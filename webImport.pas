unit webImport;

interface

uses
  Windows, Messages, Classes, Controls, Forms, Dialogs;

  procedure getTDAmeritradeCSV(OFXStart,OFXEnd:TDateTime);
  procedure getEtradeCSV(OFXStart,OFXEnd:TDateTime);
  procedure getFidelityCSV(OFXStart,OFXEnd:TDateTime);
  procedure getIBflex(OFXStart,OFXEnd:TDateTime);
  procedure getLightspeedCSV(OFXStart,OFXEnd:TDateTime);
  procedure getSchwabCSV(OFXStart,OFXEnd:TDateTime);
  procedure getTMcsv(OFXStart,OFXEnd:TDateTime);


implementation

uses
  funcProc, SysUtils, StrUtils, DateUtils, globalVariables, webGet,
  TLCommonLib, TLFile, TLSettings, TLWinInet, securityQues, clipbrd;


procedure saveDownloadedCSV(dateStart,dateEnd:string);
var
  i : integer;
  sFileName : string;
  csvFile: TextFile;
begin
  sFileName := assignImpBackupFilename(dateStart, dateEnd, Settings.InternalFmt);
  if FileExists(sFileName) then deleteFile(sFileName);
  // write webGetData to file
  AssignFile(csvFile, sFileName);
  Rewrite(csvFile);
  write(csvFile, webGetData);
  closeFile(csvFile);
end;


function encodeHTMLChars(s:string): string;
var
  i : integer;
  myS : string;
begin
  result := '';
  for i := 1 to length(s) do
    case s[i] of
      '&': result := result + '%26';
      '!': result := result + '%21';
      '#': result := result + '%23';
      '$': result := result + '%24';
      '%': result := result + '%25';
      '@': result := result + '%40';
    else
      result := result + s[i];
    end;
end;


// ----------------------------------------------
procedure getTDAmeritradeCSV(OFXStart,OFXEnd:TDateTime);
// ----------------------------------------------
var
  securityQues, securityAns, remDevice, sURL : string;
  dlgSecQues : TdlgSecurityQues;
  dateStart, dateEnd : string;
begin
  if webGetData = 'cancel' then exit;
  Screen.Cursor := crHourglass;
  dateStart := DateToStr(OFXStart, Settings.InternalFmt);
  dateEnd := DateToStr(OFXEnd, Settings.InternalFmt);
  statBar('Logging into TDAmeritrade web site - Please Wait...');
  sURL := 'https://invest.ameritrade.com/grid/p/login' //
      + '?tbUsername=' + TradeLogFile.CurrentAccount.OFXUserName //
      + '&tbPassword=' //
      + TradeLogFile.CurrentAccount.OFXpassword //
      + '&ldl=main:home' + '&mAction=submit'; //
  webgetData := readURL(sURL);
  if (pos('Unable to authorize access',webGetData)>0) then begin
    mDlg('Invalid UserID or Password' + cr //
      + cr //
      + 'Please enter correct Login info and try again' + cr, mtError,[mbOk],0);
    webgetData := '';
    exit;
  end
  else if (pos('<p class="securityP"><span style="font-weight:bold">Question:</span>', webgetData) > 0)
  then begin
    securityQues := trim(parseHTML(webGetdata, 'Question:</span>', '</'));
    dlgSecQues := TdlgSecurityQues.Create(application);
    try
      dlgSecQues.lblQues.Caption := securityQues;
      dlgSecQues.ShowModal;
      if dlgSecQues.ModalResult = mrOk then begin
        securityAns := dlgSecQues.edAnswer.Text;
        if dlgSecQues.cbRemDevice.checked then
          remDevice := 'yes'
        else
          remDevice := '';
      end
      else begin
        webgetData := '';
        exit;
      end;
    finally
      dlgSecQues.Free;
    end;
    sURL := 'https://invest.ameritrade.com/grid/m/securityChallenge';
    sURL := sURL + '?challengeAnswer=' + securityAns //
      + '&rememberDevice=' + remDevice + '&mAction=submit';
    webgetData := readURL(sURL);
  end;
  // ==========================
  // security challenge question
  // ==========================
  if (pos('Unable to authorize access', webGetData) > 0) then begin
    mDlg('Invalid Challenge Answer' + cr //
      + cr //
      + 'Please try again' + cr, mtError,[mbOk],0);
    webgetData := '';
    exit;
  end
  // ==========================
  // check for valid account number
  // ==========================
  else if (pos('"active":"' + TradeLogFile.CurrentAccount.OFXaccount + '"', webGetData) = 0)
  then begin
    clipboard.astext := webgetData;
    mDlg('Invalid Account Number: ' + TradeLogFile.CurrentAccount.OFXaccount + cr //
      + cr //
      + 'Please edit account number and try again.' + cr, mtError,[mbOk],0);
    webgetData := '';
    exit;
  end
  else
    statBar(sMsgGetCSV);
  // ==========================
  // get csv file - account number is set after login, so no acct number needed
  // ==========================
  sURL := 'https://invest.ameritrade.com/cgi-bin/apps/u/HistoryDownload/transactions.csv' //
    + '?__ctype=text%2Fplain'
    + '&TRANSACTION_TYPE=0'
    + '&FROM_DATE='+YYYYMMDD(dateStart)
    + '&TO_DATE='+YYYYMMDD(dateEnd)
    + '&SYMBOL_INPUT='
    + '&DOWNLOAD=true';
  webGetData := readURL(sURL);
  if (pos('DATE',webGetData)=1) then begin
    saveImportAsFile(webGetData,dateStart,dateEnd,Settings.InternalFmt);
  end
  else begin
    raise Exception.Create(TradeLogFile.CurrentAccount.FileImportFormat //
      + ' brokerConnect web import error');
    webGetData := '';
  end;
  repaintGrid;   //??
end;


// ----------------------------------------------
procedure getEtradeCSV(OFXStart,OFXEnd:TDateTime);
// ----------------------------------------------
var
  securityQues, securityAns, remDevice, ETAcct, sTimeStamp, sURL : string;
  dateStart, dateEnd : string;
  dlgSecQues : TdlgSecurityQues;
  myParams: TStringList;
begin
  // NOTE: needs work!
  if webGetData = 'cancel' then exit;
  Screen.Cursor := crHourglass;
  statBar('Logging into ETrade web site - Please Wait...');
  dateStart := DateToStr(OFXStart, Settings.InternalFmt);
  dateEnd := DateToStr(OFXEnd, Settings.InternalFmt);
  sURL:= 'https://us.etrade.com/e/t/user/login';
  myParams := TStringList.create; // reserve memory
  try
    myParams.Add('USER=' + TradeLogFile.CurrentAccount.OFXUserName);
    myParams.Add('txtPassword=' + TradeLogFile.CurrentAccount.OFXPassword);
    myParams.Add('PASSWORD=' + TradeLogFile.CurrentAccount.OFXPassword);
    // -----------------
    myParams.Add('SWHHTTPHeader=ETWLAPP1-5cd7ad6c-920'); // 2020-08-13 MB
    // -----------------
    myParams.Add('TARGET=https://us.etrade.com/e/t/accounts/accountscombo?cnt=header_logon_startin_accounts');
    webGetData := readURLpost(sURL, myParams);
    // -----------------
    myParams.clear;
    webGetdata := readURLpost('https://us.etrade.com/e/t/invest/downloadofxtransactions?fp=TH', myParams);
    // -----------------
    sURL:='https://us.etrade.com/e/t/invest/ExcelDownloadTxnHistoryComponent';
    myParams.clear;
    delete(dateStart,7,2);
    delete(dateEnd,7,2);
    myParams.Add('skinname=none');
    myParams.Add('DownloadFormat=msexcel');
    myParams.Add('AcctNum='+ETAcct);
    myParams.Add('FromDate='+dateStart);
    myParams.Add('ToDate='+dateEnd);
    // -----------------
    webGetData := readURLpost(sURL, myParams);
  finally
    freeAndNil(myParams); // release memory
  end;
end;


// ----------------------------------------------
procedure getFidelityCSV(OFXStart,OFXEnd:TDateTime);
// ----------------------------------------------
var
  securityQues, securityAns, remDevice, ETAcct, sURL : string;
//  dateStart, dateEnd : string;
  dlgSecQues : TdlgSecurityQues;
begin
  // Fidelity Tech Support, M-F 8:30 - 5:00 EST
  // 1-800-544-7595 = Wade May, 6/14/2017
  Screen.Cursor := crHourglass;
  statBar('Logging into Fidelity web site - Please Wait...');
  // ----------------------------------
  // see WebGet.pas
  if (Developer) then begin
    clipboard.astext := sURL + CRLF + CRLF + webgetData;
    sm('Paste webgetData: ' + CRLF //
      + copy(webgetData,1,2000));
  end;
  // ----------------------------------
end;


// ----------------------------------------------
procedure getIBflex(OFXStart,OFXEnd:TDateTime);
// ----------------------------------------------
var
  sURL, sRef, sFrom, sTo, sErr, sErrMsg : String;
  dateStart, dateEnd : string;
  errCount : integer;
begin
  statBar('Getting IB Trade History Data');
  screen.Cursor := crHourglass;
  dateStart := DateToStr(OFXStart, Settings.InternalFmt);
  dateEnd := DateToStr(OFXEnd, Settings.InternalFmt);
  sFrom := YYYYMMDD(dateStart);
  sTo := YYYYMMDD(dateEnd);
  sURL := 'https://www.interactivebrokers.com/Universal/servlet/FlexStatementService.SendRequest'
    + '?t=' + TradeLogFile.CurrentAccount.OFXUserName
    + '&q=' + TradeLogFile.CurrentAccount.OFXpassword
    + '&v=3'
    + '&fd=' + sFrom
    + '&td=' + sTo;
  webgetData := readURL(sURL);
  errCount := 0;
  // ----------------------------------
  while (pos('FlexStatementResponse', webGetData) = 0) and (errCount < 5) do begin
    sleep(1100); // 2018-01-29 MB - must wait at least 1 second per IB
    webgetData := readURL(sURL);
    errCount := errCount + 1;
  end;
  // ----------------------------------
  if (pos('<ErrorCode>', webGetData) > 0) then begin
    sErr := parseHTML(webGetdata, '<ErrorCode>', '</ErrorCode>');
    sErrMsg := parseHTML(webGetdata, '<ErrorMessage>', '</ErrorMessage>');
    mDlg('Message from IB Server:'+cr+cr+'ErrorCode: '+sErr+cr+sErrMsg, mtError, [mbCancel], 0);
    webGetData := '';
    exit;
  end;
  // ----------------------------------
  sRef := parseHTML(webGetData,'<ReferenceCode>','</ReferenceCode>');
  sUrl := parseHTML(webGetData,'<Url>','</Url>') +
    '?q=' + sRef +
    '&t=' + TradeLogFile.CurrentAccount.OFXUserName +
    '&v=3' +
    '&fd=' + sFrom +
    '&td=' + sTo;
  webgetData := readURL(sURL);
  while (pos('ErrorCode>1019<', webGetData) > 0) do begin
    sleep(1100); // 2018-01-29 MB - must wait at least 1 second per IB
    webgetData := readURL(sURL);
  end;
  // ----------------------------------
  if (pos('<ErrorCode>', webGetData) > 0) then begin
    sErr := parseHTML(webGetdata, 'ErrorCode>', '</');
    sErrMsg := parseHTML(webGetdata, 'ErrorMessage>', '</');
    if sErr = '1022' then begin
      mDlg('Message from IB Server:' + cr //
        + cr //
        + 'ErrorCode: '  + sErr + cr //
        + sErrMsg + cr //
        + cr //
        + 'This is often caused by date range too large.' + cr //
        + 'Please try importing one month at a time.', mtError, [mbCancel], 0);
    end
    else begin
      mDlg('Message from IB Server:' + cr //
        + cr //
        + 'ErrorCode: ' + sErr + cr //
        + sErrMsg + cr //
        + cr //
        + 'Please try again later, or call IB for assistance' + cr //
        , mtError, [mbCancel], 0);
    end;
    webGetData := '';
    exit;
  end;
  saveDownloadedCSV(dateStart,dateEnd);
  // must copy to clipboard to read flex file (ie: different from csv file)
  clipboard.astext := webgetData;
  //sm(webgetData);
end;


// ----------------------------------------------
procedure getLightspeedCSV(OFXStart,OFXEnd:TDateTime);
// ----------------------------------------------
var
  myParams: TStringList;
  sURL : String;
  dateStart, dateEnd : string;
begin
  if webGetData = 'cancel' then exit;
  screen.Cursor := crHourglass;
  statBar(sMsgGetCSV);
  dateStart := DateToStr(OFXStart, Settings.InternalFmt);
  dateEnd := DateToStr(OFXEnd, Settings.InternalFmt);
  sURL:= 'https://secure.lightspeed.com/secure/tradelog.php';
  myParams := TStringList.create;
  try
    myParams.Add('Username=' + TradeLogFile.CurrentAccount.OFXUserName);
    myParams.Add('Password=' + TradeLogFile.CurrentAccount.OFXPassword);
    myParams.Add('acct='+ TradeLogFile.CurrentAccount.OFXAccount);
    myParams.Add('from='+dateStart);
    myParams.Add('to='+dateEnd);
    // -----------------
    webGetData := readURLpost(sURL, myParams);
    // test for invalid Username or Password
    if (pos('302 Found',webGetData)>0) then begin
      webgetData := '';
      sm('Invalid Username or Password.');
    end else
    // test for invalid account number
    if (pos('incorrect: acct',webGetData)>0) then begin
      webgetData := '';
      sm('Invalid Account Number.');
    end;
    // -----------------
    if (webgetData <> '') then
      saveImportAsFile(webGetData,dateStart,dateEnd,Settings.InternalFmt);
  finally
    freeAndNil(myParams);
  end;
end;


// ----------------------------------------------
procedure getSchwabCSV(OFXStart,OFXEnd:TDateTime);
// ----------------------------------------------
var
  securityQues, securityAns, remDevice, ETAcct, sURL : string;
  dateStart, dateEnd : string;
  dlgSecQues : TdlgSecurityQues;
begin
  if webGetData = 'cancel' then exit;
  Screen.Cursor := crHourglass;
  dateStart := DateToStr(OFXStart, Settings.InternalFmt);
  dateEnd := DateToStr(OFXEnd, Settings.InternalFmt);
  statBar('Logging into Schwab web site - Please Wait...');
  sURL := 'https://client.schwab.com/Login/SignOn/SignOn.ashx'
      + '?HdnChanFooterContentID=GLOBAL-SIMPLECHAN-DEFULTFOOLTER'
      + '&ctl00$WebPartManager1$CenterLogin$LoginUserControlId$txtLoginID='
      + TradeLogFile.CurrentAccount.OFXUserName
      + '&txtPassword='
      + TradeLogFile.CurrentAccount.OFXpassword
      + '&hdnLoginExperience=Domestic';
  webgetData := readURL(sURL);
  saveDownloadedCSV(dateStart,dateEnd);
end;


// ----------------------------------------------
procedure getTMcsv(OFXStart,OFXEnd:TDateTime);
// ----------------------------------------------
var
  TMurl, sessionId, token, userId, reply, sTime, eTime, acct : string;
  dateStart, dateEnd : string;
  postData : AnsiString;
  Header : TStringStream;
begin
  if webGetData = 'cancel' then exit;
  //// TM LOGIN ////
  Screen.Cursor := crHourglass;
  statBar('Logging into TradeMONSTER web site - Please Wait...');
  dateStart := DateToStr(OFXStart, Settings.InternalFmt);
  dateEnd := DateToStr(OFXEnd, Settings.InternalFmt);
  TMurl := 'https://www.trademonster.com/j_acegi_security_check';
  postData := 'j_username=' + TradeLogFile.CurrentAccount.OFXusername //
           + '&j_password=' + TradeLogFile.CurrentAccount.OFXpassword;
  Header := TStringStream.Create('');
  try
    with Header do begin
        WriteString('User-Agent: TradeLog InetClntApp/3.0' + SLineBreak);
        WriteString('Content-Type: application/x-www-form-urlencoded' +SLineBreak);
        WriteString('Accept: text/html' +SLineBreak);
        WriteString('Connection: Keep-Alive' + SlineBreak);
    end;
    reply := postGet(TMurl, Header, postData);
    //test for successful login post
    if pos('200 OK',reply)=0 then begin
      sm('Login Failed.');
      webGetData := '';
      exit;
    end else
    if pos('BadCredentialsException',postData)>0 then begin
      sm('Invalid Username or Password.');
      webGetData := '';
      exit;
    end;
    //get sessionId, token, and userId
    sessionId := delQuotes(parseHTML(postData,'sessionId":"',','));
    token := delQuotes(parseHTML(postData,'token":"',','));
    userId := parseHTML(postData,'userId":',',');
    statbar(sMsgGetCSV);
    // need to decrement month by 1 ie: 01/01/2015 = 00/01/2015
    sTime:= inttostr(strToInt(leftStr(dateStart,2))-1) +rightStr(dateStart,8);
    if length(sTime)=9 then sTime:= '0'+sTime;
    eTime:= inttostr(strToInt(leftStr(dateEnd,2))-1) +rightStr(dateEnd,8);
    if length(eTime)=9 then eTime:= '0'+eTime;
    //delete dash in account number
    Acct := ReplaceStr(TradeLogFile.CurrentAccount.OFXAccount, '-', '');
    //// TM CSV File Download ////
    with Header do begin
      WriteString('Cookie: JSESSIONID=' +sessionId +SlineBreak);
      WriteString('token:' +token +SlineBreak);
    end;
    postData:='';
    TMurl :='https://www.trademonster.com/AccountHistoryExporterServlet';
    TMurl := TMurl + '?userId=' + userId //
      + '&accountNumber=' + Acct //
      + '&transactionType=ALL' //
      + '&timeRange=RANGE' //
      + '&startTime=' + sTime //
      + '&endTime=' + eTime //
      + '&customerMode=true';
    webGetData := postGet(TMurl, Header, postData);
  finally
    Header.Free;
  end;
  // ------------------------
  if pos('200 OK',reply)=0 then begin
    sm('CSV File Download Failed.');
    webGetData := '';
    exit;
  end;
  webGetData := postData;
  if pos('An Error Occurred',webgetData)>0 then begin
    mDlg('Error accessing this account. ' + cr //
      + cr //
      + 'Please contact tradeMONSTER Customer Service at 1-877-598-3190' + cr //
      , mtError,[mbOK],1);
  end;
end;


end.
