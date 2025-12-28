unit FastReportsPreview;

(*
  Steps for creating new reports:
  1. Add new Report component and Datasource component to the form.
   Attach datasource component to the report component via Dataset Property.
  2. In the Datasource properties set the Fields property
   with the names of the fields for the dataset.
  3. Code the onGetValue event of the dataset property to return data for each field.
   See the dsPerformance.OnGetValue method for an example.
  4. Code the onFirst, onCheckEOF methods of the dataset,
   or if there are a fixed number of records you can set the RangeEnd property to reCount
   and then RangeEndCount property to the number of records you expect.
   See the dsPerformance dataset for an example of this.
  5. Double click the new report component and in the designer design your report
  6. Add a public method to the form and set any custom parameters
   or do any custom processing here before running the report.
   See the RunPerformanceReport method for an example.
  7. As the last line of your public method call the DoReport method
   with your report component as the parameter value.
*)

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, frxClass, StdCtrls, frxPreview, frxExportPDF, frxUnicodeUtils, frxUtils,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, DB, cxDBData,
  cxTextEdit, Menus, cxButtons, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxClasses, cxGridCustomView, cxGrid,
  ComCtrls, Buttons, ExtCtrls, ToolWin, ImgList, ActnList, pbmarquee, ClipBrd,
  frxChBox, FuncProc, cxNavigator, cxContainer, dxGDIPlusClasses, cxImage,
  System.Actions, GainsLosses, cxGridDBTableView, RzPrgres, cxProgressBar, dxSkinsCore,
  dxSkinHighContrast, dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinscxPCPainter, dxSkinBasic, dxSkinMetropolis, dxSkinMetropolisDark,
  dxSkinOffice2013DarkGray, dxSkinOffice2013LightGray, dxSkinOffice2013White,
  dxSkinOffice2016Colorful, dxSkinOffice2016Dark, dxSkinOffice2019Black,
  dxSkinOffice2019Colorful, dxSkinOffice2019DarkGray, dxSkinOffice2019White,
  dxSkinTheBezier, dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light, dxDateRanges, dxScrollbarAnnotations,
  System.ImageList, frxExportBaseDialog;

type
  TfrmFastReports = class(TForm)
    pnlMain: TPanel;
    frxPDFExport1: TfrxPDFExport;
    MainMenu1: TMainMenu;
    mnuFile: TMenuItem;
    mnuFileCopy: TMenuItem;
    mnuFileSavePDF: TMenuItem;
    N4: TMenuItem;
    mnuFileExit: TMenuItem;
    mnuPage: TMenuItem;
    mnuPageFirst: TMenuItem;
    mnuPagePrevious: TMenuItem;
    mnuPageNext: TMenuItem;
    mnuPageLast: TMenuItem;
    N2: TMenuItem;
    mnuPageGoto: TMenuItem;
    mnuPrint: TMenuItem;
    Print1: TMenuItem;
    mnuZoom: TMenuItem;
    mnuZoomIn: TMenuItem;
    mnuZoomOut: TMenuItem;
    N3: TMenuItem;
    mnuZoomFitPage: TMenuItem;
    mnuZoomMultiplePages: TMenuItem;
    mnuZoomFitWidth: TMenuItem;
    ActionList1: TActionList;
    actnFile_Print: TAction;
    actnFile_SaveToPDF: TAction;
    actnFile_Exit: TAction;
    actnPage_First: TAction;
    actnPage_Next: TAction;
    actnPage_Previous: TAction;
    actnPage_Last: TAction;
    actnZoom_In: TAction;
    actnZoom_Out: TAction;
    actnZoom_PageWidth: TAction;
    actnZoom_Page100: TAction;
    actnZoom_Page: TAction;
    actnFile_Copy: TAction;
    tbImages: TImageList;
    PopupMenu1: TPopupMenu;
    mnuPopZoomIn: TMenuItem;
    mnuPopZoomOut: TMenuItem;
    tlBarPreview: TToolBar;
    tlbtnZoomIn: TToolButton;
    tlbtnZoomOut: TToolButton;
    tlbtnFitPage: TToolButton;
    tlbtnFit100: TToolButton;
    tlbtnFitWidth: TToolButton;
    txtZoomEdit: TEdit;
    tlbtnPageFirst: TToolButton;
    tlBtnPagePrev: TToolButton;
    tlbtnPageNext: TToolButton;
    tlbtnPageLast: TToolButton;
    txtPageEdit: TEdit;
    sep2: TToolButton;
    tlbtnPrint: TToolButton;
    sep3: TToolButton;
    spdCopy: TToolButton;
    sep4: TToolButton;
    spdPDF: TToolButton;
    sep7: TToolButton;
    spdExit: TToolButton;
    pnlTotals: TPanel;
    cxGridRptTot: TcxGrid;
    cxGridRptTotTableView: TcxGridDBTableView;
    STLT: TcxGridDBColumn;
    colSales: TcxGridDBColumn;
    colCost: TcxGridDBColumn;
    colPL: TcxGridDBColumn;
    colWS: TcxGridDBColumn;
    colPLactual: TcxGridDBColumn;
    colSpace: TcxGridDBColumn;
    cxGridRptTotLevel1: TcxGridLevel;
    pnlHide: TPanel;
    lblTotals: TLabel;
    Preview: TfrxPreview;
    tlbtnPageSettings: TToolButton;
    PrinterSettings1: TMenuItem;
    actnPrint_Settings: TAction;
    PrintDialog1: TPrintDialog;
    frxCheckBoxObject1: TfrxCheckBoxObject;
    cxStyleRepository1: TcxStyleRepository;
    cxStyle1: TcxStyle;
    cxStyleRepository2: TcxStyleRepository;
    cxStyle2: TcxStyle;
    pnlRptTotHide: TPanel;
    btnHide: TcxButton;
    btnHelp: TcxButton;
    colAdjG: TcxGridDBColumn;
    btnTurboTax: TToolButton;
    sep5: TToolButton;
    btnTaxAct: TToolButton;
    actnExport_TurboTax: TAction;
    actnExport_TaxACT: TAction;
    mnuExports: TMenuItem;
    mnuTurboTax: TMenuItem;
    mnuTaxAct: TMenuItem;
    sep6: TToolButton;
    colWSIRa: TcxGridDBColumn;
    imDraftBackground: TcxImage;
    pnlWarning: TPanel;
    lbl1: TLabel;
    lblCheckListMessage: TLabel;
    lblEndTaxYrMessage: TLabel;
    ImageList1: TImageList;
    Label2: TLabel;
    pnlGotoPage: TPanel;
    pnlPageOf: TPanel;
    lblGotoPage: TLabel;
    lblOfPage: TLabel;
    pnlZoom: TPanel;
    lblZoom: TLabel;
    pnlPerc: TPanel;
    lblPerc: TLabel;
    pnlHelp: TPanel;
    btnYECHelp: TcxButton;
    pnlStatus: TPanel;
    pnlReportTime: TPanel;
    progrBar: TcxProgressBar;
    procedure FormShow(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btnHideClick(Sender: TObject);
    procedure actnZoom_InExecute(Sender: TObject);
    procedure actnZoom_OutExecute(Sender: TObject);
    procedure actnZoom_PageWidthExecute(Sender: TObject);
    procedure actnZoom_Page100Execute(Sender: TObject);
    procedure actnZoom_PageExecute(Sender: TObject);
    procedure txtZoomEditExit(Sender: TObject);
    procedure txtZoomEditKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure actnPage_FirstExecute(Sender: TObject);
    procedure actnPage_NextExecute(Sender: TObject);
    procedure actnPage_PreviousExecute(Sender: TObject);
    procedure actnPage_LastExecute(Sender: TObject);
    procedure txtPageEditKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure txtPageEditExit(Sender: TObject);
    procedure PreviewPageChanged(Sender: TfrxPreview; PageNo: Integer);
    procedure actnFile_ExitExecute(Sender: TObject);
    procedure actnFile_CopyExecute(Sender: TObject);
    procedure actnFile_PrintExecute(Sender: TObject);
    procedure actnFile_SaveToPDFExecute(Sender: TObject);
    procedure actnPrint_SettingsExecute(Sender: TObject);
    procedure PrintDialog1Show(Sender: TObject);
    procedure cxGridRptTotTableViewCustomDrawCell(
      Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
      AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
    procedure actnExport_TurboTaxExecute(Sender: TObject);
    procedure actnExport_TaxACTExecute(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnYECHelpClick(Sender: TObject);
//    procedure StatusBarDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect);
    procedure PrintRptToPDF(sFileName : string);
  private
    { Private declarations }
    FAllowMarginAdjustment : Boolean;
    FCloseAction : Integer;
    FForceQuickStart : Boolean;
    FReportDone : Boolean;
    FMsgShown : Boolean;
    procedure UpdateText;
    procedure UpdateStatus;
    procedure SetupInitialPageValues;
    procedure SetupStandardVariables;
//    procedure disableButtons;
    procedure enableButtons;
  public
    { Public declarations }
     //Some reports should not be affected by margin adjustment such as IRS Forms.
    //Set this to false to supress margin adjustment based on Report Paqe settings or true
    //to allow the user to control margins in the Page Setup Dialog.
    property AllowMarginAdjustment : Boolean read FAllowMarginAdjustment write FAllowMarginAdjustment default false;
    procedure SetupTotalsPanel(Visible : Boolean);
    procedure SetupExports(Visible : Boolean);
    procedure DoReport(Report : TFrxReport);
    procedure ReportComplete;
  end;


var
  frmFastReports: TfrmFastReports;
  startTime : TTime;
  RowsPerPage : integer;
  bDraft : boolean;

implementation

{$R *.dfm}

uses Main, frmPageSetupDlg, Printers, TLSettings, TLRegister, TLUpdate,
     StrUtils, Reports, FastReportsData, TLFile, RecordClasses, TLCommonlib,
     GlobalVariables, frmSSNEIN;


//function getLoadTime(startTime:TDateTime):string;
//var
//  hour, min, sec, msec : word;
//  loadTime : TDateTime;
//  loadTimeStr : String;
//begin
//  //calc file open time
//  if startTime=0 then  begin
//    result := '';
//    exit;
//  end;
//  loadTime := time - startTime;
//  decodeTime(loadTime, hour, min, sec, msec);
//  if hour=0 then
//    if min=0 then
//      if sec<10 then
//        loadTimeStr := '00:0'+ intToStr(sec)
//      else
//        loadTimeStr := '00:'+ intToStr(sec)
//    else
//    if (sec < 10) then
//      loadTimeStr := intToStr(min) +':0'+ intToStr(sec)
//    else
//      loadTimeStr := intToStr(min) +':'+ intToStr(sec)
//  else
//    loadTimeStr := intToStr(hour) +':'+ intToStr(min) +':'+ intToStr(sec);
//  result:= ' - '+loadTimeStr;
//end;


function DefaultPDFName(dtEnd : TDateTime) : string;
var
  sLName, sFName, sDraft, sMTM, MMM, YYYY, DD, sAsOf : string;
  dtEoY : tDateTime;
begin
  sFName := ProHeader.taxFile; // eg. 2024 Mark Jones
  if pos(' ', sFName) < 1 then begin
    sLName := '';
    result := sFName + '_' + taxYear;
  end
  else begin
    sLName := ParseLast(sFName, ' ');
    result := sLName + '_' + sFName + '_' + taxYear;
  end;
  // ------------------------
  if (TradeLogFile.TaxYear > MAX_TAX_YEAR) //
  or (TradeLogFile.YearEndDone = false) then
    sDraft := 'DRAFT...';
  // ------------------------
  dtEoY := xStrToDate('12/31/' + Taxyear, settings.InternalFmt);
  if (dtEnd <> dtEoY) then begin
    YYYY := FormatDateTime('YYYY', dtEnd);
    MMM := FormatDateTime('MMM', dtEnd);
    DD := FormatDateTime('DD', dtEnd);
    sAsOf := 'as of ' + MMM + ' ' + DD;
  end
  else begin
    sAsOf := '';
  end;
  // ------------------------
  sMTM := ''; // clear first
  if (TradeLogFile.HasAccountType[atMTM] = true) //
  and (TradeLogFile.CurrentBrokerID > 0) //
  and (TradeLogFile.CurrentAccount.MTM = true) then
    sMTM := 'MTM ';
  // ------------------------
  if (ReportStyle = rptPotentialWS) then
    result := result + '_Potential WashSales' // as of [Mmm DD]'
  else if (ReportStyle = rptDateDetails) then
    result := result + '_rptDateDetails'
  else if (ReportStyle = rptTickerDetails) then
    result := result + '_rptTickerDetails'
  else if (ReportStyle = rptTickerSummary) then
    result := result + '_rptTickerSummary'

  // Cash Basis
  else if (ReportStyle = rptIRS_D1) and (taxYear > '2010') then
    result := result + '_Form8949'
  else if (ReportStyle = rptSubD1) then
    result := result + '_Taxable GL'
  else if (ReportStyle = rptWashSales) then
    result := result + '_WashSaleDetails_NOT FOR TAX FILING'
  // Sect 1256/Futures
  else if (ReportStyle = rptFutures) then
    result := result + '_6781 Report'
  // MTM
  else if (ReportStyle = rpt4797) then
    result := result + '_4797 Report'
  else if (ReportStyle = rpt481Adjust) then
    result := result + '_rpt481Adjust'
  else if (ReportStyle = rptMTM) then
    result := result + '_SecuritiesMTM'
  // Other
  else if (ReportStyle = rptGAndL) then
    result := result + '_Realized PL'

  else if (ReportStyle = rpt8949statement) then
    result := result + '_rpt8949statement'
  else if (ReportStyle = rptDeferred) then
    result := result + '_rptDeferred'
  else if (ReportStyle = rptRecon) then
    result := result + '_1099 Recon'

  else if (ReportStyle = rptCurrencies) then
    result := result + '_Currency Trades'
  else if (ReportStyle = rptPerformance) then
    result := result + '_Trade Performance'
  else if (ReportStyle = rptTradeDetails) then
    result := result + '_Trade Details'
  else if (ReportStyle = rptTradeSummary) then
    result := result + '_Trade Summary'
  else if (ReportStyle = rptHorizChart) then
    result := result + '_rptHorizChart'
  else if (ReportStyle = rptPerformance) then
    result := result + '_rptPerformance'
  else if (ReportStyle = rptVertCharts) then
    result := result + '_rptVertCharts';
  // ------------------------
//  result := sDraft + sMTM + result;
  result := sDraft + result;
  if (sAsOf <> '') then result := result + ' ' + sAsOf;
end;

procedure TfrmFastReports.actnExport_TaxACTExecute(Sender: TObject);
begin
  FForceQuickStart := True;
  FCloseAction :=  WPARAM_SHOW_QUICKSTART_82;
  LoadTradesSumGLWSunequal;
  if Not frmMain.SaveCSV then begin
    FCloseAction :=  WPARAM_SHOW_QUICKSTART_84;
    Close;
  end
  else if GainsReportData.CostAdjustment then
    mdlg('WARNING: TradeLog made either a short or long term adjustment to your form 8949. '
      + CR + 'Tax Act does not support importing of this adjustment line.' + CR
      + 'Therefore, you must enter this adjustment manually.' + CR
      + 'Please see the TradeLog User guide for step by step instructions.',
      mtWarning, [mbOK], 0);
end;


procedure TfrmFastReports.actnExport_TurboTaxExecute(Sender: TObject);
begin
  if TradeLogFile.TaxYear > 2012 then begin
    webURL(supportSiteURL + 'hc/en-us/articles/115004512594'); // 2019-01-25 MB
    if mDlg('Using a TXF file is no longer the recommended method to file your taxes with TurboTax.' + cr //
      + cr //
      + 'Please save your TradeLog Form 8949 report as PDF and use the TurboTax Form 8453 instead.' + cr //
      + cr //
      + 'If you use TXF to import into TurboTax you do so at your own risk, as TXF has many limitations.' + cr //
      + cr //
      + 'Do you understand the risks and want to create a TXF file anyway?' + cr //
      ,mtWarning, [mbYes, mbNo], 0) <> mrYes
    then begin
      exit;
    end;
  end;
  FForceQuickStart := True;
  FCloseAction :=  WPARAM_SHOW_QUICKSTART_83;
  LoadTradesSumGLWSunequal;
  if not frmMain.SaveTXF then begin
    FCloseAction :=  WPARAM_SHOW_QUICKSTART_85;
    Close;
  end
  else if GainsReportData.CostAdjustment then
    mdlg('WARNING: TradeLog made either a short or long term adjustment to your form 8949. '
      + CR + 'Turbo Tax does not support importing of this adjustment line.'
      + CR + 'Therefore, you must enter this adjustment manually.' + CR
      + 'Please see the TradeLog User guide for step by step instructions.',
      mtWarning, [mbOK], 0);
end;


procedure TfrmFastReports.actnFile_CopyExecute(Sender: TObject);
var
  i,j : integer;
  clipOK : boolean;
  s : string;
begin
  j := clipStr.count - 1;
  if j < 0 then begin
    sm('No Text Available - Nothing Copied.');
    exit;
  end;
  clipOK := false;
  Screen.Cursor := crHourGlass;
  statBar('Copying Report to Window''s Clipboard.');
  try
    Clipboard.Open;
    Clipboard.clear;
    Clipboard.AsText := clipStr.Text;
    clipOK := true;
  finally
    Clipboard.close;
    Screen.Cursor := crDefault;
    statBar('off');
  end;
  if (clipOK ) then
    sm('Report has been copied and may now be pasted.' + cr //
      + 'into any Windows text processor or spreadsheet program.')
  else
    sm('Clipboard copy did not complete!');
end;


procedure TfrmFastReports.actnFile_ExitExecute(Sender: TObject);
begin
  Close;
end;


procedure TfrmFastReports.actnFile_PrintExecute(Sender: TObject);
var
  MyHandle  : THandle;
  MyDevMode : pDevmode;
  MyDevice,
  MyDriver,
  MyPort: array [0..255] of Char;
begin
  PrintDialog1.minPage := 1;
  PrintDialog1.FromPage := 1;
  PrintDialog1.ToPage := Preview.PageCount;
  PrintDialog1.MaxPage :=Preview.PageCount;
  if PrintDialog1.Execute(Handle) then begin
    Preview.Report.PrintOptions.ShowDialog := False;
    Preview.Report.PrintOptions.Copies := PrintDialog1.Copies;
    Preview.Report.PrintOptions.Collate := PrintDialog1.Collate;
    Preview.Report.PrintOptions.PageNumbers := IntToStr(PrintDialog1.FromPage) + '-' + IntToStr(PrintDialog1.ToPage);
    Preview.Report.PrintOptions.Printer := Printer.Printers.Strings[Printer.PrinterIndex];
    Printer.GetPrinter(MyDevice,MyDriver,MyPort,MyHandle);
    MyDevMode := GlobalLock(MyHandle);
    if MyDevMode^.dmDuplex = 2 then
      Preview.Report.PrintOptions.Duplex := dmVertical
    else
      Preview.Report.PrintOptions.Duplex := dmNone;
    Preview.Print;
  end;
end;


procedure TfrmFastReports.PrintRptToPDF(sFileName : string);
begin
  frxPDFExport1.DefaultPath := Settings.ReportDir;
  frxPdfExport1.FileName := sFileName;
  frxPdfExport1.Background := (TradeLogFile.TaxYear > MAX_TAX_YEAR)
    or not TradeLogFile.YearEndDone;
  frxPdfExport1.EmbeddedFonts := true;
  Preview.Export(frxPDFExport1);
end;


procedure TfrmFastReports.actnFile_SaveToPDFExecute(Sender: TObject);
begin
  frmMain.SaveDialog.DefaultExt := 'pdf';
  frmMain.SaveDialog.InitialDir := Settings.ReportDir;
  //2014-02-03
  frmMain.SaveDialog.FileName := DefaultPDFName(frmMain.glEndDate.Date);
  frmMain.SaveDialog.Filter := 'Portable Document Format (PDF) File (*.pdf)|*.pdf';
  frmMain.SaveDialog.Title:= 'Save Report Image to PDF file';
  if frmMain.SaveDialog.Execute(frmMain.Handle) then begin
    frxPDFExport1.DefaultPath := Settings.ReportDir;
    frxPdfExport1.FileName := frmMain.SaveDialog.FileName;
    // 2017-02-16 MB the next line puts DRAFT watermark on tax years not yet released.
    frxPdfExport1.Background := (TradeLogFile.TaxYear > MAX_TAX_YEAR)
      or not TradeLogFile.YearEndDone;
    frxPdfExport1.EmbeddedFonts := true;
//    frxPdfExport1.EmbedFontsIfProtected := true;
    Preview.Export(frxPDFExport1);
  end;
end;


procedure TfrmFastReports.actnPage_FirstExecute(Sender: TObject);
begin
  Preview.First;
end;


procedure TfrmFastReports.actnPage_LastExecute(Sender: TObject);
begin
  Preview.Last;
end;


procedure TfrmFastReports.actnPage_NextExecute(Sender: TObject);
begin
  Preview.Next;
end;


procedure TfrmFastReports.actnPage_PreviousExecute(Sender: TObject);
begin
  Preview.Prior;
end;


procedure TfrmFastReports.actnPrint_SettingsExecute(Sender: TObject);
begin
  if TPageSetupDlg.Execute = mrOK then begin
    SetupInitialPageValues;
    SetupStandardVariables;
    Preview.RefreshReport;
  end;
end;


procedure TfrmFastReports.actnZoom_InExecute(Sender: TObject);
begin
  Preview.Zoom := Preview.Zoom + 0.05;
  txtZoomEdit.Text := intToStr(Trunc(Preview.Zoom * 100));
end;


procedure TfrmFastReports.actnZoom_OutExecute(Sender: TObject);
begin
  Preview.Zoom := Preview.Zoom - 0.05;
  txtZoomEdit.Text := intToStr(Trunc(Preview.Zoom * 100));
end;


procedure TfrmFastReports.actnZoom_Page100Execute(Sender: TObject);
begin
  txtZoomEdit.Text := '100.0';
  txtZoomEditExit(txtZoomEdit);
end;


procedure TfrmFastReports.actnZoom_PageExecute(Sender: TObject);
begin
  Preview.ZoomMode := zmWholePage;
  txtZoomEdit.Text := intToStr(Trunc(Preview.Zoom * 100));
end;


procedure TfrmFastReports.actnZoom_PageWidthExecute(Sender: TObject);
begin
  Preview.ZoomMode := zmPageWidth;
  txtZoomEdit.Text := intToStr(Trunc(Preview.Zoom * 100));
end;


procedure TfrmFastReports.btnHideClick(Sender: TObject);
begin
  pnlTotals.Hide;
  self.SetFocus;
end;


procedure TfrmFastReports.btnYECHelpClick(Sender: TObject);
begin
  webURL(supportSiteURL + 'hc/en-us/sections/115000956894'); // 2019-01-25 MB
end;


procedure TfrmFastReports.cxGridRptTotTableViewCustomDrawCell(
  Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
var
  aRow,aCol:integer;
  R : TRect;
begin
  with cxGridRptTotTableView.dataController do
  with AViewInfo do begin
    aRow:= GridRecord.Index;
    aCol:= AViewInfo.item.index;
    ACanvas.Brush.color:= clBtnFace;
    try
      if (aRow=0) or (aCol=0) then begin
        ACanvas.Font.color:= clBtnText;
        ACanvas.Font.Style:= [fsBold];
      end;
      if (aRow = 3) and (ACol < 8) then begin
        R := AViewInfo.Bounds;
        R.Bottom := R.Top + 1;
        if ACol = 0 then
          R.Left := R.Right - (ACanvas.TextWidth(AViewInfo.DisplayValue) + 40);
        {Draw the line}
//        ACanvas.FillRect(R, AViewInfo.Params, [bTop], clBlack, 1, True);
        R := AViewInfo.Bounds;
        R.Top := R.Top + 2;
        {Fill the background with color}
        ACanvas.FillRect(R, clBtnFace);
      end;
    except
    end;
    // ----------------------
    try
      if (aCol=4) or (aCol=7) then
      begin  //G/L or Actual G/L
        ACanvas.Font.Style:= [fsBold];
      end;
    except
    end;
    // ----------------------
    try
      if ( (aCol>0) and (aRow>0) )
      and (pos('(',displaytexts[aRow,aCol])>0) then
      begin
        ACanvas.font.color:= clRed;
      end;
    except
    end;
  end;
end;


(*
 * pnlRange is visible for Detail, Summary and Performance reports
 * pnlGains is visible for Gains, Losses and Tax Reports
 * pnlChart is visible for Charts - Same code for Detail, Summary and Performance reports.
 *
 * The code checks whether these panels are visible to know how to setup the filter
 * This seems like an inappropriate thing to depend on for this decision process, but
 * since the menu code behind the report menu sets these up appropriately, it does provide
 * a way to know what reports are being printed.
*)
function getFilter : String;
begin
  With frmMain do begin
    //Initially set the result to the actual Filter from the grid.
    Result := cxGrid1TableView1.DataController.Filter.FilterCaption;
    //Certain conditions require that the filter text be specific so modify it for these conditions.
    if (ReportStyle in [rptMTM, rpt4797, rpt481Adjust]) then Result := '' // MTM
    else if not (ReportStyle in [rptSubD1, rptGAndL, rptFutures, rptCurrencies, rptIRS_D1, rptWashSales, rptPotentialWS]) then
    begin //Detail, Summary or Performance report chosen, or Chart Reports chosen
      if (Result = '') then
        Result := 'None'
      else if (Pos('(Type/Mult NOT LIKE FUT*) and (Type/Mult NOT LIKE CUR*) and ((O/C <> W))', Result) > 0 ) then
        Result := 'NO Wash Sale Deferrals, Futures, or Currencies'
      else if Pos('((O/C <> W))', Result) > 0 then
        Result := 'NO Wash Sale Deferrals'
      else if (Pos('(Type/Mult NOT LIKE FUT*) and (Type/Mult NOT LIKE CUR*)', Result) > 0 ) then
        Result := 'No Futures or Currencies'
      else begin
        Result := GetFilterCaption;
//        if Result = '' then
//          Result := 'None'
//        else if Result = '(Type/Mult NOT LIKE CUR*)' then
//          Result := 'No Currencies';
      end;
    end
    else begin //Gains, Losses or Tax reports chosen
      if ReportStyle = rptFutures then
        Result:= 'Only Futures'
      else if ReportStyle = rptCurrencies then
        Result:= 'Only Currencies'
      else if (cbAdjWash.Enabled = False) and not (ReportStyle in [rptWashSales, rptPotentialWS]) then
        Result := 'None' //MTM Report
      else if ((Result = '') //
        or (Pos('(Type/Mult NOT LIKE FUT*) and (Type/Mult NOT LIKE CUR*)', Result) > 0)) //
      and (ReportStyle in [rptWashSales, rptPotentialWS]) then begin
        if (cbAdjWash.Checked) then
          Result := 'Wash Sale Adjusted'
        else
          Result := 'No WS Adjustments';
      end
      else
        Result := GetFilterCaption;
    end;
  end;
end;


procedure TfrmFastReports.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  iFormT := frmFastReports.top;
  iFormL := frmFastReports.left;
  iFormW := frmFastReports.width;
  iFormH := frmFastReports.height;
  PostMessage(Application.MainForm.Handle, WM_REPORT_CLOSING, FCloseAction, StrToInt(BoolToStr(FForceQuickStart)));
end;


procedure TfrmFastReports.FormCreate(Sender: TObject);
begin
  top := frmMain.Top;
  left := frmMain.Left;
  width := frmMain.width;
  height := frmMain.height;
  btnTaxAct.Caption := btnTaxAct.Caption + Chr(174);
  btnTurboTax.Caption := btnTurboTax.Caption + Chr(174);
  mnuTurboTax.Caption := mnuTurboTax.Caption + Chr(174);
  mnuTaxAct.Caption := mnuTaxAct.Caption + Chr(174);
  frmMain.pnlTools.visible:= false;
end;


procedure TfrmFastReports.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = 27) then begin
    if not FReportDone then
      stopReport := True
    else
      close;
  end;
end;

procedure TfrmFastReports.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
//  Preview.MouseWheelScroll(WheelDelta);
end;


procedure TfrmFastReports.FormShow(Sender: TObject);
begin
  if ReportStyle = rptRecon then
    FCloseAction :=  WPARAM_SHOW_QUICKSTART_61
  else if ReportStyle = rptIRS_D1 then
    FCloseAction :=  WPARAM_SHOW_QUICKSTART_81;
  FForceQuickStart := false;
  if (ReportStyle in [rptIRS_D1, rptSubD1, rptMTM, rptFutures, rptCurrencies, rpt481Adjust, rpt4797])
  and not (TradeLogFile.AllCheckListsComplete and TradeLogFile.YearEndDone)
  then begin
    pnlWarning.Visible := true;
    lblCheckListMessage.Visible := not TradeLogFile.AllCheckListsComplete;
    lblEndTaxYrMessage.Visible := not TradeLogFile.YearEndDone;
    if lblEndTaxYrMessage.Visible and not lblCheckListMessage.Visible then
      lblEndTaxYrMessage.Top := lblCheckListMessage.Top
    else
      lblEndTaxYrMessage.Top := 46;
  end
  else
    pnlWarning.Visible := False;
  case reportStyle of
    rptIRS_D1: RowsPerPage := 16;
    rptSubD1, rptGAndL, rptCurrencies, rpt4797: RowsPerPage := 52;
  end;
  Preview.Align:= alClient;
  Preview.SetFocus;
  SetupStandardVariables;
  SetupInitialPageValues;
  // setup Preview menu
  //Menu:=nil;
  //frmMain.Menu:= MainMenu1;
  // setup report Preview toolbar
  tlbtnPrint.Enabled:=false;
  spdCopy.Enabled:= false;
  spdPDF.Enabled:= false;
  btnTurboTax.Enabled:= false;
  btnTaxAct.Enabled:= false;
  mnuExports.Enabled := false; // 2017-05-02 MB make sure Free Trial users cannot use these
  mnuPrint.Enabled := false; // 2017-05-02 MB make sure Free Trial users cannot use these
  mnuFileCopy.Enabled := false; // 2017-05-02 MB make sure Free Trial users cannot use these
  mnuFileSavePDF.Enabled := false; // 2017-05-02 MB make sure Free Trial users cannot use these
  spdExit.Enabled:= false;
  // hide report panels
  with frmMain do begin
    pnlGains.hide;
    pnlTrades.hide;
    pnlChart.hide;
    pnlDoReport.hide;
  end;
  // not sure why RefreshReport takes sop long on detail reports
  // it does not seem necesary for these reports, but IS necessary for others why ???
  if not (ReportStyle in [rptDateDetails, rptTickerDetails,  rptTradeDetails])
  then
    Preview.RefreshReport;
  //Run the Report.
  FReportDone:= false;
  Preview.PageNo := 0;
  Preview.ZoomMode := zmPageWidth;
  pnlReportTime.Caption := FormatDateTime('nn:ss', now() - StartTime);
  Preview.Report.ShowReport;
  frmMain.Hide;
  frmFastReports.setfocus;
  if frmMain.cbForm8949pdf.checked then spdPDF.Click;
end;


procedure TfrmFastReports.PreviewPageChanged(Sender : TfrxPreview; PageNo : Integer);
begin
  if stopReport then begin
    Preview.Report.Engine.stopReport;
    Preview.Hide;
    if not FMsgShown then begin
      reportCancelledMsg;
      FMsgShown := True;
    end;
    tlBarPreview.Hide;
    pnlWarning.Hide;
    pnlTotals.Hide;
    pnlStatus.Hide;
    screen.Cursor := crHourglass;
  end else
  if not FReportDone then begin
    statBar('Generating Report');
    UpdateStatus; // do this while report is building
    //disableButtons; // stopped calling this long before TL25!
  end;
  UpdateText; // do this EVERY time preview changes
end;


procedure TfrmFastReports.ReportComplete;
begin
  if Preview.PageNo = 0 then exit;
  FReportDone := True;
  progrBar.Hide;
  enableButtons;
  pnlReportTime.Caption := FormatDateTime('nn:ss', now() - StartTime);
  statBar('off');
  if stopReport then close;
end;


procedure TfrmFastReports.UpdateText;
begin
  txtZoomEdit.Text := intToStr(Trunc(Preview.Zoom * 100));  // zoom%
  txtPageEdit.Text := intToStr(Preview.PageNo);             // page no.
end;


procedure TfrmFastReports.UpdateStatus;
var
  C : Integer;
begin
  C := Preview.PageCount;
  lblOfPage.Caption := 'of ' + intToStr(C);                 // #pages
  progrBar.Position := round(c/glReportRows*RowsperPage*100);
end;


procedure TfrmFastReports.PrintDialog1Show(Sender: TObject);
var
  dlg : TPrintDialog;
  PreviewInfo : tagWINDOWINFO;
  DialogInfo : tagWINDOWINFO;
  DlgW, DlgH,
  DlgL, DlgT : Integer;
begin
   if Sender is TPrintDialog then begin
     dlg := TPrintDialog(Sender);
     GetWindowInfo(self.Handle, PreviewInfo);
     GetWindowInfo(Dlg.Handle, DialogInfo);
     DlgW := DialogInfo.rcWindow.Right - DialogInfo.rcWindow.Left;
     DlgH := DialogInfo.rcWindow.Bottom - DialogInfo.rcWindow.Top;
     DlgT := PreviewInfo.rcWindow.top
       + Trunc(((PreviewInfo.rcWindow.Bottom - PreviewInfo.rcWindow.Top) / 2) - (DlgH / 2));
     DlgL := PreviewInfo.rcWindow.Left
       + Trunc(((PreviewInfo.rcWindow.Right - PreviewInfo.rcWindow.Left) / 2) - (DlgW / 2));
     SetWindowPos(dlg.Handle, HWND_TOPMOST, DlgL, DlgT, DlgW, DlgH, SWP_SHOWWINDOW);
   end;
end;

procedure TfrmFastReports.DoReport(Report : TFrxReport);
begin
  if stopReport then exit;
  //Make sure the report is set to use our preview window.
  Report.Preview := Preview;
  //Set the report into the preview so that when the initial values are set
  //they will be set against this report in the FormShow Method.
  Preview.Report := Report;
  //Initially the reports previewOptions Zoom Mode must be set in order to get
  //the report to open with the users defined zoom mode. After that the Preview component's
  //zoom mode can be set.
  if Settings.ReportPageData.FitToWidth then
    Report.PreviewOptions.ZoomMode := zmPageWidth
  else
    Report.PreviewOptions.ZoomMode := zmWholePage;
  //Show the form, for some reason this needs to be done first otherwise the report
  //form will be blank when the showreport method is run
  ShowModal;
end;


procedure TfrmFastReports.SetupExports(Visible: Boolean);
begin
  mnuExports.Visible := Visible;
  btnTaxAct.Visible := Visible;
  btnTurboTax.Visible := Visible;
  Sep5.Visible := Visible;
  Sep7.Visible := Visible;
end;


procedure TfrmFastReports.SetupInitialPageValues;
var
  style : TfrxStyleItem;
  dataPage : TfrxReportPage;
  I : Integer;
const
  MyIn = 25.4;
begin
  if Settings.ReportPageData.FitToWidth then
    Preview.ZoomMode := zmPageWidth
  else
    Preview.ZoomMode := zmWholePage;
  // ------------------------
  style := Preview.Report.Styles.Find('FmData');
  if style <> nil then
    style.Font.Size := Settings.ReportPageData.FontDataSize;
  style := Preview.Report.Styles.Find('FmDataBold');
  if style <> nil then
    style.Font.Size := Settings.ReportPageData.FontDataSize;
  style := Preview.Report.Styles.Find('FmDataHead');
  if style <> nil then
    style.Font.Size := Settings.ReportPageData.FontDataSize;
  style := Preview.Report.Styles.Find('FmDataUL');
  if style <> nil then
    style.Font.Size := Settings.ReportPageData.FontDataSize;
  style := Preview.Report.Styles.Find('FmTitle');
  if style <> nil then
    style.Font.Size := Settings.ReportPageData.FontHeadingSize;
  style := Preview.Report.Styles.Find('FmTitleBlack');
  if style <> nil then
    style.Font.Size := Settings.ReportPageData.FontHeadingSize - 2;
  style := Preview.Report.Styles.Find('FmTitleHead');
  if style <> nil then
    style.Font.Size := Settings.ReportPageData.FontHeadingSize - 6;
  style := Preview.Report.Styles.Find('FmTitleHeadBold');
  if style <> nil then
    style.Font.Size := Settings.ReportPageData.FontHeadingSize - 6;
  // ------------------------
  //Some reports should not be affected by margin adjustment such as IRS Forms.
  if AllowMarginAdjustment then begin
    //Set the margin for all pages.
    for I := 1 to Preview.Report.PagesCount - 1 do begin
      dataPage := TfrxReportPage(Preview.Report.Pages[I]);
      dataPage.Orientation := Settings.ReportPageData.Orientation;
      dataPage.LeftMargin :=  MyIn * (Settings.ReportPageData.Margins.Left / 1000);
      dataPage.RightMargin := Myin * (Settings.ReportPageData.Margins.Right / 1000);
      dataPage.TopMargin := Myin * (Settings.ReportPageData.Margins.Top / 1000);
      dataPage.BottomMargin := Myin * (Settings.ReportPageData.Margins.Bottom / 1000);
    end;
  end;
end;


procedure TfrmFastReports.SetupStandardVariables;
var
  S, nameOnReports, SSN : String;
  i, x: Integer;
  hasMultAccts, hasShortSales, hasWSadjProceeds, FidTS : boolean;
  TrSum : PTTrSum;
  F : TdlgSSNEIN;
function WSSettingStr(): string;
var
  t:string;
begin
  t := ' W/S ';
  if bWashShortAndLong then t := t + '1';
  if bWashStock2Opt then t := t + '2';
  if bWashOpt2Stock then t := t + '3';
  if bWashUnderlying then t := t + '4';
  result := t;
end;
procedure GetSSNEIN;
begin
  F := TdlgSSNEIN.Create(self);
  F.MaskEdit1.EditMask := 'aaa-aa-aaaa'; // SSN
  F.showmodal;
  SSN := F.MaskEdit1.EditText;
  F.Free;
end;
begin
  hasShortSales := false;
  hasWSadjProceeds := false;
  FidTS := false;
  hasMultAccts := false;
  x := 0;
  S := ReplaceStr(GetAccountNamesFromFilter, '''', '''''');
  Preview.Report.Variables.Variables['Filename'] := QuotedStr(TrFileName);
  Preview.Report.Variables.Variables['Accounts'] := QuotedStr(S);
  Preview.Report.Variables.Variables['Filter'] := QuotedStr(getFilter);
  Preview.Report.Variables.Variables['TaxYear'] := QuotedStr(TaxYear);
  // The next value used to be Settings.NameOnReports
  if ProHeader.taxFile <> '' then begin
    if lowercase(RightStr(ProHeader.taxFile, 4)) = '.tdf' then begin
      // remove file extension
      nameOnReports := RemoveFileExtension(ProHeader.taxFile); // 2017-04-11 MB
    end
    else
      nameOnReports := ProHeader.taxFile;
    // remove tax year
    if isInt(leftStr(nameOnReports,4)) then delete(nameOnReports,1,5);
    Preview.Report.Variables.Variables['User1'] := QuotedStr(nameOnReports);
  end
  else
    Preview.Report.Variables.Variables['User1'] := QuotedStr(Settings.AcctName);
  // -------------- SSN/EIN + Taxpayer --------------------
  // for reports which can turn SSN/EIN on/off
  if (ReportStyle in [rptMTM, rpt481Adjust, rptIRS_D1, rptSubD1, rptGAndL, rptCurrencies, rptFutures, rpt4797]) then
  begin
    if Tradelogfile.YearEndDone then begin
      GetSSNEIN;
      Preview.Report.Variables.Variables['SocialSecurity'] := QuotedStr(SSN); // was ProHeader.taxpayer
      if Settings.IsEIN then S := 'EIN:' else S := 'SSN:';
      Preview.Report.Variables.Variables['SSNEINTitle'] := QuotedStr(S);
    end
    else begin
      Preview.Report.Variables.Variables['SocialSecurity'] := QuotedStr('');
      Preview.Report.Variables.Variables['SSNEINTitle'] := QuotedStr('');
    end;
  end
  else begin
    Preview.Report.Variables.Variables['SocialSecurity'] := QuotedStr('');
    Preview.Report.Variables.Variables['SSNEINTitle'] := QuotedStr('');
  end;
  // end if
  Preview.Report.Variables.Variables['Title'] := QuotedStr(Title);
  if (ReportStyle in [rptSubD1, rptIRS_D1, rptGAndL, rptWashSales, rpt4797, rptPotentialWS]) then
    Preview.Report.Variables.Variables['TradeLogVersion']
      := QuotedStr(gsInstallVer + WSSettingStr)
  else
    Preview.Report.Variables.Variables['TradeLogVersion'] := QuotedStr(gsInstallVer);
  Preview.Report.Variables.Variables['RunDate'] := QuotedStr(DateToStr(Date, Settings.UserFmt));
  if Settings.ReportPageData.UseColor then
    Preview.Report.Variables.Variables['RedNegatives'] := QuotedStr('true')
  else
    Preview.Report.Variables.Variables['RedNegatives'] := QuotedStr('false');
  //set 8949 Statement check boxes
  if frmMain.cbIncludeStatement.checked and (ReportStyle = rptIRS_D1) then begin
    Preview.Report.Variables.Variables['hasOptions'] := TradeLogFile.HasOptions;
    // ----- Non-taxable IRA check box logic -----------------------------------
    // code to set [ ] Non-taxable IRA check box only if a WS was lost to an IRA - MB
    Preview.Report.Variables.Variables['hasIRA'] := (high(datDeferralsIra) > -1);
    // code to set [ ] Non-taxable IRA check box if there exists an IRA - 2017-02-23 MB
    //if ((TradeLogFile.CurrentBrokerID = 0) and (TradeLogFile.HasAccountType[atIRA]))
    //or ((TradeLogFile.CurrentBrokerID > 0) and (TradeLogFile.CurrentAccount.Ira)) then
    //  Preview.Report.Variables.Variables['hasIRA'] := true;
    // end [ ] Non-taxable IRA check box
    // -------------------------------------------------------------------------
    //check if accounts = Fidelity or Tradestation
    Preview.Report.Variables.Variables['hasWSadjProceeds'] := false;
    for i := 0 to TradeLogFile.FileHeaders.Count - 1 do begin
      if (TradeLogFile.FileHeaders[i].Ira) then continue;
      if (TradeLogFile.FileHeaders[i].MTM) then continue;
      inc(x);
      if (x > 1) then hasMultAccts := true;
      if ( ( (TradeLogFile.FileHeaders[i].FileImportFormat = 'Fidelity')
         and (TradeLogFile.TaxYear < 2013) )
        or (TradeLogFile.FileHeaders[i].FileImportFormat = 'TradeStation')
      ) then FidTS := true;
    end;
    //check for short sales
    for i:= 0 to TrSumList.count-1 do begin
      TrSum := TrSumList[i];
      if (TradeLogFile.FileHeader[StrToInt(TrSum.br)].IRA) then continue;
      if (TrSum.ls = 'S') and (TrSum.cd <> '') and (pos('OPT',TrSum.prf)=0)
      then begin
        hasShortSales := true;
        if not FidTS then break;
        if (TradeLogFile.FileHeader[StrToInt(TrSum.br)].ImportFilter.FilterName = 'Fidelity')
        or (TradeLogFile.FileHeader[StrToInt(TrSum.br)].ImportFilter.FilterName = 'TradeStation')
        then begin
          hasWSadjProceeds := true;
          break;
        end;
      end;
    end;
    if (bWashUnderlying AND bWashStock2Opt AND bWashOpt2Stock) = false then
      Preview.Report.Variables.Variables['hasOptions'] := false;
    Preview.Report.Variables.Variables['hasMultAccts'] := hasMultAccts;
    Preview.Report.Variables.Variables['hasShortSales'] := hasShortSales;
    Preview.Report.Variables.Variables['hasWSadjProceeds'] := hasWSadjProceeds;
    Preview.Report.Variables.Variables['hasOtherErrors'] := frmMain.cb1099OtherErrors.checked;
  end;
end;


procedure TfrmFastReports.enableButtons;
begin
  if not settings.TrialVersion then begin
    tlbtnPrint.Enabled :=true;
    spdCopy.Enabled := true;
    spdPDF.Enabled := true;
    btnTurboTax.Enabled := true;
    btnTaxAct.Enabled := true;
    // 2017-05-02 MB - enable what was disabled
    mnuExports.Enabled := true;
    mnuPrint.Enabled := true;
    mnuFileCopy.Enabled := true;
    mnuFileSavePDF.Enabled := true;
  end;
  tlBarPreview.Enabled:=true;
  spdExit.Enabled:= true;
end;


procedure TfrmFastReports.SetupTotalsPanel(Visible : Boolean);
begin
  pnlTotals.Visible := Visible;
  if Not pnlTotals.Visible then exit;
  pnlTotals.Height:= pnlHide.Height + 90;
  pnlhide.caption:= '';
  if not GainsReportData.HasShortTerm and not GainsReportData.HasLongTerm then
    pnlhide.caption:= 'No Short-Term or Long-Term'
  else if not GainsReportData.HasShortTerm then
    pnlhide.caption:= 'No Short-Term'
  else if  not GainsReportData.HasLongTerm then
    pnlhide.caption:= 'No Long-Term'
  else
    pnlhide.caption:= '';
  // ------------------------
  if pnlhide.caption<>'' then begin
    if (ReportStyle = rptWashSales) then
      pnlhide.caption:= pnlhide.caption + ' wash sales deferred to next year'
    else
      pnlhide.caption:= pnlhide.caption + ' Gains or Losses';
  end;
  // ------------------------
  if pnlhide.caption='' then begin
    lblTotals.Font.Color := clWindowText;
    pnlHide.Color:= clBtnface;
    pnlRptTotHide.Color:= clBtnface;
  end
  else begin
    lblTotals.Font.Color := clBlack;
  end;
  // ------------------------
  with cxGridRptTotTableView do begin
    items[0].DataBinding.ValueTypeClass := TcxStringValueType;
    items[1].DataBinding.ValueTypeClass := TcxStringValueType;
    items[2].DataBinding.ValueTypeClass := TcxStringValueType;
    items[3].DataBinding.ValueTypeClass := TcxStringValueType;
    items[4].DataBinding.ValueTypeClass := TcxStringValueType;
    items[5].DataBinding.ValueTypeClass := TcxStringValueType;
    items[6].DataBinding.ValueTypeClass := TcxStringValueType;
    items[7].DataBinding.ValueTypeClass := TcxStringValueType;
    items[8].DataBinding.ValueTypeClass := TcxStringValueType;
  end;
  // ------------------------
  with cxGridRptTotTableView.datacontroller do begin
    recordCount:= 4;
    beginUpdate;
    try
      Values[0,0] := '';
      Values[1,0] := 'Short Term:';
      Values[2,0] := 'Long Term:';
      Values[3,0] := 'Total:';
      // --- Sales
      Values[0,1] := 'Total Sales:';
      Values[1,1] := CurrStrEx(GainsReportData.STSales,Settings.UserFmt);
      if (ReportStyle <> rpt4797) then begin
        Values[2,1] := CurrStrEx(GainsReportData.LTSales,Settings.UserFmt);
      end;
      Values[3,1] := CurrStrEx(GainsReportData.TotalSales,Settings.UserFmt);
      // --- Cost
      Values[0,2] := 'Total Cost:';
      Values[1,2] := CurrStrEx(GainsReportData.STCostBasis,Settings.UserFmt);
      if (ReportStyle <> rpt4797) then begin
        Values[2,2] := CurrStrEx(GainsReportData.LTCostBasis,Settings.UserFmt);
      end;
      Values[3,2] := CurrStrEx(GainsReportData.TotalCostBasis,Settings.UserFmt);
      colAdjG.Visible := (ReportStyle = rptIRS_D1) and (TradeLogFile.TaxYear > 2010);
      // -----
      Values[0,3] := 'Col (g) Adjustment:';
      Values[1,3] := CurrStrEx(GainsReportData.STAdjustment,Settings.UserFmt);
      Values[2,3] := CurrStrEx(GainsReportData.LTAdjustment,Settings.UserFmt);
      Values[3,3] := CurrStrEx(GainsReportData.TotalAdjustment,Settings.UserFmt);
      // ----- taxable P/L -------
      Values[0,4] := 'Taxable G/L:';
      Values[1,4] := CurrStrEx(GainsReportData.STPAndL + GainsReportData.STAdjustment, Settings.UserFmt, GainsReportData.STSales <> 0);
      if (ReportStyle <> rpt4797) then begin
        Values[2,4] := CurrStrEx(GainsReportData.LTPAndL + GainsReportData.LTAdjustment, Settings.UserFmt, GainsReportData.LTSales <> 0);
      end;
      Values[3,4] := CurrStrEx(GainsReportData.TotalPAndL + GainsReportData.TotalAdjustment, Settings.UserFmt, True);
      // ----- WS Deferrals
      Values[0,5] := 'WS Deferrals:';
      Values[1,5] := CurrStrEx(GainsReportData.STDeferrals, Settings.UserFmt);
      Values[2,5] := CurrStrEx(GainsReportData.LTDeferrals, Settings.UserFmt);
      Values[3,5] := CurrStrEx(GainsReportData.TotalDeferrals, Settings.UserFmt);
      // ----- Wash Sales lost to IRA
      Values[0, 6] := 'WS Lost to IRA:';
      Values[1,6] := CurrStrEx(GainsReportData.STWSLostToIra, Settings.UserFmt);
      Values[2,6] := CurrStrEx(GainsReportData.LTWSLostToIra, Settings.UserFmt);
      Values[3,6] := CurrStrEx(GainsReportData.TotalWSLostToIra, Settings.UserFmt);
      // ----- Net P/L
      Values[0,7] := 'Actual G/L:';
      Values[1,7] := CurrStrEx(GainsReportData.STPAndL + GainsReportData.STAdjustment //
        + GainsReportData.STDeferrals + GainsReportData.STWSLostToIra, //
          Settings.UserFmt, GainsReportData.STSales <> 0);
//      Values[1,7] := CurrStrEx(GainsReportData.STActualGL, Settings.UserFmt, GainsReportData.STSales <> 0);
      if (ReportStyle <> rpt4797) then begin
        Values[2,7] := CurrStrEx(GainsReportData.LTPAndL + GainsReportData.LTAdjustment //
          + GainsReportData.LTDeferrals + GainsReportData.LTWSLostToIra, //
            Settings.UserFmt, GainsReportData.LTSales <> 0);
//        Values[2,7] := CurrStrEx(GainsReportData.LTActualGL, Settings.UserFmt, GainsReportData.LTSales <> 0);
      end;
      Values[3,7] := CurrStrEx(GainsReportData.STPAndL + GainsReportData.STAdjustment //
        + GainsReportData.STDeferrals + GainsReportData.STWSLostToIra //
        + GainsReportData.LTPAndL + GainsReportData.LTAdjustment //
          + GainsReportData.LTDeferrals + GainsReportData.LTWSLostToIra, //
            Settings.UserFmt, True);
//      Values[3,7] := CurrStrEx(GainsReportData.TotalActualGL, Settings.UserFmt, True);
    finally
      endUpdate;
    end;
  end;
end;


procedure TfrmFastReports.txtPageEditExit(Sender: TObject);
var
  x : Integer;
begin
  x := StrToInt(txtPageEdit.Text);
  if x <= Preview.PageCount then
    Preview.PageNo := x
  else
    txtPageEdit.Text := IntToStr(Preview.PageNo);
end;


procedure TfrmFastReports.txtPageEditKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_RETURN then txtPageEditExit(Sender);
end;


procedure TfrmFastReports.txtZoomEditExit(Sender: TObject);
begin
  Preview.Zoom := StrToFloat(txtZoomEdit.Text) / 100;
  txtZoomEdit.Text := intToStr(Trunc(Preview.Zoom * 100));
end;


procedure TfrmFastReports.txtZoomEditKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if Key = VK_RETURN then txtZoomEditExit(Sender);
end;


end.

