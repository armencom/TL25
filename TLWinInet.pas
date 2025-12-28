unit TLWinInet;

interface

uses
  Windows, Messages, SysUtils, Classes, Forms, Dialogs, TLCommonLib;

type
  EReadUrlException = class(Exception);

function readUrl(url:string; timeout : integer = 5000):string; overload;
function readUrl(url:string; ShowError : Boolean; timeout : integer = 5000):string; overload;

//new WinInet functions for tradeMonster
function readURLpost(myURL:string; var myParams:TStringList): string;
//function readYodleePost(sURL:string; sUser:string): string;
//function ReadBrokerConnectPost(AUrl : String; Header : TStringStream; var AData : AnsiString) : String;
function ReadBrokerConnectPost(AUrl : String; Header : TStringStream; var AData : AnsiString; sMethod : String) : String;

function postGet(AUrl : String; Header : TStringStream; var AData : AnsiString) : String;


implementation

uses
  Main, FuncProc, Controls, StrUtils, idURI, IDhttp, IdSSLOpenSSL, Winapi.WinInet,
   ClipBrd, GlobalVariables;

var
  hInet: HINTERNET;
  hFile: HINTERNET;
  cancelURL : Boolean;

const
  ydHost = 'sandbox.api.yodlee.com';
  ydAPI = 'Api-Version: 1.1';
  ydCont = 'Content-Type: application/x-www-form-urlencoded';
  ydCryp = 'clientId=8S6jPTCFf7cI7FfT1JOSNRZiuWwA7NVW&secret=nOYVAwBjIAemacc1';
  ydClient = '8S6jPTCFf7cI7FfT1JOSNRZiuWwA7NVW';
  ydSecret = 'nOYVAwBjIAemacc1';


procedure LogToFile(sMsg : string);
var
  eLog : textfile;
  sLogFile : string;
begin
  if gsErrorLog = '' then exit; // not yet initialized
  AssignFile(eLog, gsErrorLog);
  if fileexists(gsErrorLog) then
    append(eLog)
  else
    rewrite(eLog);
  try
    write(eLog, sMsg);
  finally
    CloseFile(eLog);
  end;
end;


procedure dialogNoNet(sMsg : String = '');
begin
  if sMsg = '' then
    sMsg := 'Could not connect to the Internet' + cr //
      + cr //
      + 'Please make sure you are connected and that' + cr //
      + 'your Firewall software is not blocking TradeLog' + cr //
      + 'from accessing the Internet';
  if GetLastError > 0 then
    sMsg := GetLastErrorMessage(GetLastError)+cr+cr+sMsg;
  mDlg(sMsg , mtWarning, [mbOK], 0);
end;


function readUrl(url:string; timeout : integer = 5000) : string;
begin
  screen.Cursor := crHourglass;
  Result := readUrl(url, true, timeout);
  screen.Cursor := crDefault; // prevent hanging - 2015-12-14 MB
end;

function readUrl(url :string; ShowError : Boolean; timeout : integer = 5000) : string;
var
  buffer : array[1 .. 32000] of AnsiChar;
  OpBuffer, errCount : integer;
  bytesRead : DWORD;
  myStr, sInetBlock : string;
begin
  try
    myStr := '';
    Result := '';
    fillChar(buffer, 0, sizeOf(buffer));
    // Minimum timeout is 10 seconds
    if timeout > 999 then
      OpBuffer := timeout
    else
      OpBuffer := 10000; // in milliseconds
    hInet := InternetOpen(PChar(application.title), INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
    try
      // could not connect to the Internet
      if hInet = nil then begin
        if ShowError then begin
          statBar('off');
          dialogNoNet;
          Result := '';
          exit;
        end
        else
          raise EReadUrlException.Create('Opening the Internet Connection Failed: ' //
            + GetLastErrorMessage(GetLastError));
      end;
      InternetSetOption(hInet, INTERNET_OPTION_RECEIVE_TIMEOUT, @OpBuffer, sizeOf(OpBuffer));
      hFile := InternetOpenURL(hInet, PChar(url), '', 0, INTERNET_FLAG_RELOAD, 0);
      try
        // page not found or not returned
        if hFile = nil then begin
          if ShowError then begin
            if TLStart and (pos('regcheck.cgi', url)> 0) then
              dialogNoNet('The following URL is currently not available: ' + cr //
                + cr //
                + copy(url, 1, 100) + cr //
                + cr //
                + 'Please try again later, as the page may become available.' + cr //
                + cr //
                + 'If the problem persists please contact TradeLog Support.');
            statBar('off');
            Result := '';
            exit;
          end
          else
            raise EReadUrlException.Create('URL Cannot Be Read: ' + cr //
              + cr //
              + url + ' ' + cr //
              + cr //
              + GetLastErrorMessage(GetLastError));
        end;
        // Here's the loop to get the data
        errCount := 0;
        repeat
          if InternetReadFile(hFile,@buffer, sizeOf(buffer), bytesRead) then begin
            sInetBlock := copy(buffer, 1, bytesRead); // 2018-04-03 MB begin new ErrTrap code
            if (pos('<Status>Fail</Status>', sInetBlock) > 0) then begin
              Result := sInetBlock;
              exit; // hopefully returns the error code!
            end; // 2018-04-03 MB end new ErrTrap code
            myStr := myStr + sInetBlock;
          end
          else begin
            errCount := errCount + 1;
          end;
// Screen.Cursor := crHourglass;
          application.ProcessMessages;
          if GetKeyState(VK_ESCAPE) and 128 = 128 then
            cancelURL := true;
          if cancelURL then begin
            myStr := 'cancel';
            break;
          end;
        until (bytesRead = 0) or (errCount > 10);
        // did we fail 10X?
        if errCount > 10 then begin
          if ShowError then begin
            dialogNoNet('Reading the URL: ' + url + ' failed. ' + cr + cr //
              + 'This is most likely an issue with the URL being too busy or intermittent connectivity.' + cr //
              + 'Please try again later!');
            statBar('off');
            Result := '';
            exit;
          end
          else
            raise EInOutError.Create('InternetReadFile failed to read next packet. ' //
              + GetLastErrorMessage(GetLastError));
        end;
      finally
        InternetCloseHandle(hFile);
      end;
    finally
      InternetCloseHandle(hInet);
    end;
    Result := myStr;
  finally
    // readURL
  end;
end;


function readURLpost(myURL:string; var myParams:TStringList): string;
var
  t: string;
  http : TIDHttp;
  LHandler: TIdSSLIOHandlerSocketOpenSSL;
begin
//  screen.Cursor := crHourglass;
  try
    http := TIDHttp.Create(nil);
    http.ReadTimeout := 30000;
    http.Request.ContentType := 'application/x-www-form-urlencoded';
    http.Request.Charset := 'utf-8';
    http.Request.UserAgent := 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_2)'
      + ' AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.111 Safari/537.36';
    try
      LHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
      try
        http.IOHandler := LHandler;
        result := http.Post(myURL, myParams);
        //sm('result ='+cr+result);
      finally
        LHandler.Free;
      end;
    finally
      http.Free;
    end;
  except
    on E: Exception do begin
      If (Developer) then begin
        t := clipBoard.AsText;
        clipBoard.AsText := 'ERROR:' + CRLF + E.ClassName+ ': ' + E.Message;
        sm('ERROR:' + CRLF + E.ClassName+ ': ' + E.Message);
        clipBoard.AsText := t;
      end;
      result := E.Message;
    end;
  end;
  screen.Cursor := crDefault;
end;


function ReadBrokerConnectPost(
  AUrl : String;
  Header : TStringStream;
  var AData : AnsiString;
  sMethod : String
  ) : String;
var
  aBuffer     : array[0..4096] of Byte;
  BufStream   : TStringStream;
  BytesRead   : Cardinal;
  pSession    : HINTERNET;
  pConnection : HINTERNET;
  pRequest    : HINTERNET;
  blnSSL      : Boolean;
  URI: TIdURI;
  ResultBuffer : array[0..4096] of Char;
  Reserved    : Cardinal;
  nRecords    : integer;
  ADataIn : AnsiString;
begin
  if Developer or (v2UserEmail = DEBUG_EMAIL) then begin
    LogToFile('url=' + AUrl + CRLF + sMethod + '=' + AData + CRLF);
  end;
  ADataIn := AData;
  try
    Result := '';
    blnSSL := StrUtils.StartsText('https://', AURl);
    URI := TidUri.Create(AURL);
    try
      pSession := InternetOpen(nil, INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
      if Assigned(pSession) then
      try
        case blnSSL of
        True :
          pConnection := InternetConnect(pSession, PChar(URI.Host),
            INTERNET_DEFAULT_HTTPS_PORT, nil, nil, INTERNET_SERVICE_HTTP, 0, 0);
        False :
          pConnection := InternetConnect(pSession, PChar(URI.Host),
            INTERNET_DEFAULT_HTTP_PORT, nil, nil, INTERNET_SERVICE_HTTP, 0, 0);
        end;
        if Assigned(pConnection) then
        try
          case blnSSL of
          True :
            pRequest := HTTPOpenRequest(pConnection, PChar(sMethod),
              PChar(URI.GetPathAndParams), PChar('HTTP/1.0'), nil, nil,
              INTERNET_FLAG_SECURE or INTERNET_FLAG_NO_COOKIES, 0);
          False :
            pRequest := HTTPOpenRequest(pConnection, PChar(sMethod), PChar(AURL),
              PChar('HTTP/1.0'), nil, nil, INTERNET_FLAG_NO_COOKIES, 0);
          end;
          if Assigned(pRequest) then
          try
            HttpAddRequestHeaders(pRequest, PChar(Header.DataString),
              Length(Header.DataString),
              HTTP_ADDREQ_FLAG_ADD and HTTP_ADDREQ_FLAG_REPLACE);
            if HTTPSendRequest(pRequest,  nil, 0, Pointer(AData), Length(AData)) then begin
              BufStream := TStringStream.Create('', tEncoding.UTF8);
              try
                BytesRead := 0;
                while InternetReadFile(pRequest, @aBuffer, SizeOf(aBuffer), BytesRead) do begin
                  if (BytesRead = 0) then Break;
                  BufStream.WriteBuffer(aBuffer[0], BytesRead);
                  // -------- count transactions ----------
                  if rightstr(AUrl,12) = 'transactions' then begin
                    nRecords := nRecords + 1;
                  end;
                end;
                AData := BufStream.DataString;
                // Read the HTTP Status Code from the header and if it exists then return it
                BytesRead := Length(ResultBuffer);
                Reserved := 0;
                if HttpQueryInfo(pRequest, HTTP_QUERY_STATUS_CODE, @ResultBuffer, BytesRead, Reserved) then
                  Result := ResultBuffer;
                BytesRead := Length(ResultBuffer);
                if HttpQueryInfo(pRequest, HTTP_QUERY_STATUS_TEXT, @ResultBuffer, BytesRead, Reserved) then
                  Result := Result + ' ' + ResultBuffer;
                // get raw header data
                BytesRead := Length(ResultBuffer);
                if HttpQueryInfo(pRequest, HTTP_QUERY_RAW_HEADERS_CRLF, @ResultBuffer, BytesRead, Reserved) then
                  Result := Result + ' ' + ResultBuffer;
                if Length(Result) = 0  then
                  Result := 'Could not read Status Code, See Data for Results';
              finally
                FreeAndNil(BufStream);
              end;
            end;
          finally
            InternetCloseHandle(pRequest);
          end;
        finally
          InternetCloseHandle(pConnection);
        end;
      finally
        InternetCloseHandle(pSession);
      end;
    finally
      URI.Free;
      if Developer or (v2UserEmail = DEBUG_EMAIL) then begin
        if (AData = '') then
          LogToFile('status=' + leftstr(Result,4) + CRLF //
            + 'returned=<nothing>' + CRLF + CRLF)
        else if (AData = ADataIn) then
          LogToFile('status=' + leftstr(Result,4) + CRLF //
            + 'returned=<timed-out>' + CRLF + CRLF)
        else
          LogToFile('status=' + leftstr(Result,4) + CRLF //
            + 'returned=' + leftstr(AData,999) + CRLF + CRLF);
      end;
      screen.Cursor := crDefault;
    end;
  except
    on e: Exception do begin
      mDlg('Error: ' + e.Message, mtWarning, [mbOK], 0);
    end;
  end;
end;


function postGet(AUrl : String; Header : TStringStream; var AData : AnsiString) : String;
var
  aBuffer     : array[0..4096] of Byte;
  BufStream   : TStringStream;
  sMethod     : String;
  BytesRead   : Cardinal;
  pSession    : HINTERNET;
  pConnection : HINTERNET;
  pRequest    : HINTERNET;
  blnSSL      : Boolean;
  URI: TIdURI;
  ResultBuffer : array[0..4096] of Char;
  Reserved    : Cardinal;
begin
//  screen.Cursor := crHourglass;
  Result := '';
  blnSSL := StrUtils.StartsText('https://', AURl);
  URI := TidUri.Create(AURL);
  try
    if not StrUtils.ContainsText('Host:', Header.DataString) then
      Header.WriteString('Host: ' + URI.Host + sLineBreak);
    pSession := InternetOpen(nil, INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
    if Assigned(pSession) then
    try
      case blnSSL of
      True :
        pConnection := InternetConnect(pSession, PChar(URI.Host),
          INTERNET_DEFAULT_HTTPS_PORT, nil, nil, INTERNET_SERVICE_HTTP, 0, 0);
      False :
        pConnection := InternetConnect(pSession, PChar(URI.Host),
          INTERNET_DEFAULT_HTTP_PORT, nil, nil, INTERNET_SERVICE_HTTP, 0, 0);
      end;
      if Assigned(pConnection) then
      try
        if (AData = '') then
          sMethod := 'GET'
        else
          sMethod := 'POST';
        case blnSSL of
        True :
          pRequest := HTTPOpenRequest(pConnection, PChar(sMethod),
            PChar(URI.GetPathAndParams), PChar('HTTP/1.0'), nil, nil,
            INTERNET_FLAG_SECURE or INTERNET_FLAG_NO_COOKIES, 0);
        False :
          pRequest := HTTPOpenRequest(pConnection, PChar(sMethod), PChar(AURL),
            PChar('HTTP/1.0'), nil, nil, INTERNET_FLAG_NO_COOKIES, 0);
        end;
        if Assigned(pRequest) then
        try
          HttpAddRequestHeaders(pRequest, PChar(Header.DataString),
            Length(Header.DataString),
            HTTP_ADDREQ_FLAG_ADD and HTTP_ADDREQ_FLAG_REPLACE);
          if HTTPSendRequest(pRequest,  nil, 0, Pointer(AData), Length(AData)) then begin
            BufStream := TStringStream.Create('', tEncoding.UTF8);
            try
              BytesRead := 0;
              while InternetReadFile(pRequest, @aBuffer, SizeOf(aBuffer), BytesRead) do begin
                if (BytesRead = 0) then Break;
                BufStream.WriteBuffer(aBuffer[0], BytesRead);
              end;
              AData := BufStream.DataString;
              // Read the HTTP Status Code from the header and if it exists then return it
              BytesRead := Length(ResultBuffer);
              Reserved := 0;
              if HttpQueryInfo(pRequest, HTTP_QUERY_STATUS_CODE, @ResultBuffer, BytesRead, Reserved) then
                Result := ResultBuffer;
              BytesRead := Length(ResultBuffer);
              if HttpQueryInfo(pRequest, HTTP_QUERY_STATUS_TEXT, @ResultBuffer, BytesRead, Reserved) then
                Result := Result + ' ' + ResultBuffer;
              // get raw header data
              BytesRead := Length(ResultBuffer);
              if HttpQueryInfo(pRequest, HTTP_QUERY_RAW_HEADERS_CRLF, @ResultBuffer, BytesRead, Reserved) then
                Result := Result + ' ' + ResultBuffer;
              if Length(Result) = 0  then
                Result := 'Could not read Status Code, See Data for Results';
            finally
              FreeAndNil(BufStream);
            end;
          end;
        finally
          InternetCloseHandle(pRequest);
        end;
      finally
        InternetCloseHandle(pConnection);
      end;
    finally
      InternetCloseHandle(pSession);
    end;
  finally
    URI.Free;
    screen.Cursor := crDefault;
  end;
end;


end.
