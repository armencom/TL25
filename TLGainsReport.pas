unit TLGainsReport;

interface

uses FuncProc, Classes, SysUtils;

type
  TSectionState = (ssNone, ssHasRecords, ssProcessing, ssProcessComplete);

  EGainsReportException = class(Exception);

  TActiveDataType = (adNone, adShortTerm, adLongTerm);
  TActiveDeferralDataType = (addNone, addShortLong, addIRA);

  TGainsReportData = class
  private
    FLTSectionBState: TSectionState;
    FLTSectionCState: TSectionState;
    FLTSectionAState: TSectionState;
    FSTSectionBState: TSectionState;
    FSTSectionCState: TSectionState;
    FSTSectionAState: TSectionState;
    FLTData: TTglReportArray;
    FSTSales: Extended;
    FLTCostBasis: Extended;
    FBlankRows: Boolean;
    FSTPAndL: Extended;
    FLTSales: Extended;
    FSTAdjustment: Extended;
    FSTData: TTglReportArray;
    FSTCostBasis: Extended;
    FLTPAndL: Extended;
    FSTDeferrals: Extended;
    FLTDeferrals: Extended;
    FLTAdjustment: Extended;
    FHasLongTerm: Boolean;
    FHasShortTerm: Boolean;
    FSTRecordCount: Integer;
    FLTRecordCount: Integer;
    FCostAdjustment: Boolean;
    FIncludeCostAdjustment: Boolean;
    FSTLoss: Extended;
    FSTGain: Extended;
    FLTLoss: Extended;
    FLTGain: Extended;
    FSTWSLostToIra: Extended;
    FLTWSLostToIra: Extended;
    FActiveDataType : TActiveDataType;
    FActiveDeferralDataType : TActiveDeferralDataType;
    FSTDeferralData: TTDeferralsReportArray;
    FLTDeferralData: TTDeferralsReportArray;
    FIRADeferralData: TTDeferralsReportArray;
    FSTJanDeferrals: Extended;
    FSTOpenDeferrals: Extended;
    FLTJanDeferrals: Extended;
    FLTOpenDeferrals: Extended;
    FIRAJanDeferrals: Extended;
    FIRAOpenDeferrals: Extended;
    FSTActualGL: Extended;
    FLTActualGL: Extended;
    FSTGainMay5: Extended;
    FLTGainMay5: Extended;
    function GetTotalAdjustment: Extended;
    function GetTotalDeferrals: Extended;

    procedure SetLTData(const Value: TTglReportArray);
    procedure SetSTData(const Value: TTglReportArray);

    function GetTotalCostBasis: Extended;
    function GetTotalSales: Extended;
    function GetTotalPAndL: Extended;
    function GetLTSalesCost: String;
    function GetSTSalesCost: String;
    function GetTotalSalesCost: String;
    function GetClipBoardColumnHeader: String;
    function GetLongTermPageHeader(box: char): String;
    function GetShortTermPageHeader(box: char): String;
    function GetForm8949ReportHeader: String;
    function GetTotalWSLostToIra: Extended;
    function GetActiveData: TTglReportArray;
    function GetActiveDeferralData: TTDeferralsReportArray;
    procedure SetLTDeferralData(const Value: TTDeferralsReportArray);
    procedure SetSTDeferralData(const Value: TTDeferralsReportArray);
    function GetActiveJanDeferredTotal: Extended;
    function GetActiveOpenDeferredTotal: Extended;
    procedure SetIRADeferralData(const Value: TTDeferralsReportArray);
    function GetTotalActualGL: Extended;
    function GetGainMay5Total: Extended;
    function GetIRSD1ReportHeader: String;
  public
    constructor Create;
    property STAdjustment : Extended Read FSTAdjustment write FSTAdjustment;
    property LTAdjustment  : Extended Read FLTAdjustment write FLTAdjustment;
    property TotalAdjustment  : Extended Read GetTotalAdjustment;
    property STDeferrals  : Extended read FSTDeferrals write FSTDeferrals;
    property STOpenDeferrals : Extended read FSTOpenDeferrals;
    property STJanDeferrals : Extended read FSTJanDeferrals;
    property LTOpenDeferrals : Extended read FLTOpenDeferrals;
    property LTJanDeferrals : Extended read FLTJanDeferrals;
    property IRAJanDeferrals : Extended read FIRAJanDeferrals;
    property IRAOpenDeferrals : Extended read FIRAOpenDeferrals;
    property LTDeferrals  : Extended read FLTDeferrals write FLTDeferrals;
    property TotalDeferrals : Extended read GetTotalDeferrals;
    property STWSLostToIra : Extended read FSTWSLostToIra write FSTWSLostToIra;
    property LTWSLostToIra : Extended read FLTWSLostToIra write FLTWSLostToIra;
    property TotalWSLostToIra : Extended read GetTotalWSLostToIra;
    property STActualGL : Extended read FSTActualGL write FSTActualGL;
    property LTActualGL : Extended read FLTActualGL write FLTActualGL;
    property TotalActualGL : Extended read GetTotalActualGL;
    property STPAndL  : Extended read FSTPAndL write FSTPAndL;
    property LTPAndL : Extended read FLTPAndL write FLTPAndL;
    property TotalPAndL : Extended read GetTotalPAndL;
    property STSales  : Extended read FSTSales write FSTSales;
    property LTSales  : Extended read FLTSales write FLTSales;
    property TotalSales  : Extended read GetTotalSales;
    property STCostBasis  : Extended read FSTCostBasis write FSTCostBasis;
    property LTCostBasis  : Extended read FLTCostBasis write FLTCostBasis;
    property TotalCostBasis  : Extended read GetTotalCostBasis;
    property STGainMay5 : Extended read FSTGainMay5 write FSTGainMay5;
    property LTGainMay5 : Extended read FLTGainMay5 write FLTGainMay5;
    property GainMay5Total : Extended read GetGainMay5Total;
    property STLoss : Extended read FSTLoss write FSTLoss;
    property LTLoss : Extended read FLTLoss write FLTLoss;
    property STGain : Extended read FSTGain write FSTGain;
    property LTGain : Extended read FLTGain write FLTGain;

    property STData : TTglReportArray read FSTDAta write SetSTData;
    property LTData : TTglReportArray read FLTData Write SetLTData;
    property STDeferralData : TTDeferralsReportArray read FSTDeferralData write SetSTDeferralData;
    property LTDeferralData : TTDeferralsReportArray read FLTDeferralData write SetLTDeferralData;
    property IRADeferralData : TTDeferralsReportArray read FIRADeferralData write SetIRADeferralData;
    property ActiveData : TTglReportArray read GetActiveData;
    property ActiveDeferralData : TTDeferralsReportArray read GetActiveDeferralData;
    property ActiveOpenDeferredTotal : Extended read GetActiveOpenDeferredTotal;
    property ActiveJanDeferredTotal : Extended read GetActiveJanDeferredTotal;
    property ActiveDataType : TActiveDataType read FActiveDatatype write FActiveDataType;
    property ActiveDeferralDataType : TActiveDeferralDataType read FActiveDeferralDataType write FActiveDeferralDataType;
    property STSectionAState : TSectionState read FSTSectionAState write FSTSectionAState;
    property STSectionBState : TSectionState read FSTSectionBState write FSTSectionBState;
    property STSectionCState : TSectionState read FSTSectionCState write FSTSectionCState;
    property LTSectionAState : TSectionState read FLTSectionAState write FLTSectionAState;
    property LTSectionBState : TSectionState read FLTSectionBState write FLTSectionBState;
    property LTSectionCState : TSectionState read FLTSectionCState write FLTSectionCState;
    property BlankRows : Boolean read FBlankRows write FBlankRows;
    property HasShortTerm : Boolean read FHasShortTerm write FHasShortTerm;
    property HasLongTerm : Boolean read FHasLongTerm write FHasLongTerm;
    property STSalesCost : String read GetSTSalesCost;
    property LTSalesCost : String read GetLTSalesCost;
    property TotalSalesCost : String read GetTotalSalesCost;
    property STRecordCount : Integer read FSTRecordCount write FSTRecordcount;
    property LTRecordCount : Integer read FLTRecordCount write FLTRecordcount;
    property ClipBoardColumnHeader : String read GetClipBoardColumnHeader;
    property ShortTermPageHeader[box : char] : String read GetShortTermPageHeader;
    property LongTermPageHeader[box : char] : String read GetLongTermPageHeader;
    property Form8949ReportHeader : String read GetForm8949ReportHeader;
    property IRSD1ReportHeader : String read GetIRSD1ReportHeader;
    property CostAdjustment : Boolean read FCostAdjustment;
    property IncludeCostAdjustment : Boolean read FIncludeCostAdjustment write FIncludeCostAdjustment;
    //
    procedure SumLTData; // (const Value: TTglReportArray); // 2025-08-14
    procedure SumSTData; // (const Value: TTglReportArray); // 2025-08-14
    //
  end;

var
  bNew8949 : boolean;
  gSTsalesA, gSTcostA, gSTadjA, gSTprofA, gLTsalesA, gLTcostA, gLTadjA, gLTprofA : double;
  gSTsalesB, gSTcostB, gSTadjB, gSTprofB, gLTsalesB, gLTcostB, gLTadjB, gLTprofB : double;
  gSTsalesC, gSTcostC, gSTadjC, gSTprofC, gLTsalesC, gLTcostC, gLTadjC, gLTprofC : double;

implementation

uses TLSettings, TLRegister, StrUtils, Import, RecordClasses, TLFile, TLCommonLib;

{ TData8949Rpt }

constructor TGainsReportData.Create;
begin
  FSTData := nil;
  FLTData := nil;
  FHasShortTerm := False;
  FHasLongTerm := False;
  FSTSales := 0;
  FLTSales := 0;
  FSTCostBasis := 0;
  FLTCostBasis := 0;
  FSTPAndL := 0;
  FLTPAndL := 0;
  FSTAdjustment := 0;
  FLTAdjustment := 0;
  FSTDeferrals := 0;
  FLTDeferrals := 0;
  FSTSectionAState := ssNone;
  FSTSectionBState := ssNone;
  FSTSectionCState := ssNone;
  FLTSectionAState := ssNone;
  FLTSectionBState := ssNone;
  FLTSectionCState := ssNone;
  FBlankRows := False;
  FSTRecordCount := 0;
  FLTRecordCount := 0;
  FCostAdjustment := False;
  FIncludeCostAdjustment := True;
  FActiveDataType := adNone;
  FSTOpenDeferrals := 0;
  FSTJanDeferrals := 0;
  FLTOpenDeferrals := 0;
  FLTJanDeferrals := 0;
  FIraJanDeferrals := 0;
  FIRAOpenDeferrals := 0;
  SetLength(FIraDeferralData, 0);
  SetLength(FSTDeferralData, 0);
  SetLength(FLTDeferralData, 0);
end;

function TGainsReportData.GetActiveData: TTglReportArray;
begin
  Result := nil;
  if FActiveDataType = adShortTerm then
    Result := StData
  else if FactiveDataType = adLongTerm then
    Result := LTData;
end;

function TGainsReportData.GetActiveDeferralData : TTDeferralsReportArray;
var
  I : Integer;
  J : Integer;
  Found : Boolean;
begin
  SetLength(Result, 0);
  if FActiveDeferralDataType = addShortLong then begin
    if high(STDeferralData) <> -1 then
      Result := Copy(STDeferralData, 0, Length(STDeferralData));
    if high(LTDeferralData) <> -1 then begin
      if Length(Result) > 0 then begin
        for I := 0 to high(LTDeferralData) do begin
          Found := False;
          for J := 0 to high(Result) do begin
            if ( //
              (Length(Result[J].OpenDesc) > 0) //
              and (Result[J].OpenDesc = LTDeferralData[I].OpenDesc) //
            ) //
            or ( //
              (Length(Result[J].JanDesc) > 0) //
              and (Result[J].JanDesc = LTDeferralData[I].JanDesc) //
            )
            then begin // combine them
              Result[J].OpenAmt := Result[J].OpenAmt + LTDeferralData[I].OpenAmt;
              Result[J].JanAmt := Result[J].JanAmt + LTDeferralData[I].JanAmt;
              Found := True;
              Break;
            end
          end;
          if not Found then begin
            SetLength(Result, Length(Result) + 1);
            Result[high(Result)] := LTDeferralData[I];
          end;
        end;
      end
      else
        Result := Copy(LTDeferralData, 0, Length(LTDeferralData));
    end;
  end
  else if FActiveDeferralDataType = addIRA then
    Result := IRADeferralData;
end;

function TGainsReportData.GetActiveJanDeferredTotal: Extended;
begin
  Result := 0;
  if ActiveDeferralDataType = addShortLong then
    Result := STJanDeferrals + LTJanDeferrals
  else if ActiveDeferralDataType = addIra then
    Result := IRAJanDeferrals;
end;

function TGainsReportData.GetActiveOpenDeferredTotal: Extended;
begin
  Result := 0;
  if ActiveDeferralDataType = addShortLong then
    Result := STOpenDeferrals + LTOpenDeferrals
  else if ActiveDeferralDataType = addIRA then
    Result := IRAOpenDeferrals;
end;

function TGainsReportData.GetClipBoardColumnHeader: String;
begin
  if TradeLogFile.TaxYear = 2011 then
    Result := '(a) Description Of Property' + TAB + '(b) Code' + Tab //
      + '(c) Date Acquired' + Tab + '(d) Date Sold' + Tab //
      + '(e) Sales Price' + Tab + '(f) Cost or Other Basis' + Tab + '(g) Adjustments to Gain or Loss'
  else if (TradeLogFile.TaxYear > 2011) then
    Result := '(a) Description Of Property' + TAB + '(b) Date Acquired' + Tab + '(c) Date Sold' + Tab //
      + '(d) Sales Price' + Tab + '(e) Cost or Other Basis' + Tab + '(f) Code' + Tab //
      + '(g) Adjustments to Gain or Loss' + Tab + '(h) Gain or Loss'
  else
    Result := '(a) Description Of Property' + TAB + '(b) Date Acquired' + Tab + '(c) Date Sold' + Tab //
      + '(d) Sales Price' + Tab + '(e) Cost or Other Basis' + Tab + '(f) Gain or Loss';
  if TradeLogFile.TaxYear = 2003 then
    Result := Result + TAB + '(g) Post-May 5 gain or (loss)';
end;

function TGainsReportData.GetForm8949ReportHeader: String;
begin
  Result := 'Form 8949 - Sales and Other Dispositions of Capital Assets';
end;

function TGainsReportData.GetGainMay5Total: Extended;
begin
  Result := 0;
  case FActiveDataType of
    adNone: Result := STGainMay5 + LTGainMay5;
    adShortTerm: Result := STGainMay5;
    adLongTerm: Result := LTGainMay5;
  end;
end;

function TGainsReportData.GetIRSD1ReportHeader: String;
begin
  Result := 'Schedule D-1 (Form 1040) - Sales and Other Dispositions of Capital Assets';
end;

function TGainsReportData.GetLongTermPageHeader(box: char): String;
begin
  if box = ' ' then
    Result := 'Long-Term Gains and Losses:'
  else
    Result := 'Long-Term Capital Gains and Losses - Box ' + box + ' Checked';
end;


function TGainsReportData.GetLTSalesCost: String;
begin
  if rndto5(FLTPAndL-(FLTSales - FSTCostBasis)) = 0 then
    Result := 'OK'
  else
    Result  := CurrStrEx(FLTPAndL - (FLTSales - FLTCostBasis), Settings.UserFmt);
end;

function TGainsReportData.GetShortTermPageHeader(box: char): String;
begin
  if box = ' ' then
    Result := 'Short-Term Gains and Losses:'
  else
    Result := 'Short-Term Capital Gains and Losses - Box ' + box + ' Checked';
end;


function TGainsReportData.GetSTSalesCost: String;
begin
  if rndto5(FSTPAndL-(FSTSales-FSTCostBasis)) = 0 then
    Result := 'OK'
  else
    Result := CurrStrEx(FSTPAndL - (FSTSales - FSTCostBasis), Settings.UserFmt);
end;

function TGainsReportData.GetTotalActualGL: Extended;
begin
  Result := 0;
  case FActiveDataType of
    adNone: Result := STActualGL + LTActualGL;
    adShortTerm: Result := STActualGL;
    adLongTerm: Result := LTActualGL;
  end;
end;

function TGainsReportData.GetTotalAdjustment: Extended;
begin
  Result := 0;
  case FActiveDataType of
    adNone: Result := STAdjustment + LTAdjustment;
    adShortTerm: Result := STAdjustment;
    adLongTerm: Result := LTAdjustment;
  end;
end;

function TGainsReportData.GetTotalCostBasis: Extended;
begin
  Result := 0;
  case FActiveDataType of
    adNone: Result := STCostBasis + LTCostBasis;
    adShortTerm: Result := STCostBasis;
    adLongTerm: Result := LTCostBasis;
  end;
end;

function TGainsReportData.GetTotalDeferrals: Extended;
begin
  Result := 0;
  case FActiveDataType of
    adNone: Result := STDeferrals + LTDeferrals;
    adShortTerm: Result := STDeferrals;
    adLongTerm: Result := LTDeferrals;
  end;
end;

function TGainsReportData.GetTotalPAndL: Extended;
begin
  Result := 0;
  case FActiveDataType of
    adNone: Result := LTPAndL + STPAndL;
    adShortTerm: Result :=STPAndL;
    adLongTerm: Result := LTPAndL;
  end;
end;

function TGainsReportData.GetTotalSales: Extended;
begin
  Result := 0;
  case FActiveDataType of
    adNone: Result := STSales + LTSales;
    adShortTerm: Result := STSales;
    adLongTerm: Result := LTSales;
  end;
end;

function TGainsReportData.GetTotalSalesCost: String;
begin
  if rndto5(GetTotalPAndL - (GetTotalSales - GetTotalCostBasis)) = 0 then
    Result := 'OK'
  else
    Result := CurrStrEx(GetTotalPAndL - (GetTotalSales - GetTotalCostBasis), Settings.UserFmt);
end;


function TGainsReportData.GetTotalWSLostToIra: Extended;
begin
  Result := 0;
  case FActiveDataType of
    adNone: Result := FSTWSLostToIra + FLTWSLostToIra;
    adShortTerm: Result := FSTWSLostToIra;
    adLongTerm: Result := FLTWSLostToIra;
  end;
end;


procedure TGainsReportData.SetIRADeferralData(const Value: TTDeferralsReportArray);
  var
  I : Integer;
begin
  if Value <> nil then begin
    FIRADeferralData := Value;
    FIRAOpenDeferrals := 0;
    FIRAJanDeferrals := 0;
    for I := Low(FIRADeferralData) to High(FIRADeferralData) do begin
      FIRAOpenDeferrals := FIRAOpenDeferrals + FIRADeferralData[I].OpenAmt;
      FIRAJanDeferrals := FIRAJanDeferrals + FIRADeferralData[I].JanAmt;
    end;
  end;
end;


procedure TGainsReportData.SumLTData; // (const Value : TTglReportArray);
var
  I : Integer;
  Cost1099 : string;
begin
  // init A
  gLTsalesA := 0;
  gLTcostA := 0;
  gLTadjA := 0;
  gLTprofA := 0;
  // init B
  gLTsalesB := 0;
  gLTcostB := 0;
  gLTadjB := 0;
  gLTprofB := 0;
  // init C
  gLTsalesC := 0;
  gLTcostC := 0;
  gLTadjC := 0;
  gLTprofC := 0;
  // Setup Section Variables.
  for I := 0 to Length(FLTData) - 1 do begin
    case FLTData[I].abc[1] of
    'A' : begin
        gLTsalesA := gLTsalesA + FLTData[I].sales; // A
        gLTcostA := gLTcostA + FLTData[I].cs;
        gLTadjA := gLTadjA + FLTData[I].adjG;
        gLTprofA := gLTprofA + FLTData[I].pl;
      end;
    'B' : begin
        gLTsalesB := gLTsalesB + FLTData[I].sales; // B
        gLTcostB := gLTcostB + FLTData[I].cs;
        gLTadjB := gLTadjB + FLTData[I].adjG;
        gLTprofB := gLTprofB + FLTData[I].pl;
      end;
    'C' : begin
        gLTsalesC := gLTsalesC + FLTData[I].sales; // C
        gLTcostC := gLTcostC + FLTData[I].cs;
        gLTadjC := gLTadjC + FLTData[I].adjG;
        gLTprofC := gLTprofC + FLTData[I].pl;
      end;
    'D' : begin
        gLTsalesA := gLTsalesA + FLTData[I].sales; // D
        gLTcostA := gLTcostA + FLTData[I].cs;
        gLTadjA := gLTadjA + FLTData[I].adjG;
        gLTprofA := gLTprofA + FLTData[I].pl;
      end;
    'E' : begin
        gLTsalesB := gLTsalesB + FLTData[I].sales; // E
        gLTcostB := gLTcostB + FLTData[I].cs;
        gLTadjB := gLTadjB + FLTData[I].adjG;
        gLTprofB := gLTprofB + FLTData[I].pl;
      end;
    'F' : begin
        gLTsalesC := gLTsalesC + FLTData[I].sales; // F
        gLTcostC := gLTcostC + FLTData[I].cs;
        gLTadjC := gLTadjC + FLTData[I].adjG;
        gLTprofC := gLTprofC + FLTData[I].pl;
      end;
    end;
  end;
end;

procedure TGainsReportData.SetLTData(const Value: TTglReportArray);
var
  I : Integer;
  CostA : Extended;
  Cost1099 : String;
begin
  FLTData := Value;
  CostA := 0;
  //Setup Section Variables.
  for I := 0 to Length(FLTData) - 1 do
  begin
    case FLTData[I].abc[1] of
      'A' : begin
              FLTSectionAState := ssHasRecords;
              CostA := CostA + FLTData[I].cs;
            end;
      'B' : FLTSectionBState := ssHasRecords;
      'C' : FLTSectionCState := ssHasRecords;
      'D' : begin
              FLTSectionAState := ssHasRecords;
              CostA := CostA + FLTData[I].cs;
            end;
      'E' : FLTSectionBState := ssHasRecords;
      'F' : FLTSectionCState := ssHasRecords;
    end;
  end;
  if TradeLogFile.CurrentBrokerID = 0 then
    Cost1099 := TradeLogFile.CostBasis1099LTAllBrokers
  else
    Cost1099 := TradeLogFile.CurrentAccount.CostBasis1099LT;
  // Setup Long Term A Adjustment Line if necessary
  if (Length(Cost1099) > 0)
  and (Trunc(abs(CostA - StrToFloat(Cost1099))) > 0)
  and (IncludeCostAdjustment) then begin
    I := Length(FLTData);
    SetLength(FLTData, I + 1);
    FillChar(FLTData[I], SizeOf(FLTData[I]), 0);
    FLTData[I].desc := 'Adj. to reconcile difference with 1099-B';
    FLTData[I].cs := StrToFloat(Cost1099) - CostA;
    FLTData[I].abc := 'A';
    FLTData[I].code := 'B';
    FLTData[I].adjG := FLTData[I].cs;
    FCostAdjustment := True;
    FLTSectionAState := ssHasRecords;
    FLTCostBasis := FLTCostBasis + FLTData[I].cs;
    FLTAdjustment := FLTAdjustment + FLTData[I].cs;
    FLTPAndL := FLTPAndL - FLTData[I].cs;
  end;
end;


procedure TGainsReportData.SetLTDeferralData(const Value: TTDeferralsReportArray);
var
  I : Integer;
begin
  if Value <> nil then begin
    FLTDeferralData := Value;
    FLTOpenDeferrals := 0;
    FLTJanDeferrals := 0;
    for I := Low(FLTDeferralData) to High(FLTDeferralData) do begin
      FLTOpenDeferrals := FLTOpenDeferrals + FLTDeferralData[I].OpenAmt;
      FLTJanDeferrals := FLTJanDeferrals + FLTDeferralData[I].JanAmt;
    end;
  end;
end;


procedure TGainsReportData.SumSTData; // (const Value : TTglReportArray);
var
  I : Integer;
  Cost1099 : string;
begin
  // init A
  gSTsalesA := 0;
  gSTcostA := 0;
  gSTadjA := 0;
  gSTprofA := 0;
  // init B
  gSTsalesB := 0;
  gSTcostB := 0;
  gSTadjB := 0;
  gSTprofB := 0;
  // init C
  gSTsalesC := 0;
  gSTcostC := 0;
  gSTadjC := 0;
  gSTprofC := 0;
  // Setup Section Variables.
  for I := 0 to Length(FSTData) - 1 do begin
    case FSTData[I].abc[1] of
    'A' : begin
        gSTsalesA := gSTsalesA + FSTData[I].sales; // A
        gSTcostA := gSTcostA + FSTData[I].cs;
        gSTadjA := gSTadjA + FSTData[I].adjG;
        gSTprofA := gSTprofA + FSTData[I].pl;
      end;
    'B' : begin
        gSTsalesB := gSTsalesB + FSTData[I].sales; // B
        gSTcostB := gSTcostB + FSTData[I].cs;
        gSTadjB := gSTadjB + FSTData[I].adjG;
        gSTprofB := gSTprofB + FSTData[I].pl;
      end;
    'C' : begin
        gSTsalesC := gSTsalesC + FSTData[I].sales; // C
        gSTcostC := gSTcostC + FSTData[I].cs;
        gSTadjC := gSTadjC + FSTData[I].adjG;
        gSTprofC := gSTprofC + FSTData[I].pl;
      end;
    'D' : begin
        gSTsalesA := gSTsalesA + FSTData[I].sales; // D
        gSTcostA := gSTcostA + FSTData[I].cs;
        gSTadjA := gSTadjA + FSTData[I].adjG;
        gSTprofA := gSTprofA + FSTData[I].pl;
      end;
    'E' : begin
        gSTsalesB := gSTsalesB + FSTData[I].sales; // E
        gSTcostB := gSTcostB + FSTData[I].cs;
        gSTadjB := gSTadjB + FSTData[I].adjG;
        gSTprofB := gSTprofB + FSTData[I].pl;
      end;
    'F' : begin
        gSTsalesC := gSTsalesC + FSTData[I].sales; // F
        gSTcostC := gSTcostC + FSTData[I].cs;
        gSTadjC := gSTadjC + FSTData[I].adjG;
        gSTprofC := gSTprofC + FSTData[I].pl;
      end;
    end;
  end;
end;


procedure TGainsReportData.SetSTData(const Value: TTglReportArray);
var
  I : Integer;
  CostA : Extended;
  Cost1099 : String;
begin
  FSTData := Value;
  CostA := 0;
  //Setup Section Variables.
  for I := 0 to Length(FSTData) - 1 do begin
    case FSTDAta[I].abc[1] of
      'A' : begin
              FSTSectionAState := ssHasRecords;
              CostA := CostA + FSTData[I].cs;
            end;
      'B' : FSTSectionBState := ssHasRecords;
      'C' : FSTSectionCState := ssHasRecords;
    end;
  end;
  if TradeLogFile.CurrentBrokerID = 0 then
    Cost1099 := TradeLogFile.CostBasis1099STAllBrokers
  else
    Cost1099 := TradeLogFile.CurrentAccount.CostBasis1099ST;
  //Create Short Term A Adjustment line if necessary.
  if (Length(Cost1099) > 0) //
  and (Trunc(abs(CostA - StrToFloat(Cost1099))) > 0) //
  and (IncludeCostAdjustment) then begin
    I := Length(FSTData);
    SetLength(FSTData, I + 1);
    FillChar(FSTData[I], SizeOf(FSTData[I]), 0);
    FSTData[I].desc := 'Adj. to reconcile difference with 1099-B';
    FSTData[I].cs := StrToFloat(Cost1099) - CostA;
    FSTData[I].abc := 'A';
    FSTData[I].code := 'B';
    FSTData[I].adjG := FSTData[I].cs;
    FCostAdjustment := True;
    FSTSectionAState := ssHasRecords;
    FSTCostBasis := FSTCostBasis + FSTData[I].cs;
    FSTAdjustment := FSTAdjustment + FSTData[I].cs;
    FSTPAndL := FSTPAndL - FSTData[I].cs;
  end;
end;


procedure TGainsReportData.SetSTDeferralData(const Value: TTDeferralsReportArray);
var
  I : Integer;
begin
  if Value <> nil then begin
    FSTDeferralData := Value;
    FSTOpenDeferrals := 0;
    FSTJanDeferrals := 0;
    for I := Low(FSTDeferralData) to High(FSTDeferralData) do begin
      FSTOpenDeferrals := FSTOpenDeferrals + FSTDeferralData[I].OpenAmt;
      FSTJanDeferrals := FSTJanDeferrals + FSTDeferralData[I].JanAmt;
    end;
  end;
end;


end.
