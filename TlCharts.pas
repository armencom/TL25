unit TlCharts;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, ComCtrls, Buttons, Series,
  cxCustomData, TeEngine, TeeProcs, DbChart, TeeFunci, TeeStore, ExtCtrls, Chart, StdCtrls, CommDlg,
  Dialogs, StrUtils;

type
  TfrmTlCharts = class(TForm)
    SharesPieChart : TDBChart;
    PL_PieChart : TDBChart;
    TLVertBarChart1 : TDBChart;
    TLLineChart1 : TDBChart;
    SeriesShares : TPieSeries;
    SeriesPL : TPieSeries;
    SeriesLineDefault : TLineSeries;
    VBarWinners : TBarSeries;
    VBarLosers : TBarSeries;
    SeriesLinePurchases : TLineSeries;
    TeeFunction1 : TAddTeeFunction;
    TeeFunction2 : TAddTeeFunction;
    tmrFS_Dlg : TTimer;
    TLHorizBarChart1 : TDBChart;
    HBarWinners : THorizBarSeries;
    HBarLosers : THorizBarSeries;
    procedure tmrFS_DlgTimer(Sender : TObject);
    private
      function FileSaveDialog(Filter, DefExt, Title :string; var Path, FileName :string) : bool;
      function GetTickSeg(thisTick, thisType : string) : integer;
      function GetTimeSeg(thisTime : TTime) : integer;
      function PrepareHChart : boolean;
      procedure PrepareVCharts;
      procedure SendPeriodicVChart(j : integer);
      procedure SendHorizData(Segment : integer);
      procedure SendVertData(ChartTitle : string; DateNum : Tdate; PreferLine : boolean = false);
    public
    { Public declarations }
  end;

function ComposeHChart : boolean;
function ComposeVCharts : boolean;
procedure ComposePerfRpt;
function GetStrategyProfit(index : integer): Double;

const
  // Horizontal Chart "Intervals"
  chrtIntTickCompare = 0;
  // Vertical Charts "Intervals"
  chrtIntDaily = 100;
  chrtIntWeekly = 101;
  chrtIntMonthly = 102;
  chrtIntWeekDay = 103;
  chrtIntTimeDay = 104;
  // ChartTypes
  chrtTypProfit = 0;
  chrtTypSales = 1;
  chrtTypComm = 2;
  chrtTypAveNum = 3;
  chrtTypPerCent = 4;
  chrtTypShares = 5;
  chrtTypAvePlShares = 6;
  chrtTypAvePlTrades = 7;
  chrtTypAvePandL = 8;
  chrtTypTotPandL = 9;
  chrtTypAvePorL = 10;
  chrtTypTotPorL = 11;
  // Ticker Types
  tckrStocks = 0;
  tckrOptions = 1;
  tckrFutures = 2;
  tckrSSFs = 3;
  tckrCurrencies = 4;

var
  frmTlCharts : TfrmTlCharts;
  DlgOpen, RunningChartRpt, RunningPerfRpt : boolean;
  dlgFS_Title : Pchar;
  TradesIndex, MainLeft, MainTop, MainHeight, MainWidth : integer;
  ProcessedTradeList, ShProfitList : TStringList;
  ShowLineChart : boolean;

implementation

uses
  Main, FuncProc, Import, TLSettings, TLCommonLib, TLFile, Reports, dxCore;

{$R *.DFM}

var
  LastTrNum, TotTrades, AveShPerTr, BarWidth, ChartInterval, ChartType, Segments, LastRecordIndex,
    TickType, numBars : integer;
  LastDate, sLastClipStr : string;
  // --------------
  Prof, ProfTr, ProfTot, TotProf, TotProfDiff, TotComm, TotShares, SharesTot, TotWin, TotWinSh,
    AveWinProfPerSh, LargestWin, PercWinSh, TotBuy, TotSell, TotFlat, TotFlatSh, AveFlatProfPerSh,
    PercFlatSh, TotLoser, TotLoserSh, AveLoserProfPerSh, LargestLoss, PercLoserSh, Purch, PurchTot,
    Sales, SalesTot, Comm, CommTot, AveProfPerSh, AveProfPerTr, PercTotSh, Shares, Loss : Double;
  // --------------
  ProfTotBegan, PurchTotBegan, SalesTotBegan, SharesTotBegan, RequirePL, ProfTotSeen, SharesTotSeen,
    ComTotBegan, Periodic : boolean;
  // --------------
  DateNum, WeekEnd : Extended;
  // --------------
  ChartTitle, ChrtXLabel, ChrtYLabel : string;
  EndTime, StartTime : TTime;
  PeriodLabels : TStringList;
  Periods : array of integer;
  PeriodicWinners : array of Extended;
  PeriodicLosers : array of Extended;


function FSCallback(Wnd : HWnd; Msg : UINT; WParam : WParam; LParam : LParam): UINT; stdcall;
begin
  Result := 1; // Dialog may close
  case Msg of
  WM_NOTIFY : begin
      if POFNotify(LParam)^.hdr.code = CDN_INITDONE then
        frmTlCharts.tmrFS_Dlg.Enabled := true;
    end;
  end;
end;


function TfrmTlCharts.FileSaveDialog(Filter, DefExt, Title :string;
  var Path, FileName :string) : bool;
var
  // Structure identical to OpenFile; Difference is in nature of Call below
  { Todd Flora changed to use TOpenFileName without the A so that Delphi decides
  on which OpenDialog to use. }
  FSDlg : TOpenFileName;
  ChoseFile : bool;
  InitDir, Pattern, FiltBuff : string;
  i : integer;
  P2 : Pchar;
begin
  Result := false;
  Pattern := '';
  InitDir := Path;
  SetLength(Path, MAX_PATH + 2);
  SetLength(FileName, MAX_PATH + 2);
  SetLength(FiltBuff, Length(Filter) + 2);
  try
    MainTop := FrmMain.top;
    MainLeft := FrmMain.left;
    MainWidth := FrmMain.width;
    MainHeight := FrmMain.height;
    FillChar(FSDlg, SizeOf(FSDlg), 0);
    FSDlg.hInstance := hInstance;
    with FSDlg do begin
      nFilterIndex := 1;
      lStructSize := SizeOf(FSDlg);
      hWndOwner := frmTlCharts.Handle;
      nMaxFile := MAX_PATH;
      nMaxFileTitle := MAX_PATH;
      lpstrFile := Pchar(Path);
      FillChar(lpstrFile^, MAX_PATH + 2, 0);
      StrLCopy(lpstrFile, '', MAX_PATH);
      lpstrTitle := Pchar(Title);
      dlgFS_Title := lpstrTitle;
      lpfnHook := @FSCallback;
      lpstrFileTitle := Pchar(FileName);
      FillChar(lpstrFileTitle^, MAX_PATH + 2, 0);
      StrLCopy(lpstrFileTitle, '', MAX_PATH);
      lpstrFilter := Pchar(Filter);
      // if Filter contains a see-only extension, use it, else use DefExt
      i := Length(Filter);
      lpstrFilter := Pchar(FiltBuff);
      FillChar(lpstrFilter^, i + 2, 0);
      StrLCopy(lpstrFilter, Pchar(Filter), i);
      i := posex(char(0), Filter);
      if i > 1 then begin
        Pattern := copy(Filter, i + 1, 255);
        P2 := StrEnd(lpstrFilter);
        inc(P2);
        StrLCopy(P2, Pchar(Pattern), Length(Pattern));
      end
      else
        lpstrDefExt := Pchar(DefExt);
      lpstrInitialDir := Pchar(InitDir);
      Flags := OFN_NOREADONLYRETURN + OFN_ENABLEHOOK + OFN_EXPLORER + OFN_HIDEREADONLY +
        OFN_PATHMUSTEXIST;
      repeat
        DlgOpen := true;
        ChoseFile := GetSaveFileName(FSDlg);
        if ChoseFile = true then
          if (Flags and OFN_EXTENSIONDIFFERENT <> 0) then
            sm('Desired file MUST have extension .' + DefExt)
          else begin
            parseLast(Path, '\');
            SetLength(FileName, pos(char(0), FileName) - 1);
            Result := true;
            exit;
          end;
        // end if
      until (ChoseFile = false) or (Flags and OFN_EXTENSIONDIFFERENT = 0);
    end;
  except
  end;
  DlgOpen := false;
end;


function TfrmTlCharts.GetTickSeg(thisTick, thisType : string) : integer;
begin
  Result := -1;
  if FrmMain.rbTickCompare.checked then begin
    case TickType of
    tckrStocks :
      if (leftstr(thisType, 3) <> 'STK') and (leftstr(thisType, 3) <> 'MUT')
      and (leftstr(thisType, 3) <> 'ETF') and (leftstr(thisType, 3) <> 'DRP') then
        exit;
    tckrOptions :
      if leftstr(thisType, 3) <> 'OPT' then exit;
    tckrFutures :
      if leftstr(thisType, 3) <> 'FUT' then exit;
    tckrSSFs :
      if leftstr(thisType, 3) <> 'SSF' then exit;
    tckrCurrencies :
      if leftstr(thisType, 3) <> 'CUR' then exit;
    end;
  end;
  Result := PeriodLabels.IndexOf(trim(thisTick));
end;


function TfrmTlCharts.GetTimeSeg(thisTime : TTime) : integer;
var
  i : integer;
begin
  Result := -1;
  if (thisTime < StartTime) or (thisTime > EndTime) then exit;
  for i := 0 to Segments do begin
    if i = Segments then
      Result := i
    else if Settings.ChartDataList.ActiveChartData.ChartTimes[i + 1] = NoTime then begin
      Result := i;
      break;
    end
    else if (thisTime >= Settings.ChartDataList.ActiveChartData.ChartTimes[i + 1])
    and (thisTime < Settings.ChartDataList.ActiveChartData.ChartTimes[i + 2]) then begin
      Result := i;
      break;
    end;
  end;
end;


procedure ComposePerfRpt;
var
  i, ShOpenTick, LastMonth, TotWinTrades, TotFlatTrades, TotLoserTrades, AveWinShPerTr,
    AveFlatShPerTr, AveLoserShPerTr : integer;
  AveProfPerTr, AveWinProfPerTr, AveLoserProfPerTr : Double;
  Trade : TTLTrade;
  Title : string;
begin
  RunningPerfRpt := true;
  Title := '';
  // --------------
  AveProfPerSh := 0;
  AveProfPerTr := 0;
  AveShPerTr := 0;
  TotProf := 0;
  TotProfDiff := 0;
  TotComm := 0;
  TotShares := 0;
  TotBuy := 0;
  TotSell := 0;
  TotTrades := 0;
  // --------------
  AveWinProfPerSh := 0;
  AveWinProfPerTr := 0;
  AveWinShPerTr := 0;
  LargestWin := 0;
  TotWin := 0;
  TotWinSh := 0;
  TotWinTrades := 0;
  // --------------
  TotFlat := 0;
  TotFlatSh := 0;
  AveFlatProfPerSh := 0;
  PercFlatSh := 0;
  AveFlatShPerTr := 0;
  TotFlatTrades := 0;
  // --------------
  AveLoserProfPerSh := 0;
  AveLoserProfPerTr := 0;
  AveLoserShPerTr := 0;
  TotLoser := 0;
  TotLoserSh := 0;
  LargestLoss := 0;
  PercLoserSh := 0;
  TotLoserTrades := 0;
  with frmTlCharts do begin
    Title := 'Trading Performance Report';
// if IsInt(GridDisplay) then
// title:= 'Trades - Trade # '+ gridDisplay
// else if GridDisplay = 'Futures' then
// title:= 'Futures ' + title
// else if GridDisplay = 'Stocks && Options' then
// title:= 'Stocks & Options ' + title;
    Title := Title + FrmMain.GetFilterDataFromPanel;
    /// //////// Calculate Trade Performance Values ///////////
    LastTrNum := 0;
    /// SORT by Date
    FrmMain.cxGrid1TableView1.items[2].SortOrder := soAscending;
    with FrmMain.cxGrid1TableView1.DataController do
      for i := 0 to FilteredRecordCount - 1 do begin
        Trade := TradeLogFile[FrmMain.cxGrid1TableView1.DataController.FilteredRecordIndex[i]];
        Prof := Trade.PL;
        if not Settings.DispWSdefer and (Trade.OC = 'W')
        and (pos('01/01', DateToStr(Trade.Date, Settings.UserFmt))= 0) then
          continue;
        if (Trade.Date < StartDate) or (Trade.Date > EndDate) then continue;
        TotProf := TotProf + Trade.PL;
        ProfTr := ProfTr + Trade.PL;
        TotComm := TotComm + Trade.Commission;
        if (TradeLogFile.CurrentBrokerID > 0)
        and (TradeLogFile.CurrentAccount.FileImportFormat = 'Globex') then begin
          datPerf.contracts := true;
          with SharesPieChart.Foot.Text do begin
            Clear;
            Add('CONTRACTS');
          end;
        end
        else begin
          Shares := Trade.Shares;
          datPerf.contracts := false;
        end;
        if (Trade.OC <> 'O') and (Trade.OC <> 'W') then begin
          TotShares := TotShares + Shares;
          AveProfPerSh := TotProf / TotShares;
        end;
        if ((Trade.OC = 'O') and (Trade.LS = 'L'))
        or ((Trade.OC = 'C') and (Trade.LS = 'S')) then
          TotBuy := TotBuy - Trade.Amount;
        if ((Trade.OC = 'C') and (Trade.LS = 'L'))
        or ((Trade.OC = 'O') and (Trade.LS = 'S')) then
          TotSell := TotSell + Trade.Amount;
        if Trade.TradeNum > LastTrNum then
          ProfTr := 0;
        if Trade.OC = 'C' then
          inc(TotTrades);
        try
          TotProfDiff := TotSell - TotBuy - TotProf;
          if TotTrades > 0 then begin
            AveProfPerTr := TotProf / TotTrades;
            AveShPerTr := round(TotShares / TotTrades);
          end;
          if Prof > 0 then begin // Winners
            inc(TotWinTrades);
            TotWin := TotWin + Prof;
            TotWinSh := TotWinSh + Shares;
            AveWinProfPerSh := TotWin / TotWinSh;
            if Prof > LargestWin then
              LargestWin := Prof;
            AveWinProfPerTr := TotWin / TotWinTrades;
            AveWinShPerTr := round(TotWinSh / TotWinTrades);
          end
          else if Prof < 0 then begin // Losers
            inc(TotLoserTrades);
            TotLoser := TotLoser + Prof;
            TotLoserSh := TotLoserSh + Shares;
            if TotLoserSh > 0 then
              AveLoserProfPerSh := TotLoser / TotLoserSh;
            if Prof < LargestLoss then
              LargestLoss := Prof;
            AveLoserProfPerTr := TotLoser / TotLoserTrades;
            AveLoserShPerTr := round(TotLoserSh / TotLoserTrades);
          end
          else if ((Trade.OC <> 'O') and (Trade.OC <> 'W')) then begin // Flat
            inc(TotFlatTrades);
            TotFlatSh := TotFlatSh + Shares;
            AveFlatShPerTr := round(TotFlatSh / TotFlatTrades);
          // AveFlatProfPerSh:= TotFlat / TotFlatSh;
          // TotFlat:= TotFlat + pr;
          end;
        except
        end; // try
        LastTrNum := Trade.TradeNum;
      end; // For Sort by Trade Num
    if TotShares > 0 then begin
      PercLoserSh := TotLoserSh / TotShares;
      PercFlatSh := TotFlatSh / TotShares;
    end;
    /// ////////       Compose Report Data        ///////////
    with datPerf do begin
      avgPLsh := AveProfPerSh;
      avgPLtr := AveProfPerTr;
      avgSHtr := AveShPerTr;
      diff := TotProfDiff;
      fltAvgSHtr := AveFlatShPerTr;
      fltPercent := round(PercFlatSh * 100);
      fltShares := TotFlatSh;
      lsrAvgLsh := AveLoserProfPerSh; // Losing Average Loss per share
      lsrAvgLtr := AveLoserProfPerTr; // Losing Average Loss per trade
      lsrAvgSHtr := AveLoserShPerTr; // Losing Average shares per trade
      lsrL := TotLoser; // Losses
      lsrLargest := LargestLoss; // Largest Loss
      lsrPercent := round(PercLoserSh * 100); // Losing Percentage
      lsrShares := TotLoserSh; // Losing Shares
      totalComm := TotComm;
      totalCost := TotBuy;
      totalPL := TotProf;
      totalSales := TotSell;
      totalShares := TotShares;
      winAvgPsh := AveWinProfPerSh;
      winAvgPtr := AveWinProfPerTr;
      winAvgSHtr := AveWinShPerTr;
      winLargest := LargestWin;
      winP := TotWin;
      winPercent := 100 - (lsrPercent + fltPercent);
      winShares := TotWinSh;
      // Prepare Charts
      SeriesShares.Clear;
      SeriesPL.Clear;
      if Settings.ReportPageData.UseColor then begin
        SeriesShares.Add(winPercent, 'Winners', clGreen);
        SeriesShares.Add(fltPercent, 'Flat', clWhite);
        SeriesShares.Add(lsrPercent, 'Losers', clRed);
        SeriesPL.Add(TotWin, 'Winners', clGreen);
        // SeriesPL.Add(TotFlat,'Flat',clWhite);
        SeriesPL.Add(TotLoser, 'Losers', clRed);
      end
      else begin
        SeriesShares.Add(winPercent, 'Winners', clWhite);
        SeriesShares.Add(fltPercent, 'Flat', clGray);
        SeriesShares.Add(lsrPercent, 'Losers', clBlack);
        SeriesPL.Add(TotWin, 'Winners', clWhite);
        // SeriesPL.Add(TotFlat,'Flat',clGray);
        SeriesPL.Add(TotLoser, 'Losers', clBlack);
      end;
      SharesPieChart.Repaint;
      PL_PieChart.Repaint;
    end; // With datPerf
  end; // With frmMain
end;


procedure TfrmTlCharts.SendVertData(ChartTitle : string; DateNum : Tdate;
  PreferLine : boolean = false);
begin
//  if DateToStr(DateNum) <> sLastClipStr then
//    ClipStr.Add(DateToStr(DateNum) + TAB + FloatToStr(Prof));
//  sLastClipStr := DateToStr(DateNum);
  with FrmMain do
    with frmTlCharts do
      case ChartType of
      chrtTypProfit : begin
          if PreferLine then begin
            if ProfTotBegan and not ProfTotSeen then begin
              ProfTotSeen := true;
              SeriesLineDefault.AddXY(DateNum, 0, '', clGreen);
            end;
            if ProfTotSeen then
              SeriesLineDefault.AddXY(DateNum, ProfTot, '', clGreen);
            ShowLineChart := true;
          end
          else begin
            if Prof < 0 then begin
              VBarLosers.AddXY(DateNum,-Prof, ChrtXLabel, clRed);
              VBarWinners.AddXY(DateNum, 0, ChrtXLabel, clGreen)
            end
            else begin
              VBarLosers.AddXY(DateNum, 0, ChrtXLabel, clRed);
              VBarWinners.AddXY(DateNum, Prof, ChrtXLabel, clGreen);
            end;
          end;
        end;
      chrtTypSales : begin
          if not(PreferLine) then begin
            if Sales > 0 then begin
              VBarWinners.AddXY(DateNum, 0, ChrtXLabel, clGreen);
              VBarWinners.AddXY(DateNum, Sales, ChrtXLabel, clGreen);
            end;
            if Purch > 0 then begin
              VBarLosers.AddXY(DateNum, 0, ChrtXLabel, clRed);
              VBarLosers.AddXY(DateNum, Purch, ChrtXLabel, clRed);
            end;
          end;
        end;
      chrtTypComm : begin
          if PreferLine then begin
            if ComTotBegan then
              SeriesLineDefault.AddXY(DateNum, 0, '', clRed);
            if CommTot <> 0 then
              SeriesLineDefault.AddXY(DateNum, CommTot, '', clRed);
            ShowLineChart := true;
          end
          else if Comm <> 0 then
            VBarLosers.AddXY(DateNum, Comm, '', clRed);
        end;
      chrtTypAveNum : begin
          if not(PreferLine) then
            if AveShPerTr <> 0 then
              VBarWinners.AddXY(DateNum, AveShPerTr, '', clGreen);
        end;
      chrtTypPerCent : begin
          if not(PreferLine) and (Sales > 0) then begin
            if PercWinSh <> 0 then
              VBarWinners.AddXY(DateNum, PercWinSh, '', clGreen);
            if PercLoserSh <> 0 then
              VBarLosers.AddXY(DateNum, PercLoserSh, '', clRed);
          end;
        end;
      chrtTypShares : begin
          if PreferLine then begin
            if SharesTotBegan and not SharesTotSeen then begin
              SharesTotSeen := true;
              SeriesLineDefault.AddXY(DateNum, 0, '', clGreen);
            end;
            if SharesTotSeen then
              SeriesLineDefault.AddXY(DateNum, SharesTot, '', clGreen);;
            ShowLineChart := true;
          end
          else if Shares <> 0 then
            VBarWinners.AddXY(DateNum, Shares, '', clGreen);
        end;
      chrtTypAvePlShares :
        if not(PreferLine) then begin
          if (pos('Ave Prof/Loss Per Share', ChartTitle)> 0) or
            (pos('Ave Prof/Loss Per Contract', ChartTitle)> 0) then begin
            if Shares > 0 then
              if AveProfPerSh < 0 then
                VBarLosers.AddXY(DateNum,-AveProfPerSh, '', clRed)
              else
                VBarWinners.AddXY(DateNum, AveProfPerSh, '', clGreen);
          end;
        end;
      chrtTypAvePlTrades :
        if not(PreferLine) then begin
          if Shares > 0 then
            if AveProfPerTr < 0 then
              VBarLosers.AddXY(DateNum,-AveProfPerTr, '', clRed)
            else
              VBarWinners.AddXY(DateNum, AveProfPerTr, '', clGreen);
        end;
      chrtTypAvePandL, chrtTypTotPandL : begin
          VBarLosers.AddXY(DateNum, Loss, ChrtXLabel, clRed);
          VBarWinners.AddXY(DateNum, Prof, ChrtXLabel, clGreen)
        end;
      chrtTypAvePorL, chrtTypTotPorL : begin
          if Prof < 0 then begin
            VBarLosers.AddXY(DateNum,-Prof, ChrtXLabel, clRed);
            VBarWinners.AddXY(DateNum, 0, ChrtXLabel, clGreen)
          end
          else begin
            VBarLosers.AddXY(DateNum, 0, ChrtXLabel, clRed);
            VBarWinners.AddXY(DateNum, Prof, ChrtXLabel, clGreen);
          end;
        end;
      end;
end;


function TfrmTlCharts.PrepareHChart : boolean;
var
  i : integer;
  ReportParam : string;
  RecordIDX : integer;
begin
  with FrmMain do
    with frmTlCharts do begin
      Title := 'Chart';
      TLHorizBarChart1.Series[1].Color := clGreen;
      if rbStrategy.checked then begin
        PeriodLabels.Clear;
        for i := 0 to LastRecordIndex - 1 do begin
          RecordIDX := cxGrid1TableView1.DataController.FilteredRecordIndex[i];
          if (PeriodLabels.IndexOf(trim(TradeLogFile[RecordIDX].strategy)) = -1) and
            (trim(TradeLogFile[RecordIDX].strategy) <> EmptyStr) then
            PeriodLabels.Add(trim(TradeLogFile[RecordIDX].strategy));
        end;
      end;
      if rbTickCompare.checked then begin
        ChartTitle := cbTickType.Text;
        if ChartTitle = 'Options' then
          TickType := tckrOptions
        else if ChartTitle = 'Futures' then
          TickType := tckrFutures
        else if ChartTitle = 'SSFs' then
          TickType := tckrSSFs
        else if ChartTitle = 'Currencies' then
          TickType := tckrCurrencies
        else begin
          TickType := tckrStocks;
          ChartTitle := ChartTitle + ', Mutual Funds, ETFs/ETNs, Drips';
        end;
      // Get Period Labels
        PeriodLabels.Clear;
        for i := 0 to LastRecordIndex - 1 do begin
          RecordIDX := cxGrid1TableView1.DataController.FilteredRecordIndex[i];
          case TickType of
          tckrStocks :
            if (leftstr(TradeLogFile[RecordIDX].TypeMult, 3) = 'STK') or
              (leftstr(TradeLogFile[RecordIDX].TypeMult, 3) = 'MUT') or
              (leftstr(TradeLogFile[RecordIDX].TypeMult, 3) = 'ETF') or
              (leftstr(TradeLogFile[RecordIDX].TypeMult, 3) = 'DRP') then
              if PeriodLabels.IndexOf(trim(TradeLogFile[RecordIDX].Ticker)) = -1 then
                PeriodLabels.Add(trim(TradeLogFile[RecordIDX].Ticker));
          tckrOptions :
            if leftstr(TradeLogFile[RecordIDX].TypeMult, 3) = 'OPT' then
              if PeriodLabels.IndexOf(trim(TradeLogFile[RecordIDX].Ticker)) = -1 then
                PeriodLabels.Add(trim(TradeLogFile[RecordIDX].Ticker));
          tckrFutures :
            if leftstr(TradeLogFile[RecordIDX].TypeMult, 3) = 'FUT' then
              if PeriodLabels.IndexOf(trim(TradeLogFile[RecordIDX].Ticker)) = -1 then
                PeriodLabels.Add(trim(TradeLogFile[RecordIDX].Ticker));
          tckrSSFs :
            if leftstr(TradeLogFile[RecordIDX].TypeMult, 3) = 'SSF' then
              if PeriodLabels.IndexOf(trim(TradeLogFile[RecordIDX].Ticker)) = -1 then
                PeriodLabels.Add(trim(TradeLogFile[RecordIDX].Ticker));
          tckrCurrencies :
            if leftstr(TradeLogFile[RecordIDX].TypeMult, 3) = 'CUR' then
              if PeriodLabels.IndexOf(trim(TradeLogFile[RecordIDX].Ticker)) = -1 then
                PeriodLabels.Add(trim(TradeLogFile[RecordIDX].Ticker));
          end; { case }
        end;
      end;
      Segments := PeriodLabels.Count;
      Result := Segments > 0;
      if not(Result) then
        exit;
      RunningChartRpt := true;
      ChartInterval := chrtIntTickCompare;
      SetLength(PeriodicWinners, 0);
      SetLength(PeriodicLosers, 0);
      SetLength(Periods, 0);
      Title := Title + GetFilterDataFromPanel;
      ReportParam := cbParameter.items[cbParameter.itemindex];
      RequirePL := ReportParam <> 'Purchases/Sales';
      LastDate := DateToStr(StartDate, Settings.UserFmt);
      HBarLosers.Clear;
      HBarWinners.Clear;
      HBarLosers.ShowInLegend := true;
      HBarWinners.ShowInLegend := true;
      if EndDate <> StartDate then
        BarWidth := round(TLVertBarChart1.width /(1.25 * abs(EndDate - StartDate)))
      else
        BarWidth := round(TLVertBarChart1.width / 1.25);
    // Bar Widths
      if BarWidth > 60 then
        BarWidth := 60
      else if BarWidth < 5 then
        BarWidth := 5;
      TLHorizBarChart1.Chart3dPercent := round(0.8 * BarWidth);
    // Titles & Legends, some specific to Profit / Loss
      if rbTickCompare.checked then
        ChartTitle := ChartTitle + ' Profit / Loss'
      else
        ChartTitle := 'Profit / Loss';
      if not cbWin.checked then
        ChartTitle := ChartTitle + ' Losers'
      else if not cbLose.checked then
        ChartTitle := ChartTitle + ' Winners';
      ChartType := chrtTypProfit;
      TLHorizBarChart1.view3d := false;
      HBarWinners.ShowInLegend := true;
      HBarWinners.Title := 'Profit';
      HBarLosers.Title := 'Loss';
      HBarWinners.Marks.Visible := false;
      HBarLosers.Marks.Visible := false;
      with TLHorizBarChart1 do begin
        while Page > 1 do
          PreviousPage;
        Legend.top := 25;
        Title.Text.Clear;
      { i := pos('/',ChartTitle);
      if i > 0 then begin
        Title.text.add(LeftStr(ChartTitle, i));
        Title.text.add(copy(ChartTitle, i + 1, length(ChartTitle)));
      end else } Title.Text.Add(ChartTitle);
        if (pos('Winners', Title.Text.Strings[0]) > 0) or (pos('Losers', Title.Text.Strings[0]) > 0)
        then
          HBarWinners.ShowInLegend := false;
        if HBarWinners.ShowInLegend = false then
          HBarLosers.ShowInLegend := false;
        if HBarLosers.ShowInLegend = false then
          HBarWinners.ShowInLegend := false;
        case ChartInterval of
        chrtIntTickCompare : begin
            BottomAxis.Increment := 1;
            TopAxis.Increment := 1;
            SetLength(PeriodicWinners, Segments + 1);
            SetLength(PeriodicLosers, Segments + 1);
            SetLength(Periods, Segments + 1);
            for i := 0 to Segments do begin
              PeriodicLosers[i] := 0;
              PeriodicWinners[i] := 0;
              Periods[i] := 0;
            end;
          end;
        end;
      end;
    end;
end;


function ComposeHChart : boolean;
var
  SendData : boolean;
  i, ThisSeg, MaxLabelLen : integer;
  MaxAmt : Double;
  ThisDate : Tdate;
  RecordIDX : integer;
  Year, Month, Day : Word;
begin
  ProcessedTradeList := TStringList.Create;
  ShProfitList := TStringList.Create;
  with FrmMain do
    with frmTlCharts do begin
      Result := false;
      cxGrid1TableView1.items[2].SortOrder := soAscending;
      LastRecordIndex := cxGrid1TableView1.DataController.FilteredRecordCount;
      if LastRecordIndex < 1 then begin
        sm('No records to show.');
        exit;
      end;
      PeriodLabels := TStringList.Create;
      PeriodLabels.Sorted := true;
      if not PrepareHChart then begin
        PeriodLabels.Destroy;
        sm('No records to show.');
        exit;
      end;
      for i := 0 to LastRecordIndex - 1 do begin
        RecordIDX := cxGrid1TableView1.DataController.FilteredRecordIndex[i];
        ShProfitList.Add(FloatToStr(TradeLogFile[RecordIDX].Shares, Settings.InternalFmt) + '=' +
            FloatToStr(TradeLogFile[RecordIDX].PL, Settings.InternalFmt));
      end;
    // Sorts are Base One
      for i := 0 to LastRecordIndex - 1 do begin
        RecordIDX := cxGrid1TableView1.DataController.FilteredRecordIndex[i];
      // Skip this record?
        ThisDate := TradeLogFile[RecordIDX].Date;
        if rbStrategy.checked then begin
          if trim(TradeLogFile[RecordIDX].strategy) = EmptyStr then
            continue;
        end
        else begin
          if ThisDate < StartDate then
            continue;
          if ThisDate > EndDate then
            break;
        end;
        if ChartInterval = chrtIntTickCompare then begin
          if rbTickCompare.checked then
            ThisSeg := GetTickSeg(TradeLogFile[RecordIDX].Ticker, TradeLogFile[RecordIDX].TypeMult)
          else
            ThisSeg := GetTickSeg(TradeLogFile[RecordIDX].strategy,
              TradeLogFile[RecordIDX].TypeMult);
          if ThisSeg = -1 then
            continue;
        end;
        decodeDate(ThisDate, Year, Month, Day);
        if not(Settings.DispWSdefer) and (TradeLogFile[RecordIDX].OC = 'W') then
          if (Month <> 1) or (Day <> 1) then
            continue;
        Prof := TradeLogFile[RecordIDX].PL;
        if RequirePL then begin
          if Prof = 0 then
            continue;
          if (not cbWin.checked) and (Prof > 0) then
            continue;
          if (not cbLose.checked) and (Prof < 0) then
            continue;
        end;
      // Commissions
        Comm := TradeLogFile[RecordIDX].Commission;
      // Sales & Purchases
        if TradeLogFile[RecordIDX].Amount <> 0 then begin
          if ((TradeLogFile[RecordIDX].OC = 'O') and (TradeLogFile[RecordIDX].LS = 'L')) or
            ((TradeLogFile[RecordIDX].OC = 'C') and (TradeLogFile[RecordIDX].LS = 'S')) then
            Purch := -TradeLogFile[RecordIDX].Amount
          else if ((TradeLogFile[RecordIDX].OC = 'C') and (TradeLogFile[RecordIDX].LS = 'L')) or
            ((TradeLogFile[RecordIDX].OC = 'O') and (TradeLogFile[RecordIDX].LS = 'S')) then
            Sales := TradeLogFile[RecordIDX].Amount;
        end;
      // Closing Shares, Averages, Percentages
        if TradeLogFile[RecordIDX].OC = 'C' then begin
          if TradeLogFile[RecordIDX].Shares > 0 then begin
            Shares := TradeLogFile[RecordIDX].Shares;
            if (TradeLogFile.CurrentBrokerID > 0) and
              (TradeLogFile.CurrentAccount.FileImportFormat = 'Globex') then
              if pos('NQ', TradeLogFile[RecordIDX].Ticker) = 1 then
                Shares := round(Shares / 20)
              else if pos('ES', TradeLogFile[RecordIDX].Ticker) = 1 then
                Shares := round(Shares / 50);
          end;
        end;
        if Shares > 0 then
          AveProfPerSh := (Prof / Shares)
        else
          AveProfPerSh := 0;
        if ChartInterval = chrtIntTickCompare then begin
          if ChartType = chrtTypProfit then begin
            if Prof > 0 then
              PeriodicWinners[ThisSeg] := PeriodicWinners[ThisSeg] + Prof
            else
              PeriodicLosers[ThisSeg] := PeriodicLosers[ThisSeg] + Prof
          end;
        end;
      end; // for i:= 0 to LastRecordIndex - 1
      MaxLabelLen := 0;
      MaxAmt := 0;
      SendData := false;
      if Segments > 0 then begin
      // Compute X Scaling and Left Margin
        if ChartInterval = chrtIntTickCompare then begin
          for i := 0 to Segments - 1 do begin
            if cbWin.checked and not(cbLose.checked) then begin
              if PeriodicWinners[i] > 0 then begin
                SendData := true;
                if Length(PeriodLabels[i]) > MaxLabelLen then
                  MaxLabelLen := Length(PeriodLabels[i]);
                if PeriodicWinners[i] > MaxAmt then
                  MaxAmt := PeriodicWinners[i];
              end;
            end
            else if not(cbWin.checked) and cbLose.checked then begin
              if PeriodicLosers[i] < 0 then begin
                SendData := true;
                if Length(PeriodLabels[i]) > MaxLabelLen then
                  MaxLabelLen := Length(PeriodLabels[i]);
                if -PeriodicLosers[i] > MaxAmt then
                  MaxAmt := -PeriodicLosers[i];
              end;
            end
            else begin
              SendData := true;
              if Length(PeriodLabels[i]) > MaxLabelLen then
                MaxLabelLen := Length(PeriodLabels[i]);
              Prof := abs(PeriodicWinners[i] + PeriodicLosers[i]);
              if Prof > MaxAmt then
                MaxAmt := Prof;
            end;
          end;
        end;
        if SendData then begin
          i := 6 + trunc(MaxLabelLen / 1.75);
          if i > 33 then i := 33;
          with TLHorizBarChart1 do begin
            MarginLeft := i;
            BottomAxis.SetMinMax(0, MaxAmt);
            TopAxis.SetMinMax(0, MaxAmt);
          end;
          case ChartInterval of
          chrtIntTickCompare :
            for i := 0 to Segments - 1 do begin
              ChrtYLabel := PeriodLabels[i];
              if cbWin.checked and not(cbLose.checked) then begin
                Prof := PeriodicWinners[i];
                if Prof > 0 then
                  SendHorizData(i);
              end
              else if not(cbWin.checked) and cbLose.checked then begin
                Prof := PeriodicLosers[i];
                if Prof < 0 then
                  SendHorizData(i);
              end
              else begin
                Prof := PeriodicWinners[i] + PeriodicLosers[i];
                SendHorizData(i);
              end;
            end;
          end;
        end;
      end;
      Result := SendData;
      if Result then begin
      //
      end
      else
        sm('No records to show.');
      PeriodLabels.Destroy;
      ProcessedTradeList.Free;
      ShProfitList.Free;
    end;
end;


procedure TfrmTlCharts.SendHorizData(Segment : integer);
begin
  with FrmMain do
    case ChartType of
    chrtTypProfit :
      if Prof < 0 then begin
        HBarLosers.AddXY(-Prof, Segment, ChrtYLabel, clRed);
        HBarWinners.AddXY(0, Segment, ChrtYLabel, clGreen)
      end
      else begin
        HBarLosers.AddXY(0, Segment, ChrtYLabel, clRed);
        HBarWinners.AddXY(Prof, Segment, ChrtYLabel, clGreen);
      end;
    end;
end;


procedure TfrmTlCharts.PrepareVCharts;
var
  i : integer;
  EndWeekEnd, MaxDate : Extended;
  BarChartTitle, LineChartTitle, ReportIntStr, ReportParam : string;
  Year, Month, Day : Word;
begin
//  ClipStr.Clear; // init
//  ClipStr.Add('Date' + TAB + 'Prof'); // init
  with FrmMain do
    with frmTlCharts do begin
      RunningChartRpt := true;
      TLVertBarChart1.Series[1].Color := clGreen;
      ShowLineChart := false;
      SetLength(PeriodicWinners, 0);
      SetLength(PeriodicLosers, 0);
      SetLength(Periods, 0);
      Title := 'Chart';
// if IsInt(GridDisplay) then
// title:= 'Trades - Trade # '+ gridDisplay
// else if GridDisplay = 'Futures' then
// title:= title +' - Futures'
// else if GridDisplay = 'Stocks && Options' then
// title:= title +' - Stocks & Options';
      Title := Title + GetFilterDataFromPanel;
      ChartTitle := Title;
      if rbStandard.checked then begin
        ReportIntStr := cbInterval.items[cbInterval.itemindex];
        if ReportIntStr = 'Daily' then
          ChartInterval := chrtIntDaily
        else if ReportIntStr = 'Weekly' then
          ChartInterval := chrtIntWeekly
        else
          ChartInterval := chrtIntMonthly;
      end
      else if rbWeekDay.checked then
        ChartInterval := chrtIntWeekDay
      else begin
        ChartInterval := chrtIntTimeDay;
        EndTime := Settings.ChartDataList.ActiveChartData.ChartTimes[0];
        StartTime := Settings.ChartDataList.ActiveChartData.ChartTimes[1];
        Segments := 0;
        for i := 2 to 10 do begin
          if Settings.ChartDataList.ActiveChartData.ChartTimes[i] = NoTime then
            break;
          inc(Segments);
        end;
      end;
      Periodic := ChartInterval > chrtIntMonthly;
      ReportParam := cbParameter.items[cbParameter.itemindex];
      RequirePL := ReportParam <> 'Purchases/Sales';
      if ChartInterval = chrtIntMonthly then
        LastDate := UserDateStr('01/01/1955')
      else
        LastDate := DateToStr(StartDate, Settings.UserFmt);
      WeekEnd := trunc(StartDate + 6 - DayofWeek(StartDate));
      EndWeekEnd := trunc(EndDate + 6 - DayofWeek(EndDate));
      VBarLosers.Clear;
      VBarWinners.Clear;
      SeriesLineDefault.Clear;
      SeriesLinePurchases.Clear;
      VBarLosers.ShowInLegend := true;
      VBarWinners.ShowInLegend := true;
      SeriesLinePurchases.ShowInLegend := false;
    // if cbLine.checked then ; //Maybe in future switch to Line Series
      if EndDate <> StartDate then
        BarWidth := round(TLVertBarChart1.width /(1.25 * abs(EndDate - StartDate)))
      else
        BarWidth := round(TLVertBarChart1.width / 1.25);
    // Bar Widths
      if ChartInterval = chrtIntWeekly then
        BarWidth := round(BarWidth * 5)
      else if ChartInterval >= chrtIntMonthly then
        BarWidth := round(BarWidth * 25);
      if BarWidth > 60 then
        BarWidth := 60
      else if BarWidth < 5 then
        BarWidth := 5;
      if ReportParam = 'Purchases/Sales' then
        BarWidth := round(BarWidth / 2);
      VBarWinners.CustomBarWidth := BarWidth;
      VBarLosers.CustomBarWidth := BarWidth;
      TLVertBarChart1.Chart3dPercent := round(0.8 * BarWidth);
      TLLineChart1.Enabled := true;
    // Titles & Legends
      TLLineChart1.Enabled := false;
      if Periodic then begin
        ChartTitle := ReportParam;
        VBarLosers.XValues.DateTime := false;
        VBarWinners.XValues.DateTime := false;
        TLVertBarChart1.BottomAxis.MinorTicks.Visible := false;
        TLVertBarChart1.BottomAxis.LabelsMultiline := false;
        TLVertBarChart1.Foot.Caption := '';
      { if (pos('Profit',ReportParam) >0)
      or (pos('Loss',ReportParam) >0)then begin } // Enable when other choices
        VBarWinners.ShowInLegend := true;
        VBarLosers.ShowInLegend := true;
        VBarWinners.Title := 'Profit';
        VBarLosers.Title := 'Loss';
        TLVertBarChart1.view3d := pos(' AND ', ReportParam) > 0;
        if pos(' OR ', ReportParam) > 0 then begin
          if pos('Ave', ReportParam) = 1 then
            ChartType := chrtTypAvePorL
          else
            ChartType := chrtTypTotPorL;
        end
        else begin
          if pos('Ave', ReportParam) = 1 then
            ChartType := chrtTypAvePandL
          else
            ChartType := chrtTypTotPandL;
          VBarLosers.ShowInLegend := TLVertBarChart1.view3d;
        end;
     // end;
      end
      else begin
        VBarLosers.XValues.DateTime := true;
        VBarWinners.XValues.DateTime := true;
        TLVertBarChart1.BottomAxis.MinorTicks.Visible := true;
        TLVertBarChart1.BottomAxis.LabelsMultiline := true;
        if pos('Ave #', ReportParam)> 0 then begin
          if (TradeLogFile.CurrentBrokerID > 0) and
            (TradeLogFile.CurrentAccount.FileImportFormat = 'Globex') then begin
            ChartTitle := 'Ave # Contracts Per Trade';
            VBarWinners.Title := 'Ave # Contracts';
          end
          else begin
            ChartTitle := 'Ave # Shares Per Trade';
            VBarWinners.Title := 'Ave # Shares';
          end;
          ChartType := chrtTypAveNum;
          TLVertBarChart1.view3d := false;
          VBarWinners.ShowInLegend := true;
          VBarLosers.ShowInLegend := false;
        end
        else if pos('% Total', ReportParam)> 0 then begin
          if (TradeLogFile.CurrentBrokerID > 0) and
            (TradeLogFile.CurrentAccount.FileImportFormat = 'Globex') then begin
            ChartTitle := '% Total Contracts';
            VBarWinners.Title := 'Losers';
            VBarLosers.Title := 'Winners';
          end
          else
            ChartTitle := '% Total Shares';
          ChartType := chrtTypPerCent;
          VBarWinners.Title := 'Winners';
          VBarLosers.Title := 'Losers';
          TLVertBarChart1.view3d := true;
          VBarWinners.ShowInLegend := true;
          VBarLosers.ShowInLegend := true;
        end
        else if ReportParam = 'Profit/Loss' then begin
          ChartTitle := 'Profit / Loss';
          ChartType := chrtTypProfit;
          TLVertBarChart1.view3d := false;
          VBarWinners.ShowInLegend := true;
          VBarWinners.Title := 'Profit';
          VBarLosers.Title := 'Loss';
          TLLineChart1.Enabled := true;
        end
        else if ReportParam = 'Purchases/Sales' then begin
          ChartTitle := 'Purchases / Sales';
          ChartType := chrtTypSales;
          TLVertBarChart1.view3d := true;
          VBarWinners.ShowInLegend := true;
          VBarWinners.Title := 'Sales';
          VBarLosers.Title := 'Purchases';
        end
        else if ReportParam = 'Commission' then begin
          ChartTitle := 'Commission';
          ChartType := chrtTypComm;
          TLVertBarChart1.view3d := false;
          VBarWinners.ShowInLegend := false;
          VBarLosers.ShowInLegend := true;
          VBarLosers.Title := 'Commission';
          TLLineChart1.Enabled := true;
        end
        else if pos('Closed', ReportParam)> 0 then begin
          ChartType := chrtTypShares;
          TLVertBarChart1.view3d := false;
          TLLineChart1.Enabled := true;
          VBarLosers.ShowInLegend := false;
          if (TradeLogFile.CurrentBrokerID > 0) and
            (TradeLogFile.CurrentAccount.FileImportFormat = 'Globex') then begin
            ChartTitle := 'Contracts Closed';
            VBarWinners.Title := 'Contracts Closed';
          end
          else begin
            ChartTitle := 'Shares Closed';
            VBarWinners.Title := 'Shares Closed';
          end;
        end
        else if pos('Per Trade', ReportParam)> 0 then begin
          ChartTitle := 'Ave Prof/Loss Per Trade';
          ChartType := chrtTypAvePlTrades;
          TLVertBarChart1.view3d := false;
          VBarWinners.ShowInLegend := true;
          VBarWinners.Title := 'Ave Profit / Trade';
          VBarLosers.Title := 'Ave Loss / Trade';
        end
        else if pos('Ave Prof/Loss Per', ReportParam)> 0 then begin
          ChartTitle := 'Ave Prof/Loss Per Share';
          ChartType := chrtTypAvePlShares;
          TLVertBarChart1.view3d := false;
          VBarWinners.ShowInLegend := true;
          if (TradeLogFile.CurrentBrokerID > 0) and
            (TradeLogFile.CurrentAccount.FileImportFormat = 'Globex') then begin
            ChartTitle := 'Ave Prof/Loss Per Contract';
            VBarWinners.Title := 'Ave Profit / Contract';
            VBarLosers.Title := 'Ave Loss / Contract';
          end
          else begin
            VBarWinners.Title := 'Ave Profit / Share';
            VBarLosers.Title := 'Ave Loss / Share';
          end;
        end; // If pos...
        if TLLineChart1.Enabled then begin
          LineChartTitle := 'Cumulative ' + ChartTitle;
          TLLineChart1.Title.Text.Clear;
          TLLineChart1.Title.Text.Add(LineChartTitle);
        end;
      end;
      if not cbWin.checked then
        ChartTitle := ChartTitle + ' Losers'
      else if not cbLose.checked then
        ChartTitle := ChartTitle + ' Winners';
      BarChartTitle := ReportIntStr + ' ' + ChartTitle;
      with TLVertBarChart1 do begin
        Title.Text.Clear;
        if (pos(' Per ', BarChartTitle)= 0) or (pos('#', BarChartTitle)> 0)then begin
          Legend.top := 15;
          Title.Text.Add(BarChartTitle)
        end
        else begin
          Legend.top := 25;
          i := pos('/', BarChartTitle);
          if i > 0 then begin
            Title.Text.Add(leftstr(BarChartTitle, i));
            Title.Text.Add(copy(BarChartTitle, i + 1, Length(BarChartTitle)));
          end
          else
            Title.Text.Add(BarChartTitle);
        end;
        if (pos('Winners', Title.Text.Strings[0]) > 0) or (pos('Losers', Title.Text.Strings[0]) > 0)
        then
          VBarWinners.ShowInLegend := false;
        if VBarWinners.ShowInLegend = false then
          VBarLosers.ShowInLegend := false;
        if VBarLosers.ShowInLegend = false then
          VBarWinners.ShowInLegend := false;
      // Bottom Axes
        with BottomAxis do begin
          Automatic := false;
          ExactDateTime := true;
          DateTimeFormat := TLLineChart1.BottomAxis.DateTimeFormat;
          VBarWinners.Marks.Visible := false;
          VBarLosers.Marks.Visible := false;
          if Periodic then
            Title.Caption := '';
          case ChartInterval of
          chrtIntDaily : begin { Todd Flora - Replace custom fields with standard fields
          Old Line: DateTimeFormat := 'mmm' + Settings.UserFmt.DateSep +'dd yy'; }
              DateTimeFormat := 'mmm' + Settings.UserFmt.DateSeparator + 'dd yy';
              TLVertBarChart1.Foot.Caption := 'Day';
              SetMinMax(StartDate - 1, EndDate + 1);
              Increment := DateTimeStep[dtOneDay];
            end;
          chrtIntWeekly : begin { Todd Flora - Replace custom fields with standard fields
            Old Line: DateTimeFormat := 'mmm' + Settings.UserFmt.DateSep +'dd yy'; }
              DateTimeFormat := 'mmm' + Settings.UserFmt.DateSeparator + 'dd yy';
              TLVertBarChart1.Foot.Caption := 'Day';
              SetMinMax(WeekEnd - 7, EndWeekEnd + 7);
              Increment := DateTimeStep[dtOneWeek];
            end;
          chrtIntMonthly : begin { Todd Flora - Replace custom fields with standard fields
            Old Line: DateTimeFormat := 'mmm' + Settings.UserFmt.DateSep + 'yy'; }
              DateTimeFormat := 'mmm' + Settings.UserFmt.DateSeparator + 'yy';
              decodeDate(EndDate, Year, Month, Day);
              MaxDate := EndDate;
              if Month = StrToInt(copy(YYYYMMDD_Ex(DateToStr(EndDate + 1, Settings.UserFmt),
                    Settings.UserFmt), 5, 2)) then begin
                inc(Month);
                if Month = 13 then begin
                  Month := 1;
                  inc(Year);
                end;
                MaxDate := encodeDate(Year, Month, 1);
              end;
              Foot.Caption := 'Month';
              SetMinMax(StartDate - 31, MaxDate);
              Increment := DateTimeStep[dtOneMonth];
            end;
          chrtIntWeekDay : begin
              SetMinMax(0, 8);
              Increment := DateTimeStep[dtOneDay];
              SetLength(PeriodicLosers, 7);
              SetLength(PeriodicWinners, 7);
              SetLength(Periods, 7);
              for i := 0 to 6 do begin
                PeriodicLosers[i] := 0;
                PeriodicWinners[i] := 0;
                Periods[i] := 0;
              end;
            end;
          chrtIntTimeDay : begin
              SetMinMax(0, Segments + 2);
              Increment := 1;
              SetLength(PeriodicWinners, Segments + 1);
              SetLength(PeriodicLosers, Segments + 1);
              SetLength(Periods, Segments + 1);
              for i := 0 to Segments do begin
                PeriodicLosers[i] := 0;
                PeriodicWinners[i] := 0;
                Periods[i] := 0;
              end;
            end;
          end;
        end;
      end;
    // Cumulative Line Chart
      if TLLineChart1.Enabled then
        with TLLineChart1.BottomAxis do begin
          Automatic := false;
          DateTimeFormat := TLVertBarChart1.BottomAxis.DateTimeFormat;
          ExactDateTime := true;
          Increment := TLVertBarChart1.BottomAxis.Increment;
          SeriesLineDefault.XValues.DateTime := true;
          SeriesLineDefault.HorizAxis := aBottomAxis;
          SetMinMax(TLVertBarChart1.BottomAxis.Minimum, TLVertBarChart1.BottomAxis.Maximum);
          TLLineChart1.Foot.Caption := TLVertBarChart1.Foot.Caption;
        end;
    end;
end;


function ComposeVCharts : boolean;
var
  PeriodEnded : boolean;
  i, j, CurrSeg, NextSeg, ThisSeg : integer;
  ThisDatum : Double;
  CurrMonth, CurrYear, NextMonth, NextYear : Word;
  CurrDate, NextDate, ThisDate : Tdate;
  CurrTime, NextTime, thisTime : TTime;
  RecordIDX, RecordIDXJ : integer;
  Year, Month, Day : Word;
begin
  with FrmMain do
    with frmTlCharts do begin
      Result := false;
      cxGrid1TableView1.items[2].SortOrder := soAscending;
      LastRecordIndex := cxGrid1TableView1.DataController.FilteredRecordCount;
      if LastRecordIndex < 1 then begin
        sm('No records to show.');
        exit;
      end;
      PrepareVCharts;
    // Per Bar
      AveProfPerSh := 0;
      AveShPerTr := 0;
      Comm := 0;
      Prof := 0;
      Purch := 0;
      Sales := 0;
      Shares := 0;
      TotLoserSh := 0;
      TotTrades := 0;
      TotWinSh := 0;
    // ----- Line Cumulatives -----
      CommTot := 0;
      ProfTot := 0;
      PurchTot := 0;
      SalesTot := 0;
      SharesTot := 0;
    // -----
      ComTotBegan := false;
      ProfTotBegan := false;
      ProfTotSeen := false;
      PurchTotBegan := false;
      SalesTotBegan := false;
      SharesTotBegan := false;
      SharesTotSeen := false;
    // -----
      CurrDate := xStrToDate('1/1/1900', Settings.InternalFmt);
      CurrMonth := 0;
      CurrSeg := 0;
      CurrTime := NoTime;
      CurrYear := 0;
      NextDate := CurrDate;
      NextSeg := CurrSeg;
      NextTime := CurrTime;
      PeriodEnded := true;
      ThisSeg := 0;
    // ----- Sorts are Base One
      for i := 0 to LastRecordIndex - 1 do begin
        RecordIDX := cxGrid1TableView1.DataController.FilteredRecordIndex[i];
      // Skip this record?
        ThisDate := TradeLogFile[RecordIDX].Date;
        thisTime := xStrToTimeEx(TradeLogFile[RecordIDX].Time, Settings.UserFmt);
        if ThisDate < StartDate then
          continue;
        if ChartInterval = chrtIntTimeDay then begin
          if trim(TradeLogFile[RecordIDX].Time) = '' then
            continue;
          ThisSeg := GetTimeSeg(thisTime);
          if ThisSeg = -1 then
            continue;
        end;
        decodeDate(ThisDate, Year, Month, Day);
        if not(Settings.DispWSdefer) and (TradeLogFile[RecordIDX].OC = 'W') then
          if (Month <> 1) or (Day <> 1) then
            continue;
        ThisDatum := TradeLogFile[RecordIDX].PL;
        if RequirePL then begin
          if ThisDatum = 0 then
            continue;
          if (not cbWin.checked) and (ThisDatum > 0) then
            continue;
          if (not cbLose.checked) and (ThisDatum < 0) then
            continue;
        end;
      // Begin/End useful records
        Result := true;
        if ThisDate > EndDate then begin
          NextDate := ThisDate;
          PeriodEnded := true;
        end
        else begin
          if PeriodEnded then begin
            PeriodEnded := false;
            case ChartInterval of
            chrtIntDaily, chrtIntWeekDay :
              CurrDate := ThisDate;
            chrtIntWeekly :
              WeekEnd := trunc(ThisDate + 6 - DayofWeek(ThisDate));
            chrtIntMonthly : begin
                CurrMonth := Month;
                CurrYear := Year;
              end;
            chrtIntTimeDay :
              CurrSeg := ThisSeg;
            end;
          end;
        // Commissions
          if TradeLogFile[RecordIDX].Commission <> 0 then begin
            Comm := Comm + TradeLogFile[RecordIDX].Commission;
            ComTotBegan := CommTot = 0;
            CommTot := CommTot + TradeLogFile[RecordIDX].Commission;
          end;
        // Sales & Purchases
          if TradeLogFile[RecordIDX].Amount <> 0 then begin
            if TradeLogFile[RecordIDX].Amount > 0 then begin
              SalesTotBegan := SalesTot = 0;
              SalesTot := SalesTot + TradeLogFile[RecordIDX].Amount;
            end
            else begin
              PurchTotBegan := PurchTot = 0;
              PurchTot := PurchTot + TradeLogFile[RecordIDX].Amount;
            end;
            if ((TradeLogFile[RecordIDX].OC = 'O') and (TradeLogFile[RecordIDX].LS = 'L')) or
              ((TradeLogFile[RecordIDX].OC = 'C') and (TradeLogFile[RecordIDX].LS = 'S')) then
              Purch := Purch - TradeLogFile[RecordIDX].Amount
            else if ((TradeLogFile[RecordIDX].OC = 'C') and (TradeLogFile[RecordIDX].LS = 'L')) or
              ((TradeLogFile[RecordIDX].OC = 'O') and (TradeLogFile[RecordIDX].LS = 'S')) then
              Sales := Sales + TradeLogFile[RecordIDX].Amount;
          end;
        // Profit/Loss
          if ThisDatum <> 0 then begin
            Prof := Prof + ThisDatum;
            ProfTotBegan := true;
            ProfTot := ProfTot + ThisDatum;
          end;
        // Closing Shares, Averages, Percentages
          if TradeLogFile[RecordIDX].OC = 'C' then begin
            inc(TotTrades);
            if TradeLogFile[RecordIDX].Shares > 0 then begin
              ThisDatum := TradeLogFile[RecordIDX].Shares;
              if (TradeLogFile.CurrentBrokerID > 0) and
                (TradeLogFile.CurrentAccount.FileImportFormat = 'Globex') then
                if pos('NQ', TradeLogFile[RecordIDX].Ticker) = 1 then
                  ThisDatum := round(TradeLogFile[RecordIDX].Shares / 20)
                else if pos('ES', TradeLogFile[RecordIDX].Ticker) = 1 then
                  ThisDatum := round(TradeLogFile[RecordIDX].Shares / 50);
              Shares := Shares + ThisDatum;
              SharesTotBegan := true;
              SharesTot := SharesTot + ThisDatum;
              if Prof > 0 then
                TotWinSh := TotWinSh + ThisDatum
              else if Prof < 0 then
                TotLoserSh := TotLoserSh + ThisDatum;
            end;
          end;
          if Shares > 0 then begin
            AveProfPerSh := (Prof / Shares);
            PercWinSh := TotWinSh / Shares * 100;
            PercLoserSh := TotLoserSh / Shares * 100;
          end;
          if TotTrades > 0 then begin
            AveProfPerTr := Prof / TotTrades;
            AveShPerTr := round(Shares / TotTrades);
          end;
          CurrDate := ThisDate;
          CurrMonth := Month;
          CurrTime := thisTime;
          CurrYear := Year;
          if i = LastRecordIndex - 1 then
            PeriodEnded := true
          else begin
          // Any more usable records?
            for j := (i + 1) to LastRecordIndex - 1 do begin
              RecordIDXJ := cxGrid1TableView1.DataController.FilteredRecordIndex[j];
              ThisDatum := TradeLogFile[RecordIDXJ].PL;
              if RequirePL then begin
                if ((cbWin.checked) and (ThisDatum > 0) or (cbLose.checked) and (ThisDatum < 0))
                then begin
                  NextDate := TradeLogFile[RecordIDXJ].Date;
                  NextSeg := GetTimeSeg(xStrToTimeEx(TradeLogFile[RecordIDXJ].Time,
                      Settings.UserFmt));
                  break;
                end;
              end
              else begin
                NextDate := TradeLogFile[RecordIDXJ].Date;
                NextSeg := GetTimeSeg(xStrToTimeEx(TradeLogFile[RecordIDXJ].Time,
                    Settings.UserFmt));
                break;
              end;
              if j = LastRecordIndex - 1 then begin
                NextDate := TradeLogFile[RecordIDXJ].Date;
                NextSeg := GetTimeSeg(xStrToTimeEx(TradeLogFile[RecordIDXJ].Time,
                    Settings.UserFmt));
                PeriodEnded := true;
              end;
            end;
            if not(PeriodEnded) then
              case ChartInterval of
              chrtIntDaily, chrtIntWeekDay :
                PeriodEnded := NextDate > CurrDate;
              chrtIntWeekly :
                PeriodEnded := NextDate > WeekEnd;
              chrtIntMonthly : begin
                  decodeDate(NextDate, NextYear, NextMonth, Day);
                  PeriodEnded := (CurrMonth <> NextMonth) or (CurrYear <> NextYear);
                end;
              chrtIntTimeDay :
                PeriodEnded := NextSeg <> ThisSeg;
              end;
          end;
        end;
      // Update Periodic or Write Linear to Charts
        if PeriodEnded then begin
          case ChartInterval of
          // Linear
          chrtIntDaily :
            DateNum := CurrDate;
          chrtIntWeekly :
            DateNum := WeekEnd;
          chrtIntMonthly : begin
              DateNum := xStrToDate(IntToStr(CurrMonth)+ '/01/' + IntToStr(CurrYear),
                Settings.InternalFmt);
            end;
          // Periodic
          chrtIntWeekDay : begin
              DateNum := CurrDate;
              j := DayofWeek(CurrDate) - 1; // DayOfWeek returns 1 -7
              inc(Periods[j]);
              case ChartType of
              chrtTypAvePandL .. chrtTypTotPorL :
                if Prof <> 0 then begin
                // if Prof > 0 then
                  PeriodicWinners[j] := PeriodicWinners[j] + Prof
                // else
                  // PeriodicLosers[j] := PeriodicLosers[j] + Prof
                end;
              end;
            end;
          chrtIntTimeDay : begin
              DateNum := ThisSeg;
              inc(Periods[ThisSeg]);
              case ChartType of
              chrtTypAvePandL .. chrtTypTotPorL :
                if Prof <> 0 then begin
                // if Prof > 0 then
                  PeriodicWinners[ThisSeg] := PeriodicWinners[ThisSeg] + Prof
                // else
                  // PeriodicLosers[ThisSeg] := PeriodicLosers[ThisSeg] + Prof
                end;
              end;
            end;
          end;
          if not(Periodic) then
            SendVertData(ChartTitle, DateNum); // Write Bars
        // Reset Bar Data
          Prof := 0;
          Purch := 0;
          Sales := 0;
          Comm := 0;
          Shares := 0;
          AveProfPerSh := 0;
          TotTrades := 0;
          TotWinSh := 0;
          TotLoserSh := 0;
        // Send Cumulative Data
          if TLLineChart1.Enabled then
            SendVertData(ChartTitle, DateNum, true); // Write Lines
          if NextDate > EndDate then
            break;
        end;
      end; // for i:= 1 to LastRecordIndex
      if Periodic then begin
        case ChartInterval of
        chrtIntWeekDay :
          for j := 0 to 6 do begin
            case j of
            0 :
              ChrtXLabel := 'Sun';
            1 :
              ChrtXLabel := 'Mon';
            2 :
              ChrtXLabel := 'Tue';
            3 :
              ChrtXLabel := 'Wed';
            4 :
              ChrtXLabel := 'Thur';
            5 :
              ChrtXLabel := 'Fri';
            6 :
              ChrtXLabel := 'Sat';
            end;
            SendPeriodicVChart(j);
          end;
        chrtIntTimeDay :
          for j := 0 to Segments do begin
            ChrtXLabel := TimeToStr(Settings.ChartDataList.ActiveChartData.ChartTimes[j + 1],
              Settings.UserFmt);
            SendPeriodicVChart(j);
          end;
        end;
        ChrtXLabel := '';
      end;
      TLVertBarChart1.Repaint;
      TLLineChart1.Repaint;
    end;
end;


procedure TfrmTlCharts.SendPeriodicVChart(j : integer);
begin
  with FrmMain do
    case ChartType of
    chrtTypAvePandL : begin
        if cbWin.checked then begin
          Prof := PeriodicWinners[j];
          if (Periods[j] > 1) and (Prof > 0) then
            Prof := Prof / Periods[j];
        end
        else
          Prof := 0;
        if cbLose.checked then begin
          Loss := -PeriodicLosers[j];
          if (Periods[j] > 1) and (Loss > 0) then
            Loss := Loss / Periods[j];
        end
        else
          Loss := 0;
      end;
    chrtTypTotPandL : begin
        if cbWin.checked then
          Prof := PeriodicWinners[j]
        else
          Prof := 0;
        if cbLose.checked then
          Loss := -PeriodicLosers[j]
        else
          Loss := 0;
      end;
    chrtTypAvePorL : begin
        Prof := PeriodicWinners[j] + PeriodicLosers[j];
        if (Periods[j] > 1) and (Prof <> 0) then
          Prof := Prof / Periods[j];
      end;
    chrtTypTotPorL :
      Prof := PeriodicWinners[j] + PeriodicLosers[j];
    end;
  SendVertData(ChartTitle, j + 1); // Write Bars
end;


procedure TfrmTlCharts.tmrFS_DlgTimer(Sender : TObject);
var
  dlgWnd : HWnd;
  newleft, newTop, Wdth : integer;
  dlgRect : TRect;
begin
  dlgWnd := FindWindow('#32770', dlgFS_Title);
  if dlgWnd <> 0 then begin
    tmrFS_Dlg.Enabled := false;
    GetWindowRect(dlgWnd, dlgRect);
    Wdth := dlgRect.Right - dlgRect.left;
    newleft := MainLeft + trunc((MainWidth - Wdth)/ 2);
    newTop := MainTop + trunc((MainHeight - dlgRect.Bottom + dlgRect.top)/ 2);
    SetWindowPos(dlgWnd, 0, newleft, newTop, 0, 0, SWP_NOACTIVATE + SWP_NOSIZE + SWP_NOZORDER);
    dlgFS_Title := nil;
  end;
end;


function GetStrategyProfit(index : integer): Double;
var
  i, j : integer;
  lastShareCount, noOfShares, prevNoOfShares, prevTotalProfit, currNoOfShares,
    currTotalProfit : Double;
  isUsed : boolean;
  RecordIDX : integer;
begin
  Result := 0;
  lastShareCount := 0;
  prevNoOfShares := 0;
  prevTotalProfit := 0;
  currNoOfShares := 0;
  currTotalProfit := 0;
  noOfShares := 0;
  if TradeLogFile[index].OC = 'C' then begin
    isUsed := false;
    for j := 0 to LastRecordIndex - 1 do begin
      RecordIDX := FrmMain.cxGrid1TableView1.DataController.FilteredRecordIndex[j];
      if (TradeLogFile[RecordIDX].OC = 'O') and
        (TradeLogFile[RecordIDX].strategy = TradeLogFile[index].strategy) then begin
        isUsed := true;
        break;
      end;
    end;
    if not isUsed then begin
      Result := TradeLogFile[index].PL;
      exit;
    end;
  end;
  if TradeLogFile[index].OC = 'O' then begin
    for i := 0 to LastRecordIndex - 1 do begin
      RecordIDX := FrmMain.cxGrid1TableView1.DataController.FilteredRecordIndex[i];
      if (TradeLogFile[RecordIDX].Ticker = TradeLogFile[index].Ticker) and
        (TradeLogFile[RecordIDX].OC = 'C') then begin
        isUsed := false;
        for j := 0 to ProcessedTradeList.Count - 1 do begin
          if(StrToInt(trim(ProcessedTradeList.Names[j])) = TradeLogFile[RecordIDX].ID) then
            isUsed := true;
        end;
        if isUsed then
          continue
        else begin
          ProcessedTradeList.Add(IntToStr(TradeLogFile[RecordIDX].ID) + '=' + TradeLogFile
              [RecordIDX].strategy);
          currNoOfShares := StrToFloat(ShProfitList.Names[i], Settings.InternalFmt);
          currTotalProfit := StrToFloat(ShProfitList.ValueFromIndex[i], Settings.InternalFmt);
          noOfShares := currNoOfShares + prevNoOfShares;
          if noOfShares >= TradeLogFile[index].Shares then begin
            if noOfShares = TradeLogFile[index].Shares then begin
              Result := currTotalProfit + prevTotalProfit;
              prevTotalProfit := 0;
              prevNoOfShares := 0;
            end
            else begin
              lastShareCount := TradeLogFile[index].Shares - prevNoOfShares;
              Result := ((lastShareCount * currTotalProfit)/ TradeLogFile[RecordIDX].Shares);
              ShProfitList.Delete(i);
              ShProfitList.Insert(i, FloatToStr(TradeLogFile[RecordIDX].Shares - lastShareCount,
                  Settings.InternalFmt) + '=' + FloatToStr(currTotalProfit - Result,
                  Settings.InternalFmt));
              Result := Result + prevTotalProfit;
              ProcessedTradeList.Delete(ProcessedTradeList.Count - 1);
            end;
            exit;
          end
          else begin
            prevTotalProfit := currTotalProfit + prevTotalProfit;
            prevNoOfShares := noOfShares;
          end;
        end;
      end;
    end;
  end;
end;

end.
