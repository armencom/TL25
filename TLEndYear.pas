unit TLEndYear;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ShellAPI, Math, Menus, StrUtils, StdCtrls, ExtCtrls, DateUtils,
  TLFile, TLCommonLib, Generics.Collections, Generics.Defaults,
  TLTradeSummary;

type TLETY = class
  private
    function FinalCheckBeforeETY: boolean;
    procedure DeleteNextYearTrades;
    function processCashAccount(IRA:boolean; NextYearTrades:TTradeList): boolean;
    function processMTMAccount(LastOpenTrNum:Integer; NextYearTrades:TTradeList) : boolean;
    function EnterYearEndPrice(LastOpenTrNum:integer; NextYearTrades:TTradeList): boolean;
    procedure CopyAWSAdjToNextYear(NextYearTrades: TTradeList);
    procedure CopyAShortLossTradesToNextYear(NextYearTrades: TTradeList);
    procedure CopyBJanTradesToNextYearTradesList(NextYearTrades: TTradeList);
    procedure CopyCOpenPositionsToNextYear(NextYearTrades: TTradeList);
    function CopyDnextYearTradesToNextYearFile(NextYearTrades: TTradeList): boolean;
  public
    function EndTaxYear(): boolean;
    function ReverseYearEnd(Silent: boolean = false): boolean;
  end;

var
  ETY: TLETY;

implementation

uses
  Main, winInet, Import, ClipBrd, TLRegister, Commission, // HelpMsg,
  Reports,
  RecordClasses, cxCustomData, cxGridCustomTableView, cxFilter, myInput,
  SelectDateRange, frmOFX, Web,
  myDatePick, frmNewStrategies, frmNewBBIFU,
  SysConst, TLSettings, splash,
  messagePanel, PriceList, TLImportFilters, globalVariables,
  TLWinInet, TLDataSources, AccountSetup, TLDateUtils, dxCore,
  TLLogging, FuncProc,
  BackupRestoreDialog, GainsLosses, underlying;

const
  CODE_SITE_CATEGORY = 'TLEndYear';

var
  NewFile: TTLFile;
  bSaveNewFile : boolean;


//// Main End Yax Year procedure ////
// 2017-03-31 MB - changed to function!
function TLETY.EndTaxYear(): boolean;
// --------------------------
var
  i, AllAcctsBrokerID, NextWashSale, LastOpenTrNum: integer;
  Line, TimeStr, FileYr, SavedFileName: String;
  SaveDispWS, ETYaborted: boolean;
  startTime, EndTime: TDateTime;
  NextYearTrades: TTradeList;
begin // ProcessYearEnd
  result := false; // 2017-03-31 MB - assume fail until it passes
  if FinalCheckBeforeETY = false then exit;
  // ----------------------------------
  // Make sure this is false so it does not stop the process accidentally.
  StopReport := false;
  // Disable all menus and toolbar/tab control so they can't click
  frmMain.DisableMenuToolsAll;
  try
    // --------------------------------
    // Save the currently open file name so that we can restore it at the end.
    SavedFileName := Settings.DataDir + '\' + TrFileName;
    clearFilter;
    // Setting Local Variables
    NextWashSale := 0;
    LastOpenTrNum := 1;
    // Save the Current File to a year end backup.
    SaveEndYearBack;
    // --------------------------------
    NewFile := TTLFile.CreateNextYear(TradeLogFile.FileName, NextTaxYear,
      TradeLogFile.FileHeaders, frmMain.FileStatusCallBack);
    if FileExists(NewFile.FileName) //
    and (mDlg(NewFile.FileName + cr //
      + ' already exists' + cr //
      + cr //
      + 'Do you wish to overwrite this file?', //
      mtConfirmation, [mbYes, mbNo], 0) <> mrYes)
    then
      bSaveNewFile := false // not necessarily exit
    else
      bSaveNewFile := true;
    // --------------------------------
    startTime := time;
    SortByTradeNum;
    StatBar('Ending Tax Year');
    screen.Cursor := crHourglass;
    NextYearTrades := TTradeList.Create;
    // We will now load the NextYearTrades array with all necessary records.
    try
      // Save current Wash Sale setting so we can reset this later.
      Settings.DispWSDefer := True;
      frmMain.SetOptions;
      if TradeLogFile.MultiBrokerFile then begin
        frmMain.ChangeToTab('All Accounts');
        AllAcctsBrokerID := TradeLogFile.CurrentBrokerID;
        // we need this later - 2015-02-27 MB
        // Make sure all records are showing.
        frmMain.btnShowAll.click;
        screen.Cursor := crHourglass;
        // ------------------------------------------------
        // NOTE: for the following sections, I've separated each IF THEN
        // to make it easier to troubleshoot (it shouldn't impact speed)
        // ------------------------------------------------
        // Filter for Cash Records and process if they exist
        if FilterByBrokerAccountType(false, false, True, True, True) then begin
          if frmMain.cxGrid1TableView1.DataController.FilteredRecordCount > 0
          then begin
            if not processCashAccount(false, NextYearTrades) then begin
              ETYaborted := True;
              exit; // this does NOT exit procedure --> it jumps to FINALLY
            end;
          end; // if FilteredRecordCount > 0
        end; // if cash account(s)
        // ------------------------------------------------
        // Filter for IRA Records and process if they exist
        TradeLogFile.CurrentBrokerID := AllAcctsBrokerID;
        // set BrokerID back to zero!
        if FilterByBrokerAccountType(false, True, false, True, false) then begin
          if frmMain.cxGrid1TableView1.DataController.FilteredRecordCount > 0
          then begin
            if not processCashAccount(True, NextYearTrades) then begin
              ETYaborted := True;
              exit; // this does NOT exit procedure --> it jumps down to FINALLY
            end;
          end; // if FilteredRecordCount > 0
        end; // if IRA account(s)
        // ------------------------------------------------
        // Filter for MTM Records. and process these records if they exits.
        if FilterByBrokerAccountType(True, false, false, True, True) then begin
          if frmMain.cxGrid1TableView1.DataController.FilteredRecordCount > 0
          then begin
            if not processMTMAccount(LastOpenTrNum, NextYearTrades) then begin
              ETYaborted := True;
              exit; // this does NOT exit procedure --> it jumps down to FINALLY
            end;
          end; // if FilteredRecordCount > 0
        end; // if MTM account(s)
      end // multi broker file
      // ------------------------------
      else begin // single-account file
        // Make sure all records are showing.
        frmMain.btnShowAll.click; // unfilter account - process ALL of them
        screen.Cursor := crHourglass;
        // ---------- MTM -------------
        if TradeLogFile.CurrentAccount.MTM then begin
          if processMTMAccount(LastOpenTrNum, NextYearTrades) then begin
            // If there are VTNs in an MTM account, we need to process them as cash.
            FilterByType('VTN', True);
            if frmMain.cxGrid1TableView1.DataController.FilteredRecordCount > 0
            then begin
              if not processCashAccount(True, NextYearTrades) then begin
                ETYaborted := True;
                exit; // this does NOT exit procedure --> it jumps down to FINALLY
              end;
            end; // if FilteredRecordCount > 0
            // ------------------------
            // Now, copy any O/M rec pairs which were kept from previous ETY
          end // ----------------------
          else begin // MTM failed or aborted
            ETYaborted := True;
            exit; // this does NOT exit procedure --> it jumps down to FINALLY
          end;
        end
        // ---------- IRA -------------
        else if TradeLogFile.CurrentAccount.IRA then begin
          if not processCashAccount(True, NextYearTrades) then begin
            ETYaborted := True;
            exit; // this does NOT exit procedure --> it jumps down to FINALLY
          end;
        end
        // -------- cash account ------
        else begin
          if not processCashAccount(false, NextYearTrades) then begin
            ETYaborted := True;
            exit; // this does NOT exit procedure --> it jumps down to FINALLY
          end;
          // If there are futures in a cash account then we need to process them as MTM.
          FilterByType('FUT', True);
          if frmMain.cxGrid1TableView1.DataController.FilteredRecordCount > 0
          then begin
            if not processMTMAccount(LastOpenTrNum, NextYearTrades) then begin
              ETYaborted := True;
              exit; // this does NOT exit procedure --> it jumps down to FINALLY
            end;
          end; // if FilteredRecordCount > 0
        end; // if...else if (case of account type)
      end; // if multi or single account?
      // ------------------------------
      clearFilter;
      // ------------------------------
      CopyBJanTradesToNextYearTradesList(NextYearTrades);
      // ------------------------------
      ETYaborted := false;
      //
      if CopyDnextYearTradesToNextYearFile(NextYearTrades) then begin
        DeleteNextYearTrades;
        StatBar('Next Year Year File Complete');
        TradeLogFile.YearEndDone := True;
        StatBar('Saving Next Year Year File');
        SaveTradeLogFile('End Tax Year', True);
        TimeStr := getElapsedTime(startTime);
      end
      else begin
        mDlg('End Tax Year Aborted', mtWarning, [mbOK], 0);
        ETYaborted := True;
      end;
    finally
      NextYearTrades.FreeAll;
    end;
    // ------------
    StatBar('Reloading Current Year File');
    LoadRecords;
  finally
    frmMain.SetupToolBarMenuBar(false);
    screen.Cursor := crDefault; // to prevent freezing program!
    StatBar('off');
    if not ETYaborted then begin
      // make sure we cannot ETY (bug fix: after entering year end prices for Futures)
      ProHeader.CanETY := 0;
      mDlg('Year end processing complete!' + cr
        + cr
        + 'FILE HAS BEEN LOCKED FOR EDITING' + cr
        + 'and no further changes are allowed.' + cr
        + cr
        + 'You may now run the tax reports' + cr
        + 'in order to file your taxes.', mtInformation, [mbOK], 0);
      disableEdits;
      frmMain.bbFile_Save.Enabled := false;
      frmMain.bbFile_EndTaxYear.Enabled := false;
      frmMain.btnCheckList.Enabled := false; // 2017-02-16 MB New button
      frmMain.bbFile_ReverseEndYear.Enabled := true;
      result := true; // 2017-03-31 MB
    end;
  end;
end;


function TLETY.FinalCheckBeforeETY: boolean;
var
  Msg: String;
begin
  result := false; // assume fail until the end
  if TradeLogFile.Count = 0 then exit;
  // ----------------------------------
  if TradeLogFile.YearEndDone then begin
    mDlg('Year End Processing has already been completed on' + cr //
      + 'this file and cannot be run again unless you first' + cr //
      + 'run Reverse End Tax Year.',
      mtInformation, [mbOK], 0);
    exit;
  end; // -----------------------------
  if TradeLogFile.RecordLimitExceeded then begin
    mDlg('Your record limit has been exceeded.' + cr //
      + cr //
      + 'Please upgrade to a higher record limit' + cr //
      + 'to enable all features.',
      mtWarning, [mbOK], 0);
    exit;
  end; // -----------------------------
  if TradeLogFile.HasAnyTradeIssues then begin
    mDlg('You cannot end tax year when trade issues exist.' + cr //
      + cr //
      + 'Please select each account tab and then from the' + cr //
      + 'Account menu select "Year End Checklist". Complete' + cr //
      + 'all items on each list and check each box.' + cr //
      + cr //
      + 'Once complete then run end of year processing again.',
      mtError, [mbOK], 0);
    exit;
  end; // -----------------------------
  if not TradeLogFile.AllCheckListsComplete then begin
    mDlg('You must complete the end of year checklist for each account before' + cr //
      + 'you can run end of year processing!' + cr //
      + cr //
      + 'Please select each account tab and then from the Account menu select' + cr //
      + '"Year End Checklist". Complete all items on each list and check each box.' + cr //
      + cr //
      + 'Once complete then run end of year processing again.', mtError, [mbOK], 0);
    exit;
  end; // -----------------------------
  if Not Settings.MTMVersion and TradeLogFile.HasAccountType[atMTM] then begin
    mDlg('This file contains accounts that are Mark-to-Market.' + cr //
      + cr //
      + 'In order to utilize the MTM functions of TradeLog,' + cr //
      + 'you must upgrade to a MTM version of TradeLog.', mtWarning, [mbOK], 0);
    exit;
  end; // -----------------------------
  Msg := 'The following item(s) MUST be completed before running end of year processing:'
    + cr + cr;
  if TradeLogFile.HasAccountType[atCash]
  or TradeLogFile.HasAccountType[atIRA] then begin
    Msg := Msg //
      + '  For CASH and IRA accounts: ALL Current trades for January of the next tax' + CR //
      + '  year should be imported. This is necessary to see if you bought back any' + CR //
      + '  shares that you took a loss on in December.' + cr //
      + cr;
    Msg := Msg
      + 'If you have not completed the above requirement(s) then you MUST answer "NO"' + CR //
      + 'to this dialog and perform the necessary steps if you want end of year' + CR //
      + 'processing to perform correctly.' + cr //
      + cr //
      + 'Would you like to continue with end of year processing?';
    if mDlg(Msg, mtWarning, [mbYes, mbNo], 0) <> mrYes then exit;
  end;
  result := true; // made it this far, must be ok!
end;


procedure TLETY.DeleteNextYearTrades;
var
  i : integer;
  Trade : TTLTrade;
begin
  i := 0;
  try
  while i < TradeLogFile.Count do begin
    Trade := TradeLogFile.Trade[i];
    if ( (pos('FUT', Trade.typemult) = 1)
      or (TradeLogFile.FileHeader[Trade.Broker].MTM) )
    and (Trade.Date > strToDate('12/31/' + TaxYear, Settings.internalFmt)) then
      TradeLogFile.DeleteTrade (Trade, false)
      // false does not reset YE CheckList
    else
    //-------------
    if (Trade.Date > strToDate('01/31/' + NextTaxYear, Settings.internalFmt))
    then
      TradeLogFile.DeleteTrade (Trade, false)
    else
      inc (i);
  end; // while
  except
    //sm('DeleteNextYearTrades failed on Trade: ' + Trade.AsString);
    on E : Exception do begin
      if (1=0) then ShowMessage('DeleteNextYearTrades failed on Trade: ' + Trade.AsString);
   end;
  end;
end;


function TLETY.processCashAccount (IRA:boolean; NextYearTrades:TTradeList): boolean;
var
  SDate, EDate : TDate;
begin
  if not IRA then begin
    FilterInWashSales;
    SortByTickerForWS; //
    // Fake out the LoadTradeSUMGLWS routine to think that
    // the rptSubD1 report is running, so that Holding Date is adjusted.
    ReportStyle := rptSubD1;
  end;
  screen.Cursor := crHourglass;
  try
    if LoadTradesSumGL(0, 0, True) = false then exit (false);
    // ------------
    if not IRA then begin
      DoLT := True;
      DoST := True;
      SDate := EncodeDate(TradeLogFile.TaxYear, 1, 1);
      EDate := EncodeDate(TradeLogFile.TaxYear, 12, 31);
      // sm('Account Tab = ' + IntToStr(frmMain.TabAccounts.TabIndex) + CR +'CurrentBrokerID = ' + IntToStr(TradeLogFile.CurrentBrokerID) ); // 2015-02-27 MB
      LoadTradesSumGLWS(SDate, EDate);
      // Load these rules on a cash account so that it forces Short losses at end of year
      // to be shown as Open. This will force an inclusion of the Wash Sale Records for next
      // year, I Hope.
      // sm('Account Tab = ' + IntToStr(frmMain.TabAccounts.TabIndex) + CR +'CurrentBrokerID = ' + IntToStr(TradeLogFile.CurrentBrokerID) ); // 2015-02-27 MB
      LoadTradeSumAdditionalRules; // why did he do this???
      // sm('Account Tab = ' + IntToStr(frmMain.TabAccounts.TabIndex) + CR +'CurrentBrokerID = ' + IntToStr(TradeLogFile.CurrentBrokerID) ); // 2015-02-27 MB
      // NOTE: This changes TradeLogFile.CurrentBrokerID to point to the Cash Account!
      // showTrSumList;
      try
        CopyAWSAdjToNextYear(NextYearTrades);
        // 2014-04-30 - new simplified code
        CopyAShortLossTradesToNextYear(NextYearTrades);
      finally
        frmMain.FreeTrSumList;
      end;
    end;
    CopyCOpenPositionsToNextYear(NextYearTrades);
    ReportStyle := rptNone;
    result := True;
  finally
    screen.Cursor := crDefault;
  end;
end;


function TLETY.processMTMAccount(LastOpenTrNum:Integer; NextYearTrades:TTradeList): boolean;
begin
  result := True;
  // MTM processing is different from Standard Processing
  // 1. We need to close all positions in the current file and set the closing
  // price by adding a Closing record for each open position and setting the
  // price to the Market price as of 12/31 of the current Tax Year
  // 2. We need to reopen each previously closed position in the next year file
  // with the same closing price. This is all handled by ProcessYearEndDone.
  // It also creates the next year file. It assumes that there is only one header
  // record in the file, (ie not a multiBroker file) and therefore just works off
  // of Header zero.
  if EnterYearEndPrice(LastOpenTrNum, NextYearTrades) = false then exit(false);
  TradeLogFile.SortByTrNumber;
end;


function TLETY.EnterYearEndPrice(LastOpenTrNum:integer; NextYearTrades:TTradeList): boolean;
var
  i, x, RecIdx: integer;
  Amount, mult: double;
  clickedOK: boolean;
  cType: string;
  // NextYearFile: TTLFile;  // not used??
  PriceList: TPriceList;
  PriceRec: TPrice;
  Trade: TTLTrade;
  NextYrTrade: TTLTrade;
  Price: double;
  { List of BrokerID's that have Cash Account Futures processed,
    This is needed in order to MatchAndReorganize any cash accounts with Futures
    that were processed }
  FuturesProcessed: TList<integer>;
  dtEOY, dtBONY : TDate;
  // --------------------------------------------
  Procedure AddTradeToNextYearTrades;
  begin
    // add Year End MTM price to next year data file
    NextYrTrade := TTLTrade.Create(Trade);
    NextYrTrade.TradeNum := x;
    NextYrTrade.Date := dtBONY;
    NextYrTrade.time := formatTime('00:00');
    NextYrTrade.oc := 'O';
    NextYrTrade.Amount := -Amount;
    NextYearTrades.Add(NextYrTrade); // add the MTM re-open to next year
  end;
  // --------------------------------------------
begin
  EnteringEndYearPrice := True;
  result := false;
  x := 0;
  stopUpdate := false;
  LoadTradesSumTaxYear;
  FuturesProcessed := TList<integer>.Create;
  PriceList := TPriceList.Create;
  try
    dtEOY := xStrToDate('12/31/' + TaxYear, Settings.internalFmt);
    dtBONY := xStrToDate('01/01/' + NextTaxYear, Settings.internalFmt);
    // --------------------------------
    for i := LastOpenTrNum to high(TradesSum) do begin
      if (RndTo5(TradesSum[i].os) <> RndTo5(TradesSum[i].cs))
      and (TradesSum[i].od <> '')
      and (xStrToDate(TradesSum[i].od, Settings.UserFmt) <= dtEOY) then begin
        Application.ProcessMessages;
        if GetKeyState(VK_ESCAPE) and 128 = 128 then stopUpdate := True;
        if stopUpdate then begin
          frmMain.cxGrid1.SetFocus;
          break;
        end;
        if (POS('VTN-', TradesSum[i].prf) <> 1) then begin // 2019-08-14 MB - Skip VTN per Jason email
          Price := getYearEndMTMprice(TradesSum[i].tk, TradesSum[i].prf, false);
          // Create a list of prices.
          FillChar(PriceRec, SizeOf(PriceRec), 0);
          PriceRec.Ticker := TradesSum[i].tk + ' - ' + TradesSum[i].prf;
          PriceRec.Price := Price;
          PriceRec.i := i;
          PriceList.Add(PriceRec);
        end; // 2019-08-14 MB - end changes
      end;
    end; // for loop
    // --------------------------------
    if PriceList.Count > 0 then begin
      // If there are prices to show then filter the grid for the records in the PriceList.
      frmMain.cxGrid1TableView1.DataController.ClearSelection;
      frmMain.cxGrid1TableView1.DataController.Filter.Active := True;
      frmMain.cxGrid1TableView1.DataController.Filter.BeginUpdate;
      clearFilter;
      frmMain.cxGrid1TableView1.DataController.Filter.Root.BoolOperatorKind := fboOr;
      for i := 0 to PriceList.Count - 1 do begin
        frmMain.cxGrid1TableView1.DataController.Filter.Root.AddItem
          (frmMain.cxGrid1TableView1.Items[1], foEqual,
          TradesSum[PriceList[i].i].tr, IntToStr(TradesSum[PriceList[i].i].tr));
      end;
      frmMain.cxGrid1TableView1.DataController.Filter.EndUpdate;
      if frmMain.btnFilterEnable.down then
        frmMain.cxGrid1TableView1.OptionsCustomize.ColumnFiltering := false;
      dispProfit(True, 0, 0, 0, 0);
      // Present the user with all the prices for the tickers.
      if TdlgPriceList.Execute(PriceList) = mrOK then begin
        for i := 0 to PriceList.Count - 1 do begin
          cType := TradesSum[PriceList[i].i].prf;
          delete(cType, 1, pos('-', cType));
          if cType <> '' then
            mult := StrToFloat(cType, Settings.UserFmt)
          else
            mult := 1;
          Amount := (TradesSum[PriceList[i].i].os -
            TradesSum[PriceList[i].i].cs) * PriceList[i].Price * mult;
          if TradesSum[PriceList[i].i].ls = 'S' then Amount := -Amount;
          inc(x);
          Trade := TTLTrade.Create; // create an M record
          Trade.id := 0;
          Trade.TradeNum := TradesSum[PriceList[i].i].tr;
          Trade.Date := dtEOY;
          Trade.time := formatTime('23:59');
          Trade.oc := 'M';
          Trade.ls := Char(TradesSum[PriceList[i].i].ls[1]);
          Trade.Ticker := TradesSum[PriceList[i].i].tk;
          Trade.Shares := TradesSum[PriceList[i].i].os
            - TradesSum[PriceList[i].i].cs; // remaining open shares only
          Trade.Price := PriceList[i].Price; // user entered
          Trade.typemult := TradesSum[PriceList[i].i].prf;
          Trade.Commission := 0;
          Trade.Amount := Amount;
          Trade.Note := '';
          Trade.Matched := '';
          Trade.Broker := strToInt(TradesSum[PriceList[i].i].br);
          TradeLogFile.AddTrade(Trade); // add M rec to this year
          // add Year End MTM price to next year data file
          AddTradeToNextYearTrades;
        end; // for
        if FuturesProcessed.Count > 0 then begin
          TradeLogFile.MatchAndReorganizeAllAccounts;
          TradelogFile.SaveFile;
        end;
        // Since we changed the currentBrokerID from Zero we need to change it back to reset the file.
        TradeLogFile.CurrentBrokerID := 0;
      end
      else
        stopUpdate := True;
    end; // if Price
    // --------------------------------
    for i := 0 to frmMain.cxGrid1TableView1.datacontroller.FilteredRecordCount - 1 do begin
      RecIdx := frmMain.cxGrid1TableView1.datacontroller.FilteredRecordIndex[i];
      if (TradeLogFile[RecIdx].OC = 'M') // an MTM record
      and (TradeLogFile[RecIdx].Date = dtEOY) then begin
        Trade := TTLTrade.Create(TradeLogFile[RecIdx]);
        inc(x);
        AddTradeToNextYearTrades;
      end; // 2019-08-14 MB - end changes
    end;
  finally
    FreeAndNil(PriceList);
    FreeAndNil(FuturesProcessed);
    EnteringEndYearPrice := false;
  end;
  if stopUpdate then begin
    result := ReverseYearEnd(True);
    result := false; // ETY failed!
  end
  else
    result := True;
end;


// --------------------------------------------------------
//procedure TLETY.addTradesToNewFile(NextYearTrades:TTradeList);
//var
//  Trade: TTLTrade;
//begin
//  // add Trades to Newfile, free NextYearTrades, and create new instance of NextYearTrades
//  for Trade in NextYearTrades do begin
//    //sm(dateToStr(Trade.Date)+tab+Trade.OC+tab+floatToStr(Trade.Shares));
//    NewFile.AddTrade(Trade);
//  end;
//  NextYearTrades.Free;
//  NextYearTrades := TTradeList.Create;
////  for trade in NewFile.TradeList do
////    sm(dateToStr(Trade.Date)+tab+Trade.OC+tab+floatToStr(Trade.Shares));
//end;


procedure TLETY.CopyAShortLossTradesToNextYear(NextYearTrades: TTradeList);
var
  TrSum: PTTrSum;
  i, j: integer;
  ClosedSh, openSh: double;
  Trade: TTLTrade;
  TradeNum: TTLTradeNum;
  dtEOY : TDate;
begin
  // DE modified 2015-05-15
  if (TradeLogFile.TaxYear < 2012) then exit;
  dtEOY := xStrToDate('12/31/' + TaxYear, Settings.internalFmt);
  // showTrSumList;
  StatBar('Copying Short Trades, Closed at a Loss at Year End, To Next Year');
  for i := 0 to TrSumList.Count - 1 do begin
    TrSum := TrSumList[i];
    // open date has already been changed to next year settle date
    if (xStrToDate(TrSum.od, Settings.UserFmt) > dtEOY) // open is after end of year...
    and ((TrSum.cd <> '') // ...and trade has close date, which is...
    and (xStrToDate(TrSum.cd, Settings.UserFmt) <= dtEOY)) // ...before end of year
    and (TrSum.ls = 'S') and (RndTo5(TrSum.os - TrSum.cs) = 0) // SHORT trade, no open shares
    and (compareValue((TrSum.oa + TrSum.ca), 0, NEARZERO) < 0) // at a LOSS
    and (IsStockType(TrSum.prf)) then begin // and it's a "stock type"
      { OK this is a Short Sale, Opened in the current Tax Year, that
        closed at a loss, and it's settlement date falls in Next Tax Year,
        so we need to transfer this position even though it is closed.
        This is because it is not reported on 8949 in the current tax year
        and it must be reported on 8949 in next tax year
      }
      ClosedSh := TrSum.cs;
      openSh := TrSum.os;
      // sm(TrSum.od+'  '+TrSum.cd+cr+floatToStr(TrSum.oa+TrSum.ca)+cr+intToStr(TrSum.openid)+'  '+intToStr(TrSum.closeid));
      // Get the TradeNum list for the CurrentTrNum
      TradeNum := TradeLogFile.TradeNums.FindTradeNum(TrSum.tr);
      // DE modified 2015-05-15
      // get open records and add next year trades list            // DE modified 2015-05-15
      for j := 0 to TradeNum.Count - 1 do begin // DE modified 2015-05-15
        try
          if openSh <= 0 then break;
          if (TradeNum[j].id = TrSum.openid) then begin
            Trade := TTLTrade.Create (TradeNum[j]);
            // --------[ = ]-----------
            if (Trade.Shares = openSh) then begin
              // if (xStrToDate(TrSum.od, Settings.UserFmt) > dtEOY) then
              //   sm(floatToStr(trade.Shares)+cr+floatToStr(openSh));
              NextYearTrades.Add (Trade);
              break;
            end
            // --------[ > ]-----------
            else if (Trade.Shares > openSh) then begin
              Trade.Commission := Trade.Commission * openSh / Trade.Shares;
              Trade.Amount := Trade.Amount * openSh / Trade.Shares;
              Trade.Shares := openSh;
              NextYearTrades.Add (Trade);
              break;
            end
            // --------[ < ]-----------
            else if (Trade.Shares < openSh) then begin
              NextYearTrades.Add (Trade);
              openSh := openSh - Trade.Shares;
            end;
          end;
          if openSh <= 0 then break;
        finally
          //Trade.Free;   // Freeing this will not get all short loss trades copied over - why???
        end;
      end;
      // get close records and add next year trades list
      for j := 0 to TradeNum.Count - 1 do begin // DE modified 2015-05-15
        try
          if ClosedSh <= 0 then break;
          if (TradeNum[j].id = TrSum.closeid) then begin
            Trade := TTLTrade.Create (TradeNum[j]); // DE modified 2015-05-15
            // --------[ = ]-----------
            if (Trade.Shares = ClosedSh) then begin
              NextYearTrades.Add (Trade);
              break;
            end
            // --------[ > ]-----------
            else if (Trade.Shares > ClosedSh) then begin
              Trade.Commission := Trade.Commission * ClosedSh / Trade.Shares;
              Trade.Amount := Trade.Amount * ClosedSh / Trade.Shares;
              Trade.Shares := ClosedSh;
              NextYearTrades.Add (Trade);
              break;
            end
            // --------[ < ]-----------
            else if (Trade.Shares < ClosedSh) then begin
              NextYearTrades.Add (Trade);
              ClosedSh := ClosedSh - Trade.Shares;
            end;
          end;
          if ClosedSh <= 0 then break;
        finally
          //Trade.Free;
        end;
      end;
    end;
  end;
  //addTradesToNewFile(NextYearTrades);
end;


procedure TLETY.CopyAWSAdjToNextYear(NextYearTrades: TTradeList);
var
  i, iID: integer;
  wsDefer: PTTrSum;
  Trade: TTLTrade;
  TrSum: PTTrSum;
  dShContr, dMult: double;
  tMult: string;
begin
  StatBar('Copying Wash Sale Deferrals to Next Year');
    // get all ws deferrals from previous year
    // that are attached to year end open trades
    iID := 0;
    // sm('NextYearTrades.count = '+intToStr(NextYearTrades.count));
    if wsDeferrals then begin
      for i := 0 to wsDeferOpenList.Count - 1 do begin
        wsDefer := wsDeferOpenList[i];
        if (wsDefer.oa = 0) then continue;
        Trade := TTLTrade.Create; // must create a new instance for each record
        inc(iID);
        Trade.Amount := wsDefer.oa;
        Trade.id := iID;
        Trade.TradeNum := wsDefer.tr;
        if wsDefer.od = '' then
          Trade.Date := xStrToDate(wsDefer.cd, Settings.UserFmt)
        else
          Trade.Date := xStrToDate(wsDefer.od, Settings.UserFmt);
        Trade.oc := 'W';
        Trade.ls := Char(wsDefer.ls[1]);
        Trade.Ticker := wsDefer.tk;
        // ------------------------------------------------------------------
        // NOTE: wsDefer.os = open shares X multiplier, so therefore we must
        // divide by multiplier to get new "shares" - 2015-04-03 MB
        tMult := wsDefer.prf;
        delete(tMult, 1, pos('-', tMult));
        if length(tMult) > 0 then
          dShContr := wsDefer.os / StrToFloat(tMult)
        else
          dShContr := wsDefer.os;
        Trade.Shares := dShContr;
        // ------------------------------------------------------------------
        Trade.typemult := wsDefer.prf;
        Trade.Broker := strToInt(wsDefer.br);
        Trade.Matched := wsDefer.m;
        if length(wsDefer.wsd) > 0 then
          Trade.WSHoldingDate := xStrToDate(wsDefer.wsd, Settings.UserFmt);
        NextYearTrades.Add(Trade);
        // sm(intToStr(i)+tab+trade.ticker);
      end; // for i
      for i := 0 to wsDeferOpenList.Count - 1 do
        Dispose(wsDeferOpenList[i]);
      wsDeferOpenList.Free;
    end; // if wsDeferrals
    /// get all current tax year wash sale deferrals
    for i := 0 to TrSumList.Count - 1 do begin
      TrSum := TrSumList[i];
      // get all ws triggered by Jan trades
      // and all ws attached to year end open trades
      if TrSum.ny and (TrSum.ws = wsThisYr) then begin
        if rndTo2(TrSum.oa) = 0 then begin // < $0.01
          continue;
        end;
        Trade := TTLTrade.Create;  // must create a new instance for each record
        inc(iID);
        Trade.Amount := TrSum.oa;
        Trade.id := iID;
        Trade.TradeNum := TrSum.tr;
        if TrSum.od = '' then
          Trade.Date := xStrToDate(TrSum.cd, Settings.UserFmt)
        else
          Trade.Date := xStrToDate(TrSum.od, Settings.UserFmt);
        Trade.oc := 'W';
        Trade.ls := Char(TrSum.ls[1]);
        Trade.Ticker := TrSum.tk;
        Trade.Shares := rndTo5(TrSum.os);
        Trade.typemult := TrSum.prf;
        Trade.Broker := strToInt(TrSum.br);
        Trade.Matched := TrSum.m;
        if length(TrSum.wsd) > 0 then
          Trade.WSHoldingDate := xStrToDate(TrSum.wsd, Settings.UserFmt);
        // sm(TrSum.od+tab+TrSum.cd+cr+TrSum.tk+cr+floatToStr(TrSum.oa)+cr+floatToStr(TrSum.ca));
        NextYearTrades.Add(Trade);
      end;
    end;
    //addTradesToNewFile(NextYearTrades);
end;


procedure TLETY.CopyBJanTradesToNextYearTradesList(NextYearTrades: TTradeList);
var
  i: integer;
  RecIdx: integer;
  Trade: TTLTrade;
begin
  StatBar('Copying January Trades to Next Year Data File');
    // Copy next years trades from Trades to NextYearTrades
    for i := 0 to TradeLogFile.TradeList.Count - 1 do begin
      if ( (TradeLogFile.TradeList[i].oc = 'W')
      and (TradeLogFile.TradeList[i].Amount > 0)
      and (TradeLogFile.TradeList[i].Date >= xStrToDate('01/01/' + NextTaxYear, Settings.internalFmt))
      )
      or (TradeLogFile.TradeList[i].Date < xStrToDate('01/01/' + NextTaxYear, Settings.internalFmt))
      or (TradeLogFile.TradeList[i].Shares = 0) then
        continue;
      Trade := TTLTrade.Create(TradeLogFile.TradeList[i]);
      NextYearTrades.Add(Trade);
    end;
  //addTradesToNewFile(NextYearTrades);
end;


procedure TLETY.CopyCOpenPositionsToNextYear(NextYearTrades : TTradeList);
var
  i, j, RecIdx : Integer;
  openSh : double;
  Trade : TTLTrade;
  SettleDate, dt1, dtEOY : TDate;
  Y, m, D : word;
begin
  StatBar('Copying Open Positions to Next Year');
  // get one TrSum record with total shares open and closed for each ticker
  // NOTE: Should include all O/M combinations, too!
  LoadTradesSumTaxYear;
  dtEOY := xStrToDate('12/31/' + TaxYear, Settings.internalFmt);
  for i := high(TradesSum) downto 1 do begin
    // if TradesSum[I].od = '' then sm(TradesSum[I].tk+tab+TradesSum[I].cd);
    // IF this is an open position AND is in the current tax year
    // AND finally is not a future (except in IRAs, since futures are processed as MTM),
    // THEN we need to move this open position to next year
    if (SuperUser or Developer) and (TradesSum[i].od = '') then begin
      sm('Error matching ticker: ' + TradesSum[i].tk + cr //
        + 'Aborting ETY process (SuperUser only)');
      exit;
    end;
    // ------------------------------------------
    if (TradesSum[i].os <> TradesSum[i].cs) //
    and (xStrToDate(TradesSum[i].od, Settings.UserFmt) <= dtEOY) //
    and (((pos('FUT', TradesSum[i].prf) = 1) //
      and (TradeLogFile.FileHeader[strToInt(TradesSum[i].br)].IRA)) //
    or (pos('FUT', TradesSum[i].prf) = 0)) //
    then begin
      // total shares open for each ticker
      openSh := RndTo5(TradesSum[i].os - TradesSum[i].cs);
      if abs(rndTo5(openSh)) < NEARZERO // (StrFmtToFloat('%1.5f', [openSh], Settings.UserFmt) = 0)
      then continue;
      // loop backwards thru trades to gather open position records
      for j := frmMain.cxGrid1TableView1.DataController.FilteredRecordCount - 1 downto 0 do begin
        RecIdx := frmMain.cxGrid1TableView1.DataController.FilteredRecordIndex[j];
          // find open position
        if (TradeLogFile[RecIdx].TradeNum = TradesSum[i].tr) //
        and (TradeLogFile[RecIdx].Ticker = TradesSum[i].tk) //
        and (TradeLogFile[RecIdx].oc = 'O') //
        and (TradeLogFile[RecIdx].Date <= dtEOY) then begin
          if openSh = 0 then
            break;
          /////// BIG TIME MEMORY LEAK //////
          Trade := TTLTrade.Create(TradeLogFile.Trade[RecIdx]);
          ///////////////////////////////////
          if (Trade.Shares = openSh) then begin
            TradesSum[i].os := TradesSum[i].os - openSh;
            openSh := 0; // os-cs;
            NextYearTrades.Add(Trade);
            break; // Break out of TradeLogFile Loop since there are no more shares
          end
          // Open Shares for this trade are greater than open shares
          // so this satisfies the open shares but needs to be split,
          // Open Shares to next year, Closed Shares to current Year.
          else if (Trade.Shares > openSh) then begin
            // split the commission to next year
            Trade.Commission := openSh / Trade.Shares * Trade.Commission;
            // split the Amount to next year
            Trade.Amount := openSh / Trade.Shares * Trade.Amount;
            // Amount is calculated except for wash sales so we need to calc these.
            if Trade.oc = 'W' then begin
              if Trade.ls = 'L' then
                Trade.Amount := -TradeLogFile[RecIdx].Shares * Trade.Price
              else
                Trade.Amount := TradeLogFile[RecIdx].Shares * Trade.Price;
            end;
            Trade.Shares := openSh;
            TradesSum[i].os := TradesSum[i].os - openSh;
            openSh := 0;
            NextYearTrades.Add(Trade);
            break;
          end
          // If Shares is less than open shares then just move this over to the next year file.
          else if (Trade.Shares < openSh) then begin
            TradesSum[i].os := TradesSum[i].os - TradeLogFile[RecIdx].Shares;
            openSh := RndTo5(TradesSum[i].os - TradesSum[i].cs);
            NextYearTrades.Add(Trade);
          end;
        end; // if find open position
      end; // for j :=
    end;
    // ------------------------------------------
  end;
  // addTradesToNewFile(NextYearTrades);
end;


function TLETY.CopyDnextYearTradesToNextYearFile(NextYearTrades: TTradeList): boolean;
var
  i, j: integer;
  NewHeader: TTLFileHeader;
  FileExistsError: String;
  sEmailToUse : string;
  Trade: TTLTrade;
  myCanETY : integer;
begin
  FileExistsError := '';
  try
    // add trades to NewFile
    for Trade in NextYearTrades do
      NewFile.AddTrade(Trade);
    // if more than 1 record then rematch
    if NewFile.Count > 1 then begin
      NewFile.MatchAndReorganizeAllAccounts;
    end;
    // ----------------------
    try
      if ProVer and (ProHeader.regCode <> '') then begin
        sRegCodeToUse := ProHeader.regCode;
        sEmailToUse := ProHeader.email;
      end
      else begin
        sRegCodeToUse := ProHeader.regCodeAcct;
        sEmailToUse := v2UserEmail;
        // why does Pro User ever have a file with no user RegCode?
      end;
    except
      mDlg('Unable to save Taxpayer ID via Internet.', mtError, [mbOK], 0);
      exit(false);
    end;
    myCanETY := ProHeader.canETY; // preserve value of current year file
    // 2017-03-31 MB - CanETY always false for new file!
    ProHeader.canETY := 0; // since we are not using a taxfile for this
    if bSaveNewFile then // 2020-01-08 MB
      NewFile.SaveFile(True);
    ProHeader.CanETY := myCanETY; // restore it.
    clearFilter;
    SaveLastFileName(NewFile.FileName);
    result := True;
  finally
    FreeAndNil(NewFile);
  end;
end;


procedure myFileCopy(const FromFile, ToFile: string);
var
  FromF, ToF: file;
  NumRead, NumWritten: integer;
  Buf: array [1 .. 2048] of Char;
begin
  AssignFile(FromF, FromFile);
  Reset(FromF, 1); { Record size = 1 }
  AssignFile(ToF, ToFile); { Open output file }
  Rewrite(ToF, 1); { Record size = 1 }
  repeat
    BlockRead(FromF, Buf, SizeOf(Buf), NumRead);
    BlockWrite(ToF, Buf, NumRead, NumWritten);
  until (NumRead = 0) or (NumWritten <> NumRead);
  CloseFile(FromF);
  CloseFile(ToF);
end;


// **********************************************
function TLETY.ReverseYearEnd(Silent: boolean = false): boolean;
Var
  TYFile, nextYr, sFileName, sTmp, s: string;
  // ------------------------
  procedure DeleteMrecs;
  var
    i : integer;
    Trade : TTLTrade;
    dtEOY: TDate;
  begin
    i := 0;
    dtEOY := strToDate('12/31/' + TaxYear, Settings.internalFmt);
    try
    while i < TradeLogFile.Count do begin
      Trade := TradeLogFile.Trade[i];
      if (Trade.OC = 'M') and (Trade.Date = dtEOY) then
        TradeLogFile.DeleteTrade(Trade, false)
        // false does not reset YE CheckList
      else
        inc (i);
    end; // while
    except
      on E : Exception do begin
        if (1=0) then ShowMessage('DeleteNextYearTrades failed on Trade: ' + Trade.AsString);
     end;
    end;
  end;
  // ------------------------
begin
  if Not Silent then begin
    if mDlg('Are you sure you want to reverse Year End Entries?',
      mtConfirmation, [mbYes, mbNo], 0) <> mrYes
    then exit(false);
  end;
  // ------------------------------------------------------
  // ReverseETY unlocks the file and (optionally) moves the
  // M recs (MTM accounts) to a data file for safe keeping.
  // ------------------------------------------------------
  screen.Cursor := crHourglass;
  // ----------------------------------
  // 2017-04-02 MB - NextYear files are NOT registered
  // so no need to remove nextyear taxfile from server!
  // but do need to log it, though...
  sFileName := RemoveFileExtension(TrFileName); //
  //
  v2WriteTaxFileLog(v2ClientToken, FileCodeToUse, 'Write', 'Reverse ETY', sFileName, '', '');
  // ----------------------------------
  // don't enable edit menus if taxidVer and file not converted
  if taxidVer and (iVer < 0) then disableEdits else enableEdits; // 2016-07-11 MB
  ProHeader.canETY := 1; // if ETY was done before, should be able to ETY again
  dispProfit(True, 0, 0, 0, 0);
  TradeLogFile.YearEndDone := false;
  frmMain.bbFile_ReverseEndYear.Enabled := false;
  // ----------------------------------
  // only ask about MTM if (1) not silent, and (2) has MTM - 2016-11-23 MB
  if Not Silent and (TradeLogFile.HasAccountType[atMTM]) then begin
    if mDlg('Do you want to keep MTM Year End prices?',
      mtConfirmation, [mbYes, mbNo], 0) <> mrYes
    then DeleteMrecs;
  end;
  // ----------------------------------
  // Undo(false, false); // doesn't do anything - btnUndo is disabled!
  // save new or changed file and open
  TYFile := TradeLogFile.FileName;
  TradeLogFile.SaveFileAs(TYFile, Settings.DataDir, TradeLogFile.TaxYear, true);
  frmMain.CloseFileIfAny;
  OpenTradeLogFile(Settings.DataDir + '\' + TYFile);
  screen.Cursor := crDefault;
  StatBar('off');
  result := true;
end;


end.
