unit frmOptionDialogTest;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, dxSkinsCore, dxSkinBasic, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkroom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMetropolis,
  dxSkinMetropolisDark, dxSkinMoneyTwins, dxSkinOffice2007Black,
  dxSkinOffice2007Blue, dxSkinOffice2007Green, dxSkinOffice2007Pink,
  dxSkinOffice2007Silver, dxSkinOffice2010Black, dxSkinOffice2010Blue,
  dxSkinOffice2010Silver, dxSkinOffice2013DarkGray, dxSkinOffice2013LightGray,
  dxSkinOffice2013White, dxSkinOffice2016Colorful, dxSkinOffice2016Dark,
  dxSkinOffice2019Black, dxSkinOffice2019Colorful, dxSkinOffice2019DarkGray,
  dxSkinOffice2019White, dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic,
  dxSkinSharp, dxSkinSharpPlus, dxSkinSilver, dxSkinSpringtime, dxSkinStardust,
  dxSkinSummer2008, dxSkinTheAsphaltWorld, dxSkinTheBezier,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinVisualStudio2013Blue,
  dxSkinVisualStudio2013Dark, dxSkinVisualStudio2013Light, dxSkinVS2010,
  dxSkinWhiteprint, dxSkinXmas2008Blue, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, cxNavigator, dxDateRanges,
  dxScrollbarAnnotations, Data.DB, cxDBData, cxTextEdit, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys,
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.VCLUI.Wait, FireDAC.Comp.Client, FireDAC.Comp.DataSet, Vcl.StdCtrls,
  Vcl.ExtCtrls, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxClasses, cxGridCustomView, cxGrid, Vcl.ComCtrls, cxMemo,
  cxDropDownEdit, dxNumericWheelPicker, cxCurrencyEdit, cxSpinEdit, cxContainer,
  cxLabel;

type
  TfrmOptionDialogTest = class(TForm)
    qry: TFDQuery;
    ds: TDataSource;
    qcnt: TFDQuery;
    Panel1: TPanel;
    btnCancel: TButton;
    btnOK: TButton;
    btnRestoreDefaults: TButton;
    Button1: TButton;
    btnAdd: TButton;
    tabPages: TPageControl;
    tabGlobal: TTabSheet;
    lblCtrlW: TLabel;
    lblCtrlT: TLabel;
    lblCtrlAltO: TLabel;
    lblCtrlAltM: TLabel;
    lblCtrlN: TLabel;
    lblCtrlAltS: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    lblCtrlQ: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    chkMTaxLots: TCheckBox;
    chkNotes: TCheckBox;
    chkOptTicks: TCheckBox;
    chkTime: TCheckBox;
    chkWSdefer: TCheckBox;
    splitLineBottom: THeader;
    Header1: THeader;
    chkStrategies: TCheckBox;
    chkAcct: TCheckBox;
    chkQS: TCheckBox;
    chk8949Code: TCheckBox;
    ckWSHoldingDate: TCheckBox;
    chkLegacyBC: TCheckBox;
    tabBroadBased: TTabSheet;
    grdBBIO: TcxGrid;
    tvBBIO: TcxGridDBTableView;
    tvBBIOTicker: TcxGridDBColumn;
    tvBBIOMultiplier: TcxGridDBColumn;
    tvBBIODescription: TcxGridDBColumn;
    tv2: TcxGridDBTableView;
    tv2id: TcxGridDBColumn;
    tv2ConfigList: TcxGridDBColumn;
    tv2Symbol: TcxGridDBColumn;
    tv2Multiplier: TcxGridDBColumn;
    tv2Description: TcxGridDBColumn;
    grdBBIOLevel1: TcxGridLevel;
    tabFutures: TTabSheet;
    grdFutures: TcxGrid;
    tvFutures: TcxGridDBTableView;
    tvFuturesSymbol: TcxGridDBColumn;
    tvFuturesMultiplier: TcxGridDBColumn;
    tvFuturesDescription: TcxGridDBColumn;
    cxGridDBTableView2: TcxGridDBTableView;
    cxGridDBColumn4: TcxGridDBColumn;
    cxGridDBColumn5: TcxGridDBColumn;
    cxGridDBColumn6: TcxGridDBColumn;
    cxGridDBColumn7: TcxGridDBColumn;
    cxGridDBColumn8: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    tabStrategies: TTabSheet;
    grdStrategy: TcxGrid;
    tvStrategy: TcxGridDBTableView;
    tvStrategyList: TcxGridDBColumn;
    cxGridDBTableView4: TcxGridDBTableView;
    cxGridDBColumn9: TcxGridDBColumn;
    cxGridDBColumn10: TcxGridDBColumn;
    cxGridDBColumn11: TcxGridDBColumn;
    cxGridDBColumn12: TcxGridDBColumn;
    cxGridDBColumn13: TcxGridDBColumn;
    cxGridLevel2: TcxGridLevel;
    tabMutFunds: TTabSheet;
    grdMut: TcxGrid;
    tvMut: TcxGridDBTableView;
    tvMutTicker: TcxGridDBColumn;
    tvMutDescription: TcxGridDBColumn;
    cxGridLevel3: TcxGridLevel;
    TabETNs: TTabSheet;
    grdETF: TcxGrid;
    tvETF: TcxGridDBTableView;
    tvETFTicker: TcxGridDBColumn;
    tvETFType: TcxGridDBColumn;
    tvETFDescription: TcxGridDBColumn;
    cxGridLevel4: TcxGridLevel;
    lblTab: TcxLabel;
    procedure tabPagesChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure qryBeforePost(DataSet: TDataSet);
    procedure qryAfterPost(DataSet: TDataSet);
    procedure btnRestoreDefaultsClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnAddClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    procedure UpdateSymbolCount;
    function TableRowCount(tbl: string): integer;
    procedure SetupScript(tbl: integer);
    procedure CreateConfigBBIO;
    procedure CreateConfig(sTableName: string);
    function TableExists(AConnection: TFDConnection; const ATableName: string): Boolean;

    procedure InsertIntoConfigBBIO;
    procedure InsertIntoConfigETF;
    procedure InsertIntoConfigFutures;
    procedure InsertIntoConfigMUTS;
    procedure InsertIntoConfigStrategy;

    function getCurrentTableAndView: TArray<string>;
  public
    class function Execute : TModalResult;
  end;

CONST
  _TAB_BBIO = 1;
  _TAB_FUTURES = 2;
  _TAB_STRATEGY = 3;
  _TAB_MUT = 4;
  _TAB_ETF = 5;

  _LABEL_BBIO = 'Index Option Symbols';
  _LABEL_FUTURES = 'Future Symbols';
  _LABEL_STRATEGY = 'Trade Strategies';
  _LABEL_MUT = 'Mutual Fund Symbols';
  _LABEL_ETF = 'ETF/ETN Symbol';

  _TABLE_BBIO = '_configBBIO';
  _TABLE_FUTURES = '_configFutures';
  _TABLE_MUT = '_configMUT';
  _TABLE_STRATEGY = '_configStrategy';
  _TABLE_ETF = '_configETF';

//var
//  xcx: TfrmOptionTest;

implementation

uses uDM, TLSettings, Main, TLFile;

{$R *.dfm}

function TfrmOptionTest.TableRowCount(tbl: string): integer;
begin
  with DM.qcnt do begin
    Close;
    SQL.Clear;
    SQL.Text := 'SELECT Count(*) AS cnt FROM ' + tbl;
    Active := true;
    Open;
    result := FieldByName('cnt').AsInteger;
    Close;
  end;
end;

procedure TfrmOptionTest.btnOKClick(Sender: TObject);
begin
  qry.Close;
end;

procedure TfrmOptionTest.btnRestoreDefaultsClick(Sender: TObject);
var
  tab: integer;
begin
    tab := tabPages.TabIndex;
    case tab of
      _TAB_BBIO:      begin CreateConfig(_TABLE_BBIO); InsertIntoConfigBBIO; end;
      _TAB_FUTURES:   begin CreateConfig(_TABLE_FUTURES); InsertIntoConfigFutures; end;
      _TAB_MUT:       begin CreateConfig(_TABLE_MUT); InsertIntoConfigMuts; end;
      _TAB_STRATEGY:  begin CreateConfig(_TABLE_STRATEGY); InsertIntoConfigStrategy; end;
      _TAB_ETF:       begin CreateConfig(_TABLE_ETF); InsertIntoConfigETF; end;
    end;
    qry.Active := true;
    showmessage('Restore Completed!');
end;

procedure TfrmOptionTest.Button1Click(Sender: TObject);
var
  View: TcxGridDBTableView;
  Arr: TArray<string>;
  SymbolValue: string;
  AItem: TcxCustomGridTableItem;
begin
  // 1. Get your dynamic names
  Arr := getCurrentTableAndView;
  View := Self.FindComponent(Arr[1]) as TcxGridDBTableView;

  if not Assigned(View) then Exit;

  if View.Controller.IsNewItemRowFocused then
  begin
    ShowMessage('You cannot delete the new item row.');
    Exit;
  end;

  // 1. Get the Column/Item based on the Field Name
  AItem := TcxCustomGridTableItem(View.DataController.GetItemByFieldName(Arr[2]));

  if Assigned(AItem) and (View.Controller.FocusedRecord <> nil) then
  begin
    // 2. USE THE RECORD OBJECT directly.
    // This is the most accurate way to get the displayed value.
    SymbolValue := VarToStr(View.Controller.FocusedRecord.Values[AItem.Index]);
  end
  else
    SymbolValue := 'Unknown';

  // 3. Confirmation Message
  if MessageDlg('Are you sure you want to delete this record: ' + SymbolValue + '?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    View.DataController.DeleteFocused;
  end;
end;

procedure TfrmOptionTest.btnAddClick(Sender: TObject);
var
  grid: TcxGrid;
  view: TcxGridDBTableView;
  Arr: TArray<string>;
begin
  Arr := getCurrentTableAndView;

  grid := Self.FindComponent(Arr[0]) AS TcxGrid;
  view := Self.FindComponent(Arr[1]) AS TcxGridDBTableView;

  grid.SetFocus;
  // 1. Move focus to the New Item Row
  view.ViewData.NewItemRow.Focused := True;

  // 2. Focus a specific column (e.g., the first visible column)
  view.Controller.FocusedColumn := view.VisibleColumns[0];

  view.DataController.Append;
  // 3. Activate the editor
  view.Controller.EditingController.ShowEdit;

(*
  // 1. Move focus to the New Item Row
  tv.ViewData.NewItemRow.Focused := True;

  // 2. Focus a specific column (e.g., the first visible column)
  tv.Controller.FocusedColumn := tv.VisibleColumns[0];

  tv.DataController.Append;
  // 3. Activate the editor
  tv.Controller.EditingController.ShowEdit;
*)
end;

procedure TfrmOptionTest.CreateConfig(sTableName: string);
begin
  qry.Close;
  qcnt.SQL.Clear;
  qcnt.SQL.Text :=
    'DROP TABLE IF EXISTS ' + sTableName + '; ' + sLineBreak;
  if sTableName = _TABLE_BBIO then
    qcnt.SQL.Text := qcnt.SQL.Text +
      'CREATE TABLE IF NOT EXISTS ' + _TABLE_BBIO + ' (' +
      'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
      'ConfigList TEXT(15), Ticker TEXT(10), Multiplier INTEGER, Description TEXT(100));' +
      'CREATE INDEX IF NOT EXISTS idx_config_bbio_ticker ON ' + _TABLE_BBIO + ' (Ticker ASC);'
  else if sTableName = _TABLE_FUTURES then
    qcnt.SQL.Text := qcnt.SQL.Text +
      'CREATE TABLE IF NOT EXISTS ' + _TABLE_FUTURES + ' (' +
      'id INTEGER PRIMARY KEY AUTOINCREMENT, ConfigList TEXT(20), Symbol TEXT(10), Multiplier INTEGER, Description TEXT(100));' +
      'CREATE INDEX IF NOT EXISTS futuresConfigList ON ' + _TABLE_FUTURES + '(ConfigList ASC);'
  else if sTableName = _TABLE_MUT then
    qcnt.SQL.Text := qcnt.SQL.Text +
      'CREATE TABLE IF NOT EXISTS ' + _TABLE_MUT + ' (' +
      'id INTEGER PRIMARY KEY AUTOINCREMENT, Ticker TEXT(10), Description TEXT(100));' + sLineBreak +
      'CREATE INDEX IF NOT EXISTS mutsTicker ON ' + _TABLE_MUT + ' (Ticker ASC);'
  else if sTableName = _TABLE_STRATEGY then
    qcnt.SQL.Text := qcnt.SQL.Text +
      'CREATE TABLE IF NOT EXISTS ' + _TABLE_STRATEGY + ' (' +
      'id INTEGER PRIMARY KEY AUTOINCREMENT, List TEXT(30));' + sLineBreak +
      'CREATE INDEX IF NOT EXISTS strategiesList ON ' + _TABLE_STRATEGY + ' (List ASC);'
  else if sTableName = _TABLE_ETF then
    qcnt.SQL.Text := qcnt.SQL.Text +
      'CREATE TABLE IF NOT EXISTS ' + _TABLE_ETF + ' (' +
      'ID INTEGER PRIMARY KEY AUTOINCREMENT, Legacy TEXT(15), Ticker TEXT(10), Type TEXT(10), Description TEXT(100), AssetClass TEXT(20));' +
      'CREATE INDEX IF NOT EXISTS etfsTicker ON ' + _TABLE_ETF + ' (Ticker);';
  qcnt.ExecSQL;
end;

procedure TfrmOptionTest.CreateConfigBBIO;
begin
  qry.Close;
  qcnt.SQL.Clear;
  qcnt.SQL.Text :=
    'DROP TABLE IF EXISTS ' + _TABLE_BBIO + ';'  + sLineBreak +
    'CREATE TABLE IF NOT EXISTS ' + _TABLE_BBIO + ' (' +
    'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
    'ConfigList TEXT(15), Ticker TEXT(10), Multiplier INTEGER, Description TEXT(100));' + sLineBreak +
    'CREATE INDEX IF NOT EXISTS idx_config_bbio_ticker ON ' + _TABLE_BBIO + ' (Ticker);';

  qcnt.ExecSQL;
end;

procedure TfrmOptionTest.FormActivate(Sender: TObject);
const
  aTables: array[1..5] of string = (_TABLE_BBIO, _TABLE_FUTURES, _TABLE_MUT, _TABLE_STRATEGY, _TABLE_ETF);
var
  sTableName: string;
begin
  try
    for sTableName in aTables do begin
      if not TableExists(DM.fDB, sTableName) then begin
        CreateConfig(sTableName);
        if (sTableName = _TABLE_BBIO) then InsertIntoConfigBBIO
        else if (sTableName = _TABLE_FUTURES) then InsertIntoConfigFutures
        else if (sTableName = _TABLE_MUT) then InsertIntoConfigMUTS
        else if (sTableName = _TABLE_STRATEGY) then InsertIntoConfigStrategy
        else if (sTableName = _TABLE_ETF) then InsertIntoConfigETF
      end;
    end;
  finally
    btnRestoreDefaults.Enabled := false;
    lblTab.Visible := false;
    tabPages.ActivePageIndex := 0;
  end;
end;

procedure TfrmOptionTest.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action := caFree;
end;

procedure TfrmOptionTest.qryAfterPost(DataSet: TDataSet);
var i: integer;
begin
  UpdateSymbolCount;
end;

procedure TfrmOptionTest.qryBeforePost(DataSet: TDataSet);
var
  tab : integer;
  Value: string;
begin
  if DataSet.State = dsInsert then
  begin
    tab := tabPages.TabIndex;
    case tab of
      _TAB_BBIO:      Value := Trim(DataSet.FieldByName('Ticker').AsString);
      _TAB_FUTURES:   Value := Trim(DataSet.FieldByName('Symbol').AsString);
      _TAB_MUT:       Value := Trim(DataSet.FieldByName('Ticker').AsString);
      _TAB_STRATEGY:  Value := Trim(DataSet.FieldByName('List').AsString);
      _TAB_ETF:       Value := Trim(DataSet.FieldByName('Ticker').AsString);
    end;

    // Check if the Ticker field is blank
    if Value = '' then
    begin
      ShowMessage('The Symbol field must be entered before saving the new row.');
      // rj this needs to be dynamic
//      tv.DataController.Cancel;
    end;
  end;
end;

procedure TfrmOptionTest.SetupScript(tbl: integer);
begin
  case tbl of
    _TAB_BBIO: begin
      DM.CreateConfigBBIO;
//         + sLineBreak +
//        'CREATE TABLE IF NOT EXISTS _cBroadBased (' +
//        'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
//        'ConfigList TEXT(15), Ticker TEXT(10), Multiplier INTEGER, Description TEXT(100));' + sLineBreak +
//        'CREATE INDEX IF NOT EXISTS idx_config_bbio_ticker ON config_bbio(Ticker);';
    end;
  end;
//    DM.FDScript1.ValidateAll;  // Optional: checks syntax
//    DM.FDScript1.ExecuteAll;
    DM.qUpdateTables.open;

end;

procedure TfrmOptionTest.tabPagesChange(Sender: TObject);
var
  tab : integer;
begin
  qry.Active := false;
  qry.SQL.Clear;
  tab := tabPages.TabIndex;
  btnRestoreDefaults.Enabled := tab > 0;
  lblTab.Visible := tab > 0;
  case tab of
    _TAB_BBIO: qry.SQL.Text := 'SELECT * FROM ' + _TABLE_BBIO;
    _TAB_FUTURES: qry.SQL.Text := 'SELECT * FROM ' + _TABLE_FUTURES;
    _TAB_MUT: qry.SQL.Text := 'SELECT * FROM ' + _TABLE_MUT;
    _TAB_STRATEGY: qry.SQL.Text := 'SELECT * FROM ' + _TABLE_STRATEGY;
    _TAB_ETF: qry.SQL.Text := 'SELECT * FROM ' + _TABLE_ETF;
  end;
  if (tab > 0) then begin
    qry.Active := true;
    UpdateSymbolCount;
  end;
end;

procedure TfrmOptionTest.UpdateSymbolCount;
var
  tab: integer;
begin
  tab := tabPages.TabIndex;
  case tab of
    _TAB_BBIO: lblTab.caption     := _LABEL_BBIO + ' - Count = ' + IntToStr(TableRowCount(_TABLE_BBIO));
    _TAB_FUTURES: lblTab.caption  := _LABEL_FUTURES + ' - Count = ' + IntToStr(TableRowCount(_TABLE_FUTURES));
    _TAB_MUT: lblTab.caption      := _LABEL_MUT + ' - Count = ' + IntToStr(TableRowCount(_TABLE_MUT));
    _TAB_STRATEGY: lblTab.caption := _LABEL_STRATEGY + ' - Count = ' + IntToStr(TableRowCount(_TABLE_STRATEGY));
    _TAB_ETF: lblTab.caption      := _LABEL_ETF + ' - Count = ' + IntToStr(TableRowCount(_TABLE_ETF));
  end;
end;

function TfrmOptionTest.TableExists(AConnection: TFDConnection; const ATableName: string): Boolean;
var
  List: TStringList;
begin
  Result := False;
  List := TStringList.Create;
  try
    // GetTableNames retrieves all table names into the string list
    // Parameters: CatalogName, SchemaName, Mask, List
    AConnection.GetTableNames('', '', '', List);

    // Check if our table name exists in the list (Case-Insensitive)
    List.CaseSensitive := False;
    if List.IndexOf(ATableName) > -1 then
      Result := True;
  finally
    List.Free;
  end;
end;

procedure TfrmOptionTest.InsertIntoConfigBBIO;
var
  i: integer;
  Q: TFDQuery;
begin
  DM.RestClient1.BaseURL := url + 'bbio';
  DM.RESTRequest1.Execute;


  Q := TFDQuery.Create(nil);
  try
    Q.Connection := DM.fDB;
    DM.MemTable.First;

    while not DM.MemTable.Eof do
    begin
      Q.SQL.Text :=
        'INSERT INTO ' + _TABLE_BBIO + ' (ConfigList, Ticker, Multiplier, Description) ' +
        'VALUES (:ConfigList, :Ticker, :Multiplier, :Description)';
      for i := 0 to DM.MemTable.FieldCount - 1 do
      begin
        if (i > 0) then
          Q.Params[i-1].AsString := DM.MemTable.Fields[i].Value;
      end;
      Q.ExecSQL;
      DM.MemTable.Next;



    (*
      Q.SQL.Text :=
        'INSERT INTO ' + _TABLE_BBIO + ' (ConfigList, Ticker, Multiplier, Description) ' +
        'VALUES (:ConfigList, :Ticker, :Multiplier, :Description)';
      Q.Params.ParamByName('ConfigList').AsString := DM.MemTable.FieldByName('ConfigList').AsString;
      Q.Params.ParamByName('Ticker').AsString := DM.MemTable.FieldByName('Ticker').AsString;
      Q.Params.ParamByName('Multiplier').AsInteger := DM.MemTable.FieldByName('Multiplier').AsInteger;
      Q.Params.ParamByName('Description').AsString := DM.MemTable.FieldByName('Description').AsString;
      Q.ExecSQL;
      DM.MemTable.Next;
      *)
    end;
  finally
    Q.Free;
  end;
end;

procedure TfrmOptionTest.InsertIntoConfigETF;
var
  Q: TFDQuery;
begin
  DM.RestClient1.BaseURL := url + 'etfs';
  DM.RESTRequest1.Execute;

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := DM.fDB;
    DM.MemTable.First;
    while not DM.MemTable.Eof do
    begin
      Q.SQL.Text :=
        'INSERT INTO ' + _TABLE_ETF + ' (Legacy, Ticker, Type, Description, AssetClass) ' +
        'VALUES (:Legacy, :Ticker, :Type, :Description, :AssetClass)';
      Q.Params.ParamByName('Legacy').AsString := DM.MemTable.FieldByName('Legacy').AsString;
      Q.Params.ParamByName('Ticker').AsString := DM.MemTable.FieldByName('Ticker').AsString;
      Q.Params.ParamByName('Type').AsString := DM.MemTable.FieldByName('Type').AsString;
      Q.Params.ParamByName('Description').AsString := DM.MemTable.FieldByName('Description').AsString;
      Q.Params.ParamByName('AssetClass').AsString := DM.MemTable.FieldByName('AssetClass').AsString;
      Q.ExecSQL;
      DM.MemTable.Next;
    end;
  finally
    Q.Free;
  end;
end;

procedure TfrmOptionTest.InsertIntoConfigFutures;
var
  Q: TFDQuery;
begin
  DM.RestClient1.BaseURL := url + 'futures';
  DM.RESTRequest1.Execute;

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := DM.fDB;
    DM.MemTable.First;
    while not DM.MemTable.Eof do
    begin
      Q.SQL.Text :=
        'INSERT INTO ' + _TABLE_FUTURES + ' (ConfigList, Symbol, Multiplier, Description) ' +
        'VALUES (:ConfigList, :Symbol, :Multiplier, :Description)';
      Q.Params.ParamByName('ConfigList').AsString := DM.MemTable.FieldByName('ConfigList').AsString;
      Q.Params.ParamByName('Symbol').AsString := DM.MemTable.FieldByName('Symbol').AsString;
      Q.Params.ParamByName('Multiplier').AsInteger := DM.MemTable.FieldByName('Multiplier').AsInteger;
      Q.Params.ParamByName('Description').AsString := DM.MemTable.FieldByName('Description').AsString;
      Q.ExecSQL;
      DM.MemTable.Next;
    end;
  finally
    Q.Free;
  end;
end;

procedure TfrmOptionTest.InsertIntoConfigMUTS;
var
  Q: TFDQuery;
  i, BatchSize: Integer;
begin
  DM.RestClient1.BaseURL := url + 'muts';
  DM.RESTRequest1.Execute;

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := DM.fDB;
    Q.SQL.Text :=
      'INSERT INTO ' + _TABLE_MUT + ' (Ticker, Description) VALUES (:Ticker, :Description)';
    Q.Params.ArraySize := 100; // Set batch size

    i := 0;
    DM.MemTable.First;
    while not DM.MemTable.Eof do
    begin
      Q.Params[0].AsStrings[i] := DM.MemTable.FieldByName('Ticker').AsString;
      Q.Params[1].AsStrings[i] := DM.MemTable.FieldByName('Description').AsString;

      Inc(i);
      DM.MemTable.Next;

      if (i = Q.Params.ArraySize) or DM.MemTable.Eof then
      begin
        Q.Execute(Q.Params.ArraySize);
        i := 0;
      end;
    end;
  finally
    Q.Free;
  end;
end;

procedure TfrmOptionTest.InsertIntoConfigStrategy;
var
  Q: TFDQuery;
begin
  DM.RestClient1.BaseURL := url + 'strategies';
  DM.RESTRequest1.Execute;

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := DM.fDB;
    DM.MemTable.First;
    while not DM.MemTable.Eof do
    begin
      Q.SQL.Text := 'INSERT INTO ' + _TABLE_STRATEGY + ' (List) VALUES (:List)';
      Q.Params.ParamByName('List').AsString := DM.MemTable.FieldByName('List').AsString;
      Q.ExecSQL;
      DM.MemTable.Next;
    end;
  finally
    Q.Free;
  end;
end;

class function TfrmOptionTest.Execute: TModalResult;
var
  sErrLocus : string;
begin
  with create(Nil) do begin
    Screen.Cursor := crHourGlass;
    try
      tabPages.ActivePage:= tabGlobal;
      chkAcct.Checked:= Settings.DispAcct;
      chkMTaxLots.checked:= Settings.DispMTaxLots;
      chkNotes.Checked:= Settings.DispNotes;
      chkOptTicks.checked:= Settings.DispOptTicks;
      chkTime.Checked := Settings.DispTimeBool;
      chkWSdefer.Checked := Settings.DispWSdefer;
      chkStrategies.Checked := Settings.DispStrategies;
      chkQS.checked:= Settings.DispQS;
      chk8949Code.Checked := Settings.Disp8949Code;
      ckWSHoldingDate.Checked := Settings.DispWSHolding;
      chkLegacyBC.Checked := Settings.LegacyBC; // 2022-01-20 MB New
      (*
      try
        sErrLocus := 'Load Broad-Based Index List';
        LoadBBIndexListBox;
        sErrLocus := 'Load Strategy List';
        LoadStrategyListBox;
        sErrLocus := 'Load Futures List';
        LoadFutureListBox;
        sErrLocus := 'Load ETN-ETF List';
        LoadETNListBox;
        sErrLocus := 'Load Mutual Funds List';
        LoadFundsListBox;
      except
        on E : Exception do begin
          sm('ERROR in ' + sErrLocus + CR //
            + E.ClassName + CR //
            + E.Message);
        end;
      end;
      *)
    finally
      Screen.Cursor := crDefault;
    end;
    Result := showModal;
//    if Result = mrOk then SaveData;
  end;
end;

function TfrmOptionTest.getCurrentTableAndView: TArray<string>;
var
  tab : integer;
begin
  tab := tabPages.TabIndex;
  btnRestoreDefaults.Enabled := tab > 0;
  case tab of
    _TAB_BBIO:     begin result := ['grdBBIO', 'tvBBIO', 'Ticker'];         end;
    _TAB_FUTURES:  begin result := ['grdFutures', 'tvFutures', 'Symbol'];   end;
    _TAB_MUT:      begin result := ['grdMut', 'tvMut', 'Ticker'];           end;
    _TAB_STRATEGY: begin result := ['grdStrategy', 'tvStrategy', 'List']; end;
    _TAB_ETF:      begin result := ['grdETF', 'tvETF', 'Ticker'];           end;
  end;
end;

end.
