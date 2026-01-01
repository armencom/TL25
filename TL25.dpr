// JCL_DEBUG_EXPERT_DELETEMAPFILE ON
program TL25;
{$R 'manifest.res' 'manifest.rc'}
{$STRONGLINKTYPES ON}
uses
  Dialogs,
  Forms,
  Controls,
  SysUtils,
  TLLogging in 'TLLogging.pas',
  Main in 'Main.pas' {frmMain},
  FuncProc in 'FuncProc.pas',
  TLRegister in 'TLRegister.pas',
  Import in 'Import.pas',
  pbmarquee in 'pbmarquee.pas',
  RecordClasses in 'RecordClasses.pas',
  ZLibEx in 'ZLibEx.pas',
  Commission in 'Commission.pas' {frmCommission},
  EditSplit in 'EditSplit.pas' {frmEditSplit},
  FileSave in 'FileSave.pas' {dlgFileSave},
  frmOFX in 'frmOFX.pas' {frmOFX1},
  frmOpTick in 'frmOpTick.pas' {frmOptTick},
  AccountSetup in 'AccountSetup.pas' {dlgAccountSetup},
  OpenTrades in 'OpenTrades.pas' {frmOpenTrades},
  ReadMe in 'ReadMe.pas' {frmReadMe},
  SelectDateRange in 'SelectDateRange.pas' {frmRangeSelect},
  TlCharts in 'TlCharts.pas' {frmTlCharts},
  underlying in 'underlying.pas' {frmUnderlying},
  Web in 'Web.pas' {frmWeb},
  selImpMethod in 'selImpMethod.pas' {frmSelImpMethod},
  bcFunctions in 'bcFunctions.pas',
  myInput in 'myInput.pas' {frmInput},
  myDatePick in 'myDatePick.pas' {frmDatePick},
  DataConvError in 'DataConvError.pas' {frmDataConvErr},
  frmSendSupportFiles in 'frmSendSupportFiles.pas' {SendSupport},
  Reports in 'Reports.pas',
  ChartTimes in 'ChartTimes.pas' {frmChartTimes},
  frmAssignStrategy in 'frmAssignStrategy.pas' {AssignStrategy},
  frmNewBBIFU in 'frmNewBBIFU.pas' {NewBBIFU},
  frmNewStrategies in 'frmNewStrategies.pas' {NewStrategies},
  SciZipFile in 'SciZipFile.pas',
  FastReportsPreview in 'FastReportsPreview.pas' {frmFastReports},
  frmPageSetupDlg in 'frmPageSetupDlg.pas' {PageSetupDlg},
  TLSettings in 'TLSettings.pas',
  splash in 'splash.pas' {panelSplash},
  messagePanel in 'messagePanel.pas' {panelMsg},
  TLGainsReport in 'TLGainsReport.pas',
  TypeMult in 'TypeMult.pas' {frmTypeMult},
  TLFile in 'TLFile.pas',
  TLCommonLib in 'TLCommonLib.pas',
  PriceList in 'PriceList.pas' {dlgPriceList},
  TLExerciseAssign in 'TLExerciseAssign.pas',
  WebBrowser in 'WebBrowser.pas' {frmWebBrowserPopup},
  ExerciseAssignList in 'ExerciseAssignList.pas' {frmExerciseAssign},
  TLImportFilters in 'TLImportFilters.pas',
  TLImportReadMethods in 'TLImportReadMethods.pas',
  uLkJSON in 'uLkJSON.pas',
  BaseDialog in 'BaseDialog.pas' {BaseDlg},
  TLDataSources in 'TLDataSources.pas',
  fm1099Info in 'fm1099Info.pas' {frm1099info},
  HintModule in 'HintModule.pas' {moduleHints: TDataModule},
  FastReportsData in 'FastReportsData.pas' {dataFastReports: TDataModule},
  TLSupport in 'TLSupport.pas',
  AccountYrEndCheck in 'AccountYrEndCheck.pas' {dlgAccountYrEndCheck},
  StackTrace in 'StackTrace.pas',
  LoggingDialog in 'LoggingDialog.pas' {LoggingDlg},
  BackupRestoreDialog in 'BackupRestoreDialog.pas' {BackupRestoreDlg},
  TLDateUtils in 'TLDateUtils.pas',
  TLUpdate in 'TLUpdate.pas',
  MessageDlg in 'MessageDlg.pas' {MessageDialog},
  GainsLosses in 'GainsLosses.pas',
  TLTradeSummary in 'TLTradeSummary.pas',
  shortSalesDiv in 'shortSalesDiv.pas' {panelShortSaleDiv},
  globalVariables in 'globalVariables.pas',
  baseline in 'baseline.pas' {pnlBaseline},
  baseline1 in 'baseline1.pas' {pnlBaseline1},
  AdjCostBasisAmt in 'AdjCostBasisAmt.pas' {dlgAdjCostBasisAmt},
  SecurityQues in 'SecurityQues.pas' {dlgSecurityQues},
  webImport in 'webImport.pas',
  importCSV in 'importCSV.pas',
  fm1099more in 'fm1099more.pas' {frm1099more},
  WebDelay in 'WebDelay.pas',
  TLDatabase in 'TLDatabase.pas',
  TLWinInet in 'TLWinInet.pas',
  dlgTaxfilePicker in 'dlgTaxfilePicker.pas' {dlgPickTaxFiles},
  dlgSuperUser in 'dlgSuperUser.pas' {dlgSuper},
  TLEndYear in 'TLEndYear.pas',
  dlgAcctImport in 'dlgAcctImport.pas' {dlgCanProHelp},
  AdjCodes in 'AdjCodes.pas' {dlgAdjCodes},
  dlgWashSales in 'dlgWashSales.pas' {dlgWSsettings},
  ImportSetup in 'ImportSetup.pas' {dlgImportSetup},
  dlgImport in 'dlgImport.pas' {dlgImport},
  BrokerSelectDlg in 'BrokerSelectDlg.pas' {dlgBrokerSelect},
  dlgInputVal in 'dlgInputVal.pas' {dlgInputValue},
  dlgExcelWarn in 'dlgExcelWarn.pas' {dlgExcelWarning},
  GetStarted in 'GetStarted.pas' {frmGetStarted},
  dlgConsolidation in 'dlgConsolidation.pas' {dlgConsolidate},
  TL_API in 'TL_API.pas',
  fmLogin in 'fmLogin.pas' {dlgLogIn},
  frmBackOffice in 'frmBackOffice.pas' {dlgBackOffice},
  Ping2 in 'Ping2.pas',
  fmProgress in 'fmProgress.pas' {dlgProgress},
  TL_Passiv in 'TL_Passiv.pas',
  frmSSNEIN in 'frmSSNEIN.pas' {dlgSSNEIN},
  WebGet in 'WebGet.pas' {frmWebGet},
  OSIdentifier in 'OSIdentifier.pas',
  uDM in 'uDM.pas' {DM: TDataModule},
  Security in 'Security.pas',
  frmOption in 'frmOption.pas' {frmOptionDlg};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'TradeLog';
  Application.ShowHint := true;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TmoduleHints, moduleHints);
  Application.CreateForm(TpanelSplash, panelSplash);
  Application.CreateForm(TpanelMsg, panelMsg);
  Application.CreateForm(TfrmCommission, frmCommission);
  Application.CreateForm(TfrmEditSplit, frmEditSplit);
  Application.CreateForm(TfrmDatePick, frmDatePick);
  Application.CreateForm(TfrmOFX1, frmOFX1);
  Application.CreateForm(TfrmOptTick, frmOptTick);
  Application.CreateForm(TfrmRangeSelect, frmRangeSelect);
  Application.CreateForm(TfrmTlCharts, frmTlCharts);
  Application.CreateForm(TfrmSelImpMethod, frmSelImpMethod);
  Application.CreateForm(TfrmInput, frmInput);
  Application.CreateForm(TfrmDatePick, frmDatePick);
  Application.CreateForm(TSendSupport, SendSupport);
  Application.CreateForm(TAssignStrategy, AssignStrategy);
  Application.CreateForm(TNewBBIFU, NewBBIFU);
  Application.CreateForm(TNewStrategies, NewStrategies);
  Application.CreateForm(TfrmWebBrowserPopup, frmWebBrowserPopup);
  Application.CreateForm(TdlgAdjCodes, dlgAdjCodes);
  Application.CreateForm(TdlgWSsettings, dlgWSsettings);
  Application.CreateForm(TdlgInputValue, dlgInputValue);
  Application.CreateForm(TdlgExcelWarning, dlgExcelWarning);
  Application.CreateForm(TfrmGetStarted, frmGetStarted);
  Application.CreateForm(TdlgLogIn, dlgLogIn);
  Application.CreateForm(TdlgBackOffice, dlgBackOffice);
  Application.CreateForm(TDM, DM);
  Application.Run;
end.
