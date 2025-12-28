unit TLPassiv;

interface

uses
  Sysutils, StrUtils, Dialogs, Variants, Classes, clipBrd, TLWinInet, uLkJSON;

// --- translate TradeLog/Plaid -------
function IsSameBroker(Filt, Brok : string): boolean;

// --- Authentication/Permissions -----
//function GetAuthenticate(sEmail, sPwd : string): string; // returns CustomerToken

// --- BrokerConnect Setup ------------
function GetPlaidAccounts(sUserName, sInsId, sFilter : string): string;
function GetEncryptedLink(sUser, sInsId : string): string;

function InsertClient(sToken, sUser, sIns : string): string;
function UpdateClient(sToken, sUser, sIns, sNew : string): string;


// --- BrokerConnect Downloads --------
function GetPlaidTrans(sInsId, sAcctId, sFromDate, sToDate, sUserName : string): string;
function GetPlaidHoldings(sAcctId, sUserName : string): string;

var
  API_VER: integer = 2; // default (SuperUser can change this)

implementation

uses
  TL_API,
  TLFile, funcproc, TLCommonLib, TLSettings, Import, globalVariables;

const
  DEBUGGING : boolean = false;
//  API_KEY: string = '8?xP*o&zdA&Qa16oU$F9TCk@45$mS*';
//  API_KEYv2 : string = '8?xP*o&zdA&Qa16oU$F9TCk@45$mS*'; // v2 API


// --------------------------------------------------------
// Unit-level (internal) routines
// --------------------------------------------------------
function JSONFieldExists(jsO : TlkJSONObject; sName : string) : boolean;
var
  idx : integer;
begin
  result := false; // until proven true
  if (jsO = nil) then
    exit;
  idx := jsO.IndexOfName(sName);
  if (idx < 1) then
    exit;
  result := true;
end; // JSONFieldExists


function IsSameBroker(Filt, Brok : string): boolean;
var
  sFilter, sBroker : string;
begin
  sBroker := Uppercase(Brok);
  sFilter := Uppercase(Filt);
  if (leftstr(sBroker, 8) = 'E*TRADE') then begin
    if (sFilter = 'ETRADE') then
      exit(true)
    else
      exit(false);
  end
  else if (leftstr(sBroker, 9) = 'FIDELITY') then begin
    if (sFilter = 'FIDELITY') then
      exit(true)
    else
      exit(false);
  end
  else if (sBroker = 'CHARLES SCHWAB') then begin
    if (sFilter = 'CHARLES SCHWAB') then
      exit(true)
    else
      exit(false);
  end
  else if (sBroker = 'ROBINHOOD') then begin
    if (sFilter = 'ROBINHOOD') then
      exit(true)
    else
      exit(false);
  end
  else if (sBroker = 'TASTYWORKS') then begin
    if (sFilter = 'TASTYWORKS') then
      exit(true)
    else
      exit(false);
  end
  else if (sBroker = 'TD AMERITRADE INC.') then begin
    if (sFilter = 'TDAMERITRADE') then
      exit(true)
    else
      exit(false);
  end
  else if (leftstr(sBroker, 13) = 'TRADESTATION ') then begin
    if (sFilter = 'TRADESTATION') then
      exit(true)
    else
      exit(false);
  end;
end; // IsSameBroker


// --------------------------------------------------------
// Plaid Broker Accounts
// S <input> is a JSON in this format:
//[{"CustomerName":"Larry Bergus",
//  "Name":"lbergus",
//  "Institution_id":"ins_11",
//  "Institution":"Charles Schwab",
//  "account_name":"Inh IRA from IRA",
//  "account_id":"XJq1jERB1PH3M9wKjkdYtnBKPJEA3Yf0KDp1R"
//},...]
// --------------------------------------------------------
function ParseJSONAccounts(S, sFilter : string): string;
var
  JSONObject : TlkJSONObject;
  JSONChild : TlkJSONObject;
  I, R : integer;
  t, sBroker : string;
begin
  if (v2UserEmail='mark@tradelogsoftware.com') //
  and SuperUser then begin
    clipboard.AsText := S;
  end;
  t := ''; // init
  if pos('Error', S) > 0 then begin
    result := '';
    exit;
  end;
  // ------------------------
  try
    if (POS('{', S) > 0) and (POS('}', S) > POS('{', S)) then begin
      JSONObject := TlkJSONObject(TLKJSON.ParseText(S));
      if JSONObject = nil then begin
        result := '';
        exit;
      end;
      // ------------------------------
      // { "UserToken": "a5db0a14-3817-11ed-942c-f23c938e66e4",
      //   "Customer": "Aaron Thaler",
      //   "ClientName": "jsscher",
      //   "Institution": "Fidelity",
      //   "Institution_id": "ins_12",
      //   "account_name": "JOINT WROS",
      //   "account_id": "LzNv0V6zLouEVeOxK4dohd3P313qBXF8qvx77"

      // [{"account_id":"m3rYQ1wddJCYjYBRAxV4TQ9xXpBKQatM47xnk",
      //   "name":"JOINT WROS",
      //   "official_name":"JOINT WROS"},
      // ...]
      // ------------------------------
      for I := 0 to JSONObject.Count - 1 do begin
        JSONChild := JSONObject.Child[I] as TlkJSONObject;
          if length(t)> 1 then t := t + CRLF;
          t := t + sFilter + TAB //
            + VarToStr(JSONChild.Field['account_name'].Value) //
            + TAB + VarToStr(JSONChild.Field['account_id'].Value);
      end; // for
    end; // if
  finally
    result := t;
  end;
end; // ParseJSONAccounts


// --------------------------------------------------------
// BrokerConnect Setup routines
// --------------------------------------------------------

// URL = https://brokerconnect.live/api/v2/users/auth/hash
// Json request POST:
// {"UserToken": "9fa80b00-64d4-11ed-8efe-f23c938e66e4",
//  "Name": "ralph", client Id
//  "Institution_id": "ins_11" Institution Id}
//
// Response, ERROR:
// {"message": "Unable to find Client / Institution combination."}
// OR SUCCESS:
// {"link": "https://brokerconnect.live/v2?t=a6fba5037830a22c9ab8c3bfce02a575d4fe4a125b3c039cf2b82947f6e29c792f1b...",
//  "LinkToken": "ec2abf0f-76e6-46cb-ba09-22a5b2968887"}
function GetEncryptedLink(sUser, sInsId : string): string;
var
  sURL, sData, sStatus, s : string;
  postData : AnsiString;
  postHead : TStringStream;
begin
  sURL := 'https://brokerconnect.live/api/v2/auth/hash';
  postHead := TStringStream.Create('');
  with postHead do begin
    WriteString('api: ' + GetAPIKey + sLineBreak);
    WriteString('Content-Type: application/json' + sLineBreak);
    WriteString('charset: utf-8' + sLineBreak);
  end;
  postData := '{"UserToken":"' + v2ClientToken //
    + '","Name" : "' + sUser + //
    '","Institution_id": "' + sInsId + '"}';
  s := 'POST';
  // -------------------------------------------------
  try
    sStatus := ReadBrokerConnectPost(sURL, postHead, postData, s);
    if pos('200 OK', sStatus)=1 then begin
      sData := postData;
    end
    else begin
      sData := '';
    end;
  finally
    postHead.Free;
  end;
  result := sData;
end; // GetEncryptedLink


function GeneratePwd(sText : string): string;
var
  sURL, sData, sStatus, S : string;
  postData : AnsiString;
  postHead : TStringStream;
begin
  sURL := 'https://brokerconnect.live/api/v2/generatePassword';
  try
    postHead := TStringStream.Create('');
    with postHead do begin
      WriteString('api: ' + GetAPIKey + sLineBreak);
      WriteString('Content-Type: application/json' + sLineBreak);
      WriteString('charset: utf-8' + sLineBreak);
    end;
    // ----------------------------------------------------
    postData := '{' //
      + '"Password": "' + sText + '"' //
      + '}';
    // ----------------------------------------------------
    sStatus := ReadBrokerConnectPost(sURL, postHead, postData, 'POST');
    if POS('200 OK', sStatus)= 1 then begin
      sData := postData;
      // --------------------------------
      // Ex: [{"CustomerId": 28}]
      // --------------------------------
      sData := replacestr(sData, #$A, ' ');
      gsRegCodes := parsehtml(sData, '[', ']'); // { ... }
      if length(trim(gsRegCodes))< 3 then
        exit;
      //
      S := parsehtml(S, '"', '"');
    end
    else begin
      sData := '';
    end;
  finally
    postHead.Free;
  end;
  result := sData;
end; // GeneratePwd


// ----------------------------------------------
// API: brokerconnect.live/api/v2/clients/insert
// Method: POST
// Parameters
// {
//  "UserToken": "2a5a31c4-5933-11ec-8c6c-f23c92dd5fb6",
//  "Name" : "<username>",
//  "Institution_id" : "<ins>"
// }
// --------------------------
// Update Client
// POST
// brokerconnect.live/api/v1/clients/update
// {
//  "UserToken" : "a5db0a14-3817-11ed-942c-f23c938e66e4",
//  "Name" : "Bob",
//  "NewName": "Bert",
//  "Institution_id" : "<ins>"
// }
// ----------------------------------------------
function InsertClient(sToken, sUser, sIns : string): string;
var
  sURL, sStatus, sData, S : string;
  postData : AnsiString;
  postHead : TStringStream;
begin
  // --------------------------------------------
  sURL := 'https://brokerconnect.live/api/v2/clients/insert';
  try
    postHead := TStringStream.Create('');
    with postHead do begin
      WriteString('api: ' + GetAPIKey + sLineBreak);
      WriteString('content-type: application/json' + sLineBreak);
      WriteString('charset: utf-8' + sLineBreak);
    end;
    // ------------------------------------------
    postData := '{' //
      + '"UserToken" : "' + sToken + '",' //
      + '"Name" : "' + sUser + '",' //
      + '"Institution_id" : "' + sIns + '"' //
      + '}';
    sStatus := ReadBrokerConnectPost(sURL, postHead, postData, 'POST');
//    sData := postData;
//    // --- ERROR: Duplicate entry -----
//    if (POS('Duplicate', sData) > 1) then
//      sData := postData
//    else if (POS('200 OK', sStatus) = 1) then
//      sData := postData;
//    // --------------------------------
  finally
    postHead.Free;
  end;
  result := postData;
end; // InsertClient

function UpdateClient(sToken, sUser, sIns, sNew : string): string;
var
  sURL, sStatus, sData, S : string;
  postData : AnsiString;
  postHead : TStringStream;
begin
  // --------------------------------------------
  if (sUser = sNew) or (sNew = '') then begin
    result := 'nothing to do';
    exit;
  end;
  // --------------------------------------------
  sURL := 'https://brokerconnect.live/api/v2/clients/insert';
  try
    postHead := TStringStream.Create('');
    with postHead do begin
      WriteString('api: ' + GetAPIKey + sLineBreak);
      WriteString('content-type: application/json' + sLineBreak);
      WriteString('charset: utf-8' + sLineBreak);
    end;
    // ------------------------------------------
    postData := '{' //
      + '"UserToken" : "' + sToken + '",' //
      + '"Name" : "' + sUser + '",' //
      + '"NewName" : "' + sNew + '",' //
      + '"Institution_id" : "' + sIns + '"' //
      + '}';
    sStatus := ReadBrokerConnectPost(sURL, postHead, postData, 'POST');
//    sData := postData;
//    // --- ERROR: Duplicate entry -----
//    if (POS('Duplicate', sData) > 1) then begin
//      if (sNew <> '') then begin
//        // failover to UPDATE function
//        sURL := 'https://brokerconnect.live/api/v2/clients/update';
//        postData := '{' //
//          + '"UserToken" : "' + sToken + '",' //
//          + '"Name" : "' + sUser + '",' //
//          + '"NewName" : "' + sNew + '",' //
//          + '"Institution_id" : "' + sIns + '"}';
//        sStatus := ReadBrokerConnectPost(sURL, postHead, postData, 'POST');
//        sData := postData;
//      end;
//    end;
//    // ------------------------------------------
//    if (POS('200 OK', sStatus) = 1) then
//      result := postData;
//    // --------------------------------
  finally
    postHead.Free;
  end;
  result := postData;
end; // UpdateClient

// function AddClient(sToken, sUser, sIns, sNew : string): string;


// ----------------------------------------------
function GetPlaidAccounts(sUserName, sInsId, sFilter : string): string;
// ----------------------------------------------
var
  sURL, sLoginName, sAcctId, sStatus, sData, S : string;
  myParams : TStringList;
  sAccts : TStrings;
  postData : AnsiString;
  postHead : TStringStream;
begin
  // ------------------------------------------------------
  // URL = https://brokerconnect.live/api/v2/plaid/institution_accounts
  // Json request POST
  // {"UserToken": "353e23f0-7740-11ed-b13e-f23c938e66e4",
  //  "Name" : "cawcfacmt", optional
  //  "Institution_id" : "ins_12" optional
  // }
  //[{"CustomerName":"Larry Bergus",
  //  "Name":"lbergus",
  //  "Institution_id":"ins_11",
  //  "Institution":"Charles Schwab",
  //  "account_name":"Inh IRA from IRA",
  //  "account_id":"XJq1jERB1PH3M9wKjkdYtnBKPJEA3Yf0KDp1R"
  //},...]
  // OR
  // { "message": "There is no information for this customer's institution access."
  // }
  // sURL := 'https://brokerconnect.live/api/v2/plaid/investment_accounts';
  sURL := 'https://brokerconnect.live/api/v2/plaid/institution_accounts';
  try
    postHead := TStringStream.Create('');
    with postHead do begin
      WriteString('api: ' + GetAPIKey + sLineBreak);
      WriteString('Content-Type: application/json' + sLineBreak);
      WriteString('charset: utf-8' + sLineBreak);
    end;
    // ----------------------------------------------------
    if trim(v2ClientToken)= '' then exit; // still blank
    postData := '{' //
      + '"UserToken": "' + v2ClientToken // which user
      + '","Name" : "' + sUserName // which broker login
      + '","Institution_id" : "' + sInsId // which broker
      + '"}';
    // ----------------------------------------------------
    sStatus := ReadBrokerConnectPost(sURL, postHead, postData, 'POST');
    if POS('200', sStatus) <> 1 then begin
      result := 'ERROR: ' + sStatus;
      exit;
    end;
    sData := ParseHTML(postData, '{', '}');
    sData := uppercase(sData);
    if POS('ERROR', sData) > 0 then begin
      result := sData;
      exit;
    end;
    sData := postData;
    result := ParseJSONAccounts(sData, sFilter); // -- >
  finally
    postHead.Free;
  end;
end; // GetPlaidAccounts


// --------------------------------------------------------
// Plaid Transactions
// --------------------------------------------------------

procedure SavePlaidJSON(sData : string);
var
  sFile, ext, localFileName : string;
  localFile : textFile;
begin
  try
    // get a unique name for the import backup file
    sFile := TradeLogFile.CurrentAccount.FileImportFormat;
    Delete(sFile, POS('*', sFile), 1);
    Delete(sFile, POS(',', sFile), 1);
    ext := TradeLogFile.CurrentAccount.ImportFilter.ImportFileExtension;
    localFileName := Settings.ImportDir + '\' + sFile + '_' //
      + formatdatetime('yyyymmdd-hhmmss', now)+ '.JSON.txt'; //
    // --- Open the file ----
    AssignFile(localFile, localFileName);
    Rewrite(localFile);
    // --- add appropriate line breaks for easy reading ---
    sFile := replacestr(sData, '{"account_id":', CR + '{"account_id":');
    sFile := replacestr(sFile, '{"close_price":', CR + '{"close_price":');
    sFile := replacestr(sFile, '],"investment_transactions":[', CR + '],"investment_transactions":[');
    sFile := replacestr(sFile, ',"securities":[', CR + ',"securities":[');
    // --- finish -----------
    write(localFile, sFile);
    CloseFile(localFile);
  except
    On E : Exception do begin
      if SuperUser then begin
        mDlg('Unable to save JSON data to file' + CR //
          + localFileName + CR //
          + 'Error Message: ' + E.Message + CR //
          + '(click OK to continue.)', mtError, [mbOK], 0);
      end; // if
    end; // on E
  end; // try...except
end; // SavePlaidJSON


procedure ReadPlaidIntoStrList(var sJSON : AnsiString; bClear : boolean);
var
  jsTrans, jsTran, jsSecs, jsSec : TlkJSONObject;
  amt, pr, qty, cm : double;
  i, j, R : integer;
  S, t, x, sDate, sType, sOC, sAmt, sDesc, sBroker, sQty, sPrice, sTick, sCom, sCusp : string;
  dt : TDate;
  reply : TStringList;
  // ------------------------
  function GetWarrantTicker: string;
  const
    number = ['0','1','2','3','4','5','6','7','8','9'];
  var
    k : integer;
    sW : string;
  begin
    sW := '';
    for k := 1 to length(sTick) do begin
      if (sTick[k] in number) then break;
      sW := sW + sTick[k];
    end;
    result := sW;
  end;
begin
  if bClear then begin
    ImpStrList.Clear;
    t := 'DATE' + TAB + 'OCLS' + TAB + 'TICK' + TAB + 'COMM' + TAB + 'DESC' //
      + TAB + 'Type' + TAB + 'PRC' + TAB + 'QTY' + TAB + 'AMT' + TAB + 'CUSP';
    ImpStrList.Add(t);
  end;
  // ----------------------------------
  x := lowercase(sJSON);
  if length(x) < 46 then begin
    showmessage('Import data is missing or incomplete.');
    exit;
  end;
  // ----------------------------------
  try
    sBroker := Uppercase(TradeLogFile.CurrentAccount.FileImportFormat);
    // ----------------------
    i := POS('"investment_transactions":', x);
    if i < 1 then begin
      showmessage('Import data format is incorrect.');
      exit;
    end;
    S := copy(x, i); // trim
    t := '[' + parsehtml(S, '[', ']') + ']';
    // clipboard.AsText := t;
    // sm('t');
    // ----------------------
    i := length(t)+ 26;
    if length(S) < i then begin
      showmessage('Import data is missing or incomplete.');
      exit;
    end;
    x := copy(S, i); // start after t
    i := POS('"securities":', x);
    if i < 1 then begin
      showmessage('Import data format is incorrect.');
      exit;
    end;
    x := copy(x, i); // trim
    S := '[' + parsehtml(x, '[', ']') + ']';
    // clipboard.AsText := s;
    // sm('s');
    // --------------------------------
    if (POS('[', t) > 0) and (POS('[', S) > 0) then begin
      jsTrans := TlkJSONObject(TLKJSON.ParseText(t));
      if (jsTrans = nil) then begin
        showmessage('Import data format is incorrect.');
        exit;
      end;
      // --------------------
      jsSecs := TlkJSONObject(TLKJSON.ParseText(S));
      if (jsSecs = nil) then begin
        showmessage('data format incorrect.');
        exit;
      end;
      // --------------------
      S := '';
      x := '';
      // ----------------------------------------
      for i := 0 to jsTrans.Count - 1 do begin
        jsTran := jsTrans.Child[i] as TlkJSONObject;
        // ----------------------------
        // ...{"account_id":"5XBrKpAKYrsPLEK7zaYgfAD556O5PPCBB6JXp",
        // "amount":0.47,
        // "cancel_transaction_id":null,
        // "date":"2021-09-14",
        // "fees":0,
        // "investment_transaction_id":"KYVvXz1XkvUDKdZJMOvwcLV35Akz7KUQJY8gN",
        // "iso_currency_code":"USD",
        // "name":"Reinvest Shares - VICTORYSHARES NASDAQ NEXT 50 ETF",
        // "price":33.875,
        // "quantity":0.0139,
        // "security_id":"bn4Q8gQOBJt19jxozg9LfLYEO5EBD1Fq0JkYE",
        // "subtype":"buy",
        // "type":"buy",
        // "unofficial_currency_code":null}...
        // --- date -------------------                     REQUIRED!
        if (JSONFieldExists(jsTran, 'date')) then begin
          S := 'date';
          sDate := VarToStr(jsTran.Field['date'].Value);
          x := parsefirst(sDate, '-');
          sDate := replacestr(sDate, '-', '/') + '/' + x;
          dt := StrToDate(sDate); // Plaid dates are always yyyy-mm-dd
        end
        else begin
          continue; // can't use this record.
        end;
        // --- type -------
        if (JSONFieldExists(jsTran, 'type')) then begin
          S := 'type';
          sOC := VarToStr(jsTran.Field[S].Value);
          if sOC = 'cash' then
            continue;
        end
        else begin
          continue; // can't use this record.
        end;
        // --- amount -------                               REQUIRED!
        if (JSONFieldExists(jsTran, 'amount')) then begin
          S := 'amount';
          amt := jsTran.Field['amount'].Value;
          sAmt := FloatToStr(amt);
        end
        else begin
          continue; // can't use this record.
        end;
        // --- ticker -------                               REQUIRED!
        if (JSONFieldExists(jsTran, 'security_id')) then begin
          S := VarToStr(jsTran.Field['security_id'].Value);
        end;
        // -- find security_id in jsSecs --------
        sTick := ''; // start blank
        for j := 0 to jsSecs.Count - 1 do begin
          jsSec := jsSecs.Child[j] as TlkJSONObject;
          // --------------------------
          // ...{"close_price":44.74,
          // "close_price_as_of":"2022-01-10",
          // "cusip":"67110P704",
          // "institution_id":null,
          // "institution_security_id":null,
          // "is_cash_equivalent":false,
          // "isin":"US67110P7042",
          // "iso_currency_code":"USD",'
          // "name":"OSI ETF Trust - O`Shares Global Internet Giants ETF",
          // "proxy_security_id":null,
          // "security_id":"pJPM4LMBNQFrOjDOPg3rU8ZPB4P5yAfOLjBMp",
          // "sedol":null,
          // "ticker_symbol":"OGIG",
          // "type":"etf",
          // "unofficial_currency_code":null}...
          // --------------------------
          if VarToStr(jsSec.Field['security_id'].Value) = S then begin
            if (JSONFieldExists(jsSec, 'ticker_symbol')) then begin
              sTick := VarToStr(jsSec.Field['ticker_symbol'].Value); // ticker
              // special case: warrants
              if length(sTick) > 7 then begin
                if (VarToStr(jsSec.Field['type'].Value) = 'equity') //
                or (POS('WARRANT', uppercase(VarToStr(jsTran.Field['name'].Value))) > 0) //
                then
                  sTick := GetWarrantTicker;
              end;
            end
            else begin
              continue; // mandatory field
            end;
            if (JSONFieldExists(jsSec, 'name')) then
              sDesc := VarToStr(jsSec.Field['name'].Value); // description
            if (JSONFieldExists(jsSec, 'type')) then
              sType := VarToStr(jsSec.Field['type'].Value); // sec. type
            if (JSONFieldExists(jsSec, 'cusip')) then
              sCusp := VarToStr(jsSec.Field['cusip'].Value); // cusip
            break;
          end
          else begin
            continue; // keep looking
          end; // if security_id found
          if sTick = '' then begin
            // no match, so...
            sm('unable to match security_id' + CR + S);
          end;
        end; // for j
        // --------------------------------------
        // --- qty --------
        if (JSONFieldExists(jsTran, 'quantity')) then begin
          S := 'qty';
          qty := jsTran.Field['quantity'].Value; // quantity
          sQty := FloatToStr(qty);
        end
        else begin
          continue; // can't use this record.
        end;
        // --- price ------
        if (JSONFieldExists(jsTran, 'price')) then begin
          S := 'price';
          pr := jsTran.Field['price'].Value;
          sPrice := FloatToStr(pr);
        end
        else begin
          continue; // can't use this record.
        end;
        // --- commission ---
        if (JSONFieldExists(jsTran, 'fees')) then begin
          S := 'comm';
          cm := jsTran.Field['fees'].Value; // quantity
          sCom := FloatToStr(cm);
        end
        else
          sCom := ''; // skip if no quantity
        // --- build record -----------
        S := 'add';
        t := sDate + TAB + sOC + TAB + sTick + TAB + sCom + TAB + sDesc //
          + TAB + sType + TAB + sPrice + TAB + sQty + TAB + sAmt + TAB + sCusp;
        ImpStrList.Add(t);
      end; // for
    end; // if
  except
    on E : Exception do begin
      sm('ReadPlaidIntoStrList failed on row ' + IntToStr(i) + ' in ' + S + CRLF //
        + E.ClassName + ': ' + E.Message);
    end;
  end;
end; // ReadPlaidIntoStrList


// ----------------------------------------------
// Get Plaid Transactions
function GetPlaidTrans(sInsId, sAcctId, sFromDate, sToDate, sUserName : string): string;
// ----------------------------------------------
var
  sHost, sBaseURL, sURL, sStatus, sData, S : string;
  sContainer, sCategory : string;
  postData : AnsiString;
  postHead : TStringStream;
  i, j : integer;
begin
  // ------------------------------------------------------
  // API: .../api/v2/plaid/investment_transactions
  // Method: POST
  // Parameters: {
  // "UserToken": "25fcc41d-5eb4-11ec-8e26-f23c92dd5fb6",
  // "Name": "cawcfacmt",
  // "accountids" : [ "5XBrKpAKYrsPLEK7zaYgfAD556O5PPCBB6JXp",
  //   <other accountId(s), optional> ],
  // <optional parameters are:>
  // days,
  // startDate,
  // endDate
  // offset
  // }
  // ------------------------------------------------------
  sURL := 'https://brokerconnect.live/api/v2/plaid/investment_transactions';
  try
    postHead := TStringStream.Create('');
    with postHead do begin
      WriteString('api: ' + GetAPIKey + sLineBreak);
      WriteString('Content-Type: application/json' + sLineBreak);
      WriteString('charset: utf-8' + sLineBreak);
    end;
    // ----------------------------------------------------
//    if trim(gsCustomerToken)= '' then // try getting it again
//      gsCustomerToken := v2ClientToken; // GetAuthenticate(ProHeader.email, ProHeader.regCode);
    if trim(v2ClientToken)= '' then // still blank
      exit;
    j := 0;
    repeat
      postData := '{' //
        + '"UserToken": "' + v2ClientToken //
        + '","Name": "' + sUsername // ProHeader.email
        + '","accountids": ["' + sAcctId + '"]' //
        + ',"startDate": "' + sFromDate // in YYYY-MM-DD format
        + '","endDate": "' + sToDate; // in YYYY-MM-DD format
      if j=0 then // first pass, zero offset
        postData := postData + '","offset": " "}'
      else
        postData := postData + '","offset": ' + IntToStr(j) + '}';
      // --------------------------------------------------
      try // --- download data block ----
        sStatus := ReadBrokerConnectPost(sURL, postHead, postData, 'POST');
        SavePlaidJSON(postData);
        if (POS('200 OK', sStatus) < 1) then
          result := 'ERROR: ' + sStatus
        else begin
          result := 'OK';
          i := pos('"total_investment_transactions"', postData);
          if i > 1 then begin
            S := copy(postData, i);
            S := parsehtml(S,':','}');
            i := StrToInt(S);
          end;
          ReadPlaidIntoStrList(postData, (j=0));
        end;
      except
        on E : Exception do begin
          sm('ERROR in GetPlaidTrans:' + CRLF + E.ClassName + ': ' + E.Message);
        end;
      end;
      if (i > j) then j := j + 500;
    until (j >= i);
  finally
    postHead.Free;
  end;
end; // GetPlaidTrans


// ----------------------------------------------
// Get Plaid Transactions
function GetPlaidHoldings(sAcctId, sUserName : string): string;
// ----------------------------------------------
var
  sHost, sBaseURL, sURL, sStatus, sData, S : string;
  sContainer, sCategory : string;
  postData : AnsiString;
  postHead : TStringStream;
  function FakeData(var ps : AnsiString) : string;
  begin
    ps := '{"accounts":[' //
      + '{"account_id":"1234",' //
      + '"balances":{"available":null,"current":19963.37,"iso_currency_code":"USD","limit":null,"unofficial_currency_code":null}' //
      + '"mask":"8738","name":"Individual","official_name":"Individual","subtype":"brokerage","type":"investment"}],' //
    + '"investment_transactions":[' //
      + '{"account_id":"1234","amount":3.45,"cancel_transaction_id":null,"date":"2022-01-03","fees":0,"investment_transaction_id":"VpLOVzjVZOT69nMzoA5Xsxwpr01P6MfrzQ4ey","iso_currency_code":"USD",' //
        + '"name":"Reinvest Shares - INVESCO QQQ TRUST","price":399.3889,"quantity":0.0086,"security_id":"Z09ER5EZdAHRNm4dP0Qes8kyOLyDngfQPxpXO","subtype":"buy","type":"buy","unofficial_currency_code":null}' //
      + '{"account_id":"1234","amount":29.1,"cancel_transaction_id":null,"date":"2021-12-27","fees":0,"investment_transaction_id":"VpLOVzjVZOT69nMzoAdgIZ3vDgM4OEUrXDnnq","iso_currency_code":"USD",' //
        + '"name":"Reinvest Shares - ENERGY SELECT SECTOR SPDR ETF IV","price":55.68361,"quantity":0.5226,"security_id":"pJPM4LMBNQFrOj94PQDeC8ZPB4P5yAfOLr4jD","subtype":"buy","type":"buy","unofficial_currency_code":null}' //
      + '{"account_id":"1234","amount":1.64,"cancel_transaction_id":null,"date":"2021-12-21","fees":0,"investment_transaction_id":"Ep5Ngz9gPNT8dEoyJrABTxr0arnRg8IpNqe47","iso_currency_code":"USD",' //
        + '"name":"Reinvest Shares - VICTORYSHARES NASDAQ NEXT 50 ETF","price":32.96,"quantity":0.0498,"security_id":"bn4Q8gQOBJt19jxozg9LfLYEO5EBD1Fq0JkYE","subtype":"buy","type":"buy","unofficial_currency_code":null}' //
      + '{"account_id":"1234","amount":81.87,"cancel_transaction_id":null,"date":"2021-11-10","fees":0,"investment_transaction_id":"dOrxedzekxhpMwBN03LySL1OvJNd9BUbp3Jax","iso_currency_code":"USD",' //
        + '"name":"Buy - RIOT BLOCKCHAIN I N C","price":40.935,"quantity":2,"security_id":"moPE4dE1yMHJXRvqvedVUvbZ1LZ7NVHdEykAJ","subtype":"buy","type":"buy","unofficial_currency_code":null}' //
      + '{"account_id":"1234","amount":-1047.99,"cancel_transaction_id":null,"date":"2021-05-13","fees":0.01,"investment_transaction_id":"RXpjEzkEajs7PemgJKqBs86OZjyKg5FyPQYj3","iso_currency_code":"USD",' //
        + '"name":"Sell - FILO MINING CORP F","price":5.24,"quantity":-200,"security_id":"AyvPNVPQ75SR8VXPqVAVcOXJP6JdVphkxYeAw","subtype":"sell","type":"sell","unofficial_currency_code":null}' //
      + '{"account_id":"1234","amount":-1621.37,"cancel_transaction_id":null,"date":"2021-05-13","fees":0.01,"investment_transaction_id":"Ep5Ngz9gPNT8dEoyJrALFY6dMX3vjrFp7kzXx","iso_currency_code":"USD",' //
        + '"name":"Sell - O`SHARES GLOBAL INTERNETGIANTS ETF","price":47.6875,"quantity":-34,"security_id":"pJPM4LMBNQFrOjDOPg3rU8ZPB4P5yAfOLjBMp","subtype":"sell","type":"sell","unofficial_currency_code":null}],' //
    + '"item":{"available_products":["balance"],"billed_products":["auth","investments","transactions"],' //
      + '"consent_expiration_time":null,"error":null,"institution_id":"ins_11","item_id":"wbnKYaQYXKTpg465dKNoSwaK1O3PxoCL6ngKv","products":["auth","investments","transactions"],"update_type":"background","webhook":""}' //
    + '"request_id":"4JehEXahVp6Z1t4",' //
    + '"securities":[' //
      + '{"close_price":null,"close_price_as_of":null,"cusip":null,"institution_id":null,"institution_security_id":null,"is_cash_equivalent":true,"isin":null,"iso_currency_code":"USD",' //
        + '"name":"Bank Int 101621-111521 Schwab Premier Bank","proxy_security_id":null,"security_id":"7dD8KV8owvUr4gaPYKAqFLPy8Kyr9dF40VYzg","sedol":null,"ticker_symbol":null,"type":"equity","unofficial_currency_code":null}' //
      + '{"close_price":428.03,"close_price_as_of":"2022-01-10","cusip":"922908363","institution_id":null,"institution_security_id":null,"is_cash_equivalent":false,"isin":"US9229083632","iso_currency_code":"USD",' //
        + '"name":"Vanguard S&P 500 ETF","proxy_security_id":null,"security_id":"96d5AO5gLjC9Ey6n7e0AFB1YdrYymNfaJKNOM","sedol":"BF2GMJ3","ticker_symbol":"VOO","type":"etf","unofficial_currency_code":null}' //
      + '{"close_price":9.95,"close_price_as_of":"2022-01-10","cusip":"31730E101","institution_id":null,"institution_security_id":null,"is_cash_equivalent":false,"isin":null,"iso_currency_code":"USD",' //
        + '"name":"Filo Mining Corp","proxy_security_id":null,"security_id":"AyvPNVPQ75SR8VXPqVAVcOXJP6JdVphkxYeAw","sedol":null,"ticker_symbol":"FLMMF","type":"equity","unofficial_currency_code":null}' //
      + '{"close_price":null,"close_price_as_of":null,"cusip":null,"institution_id":null,"institution_security_id":null,"is_cash_equivalent":true,"isin":null,"iso_currency_code":"USD",' //
        + '"name":"Bank Int 051621-061521 Schwab Premier Bank","proxy_security_id":null,"security_id":"DAE3Yo3wXgsKz1pr7O7MIr6Z7OZjoJfR8OM6o","sedol":null,"ticker_symbol":null,"type":"equity","unofficial_currency_code":null}' //
      + '{"close_price":null,"close_price_as_of":null,"cusip":null,"institution_id":null,"institution_security_id":null,"is_cash_equivalent":true,"isin":null,"iso_currency_code":"USD",' //
        + '"name":"Bank Int 081621-091521 Schwab Premier Bank","proxy_security_id":null,"security_id":"EvByboy6Z7IYB8w8oMJgUQ5R4YRjPMfZj5d5m","sedol":null,"ticker_symbol":null,"type":"equity","unofficial_currency_code":null}' //
      + '{"close_price":85.52,"close_price_as_of":"2022-01-10","cusip":null,"institution_id":null,"institution_security_id":null,"is_cash_equivalent":false,"isin":null,"iso_currency_code":"USD",' //
        + '"name":"Roblox Corporation - Ordinary Shares - Class A","proxy_security_id":null,"security_id":"JmN0JX0q5EcgEkxY91P6IYzMgoMr6psbrg1gE","sedol":null,"ticker_symbol":"RBLX","type":"equity","unofficial_currency_code":null}' //
      + '{"close_price":5.35,"close_price_as_of":"2022-01-10","cusip":"G1144A105","institution_id":null,"institution_security_id":null,"is_cash_equivalent":false,"isin":"KYG1144A1058","iso_currency_code":"USD",' //
        + '"name":"Bit Digital Inc","proxy_security_id":null,"security_id":"M654JE4yQdCLaaYwx37KSZJ3Lo34kKHM33Dze","sedol":null,"ticker_symbol":"BTBT","type":"equity","unofficial_currency_code":null}' //
      + '{"close_price":null,"close_price_as_of":null,"cusip":null,"institution_id":null,"institution_security_id":null,"is_cash_equivalent":true,"isin":null,"iso_currency_code":"USD",' //
        + '"name":"Bank Int 111621-121521 Schwab Premier Bank","proxy_security_id":null,"security_id":"QPO8Jo8vdDHRQ9dgL3ZdcYZvqRv3XPswz1EEy","sedol":null,"ticker_symbol":null,"type":"equity","unofficial_currency_code":null}' //
      + '{"close_price":null,"close_price_as_of":null,"cusip":null,"institution_id":null,"institution_security_id":null,"is_cash_equivalent":true,"isin":null,"iso_currency_code":"USD",' //
        + '"name":"Bank Int 071621-081521 Schwab Premier Bank","proxy_security_id":null,"security_id":"VK0EQ5Ea13u5mDPJPy7AUNz0Jd0ZYMHzpQNB3","sedol":null,"ticker_symbol":null,"type":"equity","unofficial_currency_code":null}' //
      + '{"close_price":null,"close_price_as_of":null,"cusip":null,"institution_id":null,"institution_security_id":null,"is_cash_equivalent":true,"isin":null,"iso_currency_code":"USD",' //
        + '"name":"Bank Int 091621-101521 Schwab Premier Bank","proxy_security_id":null,"security_id":"VK0EQ5Ea13u5oOO5nKO4INz0Jd0ZYMHzdLVMo","sedol":null,"ticker_symbol":null,"type":"equity","unofficial_currency_code":null}' //
      + '{"close_price":380.11,"close_price_as_of":"2022-01-10","cusip":"46090E103","institution_id":null,"institution_security_id":null,"is_cash_equivalent":false,"isin":"US46090E1038","iso_currency_code":"USD",' //
        + '"name":"PowerShares QQQ","proxy_security_id":null,"security_id":"Z09ER5EZdAHRNm4dP0Qes8kyOLyDngfQPxpXO","sedol":"BDQYP67","ticker_symbol":"QQQ","type":"etf","unofficial_currency_code":null}' //
      + '{"close_price":31.58,"close_price_as_of":"2022-01-10","cusip":null,"institution_id":null,"institution_security_id":null,"is_cash_equivalent":false,"isin":null,"iso_currency_code":"USD",' //
        + '"name":"Victory Portfolios II - VictoryShares Nasdaq Next 50 ETF","proxy_security_id":null,"security_id":"bn4Q8gQOBJt19jxozg9LfLYEO5EBD1Fq0JkYE","sedol":null,"ticker_symbol":"QQQN","type":"etf","unofficial_currency_code":null}' //
      + '{"close_price":null,"close_price_as_of":null,"cusip":null,"institution_id":null,"institution_security_id":null,"is_cash_equivalent":true,"isin":null,"iso_currency_code":"USD",' //
        + '"name":"Bank Int 041621-051521 Schwab Premier Bank","proxy_security_id":null,"security_id":"dRBp95pEwZfvZr5gamnrhYr08L09XvsoJOLJ5","sedol":null,"ticker_symbol":null,"type":"equity","unofficial_currency_code":null}' //
      + '{"close_price":20.09,"close_price_as_of":"2022-01-10","cusip":"767292105","institution_id":null,"institution_security_id":null,"is_cash_equivalent":false,"isin":"US7672921050","iso_currency_code":"USD",' //
        + '"name":"Riot Blockchain Inc","proxy_security_id":null,"security_id":"moPE4dE1yMHJXRvqvedVUvbZ1LZ7NVHdEykAJ","sedol":"BD9F675","ticker_symbol":"RIOT","type":"equity","unofficial_currency_code":null}' //
      + '{"close_price":5.87,"close_price_as_of":"2022-01-10","cusip":"88105E108","institution_id":null,"institution_security_id":null,"is_cash_equivalent":false,"isin":"CA88105E1088","iso_currency_code":"USD",' //
        + '"name":"TerrAscend Corp","proxy_security_id":null,"security_id":"nban4wnPKEtnm5eEwnDztE1oPmowQ8S8Lmz05","sedol":null,"ticker_symbol":"TRSSF","type":"equity","unofficial_currency_code":null}' //
      + '{"close_price":7.74,"close_price_as_of":"2022-01-10","cusip":"25686H100","institution_id":null,"institution_security_id":null,"is_cash_equivalent":false,"isin":null,"iso_currency_code":"USD",' //
        + '"name":"Dolphin Entertainment Inc.","proxy_security_id":null,"security_id":"nban4wnPKEtnmKoQpXBAiE1oPmowQ8S8X4q5Q","sedol":null,"ticker_symbol":"DLPN","type":"equity","unofficial_currency_code":null}' //
      + '{"close_price":null,"close_price_as_of":null,"cusip":null,"institution_id":null,"institution_security_id":null,"is_cash_equivalent":true,"isin":null,"iso_currency_code":"USD",' //
        + '"name":"Bank Int 061621-071521 Schwab Premier Bank","proxy_security_id":null,"security_id":"pJPM4LMBNQFdzojJVJpDc8ZPB4P5yAfZoEY0x","sedol":null,"ticker_symbol":null,"type":"equity","unofficial_currency_code":null}' //
      + '{"close_price":61.15,"close_price_as_of":"2022-01-10","cusip":"81369Y506","institution_id":null,"institution_security_id":null,"is_cash_equivalent":false,"isin":"US81369Y5069","iso_currency_code":"USD",' //
        + '"name":"Energy Select Sector SPDR","proxy_security_id":null,"security_id":"pJPM4LMBNQFrOj94PQDeC8ZPB4P5yAfOLr4jD","sedol":"2402466","ticker_symbol":"XLE","type":"etf","unofficial_currency_code":null}' //
      + '{"close_price":44.74,"close_price_as_of":"2022-01-10","cusip":"67110P704","institution_id":null,"institution_security_id":null,"is_cash_equivalent":false,"isin":"US67110P7042","iso_currency_code":"USD",' //
        + '"name":"OSI ETF Trust - O`Shares Global Internet Giants ETF","proxy_security_id":null,"security_id":"pJPM4LMBNQFrOjDOPg3rU8ZPB4P5yAfOLjBMp","sedol":null,"ticker_symbol":"OGIG","type":"etf","unofficial_currency_code":null}],' //
    + '"total_investment_transactions":45}';
    result := '200 OK';
  end;
begin
  // ------------------------------------------------------
  // API: .../api/v2/plaid/holdings
  // Method: POST
  // Parameters:
  // {
  // "UserToken": "25fcc41d-5eb4-11ec-8e26-f23c92dd5fb6",
  // "Name": "cawcfacmt@gmail.com",
  // "accountids" : [
  //   "5XBrKpAKYrsPLEK7zaYgfAD556O5PPCBB6JXp",
  //   <other accountId(s), optional>
  // ],
  // <optional parameters are:>
  // days,
  // startDate,
  // endDate
  // }
  // ------------------------------------------------------
  sURL := 'https://brokerconnect.live/api/v2/plaid/holdings';
  try
    postHead := TStringStream.Create('');
    with postHead do begin
      WriteString('api: ' + GetAPIKey + sLineBreak);
      WriteString('Content-Type: application/json' + sLineBreak);
      WriteString('charset: utf-8' + sLineBreak);
    end;
    // ----------------------------------------------------
//    if trim(gsCustomerToken)= '' then // try getting it again
//      gsCustomerToken := v2ClientToken; // GetAuthenticate(ProHeader.email, ProHeader.regCode);
    if trim(v2ClientToken)= '' then // still blank
      exit;
    postData := '{' //
      + '"UserToken": "' + v2ClientToken //
      + '","Name": "' + ProHeader.email // + sUserName //
      + '","accountids": ["' + sAcctId + '"]' //
      + '"}';
    // ----------------------------------------------------
    try // --- download data block ----
      if DEBUGGING then
        sStatus := FakeData(postData)
      else begin
        sStatus := ReadBrokerConnectPost(sURL, postHead, postData, 'POST');
        SavePlaidJSON(postData);
      end;
      if (POS('200 OK', sStatus) < 1) then
        result := 'ERROR: ' + sStatus
      else begin
        result := 'OK';
//        ReadPlaidIntoStrList(postData);
      end;
    except
      on E : Exception do begin
        sm('ERROR in GetPlaidHoldings:' + CRLF + E.ClassName + ': ' + E.Message);
      end;
    end;
  finally
    postHead.Free;
  end;
end; // GetPlaidHoldings

end.
