unit WebGet;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OleCtrls, SHDocVw, StdCtrls, extctrls, ComCtrls, cxRadioGroup,
  cxControls, cxContainer, cxEdit, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, dxCore,
  cxDateUtils, RzButton, RzRadChk, Vcl.ExtDlgs, dxSkinsCore, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue;

const
  WM_ThreadDoneMsg = WM_User + 8;

type
  TfrmWebGet = class(TForm)
    Panel1: TPanel;
    lblPW: TLabel;
    lblUN: TLabel;
    btnCancel: TButton;
    txtUsername: TEdit;
    btnOK: TButton;
    txtPassword: TEdit;
    TimerBrokerConnect: TTimer;
    Timer1: TTimer;
    pnlProgr: TPanel;
    ProgressBar1: TProgressBar;
    Panel2: TPanel;
    lblAcct: TLabel;
    txtAcct: TEdit;
    Label3: TLabel;
    cxFrom: TcxDateEdit;
    Label4: TLabel;
    cxTo: TcxDateEdit;
    rbMo: TcxRadioButton;
    rbMax: TcxRadioButton;
    cbWebLogin: TRzCheckBox;
    OpenTextFileDialog1: TOpenTextFileDialog;
    procedure cxToPropertiesChange(Sender: TObject);
    procedure cxFromPropertiesChange(Sender: TObject);
    procedure rbMoClick(Sender: TObject);
    procedure rbMaxClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure TimerBrokerConnectTimer(Sender: TObject);
    procedure timer1Timer(Sender: TObject);
    procedure pnlProgrClick(Sender: TObject);
    procedure cbWebLoginClick(Sender: TObject);
    procedure lblPWMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnOKMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
  public
  end;

var
  fformGet: TfrmWebget;
  webgetData, myURL : string;
  webgetTimedOut,
//  crippled,
  csvFileDL, OFXUsed : Boolean;

function parseHTML(s,f,t:string):string;
function formGet: TfrmWebget;
procedure saveImportAsFile(s,dateStart,dateEnd:string;Fmt:TFormatSettings);
function assignImpBackupFilename(dateStart,dateEnd:string;Fmt:TFormatSettings):string;


implementation

uses
  Main, funcProc, RecordClasses, import, frmOFX, msHTML, clipbrd, web, //
  baseline1, globalVariables, //
  dateUtils, TLregister, StrUtils, TLSettings, TLCommonLib, TLFile, TLWinInet, //
  webImport, importCSV, Winapi.WinInet;

{$R *.DFM}

var
  CurDispatch: IDispatch;
  apiID:string;   // used for optionsXpress API
  impBL, impBL2: boolean;


         // ---------------------------
         // General-purpose routines
         // ---------------------------

function LastDayofMon(d:Tdate):TDate;
begin
   result := EncodeDate(YearOf(d),MonthOf(d), DaysInMonth(d)) ;
end;


function inc3Months(sd:Tdate):Tdate;
begin
  try // fix for integer overflow error when last date imported 10/31 or greater
    result:= LastDayofMon(incMonth(sd,2));
  except
  end;
end;


function StripHTML(S: string): string;
var
  i,x, TagBegin, TagEnd, TagLength: integer;
  noLF:boolean;
begin
  noLF:= false;
  // check if s has no LF characters
  if (pos(#10+' ',s)=0)
  or (pos('p><p',s)>0)
  then begin
    noLF:= true;
    // add crlf to each table row <tr>
    x:= length(s);
    for i:= 1 to x do begin
      if (copy(s,i,6)='</tr> ')
      or (copy(s,i,6)='</tr><')
      then insert(#13+#10,s,i+5);
    end;
    // add crlf to each para <p>
    x:= length(s);
    for i:= 1 to x do begin
      if (copy(s,i,5)='</p> ')
      or (copy(s,i,5)='</p><')
      then insert(#13+#10,s,i+4);
    end;
    s:= AdjustLineBreaks(s);
    // add spaces to end of data fields
    i:=1;
    x:= length(s);
    while i<x do begin
      if copy(s,i,1)='<' then begin
        insert(' ',s,i);
        inc(i);
      end;
      inc(i);
    end;
  end;
  TagBegin := Pos( '<', S);      // search position of first <
  while (TagBegin > 0) do begin  // while there is a < in S
    TagEnd := Pos('>', S);              // find the matching >
    TagLength := TagEnd - TagBegin + 1;
    Delete(S, TagBegin, TagLength);     // delete the tag
    TagBegin:= Pos( '<', S);            // search for next <
  end;
  // delete all double-spaces
  if noLF then begin
    while pos('  ',s)>0 do
      delete(s,pos('  ',s),1);
  end;
  if (noLF=false) then begin
    // replace lf-space-lf with tab
    while pos(#10+' '+#10,s)>0 do begin
      insert(#9,s,pos(#10+' '+#10,s));
      delete(s,pos(#10+' '+#10,s),3);
    end;
    // delete all cr marks
    while pos(#10,s)>0 do begin
      delete(s,pos(#10,s),1);
    end;
    //replace tabs with crlf
    while pos(#9,s)>0 do begin
      insert(#13+#10,s,pos(#9,s));
      delete(s,pos(#9,s),1);
    end;
  end;
  Result := S;
end;


function assignImpBackupFilename(dateStart, dateEnd :string; Fmt : TFormatSettings):string;
var
  f, ext, localFileName : string;
begin
  ext := TradeLogFile.CurrentAccount.ImportFilter.ImportFileExtension;
  // make sure dates are mm/dd/yyyy format
  if dateStart <> '' then
    dateStart := dateToStr(xStrToDate(dateStart, Fmt), Settings.InternalFmt);
  if dateEnd <> '' then
    dateEnd := dateToStr(xStrToDate(dateEnd, Fmt), Settings.InternalFmt);
  f := TradeLogFile.CurrentAccount.FileImportFormat;
  Delete(f, pos('*', f), 1);
  Delete(f, pos(',', f), 1);
  try
    if (dateStart <> '') and (dateEnd = '') then
      localFileName := Settings.ImportDir + '\' + f + '_' + dateStart + ext
    else if (dateStart <> '') then
      localFileName := Settings.ImportDir + '\' + f + '_' //
        + YYYYMMDD_ex(dateStart, Settings.InternalFmt) + '_' //
        + YYYYMMDD_ex(dateEnd, Settings.InternalFmt) + ext
    else
      localFileName := Settings.ImportDir + '\' + f + ext;
  finally
    result := localFileName;
  end;
end;


procedure saveImportAsFile(s, dateStart, dateEnd : string; Fmt: TFormatSettings);
var
  localFileName:string;
  localFile:textFile;
begin
  // get a unique name for the import backup file
  localFileName:= assignImpBackupFilename(dateStart,dateEnd,Fmt);
  AssignFile(localFile,localFileName);
  try
    Rewrite(localFile);
    write(localFile,s);
  finally
    CloseFile(localFile);
  end;
end;


procedure TfrmWebGet.TimerBrokerConnectTimer(Sender: TObject);
begin
  TimerBrokerConnect.enabled:= false;
  if (TradeLogFile.CurrentAccount.FileImportFormat='tradeMONSTER')
  or (TradeLogFile.CurrentAccount.FileImportFormat='optionsXpress')
  then exit;
  try
    frmWeb.close;
  except
    //
  end;
  webGetTimedOut:=true;
  cancelURL:= true;
end;


procedure TfrmWebGet.btnCancelClick(Sender: TObject);
begin
  hide;
  TimerBrokerConnect.enabled:= false;
  webGetData:='cancel';
  cancelURL:= true;
  close;
end;


function parseHTML(s,f,t:string):string;
begin
  delete(s,1,pos(f,s)+length(f)-1);
  result:= copy(s,1,pos(t,s)-1);
end;


// ----------------------------------------------
function reformatTick(tk,exMoYr:string):string;
var
  i,c,p:integer;
  cp,str:string;
begin
  tk:= trim(tk);
  // test location of parenthesis
  if rightStr(tk,1)=')' then begin
    // GLD JAN  84 Put (.GLDMF)
    // parenthesis at end - delete chars in parenthesis
    p:= pos('(',tk);
    if p>0 then begin
      delete(tk,p,length(tk)-p+1);
      tk:= trim(tk);
    end;
  end else
  if pos('(',tk)>0 then begin
    // OIH (OAU) Apr10 100 Put
    // parenthesis is in the middle
    p:= pos('(',tk);
    if p>0 then begin
      // delete chars in parenthesis
      c:= pos(')',tk);
      for i:= p to c do begin
        delete(tk,i,1);
      end;
      tk:= trim(tk);
    end;
  end;
  cp:= parseLast(tk,' ');
  str:=parseLast(tk,' ');
  tk:= copy(tk,1,pos(' ',tk))+exMoYr+' '+str+' '+cp;
  result:= uppercase(tk);
end;


function formGet: TfrmWebget;
begin
  if (fformGet=nil) then
    fformGet:= TfrmWebget.create(frmMain);
  result:= fformGet;
end;


         // ---------------------------
         //         Form Events
         // ---------------------------

procedure TfrmWebGet.FormShow(Sender: TObject);
var
  t, d : string;
  maxOFX : integer;
begin
  impBL := false;
  impBL2 := false;
  cbWebLogin.enabled := TradeLogFile.CurrentAccount.ImportFilter.OFXConnect;
  cbWebLogin.Checked := not TradeLogFile.CurrentAccount.ImportFilter.OFXConnect;
  cbWebLogin.Visible := TradeLogFile.CurrentAccount.ImportFilter.OFXConnect;
  // ------------------------
  t := intToStr(Settings.BCTimeout);
  if t = '0' then t := '240000';
  t := '  Timeout = ' + copy(t, 1, length(t)- 3)+ ' sec';
  pnlProgr.caption := t;
  txtAcct.Visible := false;
  lblAcct.Visible := false;
  width := 400;
  height := height - clientHeight + Panel1.height + Panel2.height + pnlProgr.height;
  // --- get startDate and endDate ----
  dtBegTaxYr := xStrToDate('01/01/' + TaxYear, Settings.InternalFmt);
  if TradeLogFile.Count = 0 then begin
    cxFrom.date := dtBegTaxYr;
  end
  else begin
    frmMain.enabled := true;
    clearFilter;
    frmMain.enabled := false;
    if TradeLogFile.LastDateImported + 1 < dtBegTaxYr then
      cxFrom.date := dtBegTaxYr
    else
      cxFrom.date := TradeLogFile.LastDateImported + 1;
  end;
  // do not import past OCT 16 of next tax year (former limit was 01/31)
  if cxTo.date > xStrToDate('10/16/' +NextTaxYear, Settings.InternalFmt)
  then
    cxTo.date := xStrToDate('10/16/' +NextTaxYear, Settings.InternalFmt)
  else
    cxTo.date := dateOf(date - 1); // or not past yesterday
  // fix for legacy ETrade
  if (TradeLogFile.CurrentAccount.FileImportFormat = 'Etrade') //
  or (TradeLogFile.CurrentAccount.FileImportFormat = 'ETrade') then
    TradeLogFile.CurrentAccount.FileImportFormat := 'E-Trade';
  // some brokers do not like importing multiple months across two years
  if TradeLogFile.CurrentAccount.FileImportFormat = 'TDAmeritrade' then begin
    txtAcct.Visible := true;
    lblAcct.Visible := true;
    if cxFrom.date < xStrToDate('12/31/' + taxyear, Settings.InternalFmt)-30 then
      cxTo.date := xStrToDate('12/31/' + taxyear, Settings.InternalFmt);
  end
  else if TradeLogFile.CurrentAccount.FileImportFormat = 'TOS' then begin
    txtAcct.Visible := true;
    lblAcct.Visible := true;
    if cxFrom.date < xStrToDate('12/31/' + taxyear, Settings.InternalFmt)-30 then
      cxTo.date := xStrToDate('12/31/' + taxyear, Settings.InternalFmt);
  end
  // ********************************************
  else if (TradeLogFile.CurrentAccount.FileImportFormat = 'E-Trade') then begin
    lblAcct.Visible := true;
    txtAcct.Visible := true;
    if cxFrom.date < xStrToDate('12/31/' + taxyear, Settings.InternalFmt)-30 then
      cxTo.date := xStrToDate('12/31/' + taxyear, Settings.InternalFmt);
    // no longer need to limit to 3 months
  end
  // ********************************************
  else if TradeLogFile.CurrentAccount.FileImportFormat = 'Fidelity' then begin
    txtAcct.Visible := true;
    lblAcct.Visible := true;
    rbMax.caption := '90 Days';
    if (cxTo.date > cxFrom.date + 90) then
      cxTo.date := dateOf(cxFrom.date + 90);
  end
  // ********************************************
  else if TradeLogFile.CurrentAccount.FileImportFormat = 'IB' then begin
    lblUN.caption := 'Token: ';
    lblPW.caption := 'Query ID: ';
  end
  else if TradeLogFile.CurrentAccount.FileImportFormat = 'Lightspeed' then begin
    apiID := 'ACTLOG';
    txtAcct.Visible := true;
    lblAcct.Visible := true;
  end
//  else if TradeLogFile.CurrentAccount.FileImportFormat = 'optionsXpress' then begin
//    caption := 'optionsXpress BrokerConnect';
//    apiID := 'ACTLOG';
//  end
  else if TradeLogFile.CurrentAccount.FileImportFormat = 'Scottrade' then begin
    lblUN.caption := 'Account #:';
    apiID := 'ACTLOG';
  end
  else if TradeLogFile.CurrentAccount.FileImportFormat = 'Charles Schwab' then begin
    txtAcct.Visible := true;
    lblAcct.Visible := true;
    cbWebLogin.enabled := false;
    apiID := 'ACTLOG';
  end
  else if TradeLogFile.CurrentAccount.FileImportFormat = 'optionsHouse' then begin
    txtAcct.Visible := true;
    lblAcct.Visible := true;
    apiID := 'ACTLOG';
  end
  else if TradeLogFile.CurrentAccount.FileImportFormat = 'tradeMONSTER' then begin
    txtAcct.Visible := true;
    lblAcct.Visible := true;
    apiID := 'ACTLOG';
  end
  // ********************************************
  else if TradeLogFile.CurrentAccount.FileImportFormat = 'TradeStation' then begin
    txtAcct.Visible := true;
    lblAcct.Visible := true;
    rbMax.caption := '3 Months';
    if (cxFrom.date + 90 <= xStrToDate('01/31/' + NextTaxYear, Settings.InternalFmt)) then
      cxTo.date := inc3Months(cxFrom.date);
  end
  // ********************************************
  else if TradeLogFile.CurrentAccount.FileImportFormat = 'Vanguard' then begin
    lblAcct.Visible := true;
    txtAcct.Visible := true;
    apiID := 'ACTLOG';
    cbWebLogin.Visible := false;
    rbMax.caption := '3 Months';
    cxTo.date := inc3Months(cxFrom.date);
  end;
  // --------------------------------------------
  // make sure from to dates are not greater than yesterday
  if cxFrom.date >= now()- 1 then begin
    cxFrom.date := dateOf(now()- 1);
    if (TradeLogFile.CurrentAccount.FileImportFormat = 'TradeStation')
    or (TradeLogFile.CurrentAccount.FileImportFormat = 'IB') then begin
      // set start date to Mon thru Fri
      if dayOfWeek(cxFrom.date)= 1 then
        cxFrom.date := cxFrom.date + 1 // change Sun to Mon
      else if dayOfWeek(cxFrom.date)= 7 then
        cxFrom.date := dateOf(cxFrom.date + 2); // change Sat to Mon
    end;
  end;
  if cxTo.date >= now()- 1 then begin
    cxTo.date := dateOf(now()- 1);
  end;
  // do not import OFX if cxFrom is less than OFXMonths
  maxOFX := TradeLogFile.CurrentAccount.ImportFilter.OFXMonths;
  if (Settings.LegacyBC) and (maxOFX > 0) //
  and TradeLogFile.CurrentAccount.ImportFilter.OFXConnect //
  and (now - maxOFX * 30 > cxFrom.date) then begin
    cbWebLogin.enabled := false;
    cbWebLogin.Checked := true;
    cbWebLogin.Visible := true;
  end;
  if TradeLogFile.CurrentAccount.FileImportFormat = 'optionsHouse' then
    caption := 'TradeMONSTER BrokerConnect'
  else
    caption := TradeLogFile.CurrentAccount.FileImportFormat + ' BrokerConnect';
  frmMain.enabled := false;
  txtUsername.text := TradeLogFile.CurrentAccount.OFXUserName;
  txtPassword.text := TradeLogFile.CurrentAccount.OFXpassword;
  txtAcct.text := TradeLogFile.CurrentAccount.OFXaccount;
  txtUsername.setfocus;
  width := btnOK.Left + btnOK.width + 30;
  // Finally set Web Connect CheckBox based on OFX capatability
  // and OFX Max Months the Date Range. Since some OFX Provide
  // have a Maximum number of months we can go backward, if the
  // dates are outside this maximum, then we will not check
  // this direct connect option
  if (TradeLogFile.CurrentAccount.ImportFilter.OFXMaxMonths > 0) then
    cbWebLogin.Checked := not(((date - cxFrom.date) / 30) <=
      TradeLogFile.CurrentAccount.ImportFilter.OFXMaxMonths);
  if impBaseline then begin
    rbMo.Checked := true;
    cxFrom.date := blFromDate;
    cxTo.date := blToDate;
    impBL := true;
  end;
  screen.Cursor := crDefault;
end;


// Control + Shift + click mouse on 'Password' label
procedure TfrmWebGet.lblPWMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (ssCtrl in Shift) and (ssShift in Shift) then begin
    clipboard.astext := TradeLogFile.CurrentAccount.OFXpassword;
    sm('Password: ' + TradeLogFile.CurrentAccount.OFXPassword);
  end;
end;


procedure TfrmWebGet.formClose(sender: TObject; var Action: TCloseAction);
begin
  Action:= caFree;
  fformGet:= nil;
  if not isFormOpen('frmWeb') then begin
    frmMain.enabled:=true;
    frmMain.setfocus;
  end;
end;

// Control + Shift + [P]
procedure TfrmWebGet.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=27 then close; // ESC
  if shift=[ssCtrl,ssShift] then
    case key of
    80: begin // Ctrl + Shift + [P]
      clipboard.astext := TradeLogFile.CurrentAccount.OFXpassword;
      sm('Password: ' + TradeLogFile.CurrentAccount.OFXpassword);
    end;
  end;
end;


// -----------
//     OK    |
// -----------
procedure TfrmWebGet.btnOKClick(Sender: TObject);
var
  dateStart, dateEnd, s, sID, randomNum, IBdate, monStr, yrStr, dateStr,
    IBrptFormat, urlStr, ETAcct, sTime, eTime, reply:string;
  Year, Month, Day: Word;
  i, z, numMonths: Integer;
  Acct: String;
  myParams: TStringList;
begin
  if impBaseline then
    blFromDate := cxFrom.date;
  if Settings.BCTimeout <> 0 then
    TimerBrokerConnect.interval := Settings.BCTimeout;
  webgetData := '';
  s := '';
  sID := '';
  randomNum := '';
  webgetTimedOut := false;
  cancelURL := false;
  // make sure timeout is never less than 1 minute
  if Settings.BCTimeout < 60000 then
    Settings.BCTimeout := 180000;
  TimerBrokerConnect.interval := Settings.BCTimeout;
  TimerBrokerConnect.enabled := true;
  if (txtUsername.text = '')
  or (txtPassword.text = '') then begin
    mDlg('Must enter a Username and Password', mtError,[mbOK], 0);
    exit;
  end;
  // if we made the Account box visible, assume it's required too.
  if (txtAcct.Visible) and (txtAcct.text = '') then begin
    mDlg('Must enter an Account Number', mtError,[mbOK], 0);
    exit;
  end;
  hide;
  btnOK.enabled := false;
  // ------------------------
  if TradeLogFile.CurrentAccount.FileImportFormat = 'TDAmeritrade' then begin
    // fix for TDA OFX not accepting caps in username
    txtUsername.text := lowercase(txtUsername.text);
    // remove dashes from account number
    Acct := txtAcct.text;
    while (pos('-', Acct) > 0) do Delete(Acct, pos('-', Acct), 1);
    txtAcct.text := Acct;
  end;
  // ------------------------
  // save login info if changed
  if (TradeLogFile.CurrentAccount.OFXUserName <> txtUsername.text)
  or (TradeLogFile.CurrentAccount.OFXpassword <> txtPassword.text)
  or (TradeLogFile.CurrentAccount.OFXaccount <> uppercase(txtAcct.text)) then begin
    TradeLogFile.CurrentAccount.OFXUserName := txtUsername.text;
    TradeLogFile.CurrentAccount.OFXpassword := txtPassword.text;
    TradeLogFile.CurrentAccount.OFXaccount := uppercase(txtAcct.text);
    TradeLogFile.SaveFile(true);
  end;
  // get startDate and endDate
  try
    dateStart := dateToStr(cxFrom.date, Settings.InternalFmt);
    // 2011-12-06 DE changed from userfmt
    dateEnd := dateToStr(cxTo.date, Settings.InternalFmt);
  except
    // do nothing
  end;
  // OFX import
  // from OFX file already downloaded
//  if not cbWebLogin.Checked or (length(OFXFile) > 0) then begin
//    OFXDateStart := cxFrom.date;
//    OFXDateEnd := cxTo.date;
//    OFX := true;
//    close;
//    exit;
//  end;
  // --------------------------------------------
  // BrokerConnect web import
  // --------------------------------------------
  //
  // ------------------- TDA (TD Ameritrade) -----------------------------
  if TradeLogFile.CurrentAccount.FileImportFormat = 'TDAmeritrade' then begin
    hide;
    close;
    // get csv using WinInet in import.pas function readAmeritrade
    OFXDateStart := cxFrom.date;
    OFXDateEnd := cxTo.date;
  end
  else if TradeLogFile.CurrentAccount.FileImportFormat = 'TOS' then begin
    hide;
    close;
    setupBrokerConnect('https://wwws.ameritrade.com/apps/LogIn', dateStart, dateEnd);
    if not cancelURL then modalresult := mrOK;
    exit;
  end
  // ------------------- E*Trade -----------------------------------------
  else if TradeLogFile.CurrentAccount.FileImportFormat = 'E-Trade' then begin
    hide;
    close;
    // make sure acct number has proper format ie: 1234-5678
    s := TradeLogFile.CurrentAccount.OFXaccount;
    if (pos('-', s)= 0)and(length(s)= 8) then
      s := leftStr(s, 4)+ '-' + rightStr(s, 4)
    else if (pos('-', s)> 0)and(pos('-', s)<> 5) then begin
      while (pos('-', s)> 0) do Delete(s, pos('-', s), 1);
      if (length(s)= 8) then s := leftStr(s, 4)+ '-' + rightStr(s, 4);
    end;
    TradeLogFile.CurrentAccount.OFXaccount := s;
    Statbar('off');
    // login via BrokerConnect web
    setupBrokerConnect('https://us.etrade.com/e/t/user/login', dateStart, dateEnd);
    if not cancelURL then modalresult := mrOK;
    exit;
  end
  // ------------------- Fidelity ----------------------------------------
  else if TradeLogFile.CurrentAccount.FileImportFormat = 'Fidelity' then begin
    // remove dash from acct number
    TradeLogFile.CurrentAccount.OFXaccount :=
      ReplaceStr(TradeLogFile.CurrentAccount.OFXaccount, '-', '');
    // download limited to last 2 years
    try
      DecodeDate(date, Year, Month, Day);
      if strToInt(rightStr(dateStart, 4))< Year - 5 then begin
        dateStart := '01/01/' + intToStr(Year - 5);
        cxFrom.date := xStrToDate(dateStart, Settings.InternalFmt);
        sm('Fidelity online trade history' + cr //
          + 'only goes back 5 years to:' + cr //
          + dateStart + cr);
        exit;
      end;
    except
    end;
    // get csv using WinInet in import.pas function readFidelity
    OFXDateStart := cxFrom.date;
    OFXDateEnd := cxTo.date;
    setupBrokerConnect('https://login.fidelity.com/ftgw/Fas/Fidelity/RtlCust/Login/Init', dateStart, dateEnd);
    if not cancelURL then modalresult := mrOK;
  end
  // ------------------- IB (Interactive Brokers) ------------------------
  else if TradeLogFile.CurrentAccount.FileImportFormat = 'IB' then begin
    hide;
    close;
    OFXDateStart := cxFrom.date;
    OFXDateEnd := cxTo.date;
    txtUsername.text := trim(txtUsername.text);
    txtPassword.text := trim(txtPassword.text);
    if (not isInt(txtUsername.text)) or (not isInt(txtPassword.text)) then begin
      mDlg('Username and Password has been changed to' + cr //
        + ' Token and Query ID. ' + cr //
        + cr //
        + 'See IB import user guide for details.' + cr//
        , mtError, [mbOK], 0);
      webURL(supportSiteURL + 'hc/en-us/articles/115004920933');
      webgetData := 'cancel';
      cancelURL := true;
      exit;
    end;
    if not cancelURL then modalresult := mrOK;
    exit;
  end
  // ------------------- Lightspeed --------------------------------------
  else if TradeLogFile.CurrentAccount.FileImportFormat = 'Lightspeed' then begin
    hide;
    close;
    // get csv using WinInet in import.pas
    OFXDateStart := cxFrom.date;
    OFXDateEnd := cxTo.date;
  end
  // ------------------- optionsXpress -----------------------------------
  else if (TradeLogFile.CurrentAccount.FileImportFormat = 'optionsXpress') then begin
    Timer1.enabled := true;
    webgetData :=
      readURL('https://oxbranch.optionsxpress.com/accountservice/account.asmx/'
        + 'GetOxSessionWithSource?'
        + 'sUserName=' + TradeLogFile.CurrentAccount.OFXUserName
        + '&' + 'sPassword='
        + TradeLogFile.CurrentAccount.OFXpassword
        + '&' + 'sSessionID=&sSource=' + apiID);
    if (webgetData = '') or (webgetData = 'cancel') then begin
      if not cancelURL then modalresult := mrOK;
      exit;
    end;
    // check for valid login
    if pos('Invalid Login', webgetData)> 0 then begin
      mDlg('Invalid Login', mtError,[mbOK], 0);
    end
    // check for server error
    else if pos('System.InvalidOperationException', webgetData)> 0 then begin
      mDlg('optionsXpress Server Error - Please tray again later', mtError,[mbOK], 0);
      webgetData := '';
    end
      // check for account enabled for XML
    else if pos('Need to enable account for XML', webgetData)> 0 then begin
      mDlg('Need to enable optionsXpress account for '
        + 'XML/Software Access in account profile.', mtWarning,[mbOK], 0);
    end
    // parse out session id
    else if pos('<SessionID>', webgetData)> 0 then begin
      sID := parseHTML(webgetData, '<SessionID>', '</SessionID>');
    end
    // login failed
    else begin
      webgetData := '';
    end;
    dateStart := US_DateStr(dateStart, Settings.InternalFmt);
    dateEnd := US_DateStr(dateEnd, Settings.InternalFmt);
    Statbar('Getting trade history data from ' + dateStart + ' to ' + dateEnd + ' - PLEASE WAIT');
    webgetData :=
      readURL('https://oxbranch.optionsxpress.com/accountservice/account.asmx/'
        + 'GetCustActivity?' + 'sSessionID=' + sID
        + '&datStartDate=' + dateStart + '&datEndDate=' + dateEnd);
    if (webgetData = '') or (webgetData = 'cancel') then begin
      if not cancelURL then modalresult := mrOK;
      exit;
    end;
    saveImportAsFile(webgetData, dateStart, dateEnd, Settings.InternalFmt);
    // no trade history data
    if pos('<CServActivity>', webgetData)= 0 then begin
      webgetData := '';
    end;
  end
  // ------------------- Charles Schwab ----------------------------------
  else if TradeLogFile.CurrentAccount.FileImportFormat = 'Charles Schwab' then begin
    // make sure acct number has proper format ie: 1234-5678
    s := TradeLogFile.CurrentAccount.OFXaccount;
    if (pos('-', s)= 0)and(length(s)= 8) then
      s := leftStr(s, 4)+ '-' + rightStr(s, 4)
    else if (pos('-', s)> 0)and(pos('-', s)<> 5) then begin
      while (pos('-', s)> 0) do Delete(s, pos('-', s), 1);
      if (length(s)= 8) then s := leftStr(s, 4)+ '-' + rightStr(s, 4);
    end;
    TradeLogFile.CurrentAccount.OFXaccount := s;
    // download limited to last 24 months
    try
      if (xStrToDate(dateStart, Settings.InternalFmt)< date - 730) then begin
        dateStart := dateToStr(date - 730, Settings.InternalFmt);
        if mDlg('Charles Schwab online trade history' + cr
          + 'only goes back 2 years to: ' + dateStart + cr + cr
          + 'Do you wish to import starting from ' + dateStart + '?'
          , mtWarning, [mbOK, mbCancel], 0)= mrOK then
        begin
          btnOK.enabled := true;
          cxFrom.date := date - 730;
          cxFrom.setfocus;
          exit;
        end
        else begin
          hide;
          close;
          exit;
        end;
      end
      else
        hide;
      close;
    except
      // do nothing
    end;
    if webgetData = '' then begin
      Statbar('off');
      setupBrokerConnect('https://client.schwab.com/Login/SignOn/CustomerCenterLogin.aspx?&&lor=n',
        dateStart, dateEnd);
    end
    else begin
      saveImportAsFile(webgetData, dateStart, dateEnd, Settings.InternalFmt);
      if not cancelURL then modalresult := mrOK;
      exit;
    end;
  end
  // ------------------- Scottrade ---------------------------------------
  else if TradeLogFile.CurrentAccount.FileImportFormat = 'Scottrade' then begin
    hide;
    close;
    setupBrokerConnect('https://trading.scottrade.com/default.aspx', dateStart, dateEnd);
    if not cancelURL then modalresult := mrOK;
    exit;
  end
  // ------------------- TradeStation ------------------------------------
  else if TradeLogFile.CurrentAccount.FileImportFormat = 'TradeStation' then
  begin
    hide;
    close;
    setupBrokerConnect('https://www.tradestation.com', dateStart, dateEnd);
    if not cancelURL then modalresult := mrOK;
    exit;
  end
  // ------------------- optionsHouse / tradeMONSTER ---------------------
  else if (TradeLogFile.CurrentAccount.FileImportFormat = 'optionsHouse')
  or (TradeLogFile.CurrentAccount.FileImportFormat = 'tradeMONSTER') then begin
    hide;
    close;
    // get csv using WinInet in import.pas function readFidelity
    OFXDateStart := cxFrom.date;
    OFXDateEnd := cxTo.date;
  end
  // ------------------- Vanguard ----------------------------------------
  else if TradeLogFile.CurrentAccount.FileImportFormat = 'Vanguard' then begin
    hide;
    close;
    // add 3 extra days to end date for unsettled trades
    if (xStrToDate(dateEnd) > EncodeDate(2024,05,28)) then
      dateEnd := dateToStr(xStrToDate(dateEnd, Settings.InternalFmt)+ 1, Settings.InternalFmt)
    else if (xStrToDate(dateEnd) > EncodeDate(2017,05,28)) then
      dateEnd := dateToStr(xStrToDate(dateEnd, Settings.InternalFmt)+ 2, Settings.InternalFmt)
    else
      dateEnd := dateToStr(xStrToDate(dateEnd, Settings.InternalFmt)+ 3, Settings.InternalFmt);
    // delete dash from account num
    Acct := TradeLogFile.CurrentAccount.OFXaccount;
    if pos('-', Acct)> 0 then Delete(Acct, pos('-', Acct), 1);
      // test to see if logged on
    webgetData := readURL('https://personal.vanguard.com/us/MyHomeExt');
    if pos('You must be logged on to continue', webgetData)= 0 then begin
      // if logged on, clear webbrowser session
      InternetSetOption(nil, INTERNET_OPTION_END_BROWSER_SESSION, nil, 0);
    end;
    setupBrokerConnect('https://investor.vanguard.com/home/', dateStart, dateEnd);
    if not cancelURL then modalresult := mrOK;
    exit;
  end;
  hide;
  close;
end;


// special Ctrl+Shift+[OK]
procedure TfrmWebGet.btnOKMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (ssCtrl in Shift) and (ssShift in Shift)
  and (TradeLogFile.CurrentAccount.ImportFilter.OFXConnect) then begin
    OpenTextFileDialog1.InitialDir := Settings.ImportDir;
    OpenTextFileDialog1.DefaultExt := 'ofx';
    OpenTextFileDialog1.Filter := 'OFX File (ofx, qfx)|*.ofx;*.qfx';
    OpenTextFileDialog1.Options := [ofFileMustExist];
    if OpenTextFileDialog1.Execute(Handle) then begin
//      OFXFile := OpenTextFileDialog1.FileName;
      btnOK.Click;
    end;
  end;
end;


procedure TfrmWebGet.Timer1Timer(Sender: TObject);
begin
  with progressBar1 do begin
    if position>=100 then
      position:= 0
    else
      stepit;
  end;
  timer1.enabled:= true;
end;


procedure TfrmWebGet.pnlProgrClick(Sender: TObject);
var
  t:string;
begin
  if not btnOk.Enabled then exit;
  with frmMain do begin
    BCtimeout1.Enabled := true;
    BCtimeout1.click;
    BCtimeout1.Enabled := false;
  end;
  t:= intToStr(Settings.BCTimeout);
  if t='0' then t:= '60000';
  t:= '  Timeout = '+copy(t,1,length(t)-3)+' sec';
  pnlProgr.caption:= t;
end;


procedure TfrmWebGet.rbMaxClick(Sender: TObject);
begin
  if rbMax.checked then begin
    // import up to yesterday
    cxTo.Date:= dateOf(date-1);
    if TradeLogFile.CurrentAccount.FileImportFormat='Fidelity' then
      cxTo.Date:= dateOf(cxFrom.Date+90)
    else if (TradeLogFile.CurrentAccount.FileImportFormat='TradeStation')
    or (TradeLogFile.CurrentAccount.FileImportFormat='E-Trade') then begin
      if cxFrom.Date < xStrToDate('11/01/'+Taxyear,Settings.InternalFmt) then
        cxTo.Date:= inc3months(cxFrom.Date)
      else
        cxTo.Date:= xStrToDate('01/31/'+nextTaxYear,Settings.InternalFmt);
    end
    else if TradeLogFile.CurrentAccount.MTM
    and (TradeLogFile.NextTaxYear <> currentYear)
    and (cxTo.Date > xStrToDate('12/31/'+Taxyear,Settings.InternalFmt)) then
      cxTo.Date := xStrToDate('12/31/'+Taxyear,Settings.InternalFmt);
  end;
end;


procedure TfrmWebGet.rbMoClick(Sender: TObject);
begin
  if rbMo.checked then begin
    if DayOf(cxFrom.Date) = 1 then
      cxTo.date:= dateOf(endOfTheMonth(cxFrom.Date))
    else
      cxTo.Date := cxFrom.Date + 30;
  end;
end;


procedure TfrmWebGet.cbWebLoginClick(Sender: TObject);
begin
  if (not cbWebLogin.Checked)
  and (TradeLogFile.CurrentAccount.ImportFilter.OFXMaxMonths > 0) then begin
    cbWebLogin.Checked := not ( ((Date - cxFrom.Date) / 30) <=  TradeLogFile.CurrentAccount.ImportFilter.OFXMaxMonths);
    if cbWebLogin.Checked then begin
      mDlg('Sorry, ' + TradeLogFile.CurrentAccount.FileImportFormat
        + ' only supports direct connect for the last '
        + IntToStr(TradeLogFile.CurrentAccount.ImportFilter.OFXMaxMonths)
        + ' months of data', mtWarning, [mbOK], 0);
    end;
  end;
end;


procedure TfrmWebGet.cxFromPropertiesChange(Sender: TObject);
var
  maxOFX : integer;
begin
  if (TradeLogFile.CurrentAccount.ImportFilter.OFXMaxMonths > 0) then
    cbWebLogin.Checked := not (((Date - cxFrom.Date) / 30) <=  TradeLogFile.CurrentAccount.ImportFilter.OFXMaxMonths);
  // do not allow importing past Jan 31
  if (TradeLogFile.NextTaxYear <> currentYear)
  and (cxFrom.Date>xStrToDate('01/31/'+nextTaxyear,Settings.InternalFmt))
  then begin
    cxFrom.Date:= TradeLogFile.LastDateImported + 1;
    sm('Cannot import trades past ' //
      + dateToStr(xStrToDate('01/31/' +nexttaxyear, Settings.InternalFmt), Settings.InternalFmt) //
      + ' in a ' + taxyear + ' data file');
    exit;
  end;
  if rbMo.checked then
    cxTo.Date:= dateOf(endOfTheMonth(cxFrom.Date))
  else if TradeLogFile.CurrentAccount.FileImportFormat='Fidelity' then begin
    if cxFrom.Date+90<=xStrToDate('01/31/'+nextTaxyear,Settings.InternalFmt) then
      cxTo.Date:= dateOf(cxFrom.Date+90);
  end;
  if TradeLogFile.CurrentAccount.FileImportFormat='TradeStation' then begin
    if cxFrom.Date<xStrToDate('11/01/'+Taxyear,Settings.InternalFmt)then
      cxTo.Date:= inc3months(cxFrom.Date)
    else
      cxTo.Date:= xStrToDate('01/31/'+nextTaxYear,Settings.InternalFmt);
  end;
  if cxTo.date>now() then cxTo.date:= dateOf(now()-1);
  // do not import OFX if cxFrom is less than OFXMonths
  maxOFX := TradeLogFile.CurrentAccount.ImportFilter.OFXMonths;
  if (Settings.LegacyBC) and (maxOFX > 0) //
  and TradeLogFile.CurrentAccount.ImportFilter.OFXConnect //
  and (now - maxOFX * 30 > cxFrom.date) //
  and (TradeLogFile.CurrentAccount.ImportFilter.FilterName <> 'Fidelity')
  then begin
    cbWebLogin.Enabled := false;
    cbWebLogin.Checked := true;
    cbWebLogin.Visible := true;
  end;
  if impBaseline and ImpBL2 then begin
    blFromDate:= cxFrom.Date;
    cxTo.Date:= blToDate;
  end;
  if impBaseline then begin
    impBL2:= true;
  end;
end;


procedure TfrmWebGet.cxToPropertiesChange(Sender: TObject);
begin
  if impBaseline and impBL and (cxTo.Date <> blToDate) then begin
    cxTo.Date := blToDate;
    exit;
  end;
  if cbWebLogin.Checked then begin //<-- IMPORTANT!
    // limit imports to 12 months at a time
    if (TradeLogFile.CurrentAccount.FileImportFormat='TDAmeritrade') then begin
      if  (cxTo.Date > xStrToDate('12/31/'+taxyear,Settings.InternalFmt))
      and (cxFrom.Date < xStrToDate('02/01/'+taxyear,Settings.InternalFmt))
      then begin
        sm('TDAmeritrade limits trade history downloads to 12 months at a time!');
        cxTo.Date := xStrToDate('12/31/'+taxyear,Settings.InternalFmt);
      end;
    end;
    // do not allow importing past Jan 31
    if (TradeLogFile.NextTaxYear <> currentYear)
    and (cxTo.date > xStrToDate('01/31/'+nexttaxyear,Settings.InternalFmt))
    then begin
      sm('Cannot import trades past ' //
        + dateToStr(xStrToDate('01/31/' + nexttaxyear, Settings.InternalFmt), Settings.InternalFmt) //
        + ' in a ' + taxyear + ' data file.' + CR //
        + 'Adjusting end date.');
      cxTo.date:= xStrToDate('01/31/'+nexttaxyear,Settings.InternalFmt);
    end;
    // cannot import past yesterday
    if cxTo.date>= now() then begin
      cxTo.Date:= dateOf(now()-1);
    end;
    // Fidelity does not allow downloads of more than 90 days, otherwise no data returned
    if  (TradeLogFile.CurrentAccount.FileImportFormat='Fidelity')
    and ( cxTo.IsFocused or rbMo.Checked ) then begin
      if cxTo.Date > cxFrom.Date +90 then begin
        cxFrom.Date := cxTo.Date - 90;
        cxTo.Date:= cxFrom.Date +90;
        mDlg('Fidelity does not allow downloads of more than 90 days',
          mtWarning,[mbOK],1);
      end;
    end
    // Tradestation and ETrade do not allow downloads of more than 3 months, otherwise get IE error
    else if cbWebLogin.Checked
    and ( //
       (TradeLogFile.CurrentAccount.FileImportFormat='TradeStation') //
    or (TradeLogFile.CurrentAccount.FileImportFormat='ETrade') // pre-Passiv only
    ) //
    and ( cxTo.IsFocused or rbMo.Checked ) then begin
      if (cxTo.Date > inc3months(cxFrom.Date))then begin
        cxFrom.Date := cxTo.Date - 90;
        cxTo.Date:= inc3months(cxFrom.Date);
        mDlg(TradeLogFile.CurrentAccount.FileImportFormat + ' does not allow downloads of more than 3 months',
          mtWarning,[mbOK],1);
      end;
    end
    // set start date to Mon thru Fri for IB
    else if  (TradeLogFile.CurrentAccount.FileImportFormat='IB')
    and ( cxTo.IsFocused or rbMo.Checked ) then begin
      if dayOfWeek(cxTo.date)=1 then begin
        cxTo.date:= cxTo.Date-2;
      end
      else if dayOfWeek(cxTo.date)=7 then begin
        cxTo.date:= cxTo.Date-1;
      end;
    end;
    // open this up for To date beyond 12/31/taxyear
    if (cxTo.Date > xStrToDate('10/16/' + NextTaxYear, Settings.InternalFmt))
    and TradeLogFile.CurrentAccount.MTM then
      cxTo.Date := xStrToDate('10/16/' + NextTaxYear, Settings.InternalFmt);
    // end if
  end;
end;


function readHTMLPage(hPage:HINTERNET):string;
var
  buffer:array[1..256] of char;
  bytesRead:DWORD;
  pageStr:string;
begin
  pageStr:='';
  repeat
    if not InternetReadFile(hPage,@buffer,SizeOf(buffer),bytesRead) then break;
    pageStr:= pageStr + Copy(buffer,1,bytesRead);
  until bytesRead = 0;
  if pageStr='' then
    result:= 'no page data found'
  else
    result:= pageStr;
end;


initialization
  fformGet:= nil;

end.
