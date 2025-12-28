unit TLDataSources;

interface

uses SysUtils, Windows, Classes, Forms, TLFile, cxCustomData, cxGridTableView ;

type
  TTLFileDataSource = class(TcxCustomDataSource)
  private
    FFile : TTLFile;
    FGridTableView : TcxGridTableView;
  protected
    function GetRecordCount: Integer; override;
    function GetValue(ARecordHandle: TcxDataRecordHandle; AItemHandle: TcxDataItemHandle): Variant; override;
    procedure SetValue(ARecordHandle: TcxDataRecordHandle; AItemHandle: TcxDataItemHandle; const AValue: Variant); override;
    procedure DeleteRecord(ARecordHandle: TcxDataRecordHandle); override;
    function  InsertRecord(ARecordHandle: TcxDataRecordHandle): TcxDataRecordHandle; override;
    function  AppendRecord: TcxDataRecordHandle; override;
  public
    constructor Create(TradeLogFile: TTLFile; GridTableView : TcxGridTableView);
    procedure EditEnable;
    procedure EditDisable;
  end;

  // -----------------------------------------------------+
  //       Use this one for the OpenTrades grid           |
  // -----------------------------------------------------+
  TTLOpenTradesDataSource = class(TcxCustomDataSource)
  private
    FTradeNums : TTLTradeNumList;
    FGridTableView : TcxGridTableView;
    FAsOfDate : TDate;
  protected
    function GetRecordCount: Integer; override;
    function GetValue(ARecordHandle: TcxDataRecordHandle; AItemHandle: TcxDataItemHandle): Variant; override;
  public
    constructor Create(TradeNums : TTLTradeNumList; GridTableView : TcxGridTableView; AsOfDate : TDate);
    destructor Destroy; override;
    property TradeNums : TTLTradeNumList read FTradeNums;
  end;

  TTLTradesDataSource = class(TcxCustomDataSource)
  private
    FTrades : TTradeList;
  protected
    function GetRecordCount: Integer; override;
    function GetValue(ARecordHandle: TcxDataRecordHandle; AItemHandle: TcxDataItemHandle): Variant; override;
  public
    constructor Create(TradeList: TTradeList);
    destructor Destroy; override;
    property Trades : TTradeList read FTrades;
  end;

implementation

uses TLCommonLib, FuncProc, TLSettings,
  cxGridCustomTableView,
  Variants, RecordClasses, Graphics, gainsLosses, globalVariables;

{ TTLFileDataSource }

constructor TTLFileDataSource.Create(TradeLogFile: TTLFile; GridTableView : TcxGridTableView);
begin
  FFile := TradeLogFile;
  FGridTableView := GridTableView;
end;

function getUnderlying(Trade : TTLTrade):string;
begin
  if (pos('OPT',uppercase(Trade.TypeMult)) = 1) then
  begin
    result := copy(Trade.Ticker, 1, Pos(' ', Trade.Ticker) - 1);
  end
  else
    result := Trade.Ticker;
end;

procedure TTLFileDataSource.DeleteRecord(ARecordHandle: TcxDataRecordHandle);
begin
  FFile.DeleteTrade(FFile.Trade[Integer(ARecordHandle)]);
  DataChanged;
end;

procedure TTLFileDataSource.EditDisable;
begin
  FGridTableView.OptionsData.Editing:= false;
  FGridTableView.OptionsView.ShowEditButtons:= gsebNever;
end;

procedure TTLFileDataSource.EditEnable;
begin
  FGridTableView.OptionsData.Editing:= true;
  FGridTableView.OptionsSelection.CellSelect:= true;
  FGridTableView.OptionsView.ShowEditButtons:= gsebForFocusedRecord;
  FGridTableView.Controller.editingItem:= FGridTableView.Controller.FocusedItem;
end;

function TTLFileDataSource.GetRecordCount: Integer;
begin
  Result := FFile.Count
end;

function TTLFileDataSource.GetValue(ARecordHandle: TcxDataRecordHandle; AItemHandle: TcxDataItemHandle): Variant;
var
  Trade : TTLTrade;
  ColumnID : Integer;
  acctType : string;

  function getAcctType : string;
  begin
    if FFile.FileHeader[Trade.Broker].MTM then
      Result := 'M' //MTM
    else
    if FFile.FileHeader[Trade.Broker].Ira then
      Result := 'I' //IRA
    else
      Result := 'C'; //Cash
  end;

begin
  if Integer(ARecordHandle) < FFile.Count then
  begin
    Trade := FFile.Trade[Integer(ARecordHandle)];
    ColumnId := GetDefaultItemID(Integer(AItemHandle));
    //acctType := getAcctType;   // 2015-05-04 what the heck is this for????
    case ColumnID of
      0: Result := Trade.ID;
      1: Result := Trade.TradeNum;
      2: Result := Trade.Date;
      3: Result := Trade.Time;
      4: Result := Trade.OC;
      5: Result := Trade.LS;
      6: Result := Trade.Ticker;
      7: Result := Trade.Shares;
      8: Result := Trade.Price;
      9: Result := Trade.TypeMult;
      10: Result := Trade.Commission;
      11: Result := Trade.Amount;
      12: Result := Trade.PL;
      13: Result := Trade.Note;
      14: Result := Trade.Open;
      15: Result := Trade.Matched;
      16: Result := Trade.Broker;
      17: Result := Trade.OptionTicker;
      18: Result := FormatTKSort(Trade.Ticker, Trade.TypeMult, '');
      19: Result := Trade.Strategy;
      20: Result := Trade.ABCCode;
      21: Result := getAcctType;    // 2015-05-04 this is where this should be
      22: begin
            if Trade.WSHoldingDate > 0 then
              Result := Trade.WSHoldingDate
            else
              Result := Null;
          end;
      23: Result := FormatMatchedSort(Trade.Matched);
      24: Result := getUnderlying(Trade);
    end;
    //acctType := getAcctType;   // 2015-05-04 what the heck is this for????
  end;
end;

function TTLFileDataSource.InsertRecord(ARecordHandle: TcxDataRecordHandle): TcxDataRecordHandle;
var
  RecNum : Integer;
  Trade : TTLTrade;
begin
  RecNum := Integer(ARecordHandle);
  Trade := TTLTrade.Create;

  FFile.InsertTrade(RecNum, Trade);

  if FFile.count > RecNum then
  begin
    Trade.TradeNum:= FFile[RecNum + 1].TradeNum;
    Trade.Date:= FFile[RecNum+1].Date;
    Trade.OC:= 'O';
    Trade.LS:= FFile[RecNum + 1].LS;
    Trade.Ticker:= FFile[RecNum + 1].Ticker;
    Trade.Broker := TradeLogFile.CurrentAccount.BrokerID;
  end;

  Result := TcxDataRecordHandle(ARecordHandle);
  DataChanged;
  EditEnable;
end;

procedure TTLFileDataSource.SetValue(ARecordHandle: TcxDataRecordHandle; AItemHandle: TcxDataItemHandle;
  const AValue: Variant);
var
  Trade : TTLTrade;
  AColumnId: Integer;
begin
  AColumnId := GetDefaultItemID(Integer(AItemHandle));
  Trade := FFile.Trade[Integer(ARecordHandle)];
  case AColumnId of
    1: begin
         if not VarIsNull(Avalue) then
           Trade.TradeNum := AValue;
       end;
    2: begin
         if not VarIsNull(Avalue) then
           Trade.Date := AValue;
       end;
    3: begin
         if VarIsNull(Avalue) then
           Trade.Time := ''
         else
           Trade.Time := AValue;
       end;
    4: Trade.OC := VarToStr(AValue)[1];
    5: Trade.LS := VarToStr(AValue)[1];
    6: Trade.Ticker := AValue;
    7: begin
        if Not VarIsNull(AValue) then
          Trade.Shares := AValue
        else
          Trade.Shares := 0;
       end;
    8: begin
         if Not VarIsNull(Avalue) then
          Trade.Price := AValue
         else
          Trade.Price := 0;
        end;
    9: Trade.TypeMult := AValue;
    10: begin
         if Not VarIsNull(Avalue) then
           Trade.Commission := AValue
         else
           Trade.Commission := 0;
        end;
    11: begin
         if Not VarIsNull(Avalue) then
          Trade.Amount := AValue
         else
          Trade.Amount := 0;
        end;
    12: begin
          //PL is read only so it cannot be updated.
        end;
    13: begin
          if VarIsNull(Avalue) then
            Trade.Note := ''
          else
            Trade.Note := AValue;
        end;
    14: begin end;//Another field that is read only Trade.open := AValue;
    15: begin
          if VarIsNull(Avalue) then
            Trade.Matched := ''
          else
            Trade.Matched := AValue;
        end;
    16: Trade.Broker := AValue;
    17: Trade.OptionTicker := AValue;
    18: begin end;//Another read only property so no need to do anything Trade.tkSort := AValue;
    19: begin
          if VarIsNull(Avalue) then
            Trade.Strategy := ''
          else
            Trade.Strategy := AValue;
        end;
    20: begin
          if VarIsNull(AValue) then
            Trade.ABCCode := ' '
          else
            Trade.ABCCode := VarToStr(AValue); //[1];
        end;
    21: begin end; //Read only type field for IRA, Cash, MTM. do not change this one.
    22: begin
          if not VarIsNull(AValue) then
            Trade.WSHoldingDate := AValue;
        end;
  end;
end;

function TTLFileDataSource.AppendRecord: TcxDataRecordHandle;
var
  Trade : TTLTrade;
  I, RecNum, LastRecNum: Integer;
  Shares : Double;
  YrEnd : TDate;
begin
  Trade := TTLTrade.Create;
  // If we are still in the current tax year then use today's date otherwise
  // if we are in a previous TaxYear file use the end of year date as default
  YrEnd := StrToDate('12/31/' + IntToStr(TradeLogFile.TaxYear),Settings.InternalFmt);
  if Date >  YrEnd then
    Trade.Date := YrEnd
  else
    Trade.Date := Date;
  // If we have records in the Grid already, let's try and figure out what they will
  // enter next; e.g. if the grid is filtered and shares for the filter are greater
  // than zero, assume they're entering a closing record for all the filtered trades.
  //
  // If the grid is not filtered then just assume we are closing the last record.
  // Or if we are Entering Begin Prices then create an Open Record.
  if FGridTableView.DataController.RowCount > 0 then
    LastRecNum:= FGridTableView.DataController.GetRowInfo(FGridTableView.DataController.RowCount - 1).recordIndex
  else
    LastRecNum := -1;
  // If we are filtered with something other than just the WashSale Filter
  // or the broker filter, then let's add up the shares for the filter
  // and use this as the beginning value for the Shares field of the new record
  Shares := 0;
  if (Length(GetFilterCaption) > 0) //
  and Not EnteringBeginYearPrice //
  and (LastRecNum > -1) then begin
    for I := 0 to FGridTableView.DataController.FilteredRecordCount - 1 do begin
      if FGridTableView.DataController.Values[FGridTableView.DataController.FilteredRecordIndex[I], 4] = 'O' then
        Shares := Shares + FGridTableView.DataController.Values[FGridTableView.DataController.FilteredRecordIndex[I], 7]
      else if FGridTableView.DataController.Values[FGridTableView.DataController.FilteredRecordIndex[I], 4] = 'C' then
        Shares := Shares - FGridTableView.DataController.Values[FGridTableView.DataController.FilteredRecordIndex[I], 7];
    end;
  end;
  // ----
  if (ABS(Shares) > NEARZERO) and (LastRecNum > -1)then begin // 2024-07-31 MB
//  if (Shares > 0) and (LastRecNum > -1)then begin
    Trade.Shares := Abs(Shares);
    Trade.TradeNum := TradeLogFile[LastRecNum].TradeNum;
    Trade.OC := 'C';
    Trade.LS := TradeLogFile[LastRecNum].LS;
    Trade.Ticker := TradeLogFile[LastRecNum].Ticker;
    Trade.TypeMult := TradeLogFile[LastRecNum].TypeMult;
    Trade.Broker := TradeLogFile.CurrentAccount.BrokerID;
  end
  else begin
    Trade.OC := 'O';
    Trade.LS := 'L';
    Trade.TypeMult := 'STK-1';
    Trade.TradeNum := TradeLogFile.TradeNums.NextTradeNum;
    Trade.Broker := TradeLogFile.CurrentAccount.BrokerID;
  end;
  // ----
  if EnteringBeginYearPrice then begin
    if TradeLogFile.CurrentAccount.MTM //
    and TradeLogFile.CurrentAccount.MTMLastYear then begin
      Trade.Date := StrToDate('01/01/' + TaxYear, Settings.InternalFmt);
      Trade.Time := '00:00:00';
    end
    else
      Trade.Date := StrToDate('12/31/' + LastTaxYear, Settings.InternalFmt);
  end;
  RecNum := FFile.AddTrade(Trade);
  Result := TcxDataRecordHandle(RecNum);
  DataChanged;
  EditEnable;
end;


// --------------------------
// TTLOpenTradesDataSource
// --------------------------

constructor TTLOpenTradesDataSource.Create(TradeNums: TTLTradeNumList;
  GridTableView: TcxGridTableView; AsOfDate : TDate);
begin
  FTradeNums := TradeNums;
  FAsOfDate := AsOfDate;
  FGridTableView := GridTableView;
end;

destructor TTLOpenTradesDataSource.Destroy;
begin
  {TradeNums.Free;
    For some reason this is hosing the Trade Num Objects in this list even though
     the list is set to OwnsObject = False. Must be an issue with TObjectList,
     So I guess we leak a little memory here.}
  inherited;
end;

function TTLOpenTradesDataSource.GetRecordCount: Integer;
begin
  Result := FTradeNums.Count;
end;

function TTLOpenTradesDataSource.GetValue(ARecordHandle: TcxDataRecordHandle;
  AItemHandle: TcxDataItemHandle): Variant;
var
  TradeNum : TTLTradeNum;
  ColumnID : Integer;
begin
  TradeNum := FTradeNums[Integer(ARecordHandle)];
  ColumnId := GetDefaultItemID(Integer(AItemHandle));
  case ColumnID of
    0: Result := TradeNum.TradeNum;
    1: Result := TradeNum.Ticker;
    2: Result := TradeNum.SharesAsOf[FAsOfDate];
    3: if TradeNum.LS = 'L' Then
         Result := 'Long'
       else
         Result := 'Short';
    4: Result := TradeNum.TypeMult;
    5: Result := FormatFloat('0.######', TradeNum.AveragePriceAsOf[FAsOfDate]);
    6: Result := TradeNum.LastDate;
    7: Result := FormatTkSort(TradeNum.Ticker,TradeNum.TypeMult,'');
    8: Result := FormatFloat('0.#####', TradeNum.AmountAsOf[FAsOfDate]);
    9: Result := TradeNum.OptionTicker;
  end;
end;


// --------------------------
// TTLTradesDataSource
// --------------------------

constructor TTLTradesDataSource.Create(TradeList: TTradeList);
begin
  FTrades := TradeList;
end;

destructor TTLTradesDataSource.Destroy;
begin
  FTrades.FreeAll;
  inherited;
end;

function TTLTradesDataSource.GetRecordCount: Integer;
begin
  Result := FTrades.Count;
end;

function TTLTradesDataSource.GetValue(ARecordHandle: TcxDataRecordHandle;
  AItemHandle: TcxDataItemHandle): Variant;
var
  Trade : TTLTrade;
  ColumnID : Integer;
begin
  Trade := FTrades[Integer(ARecordHandle)];
  ColumnId := GetDefaultItemID(Integer(AItemHandle));
  case ColumnID of
    0: Result := Trade.ID;
    1  : Result := Trade.TradeNum;
    2  : Result := Trade.Date;
    3  : Result := Trade.Time;
    4  : Result := Trade.OC;
    5  : Result := Trade.LS;
    6  : Result := Trade.Ticker;
    7  : Result := Trade.Shares;
    8  : Result := Trade.Price;
    9  : Result := Trade.TypeMult;
    10 : Result := Trade.Commission;
    11 : Result := Trade.Amount;
    12 : Result := Trade.PL;
    13 : Result := Trade.Note;
    14 : Result := Trade.Open;
    15 : Result := Trade.Matched;
    16 : Result := Trade.Broker;
    17 : Result := Trade.OptionTicker;
    18 : Result := FormatTKSort(Trade.Ticker, Trade.TypeMult,'');
    19 : Result := Trade.Strategy;
    20 : Result := Trade.ABCCode;
  end;
end;

end.
