unit TL_API;

interface

uses
  Sysutils, StrUtils, Windows, Dialogs, Variants, Classes, clipBrd, TLWinInet;

function GetAPIKey: string;
function TestAnyAPI(sKey, sURL, sDat: string): string;

function ParseJSON(const s, sOpenDelim, sCloseDelim: string) : TStrings; overload;
function ParseJSON(const s: string) : TStrings; overload;

function ParseV2APIResponse(s: string): TStrings;
function FormatV2APIResponse(sJSON: string): string;
function FastSpringToDate(s : string): TDateTime;

function GeneratePassword(sPwd : string): string;
function GetLogin(sEmail, sPwd : string): string; // returns JSON
function GetSubscriptions(sUserToken : string): string;
function GetCustomerId(sToken : string): string; // 2024-03-04 MB

function ListAllUsers(sUserToken : string): string;
function ManageUsers(sFunc, sUserToken, sName, sEmail, sPwd : string): string;

//function ListAllClients(sUserToken : string): string;
//function ManageClients(sFunc, sUserToken, sName, sEmail, sPwd : string): string;

function ListFileKeys(sUserToken : string): string;
//function AvailableFileKeys(sUserToken : string): string;
function UpdateFileKey(sUserToken, sEmail, sFileCode, sFileName, sTaxPayer, sTaxYear : string): string;

function InsertFileKeyLog(sUserToken, sFileCode, sFunc, sReason, sComment, sTracking, sAcct : string): string;
function GetFileKeyLog(sUserToken, sFileCode : string): string;

function LogEntry(sUserToken, sCategory, sMessage, sAction : string): string;
// note: LogEntry CRUD - sAction can be SELECT, INSERT, or DELETE

// special TradeLog functions
function GetConfigData(sUserToken, sOptionType, sLocalFile : string) : boolean;
function GetVersion(subFunc : string): string;


// Zendesk API calls
function ZendeskPullFile(sUserToken, sFileName : string) : string;
function ZendeskTicket(sUserToken, sVer, sFileName, sComments, sEmail, sName : string): string;


// --- Super User -----------
function Impersonate(sEmail : string): string;
function SuperChangeEmail(sOldEmail, sNewEmail : string): string;

function SuperInsertFileKey(sEmail, sFreeFileKey : string): string;
function SuperDeleteFileKey(sUserToken, sEmail, sFileCode : string): string;

// --- MTM Pricing ----------
function GetMTMPriceOPT(sUserToken, sYear, sOptTick : string) : string;
function GetMTMPriceSTK(sUserToken, sYear, sTick : string) : string;


implementation

uses
  Shlobj, // for ShGetSpecialFolderPath
  funcproc, // for ParseCSV
  TLCommonLib, // for TAB, CR, LF
  DateUtils, // for UnixToDateTime
  globalVariables;

const
  DEBUGGING : boolean = false;


// --------------------------
function GetAPIKey: string;
var
  x, y : TDateTime;
begin
//  x := EncodeDate(2023,03,01) + EncodeTime(0,0,0,0);
//  y := GetEasternTime;
//  if y < x then begin
    result := API_KEY;
//    result := API_KEYdev;
//  end
//  else begin
//    result := API_KEY23;
//  end;
end;

// --------------------------
procedure SaveDiagnostics(sEmail, sErr : string);
var
  path: array[0..Max_Path] of Char;
  sDiag, s1, s2, s3 : string;
  myFile : TextFile;
  // --------------
//  function EncryptOTP(Str: string): string;
//  var
//    X, Y, Z: integer;
//    A: Byte;
//    eKey : string;
//  begin
//    if length(Str) > 0 then begin
//      eKey := 'd1duOsy3n6qrPr2eF9u';
//      Y := 1;
//      Z := length(eKey);
//      for X := 1 to length(Str) do begin
//        A := (ord(Str[X]) and $0F) //
//        xor (ord(eKey[Y]) and $0F);
//        Str[X] := char((ord(Str[X]) and $F0) + A);
//        inc(Y);
//        if Y > Z then Y := 1;
//      end;
//    end;
//    Result := Str;
//  end; // EncryptOTP
begin
  if ShGetSpecialFolderPath(0, path, CSIDL_PROFILE, False) then begin
    s1 := path;
    if DirectoryExists(s1 + '\.TradeLog\Logs\') then
      s1 := s1 + '\.TradeLog\Logs\';
  end
  else begin
    s1 := GetCurrentDir;
  end;
  sDiag := s1 + '\diagnostics.txt';
//  if FileExists(s1) then DeleteFile(sDiag);
  s1 := 'Diagnostics data: ' + dEncrypt(sEmail, '');
  s3 := StringReplace(sErr, CRLF, '|', [rfReplaceAll]);
  s2 := dEncrypt(s3, '');
  AssignFile(myFile, sDiag);
  try
    Rewrite(myFile);
    WriteLn(myFile, s1);
    WriteLn(myFile, s2);
  finally
    CloseFile(myFile);
  end;
end;

// --------------------------
function TestAnyAPI(sKey, sURL, sDat: string): string;
var
  sData, sStatus, s : string;
  postData : AnsiString;
  postHead : TStringStream;
begin
  try
    postHead := TStringStream.Create('');
    with postHead do begin
      WriteString('api: ' + sKey + sLineBreak);
      WriteString('Content-Type: application/json' + sLineBreak);
      WriteString('charset: utf-8' + sLineBreak);
    end;
    // ----------------------------------------------------
    PostData := sDat;
    sStatus := ReadBrokerConnectPost(sURL, postHead, postData, 'POST');
  finally
    result := s;
  end;
end;


// --------------------------
function GetStatus(sArg : string): integer;
var
  s, t : string;
begin
  s := uppercase(sArg);
  t := ParseFirst(s, ' ');
  result := StrToIntDef(t, 0);
end;


// Check for internet connection

// Check for TradeLog website


// --------------------------------------------------------------------
// Parse JSON into a TStrings list of {1},{2},... each ready to parse
// --------------------------------------------------------------------
function ParseJSON(const s, sOpenDelim, sCloseDelim: string) : TStrings;
var
  i, j: integer;
  token: string;
begin
  if s = '' then exit;
  result := TStringList.Create;
  i := 1; // init
  while i <= length(s) do begin
    token := '';
    j := pos(sOpenDelim, s, i) + 1; // find start of object {
    if j < i then break;
    i := pos(sCloseDelim, s, j); // find end of object }
    if i < j then break;
    token := Copy( s, j, (i-j) ); // from { to }
    result.add(token);
    i := j + 1;
  end; // while loop
  if token <> '' then
    result.add(token);
end; // ParseJSON

function ParseJSON(const s: string) : TStrings; overload;
begin
  result := ParseJSON(s, '{', '}');
end;


// --------------------------------------------------------------------
// Parse a v2 API response into a TStrings list
// ASSUMES: the {braces} have already been removed
// --------------------------------------------------------------------
function ParseV2APIResponse(s: string): TStrings;
var
  i, j: integer;
  token: string;
begin
  if s = '' then exit; // nothing to do
  result := TStringList.Create;
  i := 1;
  j := 1;
  while i <= length(s) do begin
    token := '';
    if (s[i] = '"') then begin // string delimiter found
      j := i + 1; // starts after quote
      // find end of quote
      repeat i := i+1 until ((i > Length(s)) or (s[i] = '"'));
      token := Copy(s,j,(i-j));
      repeat i := i+1 until ((i > length(s)) or (s[i] = ',') or (s[i] = ':'));
      // find end of field
    end
    else begin // non-quoted field, so just look for ','
      if (s[i] = ',') or (s[i] = ':') then begin
        token := ' ';
      end
      else begin
        repeat i := i+1 until ((i > length(s)) or (s[i] = ',') or (s[i] = ':'));
        token := Copy(s, j, (i-j));
      end;
    end;
    result.add(token);
    j := i+1;
    i := j;
  end; // while loop
end; // ParseV2APIResponse
// --------------------------------------------------------------------
// postData returns the following responses:
// FAIL
//  "status":"error","message":"Wrong or missing email or password."
//  or {"status":"error","message":"Unauthorized"} <-- e.g. bad API key
// PASS
//  "status":"success",
//  "message":{"SubscriptionId":1910, ...}
// or just "SubscriptionId":1910, ...
// --------------------------------------------------------------------



// --------------------------------------------------------------------
// Format a v2 API response for paste / display
// --------------------------------------------------------------------
function FormatV2APIResponse(sJSON: string): string;
var
  sData : string;
begin
  if sJSON = '' then exit;
  sData := replacestr(sJSON, '[', '[' + CRLF);
  sData := replacestr(sData, ']', CRLF + ']');
  sData := replacestr(sData, '{', ' {' + CRLF);
  sData := replacestr(sData, '}', CRLF + ' }');
  sData := replacestr(sData, ',', ',' + CRLF);
  result := sData;
end; // FormatV2APIResponse



// ------------------------
// If in milliseconds since 1/1/1970 00:00:00...
function FastSpringToDate(s : string): TDateTime;
var
  v : integer;
begin
  if length(s) > 3 then
    s := leftstr(s, length(s)-3);
  v := StrToInt(s);
  if v < 0 then v := -v;
  result := (v/86400) + 25569;
end;


// --------------------------------------------------------------------
// Encrypt a password as used in the v2 API (testing only)
// --------------------------------------------------------------------
function GeneratePassword(sPwd : string): string; // 2024-08-27 MB - NOT USED
var
  sURL, sData, sStatus, s, APIKey : string;
  postData : AnsiString;
  postHead : TStringStream;
begin
  sURL := API_BASE + API_VER + 'auth/generatePassword';
  try
    postHead := TStringStream.Create('');
    with postHead do begin
      WriteString('api: ' + GetAPIKey + sLineBreak);
      WriteString('Content-Type: application/json' + sLineBreak);
      WriteString('charset: utf-8' + sLineBreak);
    end;
    // ----------------------------------------------------
    postData := '{"password" : "' + sPwd + '"}';
    // ----------------------------------------------------
    sStatus := ReadBrokerConnectPost(sURL, postHead, postData, 'POST');
    if Developer then begin
      clipboard.AsText := postData;
      sm(sURL + ' returned:' + CRLF + postData);
    end;
    if POS('200 OK', sStatus)= 1 then begin
      sData := postData;
      s := FormatV2APIResponse(sData);
    end
    else begin
      s := '';
    end;
  finally
    postHead.Free;
  end;
  result := s;
end; // GeneratePassword


// --------------------------------------------------------------------
// Login(email,pwd) API -- as of 8/18/2025
// returns JSON:
//{"SubscriptionId":1910,
// "UserToken":"eb923b18-7c4d-11f0-b9fd-f23c938e66e4",
// "CustomerId":10122,
// "Name":"Mark Blackston",
// "Subscription":"Subscription",
// "Sku":"1007",
// "product":"Elite",
// "Manager":136,
// "UserStartDateForTrial":"2022-11-29 19:36:31.280000",
// "StartDate":"2022-01-01 00:00:00",
// "EndDate":"2025-12-31 00:00:00",
// "CanceledDate":null,
// "Version":"20.4.1.0",
// "MinVersion":"020.04.00.00"}
// --------------------------------------------------------------------
function GetLogin(sEmail, sPwd : string): string;
var
  sURL, sData, sStatus, s, s1, sReply, t : string;
  postData : AnsiString;
  postHead : TStringStream;
  lineLst: TStrings;
  i, k, n : integer;
  // ----------------------------------
  procedure InitV2Vars();
  begin
    v2LoginPostData := '';
    v2LoginPostMsg := '';
    gbOffline := true; // assume offline until proven otherwise
    gbFreeTrial := true;
    gbExpired := true;
    // ----------------------
    v2UserToken := '';
    v2UserId := '';
    v2CustomerId := '';
    v2UserName := 'Unregistered';
    v2Subscription := 'Free Trial';
    v2SKU := '';
    v2Product := 'Free Trial';
    v2Manager := '0';
    ProVer := false;
    ProManager := false;
    SuperUser := false;
    // --- date strings -----
    s2CreateDate := '';
    s2StartDate := '';
    s2EndDate := '';
    s2CancelDate := '';
    // --- dates ------------
    v2StartDate := 0;
    v2EndDate := 0;
    v2CancelDate := 0;
    v2CreateDate := 0;
  end;
  // ----------------------------------
  procedure SetV2Vars();
  var
    j, v : integer;
    dtLst : TStrings;
    // ----------------------
    function APIdate(t: string): TDate;
    var
      Y, M, D : Word;
    begin
      result := 0;
      if length(t) < 8 then exit;
      if pos(' ',t) > 0 then
        t := leftstr(t,pos(' ',t)-1); // remove time
      if pos('-',t) > 0 then begin
        dtLst := parseCSV(t, '-');
        try
          Y := StrToInt(dtLst[0]);
          M := StrToInt(dtLst[1]);
          D := StrToInt(dtLst[2]);
          result := EncodeDate(Y, M, D);
        except
          sm('unable to convert ' + t + CRLF + 'to a YY-M-D date value.');
        end;
      end
      else if pos('/', t) > 0 then begin
        dtLst := parseCSV(t, '/');
        try
          Y := StrToInt(dtLst[2]);
          M := StrToInt(dtLst[0]);
          D := StrToInt(dtLst[1]);
          result := EncodeDate(Y, M, D);
        except
          sm('unable to convert ' + t + CRLF + 'to a M/D/YYYY date value.');
        end;
      end
      else begin // no delimiter
        try
          Y := StrToInt(Copy(t, 1, 4));
          M := StrToInt(Copy(t, 5, 2));
          D := StrToInt(Copy(t, 7, 2));
          result := EncodeDate(Y, M, D);
        except
          sm('unable to convert ' + t + CRLF + 'to a YYYYMMDD date value.');
        end;
      end;
    end; // -----------------
  begin
    // find/map fields
    k := 0;
    j := 0;
    while (j < (lineLst.Count-1)) do begin
      if (Uppercase(lineLst[j]) = 'USERTOKEN') then begin
        v2UserToken := lineLst[j+1];
        v2UserId := ''; //  GetCustomerId(v2UserToken);
//        v2CustomerId := v2UserId;
        k := k or 1;
      end
      else if (Uppercase(lineLst[j]) = 'CUSTOMERID') then begin //
        v2CustomerId := lineLst[j+1];
        k := k or 2;
      end
      else if (Uppercase(lineLst[j]) = 'NAME') then begin //
        v2UserName := lineLst[j+1];
//        t := GetEnvironmentVariable('USERNAME');
        k := k or 2;
      end
      else if (Uppercase(lineLst[j]) = 'SUBSCRIPTION') then begin //
        v2Subscription := lineLst[j+1];
        k := k or 4;
      end
      else if (Uppercase(lineLst[j]) = 'SKU') then begin //
        v2SKU := lineLst[j+1];
        k := k or 8;
      end
      else if (Uppercase(lineLst[j]) = 'PRODUCT') then begin //
        v2Product := lineLst[j+1];
        k := k or 16;
      end
      else if (Uppercase(lineLst[j]) = 'MANAGER') then begin //
        if (lineLst[j+1] = 'null') then
          v2Manager := '0'
        else
          v2Manager := lineLst[j+1];
        i := StrToIntDef(v2Manager, 0);
        ProVer := ((i and 1)=1);
        ProManager := ((i and 2)=2);
        SuperUser := ((i and 8)=8);
        Developer := ((i and 128)=128);
        k := k or 32;
      end
      else if (Uppercase(lineLst[j]) = 'USERSTARTDATEFORTRIAL') then begin //
        //  "UserStartDateForTrial":"20220607",
        s := lineLst[j+1]; // this one's in yyyymmdd format
        s2CreateDate := yyyymmddToUSDate(s);
        v2CreateDate := APIdate(s);
        k := k or 64;
      end
      else if (Uppercase(lineLst[j]) = 'STARTDATE') then begin //
        //  "StartDate":"2022-11-03 07:46:04.0970",
        s := lineLst[j+1]; //
        s2StartDate := yyyymmddToUSDate(s);
        v2StartDate := APIdate(s);
        k := k or 128;
      end
      else if (Uppercase(lineLst[j]) = 'ENDDATE') then begin //
        //  "EndDate":"2023-11-03 00:00:00.0000",
        s := lineLst[j+1]; //
        s2EndDate := yyyymmddToUSDate(s);
        v2EndDate := APIdate(s);
        k := k or 256;
      end
      else if (Uppercase(lineLst[j]) = 'CANCELEDDATE') then begin //
        //  "CanceledDate":"2022-11-03 08:28:10.5340"}
        s := lineLst[j+1]; //
        s2CancelDate := yyyymmddToUSDate(s);
        v2CancelDate := APIdate(s);
        k := k or 512;
      end;
      j := j + 2;
    end; // while
    v2ClientToken := v2UserToken; // until we open a file.
  end;
  // ------------------------
begin
  sURL := API_BASE + API_VER + 'users/login';
  // note: on 2024-05-17, IP was 2600:3c02::f03c:93ff:febd:3545
  InitV2Vars;
  try
    postHead := TStringStream.Create('');
    with postHead do begin
      WriteString('api: ' + GetAPIKey + sLineBreak);
      WriteString('Content-Type: application/json' + sLineBreak);
      WriteString('charset: utf-8' + sLineBreak);
    end;
    // ------------------------------------------
    postData := '{"Email" : "' + sEmail //
      + '","Password" : "' + sPwd //
      + '","version" : "' + gsVersion //
      + '"}';
    // ------------------------------------------
    v2LoginPostData := postData; // remember it
    sStatus := ReadBrokerConnectPost(sURL, postHead, postData, 'POST');
    // possibilities: offline, goodlogin(Trial, Active, or Expired), badlogin
    // if pos('"status":"error"', postData) > 0 then begin...
    //   if pos('"message":"Wrong email or password."', postData) > 0 then begin...
    //   end;
    // end;
// simulate being offline:
//postData := v2LoginPostData; // simulate offline
//sStatus := '502 BAD GATEWAY'; // 400 Bad Request';
    SaveDiagnostics(sEmail, sStatus);
    // --- timeout ------------------------------
    if (v2LoginPostData = postData) then begin
      v2LoginPostMsg := 'ERROR: unable to reach server before timeout.' + CR //
        + 'Switching to OFFLINE mode.';
      if sStatus = ''
      then v2LoginStatus := 'timed-out'
      else v2LoginStatus := sStatus;
      gbOffline := true;
      bCancelLogin := false;
      result := 'ERROR: timeout.';
      exit;
    end else begin
      v2LoginStatus := sStatus;
    end;
    // --- no response --------------------------
    if (postData = '') then begin
      v2LoginPostMsg := 'Server did not return user information.' + CR //
        + 'Switching to OFFLINE mode.';
      gbOffline := true;
      bCancelLogin := false;
      result := 'ERROR: unable to login.';
      exit;
    end;
    // --- check status -------------------------
    n := GetStatus(sStatus);
    if (n > 499) then begin
      gbOffline := true;
      bCancelLogin := false;
      if (n = 502) then begin
        v2LoginPostMsg := 'ERROR: 502 BAD GATEWAY'; // + FormatV2APIResponse(postData); //
        result := 'ERROR: Server gateway problem.';
      end
      else begin
        v2LoginPostMsg := 'Server error'; //
        result := 'ERROR: Server problem.';
      end;
      exit;
    end
    else if (n < 100) or (n > 399) then begin
      if pos('"message":"invalid password"', lowercase(postData)) > 0 then begin
        gbOffline := false;
        bCancelLogin := true;
        result := postData;
       sm('Incorrect password.');
      end
      else if pos('"message":"invalid email"', lowercase(postData)) > 0 then begin
        gbOffline := false;
        bCancelLogin := true;
        result := postData;
       sm('Email not recognized.');
      end
      else begin
        gbOffline := true;
        bCancelLogin := false;
        v2LoginPostMsg := 'ERROR: ' + postData + CR //
          + 'Switching to OFFLINE mode.'; // 2024-07-16 MB
        result := v2LoginPostMsg;
      end;
      exit;
    end;
    v2LoginPostMsg := sStatus; // not postData
    // --- check response for error -------------
    sReply := uppercase(postData);
    if (POS('"RESULT":"ERROR"', sReply) > 0) //
    or (POS('"STATUS":"ERROR"', sReply) > 0) //
//    or (POS('"MESSAGE":"UNEXPECTED TOKEN', sReply) > 0) //
    then begin
      v2LoginPostMsg := 'ERROR: ' + FormatV2APIResponse(postData); //
      gbOffline := false;
      bCancelLogin := true;
    end
    else begin // assume it worked
      s := ParseHtml(postData, '{','}');
      lineLst := ParseV2APIResponse(s);
//      if lineLst.Count = 4 then begin
//        s := uppercase(lineLst[0]);
//        if ((s = '"STATUS"') or (s = '"RESULT"')) //
//        and (POS('ERROR', uppercase(lineLst[1])) > 0) then
//
//      end;
      SetV2Vars; // <-- can't use Developer, SuperUser, etc. before this!
      if (k = 1023) then begin
        gbOffline := false;
        bCancelLogin := false;
      end
      else begin
        s := 'ERROR: login response is missing data';
        exit;
      end;
      s := FormatV2APIResponse(postData); //
    end;
  finally
    postHead.Free;
    if gbOffline then begin
      sm(v2LoginPostMsg);
//      clipboard.AsText := s; // postData;
//      k := messagedlg('TradeLog was unable to log you in at this time.' + CRLF //
//       + 'If you believe this is in error, submit a request' + CRLF //
//       + 'for assistance to TradeLog Customer Support.' + CRLF //
//       + 'Would you like to send that request now?', mtWarning, [mbYes,mbNo], 0);
//      if k = 6 then
        gbGetSupportNow := true;
//      else
//        gbGetSupportNow := false;
    end; // if gbOffline
  end; // finally
  // ------------------------
  result := s;
end; // GetLogin


// GetSubscriptions
// [{
//   "UserToken":"201a28b8-9c26-11ed-929d-f23c938e66e4",
//   "CustomerId":20050,
//   "OrderId":"rg97Yu6MQGuXujcrSaWGhQ",
//   "Product":"investor",
//   "Sku":"1005",
//   "StartDate":1670104499397,
//   "EndDate":1701561600000,
//   "DateCreated":1670104501079
// }]

// --------------------------------------------------------------------
// User -> subscriptions
// This is a list of ???
//
//  brokerconnect.live/api/v2/users/subscriptions
//
// Json request POST
//  {"UserToken" : "35bcd5ed-37f4-11ed-942aslf"}
//
// Response
// [{"UserToken": "c4a2c4ed-326f-11ed-b243-088fc34537c8",
//  "CustomerId": 2, "OrderId": "123", "Product": "theProduct",
//  "Sku": "theSku", "StartDate": 16593984000, "EndDate": 16593984000,
//  "DateCreated": null}]
// OR
//  {"message": "No matching records!"}
// --------------------------------------------------------------------
function GetSubscriptions(sUserToken : string): string;
var
  sURL, sData, sStatus, s : string;
  postData : AnsiString;
  postHead : TStringStream;
  i : integer;
begin
  sURL := API_BASE + API_VER + 'users/subscriptions';
  try
    postHead := TStringStream.Create('');
    with postHead do begin
      WriteString('api: ' + GetAPIKey + sLineBreak);
      WriteString('Content-Type: application/json' + sLineBreak);
      WriteString('charset: utf-8' + sLineBreak);
    end;
    // ----------------------------------------------------
    postData := '{"UserToken": "' + sUserToken + '"}';
    sData := postData;
    // ----------------------------------------------------
    sStatus := ReadBrokerConnectPost(sURL, postHead, postData, 'POST');
    s := uppercase(postData);
    if POS('200 ', sStatus) = 1 then begin
      result := postData;
    end
    else begin
      if pos('ERROR', s) > 0 then
        result := postData
      else if length(s) < 4 then
        result := 'ERROR: ' + sStatus
      else
        result := 'ERROR: ' + postData;
    end;
  finally
    postHead.Free;
  end;
end; // GetSubscriptions


function GetCustomerId(sToken : string): string; // 2024-03-04 MB
var
  s : string;
  lineLst : TStrings;
  i : integer;
begin
  result := '';
  // --- GetSubscriptions ---------------------------------
  // [{"UserToken":"201a28b8-9c26-11ed-929d-f23c938e66e4",
  //   "CustomerId":20050,
  //   ...
  s := GetSubscriptions(sToken);
  s := ParseHtml(s, '{', '}');
  lineLst := ParseV2APIResponse(s);
  for i := 0 to lineLst.Count-1 do begin
    if uppercase(lineLst[i]) = 'CUSTOMERID' then begin
      result := lineLst[i+1];
      break;
    end;
  end;
end;


// ListAllUsers
// [{
//   "UserId":8244,
//   "CustomerId":20050,
//   "Name":"Virender Mann",
//   "Email":"virender@mannrei.com",
//   "Manager":0,
//   "DateCreated":1670104500953
// }]

// --------------------------------------------------------------------
// Auth -> list all users
// List all the users of a customer
//
// brokerconnect.live/api/v2/auth/listAllUsers
//
// Json request POST
// {"UserToken": "UserToken"}
//
//  Response
// [{"UserId": 13986,
//  "CustomerId": 2,
//  "Name": "dpreiss",
//  "Email": "damian@e-daptive.com",
//  "Manager": 1,
//  "DateCreated": 1662998154391
// },{...}]
// OR
// {"Error": "Please check the user token"}
// --------------------------------------------------------------------
function ListAllUsers(sUserToken : string): string;
var
  sURL, sData, sStatus, s : string;
  postData : AnsiString;
  postHead : TStringStream;
//  lineLst: TStrings;
//  i : integer; // longint;
begin
  sURL := API_BASE + API_VER + 'auth/listAllUsers';
  try
    postHead := TStringStream.Create('');
    with postHead do begin
      WriteString('api: ' + GetAPIKey + sLineBreak);
      WriteString('Content-Type: application/json' + sLineBreak);
      WriteString('charset: utf-8' + sLineBreak);
    end;
    // ----------------------------------------------------
    postData := '{"UserToken": "' + sUserToken + '"}';
    // ----------------------------------------------------
    sStatus := ReadBrokerConnectPost(sURL, postHead, postData, 'POST');
    s := uppercase(postData);
    if POS('200 ', sStatus) = 1 then begin
      result := postData;
    end
    else begin
      if pos('ERROR', s) > 0 then
        result := postData
      else if length(s) < 4 then
        result := 'ERROR: ' + sStatus
      else
        result := 'ERROR: ' + postData;
    end;
  finally
    postHead.Free;
  end;
end; // ListAllUsers


// --------------------------------------------------------------------
// INSERT a new client OR UPDATE an existing client.
// Accountants (Users) working for a Firm (Customer), all using one
// (Pro) subscription.
//
//  URL: brokerconnect.live/api/v2/users/insert // INS
// OR brokerconnect.live/api/v2/users/update // UPD
//
// JSON param POST
// { 'UserToken': <UserToken>, 'Name': 'some Name',
// 'Email': 'email@me.now, 'Password': 'password }
//
// Response
// {"results": "Success",
// "message": "Successfully Inserted or Updated User: 13986234234"}
//
// There are 3 responses:
// 1. UserToken doesn't exist
// 2. User is not a manager.
// 3. Successfully Inserted or Updated User: 12345 (number is UserId)
//
// This is NOT adding NEW CUSTOMERS - only USERS of a CUSTOMER
// ONLY v2Manager (and SuperUser?) can add/update users (see GetLogin)
// --------------------------------------------------------------------
function ManageUsers(sFunc, sUserToken, sName, sEmail, sPwd : string): string; // 2024-08-27 MB - NOT USED
var
  sURL, sData, sStatus, s : string;
  postData : AnsiString;
  postHead : TStringStream;
begin
  if sFunc = 'INS' then
    sURL := API_BASE + API_VER + 'users/insert'
  else if sFunc = 'UPD' then
    sURL := API_BASE + API_VER + 'users/update'
  else
    exit('ERROR: Unknown function call in PutUser.');
  try
    postHead := TStringStream.Create('');
    with postHead do begin
      WriteString('api_key: ' + GetAPIKey + sLineBreak);
      WriteString('Content-Type: application/json' + sLineBreak);
      WriteString('charset: utf-8' + sLineBreak);
    end;
    // ----------------------------------------------------
    postData := '{"UserToken": "' + sUserToken //
      + '","Name" : "' + sName //
      + '","Email" : "' + sEmail //
      + '","Password" : "' + sPwd + '"}';
    // ----------------------------------------------------
    sStatus := ReadBrokerConnectPost(sURL, postHead, postData, 'POST');
    if Developer then begin
      clipboard.AsText := postData;
      sm(sURL + ' returned:' + CRLF + postData);
    end; // -----------------
    if POS('200 OK', sStatus)= 1 then begin
      sData := postData;
      s := 'ManageUsers' + CRLF + FormatV2APIResponse(postData);
    end
    else begin
      s := 'ERROR: ' + sStatus;
    end;
  finally
    postHead.Free;
  end;
  result := s;
end; // ManageUsers


// --------------------------------------------------------
// User -> Customer Clients
//
// brokerconnect.live/api/v2/users/clients
//
// JSON request POST
// {"UserToken" : "35bcd5ed-37f4-11ed-942adsfd}
//
// Response
// [{
//  "UserToken": "35bcd5ed-37f4-11ed-942c-f23c938e66e5",
//  "UserId": 14002,
//  "UserName": "J",
//  "Email": "J@email.org",
//  "ClientId": 8234579,
//  "Name": "Mark Blackston"
// }]
// This is a list of the Clients used for brokerconnect.
// A customer can have multiple clients.
// --------------------------------------------------------
//function ListAllClients(sUserToken : string): string; // 2024-08-27 MB - NOT USED
//var
//  sURL, sData, sStatus, s : string;
//  postData : AnsiString;
//  postHead : TStringStream;
//  lineLst: TStrings;
//  i : integer; // longint;
//begin
//  sURL := API_BASE + API_VER + 'users/clients';
//  try
//    postHead := TStringStream.Create('');
//    with postHead do begin
//      WriteString('api: ' + GetAPIKey + sLineBreak);
//      WriteString('Content-Type: application/json' + sLineBreak);
//      WriteString('charset: utf-8' + sLineBreak);
//    end;
//    // ----------------------------------------------------
//    postData := '{"UserToken": "' + sUserToken + '"}';
//    // ----------------------------------------------------
//    sStatus := ReadBrokerConnectPost(sURL, postHead, postData, 'POST');
//    if Developer then begin
//      clipboard.AsText := postData;
//      sm(sURL + ' returned:' + CRLF + postData);
//    end; // -----------------
//    if POS('200 OK', sStatus)= 1 then begin
//      s := ParseHtml(postData, '{','}');
//      lineLst := ParseV2APIResponse(s);
//      s := 'ListAllClients' + CRLF + FormatV2APIResponse(postData);
//    end
//    else begin
//      s := 'ERROR: ' + sStatus;
//    end;
//  finally
//    postHead.Free;
//  end;
//  result := s;
//end; // ListAllUsers


// --------------------------------------------------------
//  Clients -> List All Clents
//  List all clients for given Customer
//
//  brokerconnect.live/api/v2/clients/getAllClients
//
// Json request POST
//  {"UserToken" : "a5db0a14-3817-11ed-942c-f23c938e66e4",}
//
// Response
// {"data": [
//  {"ClientId": 20893,
//   "CustomerId": 2,
//   "Name": "John",
//   "Broker": Fidelity,
//   "Internal": null
//  },
//  {"ClientId": 8579,
//   "CustomerId": 2,
//   "Name": "Mark asdfasf",
//   "Broker": Robinhood,
//   "Internal": null
//  }
// ]}
//  ...
// OR
// {"Message": "No clients for this Customer."}
// --------------------------------------------------------



// --------------------------------------------------------
//  This is a list of the Clients used for brokerconnect.
// A customer can have multiple clients.
//
//  brokerconnect.live/api/v2/users/subscriptions
//
//  Json request POST
// {"UserToken" : "35bcd5ed-37f4-11ed-942aslf"}
//
// Response
// [{
//  "UserToken": "c4a2c4ed-326f-11ed-b243-088fc34537c8",
//  "CustomerId": 2,
//  "OrderId": "123",
//  "Product": "theProduct",
//  "Sku": "theSku",
//  "StartDate": 16593984000,
//  "EndDate": 16593984000,
//  "DateCreated": null
// }]
//
// OR
//  {"message": "No matching records!"}
// --------------------------------------------------------


// --------------------------------------------------------
// Clients -> Insert
// Insert a new client
//
// URL := brokerconnect.live/api/v2/users/insert // INS
// OR brokerconnect.live/api/v2/users/update // UPD
//
// This is NOT adding NEW CUSTOMERS. (CUSTOMERS are added
// on either a purchase or the LOGIN above). These are
// clients of a Customer.
//
// JSON param POST:
// { 'UserToken': UserToken,
// 'Name': 'some Name',
// 'Email': 'email@me.now,
// 'Password': 'very secret password }
//
// Response
// { "results": "Success",
// "message": "Successfully Inserted or Updated User: 13986234234" }
//
// There are 3 responses:
// 1. UserToken doesn't exist
// 2. User is not a manager.
// 3. Successfully Inserted or Updated User: 12345 (number is UserId)
// --------------------------------------------------------
//function ManageClients(sFunc, sUserToken, sName, sEmail, sPwd : string): string; // 2024-08-27 MB - NOT USED
//var
//  sURL, sData, sStatus, s : string;
//  postData : AnsiString;
//  postHead : TStringStream;
//begin
//  sURL := API_BASE + API_VER + 'users/update';
//  try
//    postHead := TStringStream.Create('');
//    with postHead do begin
//      WriteString('api_key: ' + GetAPIKey + sLineBreak);
//      WriteString('Content-Type: application/json' + sLineBreak);
//      WriteString('charset: utf-8' + sLineBreak);
//    end;
//    // ----------------------------------------------------
//    postData := '{"UserToken" : "' + sUserToken //
//      + '","Name" : "' + sName + '"' //
//      + '","Email" : "' + sEmail //
//      + '","Password" : "' + sPwd + '"}';
//    // ----------------------------------------------------
//    sStatus := ReadBrokerConnectPost(sURL, postHead, postData, 'POST');
//    if Developer then begin
//      clipboard.AsText := postData;
//      sm(sURL + ' returned:' + CRLF + postData);
//    end; // -----------------
//    if POS('200 OK', sStatus)= 1 then begin
//      sData := postData;
//      s := 'ManageClients' + CRLF + FormatV2APIResponse(postData);
//    end
//    else begin
//      s := '';
//    end;
//  finally
//    postHead.Free;
//  end;
//  result := s;
//end; // UpdateClient


// --------------------------------------------------------
// User -> tax file keys
// A list of tax file keys
//
// API_BASE + 'filekeys/
// API_BASE + 'users/taxfiles_list
//
//  Json request POST
//  {"UserToken" : "35bcd5ed-37f4-11ed-942aslf"}
//
// Response
// [{"FileKeyId": 1, "OrderId": "1", "CustomerId": 2,
//  "Sku": "100", "Product": "FileKey", "FreeFileKey": 0,
//  "FileCode": "FileCode", "FileName": "FileName",
//  "TaxPayer": "TaxPayer", "TaxYear": 234,
//  "DateUsed": "2021-12-31T21:00:00.000Z",
//  "FuncCode": "aldf", "Reason": "aldjf",
//  "TrackingCode": "lajdf", "Accountant": "aldjf",
//  "CanceledDate": null, "DateCreated": 20220101,
//  "UserToken": "c4a2c4ed-326f-11ed-b243-088fc34537c8"
// },
// {"FileKeyId": 3, ... }]
// --------------------------------------------------------

function ListFileKeys(sUserToken : string): string;
var
  sURL, sData, sStatus, s : string;
  postData : AnsiString;
  postHead : TStringStream;
  FKeyLst, lineLst: TStrings;
  i : integer; // longint;
begin
  sURL := API_BASE + API_VER + 'filekeys/';
  try
    postHead := TStringStream.Create('');
    with postHead do begin
      WriteString('api: ' + GetAPIKey + sLineBreak);
      WriteString('Content-Type: application/json' + sLineBreak);
      WriteString('charset: utf-8' + sLineBreak);
    end;
    // ----------------------------------------------------
    postData := '{"UserToken": "' + sUserToken + '"}';
    // ----------------------------------------------------
    sData := postData; // save for troubleshooting
    sStatus := ReadBrokerConnectPost(sURL, postHead, postData, 'POST');
//    if Developer then begin
//      clipboard.AsText := leftstr(postData, 800);
//      sm(sURL + ' returned:' + CRLF + postData);
//    end; // -----------------
    if POS('200 ', sStatus)= 1 then begin // 200 is all that matters; OK not required
      s := 'ListFileKeys' + CRLF + FormatV2APIResponse(postData);
    end
    else begin
      s := 'ERROR: ' + sStatus;
    end;
  finally
    postHead.Free;
  end;
  result := postData;
end; // ListFileKeys


// --------------------------------------------------------
// RETURNS:
// [{"UserToken": "999185f9b-f1ac-11ec-870c-f23c92dd5fb6",
//   "FileCode": "d5bdc750-2dbf-11ed-942c-f23c938e66e4",
//   "FileName": null,
//   "TaxPayer": null,
//   "TaxYear": 2026,
//   "DateUsed": null,
// }]
// OR {"message": "No matching records!"}
// --------------------------------------------------------
//function AvailableFileKeys(sUserToken : string): string;
//var
//  sURL, sData, sStatus, s : string;
//  postData : AnsiString;
//  postHead : TStringStream;
//  fileKeys, lineLst: TStrings;
//  i : integer; // longint;
//begin
//  sURL := API_BASE + API_VER + 'filekeys/available';
//  try
//    postHead := TStringStream.Create('');
//    with postHead do begin
//      WriteString('api: ' + GetAPIKey + sLineBreak);
//      WriteString('Content-Type: application/json' + sLineBreak);
//      WriteString('charset: utf-8' + sLineBreak);
//    end;
//    // ----------------------------------------------------
//    postData := '{"UserToken": "' + sUserToken + '"}';
//    // ----------------------------------------------------
//    sStatus := ReadBrokerConnectPost(sURL, postHead, postData, 'POST');
//    if Developer then begin
//      clipboard.AsText := postData;
//      sm(sURL + ' returned:' + CRLF + postData);
//    end; // -----------------
//    if POS('200 OK', sStatus)= 1 then begin
//      s := 'ListFileKeys' + CRLF + FormatV2APIResponse(postData);
//      lineLst := ParseV2APIResponse(postData);
//    end
//    else begin
//      s := 'ERROR: ' + sStatus;
//    end;
//  finally
//    postHead.Free;
//  end;
//  result := s;
//end; // ListFileKeys


function AvailableFileKeys2(sUserToken : string): integer;
var
  sTmp: string;
  i : integer;
  FKeyLst, lineLst : TStrings;
begin
  result := 0;
  sTmp := ListFileKeys(v2UserToken);
  FKeyLst := ParseJSON(sTmp); // {FileKey1},{FileKey2}...
  for i := 0 to FKeyLst.Count-1 do begin
    sTmp := FKeyLst[i];
    lineLst := ParseV2APIResponse(sTmp);
    if assigned(lineLst)=false then continue;
    if lineLst.Count > 13 then begin
      if (lineLst[7] = '') and (lineLst[13] = 'null') //
      then result := result + 1;
    end; // if
  end; // for
end; // ListFileKeys


// --------------------------------------------------------
// brokerconnect.live/api/v2/logs
// Json request POST
// JSON requests
//  {"UserToken": "4fa37067-75f8-11ed-b13e-f23c938e66e4",
//   "Category": "FileKeys", optional on Action=SELECT
//   "Message": "This is my second message",
//   optional on Action=SELECT, DELETE
//   "Action": "SELECT" or "INSERT" or "DELETE"
//  }
// Response
// ERROR
//  [{"error": "The UserToken doesn't exist."}]
// OR
// SUCCESS
// Action=SELECT
//  [{"LogId": 1,
//    "CustomerId": 100,
//    "Category": "FileKeys",
//    "Message": "This is my first message",
//    "DateCreated": "23-01-13"
//   },
//   {"LogId": 2,
//    "CustomerId": 100,
//    "Category": "FileKeys",
//    "Message": "This is my second message",
//    "DateCreated": "23-01-13"
//   }
//  ]
// Action=INSERT
//  [{"success": "Inserted log"}]
// Action=DELETE
//  [{"success": "Deleted log"}]
// --------------------------------------------------------
function LogEntry(sUserToken, sCategory, sMessage, sAction : string): string;
var
  sURL, sData, sStatus, s : string;
  postData : AnsiString;
  postHead : TStringStream;
//  fileKeys, lineLst: TStrings;
//  i : integer; // longint;
begin
  sURL := API_BASE + API_VER + 'logs';
  try
    postHead := TStringStream.Create('');
    with postHead do begin
      WriteString('api: ' + GetAPIKey + sLineBreak);
      WriteString('Content-Type: application/json' + sLineBreak);
      WriteString('charset: utf-8' + sLineBreak);
    end;
    // ----------------------------------------------------
    postData := '{' //
      + '"UserToken": "' + sUserToken + '"'
      + ',"Category":"' + sCategory + '"'
      + ',"Message":"' + sMessage + '"'
      + ',"Action":"' + sAction + '"'
      + '}';
    // ----------------------------------------------------
    sStatus := ReadBrokerConnectPost(sURL, postHead, postData, 'POST');
    if POS('200 OK', sStatus)= 1 then begin
      s := 'Logs ' + sAction + CRLF + postData;
    end
    else begin
      s := 'ERROR: ' + sStatus;
    end;
  finally
    postHead.Free;
  end;
  result := s;
end;


// --------------------------------------------------------
//  updates a FileKey
//  URL = brokerconnect.live/api/v2/filekeys/update
//  -- Json request POST --

// updated documentation:
// {
//  "UserToken": "<userToken>",
//  "Email":"<userEmail-matches Token>",
//  "FileCode":"<FileKeyId-matches Token>",
//  "FileName":"<text: sFileName>",
//  "TaxPayer":"<text: sTaxPayer>",
//  "TaxYear":"<text: sTaxYear>"
// }
//  -- Response --
// {
//   "fieldCount": 0,
//   "affectedRows": 1,
//   "insertId": 0,
//   "info": "",
//   "serverStatus": 2,
//   "warningStatus": 0
// }
// --------------------------------------------------------
function UpdateFileKey(sUserToken, sEmail, sFileCode, sFileName, sTaxPayer, sTaxYear : string): string;
var
  sURL, sData, sStatus, s : string;
  postData : AnsiString;
  postHead : TStringStream;
  fileKeys, lineLst: TStrings;
  i : integer; // longint;
begin
  sURL := API_BASE + API_VER + 'filekeys/update';
  try
    postHead := TStringStream.Create('');
    with postHead do begin
      WriteString('api: ' + GetAPIKey + sLineBreak);
      WriteString('Content-Type: application/json' + sLineBreak);
      WriteString('charset: utf-8' + sLineBreak);
    end;
    // ----------------------------------------------------
    postData := '{"UserToken": "' + sUserToken + '"'
      + ',"Email":"' + sEmail + '"'
      + ',"FileCode":"' + sFileCode + '"'
      + ',"FileName":"' + sFileName + '"'
      + ',"TaxPayer":"' + sTaxPayer + '"'
      + ',"TaxYear":"' + sTaxYear + '"'
      + '}';
    // ----------------------------------------------------
    sStatus := ReadBrokerConnectPost(sURL, postHead, postData, 'POST');
    if Developer then begin
      clipboard.AsText := postData;
      sm(sURL + ' returned:' + CRLF + postData);
    end; // -----------------
    if POS('200 ', sStatus)= 1 then begin
      s := 'UpdateFileKey:' + CRLF + FormatV2APIResponse(postData);
    end
    else begin
      LogEntry(v2UserToken, 'ERROR', 'UpdateFileKey:' + sFileCode, 'UPDATE');
      LogEntry(v2UserToken, 'ERROR', 'API Response:' + s, 'UPDATE');
      s := 'ERROR: ' + sStatus;
    end;
  finally
    postHead.Free;
  end;
  result := s;
end; // UpdateFileKey

// ----------------------------------------------
// {
//  "UserToken": "999185f9b-f1ac-11ec-870c-f23c92dd5fb6999",
//  "FileCode": "54ca573e-2cfb-11ed-bd95-f23c938e66e4",
//  "FuncCode": null,
//  "Reason": null,
//  "Comment": null,
//  "TrackingCode": null,
//  "Accountant": "Bob the accountant"
// }
// -- Response --
// [{"Exists": 0, "message": "This filekey has been canceled."}]
//  OR
// [{"Exists": 0,"message": "Either the User doesn't exist or the User doesn't have access to this FileKey."}]
// ----------------------------------------------
function InsertFileKeyLog(sUserToken, sFileCode, sFunc, sReason, sComment, sTracking, sAcct : string): string;
var
  sURL, sData, sStatus, s : string;
  postData : AnsiString;
  postHead : TStringStream;
  fileKeys, lineLst: TStrings;
  i : integer; // longint;
begin
  sURL := API_BASE + API_VER + 'filekeys/insert_log';
  try
    postHead := TStringStream.Create('');
    with postHead do begin
      WriteString('api: ' + GetAPIKey + sLineBreak);
      WriteString('Content-Type: application/json' + sLineBreak);
      WriteString('charset: utf-8' + sLineBreak);
    end;
    // ----------------------------------------------------
    if sFileCode = '' then begin
      result := 'ERROR: ' + 'no FileCode';
      exit;
    end;
    postData := '{' //
      + '"UserToken": "' + sUserToken + '"'
      + ',"FileCode":"' + sFileCode + '"'
      + ',"FuncCode":"' + sFunc + '"'
      + ',"Reason":"' + sReason + '"'
      + ',"Comment":"' + sComment + '"'
      + ',"TrackingCode":"' + sTracking + '"'
      + ',"Accountant":"' + sAcct + '"'
      + '}';
    // ----------------------------------------------------
    sStatus := ReadBrokerConnectPost(sURL, postHead, postData, 'POST');
    if Developer then begin
      clipboard.AsText := postData;
      sm(sURL + ' returned:' + CRLF + postData);
    end; // -----------------
    if POS('200 ', sStatus)= 1 then begin
      sData := uppercase(postData);
//      replacestr(sData, 'DOESN''T', 'DOES NOT');
      if POS('HAVE ACCESS TO THIS FILEKEY', sData) > 0 then begin
        s := 'ERROR: ' + sStatus;
      end
      else begin
        s := 'ListFileKeys' + CRLF + FormatV2APIResponse(postData);
        lineLst := ParseV2APIResponse(postData);
      end;
    end
    else begin
      s := 'ERROR: ' + sStatus;
    end;
  finally
    postHead.Free;
  end;
  result := s;
end;


// ----------------------------------------------
//  Purpose: Lists the FileKey Logs
//  URL: API_BASE + 'filekeys/select_log
// Json request POST
// {"UserToken":"e3655730-6b2a-11ed-8efe-f23c938e66e4",
//  "FileCode":"3b55362b-666c-11ed-8b53-f23c92dd5fb6"}
// ----------------------------------------------
function GetFileKeyLog(sUserToken, sFileCode : string): string;
var
  sURL, sData, sStatus, s : string;
  postData : AnsiString;
  postHead : TStringStream;
  fileKeys, lineLst: TStrings;
  i : integer; // longint;
begin
  sURL := API_BASE + API_VER + 'filekeys/select_log';
  try
    postHead := TStringStream.Create('');
    with postHead do begin
      WriteString('api: ' + GetAPIKey + sLineBreak);
      WriteString('Content-Type: application/json' + sLineBreak);
      WriteString('charset: utf-8' + sLineBreak);
    end;
    // ----------------------------------------------------
    postData := '{' //
      + '"UserToken": "' + sUserToken + '"'
      + ',"FileCode":"' + sFileCode + '"'
      + '}';
    // ----------------------------------------------------
    sStatus := ReadBrokerConnectPost(sURL, postHead, postData, 'POST');
    if Developer then begin
      clipboard.AsText := postData;
      sm(sURL + ' returned:' + CRLF + postData);
    end; // -----------------
    if POS('200 ', sStatus)= 1 then begin
      sData := uppercase(postData);
      if POS('HAVE ACCESS TO THIS FILEKEY', sData) > 0 then begin
        s := 'ERROR: ' + sStatus;
      end
      else begin
        s := FormatV2APIResponse(postData);
        lineLst := ParseV2APIResponse(postData);
      end;
    end
    else begin
      s := 'ERROR: ' + sStatus;
    end;
  finally
    postHead.Free;
  end;
  result := s;
end;


// --------------------------------------------------------
// Returns
//  {"results": "success","message": [
//   {"FileKeyId": 32877,
//    "ByCustomerId": 20071,
//    "ForCustomerId": 20071,
//    "FuncCode": "Write",
//    "Reason": "End Tax Year",
//    "TrackingCode": "",
//    "Comment": "2021 Robert",
//    "Accountant": "",
//    "DateCreated": "2022-12-07T15:07:50.583Z"},
// OR
//  {"results": "error","message":[
//   {"Exists": 0,"message": "Either the User doesn't exist or
//                 the User doesn't have access to this FileKey."}
//  ]}
// --------------------------------------------------------


          // ----------+
          //   Super   |
          //   Users   |
          // ----------+

// In the Header section:
// api: API_KEY
// superuser: UQ@5v28RyH3jG8505zr!M&o#$x*?#T

// --------------------------------------------------------
// SuperUser -> impersonate user
// SuperUser gains control over a customer's account
//
//   API_BASE + 'superuser/impersonate
//
// The results will return 3 possibilities:
//  1. 0 - not a SuperUser
//  2. null - Incorrect Email
//  3. UserToken
//
// JSON request POST
// { "UserToken": "bfbec44d-5554-11ed-8b53-f23c92dd5fb6s", (SuperUser's UserToken)
//   "Email": "name@email.com", (Customer to impersonate)
// }
//
// Returns: UserToken to impersonate
// e.g. "bfbec44d-5554-11ed-8b53-f23c92dd5fb6"
// OR   {"message": "This is ONLY for SuperUsers."}
// OR   {"message": "Email doesn't exist."}
// --------------------------------------------------------
function Impersonate(sEmail : string): string;
var
  sURL, sData, sStatus, s : string;
  postData : AnsiString;
  postHead : TStringStream;
  i, iRetries : integer; // longint;
begin
  iRetries := 1;
  sURL := API_BASE + API_VER + 'superuser/impersonate';
  try
    postHead := TStringStream.Create('');
    with postHead do begin
      WriteString('api: ' + GetAPIKey + sLineBreak);
      WriteString('superuser: ' + SUPER_KEY + sLineBreak);
      WriteString('Content-Type: application/json' + sLineBreak);
    end;
    // ----------------------------------------------------
    postData := '{"UserToken":"' + v2UserToken //
      + '","Email" : "' + sEmail + '"}';
    // ----------------------------------------------------
    s := postData; // save for retries
    while iRetries < 3 do begin
      sStatus := ReadBrokerConnectPost(sURL, postHead, postData, 'POST');
      if POS('200 ', sStatus)= 1 then break; // out of loop
      sleep(500); // 0.500 sec
      inc(iRetries);
      postData := s; // restore postData before retry
    end;
    if length(postData) < 13 then begin
      postData := s; // try again
      sStatus := ReadBrokerConnectPost(sURL, postHead, postData, 'POST');
    end;
    if length(postData) < 13 then begin
      postData := s; // wait, then try again
      sleep(500); // 0.500 sec
      sStatus := ReadBrokerConnectPost(sURL, postHead, postData, 'POST');
    end;
    sData := uppercase(postData);
    if POS('200 ', sStatus)= 1 then begin
      if length(postData) < 13 then
        if SuperUser then
          result := postData
        else
          result := 'ERROR: unable to retrieve user data.'
      else if POS('ERROR', sData) > 0 then
        result := postData
      else if POS('400 ', sStatus) = 1 then
        result := 'ERROR: '  + sStatus + ';' + postData
      else // success!
        result := copy(postData, 2, length(postData)-2);
    end
    else begin // Status NOT 200
      result := 'ERROR: ' + sStatus;
    end;
  finally
    postHead.Free;
  end;
end; // Impersonate


// --------------------------------------------------------
// SuperUser -> Change customer email
// URL = API_BASE + 'superuser/email_change
//
// JSON request POST
// {"UserToken": "4fa37067-75f8-11ed-b13e-f23c938e66e4",
//  "Old_Email": "jayvan0279@gmail.com",
//  "New_Email": "jayvan0279@gmail.comNEW"
// }
// Response
// [{"response": "success",
//  "msg": "The Email, filekeys and subscriptions has been updated from jayvan0279@gmail.com to jayvan0279@gmail.comNEW"
// }]
// OR
// [{"response": "error",
//  "msg": "The old customer email does not exist: jayvan0279@gmail.com"
// }]
// --------------------------------------------------------
function SuperChangeEmail(sOldEmail, sNewEmail : string): string;
var
  sURL, sData, sStatus, s : string;
  postData : AnsiString;
  postHead : TStringStream;
  lineLst: TStrings;
  i : integer; // longint;
begin
  sURL := API_BASE + API_VER + 'superuser/email_change';
  if trim(v2ClientToken)= '' then exit; // still blank
  try
    postHead := TStringStream.Create('');
    with postHead do begin
      WriteString('api: ' + GetAPIKey + sLineBreak);
      WriteString('superuser: ' + SUPER_KEY + sLineBreak);
      WriteString('Content-Type: application/json' + sLineBreak);
      WriteString('charset: utf-8' + sLineBreak);
    end;
    // ----------------------------------------------------
    postData := '{"UserToken": "' + v2UserToken + '"'
      + ',"Old_Email":"' + sOldEmail //
      + '","New_Email":"' + sNewEmail //
      + '"}';
    // ----------------------------------------------------
    sStatus := ReadBrokerConnectPost(sURL, postHead, postData, 'POST');
    if Developer then begin
      clipboard.AsText := postData;
      sm(sURL + ' returned:' + CRLF + postData);
    end; // -----------------
    if POS('200 OK', sStatus)= 1 then begin
      s := postData;
    end
    else begin
      s := 'ERROR: ' + sStatus + CR + postData;
    end;
  finally
    postHead.Free;
  end;
  result := s;
end; // SuperChangeEmail


// --------------------------------------------------------
// SuperUser -> Change customer email
// URL = API_BASE + 'superuser/email_change
//
// JSON request POST
// {"UserToken": "4fa37067-75f8-11ed-b13e-f23c938e66e4", -- superuser
//  "Email": "siddharth.sarna@gmail.com", -- customer's Email
//  "FreeFileKey": "True" -- or "False" }
// Response
// [{"FileKeyId": 33409,
//   "OrderId": "Support Staff: ralph@tradelog.com : 2023-01-11 19:47:05",
//   "CustomerId": 13511,
//   "CustId": null,
//   "Sku": 1000,
//   "Product": "file-key",
//   "FreeFileKey": 1,
//   "FileCode": "94bd490f-91cf-11ed-8eb6-088fc34537c8",
//   "FileName": null,
//   "TaxPayer": null,
//   "TaxYear": null,
//   "Accountant": null,
//   "DateUsed": null,
//   "CanceledDate": null,
//   "DateCreated": 1673455625804
// }]
// OR
// [{"response": "error",
//  "msg": "The old customer email does not exist: jayvan0279@gmail.com"
// }]
// --------------------------------------------------------
function SuperInsertFileKey(sEmail, sFreeFileKey : string): string;
var
  sURL, sData, sStatus, s : string;
  postData : AnsiString;
  postHead : TStringStream;
  fileKeys, lineLst: TStrings;
  i : integer; // longint;
begin
  sURL := API_BASE + API_VER + 'superuser/filekey_add';
  if trim(sEmail)= '' then exit; // still blank
  if trim(sFreeFileKey)= '' then sFreeFileKey := '1'; // default
  try
    postHead := TStringStream.Create('');
    with postHead do begin
      WriteString('api: ' + GetAPIKey + sLineBreak);
      WriteString('superuser: ' + SUPER_KEY + sLineBreak);
      WriteString('Content-Type: application/json' + sLineBreak);
      WriteString('charset: utf-8' + sLineBreak);
    end;
    // ----------------------------------------------------
    postData := '{"UserToken": "' + v2UserToken + '"'
      + ',"Email":"' + sEmail //
      + '","FreeFileKey":"' + sFreeFileKey + '"}';
    // ----------------------------------------------------
    sStatus := ReadBrokerConnectPost(sURL, postHead, postData, 'POST');
    if Developer then begin
      clipboard.AsText := postData;
      sm(sURL + ' returned:' + CRLF + postData);
    end; // -----------------
    if POS('200 OK', sStatus)= 1 then begin
      s := postData;
    end
    else begin
      s := 'ERROR: ' + sStatus + CR + postData;
    end;
  finally
    postHead.Free;
  end;
  result := s;
end; // SuperInsertFileKey


// --------------------------------------------------------
// SuperUser -> Change customer email
// Delete Filekey
// URL = brokerconnect.live/api/v2/superuser/filekey_delete
// JSON request POST
// {
//  "UserToken": "59d4acf6-0ef4-11ee-be24-088fc34537c8", SuperUser's token
//  "Email": "anndee108@gmail.com", user's Email
//  "FileCode": "f8796511-61de-11ee-933c-088fc34537c8",
// }
// Response
// [
//  {
//   "result": "success",
//   "message": "Deleted Filekey: 6c3080c8-91ce-11ed-8eb6-088fc34537c8, Record ID: 33407"
//  }
// ]
// --------------------------------------------------------
function SuperDeleteFileKey(sUserToken, sEmail, sFileCode : string): string;
var
  sURL, sData, sStatus, s : string;
  postData : AnsiString;
  postHead : TStringStream;
  fileKeys, lineLst: TStrings;
  i : integer; // longint;
begin
  sURL := API_BASE + API_VER + 'superuser/filekey_delete';
  try
    postHead := TStringStream.Create('');
    with postHead do begin
      WriteString('api: ' + GetAPIKey + sLineBreak);
      WriteString('superuser: ' + SUPER_KEY + sLineBreak);
      WriteString('Content-Type: application/json' + sLineBreak);
      WriteString('charset: utf-8' + sLineBreak);
    end;
    // ----------------------------------------------------
    postData := '{"UserToken": "' + sUserToken + '"'
      + ',"Email":"' + sEmail + '"'
      + ',"FileCode":"' + sFileCode + '"'
      + '}';
    // ----------------------------------------------------
    sStatus := ReadBrokerConnectPost(sURL, postHead, postData, 'POST');
    if Developer then begin
      clipboard.AsText := postData;
      sm(sURL + ' returned:' + CRLF + postData);
    end; // -----------------
    if POS('200 ', sStatus)= 1 then begin
      s := 'DeleteFileKey:' + CRLF + FormatV2APIResponse(postData);
    end
    else begin
      LogEntry(v2UserToken, 'ERROR', 'DeleteFileKey:' + sFileCode, 'UPDATE');
      LogEntry(v2UserToken, 'ERROR', 'API Response:' + s, 'UPDATE');
      s := 'ERROR: ' + sStatus;
    end;
  finally
    postHead.Free;
  end;
  result := s;
end; // SuperDeleteFileKey


// --------------------------------------------------------
// SuperUser -> list users
// Returns a list of all Users
// URL = API_BASE + 'superuser/listAllUsers
//
// JSON request POST
// { "UserToken": "02da4cfe-5551-11ed-8b53-f23c92dd5fb6",
//   "Email": "name@email.com.com",
//   "Name": "ro",
//   "FSSubscription": "Nsg6P0C8QNGwhkWlU1K1PQ", -- FastSpring sub id
//   "Subscription": "dbc14c90-1804-11ed-a943-482ae324d10c", -- TradeLog sub id
// }
//
// Response
// [
//  { "UserId": 13986,
//    "CustomerId": 2,
//    "Name": "dpreiss",
//    "Email": "damian@e-daptive.com",
//    "Password": "$2b$10$WY41ydNdZ1r1uqKE5RgOROY.EXv0SAiPP5ws6SDvctKfh9u5.eZ1m",
//    "Manager": 1,
//    "UserToken": "a5db0a14-3817-11ed-942c-f23c938e66e4",
//    "DateCreated": 1662998154391,
//    "DateUpdated": null,
//    "FSSubscription": "Nsg6P0C8QNGwhkWlU1K1PQ",
//    "TradeLogSubscription": "dbc14c90-1804-11ed-a943-482ae324d10c"
//  },...
// ]
// OR
// {"message": "No matching records!"}
// --------------------------------------------------------
//function ListAllUsers(sUserToken : string): string;
//var
//  sURL, sData, sStatus, s : string;
//  postData : AnsiString;
//  postHead : TStringStream;
//  lineLst: TStrings;
//  i : integer; // longint;
//begin
//  sURL := API_BASE + API_VER + 'filekeys/';
//  try
//    postHead := TStringStream.Create('');
//    with postHead do begin
//      WriteString('api: ' + GetAPIKey + sLineBreak);
//      WriteString('Content-Type: application/json' + sLineBreak);
//      WriteString('charset: utf-8' + sLineBreak);
//    end;
//    // ----------------------------------------------------
//    postData := '{"UserToken": "' + sUserToken + '"}';
//    // ----------------------------------------------------
//    sStatus := ReadBrokerConnectPost(sURL, postHead, postData, 'POST');
//    if POS('200 OK', sStatus)= 1 then begin
//      s := 'ListFileKeys' + CRLF + FormatV2APIResponse(postData);
//      lineLst := ParseV2APIResponse(postData);
//    end
//    else begin
//      s := 'ERROR: ' + sStatus;
//    end;
//  finally
//    postHead.Free;
//  end;
//  clipboard.AsText := s;
//  result := s;
//end; // ListFileKeys


          // ----------+
          //  Config   |
          //   Files   |
          // ----------+

// --------------------------------------------------------
// The api gives a list of the various config files
//
// brokerconnect.live/api/v2/configs/bbio
// brokerconnect.live/api/v2/configs/etfs
// brokerconnect.live/api/v2/configs/futures
// brokerconnect.live/api/v2/configs/strategies
//
// Json request POST
// {
// "UserToken" : "a5db0a14-3817-11ed-942c-f23c938e66e4"
// }
//
// Response is a list
// OR
// {
// "Error": "UserToken does not exist"
// }
// --------------------------------------------------------
function GetConfigData(sUserToken, sOptionType, sLocalFile : string) : boolean;
var
  SomeTxtFile : textfile;
  buffer, sURL, sData, sStatus, s, sOpt, t : string;
  postData : AnsiString;
  postHead : TStringStream;
  lineLst : TStrings;
  i, n : integer; // longint;
begin
  s := lowercase(sOptionType);
  if s = 'broadbasedoptions' then sOpt := 'bbio'
  else if s = 'futureoptions' then sOpt := 'futures'
  else if s = 'mutualfunds' then sOpt := 'muts'
  else if s = 'strategyoptions' then sOpt := 'strategies'
  else sOpt := s;
  // --------------
  sURL := API_BASE + API_VER + 'configs/' + sOpt;
  result := true; // until proven false
  try
    postHead := TStringStream.Create('');
    with postHead do begin
      WriteString('api: ' + GetAPIKey + sLineBreak);
      WriteString('Content-Type: application/json' + sLineBreak);
      WriteString('charset: utf-8' + sLineBreak);
    end;
    // ----------------------------------------------------
    postData := '{"UserToken": "' + sUserToken + '"}';
    // ----------------------------------------------------
    sStatus := ReadBrokerConnectPost(sURL, postHead, postData, 'POST');
// if Developer then begin
// clipboard.AsText := postData;
// sm(sURL + ' returned:' + CRLF + leftstr(postData,400));
// end; // -----------------
    // {"result":[
    // {"List":"BBH = 100","Ticker":"BBH","Multiplier":"100","Description":"VanEck Biotech ETF"},
    // {"List":"BBIO = 100","Ticker":"BBIO","Multiplier":"100","Description":"BridgeBio Pharma, Inc."},
    // . . . ]}
    // 0       1            2       3        4          5      6            7
    if pos('200 OK', sStatus) <> 1 then begin
      s := 'ERROR: ' + sStatus;
      exit(false);
    end
    else begin
      // want everything betweeen first and last bracket
      sData := postData;
      sData := ParseBetween(sData, '[', ']');
      AssignFile(SomeTxtFile, sLocalFile);
      rewrite(SomeTxtFile);
      try
        while length(sData) > 0 do begin
          s := ParseHtml(sData, '{', '}');
          if s = '' then
            sm('problem!');
          delete(sData, 1, length(s)+ 3);
          if length(s) < 2 then continue;
          lineLst := ParseV2APIResponse(s);
          if lineLst.Count < 1 then continue;
          if sOpt = 'bbio' then begin
            t := lineLst[3];
            if t = '' then t := lineLst[5] + ' = ' + lineLst[7];
            WriteLn(SomeTxtFile, t);
          end
          else if sOpt = 'etfs' then begin
            t := lineLst[3];
            if t = '' then t := lineLst[5] + ' = ' + lineLst[7];
            if lineLst.Count >= 11 then
              t := t + TAB + lineLst[5] + TAB + lineLst[7] + TAB + lineLst[9] + TAB + lineLst[11];
              // u   	       Ticker	            Type	             Description   	               Asset Class
              // AAA = ETF	 AAA 	              ETF 	             AAF First Priority CLO Bond   ETF	Bond
            WriteLn(SomeTxtFile, t);
          end
          else if sOpt = 'futures' then begin
            t := lineLst[3];
            WriteLn(SomeTxtFile, t);
          end
          else if sOpt = 'muts' then begin
            t := lineLst[3];
            WriteLn(SomeTxtFile, t);
          end
          else if sOpt = 'strategies' then begin
            t := lineLst[3];
            WriteLn(SomeTxtFile, t);
          end;
        end; // while
      finally
        CloseFile(SomeTxtFile);
      end; // try...finally
    end; // if sStatus = OK
  finally
    postHead.Free;
  end;
end; // getConfigData


// brokerconnect.live/api/v2/tradelog_version/

// --------------------------------------------------------------------
// function GetVersion(subFunc : string; optional sEmail, sPwd : string;): string;
// returns JSON:
// --------------------------------------------------------------------
function GetVersion(subFunc : string): string;
var
  sURL, sData, sStatus, s, s1, sReply : string;
  postData : AnsiString;
  postHead : TStringStream;
  lineLst: TStrings;
  i, k, n : integer;
  // ----------------------------------
    function APIdate(t: string): TDate;
    var
      Y, M, D : Word;
    begin
      result := 0;
      if length(t) < 8 then exit;
      if pos(' ',t) > 0 then
        t := leftstr(t,pos(' ',t)-1); // remove time
//        try
//          Y := StrToInt(dtLst[0]);
//          M := StrToInt(dtLst[1]);
//          D := StrToInt(dtLst[2]);
//          result := EncodeDate(Y, M, D);
//        except
//          sm('unable to convert ' + t + CRLF + 'to a YY-M-D date value.');
//        end;
    end; // -----------------
begin
  sURL := API_BASE + API_VER + 'tradelog_version/' + subFunc;
//  sURL := DEV_BASE + API_VER + 'tradelog_version/' + subFunc;
  try
    postHead := TStringStream.Create('');
    with postHead do begin
      WriteString('api: ' + GetAPIKey + sLineBreak);
//      WriteString('api: de835869ae0fb9413f207482f4b4d47a19810c2c7171f4a0351ca02fc7fc4eec' + sLineBreak);
      WriteString('Content-Type: application/json' + sLineBreak);
      WriteString('charset: utf-8' + sLineBreak);
    end;
    // ------------------------------------------
    postData := '{}';
//    postData := '{"api_key":"' + GetAPIKey + '"}';
    // ------------------------------------------
    sStatus := ReadBrokerConnectPost(sURL, postHead, postData, 'POST');
    // expected return:
    // [
    //  {
    //   "id":8,
    //   "Version":"020.03.00.00",
    //   "RelDate":"23-10-27",
    //   "Description":"Improved Get Support and TradeLog Update."
    //  }
    // ]
    // --- no response --------------------------
    if (postData = '') then begin
      result := 'ERROR: unable to check for software update.';
      exit;
    end;
    // --- check status -------------------------
    n := GetStatus(sStatus);
    if (n < 100) or (n > 399) then begin
      result := 'ERROR: unable to check for software update.';
      exit;
    end;
    // --- check response for error -------------
    sReply := uppercase(postData);
  finally
    postHead.Free;
  end; // finally
  // ------------------------
  result := postData;
end; // GetLogin


// ------------------------------------------------------------------
// 1st: upload file to 45.56.119.22:/home/tradelog-backup/backup
// ------------------------------------------------------------------
function ZendeskPullFile(sUserToken, sFileName : string) : string;
var
  sURL, sData, sStatus, s : string;
  postData : AnsiString;
  postHead : TStringStream;
  fileKeys, lineLst: TStrings;
  i : integer; // longint;
begin
  sURL := 'https://zendesk.brokerconnect.live/pull_file';
  try
    postHead := TStringStream.Create('');
    with postHead do begin
      WriteString('api: ' + UPLOADKEY + sLineBreak);
      WriteString('Content-Type: application/json' + sLineBreak);
      WriteString('charset: utf-8' + sLineBreak);
    end;
    // ----------------------------------------------------
    postData := '{"api":"' + UPLOADKEY +'","UserToken":"' //
      + sUserToken + '"' + ',"file":"' + sFileName + '"}';
    // ----------------------------------------------------
    sStatus := ReadBrokerConnectPost(sURL, postHead, postData, 'POST');
    if Developer then begin
      clipboard.AsText := postData;
      sm(sURL + ' returned:' + CRLF + postData);
    end; // -----------------
    if POS('200 ', sStatus)= 1 then begin
      s := 'ZendeskTicket:' + CRLF + FormatV2APIResponse(postData);
    end
    else begin
      LogEntry(v2UserToken, 'ERROR', 'ZendeskPullFile:' + sFileName, 'UPDATE');
      LogEntry(v2UserToken, 'ERROR', 'API Response:' + s, 'UPDATE');
      s := 'ERROR: ' + sStatus;
    end;
  finally
    postHead.Free;
  end;
  result := s;
end; // ZendeskPullFile


// ----------------------------------------------
//  endpoint: API_BASE + 'mail
//  The json fields are all mandatory.
//  json: {
//    "UserToken": "ce29f8b6-b0f0-11ed-afb1-f23c938e66e4",
//    "ver": "23.4", (TradeLog version ??)
//    "file": "readme.txt", (associated file)
//    "comments": "TESTing Ralph's API!"
//    "email":<some email address>,
//    "name": <some user name>
//  }
// ----------------------------------------------
function ZendeskTicket(sUserToken, sVer, sFileName, sComments, sEmail, sName : string): string;
var
  sURL, sData, sStatus, s : string;
  postData : AnsiString;
  postHead : TStringStream;
  fileKeys, lineLst: TStrings;
  i, iRetries : integer; // longint;
begin
  iRetries := 1;
  sURL := API_BASE + API_VER + 'mail';
  try
    postHead := TStringStream.Create('');
    with postHead do begin
      WriteString('api: ' + GetAPIKey + sLineBreak);
      WriteString('Content-Type: application/json' + sLineBreak);
      WriteString('charset: utf-8' + sLineBreak);
    end;
    // ------------------------------------------
    postData := '{'                            //
      + '"UserToken": "' + sUserToken + '"'    //
      + ',"ver":"' + sVer + '"'                //
      + ',"file":"' + sFileName + '"'          //
      + ',"comments":"' + sComments + '"'      //
      + ',"email":"' + sEmail + '"'            //
      + ',"name":"' + sName + '"'              //
      + '}';                                   //
    // ------------------------------------------
    s := postData; // save for troubleshooting
    while iRetries < 5 do begin
      sStatus := ReadBrokerConnectPost(sURL, postHead, postData, 'POST');
      if POS('200 ', sStatus)= 1 then break; // out of loop
      sleep(500); // 0.500 sec
      inc(iRetries);
      postData := s; // restore postData before retry
    end;
    if POS('200 ', sStatus)= 1 then begin
      s := 'ZendeskTicket:' + CRLF + FormatV2APIResponse(postData);
    end
    else begin
      LogEntry(v2UserToken, 'ERROR', 'ZendeskTicket:' + sFileName, 'UPDATE');
      LogEntry(v2UserToken, 'ERROR', 'API Response:' + s, 'UPDATE');
      if Developer then begin
        clipboard.AsText := postData;
        sm('Posted:' + CRLF + s + CRLF + 'Returned:' + CRLF + postData);
      end; // -----------------
      s := 'ERROR: ' + sStatus;
    end;
  finally
    postHead.Free;
  end;
  result := s;
end; // UpdateFileKey


// ----------------------------------------------
// brokerconnect.live/api/v2.5/mtm/options
// params: UserToken, year, optionroot
// {
//    "UserToken": "b124b07f-b5f2-11ee-ab4b-088fc34537c8",
//    "year": 2018,
//    "optionroot": "A190118C00062500"
// }
// ----------------------------------------------
function GetMTMPriceOPT(sUserToken, sYear, sOptTick : string) : string;
var
  SomeTxtFile : textfile;
  buffer, sURL, sStatus, s, sTmp, t : string;
  sAsk, sBid, sLast, sMark : string;
  nAsk, nBid, nLast, nMark : double;
  postData : AnsiString;
  postHead : TStringStream;
  lineLst : TStrings;
  i, j, n : integer; // longint;
  fldLst : TStrings;
begin
  // --------------
  sURL := API_BASE + BC_VER + 'mtm/options';
  result := '';
  sAsk := '';
  sBid := '';
  sLast := '';
  sMark := '';
  try
    postHead := TStringStream.Create('');
    with postHead do begin
      WriteString('api: ' + GetAPIKey + sLineBreak);
      WriteString('Content-Type: application/json' + sLineBreak);
      WriteString('charset: utf-8' + sLineBreak);
    end;
    // ----------------------------------------------------
    postData := '{"UserToken":"' + sUserToken //
      + '","year":"' + sYear //
      + '","optionroot":"' + sOptTick + '"}';
    // ----------------------------------------------------
    sStatus := ReadBrokerConnectPost(sURL, postHead, postData, 'POST');
    if pos('200 OK', sStatus) = 1 then begin
      // {
      //  "id":5635998,
      //  "UnderlyingSymbol":"AMZN",
      //  "UnderlyingPrice":151.94,
      //  "Exchange":"*",
      //  "OptionRoot":"AMZN240112C00170000",
      //  "OptionExt":"",
      //  "Type":"call",
      //  "Expiration":"01/12/2024",
      //  "DataDate":"12/29/2023",
      //  "Strike":170,
      //  "Last":0.06,
      //  "Bid":0.05,
      //  "Ask":0.06,
      //  "Volume":478,
      //  "OpenInterest":1424,
      //  "T1OpenInterest":0,
      //  "Year":2023
      // }
      s := lowercase(trim(postData));
      sTmp := parseBetween(s, '{', '}');
      if length(sTmp) < 4 then begin
        if (Developer) then showmessage('No data from API.');
        exit;
      end;
      // ----------------------------------
      try
        fldLst := ParseV2APIResponse(sTmp); //             create fldLst
        if assigned(fldLst)=false then exit;
        j := 0;
        while (j < fldLst.Count) do begin
          sTmp := lowercase(fldLst[j]); // reuse var
          if sTmp = 'ask' then sAsk := fldLst[j+1];
          if sTmp = 'bid' then sBid := fldLst[j+1];
          if sTmp = 'last' then sLast := fldLst[j+1];
          j := j + 2; // pairs
        end;
        // --- convert Ask/Bid/Last to numbers ---
        if sAsk = '' then nAsk := 0 else nAsk := StrToFloat(sAsk);
        if sBid = '' then nBid := 0 else nBid := StrToFloat(sBid);
        if sLast = '' then nLast := 0 else nLast := StrToFloat(sLast);
        // --- MTM options Ask/Bid/Last logic ---
        // If Last > Ask, then Mark = Ask
        // If Last < Bid, then Mark = Bid
        // If Last is > Bid and < Ask, then Mark = Last
        // If any result above = 0 then Mark = 0.01
        if (nLast >= nAsk) then sMark := sAsk;
        if (nLast <= nBid) then sMark := sBid;
        If (nLast > nBid) and (nLast < nAsk) then sMark := sLast;
        if sMark = '' then nMark := 0.01 else nMark := StrToFloat(sMark);
        result := FloatToStr(nMark);
        fldLst.Free; //                                    free memory
      except
        on E : Exception do begin
          sm('GetMTMOptPrice failed: ' + S + CRLF //
            + E.ClassName + ': ' + E.Message);
        end;
      end;
    end; // if status like '200 OK'
  finally
    postHead.Free;
  end;
end;

// ----------------------------------------------
// brokerconnect.live/api/v2.5/mtm/options
// params: UserToken, year, optionroot
// {
//    "UserToken": "b124b07f-b5f2-11ee-ab4b-088fc34537c8",
//    "year": 2018,
//    "optionroot": "A190118C00062500"
// }
// ----------------------------------------------
function GetMTMPriceSTK(sUserToken, sYear, sTick : string) : string;
var
  SomeTxtFile : textfile;
  buffer, sURL, sStatus, s, sTmp, t : string;
  postData : AnsiString;
  postHead : TStringStream;
  lineLst : TStrings;
  i, j, n : integer; // longint;
  fldLst : TStrings;
begin
  // --------------
  sURL := API_BASE + BC_VER + 'mtm/stocks';
  result := '';
  try
    postHead := TStringStream.Create('');
    with postHead do begin
      WriteString('api: ' + GetAPIKey + sLineBreak);
      WriteString('Content-Type: application/json' + sLineBreak);
      WriteString('charset: utf-8' + sLineBreak);
    end;
    // ----------------------------------------------------
    postData := '{"UserToken":"' + sUserToken //
      + '","year":"' + sYear //
      + '","ticker":"' + sTick + '"}';
    // ----------------------------------------------------
    sStatus := ReadBrokerConnectPost(sURL, postHead, postData, 'POST');
    if pos('200 OK', sStatus) = 1 then begin
      // {
      //  "date": 20191231,
      //  "close": "21.5100",
      //  "ticker": "AA"
      // }
      s := lowercase(trim(postData));
      sTmp := parseBetween(s, '{', '}');
      if length(sTmp) < 4 then begin
        if (Developer) then showmessage('No data from API.');
        exit;
      end;
      // ----------------------------------
      try
        fldLst := ParseV2APIResponse(sTmp); //              create fldLst
        if assigned(fldLst)=false then exit;
        j := 0;
        while (j < fldLst.Count) do begin
          sTmp := fldLst[j]; // reuse var
          if sTmp = 'close' then begin
            result := fldLst[j+1];
            break;
          end;
          j := j + 2; // pairs
        end;
        fldLst.Free; //                                          free memory
      except
        on E : Exception do begin
          sm('GetMTMOptPrice failed: ' + S + CRLF //
            + E.ClassName + ': ' + E.Message);
        end;
      end;
    end; // if status like '200 OK'
  finally
    postHead.Free;
  end;
end;


end.
