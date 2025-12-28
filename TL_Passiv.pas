unit TL_Passiv;

interface

uses
  forms, controls, Sysutils, StrUtils, Dialogs, Variants, Classes, clipBrd, TLWinInet, uLkJSON;

// general/utility functions
function convertToBase62(num : integer): string;

// Passiv -> list_status
function GetPassivStatus(sUserToken : string): string;

// Passiv -> list_tl_clients
function GetListTLClients(sUserToken : string): string;
// Passiv -> list_passiv_client(s)
function CheckPassivClient(sUserToken, sClientName : string): string;
function GetListPassivClients(sUserToken : string): string;

// Passiv -> create_client
function CreatePassivClient(sUserToken, sClientName : string): string;
// Passiv -> delete_client
function DeletePassivClient(sUserToken, sClientName : string): string;

// Passiv -> broker_link
function GetPassivBrokerLink(sUserToken, sClientName : string): string;
procedure LaunchPassivLink(sData, sClientName : string);
procedure DeleteBrokerLink(sUserToken, sClientName, sBroker : string);

// Passiv -> brokers
function GetPassivBrokerId(sToken, sName, sBroker : string): string;
function GetListPassivBrokers(sUserToken, sClientName : string): string;

// Passiv -> list_accounts
function GetListPassivAccts(sUserToken, sClientName : string): string;

// Passiv -> holdings
function GetListPassivHoldings(sUserToken, sClientName : string): string;

// Passiv -> transactions
procedure ReadPassivIntoStrList(var sJSON : String; bClear : boolean; sAcctId : string);
function GetPassivTrans(sUserToken, sClientName, sStartDate, sEndDate, sBrokerId, sAcctId : string): string;
function GetPassivRawTrans(sUserToken, sClientName, sStartDate, sEndDate, sBrokerId, sAcctId : string): string;

// Passiv -> currency_list

// Passiv -> currencyRate

// Passiv -> ticker_symbols
function GetTickerSymbol(sDesc : string): string;

function TestAllPassivData(sUserToken, sClientName : string): string;

var
  bBrokerDisabled : boolean;


implementation

uses
  TL_API, //
  funcproc, // for ParseCSV
  TLCommonLib, // for TAB, CR, LF
  DateUtils, // for UnixToDateTime
  Import, // for ImpStrList
  TLFile, // for TradeLogFile
  globalVariables;

// --------------------------------------------------------
// Unit-level (internal) routines
// --------------------------------------------------------

// ------------------------------------
// convert integer to base 62 string
// ------------------------------------
function convertToBase62(num : integer): string;
const base62Digits = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
var
  base62 : string;
  i, remainder : integer;
begin
  base62 := ''; // init
  i := num;
  while (i > 0) do begin
    remainder := i mod 62;
    base62 := base62Digits[remainder+1] + base62;
    i := i div 62;
  end;
  result := base62;
end;


// ------------------------------------
// check if Passiv system is ready
// ------------------------------------
function GetPassivStatus(sUserToken : string): string; // 2024-08-27 MB - NOT USED
var
  sURL, sData, sStatus, s : string;
  postData : AnsiString;
  postHead : TStringStream;
  i : integer;
begin
//  sURL := 'https://brokerconnect.live/api/v2.5/passiv/status';
  sURL := API_BASE + BC_VER + 'passiv/status';
  try
    postHead := TStringStream.Create('');
    with postHead do begin
      WriteString('api: ' + API_KEY + sLineBreak);
      WriteString('Content-Type: application/json' + sLineBreak);
      WriteString('charset: utf-8' + sLineBreak);
    end;
    // ----------------------------------------------------
    postData := '{"UserToken":"' + sUserToken + '"}';
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
end; // GetPassivStatus


// To list all relevant clients for a customer: /list_tl_clients
// name of clients (p_clients table) that belong to a user.
// URL = brokerconnect.live/api/v2.5/passiv/list_tl_clients
// JSON request POST
// {
//  "UserToken" : "35bcd5ed-37f4-11ed-942aslf"
// }
// Response
// {
//  "Name": "ralph"
// }
// OR
// {
//  "success": "true",
//  "message": "There are no passiv clients set up for this user"
// }
// OR
// {
//  "success": "false",
//  "message": "The UserToken does not exist."
// }
function GetListTLClients(sUserToken : string): string; // 2024-08-27 MB - NOT USED
var
  sURL, sData, sStatus, s : string;
  postData : AnsiString;
  postHead : TStringStream;
  i : integer;
begin
//  sURL := 'https://brokerconnect.live/api/v2.5/passiv/list_tl_clients';
  sURL := API_BASE + BC_VER + 'passiv/list_tl_clients';
  try
    postHead := TStringStream.Create('');
    with postHead do begin
      WriteString('api: ' + API_KEY + sLineBreak);
      WriteString('Content-Type: application/json' + sLineBreak);
      WriteString('charset: utf-8' + sLineBreak);
    end;
    // ----------------------------------------------------
    postData := '{"UserToken":"' + sUserToken + '"}';
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
end; // GetListTLClients


// Creates (Registers) a new name that belongs to a user.
// The return, if successful, is the SECRET key that is
// stored and used for other Passiv API endpoints.
// URL = brokerconnect.live/api/v2.5/passiv/create_client
// JSON request POST
// {
//  "UserToken" : "35bcd5ed-37f4-11ed-942aslf",
//  "name": "jen"
// }
// Response
// {
//  "success": true,
//  "message": "jen created successfully."
// }
// OR
// {
//  "success": false,
//  "message": "jen already exists."
// }
function CreatePassivClient(sUserToken, sClientName : string): string; // used in ImportSetup
var
  sURL, sData, sStatus, s : string;
  postData : AnsiString;
  postHead : TStringStream;
  i : integer;
begin
//  sURL := 'https://brokerconnect.live/api/v2.5/passiv/create_client';
  sURL := API_BASE + BC_VER + 'passiv/create_client';
  try
    postHead := TStringStream.Create('');
    with postHead do begin
      WriteString('api: ' + API_KEY + sLineBreak);
      WriteString('Content-Type: application/json' + sLineBreak);
      WriteString('charset: utf-8' + sLineBreak);
    end;
    // ----------------------------------------------------
    postData := '{"UserToken":"' + sUserToken //
      + '","name": "' + sClientName + ':' + v2CustomerId //
      + '"}';
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
    s := GetListPassivBrokers(sUserToken, sClientName); // Force update 1
    s := GetListPassivAccts(sUserToken, sClientName); // Force update 2
  end;
end; // CreatePassivClient


// Check to see if a client exists in Passiv
function CheckPassivClient(sUserToken, sClientName : string): string;
var
  sURL, sData, sStatus, s : string;
  postData : AnsiString;
  postHead : TStringStream;
  i : integer;
begin
//  sURL := 'https://brokerconnect.live/api/v2.5/passiv/list_passiv_clients';
  sURL := API_BASE + BC_VER + 'passiv/list_passiv_client';
  try
    postHead := TStringStream.Create('');
    with postHead do begin
      WriteString('api: ' + API_KEY + sLineBreak);
      WriteString('Content-Type: application/json' + sLineBreak);
      WriteString('charset: utf-8' + sLineBreak);
    end;
    // ----------------------------------------------------
    postData := '{"UserToken":"' + sUserToken //
      + '","name": "' + sClientName + ':' + v2CustomerId //
      + '"}';
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
end; // CheckPassivClient


// To list all registered clients: list_passiv_clients
// URL = brokerconnect.live/api/v2.5/passiv/list_passiv_clients
// JSON request POST
// Response
// [
//  "bob",
//  "ralph"
// ]
function GetListPassivClients(sUserToken : string): string; // 2024-08-27 MB - NOT USED
var
  sURL, sData, sStatus, s : string;
  postData : AnsiString;
  postHead : TStringStream;
  i : integer;
begin
//  sURL := 'https://brokerconnect.live/api/v2.5/passiv/list_passiv_clients';
  sURL := API_BASE + BC_VER + 'passiv/list_passiv_clients';
  try
    postHead := TStringStream.Create('');
    with postHead do begin
      WriteString('api: ' + API_KEY + sLineBreak);
      WriteString('Content-Type: application/json' + sLineBreak);
      WriteString('charset: utf-8' + sLineBreak);
    end;
    // ----------------------------------------------------
    postData := '{"UserToken":"' + sUserToken //
      + '"}';
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
end; // GetListPassivClients


// ------------------------------------------------------
// Deletes (unRegisters) a name that belongs to a user.
// The return, if successful, is the SECRET key that is
// stored and used for other Passiv API endpoints.
// URL = brokerconnect.live/api/v2.5/passiv/delete_client
// JSON request POST
// {
//  "UserToken" : "35bcd5ed-37f4-11ed-942aslf",
//  "name": "jen"
// }
// Response
// {
//  "success": true,
//  "message": "jen deleted successfully."
// }
// OR
// {
//  "success": false,
//  "message": "jen doesn't exist."
// }
function DeletePassivClient(sUserToken, sClientName : string): string; // 2024-08-27 MB - NOT USED
var
  sURL, sData, sStatus, s : string;
  postData : AnsiString;
  postHead : TStringStream;
  i : integer;
begin
//  sURL := 'https://brokerconnect.live/api/v2.5/passiv/delete_client';
  sURL := API_BASE + BC_VER + 'passiv/delete_client';
  try
    postHead := TStringStream.Create('');
    with postHead do begin
      WriteString('api: ' + API_KEY + sLineBreak);
      WriteString('Content-Type: application/json' + sLineBreak);
      WriteString('charset: utf-8' + sLineBreak);
    end;
    // ----------------------------------------------------
    postData := '{"UserToken":"' + sUserToken //
      + '","name": "' + sClientName //
      + '"}';
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
end; // DeletePassivClient


// ------------------------------------------------------
// removes all account links for a given client and broker
// ------------------------------------------------------
procedure DeleteBrokerLink(sUserToken, sClientName, sBroker : string); // used in ImportSetup
var
  sURL, sData, sStatus, s : string;
  postData : AnsiString;
  postHead : TStringStream;
  i : integer;
  lineLst : TStrings;
begin
//  sURL := 'https://brokerconnect.live/api/v2.5/passiv/delete_broker';
  sURL := API_BASE + BC_VER + 'passiv/delete_broker';
  try
    postHead := TStringStream.Create('');
    with postHead do begin
      WriteString('api: ' + API_KEY + sLineBreak);
      WriteString('Content-Type: application/json' + sLineBreak);
      WriteString('charset: utf-8' + sLineBreak);
    end;
    // ----------------------------------------------------
    postData := '{"UserToken":"' + sUserToken //
      + '","name": "' + sClientName + ':' + v2CustomerId //
      + '","broker": "' + sBroker //
      + '"}';
    sData := postData;
    // ----------------------------------------------------
    sStatus := ReadBrokerConnectPost(sURL, postHead, postData, 'POST');
    s := trim(postData);
    if POS('200 ', sStatus) = 1 then begin
      if (s = '') then begin
        sm('ERROR: ' + sStatus);
        exit;
      end;
      s := parseHTML(s, '{', '}'); // just remove braces
      lineLst := ParseCSV(s,':','"');
      if (lineLst = nil) then begin
        sm('ERROR deleting link.');
        exit;
      end
      else if (lineLst.count > 1) then begin
        if (uppercase(lineLst[0]) = 'MESSAGE') //
        or (uppercase(lineLst[0]) = 'ERROR') then begin
          s := lineLst[1];
          sm(s);
        end; // if lineLst[0]
      end; // if lineLst.count
    end
    else begin
      sm('ERROR deleting link.');
    end; // if sStatus
  finally
    postHead.Free;
  end;
end; //


procedure LaunchPassivLink(sData, sClientName : string);
var
  s : string;
  lineLst : TStrings;
begin
  // {
  //  "link":"https://brokerconnect.live/v2?t=<reallylongstring>",
  //  "LinkToken":"fe2ba012-5067-4f14-8c76-77c275815f87"
  // }
  s := parseHTML(sData, '{', '}'); // just remove braces
  lineLst := ParseCSV(s,':','"');
  if (lineLst = nil) then begin
    sm('Web service unavailable at this time.' + CR //
        + 'If this error persists, please contact TradeLog Support.');
    exit;
  end;
  if (lineLst.count < 3) then begin
    if pos('client doesn''t have an account', s) > 1 then begin
      sm('A problem was detected with your account link.' + CRLF //
       + 'TradeLog will attempt to automatically fix it.');
      s := CreatePassivClient(v2ClientToken, sClientName); //
    end
    else begin
      sm('unexpected link data returned by server.' + CR //
        + 'Please contact TradeLog Support.');
      exit;
    end;
  end;
  s := lineLst[1];
  if POS('https', s) < 1 then begin
    sm('unexpected link data returned by server.' + CR //
        + 'Please contact TradeLog Support.');
    exit;
  end;
  // --------------
  if (ProVer) or (SuperUser) then begin
    clipboard.AsText := s;
    sm('Paste the one-time setup link into an email or browser.');
  end
  else begin
    webURL(s);
  end;
end;


// Return an URL to connect to Broker(s)
// URL = brokerconnect.live/api/v2.5/passiv/broker_link
// JSON request POST
// {
//  "UserToken" : "35bcd5ed-37f4-11ed-942aslf",
//  "name": "jen"
// }
// Response
// {
//  "redirectURI": "https://app.snaptrade.com/snapTrade/redeemToken?token=A6mBf56YvdEU5Ba5qpfsrtYprlRhCB/FMXR68zgphe8TKN..."
// }
// OR
// {
//  "success": "false",
//  "message": "The UserToken does not exist."
// }
// OR
// {
// "success": "false",
// "message": "The passiv client does not exist for this TradeLog user."
// }
function GetPassivBrokerLink(sUserToken, sClientName : string): string;
var
  sURL, sData, sStatus, s : string;
  postData : AnsiString;
  postHead : TStringStream;
  i : integer;
begin
//  sURL := 'https://brokerconnect.live/api/v2.5/passiv/broker_link';
  sURL := API_BASE + BC_VER + 'passiv/broker_link';
  try
    postHead := TStringStream.Create('');
    with postHead do begin
      WriteString('api: ' + API_KEY + sLineBreak);
      WriteString('Content-Type: application/json' + sLineBreak);
      WriteString('charset: utf-8' + sLineBreak);
    end;
    // ----------------------------------------------------
    postData := '{"UserToken":"' + sUserToken //
      + '","name": "' + sClientName + ':' + v2CustomerId //
      + '"}';
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
end; // CreatePassivClient


// -------------------------------
// Get BrokerId from BrokerName
// -------------------------------

function GetPassivBrokerId(sToken, sName, sBroker : string): string;
var
  ii, jj : integer;
  sTmp, sBrokerId, sJSON, ss : string;
  BrokerLst, lineLst : TStrings;
begin
  result := ''; // default
  bBrokerDisabled := false; // 2025-03-13 MB - clear before testing
  sTmp := GetListPassivBrokers(sToken, sName);
  sJSON := ParseBetween(sTmp, '[', ']'); // because API returns '[[r1],[r2]]'
  //
  if leftstr(sJSON,1) = '[' then
    BrokerLst := ParseJSON(sJSON, '[', ']')
  else
    BrokerLst := ParseJSON(sJSON, '{', '}');
  if BrokerLst = nil then exit;
  if BrokerLst.Count < 1 then exit;
  // ------------------------
  for ii := 0 to BrokerLst.Count-1 do begin
    ss := BrokerLst[ii];
    lineLst := ParseV2APIResponse(ss);
    if (lineLst.Count < 3) then begin // it's an array (old)
      if lineLst[1] = sBroker then begin
        result := lineLst[0];
        exit;
      end;
    end
    else if (lineLst[0] = 'id') then begin // it's a JSON
      if lineLst[3] = sBroker then begin
        result := lineLst[1];
        if lineLst[6] = 'disabled' then begin
          bBrokerDisabled := (lineLst[7] = 'true');
        end;
        exit;
      end;
    end;
  end;
end;


// Return a list of brokers and insert into p_table
// URL = brokerconnect.live/api/v2.5/passiv/brokers
// JSON request POST
// {
//  "UserToken" : "35bcd5ed-37f4-11ed-942aslf",
//  "name": "jen"
// }
// Response
// [
//  ["b6d3c241-197a-4d3e-8acb-07991033e923", "Alpaca"],
//  ["9bc5bdd4-4944-468e-ba1e-628bd7d6ad44", "Robinhood"]
// ]
// OR
// {
//  "status": "fail",
//  "message": "User does not exist."
// }
function GetListPassivBrokers(sUserToken, sClientName : string): string; // used in this unit!
var
  sURL, sData, sStatus, s : string;
  postData : AnsiString;
  postHead : TStringStream;
  i : integer;
begin
//  sURL := 'https://brokerconnect.live/api/v2.5/passiv/brokers';
  sURL := API_BASE + BC_VER + 'passiv/brokers';
  try
    postHead := TStringStream.Create('');
    with postHead do begin
      WriteString('api: ' + API_KEY + sLineBreak);
      WriteString('Content-Type: application/json' + sLineBreak);
      WriteString('charset: utf-8' + sLineBreak);
    end;
    // ----------------------------------------------------
    postData := '{"UserToken":"' + sUserToken //
      + '","name": "' + sClientName + ':' + v2CustomerId //
      + '"}';
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
end; // GetListPassivBrokers


// Reads Accounts from p_broker_accounts table
// Returns array of [id, acctname, acctnum, authorization]
// URL = brokerconnect.live/api/v2.5/passiv/list_accounts
// Json request POST
// {
//  "UserToken" : "35bcd5ed-37f4-11ed-942aslf",
//  "name": "jen"
// }
// Response:
// BrokerId
// Name
// Broker Number
// brokerage_authorization
// [
//  [
//   "aa005028-bcd2-477f-8d83-0c11d320a965", // account id
//   "Alpaca Margin",                        // acct name
//   "870903896",                            // acct number
//   "b6d3c241-197a-4d3e-8acb-07991033e923"  // broker id
//  ],
//  [<another record>...]
// OR
// {
//  "success": "false",
//  "message": "The UserToken does not exist."
// }
// OR
// {
//  "success": "false",
//  "message": "The passiv client does not exist for this TradeLog user."
// }
function GetListPassivAccts(sUserToken, sClientName : string): string;
var
  sURL, sData, sStatus, s : string;
  postData : AnsiString;
  postHead : TStringStream;
  i : integer;
begin
//  sURL := 'https://brokerconnect.live/api/v2.5/passiv/list_accounts';
  sURL := API_BASE + BC_VER + 'passiv/list_accounts';
  try
    postHead := TStringStream.Create('');
    with postHead do begin
      WriteString('api: ' + API_KEY + sLineBreak);
      WriteString('Content-Type: application/json' + sLineBreak);
      WriteString('charset: utf-8' + sLineBreak);
    end;
    // ----------------------------------------------------
    postData := '{"UserToken":"' + sUserToken //
      + '","name": "' + sClientName + ':' + v2CustomerId //
      + '"}';
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
end; // GetListPassivAccts


// Return the holdings
// URL = brokerconnect.live/api/v2.5/passiv/holdings
// JSON request POST
// {"UserToken" : "35bcd5ed-37f4-11ed-942aslf","name": "jen"}
// Response
// [
//  {"account":
//   {"brokerage_authorization":
//    {"id": "b6d3c241-197a-4d3e-8acb-07991033e923",
//     "created_date": "2023-07-19T21:57:11.097944Z",
//     "updated_date": "2023-07-19T21:57:11.701683Z",
//     "brokerage":
//     {"authorization_types":
//      [...
// ...
// OR
// {
//  "success": "false",
//  "message": "The UserToken does not exist."
// }
// OR
// {
//  "success": "false",
//  "message": "The passiv client does not exist for this TradeLog user."
// }
function GetListPassivHoldings(sUserToken, sClientName : string): string;
var
  sURL, sData, sStatus, s : string;
  postData : AnsiString;
  postHead : TStringStream;
  i : integer;
begin
//  sURL := 'https://brokerconnect.live/api/v2.5/passiv/holdings';
  sURL := API_BASE + BC_VER + 'passiv/holdings';
  try
    postHead := TStringStream.Create('');
    with postHead do begin
      WriteString('api: ' + API_KEY + sLineBreak);
      WriteString('Content-Type: application/json' + sLineBreak);
      WriteString('charset: utf-8' + sLineBreak);
    end;
    // ----------------------------------------------------
    postData := '{"UserToken":"' + sUserToken //
      + '","name": "' + sClientName + '"}';
    sData := postData;
    // ----------------------------------------------------
    sStatus := ReadBrokerConnectPost(sURL, postHead, postData, 'POST');
    s := uppercase(postData);
    if POS('200 ', sStatus) = 1 then begin
      result := FormatV2APIResponse(postData);
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
end; // GetListPassivHoldings


// ------------------------------------
// Transactions
// ------------------------------------
// [
//  {
//   "id":"fb62355d-8cbe-4999-8fdb-320a63b0ad15",
//   "symbol_description":"Spartannash Co",
//   "symbol_id":"013cec2f-0a37-4efb-9088-9e03419b3d02",
//   "symbol":"SPTN",
//   "raw_symbol":"SPTN",
//   "instrumenttype_id":"515c27d1-8471-4dec-a234-af12184c51d4",
//   "instrumenttype_description":"Common Stock",
//   "currency_code":"USD",
//   "currency_name":"US Dollar",
//   "type":"BUY",
//   "description":"2021-06-18 LONG CALL 1.0000 units for SPTN at $0.20",
//   "amount":-20,
//   "price":0.2,
//   "units":1,
//   "fee":0,
//   "settlement_date":"2021-06-02t19:39:40.583000z",
//   "trade_date":"2021-06-02t19:39:40.583000z",
//   -------- option data -------------
//   "ticker":"SPTN  210618C00022500",
//   "strike_price":22.5,
//   "expiration_date":"2021-06-18",
//   "is_mini_option":false,
//   "underlying_symbol":"SPTN",
//   "option_type":"CALL"
//  }, ...
// ]
procedure ReadPassivIntoStrList(var sJSON : String; bClear : boolean; sAcctId : string);
var
  amt, pr, qty, cm : double;
  i, j, nErrs, R : integer;
  S, t, sTmp, sBroker : string;
  sDate, sType, sOC, sAmt, sDesc, sQty, sPrice, sTick, sCom, sCusp, sMeta, sOBS, sAcct : string;
  sUnderlying, sStrike, sCP, sExpDt, sMini, sOpTick : string;
  dt : TDate;
  recLst, fldLst : TStrings;
  // ------------------------
  procedure ResetVars;
  begin
    sDate := '';
    sOC := '';
    sTick := '';
    sCom := '';
    sDesc := '';
    sType := '';
    sPrice := '';
    sQty := '';
    sAmt := '';
    sCusp := '';
    sMeta := '';
    sOpTick := '';
    sUnderlying := '';
    sExpDt := '';
    sCP := '';
    sStrike := '';
    sMini := '';
    sOBS := '';
  end;
  // ------------------------
begin
  if bClear then begin // command switch to reset ImpStrList
    ImpStrList.Clear;
    t := 'DATE' + TAB + 'OCLS' + TAB + 'TICK' + TAB + 'COMM' + TAB + 'DESC' //
      + TAB + 'TYPE' + TAB + 'PRC' + TAB + 'QTY' + TAB + 'AMT' //
      + TAB + 'CUSP' + TAB + 'META' + TAB + 'OPTICK' //
      + TAB + 'UNDERLYING' + TAB + 'EXPDT' + TAB + 'CP' + TAB + 'STRIKE' //
      + TAB + 'MINI' + TAB + 'OBS' + TAB + 'ACCT';
    ImpStrList.Add(t);
  end;
  // ----------------------------------
  s := lowercase(trim(sJSON));
  sTmp := parseBetween(s, '[', ']');
  if length(sTmp) < 4 then begin
//    showmessage('No data.');
    exit;
  end;
  // ----------------------------------
  R := ImpStrList.Count;
  try
    recLst := ParseJSON(sTmp); //                         create recLst
    if (recLst = nil) or (recLst.Count < 1) then begin
      showmessage('No data received from broker.');
      exit;
    end;
    // ----------------------
    nErrs := 0;
    i := 0;
    sOpTick := '';
    while (i < recLst.Count) do begin
      sTmp := recLst[i];
      statBar('Reading ' + inttostr(i+R+1) + ' of ' + inttostr(recLst.Count+R));
      fldLst := ParseV2APIResponse(sTmp); //              create fldLst
      if (fldLst = nil) or (fldLst.Count < 18) then begin
        if Developer and (nErrs < 2) then begin
          showmessage('Data format is incorrect:' + CRLF + sTmp);
          nErrs := nErrs + 1;
        end;
        continue;
      end;
      // ----------------------
      if assigned(fldLst)=false then continue;
      j := 0;
      ResetVars;
      while (j < fldLst.Count) do begin
        sTmp := fldLst[j];
        if sTmp = 'trade_date' then
          sDate := fldLst[j+1]
        else if sTmp = 'type' then
          sOC := fldLst[j+1]
        else if sTmp = 'symbol' then
          sTick := fldLst[j+1]
        else if sTmp = 'fee' then
          sCom := fldLst[j+1]
        else if sTmp = 'symbol_description' then
          sDesc := fldLst[j+1]
        else if sTmp = 'instrumenttype_description' then
          sType := fldLst[j+1]
        else if sTmp = 'price' then
          sPrice := fldLst[j+1]
        else if sTmp = 'units' then
          sQty := fldLst[j+1]
        else if sTmp = 'amount' then
          sAmt := fldLst[j+1]
        else if sTmp = 'cusip' then
          sCusp := fldLst[j+1]
        else if sTmp = 'description' then
          sMeta := fldLst[j+1]
        else if sTmp = 'ticker' then
          sOpTick := fldLst[j+1]
        else if sTmp = 'underlying_symbol' then
          sUnderlying := fldLst[j+1]
        else if sTmp = 'expiration_date' then
          sExpDt := fldLst[j+1]
        else if sTmp = 'option_type' then
          sCP := fldLst[j+1]
        else if sTmp = 'strike_price' then
          sStrike := fldLst[j+1]
        else if sTmp = 'is_mini_option' then
          sMini := fldLst[j+1]
        else if sTmp = 'option_buysell' then
          sObs := fldLst[j+1]
        else if sTmp = 'account_id' then
          sAcct := fldLst[j+1];
        j := j + 2; // pairs
      end;
      fldLst.Free; //                                          free memory
      // --- build record -----------
      if (sAcct = sAcctId) then begin
        S := 'add';
        t := sDate + TAB + sOC + TAB + sTick + TAB + sCom + TAB + sDesc //
          + TAB + sType + TAB + sPrice + TAB + sQty + TAB + sAmt + TAB //
          + sCusp + TAB + sMeta + TAB + sOpTick //
          + TAB + sUnderlying + TAB + sExpDt + TAB + sCP + TAB + sStrike //
          + TAB + sMini + TAB + sOBS + TAB + sAcct;
        ImpStrList.Add(t);
      end else begin
        t := ''; // wrong account, so clear it
      end;
      i := i + 1;
    end; // while i < count
    if Developer and (i >= 9999) then sm('record limit');
    recLst.Free; //                                            free memory
  except
    on E : Exception do begin
      sm('Read API data failed on row ' + IntToStr(i) + ' in ' + S + CRLF //
        + E.ClassName + ': ' + E.Message);
    end;
  end;
end; // ReadPassivIntoStrList


// --------------------------------------------------------
// Return the historical transactions
// URL = brokerconnect.live/api/v2.5/passiv/transactions
// JSON request POST
// {
//  "UserToken": "59d4acf6-0ef4-11ee-be24-088fc34537c8",
//  "name": "ralph",
//  "startDate": "2022-01-24",
//  "endDate": "2023-01-24",
//  "brokers": "9bc5bdd4-4944-468e-ba1e-628bd7d6ad44",
//  "accounts": "45542808-3c0b-41d2-afc9-755dce0ff945,939267b6-22c3-4a45-8e97-1dc6f56a56d8"
// }
// Response
// [
// {"account":
//  {"brokerage_authorization":
//   {"id": "b6d3c241-197a-4d3e-8acb-07991033e923",
//    "created_date": "2023-07-19T21:57:11.097944Z",
//    "updated_date": "2023-07-19T21:57:11.701683Z",
//    "brokerage": {
//     "authorization_types": [
// ...
// OR
// {
//  "success": "false",
//  "message": "The UserToken does not exist."
// }
// OR
// {
//  "success": "false",
//  "message": "The passiv client does not exist for this TradeLog user."
// }
function GetPassivTrans(sUserToken, sClientName, sStartDate, sEndDate, sBrokerId, sAcctId : string): string;
var
  sURL, sStatus, s, sFile : string;
  postData : AnsiString;
  postHead : TStringStream;
  i : integer;
begin
//  sURL := 'https://brokerconnect.live/api/v2.5/passiv/transactions';
  sURL := API_BASE + BC_VER + 'passiv/transactions'; // dev
  try
    postHead := TStringStream.Create('');
    with postHead do begin
      WriteString('api: ' + API_KEY + sLineBreak);
//      WriteString('api: de835869ae0fb9413f207482f4b4d47a19810c2c7171f4a0351ca02fc7fc4eec' + sLineBreak); // dev
      WriteString('Content-Type: application/json' + sLineBreak);
      WriteString('charset: utf-8' + sLineBreak);
    end;
    // ----------------------------------------------------
    postData := '{"UserToken":"' + sUserToken //
      + '","name": "' + sClientName + ':' + v2CustomerId
      + '","startdate": "' + sStartDate
      + '","enddate": "' + sEndDate
      + '","brokers": "' + sBrokerId
      + '","accounts": "' + sAcctId
      + '"}';
    // ----------------------------------------------------
    s := postData;
    screen.Cursor := crHourglass; // disable cursor
    sStatus := ReadBrokerConnectPost(sURL, postHead, postData, 'POST');
    screen.Cursor := crDefault; // reenable cursor
    if (s = postData) or (postData = '') then begin
      result := 'ERROR: the server failed to respond.';
      exit;
    end;
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
end; // GetPassivTrans

function GetPassivRawTrans(sUserToken, sClientName, sStartDate, sEndDate, sBrokerId, sAcctId : string): string;
var
  sURL, sStatus, s, sFile : string;
  postData : AnsiString;
  postHead : TStringStream;
  i : integer;
begin
// sURL := 'https://brokerconnect.live/api/v2.5/passiv/transactions_original';
  sURL := API_BASE + BC_VER + 'passiv/transactions_original';
  try
    postHead := TStringStream.Create('');
    with postHead do begin
      WriteString('api: ' + API_KEY + sLineBreak);
//      WriteString('api: de835869ae0fb9413f207482f4b4d47a19810c2c7171f4a0351ca02fc7fc4eec' + sLineBreak); // dev
      WriteString('Content-Type: application/json' + sLineBreak);
      WriteString('charset: utf-8' + sLineBreak);
    end;
    // ----------------------------------------------------
    postData := '{"UserToken":"' + sUserToken //
      + '","name": "' + sClientName + ':' + v2CustomerId
      + '","startdate": "' + sStartDate
      + '","enddate": "' + sEndDate
      + '","brokers": "' + sBrokerId
      + '","accounts": "' + sAcctId
      + '"}';
    // ----------------------------------------------------
    s := postData;
    screen.Cursor := crHourglass; // disable cursor
    sStatus := ReadBrokerConnectPost(sURL, postHead, postData, 'POST');
    screen.Cursor := crDefault; // reenable cursor
    if (s = postData) then begin
      result := 'ERROR: the server failed to respond.';
      exit;
    end;
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
end; // GetPassivRawTrans


// Passiv -> transactions
// Passiv -> currency_list
// Passiv -> currencyRate

// Passiv -> ticker_symbols
// ------------------------------------
//
// ------------------------------------
// To list all relevant clients for a customer: /ticker_symbols
// name of clients (p_clients table) that belong to a user.
// URL = brokerconnect.live/api/v2.5/passiv/ticker_symbols
// JSON request POST
// {
//  "UserToken" : "35bcd5ed-37f4-11ed-942aslf",
//  "name": "jen"
//  "tickerDesc": "tesla"
// }
// Response
// {
//  "Name": "ralph"
// }
// OR
// {
//  "success": "true",
//  "message": "There are no passiv clients set up for this user"
// }
// OR
// {
//  "success": "false",
//  "message": "The UserToken does not exist."
// }
function GetTickerSymbol(sDesc : string): string;
var
  sURL, sData, sStatus, s : string;
  postData : AnsiString;
  postHead : TStringStream;
  i : integer;
  sTmp: string;
  SymbolLst, lineLst : TStrings;
begin
//  sURL := 'https://brokerconnect.live/api/v2.5/passiv/ticker_symbols';
  sURL := API_BASE + BC_VER + 'passiv/ticker_symbols';
  result := '';
  try
    screen.Cursor := crHourglass;
    postHead := TStringStream.Create('');
    with postHead do begin
      WriteString('api: ' + API_KEY + sLineBreak);
      WriteString('Content-Type: application/json' + sLineBreak);
      WriteString('charset: utf-8' + sLineBreak);
    end;
    sData := postData;
    // ----------------------------------------------------
    postData := '{"UserToken":"' + v2ClientToken //
      + '","name": "TradeLog' // test shows it just needs to be non-blank
      + '","tickerDesc": "' + sDesc //
      + '"}';
    // ----------------------------------------------------
    s := postData;
    screen.Cursor := crHourglass; // disable cursor
    sStatus := ReadBrokerConnectPost(sURL, postHead, postData, 'POST');
    s := uppercase(postData);
    if POS('200 ', sStatus) = 1 then begin
      sTmp := postData;
      SymbolLst := ParseJSON(sTmp); //
      for i := 0 to SymbolLst.Count-1 do begin
        sTmp := SymbolLst[i];
        lineLst := ParseV2APIResponse(sTmp);
        if assigned(lineLst)=false then continue;
        if lineLst.Count >= 5 then begin // first field is 0th
          if (pos(uppercase(sDesc), uppercase(lineLst[3])) = 1) // description
          and (lineLst[5] = 'USD') // currency
          then begin
            result := lineLst[1]; // symbol
            break; // exit loop
          end; // if available and not canceled
        end; // if line has enough fields
      end; // for i loop
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
    screen.Cursor := crDefault;
  end;
end; // GetTickerSymbol


// ------------------------------------
// check if Passiv system is ready
// ------------------------------------
function TestAllPassivData(sUserToken, sClientName : string): string;
var
  sURL, sData, sStatus, s : string;
  postData : AnsiString;
  postHead : TStringStream;
  i : integer;
begin
  try
    postHead := TStringStream.Create('');
    with postHead do begin
      WriteString('api: ' + API_KEY + sLineBreak);
      WriteString('Content-Type: application/json' + sLineBreak);
      WriteString('charset: utf-8' + sLineBreak);
    end;
    // ----------------------------------------------------
//    sURL := 'https://brokerconnect.live/api/v2.5/passiv/status';
    sURL := API_BASE + BC_VER + 'passiv/status';
    postData := '{"UserToken":"' + sUserToken + '"}';
    sData := postData;
    sStatus := ReadBrokerConnectPost(sURL, postHead, postData, 'POST');
    sm('status:' + CRLF + postData);
    // ----------------------------------------------------
//    sURL := 'https://brokerconnect.live/api/v2.5/passiv/list_tl_clients';
    sURL := API_BASE + BC_VER + 'passiv/list_tl_clients';
    postData := '{"UserToken":"' + sUserToken + '"}';
    sData := postData;
    sStatus := ReadBrokerConnectPost(sURL, postHead, postData, 'POST');
    sm('list tl clients:' + CRLF + postData);
    // ----------------------------------------------------
//    sURL := 'https://brokerconnect.live/api/v2.5/passiv/list_passiv_clients';
    sURL := API_BASE + BC_VER + 'passiv/list_passiv_clients';
    postData := '{"UserToken":"' + sUserToken + '"}';
    sData := postData;
    sStatus := ReadBrokerConnectPost(sURL, postHead, postData, 'POST');
    sm('list tl clients:' + CRLF + postData);
    // ----------------------------------------------------
//    sURL := 'https://brokerconnect.live/api/v2.5/passiv/brokers';
    sURL := API_BASE + BC_VER + 'passiv/brokers';
    postData := '{"UserToken":"' + sUserToken //
      + '","name": "' + sClientName + '"}';
    sData := postData;
    sStatus := ReadBrokerConnectPost(sURL, postHead, postData, 'POST');
    sm('list brokers:' + CRLF + postData);
    // ----------------------------------------------------
//    sURL := 'https://brokerconnect.live/api/v2.5/passiv/list_accounts';
    sURL := API_BASE + BC_VER + 'passiv/list_accounts';
    postData := '{"UserToken":"' + sUserToken //
      + '","name": "' + sClientName + '"}';
    sData := postData;
    sStatus := ReadBrokerConnectPost(sURL, postHead, postData, 'POST');
    sm('list accounts:' + CRLF + postData);
    // ----------------------------------------------------
  finally
  //
  end;
end;


end.
