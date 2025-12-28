unit ExerciseAssignList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, cxGridCustomTableView,
  Dialogs, TLExerciseAssign, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridTableView, cxGrid, StdCtrls, Buttons, ExtCtrls,
  cxTextEdit, cxCalendar, cxCurrencyEdit, cxCheckBox, Menus, cxButtons, TLFile, cxNavigator,
  Generics.Collections, Generics.Defaults, cxGridDBTableView, dxSkinsCore,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010,
  dxSkinWhiteprint, dxSkinXmas2008Blue, dxSkinscxPCPainter;

type
  TExerciseDataSource = class(TcxCustomDataSource)
  private
    FExerciseDiscoverer : TExerciseAssign;
//    procedure Delete(AIndex: Integer);
  protected
    function GetRecordCount: Integer; override;
    function GetValue(ARecordHandle: TcxDataRecordHandle; AItemHandle: TcxDataItemHandle): Variant; override;
    procedure DeleteRecord(ARecordHandle: TcxDataRecordHandle); override;
  public
    constructor Create(RecordList: TExerciseAssign);
    destructor Destroy; override;
  end;

  TStocksDataSource = class(TcxCustomDataSource)
  private
    FExerciseDiscoverer : TExerciseAssign;
  protected
    function GetRecordCount: Integer; override;
    function GetValue(ARecordHandle: TcxDataRecordHandle; AItemHandle: TcxDataItemHandle): Variant; override;
  public
    constructor Create(RecordList: TExerciseAssign);
    destructor Destroy; override;
  end;

  TfrmExerciseAssign = class(TForm)
    pnlMain: TPanel;
    cxStyleRepository1: TcxStyleRepository;
    cxStyle1: TcxStyle;
    cxStyle2: TcxStyle;
    cxStyle3: TcxStyle;
    cxStyle4: TcxStyle;
    cxStyle5: TcxStyle;
    pnlButtons: TPanel;
    pnlLeft: TPanel;
    pnlTop: TPanel;
    cxGrid1: TcxGrid;
    cxGrid1TableView1: TcxGridTableView;
    cxGrid1TableView1_Desc: TcxGridColumn;
    cxGrid1TableView1_TrNum: TcxGridDBColumn;
    cxGrid1TableView1_Date: TcxGridDBColumn;
    cxGrid1TableView1_OpenClose: TcxGridDBColumn;
    cxGrid1TableView1_LongShort: TcxGridDBColumn;
    cxGrid1TableView1_Ticker: TcxGridDBColumn;
    cxGrid1TableView1_Contracts: TcxGridDBColumn;
    cxGrid1TableView1_StrikePrice: TcxGridDBColumn;
    cxGrid1TableView1_Type: TcxGridDBColumn;
    cxGrid1TableView1_ExpireDate: TcxGridDBColumn;
    cxGrid1TableView1_Expired: TcxGridDBColumn;
    cxGrid1Level1: TcxGridLevel;
    Label4: TLabel;
    pnlBtns: TPanel;
    btnExercise: TcxButton;
    btnClose: TcxButton;
    pnlNotes: TPanel;
    lblSkip: TLabel;
    pnlWarn: TPanel;
    Label2: TLabel;
    lblText: TLabel;
    lblNotes: TLabel;
    btnSkip: TcxButton;
    lblExercise: TLabel;
    pnlAutoEx: TPanel;
    Label1: TLabel;
    pnlCB: TPanel;
    cbAutoEx: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCloseClick(Sender: TObject);
    procedure cxGrid1TableView1FocusedRecordChanged(
      Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
//    procedure ExpandAll(Expand : Boolean);
    procedure FormActivate(Sender: TObject);
    procedure Exercise(Sender: TObject);

    procedure btnExerciseClick(Sender: TObject);
    procedure btnSkipClick(Sender: TObject);
  private
    { Private declarations }
    FExerciseAssign : TExerciseAssign;
    FExerciseDS : TExerciseDataSource;
    FStockDS : TStocksDataSource;
    FExercisedClicked, FSkipClicked : Boolean;
    FStocksSelected : TTradeList;
    FOptionsSelected : TTradeList;
    FSelectStocks : Boolean;
    procedure UpdateCount;
  public
    { Public declarations }
    constructor Create(AOwner : TComponent; ExerciseAssign : TExerciseAssign); overload;
    procedure MainGridClicked;
  end;

var
  AutoExAssign, AutoExDone, askOnce, exerciseOK : boolean;
  OptionsNotExercisedCnt, rowIdx : integer;

implementation

{$R *.dfm}

uses RecordClasses, FuncProc, Main, TLSettings, Import, dxCore, TLCommonLib;


procedure TfrmExerciseAssign.btnCloseClick(Sender: TObject);
begin
  Close;
end;

// ------------------------------------
procedure TfrmExerciseAssign.btnExerciseClick(Sender: TObject);
begin
  rowIdx := 0;
  // flag to track whether user, at any time, clicked this button
  FExercisedClicked := true;
  // form create sets FExercisedClicked to false; only this sets to true
  Exercise(self);
end;

procedure TfrmExerciseAssign.btnSkipClick(Sender: TObject);
var
  I, recIdx : Integer;
begin
  FSkipClicked := true;
  SaveTradesBack('Skip Stock from Assignment');
  // get number of selected stock and option shares
  with frmMain.cxGrid1TableView1.DataController do
  for I := 0 to getSelectedCount - 1 do begin
    recIdx := getRowInfo(GetSelectedRowIndex(I)).RecordIndex;
    if IsStockType(TradeLogFile[recIdx].TypeMult)
    or (POS('OPT', TradeLogFile[recIdx].TypeMult)=1) then begin
      TradeLogFile[recIdx].Matched := 'Ex-0';
    end;
  end;
  OptionsNotExercisedCnt := 1; // this will force another DiscoverExerciseAssigns
  Close;
end;


// ------------------------------------
procedure TfrmExerciseAssign.Exercise(Sender: TObject);
var
  I, iOptionSelected, iLastRowToProcess, rowCnt, recIdx, ExNumber : Integer;
  contracts, shares, OptionsOpened : double;
  exerciseSimple : boolean;
begin
  //rj CodeSite.EnterMethod('btnExerciseClick');
  exerciseOK := false;
  exerciseSimple := false;
 try
  StatBar('Exercising Options - Please Wait . . .');
  // note: if the user skips the first option, we want to start with
  // the first option he/she actually did select
  iOptionSelected := cxGrid1TableView1.DataController.FocusedRowIndex;
  // ------------------------
  // automate the process
  // do not auto exercise if user selected a trade rec
  if (cxGrid1TableView1.DataController.RecordCount > 2)
  and (frmMain.cxGrid1TableView1.DataController.GetSelectedCount = 0)
  then begin
    if cbAutoEx.Checked then begin
      autoExAssign := true;
      sendMessage(frmMain.Handle, WM_SETREDRAW, WPARAM(False), 0);
      // screen.Cursor := crHourGlass;
    end
    else
      autoExAssign := false;
  end;
  // sm('1: '+intToStr(cxGrid1TableView1.DataController.FocusedRowIndex));
  if autoExAssign then
    rowCnt := cxGrid1TableView1.DataController.RowCount - iOptionSelected + 1
  // NOTE: rowCnt is one-based, not zero-based.
  // Exercise button enabled, trades selected
  else if (btnExercise.Enabled) then begin
    rowCnt := 1;
    //
    if (FStocksSelected.Count > 0) and (FOptionsSelected.Count > 0) then
      exerciseOK := true
    else if (FStocksSelected.Count = 0) and (FOptionsSelected.Count = 0) then
    begin
      exerciseOK := true;
      exerciseSimple := true;
    end;
  end;
  //for rowIdx := 0 to rowCnt - 1 do
  for rowIdx := iOptionSelected to (iOptionSelected + rowCnt - 1) do begin
    // select option grid record row (user selection is now erased)
    cxGrid1TableView1.DataController.FocusedRowIndex := rowIdx;
    if autoExAssign then begin
      shares := 0;
      contracts := 0;
      OptionsOpened := 0; // 2015-04-14 MB
      // get number of stock and option shares
      with frmMain.cxGrid1TableView1.DataController do begin
        for I := 0 to RowCount - 1 do begin
          recIdx := getRowInfo(I).RecordIndex;
          //sm(intToStr(rowIdx)+'   '+ TradeLogFile[recIdx].Ticker );
          if IsOption(TradeLogFile[recIdx].TypeMult, TradeLogFile[recIdx].Ticker)
          and (TradeLogFile[recIdx].OC = 'O') then begin
            Contracts := Contracts + (TradeLogFile[recIdx].Shares * TradeLogFile[recIdx].Multiplier);
            OptionsOpened := OptionsOpened + (TradeLogFile[recIdx].Shares * TradeLogFile[recIdx].Multiplier);
          end
          else if IsStockType(TradeLogFile[recIdx].TypeMult) then begin
            Shares := Shares + TradeLogFile[recIdx].Shares;
          end;
        end;
      end;
      //if shares = contracts then exerciseOK := true // 2015-04-14 MB
      if shares = OptionsOpened then
        exerciseOK := true
      else
        exerciseOK := false;
    end;
    recIdx := cxGrid1TableView1.DataController.FocusedRecordIndex;
    if recIdx > -1 then begin
      // this code is dual purpose:
      // 1. checks if autoAssign and stocks match so we can exercise
      // 2. checks if user manually selected stocks or options to exercise
      if exerciseOK then begin
        if autoExAssign or exerciseSimple then
          ExNumber:= FExerciseAssign.ExerciseAssign(recIdx, nil, nil)
        else
          ExNumber:= FExerciseAssign.ExerciseAssign(recIdx, FStocksSelected, FOptionsSelected);
        // end if autoExAssign
      end
      // if autoExAssign, options that need user intervention will not be exercised
      // these will be exercised manually on subsequent passes
      else if autoExAssign and (rowIdx < rowCnt-1) then
        inc(OptionsNotExercisedCnt);
      // end if exerciseOK
      if not autoExAssign then begin
        // delete the option from the grid
        FExerciseDS.DeleteRecord(FExerciseDS.GetRecordHandle(recIdx));
        UpdateCount;
        FExerciseDS.DataChanged;
      end;
    end;
    pnlMain.Enabled := true;
    Screen.Cursor := crDefault;
    TradeLogFile.ShowStatus := true;
    statBar('C = '+intToStr(rowCnt)+'   R = '+intToStr(rowIdx));
    // Make sure we clear the stock list for the next exercise.
    FStocksSelected.Clear;
    FOptionsSelected.Clear;
    if AutoExAssign and FExercisedClicked and not AutoExDone
    and (rowIdx = (iOptionSelected + rowCnt - 1)) then begin
      // clear option grid
      sendMessage(frmMain.Handle, WM_SETREDRAW, WPARAM(true), 0);
      AutoExDone := true;
      filterByTick('');
      frmMain.pnlFilter.Visible := false;
      pnlNotes.Visible := false;
      pnlWarn.Visible := false;
      btnExercise.Enabled := false;
      lblNotes.Caption := 'Auto Exercise Complete';
      StatBar('Automatic Option Exercises Complete - Please click Close button.');
      btnClose.click;
    end
    else if not AutoExAssign
    and (cxGrid1TableView1.DataController.RecordCount = 0) then
      btnClose.click;
    pnlMain.Enabled := true;
  end;
 finally
   Screen.Cursor := crDefault;
 end;
end; // btnExerciseClick


// ------------------------------------
//procedure TfrmExerciseAssign.ExpandAll(Expand : Boolean);
//var
//  I : Integer;
//  idx : Integer;
//begin
//  for I := 0 to cxGrid1TableView1.DataController.RecordCount - 1 do
//    begin
//      idx := cxGrid1TableView1.DataController.GetRowIndexByRecordIndex(I, false);
//      cxGrid1TableView1.ViewData.Records[Idx].Expanded := Expand;
//    end;
//  // end for I
//end;


// ----------------------------------------------
constructor TfrmExerciseAssign.Create(AOwner : TComponent;
  ExerciseAssign: TExerciseAssign);
begin
  Create(AOwner);
  frmMain.DisableMenuToolsAll;
  FExerciseAssign := ExerciseAssign;
  FExerciseDS := TExerciseDataSource.Create(FExerciseAssign);
  cxGrid1TableView1.DataController.CustomDataSource := FExerciseDS;
  FStockDS := TStocksDataSource.Create(FExerciseAssign);
  UpdateCount;
  FStocksSelected := TTradeList.Create;
  FOptionsSelected := TTradeList.Create;
  // overwrite the wrong sort order to sort by TrNum
  cxGrid1TableView1.DataController.ClearSorting(False);
  cxGrid1TableView1_TrNum.SortOrder := soAscending;
end;


// ----------------------------------------------
procedure TfrmExerciseAssign.cxGrid1TableView1FocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
var
  TrNum, ItNum : String;
  I, j, numStocks : Integer;
  ItemList : TcxFilterCriteriaItemList;
  StockSharesAssigned, shOpen, contrOpen : double;
begin
  btnSkip.Enabled := false; // new row means nothing selected up top.
  pnlWarn.Color := clYellow;
  // added to make sure first option record is selected
  if (cxGrid1TableView1.DataController.RowCount > 0) then begin
    if (cxGrid1TableView1.DataController.FocusedRowIndex = -1) then begin
      cxGrid1TableView1.DataController.FocusedRowIndex := 0;
      exit;
    end;
  end;
  if (cxGrid1TableView1.DataController.RowCount <= 0) then exit;
  StockSharesAssigned := 0;
  btnExercise.Caption := 'Exercise';
  pnlButtons.Color := clInfoBk;
  lblExercise.Caption := 'Click the Exercise button to exercise.';
  if AFocusedRecord <> nil then begin
    // check for already assigned stocks
    numStocks := 0;
    for I := 0 to FExerciseAssign[AFocusedRecord.RecordIndex].MatchingStocks.Count - 1 do
    begin
      if FExerciseAssign[AFocusedRecord.RecordIndex].MatchingStocks[I].Matched = '' then
        inc(NumStocks)
      else
        StockSharesAssigned := StockSharesAssigned +
          FExerciseAssign[AFocusedRecord.RecordIndex].MatchingStocks[I].Shares;
    end;
    if numStocks = 0 then begin
      j := cxGrid1TableView1.DataController.FocusedRecordIndex;
      // delete the option from the grid
      FExerciseDS.DeleteRecord(FExerciseDS.GetRecordHandle(j));
      UpdateCount;
      FExerciseDS.DataChanged;
      exit;
    end;
    TrNum := IntToStr(FExerciseAssign[AFocusedRecord.RecordIndex].TrNum);
    frmMain.cxGrid1TableView1.DataController.Filter.beginUpdate;
    frmMain.cxGrid1TableView1.DataController.ClearSelection;
    try
      ClearFilter;
      frmMain.cxGrid1TableView1.DataController.Filter.Active := False;
      ItemList := frmMain.cxGrid1TableView1.DataController.Filter.Root.AddItemList(fboAnd);
      ItemList.BoolOperatorKind := fboOr;
      ItemList.AddItem(frmMain.cxGrid1TableView1.Items[1], foEqual, TrNum, TrNum);
      for I := 0 to FExerciseAssign[AFocusedRecord.RecordIndex].MatchingStocks.Count - 1 do
      if FExerciseAssign[AFocusedRecord.RecordIndex].MatchingStocks[I].Matched = '' then
      begin
        ItNum := IntToStr(FExerciseAssign[AFocusedRecord.RecordIndex].MatchingStocks[I].ID);
        ItemList.AddItem(frmMain.cxGrid1TableView1.Items[0], foEqual, ItNum, ItNum);
      end;
      frmMain.cxGrid1TableView1.DataController.Filter.Active := True;
    finally
      frmMain.cxGrid1TableView1.DataController.Filter.endUpdate;
    end;
    // select STOCK trades
    if (FExerciseAssign[AFocusedRecord.RecordIndex].SharesToMatch
      < FExerciseAssign[AFocusedRecord.RecordIndex].TotalMatchedShares
        - StockSharesAssigned)
    then begin
      btnExercise.Enabled := False;
      exerciseOk := false;
      // there is only 1 stock that matches and there are more shares than contracts
      if (FExerciseAssign[AFocusedRecord.RecordIndex].MatchingStocks.Count = 1)
      then begin
        statBar('off');
        lblNotes.Caption := IntToStr(FExerciseAssign.Count) + ' Option(s) Found';
        lblText.caption := 'TradeLog found one matching stock trade, '+
          'but there are more shares than there are option contracts.' +cr+cr+
          'PLEASE SKIP THIS OPTION!';
        btnExercise.Caption := 'SKIP';
        if AutoExAssign then
          exerciseOk := false
        else
          btnExercise.Enabled := True;
      end
      else begin
        FSelectStocks := True;
        statBar('off');
        lblNotes.Caption := IntToStr(FExerciseAssign.Count) + ' Option(s) Found';
        lblText.caption :=
          'Please select the STOCK trade(s) in the upper grid that you want to assign to this option.' +cr+cr+
          'Use Ctrl-Left-Click to select multiple records.';
      end;
      pnlNotes.Visible := false;
      pnlWarn.Align:= alClient;
      pnlWarn.Visible := true;
    end
    //select OPTION trades
    else if (FExerciseAssign[AFocusedRecord.RecordIndex].SharesToMatch
      > FExerciseAssign[AFocusedRecord.RecordIndex].TotalMatchedShares)
    then begin
      FSelectStocks := False;
      btnExercise.Enabled := False;
      exerciseOK := false;
      statBar('off');
      lblNotes.Caption := IntToStr(FExerciseAssign.Count) + ' Option(s) Found';
      lblText.caption :=
        'Please select the OPTION trade(s) in the upper grid that you want to exercise.' +cr+cr+
        'Use Ctrl-Left-Click to select multiple records.';
      pnlNotes.Visible := false;
      pnlWarn.Align:= alClient;
      pnlWarn.Visible := true;
    end
    else begin
      if AutoExAssign then
        exerciseOk := true
      else
        btnExercise.Enabled := True;
      pnlNotes.Visible := true;
      pnlWarn.Visible := false;
    end;
  end;
  frmMain.pnlFilter.Visible := false;
  if not autoExAssign then begin
    // update blue profit/loss panel
    shOpen := FExerciseAssign[AFocusedRecord.RecordIndex].TotalMatchedShares;
    contrOpen := FExerciseAssign[AFocusedRecord.RecordIndex].SharesToMatch / FExerciseAssign[AFocusedRecord.RecordIndex].Multiplier;
    //sm(floatToStr(shOpen)+cr+floatToStr(contrOpen));
    dispProfit(false,0,shOpen,contrOpen,0);
  end;
end;


// ------------------------------------
procedure TfrmExerciseAssign.FormActivate(Sender: TObject);
begin
  cxGrid1TableView1_Ticker.ApplyBestFit;
end;

// ------------------------------------
procedure TfrmExerciseAssign.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  FirstExerciseAssignNo : Integer;
begin
  try
    FirstExerciseAssignNo := 0;
    if FExercisedClicked then
    begin
      TradeLogFile.RenumberItemField;
      TradeLogfile.MatchAndReorganize;
      FilterByExerciseAssigns(FExerciseAssign.FirstExerciseNum);
      frmMain.pnlFilter.Visible := false;
      FirstExerciseAssignNo := FExerciseAssign.FirstExerciseNum;
      SaveTradesBack('Exercise/Assign');
    end else
    if FSkipClicked then begin
      FirstExerciseAssignNo := 1;
    end;
    Action := caFree;
  finally
    //sm('OptionsNotExercisedCnt = '+intToStr(OptionsNotExercisedCnt));
    PostMessage(Application.MainFormHandle, WM_DISCOVER_EXERCISE_CLOSING, FirstExerciseAssignNo, OptionsNotExercisedCnt);
    FStocksSelected.Free;
    FOptionsSelected.Free;
    autoExAssign := false;
    askOnce := false;
    FreeAndNil(FExerciseAssign);
  end;
end;

// ------------------------------------
procedure TfrmExerciseAssign.FormCreate(Sender: TObject);
begin
  btnExercise.Enabled := true;
  OptionsNotExercisedCnt := 0;
  AutoExDone := false;
  cxStyle4.Color := tlGreen;
  BorderStyle := bsNone;
  FExercisedClicked:= false;
  FSelectStocks := False;
  // We need to see Wash Sales for the Exercise process so temporarily
  // filter them into the grid while the ExerciseAssign form is active.
  filterInWashSales;
  height := 250;
end;

// -----------------------------------------------------------------------
// IMPORTANT: When user clicks on top grid, the Mouse Up event jumps here.
// -----------------------------------------------------------------------
procedure TfrmExerciseAssign.MainGridClicked;
var
  i, recIdx: Integer;
  Shares, Contracts : Double;
begin
  // ----------------------------------
  // see if we can auto-exercise
  // ----------------------------------
  if btnExercise.Enabled
  and (FStocksSelected.Count = 0)
  and (FOptionsSelected.Count = 0)
  then begin
    //frmMain.cxGrid1TableView1.DataController.ClearSelection;
    exerciseOK := false;
    btnExercise.Enabled := false; // 2015.04.28 MB
    //don't exit - MB;
  end;
  // ----------------------------------
  // User is clicking on the main grid in order to select Stock or Option records
  // ----------------------------------
  btnExercise.Enabled := false;
  pnlButtons.Color := clYellow;
  lblExercise.caption := 'Select both a Stock and an Option record in the grid above to exercise.';
  Shares := 0;
  Contracts := 0;
  FStocksSelected.Clear;
  FOptionsSelected.Clear;
    //sm('c = '+intToStr(frmMain.cxGrid1TableView1.DataController.GetSelectedCount));
  // get number of selected stock and option shares
  with frmMain.cxGrid1TableView1.DataController do
  for I := 0 to getSelectedCount - 1 do begin
    recIdx := getRowInfo(GetSelectedRowIndex(I)).RecordIndex;
    if IsOption(TradeLogFile[recIdx].TypeMult, TradeLogFile[recIdx].Ticker)
    and (TradeLogFile[recIdx].OC = 'O')
    then begin
      Contracts := Contracts + (TradeLogFile[recIdx].Shares * TradeLogFile[recIdx].Multiplier);
      FOptionsSelected.Add(TradeLogFile[recIdx]);
    end else
    if IsStockType(TradeLogFile[recIdx].TypeMult) then begin
      Shares := Shares + TradeLogFile[recIdx].Shares;
      FStocksSelected.Add(TradeLogFile[recIdx]);
    end;
  end;
  StatBar('Contracts x100 = ' + floatToStr(Contracts) +
    ' . . . . Shares = ' + floatToStr(Shares));
  // ---------------------------------------------------
  // see if user has selected any stock OR any option...
  // ---------------------------------------------------
  if (FStocksSelected.Count > 0) or (FOptionsSelected.Count > 0) then
    btnSkip.enabled := true
  else
    btnSkip.enabled := false;
  // ----------------------------------
  // user needs to select both stock and option records
  if (shares = 0)
  and (contracts = 0)
  then begin
    mDlg('Please select the OPTION records in the upper grid' + CR //
      + 'that have been exercised.' + cr //
      + cr //
      + 'Use Ctrl-Left-Click to select multiple records',
      mtWarning, [mbYes], 0);
  end;
  // ----------------------------------
  if (Contracts > 0)
  and (shares = 0)
  then begin
    if (Contracts < Shares) then
      lblText.caption := 'Please select another OPTION.' + cr //
        + cr //
        +'Use Ctrl-Left-Click to select multiple records'
    else
      lblText.caption := 'Please select a matching STOCK record.' + cr //
        + cr //
        + 'Use Ctrl-Left-Click to select multiple records';
    exit;
  end else
  if (Contracts < Shares) then
    lblText.caption := 'Please select another OPTION.' + cr //
      + cr //
      + 'Use Ctrl-Left-Click to select multiple records'
  else begin
    lblText.caption := 'Click the Exercise button.';
    btnExercise.Enabled := true;
  end;
  // color Directions panel background
  if btnExercise.Enabled then
    pnlWarn.Color := clBtnFace
  else
    pnlWarn.Color := clYellow;
end;


// ------------------------------------
procedure TfrmExerciseAssign.UpdateCount;
begin
  lblNotes.Caption := IntToStr(FExerciseAssign.Count) + ' Option(s) Found';
end;

{ TExerciseDataSource }
constructor TExerciseDataSource.Create(RecordList: TExerciseAssign);
begin
  FExerciseDiscoverer := RecordList;
end;

//procedure TExerciseDataSource.Delete(AIndex: Integer);
//begin
//  FExerciseDiscoverer.RemoveOption(AIndex);
//  DataController.Refresh;
//end;

procedure TExerciseDataSource.DeleteRecord(ARecordHandle: TcxDataRecordHandle);
begin
  FExerciseDiscoverer.RemoveOption(Integer(ARecordHandle));
  DataChanged;
end;

destructor TExerciseDataSource.Destroy;
begin
  if Assigned(FExerciseDiscoverer) then
    FExerciseDiscoverer.Free;
  inherited;
end;

function TExerciseDataSource.GetRecordCount: Integer;
begin
  Result := FExerciseDiscoverer.Count;
end;

function TExerciseDataSource.GetValue(ARecordHandle: TcxDataRecordHandle;
  AItemHandle: TcxDataItemHandle): Variant;
var
  AColumnId: Integer;
  Option : TOption;
  I : Integer;
  Value : String;
begin
  Option := FExerciseDiscoverer[Integer(ARecordHandle)];
  AColumnId := GetDefaultItemID(Integer(AItemHandle));
  case AColumnId of
    0: Result := 'UnExercised Option';
    1: Result := Option.TrNum;
    2: Result := Option.BuyDate;
    3 : Result := Option.OpenClose;
    4 : Result := Option.LongShort;
    5: Result := Option.OptionTicker;
    6: Result := Option.Contracts;
    7: Result := Option.StrikePrice;
    8: Result := Option.TypeMult;
    9: Result := Option.ExpirationDate;
    10: Result := Option.Expired;
  end;
end;

{ TStocksDataSource }
constructor TStocksDataSource.Create(RecordList: TExerciseAssign);
begin
  FExerciseDiscoverer := RecordList;
end;

destructor TStocksDataSource.Destroy;
begin
  inherited;
end;

function TStocksDataSource.GetRecordCount: Integer;
begin
  Result := FExerciseDiscoverer.Option[DataController.GetMasterRecordIndex].MatchingStocks.Count;
end;

function TStocksDataSource.GetValue(ARecordHandle: TcxDataRecordHandle;
  AItemHandle: TcxDataItemHandle): Variant;
var
  AColumnId: Integer;
  Stock : TTLTrade;
  I : Integer;
  Value : String;
begin
  Stock := FExerciseDiscoverer[DataController.GetMasterRecordIndex].MatchingStocks[Integer(ARecordHandle)];
  AColumnId := GetDefaultItemID(Integer(AItemHandle));
  case AColumnId of
    0: Result := 'Matching Stock';
    1: Result := Stock.ID;
    2: Result := Stock.TradeNum;
    3: Result := Stock.Date;
    4 : Result := Stock.OC;
    5 : Result := Stock.LS;
    6: Result := Stock.Ticker;
    7: Result := Stock.Shares;
    8: Result := Stock.Price;
    9: Result := Stock.TypeMult;
    10 : Result := Stock.Commission;
    11: Result := Stock.Amount;
    12: Result := Stock.Note;
    13: Result := Stock.Strategy;
  end;
end;

end.
