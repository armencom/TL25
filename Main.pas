unit Main;

interface

uses
  MMSystem, // 2020-03-25 MB - to mute/unmute sounds

  // Standard Delphi Units
  HintModule, Calendar, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Grids, DBGrids, StdCtrls, Mask, DBCtrls, ExtCtrls,
  Buttons, Menus, ComCtrls, Registry, Clipbrd, ShellAPI, CommDlg, Math,
  Gauges, Chart, Printers, ToolWin, ImgList, jpeg, DB, StrUtils,
  Variants, DateUtils, ShlObj, activeX, AppEvnts, SysUtils, ActnList,
  wininet, DBChart,
  // DevExpress Grid Units
  cxLabel, cxLookAndFeelPainters, cxStyles, cxCustomData, cxGraphics,
  cxFilter, cxData, cxEdit, cxNavigator, cxContainer, cxDBData,
  cxCurrencyEdit, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar,
  cxDateUtils, cxGridTableView, cxGridLevel, cxGridCustomTableView,
  cxClasses, cxControls, cxGridCustomView, cxGrid, cxGridCustomPopupMenu,
  cxGridPopupMenu, cxLookAndFeels, cxDataStorage, cxShellTreeView, cxButtons,
  cxShellBrowserDialog, cxFilterControl, cxVariants,
  // Tradelog Units
  FuncProc, TLFile, AccountYrEndCheck, AdjCostBasisAmt, AdjCodes,
  // misc stuff
  OleCtrls, SHDocVw, Generics.Defaults, Generics.Collections, System.Actions,
  // FastReports
  frxClass, frxExportPDF, FastReportsPreview,
  // other devExpress
  cxHint, dxCore, cxCheckGroup, cxCheckBox,
  cxBarEditItem, dxBarExtItems, cxImage, cxCheckComboBox,
  dxScreenTip, dxCustomHint,
  // Raize Components
  RzTabs, RzPanel, RzButton, RzStatus, RzGroupBar, RzBorder, RzBckgnd,
  // skins
  dxSkinHighContrast, dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, dxRibbonSkins, dxSkinsdxRibbonPainter, dxRibbon,
  dxBar, dxBarApplicationMenu, dxSkinsdxNavBarPainter, dxNavBarGroupItems, dxNavBarCollns,
  dxNavBarBase, dxNavBar, dxSkinsCore, dxSkinsForm, dxSkinInfo, dxSkinsLookAndFeelPainter,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkiniMaginary,
  dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin,
  dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010,
  dxSkinWhiteprint, dxSkinXmas2008Blue,
  dxStatusBar, dxRibbonStatusBar, dxmdaset, dxSkinBasic, dxSkinMetropolis,
  dxSkinMetropolisDark, dxSkinOffice2013DarkGray, dxSkinOffice2013LightGray,
  dxSkinOffice2013White, dxSkinOffice2016Colorful, dxSkinOffice2016Dark,
  dxSkinOffice2019Black, dxSkinOffice2019Colorful, dxSkinOffice2019DarkGray,
  dxSkinOffice2019White, dxSkinTheBezier, dxSkinVisualStudio2013Blue,
  dxSkinVisualStudio2013Dark, dxSkinVisualStudio2013Light, dxDateRanges,
  dxScrollbarAnnotations, dxRibbonCustomizationForm, cxImageList,
  System.ImageList;

const
  WM_REPORT_CLOSING = WM_USER + 11;
  WM_OPEN_TRADES_CLOSING = WM_USER + 12;
  WM_DISCOVER_EXERCISE_CLOSING = WM_USER + 13;

  WPARAM_TRANSFER_OPEN_POSITIONS = 1;
  WPARAM_FILTER_BY_TRNUM = 2;
  WPARAM_GET_CURRENT_PRICES = 3;

  WPARAM_SHOW_START = 50;
  WPARAM_SHOW_QUICKSTART_51 = 51;
  WPARAM_SHOW_QUICKSTART_61 = 61;
  WPARAM_SHOW_QUICKSTART_81 = 81;
  WPARAM_SHOW_QUICKSTART_82 = 82;
  WPARAM_SHOW_QUICKSTART_83 = 83;
  WPARAM_SHOW_QUICKSTART_84 = 84;
  WPARAM_SHOW_QUICKSTART_85 = 85;

  // Constants for Update History Menu Items.
  CLOSE_UPDATE_HISTORY = '&Close Update History';
  VIEW_UPDATE_HISTORY = '&View Update History';
  INSTALL_UPDATE = 'Install Update';
  DOWNLOAD_UPDATE = 'Download Update';

type
  TRowColorList = TObjectDictionary<Integer, TColor>;
  TGridFilter = (gfNone, gfAll, gfOpen, gfClosed, gfRange, gfFilter, gfTradeIssues);

  TfrmMain = class(TForm)
    Label11: TLabel;
    Label10: TLabel;
    Label14: TLabel;

    MainMenu: TMainMenu;
      // File menu
      File1: TMenuItem;
      Exit1: TMenuItem;
      // Account menu
      mnuAcct: TMenuItem;
      mnuAcct_Add: TMenuItem;
      mnuAcct_Edit: TMenuItem;
      mnuAcct_Import: TMenuItem;
      DeleteAccount1: TMenuItem;
      TransferOpenPositions1: TMenuItem;
      EndYearCheckList1: TMenuItem;
      Commision1: TMenuItem;
      // Edit menu
      mnuEdit: TMenuItem;
      REDO1: TMenuItem;
      Undo1: TMenuItem;
      Cut: TMenuItem;
      Copy1: TMenuItem;
      Paste1: TMenuItem;
      SelectAll: TMenuItem;
      CopySum: TMenuItem;
      DeleteSelectedRec: TMenuItem;
      DeleteAll1: TMenuItem;
      EditRec1: TMenuItem;
      changeTick1: TMenuItem;
      ChangeStockDescrtoTickerSymbol1: TMenuItem;
      changeCusip1: TMenuItem;
      ChangeTypeMult1: TMenuItem;
      Change8949Code1: TMenuItem;
      AdjustforStockSplit2: TMenuItem;
      AdjustforShortSaleDividend1: TMenuItem;

      mnuEdit_AdjustAmount: TMenuItem;

      ExpireOptions1: TMenuItem;
      ExerciseAssign1: TMenuItem;
      ToggleShortLong1: TMenuItem;
      MatchTaxLots1: TMenuItem;
      UnMatchTaxLots1: TMenuItem;
      FixNegSharesOpen1: TMenuItem;
      Fix1: TMenuItem;
      ReOrderTradeNumbers1: TMenuItem;
      // Add menu
      mnuAdd: TMenuItem;
      AddRecord1: TMenuItem;
      InsertRecord1: TMenuItem;
      EnterOpenPositions1: TMenuItem;
      mnuBaselinePositionWizard: TMenuItem;
      // Find menu
      Find: TMenuItem;
      Ticker1: TMenuItem;
      TrNum1: TMenuItem;
      Stocks2: TMenuItem;
      options2: TMenuItem;
      MutualFunds1: TMenuItem;
      ETFETNs1: TMenuItem;
      Drips1: TMenuItem;
      Futures1: TMenuItem;
      Currencies1: TMenuItem;
      MTMAccounts1: TMenuItem;
      IRAAccounts1: TMenuItem;
      CashAccounts1: TMenuItem;
      MatchedTaxLots1: TMenuItem;
      ExercisesAssigns1: TMenuItem;
      DuplicateTrades1: TMenuItem;
      InvalidTickers1: TMenuItem;
      LookupTicker: TMenuItem;
      // Options menu
      mnuOptions: TMenuItem;
      GlobalOptions1: TMenuItem;
      BCTimeout1: TMenuItem;
      // Reports menu
      Reports1: TMenuItem;
      //----- Tax Analysis -----
      Reconcile1099B1: TMenuItem;
      WashSaleDetails1: TMenuItem;
      PotentialWashSales1: TMenuItem;
      //----- Taxes: Individual -----
      Form1040ScheduleD1: TMenuItem;
      GLScheduleDD1Substitute1: TMenuItem;
      Form6781Futures1: TMenuItem;
      ForexCurrencies1: TMenuItem;
      Form4797MTM1: TMenuItem;
      //----- Taxes: Entity -----
      // same as Taxes: Individual
      //----- Trade Analysis -----
      TradeAnalysis1: TMenuItem;
      GainsLossesAllAccounts1: TMenuItem;
      Trades1: TMenuItem;
      TradesSummary: TMenuItem;
      Perf1: TMenuItem;
      Chart1: TMenuItem;
      ReportOptions1: TMenuItem;
      // View menu
      View1: TMenuItem;
      DisplayMatchedTaxLots1: TMenuItem;
      DisplayNotes1: TMenuItem;
      DisplayOptionTickers1: TMenuItem;
      DisplayStrategies1: TMenuItem;
      DisplayTime1: TMenuItem;
      DisplayWashSales1: TMenuItem;
      Display8949Code1: TMenuItem;
      DisplayWashSaleHoldingDate1: TMenuItem;
      // Help menu
      Help1: TMenuItem;
      FAQHelp1: TMenuItem;
      onlineSupportpage1: TMenuItem;
      Tutorial1: TMenuItem;
      whatsnew: TMenuItem;
      ReadMe1: TMenuItem;
      Register1: TMenuItem;
      Update1: TMenuItem;
      miSendFiles: TMenuItem;
      DebugLogging1: TMenuItem;
      Purchase1: TMenuItem;
      About1: TMenuItem;

    PageSetup1: TMenuItem;
    pupEdit: TPopupMenu;
    tmrFileDL: TTimer;
    AssignStrategy1: TMenuItem;
      mErrorTest: TMenuItem;
    TaxAnalysis1: TMenuItem;
    TaxesIndividual1: TMenuItem;
    TaxesCorporate1: TMenuItem;
    GLScheduleDSubstitute1: TMenuItem;
    Form6781Futures2: TMenuItem;
    ForexCurrencies2: TMenuItem;
    Form4797MTM2: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N13: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    N22: TMenuItem;
    N23: TMenuItem;
    N31: TMenuItem;
    N39: TMenuItem;
    N40: TMenuItem;
    N45: TMenuItem;
    N48: TMenuItem;
    N49: TMenuItem;
    N50: TMenuItem;

    OpenDialog: TOpenDialog;
    ImgToolBar: TImageList;
    cxStyle: TcxStyleRepository;
    cxStyle1: TcxStyle;
    pnlMain: TPanel;
    pnlTrades: TPanel;
    pnlSummBy: TPanel;
    Label20: TLabel;
    pnlDoReport: TPanel;
    spdRunReport: TcxButton;
    exitReports: TcxButton;
    pnlChart: TPanel;
    lblFreq: TLabel;
    lblParam: TLabel;
    lblInclude: TLabel;
    cbParameter: TComboBox;
    cbWin: TCheckBox;
    cbLose: TCheckBox;
    ChartTypeGrp: TGroupBox;
    rbWeekDay: TRadioButton;
    rbTimeDay: TRadioButton;
    rbStandard: TRadioButton;
    rbTickCompare: TRadioButton;
    rbStrategy: TRadioButton;
    btnTODsetup: TcxButton;
    cbTickType: TComboBox;
    cbInterval: TComboBox;
    pnlGains: TPanel;
    // Grid objects
    cxGrid1: TcxGrid;
    cxLook: TcxLookAndFeelController;
    cxGrid1TableView1: TcxGridTableView;
    cxGrid_0_Item: TcxGridColumn;
    cxGrid_1_TrNum: TcxGridColumn;
    cxGrid_2_Date: TcxGridColumn;
    cxGrid_3_Time: TcxGridColumn;
    cxGrid_4_OC: TcxGridColumn;
    cxGrid_5_LS: TcxGridColumn;
    cxGrid_6_Ticker: TcxGridColumn;
    cxGrid_7_Shares: TcxGridColumn;
    cxGrid_8_Price: TcxGridColumn;
    cxGrid_9_PRF: TcxGridColumn;
    cxGrid_10_Comm: TcxGridColumn;
    cxGrid_11_Amount: TcxGridColumn;
    cxGrid_12_PL: TcxGridColumn;
    cxGrid_13_Notes: TcxGridColumn;
    cxGrid_14_Open: TcxGridColumn;
    cxGrid_15_m: TcxGridColumn;
    cxGrid_17_opTk: TcxGridColumn;
    cxGrid_18_tkSort: TcxGridColumn;
    cxGrid_16_br: TcxGridColumn;
    cxGrid_19_Strategy: TcxGridColumn;
    cxGrid_20_Code: TcxGridColumn;
    cxGrid_21_AcctType: TcxGridColumn;
    cxGrid_22_WSHoldingDate: TcxGridColumn;
    cxGrid_23_mSort: TcxGridColumn;
    cxGrid_24_wsSort: TcxGridColumn;
    cxGrid1Level1: TcxGridLevel;
    //
    pnlTools: TPanel;
    Panel1: TPanel;
    lblRptTitle: TLabel;
    cbTrNum: TRadioButton;
    cbTick: TRadioButton;
    cbDate: TRadioButton;
    cbSubTotals: TCheckBox;
    SaveDialog: TSaveDialog;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    pupView: TPopupMenu;
    pupFind: TPopupMenu;

    pnlGrid: TPanel;
    pnlFilter: TPanel;
    lbFilter : TEdit;

    lblReportName: TLabel;
    pupAccount: TPopupMenu;
    pupPlusBtn: TPopupMenu;

    TabAccounts: TRzTabControl;
    actionsToolBar: TActionList;
    ActShowAll: TAction;
    actShowOpen: TAction;
    actnShowClosed: TAction;
    actnShowRange: TAction;
    actnFilter: TAction;
    actnCustomFilter: TAction;
    actnAdd: TAction;
    actnInsert: TAction;
    actnDelete: TAction;
    actnUndo: TAction;
    actnRedo: TAction;
    actnCopy: TAction;
    actnImport: TAction;
    StatusBar: TRzStatusBar;
    stUpdateMsg: TRzStatusPane;
    stRecsLimit: TRzStatusPane;
    stRegDaysLeft: TRzStatusPane;
    stMessage: TRzStatusPane;
    stAcctType: TRzStatusPane;
    RzBorder1: TRzBorder;
    pupAllTab: TPopupMenu;
    GoToInAccountTab1: TMenuItem;
    Form8949Corporate: TMenuItem;
    cxHint: TcxHintStyleController;
    stImportType: TRzStatusPane;
    pnlMTM: TPanel;
    grpRptType: TGroupBox;
    cb4797: TRadioButton;
    cbSec481: TRadioButton;
    cbMTM: TRadioButton;
    pnlWS: TPanel;
    pnlLeft: TPanel;
    lblGlStartDate: TLabel;
    glStartDate: TcxDateEdit;
    lblGlEndDate: TLabel;
    glEndDate: TcxDateEdit;
    pnlStatements: TPanel;
    GroupBox1: TGroupBox;
    cbIncludeAdjustment: TCheckBox;
    cbIncludeStatement: TCheckBox;
    cb1099OtherErrors: TCheckBox;
    cbForm8949pdf: TCheckBox;
    cbShowOpens: TCheckBox;
    pnlToolbar: TPanel;
    ToolbarHelp: TRzToolbar;
    Toolbar1: TRzToolbar;
    btnShowAll: TRzToolButton;
    btnShowOpen: TRzToolButton;
    btnClosed: TRzToolButton;
    btnShowRange: TRzToolButton;
    btnFilterEnable: TRzToolButton;
    Separator1: TRzSpacer;
    Separator2: TRzSpacer;
    btnFilterCustom: TRzToolButton;
    btnAddRec: TRzToolButton;
    Separator3: TRzSpacer;
    btnInsRec: TRzToolButton;
    btnDelRec: TRzToolButton;
    Separator4: TRzSpacer;
    btnUndo: TRzToolButton;
    btnRedo: TRzToolButton;
    Separator5: TRzSpacer;
    btnCopy: TRzToolButton;
    Separator6: TRzSpacer;
    Edit_SplitRecord: TMenuItem;
    Edit_Consolidate: TMenuItem;
    mnuEdit_AssignNotes: TMenuItem;
    stSuperUser: TRzStatusPane;
    btnCheckList: TRzToolButton;
    actnCheckList: TAction;
    btnImport: TRzToolButton;
    mnuFindVTN: TMenuItem;
    mnuFindCTNs: TMenuItem;
    DigCur1: TMenuItem;
    Timer1: TTimer;
    cxImageListLarge: TcxImageList;
    dxBarManager1: TdxBarManager;
    dxBarManager1BarQuickMenu: TdxBar;
    bbClear: TdxBarLargeButton;
    bbSimple: TdxBarLargeButton;
    bbAdvanced: TdxBarLargeButton;
    bbTicker: TdxBarLargeButton;
    bbTrade: TdxBarLargeButton;
    bbStrategy: TdxBarLargeButton;
    dxBarLargeButton7: TdxBarLargeButton;
    bbNote: TdxBarButton;
    bbDuplicate: TdxBarButton;
    bbValidOption: TdxBarButton;
    bbStocks: TdxBarButton;
    bbOptions: TdxBarButton;
    bbMutualFunds: TdxBarButton;
    bbETNETFs: TdxBarButton;
    bbFutures: TdxBarButton;
    bbCurrency: TdxBarButton;
    bbVTNs: TdxBarButton;
    bbCTNs: TdxBarButton;
    bbDigitalCurrency: TdxBarButton;
    bbDrips: TdxBarButton;
    dxBarButton14: TdxBarButton;
    dxBarButton15: TdxBarButton;
    beAccounts: TcxBarEditItem;
    beMatched: TcxBarEditItem;
    bbNew: TdxBarButton;
    beMTM: TcxBarEditItem;
    beIRA: TcxBarEditItem;
    beCash: TcxBarEditItem;
    beExerciseAssigns: TcxBarEditItem;
    beMatchedTaxLots: TcxBarEditItem;
    beViewTime: TcxBarEditItem;
    beViewOptionTk: TcxBarEditItem;
    beViewStrategy: TcxBarEditItem;
    beViewMatched: TcxBarEditItem;
    beViewWSHoldDt: TcxBarEditItem;
    beViewNotes: TcxBarEditItem;
    beView8949Code: TcxBarEditItem;
    beViewWashSales: TcxBarEditItem;
    bbRecordsAdd: TdxBarLargeButton;
    bbRecordsInsert: TdxBarLargeButton;
    bbRecordsEdit: TdxBarLargeButton;
    bbRecordsDelete: TdxBarLargeButton;
    bbRecordsDeleteAll: TdxBarLargeButton;
    bbRecordsCut: TdxBarLargeButton;
    bbRecordsCopy: TdxBarLargeButton;
    bbRecordsPaste: TdxBarLargeButton;
    bbRecordsSelectAll: TdxBarLargeButton;
    bbEditLongShort: TdxBarLargeButton;
    bbEditStrategy: TdxBarLargeButton;
    bbEditTicker: TdxBarLargeButton;
    bbEditABCcode: TdxBarLargeButton;
    bbAccountAdd: TdxBarLargeButton;
    bbAccountBaseline: TdxBarLargeButton;
    bbAccountEdit: TdxBarLargeButton;
    bbAccountDelete: TdxBarLargeButton;
    bbAccountTransfer: TdxBarLargeButton;
    bbAccountChecklist: TdxBarLargeButton;
    bbAdjustCost: TdxBarLargeButton;
    bbAdjustCorporateAction: TdxBarLargeButton;
    bbAdjustExercise: TdxBarLargeButton;
    bbAdjustExpire: TdxBarLargeButton;
    bbMatchLot: TdxBarLargeButton;
    bbUnMatch: TdxBarLargeButton;
    bbMatchOrder: TdxBarLargeButton;
    bbMatchLS: TdxBarLargeButton;
    bbMatchForce: TdxBarLargeButton;
    bbReMatch: TdxBarLargeButton;
    bbMatchCalcWS: TdxBarLargeButton;
    dxBarLargeButton9: TdxBarLargeButton;
    dxBarLargeButton10: TdxBarLargeButton;
    beMatchWsShortNLong: TcxBarEditItem;
    cxBarEditItem2: TcxBarEditItem;
    beMatchWsUnderlying: TcxBarEditItem;
    dxBarSubItem1: TdxBarSubItem;
    beMatchWsClosedTrig: TcxBarEditItem;
    cxBarEditItem5: TcxBarEditItem;
    beMatchWsOpt2Stk: TcxBarEditItem;
    beMatchWsSTK2Opt: TcxBarEditItem;
    bbImportBaseLine: TdxBarLargeButton;
    bbImportAuto: TdxBarLargeButton;
    bbImportFile: TdxBarLargeButton;
    bbImportWeb: TdxBarLargeButton;
    bbImportExcel: TdxBarLargeButton;
    bbUndo_small: TdxBarButton;
    bbRedo_small: TdxBarButton;
    dxBarLargeButton1: TdxBarLargeButton;
    dxBarLargeButton2: TdxBarLargeButton;
    dxBarLargeButton3: TdxBarLargeButton;
    dxBarLargeButton4: TdxBarLargeButton;
    bbOptons: TdxBarButton;
    dxBarButton1: TdxBarButton;
    bbExit: TdxBarButton;
    bbNewOptions: TdxBarButton;
    dxBarButton2: TdxBarButton;
    dxBarApplicationMenu1: TdxBarApplicationMenu;
    RibbonMenu: TdxRibbon;
    dxBarLargeButton5: TdxBarLargeButton;
    dxBarLargeButton6: TdxBarLargeButton;
    dxBarLargeButton8: TdxBarLargeButton;
    dxBarLargeButton11: TdxBarLargeButton;
    dxBarLargeButton12: TdxBarLargeButton;
    dxBarLargeButton13: TdxBarLargeButton;
    dxBarLargeButton14: TdxBarLargeButton;
    dxBarLargeButton15: TdxBarLargeButton;
    dxBarLargeButton16: TdxBarLargeButton;
    dxBarLargeButton17: TdxBarLargeButton;
    dxBarLargeButton18: TdxBarLargeButton;
    dxBarLargeButton19: TdxBarLargeButton;
    dxBarLargeButton20: TdxBarLargeButton;
    dxBarLargeButton21: TdxBarLargeButton;
    dxBarLargeButton22: TdxBarLargeButton;
    dxBarLargeButton23: TdxBarLargeButton;
    dxBarLargeButton24: TdxBarLargeButton;
    dxBarLargeButton25: TdxBarLargeButton;
    dxBarLargeButton26: TdxBarLargeButton;
    dxBarLargeButton27: TdxBarLargeButton;
    cxBarEditItem1: TcxBarEditItem;
    dxBarButton3: TdxBarButton;
    dxBarDateCombo1: TdxBarDateCombo;
    dxBarSubItem2: TdxBarSubItem;
    dxBarButton4: TdxBarButton;
    cxBarEditItem3: TcxBarEditItem;
    cxBarEditItem4: TcxBarEditItem;
    dxBarEdit1: TdxBarEdit;
    dxBarLargeButton28: TdxBarLargeButton;
    dxBarLargeButton29: TdxBarLargeButton;
    dxBarLargeButton30: TdxBarLargeButton;
    dxBarLargeButton31: TdxBarLargeButton;
    dxBarLargeButton32: TdxBarLargeButton;
    dxBarLargeButton33: TdxBarLargeButton;
    dxBarLargeButton34: TdxBarLargeButton;
    dxBarLargeButton35: TdxBarLargeButton;
    dxBarLargeButton36: TdxBarLargeButton;
    dxBarLargeButton37: TdxBarLargeButton;
    dxBarLargeButton38: TdxBarLargeButton;
    dxBarLargeButton39: TdxBarLargeButton;
    dxBarLargeButton40: TdxBarLargeButton;
    dxBarLargeButton41: TdxBarLargeButton;
    dxBarLargeButton42: TdxBarLargeButton;
    dxBarLargeButton43: TdxBarLargeButton;
    mtFile: TdxRibbonTab;
    BMFileActions: TdxBar;
    bbFile_New: TdxBarLargeButton;
    bbFile_Open: TdxBarLargeButton;
    bbFile_Close: TdxBarLargeButton;
    BMCurrentFile: TdxBar;
    bbFile_Save: TdxBarLargeButton;
    bbFile_Edit: TdxBarLargeButton;
    bbFile_Backup: TdxBarLargeButton;
    BMYearEnd: TdxBar;
    bbFile_ReverseEndYear: TdxBarLargeButton;
    btnLastFile1: TdxBarButton;
    btnLastFile2: TdxBarButton;
    btnLastFile3: TdxBarButton;
    btnLastFile4: TdxBarButton;
    cxImageBig: TcxImageList;
    mtAccount: TdxRibbonTab;
    BMAccountActions: TdxBar;
    bbAccount_Add: TdxBarLargeButton;
    bbAccount_Delete: TdxBarLargeButton;
    bbAccount_Edit: TdxBarLargeButton;
    bbAccount_Transfer: TdxBarLargeButton;
    bbAccount_YearEndChecklist: TdxBarLargeButton;
    bbAccounts_Commission: TdxBarLargeButton;
    dxBarLargeButton68: TdxBarLargeButton;
    dxBarLargeButton69: TdxBarLargeButton;
    dxBarLargeButton74: TdxBarLargeButton;
    bbAdjustments_StockSplit: TdxBarLargeButton;
    bbAdjustments_CostBasis: TdxBarLargeButton;
    bbAdjustments_Expire: TdxBarLargeButton;
    bbAdjustments_Exercise: TdxBarLargeButton;
    dxBarLargeButton92: TdxBarLargeButton;
    mtRecords: TdxRibbonTab;
    mtFind: TdxRibbonTab;
    mtReports: TdxRibbonTab;
    mtHelp: TdxRibbonTab;
    dxBarManager1Bar48: TdxBar;
    bbRecords_AddRecord: TdxBarLargeButton;
    bbRecords_EnterBaselinePositions: TdxBarLargeButton;
    bbRecords_InsertRecord: TdxBarLargeButton;
    dxBarManager1Bar49: TdxBar;
    dxBarManager1Bar50: TdxBar;
    bbFind_Ticker: TdxBarLargeButton;
    bbFind_TradeNo: TdxBarLargeButton;
    dxBarSubItem3: TdxBarSubItem;
    dxBarLargeButton99: TdxBarLargeButton;
    dxBarLargeButton100: TdxBarLargeButton;
    dxBarLargeButton101: TdxBarLargeButton;
    dxBarLargeButton102: TdxBarLargeButton;
    dxBarLargeButton103: TdxBarLargeButton;
    dxBarLargeButton104: TdxBarLargeButton;
    dxBarLargeButton105: TdxBarLargeButton;
    dxBarLargeButton106: TdxBarLargeButton;
    dxBarLargeButton107: TdxBarLargeButton;
    dxBarLargeButton108: TdxBarLargeButton;
    dxBarManager1Bar58: TdxBar;
    dxBarManager1Bar59: TdxBar;
    dxBarManager1Bar61: TdxBar;
    dxBarManager1Bar62: TdxBar;
    dxBarLargeButton112: TdxBarLargeButton;
    dxBarLargeButton113: TdxBarLargeButton;
    dxBarLargeButton114: TdxBarLargeButton;
    dxBarLargeButton115: TdxBarLargeButton;
    dxBarLargeButton116: TdxBarLargeButton;
    dxBarLargeButton117: TdxBarLargeButton;
    dxBarLargeButton118: TdxBarLargeButton;
    dxBarLargeButton119: TdxBarLargeButton;
    dxBarLargeButton120: TdxBarLargeButton;
    dxBarLargeButton121: TdxBarLargeButton;
    dxBarLargeButton122: TdxBarLargeButton;
    dxBarLargeButton123: TdxBarLargeButton;
    dxBarLargeButton124: TdxBarLargeButton;
    dxBarButton13: TdxBarButton;
    bbReports_ForexCurrencies: TdxBarButton;
    bbReports_GainsLosses: TdxBarButton;
    bbReports_Section1256: TdxBarButton;
    bbReports_Sec475: TdxBarButton;
    dxBarButton20: TdxBarButton;
    dxBarButton21: TdxBarButton;
    dxBarButton22: TdxBarButton;
    dxBarButton23: TdxBarButton;
    dxBarButton24: TdxBarButton;
    dxBarButton25: TdxBarButton;
    dxBarButton26: TdxBarButton;
    bbReports_Detail: TdxBarButton;
    dxBarButton28: TdxBarButton;
    bbReports_Summary: TdxBarButton;
    dxBarLargeButton125: TdxBarLargeButton;
    dxBarLargeButton126: TdxBarLargeButton;
    dxBarLargeButton127: TdxBarLargeButton;
    dxBarLargeButton128: TdxBarLargeButton;
    dxBarLargeButton129: TdxBarLargeButton;
    dxBarLargeButton130: TdxBarLargeButton;
    dxBarLargeButton131: TdxBarLargeButton;
    dxBarLargeButton132: TdxBarLargeButton;
    dxBarLargeButton133: TdxBarLargeButton;
    dxBarLargeButton134: TdxBarLargeButton;
    dxBarManager1Bar65: TdxBar;
    bbHelp_SupportCenter: TdxBarLargeButton;
    dxBarLargeButton138: TdxBarLargeButton;
    dxBarLargeButton141: TdxBarLargeButton;
    dxBarLargeButton142: TdxBarLargeButton;
    bbHelp_GetSupport: TdxBarLargeButton;
    bbHelp_DebugLogging: TdxBarLargeButton;
    bbHelp_About: TdxBarLargeButton;
    bbHelp_DebugLevel: TdxBarLargeButton;
    cxBarEditItem6: TcxBarEditItem;
    chViewWashSales: TcxBarEditItem;
    chViewQuickStart: TcxBarEditItem;
    cxBarEditItem14: TcxBarEditItem;
    dxBarButton30: TdxBarButton;
    dxBarLargeButton149: TdxBarLargeButton;
    dxBarSubItem4: TdxBarSubItem;
    cxBarEditItem17: TcxBarEditItem;
    cxBarEditItem18: TcxBarEditItem;
    cxBarEditItem19: TcxBarEditItem;
    dxBarCombo1: TdxBarCombo;
    cxBarEditItem20: TcxBarEditItem;
    cxBarEditItem21: TcxBarEditItem;
    cxBarEditItem22: TcxBarEditItem;
    cxBarEditItem23: TcxBarEditItem;
    bbReports_WashSaleDetails: TdxBarButton;
    dxBarButton32: TdxBarButton;
    dxBarButton33: TdxBarButton;
    bbReports_Form8949: TdxBarLargeButton;
    dxBarLargeButton153: TdxBarLargeButton;
    dxBarLargeButton154: TdxBarLargeButton;
    dxBarButton36: TdxBarButton;
    dxBarButton37: TdxBarButton;
    dxBarButton38: TdxBarButton;
    dxBarStatic1: TdxBarStatic;
    btnBaseline: TdxBarLargeButton;
    mtUser: TdxRibbonTab;
    dxBarManager1Bar3: TdxBar;
    dxBarButton43: TdxBarButton;
    bbFind_GridFilter: TdxBarLargeButton;
    bbFind_Advanced: TdxBarLargeButton;
    cxBarEditItem24: TcxBarEditItem;
    bbFind_Adjusted: TdxBarCombo;
    bbFind_ErrorCheck: TdxBarCombo;
    bbFind_Accounts: TdxBarCombo;
    cxImageList2: TcxImageList;
    dxBarLargeButton53: TdxBarLargeButton;
    bbAccount_Baselines: TdxBarLargeButton;
    dxBarManager1Bar5: TdxBar;
    bbRecords_Edit: TdxBarLargeButton;
    bbRecords_SplitTrade: TdxBarLargeButton;
    bbRecords_ConsolidatePartialFills: TdxBarLargeButton;
    dxBarManager1Bar6: TdxBar;
    bbRecords_Transfer: TdxBarLargeButton;
    bbRecords_Copy: TdxBarLargeButton;
    bbRecords_Paste: TdxBarLargeButton;
    bbRecords_SelectAll: TdxBarLargeButton;
    dxBarManager1Bar7: TdxBar;
    bbRecords_Delete: TdxBarLargeButton;
    bbRecords_DeleteAll: TdxBarLargeButton;
    mtAdjust: TdxRibbonTab;
    dxBarManager1Bar11: TdxBar;
    dxBarManager1Bar12: TdxBar;
    dxBarLargeButton71: TdxBarLargeButton;
    btnHelp: TRzToolButton;
    cxImageSmall: TcxImageList;
    dxSkinController1: TdxSkinController;
    bbReports_YearEndChecklist: TdxBarLargeButton;
    bbReports_Performance: TdxBarLargeButton;
    bbReports_Chart: TdxBarLargeButton;
    bbReports_RealizedPL: TdxBarButton;
    bbReports_PotentialWashSales: TdxBarLargeButton;
    bbReports_Reconcile1099: TdxBarButton;
    pnlBlue: TPanel;
    RzSeparator1: TRzSeparator;
    RzSeparator2: TRzSeparator;
    RzSeparator3: TRzSeparator;
    RzSeparator4: TRzSeparator;
    RzSeparator5: TRzSeparator;
    Panel5: TPanel;
    RzToolButton6: TRzToolButton;
    RzToolButton5: TRzToolButton;
    RzToolButton1: TRzToolButton;
    Panel6: TPanel;
    txtNumRecs: TLabel;
    cxLabel1: TcxLabel;
    Panel7: TPanel;
    txtLastImp: TLabel;
    cxLabel2: TcxLabel;
    Panel8: TPanel;
    txtCommis: TLabel;
    cxLabel3: TcxLabel;
    Panel9: TPanel;
    txtProfit: TLabel;
    cxLabel4: TcxLabel;
    Panel10: TPanel;
    txtContrOpen: TLabel;
    cxLabel5: TcxLabel;
    Panel2: TPanel;
    txtSharesOpen: TLabel;
    cxLabel6: TcxLabel;
    RzSeparator6: TRzSeparator;
    bbUser_WSsettings: TdxBarLargeButton;
    grpWashSales: TGroupBox;
    cbAdjWash: TCheckBox;
    rbStatusBar: TdxRibbonStatusBar;
    checkbox: TcxBarEditItem;
    dxBarButton5: TdxBarButton;
    bbUser_Register: TdxBarLargeButton;
    bbHelp_Update: TdxBarLargeButton;
    bbFile_mruLastFile: TdxBarMRUListItem;
    bbAdjustments_AdjCode: TdxBarLargeButton;
    bbUser_TradeTypeSettings: TdxBarLargeButton;
    dxBarLargeButton70: TdxBarLargeButton;
    bbFind_FindInstrument: TcxBarEditItem;
    bbFind_Blank: TcxBarEditItem;
    btnManualEntry: TdxBarLargeButton;
    bbFind_DateRange: TdxBarLargeButton;
    cxBarEditItem9: TcxBarEditItem;
    cxBarEditItem10: TcxBarEditItem;
    RzToolButton2: TRzToolButton;
    RzToolButton3: TRzToolButton;
    bbUndo_Large: TRzToolButton;
    bbRedo_large: TRzToolButton;
    BMWashSaleSettings: TdxBar;
    bbFile_WashSale: TdxBarLargeButton;
    BMYearEndCheckList: TdxBar;
    BMImportTradeHistory: TdxBar;
    bbAccount_ImportSettings: TdxBarLargeButton;
    bbAccount_FromFile: TdxBarLargeButton;
    bbAccount_FromExcel: TdxBarLargeButton;
    bbAccount_BrokerConnect: TdxBarLargeButton;
    dxBarManager1Bar16: TdxBar;
    dxBarManager1Bar17: TdxBar;
    bbAdjustments_Match: TdxBarLargeButton;
    bbAdjustments_UnMatch: TdxBarLargeButton;
    bbAdjustments_Reorder: TdxBarLargeButton;
    bbAdjustments_LongShort: TdxBarLargeButton;
    bbAdjustments_ForceMatch: TdxBarLargeButton;
    bbAdjustments_Rematch: TdxBarLargeButton;
    dxBarManager1Bar18: TdxBar;
    bbAdjustments_Ticker: TdxBarLargeButton;
    bbAdjustments_TypeMult: TdxBarLargeButton;
    dxBarManager1Bar19: TdxBar;
    bbAdjustments_StockDescrToTicker: TdxBarLargeButton;
    bbAdjustments_CusipToTicker: TdxBarLargeButton;
    dxBarManager1Bar20: TdxBar;
    bbRecords_AssignStrategy: TdxBarLargeButton;
    bbRecords_Note: TdxBarLargeButton;
    bbFile_EndTaxYear: TdxBarLargeButton;
    dxBarManager1Bar21: TdxBar;
    bbUser_Matched: TcxBarEditItem;
    bbUser_Notes: TcxBarEditItem;
    bbUser_OptionTickers: TcxBarEditItem;
    bbUser_Strategies: TcxBarEditItem;
    bbUser_Time: TcxBarEditItem;
    bbUser_Adjust: TcxBarEditItem;
    bbUser_WashSaleHoldings: TcxBarEditItem;
    dxBarManager1Bar22: TdxBar;
    bbUser_WashSales: TdxBarButton;
    bbUser_QuickStart: TdxBarButton;
    bbReports_Setup: TdxBarLargeButton;
    tblTabs: TdxMemData;
    tblTabsProcess: TStringField;
    tblTabsFile: TBooleanField;
    tblTabsbbFile_Open: TBooleanField;
    tblTabsbbFile_mruLastFile: TBooleanField;
    tblTabsbbFile_Close: TBooleanField;
    tblTabsbbFile_Save: TBooleanField;
    tblTabsbbFile_Edit: TBooleanField;
    tblTabsbbFile_Backup: TBooleanField;
    tblTabsbbFile_WashSale: TBooleanField;
    tblTabsbbFile_EndTaxYear: TBooleanField;
    tblTabsbbFile_ReverseEndYear: TBooleanField;
    tblTabsbbAccount_Add: TBooleanField;
    tblTabsbbAccount_Baselines: TBooleanField;
    tblTabsbbAccount_Edit: TBooleanField;
    tblTabsbbAccount_Delete: TBooleanField;
    tblTabsbbAccount_Transfer: TBooleanField;
    tblTabsbbAccount_YearEndChecklist: TBooleanField;
    tblTabsbbAccount_ImportSettings: TBooleanField;
    tblTabsbbAccount_BrokerConnect: TBooleanField;
    tblTabsbbAccount_FromFile: TBooleanField;
    tblTabsbbAccount_FromExcel: TBooleanField;
    tblTabsbbRecords_AddRecord: TBooleanField;
    tblTabsbbRecords_InsertRecord: TBooleanField;
    tblTabsbbRecords_EnterBaselinePositions: TBooleanField;
    tblTabsbbRecords_Edit: TBooleanField;
    tblTabsbbRecords_SplitTrade: TBooleanField;
    tblTabsbbRecords_ConsolidatePartialFills: TBooleanField;
    tblTabsbbRecords_Transfer: TBooleanField;
    tblTabsbbRecords_Copy: TBooleanField;
    tblTabsbbRecords_Paste: TBooleanField;
    tblTabsbbRecords_SelectAll: TBooleanField;
    tblTabsbbRecords_Delete: TBooleanField;
    tblTabsbbRecords_DeleteAll: TBooleanField;
    tblTabsbbRecords_AssignStrategy: TBooleanField;
    tblTabsbbRecords_Note: TBooleanField;
    tblTabsbbAdjustments_CostBasis: TBooleanField;
    tblTabsbbAdjustments_AdjCode: TBooleanField;
    tblTabsbbAdjustments_StockSplit: TBooleanField;
    tblTabsbbAdjustments_Exercise: TBooleanField;
    tblTabsbbAdjustments_Expire: TBooleanField;
    tblTabsbbAdjustments_Match: TBooleanField;
    tblTabsbbAdjustments_UnMatch: TBooleanField;
    tblTabsbbAdjustments_Reorder: TBooleanField;
    tblTabsbbAdjustments_LongShort: TBooleanField;
    tblTabsbbAdjustments_ForceMatch: TBooleanField;
    tblTabsbbAdjustments_Rematch: TBooleanField;
    tblTabsbbAdjustments_Ticker: TBooleanField;
    tblTabsbbAdjustments_TypeMult: TBooleanField;
    tblTabsbbAdjustments_StockDescrToTicker: TBooleanField;
    tblTabsbbAdjustments_CusipToTicker: TBooleanField;
    tblTabsbbFind_GridFilter: TBooleanField;
    tblTabsbbFind_Advanced: TBooleanField;
    tblTabsbbFind_Ticker: TBooleanField;
    tblTabsbbFind_TradeNo: TBooleanField;
    tblTabsbbFind_DateRange: TBooleanField;
    tblTabsbbFind_FindInstrument: TBooleanField;
    tblTabsbbFind_Adjusted: TBooleanField;
    tblTabsbbFind_ErrorCheck: TBooleanField;
    tblTabsbbFind_Accounts: TBooleanField;
    tblTabsbbFind_Blank: TBooleanField;
    tblTabsbbReports_YearEndChecklist: TBooleanField;
    tblTabsbbReports_PotentialWashSales: TBooleanField;
    tblTabsbbReports_Reconcile1099: TBooleanField;
    tblTabsbbReports_WashSaleDetails: TBooleanField;
    tblTabsbbReports_Form8949: TBooleanField;
    tblTabsbbReports_GainsLosses: TBooleanField;
    tblTabsbbReports_Section1256: TBooleanField;
    tblTabsbbReports_ForexCurrencies: TBooleanField;
    tblTabsbbReports_Sec475: TBooleanField;
    tblTabsbbReports_Performance: TBooleanField;
    tblTabsbbReports_Chart: TBooleanField;
    tblTabsbbReports_RealizedPL: TBooleanField;
    tblTabsbbReports_Detail: TBooleanField;
    tblTabsbbReports_Summary: TBooleanField;
    tblTabsbbReports_Setup: TBooleanField;
    tblTabsbbUser_VisualThemes: TBooleanField;
    tblTabsbbUser_WSsettings: TBooleanField;
    tblTabsbbUser_TradeTypeSettings: TBooleanField;
    tblTabsbbUser_Register: TBooleanField;
    tblTabsbbUser_Matched: TBooleanField;
    tblTabsbbUser_Notes: TBooleanField;
    tblTabsbbUser_OptionTickers: TBooleanField;
    tblTabsbbUser_Strategies: TBooleanField;
    tblTabsbbUser_Time: TBooleanField;
    tblTabsbbUser_Adjust: TBooleanField;
    tblTabsbbUser_WashSaleHoldings: TBooleanField;
    tblTabsbbUser_WashSales: TBooleanField;
    tblTabsbbUser_QuickStart: TBooleanField;
    tblTabsbbHelp_SupportCenter: TBooleanField;
    tblTabsbbHelp_GetSupport: TBooleanField;
    tblTabsbbHelp_About: TBooleanField;
    tblTabsbbHelp_Updat: TBooleanField;
    bbUser_TaxFiles: TdxBarLargeButton;
    mtSuperUser: TdxRibbonTab;
    dxBarManager1Bar1: TdxBar;
    bbSuper_TaxFiles: TdxBarLargeButton;
    bbSuper_Code: TdxBarLargeButton;
    bbFTPdownload: TdxBarButton;
    bbSuper_GetFTP: TdxBarLargeButton;
    stAcctName: TRzStatusPane;
    bbSuper_Test: TdxBarLargeButton;
    btnImportHelp: TdxBarLargeButton;
    bbSuper_DebugLevel: TdxBarLargeButton;
    btnBackOffice: TdxBarLargeButton;
    btnGetBeta: TdxBarLargeButton;
    tblTabsbtnGetBeta: TStringField;
    bbReports_AllRpts: TdxBarLargeButton;
    cbInc8949Summary: TCheckBox;
    btnHelp8949Rpt: TcxButton;
    Label1: TLabel;
    cbForm8949: TCheckBox;
    dxBarButton6: TdxBarButton;
    // --------------------------------
    procedure tmrFileDLTimer(Sender: TObject);
//    procedure QuickStartClick(Sender: TObject);
//    procedure Stocks1Click(Sender: TObject);
    procedure Stocks2Click(Sender: TObject);
//    procedure findGridFilter1Click(Sender: TObject);
    procedure ExercisesAssigns1Click(Sender: TObject);
    procedure ExerciseAssign1Click(Sender: TObject);
    procedure MatchedTaxLots1Click(Sender: TObject);
    procedure Sales1Click(Sender: TObject);
    procedure Purchases1Click(Sender: TObject);
    procedure ShowAllTrades;
    procedure actnShowAllClick(Sender: TObject);
    procedure actnShowOpenClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure actnShowRangeClick(Sender: TObject);
    procedure actnClosedClick(Sender: TObject);
    procedure actnDelClick(Sender: TObject);
    procedure DeleteSelectedRecClick(Sender: TObject);
    procedure DeleteAll1Click(Sender: TObject);
    procedure Commision1Click(Sender: TObject);

    procedure mnuFileEdit;

    procedure mnuFile_EditClick(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Trades1Click(Sender: TObject);

    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ProcessCommandLineOptions;
    procedure FormResize(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

    // routines from menu event handlers
    procedure mnuFileNew;

    procedure btnImportClick(Sender: TObject);
    procedure EditRec1Click(Sender: TObject);
    procedure DisableIfNoFileOpen;
    procedure Register1Click(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure SelectAllClick(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure CopySumClick(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure lblPurchaseClick(Sender: TObject);
    procedure actnCopyClick(Sender: TObject);
    procedure changeTick1Click(Sender: TObject);
//    procedure ConvertOldDataFiles1Click(Sender: TObject);
    procedure ImageGTTClick(Sender: TObject);
    procedure Update1Click(Sender: TObject);
    procedure TaxYearHelpClick(Sender: TObject);
    procedure PageSetup1Click(Sender: TObject);
    procedure ReOrderTradeNumbers1Click(Sender: TObject);
    procedure ToggleShortLong1Click(Sender: TObject);
    procedure Paste1Click(Sender: TObject);
    procedure mnuFile_EndTaxYearClick(Sender: TObject);
    procedure ReverseEndYear1Click(Sender: TObject);
    procedure FixNegSharesOpen1Click(Sender: TObject);
    procedure actnFilterEnableClick(Sender: TObject);
    procedure Perf1Click(Sender: TObject);
    procedure FormEndDock(Sender, Target: TObject; X, Y: Integer);
    procedure Chart1Click(Sender: TObject);
    procedure Undo1Click(Sender: TObject);
    procedure Tutorial1Click(Sender: TObject);
    procedure actnUndoClick(Sender: TObject);
    procedure CutClick(Sender: TObject);
    procedure OpenRecentFile(i : integer); // 2022-04-13 MB bugfix

    procedure LastFile1Click(Sender: TObject);
    procedure LastFile2Click(Sender: TObject);
    procedure LastFile3Click(Sender: TObject);
    procedure LastFile4Click(Sender: TObject);

    procedure cbMTMClick(Sender: TObject);
    procedure cbSec481Click(Sender: TObject);
    procedure cbAdjWashClick(Sender: TObject);
    procedure cbParameterChange(Sender: TObject);
    procedure FAQHelp1Click(Sender: TObject);
    procedure cxGrid1TableView1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cxGrid1TableView1DataControllerSortingChanged(Sender: TObject);
    procedure cxGrid1TableView1DblClick(Sender: TObject);
    procedure cxGrid1TableView1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure cxGrid1TableView1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure cxGrid1TableView1FocusedRecordChanged
      (Sender: TcxCustomGridTableView;
      APrevFocusedRecord, AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
    procedure actnDelRecClick(Sender: TObject);
    procedure actnInsRecClick(Sender: TObject);
    procedure actnAddRecClick(Sender: TObject);
    // --- when a grid cell value changes -------
    procedure cxGrid_1_TrNumPropertiesEditValueChanged(Sender: TObject);
    procedure cxGrid_2_DatePropertiesEditValueChanged(Sender: TObject);
    procedure cxGrid_3_TimePropertiesEditValueChanged(Sender: TObject);
    procedure cxGrid_4_OCPropertiesEditValueChanged(Sender: TObject);
    procedure cxGrid_5_LSPropertiesEditValueChanged(Sender: TObject);
    procedure cxGrid_6_TickerPropertiesEditValueChanged(Sender: TObject);
    procedure cxGrid_7_SharesPropertiesEditValueChanged(Sender: TObject);
    procedure cxGrid_8_PricePropertiesEditValueChanged(Sender: TObject);
    procedure cxGrid_9_PRFPropertiesEditValueChanged(Sender: TObject);
    procedure cxGrid_10_CommPropertiesEditValueChanged(Sender: TObject);
    procedure cxGrid_11_AmountPropertiesEditValueChanged(Sender: TObject);

    procedure cxGrid_16_opTkPropertiesEditValueChanged(Sender: TObject);
    procedure cxGrid_19_StrategyPropertiesEditValueChanged(Sender: TObject);
    // ---
    procedure actnFilterCustomClick(Sender: TObject);
    procedure cxGrid1TableView1DataControllerFilterChanged(Sender: TObject);
    procedure FindAllStocks1Click(Sender: TObject);
    procedure FindAllOptions1Click(Sender: TObject);
    procedure FindAllSingleStockFutures1Click(Sender: TObject);
    procedure FindAllFutures1Click(Sender: TObject);
    procedure AllStocksandOptionsandSSFs1Click(Sender: TObject);
    procedure cxGrid1TableView1CustomDrawCell(Sender: TcxCustomGridTableView;
      ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;
      var ADone: Boolean);
    procedure DeleteALLRecords1Click(Sender: TObject);
    procedure ToggleShortLongorLongShort1Click(Sender: TObject);
    procedure cxGrid1TableView1Editing(Sender: TcxCustomGridTableView;
      AItem: TcxCustomGridTableItem; var AAllow: Boolean);
    procedure DisplayNotesClick(Sender: TObject);
    procedure DisplayWashSalesClick(Sender: TObject);

    procedure mnuFileSave;

    procedure Save1Click(Sender: TObject);
    procedure TradesSummaryClick(Sender: TObject);
    procedure Currencies1Click(Sender: TObject);
    procedure Ticker1Click(Sender: TObject);
    procedure TrNum1Click(Sender: TObject);
    procedure Short1Click(Sender: TObject);
    procedure Long1Click(Sender: TObject);
    procedure Options2Click(Sender: TObject);
    procedure SingleStockFutures1Click(Sender: TObject);
    procedure StocksOptionsandSSFs1Click(Sender: TObject);
    procedure Currencies2Click(Sender: TObject);
    procedure Futures1Click(Sender: TObject);
    procedure ReadMe1Click(Sender: TObject);
    procedure cbTickClick(Sender: TObject);
    procedure cbDateClick(Sender: TObject);
    procedure cbTrNumClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Save2Click(Sender: TObject);
    procedure MatchTaxLots1Click(Sender: TObject);
    procedure MatchTaxLots2Click(Sender: TObject);
    procedure UnMatchTaxLots1Click(Sender: TObject);
    procedure cxGrid_11_AmountPropertiesChange(Sender: TObject);
    procedure ExpireOptions1Click(Sender: TObject);
    procedure Purchase1Click(Sender: TObject);
    procedure DuplicateTrades1Click(Sender: TObject);
    procedure AdjustforStockSplit2Click(Sender: TObject);
    procedure AdjustforStockSplit1Click(Sender: TObject);
//    procedure Combine1ClickNew(Sender: TObject);
    procedure whatsnewClick(Sender: TObject);
    procedure cb4797Click(Sender: TObject);
    procedure cxGrid1TableView1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cxGrid1TableView1StartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure Fix1Click(Sender: TObject);
    procedure AddRecord1Click(Sender: TObject);
    procedure InsertRecord1Click(Sender: TObject);
    procedure ChangeOptionTickers1Click(Sender: TObject);
    procedure cxGrid1TableView1DataControllerCompare
      (ADataController: TcxCustomDataController; ARecordIndex1, ARecordIndex2,
      AItemIndex: Integer; const V1, V2: Variant; var Compare: Integer);
    procedure cxGrid1TableView1FocusedItemChanged
      (Sender: TcxCustomGridTableView;
      APrevFocusedItem, AFocusedItem: TcxCustomGridTableItem);
    procedure glEndDatePropertiesEditValueChanged(Sender: TObject);
    procedure dxBrokerConnect_Click(Sender: TObject);
    procedure ChangeStockDescrtoTickerSymbol1Click(Sender: TObject);
    procedure FreeTrSumList();
    function GetFilterDataFromPanel : String;
    procedure cxGrid1TableView1TopRecordIndexChanged(Sender: TObject);
    procedure txt1099KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MakeGLCalendarYear(First, Last: Variant);
    procedure DoRecon;
    procedure DoStocks(stkType: string = 'schedD'; ClrFilter : Boolean = True);
    procedure DoFutures(futType: string = 'FUT');
    procedure DoCurrencies;
    procedure glStartDatePropertiesEditValueChanged(Sender: TObject);
    function GetIRS_SSN(Warn: Boolean): Boolean;
    // procedure PageSetup();
    procedure spdRunReportClick(Sender: TObject);
    procedure glStartDatePropertiesValidate(Sender: TObject;
      var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
    procedure glEndDatePropertiesValidate(Sender: TObject;
      var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
    function OpenFileDialog(Filter, InitialDir, Title: string;
      var Path: string; var Files: TStringList; AllowMultiSelect: Boolean;
      NoReadOnly: Boolean): Boolean;
    procedure exitReportsClick(Sender: TObject);
    procedure pnl1099Exit(Sender: TObject);
//    procedure cbShowSSNClick(Sender: TObject);
    procedure cxGrid1TableView1FilterDialogShow(Sender: TcxCustomGridTableView;
      AItem: TcxCustomGridTableItem; var ADone: Boolean);
    procedure cxGrid_12_PLGetDisplayText(Sender: TcxCustomGridTableItem;
      ARecord: TcxCustomGridRecord; var AText: string);
    procedure cxGrid_11_AmountGetDisplayText(Sender: TcxCustomGridTableItem;
      ARecord: TcxCustomGridRecord; var AText: string);
    procedure cxGrid_10_CommGetDisplayText(Sender: TcxCustomGridTableItem;
      ARecord: TcxCustomGridRecord; var AText: string);
    procedure REDO1Click(Sender: TObject);
    procedure actnRedoClick(Sender: TObject);
    procedure cxGrid_3_TimeGetDisplayText(Sender: TcxCustomGridTableItem;
      ARecord: TcxCustomGridRecord; var AText: string);
    procedure cxGrid1TableView1ColumnHeaderClick(Sender: TcxGridTableView;
      AColumn: TcxGridColumn);
    procedure cxGrid1TableView1InitEdit(Sender: TcxCustomGridTableView;
      AItem: TcxCustomGridTableItem; AEdit: TcxCustomEdit);
    procedure cxGrid_2_DatePropertiesValidate(Sender: TObject;
      var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
    procedure cxGrid_1_TrNumPropertiesValidate(Sender: TObject;
      var DisplayValue: Variant; var ErrorText: TCaption;
      var Error: Boolean);
    procedure cxGrid_10_CommPropertiesValidate(Sender: TObject;
      var DisplayValue: Variant; var ErrorText: TCaption;
      var Error: Boolean);
    procedure cxGrid_3_TimePropertiesValidate(Sender: TObject;
      var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
    procedure cbD1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cbD1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure GridEscape;
    procedure SaveFileFromGrid();
    procedure miSendFilesClick(Sender: TObject);
    procedure GlobalOptions1Click(Sender: TObject);

    procedure bindStrategy();
    procedure AssignStrategy1Click(Sender: TObject);
    procedure CloseFileIfAny;
    procedure Close1Click(Sender: TObject);
    procedure SetChartParams(NewSel: Boolean = true);
    procedure SetChartParms(Sender: TObject);
    procedure btnTODsetupClick(Sender: TObject);
    function HelpRouter1Help(Command: Word; Data: Integer;
      var CallHelp: Boolean): Boolean;
    procedure onlineSupportpage1Click(Sender: TObject);
    procedure DisplayOptionTickers1Click(Sender: TObject);
    procedure DisplayTime1Click(Sender: TObject);
    procedure DisplayStrategies1Click(Sender: TObject);
    procedure DisplayMatchedTaxLots1Click(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure changeCusip1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnFAQClick(Sender: TObject);
    procedure btnTutorialsClick(Sender: TObject);
    procedure btnSampleDataClick(Sender: TObject);
    procedure EnterOpenPositions1Click(Sender: TObject);
    procedure statRegDaysLeftClick(Sender: TObject);
    procedure statRegTxtClick(Sender: TObject);
//    procedure StatRecsLimitClick(Sender: TObject);
    procedure Splitter1CanResize(Sender: TObject; var NewSize: Integer;
      var Accept: Boolean);
    procedure MutualFunds1Click(Sender: TObject);
    procedure Drips1Click(Sender: TObject);
    procedure ChangeTypeMult1Click(Sender: TObject);
    procedure cxGrid_16_brGetDisplayText(Sender: TcxCustomGridTableItem;
      ARecord: TcxCustomGridRecord; var AText: string);
    procedure ETFETNs1Click(Sender: TObject);
    procedure cxGrid_7_SharesPropertiesValidate(Sender: TObject;
      var DisplayValue: Variant; var ErrorText: TCaption;
      var Error: Boolean);
    procedure mnu8949Click(Sender: TObject);
    procedure Display8949CodeClick(Sender: TObject);
    procedure MainMenuClick(Sender: TObject);
    procedure DiscoverExerciseAssigns;
    procedure TransferOpensToAcct; // 2023-03-09 MB
    procedure TransferOpenPositions1Click(Sender: TObject);
    procedure InvalidTickers1Click(Sender: TObject);
    procedure cxGrid_8_PricePropertiesValidate(Sender: TObject;
      var DisplayValue: Variant; var ErrorText: TCaption;
      var Error: Boolean);
    procedure cxGrid_11_AmountPropertiesValidate(Sender: TObject;
      var DisplayValue: Variant; var ErrorText: TCaption;
      var Error: Boolean);
    procedure cxGrid_9_PRFPropertiesValidate(Sender: TObject; var DisplayValue: Variant;
      var ErrorText: TCaption; var Error: Boolean);
    procedure LookupTickerClick(Sender: TObject);

    procedure mnuAcct_EditClick(Sender: TObject);
    procedure mnuAcct_AddClick(Sender: TObject);
    procedure mnuAcct_ImportClick(Sender: TObject);

    procedure tabAccountsChange(Sender: TObject);
    procedure DeleteAccount1Click(Sender: TObject);
    procedure MTMAccounts1Click(Sender: TObject);
    procedure IRAAccounts1Click(Sender: TObject);
    procedure CashAccounts1Click(Sender: TObject);
    procedure Reconcile1099B1Click(Sender: TObject);
    procedure WashSaleDetails1Click(Sender: TObject);
    procedure Form1040ScheduleD1Click(Sender: TObject);
    procedure GLScheduleDD1Substitute1Click(Sender: TObject);
    procedure Form6781Futures1Click(Sender: TObject);
    procedure SetupForGains(AllAccounts : Boolean = false);
    procedure ForexCurrencies1Click(Sender: TObject);
    procedure Form4797MTM1Click(Sender: TObject);
    procedure GainsLossesAllAccounts1Click(Sender: TObject);
    procedure btnAddAcctDropDownMenuPopup(Sender: TObject; var APopupMenu: TPopupMenu;
      var AHandled: Boolean);
    procedure tabAccountsMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure StatBarAccountType;
    procedure cxGrid1TableView1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure TabAccountsChanging(Sender: TObject; NewIndex: Integer; var AllowChange: Boolean);
    procedure pupAccountPopup(Sender: TObject);
    procedure GoToInAccountTab1Click(Sender: TObject);
    procedure cxGrid_4_OCPropertiesValidate(Sender: TObject; var DisplayValue: Variant;
      var ErrorText: TCaption; var Error: Boolean);
    procedure cxGrid_6_TickerPropertiesValidate(Sender: TObject; var DisplayValue: Variant;
      var ErrorText: TCaption; var Error: Boolean);
    procedure cxGrid_5_LSPropertiesValidate(Sender: TObject; var DisplayValue: Variant;
      var ErrorText: TCaption; var Error: Boolean);
    procedure stUpdateMsgMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure btnCopyMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure cxGrid_13_NotesGetCellHint(Sender: TcxCustomGridTableItem;
      ARecord: TcxCustomGridRecord; ACellViewInfo: TcxGridTableDataCellViewInfo;
      const AMousePos: TPoint; var AHintText: TCaption; var AIsHintMultiLine: Boolean;
      var AHintTextRect: TRect);
    procedure cxHintShowHint(Sender: TObject; var HintStr: string;
      var CanShow: Boolean; var HintInfo: THintInfo);
    procedure DisplayWashSaleHoldingDate1Click(Sender: TObject);
    procedure cxGrid_22_WSHoldingDatePropertiesValidate(Sender: TObject; var DisplayValue: Variant;
      var ErrorText: TCaption; var Error: Boolean);
    procedure EndYearCheckList1Click(Sender: TObject);
    procedure DebugLogging1Click(Sender: TObject);
    procedure BackupRestore1Click(Sender: TObject);
    procedure lbFilterDblClick(Sender: TObject);
    procedure PotentialWashSales1Click(Sender: TObject);
    procedure mnuBaselinePositionWizardClick(Sender: TObject);
    procedure cbIncludeStatementClick(Sender: TObject);
    procedure cbIncludeAdjustmentClick(Sender: TObject);
    procedure btHelpStatementClick(Sender: TObject);
    procedure btnHelpOtherErrorsClick(Sender: TObject);
    procedure cbForm8949pdfMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cbShowSSNMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure AdjustforShortSaleDividend1Click(Sender: TObject);

    procedure mnuEdit_AdjustAmountClick(Sender: TObject);

    procedure cxGrid1TableView1SelectionChanged(
      Sender: TcxCustomGridTableView);
    procedure btnHelpClick(Sender: TObject);
    procedure Edit_SplitRecordClick(Sender: TObject);
    procedure Edit_ConsolidateClick(Sender: TObject);
    procedure mnuEdit_AssignNotesClick(Sender: TObject);

    //procedure mnuFile_ResetTaxFilesClick(Sender: TObject);
    procedure Add2Click(Sender: TObject);
    procedure Import1Click(Sender: TObject);

    procedure mnuFileResetUser;

    procedure mnuFile_ResetUserClick(Sender: TObject);
//    procedure mnuFile_ResetPWClick(Sender: TObject);
    procedure cxGrid1TableView1DataControllerFilterRecord(ADataController: TcxCustomDataController;
      ARecordIndex: Integer; var Accept: Boolean);
    procedure actnCheckListExecute(Sender: TObject);
    procedure DigCur1Click(Sender: TObject);
    procedure mnuFindVTNClick(Sender: TObject);
    procedure mnuFindCTNsClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure bbFile_mruLastFileClick(Sender: TObject);
    procedure btnBaselineClick(Sender: TObject);

    procedure btnFromFileClick(Sender: TObject);
    procedure btnFromWebClick(Sender: TObject);
    procedure btnFromExcelClick(Sender: TObject);
    procedure bbFind_AdjustedChange(Sender: TObject);
    procedure bbFind_ErrorCheckChange(Sender: TObject);
    procedure bbFind_AccountsChange(Sender: TObject);
    procedure bbUser_QuickStartClick(Sender: TObject);
    procedure bbRecords_ConsolidatePartialFillsClick(Sender: TObject);
    procedure bbRecords_EditClick(Sender: TObject);
    procedure bbRecords_SplitTradeClick(Sender: TObject);
    procedure bbRecords_DeleteAllClick(Sender: TObject);
    procedure bbRecords_DeleteClick(Sender: TObject);
    procedure btnAdjCodeClick(Sender: TObject);

    procedure getVisualThemeSkin;
    procedure bbUser_VisualThemesClick(Sender: TObject);
    procedure bbUser_WSsettingsClick(Sender: TObject);
    procedure bbUser_NotesChange(Sender: TObject);
    procedure bbUser_MatchedChange(Sender: TObject);
    procedure bbUser_OptionTickersChange(Sender: TObject);
    procedure bbUser_StrategiesClick(Sender: TObject);
    procedure bbUser_TimeClick(Sender: TObject);
    procedure bbUser_AdjustChange(Sender: TObject);
    procedure bbUser_WashSaleHoldingsChange(Sender: TObject);
    procedure bbUser_WashSalesClick(Sender: TObject);
    procedure dxImportSettingsClick(Sender: TObject);
    procedure bbFind_FindInstrumentPropertiesEditValueChanged(Sender: TObject);

    //procedure btnManualEntryClick(Sender: TObject);
    procedure bbReports_YearEndChecklistClick(Sender: TObject);
    procedure RzToolButton1Click(Sender: TObject);
    procedure bbFind_DateRangeClick(Sender: TObject);
    procedure Change8949Code1Click(Sender: TObject);
    procedure bbSuper_GetFTPClick(Sender: TObject);
    procedure bbSuper_TestClick(Sender: TObject);
    procedure btnImportHelpClick(Sender: TObject);
    procedure bbSuper_DebugLevelClick(Sender: TObject);
    procedure btnBackOfficeClick(Sender: TObject);
    procedure btnGetBetaClick(Sender: TObject);
    procedure bbReports_AllRptsClick(Sender: TObject);
    procedure bbUser_TaxFilesClick(Sender: TObject);
    procedure bbSuper_TaxFilesClick(Sender: TObject);
    procedure bbSuper_CodeClick(Sender: TObject);
    procedure bbFile_EditClick(Sender: TObject);
    procedure btnHelp8949RptClick(Sender: TObject);
    procedure cbForm8949Click(Sender: TObject);
//    procedure cbShowSSNClick(Sender: TObject);

  private
    dlgOF_Title: Pchar;
    miHint: TMenuItemHint;
    LastTabIndex : Integer;
    RowColors : TRowColorList;
    SettingUpTabs : Boolean;
    FHaltCustomDrawing: Boolean;
    TempIndex : Integer;
    FGridFilter: TGridFilter;
    FEditRec: Boolean;
    FInsertRec: Boolean;
    FAddRec: Boolean;
    FFilePassedIn : String;
    FAllTableClicked : boolean;
    FEscKeyPressed : boolean;

    procedure WMMenuSelect(var Msg: TWMMenuSelect); message WM_MENUSELECT;
    procedure CloseAdditionalForms;
    function UpdateFutureList(symbol, multStr: string) : Double;
    procedure SetWSDefer;
    function GetWindowsTempPath: String;
    procedure AppMessageProcedure(var Message: TMsg; var Handled: Boolean);
    procedure AppExceptionHandler(Sender : TObject; E : Exception);
    function changeFutSymbol(s: string): string;
    procedure CopyMenu(const dst, src: TMenuItem);
    procedure DoGlAll();
    procedure SetGridFilter(const Value: TGridFilter);
    procedure SetAddRec(const Value: Boolean);
    procedure SetEditRec(const Value: Boolean);
    procedure SetInsertRec(const Value: Boolean);
    procedure SetAddInsertEdit(Value : Boolean);
    procedure OpenFilePassedIn;
    procedure ResetFilterCombobox(combobox : string);
    procedure SetupTitleAndSummaryColors;
  public
    UserChangedTab : Boolean;
    procedure RemoveDuplicateOpenFileMenuItems;
    procedure SetupLastOpenFilesMenu;
    procedure DisableAllReports; // 2021-09-10 MB
    procedure SetupReportsMenu;
    function AddNewAccount(bSaveFile: Boolean = true) : Integer;

    function CheckCurrentAccount : TExitOperation;
    procedure SetOptions;
    procedure SetupTabs;
    procedure ChangeToTab(AccountName : String);

    function mnuFileOpen(DlgTitle: String = ''): Boolean;

    procedure FileStatusCallBack(Msg: String);
    procedure UpdateStatus(Msg: String; hint: String; color: TColor);
    procedure SetMenuBarVisibility(Visible: Boolean);
    procedure SetPopupMenuEnabled(menu: TPopupMenu; enable: Boolean);
    procedure SetupOpenCloseItems;
    function SaveTXF: Boolean;
    function SaveCSV: Boolean;
    procedure SetAccountOptions;
    procedure SetEditedTradesFilter(Trades: TTradeList);
    procedure SetupToolBarMenuBar(bGetCurrentPrices: Boolean);
    procedure EnableMenuToolsAll;
    procedure DisableMenuToolsAll;
    property HaltCustomDrawing : Boolean read FHaltCustomDrawing write FHaltCustomDrawing;
    property GridFilter : TGridFilter read FGridFilter write SetGridFilter;
    // Used to keep track of what operation was initiated
    property AddRec : Boolean read FAddRec write SetAddRec;
    property InsertRec : Boolean read FInsertRec write SetInsertRec;
    property EditRec : Boolean read FEditRec write SetEditRec;
    procedure EnableTabItems(value : string);
  end;

function ReportSetup(DisableMenus : Boolean = True): Boolean;
procedure SaveLastFileName(FileName: string);
function CopyTradesToClipboard(bColVis:Boolean): Integer;
procedure SpeedButtonsUp;
procedure AddRecord;
procedure BCImportDateRange(dt1, dt2 : TDate);


var
  frmMain: TfrmMain;
  StartDate, EndDate : Tdate;
  // Summary of trades used everywhere
  TradesSum: TTradesumArray;
  // For saving the filter in the grid
  MainFilterStream: TMemoryStream;
  TLstart : Boolean;
  FGridOdd, FGridEven : TColor; // RJ Jan 26, 21 add odd and even default colors
  gsMainErrMsg : string; // 2023-09-28 MB

implementation

uses
  // Tradelog Units
  RecordClasses, Reports, Commission, Import, // HelpMsg,
  TLRegister, SelectDateRange,
  OpenTrades, ReadMe, frmOFX, EditSplit, // frmOpTick,
  FileSave, // findStocks, // dateErr,
  frmSendSupportFiles, frmOption, frmAssignStrategy, ChartTimes, bcFunctions, // trial,
  frmPageSetupDlg, TLSettings, splash, messagePanel, TLUpdate,
  TypeMult, TLCommonLib, fm1099Info, TLExerciseAssign, ExerciseAssignList,
  Web, WebGet, //
  TLWinInet, WebBrowser, WBform,
  TLImportFilters, TLDataSources, underlying, AccountSetup, BrokerSelectDlg,
  PriceList, TLSupport, myInput, TlCharts, GainsLosses,
  //TLYodlee,
  dlgImport, dlgExcelWarn,
  //
  JCLDebug, JclHookExcept, StackTrace, OSIdentifier, //
  TL_API, frmBackOffice, TL_Passiv, // used for SuperUser functions
  //
  LoggingDialog, TLLogging, BackupRestoreDialog, TLDateUtils, baseline,
  shortSalesDiv, baseline1, TLEndYear, globalVariables, FastReportsData,
  dlgTaxfilePicker, dlgSuperUser, dlgAcctImport, dlgWashSales, GetStarted; // ManualEntry;

const
  CODE_SITE_CATEGORY = 'MainForm';

var
  wb: TWebBrowser;
  InLiveLogMode : Boolean;
  AlreadyLoaded : Boolean = false;
  nErrorCount : integer;

{$R *.DFM}


procedure TfrmMain.FreeTrSumList;
var
  I: Integer;
  TrSum: PTTrSum;
begin
  try
    if not assigned(TrSumList) then exit;
    try
      FreeAndNil(TrSumList);
      FreeAndNil(STDeferralDetails);
      FreeAndNil(IRADeferralDetails);
      FreeAndNil(NewTradesDeferralDetails);
    except
      mDlg('Could Not Free TrSumList.' + cr //
        + cr //
        + 'This is not critical, and should not cause any problems.',mtWarning,[mbOK],0);
    end;
  finally
    //
  end;
end; // FreeTrSumList


procedure TfrmMain.WMMenuSelect(var Msg: TWMMenuSelect);
begin
  inherited; // from TCustomForm
  ShowMenuHint(Msg, TForm(Self), miHint);
end;


procedure TfrmMain.OpenFilePassedIn;
var
  WindowsTempDir: String;
  OKToCopy: Boolean;
  TempDataDir: String;
  I: Integer;
  NewFileName: String;
  Done : Boolean;
begin
  try
    Done := False;
    if (Length(FFilePassedIn) = 0) then begin
      // no file passed in, so help user
    end
    else begin // a file WAS passed in, so open it
      TempDataDir := '';
      frmMain.Enabled := False; // 2019-02-14 MB for ETLFile Error
      // Move the file if it is in a temp location.
      WindowsTempDir := GetWindowsTempPath;
      // If this file was opened from a temporary location, such as via a download or email
      // attachment, we need to move it to a secure location where the imports and reports, etc.
      // can reside. We will prompt the user for a folder to store it in.
      repeat
        TempDataDir := ExtractFilePath(FFilePassedIn);
        if copy(TempDataDir, Length(TempDataDir), 1) = '\' then
          TempDataDir := copy(TempDataDir, 1, Length(TempDataDir) - 1);
        if (pos('LOCALS~', UpperCase(TempDataDir)) > 0) //
        or (pos('Temporary Internet Files', TempDataDir) > 0) //
        or (pos(UpperCase(WindowsTempDir), UpperCase(TempDataDir)) = 1) //
        then begin
          SaveDialog.Title := 'Please Pick a permanent location for this data file';
          SaveDialog.InitialDir := Settings.DataDir;
          NewFileName := ExtractFileName(FFilePassedIn);
          // Just in case there is not a space after the year add one.
          if copy(NewFileName, 5, 1) <> ' ' then
            Insert(' ', NewFileName, 5);
          SaveDialog.FileName := NewFileName;
          SaveDialog.DefaultExt := 'tdf';
          SaveDialog.Filter := 'Trade Log Data Files (*.tdf)|*.tdf';
          while Not SaveDialog.Execute(Self.Handle) do begin
            if mDlg('You must save your file in a permanent location before tradelog can continue.' + cr //
              + cr //
              + 'Do you want to try again?', mtInformation, [mbYes, mbNo], 0) <> mrYes //
            then begin
              Halt(1);
            end;
          end;
          OKToCopy := Not FileExists(SaveDialog.FileName);
          if Not OKToCopy then
            OKToCopy := mDlg('File already exists!' + cr //
              + cr //
              + 'Do you want to overwrite it?', mtWarning, [mbYes, mbNo], 0) = mrYes;
          if OKToCopy then begin
            CopyFile(Pchar(FFilePassedIn), Pchar(SaveDialog.FileName), False);
            FFilePassedIn := SaveDialog.FileName;
          end;
        end
        else begin
          Done := True;
          // --------------------------
          OpenTradeLogFile(FFilePassedIn);
          // --------------------------
        end;
      until Done;
      FFilePassedIn := '';
    end;
  finally
    frmMain.Enabled := true; // re-enable (see above)
    AlreadyLoaded := true;
  end;
end; // OpenFilePassedIn


procedure TfrmMain.ProcessCommandLineOptions;
var
  I : Integer;
begin
  try
    FFilePassedIn := '';
    if paramCount > 0 then begin
      for I := 1 to paramCount do begin
        if (ParamStr(I)[1] = '-') then begin
          if (ContainsStr(ParamStr(I), '-updatetimeout')) then
//            UpdateInformation.BlockingTimeout :=
//              StrToInt(Trim(RightStr(ParamStr(I), Length(ParamStr(I)) - pos('=', ParamStr(I)))))
          else if (ContainsStr(ParamStr(I), '-log')) then
            InLiveLogMode := True;
        end
        else if FileExists(ParamStr(I)) //
        and (LowerCase(ExtractFileExt(ParamStr(I))) = '.tdf') then begin
          FFilePassedIn := ParamStr(I);
        end;
      end;
    end;
  finally
    //
  end;
end; // ProcessCommandLineOptions


procedure TfrmMain.FormActivate(Sender : TObject);
var
  sTmp, s1, s2, s3, s4 : string;
  bSiteFound : Boolean;
begin
  // ----------------------------------
  mnuBaselinePositionWizard.Visible := baselineWizardOn;
  mnuBaselinePositionWizard.Enabled := baselineWizardOn;
  if baselineWizardOn then begin
    mnuBaselinePositionWizard.shortCut := textToShortCut('F8');
  end
  else begin
    mnuBaselinePositionWizard.shortCut := textToShortCut('');
  end; // if...else
  // ----------------------------------
  try
    screen.Cursor := crHourGlass;
    if (pnlDoReport.Visible) // when exiting from fastReports
    or (panelSplash.Visible) then begin
      screen.Cursor := crDefault;
      statBar('off');
      exit;
    end;
    if deletingRecords // or windowsdateErr //
    or (pos('Sorting', stMessage.Caption) > 0) //
    or (pos('Matching', stMessage.Caption) > 0) then begin
      screen.Cursor := crDefault;
      statBar('off');
      exit;
    end;
    // ------------------------------------------
    // Run the following code only once when first running the program
    if not TLstart then begin
      StatusBar.Visible := True;
      RegDefaults;
      Settings.InstallNewFeatures; // 2023-07-24 MB
      // check for Internet connection and TradeLog website
      // if either fails then do not check regcode or check for update
      statBar('Checking connection to TradeLog server');
      sTmp := readURL('https://tradelog.com/', 4000);
      bSiteFound := (sTmp <> '');
//      clipboard.AsText := sTmp;
      // always check if SUBSCRIPTION is still active (could be refunded)
      if bSiteFound then
        RegistrationCheck
      else
        checkOneYrLockout;
      statBar('Setting Up TradeLog');
      editDisable(false);
      SetupOpenCloseItems;
//      if Settings.DispQS then begin
//        panelQS.show;
//        if (TradeLogFile <> nil) and (TradeLogFile.Count = 0) then
//          panelQS.doQuickStart(2, 1, True)
//        else
//          panelQS.doQuickStart(3, 1);
//      end;
      pnlTools.Height := Toolbar1.Height + pnlBlue.Height;
    end; // if not TLStart - So first time we are starting app.
    if (TrFileName = '') then begin
      panelSplash.show;
      StatusBar.Top := 1000;
    end;
    // ------------------------------------------
    // check for update  // 2013-12-23 - allow updates in trial
    if not TLstart and bSiteFound then begin
      // Check For Update
      s1 := gsVersion;
      sTmp := parselast(s1, '.'); // remove last segment
      s2 := gsInstallVer;
      sTmp := parselast(s2, '.'); // remove last segment
      if (gsVersion > gsInstallVer) then begin
        bbHelp_Update.Caption := 'important update';
        if (s1 > s2) and not bCancelLogin then begin
//          s3 := parsefirst(s1, '.'); // major ver#
//          s4 := parsefirst(s2, '.'); // major ver#
//          if (s3 > s4) then begin
//            sm('There is a mandatory update required.' + cr //
//              + 'TradeLog will now automatically close' + cr //
//              + 'and the new version will be installed.');
//            gbUpdateNow := true; // don't ask, just do!
//          end
//          else
          if mDlg('An updated Tradelog version ' + gsVersion +' is now available!' + cr //
            + cr //
            + 'Brief Description:' + cr //
            + gsRelDesc + cr + cr //
            + 'Do you want to close TradeLog and download and' + cr //
            + 'install it now?',
            mtWarning, [mbYes, mbNo],1) = mrYes
          then begin
            gbUpdateNow := true;
          end; // if mDlg
        end // if s1 > s2
        else begin
          bbHelp_Update.Caption := 'Minor update';
        end;
      end // if newer version
      else begin
        if (gsInstalldate >= gsRelDate) then
          bbHelp_Update.Caption := 'Up to date'
        else
          bbHelp_Update.Caption := 'Minor update';
      end;
    end; // if not TLStart and bSiteFound
    // ------------------------------------------
    if not TLstart and panelSplash.Visible then
      disableMenuTools;
    // ------------------------------------------
    btnImport.Enabled := not isAllBrokersSelected;
    TLstart := True;
    // ------------------------------------------
    if not isFormOpen('panelSplash') then begin
      bbFile_Edit.Enabled := not isAllBrokersSelected;
      mnuEdit.Enabled := not isAllBrokersSelected;
      mnuAdd.Enabled := not isAllBrokersSelected;
      btnImport.Enabled := not isAllBrokersSelected;
      // rj Feb 6, 2021 make Ribbon visible/invisible based on above values
      showmessage('FormActivate');
      mtAccount.Visible := not isAllBrokersSelected;
      mtRecords.Visible := not isAllBrokersSelected;
      mtAdjust.Visible := not isAllBrokersSelected;
    end
    else begin
      DisableIfNoFileOpen;
    end;
  // ----------------------------------
  finally
    screen.Cursor := crDefault;
    // --- avoid circular call in statBar, just do 'off' --
    stMessage.Font.Style := [];
    screen.Cursor := crDefault;
    stMessage.FillColor := clBtnFace;
    stMessage.Font.Style := [];
    stMessage.Caption := 'Ready';
    rbStatusBar.Panels[5].Text := 'Ready'; // RJ Jan 1, 2021
    StatusBar.update;
    // ------------
    Timer1.Enabled := True;
  end;
end; // FormActivate


procedure TfrmMain.AppExceptionHandler(Sender: TObject; E: Exception);
var
  msgTxt : string;
begin
  if E is EcxEditValidationError then begin
    mDlg(E.Message, mtWarning, [mbOK], 0);
    exit;
  end
  else if (E is EInvalidOperation) then
    if (E.Message = 'Cannot focus a disabled or invisible window') then exit;
  //2014-01-22 trap all access violations and forget them
  //File, New has test code to generate EAccessViolation
  if (E.ClassName = 'EAccessViolation') then exit;
  msgTxt := 'The following error has occured!' + CR //
    + CR
    + E.ClassName + ': ' + E.Message + CR //
    + CR //
    + 'Would you like to send an error report to TradeLog Support?';
  //check for BrokerConnect Error
  if (pos('BrokerConnect web import',E.Message)>0) then begin
    TLSupportLib.createErrorLog(Settings.LogDir + '\error.log', crlf //
      + E.Message + ':' + crlf //
      + webGetData);
    SendSupport.edDetails.Text := E.Message;
    msgTxt := E.Message + CR //
      + CR //
      + 'Would you like to send an error report to TradeLog Support?';
    if (mDlg(msgTxt, mtError, [mbYes, mbNo], 0) = mrYes) then begin
      SendSupport.ShowModal;
    end;
    exit;
  end
  else // create error log in case we cannot create a csl file
    TLSupportLib.createErrorLog(Settings.LogDir + '\error.log',E.Message);
  // ----------------------------------
  //2014-01-25 trap OFX error message
  if (pos('Get OFX Data failed',E.Message)=1)
  and (pos('400 Bad Request',E.Message)>0) then
    mDlg('Your brokerage account broker may not' + CR //
      + 'be setup properly for OFX downloads.' + CR //
      + CR //
      + 'Please contact your broker to assist.', mtError, [mbOK], 0)
  else if (mDlg(msgTxt, mtError, [mbYes, mbNo], 0) = mrYes) then begin
    try
      CreateScreenShot(self.Handle, Settings.LogDir + '\ScreenShot.png');
      Help_SendFilestoSupport(False);
    except
      On E : Exception Do
        mDlg('Error occured trying to send files to support!' + CR //
          + CR //
          + 'Error Message: ' + E.Message + CR //
          + CR //
          + 'Please Check Your Internet Connection', mtError, [mbOK], 0);
    end;
  end; // if...else if...
  // --- avoid circular call in statBar, just do 'off' --
  stMessage.Font.Style := [];
  screen.Cursor := crDefault;
  stMessage.FillColor := clBtnFace;
  stMessage.Font.Style := [];
  stMessage.caption := 'Ready';
  rbStatusBar.Panels[5].Text := 'Ready'; //RJ Jan 1, 2021
  StatusBar.update;
  Application.ProcessMessages;
end;


// Process Application Messages (ProcessMessages)
procedure TfrmMain.AppMessageProcedure(var Message: TMsg; var Handled: Boolean);
var
  s, sUndo: String;
  X, Y: Integer;
  Target : TControl;
  Point : TPoint;
begin
  Handled := False;
  if (Message.message = WM_OPEN_TRADES_CLOSING) then begin
   try
    pnlTools.Show;
    try
      cxGrid1.SetFocus;
    except
      // do nothing?
    end;
    repaintGrid;
    Splitter2.Visible := False;
    if Message.wParam = WPARAM_GET_CURRENT_PRICES then begin
      SetupToolBarMenuBar(true);
    end;
    // ----------------------------------------------------
    if Message.wParam = WPARAM_TRANSFER_OPEN_POSITIONS then begin
      btnShowAll.Click;
      TransferOpensToAcct; // 2023-03-09 MB
//      TransferOpenPositions1.Click;
    end;
    Handled := true;
   finally
    Screen.Cursor := crDefault;
    statBar('off');
   end;
  end
  else if (Message.message = WM_DISCOVER_EXERCISE_CLOSING) then begin
//    if Settings.DispQS then panelQS.Show;
    repaintGrid;
    Splitter2.Visible := False;
    // By calling this next function we reset the columns visibility
    // based on the user preferences set in the options screen.
    // We do this here because we have temporarily made visible the
    // Matched Tax lots column and when we exit options this will reset
    // it to whatever it was before we started this process.
    SetOptions;
    SetupToolBarMenuBar(False);
    // If WParam comes back with a First Assign Number greater than zero
    // then we saved the file and want to filter the grid by the exercises
    // they just completed.
    if (Message.WParam > 0) then begin
      FilterByExerciseAssigns(Message.WParam);
      if SaveTradeLogFile then begin
        if (Message.LParam > 0) then begin
          DiscoverExerciseAssigns;
        end;
      end
      else begin
        undo(false, false);
        btnShowAll.click;
      end;
    end
    else begin
      btnShowAll.Click;  //If they closed and did not save then just show all.
    end;
    Handled := true;
    Screen.Cursor := crDefault;
    statBar('off');
  end
  else if Message.message = WM_REPORT_CLOSING then begin
   try
    // reset main form
    frmMain.Show;
    frmMain.Left := iFormL; //frmFastReports.Left;
    frmMain.Top := iFormT; //frmFastReports.Top;
    frmMain.Width := iFormW; //frmFastReports.Width;
    frmMain.Height := iFormH; //frmFastReports.Height;
    frmMain.Refresh;
//    if Settings.DispQS then panelQS.show;
    StopReport := False;
    if not isFormOpen('frmWeb') then
      SetMenuBarVisibility(true);
    menu := MainMenu;
    exitReportsClick(nil); //always exit reports panel
    frmTLCharts.HBarLosers.clear;
    frmTLCharts.HBarWinners.clear;
    if (ReportStyle in [rptRecon, rptWashSales, rptPerformance, rptPotentialWS]) then begin
      if (cxGrid1TableView1.DataController.CustomDataSource <> OpenTradeRecordsSource) then
        btnShowAll.Click;
      SortByTradeNum;
      pnlTools.Visible := True;
      tabAccounts.Enabled := True;
      SetPopupMenuEnabled(pupEdit, not isAllBrokersSelected);
      ReportStyle := rptNone;
    end;
    if (Message.wParam > WPARAM_SHOW_START) then begin
      s := intToStr(Message.wParam);
      X := StrToInt(leftStr(s, 1));
      Y := StrToInt(RightStr(s, 1));
//      panelQS.doQuickStart(X, Y, Not Message.lParam = 0);
    end;
    frmMain.cxGrid1.Enabled := True;
    repaintGrid;
    cxGrid1.SetFocus;
    Handled := true;
    frmMain.cxGrid1TableView1.DataController.Filter.Clear;
    // restore account filter if any
    SettingUpTabs := False;
    UserChangedTab := false;
    tabAccountsChange(nil);
   finally
    // free all objects created when running reports
    FreeTrSumList;
    if assigned(ClipStr) then ClipStr.Free;
    try
      if assigned(GainsReportData) then freeAndNil(GainsReportData);
      if assigned(dataFastReports) then freeAndNil(dataFastReports);
      if assigned(frmFastReports) then begin
        frmFastReports.Release;
        freeAndNil(frmFastReports);
      end;
    except
      mDlg('Could Not Free Report Preview Window.' +cr +cr
        + 'This is not critical, and should not cause any problems.',mtWarning,[mbOK],0);
    end;
    if TradeLogFile.YearEndDone then disableEdits;
    Screen.Cursor := crDefault;
    // --- avoid circular call in statBar, just do 'off' --
    stMessage.Font.Style := [];
    screen.Cursor := crDefault;
    stMessage.FillColor := clBtnFace;
    stMessage.Font.Style := [];
    stMessage.caption := 'Ready';
    rbStatusBar.Panels[5].Text := 'Ready'; //RJ Jan 1, 2021
    StatusBar.update;
   end;
  end;
end;


procedure TfrmMain.mnuEdit_AssignNotesClick(Sender: TObject);
begin
  AssignNoteToTrades;
end;


procedure TfrmMain.FormCreate(Sender: TObject);
var
  status, I: Integer;
  InstallDataDir2, tmpStr, shortDateFormatOld, thisKey: string;
  osv: TOSVERSIONINFO;
  myDate: Tdate;
  searchResult: TSearchRec;
  fileExt, isMoved: string;
begin
  // DO NOT REMOVE: This is required to keep MS DLL from throwing
  // Divide By Zero and other errors, Specifically mshtml.dll
  Math.SetExceptionMask([exInvalidOp, exDenormalized, exZeroDivide, exOverflow, exUnderflow, exPrecision]);
  // END OF DO NOT REMOVE
  if SuperUser and (DEBUG_MODE > 3) then
    ReportMemoryLeaksOnShutdown := True; // check for memory leaks when done
  // First thing setup logging before any logging is completed.
  InLiveLogMode := False;
  ProcessCommandLineOptions;
  // Set this after calling command line options so it shows up if you ask for it.
//  UpdateInformation.StatusCallBack := UpdateStatus;
  if FileExists(Settings.LogDir + '\' + Settings.LogFileName) then
    DeleteFile(Settings.LogDir + '\' + Settings.LogFileName);
    // This line is necessary to get the CSDispatcher.exe to start so that
    // we don't have to silently install the CS Tools; Do not remove it.
    // As soon as a file is opened, the Directory will be changed to the
    // Data Directory
  Chdir(ExtractFilePath(Application.ExeName));
  // End of Do Not Remove code
  JCLdebug.JclStackTrackingOptions:=[stStack, stRawMode];
  JclAddExceptNotifier(LogException);
  try
    Application.OnMessage := AppMessageProcedure;
    Application.OnException := AppExceptionHandler;
    // Create Popup Menus based on Main Menu Counterparts
    CopyMenu(pupEdit.Items, mnuEdit);
    CopyMenu(pupView.Items, View1);
    CopyMenu(pupFind.Items, Find);
    // End of Create Popup Menus.
    // Manually Scale the form since automatic scaling does not work so good
    if GetScalePercentage > 100 then Self.ScaleBy(GetScalePercentage, 125);
    // Used to know the difference between when the user clicks on a tab and
    // we programatically change to a tab
    UserChangedTab := False;
    stUpdateMsg.Visible := False;
    rbStatusBar.Panels[2].Visible := false;
    stAcctType.Visible := False;
    rbStatusBar.Panels[3].Visible := false;
    stImportType.Visible := False;
    rbStatusBar.Panels[4].Visible := false;
    // Row Colors for DrawCell
    RowColors := TRowColorList.Create;
    FHaltCustomDrawing := False;
    frmMain.Enabled := False;
    renumFldChanged := False;
    // What Platform are we running on?
    osv.dwOSVersionInfoSize := sizeOf(OSVERSIONINFO);
    GetVersionEx(osv);
    if osv.dwMajorVersion < 5 then begin
      mDlg('Tradelog requires Windows 2000, XP, Vista, or Newer', //
        mtError, [mbOK], 0);
      Application.Terminate;
    end;
    // Used to read command line option to specify
    // Mad Exceptions should be displayed when in design mode.
    bImporting := False;
    redoing := false; // used to track when Redo is taking place
    StopReport := False;
    SettingUpTabs := False;
    RangeStart := xStrToDate('1/1/1900');
    RangeEnd := xStrToDate('1/1/1900');
    DoLT := true;
    DoST := true;
    regCheck := False;
    MainFilterStream := TMemoryStream.Create;
    TLstart := False;
    // get help file
    Application.HelpFile := Settings.HelpFileName;
    Self.BorderIcons := Self.BorderIcons + [biHelp];
    Width := 800;
    Height := 600; // added as default
    Settings.MainFormData.GetData(TForm(Self));
    Application.ProcessMessages;
    SetupLastOpenFilesMenu;
    if Settings.TrialVersion then Settings.DispQS := true;
    pnlGrid.align := alClient;
    Printers.Printer;
    miHint := TMenuItemHint.Create(Self);
    bindStrategy;
  finally
    frmMain.Enabled := true; // ensure we don't leave frmMain disabled
    DisableIfNoFileOpen;
  end;
  // turn off the current menu
  Menu := nil;
  mtFile.Active := true; // show File menu as default
  getVisualThemeSkin;
  SetupTitleAndSummaryColors;
  FGridOdd  := clWhite;
  FGridEven := tlGreen;
end; // FormCreate


procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  try
    RowColors.Free;
    Settings.MainFormData.SetData(Self);
    // SaveLastFileName(TrFileName);
    if TLstart and not bCancelLogin then // only after initial app startup
      Settings.SaveSettings;
    try
      if isFormOpen('frmWeb') then
        frmWeb.close;
    except
    end;
  finally
    //
  end;
end; // FormClose


procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  try
    if (Screen.Cursor = crHourGlass) //
    or isFormOpen('pnlBaseline') //
    or isFormOpen('pnlBaseline1') //
    then begin
      // should be a counter to allow exit after so many attempts
      CanClose := False;
      exit;
    end;
    if IsFormVisible('frmExerciseAssign') then begin
      GetFormIfOpen('frmExerciseAssign').close;
      Application.ProcessMessages;
    end;
  finally
    HaltCustomDrawing := CanClose;
  end;
end; // FormCloseQuery

{ Buttons }

procedure TfrmMain.btnSampleDataClick(Sender: TObject);
begin
  webURL(siteURL + 'support/trial-resources');
end;

procedure TfrmMain.btnTODsetupClick(Sender: TObject);
var
  I: Integer;
begin
  if rbTimeDay.checked then
    TfrmChartTimes.Execute;
end;

procedure TfrmMain.btnTutorialsClick(Sender: TObject);
begin
  webURL(siteURL + 'support/online-tutorial');
end;


// --- Speed Buttons --------

procedure TfrmMain.actnShowOpenClick(Sender: TObject);
var
  F : TfrmOpenTrades;
  i, j : integer;
begin
  try
    if TradeLogFile.Count = 0 then exit;
    frmMain.Enabled := true; // <-- uh-oh, what is this supposed to fix?
    statBar('Loading Open Positions Windows');
    screen.Cursor := crHourGlass;
    if panelMsg.Visible then panelMsg.hide;
    GridFilter := gfOpen;
    SpeedButtonsUp;
    SortBy := '';
    pnlTools.hide;
    menu := nil;
    // --------------------------------
    i := TradeLogFile.CurrentBrokerID;
    if (i = 0) then begin
      // select 1st tab, then back to all accounts
      // why is this necessary? IDK!
      j := TradeLogFile.FileHeaders[0].BrokerID;
      TradeLogFile.CurrentBrokerID := j;
      TradeLogFile.CurrentBrokerID := i;
    end;
//    TradeLogFile.RefreshOpens; // 2022-03-08 MB
    TradeLogFile.CurrentBrokerID := i;
    // --------------------------------
    F := TfrmOpenTrades.Create(Self);
    F.show;
  finally
    screen.Cursor := crDefault; // if we fail to set this back,
    TradeLogFile.CloneList; // same
    // it will seem to lock up the program (can't click mouse)
//    F.Close;
//    F.Destroy;
  end;
  Menu := nil;
end;


procedure TfrmMain.actnCheckListExecute(Sender: TObject);
begin
  EndYearCheckList1.Click;
end;


procedure TfrmMain.actnClosedClick(Sender: TObject);
begin
  try
    CloseFormIfOpen('frmOpenTrades');
    GridFilter := gfClosed;
    SpeedButtonsUp;
    if TradeLogFile.Count = 0 then exit;
    SortBy := '';
    FilterByOpenTrades('C');
    cxGrid1.SetFocus;
  finally
    //
  end;
end; // actnClosedClick

procedure TfrmMain.actnDelClick(Sender: TObject);
begin
  try
    DelSelectedRecords;
  finally
    //
  end;
end; // actnDelClick


function TfrmMain.CheckCurrentAccount : TExitOperation;
begin
  try
    if TradeLogFile.CurrentBrokerID > 0 then begin
      {Make sure we are showing all as some issues may occur otherwise.}
      btnShowAll.Click;
      Result := TdlgAccountYrEndCheck.Execute;
      case Result of
        eoExpireOptions: ExpireOptions1.Click;
        eoExerciseOptions: ExerciseAssign1.Click;
        eoOpenPositions: btnShowOpen.Click;
        eoReconcile1099: Reconcile1099B1.Click;
      end;
      if (TradeLogFile.FileNeedsSaving) then
        SaveTradeLogFile('EOY CheckList for ' + TradeLogFile.CurrentAccount.AccountName, True);
    end
    else
      mDlg('End of Year checklist must be run from each individual account tab.' + CR + CR
        + 'Please select an account tab and try again!' , mtInformation, [mbOK], 0);
  finally
    //
  end;
end; // CheckCurrentAccount


procedure TfrmMain.bbFind_FindInstrumentPropertiesEditValueChanged(Sender: TObject);
var
  sSelected, sChar : string;
  i, iChar : integer;
  bSelected : boolean;
  aInstruments : array[0..9] of string;
  sTest, sTestOne : string;
  iCount : integer;
  cItem : TcxCheckComboBoxItem;
  cState : TcxCheckComboBoxProperties;
begin
  aInstruments[0] := 'STK';
  aInstruments[1] := 'OPT';
  aInstruments[2] := 'ETF';
  aInstruments[3] := 'DRP';
  aInstruments[4] := 'DCY';
  aInstruments[5] := 'CUR';
  aInstruments[6] := 'MUT';
  aInstruments[7] := 'FUT';
  aInstruments[8] := 'VTN';
  aInstruments[9] := 'CTN';
  bSelected := false;
  // set cbFindAdjusted and cbFindErrorCheck to blank
  ResetFilterCombobox('bbFind_FindInstrument');
  // remove all Filters
  actnShowAllClick(Sender);
  //set filter
  if bbFind_FindInstrument.EditValue <> null then begin
    for i := 0 to 9 do begin
      bSelected := StrToInt(copy(bbFind_FindInstrument.EditValue, i+1, 1)) = 1;
      if bSelected then
        sSelected := sSelected + aInstruments[i] + ';';
    end;
  end;
  sSelected := copy(sSelected, 1, Length(sSelected)-1);
  if (bbFind_FindInstrument.EditValue <> '0000000000') and bbFind_FindInstrument.EditValue <> null then
    filterByType('~'+sSelected, True);
(* form checkcombobox
  if cxBarEditItem7.EditValue <> '0000' then
    for i := 1 to Length(cxBarEditItem7.EditValue) do begin
      sTestOne := copy(cxBarEditItem7.EditValue, i, 1);
      if TryStrToInt(sTestOne, iCount) then
        if iCount > 0 then
          sSelected := sSelected + aInstruments[i-1] + ';'
   end;
  sSelected := copy(sSelected, 1, Length(sSelected)-1);
  if (sSelected <> '') then
    filterByType('~'+sSelected, True);
*)
end;


procedure TfrmMain.bbUser_AdjustChange(Sender: TObject);
begin
  Settings.Disp8949Code := bbUser_Adjust.EditValue;
  SetOptions;
end;

procedure TfrmMain.bbUser_MatchedChange(Sender: TObject);
begin
  Settings.DispMTaxLots := bbUser_Matched.EditValue;
  SetOptions;
end;

procedure TfrmMain.bbUser_NotesChange(Sender: TObject);
begin
  Settings.DispNotes := bbUser_Notes.EditValue;
  SetOptions;
end;

procedure TfrmMain.bbUser_OptionTickersChange(Sender: TObject);
begin
  Settings.DispOptTicks := bbUser_OptionTickers.EditValue;
  SetOptions;
end;

procedure TfrmMain.bbUser_StrategiesClick(Sender: TObject);
begin
  Settings.DispStrategies := bbUser_Strategies.EditValue;
  SetOptions;
end;

procedure TfrmMain.bbUser_TaxFilesClick(Sender: TObject);
begin
  mnuFileResetUser;
end;

procedure TfrmMain.bbUser_TimeClick(Sender: TObject);
begin
  Settings.DispTimeBool := bbUser_Time.EditValue;
  SetOptions;
end;

procedure TfrmMain.bbUser_WashSaleHoldingsChange(Sender: TObject);
begin
  Settings.DispWSHolding := bbUser_WashSaleHoldings.EditValue;
  SetOptions;
end;

procedure TfrmMain.mnuAcct_EditClick(Sender: TObject);
begin
  if not CheckRecordLimit then Exit;
  EditCurrentAccount('');
  SetupToolBarMenuBar(False); // update buttons
end;


procedure TfrmMain.EndYearCheckList1Click(Sender: TObject);
begin
  if not CheckRecordLimit then Exit;
  CheckCurrentAccount;
end;

// ----------------
// Grid Functions
// ----------------

procedure TfrmMain.EditRec1Click(Sender: TObject);
begin
  try
    if (TradeLogFile.Count = 0) //
    or oneYrLocked //
    or isAllBrokersSelected then begin
      exit;
    end;
    if not CheckRecordLimit then Exit;
    // -----------------
    if cxGrid1TableView1.DataController.GetSelectedCount < 1 then
      mDlg('No Record Selected: You must first select a record to edit.', mtError, [mbOK], 0)
    else begin
      EditRec := true;
      EditEnable;
      glEditListItems.Clear;
      glEditListTicks.Clear;
      glEditListItems.add(TradeLogFile[cxGrid1TableView1.DataController.FocusedRecordIndex].ID);
      glEditListTicks.add(TradeLogFile[cxGrid1TableView1.DataController.FocusedRecordIndex].Ticker);
      // this should be set only when a record is actually changed, but
      // there is code which assumes at least one ticker - 2016-11-04 MB
    end;
    readFilter;
  finally
    //
  end;
end; // EditRec1Click


procedure TfrmMain.Edit_ConsolidateClick(Sender: TObject);
begin
  consolidateRecords;
end;

procedure TfrmMain.Edit_SplitRecordClick(Sender: TObject);
begin
  splitRecord;
end;


procedure TfrmMain.changeTick1Click(Sender: TObject);
begin
  try
    if oneYrLocked or isAllBrokersSelected then exit;
    if not CheckRecordLimit then Exit;
    // -----------------
    changeTickerShowDlg;
  finally
    //
  end;
end; // changeTick1Click


// Up is which button not to allow up.
procedure SpeedButtonsUp;
begin
  try
    frmMain.btnShowAll.Down := (frmMain.GridFilter = gfAll);
    frmMain.btnShowOpen.Down := frmMain.GridFilter = gfOpen;
    frmMain.btnClosed.Down := frmMain.GridFilter = gfClosed;
    frmMain.btnShowRange.Down := frmMain.GridFilter = gfRange;
    frmMain.btnFilterEnable.Down := frmMain.GridFilter = gfFilter;
  except
    sm('error in SpeedButtonsUp');
  end;
end; // SpeedButtonsUp


// ------
//   +
// ------
procedure AddRecord;
var
  Shares: double;
begin
  // ---- skip code -------------------
  if oneYrLocked
  or IsAllBrokersSelected
  or TradeLogFile.YearEndDone
  or frmMain.cxGrid1TableView1.optionsData.editing
  or (TradeLogFile.CurrentBrokerID = 0) then
    exit;
  if panelSplash.Visible then exit;
  if not CheckRecordLimit then exit;
  // ----------------------------------
  // AddRecord
  try
  readFilter;
  frmMain.cxGrid1TableView1.DataController.clearSorting(False);
  with frmMain.cxGrid1TableView1.DataController do begin
    if TradeLogFile.Count > 0 then
      if CustomDataSource <> TradeRecordsSource then
        TradeRecordsSource.DataChanged;
    if not frmMain.DisplayWashSales1.checked then
      frmMain.DisplayWashSales1.Click;
    Append;
    FocusedRowIndex := RowCount - 1;
    clearSelection;
    ChangeRowSelection(RowCount - 1, true);
    if panelMsg.HasTradeIssues then
      frmMain.cxGrid1TableView1.Columns[4].EditValue := 'O';
    frmMain.cxGrid1TableView1.Columns[2].focused := true;
  end;
  frmMain.txtSharesOpen.Caption := '';
  frmMain.addRec := true;
  finally
    //
  end;
end; // AddRecord


// ------
//   V
// ------
procedure InsertRecord;
var
  RecIdx : Integer;
begin
  if oneYrLocked //
  or frmMain.cxGrid1TableView1.optionsData.editing
  or TradeLogFile.YearEndDone or panelSplash.Visible //
  or frmMain.insertRec
  or (TradeLogFile.CurrentBrokerID = 0) then
    exit;
  if (TradeLogFile.Count = 0) then begin
    AddRecord;
    exit;
  end;
  try
    if not CheckRecordLimit then exit;
    if frmMain.cxGrid1TableView1.DataController.GetSelectedCount = 0 then begin
      mDlg('Please select a record to insert before', mtInformation, [mbOK], 0);
      exit;
    end;
    RecIdx := frmMain.cxGrid1TableView1.DataController.GetFocusedRecordIndex;
    frmMain.cxGrid1TableView1.DataController.insertRecord(RecIdx);
    frmMain.InsertRec := true;
  except
    on E: exception do begin
      mDlg('Error inserting record' + cr //
        + E.Message + cr, mtError, [mbOK], 0);
      StatBar('off');
      exit;
    end;
  end;
end;


// ----------------
// Menus
// ----------------

procedure TfrmMain.Exit1Click(Sender: TObject);
begin
  close;
end;

procedure TfrmMain.DeleteSelectedRecClick(Sender: TObject);
begin
  try
    if not CheckRecordLimit then Exit;
    // -----------------
    if not cxGrid1TableView1.optionsData.editing then
      DelSelectedRecords;
    cxGrid1.SetFocus;
    repaintGrid;
  finally
    // DeleteSelectedRecClick
  end;
end;


procedure TfrmMain.DebugLogging1Click(Sender: TObject);
begin
  if (TLoggingDlg.Execute = mrOK) then begin
    // for future functionality
  end;
end;


procedure TfrmMain.DeleteAccount1Click(Sender: TObject);
var
  S, AccountName : String;
begin
  // skip code
  if not CheckRecordLimit then Exit;
  if TradeLogFile.FileHeaders.Count = 1 then begin
    mDlg('A File must have at least one account, therefore you can not delete this account.',
      mtError, [mbOK], 0);
    exit;
  end;
  if (TradeLogFile.CurrentBrokerID <= 0) then exit; // All Accounts Tab
  // end skip code
  try
    if (mDlg('Deleting an account will also delete all trade details for this account' +
      CR + CR + 'Are you sure you want to delete the account: ' +
      TradeLogFile.CurrentAccount.AccountName, mtWarning, [mbYes, mbNo], 0) = mrYes) then
    begin
      S := TradeLogFile.CurrentAccount.AccountName;
      TradeLogFile.DeleteAccount;
      SetupTabs;  // this must come before set tabIndex
      // 2015-12-23 DE - must set tab index to first tab in order to rematch
      tabAccounts.TabIndex := 1;
      TradeLogFile.RenumberItemField;
      TradeLogfile.MatchAndReorganize;
      TradeRecordsSource.DataChanged; // numbers may have changed!
      SaveTradeLogFile('Delete Account: ' + S, True);
      doGLAll;
    end;
  finally
    // DeleteAccount1Click
  end;
end;


procedure TfrmMain.DeleteAll1Click(Sender: TObject);
begin
  try
    if not CheckRecordLimit then Exit;
    // -----------------
    DelAll;
    //repaintGrid;
  finally
    // DeleteAll1Click
  end;
end;

procedure TfrmMain.Commision1Click(Sender: TObject);
begin
  frmCommission.show;
end;

// ----------------
// MENU: File \ New
// ----------------
procedure TfrmMain.mnuFileNew;
var
  x:integer;
begin
  clearProHeader;
  CreateNewFile; // old name was ProcessBeginYearA;
  statBar('off');
end;

procedure TfrmMain.New1Click(Sender: TObject);
begin
  mnuFileNew;
end;


procedure TfrmMain.onlineSupportpage1Click(Sender: TObject);
begin
  webURL('https://support.tradelogsoftware.com/hc/en-us');
end;


procedure TfrmMain.SaveFileFromGrid();
var
  TrNum: Integer;
begin
  if not CheckRecordLimit then exit;
  savingFile := true;
  if not frmMain.cxGrid1TableView1.DataController.IsEditing
  and (TradeLogFile.Count = 0) then begin
    mDlg('There are no records to save!', mtInformation, [mbOK], 0);
    exit;
  end;
  // ----------------------------------
  if cxGrid1TableView1.optionsData.editing then begin
    with cxGrid1TableView1 do begin
      if (cxGrid_6_Ticker.EditValue = '') //
      or (cxGrid_7_Shares.EditValue = 0) //
      or ((cxGrid_8_Price.EditValue = 0) and EnteringBeginYearPrice) //
      then begin
        mDlg('Missing Data Fields', mtError, [mbOK], 1);
        exit;
      end;
    end; // end with
    if addRec then
      SaveTradesBack('Add Transaction')
    else
      SaveTradesBack('Edit');
    editDisable(False);
    SaveGridData(true);
    dispProfit(true, 0, 0, 0, 0);
  end
  else
    SaveTradeLogFile;
  // end if ---------------------------
  EditRec := False;
  addRec := False;
  insertRec := False;
  savingFile := False;
end;

procedure TfrmMain.mnuFileSave;
begin
  if cxGrid1TableView1.optionsData.editing then begin
    if addRec then begin
      SaveTradesBack('Add Transaction');
      savingFile := true;
      cxGrid1TableView1.DataController.Post(true);
    end
    else if editRec then begin
      SaveTradesBack('Edit');
      cxGrid1TableView1.DataController.Post(true);
      EditRec := False;
    end;
    editDisable(False);
    SaveGridData(true);
  end
  else begin
    SaveFileFromGrid;
  end;
  dispProfit(true, 0, 0, 0, 0);
  EditRec := False;
  addRec := False;
  insertRec := False;
  savingFile := False;
end;

procedure TfrmMain.Save1Click(Sender: TObject);
begin
  mnuFileSave;
end;


function TfrmMain.SaveTXF: Boolean;
var
  I, X, Y, RptYear: Integer;
  dacq, dsld, cost, sale, adjG, category, FileName, newPath, rptType: string;
  TXFFile: TextFile;
  ARec: TTradeSum;
  dEnd: Tdate;
  expOptHasComm: Boolean;
  TrSum: PTTrSum;
  Tick : String;
  // ------------------------
  function toString(Rec: PTTrSum): String;
  var
    ClosedDate: String;
    LongShort: String;
  begin
    if Length(Rec.cd) > 0 then
      ClosedDate := Rec.cd
    else
      ClosedDate := '[Not Closed]';
    // end if closed
    if Rec.ls = 'L' then
      LongShort := 'Long'
    else
      LongShort := 'Short';
    // end if Long/Short
    Result := intToStr(Rec.tr) + ' ' + Rec.od + '-' + ClosedDate + ' ' +
      LongShort + ' ' + Rec.tk + ' ' + Rec.prf + ' Open:' + FloatToStr(Rec.os)
      + ' Closed:' + FloatToStr(Rec.cs) + ' WS:' + intToStr(Rec.ws);
  end;
  // ------------------------
begin // SaveTXF
  try
    Result := true;
    //
    // TXF Spec 042
    // Form 8949 Copy A : (reported cost basis for this sale to the
    // IRS using Form 1099B Box 3)
    // 321 (Short term holding period); 323 (long term holding period);
    // 673 (you don't know the holding period); 682 (wash);
    //
    // Form 8949 Copy B : (provided cost basis to customer,
    // but did NOT report it to the IRS using Form 1099B Box 3)
    // 711 (short term, Copy B);
    // 713 (long term, Copy B);
    // 715 (unknown holding period, Copy B);
    // 718 (wash, Copy B)
    //
    // Form 8949 Copy C : (no 1099B issued customer or IRS)
    // 712 (short term, Copy C);
    // 714 (long term, Copy C);
    // 716 (unknown holding period, Copy C)
    //
    // Record Format 5
    // P security
    // D date acquired   mm/dd/yyyy
    // D date sold
    // $ cost basis
    // $ sales net
    // $ Depreciation Allowed OR Disallowed wash sale amount (added for TY11)
    //
    // Note: expanded Format 5 to use for new TY11 cost basis reporting rules.
    // Format 5 used with Taxrefs 321,323,673,682,711,712,713,714,715,716
    // when reporting a disallowed wash sale amount.
    //
    X := 0;
    Y := 0;
    dtBegTaxYr := xStrToDate('01/01/' + TaxYear, Settings.InternalFmt);
//    dtBegTaxYr := EncodeDate(TaxYear, 1, 1);
    TXFlines := 0;
    if pos('Trial', Settings.TLVer) > 0 then begin
      sm('This report is not available in the Free Trial version');
      exit;
    end;
    // check for commiss in expired options - 2010-03-18
    expOptHasComm := False;
    for I := 0 to TradeLogFile.Count - 1 do begin
      if (pos('OPT', TradeLogFile[I].TypeMult) = 1)
      and (TradeLogFile[I].Price = 0)
      //and (TradeLogFile[I].Commission <> 0) then
      and (compareValue(TradeLogFile[I].Commission, 0, NEARZERO) <> 0) then
      begin
        mDlg('ERROR - Expired option has commission:' + cr + cr
          + TradeLogFile[I].Ticker, mtError, [mbOK], 0);
        expOptHasComm := true;
      end;
    end;
    if expOptHasComm then begin
      sm('Please delete the commission amount from all expired options' + cr +
          'otherwise TurboTax will not recognize the txf file' + cr);
      exit;
    end;
    FileName := '';
    DoST := true;
    DoLT := true;
    RptYear := StrToInt(TaxYear);
    newPath := Settings.ReportDir;
    // if not DirectoryExists(newPath) then ForceDirectories(newPath);
    // NEED TO HAVE DIALOG MOVE WITH MAIN WINDOW FOR MULTI-MONITOR SUPPORT //
    with SaveDialog do begin
      Title := 'Export Gains & Losses to TXF file';
      InitialDir := newPath;
      Filter := 'Tax eXchange File|*.txf';
      DefaultExt := 'txf';
      FileName := '';
      if not Execute(Self.Handle) then exit;
    end;
    FileName := SaveDialog.FileName;
    try
      if pos('.', FileName) < 1 then FileName := FileName + '.txf';
      if MidStr(FileName, pos('.', FileName), Length(FileName)) <> '.txf' then
        FileName := leftStr(FileName, pos('.', FileName)) + 'txf';
      if FileExists(FileName) then
        if mDlg('A file named: ' + FileName + cr + 'already exists' + cr + cr
          + 'Do you wish to over write this file?', mtConfirmation,
          [mbYes, mbNo], 0) <> mrYes then
          exit
        else
          DeleteFile(FileName);
      AssignFile(TXFFile, FileName);
      Rewrite(TXFFile);
      writeln(TXFFile, 'V042');
      writeln(TXFFile, 'ATradeLog ver ' + Ver);
      writeln(TXFFile, 'D' + dateToStr(date, Settings.UserFmt));
      with ARec do
        for I := 0 to TrSumList.Count - 1 do begin
          TrSum := TrSumList[I];
          tr := TrSum.tr;
          tk := TrSum.tk;
          od := TrSum.od;
          cd := TrSum.cd;
          os := TrSum.os;
          cs := TrSum.cs;
          ls := TrSum.ls;
          oa := TrSum.oa;
          ca := TrSum.ca;
          wsh := TrSum.wsh;
          ws := TrSum.ws;
          prf := TrSum.prf;
          pr := TrSum.pr;
          lt := TrSum.lt;
          // skip if wash sale deferral
          if ws = wsPrvYr then begin
            continue;
          end;
          // Skip if an IRA Account.
          if (TradeLogFile.FileHeader[StrToInt(TrSum.br)].IRA) then Continue;
          // skip exercized options - 2009-04-08
          if (pos('EXERCISED', tk) > 1) then continue;
          // add 'EXPIRED' to expired options
          if (pos('OPT', prf) = 1) and (ca = 0) then tk := tk + ' EXPIRED';
          // skip if trade closed in prev tax year
          if (Length(cd) > 0)
          and (xStrToDate(cd, Settings.UserFmt) < dtBegTaxYr) then begin
            continue; // skip trade closed in prev Year
          end;
          if (TaxYear > '2010') and (rndto5(os) <> rndto5(cs))
          and (ls = 'S') then begin
            continue; // skip trades open short after 2010
          end;
          // check for negative close amount - 2011-03-09
          if (pos('OPT', prf) = 1) and (ls = 'L') and (ws <> 1)
          and (compareValue(ca, 0, NEARZERO) < 0) then begin
            mDlg('TXF ERROR on the following transaction: ' + cr //
              + cr + cd //
              + '  ' + tk + '   amount = ' + FloatToStr(rndto2(ca), Settings.UserFmt) + cr //
              + cr //
              + 'TurboTax does not allow a negative value for the close amount and will' + cr //
              + 'throw an error when importing this TXF file.' + cr + cr //
              + 'The only workaround is to reduce the commission on the above trade so' + cr //
              + 'the amount is zero.  This is just one of the many limitations of TurboTax.', //
              mtError, [mbOK], 0);
            exit;
          end;
          if (oa = 0) and (ca = 0) then begin
            continue; // skip trade if open & close amts are zero
          end;
          // skip if futures or currency
          if (pos('FUT', prf) > 0) or (pos('CUR', prf) > 0) then begin
            continue; // skip trade if future or currency
          end;
          Tick := '';
          if (ws = wsThisYr) then begin
            continue; // don't save wash sale transactions to TXF
          end
          else begin // ws = either wsNone or wsCstAdjd
            dEnd := xStrToDate('12/31/' + intToStr(RptYear));
            if ( ((od <> '') and (xStrToDate(od, Settings.UserFmt) > dEnd))
              or ( (ls = 'L') and (cd <> '')
               and (xStrToDate(cd, Settings.UserFmt) > dEnd) )
              or ( (ls = 'S') and (cd <> '') and (pos('OPT', prf) = 1)
               and (xStrToDate(cd, Settings.UserFmt) > dEnd) )
            ) then begin
              continue; // skip trade not closed in current tax year
            end;
            if (rndto5(os) <> rndto5(cs)) and (ls = 'L') then begin
              continue; // skip trade open long, not closed, wsDetail not checked
            end;
            if (rndto5(os) <> rndto5(cs)) and (ls = 'S')
            and (pos('OPT', prf) = 1) then begin
              continue; // skip open short option, not closed, wsDetail not checked
            end;
            if ls = 'S' then begin
              tk := '(S) ' + tk;
              // fix for open short sales 8-9-06
              if (cd = '')
              or ( (cd <> '')
               and (xStrToDate(cd, Settings.UserFmt) > dEnd) ) then begin
                ca := -oa;
                cd := od;
                tk := tk + ' OPEN'
              end;
              dacq := cd;
              dsld := od;
              cost := CurrStrEx(-ca, Settings.UserFmt, true);
              sale := CurrStrEx(oa, Settings.UserFmt, true);
              adjG := CurrStrEx(TrSum.adjG, Settings.UserFmt, true);
              if (cd <> '')
              and (xStrToDate(cd, Settings.UserFmt) > xStrToDate('12/31/' + TaxYear)) then
              begin
                cost := sale;
                dacq := dsld;
              end;
              // short term
              if TrSum.abc = 'A' then      category := '321'
              else if TrSum.abc = 'B' then category := '711'
              else if TrSum.abc = 'C' then category := '712';
              // long term
              if (cd <> '') and (pos('OPT', prf) = 0) // short options always S-T
              then begin
                if (TTLDateUtils.MoreThanOneYearBetween(xStrToDate(od, Settings.UserFmt),
                    xStrToDate(cd, Settings.UserFmt)))
                or (lt = 'L') then begin
                  if TrSum.abc = 'A' then      category := '323'
                  else if TrSum.abc = 'B' then category := '713'
                  else if TrSum.abc = 'C' then category := '714';
                end;
              end;
              Tick := tk;
            end
            else if ls = 'L' then begin
              tk := '(L) ' + tk;
              dacq := od;
              dsld := cd;
              cost := CurrStrEx(-oa, Settings.UserFmt, true);
              sale := CurrStrEx(ca, Settings.UserFmt, true);
              adjG := CurrStrEx(TrSum.adjG, Settings.UserFmt, true);
              // short term
              if TrSum.abc = 'A' then      category := '321'
              else if TrSum.abc = 'B' then category := '711'
              else if TrSum.abc = 'C' then category := '712';
              // long term
              if (cd <> '') then begin
                if (TTLDateUtils.MoreThanOneYearBetween(xStrToDate(od, Settings.UserFmt),
                      xStrToDate(cd, Settings.UserFmt)))
                or (lt = 'L') then begin
                  if TrSum.abc = 'A' then      category := '323'
                  else if TrSum.abc = 'B' then category := '713'
                  else if TrSum.abc = 'C' then category := '714';
                end;
              end;
              Tick := tk;
            end;
          end; // if ws..
          if (Tick = 'Wash Sale')
          and (cost = CurrStrEx(0, Settings.UserFmt, true)) then begin
            continue; // skip trade open short, tax year > 2010
          end;
          if (ws = wsTXF) and (TaxYear < '2011') then begin
            // wash sale flag
            category := '682';
          end;
          // Writing data
          writeln(TXFFile, '^');
          writeln(TXFFile, 'TD');
          writeln(TXFFile, 'N' + category); // short term / long term / wash sale
          writeln(TXFFile, 'C1');
          writeln(TXFFile, 'L1');
          if (category = '321') or (category = '711') or (category = '712') then
          begin
            inc(X);
            writeln(TXFFile, 'P' + FloatToStr(os, Settings.UserFmt) + Tick);
          end
          else if (category = '323') or (category = '713') or (category = '714')
          then begin
            inc(Y);
            writeln(TXFFile, 'P' + FloatToStr(os, Settings.UserFmt) + Tick);
          end
          else if (category = '682') or (category = '718')
          // or (category='XXX') //needed for Copy C wash sales
          then begin
            if cd <> '' then
              if TTLDateutils.MoreThanOneYearBetween(xStrToDate(od, Settings.UserFmt),
                xStrToDate(cd, Settings.UserFmt)) then
              begin
                inc(Y);
                writeln(TXFFile, 'P' + FloatToStr(os, Settings.UserFmt) + Tick);
              end
              else begin
                inc(X);
                writeln(TXFFile, 'P' + FloatToStr(os, Settings.UserFmt) + Tick);
              end;
          end;
          writeln(TXFFile, 'D' + US_DateStr(dAcq,settings.UserFmt));
          writeln(TXFFile, 'D' + US_DateStr(dSld,settings.UserFmt));
          writeln(TXFFile, Del1000SepEx(cost, Settings.UserFmt));
          writeln(TXFFile, Del1000SepEx(sale, Settings.UserFmt));
          // column G adjustment
          if TaxYear > '2010' then begin
            adjG := Del1000SepEx(adjG, Settings.UserFmt);
            if adjG = '$0.00' then
              writeln(TXFFile, '$')
            else
              writeln(TXFFile, adjG);
          end;
          inc(TXFlines);
          if pos('($', sale) = 1 then
            sm('ERROR: Sales amount less than zero for the following trade:' +
                cr + cr + Tick + cr + 'date acquired: ' + dacq + cr +
                'date sold: ' + dsld + cr + 'sales amount: ' + Del1000SepEx(sale,
                Settings.UserFmt) + cr + cr +
                'This MUST be fixed before importing into TurboTax' + cr +
                'otherwise TurboTax will not recognize the TXF file.');
        end; // For ..
      // --------------------
      writeln(TXFFile, '^');
      CloseFile(TXFFile);
      if TXFlines > 3000 then begin
        if (TaxYear > '2010') then
          rptType := 'IRS Form 8949'
        else
          rptType := 'Gains and Losses';
        mDlg(
          'Your TXF File has more than 3000 lines and cannot be imported into TurboTax'
            + cr + cr + 'If you wish to use TurboTax you must file by mail:'
            + cr + 'Run the TradeLog ' + rptType
            + ' report, enter the totals into TurboTax, and then mail your return to the IRS.'
            + cr + cr + 'We suggest that you use TaxACT if you wish to E-File.',
          mtWarning, [mbOK], 0);
        Result := False;
      end
      else
        sm(FileName + cr + ' was created for your Capital Gains Gains' + cr +
          cr + 'You may now import this txf file into your Tax Software Program' +
          cr + '  (ie: TurboTax, TaxCut, etc.)');
    except
    end; // try
  finally
    // SaveTXF
  end;
end;


procedure EditFileHeader;
var
  I, tYear : Integer;
  S, FileName, OldFileName, delName, newName, reply, Folder : String;
  sFileCode : string;
begin
  tYear := TradeLogFile.TaxYear;
  OldFileName := Settings.DataDir + '\' + TradeLogFile.FileName;
  // Remove the tax year from the file name.
  FileName := Copy(TradeLogFile.FileName, 6);
  // Find the file extension and remove it.
  for I := Length(FileName) downto 1 do begin
    if FileName[I] = '.' then begin
      FileName := Copy(FileName, 1, I - 1);
      break;
    end;
  end;
  // ----------------------------------
  // Suggest the current Data Directory.
  Folder := Settings.DataDir;
  if TdlgFileSave.Execute(tYear, FileName, Folder) = mrOK then begin
    if FileExists(OldFileName)
    and (folder + '\' + FileName <> OldFileName) then begin
      delName := RemoveFileExtension(TradeLogFile.FileName); // 2017-04-11 MB safer code
      newName := RemoveFileExtension(FileName);
      if (mDlg('Are you sure you want replace ' +cr +cr + delName
        + cr + cr + '  with ' + cr + cr + newName + '?',
        mtConfirmation, [mbYes, mbNo], 0) <> mrYes)
      then
        exit;
    end;
    // ----------------------------------------------------
    // 2017-05-05 MB - Handle case of FileName was changed
    // only change TaxFile name if name has been changed
    // ----------------------------------------------------
    if (FileName <> TradeLogFile.FileName) then begin
      sFileCode := TaxpayerExists(v2ClientToken, delName);
      if (sFileCode <> '') then begin
        // delete old Taxpayer from TaxFiles
        s := siteURL+'/taxfile/reset?'
          + 'regcode=' +ProHeader.regCode
          + '&filename=' +delName
          + '&byRC=' +Settings.RegCode
          + '&reason=File Edit';
        reply := readUrl(s);
        // add new Taxpayer to TaxFiles
        S := siteURL + 'taxfile/save-taxpayer?' + 'taxpayer=' + newName
          + '&regcode=' + ProHeader.regCode;
        // tracking info - MB 6/1/2016
        s := s + '&byRC=' +Settings.RegCode
          + '&reason=File Edit';
        reply := readURL(s);
        reply := parseHTML(reply,'<result>','</result>');
        if (reply <> 'OK') then
          mDlg('Could not add Taxpayer to TaxFiles.', mtError, [mbYes], 0);
      end;
      // delete old file
      DeleteFile(OldFileName);
    end;
    // ---------------------------------
    // save new or changed file and open
    // ---------------------------------
    TradeLogFile.SaveFileAs(FileName, Folder, tYear, true);
    OpenTradeLogFile(Folder + '\' + FileName);
  end;
end;


procedure TfrmMain.mnuFileEdit;
begin
  if not CheckRecordLimit then exit;
  if (ProHeader.regCode = TRADELOG_SAMPLE_REGCODE) then begin
    sm('File Edit function is disabled in Sample File.');
    exit;
  end;
  EditFileHeader;
  if (ProVer or SuperUser) and (ProHeader.email <> v2UserEmail) then begin
    v2ClientEmail := ProHeader.email;
    v2ClientToken := Impersonate(v2ClientEmail);
    if (v2ClientToken='') or (pos('Error', v2ClientToken) > 0) then begin
      v2CustomerId := '';
    end
    else begin
      v2CustomerId := GetCustomerId(v2ClientToken); // not same as v2UserId!
    end;
  end;
end;

procedure TfrmMain.mnuFile_EditClick(Sender: TObject);
begin
  mnuFileEdit;
end;


function TfrmMain.SaveCSV: Boolean;
var
  I, RptYear: Integer;
  dacq, dsld, cost, sale, category, washsale, FileName, newPath, rptType, ABCcode: string;
  CSVFile: TextFile;
  ARec: TTradeSum;
  dEnd: Tdate;
  expOptHasComm: Boolean;
  TrSum: PTTrSum;
  Tick : String;
begin
  Result := true;
  FileName := '';
  DoST := true;
  DoLT := true;
  CSVlines := 0;
  if pos('Trial', Settings.TLVer) > 0 then begin
    sm('This report is not available in the Free Trial version');
    exit;
  end;
  // check for commiss in expired options - 2010-03-18
  expOptHasComm := False;
  for I := 0 to TradeLogFile.Count - 1 do begin
    if (pos('OPT', TradeLogFile[I].TypeMult) = 1)
    and (TradeLogFile[I].Price = 0)
    //and (TradeLogFile[I].Commission <> 0) then
    and (compareValue(TradeLogFile[I].Commission, 0, NEARZERO) <> 0) then
    begin
      sm('ERROR - Expired option has commission:'
        + cr + cr + TradeLogFile[I].Ticker);
      expOptHasComm := true;
    end;
  end;
  if expOptHasComm then begin
    sm('Please delete the commission amount from all expired options' + cr
      + 'otherwise TaxACT will not recognize the CSV file' + cr);
    exit;
  end;
  RptYear := StrToInt(TaxYear);
  newPath := Settings.ReportDir;
  if not DirectoryExists(newPath) then ForceDirectories(newPath);
  /// // NEED TO HAVE DIALOG MOVE WITH MAIN WINDOW FOR MULTI-MONITOR SUPPORT ////
  with SaveDialog do begin
    Title := 'Export Gains & Losses to TaxAct csv file';
    InitialDir := newPath;
    DefaultExt := 'csv';
    Filter := 'TaxACT CSV File|*.csv';
    FileName := '';
    if not Execute(Self.Handle) then exit;
  end;
  FileName := SaveDialog.FileName;
  try
    if pos('.', FileName) < 1 then FileName := FileName + '.csv';
    if MidStr(FileName, pos('.', FileName), Length(FileName)) <> '.csv' then
      FileName := leftStr(FileName, pos('.', FileName)) + 'csv';
    if FileExists(FileName) then
      if mDlg('A file named: ' + FileName + cr + 'already exists' + cr + cr +
          'Do you wish to over write this file?', mtConfirmation,
        [mbYes, mbNo], 0) <> mrYes then
        exit
      else
        DeleteFile(FileName);
    AssignFile(CSVFile, FileName);
    Rewrite(CSVFile);
    writeln(CSVFile,
      'Description,Date Acquired,Date Sold,Sales,Cost,Wash Sale,L-T / S-T,Adjustment,Reporting Category');
    with ARec do
      for I := 0 to TrSumList.Count - 1 do begin
        washsale := '';
        TrSum := TrSumList[I];
        tr := TrSum.tr;
        tk := TrSum.tk;
        od := TrSum.od;
        cd := TrSum.cd;
        os := TrSum.os;
        cs := TrSum.cs;
        ls := TrSum.ls;
        oa := TrSum.oa;
        ca := TrSum.ca;
        wsh := TrSum.wsh;
        ws := TrSum.ws;
        prf := TrSum.prf;
        pr := TrSum.pr;
        lt := TrSum.lt;
        // skip if wash sale deferral
        if ws = wsPrvYr then continue;
        // skip exercized options - 2009-04-08
        if (pos('EXERCISED', tk) > 1) then continue;
        // Skip if an IRA Account.
        if (TradeLogFile.FileHeader[StrToInt(TrSum.br)].IRA) then Continue;
        if (oa = 0) and (ca = 0) then continue;
        // skip if futures or currency
        if (pos('FUT', prf) > 0) or (pos('CUR', prf) > 0) then continue;
        Tick := '';
        if (ws = wsThisYr) then
          continue // don't save WS transactions to CSV
        else begin // ws = either wsNone or wsCstAdjd
          dEnd := xStrToDate('12/31/' + intToStr(RptYear));
          // skip if not closed in current tax year
          if ( ( (od <> '') and (xStrToDate(od, Settings.UserFmt) > dEnd) ) //
            or ( (ls = 'L') and (cd <> '') and (xStrToDate(cd,Settings.UserFmt) > dEnd) ) //
            or ( (ls = 'S') and (cd <> '') and (pos('OPT', prf) = 1) //
              and (xStrToDate(cd, Settings.UserFmt) > dEnd) ) ) //
          then
            continue;
          // skip if trade is open long
          if (rndto5(os) <> rndto5(cs)) and (ls = 'L') then continue;
          // skip if trade is open short for tax years > 2010
          if (RptYear > 2010) and (rndto5(os) <> rndto5(cs)) and (ls = 'S') then
            continue;
          // skip if trade is open short option
          if (rndto5(os) <> rndto5(cs)) and (ls = 'S')
          and (pos('OPT', prf) = 1) then begin
            // sm(od+' '+floattostr(oa,Settings.UserFmt));
            continue;
          end;
          if ls = 'S' then begin
            tk := '(S) ' + tk;
            // fix for open short sales 8-9-06
            if (cd = '')
            or ((cd <> '') and (xStrToDate(cd, Settings.UserFmt) > dEnd)) then
            begin
              ca := -oa;
              cd := od;
              tk := tk + ' OPEN'
            end;
            dacq := cd;
            dsld := od;
            cost := FloatToStr(rndto2(-ca), Settings.UserFmt);
            sale := FloatToStr(rndto2(oa), Settings.UserFmt);
            if (cd <> '')
            and (xStrToDate(cd, Settings.UserFmt) > xStrToDate('12/31/' + TaxYear)) then
            begin
              cost := sale;
              dacq := dsld;
            end;
            category := 'S'; // short-term
            if lt = 'L' then category := 'L';
            Tick := tk;
          end
          else if ls = 'L' then begin
            tk := '(L) ' + tk;
            dacq := od;
            dsld := cd;
            cost := FloatToStr(rndto2(-oa), Settings.UserFmt);
            sale := FloatToStr(rndto2(ca), Settings.UserFmt);
            category := 'S';
            if lt = 'L' then category := 'L';
            Tick := tk;
          end;
          Tick := FloatToStr(os, Settings.UserFmt) + Tick;
        end; // if ws..
        if (Tick = 'Wash Sale')
        and (cost = CurrStrEx(0, Settings.UserFmt, true)) then
          continue;
        if (ws = wsTXF) then washsale := 'W'; // wash sale flag
        //change Long-Term ABC code for 2013 and beyond
        if (TradeLogFile.taxyear > 2012)
        and (TrSum.lt = 'L') then begin
          if TrSum.abc = 'A' then ABCcode := 'D'
          else if TrSum.abc = 'B' then ABCcode := 'E'
          else if TrSum.abc = 'C' then ABCcode := 'F';
        end
        else begin
          if TrSum.abc = 'A' then ABCcode := 'A'
          else if TrSum.abc = 'B' then ABCcode := 'B'
          else if TrSum.abc = 'C' then ABCcode := 'C';
        end;
        dAcq := US_DateStr(dAcq,Settings.UserFmt);
        dSld := US_DateStr(dSld,Settings.UserFmt);
        writeln(CSVFile,
          Tick + ',' + dacq + ',' + dsld + ',' + sale + ',' + cost + ',' //
          + washsale + ',' + category + ',' //
          + FloatToStr(TrSum.adjG, Settings.InternalFmt) + ',' + ABCcode);
        inc(CSVlines);
      end; // For ..
    CloseFile(CSVFile);
    if CSVlines > 2000 then begin
      if (TaxYear > '2010') then
        rptType := 'IRS Form 8949'
      else
        rptType := 'Gains and Losses';
      mDlg('Your CSV File has more than 2000 lines and cannot be imported into TaxACT'
        + cr + cr
        + 'You can still E-File with TaxACT but you will have to run and print the TradeLog'
        + cr + rptType
        + ' report, enter the totals into TaxACT, and then mail the report to the IRS.',
        mtWarning, [mbOK], 0);
      Result := False;
    end
    else
      sm(FileName + cr + ' was created for your Capital Gains' + cr + cr
        + 'You may now import this CSV file into TaxAct');
  except
  end; // try
end; // SaveCSV


function TfrmMain.OpenFileDialog(Filter, InitialDir, Title: string;
  var Path: string; var Files: TStringList;
  AllowMultiSelect, NoReadOnly: Boolean): Boolean;
var
  I: Integer;
begin
  Result := False;
  OpenDialog.InitialDir := InitialDir;
  OpenDialog.Filter := Filter;
  OpenDialog.Title := Title;
  OpenDialog.Options := [ofEnableSizing, ofHideReadOnly, ofPathMustExist];
  if AllowMultiSelect then
    OpenDialog.Options := OpenDialog.Options + [ofAllowMultiSelect];
  if NoReadOnly then
    OpenDialog.Options := OpenDialog.Options + [ofNoReadOnlyReturn];
  if OpenDialog.Execute(Handle) then begin
    Path := ExtractFilePath(OpenDialog.Files[0]);
    delete(Path, Length(Path), 1);
    for I := 0 to OpenDialog.Files.Count - 1 do
      Files.Add(ExtractFileName(OpenDialog.Files[I]));
    Result := true;
  end;
end;


function TfrmMain.mnuFileOpen(DlgTitle: String = ''): Boolean;
var
  newPath: String;
  newFiles: TStringList;
begin
  newPath := '';
  if Length(DlgTitle) = 0 then DlgTitle := 'Open Tradelog Data File';
  Result := False;
  newFiles := TStringList.Create;
  try
    newFiles.Capacity := 1;
    If OpenFileDialog('TradeLog data files (*.tdf or *.dat)|*.tdf;*.dat',
      Settings.DataDir, DlgTitle, newPath, newFiles, False, true) then
    begin
      if FileExists(newPath + '\' + newFiles[0]) then begin
        OpenTradeLogFile(newPath + '\' + newFiles[0]);
        bFileOpen := true;
        Result := true;
      end;
    end;
  finally
    newFiles.free;
  end;
end;


procedure TfrmMain.Open1Click(Sender: TObject);
begin
  mnuFileOpen;
end;


function ReportSetup(DisableMenus : Boolean): Boolean;
var
  I: Integer;
begin
  if (TradeLogFile.FileHeaders.Count > 1) //
  and (frmMain.TabAccounts.TabIndex = 0) //
  and (ReportStyle = rptRecon) then begin
    mDlg('You cannot run 1099 Reconciliation report from the All Accounts tab.', mtInformation, [mbOK], 0);
    Exit(False);
  end;
  if (frmMain.cxGrid1TableView1.DataController.FilteredRecordCount = 0) //
  and (ReportStyle <> rptRecon) then begin
    mDlg('No records to run report', mtInformation, [mbOK], 0);
    Exit(False);
  end;
  if (Pos('Date', GetFilterCaption) > 0) //
  and (ReportStyle in [rptTradeSummary, rptSubD1, rptIRS_D1, rptGAndL]) then begin
    if mDlg('This report cannot be run when the grid is filtered by date!'
      + CR + 'In order to continue TradeLog must remove the current grid filter. '
      + CR + CR + 'Are you sure?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      frmMain.btnShowAll.Click
    else begin
      exit(False);
    end;
  end;
  if ReportStyle <> rptRecon then frmMain.pnlTools.hide;
  with frmMain do begin
    if DisableMenus then begin
      for I := 0 to MainMenu.Items.Count - 1 do
        MainMenu.Items[I].Enabled := False;
      for I := 0 to pupEdit.Items.Count - 1 do
        pupEdit.Items[I].Enabled := False;
      for I := 0 to pupView.Items.Count - 1 do
        pupView.Items[I].Enabled := False;
      for I := 0 to pupFind.Items.Count - 1 do
        pupFind.Items[I].Enabled := False;
    end;
    panelMsg.Visible := ReportStyle = rptRecon;
    //pnlTools.Visible := ReportStyle = rptRecon;    //why is this visible for recon?
    show;
    if Settings.AcctName = '' then
      Settings.AcctName := myInputBox('Name', 'Please enter your name for reports', '', frmMain.Handle);
    tabAccounts.Enabled := False;
  end;
  Result := true;
end;


procedure TfrmMain.TransferOpensToAcct;
var
  NewBrokerID, lastTrNum : Integer;
  OpenPositions : TTLTradeNumList;
  TradeNum : TTLTradeNum;
  ORecDatesList : TList<double>;
begin
  if not CheckRecordLimit then Exit;
  NewBrokerID := 0;
  // ------------------------------------------------------
  // Get OpenPositions based on AsOfDate
  OpenPositions := TradeLogFile.OpenPositions[TradeLogFile.LastDateImported];
  if OpenPositions.Count = 0 then begin
    mDlg('No Open Positions to transfer', mtInformation, [mbOK], 0);
    exit;
  end;
  // ------------------------------------------------------
  if mDlg(
    'WARNING: Transfering open positions will perform the following steps:' + cr +
      '   1) Allow you to choose an existing Account or create a new Account to transfer to.' + CR +
      '   2) Copy all open positions from the current Account to the Account specified.' + cr+
      '   3) Close all open positions in the current Account.' + cr + cr +
      'Are you sure you want to transfer open positions?', mtWarning, [mbYes, mbNo], 0) = mrNo then
    exit;
  // ------------------------------------------------------
  // 1. They need to select which broker to transfer to.
  if TradeLogFile.FileHeaders.Count > 1 then
    if TdlgBrokerSelect.Execute(NewBrokerID, 'Select Account to use for Transfer') = mrCancel then
      exit;  {Canceling the dialog box means they want to cancel the process}
  // If they did not select a broker then the want to add a new broker
  if NewBrokerID < 1 then
    NewBrokerID := AddNewAccount(False) // don't save yet because we save 20 lines down.
  else
    ChangeToTab(TradeLogFile.FileHeader[NewBrokerID].AccountName);
  if NewBrokerID = -1 then exit;
  // ------------------------------------------------------
  try
    // keeps track of O rec dates for matching W recs
    ORecDatesList := TList<double>.create;
    lastTrNum := 0;
    for TradeNum in OpenPositions do begin
      if (TradeNum.TradeNum <> lastTrNum) then ORecDatesList.Clear;
      lastTrNum := TradeNum.TradeNum;
      TradeNum.TransferOpenPosition(
        NewBrokerID, TradeLogFile.TradeNums.NextTradeNum, ORecDatesList);
    end;
  finally
    ORecDatesList.free;
  end;
  TradeLogFile.SortByTrNumber;
  TradeLogFile.MatchAll;
  TradeLogFile.Reorganize;
  TradeRecordsSource.DataChanged;
  SaveTradeLogFile('Transfer Open Positions');
end;

procedure TfrmMain.TransferOpenPositions1Click(Sender: TObject);
begin
  TransferOpensToAcct;
end;

procedure TfrmMain.ChangeToTab(AccountName : String);
var
  I : Integer;
begin
  for I := 0 to tabAccounts.Tabs.Count - 1 do
    if tabAccounts.Tabs[I].Caption = AccountName then begin
      tabAccounts.TabIndex := I;
      exit;
    end;
end;


procedure TfrmMain.ChangeTypeMult1Click(Sender: TObject);
var
  I, aRow, ARec: Integer;
  aRowInfo: TcxRowInfo;
  TypeMultForm : TfrmTypeMult;
  TrNums : String;
  LastTrNum : Integer;
  SelectCount : Integer;
begin
  if cxGrid1TableView1.DataController.GetSelectedCount = 0 then begin
    mDlg('No records selected!' + cr + cr +
        'Please select the records you would like to change.', mtError, [mbOK],
      1);
    exit;
  end;
  if not CheckRecordLimit then Exit;
  SaveTradesBack('Change Type/Mult');
  TrNums := '';
  LastTrNum := 0;
  TypeMultForm := TfrmTypeMult.Create(Self);
  try
    if TypeMultForm.ShowModal = mrOK then begin
      with cxGrid1TableView1.DataController do begin
        BeginUpdate;
        SelectCount := GetSelectedCount;
        for I := 0 to GetSelectedCount - 1 do begin
          aRow := GetSelectedRowIndex(I);
          aRowInfo := GetRowInfo(aRow);
          ARec := aRowInfo.RecordIndex;
          values[ARec, 9] := TypeMultForm.cboTypeMult.Text;
          if LastTrNum <> Values[ARec, 1] then begin
            LastTrNum := Values[ARec, 1];
            if Length(TrNums) > 0 then TrNums := TrNums + ',';
            TrNums := TrNums + IntToStr(LastTrNum);
          end;
        end;
        {If they happen to be filtered on type multiplier then the filtered record list may change
          when we change the type multiplier, so lets, filter by TrNums so that we are still showing
          the record set that was edited when they are asked to save.
        }
        EndUpdate;
        if SelectCount <> GetSelectedCount then begin
          ClearFilter;
          filterByTrNum(TrNums);
        end;
      end;
      SaveGridData(true);
    end;
  finally
    TypeMultForm.Free;
  end;
end;


procedure TfrmMain.About1Click(Sender: TObject);
begin
  AboutTL;
end;


procedure TfrmMain.btnImportClick(Sender: TObject);
var
  fromDate : TDate;
  maxOFX : integer;
begin
  if OneYrLocked or isAllBrokersSelected then exit;
  if not CheckRecordLimit then exit;
  // ------------------------------------------------------------
  if TradeLogFile.CurrentAccount.FileImportFormat = '' then begin
    sm('No import Filter Selected');
    exit;
  end;
  // ------------------------------------------------------------
  dtBegTaxYr := xStrToDate('01/01/' + TaxYear, Settings.InternalFmt);
  dtEndTaxYr := xStrToDate('12/31/' + TaxYear, Settings.InternalFmt);
  if TradeLogFile.LastDateImported + 1 < dtBegTaxYr then
    fromDate := dtBegTaxYr
  else
    fromDate := TradeLogFile.LastDateImported +1;
  // ------------------------------------------------------
  maxOFX := TradeLogFile.CurrentAccount.ImportFilter.OFXMonths;
//  if (Settings.LegacyBC) and (maxOFX > 0) //
//  and TradeLogFile.CurrentAccount.ImportFilter.OFXConnect //
//  and (now - maxOFX * 30 > fromDate) //
//  and (TradeLogFile.CurrentAccount.ImportFilter.FilterName = 'Fidelity') then begin
//    mDlg('Fidelity OFX data is limited to the last ' //
//      + intToStr(maxOFX) + ' months.' + cr //
//      + cr //
//      + 'Please use the Fidelity csv import method instead', //
//      mtWarning,[mbOK],0);
//    exit;
//  end;
  // ------------------------------------------------------------
  if panelSplash.Visible then begin
    if mDlg('Are you sure you have no open positions from last year?', //
      mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      GridEscape;
      panelSplash.hide;
    end
    else begin
      sm('Please enter your open positions now');
      exit;
    end;
  end;
  // ------------------------------------------------------------
  if TradeLogFile.YearEndDone then begin // cannot import after end tax year
    mDlg('You can no longer import into this file' + cr //
      + 'because a ' + NextTaxYear + ' data file was created' + cr //
      + 'when you ended the tax year in this file.' + cr //
      + cr //
      + 'Please open your ' + NextTaxYear + ' data file' + cr //
      + 'to import your ' + NextTaxYear + ' trades.', mtWarning, [mbOK], 0);
    exit;
  end
  else if (TradeLogFile.LastDateImported = today - 1) then begin
    if (TradeLogFile.CurrentAccount.FileImportFormat = 'IB') //
    or (TradeLogFile.CurrentAccount.FileImportFormat = 'Fidelity') //
    or (TradeLogFile.CurrentAccount.FileImportFormat = 'optionsXpress') //
    or (TradeLogFile.CurrentAccount.FileImportFormat = 'TradeStation') then begin
      sm('Cannot import trades past yesterday ' //
        + dateToStr(TradeLogFile.LastDateImported, Settings.UserFmt));
      exit;
    end
    else if mDlg('Trades already imported up to yesterday ' //
      + dateToStr(TradeLogFile.LastDateImported, Settings.UserFmt) + cr //
      + 'If you import today''''s trades you may import duplicate trades' + cr //
      + cr //
      + 'Do you want to continue with this import?', //
      mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    begin
      exit;
    end;
  end;
  // ------------------------------------------------------------
  statBar('Importing Trade History');
  btnShowAll.Click;
  DeleteFile('filter.txt');
  statBar('Importing Trade History');
  // ------------------------------------------------------------
  bImporting := true;
  FileImport(False); // <-- MAIN ROUTINE
  bImporting := False;
  // ------------------------------------------------------------
  if stkAssignsPriceZero then begin
    FilterByStkAssignsPriceZero;
    mDlg('These stocks were assigned and no price was provided by your broker!' + cr //
      + cr //
      + 'You MUST look up the prices for all these stock assignments' + cr //
      + 'and edit all these records so you can properly Exercise your option trades' + cr, //
      mtWarning,[mbOK],1);
    stkAssignsPriceZero := false;
  end
  else
    btnShowAll.Click;
  // end if
  // ------------------------------------------------------------
  if TradeLogFile.CurrentAccount.ImportFilter.BrokerHasTimeOfDay then begin
    if (bbUser_Time.EditValue = false) then begin
      if mDlg('This broker reports trade times, but you have the trade' + CR //
        + 'time column hidden. Would you like to display it now?', //
        mtWarning, [mbYes, mbNo], 0) = mrYes
      then begin
        Settings.DispTimeBool := TRUE;
        SetOptions;
      end;
    end;
  end;
end;


procedure TfrmMain.btnImportHelpClick(Sender: TObject);
var
  InstrPage : string;
begin
  InstrPage := TradeLogFile.CurrentAccount.importFilter.InstructPage;
  if pos('tradelogsoftware.com', InstrPage) > 0 then // security chack
    webURL(InstrPage)
  else
    webURL(SiteURL + 'support/broker-imports/'); // 2019-01-25 MB
end;


//procedure TfrmMain.btnManualEntryClick(Sender: TObject);
//var
//  f : TfManualEntry;
//begin
//  f := TfManualEntry.Create(Nil);
//  try
//    f.ShowModal;
//  finally
//    f.Free;
//  end;
//end;


procedure TfrmMain.bbRecords_ConsolidatePartialFillsClick(Sender: TObject);
begin
  consolidateRecords;
end;


// ---------------+
//   DELETE ALL   |
// ===============+
procedure TfrmMain.bbRecords_DeleteAllClick(Sender: TObject);
begin
  try
    if not CheckRecordLimit then Exit;
    // -----------------
    DelAll;
    // repaintGrid;
  finally
    // DeleteAll1Click
  end;
end;

// ---------------+
//     DELETE     |
// ===============+
procedure TfrmMain.bbRecords_DeleteClick(Sender: TObject);
begin
  try
    if not CheckRecordLimit then Exit;
    // -----------------
    if not cxGrid1TableView1.optionsData.editing then
      DelSelectedRecords;
    cxGrid1.SetFocus;
    repaintGrid;
  finally
    //
  end;
end; // DeleteSelectedRecClick


// ---------------+
//      EDIT      |
// ===============+
procedure TfrmMain.bbRecords_EditClick(Sender: TObject);
begin
  EditRec1Click(Sender);
end;


// ---------------+
//      SPLIT     |
// ===============+
procedure TfrmMain.bbRecords_SplitTradeClick(Sender: TObject);
begin
  splitRecord;
end;


procedure TfrmMain.FileStatusCallBack(Msg: String);
begin
  statBar(Msg);
end;


procedure TfrmMain.CashAccounts1Click(Sender: TObject);
begin
  if Not FilterByBrokerAccountType(False, False, True) then
    mDlg('No Cash accounts exist in this file', mtInformation, [mbOK], 0);
end;

procedure TfrmMain.IRAAccounts1Click(Sender: TObject);
begin
  if Not FilterByBrokerAccountType(False, True, False) then
    mDlg('No IRA accounts exist in this file', mtInformation, [mbOK], 0);
end;


procedure TfrmMain.Register1Click(Sender: TObject);
begin
  RegisterTL(false);
  if TradeLogFile <> nil then begin
    SetupOpenCloseItems;
    SetupReportsMenu;
  end;
  statBar('off');
  screen.Cursor := crDefault;
end;


procedure TfrmMain.SelectAllClick(Sender: TObject);
begin
  cxGrid1TableView1.DataController.SelectAll;
end;


procedure TfrmMain.CopyMenu(const dst, src: TMenuItem);
var
  m: TMenuItem;
  I: Integer;
begin
  dst.Clear;
  for I := 0 to src.Count - 1 do begin
    m := TMenuItem.Create(Self);
    dst.Add(m);
    m.Name := 'popup' + src.Items[I].Name;
      //if (src=mnuAcct) then sm(m.Name);
    m.Caption := src.Items[I].Caption;
    m.OnClick := src.Items[I].OnClick;
    m.Tag := src.Items[I].Tag;
    m.ImageIndex := src.Items[I].ImageIndex;
    m.checked := src.Items[I].checked;
    m.Default := src.Items[I].Default;
    m.Enabled := src.Items[I].Enabled;
    m.GroupIndex := src.Items[I].GroupIndex;
    m.HelpContext := src.Items[I].HelpContext;
    m.hint := src.Items[I].hint;
    m.Action := src.Items[I].Action;
    m.Break := src.Items[I].Break;
    m.RadioItem := src.Items[I].RadioItem;
    m.ShortCut := src.Items[I].ShortCut;
    m.Visible := src.Items[I].Visible;
    m.OnDrawItem := src.Items[I].OnDrawItem;
    m.OnMeasureItem := src.Items[I].OnMeasureItem;
    m.OnAdvancedDrawItem := src.Items[I].OnAdvancedDrawItem;
    m.SubMenuImages := src.Items[I].SubMenuImages;
    m.AutoCheck := src.Items[I].AutoCheck;
    if src.Items[I].Count > 0 then CopyMenu(m, src.Items[I]);
  end;
end;


// ----------------------------------------------
// COPY
// ----------------------------------------------
procedure TfrmMain.Copy1Click(Sender: TObject);
begin
  if Settings.TrialVersion then begin
    sm('Copy function is disabled in Trial.' +cr
      +cr +'No records have been copied.');
    exit;
  end;
  btnCopy.Click;
  repaintGrid;
end;


function CopyTradesToClipboard(bColVis: Boolean): Integer;
var
  I, J, RowIndex, RecIndex : Integer;
  s, t : String;
  ColsToSkip : TList<Integer>;
  ClipStringList : TStringList;
begin
  ClipStringList := TStringList.Create;
  ColsToSkip := TList<Integer>.Create;
  Result := 0;
  try
    Result := frmMain.cxGrid1TableView1.DataController.GetSelectedCount;
    // Get all the column headings.
    s := '';
    for J := 0 to frmMain.cxGrid1TableView1.DataController.ItemCount - 1 do begin
      t := TcxGridColumn(frmMain.cxGrid1TableView1.DataController.GetItem(J)).Caption
        + ' ' + booltostr(TcxGridColumn(frmMain.cxGrid1TableView1.DataController.GetItem(J)).Visible);
      // skip columns that are never visible
      if (J = 14) // open
      or (J = 18) // tksort
      or (J = 21) // AcctType
      or (J = 23) // mSort
      or (J = 24) // wsSort
      then continue;
      // skip columns that are not visible
      if not (TcxGridColumn(frmMain.cxGrid1TableView1.DataController.GetItem(J)).Visible)
      and bColVis then begin
        ColsToSkip.add(J);
        continue;
      end;
      // get the visible columns
      if (TcxGridColumn(frmMain.cxGrid1TableView1.DataController.GetItem(J)).Caption <> 'tkSort')
      then begin
        s := s + TcxGridColumn(frmMain.cxGrid1TableView1.DataController.GetItem(J)).Caption + Tab;
      end;
    end;
    ClipStringList.Append(copy(s, 1, Length(s) - 1)); // Remove the last tab.
    // Now get all the data
    for I := 0 to frmMain.cxGrid1TableView1.DataController.GetSelectedCount - 1 do begin
      try
        RowIndex := frmMain.cxGrid1TableView1.DataController.GetSelectedRowIndex(I);
        RecIndex := frmMain.cxGrid1TableView1.DataController.GetRowInfo(RowIndex).RecordIndex;
          s := '';
          for J := 0 to frmMain.cxGrid1TableView1.DataController.ItemCount-1 do begin
            // skip columns that are never visible
            if (J = 14) // open
            or (J = 18) // tksort
            or (J = 21) // AcctType
            or (J = 23) // mSort
            or (J = 24) // wsSort
            then continue;
            // skip columns that are not visible
            if not (TcxGridColumn(frmMain.cxGrid1TableView1.DataController.GetItem(J)).Visible)
            and bColVis then begin
              ColsToSkip.add(J);
              continue;
            end;
            s := s + frmMain.cxGrid1TableView1.DataController.GetDisplayText(RecIndex,J) + tab;
          end;
          ClipStringList.Append(s);
      except
        On E: Exception Do
          mDlg('Error in CopyTradesToClipboard' + cr + 'Error Message: ' +
            E.Message + cr + 'i: ' + intToStr(I), mtError, [mbOK], 0);
      end;
    end;
    // ----------------------
    if Result > 0 then begin
      Clipboard.clear;
      Clipboard.AsText := ClipStringList.Text;
    end;
  finally
    ClipStringList.Free;
    ColsToSkip.Free;
  end;
end;

// --------------------------
procedure TfrmMain.actnCopyClick(Sender: TObject);
var
  RecsSelected : integer;
  bColVis : boolean;
begin
  bcolVis := false;
  if Settings.TrialVersion then begin
    sm('Copy function is disabled in Trial.' +cr
      +cr +'No records have been copied.');
    exit;
  end;
  if (cxGrid1TableView1.DataController.GetSelectedCount = 0) then begin
    mDlg('No Records Selected - Please select some records to copy', mtError, [mbOK], 0);
    exit;
  end;
  // ---------- actnCopyClick ---------
  try
    if (mDlg('Copy visible columns only?', mtConfirmation, [mbYes, mbNo], 0)
      = mrYes) then bColVis := true;
    statBar('Copying Records to Windows Clipboard.');
    screen.cursor := crHourglass;
    RecsSelected := CopyTradesToClipboard(bColVis);
    mDlg(intToStr(RecsSelected) + ' Records copied to clipBoard', mtInformation, [mbOK], 0);
  finally
    statBar('off');
    screen.cursor := crDefault;
  end;
end;


procedure TfrmMain.CopySumClick(Sender: TObject);
begin
  CopyTradesSumToClip;
end;


// ---------------+
// glStartDate    |
// ---------------+
procedure TfrmMain.glStartDatePropertiesEditValueChanged(Sender: TObject);
begin
  if not pnlGains.Visible then exit;
end;

procedure TfrmMain.glStartDatePropertiesValidate(Sender: TObject;
  var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
var
  thisDay, endDay: Tdate;
begin
  with glStartDate do begin
    if DisplayValue <> '' then begin
      thisDay := xStrToDate(DisplayValue, Settings.UserFmt);
      endDay := xStrToDate(glEndDate.Text, Settings.UserFmt);
      if thisDay >= endDay then begin
        sm('START date must be Less than END date');
        thisDay := IncDay(endDay, -1);
        if date > properties.maxDate then
          date := properties.maxDate
        else
          date := thisDay;
      end
      else if date < properties.minDate then
        properties.minDate := date
      else if date > properties.maxDate then
        properties.maxDate := date
      else
        exit;
    end
    else
      date := properties.minDate;
    glStartDate.Text := dateToStr(date, Settings.UserFmt);
    ErrorText := '';
    Error := true;
  end;
end;


procedure TfrmMain.Image1Click(Sender: TObject);
begin
  webURL(siteURL);
end;

procedure TfrmMain.ImageGTTClick(Sender: TObject);
begin
  webURL(siteURL + 'gtttradelog');
end;

procedure TfrmMain.Import1Click(Sender: TObject);
begin
  tabAccounts.SetFocus;
  mnuAcct_ImportClick(Sender);
end;

procedure TfrmMain.lbFilterDblClick(Sender: TObject);
begin
  mDlg(frmMain.cxGrid1TableView1.DataController.Filter.FilterCaption, mtInformation, [mbOK], 0 );
end;

procedure TfrmMain.lblPurchaseClick(Sender: TObject);
begin
  webURL(securesiteURL + 'purchase');
end;


procedure TfrmMain.DisableIfNoFileOpen;
var
  comp : TComponent;
begin
  if Pos('.tdf', frmMain.Caption) = 0 then
    EnableTabItems('NoFileOpen');
  // things you can't do if there isn't any file open
  // fine-tune if necessary
end;


procedure TfrmMain.CloseFileIfAny;
begin
  if Not OpeningFile then begin
    screen.Cursor := crHourglass;
    StatBar('Closing File');
    CloseFormIfOpen('frmOpenTrades'); // 2021-05-21 MB - don't stay in "holdings" mode!
    CloseAdditionalForms; // closes Excercise/Assign form
    cxGrid1TableView1.DataController.Filter.Clear;
    dispProfit(false, 0, 0, 0, 0);
    FreeAndNil(TradeLogFile);
    FreeAndNil(TradeRecordsSource);
    FreeAndNil(lineList);
    ProHeader.TDFpassword := '';
    isDBFile := false;
    TrFileName := '';
    Caption := Settings.TLVer + ' - ' + Settings.DataDir + '\';
    panelSplash.show;
    panelSplash.SetupForm;
//    if Settings.DispQS then panelQS.doQuickStart(1, 1);
    panelMsg.ClearTradeIssues;
    tabAccounts.Tabs.Clear;
    stAcctType.Visible := false;
    rbStatusBar.Panels[3].Visible := false;
    stImportType.Visible := false;
    rbStatusBar.Panels[4].Visible := false;
    statBar('off');
    screen.Cursor := crDefault;
    bFileOpen := false;
    ClearTempProHdr; // 2021-05-21 MB can't keep ProHeader!
    ClearProHeader; // same
    if SuperUser or ProVer then // was using Client CustomerId
      v2CustomerId := v2UserId; // reset to User's CustomerId
    DisableIfNoFileOpen;
  end;
end;


procedure TfrmMain.Close1Click(Sender: TObject);
begin
  CloseFileIfAny;
end;


procedure TfrmMain.CloseAdditionalForms;
var
  I: Integer;
  F: TForm;
begin
  for I := Screen.FormCount - 1 downto 0 do begin
    F := Screen.Forms[I];
    if F is TfrmExerciseAssign and F.Visible then
      F.close;
  end;
end;


procedure TfrmMain.ToggleShortLong1Click(Sender: TObject);
begin
  if oneYrLocked or isAllBrokersSelected then exit;
  if not CheckRecordLimit then exit;
  readFilter;
  ToggleShortLong;
  if not PanelMsg.visible then writeFilter(true);
  if (cxGrid1TableView1.DataController.RowCount = 0) then clearFilter;
  repaintGrid;
  FindTradeIssues;
end;


// ------------------------------------
// Exercise/Assign Options
// ------------------------------------
procedure TfrmMain.ExerciseAssign1Click(Sender: TObject);
var
  I: Integer;
  m: TModalResult;
begin
  if not CheckRecordLimit then exit;
  if TradeLogFile.HasNegShares then begin
    mDlg('You must fix all trades with Negative Share'+cr+
      ' warnings before you run this function!'
      ,mtWarning, [mbOK], 0);
    screen.cursor := crDefault;
    exit;
  end;
  if Length(TradeLogFile.GetInvalidOptionTickers) > 0 then begin
    m := mDlg('WARNING: Some Option Tickers are Invalid.' + cr //
      + cr //
      + 'These Option trades will not be exercisable and' + cr //
      + 'therefore will not show up in the Exercise list until' + cr //
      + 'you fix the tickers in error!' + cr //
      + cr //
      + 'Would you like to fix them now?', mtWarning, [mbYes, mbNo, mbCancel], 0);
    case m of
      mrYes:
        InvalidTickers1.Click;
      mrNo:
        DiscoverExerciseAssigns;
      mrCancel:
        exit;
    end;
  end
  else
    DiscoverExerciseAssigns;
end;


//procedure TfrmMain.ConvertOldDataFiles1Click(Sender: TObject);
//begin
//  // for TL26 future use
//  ExecuteFile('tlconvert.exe', '', Settings.InstallDir, SW_SHOW);
//  ConvertOldDataFiles1.Visible := False;
//end;


procedure TfrmMain.TaxYearHelpClick(Sender: TObject);
begin
  ExecuteFile('IEXPLORE.EXE', Settings.WebSiteURL + '/taxyearhelp.shtml',
    Settings.InstallDir, SW_SHOW);
end;


procedure TfrmMain.Update1Click(Sender: TObject);
var
  I: Integer;
  TimeOut: Boolean;
begin
  if oneYrLocked then begin
    sm('Cannot update when subscription is expired');
    exit;
  end;
  UpdateTradeLogExe(false);
  close; // closes main form and exits application
  Screen.Cursor := crDefault; // need to reset cursor!
end;


procedure TfrmMain.Purchase1Click(Sender: TObject);
begin
  webURL(secureSiteURL + 'purchase/?regcode=' + Settings.RegCode);
end;


procedure TfrmMain.PageSetup1Click(Sender: TObject);
begin
  TPageSetupDlg.Execute;
  SetupReportsMenu;
end;


procedure TfrmMain.ReOrderTradeNumbers1Click(Sender: TObject);
var
  Start: TDateTime;
  NegShares : Boolean;
begin
  NegShares := TradeLogFile.HasNegShares;
  if oneYrLocked or isAllBrokersSelected then exit;
  if not CheckRecordLimit then Exit;
  if mDlg('This will match and renumber all trades' + cr + cr
    + 'Are you sure?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    readFilter;
    Start := now;
    try
    // We need to renumber the item field here because thet items may be out
    // of order for some reason or another, but the trades as they are in the
    // grid should be in the correct order, so renumbering the item number
    // will ensure that the trades are processed in the order they exist now
    // in the grid.
      TradeLogFile.RenumberItemField;
      TradeLogfile.MatchAndReorganize;
      TradeRecordsSource.DataChanged;
      if NegShares then begin
        ClearFilter;
        FindTradeIssues;
      end;
      statBar('Total Time: '
        + FloatToStr(StrFmtToFloat('%1.3f', [((now - Start) * 86400)], Settings.UserFmt)));
      SaveTradeLogFile('Renumber/Rematch Trades');
    finally
      if not NegShares then writeFilter(False);
    end;
  end;
end;


procedure TfrmMain.mnuFileResetUser;
var
  sResult, sEmail, sToken, sTmp, sLine, sFC : string;
  i, j, k, nFileKeys, nFKAvail, nRetCode, nCanceled : integer;
  FKeyLst, lineLst : TStrings;
  f: TdlgPickTaxFiles;
begin
  // get available TaxFiles
  if SuperUser then begin // the email from the FILE
    sEmail := ProHeader.email;
    sToken := v2ClientToken;
  end
  else begin // use the RegCode of the current USER
    sEmail := Settings.UserEmail;
    sToken := v2UserToken;
  end;
  // --- init counters ------
  nFileKeys := 0;
  nFKAvail := 0;
  nCanceled := 0;
  // ----------------------------------
  try
    StatBar('Searching for list of File Keys');
    screen.Cursor := crHourglass;
    sTmp := ListFileKeys(sToken);
    if (sTmp = '') or (pos('no matching', lowercase(sTmp)) > 0) then begin
      sm('no File Keys found for email' + CR + sEmail);
      exit;
    end;
    // --------------------------------
    f := TdlgPickTaxFiles.Create(nil);
    f.Caption := 'File Keys for ' + sEmail;
    if not SuperUser then begin
      f.btnReset.Visible := false;
      f.btnDelete.Visible := false;
      f.btnClose.Caption := 'Close';
      f.btnTracking.Visible := false;
    end;
    j := 1;
    // --------------------------------
    FKeyLst := ParseJSON(sTmp); // {FileKey1},{FileKey2}...
    FileCodes := TStringList.Create;
    try
    for i := 0 to FKeyLst.Count-1 do begin
      sTmp := FKeyLst[i];
      nFileKeys := nFileKeys + 1;
      lineLst := ParseV2APIResponse(sTmp);
      if assigned(lineLst)=false then continue;
      {"UserToken":"c1ff67d8-b47f-11ed-afb1-f23c938e66e4",
       "Email":"summa.iru@gmail.com",
       "FileCode":"9fbddc94-9410-11ee-840e-f23c938e66e4",
       "FileName":"CANCELLED", "TaxPayer":null, "TaxYear":null,
       "DateUsed":null, "CanceledDate":1701820800000}
      if lineLst.Count > 15 then begin // added
        if (lineLst[15] <> '') and (lineLst[15] <> 'null') // canceled
        then begin
          nCanceled := nCanceled + 1;
          nFileKeys := nFileKeys - 1;
        end
        else if ((lineLst[7] = 'null') or (lineLst[7] = '')) // not used
        then begin
          nFKAvail := nFKAvail + 1;
          if SuperUser then begin
            f.lstTaxfiles.Add('<available>');
            sFC := lineLst[5];
            FileCodes.Add(sFC);
          end; // if SuperUser
        end
        else begin // must be in use
          sLine := lineLst[7]; // FileName
          f.lstTaxfiles.Add(sLine);
          sFC := lineLst[5];
          FileCodes.Add(sFC);
        end; // if lineLst[x]
      end; // if count > 15
    end; // for i
    except
      On E : Exception do begin
        sTmp := 'ERROR: ' + E.Message;
      end; // on E
    end;
  finally
    StatBar('off');
    screen.Cursor := crDefault;
  end;
  f.lblTaxFiles.Caption := intToStr(nFileKeys-nFKAvail);
  f.lblAvailable.Caption := intToStr(nFKAvail);
  if SuperUser and (f.lstTaxfiles.count <> nFileKeys) then
    sm('Total # File Keys = ' + IntToStr(nFileKeys) + CR //
      + '#Linked File Keys = ' + IntToStr(nFileKeys-nFKAvail) + CR //
      + '#Available File Keys = ' + IntToStr(nFKAvail));
  nRetCode := f.ShowModal;
  // --------------------------------------------
  // Process return code from dlgTaxfilePicker
  // --------------------------------------------
  try
    if SuperUser then begin // a prerequisite!
    // -------------------------------------
    if (nRetCode = mrOK) then begin // RESET
      if f.lstTaxfiles.SelCount < 1 then begin
        sm('Please select a File Key first.');
      end
      else if f.lstTaxFiles.SelCount > 1 then begin
        sTmp := 'Are you sure you want to completely reset' + CRLF
          + IntToStr(f.lstTaxfiles.SelCount) + ' File Keys from' + CRLF
          + 'eMail = ' + ProHeader.email;
        if mdlg(sTmp, mtWarning, mbYesNo, 0) <> mrYes then exit;
      end;
      // -- delete selected taxfiles ----
      for i := 0 to f.lstTaxfiles.Items.Count-1 do begin
        if f.lstTaxfiles.Selected[i] then begin
          // delete it
          sTmp := f.lstTaxfiles.Items[i]; // this is the file key Name
          if (i >= FileCodes.Count) then
            sTmp := 'ERROR: not enough file codes for list box';
          sFC := FileCodes[i];
          // release a used file key
          sResult := UpdateFileKey(sToken, sEmail, sFC, '', '', '0');
        end;
      end;
    end // if nRetCode...
    // -------------------------------------
    else if (nRetCode = mrYes) then begin // DELETE
      if f.lstTaxfiles.SelCount < 1 then begin
        sm('Please select a File Key first.');
      end
      else if f.lstTaxFiles.SelCount > 1 then begin
        sTmp := 'Are you sure you want to completely reset' + CRLF
          + IntToStr(f.lstTaxfiles.SelCount) + ' File Keys from' + CRLF
          + 'eMail = ' + ProHeader.email;
        if mdlg(sTmp, mtWarning, mbYesNo, 0) <> mrYes then exit;
      end;
      // -- delete selected taxfiles ----
      for i := 0 to f.lstTaxfiles.Items.Count-1 do begin
        if f.lstTaxfiles.Selected[i] then begin
          // delete it
          sTmp := f.lstTaxfiles.Items[i]; // this is the file key Name
          if (sTmp <> '<available>') then begin
            sm('Cannot delete used FileKey!' + CRLF + 'You may reset it 1st.');
          end
          else begin
            sFC := FileCodes[i];
            // delete an available file key
            sResult := SuperDeleteFileKey(v2UserToken, sEmail, sFC);
          end;
        end;
      end;
    end; // if nRetCode...
    end; // if SuperUser
  finally
    f.free;
  end;
  FileCodes.Free;
end;


procedure TfrmMain.mnuFile_ResetUserClick(Sender: TObject);
begin
  mnuFileResetUser;
end;


procedure TfrmMain.mnuFindCTNsClick(Sender: TObject);
begin
  filterByType('CTN', True);
end;

procedure TfrmMain.mnuFindVTNClick(Sender: TObject);
begin
  filterByType('VTN', True);
end;

procedure TfrmMain.bbFile_EditClick(Sender: TObject);
begin
  mnuFileEdit;
end;

procedure TfrmMain.bbFile_mruLastFileClick(Sender: TObject);
var
  AFileName: String;
begin
  AFileName := bbFile_mruLastFile.Items[bbFile_mruLastFile.ItemIndex];
  if FileExists(AFileName) then
    OpenTradeLogFile(AFileName)
  else
    Application.MessageBox(PChar(AFileName+#10#13+'File not found.'),'Open',MB_OK or MB_ICONERROR)
end;

procedure TfrmMain.Paste1Click(Sender: TObject);
begin
  if oneYrLocked or isAllBrokersSelected then exit;
  if not CheckRecordLimit then exit;
  FileImport(true);
  btnShowAll.Click;
end;


procedure TfrmMain.EnableMenuToolsALL;
var
  I, J : integer;
begin
  // enable menu
  // frmMain.ReverseEndYear1.Enabled := TradeLogFile.YearEndDone;
  bbFile_ReverseEndYear.Enabled := TradeLogFile.YearEndDone;
  bbFile_EndTaxYear.Enabled := not(TradeLogFile.YearEndDone);
  if not panelSplash.Visible then begin
    frmMain.Register1.enabled:= false;
    frmMain.Update1.enabled:= false;
  end;
  //enable toolbar
  for I := 0 to ToolBar1.controlcount - 1 do
    ToolBar1.Controls[i].Enabled := True;
  ToolBar1.Visible := false; // 2021-06-07 MB - do not show!
  ToolBarHelp.Visible := false; // same
  // special case for btnCheckList
  btnCheckList.Enabled := (TradeLogFile.CurrentBrokerID > 0);
  // enabled if file is open
  bbFile_Save.Enabled := true;
  // ----- pop-up menus -----
  SetPopupMenuEnabled(pupEdit, True);
  SetPopupMenuEnabled(pupView, True);
  SetPopupMenuEnabled(pupFind, True);
  pnlTools.Visible := True;
  tabAccounts.Enabled := True;
  // ------------------------
  for I := 0 to RibbonMenu.Tabs.Count-1 do begin
    if RibbonMenu.Tabs[I].Name = 'mtSuperUser' then
      mtSuperUser.Visible := SuperUser
    else
      RibbonMenu.Tabs[I].Visible := true;
  end; // end for I loop
  RibbonMenu.ShowTabGroups := true;
  bbFile_Close.Enabled := true; // because a file is open
end;


// ----------------------------------------------
procedure TfrmMain.mnuFile_EndTaxYearClick(Sender : TObject);
var
  sAcctCode, sFileName, sResetURL, s, t, sAccts : string;
  sURL, sN : string;
  bAnswered, bOKtoETY, bUsedTaxFile, bKeepGoing : Boolean;
  Header : TTLFileHeader;
  nTrades, nAccts, nAvail : integer;
  sFileCode, sEmailToUse, sTokenToUse : string;
  // ------------------------
  // numerals only
  function StripSSN(sInp : string): string;
  var
    I : Integer;
  begin
    Result := '';
    if (sInp = '') then exit;
    for I := 0 to Length(sInp) do begin
      if pos(sInp[I], '1234567890') > 0 then
        Result := Result + sInp[I];
    end;
  end;
  // ------------------------
  // which FileKey to use?
  function GetProAccountantCode(sEmail: string): string;
  begin
    frmInput.display2('Using a TaxFile', 'About to use a TaxFile belonging to' + cr //
        + cr //
        + '  ' + sEmail + cr //
        + cr //
        + 'If not correct, click Cancel and contact TradeLog Support for' + cr //
        + 'assistance.' + cr //
        + cr //
        + 'Enter a User Reference to continue:', '', //
      'Continue', //
      'Cancel', //
      false); //
    result := frmInput.inputStr;
  end;
  // ------------------------
  // already has FileKey?
  function AlreadyHasFileKey: string;
  begin
    // LOGIC FLOW:
    result := '';
    // 1. Exists(User) --> already paid for
    sFileCode := TaxpayerExists(v2UserToken, sFileName);
    if (sFileCode <> '') then begin
       sm('This file has already been assigned one of your' + cr //
        + 'FileKeys. You will not need to use another one.');
        sEmailToUse := v2UserEmail;
        sTokenToUse := v2UserToken;
        result := sFileCode;
        exit;
    end
    // 2. Exists(Pro) --> already paid for
    else if (ProVer) then begin
      sFileCode := TaxpayerExists(v2ClientToken, sFileName);
      if (sFileCode <> '') then begin
         sm('This file has been assigned to one of your client' + cr //
          + 'FileKeys. You will not need to use another one.');
          sEmailToUse := v2ClientEmail;
          sTokenToUse := v2ClientToken;
          result := sFileCode;
          exit;
      end; // sFileCode found
    end; // else ProVer?
  end;
// --------------
begin
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
  bAnswered := false;
  bOKtoETY := false;
  bUsedTaxFile := false;
  sResetURL := '';
  // ------------------------
  if Settings.TrialVersion then begin
    sm('End Tax Year function is disabled in Trial.');
    exit;
  end
  else if (ProHeader.regCode = TRADELOG_SAMPLE_REGCODE) then begin
    sm('End Tax Year function is disabled in Sample File.');
    exit;
  end;
  // ------------------------
  bAnswered := True;
  // ------------------------
  sFileName := RemoveFileExtension(TradeLogFile.FileName);
  bOKtoETY := false; // assume NOT paid
  // --------- First, try Client FileKey --------
  sRegCodeToUse := Settings.regCode; // 2018-03-19 MB - check user RegCode first
  sEmailToUse := ProHeader.email; // 2022-11-27 MB - new way
  bOKtoETY := false; // init
  // --------- Next, try FILE RegCode -----------
  if SuperUser then begin // need a FileKey
    bOKtoETY := true;
  end
  else begin // not Super User
    // LOGIC FLOW:
    // 1. FileKey Exists --> already paid for
    sFileCode := AlreadyHasFileKey;
    if (sFileCode <> '') then begin
       sm('This file already has a FileKey.' + cr //
        + 'You will not need to use another.');
       bOKtoETY := True;
       bUsedTaxFile := False;
    end;
    // 2. Needs FileKey --> try client
    if not bOKtoETY then begin
      nAvail := TaxFilesAvail(v2ClientToken);
      if (nAvail > 0) then begin // client has one
        if ProVer then
          sAcctCode := GetProAccountantCode(v2ClientEmail)
        else
          sAcctCode := v2UserName;
        // -- now, actually link the File Key
        sFileCode := GetAvailFileKey(v2ClientToken);
        if (sFileCode <> '') then
        if TaxFileSave(v2ClientToken, v2ClientEmail, sFileName, sFileCode, 'End Tax Year') //
        then begin
          bOKtoETY := True;
          bUsedTaxFile := True;
        end
        else begin
          sm('File Key found for email: ' + v2ClientEmail + CR //
            + 'but TradeLog was not able to link it at this time.' + cr //
            + 'Please try again later or contact TradeLog Support' + cr //
            + 'if the problem persists.');
          exit;
        end; // if TaxFileSave
      end; // if Avail
    end; // block 2
    // 3. Needs FileKey --> try Pro
    if (ProVer) and (bOKtoETY = false) then begin
      nAvail := TaxFilesAvail(v2UserToken);
      if (nAvail > 0) then begin // pro user has one
        sAcctCode := GetProAccountantCode(v2UserEmail);
        if sAcctCode = '' then begin
          sm('End Tax Year aborted.');
          exit;
        end;
        // -- now, actually link the File Key
        sFileCode := GetAvailFileKey(v2UserToken);
        if (sFileCode <> '') then
        if TaxFileSave(v2UserToken, v2UserEmail, sFileName, sFileCode, 'End Tax Year') //
        then begin
          bOKtoETY := True;
          bUsedTaxFile := True;
        end
        else begin
          sm('File Key found for ' + v2UserEmail + CR //
            + 'but TradeLog was not able to link it at this time.' + cr //
            + 'Please try again later or contact TradeLog Support' + cr //
            + 'if the problem persists.');
          exit;
        end; // if TaxFileSave
      end; // if Avail
    end; // block 3
  end; // not a SuperUser
  // ------------------------
  // limit End Tax Year unless TaxFile has been purchased for this tax year file
  if not bOKtoETY then begin
    sm('You must purchase an additional TaxFile to end the' + cr //
     + 'tax year on this ' + TaxYear + ' file.' + cr //
     + cr //
     + 'If you feel this is incorrect, please contact TradeLog' + cr //
     + 'Support by clicking the [GetSupport] button.');
    exit;
  end;
  // -----
  screen.Cursor := crHourGlass;
  FindTradeIssues;
  // search for O and W errors here!
  if panelMsg.HasTradeIssues then begin
    mDlg('Issues exist in your data which must be resolved before' + cr +
        'you can run end of year processing.' + cr + cr +
        'Please see the warning box at the top of the grid for details.', mtError, [mbOK], 0);
    if bUsedTaxFile then
      TaxFileSave(v2UserToken, v2UserEmail, '', sFileCode, ''); // Reset File Key
    exit;
  end
  else begin
    if (not bAnswered) //
      and (mDlg('If you continue with Year end processing' + cr //
          + 'your file will be LOCKED for editing and' + cr //
          + 'no further changes will be allowed.' + cr //
          + cr //
          + 'Are you sure you wish to continue?', mtWarning, [mbYes]+[mbNo], 0) = mrNo) //
    then begin
      if bUsedTaxFile then
        TaxFileSave(v2UserToken, v2UserEmail, '', sFileCode, ''); // Reset File Key
      exit;
    end;
    // ------------------------------------------
    ETYinProgress := True; // added switch for ETY - 2016-07-12 MB
    // ------------------------------------------
    // 2019-02-20 MB - get stats for taxfilelog
    nTrades := cxGrid1TableView1.DataController.rowCount;
    nAccts := 0;
    sAccts := '';
    for Header in TradeLogFile.FileHeaders do begin
      inc(nAccts);
      sAccts := sAccts + Header.ImportFilter.BrokerCode;
      if Header.Ira then
        sAccts := sAccts + 'I'
      else if Header.MTM then
        sAccts := sAccts + 'M'
      else
        sAccts := sAccts + 'C';
    end;
    // ------------------------------------------
    FileCodeToUse := sFileCode;
    if ETY.EndTaxYear then begin
      // 2017-09-14 MB - Move WriteTaxFileLog so it's only called if ETY succeeds.
      s := Settings.regCode;
      t := ProHeader.regCode;
      if ProVer then begin
        v2WriteTaxFileLog(v2UserToken, sFileCode, 'Write',
          'ETY(' + Settings.TLVer + ')' + sAcctCode,
          sFileName, '', '');
      end
      else begin
        v2WriteTaxFileLog(v2UserToken, sFileCode, 'Write', 'End Tax Year', sFileName, '', '');
      end;
      sN := IntToStr(nTrades);
      v2WriteTaxFileLog(v2UserToken, sFileCode, 'Tracking', IntToStr(nAccts), sN, sAccts, '');
      // survey
      If (not ProVer) and (not SuperUser) //
      and (TaxYear = '2024') then begin
        // V = Investor / Trader / Elite - this helps us understand what version customer is using
        // ETY = this is the same ETY code we pass with the filekey information, encoding the brokers
        // N = number of records in file
        sURL := 'https://www.surveymonkey.com/r/tradelog2024?' //
          + 'V=' + Settings.TLVer //
          + char(38) + 'ETY=' + sAccts //
          + char(38) + 'N=' + sN;
        webURL(sURL);
        // EX: https://www.surveymonkey.com/r/tradelog2024?V=20.3.6.2&ETY=<AcctCodes>&N=<#trades>;
      end;
    end
    else if bUsedTaxFile then begin
      // we Used a TaxFile, but ETY failed, so roll back
      TaxFileSave(v2UserToken, v2UserEmail, '', sFileCode, '');
    end;
    ETYinProgress := false; // clear flag when done.
    // ------------------------------------------
    repaintGrid;
    // end else cancel
  end;
  screen.Cursor := crDefault;
end; // bbFile_EndTaxYear.Click


//procedure TfrmMain.mnuFile_ResetPWClick(Sender: TObject);
//begin
//  showFileResetPW;
//end;


// ----------------------------------------------

procedure TfrmMain.EnterOpenPositions1Click(Sender: TObject);
begin
  EnterBeginYearPrice;
end;

procedure TfrmMain.ETFETNs1Click(Sender: TObject);
begin
  filterByType('ETF', True);
end;

procedure TfrmMain.ReverseEndYear1Click(Sender: TObject);
begin
  if not CheckRecordLimit then exit;
  if ETY.ReverseYearEnd then begin
    // we can't assume edits should be enabled; what if aborted?
    bbFile_EndTaxYear.Enabled := True;
    btnCheckList.Enabled := True;
  end;
end;


procedure TfrmMain.RzToolButton1Click(Sender: TObject);
begin
  FAllTableClicked := true;
  actnShowAllClick(Sender);
end;

procedure TfrmMain.btHelpStatementClick(Sender: TObject);
begin
  webURL(supportSiteURL + 'hc/en-us/articles/115004509614');
end;


procedure TfrmMain.btnAddAcctDropDownMenuPopup(Sender: TObject; var APopupMenu: TPopupMenu;
  var AHandled: Boolean);
begin
  TabAccounts.SetFocus;
end;


procedure TfrmMain.btnCancelClick(Sender: TObject);
begin
  clearFilter;
  cxGrid1.SetFocus;
end;


procedure TfrmMain.btnCopyMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  try
    if (ssCtrl in Shift) and (ssShift in Shift) then
      raise Exception.Create('Test Exception for Send Files Testing');
  finally
    //
  end;
end; // btnCopyMouseDown


procedure TfrmMain.btnFAQClick(Sender: TObject);
begin
  webURL(SiteURL + 'faqs');
end;


// ----------------------------------------------
// Import routines
// ----------------------------------------------

function IsOkToImport: boolean;
begin
  if isAllBrokersSelected then exit(false); // cannot import all at once
  if (OneYrLocked and not SuperUser) then exit(false);
  if not CheckRecordLimit then exit(false);
  // ------------------------------------------------------------
  if TradeLogFile.CurrentAccount.FileImportFormat = '' then begin
    sm('No import Filter Selected');
    exit(false);
  end;
  result := true;
end;


procedure BCImportDateRange(dt1, dt2 : TDate);
var
  fromDate, endDate : TDate;
  maxOFX : integer;
begin
  if not IsOKToImport then exit;
  sImpMethod := 'BC';
  dtBegTaxYr := dt1;
  dtEndTaxYr := dt2;
  // ------------------------------------------------------------
  glbBLWizOpen := true;
  BCImport; // <--- call the import function!
  glbBLWizOpen := false;
end; // BCImportDateRange


procedure TfrmMain.dxBrokerConnect_Click(Sender: TObject);
var
  fromDate, endDate : TDate;
  maxOFX : integer;
begin
  if not IsOKToImport then exit;
  sImpMethod := 'BC';
  try
    // ------------------------------------------------------------
    dtBegTaxYr := xStrToDate('01/01/' + TaxYear, Settings.InternalFmt);
    dtEndTaxYr := xStrToDate('12/31/' + TaxYear, Settings.InternalFmt);
    // ------------------------------------------------------------
    if TradeLogFile.LastDateImported + 1 < dtBegTaxYr then
      fromDate := dtBegTaxYr // assume prev year was ETY'd
    else
      fromDate := TradeLogFile.LastDateImported + 1;
    // ------------------------------------------------------------
    maxOFX := TradeLogFile.CurrentAccount.ImportFilter.OFXMonths;
    // ------------------------------------------------------------
    if panelSplash.Visible then begin
      if mDlg('Are you sure you have no open positions from last year?', //
        mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
        GridEscape;
        panelSplash.hide;
      end
      else begin
        sm('Please enter your open positions now');
        exit;
      end;
    end;
    // ------------------------------------------------------------
    endDate := xStrToDate('12/31/' + TaxYear, Settings.InternalFmt);
    // ------------------------------------------------------------
    if TradeLogFile.YearEndDone then begin // no importing after ETY!
      mDlg('You can no longer import into this file' + cr //
         + 'because a ' + NextTaxYear + ' data file was created' + cr //
         + 'when you ended the tax year in this file.' + cr //
         + cr //
         + 'Please open your ' + NextTaxYear + ' data file' + cr //
         + 'to import your ' + NextTaxYear + ' trades.', mtWarning, [mbOK], 0);
      exit;
    end
    else if (TradeLogFile.LastDateImported = today - 1) then begin
      if (TradeLogFile.CurrentAccount.FileImportFormat = 'IB') //
      or (TradeLogFile.CurrentAccount.FileImportFormat = 'Fidelity') //
      or (TradeLogFile.CurrentAccount.FileImportFormat = 'optionsXpress') //
      or (TradeLogFile.CurrentAccount.FileImportFormat = 'TradeStation') then begin
        sm('Cannot import trades past yesterday ' //
          + dateToStr(TradeLogFile.LastDateImported, Settings.UserFmt));
        exit;
      end
      else if mDlg('Trades already imported up to yesterday ' //
        + dateToStr(TradeLogFile.LastDateImported, Settings.UserFmt) + cr //
        + 'If you import today''''s trades you may import duplicate trades' + cr //
        + cr //
        + 'Do you want to continue with this import?', //
        mtConfirmation, [mbYes, mbNo], 0) <> mrYes then begin
        exit;
      end;
    end;
    // ------------------------------------------------------------
    statBar('Importing Trade History');
    btnShowAll.Click;
    DeleteFile('filter.txt');
    statBar('Importing Trade History');
    // ------------------------------------------------------------
    bImporting := true;
    BCImport; //         <--- Call the import function!
    bImporting := False;
    // ------------------------------------------------------------
    if stkAssignsPriceZero then begin
      FilterByStkAssignsPriceZero;
      mDlg('These stocks were assigned and no price was provided by your broker!' + cr //
        + cr //
        + 'You MUST look up the prices for all these stock assignments and' + cr //
        + 'edit all these records so you can properly Exercise your option trades' + cr, //
        mtWarning, [mbOK], 1);
      stkAssignsPriceZero := false;
    end
    else
      btnShowAll.Click;
    // end if
    // ------------------------------------------------------------
    if TradeLogFile.CurrentAccount.ImportFilter.BrokerHasTimeOfDay then begin
    // if not DisplayTime1.checked then begin
      if (bbUser_Time.EditValue = false) then begin
        if mDlg('This broker reports trade times, but you have the trade' + CR //
          + 'time column hidden. Would you like to display it now?', //
          mtWarning, [mbYes, mbNo], 0) = mrYes
        then begin
          Settings.DispTimeBool := TRUE;
          SetOptions;
        // was DisplayTime1.Click;
        end;
      end;
    end;
  finally
    sImpMethod := ''; // clear on exit
    //statBar('off');
    screen.Cursor := crDefault;
  end;
end; // dxBrokerConnect_Click


procedure TfrmMain.btnFromFileClick(Sender: TObject);
var
  fromDate : TDate;
  maxOFX : integer;
begin
  if not IsOKToImport then exit;
  if TradeLogFile.CurrentAccount.FileImportFormat = '' then begin
    sm('No import Filter Selected');
    exit;
  end;
  sImpMethod := 'File';
  try
    // ------------------------------------------------------------
    dtBegTaxYr := xStrToDate('01/01/' + TaxYear, Settings.InternalFmt);
    dtEndTaxYr := xStrToDate('12/31/' + TaxYear, Settings.InternalFmt);
    // ------------------------------------------------------------
    if TradeLogFile.LastDateImported + 1 < dtBegTaxYr then
      fromDate := xStrToDate('01/01/' + taxyear, Settings.InternalFmt)
    else
      fromDate := TradeLogFile.LastDateImported + 1;
    // ------------------------------------------------------------
    maxOFX := TradeLogFile.CurrentAccount.ImportFilter.OFXMonths;
//    if (Settings.LegacyBC) and (maxOFX > 0) //
//    and TradeLogFile.CurrentAccount.ImportFilter.OFXConnect //
//    and (now - maxOFX * 30 > fromDate) //
//    and (TradeLogFile.CurrentAccount.ImportFilter.FilterName = 'Fidelity') then begin
//      mDlg('Fidelity OFX data is limited to the last ' //
//        + intToStr(maxOFX) + ' months.' + cr + cr //
//        + 'Please use the Fidelity csv import method instead', //
//        mtWarning, [mbOK], 0);
//      exit;
//    end;
    // ------------------------------------------------------------
    if panelSplash.Visible then begin
      if mDlg('Are you sure you have no open positions from last year?', //
        mtConfirmation, [mbYes, mbNo], 0) = mrYes
      then begin
        GridEscape;
        panelSplash.hide;
      end
      else begin
        sm('Please enter your open positions now');
        exit;
      end;
    end;
    // ------------------------------------------------------------
//    if (TradeLogFile.LastDateImported //
//        = xStrToDate('12/31/' + TaxYear, Settings.InternalFmt)) //
//      and isMTM then begin
//      sm('Cannot import trades past ' //
//          + dateToStr(xStrToDate('12/31/' + TaxYear, Settings.InternalFmt), Settings.UserFmt) //
//          + ' in a ' + TaxYear + ' MTM account');
//      exit;
//    end
//    else
    if TradeLogFile.YearEndDone then begin // cannot import after end tax year
      mDlg('You can no longer import into this file' + cr //
         + 'because a ' + NextTaxYear + ' data file was created' + cr //
         + 'when you ended the tax year in this file.' + cr //
         + cr //
         + 'Please open your ' + NextTaxYear + ' data file' + cr //
         + 'to import your ' + NextTaxYear + ' trades.', mtWarning, [mbOK], 0);
      exit;
    end
//    // do not allow importing past Jan 31
//    else if (TradeLogFile.LastDateImported
//    = xStrToDate('01/31/' + NextTaxYear, Settings.InternalFmt)) //
//    and (TradeLogFile.NextTaxYear <> currentYear) then begin
//      sm('Cannot import trades past ' //
//        + dateToStr(xStrToDate('01/31/' + NextTaxYear, Settings.InternalFmt), Settings.UserFmt) //
//        + ' in a ' + TaxYear + ' data file');
//      exit;
//    end
    else if (TradeLogFile.LastDateImported = today - 1) then begin
      if (TradeLogFile.CurrentAccount.FileImportFormat = 'IB') //
      or (TradeLogFile.CurrentAccount.FileImportFormat = 'Fidelity') //
      or (TradeLogFile.CurrentAccount.FileImportFormat = 'optionsXpress') //
      or (TradeLogFile.CurrentAccount.FileImportFormat = 'TradeStation') then begin
        sm('Cannot import trades past yesterday ' //
          + dateToStr(TradeLogFile.LastDateImported, Settings.UserFmt));
        exit;
      end
      else if mDlg('Trades already imported up to yesterday ' //
        + dateToStr(TradeLogFile.LastDateImported, Settings.UserFmt) + cr //
        + 'If you import today''''s trades you may import duplicate trades' + cr //
        + cr //
        + 'Do you want to continue with this import?', //
        mtConfirmation, [mbYes, mbNo], 0) <> mrYes then begin
        exit;
      end;
    end;
    // ------------------------------------------------------------
    statBar('Importing Trade History');
    btnShowAll.Click;
    DeleteFile('filter.txt');
    statBar('Importing Trade History');
    // ------------------------------------------------------------
    bImporting := true;
    FileImport(False); // <-- MAIN ROUTINE
    bImporting := False;
    // ------------------------------------------------------------
    if stkAssignsPriceZero then begin
      FilterByStkAssignsPriceZero;
      mDlg('These stocks were assigned and no price was provided by your broker!' + cr //
        + cr //
        + 'You MUST look up the prices for all these stock assignments and' + cr //
        + 'edit all these records so you can properly Exercise your option trades' + cr, //
        mtWarning, [mbOK], 1);
      stkAssignsPriceZero := false;
    end
    else
      btnShowAll.Click;
    // end if
    // ------------------------------------------------------------
    if TradeLogFile.CurrentAccount.ImportFilter.BrokerHasTimeOfDay then begin
      if (bbUser_Time.EditValue = false) then begin
        if mDlg('This broker reports trade times, but you have the trade' + CR //
          + 'time column hidden. Would you like to display it now?', //
          mtWarning, [mbYes, mbNo], 0) = mrYes
        then begin
          Settings.DispTimeBool := TRUE;
          SetOptions;
        end;
      end;
    end;
  finally
    sImpMethod := ''; // clear on exit
    screen.Cursor := crDefault;
  end;
end; // btnFromFileClick


procedure TfrmMain.btnFromExcelClick(Sender: TObject);
var
  R : integer;
  F : TdlgExcelWarning;
begin
  if not IsOKToImport then exit;
 // if not Settings.DispQS and panelQS.Visible then panelQS.hide;
  sImpMethod := 'Excel';
try
  // ------------------------------------------------------------
  IF NOT (TradeLogFile.CurrentAccount.FileImportFormat = 'Other') //
  THEN BEGIN //
    f := TdlgExcelWarning.Create(nil);
    try
      R := f.showmodal;
      if R = mrNo then begin
        btnFromFileClick(Sender);
        exit;
      end;
      // ----------------------
      if R = mrCancel then exit;
      // ----------------------
    finally // must be mrYes!
      f.Free;
    end;
  END;
  if messagedlg('Select the formatted excel data,' + CR //
    + 'copy it, then click OK to import.', //
    mtInformation, [mbOK, mbCancel], 0) = mrCancel
  then
    exit;
  // ------------------------------------------------------------
  statBar('Importing Trade History');
  actnShowAllClick(Sender);
  DeleteFile('filter.txt');
  statBar('Importing Trade History');
  // ------------------------------------------------------------
  bImporting := true;
  R := ReadManualEntry(false); // True - date from Grid; False - data from CSV
  bImporting := False;
  // ------------------------------------------------------------
  if stkAssignsPriceZero then begin
    FilterByStkAssignsPriceZero;
    mDlg('These stocks were assigned and no price was provided by your broker!' + cr //
      + cr //
      + 'You MUST look up the prices for all these stock assignments and' + cr //
      + 'edit all these records so you can properly Exercise your option trades' + cr, //
      mtWarning,[mbOK],1);
    stkAssignsPriceZero := false;
  end
  else
    actnShowAllClick(Sender);
finally
    sImpMethod := ''; // clear on exit
    StatBar('off');
    Screen.Cursor := crDefault;
end;
end; // btnFromExcelClick


procedure TfrmMain.btnFromWebClick(Sender: TObject);
begin
  sImpMethod := 'Web';
  try
    ShowMessage('To Do: From Web/Paste');
  finally
    sImpMethod := ''; // clear on exit
    StatBar('off');
    Screen.Cursor := crDefault;
  end;
end;


procedure TfrmMain.btnGetBetaClick(Sender: TObject);
var
  j : integer;
  x : string;
begin
  // same as regular update, only gets the beta instead
  UpdateTradeLogExe(true);
  close; // closes main form and exits application
  Screen.Cursor := crDefault; // need to reset cursor!
//  randomize;
//  j := random($7FFFFFFF);
//  x := inttostr(j);
//  if UpdateInformation.DownloadBeta(
//    'https://tradelog.com/tradelog-software/beta/setupTL20.exe' //
//    + '?ver=' + x, //
//    Settings.UpdateDir + '\setupTL20.exe')
//  then begin
//    Screen.Cursor := crDefault;
//    ExecuteFile('setupTL20.exe', '', Settings.UpdateDir, SW_SHOW);
//    close; // main
//  end;
//  StatBar('off');
//  Screen.Cursor := crDefault;
end;

// ----------------------------------------------
// HELP
// ----------------------------------------------
procedure TfrmMain.btnHelp8949RptClick(Sender: TObject);
begin
  webURL(supportSiteURL + 'hc/en-us/articles/115004509514-IRS-Form-8949');
end;


procedure TfrmMain.btnHelpClick(Sender: TObject);
begin
  miSendFiles.Click;
end;


procedure TfrmMain.btnHelpOtherErrorsClick(Sender: TObject);
begin
  webURL(supportSiteURL + 'hc/en-us/articles/115004483973');
end;


procedure TfrmMain.FixNegSharesOpen1Click(Sender: TObject);
begin
  ForceMatchTrades;
end;


procedure TfrmMain.actnFilterEnableClick(Sender: TObject);
begin
  ResetFilterCombobox('');
  try
    if not btnFilterEnable.Down then begin
      if TradeLogFile.Count = 0 then exit;
      ResetFilterCombobox('');
      GridFilter := gfFilter;
      SpeedButtonsUp;
      cxGrid1TableView1.OptionsCustomize.ColumnFiltering := true;
    end;
  finally
    // actnFilterEnableClick
  end;
end;


procedure TfrmMain.FormEndDock(Sender, Target: TObject; X, Y: Integer);
begin
  if (pos('Sorting', stMessage.Caption) > 0)
  or (pos('Matching', stMessage.Caption) > 0)
  then
    exit;
end;


procedure TfrmMain.Tutorial1Click(Sender: TObject);
var
  oldDir: string;
begin
  webURL(SiteURL + 'support/online-tutorial');
end;


procedure TfrmMain.txt1099KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key <> vk_Delete then exit; // vk_Delete only caught on Key Up
  Key := 0;
  // txt1099.SelText := ''
end;


         // -----------------
         //       UNDO
         // -----------------
procedure TfrmMain.Undo1Click(Sender: TObject);
begin
  Undo(true);
//  enableEdits; // old
  SetupToolBarMenuBar(false); // new
end;

procedure TfrmMain.actnUndoClick(Sender: TObject);
begin
  //if isFormOpen('pnlBaseline1') then sm('BL1 open') else sm('BL1 closed');  //test code
  //if isFormOpen('pnlBaseline') then sm('BL open') else sm('BL closed');  //test code
  Undo1Click(Sender);
end;


procedure TfrmMain.CutClick(Sender: TObject);
var
  RecsSelected: Integer;
begin
  if cxGrid1TableView1.optionsData.editing then exit;
  if Settings.TrialVersion then begin
    sm('Cut function is disabled in Trial.'+cr+cr+'No records have been cut.');
    exit;
  end;
  if not CheckRecordLimit then exit;
  // ---- end of checks -----
  DelSelectedRecords(true);
{ if mDlg('Cut Selected Record(s)?', mtWarning, [mbNo, mbYes], 0) = mrYes then
    with frmMain.cxGrid1TableView1.DataController do begin
      if GetSelectedCount < 1 then begin
        sm('Please select record(s) to cut!');
        exit;
      end;
      RecsSelected := CopyTradesToClipboard(true);
      mDlg(intToStr(RecsSelected) + ' Records cut to clipboard', mtInformation,
        [mbOK], 0);
      myDeleteSelection;
      if not stopDel then
        SaveTradeLogFile('Cut')
      else
        TradeLogFile.Revert;
      deletingRecords := False;
    end;
  repaintGrid;
}
end;


procedure SaveLastFileName(FileName: string);
var
  Idx, I: Integer;
begin
  if Length(FileName) = 0 then exit;
  if (pos('.tdf', FileName) = 0)
  or (pos('.tdb', FileName) > 0)
  then
    exit;
  LastFileName := Settings.DataDir + '\' + FileName;
  if Not FileExists(LastFileName) then exit;
  Idx := Settings.LastOpenFilesList.IndexOf(LastFileName);
  // file is NOT in the list
  if Idx = -1 then begin
    // add it to the front and remove any files above a count of 4
    Settings.LastOpenFilesList.Insert(0, LastFileName);
    if Settings.LastOpenFilesList.Count > 4 then
      for I := 4 to Settings.LastOpenFilesList.Count - 1 do
        Settings.LastOpenFilesList.delete(I);
  end
  else begin // file is already in the list
    // delete it from the list
    Settings.LastOpenFilesList.delete(Idx);
    // insert it at the top of the list
    Settings.LastOpenFilesList.Insert(0, LastFileName);
  end;
  // Save the INI Entries for the Last Open Files
  Settings.WriteLastOpenFiles;
  // Setup Main Menu Items
  frmMain.SetupLastOpenFilesMenu;
end;


procedure TfrmMain.OpenRecentFile(i : integer);
begin
  LastFileName := Settings.LastOpenFilesList[i];
  OpenTradeLogFile(LastFileName);
end;

// old menu events with code moved out:
procedure TfrmMain.LastFile1Click(Sender: TObject);
begin
  OpenRecentFile(0);
end;
procedure TfrmMain.LastFile2Click(Sender: TObject);
begin
  OpenRecentFile(1);
end;
procedure TfrmMain.LastFile3Click(Sender: TObject);
begin
  OpenRecentFile(2);
end;
procedure TfrmMain.LastFile4Click(Sender: TObject);
begin
  OpenRecentFile(3);
end;


procedure TfrmMain.exitReportsClick(Sender: TObject);
var
  I: Integer;
begin
  //FreeTrSumList;
  // If we Forced the opening of the  quick start panel after
  // a report had failed, Close the PanelQS if the setting is off.
//  if panelQS.Visible and not Settings.DispQS then panelQS.hide;
  If (pnlGains.Visible) and (MainFilterStream.Size > 0) then begin
    WriteFilter(True);
  end
  else if ((pnlGains.Visible) or (btnShowAll.Down))
  and (cxGrid1TableView1.DataController.CustomDataSource <> OpenTradeRecordsSource) then
    btnShowAll.Click;
  if pnlGains.Visible then pnlGains.hide;
  if pnlTrades.Visible then pnlTrades.hide;
  if pnlChart.Visible then pnlChart.hide;
  pnlDoReport.hide;
  spdRunReport.Enabled := true;
  pnlTools.Visible := True;
  tabAccounts.Enabled := True;
  SetupToolBarMenuBar(false);
  frmMain.cxGrid1.SetFocus;
  if Settings.DispWSdefer then filterInWashSales;
  ReportStyle := rptNone;
  spdRunReport.Enabled := false;
  cbForm8949pdf.checked := false;
  cbForm8949pdf.visible := false;
  // DE added 2015-11-07
  if TradeLogFile.YearEndDone then disableEdits;
  screen.Cursor := crDeFault;
  statBar('off');
end;


procedure TfrmMain.actnRedoClick(Sender: TObject);
begin
  REDO1Click(Sender);
end;


procedure TfrmMain.spdRunReportClick(Sender : TObject);
var
  Show1099bMessage : Boolean;
//  Account : TTLFileHeader;
  IncludeAdjustment : Boolean;
begin
  if (screen.Cursor = crHourGlass) or not spdRunReport.Enabled then exit;
  // ------------------------
  screen.Cursor := crHourGlass; // disables mouse!
  startTime := time - startTime;
  spdRunReport.Enabled := false;
  if cxGrid1TableView1.ViewData.RowCount < 1 then begin
    mDlg('No data to report!', mtInformation, [mbOK], 0);
    screen.Cursor := crDefault; // re-enables mouse
    spdRunReport.Enabled := true;
    exit;
  end
  // --------- 8949 ----------------
  else if (ReportStyle = rptIRS_D1) then begin
    if (not cbForm8949.Checked) //
    and (not cbInc8949Summary.Checked) then begin
      sm('WARNING: You have not selected anything to show on the report.' + CRLF //
        + 'Please select Summary, Form 8949, or both before Run.');
      screen.Cursor := crDefault; // re-enables mouse
      spdRunReport.Enabled := true;
      exit;
    end;
    if (TaxYear > '2010') then begin
      // Loop through all the Cash/IRA accounts and verify that the 1099 Data has been filled in.
      if TradeLogFile.CurrentBrokerID <> 0 then begin
        if TradeLogFile.MultiBrokerFile then
          mDlg('This 8949 report only reflects trade activity in the single account you selected' + CR //
            + 'and should not be used for tax reporting.' + cr //
            + cr //
            + 'Please select the All Accounts tab and then run the Form 8949 report to generate' + CR //
            + 'a complete tax report accounting for all taxable trade history and wash sales' + CR //
            + ' that may have occurred across accounts.', mtWarning, [mbOK], 0)
        else
          Show1099bMessage := (not TradeLogFile.CurrentAccount.no1099) //
            and ((TradeLogFile.CurrentAccount.GrossSales1099 = '') //
              or (TradeLogFile.CurrentAccount.CostBasis1099ST = ''));
      end; // if TradeLogFile.CurrentBrokerID <> 0
      if not TradeLogFile.YearEndDone then begin
        sm('WARNING: You have not performed End Tax Year.' + cr //
            + 'Your 8949 Report will show as Draft until you' + cr //
            + 'end the tax year.');
      end; // if not TradeLogFile.YearEndDone
    end; //if (TaxYear > '2010')
  end; // if (ReportStyle = rptIRS_D1)
  // note: no 8949 before 2011
  // ---------
  frmMain.cxGrid1.Enabled := True;
  SetPopupMenuEnabled(pupEdit, false);
  if (ReportStyle = rptTradeSummary) then begin
  // If They chose Summary from the menu and then clicked ticker change the reportStyle to match
    if cbTick.checked then
      ReportStyle := rptTickerSummary;
  end;
  IncludeAdjustment := (ReportStyle = rptIRS_D1) //
    and (TradeLogFile.TaxYear > 2010) //
    and (TradeLogFile.TaxYear < 2014) //
    and (cbIncludeAdjustment.checked);
  // --------- G and L ----------------
  if ReportStyle in [rptSubD1, rptGAndL] then begin
    RunReport(glStartDate.date, glEndDate.date, cbAdjWash.checked, bWashShortAndLong);
  end
  // ---------  ----------------
  else if ReportStyle in [rptTradeDetails, rptDateDetails, rptTickerDetails, rptPerformance, rptNone]
  then
    RunReport(StartDate, EndDate, false, false, false)
  // --------- all others ----------------
  else
    RunReport(glStartDate.date, glEndDate.date, false, false, IncludeAdjustment);
  screen.Cursor := crDefault;
end;


procedure TfrmMain.cbMTMClick(Sender: TObject);
begin
  spdRunReport.Enabled := false;
  try
    ReportStyle := rptMTM;
    filterInWashSales;
    FilterMTM;
    if TradeLogFile.CurrentBrokerID = 0 then
      FilterByBrokerAccountType(True, False, False, False);
    sortByLS;
  finally
    spdRunReport.Enabled := true;
    screen.Cursor := crDefault;
  end;
end;


procedure TfrmMain.DoRecon;
begin
  btnShowAll.Click;
  frm1099Info := Tfrm1099Info.Create(frmMain);
  if frm1099Info.showModal = mrOK then begin
    if TradeLogFile.CurrentAccount.MTM then begin
      filterByType('NoCur', false);
      if not TradeLogFile.CurrentAccount.MTMForFutures then
        filterByType('NoFut', false);
    end
    else
      DoStocks('Recon', True);
    // sm(frmMain.cxGrid1TableView1.DataController.filter.FilterText);
    pnlTools.Visible := False;
    StartDate := xStrToDate('01/01/' + TaxYear, Settings.InternalFmt); // dtBegTaxYr;
    EndDate := xStrToDate('12/31/' + TaxYear, Settings.InternalFmt); // dtEndTaxYr;
    RunReport(StartDate, EndDate);
  end
  else begin
    tabAccounts.Enabled := True;
    SetPopupMenuEnabled(pupEdit, not isAllBrokersSelected);
    ReportStyle := rptNone;
  end;
end;


//procedure TfrmMain.cbShowSSNClick(Sender: TObject);
//begin
//  statBar('off');
//  gbAddSSNEIN := cbShowSSN.Checked; // 2024-01-29 MB
//end;

procedure TfrmMain.cbShowSSNMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
    webURL(supportSiteURL + 'hc/en-us/articles/115004469113');
end;

procedure TfrmMain.cbSec481Click(Sender: TObject);
begin
  spdRunReport.Enabled := false;
  try
    ReportStyle := rpt481Adjust;
    filterInWashSales;
    filterSec481;
    if TradeLogFile.CurrentBrokerID = 0 then
    FilterByBrokerAccountType(True, False, False, False);
    //sortByTickerForWS;
  finally
    spdRunReport.Enabled := true;
    screen.Cursor := crDefault;
  end;
end;


procedure TfrmMain.cbD1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (StrToInt(TaxYear) < 2003) then
    sm('IRS Schedule D-1 is not available for Tax Years earlier than 2003' + cr + cr
      + 'Please use Gains && Losses report type')
  else if Settings.IsEin then
    sm('IRS Schedule D-1 is not available when filing as a Corporation using an EIN' + cr + cr
      + 'Please click on Reports, Page Setup and uncheck ''''Use EIN instead of SSN''''');
end;


procedure TfrmMain.cbD1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (StrToInt(TaxYear) < 2003) then
    sm('IRS Schedule D-1 is not available for Tax Years earlier than 2003' + cr + cr
      + 'Please use Gains && Losses report type')
  else if Settings.IsEin then
    sm('IRS Schedule D-1 is not available when filing as a Corporation using an EIN' + cr + cr
        + 'Please click on Reports, Page Setup and uncheck ''''Use EIN instead of SSN''''');
end;


procedure TfrmMain.cb4797Click(Sender: TObject);
begin
  spdRunReport.Enabled := false;
  try
    ReportStyle := rpt4797;
    ClearFilter;
    filterInWashSales;
    FilterForMTMStocks;
    //sortByTickerForWS;
  finally
    spdRunReport.Enabled := true;
    screen.Cursor := crDefault;
  end;
end;


procedure TfrmMain.cbAdjWashClick(Sender: TObject);
begin
  if grpWashSales.Visible then begin
    if cbAdjWash.checked then begin
      Settings.DispWSDefer := True;
      SetOptions;
      filterInWashSales;
//      cbWSshortsLongs.Enabled := cbAdjWash.Enabled and cbAdjWash.checked;
//      cbWSshortsLongs.checked := cbAdjWash.checked;
    end
    else begin
//      Settings.DispWSDefer := False;
      filterOutWashSales;
//      cbWSshortsLongs.Enabled := False;
//      cbWSshortsLongs.Checked := False;
    end;
  end;
end;


procedure TfrmMain.cbParameterChange(Sender: TObject);
begin
  if pos('% Total', cbParameter.Items[cbParameter.ItemIndex]) > 0 then begin
    cbWin.checked := true;
    cbLose.checked := true;
    cbWin.Enabled := False;
    cbLose.Enabled := False;
  end
  else begin
    cbWin.Enabled := true;
    cbLose.Enabled := true;
  end;
end;


function TfrmMain.GetFilterDataFromPanel : String;
begin
  if StartDate = Enddate then
    Result := '  ' + dateToStr(EndDate, Settings.UserFmt)
  else
    Result := '  ' + dateToStr(StartDate, Settings.UserFmt)
      + ' - ' + dateToStr(EndDate, Settings.UserFmt);
end;


procedure TfrmMain.DoStocks(stkType: string = 'schedD'; ClrFilter : Boolean = True);
begin
  // all types reported on schedule D: STK,MUT,ETF,DRP,SSF,OPT
  if ClrFilter then ClearFilter;
  filterByType(stkType, True);
  //repaintGrid;
end;


procedure TfrmMain.Drips1Click(Sender: TObject);
begin
  filterByType('DRP', True);
end;


procedure TfrmMain.DoFutures(futType: string = 'FUT');
begin
  filterByType(futType);
  repaintGrid;
end;


procedure TfrmMain.DoCurrencies;
begin
  filterByType('CUR');
  repaintGrid;
end;


procedure TfrmMain.DoGlAll;
var
  I: Integer;
begin
  deletingRecords := False;
  ReOrdering := False;
  RangeStart := xStrToDate('1/1/1900');
  RangeEnd := xStrToDate('1/1/1900');
  SortBy := '';
  statBar('Loading Grid');
  GetCurrTaxYear;
  editDisable(False);
  cxGrid1TableView1.DataController.clearSelection;
  cxGrid1TableView1.DataController.gotoFirst;
  clearFilter;
  dispProfit(true, 0, 0, 0, 0);
  // --------------------------------------------
  // 2021-06-25 MB - hide other visible reports
  if pnlTrades.Visible then pnlTrades.hide;
  if pnlChart.Visible then pnlChart.hide;
  // --------------------------------------------
  if not pnlGains.Visible and (GridFilter <> gfTradeIssues) then begin
    FindTradeIssues;
    if GridFilter <> gfTradeIssues then begin
      GridFilter := gfAll;
      panelMsg.hide;
    end;
  end
  else begin
    GridFilter := gfAll;
    panelMsg.hide;
  end;
  deletingRecords := False;
  if not(btnShowRange.Down or (GridFilter = gfRange)) then begin
    if not TradesSummary.Enabled then TradesSummary.Enabled := true;
  end;
  if cb4797.checked or cbSec481.checked or cbMTM.checked then exit;
  if not OpeningFile and (Screen.Cursor = crDefault) then statBar('off');
end;



procedure TfrmMain.ShowAllTrades;
begin
  if FAllTableClicked or FEscKeyPressed then
    ResetFilterCombobox('');
  FAllTableClicked := false;
  try
    if cxGrid1TableView1.DataController.CustomDataSource = OpenTradeRecordsSource then begin
      cxGrid1TableView1.DataController.CustomDataSource := TradeRecordsSource;
      SetupToolBarMenuBar(False);
      repaintGrid;
    end;
    DoGlAll;
    SpeedButtonsUp;
  finally
    Screen.Cursor := crDefault;
    statBar('off');
    // ShowAllClick
  end;
end;

procedure TfrmMain.actnShowAllClick(Sender: TObject);
begin
  ShowAllTrades;
end;

procedure TfrmMain.FAQHelp1Click(Sender: TObject);
begin
  try
    showUserGuide;
  finally
    // FAQHelp1Click
  end;
end;


procedure TfrmMain.MainMenuClick(Sender: TObject);
begin
  if IsFormVisible('frmWebBrowserPopup') then frmWebBrowserPopup.close;
end;


//procedure TfrmMain.QuickStartClick(Sender: TObject);
//begin
//  webURL(supportSiteURL + 'hc/en-us/categories/115000347454');
//end;


procedure TfrmMain.SetChartParms(Sender: TObject);
begin
  SetChartParams;
end;


procedure TfrmMain.SetEditedTradesFilter(Trades: TTradeList);
var
  Trade: TTLTrade;
  ItemNumStr: String;
begin
  ItemNumStr := '';
  for Trade in Trades do
    if Trade.Edited then begin
      if Length(ItemNumStr) > 0 then
        ItemNumStr := ItemNumStr + ',';
      ItemNumStr := ItemNumStr + intToStr(Trade.ID);
    end;
  filterByItemNumber(ItemNumStr);
end;


procedure TfrmMain.SetEditRec(const Value: Boolean);
begin
  FEditRec := Value;
  SetAddInsertEdit(not Value);
end;


procedure TfrmMain.SetGridFilter(const Value: TGridFilter);
begin
  FGridFilter := Value;
end;


procedure TfrmMain.SetInsertRec(const Value: Boolean);
begin
  FInsertRec := Value;
  SetAddInsertEdit(not Value);
end;


procedure TfrmMain.SetAccountOptions;
var
  Locale: TTLLocInfo;
  LCID : Integer;
begin
  SetupReportsMenu;   //2014-05-06 so when user clicks on acct tab the right reports are shown
  if TradeLogFile.CurrentBrokerID > 0 then
    LCID := TradeLogFile.CurrentAccount.BaseCurrencyLocale
  else
    LCID := EnglishUS;
// RJ Jan 22, 2021 appears this is not used according to Jason's changes.
//  if LocaleInfoList.TryGetValue(intToStr(LCID), Locale) then
//    txtBaseLocale.Caption := Locale.Country + ' (' + Locale.CurrencySymbol + ')'
//  else
//    txtBaseLocale.Caption := 'Unknown';
  btnImport.Enabled := (TradeLogFile.CurrentBrokerID > 0) and not bEditsDisabled;
  if (TradeLogFile.CurrentBrokerID = 0) then
    btnImport.Caption := 'Import'
  else
    btnImport.Caption := TradeLogFile.CurrentAccount.FileImportFormat + ' Imp';
  if (btnImport.Enabled) then begin
    if (TradeLogFile.CurrentAccount.FileImportFormat = '')
    or (TradeLogFile.CurrentAccount.FileImportFormat = 'Import') then begin
      btnImport.Caption := 'Import';
      btnImport.Enabled := False;
    end
    else begin
      btnImport.Enabled := true;
    end;
  end;
  GetLocaleFormats;
// RJ Jan 22, 2021 appears that this isn't used based on Jason's update
//  lblBaseLocale.Visible := LCID <> EnglishUS;
//  txtBaseLocale.Visible := lblBaseLocale.Visible;
  GetDataFileName;
  frmMain.caption := Settings.TLVer + ' - ' + DataFileName;
end;


procedure TfrmMain.SetAddInsertEdit(Value: Boolean);
var
  I: Integer;
begin
  if not Value then begin
    DisableMenuToolsAll;
    File1.Enabled := True;
    for I := 0 to File1.Count - 1 do
      File1.Items[I].Enabled := False;
//    Save1.Enabled := True;
    bbFile_Save.Enabled := True;
  end
  else
    SetupToolBarMenuBar(False);
end;


procedure TfrmMain.SetAddRec(const Value: Boolean);
begin
  FAddRec := Value;
  SetAddInsertEdit(not Value);
end;


procedure TfrmMain.SetMenuBarVisibility(Visible: Boolean);
var
  I: Integer;
begin
  For I := 0 to MainMenu.Items.Count - 1 do
    MainMenu.Items[I].Visible := false; // 2021-05-10 MB - no longer Visible;
  pnlMain.Visible := Visible;
  statusBar.Visible := Visible;
end;


procedure TfrmMain.SetOptions;
var
  I: Integer;
begin
  cxGrid_15_m.Visible := Settings.DispMTaxLots;
  cxGrid_13_Notes.Visible := Settings.DispNotes;
  cxGrid_3_Time.Visible := Settings.DispTimeBool;
  cxGrid_17_opTk.Visible := Settings.DispOptTicks;
  cxGrid_19_Strategy.Visible := Settings.DispStrategies;
  cxGrid_20_Code.Visible := Settings.Disp8949Code;
  cxGrid_22_WSHoldingDate.Visible := Settings.DispWSHolding;
  // rj Feb 10, 2021 Add values to the Ribbon
  // This only needs to be done once, at startup - MB
  bbUser_Matched.EditValue := Settings.DispMTaxLots;
  bbUser_Notes.EditValue := Settings.DispNotes;
  bbUser_OptionTickers.EditValue := Settings.DispOptTicks;
  bbUser_Time.EditValue := Settings.DispTimeBool;
  bbUser_Strategies.EditValue := Settings.DispStrategies;
  bbUser_Adjust.EditValue := Settings.Disp8949Code;
  bbUser_WashSaleHoldings.EditValue := Settings.DispWSHolding;
  bbUser_WashSales.Down := Settings.DispWSdefer;
  bbUser_QuickStart.Down := Settings.DispQS;
//  if TLstart then panelQS.Visible := Settings.DispQS;
  for I := 0 to pupView.Items.Count - 1 do
    pupView.Items[I].checked := View1.Items[I].checked;
  // repaintGrid;
end;


procedure TfrmMain.SetPopupMenuEnabled(menu: TPopupMenu; enable: Boolean);
var
  I: Integer;
begin
  for I := 0 to menu.Items.Count - 1 do
    menu.Items[I].Enabled := enable;
end;


procedure TfrmMain.SetupForGains(AllAccounts : Boolean);
var
  bFiltered : Boolean;
  bGetCurrentPrices : Boolean;
  // ------------------------
  function RemoveAmpersands(Value : String) : String;
  var
    cnt : Integer;
  begin
    Result := Value;
    Cnt := Pos('&', Result);
    while Cnt > 0 do begin
      if (Cnt < Length(Result) - 1)
      and (Result[Cnt + 1] = '&' ) then
        Inc(Cnt)
      else
        Delete(Result, Cnt, 1);
      Cnt := PosEx('&', Result, Cnt + 1);
    end;
  end;
  // --------------------------------------------------------------------------
  // bGetCurrentPrices means that we have just returned from Open Positions
  // and priced all open positions to current Market Prices;
  // The Grid no longer points at TLFile but now points at just these open
  // positions and prices.
  //
  // Reports that can be run are basically analysis reports only.
  //
  // AllAccounts flag means we are not filtering for taxable versus non
  // taxable or MTM type reports; generally this flag is only used to print
  // the G&L report under Analysis so that all accounts are included.
  //
  // bFiltered is used to determine if they already had a filter in the grid
  // when they started the reports. If they had a filter, we want to preserve
  // it so they can run reports against the filtered set; otherwise we will
  // decide on the filter based on which report is selected.
  //
  // ReportSetup takes care of warnings, setting up values, disabling of menus,
  // tabs, verifying there are records, etc., before running a report. If this
  // method returns false, no report can be run with the current parameters.
  // --------------------------------------------------------------------------
begin
  startTime:= time;
  Screen.Cursor := crHourGlass;
  statBar('Setting Up Trades For Report');
  if ReportSetup(True) = False then begin
    Screen.Cursor := crDefault;
    statBar('off');
    if not bfiltered then btnShowAll.Click;
    exit;
  end;
  // ------------------------
  // Setup the Label for the Gains Panel
  pnlStatements.Visible := false;
  pnlWS.Visible := false;
  pnlMTM.Visible := false;
  // replaced Length(Settings.SSN) > 0;
  // ------------------------
  if ReportStyle in [rptGAndL] then begin
    cbShowOpens.Visible := false; // 2022-04-04 MB - was true;
  end
  else begin
    cbShowOpens.Visible := false;
    cbShowOpens.checked := false;
  end;
  MakeGLCalendarYear(null, null);
  pnlGains.height := 140;
  // ------------------------
  // Reports
  // ------------------------
  if ReportStyle = rptIRS_D1 then begin //                            Form 8949
    lblReportName.Caption := UpperCase(RemoveAmpersands(Form1040ScheduleD1.Caption)) + ': ';
    if TradeLogFile.TaxYear > 2010 then begin
      pnlStatements.Visible := True;
      cbIncludeStatement.Visible := (TradeLogFile.TaxYear > 2011);
      cbIncludeAdjustment.Visible := (TradeLogFile.TaxYear < 2014);
      cbForm8949pdf.Visible := True;
      cbInc8949Summary.Visible := (TradeLogFile.TaxYear > 2011);
      if (TradeLogFile.TaxYear < 2024) then cbForm8949.Checked := true;
      cbForm8949.Visible := (TradeLogFile.TaxYear > 2023);
      pnlGains.height := 180;
      if TradeLogFile.TaxYear > 2012 then
        cbIncludeStatement.Checked := True
      else
        cbIncludeAdjustment.Checked := True;
    end;
  end // --------------------
  else if ReportStyle in [rptSubD1, rptGAndL] then begin //         G&L Reports
    if (ReportStyle = rptGandL) then
      cbAdjWash.Checked := false
    else if (ReportStyle = rptSubD1) then
      pnlWS.Visible := true;
    if AllAccounts then
      lblReportName.Caption := UpperCase(RemoveAmpersands(GainsLossesAllAccounts1.Caption)) + ': '
    else
      lblReportName.Caption := UpperCase(RemoveAmpersands(GLScheduleDD1Substitute1.Caption)) + ': '
  end // --------------------
  else if ReportStyle = rpt4797 then begin //                        MTM Report
    pnlMTM.Visible := true;
    lblReportName.Caption := UpperCase(RemoveAmpersands(Form4797MTM1.Caption)) + ': '
  end // --------------------
  else if ReportStyle = rptFutures then //                            Form 1249
    lblReportName.Caption := UpperCase(RemoveAmpersands(Form6781Futures1.Caption)) + ': '
  else if ReportStyle = rptCurrencies then
    lblReportName.Caption := UpperCase(RemoveAmpersands(ForexCurrencies1.Caption)) + ': ';
  // ------------------------
  // End of Setup the Label
  // ------------------------
  // If the user has specified a filter then save it
  // and be sure and preserve it for reports that it is appropriate for
  bFiltered := (Length(GetFilterCaption) > 0);
  MainFilterStream.Clear;
  if bFiltered then
    cxGrid1TableView1.DataController.Filter.SaveToStream(MainFilterStream);
  pnlTools.Visible := False;
  // --------------------------------------------
  // 2021-06-25 MB - hide other visible reports
  if pnlTrades.Visible then pnlTrades.hide;
  if pnlChart.Visible then pnlChart.hide;
  // --------------------------------------------
  if not(ReportStyle in [rptWashSales]) then begin
    pnlGains.Visible := True;
    pnlDoReport.Visible := true;
    pnlDoReport.Enabled:= true;
    spdRunReport.Caption := 'R&un Rpt';
  end;
  grpRptType.Visible := (ReportStyle = rpt4797);
  // ------------------------
  if grpRptType.Visible then begin
    grpRptType.Left := grpWashSales.Left;
    grpRptType.Top := grpWashSales.Top;
  end;
  // ------------------------
  if (ReportStyle = rptIRS_D1) then begin
    FilterInWashSales;
    Settings.DispWSDefer := True;
    SetOptions;
  end
  else if (ReportStyle = rptGandL) then
    FilterOutWashSales;
  // end if -----------------
  if (ReportStyle in [rptSubD1])
  and not bGetCurrentPrices then begin
    cbAdjWash.checked := not IsIra and not IsMTM;
//    cbWSshortsLongs.checked := Not IsIra and not IsMTM;
//    cbWSshortsLongs.Enabled := cbAdjWash.checked and cbAdjWash.Enabled;
    grpWashSales.Visible := not isMTM;
    {Make sure wash sales get setup properly}
    cbAdjWashClick(nil);
  end;
  // ------------------------
  // Remove all last year records for MTM Accounts.
  FilterMTMLastYear;
  bGetCurrentPrices := (OpenTradeRecordsSource <> nil)
    and (cxGrid1TableView1.DataController.CustomDataSource = OpenTradeRecordsSource);
  // ------------------------
  if panelMsg.HasTradeIssues then begin
    exitReports.Click;
    panelMsg.Show;
    panelMsg.ShowTradeIssuesError;
    Screen.Cursor := crDefault; // MB - don't exit w/o setting it back!
    exit;
  end;
  // ------------------------
  // Filter for Report
  // ------------------------
  if (ReportStyle = rptIRS_D1) then begin
    DoStocks('schedD', false); // 2020-01-05 MB - remove CUR, FUT types from 8949 rpt
    // 2021-02-23 MB - set ClrFilter to false (keep filter).
    FilterByBrokerAccountType(False, True, True, False, False, True);
  end
  else if (ReportStyle = rptFutures) then begin
    if not FilterForFutures
    or (cxGrid1TableView1.DataController.FilteredRecordCount = 0) then begin
      mDlg('No Futures to report', mtInformation, [mbOK], 0);
      exitReports.Click;
      Screen.Cursor := crDefault; // MB - don't exit w/o setting it back!
      exit;
    end;
  end // --------------------
  else if (ReportStyle = rptCurrencies) then begin
    if not FilterForCurrencies
    or (cxGrid1TableView1.DataController.FilteredRecordCount = 0) then begin
      mDlg('No Currencies to report', mtInformation, [mbOK], 0);
      exitReports.Click;
      Screen.Cursor := crDefault; // MB - don't exit w/o setting it back!
      exit;
    end;
  end // --------------------
  else if (ReportStyle = rpt4797) then begin
    if not bFiltered then ClearFilter;
    if cb4797.Checked then
      cb4797Click(nil)
    else
      cb4797.Checked := True;
  end // --------------------
  else if not bFiltered and not AllAccounts then begin
    if pnlGains.Visible then
      DoStocks; // needed for G/L report
    if TradeLogFile.CurrentBrokerID = 0 then
      FilterByBrokerAccountType(False, True, True, False) {Filter out MTM Accounts}
  end; // -------------------
  //SortByTickerForWS;
  startTime := time - startTime;
  spdRunReport.Enabled := true;
  Screen.Cursor := crDefault;
  statBar('off');
end;


procedure TfrmMain.RemoveDuplicateOpenFileMenuItems;
var
  i, j : integer;
  sFName : string;
  NewOpenFilesList : TStringList;
begin
  // 2015-07-06 Make sure there is not more than one entry with same filename
  try
    NewOpenFilesList := TStringList.create;
    for  i := 0 to Settings.LastOpenFilesList.count - 1 do begin
      sFName := Settings.LastOpenFilesList[i];
      if NewOpenFilesList.IndexOf(sFName) = -1 then
        NewOpenFilesList.add(sFName);
    end;
    // delete all entries from LastOpenFilesList
    while (Settings.LastOpenFilesList.count > 0) do
      Settings.LastOpenFilesList.Delete(0);
    // rePopulate LastOpenFilesList
    for  i := 0 to NewOpenFilesList.count - 1 do begin
      // do not save *.tdb if not taxidVer
      if not taxidVer and (pos('.tdb', NewOpenFilesList[i]) > 0) then continue;
      Settings.LastOpenFilesList.Add(NewOpenFilesList[i]);
    end;
  finally
    NewOpenFilesList.free;
  end;
end;


procedure TfrmMain.SetupLastOpenFilesMenu;
var
  i : integer;
begin
  RemoveDuplicateOpenFileMenuItems;
//  LastFile1.Caption := '';
//  LastFile2.Caption := '';
//  LastFile3.Caption := '';
//  LastFile4.Caption := '';
  btnLastFile1.Caption := '';
  btnLastFile2.Caption := '';
  btnLastFile3.Caption := '';
  btnLastFile4.Caption := '';
  if Settings.LastOpenFilesList.Count > 0 then begin
//    LastFile1.Caption := '&1  ' + Settings.LastOpenFilesList[0];
//    LastFile1.Visible := true;
    btnLastFile1.Caption := '&1  ' + Settings.LastOpenFilesList[0];
  end;
  if Settings.LastOpenFilesList.Count > 1 then begin
//    LastFile2.Caption := '&2  ' + Settings.LastOpenFilesList[1];
//    LastFile2.Visible := true;
    btnLastFile2.Caption := '&1  ' + Settings.LastOpenFilesList[1];
  end;
  if Settings.LastOpenFilesList.Count > 2 then begin
//    LastFile3.Caption := '&3  ' + Settings.LastOpenFilesList[2];
//    LastFile3.Visible := true;
    btnLastFile3.Caption := '&1  ' + Settings.LastOpenFilesList[2];
  end;
  if Settings.LastOpenFilesList.Count > 3 then begin
//    LastFile4.Caption := '&4  ' + Settings.LastOpenFilesList[3];
//    LastFile4.Visible := true;
    btnLastFile4.Caption := '&1  ' + Settings.LastOpenFilesList[3];
  end;
  //RJ Dec 23, 2020 Locad up MRU list
  bbFile_mruLastFile.Items.Clear;
  for I := 0 to Settings.LastOpenFilesList.Count-1 do
    bbFile_mruLastFile.Items.Add((*'&' + IntToStr(i+1) + '  ' + *) Settings.LastOpenFilesList[i]);
end;


procedure TfrmMain.SetupOpenCloseItems;
var
  Items : TStrings;
begin
  Items := TcxTextEditProperties(cxGrid_4_OC.Properties).LookupItems;
  Items.Clear;
  Items.Add('O');
  Items.Add('C');
  Items.Add('W');
  if Settings.MTMVersion then Items.Add('M');
end;


procedure TfrmMain.DisableAllReports;
begin
  // ----------------------------------------
  bbReports_Chart.enabled := false;
  bbReports_ForexCurrencies.enabled := false;
  bbReports_Form8949.enabled := false;
  bbReports_GainsLosses.enabled := false;
  bbReports_PotentialWashSales.enabled := false;
  bbReports_RealizedPL.enabled := false;
  bbReports_Reconcile1099.enabled := false;
  bbReports_Sec475.enabled := false;
  bbReports_Section1256.enabled := false;
  bbReports_WashSaleDetails.enabled := false;
  // ----------------------------------------
  bbReports_Performance.enabled := false;
  bbReports_Detail.enabled := false;
  bbReports_Summary.enabled := false;
  // ----------------------------------------
end; // DisableAllReports


procedure TfrmMain.SetupReportsMenu;
var
  bOpenTrades, bNoWashSalesPossible : Boolean;
begin
  try
    bOpenTrades := (OpenTradeRecordsSource <> nil)
      and (cxGrid1TableView1.DataController.CustomDataSource = OpenTradeRecordsSource);
    bNoWashSalesPossible := TradeLogFile.IsAllMTM;
    // Set Report Menus based on Account Type, TaxYear, EIN/SSN, etc.
    // Captions
    if TaxYear < '2011' then
      Form1040ScheduleD1.Caption := 'Schedule D-1 (for IRS Schedule D)'
    else
      Form1040ScheduleD1.Caption := 'Form 8949 (for IRS Schedule D)';
    if TradeLogFile.TaxYear > 2011 then
      GLScheduleDSubstitute1.Caption := GLScheduleDD1Substitute1.Caption
    else
      GLScheduleDSubstitute1.Caption := 'Gains && Losses (Schedule D-1 Substitute)';
    // --- SSN ---------------- IsEIN -- IsMTM --
    // Form1040ScheduleD1       F        -
    // GLScheduleDD1Substitute1 F        -
    // Form6781Futures1         F        T
    // ForexCurrencies1         F        -
    // Form4797MTM1             F        T
    // --- EIN ----------------------------------
    // Form8949Corporate        T        -
    // GLScheduleDSubstitute1   T        -
    // Form6781Futures2         T        T
    // ForexCurrencies2         T        -
    // Form4797MTM2             T        T
    // ------------------------------------------
    // 2017-02-21 MB - By nesting IFs rather than counting on the sequence,
    // the chances of coding errors (bugs) are reduced - Mark B
    // 2018-06-01 MB - logic modified to handle accounts which contain CTN or VTN
    // and NEVER show any tax reports for an IRA account
    // 2018-09-17 MB - changed Corporate 8949 rpt logic to match individual 8949
    // ------------------------------------------
    if not Settings.IsEin then begin // Individual reports
      GLScheduleDD1Substitute1.Enabled := (not IsMTM) //
        and (not isIRA) //
        and (not bOpenTrades) //
        and TradeLogFile.HasAccountType[atCash] //
        and TradeLogFile.IsUSCurrency;
      bbReports_GainsLosses.enabled := GLScheduleDD1Substitute1.enabled;
      // ------------------------------------------
      WashSaleDetails1.Enabled := (not bOpenTrades)
      and GLScheduleDD1Substitute1.Enabled;
      bbReports_WashSaleDetails.enabled := WashSaleDetails1.Enabled;
      // ----------------------------------------
      Form1040ScheduleD1.Enabled := (TradeLogFile.TaxYear > 2002) //
        and (GLScheduleDD1Substitute1.Enabled //
          or (TradeLogFile.HasVTNType and not isIRA));
      bbReports_Form8949.enabled := Form1040ScheduleD1.Enabled;
      // ----------------------------------------
      Form6781Futures1.Enabled := (taxidVer or Settings.MTMVersion)
        and not IsMTMForFutures and not bOpenTrades //
        and not isIRA and not bOpenTrades;
      bbReports_Section1256.enabled := Form6781Futures1.Enabled;
      // ----------------------------------------
      ForexCurrencies1.Enabled := (not isIRA) and (not bOpenTrades);
      bbReports_ForexCurrencies.enabled := ForexCurrencies1.Enabled;
      // ----------------------------------------
      Form4797MTM1.Enabled := (TradeLogFile.HasAccountType[atMTM])
        and ( (TradeLogFile.CurrentBrokerID = 0)
           or (TradeLogFile.CurrentAccount.MTM) )
        and not bOpenTrades
        and Settings.MTMVersion;
      bbReports_Sec475.enabled := Form4797MTM1.Enabled;
      // ----------------------------------------

      // ----------------------------------------
      // disable the EIN reports
      Form8949Corporate.Enabled := false;
      GLScheduleDSubstitute1.Enabled := false;
      Form6781Futures2.Enabled := false;
      ForexCurrencies2.Enabled := false;
      Form4797MTM2.Enabled := false;
    end
    // ------------------------------------------
    else begin // Corporate Entity reports
      Form8949Corporate.Visible := (TradeLogFile.TaxYear > 2011);
      // ----------------------------------------
      GLScheduleDSubstitute1.Enabled := not IsMTM and not isIRA
        and not bOpenTrades and TradeLogFile.IsUSCurrency
        and TradeLogFile.HasAccountType[atCash]; // 2018-09-17 MB - removed VTN
      bbReports_GainsLosses.enabled := GLScheduleDSubstitute1.enabled;
      // ------------------------------------------
      WashSaleDetails1.Enabled := (not bOpenTrades)
        and GLScheduleDSubstitute1.Enabled;
      bbReports_WashSaleDetails.enabled := WashSaleDetails1.Enabled;
      // ----------------------------------------
      Form8949Corporate.Enabled := GLScheduleDSubstitute1.Enabled //
        or (TradeLogFile.HasVTNType and not isIRA);
      bbReports_Form8949.enabled := Form8949Corporate.Enabled;
      // ----------------------------------------
      Form6781Futures2.Enabled := (taxidVer or Settings.MTMVersion)
        and not IsMTMForFutures and not bOpenTrades and not isIRA
        and not bOpenTrades;
      bbReports_Section1256.enabled := Form6781Futures2.Enabled;
      // ----------------------------------------
      ForexCurrencies2.Enabled := (TradeLogFile.HasCTNType or not isIRA) and not bOpenTrades;
      bbReports_ForexCurrencies.enabled := ForexCurrencies2.Enabled;
      // ----------------------------------------
      Form4797MTM2.Enabled := (TradeLogFile.HasAccountType[atMTM])
        and ( (TradeLogFile.CurrentBrokerID = 0)
           or (TradeLogFile.CurrentAccount.MTM) )
        and not bOpenTrades
        and Settings.MTMVersion; // added 2017-02-21 MB
      bbReports_Sec475.enabled := Form4797MTM2.Enabled;
      // ----------------------------------------
      // disable the SSN reports
      GLScheduleDD1Substitute1.Enabled := false;
      Form1040ScheduleD1.Enabled := false;
      Form6781Futures1.Enabled := false;
      ForexCurrencies1.Enabled := false;
      Form4797MTM1.Enabled := false;
    end;
    // ------------------------------------------
    Reconcile1099B1.Enabled := (TradeLogFile.CurrentBrokerID > 0)
      and not bOpenTrades and not IsIRA;
    bbReports_Reconcile1099.enabled := Reconcile1099B1.Enabled;
    // ------------------------------------------
    Chart1.Enabled := not bOpenTrades;
    bbReports_Chart.enabled := Chart1.Enabled;
    // ------------------------------------------
    // Realized P/L
    GainsLossesAllAccounts1.enabled :=  not bOpenTrades;
    bbReports_RealizedPL.enabled := GainsLossesAllAccounts1.enabled;
    // ------------------------------------------
    // Only enable this report for a single Account file,
    // or when on the all tab for a multi account file
    PotentialWashSales1.Enabled := ((TradeLogFile.CurrentBrokerID = 0)
      or (TradeLogFile.FileHeaders.Count = 1))
      and not bOpenTrades;
    bbReports_PotentialWashSales.enabled := PotentialWashSales1.enabled;
    // ------------------------------------------
    if TradeLogFile.CurrentBrokerID = 0 then // multi-acct
      PotentialWashSales1.Enabled := NOT(bNoWashSalesPossible)
    else
      PotentialWashSales1.Enabled := NOT(TradeLogFile.CurrentAccount.MTM);
    bbReports_PotentialWashSales.enabled := PotentialWashSales1.enabled;
    // ------------------------------------------
    // These are just headings for the report menu, We always want them to
    // be disabled
    TaxAnalysis1.Enabled := False;
    TaxesIndividual1.Enabled := False;
    TaxesCorporate1.Enabled := False;
    TradeAnalysis1.Enabled := False;
    ReportOptions1.Enabled := False;
  finally
    // ------ always ON -------------------------
    bbReports_Performance.enabled := true;
    bbReports_Detail.enabled := true;
    bbReports_Summary.enabled := true;
    // ------------------------------------------
  end;
end; // SetupReportsMenu


procedure TfrmMain.SetupTabs;
var
  Header : TTLFileHeader;
  TabItem : TrzTabCollectionItem;
begin
  SettingUpTabs := True;
  tabAccounts.Tabs.Clear;
  {We want the tab there so that code checking for tabIndex of zero works
    no matter whether we are multibroker or not.}
  TabItem := tabAccounts.Tabs.Add;
  TabItem.Caption := 'All Accounts';
  TabItem.Color := tabAccounts.TabColors.Unselected;
  tabAccounts.Tabs[0].Visible := TradeLogFile.MultiBrokerFile;
  for Header in TradeLogFile.FileHeaders do begin
    TabItem := tabAccounts.Tabs.Add;
    TabItem.Caption := Header.AccountName;
    TabItem.Color := tabAccounts.TabColors.Unselected;
  end;
  {Add Plus Tab}
  TabItem := TabAccounts.Tabs.Add;
  TabItem.Caption := '+';
  TabItem.Color := tabAccounts.TabColors.Unselected;
  if TradeLogFile.MultiBrokerFile then
    tabAccounts.TabIndex := 0
  else
    tabAccounts.TabIndex := 1;
  SettingUpTabs := False;

  UserChangedTab := false;
  tabAccountsChange(nil);
end;


procedure TfrmMain.SetupTitleAndSummaryColors;
var
  APainterInfo: TdxSkinLookAndFeelPainterInfo;
  ASkin: TdxSkin;
  AGroup: TdxSkinControlGroup;
  AElement: TdxSkinElement;
  AProperty: TdxSkinProperty;
  sDir, sSkin : string;
begin
  if RootLookAndFeel.Painter.GetPainterData(APainterInfo) then begin
    sDir := ExtractFileDir(Application.ExeName) + '\';
    ASkin := APainterInfo.Skin;
    //Find an element group
    if ASkin.GetGroupByName('Form', AGroup) //
    and (FileExists(sDir+'FormContent_Image.png')) then begin
      //Find an element
      if AGroup.GetElementByName('FormContent', AElement) then
        // Change the form background texture
        AElement.Image.LoadFromFile(sDir+'FormContent_Image.png');
      //Find an element
      if AGroup.GetElementByName('FormCaption', AElement) then
        //Change the form title background texture
        AElement.Image.LoadFromFile(sDir+'FormCaption_Image.png');
      AElement.TextColor := clWhite;
    end;
    // Change content color
    // ASkin.GetColorByName(sDir+'ContentColor').Value := clWhite;
    // Refresh
    RootLookAndFeel.Refresh;
  end;
end;


procedure TfrmMain.SetupToolBarMenuBar(bGetCurrentPrices: Boolean);
var
  I : Integer;
  bmtEditActive : boolean; // see if current Ribbon Tab is mtEdit
begin
  try
    EnableMenuToolsAll;
    if bGetCurrentPrices then begin
      btnShowAll.Caption := ' Close';
      btnShowAll.ImageIndex := 38;
    end
    else begin
      btnShowAll.Caption := 'ALL Trades';
      btnShowAll.ImageIndex := 6;
    end;
    pnlTools.Visible := True;
    btnShowOpen.Visible := not bGetCurrentPrices;
    btnShowRange.Visible := not bGetCurrentPrices;
    btnClosed.Visible := not bGetCurrentPrices;
    btnFilterEnable.Visible := not bGetCurrentPrices;
    btnFilterCustom.Visible := not bGetCurrentPrices;
    btnAddRec.Visible := not bGetCurrentPrices;
    btnInsRec.Visible := not bGetCurrentPrices;
    btnDelRec.Visible := not bGetCurrentPrices;
    btnUndo.Visible := not bGetCurrentPrices;
    btnRedo.Visible := not bGetCurrentPrices;
    btnImport.Visible := not bGetCurrentPrices;
    Separator1.Visible := not bGetCurrentPrices;
    Separator2.Visible := not bGetCurrentPrices;
    Separator3.Visible := not bGetCurrentPrices;
    Separator4.Visible := not bGetCurrentPrices;
    Separator6.Visible := not bGetCurrentPrices;
    bbFile_Edit.Enabled := not bGetCurrentPrices;
    mnuAcct.Enabled := not bGetCurrentPrices;
    mnuAdd.Enabled := not bGetCurrentPrices and not isAllBrokersSelected;
    mnuEdit.Enabled := not bGetCurrentPrices and not isAllBrokersSelected;
    mnuAcct_Edit.Visible := not IsAllBrokersSelected;
    DeleteAccount1.Visible := not IsAllBrokersSelected;
    TransferOpenPositions1.Visible := not IsAllBrokersSelected;
    btnImport.Enabled := not IsAllBrokersSelected;
    btnAddRec.Enabled := not IsAllBrokersSelected;
    btnInsRec.Enabled := not IsAllBrokersSelected;
    btnDelRec.Enabled := not IsAllBrokersSelected;
    // --- reset default hint ---
    bbAccount_BrokerConnect.Hint := 'Broker Connect';
    // --------------------------
    if not bGetCurrentPrices then
      if not IsAllBrokersSelected then
        EnableTabItems('enableEdits')
      else
        EnableTabItems('AllTrades'); // limited
    // --- 1st 3 menu items only apply to the all tab -----
    if IsAllBrokersSelected then begin //                    ALL ACCOUNTS
      MTMAccounts1.Visible := true;
      IraAccounts1.Visible := true;
      CashAccounts1.Visible := true;
      N10.Visible := true;
      // --------------------
      bbAccount_ImportSettings.enabled := false;
      bbAccount_BrokerConnect.enabled := false;
      bbAccount_FromFile.enabled := false;
      // --------------------
      btnImportHelp.Enabled := false;
      btnImportHelp.Caption := 'Help for Import';
    end
    else begin // single account tab
      if (TradeLogFile.CurrentAccount.FileImportFormat = 'Other') // EXCEL import only!
      then begin
        bbAccount_ImportSettings.enabled := false;
        bbAccount_BrokerConnect.enabled := false;
        bbAccount_FromFile.enabled := false;
      end
      else if (TradeLogFile.CurrentAccount.FileImportFormat = 'IB') //
      then begin
        bbAccount_ImportSettings.enabled := true;
        bbAccount_BrokerConnect.enabled := true;
        bbAccount_FromFile.enabled := true;
      end
      else if Settings.LegacyBC //
      and ((TradeLogFile.CurrentAccount.importFilter.FilterName = 'E-Trade') //
      or (TradeLogFile.CurrentAccount.importFilter.FilterName = 'Fidelity')) //
      then begin
        bbAccount_ImportSettings.enabled := true;
        bbAccount_BrokerConnect.enabled := true;
        bbAccount_FromFile.enabled := true;
      end
      else if (TradeLogFile.CurrentAccount.ImportFilter.FastLinkable = true) //
      then begin
        bbAccount_ImportSettings.enabled := true;
        if (TradeLogFile.CurrentAccount.PlaidAcctId = '') then begin
          bbAccount_BrokerConnect.enabled := false; // link not set up yet
          bbAccount_BrokerConnect.Hint := 'Not set up yet.';
        end
        else begin
          bbAccount_BrokerConnect.enabled := NewBCenabled; // see globalVariables
        end;
        bbAccount_FromFile.enabled := true;
      end
      else if (TradeLogFile.CurrentAccount.ImportFilter.FastLinkable = false) //
      then begin
        bbAccount_ImportSettings.enabled := true;
        bbAccount_BrokerConnect.enabled := false;
        bbAccount_FromFile.enabled := true;
      end
      else begin // none of these, so disable BC
        bbAccount_BrokerConnect.enabled := false;
      end;
      // --------------------
      btnImportHelp.Enabled := true;
      btnImportHelp.Caption := 'Help for ' + TradeLogFile.CurrentAccount.FileImportFormat;
    end; // all accounts or just one?
    // --------------------------------
//    File1.Enabled := not bGetCurrentPrices;
    EndYearCheckList1.Visible := (TradeLogFile <> nil) and not TradeLogFile.BeforeCheckList;
    SetPopupMenuEnabled(pupEdit, not IsAllBrokersSelected);
    CopyMenu(pupAccount.Items, mnuAcct);
    CheckForBaks; // enable undo and redo if Undo/Redo backup files exist.
    SetupReportsMenu;
  finally
    // disable edit menus if taxidVer and file not converted
    if taxidVer and (iVer < 0) then disableEdits; // lock unconverted files
  end;
end; // SetupToolBarMenuBar


procedure TfrmMain.SetWSDefer;
begin
  if panelSplash.Visible then exit;
  if Settings.DispWSdefer then
    FilterInWashSales
  else
    filterOutWashSales;
end;


procedure TfrmMain.GoToInAccountTab1Click(Sender: TObject);
var
  FocusedRec : Integer;
  FocusedRow : Integer;
begin
  FocusedRec := cxGrid1TableView1.DataController.FocusedRecordIndex;
  if (tabAccounts.TabIndex = 0) and (FocusedRec > -1) then begin
    ChangeToTab(TradeLogFile.FileHeader[TradeLogFile[FocusedRec].Broker].AccountName);
    FocusedRow := cxGrid1TableView1.DataController.GetRowIndexByRecordIndex(FocusedRec, True);
    cxGrid1TableView1.DataController.SelectRows(FocusedRow, FocusedRow);
    cxGrid1TableView1.DataController.MoveBy(FocusedRow);
  end;
end;


procedure TfrmMain.GridEscape;
begin
  // add/insert records
  if insertRec or addRec then begin
    insertRec := False;
    addRec := False;
    cxGrid1TableView1.DataController.DeleteSelection;
  end
  // edit records
  else if EditRec then begin
    EditRec := False;
    editDisable(False);
    TradeLogFile.Revert;
    TradeRecordsSource.DataChanged;
    btnShowAll.Click;
    exit;
  end
  else begin
    stopUpdate := true;
    if btnShowAll.Down then begin
      clearFilter;
      cxGrid1TableView1.DataController.clearSelection;
      FindTradeIssues;
      dispProfit(true, 0, 0, 0, 0);
      exit;
    end
    else
      btnShowAll.Click;
    // end if
//    if (pos('2:', panelQS.cboStep.Text) = 1) and not doingQS then panelQS.show;
    if panelSplash.Visible then begin
      panelSplash.hide;
      btnImport.Enabled := true;
      EnteringBeginYearPrice := False;
    end;
  end;
  editDisable(False);
end;


function TfrmMain.HelpRouter1Help(Command: Word; Data: Integer;
  var CallHelp: Boolean): Boolean;
begin
  CallHelp := False;
end;

// --------------------------------------------------------
//
// --------------------------------------------------------
procedure TfrmMain.cxGrid1TableView1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  TrNum, i, j : Integer;
  myDate, sFilter, Tk : string;
  // ----------------------------------
  function saveAddEdit(undoTxt:string): boolean;
   var
     r : integer;
     tk : string;
   begin
     tk := '';
     result := true;
     try
       with cxGrid1TableView1.DataController do begin
         r := GetFocusedRowIndex;
         SelectRows(r, r);
       end;
       if (pos('Add', undoTxt) = 1) then begin
         glEditListTicks.Add(cxGrid_6_Ticker.EditValue);
         tk := cxGrid_6_Ticker.EditValue;
       end
       else if (pos('Edit', undoTxt) = 1) then begin
         tk := glEditListTicks[glEditListTicks.Count-1];
         clearFilter;
       end;
       editDisable(True);
       // Save Undo file, match & reorganize, load into grid
       SaveTradesBack(undoTxt);
       TradeLogFile.Match(glEditListTicks); // <------- HERE'S THE REMATCH AFTER CHANGES!
       TradeLogFile.Reorganize;
       // --- Load data into Grid ---------------
       TradeLogFile.CreateLists;
       TradeRecordsSource.DataChanged;
       if (tk <> '') then begin// it was an ADD
         cxGrid1TableView1.DataController.ClearSelection;
         filterbytick(tk);
       end;
       // --- Save the File ---------------------
       if not SaveTradeLogFile then result := false;
     finally
       FindTradeIssues;
     end;
   end;
  // ----------------------------------
begin
  if deletingRecords
  or (pos('Sorting', stMessage.Caption) > 0)
  or (pos('Matching', stMessage.Caption) > 0)
  or (pos('Checking', stMessage.Caption) > 0)
  or IsFormVisible('frmOpenTrades') then begin
    exit;
  end;
  // renum:= false;
  Case Key of
    13:
      begin
        // sm('Enter');
        if cxGrid1TableView1.optionsData.editing then begin
          // check for missing data
          MsgTxt := '';
          if (cxGrid_4_OC.EditValue = 'W') then begin
            if (cxGrid_6_Ticker.EditValue = '') then
              MsgTxt := 'Please enter a Ticker symbol in the Ticker column.' + cr;
            if (cxGrid_7_Shares.EditValue <= 0) then
              MsgTxt := MsgTxt + 'Please enter a positive number in the Sh/Contr column.' + cr;
            if (cxGrid_11_Amount.EditValue >= 0) then
              MsgTxt := MsgTxt + 'Please enter a Negative number in the Amount column.' + cr;
            if MsgTxt <> '' then begin
              mDlg('Data Entry Error:' + cr + cr + MsgTxt, mtError, [mbOK], 1);
              exit;
            end;
          end
          else if (cxGrid_4_OC.EditValue <> 'W') then begin
            if (cxGrid_4_OC.EditValue = '') or (cxGrid_4_OC.EditValue = ' ') then
              MsgTxt := 'Please select O, C, M, or W in the Open/Close column.' + cr;
            if (cxGrid_5_LS.EditValue = '') or (cxGrid_5_LS.EditValue = ' ') then
              MsgTxt := MsgTxt + 'Please select L or S in the Short/Long column.' + cr;
            if (cxGrid_6_Ticker.EditValue = '') or (cxGrid_6_Ticker.EditValue = ' ') then
              MsgTxt := MsgTxt + 'Please enter a Ticker symbol in the Ticker column.' + cr;
            if (cxGrid_9_PRF.EditValue = '') or (cxGrid_9_PRF.EditValue = ' ') then
              MsgTxt := MsgTxt + 'Please select the proper Type in the Type/Mult column.' + cr;
            if (cxGrid_7_Shares.EditValue <= 0) then
              MsgTxt := MsgTxt + 'Please enter a positive number in the Sh/Contr column.' + cr;
             if ((cxGrid_8_Price.EditValue = 0) and EnteringBeginYearPrice) then
              MsgTxt := MsgTxt + 'Please enter a Price in the Price column.' + cr;
            if MsgTxt <> '' then begin
              mDlg('Data Entry Error:' + cr + cr + MsgTxt, mtError, [mbOK], 1);
              exit;
            end;
          end;
          {2014-02-03
          if (cxGrid_2_Date.EditValue > strToDate('01/31/' + nexttaxyear, Settings.InternalFmt))
          then begin
            mDlg('Cannot enter a date past 01/31/' + nexttaxyear + cr
              + 'in a ' + TaxYear + ' data file', mtError, [mbOK], 1);
            exit;
          end;
          }
          if EnteringBeginYearPrice then begin
            SaveTradesBack('Add Transaction');
            if not SaveGridData(true) then begin
              EnteringBeginYearPrice := False;
              exit;
            end;
            SaveTradeLogFile('', True);
            if panelMsg.HasTradeIssues then begin
              ProcessBeginYearDone;
              exit;
            end;
            if mDlg('Enter another open position?', mtConfirmation, [mbYes, mbNo], 1) = mrYes
            then begin
              if not panelMsg.HasTradeIssues then EnterBeginYearPrice;
              exit;
            end;
//            panelQS.doQuickStart(3, 1);
          end
          // ADDING RECORDS
          else if not EditRec then begin
            statBar('Adding Record');
            if insertRec then insertRec := False;
            if addRec then addRec := False;
            if not saveAddEdit('Add Transaction') then begin
              Undo(false, true);
              exit;
            end;
            if mDlg('Enter another transaction?', mtConfirmation, [mbYes, mbNo], 1) = mrYes
            then begin
              if not panelMsg.HasTradeIssues then btnAddRec.Click;
              exit;
            end;
          end
          // EDITING RECORDS
          else begin
            EditRec := False;
            if not saveAddEdit('Edit Records') then begin
              Undo(false, true);
              exit;
            end;
          end;
          if EnteringBeginYearPrice then ProcessBeginYearDone;
        end
        else begin
          dispProfit(true, 0, 0, 0, 0);
          if panelMsg.HasTradeIssues then
            FindTradeIssues
          else
            WriteFilter(True);
        end;
        FindTradeIssues;
      end;
    27: // Escape
      begin
        cxGrid1.Enabled := False;
        try
          if EnteringBeginYearPrice then begin
            GridEscape;
            EnteringBeginYearPrice := False;
          end;
          if not(frmEditSplit.Visible) //
          and not panelSplash.Visible then
            GridEscape;
          StopReport := true;
          Key := 0;
        finally
          statBar('off');
          cxGrid1.Enabled := True;
          cxGrid1.SetFocus;
          screen.Cursor := crDefault;
        end;
      end;
    36: // Home
      begin
        // do nothing
      end;
    38: // Up Arrow
      Begin
        if cxGrid1TableView1.optionsData.editing then begin
          // cxGrid1TableView1.DataController.gotoNext;
          // editDisable(false);
        end;
      end;
    40: // Down Arrow
      Begin
        if cxGrid1TableView1.optionsData.editing then begin
          // cxGrid1TableView1.DataController.gotoPrev;
          // editDisable(false);
        end;
      end;
    116: // F5 Add Record
      if (cxGrid1TableView1.DataController.CustomDataSource <> OpenTradeRecordsSource)
      and btnAddRec.Enabled then begin
        btnAddRec.Click;
      end;
    117: // F6 Insert Record
      if (cxGrid1TableView1.DataController.CustomDataSource <> OpenTradeRecordsSource)
      and btnInsRec.Enabled then begin
        btnInsRec.Click;
      end;
  end;
  if Shift = [ssCtrl] then
    case Key of
      73: // i = import
        begin
          if not oneYrLocked
          and not isAllBrokersSelected
          and not bEditsDisabled
          then
            btnImport.Click;
        end;
      79: // o
        begin
          btnShowOpen.Click;
        end;
    end;
  screen.cursor := crDefault;
end;


procedure TfrmMain.cxGrid1TableView1DataControllerSortingChanged(Sender: TObject);
begin
  if (pos('Sorting', stMessage.Caption) > 0)
  or (pos('Matching', stMessage.Caption) > 0)
  or (pos('Loading', stMessage.Caption) > 0) then
    exit;
  cxGrid1TableView1.DataController.FocusedRowIndex := 0;
  dispProfit(true, 0, 0, 0, 0);
  SortBy := 'column';
end;


procedure TfrmMain.cxGrid1TableView1DblClick(Sender: TObject);
var
  i, TrNum: Integer;
  RecIndex, RowIdx : Integer;
  MsgType : TMessageType;
begin
  // sm('onCellDoubleClick');
  if TradeLogFile.Count = 0 then exit;
  GridFilter := gfNone;
  if deletingRecords
  or ReOrdering
  or (pos('Sorting', stMessage.Caption) > 0)
  or (pos('Matching', stMessage.Caption) > 0)
  or frmMain.cxGrid1TableView1.DataController.IsEditing
  or (frmMain.cxGrid1TableView1.DataController.focusedRecordIndex < 0) then begin
    cxGrid1.Enabled := true;
    cxGrid1.SetFocus;
    exit;
  end;
  RecIndex := cxGrid1TableView1.DataController.FocusedRecordIndex;
  // --------- error condition --------
  if panelMsg.Visible then begin
    MsgType := panelMsg.MessageType;
    // if ALL account tab then go to account with warning
    if (tabAccounts.TabIndex = 0) and (RecIndex > -1) then begin
      ChangeToTab(TradeLogFile.FileHeader[TradeLogFile[RecIndex].Broker].AccountName);
      panelMsg.JumpToMessageType(MsgType);
      cxGrid1TableView1.DataController.clearSelection;
    end;
    if (pos('Ticker', cxGrid1TableView1.DataController.Filter.filterText) > 0) then begin
      mnuAdd.Enabled := not (OneYrLocked or isAllBrokersSelected);
      btnAddRec.Enabled := not (OneYrLocked or isAllBrokersSelected);
      btnInsRec.Enabled := not (OneYrLocked or isAllBrokersSelected);
      btnDelRec.Enabled := not (OneYrLocked or isAllBrokersSelected);
      AddRecord1.Enabled := not (OneYrLocked or isAllBrokersSelected);
      InsertRecord1.Enabled := not (OneYrLocked or isAllBrokersSelected);
      EnterOpenPositions1.Enabled := not (OneYrLocked or isAllBrokersSelected);
    end;
    // ------- is error neg sh? -------
    if TradeLogFile.HasNegShares then begin
      // added 2015-07-20 so record with neg shares is selected in grid
      with cxGrid1TableView1.DataController do begin
        dispNegShTicker(Values[recIndex,6]);
        RowIdx := GetRowIndexByRecordIndex(RecIndex,true);
        FocusedRecordIndex := RecIndex;
        SelectRows(RowIdx, RowIdx);
      end;
      panelMsg.show;
    end
    // ------- NO. Is it cancels? -----
    else if TradeLogFile.HasCancelledTrades then begin
      // display all records for selected ticker
      clearFilter;
      filterByTick(TradeLogFile[RecIndex].Ticker);
      sortByDate;
      // select first X record
      with cxGrid1TableView1.DataController do begin
        clearSelection;
        for i := 0 to filteredRecordCount - 1 do
          if values[i, 4] = 'X' then begin
            selectRows(i, i);
            exit;
          end;
      end;
      mDlg('Please select the cancelled trade record (OC = "X")' +cr+
        ' along with the trade record it cancelled' +cr+
        ' and delete them both.', mtInformation, [mbOK], 0);
    end;
    screen.Cursor := crDefault;
    panelMsg.Close;
    exit;
  end;
  cxGrid1.Enabled := False;
  TrNum := cxGrid1TableView1.DataController.values[cxGrid1TableView1.DataController.focusedRecordIndex, 1];
  // We are on the all tab so switch to the appropriate account tab for the trade double clicked on
  if (tabAccounts.TabIndex = 0) then
    ChangeToTab(TradeLogFile.FileHeader[TradeLogFile[RecIndex].Broker].AccountName);
  cxGrid1TableView1.DataController.Filter.BeginUpdate;
  try
    ClearFilter;
    cxGrid1TableView1.DataController.Filter.Root.AddItem(
      cxGrid1TableView1.Items[1], foEqual, TrNum, intToStr(TrNum));
    cxGrid1TableView1.DataController.Filter.Active := true;
  finally
    cxGrid1TableView1.DataController.Filter.endUpdate;
  end;
  if btnFilterEnable.Down then
    cxGrid1TableView1.OptionsCustomize.ColumnFiltering := False;
  cxGrid1.Enabled := true;
  cxGrid1.SetFocus;
  if frmMain.cxGrid1TableView1.DataController.IsEditing then
    frmMain.cxGrid1TableView1.optionsData.editing := False;
  cxGrid1TableView1.DataController.clearSelection;
  dispProfit(true, 0, 0, 0, 0);
  screen.Cursor := crDefault;
end;


procedure TfrmMain.cxGrid1TableView1DragDrop(Sender, Source: TObject; X, Y: Integer);
var
  BeginRow, EndRow, EndRec, tr: Integer;
  dt: Tdate;
  tm, OC, ls, tk, prf: string;
  sh, pr, cm, am: double;
  NegShares : Boolean;
begin
  if (pos('Sorting', stMessage.Caption) > 0)
  or (pos('Matching', stMessage.Caption) > 0)
  or AddRec or InsertRec or EditRec
  or (frmMain.cxGrid1TableView1.DataController.FocusedRecordIndex < 0)
  or (cxGrid1TableView1.DataController.GetSelectedCount = 0)
  then exit;
  // ----------------------------------
  NegShares := TradeLogFile.HasNegShares;
  if Source is TcxDragControlObject then begin
    with TcxDragControlObject(Source) do begin
      if Control is TcxGridSite then begin
        with TcxGridSite(Control) do begin
          with cxGrid1TableView1.DataController do begin
            if GetSelectedCount > 1 then begin
              mDlg('Can only move one record at a time!', mtError, [mbOK], 0);
              exit;
            end;
            BeginRow := GetRowInfo(GetSelectedRowIndex(0)).RecordIndex;
            EndRow := FocusedRowIndex;
            EndRec := focusedRecordIndex;
            TradeLogFile.MoveRecord(BeginRow, EndRec);
            TradeRecordsSource.DataChanged;
            clearSelection;
            ChangeRowSelection(EndRow, true);
            if mDlg('Move record here?', mtWarning, [mbNo, mbYes], 0) <> mrYes
            then begin
              // Move the record back and showAll
              TradeLogFile.MoveRecord(EndRec, BeginRow);
              btnShowAll.Click;
            end
            else begin // ---------------------------
              TradeLogFile.RenumberItemField;
              TradeLogfile.MatchAndReorganize;
              TradeRecordsSource.DataChanged;
              if NegShares then begin
                ClearFilter;
                FindTradeIssues;
              end;
              SaveTradeLogFile('Move');
            end;
            // ----------------------------------
            clearSelection;
            dispProfit(true, 0, 0, 0, 0);
          end; // with cxGrid1TableView1.DataController do
        end; // with TcxGridSite(Control) do
      end; // if Control is ...
    end; // with TcxDragControlObject(Source) do
  end; // if Source is ...
end;


procedure TfrmMain.cxGrid1TableView1DragOver(Sender, Source: TObject;
  X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := False;
  if (pos('Sorting', stMessage.Caption) > 0)
  or (pos('Matching', stMessage.Caption) > 0)
  or addRec or insertRec or EditRec
  or (TradeLogFile.Count = 0)
  or (frmMain.cxGrid1TableView1.DataController.focusedRecordIndex < 0)
  or (cxGrid1TableView1.DataController.GetSelectedCount = 0)
  then begin
    exit;
  end;
  // ------------------------
  if Source is TcxDragControlObject then begin
    with TcxDragControlObject(Source) do begin
      if Control is TcxGridSite then begin
        with TcxGridSite(Control) do begin
          Accept := (GridView.PatternGridView = cxGrid1TableView1);
        end; // with TcxGridSite
      end; // if Control is...
    end; // with TcxDragControlObject
  end; // if Source is...
end;


procedure TfrmMain.cxGrid1TableView1Editing(Sender: TcxCustomGridTableView;
  AItem: TcxCustomGridTableItem; var AAllow: Boolean);
begin
  DeleteSelectedRec.ShortCut := ShortCut(0, []);
end;


procedure TfrmMain.cxGrid1TableView1FocusedRecordChanged(Sender: TcxCustomGridTableView;
  APrevFocusedRecord, AFocusedRecord: TcxCustomGridRecord;
  ANewItemRecordFocusingChanged: Boolean);
var
  aRow, aRec: Integer;
  I, ItemNum: Integer;
  shOpen, contrOpen, commis, Profit: Double;
  nPL, nCm : Double; // ** NEW **
  aRowInfo : TcxRowInfo;
  msgTxt: string;
begin
  if EditRec then exit;
  // 2015-05-25 fix for using File, Save when adding or inserting
  if (AddRec or InsertRec) and not EnteringBeginYearPrice and not savingFile then begin
    if AddRec then
      msgTxt := 'Add Record Cancelled!'
    else if InsertRec then
      msgTxt := 'Insert Record Cancelled!';
    mDlg(msgTxt + cr + cr + 'Please do NOT click on another row when entering trades.',
      mtWarning,[mbOK], 0);
    GridEscape;
    mySendKeys(char(27));
    exit;
  end;
  // ------------------------
  if cxGrid1TableView1.optionsData.editing then
    cxGrid1TableView1.controller.EditingItem := cxGrid1TableView1.controller.focusedItem;
  if cxGrid1TableView1.optionsData.editing
  or (pos('Sorting', stMessage.Caption) > 0)
  or (pos('Matching', stMessage.Caption) > 0)
  or (stMessage.Caption = 'Loading grid')
  or AddRec or deletingRecords
  or ((TradeLogFile <> nil) and (TradeLogFile.Count = 0))
  or (frmMain.cxGrid1TableView1.DataController.FocusedRecordIndex < 0)
  then exit;
  // ------------------------
  Profit := 0;
  shOpen := 0;
  contrOpen := 0;
  commis := 0;
  frmMain.txtProfit.Caption := '';
  frmMain.txtSharesOpen.Caption := '';
  if (TradeLogFile.Count <= 0) then exit;
  // ------------------------
  with cxGrid1TableView1.DataController do
    if CustomDataSource = OpenTradeRecordsSource then begin
      for I := 0 to recordcount - 1 do begin
        if values[FocusedRowIndex, 1] = values[I, 1] then begin
          if values[I, 4] = 'O' then
            shOpen := shOpen + values[I, 7]
          else if values[I, 4] = 'C' then
            shOpen := shOpen - values[I, 7];
          Profit := values[I, 12];
        end;
        if (I = FocusedRecordIndex) then break;
      end;
      dispProfit(false, Profit, shOpen, contrOpen, commis);
    end
//    // ----------------------
//    else if GetSelectedCount > 0 then begin
//      nPL := 0; // ** NEW **
//      nCm := 0; // ** NEW **
//      for i := 0 to  GetSelectedCount - 1 do begin
//        aRow := GetSelectedRowIndex(I);
//        aRowInfo := GetRowInfo(aRow);
//        ARec := aRowInfo.RecordIndex;
//        nPL := nPL + values[aRec,11]; // ** NEW **
//        nCm := nCm + values[aRec,10]; // ** NEW **
//        if values[FocusedRowIndex, 1] = values[I, 1] then begin
//          if values[I, 4] = 'O' then
//            shOpen := shOpen + values[I, 7]
//          else if values[I, 4] = 'C' then
//            shOpen := shOpen - values[I, 7];
//          Profit := values[I, 12];
//        end;
//        if (I = FocusedRecordIndex) then break;
//      end;
//      dispProfit(false, nPL, shOpen, contrOpen, nCm);
//    end
//    // ----------------------
    else begin
      ItemNum := FocusedRecordIndex;
      if (TradeLogFile.Trade[ItemNum].OC = 'C')
      or (TradeLogFile.Trade[ItemNum].OC = 'W')
      or (TradeLogFile.Trade[ItemNum].OC = 'M') then
        Profit := TradeLogFile.Trade[ItemNum].PL;
      if TradeLogFile.Trade[ItemNum].IsStockType then
        shOpen := TradeLogFile.Trade[ItemNum].OpenShares
      else
        contrOpen := TradeLogFile.Trade[ItemNum].OpenShares;
      commis := TradeLogFile.Trade[ItemNum].Commission;
      dispProfit(false, Profit, shOpen, contrOpen, commis);
    end;
end;


procedure TfrmMain.cxGrid1TableView1InitEdit(Sender: TcxCustomGridTableView;
  AItem: TcxCustomGridTableItem; AEdit: TcxCustomEdit);
begin
  if AEdit is TcxDateEdit then
    with AEdit as TcxDateEdit do
      properties.DateButtons := [btnToday];
end;


procedure TfrmMain.actnInsRecClick(Sender: TObject);
var
  RecIdx : Integer;
begin
  if oneYrLocked or cxGrid1TableView1.optionsData.editing
  or TradeLogFile.YearEndDone or panelSplash.Visible or insertRec
  or (TradeLogFile.CurrentBrokerID = 0) then
    exit;
  if (TradeLogFile.Count = 0) then begin
    btnAddRec.Click;
    exit;
  end;
  try
  if not CheckRecordLimit then exit;
  if frmMain.cxGrid1TableView1.DataController.GetSelectedCount = 0 then begin
    mDlg('Please select a record to insert before', mtInformation, [mbOK], 0);
    exit;
  end;
  RecIdx := cxGrid1TableView1.DataController.GetFocusedRecordIndex;
  cxGrid1TableView1.DataController.insertRecord(RecIdx);
  InsertRec := true;
  finally
    //
  end;
end;


procedure TfrmMain.actnAddRecClick(Sender: TObject);
var
  Shares: double;
begin
  // ---- skip code -------------------
  if oneYrLocked
  or IsAllBrokersSelected
  or TradeLogFile.YearEndDone
  or cxGrid1TableView1.optionsData.editing
  or (TradeLogFile.CurrentBrokerID = 0) then
    exit;
  if panelSplash.Visible then exit;
  if not CheckRecordLimit then exit;
  // ----------------------------------
  // AddRecord
  try
  readFilter;
  cxGrid1TableView1.DataController.clearSorting(False);
  with cxGrid1TableView1.DataController do begin
    if TradeLogFile.Count > 0 then
      if CustomDataSource <> TradeRecordsSource then
        TradeRecordsSource.DataChanged;
    if not DisplayWashSales1.checked then
      DisplayWashSales1.Click;
    Append;
    FocusedRowIndex := RowCount - 1;
    clearSelection;
    ChangeRowSelection(RowCount - 1, true);
    if panelMsg.HasTradeIssues then
      cxGrid1TableView1.Columns[4].EditValue := 'O';
    cxGrid1TableView1.Columns[2].focused := true;
  end;
  frmMain.txtSharesOpen.Caption := '';
  addRec := true;
  finally
    //
  end;
end; // AddRecord


procedure TfrmMain.actnDelRecClick(Sender: TObject);
begin
  if oneYrLocked or cxGrid1TableView1.optionsData.editing
  or IsAllBrokersSelected then
    exit;
  if not CheckRecordLimit then Exit;
  DelSelectedRecords;
end;


procedure TfrmMain.cxGrid_1_TrNumPropertiesEditValueChanged(Sender: TObject);
var
  tr: Integer;
begin
  tr := (TcxMaskEdit(Sender).EditValue);
  cxGrid_1_TrNum.EditValue := tr;
  renumFldChanged := true;
end;


procedure TfrmMain.cxGrid_1_TrNumPropertiesValidate(Sender: TObject;
  var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
begin
  if (DisplayValue = '') then begin
    ErrorText := '      Trade Number Cannot Be Empty' + UseEscapeStr
      + '       Or Else Enter New Number.';
    Error := true;
  end
  else if not(isInt(DisplayValue)) then begin
    ErrorText := '      Trade Must Be a Number' + UseEscapeStr
      + '       Or Else Enter New Number.';
    Error := true;
  end
  else if StrToInt(DisplayValue) < 1 then begin
    ErrorText := '  Trade Number Must Be Positive' + UseEscapeStr
      + '       Or Else Enter New Number.';
    Error := true;
  end;
end;


procedure TfrmMain.cxGrid_22_WSHoldingDatePropertiesValidate(Sender: TObject;
  var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
var
  MyDateTime : TDateTime;
begin
  if TryStrToDateTime(VarToStr(DisplayValue), MyDateTime) then begin
    DisplayValue := DisplayValue;
  end
  else begin
    ErrorText := 'Please enter a valid date';
    Error := true;
    DisplayValue := DateToStr(TradeLogFile[cxGrid1TableView1.DataController.FocusedRecordIndex].WSHoldingDate, Settings.InternalFmt);
  end;
end;


procedure TfrmMain.cxGrid_2_DatePropertiesEditValueChanged(Sender: TObject);
begin
  renumFldChanged := true;
end;


procedure TfrmMain.cxGrid_2_DatePropertiesValidate(Sender: TObject;
  var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
var
  MyDateTime: TDate;
begin
  MyDateTime := cxGrid_2_Date.EditValue;
  begin
    // ----------------------------------------------------
    // test for date limitations
    if TradeLogFile.CurrentAccount.MTM
    and (MyDateTime > xStrToDate('12/31/' + TaxYear, Settings.InternalFmt)) then
      mDlg('Cannot enter a trade date greater than 12/31/' + taxyear
        +' in a ' + taxyear +' MTM file!', mtError, [mbOK], 0);
    // ----------------------------------------------------
    // if entering base line positions, date must be < Jan 1st, current tax year
    if EnteringBeginYearPrice then begin
      if TradeLogFile.CurrentAccount.MTM
      and TradeLogFile.CurrentAccount.MTMLastYear then begin
        if (MyDateTime <> xStrToDate('01/01/' + TaxYear, Settings.InternalFmt)) then begin
          // If MTM Account make sure that Date is Jan 1st
          ErrorText := 'When "Entering Base Line Positions" for an MTM Account where Last Year was also MTM the date must be 1/1/' + TaxYear + '.';
          Error := True;
          DisplayValue := dateToStr(xStrToDate('01/01/' + TaxYear, Settings.InternalFmt), Settings.UserFmt)
        end;
      end
      else if (MyDateTime > xStrToDate('12/31/' + LastTaxYear, Settings.InternalFmt)) then begin
        // If not MTMLastYear then make sure BeginYear Price date is in previous tax year
        ErrorText := 'When "Entering Base Line Positions" the date must be less than 1/1/' + TaxYear + '.' + CR + CR +
          'To enter transactions for the current tax year use "Add" instead of "Enter Baseline Positions".';
        Error := True;
        DisplayValue := dateToStr(xStrToDate('12/31/' + LastTaxYear, Settings.InternalFmt), Settings.UserFmt)
      end;
    end;
  end;
  // date was changed, so may need to renumber this ticker - 2016-11-04 MB
  glEditListTicks.add(TradeLogFile[cxGrid1TableView1.DataController.FocusedRecordIndex].Ticker);
end;


procedure TfrmMain.cxGrid_3_TimeGetDisplayText(Sender: TcxCustomGridTableItem;
  ARecord: TcxCustomGridRecord; var AText: string);
begin
  if AText <> '' then AText := GridTimeStr(AText, Settings.UserFmt);
end;


procedure TfrmMain.cxGrid_3_TimePropertiesEditValueChanged(Sender: TObject);
begin
  renumFldChanged := true;
end;


procedure TfrmMain.cxGrid_3_TimePropertiesValidate(Sender: TObject;
  var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
var
  MyDateTime: TDateTime;
begin
  if EnteringBeginYearPrice and TradeLogFile.CurrentAccount.MTM
  and TradeLogFile.CurrentAccount.MTMLastYear
  and (DisplayValue <> '00:00:00') then begin
    {If MTM Account make sure that Date is Jan 1st}
    ErrorText := 'When "Entering Base Line Positions" for an MTM Account ' + CR
      + 'where Last Year was also MTM the time must be 12 Midnight or 00:00:00';
    Error := True;
    DisplayValue := '00:00:00';
  end
  else if (Length(DisplayValue) > 0)
  and not TryStrToTime(VarToStr(DisplayValue), MyDateTime) then begin
    ErrorText := 'Please enter a valid time';
    Error := true;
    DisplayValue := TimeToStr(StrToTime('00:00'), Settings.UserFmt);
  end;
  // time was changed, so may need to renumber this ticker - 2016-11-04 MB
  glEditListTicks.add(TradeLogFile[cxGrid1TableView1.DataController.FocusedRecordIndex].Ticker);
end;


procedure TfrmMain.cxGrid_4_OCPropertiesEditValueChanged(Sender: TObject);
var
  OC, ls, ctype: string;
  Shares, Price, Comm, amount, mult: double;
begin
  OC := (TcxMaskEdit(Sender).EditValue);
  cxGrid_4_OC.EditValue := OC;
  ls := cxGrid_5_LS.EditValue;
  Shares := cxGrid_7_Shares.EditValue;
  Price := cxGrid_8_Price.EditValue;
  ctype := cxGrid_9_PRF.EditValue;
  Comm := cxGrid_10_Comm.EditValue;
  delete(ctype, 1, pos('-', ctype));
  if ctype <> '' then
    mult := StrToFloat(ctype, Settings.UserFmt)
  else
    mult := 1;
  if ((OC = 'O') and (ls = 'L'))
  or (((OC = 'C') or (OC = 'M')) and (ls = 'S')) then
    amount := -(Shares * Price * mult) - Comm
  else if (((OC = 'C') or (OC = 'M')) and (ls = 'L'))
  or ((OC = 'O') and (ls = 'S')) then
    amount := (Shares * Price * mult) - Comm
  else
    amount := 0;
  cxGrid_11_Amount.EditValue := amount;
  renumFldChanged := true;
end;


procedure TfrmMain.cxGrid_4_OCPropertiesValidate(Sender: TObject; var DisplayValue: Variant;
  var ErrorText: TCaption; var Error: Boolean);
begin
  if TradeLogFile.CurrentAccount.Ira and (DisplayValue = 'W') then begin
    ErrorText := 'Wash Sale Records cannot be entered for an IRA Account';
    Error := True;
    DisplayValue := 'O';
  end
  else if (Length(DisplayValue) = 0)
  or not (VarToStr(DisplayValue)[1] in ['W', 'O', 'C', 'M']) then begin
    ErrorText := 'Valid values for Open/Close field are: W - WS Deferral, O - Open, C - Close, M - MTM Close';
    Error := True;
    DisplayValue := 'O';
  end;
  // OC was changed, so may need to renumber this ticker - 2016-11-04 MB
  glEditListTicks.add(TradeLogFile[cxGrid1TableView1.DataController.FocusedRecordIndex].Ticker);
end;


procedure TfrmMain.cxGrid_5_LSPropertiesEditValueChanged(Sender: TObject);
var
  OC, ls, ctype: string;
  Shares, Price, Comm, amount, mult: double;
begin
  OC := cxGrid_4_OC.EditValue;
  ls := (TcxMaskEdit(Sender).EditValue);
  cxGrid_5_LS.EditValue := ls;
  Shares := cxGrid_7_Shares.EditValue;
  Price := cxGrid_8_Price.EditValue;
  ctype := cxGrid_9_PRF.EditValue;
  Comm := cxGrid_10_Comm.EditValue;
  delete(ctype, 1, pos('-', ctype));
  if ctype <> '' then
    mult := StrToFloat(ctype, Settings.UserFmt)
  else
    mult := 1;
  if ((OC = 'O') and (ls = 'L'))
  or (((OC = 'C') or (OC = 'M')) and (ls = 'S')) then
    amount := -(Shares * Price * mult) - Comm
  else if (((OC = 'C') or (OC = 'M')) and (ls = 'L'))
  or ((OC = 'O') and (ls = 'S')) then
    amount := (Shares * Price * mult) - Comm
  else
    amount := 0;
  cxGrid_11_Amount.EditValue := amount;
  renumFldChanged := true;
end;


procedure TfrmMain.cxGrid_5_LSPropertiesValidate(Sender: TObject; var DisplayValue: Variant;
  var ErrorText: TCaption; var Error: Boolean);
begin
  if (DisplayValue <> 'L')  and (DisplayValue <> 'S') then begin
    Error := True;
    ErrorText := 'Valid values for Long/Short field are ''L'' for Long or ''S'' for short';
  end;
  // LS was changed, so may need to renumber this ticker - 2016-11-04 MB
  glEditListTicks.add(TradeLogFile[cxGrid1TableView1.DataController.FocusedRecordIndex].Ticker);
end;


procedure TfrmMain.cxGrid_6_TickerPropertiesEditValueChanged(Sender: TObject);
begin
  renumFldChanged := true;
end;


procedure TfrmMain.cxGrid_6_TickerPropertiesValidate(Sender: TObject; var DisplayValue: Variant;
  var ErrorText: TCaption; var Error: Boolean);
begin
  if VarIsNull(DisplayValue) or (Length(DisplayValue) = 0)  then begin
    Error := True;
    ErrorText := 'Ticker cannot be blank; restoring previous value.';
    DisplayValue := TradeLogFile[cxGrid1TableView1.DataController.FocusedRecordIndex].Ticker;
  end
  else begin
    // Ticker was changed, so need to renumber this ticker - 2016-11-04 MB
    glEditListTicks.add(DisplayValue);
  end;
end;


procedure TfrmMain.cxGrid_16_opTkPropertiesEditValueChanged(Sender: TObject);
begin
  renumFldChanged := true;
end;


procedure TfrmMain.cxGrid_16_brGetDisplayText(Sender: TcxCustomGridTableItem;
  ARecord: TcxCustomGridRecord; var AText: string);
begin
  if isInt(AText) then
    if TradeLogFile.FileHeader[StrToInt(AText)] <> nil then
      AText := TradeLogFile.FileHeader[StrToInt(AText)].AccountName;
end;


procedure TfrmMain.cxGrid_19_StrategyPropertiesEditValueChanged(Sender: TObject);
var
  strategy: string;
begin
  strategy := (TcxTextEdit(Sender).EditValue);
  if strategy = 'None' then strategy := EmptyStr;
  cxGrid_19_Strategy.EditValue := strategy;
  renumFldChanged := true;
end;


procedure TfrmMain.cxGrid_7_SharesPropertiesEditValueChanged(Sender: TObject);
begin
  renumFldChanged := true;
end;


procedure TfrmMain.cxGrid_7_SharesPropertiesValidate(Sender : TObject; var DisplayValue : Variant;
  var ErrorText : TCaption; var Error : Boolean);
var
  ClickedOK : Boolean;
  tmp : string;
begin
  if VarIsNull(DisplayValue) //
  or (DisplayValue = '') //
  or (abs(strtofloat(DisplayValue)) = 0) //
  then begin
    ClickedOK := myInputQuery('Shares cannot be empty or zero.', //
      'Please correct it now:', tmp, frmMain.Handle, false);
    if not ClickedOK then
      DisplayValue := TradeLogFile[cxGrid1TableView1.DataController.FocusedRecordIndex].Shares
    else
      DisplayValue := UpperCase(tmp);
  end;
  // #Shares changed, so may need to renumber this ticker - 2016-11-04 MB
  glEditListTicks.add(TradeLogFile[cxGrid1TableView1.DataController.FocusedRecordIndex].Ticker);
end;


procedure TfrmMain.cxGrid_8_PricePropertiesEditValueChanged(Sender: TObject);
var
  OC, ls, ctype: string;
  Shares, Price, Comm, amount, mult: double;
begin
  OC := cxGrid_4_OC.EditValue;
  ls := cxGrid_5_LS.EditValue;
  Shares := cxGrid_7_Shares.EditValue;
  Price := (TcxMaskEdit(Sender).EditValue);
  cxGrid_8_Price.EditValue := Price;
  ctype := cxGrid_9_PRF.EditValue;
  Comm := cxGrid_10_Comm.EditValue;
  delete(ctype, 1, pos('-', ctype));
  if ctype <> '' then
    mult := StrToFloat(ctype, Settings.UserFmt)
  else
    mult := 1;
  // end if
  if ((OC = 'O') and (ls = 'L'))
  or (((OC = 'C') or (OC = 'M')) and (ls = 'S')) then
    amount := -(Shares * Price * mult) - Comm
  else if (((OC = 'C') or (OC = 'M')) and (ls = 'L'))
  or ((OC = 'O') and (ls = 'S')) then
    amount := (Shares * Price * mult) - Comm
  else
    amount := 0;
  cxGrid_11_Amount.EditValue := amount;
end;


procedure TfrmMain.cxGrid_8_PricePropertiesValidate(Sender: TObject;
  var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
var
  ClickedOK : Boolean;
  tmp : string;
begin
  if VarIsNull(DisplayValue) or (DisplayValue = '') then begin
    ClickedOK := myInputQuery('Price cannot be blank.', //
        'Please enter a new price, or' + CR //
      + 'Cancel to keep current price:', tmp, frmMain.Handle, true);
    if not ClickedOK then
      DisplayValue := TradeLogFile[cxGrid1TableView1.DataController.FocusedRecordIndex].Price
    else begin
      DisplayValue := UpperCase(tmp);
    end;
  end;
end;


procedure TfrmMain.cxGrid_9_PRFPropertiesEditValueChanged(Sender: TObject);
begin
  renumFldChanged := true;
end;


procedure TfrmMain.cxGrid_9_PRFPropertiesValidate(Sender : TObject; var DisplayValue : Variant;
  var ErrorText : TCaption; var Error : Boolean);
var
  s : string;
  I : Integer;
  TypeList, multStr, TypeMult : string;
  ClickedOK : Boolean;
  mult : Double;
  tmp : string;
begin
  // get ticker
  s := Trim(cxGrid_6_Ticker.EditValue);
  // --------------------------------------------
  // make sure options get entered as OPT or FUT (broad-based)
  if (pos(' PUT', s)> 0) or (pos(' CALL', s)> 0) then begin
    if (pos('OPT', DisplayValue)= 0) // not an OPT
    and (pos('FUT', DisplayValue)= 0) // or a FUT (BBIO)
    then begin
      sm('You have entered an option, ' + cr //
        + 'therefore type must be "OPT"' + cr //
        + 'or "FUT" if this is a broad based index option.');
    end;
    TypeMult := futures_index(s);
    // 2014-08-25 - allow options multipliers to be other than 100
    if (TypeMult <> 'OPT-100') then
      DisplayValue := TypeMult;
  end
  // --------------------------------------------
  // if this is an option, check if broad-based
  else if (pos('OPT', DisplayValue) = 1) then begin
    // make sure we got something
    if (Length(s) > 0) then begin
      TypeMult := futures_index(s);
      if (TypeMult <> 'OPT-100') then begin
        DisplayValue := TypeMult;
        sm('This is a Broad-Based Index option' + cr //
          + 'therefore type must be "FUT"');
      end;
    end;
  end
  // --------------------------------------------
  // If this is a future, then ask for a multiplier
  else if Length(DisplayValue) < 5 then begin
    if (pos('FUT', DisplayValue) > 0) then begin
      ClickedOK := myInputQuery('Future contract multiplier',
        'Enter multiplier for future contract:', multStr, frmMain.Handle, True);
      if not ClickedOK then
        DisplayValue := TradeLogFile[cxGrid1TableView1.DataController.FocusedRecordIndex].TypeMult
      else begin
        DisplayValue := DisplayValue + multStr;
      end;
    end;
  end;
  // --------------------------------------------
  // OK now check that the multiplier is in the global futures list.
  if (pos('FUT', DisplayValue) > 0) and (pos(' CALL', cxGrid_6_Ticker.EditValue)= 0) and
    (pos(' PUT', cxGrid_6_Ticker.EditValue)= 0) then begin
    multStr := DisplayValue;
    delete(multStr, 1, pos('-', multStr));
    mult := UpdateFutureList(cxGrid_6_Ticker.EditValue, multStr);
    if mult <> 0 then
      DisplayValue := 'FUT-' + FloatToStr(mult, Settings.InternalFmt);
  end;
  // --------------------------------------------
  // Verify that the display value is formatted correctly
  // Must have a dash between type and multiplier
  if pos('-', DisplayValue) = 0 then begin
//    ErrorText :=
//      'Type Multiplier must be in the format TYPE-MULTIPLIER, but there is no dash in your entry';
//    Error := True;
//    exit;
    ClickedOK := myInputQuery('Type Multiplier must be in the format TYPE-MULTIPLIER',
      'but there is no dash in your entry. Please correct it now:', multStr, frmMain.Handle, False);
    if not ClickedOK then
      DisplayValue := TradeLogFile[cxGrid1TableView1.DataController.FocusedRecordIndex].TypeMult
    else begin
      DisplayValue := Uppercase(multStr);
    end;
  end
  // --------------------------------------------
  else begin
    // Must have a multiplier that is a number
    s := VarToStr(DisplayValue);
    delete(s, 1, pos('-', s));
    if not IsFloat(s) then begin
      ClickedOK := myInputQuery('Multiplier cannot be blank.', //
        'Please enter it now (or cancel for 100):', tmp, frmMain.Handle, false);
      if not ClickedOK then
        DisplayValue := 'FUT-100'
      else
        DisplayValue := 'FUT-' + tmp;
      exit;
    end;
    if s = '0' then begin
      ClickedOK := myInputQuery('Multiplier cannot be zero.', //
        'Please enter it now (or cancel for 1):', tmp, frmMain.Handle, false);
      if not ClickedOK then
        DisplayValue := 'FUT-1'
      else
        DisplayValue := 'FUT-' + tmp;
      exit;
    end;
  end;
  // --------------------------------------------
  // Finally make sure the type is from the list
  s := leftStr(VarToStr(DisplayValue), pos('-', DisplayValue)- 1);
  TypeList := '';
  // --------------------------------------------
  for I := 0 to TcxComboBox(Sender).properties.Items.Count - 1 do begin
    if Length(TypeList) > 0 then
      TypeList := TypeList + ', ';
    TypeList := TypeList + leftStr(TcxComboBox(Sender).properties.Items[I], 3);
  end;
  // --------------------------------------------
  if pos(s, TypeList) = 0 then begin
    ErrorText := 'Type portion must be in the following supported list: ' + TypeList;
    Error := True;
    exit;
  end;
  // --------------------------------------------
  // PRF was changed, so may need to renumber this ticker - 2016-11-04 MB
  glEditListTicks.add(TradeLogFile[cxGrid1TableView1.DataController.FocusedRecordIndex].Ticker);
end;


procedure TfrmMain.cxHintShowHint(Sender: TObject; var HintStr: string;
  var CanShow: Boolean; var HintInfo: THintInfo);
begin
  moduleHints.ShowHint(HintStr, CanShow, HintInfo);
end;


procedure TfrmMain.cxGrid_10_CommGetDisplayText(Sender: TcxCustomGridTableItem;
  ARecord: TcxCustomGridRecord; var AText: string);
begin
  GridCurrStr(AText);
end;


procedure TfrmMain.cxGrid_10_CommPropertiesEditValueChanged(Sender: TObject);
var
  OC, ls, ctype: string;
  Shares, Price, Comm, amount, mult: double;
begin
  OC := cxGrid_4_OC.EditValue;
  ls := cxGrid_5_LS.EditValue;
  Shares := cxGrid_7_Shares.EditValue;
  Price := cxGrid_8_Price.EditValue;
  ctype := cxGrid_9_PRF.EditValue;
  Comm := (TcxMaskEdit(Sender).EditValue);
  if Comm < 0 then begin
    sm('Commission should be entered as a positive number' + cr //
      + 'unless you are getting a commission credit or rebate.');
  end;
  cxGrid_10_Comm.EditValue := Comm;
  delete(ctype, 1, pos('-', ctype));
  if ctype <> '' then
    mult := StrToFloat(ctype, Settings.UserFmt)
  else
    mult := 1;
  //
  if ((OC = 'O') and (ls = 'L')) //
  or (((OC = 'C') or (OC = 'M')) and (ls = 'S')) then
    amount := -(Shares * Price * mult) - Comm
  else if (((OC = 'C') or (OC = 'M')) and (ls = 'L')) //
  or ((OC = 'O') and (ls = 'S')) then
    amount := (Shares * Price * mult) - Comm
  else
    amount := 0;
  cxGrid_11_Amount.EditValue := amount;
end;


procedure TfrmMain.cxGrid_10_CommPropertiesValidate(Sender: TObject;
  var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
var
  Comm: double;
begin
  if (DisplayValue = '') then DisplayValue := '0';
  Comm := (TcxMaskEdit(Sender).EditValue);
end;


procedure TfrmMain.cxGrid_11_AmountPropertiesEditValueChanged(Sender: TObject);
var
  OC, ls, ctype: string;
  Shares, Price, Comm, amount, mult: double;
begin
  // sm('onEditValueChanged');
  OC := cxGrid_4_OC.EditValue;
  ls := cxGrid_5_LS.EditValue;
  Shares := cxGrid_7_Shares.EditValue;
  Price := cxGrid_8_Price.EditValue;
  ctype := cxGrid_9_PRF.EditValue;
  Comm := cxGrid_10_Comm.EditValue;
  amount := (TcxMaskEdit(Sender).EditValue);
  delete(ctype, 1, pos('-', ctype));
  if ctype <> '' then
    mult := StrToFloat(ctype, Settings.UserFmt)
  else
    mult := 1;
  //
  if ((OC = 'O') and (ls = 'L'))
  or (((OC = 'C') or (OC = 'M')) and (ls = 'S')) then begin
    if amount > 0 then begin
      amount := -amount;
      TcxMaskEdit(Sender).EditValue := amount;
    end;
    Comm := -amount - (Shares * Price * mult);
  end
  else if (((OC = 'C') or (OC = 'M')) and (ls = 'L'))
  or ((OC = 'O') and (ls = 'S')) then begin
    if amount < 0 then begin
      amount := -amount;
      TcxMaskEdit(Sender).EditValue := amount;
    end;
    Comm := (Shares * Price * mult) - amount;
  end;
  cxGrid_10_Comm.EditValue := Comm;
  cxGrid_11_Amount.EditValue := amount;
  if Comm < 0 then sm('Amount makes Comm negative');
end;


procedure TfrmMain.cxGrid_11_AmountPropertiesValidate(Sender: TObject;
  var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
var
  ClickedOK : Boolean;
  tmp : string;
begin
  if VarIsNull(DisplayValue)
  or (DisplayValue = '')
  then begin
    ClickedOK := myInputQuery('Amount cannot be empty.', //
      'Please correct it, or click' + CR //
      +'Cancel to abort change:', tmp, frmMain.Handle, true);
    if not ClickedOK then
      DisplayValue := TradeLogFile[cxGrid1TableView1.DataController.FocusedRecordIndex].Amount
    else
      DisplayValue := UpperCase(tmp);
  end;
end;


procedure TfrmMain.cxGrid_12_PLGetDisplayText(Sender: TcxCustomGridTableItem;
  ARecord: TcxCustomGridRecord; var AText: string);
begin
  GridCurrStr(AText);
end;


procedure TfrmMain.cxGrid_13_NotesGetCellHint(Sender: TcxCustomGridTableItem;
  ARecord: TcxCustomGridRecord; ACellViewInfo: TcxGridTableDataCellViewInfo;
  const AMousePos: TPoint; var AHintText: TCaption; var AIsHintMultiLine: Boolean;
  var AHintTextRect: TRect);
var
  ACanvas : TControlCanvas;
  X : Integer;
  CellValue : String;
begin
  ACanvas := TControlCanvas.Create;
  try
    TControlCanvas(ACanvas).Control := cxGrid1;
    ACanvas.Font.Assign(cxGrid1.Font);
    CellValue := VarToStr(ARecord.Values[Sender.Index]);
    X := ACanvas.TextWidth(CellValue);
    if (X > ACellViewInfo.Bounds.Right - ACellViewInfo.Bounds.Left) then
    begin
      AHintText := MakeMultiLine(CellValue, 50);
      AIsHintMultiLine := (Length(AHintText) > 50) ;
    end;
  finally
    ACanvas.Free;
  end;
end;


procedure TfrmMain.pnl1099Exit(Sender: TObject);
begin
  spdRunReport.Enabled := true;
end;


procedure TfrmMain.pupAccountPopup(Sender: TObject);
begin
  Application.CancelHint;
end;


procedure TfrmMain.DeleteALLRecords1Click(Sender: TObject);
begin
  DeleteAll1.Click;
end;


procedure TfrmMain.DigCur1Click(Sender: TObject);
begin
  FilterByType('DCY', True); // 2018-02-22 MB - New Find type
end;


procedure TfrmMain.DisableMenuToolsAll;
var
  I: integer;
begin
  //disable toolbar
  for I := 0 to ToolBar1.ControlCount - 1 do
    ToolBar1.Controls[i].Enabled := false;
  SetPopupMenuEnabled(pupEdit, False);
  SetPopupMenuEnabled(pupView, False);
  SetPopupMenuEnabled(pupFind, False);
  tabAccounts.Enabled := False;
end;


// ------------------------------------
// are there any records which look like Ex/As?
// ------------------------------------
procedure TfrmMain.DiscoverExerciseAssigns;
var
  ExerciseDiscovery: TExerciseAssign;
  Frm: TfrmExerciseAssign;
begin
  TradeLogFile.ShowStatus := False;
  statBar('Discovering Exercise Assigns');
  Screen.Cursor := crHourGlass;
  try
    ExerciseDiscovery := TExerciseAssign.Create;
    ExerciseDiscovery.DiscoverUnexercisedOptions;
    if ExerciseDiscovery.Count > 0 then begin
      // ---- Show the Exercise/Assign panel ----
      Frm := TfrmExerciseAssign.Create(Self, ExerciseDiscovery);
      Frm.Parent := pnlMain;
      Frm.align := alBottom;
      Frm.show;
      Splitter2.Visible := true;
      Splitter2.Top := Frm.Top - 10;
      cxGrid1TableView1.DataController.clearSelection;
      Frm.cxGrid1TableView1.DataController.FocusedRowIndex := 0;
      //sm('DiscoverExerciseAssigns');
      statBar('off');
    end
    else begin
      statBar('off');
      clearFilter;
      mDlg('Did not find any options that need to be assigned!', mtInformation, [mbOK], 0);
    end;
  finally
    Screen.Cursor := crDefault;
    TradeLogFile.ShowStatus := true;
  end;
end;


procedure TfrmMain.Display8949CodeClick(Sender: TObject);
begin
  Settings.Disp8949Code := TMenuItem(Sender).checked;
  SetOptions;
end;


procedure TfrmMain.DisplayMatchedTaxLots1Click(Sender: TObject);
begin
  Settings.DispMTaxLots := TMenuItem(Sender).checked;
  SetOptions;
end;

procedure TfrmMain.DisplayNotesClick(Sender: TObject);
begin
  Settings.DispNotes := TMenuItem(Sender).checked;
  SetOptions;
end;

procedure TfrmMain.DisplayOptionTickers1Click(Sender: TObject);
begin
  Settings.DispOptTicks := TMenuItem(Sender).checked;
  SetOptions;
end;

procedure TfrmMain.DisplayStrategies1Click(Sender: TObject);
begin
  Settings.DispStrategies := TMenuItem(Sender).checked;
  SetOptions;
end;

procedure TfrmMain.DisplayTime1Click(Sender: TObject);
begin
  Settings.DispTimeBool := TMenuItem(Sender).checked;
  SetOptions;
end;

procedure TfrmMain.DisplayWashSaleHoldingDate1Click(Sender: TObject);
begin
  Settings.DispWSHolding := TMenuItem(Sender).checked;
  SetOptions;
end;

procedure TfrmMain.DisplayWashSalesClick(Sender: TObject);
begin
  Settings.DispWSdefer := TMenuItem(Sender).checked;
  SetWSDefer;
  SetOptions;
end;

procedure TfrmMain.ToggleShortLongorLongShort1Click(Sender: TObject);
begin
  ToggleShortLong;
end;

//procedure TfrmMain.findGridFilter1Click(Sender: TObject);
//begin
//  findStocksDlg;
//end;

procedure TfrmMain.FindAllStocks1Click(Sender: TObject);
begin
  DoStocks('STK');
end;

procedure TfrmMain.FindAllOptions1Click(Sender: TObject);
begin
  DoStocks('OPT');
end;

procedure TfrmMain.FindAllSingleStockFutures1Click(Sender: TObject);
begin
  DoStocks('SSF');
end;

procedure TfrmMain.Currencies1Click(Sender: TObject);
begin
  filterByType('CUR', True);
end;

procedure TfrmMain.FindAllFutures1Click(Sender: TObject);
begin
  DoFutures;
end;

procedure TfrmMain.AllStocksandOptionsandSSFs1Click(Sender: TObject);
begin
  DoStocks;
end;

// ------------------------------------
procedure TfrmMain.actnShowRangeClick(Sender: TObject);
var
  I, TaxYrIndex: Integer;
  StartYr, EndYr, Year, Month, Day: Word;
  startDt, endDt: Tdate;
begin
  try
    if (TradeLogFile.Count = 0) then exit;
    //btnShowAll.Click;
    if TradeLogFile.Count > 0 then begin
      DecodeDate(TradeLogFile.EarliestDate, StartYr, Month, Day);
      startDt := TradeLogFile.EarliestDate;
    end
    else begin
      StartYr := TradeLogFile.TaxYear;
      startDt := xStrToDate('01/01/' + IntToStr(TradeLogFile.TaxYear), Settings.InternalFmt);
    end;
    endDt := TradeLogFile.LastDateImported;
    DecodeDate(TradeLogFile.LastDateImported, Year, Month, Day);
    EndYr := Year;
    if startDt > endDt then startDt := endDt;
    TaxYrIndex := 0;
    // RangeSelect:= true;
    with frmRangeSelect do begin
      cboYear.properties.Items.Clear;
      for I := StartYr to EndYr do begin
        if intToStr(I) = TaxYear then
          TaxYrIndex := cboYear.properties.Items.Count;
        cboYear.properties.Items.Add(intToStr(I));
      end;
      cboYear.ItemIndex := TaxYrIndex;
      with calTo do begin
        if (date > endDt) or (date < startDt) then date := endDt;
      end;
      with CalFrom do begin
        if (date > endDt) or (date < startDt) then date := startDt;
      end;
      Top := frmMain.Top + 46;
      Left := frmMain.Left + 116;
      Height := pnlCalendar.Height + pnlyear.Height + pnlOK.Height + 41;
      if ShowModal = mrOK then begin
        repaintGrid;
        TradesSummary.Enabled := true;
        btnShowRange.Down := true;
        btnShowAll.Down := False;
      end
    end;
  finally
    // actnShowRangeClick
  end;
end;


procedure TfrmMain.actnFilterCustomClick(Sender: TObject);
var
  LastDate: Tdate;
  Success : Boolean;
  BrokerStr : String;
  FilterStr : String;
begin
  ResetFilterCombobox('');
  try
    Success := False;
    ReadFilter;
    FilterStr := cxGrid1TableView1.DataController.Filter.FilterCaption;
    if TabAccounts.TabIndex = 0 then
      BrokerStr := ''
    else
      BrokerStr := 'Broker Account = ' + tabAccounts.Tabs[tabAccounts.TabIndex].Caption;
    // ------------
    cxGrid1TableView1.filtering.RunCustomizeDialog(nil);
    if frmMain.cxGrid1TableView1.DataController.Filter.FilterCaption <> FilterStr then
    begin
      // If they are on a tab they cannot remove the broker filter line,
      // if they do Just add it back.
      Success := (TabAccounts.TabIndex = 0)
        or ((tabAccounts.TabIndex > 0)
        and (pos(BrokerStr, frmMain.cxGrid1TableView1.DataController.Filter.filterCaption) > 0));
      if Not Success then
        filterByBrokerAcct(TradeLogFile.CurrentBrokerID, TradeLogFile.CurrentAccount.AccountName);
      GridFilter := gfFilter;
      SpeedButtonsUp;
    end;
    //They have removed the WSDefer filter so turn on the setting to keep it in sync.
    if (Pos('O/C <> W', FilterStr) > 0)
    and (Pos('O/C <> W', frmMain.cxGrid1TableView1.DataController.Filter.filterCaption) = 0) then
    begin
       mDlg('Wash Sale Filter removed, Now displaying Wash Sales', mtInformation, [mbOK], 0);
       DisplayWashSales1.Checked := True;
       Settings.DispWSDefer := True;
    end;
    repaintGrid;
    LastDate := TradeLogFile.LastDateImported;
    TcxDateEditProperties(frmMain.cxGrid1TableView1.Items[2].properties).maxDate := LastDate;
  finally
    // actnFilterCustomClick
  end;
end;


procedure TfrmMain.cxGrid1TableView1DataControllerFilterChanged(Sender: TObject);
var
  S : String;
begin
  screen.cursor := crHourGlass;
  SpeedButtonsUp;
  S := GetFilterCaption;
  if Length(S) = 0 then begin
//    try
      pnlFilter.Visible := False;
//    except
//      sm('error');
//    end;
    lbFilter.Text := '';
  end
  else begin
    pnlFilter.Visible := True;
    lbFilter.Text := S;
  end;
  if (pos('Sorting', stMessage.Caption) > 0)
  or (pos('Matching', stMessage.Caption) > 0) then begin
    Screen.Cursor := crDefault; // MB - don't exit w/o setting it back!
    exit;
  end;
  repaintGrid;
  if (pos('Ticker', cxGrid1TableView1.DataController.Filter.filterText) > 0)
  and (txtSharesOpen.Font.color <> clRed) and (txtContrOpen.Font.color <> clRed)
  and panelMsg.HasTradeIssues then
    panelMsg.hide;
  // NOTE: This procedure ends with the screen.cursor := crHourglass!
end;


procedure TfrmMain.cxGrid1TableView1DataControllerFilterRecord(ADataController: TcxCustomDataController;
  ARecordIndex: Integer; var Accept: Boolean);
begin
  //
end;


procedure TfrmMain.cxGrid1TableView1ColumnHeaderClick(Sender: TcxGridTableView; AColumn: TcxGridColumn);
begin
  cxGrid1TableView1.DataController.focusedRecordIndex := -1;
  if AColumn = cxGrid1TableView1.Columns[6] then
    SortByTicker
  else if AColumn = cxGrid1TableView1.Columns[15] then
    SortByMatched;
end;


procedure TfrmMain.cxGrid1TableView1CustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
var
  RecIdx,
  RowIdx,
  ColIdx,
  LastRecIdx : Integer;
  BackgroundColor : TColor;
begin
  if HaltCustomDrawing then exit;
  // This method uses a TObjectDictionary to keep track of the colors for each
  // Record. When on row zero we clear the RowColors list and start with
  // clWhite; Subsequent rows will lookup the color of the LastRecord and if
  // the TrNum changes, will toggle from White to tlGreen, Trade Log's Green
  // color. The ObjectDictionary will be updated for each Record displayed so
  // that we always have the White/Green look in the grid no matter how
  // the grid is filtered.
  // --------------------
  // The Record Index of the record in TradeLogFile}
  RecIdx := AViewInfo.GridRecord.RecordIndex;
  // The row Index of the current Row, Different from the Record Index
  // based on Filtering and sorting, etc.
  RowIdx := AViewInfo.GridRecord.Index;
  // The Column Index of the column being drawn
  ColIdx := AViewInfo.Item.Index;
  // Record is out of range, don't think this will ever happen,
  // but since it was in the previous code maybe it is needed
  if RowIdx > cxGrid1TableView1.DataController.RecordCount - 1 then exit;
  // First Rows always use clWhite, Clear Row Colors if on Column 1 and
  // Add record index with clwhite
  if (RowIdx = 0)  then begin
    // If we are on the first row, then always use white
    BackgroundColor := clWhite;
    if ColIdx = 1 then begin
      RowColors.Clear;
      RowColors.Add(RecIdx, clWhite);
    end;
  end
  else begin
    // We are on any other row
    // Get Record Index of previous Row
    LastRecIdx := cxGrid1TableView1.DataController.GetRowInfo(RowIdx - 1).RecordIndex;
    // Get Color associated with Previous Record
    // If this record does not exist in the dictionary, default to white
    if not RowColors.TryGetValue(LastRecIdx, BackgroundColor) then
      BackGroundColor := clWhite;
    // If TradeNumber differs from previous row, toggle color
    if (cxGrid1TableView1.DataController.Values[LastRecIdx, 1] <> AViewInfo.GridRecord.Values[1]) then
    begin
      if BackgroundColor = clWhite then
        BackgroundColor := FGridEven
      else
        BackgroundColor := clWhite;
    end;
    {Write new color to Dictionary, If this record already exists then we update the value otherwise
      this method will add a new dictionary item}
    RowColors.AddOrSetValue(RecIdx, BackgroundColor);
  end;
  {Set the colors based on our decisions above,
    also if the row is selected set the selected record color}
  ACanvas.Font.color := clBlack;
  if (AViewInfo.GridRecord.Selected) then begin
    ACanvas.Brush.color := clBtnFace;
    ACanvas.Font.Style := [fsBold];
  end
  else ACanvas.Brush.Color := BackGroundColor;
  {If the PL Amount is less than zero then use red for the font color}
  if (ColIdx = 12) and (AViewInfo.Value < 0) then
    ACanvas.Font.color := clRed; //PL is less than zero
 {If we are Getting Current Prices, and this is the Close Record then use Beige as the back color}
 if cxGrid1TableView1.DataController.CustomDataSource = OpenTradeRecordsSource
 then begin
   if (AViewInfo.GridRecord.Values[4{OC}] = 'C')
   and (AViewInfo.GridRecord.Values[12{PL}] = 0) then
     ACanvas.Brush.color := tlBeige;
 end; // if cxGrid1TableView1
end;


procedure TfrmMain.FormResize(Sender: TObject);
begin
  stMessage.Width := frmMain.Width - 14;
  pnlDoReport.Left := frmMain.Width - pnlDoReport.Width - 30;
  pnlDoReport.Top := 6;
  if IsFormVisible('frmWebBrowserPopup') then begin
    frmWebBrowserPopup.Width := ClientWidth;
    frmWebBrowserPopup.Height := ClientHeight - statusBar.Height;
  end;
  StatusBar.Visible := false; // RJ Jan 1, 2021
end;


procedure TfrmMain.glEndDatePropertiesEditValueChanged(Sender: TObject);
begin
  if LoadingRecs then exit;
end;


procedure TfrmMain.glEndDatePropertiesValidate(Sender: TObject;
  var DisplayValue: Variant; var ErrorText: TCaption;
  var Error: Boolean);
var
  thisDay, startDay: Tdate;
begin
  with glEndDate do begin
    if DisplayValue <> '' then begin
      thisDay := xStrToDate(DisplayValue, Settings.UserFmt);
      startDay := xStrToDate(glStartDate.Text, Settings.UserFmt);
      if thisDay <= startDay then begin
        sm('END date must be Greater than START date');
        thisDay := IncDay(startDay, 1);
        if thisDay < properties.minDate then
          date := properties.minDate
        else
          date := thisDay;
      end
      else if date < properties.minDate then begin
        properties.minDate := date;
      end
      else if date > properties.maxDate then begin
        properties.maxDate := date;
      end
      else exit; // if thisDay... else
    end
    else date := properties.maxDate; // if DisplayValue... else
    glEndDate.Text := dateToStr(date, Settings.UserFmt);
    ErrorText := '';
    Error := true;
  end; // with
end;


procedure TfrmMain.GlobalOptions1Click(Sender: TObject);
begin
  if TfrmOptionDlg.Execute = mrOK then begin
    try
      screen.cursor := crHourGlass;
      statBar('Saving Trade Type Settings');
      readFilter;
      SetOptions;
      SetWSDefer;
      // applies the changes to the trades
      applyChangesToMultipliers(true);
      dispProfit(True, 0, 0, 0, 0);
    finally
      statBar('off');
      screen.cursor := crDefault;
    end;
  end;
end;


function EnumWindowsFunc(Handle: THandle; List: TStringList): Boolean; stdcall;
var
  Caption: array [0 .. 256] of Char;
begin
  if (GetWindowText(Handle, Caption, sizeOf(Caption) - 1) <> 0) then
    List.Add(Caption);
  Result := true;
end;


function findMultWindows(Title: string; winTitles: TStringList): Boolean;
var
  I: Integer;
  winTitlesAll: TStringList;
begin
  winTitlesAll := TStringList.Create;
  try
    winTitlesAll.Clear;
    EnumWindows(@EnumWindowsFunc, lParam(winTitlesAll));
    for I := 0 to winTitlesAll.Count - 1 do begin
      if winTitlesAll[I] = Title then winTitles.Add(winTitlesAll[I]);
    end; // for
  finally
    winTitlesAll.Free;
  end;
end;


procedure TfrmMain.tmrFileDLTimer(Sender: TObject);
var
  C, s, F, W, H, TL: hWnd;
  E, I: Integer;
  winTitles: TStringList;
begin
  C := 0;
  s := 0;
  F := 0;
  H := 0;
  TL := 0;
  winTitles := TStringList.Create;
  try
    if (TradeLogFile.CurrentAccount.FileImportFormat = 'Charles Schwab')
    or (TradeLogFile.CurrentAccount.FileImportFormat = 'Scottrade')
    or (TradeLogFile.CurrentAccount.FileImportFormat = 'TOS')
    or (TradeLogFile.CurrentAccount.FileImportFormat = 'Fidelity') then begin
      C := findWindow(nil, 'Download Complete');
      s := findWindow(nil, 'Save As');
      F := findWindow(nil, 'File Download');
      if (C > 0) and (s = 0) and (F = 0) then begin
        tmrFileDL.Enabled := False;
        // test for multiple File Download windows
        findMultWindows('Download Complete', winTitles);
        if winTitles.Count > 1 then begin
          SimulateKeystroke(VK_CANCEL, 0);
          repaintGrid;
          frmWeb.close;
          sm('Please close any other "Download Complete" dialog boxes and retry');
          exit;
        end;
        // close Download Complete dialog
        E := SendMessage(C, WM_CLOSE, 0, 0);
        sleep(200);
        frmWeb.close;
      end
      else if (s > 0) and (C = 0) and (F = 0) then begin
        tmrFileDL.Enabled := False;
        // test for multiple Save As windows
        findMultWindows('Save As', winTitles);
        if winTitles.Count > 1 then begin
          SimulateKeystroke(VK_CANCEL, 0);
          frmWeb.close;
          sm('Please close any other "File Save" dialog boxes and retry');
          exit;
        end;
        if FileExists(Settings.ImportDir + '\download.csv') then
          DeleteFile(Settings.ImportDir + '\download.csv');
        // send keys to file Save As box
        if (TradeLogFile.CurrentAccount.FileImportFormat = 'TOS') then
          mySendKeys(Settings.ImportDir + '\TOS-ExportData.txt')
        else
          mySendKeys(Settings.ImportDir + '\download.csv');
        SimulateKeystroke(vk_Return, 0);
        // test if Download Complete dialog box option is enabled in Windows
        if (Settings.NotifyDownloadComplete = 'yes') then
          tmrFileDL.Enabled := true
        else begin
          tmrFileDL.Enabled := False;
          sleep(200);
          frmWeb.close;
        end;
      end
      else if F > 0 then begin
        // test for multiple File Download windows
        findMultWindows('File Download', winTitles);
        if winTitles.Count > 1 then begin
          SimulateKeystroke(VK_CANCEL, 0);
          frmWeb.close;
          sm('Please close any other "File Download" dialog boxes and retry');
          exit;
        end;
        // send keys to file download box
        E := SendMessage(F, WM_SETFOCUS, 0, 0);
        mySendKeys('s');
      end
      else begin
        tmrFileDL.Enabled := true;
      end;
    end;
  finally
    winTitles.Free;
  end;
end;


procedure TfrmMain.Ticker1Click(Sender: TObject);
var
  Tick : String;
begin
  frmInput.display('Find Ticker',
      'Enter Tickers To Find:' + cr +
      '(* = wildcard): '+cr+cr+
      'Examples:'+cr+
      'DELL  or  D*'+cr+
      'or  A-F'+cr+
      'or  AOL, DELL, MSFT )', '', True);
  if frmInput.inputStr = '' then exit;
  Tick:= uppercase(frmInput.inputStr);
  ClearFilter;
  ResetFilterCombobox('');
  filterByTick(Tick);
  repaintGrid;
end;


procedure TfrmMain.Timer1Timer(Sender: TObject);
var
  sDir, sFile1, suptName, sUploadFile, text : string;
  p : integer;
  // ------------------------
  procedure SaveDiagnostics(sFile : string);
  var
    s, s2 : string;
    myFile : TextFile;
  begin
    s2 := 'login: ' + v2LoginStatus;
    s := dEncrypt(s2, '');
    text := 'Diagnostics data: ' + s;
    AssignFile(myFile, sFile);
    try
      Rewrite(myFile);
      WriteLn(myFile, text);
    finally
      CloseFile(myFile);
    end;
  end;
  // ------------------------
begin
  Timer1.Enabled := false; // one time only
  if gbUpdateNow then begin
    UpdateTradeLogExe(false);
    Screen.Cursor := crDefault; // need to reset cursor!
    bCancelLogin := true; // closes main form and exits application
  end;
  if gbGetSupportNow then begin
    suptName := panelSplash.txtRegUser.Caption;
    p := pos(' ', suptName);
    while p > 0 do begin
      delete(suptName, p, 1);
      insert('_', suptName, p);
      p := pos(' ', suptName);
    end;
//    sUploadFile := suptName + FormatDateTime('-yyyyMMdd-hhnnss', now);
    // ----------------------------------
    sFile1 := Settings.LogDir + '\diagnostics.txt';
    SaveDiagnostics(sFile1);
    screen.Cursor := crDefault; // to be sure
  end;
  if bCancelLogin then begin
    frmMain.Close;
  end;
  if AlreadyLoaded then exit;
  // ------------
  if not Developer then begin // not during development, though
//    GetOSInfo; // 2025.07.17 MDB
  end;
  // --------------
  OpenFilePassedIn; // was a file passed in?
  // ------------
  if (Settings.ReadGetStarted = 'T') then begin
    frmGetStarted.showmodal; // display "What's New"
  end;
end;


procedure TfrmMain.TrNum1Click(Sender: TObject);
begin
  ClearFilter;
  ResetFilterCombobox('');
  filterByTrNum('');
  repaintGrid;
end;


procedure TfrmMain.Short1Click(Sender: TObject);
begin
  ClearFilter;
  filterByLS('S');
  repaintGrid;
end;


procedure TfrmMain.Long1Click(Sender: TObject);
begin
  ClearFilter;
  filterByLS('L');
  repaintGrid;
end;


procedure TfrmMain.LookupTickerClick(Sender: TObject);
var
  Ticker: String;
begin
  Ticker := '';
  //TfrmUnderlying.Execute(Ticker);
end;


procedure TfrmMain.Purchases1Click(Sender: TObject);
begin
  ClearFilter; //cxGrid1TableView1.DataController.Filter.Clear;
  filterPurchSales('P');
  repaintGrid;
end;


procedure TfrmMain.Sales1Click(Sender: TObject);
begin
  ClearFilter; //cxGrid1TableView1.DataController.Filter.Clear;
  filterPurchSales('S');
  repaintGrid;
end;


procedure TfrmMain.MatchedTaxLots1Click(Sender: TObject);
begin
  GridFilter := gfNone;
  ClearFilter;
  filterTaxLots;
  frmMain.cxGrid_15_m.Visible := true;
  repaintGrid;
end;


procedure TfrmMain.ExercisesAssigns1Click(Sender: TObject);
begin
  FilterByExerciseAssigns(0);
end;


//procedure TfrmMain.Stocks1Click(Sender: TObject);
//begin
//  if findStocksDlg then SpeedButtonsUp;
//end;


procedure TfrmMain.Stocks2Click(Sender: TObject);
begin
  filterByType('STK', True);
end;


procedure TfrmMain.Options2Click(Sender: TObject);
begin
  filterByType('OPT', True);
end;


procedure TfrmMain.SingleStockFutures1Click(Sender: TObject);
begin
  DoStocks('SSF');
end;


procedure TfrmMain.StocksOptionsandSSFs1Click(Sender: TObject);
begin
  DoStocks;
end;


procedure TfrmMain.Currencies2Click(Sender: TObject);
begin
  filterByType('CUR', True);
end;


procedure TfrmMain.ReadMe1Click(Sender: TObject);
var
  TxtFile: TextFile;
  txtFileName, txtStr: string;
begin
  frmReadMe := TfrmReadMe.Create(frmMain);
  // load readMe with readMe.txt
  txtFileName := Settings.InstallDir + '\ReadMe.txt';
  if FileExists(txtFileName) then begin
    with frmReadMe.richreadMe do begin
      AssignFile(TxtFile, txtFileName);
      reset(TxtFile);
      lines.Clear;
      while not Eof(TxtFile) do begin
        ReadLn(TxtFile, txtStr);
        lines.Add(txtStr);
      end;
      CloseFile(TxtFile);
    end; // with
  end; // if
  // load newfeatures with newFeatures.txt
  txtFileName := Settings.InstallDir + '\newFeatures.txt';
  if FileExists(txtFileName) then begin
    with frmReadMe.richNewFeatures do begin
      AssignFile(TxtFile, txtFileName);
      reset(TxtFile);
      lines.Clear;
      while not Eof(TxtFile) do begin
        ReadLn(TxtFile, txtStr);
        lines.Add(txtStr);
      end;
      CloseFile(TxtFile);
    end;
  end;
  if frmReadMe.ShowModal = mrCancel then begin
    frmReadMe.close;
    frmReadMe.release;
  end;
end;


procedure TfrmMain.REDO1Click(Sender: TObject);
begin
  if not CheckRecordLimit then Exit;
  Redo(true);
end;


procedure TfrmMain.changeCusip1Click(Sender: TObject);
begin
  if not CheckRecordLimit then Exit;
  changeCusips;
end;


function TfrmMain.changeFutSymbol(s: string): string;
var
  opTick, callPut, tkStr, moStr, yrStr, monYr: string;
begin
  // test if future option already in long format ie: ES DEC08 1250 CALL
  if ((pos(' CALL', s) = Length(s) - 4) and (pos(' CALL', s) > 0))
  or ((pos(' PUT', s) = Length(s) - 3) and (pos(' PUT', s) > 0)) then begin
    Result := s;
    exit;
  end;
  // test if future already in long format ie: ES DEC08
  // last char of future symbol is always a number
  if (pos(' ', s) > 0) and not(isInt(copy(s, pos(' ', s) - 1, 1))) then begin
    Result := s;
    exit;
  end;
  callPut := '';
  opTick := '';
  // test if Futures Option  ie: ESZ8 C1280
  // test for space
  if (pos(' ', s) > 0) then begin
    opTick := s;
    opTick := parselast(opTick, ' ');
  end;
  // test for C or P
  if (opTick <> '') and ((pos('C', opTick) = 1) or (pos('P', opTick) = 1)) then
  begin
    if pos('C', opTick) = 1 then      callPut := 'CALL'
    else if pos('P', opTick) = 1 then callPut := 'PUT';
    if callPut <> '' then begin
      delete(opTick, 1, 1);
      opTick := ' ' + opTick + ' ' + callPut;
    end
    else opTick := '';
    s := copy(s, 1, pos(' ', s) - 1);
  end; ;
  // change future symbol to long format ie: ESZ8  to ES DEC08
  tkStr := copy(s, 1, Length(s) - 2);
  moStr := copy(s, Length(s) - 1, 1);
  moStr := getFutCodeExpMo(moStr);
  yrStr := '0' + copy(s, Length(s), 1);
  if opTick <> '' then
    Result := tkStr + ' ' + moStr + yrStr + opTick
  else
    Result := tkStr + ' ' + moStr + yrStr;
end;


procedure TfrmMain.cbTickClick(Sender: TObject);
begin
  SortByTicker;
  if (lblRptTitle.Caption = 'DETAIL REPORT') then
    ReportStyle := rptTickerDetails
  else
    ReportStyle := rptTickerSummary;
end;


procedure TfrmMain.cbDateClick(Sender: TObject);
begin
  SortByDate;
  ReportStyle := rptDateDetails;
end;


procedure TfrmMain.cbForm8949Click(Sender: TObject);
begin
  if cbForm8949.Checked then begin
    cbIncludeStatement.Enabled := true;
    cb1099OtherErrors.Enabled := true;
    cbIncludeAdjustment.Enabled := true;
    cbIncludeStatement.Checked := true;
    cbIncludeAdjustment.Checked := true;
  end
  else begin
    cbIncludeStatement.Checked := false;
    cb1099OtherErrors.Checked := false;
    cbIncludeAdjustment.Checked := false;
    cbIncludeStatement.Enabled := false;
//    cb1099OtherErrors.Enabled := false;
    cbIncludeAdjustment.Enabled := false;
  end;
end;

procedure TfrmMain.cbForm8949pdfMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
    webURL(supportSiteURL + 'hc/en-us/articles/115004512594');
end;


procedure TfrmMain.cbIncludeAdjustmentClick(Sender: TObject);
begin
  cb1099OtherErrors.visible := cbIncludeStatement.checked;
//  btnHelpOtherErrors.visible := cbIncludeStatement.checked;
end;


procedure TfrmMain.cbIncludeStatementClick(Sender: TObject);
begin
  cb1099OtherErrors.visible := cbIncludeStatement.checked;
//  btnHelpOtherErrors.visible := cbIncludeStatement.checked;
end;


procedure TfrmMain.cbTrNumClick(Sender: TObject);
begin
  sortByTradeNum;
  if (lblRptTitle.Caption = 'DETAIL REPORT') then
    ReportStyle := rptTradeDetails
  else
    ReportStyle := rptTradeSummary;
end;


procedure TfrmMain.Change8949Code1Click(Sender: TObject);
begin
  btnAdjCodeClick(Sender); // 2021-05-12 MB
end;


procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  P: TPoint;
  sMsg, sLine: string;
  i, x: integer;
  // ------------------------
  MyWaveOutCaps: TWaveOutCaps;
  Volume: Integer;
  procedure EnableAudio;
  begin
    if WaveOutGetDevCaps(WAVE_MAPPER, @MyWaveOutCaps,
      sizeof(MyWaveOutCaps)) = MMSYSERR_NOERROR then
        WaveOutSetVolume(WAVE_MAPPER, MakeLong(20479, 20479));
  end;
  procedure DisableAudio;
  begin
    if WaveOutGetDevCaps(WAVE_MAPPER, @MyWaveOutCaps,
      sizeof(MyWaveOutCaps)) = MMSYSERR_NOERROR then
        WaveOutSetVolume(WAVE_MAPPER, MakeLong(0, 0));
  end;
  // ------------------------
begin
  if assigned(frmFastReports) then begin
    if frmFastReports.Visible then
      frmFastReports.SetFocus;
    exit;
  end;
  if (pos('Sorting', stMessage.Caption) > 0) then exit;
  if (pos('Matching', stMessage.Caption) > 0) then exit;
  if (pos('Loading', stMessage.Caption) > 0) then exit;
  if (IsFormVisible('frmOpenTrades')) then exit;
  if ReOrdering then exit;
  // -------------- Redo and Undo keyboard shortcuts
  if Shift = [ssCtrl] then begin
    case Key of
      89: begin // Ctrl+Y = Redo
        if not CheckRecordLimit then Exit;
        Redo(true);
        exit;
      end;
      90: begin // Ctrl+Z = Undo
        Undo(true);
        enableEdits;
        exit;
      end;
    end; // end case Key
  end; // if ssCtrl
  // --------------
  Case Key of
    13: begin // Enter
      if ( pnlTrades.Visible or pnlGains.Visible or pnlChart.Visible )
      and spdRunReport.Enabled then
        spdRunReport.Click;
    end;
    27: begin // Escape
      FEscKeyPressed := true;
      try
        statBar('off');
        // If we have a report open, ESC = exit the report
        if assigned(frmFastReports) then
          frmFastReports.actnFile_ExitExecute(Sender)
        // If we are looking at Open Trades that are price to market
        // ESC = stop the update and clear
        else if (cxGrid1TableView1.DataController.CustomDataSource = OpenTradeRecordsSource) //
        then begin
          stopUpdate := true;
          exit;
        end
        else if (panelSplash.Visible) //
        or (frmEditSplit.Visible) then
          exit
        else
          cxGrid1TableView1KeyDown(Sender, Key, Shift);
        // end if block
        exit;
      finally
        cxGrid1TableView1.DataController.GotoFirst;
        dispProfit(true, 0, 0, 0, 0);
        statBar('off');
        screen.Cursor := crDefault;
        FEscKeyPressed := false;
      end;
    end; // Escape key
  end; // Case Key
  // --------------
  if Shift = [ssCtrl,ssShift] then begin
    case Key of
      90: begin  // shift+ctrl+Z (aka ctrl+shift+Z) = SuperUser
        if not superUser or not isDBFile then exit;
        dlgSuper := TdlgSuper.Create(frmMain);
        dlgSuper.show;
      end;
    end;
  end; // Ctrl+Shift
  // --------------
  if Shift = [ssCtrl] then begin
    case Key of
      70: begin // Ctrl+F = Find
        if not panelSplash.Visible then begin
          GetCursorPos(P);
          // If our mouse pointer is in the bounds of the application then
          // popup wherever the mouse pointer is located
          if  (P.X > Self.Left) and (P.X < Self.Left + Self.Width)
          and (P.Y > Self.Top) and (P.Y < Self.Top + Self.Height) then
            pupFind.Popup(P.X, P.Y)
          else { Otherwise popup 50 points inside the app from top and left }
            pupFind.Popup(Self.Top + 50, Self.Left + 50);
        end;
      end;
    end;
  end; // if Ctrl
  // --------------
  // keyboard shortcut to enter super user reg code
  if Shift = [ssCtrl,ssShift] then begin
    // slash key [/]+Shift+Ctrl = switch to SuperUser mode
    if (key = 191) and (DEBUG_MODE > 1) then begin
      if inputBox('', 'Enter code:', '') = 'acl' // secret code
      then begin
        // super user reg code
        Settings.RegCode := 'H101-2121-2121-5454-9894';
        Register1.click;
      end; // if speedcode
    end; // if "/" and DEBUG > 1
  end; // if Ctrl+Shift
end;


// https://docs.devexpress.com/WindowsForms/DevExpress.XtraGrid.Views.Grid.GridView.LayoutChanged
// The LayoutChanged method recalculates all graphical information
// of the current View and redraws it. This method is called
// automatically when changes are applied to the View (for example,
// when changing row height, column width, etc). You may also call
// this method manually when the View needs to be updated. This can
// be used when you need the control to be updated in response to
// custom actions that do not lead to automatic updating.
//
// Calling the LayoutChanged method has NO effect in the following cases:
// 1. the View is being initialized or destroyed;
// 2. the BaseView.BeginUpdate method was called previously
//    and there was no matching BaseView.EndUpdate method call;
// 3. the method is called for a pattern view.
// 4. Calling the LayoutChanged method raises the BaseView.Layout event.
//
// NOTE: Detail pattern Views do not contain data and they are never
// displayed within XtraGrid. So, the LayoutChanged member must NOT be
// invoked for these Views. The LayoutChanged member can only be used
// with Views that display real data within the Grid Control. Use the
// following methods to access these Views with which an end user interacts
// at runtime:
// GridControl.MainView - returns the top most View in a grid;
// GridControl.FocusedView - returns the focused View;
// GridControl.DefaultView - returns the currently maximized View;
//  the sender parameter of View specific events;
// GridView.GetDetailView - returns a detail clone View for a specific master row.

procedure TfrmMain.FormPaint(Sender: TObject);
var
  sErr : string;
  bFlag : boolean;
begin
  try
    sErr := '';
    bFlag := true;
//    cxGrid1.layoutchanged; // 2023-05-12 MB disabled, causing errors
    sErr := ' test grid enabled';
    if not cxGrid1.Enabled then bFlag := false;
    sErr := ' test grid visible';
    if not cxGrid1.Visible then bFlag := false;
    sErr := ' test main panel visible';
    if not pnlMain.Visible then bFlag := false;
    if bFlag then begin
      sErr := ' set focus on grid';
      cxGrid1.SetFocus;
    end;
  except
    nErrorCount := nErrorCount + 1; // count 'em
//    if not SuperUser then sErr := '';
//    sm('error' + sErr + ' in form paint(main)');
  end;
  StatusBar.Visible := false;
end;


procedure TfrmMain.Save2Click(Sender: TObject);
begin
  mnuFileSave;
end;


procedure TfrmMain.MatchTaxLots1Click(Sender: TObject);
var
  I, ARec: Integer;
  Ticker, sType, sLS: string;
  NextNum: Integer;
  EditedTrades: TTradeList;
begin
  if (TradeLogFile.Count < 1) then exit;
  if not CheckRecordLimit then exit;
  readFilter;
  try
    with cxGrid1TableView1.DataController do begin
      if GetSelectedCount < 1 then begin
        sm('Select Record(s) to Match');
        exit;
      end;
      if mDlg('Match Selected Record(s)?', mtWarning, [mbNo, mbYes], 0) <> mrYes
      then
        exit;
      Ticker := '';
      // Gets the Next Number to use for matching from the Tradelog file.
      NextNum := TradeLogFile.NextMatchNumber;
      for I := 0 to GetSelectedCount - 1 do begin
        ARec := GetRowInfo(GetSelectedRowIndex(I)).RecordIndex;
        if (i = 0) then begin
          ticker := TradeLogFile[ARec].Ticker;
          sType :=  TradeLogFile[ARec].TypeMult;
          sLS :=  TradeLogFile[ARec].LS;
        end;
        // make sure tickers match
        if (TradeLogFile[ARec].Ticker <> Ticker) then begin
          mDlg('Cannot match trades with different ticker symbols', mtError, [mbOK], 0);
          exit;
        end;
        // make sure type/mult's match
        if (TradeLogFile[ARec].TypeMult <> sType) then begin
          mDlg('Cannot match trades with different Type/Mult', mtError, [mbOK], 0);
          exit;
        end;
        // make sure LS's match
        if (TradeLogFile[ARec].LS <> sLS) then begin
          mDlg('Cannot match trades with different Long/Short', mtError, [mbOK], 0);
          exit;
        end;
        //-
        TradeLogFile[ARec].Matched := intToStr(NextNum);
        Ticker := TradeLogFile[ARec].Ticker;
      end;
      EditedTrades := TradeLogFile.Match(Ticker);
      try
        TradeLogFile.RenumberTrades;
        // Because we now may have manually matched trades of differing dates
        // we need to sort by TrNumber in order for transaction numbers to end
        // up together.
        TradeLogFile.SortByTrNumber;
        DisplayMatchedTaxLots1.checked := true;
        TradeRecordsSource.DataChanged;
        SetEditedTradesFilter(EditedTrades);
        frmMain.cxGrid1TableView1.DataController.ClearSelection;
        frmMain.cxGrid_15_m.Visible := true;
        filterTaxLots(NextNum);
        dispProfit(true, 0, 0, 0, 0);
        if not SaveTradeLogFile('Match Tax Lots') then begin
          clearFilter;
          writeFilter(false);
        end;
      finally
        EditedTrades.Free;
        writeFilter(false); // 2020-12-29 MB
      end;
    end;
  finally
    FindTradeIssues;
  end;
end;


procedure TfrmMain.MatchTaxLots2Click(Sender: TObject);
begin
  MatchTaxLots1.Click;
end;


procedure TfrmMain.miSendFilesClick(Sender: TObject);
begin
  CreateScreenShot(self.Handle, Settings.LogDir + '\ScreenShot.png');
  Help_SendFilestoSupport;
end;


procedure TfrmMain.mnu8949Click(Sender: TObject);
var
  code: Char;
  I: Integer;
  Idx: Integer;
  RowInfo: TcxRowInfo;
begin
  if cxGrid1TableView1.DataController.GetSelectedCount = 0 then begin
    mDlg('No Records Selected. Please select some records' + CR //
      + 'in the grid in order to change the 8949 code.', mtInformation, [mbOK], 0);
    exit;
  end;
  if not CheckRecordLimit then exit;
  SaveTradesBack('Change 8949 Code');
  if (TdxBarListItem(Sender).ItemIndex = 0) then begin // Clear menu item chosen
    code := ' ';
    if mDlg('You are about to clear the TradeLog 8949 Code for (' //
      + intToStr(cxGrid1TableView1.DataController.GetSelectedCount) //
      + ') records!' + cr + cr + 'Are you sure?', //
      mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
      exit;
  end
  else begin // A B or C Chosen, Tag Property contains the Ordinal value of the character chosen.
    code := (TdxBarListItem(Sender).Items[TdxBarListItem(Sender).ItemIndex])[1];
    if mDlg('You are about to change the TradeLog 8949 Code for (' //
      + intToStr(cxGrid1TableView1.DataController.GetSelectedCount) //
      + ') records to ' + #39 + code + #39 + '!' + cr + cr + 'Are you sure?', //
      mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
      exit;
  end;
  for I := 0 to cxGrid1TableView1.DataController.GetSelectedCount - 1 do begin
    Idx := cxGrid1TableView1.DataController.GetSelectedRowIndex(I);
    RowInfo := cxGrid1TableView1.DataController.GetRowInfo(Idx);
    TradeLogFile[RowInfo.RecordIndex].ABCCode := code;
  end;
  SaveGridData(False, true);
  if Not cxGrid_20_Code.Visible then
    Display8949Code1.Click;
  TradeRecordsSource.DataChanged;
  screen.Cursor := crDefault; // make sure cursor is not left on crHourglass!
end; // mnu8949


procedure TfrmMain.MTMAccounts1Click(Sender: TObject);
begin
  if Not FilterByBrokerAccountType(True, False, False) then
    mDlg('No MTM accounts exist in this file', mtInformation, [mbOK], 0);
end;


procedure TfrmMain.MutualFunds1Click(Sender: TObject);
begin
  filterByType('MUT', True);
end;


procedure TfrmMain.UnMatchTaxLots1Click(Sender: TObject);
var
  I, ARec: Integer;
  Tickers: TStringList;
begin
  if oneYrLocked
  or (TradeLogFile.Count = 0)
  or IsAllBrokersSelected
  then
    exit;
  if not CheckRecordLimit then Exit;
  readFilter;
  with cxGrid1TableView1.DataController do
  begin
    if GetSelectedCount < 1 then
    begin
      mDlg('First Select Record(s) to Un-Match', mtInformation, [mbOK], 0);
      exit;
    end;
    if mDlg('Un-Match Selected Record(s)?', mtWarning, [mbNo, mbYes], 0) <> mrYes
    then
      exit;
    Tickers := TStringList.Create;
    Tickers.Delimiter := ',';
    Tickers.Duplicates  := dupIgnore;
    try
     for I := 0 to GetSelectedCount - 1 do
      begin
        ARec := GetRowInfo(GetSelectedRowIndex(I)).RecordIndex;
        if pos('Ex-', TradeLogFile[ARec].Matched) > 0 then
        begin
          mDlg('Exercised trades cannot be unmatched!', mtError, [mbOK], 0);
          exit;
        end;
        Tickers.Append(Trim(TradeLogFile[ARec].Ticker));
        TradeLogFile[ARec].Matched := '';
      end;
      { Because of a previous match the trades may now no longer be in date order,
        so we need to sort by date in order for trades that are matched to show up together. }
      TradeLogFile.Match(Tickers);
      TradeLogFile.Reorganize(False);
      TradeRecordsSource.DataChanged;
      SaveTradeLogFile('Un-Match Tax Lots');
    finally
      Tickers.free;
      writeFilter(true);
      repaintGrid;
    end;
  end;
end; // UnMatchTaxLots1Click


procedure TfrmMain.cxGrid_11_AmountGetDisplayText
  (Sender: TcxCustomGridTableItem;
  ARecord: TcxCustomGridRecord; var AText: string);
begin
  GridCurrStr(AText);
end;


procedure TfrmMain.cxGrid_11_AmountPropertiesChange(Sender: TObject);
var
  OC, ls, ctype: string;
  Shares, Price, Comm, amount, mult: double;
begin
  sm('onChange');
  exit;
  OC := cxGrid_4_OC.EditValue;
  ls := cxGrid_5_LS.EditValue;
  Shares := cxGrid_7_Shares.EditValue;
  Price := cxGrid_8_Price.EditValue;
  ctype := cxGrid_9_PRF.EditValue;
  Comm := (TcxMaskEdit(Sender).EditValue);
  cxGrid_10_Comm.EditValue := -Comm;
  delete(ctype, 1, pos('-', ctype));
  if ctype <> '' then
    mult := StrToFloat(ctype, Settings.UserFmt)
  else
    mult := 1;
  // end if
  if ((OC = 'O') and (ls = 'L') or (OC = 'C') and (ls = 'S')) then
    amount := -(Shares * Price * mult) - Comm
  else if ((OC = 'C') and (ls = 'L') or (OC = 'O') and (ls = 'S')) then
    amount := Shares * Price * mult - Comm
  else
    amount := 0;
  cxGrid_11_Amount.EditValue := amount;
end;


procedure TfrmMain.ExpireOptions1Click(Sender: TObject);
begin
  if not CheckRecordLimit then exit;
  if TradeLogFile.HasNegShares then begin
    mDlg('You must fix all trades with Negative Share'+cr+
      ' warnings before you run this function!'
      ,mtWarning, [mbOK], 0);
    screen.cursor := crDefault;
    exit;
  end;
  btnShowOpen.Click;
  expireOptions;
end;


procedure TfrmMain.DuplicateTrades1Click(Sender: TObject);
begin
  filterByDuplicateItems;
end;


procedure TfrmMain.bbUser_WashSalesClick(Sender: TObject);
begin
  Settings.DispWSdefer := not(Settings.DispWSdefer); // was bbUser_WashSales.Down;
  SetWSDefer;
  SetOptions;
  bbUser_WashSales.Down := Settings.DispWSDefer;
end;


procedure TfrmMain.bbUser_QuickStartClick(Sender: TObject);
begin
    exit;
end;


// ----------------
//     Adj Code
// ----------------
procedure TfrmMain.btnAdjCodeClick(Sender: TObject);
var
  code: Char;
  I, Idx: Integer;
  RowInfo: TcxRowInfo;
  f: TdlgAdjCodes;
  s : string;
  s1, s2, s3 : string[1];
begin
  // --- check for invalid use --------
  if cxGrid1TableView1.DataController.GetSelectedCount = 0 then begin
    mDlg('No Records Selected. Please select some records' + CR //
      + 'in the grid in order to change the 8949 code.', mtInformation, [mbOK], 0);
    exit;
  end;
  if not CheckRecordLimit then exit;
  f := TdlgAdjCodes.Create(nil);
  try
    // ----------------------------------------------------
    // now set defaults to match first trade selected
    // ----------------------------------------------------
    Idx := cxGrid1TableView1.DataController.GetSelectedRowIndex(0);
    RowInfo := cxGrid1TableView1.DataController.GetRowInfo(Idx);
    s := leftstr(TradeLogFile[RowInfo.RecordIndex].ABCCode + '   ', 3);
    // --- 8949 code ----------------
    if (s[1] = 'A') then
      f.RadioButton1.Checked := true
    else if (s[1] = 'B') then
      f.RadioButton2.Checked := true
    else if (s[1] = 'C') then
      f.RadioButton3.Checked := true
    else
      f.RadioButton4.Checked := true;
    // --- WS Exempt ----------------
    if (s[2] = 'X') then
      f.CheckBox1.Checked := true
    else
      f.CheckBox1.Checked := false;
    // --- Long/Short term ----------
    if (s[3] = 'L') then
      f.RadioButton5.Checked := true
    else if (s[3] = 'S') then
      f.RadioButton6.Checked := true
    else
      f.RadioButton7.Checked := true;
    // --- init variables -------------
    s1 := '';
    s2 := '';
    s3 := '';
    // ----------------------------------------------------
    // Get User Selections
    // ----------------------------------------------------
    if f.showmodal = mrOK then begin
      // --- 8949 code ----------------
      if f.RadioButton1.Checked then
        s1 := 'A'
      else if f.RadioButton2.Checked then
        s1 := 'B'
      else if f.RadioButton3.Checked then
        s1 := 'C'
      else
        s1 := ' ';
      // --- WS Exempt ----------------
      if f.CheckBox1.Checked then
        s2 := 'X'
      else
        s2 := ' ';
      // --- Long/Short term ----------
      if f.RadioButton5.Checked then
        s3 := 'L'
      else if f.RadioButton6.Checked then
        s3 := 'S'
      else
        s3 := ' '; // 2022-01-26 MB force all to clear for now
    end
    else begin
      exit; // jump to FINALLY block
    end;
    SaveTradesBack('Change 8949 Code');
    // --- do selection -------
    s := ''; // clear, use for error message if any
    for I := 0 to cxGrid1TableView1.DataController.GetSelectedCount - 1 do begin
      Idx := cxGrid1TableView1.DataController.GetSelectedRowIndex(I);
      RowInfo := cxGrid1TableView1.DataController.GetRowInfo(Idx);
      if (s = '') and (TradeLogFile[RowInfo.RecordIndex].LS = 'S') then begin
        s := 'IRS rules state that all short sales' + CR //
          + 'are taxed at the short-term rate.' + CR //
          + 'Some changes were disallowed.';
        TradeLogFile[RowInfo.RecordIndex].ABCCode := (s1+s2+' ');
      end
      else
        TradeLogFile[RowInfo.RecordIndex].ABCCode := (s1+s2+s3);
    end;
    if (s <> '') then
      sm(s);
    SaveGridData(False, true);
    if Not cxGrid_20_Code.Visible then
      Display8949Code1.Click;
    TradeRecordsSource.DataChanged;
  finally
    f.Free;
    screen.Cursor := crDefault; // make sure cursor is not left on crHourglass!
  end;
end; // btnAdjCodeClick


//procedure TfrmMain.dxBarLargeButton64Click(Sender: TObject);
//var
//  I, Idx: Integer;
//  RowInfo: TcxRowInfo;
//  s : string;
//begin
//  if cxGrid1TableView1.DataController.GetSelectedCount = 0 then begin
//    mDlg('No Records Selected. Please select some records' + CR //
//      + 'in the grid in order to change the 8949 code.', mtInformation, [mbOK], 0);
//    exit;
//  end;
//  if not CheckRecordLimit then exit;
//  // ----------------------------------
//  for I := 0 to cxGrid1TableView1.DataController.GetSelectedCount - 1 do begin
//    Idx := cxGrid1TableView1.DataController.GetSelectedRowIndex(I);
//    RowInfo := cxGrid1TableView1.DataController.GetRowInfo(Idx);
//    s := leftstr(TradeLogFile[RowInfo.RecordIndex].ABCCode + '   ', 3);
//    if (s[2] = 'X') then // toggle
//      s[2] := ' '
//    else
//      s[2] := 'X';
//    TradeLogFile[RowInfo.RecordIndex].ABCCode := s;
//  end;
//  SaveGridData(False, true);
//  if Not cxGrid_20_Code.Visible then
//    Display8949Code1.Click;
//  TradeRecordsSource.DataChanged;
//end;


procedure TfrmMain.bbFind_DateRangeClick(Sender: TObject);
begin
  ClearFilter;
  ResetFilterCombobox('');
  actnShowRangeClick(Sender);
end;


// ----------------------------------------------
// run all reports for that type of accounting,
// using our specified naming convention.
// EX: MTM - push button
// TradeLog prints to pdf...
// <username>_2022_4797 Report
// <username>_2022_6781 Report
// <username>_2022_SecuritiesMTM
// ----------------------------------------------
procedure TfrmMain.bbReports_AllRptsClick(Sender: TObject);
var
  Account : TTLFileHeader;
  IncludeAdjustment : Boolean;
begin
  // ---------
  frmMain.cxGrid1.Enabled := True;
  SetPopupMenuEnabled(pupEdit, false);
  // ---------
  IncludeAdjustment := (ReportStyle = rptIRS_D1) //
    and (TradeLogFile.TaxYear > 2010) //
    and (TradeLogFile.TaxYear < 2014) //
    and (cbIncludeAdjustment.checked);
  // ---------
  if TradeLogFile.CurrentBrokerID = 0 then begin // all accounts
    sm('not available in All Accounts tab');
    exit;
  end
  else if TradeLogFile.CurrentAccount.MTM then begin
    // rpt4797 = RunGandLReport(true)
    ReportStyle := rpt4797;
    SetupForGains;
    RunReport(glStartDate.date, glEndDate.date, false, false, IncludeAdjustment);
    // rptFutures = RunFuturesReport

    // rptMTM = RunSecuritiesMTM

  end;
  screen.Cursor := crDefault;
end;

procedure TfrmMain.bbReports_YearEndChecklistClick(Sender: TObject);
begin
  // Year End Checklist
  if not CheckRecordLimit then Exit;
  CheckCurrentAccount;
end;


procedure TfrmMain.dxImportSettingsClick(Sender: TObject);
var
  t: string;
begin
  if not CheckRecordLimit then Exit;
//SuperUser := false; // for debugging UNLINK button
//Developer := false;
  // --- check API ----------
  t := GetPassivStatus(v2ClientToken);
  if (pos('"online":true', t) < 1) then begin // BC is offline
    sm('BrokerConnect is currently offline.');
    exit;
  end;
  // ------------------------
  EditCurrentImport('');
  SetupToolBarMenuBar(false);
end;


// -----------------------------------+
//          Super User Menu
// ===================================+
procedure TfrmMain.bbSuper_GetFTPClick(Sender: TObject);
var
  sFile : string;
begin
  // get file name, download file
  sFile := inputbox('Name of File to Download','Paste file name here:','');
  if sFile = '' then exit;
  // instantiate TLSupport object, call GetSupportFile
  TLSupportLib.GetSupportFile(sFile);
end;

          // ----------+
          // Test Code |
          // ----------+
procedure TfrmMain.bbSuper_TaxFilesClick(Sender: TObject);
begin
  frmMain.mnuFileResetUser;
end;

procedure TfrmMain.bbSuper_TestClick(Sender: TObject);
var
  sEmail, sPwd, sAuth, s, t, s1, s2, s3, s4 : string;
  sAccts, sN, sURL : string;
  Header : TTLFileHeader;
  i, x, nTrades, nAccts : integer;
  FKeyLst, lineLst: TStrings;
  bFlag : boolean;
  Amt : double;
  // ------------------------
  function ReadDiagnostics(sFile : string) : string;
  var
    s : string;
    myFile : TextFile;
  begin
    result := ''; // clear
    try
      AssignFile(myFile, sFile);
      reset(myFile);
      while not Eof(myFile) do begin
        ReadLn(myFile, s);
        if pos('Diagnostics data: ', s) = 1 then s := copy(s, 19);
        result := result + CRLF + dEncrypt(s, '');
      end;
    finally
      CloseFile(myFile);
    end;
  end;
  // ------------------------
begin
  if v2ClientToken = '' then
    sAuth := v2UserToken
  else
    sAuth := v2ClientToken;
  if v2UserEmail = 'mark@tradelogsoftware.com' then begin
    sAuth := Settings.DataDir + '\diagnostics.txt';
    if fileexists(sAuth) then begin
      t := ReadDiagnostics(sAuth);
      sm('Diagnostics:' + crlf + t);
      exit;
    end;
  end;
  // ------------------------
//  DeleteBrokerLink(v2ClientToken, 'TL:23113', '66e88d71-79f5-4dbe-a0a7-9df63fd0e674');
//  exit;
  // ------------------------
  if TaxYear = '' then sN := inputbox('Tax Year','yyyy: ', '') else sN := TaxYear;
  t := inputbox('Get MTM Price for...', 'option:', t);
  s := GetMTMPriceOPT(sAuth, sN, t);
  sm('$' + s);
  exit;
  // ------------------------
  s := GeneratePassword('TLPass123');
  clipboard.AsText := s;
  sm('pass=' + s);
  clipboard.Clear;
  exit;
  // ------------------------
  s1 := TradeLogFile.CurrentAccount.FileImportFormat; // sBroker
  s2 := TradeLogFile.CurrentAccount.PlaidAcctId; // sAcctId
  s3 := TradeLogFile.CurrentAccount.OFXUserName; // sName
  s4 := GetPassivBrokerId(v2ClientToken, s3, s1); // sBrokerId
  // ------------------------
  ImpStrList := TStringList.Create;
  s := GetPassivRawTrans( v2ClientToken, 'mspeaker:', // production
   '2024-08-10', '2024-08-25',
   '86dc4424-47f0-481e-a1ac-47b6081d9980',
   '1cf52036-3023-48c8-9031-8ecb8f6bca80'); // dev
  sAuth := FormatV2APIResponse(s);
  clipboard.AsText := sAuth;
  sm('paste transactions');
  clipboard.Clear;
  exit;
//  // ------------------------
  if TradeLogFile <> nil then begin
    sN := TradeLogFile.CurrentAccount.OFXUserName;
    t := TradeLogFile.CurrentAccount.ImportFilter.InstitutionId; // broker id
  end;
  sN := inputbox('user name:id','enter entire string', sN);
  if sN = '' then exit;
  s := inputbox('broker name:', 'enter:', 'Webull');
  if s = '' then exit;
  t := GetPassivBrokerId(sAuth, sN, s);
  sm('broker id: ' + t);
//  t := inputbox('broker id','copy/paste here', t);
//  DeleteBrokerLink(sAuth, sN, t); // 'zaronan', '3ca2249b-b246-40bf-bcc7-adef262fff0e');
  exit;
//  bFlag := true;
//  if TaxYear = '' then sN := inputbox('Tax Year','yyyy: ', '') else sN := TaxYear;
//  t := inputbox('Get MTM Price for...', 'option:', t);
//  s := GetMTMPriceOPT(sAuth, sN, t);
//  sm('$' + s);
//  t := inputbox('Get MTM Price for...', 'stock:', t);
//  s := GetMTMPriceSTK(sAuth, sN, t);
//  sm('$' + s);
//  exit;
  // ------------------------
//  sAuth := '1.' + GetPassivStatus(v2ClientToken);
//  t := inputbox('Enter Description', 'Description:', t);
//  s := trim(StripNonAlpha(t));
//  sAuth := GetTickerSymbol(s);
//  sm(t + ' --> [' + sAuth + ']');
//  exit;
  // ------------------------
  if length(sAuth) > 2000 then
    sm('returned: ' + leftstr(sAuth,2000)+'...')
  else
    sm('returned: ' + sAuth);
  exit;
//  // ------------------------
//  x := messagedlg('Yes=Password; No=Decode Diagnostics; Cancel=ReadLogs',
//    mtInformation, [mbYes,mbNo,mbCancel], 0);
//  // put anything we need to test here.
//  if x = mrYes then begin
//  end // ----------
//  else if x = mrNo then begin
//  end // ----------
//  else if x = mrCancel then begin
//  end;
end;


procedure TfrmMain.bbSuper_CodeClick(Sender: TObject);
begin
  showFileResetPW;
end;

procedure TfrmMain.bbSuper_DebugLevelClick(Sender: TObject);
begin
  try
    DEBUG_MODE := StrToInt(InputBox('Debug Level', 'Enter Debug Level [0 - 9]:', '0'));
  except
    DEBUG_MODE := 0;
  end;
end;


// -----------------------------------+
//             User Menu
// ===================================+
procedure TfrmMain.getVisualThemeSkin;
var
  sSkin : string;
  aSkin : TArray<string>;
//  sValue : string;
//  APainterInfo: TdxSkinLookAndFeelPainterInfo;
//  AdxSkin: TdxSkin;
//  AGroup: TdxSkinControlGroup;
//  AElement: TdxSkinElement;
//  AProperty: TdxSkinProperty;
begin
  aSkin := TArray<string>.Create( 'HighContrast', 'Office2010Black',
                                  'Office2010Blue', 'Office2010Silver');
  // get sSkin choice fron registry
  sSkin := Settings.SkinName;
  // find skin choice in array
  if not (MatchStr(sSkin, aSkin)) then
    sSkin := 'HighContrast';
  // sSkin := QuotedStr(sSkin);
   RibbonMenu.ColorSchemeName := sSkin;
  // Grid skin
  cxGrid1.LookAndFeel.SkinName := sSkin;
 {$IFDEF EXPRESSSKINS}
 {$IFDEF DXSKINDYNAMICLOADING}
   FChooser.SelectedSkinName := dxSkinsUserSkinGetLoadedSkinName;
 {$ELSE}
   FChooser.SelectedSkinName := AName;
 {$ENDIF}
 {$ENDIF}
   Panel1.Color := RibbonMenu.ColorScheme.GetPartColor(rfspRibbonForm);
end;


procedure TfrmMain.bbUser_VisualThemesClick(Sender: TObject);
var
  sSkin : string;
  aSkin : TArray<string>;
  sValue : string;
  APainterInfo: TdxSkinLookAndFeelPainterInfo;
  AdxSkin: TdxSkin;
  AGroup: TdxSkinControlGroup;
  AElement: TdxSkinElement;
  AProperty: TdxSkinProperty;
begin
  aSkin := TArray<string>.Create( 'HighContrast', 'Office2010Black',
                                  'Office2010Blue', 'Office2010Silver');
  sSkin := (TdxBarListItem(Sender).Items[TdxBarListItem(Sender).ItemIndex]);
  sSkin := Trim(sSkin);
  sSkin := 'Office2010' + sSkin;
  // save sSkin choice to registry
  Settings.SkinName := sSkin;
  // find skin choice in array
  if not (MatchStr(sSkin, aSkin)) then
    sSkin := 'HighContrast';
  // sSkin := QuotedStr(sSkin);
   RibbonMenu.ColorSchemeName := sSkin;
  // Grid skin
  cxGrid1.LookAndFeel.SkinName := sSkin;
 {$IFDEF EXPRESSSKINS}
 {$IFDEF DXSKINDYNAMICLOADING}
   FChooser.SelectedSkinName := dxSkinsUserSkinGetLoadedSkinName;
 {$ELSE}
   FChooser.SelectedSkinName := AName;
 {$ENDIF}
 {$ENDIF}
   Panel1.Color := RibbonMenu.ColorScheme.GetPartColor(rfspRibbonForm);
end;


// ----------------------------------------------
// NOTE: The following settings are stored in the
// TDF file and therefore require an open file.
// ----------------------------------------------
procedure TfrmMain.bbUser_WSsettingsClick(Sender: TObject);
var
  f : TdlgWSsettings;
begin
  f := TdlgWSsettings.Create(nil);
  try
    // ----------------------------------------------------
    // now set defaults to match first trade selected
    // ----------------------------------------------------
    f.chkShortLong.Checked := bWashShortAndLong;
    f.chkStkOpt.Checked := bWashStock2Opt;
    f.chkOptStk.Checked := bWashOpt2Stock;
    f.chkSubstantially.Checked := bWashUnderlying;
    // ----------------------------------------------------
    // Get User Selections
    // ----------------------------------------------------
    if f.showmodal = mrOK then begin
      bWashShortAndLong := f.chkShortLong.Checked;
      bWashStock2Opt := f.chkStkOpt.Checked;
      bWashOpt2Stock := f.chkOptStk.Checked;
      bWashUnderlying := f.chkSubstantially.Checked;
      SaveTradeLogFile('', true); // save change
    end
    else begin // CANCEL
      exit; // jump to FINALLY block
    end;
  finally
    f.Free;
    screen.Cursor := crDefault; // do not leave crHourglass!
  end;
end;


procedure TfrmMain.bbFind_AccountsChange(Sender : TObject);
begin
  // set cbFindInstrament and cbFindErrorCheck to blank
  ResetFilterCombobox('bbFind_Accounts');
  // remove all Filters
  actnShowAllClick(Sender);
  // set filter
  case bbFind_Accounts.ItemIndex of
  1 : begin
      if not FilterByBrokerAccountType(True, false, false) then
        mDlg('No MTM accounts exist in this file', mtInformation, [mbOK], 0);
    end;
  2 : begin
      if not FilterByBrokerAccountType(false, True, false) then
        mDlg('No IRA accounts exist in this file', mtInformation, [mbOK], 0);
    end;
  3 : begin
      if not FilterByBrokerAccountType(false, false, True) then
        mDlg('No Cash accounts exist in this file', mtInformation, [mbOK], 0);
    end;
  end;
end;


procedure TfrmMain.bbFind_AdjustedChange(Sender: TObject);
begin
  // set cbFindInstrament and cbFindErrorCheck to blank
  ResetFilterCombobox('bbFind_Adjusted');
  // remove all Filters
  actnShowAllClick(Sender);
  //set filter
  case bbFind_Adjusted.ItemIndex of
    1  : MatchedTaxLots1Click(Sender);
    2  : FilterByExerciseAssigns(0);
  end;
end;


procedure TfrmMain.bbFind_ErrorCheckChange(Sender: TObject);
begin
  // set cbFindInstrament and cbFindAdjusted to blank
  ResetFilterCombobox('bbFind_ErrorCheck');
  // remove all Filters
  actnShowAllClick(Sender);
  //set filter
  case bbFind_ErrorCheck.ItemIndex of
    1  : filterByDuplicateItems;
    2  : InvalidTickers1Click(Sender);
  end;
end;


procedure TfrmMain.ResetFilterCombobox(combobox : string);
var
  iInstrument, iAdjusted, iErrorCheck, iAccounts, iCount, i : integer;
begin
  //rj April 20, 21
  iAdjusted := bbFind_Adjusted.ItemIndex;
  iErrorCheck := bbFind_ErrorCheck.ItemIndex;
  iAccounts := bbFind_Accounts.ItemIndex;
  if (combobox = 'bbFind_FindInstrument') then begin
    bbFind_Adjusted.ItemIndex := 0;
    bbFind_ErrorCheck.ItemIndex := 0;
    bbFind_Accounts.ItemIndex := 0;
  end else if (combobox = 'bbFind_Adjusted') then begin
    bbFind_FindInstrument.EditValue := null;
    bbFind_ErrorCheck.ItemIndex := 0;
    bbFind_Accounts.ItemIndex := 0;
    bbFind_Adjusted.ItemIndex := iAdjusted;
  end else if (combobox = 'bbFind_ErrorCheck') then begin
    bbFind_FindInstrument.EditValue := null;
    bbFind_Adjusted.ItemIndex := 0;
    bbFind_Accounts.ItemIndex := 0;
    bbFind_ErrorCheck.ItemIndex := iErrorCheck;
  end else if (combobox = 'bbFind_Accounts') then begin
    bbFind_FindInstrument.EditValue := null;
    bbFind_Adjusted.ItemIndex := 0;
    bbFind_ErrorCheck.ItemIndex := 0;
    bbFind_Accounts.ItemIndex := iAccounts;
  end else begin
    bbFind_FindInstrument.EditValue := null;
    bbFind_ErrorCheck.ItemIndex := 0;
    bbFind_Accounts.ItemIndex := 0;
    bbFind_Adjusted.ItemIndex := 0;
  end;
end;


procedure TfrmMain.btnBaselineClick(Sender: TObject);
begin
  //ShowMessage('Baseline');
  mnuBaselinePositionWizardClick(Sender);
end;


procedure TfrmMain.AdjustforStockSplit2Click(Sender: TObject);
begin
  if oneYrLocked or isAllBrokersSelected then exit;
  if not CheckRecordLimit then exit;
  frmEditSplit.Position := poMainFormCenter;
  editSplitShowDlg;
end;


procedure TfrmMain.AdjustforShortSaleDividend1Click(Sender: TObject);
begin
  panelShortSaleDiv.show;
end;


procedure TfrmMain.AdjustforStockSplit1Click(Sender: TObject);
begin
  AdjustforStockSplit2.Click;
end;


procedure TfrmMain.whatsnewClick(Sender: TObject);
begin
  getWebPage('http://www.tradelogsoftware.com/whats-new');
  exit;
end;


procedure TfrmMain.cxGrid1TableView1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if isFormOpen('frmExerciseAssign') then begin
    cancelDrag;
    exit;
  end;
  if EditRec or addRec or insertRec
  or (cxGrid1TableView1.ViewInfo.GetHitTest(X, Y).HitTestCode = htHeader)
  or (cxGrid1TableView1.ViewInfo.GetHitTest(X, Y).HitTestCode = htColumnHeader)
  or (cxGrid1TableView1.ViewInfo.GetHitTest(X, Y).HitTestCode = htColumnHeaderHorzSizingEdge)
  or (cxGrid1TableView1.DataController.focusedRecordIndex < 0)
  then begin
    if (Button = mbRight) then
      pupView.Popup(frmMain.Left + X, frmMain.Top + Y + 110);
    exit;
  end;
  //
  if (Button = mbLeft) and (Shift = [ssLeft])
  and not (cxGrid1TableView1.OptionsCustomize.ColumnFiltering) then
    TcxGridSite(Sender).BeginDrag(False);
  //
  if (Button = mbRight) and Not oneYrLocked
  and (cxGrid1TableView1.DataController.RowCount > 0)
  and (cxGrid1TableView1.DataController.CustomDataSource = TradeRecordsSource)
  then begin
    if TabAccounts.TabIndex > 0 then
      pupEdit.Popup(frmMain.Left + X, frmMain.Top + Y + 110);
  end
  else if not OneYrLocked and (TabAccounts.TabIndex = 0) and (Button = mbRight)
  then
    pupAllTab.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
end;


procedure TfrmMain.cxGrid1TableView1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
 HT: TcxCustomGridHitTest;
begin
  if isFormOpen('frmExerciseAssign') then begin
    //cancelDrag;
    TfrmExerciseAssign(GetFormIfOpen('frmExerciseAssign')).MainGridClicked;
    exit;
  end;
  with TcxGridSite(Sender) do begin
    if (Button = mbLeft) and (Shift = []) then begin
      HT := ViewInfo.GetHitTest(X, Y);
      if (HT is TcxGridRecordCellHitTest)
      and (TcxGridRecordCellHitTest(HT).GridRecord.RecordIndex
        = GridView.DataController.FocusedRecordIndex)
      then
        CancelDrag;
    end;
  end;
end;


procedure TfrmMain.cxGrid1TableView1SelectionChanged(
  Sender: TcxCustomGridTableView);
var
  i, aRow, aRec: Integer;
  shOpen, contrOpen, nPL, nCM : Double;
  aRowInfo : TcxRowInfo;
begin
  if isFormOpen('frmExerciseAssign') then begin
    //calc open shares
    shOpen := 0;
    contrOpen := 0;
    with cxGrid1TableView1.DataController do begin
      for i := 0 to  GetSelectedCount - 1 do begin
        aRow := GetSelectedRowIndex(i);
        aRowInfo := GetRowInfo(aRow);
        aRec := aRowInfo.RecordIndex;
        if (pos('OPT',values[aRec,9])=1) then
          contrOpen := contrOpen + values[aRec,7]
        else
          shOpen := shOpen + values[aRec,7];
      end;
    end;
    dispProfit(false, 0, shOpen, contrOpen, 0);
    exit;
  end
  else if cxGrid1TableView1.DataController.GetSelectedCount > 1 then begin
    shOpen := 0;
    contrOpen := 0;
    nPL := 0; // ** NEW **
    nCM := 0; // ** NEW **
    with cxGrid1TableView1.DataController do begin
      for i := 0 to GetSelectedCount-1 do begin
        aRow := GetSelectedRowIndex(i);
        aRowInfo := GetRowInfo(aRow);
        aRec := aRowInfo.RecordIndex;
        if (pos('OPT',values[aRec,9])=1) then begin
          if values[aRec, 4] = 'O' then
            contrOpen := contrOpen + values[aRec,7]
          else if values[aRec, 4] = 'C' then
            contrOpen := contrOpen - values[aRec,7];
        end
        else begin
          if values[aRec, 4] = 'O' then
            shOpen := shOpen + values[aRec, 7]
          else if values[aRec, 4] = 'C' then
            shOpen := shOpen - values[aRec, 7];
        end;
        nPL := nPL + values[aRec,12]; // 2025-02-05 MB (11=Amt, 12=P/L)
        nCm := nCm + values[aRec,10]; // ** NEW **
      end;
    end;
    dispProfit(false, nPL, shOpen, contrOpen, nCm); // ** CHANGED **
    exit;
  end; //
end;


procedure TfrmMain.cxGrid1TableView1StartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
//  if EditRec or addRec then
//    Dragmode := dmManual;
end;


procedure TfrmMain.cxGrid1TableView1TopRecordIndexChanged(Sender: TObject);
begin
  if addRec then exit;
  cxGrid1.layoutchanged;
end;


procedure TfrmMain.Fix1Click(Sender: TObject);
var
  Trades: TTradeList;
  I: Integer;
  r: Integer;
  Msg: String;
begin
  if oneYrLocked or isAllBrokersSelected then exit;
  if not CheckRecordLimit then exit;
  if cxGrid1TableView1.DataController.GetSelectedCount = 0 then
    Msg := 'WARNING: You are about to run fix trades out of order on an entire account'
    + cr + cr
  else Msg := 'Fix trades out of order intra-day?' + cr + cr;
  if Not TradeLogFile.NoTimeInData then begin
    Msg := Msg +
      'This function only works when there is no time of day. Please try' + cr +
      'Edit, Force Match Trades instead, unless there are only a few time stamps.'
      + cr + cr;
  end;
  if mDlg(Msg + 'This will put all open longs first, followed by open shorts,' +
    cr + 'followed by close longs and close shorts, intra-day.' + cr + cr +
    'Are you sure you want to do this?', mtWarning, [mbNo, mbYes], 0) <> mrYes
  then exit;
  if cxGrid1TableView1.DataController.GetSelectedCount > 0 then begin
    Trades := TTradeList.Create;
    try
      for I := 0 to cxGrid1TableView1.DataController.GetSelectedCount - 1 do
      begin
        r := cxGrid1TableView1.DataController.GetRowInfo
          (cxGrid1TableView1.DataController.GetSelectedRowIndex(I)).RecordIndex;
        Trades.add(TradeLogFile[r]);
      end;
      TradeLogFile.Match(Trades, false, True);
      TradeLogFile.Reorganize;
    finally
      Trades.Free;
    end;
  end
  else
    TradeLogFile.MatchAndReorganize(True);
  try
    cxGrid1TableView1.DataController.clearSelection;
    TradeRecordsSource.DataChanged;
    SaveTradeLogFile('Fix trades out of order');
  finally
    FindTradeIssues;
    repaintGrid;
  end;
end;


// ------------------------------------
procedure TfrmMain.mnuAcct_ImportClick(Sender: TObject);
var
  newPath : String;
  newFiles : TStringList;
  FileName : String;
  I : Integer;
  Success : Boolean;
  F : TdlgCanProHelp;
begin
  // 2020-07-15 MB - Warning dialog ---
  F := TdlgCanProHelp.Create(nil);
  if F.showmodal = 1 then
    F.Free
  else begin
    F.Free;
    exit;
  end;
  // ----------------------------------
  if not CheckRecordLimit then Exit;
  newPath := '';
  newFiles := TStringList.Create;
  Success := True;
  try
    try
      If OpenFileDialog('TradeLog data files (*.tdf)|*.tdf', Settings.DataDir,
        'Please select existing TradeLog Data Files', newPath,
        newFiles, true, False) = False then exit;
      newFiles.Sort;
      bImportingAccounts := true;
      for I := 0 to newFiles.Count - 1 do begin
        FileName := newFiles[I];
        if FileExists(newPath + '\' + Filename) then begin
          try
            // ADD FILE -->
            GetDataVersion(newPath +'\'+ Filename); // see note
            // we don't care about the return, we just want to set isDBfile
            Success := TradeLogFile.CombineFile(newPath+'\'+ FileName);
          except
            on E: ETLFileCurrencyException do begin
              mDlg(E.Message + CR + CR
                + 'You can only add files with the same currency type.',
                mtError, [mbOK], 0);
              exit;
            end;
            on E: ETLFileCombineException do begin
              if mDlg(E.Message + cr + cr
                + ' Would you like to skip this file and continue? ',
                mtInformation, [mbYes, mbNo], 0) <> mrYes then exit;
            end;
            on E: ETLFileMultiAccountImportException do begin
              mDlg(E.Message, mtError, [mbOK], 0);
              LoadRecords;
              exit;
            end;
            on E: ELTFileInvalidYearException do begin
              mDlg(E.Message, mtError, [mbOK], 0);
              LoadRecords;
              exit;
            end;
          end;
        end
        else begin
          mDlg('File does not exist: ' + FileName + cr, mtError, [mbOK], 0);
          exit;
        end;
      end;
      if Not Success then begin
        LoadRecords;
        exit;
      end;
      TradeLogFile.Reorganize;
      SaveTradeLogFile('Account Import', True);
      LoadRecords;
      AddExistingAcct := true;
    except
      On E: ETLFileException do begin
        mDlg(E.Message, mtError, [mbOK], 0);
        exit;
      end;
      on EInOutError do begin
        mDlg('One of the Files Is Already Open.' + cr + cr
          + 'Please Close It First!', mtError, [mbOK], 0);
        exit;
      end;
      on E: Exception do begin
        mDlg('Error: ' + E.Message, mtError,[mbOK], 0);
        exit;
      end;
    end;
  finally
    bImportingAccounts := false;
    newFiles.Free;
    AddExistingAcct := false;
    statBar('off');
  end;
end;


procedure TfrmMain.Add2Click(Sender: TObject);
begin
  tabAccounts.SetFocus;
  if not CheckRecordLimit then Exit;
  AddNewAccount;
end;


function TfrmMain.AddNewAccount(bSaveFile : Boolean): Integer;
var
  Header : TTLFileHeader;
begin
  Header := TTLFileHeader.Create(TradeLogFile);
  if TdlgAccountSetup.Execute(Header, True, //
    Header.MTMLastYear, Header.MTM, // previously, all of this
    'Add New Account' //         was assumed (overload)
  ) = mrOK then begin
    try
      TradeLogFile.AddAccount(Header);
    except
      on E : ETLFileCurrencyException do
        mDlg(E.Message + CR + CR
          + 'You can only add accounts with the same currency type.', mtError, [mbOK], 0);
      on E : Exception do
        raise E;
    end;
    if bSaveFile then SaveTradeLogFile('Add New Account', True);
    SetupTabs;
    ChangeToTab(Header.AccountName);
    // offer to call import settings if broker is "fastlinkable"
    if (TradeLogFile.CurrentAccount.importFilter.FastLinkable) then begin
      if mDlg('This broker supports BrokerConnect' + CRLF //
        + 'Would you like to set that up now?',
        mtConfirmation, mbYesNo, 0) = mrYes
      then
        EditCurrentImport(''); // import settings
      SetupToolBarMenuBar(false);
    end;
    // finally, call baseline wizard when creating new account tab
    if baselineWizardOn then begin
      mnuBaselinePositionWizard.click; // mnuBaselinePositionWizardClick;
    end;
    Exit(Header.BrokerID);
  end
  else begin
    Header.Free;
    Exit(-1);
  end;
end;


procedure TfrmMain.mnuAcct_AddClick(Sender: TObject);
begin
  if not CheckRecordLimit then Exit;
  AddNewAccount;
end;


procedure TfrmMain.AddRecord1Click(Sender: TObject);
begin
  AddRecord; // 2023-05-01 MB replaces frmMain.btnAddRec.Click;
end;

procedure TfrmMain.InsertRecord1Click(Sender: TObject);
begin
  InsertRecord;
//  frmMain.btnInsRec.Click;
end;

procedure TfrmMain.InvalidTickers1Click(Sender: TObject);
var
  Tickers: String;
begin
  Tickers := TradeLogFile.GetInvalidOptionTickers;
  if Length(Tickers) > 0 then begin
    filterByItemNumber(Tickers);
    panelMsg.showMsgPanel(mtInvalidTickers);
  end
  else
    mDlg('No Invalid Option Tickers Found', mtInformation, [mbOK], 0);
end;

procedure TfrmMain.Futures1Click(Sender: TObject);
begin
  filterByType('FUT', True);
end;


procedure TfrmMain.ChangeOptionTickers1Click(Sender: TObject);
begin
  if oneYrLocked or IsAllBrokersSelected then exit;
  if not CheckRecordLimit then exit;
  ChangeOptTicker;
end;

procedure TfrmMain.cxGrid1TableView1DataControllerCompare
  (ADataController: TcxCustomDataController; ARecordIndex1, ARecordIndex2,
  AItemIndex: Integer; const V1, V2: Variant; var Compare: Integer);
var
  myV1, myV2: string;
begin
  // ticker sort for wash sales 2011-11-05 DE
  if (AItemIndex = 6) then begin
  // and (VarType(V1) = VarType(V2))   caused routine to fail in D2010
  // and (VarType(V1) = varString)
    // if option compare underlying stock ticker
    myV1 := V1;
    myV2 := V2;
    if  (pos('OPT', ADataController.values[ARecordIndex1, 9]) = 1)
    and (pos('OPT', ADataController.values[ARecordIndex2, 9]) = 1) then begin
      // this puts all stocks first, then options which are sorted by date
      if pos(' ', V1) > 1 then myV1 := copy(V1, 1, pos(' ', V1) - 1);
      if pos(' ', V2) > 1 then myV2 := copy(V2, 1, pos(' ', V2) - 1);
    end;
    // sm(ADataController.values[ARecordIndex1,9]+cr+ADataController.values[ARecordIndex2,9]+cr+myV1+' - '+myV2);
    Compare := VarCompare(myV1, myV2);
  end
  // Type/Mult sort
  else if (AItemIndex = 9) then begin
  // and (VarType(V1) = VarType(V2))
  // and(VarType(V1) = varString)
    // grab 1st 3 chars of Type/Mult
    myV1 := copy(V1, 1, 3);
    myV2 := copy(V2, 1, 3);
    Compare := VarCompare(myV1, myV2);
  end
  else
    // compare values in other columns
    Compare := VarCompare(V1, V2);
end;


procedure TfrmMain.cxGrid1TableView1FilterDialogShow
  (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
  var ADone: Boolean);
begin
  repaintGrid;
end;

procedure TfrmMain.cxGrid1TableView1FocusedItemChanged
  (Sender: TcxCustomGridTableView;
  APrevFocusedItem, AFocusedItem: TcxCustomGridTableItem);
begin
  AFocusedItem.editing := true;
end;

// ----------------
//   Back Office
// ----------------
procedure TfrmMain.btnBackOfficeClick(Sender: TObject);
var
  i : Integer;
  f : TdlgBackOffice;
  s : string;
begin
  // --- check for invalid use --------
  f := TdlgBackOffice.Create(nil);
  try
    // ----------------------------------------------------
    // initialize
//
    // ----------------------------------------------------
    // show dialog, get inputs
    if f.showmodal = mrOK then begin
      //
    end
    else begin
      exit; // jump to FINALLY block
    end;
    // --- do selection -------
    screen.Cursor := crHourglass;
    s := ''; // clear, use for error message if any
  finally
    f.Free;
    screen.Cursor := crDefault; // don't leave crHourglass!
  end;
end; // btnBackOffice


procedure TfrmMain.BackupRestore1Click(Sender: TObject);
begin
  if not CheckRecordLimit then exit;
  if TBackupRestoreDlg.Execute = mrOK then begin
    SaveLastFileName(TrFileName);
    if panelSplash.visible then panelSplash.SetupForm;
  end;
end;


procedure TfrmMain.mnuBaselinePositionWizardClick(Sender: TObject);
begin
  getImpDateLast;
  if (strToDate(ImpDateLast,Settings.internalFmt) > strToDate('12/31/'+lastTaxYear,Settings.internalFmt))
  then begin
    if mDlg('Baseline Position Wizard can no longer be used because' + cr //
          + 'trades have been imported up to ' + ImpDateLast + '.' + cr //
          + cr //
          + 'If you need to enter missing Baseline position(s),' + cr //
          + 'you may press the function key [F7].' + cr //
          + cr //
          + 'Do you want to do that now?' + cr //
          , mtInformation, [mbYes,mbNo], 1) = mrYes
    then
      EnterBeginYearPrice; // EnterOpenPositions1.Click;
    exit;
  end;
  if TradeLogFile.CurrentAccount.MTM
  and TradeLogFile.CurrentAccount.MTMLastYear then begin
    if mDlg('Please manually enter your Baseline positions.' + cr //
        + cr //
        + 'You may do that at any time by pressing the' + cr //
        + '[F7] function key shortcut.' + cr //
        + cr //
        + 'Do you want to do that now?' + cr //
        , mtInformation, [mbYes,mbNo], 1) = mrYes
    then
      EnterBeginYearPrice; // EnterOpenPositions1.Click;
    exit;
  end;
  pnlBaseline := TpnlBaseline.Create(frmMain);
  pnlBaseline.Show;
end;


// --------------------------------------------------------
// How to compute new price from change amount:
// GIVEN: origAmt = (pr * (sh * mul)) + com
// and (origAmt + adjAmt) = ((pr + adjPr) * (sh * mul)) + com
// THEN it follows that
//   (origAmt + adjAmt) = (pr * (sh * mul)) + (adjPr * (sh * mul)) + com
// and therefore
//   adjAmt = (pr * (sh * mul)) + (adjPr * (sh * mul)) + com - origAmt
// but substituting equation #1 for origAmt we get
//   adjAmt = [(pr * (sh * mul)) + (adjPr * (sh * mul)) + com] - [(pr * (sh * mul)) + com]
// we cancel out the com - com to get this
//   adjAmt = [(pr * (sh * mul)) + (adjPr * (sh * mul))] - [(pr * (sh * mul))]
// then we cancel the (pr * (sh * mul)) to get
//   adjAmt = (adjPr * (sh * mul))
// So, solving for adjPr gives us
//   adjPr = adjAmt / (sh * mul)
procedure TfrmMain.mnuEdit_AdjustAmountClick(Sender: TObject);
var
  i, rec: integer;
  EditedTrades: TTradeList;
  sh, pr, mult, adjAmt, adjPr: double;
  f: TdlgAdjCostBasisAmt;
  bSh: boolean;
begin
  // pop up menu asking for dollar amount to adjust
  // calculate price change, then modify price field
  //   adjPr = adjAmt / (sh * mul)
  try
    // is TradeLog locked down?
    if (TradeLogFile.Count = 0) or isAllBrokersSelected then exit;
    if not CheckRecordLimit or oneYrLocked then Exit;
    // --- CAN we modify this(these) trade(s)? ---
    with frmMain.cxGrid1TableView1.DataController do begin
      for i := 0 to GetSelectedCount - 1 do begin
        rec := GetRowInfo(GetSelectedRowIndex(i)).RecordIndex;
        if NOT (IsStockType(TradeLogFile[rec].TypeMult) //
        or (POS('VTN', TradeLogFile[rec].TypeMult)=1)) then begin
          mDlg('This function is only for stock type trades.', mtError, [mbOK], 0);
          exit;
        end;
      end; // for
    end; // with
    // -------- get change in amount ------------
    f:= TdlgAdjCostBasisAmt.create(nil);
    if f.showmodal = mrOK then begin
      adjAmt := f.AdjustAmount;
      bSh := f.bPerShare;
     end;
    f.free;
    // save function text for undo
    SaveTradesBack('Adjust Cost Basis Amount');
    EditRec := true;
    // ------- now modify selected records ------
    EditEnable;
    readFilter;
    with frmMain.cxGrid1TableView1.DataController do begin
      for i := 0 to GetSelectedCount - 1 do begin
        rec := GetRowInfo(GetSelectedRowIndex(i)).RecordIndex;
        // get component values from TradeLogFile instead of Grid - 3/21/2014 MB
        sh := TradeLogFile[rec].Shares;
        pr := TradeLogFile[rec].Price;
        mult := TradeLogFile[rec].Multiplier;
        if bSh then
          adjPr := adjAmt
        else
          adjPr := adjAmt/(sh * mult);
        // insert into grid
        TradeLogFile[rec].Price := (pr + adjPr);
      end;
      ClearSelection;
      // turn off grid updates
      cxGrid1TableView1.DataController.BeginUpdate;
      // save changes
      saveGridData(false);
      gridEscape;
      // put back whatever filter user had when he started
      writeFilter(true);
      cxGrid1TableView1.DataController.EndUpdate;
      // reselect whatever grid row was selected at the start
    end;
  finally
    screen.cursor := crDefault; // because EndUpdate triggers something
    // which leaves crHourglass cursor!
  end;
end; // mnuEdit_AdjustAmountClick


procedure TfrmMain.AssignStrategy1Click(Sender: TObject);
begin
  if not CheckRecordLimit then Exit;
  AssignStrategy.Position := poMainFormCenter;
  with cxGrid1TableView1.DataController do begin
    if GetSelectedCount > 0 then begin
      if AssignStrategy.StrategyCount > 0 then AssignStrategy.ShowModal;
    end
    else
      sm('There are no items selected at this time.');
  end;
  frmMain.SetFocus;
end;


procedure TfrmMain.ChangeStockDescrtoTickerSymbol1Click(Sender: TObject);
begin
  ChangeStockDescrtoTickerSymbol;
end;


procedure TfrmMain.stUpdateMsgMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  // 2014-05-27 this code no longer used
end;


procedure TfrmMain.tabAccountsChange(Sender: TObject);
var
  AccountName : String;
  P : TPoint;
begin
  AccountName := tabAccounts.Tabs[tabAccounts.TabIndex].Caption;
  try
    if SettingUpTabs then exit;
    screen.cursor := crHourGlass;
    // If in the process of entering or editing a record in another grid
    // and user clicks another tab, roll back changes before switching.
    if EditRec or insertRec or addRec then begin
      if EditRec then begin
        EditDisable(False);
        TradeLogFile.Revert;
        TradeRecordsSource.DataChanged;
      end
      else begin
        cxGrid1TableView1.DataController.DeleteSelection;
      end;
      EditRec := False;
      InsertRec := False;
      AddRec := False;
    end;
    if tabAccounts.TabIndex = 0 then begin
      TradeLogFile.CurrentBrokerID := 0;
      clearFilter;
    end
    else begin
      TradeLogFile.CurrentBrokerID := TradeLogFile.BrokerIDByName[AccountName];
      // clear Filter will clear the filter then add back the broker filter
      // Since this is always necessary there never really is a clear filter,
      // unless you are on the all tab. Also clear filter will always add the
      // display wash sales option to the filter as well.
      ClearFilter;
    end;
    screen.cursor := crHourGlass;
    {Broker column should be visible when on the all tab.}
    cxGrid_16_br.Visible := (tabAccounts.TabIndex = 0);
    // Set griddisplay to blank string so that NegShares message will
    // popup if neg shares exist for a given account or for all tab.
    GridFilter := gfNone;
    SetAccountOptions;
    StatBarAccountType;
    //if UserChangedTab and not OpeningFile then //btnShowAll.Click;
    FindTradeIssues;
    dispProfit(true,0,0,0,0);
    UserChangedTab := False;
    // Disable menu items when on the all tab
    // Also calls Setup Reports Menu
    if not TradeLogFile.YearEndDone //
    and not TradeLogFile.RecordLimitExceeded then begin
      // do not enable menus if TaxIDver and file not converted
      if taxIDver then begin
        if (iVer <> -9) then SetupToolBarMenuBar(False)
      end
      else begin
        SetupToolBarMenuBar(False);
      end;
    end;
    if oneYrLocked then doOneYrLockout;
    checkForBaks;
    // --- 2021/11/05 MB - NEW: Broker Import instructions in panelQS
    if (AccountName = 'All Accounts') then begin
      btnImportHelp.Enabled := false;
      btnImportHelp.Caption := 'Help for Import';
    end
    else begin
      btnImportHelp.Enabled := true;
      btnImportHelp.Caption := 'Help for ' + TradeLogFile.CurrentAccount.FileImportFormat;
    end;
  finally
    screen.cursor := crDefault;
    // TabAccountsChange
  end;
end;


procedure TfrmMain.tabAccountsMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  Idx : Integer;
begin
  if Button = TMouseButton.mbRight then begin
    Idx := tabAccounts.TabAtPos(X, Y);
    if (Idx > -1) then begin
      if (Idx <> TabAccounts.TabIndex)
      and (Idx < TabAccounts.Tabs.Count - 1) then begin
        TabAccounts.TabIndex := Idx;
        TabAccountsChange(Sender);
      end;
      if (Idx < TabAccounts.Tabs.Count - 1) then
        pupAccount.Popup(Left + X + 10,Top + pnlMain.Top  + pnlBlue.Top + TabAccounts.Height + 10);
    end;
  end
  else
    UserChangedTab := True;
end;


procedure TfrmMain.MakeGLCalendarYear(First, Last: Variant);
var
  NewMin, NewMax {, OldMin, OldMax }: Tdate;
begin
  If (First = null) or (First <= xStrToDate('1/1/1900')) then
    NewMin := xStrToDate('01/01/' + TaxYear)
  else
    NewMin := First;
  // end if First...
  If (Last = null) or  (Last <= xStrToDate('1/1/1900')) then
    NewMax := xStrToDate('12/31/' + TaxYear)
  else
    NewMax := Last;
  // end if Last...
  glStartDate.date := NewMin;
  glEndDate.date := NewMax;
  glStartDate.properties.minDate := NewMin;
  glEndDate.properties.minDate := NewMin;
  glEndDate.properties.maxDate := NewMax;
  glStartDate.properties.maxDate := NewMax;
end;


procedure TfrmMain.TabAccountsChanging(Sender: TObject; NewIndex: Integer;
  var AllowChange: Boolean);
begin
  AllowChange := TabAccounts.Tabs[NewIndex].Caption <> '+';
  if not AllowChange then
    pupPlusBtn.Popup(Mouse.CursorPos.X, Top + pnlMain.Top  + pnlBlue.Top + TabAccounts.Height + 10)
  else begin
    TabAccounts.Tabs[NewIndex].Color := TabAccounts.TabColors.Shadow;   //.HighlightBar;
    if (TabAccounts.TabIndex > -1) then
      TabAccounts.Tabs[TabAccounts.TabIndex].Color := TabAccounts.TabColors.Unselected;
    LastTabIndex := tabAccounts.TabIndex;
    bbFind_FindInstrument.EditValue := ''; //reset the checkboxes to false
  end;
end;


Function TfrmMain.GetIRS_SSN(Warn: Boolean): Boolean;
begin
  If Settings.IsEin then
    Result := (Length(Settings.SSN) = 10)
  else
    Result := (Length(Settings.SSN) = 11);
end;

function TfrmMain.GetWindowsTempPath: String;
var
  I: DWord;
begin
  SetLength(Result, MAX_PATH);
  I := GetTempPath(MAX_PATH, Pchar(Result));
  SetLength(Result, I);
  Settings.RemoveTrailingBackSlash(Result);
end;



function TfrmMain.UpdateFutureList(symbol, multStr: string) : Double;
var
  space: string;
  spacePosition, I: Integer;
  futureItem: PFutureItem;
  FutureList: TList;
  Found: Boolean;
begin
  Result := 0;
  Found := False;
  if symbol <> EmptyStr then begin
    symbol := changeFutSymbol(symbol);
    spacePosition := pos(' ', symbol);
    if spacePosition <> 0 then
      symbol := copy(symbol, 1, spacePosition - 1);
    {At this point of the symbol is empty then it was an invalid symbol, dont add a blank to the futures list}
    if Symbol = EmptyStr then exit;
    FutureList := Settings.FutureList;
    for I := 0 to FutureList.Count - 1 do begin
      futureItem := Settings.FutureList[I];
      if Trim(futureItem.Name) = symbol then begin
        if FutureItem.Value <>  StrToFloat(multStr, Settings.UserFmt) then begin
          if (mDlg(symbol + cr + 'mult = ' + multStr + cr //
            + cr //
            + ' The above imported futures multiplier' + cr //
            + 'does not match the Trade Type futures multiplier' + cr //
            + 'mult = ' + floatToStr(FutureItem.Value, Settings.InternalFmt) + cr //
            + cr //
            + 'Change Trade Type futures multiplier to match?' + cr,
            mtConfirmation, [mbYes, mbNo], 0) = mrYes)
          then
            futureItem.Value := StrToFloat(multStr, Settings.UserFmt)
          else
            Result := FutureItem.Value;
        end;
        Found := True;
        break;
      end
    end;
    if not Found then begin
      mDlg('Futures symbol: ' + Symbol + ' was not found in global Futures list' + CR //
        + CR //
        + 'It has therefore been added to the list with a multiplier of ' + MultStr,
        mtInformation, [mbOK], 0);
      new(futureItem);
      futureItem.Name := symbol;
      futureItem.Value := StrToFloat(multStr, Settings.UserFmt);
      FutureList.Add(futureItem);
    end;
    Settings.FutureList := FutureList;
  end;
end;


// --------------------------
// DoStatus ends up here.
// --------------------------
procedure TfrmMain.UpdateStatus(Msg: String; hint: String; color: TColor);
begin
  if Msg = 'off' then begin
    stUpdateMsg.hint := '';
    stUpdateMsg.FillColor := clScrollBar;
    stUpdateMsg.FlatColor := clBtnFace;
    stUpdateMsg.Font.Style := [];
    stUpdateMsg.color := clBtnFace;
    stUpdateMsg.Caption := '';
    stUpdateMsg.Visible := False;
    rbStatusBar.Panels[2].Text := '';
    rbStatusBar.Panels[2].Width := 55;
  end
  else begin
    stUpdateMsg.FillColor := color;
    stUpdateMsg.FlatColor := color;
    stUpdateMsg.Caption := Msg;
    stUpdateMsg.Font.Style := [fsBold];
    stUpdateMsg.hint := hint;
    stUpdateMsg.Visible := True;
    rbStatusBar.Panels[2].Text := Msg;
    rbStatusBar.Panels[2].Visible := true;
    rbStatusBar.Panels[2].Width := 150;
  end;
  Application.ProcessMessages;
end;


procedure TfrmMain.bindStrategy();
begin
  with frmMain.cxGrid_19_Strategy.properties as TcxComboBoxProperties do
  begin
    if FileExists(Settings.StrategyOptionsFile) and
      (Settings.FileSze(Settings.StrategyOptionsFile) > 0) then
      Items.LoadFromFile(Settings.StrategyOptionsFile);
    {2014-01-22 no need for this message, pops up when first running TL and creates confusion
    else
      mDlg('WARNING: Strategy Options file is empty or could not be found!' +
          cr + cr + 'This will not stop you from using the application,' +
          cr +
          'but you will not see a list of Strategies in the Strategy drop down'
          + cr +
          'until you restart TradeLog while connected to the Internet, allowing the' +
          cr + 'default Strategies config file to be downloaded.', mtWarning,
        [mbOK], 0);
    }
    if (Items.Count = 0) or ((Items.Count > 0) and (Items.Names[0] <> 'None'))
      then
      Items.Insert(0, 'None');
  end;
end;

procedure TfrmMain.SetChartParams(NewSel: Boolean = true);
var
  DoNewSel, RowLacksTime: Boolean;
  I: Integer;
  ShCon: string;
begin
  if (TradeLogFile.CurrentBrokerID > 0) and (TradeLogFile.CurrentAccount.FileImportFormat = 'Globex') then
    ShCon := 'Contract'
  else
    ShCon := 'Share';
  spdRunReport.Enabled := true;
  DoNewSel := NewSel or not(rbStandard.checked or rbTickCompare.checked);
  with cbParameter.Items do begin
    if DoNewSel then Clear;
    if rbStandard.checked then begin
      cbInterval.Enabled := true;
      cbInterval.Visible := true;
      lblFreq.Enabled := true;
      lblFreq.Caption := 'Frequency:';
      if DoNewSel then begin
        Add('Profit/Loss');
        Add('Purchases/Sales');
        Add('Commission');
        Add('');
        Add(ShCon + 's Closed');
        Add('');
        Add('Ave Prof/Loss Per ' + ShCon);
        Add('Ave Prof/Loss Per Trade');
        Add('Ave # ' + ShCon + 's Per Trade');
        Add('');
        Add('% Total ' + ShCon + 's Closed');
      end;
    end
    else if rbTickCompare.checked or rbStrategy.checked then begin
      cbInterval.Visible := False;
      cbTickType.Enabled := rbTickCompare.checked;
      lblFreq.Enabled := rbTickCompare.checked;
      if rbTickCompare.checked then
        lblFreq.Caption := 'For:';
      if DoNewSel then begin
        Add('Profit/Loss');
      end;
    end
    else begin
      cbInterval.Enabled := False;
      cbInterval.Visible := true;
      lblFreq.Enabled := False;
      lblFreq.Caption := 'Frequency:';
      if cbWin.checked and cbLose.checked then begin
        Add('Total Profit OR Loss');
        Add('Total Profit AND Loss');
        Add('Ave Profit OR Loss');
        Add('Ave Profit AND Loss');
      end
      else if cbWin.checked then begin
        Add('Total Profit');
        Add('Ave Profit');
      end
      else if cbLose.checked then begin
        Add('Total Loss');
        Add('Ave Loss');
      end
      else begin
        spdRunReport.Enabled := False;
      end;
    end;
  end;
  if DoNewSel then begin
    cbParameter.ItemIndex := 0;
    cbTickType.ItemIndex := 0;
  end;
  cbTickType.Visible := not(cbInterval.Visible);
  btnTODsetup.Visible := rbTimeDay.checked;
  if btnTODsetup.Visible then
    with cxGrid1TableView1.ViewData do begin
      if RowCount > 0 then begin
        RowLacksTime := False;
        for I := 0 to RowCount - 1 do begin
          if Rows[I].values[3] = '' then begin
            RowLacksTime := true;
            Break;
          end;
        end;
        if RowLacksTime then lblInclude.Visible := true;
      end;
    end
    else
      lblInclude.Visible := False;
end;


procedure TfrmMain.Splitter1CanResize(Sender: TObject; var NewSize: Integer;
  var Accept: Boolean);
begin
  if NewSize < 27 then Accept := False;
end;


procedure TfrmMain.StatBarAccountType;
var
  nPts : double;
begin
  stAcctType.Visible := True;
  rbStatusBar.Panels[3].Visible := true;
  stAcctType.Hint := 'Selected Account Type';
  stAcctType.Caption := ' '+TradeLogFile.CurrentAcctType;
  rbStatusBar.Panels[3].Text := ' '+TradeLogFile.CurrentAcctType;
  if (tabAccounts.TabIndex > 0) then begin
    stImportType.Visible := true;
    rbStatusBar.Panels[4].Visible := true;
    stImportType.Left := 200;
    stImportType.AutoSize := true;
    stImportType.Hint := 'Selected Account Name';
    // ----------------------
    stImportType.Caption := TradeLogFile.CurrentAccount.FileImportFormat; // 2021-05-12 MB
    nPts := stImportType.Width; // let Raize compute width
    rbStatusBar.Panels[4].Width := CEIL(nPts); // 2021-06-04 MB - adjust width to fit text
    rbStatusBar.Panels[4].Text := TradeLogFile.CurrentAccount.FileImportFormat; // 2021-05-12 MB
    rbStatusBar.Panels[4].Visible := true;
    // ----------------------
    stAcctName.Caption := TradeLogFile.CurrentAccount.AccountName; // 2021-05-12 MB
    nPts := stAcctName.Width; // let Raize compute width
    rbStatusBar.Panels[5].Width := CEIL(nPts); // 2021-06-04 MB - adjust width to fit text
    rbStatusBar.Panels[5].Text := TradeLogFile.CurrentAccount.AccountName; // 2021-05-12 MB
    rbStatusBar.Panels[5].Visible := true;
  end
  else begin
    stImportType.Visible := false;
    rbStatusBar.Panels[4].Visible := false;
    stAcctName.Visible := false;
    rbStatusBar.Panels[5].Visible := false;
  end;
end;


//procedure TfrmMain.StatRecsLimitClick(Sender: TObject);
//begin
//  if (pos('UNLIMITED', stRecsLimit.Caption)=0) then
//    webURL(secureSiteURL + 'purchase/?regcode=' + Settings.RegCode);
//end;


procedure TfrmMain.statRegDaysLeftClick(Sender: TObject);
begin
  if (stRegDaysLeft.fillColor = tlYellow) or (stRegDaysLeft.fillColor = clRed)
  then begin
    webURL(secureSiteURL + 'purchase/?regcode=' + Settings.RegCode);
  end;
end;


procedure TfrmMain.statRegTxtClick(Sender: TObject);
begin
  if stRegDaysLeft.fillColor = tlYellow then begin
    webURL(secureSiteURL + 'purchase/?regcode=' + Settings.RegCode);
    close;
  end;
end;

// ================================= //
//         REPORTS MENU ITEMS        //
// ================================= //

//// TAX ANALYSIS

procedure set1099ReconBoxes;
var
  s, t : string;
  b1, b2, b3, bFound : boolean;
  // ------------------------
  function boolToCheckUncheck(b : boolean) : string;
  begin
    if b then
      result := '[x] '
    else
      result := '[ ] ';
  end;
  // ------------------------
begin
  s := TradeLogFile.CurrentAccount.FileImportFormat;
  // defaults for unknown brokers
  b1 := false; // 1. Sales Adjusted for Option Premiums
  b2 := false; // 2. Broker reports G/L instead of Proceeds for Short Options
  b3 := false; // 3. Broker reported options opened prior to 2014
  bFound := false; // haven't matched the broker yet
  if (s = 'Apex') then begin
    b1 := true;
    b2 := false;
    b3 := true;
    bFound := true;
  end
  else if (s = 'BOA') then begin
    if (TradeLogFile.TaxYear = 2017) //
    or (TradeLogFile.TaxYear >= 2019) then begin
      b1 := true;
      b2 := false;
      b3 := true;
      bFound := true;
    end
    else begin
      b1 := false;
      b2 := false;
      b3 := true;
      bFound := true;
    end;
  end
  else if (s = 'Schwab') then begin
    b1 := true;
    b2 := false;
    b3 := false;
    bFound := true;
  end
  else if (s = 'E-Trade') then begin
    if (TradeLogFile.TaxYear >= 2019) then begin
      b1 := true;
      b2 := true;
      b3 := true;
      bFound := true;
    end
    else begin
      b1 := true;
      b2 := false;
      b3 := true;
      bFound := true;
    end;
  end
  else if (s = 'Fidelity') then begin
    b1 := true;
    b2 := true;
    b3 := false;
    bFound := true;
  end
  else if (s = 'IB') then begin
    b1 := true;
    b2 := false;
    b3 := true;
    bFound := true;
  end
  else if (s = 'optionsXpress') then begin
    b1 := true;
    b2 := true;
    if TradeLogFile.TaxYear < 2015 then
      b3 := false
    else
      b3 := true;
    bFound := true;
  end
  else if (s = 'Robinhood') then begin
    b1 := true;
    b2 := true;
    b3 := false;
    bFound := true;
  end
  else if (s = 'Scottrade') then begin
    if TradeLogFile.TaxYear = 2017 then begin
      b1 := true;
      b2 := true;
      b3 := false;
      bFound := true;
    end else begin
      b1 := true;
      b2 := false;
      b3 := false;
      bFound := true;
    end;
  end
  else if (s = 'tastyworks') or (s = 'tastytrade') then begin
    if TradeLogFile.TaxYear >= 2022 then begin
      b1 := true;
      b2 := false;
      b3 := false;
      bFound := true;
    end else begin
      b1 := true;
      b2 := true;
      b3 := false;
      bFound := true;
    end;
  end
  else if (s = 'TDAmeritrade') then begin // TDA accts moved to Schwab on Sept 5, 2023
    b1 := true;
    b2 := true;
    b3 := true;
    bFound := true;
  end
  else if (s = 'TradeKing') then begin
    b1 := true;
    b2 := false;
    b3 := false;
    bFound := true;
  end
  else if (s = 'TradeStation') then begin
    b1 := true;
    b2 := true;
    b3 := true;
    bFound := true;
  end
  else if (s = 'Vanguard') then begin
    b1 := true;
    b2 := true;
    b3 := false;
    bFound := true;
  end
  else if (s = 'Webull') then begin
    if TradeLogFile.TaxYear >= 2022 then begin
      b1 := true;
      b2 := false;
      b3 := false;
      bFound := true;
    end else begin
      b1 := true;
      b2 := true;
      b3 := false;
      bFound := true;
    end;
  end;
  if bFound then begin
    // check current settings first
    if (TradeLogFile.CurrentAccount.SalesAdjOptions1099 <> b1)
    or (TradeLogFile.CurrentAccount.ShortOptGL <> b2)
    or (TradeLogFile.CurrentAccount.Options2013 <> b3) then begin
      t := 'The 1099 Recon settings are not correct for this broker' + CR
      + 'account and tax year.' + CR + CR
      + 'The correct settings for ' + s + ' are:' + CR + CR
      + '  ' + boolToCheckUncheck(b1) + '1. Sales Adjust for Options' + CR
      + '  ' + boolToCheckUncheck(b2) + '2. G/L instead of Proceeds for Short Options' + CR
      + '  ' + boolToCheckUncheck(b3) + '3. Broker reported options opened prior to 2014' + CR
      + CR + 'Would you like TradeLog to check these for you?';
      if mDlg(t, mtConfirmation, [mbYes, mbNO], 0) = mrYes then begin
        SaveTradesBack('1099 Info Fix');
        TradeLogFile.CurrentAccount.SalesAdjOptions1099 := b1;
        TradeLogFile.CurrentAccount.ShortOptGL := b2;
        TradeLogFile.CurrentAccount.Options2013 := b3;
        TradeLogFile.SaveFile(True);
      end; // if Yes
    end; // if changed
  end;
end;


procedure TfrmMain.Reconcile1099B1Click(Sender: TObject);
begin
  // determine 1099 setup for this broker
  if (TradeLogFile.CurrentBrokerID > 0)
  and (TradeLogFile.HasOptions) then
    set1099ReconBoxes;
  ReportStyle := rptRecon;
  if ReportSetup(False) = False then exit;
  DoRecon;
end;


procedure TfrmMain.WashSaleDetails1Click(Sender: TObject);
begin
  ReportStyle := rptWashSales;
  if ReportSetup(False) = False then exit;
  DisableAllReports; //
try
  SetupForGains; // 2018-03-20 MB - filter out FUT and CUR
  FilterByBrokerAccountType(False, True, True, False); // 2018-03-08 MB - Filter out MTM Accounts
  FilterInWashSales; // ...but include any WS records
  Settings.DispWSDefer := True;
  pnlTools.Visible := False;
  StartDate := xStrToDate('01/01/' + TaxYear, Settings.InternalFmt);
  EndDate := xStrToDate('12/31/' + TaxYear, Settings.InternalFmt);
  Screen.Cursor := crHourGlass;
  // 2021-09-09 MB
  startTime := time - startTime;
  spdRunReport.Enabled := false;
  pnlGains.Visible := false;
  pnlTrades.Visible := false;
  //
  RunReport(StartDate, EndDate, true);
finally
  SetupReportsMenu;
  Screen.Cursor := crDefault;
end;
end;


procedure TfrmMain.PotentialWashSales1Click(Sender: TObject);
var
  FileHeader : TTLFileHeader;
  AcctList, ChildAcctList : TcxFilterCriteriaItemList;
begin
  ReportStyle := rptPotentialWS;
  if TradeLogFile.MultiBrokerFile
  and (TradeLogFile.CurrentBrokerID <> 0) then begin
    mDlg('This report will only reflect trade activity in the single account you selected' + CR //
      + 'and therefore may not reflect your final tax reporting.' + CR + CR //
      + 'Please select the All Accounts tab and then run the Potential Wash Sales report' + CR //
      + 'to generate a complete potential wash sale analysis report, accounting for all' + CR //
      + 'taxable trade history and wash sales that may occur across accounts.',
    mtWarning, [mbOK], 0)
  end;
  if ReportSetup(False) = False then exit;
  FilterInWashSales;
  // 2018-12-18 MB - Filter out VTN when running Potential Wash Sales report
  frmMain.cxGrid1TableView1.DataController.filter.root.AddItem(
    frmMain.cxGrid1TableView1.items[9],foNotLike,'VTN*','VTN*'); // 2018-12-18 MB
  // end changes of 2018-12-18 MB
  FilterByBrokerAccountType(False, True, True, False); // 2021-10-15 MB - Filter out MTM Accounts
  Settings.DispWSDefer := True;
  pnlTools.Visible := False;
  StartDate := xStrToDate('01/01/' + TaxYear, Settings.InternalFmt);
  EndDate := xStrToDate('12/31/' + TaxYear, Settings.InternalFmt);
  if (date > EndDate) then EndDate := date; // 2020-04-27 MB
  Screen.Cursor := crHourGlass;
  //SortByTickerForWS;
  RunReport(StartDate, EndDate, true);
  // NOTE: This procedure ends with the screen.cursor := crHourglass!
end;


//// TAXES

procedure TfrmMain.Form1040ScheduleD1Click(Sender: TObject);
begin
  try
    if TradeLogFile.TaxYear > MAX_TAX_YEAR then
      mDlg('Form 8949 has NOT YET been finalized for Tax Year ' + IntToStr(TradeLogFile.TaxYear)
        + '.' + CR + CR + 'Please do not use for filing your ' + IntToStr(TradeLogFile.TaxYear)
        + ' taxes until Tradelog Final Tax version is released!', mtWarning, [mbOK], 0);
    ReportStyle := rptIRS_D1;
    SetupForGains;
  finally
    // Form1040ScheduleD1Click
  end;
end;


procedure TfrmMain.GLScheduleDD1Substitute1Click(Sender: TObject);
begin
  ReportStyle := rptSubD1;
  SetupForGains;
end;


procedure TfrmMain.Form6781Futures1Click(Sender: TObject);
begin
  // see also https://tradelog.dev/futures-sec-1256/
  try
    ReportStyle := rptFutures;
    SetupForGains;
  finally
    // Form6781Futures1Click
  end;
end;


procedure TfrmMain.ForexCurrencies1Click(Sender: TObject);
begin
  try
    ReportStyle := rptCurrencies;
    SetupForGains;
  finally
    // ForexCurrencies1Click
  end;
end;


procedure TfrmMain.Form4797MTM1Click(Sender: TObject);
begin
  try
    ReportStyle := rpt4797;
    SetupForGains;
  finally
    // Form4797MTM1Click
  end;
end;


// ----------------
// TRADE ANALYSIS
// ----------------

procedure TfrmMain.GainsLossesAllAccounts1Click(Sender: TObject);
begin
  ReportStyle := rptGAndL;
  SetupForGains(True);
end;


procedure TfrmMain.Trades1Click(Sender: TObject);
var
  I : Integer;
  dtEnd : TDate;
  sDateEnd : string;
begin
  frmMain.lblRptTitle.Caption := 'DETAIL REPORT';
  ReportStyle := rptTradeDetails;
  if ReportSetup = False then exit;
  // --------------------------------------------
  // 2021-06-28 MB - hide other visible reports
  if pnlGains.Visible then pnlGains.hide;
  if pnlChart.Visible then pnlChart.hide;
  // --------------------------------------------
  pnlTrades.show;
  if btnShowAll.Down then begin
    filterByOpenPositons(strToDate('12/31/' + TaxYear, Settings.InternalFmt), True);
  end
  else if (pos('Date', cxGrid1TableView1.DataController.Filter.filterText) < 1) then begin
    sDateEnd := '12/31/' + TaxYear;
    dtEnd := strToDate(sDateEnd, Settings.InternalFmt);
    sDateEnd := dateToStr(dtEnd,Settings.UserFmt);
    frmMain.cxGrid1TableView1.DataController.filter.root.AddItem(
      frmMain.cxGrid1TableView1.Items[2], foLessEqual, dtEnd, sDateEnd);
  end;
  {Remove all last year records for MTM Accounts.}
  FilterMTMLastYear;
  cbTrNum.checked := true;
  cbDate.Enabled := True;
  cbSubTotals.Checked := True;
  spdRunReport.Caption := 'R&un Rpt';
  sortByTradeNum;
  pnlDoReport.Visible := true;
  spdRunReport.Enabled := true;
end;


procedure TfrmMain.TradesSummaryClick(Sender: TObject);
var
  I: Integer;
  dtEnd : TDate;
  sDateEnd : string;
begin
  frmMain.lblRptTitle.Caption := 'SUMMARY REPORT';
  ReportStyle := rptTradeSummary;
  if ReportSetup = False then exit;
  pnlTrades.show;
  if btnShowAll.Down then begin
    filterByOpenPositons(strToDate('12/31/' + TaxYear, Settings.InternalFmt), True);
  end
  else if (pos('Date', cxGrid1TableView1.DataController.Filter.filterText) < 1) then begin
    sDateEnd := '12/31/' + TaxYear;
    dtEnd := strToDate(sDateEnd, Settings.InternalFmt);
    sDateEnd := dateToStr(dtEnd,Settings.UserFmt);
    frmMain.cxGrid1TableView1.DataController.filter.root.AddItem(
      frmMain.cxGrid1TableView1.Items[2], foLessEqual, dtEnd, sDateEnd);
  end;
  {Remove all last year records for MTM Accounts.}
  FilterMTMLastYear;
  cbTrNum.checked := true;
  cbDate.Enabled := False;
  cbSubTotals.Checked := True;
  spdRunReport.Caption := 'R&un Rpt';
  sortByTradeNum;
  pnlDoReport.Visible := true;
  spdRunReport.Enabled := true;
end;


procedure TfrmMain.Perf1Click(Sender: TObject);
var
  I: Integer;
begin
  ReportStyle := rptPerformance;
  if ReportSetup(False) = False then exit;
  if btnShowAll.Down then
    filterByOpenPositons(strToDate('12/31/' + TaxYear, Settings.InternalFmt), True);
//  if (frmMain.GridFilter = gfNone) then // undo changes of 1/21/2022 - MB - doesn't work!
//    filterByOpenPositons(strToDate('12/31/' + TaxYear, Settings.InternalFmt), false);
  {Remove all last year records for MTM Accounts.}
  FilterMTMLastYear;
  for I := 0 to cxGrid1TableView1.DataController.FilteredRecordCount - 1 do begin
    if I = 0 then begin
      StartDate := TradeLogFile[cxGrid1TableView1.DataController.filteredRecordIndex[I]].date;
      EndDate := TradeLogFile[cxGrid1TableView1.DataController.filteredRecordIndex[I]].date;
    end
    else begin
      if TradeLogFile[cxGrid1TableView1.DataController.filteredRecordIndex[I]].date < StartDate then
        StartDate := TradeLogFile[cxGrid1TableView1.DataController.filteredRecordIndex[I]].date;
      if TradeLogFile[cxGrid1TableView1.DataController.filteredRecordIndex[I]].date > EndDate then
        EndDate := TradeLogFile[cxGrid1TableView1.DataController.filteredRecordIndex[I]].date;
    end;
  end;
  sortByTradeNum;
  RunReport(StartDate, EndDate);
end;


procedure TfrmMain.Chart1Click(Sender: TObject);
var
  I: Integer;
  ShCon: string;
begin
  ReportStyle := rptNone;
  // 2015-04-08 changed 1/1/taxyear from userfmt to internalfmt - MB
  if (tradelogFile.LastDateImported < strtoDate('01/01/'+taxYear,Settings.InternalFmt))
  then begin
    sm('No trades in current tax year to show in chart report');
    exit;
  end else
  if (ReportSetup = False) then exit;
  if btnShowAll.Down then
    filterByOpenPositons(strToDate('12/31/' + TaxYear, Settings.InternalFmt), True);
  {Remove all last year records for MTM Accounts.}
  // --------------------------------------------
  // 2021-06-28 MB - hide other visible reports
  if pnlGains.Visible then pnlGains.hide;
  if pnlTrades.Visible then pnlTrades.hide;
  // --------------------------------------------
  FilterMTMLastYear;
  pnlChart.show;
  pnlChart.Top := 97;
  pnlChart.align := alTop;
  cbInterval.Items.Clear;
  cbInterval.Items.Add('Daily');
  cbInterval.Items.Add('Weekly');
  cbInterval.Items.Add('Monthly');
  if cbInterval.Items.Count = 6 then
    cbInterval.ItemIndex := 3
  else
    cbInterval.ItemIndex := 0;
  if (TradeLogFile.CurrentBrokerID > 0)
  and (TradeLogFile.CurrentAccount.FileImportFormat = 'Globex') then
    ShCon := 'Contract'
  else
    ShCon := 'Share';
  cbParameter.Items.Clear;
  cbParameter.Items.Add('Profit/Loss');
  cbParameter.Items.Add('Purchases/Sales');
  cbParameter.Items.Add('Commission');
  cbParameter.Items.Add('');
  cbParameter.Items.Add(ShCon + 's Closed');
  cbParameter.Items.Add('');
  cbParameter.Items.Add('Ave Prof/Loss Per ' + ShCon);
  cbParameter.Items.Add('Ave Prof/Loss Per Trade');
  cbParameter.Items.Add('Ave # ' + ShCon + 's Per Trade');
  cbParameter.Items.Add('');
  cbParameter.Items.Add('% Total ' + ShCon + 's Closed');
  cbParameter.ItemIndex := 0;
  if cxGrid1TableView1.DataController.CustomDataSource = OpenTradeRecordsSource then begin
    StartDate := cxGrid1TableView1.DataController.values[0, 2];
    EndDate := now();
  end
  else begin
    for I := 0 to cxGrid1TableView1.DataController.FilteredRecordCount - 1 do begin
      if I = 0 then begin
        StartDate := TradeLogFile[cxGrid1TableView1.DataController.filteredRecordIndex[I]].date;
        EndDate := TradeLogFile[cxGrid1TableView1.DataController.filteredRecordIndex[I]].date;
      end
      else begin
        if TradeLogFile[cxGrid1TableView1.DataController.filteredRecordIndex[I]].date < StartDate then
          StartDate := TradeLogFile[cxGrid1TableView1.DataController.filteredRecordIndex[I]].date;
        if TradeLogFile[cxGrid1TableView1.DataController.filteredRecordIndex[I]].date > EndDate then
          EndDate := TradeLogFile[cxGrid1TableView1.DataController.filteredRecordIndex[I]].date;
      end;
    end;
  end;
  if (StartDate < xStrToDate('01/01/' + TaxYear)) then
    StartDate := xStrToDate('01/01/' + TaxYear);
  spdRunReport.Caption := 'R&un Chart';
  sortByTradeNum;
  pnlDoReport.Visible := true;
  spdRunReport.Enabled := true;
end;


// ----------------------------------------------
// PURPOSE: enable/disable buttons
// DESCRIPTION: read T/F from in-memory table,
// where row = value of "Process", and each
// component is enabled (or not) by name.
// ----------------------------------------------
// To add/edit tblTabs, right-click and use the
// "Persistent Editor" (down arrow at bottom to
// add a new row; T or F + Tab to enter/edit).
// ----------------------------------------------
procedure TfrmMain.EnableTabItems(value : string);
var
  i: integer;
  comp : TComponent;
begin
  with tblTabs do begin // in-memory table component
    Open;
    while not eof do begin
      if FieldByName('Process').AsString = value then begin
        for i := 2 to tblTabs.FieldCount - 1 do begin
          comp := frmMain.FindComponent(Fields[i].FieldName);
          if comp <> nil then begin
            if comp is TdxBarLargeButton then
              TdxBarLargeButton(Comp).Enabled := Fields[i].AsBoolean
            else if comp is TdxBarButton then
              TdxBarButton(Comp).Enabled := Fields[i].AsBoolean
            else if comp is TdxBarCombo then
              TdxBarCombo(Comp).Enabled := Fields[i].AsBoolean
            else if comp is TcxBarEditItem then
              TcxBarEditItem(Comp).Enabled := Fields[i].AsBoolean
            else if comp is TcxCheckGroup then
              TcxCheckGroup(Comp).Enabled := Fields[i].AsBoolean
          end; // if comp <> nil
        end; // for i
      end; // if FieldByName
      next;
    end; // while not eof
    Close;
  end; // with tblTabs
  // ---- overrides not covered by table matrix ---------
  mtSuperUser.Visible := SuperUser;
  if oneYrLocked then doOneYrLockout; // disable some once sub expires
  if Pos('.tdf', frmMain.Caption) > 0 then // if file open,
    SetupReportsMenu; // must override EnableTabItems!
  if mtSuperUser.Visible <> SuperUser then
    mtSuperUser.Visible := SuperUser;
  if (gsInstallVer >= gsVersion) //
  and (gsInstallDate >= gsRelDate) //
  then begin
    bbHelp_Update.Enabled := false;
  end;
end;


initialization
  JclStartExceptionTracking;


finalization
  JclStopExceptionTracking;

end.

