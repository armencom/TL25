unit FastReportsData;

interface

uses
  SysUtils, Classes, frxClass, Variants, FuncProc, Graphics, TLGainsReport,
  frxRich, frxDesgn, frxChBox;

type
  EReportException = class(Exception);

  TdataFastReports = class(TDataModule)
    rptPerformance: TfrxReport;
    rptCharts: TfrxReport;
    rpt8949_2011: TfrxReport;
    rptReconcile: TfrxReport;
    dsForm8949P1: TfrxUserDataSet;
    dsForm8949P2: TfrxUserDataSet;
    dsPerformance: TfrxUserDataSet;
    dsFutures: TfrxUserDataSet;
    rptFutures: TfrxReport;
    rptGAndL: TfrxReport;
    dsGAndL: TfrxUserDataSet;
    rptWSDetails: TfrxReport;
    rpt8949_2012: TfrxReport;
    rptGAndL_03: TfrxReport;
    rptWSDetails_03: TfrxReport;
    rptSecuritiesMTM: TfrxReport;
    dsSecuritiesMTM: TfrxUserDataSet;
    rptIRS_D1: TfrxReport;
    dsIRSD1P1: TfrxUserDataSet;
    dsIRSD1P2: TfrxUserDataSet;
    rptIRS_D1_2003: TfrxReport;
    rptDetail: TfrxReport;
    rptHorizCharts: TfrxReport;
    rptPotentialWS: TfrxReport;
    dsWSSummary: TfrxUserDataSet;
    dsPotentialWSDetails: TfrxUserDataSet;
    dsPotentialWSNewTrades: TfrxUserDataSet;
    dsPotentialWSIRA: TfrxUserDataSet;
    frxRichObject1: TfrxRichObject;
    frxCheckBoxObject1: TfrxCheckBoxObject;
    rptHeader: TfrxReport;
    rpt8949_2014: TfrxReport;
    dsDetails: TfrxUserDataSet;
    rpt8949_2015: TfrxReport;
    rpt8949_2018: TfrxReport;
    rptMTM4797: TfrxReport;
    rpt8949_2024: TfrxReport;
    rpt8949_2025: TfrxReport;
    // ----------------------
    procedure dsPerformanceGetValue(const VarName: string; var Value: Variant);
    procedure rptPerformanceBeforePrint(Sender: TfrxReportComponent);
    procedure rptChartsBeforePrint(Sender: TfrxReportComponent);

    procedure dsForm8949P1GetValue(const VarName: string; var Value: Variant);
    procedure dsForm8949P2GetValue(const VarName: string; var Value: Variant);
    procedure rpt8949_2011ManualBuild(Page: TfrxPage);
    procedure rpt8949_2011EndDoc(Sender: TObject);
    procedure rpt8949_2012EndDoc(Sender: TObject);

    procedure dsFuturesGetValue(const VarName: string; var Value: Variant);
    procedure dsGAndLGetValue(const VarName: string; var Value: Variant);
    procedure rptGAndLManualBuild(Page: TfrxPage);
    procedure rptGAndLBeginDoc(Sender: TObject);
    procedure dsWSSummaryGetValue(const VarName: string; var Value: Variant);
    procedure rptWSDetailsManualBuild(Page: TfrxPage);
    procedure dsSecuritiesMTMGetValue(const VarName: string;
      var Value: Variant);
    procedure rptSecuritiesMTMManualBuild(Page: TfrxPage);
    procedure dsIRSD1P1GetValue(const VarName: string; var Value: Variant);
    procedure dsIRSD1P2GetValue(const VarName: string; var Value: Variant);
    procedure rptIRS_D1ManualBuild(Page: TfrxPage);
    procedure dsDetailsGetValue(const VarName: string; var Value: Variant);
    procedure rptDetailManualBuild(Page: TfrxPage);
    procedure rptDetailBeginDoc(Sender: TObject);
    procedure rptHorizChartsManualBuild(Page: TfrxPage);
    procedure dsSecuritiesMTMNext(Sender: TObject);

    procedure rptGAndLEndDoc(Sender: TObject);
    procedure rptGAndL_03EndDoc(Sender: TObject);

    procedure rptWSDetails_03EndDoc(Sender: TObject);
    procedure rptWSDetailsEndDoc(Sender: TObject);
    procedure rptFuturesEndDoc(Sender: TObject);
    procedure rptPerformanceEndDoc(Sender: TObject);
    procedure rptChartsEndDoc(Sender: TObject);
    procedure rptReconcileEndDoc(Sender: TObject);
    procedure rptIRS_D1EndDoc(Sender: TObject);
    procedure rptIRS_D1_2003EndDoc(Sender: TObject);
    procedure rptSecuritiesMTMEndDoc(Sender: TObject);
    procedure rptHorizChartsEndDoc(Sender: TObject);
    procedure rptDetailEndDoc(Sender: TObject);

    procedure dsPotentialWSDetailsGetValue(const VarName: string; var Value: Variant);
    procedure rptPotentialWSEndDoc(Sender: TObject);
    procedure dsPotentialWSNewTradesGetValue(const VarName: string; var Value: Variant);
    procedure dsPotentialWSIRAGetValue(const VarName: string; var Value: Variant);

  private
    { Private declarations }
    function ProcessDetailBand(Section: Char; Data: TfrxUserDataSet;
      ArrayData: TTglReportArray; var RecCount: Integer; Rows: Integer;
      Band: TFrxMasterData; HeaderBand: TfrxHeader): extended;
    procedure SetupGainsReportData(ShortTerm: Boolean; LongTerm,
      IncludeCostAdjustment: Boolean; MTM: Boolean = false);
    procedure SetupBackPicture(DataPage : TfrxReportPage; DraftForTaxYear : Boolean = false);
  public
    { Public declarations }
    procedure RunPerformanceReport;
    procedure RunChartsReport;
    procedure Run8949Report(IncSummary, IncForm8949, IncAdjustment: Boolean);
//procedure Run8949Summary;
    procedure RunIRSD1Report;
    procedure RunReconcileReport;
    procedure RunFuturesReport;
    procedure RunGAndLReport(MTM: Boolean = false);
    procedure RunWSDetailReport;
    procedure RunWSPotentialReport;
    procedure RunReportSummary;
    procedure RunSecuritiesMTM;
    procedure RunDetailReport(WithSubTotals : Boolean);
  end;

const
  MAX_TAX_YEAR : integer = 2024; // use for ETY / Tax Year checks

var
  dataFastReports: TdataFastReports;
  GainsReportData: TGainsReportData;
  // For some reason the ManualBuld methods run twice and the first time the code should not run.
  // Therefore we will use these booleans to know when the method has run and short circuit it
  // the first time.
  ManualBuildPage1: Boolean;
  ManualBuildPage2: Boolean;
  ShortLongToggle: Boolean; // When it is false we are doing Short Term, when True doing Long Term
  LastRecNo, PassNum : integer; // used to detect multiple passes through data

implementation

{$R *.dfm}

uses TLSettings, StrUtils, Reports, TLFile, TLCommonLib, tlCharts,
  FastReportsPreview, TeEngine, TeeProcs, DbChart, TeeFunci, TeeStore, Main, cxGridTableView;

//{ Extract whole part and decimal part and return for a string value that is expected to be numeric. }
//procedure ExtractNumberParts(Value: String; var wholePart, decimalPart: String;
//  decimalSeperator: Char);
//var
//  x: Integer;
//begin
//  if Length(Value) = 0 then begin
//    wholePart := '';
//    decimalPart := '';
//    exit;
//  end;
//  x := pos(decimalSeperator, Value);
//  if x > 0 then begin
//    decimalPart := RightStr(Value, Length(Value) - x);
//    wholePart := LeftStr(Value, x - 1);
//  end
//  else begin
//    decimalPart := '00';
//    wholePart := Value;
//  end;
//end;

// Todd Flora - Method added to do what the old Rave Report was doing in it's script for many
// fields. This may be unnecessary but we will do it anyway for now until we can
// determine it's necessity or lack thereof
function remove3Spaces(Value: String): String;
begin
  while pos('  ', Value) > 0 do
    Delete(Value, pos('  ', Value), 1);
  result := Value;
end;

//// Fast Reports uses a variant type when writing data to the User Connection Object, so if
//// we want images from TeeChart as variants we need to use this method to convert them.
//function getChartVariant(Chart: TDBChart): OleVariant;
//var
//  MetaFile: TMetaFile;
//  Stream: TMemoryStream;
//  p: pointer;
//begin
//  MetaFile := Chart.TeeCreateMetafile(false, Chart.GetRectangle);
//  try
//    MetaFile.SaveToStream(Stream);
//    result := VarArrayCreate([0, Stream.Size - 1], varByte);
//    p := VarArrayLock(result);
//    Stream.Position := 0;
//    Stream.Read(p^, Stream.Size);
//    VarArrayUnlock(result);
//  finally
//    Stream.Free;
//    MetaFile.Free;
//  end;
//end;


procedure TdataFastReports.dsDetailsGetValue(const VarName: string; var Value: Variant);
var
  recNo: Integer;
  Data: TcxGridViewData;
begin
  recNo := dsDetails.recNo;
  Data := frmMain.cxGrid1TableView1.ViewData;
  if (VarName = 'tr') then
    Value := IntToStr(Data.Rows[recNo].Values[1])
  else if (VarName = 'dt') then
    Value := DateToStr(Data.Rows[recNo].Values[2], Settings.UserFmt)
  else if (VarName = 'oc') then
    Value := Data.Rows[recNo].Values[4]
  else if (VarName = 'ls') then
    Value := Data.Rows[recNo].Values[5]
  else if (VarName = 'tk') then
    Value := Data.Rows[recNo].Values[6]
  else if (VarName = 'sh') then
    Value := FloatToStr(Data.Rows[recNo].Values[7], Settings.UserFmt)
  else if (varName = 'pr')  then
    Value := CurrStrEx(Data.Rows[recNo].Values[8], Settings.UserFmt, False, True, 5)
  else if (VarName = 'cm') then
    Value := CurrStrEx(Data.Rows[recNo].Values[10], Settings.UserFmt)
  else if (VarName = 'am') then
    Value := CurrStrEx(Data.Rows[recNo].Values[11], Settings.UserFmt)
  else if (VarName = 'pl') then
    Value := CurrStrEx(Data.Rows[recNo].Values[12], Settings.UserFmt);
end;


// ----------------
// Form 8949 Data P1
// ----------------
procedure TdataFastReports.dsForm8949P1GetValue(const VarName: string;
  var Value: Variant);
var
  recNo: Integer;
begin
  if GainsReportData.BlankRows then begin
    Value := '';
    exit;
  end;
  recNo := dsForm8949P1.recNo;
  if (VarName = 'ds') then
    Value := GainsReportData.STData[recNo].desc
  else if (VarName = 'code') then
    Value := GainsReportData.STData[recNo].code
  else if (VarName = 'dta') then
    Value := US_DateStr(GainsReportData.STData[recNo].dtAcq, Settings.UserFmt)
  else if (VarName = 'dts') then
    Value := US_DateStr(GainsReportData.STData[recNo].dtSld, Settings.UserFmt)
  else if (VarName = 'sp') then
    Value := CurrStrEx(GainsReportData.STData[RecNo].sales, Settings.UserFmt)
  else if (VarName = 'bas') then
    Value := CurrStrEx(GainsReportData.STData[RecNo].cs, Settings.UserFmt)
  else if (VarName = 'pl') then
    Value := CurrStrEx(RndTo5(GainsReportData.STData[RecNo].sales
      - GainsReportData.STData[RecNo].cs
      + GainsReportData.STData[RecNo].adjG),
    Settings.UserFmt)
  else if (VarName = 'adj') then begin
    if (GainsReportData.STData[recNo].adjG > -0.01)
    and (GainsReportData.STData[recNo].adjG < 0.01)
    and (GainsReportData.STData[recNo].code <> 'B') then
      Value := ''
    else
      Value := CurrStrEx(GainsReportData.STData[RecNo].adjG, Settings.UserFmt)
  end
  else if (VarName = 'abc') then
    Value := GainsReportData.STData[recNo].abc;
end;

// ----------------
// Form 8949 data P2
// ----------------
procedure TdataFastReports.dsForm8949P2GetValue(const VarName: string;
  var Value: Variant);
var
  recNo: Integer;
begin
  if GainsReportData.BlankRows then begin
    Value := '';
    exit;
  end;
  recNo := dsForm8949P2.recNo;
  if (VarName = 'ds') then
    Value := GainsReportData.LTData[recNo].desc
  else if (VarName = 'code') then
    Value := GainsReportData.LTData[recNo].code
  else if (VarName = 'dta') then
    Value := US_DateStr(GainsReportData.LTData[recNo].dtAcq, Settings.UserFmt)
  else if (VarName = 'dts') then
    Value := US_DateStr(GainsReportData.LTData[recNo].dtSld, Settings.UserFmt)
  else if (VarName = 'sp') then
    Value := CurrStrEx(GainsReportData.LTData[RecNo].sales, Settings.UserFmt)
  else if (VarName = 'bas') then
    Value := CurrStrEx(GainsReportData.LTData[RecNo].cs, Settings.UserFmt)
 else if (VarName = 'pl') then
    Value := CurrStrEx(RndTo5(GainsReportData.LTData[RecNo].sales
      - GainsReportData.LTData[RecNo].cs
      + GainsReportData.LTData[RecNo].adjG),
    Settings.UserFmt)
  else if (VarName = 'adj') then begin
    if (GainsReportData.LTData[recNo].adjG > -0.01)
    and (GainsReportData.LTData[recNo].adjG < 0.01)
    and (GainsReportData.LTData[recNo].code <> 'B') then
      Value := ''
    else
      Value := CurrStrEx(GainsReportData.LTData[RecNo].adjG, Settings.UserFmt)
  end
  else if (VarName = 'abc') then
    Value := GainsReportData.LTData[recNo].abc;
end;


// ----------------
// Futures Report data
// ----------------
procedure TdataFastReports.dsFuturesGetValue(const VarName: string;
  var Value: Variant);
var
  recNo: Integer;
begin
  recNo := dsFutures.recNo;
  Value := '';
  if (VarName = 'Description') then
    Value := GainsReportData.STData[recNo].desc
  else if (VarName = 'DateAcquired') and
    (Length(GainsReportData.STData[recNo].dtAcq) > 0) then
    Value := xStrToDate(GainsReportData.STData[recNo].dtAcq, Settings.UserFmt)
  else if (VarName = 'DateSold') and
    (Length(GainsReportData.STData[recNo].dtSld) > 0) then
    Value := xStrToDate(GainsReportData.STData[recNo].dtSld, Settings.UserFmt)
  else if (VarName = 'Sales') then
    Value := CurrStrEx(GainsReportData.STData[recNo].sales, Settings.UserFmt)
  else if (VarName = 'CostBasis') then
    Value := CurrStrEx(GainsReportData.STData[recNo].cs, Settings.UserFmt)
  else if (VarName = 'Loss') then begin
    if (GainsReportData.STData[recNo].pl < 0) then
      Value := CurrStrEx(GainsReportData.STData[recNo].pl, Settings.UserFmt)
  end
  else if (VarName = 'Gain') then begin
    if (GainsReportData.STData[recNo].pl > 0) then
      Value := CurrStrEx(GainsReportData.STData[recNo].pl, Settings.UserFmt);
  end;
  if (recNo = dsFutures.RecordCount - 1) then begin
    rptFutures.Variables.Variables['TotalSales'] := QuotedStr
      (CurrStrEx(GainsReportData.STSales, Settings.UserFmt));
    rptFutures.Variables.Variables['TotalCost'] := QuotedStr
      (CurrStrEx(GainsReportData.STCostBasis, Settings.UserFmt));
    rptFutures.Variables.Variables['TotalLoss'] := QuotedStr
      (CurrStrEx(GainsReportData.STLoss, Settings.UserFmt));
    rptFutures.Variables.Variables['TotalGain'] := QuotedStr
      (CurrStrEx(GainsReportData.STGain, Settings.UserFmt));
    rptFutures.Variables.Variables['TotalPL'] := QuotedStr
      (CurrStrEx(GainsReportData.STPAndL, Settings.UserFmt));
  end;
end;


procedure TdataFastReports.dsGAndLGetValue(const VarName: string;
  var Value: Variant);
var
  recNo: Integer;
  Summary: Boolean;
begin
  if stopREport then exit;
  recNo := dsGAndL.recNo;
  Value := '';
  Summary := (ReportStyle in [rptTickerSummary, rptTradeSummary, rpt481Adjust]);
  if (VarName = 'Description') then begin
    if Summary then
      Value := datSummary[recNo].desc
    else
      Value := GainsReportData.ActiveData[recNo].desc;
  end
  else if (VarName = 'DateAcquired') then begin
    if Summary then begin
      if (datSummary[recNo].dtAcq > 0) then
        Value := DateTimeToStr(datSummary[recNo].dtAcq, Settings.UserFmt)
    end
    else if (Length(GainsReportData.ActiveData[recNo].dtAcq) > 0) then
      Value := xStrToDate(GainsReportData.ActiveData[recNo].dtAcq,
        Settings.UserFmt);
  end
  else if (VarName = 'DateSold') then begin
    if Summary then begin
      if (datSummary[recNo].dtSld > 0) then
        Value := DateTimeToStr(datSummary[recNo].dtSld, Settings.UserFmt);
    end
    else if (Length(GainsReportData.ActiveData[recNo].dtSld) > 0) then
      Value := xStrToDate(GainsReportData.ActiveData[recNo].dtSld, Settings.UserFmt);
  end
  else if (VarName = 'Sales') then begin
    if Summary then
      Value := CurrStrEx(datSummary[recNo].TrSales, Settings.UserFmt)
    else
      Value := CurrStrEx(GainsReportData.ActiveData[recNo].sales, Settings.UserFmt);
  end
  else if (VarName = 'CostBasis') then begin
    if Summary then
      Value := CurrStrEx(datSummary[recNo].TrCost, Settings.UserFmt)
    else
      Value := CurrStrEx(GainsReportData.ActiveData[recNo].cs, Settings.UserFmt);
  end
  else if (VarName = 'PAndL') then begin
    if Summary then
      Value := CurrStrEx(datSummary[recNo].TrPl, Settings.UserFmt)
    else
      Value := CurrStrEx(GainsReportData.ActiveData[recNo].pl, Settings.UserFmt);
  end
  else if (TaxYear = '2003') and (VarName = 'GM03') then
    Value := CurrStrEx(GainsReportData.ActiveData[recNo].gm03, Settings.UserFmt);

  if (recNo = dsGAndL.RecordCount - 1) then begin
    if Summary then
      frmFastReports.Preview.Report.Variables.Variables['TotalSales'] :=
        QuotedStr(CurrStrEx(SlsprTot, Settings.UserFmt))
    else
      frmFastReports.Preview.Report.Variables.Variables['TotalSales'] :=
        QuotedStr(CurrStrEx(GainsReportData.TotalSales, Settings.UserFmt));

    if Summary then
      frmFastReports.Preview.Report.Variables.Variables['TotalCost'] :=
        QuotedStr(CurrStrEx(CostTot, Settings.UserFmt))
    else
      frmFastReports.Preview.Report.Variables.Variables['TotalCost'] :=
        QuotedStr(CurrStrEx(GainsReportData.TotalCostBasis, Settings.UserFmt));

    if Summary then
      frmFastReports.Preview.Report.Variables.Variables['TotalPL'] := QuotedStr
        (CurrStrEx(ProfTot, Settings.UserFmt))
    else
      frmFastReports.Preview.Report.Variables.Variables['TotalPL'] := QuotedStr
        (CurrStrEx(GainsReportData.TotalPAndL, Settings.UserFmt));

    if Summary then
      frmFastReports.Preview.Report.Variables.Variables['TotalGM03'] :=
        QuotedStr(CurrStrEx(GainMay5Tot, Settings.UserFmt))
    else
      frmFastReports.Preview.Report.Variables.Variables['TotalGM03'] :=
        QuotedStr(CurrStrEx(GainsReportData.GainMay5Total, Settings.UserFmt));

    if not Summary then begin
      if GainsReportData.TotalDeferrals <> 0 then
        frmFastReports.Preview.Report.Variables.Variables['DeferredWS'] :=
          QuotedStr(CurrStrEx(GainsReportData.TotalDeferrals, Settings.UserFmt))
      else
        frmFastReports.Preview.Report.Variables.Variables['DeferredWS'] :=
          QuotedStr('None');
      if GainsReportData.TotalWSLostToIra <> 0 then
        frmFastReports.Preview.Report.Variables.Variables['WSLostToIra'] :=
          QuotedStr(CurrStrEx(GainsReportData.TotalWSLostToIra, Settings.UserFmt))
      else
        frmFastReports.Preview.Report.Variables.Variables['WSLostToIra'] := QuotedStr('None');
    end;
  end;
end;


procedure TdataFastReports.dsIRSD1P1GetValue(const VarName: string; var Value: Variant);
var
  recNo: Integer;
  pl : Double;
begin
  if GainsReportData.BlankRows then begin
    Value := '';
    exit;
  end;
  recNo := dsIrsD1P1.RecNo;
  {Replace period with spaces in numbers because this form has a line
    seperating decimals from whole number, Also Negative numbers will have
    a closing Paren, so add a space to the end of positive numbers so that they line up better.}
  if (VarName = 'ds') then
    Value := GainsReportData.STData[recNo].desc
  else if (VarName = 'dta') then
    Value := US_DateStr(GainsReportData.STData[recNo].dtAcq, Settings.UserFmt)
  else if (VarName = 'dts') then
    Value := US_DateStr(GainsReportData.STData[recNo].dtSld, Settings.UserFmt)
  else if (VarName = 'sp') then begin
    Value := ReplaceStr(CurrStrEx(GainsReportData.STData[RecNo].sales, Settings.UserFmt), '.', '  ');
    if GainsReportData.STData[RecNo].sales >= 0 then
      Value := Value + ' ';
  end
  else if (VarName = 'bas') then begin
    Value := ReplaceStr(CurrStrEx(GainsReportData.STData[RecNo].cs, Settings.UserFmt), '.', '  ');
    if GainsReportData.STData[RecNo].cs >=0 then
      Value := Value + ' ';
  end
 else if (VarName = 'pl') then begin
    pl := RndTo5(GainsReportData.STData[RecNo].sales - GainsReportData.STData[RecNo].cs);
    Value := ReplaceStr(CurrStrEx(pl,
    Settings.UserFmt), '.', '  ');
    if pl >=0 then Value := Value + ' '
 end
 else if (VarName = 'gm03') then begin
   Value := ReplaceStr(CurrStrEx(GainsReportData.STData[RecNo].gM03, Settings.UserFmt), '.', '  ');
    if GainsReportData.STData[RecNo].gM03 >=0 then Value := Value + ' ';
 end;
end;


procedure TdataFastReports.dsPerformanceGetValue(const VarName: string;
  var Value: Variant);
begin
  With datPerf do begin
    if VarName = 'avgPLsh' then
      Value := remove3Spaces(CurrStrEx(avgPLsh, Settings.UserFmt))
    else if VarName = 'avgPLtr' then
      Value := remove3Spaces(CurrStrEx(avgPLtr, Settings.UserFmt))
    else if VarName = 'avgSHtr' then
      Value := IntToStr(avgSHtr)
    else if VarName = 'diff' then
      Value := remove3Spaces(CurrStrEx(diff, Settings.UserFmt))
    else if VarName = 'fltAvgSHtr' then
      Value := IntToStr(fltAvgSHtr)
    else if VarName = 'fltPercent' then
      Value := IntToStr(fltPercent) + '%'
    else if VarName = 'fltShares' then
      Value := format('%9.0n', [fltShares], Settings.UserFmt)
    else if VarName = 'lsrAvgLsh' then
      Value := remove3Spaces(CurrStrEx(lsrAvgLsh, Settings.UserFmt))
    else if VarName = 'lsrAvgLtr' then
      Value := remove3Spaces(CurrStrEx(lsrAvgLtr, Settings.UserFmt))
    else if VarName = 'lsrAvgSHtr' then
      Value := IntToStr(lsrAvgSHtr)
    else if VarName = 'lsrLargest' then
      Value := remove3Spaces(CurrStrEx(lsrLargest, Settings.UserFmt))
    else if VarName = 'lsrL' then
      Value := remove3Spaces(CurrStrEx(lsrL, Settings.UserFmt))
    else if VarName = 'lsrPercent' then
      Value := IntToStr(lsrPercent) + '%'
    else if VarName = 'lsrShares' then
      Value := format('%9.0n', [lsrShares], Settings.UserFmt)
    else if VarName = 'ShareOrContract' then
      if contracts = true then
        Value := 'Contract'
      else
        Value := 'Share'
      else if VarName = 'lsrShares' then
        Value := format('%9.0n', [totalShares], Settings.UserFmt)
      else if VarName = 'totalComm' then
        Value := remove3Spaces(CurrStrEx(totalComm, Settings.UserFmt))
      else if VarName = 'totalCost' then
        Value := remove3Spaces(CurrStrEx(totalCost, Settings.UserFmt))
      else if VarName = 'totalPl' then
        Value := remove3Spaces(CurrStrEx(totalPL, Settings.UserFmt))
      else if VarName = 'totalSales' then
        Value := remove3Spaces(CurrStrEx(TotalSales, Settings.UserFmt))
      else if VarName = 'totalShares' then
        Value := format('%9.0n', [totalShares], Settings.UserFmt)
      else if VarName = 'winAvgPsh' then
        Value := remove3Spaces(CurrStrEx(winAvgPsh, Settings.UserFmt))
      else if VarName = 'winAvgPtr' then
        Value := remove3Spaces(CurrStrEx(winAvgPtr, Settings.UserFmt))
      else if VarName = 'winAvgSHtr' then
        Value := IntToStr(winAvgSHtr)
      else if VarName = 'winLargest' then
        Value := remove3Spaces(CurrStrEx(winLargest, Settings.UserFmt))
      else if VarName = 'winPercent' then
        Value := IntToStr(winPercent) + '%'
      else if VarName = 'winP' then
        Value := remove3Spaces(CurrStrEx(winP, Settings.UserFmt))
      else if VarName = 'winShares' then
        Value := format('%9.0n', [winShares], Settings.UserFmt);
  end;
end;


procedure TdataFastReports.dsPotentialWSDetailsGetValue(const VarName: string;
  var Value: Variant);
var
  RecNo : Integer;
  OpenDeferral : TSTOpenDeferral;
begin
  if (STDeferralDetails.Count = 0)
//  or (date > strToDate('12/31/'+taxYear,Settings.UserFmt))    // 2015-01-13
  then begin
    if (VarName = 'DateOpen') then
      Value := ''
    else if (VarName = 'Ticker') then
      Value := 'NONE!'
    else if (VarName = 'Shares') then
      Value := ''
    else if (VarName = 'LS') then
      Value := ''
    else if (VarName = 'Amount') then
      Value := ''
    else if (Varname = 'Account') then
      Value := ''
  end
  else begin
    recNo  := dsPotentialWSDetails.RecNo;
    OpenDeferral := STDeferralDetails[RecNo];
    if (VarName = 'DateOpen') then
      Value := DateToStr(OpenDeferral.DateOpen,settings.UserFmt)
    else if (VarName = 'Ticker') then
      Value := OpenDeferral.Ticker
    else if (VarName = 'Shares') then
      Value := FloatToStr(OpenDeferral.Shares, Settings.UserFmt)
    else if (VarName = 'LS') then
      Value := OpenDeferral.ls
    else if (VarName = 'Amount') then
      Value := CurrStrEx(OpenDeferral.Amount, Settings.UserFmt)
    else if (Varname = 'Account') then
      Value := OpenDeferral.Account;
  end;
end;


procedure TdataFastReports.dsPotentialWSIRAGetValue(const VarName: string;
  var Value: Variant);
var
  RecNo : Integer;
  OpenDeferral : TSTOpenDeferral;
begin
  {We always want this section to show so even if there are
    no Ira Deferrals just spit out one record with None}
  if IraDeferralDetails.Count = 0 then
  begin
    if (VarName = 'DateOpen') then
      Value := ''
    else if (VarName = 'Ticker') then
      Value := 'NONE!'
    else if (VarName = 'Shares') then
      Value := ''
    else if (VarName = 'LS') then
      Value := ''
    else if (VarName = 'LossAmount') then
      Value := ''
    else if (VarName = 'DateOfLoss') then
      Value := ''
    else if (VarName = 'ThirtyDaysEnds') then
      Value := ''
    else if (Varname = 'Account') then
      Value := '';
  end
  else begin
    recNo  := dsPotentialWSIRA.RecNo;
    OpenDeferral := IRADeferralDetails[RecNo];
    if (VarName = 'DateOpen') then
      Value := DateToStr(OpenDeferral.DateOpen,settings.UserFmt)
    else if (VarName = 'Ticker') then
      Value := OpenDeferral.Ticker
    else if (VarName = 'Shares') then
      Value := FloatToStr(OpenDeferral.Shares, Settings.UserFmt)
    else if (VarName = 'LS') then
      Value := OpenDeferral.ls
    else if (VarName = 'LossAmount') then
      Value := CurrStrEx(OpenDeferral.Amount, Settings.UserFmt)
    else if (VarName = 'DateOfLoss') then
      Value := DateToStr(OpenDeferral.DateOfLoss, Settings.UserFmt)
    else if (VarName = 'ThirtyDaysEnds') then
      Value := DateToStr(OpenDeferral.DateOfLoss + 30, Settings.UserFmt)
    else if (Varname = 'Account') then
      Value := OpenDeferral.Account;
  end;
end;


procedure TdataFastReports.dsPotentialWSNewTradesGetValue(const VarName: string;
  var Value: Variant);
var
  RecNo : Integer;
  OpenDeferral : TSTOpenDeferral;
begin
  {We always want this section to show so even if there are
    no New Trades Deferrals just spit out one record with None}
  if NewTradesDeferralDetails.Count = 0 then
  begin
    if (VarName = 'DateOpen') then
      Value := ''
    else if (VarName = 'Ticker') then
      Value := 'NONE!'
    else if (VarName = 'Shares') then
      Value := ''
    else if (VarName = 'LS') then
      Value := ''
    else if (VarName = 'LossAmount') then
      Value := ''
    else if (VarName = 'DateOfLoss') then
      Value := ''
    else if (VarName = 'ThirtyDaysEnds') then
      Value := ''
    else if (Varname = 'Account') then
      Value := '';
  end
  else begin
    recNo  := dsPotentialWSNewTrades.RecNo;
    OpenDeferral := NewTradesDeferralDetails[RecNo];
    if (VarName = 'DateOpen') then
      Value := DateToStr(OpenDeferral.DateOpen,settings.UserFmt)
    else if (VarName = 'Ticker') then
      Value := OpenDeferral.Ticker
    else if (VarName = 'Shares') then
      Value := FloatToStr(OpenDeferral.Shares, Settings.UserFmt)
    else if (VarName = 'LS') then
      Value := OpenDeferral.ls
    else if (VarName = 'LossAmount') then
      Value := CurrStrEx(OpenDeferral.Amount, Settings.UserFmt)
    else if (VarName = 'DateOfLoss') then
      Value := DateToStr(OpenDeferral.DateOfLoss, Settings.UserFmt)
    else if (VarName = 'ThirtyDaysEnds') then
      Value := DateToStr(OpenDeferral.DateOfLoss + 30, Settings.UserFmt)
    else if (Varname = 'Account') then
      Value := OpenDeferral.Account;
  end;
end;


procedure TdataFastReports.dsSecuritiesMTMGetValue(const VarName: string;
  var Value: Variant);
var
  recNo: Integer;
  Data: TcxGridViewData;
begin
  recNo := dsSecuritiesMTM.recNo;
  Data := frmMain.cxGrid1TableView1.ViewData;
  if (VarName = 'TradeNum') then
    Value := Data.Rows[recNo].Values[1]
  else if (VarName = 'TradeDate') then
    Value := DateToStr(Data.Rows[recNo].Values[2], Settings.UserFmt)
  else if (VarName = 'OC') then
    Value := Data.Rows[recNo].Values[4]
  else if (VarName = 'LS') then
    Value := Data.Rows[recNo].Values[5]
  else if (VarName = 'Ticker') then
    Value := Data.Rows[recNo].Values[6]
  else if (VarName = 'Shares') then
    Value := FloatToStr(Data.Rows[recNo].Values[7], Settings.UserFmt)
  else if (VarName = 'Price') then
    Value := FloatToStr(Data.Rows[recNo].Values[8], Settings.UserFmt)
  else if (VarName = 'Amount') then
    Value := CurrStrEx(Data.Rows[recNo].Values[11], Settings.UserFmt)
  else if (VarName = 'ProfitLoss') then
    Value := CurrStrEx(Data.Rows[recNo].Values[12], Settings.UserFmt);
end;


procedure TdataFastReports.dsSecuritiesMTMNext(Sender: TObject);
var
  recNo: Integer;
  Data: TcxGridViewData;
  S : String;
begin
  recNo := dsSecuritiesMTM.recNo;
  {for some reason this method is called twice for each row and we only want this code to run once
    so since the header is one row then clipStr should be one ahead of the row number
    If not then just exit as we have already processed all rows.
  }
  if ClipStr.Count <> RecNo  then Exit;
  Data := frmMain.cxGrid1TableView1.ViewData;
//  S := IntToStr(Data.Rows[recNo].Values[1]) + TAB +
//       DateToStr(Data.Rows[recNo].Values[2], Settings.UserFmt) + TAB +
//       Data.Rows[recNo].Values[4] + TAB +
//       Data.Rows[recNo].Values[5] + TAB +
//       Data.Rows[recNo].Values[6] + TAB +
//       FloatToStr(Data.Rows[recNo].Values[7], Settings.UserFmt) + TAB +
//       FloatToStr(Data.Rows[recNo].Values[8], Settings.UserFmt) + TAB +
//       FloatToStrF(Data.Rows[recNo].Values[10], ffFixed, 12, 2, Settings.UserFmt) + TAB +
//       FloatToStrF(Data.Rows[recNo].Values[11],ffFixed, 12, 2, Settings.UserFmt) + TAB +
//       FloatToStrF(Data.Rows[recNo].Values[12],ffFixed, 12, 2, Settings.UserFmt);
//  ClipStr.Append(S);
end;


procedure TdataFastReports.dsWSSummaryGetValue(const VarName: string;
  var Value: Variant);
var
  recNo: Integer;
  Total: extended;
begin
  recNo := dsWSSummary.recNo;
  Value := '';
  if (VarName = 'OpenDescription')
  and (GainsReportData.ActiveDeferralData[recNo].OpenAmt <> 0) then
    Value := GainsReportData.ActiveDeferralData[recNo].OpenDesc
  else if (VarName = 'OpenAmount')
  and (GainsReportData.ActiveDeferralData[recNo].OpenAmt <> 0) then
    Value := CurrStrEx(-GainsReportData.ActiveDeferralData[recNo].OpenAmt, Settings.UserFmt)
  else if (VarName = 'JanDescription')
  and (GainsReportData.ActiveDeferralData[recNo].JanAmt <> 0) then
    Value := GainsReportData.ActiveDeferralData[recNo].JanDesc
  else if (VarName = 'JanAmount')
  and (GainsReportData.ActiveDeferralData[recNo].JanAmt <> 0) then
    Value := CurrStrEx(-GainsReportData.ActiveDeferralData[recNo].JanAmt, Settings.UserFmt)
  else if (VarName = 'TotAmount') then begin
    Total := GainsReportData.ActiveDeferralData[recNo].JanAmt +
      GainsReportData.ActiveDeferralData[recNo].OpenAmt;
    if Total <> 0 then Value := CurrStrEx(-Total, Settings.UserFmt);
  end;
  // --------------
  if (recNo = dsWSSummary.RecordCount - 1) then begin
    rptWSDetails.Variables.Variables['TotJanDefr'] := QuotedStr
      (CurrStrEx(-GainsReportData.ActiveJanDeferredTotal, Settings.UserFmt,
        true));
    rptWSDetails.Variables.Variables['TotOpenDefr'] := QuotedStr
      (CurrStrEx(-GainsReportData.ActiveOpenDeferredTotal, Settings.UserFmt,
        true));
    rptWSDetails.Variables.Variables['TotDefr'] := QuotedStr
      (CurrStrEx(-(GainsReportData.ActiveOpenDeferredTotal +
            GainsReportData.ActiveJanDeferredTotal), Settings.UserFmt));
  end;
end;


procedure TdataFastReports.dsIRSD1P2GetValue(const VarName: string; var Value: Variant);
var
  recNo : Integer;
  pl : Double;
begin
  if GainsReportData.BlankRows then begin
    Value := '';
    exit;
  end;
  recNo := dsIrsD1P2.RecNo;
  if (VarName = 'ds') then
    Value := GainsReportData.LTData[recNo].desc
  else if (VarName = 'dta') then
    Value := US_DateStr(GainsReportData.LTData[recNo].dtAcq, Settings.UserFmt)
  else if (VarName = 'dts') then
    Value := US_DateStr(GainsReportData.LTData[recNo].dtSld, Settings.UserFmt)
  else if (VarName = 'sp') then begin
    Value := ReplaceStr(CurrStrEx(GainsReportData.LTData[RecNo].sales, Settings.UserFmt), '.', '  ');
    if GainsReportData.STData[RecNo].sales >= 0 then Value := Value + ' ';
  end
  else if (VarName = 'bas') then begin
    Value := ReplaceStr(CurrStrEx(GainsReportData.LTData[RecNo].cs, Settings.UserFmt), '.', '  ');
    if GainsReportData.LTData[RecNo].cs >= 0 then Value := Value + ' ';
  end
  else if (VarName = 'pl') then begin
    pl := RndTo5(GainsReportData.LTData[RecNo].sales - GainsReportData.LTData[RecNo].cs);
    Value := ReplaceStr(CurrStrEx(pl, Settings.UserFmt), '.', '  ');
    if pl >= 0 then Value := Value + ' ';
  end
  else if (VarName = 'gm03') then begin
    Value := ReplaceStr(CurrStrEx(GainsReportData.LTData[RecNo].gM03, Settings.UserFmt), '.', '  ');
    if GainsReportData.LTData[RecNo].gM03 >=0 then Value := Value + ' ';
  end;
end;


function TdataFastReports.ProcessDetailBand(Section: Char;
  Data: TfrxUserDataSet; ArrayData: TTglReportArray;
  var RecCount: Integer; Rows: Integer; Band: TFrxMasterData;
  HeaderBand: TfrxHeader): extended;
var
  sales, Cost, Adjustment, CostCopy: extended;
  Cnt: Integer;
  I: Integer;
  p: Integer;
  // ------------------------
  { Build a row that will be put into the clipboard. }
  function BuildClipboardRow(Data: TTglReport): String;
  begin
    if TradeLogFile.TaxYear = 2011 then
      result := Data.desc + Tab + Data.code + Tab + US_DateStr(Data.dtAcq,
        Settings.UserFmt) + Tab + US_DateStr(Data.dtSld, Settings.UserFmt)
        + Tab + FloatToStrF(Data.sales, ffCurrency, 12, 2, Settings.UserFmt)
        + Tab + FloatToStrF(Data.cs, ffCurrency, 12, 2, Settings.UserFmt)
        + Tab + FloatToStrF(Data.adjG, ffCurrency, 12, 2, Settings.UserFmt)
    else
      result := Data.desc + Tab + US_DateStr(Data.dtAcq, Settings.UserFmt)
        + Tab + US_DateStr(Data.dtSld, Settings.UserFmt) + Tab + FloatToStrF
        (Data.sales, ffCurrency, 12, 2, Settings.UserFmt) + Tab + FloatToStrF
        (Data.cs, ffCurrency, 12, 2, Settings.UserFmt)
        + Tab + Data.code + Tab + FloatToStrF(Data.adjG, ffCurrency, 12, 2,
        Settings.UserFmt) + Tab + FloatToStrF
        ((Data.sales - Data.cs) + Data.adjG, ffCurrency, 12, 2,
        Settings.UserFmt);
  end;
  // ------------------------
begin
  // Reset all totals variables.
  sales := 0;
  Cost := 0;
  Adjustment := 0;
  Cnt := 0;
  if Band.Name = 'MasterData1' then begin
    frmFastReports.Preview.Report.Variables.Variables['PriceTotalP1'] := QuotedStr(' ');
    frmFastReports.Preview.Report.Variables.Variables['BasisTotalP1'] := QuotedStr(' ');
    frmFastReports.Preview.Report.Variables.Variables['AdjTotalP1'] := QuotedStr(' ');
    frmFastReports.Preview.Report.Variables.Variables['GLTotalP1'] := QuotedStr(' ');
  end
  else if Band.Name = 'MasterData2' then begin
    frmFastReports.Preview.Report.Variables.Variables['PriceTotalP2'] := QuotedStr(' ');
    frmFastReports.Preview.Report.Variables.Variables['BasisTotalP2'] := QuotedStr(' ');
    frmFastReports.Preview.Report.Variables.Variables['AdjTotalP2'] := QuotedStr(' ');
    frmFastReports.Preview.Report.Variables.Variables['GLTotalP2'] := QuotedStr(' ');
  end;
  Data.First;
  while Not Data.EOF do begin
    if (Data.Value['abc'] = Section) then begin
      if (Cnt mod Rows = 0) then begin
        frmFastReports.Preview.Report.Variables.Variables['abc'] := QuotedStr(Section);
        frmFastReports.Preview.Report.Engine.ShowBand(HeaderBand);
      end;
      // If this is not an adjustment line then we need to number it properly.
      if ArrayData[Data.recNo].code <> 'B' then begin
        RecCount := RecCount + 1;
        p := pos(')', ArrayData[Data.recNo].desc);
        // Remove the transaction number that was put on by the GainsAvailable method.
        if (p > 1) then
          Delete(ArrayData[Data.recNo].desc, 1, p - 1);
        // Add the transaction Number to the description.
        ArrayData[Data.recNo].desc := IntToStr(RecCount) + ArrayData[Data.recNo].desc;
      end;
      Inc(Cnt);
      ClipStr.Append(BuildClipboardRow(ArrayData[Data.recNo]));
      frmFastReports.Preview.Report.Engine.ShowBand(Band);
      sales := sales + ArrayData[Data.recNo].sales;
      Cost := Cost + ArrayData[Data.recNo].cs;
      Adjustment := Adjustment + ArrayData[Data.recNo].adjG;
    end;
    Data.Next;
  end;
  CostCopy := Cost;
  // How many lines short of a full page are we.
  // Lets print blanks so we get the full grid
  if (Cnt mod Rows > 0) then begin
    GainsReportData.BlankRows := true;
    Cnt := (Rows - (Cnt mod Rows));
    for I := 1 to Cnt do
      frmFastReports.Preview.Report.Engine.ShowBand(Band);
    GainsReportData.BlankRows := false;
  end;
  // ------------------------
  if Band.Name = 'MasterData1' then begin
    if sales <> 0 then begin
      frmFastReports.Preview.Report.Variables.Variables['PriceTotalP1'] :=
        QuotedStr(FloatToStrF(sales, ffCurrency, 12, 2, Settings.InternalFmt));
      frmFastReports.Preview.Report.Variables.Variables['STSales' + Section] :=
        QuotedStr(FloatToStrF(sales, ffCurrency, 12, 0, Settings.InternalFmt));
    end;
    if Cost <> 0 then begin
      frmFastReports.Preview.Report.Variables.Variables['BasisTotalP1'] :=
        QuotedStr(FloatToStrF(Cost, ffCurrency, 12, 2, Settings.InternalFmt));
      frmFastReports.Preview.Report.Variables.Variables['STCost' + Section] :=
        QuotedStr(FloatToStrF(Cost, ffCurrency, 12, 0, Settings.InternalFmt));
    end;
    if Adjustment <> 0 then begin
      frmFastReports.Preview.Report.Variables.Variables['AdjTotalP1'] :=
        QuotedStr(FloatToStrF(Adjustment, ffCurrency, 12, 2,
          Settings.InternalFmt));
      frmFastReports.Preview.Report.Variables.Variables['STAdj' + Section] :=
        QuotedStr(FloatToStrF(Adjustment, ffCurrency, 12, 0,
          Settings.InternalFmt));
    end;
    result := sales - Cost + Adjustment;
    frmFastReports.Preview.Report.Variables.Variables['GLTotalP1'] := QuotedStr
      (FloatToStrF(result, ffCurrency, 12, 2, Settings.InternalFmt));

    if (sales <> 0) or (Cost <> 0) or (Adjustment <> 0) then begin
      frmFastReports.Preview.Report.Variables.Variables['STTotal' + Section] :=
        QuotedStr(FloatToStrF(result, ffCurrency, 12, 0, Settings.InternalFmt));
    end;
  end
  else if Band.Name = 'MasterData2' then begin
    if sales <> 0 then begin
      frmFastReports.Preview.Report.Variables.Variables['PriceTotalP2'] :=
        QuotedStr(FloatToStrF(sales, ffCurrency, 12, 2, Settings.InternalFmt));
      frmFastReports.Preview.Report.Variables.Variables['LTSales' + Section] :=
        QuotedStr(FloatToStrF(sales, ffCurrency, 12, 0, Settings.InternalFmt));
    end;
    if Cost <> 0 then begin
      frmFastReports.Preview.Report.Variables.Variables['BasisTotalP2'] :=
        QuotedStr(FloatToStrF(Cost, ffCurrency, 12, 2, Settings.InternalFmt));
      frmFastReports.Preview.Report.Variables.Variables['LTCost' + Section] :=
        QuotedStr(FloatToStrF(Cost, ffCurrency, 12, 0, Settings.InternalFmt));
    end;
    if Adjustment <> 0 then begin
      frmFastReports.Preview.Report.Variables.Variables['AdjTotalP2'] :=
        QuotedStr(FloatToStrF(Adjustment, ffCurrency, 12, 2,
          Settings.InternalFmt));
      frmFastReports.Preview.Report.Variables.Variables['LTAdj' + Section] :=
        QuotedStr(FloatToStrF(Adjustment, ffCurrency, 12, 0,
          Settings.InternalFmt));
    end;
    result := sales - Cost + Adjustment;
    frmFastReports.Preview.Report.Variables.Variables['GLTotalP2'] := QuotedStr
      (FloatToStrF(result, ffCurrency, 12, 2, Settings.InternalFmt));
    if (sales <> 0) or (Cost <> 0) or (Adjustment <> 0) then begin
      frmFastReports.Preview.Report.Variables.Variables['LTTotal' + Section] :=
        QuotedStr(FloatToStrF(result, ffCurrency, 12, 0, Settings.InternalFmt));
    end;
  end;
  { Output the totals to the Clipboard }
  ClipStr.Append(Tab + Tab + Tab + 'Totals: ' + Tab + FloatToStrF(sales,
      ffCurrency, 12, 2, Settings.InternalFmt) + Tab + FloatToStrF(Cost,
      ffCurrency, 12, 2, Settings.InternalFmt) + Tab + FloatToStrF(Adjustment,
      ffCurrency, 12, 2, Settings.InternalFmt) + Tab + FloatToStrF(result,
      ffCurrency, 12, 2, Settings.InternalFmt) + CRLF);
end;


procedure TdataFastReports.rptChartsBeforePrint(Sender: TfrxReportComponent);
begin
  if Sender.name = 'metTop' then begin
    if ReportStyle = rptVertCharts then begin
      tfrxPictureView(Sender).Picture.MetaFile :=
        frmTlCharts.TLVertBarChart1.TeeCreateMetafile(false,
        frmTlCharts.TLVertBarChart1.GetRectangle);
      Sender.Height := Fr1In * 4.39;
    end
  end
  else if (Sender.name = 'metBottom') then begin
    if (ReportStyle = rptVertCharts) and ShowLineChart then begin
      Sender.Visible := true;
      tfrxPictureView(Sender).Picture.MetaFile :=
        frmTlCharts.TLLineChart1.TeeCreateMetafile(false,
        frmTlCharts.TLLineChart1.GetRectangle);
    end
    else
      Sender.Visible := false;
  end;
end;


procedure TdataFastReports.rptChartsEndDoc(Sender: TObject);
begin
  frmFastReports.ReportComplete;
end;


procedure TdataFastReports.rptDetailBeginDoc(Sender: TObject);
begin
  if ReportStyle = TReportStyle.rptTradeDetails then
    rptDetail.Variables.Variables['Title'] := QuotedStr('Trades Detail Report')
  else if ReportStyle = TReportStyle.rptDateDetails then
    rptDetail.Variables.Variables['Title'] := QuotedStr('Trades Detail Report -- Summed By Date')
  else if ReportStyle = TReportStyle.rptTickerDetails then
    rptDetail.Variables.Variables['Title'] := QuotedStr('Trades Detail Report -- Sorted By Ticker');
end;


procedure TdataFastReports.rptDetailEndDoc(Sender: TObject);
begin
  frmFastReports.ReportComplete;
end;


procedure TdataFastReports.rptDetailManualBuild(Page: TfrxPage);
var
  Band: TFrxMasterData;
  FooterBand : TfrxFooter;
  accuTotalPL : Double;
  accuTotalComm : Double;
  RunPL : Double;
  RunSh : Double;
  BreakValue : Variant;
  BreakCol : Integer;
  Data: TcxGridViewData;
  // ------------------------
  function BuildClipBoardRow : String;
  begin
    result := IntToStr(Data.Rows[dsDetails.RecNo].Values[1]) + TAB +
       DateToStr(Data.Rows[dsDetails.RecNo].Values[2], Settings.UserFmt) + TAB +
       Data.Rows[dsDetails.RecNo].Values[4] + TAB +
       Data.Rows[dsDetails.RecNo].Values[5] + TAB +
       Data.Rows[dsDetails.RecNo].Values[6] + TAB +
       FloatToStr(Data.Rows[dsDetails.RecNo].Values[7], Settings.UserFmt) + TAB +
       FloatToStr(Data.Rows[dsDetails.RecNo].Values[8], Settings.UserFmt) + TAB +
       FloatToStrF(Data.Rows[dsDetails.RecNo].Values[10], ffFixed, 12, 2, Settings.UserFmt) + TAB +
       FloatToStrF(Data.Rows[dsDetails.RecNo].Values[11],ffFixed, 12, 2, Settings.UserFmt) + TAB +
       FloatToStrF(Data.Rows[dsDetails.RecNo].Values[12],ffFixed, 12, 2, Settings.UserFmt);
  end;
  // ------------------------
  procedure SetRunningTotals;
  begin
    if ReportStyle = TReportStyle.rptTradeDetails then
      Page.Report.Variables.Variables['RunTitle'] := QuotedStr('Trade #' + VarToStr(BreakValue) + ' P/L:')
    else if ReportStyle = TReportStyle.rptDateDetails then
      Page.Report.Variables.Variables['RunTitle'] := QuotedStr(DateToStr(VarToDateTime(BreakValue), Settings.UserFmt) + ' P/L:')
    else if ReportStyle = TReportStyle.rptTickerDetails then
      Page.Report.Variables.Variables['RunTitle'] := QuotedStr(VarToStr(BreakValue) + ' P/L:');
    Page.Report.Variables.Variables['RunPLTotal'] := QuotedStr(CurrStrEx(RndTo5(RunPL), Settings.UserFmt));
    Page.Report.Variables.Variables['RunSHTotal'] := QuotedStr(FloatToStr(RndTo5(RunSh), Settings.UserFmt));
  end;
  // ------------------------
begin
  accuTotalPL := 0;
  accuTotalComm := 0;
  RunPL := 0;
  RunSh := 0;
  Data := frmMain.cxGrid1TableView1.ViewData;
  Band := Page.Report.FindObject('MasterData1') as TFrxMasterData;
  FooterBand := Page.Report.FindObject('Footer1') as TfrxFooter;
  // Summ by Trnum, Ticker, or Date
  dsDetails.First;
  if ReportStyle = TReportStyle.rptTradeDetails then
    BreakCol := 1
  else if ReportStyle = TReportStyle.rptDateDetails then
    BreakCol := 2
  else if ReportStyle = TReportStyle.rptTickerDetails then
    BreakCol := 6;
  BreakValue := Data.Rows[dsDetails.RecNo].Values[BreakCol];
  while not dsDetails.EOF do begin
    Page.Report.Engine.ShowBand(Band);
    accuTotalPL := accuTotalPL + Data.Rows[dsDetails.recNo].Values[12];
    accuTotalComm := accuTotalComm + Data.Rows[dsDetails.recNo].Values[10];
    RunPL := RunPL + Data.Rows[dsDetails.recNo].Values[12];
    if Data.Rows[dsDetails.RecNo].Values[4] = 'O' then
      RunSh := RunSh + Data.Rows[dsDetails.recNo].Values[7]
    else if (Data.Rows[dsDetails.RecNo].Values[4] = 'C')
         or (Data.Rows[dsDetails.RecNo].Values[4] = 'M') then
      RunSh := RunSh - Data.Rows[dsDetails.recNo].Values[7];
    ClipStr.Append(BuildClipboardRow);
    dsDetails.Next;
    if BreakValue <> Data.Rows[dsDetails.RecNo].Values[BreakCol] then begin
      SetRunningTotals;
      Page.Report.Engine.ShowBand(FooterBand);
      RunPL := 0;
      RunSh := 0;
      BreakValue := Data.Rows[dsDetails.RecNo].Values[BreakCol];
    end;
  end;
  //Set the final running Band
  SetRunningTotals;
  Page.Report.Engine.ShowBand(FooterBand);
  Page.Report.Variables.Variables['TotalPL'] := QuotedStr(CurrStrEx(AccuTotalPL,Settings.UserFmt));
  Page.Report.Variables.Variables['TotalComm'] := QuotedStr(CurrStrEx(AccuTotalComm,Settings.UserFmt));
end;


procedure TdataFastReports.rptFuturesEndDoc(Sender: TObject);
begin
  frmFastReports.ReportComplete;
end;


procedure TdataFastReports.rpt8949_2011EndDoc(Sender: TObject);
begin
  frmFastReports.ReportComplete;
end;


procedure TdataFastReports.rpt8949_2011ManualBuild(Page: TfrxPage);
var
  Band: TFrxMasterData;
  HeaderBand: TfrxHeader;
  Cnt: Integer;
  RowCount: Integer;
  I: Integer;
  GrandTotal: extended;
begin
  if (Page.Name = 'Page1')
  and ManualBuildPage1 then begin
    Band := Page.Report.FindObject('MasterData1') as TFrxMasterData;
    HeaderBand := Page.Report.FindObject('Header1') as TfrxHeader;
    GrandTotal := 0;
    // sets number of rows avilable on Sewchedule D-1 and Form 8949 reports
    if TradeLogFile.TaxYear = 2011 then
      RowCount := 38
    else if TradeLogFile.TaxYear >= 2014 then
      RowCount := 14
    else
      RowCount := 16;
    if (GainsReportData.STSectionAState = ssHasRecords) then begin
      ClipStr.Append(GainsReportData.ShortTermPageHeader['A']);
      ClipStr.Append(GainsReportData.ClipBoardColumnHeader);
      GainsReportData.STSectionAState := ssProcessing;
      Cnt := GainsReportData.STRecordCount;
      GrandTotal := GrandTotal + ProcessDetailBand('A', dsForm8949P1,
        GainsReportData.STData, Cnt, RowCount, Band, HeaderBand);
      GainsReportData.STRecordCount := Cnt;
      GainsReportData.STSectionAState := ssProcessComplete;
    end;
    if (GainsReportData.STSectionAState = ssProcessComplete)
    and (GainsReportData.STSectionBState = ssHasRecords) then begin
      Page.Report.Engine.NewPage;
    end;
    if (GainsReportData.STSectionBState = ssHasRecords) then begin
      ClipStr.Append(GainsReportData.ShortTermPageHeader['B']);
      ClipStr.Append(GainsReportData.ClipBoardColumnHeader);
      GainsReportData.STSectionBState := ssProcessing;
      Cnt := GainsReportData.STRecordCount;
      GrandTotal := GrandTotal + ProcessDetailBand('B', dsForm8949P1,
        GainsReportData.STData, Cnt, RowCount, Band, HeaderBand);
      GainsReportData.STRecordCount := Cnt;
      GainsReportData.STSectionBState := ssProcessComplete;
    end; // if
    if ( (GainsReportData.STSectionAState = ssProcessComplete)
      or (GainsReportData.STSectionBState = ssProcessComplete) )
    and (GainsReportData.STSectionCState = ssHasRecords) then
      Page.Report.Engine.NewPage;
    // end if
    if (GainsReportData.STSectionCState = ssHasRecords) then begin
      ClipStr.Append(GainsReportData.ShortTermPageHeader['C']);
      ClipStr.Append(GainsReportData.ClipBoardColumnHeader);
      GainsReportData.STSectionCState := ssProcessing;
      Cnt := GainsReportData.STRecordCount;
      GrandTotal := GrandTotal + ProcessDetailBand('C', dsForm8949P1,
        GainsReportData.STData, Cnt, RowCount, Band, HeaderBand);
      GainsReportData.STRecordCount := Cnt;
      GainsReportData.STSectionCState := ssProcessComplete;
    end; // if
    { Since the Heading for the report is on page 1 and page 2 does not contain this heading then
      even if there is no Short Term records we need to print a blank page 1.
      The following code will gerne
    }
    if not GainsReportData.HasShortTerm then begin
      GainsReportData.BlankRows := True;
      frmFastReports.Preview.Report.Engine.ShowBand(HeaderBand);
      for I := 1 to RowCount do
        frmFastReports.Preview.Report.Engine.ShowBand(Band);
      GainsReportData.BlankRows := false;
    end; // if
    if GrandTotal <> 0 then
      frmFastReports.Preview.Report.Variables.Variables['Part1GrandTotal'] :=
        QuotedStr(FloatToStrF(GrandTotal, ffCurrency, 12, 0, Settings.InternalFmt));
    // end if
  end
  else if (Page.Name = 'Page1') then
    ManualBuildPage1 := true;
  // end if
  // ------------------------
  if (Page.Name = 'Page2') and ManualBuildPage2 then begin
    Band := Page.Report.FindObject('MasterData2') as TFrxMasterData;
    HeaderBand := Page.Report.FindObject('Header2') as TfrxHeader;
    GrandTotal := 0;
    if TradeLogFile.TaxYear = 2011 then
      RowCount := 39
    else if TradeLogFile.TaxYear >= 2014 then
      RowCount := 15
    else
      RowCount := 17;
    // end if
    if (GainsReportData.LTSectionAState = ssHasRecords) then begin
      ClipStr.Append(GainsReportData.LongTermPageHeader['A']);
      ClipStr.Append(GainsReportData.ClipBoardColumnHeader);
      GainsReportData.LTSectionAState := ssProcessing;
      Cnt := GainsReportData.LTRecordCount;
      GrandTotal := GrandTotal + ProcessDetailBand('A', dsForm8949P2,
        GainsReportData.LTData, Cnt, RowCount, Band, HeaderBand);
      GainsReportData.LTRecordCount := Cnt;
      GainsReportData.LTSectionAState := ssProcessComplete;
    end; // if
    if (GainsReportData.LTSectionAState = ssProcessComplete)
    and (GainsReportData.LTSectionBState = ssHasRecords) then
      Page.Report.Engine.NewPage;
    // end if
    if (GainsReportData.LTSectionBState = ssHasRecords) then begin
      ClipStr.Append(GainsReportData.LongTermPageHeader['B']);
      ClipStr.Append(GainsReportData.ClipBoardColumnHeader);
      GainsReportData.LTSectionBState := ssProcessing;
      Cnt := GainsReportData.LTRecordCount;
      GrandTotal := GrandTotal + ProcessDetailBand('B', dsForm8949P2,
        GainsReportData.LTData, Cnt, RowCount, Band, HeaderBand);
      GainsReportData.LTRecordCount := Cnt;
      GainsReportData.LTSectionBState := ssProcessComplete;
    end; // if
    if ( (GainsReportData.LTSectionAState = ssProcessComplete)
      or (GainsReportData.LTSectionBState = ssProcessComplete) )
    and (GainsReportData.LTSectionCState = ssHasRecords) then
      Page.Report.Engine.NewPage;
    // end if
    if (GainsReportData.LTSectionCState = ssHasRecords) then begin
      ClipStr.Append(GainsReportData.LongTermPageHeader['C']);
      ClipStr.Append(GainsReportData.ClipBoardColumnHeader);
      GainsReportData.LTSectionCState := ssProcessing;
      Cnt := GainsReportData.LTRecordCount;
      GrandTotal := GrandTotal + ProcessDetailBand('C', dsForm8949P2,
        GainsReportData.LTData, Cnt, RowCount, Band, HeaderBand);
      GainsReportData.LTRecordCount := Cnt;
      GainsReportData.LTSectionCState := ssProcessComplete;
    end;
    if GrandTotal <> 0 then
      frmFastReports.Preview.Report.Variables.Variables['Part2GrandTotal'] :=
        QuotedStr(FloatToStrF(GrandTotal, ffCurrency, 12, 0, Settings.InternalFmt));
    // end if
  end
  else if Page.Name = 'Page2' then begin
    ManualBuildPage2 := true;
  end; // if Page.Name
end;


procedure TdataFastReports.rpt8949_2012EndDoc(Sender: TObject);
begin
  frmFastReports.ReportComplete;
end;


procedure TdataFastReports.rptGAndLBeginDoc(Sender: TObject);
var
  R: TfrxReport;
begin
  { Set the title for the report }
  if (ReportStyle = rptTradeSummary) then
    rptGAndL.Variables.Variables['Title'] := QuotedStr('Trades Summary Report')
  else if (ReportStyle = rptTickerSummary) then
    rptGAndL.Variables.Variables['Title'] := QuotedStr
      ('Trades Summary Report -- by Ticker')
  else if (ReportStyle = rpt481Adjust) then
    rptGAndL.Variables.Variables['Title'] := QuotedStr('Section 481 Adjustment')
  else begin
    if TradeLogFile.TaxYear = 2003 then
      R := rptGAndL_03
    else
      R := rptGAndL;
    if (ReportStyle = rpt4797) then begin
      R := rptMTM4797;
      R.Variables.Variables['Title'] := QuotedStr('Gains and Losses for Form 4797');
    end
    else if (ReportStyle = TReportStyle.rptGAndL) then begin
      if GainsReportData.HasShortTerm then
        R.Variables.Variables['Title'] := QuotedStr('Short-Term Realized P&L Report')
      else
        R.Variables.Variables['Title'] := QuotedStr('Long-Term Realized P&L Report');
    end
    else begin
      if GainsReportData.HasShortTerm then
        R.Variables.Variables['Title'] := QuotedStr('Short-Term Gains & Losses Report')
      else
        R.Variables.Variables['Title'] := QuotedStr
          ('Long-Term Gains & Losses Report');
    end;
  end;
end;


procedure TdataFastReports.rptGAndLEndDoc(Sender: TObject);
begin
  frmFastReports.ReportComplete;
end;


procedure TdataFastReports.rptGAndLManualBuild(Page: TfrxPage);
var
  DataBand: TFrxMasterData;
  FooterBand: TfrxFooter;
  Memo: TfrxMemoView;
  Summary: Boolean;
  MTM4797: Boolean;
begin
  if Not ManualBuildPage1 then begin
    ManualBuildPage1 := true;
    exit;
  end;
  Summary := (ReportStyle in [rptTickerSummary, rptTradeSummary, rpt481Adjust]);
  MTM4797 := (ReportStyle = rpt4797);
  DataBand := Page.Report.FindObject('MasterData1') as TFrxMasterData;
  FooterBand := Page.Report.FindObject('Footer1') as TfrxFooter;
  Memo := FooterBand.FindObject('lbDeferredTotal') as TfrxMemoView;
  Memo.Visible := not Summary and not MTM4797;
  Memo := FooterBand.FindObject('txDeferredTotal') as TfrxMemoView;
  Memo.Visible := not Summary and not MTM4797;
  Memo := FooterBand.FindObject('lbIRALostTotal') as TfrxMemoView;
  Memo.Visible := not Summary and not MTM4797;
  Memo := FooterBand.FindObject('txIRALostTotal') as TfrxMemoView;
  Memo.Visible := not Summary and not MTM4797;
  if Summary then begin
    dsGAndL.RangeEnd := reCount;
    dsGAndL.RangeEndCount := Length(datSummary);
    dsGAndL.First;
    while not dsGAndL.EOF do begin
      Page.Report.Engine.ShowBand(DataBand);
      dsGAndL.Next;
    end;
    Page.Report.Engine.ShowBand(FooterBand);
  end
  else begin
    if GainsReportData.HasShortTerm then begin
      GainsReportData.ActiveDataType := adShortTerm;
      dsGAndL.RangeEnd := reCount;
      dsGAndL.RangeEndCount := Length(GainsReportData.ActiveData);
      dsGAndL.First;
      while not dsGAndL.EOF do begin
        Page.Report.Engine.ShowBand(DataBand);
        dsGAndL.Next;
      end;
      Page.Report.Engine.ShowBand(FooterBand);
    end;
    if GainsReportData.HasShortTerm and GainsReportData.HasLongTerm then begin
      { Set the title for Long Term if there was short term }
      Page.Report.Variables.Variables['Title'] := QuotedStr
        ('Long-Term Gains & Losses Report');
      Page.Report.Engine.NewPage;
    end;
    if GainsReportData.HasLongTerm then begin
      GainsReportData.ActiveDataType := adLongTerm;
      dsGAndL.RangeEnd := reCount;
      dsGAndL.RangeEndCount := Length(GainsReportData.ActiveData);
      dsGAndL.First;
      while not dsGAndL.EOF do begin
        Page.Report.Engine.ShowBand(DataBand);
        dsGAndL.Next;
      end;
      Page.Report.Engine.ShowBand(FooterBand);
    end;
  end;
end;


procedure TdataFastReports.rptGAndL_03EndDoc(Sender: TObject);
begin
  frmFastReports.ReportComplete;
end;


procedure TdataFastReports.rptHorizChartsEndDoc(Sender: TObject);
begin
  frmFastReports.ReportComplete;
end;


procedure TdataFastReports.rptHorizChartsManualBuild(Page: TfrxPage);
var
  I : Integer;
  DataBand : TfrxChild;
  Pic : TfrxPictureView;
  Pgs : Integer;
begin
  if Not ManualBuildPage1 then begin
    ManualBuildPage1 := true;
    exit;
  end;
  Pgs := frmTlCharts.tlHorizBarChart1.NumPages;
  DataBand := Page.FindObject('Child1') as TfrxChild;
  Pic := Page.FindObject('metTop') as TfrxPictureView;
  for I := 1 to Pgs do begin
    Pic.Picture.MetaFile :=
      frmTlCharts.TLHorizBarChart1.TeeCreateMetafile(false,
      frmTlCharts.TLHorizBarChart1.GetRectangle);
    rptHorizCharts.Engine.ShowBand(DataBand);
    if I < pgs then
      frmTlCharts.tlHorizBarChart1.NextPage;
  end;
end;


procedure TdataFastReports.rptIRS_D1EndDoc(Sender: TObject);
begin
  frmFastReports.ReportComplete;
end;


procedure TdataFastReports.rptIRS_D1ManualBuild(Page: TfrxPage);
var
  Band: TFrxMasterData;
  HeaderBand: TfrxHeader;
  Cnt: Integer;
  RowCount: Integer;
  Total : String;
  I : Integer;
  TotalRow : String;
  // ------------------------
  function BuildClipboardRow(Data: TTglReport): String;
  begin
    result := Data.desc + Tab + US_DateStr(Data.dtAcq, Settings.UserFmt)
    + Tab +  US_DateStr(Data.dtSld, Settings.UserFmt)
    + Tab + CurrStrEx(Data.sales, Settings.UserFmt)
    + Tab + CurrStrEx(Data.cs, Settings.UserFmt)
    + Tab + CurrStrEx(Data.sales - Data.cs, Settings.UserFmt);
    if TradeLogFile.TaxYear = 2003 then
      Result := Result + TAB + CurrStrEx(Data.gM03, Settings.UserFmt);
  end;
  // ------------------------
begin
  if (Page.Name = 'Page1') and ManualBuildPage1 then begin
    Band := Page.Report.FindObject('MasterData1') as TFrxMasterData;
    HeaderBand := Page.Report.FindObject('Header1') as TfrxHeader;
    RowCount := 24;
    cnt := 0;
    dsIRSD1P1.First;
    ClipStr.Append(GainsReportData.ShortTermPageHeader[' ']);
    ClipStr.Append(GainsReportData.ClipBoardColumnHeader);
    while Not dsIRSD1P1.EOF do begin
      if (cnt mod RowCount = 0) then begin
        frmFastReports.Preview.Report.Engine.ShowBand(HeaderBand);
      end;
      Inc(Cnt);
      ClipStr.Append(BuildClipboardRow(GainsReportData.STData[dsIRSD1P1.recNo]));
      frmFastReports.Preview.Report.Engine.ShowBand(Band);
      dsIRSD1P1.Next;
    end;
    if (Cnt mod RowCount > 0) then begin
      GainsReportData.BlankRows := true;
      Cnt := (RowCount - (Cnt mod RowCount));
      for I := 1 to Cnt do
        frmFastReports.Preview.Report.Engine.ShowBand(Band);
      GainsReportData.BlankRows := false;
    end;
    TotalRow := TAB+TAB+TAB;
    Total := ReplaceStr(CurrStrEx(GainsReportData.STSales, Settings.UserFmt), '.', '  ');
    if GainsReportData.STSales >=0 then Total := Total + ' ';
    Page.Report.Variables.Variables['PriceTotalP1'] := QuotedStr(Total);
    TotalRow := TotalRow + CurrStrEx(GainsReportData.STSales, Settings.UserFmt) + TAB + TAB;
    Total := ReplaceStr(CurrStrEx(GainsReportData.STPAndL, Settings.UserFmt), '.', '  ');
    if GainsReportData.STPAndL >=0 then Total := Total + ' ';
    Page.Report.Variables.Variables['PLTotalP1'] := QuotedStr(Total);
    TotalRow := TotalRow + CurrStrEx(GainsReportData.STPAndL, Settings.UserFmt) + TAB;
    Total := ReplaceStr(CurrStrEx(GainsReportData.STGainMay5, Settings.UserFmt), '.', '  ');
    if GainsReportData.STGainMay5 >=0 then Total := Total + ' ';
    Page.Report.Variables.Variables['May5TotalP1'] := QuotedStr(Total);
    if TradeLogFile.TaxYear = 2003 then
      TotalRow := TotalRow + CurrStrEx(GainsReportData.STGainMay5, Settings.UserFmt) + TAB;
    ClipStr.Append(TotalRow);
  end
  else if (Page.Name = 'Page1') then
    ManualBuildPage1 := true;

  if (Page.Name = 'Page2') and ManualBuildPage2 then begin
    Band := Page.Report.FindObject('MasterData2') as TFrxMasterData;
    HeaderBand := Page.Report.FindObject('Header2') as TfrxHeader;
    RowCount := 25;
    cnt := 0;
    ClipStr.Append(GainsReportData.LongTermPageHeader[' ']);
    ClipStr.Append(GainsReportData.ClipBoardColumnHeader);
    dsIRSD1P2.First;
    while Not dsIRSD1P2.EOF do begin
      if (cnt mod RowCount = 0) then begin
        frmFastReports.Preview.Report.Engine.ShowBand(HeaderBand);
      end;
      Inc(Cnt);
      ClipStr.Append(BuildClipboardRow(GainsReportData.LTData[dsIRSD1P2.recNo]));
      frmFastReports.Preview.Report.Engine.ShowBand(Band);
      dsIRSD1P2.Next;
    end;
    { How many lines short of a full page are we. Lets print blanks so we get the full grid}
    if (Cnt mod RowCount > 0) then begin
      GainsReportData.BlankRows := true;
      Cnt := (RowCount - (Cnt mod RowCount));
      for I := 1 to Cnt do
        frmFastReports.Preview.Report.Engine.ShowBand(Band);
      GainsReportData.BlankRows := false;
    end;
    TotalRow := TAB+TAB+TAB;
    Total := ReplaceStr(CurrStrEx(GainsReportData.LTSales, Settings.UserFmt), '.', '  ');
    if GainsReportData.LTSales >=0 then Total := Total + ' ';
    Page.Report.Variables.Variables['PriceTotalP2'] := QuotedStr(Total);
    TotalRow := TotalRow + CurrStrEx(GainsReportData.LTSales, Settings.UserFmt) + TAB + TAB;
    Total := ReplaceStr(CurrStrEx(GainsReportData.LTPAndL, Settings.UserFmt), '.', '  ');
    if GainsReportData.LTPAndL >=0 then Total := Total + ' ';
    Page.Report.Variables.Variables['PLTotalP2'] := QuotedStr(Total);
    TotalRow := TotalRow + CurrStrEx(GainsReportData.LTPAndL, Settings.UserFmt) + TAB;
    Total := ReplaceStr(CurrStrEx(GainsReportData.LTGainMay5, Settings.UserFmt), '.', '  ');
    if GainsReportData.LTGainMay5 >=0 then Total := Total + ' ';
    Page.Report.Variables.Variables['May5TotalP2'] := QuotedStr(Total);
    if TradeLogFile.TaxYear = 2003 then
      TotalRow := TotalRow + CurrStrEx(GainsReportData.LTGainMay5, Settings.UserFmt) + TAB;
    ClipStr.Append(TotalRow);
  end
  else if Page.Name = 'Page2' then
    ManualBuildPage2 := True;
end;


procedure TdataFastReports.rptIRS_D1_2003EndDoc(Sender: TObject);
begin
  frmFastReports.ReportComplete;
end;


procedure TdataFastReports.rptPerformanceBeforePrint
  (Sender: TfrxReportComponent);
begin
  if Sender.name = 'SharesPieChart' then
    tfrxPictureView(Sender).Picture.MetaFile :=
      frmTlCharts.SharesPieChart.TeeCreateMetafile(false,
      frmTlCharts.SharesPieChart.GetRectangle)
  else if Sender.name = 'PLPieChart' then
    tfrxPictureView(Sender).Picture.MetaFile :=
      frmTlCharts.PL_PieChart.TeeCreateMetafile(false,
      frmTlCharts.PL_PieChart.GetRectangle);
end;


procedure TdataFastReports.rptPerformanceEndDoc(Sender: TObject);
begin
  frmFastReports.ReportComplete;
end;


procedure TdataFastReports.rptPotentialWSEndDoc(Sender: TObject);
begin
  frmFastReports.ReportComplete;
end;


procedure TdataFastReports.rptReconcileEndDoc(Sender: TObject);
begin
  frmFastReports.ReportComplete;
end;


procedure TdataFastReports.rptSecuritiesMTMEndDoc(Sender: TObject);
begin
  frmFastReports.ReportComplete;
end;


procedure TdataFastReports.rptSecuritiesMTMManualBuild(Page: TfrxPage);
var
  DataBand: TFrxMasterData;
  FooterBand: TfrxFooter;
  LS, S1: String;
  pl, Amt, PL1, Amt1, totalPL: Double;
  Data: TcxGridViewData;
  R1 : integer;
  // ------------------------
  procedure SetTotalsVariables;
  begin
    if LS = 'S' then
      Page.Report.Variables.Variables['TotalDesc'] := QuotedStr('Total COST Short:')
    else
      Page.Report.Variables.Variables['TotalDesc'] := QuotedStr(
        'Needed for 1099 Reconciliation --> Total SALES - Long:');
    Page.Report.Variables.Variables['RunningAmt'] := QuotedStr
      (CurrStrEx(Amt, Settings.UserFmt));
    Page.Report.Variables.Variables['RunningPL'] := QuotedStr
      (CurrStrEx(pl, Settings.UserFmt));
  end;
  // ------------------------
begin
  PassNum := PassNum + 1;
  Data := frmMain.cxGrid1TableView1.ViewData;
  DataBand := Page.Report.FindObject('MasterData1') as TFrxMasterData;
  FooterBand := Page.Report.FindObject('Footer1') as TfrxFooter;
  dsSecuritiesMTM.First;
  LS := VarToStr(Data.Rows[dsSecuritiesMTM.recNo].Values[5]);
  pl := 0;
  Amt := 0;
  totalPL := 0;
  while not dsSecuritiesMTM.EOF do begin
//    Page.Report.Engine.ShowBand(DataBand);
    R1 := dsSecuritiesMTM.recNo;
    // check to see if this is the transition from Long to Short
    if not dsSecuritiesMTM.EOF
    and (VarToStr(Data.Rows[R1].Values[5]) <> LS) then begin
      SetTotalsVariables;
      Page.Report.Engine.ShowBand(FooterBand);
      totalPL := totalPL + pl;
      pl := 0;
      Amt := 0;
      LS := VarToStr(Data.Rows[R1].Values[5]);
    end;
    Page.Report.Engine.ShowBand(DataBand);
    PL1 := Data.Rows[R1].Values[12];
    Amt1 := Data.Rows[R1].Values[11];
    pl := pl + PL1;
    Amt := Amt + Amt1;
    if (PassNum < 2) then begin
    S1 := IntToStr(Data.Rows[R1].Values[1]) + TAB //
      +  DateToStr(Data.Rows[R1].Values[2], Settings.UserFmt) + TAB //
      +  Data.Rows[R1].Values[4] + TAB //
      +  Data.Rows[R1].Values[5] + TAB //
      +  Data.Rows[R1].Values[6] + TAB //
      +  FloatToStr(Data.Rows[R1].Values[7], Settings.UserFmt) + TAB //
      +  FloatToStr(Data.Rows[R1].Values[8], Settings.UserFmt) + TAB //
      +  FloatToStrF(Data.Rows[R1].Values[10], ffFixed, 12, 2, Settings.UserFmt) + TAB //
      +  FloatToStrF(Amt1,ffFixed, 12, 2, Settings.UserFmt) + TAB //
      +  FloatToStrF(PL1,ffFixed, 12, 2, Settings.UserFmt);
    ClipStr.Append(S1);
    end;
//    LastRecNo := R1;
    dsSecuritiesMTM.Next;
  end;
  totalPL := totalPL + pl;
  SetTotalsVariables;
  Page.Report.Engine.ShowBand(FooterBand);
  Page.Report.Variables.Variables['TotalPL'] := QuotedStr(CurrStrEx(totalPL, Settings.UserFmt));
end;


procedure TdataFastReports.rptWSDetailsEndDoc(Sender: TObject);
begin
  frmFastReports.ReportComplete;
end;


procedure TdataFastReports.rptWSDetailsManualBuild(Page: TfrxPage);
var
  DataBand: TFrxMasterData;
  FooterBand: TfrxFooter;
  HeaderBand: TfrxHeader;
  Memo: TfrxMemoView;
  TotalSales, totalCost, totalPL, TotalDeferrals, TotalWSLostToIra: extended;
  GrTotOpen, GrTotJan: extended;
begin
  { The next two if's are necessary to keep this method from running twice. We only want to
    process for a page the second time through, so the first time we just exit. }
  if (Page.Name = 'Page1') and Not ManualBuildPage1 then begin
    ManualBuildPage1 := true;
    exit;
  end;
  if (Page.Name = 'Page2') and Not ManualBuildPage2 then begin
    ManualBuildPage2 := true;
    exit;
  end;
  if (Page.Name = 'Page1') then begin
    DataBand := Page.Report.FindObject('MasterData1') as TFrxMasterData;
    FooterBand := Page.Report.FindObject('Footer1') as TfrxFooter;
    HeaderBand := Page.Report.FindObject('Header1') as TfrxHeader;
    GrTotOpen := 0;
    GrTotJan := 0;
    if ( High(GainsReportData.STDeferralData) <> -1)
    or ( High(GainsReportData.LTDeferralData) <> -1) then begin
      Page.Report.Variables.Variables['Title'] := QuotedStr
        ('Summary of Wash Sale Loss Deferrals');
      Page.Report.Engine.ShowBand(HeaderBand);
      GainsReportData.ActiveDeferralDataType := addShortLong;
      dsWSSummary.RangeEnd := reCount;
      dsWSSummary.RangeEndCount := Length(GainsReportData.ActiveDeferralData);
      dsWSSummary.First;
      while not dsWSSummary.EOF do begin
        Page.Report.Engine.ShowBand(DataBand);
        dsWSSummary.Next;
      end;
      Page.Report.Engine.ShowBand(FooterBand);
      GrTotOpen := GrTotOpen + GainsReportData.LTOpenDeferrals +
        GainsReportData.STOpenDeferrals;
      GrTotJan := GrTotJan + GainsReportData.LTJanDeferrals +
        GainsReportData.STJanDeferrals;
    end;

    if ( High(GainsReportData.IRADeferralData) <> -1) then begin
      Memo := Page.Report.FindObject('lbOpenTotals') as TfrxMemoView;
      Memo.Visible := false;
      Memo := Page.Report.FindObject('TxtOpenTotals') as TfrxMemoView;
      Memo.Visible := false;
      Memo := Page.Report.FindObject('lbJanTotals') as TfrxMemoView;
      Memo.Visible := false;
      Memo := Page.Report.FindObject('txtJanTotals') as TfrxMemoView;
      Memo.Visible := false;
      Memo := rptWSDetails.FindObject('lblOpenPositions') as TfrxMemoView;
      Memo.Visible := false;
      Memo := Page.Report.FindObject('lblJanTrades') as TfrxMemoView;
      Memo.Visible := false;
      Memo := Page.Report.FindObject('txtJanData') as TfrxMemoView;
      Memo.Visible := false;
      Page.Report.Variables.Variables['Title'] := QuotedStr(
        'Summary of Wash Sales Permanently Disallowed (IRA)');
      Page.Report.Engine.ShowBand(HeaderBand);
      GainsReportData.ActiveDeferralDataType := addIRA;
      dsWSSummary.RangeEnd := reCount;
      dsWSSummary.RangeEndCount := Length(GainsReportData.ActiveDeferralData);
      dsWSSummary.First;
      while not dsWSSummary.EOF do begin
        Page.Report.Engine.ShowBand(DataBand);
        dsWSSummary.Next;
      end;
      Page.Report.Engine.ShowBand(FooterBand);
      GrTotOpen := GrTotOpen + GainsReportData.IRAOpenDeferrals;
      GrTotJan := GrTotJan + GainsReportData.IRAJanDeferrals;
    end;
    Page.Report.Variables.Variables['GTotOpenDefr'] := QuotedStr
      (CurrStrEx(-GrTotOpen, Settings.UserFmt));
    Page.Report.Variables.Variables['GTotJanDefr'] := QuotedStr
      (CurrStrEx(-GrTotJan, Settings.UserFmt));
    Page.Report.Variables.Variables['GTotDefr'] := QuotedStr
      (CurrStrEx(-(GrTotJan + GrTotOpen), Settings.UserFmt));
    Page.Report.Variables.Variables['Title'] := QuotedStr
      ('Trade Details');
  end
  else if (Page.Name = 'Page2') then begin
    DataBand := Page.Report.FindObject('MasterData2') as TFrxMasterData;
    FooterBand := Page.Report.FindObject('Footer2') as TfrxFooter;
    TotalSales := 0;
    totalCost := 0;
    totalPL := 0;
    TotalDeferrals := 0;
    TotalWSLostToIra := 0;
    if GainsReportData.HasShortTerm then begin
      GainsReportData.ActiveDataType := adShortTerm;
      dsGAndL.RangeEnd := reCount;
      dsGAndL.RangeEndCount := Length(GainsReportData.ActiveData);
      dsGAndL.First;
      while not dsGAndL.EOF do begin
        Page.Report.Engine.ShowBand(DataBand);
        dsGAndL.Next;
      end;
      TotalSales := TotalSales + GainsReportData.TotalSales;
      totalCost := totalCost + GainsReportData.TotalCostBasis;
      totalPL := totalPL + GainsReportData.TotalPAndL;
      TotalDeferrals := TotalDeferrals + GainsReportData.TotalDeferrals;
      TotalWSLostToIra := TotalWSLostToIra + GainsReportData.TotalWSLostToIra;
    end;
    if GainsReportData.HasLongTerm then begin
      GainsReportData.ActiveDataType := adLongTerm;
      dsGAndL.RangeEnd := reCount;
      dsGAndL.RangeEndCount := Length(GainsReportData.ActiveData);
      dsGAndL.First;
      while not dsGAndL.EOF do begin
        Page.Report.Engine.ShowBand(DataBand);
        dsGAndL.Next;
      end;
      TotalSales := TotalSales + GainsReportData.TotalSales;
      totalCost := totalCost + GainsReportData.TotalCostBasis;
      totalPL := totalPL + GainsReportData.TotalPAndL;
      TotalDeferrals := TotalDeferrals + GainsReportData.TotalDeferrals;
      TotalWSLostToIra := TotalWSLostToIra + GainsReportData.TotalWSLostToIra;
    end;
    frmFastReports.Preview.Report.Variables.Variables['TotalSales'] := QuotedStr
      (CurrStrEx(TotalSales, Settings.UserFmt));
    frmFastReports.Preview.Report.Variables.Variables['TotalCost'] := QuotedStr
      (CurrStrEx(totalCost, Settings.UserFmt));
    frmFastReports.Preview.Report.Variables.Variables['TotalPL'] := QuotedStr
      (CurrStrEx(totalPL, Settings.UserFmt));
    if TotalDeferrals <> 0 then
      frmFastReports.Preview.Report.Variables.Variables['DeferredWS'] :=
        QuotedStr(CurrStrEx(TotalDeferrals, Settings.UserFmt))
    else
      frmFastReports.Preview.Report.Variables.Variables['DeferredWS'] :=
        QuotedStr('None');
    if TotalWSLostToIra <> 0 then
      frmFastReports.Preview.Report.Variables.Variables['WSLostToIra'] :=
        QuotedStr(CurrStrEx(TotalWSLostToIra, Settings.UserFmt))
    else
      frmFastReports.Preview.Report.Variables.Variables['WSLostToIra'] :=
        QuotedStr('None');
    Page.Report.Engine.ShowBand(FooterBand);
  end;
end;


procedure TdataFastReports.rptWSDetails_03EndDoc(Sender: TObject);
begin
  frmFastReports.ReportComplete;
end;


procedure TdataFastReports.SetupBackPicture(DataPage: TfrxReportPage; DraftForTaxYear : Boolean = false);
var
  isVisible : Boolean;
begin
  if DataPage = nil then exit;
  // show "Draft" watermark if these conditions are met...
  IsVisible := (DraftForTaxYear and (TradeLogFile.TaxYear > MAX_TAX_YEAR))
    or not (TradeLogFile.AllCheckListsComplete and TradeLogFile.YearEndDone)
    or ((TradeLogFile.CurrentBrokerID <> 0) and TradeLogFile.MultiBrokerFile);
  //code to remove draft when running 4797 from account tab
  if IsVisible then begin
    DataPage.BackPicture := frmFastReports.imDraftBackground.Picture;
    DataPage.BackPictureVisible := IsVisible;
    DataPage.BackPicturePrintable := IsVisible;
  end
  else begin
    DataPage.BackPictureVisible := IsVisible;
    DataPage.BackPicturePrintable := IsVisible;
  end;
end;


procedure TdataFastReports.SetupGainsReportData(ShortTerm, LongTerm, IncludeCostAdjustment: Boolean; MTM: Boolean = false);
var
  StartingLineNumber: Integer;
begin
  if not LongTerm and not ShortTerm then
    raise EReportException.Create(
      'Cannot setup Gains Report Data if both Short and Long Term are false');
  if LongTerm and MTM then
    raise EReportException.Create(
      'Cannot setup Gains Report Data if both Long Term and MTM are true');
  // end error raise conditions
  // --------------------------
  StartingLineNumber := 1;
  GainsReportData := TGainsReportData.Create;
  GainsReportData.IncludeCostAdjustment := IncludeCostAdjustment;
  // The way the data is collected for this report is very difficult to follow. There are many
  // methods involved and many global variables that are defined in other units. This should
  // probably be rewritten to be more encapsulated.
  // --------------------------
  // Populate the arrays for the datasets. The GainsReportAvailable method does not just report if there
  // are gains but is also the method that actually populates the datGL Array with data.
  // By setting these two variables we control what lands in the datGL array.
  if ShortTerm or MTM then begin
    DoST := true;
    DoLT := MTM;
    // Short Term Boolean is used later to determine how the
    // totals hide panel message should display
    // *****
    // THIS IS THE MAIN ROUTINE THAT LOOPS THRU TrSumList TO POPULATE THE REPORT
    // *****
    GainsReportData.HasShortTerm := GainsReportAvailable(StartingLineNumber);
    // *****
    if GainsReportData.HasShortTerm
    or (Length(TradeLogFile.CostBasis1099STAllBrokers) > 0) then begin
      // Grab the Totals for this run
      GainsReportData.STDeferrals := totWSdeferS;
      GainsReportData.STWSLostToIra := totWSLostToIraS;
      GainsReportData.STPAndL := ProfTot;
      GainsReportData.STSales := SlsprTot; //           Sales
      GainsReportData.STCostBasis := CostTot; //        - Cost
      GainsReportData.STGain := GainTot;
      GainsReportData.STLoss := LossTot;
      GainsReportData.STAdjustment := AdjGTot; //       + Adj = Taxable G/L
      GainsReportData.STActualGL := totActualGLST;
      GainsReportData.STGainMay5 := GainMay5Tot;
      // Make a copy of the results of GainsReportAvailable
      GainsReportData.STData := Copy(datGL, 0, Length(datGL));
      if bNew8949 then begin
        GainsReportData.SumSTData; // 2025-08-14 MB
      end;
      GainsReportData.STDeferralData := Copy(datDeferralsST, 0, Length(datDeferralsST));
    end
  end; // if ShortTerm or MTM
  if LongTerm then begin
    // So now let's do the long term Gains/Losses.
    DoST := false;
    DoLT := true;
    // Long Term variable is also used later to determine
    // how the totals hide panel message should display.
    // ------------ now get the data ----------------------
    GainsReportData.HasLongTerm := GainsReportAvailable(StartingLineNumber);
    if GainsReportData.HasLongTerm then begin
      // Get Totals for Long Term
      GainsReportData.LTDeferrals := totWSdeferL;
      GainsReportData.LTWSLostToIra := totWSLostToIraL;
      GainsReportData.LTPAndL := ProfTot;
      GainsReportData.LTSales := SlsprTot;
      GainsReportData.LTCostBasis := CostTot;
      GainsReportData.LTGain := GainTot;
      GainsReportData.LTLoss := LossTot;
      GainsReportData.LTAdjustment := AdjGTot;
      GainsReportData.LTActualGL := totActualGLLT;
      GainsReportData.LTGainMay5 := GainMay5Tot;
      // Copy Long Term Data into our variable
      GainsReportData.LTData := Copy(datGL, 0, Length(datGL));
      if bNew8949 then begin
        GainsReportData.SumLTData; // 2025-08-14 MB
      end;
      GainsReportData.LTDeferralData := Copy(datDeferralsLT, 0, Length(datDeferralsLT));
    end
  end;
  GainsReportData.IRADeferralData := Copy(datDeferralsIra, 0, Length(datDeferralsIra));
  SetWashSaleLineNumbers(GainsReportData.STData, true);
  SetWashSaleLineNumbers(GainsReportData.LTData, false);
end;


// ----------------
// Form 8949 Report
// ----------------
procedure TdataFastReports.Run8949Report(IncSummary, IncForm8949, IncAdjustment: Boolean);
var
  I, nSTPage, nLTPage, nSummaryPage : Integer;
  DataPage: TfrxReportPage;
  ReportToUse: TfrxReport;
begin
  ManualBuildPage1 := false;
  ManualBuildPage2 := false;
  bNew8949 := false;
  nSTPage := 1;
  nLTPage := 2;
  nSummaryPage := 3;
  // differences between 2011 and newer versions
  if TradeLogFile.TaxYear = 2011 then begin
    ReportToUse := rpt8949_2011;
    ReportToUse.Pages[3].Visible := (tradeLogFile.TaxYear <= 2012) //
      and not frmMain.cbForm8949pdf.Checked;
    ReportToUse.Pages[4].Visible := frmMain.cbIncludeAdjustment.Checked;
  end
  // select the appropriate tax form
  else begin
    if TradeLogFile.TaxYear > 2023 then begin
      ReportToUse := rpt8949_2025;
      bNew8949 := true;
      nSummaryPage := 1;
      nSTPage := 2;
      nLTPage := 3;
    end
    else if TradeLogFile.TaxYear > 2017 then begin
      ReportToUse := rpt8949_2018;
    end
    else if TradeLogFile.TaxYear > 2014 then begin
      ReportToUse := rpt8949_2015;
    end
    else if TradeLogFile.TaxYear > 2013 then begin
      ReportToUse := rpt8949_2014;
    end
    else begin
      ReportToUse := rpt8949_2012;
    end;
    // show/hide parts which do/don't apply
    if (tradeLogFile.TaxYear <= 2013) then begin
      ReportToUse.Pages[3].Visible := (tradeLogFile.TaxYear <= 2012)
        and not frmMain.cbForm8949pdf.Checked;
      ReportToUse.Pages[4].Visible := (tradeLogFile.TaxYear > 2012)
        and not frmMain.cbForm8949pdf.Checked;
      ReportToUse.Pages[5].Visible := frmMain.cbIncludeAdjustment.Checked;
      ReportToUse.Pages[6].Visible := frmMain.cbIncludeStatement.Checked;
    end
    else begin
      // 2025-08-07 MB - changed so Summary not visible if "Create 8949 PDF" is checked.
      ReportToUse.Pages[nSummaryPage].Visible := IncSummary and not frmMain.cbForm8949pdf.Checked;
      ReportToUse.Pages[4].Visible := frmMain.cbIncludeStatement.Checked;
    end;
  end;
  // Holds all the variables for a run of the 8949 Report.
  SetupGainsReportData(true, true, IncAdjustment);
  // ----- is Form8949 selected? -----
  if IncForm8949 then begin
    // Prepare for Short Term Data
    if GainsReportData.HasShortTerm
    or (Length(TradeLogFile.CostBasis1099STAllBrokers) > 0) then begin
      dsForm8949P1.RangeEnd := reCount;
      dsForm8949P1.RangeEndCount := Length(GainsReportData.STData);
    end;
    // Prepare for Long Term Data
    if GainsReportData.HasLongTerm then begin
      dsForm8949P2.RangeEnd := reCount;
      dsForm8949P2.RangeEndCount := Length(GainsReportData.LTData);
      ReportToUse.Pages[nLTPage].Visible := true;
    end
    else if (Length(TradeLogFile.CostBasis1099LTAllBrokers) > 0) then
      ReportToUse.Pages[nLTPage].Visible := Trim(TradeLogFile.CostBasis1099LTAllBrokers) <> '0'
    else
      ReportToUse.Pages[nLTPage].Visible := false;
  end
  else begin
    ReportToUse.Pages[nSTPage].Visible := false;
    ReportToUse.Pages[nLTPage].Visible := false;
  end;
  // Init variables to null, they will be set on the last page of data.
  ReportToUse.Variables.Variables['PriceTotalP1'] := QuotedStr(' ');
  ReportToUse.Variables.Variables['BasisTotalP1'] := QuotedStr(' ');
  ReportToUse.Variables.Variables['PriceTotalP2'] := QuotedStr(' ');
  ReportToUse.Variables.Variables['BasisTotalP2'] := QuotedStr(' ');
  ReportToUse.Variables.Variables['AdjTotalP1'] := QuotedStr(' ');
  ReportToUse.Variables.Variables['AdjTotalP2'] := QuotedStr(' ');
  ReportToUse.Variables.Variables['abc'] := QuotedStr(' ');
  ReportToUse.Variables.Variables['SocialSecurity'] := QuotedStr(' ');
  ReportToUse.Variables.Variables['GLTotalP1'] := QuotedStr(' ');
  ReportToUse.Variables.Variables['GLTotalP2'] := QuotedStr(' ');
  if bNew8949 then begin
    // ----- Short Term -----
    ReportToUse.Variables.Variables['STSalesA'] := QuotedStr(CurrStrEx(gSTsalesA, Settings.UserFmt, false, false, 0));
    ReportToUse.Variables.Variables['STCostA'] := QuotedStr(CurrStrEx(gSTcostA, Settings.UserFmt, false, false, 0));
    ReportToUse.Variables.Variables['STAdjA'] := QuotedStr(CurrStrEx(gSTadjA, Settings.UserFmt, false, false, 0));
    ReportToUse.Variables.Variables['STTotalA'] := QuotedStr(CurrStrEx(gSTprofA + gSTadjA, Settings.UserFmt, false, false, 0));
    // -----
    ReportToUse.Variables.Variables['STSalesB'] := QuotedStr(CurrStrEx(gSTsalesB, Settings.UserFmt, false, false, 0));
    ReportToUse.Variables.Variables['STCostB'] := QuotedStr(CurrStrEx(gSTcostB, Settings.UserFmt, false, false, 0));
    ReportToUse.Variables.Variables['STAdjB'] := QuotedStr(CurrStrEx(gSTadjB, Settings.UserFmt, false, false, 0));
    ReportToUse.Variables.Variables['STTotalB'] := QuotedStr(CurrStrEx(gSTprofB + gSTadjB, Settings.UserFmt, false, false, 0));
    // -----
    ReportToUse.Variables.Variables['STSalesC'] := QuotedStr(CurrStrEx(gSTsalesC, Settings.UserFmt, false, false, 0));
    ReportToUse.Variables.Variables['STCostC'] := QuotedStr(CurrStrEx(gSTcostC, Settings.UserFmt, false, false, 0));
    ReportToUse.Variables.Variables['STAdjC'] := QuotedStr(CurrStrEx(gSTadjC, Settings.UserFmt, false, false, 0));
    ReportToUse.Variables.Variables['STTotalC'] := QuotedStr(CurrStrEx(gSTprofC + gSTadjC, Settings.UserFmt, false, false, 0));
    // ----- Long Term -----
    ReportToUse.Variables.Variables['LTSalesA'] := QuotedStr(CurrStrEx(gLTsalesA, Settings.UserFmt, true, false, 0));
    ReportToUse.Variables.Variables['LTCostA'] := QuotedStr(CurrStrEx(gLTcostA, Settings.UserFmt, true, false, 0));
    ReportToUse.Variables.Variables['LTAdjA'] := QuotedStr(CurrStrEx(gLTadjA, Settings.UserFmt, true, false, 0));
    ReportToUse.Variables.Variables['LTTotalA'] := QuotedStr(CurrStrEx(gLTprofA + gLTadjA, Settings.UserFmt, true, false, 0));
    // -----
    ReportToUse.Variables.Variables['LTSalesB'] := QuotedStr(CurrStrEx(gLTsalesB, Settings.UserFmt, true, false, 0));
    ReportToUse.Variables.Variables['LTCostB'] := QuotedStr(CurrStrEx(gLTcostB, Settings.UserFmt, true, false, 0));
    ReportToUse.Variables.Variables['LTAdjB'] := QuotedStr(CurrStrEx(gLTadjB, Settings.UserFmt, true, false, 0));
    ReportToUse.Variables.Variables['LTTotalB'] := QuotedStr(CurrStrEx(gLTprofB + gLTadjB, Settings.UserFmt, true, false, 0));
    // -----
    ReportToUse.Variables.Variables['LTSalesC'] := QuotedStr(CurrStrEx(gLTsalesC, Settings.UserFmt, true, false, 0));
    ReportToUse.Variables.Variables['LTCostC'] := QuotedStr(CurrStrEx(gLTcostC, Settings.UserFmt, true, false, 0));
    ReportToUse.Variables.Variables['LTAdjC'] := QuotedStr(CurrStrEx(gLTadjC, Settings.UserFmt, true, false, 0));
    ReportToUse.Variables.Variables['LTTotalC'] := QuotedStr(CurrStrEx(gLTprofC + gLTadjC, Settings.UserFmt, true, false, 0));
  end;
  // -----
  // Dont want margin settings to affect this report.
  frmFastReports.AllowMarginAdjustment := false;
  // Setup the totals panel with the above totals.
  frmFastReports.SetupTotalsPanel(true);
  frmFastReports.SetupExports(true);
  // Clear the Clipboard so that we can create the report in it.
  ClipStr.Clear;
  ClipStr.Append(GainsReportData.Form8949ReportHeader + CRLF);
  //add a Draft Watermark to Years where Form 8949 has not been finalized yet.
  SetupBackPicture(ReportToUse.FindObject('Page1') as TfrxReportPage, True);
  SetupBackPicture(ReportToUse.FindObject('Page2') as TfrxReportPage, True);
  SetupBackPicture(ReportToUse.FindObject('Page3') as TfrxReportPage, True);
  frmFastReports.DoReport(ReportToUse);
end; // run8949report


procedure TdataFastReports.RunIRSD1Report;
var
  I: Integer;
  DataPage: TfrxReportPage;
  ReportToUse: TfrxReport;
begin
  ManualBuildPage1 := false;
  ManualBuildPage2 := false;
  if TradeLogFile.TaxYear = 2003 then
    ReportToUse := rptIRS_D1_2003
  else
    ReportToUse := rptIRS_D1;
  // Holds all the variables for a run of the IRS D1 Report.
  SetupGainsReportData(true, true, False);
  // Prepare for Short Term Data
  if GainsReportData.HasShortTerm then begin
    dsIRSD1P1.RangeEnd := reCount;
    dsIRSD1P1.RangeEndCount := Length(GainsReportData.STData);
  end;
  // Prepare for Long Term Data
  if GainsReportData.HasLongTerm then begin
    dsIRSD1P2.RangeEnd := reCount;
    dsIRSD1P2.RangeEndCount := Length(GainsReportData.LTData);
    ReportToUse.Pages[2].Visible := true;
  end
  else
    ReportToUse.Pages[2].Visible := False;
  // end if HasLongTerm
  // Initialize these variables to null, they will be set on the last page of data.
  ReportToUse.Variables.Variables['PriceTotalP1'] := QuotedStr(' ');
  ReportToUse.Variables.Variables['BasisTotalP1'] := QuotedStr(' ');
  ReportToUse.Variables.Variables['PriceTotalP2'] := QuotedStr(' ');
  ReportToUse.Variables.Variables['BasisTotalP2'] := QuotedStr(' ');
  ReportToUse.Variables.Variables['PLTotalP1'] := QuotedStr(' ');
  ReportToUse.Variables.Variables['PLTotalP2'] := QuotedStr(' ');
  ReportToUse.Variables.Variables['May5TotalP1'] := QuotedStr(' ');
  ReportToUse.Variables.Variables['May5TotalP2'] := QuotedStr(' ');
  ReportToUse.Variables.Variables['SocialSecurity'] := QuotedStr(' ');
  // Dont want margin settings to affect this report.
  frmFastReports.AllowMarginAdjustment := false;
  // Setup the totals panel with the above totals.
  frmFastReports.SetupTotalsPanel(true);
  frmFastReports.SetupExports(true);
  // Clear the Clipboard so that we can create the report in it.
  ClipStr.Clear;
  ClipStr.Append(GainsReportData.IRSD1ReportHeader + CRLF);
  SetupBackPicture(ReportToUse.FindObject('Page1') as TfrxReportPage);
  SetupBackPicture(ReportToUse.FindObject('Page2') as TfrxReportPage);
  frmFastReports.DoReport(ReportToUse);
end;


procedure TdataFastReports.RunChartsReport;
var
  I : Integer;
begin
  ManualBuildPage1 := False;
  frmFastReports.SetupTotalsPanel(false);
  frmFastReports.SetupExports(false);
  frmFastReports.AllowMarginAdjustment := true;
  if ReportStyle = rptVertCharts then
    frmFastReports.DoReport(rptCharts)
  else
    frmFastReports.DoReport(rptHorizCharts)
end;


procedure TdataFastReports.RunDetailReport(WithSubTotals : Boolean);
begin
  ClipStr.Clear;
  ClipStr.Append('TrNum' + Tab + 'Date' + Tab + 'O/C' + Tab + 'L/S' + Tab + 'Ticker' + Tab
    + 'Sh/Contr' + Tab + 'Price' + Tab + 'Comm' + Tab + 'Amount' + Tab + 'Profit/Loss');
  dsDetails.RangeEnd := reCount;
  dsDetails.RangeEndCount := frmMain.cxGrid1TableView1.DataController.FilteredRecordCount;
  rptDetail.Variables.Variables['WithSubTotals'] := QuotedStr(BoolToStr(WithSubTotals));
  frmFastReports.SetupTotalsPanel(False);
  frmFastReports.SetupExports(False);
  frmFastReports.AllowMarginAdjustment := True;
  frmFastReports.DoReport(rptDetail);
end;


procedure TdataFastReports.RunFuturesReport;
begin
  { Futures are only short term so no need to process for long term }
  SetupGainsReportData(true, false, false);
  if GainsReportData.HasShortTerm then begin
    dsFutures.RangeEnd := reCount;
    dsFutures.RangeEndCount := Length(GainsReportData.STData);
  end
  else
    exit;
  // end if
  frmFastReports.SetupTotalsPanel(true);
  frmFastReports.SetupExports(false);
  frmFastReports.AllowMarginAdjustment := true;
  frmFastReports.DoReport(rptFutures);
  SetupBackPicture(rptFutures.FindObject('Page1') as TfrxReportPage);
end;


procedure TdataFastReports.RunGAndLReport(MTM: Boolean = false);
var
  ReportToUse: TfrxReport;
  DataPage : TfrxReportPage;
begin
  ManualBuildPage1 := false;
  if TradeLogFile.TaxYear = 2003 then
    ReportToUse := rptGandL_03
  else if MTM then
    ReportToUse := rptMTM4797
  else
    ReportToUse := rptGandL;
  // end if 2003
  if MTM then
    SetupGainsReportData(true, false, false, true)
  else
    SetupGainsReportData(true, true, false);
  // end if MTM
  frmFastReports.SetupTotalsPanel(true);
  frmFastReports.SetupExports(false);
  frmFastReports.AllowMarginAdjustment := true;
  DataPage := ReportToUse.FindObject('Page1') as TfrxReportPage;
  if (ReportStyle <> TReportStyle.rptGandL) then
    SetupBackPicture(DataPage)
  else begin
    DataPage.BackPictureVisible := False;
    DataPage.BackPicturePrintable := False;
  end;
  frmFastReports.DoReport(ReportToUse);
end;


procedure TdataFastReports.RunPerformanceReport;
begin
  frmFastReports.SetupTotalsPanel(false);
  frmFastReports.SetupExports(false);
  frmFastReports.AllowMarginAdjustment := true;
  ComposePerfRpt;
  frmFastReports.DoReport(rptPerformance);
end;


procedure TdataFastReports.RunReconcileReport;
begin
  //Don't want the totals Panel or the Export buttons or menu.
  frmFastReports.SetupTotalsPanel(False);
  frmFastReports.SetupExports(False);
  //Dont want margin settings to affect this report.
  frmFastReports.AllowMarginAdjustment := False;
  //The standard variables in the header are already set for you like year, SSN etc so all you need to set
  //here is the variables for the body of the report that you have created in the report.
  rptReconcile.Variables.Variables['SalesST'] := QuotedStr(CurrStrEx(RndTo2(SalesST),Settings.UserFmt, True));
  rptReconcile.Variables.Variables['SalesLT'] := QuotedStr(CurrStrEx(RndTo2(SalesLT),Settings.UserFmt, True));
  rptReconcile.Variables.Variables['OptEX'] := QuotedStr(CurrStrEx(RndTo2(-optExAssSales),Settings.UserFmt, True));
  rptReconcile.Variables.Variables['OptSales'] := QuotedStr(CurrStrEx(RndTo2(-OptSales),Settings.UserFmt, True));
  rptReconcile.Variables.Variables['IsMTM'] := QuotedStr(BoolToStr(TradeLogFile.CurrentAccount.MTM));
  if TradeLogFile.CurrentAccount.MTM then
    rptReconcile.Variables.Variables['SSPrevTaxYrOrMTMTotal'] := QuotedStr(
      CurrStrEx(RndTo2(-SecMTM), Settings.UserFmt, true))
  else begin
    if TradeLogFile.TaxYear < 2012 then
      rptReconcile.Variables.Variables['SSPrevTaxYrOrMTMTotal'] := QuotedStr(
        CurrStrEx(RndTo2(-OshSales),Settings.UserFmt, True))
    else
      rptReconcile.Variables.Variables['SSPrevTaxYrOrMTMTotal'] := QuotedStr(
        CurrStrEx(RndTo2(-OShNextYrSales),Settings.UserFmt, True))
  end;
  rptReconcile.Variables.Variables['NetSales'] := QuotedStr(
    CurrStrEx(RndTo2(NetSales), Settings.UserFmt, true));
  if Length(TradeLogFile.CurrentAccount.GrossSales1099) > 0 then
    rptReconcile.Variables.Variables['Gross1099'] := QuotedStr(
      CurrStrEx(StrToFloat(Del1000SepEx(
        TradeLogFile.CurrentAccount.GrossSales1099, Settings.UserFmt), Settings.UserFmt),
          Settings.UserFmt, true))
  else
    rptReconcile.Variables.Variables['Gross1099'] := QuotedStr('');
  // end if
  rptReconcile.Variables.Variables['Difference'] := QuotedStr(
    CurrStrEx(RndTo2(DiffSales), Settings.UserFmt, true));
  frmFastReports.DoReport(rptReconcile);
end;


procedure TdataFastReports.RunReportSummary;
var
  DataPage : TFrxReportPage;
begin
  ManualBuildPage1 := false;
  frmFastReports.SetupTotalsPanel(false);
  frmFastReports.SetupExports(false);
  frmFastReports.AllowMarginAdjustment := true;
  DataPage := rptGAndL.FindObject('Page1') as TfrxReportPage;
  if (ReportStyle = rpt481Adjust) then
    SetupBackPicture(DataPage)
  else begin
    DataPage.BackPictureVisible := False;
    DataPage.BackPicturePrintable := False;
  end;
  frmFastReports.DoReport(rptGAndL);
end;


procedure TdataFastReports.RunSecuritiesMTM;
begin
  ClipStr.Clear;
  ClipStr.Append('TrNum' + Tab + 'Date' + Tab + 'O/C' + Tab + 'L/S' + Tab + 'Ticker' + Tab
    + 'Sh/Contr' + Tab + 'Price' + Tab + 'Comm' + Tab + 'Amount' + Tab + 'Profit/Loss');
  frmFastReports.SetupTotalsPanel(false);
  frmFastReports.SetupExports(false);
  frmFastReports.AllowMarginAdjustment := true;
  dsSecuritiesMTM.RangeEnd := reCount;
  dsSecuritiesMTM.RangeEndCount :=
    frmMain.cxGrid1TableView1.DataController.FilteredRecordCount;
  SetupBackPicture(rptSecuritiesMTM.FindObject('Page1') as TfrxReportPage);
  frmFastReports.DoReport(rptSecuritiesMTM);
end;


procedure TdataFastReports.RunWSDetailReport;
var
  ReportToUse: TfrxReport;
begin
  ManualBuildPage1 := false;
  ManualBuildPage2 := false;
  if TradeLogFile.TaxYear = 2003 then
    ReportToUse := rptWSDetails_03
  else
    ReportToUse := rptWSDetails;
  SetupGainsReportData(true, true, false);
  frmFastReports.SetupTotalsPanel(false);
  frmFastReports.SetupExports(false);
  frmFastReports.AllowMarginAdjustment := true;
  ReportToUse.Variables.Variables['GTotOpenDefr'] := QuotedStr(' ');
  ReportToUse.Variables.Variables['GTotJanDefr'] := QuotedStr(' ');
  ReportToUse.Variables.Variables['GTotDefr'] := QuotedStr(' ');
  frmFastReports.DoReport(ReportToUse);
end;


procedure TdataFastReports.RunWSPotentialReport;
begin
  ManualBuildPage1 := false;
  ManualBuildPage2 := false;
  SetupGainsReportData(true, true, false);
  dsPotentialWSDetails.RangeEnd := reCount;
  //We always want All sections to show so even if there are no records
  //  Create a dummy Record with a Ticker of None
  if STDeferralDetails.Count = 0 then
    dsPotentialWSDetails.RangeEndCount := 1
  else
    dsPotentialWSDetails.RangeEndCount := STDeferralDetails.Count;
  //
  dsPotentialWSNewTrades.RangeEnd := reCount;
  if NewTradesDeferralDetails.Count = 0 then
    dsPotentialWSNewTrades.RangeEndCount := 1
  else
    dsPotentialWSNewTrades.RangeEndCount := NewTradesDeferralDetails.Count;
  //
  dsPotentialWSIRA.RangeEnd := reCount;
  if IRADeferralDetails.Count = 0 then
    dsPotentialWSIRA.RangeEndCount := 1
  else
    dsPotentialWSIRA.RangeEndCount := IRADeferralDetails.Count;
  //
  frmFastReports.SetupTotalsPanel(false);
  frmFastReports.SetupExports(false);
  frmFastReports.AllowMarginAdjustment := true;
  frmFastReports.DoReport(rptPotentialWS);
end;


end.
