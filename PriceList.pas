unit PriceList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Generics.Collections, Generics.Defaults, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, StdCtrls,
  cxTextEdit, cxCurrencyEdit, ComCtrls, ExtCtrls, Grids, RzGrids, DB, DBClient, DBGrids, RzDBGrid, MidasLib;

type

  TPrice = packed record
    Ticker : String;
    Price : Double;
    I : Integer;
  end;

  TPriceList = TList<TPrice>;

  TdlgPriceList = class(TForm)
    pnlMain: TPanel;
    Label1: TLabel;
    btnOK: TButton;
    btnCancel: TButton;
    grdPrices: TRzDBGrid;
    cdsPriceList: TClientDataSet;
    dsPriceList: TDataSource;
    procedure btnOKClick(Sender: TObject);
    procedure cdsPriceListNewRecord(DataSet: TDataSet);
    procedure grdPricesKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
 private
    { Private declarations }
    FLoading : Boolean;
    constructor Create(AOwner: TComponent); overload;

  public
    { Public declarations }
    constructor Create; reintroduce; overload;
    class function Execute(var PriceList : TPriceList) : TModalResult;
    class function GenerateSection481Prices : Boolean;
  end;


var
  dlgPriceList: TdlgPriceList;

implementation

{$R *.dfm}

uses TLSettings, FuncProc, TLFile, TLCommonLib, RecordClasses, Clipbrd;

{ TForm1 }

constructor TdlgPriceList.Create(AOwner: TComponent);
begin
  inherited;
end;


procedure TdlgPriceList.btnOKClick(Sender: TObject);
begin
  cdsPriceList.First;
  while not cdsPriceList.eof do begin
    if Length(cdsPriceList.FieldByName('Price').AsString) = 0 then begin
      mDlg('You must enter all prices before continuing.', mtError, [mbOK], 0);
      modalResult := mrNone;
      break;
    end;
    cdsPriceList.Next;
  end;
end;


procedure TdlgPriceList.cdsPriceListNewRecord(DataSet: TDataSet);
begin
  if Not FLoading then DataSet.Cancel;
end;


constructor TdlgPriceList.Create;
begin
  raise Exception.Create('Constructor Disabled, Use Execute Class Method Instead.')
end;


class function TdlgPriceList.Execute(var PriceList : TPriceList): TModalResult;
var
  I : Integer;
  Item: TListItem;
  Price : TPrice;
begin
  With create(Application.MainForm) do begin
    FLoading := True;
    cdsPriceList.CreateDataSet;
    cdsPriceList.Active := True;
    grdPrices.Columns[0].FieldName := 'Ticker';
    grdPrices.Columns[1].FieldName := 'Price';
//    PriceList.Sort; // 2022-01-21 MB
    for I := 0 to PriceList.Count - 1 do begin
      cdsPriceList.Append;
      cdsPriceList.FieldByName('Ticker').AsString := PriceList[I].Ticker;
      cdsPriceList.FieldByName('I').AsInteger := PriceList[I].I;
      if PriceList[i].Price <> -1 then
        cdsPriceList.FieldByName('Price').AsFloat := PriceList[I].Price;
      cdsPriceList.Post;
    end;
    cdsPriceList.IndexFieldNames := 'Ticker'; // 2022-01-21 MB
    FLoading := False;
    cdsPriceList.First;
    Result := showModal;
    if Result = mrOk then begin
      cdsPriceList.First;
      I := 0;
      PriceList.Clear;
      while not cdsPriceList.Eof do begin
        FillChar(Price, SizeOf(Price), 0);
        Price.Price := cdsPriceList.FieldByName('Price').AsFloat;
        Price.Ticker := cdsPriceList.FieldByName('Ticker').AsString;
        Price.I := cdsPriceList.FieldByName('I').AsInteger;
        PriceList.Add(Price);
        cdsPriceList.Next;
      end;
    end;
  end;
end;


procedure TdlgPriceList.FormShow(Sender: TObject);
begin
  //set focus on price
  cdsPriceList.Fields.Fields[2].FocusControl;
end;


class function TdlgPriceList.GenerateSection481Prices : Boolean;
var
  I : Integer;
  OpenTrades : TTLTradeNumList;
  PriceList : TPriceList;
  Price : TPrice;
  LookupResult : Double;
begin
  if TradeLogFile.CurrentBrokerID = 0 then
    raise ETLFileException.Create('A Current Broker must be selected in order to generate Section 481 entries.');
  Result := True;
  {Look at all Open Records as of 12/31 of Last Tax Year and make sure a Closing M record exists as
    well as an opening record with same price on 1/1/Current Tax Year}
  PriceList := TPriceList.Create;
  {Open Positions as of 12/31 Last Tax Year need to have closing M Records}
  if TradeLogFile.CurrentAccount.MTMLastYear then
    OpenTrades := TradeLogFile.OpenPositions[xStrToDate('01/01/' + IntToStr(TradeLogFile.TaxYear))]
  else
    OpenTrades := TradeLogFile.OpenPositions[xStrToDate('12/31/' + IntToStr(TradeLogFile.LastTaxYear))];
  //
  if OpenTrades.Count > 0 then begin
    for I := 0 to OpenTrades.Count - 1 do begin
      if TradeLogFile.CurrentAccount.MTMLastYear
      and (OpenTrades[I].OpeningMTMRecord = nil)
      then continue;
      FillChar(Price, SizeOf(Price), 0);
      Price.Ticker := OpenTrades[I].Ticker;
      LookupResult := getYearEndMTMprice(OpenTrades[I].Ticker, OpenTrades[I].TypeMult, True);
      Price.Price := LookupResult;
      Price.I := I;
      PriceList.Add(Price);
    end;
    {Generate Close Records and new Open Records.}
    if TdlgPriceList.Execute(PriceList) <> mrOK then begin
      Result := False;
      exit;
    end;
    for I := 0 to PriceList.Count - 1 do
      OpenTrades[PriceList[I].I].UpdateSection481(PriceList[I].Price);
    //TradeLogFile.MatchAndReorganize;
  end;
end;


procedure TdlgPriceList.grdPricesKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if key = 27 then btnCancel.Click;
end;


end.
