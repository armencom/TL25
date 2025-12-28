unit OpenTrades;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls,
  ComCtrls, cxGridCustomTableView, cxGridTableView, cxGridLevel, cxClasses, cxControls,
  cxGridCustomView, cxGrid, Buttons, cxStyles, ToolWin, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxCurrencyEdit, cxCalc, cxTextEdit, cxMemo, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxMaskEdit, cxDropDownEdit, cxCalendar, ImgList, TLFile,
  TLDataSources, RzButton, RzPanel, cxNavigator, dxCore, cxDateUtils, dxSkinsCore,
  dxSkinHighContrast, dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinscxPCPainter;

type
  TfrmOpenTrades = class(TForm)
    cxGrid1 : TcxGrid;
    cxGridOpenTrades : TcxGridTableView;
    colTrNum : TcxGridColumn;
    colTick : TcxGridColumn;
    colShares : TcxGridColumn;
    colLS : TcxGridColumn;
    cxGrid1Level1 : TcxGridLevel;
    colAvePrice : TcxGridColumn;
    colTypeMult : TcxGridColumn;
    colDate : TcxGridColumn;
    coSort : TcxGridColumn;
    colOpTk : TcxGridColumn;
    RichEdit1 : TRichEdit;
    BitBtn1 : TBitBtn;
    colAmount : TcxGridColumn;
    ImageList1 : TImageList;
    ToolBar1 : TRzToolbar;
    sep1 : TRzSpacer;
    spdYrEndOpen : TRzToolButton;
    sep2 : TRzSpacer;
    spdTransferOpens : TRzToolButton;
    sep3 : TRzSpacer;
    spdPriceToMkt : TRzToolButton;
    sep4 : TRzSpacer;
    spdExpOpt : TRzToolButton;
    sep5 : TRzSpacer;
    spdCopy : TRzToolButton;
    sep6 : TRzSpacer;
    spdPrint : TRzToolButton;
    Label1 : TLabel;
    calAsOf : TcxDateEdit;
    spdExit: TRzToolButton;
    RzSpacer1 : TRzSpacer;
    procedure spdYrEndOpenClick(Sender : TObject);
    procedure spdPriceToMktClick(Sender : TObject);
    procedure spdExpOptClick(Sender : TObject);
    procedure spdCopyClick(Sender : TObject);
    procedure spdPrintClick(Sender : TObject);
    procedure FormCreate(Sender : TObject);
    procedure FormClose(Sender : TObject; var Action : TCloseAction);
    procedure spdCloseClick(Sender : TObject);
    procedure FormShow(Sender : TObject);
    procedure calAsOfPropertiesEditValueChanged(Sender : TObject);
    procedure spdTransferOpensClick(Sender : TObject);
    procedure BitBtn1Click(Sender : TObject);
    procedure colAmountGetDisplayText(Sender : TcxCustomGridTableItem;
      ARecord : TcxCustomGridRecord; var AText : string);
    procedure cxGridOpenTradesCellDblClick(Sender : TcxCustomGridTableView;
      ACellViewInfo : TcxGridTableDataCellViewInfo; AButton : TMouseButton; AShift : TShiftState;
      var AHandled : Boolean);
    procedure spdExitClick(Sender : TObject);
    private
    { Private declarations }
      FOpenTradesRecordSource : TTLOpenTradesDataSource;
      FCloseOperation : Integer;
    { Pressing Escape to close this form twice in quick succession causes
      the Close event to run twice and the second time it fails with an access violation because the
      first time through the controls were free'd, therefore we need to stop the second run
      of the close method so FFormClosing accomplishes this, ARRGHHHHH Delphi! }
      FFormClosing : Boolean;
// procedure OpenTradesAsOf(asOfDate: Tdate);
      procedure filterMainGridbyOpenTrNums;
    public
    { Public declarations }
      procedure UpdateGrid(AsOfDate : TDate);
  end;

var
  AYellowStyle : TcxStyle;
  AWhiteStyle : TcxStyle;


implementation

uses
  Main, FuncProc, RecordClasses, ClipBrd, TLSettings, TLCommonLib, TLRegister, StrUtils;

{$R *.DFM}

var
  loadingOpenPos : Boolean;
  dtAsOf : TDate;

// procedure TfrmOpenTrades.OpenTradesAsOf(asOfDate: Tdate);
// begin
//   try
//     cxGridOpenTrades.DataController.Filter.Active := true;
//     cxGridOpenTrades.DataController.Filter.BeginUpdate;
//     cxGridOpenTrades.DataController.Filter.Root.Clear;
//     cxGridOpenTrades.DataController.Filter.Root.BoolOperatorKind := fboAnd;
//     cxGridOpenTrades.DataController.Filter.Root.AddItem(
//     cxGridOpenTrades.Items[6], foLessEqual, asOfDate,
//     dateToStr(asOfDate, Settings.UserFmt));
//     dtAsOf := asOfDate;
//   finally
//     cxGridOpenTrades.DataController.Filter.EndUpdate;
//   end;
// end;


procedure TfrmOpenTrades.spdExitClick(Sender : TObject);
begin
//  screen.Cursor := crHourGlass;
  Close;
//  screen.Cursor := crDefault;
  // note: cursor is reset by TfrmOpenTrades.FormClose (see below)
end;


procedure TfrmOpenTrades.spdPriceToMktClick(Sender : TObject);
var
  sDate : string;
begin
  if TradeLogFile.Count = 0 then exit;
  if not CheckRecordLimit then exit;
  if not GetOnlineStatus then begin
    mDlg('No Internet Connection Found!' + CR + CR //
      + 'In order to get prices you must be connected to the internet', mtError, [mbOK], 0);
    exit;
  end;
  // ----------------------------------
  FCloseOperation := WPARAM_GET_CURRENT_PRICES;
  Close;
  clearFilter;
  statBar('Loading Grid with Open Positions - Please Wait...');
  try
    // ------------------------------------------------------
    // Create a new OpenTradesRecordsSource from the current
    OpenTradeRecordsSource.Free;
    OpenTradeRecordsSource := TTLTradesDataSource.Create(TradeLogFile.OpenTrades);
    frmMain.cxGrid1TableView1.BeginUpdate;
    frmMain.cxGrid1TableView1.DataController.CustomDataSource := OpenTradeRecordsSource;
    frmMain.cxGrid1TableView1.EndUpdate;
    // ------------------------------------------------------
    repaintGrid;
    SortByTypeNoOpt;
    sDate := FormatDateTime('mm/dd/yyyy', dtAsOf);
    getCurrentPrices(dtAsOf);
  except
    on E : Exception do begin
      if SuperUser then begin
        mDlg('Database Error Message: ' + E.Message + CR //
            + '(click OK to continue.)', mtError, [mbOK], 0);
      end; // if
    end; // on E
  end;
  frmMain.SetupReportsMenu;
  dispProfit(true, 0, 0, 0, 0);
  try
    frmMain.cxGrid1.SetFocus;
  except
    on E : Exception do begin
      if SuperUser then begin
        mDlg('Grid Error Message: ' + E.Message + CR //
            + '(click OK to continue.)', mtError, [mbOK], 0);
      end; // if
    end; // on E
  end;
//  if SuperUser then begin
//    mDlg('exiting spdPriceToMktClick.', mtError, [mbOK], 0);
//  end; // if
end;


procedure TfrmOpenTrades.FormClose(Sender : TObject; var Action : TCloseAction);
begin
  { Pressing Escape to close this form twice in quick succession causes
    this event to run twice and the second time it fails with an access violation because the
    first time through the controls were free'd }
  if FFormClosing then
    exit
  else
    FFormClosing := true;
try
  screen.Cursor := crHourGlass;
  { If they did not click a button that closed the form the filter the main grid on open positions }
  if FCloseOperation = 0 then begin
    try
      filterMainGridbyOpenTrNums;
    finally
      frmMain.Enabled := true;
    end;
  end
  else begin
    statBar('off');
  end;
  frmMain.enableMenuToolsAll; // re-enable main menu bar
finally
  screen.Cursor := crDefault; // never leave cursor disabled!
end;
  // Make sure the calendar gets reset to it's default so that the editChanged method gets called on show.
  PostMessage(Application.MainFormHandle, WM_OPEN_TRADES_CLOSING, FCloseOperation, 0);
  Action := caFree;
  FreeAndNil(FOpenTradesRecordSource);
end;


procedure TfrmOpenTrades.FormCreate(Sender : TObject);
begin
  parent := frmMain;
  BorderStyle := bsNone;
  FCloseOperation := 0;
end;


procedure TfrmOpenTrades.spdExpOptClick(Sender : TObject);
begin
  frmMain.Repaint;
  expireOptions;
  try
    cxGrid1.SetFocus;
  except
  end;
end;


procedure TfrmOpenTrades.spdCloseClick(Sender : TObject);
begin
  if not loadingOpenPos then
    Close;
end;


procedure TfrmOpenTrades.spdCopyClick(Sender : TObject);
var
  R : Integer;
begin
  clipboard.clear;
  cxGridOpenTrades.CopyToClipboard(true);
  R := cxGridOpenTrades.DataController.RecordCount;
  sm(IntToStr(R) + ' Records copied');
end;


procedure TfrmOpenTrades.spdPrintClick(Sender : TObject);
var
  i, j, l, R : Integer; // , p
  s, sp, TrNum, tick, sh, ls, typ, pr, Amount : string;
  printDialog : TPrintDialog;
begin
  s := '';
  // Report headers
  s := '     TrNum:  Ticker:                                 ' //
    + 'Shares:        L/S:   Type/Mult:      Price:             Amount:' + crlf + crlf;
  // p := pos('Opt', s);
  with cxGridOpenTrades.DataController do begin
    for i := 0 to RecordCount - 1 do begin
      R := filteredRecordIndex[i];
      // TrNum
      TrNum := values[R, 0];
      sp := '';
      for j := 1 to 8 - length(TrNum) do
        sp := sp + ' ';
      s := s + '     ' + TrNum + sp;
      // tick
      tick := values[R, 1];
      sp := '';
      for j := 1 to 40 - length(tick) do
        sp := sp + ' ';
      s := s + tick + sp;
      // sh
      sh := values[R, 2];
      sp := '';
      if pos('.', sh) > 0 then begin
        for j := 1 to 8 - length(copy(sh, 1, pos('.', sh))) do
          sp := sp + ' ';
        s := s + sp + sh;
        sp := '';
        for j := 1 to 6 - length(copy(sh, pos('.', sh) + 1, length(sh) - pos('.', sh))) do
          sp := sp + ' ';
        s := s + sp;
      end
      else begin
        for j := 1 to 7 - length(sh) do
          sp := sp + ' ';
        s := s + sp + sh + '       ';
      end;
      // ls
      ls := values[R, 3];
      sp := '';
      for j := 1 to 8 - length(ls) do
        sp := sp + ' ';
      s := s + ls + sp;
      // type
      typ := values[R, 4];
      sp := '';
      for j := 1 to 10 - length(typ) do
        sp := sp + ' ';
      s := s + typ + sp;
      // price
      // pr := floatToStr(rndto5(values[R, 5]), Settings.UserFmt);
      pr := CurrStrEx(values[R, 5], Settings.UserFmt, False, true, 6);
      sp := '';
      if pos('.', pr) > 0 then
        for j := 1 to 8 - length(copy(pr, 1, pos('.', pr))) do
          sp := sp + ' '
      else
        for j := 1 to 7 - length(pr) do
          sp := sp + ' ';
      s := s + sp + pr;
      sp := '';
      // get number of decimals
      if pos('.', pr) > 0 then begin
        j := length(pr) - pos('.', pr);
        // set sp at 9 spaces
        sp := '         ';
        // remove 1 space for each decimal point
        for l := 1 to j do
          delete(sp, 1, 1);
      end
      else
        sp := '          ';
      // Amount
      Amount := CurrStrEx(values[R, 8], Settings.UserFmt, False, true, 2);
      if pos('.', Amount) > 0 then
        for j := 1 to 15 - length(copy(Amount, 1, pos('.', Amount))) do
          sp := sp + ' '
      else
        for j := 1 to 14 - length(Amount) do
          sp := sp + ' ';
      s := s + sp + Amount;
      s := s + crlf;
    end; // for i
  end; // with cxGridOpenTrades.DataController
  // clipboard.astext:= s;
  // Create a printer selection dialog
  printDialog := TPrintDialog.Create(self);
  try
    if printDialog.Execute then begin
      with RichEdit1 do begin
        clear;
        font.Name := 'Courier New';
        lines.add('');
        lines.add('');
        lines.add('');
        lines.add('     Open Trades As Of: ' + DateTimeToStr(calAsOf.Date, Settings.UserFmt));
        lines.add('              FileName: ' + trFileName);
        lines.add('            Account(s): ' + TradeLogFile.CurrentAcctName);
        lines.add('');
        // PasteFromClipboard;
        lines.add(s);
        Print(trFileName);
      end;
    end; // if printDialog
  finally
    printDialog.Free;
  end;
end;


procedure TfrmOpenTrades.spdTransferOpensClick(Sender : TObject);
//var
//  n : integer;
begin
  if not CheckRecordLimit then exit;
//  n := cxGridOpenTrades.DataController.GetSelectedCount;
//  if n > 0 then begin
//    sm(IntToStr(n) + ' rows selected.');
//    exit;
//  end;
  FCloseOperation := WPARAM_TRANSFER_OPEN_POSITIONS;
  Close;
end;


procedure TfrmOpenTrades.filterMainGridbyOpenTrNums;
var
  i : Integer;
  trNums :string;
begin
  if not frmMain.btnShowOpen.Down then exit;
  if FOpenTradesRecordSource.TradeNums.Count = 0 then begin
    frmMain.btnShowAll.Click;
  end
  else begin
    trNums := '';
    clearFilter;
    screen.Cursor := crHourGlass;
    for i := 0 to FOpenTradesRecordSource.TradeNums.Count - 1 do begin
      if trNums = '' then
        trNums := trNums + IntToStr(FOpenTradesRecordSource.TradeNums[i].TradeNum)
      else
        trNums := trNums + ',' + IntToStr(FOpenTradesRecordSource.TradeNums[i].TradeNum);
    end;
    screen.Cursor := crHourGlass;
    if length(trNums) > 0 then
      filterByTrNum(trNums, true);
    screen.Cursor := crDefault;
    // filter by end date   ????  why needed ????
     try
      frmMain.cxGrid1TableView1.DataController.Filter.BeginUpdate;
      frmMain.cxGrid1TableView1.DataController.Filter.root.AddItem(
      frmMain.cxGrid1TableView1.Items[2],foLessEqual,calAsOf.date,calAsOf.text);
      frmMain.cxGrid1TableView1.DataController.Filter.active:= true;
    finally
      frmMain.cxGrid1TableView1.DataController.Filter.EndUpdate;
    end;
  end;
end;


procedure TfrmOpenTrades.FormShow(Sender : TObject);
begin
  screen.Cursor := crHourGlass;
  statBar('Loading Open Positions Windows - Please Wait...');
  Align := alClient;
  cxGrid1.Align := alClient;
  FFormClosing := False;
  cxGridOpenTrades.items[0].DataBinding.ValueTypeClass := TcxIntegerValueType; // TrNum
  cxGridOpenTrades.items[1].DataBinding.ValueTypeClass := TcxStringValueType; // Ticker
  cxGridOpenTrades.items[2].DataBinding.ValueTypeClass := TcxFloatValueType; // Shares
  cxGridOpenTrades.items[3].DataBinding.ValueTypeClass := TcxStringValueType; // Long/Short
  cxGridOpenTrades.items[4].DataBinding.ValueTypeClass := TcxStringValueType; // Type/Mult
  cxGridOpenTrades.items[5].DataBinding.ValueTypeClass := TcxFloatValueType; // Ave Price
  cxGridOpenTrades.items[6].DataBinding.ValueTypeClass := TcxStringValueType; // Date
  cxGridOpenTrades.items[7].DataBinding.ValueTypeClass := TcxStringValueType; // Sort
  cxGridOpenTrades.items[8].DataBinding.ValueTypeClass := TcxFloatValueType; // Amount
  cxGridOpenTrades.items[9].DataBinding.ValueTypeClass := TcxStringValueType; // opTk
  cxGrid1.SetFocus;
  calAsOf.Date := TradeLogFile.LastDateImported;
  spdTransferOpens.Visible := TradeLogFile.CurrentBrokerID > 0;
  sep3.Visible := spdTransferOpens.Visible;
  spdYrEndOpen.Visible := (TradeLogFile.LastDateImported >
      xStrToDate('12/31/' + IntToStr(TradeLogFile.TaxYear), Settings.InternalFmt));
  sep2.Visible := spdYrEndOpen.Visible;
end;


procedure TfrmOpenTrades.BitBtn1Click(Sender : TObject);
begin
  Close; // attach ESC key to this button
end;


procedure TfrmOpenTrades.calAsOfPropertiesEditValueChanged(Sender : TObject);
begin
  statBar('Loading Open Positions - Please Wait...');
  screen.Cursor := crHourGlass;
  try
    loadingOpenPos := true;
    if calAsOf.Date = xStrToDate('12/31/' + TaxYear, Settings.InternalFmt) then begin
      spdYrEndOpen.caption := 'All Open Positions';
      spdYrEndOpen.Hint := 'Show All open positions in file';
    end
    else begin
      spdYrEndOpen.caption := 'Year End Open Positions';
      spdYrEndOpen.Hint := 'Show year end open positions';
    end;
    UpdateGrid(calAsOf.Date);
    if cxGridOpenTrades.DataController.RowCount > 0 then begin
      statBar((IntToStr(cxGridOpenTrades.DataController.RowCount) + ' Open Position(s) as of ') +
          calAsOf.text);
    end
    else begin
      statBar('There are NO open positions as of ' + calAsOf.text);
    end;
    cxGrid1.SetFocus;
    loadingOpenPos := False;
  finally
    screen.Cursor := crDefault;
  end;
end;


// --------------------------------------------------------
// on Get Display Text
// --------------------------------------------------------
procedure TfrmOpenTrades.colAmountGetDisplayText(Sender : TcxCustomGridTableItem;
  ARecord : TcxCustomGridRecord; var AText : string);
begin
  if IsFloat(AText) then
    AText := CurrStrEx(StrToFloat(AText), Settings.UserFmt, true, true, 5);
end;


// --------------------------------------------------------
// On grid cell double-click
// --------------------------------------------------------
procedure TfrmOpenTrades.cxGridOpenTradesCellDblClick(Sender : TcxCustomGridTableView;
  ACellViewInfo : TcxGridTableDataCellViewInfo; AButton : TMouseButton; AShift : TShiftState;
  var AHandled : Boolean);
var
  TrNum : Integer;
begin
  if loadingOpenPos then
    exit;
  FCloseOperation := WPARAM_FILTER_BY_TRNUM;
  with cxGridOpenTrades.DataController do
    TrNum := values[focusedRecordIndex, 0];
  with frmMain.cxGrid1TableView1 do begin
    with DataController.filter do begin
      DataController.ClearSelection;
      active := true;
      beginUpdate;
      clearFilter; // root.clear;
      root.AddItem(items[1], foEqual, TrNum, IntToStr(TrNum));
      endUpdate;
    end;
  end;
  dispProfit(true, 0, 0, 0, 0);
  with frmMain do begin
    btnShowAll.Down := False;
    btnAddRec.Enabled := not(OneYrLocked or isAllBrokersSelected);
    btnInsRec.Enabled := not(OneYrLocked or isAllBrokersSelected);
    btnDelRec.Enabled := not(OneYrLocked or isAllBrokersSelected);
    addRecord1.Enabled := not(OneYrLocked or isAllBrokersSelected);
    insertRecord1.Enabled := not(OneYrLocked or isAllBrokersSelected);
    enterOpenPositions1.Enabled := not(OneYrLocked or isAllBrokersSelected);
  end;
  Close;
  frmMain.btnShowAll.Down := False;
  AHandled := true;
  screen.Cursor := crDefault;
end;


procedure TfrmOpenTrades.spdYrEndOpenClick(Sender : TObject);
var
  Year, Month, Day : Word;
begin
  DecodeDate(now, Year, Month, Day);
  if pos('All', spdYrEndOpen.caption) > 0 then begin
    // So this might include January of next year, if they exist.
    spdYrEndOpen.caption := 'Year End Open Positions';
    spdYrEndOpen.Hint := 'Show year end open positions';
    calAsOf.Date := TradeLogFile.LastDateImported;
  end
  else begin
    spdYrEndOpen.caption := 'All Open Positions';
    spdYrEndOpen.Hint := 'Show All open positions in file';
    calAsOf.Date := StrToDate('12/31/' + IntToStr(TradeLogFile.TaxYear), Settings.InternalFmt);
  end;
end;


procedure TfrmOpenTrades.UpdateGrid(AsOfDate : TDate);
var
  i : Integer;
begin
  dtAsOf := AsOfDate;
  if Assigned(FOpenTradesRecordSource) then
    FreeAndNil(FOpenTradesRecordSource);
  FOpenTradesRecordSource := TTLOpenTradesDataSource.Create(TradeLogFile.OpenPositions[AsOfDate],
    cxGridOpenTrades, AsOfDate);
  cxGridOpenTrades.DataController.CustomDataSource := FOpenTradesRecordSource;
  for i := 0 to 9 do
    cxGridOpenTrades.items[i].sortorder := soNone;
  cxGridOpenTrades.items[4].sortorder := soDescending;
  cxGridOpenTrades.items[7].sortorder := soAscending;
  cxGridOpenTrades.DataController.gotoFirst;
  FOpenTradesRecordSource.DataChanged;
  for i := 0 to FOpenTradesRecordSource.TradeNums.Count - 1 do begin
    if IsOption(FOpenTradesRecordSource.TradeNums[i].TypeMult,
      FOpenTradesRecordSource.TradeNums[i].Ticker) then begin
      colOpTk.Visible := true;
      break;
    end;
  end; // for i
end;


end.
