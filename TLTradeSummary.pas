unit TLTradeSummary;

interface

uses Classes, SysUtils, StrUtils, Generics.Collections, Generics.Defaults, TLCommonLib;

type
  TWashSaleType =  (wsNone, // No wash sale deferral involve
                    wsPrvYr, // Wash sale deferral carried from a Previous Year
                    wsThisYr, // Wash sale deferral within current year
                    wsCstAdjd, // Cost basis adjusted due to wash sale deferral
                    wsTXF); // Wash Sale for TXF Report

  TTLTradeSummary = class(TPersistent)
  private
    FOpenAmount: Double;
    FTradeNum: Integer;
    FClosedShares: Double;
    FPrice: Double;
    FOpenedShares: Double;
    FWashSaleType: TWashSaleType;
    FTicker: String;
    FOpenDate: TDate;
    FMatched: String;
    FCommission: Double;
    FWashShareSales: Double;
    FWSTriggerID: Integer;
    FBrokerID: Integer;
    FCloseAmount: Double;
    FUniqueID: Integer;
    FCloseDate: TDate;
    FActualPL: Double;
    FTypeMult: String;
    FLS: Char;
    FWashSaleHoldingDate: TDateTime;
    FAccountType: TTLAccountType;
    FABCCode: String;
    FNextYear: Boolean;
    FLT: Char;
    FCode: Char;
    FAdjustmentG: double;
    FOpen: integer;
    FOpenID: Integer;
    FCloseID: Integer;
    function GetProfitLoss: Double;
    function GetMultiplier: Double;
    function GetTickerForSort: String;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    constructor Create; overload;
    constructor Create(TradeSummary : TTLTradeSummary); overload;
    property TradeNum : Integer read FTradeNum write FTradeNum; // Trade Number
    property Ticker : String read FTicker write FTicker;
    property TickerForSort : String read GetTickerForSort;
    property LS : Char Read FLS write FLS;
    property TypeMult : String read FTypeMult write FTypeMult;
    property Commission : Double read FCommission write FCommission;
    // --------------------------------
    // Open Date - Corresponds to Date Acquired when Long Term (LS = L),
    // Corresponds to Date Sold when Short Term (LS = S)
    property OpenDate : TDate read FOpenDate write FOpenDate;
    // Close Date - Corresponds to Date Sold when Long Term (LS = L),
    // Corresponds to Date Aqcuired when Short Term (LS = S)
    property CloseDate : TDate read FCloseDate write FCloseDate;
    // --------------------------------
    property WashSaleHoldingDate : TDateTime read FWashSaleHoldingDate write FWashSaleHoldingDate;
    property OpenedShares : Double read FOpenedShares write FOpenedShares;
    property ClosedShares : Double read FClosedShares write FClosedShares;
    property OpenAmount : Double read FOpenAmount write FOpenAmount;
    property CloseAmount : Double read FCloseAmount write FCloseAmount;
    property WashSaleShares : Double read FWashShareSales write FWashShareSales;
    property WashSaleType : TWashSaleType read FWashSaleType write FWashSaleType;
    property Price : Double read FPrice write FPrice;
    property ProfitLoss : Double read GetProfitLoss;
    property ActualPL : Double read FActualPL write FActualPL;
    // Gain/Loss Tax Term: L(ong 365 days+) or S(hort)
    property LT : Char read FLT write FLT;
    property NextYear : Boolean read FNextYear write FNextYear; // Defer to Next Year
    property Matched : String read FMatched write FMatched;
    property BrokerID : Integer read FBrokerID write FBrokerID;
    property Open : integer read FOpen write FOpen;
    // added for Form 8949
    property ABCCode: String read FABCCode write FABCCode;
    property Code: Char read FCode write FCode;
    property AdjustmentG : double read FAdjustmentG write FAdjustmentG;
    // --------------------------------
    // These two values are used to link Trigger trades to loss trades
    // so that we can do line numbers on the reports
    // to show how Wash Sales are being calculated
    // --------------------------------
    // A Unique Number for each TradeSum record in a list
    property UniqueId: Integer read FUniqueID write FUniqueID;
    // The Unique ID from the TradeSum record that triggered a wash sale.
    property WSTriggerid : Integer read FWSTriggerID write FWSTriggerID;
    // --------------------------------
    // This value is used to link a close record to the associated TrSum, Used by the
    // Copy ShortLossTrades to next year routine to link records properly
    property OpenID : Integer read FOpenID write FOpenID; //The open Record Item/ID number that is attached to this TrSum record
    property CloseID : Integer read FCloseID write FCloseID; //The Close Record Item/ID number that is attached to this TrSum record
    // --------------------------------
    property AccountType : TTLAccountType read FAccountType write FAccountType;
    property Multiplier : Double read GetMultiplier;
  end;

  TTradeSummaryComparer = TComparer<TTLTradeSummary>;

  TTLTradeSummaryList = class(TObjectList<TTLTradeSummary>)
  private
    function CompareOpenDates(const Item1, Item2: TTLTradeSummary): Integer;
    function CompareCloseDates(const Item1, Item2: TTLTradeSummary): Integer;
    function CompareTradeNum(const Item1, Item2: TTLTradeSummary): Integer;
    function CompareStockOption(const Item1, Item2 : TTLTradeSummary) : Integer;
    function CompareTickers(const Item1, Item2 : TTLTradeSummary) : Integer;
    function CompareLSDescending(const Item1, Item2 : TTLTradeSummary) : Integer;
    function CompareBroker(const Item1, Item2 : TTLTradeSummary) : Integer;
    function CompareAccountType(const Item1, Item2 : TTLTradeSummary) : Integer;
  public
    procedure SortByTicker_AcctType_StockOption_OpenDate;
  end;

implementation


{ TTLTradeSummary }


uses TLSettings;


procedure TTLTradeSummary.AssignTo(Dest: TPersistent);
var
  D : TTLTradeSummary;
begin
  D := TTLTradeSummary(Dest);
  D.FOpenAmount := FOpenAmount;
  D.FTradeNum := FTradeNum;
  D.FClosedShares := FClosedShares;
  D.FPrice := FPrice;
  D.FOpenedShares := FOpenedShares;
  D.FWashSaleType := D.FWashSaleType;
  D.FTicker := FTicker;
  D.FOpenDate := FOpenDate;
  D.FMatched := FMatched;
  D.FCommission := FCommission;
  D.FWashShareSales := FWashShareSales;
  D.FWSTriggerID := FWSTriggerID;
  D.FBrokerID := FBrokerID;
  D.FCloseAmount := FCloseAmount;
  D.FUniqueID := FUniqueID;
  D.FCloseDate := FCloseDate;
  D.FActualPL := FActualPL;
  D.FTypeMult := FTypeMult;
  D.FLS := FLS;
  D.FWashSaleHoldingDate := FWashSaleHoldingDate;
  D.FAccountType := FAccountType;
  D.FABCCode := FABCCode;
  D.FNextYear := FNextYear;
  D.FLT := FLT;
  D.FCode := FCode;
  D.FAdjustmentG := FAdjustmentG;
  D.FOpen := FOpen;
  D.FCloseID := FCloseID;
end;


constructor TTLTradeSummary.Create;
begin
    FOpenAmount := 0;
    FTradeNum := 0;
    FClosedShares := 0;
    FPrice := 0;
    FOpenedShares := 0;
    FWashSaleType := wsNone;
    FTicker := '';
    FOpenDate := 0;
    FMatched := '';
    FCommission := 0;
    FWashShareSales := 0;
    FWSTriggerID := 0;
    FBrokerID := 0;
    FCloseAmount := 0;
    FUniqueID := 0;
    FCloseDate := 0;
    FActualPL := 0;
    FTypeMult := '';
    FLS := ' ';
    FWashSaleHoldingDate := 0;
    FAccounttype := atCash;
end;


constructor TTLTradeSummary.Create(TradeSummary: TTLTradeSummary);
begin
  Assign(TradeSummary);
end;


function TTLTradeSummary.GetMultiplier: Double;
var
  S : String;
begin
  Result := 1;
  S := FTypeMult;
  delete(S,1,pos('-',S));
  if IsFloatEx(S,Settings.UserFmt) then
    Result := strToFloat(S, Settings.UserFmt)
end;


function TTLTradeSummary.GetProfitLoss: Double;
begin
  Result := OpenAmount + CloseAmount;
end;


function TTLTradeSummary.GetTickerForSort: String;
begin
  Result := formatTkSort(FTicker, FTypeMult, GetAccountTypeAsChar(AccountType));
end;


{ TTLTradeSummaryList }


function TTLTradeSummaryList.CompareAccountType(const Item1,
  Item2: TTLTradeSummary): Integer;
begin
  Result := 0;
  if Item1.AccountType < Item2.AccountType then
    Result := -1
  else if Item1.AccountType > Item2.AccountType then
    Result := 1;
end;


function TTLTradeSummaryList.CompareBroker(const Item1,
  Item2: TTLTradeSummary): Integer;
begin
  result := 0;
  if Item1.BrokerID < Item2.BrokerID then
    result := -1
  else if Item1.BrokerID > Item2.BrokerID then
    result := 1
end;


function TTLTradeSummaryList.CompareCloseDates(const Item1,
  Item2: TTLTradeSummary): Integer;
begin
  result := 0;
  if Item1.CloseDate < Item2.CloseDate then
    result := -1
  else if Item1.CloseDate > Item2.CloseDate then
    result := 1
end;


function TTLTradeSummaryList.CompareLSDescending(const Item1,
  Item2: TTLTradeSummary): Integer;
begin
  Result := 0;
  if Item1.LS < Item2.LS then
    Result := 1
  else if Item1.LS > Item2.LS then
    Result := -1
end;


function TTLTradeSummaryList.CompareOpenDates(const Item1,
  Item2: TTLTradeSummary): Integer;
begin
  result := 0;
  if Item1.OpenDate < Item2.OpenDate then
    result := -1
  else if Item1.OpenDate > Item2.OpenDate then
    result := 1

end;

function TTLTradeSummaryList.CompareStockOption(const Item1, Item2: TTLTradeSummary): Integer;
begin
  {Sort stocks before Options}
  Result := 0;
  if IsStockType(Item1.TypeMult) and IsOption(Item2.TypeMult, Item2.Ticker) then
    Result := -1
  else if IsOption(Item1.TypeMult, Item1.Ticker) and IsStockType(Item2.TypeMult) then
    Result := 1;
end;


function TTLTradeSummaryList.CompareTickers(const Item1,
  Item2: TTLTradeSummary): Integer;
begin
  Result := 0;
  if Item1.TickerForSort < Item2.TickerForSort then
    Result := -1
  else if Item1.TickerForSort > Item2.TickerForSort then
    Result := 1
end;


function TTLTradeSummaryList.CompareTradeNum(const Item1, Item2: TTLTradeSummary): Integer;
begin
  result := 0;
  if Item1.TradeNum < Item2.TradeNum then
    result := -1
  else if Item1.TradeNum > Item2.TradeNum then
    result := 1
end;


procedure TTLTradeSummaryList.SortByTicker_AcctType_StockOption_OpenDate;
begin
  Sort(TTradeSummaryComparer.Construct( function(const Item1, Item2: TTLTradeSummary): Integer
  begin
    result := CompareTickers(Item1, Item2);
    //Don't think we need this one since the TickerForSort has the acct type imbedded in it.
    if Result = 0  then Result := CompareAccountType(Item1, Item2);
    if result = 0 then result := CompareStockOption(Item1, Item2);
    if result = 0 then result := CompareOpenDates(Item1,Item2);
  end));

end;


end.
