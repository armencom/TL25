unit frmOptionDialog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, FuncProc, StrUtils, ExtCtrls,
  recordClasses, import, cxControls, cxContainer, cxEdit, cxTextEdit, wininet,
  ShlObj, activeX, Grids, TLCommonLib, System.Generics.Collections, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, dxSkinBasic,
  dxSkinHighContrast, dxSkinMetropolis, dxSkinMetropolisDark,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinOffice2013DarkGray, dxSkinOffice2013LightGray, dxSkinOffice2013White,
  dxSkinOffice2016Colorful, dxSkinOffice2016Dark, dxSkinOffice2019Black,
  dxSkinOffice2019Colorful, dxSkinOffice2019DarkGray, dxSkinOffice2019White,
  dxSkinTheBezier, dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light, cxCustomListBox, cxListBox, cxDBEdit,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxNavigator, dxDateRanges, dxScrollbarAnnotations, Data.DB,
  cxDBData, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridLevel, cxClasses, cxGridCustomView, cxGrid, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkroom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkiniMaginary,
  dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin,
  dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringtime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010,
  dxSkinWhiteprint, dxSkinXmas2008Blue;

type
  TfrmOptDialog = class(TForm)
    btnCancel: TButton;
    btnOK: TButton;
    tabPages: TPageControl;
    tabBroadBased: TTabSheet;
    lblCurrentSymbol: TLabel;
    lblNewSymbol: TLabel;
    lblMultiplier: TLabel;
    btnRemove: TButton;
    btnAdd: TButton;
    txtSymbol: TEdit;
    txtMultiplier: TEdit;
    lstBBIOs: TListView;
    tabGlobal: TTabSheet;
    chkMTaxLots: TCheckBox;
    chkNotes: TCheckBox;
    chkOptTicks: TCheckBox;
    chkTime: TCheckBox;
    chkWSdefer: TCheckBox;
    splitLineBottom: THeader;
    lblCtrlW: TLabel;
    lblCtrlT: TLabel;
    lblCtrlAltO: TLabel;
    lblCtrlAltM: TLabel;
    lblCtrlN: TLabel;
    btnRestoreBBIndexOptions: TButton;
    tabFutures: TTabSheet;
    lblFuturesCount: TLabel;
    btnRestoreFuturesSettings: TButton;
    lstFuture: TListView;
    btnFuRemove: TButton;
    txtFuMultiplier: TEdit;
    txtFuSymbol: TEdit;
    lblFuSymbol: TLabel;
    lblFuMultiplier: TLabel;
    btnFuAdd: TButton;
    Header1: THeader;
    tabStrategies: TTabSheet;
    lstStrategy: TListBox;
    lblCurrentStrategy: TLabel;
    btnRestoreStrategies: TButton;
    btnRemoveStrategy: TButton;
    btnAddStrategy: TButton;
    txtStrategy: TEdit;
    lblNewStrategy: TLabel;
    lblCtrlAltS: TLabel;
    chkStrategies: TCheckBox;
    chkAcct: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    chkQS: TCheckBox;
    lblCtrlQ: TLabel;
    tabMutFunds: TTabSheet;
    btnRestoreFunds: TButton;
    btnRemoveFund: TButton;
    btnAddFund: TButton;
    txtNewFund: TEdit;
    lblNewFundSymbol: TLabel;
    lblFundCount: TLabel;
    lstFunds: TListBox;
    chk8949Code: TCheckBox;
    Label3: TLabel;
    ckWSHoldingDate: TCheckBox;
    Label4: TLabel;
    TabETNs: TTabSheet;
    btnETNRestore: TButton;
    btnETNremove: TButton;
    btnETNAdd: TButton;
    txtETNNew: TEdit;
    lblETNNewSymbol: TLabel;
    lblETNCount: TLabel;
    lstETNs: TListView;
    lblETNsubType: TLabel;
    pnlETNsubType: TPanel;
    rbETN: TRadioButton;
    rbVTN: TRadioButton;
    rbCTN: TRadioButton;
    btnETNclear: TButton;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    lblDescrip: TLabel;
    txtETFdescrip: TMemo;
    chkLegacyBC: TCheckBox;
    btnImport: TButton;
    Button1: TButton;
    qBBIO: TFDQuery;
    dsBBIO: TDataSource; // 2022-01-20 MB New
    procedure btnAddClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure LoadBBIndexListBox;
    procedure LoadStrategyListBox;
    procedure LoadFutureListBox;
    procedure LoadFundsListBox;
    procedure loadETNListBox;
    procedure SaveFutureList;
    procedure SaveBBIndexList;
    procedure SaveETNList;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

    procedure btnAddStrategyClick(Sender: TObject);
    procedure btnRemoveStrategyClick(Sender: TObject);
    procedure btnRestoreBBIndexOptionsClick(Sender: TObject);
    procedure btnRestoreFuturesSettingsClick(Sender: TObject);

    function IsStrategyInUse():Boolean;
    procedure btnFuAddClick(Sender: TObject);
    procedure btnFuRemoveClick(Sender: TObject);
    procedure btnRestoreStrategiesClick(Sender: TObject);
    procedure btnAddFundClick(Sender: TObject);
    procedure btnRemoveFundClick(Sender: TObject);
    procedure btnETNRestoreClick(Sender: TObject);
    procedure btnRestoreFundsClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnETNAddClick(Sender: TObject);
    procedure btnETNremoveClick(Sender: TObject);
    procedure lstETNsSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure rbVTNClick(Sender: TObject);
    procedure rbETNClick(Sender: TObject);
    procedure rbCTNClick(Sender: TObject);
    procedure btnETNclearClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnImportClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure qBBIOBeforePost(DataSet: TDataSet);
    procedure btnCancelClick(Sender: TObject);

type
  TRows = TList<string>;

  private
    { Private declarations }
    constructor Create(AOwner: TComponent); overload;
    procedure SaveData;
    function SaveSymbolList(SymbolList : TListBox; MyList : TList) : TList;
//    function InETNsList(Symbol : TEdit) : boolean;
    procedure AddToSymbolList(Symbol : TEdit; SymbolList : TListBox; SymbolCount : TLabel);
    procedure UpdateSymbolCount(SymbolText : String; Count : Integer; SymbolCount : TLabel);
    function GetETFSubType(): string;
  public
    constructor Create; reintroduce; overload;
    class function Execute : TModalResult;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses TLSettings, Main, TLFile, uDM;

const
  ETFs_SYMBOL = 'ETF/ETN Symbol';
  MUTUAL_FUND_SYMBOL = 'Mutual Fund Symbols';
  INDEX_OPTION_SYMBOL = 'Index Option Symbols';
  FUTURE_SYMBOL = 'Future Symbols';
  TRADE_STRATEGIES = 'Trade Strategies';

var
  miETFsubType : integer = 0;

// ------------------------------------
// FORM
// ------------------------------------
procedure TfrmOptDialog.FormActivate(Sender: TObject);
var
  i : Integer;
  item : PSymbolItem;
  list : TListItem;
begin
  repaint;
  if (lstFunds.Count = Settings.MutualFundList.Count) then exit;
  // else we need to reload the mutual funds!
  Screen.Cursor := crHourGlass;
  LoadFundsListBox;
  Screen.Cursor := crDefault;
end;

procedure TfrmOptDialog.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action := caFree;
end;


procedure TfrmOptDialog.FormCreate(Sender: TObject);
begin
  //
end;

procedure TfrmOptDialog.FormShow(Sender: TObject);
begin
//  if panelQS.visible and not chkQS.checked then begin
//    chkQS.checked:= true;
//  end;
end;


// ------------------------------------
// Is Symbol in ETNs List?
// ------------------------------------
//function TfrmOptDialog.InETNsList(Symbol : TEdit) : boolean;
//var
//  j : Integer;
//  sMsg : string;
//begin
//  Result := False;
//end;


// --------------------------------------------------------
// Add Symbol to List{lstETNs, lstFunds}
// --------------------------------------------------------
procedure TfrmOptDialog.AddToSymbolList(Symbol : TEdit; SymbolList : TListBox; SymbolCount : TLabel);
var
  count, i : Integer;
begin
  if Length(Trim(Symbol.Text)) > 0 then begin
    count := SymbolList.Items.Count - 1;
    for i := 0 to count do begin
      if (SymbolList.Items[i] = Trim(Symbol.Text)) then begin
        ShowMessage('The specified Symbol already exists.');
        Exit;
      end;
    end;
    i := SymbolList.Items.Add(Symbol.Text);
    Symbol.Text := EmptyStr;
    SymbolList.Selected[i] := True;
  end
  else
    ShowMessage('The Symbol cannot be blank.');
  SymbolCount.Caption:= 'Symbols - Count:  ' + intToStr(SymbolList.Items.Count);
end;


// --------------------------
// BBIO List
// --------------------------
procedure TfrmOptDialog.btnAddClick(Sender: TObject);
var
  list : TListItem;
  count,i : Integer;
begin
  if Length(Trim(txtSymbol.Text)) > 0 then begin
    if Length(Trim(txtMultiplier.Text)) > 0 then begin
      count := lstBBIOs.Items.Count - 1;
      for i := 0 to count do begin
        if (lstBBIOs.Items[i].Caption = Trim(txtSymbol.Text)) then begin
          // only check if ticker exists
          if (lstBBIOs.Items[i].SubItems[0] = Trim(txtMultiplier.Text)) then begin
            ShowMessage('The specified Symbol already exists.');
            Exit;
          end;
        end;
      end;
      list := lstBBIOs.Items.Add;
      list.Caption := Trim(txtSymbol.Text);
      list.SubItems.Add(Trim(txtMultiplier.Text));
      lstBBIOs.Selected := list;
      txtSymbol.Text := EmptyStr;
      txtMultiplier.Text := EmptyStr;
    end
    else
      ShowMessage('The Multiplier cannot be blank.');
  END
  else
    ShowMessage('The Symbol cannot be blank.');
  UpdateSymbolCount(INDEX_OPTION_SYMBOL,lstBBIOs.Items.Count, lblCurrentSymbol);
end;

// REMOVE
procedure TfrmOptDialog.btnRemoveClick(Sender: TObject);
begin
  lstBBIOs.DeleteSelected;
  UpdateSymbolCount(INDEX_OPTION_SYMBOL, lstBBIOs.Items.Count, lblCurrentSymbol);
end;

// RESTORE
procedure TfrmOptDialog.btnRestoreBBIndexOptionsClick(Sender: TObject);
begin
   if  mDlg('Are you sure you would like to restore all Index Option Symbols to their default?',
   mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
      Screen.Cursor := crHourGlass;
      try
        Settings.ResetBroadBasedOptions;
        loadBBIndexListBox;
        UpdateSymbolCount(INDEX_OPTION_SYMBOL, lstBBIOs.Items.Count, lblCurrentSymbol);
      finally
        Screen.Cursor := crDefault;
      end;
    end;
end;

// LOAD
procedure TfrmOptDialog.loadBBIndexListBox;
var
  list : TListItem;
  i : Integer;
  pBBIO : PBBIOItem;
begin
  lstBBIOs.Items.Clear;
  // Populate the lstSymbol listbox with values from frmMain.SymbolList.
  for i := 0 to Settings.BBIOList.Count - 1 do begin
    pBBIO := Settings.BBIOList[i];
    list := lstBBIOs.Items.Add;
    list.Caption := pBBIO.Symbol;
    list.SubItems.Add(pBBIO.Mult);
  end;
  UpdateSymbolCount(INDEX_OPTION_SYMBOL, Settings.BBIOList.Count, lblCurrentSymbol);
end;

// SAVE
procedure TfrmOptDialog.SaveBBIndexList;
var
  i : integer;
  pBBIO : PBBIOItem;
  BBIOsList : TLBBIOList;
  t : string;
begin
  BBIOsList := Settings.BBIOList;
  BBIOsList.Clear;
  for i := 0 to lstBBIOs.Items.Count - 1 do begin
    new(pBBIO);
    FillChar(pBBIO^, SizeOf(pBBIO^), 0);
    pBBIO.Symbol := lstBBIOs.Items[i].Caption;
    pBBIO.Mult := lstBBIOs.Items[i].SubItems[0];
    BBIOsList.Add(pBBIO);
  end;
  Settings.BBIOList := BBIOsList;
end;


// --------------------------
// MUTUAL FUNDS
// --------------------------

// ADD
procedure TfrmOptDialog.btnAddFundClick(Sender: TObject);
begin
  AddToSymbolList(txtNewFund, lstFunds, lblFundCount);
end;

// REMOVE
procedure TfrmOptDialog.btnRemoveFundClick(Sender: TObject);
begin
  lstFunds.DeleteSelected;
  UpdateSymbolCount(MUTUAL_FUND_SYMBOL, lstFunds.Count, lblFundCount);
end;

// LOAD
procedure TfrmOptDialog.LoadFundsListBox;
var
  i : Integer;
  item : PSymbolItem;
  list : TListItem;
begin
  lstFunds.Items.Clear;
  for i := 0 to Settings.MutualFundList.Count - 1 do begin
    item := Settings.MutualFundList[i];
    lstFunds.Items.Add(item.Symbol);
  end;
  UpdateSymbolCount(MUTUAL_FUND_SYMBOL, lstFunds.Count, lblFundCount);
end;


// RESTORE
procedure TfrmOptDialog.btnRestoreFundsClick(Sender: TObject);
begin
  if  mDlg('Are you sure you would like to restore all Mutual Fund values to their default?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
      Screen.Cursor := crHourGlass;
      try
        //reload TradeLog default Futures List
        Settings.ResetMutualFunds;
        loadFundsListBox;
      finally
        Screen.Cursor := crDefault;
      end;
    end;
end;


// --------------------------
// FUTURES
// --------------------------
procedure TfrmOptDialog.btnFuAddClick(Sender: TObject);
var
  list : TListItem;
  count,i : Integer;
begin
  if Length(Trim(txtFuSymbol.Text)) > 0 then begin
    if Length(Trim(txtFuMultiplier.Text)) > 0 then begin
      if IsFloat(txtFuMultiplier.Text)
      and (StrToFloat(txtFuMultiplier.Text) > -1) then begin
        count := lstFuture.Items.Count - 1;
        for i := 0 to count do begin
          if (trim(lstFuture.Items[i].Caption) = Trim(txtFuSymbol.Text))
          then begin
            ShowMessage('The specified Symbol already exists.');
            Exit;
          end;
        end;
        list := lstFuture.Items.Add;
        list.Caption := Trim(txtFuSymbol.Text);
        list.SubItems.Add(Trim(txtFuMultiplier.Text));
        lstFuture.Selected := list;
        txtFuSymbol.Text := EmptyStr;
        txtFuMultiplier.Text := EmptyStr;
      end
      else begin
        ShowMessage('Please provide a valid numeric value for Multiplier.');
      end;
    end
    else
      ShowMessage('The Multiplier cannot be blank.');
  end
  else
    ShowMessage('The Symbol cannot be blank.');
    UpdateSymbolCount(FUTURE_SYMBOL, lstFuture.Items.Count, lblFuturesCount);
end;

// REMOVE
procedure TfrmOptDialog.btnFuRemoveClick(Sender: TObject);
begin
  lstFuture.DeleteSelected;
  UpdateSymbolCount(FUTURE_SYMBOL, lstFuture.Items.Count,  lblFuturesCount);
end;

// RESTORE
procedure TfrmOptDialog.btnRestoreFuturesSettingsClick(Sender: TObject);
begin
  if  mDlg('Are you sure you would like to restore all Futures Setup values to their default?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes
  then begin
    Screen.Cursor := crHourGlass;
    try
      //reload TradeLog default Futures List
      Settings.ResetFutureOptions;
      loadFutureListBox;
      UpdateSymbolCount(FUTURE_SYMBOL, lstFuture.Items.Count, lblFuturesCount);
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

// LOAD
procedure TfrmOptDialog.loadFutureListBox;
var
  i : Integer;
  item : PFutureItem;
  list : TListItem;
begin
  lstFuture.Items.Clear;
  // Populate the lstFutures listbox with values from frmMain.FutureList.
  for i := 0 to Settings.FutureList.Count - 1 do begin
    //new(item);
    item := Settings.FutureList[i];
    list := lstFuture.Items.Add;
    list.Caption := item.Name;
    list.SubItems.Add(FloatToStr(item.Value));
  end;
  UpdateSymbolCount(FUTURE_SYMBOL, lstFuture.Items.Count, lblFuturesCount);
end;

// SAVE FUT
procedure TfrmOptDialog.SaveFutureList;
var
  FutureList : TList;
  i : Integer;
  futureitem : PFutureItem;
begin
  FutureList := Settings.FutureList;
  FutureList.Clear;
  for i := 0 to lstFuture.Items.Count - 1 do begin
    new(futureItem);
    FillChar(futureItem^, SizeOf(futureItem^), 0);
    futureItem.Name := lstFuture.Items[i].Caption;
    futureItem.Value := StrToFloat(lstFuture.Items[i].SubItems[0]);
    FutureList.Add(futureItem);
  end;
  Settings.FutureList := FutureList;
end;



// --------------------------
// Strategies
// --------------------------
function TfrmOptDialog.IsStrategyInUse():Boolean;
var
  i, j : Integer;
begin
  if (TradeLogFile <> nil) and (TradeLogFile.Count > 0) then begin
    for i:= 0 to TradeLogFile.Count - 1 do begin
      if lstStrategy.SelCount > 1 then begin
        for j := 0 to lstStrategy.Count - 1 do begin
          if lstStrategy.Selected[j] then begin
            if TradeLogFile[i].Strategy = lstStrategy.Items.Strings[j] then
            begin
              Result := true;
              exit;
            end; // if Strategy
          end; // if selected[j]
        end; // for j
      end;
      if TradeLogFile[i].Strategy = lstStrategy.Items.Strings[lstStrategy.ItemIndex]
      then begin
        Result := true;
        exit;
      end;
    end;
  end;
  Result := false;
end;


// ADD
procedure TfrmOptDialog.btnAddStrategyClick(Sender: TObject);
begin
  if Length(Trim(txtStrategy.Text)) > 0 then begin
    if lstStrategy.Items.IndexOf(Trim(txtStrategy.Text)) > -1 then begin
      ShowMessage('The strategy entered already exists.');
      Exit;
    end;
    lstStrategy.Items.Add(txtStrategy.Text);
    lstStrategy.ClearSelection;
    lstStrategy.Selected[lstStrategy.Items.Count - 1] := true;
    txtStrategy.Text := EmptyStr;
  end;
  UpdateSymbolCount(TRADE_STRATEGIES, lstStrategy.Items.Count, lblCurrentStrategy);
end;

procedure TfrmOptDialog.btnCancelClick(Sender: TObject);
begin

end;

// REMOVE
procedure TfrmOptDialog.btnRemoveStrategyClick(Sender: TObject);
var
  index, i : Integer;
  isLastIndex : BOOL;
begin
  if IsStrategyInUse then begin
    if lstStrategy.MultiSelect then begin
      if mDlg('One or more selected items are in use. Are you sure you want to remove?',
      mtConfirmation, [mbYes, mbNo], 0) = mrNo then exit;
    end
    else begin
      if mDlg('The selected item is in use. Are you sure you want to remove?',
      mtConfirmation, [mbYes, mbNo], 0) = mrNo then exit;
    end;
  end;
  isLastIndex := false;
  index := lstStrategy.ItemIndex;
  if (lstStrategy.MultiSelect) then
    isLastIndex := true;
  if lstStrategy.ItemIndex > -1 then begin
    lstStrategy.DeleteSelected;
    if lstStrategy.Items.Count > index then
      lstStrategy.Selected[index] := true
    else if lstStrategy.ItemIndex > -1 then
      if isLastIndex then
        lstStrategy.Selected[lstStrategy.Items.Count - 1] := true
      else
        lstStrategy.Selected[index - 1] := true;
  end;
  UpdateSymbolCount(TRADE_STRATEGIES, lstStrategy.Items.Count, lblCurrentStrategy);
end;

// RESTORE
procedure TfrmOptDialog.btnRestoreStrategiesClick(Sender: TObject);
begin
   if  mDlg('Are you sure you would like to restore all Trade Strategies to their default?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes
   then begin
    Screen.Cursor := crHourGlass;
    try
      //restore TradeLog defaults
      Settings.ResetStrategyOptions;
      LoadStrategyListBox;
      UpdateSymbolCount(TRADE_STRATEGIES, lstStrategy.Items.Count, lblCurrentStrategy);
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TfrmOptDialog.Button1Click(Sender: TObject);
var
  Rows : TRows;
begin

//  Rows := DM.GetTableValues('BBIO');
//  showmessage(string(Rows[0]));

end;

// LOAD
procedure TfrmOptDialog.LoadStrategyListBox;
begin
  lstStrategy.Items.LoadFromFile(Settings.StrategyOptionsFile);
  if (lstStrategy.Items.Count < 1) // 2021-07-09 MB - case of zero items
  or (pos('<!DOCTYPE html',lstStrategy.items[0])>0) then
    lstStrategy.items.Clear;
  UpdateSymbolCount(TRADE_STRATEGIES, lstStrategy.Items.Count, lblCurrentStrategy);
end;


procedure TfrmOptDialog.btnOKClick(Sender: TObject);
begin
  if trFileName='' then exit;
  SaveTradesBack('Trade Type Change');
end;


// --------------------------
// ETN / ETF / VTN / CTN
// --------------------------
function GetDefaultETFSubType(tk : string): string;
begin
  if (tk = 'EVIX')
  or (tk = 'EXIV')
  or (tk = 'VXX')
  or (tk = 'VXXB')
  or (tk = 'VXZ')
  or (tk = 'VXZB')
  or (tk = 'XVZ')
  then
    result := 'VTN'
  else if (tk = 'AYT')
  or (tk = 'CNY')
  or (tk = 'DRR')
  or (tk = 'ERO')
  or (tk = 'GBB')
  or (tk = 'ICI')
  or (tk = 'INR')
  or (tk = 'JEM')
  or (tk = 'JYN')
  or (tk = 'PGD')
  or (tk = 'URR')
  then
    result := 'CTN'
  else
    result := 'ETF';
end;


procedure TfrmOptDialog.lstETNsSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
var
  i : integer;
  t : string;
begin
  txtETNNew.Text := Item.Caption; // Symbol
  // ----------------------------------
  for i := 0 to lstETNs.Items.Count do begin
    if (lstETNs.Items[i].Caption = Item.Caption) then begin
      t := lstETNs.Items[i].SubItems[0];
      txtETFDescrip.Text := lstETNs.Items[i].SubItems[1];
      break;
    end;
  end;
  // ----------------------------------
  if (t = 'VTN') then begin
    miETFsubType := 2;
    rbVTN.Checked := true;
  end
  else if (t = 'CTN') then begin
    miETFsubType := 1;
    rbCTN.Checked := true;
  end
  else begin
    miETFsubType := 0;
    rbETN.Checked := true;
  end;
end;

procedure TfrmOptDialog.qBBIOBeforePost(DataSet: TDataSet);
var
  TickerValue: string;
begin

  // Check if the dataset is currently inserting a new record
  if DataSet.State = dsInsert then
  begin
    TickerValue := Trim(DataSet.FieldByName('Ticker').AsString);

    // Check if the Ticker field is blank
    if TickerValue = '' then
    begin
      // 1. Raise a custom exception with the error message.
      // The cxGrid will catch this exception and handle the error display.

//      raise Exception.Create('The Ticker field must be entered before saving the new row.');


      ShowMessage('The Ticker field must be entered before saving the new row.');
      Abort;
      // 2. DO NOT use Abort here.
      // 3. DO NOT use MessageDlg here, as it may be suppressed or flicker.
    end;
  end;
end;

procedure TfrmOptDialog.rbCTNClick(Sender: TObject);
begin
  miETFsubType := 2;
end;

procedure TfrmOptDialog.rbETNClick(Sender: TObject);
begin
  miETFsubType := 0;
end;

procedure TfrmOptDialog.rbVTNClick(Sender: TObject);
begin
  miETFsubType := 1;
end;

function TfrmOptDialog.GetETFSubType(): string;
begin
  if rbETN.Checked then
    result := 'ETF'
  else if rbVTN.Checked then
    result := 'VTN'
  else if rbCTN.Checked then
    result := 'CTN'
  else
    result := 'ERR';
end;


procedure TfrmOptDialog.btnETNAddClick(Sender: TObject);
var
  newETF : TListItem;
  count, i : Integer;
  sType : string;
begin
  if Length(Trim(txtETNNew.Text)) > 0 then begin
    count := lstETNs.Items.Count - 1;
    sType := GetETFSubType; // make sure we get the same value both times!
    for i := 0 to count do begin
      if (lstETNs.Items[i].Caption = Trim(txtETNNew.Text)) then begin
        // found symbol, 2 more possibilities:
        // 1. symbol + subtype already match - error
        if (lstETNs.Items[i].SubItems[0] = sType) then begin
          ShowMessage('The specified ETN already exists.');
          Exit;
        end
        // 2. subtype is different - change it (i.e. delete old, then add new)
        else begin
          lstETNs.Items.Delete(i);
          break;
        end; // 2 cases
      end; // if symbol found
    end; // for i
    // if we get here, it mwans there is no match, so just ADD
    lstETNs.Items.BeginUpdate;
      newETF := lstETNs.Items.Add;
      newETF.Caption := Trim(txtETNnew.Text);
      newETF.SubItems.Add(sType);
      newETF.SubItems.Add(txtETFDescrip.text);
      lstETNs.Selected := newETF;
    lstETNs.Items.EndUpdate;
    lstETNs.Refresh;
    //txtETNNew.Text := EmptyStr; // 2018-04-05 MB don't clear, leave as-is
  end
  else
    ShowMessage('The ETN Symbol cannot be blank.');
  UpdateSymbolCount(ETFs_SYMBOL, lstETNs.Items.Count, lblETNcount);
end;

procedure TfrmOptDialog.btnETNclearClick(Sender: TObject);
begin
  txtETNNew.Text := '';
end;

// REMOVE
procedure TfrmOptDialog.btnETNremoveClick(Sender: TObject);
begin
  lstETNs.DeleteSelected;
  UpdateSymbolCount(ETFs_SYMBOL, lstETNs.Items.Count, lblETNcount);
end;

// RESTORE
procedure TfrmOptDialog.btnETNRestoreClick(Sender: TObject);
begin
  if  mDlg('Are you sure you would like to restore all ETF/ETN values to their default?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
      Screen.Cursor := crHourGlass;
      try
        //reload TradeLog default Futures List
        Settings.ResetETFs;
        loadETNListBox;
        UpdateSymbolCount(ETFs_SYMBOL, lstETNs.Items.Count, lblETNcount);
      finally
        Screen.Cursor := crDefault;
      end;
    end;
end;

// LOAD
procedure TfrmOptDialog.loadETNListBox;
var
  list : TListItem;
  i : Integer;
  item : PETFItem;
begin
  lstETNs.Items.Clear;
  // Populate the lstSymbol listbox with values from frmMain.SymbolList.
  for i := 0 to Settings.ETFsList.Count - 1 do begin
    item := Settings.ETFsList[i];
    if item.subType = '' then
      item.subType := GetDefaultETFSubType(item.Symbol);
    list := lstETNs.Items.Add;
    list.SubItems.Add(item.subType);
    list.SubItems.Add(item.descrip);
    list.Caption := item.Symbol;
  end;
  UpdateSymbolCount(ETFs_SYMBOL, Settings.ETFsList.Count, lblETNcount);
end;

// SAVE
procedure TfrmOptDialog.SaveETNList;
var
  i : integer;
  item : PETFItem;
  ETFList : TLETFList;
begin
  ETFList := Settings.ETFsList;
  ETFList.Clear;
  for i := 0 to lstETNs.Items.Count - 1 do begin
    new(item);
    FillChar(item^, SizeOf(item^), 0);
    item.Symbol := lstETNs.Items[i].Caption;
    item.subType := lstETNs.Items[i].SubItems[0];
    item.descrip := lstETNs.Items[i].SubItems[1];
    ETFList.Add(item);
  end;
  Settings.ETFsList := ETFList;
end;


// ------------------------------------
constructor TfrmOptDialog.Create(AOwner: TComponent);
begin
  inherited;
end;

constructor TfrmOptDialog.Create;
begin
  raise Exception.Create('Constructor Disabled, Use Execute Class Method Instead.')
end;


procedure TfrmOptDialog.UpdateSymbolCount(SymbolText: String; Count : Integer; SymbolCount: TLabel);
begin
  SymbolCount.Caption := SymbolText + ' - Count = ' + IntToStr(Count);
end;


Function TfrmOptDialog.SaveSymbolList(SymbolList: TListBox; MyList: TList) : TList;
var
  i : integer;
  item : PSymbolItem;
begin
  MyList.Clear;
  for i := 0 to SymbolList.Items.Count - 1 do begin
    new(item);
    FillChar(item^, SizeOf(item^), 0);
    item.Symbol := SymbolList.Items[i];
    item.Multiplier := '';
    MyList.Add(item);
  end;
  Result := MyList;
end;


// ------------------------------------
// SAVE ALL DATA
// ------------------------------------
procedure TfrmOptDialog.SaveData;
begin
  Settings.DispSupportCenter := false; // cbShowSupportCenter.Checked;
  Settings.DispQuickTour := false; // chkQuickTour.Checked;
  Settings.DispAcct := chkAcct.checked;
  Settings.DispImport := false; // chkImportFilter.Checked;
  Settings.DispMTaxLots := chkMTaxLots.Checked;
  Settings.DispNotes := chkNotes.Checked;
  Settings.DispOptTicks := chkOptTicks.Checked;
  Settings.DispQS := chkQS.Checked;
  Settings.DispStrategies := chkStrategies.Checked;
  Settings.DispTimeBool := chkTime.checked;
  Settings.DispWSdefer := chkWSdefer.checked;
  Settings.Disp8949Code := chk8949Code.Checked;
  Settings.DispWSHolding := ckWSHoldingDate.Checked;
//  Settings.LegacyBC := chkLegacyBC.Checked; // 2022-01-20 MB New
  frmMain.SetupToolBarMenuBar(false); // 2022-01-24 MB
  SaveFutureList;
  SaveBBIndexList;
  Settings.MutualFundList := TLSymbolList(SaveSymbolList(lstFunds, Settings.MutualFundList));
  SaveETNList;
  lstStrategy.Items.SaveToFile(Settings.StrategyOptionsFile);
end;


// ------------------------------------
// EXECUTE
// ------------------------------------
class function TfrmOptDialog.Execute: TModalResult;
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
//      chkLegacyBC.Checked := Settings.LegacyBC; // 2022-01-20 MB New
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
    finally
      Screen.Cursor := crDefault;
    end;
    Result := showModal;
    if Result = mrOk then SaveData;
  end;
end;

procedure TfrmOptDialog.btnImportClick(Sender: TObject);
begin
  // import the data
//  DM.qSetUpConfig.ExecSQL;

DM.FDScript1.SQLScripts.Clear;
DM.FDScript1.SQLScripts.Add;
DM.FDScript1.SQLScripts[0].Name := 'CreateTables';
DM.FDScript1.SQLScripts[0].SQL.Text :=
  'DROP TABLE IF EXISTS config_bbio;' + sLineBreak +
  'DROP TABLE IF EXISTS config_etfs;' + sLineBreak +
  'DROP TABLE IF EXISTS config_futures;' + sLineBreak +
  'DROP TABLE IF EXISTS config_muts;' + sLineBreak +
  'DROP TABLE IF EXISTS config_strategies;' + sLineBreak +

  'CREATE TABLE IF NOT EXISTS _cBbio (' +
  'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
  'ConfigList TEXT(15), Ticker TEXT(10), Multiplier INTEGER, Description TEXT(100));' + sLineBreak +
  'CREATE INDEX IF NOT EXISTS idx_config_bbio_ticker ON config_bbio(Ticker);' + sLineBreak +

  'CREATE TABLE IF NOT EXISTS _cEtfs (' +
  'ID INTEGER PRIMARY KEY AUTOINCREMENT, Legacy TEXT(15), Ticker TEXT(10), Type TEXT(10), Description TEXT(100), AssetClass TEXT(20));' + sLineBreak +
  'CREATE INDEX IF NOT EXISTS etfsTicker ON config_etfs(Ticker);' + sLineBreak +

  'CREATE TABLE IF NOT EXISTS _cFutures (' +
  'id INTEGER PRIMARY KEY AUTOINCREMENT, ConfigList TEXT(20), Symbol TEXT(10), Multiplier INTEGER, Description TEXT(100));' + sLineBreak +
  'CREATE INDEX IF NOT EXISTS futuresConfigList ON config_futures(ConfigList ASC);' + sLineBreak +

  'CREATE TABLE IF NOT EXISTS _cMuts (' +
  'id INTEGER PRIMARY KEY AUTOINCREMENT, Ticker TEXT(10), Description TEXT(100));' + sLineBreak +
  'CREATE INDEX IF NOT EXISTS mutsTicker ON config_muts(Ticker ASC);' + sLineBreak +

  'CREATE TABLE IF NOT EXISTS _cStrategies (' +
  'id INTEGER PRIMARY KEY AUTOINCREMENT, List TEXT(30));' + sLineBreak +
  'CREATE INDEX IF NOT EXISTS strategiesList ON config_strategies(List ASC);';

DM.FDScript1.ValidateAll;  // Optional: checks syntax
DM.FDScript1.ExecuteAll;






  DM.InsertIntoConfigBBIO;
  DM.InsertIntoConfigETFS;
  DM.InsertIntoConfigFutures;
  DM.InsertIntoConfigMUTS;
  DM.InsertIntoConfigStrategies;

  showmessage('Done!');
end;

end.
