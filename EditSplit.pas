unit EditSplit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, //
  Vcl.ComCtrls, Menus, Math, //
  TLregister, //
  cxLookAndFeelPainters, cxGraphics, cxLookAndFeels, cxDateUtils, cxButtons, cxTextEdit, //
  cxControls, cxContainer, cxEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, //
  dxCore, dxSkinsCore, dxSkinHighContrast, dxSkinOffice2010Black, dxSkinOffice2010Blue, //
  dxSkinOffice2010Silver;

type
  TfrmEditSplit = class(TForm)
    dateSplit: TcxDateEdit;
    Label2: TLabel;
    editSplit1: TcxTextEdit;
    editSplit2: TcxTextEdit;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    btnOK: TcxButton;
    btnCancel: TcxButton;
    editTick: TcxComboBox;
    editNewTicker: TcxTextEdit;
    btnNewTick: TcxButton;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnNewTickClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  procedure editSplitShowDlg;
  procedure changeTickerShowDlg;
  procedure changeTicker;

var
  frmEditSplit: TfrmEditSplit;
  editAdjSplit : boolean;

implementation

uses Main, FuncProc,
  cxCustomData, RecordClasses, cxFilter,
  Import, globalVariables, TLSettings, TLCommonLib, TLFile;

{$R *.DFM}

procedure TfrmEditSplit.btnCancelClick(Sender: TObject);
begin
  hide;
  modalResult:= mrCancel;
end;


procedure TfrmEditSplit.FormShow(Sender: TObject);
var
  i:integer;
  tick,lastTick:string;
begin
  editTick.properties.items.Clear;
  lastTick:= '';
  with frmMain do
  with cxGrid1TableView1 do
  with DataController do begin
    if getSelectedCount > 0 then begin
      tick:= TradeLogFile[focusedRecordIndex].Ticker;
      editTick.properties.items.add(tick);
      if editAdjSplit then
        dateSplit.Date:= TradeLogFile[focusedRecordIndex].Date;
    end
    else begin
      //load tickers into split ticker edit box
      for i:= 0 to filteredRecordCount-1 do begin
        tick:= TradeLogFile[filteredRecordIndex[i]].Ticker;
        if tick<>lastTick then
          editTick.properties.items.add(tick);
        lastTick:= tick;
      end;
      //load max date
      if editAdjSplit then
        dateSplit.Date:= TradeLogFile.LastDateImported;
    end;
    editTick.itemIndex:= 0;
    editTick.SetFocus;
  end;
end;


// --------------------------
//   OK - adjust for split
// --------------------------
procedure TfrmEditSplit.btnOKClick(Sender : TObject);
var
  i, trNum : integer;
  splitShares, Shares, Price, splitFactor : double;
  tick, splitTick, MatchTicker, ls : string;
  splitDate, recDate : TDate;
  AFiltList : TcxFilterCriteriaItemList;
  Trade : TTLTrade;
  ChangeStrike : boolean;
  // ----------------------------------
  function newTick(tick :string):string;
  var
    strikePr, callPut : string;
    spNum : double;
  begin
    // get strike price
    callPut := parseLast(tick, ' ');
    strikePr := parseLast(tick, ' ');
    if isFloatEx(strikePr, Settings.UserFmt) then
      spNum := (strToFloat(strikePr, Settings.UserFmt) / splitFactor);
      spNum := StrFmtToFloat('%1.2f', [spNum], Settings.UserFmt);
      strikePr := floatToStr(spNum, Settings.UserFmt);
    result := tick + ' ' + strikePr + ' ' + callPut;
  end;
  // ----------------------------------
  procedure filterBySplitDate;
  begin
    with frmMain.cxGrid1TableView1 do
      with DataController.filter do begin
        try
          active := true;
          beginUpdate;
          root.AddItem(items[2], foLessEqual, splitDate, dateToStr(splitDate, Settings.UserFmt));
        finally
          EndUpdate;
        end;
      end;
  end;
  // ----------------------------------
  procedure AdjustForStockSplit;
  var
    i, j : integer;
    sSplitSh, sSplitType : string;
    splitShares : double;
  begin
    // get number of open shares/contracts and whether long or short   2011-01-04
    with frmMain.cxGrid1TableView1.DataController do begin
      if (filteredRecordCount < 1) then
        exit;
      sSplitType := TradeLogFile[filteredRecordIndex[filteredRecordCount - 1]].TypeMult;
      if ((pos('OPT', sSplitType) = 1) or (pos('FUT', sSplitType) = 1)) then
        sSplitSh := delCommas(frmMain.txtContrOpen.caption)
      else
        sSplitSh := delCommas(frmMain.txtSharesOpen.caption);
      splitShares := strToFloat(sSplitSh, Settings.UserFmt)
    end;
    // sm('NumSharesOpen = '+floatToStr(splitShares,Settings.UserFmt));
    // adjust for stock split
    with frmMain do begin
      with cxGrid1TableView1 do begin
        with DataController do begin
          for i := filteredRecordCount - 1 downto 0 do begin
            // sm(intToStr(i)+tab+splitTick+tab+floatToStr(splitFactor) //
            //   +tab+dateToSTr(splitDate,Settings.UserFmt));
            // if (TradeLogFile[filteredRecordIndex[i]].ls <> ls) then continue;
            if splitShares = 0 then
              break;
            tick := TradeLogFile[filteredRecordIndex[i]].Ticker;
            if tick < splitTick then
              break;
            if tick = splitTick then begin
              recDate := TradeLogFile[filteredRecordIndex[i]].Date;
              if recDate <= splitDate then begin
                // get number of pre-split shares
                if (splitShares = -1) then
                  splitShares := TradeLogFile[filteredRecordIndex[i]].OpenShares;
                // check if trade has open shares
                if (trNum = TradeLogFile[filteredRecordIndex[i]].TradeNum) then
                  continue
                else if (TradeLogFile[filteredRecordIndex[i]].OC = 'C') //
                  and (TradeLogFile[filteredRecordIndex[i]].OpenShares = 0) //
                then begin
                  trNum := TradeLogFile[filteredRecordIndex[i]].TradeNum;
                end;
                // split all open shares
                if (TradeLogFile[filteredRecordIndex[i]].OC = 'O') then begin
                  Shares := TradeLogFile[filteredRecordIndex[i]].Shares;
                  // added 9-13-05 to split strike price
                  if (pos(' CALL', tick) > 1) or (pos(' PUT', tick) > 1) then begin
                    // get strike price
                    if ChangeStrike //
                    or (mDlg('Change the pre-Split strike price?',
                      mtConfirmation, [mbYes, mbNo], 0) = mrYes)
                    then
                      ChangeStrike := true;
                  end;
                  // if Shares <= splitShares, but ignoring round-off error
                  if (compareValue(Shares, splitShares, NEARZERO) <= 0) then begin
                    Price := TradeLogFile[filteredRecordIndex[i]].Price;
                    TradeLogFile[filteredRecordIndex[i]].Shares := Shares * splitFactor;
                    TradeLogFile[filteredRecordIndex[i]].Price := Price / splitFactor;
                    splitShares := splitShares - Shares;
                    // added 9-13-05 to split strike price
                    if ChangeStrike then begin
                      { callPut:= parseLast(tick,' ');
                        strikePr:= parseLast(tick,' ');
                        if isFloatEx(strikePr,Settings.UserFmt) then
                        strikePr:= floatToStr(strToFloat(strikePr,Settings.UserFmt)/splitFactor,Settings.UserFmt);
                        tick:= tick +' '+ strikePr +' '+callPut; }
                      tick := newTick(tick);
                      TradeLogFile[filteredRecordIndex[i]].Ticker := tick;
                      MatchTicker := tick;
                    end;
                    // adjust W transactions
                    for j := i downto 0 do begin
                      if (TradeLogFile[filteredRecordIndex[j]].OC = 'W') //
                      and (TradeLogFile[filteredRecordIndex[j]].Date = TradeLogFile[filteredRecordIndex[i]].Date) //
                      and (TradeLogFile[filteredRecordIndex[j]].Note <> 'adj')
                      // and (TradeLogFile[filteredRecordIndex[j]].ls = ls)
                      then begin
                        TradeLogFile[filteredRecordIndex[j]].Shares :=
                          TradeLogFile[filteredRecordIndex[j]].Shares * splitFactor;
                        TradeLogFile[filteredRecordIndex[j]].Note := 'adj';
                      end;
                    end;
                  end
                  // else if Shares > splitShares, but ignoring round-off
                  else if (compareValue(Shares, splitShares, NEARZERO) > 0) then begin
                    // add a record with balance of shares
                    Trade := TTLTrade.Create(TradeLogFile[filteredRecordIndex[i]]);
                    Trade.Commission := (Trade.Shares - splitShares) / Trade.Shares *
                      Trade.Commission;
                    Trade.Shares := Shares - splitShares;
                    Trade.ID := TradeLogFile.NextID;
                    // adjust the open shares for the split
                    Price := TradeLogFile[filteredRecordIndex[i]].Price;
                    TradeLogFile[filteredRecordIndex[i]].Shares := splitShares * splitFactor;
                    TradeLogFile[filteredRecordIndex[i]].Commission :=
                      TradeLogFile[filteredRecordIndex[i]].Commission - Trade.Commission;
                    TradeLogFile[filteredRecordIndex[i]].Price := Price / splitFactor;
                    // added 9-13-05 to split strike price
                    if ChangeStrike then begin
                      // // get strike price
                      // callPut:= parseLast(tick,' ');
                      // strikePr:= parseLast(tick,' ');
                      // if isFloatEx(strikePr, Settings.UserFmt) then
                      // strikePr:= floatToStr(strToFloat(strikePr,Settings.UserFmt) / splitFactor,Settings.UserFmt);
                      // tick:= tick + ' ' + strikePr + ' ' +callPut;
                      tick := newTick(tick);
                      TradeLogFile[filteredRecordIndex[i]].Ticker := tick;
                    end;
                    // Give the left over shares a new ID, so that matching does not get confused,
                    // Trade.ID := TradeLogFile.NextID;
                    // insert the trade in the position it was in.
                    TradeLogFile.InsertTrade(filteredRecordIndex[i], Trade);
                    splitShares := 0;
                    break;
                  end; // if Shares <= splitShares
                end; // if open shares
              end; // if recDate <= splitDate
            end; // if tick = splitTick
          end; // for i := filteredRecordCount - 1 downto 0
        end; // with DataController
      end; // with cxGrid1TableView
    end; // with frmMain
  end; // procedure AdjustForStockSplit
// --------------------------------------------------------
begin
  // sm('adjust for stock split');
  // updated 2014-06-26
  btnOK.SetFocus; // moves off of date edit box so new date is posted
  readFilter;
  // --------------
  splitTick := editTick.text;
  MatchTicker := splitTick;
  ChangeStrike := False;
  splitFactor := strToFloat(editSplit1.text, Settings.UserFmt) / strToFloat(editSplit2.text,
    Settings.UserFmt);
  splitDate := dateSplit.Date;
  // --------------
  hide;
  modalResult := mrOK;
  // --------------
  // initial grid filter - select all trades for specific stock ticker
  ClearFilter;
  filterByTick(splitTick);
  readFilter;
  filterBySplitDate; // this assumes LIFO!
  // --------------
  if frmMain.cxGrid1TableView1.DataController.filteredRecordCount = 0 then begin
    mDlg('ERROR: No records match your criteria.' + CR + CR +
        'Please enter a valid ticker and a date greater' + CR +
        'than the earliest trade for the ticker.', mtError, [mbOK], 0);
    modalResult := mrCancel;
    frmMain.btnShowAll.Click;
    exit;
  end;
  // adjust long trades
  splitShares := -1;
  filterByLS('L');
  AdjustForStockSplit;
  // --------------
  ClearFilter;
  TradeRecordsSource.DataChanged;
  // --------------
  // adjust short trades
  splitShares := -1;
  filterByTick(splitTick);
  filterBySplitDate;
  filterByLS('S');
  AdjustForStockSplit;
  // --------------
  // clear notes field
  with frmMain do
    with cxGrid1TableView1 do
      with DataController do
        for i := filteredRecordCount - 1 downto 0 do begin
          if TradeLogFile[filteredRecordIndex[i]].Note = 'adj' then
            TradeLogFile[filteredRecordIndex[i]].Note := '';
        end;
  // --------------
  editAdjSplit := true;
  TradeLogFile.RenumberItemField;
  TradeLogFile.MatchAndReorganize;
  TradeRecordsSource.DataChanged;
  frmMain.cxGrid1TableView1.DataController.ClearSelection;
  // --------------
  ClearFilter;
  filterByTick(MatchTicker);
  SaveTradeLogFile('Adjust for Split');
  FindTradeIssues;
  editAdjSplit := False;
end;


procedure editSplitShowDlg;
begin
  with frmEditSplit do begin
    Caption:= 'Adjust for Stock Split';
    editSplit1.Visible:= true;
    editSplit2.Visible:= true;
    editSplit1.text:= '2';
    editSplit2.text:= '1';
    dateSplit.Visible:= true;
    label2.visible:= true;
    label3.caption:= '<- enter split';
    label4.visible:= true;
    btnOK.visible:= true;
    btnOK.enabled:= true;
    editNewTicker.Visible:= false;
    editNewTicker.text:='';
    btnNewTick.visible:= false;
    btnNewTick.enabled:= false;
    editAdjSplit:= true;
    showModal;
    editAdjSplit := false;
  end;
end;


procedure changeTickerShowDlg;
begin
  if (TradeLogFile.Count = 0) then exit;
  with frmMain.cxGrid1TableView1.DataController do begin
    if GetSelectedCount < 1 then begin
      sm('Select Records to Change Ticker');
      exit;
    end;
  end;
  with frmEditSplit do begin
    Caption:= 'Change Ticker';
    editSplit1.Visible:= false;
    editSplit2.Visible:= false;
    dateSplit.Visible:= false;
    label2.visible:= false;
    label3.caption:= '<- enter new Ticker';
    label4.visible:= false;
    btnOK.visible:= false;
    btnOK.enabled:= false;
    editNewTicker.Visible:= true;
    editNewTicker.Text:='';
    btnNewTick.visible:= true;
    btnNewTick.enabled:= true;
    showModal;
  end;
end;


procedure TfrmEditSplit.btnNewTickClick(Sender: TObject);
begin
  changeTicker;
  hide;
  modalResult:= mrOK;
end;


function myInsert(r,s:string;i:integer):string;
begin
  insert(r,s,i);
  myInsert:= s;
end;


procedure changeTicker;
var
  i,p,aRow,aRec:Integer;
  aRowInfo: TcxRowInfo;
  oldTk,newTk,tick:string;
begin
  frmEditSplit.hide;
  SaveTradesBack('Change Ticker');
  oldTk:= frmEditSplit.editTick.text;
  newTk:= frmEditSplit.editNewTicker.text;
  with frmMain.cxGrid1TableView1.DataController do begin
    beginUpdate;
    try
      for i:= 0 to GetSelectedCount-1 do begin
        aRow := GetSelectedRowIndex(i);
        aRowInfo := GetRowInfo(aRow);
        aRec:= aRowInfo.RecordIndex;
        tick:= Values[aRec,6];
        p:= pos(oldTk,tick);
        if p>0 then begin
          delete(tick,p,length(oldTk));
          tick:= myInsert(newTk,tick,p);
        end;
        Values[aRec,6]:= tick;
      end;
    finally
      EndUpdate;
    end;
  end;
  // 2017-05-10 MB - ReMatch and ReNumber affected records
  TradeLogFile.SortByTicker;
  TradeLogFile.Match(newTk);
  TradeLogFile.Match(oldTk);
  TradeLogFile.Reorganize(true);
  saveGridData(false);
  // 2017-05-10 MB - Finally, display affected records
  ClearFilter;
  filterByTick(frmEditSplit.editTick.text+','+frmEditSplit.editNewTicker.text);
end;


procedure TfrmEditSplit.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  ModalResult := mrOK;
  repaintGrid;
end;


end.
