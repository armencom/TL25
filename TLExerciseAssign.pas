unit TLExerciseAssign;

interface

uses SysUtils, StrUtils, TLFile, Generics.Collections, Generics.Defaults;

type
  EExerciseAssignException = class(Exception);

  TOption = class
  private
    FExpirationDate: TDateTime;
    FContracts: Double; // 2015-04-14 MB
    FOptionsOpened: Double;
    FStockTicker: String;
    FOptionType: Char;
    FTrDate: TDateTime;
    FTRNum: Integer;
    FExercised: Boolean;
    FStrikePrice: Double;
    FOpenClose: Char;
    FExpired: Boolean;
    FMultiplier: Double;
    FPrice: Double;
    FLongshort: Char;
    FMatchingStocks: TTradeList;
    FInvalidDate: Boolean;
    FOptionTicker: String;
    FTypeMult: String;
    FExpiredOptions: TTradeList;
    FOptions: TTradeList;
    FWashSales : TTradeList;
    FWashOptionMap : TObjectList<TList<Integer>>;
    FSomeOptionsClosed: Boolean;
    function GetMatchingStock: Boolean;
    function GetTotalMatchedShares: Double;
    function SetTotalMatchedShares(I:integer; sh:double) : double;
    function GetSharesToMatch: Double;
    function GetStock(Item: Integer): TTLTrade;
    function GetOption(Item: Integer): TTLTrade;
    function GetTotalExpiredContracts: Double;
  public
    constructor create(TradeRec: TTLTrade);
    destructor destroy; override;
    procedure IncContracts(Count: Double);
    procedure DecContracts(Count: Double);
    procedure MarkExpired;
    procedure AddStock(StockTrade: TTLTrade);
    procedure AddExpiredOption(ExpiredOption: TTLTrade); // 2015.04.14 MB
    procedure AddWashSales(WashSales : TTradeList);
    procedure AddOption(Option: TTLTrade);
    property TrNum: Integer read FTRNum;
    property BuyDate: TDateTime read FTrDate;
    property ExpirationDate: TDateTime read FExpirationDate;
    property InvalidDate: Boolean read FInvalidDate;
    property Expired: Boolean read FExpired;
    property StockTicker: String read FStockTicker;
    property OptionTicker: String read FOptionTicker;
    property OptionType: Char read FOptionType; // P or C
    property TypeMult: String read FTypeMult;
    property Contracts: Double read FContracts;
    property OptionsOpened: Double read FOptionsOpened write FOptionsOpened; // 2015-04-14 MB
    property Exercised: Boolean read FExercised;
    property StrikePrice: Double read FStrikePrice;
    property Price: Double read FPrice;
    property OpenClose: Char read FOpenClose;
    property LongShort: Char read FLongshort;
    // the multiplier for a contract, usually 100 but read from the prf/type value.
    property Multiplier: Double read FMultiplier;
    // Provided Matching Stock records as List.
    property MatchingStocks: TTradeList read FMatchingStocks;
    // Provides matching stocks as individual TTrade records.
    property Stock[Item: Integer]: TTLTrade read GetStock;
    //Returns Option by Item Number
	  property Option[Item: Integer]: TTLTrade read GetOption;
    // Total of shares for matched stock records.
    property TotalMatchedShares: Double read GetTotalMatchedShares;
    // Total Shares based on option contracts * Multiplier
    property SharesToMatch: Double read GetSharesToMatch;
    // Expired record List.
    property ExpiredOptions: TTradeList read FExpiredOptions;
    // Total count of contracts for expired options.
    property TotalExpiredContracts: Double read GetTotalExpiredContracts;
    // The underlying option records that make up this Option group.
    property Options: TTradeList read FOptions;
    //Wash Sales associated with the Option.
    property WashSales : TTradeList read FWashSales;

    property SomeOptionsClosed: Boolean read FSomeOptionsClosed;
  end;

  TOptionList = TObjectList<TOption>;
  TOptionComparer = TComparer<TOption>;

  TExerciseAssign = class
    FOptions: TOptionList;
    FFileToUse: TTLFile;
  private
    FFirstExerciseNum : Integer;
    FNextExerciseNum : Integer;
    function GetOption(Index: Integer): TOption;
    function GetCount: Integer;
    function ValidStockType(Value: String): Boolean;
    function ValidStockBuySell(CallOrPut, OptionLS, StockOC, StockLS: Char)
      : Boolean;
    procedure GetOpenOptions;
    procedure GetMatchingStocks;
    function GetAssignNum(exStr: string): Integer;
    function ParseStrike(tick: string): Double;
  published
  public
    constructor create; overload;
    constructor create(FileToUse: TTLFile); overload;
    destructor destroy; override;
    procedure RemoveOption(Index: Integer);
    procedure RemoveExpiredOptions(Index: Integer);
    procedure DiscoverUnexercisedOptions;
    function ExerciseAssign(Index: Integer): Integer; overload;
    function ExerciseAssign(Index: Integer; StockTrades, OptionTrades: TTradeList): Integer; overload;
    property Option[Index: Integer]: TOption read GetOption; default;
    property Count: Integer read GetCount;
    property FirstExerciseNum : Integer read FFirstExerciseNum;
  end;

implementation

uses Import, TLSettings, TLCommonLib,
//rj CodeSiteLogging,
TLLogging, funcProc;

const
  CODE_SITE_CATEGORY = 'TLExerciseAssign';
  CODE_SITE_DETAIL_CATEGORY = 'TLExerciseAssign-Detail';

//rj var
//rj   Logger : TCodeSiteLogger;
//rj   DetailLogger : TCodeSiteLogger;

{ TOption }

procedure TOption.AddExpiredOption(ExpiredOption: TTLTrade);
begin
  FExpiredOptions.Add(ExpiredOption);
end;

procedure TOption.AddOption(Option: TTLTrade);
begin
  FOptions.Add(Option);
end;

procedure TOption.AddStock(StockTrade: TTLTrade);
begin
  FMatchingStocks.Add(StockTrade);
end;

procedure TOption.AddWashSales(WashSales: TTradeList);
var
  WashSale : TTLTrade;
  Option : TTLTrade;
  AppliedShares : Double;
  I, J : Integer;
  WSIds : TList<Integer>;
begin
  J := 0;
  FWashSales.AddRange(WashSales);
  for I := 0 to FOptions.Count - 1 do
  begin
    WSIds := TList<Integer>.Create;
    FWashOptionMap.Add(WSIds);
    AppliedShares := 0;
    Option := FOptions[I];
    if Option.OC = 'C' then
      continue;
    while J <= FWashSales.Count - 1 do
    begin
      WashSale := FWashSales[J];
      if (WashSale.Shares <= Option.Shares - AppliedShares) and
         (WashSale.Date = Option.Date) then
      begin
        WSIds.Add(J);
        AppliedShares := AppliedShares + WashSale.Shares;
        Inc(J);
        {If we've applied all the shares then move on to the next option}
        if AppliedShares = Option.Shares then
          Break;
      end
      else
        Break;
    end;
  end;
end;

constructor TOption.create(TradeRec: TTLTrade);
var
  Ticker: String;
  Value: String;
  a, b: string;
begin
  //rj DetailLogger.EnterMethod(self, 'Create');
  try
    if Not IsOption(TradeRec.TypeMult, TradeRec.Ticker) then
      raise EExerciseAssignException.create(
        'Trade Record is not an Option. Type/Mult column must start with ''OPT'' or ''FUT'' and Ticker column must contain ''CALL'' or ''PUT''');
    FInvalidDate := False;
    FMatchingStocks := TTradeList.create;
    FExpiredOptions := TTradeList.create;
    FWashSales := TTradeList.Create;
    FOptions := TTradeList.create;
    FWashOptionMap := TObjectList<TList<Integer>>.Create(True);
    FOptionTicker := TradeRec.Ticker;
    FTypeMult := TradeRec.TypeMult;
    Ticker := FOptionTicker;
    FContracts := TradeRec.Shares;
    FOptionsOpened := TradeRec.Shares; // 2015-04-14 MB
    FTRNum := TradeRec.TradeNum;
    FTrDate := TradeRec.Date;
    FPrice := TradeRec.Price;
    FOpenClose := TradeRec.OC;
    FLongshort := TradeRec.LS;
    FMultiplier := StrToFloat(Copy(Trim(TradeRec.TypeMult), 5));
    Value := ParseLast(Ticker, ' ');
    FExercised := Trim(Value) = 'EXERCISED';
    FOptions.Add(TradeRec);
    FSomeOptionsClosed := False;
    // If Exercised was on the end then read the end again to get the Option Type.
    if FExercised then
      Value := ParseLast(Ticker, ' ');

    if Value = 'CALL' then
      FOptionType := 'C'
    else if Value = 'PUT' then
      FOptionType := 'P'
    else
      raise EExerciseAssignException.create(
        'Option Type is not correct, Must be ''Call'' or ''Put''');

    // Strike Price
    Value := ParseLast(Ticker, ' ');
    // test for fraction
    if Pos('/', Value) > 0 then
    begin
      b := ParseLast(Value, '/');
      a := Value;
      // get integer part of strike price
      Value := ParseLast(Ticker, ' ');
      FStrikePrice := StrToInt(Value) + StrToInt(a) / StrToInt(b);
    end
    else
      FStrikePrice := StrToFloat(Value, Settings.InternalFmt);

    FStockTicker := ParseFirst(Ticker, ' ');

    // Expiration Date.
    Value := ParseFirst(Ticker, ' '); // Expiration Date

    try
      FExpirationDate := ConvertExpDate(Value);
    except
      FInvalidDate := True;
    end;
    FExpired := False;
  finally
    //rj DetailLogger.ExitMethod(self, 'Create');
  end;

end;

procedure TOption.DecContracts(Count: Double);
begin
  FContracts := FContracts - Count; // reduce the number of contracts available
  // but DO NOT reduce the number of FOptionsOpened // 2015-04-14 MB
  FSomeOptionsClosed := True;
end;

destructor TOption.destroy;
var
  I : Integer;
begin
  FMatchingStocks.Free;
  FExpiredOptions.Free;
  FWashSales.Free;
  FOptions.Free;
  FWashOptionMap.Free;
  inherited;
end;

function TOption.GetMatchingStock: Boolean;
begin
  Result := (FMatchingStocks.Count > 0) and
    (TotalMatchedShares >= FContracts * FMultiplier);
end;

function TOption.GetSharesToMatch: Double;
begin
  //Result := FContracts * FMultiplier;
  // even if Some options are closed, include them in this calculation
  Result := FOptionsOpened * FMultiplier;
end;

function TOption.GetStock(Item: Integer): TTLTrade;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to FMatchingStocks.Count - 1 do
    if FMatchingStocks[I].ID = Item then
    begin
      Result := FMatchingStocks[I];
      break;
    end;
end;

function TOption.GetOption(Item: Integer): TTLTrade;
var
  I: Integer;
  Option : TTLTrade;
begin
  Result := nil;
  for Option in Options do
    if Option.ID = Item then
    begin
      Result := Option;
      break;
    end;
end;

function TOption.GetTotalExpiredContracts: Double;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to FExpiredOptions.Count - 1 do
    Result := Result + FExpiredOptions[I].Shares;
end;

function TOption.GetTotalMatchedShares: Double;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to FMatchingStocks.Count - 1 do
    Result := Result + FMatchingStocks[I].Shares;
end;

function TOption.SetTotalMatchedShares(I:Integer; sh:Double) : double;
begin
  FMatchingStocks[I].Shares := sh;
  result := sh;
end;

procedure TOption.IncContracts(Count: Double);
begin
  FContracts := FContracts + Count;
  FOptionsOpened := FOptionsOpened + Count; // 2015-04-14 MB
end;

procedure TOption.MarkExpired;
begin
  FExpired := True;
end;


function TExerciseAssign.ValidStockBuySell(CallOrPut, OptionLS, StockOC,
  StockLS: Char): Boolean;
begin
  Result := True;
  // Check for Stock Buy
  if ( ((OptionLS = 'S') and (CallOrPut = 'P')) or ((OptionLS = 'L') and (CallOrPut = 'C')) )
  and ( ((StockOC = 'O') and (StockLS = 'L')) or ((StockOC = 'C') and (StockLS = 'S')) ) then
    exit;
  // Check for Stock Sell
  if ( ((OptionLS = 'L') and (CallOrPut = 'P')) or ((OptionLS = 'S') and (CallOrPut = 'C')) )
  and ( ((StockOC = 'C') and (StockLS = 'L')) or ((StockOC = 'O') and (StockLS = 'S')) ) then
    exit;
  // If we got here then the Stock Buy or Sell does NOT match up with
  // the option type so return false
  Result := False;
end;


function TExerciseAssign.ValidStockType(Value: String): Boolean;
var
  S: String;
begin
  Result := False;
  S := LeftStr(Value, 3);
  if (S = 'STK') or (S = 'MUT') or (S = 'DRP') or (S = 'ETF') then
    Result := True;
end;

{ TExerciseDiscoverer }

function CompareTrNumber(const Item1, Item2: TOption): Integer;
begin
  Result := 0;
  if Item1.TrNum < Item2.TrNum then
    Result := -1
  else if Item1.TrNum > Item2.TrNum then
    Result := 1
end;

function CompareTicker(const Item1, Item2: TOption): Integer;
begin
  Result := 0;
  if Item1.StockTicker < Item2.StockTicker then
    Result := -1
  else if Item1.StockTicker > Item2.StockTicker then
    Result := 1
end;

function CompareExpirationDt(const Item1, Item2: TOption): Integer;
begin
  Result := 0;
  if Item1.ExpirationDate < Item2.ExpirationDate then
    Result := -1
  else if Item1.ExpirationDate > Item2.ExpirationDate then
    Result := 1
end;

function CompareStrikePrice(const Item1, Item2: TOption): Integer;
begin
  Result := 0;
  if Item1.StrikePrice < Item2.StrikePrice then
    Result := -1
  else if Item1.StrikePrice > Item2.StrikePrice then
    Result := 1
end;

function CompareOptionType(const Item1, Item2: TOption): Integer;
begin
  Result := 0;
  if Item1.OptionType < Item2.OptionType then
    Result := -1
  else if Item1.OptionType > Item2.OptionType then
    Result := 1
end;

function CompareLongShort(const Item1, Item2: TOption): Integer;
begin
  Result := 0;
  if Item1.LongShort < Item2.LongShort then
    Result := -1
  else if Item1.LongShort > Item2.LongShort then
    Result := 1
end;

constructor TExerciseAssign.create;
begin
  create(TradeLogFile);
end;


// Whenever TList's "IndexOf" or "Contains" methods are run the Option Comparer as defined here
// will be used to compare two items in the list to determine if they are
// equal to each other. This compares TrNumber, Stock Ticker, OptionType (Call or Put)
// Expiration Date and Strike Price and LongShort. This may be overkill since TrNum alone
// matched records.
constructor TExerciseAssign.create(FileToUse: TTLFile);
begin
  //rj Logger.EnterMethod(self, 'Create(' + FileToUse.FileName + ')');
  try
    if FileToUse.CurrentBrokerID = 0 then
      raise EExerciseAssignException.Create('Current Broker is set to All, Please choose a broker tab to exercise Options');
    FFirstExerciseNum := 0;
    FFileToUse := FileToUse;
    FOptions := TOptionList.create(TOptionComparer.Construct(
      function(const Item1,Item2: TOption): Integer
      begin
        Result := CompareTrNumber(Item1,Item2);
        //if Result = 0 then Result := CompareTicker(Item1, Item2);
        //if Result = 0 then Result := CompareOptionType(Item1, Item2);
        //if Result = 0 then Result := CompareExpirationDt(Item1, Item2);
        //if Result = 0 then Result := CompareStrikePrice(Item1, Item2);
        //if Result = 0 then Result := CompareLongShort(Item1, Item2);
      end),
      True
    );
  finally
    //rj Logger.ExitMethod(self, 'Create');
  end;
end;

destructor TExerciseAssign.destroy;
begin
  FOptions.Free;
  inherited;
end;


procedure TExerciseAssign.DiscoverUnexercisedOptions;
var
  I, Idx, J: Integer;
  StkDate: TDateTime;
begin
  FOptions.Clear;
  FFileToUse.SortByTrNumber;
  // Gets all open options even if they are closed by ZERO PRICE expiration
  // records (this is to make allowances for user error)
  GetOpenOptions;
  // No Need to continue we have no options.
  if FOptions.Count = 0 then exit;
  // ----------------------------------
  // At this point we have all OPEN Options with contracts that have NOT been
  // exercised. Next let's look for matching Stock trades for these options.
  GetMatchingStocks;
  for I := FOptions.Count - 1 downto 0 do begin
    if FOptions[I].TotalMatchedShares = 0 then FOptions.Delete(I);
  end;
end;


function TExerciseAssign.ExerciseAssign(Index: Integer): Integer;
begin
  Result := ExerciseAssign(Index, nil, nil);
end;


function TExerciseAssign.GetCount: Integer;
begin
  Result := FOptions.Count
end;

// ------------------------------------
procedure TExerciseAssign.GetMatchingStocks;
var
  I, J: Integer;
  StkDate: TDateTime;
begin
  for I := 0 to FOptions.Count - 1 do
  begin
    // Once we have the options that are still open we now need to determine
    // if there are matching Stock transactions
    for J := 0 to FFileToUse.Count - 1 do
    begin
      //2014-03-19 don't assign stocks opened in next tax year
      if (TradeLogFile.FileHeader[FFileToUse[J].Broker].MTM)
      and (FFileToUse[J].Date > strToDate('12/31/'+intToStr(TradeLogFile.TaxYear),settings.InternalFmt))
      then
        continue;
      // ----------------------------------------
      if Not ValidStockType(FFileToUse[J].TypeMult)
      or (FFileToUse.CurrentBrokerID <> FFileToUse[J].Broker)
      then continue;
      // ----------------------------------------
      StkDate := FFileToUse[J].Date;
      if (FOptions[I].StockTicker = FFileToUse[J].Ticker)
      and (FOptions[I].StrikePrice = FFileToUse[J].price)
      and ValidStockBuySell(FOptions[I].OptionType, FOptions[I].LongShort, FFileToUse[J].OC, FFileToUse[J].LS)
      and ((StkDate >= FOptions[I].BuyDate) and (StkDate <= FOptions[I].FExpirationDate + 4))
      and (Pos('Ex-', FFileToUse[J].Matched) = 0)
      and (FFileToUse[J].Shares <= FOptions[I].SharesToMatch)
      then begin
        // We have a matching stock
        FOptions[I].AddStock(FFileToUse[J]);
      end;
    end;
  end;
end;


//-------------------------------------
procedure TExerciseAssign.GetOpenOptions;
var
  I, brID: Integer;
  Option: TOption;
  CurrentTrNumber: Integer;
  Idx: Integer;
  WashSales : TTradeList;
begin
  CurrentTrNumber := 0;
  WashSales := TTradeList.Create;
  try
    for I := 0 to FFileToUse.Count - 1 do begin
      try
        brID := TradeLogFile.FileHeader[FFileToUse[I].Broker].BrokerID;
      except
      begin
        sm('ERROR: A record was found which points' + CR
          + 'to a non-existent broker account.' + CR + CR
          + 'Please contact TradeLog Support.');
        exit;
      end;
      end;
      //2014-03-19 don't exercise options opened in next tax year
      if (TradeLogFile.FileHeader[FFileToUse[I].Broker].MTM)
      and (FFileToUse[I].Date > strToDate('12/31/'+intToStr(TradeLogFile.TaxYear),settings.InternalFmt))
      then
        continue;
      // ------------------------------
      if IsOption(FFileToUse[I].TypeMult, FFileToUse[I].Ticker,false) // It's an Option
      and (Pos('Ex', FFileToUse[I].Matched) = 0) // It hasn't been exercised.
      and (FFileToUse.CurrentBrokerID = FFileToUse[I].Broker) //It is of the current broker
      then begin
        if (CurrentTrNumber > 0)
        and (CurrentTrNumber <> FFileToUse[I].TradeNum) then begin
          // New Transaction group.
          // Determine if the last group has open contracts.
          // If Not then remove it as it is not an open Option.
          if FOptions.Count > 0 then begin
            if FOptions.Last.Contracts = 0 then
              FOptions.Remove(FOptions.Last)
            else if (WashSales.Count > 0)
            and (WashSales[0].TradeNum = CurrentTrNumber) then begin
              FOptions.Last.AddWashSales(WashSales);
              WashSales.Clear;
            end;
          end;
        end;
        // ----------------------------
        // Add Wash Sales to a list to add later on
        if (FFileToUse[I].OC = 'W') then begin
          // If for some reason the WashSales TrNums don't match
          // then clear the list
          if (WashSales.Count > 0)
          and (WashSales[0].TradeNum <> FFileToUse[I].TradeNum) then
            WashSales.Clear;
          WashSales.Add(FFileToUse[I]);
          Continue;
        end;
        // ----------------------------
        Option := TOption.create(FFileToUse[I]);
        if FOptions.Contains(Option) and not Option.InvalidDate then begin
          Idx := FOptions.IndexOf(Option);
          // If the Option Price is zero then this is the record that expires the option
          // We want to know so that if they exercise the option we will then know that we need to
          // delete the expired record. Also we do not want to increment or decrement the contracts
          // with this record since we want to present them with the opportunity to
          // unexpire them and exercise them instead.
          if Option.Price = 0 then begin
            FOptions[Idx].MarkExpired;
            FOptions[Idx].AddExpiredOption(FFileToUse[I]);
          end
          else begin
            if Option.OpenClose = 'O' then
              // If it's an open then increment the contracts
              FOptions[Idx].IncContracts(Option.Contracts)
            else
              // if a close then decrement the contracts, but not OptionsOpened.
              FOptions[Idx].DecContracts(Option.Contracts);
            // end if
            FOptions[Idx].AddOption(FFileToUse[I]);
            Option.Free;
          end;
        end
        else begin
          // We did not find this option so let's add it to the list.
          FOptions.Add(Option);
          CurrentTrNumber := Option.TrNum;
        end;
      end;
    end;
    // --------------------------------
    // If the last record is zero contracts then remove it.
    if (FOptions.Count > 0) and (FOptions.Last.Contracts = 0) then
      FOptions.Remove(FOptions.Last)
    else if (WashSales.Count > 0)
    and (WashSales[0].TradeNum = CurrentTrNumber) then begin
      FOptions.Last.AddWashSales(WashSales);
      WashSales.Clear;
    end;
  finally
    WashSales.Free;
  end;
end;


function TExerciseAssign.GetOption(Index: Integer): TOption;
begin
  if (Index > -1) and (Index < FOptions.Count) then
    Result := FOptions[Index]
  else
    raise EArgumentException.create('Index Out of range: ' + IntToStr(Index));
end;


{ Remove all zero prices options from the file }
procedure TExerciseAssign.RemoveExpiredOptions(Index: Integer);
var
  I: Integer;
begin
  for I := 0 to FOptions[Index].ExpiredOptions.Count - 1 do
    FFileToUse.DeleteTrade(FOptions[Index].ExpiredOptions[I]);
end;

procedure TExerciseAssign.RemoveOption(Index: Integer);
begin
  FOptions.Remove(FOptions[Index]);
end;

function TExerciseAssign.GetAssignNum(exStr: string): Integer;
var
  I: Integer;
  a: string;
begin
  Result := 1;
  for I := 0 to FFileToUse.Count - 1 do
    if Pos(exStr, FFileToUse[I].Matched) = 1 then
    begin
      a := FFileToUse[I].Matched;
      delete(a, 1, Length(exStr));
      if IsInt(a) then
      begin
        if StrToInt(a) >= Result then
          Result := StrToInt(a) + 1;
      end;
    end;
end;


function TExerciseAssign.ParseStrike(tick: string): Double;
var
  a, b, S: string;
begin
  // check if exercised, remove 'EXERCISED' text from end
  if Pos('EXERCISED', tick) > 0 then
    S := ParseLast(tick, ' ');

  // remove CALL/PUT from string
  S := ParseLast(tick, ' ');
  // get strike price string
  S := ParseLast(tick, ' ');

  // test for fraction
  if Pos('/', S) > 0 then
  begin
    b := ParseLast(S, '/');
    a := S;
    // get integer part of strike price
    S := ParseLast(tick, ' ');
    Result := StrToInt(S) + StrToInt(a) / StrToInt(b);
  end
  else
    Result := StrToFloat(S, Settings.InternalFmt);
end;


// ----------------------------------------------
function TExerciseAssign.ExerciseAssign(Index:Integer; StockTrades,OptionTrades:TTradeList): Integer;
var
  I, J, W, AssignNum, StNr : Integer;
  tick, exStr, OptionType : String;
  contractsOpen, ContractsClosed, ContractsExercised, mult, OptAmt,
  StockContracts, WSTotal, WSShares, Amt, ShOpen, ShClose : Double;
  OptionRec, StockRec, WashSaleRec : TTLTrade;
  Option : TOption;
  NewTrades, NewWashSales, NewClosedTrades : TTradeList;
  addOptRecord : boolean;
  // ----- for debug only -----
  procedure ShowOptionTrades;
  var
    K : integer;
    sTmp: String;
  begin
    sTmp := '';
    for K := 0 to OptionTrades.Count - 1 do begin
      sTmp := sTmp + OptionTrades.Items[K].OC + OptionTrades.Items[K].LS + ' ';
      if (J = 0) AND (ShOpen > 0) then // we must be using ShOpen to track #shares remaining
        sTmp := sTmp + FloatToStr(ShOpen)
      else
        sTmp := sTmp + FloatToStr(OptionTrades.Items[K].Shares);
      if K = J then
        sTmp := sTmp + '< J';
      if K = I then
        sTmp := sTmp + '< I';
      if K < OptionTrades.Count-1 then
        sTmp := sTmp + CR;
    end;
    sm(sTmp);
  end;
  // ---- end debug code ----
  // ------------------------
  function isFutureOption(Prf: String; Ticker: String): Boolean;
  begin
    Result := (Pos('FUT', Prf) = 1) and
      ((Pos('PUT', Ticker) > 0) or (Pos('CALL', Ticker) > 0));
  end;
  // ------------------------
  // Adjust all W Records attached to the current Option
  // This is used when there are no adjustments to quantities
  // and no new Option Records added.
  //
  // When the Current Options Contracts are less than or equal to
  // the number of Stock shares that are being assigned.
  // ------------------------
  procedure AdjustAllWashSales;
  var
    W : Integer;
  begin
    if Option.WashSales.Count > 0 then begin
      for W := 0 to Option.FWashOptionMap[I].Count - 1 do begin
        if (Option.WashSales[Option.FWashOptionMap[I][W]].Shares <> OptionTrades[I].Shares)
        then
          continue;
        Option.WashSales[Option.FWashOptionMap[I][W]].Ticker := OptionTrades[I].Ticker;
        Option.WashSales[Option.FWashOptionMap[I][W]].Matched := OptionTrades[I].Matched;
        WSTotal := WSTotal + Option.WashSales[Option.FWashOptionMap[I][W]].Amount;
      end;
    end;
  end;
  // ------------------------
  // Adjust W Records when there are changes in the Option Records,
  // Since we breakdown option records for partial exercises, or
  // when part of an option is already closed and so on, we then need to
  // breakdown W Records appropriately.
  //
  // Used when the Current Option contracts are greater than the current
  // Stock Shares and so a breakdown of the W Records must occur.
  // ------------------------
  procedure AdjustWashSales;
  var
    W : Integer;
  begin
    if Option.WashSales.Count > 0 then begin
      WSShares := 0;
      W := 0;
      while W <= Option.FWashOptionMap[I].Count - 1 do begin
        if Option.WashSales[Option.FWashOptionMap[I][W]].Shares > StockContracts - WSShares then begin
          if (NewWashSales.Last.ID = Option.WashSales[Option.FWashOptionMap[I][W]].ID) //
          and (NewWashSales.Count > 0) then begin
            WashSaleRec := NewWashSales.Last;
            WashSaleRec.Shares := WashSaleRec.Shares + StockContracts;
            Amt := (Option.WashSales[Option.FWashOptionMap[I][W]].Amount * (StockContracts / Option.WashSales[Option.FWashOptionMap[I][W]].Shares));
            WashSaleRec.Amount := WashSaleRec.Amount + Amt;
            WSTotal := WSTotal + Amt;
            WSShares := WSShares + StockContracts;
            // Adjust existing Wash Sale Rec.
            Option.WashSales[Option.FWashOptionMap[I][W]].Shares := Option.WashSales[Option.FWashOptionMap[I][W]].Shares - StockContracts;
            Option.WashSales[Option.FWashOptionMap[I][W]].Amount := Option.WashSales[Option.FWashOptionMap[I][W]].Amount - Amt;
          end
          else
          begin
            WashSaleRec := TTLTrade.Create(Option.WashSales[Option.FWashOptionMap[I][W]]);
            WashSaleRec.TradeNum := OptionRec.TradeNum;
            // WashSaleRec.ID := OptionRec.ID - 1;    //2013-12-24 delete this line????
            WashSaleRec.Ticker := OptionRec.Ticker;
            WashSaleRec.Shares := StockContracts - WSShares;
            WashSaleRec.Amount := Option.WashSales[Option.FWashOptionMap[I][W]].Amount * StockContracts / Option.WashSales[Option.FWashOptionMap[I][W]].Shares;
            WashSaleRec.Matched := OptionRec.Matched;
            NewWashSales.Add(WashSaleRec);
            WSTotal := WSTotal + WashSaleRec.Amount;
            WSShares := WSShares + WashSaleRec.Shares;
            // Adjust existing Wash Sale Rec.
            Option.WashSales[Option.FWashOptionMap[I][W]].Shares := Option.WashSales[Option.FWashOptionMap[I][W]].Shares - WashSaleRec.Shares;
            Option.WashSales[Option.FWashOptionMap[I][W]].Amount := Option.WashSales[Option.FWashOptionMap[I][W]].Amount - WashSaleRec.Amount;
          end;
        end
        else begin
          // Just attach the W record to the new Option Record.
          Option.WashSales[Option.FWashOptionMap[I][W]].Ticker := OptionRec.Ticker;
          Option.WashSales[Option.FWashOptionMap[I][W]].Matched := OptionRec.Matched;
          Option.WashSales[Option.FWashOptionMap[I][W]].TradeNum := OptionRec.TradeNum;
          WSTotal := WSTotal + Option.WashSales[Option.FWashOptionMap[I][W]].Amount;
          WSShares := WSShares + Option.WashSales[Option.FWashOptionMap[I][W]].Shares;
          // Remove the Wash Sale since it has been applied. Do not increment W since we
          // removed the Wash Sale record, W now points at the next record.
          Option.FWashOptionMap[I].Delete(W);
        end;
        if WSShares = StockContracts then
          Break;
      end;
    end;
  end;
// ----------------------------------------------
// BEGINNING of TExerciseAssign.ExerciseAssign
// ----------------------------------------------
begin
  Option := FOptions[Index];
  if StockTrades = nil then
    StockTrades := FOptions[Index].MatchingStocks;
  Result := 0; // Success Code, Should be greater than zero if assigned.
  contractsOpen := 0;
  ContractsExercised := 0;
  ContractsClosed := 0;
  stockContracts := 0;
  mult := 0;
  exStr := 'Ex-';
  // ------------------------
  if FFirstExerciseNum = 0 then begin
    FFirstExerciseNum := GetAssignNum(exStr);
    FNextExerciseNum := FFirstExerciseNum;
    AssignNum := FFirstExerciseNum;
  end
  else begin
    FNextExerciseNum := FNextExerciseNum + 1;
    AssignNum := FNextExerciseNum;
  end;
  // ------------------------
  if OptionTrades = nil then begin
    contractsOpen := Option.Contracts;
    OptionTrades := Option.Options;
    tick := Option.OptionTicker;
    mult := Option.Multiplier;
    if isFutureOption(Option.TypeMult, tick) then
      OptionType := 'FUT'
    else
      OptionType := 'OPT';
  end else
    for OptionRec in OptionTrades do begin
    ContractsOpen := ContractsOpen + OptionRec.Shares;
      tick := OptionRec.Ticker;
      mult := Option.Multiplier;
      if isFutureOption(OptionRec.TypeMult, tick) then
        OptionType := 'FUT'
      else
        OptionType := 'OPT';
    end;
  // end if
  // ------------------------
  NewTrades := TTradeList.create;
  NewWashSales := TTradeList.Create;
  NewClosedTrades := TTradeList.Create;
  try
    // ----------------------
    OptionTrades.SortByTicker;
    // make closed options a separate trade
    // create new option trade for exercised contracts
    // ----------------------
    // 2014-12-17 loop thru stocks and loop thru options MUST be in same order
    // for StNr := StockTrades.Count - 1 downto 0 do //LIFO
    for StNr := 0 to StockTrades.Count - 1 do begin // FIFO
      // In this case we need to loop through all the stock trades
      // and make sure that we only exercise options that are on or before
      // the trade assignment date.
      StockRec := StockTrades[StNr];
      if (pos('Ex',StockRec.Matched)=1) then continue;
      // --------------------
      StockContracts := StockRec.Shares / Mult;
      OptAmt := 0;
      WSTotal := 0;
      addOptRecord := true;
      // ----------------------------------------
      // *** need to loop forwards, not backwards ***
      // If there are closed contracts records that are not priced at zero then
      // we need to skip any options that are closed due to these closed contracts
      // ----------------------------------------
      for I := 0 to OptionTrades.Count - 1 do begin // FIFO
        if (ContractsClosed > 0) then begin
          if (ContractsClosed >= OptionTrades[I].Shares) then begin
            ContractsClosed := ContractsClosed - OptionTrades[I].Shares;
            continue;
          end
          else begin
            // This Option record needs to be broken into two parts
            // and the unclosed portion needs to be part of the exercise
            // add a new open option record for the Closed Portion
            OptionRec := TTLTrade.create(OptionTrades[I]);
            OptionRec.Shares := ContractsClosed;
            OptionRec.Commission := OptionTrades[I].Commission * ContractsClosed / OptionTrades[I].Shares;
            OptionRec.Amount := OptionTrades[I].Amount * ContractsClosed / OptionTrades[I].Shares;
            // TAF 6/11/2013 ID must get set to Zero so it doesn't match later
            // when exercising Bug Fix Nicholas Maloney
            OptionRec.ID := TradeLogFile.NextID;
            // End of Bug Fix
            NewTrades.Add(OptionRec);
            // Now update the existing record as the open portion.
            OptionTrades[I].Amount := OptionTrades[I].Amount * (OptionTrades[I].Shares - ContractsClosed) /
              OptionTrades[I].Shares;
            // split commis
            OptionTrades[I].Commission := OptionTrades[I].Commission * (OptionTrades[I].Shares - ContractsClosed) /
              OptionTrades[I].Shares;
            // reduce open contracts
            OptionTrades[I].Shares := OptionTrades[I].Shares - ContractsClosed;
            // matched lots
            OptionTrades[I].Matched := '';
            { Now we are only working with this open portion. }
            ContractsClosed := 0;
            if Option.WashSales.Count > 0 then begin
              // Finally we need to break down any wash sales that go with the closed records
              WSShares := 0;
              W := 0;
              while W <= Option.FWashOptionMap[I].Count - 1 do begin
                if (Option.WashSales[Option.FWashOptionMap[I][W]].Shares - WSShares <= OptionRec.Shares) then begin
                  // OK this is a W that applies to the close so remove it from the map
                  // Dont increment the Loop Variable because the list is now one shorter.
                  // and so the current loop variable still applies to the next list item.
                  WSShares := WSShares + Option.WashSales[Option.FWashOptionMap[I][W]].Shares;
                  Option.FWashOptionMap[I].Delete(W);
                  continue;
                end else
                if (Option.WashSales[Option.FWashOptionMap[I][W]].Shares - WSShares > OptionRec.Shares) then
                begin
                  // add a new open W record for the Closed Portion of the W Record
                  WashSaleRec := TTLTrade.create(Option.WashSales[Option.FWashOptionMap[I][W]]);
                  WashSaleRec.TradeNum := OptionRec.TradeNum; { Attach this to the new TrNum created above }
                  WashSaleRec.Shares := OptionRec.Shares;
                  WashSaleRec.Amount := Option.WashSales[Option.FWashOptionMap[I][W]].Amount *
                    (OptionRec.Shares / Option.WashSales[Option.FWashOptionMap[I][W]].Shares);
                  NewTrades.Add(WashSaleRec);
                  // Now Adust the existing W Record.
                  Option.WashSales[Option.FWashOptionMap[I][W]].Shares := Option.WashSales[Option.FWashOptionMap[I][W]]
                    .Shares - WashSaleRec.Shares;
                  Option.WashSales[Option.FWashOptionMap[I][W]].Amount := Option.WashSales[Option.FWashOptionMap[I][W]]
                    .Amount - WashSaleRec.Amount;
                  Break; // We are done so break out of the loop
                end
                else Break;
              end;
            end;
          end;
        end;
      end; // check for closed options
      // ----------------------------------------------------------------------
      // to prevent negative shares, use LIFO here
      I := OptionTrades.Count - 1; // LIFO
      while (I > -1) do             // LIFO
      begin
        // If we used up the Stocks contracts on the last record then let's
        // break out of the while loop to get the next stock information.
        if (StockContracts <= 0)
        or (contractsOpen <= 0) then
        begin
          if (StockContracts <= 0)
          then
            addOptRecord := false;
          break;
        end;
        // ----------------------------
        if (pos('Ex',optionTrades[I].Matched)=1) then
        begin
          dec(I);
          continue;
        end;
        // ----------------------------
        if (Pos('OPT', OptionTrades[I].TypeMult) = 1)
        or isFutureOption(OptionTrades[I].TypeMult, OptionTrades[I].Ticker) then
        begin
          if (OptionTrades[I].OC = 'O') then
          begin
            // We can only apply stock shares to an Option that
            // was purchased on or before the stock assignment Date
            // so once we get to a new stock if the date is before the current
            // option then skip this option record.
            if (OptionTrades[I].Date > StockRec.Date)
            then begin
              if OptionTrades[I].Shares > ContractsClosed then
                ContractsClosed := 0
              else
                ContractsClosed := ContractsClosed - OptionTrades[I].Shares;
              dec(i);
              Continue;
            end;
            // ------------------------
            if OptionTrades[I].Shares <= StockContracts then
            begin
              // make this a new trade number
              OptionTrades[I].TradeNum := 0;
              StockContracts := StockContracts - OptionTrades[I].Shares;
              contractsOpen := contractsOpen - OptionTrades[I].Shares;
              ContractsExercised := ContractsExercised + OptionTrades[I].Shares;
              OptionTrades[I].Ticker := tick + ' EXERCISED';
              OptionTrades[I].Matched := exStr + IntToStr(AssignNum);
              OptionTrades[I].OptionTicker := '';
              AdjustAllWashSales;
              OptAmt := OptAmt + OptionTrades[I].Amount;
              addOptRecord := true;
              if stockContracts > 0 then
              begin
                dec(I);
                continue;
              end else
                break;
            end else
            if OptionTrades[I].Shares > StockContracts then
            begin
              // We need to split this record so that we can apply the remaining contracts for this Stock.
              // Still working on the same option record
              if (NewTrades.Count > 0)
              and (NewTrades.Last.ID = OptionTrades[I].ID) then
              begin
                OptionRec := NewTrades.Last;
                OptionRec.Shares := OptionRec.Shares + StockContracts;
                OptionRec.Commission := OptionRec.Commission + (OptionTrades[I].Commission * (StockContracts / OptionTrades[I].Shares));
              end else
              begin
                // add a new open option record
                OptionRec := TTLTrade.Create(OptionTrades[I]);
                OptionRec.OC := 'O';
                OptionRec.Ticker := OptionTrades[I].Ticker + ' EXERCISED';
                OptionRec.Shares := StockContracts;
                OptionRec.Commission := OptionTrades[I].Commission * StockContracts / OptionTrades[I].Shares;
                OptionRec.Amount :=  OptionTrades[I].Amount * StockContracts / OptionTrades[I].Shares;
                OptionRec.Matched := exStr + IntToStr(assignNum);
                NewTrades.Add(OptionRec);
              end;
              // ------------
              AdjustWashSales;
              // ------------
              OptAmt := OptAmt + (OptionTrades[I].Amount * StockContracts / OptionTrades[I].Shares);
              OptionTrades[I].Amount :=  OptionTrades[I].Amount * (OptionTrades[I].Shares - StockContracts) /  OptionTrades[I].Shares;
              // split commis
              OptionTrades[I].Commission :=  OptionTrades[I].Commission * (OptionTrades[I].Shares - StockContracts) /  OptionTrades[I].Shares;
              // reduce open contracts
              OptionTrades[I].Shares := OptionTrades[I].Shares - StockContracts;
              // matched lots
              OptionTrades[I].Matched := '';
              contractsOpen := contractsOpen - StockContracts;
              ContractsExercised := ContractsExercised + StockContracts;
              ContractsClosed := 0;
              StockContracts := 0;
              addOptRecord := true;
              break;
            end;
          end else
          begin
            if (OptionTrades[I].Price > 0) then
              ContractsClosed := ContractsClosed + OptionTrades[I].Shares;
            dec(i);
            continue;
          end;
        end else // if (pos('OPT',myType)=1)
        // if not an option then continue looping thru trades
        begin
          dec(I);
          continue;
        end;
        // If we have used up all the contracts for this stock then break out of the
        // while loop and get the next stock record.
        if (StockContracts = 0)
        or (contractsOpen = 0) then
        begin
          break;
        end;
      end; // while I loop thru options
      // --------------------
      if not addOptRecord then continue;
      // --------------------
      OptionRec := TTLTrade.Create;
      OptionRec.Date := StockRec.Date;
      OptionRec.Time := '16:00:00';
      OptionRec.TypeMult := OptionType + '-' + FloatToStr(mult, Settings.InternalFmt);
      OptionRec.OC := 'C';
      OptionRec.LS := OptionTrades[0].LS;
      OptionRec.Ticker := tick + ' EXERCISED';
      OptionRec.Commission := 0;
      OptionRec.Shares := StockRec.Shares / mult;
      // --------------------
      // added test to close option at $0 for BBIO's - 2015-05-05 MB
      if POS('FUT-', OptionRec.TypeMult) = 0 then // not a BBIO, so adjust
      begin
        OptionRec.Amount := -OptAmt;
        OptionRec.Price := (-OptAmt + -WSTotal) / (OptionRec.Shares * mult);
        if OptionRec.Price < 0 then OptionRec.Price := -OptionRec.Price;
      end
      else begin
        OptionRec.Amount := 0;
        OptionRec.Price := 0;
      end;
      // --------------------
      // sm('Cm: '+floatToStr(OptionRec.Commission)+cr+'Amt: '+floatToStr(OptionRec.Amount));
      OptionRec.Matched := exStr + IntToStr(assignNum);
      OptionRec.Broker := StockRec.Broker;
      OptionRec.OptionTicker := '';
      NewClosedTrades.Add(OptionRec);
      // --------------------
      // added test to avoid adjusting cost basis for BBIO's - 2015-05-05 MB
      if POS('FUT-', OptionRec.TypeMult) = 0 then // not a BBIO, so adjust
      begin
        // Adjust Stock Basis.
        // Since the OptionRec amount is the closing amount,
        // we need to subtract it not add it.
        StockRec.Amount := StockRec.Amount - OptionRec.Amount; // + WSTotal;
        // Take the amount and
        // back out the commission by adding it to the amount, then
        // calc the price by dividing the stock shares into the result.
        StockRec.Price := rndTo5((StockRec.Amount + StockRec.Commission) / StockRec.Shares);
        // If the price is calced as negative then make it positive.
        if StockRec.Price < 0 then StockRec.Price := -StockRec.Price;
      end;
      // --------------------
      // Set the Matched field to the Exercise Number.
      StockRec.Matched := exStr + IntToStr(assignNum);
    end; // for stNr  loop thru stock trades
    // --------------------------------
    // insert NewTrades record(s) into the file.
    for I := 0 to NewTrades.Count - 1 do
    begin
      if rndTo5(NewTrades[i].Shares) > 0 then // make sure no zero share records get added
        TradeLogFile.AddTrade(NewTrades[I]);
    end;
    // ----------------------
    // insert NewClosedTrade record(s) into the file.
    for I := 0 to NewClosedTrades.Count - 1 do
    begin
      if rndTo5(NewClosedTrades[i].Shares) > 0 then // make sure no zero share records get added
        TradeLogFile.AddTrade(NewClosedTrades[I]);
    end;
    // insert NewWashSale record(s) into the file.
    for I := 0 to NewWashSales.Count - 1 do
    begin
      if rndTo5(NewWashSales[i].Shares) > 0 then // make sure no zero share records get added
        TradeLogFile.AddTrade(NewWashSales[I]);
    end;
    // save all the changes to the options and stocks
    for I := 0 to OptionTrades.Count - 1 do
      if rndTo5(OptionTrades[I].Shares) > 0 then
        TradeLogfile.UpdateTrade(OptionTrades[I])
      else
        TradeLogfile.DeleteTrade(OptionTrades[I]);
      // end if
    for I := 0 to StockTrades.Count - 1 do
      if rndTo5(StockTrades[I].Shares) > 0 then
        TradeLogFile.UpdateTrade(StockTrades[I])
      else
        TradeLogFile.DeleteTrade(StockTrades[I]);
      // end if
    // Finally delete the expired option records.
    for I := 0 to Option.ExpiredOptions.Count - 1 do
      TradeLogFile.DeleteTrade(Option.ExpiredOptions[I]);
    // next I
    Result := AssignNum;
  finally
    NewTrades.Free;
    NewWashSales.Free;
    NewClosedTrades.Free;
  end;
end;


initialization
//rj   Logger := TCodeSite//rj Logger.Create(nil);
//rj   //rj Logger.Category := CODE_SITE_CATEGORY;
//rj   TLLoggers.RegisterLogger(CODE_SITE_CATEGORY, Logger);

//rj   DetailLogger := TCodeSite//rj Logger.Create(nil);
  //rj Detail//rj Logger.Category := CODE_SITE_DETAIL_CATEGORY;
//rj   TLLoggers.RegisterLogger(CODE_SITE_DETAIL_CATEGORY, DetailLogger);

end.