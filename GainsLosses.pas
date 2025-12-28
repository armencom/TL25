unit GainsLosses;


interface

uses
  Windows, Forms, Classes, Generics.Collections, Generics.Defaults, Math, //
  TLCommonLib, TLTradeSummary;

// latest versions of funtions for calculating gains/losses and wash sales
function calcGains(StartDate, EndDate : TDate; LoadWSDeferrals : Boolean) : Boolean;
procedure calcWSdefer;
procedure calcWashSales(StartDate, EndDate : TDateTime; Running8949, WSBetweenSL : Boolean);

procedure SortByTickerForWS;
procedure LoadTradesSum(StartDate, EndDate : string);

procedure LoadTradesSumTaxYear;

// creates a list of closed trades for P&L, each record has open and closed dates and amounts
function LoadTradesSumGL(StartDate, EndDate : TDate; LoadWSDeferrals : Boolean) : Boolean;

// adds in deferred wash sales - W recs
procedure LoadTradesSumGLdefer;

// main procedure  to calculate wash sales and adjust cost basis of trades that triggered wash sale
procedure LoadTradesSumGLWS(StartDate, EndDate : TDateTime; Running8949 : Boolean = false;
  WSBetweenSL : Boolean = True);

// only used for TurboTax and TaxAct exports prior to 2011
// where trades must be split up to match wash sale shares
// ie: loss trade of 100 sh, wash sale of 60 sh - must split 100 sh into 60 and 40
procedure LoadTradesSumGLWSunequal;

// After LoadTradesSumGLWS is done for some reports we need to change
// Short Sale Loss Dates and Wash Sale Holding Period Opening Dates
function LoadTradeSumAdditionalRules : Double;

procedure loadWSdeferred(lt : string; amt : Double);
procedure showTrSumList(sTitle : string = 'DEBUG_MODE');

var
  // Used in many places, will be removed eventually but not for now
  TrSumList : TList;
  TradeSummaryList, lstWrecs, lstOrecs : TTLTradeSummaryList;
  WSDeferOpenTradeSummaryList : TTLTradeSummaryList;


implementation

uses
  Main, funcProc, StrUtils, SysUtils, DateUtils, RecordClasses, Reports, TLFile, //
  TLSettings, TLDateUtils, GlobalVariables, // 2021-01-28 MB - removed TLCompatibility
  Controls,
//rj   CodeSiteLogging,
  TLLogging, cxGridCustomTableView, dxCore, clipBrd;

const
  CODE_SITE_CATEGORY = 'GainsLosses';

var
  newSort, ToddSort : Boolean; // flag for faster looping in loadTradesSumGLWS


procedure SortByTickerForWS;
var
  i : integer;
begin
  // NOTE: newSort uses TrSumList as-is sorted by Ticker and LoadTradesSumGLWS_NEW
  // ToddSort uses TLTradeSummaryList and LoadTradesSumGL_NEW
  // sorted by TTLTradeSummaryList.SortByTicker_AcctType_StockOption_OpenDate
  // ****SortByTicker_AcctType_StockOption_OpenDate does not work right!!!****
  // only do newSort on 2013 files and greater
  if TradeLogFile.TaxYear > 2012 then begin
    newSort := True; // false reverts back to ver 12.2.0.5 wash sales
  end;
  // below is the standard grid sort by ticker
  // it does not put IRA accounts at the bottom for each ticker
  // which is why we need newSort when calculating wash sales
  SortBy := 'tick';
  screen.cursor := crHourglass;
  StatBar('Sorting Grid by Ticker');
  with frmMain.cxGrid1TableView1 do begin
    datacontroller.BeginFullUpdate;
    for i := 0 to 17 do
      Items[i].sortorder := soNone; // clear existing sorts
    SortBy := 'ticker';
    if newSort then begin
      // if we put IRA trades at end of stocks and end of options, then they might get missed
      Items[6].sortorder := soAscending; // ticker
    end
    else begin
      Items[6].sortorder := soAscending; // ticker
      Items[21].sortorder := soAscending; // broker account type
    end;
    datacontroller.EndFullUpdate;
    datacontroller.gotoFirst;
  end;
  StatBar('off');
  screen.Cursor := crDefault;
  frmMain.cxGrid1.setfocus;
end;


procedure TransferToOldTRSumList(pTradeSummaryList : TTLTradeSummaryList; pTrSumList : TList);
var
  TradeSummary : TTLTradeSummary;
  T : PTTrSum;
begin
  for TradeSummary in pTradeSummaryList do begin
    New(T);
    FillChar(T^, SizeOf(T^), 0);
    T.tr := TradeSummary.TradeNum;
    T.tk := TradeSummary.Ticker;
    T.ls := TradeSummary.ls;
    T.prf := TradeSummary.TypeMult;
    T.cm := TradeSummary.Commission;
    T.od := DateToStr(TradeSummary.OpenDate, Settings.UserFmt);
    // 2014-01-03 fix for TDate cannot be blank or null
    if TradeSummary.CloseDate = 0 then
      T.cd := ''
    else
      T.cd := DateToStr(TradeSummary.CloseDate, Settings.UserFmt);
    if TradeSummary.WashSaleHoldingDate = 0 then
      T.wsd := ''
    else
      T.wsd := DateToStr(TradeSummary.WashSaleHoldingDate, Settings.UserFmt);
    T.os := TradeSummary.OpenedShares;
    T.cs := TradeSummary.ClosedShares;
    T.oa := TradeSummary.OpenAmount;
    T.ca := TradeSummary.CloseAmount;
    T.wsh := TradeSummary.WashSaleShares;
    T.ws := integer(TradeSummary.WashSaleType);
    T.pr := TradeSummary.Price;
    T.ActualPL := TradeSummary.ActualPL;
    T.lt := TradeSummary.lt;
    T.ny := TradeSummary.NextYear;
    T.m := TradeSummary.Matched;
    T.br := InttoStr(TradeSummary.BrokerID);
    T.op := TradeSummary.Open;
    T.abc := TradeSummary.ABCCode;
    T.code := TradeSummary.code; // 2022-04-01 MB
    T.adjG := TradeSummary.AdjustmentG;
    T.id := TradeSummary.UniqueId;
    T.wstriggerid := TradeSummary.wstriggerid;
    T.openid := TradeSummary.openid;
    T.closeid := TradeSummary.closeid;
    pTrSumList.Add(T);
  end;
end;


procedure showTrSumList(sTitle : string = 'DEBUG_MODE');
var
  T : string;
  i : integer;
  TrSumx : PTTrSum;
begin
  if not assigned(TrSumList) then exit; // can't do this
  msgTxt := 'TrNum:' + tab + 'ticker:' + tab + 'od:' + tab + 'cd:' + tab //
    + 'os:' + tab + 'cs:' + tab + 'oa:' + tab + 'ca:' + tab + 'P&L:' + tab //
    + 'ws:' + tab + 'wsh' + tab + 'wstriggerid' + tab + 'prf' + tab + 'opID' + tab //
    + 'clID' + tab + 'brID' + tab + 'adj' + CRLF;
  // ------------------------
  for i := 0 to TrSumList.Count - 1 do begin
    TrSumx := TrSumList[i];
    if TrSumx.cd = '' then TrSumx.cd := '          ';
    msgTxt := msgTxt + InttoStr(TrSumx.tr) + tab + copy(TrSumx.tk, 1, 25) + tab //
      + TrSumx.od + tab + TrSumx.cd + tab //
      + FloatToStr(TrSumx.os, Settings.UserFmt) + tab //
      + FloatToStr(TrSumx.cs, Settings.UserFmt) + tab //
      + Format('%1.2f', [TrSumx.oa], Settings.UserFmt) + tab //
      + Format('%1.2f', [TrSumx.ca], Settings.UserFmt) + tab //
      + Format('%1.2f', [TrSumx.oa + TrSumx.ca], Settings.UserFmt) + tab //
      + InttoStr(TrSumx.ws) + tab + FloatToStr(TrSumx.wsh) + tab //
      + InttoStr(TrSumx.wstriggerid) + tab + TrSumx.prf + tab //
      + InttoStr(TrSumx.openid) + tab + InttoStr(TrSumx.closeid) + tab //
      + TrSumx.br + tab + TrSumx.abc+TrSumx.code + CRLF;
    if (i = TrSumList.Count - 1) and (i > 0) then begin
      try
        clipBoard.AsText := msgTxt;
        sm(sTitle + ' count: ' + InttoStr(TrSumList.Count) + cr //
          + copy(msgTxt, 1, 1000));
      finally
        clipBoard.Clear;
      end;
    end; // if
    if TrSumx.cd = '          ' then TrSumx.cd := '';
  end;
  msgTxt := '';
end;


procedure loadWSdeferList(var DeferralArray : TTDeferralsReportArray; T, tk : string; oa : Double);
// loads ws deferral arrays
var
  i, c, tkPos, crPos : integer;
  myList, amtStr : string;
  found : Boolean;
begin
  try
    found := false;
    c := high(DeferralArray);
    oa := rndTo2(oa);
    // check if list is empty
    if c = -1 then begin
      // sm('LIST EMPTY');
      SetLength(DeferralArray, 1);
      if T = 'o' then begin
        DeferralArray[0].OpenDesc := tk;
        DeferralArray[0].OpenAmt := oa;
      end
      else if T = 'j' then begin
        DeferralArray[0].JanDesc := tk;
        DeferralArray[0].JanAmt := oa;
      end;
      exit;
    end
    else
      for i := 0 to c do begin
        // check if tk is found in string list
        if (DeferralArray[i].OpenDesc = tk) or (DeferralArray[i].JanDesc = tk) then begin
          found := True;
          if T = 'o' then begin
            DeferralArray[i].OpenDesc := tk;
            // update amount
            DeferralArray[i].OpenAmt := DeferralArray[i].OpenAmt + oa;
          end
          else if T = 'j' then begin
            DeferralArray[i].JanDesc := tk;
            // update amount
            DeferralArray[i].JanAmt := DeferralArray[i].JanAmt + oa;
          end;
          break;
        end;
      end;
    // if tk not found add new array entry
    if not found then begin
      if T = 'o' then begin
        inc(c);
        SetLength(DeferralArray, c + 1);
        DeferralArray[c].OpenDesc := tk;
        DeferralArray[c].OpenAmt := oa;
      end
      else if T = 'j' then begin
        inc(c);
        SetLength(DeferralArray, c + 1);
        DeferralArray[c].JanDesc := tk;
        DeferralArray[c].JanAmt := oa;
      end;
    end;
  finally
    // loadWSdeferList
  end;
end;


//procedure loadWSdeferListEx(list, tk : string; oa : Double);
//var
//  i, tkPos, crPos : integer;
//  myList, amtStr, s : string;
//  amount : Double;
//begin
//  // updated 2010-01-14
//  if list = 'ol' then
//    myList := wsOpenL
//  else if list = 'os' then
//    myList := wsOpenS
//  else if list = 'jl' then
//    myList := wsJanL
//  else if list = 'js' then
//    myList := wsJanS;
//  // check if tk is found in string list
//  tkPos := Pos(cr + tk + ':', myList);
//  // if tk not found, add "tk:amount" to the end of the string
//  if tkPos < 1 then begin
//    amtStr := Format('%8.2f', [oa], Settings.InternalFmt);
//    myList := myList + cr + tk + ': ' + amtStr;
//    // if found change amount
//  end
//  else begin
//    // get next crPos
//    crPos := posex(cr, myList, tkPos + 1);
//    // sm('crPos: '+inttostr(crPos));
//    if crPos < 1 then crPos := Length(myList);
//    // get amount
//    amtStr := Trim(MidStr(myList, tkPos, crPos));
//    tkPos := Pos(':', amtStr);
//    amtStr := MidStr(amtStr, tkPos, Length(amtStr));
//    s := '';
//    for i := 1 to Length(amtStr) do begin
//      if (IsInt(copy(amtStr, i, 1)) or (copy(amtStr, i, 1) = '.')) then
//        s := s + copy(amtStr, i, 1);
//    end;
//    amtStr := s;
//    // add ws amount to amt
//    amount := StrToFloat(amtStr, Settings.InternalFmt) + oa;
//    amtStr := FloatToStr(amount, Settings.InternalFmt);
//    // get pos of ":"
//    tkPos := posex(':', myList, tkPos + 1);
//    myList := LeftStr(myList, tkPos) + '  ' + amtStr + MidStr(myList, crPos, Length(myList));
//  end;
//  if list = 'ol' then
//    wsOpenL := myList
//  else if list = 'os' then
//    wsOpenS := myList
//  else if list = 'jl' then
//    wsJanL := myList
//  else if list = 'js' then
//    wsJanS := myList;
//end;


procedure LoadIRADeferralDetails(TrSum, WSum : PTTrSum);
var
  OpenDeferral : TSTOpenDeferral;
  mult : Double;
begin
  // If  same ticker,
  //     same LS
  //     same account
  // and Loss Date is within 30 Days
  // then just update shares and amount.
  // ----------------------------------
  if (TradeLogFile.FileHeader[StrToInt(WSum.br)].Ira) //
  and ((xStrToDate(TrSum.cd, Settings.UserFmt) > (Date - 30))) then begin
    // create loss trade
    OpenDeferral := TSTOpenDeferral.Create;
    // 2014-04-11 changed TrSum.od to WSum.od so loss date is loss datea and not date of IRA repurchase
    OpenDeferral.DateOpen := xStrToDate(TrSum.cd, Settings.UserFmt);
    OpenDeferral.Ticker := TrSum.tk;
    // test for WS Stock to Option
    if (Pos('OPT', TrSum.prf) = 0) and (Pos('OPT', WSum.prf) = 1) then
      mult := getMult(WSum.prf)
    else
      mult := 1;
    OpenDeferral.Shares := WSum.os * mult;
    OpenDeferral.amount := WSum.oa;
    OpenDeferral.Account := TradeLogFile.FileHeader[StrToInt(TrSum.br)].AccountName;
    OpenDeferral.ls := TrSum.ls;
    OpenDeferral.DateOfLoss := xStrToDate(TrSum.cd, Settings.UserFmt);
    IRADeferralDetails.Add(OpenDeferral);
  end;
end;


procedure LoadNewTradesDeferralDetails(TrSum, WSum : PTTrSum);
var
  OpenDeferral : TSTOpenDeferral;
  ws, amt, mult, mt, ts : Double;
  cDate : TDate;
begin
  // If  same ticker,
  //     same LS
  //     same account
  // and Loss Date within 30 Days
  // then just update shares and amount.
  // ----------------------------------
  // 2014-01-07 we already know this trade is a loss,
  // so this check is not needed and does not work for short sales!
  // if (RndTo5(TrSum.oa - TrSum.ca) < 0)
  cDate := xStrToDate(TrSum.cd, Settings.UserFmt); // close date for trade
  if (cDate > (Date - 31)) // closed in the last 30 days
  then begin
    // test for WS Stock to Option
    if (WSum <> nil) //
    and (Pos('OPT', TrSum.prf) = 0) // TrSum is a stock
    and (Pos('OPT', WSum.prf) = 1) // WSum is an option
    then
      mult := getMult(WSum.prf)
    else
      mult := 1;
    ws := 0;
    amt := 0;
    if (WSum <> nil) then begin
      ws := WSum.os * mult; // convert contracts to shares
      amt := WSum.oa;
    end;
    OpenDeferral := TSTOpenDeferral.Create;
    OpenDeferral.DateOpen := xStrToDate(TrSum.od, Settings.UserFmt);
    OpenDeferral.Ticker := TrSum.tk;
    // 2020-06-26 MB - 4 cases: STK/STK, OPT/OPT, STK/OPT, OPT/STK
    if ws = 0 then begin // nothing to subtract
      OpenDeferral.Shares := TrSum.os;
    end
    else begin
      mt := getMult(TrSum.prf);
      if mt = 0 then mt := 1;
      if (mt = getMult(WSum.prf)) then begin // same units
//        if (mt <> mult) then sm('not equal');
        OpenDeferral.Shares := TrSum.os - ws;
      end // test for WS Option to Stock
      else begin // convert both to shares
        ts := (TrSum.os * mt) - ws; // convert contracts to shares and subtract ws shares
        OpenDeferral.Shares := ts/mt;
      end;
    end; // if ws <> 0
    OpenDeferral.amount := RndTo5(TrSum.ca + TrSum.oa - amt);
    // note: ca is positive, oa is negative
    OpenDeferral.Account := TradeLogFile.FileHeader[StrToInt(TrSum.br)].AccountName;
    OpenDeferral.ls := TrSum.ls;
    OpenDeferral.DateOfLoss := cDate;
    NewTradesDeferralDetails.Add(OpenDeferral);
  end;
end;


procedure LoadSTDeferralDetails(WSum : PTTrSum);
var
  OpenDeferral : TSTOpenDeferral;
begin
  if StDeferralDetails = nil then exit;
  for OpenDeferral in StDeferralDetails do begin
    { If same ticker, same LS and same account then just update shares and amount. }
    if (OpenDeferral.Ticker = WSum.tk) //
    and (OpenDeferral.Account = TradeLogFile.FileHeader[StrToInt(WSum.br)].AccountName) //
    and (OpenDeferral.ls = WSum.ls) then begin
      OpenDeferral.Shares := OpenDeferral.Shares + WSum.os;
      OpenDeferral.amount := OpenDeferral.amount + WSum.oa;
      OpenDeferral.DateOpen := xStrToDate(WSum.od, Settings.UserFmt);
      OpenDeferral.Account := TradeLogFile.FileHeader[StrToInt(WSum.br)].AccountName;
      exit;
    end;
  end;
  // If we got here then either this is first rec or we did not find the ticker so create a new record.
  OpenDeferral := TSTOpenDeferral.Create;
  OpenDeferral.DateOpen := xStrToDate(WSum.od, Settings.UserFmt);
  OpenDeferral.Ticker := WSum.tk;
  OpenDeferral.Shares := WSum.os;
  OpenDeferral.amount := WSum.oa;
  OpenDeferral.Account := TradeLogFile.FileHeader[StrToInt(WSum.br)].AccountName;
  OpenDeferral.ls := WSum.ls;
  StDeferralDetails.Add(OpenDeferral);
end;


procedure LoadTradesSumTaxYear;
var
  StartDate, EndDate : string;
begin
  StartDate := convertInternalDateStrToUser('01/01/1900');
  EndDate := convertInternalDateStrToUser('12/31/' + TaxYear);
  LoadTradesSum(StartDate, EndDate);
end;


procedure LoadTradesSum(StartDate, EndDate : string);
var
  RecIdx, i : integer;
  Odate, Cdate : string;
  dt1, dt2 : TDate;
  TradesSumCount : integer;
  L : TList<integer>;
begin
  // sm('LoadTradesSum');
  TradesSumCount := 0;
  Odate := '';
  Cdate := '';
  if StartDate = '' then
    StartDate := convertInternalDateStrToUser('01/01/1900');
  if EndDate = '' then EndDate := convertInternalDateStrToUser('12/31/2099');
  dt1 := xStrToDate(StartDate, Settings.UserFmt);
  dt2 := xStrToDate(EndDate, Settings.UserFmt);
  TradesSum := nil;
  SetLength(TradesSum, TradesSumCount + 1);
  for i := 0 to frmMain.cxGrid1TableView1.datacontroller.FilteredRecordCount - 1 do begin
    RecIdx := frmMain.cxGrid1TableView1.datacontroller.FilteredRecordIndex[i];
    // look up the filtered record index once per loop (faster, easier to debug)
    if (TradeLogFile[RecIdx].OC = 'C') or (TradeLogFile[RecIdx].OC = 'M') then begin
      // if trade closed before start date or after end date, then skip
      if (TradeLogFile[RecIdx].Date < dt1) then begin
        continue;
      end;
      if (TradeLogFile[RecIdx].Date > dt2) then begin
        continue;
      end;
    end
    else if (TradeLogFile[RecIdx].OC = 'O') then begin
      // if trade opened after end date, then skip
      if (TradeLogFile[RecIdx].Date > dt2) then begin
        continue;
      end;
    end;
    if (TradesSumCount = 0) //
    or ((TradesSumCount > 0) //
    and (TradesSum[TradesSumCount].tr <> TradeLogFile[RecIdx].TradeNum)) //
    then begin
      inc(TradesSumCount);
      SetLength(TradesSum, TradesSumCount + 1);
      FillChar(TradesSum[TradesSumCount], SizeOf(TradesSum[TradesSumCount]), 0);
    end;
    TradesSum[TradesSumCount].tr := TradeLogFile[RecIdx].TradeNum;
    TradesSum[TradesSumCount].tk := TradeLogFile[RecIdx].Ticker;
    TradesSum[TradesSumCount].ls := TradeLogFile[RecIdx].ls;
    TradesSum[TradesSumCount].prf := uppercase(TradeLogFile[RecIdx].TypeMult);
    TradesSum[TradesSumCount].opTk := TradeLogFile[RecIdx].OptionTicker;
    TradesSum[TradesSumCount].br := InttoStr(TradeLogFile[RecIdx].Broker);
    Odate := TradesSum[TradesSumCount].od;
    Cdate := TradesSum[TradesSumCount].cd;
    TradesSum[TradesSumCount].cm := TradesSum[TradesSumCount].cm + TradeLogFile[RecIdx].Commission;
    if (TradeLogFile[RecIdx].OC = 'O') then begin
      TradesSum[TradesSumCount].os := TradesSum[TradesSumCount].os + TradeLogFile[RecIdx].Shares;
      TradesSum[TradesSumCount].oa := TradesSum[TradesSumCount].oa + TradeLogFile[RecIdx].amount;
      if (Odate = '') //
      or (TradeLogFile[RecIdx].Date < xStrToDate(Odate, Settings.UserFmt)) then
        TradesSum[TradesSumCount].od := DateToStr(TradeLogFile[RecIdx].Date, Settings.UserFmt);
    end
    else if (TradeLogFile[RecIdx].OC = 'C') or (TradeLogFile[RecIdx].OC = 'M') then begin
      TradesSum[TradesSumCount].cs := TradesSum[TradesSumCount].cs + TradeLogFile[RecIdx].Shares;
      TradesSum[TradesSumCount].ca := TradesSum[TradesSumCount].ca + TradeLogFile[RecIdx].amount;
      if (Cdate = '') then
        TradesSum[TradesSumCount].cd := DateToStr(TradeLogFile[RecIdx].Date, Settings.UserFmt)
      else if TradeLogFile[RecIdx].Date > xStrToDate(Cdate, Settings.UserFmt) then
        TradesSum[TradesSumCount].cd := DateToStr(TradeLogFile[RecIdx].Date, Settings.UserFmt);
    end
    else if (TradeLogFile[RecIdx].OC = 'W') and (Settings.DispWSdefer) then begin
      // if TradeLogFile[RecIdx].amount < 0 then
      if (compareValue(TradeLogFile[RecIdx].amount, 0, NEARZERO) < 0) then begin
        TradesSum[TradesSumCount].ws := funcProc.wsCstAdjd;
        TradesSum[TradesSumCount].oa := TradesSum[TradesSumCount].oa + TradeLogFile[RecIdx].amount;
      end
      else if not TradeLogFile.YearEndDone then
        TradesSum[TradesSumCount].ws := funcProc.wsPrvYr;
    end;
  end;
end;


// --------------------------------------------------------
function LoadTradesSumGL(StartDate, EndDate : TDate; LoadWSDeferrals : Boolean): Boolean;
// --------------------------------------------------------
var
  i, j, x, Y, z, lastTrNum, openP, iFiltRecIdx : integer;
  lastTick, lastLS : string;
  opSh, OpAm, clSh, clAm, myTotSales : Double;
  TrSum, Tr2Sum, Tr3Sum : PTTrSum;
  TrSumList2, TrSumList3 : TList;
  trNumFound : Boolean;
  abc : string;
  NextID : integer;
  // ------------------------
  function GetNextID : integer;
  begin
    Result := NextID;
    inc(NextID);
  end;
// ------------------------
begin
  // newsort:= true;   // test mode for files prior to 2013
  if newSort then begin
    Result := calcGains(StartDate, EndDate, LoadWSDeferrals);
    exit;
  end;
  // ------------------------
  NextID := 1;
  wsDeferrals := false;
  wsJan := '';
  wsJanS := '';
  wsJanL := '';
  wsOpen := '';
  wsOpenL := '';
  wsOpenS := '';
  totWSdefer := 0;
  totWSdeferL := 0;
  totWSdeferS := 0;
  totWSLostToIra := 0;
  totWSLostToIraL := 0;
  totWSLostToIraS := 0;
  TotActualGLST := 0;
  TotActualGLLT := 0;
  SkipActualGL := 0; // 2019-03-06 MB - debug var
  openP := 0;
  TradesSum := nil;
  SetLength(TradesSum, 1);
  // ----------------------------------
  TrSumList := TList.Create; // open reoords
  TrSumList2 := TList.Create; // close records
  TrSumList3 := TList.Create; // matched records
  // ----------------------------------
  StDeferralDetails := TSTOpenDeferralList.Create;
  // Short term Deferral Details for Potential Wash Sales Report
  NewTradesDeferralDetails := TSTOpenDeferralList.Create;
  // Losses that will become Wash Sales if another position
  // is opened within 30 days for Potential Wash Sales Report
  IRADeferralDetails := TSTOpenDeferralList.Create;
  // IRA Deferral Details for Potential Wash Sales Report
  screen.cursor := crHourglass;
  // added 2016-11-01 DE, but when does this get set back to crDefault ?
  StatBar('Generating Gains & Losses');
  try
    if EndDate = 0 then
      EndDate := xStrToDate('12/31/2099', Settings.UserFmt);
    // ----------------------------------------------------
    // load all wash sale deferrals and open transactions into TrSumList
    with frmMain.cxGrid1TableView1.datacontroller do begin
      for i := 0 to FilteredRecordCount - 1 do begin
        if StopReport then break;
        Application.ProcessMessages;
        if GetKeyState(VK_ESCAPE) and 128 = 128 then
          StopReport := True;
        // --------------------------------------
        // look up the filtered record index once per loop (faster, easier to debug)
        iFiltRecIdx := frmMain.cxGrid1TableView1.datacontroller.FilteredRecordIndex[i];
        if (TradeLogFile[iFiltRecIdx].OC = 'W') //
          or (TradeLogFile[iFiltRecIdx].OC = 'O') then begin
          New(TrSum);
          FillChar(TrSum^, SizeOf(TrSum^), 0);
          if (TradeLogFile[iFiltRecIdx].OC = 'W') then begin
            TrSum.id := GetNextID;
            TrSum.tr := TradeLogFile[iFiltRecIdx].TradeNum;
            TrSum.tk := TradeLogFile[iFiltRecIdx].Ticker;
            TrSum.ls := TradeLogFile[iFiltRecIdx].ls;
            TrSum.prf := uppercase(TradeLogFile[iFiltRecIdx].TypeMult);
            TrSum.ws := funcProc.wsPrvYr;
            TrSum.wsh := 0;
            TrSum.os := TradeLogFile[iFiltRecIdx].Shares;
            TrSum.cs := TradeLogFile[iFiltRecIdx].Shares;
            TrSum.od := DateToStr(TradeLogFile[iFiltRecIdx].Date, Settings.UserFmt);
            TrSum.oa := TradeLogFile[iFiltRecIdx].amount;
            TrSum.cs := 0;
            TrSum.cd := '';
            TrSum.ca := TradeLogFile[iFiltRecIdx].amount;
            TrSum.pr := TradeLogFile[iFiltRecIdx].amount;
            TrSum.m := TradeLogFile[iFiltRecIdx].Matched;
            TrSum.br := InttoStr(TradeLogFile[iFiltRecIdx].Broker);
            // ----------------------------------
            // added for Form 8949
            TrSum.abc := TradeLogFile[iFiltRecIdx].ABCCode[1];
            // special rules for digital currency (DCY) type
            if (Pos('DCY', TrSum.prf) = 1) then begin // 2018-03-12 MB - abc code for DCY type
              if TrSum.abc = 'A' then
                TrSum.abc := 'C' // always 'C' or 'F'
              else if TrSum.abc = 'D' then
                TrSum.abc := 'F';
            end;
            TrSum.code := TradeLogFile[iFiltRecIdx].ABCCode[2]; // WS Exemptions
            TrSum.lt := Trim(TradeLogFile[iFiltRecIdx].ABCCode[3]); // always LT
            TrSum.ny := false;
            // ----------------------------------
            TrSum.adjG := 0;
            if TradeLogFile[iFiltRecIdx].WSHoldingDate > 0 then
              TrSum.wsd := DateToStr(TradeLogFile[iFiltRecIdx].WSHoldingDate,
                Settings.UserFmt)
            else
              TrSum.wsd := '';
            wsDeferrals := True;
          end
          else if (TradeLogFile[iFiltRecIdx].OC = 'O') then begin
            TrSum.id := GetNextID;
            TrSum.tr := TradeLogFile[iFiltRecIdx].TradeNum;
            TrSum.tk := TradeLogFile[iFiltRecIdx].Ticker;
            TrSum.ls := TradeLogFile[iFiltRecIdx].ls;
            TrSum.prf := uppercase(TradeLogFile[iFiltRecIdx].TypeMult);
            TrSum.ws := funcProc.wsNone;
            TrSum.wsh := 0;
            TrSum.os := TradeLogFile[iFiltRecIdx].Shares;
            TrSum.od := DateToStr(TradeLogFile[iFiltRecIdx].Date, Settings.UserFmt);
            TrSum.oa := TradeLogFile[iFiltRecIdx].amount;
            TrSum.cs := 0;
            TrSum.cd := '';
            TrSum.ca := -TradeLogFile[iFiltRecIdx].amount;
            TrSum.pr := 0;
            TrSum.m := TradeLogFile[iFiltRecIdx].Matched;
            TrSum.br := InttoStr(TradeLogFile[iFiltRecIdx].Broker);
            if Trim(TradeLogFile[iFiltRecIdx].ABCCode[3]) = ' ' then
              TrSum.lt := 'S'
            else
              TrSum.lt := Trim(TradeLogFile[iFiltRecIdx].ABCCode[3]);
            TrSum.ny := false;
            // added for Form 8949
            TrSum.abc := TradeLogFile[iFiltRecIdx].ABCCode[1];
            // special rules for digital currency (DCY) type
            if (Pos('DCY', TrSum.prf) = 1) then begin // 2018-03-12 MB - abc code for DCY type
              if TrSum.abc = 'A' then
                TrSum.abc := 'C' // always 'C' or 'F'
              else if TrSum.abc = 'D' then
                TrSum.abc := 'F';
            end;
            TrSum.code := TradeLogFile[iFiltRecIdx].ABCCode[2];
            TrSum.adjG := 0;
            // added 01/30/2008 for no ws on same open position
            inc(openP);
            TrSum.op := openP;
            TrSum.openid := TradeLogFile[iFiltRecIdx].id;
          end;
          TrSumList.Add(TrSum);
        end;
      end;
    end;
    // ------------------------
    if StopReport then begin
      Result := false;
      exit;
    end;
    // ------------------------------------------
    // load all close transactions into TrSumList2
    with frmMain.cxGrid1TableView1.datacontroller do
      for i := 0 to FilteredRecordCount - 1 do begin
        if StopReport then break;
        Application.ProcessMessages;
        if ((GetKeyState(VK_ESCAPE) and 128) = 128) then
          StopReport := True;
        // ------------------
        // look up the filtered record index once per loop
        // (faster, easier to debug)
        iFiltRecIdx := FilteredRecordIndex[i];
        if (TradeLogFile[iFiltRecIdx].OC = 'C') //
        or (TradeLogFile[iFiltRecIdx].OC = 'M') then begin
          New(Tr2Sum);
          FillChar(Tr2Sum^, SizeOf(Tr2Sum^), 0);
          Tr2Sum.tr := TradeLogFile[iFiltRecIdx].TradeNum;
          Tr2Sum.tk := TradeLogFile[iFiltRecIdx].Ticker;
          Tr2Sum.ls := TradeLogFile[iFiltRecIdx].ls;
          Tr2Sum.prf := uppercase(TradeLogFile[iFiltRecIdx].TypeMult);
          Tr2Sum.ws := funcProc.wsNone;
          Tr2Sum.wsh := 0;
          Tr2Sum.os := 0;
          Tr2Sum.od := '';
          Tr2Sum.oa := 0;
          Tr2Sum.cs := TradeLogFile[iFiltRecIdx].Shares;
          Tr2Sum.cd := DateToStr(TradeLogFile[iFiltRecIdx].Date, Settings.UserFmt);
          Tr2Sum.ca := TradeLogFile[iFiltRecIdx].amount;
          Tr2Sum.abc := TradeLogFile[iFiltRecIdx].ABCCode;
          Tr2Sum.code := TradeLogFile[iFiltRecIdx].ABCCode[2];
          // special rules for digital currency (DCY) type
          if (Pos('DCY', Tr2Sum.prf) = 1) then begin // 2018-03-12 MB - abc code for DCY type
            if Tr2Sum.abc = 'A' then
              Tr2Sum.abc := 'C' // always 'C' or 'F'
            else if Tr2Sum.abc = 'D' then
              Tr2Sum.abc := 'F';
          end;
          Tr2Sum.pr := 0;
          Tr2Sum.m := TradeLogFile[iFiltRecIdx].Matched;
          Tr2Sum.br := InttoStr(TradeLogFile[iFiltRecIdx].Broker);
          Tr2Sum.closeid := TradeLogFile[iFiltRecIdx].id;
          TrSumList2.Add(Tr2Sum);
        end; // if
      end; // for i
    if StopReport then begin
      Result := false;
      exit;
    end;
    // ------------------------
    // begin matching trades  //
    // ------------------------
    x := 0;
    Y := 0;
    i := 0;
    opSh := 0;
    OpAm := 0;
    lastTick := '';
    lastLS := '';
    lastTrNum := -1;
    if (SuperUser or Developer) and (DEBUG_MODE > 3) then
      showTrSumList('Before LoadTradesSumGL'); // DEBUG
    // ------------------------
    // outer loop thru all open records to match with closed records
    // ------------------------
    while i <= TrSumList.Count - 1 do begin
      if StopReport then break;
      Application.ProcessMessages;
      if GetKeyState(VK_ESCAPE) and 128 = 128 then
        StopReport := True;;
      // --------------------
      TrSum := TrSumList[i];
      // do not match wash sale deferrals
      if (TrSum.ws = funcProc.wsPrvYr) then begin
        inc(i);
        continue;
      end;
      // ------------------------------
      if (TrSum.tr <> lastTrNum) then begin
        TrSumList3.Clear;
        trNumFound := false;
        // ------------------------
        // inner loop populates matched list
        // with close records
        // ------------------------
        for j := Y to TrSumList2.Count - 1 do begin
          Tr2Sum := TrSumList2[j];
          if not trNumFound then
            if (Tr2Sum.tr = TrSum.tr) then
              trNumFound := True;
          if (Tr2Sum.tk = TrSum.tk) //
            and (Tr2Sum.ls = TrSum.ls) //
            and (Tr2Sum.tr = TrSum.tr) then begin
            TrSumList3.Add(Tr2Sum);
          end
          else if trNumFound and (Tr2Sum.tr <> TrSum.tr) then begin
            Y := j;
            break;
          end;
        end; // for j
        lastTrNum := TrSum.tr;
        x := 0;
        if (TrSumList3.Count = 0) then begin
          lastTick := TrSum.tk;
          lastLS := TrSum.ls;
          // lastTrNum:= TrSum.tr;
          inc(i);
          continue;
        end;
      // inner loop thru close records done
      end; // reset TrSumList3 done
      // ------------------------------
      opSh := rndTo5(TrSum.os);
      OpAm := TrSum.oa;
      // ------------------------
      // inner loop to build matched trades list
      // ------------------------
      for j := x to TrSumList3.Count - 1 do begin
        if StopReport then break;
        Application.ProcessMessages;
        if ((GetKeyState(VK_ESCAPE) and 128) = 128) then
          StopReport := True;
        // ------------------
        Tr3Sum := TrSumList3[j];
        if Pos('FUT', TrSum.prf) = 0 then begin
          if formatTkSort(Tr3Sum.tk, Tr3Sum.prf, '') > formatTkSort(TrSum.tk, TrSum.prf, '') then
            break;
        end
        else if Tr3Sum.tk <> TrSum.tk then break;
        // 03-09-2009 edited - stop adding new G&L lines
        // when open positions are for a single broker
        if ((Tr3Sum.br <> TrSum.br)) or (Tr3Sum.ls <> TrSum.ls) then
          continue;
        // only match if broker is same for combined files
        if (Tr3Sum.br <> TrSum.br) and (j > i) then begin
          if j = TrSumList3.Count then begin
            opSh := 0;
            OpAm := 0;
            clSh := 0;
            clAm := 0;
            break;
          end;
          continue;
        end;
        // ------------------------
        if ((Pos('FUT', TrSum.prf) = 0) //
        and (formatTkSort(Tr3Sum.tk, Tr3Sum.prf, '') <> formatTkSort(TrSum.tk, TrSum.prf, ''))) //
          or ((Pos('FUT', TrSum.prf) = 1) and (Tr3Sum.tk <> TrSum.tk)) //
          or (Tr3Sum.ls <> TrSum.ls) then
          continue;
        clSh := rndTo5(Tr3Sum.cs);
        clAm := Tr3Sum.ca;
        // match long / short
        if (TrSum.ls <> Tr3Sum.ls) then
          continue;
        // ===================================== //
        // begin matching
        // ===================================== //
        // match tax lots
        if (IsInt(TrSum.m) and IsInt(Tr3Sum.m) and (TrSum.m = Tr3Sum.m)) // ML
        or ((not IsInt(TrSum.m)) and (not IsInt(Tr3Sum.m))) // not matched lot
        then
          // open shares = close shares
          if  rndTo5(TrSum.os) = rndTo5(clSh) then begin
            if (Pos('Ex', Tr3Sum.m) = 1) then
              TrSum.m := Tr3Sum.m;
            TrSum.cs := Tr3Sum.cs;
            TrSum.ca := Tr3Sum.ca;
            TrSum.cd := Tr3Sum.cd;
            TrSum.pr := TrSum.ca + TrSum.oa;
            TrSum.ActualPL := TrSum.pr;
            TrSum.closeid := Tr3Sum.closeid;
            if (Length(Trim(TrSum.abc)) = 0) //
            and (Length(Trim(Tr3Sum.abc)) > 0) then begin
              TrSum.abc := Tr3Sum.abc;
              TrSum.code := Tr3Sum.code; // 2020-12-18 MB
            end;
            // special rules for digital currency (DCY) type
            if (Pos('DCY', TrSum.prf) = 1) then begin // 2018-03-12 MB - abc code for DCY type
              if TrSum.abc = 'A' then
                TrSum.abc := 'C' // always 'C' or 'F'
              else if TrSum.abc = 'D' then
                TrSum.abc := 'F';
            end;
            // determine if long or short term
            if Trim(TrSum.lt) = ' ' then
              TrSum.lt := 'S';
            if (TrSum.od <> '') and (TrSum.cd <> '') then begin
            // added 4-1-08 all short sales are S-T - IRS Publ 550 p54
              if (TrSum.ls = 'L') //
                and TTLDateUtils.MoreThanOneYearBetween(xStrToDate(TrSum.od, Settings.UserFmt),
                xStrToDate(TrSum.cd, Settings.UserFmt)) then
                TrSum.lt := 'L'
              else
                TrSum.lt := 'S';
            end
            else
              TrSum.lt := 'S';
            // short option expirations are always ST
            if (Pos('OPT-', TrSum.prf) = 1) and (TrSum.ls = 'S') and (TrSum.ca = 0) then
              TrSum.lt := 'S';
            x := j + 1;
            Tr3Sum.cd := '';
            break;
          end
          // open shares < close shares
          else if rndTo5(TrSum.os) < rndTo5(clSh) then begin
            // sm('open shares < close shares' + cr + floattostr(TrSum.os,Settings.UserFmt) + cr + floattostr(clSh,Settings.UserFmt));
            // TrSum.tr:= i+1;
            if (Pos('Ex', Tr3Sum.m) = 1) then TrSum.m := Tr3Sum.m;
            TrSum.cs := TrSum.os;
            TrSum.ca := TrSum.os / Tr3Sum.cs * Tr3Sum.ca;
            TrSum.ca := rndTo2(TrSum.ca);
            TrSum.cd := Tr3Sum.cd;
            TrSum.pr := TrSum.ca + TrSum.oa;
            TrSum.ActualPL := TrSum.pr;
            TrSum.closeid := Tr3Sum.closeid;
            if (Length(Trim(TrSum.abc)) = 0) and (Length(Trim(Tr3Sum.abc)) > 0) then begin
              TrSum.abc := Tr3Sum.abc;
              TrSum.code := Tr3Sum.code; // 2020-12-18 MB
            end;
            // special rules for digital currency (DCY) type
            if (Pos('DCY', TrSum.prf) = 1) then begin // 2018-03-12 MB - abc code for DCY type
              if TrSum.abc = 'A' then
                TrSum.abc := 'C' // always 'C' or 'F'
              else if TrSum.abc = 'D' then
                TrSum.abc := 'F';
            end;
            // determine if long or short term
            // Also total up Actual GL, for Long and Short
            TrSum.lt := 'S';
            if (TrSum.od <> '') and (TrSum.cd <> '') then begin
            // added 4-1-08 all short sales are S-T - IRS Publ 550 p54
              if (TrSum.ls = 'L') //
                and TTLDateUtils.MoreThanOneYearBetween(xStrToDate(TrSum.od, Settings.UserFmt),
                xStrToDate(TrSum.cd, Settings.UserFmt)) then
                TrSum.lt := 'L'
              else
                TrSum.lt := 'S';
            end
            else
              TrSum.lt := 'S';
            // option expirations are always ST
            if (Pos('OPT-', TrSum.prf) = 1) and (TrSum.ls = 'S') and (TrSum.ca = 0) then
              TrSum.lt := 'S';
            TrSumList[i] := TrSum;
            Tr3Sum.cs := rndTo5(clSh - TrSum.os);
            Tr3Sum.ca := rndTo2(clAm - TrSum.ca);
            x := j;
            break;
          end
          // open shares > close shares
          else if rndTo5(TrSum.os) > rndTo5(clSh) then begin
            // sm('open shares > close shares'+cr+floatToStr(TrSum.os)+cr+floatToStr(clSh));
            if (Pos('Ex', Tr3Sum.m) = 1) then
              TrSum.m := Tr3Sum.m;
            TrSum.os := clSh;
            TrSum.oa := rndTo2(opAm*(clSh/opSh));
            TrSum.cs := clSh;
            TrSum.ca := clAm;
            TrSum.cd := Tr3Sum.cd;
            TrSum.pr := TrSum.ca + TrSum.oa;
            TrSum.ActualPL := TrSum.pr;
            TrSum.closeid := Tr3Sum.closeid;
            TrSum.br := Tr3Sum.br;
            // determine if long or short term
            TrSum.lt := 'S';
            if (TrSum.od <> '') and (TrSum.cd <> '') then begin
            // added 4-1-08 all short sales are S-T - IRS Publ 550 p54
              if (TrSum.ls = 'L') //
                and TTLDateUtils.MoreThanOneYearBetween(xStrToDate(TrSum.od, Settings.UserFmt),
                xStrToDate(TrSum.cd, Settings.UserFmt)) then
                TrSum.lt := 'L'
              else
                TrSum.lt := 'S';
            end
            else
              TrSum.lt := 'S';
            // option expirations are always ST
            if (Pos('OPT-', TrSum.prf) = 1) and (TrSum.ls = 'S') and (TrSum.ca = 0) then
              TrSum.lt := 'S';
            // Grab the ABC Code from TrSum3 before you blow it away
            // so it can be added to the TrSum record later.
            abc := Trim(Tr3Sum.abc);
            // add another open G&L line to TrSumList
            New(Tr3Sum);
            FillChar(Tr3Sum^, SizeOf(Tr3Sum^), 0);
            Tr3Sum.id := GetNextID;
            Tr3Sum.tr := TrSum.tr;
            Tr3Sum.tk := TrSum.tk;
            Tr3Sum.ls := TrSum.ls;
            Tr3Sum.prf := uppercase(TrSum.prf);
            Tr3Sum.ws := funcProc.wsNone;
            Tr3Sum.wsh := 0;
            Tr3Sum.os := opSh - clSh;
            Tr3Sum.oa := OpAm - TrSum.oa; // Tr3Sum.oa:= StrFmtToFloat('%1.2f',[((opSh-clSh)/opSh)*opAm]));
            Tr3Sum.od := TrSum.od;
            Tr3Sum.cs := 0;
            Tr3Sum.cd := '';
            Tr3Sum.ca := -Tr3Sum.oa;
            Tr3Sum.pr := 0;
            Tr3Sum.m := TrSum.m;
            Tr3Sum.br := TrSum.br;
            Tr3Sum.code := TrSum.code; // 2022-03-24 MB
            Tr3Sum.abc := TrSum.abc;
            // special rules for digital currency (DCY) type
            if (Pos('DCY', Tr3Sum.prf) = 1) then begin // 2018-03-12 MB - abc code for DCY type
              if Tr3Sum.abc = 'A' then
                Tr3Sum.abc := 'C' // always 'C' or 'F'
              else if Tr3Sum.abc = 'D' then
                Tr3Sum.abc := 'F';
            end;
            Tr3Sum.lt := TrSum.lt;
            Tr3Sum.op := TrSum.op;
            Tr3Sum.openid := TrSum.openid;
            // Now make a final modification to the ABC Code based on the Close record.
            // We do this after creating the additional Open record above because we don't
            // want the ABC Code set into the new record if it came from the Close Record.
            if (Length(Trim(TrSum.abc)) = 0) and (Length(abc) > 0) then
              TrSum.abc := abc;
            // special rules for digital currency (DCY) type
            if (Pos('DCY', TrSum.prf) = 1) then begin // 2018-03-12 MB - abc code for DCY type
              if TrSum.abc = 'A' then
                TrSum.abc := 'C' // always 'C' or 'F'
              else if TrSum.abc = 'D' then
                TrSum.abc := 'F';
            end;
            TrSumList.Items[i] := TrSum;
            // sm(Tr3Sum.cd);
            if i < TrSumList.Count - 1 then
              TrSumList.Insert(i + 1, Tr3Sum)
            else
              TrSumList.Add(Tr3Sum);
            x := j + 1;
            break;
          end;
      end; // for j
      // ------------------------------
      if (TrSum.cd <> '') //
        and (xStrToDate(TrSum.cd, Settings.UserFmt) >= StartDate) //
        and (xStrToDate(TrSum.cd, Settings.UserFmt) <= EndDate) then begin
        if TrSum.lt = 'L' then
          TotActualGLLT := TotActualGLLT + TrSum.ActualPL
        else
          TotActualGLST := TotActualGLST + TrSum.ActualPL;
      end
      else if (TrSum.ActualPL <> 0) then begin
        SkipActualGL := SkipActualGL + TrSum.ActualPL; // 2019-03-06 MB - debug var
      end;
      lastTick := formatTkSort(TrSum.tk, TrSum.prf, '');
      lastLS := TrSum.ls;
      inc(i);
    end; // while i
    // ------------------------------------------
    FreeAndNil(TrSumList2);
    // We do need to free the list though
    FreeAndNil(TrSumList3);
    if (SuperUser or Developer) and (DEBUG_MODE > 3) then
      showTrSumList('after LoadTradesSumGL');
    if StopReport then begin
      Result := false;
      exit;
    end
    else begin
      if LoadWSDeferrals and wsDeferrals then
        LoadTradesSumGLdefer;
      Result := True;
    end;
    // --------------
    if (SuperUser or Developer) and (DEBUG_MODE > 3) then begin
      showTrSumList('after LoadTradesSumGL'); // DEBUG
      sm('END - LoadTradesSumGL' + cr //
        + 'TotActualGLST: ' + FloatToStr(TotActualGLST));
    end; // --- DEBUG
  finally
    screen.cursor := crDefault;
  end;
end; //


procedure LoadTradesSumGLdefer;
var
  i, j, x, c : integer;
  openSh, openWSdefer, openWSamt : Double;
  wsDefer, wsDefer2, Tr2Sum, Tr3Sum : PTTrSum;
  wsDeferList : TList;
  lastTick, lastTickLT, longStr, cType : string;
  TrSum : PTTrSum;
  OldAmt, mult : Double;
  // ------------------------
  procedure AdjustHoldingDate;
  var
    HoldingDate : TDate;
  begin
    if (Length(wsDefer.wsd) = 0) or (wsDefer.wsd = '0') then exit;
    HoldingDate := xStrToDate(wsDefer.wsd, Settings.UserFmt);
    if (ReportStyle in [rptIRS_D1, rptSubD1, rptWashSales, rptPotentialWS, rptGAndL, rptRecon]) //
    and (Tr2Sum.ls = 'L') and (TradeLogFile.TaxYear > 2011) //
    and (HoldingDate < xStrToDate(Tr2Sum.od, Settings.UserFmt)) then begin
      // Holding period changes for Open Date.
      // If the Loss Trades Open Date (TrSum) is less than the Trigger Trades Open Date (Tr3Sum)
      // AND we are in 2012 or greater
      // THEN set the Trigger Trades Open Date to the Loss Trades date.
      // If this change in Date also causes the trade to become Long Term set this too
      if (Tr2Sum.cd <> '') and TTLDateUtils.MoreThanOneYearBetween(HoldingDate,
        xStrToDate(Tr2Sum.cd, Settings.UserFmt)) then begin
        Tr2Sum.lt := 'L';
        Tr2Sum.od := DateToStr(HoldingDate, Settings.UserFmt);
      end;
    end;
  end;
  // ------------------------
  procedure SplitTrSum;
  var
    HoldingDate : TDate;
  begin
    if (Length(wsDefer.wsd) = 0) or (wsDefer.wsd = '0') then exit;
    HoldingDate := xStrToDate(wsDefer.wsd, Settings.UserFmt);
    if (ReportStyle in [rptIRS_D1, rptSubD1, rptWashSales, rptPotentialWS, rptGAndL, rptRecon]) //
    and (TradeLogFile.TaxYear > 2011) and (Tr2Sum.ls = 'L') //
    and ((HoldingDate > 0) and (Tr2Sum.cd <> '') //
    and TTLDateUtils.MoreThanOneYearBetween(HoldingDate, xStrToDate(Tr2Sum.cd, Settings.UserFmt))) //
    then begin
      // This means we need to split the Trigger Trade so that it only has
      // the same amount of shares as the Loss Trade Tr2Sum
      New(Tr3Sum);
      FillChar(Tr3Sum^, SizeOf(Tr3Sum^), 0);
      // This makes a copy of the contents of the record pointed to by Tr2Sum into Tr3Sum
      Tr3Sum^ := Tr2Sum^;
      // Adjust Shares, since Close and open shares are the same
      // simply adjust open shares and set closed shares to it.
      Tr2Sum.os := wsDefer.os;
      if Tr2Sum.cd <> '' then Tr2Sum.cs := Tr2Sum.os;
      // Adjust P and L
      Tr2Sum.ActualPL := RndTo8(Tr2Sum.ActualPL * (Tr2Sum.os / Tr3Sum.os)); // split
      Tr2Sum.pr := RndTo8(Tr2Sum.pr * (Tr2Sum.os / Tr3Sum.os)); // split
      // Adjust Open Amount and Closed Amount
      Tr2Sum.oa := RndTo8(Tr2Sum.oa * (Tr2Sum.os / Tr3Sum.os)); // split
      if Tr2Sum.cd <> '' then
        Tr2Sum.ca := RndTo8(Tr2Sum.ca * (Tr2Sum.os / Tr3Sum.os)); // split
      // Adjust the original trade accordingly
      Tr3Sum.os := Tr3Sum.os - Tr2Sum.os;
      if Tr3Sum.cd <> '' then Tr3Sum.cs := Tr3Sum.os;
      Tr3Sum.ActualPL := Tr3Sum.ActualPL - Tr2Sum.ActualPL;
      Tr3Sum.pr := Tr3Sum.pr - Tr2Sum.pr;
      Tr3Sum.oa := Tr3Sum.oa - Tr2Sum.oa;
      if Tr3Sum.cd <> '' then Tr3Sum.ca := Tr3Sum.ca - Tr2Sum.ca;
      // Since we are splitting this and it will be added to the file and processed next
      // lets decrease the OpenSh variable so it is not counted twice.
      openSh := openSh - Tr3Sum.os;
      TrSumList.Insert(j + 1, Tr3Sum);
    end
  end;
// ------------------------
begin
  if (SuperUser or Developer) and (DEBUG_MODE > 3) then
    showTrSumList('before LoadTradesSumGLdefer');
  if (TradeLogFile.CurrentBrokerID > 0) //
  and TradeLogFile.CurrentAccount.Ira then exit; // --->
  // ----------------------------------
  wsDeferList := TList.Create;
  wsDeferOpenList := TList.Create;
  lastTick := '';
  // load list of wash sale deferrals from last year (ie: W recs)
  for i := 0 to TrSumList.Count - 1 do begin
    TrSum := TrSumList[i];
    if TrSum.ws = funcProc.wsPrvYr then begin
      New(wsDefer);
      FillChar(wsDefer^, SizeOf(wsDefer^), 0);
      wsDefer.tr := TrSum.tr;
      wsDefer.tk := TrSum.tk;
      wsDefer.ls := TrSum.ls;
      wsDefer.os := RndTo5(TrSum.os);
      wsDefer.oa := TrSum.oa;
      wsDefer.od := TrSum.od;
      wsDefer.cd := TrSum.cd;
      wsDefer.prf := TrSum.prf;
      wsDefer.br := TrSum.br;
      wsDefer.code := TrSum.code; // 2022-03-24 MB
      wsDefer.lt := TrSum.lt;
      wsDefer.m := TrSum.m;
      wsDefer.wsd := TrSum.wsd;
      wsDeferList.Add(wsDefer); // sm('od: '+wsDefer.od+cr+wsdefer.cd);
      continue;
    end;
  end;
  // sm('wsDeferList.count: '+intToStr(wsDeferList.count));
  if wsDeferList.Count = 0 then begin
    for i := 0 to wsDeferList.Count - 1 do begin
      Dispose(wsDeferList[i]);
    end;
    wsDeferList.free;
    // Since we have added nothing to this list we can just free it
    wsDeferOpenList.free;
    wsDeferrals := false;
    exit;
  end;
  StatBar('Adjusting for Wash Sale Deferrals');
  openWSamt := 0;
  openWSdefer := 0;
  // adjust cost basis of trades causing ws deferrals
  x := 0;
  for i := 0 to wsDeferList.Count - 1 do begin
    wsDefer := wsDeferList[i];
    openSh := 0;
    if (i > 0) and (wsDefer.tk <> lastTick) then begin
      openWSdefer := 0;
      if openWSamt <> 0 then loadWSdeferred(lastTickLT, openWSamt);
      openWSamt := 0;
    end;
    // 2013-11-18 openWSdefer must be in shares not contracts
    if True then begin // <---- ?!?
      if (TradeLogFile.TaxYear >= 2013) and (Pos('OPT', wsDefer.prf) = 1) then begin
        cType := wsDefer.prf;
        delete(cType, 1, Pos('-', cType));
        mult := StrToFloat(cType, Settings.UserFmt);
      end
      else
        mult := 1;
    end;
    openWSdefer := openWSdefer + wsDefer.os * mult;
    openWSamt := openWSamt + wsDefer.oa;
    // -------------------------------------
    // Loop through transactions
    // -------------------------------------
    for j := x to TrSumList.Count - 1 do begin
      Tr2Sum := TrSumList[j];
      if (TradeLogFile.TaxYear >= 2013) and (Pos('OPT', Tr2Sum.prf) = 1) then begin
        cType := Tr2Sum.prf;
        delete(cType, 1, Pos('-', cType));
        mult := StrToFloat(cType, Settings.UserFmt);
      end
      else
        mult := 1;
      // do not adjust cost basis of wash sale transactions
      if (Tr2Sum.ws = funcProc.wsPrvYr) or (Tr2Sum.ws = funcProc.wsThisYr) //
      or (Tr2Sum.tk <> wsDefer.tk) or (Tr2Sum.ls <> wsDefer.ls) //
      or (Tr2Sum.wsh >= Tr2Sum.cs * mult) // 2013-11-18 Dave
      or (Tr2Sum.od <> wsDefer.od) then begin
        continue;
      end;
      // 2013-11-18 openSh must be in shares too!
      if Tr2Sum.ls = 'L' then
        openSh := openSh + rndTo5(Tr2Sum.os * mult - Tr2Sum.wsh) //
      else
        openSh := openSh + rndTo5(Tr2Sum.cs * mult - Tr2Sum.wsh); //
      // skip if zero shares
      if (openSh = 0) or (openWSdefer = 0) then
        continue;
      // openSh = openWSdefer
      if rndTo5(openSh) = rndTo5(openWSdefer) then begin
        // sm(inttostr(i)+': openSh = openWSdefer');
        if Tr2Sum.ls = 'L' then
          Tr2Sum.oa := Tr2Sum.oa + openWSamt
        else
          Tr2Sum.ca := Tr2Sum.ca + openWSamt;
        // GetSettlementDate, checks
        // 1) LS = 'S'
        // 2) IsStockType
        // 3) Add 3 Business Days to CD.
        // IF GetSettlementDate causes this Transaction to flow into next year.
        // AMD after applying the W Record there is a loss,
        // THEN skip this so it flows to next year. This needs to be done here
        // for end of year processing because we need the OpenWSAmt applied to
        // the Close Amount first, so that later on we know that this is a loss.
        // --------------------------------------------------------------------
        // replaced (Tr2Sum.oa + Tr2Sum.ca < 0) with compareValue(... to avoid rounding errors
        if (GetSettlementDate(Tr2Sum) > xStrToDate('12/31/' + TaxYear, Settings.InternalFmt))
        and (compareValue((Tr2Sum.oa + Tr2Sum.ca), 0, NEARZERO) < 0) then begin
          // sm('openSh = openWSdefer');
          continue;
        end;
        //
        if openWSamt <> 0 then begin
          if (Tr2Sum.cd <> '') then begin
            if YYYYMMDD_Ex(Tr2Sum.cd, Settings.UserFmt)
              > YYYYMMDD_Ex('12/31/' + TaxYear, Settings.InternalFmt) then
            begin
              // sm('='+cr+Tr2Sum.tk+'  '+Tr2Sum.lt+'  '+CurrStrEx(openWSamt));
              loadWSdeferred(Tr2Sum.lt, openWSamt);
            end;
          end;
        end;
        longStr := Tr2Sum.ls;
        if Tr2Sum.cd <> '' then begin
          if YYYYMMDD_Ex(Tr2Sum.cd, Settings.UserFmt)
            <= YYYYMMDD_Ex('12/31/' + TaxYear, Settings.InternalFmt) then
            openWSdefer := 0;
        end;
        // Adjust holding date if there is a holding date in the deferral record m field
        AdjustHoldingDate;
        Tr2Sum.ws := funcProc.wsCstAdjd;
        // 12-11-06 change wsh from contracts to shares to fix problem with W records and options
        // note: this fix did not completely fix the problem
        // but we will leave it as is for tax year files less than 2013
        if (TradeLogFile.TaxYear < 2013) and (Pos('OPT', Tr2Sum.prf) = 1) then
          Tr2Sum.wsh := Tr2Sum.wsh + openSh * getMult(Tr2Sum.prf)
        else
          Tr2Sum.wsh := Tr2Sum.wsh + openSh;
        TrSumList[j] := Tr2Sum;
        openSh := 0;
        openWSamt := 0;
        x := j + 1;
        break;
      end
      // openSh > openWSdefer
      else if (rndTo5(openSh) > rndTo5(openWSdefer)) then begin
        // sm(inttostr(i)+': openSh > openWSdefer');
        // Split the TrSum record so that it matches the WSDefer record shares,
        SplitTrSum;
        // Adjust holding date if there is a holding date in the deferral record m field
        AdjustHoldingDate;
        if Tr2Sum.ls = 'L' then
          Tr2Sum.oa := Tr2Sum.oa + openWSamt
        else
          Tr2Sum.ca := Tr2Sum.ca + openWSamt;
        // GetSettlementDate, checks
        // 1) LS = 'S'
        // 2) IsStockType
        // 3) Add 3 Business Days to CD.
        // IF GetSettlementDate causes this Transaction to flow into next year
        // AND after applying the W Record there is a loss,
        // THEN skip this so it flows to next year. This needs to be done here
        // for end of year processing because we need the OpenWSAmt applied to
        // the Close Amount first, so that later on we know that this is a loss.
        // replaced (Tr2Sum.oa + Tr2Sum.ca < 0) with compareValue(... to avoid rounding errors
        if (GetSettlementDate(Tr2Sum) > xStrToDate('12/31/' + TaxYear, Settings.InternalFmt))
        and (compareValue((Tr2Sum.oa + Tr2Sum.ca), 0, NEARZERO) < 0) then begin
          // sm('openSh > openWSdefer');
          continue;
        end;
        openSh := rndTo5(openSh - openWSdefer);
        if openWSamt <> 0 then begin
          if Tr2Sum.cd <> '' then begin
            if xStrToDate(Tr2Sum.cd, Settings.UserFmt)
            > xStrToDate('12/31/' + TaxYear, Settings.InternalFmt)
            then begin
              loadWSdeferred(Tr2Sum.lt, openWSamt);
            end;
          end;
        end;
        longStr := Tr2Sum.ls;
        Tr2Sum.ws := funcProc.wsCstAdjd;
        Tr2Sum.wsh := Tr2Sum.wsh + openWSdefer;
        if Tr2Sum.cd <> '' then begin
          if xStrToDate(Tr2Sum.cd, Settings.UserFmt)
          <= xStrToDate('12/31/' + TaxYear, Settings.InternalFmt) then
            openWSdefer := 0;
        end;
        openWSamt := 0;
      end
      // openSh < openWSdefer
      else if (rndTo5(openSh) < rndTo5(openWSdefer))
      then begin
        // sm(inttostr(i)+': openSh < openWSdefer');
        if Tr2Sum.ls = 'L' then
          Tr2Sum.oa := Tr2Sum.oa + (openSh / openWSdefer * openWSamt) // split
        else
          Tr2Sum.ca := Tr2Sum.ca + (openSh / openWSdefer * openWSamt); // split
        // GetSettlementDate, checks
        // 1) LS = 'S'
        // 2) IsStockType
        // 3) Add 3 Business Days to CD.
        // IF GetSettlementDate causes this Transaction to flow into next year
        // AND after applying the W Record there is a loss,
        // THEN skip this so it flows to next year. This needs to be done here
        // for end of year processing because we need the OpenWSAmt applied to
        // the Close Amount first, so that later on we know that this is a loss.
        if (GetSettlementDate(Tr2Sum) > xStrToDate('12/31/' + TaxYear, Settings.InternalFmt))
        // and (Tr2Sum.oa + Tr2Sum.ca < 0) then
        and (compareValue((Tr2Sum.oa + Tr2Sum.ca), 0, NEARZERO) < 0) then begin
          // sm('openSh < openWSdefer');
          continue;
        end;
        if (openSh / openWSdefer * openWSamt) <> 0 then begin
          if Tr2Sum.cd <> '' then begin
            if YYYYMMDD_Ex(Tr2Sum.cd, Settings.UserFmt)
            > YYYYMMDD_Ex('12/31/' + TaxYear, Settings.InternalFmt)
            then begin
              loadWSdeferred(Tr2Sum.lt, (openSh / openWSdefer * openWSamt)); // split
            end;
          end;
        end;
        longStr := Tr2Sum.ls;
        // Adjust holding date if there is a holding date in the deferral record m field
        AdjustHoldingDate;
        Tr2Sum.ws := funcProc.wsCstAdjd;
        Tr2Sum.wsh := Tr2Sum.wsh + openSh;
        // Don't need to put it back in as it was never removed.
        wsDefer.oa := (openWSdefer - openSh) / openWSdefer * openWSamt; // split
        openWSdefer := rndTo5(openWSdefer - openSh);
        openWSamt := wsDefer.oa;
        openSh := 0;
      end;
      lastTickLT := Tr2Sum.lt;
      if (openWSdefer <= 0) and (openSh <= 0) then break;
    end; // end for j:=
    lastTick := wsDefer.tk;
    if (openWSdefer > 0) then begin
      New(wsDefer2);
      FillChar(wsDefer2^, SizeOf(wsDefer2^), 0);
      wsDefer2.tr := wsDefer.tr;
      wsDefer2.tk := wsDefer.tk;
      wsDefer2.ls := wsDefer.ls;
      wsDefer2.os := rndTo5(openWSdefer);
      wsDefer2.oa := wsDefer.oa;
      wsDefer2.od := wsDefer.od;
      wsDefer2.prf := wsDefer.prf;
      wsDefer2.br := wsDefer.br;
      wsDefer2.code := wsDefer.code; // 2022-03-24 MB
      wsDefer2.m := wsDefer.m;
      wsDefer2.wsd := wsDefer.wsd;
      wsDeferOpenList.Add(wsDefer2);
      openWSdefer := 0;
    end;
  end; // end for i:=
  // Must dispose of all elements previously created using new.
  for i := 0 to wsDeferList.Count - 1 do
    Dispose(wsDeferList[i]);
  wsDeferList.free;
  if (openWSamt <> 0) then begin // changed 2-22-07
    loadWSdeferred('L', openWSamt);
  end;
  if (SuperUser or Developer) and (DEBUG_MODE > 3) then
    showTrSumList('after LoadTradesSumGLdefer');
end;


function getUnderlying(TrSum : PTTrSum) : string;
begin
  if (Pos('OPT', TrSum.prf) = 1) then begin
    if ((Pos(' PUT', TrSum.tk) > 0) //
    or (Pos(' CALL', TrSum.tk) > 0)) then
      Result := copy(TrSum.tk, 1, Pos(' ', TrSum.tk) - 1)
    else
      Result := copy(TrSum.tk, 1, Length(TrSum.tk) - 2);
  end
  else
    Result := TrSum.tk;
end;


//function getUnderlyingTrade(Trade : TTLTradeSummary) : string;
//begin
//  if (Pos('OPT', uppercase(Trade.TypeMult)) = 1) then begin
//    Result := copy(Trade.Ticker, 1, Pos(' ', Trade.Ticker) - 1);
//  end
//  else
//    Result := Trade.Ticker;
//end;

//function getUnderlyingStkOpt(TrSum : PTTrSum) : string;
//begin
//  // add a space to option trades
//  if Pos('OPT', TrSum.prf) = 1 then
//    Result := getUnderlying(TrSum) + ' '
//  else
//    Result := getUnderlying(TrSum);
//end;

// currently not used
//procedure sortTrSumListByDate;
//var
//  i, j : integer;
//  sList : TList;
//  myDatesList : TList<Double>;
//  myDate, sDate : TDate;
//  myTrSum : PTTrSum;
//begin
//  if (SuperUser or Developer) and (DEBUG_MODE > 3) then
//    showTrSumList('before sortTrSumListByDate');
//  sList := TList.Create;
//  myDatesList := TList<Double>.Create;
//  try
//    StatBar('Loading Dates and Ticks Lists');
//    for i := 0 to TrSumList.Count - 1 do begin
//      myTrSum := TrSumList[i];
//      myDate := xStrToDate(myTrSum.od, Settings.InternalFmt);
//      // load list of tdates
//      if myDatesList.IndexOf(myDate) = -1 then
//        myDatesList.Add(myDate);
//    end;
//    // sort list of tdates
//    StatBar('Sorting Dates List');
//    myDatesList.Sort;
//    // cycle thru dates
//    for i := 0 to myDatesList.Count - 1 do begin
//      sDate := myDatesList[i];
//      // sm(myTicksList[t] +tab+ dateToStr(sDate) +tab+ intToStr(i));
//      // cycle thru TrSumList
//      for j := 0 to TrSumList.Count - 1 do begin
//        myTrSum := TrSumList[j];
//        myDate := xStrToDate(myTrSum.od, Settings.InternalFmt);
//        // sm('t: '+inttostr(t)+tab+myTicksList[t]+cr
//        // +'i: '+inttostr(i) +tab+dateToStr(sdate)+cr
//        // +'j: '+inttostr(j)+tab+dateToStr(myDate)+tab+floatTostr(myTrSum.os));
//        if (myDate = sDate) then begin
//          sList.Add(myTrSum);
//          // sm('added: '+myTrSum.od);
//        end;
//      end; // j
//    end; // i
//    if (SuperUser or Developer) and (DEBUG_MODE > 3) then begin
//      sm('sList: ' + inttostr(sList.Count) + ' - ' + intTostr(TrSumList.Count));
//      showTrSumList('after sortTrSumListByDate');
//    // reload TrSumList
//    end; // DEBUG
//    StatBar('Finishing Trades Sorted by Date');
//    TrSumList.clear;
//    for i := 0 to sList.Count - 1 do begin
//      myTrSum := sList[i];
//      TrSumList.Add(myTrSum);
//    end;
//  finally
//    FreeAndNil(sList);
//    FreeAndNil(myDatesList);
//  end;
//end; // sortTrSumListByDate


// this may not be needed with new calcWashSales looping
//procedure sortTrSumListbyTicker;
//var
//  i, tk, dt, w, startIdx, tickIdx : integer;
//  sumList : TList;
//  tickList, IRAticks : TStringList;
//  myDatesList : TList<Double>;
//  myTrSum, myTrSum2 : PTTrSum;
//  myDate, sDate : TDate;
//  myTick, lastTick, underlyingTk : string;
//  StopReport : Boolean;
//begin
//  if (SuperUser or Developer) and (DEBUG_MODE > 3) then
//    showTrSumList('before sortTrSumListbyTicker');
//  sumList := TList.Create;
//  tickList := TStringList.Create;
//  IRAticks := TStringList.Create;
//  myDatesList := TList<Double>.Create;
//  startIdx := 0;
//  tickIdx := 0;
//  myTick := '';
//  lastTick := '';
//  try
//    StatBar('Sorting by Ticker and Date');
//    for i := 0 to TrSumList.Count - 1 do begin
//      myTrSum := TrSumList[i];
//      myDate := strToDate(myTrSum.od); // 2015-04-08 removed InternalFmt from TrSum.od - MB
//      // load list of tdates
//      if myDatesList.IndexOf(myDate) = -1 then
//        myDatesList.Add(myDate);
//      underlyingTk := getUnderlying(myTrSum);
//      // make options a separate ticker
//      if Pos('OPT', myTrSum.prf) = 1 then
//        underlyingTk := underlyingTk + ' ';
//      // load list of tickers
//      if tickList.IndexOf(underlyingTk) = -1 then
//        tickList.Add(underlyingTk);
//    end;
//    // sort list of tdates
//    myDatesList.Sort;
//    // sort list of tickers
//    tickList.Sort;
//    // for I := 0 to tickList.Count-1 do msgTxt:= msgTxt + tickList[i] +cr; clipBoard.AsText:=msgTxt; sm(msgtxt);
//    startIdx := 0;
//    // cycle thru tickers
//    for tk := 0 to tickList.Count - 1 do begin
//      myTick := tickList[tk];
//      // find record index of first occurance of myTick
//      for i := tk to TrSumList.Count - 1 do begin
//        myTrSum := TrSumList[i];
//        underlyingTk := getUnderlying(myTrSum);
//        if Pos('OPT', myTrSum.prf) = 1 then
//          underlyingTk := underlyingTk + ' ';
//        if (underlyingTk = myTick) then begin
//          tickIdx := i;
//          break;
//        end;
//      end;
//      // statBar('Sorting By Ticker...'+myTick);
//      // cycle thru dates
//      for dt := 0 to myDatesList.Count - 1 do begin
//        sDate := myDatesList[dt];
//        startIdx := tickIdx;
//        // cycle thru TrSumList
//        while startIdx < TrSumList.Count do begin
//          myTrSum := TrSumList[startIdx];
//          // no longer necessary to put IRA trades at end with latest WS calc routine
//          myDate := xStrToDate(myTrSum.od, Settings.InternalFmt);
//          underlyingTk := getUnderlying(myTrSum);
//          if Pos('OPT', myTrSum.prf) = 1 then
//            underlyingTk := underlyingTk + ' ';
//          if (underlyingTk = myTick) and (myDate = sDate) and (myTrSum.ws <> 2) then begin
//            sumList.Add(myTrSum);
//            // add WS recs - cycle thru following records until rec is not a wash sale
//            if (startIdx < TrSumList.Count - 1) then
//              for w := startIdx + 1 to TrSumList.Count - 1 do begin
//                myTrSum2 := TrSumList[w];
//                if (myTrSum2.ws <> 2) then begin
//                  break;
//                end
//                else begin
//                  sumList.Add(myTrSum2);
//                end;
//              end;
//          end;
//          if (underlyingTk > myTick) then
//            break;
//          inc(startIdx);
//        end; // startIdx
//      end; // dt
//    end; // tk
//    // ------------------------
//    // reload TrSumList
//    TrSumList.clear;
//    for i := 0 to sumList.Count - 1 do begin
//      myTrSum := sumList[i];
//      TrSumList.Add(myTrSum);
//    end;
//  finally
//    FreeAndNil(sumList);
//    FreeAndNil(tickList);
//    FreeAndNil(IRAticks);
//    FreeAndNil(myDatesList);
//  end;
//  if (SuperUser or Developer) and (DEBUG_MODE > 3) then
//    showTrSumList('after sortTrSumListbyTicker');
//end;


// ============================================================================
procedure LoadTradesSumGLWS(StartDate, EndDate: TDateTime; Running8949, WSBetweenSL: Boolean);
// ============================================================================
var
  c, i, j, k, x, tkPos, crPos : integer;
  prof, washSh, wsSh, wsTk, wsDeferAmt, Gadj, mult : Double;
  lossDate, lastLossDate : TDate;
  WSum, TrSum, Tr3Sum, Tr2Sum : PTTrSum;
  TrSumTick, Tr2SumTick, lastTick, currTick, lastWStick, amtStr : string;
  timeStart, timeEnd : TTime;
  elapsed : string;
  wsTrigger, StkToOp, OpToOp, OpToStk, aa : Boolean;
  DaysHeld : integer;
  NextID : integer;
  YrOpenedIn, m, D : Word;
  NewHoldingDate : TDateTime;
  InsertBefore, LossHasWashSale : Boolean;
  // ------------------------
  function GetNextID : integer;
  begin
    Result := NextID;
    inc(NextID);
  end;
// ------------------------
begin
  // this is the v 12.1.2.2 version
  if (SuperUser or Developer) and (DEBUG_MODE > 3) then
    showTrSumList('before LoadTradesSumGLWS');
  if newSort then begin
    // use the new wash sale calc routine
    calcWashSales(StartDate, EndDate, Running8949, WSBetweenSL);
    exit;
  end;
  // LoadTradesSumGLWS
  try
    c := TrSumList.Count;
    if c = 0 then exit;
    timeStart := now();
    SetLength(datDeferralsST, 0);
    SetLength(datDeferralsLT, 0);
    SetLength(datDeferralsIRA, 0);
    datDeferralsST := nil;
    datDeferralsLT := nil;
    datDeferralsIRA := nil;
    wsOpenL := '';
    wsOpenS := '';
    wsJanS := '';
    wsJanL := '';
    totWSdeferS := 0;
    totWSdeferL := 0;
    totWSdefer := 0;
    totWSLostToIra := 0;
    totWSLostToIraL := 0;
    totWSLostToIraS := 0;
    j := 0;
    k := 0;
    x := 0;
    lastTick := '';
    lastWStick := '';
    wsDeferAmt := 0;
    Gadj := 0;
    DaysHeld := 0;
    NextID := 0;
    // Grab the highest ID for use later when we have to add to TrSumList.
    for i := 0 to TrSumList.Count - 1 do begin
      if PTTrSum(TrSumList[i]).id > NextID then
        NextID := PTTrSum(TrSumList[i]).id;
    end;
    inc(NextID);
    // cycle thru all records
    i := 0;
    while i < c do begin
      if StopReport then begin
        break;
        exit;
      end;
      TrSum := TrSumList[i];
      if (TaxYear > '2010') and Running8949 and (Length(Trim(TrSum.abc)) = 0) then begin
        if (TradeLogFile.TaxYear = 2011) then begin
        {               Opened Curr  Opened     Not
                        Tax Year	 Prev Year  Reported
        Stocks, Bonds	  A	           B
        Mut Funds	      B	           B	        C
        ETF/ETN's	      A	           A	        B
        Drips	          B	           B	        C
        Options	          B	           B	        C
        SSF			                                C
        }
          if (Pos('SSF', TrSum.prf) = 1) //
          or ((Pos('OPT', TrSum.prf) = 1) //
            and not TradeLogFile.FileHeader[StrToInt(TrSum.br)].Options1099) //
          or ((Pos('MUT', TrSum.prf) = 1) //
            and not TradeLogFile.FileHeader[StrToInt(TrSum.br)].MutualFunds1099) //
          or ((Pos('DRP', TrSum.prf) = 1) //
            and not TradeLogFile.FileHeader[StrToInt(TrSum.br)].Drips1099) //
            or (Pos('DCY', TrSum.prf) = 1) // 2018-03-12 MB - or digital currency
          then
            TrSum.abc := 'C'
          else if (Pos('OPT', TrSum.prf) = 1) //
          or (Pos('MUT', TrSum.prf) = 1) //
          or (Pos('DRP', TrSum.prf) = 1) //
          or ( (Pos('ETF', TrSum.prf) = 1) //
            and not TradeLogFile.FileHeader[StrToInt(TrSum.br)].ETFETN1099) //
          or (xStrToDate(TrSum.od, Settings.UserFmt) < xStrToDate('01/01/2011', Settings.InternalFmt)) //
          then
            TrSum.abc := 'B'
          else
            TrSum.abc := 'A';
          // end if
        end
        else if (TradeLogFile.TaxYear >= 2012) then begin
        { Opened Curr Tax Year	  Opened Prev Year	  Not Reported
          Stocks, Bonds	    A	            A         B < 2011
          Mut Funds	        A	            B	      B = 2012 C = 2011
          ETF/ETN's	        A	            A	      B
          Drips	            A	            B	      B = 2012 C = 2011
          Options	        B	            B	      C
          SSF			                              C
        }
          DecodeDate(xStrToDate(TrSum.od, Settings.UserFmt), YrOpenedIn, m, D);
          // sm('Account Tab = ' + IntToStr(frmMain.TabAccounts.TabIndex) + CR +'CurrentBrokerID = ' + IntToStr(TradeLogFile.CurrentBrokerID) ); // 2015-02-27 MB
          if (Pos('SSF', TrSum.prf) = 1) //
          or ((Pos('OPT', TrSum.prf) = 1) //
            and not TradeLogFile.FileHeader[StrToInt(TrSum.br)].Options1099) //
          // Mutual Funds Opened in 2011 go on C unless they are reported on 1099, then B
          or ((Pos('MUT', TrSum.prf) = 1) and (YrOpenedIn = 2011) //
            and not TradeLogFile.FileHeader[StrToInt(TrSum.br)].MutualFunds1099) //
          // Drips Opened in 2011 go on C unless they are reported on 1099, then B
          or ((Pos('DRP', TrSum.prf) = 1) and (YrOpenedIn = 2011) //
          and not TradeLogFile.FileHeader[StrToInt(TrSum.br)].Drips1099) //
          or (Pos('DCY', TrSum.prf) = 1) // 2018-03-12 MB - new DCY type
          then
            TrSum.abc := 'C'
          else if (Pos('OPT', TrSum.prf) = 1) //
          or ((Pos('MUT', TrSum.prf) = 1) //
            and (((YrOpenedIn = 2011) //
              and (TradeLogFile.FileHeader[StrToInt(TrSum.br)].MutualFunds1099)) //
            or ((YrOpenedIn = 2012) //
              and not(TradeLogFile.FileHeader[StrToInt(TrSum.br)].MutualFunds1099)))) //
            or ((Pos('DRP', TrSum.prf) = 1) //
            and (((YrOpenedIn = 2011) //
              and (TradeLogFile.FileHeader[StrToInt(TrSum.br)].MutualFunds1099)) //
          or ((YrOpenedIn = 2012) //
            and not(TradeLogFile.FileHeader[StrToInt(TrSum.br)].MutualFunds1099)))) //
          or ((Pos('ETF', TrSum.prf) = 1) //
            and not TradeLogFile.FileHeader[StrToInt(TrSum.br)].ETFETN1099) //
          or (xStrToDate(TrSum.od, Settings.UserFmt) < xStrToDate('01/01/2011', Settings.InternalFmt)) //
          then
            TrSum.abc := 'B'
          else
            TrSum.abc := 'A';
        end;
      end;
      // sm('Account Tab = ' + IntToStr(frmMain.TabAccounts.TabIndex) + CR +'CurrentBrokerID = ' + IntToStr(TradeLogFile.CurrentBrokerID) ); // 2015-02-27 MB
      // --------------------------------
      // 09-07-22
      // add wash sales deferred from last year attached to an open position from last year
      if (TrSum.ws = funcProc.wsPrvYr) then begin
        wsDeferAmt := wsDeferAmt + TrSum.oa;
        // sm(inttostr(i)+'  '+floattostr(wsdeferAmt,Settings.UserFmt));
        lastWStick := TrSum.tk;
      end;
      // sm('Account Tab = ' + IntToStr(frmMain.TabAccounts.TabIndex) + CR +'CurrentBrokerID = ' + IntToStr(TradeLogFile.CurrentBrokerID) ); // 2015-02-27 MB
      // --------------------------------
      if (TrSum.cd <> '') and (TrSum.ws = 3) then
        wsDeferAmt := 0;
      // set lastTick = to first record
      if i = 0 then begin
        if (Pos('OPT', TrSum.prf) = 1) then begin
          if ((Pos(' PUT', TrSum.tk) > 0) or (Pos(' CALL', TrSum.tk) > 0)) then
            lastTick := copy(TrSum.tk, 1, Pos(' ', TrSum.tk) - 1)
          else
            lastTick := copy(TrSum.tk, 1, Length(TrSum.tk) - 2);
        end
        else
          lastTick := TrSum.tk;
      end;
      // 2014-05-04 - fix for filterd by ticker and 1st stock trade is open so report matches with unfiltered report
      if ((i = 0) and (frmMain.gridFilter = gfNone) and (TrSum.cd = '')) then
        lastTick := '';
      // get current underlying ticker symbol
      if (Pos('OPT', TrSum.prf) = 1) then begin
        if ((Pos(' PUT', TrSum.tk) > 0) or (Pos(' CALL', TrSum.tk) > 0)) then
          currTick := copy(TrSum.tk, 1, Pos(' ', TrSum.tk) - 1)
        else
          currTick := copy(TrSum.tk, 1, Length(TrSum.tk) - 2);
      end
      else
        currTick := TrSum.tk;
      if currTick <> lastTick then begin // sm(inttostr(i)+cr+currtick+cr+lastTick);
        k := i;
        StatBar('Generating Wash Sales: ' + TrSum.tk);
      end;
      // sm('Account Tab = ' + IntToStr(frmMain.TabAccounts.TabIndex) + CR +'CurrentBrokerID = ' + IntToStr(TradeLogFile.CurrentBrokerID) ); // 2015-02-27 MB
      { // set lastTick
        if (pos('OPT',TrSum.prf) = 1) then begin
          if ((Pos(' PUT', TrSum.tk) > 0) or (Pos(' CALL', TrSum.tk) > 0)) then
            lastTick := copy(TrSum.tk, 1, Pos(' ', TrSum.tk) - 1)
          else
            lastTick := copy(TrSum.tk, 1, Length(TrSum.tk) - 2);
        end
        else
          lastTick := TrSum.tk;
      }
      // skip if trade not closed
      if (TrSum.cd = '')
      // skip all Long Trades closed in prior tax year
      or ((TrSum.ls = 'L') and (xStrToDate(TrSum.cd, Settings.UserFmt) < StartDate))
      // skip all short trades closed in prior tax year
      // that will not be pushed into this year based on settlement date
      or ((TrSum.ls = 'S') and (GetSettlementDate(TrSum) < StartDate))
      // Skip All trades in Next Tax Year.
      or (xStrToDate(TrSum.cd, Settings.UserFmt) > EndDate)
      // skip if future or currency
      or (Pos('FUT', TrSum.prf) > 0) //
      or (Pos('CUR', TrSum.prf) > 0) //
      or (Pos('DCY', TrSum.prf) > 0) //
      or (Pos('CTN', TrSum.prf) > 0) //
      or (Pos('VTN', TrSum.prf) > 0) //
      or (TrSum.ws = funcProc.wsPrvYr) // skip if wash sale
      or (TrSum.ws = funcProc.wsThisYr) then begin
        inc(i);
        continue;
      end;
      prof := TrSum.oa + TrSum.ca;
      if TrSum.oa = TrSum.ca then prof := 0;
      // --------------------------------
      //        TRADE HAS A LOSS
      // --------------------------------
      LossHasWashSale := false;
      if (prof < 0)
      // do not create WS on exercised options
        and (Pos(' EXERCISED', TrSum.tk) = 0)
      // do not create WS on a loss in an IRA
        and (not TradeLogFile.FileHeader[StrToInt(TrSum.br)].Ira) then begin
        if Frac(i / 100) = 0 then
          StatBar('Generating Wash Sales: ' + TrSum.tk + ' - ' + FloatToStr(i / 100, Settings.UserFmt));
        // washSh in shares, not contracts
        washSh := RndTo5(TrSum.cs);
        if (Pos('OPT', TrSum.prf) = 1) then begin
          washSh := washSh * getMult(TrSum.prf);
        end;
        lossDate := xStrToDate(TrSum.cd, Settings.UserFmt);
        x := 1;
        j := k; // allows loop to check backwards 30 days - k is first record of each new ticker
        /// ///  how can we make k = -30 days?  /////
        /// cycle thru trades to find a repurchase trade which triggers a WS
        Gadj := 0;
        while j < c do begin
          OpToOp := false;
          OpToStk := false;
          StkToOp := false;
          // code for exiting routine when ESC key hit
          Application.ProcessMessages;
          if GetKeyState(VK_ESCAPE) and 128 = 128 then StopReport := True;
          if StopReport then begin
            break;
            exit;
          end;
          // ----------------------------
          Tr2Sum := TrSumList[j];
          // don't create a new ws on...
          if (Tr2Sum.ws = funcProc.wsPrvYr) // ...a Prev Yr wash sale
          or (Tr2Sum.ws = funcProc.wsThisYr) // ...a current year WS
          or (Tr2Sum.ws = funcProc.wsTXF) // ...a loss trade already adjusted
          or (j = i) // ...the same trade
          or (TrSum.op = Tr2Sum.op) // ...the same open position lot
          or (Tr2Sum.code = 'X') // ...a buy marked as 'excluded from WS'
          or (Pos(' EXERCISED', Tr2Sum.tk) > 0) // ... an exercised option
          then begin
            inc(j);
            continue;
          end;
          // skip trades outside of +/-30 day window
          if ((Tr2Sum.od <> '') //
            and (xStrToDate(Tr2Sum.od, Settings.UserFmt) < lossDate - 30)) //
          then begin
            inc(j);
            continue;
          end;
          /// don't move ws back to a previous tax year   05-23-08
          /// if the trade is closed in the previous year   revised 7-10-08
          if (xStrToDate(Tr2Sum.od, Settings.UserFmt) < StartDate) //
          and (Tr2Sum.cd <> '') //
          and (xStrToDate(Tr2Sum.cd, Settings.UserFmt) < StartDate) then begin
            inc(j);
            continue;
          end;
          // ----------------------------
          // check for WS between stocks and options
          mult := 1;
          if ((Pos('STK', TrSum.prf) = 1) or (Pos('MUT', TrSum.prf) = 1) //
           or (Pos('ETF', TrSum.prf) = 1) or (Pos('DRP', TrSum.prf) = 1)) //
          and (Pos('OPT', Tr2Sum.prf) = 1) then begin
            StkToOp := True;
            mult := getMult(Tr2Sum.prf);
          end
          else if (Pos('OPT', TrSum.prf) = 1) and (Pos('OPT', Tr2Sum.prf) = 1)
          then begin
            OpToOp := True;
            mult := getMult(Tr2Sum.prf);
          end
          else if (Pos('OPT', TrSum.prf) = 1) //
          and ((Pos('STK', Tr2Sum.prf) = 1) or (Pos('MUT', Tr2Sum.prf) = 1) //
            or (Pos('ETF', Tr2Sum.prf) = 1) or (Pos('DRP', Tr2Sum.prf) = 1))
          then begin
            OpToStk := True;
            mult := 1;
          end;
          // ----------------------------
          // don't adjust a loss trade that has already had all it's shares adjusted
          // NOTE: wsh in shares and os in shares or contracts
          if (Tr2Sum.wsh >= Tr2Sum.os * mult) then begin
            inc(j);
            continue;
          end;
          // ----------------------------
          // don't create a WS on an option expiration
          if (Pos('OPT', Tr2Sum.prf) = 1) and (Tr2Sum.ls = 'S') //
          and (Tr2Sum.ca = 0) and (TrSum.ls = 'L') then begin
            inc(j);
            continue;
          end;
          // ----------------------------
          // don't create a WS between long stock and long put
          if StkToOp and (TrSum.ls = 'L') and (Tr2Sum.ls = 'L') //
          and (Pos(' PUT', Tr2Sum.tk) > 0) then begin
            inc(j);
            continue;
          end;
          // ----------------------------
          // don't create a WS between long call and long put
          if OpToOp and (TrSum.ls = 'L') and (Pos(' CALL', TrSum.tk) > 0) //
          and (Tr2Sum.ls = 'L') and (Pos(' PUT', Tr2Sum.tk) > 0) then begin
            inc(j);
            continue;
          end;
          // ----------------------------
          // added for WS between stocks and options
          if (Pos('OPT', TrSum.prf) = 1) then begin
            if ((Pos(' PUT', TrSum.tk) > 0) or (Pos(' CALL', TrSum.tk) > 0)) then
              TrSumTick := copy(TrSum.tk, 1, Pos(' ', TrSum.tk) - 1)
            else
              TrSumTick := copy(TrSum.tk, 1, Length(TrSum.tk) - 2);
          end
          else
            TrSumTick := TrSum.tk;
          // ----------------------------
          if (Pos('OPT', Tr2Sum.prf) = 1) then begin
            // myWS := Tr2Sum.os * mult;
            if ((Pos(' PUT', Tr2Sum.tk) > 0) or (Pos(' CALL', Tr2Sum.tk) > 0)) then
              Tr2SumTick := copy(Tr2Sum.tk, 1, Pos(' ', Tr2Sum.tk) - 1)
            else
              Tr2SumTick := copy(Tr2Sum.tk, 1, Length(Tr2Sum.tk) - 2);
          end
          else
            Tr2SumTick := Tr2Sum.tk;
          // ----------------------------
          // END added for WS between stocks and options
          if (TrSumTick <> Tr2SumTick) then begin
            washSh := 0;
            break;
          end;
          // ----------------------------
          try
            if OpToStk and (RndTo5(Tr2Sum.os - Tr2Sum.wsh) > 0) then
              wsTrigger := True
            else if (StkToOp or OpToOp) //
            and (RndTo5(Tr2Sum.os * mult - Tr2Sum.wsh) > 0) then
              wsTrigger := True
            else if (RndTo5(Tr2Sum.os - Tr2Sum.wsh) > 0) then
              wsTrigger := True
            else
              wsTrigger := false;
            // --------------------------
            if wsTrigger then begin
              // sm('wash sales between longs and shorts');
              if (TrSum.ls = 'L') then begin
                // no WS between Long and Shorts
                if (Tr2Sum.ls = 'S') then begin
                  inc(j);
                  continue;
                end;
                // ----------------------
                // if open date of long not within +/-30 days - no ws
                if ((Tr2Sum.ls = 'L') and (Tr2Sum.od <> '')) //
                and ((xStrToDate(Tr2Sum.od, Settings.UserFmt) > lossDate + 30) //
                or (xStrToDate(Tr2Sum.od, Settings.UserFmt) < lossDate - 30)) then begin
                  inc(j);
                  continue;
                end;
                // ----------------------
                // if open date of long within -30 days and trade has a loss - no ws
                if (Tr2Sum.ls = 'L') //
                and ((Tr2Sum.od <> '') //
                and (xStrToDate(Tr2Sum.od, Settings.UserFmt) >= lossDate - 30) //
                and (xStrToDate(Tr2Sum.od, Settings.UserFmt) < lossDate)) //
                and (Tr2Sum.ca + Tr2Sum.oa < 0) and (Tr2Sum.ws <> 3) //
                and (j < i) then begin
                  inc(j);
                  continue;
                end;
              end
              else if (TrSum.ls = 'S') then begin
                // if a long and shortLongs not checked no ws
                if not(ReportStyle in [rptWashSales, rptIRS_D1, rptPotentialWS]) //
                and not WSBetweenSL and (Tr2Sum.ls = 'L') then begin
                  inc(j);
                  continue;
                end;
                // if open date of long/short not within 30 days no ws
                if (Tr2Sum.od <> '') //
                and ((xStrToDate(Tr2Sum.od, Settings.UserFmt) > lossDate + 30) //
                or (xStrToDate(Tr2Sum.od, Settings.UserFmt) < lossDate - 30)) //
                then begin
                  inc(j);
                  continue;
                end;
                // Since the loss trade closes in next year based on Settlement Date,
                // Don't generate a wash sale since it will be generated next year.
                if (TradeLogFile.TaxYear > 2011) //
                and (GetSettlementDate(TrSum) > xStrToDate('12/31/' + TaxYear, Settings.InternalFmt)) //
                and (TrSum.oa + TrSum.ca < 0) then begin
                  inc(j);
                  continue;
                end;
              end;
              // ------------------------
              // create a new wash sale //
              // ------------------------
              // flag to not adjust the cost basis of any loss trade
              // that has already been WS adjusted
              TrSum.ws := funcProc.wsTXF;
              New(WSum);
              FillChar(WSum^, SizeOf(WSum^), 0);
              WSum.id := GetNextID;
              WSum.ws := funcProc.wsThisYr;
              WSum.tr := Tr2Sum.tr;
              WSum.prf := Tr2Sum.prf;
              WSum.tk := Tr2Sum.tk;
              WSum.ls := Tr2Sum.ls;
              WSum.cm := Tr2Sum.cm;
              WSum.lt := TrSum.lt;
              WSum.wstriggerid := Tr2Sum.id;
              WSum.os := Tr2Sum.os;
              WSum.cs := Tr2Sum.cs;
              WSum.oa := Tr2Sum.oa;
              WSum.ca := Tr2Sum.ca;
              // wsh in shares, not contracts
              WSum.wsh := Tr2Sum.wsh;
              WSum.br := Tr2Sum.br;
              WSum.code := Tr2Sum.code; // 2022-03-24 MB
              if (TrSum.ls = 'L') then begin
                if (Tr2Sum.ls = 'L') then begin
                  // wSum.od tracks original loss trade open date for W record deferrals
                  // wSum.cd tracks trigger trade open date
                  WSum.od := Tr2Sum.od;
                  WSum.cd := Tr2Sum.cd;
                end
                else begin
                  WSum.od := Tr2Sum.cd;
                  WSum.cd := Tr2Sum.od;
                end;
              end
              // ------------------------
              else if (TrSum.ls = 'S') then begin
                if (Tr2Sum.ls = 'L') then begin
                  WSum.od := Tr2Sum.od;
                  WSum.cd := Tr2Sum.cd;
                end
                else begin
                  WSum.od := Tr2Sum.od;
                  WSum.cd := Tr2Sum.cd;
                end;
              end;
              // Initially set Wash Sale Holding Date to Open Date.
              // Later if the WS Date needs adjusting we will do this.
              WSum.wsd := WSum.od;
              // if loss trades was already long term then wash sale must be
              // long term, but after 2011 we are handling this in the holding
              // date adjutment code so only do this for 2011 and earlier files.
              if TradeLogFile.TaxYear < 2012 then begin
                if TrSum.lt = 'L' then begin
                  WSum.lt := 'L';
                  Tr2Sum.lt := 'L';
                end;
              end;
              // ------------------------
              wsSh := WSum.os * mult;
              // calc wash sale amount - note: variables wsSh, wsh, and washSh in shares
              if (RndTo5(wsSh - Tr2Sum.wsh) > washSh) then begin
                WSum.os := washSh / mult; // WS entry in shares
                // sm('1 WSum.os = '+floattostr(WSum.os));
                if (TrSum.cs <> 0) then begin
                  if StkToOp then
                    WSum.oa := prof * (WSum.os / TrSum.cs * mult)
                  else if OpToStk then
                    WSum.oa := prof * (WSum.os / TrSum.cs / getMult(TrSum.prf))
                  else // OpToOp
                    WSum.oa := prof * (WSum.os / TrSum.cs);
                end;
              end
              else if (RndTo5(wsSh - Tr2Sum.wsh) = washSh) then begin
                WSum.os := washSh / mult; // WS entry in shares
                // sm('2 WSum.os = '+floattostr(WSum.os));
                if (TrSum.cs <> 0) then begin
                  if StkToOp then
                    WSum.oa := prof * (WSum.os / TrSum.cs * mult)
                  else if OpToStk then
                    WSum.oa := prof * (WSum.os / TrSum.cs / getMult(TrSum.prf))
                  else // OpToOp
                    WSum.oa := prof * (WSum.os / TrSum.cs);
                end;
              end
              else if (RndTo5(wsSh - Tr2Sum.wsh) < washSh) then begin
                WSum.os := (wsSh / mult) - (Tr2Sum.wsh / mult); // WS entry in shares
                // sm('3 WSum.os = '+floattostr(WSum.os)+cr+'WSum.cs = '+floattostr(WSum.cs)+cr+'mult = '+floattostr(mult));
                if (TrSum.cs <> 0) then begin
                  if StkToOp then
                    WSum.oa := prof * (WSum.os / TrSum.cs * mult)
                  else if OpToStk then
                    WSum.oa := prof * (WSum.os / TrSum.cs / getMult(TrSum.prf))
                  else // OpToOp
                    WSum.oa := prof * (WSum.os / TrSum.cs);
                end;
              end;
              WSum.pr := 0; // WSum.oa;
              WSum.ca := 0; // 2-13-07
              { Tr3Sum Becomes Wash Sale Portion of Tr2Sum
                Ca, and OA Amount are adjusted based on number of shares and
                the Amounts are adjusted for CstAdjd
                Holding date is changed for this record to WSum Date.
                // *** change holding period of trade that triggered wash sale
                // TrSum is trade with loss,
                // Tr2Sum is trade that triggered the Wash Sale the repurchase.
                TRSUM: 1 Jan 1 O L MSFT 100 10
                1 Jan 2 C L MSFT 100 9
                TR2SUM: 2 Jan 15 O L MSFT 100 11  (WS Valid Trigger)
                Change Open Date of Jan 15 Trade and knock it back to Jan 1.

                100 Shares bought and sold at a loss,
                repurchased 15 days later 200,
                So TradeLog currently adjusts cost basis for entire 200.
                Now the Holding period Date should it change for all 200.

                If Trigger trade is before Loss trade then don't change
                the date as you do not move the date up.

                FOR 2012 and Greater Tax Year Only
 }
              if (ReportStyle in [rptIRS_D1, rptSubD1, rptWashSales, rptGAndL, rptRecon, rptPotentialWS]) //
              and ((Tr2Sum.os > TrSum.os) or (WSum.os < Tr2Sum.os)) //
              and (TradeLogFile.TaxYear > 2011) //
              and (xStrToDate(TrSum.od, Settings.UserFmt) < xStrToDate(Tr2Sum.od, Settings.UserFmt)) //
              // Only make these adjustments if this is going to push the trade into long term status
              and ((Tr2Sum.cd <> '') //
              and TTLDateUtils.MoreThanOneYearBetween(xStrToDate(TrSum.od, Settings.UserFmt), xStrToDate(Tr2Sum.cd, Settings.UserFmt))) //
              then begin
                // Capture the reason why this is being split
                // so we know where to insert the new record.
                // If the TriggerTrade os > the loss trade.os
                // then insert after the current trigger trade,
                // or if the TriggerTrade.os > the Amount to Wash
                // then insert Before the current Trigger Trade
                InsertBefore := WSum.os < Tr2Sum.os;
                // This means we need to split the Trigger Trade
                // so that it only has the same amount of shares
                // as the Loss Trade Tr2Sum
                New(Tr3Sum);
                FillChar(Tr3Sum^, SizeOf(Tr3Sum^), 0);
                // This makes a copy of the contents of the record pointed to by Tr2Sum into Tr3Sum
                Tr3Sum^ := Tr2Sum^;
                // Adjust Shares, since Close and open shares are the same just adjust open
                //  shares and set closed shares to it.
                Tr3Sum.os := WSum.os;
                Tr3Sum.id := GetNextID;
                WSum.wstriggerid := Tr3Sum.id;
                if Tr3Sum.cd <> '' then
                  Tr3Sum.cs := Tr3Sum.os;
                { Adjust Actual Profit and Loss }
                Tr3Sum.ActualPL := RndTo5(Tr3Sum.ActualPL * (Tr3Sum.os / Tr2Sum.os));
                Tr3Sum.pr := RndTo5(Tr3Sum.pr * (Tr3Sum.os / Tr2Sum.os));
                { Adjust Open Amount and Closed Amount }
                Tr3Sum.oa := RndTo5(Tr3Sum.oa * (Tr3Sum.os / Tr2Sum.os));
                if Tr3Sum.cd <> '' then
                  Tr3Sum.ca := RndTo5(Tr3Sum.ca * (Tr3Sum.os / Tr2Sum.os));
                { Adjust the original trade accordingly }
                Tr2Sum.os := Tr2Sum.os - Tr3Sum.os;
                Tr2Sum.ActualPL := Tr2Sum.ActualPL - Tr3Sum.ActualPL;
                Tr2Sum.pr := Tr2Sum.pr - Tr3Sum.pr;
                if Tr2Sum.cd <> '' then
                  Tr2Sum.cs := Tr2Sum.os;
                Tr2Sum.oa := Tr2Sum.oa - Tr3Sum.oa;
                if Tr2Sum.cd <> '' then
                  Tr2Sum.ca := Tr2Sum.ca - Tr3Sum.ca;
                if InsertBefore then
                  TrSumList.Insert(j, Tr3Sum)
                else
                  TrSumList.Insert(j + 1, Tr3Sum);
                if j <= i then inc(i);
                c := TrSumList.Count;
              end
              else
                Tr3Sum := TrSumList[j];
              // end if
              if (TradeLogFile.TaxYear > 2011) then begin
              { Holding period changes for Open Date.
                If the Loss Trades Open Date (TrSum) < the Trigger Trades Open Date (Tr3Sum)
                and we are in 2012 or greater then subtract from he Trigger Trades Open Date the number
                of days the Loss Trade was Open.
                If this change in Date also causes the trade to become Long Term set this also. }
                if (xStrToDate(TrSum.od, Settings.UserFmt) < xStrToDate(Tr3Sum.od, Settings.UserFmt))
                then begin
                  NewHoldingDate := xStrToDate(Tr3Sum.od, Settings.UserFmt)
                  - (xStrToDate(TrSum.cd, Settings.UserFmt)
                  - xStrToDate(TrSum.od, Settings.UserFmt));
                  { set Wash Sale Date that when end of year generates
                    W records it can be carried forward to next year. }
                  if (Tr3Sum.ls = 'L') and (TrSum.ls = 'L') then
                    WSum.wsd := DateToStr(NewHoldingDate, Settings.UserFmt);
                  // Only modify the TrSum array if we are printing IRSd1 or Sub D1
                  if (ReportStyle in [rptIRS_D1, rptSubD1, rptWashSales, rptGAndL, rptRecon, rptPotentialWS])
                  then begin
                    if (Tr3Sum.cd <> '') //
                    and TTLDateUtils.MoreThanOneYearBetween(NewHoldingDate, xStrToDate(Tr3Sum.cd, Settings.UserFmt)) //
                    and (Tr3Sum.ls = 'L') and (TrSum.ls = 'L') then begin
                      Tr3Sum.lt := 'L';
                      Tr3Sum.od := DateToStr(NewHoldingDate, Settings.UserFmt);
                    end;
                  end;
                end
              end;
              // adj cost basis of the trigger trade
              Tr3Sum.ws := funcProc.wsCstAdjd;
              if (RndTo5(Tr3Sum.wsh + (WSum.os * mult)) > Tr3Sum.os * mult) then
                // Used to determine whether Wash Sales are still applicable.
                Tr3Sum.wsh := Tr3Sum.os * mult
              else
                Tr3Sum.wsh := RndTo5(Tr3Sum.wsh + (WSum.os * mult));
              // end if
              // total sales must match with or without ws
              if (Tr3Sum.ls = 'L') then
                Tr3Sum.oa := Tr3Sum.oa + WSum.oa
              else if (Tr3Sum.ls = 'S') then
                Tr3Sum.ca := Tr3Sum.ca + WSum.oa;
              // end if
              Tr3Sum.pr := Tr3Sum.pr + WSum.oa;
              // END adj cost basis of trigger trade
              // -----------------------------------
              // Wash Sales Permanently Lost to IRA
              if TradeLogFile.FileHeader[StrToInt(Tr2Sum.br)].Ira then begin
                totWSLostToIra := totWSLostToIra + WSum.oa;
                loadWSdeferList(datDeferralsIRA, 'j', WSum.tk, WSum.oa);
                LoadIRADeferralDetails(TrSum, WSum);
                // sm('Account Tab = ' + IntToStr(frmMain.TabAccounts.TabIndex) + CR +'CurrentBrokerID = ' + IntToStr(TradeLogFile.CurrentBrokerID) ); // 2/27/15
                if WSum.lt = 'L' then begin
                  totWSLostToIraL := totWSLostToIraL + WSum.oa;
                end
                else if WSum.lt = 'S' then begin
                  totWSLostToIraS := totWSLostToIraS + WSum.oa;
                end;
              end
              // wash sale caused by Jan repurchase
              else if (WSum.od <> '') //
              and (xStrToDate(WSum.od, Settings.UserFmt) > EndDate) //
              and (xStrToDate(WSum.od, Settings.UserFmt) < EndDate + 31) //
              then begin
                if (WSum.lt = 'L') then begin
                  totWSdeferL := totWSdeferL + WSum.oa;
                  loadWSdeferList(datDeferralsLT, 'j', WSum.tk, WSum.oa);
                end
                else if (WSum.lt = 'S') then begin
                  totWSdeferS := totWSdeferS + WSum.oa;
                  loadWSdeferList(datDeferralsST, 'j', WSum.tk, WSum.oa);
                end;
                totWSdefer := totWSdefer + WSum.oa;
                WSum.ny := True;
              end
              // wash sale attached to open trade
              else if (RndTo5(Tr3Sum.cs) <> RndTo5(Tr3Sum.os))
              or ( (Tr3Sum.cd <> '')
              and (xStrToDate(Tr3Sum.cd, Settings.UserFmt) > EndDate)
              and (xStrToDate(WSum.od, Settings.UserFmt) < EndDate + 31))
              then begin
                if (WSum.lt = 'L') then begin
                  totWSdeferL := totWSdeferL + WSum.oa;
                  loadWSdeferList(datDeferralsLT, 'o', WSum.tk, WSum.oa);
                  LoadSTDeferralDetails(WSum);
                end
                else if (WSum.lt = 'S') then begin
                  totWSdeferS := totWSdeferS + WSum.oa;
                  loadWSdeferList(datDeferralsST, 'o', WSum.tk, WSum.oa);
                  LoadSTDeferralDetails(WSum);
                end;
                totWSdefer := totWSdefer + WSum.oa;
                WSum.ny := True;
              end
              else
                WSum.ny := false;
              // washSh = number of loss shares
              if washSh > 0 then
                washSh := RndTo5(washSh - (WSum.os * mult));
              { When running routine for reporting the 8949 we want to create an
                adjustment column for the existing TrSum, therefore if this routine
                was run just before the report then we will create the adjustment column }
              // added for Form 8949
              if (TaxYear > '2010') and Running8949 then begin
                TrSum.code := 'W';
                Gadj := Gadj - WSum.oa;
                TrSum.adjG := Gadj;
              end;
              // insert wash sale
              TrSumList.Insert(i + x, WSum);
              LossHasWashSale := True;
              c := TrSumList.Count;
              inc(x);
              if RndTo5(washSh) <= 0 then begin
                washSh := 0;
                break;
              end;
            end; // end trigger wash sale
          except
            on E : Exception do begin
              sm(E.Message + 'Error ' + InttoStr(E.HelpContext) + CR //
               + 'in LoadTradesSumGLWS');
              exit;
            end;
          end;
          inc(j);
          if RndTo5(washSh) <= 0 then break;
        end; // while j < c
        { If Wash Sale does not exist for this loss then add to potential ws Losses. }
        if not LossHasWashSale then
          LoadNewTradesDeferralDetails(TrSum, nil)
        else if (TrSum.os - WSum.os * mult > 0) then
          LoadNewTradesDeferralDetails(TrSum, WSum);
      end; // if (prof < 0) - Trade has a loss
      washSh := 0;
      // added 12-29-07 for loss on option buy back of stock
      if (Pos('OPT', TrSum.prf) = 1) then begin
        if ((Pos(' PUT', TrSum.tk) > 0) or (Pos(' CALL', TrSum.tk) > 0)) then
          lastTick := copy(TrSum.tk, 1, Pos(' ', TrSum.tk) - 1)
        else
          lastTick := copy(TrSum.tk, 1, Length(TrSum.tk) - 2);
      end
      else
        lastTick := TrSum.tk;
      inc(i);
    end; // while i < c
    timeEnd := now();
    elapsed := TimeToStr(timeEnd - timeStart, Settings.UserFmt);
    if (SuperUser or Developer) and (DEBUG_MODE > 3) then
      showTrSumList('after LoadTradesSumGLWS');
  finally
    //rj CodeSite.ExitMethod('LoadTradesSumGLWS');
  end;
end;


procedure LoadTradesSumGLWSunequal;
var
  i, c : integer;
  wsAdj, lossTr, lossTrNew : PTTrSum;
  oldSh, oldOpAmt, oldClAmt, multA, multB : Double;
begin
  // updated 2010-06-01
  if TradeLogFile.TaxYear > 2010 then exit;
  lossTr := nil;
  // ------------------------
  i := 0;
  c := TrSumList.Count;
  while i < c do begin
    if StopReport then break;
    Application.ProcessMessages;
    if GetKeyState(VK_ESCAPE) and 128 = 128 then StopReport := True;;
    // ----------------------
    wsAdj := TrSumList[i];
    // find all WS adjustments that have less shares than loss trade
    if (wsAdj.ws = 2) and (Pos('EXERCISED', wsAdj.tk) = 0) then begin
    // trade is a WS Adjustment
      if (i > 0) then begin
        lossTr := TrSumList[i - 1];
        lossTr.ws := funcProc.wsTXF;
      end
      else begin
        inc(i);
        continue;
      end;
      // --------------------
      multA := 1;
      multB := 1;
      if (Pos('OPT-', lossTr.prf) > 0) //
      and ((Pos('STK-', wsAdj.prf) > 0) or (Pos('ETF-', wsAdj.prf) > 0) //
        or (Pos('DRP-', wsAdj.prf) > 0) or (Pos('MUT-', wsAdj.prf) > 0)) //
      then begin
        multA := 100;
        multB := 1;
      end
      else if ((Pos('STK-', lossTr.prf) > 0) or (Pos('ETF-', wsAdj.prf) > 0) //
        or (Pos('DRP-', wsAdj.prf) > 0) or (Pos('MUT-', wsAdj.prf) > 0)) //
      and (Pos('OPT-', wsAdj.prf) > 0) //
      then begin
        multA := 1;
        multB := 100;
      end;
      // --------------------
      if (RndTo5(wsAdj.os * multB) < RndTo5(lossTr.cs * multA)) then begin
      // unequal # of shares
        oldSh := lossTr.os;
        oldOpAmt := lossTr.oa;
        oldClAmt := lossTr.ca;
        // ------------------
        // reduce loss trade shares and amounts
        if multA = 100 then begin
          lossTr.os := wsAdj.os / multA;
          lossTr.cs := wsAdj.os / multA;
        end
        else begin
          lossTr.os := wsAdj.os * multB;
          lossTr.cs := wsAdj.os * multB;
        end;
        lossTr.oa := lossTr.os / oldSh * lossTr.oa;
        lossTr.ca := lossTr.cs / oldSh * lossTr.ca;
        // TrSumList[i-1]:= lossTr;
        // ------------------
        // insert new loss trade after ws adj
        New(lossTrNew);
        FillChar(lossTrNew^, SizeOf(lossTrNew^), 0);
        lossTrNew.tr := lossTr.tr;
        lossTrNew.tk := lossTr.tk;
        lossTrNew.ls := lossTr.ls;
        lossTrNew.prf := lossTr.prf;
        lossTrNew.od := lossTr.od;
        lossTrNew.cd := lossTr.cd;
        lossTrNew.wsh := lossTr.wsh;
        lossTrNew.pr := lossTr.pr;
        lossTrNew.lt := lossTr.lt;
        lossTrNew.ny := lossTr.ny;
        lossTrNew.m := lossTr.m;
        lossTrNew.br := lossTr.br;
        lossTrNew.code := lossTr.code; // 2022-03-24 MB
        // ------------------
        if multA = 100 then begin
          lossTrNew.os := oldSh - wsAdj.os / multA;
          lossTrNew.cs := oldSh - wsAdj.os / multA;
        end
        else begin
          lossTrNew.os := oldSh - wsAdj.os * multB;
          lossTrNew.cs := oldSh - wsAdj.os * multB;
        end;
        lossTrNew.oa := oldOpAmt - lossTr.oa;
        lossTrNew.ca := oldClAmt - lossTr.ca;
        lossTrNew.ws := funcProc.wsNone; // 02-13-07  TXF WS flag
        // ------------------
        TrSumList.Insert(i + 1, lossTrNew);
        c := TrSumList.Count;
      end;
    end;
    inc(i);
  end;
end;


procedure loadWSdeferred(lt : string; amt : Double);
begin
  // sm('loadWSdeferred');
  if (lt = 'L') then
    totWSdeferL := totWSdeferL + amt
  else if (lt = 'S') then
    totWSdeferS := totWSdeferS + amt;
  totWSdefer := totWSdefer + amt;
end;


// changes date acquired, date sold for short sales
function LoadTradeSumAdditionalRules : Double;
var
  TrSum : PTTrSum;
  WSum : PTTrSum;
  EoYDate, OldCloseDate, NewCloseDate, dt1 : TDate;
  i : integer;
  j : integer;
begin
  // sm('LoadTradeSumAdditionalRules');
  Result := 0;
  if (TrSumList = nil) or (TrSumList.Count = 0) then exit;
  // This is only for Tax Year 2012 and Greater
  if TradeLogFile.TaxYear < 2012 then exit;
  EoYDate := xStrToDate('12/31/' + TaxYear, Settings.InternalFmt);
  for i := 0 to TrSumList.Count - 1 do begin
    TrSum := TrSumList[i];
    dt1 := xStrToDate(TrSum.cd, Settings.UserFmt);
    dt1 := MakeSettlmentAdj(dt1); // IRS rule change
    if ( ((TrSum.ws <> funcProc.wsPrvYr) and (TrSum.ws <> funcProc.wsThisYr)) //
//      or ((TrSum.ws = funcProc.wsThisYr) and (dt1 > EoYDate)) ) //
    ) //
    and (TrSum.ls = 'S') //
    and (IsStockType(TrSum.prf)) //
    and (Length(TrSum.cd) > 0) then begin
      // If Short Sell and Stock Type and a loss then add 2 or 3 to the Date Sold
      OldCloseDate := xStrToDate(TrSum.cd, Settings.UserFmt);
      NewCloseDate := MakeSettlmentAdj(OldCloseDate);
      // --------------------
      if (RndTo5(TrSum.oa) + RndTo5(TrSum.ca) < 0) then begin // This is a Loss Trade
        TrSum.od := DateToStr(NewCloseDate, Settings.UserFmt);
        // Also if this trade now closes in next year we need to mark any
        // Wash Sales attached to this trade as Deferred to Next Year and
        // add them to the Totals for the reports.
        if (OldCloseDate <= EoYDate) //
        and (NewCloseDate > EoYDate) then begin
//          if (ReportStyle = rptRecon) then begin
//            // total short sales closed at a loss, settled next tax year
//            Result := Result - TrSum.oa;
//          end;
          for j := 0 to TrSumList.Count - 1 do begin
            WSum := TrSumList[j];
            if (WSum.ws = funcProc.wsThisYr) and (WSum.wstriggerid = TrSum.id) then begin
              totWSdeferS := totWSdeferS + WSum.oa;
              loadWSdeferList(datDeferralsST, 'o', WSum.tk, WSum.oa);
              totWSdefer := totWSdefer + WSum.oa;
              WSum.ny := True;
            end;
          end;
        end;
      end
      else begin // NOT a loss
        // This is a short gain, So we need to set OD to the Close Date
        // but if the NewCloseDate would cause this to fall into next year,
        // we need to add up the Open Amount and return it
        TrSum.od := TrSum.cd;
        // total all of short sales closed at a gain at year end,
        // but not closed trade date in next tax year
        if (NewCloseDate > EoYDate) // settled next year, but closed this year at a gain.
        and (OldCloseDate <= EoYDate) then
          Result := Result + TrSum.oa;
      end; // if loss or not
    end; // if closed short stocktype
  end; // for i
end;


// ==============================================
function calcGains(StartDate, EndDate : TDate; LoadWSDeferrals : Boolean): Boolean;
// ==============================================
var
  i, j, x, Y, z, lastTrNum, openP, NextID, iFiltRecIdx : integer;
  opSh, OpAm, clSh, clAm, myTotSales : Double;
  s, lastTick, lastLS, abc : string;
  lstCrecs, TradeSummary2List, TradeSummary3List : TTLTradeSummaryList;
  TrSumOrec, TrSumCrec, TrSumWrec, TrSum, Tr2Sum, Tr3Sum : TTLTradeSummary;
  trNumFound : Boolean;
  // ------------------------
  function GetNextID : integer;
  begin
    Result := NextID;
    inc(NextID);
  end;
  // ------------------------
  function EscapeKeyPressed : Boolean;
  begin
    Application.ProcessMessages;
    Result := GetKeyState(VK_ESCAPE) and 128 = 128;
  end;
// ------------------------
begin
  // calcGains
  try
    NextID := 1;
    wsDeferrals := false;
    wsJan := '';
    wsJanS := '';
    wsJanL := '';
    wsOpen := '';
    wsOpenL := '';
    wsOpenS := '';
    totWSdefer := 0;
    totWSdeferL := 0;
    totWSdeferS := 0;
    totWSLostToIra := 0;
    totWSLostToIraL := 0;
    totWSLostToIraS := 0;
    TotActualGLST := 0;
    TotActualGLLT := 0;
    SkipActualGL := 0; // 2019-03-06 MB - debug var
    openP := 0;
    lstWrecs := TTLTradeSummaryList.Create; // Wash Sale Deferral records
    lstOrecs := TTLTradeSummaryList.Create; // open records
    lstCrecs := TTLTradeSummaryList.Create; // close records
    screen.cursor := crHourglass;
    // added 2016-11-01 DE, but when does this get set back to crDefault ?
    try
      StatBar('Generating Gains & Losses');
      // sm(intToStr(frmMain.cxGrid1TableView1.datacontroller.FilteredRecordCount));
      with frmMain.cxGrid1TableView1.datacontroller do begin
        for i := 0 to FilteredRecordCount - 1 do begin
          // look up the filtered record index once per loop (faster, easier to debug)
          iFiltRecIdx := frmMain.cxGrid1TableView1.datacontroller.FilteredRecordIndex[i];
          // load Open recs into Open recs list
          if (TradeLogFile[iFiltRecIdx].OC = 'O') then begin
            TrSumOrec := TTLTradeSummary.Create;
            TrSumOrec.UniqueId := GetNextID;
            TrSumOrec.TradeNum := TradeLogFile[iFiltRecIdx].TradeNum;
            TrSumOrec.Ticker := TradeLogFile[iFiltRecIdx].Ticker;
            TrSumOrec.ls := TradeLogFile[iFiltRecIdx].ls;
            TrSumOrec.TypeMult := uppercase(TradeLogFile[iFiltRecIdx].TypeMult);
            TrSumOrec.WashSaleType := TWashSaleType.wsNone;
            TrSumOrec.OpenedShares := TradeLogFile[iFiltRecIdx].Shares;
            TrSumOrec.OpenDate := TradeLogFile[iFiltRecIdx].Date;
            TrSumOrec.CloseDate := 0;
            TrSumOrec.OpenAmount := TradeLogFile[iFiltRecIdx].amount;
            TrSumOrec.CloseAmount := -TradeLogFile[iFiltRecIdx].amount;
            TrSumOrec.Price := 0;
            // 2014-04-11 removed so we can use the Ex match to calc 1099 Recon exercise adj amount
            { if Pos('Ex', TradeLogFile[FilteredRecordIndex[I]].Matched) > 0 then
                TrSumOrec.Matched := ''
              else }
            TrSumOrec.Matched := TradeLogFile[iFiltRecIdx].Matched;
            TrSumOrec.BrokerID := TradeLogFile[iFiltRecIdx].Broker;
            if (TradeLogFile[FilteredRecordIndex[i]].ABCCode[3] = 'L') then
              TrSumOrec.lt := 'L'
            else
              TrSumOrec.lt := 'S';
            TrSumOrec.NextYear := false;
            // added for Form 8949
            TrSumOrec.ABCCode := TradeLogFile[iFiltRecIdx].ABCCode; // [1];
// if trim(TradeLogFile[FilteredRecordIndex[i]].ABCCode)='' then sm('problem TTLTradeSummary rec.');
            // 2020-07-17 MB - Code modified to allow user to override ABC for DCY
            if (Trim(TrSumOrec.ABCCode) = '') // if user did NOT manual override...
              and (Pos('DCY', TrSumOrec.TypeMult) = 1) then begin // and it's a DCY...
              TrSumOrec.ABCCode := 'C'; // ...set to "not reported, ws allowed, LT tbd"
            end;
            TrSumOrec.code := TradeLogFile[iFiltRecIdx].ABCCode[2];
// if (TrSumOrec.Code <> 'X') then sm('problem oRec.');
            TrSumOrec.AdjustmentG := 0;
            TrSumOrec.openid := TradeLogFile[iFiltRecIdx].id;
            // sm(intToStr(TrSumOrec.OpenID));
            // added 01/30/2008 for no ws on same open position
            inc(openP);
            TrSumOrec.Open := openP;
            lstOrecs.Add(TrSumOrec);
          end
          // load Close recs into Close recs list
          else if (TradeLogFile[iFiltRecIdx].OC = 'C') //
          or (TradeLogFile[FilteredRecordIndex[i]].OC = 'M') //
          then begin
            TrSumCrec := TTLTradeSummary.Create;
            TrSumCrec.TradeNum := TradeLogFile[FilteredRecordIndex[i]].TradeNum;
            TrSumCrec.Ticker := TradeLogFile[FilteredRecordIndex[i]].Ticker;
            TrSumCrec.ls := TradeLogFile[FilteredRecordIndex[i]].ls;
            TrSumCrec.TypeMult := uppercase(TradeLogFile[FilteredRecordIndex[i]].TypeMult);
            TrSumCrec.WashSaleType := TWashSaleType.wsNone;
            TrSumCrec.ClosedShares := TradeLogFile[FilteredRecordIndex[i]].Shares;
            TrSumCrec.CloseDate := TradeLogFile[FilteredRecordIndex[i]].Date;
            TrSumCrec.CloseAmount := TradeLogFile[FilteredRecordIndex[i]].amount;
            // ----------------
            TrSumCrec.ABCCode := TradeLogFile[FilteredRecordIndex[i]].ABCCode;
            if (Pos('DCY', TrSumCrec.TypeMult) = 1) then
              TrSumCrec.ABCCode := 'C'; // 2018-03-12 MB - DCY is always "not reported"
            TrSumCrec.code := TradeLogFile[FilteredRecordIndex[i]].ABCCode[2];
            TrSumCrec.Price := 0;
            // ----------------
            TrSumCrec.Matched := TradeLogFile[FilteredRecordIndex[i]].Matched;
            TrSumCrec.BrokerID := TradeLogFile[FilteredRecordIndex[i]].Broker;
            TrSumCrec.closeid := TradeLogFile[FilteredRecordIndex[i]].id;
            // ----------------
            lstCrecs.Add(TrSumCrec);
          end
          // load W Recs into W recs list
          else if LoadWSDeferrals //
          and (TradeLogFile[FilteredRecordIndex[i]].OC = 'W') //
          then begin
            TrSumWrec := TTLTradeSummary.Create;
            TrSumWrec.UniqueId := GetNextID;
            TrSumWrec.TradeNum := TradeLogFile[FilteredRecordIndex[i]].TradeNum;
            TrSumWrec.Ticker := TradeLogFile[FilteredRecordIndex[i]].Ticker;
            TrSumWrec.ls := TradeLogFile[FilteredRecordIndex[i]].ls;
            TrSumWrec.TypeMult := uppercase(TradeLogFile[FilteredRecordIndex[i]].TypeMult);
            TrSumWrec.WashSaleType := TWashSaleType.wsPrvYr;
            TrSumWrec.WashSaleShares := 0;
            TrSumWrec.OpenedShares := TradeLogFile[FilteredRecordIndex[i]].Shares;
            TrSumWrec.OpenDate := TradeLogFile[FilteredRecordIndex[i]].Date;
            TrSumWrec.OpenAmount := TradeLogFile[FilteredRecordIndex[i]].amount;
            TrSumWrec.ClosedShares := 0;
            TrSumWrec.CloseAmount := TradeLogFile[FilteredRecordIndex[i]].amount;
            TrSumWrec.Price := TradeLogFile[FilteredRecordIndex[i]].amount;
            TrSumWrec.Matched := TradeLogFile[FilteredRecordIndex[i]].Matched;
            TrSumWrec.BrokerID := TradeLogFile[FilteredRecordIndex[i]].Broker;
            TrSumWrec.lt := ' ';
            TrSumWrec.NextYear := false;
            // added for Form 8949
            TrSumWrec.ABCCode := TradeLogFile[FilteredRecordIndex[i]].ABCCode;
            // 2020-07-17 MB - Code modified to allow user to override ABC for DCY
            if (Trim(TrSumWrec.ABCCode) = '') // if user did NOT manual override...
              and (Pos('DCY', TrSumWrec.TypeMult) = 1) then // and it's a DCY...
              TrSumWrec.ABCCode := 'C'; // ...set to "not reported"
            TrSumWrec.code := ' ';
            TrSumWrec.AdjustmentG := 0;
            if TradeLogFile[FilteredRecordIndex[i]].WSHoldingDate > 0 then
              TrSumWrec.WashSaleHoldingDate := TradeLogFile[FilteredRecordIndex[i]].WSHoldingDate;
            wsDeferrals := True;
            lstWrecs.Add(TrSumWrec);
          end; // if OC = {O, C/M, W}
        end; // for i...
      end; // with frmMain.cxGrid1TableView1.datacontroller
    // ------------------------------------------
    // sm('O Recs: '+intToStr(lstOrecs.Count)+cr+'C Recs: '+intToStr(lstCrecs.Count));
      try
        TradeSummary3List := TTLTradeSummaryList.Create(false);
        try
          StDeferralDetails := TSTOpenDeferralList.Create;
        // Short term Deferral Details for Potential Wash Sales Report
          NewTradesDeferralDetails := TSTOpenDeferralList.Create;
        // Losses that will become Wash Sales if another position
        // is opened within 30 days for Potential Wash Sales Report
          IRADeferralDetails := TSTOpenDeferralList.Create;
        // IRA Deferral Details for Potential Wash Sales Report
          if EndDate = 0 then
            EndDate := strToDate('12/31/2099', Settings.InternalFmt);
        /// / begin matching closes to opens   ////
          x := 0;
          Y := 0;
          i := 0;
          opSh := 0;
          OpAm := 0;
          lastTick := '';
          lastLS := '';
          lastTrNum := -1;
          // outer loop thru all open records to match with closed records
          while i <= lstOrecs.Count - 1 do begin
            if EscapeKeyPressed then
              exit(false); // exit immediately!
            TrSum := lstOrecs[i];
            // do not match wash sale deferrals
            if (TrSum.WashSaleType = TWashSaleType.wsPrvYr) then begin
              inc(i);
              continue;
            end;
            // reset TradeSummary3List - clears entire list
            // if (getUnderlyingTrade(TrSum) <> lastTick) then
            if (TrSum.TradeNum <> lastTrNum) then begin
              TradeSummary3List.Clear;
              trNumFound := false;
              // inner loop populates matched list with close records
              for j := Y to lstCrecs.Count - 1 do begin
                Tr2Sum := lstCrecs[j];
                if not trNumFound then begin
                  if (Tr2Sum.TradeNum = TrSum.TradeNum) then
                    trNumFound := True;
                end;
                if (Tr2Sum.Ticker = TrSum.Ticker) and (Tr2Sum.ls = TrSum.ls) and
                  (Tr2Sum.TradeNum = TrSum.TradeNum) then begin
                  TradeSummary3List.Add(Tr2Sum);
                end
                else if trNumFound and (Tr2Sum.TradeNum <> TrSum.TradeNum) then begin
                  Y := j;
                  break;
                end;
              end;
              lastTrNum := TrSum.TradeNum;
              x := 0;
              if (TradeSummary3List.Count = 0) then begin
              // lastTick := getUnderlyingTrade(TrSum);
                lastTick := TrSum.Ticker;
                lastLS := TrSum.ls;
                inc(i);
                continue;
              end;
            // inner loop thru close records done
            end; // reset TrSumList3 done
            opSh := RndTo5(TrSum.OpenedShares);
            OpAm := TrSum.OpenAmount;
            // inner loop to build matched trades list
            for j := x to TradeSummary3List.Count - 1 do begin
              if EscapeKeyPressed then
                exit(false);
              Tr3Sum := TradeSummary3List[j];
              if Pos('FUT', TrSum.TypeMult) = 0 then begin
                if formatTkSort(Tr3Sum.Ticker, Tr3Sum.TypeMult, '') >
                  formatTkSort(TrSum.Ticker, TrSum.TypeMult, '') then
                  break;
              end
              else begin
                if Tr3Sum.Ticker <> TrSum.Ticker then
                  break;
              end;
              if ((Tr3Sum.BrokerID <> TrSum.BrokerID)) or (Tr3Sum.ls <> TrSum.ls) then
                continue;
              // ------------------------
              // only match if broker is same for combined files
              if (Tr3Sum.BrokerID <> TrSum.BrokerID) and (j > i) then begin
                if j = TradeSummary3List.Count then begin
                  opSh := 0;
                  OpAm := 0;
                  clSh := 0;
                  clAm := 0;
                  break;
                end;
                continue;
              end;
              // ------------------------
              if ( (Pos('FUT', TrSum.TypeMult) = 0) //
              and ( formatTkSort(Tr3Sum.Ticker, Tr3Sum.TypeMult, '') <>
                    formatTkSort(TrSum.Ticker, TrSum.TypeMult, '') ) ) //
              or ( (Pos('FUT', TrSum.TypeMult) = 1) and (Tr3Sum.Ticker <> TrSum.Ticker) ) //
              or (Tr3Sum.ls <> TrSum.ls) then
                continue;
              clSh := RndTo5(Tr3Sum.ClosedShares);
              clAm := Tr3Sum.CloseAmount;
              // match long / short
              if (TrSum.ls <> Tr3Sum.ls) then
                continue;
              // ------------------------
              // begin matching
              // ------------------------
              // match tax lots
              // 2014-04-11 changed so we can use the Ex match to calc 1099 Recon exercise adj amount
              if ( IsInt(TrSum.Matched) and IsInt(Tr3Sum.Matched) //
              and (TrSum.Matched = Tr3Sum.Matched) ) // i.e. the same matched lot
              or ( (not IsInt(TrSum.Matched)) and (not IsInt(Tr3Sum.Matched)) ) // not matched at all
              then begin
                // ----------------------
                // open shares = close shares -- NO SPLIT NECESSARY
                if (RndTo5(TrSum.OpenedShares) = RndTo5(clSh)) then begin
                  // sm('open shares = close shares');
                  // 2014-04-25 added for 1099 Recon total option exercise / assign sales adjustment
                  if Tr3Sum.ls = 'L' then
                    TrSum.Matched := Tr3Sum.Matched;
                  // TrSum.tr:= i+1;
                  TrSum.ClosedShares := Tr3Sum.ClosedShares;
                  TrSum.CloseAmount := Tr3Sum.CloseAmount;
                  TrSum.CloseDate := Tr3Sum.CloseDate;
                  TrSum.Price := TrSum.CloseAmount + TrSum.OpenAmount;
                  TrSum.ActualPL := TrSum.Price;
                  TrSum.closeid := Tr3Sum.closeid;
                  // sm(intToStr(TrSum.OpenID)+cr+intToStr(TrSum.closeID));
                  // Since TrSum is the open leg, keep the ABCCode and code as-is
                    // if (Length(Trim(TrSum.ABCCode)) > 0)
                    // or (Length(Trim(TrSum.code)) > 0) then
                    // sm('keep TrSum.code = ' + TrSum.Code);
                  // determine if long or short term
                  TrSum.lt := 'S';
                  if (TrSum.OpenDate <> 0) and (TrSum.CloseDate <> 0) then begin
                    // added 4-1-08 all short sales are S-T - IRS Publ 550 p54
                    if (TrSum.ls = 'L') and TTLDateUtils.MoreThanOneYearBetween(TrSum.OpenDate,
                      TrSum.CloseDate) then
                      TrSum.lt := 'L'
                    else
                      TrSum.lt := 'S';
                  end
                  else
                    TrSum.lt := 'S';
                  // short option expirations are always ST
                  if (Pos('OPT-', TrSum.TypeMult) = 1) and (TrSum.ls = 'S') //
                    and (TrSum.CloseAmount = 0) then
                    TrSum.lt := 'S';
                  x := j + 1;
                  Tr3Sum.CloseDate := 0;
                  break;
                end
                // ----------------------
                // open shares < close shares -- MUST SPLIT CLOSED SHARES
                else if (RndTo5(TrSum.OpenedShares) < RndTo5(clSh)) then begin
                  TrSum.ClosedShares := TrSum.OpenedShares;
                  TrSum.CloseAmount := TrSum.OpenedShares / Tr3Sum.ClosedShares *
                    Tr3Sum.CloseAmount;
                  TrSum.CloseAmount := rndTo2(TrSum.CloseAmount);
                  TrSum.CloseDate := Tr3Sum.CloseDate;
                  TrSum.Price := TrSum.CloseAmount + TrSum.OpenAmount;
                  TrSum.ActualPL := TrSum.Price;
                  TrSum.closeid := Tr3Sum.closeid;
                  if (Length(Trim(TrSum.ABCCode)) = 0) //
                  and (Length(Trim(Tr3Sum.ABCCode)) > 0) then
                    TrSum.ABCCode := Tr3Sum.ABCCode;
                  // determine if long or short term
                  // Also total up Actual GL, for Long and Short
                  TrSum.lt := 'S';
                  if (TrSum.OpenDate <> 0) and (TrSum.CloseDate <> 0) then begin
                    // added 4-1-08 all short sales are S-T - IRS Publ 550 p54
                    if (TrSum.ls = 'L') //
                    and TTLDateUtils.MoreThanOneYearBetween(TrSum.OpenDate, TrSum.CloseDate) then
                      TrSum.lt := 'L'
                    else
                      TrSum.lt := 'S';
                  end
                  else
                    TrSum.lt := 'S';
                  // option expirations are always ST
                  if (Pos('OPT-', TrSum.TypeMult) = 1) //
                  and (TrSum.ls = 'S') //
                  and (TrSum.CloseAmount = 0) then
                    TrSum.lt := 'S'; // 2022-01-07 MB - was .ls instead of .lt
                  Tr3Sum.ClosedShares := RndTo5(clSh - TrSum.OpenedShares);
                  Tr3Sum.CloseAmount := rndTo2(clAm - TrSum.CloseAmount);
                  x := j;
                  break;
                end
                // ----------------------
                // open shares > close shares --  MUST SPLIT OPENED SHARES
                else if RndTo5(TrSum.OpenedShares) > RndTo5(clSh) then begin
                  // sm('open shares > close shares'+cr+floatToStr(TrSum.os)+cr+floatToStr(clSh));
                  TrSum.OpenedShares := clSh;
                  TrSum.OpenAmount := RndTo5(OpAm * clSh / opSh);
                  TrSum.ClosedShares := clSh;
                  TrSum.CloseAmount := clAm;
                  TrSum.CloseDate := Tr3Sum.CloseDate;
                  TrSum.Price := TrSum.CloseAmount + TrSum.OpenAmount;
                  TrSum.ActualPL := TrSum.Price;
                  TrSum.closeid := Tr3Sum.closeid;
                  TrSum.BrokerID := Tr3Sum.BrokerID;
                  // determine if long or short term
                  TrSum.lt := 'S';
                  if (TrSum.OpenDate <> 0) and (TrSum.CloseDate <> 0) then begin
                    // added 4-1-08 all short sales are S-T - IRS Publ 550 p54
                    if (TrSum.ls = 'L') //
                      and TTLDateUtils.MoreThanOneYearBetween(TrSum.OpenDate, TrSum.CloseDate) then
                      TrSum.lt := 'L'
                    else
                      TrSum.lt := 'S';
                  end
                  else begin
                    TrSum.lt := 'S';
                  end;
                  // option expirations are always ST
                  if (Pos('OPT-', TrSum.TypeMult) = 1) and (TrSum.ls = 'S') //
                    and (TrSum.CloseAmount = 0) then
                    TrSum.lt := 'S'; // 2022-01-07 MB - was .ls instead of .lt
                  // Grab the ABC Code from TrSum3 before you blow it away
                  // so it can be added to the TrSum record later.
                  abc := Tr3Sum.ABCCode;
                  // add another open G&L line to TrSumList
                  Tr3Sum := TTLTradeSummary.Create;
                  Tr3Sum.UniqueId := GetNextID;
                  Tr3Sum.TradeNum := TrSum.TradeNum;
                  Tr3Sum.Ticker := TrSum.Ticker;
                  Tr3Sum.ls := TrSum.ls;
                  Tr3Sum.TypeMult := uppercase(TrSum.TypeMult);
                  Tr3Sum.WashSaleType := TWashSaleType.wsNone;
                  Tr3Sum.OpenedShares := opSh - clSh;
                  Tr3Sum.OpenAmount := OpAm - TrSum.OpenAmount;
                  // Tr3Sum.oa:= StrFmtToFloat('%1.2f',[((opSh-clSh)/opSh)*opAm]));
                  Tr3Sum.OpenDate := TrSum.OpenDate;
                  Tr3Sum.CloseAmount := -Tr3Sum.OpenAmount;
                  Tr3Sum.Matched := TrSum.Matched;
                  Tr3Sum.BrokerID := TrSum.BrokerID;
                  Tr3Sum.ABCCode := TrSum.ABCCode;
                  Tr3Sum.code := TrSum.code; // 2022-04-01 MB - keep Open leg
                  Tr3Sum.lt := TrSum.lt;
                  Tr3Sum.Open := TrSum.Open;
                  Tr3Sum.openid := TrSum.openid;
                  // Now make a final modification to the ABC Code based on the Close record.
                  // We do this after creating the additional Open record above because we
                  // don't want the ABC Code set into the new record if it came from the
                  // Close Record.
                  if (Length(Trim(TrSum.ABCCode)) = 0) and (Length(abc) > 0) then
                    TrSum.ABCCode := abc;
                  if i < lstOrecs.Count - 1 then begin
                    lstOrecs.Insert(i + 1, Tr3Sum);
                  end
                  else begin
                    lstOrecs.Add(Tr3Sum);
                  end;
                  x := j + 1;
                  break;
                end; // case of OpenedShares
              end; // if matched lots match (or no lot)
            // ------------------------
            end; // for j
            // ------------------------
            if (TrSum.CloseDate <> 0) and (TrSum.CloseDate >= StartDate) //
            and (TrSum.CloseDate <= EndDate) then begin
              if TrSum.lt = 'L' then
                TotActualGLLT := TotActualGLLT + TrSum.ActualPL
              else
                TotActualGLST := TotActualGLST + TrSum.ActualPL;
            end
            else if (TrSum.ActualPL <> 0) then begin
              SkipActualGL := SkipActualGL + TrSum.ActualPL; // 2019-03-06 MB - debug var
            end;
            // lastTick := getUnderlyingTrade(TrSum);
            lastTick := formatTkSort(TrSum.Ticker, TrSum.TypeMult, '');
            lastLS := TrSum.ls;
            inc(i);
          end; // while i
        finally
          // We do need to free the list though
          FreeAndNil(TradeSummary3List);
        end;
      finally
        FreeAndNil(lstCrecs);
      end;
      // --------------------------------
      if EscapeKeyPressed then
        exit(false)
      else begin
        if LoadWSDeferrals and wsDeferrals then begin
          calcWSdefer; // 2014-02-01 - crashes WS Detail report
        // after running End Tax Year, so moved to end of calcWSdefer
        end;
      end;
      if EscapeKeyPressed then
        exit(false); // exit immediately!
      // Free TrSumList and transfer from our new list to the old TrSumList for now.
      frmMain.FreeTrSumList;
      TrSumList := TList.Create;
      StatBar('Rebuilding TrSumList');
      TransferToOldTRSumList(lstOrecs, TrSumList);
      Result := True;
      if (SuperUser or Developer) and (DEBUG_MODE > 3) then
        showTrSumList('after calcGains');
    finally
      FreeAndNil(lstOrecs);
      FreeAndNil(lstWrecs);
      FreeAndNil(WSDeferOpenTradeSummaryList);
    end;
  finally
    screen.cursor := crDefault;
  end;
end; // end calcGains


// ---------------------
procedure calcWSdefer;
// ---------------------
var
  i, j, c : integer;
  openSh, openWSdefer, openWSamt : Double;
  wsDefer, wsDefer2, Tr3Sum : TTLTradeSummary;
  wsDeferList : TTLTradeSummaryList;
  TrSum : TTLTradeSummary;
  lastTick, lastTickLT, longStr, cType : string;
  OldAmt, mult : Double;
  // ------------------------
  procedure AdjustHoldingDate;
  var
    HoldingDate : TDate;
  begin
    if (wsDefer.WashSaleHoldingDate = 0) then exit; // nothing to do
    HoldingDate := wsDefer.WashSaleHoldingDate;
    if (ReportStyle in [rptIRS_D1, rptSubD1, rptWashSales, rptPotentialWS, rptGAndL, rptRecon]) //
    and (lstOrecs[j].ls = 'L') and (TradeLogFile.TaxYear > 2011) //
    and (HoldingDate < lstOrecs[j].OpenDate) then begin
      // Holding period changes for Open Date.
      // If Loss Trades Open Date (TrSum) is less than Trigger Trades Open Date (Tr3Sum)
      // and year is 2012 or greater, set Trigger Trades Open Date to Loss Trades date.
      // If this change in Date also causes the trade to become Long Term, set that also.
      if (lstOrecs[j].CloseDate <> 0) //
      and TTLDateUtils.MoreThanOneYearBetween(HoldingDate, lstOrecs[j].CloseDate) //
      then begin
        lstOrecs[j].lt := 'L';
        lstOrecs[j].OpenDate := HoldingDate;
      end;
    end;
  end;
  // ------------------------
  procedure SplitTrSum;
  var
    HoldingDate : TDate;
    nRatio : double;
  begin
    if (wsDefer.WashSaleHoldingDate = 0) then exit; // nothing to do
    HoldingDate := wsDefer.WashSaleHoldingDate;
    if (ReportStyle in [rptIRS_D1, rptSubD1, rptWashSales, rptPotentialWS, rptGAndL, rptRecon]) //
    and (TradeLogFile.TaxYear > 2011) and (lstOrecs[j].ls = 'L') //
    and ((HoldingDate > 0) and (lstOrecs[j].CloseDate <> 0) //
    and TTLDateUtils.MoreThanOneYearBetween(HoldingDate, lstOrecs[j].CloseDate)) //
    then begin
      // This means we need to split the Trigger Trade so that it only has
      // the same amount of shares as the Loss Trade lstOrecs[j]
      Tr3Sum := TTLTradeSummary.Create(lstOrecs[j]);
      // Adjust Shares, since Close and open shares are the same just adjust open
      // shares and set closed shares to it.
      lstOrecs[j].OpenedShares := openWSdefer / mult; // WsDefer.OpenedShares;  //2014-03-11
      if lstOrecs[j].CloseDate <> 0 then
        lstOrecs[j].ClosedShares := lstOrecs[j].OpenedShares;
      // Adjust P and L
      nRatio := (lstOrecs[j].OpenedShares / Tr3Sum.OpenedShares); // 2018-03-30 MB Just calc once!
      lstOrecs[j].ActualPL := RndTo5(lstOrecs[j].ActualPL * nRatio);
      lstOrecs[j].Price := RndTo5(lstOrecs[j].Price * nRatio);
      // Adjust Open Amount and Closed Amount
      lstOrecs[j].OpenAmount := RndTo5(lstOrecs[j].OpenAmount * nRatio);
      if lstOrecs[j].CloseDate <> 0 then
        lstOrecs[j].CloseAmount := RndTo5(lstOrecs[j].CloseAmount * nRatio);
      // Adjust the original trade accordingly
      Tr3Sum.OpenedShares := Tr3Sum.OpenedShares - lstOrecs[j].OpenedShares;
      if Tr3Sum.CloseDate <> 0 then
        Tr3Sum.ClosedShares := Tr3Sum.OpenedShares;
      Tr3Sum.ActualPL := Tr3Sum.ActualPL - lstOrecs[j].ActualPL;
      Tr3Sum.Price := Tr3Sum.Price - lstOrecs[j].Price;
      Tr3Sum.OpenAmount := Tr3Sum.OpenAmount - lstOrecs[j].OpenAmount;
      if Tr3Sum.CloseDate <> 0 then
        Tr3Sum.CloseAmount := Tr3Sum.CloseAmount - lstOrecs[j].CloseAmount;
      // Since we are splitting this and it will be added to the file and processed next
      // lets decrease the OpenSh variable so it is not counted twice.
      openSh := openSh - Tr3Sum.OpenedShares;
      lstOrecs.Insert(j + 1, Tr3Sum);
    end
  end;
// ------------------------------------
begin
  // calcWSdefer
  try
    if (TradeLogFile.CurrentBrokerID > 0) and TradeLogFile.CurrentAccount.Ira then exit;
    wsDeferList := TTLTradeSummaryList.Create;
    WSDeferOpenTradeSummaryList := TTLTradeSummaryList.Create;
    lastTick := '';
    StatBar('Adjusting for Wash Sale Deferrals');
    openWSamt := 0;
    openWSdefer := 0;
    // loop to adjust cost basis of trades causing ws deferrals
    // note: W recs never have greater number of shares than Open recs
    for i := 0 to lstWrecs.Count - 1 do begin
      if (Frac(trunc(i / lstWrecs.Count * 100)/ 5) = 0) then
        StatBar('Adjusting for Wash Sale Deferrals '
          + InttoStr(trunc(i / lstWrecs.Count * 100)) + '% Complete');
      wsDefer := lstWrecs[i];
      if (i > 0) and (wsDefer.Ticker <> lastTick) then begin
        openSh := 0;
        openWSdefer := 0;
        if openWSamt <> 0 then
          loadWSdeferred(lastTickLT, openWSamt);
        openWSamt := 0;
      end;
      // NOTE: W recs are in either shares or contracts
      mult := wsDefer.Multiplier;
      openWSdefer := openWSdefer + wsDefer.OpenedShares * mult;
      openWSamt := openWSamt + wsDefer.OpenAmount;
      for j := 0 to lstOrecs.Count - 1 do begin
        // putting these lines first greatly speeds up the inner loop
        if (lstOrecs[j].Ticker <> wsDefer.Ticker) //
        or (lstOrecs[j].OpenDate <> wsDefer.OpenDate) //
        or (openWSdefer = 0) then
          continue;
        if (lstOrecs[j].WashSaleType = TWashSaleType.wsPrvYr) //
        or (lstOrecs[j].WashSaleType = TWashSaleType.wsThisYr)
        // do not adjust cost basis of wash sale transactions
        or (lstOrecs[j].ls <> wsDefer.ls) //
        or (lstOrecs[j].WashSaleShares >= lstOrecs[j].OpenedShares * mult) // 2013-11-18
        then
          continue;
        mult := lstOrecs[j].Multiplier;
        // 2014-03-05 fix for nasty W rec bug introduced in ver 13.3.0.2
        // do not need to add openSh from previous record
        // fix for W rec not adjusting open record wash shares
        // if lstOrecs[j].ls = 'L' then
        openSh := rndTo5(lstOrecs[j].OpenedShares * mult - lstOrecs[j].WashSaleShares);
        if (openSh = 0) then continue;
        // openSh = openWSdefer
        if rndTo5(openSh) = rndTo5(openWSdefer) //
        then begin
          if lstOrecs[j].ls = 'L' then
            lstOrecs[j].OpenAmount := lstOrecs[j].OpenAmount + openWSamt
          else
            lstOrecs[j].CloseAmount := lstOrecs[j].CloseAmount + openWSamt;
          // GetSettlementDate, checks
          // 1) LS = 'S'
          // 2) IsStockType
          // 3) Add 3 Business Days to CD.
          // If GetSettlementDate causes this Transaction to flow into next year.
          // and after applying the W Record there is a loss. then skip this so
          // it flows to next year, This needs to be done here for end of year processing
          // because we need the OpenWSAmt applied to the Close Amount first, so that
          // later on we know that this is a loss.
          if (GetSettlementDate(lstOrecs[j]) > xStrToDate('12/31/' + TaxYear, Settings.InternalFmt))
          and (lstOrecs[j].OpenAmount + lstOrecs[j].CloseAmount < 0) then
            continue;
          if openWSamt <> 0 then begin
            if (lstOrecs[j].CloseDate <> 0) then begin
              if lstOrecs[j].CloseDate > xStrToDate('12/31/' + TaxYear, Settings.InternalFmt) then
                loadWSdeferred(lstOrecs[j].lt, openWSamt);
            end;
          end;
          longStr := lstOrecs[j].ls;
          if (lstOrecs[j].CloseDate <> 0) //
          and (lstOrecs[j].CloseDate <= xStrToDate('12/31/' + TaxYear, Settings.InternalFmt)) //
          then
            openWSdefer := 0;
          // Adjust holding date if there is a holding date in the deferral record m field
          AdjustHoldingDate;
          lstOrecs[j].WashSaleType := TWashSaleType.wsCstAdjd;
          // 12-11-06 change wsh from contracts to shares to fix problem with W records and options
          // note: this fix did not completely fix the problem
          // but we will leave it as is for tax year files less than 2013
          if (TradeLogFile.TaxYear < 2013) //
          and (Pos('OPT', lstOrecs[j].TypeMult) = 1) then
            lstOrecs[j].WashSaleShares := lstOrecs[j].WashSaleShares + openSh * mult
          else
            lstOrecs[j].WashSaleShares := lstOrecs[j].WashSaleShares + openSh;
          openWSamt := 0;
          openSh := 0;
          break;
        end
        // openSh > openWSdefer
        else if rndTo5(openSh) > rndTo5(openWSdefer) //
        then begin
          // Split the TrSum record so that it matches the WSDefer record shares,
          SplitTrSum;
          // Adjust holding date if there is a holding date in the deferral record m field
          AdjustHoldingDate;
          if lstOrecs[j].ls = 'L' then
            lstOrecs[j].OpenAmount := lstOrecs[j].OpenAmount + openWSamt
          else
            lstOrecs[j].CloseAmount := lstOrecs[j].CloseAmount + openWSamt;
          // GetSettlementDate, checks
          //  1) LS = 'S'
          //  2) IsStockType
          //  3) Add 3/2/1 Business Days to CD.
          // If GetSettlementDate causes Transaction to flow into next year,
          // and applying W Record makes it a loss, then skip it so it flows
          // to next year. This needs to be done here for EoY processing
          // because we need OpenWSAmt applied to Close Amount first, so that
          // later on we know that this is a loss.
          if (GetSettlementDate(lstOrecs[j])
          > xStrToDate('12/31/' + TaxYear, Settings.InternalFmt))
          and (lstOrecs[j].OpenAmount + lstOrecs[j].CloseAmount < 0)
          then
            continue;
          if openWSamt <> 0 then begin
            if lstOrecs[j].CloseDate <> 0 then begin
              if lstOrecs[j].CloseDate > xStrToDate('12/31/' + TaxYear, Settings.InternalFmt)
              then begin
                loadWSdeferred(lstOrecs[j].lt, openWSamt);
              end;
              end;
            end;
          longStr := lstOrecs[j].ls;
          lstOrecs[j].WashSaleType := TWashSaleType.wsCstAdjd;
          lstOrecs[j].WashSaleShares := lstOrecs[j].WashSaleShares + openWSdefer;
          if (lstOrecs[j].CloseDate <> 0) //
          and (lstOrecs[j].CloseDate <= xStrToDate('12/31/' + TaxYear, Settings.InternalFmt))
          then
            openWSdefer := 0;
          openWSamt := 0;
        end
        // openSh < openWSdefer
        else if rndTo5(openSh) < rndTo5(openWSdefer) //
        then begin
          if lstOrecs[j].ls = 'L' then
            lstOrecs[j].OpenAmount := lstOrecs[j].OpenAmount + (openSh / openWSdefer * openWSamt)
          else
            lstOrecs[j].CloseAmount := lstOrecs[j].CloseAmount + (openSh / openWSdefer * openWSamt);
            // GetSettlementDate, checks
            // 1) LS = 'S'
            // 2) IsStockType
            // 3) Add 3 Business Days to CD.
            // If GetSettlementDate causes this Transaction to flow into next year.
            // and after applying the W Record there is a loss, then skip this so it
            // flows to next year. This needs to be done here for end of year processing
            // because we need the OpenWSAmt applied to the Close Amount first, so that
            // later on we know that this is a loss.
          if (GetSettlementDate(lstOrecs[j]) > xStrToDate('12/31/' + TaxYear, Settings.InternalFmt))
          and (lstOrecs[j].OpenAmount + lstOrecs[j].CloseAmount < 0) then
            continue;
          if (openSh / openWSdefer * openWSamt) <> 0 then
            if lstOrecs[j].CloseDate <> 0 then
              if lstOrecs[j].CloseDate > xStrToDate('12/31/' + TaxYear, Settings.InternalFmt) then
                loadWSdeferred(lstOrecs[j].lt, (openSh / openWSdefer * openWSamt));
          longStr := lstOrecs[j].ls;
          // Adjust holding date if there is a holding date in the deferral record m field
          AdjustHoldingDate;
          lstOrecs[j].WashSaleType := TWashSaleType.wsCstAdjd;
          lstOrecs[j].WashSaleShares := lstOrecs[j].WashSaleShares + openSh;
          // Don't need to put it back in as it was never removed.
          wsDefer.OpenAmount := (openWSdefer - openSh) / openWSdefer * openWSamt;
          openWSamt := wsDefer.OpenAmount;
          openWSdefer := rndTo5(openWSdefer - openSh);
          openSh := 0;
        end;
        lastTickLT := lstOrecs[j].lt;
        if (openWSdefer <= 0) and (openSh <= 0) then begin
          break;
        end;
      end; // end j loop thru Open recs
      lastTick := wsDefer.Ticker;
      if (openWSdefer > 0) then begin
        // sm(floatToStr(openWSdefer));
        wsDefer2 := TTLTradeSummary.Create(wsDefer);
        wsDefer2.OpenedShares := rndTo5(openWSdefer);
        WSDeferOpenTradeSummaryList.Add(wsDefer2);
        openWSdefer := 0;
      end;
    end; // end i loop thru W recs (wsDeferList
    wsDeferOpenList := TList.Create;
    TransferToOldTRSumList(WSDeferOpenTradeSummaryList, wsDeferOpenList);
    if (openWSamt <> 0) then begin
      loadWSdeferred('L', openWSamt);
    end;
    if (SuperUser or Developer) and (DEBUG_MODE > 3) then
      showTrSumList('after calcWSdefer');
  finally
    // calcWSdefer
  end;
end; // calcWSdefer


// #######################################################################################
// ####                                 CALCULATE WASH SALES                          ####
// #######################################################################################

procedure calcWashSales(StartDate, EndDate : TDateTime; Running8949 : Boolean;
  WSBetweenSL : Boolean);
var
  WSum, TrSum, Tr3Sum, Tr2Sum : PTTrSum;
  c, i, j, k, x, tkPos, crPos, DaysHeld, NextID, tickIdx, optIdx, iraIdx, wsLoop, brID,
    numRecs : integer;
  YrOpenedIn, m, D : Word;
  prof, washSh, wsTk, wsDeferAmt, Gadj, mult1, wsShLeft, mult2, totWrec : Double;
  lossDate, lastLossDate, NewHoldingDate, dtEOY, dtOpen, dtClose : TDate;
  timeStart, timeEnd : TTime;
  TrSumTick, Tr2SumTick, lastWStick, amtStr, WrecTick, cType, lastTick, currTick, elapsed : string;
  wsTrigger, StkToOp, OpToOp, OpToStk, InsertBefore, LossHasWashSale, totOnce, tickerHasStocks,
    tickerHasOptions, tickerHasIRA : Boolean;
  sERL : string;
  // ------------------------
  function GetNextID : integer;
  begin
    Result := NextID;
    inc(NextID);
  end;
// ------------------------
begin
  sERL := '3347';
  if (SuperUser or Developer) and (DEBUG_MODE > 3) then
    showTrSumList('before calcWashSales');
  try
    if (TrSumList = nil) then
      exit; // nothing to do
    c := TrSumList.Count;
    if c = 0 then
      exit; // nothing to do
    numRecs := TrSumList.Count;
    // --------------
    timeStart := now();
    SetLength(datDeferralsST, 0);
    SetLength(datDeferralsLT, 0);
    SetLength(datDeferralsIRA, 0);
    datDeferralsST := nil;
    datDeferralsLT := nil;
    datDeferralsIRA := nil;
    wsOpenL := '';
    wsOpenS := '';
    wsJanS := '';
    wsJanL := '';
    WrecTick := '';
    totWSdeferS := 0;
    totWSdeferL := 0;
    totWSdefer := 0;
    totWSLostToIra := 0;
    totWSLostToIraL := 0;
    totWSLostToIraS := 0;
    totWrec := 0;
    lastTick := '';
    currTick := '';
    lastWStick := '';
    wsDeferAmt := 0;
    Gadj := 0;
    DaysHeld := 0;
    tickIdx := 0;
    OptSales := 0;
    tickerHasStocks := false;
    tickerHasOptions := false;
    tickerHasIRA := false;
    totOnce := false;
    NextID := 0;
    // --------------------------------
    // Grab the highest ID for use later when we have to add to TrSumList.
    for i := 0 to TrSumList.Count - 1 do begin
      if PTTrSum(TrSumList[i]).id > NextID then
        NextID := PTTrSum(TrSumList[i]).id;
    end;
    inc(NextID);
    // ------------------------
    brID := TradeLogFile.CurrentBrokerID; // the account tab we are running report in
    // sOptSalesList: Calculate Option Sales not reported on 1099
    sOptSalesList := 'Date Open:' + tab + 'Ticker:' + tab + 'L/S:' + tab //
      + 'Open Amt: ' + tab + 'Close Amt: ' + tab + 'OptSalesAmt: ' + cr;
    // -----------------------
    // only calculate this ONCE (speed!)
    dtEOY := strToDate('12/31/' + InttoStr(TradeLogFile.TaxYear), Settings.InternalFmt);
    // ------------------------
    sERL := '3406';
    for i := 0 to TrSumList.Count - 1 do begin
      TrSum := TrSumList[i];
      // ----------------------------------------
      if (ReportStyle <> rptRecon) // NOT Recon
        or (TradeLogFile.TaxYear < 2014) //
        or (Pos('OPT', TrSum.prf) <> 1) // NOT option
      then begin
        if strToDate(TrSum.od) > dtEOY then
          continue; // belongs in next year
        if (TrSum.cd <> '') then begin // closed trade, but...
          if strToDate(TrSum.cd) > dtEOY then
            continue; // ...after EoY
        end;
      end; // fix for ETY
      TradeLogFile.CurrentBrokerID := StrToInt(TrSum.br);
      // ----------------------------------------
      if (ReportStyle = rptRecon) // Recon only
        and (TradeLogFile.TaxYear >= 2014) //
        and (Pos('OPT', TrSum.prf) = 1) // options only
      then begin
        if (TrSum.cd = '') then
          continue; // do not include open options...
        if (strToDate(TrSum.od) > dtEOY) then
          continue; // or next year trades
        // 2015-04-08 MB removed internalFmt for TrSum.cd
        if (TrSum.cd <> '') and (strToDate(TrSum.cd) > dtEOY) then
          continue;
        // ------------------
        if (Pos('EXERCISED', TrSum.tk) > 0) then
          continue; // no EX'd options
        // ------------------
        // broker DID NOT report options prior to 2014
        if not TradeLogFile.CurrentAccount.Options2013 //
          and (strToDate(TrSum.od) < strToDate('01/01/2014', Settings.InternalFmt)) //
        then begin
          if (TradeLogFile.CurrentAccount.ShortOptGL) //
            and (TrSum.ls = 'S') then begin
            OptSales := OptSales + TrSum.oa;
            sOptSalesList := sOptSalesList + TrSum.od + tab + TrSum.tk + tab //
              + TrSum.ls + tab + FloatToStr(TrSum.oa) + tab //
              + FloatToStr(TrSum.ca) + tab + FloatToStr(TrSum.oa) + cr;
          end
          else if (TrSum.ls = 'S') then begin
            OptSales := OptSales + TrSum.oa;
            sOptSalesList := sOptSalesList + TrSum.od + tab + TrSum.tk + tab //
              + TrSum.ls + tab + FloatToStr(TrSum.oa) + tab //
              + FloatToStr(TrSum.ca) + tab + FloatToStr(TrSum.oa) + cr;
          end
          else if (TrSum.ls = 'L') then begin
            OptSales := OptSales + TrSum.ca;
            sOptSalesList := sOptSalesList + TrSum.od + tab + TrSum.tk + tab //
              + TrSum.ls + tab + FloatToStr(TrSum.oa) + tab //
              + FloatToStr(TrSum.ca) + tab + FloatToStr(TrSum.ca) + cr;
          end;
        end
        else begin // broker DID report options prior to 2014
          if (TradeLogFile.CurrentAccount.ShortOptGL) and (TrSum.ls = 'S') then begin
            OptSales := OptSales - TrSum.ca;
            sOptSalesList := sOptSalesList + TrSum.od + tab + TrSum.tk + tab //
              + TrSum.ls + tab + FloatToStr(TrSum.oa) + tab //
              + FloatToStr(TrSum.ca) + tab + FloatToStr(-TrSum.ca) + cr;
          end;
        end; // IF broker did not report options prior to 2014
      end; // IF rptRecon, > 2014, and OPT
      // ----------------------------------------
    end; // for i := 0 to TrSumList.Count - 1
    // reset to account tab selected
    TradeLogFile.CurrentBrokerID := brID;
    i := 0;
    j := 0;
    k := 0;
    x := 0;
    lastTick := '';
    msgTxt := 'BEGIN OUTER LOOP' + CRLF;
    // ==============================================================
    sERL := '3482';
    try
      while i < c do begin // OUTER LOOP - cycle thru all records
        if (SuperUser or Developer) and (DEBUG_MODE > 0) then
          msgTxt := msgTxt + 'i = ' + InttoStr(i) + '| ';
        if StopReport then
          break; // exit this while loop
        // updateStatBarPercent('Calculating Wash Sales ', i, c);
        // --------------------
        if (Frac(trunc(i / c * 100)/ 2) = 0) then
          StatBar('Calculating Wash Sales: ' + InttoStr(trunc(i / c * 100)) + '% Complete');
        if (TrSumList <> nil) then
          TrSum := TrSumList[i];
        // --------------------
        // 2018-04-16 MB - skip certain types
        // --------------------
        if (Pos('FUT', TrSum.prf) > 0) // FUT
        or (Pos('CUR', TrSum.prf) > 0) // CUR
        or (Pos('DCY', TrSum.prf) > 0) // DCY
        then begin
          inc(i);
          continue;
        end;
        // skip if wash sale
        if (TrSum.ws = funcProc.wsPrvYr) // WS deferral carried from a Prev Year
        or (TrSum.ws = funcProc.wsThisYr) // Wash sale deferral within this year
        then begin
          inc(i);
          continue;
        end;
        currTick := getUnderlying(TrSum);
        // get record index of new ticker
        sERL := '3514';
        if currTick <> lastTick then begin
          // sm(inttostr(i)+cr+currtick+cr+lastTick);
          k := i;
          tickIdx := i;
          lastTick := currTick;
          tickerHasStocks := false;
          tickerHasOptions := false;
          tickerHasIRA := false;
          if not TradeLogFile.HasOptions then
            tickerHasStocks := True;
          // test for options
          if newSort //
            and TradeLogFile.HasOptions //
            and not tickerHasOptions then begin
            if Pos('OPT', TrSum.prf) = 0 then
              tickerHasStocks := True;
            if Pos('OPT', TrSum.prf) = 1 then
              tickerHasOptions := True
            else begin
              for j := tickIdx to TrSumList.Count - 1 do begin
                Tr2Sum := TrSumList[j];
                if Pos('OPT', Tr2Sum.prf) = 1 then begin
                  tickerHasOptions := True;
                  optIdx := j;
                  break;
                end;
                if getUnderlying(Tr2Sum) <> currTick then
                  break;
              end;
            end; // if OPT else...
          end; // if newSort...
          // --------------------------------------
          sERL := '3547';
          // test for IRA trades
          if newSort and TradeLogFile.HasAccountType[atIRA] and not tickerHasIRA then begin
            if TradeLogFile.FileHeader[StrToInt(TrSum.br)].Ira then begin
              tickerHasIRA := True;
              iraIdx := i;
            end
            else begin
              for j := tickIdx to TrSumList.Count - 1 do begin
                Tr2Sum := TrSumList[j];
                if TradeLogFile.FileHeader[StrToInt(Tr2Sum.br)].Ira then begin
                  tickerHasIRA := True;
                  iraIdx := i;
                  break;
                end;
                if getUnderlying(Tr2Sum) <> currTick then
                  break;
              end; // for j...
            end; // if IRA else...
          end; // if newSort and IRA and not tickerHasIRA
        end; // if currTick <> lastTick
        // ----------------------------------------------------------------------
        // Determine ABC code
        // ----------------------------------------------------------------------
        sERL := '3571';
        if TradeLogFile.FileHeader[StrToInt(TrSum.br)].No1099 //
          and Running8949 and (TaxYear > '2010') then
          TrSum.abc := 'C'
        else if (TaxYear > '2010') and Running8949 //
          and (Length(Trim(TrSum.abc)) = 0) then begin
          if (TradeLogFile.TaxYear = 2011) then begin
          // ------------------------------------------------------------------
          //              Opened Curr 	  Opened Prev	  Not
          //              Tax Year        Tax Year      Reported
          // ------------------------------------------------------------------
          // Stocks, Bonds     A	           B
          // Mut Funds	       B	           B            C
          // ETF/ETN's	       A	           A            B
          // Drips	           B	           B            C
          // Options	         B	           B            C
          // SSF			                                    C
          // ------------------------------------------------------------------
            if (Pos('SSF', TrSum.prf) = 1) //
              or ((Pos('OPT', TrSum.prf) = 1) //
                and not TradeLogFile.FileHeader[StrToInt(TrSum.br)].Options1099) //
              or ((Pos('MUT', TrSum.prf) = 1) //
                and not TradeLogFile.FileHeader[StrToInt(TrSum.br)].MutualFunds1099) //
              or ((Pos('DRP', TrSum.prf) = 1) //
                and not TradeLogFile.FileHeader[StrToInt(TrSum.br)].Drips1099) //
            then
              TrSum.abc := 'C'
            else if (Pos('OPT', TrSum.prf) = 1) //
              or (Pos('MUT', TrSum.prf) = 1) //
              or (Pos('DRP', TrSum.prf) = 1) //
              or ((Pos('ETF', TrSum.prf) = 1) //
                and not TradeLogFile.FileHeader[StrToInt(TrSum.br)].ETFETN1099) //
              or (xStrToDate(TrSum.od, Settings.UserFmt) < xStrToDate('01/01/2011',
                Settings.InternalFmt)) //
            then
              TrSum.abc := 'B'
            else
              TrSum.abc := 'A';
          end
          else if (TradeLogFile.TaxYear >= 2012) then begin
            // ------------------------------------------------------------------
            //                Opened Curr   Opened Prev     Not
            //                Tax Year      Tax Year   	    Reported
            // ------------------------------------------------------------------
            // Stocks, Bonds    A	           A   B < 2011
            // Mut Funds	      A	           B	             B = 2012 C = 2011
            // ETF/ETN's	      A	           A	             B
            // Drips	          A	           B	             B = 2012 C = 2011
            // Options	        B	           B	             C
            // SSF			                                     C
            sERL := '3620';
            DecodeDate(xStrToDate(TrSum.od, Settings.UserFmt), YrOpenedIn, m, D);
            // Mutual Funds Opened in 2011 go on C unless they are reported on 1099, then B
            // Drips Opened in 2011 go on C unless they are reported on 1099, then B
            if (Pos('SSF', TrSum.prf) = 1) //
            or ((Pos('OPT', TrSum.prf) = 1) //
              and not TradeLogFile.FileHeader[StrToInt(TrSum.br)].Options1099) //
            or ((Pos('MUT', TrSum.prf) = 1) and (YrOpenedIn = 2011) //
              and not TradeLogFile.FileHeader[StrToInt(TrSum.br)].MutualFunds1099) //
            or ((Pos('DRP', TrSum.prf) = 1) and (YrOpenedIn = 2011) //
              and not TradeLogFile.FileHeader[StrToInt(TrSum.br)].Drips1099) //
            then begin
              TrSum.abc := 'C';
            end
            else if (Pos('OPT', TrSum.prf) = 1) //
            or ((Pos('MUT', TrSum.prf) = 1) //
              and (((YrOpenedIn = 2011) //
                and (TradeLogFile.FileHeader[StrToInt(TrSum.br)].MutualFunds1099)) //
              or ((YrOpenedIn = 2012) //
                and not(TradeLogFile.FileHeader[StrToInt(TrSum.br)].MutualFunds1099)))) //
            or ((Pos('DRP', TrSum.prf) = 1) //
              and (((YrOpenedIn = 2011) //
                and (TradeLogFile.FileHeader[StrToInt(TrSum.br)].MutualFunds1099)) //
              or ((YrOpenedIn = 2012) //
                and not(TradeLogFile.FileHeader[StrToInt(TrSum.br)].MutualFunds1099)))) //
            or ((Pos('ETF', TrSum.prf) = 1) //
              and not TradeLogFile.FileHeader[StrToInt(TrSum.br)].ETFETN1099) //
            or (xStrToDate(TrSum.od, Settings.UserFmt) < xStrToDate('01/01/2011', Settings.InternalFmt)) //
            then begin
              // new for 2014 - Options reported on 1099
              TradeLogFile.CurrentBrokerID := StrToInt(TrSum.br);
              if (TradeLogFile.TaxYear >= 2014) and (Pos('OPT', TrSum.prf) = 1) then begin
                // 2015-04-08 removed InternalFmt from TrSum.od - MB
                if (strToDate(TrSum.od) >= strToDate('01/01/2014', Settings.InternalFmt)) then
                  TrSum.abc := 'A'
                else if TradeLogFile.CurrentAccount.Options2013 then
                  TrSum.abc := 'B'
                else
                  TrSum.abc := 'C';
              end
              else
                TrSum.abc := 'B';
            end
            else begin
              TrSum.abc := 'A';
            end;
          end; // if TradeLogFile.TaxYear >= 2012
        end; // if (TaxYear > '2010') and Running8949 and (Length(Trim(TrSum.abc)) = 0)
        // ----------------------------------------
        sERL := '3670';
        // reset to account tab selected
        TradeLogFile.CurrentBrokerID := brID;
        // add wash sales deferred from last year attached to an open position from last year
        if (TrSum.ws = funcProc.wsPrvYr) then begin
          wsDeferAmt := wsDeferAmt + TrSum.oa;
          lastWStick := TrSum.tk;
        end;
        // ----------------------------------------
        if (TrSum.cd <> '') and (TrSum.ws = 3) then
          wsDeferAmt := 0;
        if TrSum.tk <> WrecTick then
          totWrec := 0;
        // W recs attached to an open position that was never closed in
        // current tax year reported in WS Detail and Potential WS reports
        // open trade with wash sale deferral attached;
        // need to add into WS deferred total
        if (TrSum.cd = '') and (TrSum.ws = funcProc.wsPrvYr) then begin
          WrecTick := TrSum.tk;
          totWrec := totWrec + TrSum.oa; // total up W recs
        end
        else if (TrSum.cd = '') and (TrSum.tk = WrecTick) then begin
          totWSdeferS := totWSdeferS + totWrec;
          loadWSdeferList(datDeferralsST, 'o', TrSum.tk, totWrec);
          LoadSTDeferralDetails(TrSum);
          totOnce := True;
        end
        else if (TrSum.cd <> '') then begin
          totWrec := 0;
          WrecTick := '';
          totOnce := false;
        end;
        // ----------------------------------------
        if (TrSum.cd = '') // skip if trade not closed OR
        or ((TrSum.ls = 'L') // Long trade closed in prior tax year
          and (xStrToDate(TrSum.cd, Settings.UserFmt) < StartDate)) //
        then begin
          inc(i);
          continue;
        end;
        // ----------------------------------------
        // skip all short trades closed and settled in prior tax year
        if ((TrSum.ls = 'S') and (GetSettlementDate(TrSum) < StartDate)) //
        then begin
          inc(i);
          continue;
        end;
        // ----------------------------------------
        sERL := '3718';
        // Skip All trades in Next Tax Year.
        if (xStrToDate(TrSum.cd, Settings.UserFmt) > EndDate) then begin
          inc(i);
          continue;
        end;
        // ----------------------------------------
        prof := TrSum.oa + TrSum.ca; // calc profit
        if TrSum.oa = TrSum.ca then
          prof := 0;
        LossHasWashSale := false;
        // ----------------------------------------
        // ---------- TRADE HAS A LOSS ------------
        // ----------------------------------------
        sERL := '3732';
        if (prof < 0) // a loss
        and (Pos(' EXERCISED', TrSum.tk) = 0) // not an exercised option
        and (not TradeLogFile.FileHeader[StrToInt(TrSum.br)].Ira) // not an IRA
        then begin
          // get stock/option multiplier
          mult1 := getMult(TrSum.prf);
          // washSh is the total number of shares (or contracts x mult) with a loss
          // when all this number goes to zero we stop scanning for WS trigger trades
          // washSh in shares, not contracts
          washSh := RndTo5(TrSum.cs * mult1);
          // --------------------------------------
          lossDate := xStrToDate(TrSum.cd, Settings.UserFmt);
          // get record index of stock trade 30 days back from loss date
          if (lossDate > lastLossDate) then begin
            Tr3Sum := TrSumList[tickIdx];
            if (xStrToDate(Tr3Sum.od, Settings.UserFmt) < lossDate - 30) then begin
              for j := i downto 0 do begin
                Tr2Sum := TrSumList[j];
                if tickerHasStocks and (Pos('OPT', TrSum.prf) = 1) then
                  continue;
                if (xStrToDate(Tr2Sum.od, Settings.UserFmt) < lossDate - 30) then begin
                  if j > k then
                    k := j;
                  break;
                end; // if Tr2 opened before -30 days
              end; // for j loop
            end; // if Tr3 opened before -30 days
          end; // if lossDate after lastLossDate
          lastLossDate := lossDate;
          // --------------------------------------
          Gadj := 0;
          x := 1;
          j := k; // k is the record index 30 days back
          // --------------------------------------
          // cycle thru trades to find a repurchase trade which triggers a WS
          // only checks backwards and forwards 30 days for each loss trade.
          // trades sorted by ticker and date with stocks first, then options,
          // IRA trades intermingled.
          // loops 3 times - first thru stocks, then options, then IRAs
          // wsLoop:  1 = stk; 2 = opt; 3 = ira
          sERL := '3774';
          wsLoop := 0;
          while wsLoop <= 3 do begin
            if (washSh = 0) then
              break;
            inc(wsLoop);
            if (wsLoop = 1) and not tickerHasStocks and tickerHasOptions then
              wsLoop := 2
            else if (wsLoop = 2) and not tickerHasOptions then
              continue
            else if (wsLoop = 3) and not tickerHasIRA then
              break;
            if (wsLoop = 3) then
              j := iraIdx;
            // ------------------------------------
            // ---------- INNER LOOP --------------
            // ------------------------------------
            sERL := '3791';
            while j < c do begin
             // code for exiting routine when ESC key hit
              Application.ProcessMessages;
              if GetKeyState(VK_ESCAPE) and 128 = 128 then
                StopReport := True;
              if StopReport then
                break; // exit this while loop
              if (TrSumList <> nil) then
                Tr2Sum := TrSumList[j];
              // skip over IRA trades until loop 3
              if (TradeLogFile.FileHeader[StrToInt(Tr2Sum.br)].Ira) then begin
                if (wsLoop < 3) then begin
                  inc(j);
                  continue;
                end;
              end;
              OpToOp := false;
              OpToStk := false;
              StkToOp := false;
              // break when we get to next underlying ticker
              if (getUnderlying(Tr2Sum) <> getUnderlying(TrSum)) then begin
               // washSh := 0;
                break;
              end;
              // 2020-12-09 MB - skip if we don't allow underlying ticker matches
              if (bWashUnderlying = false) //
                and (Tr2Sum.tk <> TrSum.tk) then begin
                inc(j);
                continue;
              end;
              // 2018-04-16 MB - skip certain types for WS
              if (Pos('DCY', TrSum.prf) > 0) // DCY
                or (Pos('CTN', TrSum.prf) > 0) // CTN
                or (Pos('VTN', TrSum.prf) > 0) then begin
                inc(j);
                continue;
              end;
              // skip exempt 'X' trades
              if (Tr2Sum.code = 'X') then begin
                inc(j);
                continue;
              end;
              // don't create a new ws on...
              if (Tr2Sum.ws = funcProc.wsPrvYr) // ...a Prev Yr wash sale
              or (Tr2Sum.ws = funcProc.wsThisYr) // ...a current year WS
              or (Tr2Sum.ws = funcProc.wsTXF) // ...a loss trade already adjusted
              or (j = i) // ...the same trade
              or (TrSum.op = Tr2Sum.op) // ...the same open position lot
              or (Tr2Sum.code = 'X') // ...a buy marked as 'excluded from WS'
              or (Pos(' EXERCISED', Tr2Sum.tk) > 0) // ... an exercised option
              then begin
                inc(j);
                continue;
              end; // 2020-12-18 MB - end block
              // Dave's new skip code  2013-10-22
              sERL := '3847';
              if (Tr2Sum.od <> '') then begin
                // -------------------------------------
                // date less than -30 days, then continue
                if newSort then begin
                  if (wsLoop = 2) then begin // loop thru options
                    if (Pos('OPT', Tr2Sum.prf) = 0) then begin
                      inc(j);
                      continue;
                    end
                    else if (Pos('OPT', Tr2Sum.prf) = 1) //
                    and (xStrToDate(Tr2Sum.od, Settings.UserFmt) < lossDate - 30) //
                    then begin
                      inc(j);
                      continue;
                    end;
                  end
                  else if (wsLoop = 1) or (wsLoop = 3) then begin
                    if (xStrToDate(Tr2Sum.od, Settings.UserFmt) < lossDate - 30) then begin
                      inc(j);
                      continue;
                    end;
                  end;
                end
                else begin // not newSort
                  if (xStrToDate(Tr2Sum.od, Settings.UserFmt) < lossDate - 30) then begin
                    inc(j);
                    continue;
                  end;
                end;
                // -------------------------------------
                // date greater than +30 days
                sERL := '3879';
                if newSort then begin
                  if (wsLoop = 1) then begin // loop thru stocks only
                    // break when stock trade open date > 30 days from loss
                    if (Pos('OPT', Tr2Sum.prf) = 0) //
                    and (xStrToDate(Tr2Sum.od, Settings.UserFmt) > lossDate + 30) //
                    then begin
                      break;
                    end
                    else begin
                      // break when we get to the option trades
                      if (Pos('OPT', Tr2Sum.prf) = 1) then begin
                        break;
                      end;
                    end;
                  end
                  else if (wsLoop = 2) then begin // loop thru options only
                    if (Pos('OPT', Tr2Sum.prf) = 0) then begin
                      inc(j);
                      continue;
                    end
                    else if (Pos('OPT', Tr2Sum.prf) = 1) //
                    and (xStrToDate(Tr2Sum.od, Settings.UserFmt) > lossDate + 30) //
                    then begin
                      break;
                    end;
                  end
                  else if (wsLoop = 3) then begin // loop thru all IRA trades,
                    // including both stocks and options
                    if not(TradeLogFile.FileHeader[StrToInt(Tr2Sum.br)].Ira) //
                      or (xStrToDate(Tr2Sum.od, Settings.UserFmt) > lossDate + 30) //
                    then begin
                      inc(j);
                      continue;
                    end;
                  end;
                end
                else begin // not newSort
                  if (xStrToDate(Tr2Sum.od, Settings.UserFmt) > lossDate + 30) then begin
                    inc(j);
                    continue;
                  end;
                end;
              end; // if (Tr2Sum.od <> '')
              // ------------------------------------------------------
              // Don't move WS back to a previous tax year   05-23-08
              // if the trade is closed in the previous year   revised 7-10-08
              sERL := '3929';
              if (Tr2Sum.cd <> '') then begin
                if (xStrToDate(Tr2Sum.od, Settings.UserFmt) < StartDate) //
                and (xStrToDate(Tr2Sum.cd, Settings.UserFmt) < StartDate) //
                then begin
                  inc(j);
                  continue;
                end;
              end;
              mult2 := getMult(Tr2Sum.prf);
              // ------------------------------------------------------
              // WS between stock and options     // <-- skip if using brokerage rules
              if ((Pos('STK', TrSum.prf) = 1) or (Pos('MUT', TrSum.prf) = 1) //
              or (Pos('ETF', TrSum.prf) = 1) or (Pos('DRP', TrSum.prf) = 1)) //
              and (Pos('OPT', Tr2Sum.prf) = 1) then begin
                StkToOp := True;
              end
              // WS between options and options   // <-- skip if using brokerage rules and not exact same options
              else if (Pos('OPT', TrSum.prf) = 1) //
                and (Pos('OPT', Tr2Sum.prf) = 1) then begin
                OpToOp := True;
              end
              // WS between options and stocks    // <-- skip if using brokerage rules
              else if (Pos('OPT', TrSum.prf) = 1) //
                and ((Pos('STK', Tr2Sum.prf) = 1) or (Pos('MUT', Tr2Sum.prf) = 1) //
                  or (Pos('ETF', Tr2Sum.prf) = 1) or (Pos('DRP', Tr2Sum.prf) = 1)) //
              then begin
                OpToStk := True;
              end;
              // ------------------------------------------------------
              // don't adjust a loss trade that has already had all it's shares adjusted
              // NOTE: wsh in shares and os in shares or contracts
              // 2015-05-18 - this is now worthless code becuase Tr2Sum.wsh is never updated
              if (Tr2Sum.wsh >= Tr2Sum.os * mult2) then begin
                inc(j);
                continue;
              end;
              // ------------------------------------------------------
              // don't create a WS on an option expiration
              if (Pos('OPT', Tr2Sum.prf) = 1) and (Tr2Sum.ls = 'S') //
                and (Tr2Sum.ca = 0) and (TrSum.ls = 'L') then begin
                inc(j);
                continue;
              end;
              // ------------------------------------------------------
              // don't create a WS between long stock and long put
              if StkToOp //
              and ( (bWashStock2Opt = false) // skip these     //
                or ((TrSum.ls = 'L') // long stock     //
                  and (Tr2Sum.ls = 'L') // and long...    //
                  and (Pos(' PUT', Tr2Sum.tk) > 0)) // ...put         //
              ) then begin
                inc(j);
                continue;
              end;
              // ------------------------------------------------------
              // don't create a WS between long call and long put
              if OpToOp
              and (TrSum.ls = 'L') and (Pos(' CALL', TrSum.tk) > 0) //
              and (Tr2Sum.ls = 'L') and (Pos(' PUT', Tr2Sum.tk) > 0) //
              then begin
                inc(j);
                continue;
              end;
              // ------------------------------------------------------
              // skip Opt to Stock if flag is false
              if OpToStk and not bWashOpt2Stock then begin
                inc(j);
                continue;
              end;
              // ------------------------------------------------------
              if (TrSum.code = 'X') then begin
                inc(j);
                continue;
              end;
              // ============================================
              sERL := '4005';
              try
                // are there any WS shares left to trigger new wash sale?
                // 2015-05-18 - Tr2Sum.wsh is never updated
                // Tr2Sum.os gets decremented for each wash sale in line 4219 below
                // therefore wsShLeft is actually Tr2Sum.os
                wsShLeft := (Tr2Sum.os * mult2) - Tr2Sum.wsh;
                if (RndTo5(wsShLeft) > 0) then
                  wsTrigger := True
                else
                  wsTrigger := false;
                // WS was triggered
                if wsTrigger then begin
                  if (TrSum.ls = 'L') then begin
                    // no WS between Long and Shorts
                    if (Tr2Sum.ls = 'S') //
                    then begin
                      inc(j);
                      continue;
                    end;
                  end
                  else if (TrSum.ls = 'S') then begin
                    // if a long and shortLongs not checked no ws
                    if not(ReportStyle in [rptWashSales, rptIRS_D1, rptPotentialWS]) //
                    and not WSBetweenSL and (Tr2Sum.ls = 'L') then begin
                      inc(j);
                      continue;
                    end;
                    // added due to open trades have no close amount
                    if (TrSum.ca > 0) and (TrSum.oa + TrSum.ca < 0) then begin
                      inc(j);
                      continue;
                    end;
                    // Since the loss trade closes in next year based on Settlement Date,
                    // Don't generate a wash sale since it will be generated next year.
                    if (TradeLogFile.TaxYear > 2011) //
                      and (GetSettlementDate(TrSum) > xStrToDate('12/31/' + TaxYear,
                        Settings.InternalFmt)) //
                      and (TrSum.oa + TrSum.ca < 0) then begin
                      inc(j);
                      continue;
                    end;
                  end;
// <-- END OF FUNCTION
                  // flag to not adjust the cost basis of any loss trade that has already been WS adjusted
                  TrSum.ws := funcProc.wsTXF;
                  // create a new wash sale //
                  New(WSum);
                  FillChar(WSum^, SizeOf(WSum^), 0);
                  WSum.id := GetNextID;
                  WSum.ws := funcProc.wsThisYr;
                  WSum.tr := Tr2Sum.tr;
                  WSum.prf := Tr2Sum.prf;
                  WSum.tk := Tr2Sum.tk;
                  WSum.ls := Tr2Sum.ls;
                  WSum.cm := Tr2Sum.cm;
                  WSum.lt := TrSum.lt;
                  WSum.wstriggerid := Tr2Sum.id;
                  WSum.os := Tr2Sum.os;
                  WSum.cs := Tr2Sum.cs;
                  WSum.oa := Tr2Sum.oa; //
                  WSum.ca := Tr2Sum.ca;
                  WSum.br := Tr2Sum.br;
                  WSum.code := Tr2Sum.code; // 2022-03-24 MB
                  if (TrSum.ls = 'L') then begin
                    if (Tr2Sum.ls = 'L') then begin
                      // wSum.od tracks original loss trade open date for W record deferrals
                      // wSum.cd tracks trigger trade open date
                      WSum.od := Tr2Sum.od;
                      WSum.cd := Tr2Sum.cd;
                    end
                    else begin
                      WSum.od := Tr2Sum.cd;
                      WSum.cd := Tr2Sum.od;
                    end;
                  end
                  else if (TrSum.ls = 'S') then begin
                    if (Tr2Sum.ls = 'L') then begin
                      WSum.od := Tr2Sum.od;
                      WSum.cd := Tr2Sum.cd;
                    end
                    else begin
                      WSum.od := Tr2Sum.od;
                      WSum.cd := Tr2Sum.cd;
                    end;
                  end;
                  // Initially set Wash Sale Holding Date to Open Date.
                  // Later if the WS Date needs adjusting we will do this.
                  WSum.wsd := WSum.od;
                  // if loss trades was already long term then wash sale must be long term,
                  // but after 2011 we are handling this in the holding date adjutment code so
                  // only do this for 2011 and earlier files.
                  if TradeLogFile.TaxYear < 2012 then begin
                    if TrSum.lt = 'L' then begin
                      WSum.lt := 'L';
                      Tr2Sum.lt := 'L';
                    end;
                  end;
                  // calc wash sale amount - note: variables wsSh and washSh in shares
                  if (TrSum.cs <> 0) then begin
                    wsShLeft := (Tr2Sum.os * mult2) - Tr2Sum.wsh;
                    // sm('wsShLeft = '+floatToStr(wsShLeft));
                    if (washSh >= wsShLeft) then begin
                      WSum.oa := prof * wsShLeft / (TrSum.cs * mult1);
                      WSum.os := wsShLeft / mult2;
                      WSum.cs := wsShLeft / mult2;
                      Tr2Sum.wsh := Tr2Sum.wsh + wsShLeft;
                    end
                    else if (washSh < wsShLeft) then begin
                      WSum.oa := prof * washSh / (TrSum.cs * mult1);
                      WSum.os := washSh / mult2;
                      WSum.cs := washSh / mult2;
                      Tr2Sum.wsh := Tr2Sum.wsh + washSh;
                    end;
                  end;
                  // --------------------------------------------
                  WSum.pr := 0; // WSum.oa;
                  WSum.ca := 0; // 2-13-07
                  // Tr3Sum Becomes Wash Sale Portion of Tr2Sum
                  // Ca, and OA Amount are adjusted based on number of shares and then
                  // Amounts are adjusted for CstAdjd
                  // Holding date is changed for this record to WSum Date.
                  // // *** change holding period of trade that triggered wash sale
                  // //TrSum is trade with loss, Tr2Sum is trade that triggered the
                  // // Wash Sale the repurchase.
                  // TRSUM: 1 Jan 1 O L MSFT 100 10
                  // 1 Jan 2 C L MSFT 100 9
                  // TR2SUM: 2 Jan 15 O L MSFT 100 11  (WS Valid Trigger)
                  // Change Open Date of Jan 15 Trade and knock it back to Jan 1.
                  // 100 Shares bought and sold at a loss, repurchased 15 days later 200,
                  // So TradeLog currently adjusts cost basis for entire 200.
                  // Now the Holding period Date should it change for all 200.
                  // If Trigger trade is before Loss trade then don't change the date as
                  // you do not move the date up.
                  // FOR 2012 and Greater Tax Year Only
                  if (ReportStyle in [rptIRS_D1, rptSubD1, rptWashSales, rptGAndL, rptRecon,
                    rptPotentialWS]) //
                  and ((Tr2Sum.os > TrSum.os) or (WSum.os < Tr2Sum.os)) //
                  and (TradeLogFile.TaxYear > 2011) //
                  and (xStrToDate(TrSum.od, Settings.UserFmt) < xStrToDate(Tr2Sum.od,
                    Settings.UserFmt)) //
                  and (Tr2Sum.cd <> '') //
                  and TTLDateUtils.MoreThanOneYearBetween(xStrToDate(TrSum.od, Settings.UserFmt),
                    xStrToDate(Tr2Sum.cd, Settings.UserFmt)) //
                  then begin
                    // Capture the reason why this is being split so we know where to insert the
                    // new record. If the TriggerTrade os is greater than the loss trade.os then
                    // insert after the current trigger trade, or if the TriggerTrade.os > the
                    // Amount to Wash then insert Before the current Trigger Trade
                    InsertBefore := WSum.os < Tr2Sum.os;
                    // This means we need to split the Trigger Trade so that it only has
                    // the same amount of shares as the Loss Trade Tr2Sum
                    New(Tr3Sum);
                    FillChar(Tr3Sum^, SizeOf(Tr3Sum^), 0);
                    // This makes a copy of the contents of the record pointed to by Tr2Sum into Tr3Sum
                    Tr3Sum^ := Tr2Sum^;
                    // Adjust Shares, since Close and open shares are the same just adjust open
                    // shares and set closed shares to it.
                    Tr3Sum.os := WSum.os;
                    Tr3Sum.id := GetNextID;
                    WSum.wstriggerid := Tr3Sum.id;
                    if Tr3Sum.cd <> '' then
                      Tr3Sum.cs := Tr3Sum.os;
                    // Adjust Actual Profit and Loss
                    Tr3Sum.ActualPL := RndTo5(Tr3Sum.ActualPL * (Tr3Sum.os / Tr2Sum.os));
                    Tr3Sum.pr := RndTo5(Tr3Sum.pr * (Tr3Sum.os / Tr2Sum.os));
                    // Adjust Open Amount and Closed Amount
                    Tr3Sum.oa := RndTo5(Tr3Sum.oa * (Tr3Sum.os / Tr2Sum.os));
                    if Tr3Sum.cd <> '' then
                      Tr3Sum.ca := RndTo5(Tr3Sum.ca * (Tr3Sum.os / Tr2Sum.os));
                    // Adjust the original trade accordingly
                    Tr2Sum.os := Tr2Sum.os - Tr3Sum.os;
                    Tr2Sum.wsh := 0;
                    // 2015-05-19 need to reset wsh to zero when decrementing os
                    Tr2Sum.ActualPL := Tr2Sum.ActualPL - Tr3Sum.ActualPL;
                    Tr2Sum.pr := Tr2Sum.pr - Tr3Sum.pr;
                    if Tr2Sum.cd <> '' then
                      Tr2Sum.cs := Tr2Sum.os;
                    Tr2Sum.oa := Tr2Sum.oa - Tr3Sum.oa;
                    if Tr2Sum.cd <> '' then
                      Tr2Sum.ca := Tr2Sum.ca - Tr3Sum.ca;
                    if InsertBefore then
                      TrSumList.Insert(j, Tr3Sum)
                    else
                      TrSumList.Insert(j + 1, Tr3Sum);
                    if j <= i then
                      inc(i);
                    c := TrSumList.Count;
                  end
                  else
                    Tr3Sum := TrSumList[j];
                  // ------------------
                  if (TradeLogFile.TaxYear > 2011) then begin
                    sERL := '4197';
                    try
                      // Holding period changes for Open Date.
                      // If Loss Trade Open Date (TrSum) < Trigger Trade Open Date (Tr3Sum)
                      // and TaxYear >= 2012, subtract from he Trigger Trades Open Date the
                      // number of days the Loss Trade was Open. If this causes the trade
                      // to become Long Term, set this also.
                      if (xStrToDate(TrSum.od, Settings.UserFmt) < xStrToDate(Tr3Sum.od,
                          Settings.UserFmt)) then begin
                        NewHoldingDate := xStrToDate(Tr3Sum.od, Settings.UserFmt) // This is the
                          - (xStrToDate(TrSum.cd, Settings.UserFmt) // 'Tacking Method'
                            - xStrToDate(TrSum.od, Settings.UserFmt)); // for WS Hold Dt.
                        // set Wash Sale Date so that, when end of year generates W records,
                        // it can be carried forward to next year.
                        if (Tr3Sum.ls = 'L') and (TrSum.ls = 'L') then
                          WSum.wsd := DateToStr(NewHoldingDate, Settings.UserFmt);
                        // Only modify the TrSum array if we are printing IRSd1 or Sub D1
                        if (ReportStyle in [rptIRS_D1, rptSubD1, rptWashSales, rptGAndL, rptRecon,
                            rptPotentialWS]) then begin
                          if (Tr3Sum.cd <> '') //
                          and TTLDateUtils.MoreThanOneYearBetween(NewHoldingDate,
                            xStrToDate(Tr3Sum.cd, Settings.UserFmt)) //
                            and (Tr3Sum.ls = 'L') and (TrSum.ls = 'L') then begin
                            Tr3Sum.lt := 'L';
                            Tr3Sum.od := DateToStr(NewHoldingDate, Settings.UserFmt);
                          end;
                        end;
                      end
                    except
                      on E : Exception do begin
                        sm('Error computing new holding date.' + CR //
                          + E.Message + CR //
                          + 'in ticker ' + Tr3Sum.tk + CR //
                          + 'open date: ' + Tr3Sum.od + CR //
                          + 'close date: ' + Tr3Sum.cd //
                        );
                      end;
                    end;
                  end;
                  sERL := '4231';
                  // adj cost basis of the trigger trade
                  Tr3Sum.ws := funcProc.wsCstAdjd;
                  // total sales must match with or without ws
                  if (Tr3Sum.ls = 'L') then
                    Tr3Sum.oa := Tr3Sum.oa + WSum.oa
                  else if (Tr3Sum.ls = 'S') then
                    Tr3Sum.ca := Tr3Sum.ca + WSum.oa;
                  Tr3Sum.pr := Tr3Sum.pr + WSum.oa;
                  // END adj cost basis of trigger trade
                  // -----------------------------------
                  sERL := '4242';
                  // Wash Sales Permanently Lost to IRA
                  try
                    if TradeLogFile.FileHeader[StrToInt(Tr2Sum.br)].Ira then begin
                      totWSLostToIra := totWSLostToIra + WSum.oa;
                      loadWSdeferList(datDeferralsIRA, 'j', WSum.tk, WSum.oa);
                      LoadIRADeferralDetails(TrSum, WSum);
                      if WSum.lt = 'L' then begin
                        totWSLostToIraL := totWSLostToIraL + WSum.oa;
                      end
                      else if WSum.lt = 'S' then begin
                        totWSLostToIraS := totWSLostToIraS + WSum.oa;
                      end;
                    end
                    // wash sale caused by Jan repurchase
                    else if (WSum.od <> '') //
                      and (xStrToDate(WSum.od, Settings.UserFmt) > EndDate) //
                      and (xStrToDate(WSum.od, Settings.UserFmt) < EndDate + 31) //
                    then begin
                      if (WSum.lt = 'L') then begin
                        totWSdeferL := totWSdeferL + WSum.oa;
                        loadWSdeferList(datDeferralsLT, 'j', WSum.tk, WSum.oa);
                      end
                      else if (WSum.lt = 'S') then begin
                        totWSdeferS := totWSdeferS + WSum.oa;
                        loadWSdeferList(datDeferralsST, 'j', WSum.tk, WSum.oa);
                      end;
                      totWSdefer := totWSdefer + WSum.oa;
                      WSum.ny := True;
                    end
                    // wash sale attached to open trade
                    else if (RndTo5(Tr3Sum.cs) <> RndTo5(Tr3Sum.os)) //
                      or ((Tr3Sum.cd <> '') and (xStrToDate(Tr3Sum.cd, Settings.UserFmt) > EndDate)
                      //
                        and (xStrToDate(WSum.od, Settings.UserFmt) < EndDate + 31)) //
                    then begin
                      if (WSum.lt = 'L') then begin
                        totWSdeferL := totWSdeferL + WSum.oa;
                        loadWSdeferList(datDeferralsLT, 'o', WSum.tk, WSum.oa);
                      end
                      else if (WSum.lt = 'S') then begin
                        totWSdeferS := totWSdeferS + WSum.oa;
                        loadWSdeferList(datDeferralsST, 'o', WSum.tk, WSum.oa);
                      end;
                      LoadSTDeferralDetails(WSum);
                      totWSdefer := totWSdefer + WSum.oa;
                      WSum.ny := True;
                    end
                    else begin
                      WSum.ny := false;
                    end;
                  except
                    on E : Exception do begin
                      sm('Error computing wash sales lost to IRA.' + CR //
                        + E.Message + CR //
                        + 'in ticker ' + Tr3Sum.tk + CR //
                        + 'open date: ' + Tr3Sum.od + CR //
                        + 'close date: ' + Tr3Sum.cd //
                      );
                    end;
                  end;
                  sERL := '4298';
                  // washSh = number of loss shares remaining
                  if washSh > 0 then
                    washSh := RndTo5(washSh - (WSum.os * mult2));
                  // 2015-04-15 MB
                  // When running routine for reporting the 8949 we want to create an
                  // adjustment column for the existing TrSum, therefore if this routine
                  // was run just before the report then we will create the adjustment column
                  // added for Form 8949
                  if (TaxYear > '2010') and Running8949 then begin
                    TrSum.code := 'W';
                    Gadj := Gadj - WSum.oa;
                    TrSum.adjG := Gadj;
                  end;
                  if (wsLoop = 1) and (j > k) then
                    k := j;
                  // insert wash sale
                  TrSumList.Insert(i + x, WSum);
                  LossHasWashSale := True;
                  inc(x);
                  c := TrSumList.Count;
                  if RndTo5(washSh) <= 0 then begin
                    washSh := 0;
                    break;
                  end;
                end; // end trigger wash sale
              except
                on E : Exception do begin
                  sm('ERROR: ' + E.Message + CR //
                    + InttoStr(E.HelpContext));
                  exit;
                end;
              end; // =============================
              inc(j);
              if RndTo5(washSh) <= 0 then
                break;
            end; // while j < c
          end;
        // If Wash Sale does not exist for this loss then add to potential ws Losses
          if (ReportStyle <> rptPotentialWS) // when running Potential WS report...
            or (Pos('VTN', TrSum.prf) <> 1) then begin // 2018-12-18 MB - ...Skip VTNs
            if not LossHasWashSale then
              LoadNewTradesDeferralDetails(TrSum, nil)
            else if ((TrSum.os * mult1) - (WSum.os * mult2) > 0) then
              LoadNewTradesDeferralDetails(TrSum, WSum); // 2015-04-15 MB
          end; // 2018-12-18 MB END of Change
        end; // if (prof < 0) - Trade has a loss
        washSh := 0;
        inc(i);
      end; // while i < c
    except
      on E : Exception do begin
        sm('Error in CalcWashSales' + CR //
          + 'near line ' + sERL + CR //
          + E.Message + CR //
          + 'in ticker ' + Tr3Sum.tk + CR //
          + 'open date: ' + Tr3Sum.od + CR //
          + 'close date: ' + Tr3Sum.cd //
        );
      end;
    end;
    // ==============================================================
    timeEnd := now();
    elapsed := TimeToStr(timeEnd - timeStart, Settings.UserFmt);
    StatBar('Wash Sales Done');
    if (SuperUser or Developer) and (DEBUG_MODE > 3) then
      showTrSumList('after calcWashSales');
  finally
    clipBoard.AsText := sOptSalesList;
  end;
end; // end calcWashSales


initialization


end.
