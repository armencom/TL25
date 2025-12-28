unit RecordClasses;

interface

uses
  Controls, SysUtils, Dialogs, Classes, FuncProc, Variants, //
  cxCustomData, cxGridCustomTableView, cxStyles, TLDataSources, cxCheckComboBox;

procedure EditEnable;
procedure EditDisable(inserting : boolean);

function SaveGridData(renum : boolean; silent : boolean = false; SaveToDisk : boolean = True)
  : boolean;

procedure ClearFilter;
procedure ClearGroup;

procedure FilterByOpenClosed(oc : string);
procedure FilterYearEndOpen;
procedure FilterSec481;
procedure FilterMTM;

procedure FilterByCusip;

procedure FilterByOptTickers;
procedure FilterByTrNum(TrNumStr :string; OpenTrades : boolean = false);
procedure FilterByItemNumber(ItemNumStr : string);
procedure FilterByTick(tick :string);
procedure FilterByUnderlying(tick :string);
procedure FilterByDuplicateItems;
procedure FilterByLS(ls :string);
procedure FilterByType(cType : string; ClrFilter : boolean = false);
procedure FilterByStkAssignsPriceZero;

  {
    (Report Filtering) Used to filter in or out Futures with
    stocks for an MTM Account
 }
function FilterForMTMStocks : boolean;
  {
    (Report Filtering) Used to filter in or out Futures for Futures Report
    Takes into consideration MTM Accounts that have elected futures.
 }
function FilterForFutures : boolean;
function FilterForCurrencies : boolean;
function FilterByBrokerAccountType(MTM : boolean; Ira : boolean; Cash : boolean;
  Clear : boolean = false; IncludeCashFuturesAsMTM : boolean = false;
  IncludeVTNinMTMaccount : boolean = false) : boolean; // 2018-03-29 MB - New argument

procedure FilterByOpenPositons(EndDate : TDate; ClrFilter : boolean = false);
procedure filterByOpenPositonsMTM(EndDate : TDate; ClrFilter : boolean = false);
procedure FilterByDateRange(StartDt, EndDt : TDate; ClrFilter : boolean = True);

procedure FilterByBrokerAcct(BrokerID : Integer; AccountName : string);

procedure FilterPurchSales(s :string);
procedure FilterCallPut(tk :string);
procedure filterTaxLots(id : Integer = 0);
procedure FilterExAssigns(n :string; Clear : boolean = false);
procedure FilterByExerciseAssigns(StartingNum : Integer);
procedure FilterByOpenTrades(oc : string);
procedure FilterOutWashSales;
procedure filterInWashSales;
procedure FilterMTMLastyear;

procedure DelSelectedRecords(bCut : boolean = false);
procedure GetCurrentPrices(dtAsOf : TDate);
function GetYearEndMTMprice(tkStr :string; typemult : string; lastYr : boolean): double;

procedure MyDeleteSelection;
procedure CalcProfitOpenTrades(TrNum : Integer);

procedure ReadFilter;
procedure WriteFilter(del : boolean);

function GetFilterCaption : string;

function GetAccountNamesFromFilter : string;

function GetOptInfo(tkStr :string):string;
function GetExpMoFutCode(s :string):string;
function GetFutCodeExpMo(s :string):string;
function formatMatchedSort(m :string) : string;
function GetPriceStock(tkStr :string): double;

procedure FindTradeIssues;
procedure dispNegShTicker(tick :string);
procedure DispTradesNegShares;
procedure DispTradesCancelled;
procedure DispTradesMisMatched;
procedure DispTradesMisMatchedLS;
procedure DispZeroOrLessTrades;

var
  TradeRecordsSource : TTLFileDataSource;
  OpenTradeRecordsSource : TTLTradesDataSource;
  NegClosedTrNums : TstringList;
  HasTime, stopUpdate, stopDel, DeletingRecords, haltCustDraw : boolean;
  getCurrPriceRow : Integer;
  filtTxt : TcxDataFilterCriteria;
  myFilter : TStream;


implementation

uses
  Forms, Windows, StrUtils, System.Generics.Collections, //
  cxFilter, cxDataStorage, cxEdit, cxCalendar, //
  Main, Import, OpenTrades, myInput, ClipBrd, //
  frmOFX, globalVariables, TLRegister, TLSettings, //
  messagePanel, TLFile, TLCommonLib, TLWinInet, db, TL_API;


procedure EditEnable;
begin
  with frmMain.cxGrid1TableView1 do begin
    OptionsData.Editing := True;
    OptionsSelection.CellSelect := True;
    OptionsView.ShowEditButtons := gsebForFocusedRecord;
    with controller do begin
      editingItem := focusedItem;
    end;
  end;
  frmMain.bindStrategy;
end;


procedure EditDisable(inserting : boolean);
begin
  with frmMain.cxGrid1TableView1 do begin
    OptionsData.Editing := false;
    OptionsView.ShowEditButtons := gsebNever;
  end;
end;


function SaveGridData(renum : boolean; silent : boolean = false;
  SaveToDisk : boolean = True): boolean;
var
  I, editID : Integer;
begin
  editID := -1;
  Result := True;
  if frmMain.cxGrid1TableView1.dataController.FocusedRecordIndex > -1 then
    editID := TradeLogFile[frmMain.cxGrid1TableView1.dataController.FocusedRecordIndex].id;
  with frmMain do begin
    if (cxGrid_4_OC.EditValue = 'W') //
      and not silent //
      and cxGrid1TableView1.OptionsData.Editing //
    then begin
      mDlg('NOTE: You must now enter a corresponding open record that matches the ' + cr //
          + 'Date and Number of Shares of the W record you just entered,' + cr + cr //
          + 'unless you already have entered this record.', mtInformation,[mbOK], 0);
    end;
  end;
  // cancel edit mode
  EditDisable(false);
  ReadFilter;
  if renum then
    TradeLogFile.MatchAndReorganizeAllAccounts;
  { Refresh the grid and clear the selection since the row has moved. }
  TradeRecordsSource.DataChanged;
  Application.ProcessMessages;
  frmMain.cxGrid1TableView1.dataController.ClearSelection;
  try
    // Select the record we just added/modified
    if editID > -1 then begin
      for I := 0 to frmMain.cxGrid1TableView1.dataController.FilteredRecordCount - 1 do
        if TradeLogFile[frmMain.cxGrid1TableView1.dataController.FilteredRecordIndex[I]].id = editID
        then begin
          frmMain.cxGrid1TableView1.dataController.SelectRows(I, I);
          break;
        end;
    end;
  except
    { We are just trying to get back to the row just modified, but if it fails we don't
      want to report any exceptions. }
  end;
  if SaveToDisk then
    SaveTradeLogFile;
  if panelMsg.HasTradeIssues then begin
    frmMain.GridFilter := gfAll;
    frmMain.btnShowAll.click;
  end
  else
    WriteFilter(false);
end;


procedure ClearFilter();
var
  s, t : string;
begin
  t := 'clearing filter';
  s := GetFilterCaption;
  frmMain.cxGrid1TableView1.dataController.BeginUpdate;
  try
    t := 'column filtering';
    try // except
      if frmMain.cxGrid1TableView1.OptionsCustomize.ColumnFiltering then
        frmMain.cxGrid1TableView1.OptionsCustomize.ColumnFiltering := false;
      t := 'clear sorting';
      frmMain.cxGrid1TableView1.dataController.ClearSorting(false);
      // Performance Enhancement for large files: When ClearFilter is called on
      // a large file, a lot of time is spent unfiltering and refiltering by
      // broker. This happens everytime this method is called. This is especially
      // painful when there is only one broker in a file, since the broker
      // Account field will always be in the filter.
      // Therefore we can short circuit this method if there is really no need
      // to clear and recreate the filter. GetFilterCaption will remove the
      // WashSale and Broker Filter so now we can check the length of this to
      // see if anything actually needs to be cleared. Also we check and verify
      // that the broker Account we are filtered for is the current one.
      // If these conditions are so then we don't need to clear the filter
      t := 'checking for Account filter';
      if (Length(s) = 0) //
      and (pos('(Broker Account = ' + IntToStr(TradeLogFile.CurrentBrokerID) + ')',
          frmMain.cxGrid1TableView1.dataController.Filter.FilterText) > 0) then
        exit;
    except
      sm('Record Class error 221 in ' + t);
    end;
    // ---------------------------
    t := 'filter clear';
    try
      frmMain.cxGrid1TableView1.dataController.Filter.Clear;
    except
      on E: Exception do begin
        gsErrorText := 'Error 229 clearing filter.' + cr //
          + ' Error: ' + E.Message;
      end;
    end; // try... except
    // Even after clearing a filter the DispWS filter and the Broker Filter
    // should never be removed so add them back (NOTE: This is wrong for IRA!)
    t := 'filter out wash sales';
    if not Settings.DispWSdefer then
      FilterOutWashSales;
    t := 'checking broker ID';
    if TradeLogFile.CurrentBrokerID > 0 then begin
      try
        t := 'filter by broker account';
        FilterByBrokerAcct(TradeLogFile.CurrentBrokerID, TradeLogFile.CurrentAccount.AccountName);
      except
        if SuperUser then
          gsErrorText := 'Error 242 in Clear Filter: ' + t;
      end;
    end; // if CurrentBrokerID > 0
  finally
    frmMain.cxGrid1TableView1.dataController.EndUpdate;
  end;
end; // ClearFilter


procedure ClearGroup;
begin
  with frmMain do begin
    with cxGrid1TableView1 do begin
      with OptionsCustomize do begin
        if ColumnFiltering or ColumnGrouping then begin
          ColumnFiltering := false;
          ColumnGrouping := false;
        end;
      end;
      with OptionsView do begin
        GroupByBox := false;
      end;
      with dataController do begin
        // clearSelection;
        Groups.ClearGrouping;
      end;
    end;
  end;
end;


procedure FilterByOpenClosed(oc : string);
var
  I : Integer;
  AFiltList : TcxFilterCriteriaItemList;
begin
  frmMain.cxGrid1TableView1.dataController.Filter.BeginUpdate;
  try
    frmMain.cxGrid1TableView1.dataController.Filter.Root.BoolOperatorKind := fboAnd;
// if oc='O' then begin
// AFiltList := frmMain.cxGrid1TableView1.DataController.filter.Root.AddItemList(fboOr);
// for i:= 0 to TradeLogFile.TradeNums.Count - 1 do
// AFiltList.AddItem(frmMain.cxGrid1TableView1.items[1],foEqual,
// TradeLogFile.TradeNums[I].TradeNum, intToStr(TradeLogFile.TradeNums[I].TradeNum));
// if AFiltList.count=0 then AFiltList.AddItem(frmMain.cxGrid1TableView1.items[0],foEqual,-1,'');
// end;
// if oc='C' then begin
// AFiltList := frmMain.cxGrid1TableView1.DataController.filter.Root.AddItemList(fboAnd);
// for i:= 0 to TradeLogFile.TradeNums.Count - 1 do
// AFiltList.AddItem(frmMain.cxGrid1TableView1.items[1],foNotEqual	,
// TradeLogFile.TradeNums[I].TradeNum,intToStr(TradeLogFile.TradeNums[I].TradeNum));
// if AFiltList.count=0 then AFiltList.AddItem(frmMain.cxGrid1TableView1.items[0],foNotEqual,-10,'');
// end;
    AFiltList := frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItemList(fboAnd);
    AFiltList.AddItem(frmMain.cxGrid1TableView1.items[4], foEqual, oc, oc);
    frmMain.cxGrid1TableView1.dataController.Filter.active := True;
  finally
    frmMain.cxGrid1TableView1.dataController.Filter.EndUpdate;
  end;
end;


procedure FilterYearEndOpen;
var
  I : Integer;
  AFiltList : TcxFilterCriteriaItemList;
  EndDt : TDate;
begin
  frmMain.cxGrid1TableView1.dataController.Filter.BeginUpdate;
  try
    ClearFilter; // root.clear;
    frmMain.cxGrid1TableView1.dataController.Filter.Root.BoolOperatorKind := fboAnd;
    // only open and year end
    EndDt := xStrToDate('12/31/' + Taxyear, Settings.InternalFmt);
    AFiltList := frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItemList(fboAnd);
    AFiltList.AddItem(frmMain.cxGrid1TableView1.items[2], foLessEqual, EndDt,
      dateToStr(EndDt, Settings.UserFmt));
    AFiltList := frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItemList(fboOr);
    for I := 0 to TradeLogFile.TradeNums.Count - 1 do
      AFiltList.AddItem(frmMain.cxGrid1TableView1.items[1], foEqual,
        TradeLogFile.TradeNums[I].TradeNum, IntToStr(TradeLogFile.TradeNums[I].TradeNum));
    if AFiltList.Count = 0 then
      AFiltList.AddItem(frmMain.cxGrid1TableView1.items[0], foEqual,-1, '');
    frmMain.cxGrid1TableView1.dataController.Filter.active := True;
  finally
    frmMain.cxGrid1TableView1.dataController.Filter.EndUpdate;
  end;
end;


procedure FilterOutWashSales;
var
  // i:integer;
  AFiltList : TcxFilterCriteriaItemList;
begin
  if pos('O/C <> W', frmMain.cxGrid1TableView1.dataController.Filter.filterCaption)> 0 then
    exit;
  frmMain.cxGrid1TableView1.dataController.Filter.BeginUpdate;
  try
    AFiltList := frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItemList(fboAnd);
    AFiltList.AddItem(frmMain.cxGrid1TableView1.items[4], foNotEqual, 'W', 'W');
    frmMain.cxGrid1TableView1.dataController.Filter.active := True;
  finally
    frmMain.cxGrid1TableView1.dataController.Filter.EndUpdate;
  end;
end;


procedure filterInWashSales;
begin
  if pos('((O/C <> ''W''))', frmMain.cxGrid1TableView1.dataController.Filter.FilterText) > 0 then
    try
      frmMain.cxGrid1TableView1.dataController.Filter.BeginUpdate;
      frmMain.cxGrid1TableView1.dataController.Filter.RemoveItemByItemLink(frmMain.cxGrid_4_OC);
      frmMain.cxGrid1TableView1.dataController.Filter.active := True;
    finally
      frmMain.cxGrid1TableView1.dataController.Filter.EndUpdate;
    end;
end;


procedure FilterByItemNumber(ItemNumStr : string);
var
  AFiltList : TcxFilterCriteriaItemList;
  ItemNum : string;
begin
  if ItemNumStr = '' then
    exit;
  if not(frmMain.GridFilter = gfTradeIssues) then
    frmMain.GridFilter := gfNone;
  with frmMain.cxGrid1TableView1 do
    with dataController.Filter do begin
      active := True;
      BeginUpdate;
      try
        ClearFilter; // root.clear;
        if pos(',', ItemNumStr)> 0 then begin
          Root.BoolOperatorKind := fboAnd;
          AFiltList := Root.AddItemList(fboOr);
          ItemNumStr := ItemNumStr + ',';
          while (pos(',', ItemNumStr)> 0) do begin
            ItemNum := copy(ItemNumStr, 1, pos(',', ItemNumStr)- 1);
            AFiltList.AddItem(items[0], foEqual, strToInt(ItemNum), ItemNum);
            delete(ItemNumStr, 1, pos(',', ItemNumStr));
          end;
        end
        else
          Root.AddItem(items[0], foEqual, strToInt(ItemNumStr), ItemNumStr);
      finally
        EndUpdate;
      end;
    end;
end;


procedure FilterByTrNum(TrNumStr :string; OpenTrades : boolean = false);
var
  restart : bool;
  TrNum : string;
  AFiltList : TcxFilterCriteriaItemList;
begin
  repeat
    if TrNumStr = '' then begin
      frmInput.display('Find Trade Number', 'ENTER TRADE NUMBERS TO FIND: ' + cr + cr //
          + '(examples:  1  or  1-10  or  1,3,5,10 )', '');
      TrNumStr := frmInput.inputStr;
    end;
    if TrNumStr = '' then
      exit;
    if not OpenTrades then
      frmMain.GridFilter := gfNone;
    frmMain.cxGrid1TableView1.dataController.Filter.BeginUpdate;
    try
      restart := false;
      if pos('-', TrNumStr)> 0 then begin
        AFiltList := frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItemList(fboAnd);
        TrNum := copy(TrNumStr, 1, pos('-', TrNumStr)- 1);
        if not IsInt(TrNum) then
          restart := True
        else begin
          AFiltList.AddItem(frmMain.cxGrid1TableView1.items[1], foGreaterEqual,
            strToInt(TrNum), TrNum);
          delete(TrNumStr, 1, pos('-', TrNumStr));
          TrNum := TrNumStr;
          if not IsInt(TrNum) then
            restart := True
          else
            AFiltList.AddItem(frmMain.cxGrid1TableView1.items[1], foLessEqual,
              strToInt(TrNum), TrNum);
        end;
      end
      else if pos(',', TrNumStr)> 0 then begin
        frmMain.cxGrid1TableView1.dataController.Filter.Root.BoolOperatorKind := fboAnd;
        AFiltList := frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItemList(fboOr);
        TrNumStr := TrNumStr + ',';
        while (restart = false) and (pos(',', TrNumStr)> 0) do begin
          TrNum := copy(TrNumStr, 1, pos(',', TrNumStr)- 1);
          if not IsInt(TrNum) then
            restart := True
          else begin
            AFiltList.AddItem(frmMain.cxGrid1TableView1.items[1], foEqual, strToInt(TrNum), TrNum);
            delete(TrNumStr, 1, pos(',', TrNumStr));
          end;
        end;
      end
      else if not IsInt(TrNumStr) then
        restart := True
      else
        frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItem
          (frmMain.cxGrid1TableView1.items[1], foEqual, strToInt(TrNumStr), TrNumStr);
      if restart then begin
        mDlg('Trade Numbers Must Be a Number', mtError, [mbOK], 0);
        TrNumStr := '';
      end;
      frmMain.cxGrid1TableView1.dataController.Filter.active := True;
    finally
      frmMain.cxGrid1TableView1.dataController.Filter.EndUpdate;
    end;
  until restart = false;
  screen.cursor := crDefault;
end;


procedure FilterCallPut(tk :string);
begin
  frmMain.cxGrid1TableView1.dataController.Filter.BeginUpdate;
  try
    frmMain.GridFilter := gfNone;
    frmMain.cxGrid1TableView1.dataController.Filter.PercentWildcard := '*';
    frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItem(frmMain.cxGrid1TableView1.items[6],
      foLike, tk, tk);
    frmMain.cxGrid1TableView1.dataController.Filter.active := True;
  finally
    frmMain.cxGrid1TableView1.dataController.Filter.EndUpdate;
  end;
end;


procedure FilterByTick(tick :string);
var
  tk, tkl : string;
  AFiltList : TcxFilterCriteriaItemList;
begin
  frmMain.cxGrid1TableView1.dataController.Filter.BeginUpdate;
  try
    frmMain.GridFilter := gfNone;
    frmMain.cxGrid1TableView1.dataController.Filter.PercentWildcard := '*';
    if pos('-', tick)> 0 then begin
      tk := copy(tick, 1, pos('-', tick)- 1);
      delete(tick, 1, pos('-', tick));
      tkl := tick;
      frmMain.cxGrid1TableView1.dataController.Filter.Root.BoolOperatorKind := fboOr;
      AFiltList := frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItemList(fboAnd);
      AFiltList.AddItem(frmMain.cxGrid1TableView1.items[6], foGreaterEqual, tk, tk);
      AFiltList.AddItem(frmMain.cxGrid1TableView1.items[6], foLessEqual, tkl, tkl);
      frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItem
        (frmMain.cxGrid1TableView1.items[6], foLike, tkl + '*', tkl);
    end
    else if pos(',', tick)> 0 then begin
      frmMain.cxGrid1TableView1.dataController.Filter.Root.BoolOperatorKind := fboAnd;
      AFiltList := frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItemList(fboOr);
      tick := tick + ',';
      while pos(',', tick)> 0 do begin
        tk := copy(tick, 1, pos(',', tick)- 1);
        AFiltList.AddItem(frmMain.cxGrid1TableView1.items[6], foLike, tk, tk);
        delete(tick, 1, pos(',', tick));
      end;
    end
    else begin
      tk := tick;
      frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItem
        (frmMain.cxGrid1TableView1.items[6], foLike, tk, tk);
    end;
    frmMain.cxGrid1TableView1.dataController.Filter.active := True;
  finally
    frmMain.cxGrid1TableView1.dataController.Filter.EndUpdate;
  end;
end;


procedure FilterByUnderlying(tick :string);
begin
  FilterByTick(tick+'*');
end;

procedure FilterByDuplicateItems;
var
  I, x, recIdx, recIdx2 : Integer;
  ItemNumStr, ItemNum, tick : string;
  AFiltList : TcxFilterCriteriaItemList;
begin
  x := 0;
  ItemNumStr := '';
  // make sure we are NOT on ALL account tab
  if (TradeLogFile.FileHeaders.Count > 1) //
    and (frmMain.TabAccounts.TabIndex = 0) then begin
    mDlg('Cannot perform this function on the ALL accounts tab', mtWarning, [mbOK], 0);
    exit;
  end;
  sortByAmount;
  frmMain.repaint;
  statBar('Finding Duplicates - Please Wait...');
  screen.cursor := crHourglass;
    // sm('FilteredRecordCount = '+intToStr(frmMain.cxGrid1tableView1.DataController.FilteredRecordCount));
  // get all duplicate trade item numbers
  for I := 0 to frmMain.cxGrid1TableView1.dataController.FilteredRecordCount - 2 do begin
    recIdx := frmMain.cxGrid1TableView1.dataController.FilteredRecordIndex[I];
    recIdx2 := frmMain.cxGrid1TableView1.dataController.FilteredRecordIndex[I + 1];
    if (TradeLogFile[recIdx].Date = TradeLogFile[recIdx2].Date) //
      and (TradeLogFile[recIdx].Time = TradeLogFile[recIdx2].Time) //
      and (TradeLogFile[recIdx].Ticker = TradeLogFile[recIdx2].Ticker) //
      and (TradeLogFile[recIdx].Shares = TradeLogFile[recIdx2].Shares) //
      and (TradeLogFile[recIdx].Amount = TradeLogFile[recIdx2].Amount) //
    then begin
      ItemNumStr := ItemNumStr + IntToStr(TradeLogFile[recIdx].id) + ',' //
        + IntToStr(TradeLogFile[recIdx2].id) + ',';
      inc(x);
    end;
  end;
  if (x = 0) then begin
    frmMain.btnShowAll.click;
    sm('No duplicates found.');
    exit;
  end
  else if (x > 1000) then begin
    frmMain.btnShowAll.click;
    mDlg('You have ' + IntToStr(x) + ' duplicate trade records.' + cr + cr +
        'Please filter the grid by a smaller date range.', mtWarning, [mbOK], 0);
    exit;
  end;
  // fill grid with duplicate trades
  statBar('Filtering Grid to Show Duplicates - Please Wait...');
  screen.cursor := crHourglass;
  try
    frmMain.cxGrid1TableView1.dataController.BeginUpdate;
    ClearFilter;
    AFiltList := nil;
    if pos(',', ItemNumStr) > 0 then begin
      frmMain.cxGrid1TableView1.dataController.Filter.Root.BoolOperatorKind := fboAnd;
      AFiltList := frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItemList(fboOr);
      while pos(',', ItemNumStr)> 0 do begin
        ItemNum := copy(ItemNumStr, 1, pos(',', ItemNumStr) - 1);
        AFiltList.AddItem(frmMain.cxGrid1TableView1.items[0], foEqual, ItemNum, ItemNum);
        delete(ItemNumStr, 1, pos(',', ItemNumStr));
      end;
    end;
    if (AFiltList <> nil) and (AFiltList.Count = 0) then
      AFiltList.AddItem(frmMain.cxGrid1TableView1.items[0], foEqual,-1, ItemNum);
  finally
    frmMain.cxGrid1TableView1.dataController.Filter.active := True;
    frmMain.cxGrid1TableView1.dataController.EndUpdate;
  end;
  sortByAmount;
  statBar('off');
  screen.cursor := crDefault;
  mDlg('Please verify that these are really duplicate trades' + cr //
      + ' and not partial fills.', mtWarning, [mbOK], 0);
end;


procedure FilterByLS(ls :string);
begin
  frmMain.cxGrid1TableView1.dataController.Filter.BeginUpdate;
  try
    frmMain.GridFilter := gfNone;
    frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItem(frmMain.cxGrid1TableView1.items[5],
      foEqual, ls, ls);
    frmMain.cxGrid1TableView1.dataController.Filter.active := True;
  finally
    frmMain.cxGrid1TableView1.dataController.Filter.EndUpdate;
  end;
end;


procedure FilterPurchSales(s :string);
var
  AFiltList : TcxFilterCriteriaItemList;
begin
  with frmMain.cxGrid1TableView1 do
    with dataController.Filter do begin
      frmMain.GridFilter := gfNone;
      BeginUpdate;
      if (s = 'P') then
        try
          with Root do begin
            with AddItemList(fboOr) do begin
              with AddItemList(fboAnd) do begin
                AddItem(frmMain.cxGrid1TableView1.items[4], foEqual, 'O', 'O');
                AddItem(frmMain.cxGrid1TableView1.items[5], foEqual, 'L', 'L');
              end;
              with AddItemList(fboAnd) do begin
                AddItem(frmMain.cxGrid1TableView1.items[4], foEqual, 'C', 'C');
                AddItem(frmMain.cxGrid1TableView1.items[5], foEqual, 'S', 'S');
              end;
            end;
          end;
        finally
          EndUpdate;
        end;
      if (s = 'S') then
        try
          with Root do begin
            with AddItemList(fboOr) do begin
              with AddItemList(fboAnd) do begin
                AddItem(frmMain.cxGrid1TableView1.items[4], foEqual, 'C', 'C');
                AddItem(frmMain.cxGrid1TableView1.items[5], foEqual, 'L', 'L');
              end;
              with AddItemList(fboAnd) do begin
                AddItem(frmMain.cxGrid1TableView1.items[4], foEqual, 'O', 'O');
                AddItem(frmMain.cxGrid1TableView1.items[5], foEqual, 'S', 'S');
              end;
            end;
          end;
        finally
          EndUpdate;
        end;
      active := True;
    end;
end;


procedure FilterByExerciseAssigns(StartingNum : Integer);
begin
  ClearFilter;
  if StartingNum = 0 then
    FilterExAssigns('*')
  else
    FilterExAssigns(IntToStr(StartingNum));
  frmMain.cxGrid_15_m.Visible := True;
  frmMain.cxGrid_15_m.ApplyBestFit;
  sortByMatched;
  repaintGrid;
end;


procedure filterTaxLots(id : Integer = 0);
var
  s : string;
begin
  frmMain.cxGrid1TableView1.dataController.Filter.BeginUpdate;
  if (id = 0) then
    s := 'Ex-*'
  else
    s := 'Ex-' + IntToStr(id);
  try
    frmMain.cxGrid1TableView1.dataController.Filter.PercentWildcard := '*';
    ClearFilter;
    frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItem
      (frmMain.cxGrid1TableView1.items[15], foNotLike, s, s);
    frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItem
      (frmMain.cxGrid1TableView1.items[15], foNotEqual, '', '');
    frmMain.cxGrid1TableView1.dataController.Filter.active := True;
  finally
    frmMain.cxGrid1TableView1.dataController.Filter.EndUpdate;
  end;
end;


procedure FilterExAssigns(n : string; Clear : boolean);
begin
  frmMain.cxGrid1TableView1.dataController.Filter.BeginUpdate;
  if Length(n)= 1 then
    n := '000' + n
  else if Length(n)= 2 then
    n := '00' + n
  else if Length(n)= 3 then
    n := '0' + n;
  try
    if Clear then
      ClearFilter;
    frmMain.cxGrid1TableView1.dataController.Filter.PercentWildcard := '*';
    if n = '*' then
      frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItem
        (frmMain.cxGrid1TableView1.items[23], foLike, 'Ex-' + n, 'Ex-' + n)
    else
      frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItem
        (frmMain.cxGrid1TableView1.items[23], foGreaterEqual, 'Ex-' + n, 'Ex-' + n);
    frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItem
      (frmMain.cxGrid1TableView1.items[15], foNotEqual, '', '');
    frmMain.cxGrid1TableView1.dataController.Filter.active := True;
  finally
    frmMain.cxGrid1TableView1.dataController.Filter.EndUpdate;
  end;
end;


function FilterByBrokerAccountType(MTM : boolean; Ira : boolean; Cash : boolean; Clear : boolean;
  IncludeCashFuturesAsMTM : boolean; IncludeVTNinMTMaccount : boolean) : boolean;
// 2018-03-29 MB - New argument
var
  Account : TTLFileHeader;
  FilterList : TcxFilterCriteriaItemList;
  FilterListFutures : TcxFilterCriteriaItemList;
begin
  frmMain.cxGrid1TableView1.dataController.Filter.BeginUpdate;
  try
    if Clear then
      ClearFilter;
    FilterList := nil;
    for Account in TradeLogFile.FileHeaders do begin
      // If we want MTM Accounts and this is an MTM Account then add it to the filter.
      if MTM and Account.MTM then begin
        if FilterList = nil then
          FilterList := frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItemList(fboOr);
        FilterList.AddItem(frmMain.cxGrid1TableView1.items[16], foEqual, Account.BrokerID,
          Account.AccountName);
      end;
      // If we want IRA Accounts and this is an IRA Account then add it to the filter.
      if Ira and Account.Ira then begin
        if FilterList = nil then
          FilterList := frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItemList(fboOr);
        FilterList.AddItem(frmMain.cxGrid1TableView1.items[16], foEqual, Account.BrokerID,
          Account.AccountName);
      end;
      // If we want Cash Accounts and this is a Cash Account then add it to the filter.
      if Cash and not Account.MTM and not Account.Ira then begin
        if FilterList = nil then
          FilterList := frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItemList(fboOr);
        FilterList.AddItem(frmMain.cxGrid1TableView1.items[16], foEqual, Account.BrokerID,
          Account.AccountName);
      end;
      if MTM and IncludeCashFuturesAsMTM and not Account.MTM and not Account.Ira then begin
        if FilterList = nil then
          FilterList := frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItemList(fboOr);
        FilterListFutures := FilterList.AddItemList(fboAnd);
        FilterListFutures.AddItem(frmMain.cxGrid1TableView1.items[16], foEqual, Account.BrokerID,
          Account.AccountName);
        FilterListFutures.AddItem(frmMain.cxGrid1TableView1.items[9], foLike, 'FUT*', 'FUT*')
      end;
      // ---------- NEW 2018-03-29 MB -----------
      if (not MTM) and IncludeVTNinMTMaccount and Account.MTM then begin
        if FilterList = nil then
          FilterList := frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItemList(fboOr);
        FilterListFutures := FilterList.AddItemList(fboAnd);
        FilterListFutures.AddItem(frmMain.cxGrid1TableView1.items[16], foEqual, Account.BrokerID,
          Account.AccountName);
        FilterListFutures.AddItem(frmMain.cxGrid1TableView1.items[9], foLike, 'VTN*', 'VTN*')
      end;
    end; // for Account
    Result := (FilterList <> nil);
    if Result then
      frmMain.cxGrid1TableView1.dataController.Filter.active := True;
  finally
    frmMain.cxGrid1TableView1.dataController.Filter.EndUpdate;
  end;
end;


{ Filters a Current MTM Account for Stocks and Futures if MTMForFutures is true. }
function FilterForMTMStocks : boolean;
var
  FileHeader : TTLFileHeader;
  AcctList, ChildAcctList : TcxFilterCriteriaItemList;
begin
  { On a single account tab, if this is MTM then filter based on MTMForFutures Flag }
  if TradeLogFile.CurrentBrokerID > 0 then begin
    frmMain.cxGrid1TableView1.dataController.Filter.BeginUpdate;
    try
      frmMain.cxGrid1TableView1.dataController.Filter.PercentWildcard := '*';
      // ----- MTM for futures? -----
      if not TradeLogFile.CurrentAccount.MTMForFutures then
        frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItem
          (frmMain.cxGrid1TableView1.items[9], foNotLike, 'FUT*', 'FUT*');
      // ----- filter out certain types from MTM rpt -----
      frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItem
        (frmMain.cxGrid1TableView1.items[9], foNotLike, 'CUR*', 'CUR*');
      frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItem
        (frmMain.cxGrid1TableView1.items[9], foNotLike, 'CTN*', 'CTN*'); // 2018-05-29 MB
      frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItem
        (frmMain.cxGrid1TableView1.items[9], foNotLike, 'VTN*', 'VTN*'); // 2018-05-30 MB
      // ----- done -----
      frmMain.cxGrid1TableView1.dataController.Filter.active := True;
    finally
      frmMain.cxGrid1TableView1.dataController.Filter.EndUpdate;
    end;
    if SuperUser and (DEBUG_MODE > 7) then
      sm(frmMain.cxGrid1TableView1.dataController.Filter.FilterText);
    // ----- exit -----
    exit(frmMain.cxGrid1TableView1.dataController.FilteredRecordCount > 0);
  end
  else begin
    frmMain.cxGrid1TableView1.dataController.Filter.BeginUpdate;
    try
      frmMain.cxGrid1TableView1.dataController.Filter.PercentWildcard := '*';
      AcctList := frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItemList(fboOr);
      for FileHeader in TradeLogFile.FileHeaders do begin
        if (FileHeader.MTM) then begin
          // Add an MTM Account to the Futures report only if it is not MTM For Futures
          ChildAcctList := AcctList.AddItemList(fboAnd);
          ChildAcctList.AddItem(frmMain.cxGrid1TableView1.items[16], foEqual, FileHeader.BrokerID,
            FileHeader.AccountName);
          ChildAcctList.AddItem(frmMain.cxGrid1TableView1.items[9], foNotLike, 'CUR*', 'CUR*');
          // 2018-05-30 MB - 2 new types must be filtered out -----
          ChildAcctList.AddItem(frmMain.cxGrid1TableView1.items[9], foNotLike, 'CTN*', 'CTN*');
          ChildAcctList.AddItem(frmMain.cxGrid1TableView1.items[9], foNotLike, 'VTN*', 'VTN*');
          if not(FileHeader.MTMForFutures) then
            ChildAcctList.AddItem(frmMain.cxGrid1TableView1.items[9], foNotLike, 'FUT*', 'FUT*');
        end
      end;
      Result := (AcctList.Count > 0);
      if Result then
        frmMain.cxGrid1TableView1.dataController.Filter.active := True;
    finally
      if not Result then
        AcctList.Free;
      frmMain.cxGrid1TableView1.dataController.Filter.EndUpdate;
    end;
    if SuperUser and (DEBUG_MODE > 7) then
      sm(frmMain.cxGrid1TableView1.dataController.Filter.FilterText);
  end;
  repaintGrid;
end;


procedure FilterMTMLastyear;
var
  EOYDate : TDateTime;
  FileHeader : TTLFileHeader;
  AcctList, ChildAcctList : TcxFilterCriteriaItemList;
begin
  EOYDate := xStrToDate('12/31/' + IntToStr(TradeLogFile.LastTaxYear));
  if (TradeLogFile.CurrentBrokerID > 0) then begin
    if (TradeLogFile.CurrentAccount.MTM) //
      and (not TradeLogFile.CurrentAccount.MTMLastYear) then begin
      // If we are on a current account that is MTM and Not MTM Last year
      // then we need to filter out last year recs
      frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItem
        (frmMain.cxGrid1TableView1.items[2], foGreater, EOYDate, dateToStr(EOYDate));
// frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItem
// (frmMain.cxGrid1TableView1.items[2], foGreater, EOYDate,
// '12/31/' + IntToStr(TradeLogFile.LastTaxYear));
    end;
  end
  else begin
    frmMain.cxGrid1TableView1.dataController.Filter.BeginUpdate;
    try
      AcctList := frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItemList(fboOr);
      for FileHeader in TradeLogFile.FileHeaders do begin
        if (FileHeader.MTM) and (not FileHeader.MTMLastYear) then begin
          ChildAcctList := AcctList.AddItemList(fboAnd);
          ChildAcctList.AddItem(frmMain.cxGrid1TableView1.items[2], foGreater, EOYDate,
            '12/31/' + IntToStr(TradeLogFile.LastTaxYear));
          ChildAcctList.AddItem(frmMain.cxGrid1TableView1.items[16], foEqual, FileHeader.BrokerID,
            FileHeader.AccountName);
        end
        else
          AcctList.AddItem(frmMain.cxGrid1TableView1.items[16], foEqual, FileHeader.BrokerID,
            FileHeader.AccountName);
      end;
      frmMain.cxGrid1TableView1.dataController.Filter.active := True;
    finally
      frmMain.cxGrid1TableView1.dataController.Filter.EndUpdate;
    end;
  end;
  // repaintGrid;  2015-08-19
end;


function FilterForCurrencies : boolean;
var
  FileHeader : TTLFileHeader;
  AcctList, ChildAcctList : TcxFilterCriteriaItemList;
begin
  // On a single account tab, Just return Currencies for this tab.
  // 2018-06-01 MB - changed to workaround strange behavior of cxGrid filter
  // Now I clear, then filter out any IRA accounts, then only allow CUR and CTN types
  ClearFilter;
  if (TradeLogFile.CurrentBrokerID = 0) //
    and (TradeLogFile.MultiBrokerFile) //
  then begin
    try
      AcctList := frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItemList(fboAnd);
      for FileHeader in TradeLogFile.FileHeaders do begin
        if (FileHeader.Ira) then begin
          ChildAcctList := AcctList.AddItemList(fboAnd);
          ChildAcctList.AddItem(frmMain.cxGrid1TableView1.items[16], foNotEqual,
            FileHeader.BrokerID, FileHeader.AccountName);
        end;
      end;
      Result := (AcctList.Count > 0);
    finally
      if not Result then
        AcctList.Free;
// frmMain.cxGrid1TableView1.DataController.Filter.EndUpdate;
    end;
  end;
  FilterByType('ForEx', false); // Filter by currency types, leave account filter in place
  frmMain.cxGrid1TableView1.dataController.Filter.active := True;
  repaintGrid;
  exit(frmMain.cxGrid1TableView1.dataController.FilteredRecordCount > 0);
end;

{ Filters for either Stocks reports such as D1, SubD1, 8949, GAndL Form 4797 or
  for Futures if futures boolean is true }
function FilterForFutures : boolean;
var
  FileHeader : TTLFileHeader;
  AcctList, ChildAcctList : TcxFilterCriteriaItemList;
begin
  { On a single account tab, if this is MTM then filter based on MTMForFutures Flag
   else just filter for futures. }
  if TradeLogFile.CurrentBrokerID > 0 then begin
    { If this is an MTM Account and the MTM Election was made for Futures then
      we don't have anything to report for the Futures report }
    if (TradeLogFile.CurrentAccount.MTM) and (TradeLogFile.CurrentAccount.MTMForFutures) then
      exit(false)
    else begin
      FilterByType('FUT'); { Filter by futures type }
      exit(frmMain.cxGrid1TableView1.dataController.FilteredRecordCount > 0);
    end;
  end
  else begin
    frmMain.cxGrid1TableView1.dataController.Filter.BeginUpdate;
    try
      AcctList := frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItemList(fboOr);
      for FileHeader in TradeLogFile.FileHeaders do begin
        if (FileHeader.MTM) then begin
          { Add an MTM Account to the Futures report only if it is not MTM For Futures }
          if not(FileHeader.MTMForFutures) then begin
            ChildAcctList := AcctList.AddItemList(fboAnd);
            ChildAcctList.AddItem(frmMain.cxGrid1TableView1.items[9], foLike, 'FUT*', 'FUT*');
            ChildAcctList.AddItem(frmMain.cxGrid1TableView1.items[16], foEqual, FileHeader.BrokerID,
              FileHeader.AccountName);
          end;
          Continue;
        end
        else if (not FileHeader.Ira) then begin
          ChildAcctList := AcctList.AddItemList(fboAnd);
          ChildAcctList.AddItem(frmMain.cxGrid1TableView1.items[9], foLike, 'FUT*', 'FUT*');
          ChildAcctList.AddItem(frmMain.cxGrid1TableView1.items[16], foEqual, FileHeader.BrokerID,
            FileHeader.AccountName);
        end;
      end;
      Result := (AcctList.Count > 0);
      if Result then
        frmMain.cxGrid1TableView1.dataController.Filter.active := True;
    finally
      if not Result then
        AcctList.Free;
      frmMain.cxGrid1TableView1.dataController.Filter.EndUpdate;
    end;
  end;
  repaintGrid;
end;


procedure FilterByStkAssignsPriceZero;
var
  AFiltList : TcxFilterCriteriaItemList;
begin
  frmMain.GridFilter := gfNone;
  frmMain.cxGrid1TableView1.dataController.Filter.BeginUpdate;
  try
    frmMain.cxGrid1TableView1.dataController.Filter.PercentWildcard := '*';
    ClearFilter;
    frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItem(frmMain.cxGrid1TableView1.items[9],
      foNotLike, 'FUT*', 'FUT*');
    frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItem(frmMain.cxGrid1TableView1.items[9],
      foNotLike, 'CUR*', 'CUR*');
    frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItem(frmMain.cxGrid1TableView1.items[9],
      foNotLike, 'OPT*', 'OPT*');
    frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItem(frmMain.cxGrid1TableView1.items[8],
      foEqual, '0', '0');
    frmMain.cxGrid1TableView1.dataController.Filter.active := True;
  finally
    frmMain.cxGrid1TableView1.dataController.Filter.EndUpdate;
  end;
end;


// ------------------------------------
procedure FilterByType(cType : string; ClrFilter : boolean);
// ------------------------------------
var
  AFiltList : TcxFilterCriteriaItemList;
  sl : TstringList;
  I : Integer;
  AItemList : TcxFilterCriteriaItemList;
begin
  frmMain.GridFilter := gfNone;
  // ----------------------------------
  if cType = 'schedD' then begin
    frmMain.cxGrid1TableView1.dataController.Filter.BeginUpdate;
    try
      frmMain.cxGrid1TableView1.dataController.Filter.PercentWildcard := '*';
      if ClrFilter then
        ClearFilter;
      frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItem
        (frmMain.cxGrid1TableView1.items[9], foNotLike, 'FUT*', 'FUT*');
      frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItem
        (frmMain.cxGrid1TableView1.items[9], foNotLike, 'CUR*', 'CUR*');
      frmMain.cxGrid1TableView1.dataController.Filter.active := True;
    finally
      frmMain.cxGrid1TableView1.dataController.Filter.EndUpdate;
    end;
    exit;
  end
  // ----------------------------------
  else if cType = 'FUTonly' then begin
    frmMain.cxGrid1TableView1.dataController.Filter.BeginUpdate;
    try
      frmMain.cxGrid1TableView1.dataController.Filter.PercentWildcard := '*';
      if ClrFilter then
        ClearFilter;
      frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItem
        (frmMain.cxGrid1TableView1.items[9], foLike, 'FUT*', 'FUT*');
      frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItem
        (frmMain.cxGrid1TableView1.items[6], foNotLike, '* CALL', '* CALL');
      frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItem
        (frmMain.cxGrid1TableView1.items[6], foNotLike, '* PUT', '* PUT');
      frmMain.cxGrid1TableView1.dataController.Filter.active := True;
    finally
      frmMain.cxGrid1TableView1.dataController.Filter.EndUpdate;
    end;
    exit;
  end
  // ----------------------------------
  else if cType = 'FUTopt' then begin
    frmMain.cxGrid1TableView1.dataController.Filter.BeginUpdate;
    try
      frmMain.cxGrid1TableView1.dataController.Filter.PercentWildcard := '*';
      if ClrFilter then
        ClearFilter;
      frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItem
        (frmMain.cxGrid1TableView1.items[9], foLike, 'FUT*', 'FUT*');
      AFiltList := frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItemList(fboOr);
      AFiltList.AddItem(frmMain.cxGrid1TableView1.items[6], foLike, '*CALL', '*CALL');
      AFiltList.AddItem(frmMain.cxGrid1TableView1.items[6], foLike, '*PUT', '*PUT');
      frmMain.cxGrid1TableView1.dataController.Filter.active := True;
    finally
      frmMain.cxGrid1TableView1.dataController.Filter.EndUpdate;
    end;
    exit;
  end
  // ----------------------------------
  else if cType = 'NoFut' then begin
    frmMain.cxGrid1TableView1.dataController.Filter.BeginUpdate;
    try
      frmMain.cxGrid1TableView1.dataController.Filter.PercentWildcard := '*';
      if ClrFilter then
        ClearFilter;
      frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItem
        (frmMain.cxGrid1TableView1.items[9], foNotLike, 'FUT*', 'FUT*');
      frmMain.cxGrid1TableView1.dataController.Filter.active := True;
    finally
      frmMain.cxGrid1TableView1.dataController.Filter.EndUpdate;
    end;
    exit;
  end
  // ----------------------------------
  else if cType = 'ForEx' then begin
    frmMain.cxGrid1TableView1.dataController.Filter.BeginUpdate;
    try
      frmMain.cxGrid1TableView1.dataController.Filter.PercentWildcard := '*';
      if ClrFilter then
        ClearFilter;
      // 2018-04-16 MB - Allow CUR or CTN for Forex Report ------
      AFiltList := nil;
      if AFiltList = nil then
        AFiltList := frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItemList(fboOr);
      AFiltList.AddItem(frmMain.cxGrid1TableView1.items[9], foLike, 'CUR*', 'CUR*');
      if AFiltList = nil then
        AFiltList := frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItemList(fboOr);
      AFiltList.AddItem(frmMain.cxGrid1TableView1.items[9], foLike, 'CTN*', 'CTN*');
      // --------------------------------------------------
      frmMain.cxGrid1TableView1.dataController.Filter.active := True;
    finally
      frmMain.cxGrid1TableView1.dataController.Filter.EndUpdate;
    end;
    exit;
  end
  // ----------------------------------
  else if cType = 'NoCur' then begin
    frmMain.cxGrid1TableView1.dataController.Filter.BeginUpdate;
    try
      frmMain.cxGrid1TableView1.dataController.Filter.PercentWildcard := '*';
      if ClrFilter then
        ClearFilter;
      frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItem
        (frmMain.cxGrid1TableView1.items[9], foNotLike, 'CUR*', 'CUR*');
      // 2018-02-22 MB - Also filter DCY for reports ------
      frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItem
        (frmMain.cxGrid1TableView1.items[9], foNotLike, 'DCY*', 'DCY*');
      // --------------------------------------------------
      frmMain.cxGrid1TableView1.dataController.Filter.active := True;
    finally
      frmMain.cxGrid1TableView1.dataController.Filter.EndUpdate;
    end;
    exit;
  end
  // ----------------------------------
  else if cType = 'Recon' then begin
    frmMain.cxGrid1TableView1.dataController.Filter.BeginUpdate;
    try
      frmMain.cxGrid1TableView1.dataController.Filter.PercentWildcard := '*';
      if ClrFilter then
        ClearFilter;
      frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItem
        (frmMain.cxGrid1TableView1.items[9], foNotLike, 'FUT*', 'FUT*');
      frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItem
        (frmMain.cxGrid1TableView1.items[9], foNotLike, 'CUR*', 'CUR*');
      // 2018-02-23 MB - Also filter DCY for reports ------
      frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItem
        (frmMain.cxGrid1TableView1.items[9], foNotLike, 'DCY*', 'DCY*');
      // --------------------------------------------------
      frmMain.cxGrid1TableView1.dataController.Filter.active := True;
    finally
      frmMain.cxGrid1TableView1.dataController.Filter.EndUpdate;
    end;
    exit;
  end
  // ----------------------------------
  // 21-04-20 RJ loop through cbFilterInstrament
  else if (LeftStr(cType, 1) = '~') then begin
    cType := copy(cType, 2);
    frmMain.cxGrid1TableView1.dataController.Filter.BeginUpdate;
    try
      frmMain.cxGrid1TableView1.dataController.Filter.PercentWildcard := '*';
      if ClrFilter then
        ClearFilter;
      AItemList := frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItemList(fboOr);
      // ----------
      sl := TstringList.Create;
      sl.Delimiter := ';';
      sl.DelimitedText := cType;
      // ----------
      for I := 0 to sl.Count - 1 do
        AItemList.AddItem(frmMain.cxGrid1TableView1.items[9], foLike, sl[I]+ '*', sl[I]);
      frmMain.cxGrid1TableView1.dataController.Filter.active := True;
    finally
      frmMain.cxGrid1TableView1.dataController.Filter.EndUpdate;
      sl.Free;
    end;
  end
  // ----------------------------------
  else begin
    cType := cType + '*';
    frmMain.cxGrid1TableView1.dataController.Filter.BeginUpdate;
    try
      frmMain.cxGrid1TableView1.dataController.Filter.PercentWildcard := '*';
      if ClrFilter then
        ClearFilter;
      frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItem
        (frmMain.cxGrid1TableView1.items[9], foLike, cType, cType);
      frmMain.cxGrid1TableView1.dataController.Filter.active := True;
    finally
      frmMain.cxGrid1TableView1.dataController.Filter.EndUpdate;
    end;
  end;
end;


procedure FilterByOptTickers;
begin
  frmMain.cxGrid1TableView1.dataController.Filter.BeginUpdate;
  try
    frmMain.cxGrid1TableView1.dataController.Filter.PercentWildcard := '*';
    ClearFilter; // root.clear;
    frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItem(frmMain.cxGrid1TableView1.items[9],
      foLike, 'OPT*', 'OPT*');
    frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItem(frmMain.cxGrid1TableView1.items[6],
      foNotLike, '* EXERCISED', '* EXERCISED');
    frmMain.cxGrid1TableView1.dataController.Filter.active := True;
  finally
    frmMain.cxGrid1TableView1.dataController.Filter.EndUpdate;
  end;
end;

procedure FilterByCusip;
begin
  frmMain.cxGrid1TableView1.dataController.Filter.BeginUpdate;
  try
    frmMain.cxGrid1TableView1.dataController.Filter.PercentWildcard := '*';
    ClearFilter;
    frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItem(frmMain.cxGrid1TableView1.items[6],
      foLess, 'A', 'A');
    frmMain.cxGrid1TableView1.dataController.Filter.active := True;
  finally
    frmMain.cxGrid1TableView1.dataController.Filter.EndUpdate;
  end;
end;


procedure FilterMTM;
var
  s, e :string;
begin
  s := UserDateStr('01/01/' + Taxyear);
  e := UserDateStr('12/31/' + Taxyear);
  frmMain.cxGrid1TableView1.dataController.Filter.BeginUpdate;
  try
    ClearFilter;
    frmMain.cxGrid1TableView1.dataController.Filter.Root.BoolOperatorKind := fboAnd;
    frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItem(frmMain.cxGrid1TableView1.items[2],
      foGreaterEqual, xStrToDate(s, Settings.UserFmt), s);
    frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItem(frmMain.cxGrid1TableView1.items[2],
      foLessEqual, xStrToDate(e, Settings.UserFmt), e);
    frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItem(frmMain.cxGrid1TableView1.items[4],
      foEqual, 'M', 'M');
    frmMain.cxGrid1TableView1.dataController.Filter.active := True;
  finally
    frmMain.cxGrid1TableView1.dataController.Filter.EndUpdate;
  end;
end;


procedure FilterSec481;
var
  s :string;
begin
  s := UserDateStr('01/01/' + Taxyear);
  frmMain.cxGrid1TableView1.dataController.Filter.BeginUpdate;
  try
    ClearFilter; // root.clear;
    frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItem(frmMain.cxGrid1TableView1.items[2],
      foLess, xStrToDate(s, Settings.UserFmt), s);
    frmMain.cxGrid1TableView1.dataController.Filter.active := True;
  finally
    frmMain.cxGrid1TableView1.dataController.Filter.EndUpdate;
  end;
end;

procedure filterByOpenPositonsMTM(EndDate : TDate; ClrFilter : boolean = false);
begin
  frmMain.cxGrid1TableView1.dataController.Filter.BeginUpdate;
  try
    if ClrFilter then
      ClearFilter;
    frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItem(frmMain.cxGrid1TableView1.items[2],
      foEqual, EndDate, dateToStr(EndDate, Settings.UserFmt));
    frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItem(frmMain.cxGrid1TableView1.items[4],
      foEqual, 'O', 'O');
    frmMain.cxGrid1TableView1.dataController.Filter.active := True;
  finally
    frmMain.cxGrid1TableView1.dataController.Filter.EndUpdate;
  end;
  if panelMsg.HasTradeIssues then
    panelMsg.hide;
end;


procedure FilterByOpenPositons(EndDate : TDate; ClrFilter : boolean = false);
begin
  frmMain.cxGrid1TableView1.dataController.Filter.BeginUpdate;
  try
    if ClrFilter then
      ClearFilter;
    frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItem(frmMain.cxGrid1TableView1.items[2],
      foLessEqual, EndDate, dateToStr(EndDate, Settings.UserFmt));
    frmMain.cxGrid1TableView1.dataController.Filter.active := True;
  finally
    frmMain.cxGrid1TableView1.dataController.Filter.EndUpdate;
  end;
  if panelMsg.HasTradeIssues then
    panelMsg.hide;
end;


procedure FilterByDateRange(StartDt, EndDt : TDate; ClrFilter : boolean);
begin
  frmMain.cxGrid1TableView1.dataController.Filter.BeginUpdate;
  try
    frmMain.GridFilter := gfNone;
    if ClrFilter then
      ClearFilter;
    frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItem(frmMain.cxGrid1TableView1.items[2],
      foGreaterEqual, StartDt, dateToStr(StartDt, Settings.UserFmt));
    frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItem(frmMain.cxGrid1TableView1.items[2],
      foLessEqual, EndDt, dateToStr(EndDt, Settings.UserFmt));
    frmMain.cxGrid1TableView1.dataController.Filter.active := True;
  finally
    frmMain.cxGrid1TableView1.dataController.Filter.EndUpdate;
  end;
end;


procedure FilterByBrokerAcct(BrokerID : Integer; AccountName : string);
begin
  frmMain.cxGrid1TableView1.dataController.Filter.BeginUpdate;
  try
    frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItem
      (frmMain.cxGrid1TableView1.items[16], foEqual, BrokerID, AccountName);
    frmMain.cxGrid1TableView1.dataController.Filter.active := True;
  finally
    frmMain.cxGrid1TableView1.dataController.Filter.EndUpdate;
  end;
end;


function myCompareIntegers(AItem1, AItem2 : Pointer): Integer;
begin
  Result := Integer(AItem1) - Integer(AItem2);
end;


function myGetLastRecordIndex : Integer;
var
  ARowIndex : Integer;
begin
  with frmMain.cxGrid1TableView1.dataController do begin
    Result := -1;
    ARowIndex := GetRowCount - 1;
    if ARowIndex <> -1 then
      Result := GetRowInfo(ARowIndex).RecordIndex;
  end;
end;


function myGetFocusedRecordIndex : Integer;
begin
  with frmMain.cxGrid1TableView1.dataController do begin
    Result := GetFocusedRecordIndex;
  end;
end;


procedure myCheckNearestFocusRow;
var
  ARecordIndex : Integer;
begin
  with frmMain.cxGrid1TableView1.dataController do begin
    if GetFocusedRecordIndex = -1 then begin
      ARecordIndex := myGetLastRecordIndex;
      ChangeFocusedRecordIndex(ARecordIndex);
    end;
  end;
end;

procedure myDeleteRecords(AList : TList);
var
  I : Integer;
begin
  stopDel := false;
  frmMain.enabled := false;
  with frmMain.cxGrid1TableView1.dataController do begin
    BeginUpdate;
    try
      for I := AList.Count - 1 downto 0 do begin
        Application.ProcessMessages;
        if GetKeyState(VK_ESCAPE) and 128 = 128 then begin
          stopDel := True;
        end;
        if stopDel then begin
          break;
        end;
        DeleteRecord(Integer(AList[I]));
        if frac(I / 10)= 0 then
          statBar('deleting selected records ' + IntToStr(I)+ ' - hit Escape to cancel');
      end;
    finally
      EndUpdate;
      statBar('off');
      frmMain.enabled := True;
    end;
    myCheckNearestFocusRow;
  end;
end;


// new speed optimized Delete Selection
procedure MyDeleteSelection;
var
  I, aRow, aRec : Integer;
  aRowInfo : TcxRowInfo;
  TrList : TList<Integer>;
begin
  try
    // ----------------------
    // get list of trades to delete
    try
      TrList := TList<Integer>.Create;
      with frmMain.cxGrid1TableView1.dataController do begin
        for I := 0 to getSelectedCount - 1 do begin
          aRow := GetSelectedRowIndex(I);
          aRowInfo := GetRowInfo(aRow);
          aRec := aRowInfo.RecordIndex + 1;
          TrList.Add(aRec);
        end;
      end;
      // ----------------------
      screen.cursor := crHourglass;
      frmMain.cxGrid1TableView1.dataController.ClearSelection;
      TrList.Sort;
    except
      sm('Error in Delete, 1410-23');
    end;
    // ----------------------
    I := 0;
    try
      while I < TradeLogFile.Count do begin
        aRec := TrList.IndexOf(TradeLogFile[I].id);
        if (aRec > -1) then begin
          TradeLogFile.TradeList.delete(I);
        end
        else
          inc(I);
      end;
    except
      sm('Error in Delete, 1430-37');
    end;
    // ----------------------
  finally
    TrList.Free;
  end;
end;


procedure DelSelectedRecords(bCut : boolean = false);
var
  I, aRec, RecsSelected : Integer;
  tk, sMsg, sFile : string;
  bNotWrec, bMsgPanel : boolean;
  myTickers : TstringList;
begin
  if OneYrLocked or isAllBrokersSelected then exit;
  if bCut then sMsg := 'Cut' else sMsg := 'Delete';
  with frmMain.cxGrid1TableView1.dataController do begin
    try
      if getSelectedCount < 1 then begin
        sm('Please select record(s) to ' + sMsg);
        exit;
      end;
      if mDlg(sMsg + ' Selected Record(s)?', mtWarning, [mbNo, mbYes], 0) = mrNo then
        exit;
      bMsgPanel := panelMsg.Visible;
      if (pos('TrNum =', frmMain.cxGrid1TableView1.dataController.Filter.FilterText) = 0) then
        ReadFilter;
      panelMsg.hide;
      screen.cursor := crHourglass;
      statBar('Deleting Selected Records');
      DeletingRecords := True;
      ClearFilter;
      try
        bNotWrec := false;
        try
          myTickers := TstringList.Create;
          with frmMain.cxGrid1TableView1.dataController do begin
            for I := 0 to getSelectedCount - 1 do begin
              aRec := GetRowInfo(GetSelectedRowIndex(I)).RecordIndex;
              tk := TradeLogFile[aRec].Ticker;
              if (myTickers.IndexOf(tk) = -1) then
                myTickers.Add(tk);
              if (TradeLogFile[aRec].oc <> 'W') then
                bNotWrec := True
            end; // for i
          end; // with
          if bCut then begin
            RecsSelected := CopyTradesToClipboard(True);
            mDlg(IntToStr(RecsSelected) + ' Records copied to Windows clipboard', //
              mtInformation, [mbOK], 0);
          end;
        except
          sm('error in Delete, 1472-88');
        end;
        // ----------------------------
        MyDeleteSelection;
        // ----------------------------
        // create Undo
        SaveTradesBack(sMsg + ' Records');
        if bNotWrec then begin
          statBar('Matching Records');
          TradeLogFile.Match(myTickers);
          TradeLogFile.Reorganize(True);
        end;
        TradeRecordsSource.DataChanged;
        // 2022-09-21 MB - what if the grid is now empty?
        // old code checked .RowCount, called ClearFilter
        if (frmMain.cxGrid1TableView1.dataController.getSelectedCount = 0) then
          frmMain.ShowAllTrades;
        if bMsgPanel then begin
          panelMsg.hide;
          ClearFilter;
        end;
        frmMain.cxGrid1TableView1.dataController.gotofirst;
        dispProfit(True, 0, 0, 0, 0);
        if not SaveTradeLogFile then begin
          Undo(false, True);
          exit;
        end;
        TradeRecordsSource.DataChanged;
        statBar('off');
      finally
        myTickers.Free;
      end; // try..finally
      // ----------------------------
      // 2021-07-09 MB - to force all datasources to update,
      // I resorted to close and reopen the file.
      try
        sFile := Settings.DataDir + '\' + TradeLogFile.FileName;
        TradeLogFile.RefreshOpens; // 2022-03-17 MB
  // OpenTradeLogFile(sFile);
        // ----------------------------
        FindTradeIssues;
      except
        gsErrorText := 'error in Delete, 1520-25';
      end;
      if not panelMsg.HasTradeIssues and not bMsgPanel then
        WriteFilter(True);
      if (frmMain.cxGrid1TableView1.dataController.RowCount = 0) then
        ClearFilter;
    finally
      DeletingRecords := false; // done
      screen.cursor := crDefault; // re-enable mouse
    end; // try..finally
  end; // with
end; // DeleteRecord


procedure DispTradesNegShares;
var
  itList : TList<Integer>;
  AFiltList : TcxFilterCriteriaItemList;
  Trade : TTLTrade;
begin
  screen.cursor := crHourglass;
  statBar('Searching For Trade Match Errors');
  frmMain.GridFilter := gfTradeIssues;
  frmMain.cxGrid1TableView1.dataController.Filter.BeginUpdate;
  try
    itList := TList<Integer>.Create;
    frmMain.cxGrid1TableView1.dataController.ClearSelection;
    ClearFilter;
    AFiltList := frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItemList(fboOr);
    for Trade in TradeLogFile.NegShareTradeNums do begin
      if (itList.Count > 50) then
        break;
      if (itList.IndexOf(Trade.TradeNum) > -1) then
        Continue;
      if ((TradeLogFile.CurrentBrokerID = 0) or (TradeLogFile.CurrentBrokerID = Trade.Broker)) //
        and Trade.HasNegShares then begin
        itList.Add(Trade.TradeNum);
        AFiltList.AddItem(frmMain.cxGrid1TableView1.items[1], foEqual, Trade.TradeNum,
          IntToStr(Trade.TradeNum));
      end;
    end;
  finally
    frmMain.cxGrid1TableView1.dataController.Filter.active := True;
    SortByTicker;
    frmMain.cxGrid1TableView1.dataController.Filter.EndUpdate;
    dispProfit(True, 0, 0, 0, 0);
    itList.Free;
    statBar('off');
  end;
end;


procedure DispTradesCancelled;
var
  AFiltList : TcxFilterCriteriaItemList;
  Trade : TTLTrade;
  LastTrNum : Integer;
begin
  frmMain.GridFilter := gfTradeIssues;
  frmMain.cxGrid1TableView1.dataController.Filter.BeginUpdate;
  LastTrNum := 0;
  try
    frmMain.cxGrid1TableView1.dataController.ClearSelection;
    ClearFilter;
    frmMain.cxGrid1TableView1.dataController.Filter.active := True;
    AFiltList := frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItemList(fboOr);
    statBar('Searching for Cancelled Trade Errors - Please Wait...');
    FilterByOpenClosed('X');
// for Trade in TradeLogFile.CancelledTrades do
// if ((TradeLogFile.CurrentBrokerID = 0) or (TradeLogFile.CurrentBrokerID = Trade.Broker))
// and (LastTrNum <> Trade.TradeNum) then begin
// AFiltList.AddItem(frmMain.cxGrid1TableView1.Items[1], foEqual, Trade.TradeNum, IntToStr(Trade.TradeNum));
// LastTrNum := Trade.TradeNum;
// end;
  finally
    frmMain.cxGrid1TableView1.dataController.Filter.EndUpdate;
    dispProfit(True, 0, 0, 0, 0);
    statBar('off');
  end;
end;


procedure DispTradesMisMatched;
var
  AFiltList : TcxFilterCriteriaItemList;
  Trade : TTLTrade;
  LastTrNum : Integer;
begin
  frmMain.GridFilter := gfTradeIssues;
  frmMain.cxGrid1TableView1.dataController.Filter.BeginUpdate;
  LastTrNum := 0;
  try
    frmMain.cxGrid1TableView1.dataController.ClearSelection;
    ClearFilter;
    frmMain.cxGrid1TableView1.dataController.Filter.active := True;
    AFiltList := frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItemList(fboOr);
    statBar('Searching for Dis-Similar Trade Type Errors - Please Wait...');
    for Trade in TradeLogFile.MisMatchedTrades do
      if ((TradeLogFile.CurrentBrokerID = 0) or (TradeLogFile.CurrentBrokerID = Trade.Broker)) //
        and (Trade.TradeNum <> LastTrNum) then begin
        AFiltList.AddItem(frmMain.cxGrid1TableView1.items[1], foEqual, Trade.TradeNum,
          IntToStr(Trade.TradeNum));
        LastTrNum := Trade.TradeNum;
      end;
  finally
    frmMain.cxGrid1TableView1.dataController.Filter.EndUpdate;
    dispProfit(True, 0, 0, 0, 0);
    statBar('off');
  end;
end;


procedure DispTradesMisMatchedLS;
var
  AFiltList : TcxFilterCriteriaItemList;
  Trade : TTLTrade;
  LastTrNum : Integer;
begin
  frmMain.GridFilter := gfTradeIssues;
  frmMain.cxGrid1TableView1.dataController.Filter.BeginUpdate;
  LastTrNum := 0;
  try
    frmMain.cxGrid1TableView1.dataController.ClearSelection;
    ClearFilter;
    frmMain.cxGrid1TableView1.dataController.Filter.active := True;
    AFiltList := frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItemList(fboOr);
    statBar('Searching for Dis-Similar Long/Short Errors - Please Wait...');
    for Trade in TradeLogFile.MisMatchedLS do
      if ((TradeLogFile.CurrentBrokerID = 0) or (TradeLogFile.CurrentBrokerID = Trade.Broker)) //
        and (Trade.TradeNum <> LastTrNum) then begin
        AFiltList.AddItem(frmMain.cxGrid1TableView1.items[1], foEqual, Trade.TradeNum,
          IntToStr(Trade.TradeNum));
        LastTrNum := Trade.TradeNum;
      end;
  finally
    frmMain.cxGrid1TableView1.dataController.Filter.EndUpdate;
    dispProfit(True, 0, 0, 0, 0);
    statBar('off');
  end;
end;


procedure DispZeroOrLessTrades;
var
  AFiltList : TcxFilterCriteriaItemList;
  Trade : TTLTrade;
begin
  frmMain.GridFilter := gfTradeIssues;
  frmMain.cxGrid1TableView1.dataController.Filter.BeginUpdate;
  try
    frmMain.cxGrid1TableView1.dataController.ClearSelection;
    ClearFilter;
    frmMain.cxGrid1TableView1.dataController.Filter.active := True;
    AFiltList := frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItemList(fboOr);
    statBar('Searching for Trades With Invalid Shares/Contracts - Please Wait...');
    for Trade in TradeLogFile.ZeroOrLessTrades do
      if ((TradeLogFile.CurrentBrokerID = 0) or (TradeLogFile.CurrentBrokerID = Trade.Broker)) then
        AFiltList.AddItem(frmMain.cxGrid1TableView1.items[0], foEqual, Trade.id,
          IntToStr(Trade.id));
  finally
    frmMain.cxGrid1TableView1.dataController.Filter.EndUpdate;
    dispProfit(True, 0, 0, 0, 0);
    statBar('off');
  end;
end;


function getpriceFuture(tkStr :string): double;
var
  I : Integer;
  QuoteService, prStr, futTick, monYr, mon, strike, callPut, my32 :string;
  futOpt : boolean;
begin
  futOpt := false;
  futTick := copy(tkStr, 1, pos(' ', tkStr)- 1);
  if futTick = 'ER2' then
    futTick := 'EZ';
  if (Length(futTick)= 3) and (pos('Z', futTick)= 1) and (futTick <> 'ZYG') then
    delete(futTick, 1, 1);
    // sm(futTick);
  if (pos(' CALL', tkStr)> 0) or (pos(' PUT', tkStr)> 0) then begin
    futOpt := True;
    callPut := parselast(tkStr, ' ');
    callPut := copy(callPut, 1, 1);
    strike := parselast(tkStr, ' ');
    monYr := parselast(tkStr, ' ');
    mon := copy(monYr, 1, 1)+ lowercase(copy(monYr, 2, 2));
    monYr := GetExpMoFutCode(copy(monYr, 1, 3))+ copy(monYr, 4, 2);
    QuoteService := 'http://realtime.agedwards.com/barchart/sites2/pl/_agep/optqte.asp?sym=';
  end
  else begin
    monYr := copy(tkStr, pos(' ', tkStr)+ 1, 5);
    monYr := GetExpMoFutCode(copy(monYr, 1, 3))+ copy(monYr, 4, 2);
    QuoteService := 'http://realtime.agedwards.com/barchart/sites2/pl/_agep/optqte.asp?sym=';
  end;
  QuoteService := QuoteService + futTick + '&mode=d&ageContext=public';
  prStr := readURL(QuoteService);
  if (prStr = '') then begin
    Result :=-1;
    exit;
  end;
  delete(prStr, 1, pos('<body', prStr)+ 4);
  prStr := copy(prStr, 1, pos('</body', prStr)- 1);
  if futOpt then begin
    if pos(mon, prStr)= 0 then begin
      Result := -1;
      exit;
    end
    else
      delete(prStr, 1, pos(mon, prStr));
    if pos(strike, prStr)= 0 then begin
      Result := -1;
      exit;
    end
    else
      delete(prStr, 1, pos(strike, prStr));
    delete(prStr, 1, pos(callPut, prStr));
    prStr := copy(prStr, 1, pos('</TR', prStr)- 1);
      // sm(prstr);
    for I := 1 to 4 do begin
      delete(prStr, 1, pos('align=right>', prStr)+ 11);
    end;
    prStr := copy(prStr, 1, pos('</TD', prStr)- 1);
      // sm(prstr);
  end
  else begin
    delete(prStr, 1, pos(monYr, prStr)+ Length(monYr));
      // delete(prStr,1,pos('<tr><td><b>',prStr)+10);
    prStr := trim(copy(prStr, 1, pos('</TD', prStr)- 1));
  end;
  delete(prStr, pos('s', prStr), 1);
    // sm(prStr);
    // for Bonds, etc with 1/32 ticks
  if pos('-', prStr)> 1 then begin
    try
      my32 := parselast(prStr, '-');
      my32 := floatToStr(strToInt(my32)/ 32, Settings.UserFmt);
      my32 := parselast(my32, '.');
        // sm(my32);
      prStr := prStr + '.' + my32;
        // sm(prStr);
    except
      prStr := '';
    end;
  end;
    // sm('url: '+myUrl+cr+'fut price data for '+tkStr+':'+cr+prstr);
    // clipboard.asText:= prstr;
  if not isFloat(prStr) or (prStr = '') then
    Result :=-1
  else
    Result := strToFloat(prStr, Settings.InternalFmt);
end;


function GetExpMoFutCode(s :string):string;
begin
  if s = 'JAN' then
    Result := 'F'
  else if s = 'FEB' then
    Result := 'G'
  else if s = 'MAR' then
    Result := 'H'
  else if s = 'APR' then
    Result := 'J'
  else if s = 'MAY' then
    Result := 'K'
  else if s = 'JUN' then
    Result := 'M'
  else if s = 'JUL' then
    Result := 'N'
  else if s = 'AUG' then
    Result := 'Q'
  else if s = 'SEP' then
    Result := 'U'
  else if s = 'OCT' then
    Result := 'V'
  else if s = 'NOV' then
    Result := 'X'
  else if s = 'DEC' then
    Result := 'Z';
end;

function GetFutCodeExpMo(s :string):string;
begin
  if s = 'F' then
    Result := 'JAN'
  else if s = 'G' then
    Result := 'FEB'
  else if s = 'H' then
    Result := 'MAR'
  else if s = 'J' then
    Result := 'APR'
  else if s = 'K' then
    Result := 'MAY'
  else if s = 'M' then
    Result := 'JUN'
  else if s = 'N' then
    Result := 'JUL'
  else if s = 'Q' then
    Result := 'AUG'
  else if s = 'U' then
    Result := 'SEP'
  else if s = 'V' then
    Result := 'OCT'
  else if s = 'X' then
    Result := 'NOV'
  else if s = 'Z' then
    Result := 'DEC';
end;


function getOptionTick(tkStr :string):string;
var
  Ticker, expDay, expMonth, expYear, strike, callPut, QuoteService, opTick :string;
  p : Integer;
begin
  // updated 2010-05-05
  // sm('getOptionTick');
  // example: "C 22JAN11 4 CALL" = c110122c00004000
  Ticker := lowercase(copy(tkStr, 1, pos(' ', tkStr)- 1));
  delete(tkStr, 1, pos(' ', tkStr));
  // test for expDay
  if IsInt(LeftStr(tkStr, 2)) then begin
    expDay := copy(tkStr, 1, 2);
    delete(tkStr, 1, 2);
  end
  else
    expDay := '22';
  expMonth := copy(tkStr, 1, 3);
  // change text month to 2 digit month
  expMonth := getExpMoNum(expMonth);
  expYear := copy(tkStr, 4, 2);
  delete(tkStr, 1, pos(' ', tkStr));
  strike := copy(tkStr, 1, pos(' ', tkStr)- 1);
  p := pos('.', strike);
  if p > 0 then begin
    // strike is a decimal
    while p > Length(strike)- 3 do begin
      strike := strike + '0';
      p := pos('.', strike);
    end;
    delete(strike, pos('.', strike), 1);
  end
  else begin
    // strike is whole number
    strike := strike + '000';
  end;
  // add leading zeros
  while Length(strike)< 8 do
    strike := '0' + strike;
  delete(tkStr, 1, pos(' ', tkStr));
  if pos('CALL', tkStr)> 0 then
    callPut := 'c'
  else if pos('PUT', tkStr)> 0 then
    callPut := 'p';
  opTick := Ticker + expYear + expMonth + expDay + callPut + strike;
  // sm(opTick);
  Result := opTick;
end;


function GetPriceStock(tkStr :string): double;
var
  QuoteService, prStr, sTmp : string;
begin
  QuoteService := 'http://finance.yahoo.com/q?s=' + tkStr;
  prStr := readURL(QuoteService);
  if SuperUser and (DEBUG_MODE > 3) then begin
    sTmp := 'URL = ' + CRLF + QuoteService + CRLF + CRLF + 'Reply = ' + CRLF + prStr;
    clipboard.AsText := sTmp;
    sm(copy(sTmp, 1, 2000));
  end;
  if (prStr = '') then begin
    Result := -1;
    exit;
  end;
  // -------- new code 2016-07-16 DE ----------
  // clipboard.astext:= prStr;
  // sm(tkStr+cr+cr+copy(prstr,1,1024));
  prStr := parseHTML(prStr, '$price.0">', '</span>');
  // -------- end new code -----------------
  if not isFloat(prStr) then
    Result :=-1
  else
    Result := strToFloat(prStr, Settings.InternalFmt);
end;


function getPriceOption(optStr :string): double;
var
  QuoteService, prStr, sTemp, sTest : string;
  I : Integer;
  f : double;
begin
  // sm('getPriceOption');
  // OLD URL
  // QuoteService := 'http://finance.yahoo.com/q?s=' + optStr;
  // NEW URL - 2017-05-24 MB - Hack Yahoo Finance
  // format to use yahoo: MCD170526C00125000
  QuoteService := 'https://finance.yahoo.com/quote/' + optStr + '?p=' + optStr;
  // sm(QuoteService);
  prStr := readURL(QuoteService);
  if (prStr = '') then begin
    Result :=-1;
    exit;
  end;
  // -------- old code 2016-07-16 DE ------------
  // clipboard.astext:= prStr; sm(tkStr+cr+cr+copy(prstr,1,1024));
  // prStr := parseHTML(prStr, '$price.0">', '</span>');
  // -------- new code 2017-05-24 MB ------------
  I := pos('data-reactid="36">', prStr);
  while I > 0 do begin
    sTemp := parseHTML(prStr, 'data-reactid="36">', '</span>');
    sTest := sTemp;
    while pos('.', sTest) > 0 do
      delete(sTest, pos('.', sTest), 1);
    if isNumber(sTest) then
      break;
    delete(prStr, 1, I);
    I := pos('data-reactid="36">', prStr);
  end;
  prStr := sTemp;
  // -------- end new code ----------------------
  if not isFloat(prStr) then
    Result :=-1
  else
    Result := strToFloat(prStr, Settings.InternalFmt);
end;


// ----------------------------------------------
function getPriceOnDate(sTicker, sDate : string): double;
// ----------------------------------------------
var
  prStr, QuoteService, mm, dd, yyyy, mmm, sTmp : string;
  sDate1, dd1, mm1, mmm1, yyyy1, sDateCode, sDesc : string;
  tempFile : TSearchRec;
  lineLst : TStrings;
  j : Integer;
  // -----------------------------
  // parses CSV file record into a String List
  function ParseCSV(const s : string; ADelimiter : Char = ','; AQuoteChar : Char = '"'): TStrings;
  type
    TState = (sNone, sBegin, sEnd);
  var
    I : Integer;
    state : TState;
    token : string;
    // -------------------
    procedure AddToResult;
    begin
      if (token <> '') and (token[1] = AQuoteChar) then begin
        delete(token, 1, 1);
        delete(token, Length(token), 1);
      end;
      Result.Add(token);
      token := '';
    end;

// -------------------
  begin
    if s = '' then
      exit;
    Result := TstringList.Create;
    state := sNone;
    token := '';
    I := 1;
    while I <= Length(s) do begin
      case state of
      sNone : begin
          if s[I] = ADelimiter then begin
            token := '';
            AddToResult;
            inc(I);
            Continue;
          end;
          state := sBegin;
        end;
      sBegin : begin
          if s[I] = ADelimiter then begin
            if (token <> '') and (token[1] <> AQuoteChar) then begin
              state := sEnd;
              Continue;
            end;
          end;
          if s[I] = AQuoteChar then begin
            if (I = Length(s)) or (s[I + 1] = ADelimiter) then
              state := sEnd;
          end;
        end;
      sEnd : begin
          state := sNone;
          AddToResult;
          inc(I);
          Continue;
        end;
      end;
      token := token + s[I];
      inc(I);
    end;
    if token <> '' then
      AddToResult;
    if s[Length(s)] = ADelimiter then
      AddToResult
  end;
  // -----------------------------
  function getDateCode(sDate : string): string;
  begin
    // mm/dd/yyyy to delphi date number
    Result := floatToStr(StrToDate(sDate, Settings.InternalFmt)- 27904);
  end;

// -----------------------------
begin
  try
    sDateCode := getDateCode(sDate); // 2017-05-23 MB
    sDate1 := StrDateAdd(sDate, -1, Settings.InternalFmt);
    // To get the price of AAPL from 12/28/2015 through 12/31/2015, use
    // http://ichart.finance.yahoo.com/table.csv?s=AAPL&a=11&b=28&c=2015&d=11&e=31&f=2015&g=d
    // start date is based on sDate-1
    // sDate1 := DateToStr(dtTmp);
    mm := rightstr('0' + parsefirst(sDate1, '/'), 2);
    mmm1 := getExpMo(mm);
    dd1 := parsefirst(sDate1, '/');
    yyyy1 := sDate1;
    // end date is based on sDate arg
    mm := rightstr('0' + parsefirst(sDate, '/'), 2);
    mmm := getExpMo(mm);
    dd := rightstr('0' + parsefirst(sDate, '/'), 2);
    yyyy := sDate;
// ---------- 2022-06-13 MB - price function no longer works
// prStr := '';
// Result :=-1;
// exit;
// ----------
    // ----------------------
    // STOCKS
    // ----------------------
    if isTickerSymbol(sTicker) then begin
      // NEW Google QUERY URL
      // http://www.google.com/finance/historical?cid=22568
      // &startdate=Dec+31%2C+2016&enddate=Jan+3%2C+2017
      // &num=30&output=csv
      QuoteService := 'http://www.google.com/finance/historical?q=' + sTicker //
        + '&startdate=' + mmm + '+' + dd1 + '%2C' + '+' + yyyy //
        + '&enddate=' + mmm + '+' + dd + '%2C' + '+' + yyyy //
        + '&num=1&output=csv';
      prStr := readURL(QuoteService);
      // --------------------
      if SuperUser and (DEBUG_MODE > 3) then begin
        sTmp := 'URL = ' + CRLF + QuoteService + CRLF //
          + CRLF //
          + 'Reply = ' + CRLF //
          + prStr;
        clipboard.AsText := sTmp;
        sm(sTmp);
      end;
      // --------------------
      if (prStr = '') then begin
        Result :=-1;
        exit;
      end;
      // --------------------------------------------------
      // 20022-08-16 MB - new data format from Google finance:
      // e.g. when searching for ticker 'FSLY' or 'NFLX',
      //
      // 1. confirm which ticker by searching for
      // 'https://www.google.com/finance/quote/'+ticker+':'
      //
      // 2. find 'data-last-price=', extract price between quotes
      // data-last-price="249.11" <-- price
      // --------------------------------------------------
      j := pos('https://www.google.com/finance/quote/' + sTicker, prStr);
      if (j > 1) then
        delete(prStr, 1, j - 1)
      else begin
        Result :=-1;
        exit;
      end;
      // --------------------
      j := pos('data-last-price="', prStr);
      if (j > 1) then
        delete(prStr, 1, j + 15)
      else begin
        Result :=-1;
        exit;
      end;
      sTmp := copy(prStr, 1, pos('"', prStr, 2));
      // --------------------
      prStr := parseHTML(sTmp, '"', '"');
    end // if isTickerSymbol
    // ----------------------
    // OPTIONS
    // ----------------------
    else begin
// QuoteService := 'https://ca.finance.yahoo.com/q/hp?s=' + sTicker //
// + '&a=' + mm + '&b=' + dd + '&c=' + yyyy //
// + '&d=' + mm + '&e=' + dd + '&f=' + yyyy //
// + '&g=d';
// prStr := readURL(QuoteService, 2000);
// if (prStr = '') then begin
      Result :=-1;
      exit;
// end;
// prStr := parseHTML(prStr, '$price.0">', '</span>');
    end; // if isTickerSymbol... else
// ---------- 2022-06-13 MB - price function no longer works
    // -------- end new code -----------------
    if not isFloat(prStr) then
      Result := -1
    else
      Result := strToFloat(prStr, Settings.InternalFmt);
  except
    on e : Exception do
      mDlg('Error in getPriceOnDate' + cr //
          + 'Error Message: ' + e.Message + cr //
          + 'Date: ' + sDate, mtError, [mbOK], 0);
  end;
end;


function GetYearEndMTMprice(tkStr :string; typemult : string; lastYr : boolean): double;
var
  I : Integer;
  prStr, sTmp, sTk, sYY, sMM, sDD, sSP, sCP, s : string;
  tempFile : TSearchRec;
begin
  Result := -1; // assume failure
  // get closing price for last trading day of year
  if pos('FUT', typemult) = 1 then begin
    exit;
  end
  // get Stock or Option price
  else begin
    statBar('Getting price for: ' + tkStr);
    GetCurrTaxYear;
    // -------- new code uses API ---------------
    if pos('OPT', typemult)=1 then begin
      // --- convert ticker to optionroot ---------
      // KO 16FEB24 62.5 CALL
      // KO240216C00062500
      //       DDMMMYY $$$
      // GOOGL 21JUN24 220 CALL
      // GOOGL240621C00220000
      //      YYMMDD $$$$$000
      sTmp := tkStr;
      sTk := parseFirst(sTmp, ' ');
      sCP := parseLast(sTmp, ' ');
      sCP := copy(sCP,1,1);
      sSP := parseLast(sTmp, ' ');
      s := parseFirst(sSP, '.');
      sSP := copy(sSP + '000',1,3);
      s := rightstr('00000' + s,5);
      sSP := s + sSP;
      sTmp := trim(sTmp);
      if length(sTmp) <> 7 then exit; // unable to parse option ticker
      sDD := copy(sTmp,1,2);
      sMM := copy(sTmp,3,3);
      sYY := copy(sTmp,6,2);
      sMM := monNum(sMM);
      sTmp := sTk + sYY + sMM + sDD + sCP + sSP;
      if lastYr then
        prStr := GetMTMPriceOPT(v2UserToken, LastTaxYear, sTmp)
      else
        prStr := GetMTMPriceOPT(v2UserToken, TaxYear, sTmp);
    end
    else begin // stock
      // --- fix for IB preferred stock ---------
      sTmp := tkStr;
      if pos(' PR', tkStr)> 0 then begin
        if (copy(tkStr, pos(' ', tkStr)+ 1, 2)= 'PR') then begin
          if pos(' ', tkStr)= Length(tkStr)- 2 then
            sTmp := copy(tkStr, 1, pos(' ', tkStr)- 1)+ '-'
          else
            sTmp := copy(tkStr, 1, pos(' ', tkStr)- 1) + '-' + copy(tkStr, Length(tkStr), 1);
        end;
      end;
      if lastYr then
          prStr := GetMTMPriceSTK(v2UserToken, LastTaxYear, sTmp)
      else
        prStr := GetMTMPriceSTK(v2UserToken, TaxYear, sTmp);
    end;
    if not isFloat(prStr) or (prStr = '') then
      Result :=-1
    else
      Result := strToFloat(prStr, Settings.InternalFmt);
    if findFirst('*.tmp', faAnyFile, tempFile)= 0 then
      SysUtils.deleteFile(tempFile.name);
    findClose(tempFile.FindHandle);
  end;
end;


procedure CalcProfitOpenTrades(TrNum : Integer);
var
  R : Integer;
  profit : double;
begin
  profit := 0;
  with frmMain.cxGrid1TableView1.dataController do begin
    BeginUpdate;
    try
      for R := 0 to RecordCount - 1 do begin
        if Values[R, 1] > TrNum then
          break;
        if Values[R, 1] = TrNum then begin
          profit := profit + Values[R, 11];
          if (Values[R, 4]= 'C') then
            Values[R, 12]:= profit;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;


procedure ReadFilter;
begin
  MainFilterStream.Clear;
  if not EnteringBeginYearPrice and (Length(GetFilterCaption) > 0) then begin
    frmMain.cxGrid1TableView1.dataController.Filter.SaveToStream(MainFilterStream);
    gsFilterText := frmMain.cxGrid1TableView1.dataController.Filter.FilterText;
  end;
end;


procedure WriteFilter(del : boolean);
begin
  if (MainFilterStream.Size > 0) then begin
    MainFilterStream.Position := 0;
    frmMain.cxGrid1TableView1.dataController.Filter.LoadFromStream(MainFilterStream);
    if del then
      MainFilterStream.Clear;
  end;
  dispProfit(True, 0, 0, 0, 0);
end;


procedure FilterByOpenTrades(oc : string);
begin
  ClearFilter;
  frmMain.cxGrid1TableView1.dataController.Filter.BeginUpdate;
  try
    frmMain.cxGrid1TableView1.dataController.Filter.Root.BoolOperatorKind := fboAnd;
    if oc = 'O' then
      frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItem
        (frmMain.cxGrid1TableView1.items[14], foEqual, True, 'yes');
    if oc = 'C' then
      frmMain.cxGrid1TableView1.dataController.Filter.Root.AddItem
        (frmMain.cxGrid1TableView1.items[14], foEqual, false, 'no');
    frmMain.cxGrid1TableView1.dataController.Filter.active := True;
  finally
    frmMain.cxGrid1TableView1.dataController.Filter.EndUpdate;
  end;
  sortByType;
end;


function GetOptInfo(tkStr :string):string;
var
  QuoteService, optStr, junk :string;
begin
  QuoteService := 'http://finance.yahoo.com/q/op?s=' + tkStr + '.X';
    // sm(QuoteService);
  optStr := readURL(QuoteService);
  if (optStr = '') then begin
    Result := tkStr + ' - INVALID';
    exit;
  end;
  delete(optStr, 1, pos('<title', optStr)+ 5);
  delete(optStr, 1, pos('>', optStr));
  optStr := copy(optStr, 1, pos(' - Yahoo', optStr)- 1);
  optStr := upperCase(optStr);
  if pos('(', optStr)> 0 then
    junk := parselast(optStr, '(');
  optStr := trim(optStr);
  delete(tkStr, pos('.X', tkStr), 2);
  if (optStr = '') then begin
    Result := tkStr + ' - INVALID';
    exit;
  end;
  delete(optStr, 1, pos(' FOR ', optStr)+ 4);
    // two digit year
  delete(optStr, pos(' 20', optStr), 3);
    // get rid if extra zeros in strike price
  delete(optStr, pos('0000 CALL', optStr), 4);
  delete(optStr, pos('000 CALL', optStr), 3);
  delete(optStr, pos('00 CALL', optStr), 2);
  delete(optStr, pos('0 CALL', optStr), 1);
  delete(optStr, pos('0000 PUT', optStr), 4);
  delete(optStr, pos('000 PUT', optStr), 3);
  delete(optStr, pos('00 PUT', optStr), 2);
  delete(optStr, pos('0 PUT', optStr), 1);
  delete(optStr, pos('. CALL', optStr), 1);
  delete(optStr, pos('. PUT', optStr), 1);
  if (pos('OPTIONS FOR', optStr)> 0) or (optStr = '') then begin
    Result := tkStr + ' - INVALID';
    exit;
  end;
  Result := optStr;
end;


// ------------------------------------
procedure GetCurrentPrices(dtAsOf : TDate);
var
  I, j, R, x, ItemNum : Integer;
  Shares, price, comm, Amount, mult, profit : double;
  QuoteService, reply, ticks, OptionTick, ls, prStr, line, tkStr, currYear, sTypeMult, sDate,
    sExpDt, sJunk : string;
  NotAllPriced, gotOptTicker, priceOK : boolean;
  tempFile : TSearchRec;
  txtFile : textFile;
  Year, Month, Day : Word;
  dtExpDt : TDate;
begin
  frmMain.enabled := false;
  try
    getCurrPriceRow := -1;
    NotAllPriced := false;
    stopUpdate := false;
    x := 0;
    R := 0;
    comm := 0; // Added to initialize; As of 1/26/07 comm not fetched!
    price := 0;
    gotOptTicker := false;
    DecodeDate(dtAsOf, Year, Month, Day);
    sDate := dateToStr(dtAsOf);
    currYear := IntToStr(Year mod 100);
    while Length(currYear) < 2 do
      currYear := '0' + currYear;
    // --------------------------------
    if TradeLogFile.HasOptions then begin
      if mDlg('This process will update the OPRA Symbols for all options!' + cr //
          + cr //
          + 'Would you like to clear current OPRA Symbols?', mtConfirmation,[mbYes, mbNo], 0) = mrYes
      then
        TradeLogFile.ClearOPRASymbols;
    end;
    // --------------------------------
    for I := 0 to frmMain.cxGrid1TableView1.dataController.RecordCount - 1 do begin
      if frmMain.cxGrid1TableView1.dataController.FilteredRecordCount > 0 then
        j := frmMain.cxGrid1TableView1.dataController.FilteredRecordIndex[I]
      else
        j := I;
      if (frmMain.cxGrid1TableView1.dataController.Values[j, 4]<> 'C') then
        Continue;
      // -------------------------
      Application.ProcessMessages;
      if (GetKeyState(VK_ESCAPE) and 128) = 128 then
        stopUpdate := True;
      // -------------------------
      // lookup sTypeMult once - it could be tested many times! 2016-07-18 MB
      sTypeMult := frmMain.cxGrid1TableView1.dataController.Values[j, 9];
      // ------------------------------
      // get OptionTicker / OPRA Symbol
      // ------------------------------
      if (pos('OPT', sTypeMult)= 0) //
        or (frmMain.cxGrid1TableView1.dataController.Values[j, 17]= '') //
        or (not IsInt(rightstr(frmMain.cxGrid1TableView1.dataController.Values[j, 17], 8))) //
      then begin
        // get ticker or option
        tkStr := frmMain.cxGrid1TableView1.dataController.Values[j, 6];
      end
      else begin
        // get opt OPRA symbol
        tkStr := frmMain.cxGrid1TableView1.dataController.Values[j, 17];
      end;
      // ------------------------------
      /// get Futures price
      // ------------------------------
      if pos('FUT', sTypeMult)> 0 then begin
        statBar('Getting price for Future: ' + tkStr);
        price := getPriceOnDate(tkStr, sDate);
        price := -1;
        // This is broken so for now just have them provide the price
        // price:= getPriceFuture(tkStr);
      end
      // ------------------------------
      // get Options price for PUT or CALL
      // ------------------------------
      else if (pos('OPT', sTypeMult) > 0) //
        and ((pos(' PUT', tkStr)> 0) or (pos(' CALL', tkStr)> 0)) //
      then begin
        statBar('Getting price for Option: ' + tkStr);
        sExpDt := tkStr;
        sJunk := parsefirst(sExpDt, ' ');
        sExpDt := parsefirst(sExpDt, ' ');
        if Length(sExpDt) < 5 then
          sExpDt := sJunk;
        OptionTick := getOptionTick(tkStr);
        try
          OpenTradeRecordsSource.Trades[j].OptionTicker := OptionTick;
          gotOptTicker := True;
        except
        end;
        if (Length(sExpDt)= 5) or (Length(sExpDt)= 7) then begin
          dtExpDt := ConvertExpDate(sExpDt);
          if dtExpDt < dtAsOf then
            price := 0
          else
            price := getPriceOption(OptionTick);
            // price := getPriceOnDate(OptionTick, sDate);
        end;
      end
      // ------------------------------
      else if (pos('OPT', sTypeMult) > 0) then begin
        /// get Options price for options OPRA symbol
        OptionTick := tkStr;
        price := getPriceOption(OptionTick);
        // price := getPriceOnDate(OptionTick, sDate);
      end
      // ------------------------------
      // Get STOCK Price
      // ------------------------------
      else begin
        statBar('Getting price for Stock: ' + tkStr);
        // fix for IB preferred stock
        if pos(' PR', tkStr)> 0 then begin
          if (copy(tkStr, pos(' ', tkStr)+ 1, 2)= 'PR') then begin
            if pos(' ', tkStr)= Length(tkStr)- 2 then
              tkStr := copy(tkStr, 1, pos(' ', tkStr)- 1)+ '-'
            else
              tkStr := copy(tkStr, 1, pos(' ', tkStr)- 1) + '-' + copy(tkStr, Length(tkStr), 1);
          end; // if ' PR' follows tkStr
        end; // if contains ' PR'
        price := getPriceOnDate(tkStr, sDate);
        if price = -1 then
          price := GetPriceStock(tkStr); // try both methods
      end; // if sTypeMult
      // ------------------------------
      // What to do if price not found?
      // ------------------------------
      if price = -1 then begin
        repeat
          prStr := '';
          price := 0;
          priceOK := True;
          if not myinputQuery('PRICE NOT FOUND', 'Please enter price for ' + tkStr + ':', prStr,
            frmMain.Handle) then begin
            stopUpdate := True;
            NotAllPriced := True;
          end
          else if isFloatEx(prStr, Settings.UserFmt) then
            price := strToFloat(prStr, Settings.UserFmt)
          else begin
            if mDlg('PRICE MUST BE A DECIMAL NUMBER WITH ''' + Settings.UserFmt.DecimalSeparator //
                + ''' AND NO ''' + Settings.UserFmt.ThousandSeparator + ''' !', //
              mtError, [mbOK, mbCancel], 0) = mrCancel //
            then begin
              stopUpdate := True;
              NotAllPriced := True;
            end
            else
              priceOK := false;
          end;
        until priceOK;
      end; // if price = -1
      // ------------------------------
      frmMain.cxGrid1TableView1.dataController.FocusedRecordIndex := j;
      Application.ProcessMessages;
      OpenTradeRecordsSource.Trades[j].price := price;
      OpenTradeRecordsSource.DataChanged;
      // ------------------------------
      if stopUpdate then begin
        NotAllPriced := not(I < frmMain.cxGrid1TableView1.dataController.RecordCount - 1);
        break;
      end;
    end; // for I := 0 to ...RecordCount - 1
    // --------------------------------
    if findFirst('*.tmp', faAnyFile, tempFile)= 0 then
      SysUtils.deleteFile(tempFile.name);
    findClose(tempFile.FindHandle);
    if gotOptTicker then begin
      statBar('OPRA Symbols Updated, Saving File - Please Wait...');
      SaveTradeLogFile('Save OPRA option symbols', True, True);
      statBar('off');
    end;
    if NotAllPriced then
      statBar('NOT All Open Positions Were Priced to Market - Click the CLOSE button or hit the ESCAPE key to cancel')
    else
      statBar('All Open Positions Priced to Market - You may run reports - Click the CLOSE button or hit the ESCAPE key to cancel');
  finally
    frmMain.enabled := True;
    frmMain.cxGrid1.SetFocus;
  end;
  stopUpdate := false;
end;


// ------------------------------------
function formatMatchedSort(m :string) : string;
var
  s : string;
begin
  s := m;
  if LeftStr(s, 2) = 'Ex' then begin
    s := parselast(s, '-');
    if Length(s)= 1 then
      Result := 'Ex-' + '000' + s
    else if Length(s)= 2 then
      Result := 'Ex-' + '00' + s
    else if Length(s)= 3 then
      Result := 'Ex-' + '0' + s
    else if Length(s)= 4 then
      Result := 'Ex-' + s
    else
      Result := 'x';
  end
  else if IsInt(s) then begin
    if Length(s)= 1 then
      Result := '000' + s
    else if Length(s)= 2 then
      Result := '00' + s
    else if Length(s)= 3 then
      Result := '0' + s
    else if Length(s)= 4 then
      Result := s
    else
      Result := 'x';
  end
  else
    Result := 'x';
end;


procedure FindTradeIssues;
var
  s : string;
begin
  if bImporting then
    exit;
  try
    s := 'checking panelMsg';
    if panelMsg.Visible then begin
      s := 'clearing filter';
      ClearFilter;
    end;
    s := 'checking negative shares';
    panelMsg.UpdateTradeIssues(mtNegativeShares, TradeLogFile.HasNegShares);
    s := 'checking cancelled trades';
    panelMsg.UpdateTradeIssues(mtCancelledTrades, TradeLogFile.HasCancelledTrades);
    s := 'checking invalid tickers';
    panelMsg.UpdateTradeIssues(mtInvalidTickers, TradeLogFile.HasInvalidOptionTickers);
    s := 'checking mismatched types';
    panelMsg.UpdateTradeIssues(mtMisMatchedTradeTypes, TradeLogFile.HasMisMatchedTypes);
    s := 'checking mismatched LS';
    panelMsg.UpdateTradeIssues(mtMisMatchedLS, TradeLogFile.HasMisMatchedLS);
    s := 'checking zero or less trades';
    panelMsg.UpdateTradeIssues(mtZeroOrLessTrades, TradeLogFile.HasZeroOrLessTrades);
    // panelMsg.UpdateTradeIssues(mtOptionTypeDiscrepancies, TradeLogFile.HasMisMatchedOptionTypes);
    // --
    s := 'showing trade issues';
    if panelMsg.HasTradeIssues then begin
      panelMsg.ShowTradeIssues;
    end
    else begin
      panelMsg.hide;
      frmMain.cxGrid1.enabled := True;
    end;
  except
    on E : Exception do begin
      sm('Error in FindTradeIssues in ' + s + CRLF //
        + E.ClassName + ': ' + E.Message);
      gsErrorText := 'ERROR ' + s;
    end;
  end;
  screen.cursor := crDefault;
end;


function GetAccountNamesFromFilter : string;
var
  s, T : string;
  I : Integer;
begin
  s := frmMain.cxGrid1TableView1.dataController.Filter.filterCaption; // fixed 2015-09-25 MB
  Result := '';
  repeat
    I := pos('Broker Account = ', s);
    if I > 0 then begin // 2020-05-20 MB - fix for repeated account names
      delete(s, 1, I + 16);
      T := TAB + copy(s, 1, pos(')', s) - 1) + TAB; // TAB is to prevent partial matches
      if pos(T, Result) > 0 then
        Continue;
      if Length(Result) > 0 then
        Result := Result + ', ';
      Result := Result + T;
    end;
  until I = 0;
  // now remove the placeholders
  Result := ReplaceStr(Result, TAB, '');
  // If the filter does not contain any accounts then return the
  // CurrentAcctName which will return all if no current account or account
  // name if current account
  if Length(Result) = 0 then
    Result := TradeLogFile.CurrentAcctName;
end;


function GetFilterCaption : string;
var
  I : Integer;
  Idx, Idx2 : Integer;
  // ------------------------
  procedure RemoveAndOr;
  var
    sTemp : string;
    j : Integer;
  begin
   { After removing Wash Sales and Broker Account filter stuff we now may have an
    "and" or an "or" leading or trailing so lets make sure we remove this. }
    j := pos('( and (', Result);
    if j > 0 then
      delete(Result, j + 1, 5);
    if (rightstr(Result, 4) = 'or )') //
      and (pos(' and ( or', Result) > 0) then
      delete(Result, pos(' and ( or', Result), Length(Result) - pos(' and ( or', Result) - 1);
    if LeftStr(Result, 5) = ' and ' then
      delete(Result, 1, 5);
    if LeftStr(Result, 4) = ' or ' then
      delete(Result, 1, 4);
    if rightstr(Result, 5) = ' and ' then
      delete(Result, Length(Result) - 4, 5);
    if rightstr(Result, 4) = ' or ' then
      delete(Result, Length(Result) - 3, 4);
  end;
// ------------------------
begin
try
  Result := frmMain.cxGrid1TableView1.dataController.Filter.filterCaption;
  // We never want to see the Wash Sale Filter so remove it
  Idx := pos('((O/C <> W))', Result);
  if Idx > 0 then begin
    delete(Result, Idx, 12);
    RemoveAndOr;
  end;
  // Since we have a report field for Accounts, filter out the Broker Account = portion of the filter
  while (pos('(Broker Account = ', Result)> 0) do begin
    Idx := pos('(Broker Account = ', Result);
    if Idx > 0 then begin
      Idx2 := PosEx(')', Result, Idx);
      delete(Result, Idx, Idx2 - Idx + 1);
      RemoveAndOr;
    end;
  end;
  while (pos('((Type/Mult NOT LIKE CUR*)) or ((Type/Mult NOT LIKE CUR*))', Result) > 0) do begin
    delete(Result, pos('((Type/Mult NOT LIKE CUR*)) or ((Type/Mult NOT LIKE CUR*))', Result), 31);
  end;
  while (LeftStr(Result, 2)= '((') and (rightstr(Result, 2)= '))') do
    Result := MidStr(Result, 2, Length(Result)- 2);
  // RemoveAndOr;
  { When viewing an individual broker account we don't want the broker in the
    Filter String }
{ if (TradeLogFile <> nil) and (TradeLogFile.CurrentBrokerID > 0) then
  begin
    Idx := Pos('(Broker Account = ', Result);
    if Idx > 0 then begin
      Idx2 := PosEx(')', Result, Idx);
      Delete(Result, Idx, Idx2 - Idx + 1);
      RemoveAndOr;
    end;
  end; }
except
  sm('error in GetFilterCaption');
end;
  Result := trim(Result);
end;


procedure dispNegShTicker(tick :string);
begin
  with frmMain do
    with cxGrid1TableView1.dataController do begin
      ClearFilter;
      FilterByTick(tick);
      cxGrid1.enabled := True;
      cxGrid1.SetFocus;
      EditDisable(false);
    end;
end;


end.
