unit TL_API25;

interface

uses
  Sysutils, StrUtils, Dialogs, Variants, Classes, clipBrd, TLWinInet, uLkJSON;

function GetAPIKey: string;
function ParseJSON(const s: string) : TStrings;
function ParseV2APIResponse(s: string): TStrings;
function FormatV2APIResponse(sJSON: string): string;
function yyyymmddToUSDate(s : string): string;
function FastSpringToDate(s : string): TDateTime;

function GeneratePassword(sPwd : string): string;
function GetLogin(sEmail, sPwd : string): string; // returns JSON
function GetSubscriptions(sUserToken : string): string;

function ListAllUsers(sUserToken : string): string;
function ManageUsers(sFunc, sUserToken, sName, sEmail, sPwd : string): string;

function ListAllClients(sUserToken : string): string;
function ManageClients(sFunc, sUserToken, sName, sEmail, sPwd : string): string;

function ListFileKeys(sUserToken : string): string;
//function AvailableFileKeys(sUserToken : string): string;
function UpdateFileKey(sUserToken, sEmail, sFileCode, sFileName, sTaxPayer, sTaxYear : string): string;

function InsertFileKeyLog(sUserToken, sFileCode, sFunc, sReason, sComment, sTracking, sAcct : string): string;
function GetFileKeyLog(sUserToken, sFileCode : string): string;

function LogEntry(sUserToken, sCategory, sMessage, sAction : string): string;
// note: LogEntry CRUD - sAction can be SELECT, INSERT, or DELETE

function GetConfigData(sUserToken, sOptionType, sLocalFile : string) : boolean;

//function MoveZipFileToGoogle(sFileName: string): string;
//function DeleteZipFileFromLinode(sFileName: string): string;
function ZendeskPullFile(sUserToken, sFileName : string) : string;
function ZendeskTicket(sUserToken, sVer, sFileName, sComments : string): string;


// --- Super User -----------
function Impersonate(sEmail : string): string;
function SuperChangeEmail(sOldEmail, sNewEmail : string): string;
function SuperInsertFileKey(sEmail, sFreeFileKey : string): string;


implementation

uses
  funcproc, // for ParseCSV
  TLCommonLib, // for TAB, CR, LF
  DateUtils, // for UnixToDateTime
//  TLSettings, // for internal date format
  globalVariables;

const
  DEBUGGING : boolean = false;

  API_KEYv2 : string = '8?xP*o&zdA&Qa16oU$F9TCk@45$mS*'; // v2 API until <date>
  API_KEY23 : string = '4d*T3S9kdhj#Ah87rQ&*&NJRe5!9#L'; // v2 API after <date>
  SUPER_KEY : string = 'UQ@5v28RyH3jG8505zr!M&o#$x*?#T'; // Super User
  UPLOADKEY : string = '3773ff136f9b8dd68ea9aad'; // used by ZenDesk pull file


// --------------------------
function GetAPIKey: string;
var
  x, y : TDateTime;
begin
//  x := EncodeDate(2023,03,01) + EncodeTime(0,0,0,0);
//  y := GetEasternTime;
//  if y < x then
    result := API_KEYv2
//  else
//    result := API_KEY23;
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
  // brokerconnect.live/api/v2/passiv/status
  // Response:
  // {
  // "version": 151,
  // "timestamp": "2023-08-01T15:01:01.581528Z",
  // "online": true
  // }

// Check for TradeLog website


// --------------------------------------------------------------------
// Parse JSON into a TStrings list of {1},{2},... each ready to parse
// --------------------------------------------------------------------
function ParseJSON(const s: string) : TStrings;
var
  i, j: integer;
  token: string;
begin
  if s = '' then exit;
  result := TStringList.Create;
  i := 1; // init
  while i <= length(s) do begin
    token := '';
    j := pos('{', s, i) + 1; // find start of object {
    if j < i then break;
    i := pos('}', s, j); // find end of object }
    if i < j then break;
    token := Copy( s, j, (i-j) ); // from { to }
    result.add(token);
    i := i + 1;
  end; // while loop
  if token <> '' then
    result.add(token);
end; // ParseJSON


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


// if in yyyy-mm-dd hh:mm:ss.uuu format
function yyyymmddToUSDate(s : string): string; // to mm/dd/yyyy
var
  t : string;
begin
  s := StringReplace( s, '-', '', [rfReplaceAll]);
  if (s = 'null') or (s = '') then begin
    result := '';
    exit;
  end;
  if length(s) > 8 then s := LeftStr(s, 8);
  s := copy(s,5,2) + '/' + copy(s,7,2) + '/' + copy(s,1,4);
  result := s; // StrToDate(s);
end;

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
function GeneratePassword(sPwd : string): string;
var
  sURL, sData, sStatus, s, APIKey : string;
  postData : AnsiString;
  postHead : TStringStream;
begin
  sURL := 'https://brokerconnect.live/api/v2/auth/generatePassword';
  try
    postHead := TStringStream.Create('');
    with postHead do begin
      WriteString('api: ' + GetAPIKey + sLineBreak);
      WriteString('Content-Type: application/json' + sLineBreak);
      WriteString('charset: utf-8' + sLineBreak);
    end;
    // ----------------------------------------------------
    postData := '{"api_key":"' + GetAPIKey //
      + '","password" : "' + sPwd + '"}';
    // ----------------------------------------------------
    sStatus := ReadBrokerConnectPost(sURL, postHead, postData, 'POST');
    if Developer then begin
      clipboard.AsText := postData;
      sm(sURL + ' returned:' + CRLF + postData);
    end;
    if POS('200 OK', sStatus)= 1 then begin
      sData := postData;
      s := 'GeneratePassword' + CRLF + FormatV2APIResponse(sData);
    end
    else begin
      s := '';
    end;
  finally
    postHead.Free;
  end;
  result := s;
end; // GeneratePassword


procedure LogToFile(sFileSpec, s : string);
var
  ErrLog : textfile;
  sMsg : string;
begin
  AssignFile(ErrLog, sFileSpec);
  rewrite(ErrLog);
  sMsg := 'ERROR :' + s;
  try
    write(ErrLog, sMsg);
  finally
    CloseFile(ErrLog);
  end;
//  Settings.LogDir + '\' + 'error.log'
end;


// --------------------------------------------------------------------
// new Login(email,pwd);
// returns JSON:
// {"SubscriptionId":1910,
//  "UserToken":"b85c70eb-a928-11ed-a33a-f23c938e66e4",
//  "Name":"Mark Blackston",
//  "Subscription":"Subscription",
//  "Sku":"1007",
//  "product":"Elite",
//  "Manager":8,
//  "UserStartDateForTrial":"2022-11-29 19:36:31.280000",
//  "StartDate":"2022-01-01 00:00:00",
//  "EndDate":"2023-05-31 00:00:00",
//  "CanceledDate":null}
// --------------------------------------------------------------------
function GetLogin(sEmail, sPwd : string): string;
var
  sURL, sData, sStatus, s, s1, sReply : string;
  postData : AnsiString;
  postHead : TStringStream;
  lineLst: TStrings;
  i, k, n : integer;
  // ----------------------------------
  procedure InitV2Vars();
  begin
    v2LoginPostData := '';
    gbOffline := true; // assume offline until proven otherwise
    gbFreeTrial := true;
    gbExpired := true;
    // ----------------------
    v2UserToken := '';
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
        k := k or 1;
      end
      else if (Uppercase(lineLst[j]) = 'NAME') then begin //
        v2UserName := lineLst[j+1];
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
  end;
  // ------------------------
begin
  sURL := 'https://brokerconnect.live/api/v2/users/login';
  InitV2Vars;
  try
    postHead := TStringStream.Create('');
    with postHead do begin
      WriteString('api: ' + GetAPIKey + sLineBreak);
      WriteString('Content-Type: application/json' + sLineBreak);
      WriteString('charset: utf-8' + sLineBreak);
    end;
    // ------------------------------------------
    postData := '{"api_key":"' + GetAPIKey //
      + '","Email" : "' + sEmail //
      + '","Password" : "' + sPwd + '"}';
    // ------------------------------------------
    v2LoginPostData := postData; // remember it
    sStatus := ReadBrokerConnectPost(sURL, postHead, postData, 'POST');
    // possibilities: offline, goodlogin(Trial, Active, or Expired), badlogin
    if Developer then begin
      clipboard.AsText := postData;
      sm(sURL + ' returned:' + CRLF + postData);
    end;
// simulate being offline:
//postData := v2LoginPostData; // simulate offline
//sStatus := '400 Bad Request';
    // --- timeout ------------------------------
    if (v2LoginPostData = postData) then begin
      v2LoginPostData := 'ERROR: unable to reach server before timeout.' + CR //
        + 'Switching to OFFLINE mode.';
      gbOffline := true;
      bCancelLogin := false;
      result := 'ERROR: timeout.';
      exit;
    end;
    // --- no response --------------------------
    if (postData = '') then begin
      v2LoginPostData := 'Server did not return user information.' + CR //
        + 'Switching to OFFLINE mode.';
      gbOffline := true;
      bCancelLogin := false;
      result := 'ERROR: unable to login.';
      exit;
    end;
    // --- check status -------------------------
    n := GetStatus(sStatus);
    if (n < 100) or (n > 399) then begin
      v2LoginPostData := 'ERROR: ' + sStatus + CR //
        + 'Switching to OFFLINE mode.';
      gbOffline := true;
      bCancelLogin := false;
      result := v2LoginPostData;
      exit;
    end;
    v2LoginPostData := sStatus; // not postData
    // --- check response for error -------------
    sReply := uppercase(postData);
    if (POS('"RESULT":"ERROR"', sReply) > 0) //
    or (POS('"STATUS":"ERROR"', sReply) > 0) then begin
      v2LoginPostData := 'ERROR: ' + FormatV2APIResponse(postData); //
      gbOffline := false;
      bCancelLogin := true;
    end
    else if (POS('502 BAD GATEWAY', sReply) > 0) then begin
      v2LoginPostData := 'ERROR: 502 BAD GATEWAY' + FormatV2APIResponse(postData); //
      gbOffline := true;
      bCancelLogin := false;
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
      SetV2Vars;
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
  end;
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
  sURL := 'https://brokerconnect.live/api/v2/users/subscriptions';
  try
    postHead := TStringStream.Create('');
    with postHead do begin
      WriteString('api: ' + GetAPIKey + sLineBreak);
      WriteString('Content-Type: application/json' + sLineBreak);
      WriteString('charset: utf-8' + sLineBreak);
    end;
    // ----------------------------------------------------
    postData := '{"api_key":"' + GetAPIKey //
      + '","UserToken": "' + sUserToken + '"}';
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
  sURL := 'https://brokerconnect.live/api/v2/auth/listAllUsers';
  try
    postHead := TStringStream.Create('');
    with postHead do begin
      WriteString('api: ' + GetAPIKey + sLineBreak);
      WriteString('Content-Type: application/json' + sLineBreak);
      WriteString('charset: utf-8' + sLineBreak);
    end;
    // ----------------------------------------------------
    postData := '{"api_key":"' + GetAPIKey //
      + '","UserToken": "' + sUserToken + '"}';
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
function ManageUsers(sFunc, sUserToken, sName, sEmail, sPwd : string): string;
var
  sURL, sData, sStatus, s : string;
  postData : AnsiString;
  postHead : TStringStream;
begin
  if sFunc = 'INS' then
    sURL := 'brokerconnect.live/api/v2/users/insert'
  else if sFunc = 'UPD' then
    sURL := 'brokerconnect.live/api/v2/users/update'
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
    postData := '{"api_key":"' + GetAPIKey //
      + '","UserToken": "' + sUserToken //
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
function ListAllClients(sUserToken : string): string;
var
  sURL, sData, sStatus, s : string;
  postData : AnsiString;
  postHead : TStringStream;
  lineLst: TStrings;
  i : integer; // longint;
begin
  sURL := 'https://brokerconnect.live/api/v2/users/clients';
  try
    postHead := TStringStream.Create('');
    with postHead do begin
      WriteString('api: ' + GetAPIKey + sLineBreak);
      WriteString('Content-Type: application/json' + sLineBreak);
      WriteString('charset: utf-8' + sLineBreak);
    end;
    // ----------------------------------------------------
    postData := '{"api_key":"' + GetAPIKey //
      + '","UserToken": "' + sUserToken + '"}';
    // ----------------------------------------------------
    sStatus := ReadBrokerConnectPost(sURL, postHead, postData, 'POST');
    if Developer then begin
      clipboard.AsText := postData;
      sm(sURL + ' returned:' + CRLF + postData);
    end; // -----------------
    if POS('200 OK', sStatus)= 1 then begin
      s := ParseHtml(postData, '{','}');
      lineLst := ParseV2APIResponse(s);
      s := 'ListAllClients' + CRLF + FormatV2APIResponse(postData);
    end
    else begin
      s := 'ERROR: ' + sStatus;
    end;
  finally
    postHead.Free;
  end;
  result := s;
end; // ListAllUsers


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
function ManageClients(sFunc, sUserToken, sName, sEmail, sPwd : string): string;
var
  sURL, sData, sStatus, s : string;
  postData : AnsiString;
  postHead : TStringStream;
begin
  sURL := 'brokerconnect.live/api/v2/users/update';
  try
    postHead := TStringStream.Create('');
    with postHead do begin
      WriteString('api_key: ' + GetAPIKey + sLineBreak);
      WriteString('Content-Type: application/json' + sLineBreak);
      WriteString('charset: utf-8' + sLineBreak);
    end;
    // ----------------------------------------------------
    postData := '{"api_key":"' + GetAPIKey //
      + '","UserToken" : "' + sUserToken //
      + '","Name" : "' + sName + '"' //
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
      s := 'ManageClients' + CRLF + FormatV2APIResponse(postData);
    end
    else begin
      s := '';
    end;
  finally
    postHead.Free;
  end;
  result := s;
end; // UpdateClient


// --------------------------------------------------------
// User -> tax file keys
// A list of tax file keys
//
// https://brokerconnect.live/api/v2/filekeys/
// https://brokerconnect.live/api/v2/users/taxfiles_list
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
  sURL := 'https://brokerconnect.live/api/v2/filekeys/';
  try
    postHead := TStringStream.Create('');
    with postHead do begin
      WriteString('api: ' + GetAPIKey + sLineBreak);
      WriteString('Content-Type: application/json' + sLineBreak);
      WriteString('charset: utf-8' + sLineBreak);
    end;
    // ----------------------------------------------------
    postData := '{"api_key":"' + GetAPIKey //
      + '","UserToken": "' + sUserToken + '"}';
    // ----------------------------------------------------
    sStatus := ReadBrokerConnectPost(sURL, postHead, postData, 'POST');
    if Developer then begin
      clipboard.AsText := postData;
      sm(sURL + ' returned:' + CRLF + postData);
    end; // -----------------
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
//  sURL := 'https://brokerconnect.live/api/v2/filekeys/available';
//  try
//    postHead := TStringStream.Create('');
//    with postHead do begin
//      WriteString('api: ' + GetAPIKey + sLineBreak);
//      WriteString('Content-Type: application/json' + sLineBreak);
//      WriteString('charset: utf-8' + sLineBreak);
//    end;
//    // ----------------------------------------------------
//    postData := '{"api_key":"' + GetAPIKey //
//      + '","UserToken": "' + sUserToken + '"}';
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
  fileKeys, lineLst: TStrings;
  i : integer; // longint;
begin
  sURL := 'https://brokerconnect.live/api/v2/logs';
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
//  "api":"<api_key>",
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
  sURL := 'https://brokerconnect.live/api/v2/filekeys/update';
  try
    postHead := TStringStream.Create('');
    with postHead do begin
      WriteString('api: ' + GetAPIKey + sLineBreak);
      WriteString('Content-Type: application/json' + sLineBreak);
      WriteString('charset: utf-8' + sLineBreak);
    end;
    // ----------------------------------------------------
    postData := '{"api":"' + GetAPIKey //
      + '","UserToken": "' + sUserToken + '"'
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
  sURL := 'https://brokerconnect.live/api/v2/filekeys/insert_log';
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
//  URL: https://brokerconnect.live/api/v2/filekeys/select_log
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
  sURL := 'https://brokerconnect.live/api/v2/filekeys/select_log';
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
// api = 8?xP*o&zdA&Qa16oU$F9TCk@45$mS*
// superuser = UQ@5v28RyH3jG8505zr!M&o#$x*?#T

// --------------------------------------------------------
// SuperUser -> impersonate user
// SuperUser gains control over a customer's account
//
//   https://brokerconnect.live/api/v2/superuser/impersonate
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
  i : integer;
begin
  sURL := 'https://brokerconnect.live/api/v2/superuser/impersonate';
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
    sStatus := ReadBrokerConnectPost(sURL, postHead, postData, 'POST');
    sData := uppercase(postData);
    if POS('200 ', sStatus)= 1 then begin
      if length(postData) < 3 then
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
// URL = https://brokerconnect.live/api/v2/superuser/email_change
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
  sURL := 'https://brokerconnect.live/api/v2/superuser/email_change';
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
    postData := '{"api":"' + GetAPIKey //
      + '","UserToken": "' + v2UserToken + '"'
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
// URL = https://brokerconnect.live/api/v2/superuser/email_change
//
// JSON request POST
// {"UserToken": "4fa37067-75f8-11ed-b13e-f23c938e66e4", -- superuser
//  "Email": "siddharth.sarna@gmail.com", -- customer's Email
//  "FreeFileKey": "True" -- or "False" }
// Response
// [{"FileKeyId": 33409,
//   "OrderId": "Support Staff: ralph@tradelogsoftware.com : 2023-01-11 19:47:05",
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
  sURL := 'https://brokerconnect.live/api/v2/superuser/filekey_add';
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
    postData := '{"api":"' + GetAPIKey //
      + '","UserToken": "' + v2UserToken + '"'
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
end; // SuperChangeEmail


// --------------------------------------------------------
// SuperUser -> list users
// Returns a list of all Users
// URL = https://brokerconnect.live/api/v2/superuser/listAllUsers
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
//  sURL := 'https://brokerconnect.live/api/v2/filekeys/';
//  try
//    postHead := TStringStream.Create('');
//    with postHead do begin
//      WriteString('api: ' + GetAPIKey + sLineBreak);
//      WriteString('Content-Type: application/json' + sLineBreak);
//      WriteString('charset: utf-8' + sLineBreak);
//    end;
//    // ----------------------------------------------------
//    postData := '{"api_key":"' + GetAPIKey //
//      + '","UserToken": "' + sUserToken + '"}';
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
  sURL, sData, sStatus, s : string;
  postData : AnsiString;
  postHead : TStringStream;
  FKeyLst, lineLst: TStrings;
  i : integer; // longint;
begin
  sURL := 'https://brokerconnect.live/api/v2/configs/' + sOptionType;
  try
    postHead := TStringStream.Create('');
    with postHead do begin
      WriteString('api: ' + GetAPIKey + sLineBreak);
      WriteString('Content-Type: application/json' + sLineBreak);
      WriteString('charset: utf-8' + sLineBreak);
    end;
    // ----------------------------------------------------
    postData := '{"api_key":"' + GetAPIKey //
      + '","UserToken": "' + sUserToken + '"}';
    // ----------------------------------------------------
    sStatus := ReadBrokerConnectPost(sURL, postHead, postData, 'POST');
    if Developer then begin
      clipboard.AsText := postData;
      sm(sURL + ' returned:' + CRLF + postData);
    end; // -----------------
    if POS('200 OK', sStatus)= 1 then begin
      s := ParseHTML(postData,'[',']');
      lineLst := ParseV2APIResponse(s);
// convert JSON data to a CSV or TSV file
      s := sOptionType + CRLF + FormatV2APIResponse(postData);
    end
    else begin
      s := 'ERROR: ' + sStatus;
    end;
  finally
    postHead.Free;
  end;
  if pos('ERROR', s)=1 then exit(false) else exit(true);
end; // getConfigData


// ----------------------------------------------
//
// ----------------------------------------------
//function MoveZipFileToGoogle(sFileName: string): string;
//var
//  sURL, sData, sStatus, s : string;
//  postData : AnsiString;
//  postHead : TStringStream;
//begin
//  sURL := 'https://zendesk.brokerconnect.live/googledrive';
//  try
//    postHead := TStringStream.Create('');
//    with postHead do begin
//      WriteString('api: ' + UPLOADKEY + sLineBreak);
//      WriteString('Content-Type: application/json' + sLineBreak);
//      WriteString('charset: utf-8' + sLineBreak);
//    end;
//    postData := '{"FileName": "' + sFileName + '"}';
//    // ----------------------------------------------------
//    sStatus := ReadBrokerConnectPost(sURL, postHead, postData, 'POST');
//    s := 'status: ' + FormatV2APIResponse(sStatus) + CRLF //
//      + 'response: ' + FormatV2APIResponse(postData);
//    sm(s);
//    result := s;
//  finally
//    postHead.free;
//  end;
//end;
//
//
//// ----------------------------------------------
//function DeleteZipFileFromLinode(sFileName: string): string;
//var
//  sURL, sData, sStatus, s : string;
//  postData : AnsiString;
//  postHead : TStringStream;
//begin
//  sURL := 'https://zendesk.brokerconnect.live/googledrive/delete';
//  try
//    postHead := TStringStream.Create('');
//    with postHead do begin
//      WriteString('api: ' + UPLOADKEY + sLineBreak);
//      WriteString('Content-Type: application/json' + sLineBreak);
//      WriteString('charset: utf-8' + sLineBreak);
//    end;
//    postData := '{"FileName": "' + sFileName + '"}';
//    // ----------------------------------------------------
//    sStatus := ReadBrokerConnectPost(sURL, postHead, postData, 'POST');
//    s := 'status: ' + FormatV2APIResponse(sStatus) + CRLF //
//      + 'response: ' + FormatV2APIResponse(postData);
//    sm(s);
//    result := s;
//  finally
//    postHead.free;
//  end;
//end;


// ------------------------------------------------------------------
//
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
    postData := '{"api":"' + UPLOADKEY +'","UserToken":"' + sUserToken + '"' + ',"file":"' + sFileName + '"}';
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
//  endpoint: https://brokerconnect.live/api/v2/mail
//  The json fields are all mandatory.
//  json: {
//    "UserToken": "ce29f8b6-b0f0-11ed-afb1-f23c938e66e4",
//    "ver": "23.4", (TradeLog version ??)
//    "file": "readme.txt", (associated file)
//    "comments": "TESTing AGAIN TEST TEST with Ralph's API....AGAIN!!!!! AAAAAAARGH!"
//  }
// ----------------------------------------------
function ZendeskTicket(sUserToken, sVer, sFileName, sComments : string): string;
var
  sURL, sData, sStatus, s : string;
  postData : AnsiString;
  postHead : TStringStream;
  fileKeys, lineLst: TStrings;
  i : integer; // longint;
begin
  sURL := 'https://brokerconnect.live/api/v2/mail';
  try
    postHead := TStringStream.Create('');
    with postHead do begin
      WriteString('api: ' + GetAPIKey + sLineBreak);
      WriteString('Content-Type: application/json' + sLineBreak);
      WriteString('charset: utf-8' + sLineBreak);
    end;
    // ----------------------------------------------------
    postData := '{"api":"' + GetAPIKey //
      + '","UserToken": "' + sUserToken + '"'
      + ',"ver":"' + sVer + '"'
      + ',"file":"' + sFileName + '"'
      + ',"comments":"' + sComments + '"'
      + '}';
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
      LogEntry(v2UserToken, 'ERROR', 'ZendeskTicket:' + sFileName, 'UPDATE');
      LogEntry(v2UserToken, 'ERROR', 'API Response:' + s, 'UPDATE');
      s := 'ERROR: ' + sStatus;
    end;
  finally
    postHead.Free;
  end;
  result := s;
end; // UpdateFileKey


end.
