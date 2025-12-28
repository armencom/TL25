unit FuncProc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ShellAPI, Math, Menus, StrUtils, StdCtrls, ExtCtrls, DateUtils, ZlibEx,
  TLFile, TLCommonLib, Generics.Collections, Generics.Defaults,
  TLTradeSummary, System.Variants, TlHelp32;

type

  // Function pointers
  TIntFunctionNoInpPtr = function(): integer;

  TMyQueryEventHandlers = class
    FForm: TForm;
    procedure EditKeyPress(Sender: TObject; var Key: Char);
    procedure OKBtnClick(Sender: TObject);
  public
    constructor Create(Form: TForm);
  end;

  // Allows Menu items to display hint windows since Delphi failed to implement
  TMenuItemHint = class(THintWindow)
  private
    activeMenuItem: TMenuItem;
    showTimer: TTimer;
    hideTimer: TTimer;
    procedure HideTime(Sender: TObject);
    procedure ShowTime(Sender: TObject);

  public
    constructor Create(AOwner: TComponent); override;
    procedure DoActivateHint(menuItem: TMenuItem);
    destructor Destroy; override;
  end;

  // Futures Records
  TchgdRecs = packed record
    sym: string[10];
    chngd: boolean;
  end;

  pChgdRec = ^TchgdRecs;

  // Calculated Trade Summary Record (see also TTrSum)
  TTradeSum = packed record
    tr: integer; // Trade Number
    tk: string[40]; // Ticker Symbol
    ls: string[6]; // Trade Type: L(ong) or S(hort)
    prf: string[12]; // Equity Type + Multiplier
    cm: double; // Commission
    od: string[10]; // Open Date
    cd: string[10]; // Close Date
    os: double; // Opened Shares
    cs: double; // Closed Shares
    oa: double; // Open Amount
    ca: double; // Close Amount
    ws: integer; // Wash Sale Type
    wsh: double; // Wash Sale Shares
    pr: double; // Price
    lt: string[1]; // Gain/Loss Tax Term: L(ong 365 days+) or S(hort)
    br: string[40]; // Broker (Combined files)
    opTk: string[8]; // Option Ticker
  end;

  TTradesumArray = array of TTradeSum;

  // Calculated Open Trade Record
  PTradesOpen = ^TTradesOpen;

  TTradesOpen = packed record
    tr: integer; // Trade Number
    tk: string[40]; // Ticker Symbol
    opTk: string[30]; // Option Ticker
    os: double; // Open Shares
    oa: double; // Open Amount
    ls: string[6]; // Trade Type: L(ong) or S(hort)
    prf: string[12]; // Equity Type + Multiplier
    wsa: double; // Wash Sale Amount
    m: string[1]; // Matched Tax Lots
    dt: string[10]; // Date
  end;

  TTradesOpenArray = array of TTradesOpen;

  // Accumulated Performance Report Data
  TTPerfReport = packed record
    avgPLsh: double; // Average PL per share
    avgPLtr: double; // Average PL per trade
    avgSHtr: integer; // Average shares per trade
    contracts: boolean; // Contracts instead of Shares
    diff: double; // Difference
    fltAvgSHtr: integer; // Flat Average shares per trade
    fltPercent: integer; // Flat Percentage
    fltShares: double; // Flat Shares
    lsrAvgLsh: double; // Losing Average Loss per share
    lsrAvgLtr: double; // Losing Average Loss per trade
    lsrAvgSHtr: integer; // Losing Average shares per trade
    lsrL: double; // Losses
    lsrLargest: double; // Largest Loss
    lsrPercent: integer; // Losing Percentage
    lsrShares: double; // Losing Shares
    totalComm: double; // Total Commissions
    totalCost: double; // Total Cost or other basis
    totalPl: double; // Tot Profit/Loss
    totalSales: double; // Total Sales
    totalShares: double; // Total Shares Closed
    winAvgPsh: double; // Winning Average Profit per share
    winAvgPtr: double; // Winning Average Profit per trade
    winAvgSHtr: integer; // Winning Average shares per trade
    winLargest: double; // Largest Profit
    winP: double; // Winning Profits
    winPercent: integer; // Winning Percentage
    winShares: double; // Winning Shares
  end;

  // Accumulated Gains Report Data
  TTglReport = packed record
    cs: double; // Cost or other basis
    desc: String; // Description
    dtAcq: string[10]; // Date Acquired
    dtSld: string[10]; // Date Sold
    gM03: double; // Gain May 5 for 2003 or 28% for pre 2003 page 2
    pl: double; // Profit/Loss
    sales: double; // Sales
    // added for Form 8949
    abc: string[1];
    code: string[1];
    adjG: double;
    wstriggerid: integer;
  end;

  TTglReportArray = array of TTglReport;

  // Accumulated Summary Report Data
  TTSummaryReport = packed record
    desc: String; // Description of Property
    dtAcq: integer; // Date Acquired as Integer
    dtSld: integer; // Date Sold as Integer
    Open: double; // Shares still open
    TrSales: double; // Sales Price
    TrCost: double; // Cost or other basis
    TrPl: double; // Profit/Loss
    Wash: double; // Wash sales from previous year
  end;

  TTSummaryReportArray = array of TTSummaryReport;

  // Accumulated Deferrals Report Data
  TTDeferralsReport = packed record
    OpenDesc: String; // Description Deferral attached to Open Shares
    OpenAmt: double; // Amount of Open Deferral
    JanDesc: String; // Description Deferral attached to Jan Trade
    JanAmt: double; // Amount of Jan Deferral
  end;

  TTDeferralsReportArray = array of TTDeferralsReport;

  TSTOpenDeferral = class
  public
    DateOpen: TDate;
    Ticker: String; // Description Deferral attached to Open Shares
    Shares: double;
    ls: String;
    Amount: double; // Amount of Open Deferral
    DateOfLoss: TDate;
    Account: String;
  end;

  TSTOpenDeferralList = class(TObjectList<TSTOpenDeferral>);

  // Calculated Trade Summary Record (see also TTradeSum)
  // ------------------------------------------------------
  TTrSum = packed record
    tr: integer; // Trade Number
    tk: string[40]; // Ticker Symbol
    ls: string[1]; // Trade Type: L(ong) or S(hort)
    prf: string[12]; // Equity Type + Multiplier
    cm: double; // Commission
    od: string[10];
    { Open Date - Corresponds to Date Acquired when Long Term (LS = L),
      Corresponds to Date Sold when Short Term (LS = S) }
    cd: string[10];
    { Close Date - Corresponds to Date Sold when Long Term (LS = L),
      Corresponds to Date Aqcuired when Short Term (LS = S) }
    wsd: String[10]; // Wash Sale Holding Date
    os: double; // Opened Shares
    cs: double; // Closed Shares
    oa: double; // Open Amount
    ca: double; // Close Amount
    wsh: double; // Wash Sale Shares
    ws: integer; // Wash Sale Type
    pr: double; // Price
    ActualPL: double;
    lt: string[1]; // Gain/Loss Tax Term: L(ong 365 days+) or S(hort)
    ny: bool; // Defer to Next Year
    m: string[20]; // Matched Tax Lots
    br: string[40]; // Broker (Combined files)
    op: integer;
    rec: integer;
    // added for Form 8949
    abc: string[1];
    code: string[1];
    adjG: double;
    { These two values are used to link Trigger trades to loss trades so that we can do
      line numbers on the reports to show how Wash Sales are being calculated }
    id: integer; // A Unique Number for each TradeSum record in a list
    wstriggerid: integer;
    // The Unique ID from the TradeSum record that triggered a wash sale.
    { This value is used to link a close record to the associated TrSum, Used by the
      Copy ShortLossTrades to next year routine to link records properly }
    closeid: integer;
    // The Close Record Item/ID number that is attached to this TrSum record
    openid: integer;
    // The Open Record Item/ID number that is attached to this TrSum record
  end;

  PTTrSum = ^TTrSum;

  // Matched Tax Lot Record
  TmTr = packed record
    m: string[20]; // Matched Tax Lots
    tr: integer; // Trade Number
    tk: string[40]; // Ticker Symbol
    ls: string[1]; // Trade Type: Long or Short
  end;

  mTrList = ^TmTr;

const
  tab = TLCommonLib.tab;
  lf = TLCommonLib.lf;
  cr = TLCommonLib.cr;
  crlf = TLCommonLib.crlf;
  alt = 18;
  dn = 40;
  SELDIRHELP = 1000;
  UseEscapeStr = cr + 'To return original Value, Use Escape key' + cr;

  // Short-Date Format Ordering used, but not named, by Windows
  sdoMDY = 0; // Month-Day-Year
  sdoDMY = 1; // Day-Month-Year
  sdoYMD = 2; // Year-Month-Day

  // Deferral Types
  defrCombined = 0;
  defrST = defrCombined + 1;
  defrLT = defrST + 1;

  // Rows per Report Style, .5 Margins, No Subtotals, By Orientation (L or P)
  Lrows4797 = 34;
  Lrows481 = 34;
  LrowsDeferred = 1;
  LrowsDetails = 44;
  LrowsMTM = 44;
  LrowsSubD1 = 34;
  LrowsSummary = 34;
  LrowsWashSales = 31;
  Prows4797 = 49;
  Prows481 = 49;
  ProwsDeferred = 1;
  PlnsDetails = 62;
  ProwsIRS_D1_P1 = 23;
  ProwsIRS_D1_P2 = 22;
  ProwsMTM = 62;
  ProwsSubD1 = 49;
  ProwsSummary = 49;
  PrpwsWashSales = 46;

  // Rows to subtract per subtotal
  SrowsDetails = 2;
  SrowsDeferred = 1;

  // Report Tags for Schedule D-1 variations
  tagRptNone = 0;
  tagRptP1 = tagRptNone + 1;
  tagRptP1C = tagRptP1 + 1;
  tagRptP103C = tagRptP1C + 1;
  tagRptP2 = tagRptP103C + 1;
  tagRptP2C = tagRptP2 + 1;
  tagRptP203C = tagRptP2C + 1;

  // Wash Sale situations
  wsNone = 0; // No wash sale deferral involved
  wsPrvYr = 1; // Wash sale deferral carried from a Previous Year
  wsThisYr = 2; // Wash sale deferral within current year
  wsCstAdjd = 3; // Cost basis adjusted due to wash sale deferral
  wsTXF = 4; // Wash Sale for TXF Report

  NormCapHeight = 13;

  // Locales
  EnglishUS = TLCommonLib.EnglishUS;

  // TaxID file iVer cases
  taxidVersion9 = -9; // unconverted file, new format
  taxidVersion5 = -5; // unconverted file, old format
  // = 0 means bad file (e.g. zero bytes)
  taxidTrialUserFile = 1; // no RegCode or RegCodeAcct
  taxidRegularUserFile = 2; // RegCode but no RegCodeAcct
  taxidProUserFile = 3; // no RegCode but has RegCodeAcct
  taxidSharedFile = 4; // both RegCode and RegCodeAcct

function CurrStr(f: extended): string;
function CurrToFloat(Curr: string): double;
//function DecToFrac(Dec: Real): string;
function FracDecToFloat(txt: string): double;

function convertInternalDateStrToUser(s: String; ForceLong: boolean = True): String;
function xStrToFloat(s: string): extended; overload;

function YYYYMMDD(DateStr: string): string;

function ParseCSV(const s: string; delimFld: Char = ','; delimTxt: Char = '"') : TStrings;

// Thread-safe string/numeric procedures
function CurrStrEx(f: extended; Fmt: TFormatSettings; ZeroOK: boolean = false;
  IncludeDecimal: boolean = True; decimalPlaces: integer = 2): string;
function CurrToFloatEx(Curr: string; Fmt: TFormatSettings): double;
//function DecToFracEx(Dec: Real; Fmt: TFormatSettings): string;
function Del1000SepEx(TxtStr: string; Fmt: TFormatSettings): string;
//function DelNeg(TxtStr: String; Fmt: TFormatSettings): string;
function FracDecToFloatEx(txt: string; Fmt: TFormatSettings): double;
Procedure GridCurrStr(var s: String; ZeroOK: boolean = false);
function GridTimeStr(s: String; Fmt: TFormatSettings): String;
//function ImportDateStr(s: String; Fmt: TFormatSettings; ForceLong: boolean = false): String;
function IsLongDateEx(s: string; Fmt: TFormatSettings; locale: integer) : boolean;

function StrDateAdd(s: String; Change: integer; Fmt: TFormatSettings): String;
//function StrDateIncYr(s: String; Change: integer; Fmt: TFormatSettings): String;

function UserDateStr(s: String): String;

//function UserDateStrEx(s: String; Fmt: TFormatSettings; ForceLong: boolean = True): String;
function UserDayMonthStr(uDay, uMonth: String; yrSep: boolean): String;

function xStrToTimeEx(const s: string; Fmt: TFormatSettings): TDateTime;

function YYYYMMDD_Ex(DateStr: string; Fmt: TFormatSettings): string;

//function countCharInString(Char, s: String): Longint;

function getFutExpMonth(s: string): string;
function getExpMonth(s: string): string;
function getCallPut(s: string): string;
function getStrike(s: string): string;
function getOptExpDate(ExpMo, ExpYr: string): TDate;
function getExDayFromWeek(exWk, exMon, ExYr: string): string;

//function addYearCodeToExp(tick, mYear: string): string;
function IsTime(s: string): boolean;

procedure CheckForBaks;
procedure deleteUndoRedo;
function Redo(ShowMsg: boolean): boolean;
function Undo(ShowMsg: boolean = True; ReLoadFile: boolean = True): boolean;

procedure webURL(url: string);
//function ProcessRunning (sExeName: String) : Boolean;
function ExecuteFile(const FileName, Params, DefaultDir: string; ShowCmd: integer): THandle;

//function RoundUpCents(Amount: double): double;
function RoundToDec(Amount: double; nDecimals: integer): double; // 2024-05-29 MB

function DelParenthesis(TxtStr: String): string;
function DelNonAlpha(const AValue: string): string;
function DelCommas(TxtStr: string): string;
function DelQuotes(TxtStr: string): string;

function MMDDYYYY(sYYYYMMDD : string) : string;

procedure ClearTradesSum;

function LoadRecords(NewFile: boolean = false; chgAcctTab: boolean = True): boolean;

function MakeSettlmentAdj(oldDate : TDate): TDate; overload
function MakeSettlmentAdj(oldDate : TDateTime): TDateTime; overload

function GetSettlementDate(TrSum: PTTrSum): TDate; overload;
function GetSettlementDate(TrSum: TTlTradeSummary): TDate; overload;

procedure DelAll;

procedure dispProfit(calc: boolean; profit, openSh, openContr, commis: double);

procedure StatBar(Stat: string); overload;
procedure StatBar(Stat: String; myColor: TColor); overload;

procedure SortByTradeNum;
procedure SortByLS;
procedure SortByMatched;
procedure SortByTicker(bStatBar: boolean = True);
procedure SortByType;
procedure SortByTypeNoOpt;
procedure SortByDate;
procedure SortByAmount;

procedure CopyTradesSumToClip;

procedure CreateNewFile; // old name was ProcessBeginYearA;
procedure EnterBeginYearPrice;

//function CheckForMoreClosedShares: boolean;

procedure ToggleShortLong;

procedure SaveTradesBack(SaveName: String);
procedure SaveTradesRedo(RedoName: String);
procedure SaveEndYearBack;
procedure GetCurrTaxYear;
function SetFileTaxYear(): boolean;

procedure getDataFileName;
//function IntToTimeStr(TimeStr: string): string;
procedure repaintGrid;

procedure disableMenuTools;

function GetOnlineStatus: boolean;
//function FuncAvail(VLibraryname, VFunctionname: string; var VPointer: pointer): boolean;
//procedure progressBar(i, x: integer);

procedure expireOptions;

procedure ChangeOptTicker;
function IsFormOpen(const FormName: string): boolean;
function IsFormVisible(const FormName: string): boolean;
function GetFormIfOpen(const FormName: string): TForm;
function CloseFormIfOpen(const FormName: string): boolean;

function mDlg(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons;
  HelpCtx: Longint): integer; overload;
function mDlg(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons;
  DefaultButton: TMsgDlgBtn): integer; overload;
procedure sm(s: string);
function sma(s: string; AddedButtns: TMsgDlgButtons): boolean;
function DisplayedSize(Canvas: TCanvas; ACaption: string): TPoint;
function myInputQuery(const ACaption, APrompt: string; var Value: string;
  Hnd: THandle; Numeric: boolean = false): boolean;
function myInputBox(const ACaption, APrompt, ADefault: string; Hnd: THandle): string;

procedure GetLocaleFormats;
procedure SetCurrencyOffsets;

function NextUserDate(InDateStr: String): TDate;
function UserDateStrNotGreater(TestDate, CompareDate: String): boolean;

procedure ShowMenuHint(var Msg: TWMMenuSelect; var Form: TForm; var miHint: TMenuItemHint);
//function LocateFile(FileName: String): String;
procedure OpenTradeLogFile(LastFileName: string);

//function replDateStrJanDec(s: string): string;
//function WordCount(Sentence: string): integer;
procedure CheckForNewData;
procedure showUserGuide;
procedure changeCusips;
//function numOccurances(s, substr: string): integer;
function validDriveType(s: string): boolean;
function SaveTradeLogFile(Undo: String = ''; Silent: boolean = false;
  ReloadOnCancel: boolean = True; NumRecsImported: integer = 0) : boolean; overload;
function CheckRecordLimit: boolean;

procedure applyChangesToMultipliers(bAdjContr: boolean = false);
// 2016-12-12 MB - added new switch for adjusting #contracts

// Calculate the Scale Percentage from the standard 96 DPI setting of no Scaling.
function GetScalePercentage: integer;

function isMTM: boolean;
function isMTMForFutures: boolean;
function isIRA: boolean;
function isAllBrokersSelected: boolean;
procedure SetupGUIForFile;

function getMult(typemult: string): double;

procedure disableEdits;
procedure enableEdits;

function FileExistsCaseInsensitive(fname: string): boolean;
function RemoveFileExtension(fname: string): string;
function GetVersionInfo(AIdent: String): String;

procedure splitRecord;
procedure consolidateRecords;
procedure ChangeStockDescrtoTickerSymbol(bSilent: boolean = false);
procedure AssignNoteToTrades;

function getElapsedTime(startTime: TDateTime): string;

// TaxFile functions
procedure WriteTaxFileLog(sUserRC, sFileRC, sFunc, sReason, sComment : string);
procedure v2WriteTaxFileLog(sUserToken, sFileCode,
 sFunc, sReason, sComment, sTracking, sAcct : string);

function TaxpayerExists(UserTokenToUse, sFileName: string): string;
// function TaxpayerExists(sFileName: string): string;

function TaxFilesAvail(sUserToken: string): integer;
function GetAvailFileKey(sUserToken: string): string;
//function TaxFilesAvail(sRegCode: string = ''; bIncludeConv: boolean = false): integer;

//function getTaxfileList: string;
function TaxFileSave(sToken, sEmail, sTaxFile, sFileCode, sReason: string): boolean;

procedure ProcessBeginYearDone;

function generateFilePW: string;
procedure showFileResetPW;

//procedure SelectAccountTab(AccountName : String);
function EditCurrentAccount(ACaption: String): TModalResult;
function EditCurrentImport(ACaption: String): TModalResult;

// ----------------
// GLOBAL VARIABLES
// ----------------
var
  redoing, // special case of SaveTradesBack
  savingFile,
  { When Wash Sales are loaded if there are Deferrals then this is set to true
    and other routines can act accordingly }
  wsDeferrals,

  { When we are entering begin year prices via the F7 or Enter Base Line
    Positions function this is true. Since adding records is a global thing
    then this variable tells us how to default records and when to Create MTM
    Opening records etc. }
  EnteringBeginYearPrice,

  // 2014-03-04 added so YEC does not get reset when edning tax year
  EnteringEndYearPrice,

  { Set to true when LoadRecords() is called. This is used in a number of
    methods to keep code from running if loading records is happening when the
    user tries to set a date into a date component, mainly SelectDateRange.pas
    and Main.pas, Not sure this is needed but maybe put here to solve a timing
    issue with the loading of records and the GUI operation }
  LoadingRecs,

  { This is a wierd one, Turned on before FileImport, turned off right after
    fileImport, used to Repaint the grid whenever mDlg, is called, so that the
    grid is up to date then the message is displayed, Not sure why this is
    needed since the import doesn't even update the grid. }
  bImporting,

  { These two are used by the PrepareForGainsReport methods to specify if they
    want Long Term and or Short Term Gains and Losses, They need to become
    parameters someday instead of Global variables }
  DoLT, DoST: boolean;

  { Used by gains report routines and resulting reports }
  totWSdefer, totWSdeferL, totWSdeferS: double;
  totWSLostToIra, totWSLostToIraL, totWSLostToIraS: double;
  PrvDeferrals, PrvDeferralsST, PrvDeferralsLT, PrvPl, PrvPlST, PrvPlLT,
    PrvSales, PrvSalesST, PrvSalesLT, PrvCost, PrvCostST, PrvCostLT: extended;
  { End of gains report variables }

  { Currency formatting variables }
  PlusCurrencyType, NegCurrencyType: integer;

  { Used in many places to represent Tax Years.
    Need to be removed eventually in favor of TradeLogFile.TaxYear }
  TaxYear, NextTaxYear, LastTaxYear: String;

  { More Variables used by Reports }
  wsOpenL, wsOpenS, wsJan, wsOpen, wsJanS, wsJanL, NegCurrPrfx, NegCurrPstfx,
    PosCurrPrfx, PosCurrPstfx: String;

  { Used by MakeGLCalencarYear method for Gains Report, Set in Select Range Dialog }
  RangeStart, RangeEnd: TDate;

  { Used by TLCharts and ChartTimes }
  NoTime, ThisTime: TDateTime;

  { Used for getting Wash Sale Deferrals during end of year process. }
  wsDeferOpenList: TList;
  { Used for Reports Wash Sale Deferrals }
  datDeferrals, datDeferralsLT, datDeferralsST, datDeferralsIra
    : TTDeferralsReportArray;
  STDeferralDetails, IRADeferralDetails, NewTradesDeferralDetails
    : TSTOpenDeferralList;
  datPerf: TTPerfReport;

  { Used to keep Close button from running during file Open }
  OpeningFile: boolean; // also used for other buttons
  bProHeaderChanged: boolean; // need to save ProHeader NOW!
  bTaxFileAvailable: boolean; // customer has a free TaxFile

  bNeedTaxFile: boolean; // do we need to use on this file?
  sRegCodeToUse: string; // who is paying for this taxfile?

const
  siteURL = 'http://www.tradelogsoftware.com/';
  secureSiteURL = 'https://www.tradelogsoftware.com/';
  supportSiteURL = 'https://support.tradelogsoftware.com/';

implementation

uses
  Main, winInet, Import, ClipBrd, TLRegister, Commission, // HelpMsg,
  Reports,
  RecordClasses, cxCustomData, cxGridCustomTableView, cxFilter, myInput,
  SelectDateRange, frmOFX, Web, FileSave,
  frmOpTick, // used - see lastPos, myNewOptTicker, edTick
  myDatePick, frmNewStrategies, frmNewBBIFU, SysConst, TLSettings,
  splash, dlgInputVal, dlgConsolidation, //
  messagePanel, PriceList, TLImportFilters, globalVariables,
  TLWinInet, TLDataSources, TLDateUtils, TLLogging,
  AccountSetup, ImportSetup,
  dxCore, TL_API,
  BackupRestoreDialog, GainsLosses, underlying, IdURI, uDM;

const
  CODE_SITE_CATEGORY = 'FuncProc';

var
  NewFile: TTLFile;
  bEditFileNow: boolean;

// --------------------------
function getHostName(myURL: string): string;
var
  URI: TIdURI;
  myhostname: string;
begin
  Result := '';
  URI := TIdURI.Create(myurl);
  try
    myhostname := URI.Host; // www.mail.example.co.uk
  finally
    URI.Free;
  end;
  Result:=myhostname;
end;

function getHostNameWithProtocol(myURL: string): string;
var
  URI: TIdURI;
  myhostname: string;
begin
  Result := '';
  URI := TIdURI.Create(myurl);
  try
    myhostname := URI.Protocol+'://'+URI.Host; // https://www.mail.example.co.uk
  finally
    URI.Free;
  end;
  Result:=myhostname;
end;


// ----------------------------------------------
// parses CSV file record into a String List
// 2017-08-23 MB - restored my original code
// in order to correctly handle quoted fields.
// ----------------------------------------------
function ParseCSV(const s: string; delimFld: Char = ','; delimTxt: Char = '"') : TStrings;
var
  i, j: integer;
  token: string;
begin
  if s = '' then exit;
  result := TStringList.Create;
  i := 1;
  j := 1;
  while i <= length(s) do begin
    token := '';
    if s[i] = delimTxt then begin // string delimiter found
      j := i + 1; // starts after quote
      repeat i := i+1 until ((i > Length(s)) or (s[i] = delimTxt)); // find end of quote
      token := Copy(s,j,(i-j));
      repeat i := i+1 until ((i > length(s)) or (s[i] = delimFld)); // find end of field
    end
    else begin // non-quoted field, so just look for ','
      if s[i] = delimFld then begin
        token := ' ';
      end
      else begin
        repeat i := i+1 until ((i > length(s)) or (s[i] = delimFld));
        token := Copy(s, j, (i-j));
      end;
    end;
    result.add(token);
    j := i+1;
    i := j;
  end; // while loop
end; // ParseCSV


// returns TaxFile in year+taxpayer format
function fixTaxFile(sFileSpec: string): string;
var
  s1, s2: string;
begin
  s1 := RemoveFileExtension(sFileSpec); // 2017-04-11 MB safely remove ext.
  // path\filename
  if pos(s1, '\') > 0 then
    s2 := ParseLast(s1, '\') // s1 = path, s2 = file
  else
    s2 := s1;
  if isInt(copy(s2,1,4)) then
    s1 := ParseFirst(s2, ' ') // s1 = year, s2 = taxpayer
  else
    s1 := TaxYear; // assume global var already set
  result := s1 + ' ' + s2;
end;


// find if file exists case insensitive
function FileExistsCaseInsensitive(fname: string): boolean;
var
  rec: TSearchRec;
  sPath: string;
begin
  result := false;
  sPath := ExtractFilePath(fname);
  fname := ExtractFileName(fname);
  try
    if (FindFirst(sPath + '*.*', faAnyFile, rec) = 0) then
      repeat
        if (rec.Name = '.') or (rec.Name = '..') then continue;
        if (rec.Attr and faVolumeID) = faVolumeID then continue;
        // nothing useful to do with volume IDs
        if (rec.Attr and faHidden) = faHidden then continue;
        // honor the OS "hidden" setting
        if (rec.Attr and faDirectory) = faDirectory then continue;
        // This is a directory.
        if (lowercase(rec.Name) = lowercase(fname)) then result := True;
      until FindNext(rec) <> 0;
  finally
    SysUtils.FindClose(rec);
  end;
end;

// check for file extension before removing it
function RemoveFileExtension(fname: string): string;
begin
  if lowercase(RightStr(fname, 4)) = '.tdf' then
    result := ChangeFileExt(fname, '')
  else
    result := fname;
end;


function GetVersionInfo(AIdent: String): String;
type
  TLang = packed record
    Lng, Page: WORD;
  end;
  TLangs = array [0 .. 10000] of TLang;
  PLangs = ^TLangs;
var
  BLngs: PLangs;
  BLngsCnt: Cardinal;
  BLangId: String;
  RM: TMemoryStream;
  RS: TResourceStream;
  BP: PChar;
  BL: Cardinal;
  BId: String;
begin
  // Assume error
  Result := '';
  RM := TMemoryStream.Create;
  try
    // --- Load the version resource into memory
    RS := TResourceStream.CreateFromID(HInstance, 1, RT_VERSION);
    try
      RM.CopyFrom(RS, RS.Size);
    finally
      FreeAndNil(RS);
    end;
    // --- Extract the translations list
    if not VerQueryValue(RM.Memory, '\\VarFileInfo\\Translation', Pointer(BLngs), BL) then
      Exit; // Failed to parse the translations table
    BLngsCnt := BL div sizeof(TLang);
    if BLngsCnt <= 0 then
      Exit; // No translations available
    // --- Use 1st translation from the table (usually OK)
    with BLngs[0] do
      BLangId := IntToHex(Lng, 4) + IntToHex(Page, 4);
    // --- Extract field by parameter
    BId := '\\StringFileInfo\\' + BLangId + '\\' + AIdent;
    if not VerQueryValue(RM.Memory, PChar(BId), Pointer(BP), BL) then
      Exit; // No such field
    // --- Prepare result
    Result := BP;
  finally
    FreeAndNil(RM);
  end;
end;


         // ------------------------------------
         // TaxFile Functions
         // ------------------------------------

function GetAvailFileKey(sUserToken: string): string;
var
  sTmp: string;
  i : integer;
  FKeyLst, lineLst : TStrings;
begin
  result := '';
  try
    StatBar('Checking if TaxID Already Exists');
    screen.Cursor := crHourglass;
    result := '';
    sTmp := ListFileKeys(sUserToken);
    FKeyLst := ParseJSON(sTmp); // {FileKey1},{FileKey2}...
    for i := 0 to FKeyLst.Count-1 do begin
      sTmp := FKeyLst[i];
      lineLst := ParseV2APIResponse(sTmp);
      if assigned(lineLst)=false then continue;
      if lineLst.Count > 15 then begin // first field is 0th
        if ((lineLst[7] = 'null') or (lineLst[7] = '')) // FileName
        and ((lineLst[15] = 'null') or (lineLst[15] = '')) // CanceledDate
        then begin
          result := lineLst[5]; // FileCode
          break; // exit loop
        end; // if available and not canceled
      end; // if line has enough fields
    end; // for i loop
  finally
    StatBar('off');
    screen.Cursor := crDefault;
  end;
end;

// ----------------------------------------------
// returns number of TaxFiles available
// ----------------------------------------------
//  0/ 1 "UserToken":"600b0dcb-...",
//  2/ 3 "Email":"mark@tradelogsoftware.com",
//  4/ 5 "FileCode":"3b55362b-...",
//  6/ 7 "FileName":"", <-- to be available, both
//  8/ 9 "TaxPayer":"",
// 10/11 "TaxYear":null,
// 12/13 "DateUsed":null <-- of these need to be
// ----------------------------------------------
function TaxFilesAvail(sUserToken: string): integer;
var
  sTmp: string;
  i : integer;
  FKeyLst, lineLst : TStrings;
begin
  result := 0;
  try
    StatBar('Checking if TaxID Already Exists');
    screen.Cursor := crHourglass;
    result := 0;
    sTmp := ListFileKeys(sUserToken);
    FKeyLst := ParseJSON(sTmp); // {FileKey1},{FileKey2}...
    for i := 0 to FKeyLst.Count-1 do begin
      sTmp := FKeyLst[i];
      lineLst := ParseV2APIResponse(sTmp);
      if assigned(lineLst)=false then continue;
      if lineLst.Count > 15 then begin // first field is 0th
        if ((lineLst[7] = 'null') or (lineLst[7] = '')) // FileName
        and ((lineLst[15] = 'null') or (lineLst[15] = '')) // CanceledDate
        then begin
         result := result + 1; // count #available
        end; // if available and not canceled
      end; // if line has enough fields
    end; // for i loop
  finally
    StatBar('off');
    screen.Cursor := crDefault;
  end;
end;


// ----------------------------------------------
procedure WriteTaxFileLog(sUserRC, sFileRC, sFunc, sReason, sComment : string);
var
  sURL, sReply : string;
begin
  // --- old APIs -----------
  sURL := siteURL + 'taxfile/writetaxfilelog'
      + '?userRC=' + sUserRC
      + '&fileRC=' + sFileRC;
  sURL := sURL + '&func=' + sFunc
    + '&reason=' + sReason
     + '&comment=' + sComment;
  sReply := parseHTML(readURL(sURL), '<result>', '</result>');
end;

procedure v2WriteTaxFileLog(sUserToken, sFileCode,
 sFunc, sReason, sComment, sTracking, sAcct : string);
var
  sURL, sReply : string;
begin
  // --- new APIs -----------
  sReply := InsertFileKeyLog(sUserToken, sFileCode,
    sFunc, sReason, sComment, sTracking, sAcct);
end;


// --------------------------------------------------------
// if filename is in filekeys table, return FileCode
// --------------------------------------------------------
// 0 "UserToken": 1
// 2 "Email": 3
// 4 "FileCode": 5 <-----
// 6 "FileName": 6 "", <---
// 7 "TaxPayer": 8 "",
// 10 "TaxYear": 11 null,
// 12 "DateUsed": 13 null
// Now returns FileCode
// --------------------------------------------------------
function TaxpayerExists(UserTokenToUse, sFileName: string): string;
var
  regCheckURL, reply, sTmp : string;
  FKeyLst, lineLst: TStrings;
  i : integer;
begin
  result := ''; // assume no
  try
    StatBar('Checking if TaxID Already Exists');
    screen.Cursor := crHourglass;
    sTmp := ListFileKeys(UserTokenToUse); // v2UserToken OR v2ClientToken
    FKeyLst := ParseJSON(sTmp); // {FileKey1},{FileKey2}...
    for i := 0 to FKeyLst.Count-1 do begin
      sTmp := FKeyLst[i];
      lineLst := ParseV2APIResponse(sTmp);
      if assigned(lineLst)=false then continue;
      if lineLst.Count > 15 then begin // 2023-12-07 MB
//        if ((lineLst[15] = 'null') or (lineLst[15] = '')) // NOT canceled
//        and (lineLst[7] = sFileName) then begin // match file name
        if (lineLst[15] <> '') // CanceledDate
        and (lineLst[15] <> 'null') then begin
          continue; // can't end tax year
        end; // if canceled file key
        if (lineLst[7] = sFileName) // match file name
        then begin
          result := lineLst[5]; // FileCode
          exit;
        end;
      end;
    end;
    if pos('Error', result) > 0 then result := '';
    exit;
  finally
    StatBar('off');
    screen.Cursor := crDefault;
  end;
end;


// ----------------------------------------------
// upload TaxYear, TaxFile, Settings.RegCode
function TaxFileSave(sToken, sEmail, sTaxFile, sFileCode, sReason: string): boolean;
var
  TrFileNameNoExt, regCheckURL, reply, s: string;
  sTaxPayer, sTaxYear : string;
begin
  result := True;
  if SuperUser then exit; // never upload!
  // remove file extension
  if (sTaxFile = '') then begin
    TrFileNameNoExt := RemoveFileExtension(ProHeader.taxFile); // 2017-04-11 MB
  end
  else begin
    TrFileNameNoExt := RemoveFileExtension(sTaxFile); // 2017-04-11 MB
  end;
  s := sTaxFile;
  sTaxYear := parsefirst(s,' ');
  sTaxPayer := s;
  // --- New API ----------------------
  s := UpdateFileKey(sToken, sEmail, sFileCode, sTaxFile, sTaxPayer, sTaxYear);
  if pos('successfully', s) > 0 then
    result := True
  else
    result := False;
end;


function isIRA: boolean;
begin
  result := false;
  if (TradeLogFile <> nil) and (TradeLogFile.CurrentBrokerID > 0) then
    result := TradeLogFile.CurrentAccount.IRA;
end;


function CheckRecordLimit: boolean;
begin
  if (TradeLogFile <> nil) //
  and TradeLogFile.RecordLimitExceeded then begin
    mDlg(Settings.TLVer + ' limited to ' + Settings.RecLimit + ' records' + cr //
      + cr //
      + 'Please upgrade to a higher record limit to enable all features.',
      mtInformation, [mbOK], 0);
    exit(false);
  end;
  // ----------------------
  // Enforce special rec limit for sample file
  if (ProHeader.regCode = TRADELOG_SAMPLE_REGCODE)
  and (TradeLogFile.Count > TRADELOG_SAMPLE_RecLimit) then begin
    mDlg('Sample file limited to ' + IntToStr(TRADELOG_SAMPLE_RecLimit) + ' records' + cr +
      cr + 'Please create a licensed file to enable all features.',
      mtInformation, [mbOK], 0);
    exit(false);
  end;
  // ----------------------
  exit(True);
end;


function isAllBrokersSelected: boolean;
begin
  result := false;
  if (TradeLogFile <> nil) then result := TradeLogFile.CurrentBrokerID = 0
end;


function isMTMForFutures: boolean;
begin
  result := false;
  if not Settings.MTMVersion then exit;
  if (TradeLogFile <> nil) and (TradeLogFile.CurrentBrokerID > 0) then
    result := (TradeLogFile.CurrentAccount.MTM
              and TradeLogFile.CurrentAccount.MTMForFutures);
end;


function isMTM: boolean;
begin
  result := false;
  if not Settings.MTMVersion then exit;
  if (TradeLogFile <> nil) and (TradeLogFile.CurrentBrokerID > 0) then
    result := TradeLogFile.CurrentAccount.MTM;
end;


//procedure showList(s: string; i, j: integer);
//var
//  k: integer;
//begin
//  msgTxt := s + cr + 'i= ' + IntToStr(i) + tab + 'j= ' + IntToStr(j) + cr;
//  for k := 0 to TrSumList.Count - 1 do begin
//    msgTxt := msgTxt + IntToStr(k) + tab + 'ws: ' +
//      IntToStr(PTTrSum(TrSumList[k]).ws) + tab + 'od: ' + PTTrSum(TrSumList[k])
//      .od + tab + 'cd: ' + PTTrSum(TrSumList[k]).cd + tab + 'os: ' +
//      FloatToStr(PTTrSum(TrSumList[k]).os, Settings.UserFmt) + tab + 'cs: ' +
//      FloatToStr(PTTrSum(TrSumList[k]).cs, Settings.UserFmt) + tab + 'oa: ' +
//      Format('%1.2f', [PTTrSum(TrSumList[k]).oa], Settings.UserFmt) + tab +
//      'ca: ' + Format('%1.2f', [PTTrSum(TrSumList[k]).ca], Settings.UserFmt) +
//      tab + 'prof: ' + Format('%1.2f',
//      [PTTrSum(TrSumList[k]).ca + PTTrSum(TrSumList[k]).oa],
//      Settings.UserFmt) + cr;
//  end;
//  sm(msgTxt);
//  msgTxt := '';
//end;


function GetScalePercentage: integer;
begin
  if frmMain.PixelsPerInch <= 96 then
    result := 100
  else
    result := trunc((frmMain.PixelsPerInch / 96) * 100);
end;


constructor TMenuItemHint.Create(AOwner: TComponent);
begin
  inherited;
  showTimer := TTimer.Create(self);
  showTimer.Interval := Application.HintPause;
  hideTimer := TTimer.Create(self);
  hideTimer.Interval := Application.HintHidePause;
  Brush.Color := clWhite;
end;


destructor TMenuItemHint.Destroy;
begin
  hideTimer.OnTimer := nil;
  showTimer.OnTimer := nil;
  self.ReleaseHandle;
  inherited;
end;


procedure applyChangesToMultipliers(bAdjContr: boolean = false);
begin
  if (TradeLogFile <> nil) and (TradeLogFile.Count > 0) then begin
    changeFutMult(TradeLogFile.TradeList, bAdjContr); // FUT
    TradeLogFile.UpdateTypeMultipliers;    // MUT and ETF
    // rematch trades now!
    // 2017-01-31 MB - handle case of CurrentBrokerID = 0
    if TradeLogFile.CurrentBrokerID = 0 then
      TradeLogFile.MatchAndReorganizeAllAccounts(false, True)
    else
      TradeLogFile.MatchAndReorganize(false, True);
    // end if
//    SaveTradeLogFile('Changes to Multipliers', True);
    TradeRecordsSource.DataChanged;
  end;
end;


// ---------------------------------------------------------
// Open File routines
// ---------------------------------------------------------
procedure getFileLoadTime(loadTime: TDateTime);
var
  hour, min, sec, msec: word;
  sLoadTime: string;
begin
  // calc file open time
  loadTime := time - loadTime;
  decodeTime(loadTime, hour, min, sec, msec);
  if (hour = 0) then begin
    if (min = 0) then begin
      if (sec < 10) then
        sLoadTime := '00:0' + IntToStr(sec)
      else
        sLoadTime := '00:' + IntToStr(sec);
    end
    else if (sec < 10) then
      sLoadTime := IntToStr(min) + ':0' + IntToStr(sec)
    else
      sLoadTime := IntToStr(min) + ':' + IntToStr(sec);
  end
  else
    sLoadTime := IntToStr(hour) + ':' + IntToStr(min) + ':' + IntToStr(sec);
  // ------------------------
  if (hour = 0) and (min = 0) and (sec = 0) then
    StatBar('off')
  else
    StatBar(sLoadTime + '  -  Ready', clBtnFace);
  frmMain.stMessage.Font.Style := [];
end;


function getBackupFileName(sFileName: String): String;
var
  sName, sPath: string;
begin
  sPath := sFileName;
  sName := ParseLast(sPath, '\');
  sPath := sPath + '\Backups\';
  if not DirectoryExists(sPath) then ForceDirectories(sPath);
  // sName := ExtractFileName(sFileName);
  // result := Settings.BackupDir + '\' + s + '-Backup';
  result := sPath + sName + '-Backup';
end;


//function checkBackOfficeTaxFiles(TrFileName:string; sRegCode:string=''; bSilent:boolean=false): boolean;
//begin
//  result := True;
//  // allow all prior year files to be opened and converted
//  if (TrFileName <> '') and (leftStr(TrFileName, 4) < '2015') then exit;
//  if currSubscr and (leftStr(TrFileName, 4) = '2015') then exit;
//  // check if user still has TaxFiles not used
//  if TaxFilesAvail(v2UserToken) > 0 then begin
//    msgTxt := 'IMPORTANT NOTICE - PLEASE READ CAREFULLY!' + cr + cr +
//      'This version of TradeLog restricts the number of' + cr +
//      ' new TaxFiles that can be created.' + cr + cr +
//      'ONE (1) TaxFile is included in your base subscription.' + cr + cr +
//      'Additional TaxFiles may be purchased from our web site.' + cr + cr +
//      '-------------------------------------------------------' + cr + cr;
//  end
//  else begin // Taxfile limit has been reached
//    if not bSilent then
//      mDlg('You have NO additional TaxFiles available.' + cr + cr
//        + 'Additional TaxFiles may be purchased from our website.', mtWarning, [mbOK], 0);
//    result := false;
//  end;
//end;


//procedure checkTaxYear(OldFileName: string);
//begin
//  // 2014-03-11 Test to see if user renamed file with wrong tax year
//  if copy(TrFileName, 1, 4) <> IntToStr(TradeLogFile.TaxYear) then begin
//    if mDlg('THIS FILE IS UNUSABLE FOR TAX PURPOSES!' + cr + cr
//      + 'It was created as a ' + IntToStr(TradeLogFile.TaxYear)
//      + ' tax year file,' + cr + ' but was erroneously renamed as: ' + cr + cr
//      + TrFileName + cr + cr + 'click OK to rename it properly, or' + cr + cr
//      + 'click Cancel to close the file' + cr, mtError, [mbOK, mbCancel], 0) = mrOK
//    then begin
//      // delete tax year from filename
//      delete(TrFileName, 1, 4);
//      // add correct tax year to filename
//      TrFileName := IntToStr(TradeLogFile.TaxYear) + TrFileName;
//      // sm(oldFileName+cr+TrFileName);
//      RenameFile(OldFileName, Settings.DataDir + '\' + TrFileName);
//      getDataFileName;
//      frmMain.caption := Settings.TLVer + ' - ' + DataFileName;
//      SaveLastFileName(TrFileName);
//    end
//    else begin
//      frmMain.CloseFileIfAny;
//    end;
//  end;
//end;


procedure checkImport;
begin
  // 2014-03-11 Test to see if user has imported past Jan 31
  if (TradeLogFile.LastDateImported > strToDate('01/31/' + NextTaxYear, Settings.internalFmt))
  then begin
    mDlg('This file is a ' + TaxYear + ' TAX YEAR file!' + cr + cr
      + 'If you have received all your 1099s, please run  "File, End Tax Year."' + cr + cr
      + 'This will create a ' + NextTaxYear + ' file where you can continue importing' + cr
      + ' your ' + NextTaxYear + ' trades.' + cr, mtWarning, [mbOK], 0);
  end;
end;


// --------------------------------------------------------
// This routine is called after a text TDF is converted.
// --------------------------------------------------------
function saveFileAsDB(LastFileName, sFileName, sFolder: String;
  iTaxYear: integer): boolean;
var
  i: integer;
begin
  result := True;
  begin
    isDBFile := True;
    // save TaxID to back office
//    if bNeedTaxFile and not TaxFileSave('', true, 'Convert file to DB') then begin
//      sm('Error registering TaxFile license.' + CR
//       + 'Please contact TradeLog Support.');
//      exit(false);
//    end;
    sRegCodeToUse := '';
    // remove converted file from LastOpenFilesList
    i := 0;
    while i < Settings.LastOpenFilesList.Count do begin
      if (Settings.LastOpenFilesList[i] = LastFileName) then begin
        Settings.LastOpenFilesList.delete(i);
        break;
      end
      else begin
        inc(i);
      end;
    end;
    TradeLogFile.FileName := sFileName;
    // add new file to LastOpenFilesList
    Settings.LastOpenFilesList.Add(sFolder + '\' + sFileName);
    // Edit Account should save file  ????
    // frmMain.EditCurrentAccount ('Account Converted: Please Verify Account Settings');
    // Save the converted file
    TradeLogFile.SaveFileAs(sFileName, sFolder, iTaxYear, True);
    // finally delete the tdf file just converted
    if (lowercase(ExtractFileName(LastFileName)) <> lowercase(sFileName)) then
      deleteFile(LastFileName);
    // set the main form caption
    getDataFileName;
    frmMain.caption := Settings.TLVer + ' - ' + DataFileName;
  end;
end;


// --------------------------------------------------------
// Open taxID version - can the user open the file or not?
// File not yet open, so check TempProHdr, not ProHeader.
// --------------------------------------------------------
function OpenTaxIdFile(LastFileName : string): boolean;
var
  bNoOpen : boolean;
  sFileSpec, sTaxFile, sBaseRegCode, sFileEmail : string;
begin
  Result := True;
  bNoOpen := false;
  // --- Anyone can open the official Sample Files
  if (TempProHdr.regCode = TRADELOG_SAMPLE_REGCODE) then
    exit(True);
  // --- Anyone can open an unregistered file
  if (TempProHdr.email = '') then begin
    if not(SuperUser or ProVer) then begin
      TempProHdr.email := v2UserEmail; // claim file
      bProHeaderChanged := True; // mark for saving
    end;
    exit(True);
  end;
  // --- Registered file, owner can always open it.
  if uppercase(TempProHdr.email) = uppercase(v2UserEmail) then
    exit(True); // owner
  // --- Pro or Super user
  if (SuperUser or ProVer) then begin
    v2ClientEmail := TempProHdr.email;
    v2ClientToken := Impersonate(v2ClientEmail);
    if (v2ClientToken = '') then begin
      bNoOpen := True;
      mDlg('Error opening registered file.' + cr + cr //
          + 'If this error persists, please contact' + cr //
          + 'TradeLog Support.', mtError, [mbOK], 0);
      if SuperUser then
        exit(True)
      else
        exit(false);
    end
    else if (pos('ERROR', uppercase(v2ClientToken)) > 0) then begin
      bNoOpen := True;
      mDlg('Error attempting to verify file access.' + cr + cr //
          + 'If this error persists, please contact' + cr //
          + 'TradeLog Support.', mtError, [mbOK], 0);
      if SuperUser then
        exit(True)
      else
        exit(false);
    end
    else begin
      v2CustomerId := GetCustomerId(v2ClientToken); // not same as v2UserId!
      exit(True);
    end;
  end;
  // ----------------------------------
  // User has no right to open file
  // ----------------------------------
  bNoOpen := True;
  mDlg('UNAUTHORIZED.' + cr + cr //
      + 'This file is registered to a' + cr //
      + 'different TradeLog user email.', mtError, [mbOK], 0);
  Result := false;
end;


// ----------------------------------------------
function ConvertToDBFile(LastFileName: string; var bConvertDB: boolean): boolean;
var
  bNoOpen: boolean;
  sFile, sRC, sTaxYr, sTaxFile, sClientRegCode, sReply: string;
  sBackFName, sFolder, sFileName, sTaxID, Line, OldFileName: String;
  i, iTaxYear: integer;
  myOK: word;
  bFileNeedsConversion, bFileClose: boolean;
  Header: TTLFileHeader;
  loadTime: TDateTime;
  txtFile: textFile;
  RowData: TStringList;
  // ----- can we convert file? -------
  function WeCanConvertFile: boolean;
  begin
    result := false; // assume cannot open
    if Settings.TrialVersion then begin
      mDlg('File conversion is not available in the Trial Version.' + cr + cr
        + 'Please purchase to convert files to new format!', mtError, [mbOK], 0);
      exit;
    end;
    // any registered user can convert
    bFileNeedsConversion := True;
    // file version ok?
    if not VerifyV5OrGreaterData(LastFileName) then begin
      mDlg('Sorry this is not a valid TradeLog File' + cr + cr
        + 'Please Try Again!', mtError, [mbOK], 0);
      exit;
    end;
    // file version is older than 9, no need to call FileConvert, just do it
    if (iVer > -9) then begin
      //rj CodeSite.Send('File is Older than version 9 and needs to be converted, so make a backup');
      CopyFile(PChar(LastFileName), PChar(getBackupFileName(LastFileName)), True);
      // note: actual conversion occurs in LoadRecords
    end;
    result := True;
  end;
// ----------------------------------------------
// NOTES on converting TDF files from text to DB:
// 1) there is no RegCode in a text file!
// 2) we always allow conversion, and we always
// save the TaxFile to the server with bconv=1
// ----------------------------------------------
begin
  // ONLY call if isDBFile = FALSE!
  result := True;
  bNoOpen := false;
  if not WeCanConvertFile then exit;
  if mDlg('Do you wish to convert this file to the new' + cr
    + ' encrypted database file version?' + cr, mtInformation, [mbYes, mbNo], 0) = mrYes
  then begin
    sFile := ExtractFileName(LastFileName); // remove path
    sTaxYr := copy(sFile, 1, 4); // first 4 chars should be taxyear
    Try
      iTaxYear := StrToInt(sTaxYr);
    Except
      iTaxYear := 9999;
    End;
    // --------------------------------
    // 2017-05-04 MB - ANYONE CAN CONVERT ANY FILE
    // --------------------------------
    if not CheckTLwebsite then begin
      mDlg('Cannot convert file because TradeLog website is currently unavailable.' + cr
        + cr + 'Please try again later.' + cr, mtWarning, [mbOK], 0);
      exit(false);
    end;
    // --------------------------------
    // ask Pro Users for client reg code
    // --------------------------------
    if ProVer then begin
      if mDlg('Was this file created by a client?', mtConfirmation, [mbYes, mbNo], 0) = mrYes
      then begin
        myInputQuery('Registration Code', 'Enter client registration code: ',
          sClientRegCode, frmMain.Handle);
        if (length(sClientRegCode) <> 24) then exit(false);
        // test for valid regcode
        sRC := checkRegCode(sClientRegCode);
        if not(pos('>OK<', sRC) > 0) then begin // invalid
          sm('That RegCode is not valid.');
          exit(false);
        end
        else if (pos('expired', sRC) > 0) then begin
          sm('That RegCode has expired.');
          exit(false);
        end; // if RegCode = OK and not expired
      end; // if created by client
    end; // if ProVer
    // --------------------------------
    // to get here, sClientRegCode must be valid, so save it to file
    TempProHdr.regCode := sClientRegCode;
    sRegCodeToUse := sClientRegCode;
    result := True;
    msgTxt := '';
    // ask user if he wants to convert
    if mDlg(msgTxt //
      + 'Clicking OK will convert your file and perform the following:' + cr
      + cr //
      + '1) Create a backup copy of your original tdf file' + cr
      + '     which you can restore using File, Backup/Restore.' + cr
      + cr //
      + '2) Encrypt your file for enhanced security.' + cr
      + cr //
      + '3) Rename your file using your Taxpayer name.' + cr //
      , mtConfirmation, [mbOK, mbCancel], 0) <> mrOK then
    begin
      result := false;
      bConvertDB := false;
      TempProHdr.canETY := 0;
    end
    else begin
      result := True;
      bConvertDB := True;
      TempProHdr.canETY := 1;
    end;
  end
  else begin // NOT YES
    result := false;
    bConvertDB := false;
    TempProHdr.canETY := 0;
  end;
end;


// ---------------------------------------------------------
// START Open File processing here - refactored 2016-02-08
// Make sure we can physically open the file
// Determine if it's a TXT or DB file
// 1. IF it's a TXT file...
//   a. determine if we can convert it
//   b. and if the user wants to convert it
//   c. and if it will cost him a TaxFile
// 2. IF it's a DB file...
//   a. determine if the user has permission to open it
//   b. and if it will cost him a TaxFile to do so
// ---------------------------------------------------------
procedure OpenTradeLogFile(LastFileName : string);
var
  sBackFName, sFolder, sFileName, sTaxID, // Line, //reply,
  OldFileName, sPW, sPWreset, sEmail, sFileCode : string;
  i, iTaxYear : integer;
  myOK : word;
  bFileNeedsConversion, bFileClose, bConvertDB, bFrmMainEnabled : boolean;
  Header : TTLFileHeader;
  loadTime : TDateTime;
  txtFile : textFile;
  RowData : TStringList;
  // ---- Abort! -------
  procedure myFileClose;
  begin
    TrFileName := OldFileName;
    bFileClose := True;
    bConvertDB := false;
    OpeningFile := false;
    frmMain.CloseFileIfAny;
    StatBar('off');
  end;
// ==========================
begin
  msgTxt := '';
  isDBFile := false;
  bFileNeedsConversion := false;
  bConvertDB := false;
  bFileClose := false;
  ETradeLoggedIn := false;
  try
    // close any previously open file which also forces all other windows to close.
    frmMain.CloseFileIfAny;
    // -- drive ok? -------------------
    if not validDriveType(LastFileName) then begin
      // message handled by validDriveType function
      myFileClose; // added 2016-02-09 MB
      exit;
    end; // if validDriveType
    // -- file exists? ----------------
    if not FileExistsCaseInsensitive(LastFileName) then begin
      mDlg('File does not exist: ' + cr + LastFileName, mtError, [mbOK], 0);
      myFileClose;
      exit;
    end; // if FileExists...
    // get tax year of file that is being opened
    if (LastFileName <> '') then begin
      sFileName := ExtractFileName(LastFileName); // remove path
      try
        iTaxYear := StrToInt(leftStr(sFileName, 4));
      except
        mDlg(leftStr(sFileName, 4) + ' is not a valid Tax Year', mtError, [mbOK], 0);
        myFileClose;
        exit;
      end; // try...except
    end
    else begin
      iTaxYear := yearOf(now);
    end; // if LastFileName
    // ------------------------------------------
    iVer := GetDataVersion(LastFileName);
    if (iVer = 0) then begin
      mDlg('File is blank and cannot be opened.', mtError, [mbOK], 0);
      myFileClose;
      exit;
    end; // if iVer
    // ------------------------------------------
    // Split into 2 program flows:
    // - CONVERT old file to DBfile
    // - OPEN DBfile
    // ------------ NOT isDBfile ----------------
    nonTaxFile := not(isDBFile); // i.e. no valid ProHeader
    if not isDBFile then begin
      // Converting non-DBfile
      if not ConvertToDBFile(LastFileName, bConvertDB) then begin
        // myFileClose;
        disableEdits;
        // save last file to last 4 files list
        SaveLastFileName(TrFileName);
        // exit;
      end; // if not ConvertToTDBFile (i.e. failed)
    end // -- not isDBfile ----------------------
    else if isDBFile then begin
      nonTaxFile := false;
      // -------------------------------------
      // Do we have permission to open file?
      if not OpenTaxIdFile(LastFileName) then begin
        myFileClose; // NO!
        exit;
      end; // if not OpenTaxIdFile
    end; // if isDBFile
    // --------------------------------
    // show FileSave dialog to convert to DB
    // returns iTaxYear, sFileName, and sFolder
    if bConvertDB then begin
      sFolder := LastFileName;
      sFileName := ParseLast(sFolder, '\'); // do this to get sFolder
      // ------------------------------
      // get file name without tax year and file ext
      // 2015 Jonn Q Public.tdf => Jonn Q Public
      sFileName := fixTaxFile(sFileName); // remove path, ext; insure taxyear
      // need to init Pro Header before user edits
      initProHeader(sFileName);
      if (TdlgFileSave.Execute(iTaxYear, sFileName, sFolder) = mrOK) then begin
        // make a backup copy
        sBackFName := getBackupFileName(LastFileName); // sm(sBackFName);
        CopyFile(PChar(LastFileName), PChar(sBackFName), True);
        // save ProHeader below...
        // remove file extension  move up in openTradeLogFile
        sTaxID := RemoveFileExtension(sFileName); // 2017-04-11 MB
        // --------------------------------
        // check if Taxpayer already exists
        sFileCode := TaxpayerExists(v2ClientToken, sTaxID);
        if (sFileCode <> '') then begin // does the file exist?
          if FileExists(TrFileName) then begin // overwrite
            if mDlg('A file named: ' + TrFileName + cr //
                + 'already exists' + cr //
                + cr //
                + 'Do you wish to overwrite this file?', //
              mtConfirmation, [mbYes, mbNo, mbCancel], 0) <> mrYes
            then begin
              myFileClose;
              exit;
            end; // if mDlg
          end
          else begin
            // must have deleted it, so proceed.
          end; // if FileExists
        end; // if TaxpayerExists
      end
      else begin
        myFileClose;
        exit;
      end; // if TdlgFileSave
    end; // if bConvertDB
    if bFileClose then exit;
    // --------------------------------
    // get TradeLog ready to open file
    with frmMain do begin
      if panelSplash.visible then begin
        panelSplash.Hide;
        btnImport.Enabled := not(OneYrLocked or isAllBrokersSelected);
        EnteringBeginYearPrice := false;
        btnImport.caption := 'Import';
        GridFilter := gfAll;
      end; // if panelSplash.visible
      pnlTools.visible := True;
      bFrmMainEnabled := frmMain.Enabled; // get state
      frmMain.Enabled := True; // 2019-02-14 MB
      pnlMain.visible := True;
      StatusBar.visible := True;
      frmMain.Enabled := bFrmMainEnabled; // 2019-02-15 MB - not necessarily false!
    end; // with frmMain
    // prepare variables for opening file
    TaxYear := '';
    OldFileName := TrFileName;
    TrFileName := ExtractFileName(LastFileName);
    Settings.DataDir := ExtractFilePath(LastFileName);
    if not SetFileTaxYear then exit; // year comes from FileName - ungood!
    dispProfit(false, 0, 0, 0, 0);
    // -------------------------------------
    screen.Cursor := crHourglass;
    loadTime := time; // get current time
    try
      OpeningFile := True;
      // *** READ RECORDS, text file, versions -9..-5 ***
      if not LoadRecords(True) then begin
        myFileClose;
        exit;
      end; // if LoadRecords failed
      frmMain.enableMenuToolsAll;
      GetCurrTaxYear;
      getDataFileName;
      frmMain.caption := Settings.TLVer + ' - ' + DataFileName;
      frmMain.txtSharesOpen.caption := '';
      frmMain.txtProfit.caption := '';
      CheckForNewData;
      checkOneYrLockout;
      CheckForBaks;
      // If any of the Header Account Name values were modified by the open file process
      // then present each Account to the user so they can verify the new name.
      for Header in TradeLogFile.FileHeaders do begin
        if Header.AccountNameChanged then begin
          frmMain.ChangeToTab(Header.AccountName);
          EditCurrentAccount('Account was converted: Please Verify Account Settings');
        end; // if Header.AccountNameChanged
      end; // for Header
    finally
      // do nothing
    end; // try...finally
//    checkTaxYear(OldFileName); // see if file was renamed
    // save as encrypted DB tdf file
    if bConvertDB then begin
      if not saveFileAsDB(LastFileName, sFileName, sFolder, iTaxYear) then begin
        myFileClose;
        exit;
      end; // if saveFileAsDB failed
      // set version to DB
      iVer := 1;
      frmMain.SetupToolBarMenuBar(false);
    end
    else begin // --- unconverted file! ---
      checkImport; // Test to see if user has imported past Jan 31
      if taxidVer and (iVer < 0) then begin
        // lock menus
        disableEdits;
        if not Settings.TrialVersion then begin
          mDlg('Unconverted files are exclusively for viewing data and running reports.' + cr //
            + cr //
            + 'Please note that your file has not been changed.' + cr //
            + cr //
            + 'We strongly suggest that you re-open and convert this file to the new' + cr //
            + ' encrypted file version if you want to continue importing or editing.' + cr,
            mtInformation, [mbOK], 0);
        end; // if not TrialVersion
      end
      else begin
        frmMain.SetupToolBarMenuBar(false);
      end; // if taxidVer
    end; // if bConvertDB
    // --------------------------------
    // save last file to last 4 files list
    SaveLastFileName(TrFileName);
    // --------------------------------
    // setup quick start guide
//    if TradeLogFile.Count = 0 then
//      panelQS.doQuickStart(2, 1, True)
//    else
//      panelQS.doQuickStart(3, 1);
    // --------------------------------
  finally
    if isDBFile then begin
      Settings.IsEIN := (ProHeader.IsEIN = 1);
      // --- if changed, copy TempProHdr to ProHeader -----
      if bProHeaderChanged then begin
        ProHeader.regCode := TempProHdr.regCode;
        ProHeader.regCodeAcct := TempProHdr.regCodeAcct;
        ProHeader.taxFile := TempProHdr.taxFile;
        ProHeader.taxpayer := TempProHdr.taxpayer;
        ProHeader.canETY := TempProHdr.canETY;
        ProHeader.TDFpassword := TempProHdr.TDFpassword;
        ProHeader.IsEIN := TempProHdr.IsEIN;
        if (TempProHdr.email <> '') then
          ProHeader.email := TempProHdr.email;
      end; // if bProHeaderChanged
      // --- check email ----------------------------------
      sEmail := '';
      if (ProHeader.email = '') then begin
        bProHeaderChanged := True;
        if (ProHeader.regCode <> '') then
          sEmail := settings.UserEMail;
        if sEmail <> '' then begin
          if messagedlg('We have your email address on file as' + cr //
              + cr + sEmail + cr //
              + cr + 'Is this correct?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
            ProHeader.email := sEmail;
        end; // if sEmail not blank
        if (ProHeader.email = '') then begin // still blank, so manual input
          ProHeader.email := inputbox('Update Email Address',
            'A valid email address is required to use TradeLog.' + cr //
              + cr + 'Please enter the correct email address:', '');
        end; // if ProHeader.email STILL blank
      end; // if ProHeader.email was blank
      // --------------------------------------------------
      // extract taxpayer name from fName.
      // format of fName: 'taxyear firstname lastname'
      if (ProHeader.taxFile[5] = ' ') //
      and isnumber(leftStr(ProHeader.taxFile, 4)) then begin
        ProHeader.taxFile := Copy(fixTaxFile(ProHeader.taxFile), 6);
        bProHeaderChanged := True;
        if (Uppercase(TaxYear + ' ' + ProHeader.taxFile + '.tdf') = Uppercase(TrFileName)) then
          bEditFileNow := false;
      end; // if taxfile[5]
      // --- if ProHeader was updated, save it NOW! -------
      if bProHeaderChanged then begin
        SaveTradeLogFile('', True);
        bProHeaderChanged := false;
        ClearTempProHdr; // 2017-04-03 MB - moved to after the update
      end; // if bProHeaderChanged
      // --------------------------------------------------
      // if Year End done - disable edits
      if OpeningFile and TradeLogFile.YearEndDone then begin
        disableEdits;
     // frmMain.ReverseEndYear1.Enabled := True;
        frmMain.bbFile_ReverseEndYear.Enabled := True;
      end; // if OpeningFile and YearEndDone
    end
    else begin // isDBFile = FALSE
      disableEdits;
    end; // if isDBFile
    // --------------------------------
    OpeningFile := false;
    getFileLoadTime(loadTime);
    // --------------------------------
    if (ProVer or SuperUser) //
    and not(bWashShortAndLong //
      and bWashUnderlying //
      and bWashStock2Opt //
      and bWashOpt2Stock)
    then
      sm('WARNING: Wash Sale Settings' + cr //
          + 'are different from the default.');
    // --------------------------------
    if not panelSplash.visible then
      frmMain.cxGrid1.SetFocus;
    // --------------------------------
    repaintGrid;
    // --------------------------------
    if (sPW <> '') and (sPW = sPWreset) then begin
      mDlg('Your file password has been reset', mtInformation, [mbOK], 0);
//      frmMain.mnuFile_Edit.click;
    end; // if sPWreset
    // --------------------------------
    // Does user need to edit file now?
    if isDBFile and bEditFileNow then begin
//      if SuperUser then
//        frmMain.mnuFile_Edit.click; // Edit File now!
      bEditFileNow := false;
    end; // if isDBFile and bEditFileNow
    // --------------------------------
  end; // try...finally
end;


//function LocateFile(FileName: String): String;
//var
//  temp: TWIN32FindDataW;
//  searchHandle: THandle;
//  targ: widestring;
//begin
//  // FileName MUST be full path; tildes allowed;
//  // wildcard in filename, but not directories, allowed
//  targ := '\\?\' + FileName;
//  searchHandle := FindFirstFileW(PWChar(targ), temp);
//  if searchHandle <> INVALID_HANDLE_VALUE then begin
//    result := temp.cFileName; // Implicit typecast by Delphi
//    Windows.FindClose(searchHandle);
//  end
//  else result := '';
//end;

procedure TMenuItemHint.DoActivateHint(menuItem: TMenuItem);
begin
  HideTime(self);
  if (menuItem = nil) or (menuItem.Hint = '') then begin
    activeMenuItem := nil;
    exit;
  end;
  activeMenuItem := menuItem;
  showTimer.OnTimer := ShowTime;
  hideTimer.OnTimer := HideTime;
end;


procedure TMenuItemHint.ShowTime(Sender: TObject);
var
  r: TRect;
  wdth: integer;
  hght: integer;
begin
  if activeMenuItem <> nil then begin
    wdth := Canvas.TextWidth(activeMenuItem.Hint);
    hght := Canvas.TextHeight(activeMenuItem.Hint);
    r.Left := Mouse.CursorPos.x + 16;
    r.Top := Mouse.CursorPos.Y + 16;
    r.Right := r.Left + wdth + 6;
    r.Bottom := r.Top + hght + 4;
    ActivateHint(r, activeMenuItem.Hint);
  end;
  showTimer.OnTimer := nil;
end;


procedure TMenuItemHint.HideTime(Sender: TObject);
begin
  self.ReleaseHandle;
  hideTimer.OnTimer := nil;
end;


procedure ShowMenuHint(var Msg: TWMMenuSelect; var Form: TForm;
  var miHint: TMenuItemHint);
var
  menuItem: TMenuItem;
  hSubMenu: HMENU;
begin
  try
    menuItem := nil;
    if (Msg.MenuFlag <> $FFFF) or (Msg.IDItem <> 0) then begin
      if Msg.MenuFlag and MF_POPUP = MF_POPUP then begin
        hSubMenu := GetSubMenu(Msg.Menu, Msg.IDItem);
        menuItem := Form.Menu.FindItem(hSubMenu, fkHandle);
      end
      else menuItem := Form.Menu.FindItem(Msg.IDItem, fkCommand);
    end;
    miHint.DoActivateHint(menuItem);
  except
    // Todd Flora - if this fails we don't care. just trying to show the hint.
  end;
end;


{ Todd Flora - Since this is called using both the Settings.UserFmt and the Settings.InternalFmt
  and the locale is not part of the original TFormatSettings record we need to have it passed
  in here so that we can get the LOCALE_IDATE value to support processing this
   OldLine: function IsLongDateEx(s : string; var Fmt : TFormatSettings):boolean; }
function IsLongDateEx(s: string; Fmt: TFormatSettings; locale: integer)
  : boolean;
var
  DateOrdr, LongDateLen, i, dsLen: integer;
begin
  { Todd Flora - Many changes to this. Add the first two lines to simulate what DP was doing in
    the Custom TFormatSettings fields. Replace DateDep with theoriginal DateSeperator character
    throughout the routine etc.) }
  LongDateLen := 8 + (length(Fmt.DateSeparator) * 2);
  { Todd Flora - Using the passed in locale here }
  DateOrdr := strToInt(GetLocInfo(locale, LOCALE_IDATE, 2));
  result := false;
  if length(s) <> LongDateLen then exit;
  dsLen := length(Fmt.DateSeparator);
  for i := 1 to LongDateLen do begin
    if DateOrdr = sdoYMD then begin
      if ((i = 5) or (i = 7 + dsLen)) then begin
        if (copy(s, i, dsLen) <> Fmt.DateSeparator) then exit;
      end
      else if i < 5 then begin // Year
        if not isInt(copy(s, i, 1)) then exit;
      end
      else if i < (7 + dsLen) then begin // Month or Day
        if (i > (4 + dsLen)) then
          if not isInt(copy(s, i, 1)) then exit;
      end
      else if i > (6 + (dsLen * 2)) then // Month or Day
        if not isInt(copy(s, i, 1)) then exit;
    end
    else if ((i = 3) or (i = 5 + dsLen)) then begin
      if (copy(s, i, dsLen) <> Fmt.DateSeparator) then exit;
    end
    else if i < 3 then begin // Month or Day
      if not isInt(copy(s, i, 1)) then exit;
    end
    else if i < (5 + dsLen) then begin // Month or Day
      if (i > (2 + dsLen)) then
        if not isInt(copy(s, i, 1)) then exit;
    end
    else if i > (4 + (dsLen * 2)) then // Year
      if not isInt(copy(s, i, 1)) then exit;
  end;
  result := True;
end;


function IsTime(s: string): boolean;
var
  TestTime: TDateTime;
begin
  result := TryStrToTime(s, TestTime, Settings.UserFmt);
end;

procedure webURL(url: string);
begin
  ShellExecute(GetDesktopWindow(), 'open', PChar(url), nil, nil, SW_SHOWNORMAL);
end;


//function ProcessRunning(sExeName: String) : Boolean;
//// -> sExeName : Name of the EXE without path. Does not have to be the full EXE name.
//var
//    hSnapShot : THandle;
//    ProcessEntry32 : TProcessEntry32;
//begin
//    Result := false;
//    hSnapShot := CreateToolhelp32Snapshot (TH32CS_SNAPPROCESS, 0);
//    Win32Check (hSnapShot <> INVALID_HANDLE_VALUE);
//    sExeName := LowerCase (sExeName);
//    FillChar (ProcessEntry32, SizeOf (TProcessEntry32), #0);
//    ProcessEntry32.dwSize := SizeOf (TProcessEntry32);
//    if (Process32First (hSnapShot, ProcessEntry32)) then
//      repeat
//        if (Pos (sExeName,
//          LowerCase (ProcessEntry32.szExeFile)) = 1)
//        then begin
//          Result := true;
//          Break;
//        end; { if }
//      until (Process32Next (hSnapShot, ProcessEntry32) = false);
//    CloseHandle (hSnapShot);
//end; // ProcessRunning


function ExecuteFile(const FileName, Params, DefaultDir: string;
  ShowCmd: integer): THandle;
var
  zFileName, zParams, zDir: array [0 .. 127] of Char;
begin
  result := ShellExecute(Application.MainForm.Handle, nil,
    StrPCopy(zFileName, FileName), StrPCopy(zParams, Params),
    StrPCopy(zDir, DefaultDir), ShowCmd);
end;


function DelParenthesis(TxtStr: String): string;
begin
  while pos('(', TxtStr) > 0 do delete(TxtStr, pos('(', TxtStr), 1);
  while pos(')', TxtStr) > 0 do delete(TxtStr, pos(')', TxtStr), 1);
  result := TxtStr;
end;

//function DelNeg(TxtStr: String; Fmt: TFormatSettings): string;
//begin
//  Case Fmt.NegCurrFormat of
//  0, 4, 14 .. 15: Begin
//      while pos('(', TxtStr) > 0 do delete(TxtStr, pos('(', TxtStr), 1);
//      while pos(')', TxtStr) > 0 do delete(TxtStr, pos(')', TxtStr), 1);
//    End;
//  Else if pos('-', TxtStr) = 1 then delete(TxtStr, 1, 1);
//  End;
//  result := TxtStr;
//end;

function DelNonAlpha(const AValue: string): string;
var
  SrcPtr, DestPtr: PChar;
  i: integer;
  s: string;
begin
  s := '';
  for i := 0 to length(AValue) do begin
    if AValue[i] in ['a' .. 'z', 'A' .. 'Z'] then s := s + AValue[i];
  end;
  result := s;
end;

function DelCommas(TxtStr: string): string;
var
  s: string;
begin
  s := ',';
  while pos(s, TxtStr) > 0 do begin
    delete(TxtStr, pos(s, TxtStr), 1);
  end;
  result := TxtStr;
end;

function DelQuotes(TxtStr: string): string;
var
  s: string;
begin
  s := '"';
  while pos(s, TxtStr) > 0 do begin
    delete(TxtStr, pos(s, TxtStr), 1);
  end;
  result := TxtStr;
end;

// Thread Safe, For US Input strings ONLY you can use DelCommas instead
function Del1000SepEx(TxtStr: string; Fmt: TFormatSettings): string;
var
  s: string;
begin
  s := Fmt.ThousandSeparator;
  while pos(s, TxtStr) > 0 do begin
    delete(TxtStr, pos(s, TxtStr), 1);
  end;
  result := TxtStr;
end;


// Accepts ONLY US Formatted Input String!
function UserDateStr(s: String): String;
var
  i, j, k, m: integer;
begin
  result := DateToStr(xStrToDate(s), Settings.UserFmt);
end;

// Accepts ONLY US-Formatted string!
function FracDecToFloat(txt: string): double;
var
  Dv, Sp, Len, FrTop, FrBtm: integer;
  DecPr, pr: double;
  PriceFr: String;
begin
  result := -1;
  delete(txt, pos('$', txt), 1);
  delete(txt, pos(',', txt), 1);
  Dv := pos('/', txt);
  Sp := pos(' ', txt);
  if (Dv > 0) { and (Sp > 0) } then { price is fraction }
  begin
    PriceFr := txt;
    DecPr := 0; { convert to decimal }
    Len := length(PriceFr);
    FrBtm := strToInt(copy(PriceFr, Dv + 1, Len - Dv));
    FrTop := strToInt(copy(PriceFr, Sp + 1, Dv - Sp - 1));
    if Sp > 0 then DecPr := strToInt(copy(PriceFr, 1, pos(' ', PriceFr) - 1));
    pr := DecPr + FrTop / FrBtm;
    result := pr;
  end
  else if txt <> '' then { price is decimal }
    try
      result := StrToFloat(txt, Settings.internalFmt);
    except
      //
    end;
end;

// Thread Safe
function FracDecToFloatEx(txt: string; Fmt: TFormatSettings): double;
var
  Dv, Sp, Len, FrTop, FrBtm: integer;
  DecPr, pr: double;
  PriceFr: String;
begin
  result := -1;
  delete(txt, pos('$', txt), 1);
  delete(txt, pos(Fmt.ThousandSeparator, txt), 1);
  Dv := pos('/', txt);
  Sp := pos(' ', txt);
  if (Dv > 0) { and (Sp > 0) } then { price is fraction }
  begin
    PriceFr := txt;
    DecPr := 0; { convert to decimal }
    Len := length(PriceFr);
    FrBtm := strToInt(copy(PriceFr, Dv + 1, Len - Dv));
    FrTop := strToInt(copy(PriceFr, Sp + 1, Dv - Sp - 1));
    if Sp > 0 then DecPr := strToInt(copy(PriceFr, 1, pos(' ', PriceFr) - 1));
    pr := DecPr + FrTop / FrBtm;
    result := pr;
  end
  else if txt <> '' then { price is decimal }
    try
      result := StrToFloat(txt, Fmt);
    except
      //
    end;
end;

//function DecToFrac(Dec: Real): string;
//var
//  whole: integer;
//  fract: Real;
//  FrTop, FrBtm, Num64ths: Real;
//begin
//  FrBtm := 64;
//  whole := trunc(Dec);
//  fract := Frac(Dec);
//  if fract > 0 then begin
//    Num64ths := fract / 0.015625;
//    If Frac(Num64ths) <> 0 then begin // check if divisble by 64
//      // mDlg('Must be divisible by 64',mtError,[mbCancel],0);
//      result := '';
//    end
//    else begin
//      while Odd(trunc(Num64ths)) = false do begin
//        Num64ths := Num64ths / 2;
//        FrBtm := FrBtm / 2;
//      end;
//      FrTop := Num64ths;
//      result := IntToStr(whole) + ' ' + FloatToStr(FrTop, Settings.internalFmt)
//        + '/' + FloatToStr(FrBtm, Settings.internalFmt);
//    end;
//  end
//  else result := IntToStr(whole);
//end;

//function DecToFracEx(Dec: Real; Fmt: TFormatSettings): string;
//var
//  whole: integer;
//  fract: Real;
//  FrTop, FrBtm, Num64ths: Real;
//begin
//  FrBtm := 64;
//  whole := trunc(Dec);
//  fract := Frac(Dec);
//  if fract > 0 then begin
//    Num64ths := fract / 0.015625;
//    If Frac(Num64ths) <> 0 then begin { check if divisble by 64 }
//      { mDlg('Must be divisible by 64',mtError,[mbCancel],0); }
//      result := '';
//    end
//    else begin
//      while Odd(trunc(Num64ths)) = false do begin
//        Num64ths := Num64ths / 2;
//        FrBtm := FrBtm / 2;
//      end;
//      FrTop := Num64ths;
//      result := IntToStr(whole) + ' ' + FloatToStr(FrTop, Fmt) + '/' + FloatToStr(FrBtm, Fmt);
//    end;
//  end
//  else result := IntToStr(whole);
//end;

// Accepts ONLY US-Formatted Currency Strings!
function CurrToFloat(Curr: string): double;
begin
  if pos('(', Curr) > 0 then begin
    Trim(Curr);
    delete(Curr, pos('(', Curr), 1);
    delete(Curr, pos('-', Curr), 1);
    Trim(Curr);
    delete(Curr, pos(')', Curr), 1);
  end;
  delete(Curr, pos('$', Curr), 1);
  Curr := DelCommas(Curr);
  Trim(Curr);
  try
    if Curr <> '' then
      result := StrToFloat(Curr, Settings.internalFmt)
    else
      result := 0;
  except
    result := -1;
  end;
end;

// Thread Safe
function CurrToFloatEx(Curr: string; Fmt: TFormatSettings): double;
begin
  if pos('(', Curr) > 0 then begin
    Trim(Curr);
    delete(Curr, pos('(', Curr), 1);
    delete(Curr, pos('-', Curr), 1);
    Trim(Curr);
    delete(Curr, pos(')', Curr), 1);
  end;
  delete(Curr, pos(Fmt.CurrencyString, Curr), length(Fmt.CurrencyString));
  Curr := Del1000SepEx(Curr, Fmt);
  Trim(Curr);
  try
    if Curr <> '' then result := StrToFloat(Curr, Fmt) else result := 0;
  except
    result := -1;
  end;
end;


procedure ClearTradesSum;
begin
  TradesSum := nil;
  Finalize(TradesSum);
end;


//function VerifyFileTimeEntry(tm: string; Fmt: TFormatSettings;
//  var ErrorStr: string): string;
//var
//  UserTS: Char;
//  FirstCol, SecondCol: integer;
//  TimeTest: TDateTime;
//  TestHour, TestMin, TestSec: String;
//begin
//  ErrorStr := '';
//  if tm = '' then begin
//    result := '';
//    exit;
//  end;
//  UserTS := Settings.UserFmt.TimeSeparator;
//  if Fmt.TimeSeparator <> UserTS then begin
//    while pos(Fmt.TimeSeparator, tm) > 0 do
//      delete(tm, pos(Fmt.TimeSeparator, tm), length(Fmt.TimeSeparator));
//  end;
//  if pos(UserTS, tm) > 0 then result := tm
//  else begin
//    if (length(tm) = 3) or (length(tm) = 5) then tm := '0' + tm;
//    if length(tm) = 4 then result := copy(tm, 1, 2) + UserTS + copy(tm, 3, 2)
//    else if length(tm) = 6 then
//      result := copy(tm, 1, 2) + UserTS + copy(tm, 3, 2) + UserTS + copy(tm, 5, 2);
//  end;
//  if TryStrToTime(result, TimeTest, Settings.UserFmt) then exit;
//  TestHour := '';
//  TestMin := '';
//  TestSec := '';
//  FirstCol := pos(UserTS, result);
//  if FirstCol > 0 then begin
//    TestHour := leftStr(result, FirstCol - 1);
//    SecondCol := posex(UserTS, result, FirstCol + 1);
//    if SecondCol > 0 then begin
//      TestSec := rightStr(result, length(result) - SecondCol);
//      TestMin := MidStr(result, FirstCol + 1, SecondCol - (length(TestSec) + 2));
//    end;
//  end;
//  if not isInt(TestHour) then TestHour := '00';
//  if not isInt(TestMin) then TestMin := '00';
//  if not isInt(TestSec) then TestSec := '00';
//  if not(TryStrToTime(TestHour + UserTS + '00' + UserTS + '00', TimeTest, Settings.UserFmt))
//  then begin
//    if strToInt(TestHour) > 23 then TestHour := '23' else TestHour := '00';
//  end;
//  if not(TryStrToTime(TestHour + UserTS + TestMin + UserTS + '00', TimeTest, Settings.UserFmt))
//  then begin
//    if strToInt(TestMin) > 59 then TestMin := '59' else TestMin := '00';
//  end;
//  if not(TryStrToTime(TestHour + UserTS + TestMin + UserTS + TestSec, TimeTest, Settings.UserFmt))
//  then begin
//    if strToInt(TestSec) > 59 then TestSec := '59' else TestSec := '00';
//  end;
//  result := TestHour + UserTS + TestMin + UserTS + TestSec;
//  ErrorStr := cr + cr + '"' + tm + '" is not a valid time.' + cr + cr
//    + 'Please enter valid time for this record OR click cancel to ignore all time errors' + cr
//    + 'and Tradelog will import all time format errors with a blank time value.' + cr;
//end;


procedure SetupGUIForFile;
begin
  // display time column if time in data file
  //Settings.DispTimeBool := not TradeLogFile.NoTimeInData; // 2017-05-01 MB - let the user decide
  // Set the visibility of the broker field to match the multiBroker File type.
  Settings.DispAcct := TradeLogFile.MultiBrokerFile;
  TradeRecordsSource := TTLFileDataSource.Create(TradeLogFile, frmMain.cxGrid1TableView1);
  frmMain.SetOptions;
  StatBar('Setting Up Account Tabs');
  frmMain.SetupTabs;
  application.ProcessMessages;
  // turn off grid update
  frmMain.cxGrid1TableView1.BeginUpdate;
  frmMain.cxGrid1TableView1.DataController.CustomDataSource := TradeRecordsSource;
  frmMain.cxGrid1TableView1.EndUpdate;
  GetCurrTaxYear;
end;


function readV5Data: boolean;
var
  loadTime: TDateTime;
begin
  try
    loadTime := now;
    ClearTradesSum;
    // Free any previous file that might have been open
    FreeAndNil(TradeLogFile);
    FreeAndNil(TradeRecordsSource);
    try
      StatBar('Opening Data File');
      TradeLogFile := TTLFile.OpenFile(TrFileName, frmMain.FileStatusCallBack);
      // 2014-02-01 fix for files with item number out of sequence
      TradeLogFile.RenumberItemField;
      if TradeLogFile.FileConverted or TradeLogFile.FileCleaned then
        TradeLogFile.SaveFile(True);
      SetupGUIForFile;
    except
      on E: ETLFileCombineConvertException do
      begin
        mDlg('ERROR: Combined File failed to convert: ' + TrFileName + cr + cr
          + 'Please ensure that all files exist in the same location and try again.'
          + cr + cr + E.Message, mtError, [mbOK], 0);
        StatBar('off');
        exit;
      end;
      on E: ETLFileException do begin
        mDlg('ERROR: File could not be opened' + cr
          + 'The Following Error Occurred: ' + E.Message, mtError, [mbOK], 0);
        StatBar('off');
        exit;
      end;
    end;
    result := True;
  finally
    // readV5Data
  end;
end;


// ----------------------------------------------
function LoadRecords(NewFile: boolean = false;
  chgAcctTab: boolean = True): boolean;
var
  i : integer;
  CurrentAcct, Line, sFile1, sFile2: String;
  txtFile: textFile;
begin
  try
    LoadingRecs := True;
    result := false;
    CurrentAcct := '';
    i := frmMain.tabAccounts.TabIndex;
    if not NewFile and (i > 0) then
      CurrentAcct := frmMain.tabAccounts.Tabs[i].caption;
    try
      FileSetAttr(TrFileName, 0);
      // check if file is encryped db
      if isDBFile then begin
        if not readV5Data then begin
          StatBar('off');
          exit;
        end;
        // --------------------------------------
        // check to see if TaxYear or Taxpayer was changed
        bEditFileNow := false;
        if RightStr(ProHeader.taxFile,4) = '.tdf' then
          sFile1 := Trim(ChangeFileExt(ProHeader.taxFile, ''))
        else
          sFile1 := Trim(IntToStr(TradeLogFile.TaxYear) //
            + ' ' + ProHeader.taxFile);
        sFile2 := Trim(RemoveFileExtension(TrFileName));
        // has the filename been changed?
        if SuperUser
        and (Uppercase(sFile1) <> Uppercase(sFile2)) then begin
          sm('This file is assigned to a Taxpayer or entity named' + CR + CR
            + TAB + sFile1 + CR+ CR
            + 'but the TradeLog file itself is named' + CR + CR
            + TAB + sFile2 + CR + CR
            + 'Please use File\Edit to enter the correct name.');
          bEditFileNow := true;
        end;
        // --------------------------------------
      end
      else if VerifyV5OrGreaterData(Settings.DataDir + '\' + TrFileName) then begin
        // file is plain text
        if not readV5Data then begin
          StatBar('off');
          exit;
        end;
      end
      else begin
        mDlg('ERROR: Invalid File - An Error occured while reading this file.' + CR
          + 'It may not be a Version 5 or later file.' + cr
          + cr
          + 'If this is a Pre Version 5 file please contact Tradelog Support' + CR
          + 'and we will assist you with converting the file.',  mtError, [mbOK], 0);
        exit;
      end;
      StatBar('Loading TradeLog Settings');
      if Not Settings.MTMVersion and TradeLogFile.HasAccountType[atMTM] then begin
        mDlg('This file contains accounts that are Mark-to-Market.' + cr
          + cr
          + 'In order to utilize the MTM functions of TradeLog,' + cr
          + 'you must upgrade to an MTM version of TradeLog.', mtWarning, [mbOK], 0);
      end;
      // Record Limit check
      if (Settings.RecLimit <> '')
      and (TradeLogFile.Count > strToInt(Settings.RecLimit)) then begin
        msgTxt := 'File exceeds current record limit, ' + IntToStr(TradeLogFile.Count) + ' Records';
        msgTxt := msgTxt + cr
          + cr
          + Settings.TLVer + ' is limited to ' + Settings.RecLimit + ' records' + cr
          + cr
          + 'Therefore many functions will be disabled!';
        mDlg(msgTxt, mtWarning, [mbOK], 0);
        msgTxt := '';
        frmMain.Enabled := True;
      end;
      CheckForBaks;
      if (length(CurrentAcct) > 0) and chgAcctTab then
        frmMain.ChangeToTab(CurrentAcct);
      result := True;
    finally
      StatBar('off'); // clears message
      LoadingRecs := false;
    end;
  finally
    // LoadRecords
  end;
end;


procedure DelAll;
var
  txtFile: textFile;
  Line: string;
  Msg: String;
begin
  if TradeLogFile.CurrentBrokerID = 0 then
    Msg := 'Delete All Records for All Broker Accounts?'
  else Msg := 'Delete All Records for Broker: ' +
    TradeLogFile.CurrentAccount.AccountName + '?';
  if mDlg(Msg, mtWarning, [mbNo, mbYes], 0) = mrYes then
  begin
    try
      screen.Cursor := crHourglass;
      SaveTradesBack('Delete All');
      TradeLogFile.SaveFile(True, True);
      LoadRecords;
    finally
      StatBar('off');
    end;
  end;
end;


procedure dispProfit(calc: boolean; profit, openSh, openContr, commis: double);
var
  i: integer;
  oc, prf: string;
  LDate, xDate: TDate;
  Shares: double;
begin
  if TradeLogFile = nil then exit;
  LDate := xStrToDate('01/01/1899');
  if TradeLogFile.Count < 1 then begin
    frmMain.txtCommis.caption := '';
    frmMain.txtSharesOpen.caption := '';
    frmMain.txtContrOpen.caption := '';
    frmMain.txtProfit.caption := '';
    frmMain.txtLastImp.caption := '';
    frmMain.txtNumRecs.caption := '';
    exit;
  end;
  //
  if calc then begin
    profit := 0;
    openSh := 0;
    openContr := 0;
    commis := 0;
    with frmMain.cxGrid1TableView1.DataController do
      for i := 0 to rowCount - 1 do begin
        xDate := GetRowValue(GetRowInfo(i), 2);
        if xDate > LDate then LDate := xDate;
        oc := GetRowValue(GetRowInfo(i), 4);
        Shares := GetRowValue(GetRowInfo(i), 7);
        prf := GetRowValue(GetRowInfo(i), 9);
        if (pos('STK', prf) = 1) //
        or (pos('MUT', prf) = 1) //
        or (pos('DRP', prf) = 1) //
        or (pos('ETF', prf) = 1) //
        or (pos('VTN', prf) = 1) // 2019-07-01 MB - count VTNs as Shares, not Contracts
        then begin
          if (oc = 'O') then openSh := openSh + Shares;
          if (oc = 'C') or (oc = 'M') then openSh := openSh - Shares;
        end
        else begin
          if (oc = 'O') then openContr := openContr + Shares;
          if (oc = 'C') or (oc = 'M') then openContr := openContr - Shares;
        end;
        profit := profit + GetRowValue(GetRowInfo(i), 12);
        commis := commis + GetRowValue(GetRowInfo(i), 10);
      end; // for
    // end with... do
  end; // if calc
  // if profit < 0 then
  //Rj July 6, 2021 Turn off the red color
  if (compareValue(profit, 0, NEARZERO) < 0) then
     // frmMain.txtProfit.Font.Color := clRed // rj
  else
    frmMain.txtProfit.Font.Color := clWhite; // rj jan 31, 2021 clBlack;clBlack;
  // if profit = 0 then
  if (compareValue(profit, 0, NEARZERO) = 0) then
    frmMain.txtProfit.caption := ''
  else
    frmMain.txtProfit.caption := CurrStrEx(profit, Settings.UserFmt);
  // ----- SHARES OPEN ------
  if (compareValue(openSh, 0, NEARZERO) < 0) then begin
    frmMain.txtSharesOpen.caption := FormatFloat('###,###,##0.######', openSh);
    // frmMain.txtSharesOpen.Font.Color := clRed; //rj
  end
  else begin
    frmMain.txtSharesOpen.Font.Color := clWhite; //rj jan 31, 2021 clBlack;
    if openSh = 0 then
      frmMain.txtSharesOpen.caption := '0'
    else
      frmMain.txtSharesOpen.caption := FormatFloat('###,###,##0.######', openSh);
  end;
  // ---- CONTRACTS OPEN ----
  if (compareValue(openContr, 0, NEARZERO) < 0) then begin
    frmMain.txtContrOpen.caption := FormatFloat('###,###,##0.######', openContr);
//rj    frmMain.txtContrOpen.Font.Color := clRed;
  end
  else begin
    frmMain.txtContrOpen.Font.Color := clWhite; //rj jan 31, 2021 clBlack;clBlack;
    //
    if (compareValue(openContr, 0, NEARZERO) = 0) then
      frmMain.txtContrOpen.caption := '0'
    else
      frmMain.txtContrOpen.caption := FormatFloat('###,###,##0.######', openContr);
      // previously was frmMain.txtContrOpen.caption
      // := FloatToStrFmt('%1.5f', [openContr], Settings.UserFmt);
  end;
  //
  frmMain.txtCommis.caption := CurrStrEx(commis, Settings.UserFmt);
  if calc then frmMain.txtLastImp.caption := DateToStr(LDate, Settings.UserFmt);
  //
  frmMain.txtNumRecs.caption := FormatFloat('###,###,##0',
    frmMain.cxGrid1TableView1.DataController.rowCount);
  // frmMain.repaint;  // 2015-07-15 crashes when deleting recs
end;


// ==========================
// Sorting Routines
// ==========================
procedure SortByLS;
var
  i: integer;
begin
  if SortBy = 'LS' then exit;
  SortBy := 'LS';
  StatBar('Sorting by LS');
  with frmMain.cxGrid1TableView1 do begin
    for i := 0 to 17 do
      Items[i].sortorder := soNone;
    Items[5].sortorder := soAscending;
    DataController.gotoFirst;
  end;
  StatBar('off');
  frmMain.cxGrid1.SetFocus;
end;

procedure SortByMatched;
var
  i: integer;
  SOrder: TdxSortOrder;
begin
  //if SortBy = 'matched' then exit;
  SortBy := 'matched';
  StatBar('Sorting by Match Tax Lots');
  try
    frmMain.cxGrid1TableView1.BeginUpdate;
    SOrder := frmMain.cxGrid1TableView1.Items[23].sortorder;
    for i := 0 to frmMain.cxGrid1TableView1.ItemCount - 1 do
      frmMain.cxGrid1TableView1.Items[i].sortorder := soNone;
    if (SOrder = soDescending) or (SOrder = soNone) then
      frmMain.cxGrid1TableView1.Items[23].sortorder := soAscending
    else
      frmMain.cxGrid1TableView1.Items[23].sortorder := soDescending;
  finally
    frmMain.cxGrid1TableView1.EndUpdate;
    frmMain.cxGrid1TableView1.DataController.gotoFirst;
    frmMain.cxGrid1.SetFocus;
    StatBar('off');
  end;
end;

procedure SortByTicker(bStatBar: boolean = True);
var
  i: integer;
  SOrder: TdxSortOrder;
begin
  //if SortBy = 'tick' then exit;
  SortBy := 'tick';
  if bStatBar then begin
    StatBar('Sorting by Ticker');
    screen.Cursor := crHourglass;
  end;
  try
    frmMain.cxGrid1TableView1.BeginUpdate;
    SOrder := frmMain.cxGrid1TableView1.Items[18].sortorder;
    for i := 0 to frmMain.cxGrid1TableView1.ItemCount - 1 do
      frmMain.cxGrid1TableView1.Items[i].sortorder := soNone;
    if (SOrder = soDescending) or (SOrder = soNone) then
      frmMain.cxGrid1TableView1.Items[18].sortorder := soAscending
    else
      frmMain.cxGrid1TableView1.Items[18].sortorder := soDescending;
  finally
    frmMain.cxGrid1TableView1.EndUpdate;
    frmMain.cxGrid1TableView1.DataController.gotoFirst;
    if bStatBar then begin
      StatBar('off');
      screen.Cursor := crDefault;
    end;
  end;
end;

procedure SortByDate;
var
  i: integer;
begin
  //if SortBy = 'date' then exit;
  SortBy := 'date';
  StatBar('Sorting by Date');
  for i := 0 to 17 do
    frmMain.cxGrid1TableView1.Items[i].sortorder := soNone;
  frmMain.cxGrid1TableView1.Items[2].sortorder := soAscending;
  StatBar('off');
end;

procedure SortByTypeNoOpt;
var
  i: integer;
begin
  SortBy := 'type';
  StatBar('Sorting by Type/Mult');
  for i := 0 to 19 do
    frmMain.cxGrid1TableView1.Items[i].sortorder := soNone;
  frmMain.cxGrid1TableView1.Items[9].sortorder := soDescending;
  StatBar('off');
end;

procedure SortByType;
var
  i: integer;
begin
  SortBy := 'type';
  StatBar('Sorting by Type/Mult');
  for i := 0 to 17 do
    frmMain.cxGrid1TableView1.Items[i].sortorder := soNone;
  frmMain.cxGrid1TableView1.Items[9].sortorder := soDescending;
  frmMain.cxGrid1TableView1.Items[18].sortorder := soAscending;
  StatBar('off');
end;

procedure SortByTradeNum;
var
  i: integer;
begin
  SortBy := ''; // blank means TradeNum!
  frmMain.GridFilter := gfAll;
  for i := 0 to 18 do
    frmMain.cxGrid1TableView1.Items[i].sortorder := soNone;
end;


procedure SortByAmount;
var
  i: integer;
begin
  SortBy := 'amount';
  for i := 0 to 17 do
    frmMain.cxGrid1TableView1.Items[i].sortorder := soNone;
  frmMain.cxGrid1TableView1.Items[11].sortorder := soAscending;
end;


procedure CopyTradesSumToClip;
var
  i: integer;
  TradesOCtxt: string;
  TradesSumCount: integer;
begin
  Clipboard.clear;
  TradesOCtxt := '';
  TradesSumCount := length(TradesSum) - 1;
  for i := 1 to TradesSumCount do begin
    with TradesSum[i] do begin
      TradesOCtxt := TradesOCtxt + IntToStr(tr) + tab + tk + tab
        + FloatToStr(os, Settings.UserFmt) + tab
        + FloatToStr(cs, Settings.UserFmt) + tab + od + tab + cd + tab
        + FloatToStr(oa, Settings.UserFmt) + tab
        + FloatToStr(ca, Settings.UserFmt) + tab
        + FloatToStr(cm, Settings.UserFmt) + cr;
    end; // with TradeSum[i]
  end; // for i
  try
    Clipboard.Astext := TradesOCtxt;
  finally
    Clipboard.close;
  end;
  sm('TradesSum array:' + cr + cr + 'Copied ' + IntToStr(TradesSumCount)
    + ' Records to clipboard');
end;


// ------------------------------------
// this is ONLY called by File \ New!
// ------------------------------------
procedure CreateNewFile;
var
  i: integer;
  txtFile: textFile;
  Folder, OldFolder, OldTrFileName, TaxpayerID,
    regCheckURL, reply0, sFileName, sTaxID: String;
  Yr, Mo, Day: word;
  Year: integer;
  exitFileNew: boolean;
  NewFile: TTLFile;
begin
  exitFileNew := false;
  OldTrFileName := TrFileName;
  Folder := Settings.DataDir;
  TrFileName := '';
  DecodeDate(now, Yr, Mo, Day);
  Year := Yr;
//  frmMain.Close1Click(nil);
  frmMain.CloseFileIfAny;
  // --------------------------------------------
  // NOTE: Super and Trial Users don't need TaxFiles!
  if not (SuperUser or Settings.TrialVersion) then begin
    // check TL website; cancel if not available.
    if not CheckTLwebsite then begin
      mDlg('Cannot create a new file because TradeLog website is currently unavailable.'
        + cr + cr + 'Please try again later.' + cr, mtWarning, [mbOK], 0);
      exit; // can't do anything if we can't connect!
    end;
  end;
  // --------------------------------
  // What is the name of the new file?
  if TdlgFileSave.Execute(Year, TrFileName, Folder, True) = mrCancel then begin
    TrFileName := OldTrFileName; // CANCELed by User
    exit;
  end;
  // delete file ext
  sFileName := copy(TrFileName, 1, pos('.td', TrFileName) - 1); // tdf OR tdb
  sTaxID := RemoveFileExtension(sFileName); // 2017-04-11 MB - isn't this redundant?
  // ----------------------------------
  OldFolder := Settings.DataDir;
  Settings.DataDir := Folder;
  disableMenuTools;
  isDBFile := taxidVer; // all new files will be DBfiles - 2016-02-09 MB
  ClearTradesSum;
  with frmMain do begin
    txtCommis.caption := '';
    txtSharesOpen.caption := '';
    txtContrOpen.caption := '';
    txtProfit.caption := '';
    txtLastImp.caption := '';
    txtNumRecs.caption := '';
  end;
  panelSplash.Hide;
  NewFile := TTLFile.CreateNew(TrFileName, '', imSelectEachTime, IntToStr(Year),
    0, false, false, false, frmMain.FileStatusCallBack);
  // ----------------------------------
  if TdlgAccountSetup.Execute(NewFile.FileHeader[1], True) = mrCancel then begin
    mDlg('New File Creation Cancelled.', mtInformation, [mbOK], 0);
    TrFileName := OldTrFileName;
    Settings.DataDir := OldFolder;
//    frmMain.Close1Click(nil);
    frmMain.CloseFileIfAny;
    NewFile.Free;
    exit;
  end;
  // ----------------------------------
  FreeAndNil(TradeLogFile);
  TradeLogFile := NewFile;
  // -------------- overwrite? ------------------
  if FileExists(Settings.DataDir + '/' + TrFileName)
  and not exitFileNew then begin
    if mDlg('A file named: ' + TrFileName + cr + 'already exists' + cr + cr
      +'Do you wish to over write this file?'
      , mtConfirmation, [mbYes, mbNo, mbCancel], 0) <> mrYes
    then
      exitFileNew := True
    else
      deleteUndoRedo;
  end;
  // ---- do we need to CANCEL? -------
  if exitFileNew then begin
    TrFileName := OldTrFileName;
    Settings.DataDir := OldFolder;
//    frmMain.Close1Click(nil);
    frmMain.CloseFileIfAny;
    exit;
  end;
  // ---- NO, we need to SAVE! --------
  TradeLogFile.SaveFile(True);
  SaveLastFileName(ExtractFileName(TrFileName));
  SetupGUIForFile;
  screen.Cursor := crDefault;
  frmMain.pnlMain.visible := True;
  // 2024-02-22 MB -- change to add Import Settings before BLWiz
  // offer to call import settings if broker is "fastlinkable"
  if (TradeLogFile.CurrentAccount.importFilter.FastLinkable) then begin
    if mDlg('This broker supports BrokerConnect' + CRLF //
      + 'Would you like to set that up now?',
      mtConfirmation, mbYesNo, 0) = mrYes
    then
      EditCurrentImport(''); // import settings
  end;
  // finally, call baseline wizard when creating new account tab
  if baselineWizardOn then begin
    frmMain.mnuBaselinePositionWizard.click; // mnuBaselinePositionWizardClick;
  end;
end;


procedure EnterBeginYearPrice;
var
  tick, ls, prf: string;
begin
  if not CheckRecordLimit then exit;
  EnteringBeginYearPrice := True;
  { We do not want any filter previously set to be set after this }
  MainFilterStream.clear;
  StatBar('Entering baseline positions');
//  if panelQS.cboStep.ItemIndex > 0 then panelQS.doQuickStart(2, 1);
  if TradeLogFile.CurrentAccount.MTM
  and TradeLogFile.CurrentAccount.MTMLastYear then
    filterByOpenPositonsMTM(xStrToDate('01/01/' + TaxYear))
  else
    filterByOpenPositons(xStrToDate('12/31/' + LastTaxYear));
  frmMain.btnAddRec.click;
end;


//function RoundUpCents(Amount: double): double;
//var
//  AmoStr, DollarStr: string;
//begin
//  if Amount = 0 then begin
//    result := 0;
//    exit;
//  end;
//  AmoStr := FloatToStr(Amount, Settings.UserFmt);
//  if pos('.', AmoStr) > 0 then begin
//    DollarStr := copy(AmoStr, 1, pos(Settings.UserFmt.DecimalSeparator,
//      AmoStr) - 1);
//    delete(AmoStr, 1, pos(Settings.UserFmt.DecimalSeparator, AmoStr) - 1);
//    if length(AmoStr) > 3 then begin
//      AmoStr := '0' + copy(AmoStr, 1, 3);
//      Amount := StrToFloat(AmoStr, Settings.UserFmt) +
//        StrToFloat('0.01', Settings.internalFmt);
//      AmoStr := FloatToStr(Amount, Settings.UserFmt);
//      result := StrToFloat(DollarStr, Settings.UserFmt) +
//        StrToFloat(AmoStr, Settings.UserFmt);
//    end
//    else result := Amount; // fixed Invalid Floating Point Operation error
//  end
//  else begin
//    DollarStr := AmoStr;
//    result := StrToFloat(DollarStr, Settings.UserFmt);
//  end;
//end;


function RoundToDec(Amount: double; nDecimals: integer): double;
var
  i : integer;
  N, R : double;
begin
  N := 1;
  for i := 0 to nDecimals do begin
    N := N * 10;
  end;
  R := N * Amount;
  R := Round(R);
  result := (R / N);
end;

//function CheckForMoreClosedShares: boolean;
//var
//  TrSC: string;
//  i: integer;
//  TradesSumCount: integer;
//begin
//  LoadTradesSum('', '');
//  TrSC := '';
//  TradesSumCount := length(TradesSum) - 1;
//  for i := 1 to TradesSumCount do begin
//    with TradesSum[i] do begin
//      if cs > os then begin
//        if TrSC = '' then TrSC := IntToStr(tr)
//        else TrSC := TrSC + ', ' + IntToStr(tr);
//      end;
//    end;
//  end;
//  if (TrSC <> '') then result := True else result := false;
//end;


procedure ToggleShortLong;
var
  i, rec: integer;
  Tickers: TStringList;
  EditedTrades: TTradeList;
begin
  if frmMain.cxGrid1TableView1.DataController.GetSelectedCount = 0 then begin
    mDlg('Please select records to Toggle Short/Long for', mtError, [mbOK], 0);
    exit;
  end;
  if mDlg('This will toggle the selected trades' + cr +
    'from "Long to Short" or "Short to Long".' + cr + cr +
    'Is this what you want to do?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes
  then exit;
  screen.Cursor := crHourglass;
  Tickers := TStringList.Create;
  EditedTrades := TTradeList.Create;
  try
    Tickers.Delimiter := ',';
    Tickers.Duplicates := dupIgnore;
    with frmMain.cxGrid1TableView1.DataController do begin
      for i := 0 to GetSelectedCount - 1 do begin
        rec := GetRowInfo(GetSelectedRowIndex(i)).RecordIndex;
        if (Tickers.IndexOf(Trim(TradeLogFile[rec].Ticker)) = -1) then
          Tickers.Add(Trim(TradeLogFile[rec].Ticker));
        if TradeLogFile[rec].oc = 'O' then begin
          TradeLogFile[rec].oc := 'C';
          // TradeLogFile[Rec].Time := '16:00:00';  //2014-07-15
        end
        else if TradeLogFile[rec].oc = 'C' then begin
          TradeLogFile[rec].oc := 'O';
          // TradeLogFile[Rec].Time := '00:00:00';  //2014-07-15
        end;
        if TradeLogFile[rec].ls = 'L' then
          TradeLogFile[rec].ls := 'S'
        else if TradeLogFile[rec].ls = 'S' then
          TradeLogFile[rec].ls := 'L';
        EditedTrades.Add(TradeLogFile[rec]);
      end;
      ClearSelection;
    end;
    clearFilter;
    if panelMsg.visible then panelMsg.Hide;
    screen.Cursor := crHourglass;
    StatBar('Matching Trades');
    EditedTrades.AddRange(TradeLogFile.Match(Tickers));
    TradeLogFile.Reorganize;
    TradeRecordsSource.DataChanged;
    SaveTradeLogFile('Toggle Short/Long');
  finally
    Tickers.Free;
    EditedTrades.Free;
    screen.Cursor := crDefault;
  end;
end;


// ------------------------------------
//              StatBar
// ------------------------------------
procedure StatBar(Stat: string);
begin
  try
    StatBar(Stat, tlYellow);
  except
    On E : Exception Do
    gsMainErrMsg := 'StatBar error: ' + E.Message;
  end;
end;

procedure StatBar(Stat: String; myColor: TColor);
begin
  // sm(stat);
  with frmMain do begin
    stMessage.Font.Style := [];
    if Stat = 'off' then begin
      screen.Cursor := crDefault;
      stMessage.FillColor := clBtnFace;
      stMessage.Font.Style := [];
      stMessage.caption := 'Ready';
      rbStatusBar.Panels[5].Text := 'Ready'; //RJ Jan 1, 2021
      StatusBar.update;
    end
    else begin
      // screen.cursor := crHourglass;
      stMessage.FillColor := myColor;
      stMessage.Font.Style := [];
      stMessage.caption := Stat;
      rbStatusBar.Panels[5].Visible := true;
      rbStatusBar.Panels[5].Text := Stat; //RJ Jan 1, 2021
      StatusBar.update;
    end;
  end;
  Application.ProcessMessages;
end;


// ------------------------------------
function MakeSettlmentAdj(oldDate : TDate): TDate;
begin
  // if after IRS rule change...
  if oldDate < EncodeDate(2017,09,05) then
    result := TTLDateUtils.IncBusinessDay(oldDate, 3)
  else if oldDate < EncodeDate(2024,05,28) then
    result := TTLDateUtils.IncBusinessDay(oldDate, 2)
  else
    result := TTLDateUtils.IncBusinessDay(oldDate, 1);
end;

function MakeSettlmentAdj(oldDate : TDateTime): TDateTime;
begin
  // if after IRS rule change...
  if oldDate < EncodeDate(2017,09,05) then
    result := TTLDateUtils.IncBusinessDay(oldDate, 3)
  else if oldDate < EncodeDate(2024,05,28) then
    result := TTLDateUtils.IncBusinessDay(oldDate, 2)
  else
    result := TTLDateUtils.IncBusinessDay(oldDate, 1);
end;


function GetSettlementDate(TrSum: PTTrSum): TDate;
begin
  if length(TrSum.cd) > 0 then
    result := xStrToDate(TrSum.cd, Settings.UserFmt)
  else
    result := 0;
  // If Short Sell and Stock Type and a loss then add 2 or 3 to the Date Sold
  if ((TrSum.ws <> wsPrvYr) and (TrSum.ws <> wsThisYr))
  and (TrSum.ls = 'S') //
  and (IsStockType(TrSum.prf)) //
  and (length(TrSum.cd) > 0) then begin
    // if after IRS rule change...
    result := MakeSettlmentAdj(result);
  end;
end;

function GetSettlementDate(TrSum: TTlTradeSummary): TDate;
begin
  if TrSum.CloseDate > 0 then
    result := TrSum.CloseDate
  else
    result := 0;
  // If Short Sell and Stock Type and a loss then add 3 to the Date Sold
  if ((TrSum.WashSaleType <> TWashSaleType.wsPrvYr)
    and (TrSum.WashSaleType <> TWashSaleType.wsThisYr)) //
  and (TrSum.ls = 'S') //
  and (IsStockType(TrSum.typemult)) //
  and (TrSum.CloseDate > 0) then begin
    // if after IRS rule change...
    result := MakeSettlmentAdj(result);
  end;
end;
// ------------------------------------

// Accepts ONLY mm/dd/yyyy Formatted Input String
function YYYYMMDD(DateStr: string): string;
var
  Yr, Mo, Da: word;
  Mon, Dai: string;
begin
  result := '';
  try
    // test for proper internal date format
    DecodeDate(xStrToDate(DateStr, Settings.internalFmt), Yr, Mo, Da);
  except
    sm('ERROR: YYYYMMDD convert');
  end;
  Mon := IntToStr(Mo);
  Dai := IntToStr(Da);
  if length(Mon) < 2 then Mon := '0' + Mon;
  if length(Dai) < 2 then Dai := '0' + Dai;
  result := IntToStr(Yr) + Mon + Dai;
end;


// Thread Safe
function YYYYMMDD_Ex(DateStr: string; Fmt: TFormatSettings): string;
var
  Yr, Mo, Da: word;
  Mon, Dai: string;
begin
  result := '';
  try
    DecodeDate(xStrToDate(DateStr, Fmt), Yr, Mo, Da);
  except
    sm('ERROR: YYYYMMDD_Ex convert: ' + DateStr);
  end;
  Mon := IntToStr(Mo);
  Dai := IntToStr(Da);
  if length(Mon) < 2 then Mon := '0' + Mon;
  if length(Dai) < 2 then Dai := '0' + Dai;
  result := IntToStr(Yr) + Mon + Dai;
end;

// Expects DateStr in form of YYYYMMDD
function MMDDYYYY(sYYYYMMDD : string) : string;
begin
  result := '';
  if length(sYYYYMMDD) = 8 then begin
    // DE: should return inmternal date fmt
    result := copy(sYYYYMMDD, 5, 2) + Settings.internalFmt.DateSeparator //
      + copy(sYYYYMMDD, 7, 2) + Settings.internalFmt.DateSeparator //
      + copy(sYYYYMMDD, 1, 4);
  end;
end;


procedure CheckForBaks;
var
  i: integer;
  found: boolean;
  doDir, doFileName, doListFileName, tmpStr, tmpStr2: string;
  srch: TSearchRec;
  dte: TDateTime;
  InFileStream, OutFileStream: TFileStream;
  CompressStream: TZCompressionStream;
begin
  with frmMain do begin
    if TrFileName = '' then begin // no file open, so buttons disabled
      btnRedo.Enabled := false;
      Redo1.Enabled := false;
      frmMain.bbRedo_small.Enabled := false;
      frmMain.bbRedo_Large.Enabled := false;
      btnUndo.Enabled := false;
      Undo1.Enabled := false;
      frmMain.bbUndo_small.Enabled := false;
      frmMain.bbUndo_Large.Enabled := false;
      exit;
    end;
    found := false;
    doDir := Settings.DataDir + '\Redo';
    try
      if DirectoryExists(doDir) then begin
        doFileName := doDir + '\' + copy(TrFileName, 1,
          pos('.tdf', TrFileName) - 1);
        doListFileName := doFileName + ' REDOLIST.txt';
        if FileExists(doListFileName) then begin
          for i := 1 to 9 do begin
            tmpStr := doFileName + ' REDO' + IntToStr(i) + '.tdz';
            if FileExists(tmpStr) then begin
              found := True;
              break;
            end;
          end;
          if found = false then deleteFile(doListFileName);
        end;
      end;
    except
      //
    end;
    // 2021-06-04 MB - Allow Redo on All Accounts, too!
    btnRedo.Enabled := found; // and (TradeLogFile.CurrentBrokerID > 0);
    Redo1.Enabled := found; // and (TradeLogFile.CurrentBrokerID > 0);
    frmMain.bbRedo_small.Enabled := found; // and (TradeLogFile.CurrentBrokerID > 0);
    frmMain.bbRedo_Large.Enabled := found; // and (TradeLogFile.CurrentBrokerID > 0);
    //
    found := false;
    doDir := Settings.DataDir + '\Undo';
    try
      if DirectoryExists(doDir) then begin
        doFileName := doDir + '\' + copy(TrFileName, 1,
          pos('.tdf', TrFileName) - 1);
        doListFileName := doFileName + ' UNDOLIST.txt';
        if FileExists(doListFileName) then begin
          tmpStr := doFileName + ' UNDO?.tdf';
          srch.ExcludeAttr := 0;
          srch.FindHandle := FindFirstFile(PChar(tmpStr), srch.FindData);
          if srch.FindHandle <> INVALID_HANDLE_VALUE then begin
            for i := 1 to 9 do begin
              tmpStr := doFileName + ' UNDO' + IntToStr(i) + '.tdf';
              tmpStr2 := doFileName + ' UNDO' + IntToStr(i) + '.tdz';
              if (FileExists(tmpStr)) //
              and not(FileExists(tmpStr2)) then begin
                found := True;
                InFileStream := TFileStream.Create(tmpStr, fmOpenRead);
                OutFileStream := TFileStream.Create(tmpStr2, fmCreate);
                CompressStream := TZCompressionStream.Create(OutFileStream, zcDefault);
                CompressStream.CopyFrom(InFileStream, InFileStream.Size);
                CompressStream.Free;
                OutFileStream.Free;
                InFileStream.Free;
                if fileAge(tmpStr, dte) then begin
                  FileSetDate(tmpStr2, DateTimeToFileDate(dte));
                  deleteFile(tmpStr);
                end; // if fileAge
              end; // if FileExists
            end; // for i
          end; // if srch
          FindClose(srch);
          if not found then
            for i := 1 to 9 do begin
              tmpStr := doFileName + ' UNDO' + IntToStr(i) + '.tdz';
              if FileExists(tmpStr) then begin
                found := True;
                break;
              end;
            end;
          if not found then
            deleteFile(doListFileName); // no files, don't need List
        end;
      end
    except
      // do nothing?
    end;
    // 2021-06-04 MB - Allow Redo on All Accounts, too!
    btnUndo.Enabled := found; // and (TradeLogFile.CurrentBrokerID > 0);
    Undo1.Enabled := found; // and (TradeLogFile.CurrentBrokerID > 0);
    frmMain.bbUndo_small.Enabled := found; // and (TradeLogFile.CurrentBrokerID > 0);
    frmMain.bbUndo_Large.Enabled := found; // and (TradeLogFile.CurrentBrokerID > 0);
  end;
end;


procedure deleteUndoRedo;
var
  sDir, sFileName, dFileName, sList: string;
  i: integer;
begin
  sDir := Settings.DataDir + '\Redo';
  sFileName := sDir + '\' + copy(TrFileName, 1, pos('.tdf', TrFileName) - 1);
  sList := sFileName + ' REDOLIST.txt';
  deleteFile(sList);
  for i := 1 to 9 do begin
    dFileName := sFileName + ' REDO' + IntToStr(i) + '.tdz';
    if FileExists(dFileName) then deleteFile(dFileName);
  end;
  sDir := Settings.DataDir + '\Undo';
  sFileName := sDir + '\' + copy(TrFileName, 1, pos('.tdf', TrFileName) - 1);
  sList := sFileName + ' UNDOLIST.txt';
  deleteFile(sList);
  for i := 1 to 9 do
  begin
    dFileName := sFileName + ' UNDO' + IntToStr(i) + '.tdz';
    if FileExists(dFileName) then deleteFile(dFileName);
  end;
end;


function Redo(ShowMsg: boolean): boolean;
var
  i, x: integer;
  bdt, mdt: TDateTime;
  redoDir, redoFileName, redoListFileName, redoList, tmpStr: string;
  redoListFile: textFile;
  InFileStream, OutFileStream: TFileStream;
  DeCompressStream: TZDecompressionStream;
  RedoFunc: String;
begin
  if IsFormOpen('frmOpenTrades') then exit; // can't redo from Open Trades
  result := false;
  CheckForBaks;
  if frmMain.btnRedo.Enabled = false then exit;
  redoDir := Settings.DataDir + '\Redo';
  redoFileName := redoDir + '\' + copy(TrFileName, 1,
    pos('.tdf', TrFileName) - 1);
  redoListFileName := redoFileName + ' REDOLIST.txt';
  AssignFile(redoListFile, redoListFileName);
  Reset(redoListFile);
  readLn(redoListFile, redoList);
  RedoFunc := copy(redoList, 1, pos('|', redoList) - 1);
  close(redoListFile);
  mdt := 0;
  x := 0;
  for i := 1 to 9 do begin
    tmpStr := redoFileName + ' REDO' + IntToStr(i) + '.tdz';
    if FileExists(tmpStr) then
      if fileAge(tmpStr, bdt) = True then
        if mdt < bdt then begin
          mdt := bdt;
          x := i;
        end;
      // end if fileAge
    // end if fileExists
  end;
  if ShowMsg then begin
    if mDlg('Redo ' + RedoFunc + '?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes
    then begin
      frmMain.btnRedo.down := false;
      exit;
    end;
  end;
  redoing := true;
  SaveTradesBack(RedoFunc); // Create Undo
  redoing := false;
  redoFileName := redoFileName + ' REDO' + IntToStr(x) + '.tdz';
  InFileStream := TFileStream.Create(redoFileName, fmOpenRead);
  OutFileStream := TFileStream.Create(TrFileName, fmCreate);
  DeCompressStream := TZDecompressionStream.Create(InFileStream);
  OutFileStream.CopyFrom(DeCompressStream, 0);
  // OutFileStream.CopyFrom(InFileStream, 0);
  DeCompressStream.Free;
  OutFileStream.Free;
  InFileStream.Free;
  deleteFile(redoFileName);
  // delete RedoList last Redo string
  AssignFile(redoListFile, redoListFileName);
  if FileExists(redoListFileName) then begin
    Reset(redoListFile);
    readLn(redoListFile, redoList);
    delete(redoList, 1, pos('|', redoList));
  end;
  if redoList = '' then begin
    if FileExists(redoListFileName) then close(redoListFile);
    frmMain.Redo1.Enabled := false; // redundant
    frmMain.btnRedo.Enabled := false; // redundant
    frmMain.bbRedo_small.Enabled := false;
    frmMain.bbRedo_Large.Enabled := false; // redundant
    if FileExists(redoListFileName) then
      deleteFile(redoListFileName);
  end
  else begin;
    Rewrite(redoListFile);
    writeLn(redoListFile, redoList);
    close(redoListFile);
  end;
  LoadRecords;
  result := True;
  dispProfit(True, 0, 0, 0, 0); // recompute bluebar after ReDo
  StatBar('off');
end;


function Undo(ShowMsg: boolean = True; ReLoadFile: boolean = True): boolean;
var
  i, x: integer;
  bdt, mdt: TDateTime; // for new fileAge
  bakDir, BakFileName, undoListFileName, undoList, tmpStr: string;
  undoListFile: textFile;
  InFileStream, OutFileStream: TFileStream;
  DeCompressStream: TZDecompressionStream;
  UndoFunc: String;
begin
  if not frmMain.bbUndo_small.Enabled //
  or IsFormOpen('frmOpenTrades') then exit;
  result := false;
  CheckForBaks;
  bakDir := Settings.DataDir + '\Undo';
  BakFileName := bakDir + '\' + copy(TrFileName, 1,
    pos('.tdf', TrFileName) - 1);
  undoListFileName := BakFileName + ' UNDOLIST.txt';
  AssignFile(undoListFile, undoListFileName);
  if FileExists(undoListFileName) then begin
    Reset(undoListFile);
    readLn(undoListFile, undoList);
    UndoFunc := copy(undoList, 1, pos('|', undoList) - 1);
    close(undoListFile);
  end;
  if UndoFunc = '' then exit;
  mdt := 0;
  x := 0;
  for i := 1 to 9 do begin
    tmpStr := BakFileName + ' UNDO' + IntToStr(i) + '.tdz';
    if FileExists(tmpStr) then begin
      if fileAge(tmpStr, bdt) = True then begin
        if mdt < bdt then begin
          mdt := bdt;
          x := i;
        end;
      end; // if fileAge
    end; // if FileExists
  end; // for i
  if ShowMsg then begin
    if mDlg('Undo ' + UndoFunc + '?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes
    then begin
      frmMain.bbUndo_small.down := false; // 2021-06-04 MB - is this necessary?
      exit;
    end;
  end;
  panelMsg.Hide;
  screen.Cursor := crHourglass;
  if ReLoadFile then begin
    SaveTradesRedo(UndoFunc); // <-- adds this UNDO to the REDO list
    BakFileName := BakFileName + ' UNDO' + IntToStr(x) + '.tdz';
    InFileStream := TFileStream.Create(BakFileName, fmOpenRead);
    OutFileStream := TFileStream.Create(Settings.DataDir + '\' + TrFileName, fmCreate);
    DeCompressStream := TZDecompressionStream.Create(InFileStream);
    OutFileStream.CopyFrom(DeCompressStream, 0);
    // OutFileStream.CopyFrom(InFileStream, 0);
    DeCompressStream.Free;
    OutFileStream.Free;
    InFileStream.Free;
    deleteFile(BakFileName);
  end;
  // delete undoList last undo string
  AssignFile(undoListFile, undoListFileName);
  if FileExists(undoListFileName) then begin
    Reset(undoListFile);
    readLn(undoListFile, undoList);
    delete(undoList, 1, pos('|', undoList));
  end;
  if undoList = '' then begin
    frmMain.Undo1.Enabled := false; // redundant
    frmMain.btnUndo.Enabled := false; // redundant
    frmMain.bbUndo_small.Enabled := false;
    frmMain.bbUndo_Large.Enabled := false; // redundant
    if FileExists(undoListFileName) then close(undoListFile);
    if FileExists(undoListFileName) then deleteFile(undoListFileName);
  end
  else begin
    Rewrite(undoListFile);
    writeLn(undoListFile, undoList);
    close(undoListFile);
  end;
  if ReLoadFile then begin
    LoadRecords;
    dispProfit(True, 0, 0, 0, 0);
    nextDateStart := TradeLogFile.LastDateImported + 1;
    screen.Cursor := crDefault;
    StatBar('off');
  end;
  result := True;
end;


procedure SaveTradesBack(SaveName: String);
var
  i, x: integer;
  bdt, mdt: TDateTime;
  currDir, bakDir, fname, BakFileName, undoList, undoListFileName,
    tmpStr, RedoFileName: string;
  undoListFile: textFile;
  InFileStream, OutFileStream: TFileStream;
  CompressStream: TZCompressionStream;
begin
  if Reordering then exit;
  StatBar('Creating Undo File');
  if assigned(TradeLogFile) then begin // 2021-06-04 MB - now allow Undo from All Accounts
    frmMain.btnUndo.Enabled := true; // TradeLogFile.CurrentBrokerID > 0;
    frmMain.Undo1.Enabled := true; // TradeLogFile.CurrentBrokerID > 0;
    frmMain.bbUndo_small.Enabled := true; // TradeLogFile.CurrentBrokerID > 0;
    frmMain.bbUndo_Large.Enabled := true; // TradeLogFile.CurrentBrokerID > 0;
  end;
  // make sure there is no path in TrFileName
  fname := ExtractFileName(TrFileName);
  currDir := Settings.DataDir;
  bakDir := currDir + '\Undo';
  if not DirectoryExists(bakDir) then
    CreateDirectoryEx(PChar(currDir), PChar(bakDir), nil);
  SetFileAttributes(PChar(bakDir), FILE_ATTRIBUTE_HIDDEN);
  BakFileName := bakDir + '\' + copy(fname, 1, pos('.tdf', fname) - 1);
  // save undo text to undoList text file
  undoListFileName := BakFileName + ' UNDOLIST.txt';
  mdt := 0;
  x := 1;
  // find newest of all existing UNDOs
  for i := 1 to 9 do begin
    tmpStr := BakFileName + ' UNDO' + IntToStr(i) + '.tdz';
    if FileExists(tmpStr) then begin
      if fileAge(tmpStr, bdt) = True then begin
        if mdt < bdt then begin
          mdt := bdt;
          x := i + 1;
        end;
      end;
    end;
  end;
  if x = 10 then x := 1; // startover
  BakFileName := BakFileName + ' UNDO' + IntToStr(x) + '.tdz';
  DM.BackUpDb(BakFileName);
// Ralph removed the following as exception created in FireDac.
//  InFileStream := TFileStream.Create(currDir + '\' + fname, fmOpenRead);
//  OutFileStream := TFileStream.Create(BakFileName, fmCreate);
//  CompressStream := TZCompressionStream.Create(OutFileStream, zcDefault);
//  CompressStream.CopyFrom(InFileStream, InFileStream.Size);
//  CompressStream.Free;
//  OutFileStream.Free;
//  InFileStream.Free;
  // write to undo fileList
  AssignFile(undoListFile, undoListFileName);
  if FileExists(undoListFileName) then begin
    Reset(undoListFile);
    readLn(undoListFile, undoList);
    undoList := SaveName + '|' + undoList;
    // Add Code for a Timing issue where sometimes there is a Sharing Violation when this file is rewritten.
    // Also add Closefile so that the file is closed and released properly by Delphi before we rewrite
    close(undoListFile);
    Application.ProcessMessages;
    // End of Add Code for Timing Issue.
  end
  else undoList := SaveName + '|';
  Rewrite(undoListFile);
  writeLn(undoListFile, undoList);
  close(undoListFile);
  // 2021-05-26 MB - creating new UNDO makes all existing REDO's invalid!
  // UNLESS the step we are performing is itself a REDO, that is.
  if not redoing then begin
    RedoFileName := currDir + '\Redo\' //
      + copy(fname, 1, pos('.tdf', fname) - 1) + ' REDO';
    for i := 1 to 9 do begin // delete all REDO*.tdz files!
      tmpStr := RedoFileName + IntToStr(i) + '.tdz';
      if FileExists(tmpStr) then
        deleteFile(tmpStr);
    end;
    tmpStr := currDir + '\Redo\' //
      + copy(TrFileName, 1, pos('.tdf', TrFileName) - 1)
      + ' REDOLIST.txt';
    deleteFile(tmpStr); // delete the REDOLIST also
    frmMain.btnRedo.Enabled := false;
    frmMain.Redo1.Enabled := false;
    frmMain.bbRedo_small.Enabled := false;
    frmMain.bbRedo_Large.Enabled := false;
  end;
end;


procedure SaveTradesRedo(RedoName: String);
var
  i, x: integer;
  bdt, mdt: TDateTime;
  currDir, redoDir, redoFileName, redoList, redoListFileName, tmpStr: string;
  redoListFile: textFile;
  InFileStream, OutFileStream: TFileStream;
  CompressStream: TZCompressionStream;
begin
  if Reordering then exit;
  // ------------------------
  frmMain.btnRedo.Enabled := True;
  frmMain.bbRedo_small.Enabled := True;
  frmMain.bbRedo_large.Enabled := True;
  // ------------------------
  currDir := Settings.DataDir;
  redoDir := currDir + '\Redo';
  if not DirectoryExists(redoDir) then
    CreateDirectoryEx(PChar(currDir), PChar(redoDir), nil);
  SetFileAttributes(PChar(redoDir), FILE_ATTRIBUTE_HIDDEN);
  redoFileName := redoDir + '\' + copy(TrFileName, 1,
    pos('.tdf', TrFileName) - 1);
  // save undo text to undoList text file
  redoListFileName := redoFileName + ' REDOLIST.txt';
  mdt := 0;
  x := 1;
  // find newest of all existing UNDOs
  for i := 1 to 9 do begin
    tmpStr := redoFileName + ' REDO' + IntToStr(i) + '.tdz';
    if FileExists(tmpStr) then begin
      if fileAge(tmpStr, bdt) = True then begin
        if mdt < bdt then begin
          mdt := bdt;
          x := i + 1;
        end; // if mdt
      end; // if fileAge
    end; // if FileExists
  end; // for i
  if x = 10 then x := 1; // startover
  redoFileName := redoFileName + ' REDO' + IntToStr(x) + '.tdz';
  InFileStream := TFileStream.Create(currDir + '\' + TrFileName, fmOpenRead);
  OutFileStream := TFileStream.Create(redoFileName, fmCreate);
  CompressStream := TZCompressionStream.Create(OutFileStream, zcDefault);
  CompressStream.CopyFrom(InFileStream, InFileStream.Size);
  CompressStream.Free;
  OutFileStream.Free;
  InFileStream.Free;
  // write to undo fileList
  AssignFile(redoListFile, redoListFileName);
  if FileExists(redoListFileName) then begin
    Reset(redoListFile);
    readLn(redoListFile, redoList);
    redoList := RedoName + '|' + redoList;
  end
  else
    redoList := RedoName + '|';
  Rewrite(redoListFile);
  writeLn(redoListFile, redoList);
  close(redoListFile);
end;


procedure SaveEndYearBack;
var
  TrFileBack: string;
begin
  TrFileBack := TrFileName;
  delete(TrFileBack, pos('.tdf', TrFileBack), 4);
  TrFileBack := TrFileBack + '.bak';
  if not CopyFile(PChar(TrFileName), PChar(TrFileBack), false) then
      sm('ERROR: File Copy - End Year Reversal File');
end;


procedure GetCurrTaxYear;
Var
  clickedOK, YearOK: boolean;
  MaxYear: word;
begin
  // sm('GetCurrTaxYear');
  if TrFileName = '' then exit;
  TaxYear := IntToStr(TradeLogFile.TaxYear);
  MaxYear := yearOf(now) + 20;
  if not isInt(TaxYear) then
    TaxYear := ''
  else begin
    if (strToInt(TaxYear) < 1990) or (strToInt(TaxYear) > MaxYear) then begin
      TaxYear := '';
      NextTaxYear := '';
    end;
  end;
  If TaxYear = '' then begin
    Repeat
      YearOK := false;
      clickedOK := myInputQuery('Tax Year', 'ENTER CURRENT TAX YEAR: ', TaxYear,
        frmMain.Handle);
      if not clickedOK then exit;
      if (TaxYear <> '') then begin
        if (isInt(TaxYear)) and (length(TaxYear) = 4) then begin
          NextTaxYear := IntToStr(strToInt(TaxYear) + 1);
          YearOK := True;
        end
        else
          sm('Tax Year must be 4 numeric digits between' + cr + '1990 and '
            + IntToStr(MaxYear));
      end;
    Until YearOK;
  end;
  NextTaxYear := IntToStr(strToInt(TaxYear) + 1);
  LastTaxYear := IntToStr(strToInt(TaxYear) - 1);
end;


// -----------------------------------------------
// Get Tax Year from 1st 4 characters of filename
// -----------------------------------------------
function SetFileTaxYear(): boolean;
Var
  clickedOK: boolean;
  OldFile, NewFile: string;
  MaxYear, YrInt: word;
  SpaceMissing: boolean;
begin
  result := false;
  SpaceMissing := false;
  if TrFileName = '' then exit;
  TaxYear := copy(TrFileName, 1, 4); // the filename may not be reliable!
  MaxYear := yearOf(now) + 20;
  YrInt := 0;
  if (pos('-', TaxYear) = 0) and isInt(TaxYear) then begin
    YrInt := strToInt(TaxYear);
    result := (YrInt >= 1990) and (YrInt <= MaxYear);
    SpaceMissing := result and (copy(TrFileName, 5, 1) <> ' ');
  end;
  If not result or SpaceMissing then begin
    NextTaxYear := '';
    LastTaxYear := '';
    if not SpaceMissing then
      TaxYear := ''
    else
      mDlg(
        'TradeLog File Names must be in the format "YYYY <Name>.tdf". Where YYYY is the tax year'
        + cr + 'followed by a space and the user provided <Name>. This file is missing the space'
        + cr + 'between the year and the name. TradeLog will attempt to fix this issue.',
        mtError, [mbOK], 0);
    While not result do begin
      // give the user a chance to enter the Tax Year
      clickedOK := myInputQuery('Tax Year', 'WHAT IS FILE''S TAX YEAR?',
        TaxYear, frmMain.Handle);
      if not clickedOK then exit;
      if (TaxYear <> '') then begin
        if (pos('-', TaxYear) = 0) and isInt(TaxYear) then begin
          YrInt := strToInt(TaxYear);
          result := (YrInt >= 1990) and (YrInt <= MaxYear)
        end;
        if not result then begin
          sm('Tax Year must be 4 numeric digits between' + cr + '1990 and '
            + IntToStr(MaxYear));
        end;
      end; // if TaxYear <> ''
    end; // while... do
    // OK, we have a year number, now...
    OldFile := Settings.DataDir + '\' + TrFileName;
    if SpaceMissing then
      Insert(' ', TrFileName, 5)
    else
      TrFileName := TaxYear + ' ' + TrFileName;
    NewFile := Settings.DataDir + '\' + TrFileName;
    try
      if CopyFile(PChar(OldFile), PChar(NewFile), True) then begin
        if not deleteFile(OldFile) then
          mDlg('File Copied, but Original Remains because Tradelog could not delete it.',
            mtError, [mbOK], 0);
      end
      else begin
        result := false;
        mDlg('File Rename Failed.' + cr +
          'Check that new name is unique and that' + cr +
          'You have proper file permissions for Renaming.', mtError, [mbOK], 0);
        frmMain.CloseFileIfAny;
        exit;
      end; // if CopyFile...
    except
      result := false;
      mDlg('File Rename Failed.' + cr + 'Check that new name is unique and that'
        + cr + 'You have proper file permissions for Renaming.', mtError,
        [mbOK], 0);
      frmMain.CloseFileIfAny;
      exit;
    end; // try... except
  end; // if Not Results or SpaceMissing
  NextTaxYear := IntToStr(YrInt + 1);
  LastTaxYear := IntToStr(YrInt - 1);
end;


// -----------------------------------------------
// if path\TrFileName > 80 chars...
// -----------------------------------------------
procedure getDataFileName;
var
  origLen: integer;
begin
  DataFileName := Settings.DataDir + '\' + TrFileName;
  origLen := length(DataFileName);
  while length(DataFileName) > 80 do
      DataFileName := copy(DataFileName, pos('\', DataFileName) + 1,
      length(DataFileName) - pos('\', DataFileName));
  if origLen > length(DataFileName) then DataFileName := '..\' + DataFileName;
end;


//function IntToTimeStr(TimeStr: string): string;
//begin
//  if length(TimeStr) = 6 then
//    TimeStr := copy(TimeStr, 1, 2) + ':' + copy(TimeStr, 3, 2) + ':'
//      + copy(TimeStr, 5, 2)
//  else if length(TimeStr) = 4 then
//    TimeStr := copy(TimeStr, 1, 2) + ':' + copy(TimeStr, 3, 2);
//  result := TimeStr;
//end;


// This should be in frmMain
procedure repaintGrid;
begin
  frmMain.cxGrid1.Refresh;
  try
    if not OpeningFile //
    and not frmMain.AddRec //
    and not frmMain.EditRec //
    and not frmMain.InsertRec then //
      screen.Cursor := crDefault;
  except
    screen.Cursor := crDefault; // if tests fail
  end;
  Application.ProcessMessages;
  frmMain.cxGrid1TableView1.DataController.gotoFirst;
  dispProfit(True, 0, 0, 0, 0);
end;


//function addYearCodeToExp(tick, mYear: string): string;
//var
//  tkStr: string;
//begin
//  tick := uppercase(tick);
//  if pos('JAN', tick) > 0 then begin
//    tkStr := copy(tick, 1, pos('JAN', tick) + 2) + mYear;
//    delete(tick, 1, pos('JAN', tick) + 2);
//    tkStr := tkStr + tick;
//    result := tkStr;
//  end
//  else if pos('FEB', tick) > 0 then begin
//    tkStr := copy(tick, 1, pos('FEB', tick) + 2) + mYear;
//    delete(tick, 1, pos('FEB', tick) + 2);
//    tkStr := tkStr + tick;
//    result := tkStr;
//  end
//  else if pos('MAR', tick) > 0 then begin
//    tkStr := copy(tick, 1, pos('MAR', tick) + 2) + mYear;
//    delete(tick, 1, pos('MAR', tick) + 2);
//    tkStr := tkStr + tick;
//    result := tkStr;
//  end
//  else if pos('APR', tick) > 0 then begin
//    tkStr := copy(tick, 1, pos('APR', tick) + 2) + mYear;
//    delete(tick, 1, pos('APR', tick) + 2);
//    tkStr := tkStr + tick;
//    result := tkStr;
//  end
//  else if pos('MAY', tick) > 0 then begin
//    tkStr := copy(tick, 1, pos('MAY', tick) + 2) + mYear;
//    delete(tick, 1, pos('MAY', tick) + 2);
//    tkStr := tkStr + tick;
//    result := tkStr;
//  end
//  else if pos('JUN', tick) > 0 then begin
//    tkStr := copy(tick, 1, pos('JUN', tick) + 2) + mYear;
//    delete(tick, 1, pos('JUN', tick) + 2);
//    tkStr := tkStr + tick;
//    result := tkStr;
//  end
//  else if pos('JUL', tick) > 0 then begin
//    tkStr := copy(tick, 1, pos('JUL', tick) + 2) + mYear;
//    delete(tick, 1, pos('JUL', tick) + 2);
//    tkStr := tkStr + tick;
//    result := tkStr;
//  end
//  else if pos('AUG', tick) > 0 then begin
//    tkStr := copy(tick, 1, pos('AUG', tick) + 2) + mYear;
//    delete(tick, 1, pos('AUG', tick) + 2);
//    tkStr := tkStr + tick;
//    result := tkStr;
//  end
//  else if pos('SEP', tick) > 0 then begin
//    tkStr := copy(tick, 1, pos('SEP', tick) + 2) + mYear;
//    delete(tick, 1, pos('SEP', tick) + 2);
//    tkStr := tkStr + tick;
//    result := tkStr;
//  end
//  else if pos('OCT', tick) > 0 then begin
//    tkStr := copy(tick, 1, pos('OCT', tick) + 2) + mYear;
//    delete(tick, 1, pos('OCT', tick) + 2);
//    tkStr := tkStr + tick;
//    result := tkStr;
//  end
//  else if pos('NOV', tick) > 0 then begin
//    tkStr := copy(tick, 1, pos('NOV', tick) + 2) + mYear;
//    delete(tick, 1, pos('NOV', tick) + 2);
//    tkStr := tkStr + tick;
//    result := tkStr;
//  end
//  else if pos('DEC', tick) > 0 then begin
//    tkStr := copy(tick, 1, pos('DEC', tick) + 2) + mYear;
//    delete(tick, 1, pos('DEC', tick) + 2);
//    tkStr := tkStr + tick;
//    result := tkStr;
//  end;
//end;


// -----------------------------------------------
// disable most menus during some processes
// -----------------------------------------------
procedure disableMenuTools;
var
  i: integer;
begin
  with frmMain do begin
    // disable menu
//    Save1.Enabled := false;
//    bbFile_Save.Enabled := false; rj 5/4/2021 enabled if file is open
//    mnuFile_Edit.Enabled := false;
    // BackupRestore1.Enabled := False;
//    mnuFile_EndTaxYear.Enabled := false;
    bbFile_EndTaxYear.Enabled := false;
//    ReverseEndYear1.Enabled := false;
    bbFile_ReverseEndYear.Enabled := false;
    mnuEdit.Enabled := false;
    mnuAcct.Enabled := false;
    mnuAdd.Enabled := false;
    Find.Enabled := false;
    Reports1.Enabled := false;
    //rj Feb 6, 2021 make Ribbon visible/invisible based on above values
    EnableTabItems('disableEdits');
    // popup menus, too
    SetPopupMenuEnabled(pupEdit, false);
    SetPopupMenuEnabled(pupView, false);
    SetPopupMenuEnabled(pupFind, false);
    // ----------------------
    for i := 0 to View1.Count - 1 do
      View1.Items[i].Enabled := false;
    // disable toolbar
    for i := 0 to ToolBar1.controlcount - 1 do
      ToolBar1.Controls[i].Enabled := false;
    // ----------------------
    tabAccounts.Enabled := false;
  end;
end;


// -----------------------------------------------
// do we have an internet connection?
// -----------------------------------------------
function GetOnlineStatus: boolean;
var
  ConTypes: integer;
begin
  ConTypes := INTERNET_CONNECTION_MODEM + INTERNET_CONNECTION_LAN +
    INTERNET_CONNECTION_PROXY;
  if (InternetGetConnectedState(@ConTypes, 0) = True) then exit(true);
  mDlg('No Interenet connection found!' + cr + cr
   + 'Many functions in TradeLog such as Product Registration' + cr
   + 'and Online Help require an Internet connection' + cr + cr
   + 'Please make sure you are connected to the internet' + cr,
   mtWarning, [mbOK], 0);
  result := false;
end;


//function FuncAvail(VLibraryname, VFunctionname: string;
//  var VPointer: pointer): boolean;
//var
//  Vlib: THandle;
//begin
//  result := false;
//  VPointer := NIL;
//  if LoadLibrary(PChar(VLibraryname)) = 0 then exit;
//  Vlib := GetModuleHandle(PChar(VLibraryname));
//  if Vlib <> 0 then begin
//    VPointer := GetProcAddress(Vlib, PChar(VFunctionname));
//    if VPointer <> NIL then result := True;
//  end;
//end;


//procedure progressBar(i, x: integer);
//var
//  pos: integer;
//begin
//  with frmRangeSelect do begin
//    if i = x then begin
//      progrBar.visible := false;
//      exit;
//    end;
//    if Frac(i / 100) = 0 then begin
//      pos := trunc(i / x * 100);
//      if pos < 100 then begin
//        progrBar.visible := True;
//        progrBar.position := round(pos);
//      end;
//    end;
//    repaint;
//  end;
//end;


function getStrike(s: string): string;
begin
  if (s = 'A') then result := '5'
  else if (s = 'B') then result := '10'
  else if (s = 'C') then result := '15'
  else if (s = 'D') then result := '20'
  else if (s = 'E') then result := '25'
  else if (s = 'F') then result := '30'
  else if (s = 'G') then result := '35'
  else if (s = 'H') then result := '40'
  else if (s = 'I') then result := '45'
  else if (s = 'J') then result := '50'
  else if (s = 'K') then result := '55'
  else if (s = 'L') then result := '60'
  else if (s = 'M') then result := '65'
  else if (s = 'N') then result := '70'
  else if (s = 'O') then result := '75'
  else if (s = 'P') then result := '80'
  else if (s = 'Q') then result := '85'
  else if (s = 'R') then result := '90'
  else if (s = 'S') then result := '95'
  else if (s = 'T') then result := '100'
  else if (s = 'U') then result := '7.5'
  else if (s = 'V') then result := '12.5'
  else if (s = 'W') then result := '17.5'
  else if (s = 'X') then result := '22.5'
  else if (s = 'Y') then result := '27.5'
  else if (s = 'Z') then result := '2.5';
end;


function getCallPut(s: string): string;
begin
  if (s < 'M') then
    result := 'CALL'
  else
    result := 'PUT';
end;


function getFutExpMonth(s: string): string;
begin
  // F - Jan   G - Feb   H - Mar   J - Apr   K - May   M - Jun
  // N - Jul    Q - Aug U - Sep   V - Oct   X - Nov   Z - Dec
  s := uppercase(s);
  if (s = 'F') then result := 'JAN'
  else if (s = 'G') then result := 'FEB'
  else if (s = 'H') then result := 'MAR'
  else if (s = 'J') then result := 'APR'
  else if (s = 'K') then result := 'MAY'
  else if (s = 'M') then result := 'JUN'
  else if (s = 'N') then result := 'JUL'
  else if (s = 'Q') then result := 'AUG'
  else if (s = 'U') then result := 'SEP'
  else if (s = 'V') then result := 'OCT'
  else if (s = 'X') then result := 'NOV'
  else if (s = 'Z') then result := 'DEC'
  else result := '';
end;


function getExpMonth(s: string): string;
begin
  if (s = 'A') or (s = 'M') then result := 'JAN'
  else if (s = 'B') or (s = 'N') then result := 'FEB'
  else if (s = 'C') or (s = 'O') then result := 'MAR'
  else if (s = 'D') or (s = 'P') then result := 'APR'
  else if (s = 'E') or (s = 'Q') then result := 'MAY'
  else if (s = 'F') or (s = 'R') then result := 'JUN'
  else if (s = 'G') or (s = 'S') then result := 'JUL'
  else if (s = 'H') or (s = 'T') then result := 'AUG'
  else if (s = 'I') or (s = 'U') then result := 'SEP'
  else if (s = 'J') or (s = 'V') then result := 'OCT'
  else if (s = 'K') or (s = 'W') then result := 'NOV'
  else if (s = 'L') or (s = 'X') then result := 'DEC';
end;


function getOptExpDate(ExpMo, ExpYr: string): TDate;
var
  expDate: TDate;
begin
  // no need for 1990 dates
  // if pos('0',expYr)=1 then expYr:= '20'+expYr else expYr:= '19'+expYr;
  if length(ExpYr) = 2 then ExpYr := '20' + ExpYr;
  if pos('JAN', ExpMo) > 0 then ExpMo := '01'
  else if pos('FEB', ExpMo) > 0 then ExpMo := '02'
  else if pos('MAR', ExpMo) > 0 then ExpMo := '03'
  else if pos('APR', ExpMo) > 0 then ExpMo := '04'
  else if pos('MAY', ExpMo) > 0 then ExpMo := '05'
  else if pos('JUN', ExpMo) > 0 then ExpMo := '06'
  else if pos('JUL', ExpMo) > 0 then ExpMo := '07'
  else if pos('AUG', ExpMo) > 0 then ExpMo := '08'
  else if pos('SEP', ExpMo) > 0 then ExpMo := '09'
  else if pos('OCT', ExpMo) > 0 then ExpMo := '10'
  else if pos('NOV', ExpMo) > 0 then ExpMo := '11'
  else if pos('DEC', ExpMo) > 0 then ExpMo := '12';
  try
    expDate := xStrToDate(ExpMo + '/01/' + ExpYr, Settings.internalFmt);
    if dayOfWeek(expDate) = 1 then
      expDate := xStrToDate(ExpMo + '/20/' + ExpYr, Settings.internalFmt)
    else if dayOfWeek(expDate) = 2 then
      expDate := xStrToDate(ExpMo + '/19/' + ExpYr, Settings.internalFmt)
    else if dayOfWeek(expDate) = 3 then
      expDate := xStrToDate(ExpMo + '/18/' + ExpYr, Settings.internalFmt)
    else if dayOfWeek(expDate) = 4 then
      expDate := xStrToDate(ExpMo + '/17/' + ExpYr, Settings.internalFmt)
    else if dayOfWeek(expDate) = 5 then
      expDate := xStrToDate(ExpMo + '/16/' + ExpYr, Settings.internalFmt)
    else if dayOfWeek(expDate) = 6 then
      expDate := xStrToDate(ExpMo + '/15/' + ExpYr, Settings.internalFmt)
    else if dayOfWeek(expDate) = 7 then
      expDate := xStrToDate(ExpMo + '/21/' + ExpYr, Settings.internalFmt);
    result := expDate;
  except
    result := xStrToDate('01/01/1900', Settings.internalFmt);
  end;
end;


function getExDayFromWeek(exWk, exMon, ExYr: string): string;
var
  i, x, lastDayOfMonth: integer;
  exDay: string;
  expDate: TDate;
begin
  exMon := getExpMoNum(exMon);
  if exWk = '1' then x := 1
  else if exWk = '2' then x := 8
  else if exWk = '3' then x := 15
  else if exWk = '4' then x := 22
  else if exWk = '5' then x := 29;
  lastDayOfMonth := daysInMonth(xStrToDate(exMon + '/01/20' + ExYr,
    Settings.internalFmt));
  // sm('lastDayOfMonth: '+inttostr(lastDayOfMonth));
  for i := x to x + 7 do begin
    if i > lastDayOfMonth then begin
      result := IntToStr(lastDayOfMonth);
      break;
      exit;
    end
    else
      expDate := xStrToDate(exMon + '/' + IntToStr(i) + '/20' + ExYr,
        Settings.internalFmt);
    if dayOfWeek(expDate) = 6 then begin
      exDay := IntToStr(i);
      if length(exDay) = 1 then exDay := '0' + exDay;
      result := exDay;
      exit;
    end; // day of week
  end; // for i...
end;


//function getMonPos(s: string): integer;
//  function LastPos(SubStr, S : string): Integer;
//  var
//    Found, Len, Pos : Integer;
//  begin
//    Pos := Length(S);
//    Len := Length(SubStr);
//    Found := 0;
//    while (Pos > 0) and (Found = 0) do begin
//      if Copy(S, Pos, Len) = SubStr then
//        Found := Pos;
//      Dec(Pos);
//    end;
//    // make sure two digit year is next
//    if (Found > 0) and isInt(Copy(S, Found + 4, 2)) then
//      result := Found
//    else
//      result := 0;
//  end;
//begin
//  if lastPos(' JAN', s) > 0 then result := lastPos(' JAN', s) + 1
//  else if lastPos(' FEB', s) > 0 then result := lastPos(' FEB', s) + 1
//  else if lastPos(' MAR', s) > 0 then result := lastPos(' MAR', s) + 1
//  else if lastPos(' APR', s) > 0 then result := lastPos(' APR', s) + 1
//  else if lastPos(' MAY', s) > 0 then result := lastPos(' MAY', s) + 1
//  else if lastPos(' JUN', s) > 0 then result := lastPos(' JUN', s) + 1
//  else if lastPos(' JUL', s) > 0 then result := lastPos(' JUL', s) + 1
//  else if lastPos(' AUG', s) > 0 then result := lastPos(' AUG', s) + 1
//  else if lastPos(' SEP', s) > 0 then result := lastPos(' SEP', s) + 1
//  else if lastPos(' OCT', s) > 0 then result := lastPos(' OCT', s) + 1
//  else if lastPos(' NOV', s) > 0 then result := lastPos(' NOV', s) + 1
//  else if lastPos(' DEC', s) > 0 then result := lastPos(' DEC', s) + 1
//  else result := 0;
//end;


procedure expireOptions;
var
  i, p, x: integer;
  OptTrade: TTLTrade;
  expDate, asofDate: TDate;
  expDa, ExpMo, ExpYr, ExpDateStr, TrNumStr, myTick, myType, s: string;
  exMTM: boolean;
  Tickers: String;
  MyDate: String;
begin
  // sm('expireOptions');
  // updated 2010-01-26
  if TradeLogFile.Count = 0 then exit;
  if not CheckRecordLimit then exit;
  if TradeLogFile.HasNegShares then begin
    mDlg('You must fix all trades with Negative Share' + cr +
      ' warnings before you run this function!', mtWarning, [mbOK], 0);
    screen.Cursor := crDefault;
    exit;
  end;
  // check for invalid option tickers next
  if length(TradeLogFile.GetInvalidOptionTickers) > 0 then begin
    if mDlg('ERROR: Some Option Tickers are Invalid.' + cr + cr +
      'These Option tickers must be fixed before you can expire options' + cr +
      cr + 'Would you like to fix them now?', mtError, [mbYes, mbNo], 0) = mrYes
    then begin
      StatBar('off');
      CloseFormIfOpen('frmOpenTrades');
      frmMain.InvalidTickers1.click;
    end;
    exit;
  end;
  //
  TrNumStr := '';
  Tickers := '';
  x := TradeLogFile.Count;
  repaintGrid;
  exMTM := false;
  // get user input
  frmDatePick.display('As Of Expire Date',
    'Enter an as-of-date To Expire Options:', TradeLogFile.LastDateImported);
  asofDate := frmDatePick.datePicked;
  // tell user to wait
  screen.Cursor := crHourglass;
  StatBar('Expiring Options');
  // cycle thru all open option trades and find expired
  for i := 0 to TradeLogFile.TradeNums.Count - 1 do begin
    { Only expire options for current broker }
    if (TradeLogFile.CurrentBrokerID > 0)
    and (TradeLogFile.TradeNums[i].BrokerID <> TradeLogFile.CurrentBrokerID)
    then continue;
    //
    myTick := TradeLogFile.TradeNums[i].Ticker;
    myType := copy(TradeLogFile.TradeNums[i].typemult, 1, 3);
    if not(leftStr(TradeLogFile.TradeNums[i].typemult, 3) = 'OPT')
    and not((myType = 'FUT') and (pos(' CALL', myTick) > 0))
    and not((myType = 'FUT') and (pos(' PUT', myTick) > 0)) then continue;
    //
    { This may happen if there are negative share errors in the file when this routine is run.
      we do not want to create negative expire records so just skip this TradeNum for now }
    if (TradeLogFile.TradeNums[i].Shares <= NEARZERO) then continue;
    // -------------
    OptTrade := TTLTrade.Create;
    OptTrade.TradeNum := TradeLogFile.TradeNums[i].TradeNum;
    // caused profit/loss to not calculate - 2013-04-02 DE
    // OptTrade.ID := TradeLogFile.TradeNums[I].HighID;
    OptTrade.Ticker := TradeLogFile.TradeNums[i].Ticker;
    OptTrade.Shares := TradeLogFile.TradeNums[i].Shares;
    OptTrade.ls := TradeLogFile.TradeNums[i].ls;
    OptTrade.Date := TradeLogFile.TradeNums[i].Date;
    OptTrade.typemult := TradeLogFile.TradeNums[i].typemult;
    OptTrade.oc := 'C';
    OptTrade.time := '16:00:00'; // timestamp of expired options
    OptTrade.Broker := TradeLogFile.TradeNums[i].BrokerID;
    // -------------
    if (pos(' PUT', OptTrade.Ticker) = length(OptTrade.Ticker) - 3)
    or (pos(' CALL', OptTrade.Ticker) = length(OptTrade.Ticker) - 4) then
    begin
      // test for DDMMMYY expiration date format
      s := OptTrade.Ticker;
      ParseLast(s, ' '); // del callPut
      ParseLast(s, ' '); // del strike
      s := ParseLast(s, ' '); // grab exp date
      try
        expDate := ConvertExpDate(s);
      except
        on E: Exception do begin
          mDlg('Could not calculate expiration date for ' + OptTrade.Ticker + cr
            + cr + ' Error: ' + E.Message, mtError, [mbOK], 0);
          continue;
        end;
      end; // try... except
      if (now <= expDate) or (expDate > asofDate) then
        continue
      else
        ExpDateStr := DateToStr(expDate, Settings.UserFmt);
    end
    else begin
      MyDate := DateToStr(OptTrade.Date, Settings.internalFmt);
      ExpMo := getExpMonth(copy(OptTrade.Ticker, length(OptTrade.Ticker) - 1, 1));
      if getExpMoNum(ExpMo) >= copy(MyDate, 1, 2) then
        ExpYr := copy(MyDate, 9, 2)
      else begin
        ExpYr := IntToStr(strToInt(copy(MyDate, 9, 2)) + 1);
        if length(ExpYr) = 1 then ExpYr := '0' + ExpYr;
      end;
      expDate := getOptExpDate(ExpMo, ExpYr);
      if expDate = xStrToDate('01/01/1900', Settings.internalFmt) then begin
        mDlg('Could not calculate expiration date for ' + OptTrade.Ticker,
          mtError, [mbOK], 0);
        OptTrade.Free;
        continue;
      end
      else begin
        try
          if (now <= expDate) or (expDate > asofDate) then begin
            OptTrade.Free;
            continue;
          end
          else
            ExpDateStr := DateToStr(expDate, Settings.UserFmt);
          // end if
        except
          // do nothing
        end; // try... except
      end; // if expDate
    end; // if (Pos(' PUT' or Pos(' CALL'...
//    // ----------------------------------------------------
//    // futures options expire on 1 day later on Saturday
//    if (pos('FUT', OptTrade.typemult) = 1) then
//      expDate := expDate + 1;
    // ----------------------------------------------------
    { Keep track of tickers and trade numbers for later }
    if (Tickers <> '') and (pos(OptTrade.Ticker, Tickers) = 0) then
      Tickers := Tickers + ',' + OptTrade.Ticker
    else
      Tickers := OptTrade.Ticker;
    // --- end if ---
    if TrNumStr = '' then
      TrNumStr := IntToStr(TradeLogFile.TradeNums[i].TradeNum)
    else
      TrNumStr := TrNumStr + ',' + IntToStr(TradeLogFile.TradeNums[i].TradeNum);
    // --- end if ---
    // assign expiration date
    OptTrade.Date := expDate;
    TradeLogFile.AddTrade(OptTrade);
  end;
  // -------------------------
  if x = TradeLogFile.Count then begin
    { No Records added to just report this and exit }
    mDlg('NO OPTIONS EXPIRED', mtInformation, [mbOK], 0);
    screen.Cursor := crDefault;
    StatBar('off');
    exit;
  end; // if
  // -------------------------
  screen.Cursor := crHourglass;
  StatBar('Expiring Options');
  TradeLogFile.VerifyOpenPositions;
  screen.Cursor := crHourglass;
  CloseFormIfOpen('frmOpenTrades');
  screen.Cursor := crHourglass;
  StatBar('Expiring Options');
  // Application.ProcessMessages;
  if TradeLogFile.CurrentBrokerID = 0 then
    TradeLogFile.MatchAndReorganizeAllAccounts(false, True)
  else
    TradeLogFile.MatchAndReorganize(false, True);
  // end if
  StatBar('Updating Internal Data');
  TradeRecordsSource.DataChanged;
  clearFilter;
  screen.Cursor := crHourglass;
  filterByTrNum(TrNumStr);
  // Application.ProcessMessages;
  screen.Cursor := crHourglass;
  SaveTradeLogFile('Expire Options');
  frmMain.btnShowOpen.click;
end;


// Accepts ONLY US-Formatted string!
function xStrToFloat(s: string): extended;
begin
  if s = '' then
    result := 0
  else begin
    if pos('..', s) > 0 then delete(s, pos('..', s), 1);
    try
      result := StrToFloat(s, Settings.internalFmt);
    except
      result := 0;
    end;
  end; // else
end;


procedure ChangeOptTicker;
var
  i, x, t: integer;
  lastTick, newTick, ExpMo, ExpYr, CPstr, strikePr, tempTk, ItemNum, prf, tk,
    opTk, optDesc, dt: string;
  expDate: TDate;
  verify, found: boolean;
  Y, m, D: word;
begin
  // sm('ChangeOptTicker');
  x := 0;
  found := false;
  verify := True;
  frmMain.Enabled := True;
  // filter grid by option tickers (tick not in long option format)
  filterByOptTickers;
  with frmMain.cxGrid1TableView1.DataController do begin
    if FilteredRecordCount = 0 then begin
      mDlg('No Invalid Option Tickers Found to Change', mtInformation,
        [mbOK], 0);
      clearFilter;
      exit;
    end;
  end;
  SortByTicker;
  frmMain.cxGrid1TableView1.Columns[17].visible := True;
  if mDlg('Change all option tickers to the TradeLog' + cr
    + 'long option symbol format?' + cr + cr
    + '"EXAMPLE: DLQLH" becomes "DELL DEC06 40 CALL"', mtConfirmation,
    [mbYes, mbNo], 0) <> mrYes then exit;
  if verify then begin
    if mDlg('Verify each option symbol?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes
    then verify := false;
  end;
  SaveTradesBack('Change Option Tickers'); // why make the undo so early?
  lastTick := '   ';
  // change option ticker to long form
  with frmMain.cxGrid1TableView1.DataController do begin
    BeginUpdate;
    for i := 0 to FilteredRecordCount - 1 do begin
      found := false;
      focusedRowIndex := i;
      changeRowSelection(focusedRowIndex, True);
      dt := DateToStr(values[FocusedRecordIndex, 2], Settings.UserFmt);
      DecodeDate(values[FocusedRecordIndex, 2], Y, m, D);
      tk := values[FocusedRecordIndex, 6];
      prf := values[FocusedRecordIndex, 9];
      opTk := values[FocusedRecordIndex, 17];
      optDesc := opTk;
      if CheckOptionFormat(tk) then begin
        if pos('OPT-', prf) = 0 then continue;
        if ((pos(' CALL', tk) = length(tk) - 4) and (length(tk) > 5))
        or ((pos(' PUT', tk) = length(tk) - 3) and (length(tk) > 4)) then
          continue;
      end;
      opTk := tk;
      inc(x);
      if (tk = lastTick) then begin
        tk := myNewOptTicker;
        // save new ticker to trades array
        values[FocusedRecordIndex, 6] := tk;
        values[FocusedRecordIndex, 17] := opTk;
        continue;
      end;
      StatBar('Getting option info for ' + tk + ' from web site');
      lastTick := tk;
      // sm(tk);
      newTick := tk; //
      // sm(newtick);
      delete(newTick, pos(' - INVALID', newTick),
        length(newTick) - pos(' - INVALID', newTick) + 1);
      ExpMo := getExpMonth(copy(tk, length(tk) - 1, 1));
      ExpYr := IntToStr(Y); // copy(dt, 9, 2);
      expDate := getOptExpDate(ExpMo, ExpYr);
      // try to convert standard option ticker symbol
      if (newTick = tk) then begin
        if (expDate < xStrToDate(dt, Settings.UserFmt)) then
          ExpYr := IntToStr(strToInt(ExpYr) + 1);
        if length(ExpYr) = 1 then ExpYr := '0' + ExpYr;
        if length(ExpYr) = 4 then ExpYr := copy(ExpYr, 3, 2);
        CPstr := getCallPut(copy(tk, length(tk) - 1, 1));
        strikePr := getStrike(copy(tk, length(tk), 1));
        newTick := copy(tk, 1, length(tk) - 2) + ' ' + ExpMo + ExpYr + ' ' +
          strikePr + ' ' + CPstr; // what's this for?
        // sm(newTick);
      end
      else
        found := True;
      // end if (newTick...
      if not verify then
        myNewOptTicker := newTick
      else begin
        with frmOptTick do begin
          if not found then begin
            edTick.Style.Font.Color := clRed;
            edMo.Style.Font.Color := clRed;
            edYr.Style.Font.Color := clRed;
            edStrike.Style.Font.Color := clRed;
          end;
          lblOptTick.Text := tk;
          tempTk := tk; // newTick;
          // convert tk to underlying ticker
          newTick := parseUnderlying(tk); // 2015-12-08 MB
          while pos(' ', newTick) > 0 do
            delete(newTick, pos(' ', newTick), 1);
          // remove spaces
          edTick.Text := newTick;
          edPutCall.Text := ParseLast(tempTk, ' ');
          edStrike.Text := ParseLast(tempTk, ' ');
          edYr.Text := ParseLast(tempTk, ' ');
          if length(edYr.Text) > 2 then
            edYr.Text := copy(edYr.Text, length(edYr.Text) - 1, 2);
          edMo.Text := copy(edMo.Text, 1, 3);
          if pos(copy(edMo.Text, 2, 1), '1234567890') > 0 then
            edMo.Text := copy(edMo.Text, 3, 3);
// edYr.Text := copy(edYr.Text, 4, 2);
// if (expDate > xStrToDate(dt, Settings.UserFmt)) then
// edYr.Text := IntToStr (strToInt(ExpYr));
          if length(edYr.Text) = 1 then edYr.Text := '0' + edYr.Text;
          // edTick.Text := tempTk;
          width := 440;
          height := panel1.height + pnlOpt.height + panel3.height + height -
            clientHeight;
          showmodal;
        end; // with frmOptTick do...
      end; // if not verify... else...
      // also end if not verify
      if myNewOptTicker = '' then exit;
      tk := myNewOptTicker;
      // save new ticker to trades array
      values[FocusedRecordIndex, 17] := opTk;
      values[FocusedRecordIndex, 6] := tk;
    end; // for i := 0 to FilteredRecordCount - 1 do
    EndUpdate;
  end; // with frmMain.cxGrid1TableView1.datacontroller do
  if x = 0 then begin
    sm('No option ticker symbols to change');
    exit;
  end;
  // can I move the undo file to here?
  saveGridData(True);
  if not panelMsg.visible then FilterByType('OPT', True);
end;


function IsFormVisible(const FormName: string): boolean;
var
  i: integer;
begin
  result := false;
  for i := screen.FormCount - 1 DownTo 0 do begin
    if (screen.Forms[i].Name = FormName) then begin
      result := screen.Forms[i].visible;
      break;
    end;
  end;
end;


function IsFormOpen(const FormName: string): boolean;
var
  i: integer;
begin
  result := false;
  for i := screen.FormCount - 1 DownTo 0 do begin
    if (screen.Forms[i].Name = FormName) then begin
      result := True;
      break;
    end;
  end;
end;


function GetFormIfOpen(const FormName: string): TForm;
var
  i: integer;
begin
  result := nil;
  for i := screen.FormCount - 1 DownTo 0 do begin
    if (screen.Forms[i].Name = FormName) then begin
      result := screen.Forms[i];
      break;
    end;
  end;
end;


function CloseFormIfOpen(const FormName: string): boolean;
var
  i: integer;
begin
  result := false;
  for i := screen.FormCount - 1 DownTo 0 do begin
    if (screen.Forms[i].Name = FormName) then begin
      screen.Forms[i].close;
      result := True;
      break;
    end;
  end; // for i...
end;


procedure sm(s: string);
begin
  mDlg(s, mtCustom, [mbOK], 0);
end;


function mDlg(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons;
  DefaultButton: TMsgDlgBtn): integer;
begin
  if bImporting then repaintGrid; // Be sure Grid is up to date
  with CreateMessageDialog(Msg, DlgType, Buttons, DefaultButton) do
    try
      position := poOwnerFormCenter;
      // force dialog to appear on same monitor as active form - 2016-08-08 MB
      DefaultMonitor := dmActiveForm;
      // end new code
      result := showmodal;
    finally
      Free;
//      // Preserve no updating for Grouped Messages
//      if not bImporting then // ?
    end;
  // end with... do
end;


function mDlg(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons;
  HelpCtx: Longint): integer;
begin
  if bImporting then repaintGrid; // Be sure Grid is up to date
  with CreateMessageDialog(Msg, DlgType, Buttons) do begin
    try
      position := poOwnerFormCenter;
      result := showmodal;
    finally
      Free;
//      // Preserve no updating for Grouped Messages
//      if not bImporting then // ?
    end;
  end;
end;


function sma(s: string; AddedButtns: TMsgDlgButtons): boolean;
begin
  result := True;
  if bImporting then repaintGrid; // Be sure Grid is up to date
  with CreateMessageDialog(s, mtCustom, [mbOK] + AddedButtns) do begin
    try
      position := poOwnerFormCenter;
      if showmodal = mrOK then result := false;
    finally
      Free;
//      // Preserve no updating for Grouped Messages
//      if not bImporting then
    end;
  end;
end;


// Finds average width of a displayed letter
function myGetAveCharSize(Canvas: TCanvas): TPoint;
var
  i: integer;
  Buffer: array [0 .. 51] of Char;
begin
  for i := 0 to 25 do Buffer[i] := chr(i + Ord('A'));
  for i := 0 to 25 do Buffer[i + 26] := chr(i + Ord('a'));
  GetTextExtentPoint(Canvas.Handle, Buffer, 52, TSize(result));
  result.x := result.x div 52;
end;


// Finds displayed string pixel size
function DisplayedSize(Canvas: TCanvas; ACaption: string): TPoint;
begin
  If ACaption <> '' then
      GetTextExtentPoint(Canvas.Handle, PChar(ACaption), length(ACaption),
      TSize(result))
  else
  begin
    result.x := NormCapHeight * 2;
    result.Y := NormCapHeight;
  end;
end;


function myInputQuery(const ACaption, APrompt: string; var Value: string;
  Hnd: THandle; Numeric: boolean = false): boolean;
var
  TempStr, PromptStr, BestStr: string;
  Form: TForm;
  Prompt: TLabel;
  Edit: TEdit;
  DialogUnits: TPoint;
  ButtonTop, ButtonWidth, ButtonHeight: integer;
  WndPlace: WindowPlacement;
  EventHandlers: TMyQueryEventHandlers;
begin
  result := false;
  WndPlace.length := SizeOf(WindowPlacement);
  If not(GetWindowPlacement(Hnd, @WndPlace)) then exit;
  if bImporting then repaintGrid; // Be sure Grid is up to date
  Form := TForm.Create(Application);
  EventHandlers := TMyQueryEventHandlers.Create(Form);
  // --------------- Long Try Block ------------------------
  try
    with Form do
      // ---------------- Inner Try Block -------------
      try
        Canvas.Font := Font;
        BorderStyle := bsDialog;
        caption := ACaption;
        DialogUnits := DisplayedSize(Canvas, caption);
        ClientWidth := trunc((DialogUnits.x + 80)
          * (DialogUnits.Y / Abs(Form.Font.height)));
        // force dialog to appear on same monitor as active form - 2016-08-08 MB
        DefaultMonitor := dmActiveForm;
        // end new code
        Prompt := TLabel.Create(Form);
        with Prompt do begin
          Parent := Form;
          caption := APrompt;
          if pos(cr, caption) = 0 then
            DialogUnits := DisplayedSize(Canvas, caption)
          else begin
            BestStr := '';
            PromptStr := '';
            TempStr := APrompt;
            while TempStr <> '' do begin
              PromptStr := ParseLast(TempStr, cr);
              if length(PromptStr) > length(BestStr) then BestStr := PromptStr;
            end; // while... do
            DialogUnits := DisplayedSize(Canvas, BestStr);
          end; // if Pos(...
          With Constraints do begin
            MaxWidth := DialogUnits.x;
            DialogUnits := myGetAveCharSize(Canvas);
            Left := MulDiv(8, DialogUnits.x, 4);
            If Form.ClientWidth < (MaxWidth + (Left * 2)) then
              Form.ClientWidth := MaxWidth + (Left * 2);
          end; // with ... do
          Top := MulDiv(8, DialogUnits.Y, 8);
          WordWrap := True;
        end; // with Prompt do
        Edit := TEdit.Create(Form);
        with Edit do begin
          if Numeric then Edit.OnKeyPress := EventHandlers.EditKeyPress;
          Parent := Form;
          Left := Prompt.Left;
          Top := Prompt.Top + Prompt.height + 5;
          width := MulDiv(164, DialogUnits.x, 4);
          If Form.ClientWidth < (width + (Left * 2)) then
            Form.ClientWidth := width + (Left * 2);
          MaxLength := 255;
          Text := Value;
          selectAll;
        end; // with Edit do
        if width > screen.width then
          ClientWidth := screen.width - ((width - ClientWidth) * 2);
        Prompt.Left := trunc((ClientWidth - Prompt.width) / 2);
        Edit.Left := trunc((ClientWidth - Edit.width) / 2);
        // buttons
        ButtonTop := Edit.Top + Edit.height + 15;
        ButtonWidth := MulDiv(50, DialogUnits.x, 4);
        ButtonHeight := MulDiv(14, DialogUnits.Y, 8);
        with TButton.Create(Form) do begin
          Parent := Form;
          caption := 'OK';
          ModalResult := mrOK;
          Default := True;
          OnClick := EventHandlers.OKBtnClick;
          SetBounds(Edit.Left, ButtonTop, ButtonWidth, ButtonHeight);
        end; // with TButton.Create
        with TButton.Create(Form) do begin
          Parent := Form;
          caption := 'Cancel';
          ModalResult := mrCancel;
          Cancel := True;
          SetBounds(Edit.Left + Edit.width - ButtonWidth,
            Edit.Top + Edit.height + 15, ButtonWidth, ButtonHeight);
          Form.clientHeight := Top + height + 13;
        end; // with TButton.Create
        // Position the Form
        DefaultMonitor := dmActiveForm;
        Case WndPlace.ShowCmd of
        SW_SHOWNORMAL, SW_SHOWNOACTIVATE, SW_SHOW, SW_SHOWNA, SW_RESTORE:
          With WndPlace.rcNormalPosition do begin
            Form.Left := trunc((Right - Left) / 2) + Left -
              trunc(Form.width / 2);
            Form.Top := trunc((Bottom - Top) / 2) + Top -
              trunc(Form.height / 2);
            position := poDesigned;
          End;
      Else position := poScreenCenter;
        End; // Case
        if showmodal = mrOK then begin
          Value := Edit.Text;
          result := True;
        end;
      finally
        Form.Free;
      end;
    // ---------------- Inner Try Block -------------
  finally
    EventHandlers.Free;
  end;
  // --------------- Long Try Block ------------------------
end;


function myInputBox(const ACaption, APrompt, ADefault: string;
  Hnd: THandle): string;
begin
  result := ADefault;
  myInputQuery(ACaption, APrompt, result, Hnd);
end;

// ------------------------------------
// Force recalculation of green bars
// ------------------------------------

procedure GetLocaleFormats;
begin
  NegCurrencyType := TradeLogFile.CurrentBaseCurrencyFmt.NegCurrFormat;
  PlusCurrencyType := TradeLogFile.CurrentBaseCurrencyFmt.CurrencyFormat;
  SetCurrencyOffsets;
end;


procedure SetCurrencyOffsets();
var
  c: integer;
  CurrencySmbl: String;
Begin
  // if TradeLogFile.CurrentBrokerID > 0 then
  // CurrencySmbl := TradeLogFile.CurrentAccount.ImportFilter.CurrencySymbol
  // else
  CurrencySmbl := TradeLogFile.CurrentBaseCurrencyFmt.CurrencyString;
  c := length(CurrencySmbl);
  Case NegCurrencyType of // Actual patterns
  0:
    Begin
      NegCurrPrfx := '(' + CurrencySmbl;
      NegCurrPstfx := ')';
    End;
  1:
    Begin
      NegCurrPrfx := '-' + CurrencySmbl;
      NegCurrPstfx := '';
    End;
  2:
    Begin
      NegCurrPrfx := CurrencySmbl + '-';
      NegCurrPstfx := '';
    End;
  3:
    Begin
      NegCurrPrfx := CurrencySmbl;
      NegCurrPstfx := '-';
    End;
  4:
    Begin
      NegCurrPrfx := '(';
      NegCurrPstfx := CurrencySmbl + ')';
    End;
  5:
    Begin
      NegCurrPrfx := '-';
      NegCurrPstfx := CurrencySmbl;
    End;
  6:
    Begin
      NegCurrPrfx := '';
      NegCurrPstfx := '-' + CurrencySmbl;
    End;
  7:
    Begin
      NegCurrPrfx := '';
      NegCurrPstfx := CurrencySmbl + '-';
    End;
  8:
    Begin
      NegCurrPrfx := '-';
      NegCurrPstfx := ' ' + CurrencySmbl;
    End;
  9:
    Begin
      NegCurrPrfx := '-' + CurrencySmbl + ' ';
      NegCurrPstfx := '';
    End;
  10:
    Begin
      NegCurrPrfx := '';
      NegCurrPstfx := ' ' + CurrencySmbl + '-';
    End;
  11:
    Begin
      NegCurrPrfx := CurrencySmbl + ' ';
      NegCurrPstfx := '-';
    End;
  12:
    Begin
      NegCurrPrfx := CurrencySmbl + ' -';
      NegCurrPstfx := '';
    End;
  13:
    Begin
      NegCurrPrfx := '';
      NegCurrPstfx := '- ' + CurrencySmbl;
    End;
  14:
    Begin
      NegCurrPrfx := '(' + CurrencySmbl + ' ';
      NegCurrPstfx := ')';
    End;
  15:
    Begin
      NegCurrPrfx := '(';
      NegCurrPstfx := ' ' + CurrencySmbl + ')';
    End;
  End;
  // ------------------------
  Case PlusCurrencyType of
  0:
    Begin
      PosCurrPrfx := CurrencySmbl;
      PosCurrPstfx := '';
    End;
  1:
    Begin
      PosCurrPrfx := '';
      PosCurrPstfx := CurrencySmbl;
    End;
  2:
    Begin
      PosCurrPrfx := CurrencySmbl + ' ';
      PosCurrPstfx := '';
    End;
  3:
    Begin
      PosCurrPrfx := '';
      PosCurrPstfx := ' ' + CurrencySmbl;
    End;
  End;
end;


// Accepts ONLY US Formatted Input String!
function convertInternalDateStrToUser(s: String;
  ForceLong: boolean = True): String;
var
  i, j, k, m: integer;
begin
  // converts date from InternalFmt to UserFmt
  result := DateToStr(xStrToDate(s, Settings.internalFmt), Settings.UserFmt);
end;


// Thread safe
//function UserDateStrEx(s: String; Fmt: TFormatSettings;
//  ForceLong: boolean = True): String;
//var
//  i, j, k, m: integer;
//begin
//  result := DateToStr(xStrToDate(s, Fmt), Settings.UserFmt);
//end;


procedure GridCurrStr(var s: string; ZeroOK: boolean = false);
var
  f: extended;
begin
  if s <> '' then begin
    f := StrToFloat(s, Settings.UserFmt);
    if Not ZeroOK and (f = 0) then begin
      s := '';
      exit;
    end;
    if f >= 0 then begin
      s := PosCurrPrfx + Trim((Format('%1.2n', [f], TradeLogFile.CurrentBaseCurrencyFmt)));
      if pos(TradeLogFile.CurrentBaseCurrencyFmt.DecimalSeparator, s) = (length(s) - 1) then
        s := s + '0';
      s := s + PosCurrPstfx;
    end
    else begin
      f := Abs(f);
      s := NegCurrPrfx + Trim((Format('%1.2n', [f], TradeLogFile.CurrentBaseCurrencyFmt)));
      if pos(TradeLogFile.CurrentBaseCurrencyFmt.DecimalSeparator, s) = (length(s) - 1) then
        s := s + '0';
      s := s + NegCurrPstfx;
    end;
  end;
  while pos('  ', s) > 0 do
    delete(s, pos('  ', s), 1);
end;


// Returns ONLY a US-formatted string!
function CurrStr(f: extended): string;
begin
  if f = 0 then begin
    result := '';
    exit;
  end;
  if f > 0 then begin
    result := PosCurrPrfx + Trim((Format('%1.2n', [f], Settings.internalFmt)));
    if pos('.', result) = (length(result) - 1) then result := result + '0';
    result := result + PosCurrPstfx;
  end
  else begin
    f := Abs(f);
    result := '-' + Trim((Format('%1.2n', [f], Settings.internalFmt)));
    if pos('.', result) = (length(result) - 1) then result := result + '0';
  end;
  while pos('  ', result) > 0 do delete(result, pos('  ', result), 1);
end;


function CurrStrEx(f: extended; Fmt: TFormatSettings; ZeroOK: boolean = false;
  IncludeDecimal: boolean = True; decimalPlaces: integer = 2): string;
var
  i: integer;
begin
  if f = 0 then begin
    if ZeroOK then begin
      result := PosCurrPrfx + '0';
      if IncludeDecimal then
        result := result + TradeLogFile.CurrentBaseCurrencyFmt.DecimalSeparator + '00' + PosCurrPstfx
    end
    else result := '';
    exit;
  end;
  if f > 0 then begin
    if IncludeDecimal then begin
      result := PosCurrPrfx +
        Trim((Format('%1.' + IntToStr(decimalPlaces) + 'n', [f],
        TradeLogFile.CurrentBaseCurrencyFmt)));
      if pos(TradeLogFile.CurrentBaseCurrencyFmt.DecimalSeparator, result) = (length(result) - 1) then
        result := result + '0';
    end
    else
      result := PosCurrPrfx + Trim((Format('%1.0n', [f], TradeLogFile.CurrentBaseCurrencyFmt)));
    result := result + PosCurrPstfx;
  end
  else begin
    f := Abs(f);
    if IncludeDecimal then begin
      result := NegCurrPrfx
        + Trim((Format('%1.' + IntToStr(decimalPlaces) + 'n', [f], TradeLogFile.CurrentBaseCurrencyFmt)));
      if pos(TradeLogFile.CurrentBaseCurrencyFmt.DecimalSeparator, result) = (length(result) - 1) then
        result := result + '0';
    end
    else
      result := NegCurrPrfx
        + Trim((Format('%1.' + IntToStr(decimalPlaces) + 'n', [f], TradeLogFile.CurrentBaseCurrencyFmt)));
    result := result + NegCurrPstfx;
  end;
  while pos('  ', result) > 0 do delete(result, pos('  ', result), 1);
  if IncludeDecimal and (decimalPlaces > 2) then begin
    if rightStr(result, 1) = ')' then delete(result, length(result), 1);
    for i := decimalPlaces downto 3 do
      if rightStr(result, 1) = '0' then
        delete(result, length(result), 1)
      else
        break;
    if leftStr(result, 1) = '(' then result := result + ')';
  end;
end;


function GridTimeStr(s: String; Fmt: TFormatSettings): String;
var
  Hr, Mn, Sc, Msc: word;
  hour, min, sec: String;
begin
  if s = '' then
    result := ''
  else begin
    decodeTime(StrToTime(s, Fmt), Hr, Mn, Sc, Msc);
    hour := IntToStr(Hr);
    min := IntToStr(Mn);
    sec := IntToStr(Sc);
    while length(hour) < 2 do hour := '0' + hour;
    while length(min) < 2 do min := '0' + min;
    while length(sec) < 2 do sec := '0' + sec;
    result := hour + Settings.UserFmt.TimeSeparator + min + Settings.UserFmt.TimeSeparator + sec;
  end;
end;


//function ImportDateStr(s: String; Fmt: TFormatSettings;
//  ForceLong: boolean = false): String;
//var
//  i, j, k, m: integer;
//begin
//  result := DateToStr(xStrToDate(s, Fmt), Settings.internalFmt);
//  if ForceLong = false then exit;
//  { Todd Flora - Comment Out
//    if Length(Result) = Settings.InternalFmt.LongDateLen then exit; }
//  i := length(result);
//  j := length(Settings.internalFmt.ShortDateFormat);
//  if j < 10 then j := 10;
//  if i >= j then exit;
//  m := pos(Settings.internalFmt.DateSeparator, result);
//  if m = 0 then exit;
//  k := 0;
//  while (i < j) do begin
//    if m - k < 3 then begin
//      Insert('0', result, k + 1);
//      inc(i);
//      inc(m);
//    end;
//    if m = i then exit;
//    k := m;
//    m := posex(Settings.internalFmt.DateSeparator, result, k + 1);
//    if m = 0 then m := i;
//  end;
//end;


function StrDateAdd(s: String; Change: integer; Fmt: TFormatSettings): String;
begin
  result := DateToStr(IncDay(xStrToDate(s, Fmt), Change), Fmt);
end;


//function StrDateIncYr(s: String; Change: integer; Fmt: TFormatSettings): String;
//begin
//  result := DateToStr(IncYear(xStrToDate(s, Fmt), Change), Fmt);
//end;


function UserDayMonthStr(uDay, uMonth: string; yrSep: boolean): String;
var
  DateOrdr: integer;
begin
  with Settings.UserFmt do begin
    { Todd Flora - Unnecessary code as the only times this method is called
      is whwith uday = 31 and umonth = 12. So since both of these strings
      are already two digits we don't need to add a zero to them
      if DayLong and (length(uDay) = 1) then uDay := '0' + uDay;
      if MonthLong and (length(uMonth) = 1) then uMonth := '0' + uMonth;
    Also replace DateSep custom field with Standard Field and get DateOrdr from call to win api }
    DateOrdr := strToInt(GetLocInfo(Settings.UserLocale, LOCALE_IDATE, 2));
    if DateOrdr = sdoDMY then
      result := uDay + DateSeparator + uMonth
    else
      result := uMonth + DateSeparator + uDay;
    if yrSep then begin
      if DateOrdr = sdoYMD then result := DateSeparator + result
      else result := result + DateSeparator;
    end;
  end;
end;


function NextUserDate(InDateStr: String): TDate;
begin
  result := xStrToDate(InDateStr, Settings.UserFmt) + 1;
end;


function UserDateStrNotGreater(TestDate, CompareDate: String): boolean;
begin
  result := xStrToDate(TestDate, Settings.internalFmt) <= xStrToDate(CompareDate, Settings.internalFmt)
end;


//function replDateStrJanDec(s: string): string;
//var
//  p: integer;
//begin
//  if pos('Jan', s) > 0 then begin
//    p := pos('Jan', s);
//    delete(s, p, 3);
//    Insert('01', s, p);
//  end
//  else if pos('Feb', s) > 0 then begin
//    p := pos('Feb', s);
//    delete(s, p, 3);
//    Insert('02', s, p);
//  end
//  else if pos('Mar', s) > 0 then begin
//    p := pos('Mar', s);
//    delete(s, p, 3);
//    Insert('03', s, p);
//  end
//  else if pos('Apr', s) > 0 then begin
//    p := pos('Apr', s);
//    delete(s, p, 3);
//    Insert('04', s, p);
//  end
//  else if pos('May', s) > 0 then begin
//    p := pos('May', s);
//    delete(s, p, 3);
//    Insert('05', s, p);
//  end
//  else if pos('Jun', s) > 0 then begin
//    p := pos('Jun', s);
//    delete(s, p, 3);
//    Insert('06', s, p);
//  end
//  else if pos('Jul', s) > 0 then begin
//    p := pos('Jul', s);
//    delete(s, p, 3);
//    Insert('07', s, p);
//  end
//  else if pos('Aug', s) > 0 then begin
//    p := pos('Aug', s);
//    delete(s, p, 3);
//    Insert('08', s, p);
//  end
//  else if pos('Sep', s) > 0 then begin
//    p := pos('Sep', s);
//    delete(s, p, 3);
//    Insert('09', s, p);
//  end
//  else if pos('Oct', s) > 0 then begin
//    p := pos('Oct', s);
//    delete(s, p, 3);
//    Insert('10', s, p);
//  end
//  else if pos('Nov', s) > 0 then begin
//    p := pos('Nov', s);
//    delete(s, p, 3);
//    Insert('11', s, p);
//  end
//  else if pos('Dec', s) > 0 then begin
//    p := pos('Dec', s);
//    delete(s, p, 3);
//    Insert('12', s, p);
//  end;
//  result := s;
//end;


//function WordCount(Sentence: string): integer;
//var
//  Words: integer;
//begin
//  if Sentence <> '' then begin
//    Words := 1;
//    while pos(' ', Sentence) <> 0 do begin
//      delete(Sentence, 1, pos(' ', Sentence));
//      inc(Words);
//    end;
//    WordCount := Words
//  end
//  else
//    WordCount := 0;
//end;


//function countCharInString(Char, s: String): Longint;
//var
//  t: integer;
//begin
//  t := 0;
//  while pos(Char, s) > 0 do begin
//    inc(t);
//    delete(s, pos(Char, s), 1);
//  end;
//  result := t;
//end;


// Thread safe
function xStrToTimeEx(const s: string; Fmt: TFormatSettings): TDateTime;
begin
  if not(TryStrToTime(s, result, Fmt)) then
    result := StrToTime('00:00', Settings.internalFmt);
end;


procedure CheckForNewData;
begin
  if (newBBIFU.newBBFUCount > 0) then
    newBBIFU.showmodal;
  if NewStrategies.newStrategiesCount > 0 then
    NewStrategies.showmodal;
  if TradeLogFile.MultiplierIsZero then
    applyChangesToMultipliers;
  if TradeLogFile.UpdateMultiplierIsZero then begin
    mDlg('WARNING: Multiplier not found for some records.' + cr //
      + cr //
      + 'You must correct this problem before filing your taxes using TradeLog tax forms.' + cr //
      + 'Trades in error will have a Type/Multiplier field equal to <Type>-0.' + cr //
      + 'The data will now be filtered to allow you to see and fix these issues.',
      mtWarning, [mbOK], 0);
    FilterByType('*-0', True);
    exit;
  end;
end;


procedure showUserGuide;
var
  h: hwnd;
begin
  webURL('https://support.tradelogsoftware.com/hc/en-us'); // 2019-01-18 MB
//  HtmlHelp(GetDesktopWindow, PChar(Settings.HelpFileName), HH_HELP_CONTEXT, 1000);
end;


procedure changeCusips;
var
  i: integer;
  lastTick, newTick, tk: string;
  found: boolean;
begin
  found := false;
  frmMain.Enabled := True;
  newTick := '';
  filterByCusip;
  SortByTicker;
  if mDlg('Change all Cusips stock tickers?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then exit;
  SaveTradesBack('Change Cusips to Tickers');
  lastTick := '   ';
  with frmMain.cxGrid1TableView1.DataController do begin
    BeginUpdate;
    try
      for i := 0 to FilteredRecordCount - 1 do begin
        found := false;
        focusedRowIndex := i;
        changeRowSelection(focusedRowIndex, True);
        tk := values[FocusedRecordIndex, 6];
        if (tk = lastTick) then begin
          // save new ticker to trades array
          values[FocusedRecordIndex, 6] := newTick;
          continue;
        end;
        StatBar('Getting stock ticker for Cusip: ' + tk + ' from Fidelity web site');
        lastTick := tk;
        newTick :=
          readURL('http://activequote.fidelity.com/mmnet/SymLookup.phtml?'
            + 'QUOTE_TYPE=' + '&scCode=E' + '&searchBy=C' + '&searchFor=' + tk
            + '&submit=Search');
        if (pos('?QUOTE_TYPE=&SID_VALUE_ID=', newTick) > 0) then begin
          newTick := parseHTML(newTick, '?QUOTE_TYPE=&SID_VALUE_ID=', '">');
          values[FocusedRecordIndex, 6] := newTick;
          // sm(newTick);
        end
        else begin
          newTick := tk;
          values[FocusedRecordIndex, 6] := newTick;
          // sm(newTick);
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
  clearFilter;
  saveGridData(True);
  filterByCusip;
  if frmMain.cxGrid1TableView1.DataController.FilteredRecordCount > 0 then
    sm('The following Cusips were not found' + cr + cr
      + 'You will need to look these up on your monthly statements')
  else clearFilter;
  screen.Cursor := crDefault;
end;


//function numOccurances(s, substr: string): integer;
//// Returns the number of times a substring occurs in a string
//var
//  p, q: PChar;
//  n: integer;
//begin
//  result := 0;
//  n := length(substr);
//  if n = 0 then exit;
//  q := PChar(pointer(substr));
//  p := PChar(pointer(s));
//  while p <> nil do begin
//    p := StrPos(p, q);
//    if p <> nil then begin
//      inc(result);
//      inc(p, n);
//    end;
//  end;
//end;


function validDriveType(s: string): boolean;
var
  typ: integer;
  dTyp: string;
begin
  if pos('\', s) > 0 then s := copy(s, 1, pos('\', s));
  typ := GetDriveType(PChar(s));
  if typ <> 0 then
    case typ of
    DRIVE_REMOVABLE:
      begin
        dTyp := 'Removable';
      end;
    DRIVE_FIXED:
      begin
        dTyp := 'Fixed';
      end;
    DRIVE_CDROM:
      begin
        dTyp := 'CD ROM';
      end;
    DRIVE_RAMDISK:
      begin
        dTyp := 'RAM';
      end;
    DRIVE_REMOTE:
      begin
        dTyp := 'Network';
      end;
    DRIVE_UNKNOWN:
      begin
        dTyp := 'Unknown';
      end;
    end;
  // sm('>'+dtyp+'<');
  if (dTyp = 'CD ROM') then begin
    result := false;
    sm('TradeLog cannot open data files stored on ' + dTyp + ' drives' + cr //
      + cr //
      + 'Please copy your TradeLog data files to your hard drive' + cr //
      + 'and then try opening them with TradeLog');
  end
  else result := True;
end;


// ==============================================
//
// ==============================================
function SaveTradeLogFile(Undo: String = ''; Silent: boolean = false;
  ReloadOnCancel: boolean = True; NumRecsImported: integer = 0): boolean;
var
  Msg: String;
begin
  if not Silent then begin
    StatBar('off');
    Msg := '';
    if NumRecsImported > 0 then
      Msg := Msg + IntToStr(NumRecsImported) + ' Records Imported!' + cr //
        + ' - ' + IntToStr(glNumCancelledTrades) + ' Cancelled/Corrected Records' + cr //
        + cr;
    // ---------------------
    if (Settings.RecLimit <> '')
    and (TradeLogFile.Count > strToInt(Settings.RecLimit)) then
      Msg := Msg + Settings.TLVer + ' limited to ' + Settings.RecLimit + ' records!' + cr //
      + cr //
      + 'Save a total of ' + Settings.RecLimit + ' records?'
    else
      Msg := Msg +'Save a total of ' +IntToStr(TradeLogFile.Count) +' records?';
    // ---------------------
    result := messagedlg(Msg,mtConfirmation, [mbYes, mbNo], 0) = mrYes;
  end
  else begin
    result := True;
  end;
  if result then begin
    // Add an Undo before Saving
    if length(Undo) > 0 then begin
      SaveTradesBack(Undo);
    end;
    chDir(Settings.DataDir);
//    TradeLogFile.SaveFile(True);
  end
  else begin // user cancelled save
    StatBar('Reloading File');
    if ReloadOnCancel then
      TradeLogFile.Revert;
  end;
  screen.Cursor := crHourglass;
  if not Silent then begin
    StatBar('Updating Internal Data');
    if (TradeRecordsSource <> nil) then
      TradeRecordsSource.DataChanged;
  end;
  dispProfit(True, 0, 0, 0, 0);
  screen.Cursor := crDefault;
  StatBar('off');
end;


{ TMyQueryEventHandlers }

constructor TMyQueryEventHandlers.Create(Form: TForm);
begin
  inherited Create;
  FForm := Form;
end;

procedure TMyQueryEventHandlers.EditKeyPress(Sender: TObject; var Key: Char);
var
  Dec, Ths: Char;
begin
  Dec := Settings.UserFmt.DecimalSeparator;
  Ths := Settings.UserFmt.ThousandSeparator;
  if not(CharInSet(Key, ['0' .. '9', Dec, Ths, chr(8)])) then Key := #0;
end;

procedure TMyQueryEventHandlers.OKBtnClick(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to FForm.ComponentCount - 1 do
    if (FForm.Components[i] is TEdit)
    and (length(TEdit(FForm.Components[i]).Text) = 0) then begin
      FForm.ModalResult := mrNone;
      break;
    end;
end;


function getMult(typemult: string): double;
var
  p, L: integer;
begin
  try
    p := pos('-', typemult);
    L := length(typemult);
    result := StrToFloat(copy(typemult, p + 1, L - p + 1));
  except
    sm('error: ' + typemult + ' is not a decimal number');
  end;
end;


procedure disableEdits;
begin
  with frmMain do begin
    bEditsDisabled := True;
//    Save1.Enabled := false;
    bbFile_Save.Enabled := true; // if file open
//    mnuFile_Edit.Enabled := false;
//    mnuFile_EndTaxYear.Enabled := false;
    bbFile_EndTaxYear.Enabled := false;
//    mnuAcct.Enabled := false;
//    mnuAcct_Add.Enabled := false;
//    mnuAcct_Edit.Enabled := false;
//    mnuAcct_Import.Enabled := false;
    mnuEdit.Enabled := false;
//    mnuAdd.Enabled := false;
    mnuOptions.Enabled := false;
    //rj Feb 6, 2021 make Ribbon visible/invisible based on above values
    EnableTabItems('disableEdits');
    // ------ toolbar -------
    btnImport.Enabled := false;
    btnAddRec.Enabled := false;
    btnInsRec.Enabled := false;
    btnDelRec.Enabled := false;
    btnUndo.Enabled := false;
    btnRedo.Enabled := false;
    frmMain.bbUndo_small.Enabled := false;
    frmMain.bbUndo_Large.Enabled := false;
    frmMain.bbRedo_small.Enabled := false;
    frmMain.bbRedo_Large.Enabled := false;
    btnCheckList.Enabled := false;
    // ------- popmenu -------
    SetPopupMenuEnabled(pupEdit, false);
    SetPopupMenuEnabled(pupAccount, false);
    SetPopupMenuEnabled(pupPlusBtn, false);
  end;
end;


procedure enableEdits;
begin
  with frmMain do begin
    bEditsDisabled := false;
//    Save1.Enabled := false;
    bbFile_Save.Enabled := true; // if file open
//    mnuFile_Edit.Enabled := True;
//    mnuFile_EndTaxYear.Enabled := True;
    bbFile_EndTaxYear.Enabled := True;
//    mnuAcct.Enabled := True;
//    mnuAcct_Add.Enabled := True;
//    mnuAcct_Edit.Enabled := True;
//    mnuAcct_Import.Enabled := True;
    mnuEdit.Enabled := True;
    mnuAdd.Enabled := True;
    mnuOptions.Enabled := True;
    //rj Feb 6, 2021 make Ribbon visible/invisible based on above values
    EnableTabItems('enableEdits');
    // ------ toolbar -------
    btnImport.Enabled := True;
    btnAddRec.Enabled := True;
    btnInsRec.Enabled := True;
    btnDelRec.Enabled := True;
    btnRedo.Enabled := True;
    btnCheckList.Enabled := True;
    // ------- popmenu -------
    SetPopupMenuEnabled(pupEdit, True);
    SetPopupMenuEnabled(pupAccount, True);
    SetPopupMenuEnabled(pupPlusBtn, True);
  end;
end;


procedure splitRecord;
var
  RecIdx: integer;
  shareTxt: string;
  sharesNew, sharesOld, commOld, amountOld: double;
  Trade: TTLTrade;
begin
  with frmMain.cxGrid1TableView1.DataController do begin
    // user must select one record only
    if (GetSelectedCount < 1) then begin
      mDlg('Please select a trade record to split', mtWarning, [mbOK], 1);
      exit;
    end
    else if (GetSelectedCount > 1) then begin
      mDlg('Please select only one trade record', mtWarning, [mbOK], 1);
      exit;
    end;
    // get shares
    RecIdx := FocusedRecordIndex;
    sharesOld := TradeLogFile[RecIdx].Shares;
    sharesNew := sharesOld/2;
    shareTxt := FloatToStr(sharesNew);
    if TdlgInputValue.execute('Split Shares',
      'Enter number of shares to split out',
      'shares/contracts:',
      'Help on Split Trade Records',
      'https://support.tradelogsoftware.com/hc/en-us/articles/115004471033-Split-Trade-Records',
      shareTxt
    ) = mrCancel then begin
      sm('Split cancelled.');
      exit;
    end;
    if not isFloat(shareTxt) then begin
      mDlg('Shares must be a decimal number', mtError, [mbOK], 1);
      exit;
    end;
    // create Undo
    SaveTradesBack('Split trade record shares');
    // create new record with balance of shares
    sharesNew := StrToFloat(shareTxt);
    sharesOld := TradeLogFile[RecIdx].Shares;
    commOld := TradeLogFile[RecIdx].Commission;
    amountOld := TradeLogFile[RecIdx].Amount;
    Trade := TTLTrade.Create(TradeLogFile.Trade[RecIdx]);
    // if why free this it causes problems with Undo ???
    Trade.Shares := sharesNew;
    Trade.Price := TradeLogFile.Trade[RecIdx].Price;
    Trade.Commission := sharesNew / sharesOld * commOld;
    Trade.Amount := sharesNew / sharesOld * amountOld;
    TradeLogFile.AddTrade(Trade);
    // decrease shares of selected record
    TradeLogFile[RecIdx].Shares := sharesOld - Trade.Shares;
    TradeLogFile[RecIdx].Commission := commOld - Trade.Commission;
    TradeLogFile[RecIdx].Amount := amountOld - Trade.Amount;
    // rematch
    TradeLogFile.MatchAndReorganize;
    TradeRecordsSource.DataChanged;
    SaveTradeLogFile('', True);
    if TradeLogFile.HasNegShares then begin
      clearFilter;
      FindTradeIssues;
    end;
  end;
end;


// ----------------------------------------------
// If 2 opens or closes on same date/price/etc.
// then consolidate them into one record
// ----------------------------------------------
procedure consolidateRecords;
var
  i, j, x, y, iTrNum, numRecs: integer;
  sTicker, sTime, sOC, sLS: string;
  dPrice, dCmPer, dShares, dComm, dAmount: double;
  Trade: TTLTrade;
  dtTrade: TDate;
  ConsolidatedTrades: TList<TTLTrade>;
  f : TdlgConsolidate;
  // ----------------------------------
  procedure StartNewTradeRec;
  begin
    // prime everything with record #0
    iTrNum := TradeLogFile[i].TradeNum;
    sTicker := TradeLogFile[i].Ticker;
    dtTrade := TradeLogFile[i].Date;
    sTime := TradeLogFile[i].time;
    sOC := TradeLogFile[i].oc;
    sLS := TradeLogFile[i].ls;
    sTicker := TradeLogFile[i].Ticker;
    dPrice := TradeLogFile[i].Price;
    dCmPer := (TradeLogFile[i].Commission/TradeLogFile[i].Shares);
    // accumulators
    dShares := TradeLogFile[i].Shares;
    dComm := TradeLogFile[i].Commission;
    dAmount := TradeLogFile[i].Amount;
  end;
// ----------------------------------
  procedure UpdateConsolidated;
  begin
    ConsolidatedTrades[j].CalcOff := True;
    ConsolidatedTrades[j].Shares := dShares;
    ConsolidatedTrades[j].Commission := dComm;
    ConsolidatedTrades[j].Amount := dAmount;
    ConsolidatedTrades[j].CalcOff := false;
  end;
// ----------------------------------
begin
  if not CheckRecordLimit or OneYrLocked or isAllBrokersSelected or
    (TradeLogFile.Count = 0) then exit;
  if panelMsg.visible then begin
    panelMsg.Hide;
    clearFilter;
  end;
  // ------------------------
  // ------------------------
  f := TdlgConsolidate.Create(nil);
    if (frmMain.tabAccounts.Tabs.Count < 3) then begin
      f.btnAllAccts.Visible := false;
      f.btnCurrAcct.Left := f.btnAllAccts.Left;
    end;
    // ------------------------
    x := f.ShowModal;
    if (x = mrCancel) or (x = mrNo) then exit;
    y := iConsolidateMethod; // 0 = cancel, 1 = careful, 2 = maximum
  f.Free; // done with dialog
  // ------------------------
  // create Undo
  SaveTradesBack('Consolidate Partial Fills');
  screen.Cursor := crHourglass;
  // prime everything with record #0
  i := 0;
  j := 0;
  try
    StartNewTradeRec;
    // and load it into ConsolidatedTrades
    ConsolidatedTrades := TList<TTLTrade>.Create;
    ConsolidatedTrades.Add(TradeLogFile[i]); // first record
    StatBar('Consolidating Partial Fills');
    // ---------------------------------------------------------
    // Find trades with split records to combine.
    // If single account, copy all records of another account.
    // If ALL accounts, loop through all trades.
    // note: always just copy 'W' records as-is.
    // ---------------------------------------------------------
    LoadingRecs := True;
    i := 1;
    numRecs := TradeLogFile.Count;
    while i < numRecs do begin
      // copy or consolidate based on broker tab
      if ((TradeLogFile[i].Broker = TradeLogFile.CurrentBrokerID) or (x = mrAll))
      and (TradeLogFile[i].oc <> 'W') then begin // don't consolidate WS
        // -- 2 possibilities ---------
        if (TradeLogFile[i].TradeNum = iTrNum) // must be same Trade#
        and (TradeLogFile[i].Ticker = sTicker) // ...and ticker
        and (TradeLogFile[i].Date = dtTrade) //   ...and date
        and (TradeLogFile[i].oc = sOC) //         ...and O/C
        and (TradeLogFile[i].ls = sLS) //         ...and L/S
        and (TradeLogFile[i].Price = dPrice) //   ...and price
        and (
          ((TradeLogFile[i].Commission/TradeLogFile[i].Shares) = dCmPer)
          or (y = 2) // maximum consolidation
        )
        then begin // it's a match!
          dShares := dShares + TradeLogFile[i].Shares;
          dComm := dComm + TradeLogFile[i].Commission;
          dAmount := dAmount + TradeLogFile[i].Amount;
        end
        else begin // new trade
          // first, save previous trade
          UpdateConsolidated;
          // now start new trade
          ConsolidatedTrades.Add(TradeLogFile[i]);
          inc(j);
          StartNewTradeRec;
        end; // new trade or not?
      end
      else begin // just copy the record as-is
        // first, save previous trade
        UpdateConsolidated; // save TradeLogFile data into ConsolidatedTrades
        // now start new trade
        ConsolidatedTrades.Add(TradeLogFile[i]);
        inc(j);
        StartNewTradeRec; // read the TradeLogFile data into scalar variables
      end; // if right broker and not "W"
      // ---------------------------------------------------------
      //if (Frac(trunc(i / numRecs * 100) / 5) = 0) then // original
      if (i mod 100)=1 then begin // update statbar every 100th trade
        StatBar('Consolidating Partial Fills ' +
          IntToStr(trunc(i / numRecs * 100)) + '% Complete');
      end;
      inc(i); // next i
    end; // while
    // ------- Finish -------
    UpdateConsolidated;
  finally
    screen.Cursor := crHourglass;
    // some records were consolidated
    if (i >= numRecs) and (ConsolidatedTrades.Count < numRecs) then begin
      if TradeLogFile.SaveTList(ConsolidatedTrades) < 1 then Undo(false, false);
      if x = mrAll then begin
        frmMain.tabAccounts.TabIndex := 0;
        LoadRecords(false, false); // This will recalc P&L
      end
      else
        LoadRecords; // This will recalc P&L
      // end if
      StatBar('off');
      mDlg('Consolidation Complete!' + cr + cr + 'Records Before  =  ' +
        FormatFloat('###,###,##0', numRecs) + cr + cr + 'Records After    =  ' +
        FormatFloat('###,###,##0', ConsolidatedTrades.Count), mtInformation,
        [mbOK], 0);
      if TradeLogFile.HasNegShares then begin
        clearFilter;
        FindTradeIssues;
      end;
    end
    else begin // NO records were consolidated
      StatBar('off');
      mDlg('No Partial Fills Found To Consolidate!', mtInformation, [mbOK], 0);
      Undo(false, false);
    end;
    FreeAndNil(ConsolidatedTrades);
    StatBar('off');
    screen.Cursor := crDefault;
  end;
end;


procedure ChangeStockDescrtoTickerSymbol(bSilent: boolean = false);
var
  i, j, p: integer;
  sDesc, sTick, sTicker: string;
  TickList: TStringList;
begin
  if panelMsg.visible then begin
    clearFilter;
    panelMsg.Hide;
  end;
  if not CheckRecordLimit then exit;
  StatBar('Finding Records with Stock Descriptions');
  screen.Cursor := crHourglass;
  clearFilter;
  try
    TickList := TStringList.Create;
    TickList := findTicksWithStockDescr(bImporting);
    if (TickList.Count = 0) then begin
      if not bImporting and not bSilent then
        mDlg('No Records Found with Stock Descriptions', mtInformation, [mbOK], 1);
      exit;
    end;
    TickList.Sort;
    // lookup ticker symbol and pass result to TickList
    if not descrToSymbol(TickList) then begin
      clearFilter;
      exit;
    end;
    // code to speed up innner loop
    TradeLogFile.SortByTicker;
    p := 0;
    // verify and edit if necessary all tickers found
    TfrmUnderlying.verify(TickList);
    // change tickers in TLFile
    for i := 0 to TickList.Count - 1 do begin
      sDesc := Trim(copy(TickList[i], 1, pos('|', TickList[i]) - 1));
      sTick := Trim(copy(TickList[i], pos('|', TickList[i]) + 1));
      // inner loop
      for j := p to TradeLogFile.Count - 1 do begin
        if (pos('OPT', TradeLogFile[j].typemult) > 0) then begin
          sTicker := parseUnderlying(TradeLogFile[j].Ticker);
          if (pos(sDesc, sTicker) = 1) then begin
            TradeLogFile[j].Ticker :=
              replaceUnderlying(TradeLogFile[j].Ticker, sTick);
            p := j + 1;
          end;
        end
        else begin
          if (pos(sDesc, TradeLogFile[j].Ticker) = 1) then begin
            TradeLogFile[j].Ticker := sTick;
            p := j + 1;
          end;
        end;
      end;
    end;
    // rematch and renumber trades
    TradeLogFile.MatchAndReorganize;
    TradeRecordsSource.DataChanged;
    if not SaveTradeLogFile('Change Stock Description to Ticker Symbol') then begin
      frmMain.btnShowAll.click;
    end;
  finally
    TickList.Free;
    StatBar('off');
    screen.Cursor := crDefault;
  end;
end;


procedure AssignNoteToTrades;
var
  i, RecIdx: integer;
  sNote: string;
begin
  if not CheckRecordLimit then exit;
  with frmMain.cxGrid1TableView1.DataController do begin
    if (GetSelectedCount = 0) then begin
      sm('Please select the records that you want to assign notes to.');
      exit;
    end;
    Settings.DispNotes := True;
    frmMain.SetOptions;
    sNote := inputbox('Assign Notes to Trade Records', 'Enter Notes:', '');
    for i := 0 to GetSelectedCount - 1 do begin
      RecIdx := GetRowInfo(GetSelectedRowIndex(i)).RecordIndex;
      TradeLogFile[RecIdx].Note := sNote;
    end;
  end;
  TradeRecordsSource.DataChanged;
  SaveTradeLogFile('Assign Notes');
  frmMain.SetFocus;
end;


procedure ProcessBeginYearDone;
var
  i: integer;
  clickedOK: boolean;
  prStr, Line: string;
  Price, Amount: double;
  txtFile: textFile;
  // Trade : TTLTrade;
  TradesSumCount: integer;
begin
  EnteringBeginYearPrice := True;
  Price := 0;
  if TradeLogFile.CurrentAccount.MTM
  and not TradeLogFile.CurrentAccount.MTMLastYear then
    TdlgPriceList.GenerateSection481Prices;
  TradeLogFile.MatchAndReorganize;
  SaveTradeLogFile('', True);
  TradeRecordsSource.DataChanged;
  EnteringBeginYearPrice := false;
  //
  frmMain.btnImport.Enabled := Not(OneYrLocked or isAllBrokersSelected);
  frmMain.AddRec := false;
  frmMain.InsertRec := false;
  // better to move this code out of click event:
  frmMain.btnShowAll.click;
end;


function getElapsedTime(startTime: TDateTime): string;
var
  EndTime: TDateTime;
  TimeStr: string;
begin
  EndTime := time - startTime;
  TimeStr := TimeToStr(EndTime, Settings.UserFmt);
  delete(TimeStr, pos('12' + Settings.UserFmt.TimeSeparator, TimeStr), 3);
  delete(TimeStr, pos('AM', TimeStr), 2);
  delete(TimeStr, pos('PM', TimeStr), 2);
  result := TimeStr;
end;


function generateFilePW: string;
var
  s : string;
begin
  // get today's date
  s := dateToStr(now, Settings.InternalFmt);
  // remove slashes
  while (pos('/', s) > 0) do
    delete(s, pos('/', s), 1);
  // encrypt pw
  s := dEncrypt(s, '');
  result := s;
end;


procedure showFileResetPW;
var
  s : string;
begin
  // generates a reset code based on today's date
  s := generateFilePW;
  // encrypt date
  clipboard.AsText := s;
  mDlg('The following PW reset code has' + cr
    + 'been copied to the clipboard ' + cr
    + 'and is only valid for today' + cr
    + cr
    + s, mtinformation, [mbOK], 0 );
end;


//procedure SelectAccountTab(AccountName : String);
//var
//  I : Integer;
//begin
//  for I := 0 to frmMain.tabAccounts.Tabs.Count - 1 do begin
//    if frmMain.tabAccounts.Tabs[I].Caption = AccountName then begin
//      frmMain.tabAccounts.TabIndex := I;
//      exit;
//    end;
//  end;
//end;


// ---------------------------------------------+
//                                              |
// ---------------------------------------------+
function EditCurrentAccount(ACaption: String): TModalResult;
var
  OldMTM : Boolean;
  OldIRA : Boolean;
  OldAAS : boolean;
  Header : TTLFileHeader;
  SilentSave : Boolean;
begin // EditCurrentAccount
  try
    glbAccountEdit := true;
    if TradeLogFile.CurrentBrokerID > 0 then begin
      SilentSave := True;
      OldMTM := TradeLogFile.CurrentAccount.MTM;
      OldIRA := TradeLogFile.CurrentAccount.IRA;
      OldAAS := TradeLogFile.CurrentAccount.AutoAssignShorts;
      // create and open Account Setup form
      Result := TdlgAccountSetup.Execute(
        TradeLogFile.CurrentAccount,
        Not TradeLogFile.CurrentAcctHasRecords,
        TradeLogFile.HasMTMThisYear,
        TradeLogFile.HasMTMLastYear,
        ACaption
      );
      if Result = mrOK then begin // user clicked Account Setup form OK button
        if Not OldMTM and TradeLogFile.CurrentAccount.MTM
        and not TradeLogFile.CurrentAccount.MTMLastYear then begin
          //we need to add begin Year records for this file.
          if not tDlgPriceList.GenerateSection481Prices then begin
            {If they cancel then roll back changes to account type.}
            mDlg('Account type not changed to MTM.' + CR + CR +
              'You must be prepared to enter year end prices for all' + CR +
              'open positions from the previous tax year in order to' + CR +
              'change the account type to MTM.', mtInformation, [mbOK], 0);
            TradeLogFile.CurrentAccount.MTM := OldMTM;
            TradeLogFile.CurrentAccount.Ira := OldIRA;
            SilentSave := True;
          end;
        end
        else if OldMTM and not TradeLogFile.CurrentAccount.MTM then begin
        //We need to remove Begin Year Records;
          if TradeLogFile.RemoveSection481 then
            SilentSave := False;
        end;
        if TradeLogFile.Count > 1 then
          TradeLogFile.MatchAndReorganize;
        TradeRecordsSource.DataChanged;
        if AddExistingAcct then
          SaveTradeLogFile('', SilentSave)
        else
          SaveTradeLogFile('Update Account - ' + TradeLogFile.CurrentAccount.AccountName, SilentSave);
        frmMain.SetAccountOptions;
        frmMain.SetupReportsMenu;
        frmMain.tabAccounts.Tabs[frmMain.tabAccounts.TabIndex].Caption := TradeLogFile.CurrentAccount.AccountName;
        frmMain.StatBarAccountType;
      end
      // user clicked Account Setup form Cancel
      else begin
        //Undo(false, true); // no need to undo since we Cancelled already
      end;
    end;
  finally
    glbAccountEdit := false;
  end;
end; // EditCurrentAccount


// ---------------------------------------------+
//                                              |
// ---------------------------------------------+
function EditCurrentImport(ACaption: String): TModalResult;
var
  Header : TTLFileHeader;
  SilentSave : Boolean;
begin // EditCurrentImport
  try
    glbAccountEdit := true;
    if TradeLogFile.CurrentBrokerID > 0 then begin
      SilentSave := True;
      // create and open Account Setup form
      Result := TdlgImportSetup.Execute(
        TradeLogFile.CurrentAccount,
        ACaption
      );
      if Result = mrOK then begin // user clicked Account Setup form OK button
        TradeRecordsSource.DataChanged;
        SaveTradeLogFile('Update Account - ' + TradeLogFile.CurrentAccount.AccountName, SilentSave);
        frmMain.SetAccountOptions;
        frmMain.SetupReportsMenu;
        frmMain.tabAccounts.Tabs[frmMain.tabAccounts.TabIndex].Caption := TradeLogFile.CurrentAccount.AccountName;
        frmMain.StatBarAccountType;
      end
      // user clicked Account Setup form Cancel
      else begin
        //Undo(false, true); // no need to undo since we Cancelled already
      end;
    end;
  finally
    glbAccountEdit := false;
  end;
end; // EditCurrentImport



initialization


end.
