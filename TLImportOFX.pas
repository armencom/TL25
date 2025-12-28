unit TLImportOFX;

//THIS UNIT IS FOR OFX

interface

uses System.SysUtils, System.Classes, OFXMain,
  TLImportFilters, TLFile, Generics.Collections, Generics.Defaults,
  XML.XMLIntf, XML.xmldoc, xml.xmldom;

type
  EOFXException = class(Exception);
  ETLImportException = class(Exception);

  TOFXResponse = class
  public
    InvStmt : IXMLINVSTMTMSGSRSV1Type;
    SecList : IXMLSECLISTMSGSRSV1Type;
    Signon : IXMLSIGNONMSGSRSV1Type;

    constructor Create;
    destructor Destroy; override;
  end;

  TTLImport = class
  private
   {This is a tList because if the Broker limits the number of months that can be
     retrieved at one time, then multiple Gets will be performed to handle this
     broker limitation, So for instance if a broker limits 3 months worth of data
     at a time, and the Start and End Date are greater than 3 months, say 6 months,
     then there will be two reponses, each for a total of 3 months}
    FOFXResponses : TList<TOFXResponse>;
    FImportFilter : TTLImportFilter;
    {Same with the Raw Data as with Reponses, see not above}
    FRawData : TList<String>;
    FErrorText : String;
    {If you want use fiddler to see the network traffic, then set the Proxy property to
      true and the HTTP connection will then proxy via LocalHost:8888, fiddler's default
      proxy port}
    FProxy : Boolean;
    {Convert SGML response to XML so that it can be bound to the OFX classes}
    function SGMLToXML(Value : String) : String;
    {Performs the actual HTTP Post to get the data from the OFX Server}
    function OFXWinInetPost(URL : String; var Data : AnsiString) : String;
    function GetImportFilter: TTLImportFilter;
    {Used to create a Globally Unique Identified as a Transaction and Session ID}
    function CreateGuid: String;
    procedure SetImportFilter(const Value: TTLImportFilter);
    {Find the Info Object in the Data for a given Unique ID}
    function FindInfo(Idx : Integer; UniqueID : String) : IXMLNode;
    {Convert the OFX Buy Sell to TradeLog, OL, CL, OS, CS nomenclature}
    procedure ConvertBuySell(Value : String; var Trade : TTLTrade);
    procedure CancelCorrect(Value : String; var Trade : TTLTrade);
    {Remove Leading Zero's from a number}
    function TrimLeadingZeros(const S: string): string;
    function TrimTrailingZeros(S: string): string;
    function GetRawData(Idx : Integer) : String;
    function GetOFXResponse(Idx: Integer): TOFXResponse;
    function GetOFXResponseCount: Integer;
    procedure SetProxy(const Value: Boolean);
    function SSLInet(AUrl : String; Header : TStringStream; var AData : AnsiString) : String;
    procedure GetErrors;
    function GetErrorMessage: String;
    function GetErrorOccurred: Boolean;
  protected
    {The following protected functions are all by default using the standard as set out
     by the OFX Standard 1.01, Each method will expect value in the XML Object as per the
     specificication, But since Brokers do not always follow the Spec verbatim, these are
     defined as Virtual so that they can be overridden if necessary}

    function IsCancelCorrectTrade(Value : String) : Boolean; virtual;

    {Process a Buy Option type}
    function ProcessBuyOpt(Option : IXMLBUYOPTType; OptionInfo : IXMLOPTINFOType) : TTLTrade; virtual;
    {Process a Sell Option Type}
    function ProcessSellOpt(Option : IXMLSELLOPTType; OptionInfo : IXMLOPTINFOType) : TTLTrade; virtual;

    {Process a Buy Stock Type}
    function ProcessBuyStock(Stock : IXMLBUYSTOCKType; StockInfo : IXMLNode) : TTLTrade; virtual;
    {Process a Sell Stock Type}
    function ProcessSellStock(Stock : IXMLSELLSTOCKType; StockInfo : IXMLNode) : TTLTrade; virtual;

    {Process a Buy Debt Type}
    function ProcessBuyDebt(Stock : IXMLBUYDEBTType; StockInfo : IXMLNode) : TTLTrade; virtual;
    {Process a Sell Debt Type}
    function ProcessSellDebt(Stock : IXMLSELLDEBTType; StockInfo : IXMLNode) : TTLTrade; virtual;

    {Process a Buy Mutual Fund Type}
    function ProcessBuyMF(Stock : IXMLBUYMFType; StockInfo : IXMLMFINFOType) : TTLTrade; virtual;
    {Process a Sell Mutual Fund Type}
    function ProcessSellMF(Stock : IXMLSELLMFType; StockInfo : IXMLMFINFOType) : TTLTrade; virtual;

    {Process a Closure Option Type, currently only Expires are supported}
    function ProcessClosureOpt(ClosureOpt : IXMLCLOSUREOPTType; OptionInfo : IXMLOPTINFOType; ClosureStk : IXMLNode) : TTLTrade; virtual;

    {Some brokers use BuyOther for Reinvestments so we need to process}
    function ProcessBuyOtherStock(Other : IXMLBUYOTHERType; StockInfo : IXMLSTOCKINFOTYPE) : TTLTrade; virtual;
    function ProcessBuyOtherMF(Other: IXMLBUYOTHERType; MFInfo : IXMLMFINFOType) : TTLTrade;
    function ProcessSellOtherMF(Other: IXMLSELLOTHERType; MFInfo : IXMLMFINFOType) : TTLTrade;
    function ProcessBuyOtherOption(Other : IXMLBUYOTHERType; OptionInfo : IXMLOPTINFOType) : TTLTrade; virtual;
    function ProcessBuyOther(Other : IXMLBUYOTHERType; OtherInfo : IXMLOTHERINFOType) : TTLTrade; virtual;

    {Also Some use Sell Other so let's process these as well}
    function ProcessSellOtherStock(Other : IXMLSELLOTHERType; StockInfo : IXMLSTOCKINFOTYPE) : TTLTrade; virtual;
    function ProcessSellOtherOption(Other : IXMLSELLOTHERType; OptionInfo : IXMLOPTINFOType) : TTLTrade; virtual;
    function ProcessSellOther(Other : IXMLSELLOTHERType; OtherInfo : IXMLOTHERINFOType) : TTLTrade; virtual;

    {Process the Trans Object within each of the above types}
    procedure ProcessTrans(Tran : IXMLINVTRANType; var Trade : TTLTrade); virtual;
    {Process the InvBuy Object within each of the above Buy Types}
    procedure ProcessInvBuy(InvBuy : IXMLINVBUYType; var Result: TTLTrade); virtual;
    {Process the InvSell Object within each of the above Sell Types}
    procedure ProcessInvSell(InvSell : IXMLINVSELLType; var Result : TTLTrade); virtual;
    {Process the Info Object for Options}
    procedure ProcessOptionInfo(OptionInfo: IXMLOPTINFOType; var Result : TTLTrade;
      useSecName : Boolean = false); virtual;
    {Process the Info Object for Stocks}
    procedure ProcessStockInfo(StockInfo : IXMLSTOCKINFOType; var Result : TTLTrade); virtual;
    {Process the Info Object for Debts}
    procedure ProcessDebtInfo(DebtInfo : IXMLDEBTINFOType; var Result : TTLTrade); virtual;
    {Process the Info Object for Mutual Funds}
    procedure ProcessMFInfo(MFInfo : IXMLMFINFOType; var Result : TTLTrade); virtual;
    {process the info object for other trans types}
    procedure ProcessOtherInfo(OtherInfo : IXMLOTHERINFOType; var Result : TTLTrade); virtual;

    {Process FIAssetClass from Stock Info Record, Broker Specific: Default implementation does
      nothing but if a broker defines this and TradeLog needs then a One Off impl needs to be created
      for that broker}
    procedure ProcessFIAssetClass(FIASSETCLASS : String; var Result : TTLTrade); virtual;
    {Parse the Options Ticker Field from the Security record}
    function ParseOptionTicker(var Ticker : String) : String; virtual;
    {Parse the Stock Ticker Field from the Security record}
    function ParseStockTicker(var Ticker : String) : String; virtual;
    {Parse the Expire Date Field from the Security record, Notice the Ticker is passed in, in case
      the expire Dt field does not contain a valid date, the ticker can be used.}
    function ParseExpireDate(ExpireDt : String; var Ticker : String) : String; virtual;
    {Parse the Strike Price Field from the Security record, Notice the Ticker is passed in, in case
      the Strike Price field does not contain a price, the ticker can be used.}
    function ParseStrikePrice(Strike : String; var Ticker : String; ID : String) : String; virtual;
    {Parse the Call Put Field from the Security record, Notice the Ticker is passed in, in case
      the Call Put field does not contain a valid Call Put value, the ticker can be used.}
    function ParseCallPut(CallPut : String; var Ticker : String) : String; virtual;
    procedure FixShortsOOOrder(var Result : TTradeList);
  public
    constructor Create(const ImportFilter : TTLImportFilter; Proxy : Boolean = false);
    destructor Destroy; override;
    {Load from an OFX/QFX File, Calling this multiple times will load multiple files}
    procedure LoadFromFile(FileName : String);
    {Save each rawData element in the list above to a file. If only one rawData element exists
     then the fileName will be used as passed in. if there is more than one rawData element then
     a -(1), -(2_, -(3) etc will be appended to the end of the fileName}
    procedure SaveToFile(FileName : String);
    {Create the Request String for the call to the broker}
    function CreateRequestString(UserName, Passwd, AccountNumber : String;
                             StartDate, EndDate : TDateTime;
                             IncludePositions : Boolean = False;
                             IncludeBalances : Boolean = False;
                             IncludeOpenOrders : Boolean = False;
                             Language : String = 'ENG') : String;
    {Perform the entire sequence to get the data from the Broker using the OFXPost method}
    procedure GetOFXData(UserName, Passwd, AccountNumber : String;
                             StartDate, EndDate : TDateTime;
                             IncludePositions : Boolean = False;
                             IncludeBalances : Boolean = False;
                             IncludeOpenOrders : Boolean = False);
    {Parse the OFX Classes into a TTradeList, Passing -1 will process all elements in the OFXResponses list,
     Passing a number between 0 and OFXResonses.Count - 1, will return a list with just that response}
    function GetTradeList(Idx : Integer = -1) : TTradeList;
    {Parse the raw SGMLString and create the underlying Bound XML Classes, See OFXMain, for the
    generated source for these classes.}
    procedure ParseResponse(SGMLString : String);
    {Returns the OFX Response identified by IDX.}
    property OFXResponse[Idx : Integer] : TOFXResponse read GetOFXResponse;
    {How many responses do we have}
    property ResponseCount : Integer read GetOFXResponseCount;
    {The import filter, that is associated with the Import.}
    property ImportFilter : TTLImportFilter read GetImportFilter write SetImportFilter;
    {Return the RawData associated with this IDX}
    property RawData[Idx : Integer] : String read GetRawData;
    {If you want use fiddler to see the network traffic, then set the Proxy property to
      true and the HTTP connection will then proxy via LocalHost:8888, fiddler's default
      proxy port}
    property Proxy : Boolean read FProxy write SetProxy;
    property ErrorOccurred : Boolean read GetErrorOccurred;
    property ErrorMessage : String read FErrorText;
  end;

  {TDAmeritrade does not use the Strike, Expire, and CallPut properly, so we need to
    get this data from the Ticker, since it is more correct}
  TTDAmeritradeImport = class(TTLImport)
  public
    function ParseStrikePrice(Strike : String; var Ticker : String; ID : String) : String; override;
    function ParseExpireDate(ExpireDt : String; var Ticker : String) : String; override;
    function ParseCallPut(CallPut : String; var Ticker : String) : String; override;
    procedure ProcessOptionInfo(OptionInfo : IXMLOPTINFOType; var Result : TTLTrade;
      useSecName : Boolean = false); override;
    function IsCancelCorrectTrade(Value: String) : Boolean; override;
  end;

  {TFidelityImport does not use the Strike, Expire, and CallPut properly, so we need to
    get this data from the Ticker, since it is more correct}
  TFidelityImport = class(TTLImport)
  public
    function ParseStrikePrice(Strike : String; var Ticker : String; ID : String) : String; override;
    function ParseExpireDate(ExpireDt : String; var Ticker : String) : String; override;
    function ParseCallPut(CallPut : String; var Ticker : String) : String; override;
  end;

  {VanguardImport does not use the Strike, or Ticker properly so we need to
    get this data from the Secname, since it is more correct}
  TVanguardImport = class(TTLImport)
  public
    // get ticker and strike price from Secname
    procedure ProcessOptionInfo(OptionInfo:IXMLOPTINFOType; var Result:TTLTrade;
      useSecName : Boolean = false); override;
  end;

  {IB has an interesting Ticker for Options
    P CYM May 10 10700, The P is of course Put, Next element is Ticker,
    May 2010 is Expiration in this case the third Friday I would guess,
    fortunately looks like they do use the DTExpire and OPTType properly
    StrikePrice is mostly used properly but can contain decimal portion
    of price as 00, The Ticker will contain something like 10700, and the
    Strike price will then contain 107, or sometimes it also can contain 10700.
    So this means we need to deal with this}
  TIBImport = class(TTLImport)
  public
    {Option Ticker as stated above needs to be parsed differently for Options}
    function ParseOptionTicker(var Ticker : String) : String; override;
    {Need to do additional processing for the InvTranType since the price is in the memo}
    procedure ProcessTrans(Tran: IXMLINVTRANType; var Trade: TTLTrade); override;
    {Futures Definitions are found Here}
    procedure ProcessFIAssetClass(FIASSETCLASS : String; var Result : TTLTrade); override;
    {Strike price is generally correct but occassionally I noticed that the Strike price
      from the Ticker formatted with Cents like this 11000 ($110) is not correct in the
      StrikePrice field, it is also 11000 rather than 110. So we need to deal with this
      in these cases, so we will override ParseStrike Price.}
    function ParseStrikePrice(Strike : String; var Ticker : String; ID : String) : String; override;
  end;

{This is an RTTI Factory method that will provide the proper instance of the TTLImport class
  based on the ImportFilters.OFXClass property, This method looks complex but all it basically
  does is reads the string value for the OFXClass, and then instantiated and returns one of the
  above classes based on this. It will also set the ImportFilter and Proxy parameter into the
  newly instantiated class}
function GetTLImportClass(ImportFilter : TTLImportFilter; Proxy : Boolean = False) : TTLImport;


implementation

uses ActiveX, StrUtils, Variants, XSBuiltIns, //
   clipbrd, funcproc, globalVariables, //
   IdURI, IdUriUtils, System.Rtti, //
   TLLogging, TLCommonLib, DateUtils, TLSettings, WinInet;


const
  CODE_SITE_CATEGORY = 'TLImportOFX';
  CODE_SITE_DETAIL_CATEGORY = 'TLImportOFX-Detail';

  CRLF = #13#10;
  CONTENT_TYPE = 'application/x-ofx';
  KEEP_ALIVE = 'Keep-Alive';
  ACCEPT = '*/*';
  USER_AGENT = 'InetClntApp/3.0';

  XML_HEADER_TAG = '<?xml version="1.0" encoding="UTF-8" standalone="no"?>';
  OFX_XML_HEADER_TAG = '<?OFX OFXHEADER="100" VERSION="102" SECURITY="NONE" OLDFILEUID="NONE" NEWFILEUID="100"?>';

  OFX_HEADER_TAG = 'OFXHEADER:100' + CRLF +
                   'DATA:OFXSGML' + CRLF +
                   'VERSION:102' + CRLF +
                   'SECURITY:NONE' + CRLF +
                   'ENCODING:USASCII' + CRLF +
                   'CHARSET:1252' + CRLF +
                   'COMPRESSION:NONE' + CRLF +
                   'OLDFILEUID:NONE' + CRLF +
                   'NEWFILEUID:';
  OFX_OPENING_TAG = '<OFX>';
  OFX_CLOSING_TAG  = '</OFX>';
  SIGNONMSGSRQV1_OPENING_TAG = '<SIGNONMSGSRQV1>';
  SIGNONMSGSRQV1_CLOSING_TAG = '</SIGNONMSGSRQV1>';
  SONRQ_OPENING_TAG = '<SONRQ>';
  SONRQ_CLOSING_TAG = '</SONRQ>';
  DTCLIENT_TAG = '<DTCLIENT>';
  USERID_TAG = '<USERID>';
  USERPASS_TAG = '<USERPASS>';
  GENUSERKEY_TAG = '<GENUSERKEY>';
  LANGUAGE_TAG = '<LANGUAGE>';
  LANGUAGE_VALUE = 'ENG';
  FI_OPENING_TAG = '<FI>';
  FI_CLOSING_TAG = '</FI>';
  ORG_TAG = '<ORG>';
  FID_TAG = '<FID>';
  APPID_TAG = '<APPID>';
  APPID_VALUE = 'QWIN';
//  APPID_VALUE = 'Money';
//  APPID_VALUE = 'TRADELOG';
  APPVER_TAG = '<APPVER>';
  APPVER_VALUE = '2100';
//  APPVER_VALUE = '1600';
//  APPVER_VALUE = '1200';
  INVSTMTMSGSRQV1_OPENING_TAG = '<INVSTMTMSGSRQV1>';
  INVSTMTMSGSRQV1_CLOSING_TAG = '</INVSTMTMSGSRQV1>';
  INVSTMTTRNRQ_OPENING_TAG = '<INVSTMTTRNRQ>';
  INVSTMTTRNRQ_CLOSING_TAG = '</INVSTMTTRNRQ>';
  INVSTMTRQ_OPENING_TAG = '<INVSTMTRQ>';
  INVSTMTRQ_CLOSING_TAG = '</INVSTMTRQ>';
  INVACCTFROM_OPENING_TAG = '<INVACCTFROM>';
  INVACCTFROM_CLOSING_TAG = '</INVACCTFROM>';
  TRNUID_TAG = '<TRNUID>';
  CLTCOOKIE_TAG = '<CLTCOOKIE>';
  CLTCOOKIE_VALUE = '4';
  BROKERID_TAG = '<BROKERID>';
  ACCTID_TAG = '<ACCTID>';
  INCTRAN_OPENING_TAG = '<INCTRAN>';
  INCTRAN_CLOSING_TAG = '</INCTRAN>';
  DTSTART_TAG = '<DTSTART>';
  DTEND_TAG = '<DTEND>';
  INCLUDE_TAG = '<INCLUDE>';
  INCLUDE_VALUE = 'Y';
  INCLUDE_NO_VALUE = 'N';
  INCOO_TAG = '<INCOO>';
  INCPOS_OPENING_TAG = '<INCPOS>';
  INCPOS_CLOSING_TAG = '</INCPOS>';
  DTASOF_TAG = '<DTASOF>';
  INCBAL_TAG = '<INCBAL>';


{Create an instance of the passed in class name and return it as a TTLImport Class type}
function GetTLImportClass(ImportFilter : TTLImportFilter; Proxy : Boolean = False) : TTLImport;
var
 C : TRttiContext;
 T : TRttiInstanceType;
 V : TValue;
begin
  {First look up the Class by name}
  try
    C := TRttiContext.Create;
    try
      T := (C.FindType('TLImportOFX.' + ImportFilter.OFXClass) as TRttiInstanceType);
      if T <> nil then begin
        {Next find the Create method and invoke it. passing in the Importfilter parameter}
        V := T.GetMethod('Create').Invoke(T.metaClassType, [ImportFilter, Proxy]);
        {Finally verify that the class type is a TTLImport Object type}
        if V.AsObject is TTLImport then
          Result := V.AsObject as TTLImport
        else
          raise ETLImportException.Create(Format('ClassName: %s Must be a descendent of TTLImport', [ImportFilter.OFXClass]));
      end
      else
        raise ETLImportException.Create(Format('ClassName: %s Could not be found', [ImportFilter.OFXClass]));
    finally
      C.Free;
    end;
  finally
    // GetTLImportClass
  end;
end;


function delExtraSpaces(s:string):string;
begin
  while (pos('  ',s) > 0) do begin
    delete(s,pos('  ',s),1);
  end;
  result := s;
end;


function TTLImport.SSLInet(AUrl: String; Header: TStringStream;
  var AData: AnsiString): String;
var
  aBuffer: array[0 .. 4096] of Byte;
  BufStream: TStringStream;
  sMethod: String;
  BytesRead: Cardinal;
  pSession: HINTERNET;
  pConnection: HINTERNET;
  pRequest: HINTERNET;
  blnSSL: Boolean;
  URI: TIdURI;
  ResultBuffer: array[0 .. 4096] of Char;
  Reserved: Cardinal;
begin
  try
    Result := '';
    blnSSL := StrUtils.StartsText('https://', AUrl);
    URI := TIdURI.Create(AUrl);
    try
      if not StrUtils.ContainsText('Host:', Header.DataString) then
        Header.WriteString('Host: ' + URI.Host + sLineBreak);
      pSession := InternetOpen(nil, INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
      if Assigned(pSession) then begin
        try
          case blnSSL of
          True:
             pConnection := InternetConnect(pSession, PChar(URI.Host),
              INTERNET_DEFAULT_HTTPS_PORT, nil, nil, INTERNET_SERVICE_HTTP, 0, 0);
          False:
             pConnection := InternetConnect(pSession, PChar(URI.Host),
              INTERNET_DEFAULT_HTTP_PORT, nil, nil, INTERNET_SERVICE_HTTP, 0, 0);
          end;
          if Assigned(pConnection) then begin
            try
              if (AData = '') then
                sMethod := 'GET'
              else
                sMethod := 'POST';
              case blnSSL of
              True: pRequest := HTTPOpenRequest(pConnection, PChar(sMethod),
                  PChar(URI.GetPathAndParams), PChar('HTTP/1.0'), nil, nil,
                  INTERNET_FLAG_SECURE or INTERNET_FLAG_NO_COOKIES, 0);
              false: pRequest := HTTPOpenRequest(pConnection, PChar(sMethod),
                  PChar(URI.GetPathAndParams), PChar('HTTP/1.0'), nil, nil,
                  INTERNET_FLAG_NO_COOKIES, 0);
              end;
              if Assigned(pRequest) then begin
                try
                  HttpAddRequestHeaders(pRequest, PChar(Header.DataString),
                    Length(Header.DataString), HTTP_ADDREQ_FLAG_ADD and
                      HTTP_ADDREQ_FLAG_REPLACE);
                  if HTTPSendRequest(pRequest, nil, 0, Pointer(AData), Length(AData)) then
                  begin
                    BufStream := TStringStream.Create('', TEncoding.UTF8);
                    try
                      BytesRead := 0;
                      while InternetReadFile(pRequest, @aBuffer, SizeOf(aBuffer),
                        BytesRead) do begin
                        if (BytesRead = 0) then Break;
                        BufStream.WriteBuffer(aBuffer[0], BytesRead);
                      end;
                      AData := BufStream.DataString;
                      { Read the HTTP Status Code from the header and if it exists then return it }
                      Reserved := 0;
                      BytesRead := Length(ResultBuffer);
                      if HttpQueryInfo(pRequest, HTTP_QUERY_STATUS_CODE, @ResultBuffer,
                        BytesRead, Reserved) then Result := ResultBuffer;
                      BytesRead := Length(ResultBuffer);
                      if HttpQueryInfo(pRequest, HTTP_QUERY_STATUS_TEXT, @ResultBuffer,
                        BytesRead, Reserved) then Result := Result + ' ' + ResultBuffer;
                      if Length(Result) = 0 then
                        Result := 'Could not read Status Code, See Data for Results';
                    finally
                      FreeAndNil(BufStream);
                    end;
                  end;
                finally
                  InternetCloseHandle(pRequest);
                end;
              end; // if Assigned(pRequest)
            finally
              InternetCloseHandle(pConnection);
            end;
          end; // if Assigned(pConnection)
        finally
          InternetCloseHandle(pSession);
        end;
      end; // if Assigned(pSession)
    finally
      URI.Free;
    end;
  finally
    // SSLInet
  end;
end;


{ TTLImport }

function TTLImport.TrimLeadingZeros(const S: string): string;
var
  I, L: Integer;
begin
  Result := '';
  L:= Length(S);
  if (L > 0) and (S[L] = '-') then
    Result := '-';
  I:= 1;
  while (I < L) and (S[I] in ['0', '+', '-']) do begin
    Inc(I);
    if (S[I] = '.') then begin
      {If we got to the decimal point then the number is Zero Point Something
       so don't strip the last Zero}
      Dec(I);
      break;
    end;
  end;
  Result:= Result + Copy(S, I);
end;


function TTLImport.TrimTrailingZeros(S: string): string;
var
  I, L: Integer;
begin
  if pos('.',s)=0 then begin
    result := s;
    exit;
  end;
  Result := '';
  L:= Length(S);
  if (L > 0) and (S[L] = '-') then Result := '-';
  while rightStr(s,1)='0' do
    delete(s,Length(S),1);
  if rightStr(s,1)='.' then delete(s,Length(S),1);
  Result := s;
end;


function TTLImport.CreateGuid: string;
var
  ID: TGUID;
begin
  try
    Result := '';
    if CoCreateGuid(ID) = S_OK then Result := GUIDToString(ID);
    Result := Copy(Result, 2, Length(Result) - 2);
  finally
    // CreateGuid
  end;
end;


// ====================================
function TTLImport.CreateRequestString(
  UserName, Passwd, AccountNumber : String;
  StartDate, EndDate : TDateTime;
  IncludePositions : Boolean = False;
  IncludeBalances : Boolean = False;
  IncludeOpenOrders : Boolean = False;
  Language : String = 'ENG') : String;
var
  Str : TStringList;
  dtNow : TDateTime;
  sNow : string;
  // --------------
  function GetOFXHeaderTag : String;
  begin
    Result := 'OFXHEADER:100' + CRLF +
              'DATA:OFXSGML' + CRLF +
              'VERSION:102' + CRLF +
              'SECURITY:NONE' + CRLF +
              'ENCODING:USASCII' + CRLF +
              'CHARSET:1252' + CRLF +
              'COMPRESSION:NONE' + CRLF +
              'OLDFILEUID:' + CreateGuid +  CRLF +
              'NEWFILEUID:' + CreateGuid;
  end;
  // --------------
  function BooleanToYesOrNo(Value : Boolean) : String;
  begin
    if Value then
      Result := INCLUDE_VALUE
    else
      Result := INCLUDE_NO_VALUE;
  end;
  // --------------
begin // CreateRequestString
  try
    Str := TStringList.Create;
    try
      Str.Append(GetOFXHeaderTag);
      Str.Append(''); {Need a Blank Line between header and ofx tag.}
      Str.Append(OFX_OPENING_TAG);
      // ----------
      {Signon Information}
      Str.Append(SIGNONMSGSRQV1_OPENING_TAG);
      Str.Append(SONRQ_OPENING_TAG);
      dtNow := now;
      sNow := FormatDateTime('yyyymmddhhnnss.zzz', dtNow);
      Str.Append(DTCLIENT_TAG + sNow);
      {Signon Credentials}
      Str.Append(USERID_TAG + UserName);
      Str.Append(USERPASS_TAG + Passwd);
      Str.Append(GENUSERKEY_TAG + INCLUDE_NO_VALUE);
      Str.Append(LANGUAGE_TAG + Language);
      {Financial Institution Information}
      Str.Append(FI_OPENING_TAG);
      Str.Append(ORG_TAG + FImportFilter.OFXFIOrg);
      if (FImportFilter.OFXFIID <> '<None>') then
         Str.Append(FID_TAG + FImportFilter.OFXFIID);
      Str.Append(FI_CLOSING_TAG);
      {Application Information, Should be TradeLog and Version but this does not work so for now
        we are cheating by putting MS Money and Version}
      Str.Append(APPID_TAG + APPID_VALUE);
      Str.Append(APPVER_TAG + APPVER_VALUE);
      Str.Append(SONRQ_CLOSING_TAG);
      Str.Append(SIGNONMSGSRQV1_CLOSING_TAG);
      {End Signon}
      // ----------
      {Investment Account Transaction}
      Str.Append(INVSTMTMSGSRQV1_OPENING_TAG);
      Str.Append(INVSTMTTRNRQ_OPENING_TAG);
      Str.Append(TRNUID_TAG + CreateGUID);
//      Str.Append(CLTCOOKIE_TAG + CLTCOOKIE_VALUE);
      Str.Append(INVSTMTRQ_OPENING_TAG);
      {From Account Information}
      Str.Append(INVACCTFROM_OPENING_TAG);
      Str.Append(BROKERID_TAG + FImportFilter.OFXBrokerID);
      if Length(Trim(AccountNumber)) = 0 then
      {Assume User Name is Account Number}
        Str.Append(ACCTID_TAG + UserName)
      else
        Str.Append(ACCTID_TAG + AccountNumber);
      Str.Append(INVACCTFROM_CLOSING_TAG);
      {Transaction Include Information}
      Str.Append(INCTRAN_OPENING_TAG);
      Str.Append(DTSTART_TAG + FormatDateTime('yyyymmdd', StartDate));
      Str.Append(DTEND_TAG + FormatDateTime('yyyymmdd', EndDate));
      Str.Append(INCLUDE_TAG + INCLUDE_VALUE);
      Str.Append(INCTRAN_CLOSING_TAG);
      Str.Append(INCOO_TAG + BooleanToYesOrNo(IncludeOpenOrders));
      Str.Append(INCPOS_OPENING_TAG);
      Str.Append(DTASOF_TAG + FormatDateTime('yyyymmdd', EndDate));
      Str.Append(INCLUDE_TAG + BooleanToYesOrNo(IncludePositions));
      Str.Append(INCPOS_CLOSING_TAG);
      Str.Append(INCBAL_TAG + BooleanToYesOrNo(IncludeBalances));
      // ----------
      Str.Append(INVSTMTRQ_CLOSING_TAG);
      Str.Append(INVSTMTTRNRQ_CLOSING_TAG);
      Str.Append(INVSTMTMSGSRQV1_CLOSING_TAG);
      Str.Append(OFX_CLOSING_TAG);
      Result := Str.Text;
    finally
      Str.Free;
    end;
  finally
    // CreateRequestString
  end;
end;

destructor TTLImport.Destroy;
begin
  FRawData.Free;
  FOFXResponses.Free;
  inherited;
end;
// ====================================


function TTLImport.FindInfo(Idx : Integer; UniqueID : String): IXMLNode;
var
  I : Integer;
begin
  try
    Result := nil;
    // Look through Each List in the SecList to find the Unique Sec ID
    // and then return the SecInfo Object
    // look in reverse order to get the most recent info
    for I := FOFXResponses[Idx].SecList.SECLIST.STOCKINFO.Count - 1 downto 0 do
    begin
      if (Trim(FOFXResponses[Idx].SecList.SECLIST.STOCKINFO.Items[I].SECINFO.SECID.UNIQUEID) = Trim(UniqueID))
      then begin
        //2014-06-05 added code for Schwab memo text "WITH STOCK SPLIT SHARES" so we don't skip these trades
        if (pos('SPLIT ',FOFXResponses[Idx].SecList.SECLIST.STOCKINFO.Items[I].SECINFO.SECNAME)>0)
        and (pos('WITH STOCK SPLIT SHARES',FOFXResponses[Idx].SecList.SECLIST.STOCKINFO.Items[I].SECINFO.SECNAME)=0)
        then
          continue
        else
          Exit(FOFXResponses[Idx].SecList.SECLIST.STOCKINFO.Items[I]);
      end;
    end; // for i loop
    for I := FOFXResponses[Idx].SecList.SECLIST.OPTINFO.Count - 1 downto 0 do
    begin
      if (Trim(FOFXResponses[Idx].SecList.SECLIST.OPTINFO.Items[I].SECINFO.SECID.UNIQUEID) = Trim(UniqueID)) then
        Exit(FOFXResponses[Idx].SecList.SECLIST.OPTINFO.Items[I]);
    end; // for i loop
    for I := FOFXResponses[Idx].SecList.SECLIST.MFINFO.Count - 1 downto 0 do
    begin
      if (Trim(FOFXResponses[Idx].SecList.SECLIST.MFINFO.Items[I].SECINFO.SECID.UNIQUEID) = Trim(UniqueID)) then
        Exit(FOFXResponses[Idx].SecList.SECLIST.MFINFO.Items[I]);
    end; // for i loop
    for I := FOFXResponses[Idx].SecList.SECLIST.DEBTINFO.Count - 1 downto 0 do
    begin
      if (Trim(FOFXResponses[Idx].SecList.SECLIST.DEBTINFO.Items[I].SECINFO.SECID.UNIQUEID) = Trim(UniqueID)) then
        Exit(FOFXResponses[Idx].SecList.SECLIST.DEBTINFO.Items[I]);
    end; // for i loop
    for I := FOFXResponses[Idx].SecList.SECLIST.OTHERINFO.Count - 1 downto 0 do
    begin
      if (Trim(FOFXResponses[Idx].SecList.SECLIST.OTHERINFO.Items[I].SECINFO.SECID.UNIQUEID) = Trim(UniqueID)) then
        Exit(FOFXResponses[Idx].SecList.SECLIST.OTHERINFO.Items[I]);
    end; // for i loop
    // i:=0;
  finally
    // FindInfo
  end;
end;


procedure TTLImport.FixShortsOOOrder(var Result: TTradeList);
var
  I, J : Integer;
begin
  try
    I := 0;
    while I < Result.Count do begin
      if (Result[I].LS = 'S') and (Result[I].OC = 'C') then begin
        J := I + 1;
        if (J < Result.Count) then begin
          repeat
            if (Result[J].Date = Result[I].Date)
            and (Result[J].Time = Result[I].Time)
            and (Result[J].Ticker = Result[I].Ticker)
            and (Result[J].LS = 'S') and (Result[J].OC = 'O') then begin
              Result.Move(J, I);
              Inc(I);
            end; // if Result[J]
            Inc(J);
          until (J = Result.Count);
        end; // if J <
      end; // if Result[I]
      Inc(I);
    end; // while
  finally
    // FixShortsOOOrder
  end;
end;


{Default Implementation, that expects the Broker put either CALL, or PUT in the
  callPut field, This method will also strip of any characters that may be left on the
  ticker, so that the ticker will only contain the StrikePrice
  Also if for some reason the CallPut field does not have Call or Put, then
  the Ticker Characters will be used to generate the Call Put entry.}
function TTLImport.ParseCallPut(CallPut: String; var Ticker: String) : String;
var
  S : String;
begin
  try
    {Use the CallPut field first}
    Result := Trim(CallPut);
    Ticker := Trim(Ticker);
    if Length(Ticker) > 0 then begin
      {If the first character of the Value is a character then remove it}
      if (Ticker[1] in ['a'..'z', 'A'..'Z']) then begin
        S := Ticker[1];
        if Length(Ticker) > 1 then
          Ticker := Copy(Ticker, 2)
        else
          Ticker := '';
        {If for some reason the CallPut field does not have an appropriate value then try and use
          the character}
        if (Result <> 'CALL') and (Result <> 'PUT') then begin
          if S = 'P' then
            Result := 'PUT'
          else if S = 'C' then
            Result := 'CALL';
        end; // if Result
      end; // Ticker[1]
    end; // if Length(Ticker) > 0
  finally
    // ParseCallPut
  end;
end;


{Default Implementation that expects that the Broker used the Expire Date Field
  Correctly, Date is expected to be in YYYYMMDD format}
function TTLImport.ParseExpireDate(ExpireDt : String; var Ticker: String): String;
var
  DT : String;
  M : Word;
begin
  try
    {If we got here then the Value parameter, did not have a valid date.}
    DT := Copy(Trim(ExpireDt), 1, 8);
    M := StrToInt(Copy(DT, 5, 2));
    {Month should be between 1 and 12, otherwise we just can't get the expire date so return
    zero, which will produce the 1899 date which should be an indication that this failed.}
    if (M in [1..12]) then
      Result := Copy(DT, 7, 2) + UpperCase(Settings.InternalFmt.ShortMonthNames[M]) + Copy(DT, 3, 2)
    else
      Result := '0000000';
    if (Length(Ticker) > 5) then begin
     {Assume if this is an integer then it is a date and we need to strip it for the next routine}
      if IsInt(Copy(Ticker, 1, 6)) then begin
        if Length(Ticker) > 6 then
          Ticker := Copy(Ticker, 7)
        else
          Ticker := '';
      end; // if IsInt(Copy(Ticker, 1, 6))
    end; // if Length(Ticker) > 5
  finally
    // ParseExpireDate
  end;
end;


// Default implementation, that assume all characters on the front of the ticker
// make up the actual symbol, This routine will return the Ticker parameter
// after stripping off the characters and any spaces, and also underscores
function TTLImport.ParseOptionTicker(var Ticker: String) : String;
var
  I : Integer;
begin
  try
    Ticker := UpperCase(Trim(Ticker));
    Result := '';
    {First get the characters which constitute the ticker}
    for I := 1 to Length(Ticker) do begin
      {Get all characters on front of string plus 7 which is the code for mini options of 10 contracts}
      if Ticker[I] in ['A'..'Z','7'] then Result := Result + Ticker[I]
      {Once we no longer have a character or underscore then stop assuming we are done with ticker portion}
      else
        break;
    end;
    // Did not find any characters on Ticker so just return whole string
    // because we do not know what to do
    if (Length(Result) = 0) then Result := Ticker;
    // Now remove the ticker and if the balance of the string
    // contains additional data return it to be processed
    if I < Length(Ticker) then
      Ticker := Trim(Copy(Ticker, I))
    else
      Ticker := '';
  finally
    // ParseOptionTicker
  end;
end;


procedure TTLImport.ParseResponse(SGMLString : String);
var
  S : String;
  StartIdx, EndIdx : Integer;
  XmlStr : String;
  OFXResponse : TOFXResponse;
begin
  try
    OFXResponse := TOFXResponse.Create;
    S := SGMLString;
    // Strip the Header from the SGML String
    S := Copy(S, Pos('<OFX>', S));
    //Convert the SGML String to XML
    S := SGMLToXML(S);
    // Load the Signon Reqponse Object
    StartIdx := Pos('<SIGNONMSGSRSV1>', S);
    if (StartIdx > 0) then begin
      endIdx := Pos('</SIGNONMSGSRSV1>', S) + Length('</SIGNONMSGSRSV1>');
      XmlStr := XML_HEADER_TAG + Copy(S, StartIdx, endIdx - StartIdx);
      // Parse Signon
      OFXResponse.Signon := LoadXMLData(XmlStr).GetDocBinding('SIGNONMSGSRSV1', TXMLSIGNONMSGSRSV1Type, TargetNamespace) as IXMLSIGNONMSGSRSV1Type;
      OFXResponse.Signon.OwnerDocument.Options := OFXResponse.Signon.OwnerDocument.Options + [doNodeAutoIndent];
    end;
    // Load the Investment Statment Response Object
    StartIdx := Pos('<INVSTMTMSGSRSV1>', S);
    if (StartIdx > 0) then begin
      endIdx := Pos('</INVSTMTMSGSRSV1>', S) + Length('</INVSTMTMSGSRSV1>');
      XmlStr := XML_HEADER_TAG + Copy(S, StartIdx, endIdx - StartIdx);
      // Parse Investment Statement
      OFXResponse.InvStmt := LoadXMLData(XmlStr).GetDocBinding('INVSTMTMSGSRSV1', TXMLINVSTMTMSGSRSV1Type, TargetNamespace) as IXMLINVSTMTMSGSRSV1Type;
      OFXResponse.InvStmt.OwnerDocument.Options := OFXResponse.InvStmt.OwnerDocument.Options + [doNodeAutoIndent];
    end;
    // Load the Security List Response Object
    StartIdx := Pos('<SECLISTMSGSRSV1>', S);
    if (StartIdx > 0) then begin
      endIdx := Pos('</SECLISTMSGSRSV1>', S) + Length('</SECLISTMSGSRSV1>');
      XmlStr := XML_HEADER_TAG + Copy(S, StartIdx, endIdx - StartIdx);
      // Parse Securities List
      OFXResponse.SecList := LoadXMLData(XmlStr).GetDocBinding('SECLISTMSGSRSV1', TXMLSECLISTMSGSRSV1Type, TargetNamespace) as IXMLSECLISTMSGSRSV1Type;
      OFXResponse.SecList.OwnerDocument.Options := OFXResponse.SecList.OwnerDocument.Options + [doNodeAutoIndent];
    end;
    FOFXResponses.Add(OFXResponse);
  finally
    // ParseResponse
  end;
end;


// Default implementation that assumes the Strike Price field is used correctly
// by the broker and only leading zero's - decimals MUST NOT be stripped off
function TTLImport.ParseStrikePrice(Strike : String; var Ticker: String; ID : String) : String;
var
  Price : String;
begin
  try
    {If the Strike Price is Floating Point value assume it is correct}
    Strike := Trim(Strike);
    if IsFloat(Strike) then begin
      Price := TrimLeadingZeros(Trim(Strike));
      Price := TrimTrailingZeros(Price);
      Result :=  Price;
    end
    else
      Result := '0';
  finally
    // ParseStrikePrice
  end;
end;


// Default Implementation that assumes the Stock Ticker is just a
// Simple string. Leading and trailing spaces will be trimmed, if there
// is a space within the text, only that before the space will be returned.
function TTLImport.ParseStockTicker(var Ticker: String) : String;
begin
  try
    Result := UpperCase(Trim(Ticker));
    if Pos(' ', Result) > 0 then
      Result := Copy(Result, 1, Pos(' ', Result) - 1);
  finally
    // ParseStockTicker
  end;
end;


procedure TTLImport.ProcessInvBuy(InvBuy : IXMLINVBUYType; var Result: TTLTrade);
var
  Commission: Double;
  Fees: Double;
begin
  try
    // Shares
    Result.Shares := Abs(RndTo5(StrToFloat(TrimLeadingZeros(Trim(InvBuy.UNITS)))));
    // Commissions Field and Fees Field seem to be the Comnmission
    Fees := 0;
    Commission := 0;
    if IsFloat(TrimLeadingZeros(Trim(InvBuy.FEES))) then
      Fees := Abs(RndTo5(StrToFloat(TrimLeadingZeros(Trim(InvBuy.FEES)))));
    if IsFloat(TrimLeadingZeros(Trim(InvBuy.COMMISSION))) then
      Commission := Abs(RndTo5(StrToFloat(TrimLeadingZeros(Trim(InvBuy.COMMISSION)))));
    {If it hasn't been set yet and Fees + Commission are <> 0}
    if (Result.Commission = 0) and (RndTo5(Fees + Commission) <> 0) then
      Result.Commission := RndTo5(Fees + Commission);
    // Price Check and see if it is zero, just in case it already set elsewhere
    // as in the Case of IB it is in the Memo of InvTrans; round Amount
    if (Result.Price = 0) and (StrToFloat(TrimLeadingZeros(Trim(InvBuy.UNITPRICE))) <> 0)
    then begin
      Result.Price := RndTo6(StrToFloat(TrimLeadingZeros(Trim(InvBuy.UNITPRICE))));
    end;
    // Amount
    Result.Amount := -Abs(RndTo5(StrToFloat(TrimLeadingZeros(Trim(InvBuy.TOTAL)))));
  finally
    // ProcessInvBuy
  end;
end;


procedure TTLImport.ProcessInvSell(InvSell: IXMLINVSELLType;
  var Result: TTLTrade);
var
  Commission: Double;
  Fees: Double;
begin
  try
    // Shares
    Result.Shares := Abs(RndTo5(StrToFloat(TrimLeadingZeros(Trim(InvSell.UNITS)))));
    // Commissions Field and Fees Field seem to be the Comnmission
    Fees := 0;
    Commission := 0;
    if IsFloat(TrimLeadingZeros(Trim(InvSell.FEES))) then
      Fees := Abs(RndTo5(StrToFloat(TrimLeadingZeros(Trim(InvSell.FEES)))));
    if IsFloat(TrimLeadingZeros(Trim(InvSell.COMMISSION))) then
      Commission := Abs(RndTo5(StrToFloat(TrimLeadingZeros(Trim(InvSell.COMMISSION)))));
    // If it hasn't been set yet and Fees + Commission are <> 0}
    if (Result.Commission = 0) and (RndTo5(Fees + Commission) <> 0) then
      Result.Commission := RndTo5(Fees + Commission);
    // Price Check and see if it is zero, just in case it already set elsewhere
    // as in the Case of IB it is in the Memo of InvTrans; round Amount
      if (Result.Price = 0) //
      and (StrToFloat(TrimLeadingZeros(Trim(InvSell.UNITPRICE))) <> 0) //
      then
        Result.Price := rndTo6(StrToFloat(TrimLeadingZeros(Trim(InvSell.UNITPRICE))));
      // Amount
      Result.Amount := Abs(RndTo5(StrToFloat(TrimLeadingZeros(Trim(InvSell.TOTAL)))));
  finally
    // ProcessInvSell
  end;
end;



// --------------------------------------------------------
// EXAMPLE of TDAmeritrade OFX Record
//  <OPTINFO>
//    <SECINFO>
//      <SECID>
//        <UNIQUEID>0SPXW.QQ72025000</UNIQUEID>
//        <UNIQUEIDTYPE>CUSIP</UNIQUEIDTYPE>
//      </SECID>
//      <SECNAME>SPXW May 26 2017 2025 Put (PM) (Weekly)</SECNAME>
//      <TICKER>SPXW May 26 2017 2025 Put (PM) (</TICKER>
//    </SECINFO>
//    <OPTTYPE>CALL</OPTTYPE>                   <-- WRONG!
//    <STRIKEPRICE>2025</STRIKEPRICE>        <-- matches SECNAME
//    <DTEXPIRE>20170519000000</DTEXPIRE>       <-- WRONG!
//    <SHPERCTRCT>100</SHPERCTRCT>           <-- Mult
//  </OPTINFO>
// --------------------------------------------------------

procedure TTLImport.ProcessOptionInfo(OptionInfo: IXMLOPTINFOType;
  var Result: TTLTrade; UseSecName : Boolean = false);
var
  Ticker, sTmp, Value, ID, sDTX, Expire, CallPut, Strike : String;
  // ------------------------------------------------------
  // Some Weekly/Monthly options have incorrect DTEXPIRE
  // NOTE: Uses sDTX, leaves value there - 2017-02-03 MB
  procedure GetDTExpireFromSECName(s:string);
  var
    i, j : integer;
    t1, t2 : string; // temp strings
  begin
    sDTX := '';
    i := 0;
    j := 0;
    // what format is the SECNAME?
    t1 := s; // leave s alone, work with copy in t1
    t2 := parsefirst(t1, ' '); // t2 = ticker, t1 = remainder
    t1 := trim(t1);
    repeat
      sDTX := uppercase(parsefirst(t1, ' ')); // either (PM) or MMM.
      if pos(sDTX,'JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC') > 0 then begin
        sDTX := rightstr('00' + parsefirst(t1, ' '),2) + sDTX; // DD
        t1 := trim(t1);
        t2 := parsefirst(t1, ' '); // YYYY
        sDTX := sDTX + copy(t2,3); // YY
      end else begin
        sDTX := ''; // clear if not month
      end;
    until (sDTX <> '') or (length(t1) < 10);
    // EX1: <SECNAME>SPXW (PM) (EOM) Jan 31 2017 2100 Put</SECNAME>
//    j := pos('(PM)', t1);
//    if j = 1 then begin
//      repeat
//        i := pos(') ', s, i+1);
//        if i > j then j := i;
//      until i = 0;
//      if j = 0 then exit;
//      sDTX := copy(s, j+1);
//    end
    // EX2: <SECNAME>SPXW Mar 10 2017 2450 Call (PM) (Weekly)</SECNAME> // TDAmeritrade
//    //else if (j > 1) and (pos('(Weekly)', t1) > j) then begin // old code
//    else if (j > 10) then begin // 2017-06-26 MB - more flexible
//      sDTX := trim(copy(t1, 1, j-1));
//    end;
//    s := ParseLast(sDTX, ' '); // remove Call/Put
//    s := ParseLast(sDTX, ' '); // remove strike price
//    // EX1: <SECNAME>SPXW (PM) (EOM) Jan 31 2017 2100 Put</SECNAME>
//    // EX2: <SECNAME>SPXW Mar 10 2017 2450 Call (PM) (Weekly)</SECNAME> // TDAmeritrade
//    if IsDate(sDTX) = false then
//      sDTX := ''
//    else begin
//      s := uppercase(trim(sDTX));
//      sDTX := parsefirst(s, ' '); // get MMM
//      sDTX := parsefirst(s, ' ') + sDTX; // add DD to front
//      if length(sDTX) < 5 then sDTX := '0' + sDTX;
//      sDTX := sDTX + copy(s, 3); // add YY to end
//    end;
  end;
  // ------------------------------------------------------
begin // ProcessOptionInfo
  try
    // Pass the value of the original ticker into each of the parse methods so that
    // if for some reason the broker is not using the fields of the Security Info
    // record correctly we can still try and parse the data from the Ticker.
    if UseSecName then
      Value := Trim(OptionInfo.SECINFO.SECNAME)
    else
      Value := Trim(OptionInfo.SECINFO.TICKER);
    //Before changing the Value put the entire thing in OptionTicker.
    Result.OptionTicker := Value;
    {Now parse the Value and clip off each part as we process it.}
    ID := trim(OptionInfo.SECINFO.SECID.UNIQUEID);
    Ticker := ParseOptionTicker(Value);
    Expire := OptionInfo.DTEXPIRE;
    Expire := ParseExpireDate(Expire, Value);
    // ----------------------------------------------------
    // 2017-02-03 MB - hack for CBOE Weekly/Monthly Options like SPXW
    sTmp := uppercase(OptionInfo.SECINFO.TICKER); // 2017-05-18 MB just for Weekly Options
    if (pos('(WEEKLY)', sTmp) > 0) or (pos('(PM)', sTmp) > 0) then begin
      GetDTExpireFromSECName(Trim(OptionInfo.SECINFO.SECNAME)); // sDTX
      if sDTX <> '' then begin
        if sDTX <> Expire then Expire := sDTX;
      end;
    end;
    // end hack
    // ----------------------------------------------------
    // 2017-05-18 MB - if CALL/PUT spelled out, use that
    if pos('CALL', sTmp) > 0 then
      CallPut := 'CALL'
    else if pos('PUT', sTmp) > 0 then
      CallPut := 'PUT'
    else
      CallPut := ParseCallPut(OptionInfo.OPTTYPE, Value); // original
    // ----------------------------------------------------
    if pos('EXPIRED OPT', CallPut) > 0 then begin // 2018-09-11 MB
      Result.Ticker := CallPut;
      Result.TypeMult := 'OPT-100';
      Exit; // do NOT try to make sense of these TDA expired options!
    end;
    // ----------------------------------------------------
    Strike := ParseStrikePrice(OptionInfo.STRIKEPRICE, Value, ID);
    if Strike = '0' then Strike := '';
    //mini options
    if rightStr(ticker,1) = '7' then begin
      delete(ticker,length(ticker),1);
      Result.TypeMult := 'OPT-10';
    end;
    Result.Ticker := Ticker;
    if Length(Expire) > 0 then
      Result.Ticker := Result.Ticker + ' ' + Expire;
    if Length(Strike) > 0 then
      Result.Ticker := Result.Ticker + ' ' + Strike;
    if Length(CallPut) > 0 then
      Result.Ticker := Result.Ticker + ' ' + CallPut;
  finally
    // ProcessOptionInfo
  end;
end;


procedure TTLImport.ProcessOtherInfo(OtherInfo: IXMLOTHERINFOType;
  var Result: TTLTrade);
var
  Ticker : String;
  Value : String;
begin
  try
    Value := OtherInfo.SECINFO.TICKER;
    // if TICKER value is a cusip, use SECNAME instead
    if isInt(copy(value,1,4)) then begin
      Ticker := parseWords(OtherInfo.SecInfo.SECNAME, 3);
      // change SECNAME to valid Ticker symbol
      // Ticker := DESCtoTICK(Ticker);  2015-06-29 do this after importing
    end
    else
      Ticker := ParseStockTicker(Value);
    //
    if (Length(OtherInfo.FIASSETCLASS) > 0) then
      ProcessFIAssetClass(OtherInfo.FIASSETCLASS, Result);
    Result.Ticker := Ticker;
  finally
    // ProcessOtherInfo
  end;
end;


function TTLImport.ProcessBuyOpt(Option: IXMLBUYOPTType; OptionInfo : IXMLOPTINFOType): TTLTrade;
var
  sErr : string;
begin
  try
    if (Option = nil) or (OptionInfo = nil)
    or (IsCancelCorrectTrade(Option.INVBUY.INVTRAN.MEMO)) then
      Exit(nil);
    Result := TTLTrade.Create;
    try
      sErr := 'ProcessTrans';
      ProcessTrans(Option.INVBUY.INVTRAN, Result);
      sErr := 'ProcessInvBuy';
      ProcessInvBuy(Option.INVBUY, Result);
      {OC SL Fields}
      sErr := 'ConvertBuySell';
      ConvertBuySell(Trim(Option.OPTBUYTYPE), Result);
      sErr := 'CancelCorrect';
      CancelCorrect(Option.INVBUY.INVTRAN.MEMO, Result);
      {Type Multiplier}
      Result.TypeMult := 'OPT-' + Trim(Option.SHPERCTRCT);
      //mini option tickers with a "7" at the end will change type/mult to OPT-10
      sErr := 'ProcessOptionInfo';
      ProcessOptionInfo(OptionInfo, Result);
    except
      on e: Exception do begin
        sm('Error in ProcessBuyOpt.' + sErr + ':' + CR //
        + e.Message + CR //
        + 'ID: ' + Option.INVBUY.SECID.UNIQUEID);
      end;
    end;
  finally
    // ProcessBuyOpt
  end;
end;


function TTLImport.ProcessBuyOtherStock(Other: IXMLBUYOTHERType; StockInfo : IXMLSTOCKINFOType) : TTLTrade;
begin
  try
    if (Other = nil) or (StockInfo = nil)
    or (IsCancelCorrectTrade(Other.INVBUY.INVTRAN.MEMO)) then
      Exit(nil);
    Result := TTLTrade.Create;
    ProcessTrans(Other.INVBUY.INVTRAN, Result);
    ProcessInvBuy(Other.INVBUY, Result);
    ProcessStockInfo(StockInfo, Result);
    {No BuyType in a BuyOther so we must assume an open long}
    Result.OC := 'O';
    Result.LS := 'L';
    CancelCorrect(Other.INVBUY.INVTRAN.MEMO, Result);
  finally
//rj     DetailLogger.ExitMethod(self, 'ProcessBuyOtherStock');
  end;
end;


function TTLImport.ProcessSellOtherMF(Other: IXMLSELLOTHERType; MFInfo : IXMLMFINFOType) : TTLTrade;
begin
//rj   DetailLogger.EnterMethod(self, 'ProcessBuyOtherMF');
  try
    if (Other = nil) or (MFInfo = nil)
    or (IsCancelCorrectTrade(Other.INVSELL.INVTRAN.MEMO)) then
      Exit(nil);
    Result := TTLTrade.Create;
    ProcessTrans(Other.INVSELL.INVTRAN, Result);
    ProcessInvSell(Other.INVSELL, Result);
    ProcessMFInfo(MFInfo, Result);
    // No BuyType in a BuyOther so we must assume an open long
    Result.OC := 'C';
    Result.LS := 'L';
    CancelCorrect(Other.INVSELL.INVTRAN.MEMO, Result);
  finally
//rj     DetailLogger.ExitMethod(self, 'ProcessBuyOtherMF');
  end;
end;


function TTLImport.ProcessBuyOtherMF(Other: IXMLBUYOTHERType; MFInfo : IXMLMFINFOType) : TTLTrade;
begin
//rj   DetailLogger.EnterMethod(self, 'ProcessBuyOtherMF');
  try
    if (Other = nil) or (MFInfo = nil)
    or (IsCancelCorrectTrade(Other.INVBUY.INVTRAN.MEMO)) then
      Exit(nil);
    Result := TTLTrade.Create;
    ProcessTrans(Other.INVBUY.INVTRAN, Result);
    ProcessInvBuy(Other.INVBUY, Result);
    ProcessMFInfo(MFInfo, Result);
    // No BuyType in a BuyOther so we must assume an open long
    Result.OC := 'O';
    Result.LS := 'L';
    CancelCorrect(Other.INVBUY.INVTRAN.MEMO, Result);
  finally
//rj     DetailLogger.ExitMethod(self, 'ProcessBuyOtherMF');
  end;
end;


function TTLImport.ProcessBuyOther(Other: IXMLBUYOTHERType;
  OtherInfo: IXMLOTHERINFOType): TTLTrade;
begin
//rj   DetailLogger.EnterMethod(self, 'ProcessBuyOther');
  try
    if (Other = nil) or (OtherInfo = nil)
    or (IsCancelCorrectTrade(Other.INVBUY.INVTRAN.MEMO)) then
      Exit(nil);
    Result := TTLTrade.Create;
    ProcessTrans(Other.INVBUY.INVTRAN, Result);
    ProcessInvBuy(Other.INVBUY, Result);
    ProcessOtherInfo(OtherInfo, Result);
    // No BuyType in a BuyOther so we must assume an open long
    Result.OC := 'O';
    Result.LS := 'L';
    CancelCorrect(Other.INVBUY.INVTRAN.MEMO, Result);
  finally
//rj     DetailLogger.ExitMethod(self, 'ProcessBuyOther');
  end;
end;


function TTLImport.ProcessBuyOtherOption(Other: IXMLBUYOTHERType;
  OptionInfo: IXMLOPTINFOType): TTLTrade;
begin
//rj   DetailLogger.EnterMethod(self, 'ProcessBuyOtherOption');
  try
    if (Other = nil) or (OptionInfo = nil)
    or (IsCancelCorrectTrade(Other.INVBUY.INVTRAN.MEMO)) then
      Exit(nil);
    Result := TTLTrade.Create;
    ProcessTrans(Other.INVBUY.INVTRAN, Result);
    ProcessInvBuy(Other.INVBUY, Result);
    ProcessOptionInfo(OptionInfo, Result);
    // No BuyType in a BuyOther so we must assume an open long
    Result.OC := 'O';
    Result.LS := 'L';
    CancelCorrect(Other.INVBUY.INVTRAN.MEMO, Result);
  finally
//rj     DetailLogger.ExitMethod(self, 'ProcessBuyOtherOption');
  end;
end;


function TTLImport.ProcessBuyStock(Stock: IXMLBUYSTOCKType;
  StockInfo : IXMLNode): TTLTrade;
var
  SInfo : IXMLSTOCKINFOType;
  OInfo : IXMLOTHERINFOType;
begin
//rj   DetailLogger.EnterMethod(self, 'ProcessBuyStock');
  try
    if (Stock = nil) or (StockInfo = nil)
    or (IsCancelCorrectTrade(Stock.INVBUY.INVTRAN.MEMO)) then
      Exit(nil);
    Result := TTLTrade.Create;
    ProcessTrans(Stock.INVBUY.INVTRAN, Result);
    ProcessInvBuy(Stock.INVBUY, Result);
    ConvertBuySell(Stock.BUYTYPE, Result);
    CancelCorrect(Stock.INVBUY.INVTRAN.MEMO, Result);
    Result.TypeMult := 'STK-1';
    if Supports(StockInfo, IXMLSTOCKINFOType, SInfo) then
      ProcessStockInfo(SInfo, Result)
    else if Supports(StockInfo, IXMLOTHERINFOType, OInfo) then
      ProcessOtherInfo(OInfo, Result)
    else
    begin
      FreeAndNil(Result);
      Exit(nil);
    end;
  finally
//rj     DetailLogger.ExitMethod(self, 'ProcessBuyStock');
  end;
end;


function TTLImport.ProcessBuyDebt(Stock: IXMLBUYDEBTType;
  StockInfo : IXMLNode): TTLTrade;
var
  SInfo : IXMLDEBTINFOType;
  OInfo : IXMLOTHERINFOType;
begin
//rj   DetailLogger.EnterMethod(self, 'ProcessBuyDebt');
  try
    if (Stock = nil) or (StockInfo = nil)
    or (IsCancelCorrectTrade(Stock.INVBUY.INVTRAN.MEMO)) then
      Exit(nil);
    Result := TTLTrade.Create;
    ProcessTrans(Stock.INVBUY.INVTRAN, Result);
    ProcessInvBuy(Stock.INVBUY, Result);
    result.OC := 'O';
    result.LS := 'L';
    //ConvertBuySell(Stock.BUYTYPE, Result);
    CancelCorrect(Stock.INVBUY.INVTRAN.MEMO, Result);
    Result.TypeMult := 'STK-1';
    if Supports(StockInfo, IXMLDEBTINFOType, SInfo) then
      ProcessDebtInfo(SInfo, Result)
    else begin
      FreeAndNil(Result);
      Exit(nil);
    end;
  finally
//rj     DetailLogger.ExitMethod(self, 'ProcessBuyDebt');
  end;
end;


function TTLImport.ProcessSellDebt(Stock: IXMLSellDEBTType;
  StockInfo : IXMLNode): TTLTrade;
var
  SInfo : IXMLDEBTINFOType;
  OInfo : IXMLOTHERINFOType;
begin
//rj   DetailLogger.EnterMethod(self, 'ProcessSellDebt');
  try
    if (Stock = nil) or (StockInfo = nil)
    or (IsCancelCorrectTrade(Stock.INVSELL.INVTRAN.MEMO)) then
      Exit(nil);
    Result := TTLTrade.Create;
    ProcessTrans(Stock.INVSELL.INVTRAN, Result);
    ProcessInvSell(Stock.INVSELL, Result);
    // ConvertBuySell(Stock.BUYTYPE, Result);
    result.OC := 'C';
    result.LS := 'L';
    CancelCorrect(Stock.INVSELL.INVTRAN.MEMO, Result);
    Result.TypeMult := 'STK-1';
    if Supports(StockInfo, IXMLDEBTINFOType, SInfo) then
      ProcessDebtInfo(SInfo, Result)
    else begin
      FreeAndNil(Result);
      Exit(nil);
    end;
  finally
//rj     DetailLogger.ExitMethod(self, 'ProcessSellDebt');
  end;
end;


function TTLImport.ProcessBuyMF(Stock: IXMLBUYMFType;
  StockInfo : IXMLMFINFOType): TTLTrade;
begin
//rj   DetailLogger.EnterMethod(self, 'ProcessBuyMF');
  try
    if (Stock = nil) or (StockInfo = nil)
    or (IsCancelCorrectTrade(Stock.INVBUY.INVTRAN.MEMO)) then
      Exit(nil);
    Result := TTLTrade.Create;
    ProcessTrans(Stock.INVBUY.INVTRAN, Result);
    ProcessInvBuy(Stock.INVBUY, Result);
    ConvertBuySell(Stock.BUYTYPE, Result);
    CancelCorrect(Stock.INVBUY.INVTRAN.MEMO, Result);
    Result.TypeMult := 'MUT-1';
    ProcessMFInfo(StockInfo, Result);
  finally
//rj     DetailLogger.ExitMethod(self, 'ProcessBuyMF');
  end;
end;


function TTLImport.ProcessClosureOpt(ClosureOpt : IXMLCLOSUREOPTType;
  OptionInfo: IXMLOPTINFOType; ClosureStk : IXMLNode): TTLTrade;
begin
//rj   DetailLogger.EnterMethod(self, 'ProcessClosureOpt');
  try
    if (ClosureOpt = nil) or (OptionInfo = nil)
    or (IsCancelCorrectTrade(ClosureOpt.INVTRAN.MEMO)) then
      Exit(nil);
    Result := TTLTrade.Create;
    ProcessTrans(ClosureOpt.INVTRAN, Result);
    if (Trim(ClosureOpt.OPTACTION) = 'EXPIRE') then begin
      Result.Shares := Abs(RndTo5(StrToFloat(TrimLeadingZeros(Trim(ClosureOpt.UNITS)))));
      Result.Price := 0;
      Result.OC := 'C';
      if (Trim(ClosureOpt.SUBACCTSEC) = 'SHORT') then
        Result.LS := 'S'
      else
        Result.LS := 'L';
      Result.TypeMult := 'OPT-' + Trim(ClosureOpt.SHPERCTRCT);
      ProcessOptionInfo(OptionInfo, Result);
    end
    //  else if (Trim(ClosureOpt.OPTACTION) = 'EXERCISE') then begin
    //  end
    //  else if (Trim(ClosureOpt.OPTACTION) = 'ASSIGN') then begin
    //  end
    else begin
      FreeAndNil(Result);
    end;
  finally
//rj     DetailLogger.ExitMethod(self, 'ProcessClosureOpt');
  end;
end;


procedure TTLImport.ProcessFIAssetClass(FIASSETCLASS : String;
  var Result: TTLTrade);
begin
  {Stock implementation does nothing. the FIAssetClass is specific to the
  financial institution, so this will need to be overridden at the FI level
  in FI specific one off implementations}
end;


function TTLImport.ProcessSellOpt(Option: IXMLSELLOPTType;
  OptionInfo : IXMLOPTINFOType): TTLTrade;
var
  sErr : string;
begin
//rj   DetailLogger.EnterMethod(self, 'ProcessSellOpt');
  try
    if (Option = nil) or (OptionInfo = nil)
    or (OptionInfo.SECINFO.TICKER = '')
    or (IsCancelCorrectTrade(Option.INVSELL.INVTRAN.MEMO)) then
      Exit(nil);
    try
      Result := TTLTrade.Create;
      sErr := 'ProcessTrans';
      ProcessTrans(Option.INVSELL.INVTRAN, Result);
      sErr := 'ProcessInvSell';
      ProcessInvSell(Option.INVSELL, Result);
      {OC LS Fields}
      sErr := 'ConvertBuySell';
      ConvertBuySell(Trim(Option.OPTSELLTYPE), Result);
      sErr := 'CancelCorrect';
      CancelCorrect(Option.INVSELL.INVTRAN.MEMO, Result);
      {Type Multiplier}
      Result.TypeMult := 'OPT-' + Trim(Option.SHPERCTRCT);
      sErr := 'ProcessOptionInfo';
      ProcessOptionInfo(OptionInfo, Result);
    except
      on e: Exception do
        sm('Error in ProcessSellOpt.' + sErr + ':' + CR
        + e.Message + CR
        + Option.INVSELL.SECID.UNIQUEID);
    end;
  finally
    // ProcessSellOpt
  end;
end;


function TTLImport.ProcessSellOther(Other: IXMLSELLOTHERType;
  OtherInfo: IXMLOTHERINFOType): TTLTrade;
begin
  try
    if (Other = nil) or (OtherInfo = nil)
    or (IsCancelCorrectTrade(Other.INVSELL.INVTRAN.MEMO)) then
      Exit(nil);
   Result := TTLTrade.Create;
   ProcessTrans(Other.INVSELL.INVTRAN, Result);
   ProcessInvSell(Other.INVSELL, Result);
   Result.OC := 'C';
   Result.LS := 'L';
   Result.TypeMult := 'STK-1';
   ProcessOtherInfo(OtherInfo, Result);
  finally
//rj     DetailLogger.ExitMethod(self, 'ProcessSellOther');
  end;
end;


function TTLImport.ProcessSellOtherOption(Other: IXMLSELLOTHERType;
  OptionInfo: IXMLOPTINFOType): TTLTrade;
begin
//rj   DetailLogger.EnterMethod(self, 'ProcessSellOtherOption');
  try
    if (Other = nil) or (OptionInfo = nil)
    or (IsCancelCorrectTrade(Other.INVSELL.INVTRAN.MEMO)) then
      Exit(nil);
    Result := TTLTrade.Create;
    ProcessTrans(Other.INVSELL.INVTRAN, Result);
    ProcessInvSell(Other.INVSELL, Result);
    ProcessOptionInfo(OptionInfo, Result);
    // No BuyType in a BuyOther so we must assume an open long
    Result.OC := 'C';
    Result.LS := 'L';
  finally
//rj     DetailLogger.ExitMethod(self, 'ProcessSellOtherOption');
  end;
end;


function TTLImport.ProcessSellOtherStock(Other: IXMLSELLOTHERType;
  StockInfo: IXMLSTOCKINFOTYPE): TTLTrade;
begin
//rj   DetailLogger.EnterMethod(self, 'ProcessSellOtherStock');
  try
    if (Other = nil) or (StockInfo = nil)
    or (IsCancelCorrectTrade(Other.INVSELL.INVTRAN.MEMO)) then
      Exit(nil);
    Result := TTLTrade.Create;
    ProcessTrans(Other.INVSELL.INVTRAN, Result);
    ProcessInvSell(Other.INVSELL, Result);
    ProcessStockInfo(StockInfo, Result);
    // No SellType in a SellOther so we must assume a Close Long
    Result.OC := 'C';
    Result.LS := 'L';
  finally
//rj     DetailLogger.ExitMethod(self, 'ProcessSellOtherStock');
  end;
end;


function TTLImport.ProcessSellStock(Stock: IXMLSELLSTOCKType;
  StockInfo : IXMLNode): TTLTrade;
     var
  SInfo : IXMLStockInfoType;
  OInfo : IXMLOtherInfoType;
begin
//rj   DetailLogger.EnterMethod(self, 'ProcessSellStock');
  try
    if (Stock = nil) or (StockInfo = nil)
    or (IsCancelCorrectTrade(Stock.INVSELL.INVTRAN.MEMO)) then
      Exit(nil);
    Result := TTLTrade.Create;
    ProcessTrans(Stock.INVSELL.INVTRAN, Result);
    ProcessInvSell(Stock.INVSELL, Result);
    ConvertBuySell(Stock.SELLTYPE, Result);
    CancelCorrect(Stock.INVSELL.INVTRAN.MEMO, Result);
    Result.TypeMult := 'STK-1';
    if Supports(StockInfo, IXMLStockInfoType, SInfo) then
      ProcessStockInfo(SInfo, Result)
    else if Supports(StockInfo, IXMLOtherInfoType, OInfo) then
      ProcessOtherInfo(OInfo, Result)
    else begin
      FreeAndNil(Result);
      Exit(nil);
    end;
  finally
//rj     DetailLogger.ExitMethod(self, 'ProcessSellStock');
  end;
end;


function TTLImport.ProcessSellMF(Stock: IXMLSELLMFType;
  StockInfo : IXMLMFINFOType): TTLTrade;
begin
//rj   DetailLogger.EnterMethod(self, 'ProcessSellMF');
  try
    if (Stock = nil) or (StockInfo = nil)
    or (IsCancelCorrectTrade(Stock.INVSELL.INVTRAN.MEMO)) then
      Exit(nil);
   Result := TTLTrade.Create;
   ProcessTrans(Stock.INVSELL.INVTRAN, Result);
   ProcessInvSell(Stock.INVSELL, Result);
   ConvertBuySell(Stock.SELLTYPE, Result);
   CancelCorrect(Stock.INVSELL.INVTRAN.MEMO, Result);
   Result.TypeMult := 'MUT-1';
   ProcessMFInfo(StockInfo, Result);
  finally
//rj     DetailLogger.ExitMethod(self, 'ProcessSellMF');
  end;
end;


procedure TTLImport.ProcessStockInfo(StockInfo: IXMLSTOCKINFOType;
  var Result: TTLTrade);
var
  Ticker : String;
  Value : String;
  Node : TXMLNode;
begin
//rj   DetailLogger.EnterMethod(self, 'ProcessStockInfo');
  try
    Value := StockInfo.SecInfo.TICKER;
    // if TICKER value is a cusip, use SECNAME instead
    if isInt(copy(value,1,4)) then begin
      Ticker := parseWords(StockInfo.SecInfo.SECNAME, 3);
      // change SECNAME to valid Ticker symbol
      // Ticker := DESCtoTICK(Ticker);  2015-06-29 do this after importing
    end
    else
      Ticker := trim(value); //ParseStockTicker(Value);
      // 2013-09-23 DE - allows for preferred stock tickers such as "GS PRA"
    if (Length(StockInfo.FIASSETCLASS) > 0) then
      ProcessFIAssetClass(StockInfo.FIASSETCLASS, Result);
    Result.Ticker := Ticker;
  finally
//rj     DetailLogger.ExitMethod(self, 'ProcessStockInfo');
  end;
end;


procedure TTLImport.ProcessDebtInfo(DebtInfo: IXMLDEBTINFOType;
  var Result: TTLTrade);
var
  Ticker : String;
  Value : String;
  Node : TXMLNode;
  p : Integer;
begin
//rj   DetailLogger.EnterMethod(self, 'ProcessDebtInfo');
  try
    Value := DebtInfo.SecInfo.TICKER;
    // if TICKER value is a cusip, use SECNAME instead
    if isInt(copy(value,1,4)) then begin
      Ticker := delExtraSpaces(DebtInfo.SecInfo.SECNAME);
      // NEW JERSEY TRANS 5.25%23TRAN VP DUE 12/15/23AMBAC INDEMNITY CORP
      // delete evrything after due date
      p := pos('DUE ',ticker);
      if (p > 0) and (length(ticker) > p + 12) then
        delete(ticker,p+12,length(ticker)-(P+12)+1);
      //ticker can only be 40 chars
      if length(ticker)>40 then
        ticker:= leftSTr(ticker,40);
    end;
    if (Length(DebtInfo.FIASSETCLASS) > 0) then
      ProcessFIAssetClass(DebtInfo.FIASSETCLASS, Result);
    Result.Ticker := Ticker;
  finally
//rj     DetailLogger.ExitMethod(self, 'ProcessDebtInfo');
  end;
end;


procedure TTLImport.ProcessMFInfo(MFInfo: IXMLMFINFOType;
  var Result: TTLTrade);
var
  Ticker : String;
  Value : String;
begin
//rj   DetailLogger.EnterMethod(self, 'ProcessMFInfo');
  try
    Value := MFInfo.SECINFO.TICKER;
    Ticker := ParseStockTicker(Value);
    Result.Ticker := Ticker;
  finally
//rj     DetailLogger.ExitMethod(self, 'ProcessMFInfo');
  end;
end;


procedure TTLImport.ConvertBuySell(Value: String; var Trade : TTLTrade);
begin
//rj   DetailLogger.EnterMethod(self, 'ConvertBuySell');
  Value := Trim(Value);
  try
    Trade.OC := 'O';
    Trade.LS := 'L';
    // Option Buy Sell Types
    if (UpperCase(Value) = 'BUYTOOPEN') then begin
      Trade.OC := 'O';
      Trade.LS := 'L';
    end
    else if (UpperCase(Value) = 'BUYTOCLOSE') then begin
      Trade.OC := 'C';
      Trade.LS := 'S';
    end
    else if (UpperCase(Value) = 'SELLTOOPEN') then begin
      Trade.OC := 'O';
      Trade.LS := 'S';
    end
    else if (UpperCase(Value) = 'SELLTOCLOSE') then begin
      Trade.OC := 'C';
      Trade.LS := 'L';
    end
    {Stock Buy and Sell Types}
    else if (UpperCase(Value) = 'BUYTOCOVER') then begin
      Trade.OC := 'C';
      Trade.LS := 'S';
    end
    else if (UpperCase(Value) = 'SELLSHORT') then begin
      Trade.OC := 'O';
      Trade.LS := 'S';
    end
    else if (UpperCase(Value) = 'BUY') then begin
      Trade.OC := 'O';
      Trade.LS := 'L';
    end
    else if (UpperCase(Value) = 'SELL') then begin
      Trade.OC := 'C';
      Trade.LS := 'L';
    end;
  finally
//rj     DetailLogger.ExitMethod(self, 'ConvertBuySell');
  end;
end;


procedure TTLImport.CancelCorrect(Value: String; var Trade : TTLTrade);
begin
//rj   DetailLogger.EnterMethod(self, 'CancelCorrect');
  Value := uppercase(trim(Value));
  try
    if (pos('CORRECT',Value)>0) or (pos('CANCEL',Value)>0) then begin
      Trade.OC := 'X';
    end;
  finally
//rj     DetailLogger.ExitMethod(self, 'CancelCorrect');
  end;
end;


constructor TTLImport.Create(const ImportFilter : TTLImportFilter; Proxy : Boolean);
begin
  FProxy := Proxy;
  FImportFilter := ImportFilter;
  FRawData := TList<String>.Create;
  FOFXResponses := TList<TOFXResponse>.Create;
end;


function TTLImport.GetErrorMessage: String;
begin
  Result := '';
  if FOFXResponses.Count > 0 then
    Result := Trim(FOFXResponses[0].Signon.SONRS.STATUS.MESSAGE);
end;


function TTLImport.GetErrorOccurred: Boolean;
begin
  Result := Length(FErrorText) > 0;
end;


procedure TTLImport.GetErrors;
var
  STMT : IXMLINVSTMTTRNRSType;
  STATUS : IXMLSTATUSType;
  I : Integer;
  StatusNode, Node : IXMLNode;
begin
//rj   Logger.EnterMethod('GetErrors');
  try
    FErrorText := '';
    if FOFXResponses.Count > 0 then begin
      if ContainsText(Trim(FOFXResponses[0].Signon.SONRS.STATUS.SEVERITY), 'ERROR')
      then begin
        FErrorText := Trim(FOFXResponses[0].Signon.SONRS.STATUS.MESSAGE);
        exit;
      end
      else begin
      // For some reason Schwab is not using the Investment Statement type correctly.
      // They are actually putting a status object in this type even though the OFX standard
      // defines no such child object for INVSTMTTRNRS - Dave
        STMT := FOFXResponses[0].InvStmt.INVSTMTTRNRS.Items[0] as IXMLINVSTMTTRNRSType;
        // If there happens to be a status node in the Invstmttrnrs object then check it for error.
        // Can't do this the correct way since this is a bastardization of the standard.
        // Schwab specifically does this.
        StatusNode := STMT.ChildNodes['STATUS'];
        if (StatusNode <> nil) then begin
          // Now look for a SEVERITY of ERROR and resulting MESSAGE Node
          Node := StatusNode.ChildNodes['SEVERITY'];
          if (Node <> nil) and ContainsText(Trim(Node.Text), 'ERROR') then begin
            Node := StatusNode.ChildNodes['MESSAGE'];
            if (Node <> nil) then FErrorText := Trim(Node.Text);
          end;
        end;
      end;
    end;
  finally
//rj     Logger.ExitMethod('GetErrors');
  end;
end;


function TTLImport.GetImportFilter: TTLImportFilter;
begin
  Result := FImportFilter;
end;


procedure TTLImport.GetOFXData(UserName, Passwd, AccountNumber : String;
  StartDate, EndDate: TDateTime;
  IncludePositions : Boolean = False;
  IncludeBalances : Boolean = False;
  IncludeOpenOrders : Boolean = False);
var
  Result, t : String;
  Data : AnsiString;
  Ex : Exception;
  NewEndDate : TDatetime;
  i : integer; // local loop
  // ------------------------
  procedure CheckUnsafePwdChars(sPwd : string);
  var
    j : integer;
    a : string;
  begin
    for j := 1 to length(sPwd) do begin
      if POS(sPwd[j], '@#$%&=+,;/?:|<>{}|\^~[]') > 0 then begin
        a := sPwd[j];
        if a = '&' then a := '&&';
        sm('WARNING: Your password contains the ( ' + a + ' ) character.' + CR
          + 'TradeLog may not be able to login to the broker''s website' + CR
          + 'with this character in the password.' + CR
          + CR
          + 'If you have problems, please change your password.' + CR
          + CR
          + 'Suggested password characters for automated login include:' + CR
          + CR
          + 'A-Z, a-z, 0-9, and _-!*(),`');
        break;
      end;
    end;
  end;
  // ------------------------
begin // GetOFXData
  try
    StartDate := DateOf(StartDate); // replaced Trunc(datetime)
    EndDate := DateOf(EndDate); // with DateOf(datetime) - 2015-04-01 MB
    FRawData.Clear;
    FOFXResponses.Clear;
    // 2018-09-19 MB - one week at a time logic:
    // ------------------------------------------------------------------------
    // Take the date range and break into Sun to Sat dates, then 7 day periods
    // thereafter. The most important thing is to import up to Saturday only
    // because TDA reports options as expired on Sunday (and drops key info).
    // Implement the same procedure for one-month imports, so that no matter
    // what the user chooses, behind the scenes we break into the week imports.
    // from Sep 18, 2018, 5:35 PM email from Jason Derbyshire, CC: Noreen
    // ------------------------------------------------------------------------
    for i := 1 to 7 do begin
      NewEndDate := StartDate + i;
      if DayOfTheWeek(NewEndDate) = 6 then break; // find Saturday
    end;
    // ----------------------
    // loop to get chunks
    // ----------------------
    repeat
      if (NewEndDate > EndDate) then // don't go past EndDate
        NewEndDate := EndDate;
      Data := CreateRequestString(UserName, Passwd, AccountNumber,
        StartDate, NewEndDate, IncludePositions, IncludeBalances, IncludeOpenOrders);
      // SaveData
      Result := OFXWinInetPost(FImportFilter.OFXURL, Data);
      // ---------- Trap errors due to bad password chars -------
      if (Result = '400 Bad Request') then begin
        CheckUnsafePwdChars(Passwd); // 2021-11-18 MB - moved to except block
        exit;
      end;
      // --------------------------------------------------------
      FRawData.Add(Data);
      if not StrUtils.StartsText('200', Result) then
        raise EOFXException.Create('Get OFX Data failed with http status code: ' + Result);
      Data := SGMLToXML(Data);
      // --------------------
      if (DEBUG_MODE > 8) and SuperUser then begin
        t := clipBoard.AsText;
        clipboard.astext := data;
        sm('To see import, paste XML' + CRLF //
          + 'data into notepad now');
        clipBoard.AsText := t;
      end;
      // --------------------
      ParseResponse(Data);
      // 2018-09-19 MB - one week at a time logic:
      // ALWAYS increment so we can exit the loop!
      StartDate := NewEndDate + 1; // start on next day; should be a Sunday
      NewEndDate := StartDate + 6 // should be a Saturday = one week chunk
    until (StartDate >= EndDate); // 2018-09-21 MB - changed loop test...
    // ...from NewEndDate to StartDate to get the last partial week at the end
    // ----------------------
    // end loop
    // ----------------------
    GetErrors;
  except
    CheckUnsafePwdChars(Passwd);
  end;
end;// GetOFXData


function TTLImport.GetOFXResponse(Idx: Integer): TOFXResponse;
begin
  if (Idx < 0) or (Idx > FOFXResponses.Count - 1) then
    raise EOFXException('Index Out Of Range' + IntToStr(Idx));
  Result := FOFXResponses[Idx]
end;


function TTLImport.GetOFXResponseCount: Integer;
begin
  Result := FOFXResponses.Count;
end;


function TTLImport.GetRawData(Idx : Integer): String;
begin
  Result := '';
  if (Idx < FRawData.Count) then Result := FRawData[Idx];
end;


function TTLImport.GetTradeList(Idx: Integer = -1): TTradeList;
var
  I, J, K: Integer;
  Item: IXMLINVSTMTTRNRSType;
  StockInfo: IXMLSTOCKINFOTYPE;
  MFInfo: IXMLMFINFOType;
  OptionInfo: IXMLOPTINFOType;
  BuyOpt: IXMLBUYOPTType;
  SellOpt: IXMLSELLOPTType;
  BuyStk: IXMLBUYSTOCKType;
  SellStk: IXMLSELLSTOCKType;
  BuyDebt: IXMLBUYDEBTType;
  SellDebt: IXMLSELLDEBTType;
  BuyMF: IXMLBUYMFType;
  SellMF: IXMLSELLMFType;
  ClosureOpt: IXMLCLOSUREOPTType;
  ClosureStk: IXMLNode;
  TransDict: TDictionary<String, IXMLNode>;
  TransList: TList<IXMLNode>;
  BuyOther: IXMLBUYOTHERType;
  SellOther: IXMLSELLOTHERType;
  TransNode: IXMLNode;
  Info: IXMLNode;
  Trade: TTLTrade;
  Done: Boolean;
  ID: String;
  MemoNode: IXMLNode;
  // ----------------------------------
  function GetFITID(Node: IXMLNode): String;
  var
    I: Integer;
  begin
    Result := '';
    for I := 0 to Node.ChildNodes.Count - 1 do begin
      if Length(Result) > 0 then exit(Result);
      if (Node.ChildNodes[I].NodeName = 'FITID') then
        exit(Trim(VarToStr(Node.ChildNodes[I].NodeValue)));
      Result := GetFITID(Node.ChildNodes[I]);
    end;
  end;
// ----------------------------------
begin
//rj   Logger.EnterMethod(self, 'GetTradeList');
  try
    if (Idx < -1) or (Idx > FOFXResponses.Count - 1) then
      raise EOFXException.Create('GetTradeList: Index Out of Bounds: ' +IntToStr(Idx));
    if (Idx = -1) then begin
      // Process all Responses and return on big TradeList
      Done := false;
      Idx := 0;
    end
    // Just process the one response identified by the Idx parameter,
    else Done := True;
    // Set Done to true so repeat loop does not repeat.
    Result := TTradeList.Create;
    repeat
      // FInvStmt.INVSTMTTRNRS
      // This is a list but according to the data there is only one of these
      // We will loop through anyway just in case there ever is more than one.
      for I := 0 to FOFXResponses[Idx].InvStmt.INVSTMTTRNRS.Count - 1 do begin
        Item := FOFXResponses[Idx].InvStmt.INVSTMTTRNRS.Items[I];
        TransDict := TDictionary<String, IXMLNode>.Create;
        try
          TransList := TList<IXMLNode>.Create;
          try
            { If there are no items in the TranList then skip this one }
            if (Item.INVSTMTRS.INVTRANLIST.ChildNodes.Count = 0) then continue;
            // First thing: create a list that is keyed by TransID, and also
            // in FIFO order, so that we create records into our TTradeList,
            // in the correct order.
            if FImportFilter.OFXDescOrder then
              J := Item.INVSTMTRS.INVTRANLIST.ChildNodes.Count - 1
            else
              J := 0;
            repeat
              // Even though InvTranList is a list, there are also some
              // individual node values that are not list items, but rather
              // identifiers for the list such as Start Date and End Date.
              // We do not want to process these items as if they were list
              // items so just skip them.
              if (Item.INVSTMTRS.INVTRANLIST.ChildNodes[J].NodeName <> 'DTSTART')
              and (Item.INVSTMTRS.INVTRANLIST.ChildNodes[J].NodeName <> 'DTEND')
              then begin
                ID := GetFITID(Item.INVSTMTRS.INVTRANLIST.ChildNodes[J]);
                TransDict.Add(ID, Item.INVSTMTRS.INVTRANLIST.ChildNodes[J]);
                TransList.Add(Item.INVSTMTRS.INVTRANLIST.ChildNodes[J]);
              end;
              if FImportFilter.OFXDescOrder then
                Dec(J)
              else
                Inc(J);
            until (J < 0) or (J = Item.INVSTMTRS.INVTRANLIST.ChildNodes.Count);
            // ----------------------------------
            for TransNode in TransList do begin
              // This is the Transaction List, but since transactions are
              // classed into their types here we cannot loop through as Items
              // list as we might suspect, So we'll use the generic ChildNodes
              // feature to loop and each Child Node.
              // ChildNode.NodeName will tell us what type of transaction it is.
              // Current Types Coded For: BUYOPT, SELLOPT, BUYSTOCK, SELLSTOCK,
              // BUYMF, SELLMF, BUYOTHER, SELLOTHER
              Trade := nil;
              if TransNode.NodeName = 'BUYOPT' then begin
                BuyOpt := TransNode as IXMLBUYOPTType;
                Info := FindInfo(Idx, BuyOpt.InvBuy.SECID.UniqueID);
                if not Supports(Info, IXMLOPTINFOType, OptionInfo) then continue;
                Trade := ProcessBuyOpt(BuyOpt, OptionInfo);
              end
              else if TransNode.NodeName = 'SELLOPT' then begin
                SellOpt := TransNode as IXMLSELLOPTType;
                Info := FindInfo(Idx, SellOpt.InvSell.SECID.UniqueID);
                if not Supports(Info, IXMLOPTINFOType, OptionInfo) then continue;
                Trade := ProcessSellOpt(SellOpt, OptionInfo);
              end
              else if TransNode.NodeName = 'BUYSTOCK' then begin
                BuyStk := TransNode as IXMLBUYSTOCKType;
                Info := FindInfo(Idx, BuyStk.InvBuy.SECID.UniqueID);
                // For now just pass generic Info record to ProcessBuyStock
                // But leave this old code as I have a feeling we might have
                // to revert back at a future time. }
                // if not Supports(Info, IXMLSTOCKINFOType, StockInfo) then Continue;
                Trade := ProcessBuyStock(BuyStk, Info { StockInfo } );
              end
              else if TransNode.NodeName = 'SELLSTOCK' then begin
                SellStk := TransNode as IXMLSELLSTOCKType;
                Info := FindInfo(Idx, SellStk.InvSell.SECID.UniqueID);
                // For now just pass generic Info record to ProcessBuyStock
                // But leave this old code as I have a feeling we might have
                // to revert back at a future time. }
                // if not supports(Info, IXMLSTOCKINFOType, StockInfo) then Continue;
                Trade := ProcessSellStock(SellStk, Info);
                if Trade = nil then continue;
              end
              else if TransNode.NodeName = 'BUYDEBT' then begin
                BuyDebt := TransNode as IXMLBUYDEBTType;
                Info := FindInfo(Idx, BuyDebt.InvBuy.SECID.UniqueID);
                Trade := ProcessBuyDebt(BuyDebt, Info);
              end
              else if TransNode.NodeName = 'SELLDEBT' then begin
                SellDebt := TransNode as IXMLSELLDEBTType;
                Info := FindInfo(Idx, SellDebt.InvSell.SECID.UniqueID);
                Trade := ProcessSellDebt(SellDebt, Info);
                if Trade = nil then continue;
              end
              else if TransNode.NodeName = 'BUYMF' then begin
                BuyMF := TransNode as IXMLBUYMFType;
                Info := FindInfo(Idx, BuyMF.InvBuy.SECID.UniqueID);
                if not Supports(Info, IXMLMFINFOType, MFInfo) then continue;
                Trade := ProcessBuyMF(BuyMF, MFInfo);
              end
              else if TransNode.NodeName = 'SELLMF' then begin
                SellMF := TransNode as IXMLSELLMFType;
                Info := FindInfo(Idx, SellMF.InvSell.SECID.UniqueID);
                if not Supports(Info, IXMLMFINFOType, MFInfo) then continue;
                Trade := ProcessSellMF(SellMF, MFInfo);
              end
              else if TransNode.NodeName = 'BUYOTHER' then begin
                BuyOther := TransNode as IXMLBUYOTHERType;
                Info := FindInfo(Idx, BuyOther.InvBuy.SECID.UniqueID);
                if (Info.NodeName = 'STOCKINFO') then
                  Trade := ProcessBuyOtherStock(BuyOther, Info as IXMLSTOCKINFOTYPE)
                else if (Info.NodeName = 'MFINFO') then
                  Trade := ProcessBuyOtherMF(BuyOther, Info as IXMLMFINFOType)
                else if (Info.NodeName = 'OPTINFO') then
                  Trade := ProcessBuyOtherOption(BuyOther, Info as IXMLOPTINFOType)
                else if (Info.NodeName = 'OTHERINFO') then
                  Trade := ProcessBuyOther(BuyOther, Info as IXMLOTHERINFOType);
              end
              else if TransNode.NodeName = 'SELLOTHER' then begin
                SellOther := TransNode as IXMLSELLOTHERType;
                Info := FindInfo(Idx, SellOther.InvSell.SECID.UniqueID);
                if (Info.NodeName = 'STOCKINFO') then
                  Trade := ProcessSellOtherStock(SellOther, Info as IXMLSTOCKINFOTYPE)
                else if (Info.NodeName = 'MFINFO') then
                  Trade := ProcessSellOtherMF(SellOther, Info as IXMLMFINFOType)
                else if (Info.NodeName = 'OPTINFO') then
                  Trade := ProcessSellOtherOption(SellOther, Info as IXMLOPTINFOType)
                else if (Info.NodeName = 'OTHERINFO') then
                  Trade := ProcessSellOther(SellOther, Info as IXMLOTHERINFOType);
              end;
              // ---------------------------
              if (Trade <> nil) then begin
                // If the transaction already exists in the list then skip it.
                // Sometimes a broker will not strictly abide by the Begin/End
                // Date, so if there is more than one batch of transactions
                // being processed, it's possible that a transaction might show
                // up twice in 2 batches. This means we need to skip a TransID
                // if it is already in the list and was added by another batch.
                for K := 0 to Result.Count - 1 do begin
                  if (Result[K].OFXTransID = Trade.OFXTransID) then begin
                    FreeAndNil(Trade);
                    continue;
                  end;
                end;
                // Finally if we got here then we have a new Valid
                // transaction so add it to the list.
                Result.Add(Trade);
              end;
            end;
          finally
            TransList.Free;
          end;
        finally
          TransDict.Free;
        end;
      end;
      Inc(Idx);
      if not Done then Done := (Idx = FOFXResponses.Count);
    until Done;
    if FImportFilter.FixShortsOOOrder then FixShortsOOOrder(Result);
  finally
//rj     Logger.ExitMethod(self, 'GetTradeList');
  end;
end;


function TTLImport.IsCancelCorrectTrade(Value: String) : Boolean;
begin
  {To activate this functionality remove this Exit Line}
  Exit(False);
  {End of Remove Exit Line.}
//rj   DetailLogger.EnterMethod(self, 'IsCancelCorrectTrade');
  try
    Result := False;
    Value := uppercase(trim(Value));
    if (pos('CORRECT',Value)>0) or (pos('CANCEL',Value)>0) then
      Exit(True);
  finally
//rj     DetailLogger.ExitMethod(self, 'CancelCorrect');
  end;
end;


procedure TTLImport.LoadFromFile(FileName: String);
var
  SL : TStringList;
  S : String;
begin
  SL := TStringList.Create;
  try
    SL.LoadFromFile(FileName);
    S := SL.Text;
    FRawData.Add(S);
    S := SGMLToXML(S);
    ParseResponse(S);
  finally
    SL.Free;
  end;
end;


function TTLImport.OFXWinInetPost(URL : String; var Data : AnsiString): String;
var
  Header : TStringStream;
  TZ : TTimeZone;
begin
//rj   Logger.EnterMethod(self, 'OFXWinInetPost');
  try
    Header := TStringStream.Create('');
    try
      TZ := TTimeZone.Local;
      with Header do begin
        WriteString('User-Agent: ' + USER_AGENT + SLineBreak);
        WriteString('Accept: ' + ACCEPT +SLineBreak);
        WriteString('Accept-Encoding: identity' + sLineBreak);
        WriteString('Content-Length: ' + IntToStr(Length(Data)) + sLineBreak);
        WriteString('Content-Type: ' + CONTENT_TYPE + sLineBreak);
        WriteString('Date: ' + FormatDateTime('ddd, dd mmm yyyy hh:nn:ss "' + TZ.Abbreviation + '"', Now) + sLineBreak);
        WriteString('Cookie: ' + sLineBreak);
        WriteString('Connection: ' + KEEP_ALIVE + SlineBreak);
      end;
      Result := sslInet(URL , Header, Data);
    finally
      Header.Free;
    end;
  finally
//rj     Logger.ExitMethod(self, 'OFXWinInetPost');
  end;
end;


procedure TTLImport.SaveToFile(FileName: String);
var
  I : Integer;
  Ext : String;
  Path : String;
  XMLDoc : IXMLdocument;
begin
  try
    XMLDoc := TXMLDocument.Create(nil);
    XMLDoc.Options := XMLDoc.Options + [doNodeAutoIndent];
    try
      if FRawData.Count = 1 then begin
        XMLDoc.LoadFromXML(FormatXMLData(SGMLToXML(Copy(FRawData[0], Pos('<OFX>', FRawData[0])))));
        XMLDoc.SaveToFile(FileName);
        exit;
      end;
      {Process Extension}
      Ext := ExtractFileExt(FileName);
      if (Length(Trim(Ext)) = 0) then Ext := '.ofx';
      if (LeftStr(Ext, 1) <> '.') then Ext := ',' + Ext;
      {Process Path}
      Path := ExtractFilePath(FileName);
      if (Length(Trim(Path)) = 0) then Path := Settings.ImportDir;
      if RightStr(Path, 1) <> '\' then Path := Path + '\';
      {GetFileName}
      FileName := ExtractFileName(FileName);
      FileName := LeftStr(FileName, Length(FileName) - Length(Ext));
      for I := 0 to FRawData.Count - 1 do begin
        XMLDoc.LoadFromXML(SGMLToXML(Copy(FRawData[I], Pos('<OFX>', FRawData[I]))));
        XMLDoc.SaveToFile(Path + FileName + '-(' + IntToStr(I + 1) + ')' + Ext);
      end;
    finally
      XMLDoc := nil;
    end;
  finally
    // SaveToFile
  end;
end; // SaveToFile


procedure TTLImport.SetImportFilter(const Value: TTLImportFilter);
begin
  FImportFilter := Value;
  FRawData.Clear;
  FOFXResponses.Clear;
end;


procedure TTLImport.SetProxy(const Value: Boolean);
begin
  FProxy := Value;
end;


function TTLImport.SGMLToXML(Value: String): String;
var
  LeftIdx : Integer;
  RightIdx : Integer;
  FirstTag,
  CloseTag,
  NextTag : String;
  Data : String;
begin
//rj   Logger.EnterMethod(self, 'SGMLToXML');
  try
    LeftIdx := 0;
    RightIdx := 0;
    FirstTag := '';
    CloseTag := '';
    NextTag := '';
    Result := Value;
    Data := '';
    repeat
      LeftIdx := PosEx('<', Result, LeftIdx + 1);
      RightIdx := PosEx('>', Result, RightIdx + 1);
      if (LeftIdx > 0) and (RightIdx > 0) then begin
        FirstTag := Copy(Result, LeftIdx, RightIdx - LeftIdx + 1);
        LeftIdx := PosEx('<', Result, RightIdx + 1);
        Data := Trim(Copy(Result, RightIdx + 1, LeftIdx - RightIdx - 1));
        if (Data = '<') or (Data = CRLF) then Data := '';
        RightIdx := PosEx('>', Result, RightIdx + 1);
        NextTag := Copy(Result, LeftIdx, RightIdx - LeftIdx + 1);
        // Should be an opening and then a closing tag.,
        // Also if NextTag is closing then it must match opening tag
        if (Length(Data) > 0) and (FirstTag[2] <> '/') then begin
          CloseTag := FirstTag;
          Insert('/', CloseTag, 2); //Make the First Tag a closing Tag
          {If the Closing tag already exists then skip this one}
          if (NextTag = CloseTag) then Continue;
          Insert(CloseTag, Result, LeftIdx); //Insert it just before the Left index of the next tag
          {Reset the Indexes so they take into account the new tag just inserted}
          LeftIdx := (LeftIdx - 1) + Length(CloseTag);
          RightIdx := (RightIdx - 1) + Length(CloseTag);
        end
        else begin
          //We hit an end tag, Reset these so that they start from one past the end tag.
          Dec(LeftIdx);
          RightIdx := LeftIdx;
        end;
      end;
    until LeftIdx = 0;
  finally
//rj     Logger.ExitMethod(self, 'SGMLToXML');
  end;
end;


procedure TTLImport.ProcessTrans(Tran: IXMLINVTRANType;
  var Trade: TTLTrade);
var
  Time : String;
  Y, M, D : Word;
  H, N, S : Word;
begin
//rj   DetailLogger.EnterMethod('ProcessTrans');
  try
    {Get the Date}
    Y := StrToInt(Copy(Tran.DTTRADE, 1, 4));
    M := StrToInt(Copy(Tran.DTTRADE, 5, 2));
    D := StrToInt(Copy(Tran.DTTRADE, 7, 2));
    Trade.Date := EncodeDate(Y, M, D);
    { Get the time from the Date and if BrokerHasTimeOfDay is true then
      assume it is a valid time and put it into the Trade Record }
    if FImportFilter.BrokerHasTimeOfDay then begin
      Time := Trim(Copy(Tran.DTTRADE, 9));
      if (Pos('.', Time) > 0) then Time := LeftStr(Time, Pos('.', Time) - 1);
      Trade.Time := Copy(Time, 1, 2) + ':' + Copy(Time, 3, 2) + ':' + Copy(Time, 5, 2)
    end
    else
      Trade.Time := '';
    Trade.OFXTransID := Trim(Tran.FITID);
  finally
//rj     DetailLogger.ExitMethod('ProcessTrans');
  end;
end;


{ TOFXResponse }

constructor TOFXResponse.Create;
begin
  InvStmt := nil;
  SecList := nil;
  Signon := nil;
end;

destructor TOFXResponse.Destroy;
begin
  InvStmt := nil;
  SecList := nil;
  Signon := nil;
  inherited;
end;

{ TAmeritradeImport }

{TDAmeritrade does some funny stuff, The can have two formats for their option Ticker and the
  Expire Date, OptionType and the StrikePrice in the Option Ticker does not necessarily
  match the Fields in the balance of the Security definition as defined by the OFX Standard.
  Therefore we will only depend on the Ticker and not on the field for TDAmeritrade.

  Format 1) AAPL_130201P45
            Tckr Exp   T Strike

  After Ticker there is underscore, 6 didig date in mmddyy, then a letter, P or C, then
  finally the Strike Price

  Format 2) AAPL Feb 01 2012 49 Put
            Tckr Expire      Strike Type

  Ticker followed by a space and the short date month, Day, Year with spaces between, Strike, and
  the word Call or Put
}


function TTDAmeritradeImport.IsCancelCorrectTrade(Value: String) : Boolean;
begin
  {To activate this functionality remove this Exit Line}
  //Exit(False);
  {End of Remove Exit Line.}
//rj   DetailLogger.EnterMethod(self, 'IsCancelCorrectTrade');
  try
    Result := False;
    Value := uppercase(trim(Value));
    if (pos('CORRECT',Value)>0) or (pos('CANCEL',Value)>0) then
      Exit(True);
  finally
//rj     DetailLogger.ExitMethod(self, 'CancelCorrect');
  end;
end;


function TTDAmeritradeImport.ParseExpireDate(ExpireDt: String; var Ticker: String): String;
var
  DT,M,D,Y,tick : String;
  Mon : Word;
  i, j : integer;
begin
  {Use Ticker since ExpireDt field is not dependable for TDAmeritrade}
//rj   DetailLogger.EnterMethod(self, 'ParseExpireDate');
  try
    tick := ticker;
    //test for paranthesis ie: GOOG (Weekly) Jun 28 2013 870 Put}
    // 2017-05-15 MB - Starting April 2017: <SECNAME>CTRP May 26 2017 52 Put (Weekly)</SECNAME>
    i := pos(')',tick);
    j := length(tick);
    if (i > 0) then begin
      if (i < j) then begin
        delete(tick, 1, pos(')',tick));
      end
      else begin
        i := pos('(', tick);
        delete(tick, i, j-i+1);
      end;
    end;
    tick := trim(tick);
    //Format 1
    if (tick[1] = '_') and IsInt(Copy(tick, 2, 6)) then begin
      Mon := StrToInt(Copy(tick, 2, 2));
      Result := Copy(tick, 4, 2) + UpperCase(Settings.InternalFmt.ShortMonthNames[Mon]) + Copy(tick, 6, 2);
    end
    else if StrUtils.MatchText(Copy(tick, 1, 3), Settings.InternalFmt.ShortMonthNames)
    then begin {Format 2  ie: GOOG (Weekly) Jun 28 2013 870 Put}
      //cannot always rely on mon, day, year being in definite positions
      //Result := copy(tick, 5, 2) + UpperCase(Copy(tick, 1, 3)) + Copy(tick, 10, 2);
      Y := parseLast(tick,' '); //remove Call/Put
      Y := parseLast(tick,' '); //remove Strike
      Y := rightStr(parseLast(tick,' '),2);
      D := parseLast(tick,' ');
      if (length(D)=1) then D := '0' + D;
      M := upperCase(leftStr(tick,3));
      result := D + M + Y;
    end
    else
      {If we got here then we don't know what format this is so just try and use the
       field from the OFX record standard ParseExpireDate}
      Result := inherited ParseExpireDate(ExpireDt, Ticker);
  finally
//rj     DetailLogger.ExitMethod(self, 'ParseExpireDate');
  end;
end;


function TTDAmeritradeImport.ParseStrikePrice(Strike: String;
  var Ticker: String; ID: String): String;
var
  Price : String;
begin
  {Use Ticker since Strike Price field is not dependable for TDAmeritrade}
//rj   DetailLogger.EnterMethod(self, 'ParseStrikePrice');
  try
    if (Length(Ticker) > 8) and (Ticker[1] = '_') and (Ticker[8] in ['C', 'P'])
    then begin
      // Format 1
      // ticker = _072013C825
      // uniqueid = 0LULU.GK30082500
      // correct strike = 85
      Price := rightStr(ID,7);
      Insert('.',Price,5);
      //Price := copy(Ticker, 9);
    end
    else if (Length(Ticker) > 10)
    and (StrUtils.MatchText(Copy(Ticker, 1, 3), Settings.InternalFmt.ShortMonthNames))
    then begin {Format 2}
      Price := Ticker;
      ParseLast(Price, ' '); //Strip of Call Put
      Price := ParseLast(Price, ' '); //Should be Strike
    end;
    Price := TrimTrailingZeros(Price);
    {Let's get the strike price off of what is left of the original ticker value}
    Price := TrimLeadingZeros(Trim(Price));
    if IsFloat(Price) then
      Result := Price
    else begin
      {If the Strike Price is not on the Ticker as expected, then
      Fall Back to the Standard Logic for getting Strike Price
      From strike Price Field}
      Result := Inherited ParseStrikePrice(Strike, Ticker, ID);
    end;
  finally
//rj     DetailLogger.ExitMethod(self, 'ParseStrikePrice');
  end;
end;


procedure TTDAmeritradeImport.ProcessOptionInfo(OptionInfo: IXMLOPTINFOType;
  var Result: TTLTrade; useSecName: Boolean);
begin
  //Force use of SecName for Ameritrade
  inherited ProcessOptionInfo(OptionInfo, Result, True);
end;

function TTDAmeritradeImport.ParseCallPut(CallPut: String; var Ticker: String): String;
var
  tick : string;
begin
//rj   DetailLogger.EnterMethod(self, 'ParseCallPut');
  try
    tick := trim(uppercase(ticker));
    //added 2013-08-06 for ticker with extra number at end - ie: MDLZ1_102012P40
    // ------------------------------------------
    // NOTE: this is a hidden function!
    if isInt(Ticker[1]) then delete(Ticker,1,1);
    // ------------------------------------------
    // Use Ticker since OpType field is not dependable for TDAmeritrade
    if (Length(Ticker) > 8) and (Ticker[1] = '_') and (Ticker[8] in ['C', 'P'])
    then begin // Format 1: _122113P925
      if (Ticker[8] = 'C') then
        Result := 'CALL'
      else
        Result := 'PUT';
    end
    else if (pos('0', tick) = 1) //
    and (pos('.', Ticker) > 0) then begin // TDA Expired Options Format '0TLA..junk'
      tick := copy(Ticker,1,pos('.', Ticker)-1); // everything before the '..' // 2018-09-11 MB
      Result := 'EXPIRED OPT ' + tick;
    end
    else begin // Format 2: MCD Sep 21 2013 95 Put
      if pos(' ', tick) > 0 then begin
        tick:= parseLast(tick,' '); // everything after the last space
        if (tick[1] = 'P') then
          Result := 'PUT'
        else if (tick[1] = 'C') then
          Result := 'CALL'
      end
      else // If all else fails fall back to default implementation
        Result := Inherited ParseCallPut(CallPut, tick);
    end;
  finally
//rj     DetailLogger.ExitMethod(self, 'ParseCallPut');
  end;
end;


{ TFidelityImport }

{Fidelity does not put the expire date in the ExpireDt field, Rather we need
  to get it from the Ticker field. Since the ticker has already been stripped off
  of the Ticker parameter by the GetOptionTicker method we can start from the beginning
  of the string. The format is YYMMDD}
function TFidelityImport.ParseExpireDate(ExpireDt: String;
  var Ticker: String): String;
var
  M : Word;
begin
//rj   DetailLogger.EnterMethod(self, 'ParseExpireDate');
  try
    if (Length(Ticker) > 5) then begin
      { Assume if this is an integer and position 3,2 is a valid Month
       then it is the date. yymmddmm format }
      if IsInt(Copy(Ticker, 1, 6)) and (StrToInt(Copy(Ticker, 3, 2)) in [1..12])
      then begin
        M := StrToInt(Copy(Ticker, 3, 2));
        Result := Copy(Ticker, 5, 2) + UpperCase(Settings.InternalFmt.ShortMonthNames[M]) + Copy(Ticker, 1, 2);
        {Remove the Date from the Ticker so the next routine does not have to worry about it}
        if Length(Ticker) > 6 then
          Ticker := Copy(Ticker, 7)
        else
          Ticker := '';
      end
      else
        { Fall back to the default implementation if for some reason the ticker
          does not have the expiration Date}
        { Todd Do Not Fall Back as Per Dave for Junk Data 06/22/2013}
//        Result := Inherited ParseExpireDate(ExpireDt, Ticker);
      Result := '';
    end;
  finally
//rj     DetailLogger.ExitMethod(self, 'ParseExpireDate');
  end;
end;


{ Fidelity does not use Strike Price field correctly so get it from the
  Ticker as Well, When we get here the default implementation will have
  stripped off all other fields so the Ticker field at this point
  should only contain the strike price. }
function TFidelityImport.ParseStrikePrice(Strike: String;
  var Ticker: String; ID : String): String;
var
  Price : String;
begin
//rj   DetailLogger.EnterMethod(self, 'ParseStrikePrice');
  try
    {Let's get the strike price off of what is left of the original ticker value}
    Price := TrimLeadingZeros(Trim(Ticker));
    Ticker := '';
    if IsFloat(Price) then begin
      if RndTo5(StrToFloat(Price)) <> 0 then
        Result := Price
      else
        Result := '';
    end
    else begin
      {If the Strike Price is not on the Ticker as expected, then
      at least try and get it from the Strike field
      Must be Floating Point value assume it is correct}
      Result := Inherited ParseStrikePrice(Strike, Ticker, ID);
    end;
  finally
//rj     DetailLogger.ExitMethod(self, 'ParseStrikePrice');
  end;
end;


{ Fidelity is not consistent with the CallPut Field, so
  we will use the Ticker first then if that does not contain
  a valid call put we will fall back on the Field.}
function TFidelityImport.ParseCallPut(CallPut: String; var Ticker: String): String;
begin
  try
     {Use Ticker since OpType field is not dependable for TDAmeritrade}
    if (Length(Ticker) > 1) and CharInSet(Ticker[1], ['C', 'P']) then begin
      if (Ticker[1] = 'C') then
        Result := 'CALL'
      else
        Result := 'PUT';
      Ticker := copy(Ticker, 2);
    end
    else
      {If all else fails fall back to default implementation}
      Result := Inherited ParseCallPut(CallPut, Ticker);
  finally
    //
  end;
end;


procedure TVanguardImport.ProcessOptionInfo(OptionInfo: IXMLOPTINFOType;
  var Result: TTLTrade; useSecName : Boolean = false);
var
  Value : String;
begin
//rj   DetailLogger.EnterMethod(self, 'ProcessOptionInfo');
  try
    {Pass the value of the original ticker into each of the parse methods
      so that if for some reason the broker is not using the fields of the Security Info
      record correctly we can still try and parse the data off of the Ticker}
    Value := Trim(OptionInfo.SECINFO.SECNAME);
    //Before changing the Value put the entire thing in OptionTicker.
    Result.OptionTicker := Value;
    // delete CALL/PUT text
    delete(value,1, pos(' ',Value));
    // get ticker
    result.ticker := copy(value,1,pos(' $',value)-1);
    // get strike
    delete(value,1, pos('$',Value)+1);
    OptionInfo.STRIKEPRICE := value;
  finally
//rj     DetailLogger.ExitMethod(self, 'ProcessOptionInfo');
  end;
end;


{ TIBImport }

function TIBImport.ParseOptionTicker(var Ticker: String): String;
var
  I : Integer;
begin
//rj   DetailLogger.EnterMethod(self, 'ParseOptionTicker(' + Ticker + ')');
  try
    Ticker := UpperCase(Trim(Ticker));
    Result := '';
    {First get the characters which constitute the ticker}
    for I := 1 to Length(Ticker) do begin
      {Get all characters on front of string}
      if Ticker[I] in ['A'..'Z'] then Result := Result + Ticker[I]
      {If we get to a space and the Characters so far are just P or C, then
        ignore this first character and continue with a clean result}
      else if (Length(Result) > 0) and (Ticker[I] = ' ')
      and ((Result =  'C') or (Result = 'P')) then
        Result := ''
      else
        break;
    end;
    {Now remove the ticker and if the balance of the string
     contains additional data return it to be processed}
    if I < Length(Ticker) then
      Ticker := Trim(Copy(Ticker, I))
    else
      Ticker := '';
  finally
//rj     DetailLogger.ExitMethod(self, 'ParseOptionTicker');
  end;
end;


function TIBImport.ParseStrikePrice(Strike: String; var Ticker: String; ID : String): String;
var
  S : String;
begin
//rj   DetailLogger.EnterMethod('ParseStrikePrice');
  try
    S := Trim(Ticker);
    Strike := Trim(Strike);
    {Get the Strike Price off of the ticker}
    S := ParseLast(S, ' ');
    {If they are the same length and the right side of the Strike price is 00 cents
      then strip it off.}
    if (Length(S) = Length(Strike)) and (RightStr(Strike, 2) = '00') then
      Strike := LeftStr(Strike, Length(Strike) - 2);
    {Now call the Default implementation to strip off leading zeros and decimal points etc.}
    Result := inherited ParseStrikePrice(Strike, Ticker, ID);
  finally
//rj     DetailLogger.ExitMethod('ParseStrikePrice');
  end;
end;


procedure TIBImport.ProcessFIAssetClass(FIASSETCLASS : String;
  var Result: TTLTrade);
begin
  if (Trim(FIASSETCLASS) = 'FUTURES CONTRACT') then
    Result.TypeMult := 'FUT-1';
end;


procedure TIBImport.ProcessTrans(Tran: IXMLINVTRANType; var Trade: TTLTrade);
var
  S : String;
begin
  {First call the default implementation since this will get the time and Date}
  inherited;
  if (Length(Trim(Tran.MEMO)) > 0) and (Pos('FUTURE', Tran.Memo) > 0) then
    S := Trim(Copy(Tran.MEMO, Pos('PR:', Tran.MEMO) + 3));
  if IsFloat(TrimLeadingZeros(S)) then
    Trade.Price :=  RndTo6(StrToFloat(TrimLeadingZeros(S)));
end;


initialization
//rj   Logger := TCodeSiteLogger.Create(nil);
//rj   Logger.Category := CODE_SITE_CATEGORY;
//rj   TLLoggers.RegisterLogger(CODE_SITE_CATEGORY, Logger, True);
//rj   DetailLogger := TCodeSiteLogger.Create(nil);
//rj   DetailLogger.Category := CODE_SITE_DETAIL_CATEGORY;
//rj   TLLoggers.RegisterLogger(CODE_SITE_DETAIL_CATEGORY, DetailLogger);

end.
