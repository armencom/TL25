unit TLRegister;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, StdCtrls,
  Dialogs, Web;

var
  EvalDays: integer;
  Company, Ver, DevPW, New7DayPW: string;
  RegCodeStr, DataFileName: string;
  createDate: string;
  oneYrLocked, regCheck: boolean;
  myEncrypt: boolean;

function checkRegCode(sRegCode:string; bSilent: boolean = true): string;
function CheckTLwebsite: boolean;
procedure RegDefaults;
procedure RegistrationCheck;
procedure RegisterTL(silent: boolean);
procedure TLDisable;
procedure TLenable;
procedure AboutTL;
procedure doOneYrLockout;
procedure checkOneYrLockout;
//function subExpiredForm(): TModalResult;

implementation

uses
  Main, FuncProc, import, ReadMe, clipbrd, TLWinInet, ShellAPI, //
  trial, StrUtils, WBform, SHDocVw, TLSettings, TLFile, dateUtils, //
  splash, TLCommonLib, Registry, TLUpdate, //
  TL_API, IniFiles, GlobalVariables;

var
  setupFileSize: double;
  daysLeftInSubscr: integer;


function CheckTLwebsite: boolean;
var
  reply, s: string;
begin
  result := false;
  try
    reply := readURL('http://www.tradelog.com', 2000);
  except
    if (mDlg('Tradelog could not establish an Internet Connection!' + CR + CR
      + 'Internet features will not be available, Continue?',
      mtWarning, mbYesNo, 0) = mrYes) then
      exit
    else
      Application.MainForm.Close;
    exit;
  end;
  // ----------------------------------
  if (pos('<!--tradelog website verification-->', reply) > 0) then begin
    result := true; // 2021-04-21 MB
  end
  else begin
    if (v2UserEmail='mark@tradelogsoftware.com') //
    and SuperUser then begin
      clipboard.AsText := reply;
      sm('website tag not found');
    end;
  end;
end;


// ==================================================================
// TaxFile Version:
// 1. Can create New Files up to the TaxFile number limit in back office.
//    (1 included in subscr)
// 2. Can open/convert any existing file, unless created by different user.
// 3. Can open any file created / edited by a Pro Version user,
//    unless created by another non-Pro user.
// 4. Next Year File created by non-converted file End Tax Year
//    cannot End Tax Year - unless user purchases another TaxFile.
// 5. Can End Tax Tax Year on any previously created file.
// 6. Current subscribers can convert any files previously created.
// 7. Current subscribers can End Tax Tax Year on any file up to 2015.
//    - End Tax Year on 2016 file will require purchase of another TaxFile.
//
// Pro Version:
// 1. Can create New Files up to the TaxFile number limit in back office.
//    (1 included in subscr)
// 2. Can open/convert any existing file, unless created by different Pro user.
// 3. Can End Tax Tax Year on any previously created file up to 2015.
//    - End Tax Year on 2016 file will require purchase of another TaxFile.
// ==================================================================


procedure taxidVerCheck;
var
  pv, i: integer;
  reply, sVer, sEmailDomain: string;
  IniFile: TRegIniFile;
begin
  frmMain.stSuperUser.hide;
  frmMain.rbStatusBar.Panels[0].Visible := false;
  taxidver := true;
  // --------------
  try
    IniFile := TRegIniFile.Create(SOFTWARE);
    // TradeLog website available test
//    if not CheckTLwebsite then begin
    if gbOffline then begin
      proVer := false; // no internet, default to false
      superUser := false; // but read last known value
      // use registry settings for globals instead
      pv := IniFile.ReadInteger(TRADELOG_SETUP, 'pv', pv);
      if (pv = 2) then begin
        i := pos('@', v2UserEmail);
        sEmailDomain := lowercase(copy(v2UserEmail, i+1));
        if (sEmailDomain = 'tradelogsoftware.com')
        or (sEmailDomain = 'tradelog.com') then
          pv := 2
        else
          pv := 0; // not a true super user!
      end;
      frmMain.mErrorTest.Visible := false;
      if (pv = 1) then begin
        proVer := true;
        Settings.TLVer := 'TradeLog Pro';
        frmMain.stSuperUser.show;
        frmMain.stSuperUser.Caption := 'Pro Version';
        frmMain.rbStatusBar.Panels[0].Text := 'Pro Version';
        frmMain.rbStatusBar.Panels[0].Visible := true;
      end
      else if (pv = 2) then begin
        superUser := true;
        frmMain.mErrorTest.Visible := true; // 2020-07-15 MB - only visible for SuperUsers
        frmMain.stSuperUser.show;
        frmMain.stSuperUser.Caption := 'Super-User';
        frmMain.rbStatusBar.Panels[0].Text := 'Super-User';
        frmMain.rbStatusBar.Panels[0].Visible := true;
      end
      else begin
        if gbOffline then frmMain.stSuperUser.Caption := 'OFFLINE';
        frmMain.stSuperUser.hide;
        frmMain.rbStatusBar.Panels[0].Visible := false;
      end;
      exit; // no internet
    end;
    // ------------------------------------------
    frmMain.mErrorTest.Visible := false;
    if (ProVer = true) then begin
      pv := 1;
      Settings.TLVer := 'TradeLog Pro';
      frmMain.stSuperUser.Caption := 'Pro Version';
      frmMain.stSuperUser.show;
      frmMain.rbStatusBar.Panels[0].Text := 'Pro Version';
      frmMain.rbStatusBar.Panels[0].Visible := true;
    end
    else if (SuperUser = true) then begin
      pv := 2;
      frmMain.mErrorTest.Visible := true; // 2020-07-15 MB - only visible for SuperUsers
      frmMain.stSuperUser.Caption := 'Super-User';
      frmMain.stSuperUser.show;
      frmMain.rbStatusBar.Panels[0].Text := 'Super-User';
      frmMain.rbStatusBar.Panels[0].Visible := true;
    end
    else begin
      pv := 0; // for people who try to hack the registry!
      frmMain.stSuperUser.hide;
      frmMain.rbStatusBar.Panels[0].Visible := false;
    end;
    // save proVer (pv) to registry
    IniFile.WriteInteger(TRADELOG_SETUP, 'pv', pv);
    // --------------------------------------------
    // Just for Melina: select debug level
    if SuperUser then
      DEBUG_MODE := 3
    else
      DEBUG_MODE := 2;
    // --------------------------------------------
  finally
    IniFile.Destroy;
  end;
end;


function checkRegCode(sRegCode: string; bSilent: boolean = true): string;
var
  RegCheckStr, reply, sCust : string;
  bValidpage : boolean;
begin
  if (ProHeader.email <> '') and (sRegCode <> '') then
    sCust := v2ClientToken; // GetAuthenticate(ProHeader.email, sRegCode);
  RegCheckStr := Settings.RegistrationURL + sRegCode;
  // test code to simulate not being able to get to tradelog web site
  // RegCheckStr := 'http://www.crappywebcrap.net';
  // test regcode in backoffice
  if bSilent then begin
    try
      reply := readURL(RegCheckStr, 2000);
    except
      if (mDlg('Tradelog could not establish an Internet Connection!' + CR + CR
        + 'Internet features will not be available, Continue?',
        mtWarning, mbYesNo, 0) = mrYes) then
        exit
      else
        Application.MainForm.Close;
    end;
  end
  else
    reply := readURL(RegCheckStr);
  // end if
  // clipboard.asText := reply;
  // sm(RegCheckStr +cr +cr +reply);
  if (pos('<script', reply) > 0) then begin
    while (pos(CR, reply) > 0) do delete(reply, pos(CR, reply), 1);
    while (pos(LF, reply) > 0) do delete(reply, pos(LF, reply), 1);
  end;
  // check for valid page
  if (pos('Action canceled', reply) > 0)
  or (pos('Cannot find server', reply) > 0)
  or (pos('no page to display', reply) > 0)
  or (reply = '') then begin
    mDlg('Reg Code Verification Failed.' + CR + CR + 'Cound not connect to '
      + Settings.TradeLogUrl + CR + CR
      + 'This may clear itself, and should not affect your use of TradeLog.'
      + CR, mtWarning, [mbOk], 1);
    bValidpage := false;
    result := '';
  end
  else begin
    bValidpage := true;
    result := reply;
  end;
  // sm(reply);
end;


procedure ConvertAPIdates;
var
  S : String;
begin
  try
    // -- Start Date --------
    if (s2StartDate = '') then begin
      if v2StartDate > 0 then
        s2StartDate := DateToStr(v2StartDate)
    end
    else
      v2StartDate := xStrToDate(s2StartDate);
    // -- End Date ----------
    if (s2EndDate = '') then begin
      if v2EndDate > 0 then
        s2EndDate := DateToStr(v2EndDate)
    end
    else
      v2EndDate := xStrToDate(s2EndDate);
    // -- Cancel Date -------
    if (s2CancelDate = '') then begin
      if v2CancelDate > 0 then
        s2CancelDate := DateToStr(v2CancelDate)
    end
    else
      v2CancelDate := xStrToDate(s2CancelDate);
    // -- Create Date -------
    if (s2CreateDate = '') then begin
      if v2CreateDate > 0 then
        s2CreateDate := DateToStr(v2CreateDate)
    end
    else
      v2CreateDate := xStrToDate(s2CreateDate);
  except
    on E : Exception do begin
      sm('ERROR converting date' + CRLF //
        + E.ClassName + ': ' + E.Message);
    end;
  end;
end;

// -----------------------------------+
// Defaults are:
// - Free Trial mode
// - zero FileKeys
// -----------------------------------+
procedure RegDefaults;
var
  Tutorial: boolean;
begin
  // -- for automated updates ---------
  createDate := gsInstallDate;
  ConvertAPIdates;
  Ver := gsInstallVer;
  myEncrypt := false;
  setupFileSize := 43000000;
  Company := 'Cogenta Computing Ltd.';
  // used to enable/disable Tutorial also
end;


//function subExpiredForm(): TModalResult;
//begin
//  try
//    frmSubExpired := TfrmSubExpired.Create(frmMain);
//    with frmSubExpired do begin
//      lblRegCode.Caption := Settings.RegCode;
//      lblRegName.Caption := Settings.RegName;
//      lblExpDate.Caption := Settings.DateExpired;
//      msg1.Caption := 'Therefore, you will  have limted functionality such as opening and viewing existing data files.';
//      msg2.Caption := 'If you have already renewed your subscription you need to '
//        + 'click on the REGISTER button below and enter the new Reg Code '
//        + 'you received on your invoice when you renewed.';
//      msg3.Caption := 'If you have not yet renewed, please click  the RENEW NOW button '
//        + 'below to go to our online renewal page.';
//      msg4.Caption := 'To continue without renewing, '
//        + 'click the RENEW LATER button below.';
//    end;
//    result := frmSubExpired.ShowModal;
//  finally
//    frmSubExpired.Free;
//  end;
//end;


procedure statRecLimit(recLimit: string);
begin
  with frmMain.stRecsLimit do begin
    if length(recLimit) = 0 then begin
      Caption := 'UNLIMITED' + ' - v' + Ver + ' - ' + createDate;
      hint := 'Current subscription record limit';
      cursor := crDefault;
      frmMain.rbStatusBar.Panels[1].Text := 'UNLIMITED' + ' - v' + Ver + ' - ' + createDate;
    end
    else begin
      Caption := 'Record Limit: ' + recLimit + ' - v' + Ver + ' - ' + createDate;
      hint := 'Click to upgrade to a higher record limit';
      cursor := crDefault; // 2021-06-25 MB - changed from crHandPoint;
    end;
  end;
  frmMain.rbStatusBar.Panels[1].text := frmMain.stRecsLimit.caption;
end;


// --------------------------
// Is TradeLog registered?
// --------------------------
procedure RegistrationCheck;
begin
  TLDisable;
  if not bCancelLogin then begin
    statBar('Verifying User Reg Code');
    screen.cursor := crHourglass;
    if (now <= v2CancelDate) then // cancelled
      RegisterTL(false) // NOT silent
    else if (v2Subscription = '') then // no active subscription
      RegisterTL(false) // NOT silent
    else if (v2EndDate >= now) then // good subscription
      RegisterTL(false) // NOT silent
    else
      RegisterTL(true); // silent
    TLenable;
  end;
  getDataFileName;
  frmMain.caption := Settings.TLVer + ' - ' + DataFileName;
  statRecLimit(Settings.recLimit);
end;


// ------------------------------------
// Version 20 will check new server 1st,
// then 'fail-over' to old server.
// ------------------------------------
procedure RegisterTL(silent: boolean);
var
  RegCheckStr, reply, myTxt, newRegcode, YMDD, sMo, sDa, sYr: String;
  myOK, regLenOK: boolean;
  DateInstalled: String;
  ValidPage: boolean;
  RegName, sCust : String;
  ExpFrmResult: TModalResult;
  Reg: TRegistry;
begin
  RegCodeStr := Settings.RegCode;
  newRegcode := '';
//  Settings.MTMVersion := false;
  msgTxt := '';
  // --------------------
  if (v2Subscription = '') then begin
    Settings.TLVer := 'TradeLog FREE Trial';
    Settings.MTMVersion := true;
    RegCodeStr := '';
    Settings.RegCode := '';
    Settings.DispQS := true;
  end; // if not myOK
  msgTxt := '';
  regCheck := true;
  RegCodeStr := trim(RegCodeStr);
  // ----------------------
  // get today code
  YMDD := dateToStr(now(), Settings.InternalFmt);
  sMo := leftStr(YMDD, 2);
  if sMo > '09' then
    sMo := char(strToInt(sMo) + 55)
  else
    sMo := rightStr(sMo, 1);
  sDa := copy(YMDD, 4, 2);
  sYr := rightStr(YMDD, 2);
  if sYr > '09' then sYr := char(strToInt(sYr) + 55);
  YMDD := sYr + sMo + sDa;
  // If Free Trial has expired, let user know
  // he can ask for an extension, enter atr.
  // --------------------------------
  // make sure that existing registered users cannot use free trial
  if ((length(v2Subscription) = 0) //
  and (RegCodeStr = 'atr' + YMDD)) then begin
    if (RegCodeStr = 'atr' + YMDD) //
    or (Settings.DateInstalled = '01/01/1900') then
      Settings.DateInstalled := dateToStr(now(), Settings.InternalFmt);
    // -
    Settings.TLVer := 'TradeLog FREE Trial';
    RegCodeStr := '';
    Settings.RegCode := '';
//    Settings.DispQS := true;
//    panelQS.show;
  end //
  else if (length(RegCodeStr) = 24) then begin
    if (Settings.UserEmail = '') //
    and (ProHeader.email = '') //
    and (RegCodeStr <> '') then begin
      Settings.UserEmail := settings.UserEMail;
      if (Settings.UserEmail <> '') then
        sCust := v2ClientToken; // GetAuthenticate(Settings.UserEmail, RegCodeStr); // TLPlaid
    end;
  end;
  // ------------------------
  taxidVerCheck;
  // ------------------------
  // offer to visit purchase page if Free Trial
  if myOK and ValidPage and not silent then AboutTL;
  getDataFileName;
  frmMain.Caption := Settings.TLVer + ' - ' + DataFileName;
  checkOneYrLockout;
  statRecLimit(Settings.recLimit);
  panelSplash.SetupForm;
  // Disabled the tools that are not allowed if a file is not open.
  if frmMain.cxGrid1.Visible = false then disableMenuTools;
  if TLstart then // only after initial app startup
    Settings.SaveSettings;
  regCheck := false;
  frmMain.mtSuperUser.Visible := SuperUser; // 2021-07-07 MB
end;


procedure TLDisable;
var
  i: integer;
begin
  with frmMain do begin
    For i := 0 to MainMenu.Items.Count - 1 do begin
      MainMenu.Items[i].Enabled := false;
    end;
    with toolbar1 do begin
      for i := 0 to controlcount - 1 do begin
        Controls[i].Enabled := false;
      end;
    end;
    panelSplash.DisableControls;
    cxGrid1.Enabled := false;
    EnableMenuItem(GetSystemMenu(frmMain.Handle, false), SC_CLOSE,
      MF_BYCOMMAND or MF_GRAYED);
    if panelSplash.Visible then begin
      frmMain.Register1.Enabled := true;
      frmMain.Update1.Enabled := true;
    end;
  end;
end;


procedure TLenable;
var
  i: integer;
begin
  with frmMain do begin
    For i := 0 to MainMenu.Items.Count - 1 do begin
      MainMenu.Items[i].Enabled := true;
    end;
    with toolbar1 do begin
      for i := 0 to controlcount - 1 do begin
        Controls[i].Enabled := true;
      end;
    end;
    toolbar1.Visible := false; // 2021-06-07 MB - do not show!
    ToolBarHelp.Visible := false; // same
    cxGrid1.Enabled := true;
    if not panelSplash.Visible then begin
      frmMain.Register1.Enabled := false;
      frmMain.Update1.Enabled := false;
    end;
    { Finally setup disabled controls for Trial Version }
    btnCopy.Enabled := Not Settings.TrialVersion;
    cut.Enabled := Not Settings.TrialVersion;
    copy1.Enabled := Not Settings.TrialVersion;
    EnableMenuItem(GetSystemMenu(frmMain.Handle, false), SC_CLOSE,
      MF_BYCOMMAND or MF_ENABLED);
  end;
  panelSplash.EnableControls;
  screen.cursor := crDefault; // MB to make sure TL doesn't freeze!
end;


procedure AboutTL;
var
  txtFileName, txtStr, regStr, limitStr, expDate, expireStr: string;
  txtFile: textFile;
begin
  frmReadMe := TfrmReadMe.Create(frmMain);
  frmMain.cxGrid1.Enabled := true;
  with frmReadMe do begin
    Caption := 'About';
    btnReadMe.Visible := false;
    txtFileName := Settings.InstallDir + '\LicTradeLog.txt';
    if not fileExists(txtFileName) then
      txtFileName := Settings.InstallDir + '\LicTra~1.txt';
    if fileExists(txtFileName) then begin
      with richNewfeatures do begin
        AssignFile(txtFile, txtFileName);
        reset(txtFile);
        lines.Clear;
        msgTxt := '';
        while not Eof(txtFile) do begin
          ReadLn(txtFile, txtStr);
          lines.add(txtStr);
        end;
        CloseFile(txtFile);
        selStart := 0;
      end;
    end;
    delete(limitStr, 1, pos('-', limitStr) - 2);
    regStr := copy(regStr, 1, pos('-', regStr) - 1);
    if regStr <> '' then regStr := regStr;
    txtProd.Caption := Settings.TLVer; // +limitStr;
    txtVer.Caption := 'ver ' + Ver + gsBeta;
    txtDate.Caption := createDate;
    txtCR.Caption := 'Copyright© ' + intToStr(yearOf(now)) //
      + ' | Cogenta Computing, Inc. | All Rights Reserved';
    txtCR.Alignment := taCenter;
    if Settings.TrialVersion then begin
      txtSuptExp.Caption := limitStr;
      txtProd.Caption := 'TradeLog Trial version';
    end;
    // hide special RegCodes, show normal ones
    if not SuperUser //
    and (pos('-9898-9898-9898-98', Settings.RegCode) = 0) //
    and (pos('-2121-2121-5454-98', Settings.RegCode) = 0) //
    then
      txtReg.Caption := Settings.RegCode
    else
      txtReg.Caption := 'XXXX-XXXX-XXXX-XXXX-XXXX';
    try
      expDate := Settings.DateExpired;
    except
      expDate := '';
    end;
    // 2014-07-28
    // if not Settings.TrialVersion then
    begin
      expireStr := 'expires';
      if (v2CancelDate <> 0) and (now >= v2CancelDate) then
        expireStr := 'cancelled'
      else if (v2EndDate < now) then
        expireStr := 'expired';
      expDate := dateToStr(xStrToDate(Settings.DateExpired, Settings.InternalFmt), Settings.UserFmt);
      txtSuptExp.Caption := 'Your subscription ' + expireStr + ' on: ' + expDate;
    end;
    if ShowModal = mrCancel then begin
      Close;
      release;
    end;
  end;
end;


procedure doOneYrLockout;
begin
  with frmMain do begin // subscription expired
    bbFile_New.Enabled := false;
    // combine1.Enabled := false;
    bbFile_EndTaxYear.Enabled := false;
    btnCheckList.Enabled := false;
    bbFile_ReverseEndYear.Enabled := false;
    btnImport.Enabled := false; //
    btnAddRec.Enabled := false; // user can't add new records
    btnInsRec.Enabled := false; // (ditto)
    btnDelRec.Enabled := false; // why can't user delete though?
    bbUndo_small.Enabled := false;
    bbUndo_large.Enabled := false; // on Edit menu; redundant
    bbRedo_small.Enabled := false;
    bbRedo_large.Enabled := false; // on Edit menu; redundant
  end;
end;


procedure checkOneYrLockout;
var
  expDate, testDate: TDate;
  s : string;
begin
  oneYrLocked := false;
  // -- expDate for Trial, paid sub -------------
  if Settings.TrialVersion then begin
    expDate := v2CreateDate + 30;
    s := 'expDate based on API create date = ' + s2CreateDate;
    if gbOffline then s := s + CRLF + ' from registry (offline)';
  end
  else begin
    expDate := v2EndDate;
    s := 'expDate based on API end date = ' + s2EndDate;
    if gbOffline then s := s + CRLF //
      + ' from registry (offline) = ' + Settings.DateExpired;
  end;
  // -- calculate daysLeftInSubscr --------------
  if ((v2CancelDate > 0) and (v2CancelDate < v2EndDate)) then
    daysLeftInSubscr := trunc(v2CancelDate - now + 1)
  else begin
    daysLeftInSubscr := trunc(expDate - now + 1);
//    if Developer then begin
//      testDate := now;
//      s := s + CRLF //
//        + 'expDate = ' + datetostr(expDate) + CRLF //
//        + 'now = ' + datetostr(testDate) + CRLF //
//        + 'daysLeftInSubscr = ' + inttostr(daysLeftInSubscr);
//      clipboard.AsText := s;
//      sm('dates: ' + CRLF + s);
//    end;
  end;
  // ---
  frmMain.stRegDaysLeft.Caption := 'Days left in subscr: ' + intToStr(daysLeftInSubscr);
  frmMain.stRegDaysLeft.font.color := clBlack;
  frmMain.rbStatusBar.Panels[6].Text := 'Days left in subscr: ' + intToStr(daysLeftInSubscr);
  frmMain.rbStatusBar.Panels[6].PanelStyle.Font.color := clBlack;
  // --- 30-day warning! ---
  if daysLeftInSubscr < 31 then begin
    frmMain.stRegDaysLeft.cursor := crDefault; // 2021-06-25 MB - changed from crHandPoint;
    frmMain.stRegDaysLeft.hint := 'Click here to Renew your TradeLog Subscription';
    if Settings.TrialVersion then begin // FREE TRIAL
      frmMain.stRegDaysLeft.Caption := 'Days Left in Trial: '
        + intToStr(daysLeftInSubscr);
      frmMain.rbStatusBar.Panels[6].Text := 'Days Left in Trial: '
        + intToStr(daysLeftInSubscr);
    end
    else begin
      frmMain.stRegDaysLeft.Caption := 'Days Left in Subscr: '
        + intToStr(daysLeftInSubscr);
      frmMain.rbStatusBar.Panels[6].Text := 'Days Left in Subscr: '
        + intToStr(daysLeftInSubscr);
    end;
    frmMain.stRegDaysLeft.FillColor := tlYellow;
    frmMain.rbStatusBar.Panels[6]
  end
  else begin
    frmMain.stRegDaysLeft.FillColor := clBtnFace;
    frmMain.stRegDaysLeft.font.Style := [];
    frmMain.stRegDaysLeft.hint := 'Days left in one-year subscription';
    frmMain.stRegDaysLeft.cursor := crDefault;
  end;
  // --- not expired yet? ---
  if (daysLeftInSubscr < 0) then begin
    // --- already expired! ---
    with frmMain do begin
      stRegDaysLeft.cursor := crDefault; // 2021-06-25 MB - changed from crHandPoint;
      if Settings.TrialVersion then begin // FREE TRIAL expired
        stRegDaysLeft.caption := 'TRIAL EXPIRED!';
        stRegDaysLeft.hint := 'Click here to Purchase a TradeLog Subscription';
        frmMain.rbStatusBar.Panels[6].Text := 'TRIAL EXPIRED!';
      end
      else begin
        stRegDaysLeft.caption := 'SUBSCRIPTION EXPIRED!';
        stRegDaysLeft.hint := 'Click here to Purchase/Renew your TradeLog Subscription';
        frmMain.rbStatusBar.Panels[6].Text := 'SUBSCRIPTION EXPIRED!';
      end;
      stRegDaysLeft.FillColor := clRed;
      stRegDaysLeft.font.color := clWhite;
      statusBar.Visible := false;
      statusBar.top := frmMain.Height;
      statusBar.Visible := true;
      oneYrLocked := true;
      doOneYrLockout;
    end; // with frmMain
  end; // subscription expired
end;


end.
