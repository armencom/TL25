unit Reports;

interface

uses
  // Standard Delphi Units
  Windows, Classes, Forms, Graphics, Math, StrUtils, SysUtils, Variants, DateUtils, Controls,
  TeEngine, TeeProcs, DbChart, TeeFunci, TeeStore, funcProc, dialogs;

type
  // Futures Records
  Texercises = packed record
    it : string;
    sh, exAmt : double;
  end;

  pExer = ^Texercises;

  TReportStyle = (rptNone, rptEmpty, rptDateDetails, rptTickerDetails, rptTradeDetails, rptMTM, rptTickerSummary,
    rptTradeSummary, rpt481Adjust, rptIRS_D1, rptSubD1, rptGAndL, rptFutures, rptCurrencies, rptWashSales,
    rpt8949statement, rpt4797, rptDeferred, rptHorizChart, rptPerformance, rptVertCharts, rptRecon, rptPotentialWS);

function GainsReportAvailable(var StartingLineNumber:Integer; bMTM:boolean=false): Boolean;
function GetGainsData(GainsIndex:Integer; var NextLineNumber:Integer; bMTM:boolean=false): Boolean;
procedure GetReportSummary;
procedure ParseWsLists();
procedure reportCancelledMsg;
function reportStoppedCheck : boolean;
function PrepareForGainsReports(SDate,EDate:TDate; IncludeWashSales,WSBetweenLS:Boolean): Boolean;
procedure Run1099Recon;
procedure RunReport(SDate : TDate; EDate : TDate; IncludeWashSales : Boolean = False; WSBetweenSL : Boolean = True;
  IncludeAdjustment : Boolean = False);
procedure StoreReportSummary;
procedure checkForFutCur;
procedure SetWashSaleLineNumbers(datGL : TTglReportArray; bAsk : boolean);

var
  // Used by 1099 Recon, and In Fast Reports
  CostTot, AdjGTot, optExAssSales, SalesST, SalesLT, OptSales, OshSales, OShNextYrSales, SecMTM, NetSales, DiffSales,
    SlsprTot, GainMay5Tot, ProfTot, GainTot, LossTot, TotActualGLST, TotActualGLLT : double;
    SkipActualGL : double; // 2019-03-06 MB - debug var
  noST, noLT : Boolean;
  ClipStr : TStringList;
  ReportStyle : TReportStyle;
  rptIncludeWashSales, bWSLineNums : Boolean;
  Title, sOptSalesList : String;

  // For reports GL Data
  datGL : TTglReportArray;
  datSummary : TTSummaryReportArray;
  glReportRows, CSVlines, TXFlines : Integer;

implementation

uses
  dxcore,
  // Tradelog Units
  ChartTimes, Main, TlCharts, TLRegister, cxCustomData, recordClasses,
  TLLogging, globalVariables,
  FastReportsData, TLSettings, TLCommonLib, TLFile, GainsLosses,
  System.Generics.Collections, FastReportsPreview;

const
  CODE_SITE_CATEGORY = 'Reports';

var
  lastWStick : string;
  rptGroupDone, rptSectionDone : Boolean;
  myStkSales, myOptSales, myShortSales : double;
  GainMay5, Prof, OpenTotST, OpenTotLT, JanTotST, JanTotLT, GlST, WsST, GlLT, WsLT, GlTot, accuTotalComm, curFloat,
    accuTrCost, accuTrPL, accuTrSales, accuTrShares, MTM_Long, MTM_Short : double;

  adjG : double;
  codeB : string;
  curntTrNum : Integer;

  { Report variables }
  RptRowsDone, RptRowCount, ReportTag, DefrStCount, DefrLtCount, rptSumItem, rptRow : Integer;

  LongMTM, RequireNew : Boolean;
  OpenStr, Desc, LastTick, curntData, curntLS, curntOC, curntTick : String;
  rptEndDate, lastEndDate : TDate;


//procedure ExtractNumberParts(value : String; var wholePart, decimalPart : String; decimalSeperator : Char);
//var
//  x : Integer;
//begin
//  x := pos(decimalSeperator, value);
//  if x > 0 then begin
//    decimalPart := RightStr(value, Length(value) - x);
//    wholePart := LeftStr(value, x - 1);
//  end
//  else begin
//    decimalPart := '00';
//    wholePart := value;
//  end;
//end;


// ------------------------------------
// Set line #s for WS (also CopyStr)
// ------------------------------------
procedure SetWashSaleLineNumbers(datGL: TTglReportArray; bAsk : boolean);
var
  GainsIndex, ClipStrIndex: Integer;
  WashSaleRow: TTglReport;
  TrSum: PTTrSum;
  sTmp, sWSid: string;
  dtOpen, dtEOY : TDateTime;
begin
  if stopReport then exit;
  if (TrSumList.count > 30000) then begin
    if bAsk then begin
      bWSLineNums := (mdlg('This file contains ' + IntToStr(TrSumList.count) + ' trades.' + CR //
        + CR //
        + 'It could take a long time to calculate the wash sale line numbers.' + CR //
        + CR //
        + 'If you would like to wait for TradeLog to include wash sale line' + CR //
        + 'numbers, click Yes.' + CR //
        + CR //
        + 'If you would like to skip the line numbers, click No.', //
        mtConfirmation, [mbYes, mbNo], 0) = mrYes);
    end;
    if not(bWSLineNums) then exit;
  end;
  if (ReportStyle <> rptIRS_D1) then begin
    StatBar('Linking Wash Sale Rows to Line Numbers - Please Wait . . .');
    ClipStrIndex := 0; // use to keep track of ClipStr
    for GainsIndex := 0 to Length(datGL) - 1 do begin
      if (datGL[GainsIndex].wstriggerid > 0) then begin
        WashSaleRow := datGL[GainsIndex];
        for TrSum in TrSumList do begin
          if (TrSum.id = WashSaleRow.wstriggerid) then begin
            dtOpen := xStrToDate(TrSum.od, settings.UserFmt);
            dtEOY := xStrToDate('12/31/' + Taxyear, settings.InternalFmt);
            // note: by starting where the last search left off, it should
            // improve both speed and accuracy.
            for ClipStrIndex := (ClipStrIndex+1) to (ClipStr.Count-1) do begin
              if  (POS(WashSaleRow.dtAcq, ClipStr[ClipStrIndex]) > 0)
              and (POS(WashSaleRow.dtSld, ClipStr[ClipStrIndex]) > 0)
              and (POS('[', ClipStr[ClipStrIndex]) < 1)
              and (POS('Adj - ', ClipStr[ClipStrIndex]) > 0) then break;
            end;
            //----- did we find a match? --------
            if ClipStrIndex >= ClipStr.Count then ClipStrIndex := 0;
            if ClipStrIndex > 0 then sTmp := ClipStr[ClipStrIndex];
            // ----------------------------------
            if (TrSum.wstriggerid > 0) then begin
              sWSid := ' [' + IntToStr(TrSum.wstriggerid);
              if TradeLogFile.FileHeader[strToInt(TrSum.br)].Ira then begin
                Insert(sWSid + ' IRA]', WashSaleRow.Desc, pos('-', WashSaleRow.Desc) + 1);
                if ClipStrIndex > 0 then
                  Insert(sWSid + ' IRA]', sTmp, pos('-', sTmp) + 1);
              end
              else if (dtOpen > dtEOY) then begin
                Insert(sWSid + ' JAN]', WashSaleRow.Desc, pos('-', WashSaleRow.Desc) + 1);
                if ClipStrIndex > 0 then
                  Insert(sWSid + ' JAN]', sTmp, pos('-', sTmp) + 1);
              end
              else if (TrSum.cd = '') then begin
                Insert(sWSid + ' OPEN]', WashSaleRow.Desc, pos('-', WashSaleRow.Desc) + 1);
                if ClipStrIndex > 0 then
                  Insert(sWSid + ' OPEN]', sTmp, pos('-', sTmp) + 1);
              end
              else begin
                Insert(sWSid + ']', WashSaleRow.Desc, pos('-', WashSaleRow.Desc) + 1);
                if ClipStrIndex > 0 then
                  Insert(sWSid + ' ]', sTmp, pos('-', sTmp) + 1);
              end;
            end
            else if TradeLogFile.FileHeader[strToInt(TrSum.br)].Ira then begin
              Insert(' [IRA]', WashSaleRow.Desc, pos('-', WashSaleRow.Desc) + 1);
              if ClipStrIndex > 0 then
                Insert(' [IRA]', sTmp, pos('-', sTmp) + 1);
            end
            else if (dtOpen > dtEOY) then begin
              Insert(' [JAN]', WashSaleRow.Desc, pos('-', WashSaleRow.Desc) + 1);
              if ClipStrIndex > 0 then
                Insert(sWSid + ' [JAN]', sTmp, pos('-', sTmp) + 1);
            end
            else begin
              Insert(' [OPEN]', WashSaleRow.Desc, pos('-', WashSaleRow.Desc) + 1);
              if ClipStrIndex > 0 then
                Insert(sWSid + ' [OPEN]', sTmp, pos('-', sTmp) + 1);
            end;
            if ClipStrIndex > 0 then ClipStr[ClipStrIndex] := sTmp;
            Break;
          end; // if id = wstriggerid
        end; // for...do
        datGL[GainsIndex] := WashSaleRow;
      end; // if wstriggerid
    end; // for GainsIndex.
  end; // if ReportStyle
end;


// ------------------------------------
// Get S-T and/or L-T Gains; Return False if None
// ------------------------------------
function GainsReportAvailable(var StartingLineNumber: Integer; bMTM: boolean=false) : Boolean;
var
  GainsIndex : Integer;
  Year2003 : Boolean;
  TrSum : PTTrSum;
  WashSaleRow : TTglReport;
begin
  if stopReport then exit;
  Result := False;
  CostTot := 0;
  ProfTot := 0;
  GainTot := 0;
  LossTot := 0;
  SlsprTot := 0;
  GainMay5Tot := 0;
  AdjGTot := 0;
  ReportTag := tagRptNone;
  if TrSumList = nil then exit; // No data, exit
  getCurrTaxyear;
  Year2003 := Taxyear = '2003';
  // ---- Start ClipStr ---------------
  if ClipStr.count = 0 then begin
    ClipStr := TStringList.Create;
    ClipStr.Capacity := 0;
  end;
  // Header for Saving report to Clipboard from within Preview
  msgTxt := '(a) Desc of Property' + Tab + Tab + Tab + Tab + Tab + '(b) Date acq' + Tab + '(c) Date sold' + Tab +
    '(d) Sales price' + Tab;
  if ReportStyle = rpt4797 then begin
    msgTxt := msgTxt + '(f) Cost or other basis' + Tab + '(g) GAIN or (LOSS)';
    If Year2003 then msgTxt := msgTxt + Tab + '(g) Post-May 5 gain or (loss)';
  end
  else begin
    msgTxt := msgTxt + '(e) Cost or other basis' + Tab + '(f) GAIN or (LOSS)';
  end;
  if DoST and not noST then
    ClipStr.Append('Short-Term Gains & Losses:' + crlf + msgTxt)
  else if DoLT and not noLT then
    ClipStr.Append(cr + lf + 'Long-Term Gains & Losses:' + crlf + msgTxt);
  // ---- Start ClipStr ---------------
  if (ReportStyle in [rpt481Adjust .. rpt4797, rptMTM])
  and rptIncludeWashSales
  and (EndDate = xStrToDate('12/31/' + Taxyear, settings.InternalFmt)) then
    rptEndDate := xStrToDate('01/31/' + nexttaxyear, settings.InternalFmt)
  else
    rptEndDate := EndDate;
  //
  // ------ Get Row Data ------
  SetLength(datGL, 0);
  rptRow := 0;      // Report row
  RptRowCount := 0; // Report row count
  // Repeat to get all row data
  lastWStick := '';
  myStkSales := 0;
  myOptSales := 0;
  myShortSales := 0;
  GainsIndex := 1; // Index for TrSumList
  //showTrSumList;
  while GetGainsData(GainsIndex, StartingLineNumber, bMTM) do begin
    Application.ProcessMessages;
    if GetKeyState(VK_ESCAPE) and 128 = 128 then begin
      StopReport := True;
      break;
    end;
    inc(GainsIndex);
  end;
  Result := (RptRowCount > 0);
  glReportRows := glReportRows + RptRowCount;
end;


// ------------------------------------
// Get Gains Report Row(s) for a Trade
// ------------------------------------
function GetGainsData(GainsIndex: Integer; var NextLineNumber: Integer; bMTM: boolean=false): Boolean;
var
  i : Integer;
  SlsPr, Cost, SlsPrShort, CostShort, closeSh, OpenSh : double;
  SkipData, StockShortSaleLossYE : Boolean;
  shContrStr, ShortStr, stkTk : string;
  { ATTradeSum type not a TTrSum type WHY? }
  ARec : TTradeSum;
  TrSum, TrSum2 : PTTrSum;
  LastTrNum : Integer;
  Year2003 : Boolean;
  dtOpen, dtClose: tdatetime;
begin
  SlsPr := 0;
  Cost := 0;
  Prof := 0;
  // note: cannot combine these next 2 tests because
  // ShortOptGL won't exist if CurrentBrokerID = 0
  if (TradeLogFile.CurrentBrokerID = 0) then
    optSales := 0;
  SkipData := False;
  StockShortSaleLossYE := false;
  Year2003 := Taxyear = '2003';
  if (TrSumList.count <= 0) //
  or (GainsIndex > TrSumList.count) then begin
    Result := False;
    exit;
  end;
  TrSum := TrSumList[GainsIndex - 1];
  ARec.tr := TrSum.tr;   // Trade Number
  ARec.tk := TrSum.tk;   // Ticker
  ARec.od := TrSum.od;   // Open Date
  ARec.cd := TrSum.cd;   // Close Date
  ARec.os := TrSum.os;   // Open Shares
  ARec.cs := TrSum.cs;   // Closed Shares
  ARec.ls := TrSum.ls;   // Long or Short
  ARec.oa := TrSum.oa;   // Open Price
  ARec.ca := TrSum.ca;   // Close Price
  ARec.wsh := TrSum.wsh; // Wash Sale Shares
  ARec.ws := TrSum.ws;   // Wash Sale Type
  ARec.prf := TrSum.prf; // Equity Type
  ARec.pr := TrSum.pr;   // Profit
  ARec.lt := TrSum.lt;   // Long or Short Term
  ARec.br := TrSum.br;
  Result := True;
  OpenStr := '';
  // ---- speed optimization -----
  if ARec.od = '' then
    dtOpen := 0
  else
    dtOpen := xStrToDate(ARec.od, settings.UserFmt);
  // end if
  if ARec.cd = '' then
    dtClose := 0
  else
    dtClose := xStrToDate(ARec.cd, settings.UserFmt);
  // -----------------------------
  if ((ARec.os = 0) and (ARec.cs = 0)) then exit;;
  // When running 8949 do not show any W Records as they are added
  // to the report via the adjustment column
  if (ReportStyle = rptIRS_D1) //
  and (TradeLogFile.Taxyear > 2010) //
  and (ARec.ws in [wsPrvYr, wsThisYr]) then
    exit; // --------------->
  // do not show exercized options
  if not(ReportStyle in [rptWashSales, rptPotentialWS])
  and (pos('EXERCISED', ARec.tk) > 1)
  and (pos('FUT', ARec.prf) = 0) then
    exit; // --------------------->
  // WS detail report only tickers with WS deferrals
  if (ReportStyle in [rptWashSales, rptPotentialWS]) then begin
    // added for different options on same underlying stock
    if DoST then begin
      SkipData := True;
      for i := 0 to high(datDeferralsST) do begin
        with datDeferralsST[i] do begin
          if (pos(' PUT', OpenDesc) > 0) or (pos(' CALL', OpenDesc) > 0) then
            stkTk := copy(OpenDesc, 1, pos(' ', OpenDesc) - 1)
          else
            stkTk := OpenDesc;
          // end if
          if (stkTk = ARec.tk) or ( //
            (pos('OPT', ARec.prf) = 1) //
            and (stkTk = copy(ARec.tk, 1, pos(' ', ARec.tk) - 1)) //
          ) then begin
            SkipData := False;
            Break;
          end;
          if (pos(' PUT', JanDesc) > 0) or (pos(' CALL', JanDesc) > 0) then
            stkTk := copy(JanDesc, 1, pos(' ', JanDesc) - 1)
          else
            stkTk := JanDesc;
          // end if
          if (stkTk = ARec.tk) or ( //
            (pos('OPT', ARec.prf) = 1) //
            and (stkTk = copy(ARec.tk, 1, pos(' ', ARec.tk) - 1)) //
          ) then begin
            SkipData := False;
            Break;
          end;
        end; // with
      end; // for
      //
      for i := 0 to High(datDeferralsIRA) do begin
        with datDeferralsIRA[i] do begin
          if (pos(' PUT', OpenDesc) > 0) //
          or (pos(' CALL', OpenDesc) > 0) then
            stkTk := copy(OpenDesc, 1, pos(' ', OpenDesc) - 1)
          else
            stkTk := OpenDesc;
          // end if
          if (stkTk = ARec.tk) or ( //
            (pos('OPT', ARec.prf) = 1) //
            and (stkTk = copy(ARec.tk, 1, pos(' ', ARec.tk) - 1)) //
          ) then begin
            SkipData := False;
            Break;
          end;
          // ---------------------
          if (pos(' PUT', JanDesc) > 0) //
          or (pos(' CALL', JanDesc) > 0) then
            stkTk := copy(JanDesc, 1, pos(' ', JanDesc) - 1)
          else
            stkTk := JanDesc;
          // end if PUT/CALL -----
          if (stkTk = ARec.tk) or ( //
            (pos('OPT', ARec.prf) = 1) //
            and (stkTk = copy(ARec.tk, 1, pos(' ', ARec.tk) - 1)) //
          ) then begin
            SkipData := False;
            Break;
          end;
        end; // with
      end; // for
    end // if DoST
    // ---------------------------
    else if DoLT then begin
      SkipData := True;
      for i := 0 to high(datDeferralsLT) do begin
        with datDeferralsLT[i] do begin
          if (pos(' PUT', OpenDesc) > 0) //
          or (pos(' CALL', OpenDesc) > 0) then
            stkTk := copy(OpenDesc, 1, pos(' ', OpenDesc) - 1)
          else
            stkTk := OpenDesc;
          //
          if (stkTk = ARec.tk) or ( //
            (pos('OPT', ARec.prf) = 1) //
            and (stkTk = copy(ARec.tk, 1, pos(' ', ARec.tk) - 1)) //
          ) then begin
            SkipData := False;
            Break;
          end; // if
          if (pos(' PUT', JanDesc) > 0) //
          or (pos(' CALL', JanDesc) > 0) then
            stkTk := copy(JanDesc, 1, pos(' ', JanDesc) - 1)
          else
            stkTk := JanDesc;
          // end if
          if (stkTk = ARec.tk) or ( //
            (pos('OPT', ARec.prf) = 1) //
            and (stkTk = copy(ARec.tk, 1, pos(' ', ARec.tk) - 1)) //
          ) then begin
            SkipData := False;
            Break;
          end;
        end; // with
      end; // for
      // ------------------------------
      for i := 0 to High(datDeferralsIRA) do begin
        with datDeferralsIRA[i] do begin
          if (pos(' PUT', OpenDesc) > 0) //
          or (pos(' CALL', OpenDesc) > 0) then
            stkTk := copy(OpenDesc, 1, pos(' ', OpenDesc) - 1)
          else
            stkTk := OpenDesc;
          // end if
          if (stkTk = ARec.tk) or ( //
            (pos('OPT', ARec.prf) = 1) //
            and (stkTk = copy(ARec.tk, 1, pos(' ', ARec.tk) - 1)) //
          ) then begin
            SkipData := False;
            Break;
          end;
          if (pos(' PUT', JanDesc) > 0) //
          or (pos(' CALL', JanDesc) > 0) then
            stkTk := copy(JanDesc, 1, pos(' ', JanDesc) - 1)
          else
            stkTk := JanDesc;
          // end if
          if (stkTk = ARec.tk) or ( //
            (pos('OPT', ARec.prf) = 1) //
            and (stkTk = copy(ARec.tk, 1, pos(' ', ARec.tk) - 1)) //
          ) then begin
            SkipData := False;
            Break;
          end;
        end; // with
      end; // for i =
    end; // if DoST else if DoLT
  end; // if ReportStyle
  // ----------------------------------
  if SkipData then exit;
  if (ARec.tk <> LastTick) or (ARec.tr <> LastTrNum) then Prof := 0;
  /// // filter by G&L date range - added 05-23-08 /////
  if (ARec.ws = wsThisYr)
  and not(ReportStyle in [rptWashSales, rptPotentialWS]) then begin
    if (ARec.od <> '') and (ARec.ls = 'S') then begin
      if dtOpen > (EndDate + 30) then exit;
    end;
  end
  else begin
    // 2014-04-24
    // Settlement Date Processing for skipping records that fall into previous or next tax year.
    if (IsStockType(ARec.prf)) and (ARec.od <> '') and (ARec.cd <> '')
    and (TradeLogFile.Taxyear > 2011)
    and not(ReportStyle in [rptWashSales, rptPotentialWS]) then begin
      // UPDATED 2016-05-19 - DO NOT skip short sales stock (not options) closed at a LOSS last 3 trading days OF LAST YEAR
      if (ARec.ls = 'S') and isStockType(ARec.prf) and (ARec.ca + ARec.oa < 0)
      and not(ReportStyle in [rptGAndL, rpt4797])
      and (dtClose >= settlementStartDate(xStrToDate('12/31/' + LastTaxYear, settings.InternalFmt)))
      and (dtClose <= xStrToDate('12/31/' + LastTaxYear, settings.InternalFmt)) then
        StockShortSaleLossYE := true;
      // skip all trades closed in prev tax year
      if not StockShortSaleLossYE and (dtClose < StartDate) then exit;
      // Skip short sales closed at a LOSS on last 3 trading days OF CURRENT YEAR
      // of current tax year which do not get reported till next year
      if (ARec.ls = 'S') and (ARec.ca + ARec.oa < 0)
      and not (ReportStyle in [rptGAndL, rpt4797])
      and (dtClose >= settlementStartDate(xStrToDate('12/31/' + Taxyear, settings.InternalFmt)))
      and (dtClose <= xStrToDate('12/31/' + Taxyear, settings.InternalFmt))
      and not bMTM then
        exit;
      //
    end;
    // make sure trades are closed in current tax year
    if (ARec.cd <> '')
    and not(ReportStyle in [rptWashSales, rptPotentialWS]) then begin
      if (TradeLogFile.Taxyear < 2012) or not IsStockType(ARec.prf) then begin
        if (dtClose < StartDate) then exit;
      end;
      if (ARec.ls = 'L') and (dtClose > EndDate) then exit;
      // open shorts not reported in 2011 onward
      if (Taxyear > '2010') and (ARec.ls = 'S') and (dtClose > EndDate) then
        exit;  // closed next year
    end;
  end;
  // ----------------------------------
  // skip all trades opened in next year
  if  not(ReportStyle in [rptWashSales, rptPotentialWS])
  and (ARec.ws <> wsThisYr) and (dtOpen > EndDate) then begin
    exit;
  end;
  // 8949 skip all open shorts in tax year 2011 onward
  if (Taxyear > '2010') and (TrSum.ls = 'S') and (TrSum.cd = '')
  and not(ReportStyle in [rptWashSales, rptPotentialWS])
  and not(ARec.ws = wsThisYr) // added 2012-04-13 so ws lines show on G&L report
  and not frmMain.cbShowOpens.checked then
    exit;
  //
  if not(ReportStyle = rpt4797) then begin
    // skip ST trades for Long-Term report and vice versa
    if DoLT and (ARec.lt = 'S') then exit;
    if DoST and (ARec.lt = 'L') then exit;
  end;
  // LT WSDetail skip non LT trades
  if DoLT and (ReportStyle in [rptWashSales, rptPotentialWS])
  and (ARec.lt <> 'L') then exit;
  // fix so open short sales closed in next tax year display properly in G&L report
  if (ARec.cd <> '') then begin
    if ((ARec.ls = 'S') and (dtClose > EndDate)) then begin
      ARec.cs := 0;
      ARec.cd := '';
    end;
  end;
  // added so that open shorts from previous years do not show on Long Term G&L report
  if DoLT and not DoST //
  and (rndto5(ARec.os) <> rndto5(ARec.cs)) //
  and (ARec.ls = 'S') //
  and (dtOpen < xStrToDate('01/01/' + Taxyear, settings.InternalFmt)) then
    exit;
  // Not Futures or Stocks & Options?
  if ((ReportStyle = rptFutures) and (pos('FUT', ARec.prf) = 0)) //
  or ((ReportStyle = rptCurrencies) //
    and (pos('CUR', ARec.prf) = 0) //
    and (pos('CTN', ARec.prf) = 0)) //
  or ((ReportStyle in [rptSubD1, rptIRS_D1, rptWashSales, rptPotentialWS, rptMTM]) //
   and ((pos('FUT', ARec.prf) = 1) //
     or (pos('CUR', ARec.prf) = 1)
     or (pos('CTN', ARec.prf) = 1))) //
  then
    exit;
  // If this is an IRA Record then do not include on IRS_D1 or Substitute D1
  // It will be included on standard GL.
  if (ReportStyle in [rptSubD1, rptIRS_D1]) //
  and (ARec.ws <> wsThisYr) //
  and (TradeLogFile.FileHeader[strToInt(ARec.br)].Ira) then
    exit;
  // 2014-01-08 added for WS Detail report
  if (TradeLogFile.FileHeader[strToInt(ARec.br)].Ira) //
  and (ARec.ws <> 2) then
    ARec.tk := ARec.tk + ' - IRA';
  ARec.os := rndTo5(ARec.os);
  ARec.cs := rndTo5(ARec.cs);
  closeSh := ARec.cs;
  OpenSh := ARec.os;
  // ***** THIS CODE APPEARS TO DO THE SAME EITHER WAY! *****
  if (pos('OPT', ARec.prf) = 1) then
    shContrStr := ''
  else
    shContrStr := '';
  // ********************************************************
  if ARec.ls = 'L' then begin
    ShortStr := '';
    shContrStr := shContrStr + ' (L) '
  end
  else if ARec.ls = 'S' then begin
    ShortStr := '';
    shContrStr := shContrStr + ' (S) '
  end;
  /// //// CALCULATE PROFIT ////////////
  if (ARec.os <> ARec.cs) then begin
    if (ARec.ls = 'S')
    and not(ReportStyle in [rptWashSales, rptPotentialWS]) then begin
      SlsPr := ARec.ca - ARec.pr;
      Cost := ARec.ca - ARec.pr;
      Prof := 0;
    end
    else begin
      Cost := -ARec.oa;
      SlsPr := ARec.ca;
      if ARec.ws = wsCstAdjd then Prof := ARec.ca + ARec.oa;
    end;
    OpenStr := FloatToStrFmt('%1.5f', [ARec.os], settings.UserFmt);
    OpenStr := OpenStr + shContrStr + ARec.tk + ShortStr + ' - OPEN';
  end
  else if (ARec.os <= 0) then begin
    SlsPr := ARec.ca;
    Cost := -ARec.oa;
    OpenStr := FloatToStrFmt('%1.5f', [closeSh], settings.UserFmt);
    OpenStr := OpenStr + shContrStr + ARec.tk + ShortStr + ' - OPEN';
    Prof := ARec.pr;
  end
  else if (ARec.os = ARec.cs) then begin
    SlsPr := ARec.ca;
    Cost := -ARec.oa;
    Prof := rndTo2(SlsPr) - rndTo2(Cost);
    OpenStr := FloatToStrFmt(DECIMALS05, [closeSh], settings.UserFmt);
    OpenStr := OpenStr + shContrStr + ARec.tk + ShortStr;
  end
  /// //// END Calculate profit ////////////
  // fix for open shorts
  else if (ARec.ls = 'S') and (ARec.ws <> wsThisYr)
  and ( (ARec.cd <> '') and (dtClose > EndDate) ) then begin
    ARec.cd := ARec.od;
    ARec.ca := ARec.oa;
    SlsPr := ARec.oa;
    Prof := 0;
    OpenStr := format('%1.5g', [ARec.os], settings.UserFmt) + shContrStr + ARec.tk + ShortStr + ' - OPEN';
    // skip if open short option
    if (pos('OPT', ARec.prf) = 1) then exit;;
    // 2011 onward skip open shorts
    if Taxyear > '2010' then exit;;
  end;
  // Sale is short - reverse Cost and SlsPr
  if (ARec.ls = 'S') then begin
    SlsPrShort := Cost;
    CostShort := SlsPr;
    Cost := CostShort;
    SlsPr := SlsPrShort;
    if Cost < 0 then Cost := -Cost;
    // if SlsPr < 0 then  //DE 2012-05-09
    SlsPr := -SlsPr;
  end; // if (ls...
  /// // MORE CHECKS FOR SKIP DATA /////
  // skip trades with zero shares
  if ( (pos('0 sh', OpenStr) = 1) or (pos('0 contr', OpenStr) = 1) )
  and (not TradeLogFile.YearEndDone) then exit;
  // skip if trade is open long - unless open long from last year
  if (ARec.ws <> wsPrvYr) and (ARec.ws <> wsThisYr) then begin
    if (ARec.os <> ARec.cs) and (ARec.ls = 'L')
    and not(ReportStyle in [rptWashSales, rptPotentialWS])
    and (pos('FUT-', ARec.prf) = 0)
    and (pos('CUR-', ARec.prf) = 0)
    then exit;
  end;
  // skip if open short option  02-02-08
  if not(ReportStyle in [rptWashSales, rptPotentialWS]) then begin
    if (ARec.ws <> wsPrvYr) and (ARec.ws <> wsThisYr) then begin
      if (ARec.os <> ARec.cs) and (ARec.ls = 'S') and (pos('OPT', ARec.prf) = 1)
      and not(ReportStyle in [rptWashSales, rptPotentialWS]) then exit;
    end;
  end;
  /// / get total sales Options ////
  // get long option sales
  if (pos('OPT', ARec.prf) = 1)
  and ((DoST and (ARec.lt = 'S')) or (DoLT and (ARec.lt = 'L')))
  and (ARec.ws <> wsPrvYr) and (ARec.ws <> wsThisYr)
  and (ARec.ls = 'L') and (ARec.cd <> '')
  and not((pos('EXERCISED', ARec.tk) > 0))
  // options must be closed in current tax year
  and (dtClose >= StartDate) and (dtClose <= EndDate) then begin
    // 2015-02-12
    if not((ReportStyle = rptRecon) and (TradeLogFile.Taxyear >= 2014)) then
      OptSales := OptSales + ARec.ca; // all but Recon
  end
    // get short option sales
  else if (pos('OPT', ARec.prf) = 1)
  and ( (DoST and (ARec.lt = 'S')) or (DoLT and (ARec.lt = 'L')) )
  and (ARec.ws <> wsPrvYr) and (ARec.ws <> wsThisYr)
  and (ARec.ls = 'S') and (ARec.cd <> '')
  // must be closed in current tax year
  and (dtClose >= StartDate) and (dtClose <= EndDate)
  and not((pos('EXERCISED', ARec.tk) > 0))// and(pos(' CALL',tk)>0) )
  // must not be opened after current tax year
  and (dtOpen <= EndDate) then begin // 2015-02-12
    if not((ReportStyle = rptRecon) and (TradeLogFile.Taxyear >= 2014)) then
      OptSales := OptSales + ARec.oa;
  end;
  if ARec.ws = wsPrvYr then exit;; // skip line if WS Deferral
  // calc stock sales
  if (ARec.prf = 'STK-1') //
  or (ARec.prf = 'DRP-1') //
  or (ARec.prf = 'ETF-1') //
  or (ARec.prf = 'MUT-1') //
  or (pos('DCY', ARec.prf) = 1) then begin // 2018-03-07 MB - added DCY type
    if (ARec.cd <> '') and (ARec.ls = 'L') and (ARec.lt = 'S') //
    and (dtClose >= xStrToDate('01/01/' + Taxyear)) //
    and (dtClose <= xStrToDate('12/31/' + Taxyear)) then
      myStkSales := myStkSales + ARec.ca;
    // end if
    if (ARec.od <> '') and (ARec.ls = 'S') and (ARec.lt = 'S') //
    and (dtOpen >= xStrToDate('01/01/' + Taxyear)) //
    and (dtOpen <= xStrToDate('12/31/' + Taxyear)) then
      myStkSales := myStkSales + ARec.oa;
    // end if
  end;
  // calc option sales
  if (pos('OPT', ARec.prf) = 1) then begin
    if (ARec.cd <> '') and (ARec.ls = 'L') // and(oc='C')
    and (dtClose >= xStrToDate('01/01/' + Taxyear))
    and (dtClose <= xStrToDate('12/31/' + Taxyear))
    and not((pos('EXERCISED', ARec.tk) > 0) and (pos(' PUT', ARec.tk) > 0)) then
      myOptSales := myOptSales + ARec.ca;
    // end if
    if (ARec.od <> '') and (ARec.ls = 'S')// and(oc='O')
    and (dtOpen >= xStrToDate('01/01/' + Taxyear))
    and (dtOpen <= xStrToDate('12/31/' + Taxyear))
    and not((pos('EXERCISED', ARec.tk) > 0) and (pos(' PUT', ARec.tk) > 0)) then
      myOptSales := myOptSales + ARec.oa;
    // end if
  end;
  // calc short stock sales
  if (pos('STK', ARec.prf) = 1) then begin
    if (ARec.cd <> '') and (ARec.ls = 'S')
    and (dtOpen < xStrToDate('01/01/' + Taxyear))
    and (dtClose <= xStrToDate('12/31/' + Taxyear)) then
      myShortSales := myShortSales + ARec.oa;
    // end if
  end;
  // ==================================
  // BEGIN REPORT                    //
  // ==================================
  If not SkipData then begin
    lastWStick := ARec.tk;          // INPUTS: ARec, TrSum, wsPrvYr, wsThisYr
    rptRow := RptRowCount;          // GLOBAL: RptRowCount, datGL, Desc
    inc(RptRowCount);               // PARAMETER: NextLineNumber
    SetLength(datGL, RptRowCount);
    FillChar(datGL[rptRow], SizeOf(datGL[rptRow]), 0);
    datGL[rptRow].abc := TrSum.abc;
    datGL[rptRow].code := TrSum.code;
    if TrSum.adjG < 0.01 then datGL[rptRow].code := ''; // no adjG < 1 cent!
    datGL[rptRow].adjG := TrSum.adjG;
// Desc is used for ClipStr and Report text
    Desc := '';
    if (ARec.ws <> wsPrvYr) then begin
      if (ARec.ws <> wsThisYr) then begin
        Desc := IntToStr(NextLineNumber) + ') ';
        // used for both trigger id (on a wsThisYr record), also to store the
        // transaction number (as seen here) so that we can look it up later on
        // to put the line number on the WSThisYr record.
        TrSum.wstriggerid := NextLineNumber;
        inc(NextLineNumber);
      end; // If (ws...
      Desc := Desc + OpenStr;
      if (ARec.ws = wsThisYr) then begin
        Desc := '    WS Adj - ' +FloatToStr(OpenSh, settings.UserFmt) +shContrStr +' ' +ARec.tk;
        // Pass the trigger ID so we can put the line number on this later on
        datGL[rptRow].wstriggerid := TrSum.wstriggerid;
        Cost := ARec.oa;
        Prof := -ARec.oa;
        SlsPr := 0;
      end;
      // added 2010-03-13 for expired options
      if (pos('OPT',ARec.prf)=1) and (ARec.ca=0) and (pos('WS ',Desc)=0) then
        Desc := Desc + ' EXPIRED';
      if ((Cost=0) and (SlsPr=0)) then Prof := 0;
      SlsprTot := SlsprTot + rndTo2(SlsPr);
      CostTot := CostTot + rndTo2(Cost);
      ProfTot := ProfTot + rndTo2(Prof);
      if Prof < 0 then
        LossTot := LossTot + rndTo2(Prof) //
      else
        GainTot := GainTot + rndTo2(Prof); //
      AdjGTot := AdjGTot + rndTo2(TrSum.adjG);
      datGL[rptRow].Desc := Desc;
      if (ARec.ls = 'S') and (ARec.ws <> wsThisYr) then begin
        datGL[rptRow].dtAcq := ARec.cd;
        datGL[rptRow].dtSld := ARec.od;
      end
      else begin
        datGL[rptRow].dtAcq := ARec.od;
        datGL[rptRow].dtSld := ARec.cd;
      end; // If (ls...
      if (pos('Wash Sale',Desc) > 0) then begin // and rptIncludeWashSales then
        if (pos('(S)', Desc) > 0) then begin
          datGL[rptRow].dtAcq := '';
          datGL[rptRow].dtSld := ARec.od;
        end
        else begin
          datGL[rptRow].dtAcq := ARec.od;
          datGL[rptRow].dtSld := '';
        end; // If (pos...
      end; // if pos('Wash Sale', Desc)
      if DoST then begin
        // added 7-12-08 so options not included in open shorts sales
        if (pos('OPT', ARec.prf) = 0)
        and ( ((ARec.ls = 'S') and (dtOpen < StartDate))
          // needed for MTM open shorts from last year
          or ( (ARec.ls = 'S')
           and (dtOpen = xStrToDate('01/01/' + Taxyear, settings.InternalFmt)) )
        ) then OshSales := OshSales + SlsPr;
      end
      else if DoLT then begin
        // added 7-12-08 so options not included in open shorts sales
        if (pos('OPT', ARec.prf) = 0)
        and ((ARec.ls = 'S') and (dtOpen < StartDate)) then
          OshSales := OshSales + SlsPr;
      end;
      datGL[rptRow].sales := SlsPr;
      datGL[rptRow].cs := Cost;
      datGL[rptRow].pl := Prof;
      // added for open positions on WS Detail report
      if (Taxyear > '2010') and (pos('- OPEN', datGL[rptRow].Desc) > 0) then begin
        if (ARec.ls = 'L') then
          datGL[rptRow].sales := 0
        else if (ARec.ls = 'S') then
          datGL[rptRow].cs := 0;
        // end if
      end; // if
    end; // If (ws<>wsPrvYr...
    // added for new 2003 Schedule D
    if Year2003 and (ReportStyle <> rpt481Adjust) then begin
      if ((ARec.cd <> '') and (dtClose > xStrToDate('05/05/2003', settings.InternalFmt)))
      or (((ARec.ws <> wsPrvYr) or (ARec.ws = wsThisYr))
        and ((ARec.od <> '') and (dtOpen > xStrToDate('05/05/2003', settings.InternalFmt)))
        or ((ARec.cd <> '') and (dtClose > xStrToDate('05/05/2003', settings.InternalFmt)))
      ) then begin
        GainMay5 := Prof;
        datGL[rptRow].gm03 := GainMay5;
        GainMay5Tot := GainMay5Tot + rndTo2(GainMay5);
      end
      else begin
        datGL[rptRow].gm03 := 0;
        GainMay5 := 0;
      end; // If ((cd...
    end
    else
      GainMay5 := 0;
    // --------------------------------
    // Place Data into clipStr
    if (ARec.ws <> wsPrvYr) then begin
      if pos('Wash Sale', Desc) > 0 then
        msgTxt := Tab + Tab + Tab + Tab + trim(Desc) + Tab
      else begin
        msgTxt := copy(Desc, 1, pos(' ', Desc) - 1) + Tab; // line num
        delete(Desc, 1, pos(' ', Desc));
        msgTxt := msgTxt + copy(Desc, 1, pos(' ', Desc) - 1) + Tab;
        // quantity
        delete(Desc, 1, pos(' ', Desc));
        msgTxt := msgTxt + copy(Desc, 1, pos(' ', Desc) - 1) + Tab;
        // long/short
        msgTxt := delParenthesis(msgTxt);
        delete(Desc, 1, pos(' ', Desc));
        Desc := trim(Desc);
        if pos(' ', Desc) > 0 then begin
          msgTxt := msgTxt + copy(Desc, 1, pos(' ', Desc) - 1) + Tab;
          delete(Desc, 1, pos(' ', Desc));
          if (pos('- ', Desc) = 1) then delete(Desc, 1, 2);
          msgTxt := msgTxt + Desc + Tab;
        end
        else
          msgTxt := msgTxt + Desc + Tab + Tab;
        delete(Desc, 1, pos(' ', Desc));
      end;
      if ARec.ls = 'L' then
        msgTxt := msgTxt + ARec.od + Tab + ARec.cd + Tab
      else
        msgTxt := msgTxt + ARec.cd + Tab + ARec.od + Tab;
      // end if
      msgTxt := msgTxt + CurrStrEx(SlsPr, settings.UserFmt) + Tab +
        CurrStrEx(Cost, settings.UserFmt) + Tab +
        CurrStrEx(Prof, settings.UserFmt);
      if Year2003 then
        msgTxt := msgTxt + Tab + CurrStrEx(GainMay5, settings.UserFmt);
      ClipStr.Append(msgTxt);
    end;
  end; // If Not(SkipData...
  // ----------------
  // FINISH REPORT //
  // ----------------
  if GainsIndex = TrSumList.count then
  begin // All Records Read
    // ------- End ClipStr ------------
    if not(Year2003 and (ReportStyle <> rpt481Adjust)) then GainMay5Tot := 0;
    if Year2003 then
      ClipStr.Append( Tab + Tab + Tab + Tab + Tab + Tab + Tab
        + CurrStrEx(SlsprTot, settings.UserFmt) + Tab
        + CurrStrEx(CostTot, settings.UserFmt) + Tab
        + CurrStrEx(ProfTot, settings.UserFmt) + Tab
        + CurrStrEx(GainMay5Tot, settings.UserFmt) )
    else
      ClipStr.Append( Tab + Tab + Tab + Tab + Tab + Tab + Tab
        + CurrStrEx(SlsprTot, settings.UserFmt) + Tab
        + CurrStrEx(CostTot, settings.UserFmt) + Tab
        + CurrStrEx(ProfTot, settings.UserFmt) );
    // ------- End ClipStr ------------
    wsJan := '';
    wsOpen := '';
    /// show total wash sales deferred
    if not( (ReportStyle = rptCurrencies) or (ReportStyle = rptFutures)
      or (not rptIncludeWashSales)
      or (rptEndDate < xStrToDate('12/31/' + Taxyear, settings.InternalFmt))
    ) or (ReportStyle in [rptWashSales, rptPotentialWS]) then begin
      if DoLT and not DoST then begin
        totWSdefer := totWSdeferL;
        wsOpen := wsOpenL;
        wsJan := wsJanL;
      end
      else if DoST and not DoLT then begin
        totWSdefer := totWSdeferS;
        wsOpen := wsOpenS;
        wsJan := wsJanS;
      end
      else begin
        totWSdefer := totWSdeferS + totWSdeferL;
        if wsOpenS = '' then
          wsOpen := 'Long-Term:' + cr + wsOpenL
        else
          wsOpen := 'Short-Term:' + cr + wsOpenS + cr + cr + 'Long-Term:' + cr + wsOpenL;
        // end if
        if wsJanS = '' then
          wsJan := 'Long-Term:' + cr + wsJanL
        else
          wsJan := 'Short-Term:' + cr + wsJanS + cr + cr + 'Long-Term:' + cr + wsJanL;
        // end if
      end;
      // ------- End ClipStr ----------
      if totWSdefer > 0 then
        ClipStr.Append(cr + Tab + Tab + Tab + Tab
          + 'TOTAL WASH SALES DEFERRED TO NEXT TAX YEAR:' + Tab
          + CurrStrEx(totWSdefer, settings.UserFmt));
      // ------- End ClipStr ----------
    end; // if ReportStyle...
  end; // If GainsIndex...
  LastTick := ARec.tk;
  LastTrNum := ARec.tr;
end;


procedure GetReportSummary();
var
  i, rptRow: Integer;
  sOC, sLS: string;
begin
  if not(ReportStyle in[rptTradeSummary, rptTickerSummary, rpt481Adjust]) then
    exit;
  CostTot := 0;
  ProfTot := 0;
  SlsprTot := 0;
  accuTrCost := 0;
  accuTrSales := 0;
  curntTick := '';
  curntTrNum := 0;
  rptSumItem := -1;
  RptRowCount := 0;
  SetLength(datSummary, 0);
  // ----------------------
  ClipStr.Capacity := ClipStr.count + 1;
  ClipStr.Append('Trade' + Tab + 'Shares' + Tab + 'L/S' + Tab + 'Ticker'
    + Tab + 'Date Acquired' + Tab + 'Date Sold' + Tab + 'Sales Price'
    + Tab + 'Cost or Other Basis' + Tab + 'Gain or (Loss)');
  // ----------------------
  for rptRow := 0 to (frmMain.cxGrid1TableView1.ViewData.RowCount - 1) do begin
    with frmMain.cxGrid1TableView1.ViewData.Rows[rptRow] do begin
      sOC := Values[4]; // re-use the OC value of this rptRow
      sLS := Values[5]; // re-use the LS value of this rptRow
      // New Trade or Ticker?
      if ((Values[1] <> curntTrNum) and (ReportStyle <> rptTickerSummary))
      or ((Values[6] <> curntTick) and (ReportStyle = rptTickerSummary)) then
      begin
        if RptRowCount > 0 then StoreReportSummary;
        // add earlier data to datSummary
        curntLS := sLS; // this is NOT just the current record! MB 8/25/16
        curntTick := Values[6];
        curntTrNum := Values[1];
        inc(rptSumItem);
        inc(RptRowCount);
        SetLength(datSummary, RptRowCount);
        accuTrShares := 0;
        // ------------------
        datSummary[rptSumItem].dtSld := 0;
        datSummary[rptSumItem].dtAcq := 0;
        datSummary[rptSumItem].Open := 0;
        datSummary[rptSumItem].Wash := 0;
        if sOC = 'O' then begin // Open
          accuTrShares := Values[7];
          datSummary[rptSumItem].Open := accuTrShares;
          if sLS = 'L' then
            datSummary[rptSumItem].dtAcq := Values[2]
          else if sLS = 'S' then
            datSummary[rptSumItem].dtSld := Values[2];
        end
        else if (sOC = 'C') or (sOC = 'M') then begin // Close
          datSummary[rptSumItem].Open := -Values[7];
          if sLS = 'L' then
            datSummary[rptSumItem].dtSld := Values[2]
          else if sLS = 'S' then
            datSummary[rptSumItem].dtAcq := Values[2];
        end
        else if sOC = 'W' then begin // Wash sale from prev year
          datSummary[rptSumItem].Wash := Values[11];
        end;
        // --------------
        if Values[11] < 0 then begin // Bought?
          accuTrCost := -Values[11];
          accuTrSales := 0;
        end
        else begin
          accuTrCost := 0;
          accuTrSales := Values[11];
        end; // If Values[11]
        datSummary[rptSumItem].TrPl := Values[12];
      end // if new trade
      else begin // Continuation of a trade
        if sOC = 'O' then begin // Open
          accuTrShares := accuTrShares + Values[7];
          datSummary[rptSumItem].Open := datSummary[rptSumItem].Open
            + Values[7];
          if (sLS = 'L') and (datSummary[rptSumItem].dtAcq = 0) then
            datSummary[rptSumItem].dtAcq := Values[2]
          else if (sLS = 'S') and (datSummary[rptSumItem].dtSld = 0) then
            datSummary[rptSumItem].dtSld := Values[2];
        end
        else if (sOC = 'C') or (sOC = 'M') then begin
          datSummary[rptSumItem].Open := datSummary[rptSumItem].Open
            - Values[7];
          if (sLS = 'L') and (datSummary[rptSumItem].dtSld = 0) then
            datSummary[rptSumItem].dtSld := Values[2]
          else if (sLS = 'S') and (datSummary[rptSumItem].dtAcq = 0) then
            datSummary[rptSumItem].dtAcq := Values[2];
        end
        else if sOC = 'W' then
          datSummary[rptSumItem].Wash := datSummary[rptSumItem].Wash
            + Values[11];
        // ---- Bought? ----
        if (Values[11] < 0) then
          accuTrCost := accuTrCost - Values[11]
        else
          accuTrSales := accuTrSales + Values[11];
        datSummary[rptSumItem].TrPl := datSummary[rptSumItem].TrPl + Values[12];
        // --- Both Long & Short? ---
        if pos(sLS, curntLS) = 0 then curntLS := curntLS + '/' + sLS;
      end; // else
    end; // with
  end; // for
  // Get final data
  if RptRowCount > 0 then StoreReportSummary;
end;


function remove3Spaces(value : String) : String;
begin
  while pos('  ', value) > 0 do
    delete(value, pos('  ', value), 1);
  Result := value;
end;


procedure reportCancelledMsg;
begin
  mDlg('Report Cancelled by User', mtInformation, [mbOK], 0);
end;


function reportStoppedCheck : boolean;
begin
  if stopReport then begin // User hit Escape!
//    frmMain.Menu := frmMain.MainMenu; // 2021-05-10 MB - no longer used
    frmMain.EnableMenuToolsALL;
    frmMain.FreeTrSumList;
    if assigned(ClipStr) then ClipStr.Free;
    if assigned(GainsReportData) then FreeAndNil(GainsReportData);
    if assigned(dataFastReports) then FreeAndNil(dataFastReports);
    if assigned(frmFastReports) then begin
      frmFastReports.Release;
      freeAndNil(frmFastReports);
    end;
    StatBar('off');
    reportCancelledMsg;
    result := true;
  end
  else result := false;
end;


// for computing OptSales when running MTM Recon 1099
procedure calcOptSales(StartDate, EndDate : TDateTime);
var
  TrSum : PTTrSum;
  i, brID : integer;
  dtEOY : TDate;
begin
  if (TrSumList = nil) then exit; // nothing to do
  if TrSumList.Count = 0 then exit; // nothing to do
  // --------------------------------
  try
    // 2020-12-02 MB - anything after try WILL result in finally: be careful!
    brID := TradeLogFile.CurrentBrokerID; // save the account tab we are running the report from
    dtEOY := strToDate('12/31/' + InttoStr(TradeLogFile.TaxYear), Settings.InternalFmt);
    OptSales := 0; // 2020-04-16 MB - clear before recomputing
    // ------------------------
    for i := 0 to TrSumList.Count - 1 do begin
      TrSum := TrSumList[i];
      if (ReportStyle <> rptRecon) //
      or (TradeLogFile.TaxYear < 2014) //
      or (Pos('OPT', TrSum.prf) <> 1)
      then begin
        if strToDate(TrSum.od) > dtEOY then continue;
        if (TrSum.cd <> '') then
          if strToDate(TrSum.cd) > dtEOY then continue;
        // end if
      end; // fix for ETY
      if (ReportStyle = rptRecon) //
      and (TradeLogFile.TaxYear >= 2014) //
      and (Pos('OPT', TrSum.prf) = 1)
      then begin
        if (TrSum.cd = '') then continue;
        if (strToDate(TrSum.od) > dtEOY) then continue;
        if (TrSum.cd <> '') and (strToDate(TrSum.cd) > dtEOY) then continue;
        if (Pos('EXERCISED', TrSum.tk) > 0) then continue;
        // --------------------
        // broker DID NOT report options prior to 2014
        if not TradeLogFile.CurrentAccount.Options2013 //
        and (strToDate(TrSum.od) < strToDate('01/01/2014', Settings.InternalFmt)) //
        then begin
          if (TradeLogFile.CurrentAccount.ShortOptGL) //
          and (TrSum.ls = 'S') then begin
            OptSales := OptSales + TrSum.oa;
          end
          else if (TrSum.ls = 'S') then begin
            OptSales := OptSales + TrSum.oa;
          end
          else if (TrSum.ls = 'L') then begin
            OptSales := OptSales + TrSum.ca;
          end;
        end
        else begin // broker DID report options prior to 2014
          if (TradeLogFile.CurrentAccount.ShortOptGL) and (TrSum.ls = 'S') then begin
            OptSales := OptSales - TrSum.ca;
          end;
        end; // IF broker did not report options prior to 2014
      end; // IF rptRecon, > 2014, and OPT
    end; // for i := 0 to TrSumList.Count - 1
  finally
    // reset to account tab selected
    TradeLogFile.CurrentBrokerID := brID;
  end;
end; // end calcOptSales


// ==============================================
function PrepareForGainsReports(SDate, EDate : TDate; IncludeWashSales, WSBetweenLS : Boolean) : Boolean;
// ==============================================
var
  brID : Integer;
  bFlag : boolean;
begin
  screen.cursor:= crHourglass;
try
  frmMain.FreeTrSumList;
  if ReportStyle = rpt481Adjust then begin
    LoadTradesSum('', '');
    StartDate := xStrToDate('01/01/' + Taxyear, settings.InternalFmt);
    EndDate := xStrToDate('12/31/' + Taxyear, settings.InternalFmt);
    exit(True);
  end;
  sortByTickerForWS;
  { this method loads W Records from the last year if the 3rd parameter is true, So we want
    to pass true if 1) we are including wash sales above, or 2) we are running the 4797 report,
    we do not want this years wash sales with the 4797, so it is not included
    in the IncludeWashSales variable }
  if not LoadTradesSumGL(StartDate, EndDate, IncludeWashSales or (ReportStyle=rpt4797))
  then begin
    // User hit Escape!
    stopReport := true;
    if reportStoppedCheck then exit(false);
  end;
  screen.cursor:= crHourglass; // 2021-09-10 MB keep it disabled durinr report prep
  if (ReportStyle = rptRecon) //
  and (TradeLogFile.CurrentBrokerID > 0) //
  and (TradeLogFile.CurrentAccount.MTM) then
    calcOptSales(StartDate, EndDate);
  bFlag := (Taxyear > '2010') and (ReportStyle in [rptIRS_D1, rptRecon]);
  // which tab is this report running from - calcWashSales sets ID to each account
  // as it cycles thru trades
  brID := TradeLogFile.CurrentBrokerID;
  if IncludeWashSales then
    LoadTradesSumGLWS(SDate, EDate, bFlag, WSBetweenLS);
  if reportStoppedCheck then exit(false);
  // reset ID back to what it was when report was run
  TradeLogFile.CurrentBrokerID := brID;
  if (ReportStyle in [rptIRS_D1, rptSubD1, rptWashSales, rptPotentialWS])
  or ((ReportStyle = rptRecon) and (not TradeLogFile.CurrentAccount.MTM))
  then
    OShNextYrSales := LoadTradeSumAdditionalRules;
  StatBar('Preparing Report - Please Wait...');
  Result := True;
finally
  screen.cursor:= crDefault;
end;
end;


procedure Run1099Recon;
var
  i, j, StartLineNumber, exNum, trMTM : Integer;
  multStr, exNumStr : string;
  mult, closedSh, foundSh, closedAmt : double;
  TrSum : PTTrSum;
  adjIdxList, MTMList : TList<Integer>;
  MTMclosed : TList<double>;
  dtEOY, dtPrevEOY : TDateTime;
begin
  try
    adjIdxList := TList<Integer>.Create;
    MTMList := TList<Integer>.Create;
    MTMclosed := TList<double>.Create;
    with frmMain do begin
      MakeGLCalendarYear(null, null);
      GlST := 0;
      WsST := 0;
      GlLT := 0;
      WsLT := 0;
      GlTot := 0;
      SalesST := 0;
      SalesLT := 0;
      OshSales := 0;
//      if not((ReportStyle = rptRecon) and (TradeLogFile.Taxyear >= 2014)) then
//        OptSales := 0; // seems like dead code - MB
      SecMTM := 0;
      NetSales := 0;
      DiffSales := 0;
      optExAssSales := 0;
      StartLineNumber := 1;
      mult := 100;
      dtEOY := xStrToDate('12/31/' + Taxyear, settings.InternalFmt);
      dtPrevEOY := xStrToDate('12/31/' + LastTaxYear, settings.InternalFmt);
      // ----------------------------------------
      // get list of all trades year end MTM  2015-03-09
      for i := (TradeLogFile.count - 1) downto 0 do begin // this is LIFO
        trMTM := TradeLogFile[i].TradeNum; // just lookup TrNum once
        j := MTMList.indexOf(trMTM); // just lookup index once
        if (TradeLogFile[i].OC = 'M') and (j = -1) then begin
          MTMList.Add(trMTM); // this is a list of TradeNums
          MTMclosed.Add(0); // this is the total # of closed shares
        end;
        if (TradeLogFile[i].OC = 'C') and (j > 0) then begin
          MTMclosed[j] := MTMclosed[j] + TradeLogFile[i].Shares;
        end;
      end;
      // ----------------------------------------
      // get total sales MTM
      // ----------------------------------------
      for i := 0 to (TradeLogFile.count-1) do begin // NOTE: this is FIFO
        if (TradeLogFile[i].Broker <> TradeLogFile.CurrentBrokerID) then
          Continue; // ----------------------------------------------------->
        // 2015-04-09 filter out options for tax years prior to 2014
        if (pos('OPT', TradeLogFile[i].TypeMult) = 1)
        and (TradeLogFile.Taxyear < 2014) then Continue; // ---------------->
        // --------------------------------------
        if (TradeLogFile[i].ls = 'L') then begin
          // if long M rec, this tax year, and NOT a future,
          // then add to SecMTM amount
          if (TradeLogFile[i].OC = 'M')
          and (TradeLogFile[i].date = dtEOY)
          and (pos('FUT', TradeLogFile[i].TypeMult) = 0) then
            SecMTM := SecMTM + TradeLogFile[i].Amount;
        end
        else if (TradeLogFile[i].ls = 'S') then begin
          // if short trade closed with M, amounts still open at EOY
          j := MTMList.indexOf(TradeLogFile[i].TradeNum); // list index
          if (j > -1) then begin // found in MTM list
            if (TradeLogFile[i].OC = 'O') then begin
              // we need to skip the closed shares - 7/7/2016 MB
              if TradeLogFile[i].Shares <= MTMclosed[j] then
                MTMclosed[j] := MTMclosed[j] - TradeLogFile[i].Shares
              else begin // TradeLogFile[i].Shares > MTMclosed[j]
                if MTMclosed[j] > 0.01 then
                  SecMTM := SecMTM + (TradeLogFile[i].Amount
                    * (TradeLogFile[i].Shares - MTMclosed[j]) / TradeLogFile[i].Shares)
                else
                  SecMTM := SecMTM + TradeLogFile[i].Amount;
                MTMclosed[j] := 0;
              end;
            end; // opens
          end; // TrNum in MTMlist
        end; // Short trade
      end;
      // ----------------------------------------
      // get total option exercise/assign sales adjustment for 1099 Recon report
      if not TradeLogFile.CurrentAccount.SalesAdjOptions1099 //
      and (StrToFloat(TradeLogFile.CurrentAccount.GrossSales1099) > 0) //
      then begin
        for i := 0 to TradeLogFile.count - 1 do begin
          if (TradeLogFile[i].Broker <> TradeLogFile.CurrentBrokerID) then Continue;
          // loop thru all exercised option records which resulted in stock sale assignment
          // futures should not be included 2014-04-08
          if (pos('OPT', TradeLogFile[i].TypeMult) = 1)
          and (TradeLogFile[i].OC = 'C')
          and (TradeLogFile[i].date < xStrToDate('01/01/' + nexttaxyear))
          and (pos('EXERCISED', TradeLogFile[i].Ticker) > 0) then begin
            // match only stock sales, not purchases
            if ((TradeLogFile[i].ls = 'S') and (pos(' CALL', TradeLogFile[i].Ticker) > 0))
            or ((TradeLogFile[i].ls = 'L') and (pos(' PUT', TradeLogFile[i].Ticker) > 0))
            then begin
              multStr := TradeLogFile[i].TypeMult;
              mult := StrToFloat(parseLast(multStr, '-'));
              closedSh := TradeLogFile[i].shares * mult;
              foundSh := closedSh;
              closedAmt := TradeLogFile[i].Amount;
              // sm(TradeLogFile[i].Ticker+cr+floatToStr(closedSh)+cr+floatToStr(closedAmt));
              // inner loop thru matched trades list
              for j := 0 to TrSumList.count - 1 do begin
                TrSum := TrSumList[j];
                // statBar('1: '+intToStr(j)+'  '+TrSum.cd+'  '+TrSum.prf+'  '+TrSum.m);
                if (adjIdxList.indexOf(j) > -1)
                or (pos('Ex-', TrSum.m) = 0) then Continue;
                // ignore all open trades, only total closed stock trades in current tax year
                if (TrSum.cd = '')
                or ( (TrSum.cd <> '')
                 and (xStrToDate(TrSum.cd, settings.UserFmt) > xStrToDate('12/31/' + Taxyear, settings.InternalFmt))
                  or (pos('OPT', TrSum.prf) = 1)
                ) then Continue;
                // match to Ex-
                if (TrSum.m = TradeLogFile[i].Matched)
                and (closedSh >= TrSum.cs) then begin
                  optExAssSales := optExAssSales - closedAmt * (TrSum.cs / closedSh);
                  // sm('i: '+intToStr(i)+'  j: '+intToStr(j)+cr+floatToStr(closedAmt) +'  '+ floatToStr(TrSum.cs) +'  '+floatToStr(closedSh));
                  // sm('i: '+intToStr(i)+'  j: '+intToStr(j)+cr+floatToStr(closedAmt * (TrSum.cs/closedSh)));
                  foundSh := foundSh - TrSum.cs;
                  adjIdxList.Add(j);
                  if (foundSh <= 0) then Break;
                end;
              end;
            end;
          end;
        end; // for i := 0 to TradeLogFile.count-1
      end; // if
      // ----------------------------------------
      DoST := True;
      DoLT := False;
      // ----------------------------------------
      If GainsReportAvailable(StartLineNumber, TradeLogFile.CurrentAccount.MTM)
      then begin
        GlST := ProfTot;
        SalesST := SlsprTot;
        if totWSdeferS < 0 then WsST := totWSdeferS;
      end;
      // ----------------------------------------
      if not TradeLogFile.CurrentAccount.MTM then begin
        DoST := False;
        DoLT := True;
        If GainsReportAvailable(StartLineNumber) then begin
          GlLT := ProfTot;
          SalesLT := SlsprTot;
          if totWSdeferL < 0 then WsLT := totWSdeferL;
        end;
      end;
      // ----------------------------------------
      GlTot := GlST + WsST + GlLT + WsLT;
      // ----------------------------------------
      if TradeLogFile.CurrentAccount.Options1099
      and (TradeLogFile.Taxyear < 2014) then
        OptSales := 0;
      // ----------------------------------------
      // get TradeLog Adjusted Sales Total
      if TradeLogFile.CurrentAcctType = 'MTM' then
        NetSales := SalesST + SalesLT - optExAssSales - OptSales - SecMTM
      else if Taxyear > '2011' then
        NetSales := SalesST + SalesLT - optExAssSales - OptSales - OShNextYrSales
      else
        NetSales := SalesST + SalesLT - optExAssSales - OptSales - OshSales;
      // ----------------------------------------
      if strToInt(Taxyear) < 2011 then begin
        if Length(TradeLogFile.CurrentAccount.GrossSales1099) > 0 then
          DiffSales := NetSales - StrToFloat(Del1000SepEx(TradeLogFile.CurrentAccount.GrossSales1099,
            settings.UserFmt), settings.UserFmt)
        else
          DiffSales := NetSales;
      end
      else begin
        if Length(TradeLogFile.CurrentAccount.GrossSales1099) > 0 then
          DiffSales := NetSales - StrToFloat(Del1000SepEx(TradeLogFile.CurrentAccount.GrossSales1099,
            settings.UserFmt), settings.UserFmt)
        else
          DiffSales := NetSales;
      end;
      // ----------------------------------------
      Title := 'Tradelog 1099 Reconciliation Report';
      StatBar('off');
      dataFastReports.RunReconcileReport;
    end; // with frmMain
  finally
    adjIdxList.Free;
    MTMList.Free;
    MTMclosed.Free;
    //rj CodeSite.ExitMethod('Run1099Recon');
  end;
end;


procedure checkForFutCur;
var
  i : Integer;
  HasFutures, HasCurrencies : Boolean;
begin
  // check for Futures or Currencies
  HasFutures := False;
  HasCurrencies := False;
  if (ReportStyle in [rptSubD1 .. rptCurrencies, rptIRS_D1]) then begin
    for i := 0 to TradeLogFile.count - 1 do begin
      if pos('FUT', TradeLogFile[i].TypeMult) = 1 then HasFutures := True;
      if (pos('CUR', TradeLogFile[i].TypeMult) = 1) //
      or (pos('CTN', TradeLogFile[i].TypeMult) = 1) //
      then
        HasCurrencies := True;
      if HasCurrencies and HasFutures then Break;
    end;
    if HasFutures then begin
      mDlg('Your data file includes Section 1256 contracts!' + cr //
        + cr //
        + 'Therefore you must run the Section 1256 Contracts (for Form 6781) report' + cr //
        + 'from the Reports menu to get the totals for your Section 1256 trading' + cr //
        + 'activity which is not reported on Schedule D.', mtWarning, [mbOK], 1);
    end;
    if HasCurrencies then begin
      mDlg('Your data file includes Currency trades!' + cr //
        + cr //
        + 'Therefore you must run the Forex / Currencies report from the Reports menu' + cr //
        + 'to get the totals for your Currency trading activity which is not reported' + cr //
        + 'on Schedule D.', mtWarning, [mbOK], 1);
    end;
  end;
end;




// ==============================================
procedure RunReport(SDate: TDate; EDate: TDate; IncludeWashSales: boolean;
  WSBetweenSL: boolean; IncludeAdjustment: boolean);
// ==============================================
begin
//  StartTime := now();
  glReportRows := 0;
  with frmMain do begin
    rptIncludeWashSales := IncludeWashSales;
    frmFastReports := TfrmFastReports.Create(frmMain);
    dataFastReports := TdataFastReports.Create(frmMain);
    screen.Cursor := crHourglass;
    try
      stopReport := false;
      StatBar('Running Report - Please Wait!');
      // --- unit-scope variables -----
      noST := false;
      noLT := false;
      // --- funcproc global vars -----
      PrvDeferrals := 0;
      PrvDeferralsST := 0;
      PrvDeferralsLT := 0;
      PrvPl := 0;
      PrvPlST := 0;
      PrvPlLT := 0;
      PrvSales := 0;
      PrvSalesST := 0;
      PrvSalesLT := 0;
      PrvCost := 0;
      PrvCostST := 0;
      PrvCostLT := 0;
      // --- Reports global vars ------
      ClipStr := TStringList.Create;
      ClipStr.Capacity := 0;
      // --- unit-scope variables -----
      RptRowsDone := 0;
      // --- TLCharts vars ------------
      RunningPerfRpt := false;
      RunningChartRpt := false;
      // --- end ----------------------
      // These two really need to be passed to the methods,
      // but Rave prevents this. As soon as Rave is gone
      // we need to fix this - Dave
      StartDate := SDate;
      EndDate := EDate;
      // hide quick start panel
      // ========================
      // Reports:
      // --- Tax Analysis ---
      //  Reconcile 1099-B
      //  Wash Sale Details
      //  Potential Wash Sales
      // --- Taxes: Indiv (1040) ---
      //  Schedule D-1
      //  Gains & Losses (State Sched D)
      //  Section 1256 (Form 6781)
      //  For Ex/Currencies
      //  MTM Acctg (Form 4797)
      // --- Taxes: Entity (1040) ---
      //  Schedule D-1
      //  Gains & Losses (State Sched D)
      //  Section 1256 (Form 6781)
      //  For Ex/Currencies
      //  MTM Acctg (Form 4797)
      // --- Trade Analysis ---
      //  Realized P&L
      //  Detail
      //  Summary
      //  Performance
      //  Chart
      // ========================
      // TAX ANALYSIS
      if (ReportStyle = rptRecon) then begin
        OShNextYrSales := 0;
        // 2015-03-02 added so W recs do not change option sales not
        // reported on 1099
        filterOutWashSales;
        // do not calc wash sales for MTM accounts
        if TradeLogFile.CurrentAccount.MTM then begin
          if not PrepareForGainsReports(SDate, EDate, false, false) then exit; // MTM
        end
        else begin
         if not PrepareForGainsReports(SDate, EDate, True, True) then exit; // Cash
        end;
        // -----
        if not(TradeLogFile.CurrentAccount.ShortOptGL) then
          optSales := 0; // 2017-01-13 MB - Clear optSales before (re)computing it.
        Run1099Recon;
        exit;
      end
      //
      else if (ReportStyle = rptWashSales) then begin
        if not PrepareForGainsReports(SDate, EDate, IncludeWashSales, WSBetweenSL) then
          exit;
        if (high(datDeferralsST) = -1) //
        and (high(datDeferralsLT) = -1) //
        and (High(datDeferralsIRA) = -1) //
        then begin
          mDlg('Good News!' + cr //
            + cr //
            + 'There are no disallowed or deferred losses resulting from' + cr //
            + 'wash sale adjustments during this tax year.' + cr //
            + cr //
            + '(To view all Wash Sale adjustments, please run the' + cr //
            + 'Gains and Losses report.)' + cr,
            mtInformation, [mbOK], 0);
          stopReport := True;
          exitReports.Click;
          screen.cursor := crDefault;
          exit;
        end;
        dataFastReports.RunWSDetailReport;
        exit;
      end
      //
      else if (ReportStyle = rptPotentialWS) then begin
        if not PrepareForGainsReports(SDate, EDate, IncludeWashSales, WSBetweenSL) then exit;
        dataFastReports.RunWSPotentialReport;
        exit;
      end
      // ====================
      //     TAX REPORTS
      // ====================
      // Run the new 8949 Report instead of the D1. Also the New Recon Report.
      else if (ReportStyle = rptIRS_D1) then begin // form 8949
        if not PrepareForGainsReports(SDate, EDate, True, True) then exit;
        if (strToInt(Taxyear) > 2010) then begin
          b8949 := True;

//          dataFastReports.Run8949Summary;

          dataFastReports.Run8949Report(
            frmMain.cbInc8949Summary.Checked,
            frmMain.cbForm8949.Checked,
            IncludeAdjustment)

        end
        else begin
          dataFastReports.RunIRSD1Report;
        end;
        exit;
      end
      // Gains & Losses report
      else if (ReportStyle in [rptSubD1, rptGAndL, rptCurrencies, rpt4797]) then begin
        if not PrepareForGainsReports(SDate, EDate, IncludeWashSales, WSBetweenSL) then exit;
        dataFastReports.RunGandLReport(ReportStyle = rpt4797);
        // ReportStyle = rpt4797 is a boolean
        optSales := 0; // 2020-04-14 MB - clear it AFTER it's used.
        exit;
      end
      //
      else if (ReportStyle = rptFutures) then begin
        if not PrepareForGainsReports(SDate, EDate, false, false) then exit;
        dataFastReports.RunFuturesReport;
        exit;
      end
      //
      else if ReportStyle = rptMTM then begin
//        FastReportsData.LastRecNo := 0;
        FastReportsData.PassNum := 0;
        dataFastReports.RunSecuritiesMTM;
        exit;
      end
      // ====================
      /// TRADE ANALYSIS
      // ====================
      else if (ReportStyle in [rptTickerSummary, rptTradeSummary, rpt481Adjust])
      then begin
        GetReportSummary;
        dataFastReports.RunReportSummary;
        exit;
      end
      //
      else if (ReportStyle in [rptTradeDetails, rptDateDetails, rptTickerDetails]) then begin
        dataFastReports.RunDetailReport(frmMain.cbSubTotals.checked);
        exit;
      end
      //
      else if ReportStyle = rptPerformance then begin
        Title := 'Performance Report';
        dataFastReports.RunPerformanceReport;
        exit;
      end
      //
      else if pnlChart.Visible then begin
        Title := 'Chart Report';
        if not(cbWin.checked or cbLose.checked) then begin
          sm('You must check one or both' + cr //
            + cr //
            + 'Winners or Losers check boxes.');
          stopReport := True;
        end
        else if rbTickCompare.checked then begin
          stopReport := not(ComposeHChart);
          ReportStyle := rptHorizChart;
        end
        else if rbStrategy.checked then begin
          stopReport := not(ComposeHChart);
          ReportStyle := rptHorizChart;
        end
        else begin
          stopReport := not(ComposeVCharts);
          ReportStyle := rptVertCharts;
        end; // if checkbox block
        // ___ STOP? ___
        if stopReport then begin
          ReportStyle := rptNone;
          exit;
        end; // ________
        dataFastReports.RunChartsReport;
        exit;
      end;
    finally
      b8949 := false;
      StatBar('off');
      screen.Cursor := crDefault;
      frmMain.cxGrid1.Enabled := True;
    end;
  end;
end; // RunReport


// Add to datSummary & to clipStr (for Preview's Copy to Clipbvoard)
procedure StoreReportSummary();
begin
  With frmMain do
    With datSummary[rptSumItem] do begin
      if ReportStyle = rptTradeSummary then
        Desc := IntToStr(curntTrNum) + ') '
      else
        Desc := IntToStr(rptSumItem + 1) + ') ';
      Desc := Desc + FloatToStrF(accuTrShares, ffGeneral, 9, 1, settings.UserFmt)
        + ' (' + curntLS + ') ' + curntTick;
      If rndto5(Open) <> 0 then
        Desc := Desc + ' - ' + FloatToStrF(Open, ffGeneral, 9, 1, settings.UserFmt) + ' OPEN';
      TrCost := accuTrCost;
      TrSales := accuTrSales;
      CostTot := CostTot + accuTrCost;
      ProfTot := ProfTot + TrPl;
      SlsprTot := SlsprTot + accuTrSales;
      // curntTick:= desc;    2010-03-01
      // Create clipStr addendum
      curntData := IntToStr(rptSumItem + 1) + Tab
        + FloatToStrF(accuTrShares, ffGeneral, 9, 1, settings.UserFmt) + Tab
        + curntLS + Tab + curntTick + Tab;
      if dtAcq > 0 then curntData := curntData + DateToStr(dtAcq, settings.UserFmt);
      curntData := curntData + Tab;
      if dtSld > 0 then curntData := curntData + DateToStr(dtSld, settings.UserFmt);
      curntData := curntData + Tab;
      if TrSales <> 0 then curntData := curntData + FloatToStrF(TrSales, ffFixed, 12, 2, settings.UserFmt);
      curntData := curntData + Tab;
      if TrCost <> 0 then curntData := curntData + FloatToStrF(TrCost, ffFixed, 12, 2, settings.UserFmt);
      curntData := curntData + Tab;
      if TrPl <> 0 then curntData := curntData + FloatToStrF(TrPl, ffFixed, 12, 2, settings.UserFmt);
      ClipStr.Capacity := ClipStr.count + 1;
      ClipStr.Add(curntData); // For Preview's Copy to Clipboard
    end
end;


procedure ParseWsLists;
var
  i : Integer;
begin
  // get totals
  if DoST and not DoLT then begin
    JanTotST := 0;
    OpenTotST := 0;
    DefrStCount := high(datDeferralsST) + 1;
    for i := 0 to DefrStCount - 1 do begin
      with datDeferralsST[i] do begin
        JanTotST := JanTotST + JanAmt;
        OpenTotST := OpenTotST + OpenAmt;
      end;
    end;
    // sm('OpenTotST: '+floattostr(OpenTotST,Settings.UserFmt)+cr+'JanTotST: '+floattostr(JanTotST,Settings.UserFmt));
  end
  else if DoLT and not DoST then begin
    JanTotLT := 0;
    OpenTotLT := 0;
    DefrLtCount := high(datDeferralsLT) + 1;
    for i := 0 to DefrLtCount - 1 do begin
      with datDeferralsLT[i] do begin
        JanTotLT := JanTotLT + JanAmt;
        OpenTotLT := OpenTotLT + OpenAmt;
      end;
    end;
  end;
  // sm('datDeferralsST count: '+inttostr(high(datDeferralsST))+cr
  // +'datDeferralsLT count: '+inttostr(high(datDeferralsLT)) );
end;



procedure PrintMTMRpts(SDate: TDate; EDate: TDate;
  IncludeWashSales: boolean;
  WSBetweenSL: boolean; IncludeAdjustment: boolean);
begin
  glReportRows := 0;
  with frmMain do begin
    frmFastReports := TfrmFastReports.Create(frmMain);
    dataFastReports := TdataFastReports.Create(frmMain);
    screen.Cursor := crHourglass;
    try
      stopReport := false;
      StatBar('Running Report - Please Wait!');
      // --- unit-scope variables -----
      noST := false;
      noLT := false;
      // --- funcproc global vars -----
      PrvDeferrals := 0;
      PrvDeferralsST := 0;
      PrvDeferralsLT := 0;
      PrvPl := 0;
      PrvPlST := 0;
      PrvPlLT := 0;
      PrvSales := 0;
      PrvSalesST := 0;
      PrvSalesLT := 0;
      PrvCost := 0;
      PrvCostST := 0;
      PrvCostLT := 0;
      // --- Reports global vars ------
      ClipStr := TStringList.Create;
      ClipStr.Capacity := 0;
      // --- unit-scope variables -----
      RptRowsDone := 0;
      // --- for Rave -------
      StartDate := SDate;
      EndDate := EDate;
      // ====================
      //     TAX REPORTS
      // ====================
      // Gains & Losses report
      if (ReportStyle = rpt4797) then begin
        if not PrepareForGainsReports(SDate, EDate, IncludeWashSales, WSBetweenSL) then exit;
        dataFastReports.RunGandLReport(ReportStyle = rpt4797);
//        PrintRptToPDF(v2UserName + '_' + TradeLogFile.TaxYear + '_4797.pdf');
        optSales := 0;
        exit;
      end
      //
      else if (ReportStyle = rptFutures) then begin
        if not PrepareForGainsReports(SDate, EDate, false, false) then exit;
        dataFastReports.RunFuturesReport;
        exit;
      end
      //
      else if (ReportStyle = rptMTM) then begin
        FastReportsData.PassNum := 0;
        dataFastReports.RunSecuritiesMTM;
        exit;
      end;
    finally
      StatBar('off');
      screen.Cursor := crDefault;
      frmMain.cxGrid1.Enabled := True;
    end;
  end;
end;


initialization


end.
