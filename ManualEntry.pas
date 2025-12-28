unit ManualEntry;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, cxNavigator, Data.DB, cxDBData, cxCalendar, cxTimeEdit,
  cxDropDownEdit, dxmdaset, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxClasses, cxGridCustomView, cxGrid, dxRibbonSkins,
  dxSkinsdxRibbonPainter, dxSkinsdxBarPainter, cxCheckGroup, cxCheckBox,
  cxLabel, cxImage, cxCheckComboBox, dxBarExtItems, dxBar, cxBarEditItem,
  dxRibbon, StrUtils, cxTextEdit, cxSpinEdit, cxCurrencyEdit, cxContainer,
  cxGroupBox, cxRadioGroup, Vcl.ExtCtrls, Vcl.Menus, Vcl.StdCtrls, cxButtons,
  ClipBrd, cxTL;

type
  TfManualEntry = class(TForm)
    Grid: TcxGrid;
    Table: TcxGridDBTableView;
    TableRecId: TcxGridDBColumn;
    Date: TcxGridDBColumn;
    TableTime: TcxGridDBColumn;
    TableOC: TcxGridDBColumn;
    TableLS: TcxGridDBColumn;
    TableTicker: TcxGridDBColumn;
    TableShr: TcxGridDBColumn;
    TablePrice: TcxGridDBColumn;
    TableComm: TcxGridDBColumn;
    TableType: TcxGridDBColumn;
    TableMult: TcxGridDBColumn;
    TableRate: TcxGridDBColumn;
    GridLevel1: TcxGridLevel;
    Trades: TdxMemData;
    TradesDate: TStringField;
    TradesTime: TStringField;
    TradesOC: TStringField;
    TradesLS: TStringField;
    TradesTicker: TStringField;
    TradesShr: TStringField;
    TradesPrice: TCurrencyField;
    TradesComm: TCurrencyField;
    TradesType: TStringField;
    TradesMult: TFloatField;
    TradesRate: TFloatField;
    dsTrades: TDataSource;
    dxBarManager1: TdxBarManager;
    bbClear: TdxBarLargeButton;
    bbSimple: TdxBarLargeButton;
    bbAdvanced: TdxBarLargeButton;
    bbTicker: TdxBarLargeButton;
    bbTrade: TdxBarLargeButton;
    bbStrategy: TdxBarLargeButton;
    dxBarLargeButton7: TdxBarLargeButton;
    bbNote: TdxBarButton;
    bbDuplicate: TdxBarButton;
    bbValidOption: TdxBarButton;
    bbStocks: TdxBarButton;
    bbOptions: TdxBarButton;
    bbMutualFunds: TdxBarButton;
    bbETNETFs: TdxBarButton;
    bbFutures: TdxBarButton;
    bbCurrency: TdxBarButton;
    bbVTNs: TdxBarButton;
    bbCTNs: TdxBarButton;
    bbDigitalCurrency: TdxBarButton;
    bbDrips: TdxBarButton;
    dxBarButton14: TdxBarButton;
    dxBarButton15: TdxBarButton;
    beAccounts: TcxBarEditItem;
    beMatched: TcxBarEditItem;
    bbNew: TdxBarButton;
    beMTM: TcxBarEditItem;
    beIRA: TcxBarEditItem;
    beCash: TcxBarEditItem;
    beExerciseAssigns: TcxBarEditItem;
    beMatchedTaxLots: TcxBarEditItem;
    beViewTime: TcxBarEditItem;
    beViewOptionTk: TcxBarEditItem;
    beViewStrategy: TcxBarEditItem;
    beViewMatched: TcxBarEditItem;
    beViewWSHoldDt: TcxBarEditItem;
    beViewNotes: TcxBarEditItem;
    beView8949Code: TcxBarEditItem;
    beViewWashSales: TcxBarEditItem;
    bbRecordsAdd: TdxBarLargeButton;
    bbRecordsInsert: TdxBarLargeButton;
    bbRecordsEdit: TdxBarLargeButton;
    bbRecordsDelete: TdxBarLargeButton;
    bbRecordsDeleteAll: TdxBarLargeButton;
    bbRecordsCut: TdxBarLargeButton;
    bbRecordsCopy: TdxBarLargeButton;
    bbRecordsPaste: TdxBarLargeButton;
    bbRecordsSelectAll: TdxBarLargeButton;
    bbEditLongShort: TdxBarLargeButton;
    bbEditStrategy: TdxBarLargeButton;
    bbEditTicker: TdxBarLargeButton;
    bbEditABCcode: TdxBarLargeButton;
    bbAccountAdd: TdxBarLargeButton;
    bbAccountBaseline: TdxBarLargeButton;
    bbAccountEdit: TdxBarLargeButton;
    bbAccountDelete: TdxBarLargeButton;
    bbAccountTransfer: TdxBarLargeButton;
    bbAccountChecklist: TdxBarLargeButton;
    bbAdjustCost: TdxBarLargeButton;
    bbAdjustCorporateAction: TdxBarLargeButton;
    bbAdjustExercise: TdxBarLargeButton;
    bbAdjustExpire: TdxBarLargeButton;
    bbMatchLot: TdxBarLargeButton;
    bbUnMatch: TdxBarLargeButton;
    bbMatchOrder: TdxBarLargeButton;
    bbMatchLS: TdxBarLargeButton;
    bbMatchForce: TdxBarLargeButton;
    bbReMatch: TdxBarLargeButton;
    bbMatchCalcWS: TdxBarLargeButton;
    dxBarLargeButton9: TdxBarLargeButton;
    dxBarLargeButton10: TdxBarLargeButton;
    beMatchWsShortNLong: TcxBarEditItem;
    cxBarEditItem2: TcxBarEditItem;
    beMatchWsUnderlying: TcxBarEditItem;
    dxBarSubItem1: TdxBarSubItem;
    beMatchWsClosedTrig: TcxBarEditItem;
    cxBarEditItem5: TcxBarEditItem;
    beMatchWsOpt2Stk: TcxBarEditItem;
    beMatchWsSTK2Opt: TcxBarEditItem;
    bbImportBaseLine: TdxBarLargeButton;
    bbImportAuto: TdxBarLargeButton;
    bbImportFile: TdxBarLargeButton;
    bbImportWeb: TdxBarLargeButton;
    bbImportExcel: TdxBarLargeButton;
    bbUndo_small: TdxBarButton;
    bbRedo_small: TdxBarButton;
    dxBarLargeButton1: TdxBarLargeButton;
    dxBarLargeButton2: TdxBarLargeButton;
    dxBarLargeButton3: TdxBarLargeButton;
    dxBarLargeButton4: TdxBarLargeButton;
    bbOptons: TdxBarButton;
    dxBarButton1: TdxBarButton;
    bbExit: TdxBarButton;
    bbNewOptions: TdxBarButton;
    dxBarButton2: TdxBarButton;
    dxBarLargeButton5: TdxBarLargeButton;
    dxBarLargeButton6: TdxBarLargeButton;
    dxBarLargeButton8: TdxBarLargeButton;
    dxBarLargeButton11: TdxBarLargeButton;
    dxBarLargeButton12: TdxBarLargeButton;
    dxBarLargeButton13: TdxBarLargeButton;
    dxBarLargeButton14: TdxBarLargeButton;
    dxBarLargeButton15: TdxBarLargeButton;
    dxBarLargeButton16: TdxBarLargeButton;
    dxBarLargeButton17: TdxBarLargeButton;
    dxBarLargeButton18: TdxBarLargeButton;
    dxBarLargeButton19: TdxBarLargeButton;
    dxBarLargeButton20: TdxBarLargeButton;
    dxBarLargeButton21: TdxBarLargeButton;
    dxBarLargeButton22: TdxBarLargeButton;
    dxBarLargeButton23: TdxBarLargeButton;
    dxBarLargeButton24: TdxBarLargeButton;
    dxBarLargeButton25: TdxBarLargeButton;
    dxBarLargeButton26: TdxBarLargeButton;
    dxBarLargeButton27: TdxBarLargeButton;
    cxBarEditItem1: TcxBarEditItem;
    dxBarButton3: TdxBarButton;
    dxBarDateCombo1: TdxBarDateCombo;
    dxBarSubItem2: TdxBarSubItem;
    dxBarButton4: TdxBarButton;
    cxBarEditItem3: TcxBarEditItem;
    cxBarEditItem4: TcxBarEditItem;
    dxBarEdit1: TdxBarEdit;
    dxBarLargeButton28: TdxBarLargeButton;
    dxBarLargeButton29: TdxBarLargeButton;
    dxBarLargeButton30: TdxBarLargeButton;
    dxBarLargeButton31: TdxBarLargeButton;
    dxBarLargeButton32: TdxBarLargeButton;
    dxBarLargeButton33: TdxBarLargeButton;
    dxBarLargeButton34: TdxBarLargeButton;
    dxBarLargeButton35: TdxBarLargeButton;
    dxBarLargeButton36: TdxBarLargeButton;
    dxBarLargeButton37: TdxBarLargeButton;
    dxBarLargeButton38: TdxBarLargeButton;
    dxBarLargeButton39: TdxBarLargeButton;
    dxBarLargeButton40: TdxBarLargeButton;
    dxBarLargeButton41: TdxBarLargeButton;
    dxBarLargeButton42: TdxBarLargeButton;
    dxBarLargeButton43: TdxBarLargeButton;
    dxBarLargeButton44: TdxBarLargeButton;
    dxBarLargeButton45: TdxBarLargeButton;
    dxBarLargeButton47: TdxBarLargeButton;
    dxBarLargeButton49: TdxBarLargeButton;
    bbFile_Save: TdxBarLargeButton;
    bbFile_Edit: TdxBarLargeButton;
    dxBarLargeButton52: TdxBarLargeButton;
    bbFile_EndTaxYear: TdxBarLargeButton;
    bbFile_ReverseEndYear: TdxBarLargeButton;
    btnLastFile1: TdxBarButton;
    btnLastFile2: TdxBarButton;
    btnLastFile3: TdxBarButton;
    btnLastFile4: TdxBarButton;
    dxBarLargeButton56: TdxBarLargeButton;
    dxBarLargeButton57: TdxBarLargeButton;
    dxBarLargeButton58: TdxBarLargeButton;
    dxBarLargeButton60: TdxBarLargeButton;
    dxBarLargeButton61: TdxBarLargeButton;
    dxBarLargeButton62: TdxBarLargeButton;
    dxBarLargeButton68: TdxBarLargeButton;
    dxBarLargeButton69: TdxBarLargeButton;
    dxBarLargeButton74: TdxBarLargeButton;
    dxBarLargeButton76: TdxBarLargeButton;
    dxBarLargeButton78: TdxBarLargeButton;
    dxBarLargeButton79: TdxBarLargeButton;
    dxBarLargeButton80: TdxBarLargeButton;
    dxBarLargeButton82: TdxBarLargeButton;
    dxBarLargeButton83: TdxBarLargeButton;
    dxBarLargeButton85: TdxBarLargeButton;
    dxBarLargeButton86: TdxBarLargeButton;
    dxBarLargeButton87: TdxBarLargeButton;
    dxBarLargeButton88: TdxBarLargeButton;
    dxBarLargeButton89: TdxBarLargeButton;
    dxBarLargeButton90: TdxBarLargeButton;
    dxBarLargeButton91: TdxBarLargeButton;
    dxBarLargeButton92: TdxBarLargeButton;
    dxBarLargeButton93: TdxBarLargeButton;
    dxBarLargeButton95: TdxBarLargeButton;
    dxBarLargeButton96: TdxBarLargeButton;
    dxBarLargeButton97: TdxBarLargeButton;
    dxBarLargeButton98: TdxBarLargeButton;
    dxBarSubItem3: TdxBarSubItem;
    dxBarLargeButton99: TdxBarLargeButton;
    dxBarLargeButton100: TdxBarLargeButton;
    dxBarLargeButton101: TdxBarLargeButton;
    dxBarLargeButton102: TdxBarLargeButton;
    dxBarLargeButton103: TdxBarLargeButton;
    dxBarLargeButton104: TdxBarLargeButton;
    dxBarLargeButton105: TdxBarLargeButton;
    dxBarLargeButton106: TdxBarLargeButton;
    dxBarLargeButton107: TdxBarLargeButton;
    dxBarLargeButton108: TdxBarLargeButton;
    dxBarLargeButton112: TdxBarLargeButton;
    dxBarLargeButton113: TdxBarLargeButton;
    dxBarLargeButton114: TdxBarLargeButton;
    dxBarLargeButton115: TdxBarLargeButton;
    dxBarLargeButton116: TdxBarLargeButton;
    dxBarLargeButton117: TdxBarLargeButton;
    dxBarLargeButton118: TdxBarLargeButton;
    dxBarLargeButton119: TdxBarLargeButton;
    dxBarLargeButton120: TdxBarLargeButton;
    dxBarLargeButton121: TdxBarLargeButton;
    dxBarLargeButton122: TdxBarLargeButton;
    dxBarLargeButton123: TdxBarLargeButton;
    dxBarLargeButton124: TdxBarLargeButton;
    dxBarButton13: TdxBarButton;
    dxBarButton16: TdxBarButton;
    dxBarButton17: TdxBarButton;
    dxBarButton18: TdxBarButton;
    dxBarButton19: TdxBarButton;
    dxBarButton20: TdxBarButton;
    dxBarButton21: TdxBarButton;
    dxBarButton22: TdxBarButton;
    dxBarButton23: TdxBarButton;
    dxBarButton24: TdxBarButton;
    dxBarButton25: TdxBarButton;
    dxBarButton26: TdxBarButton;
    dxBarButton27: TdxBarButton;
    dxBarButton28: TdxBarButton;
    dxBarButton29: TdxBarButton;
    dxBarLargeButton125: TdxBarLargeButton;
    dxBarLargeButton126: TdxBarLargeButton;
    dxBarLargeButton127: TdxBarLargeButton;
    dxBarLargeButton128: TdxBarLargeButton;
    dxBarLargeButton129: TdxBarLargeButton;
    dxBarLargeButton130: TdxBarLargeButton;
    dxBarLargeButton131: TdxBarLargeButton;
    dxBarLargeButton132: TdxBarLargeButton;
    dxBarLargeButton133: TdxBarLargeButton;
    dxBarLargeButton134: TdxBarLargeButton;
    dxBarLargeButton137: TdxBarLargeButton;
    dxBarLargeButton138: TdxBarLargeButton;
    dxBarLargeButton141: TdxBarLargeButton;
    dxBarLargeButton142: TdxBarLargeButton;
    dxBarLargeButton143: TdxBarLargeButton;
    dxBarLargeButton144: TdxBarLargeButton;
    dxBarLargeButton146: TdxBarLargeButton;
    dxBarLargeButton147: TdxBarLargeButton;
    cxBarEditItem6: TcxBarEditItem;
    chViewMatched: TcxBarEditItem;
    chViewNotes: TcxBarEditItem;
    chViewOptionTickers: TcxBarEditItem;
    chViewStrategies: TcxBarEditItem;
    chViewTime: TcxBarEditItem;
    chViewWashSales: TcxBarEditItem;
    chViewQuickStart: TcxBarEditItem;
    cxBarEditItem14: TcxBarEditItem;
    chViewAdjust: TcxBarEditItem;
    chViewWashSaleHoldings: TcxBarEditItem;
    dxBarButton30: TdxBarButton;
    dxBarLargeButton148: TdxBarLargeButton;
    dxBarLargeButton149: TdxBarLargeButton;
    bbUndo_Large: TdxBarLargeButton;
    bbRedo_Large: TdxBarLargeButton;
    dxBarSubItem4: TdxBarSubItem;
    cxBarEditItem17: TcxBarEditItem;
    cxBarEditItem18: TcxBarEditItem;
    cxBarEditItem19: TcxBarEditItem;
    dxBarCombo1: TdxBarCombo;
    cxBarEditItem20: TcxBarEditItem;
    cxBarEditItem21: TcxBarEditItem;
    cxBarEditItem22: TcxBarEditItem;
    cxBarEditItem23: TcxBarEditItem;
    dxBarButton31: TdxBarButton;
    dxBarButton32: TdxBarButton;
    dxBarButton33: TdxBarButton;
    dxBarLargeButton152: TdxBarLargeButton;
    dxBarLargeButton153: TdxBarLargeButton;
    dxBarLargeButton154: TdxBarLargeButton;
    dxBarButton36: TdxBarButton;
    dxBarButton37: TdxBarButton;
    dxBarButton38: TdxBarButton;
    dxBarStatic1: TdxBarStatic;
    btnBaseline: TdxBarLargeButton;
    btnFromFile: TdxBarLargeButton;
    btnFromWeb: TdxBarLargeButton;
    btnFromExcel: TdxBarLargeButton;
    dxBarButton43: TdxBarButton;
    dxBarLargeButton48: TdxBarLargeButton;
    dxBarLargeButton50: TdxBarLargeButton;
    dxBarLargeButton51: TdxBarLargeButton;
    cxBarEditItem24: TcxBarEditItem;
    cbFindAdjusted: TdxBarCombo;
    cbFindErrorCheck: TdxBarCombo;
    cbFindAccounts: TdxBarCombo;
    dxBarLargeButton53: TdxBarLargeButton;
    btnViewWashSales: TdxBarButton;
    btnViewQuickStart: TdxBarButton;
    dxBarLargeButton54: TdxBarLargeButton;
    btnRecordsEdit: TdxBarLargeButton;
    btnRecordsSplitTrade: TdxBarLargeButton;
    btnRecordsConsolidatePartialFills: TdxBarLargeButton;
    dxBarLargeButton55: TdxBarLargeButton;
    dxBarLargeButton94: TdxBarLargeButton;
    dxBarLargeButton109: TdxBarLargeButton;
    dxBarLargeButton150: TdxBarLargeButton;
    btnRecordsDelete: TdxBarLargeButton;
    btnRecordsDeleteAll: TdxBarLargeButton;
    btnEditEdit: TdxBarLargeButton;
    dxBarLargeButton63: TdxBarLargeButton;
    btnEditTicker: TdxBarLargeButton;
    dxBarLargeButton66: TdxBarLargeButton;
    dxBarLargeButton67: TdxBarLargeButton;
    dxImportSettings: TdxBarLargeButton;
    dxBrokerConnect: TdxBarLargeButton;
    dxBarLargeButton71: TdxBarLargeButton;
    dxBarLargeButton46: TdxBarLargeButton;
    dxBarLargeButton59: TdxBarLargeButton;
    dxBarListItem1: TdxBarListItem;
    dxBarLargeButton72: TdxBarLargeButton;
    dxBarLargeButton73: TdxBarLargeButton;
    dxBarLargeButton75: TdxBarLargeButton;
    dxBarButton7: TdxBarButton;
    dxBarLargeButton77: TdxBarLargeButton;
    dxBarButton8: TdxBarButton;
    dxBtnWSsettings: TdxBarLargeButton;
    checkbox: TcxBarEditItem;
    dxBarButton5: TdxBarButton;
    dxBarLargeButton81: TdxBarLargeButton;
    dxBarLargeButton84: TdxBarLargeButton;
    mruLastFile: TdxBarMRUListItem;
    dxBarLargeButton64: TdxBarLargeButton;
    dxBarLargeButton65: TdxBarLargeButton;
    dxBarLargeButton70: TdxBarLargeButton;
    cbFindInstrament: TcxBarEditItem;
    dxBarListItem2: TdxBarListItem;
    dxBarListItem3: TdxBarListItem;
    chInstrument2: TcxBarEditItem;
    cxBarEditItem8: TcxBarEditItem;
    lblInstrument: TcxBarEditItem;
    chInstrument: TcxBarEditItem;
    Panel2: TPanel;
    btnImport: TcxButton;
    btnCancel: TcxButton;
    cxStyleRepository1: TcxStyleRepository;
    TradesId: TAutoIncField;
    cxStyle1: TcxStyle;
    cxStyle2: TcxStyle;
    cxStyle3: TcxStyle;
    cxStyle4: TcxStyle;
    cxStyle5: TcxStyle;
    cxStyle6: TcxStyle;
    cxStyle7: TcxStyle;
    cxStyle8: TcxStyle;
    cxStyle9: TcxStyle;
    cxStyle10: TcxStyle;
    cxStyle11: TcxStyle;
    cxStyle12: TcxStyle;
    cxStyle13: TcxStyle;
    GridTableViewStyleSheetDevExpress: TcxGridTableViewStyleSheet;
    cxStyle14: TcxStyle;
    cxStyle15: TcxStyle;
    cxStyle16: TcxStyle;
    cxStyle17: TcxStyle;
    cxStyle18: TcxStyle;
    cxStyle19: TcxStyle;
    cxStyle20: TcxStyle;
    cxStyle21: TcxStyle;
    cxStyle22: TcxStyle;
    cxStyle23: TcxStyle;
    cxStyle24: TcxStyle;
    cxStyle25: TcxStyle;
    cxStyle26: TcxStyle;
    cxStyle27: TcxStyle;
    procedure FormCreate(Sender: TObject);
    procedure btnImportClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure TradesNewRecord(DataSet: TDataSet);
    procedure TradesBeforePost(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FDate : string;
    FComponent : string;
    FMessageSL : TStringList;
    function CheckMissingFields : string;
    function ErrorInRowsFound : boolean;
    function ImportCSV : boolean;
    procedure ErrorRowsMessage;
    procedure EnterJunk;
  public
    { Public declarations }
  end;

var
  fManualEntry: TfManualEntry;

implementation
uses Import, FuncProc;

{$R *.dfm}

procedure TfManualEntry.btnCancelClick(Sender: TObject);
begin
  close;
end;


procedure TfManualEntry.EnterJunk;
begin
  with Trades do begin
    Trades.FieldByName('Date').Value := now()-1;
    Trades.FieldByName('Time').Value := time();
  end;
end;

procedure TfManualEntry.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FMessageSL.Free;
end;

procedure TfManualEntry.FormCreate(Sender: TObject);
begin
  Trades.Open;
  Trades.Insert;
  EnterJunk;
  Date.FocusWithSelection;

  FMessageSL := TStringList.Create;
end;

procedure TfManualEntry.TradesBeforePost(DataSet: TDataSet);
var
  sMessage : string;
begin
  FDate := TradesDate.Value;
end;

procedure TfManualEntry.TradesNewRecord(DataSet: TDataSet);
begin
  TradesDate.Value := FDate;
end;

function TfManualEntry.CheckMissingFields : string;
var
  sMessage : string;
begin
    if TradesDate.Value = '' then
      sMessage := 'DATE, ';
    if TradesOC.Value = '' then
      sMessage := sMessage + 'OC, ';
    if TradesTicker.Value = '' then
      sMessage := sMessage + 'TICKER, ';
      if FComponent = '' then FComponent := 'TradesTicker';
    if TradesShr.Value = '' then
      sMessage := sMessage + 'SHR, ';
    if TradesPrice.Value = 0 then
      sMessage := sMessage + 'PRICE, ';
    if TradesComm.Value = 0 then
      sMessage := sMessage + 'COMM, ';
    if TradesType.Value = '' then
      sMessage := sMessage + 'TYPE, ';
    if TradesMult.Value = 0 then
      sMessage := sMessage + 'MULT ';

    if sMessage <> '' then  begin
      FMessageSL.Add('LINE: ' + IntToStr(TradesId.Value) +  ', ' + sMessage);

//      FComponent := 'Table'+trim(copy(sMessage, 1, AnsiPos(#13, sMessage)));
//      sMessage := 'Please fill in the following fields:' + #13 + #10 + #13 + #10 + 'LINE: ' + IntToStr(TradesId.Value) +  ', ' + sMessage;
    end;

    result := sMessage;
end;

function TfManualEntry.ErrorInRowsFound : boolean;
begin
  with Trades do begin
    First;
    while not eof do begin
      CheckMissingFields;
      Next;
    end;
  end;
  result := FMessageSL.Count > 0;
end;

procedure TfManualEntry.ErrorRowsMessage;
var
  tempString : string;
  I: Integer;
begin
  for I := 0 to FMessageSL.Count-1 do
    tempString := tempString + FMessageSL[i] + #13#10;
  if tempString.Length > 0 then
    mDlg('Please fix the following errors: ' + #13#10 + #13#10 + tempString, mtWarning, [mbOK], 0);

  FMessageSL.Clear;
end;

function TfManualEntry.ImportCSV : boolean;
begin
  result := false;
  if Trades.RecordCount > 0 then
    exit;

  if pos('Ticker', clipboard.AsText) > 0 then
    result := true;
end;

// Steps
// Step 1. Check if this is a CSV needs to be imported. if it is CSV go to Step 3
// Step 2. If not, then chekc the grid for erros
// Step 3. Call the ReadManualEntry from Import.pas
procedure TfManualEntry.btnImportClick(Sender: TObject);
var
  R : integer;
  bFromGrid : boolean;
begin
  bFromGrid := false;
  if not ImportCSV then begin // nothing in the Clipboard
    if ErrorInRowsFound then begin   // Search for missing ROW Field(s)
      ErrorRowsMessage;
      exit;
    end
    else begin
      TcxGridDBTableView(Grid.FocusedView).CopyToClipboard(True);
      bFromGrid := true;
    end;
  end;
  R := ReadManualEntry(bFromGrid); // True - date from Grid  False - data from CSV
  Close;
end;

end.
