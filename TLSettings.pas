unit TLSettings;

interface

uses Printers, SysUtils, Windows, Messages, Registry, Forms,
     Classes, Generics.Collections, Generics.Defaults;

type

  TReportPageData = packed record
    FontHeadingSize,
    FontDataSize : Integer;
    PreviewFullScreen : Boolean;
    FitToWidth : Boolean;
    Orientation : TPrinterOrientation;
    Margins : TRect;
    UseColor : Boolean
  end;

  TMainFormData = class
  private
    FStatus,
    FTop,
    FLeft,
    FWidth,
    FHeight : Integer;
  public
    procedure SetData(MainForm : TForm);
    procedure GetData(var MainForm : TForm);
    constructor Create;
  end;

  EChartDataException = class(Exception);

  // --------------------------------------------

  TChartData = class(TPersistent)
  private
    FChartTimes : TList<Double>;
    FChartIntervals : Integer;
    FChartConfigFile : String;
    FChartSeperator: Char;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    property ChartTimes : TList<Double> read FChartTimes write FChartTimes;
    property ChartIntervals : Integer read FChartIntervals write FChartIntervals;
    property ChartSeperator : Char read FChartSeperator write FChartSeperator;
  end;

  TChartDataList = class(TObjectDictionary<String, TChartData>)
  private
    FFileName : String;
    FActiveSection: String;
    procedure ReadConfigFile;
    procedure SetActiveSection(const Value: String);
    function GetActiveChartData: TChartData;
  public
    constructor Create(FileName : String);
    procedure WriteDefaultChartConfigSection;
    procedure SaveData;
    property ActiveSection : String read FActiveSection write SetActiveSection;
    property ActiveChartData : TChartData read GetActiveChartData;
  end;

  // --------------------------------------------

  FutureItem = packed record
    Name : string;
    Value : double;
  end;
  PFutureItem = ^FutureItem;

  // ------------------------

  SymbolItem = packed record
    Symbol : string;
    Multiplier : string;
    Descriptn : string;
  end;
  PSymbolItem = ^SymbolItem;

  TLSymbolList = class(TList)
  private
    function Get(Index : Integer) : PSymbolItem;
  public
    destructor Destroy; override;
    function Add(SymbolItem : PSymbolItem) : Integer;
    function indexOf(Symbol : String) : Integer;
    property Items[Index: Integer] : PSymbolItem read Get; default;
  end;

  // ------------------------

  BBIOItem = packed record
    Symbol : string;
    Mult : string;
  end;
  PBBIOItem = ^BBIOItem;

  TLBBIOList = class(TList)
  private
    function Get(Index : Integer) : PBBIOItem;
  public
    destructor Destroy; override;
    function Add(BBIOItem : PBBIOItem) : Integer;
    function indexOf(Symbol : String) : Integer;
    property Items[Index: Integer] : PBBIOItem read Get; default;
  end;

  // ------------------------

  ETFItem = packed record
    Symbol : string;
    subType : string;
    descrip : string;
  end;
  PETFItem = ^ETFItem;

  TLETFList = class(TList)
  private
    function Get(Index : Integer) : PETFItem;
  public
    destructor Destroy; override;
    function Add(ETFItem : PETFItem) : Integer;
    function indexOf(Symbol : String) : Integer;
    property Items[Index: Integer] : PETFItem read Get; default;
  end;

  // --------------------------------------------

  ETLSettingsException = class(Exception);

  TTLSettings = class
  private
    IniFile : TRegIniFile;
    FNotifyDownloadComplete: String;
    FReportPageData: TReportPageData;
    // --------------------------------
    FVersion: String;
    FRegProSuper: String; // encrypted Manager + Email value
    FRegCode: String;
    // --------------------------------
    FAcctName: String;
    FNameOnReports: String;
    FSSN: String;
    FIsEIN: Boolean;
    FDataDir: String;
    FInstallDir: String;
    FDispTimeBool: Boolean;
    FDispNotes: Boolean;
    FDispQS: Boolean;
    FDispStrategies: Boolean;
    FDispAcct: Boolean;
    FDispImport: Boolean;
    FDispOptTicks: Boolean;
    FDispSupportCenter: Boolean;
    FDispQuickTour: Boolean;
    FDispMTaxLots: Boolean;
    FDispWSDefer: Boolean;
    FInternalLocaleFmt: TFormatSettings;
    FUserDefaultLocaleFmt: TFormatSettings;
    FUserLocale: Integer;
    FMyDocumentsFolder : String;
    FUserFolder : String;
    FUserEmail : String;
    FPassword : String; // 2022-11-05 MB
    FKeepPwd : Boolean;
    // --------------------------------
    FFutureList: TList;
    FBBIOList: TLBBIOList;
    FMutualFundList: TLSymbolList;
    FETFsList: TLETFList;
    // --------------------------------
    FEMail: String;
    FUserName: String;
    FUserCredentialsReceived : Boolean;
    FDisp8949Code: Boolean;
    FOldWS: Boolean;
    FRecLimit: String;
    FTrialVersion: Boolean;
    FMTMVersion: Boolean;
    // ---
    FDateInstalled: String;
    FDateExpired: string;
    // ---
    FMainFormData: TMainFormData;
    FRegName: String;
    FNewInstall: Integer;
    FLastOpenFileList: TStringList;
    FGTTTaxPrep: String;
    FCommission: Double;
    FSecFee: Double;
    FFeePerShare: Boolean;
    FBCTimeout: Integer;
    FFeeSold: Boolean;
    FFeeBought: Boolean;
    FChartDataList: TChartDataList;
    FDispWSHolding: Boolean;
    FUserBackupDir: String;
    FUserBackupDate: Boolean;
    FSkinName : string;
    FLegacyBC : Boolean; // 2022-01-20 MB New
    // ------------------------------------------
    procedure ConvertVersion(Value : String);
    // ---
    procedure ConvertDateInstalled(Value : String; WriteToRegistry : Boolean = false);
//    function GetDateInstalledFromRegCode : TDate;
    function GetDateInstalled: String;
    function GetDateExpired: String;
    procedure SetDateInstalled(const Value : String);
    procedure SetDateExpires(const Value : String);
    // ---
    procedure ReadGeneralSettings; // -- main app settings ----------
    // ---
    procedure ReadLastOpenFiles;
    procedure ReadMainFormData;
    procedure ReadUserEMailSettings;
    procedure ReadReportPageSettings;
    procedure ReadGlobalOptions;
    // ------------------------------------------
    procedure SetReportPageData(const Value: TReportPageData);
    procedure SetDataDir(const Value: String);
    function GetWindowsSpecialFolder(Folder : Integer): string;
    function GetSettingsdir: String;
    // ------------------------------------------
    procedure SetAcctName(const Value: String);
    procedure SetNameOnreports(const Value: String);
    procedure SetSSN(const Value: String);
    procedure SetIsEIN(const Value: Boolean);
    function GetImportDir: String;
    function GetReportDir: String;
    function getChartConfigFile: String;
    procedure VerifySettingsFiles;
    function getTradeLogUrl: String;
    // ------------------------------------------
    function getStrategyOptionsFile: String;
    function GetTradeLogOptionsUrl: String;
    function getFuturesOptionsFile: String;
    function getBroadBasedOptionsFile: String;
    // ------------------------------------------
    function GetInitialOptionFile(OptionType: String) : Boolean;
    function MoveSettingsFiles(FromDir : String) : Boolean;
    procedure setDispWSDefer(const Value: Boolean);
    procedure setDispQS(const Value: Boolean);
    procedure setDispAcct(const Value: Boolean);
    procedure setDispMTaxLots(const Value: Boolean);
    procedure setDispNotes(const Value: Boolean);
    procedure setDispOptTicks(const Value: Boolean);
    procedure setDispImport(const Value: Boolean);
    procedure SetDispSupportCenter(const Value: Boolean);
    procedure SetDispQuickTour(const Value: Boolean);
    procedure setDispTimeBool(const Value: Boolean);
    procedure SetDispStrategies(const Value: Boolean);
    // ------------------------------------------
    procedure SetFutureList(const Value: TList);
    procedure SetBBIOList(const Value: TLBBIOList);
    procedure LoadSymbolListFromFile(FileName : String; MyList : TList);
    procedure LoadFutureListFromFile;
    procedure SaveFutureListToFile;
    procedure SaveSymbolListToFile(FileName : String; MyList : TList);
    // ------------------------------------------
    procedure Initialize;
    procedure WriteReportPage;
    procedure WriteMainFormData;
    procedure CleanUpRegistry;
    procedure LoadUserDefaultLocaleFmt;
    function GetMyDocumentsFolder: String;
    function GetUpdateDir: String;
//    function GetUserEmail: String;
    // ------------------------------------------
    procedure SetETFsList(const Value: TLETFList);
    procedure SetMutualFundList(const Value: TLSymbolList);
    function getETFsFile: String;
    function getMutualFundFile: String;
    // ------------------------------------------
    function GetBackupDir: String;
    function GetUndoDir: String;
    procedure SetDisp8949Code(const Value: Boolean);
    procedure SetOldWS(const Value: Boolean);
    procedure SetTLVer(const Value: String);
    function GetWebSiteURL: String;
    function GetRegistrationURL: String;
    procedure SetMainFormData(const Value: TMainFormData);
    procedure SetRegCode(const Value: String);
    procedure SetRegName(const Value: String);
    function GetHelpFileName: String;
    procedure SetGTTTaxPrep(const Value: String);
    procedure SetSecFee(const Value: Double);
    function GetFeePerTotal: Boolean;
    procedure SetFeePerShare(const Value: Boolean);
    procedure SetBCTimeout(const Value: Integer);
    procedure SetFeeSold(const Value: Boolean);
    procedure SetFeeBought(const Value: Boolean);
    procedure SetChartDataList(const Value: TChartDataList);
    function GetMTMVersion: Boolean;
    function GetCommission: Double;
    procedure SetCommission(const Value: Double);
    procedure SetDispWSHolding(const Value: Boolean);
    function GetLogDir: String;
    function GetLogFileName: String;
    procedure SetUserBackupDir(const Value: String);
    procedure SetUserBackupDate(const Value: Boolean);
    procedure setNewInstall(const Value: Integer);
    procedure SetSkinName(const Value: string);
    procedure SetLegacyBC(const Value: boolean);
    procedure SetUserEmail(const Value: String);
    procedure SetUserPassword(const Value: String);
    procedure SetKeepPwd(const Value: Boolean);
    procedure Login(b1st : boolean);
  public
    constructor Create;
    procedure InstallNewFeatures;
    procedure SaveSettings; // Save to registry before shutdown
    procedure WriteLastOpenFiles;
    function GetRegistryEntries(RootName : String) : TStringList;
    function GetTradeLogRegistryEntries : TStringList;
    function GetEnvironmentVariables : TStringList;
    function GetSystemInfo : TStringList;
    destructor Destroy; override;
    // ------------------------------------------
    procedure RemoveTrailingBackSlash(var path : String);
    procedure GetUserCredentials;
    function FileSze(FileName : String) : DWord;
    property NotifyDownloadComplete : String read FNotifyDownloadComplete;
    property ReportPageData : TReportPageData read FReportPageData write SetReportPageData;
    // --- Version Info -------------------------
    property TLVer : String read FVersion write SetTLVer;
    property RecLimit : String read FRecLimit;
    property TrialVersion : Boolean read FTrialVersion;
    property MTMVersion : Boolean read FMTMVersion write FMTMVersion; //GetMTMVersion;
//    property RegProSuperUser : string read GetRegProSuper write SetRegProSuper;
    // --- Date Installed, Expires --------------
    property DateInstalled : String read GetDateInstalled write SetDateInstalled;
    property DateExpired : String read GetDateExpired write SetDateExpires;
    // ---
    property RegCode : String read FRegCode write SetRegCode;
    property RegName : String read FRegName write SetRegName;
    property AcctName : String read FAcctName write SetAcctName;
    property NameOnReports : String read FNameOnReports write SetNameOnReports;
    property SSN : String read FSSN write SetSSN;
    property IsEIN : Boolean read FIsEIN write SetIsEIN;
    property DataDir : String read FDataDir write SetDataDir;
    property InstallDir : String read FInstallDir;
    property SettingsDir : String read GetSettingsDir;
    property ImportDir : String read GetImportDir;
    property ReportDir : String read GetReportDir;
    property UpdateDir : String read GetUpdateDir;
    property BackupDir : String read GetBackupDir;
    property UndoDir : String read GetUndoDir;
    property LogDir : String read GetLogDir;
    property UserBackupDir : String Read FUserBackupDir write SetUserBackupDir;
    property UserBackupDate : Boolean read FUserBackupDate write SetUserBackupDate;
    property UserEmail : String read FUserEmail write SetUserEmail;
    property Password : String read FPassword write SetUserPassword;
    property KeepPwd : Boolean read FKeepPwd write SetKeepPwd;
    // ------------------------------------------
    procedure ResetBroadBasedOptions;
    procedure ResetFutureOptions;
    procedure ResetStrategyOptions;
    procedure ResetMutualFunds;
    procedure ResetETFs;
    // ------------------------------------------
    // property BBIOList :   TList read FBBIOList write SetBBIOList;
    property BBIOList : TLBBIOList read FBBIOList write SetBBIOList;
    property FutureList : TList read FFutureList write SetFutureList;
    property MutualFundList : TLSymbolList read FMutualFundList write SetMutualFundList;
    property ETFsList : TLETFList read FETFsList write SetETFsList;
    // ------------------------------------------
    property StrategyOptionsFile : String read getStrategyOptionsFile;
    property FutureOptionsFile : String read getFuturesOptionsFile;
    property BroadBasedOptionsFile : String read getBroadBasedOptionsFile;
    property ETFsFile : String read getETFsFile;
    property MutualFundFile : String read getMutualFundFile;
    // ------------------------------------------
    property ChartConfigFile : String read getChartConfigFile;
    property TradeLogOptionsUrl : String read getTradeLogOptionsUrl;
    property TradeLogUrl : String read getTradeLogUrl;
    property DispWSDefer : Boolean read FDispWSDefer write setDispWSDefer;
    property DispWSHolding : Boolean read FDispWSHolding write SetDispWSHolding;
    property DispQS : Boolean read FDispQS write setDispQS;
    property DispAcct : Boolean read FDispAcct write setDispAcct;
    property DispMTaxLots : Boolean read FDispMTaxLots write setDispMTaxLots;
    property DispNotes : Boolean read FDispNotes write setDispNotes;
    property DispOptTicks : Boolean read FDispOptTicks write setDispOptTicks;
    property DispStrategies : Boolean read FDispStrategies write SetDispStrategies;
    property DispSupportCenter : Boolean read FDispSupportCenter write SetDispSupportCenter;
    property DispQuickTour : Boolean read FDispQuickTour write SetDispQuickTour;
    property DispImport : Boolean read FDispImport write setDispImport;
    property DispTimeBool : Boolean read FDispTimeBool write setDispTimeBool;
    property Disp8949Code : Boolean read FDisp8949Code write SetDisp8949Code;
    property OldWS : Boolean read FOldWS write SetOldWS;
    // ------------------------------------------
    //All Imports, File, and Internal storage of data will be in the Internal Format
    property InternalFmt : TFormatSettings read FInternalLocaleFmt;
    //Presentation will use the UserDefaultLocale Format.
    property UserFmt : TFormatSettings read FUserDefaultLocaleFmt;
    property UserName : String read FUserName;
    property EMail : String read FEMail;
    property UserLocale : Integer read FUserLocale;
    property MyDocumentsFolder : String read GetMyDocumentsFolder;
    property WebSiteURL : String read GetWebSiteURL;
    property RegistrationURL : String read GetRegistrationURL;
    property MainFormData : TMainFormData read FMainFormData write SetMainFormData;
    property HelpFileName : String read GetHelpFileName;
    property LastOpenFilesList : TStringList read FLastOpenFileList write FLastOpenFileList;
    property GTTTaxPrep : String read FGTTTaxPrep write SetGTTTaxPrep;
    property Commission : Double read GetCommission write SetCommission;
    property SecFee : Double read FSecFee write SetSecFee;
    property FeePerShare : Boolean read FFeePerShare write SetFeePerShare;
    property FeeSold : Boolean read FFeeSold write SetFeeSold;
    property FeeBought : Boolean read FFeeBought write SetFeeBought;
    property BCTimeout : Integer read FBCTimeout write SetBCTimeout;
    property ChartDataList : TChartDataList read FChartDataList write SetChartDataList;
    property LogFileName : String read GetLogFileName;
    property NewInstall : integer read FNewInstall write SetNewInstall;
    property SkinName : string read FSkinName write SetSkinName;
    property LegacyBC : Boolean read FLegacyBC write SetLegacyBC;
    // ------------------------------------------
    function ReadUpdateTime : string;
    procedure WriteUpdateTime(sUpdateTime:string);
    function ReadGetStarted : string;
    procedure WriteGetStarted(val:string);
  end;

var
  Settings : TTLSettings;

const
  WEB_SITE_URL = 'http://www.tradelogsoftware.com';
  // registry constants
  SOFTWARE = 'Software';
  TRADELOG = 'TradeLog';
  TRADELOG_SETUP = TRADELOG + '\Setup';

  //Special Colors
  tlBlue = $00FFECD9;
  tlBeige = $00CEF5F7;
  tlGreen = $00D9FFD9;
  tlYellow = $008AFFFF;  //$00AEFFFF;
  DEFAULT_CHART_SECTION = 'Default';


implementation

uses
  Shlobj, StrUtils, //
  TLCommonLib, FuncProc, Dialogs, IniFiles,
  JclSysInfo,
  fmLogin, VCL.Controls, globalVariables, TL_API,
  TLLogging, DateUtils, WinAPI.ShellAPI;

const
  INTERNET_EXPLORER = SOFTWARE + '\Microsoft\Internet Explorer\';

  //ID's for windows Folders;
  ID_MyDocumentsFolder = CSIDL_PERSONAL;
  ID_UserFolder = CSIDL_PROFILE;

  (* Registry Locations where settings will be written *)
  INST = 'Inst';
  TRADELOG_OPTIONS = TRADELOG + '\Options';
  TRADELOG_CHARTS = TRADELOG + '\Charts\TOD';
  TRADELOG_MAINFORM = TRADELOG + '\frmMain';
  FILE_STRATEGY_OPTIONS = 'StrategyOptions';
  FILE_BROAD_BASED_OPTIONS = 'BroadBasedOptions';
  FILE_FUTURE_OPTIONS = 'FutureOptions';
  FILE_ETFs = 'ETFs';
  FILE_MUTUAL_FUNDS = 'MutualFunds';
  FILE_CHART_CONFIG = 'Charts';
  EXT_CONFIG = '.cfg';
  EXT_TSV = '.tsv'; // 2021-10-26 MB - New for v20

  URL_TRADELOG = 'http://www.tradelogsoftware.com/';
  URL_OPTIONS = 'options/';

  DIR_IMPORT = '\Import';
  DIR_REPORTS = '\Reports';
  DIR_SETTINGS = '\Settings';
  DIR_UPDATES = '\Updates';
  DIR_BACKUP = '\Backups';
  DIR_UNDO = '\Undo';
  DIR_LOG = '\Logs';
  HELP_FILE_NAME = '\TradeLog.chm';

  REGISTRATION_URL = WEB_SITE_URL + '/cgi-bin/regcheck.cgi?regcode=';
  CHART_SECTION_PREFIX = 'TOD_';
  CODE_SITE_CATEGORY = 'TLSettings';


function GetInternalLocaleFmt: TFormatSettings;
begin
  try
    Result.CurrencyFormat := 0;
    Result.NegCurrFormat :=  0;
    Result.ThousandSeparator := ',';
    Result.DecimalSeparator := '.';
    Result.CurrencyDecimals := 2;
    Result.DateSeparator :=  '/';
    Result.TimeSeparator := ':';
    Result.ListSeparator := ',';
    Result.CurrencyString := '$';
    // eventually we want to change the internal date format
    // (ShortDateFormat) to yyyy-mm-dd to match standards.
    Result.ShortDateFormat := 'mm/dd/yyyy';
    Result.LongDateFormat  := 'dddd, MMMM dd, yyyy';
    Result.TimeAMString := 'AM';
    Result.TimePMString := 'PM';
    Result.ShortTimeFormat := 'h:mm AMPM';
    Result.LongTimeFormat := 'h:mm:ss AMPM';
    //
    Result.ShortMonthNames[1] := 'Jan';
    Result.ShortMonthNames[2] := 'Feb';
    Result.ShortMonthNames[3] := 'Mar';
    Result.ShortMonthNames[4] := 'Apr';
    Result.ShortMonthNames[5] := 'May';
    Result.ShortMonthNames[6] := 'Jun';
    Result.ShortMonthNames[7] := 'Jul';
    Result.ShortMonthNames[8] := 'Aug';
    Result.ShortMonthNames[9] := 'Sep';
    Result.ShortMonthNames[10] := 'Oct';
    Result.ShortMonthNames[11] := 'Nov';
    Result.ShortMonthNames[12] := 'Dec';
    //
    Result.LongMonthNames[1] := 'January';
    Result.LongMonthNames[2] := 'February';
    Result.LongMonthNames[3] := 'March';
    Result.LongMonthNames[4] := 'April';
    Result.LongMonthNames[5] := 'May';
    Result.LongMonthNames[6] := 'June';
    Result.LongMonthNames[7] := 'July';
    Result.LongMonthNames[8] := 'August';
    Result.LongMonthNames[9] := 'September';
    Result.LongMonthNames[10] := 'October';
    Result.LongMonthNames[11] := 'November';
    Result.LongMonthNames[12] := 'December';
    //
    Result.ShortDayNames[1] := 'Sun';
    Result.ShortDayNames[2] := 'Mon';
    Result.ShortDayNames[3] := 'Tue';
    Result.ShortDayNames[4] := 'Wed';
    Result.ShortDayNames[5] := 'Thu';
    Result.ShortDayNames[6] := 'Fri';
    Result.ShortDayNames[7] := 'Sat';
    //
    Result.LongDayNames[1] := 'Sunday';
    Result.LongDayNames[2] := 'Monday';
    Result.LongDayNames[3] := 'Tuesday';
    Result.LongDayNames[4] := 'Wednesday';
    Result.LongDayNames[5] := 'Thursday';
    Result.LongDayNames[6] := 'Friday';
    Result.LongDayNames[7] := 'Saturday';
    //
    Result.TwoDigitYearCenturyWindow := 21;
  finally
    // GetInternalLocaleFmt
  end;
end;


{ TTLSettings }

procedure TTLSettings.CleanUpRegistry;
begin
  try
    IniFile.DeleteKey('TradeLog\Setup', 'EX');
    IniFile.DeleteKey('TradeLog\Options', 'NinjaComm');
    IniFile.DeleteKey('TradeLog\Setup', 'New7');
    IniFile.DeleteKey('TradeLog\Options', 'SLbroker');
    IniFile.DeleteKey('TradeLog\Options', 'ImportCurrency');
    IniFile.DeleteKey('TradeLog\Options', 'AutoAssignShorts');
  finally
    // CleanUpRegistry
  end;
end;

function TTLSettings.FileSze(FileName : String) : DWord;
var
  F : Integer;
begin
  Result := 0;
  if FileExists(FileName) then
  begin
    F := FileOpen(FileName, fmOpenRead);
    try
      Result := GetFileSize(F, nil);
    finally
      FileClose(F);
    end;
  end;
end;


// ------------------------------------
// 2022-11-07 MB - get this from v2 API
// SKU #s:
// Investor = 1005
// Trader = 1006
// Elite = 1007
// Pro = 1009
// ------------------------------------
procedure TTLSettings.ConvertVersion(Value : String);
var
  P : Integer;
  t : string;
begin
  if gbOffline then begin // --- decode from registry ---
    if Pos('TradeLog', Value) = 1 then
      FVersion := Value
    else
      FVersion := Dencrypt(Value, '');
    // --- cleanup ------------------
    FTrialVersion := Length(RegCode) = 0;
    if (pos('Upgrade ', FVersion) > 0) then
      delete(FVersion, 1, pos('to ', FVersion) + 2);
    // --- remove GTT -----
    if (pos('GTT',FVersion) = 1) then begin
      delete(FVersion,1,4);
      P := pos('Renewal',FVersion);
      if P > 0 then
        insert('MTM ',FVersion,P)
      else
        FVersion := FVersion +' MTM';
      FMTMVersion := true;
    end;
    // --- decode/convert -----------
    if (FVersion = 'TradeLog 200') //
    or (FVersion = 'TradeLog 600') //
    or (FVersion = 'Investor') then
      v2SKU := '1005'
    else if (FVersion = 'TradeLog 1500') //
    or (FVersion = 'TradeLog 1500 MTM') //
    or (FVersion = 'Trader') then
      v2SKU := '1006'
    else if (FVersion = 'TradeLog') //
    or (FVersion = 'TradeLog MTM') //
    or (FVersion = 'Elite') then
      v2SKU := '1007'
    else if (FVersion = 'TradeLog PRO') //
    or (FVersion = 'Pro') then
      v2SKU := '1009'
    else if (Pos('FREE Trial', FVersion) > 0) then
      v2SKU := '';
  end; // if gbOffline
  // ----------------------------------------------------
  try
    // --- decode from SKU returned by login ---
    if pos('SKU', v2SKU) = 1 then
      t := copy(v2SKU, 5)
    else if lowercase(v2SKU) = 'null' then
      t := ''
    else
      t := v2SKU;
    if t = '1005' then begin
      FVersion := 'Investor';
      FRecLimit := '1500';
      FTrialVersion := False;
      FMTMVersion := False;
      v2RecLimit := 1500;
    end
    else if t = '1006' then begin
      FVersion := 'Trader';
      FRecLimit := '5000';
      FTrialVersion := False;
      FMTMVersion := true;
      v2RecLimit := 5000;
    end
    else if t = '1007' then begin
      FVersion := 'Elite';
      FRecLimit := ''; // unlimited
      FTrialVersion := False;
      FMTMVersion := true;
      v2RecLimit := 1999999999;
    end
    else if t = '1009' then begin
      FVersion := 'Pro';
      FRecLimit := ''; // unlimited
      FTrialVersion := False;
      FMTMVersion := true;
      v2RecLimit := 1999999999;
    end
    else begin // all else is Free Trial
      if not bCancelLogin then begin
        if (t = '') then
          sm('No valid subscription found' + CR //
            + 'Switching to Free Trial mode.')
        else
          sm('Error encountered while retrieving' + CR //
            + 'your subscription. Please contact' + CR //
            + 'Customer Support.');
      end;
      FVersion := 'FREE Trial';
      FRecLimit := ''; // unlimited
      FTrialVersion := True;
      FAcctName := 'FREE Trial';
      FMTMVersion := true;
      v2RecLimit := 1999999999;
    end; // case of SKU
    // ----------------------
    While Pos(' ', FRecLimit) > 0 do
      FRecLimit := RightStr(FRecLimit, Length(FRecLimit) - Pos(' ', FRecLimit));
  finally
      IniFile.WriteString(TRADELOG, 'tlv', Dencrypt(FVersion, ''));
  end;
end; // ConvertVersion


constructor TTLSettings.Create;
var
  IniFileNDC : TRegIniFile;
  fileHandle : Integer;
  Strategy : TStringList;
  F : file;
begin
  try
    FUserCredentialsReceived := false;
    IniFile := TRegIniFile.Create(SOFTWARE);
    CleanUpRegistry;
    Initialize;
    if not bCancelLogin then begin
      VerifySettingsFiles;
      // If for some reason there are settings files missing
      // then create them using the default values.
      if not FileExists(StrategyOptionsFile) //
        or (FileSze(StrategyOptionsFile) = 0) then
        ResetStrategyOptions;
      // ----------------------
      if not FileExists(FutureOptionsFile) //
        or (FileSze(FutureOptionsFile)  = 0) then
        ResetFutureOptions // Also loads FutureList.
      else
        LoadFutureListFromFile;
      // ----------------------
      if not FileExists(BroadBasedOptionsFile) //
        or (FileSze(BroadBasedOptionsFile) = 0) then
        ResetBroadBasedOptions // Also Loads BBOptionsList
      else
        LoadSymbolListFromFile(BroadBasedOptionsFile, FBBIOList);
      // ----------------------
      if not FileExists(ETFsFile) //
        or (FileSze(ETFsFile) = 0) then
        ResetETFs
      else
        LoadSymbolListFromFile(ETFsFile, FETFsList); // 2021-10-27 MB - ETFsFile
      // ----------------------
      if not FileExists(MutualFundFile) //
        or (FileSze(MutualFundFile) = 0) then
        ResetMutualFunds
      else
        LoadSymbolListFromFile(MutualFundFile, FMutualFundList);
    end;
    // ----------------------
    // One time read of an Internet Explorer download setting.
    IniFileNDC := TRegIniFile.Create(INTERNET_EXPLORER);
    try
      FNotifyDownloadComplete := IniFileNDC.ReadString('Main', 'NotifyDownloadComplete', 'No');
    finally
      IniFileNDC.Destroy;
    end;
    // ----------------------
    // One Time write of an Internet Explorer value to ensure we are not running in Compatiblity mode.
    with TRegistry.Create do
      try
        RootKey := HKEY_CURRENT_USER;
        if OpenKey
          ('Software\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_BROWSER_EMULATION',
          true) then
          WriteInteger(ExtractFileName(Application.ExeName), 8888);
      finally
        Free;
      end;
    // ----------------------
    FChartDataList := TChartDataList.Create(ChartConfigFile);
    // Make sure the Update folder exists
    if not DirectoryExists(UpdateDir) then
      ForceDirectories(UpdateDir);
    if not DirectoryExists(LogDir) then
      ForceDirectories(LogDir);
  finally
    gsErrorLog := LogDir + '\error.log'; // reset error log
    if fileExists(gsErrorLog) then
      SysUtils.DeleteFile(gsErrorLog);
  end;
end; // TLSettings.Create


destructor TTLSettings.Destroy;
begin
  IniFile.Destroy;
  FMainFormData.Free;
  FLastOpenFileList.Free;
  FChartDataList.Free;
  Inherited Destroy;
end;


function TTLSettings.GetBackupDir: String;
begin
  Result := DataDir + DIR_BACKUP;
end;


function TTLSettings.getStrategyOptionsFile: String;
begin
  Result := SettingsDir + '\' + FILE_STRATEGY_OPTIONS + EXT_CONFIG;
end;


function TTLSettings.GetSystemInfo: TStringList;
var
  FileDate : TDateTime;
  // ------------------------
  function getWindowsUpTime : String;
  var
    Tick : Cardinal;
    Seconds, Minutes, Hours, Days, Weeks : Integer;
  begin
    Tick := Windows.GetTickCount;
    Seconds := Tick div 1000 mod 60;
    Minutes := Tick div 1000 div 60 mod 60;
    Hours := Tick div 1000 div 60 div 60 mod 24;
    Days := Tick div 1000 div 60 div 60 div 24 mod 7;
    Weeks := Tick div 1000 div 60 div 60 div 24 div 7 mod 52;
    Result := '';
    if Weeks > 0 then
      Result := Result + IntToStr(Weeks) + ' Week(s) ';
    if Days > 0 then
      Result := Result + IntToStr(Days) + ' Day(s) ';
    if Hours > 0 then
      Result := Result + IntToStr(Hours) + ' Hour(s) ';
    if Minutes > 0 then
      Result := Result + IntToStr(Minutes) + ' Minute(s) ';
    if Seconds > 0 then
      Result := Result + IntToStr(Seconds) + ' Seconds';
  end;
  // ------------------------
  function getCPUInfoString : String;
  var
    Cpu : TCpuInfo;
  begin
    JclSysInfo.GetCpuInfo(Cpu);
    Result := InttoStr(System.CPUCount) + 'x ' +  Trim(String(Cpu.CpuName));
  end;
  // ------------------------
  function getDriveInfo : String;
  begin
    Result := '(C:) ' + InttoStr(Trunc(DiskFree(3) / 1024 / 1024 /1024)) //
      + '/' + IntToStr(Trunc(DiskSize(3) / 1024 / 1024 / 1024)) + ' GB';
    { Show D Drive if it exists as well} //2014-02-18 get rid of "No Disk in Drive D:" error on startup
    { if (DiskSize(4) > 0) then
      Result := Result + ' (D:) ' + InttoStr(Trunc(DiskFree(4) / 1024 / 1024 /1024)) + '/' + IntToStr(Trunc(DiskSize(4) / 1024 / 1024 / 1024)) + ' GB';
    }
    Result := Result + ' (free/total)';
  end;
  // ------------------------
begin
  // GetSystemInfo
  try
    Result := TStringList.Create;
    Result.Add('Date/Time: ' + DateTimeToStr(Now));
    Result.Add('Computer Name: ' + JCLSysInfo.GetLocalComputerName);
    Result.Add('User Name: ' + JCLSysInfo.GetLocalUserName);
    Result.Add('Registered Owner: ' + JclSysInfo.GetRegisteredOwner);
    Result.Add('Operating System: ' + JclSysInfo.GetOSVersionString);
    Result.Add('System Language: (' + GetLocaleStr(UserLocale, LOCALE_SENGLANGUAGE, '') + ') ' //
      + GetLocaleStr(UserLocale, LOCALE_SENGCOUNTRY, ''));
    Result.Add('System Up Time: ' + GetWindowsUpTime);
    Result.Add('Processors: ' + getCpuInfoString);
    Result.Add('Physical Memory: ' + InttoStr(Trunc(JclSysInfo.GetFreePhysicalMemory / 1024 / 1024)) //
      + '/' + IntToStr(Trunc(JclSysInfo.GetTotalPhysicalMemory / 1024 / 1024))+ ' MB (free/total)');
    Result.Add('Free Disk Space: ' + getDriveInfo);
    Result.Add('Process ID: ' + InttoStr(JclSysInfo.GetPidFromProcessName(Application.ExeName)));
    Result.Add('Executable: ' + Application.ExeName);
    FileAge(Application.ExeName, FileDate);
    Result.Add('Exec. Date/Time: ' + DateTimeToStr(FileDate));
    Result.Add('Version: ' + GetAppVersion);
  finally
    //
  end;
end; // GetSystemInfo


function TTLSettings.GetTradeLogOptionsUrl: String;
begin
  Result := URL_TRADELOG + URL_OPTIONS;
end;


function TTLSettings.GetTradeLogRegistryEntries: TStringList;
begin
  Result := GetRegistryEntries(SOFTWARE + '\' + TRADELOG);
end;


function TTLSettings.getTradeLogUrl: String;
begin
  Result := URL_TRADELOG;
end;


function TTLSettings.getBroadBasedOptionsFile: String;
begin
  Result := SettingsDir + '\' + FILE_BROAD_BASED_OPTIONS + EXT_CONFIG;
end;


function TTLSettings.getChartConfigFile: String;
begin
  Result := SettingsDir + '\' + FILE_CHART_CONFIG + EXT_CONFIG;
end;


function TTLSettings.GetCommission: Double;
begin
  Result := FCommission;
end;


// ------------------------------------
// Date Expired, Installed
// Assumes dates are encrypted when set,
// decrypted when read (get)
// ------------------------------------
function TTLSettings.GetDateExpired: String;
var
  t : string;
//  exdate : TDate;
begin
  if length(FDateExpired) > 4 then begin
    Result := FDateExpired;
  end
  else begin // -- need to read registry --
    t := IniFile.ReadString(TRADELOG, 'Dtex', '');
    if isdate(t) then result := t // OLD legacy
    else result := Dencrypt(t, '');
  end;
end;

function TTLSettings.GetDateInstalled: String;
var
  t : string;
//  dtInst : TDateTime;
begin
  if length(FDateInstalled) > 4 then begin
    Result := FDateInstalled;
  end
  else begin // -- need to read registry --
    t := IniFile.ReadString(TRADELOG, 'Inst', '');
    if isdate(t) then result := t // OLD legacy
    else result := Dencrypt(t, '');
  end;
end;

procedure TTLSettings.SetDateInstalled(const Value: String);
var
  t : string;
begin
  if (Value <> FDateInstalled) then begin
    if isdate(value) then begin // encrypt it!
      t := dencrypt(Value,'');
      IniFile.WriteString (TRADELOG, 'Inst', t);
    end;
    // note: if it's not a real date, why save it?
  end;
end;

procedure TTLSettings.SetDateExpires(const Value: String);
var
  t : string;
begin
  if (Value <> FDateInstalled) then begin
    if isdate(value) then begin // encrypt it!
      t := dencrypt(Value,'');
      IniFile.WriteString (TRADELOG, 'Dtex', t);
    end;
    // note: if it's not a real date, why save it?
  end;
end;


function TTLSettings.GetEnvironmentVariables: TStringList;
var
  PEnvVars: PChar;
  PEnvEntry: PChar;
  // ------------------------
  function ExpandEnvVars(const Str: string): string;
  var
    BufSize: Integer;
  begin
    BufSize := ExpandEnvironmentStrings(
      PChar(Str), nil, 0);
    if BufSize > 0 then begin
      SetLength(Result, BufSize - 1);
      ExpandEnvironmentStrings(PChar(Str),
        PChar(Result), BufSize);
    end
    else
      Result := '';
  end;
  // ------------------------
begin
  try
    Result := TStringList.Create;
    PEnvVars := GetEnvironmentStrings;
    if PEnvVars <> nil then begin
      PEnvEntry := PEnvVars;
      try
        while PEnvEntry^ <> #0 do begin
          Result.Add(ExpandEnvVars(PEnvEntry));
          Inc(PEnvEntry, StrLen(PEnvEntry) + 1);
        end;
      finally
        Windows.FreeEnvironmentStrings(PEnvVars);
      end;
    end
  finally
    //
  end;
end; // GetEnvironmentVariables


function TTLSettings.getETFsFile: String;
begin
  Result := SettingsDir + '\' + FILE_ETFs + EXT_TSV;
end;


function TTLSettings.GetFeePerTotal: Boolean;
begin
  Result := Not FFeePerShare;
end;


function TTLSettings.getFuturesOptionsFile: String;
begin
  Result := SettingsDir + '\' + FILE_FUTURE_OPTIONS + EXT_CONFIG;
end;


procedure TTLSettings.LoadUserDefaultLocaleFmt;
begin
  FUserLocale := GetUserDefaultLCID;
  GetLocaleFormatSettings(FUserLocale, FUserDefaultLocaleFmt);
end;


procedure TTLSettings.InstallNewFeatures;
const
  SFTP_INIT1 : string = 'echo y | "%ProgramFiles(x86)%\TradeLog\pscp.exe" -pw %1 -P 22 "';
  SFTP_INIT2 : string = '" "tradelog-backup@45.56.119.22:/home/tradelog-backup/backup"';
  SFTPpwd : string = 'a8c22a2c2c3979d4502b9e7fe654510cbca27181';
var
  bInitPuTTyDone : Boolean;
  hProcess : DWord;
  iErr : int64;
  pw1, pw2 : PWideChar;
  sDir, sZipFile, sPSCP, sMsg, s : string;
  sOutFile, ext, BatchName : string;
  BatFile, OutFile : textFile;
  // ------------------------
  function ExecBatch(AName, CLine : string; run_mode : string; var hProcess : DWord;
    var iErr : int64; bVis : Boolean = false): Boolean;
  var
    ShExecInfo : TShellExecuteInfo;
  begin
    Result := false;
    hProcess := 0;
    ZeroMemory(@ShExecInfo, SizeOf(ShExecInfo));
    ShExecInfo.cbSize := SizeOf(ShExecInfo);
    ShExecInfo.fMask := SEE_MASK_NOCLOSEPROCESS;
    if run_mode = '' then
      ShExecInfo.lpVerb := nil
    else
      ShExecInfo.lpVerb := PWideChar(run_mode);
    ShExecInfo.lpFile := PWideChar(AName);
    ShExecInfo.lpParameters := PWideChar(CLine);
    ShExecInfo.lpDirectory := PWideChar(ExtractFilePath(AName));
    if bVis then
      ShExecInfo.nShow := SW_SHOW
    else
      ShExecInfo.nShow := SW_HIDE;
    ShExecInfo.hInstApp := 0;
    if ShellExecuteEx(@ShExecInfo) then begin
      hProcess := ShExecInfo.hProcess;
      Result := hProcess > 0;
    end
    else
      iErr := GetLastError;
  end;
// ------------------------
begin
  // one-time initialization code here.
  bInitPuTTyDone := IniFile.ReadBool(TRADELOG_OPTIONS, 'IPD', false); // 2023-07-25 MB
  if bInitPuTTyDone = false then begin
    try
      screen.Cursor := crHourglass;
      sDir := Settings.DataDir; // GetCurrentDir;
      // ------------
      BatchName := sDir + '\pscp' + formatdatetime('yyyymmdd-hhmmsszzz', Now) + '.bat';
      if FileExists(BatchName) then
        SysUtils.deletefile(BatchName); // NO injection!
      AssignFile(BatFile, BatchName);
      Rewrite(BatFile);
      if not SuperUser then begin
        write(BatFile, '@echo off' + CRLF);
      end;
      write(BatFile, '@echo ...' + CRLF);
      write(BatFile, 'cd "' + sDir + '\"' + CRLF);
      sPSCP := SFTP_INIT1 + BatchName + SFTP_INIT2;
      write(BatFile, sPSCP + CRLF);
      if Developer then begin
        write(BatFile, 'pause' + CRLF)
      end;
      write(BatFile, 'exit' + CRLF);
      CloseFile(BatFile);
      // ------------
      hProcess := screen.activeform.handle;
      iErr := 0;
      // execute the batch file with password as a parameter
      chdir(PChar(sDir));
//if SuperUser then sm('ready to execute batch');
      if ExecBatch(BatchName, SFTPpwd, '', hProcess, iErr, SuperUser) then begin
        IniFile.WriteBool(TRADELOG_OPTIONS, 'IPD', true);
      end;
    finally
      sleep(1500);
      SysUtils.deletefile(BatchName); // the batch file
      screen.Cursor := crDefault;
    end; // try
  end; // if done
end;


procedure TTLSettings.Initialize;
begin
  try
    FInternalLocaleFmt := GetInternalLocaleFmt;
    LoadUserDefaultLocaleFmt; // -- international fmts ----
    ReadGeneralSettings; // -- main app settings ----------
    ReadReportPageSettings;
    FMainFormData := TMainFormData.Create;
    ReadMainFormData;
    FLastOpenFileList := TStringList.Create;
    ReadLastOpenFiles;
    if bCancelLogin then exit; // login aborted or failed
    ReadGlobalOptions;
    FFutureList := TList.Create;
    FBBIOList := TLBBIOList.Create;
    FETFsList := TLETFList.Create;
    FMutualFundList := TLSymbolList.Create;
  finally
    // Initialize
  end;
end;


// ------------------------------------
// Load Trade Type Lists
// ------------------------------------

procedure TTLSettings.LoadFutureListFromFile;
var
  name, value, text : string;
  myFile : TextFile;
  item : PFutureItem;
begin
  try
    FFutureList.Clear;
    if FileExists(FutureOptionsFile) then begin
      AssignFile(myFile, FutureOptionsFile);
      Reset(myFile);
      try
        while not Eof(myFile) do begin
          ReadLn(myFile, text);
          if (pos('<!DOCTYPE html',text)>0) then break;
          if (pos('<!',text)>0) then break;
          // --------------------------
          name := MidStr(text, 0, Pos('=', text) - 1);
          value := Trim(ReplaceStr(text, name + '=', ''));
          new(item);
          FillChar(item^, SizeOf(item^), 0);
          item.Name := Trim(name);
          if IsFloat(Value) then
            item.Value := StrToFloat(value, InternalFmt)
          else
            Item.Value := 0;
          FFutureList.Add(item);
        end;
      finally
        CloseFile(myFile);
      end;
    end;
  finally
    // LoadFuturesListFromFile
  end;
end;


// parses CSV file record into a String List
function ParseCSVtext(const S : string; ADelimiter : Char = ','; AQuoteChar : Char = '"'): TStrings;
type
  TState = (sNone, sBegin, sEnd);
var
  I : integer;
  state : TState;
  token : string;
  // -------------------
  procedure AddToResult;
  begin
    if (token <> '') and (token[1] = AQuoteChar) then begin
      Delete(token, 1, 1);
      Delete(token, Length(token), 1);
    end;
    result.Add(token);
    token := '';
  end;
// -------------------
begin
  if S = '' then
    exit;
  result := TStringList.Create;
  state := sNone;
  token := '';
  I := 1;
  while I <= Length(S) do begin
    case state of
    sNone :
      begin
        if S[I] = ADelimiter then begin
          token := '';
          AddToResult;
          Inc(I);
          Continue;
        end;
        state := sBegin;
      end;
    sBegin :
      begin
        if S[I] = ADelimiter then
          if (token <> '') and (token[1] <> AQuoteChar) then begin
            state := sEnd;
            Continue;
          end;
        if S[I] = AQuoteChar then
          if (I = Length(S)) or (S[I + 1] = ADelimiter) then
            state := sEnd;
      end;
    sEnd :
      begin
        state := sNone;
        AddToResult;
        Inc(I);
        Continue;
      end;
    end; // case of state
    token := token + S[I];
    Inc(I);
  end;
  if token <> '' then
    AddToResult;
  if S[Length(S)] = ADelimiter then
    AddToResult
end;

// --------------------------------------------------
// used to load BBIOs, Futures, Mutual Funds and ETFs
// or any text file with 2 fields delimited by ' = '
// --------------------------------------------------
procedure TTLSettings.LoadSymbolListFromFile(FileName : String; MyList : TList);
var
  symbol, multiplier, descriptn, text, tLast : string;
  myFile : TextFile;
  item : PSymbolItem;
  i : Integer;
  lineLst : TStrings;
begin
  try
    MyList.clear;
    tLast := '';
    // Load the values from the configuration file into frmMain.SymbolList.
    if FileExists(FileName) then begin
      AssignFile(myFile, FileName);
      Reset(myFile);
      try
        while not Eof(myFile) do begin
          ReadLn(myFile, text);
          if (text = tLast) then begin
            continue; // 2021-09-20 MB - skip duplicates
          end;
          if (pos('<!DOCTYPE html',text)>0) then break;
          if (pos('<!',text)>0) then break;
          // --- parse data depending on format -----------
          i := Pos(tab, text);
          if i > 0 then begin
            lineLst := ParseCSVtext(text, tab);
            // u	          AAA = ETF
            // Ticker	      AAA
            // Type	        ETF
            // Description	AAF First Priority CLO Bond ETF
            // Asset Class	Bond
            symbol := lineLst[1];
            multiplier := lineLst[2];
            descriptn := lineLst[3];
          end
          else begin
            i := Pos(' = ', text); // If there is an equal then we will get the multiplier also
            if i > 0 then begin
              symbol := MidStr(text, 0, i - 1);
              multiplier := copy(text,i+3);
              // multiplier := ReplaceStr(text, symbol + ' = ', '');
            end
            else begin
              symbol := text;
              multiplier := '';
            end;
          end;
          new(item);
          FillChar(item^, SizeOf(item^), 0);
          item.Symbol := symbol;
          item.Multiplier := multiplier;
          item.Descriptn := descriptn;
          MyList.Add(item);
          tLast := text; // remember last record
        end;
      finally
        CloseFile(myFile);
      end;
    end;
  finally
    // LoadSymbolListFromFile
  end;
end;


procedure TTLSettings.Login(b1st : boolean);
var
  f : TdlgLogIn;
  i : integer;
  s : string;
begin
  try
    f := TdlgLogIn.Create(nil);
    // ----------------------
    // initialize the form before showing
    f.edEmail.Text := FUserEmail;
    f.edPassword.Text := FPassword; // from registry
    if b1st then
      f.lblPassword.Caption := 'Initial Password:'
    else
      f.lblPassword.Caption := 'Your Password:';
    f.chkPassword.Checked := FKeepPwd;
    // ----------------------
    // now show it, return user input
    i := f.ShowModal;
    if bCancelLogin then exit; // login aborted or failed
    // ----------------------
    if f.edEmail.Text <> FUserEmail then begin
      SetUserEmail(f.edEmail.Text);
    end;
    // ----------------------
    if f.chkPassword.Checked <> FKeepPwd then begin
      SetKeepPwd(f.chkPassword.Checked);
    end;
    // ----------------------
    if FKeepPwd then begin
      SetUserPassword(f.edPassword.Text);
    end
    else begin
      SetUserPassword(''); // erase it
    end; // if KeepPwd
    // ----------------------
  finally
    f.Free;
  end;
end; // Login procedure


// ------------------------------------
// Get date installed from v2 API call
// or registry if offline.
// ------------------------------------
procedure TTLSettings.ConvertDateInstalled(Value : String; WriteToRegistry : Boolean = false);
var
  D : TDateTime;
begin
  try
    if gbOffline then begin // get install date from registry
      // note: value passed in is read from registry INST
      // D := FDateInstalled;
      if not isLongDate(Value) then
        Value := dencrypt(Value, '');
      try
        D := xStrToDate(Value, UserFmt);
        DateInstalled := DateToStr(D, InternalFmt);
      except
        // If for some reason we cannot read the date installed then set it to today.
        DateInstalled := '01/01/2023'; // DateToStr(Date, InternalFmt);
      end;
      if v2CreateDate = 0 then
        v2CreateDate := xStrToDate(DateInstalled, InternalFmt);
    end
    else begin // online, so use login data
      D := v2CreateDate; // from login
      // Use property so date is written to registry
      if D = 0 then
        DateInstalled := '01/01/2023' // dateToStr(IncYear(Date, -1), InternalFmt)
      else
        DateInstalled := DateToStr(D, InternalFmt);
    end;
    // --- Save to Registry?
    if WriteToRegistry then
      IniFile.WriteString(TRADELOG, INST, dencrypt(FDateInstalled,''));
  finally
    // swallow errors
  end;
end; // ConvertDateInstalled(FDateInstalled)


procedure TTLSettings.ReadGeneralSettings;
var
  s, t : String;
  i, j : integer;
  tempFmt: TFormatSettings;
begin
  try
    // --- LOGIN info -----------------
    FUserEmail := IniFile.ReadString (TRADELOG, 'UserEmail', ''); // NEW
    // need RegCode for upw
    FRegCode := dEncrypt(IniFile.ReadString (TRADELOG_SETUP, 'RC4', FRegCode), '');
    if Pos('|', FRegCode) > 0 then begin
      i := POS('|', FRegCode);
      j := length(FRegCode);
      if j > i then
        t := Copy(FRegCode, i+1, j-i);
      FRegCode := LeftStr(FRegCode, i-1);
    end;
    FKeepPwd := IniFile.ReadBool(TRADELOG_OPTIONS, 'KP', FKeepPwd); // NEW
    // First time password?
    s := IniFile.ReadString (TRADELOG, 'upw', '&');
    if s = '&' then begin
      FPassword := FRegCode;
      Login(true); // see above
    end
    else begin
      FPassword := dEncrypt(s, ''); // NEW
      Login(false); // see above
    end;
    // --- Version info ---------------
    s := IniFile.ReadString(TRADELOG, 'tlv', FVersion);
    if s = '' then begin
      s := t;
      IniFile.WriteString(TRADELOG, 'tlv', Dencrypt(t, ''));
    end;
    t := dencrypt(s, '');
    ConvertVersion(s); // 's' is not used any longer
    // --- Install/Expire dates -------
    if gbOffline then begin // read from registry
      s2CreateDate := DateInstalled;
      s2EndDate := DateExpired;
      try
        s2StartDate := DateToStr(StrToDate(s2EndDate)-365);
      except
        s2StartDate := '';
      end;
      // note: no way to know if cancelled without internet
    end
    else begin // save to registry
      DateInstalled := s2CreateDate;
      DateExpired := s2EndDate;
    end;
    // ----------------------
    FNewInstall := IniFile.ReadInteger(TRADELOG_SETUP, 'NewInstall', FNewInstall);
    // ----------------------
    FRegName :=  IniFile.ReadString(TRADELOG_SETUP, 'RN', FRegName);
    if gbOffline then
      FAcctName := IniFile.ReadString (TRADELOG_OPTIONS, 'AcctName', '')
    else
      FAcctName := v2UserName;
    FNameOnReports := IniFile.ReadString (TRADELOG_OPTIONS, 'NameOnReports', '');
    FSSN := IniFile.ReadString (TRADELOG_OPTIONS, 'ss', '');
    if Length(FSSN) > 0 then FSSN := Dencrypt(FSSN, '');
    FIsEin := Inifile.ReadBool(TRADELOG_OPTIONS, 'IsEIN', false);
    // ----------------------
    FMyDocumentsFolder := GetWindowsSpecialFolder(ID_MyDocumentsFolder);
    FUserFolder := GetWindowsSpecialFolder(ID_UserFolder);
    // ----------------------
    // Are these even used anymore?
    FGTTTaxPrep := IniFile.ReadString(TRADELOG_SETUP, 'GTTTaxPrep', '');
    FSecFee := StrToFloat(IniFile.ReadString(TRADELOG_OPTIONS, 'SECFee', '0'), UserFmt);
    FFeePerShare := IniFile.ReadBool(TRADELOG_OPTIONS, 'PerShare', False);
    FFeeSold := IniFile.ReadBool(TRADELOG_OPTIONS, 'FeeSold', False);
    FFeeBought := IniFile.ReadBool(TRADELOG_OPTIONS, 'FeeBought', False);
    // ----------------------
    FBCTimeout := IniFile.ReadInteger(TRADELOG_OPTIONS, 'BCTimeout', 240000);
    // ----------------------
    FCommission := StrToFloat(IniFile.ReadString(TRADELOG_OPTIONS, 'Comm', '0'), UserFmt);
    // ----------------------
    // If there is an INI Entry and the directory does not currently exist
    // then this likely means that we may be dealing with a network folder
    // that is offline. Therefore let's just use the Default
    S := IniFile.ReadString(TRADELOG, 'InstallDir5', '');
    if (Length(S) = 0) then
      SetDataDir(FMyDocumentsFolder + '\' + TRADELOG)
    else if not DirectoryExists(S) then begin
      MessageDlg('The Data Directory you last used (' + S + ') is not currently available' + CR
        + CR
        + 'Tradelog will default to ' + FMyDocumentsFolder + '\' + TRADELOG,
         mtError, [mbOK], 0);
      SetDataDir(FMyDocumentsFolder + '\' + TRADELOG);
    end
    else
      SetDataDir(S);
    FUserBackupDir := IniFile.ReadString(TRADELOG, 'UserBackupDir', BackupDir);
    FUserBackupDate := IniFile.ReadBool(TRADELOG, 'UserBackupDate', False);
    RemoveTrailingBackSlash(FDataDir);
    FInstallDir := IniFile.ReadString(TRADELOG, 'InstallDir1', extractfilepath(Application.exename));
    RemoveTrailingBackSlash(FInstallDir);
    // ----------------------
    FSkinName := IniFile.ReadString (TRADELOG_OPTIONS, 'SkinName', 'Office2010Silver');
    FLegacyBC := IniFile.ReadBool(TRADELOG_OPTIONS, 'LegacyBC', False);
  finally
    // ReadGeneralSettings
  end;
end;


procedure TTLSettings.ReadGlobalOptions;
begin
  try
    FDispMTaxLots:= IniFile.ReadBool(TRADELOG_OPTIONS, 'MatchedTaxLots', false);
    FDispNotes:= IniFile.ReadBool(TRADELOG_OPTIONS, 'ShowNotes', false);
    FDispOptTicks:= IniFile.ReadBool(TRADELOG_OPTIONS, 'OptionTickers', false);
    FDispTimeBool:= IniFile.ReadBool(TRADELOG_OPTIONS, 'OptionTime', false);
    FDispSupportCenter := IniFile.ReadBool(TRADELOG_OPTIONS, 'ShowSupportCenteronStartup', false);
    FDispQuickTour := IniFile.ReadBool(TRADELOG_OPTIONS, 'ShowQuickTouronStartup', false);
    FDispImport := IniFile.ReadBool(TRADELOG_OPTIONS,'ShowInstructions', false);
    FDispQS := IniFile.ReadBool(TRADELOG_OPTIONS,'DisplayQuickStart', true);
    FDispWSdefer:= IniFile.ReadBool (TRADELOG_OPTIONS,'inclWashSales',false);
    FDispStrategies := IniFile.ReadBool(TRADELOG_OPTIONS, 'ShowStrategies', false);
    FDispAcct := IniFile.ReadBool(TRADELOG_OPTIONS, 'ShowAcct', false);
    FDisp8949Code := IniFile.ReadBool(TRADELOG_OPTIONS, 'Show8949Code', false);
    FDispWSHolding := IniFile.ReadBool(TRADELOG_OPTIONS, 'ShowWSHolding', false);
  finally
    // ReadGlobalOptions
  end;
end;


procedure TTLSettings.ReadLastOpenFiles;
var
  FileName : String;
begin
  try
    // get last 4 files opened
    FileName := IniFile.ReadString(TRADELOG_SETUP, 'Last4File1', '');
    if (Length(FileName) > 0) and (pos('.tdf',fileName) > 0) //only show tdf files
    then begin
      {We used to save the Numeral of the file but this is unnecessary so remove this}
      if FileName[1] = '&' then delete(FileName, 1, 4);
      if FileExists(FileName) then FLastOpenFileList.Add(FileName);
    end;
    FileName := IniFile.ReadString(TRADELOG_SETUP, 'Last4File2', '');
    if (Length(FileName) > 0) and (pos('.tdf',fileName) > 0)  //only show tdf files
    then begin
      {We used to save the Numeral of the file but this is unnecessary so remove this}
      if FileName[1] = '&' then delete(FileName, 1, 4);
      if FileExists(FileName) then FLastOpenFileList.Add(FileName);
    end;
    FileName := IniFile.ReadString(TRADELOG_SETUP, 'Last4File3', '');
    if (Length(FileName) > 0) and (pos('.tdf',fileName) > 0)  //only show tdf files
    then begin
      {We used to save the Numeral of the file but this is unnecessary so remove this}
      if FileName[1] = '&' then delete(FileName, 1, 4);
      if FileExists(FileName) then FLastOpenFileList.Add(FileName);
    end;
    FileName := IniFile.ReadString(TRADELOG_SETUP, 'Last4File4', '');
    if (Length(FileName) > 0) and (pos('.tdf',fileName) > 0)  //only show tdf files
    then begin
      {We used to save the Numeral of the file but this is unnecessary so remove this}
      if FileName[1] = '&' then delete(FileName, 1, 4);
      if FileExists(FileName) then FLastOpenFileList.Add(FileName);
    end;
  finally
    // ReadLastOpenFiles
  end;
end;


procedure TTLSettings.ReadMainFormData;
begin
  try
    FMainFormData.FStatus := IniFile.ReadInteger(TRADELOG_MAINFORM, 'Status', -1);
    FMainFormData.FTop := IniFile.ReadInteger(TRADELOG_MAINFORM, 'Top', -1);
    FMainFormData.FLeft := IniFile.ReadInteger(TRADELOG_MAINFORM, 'Left', -1);
    FMainFormData.FWidth := IniFile.ReadInteger(TRADELOG_MAINFORM, 'Width', -1);
    FMainFormData.FHeight := IniFile.ReadInteger(TRADELOG_MAINFORM, 'Height', -1);
  finally
    // ReadMainFormData
  end;
end;


procedure TTLSettings.WriteMainFormData;
begin
  try
    IniFile.WriteInteger(TRADELOG_MAINFORM, 'Status', FMainFormData.FStatus);
    IniFile.WriteInteger(TRADELOG_MAINFORM, 'Top', FMainFormData.FTop);
    IniFile.WriteInteger(TRADELOG_MAINFORM, 'Left', FMainFormData.FLeft);
    IniFile.WriteInteger(TRADELOG_MAINFORM, 'Width', FMainFormData.FWidth);
    IniFile.WriteInteger(TRADELOG_MAINFORM, 'Height', FMainFormData.FHeight);
  finally
    // WriteMainFormData
  end;
end;


function TTLSettings.ReadUpdateTime : string;
begin
  result := IniFile.ReadString(TRADELOG, 'CheckForUpdate', '');
end;

procedure TTLSettings.WriteUpdateTime(sUpdateTime:string);
begin
  IniFile.WriteString(TRADELOG, 'CheckForUpdate', sUpdateTime);
end;


function TTLSettings.ReadGetStarted : string;
begin
  result := IniFile.ReadString(TRADELOG, 'GetStarted', 'T');
end;

procedure TTLSettings.WriteGetStarted(val:string);
begin
  IniFile.DeleteKey(TRADELOG, 'GetStarted');
  IniFile.WriteString(TRADELOG, 'GetStarted', val);
end;


procedure TTLSettings.WriteLastOpenFiles;
begin
  try
    // 2015-07-06 must clear all ini entries first
    IniFile.DeleteKey(TRADELOG_SETUP, 'Last4File1');
    IniFile.DeleteKey(TRADELOG_SETUP, 'Last4File2');
    IniFile.DeleteKey(TRADELOG_SETUP, 'Last4File3');
    IniFile.DeleteKey(TRADELOG_SETUP, 'Last4File4');
    if FLastOpenFileList.Count > 0 then
      IniFile.WriteString(TRADELOG_SETUP, 'Last4File1', '&1  ' + FLastOpenFileList[0]);
    if FLastOpenFileList.Count > 1 then
      IniFile.WriteString(TRADELOG_SETUP, 'Last4File2', '&2  ' + FLastOpenFileList[1]);
    if FLastOpenFileList.Count > 2 then
      IniFile.WriteString(TRADELOG_SETUP, 'Last4File3', '&3  ' + FLastOpenFileList[2]);
    if FLastOpenFileList.Count > 3 then
      IniFile.WriteString(TRADELOG_SETUP, 'Last4File4', '&4  ' + FLastOpenFileList[3]);
  finally
    // WriteLastOpenFiles
  end;
end;


procedure TTLSettings.WriteReportPage;
begin
  try
    IniFile.WriteInteger (TRADELOG_OPTIONS, 'HeadFont', FReportPageData.FontHeadingSize);
    IniFile.WriteInteger (TRADELOG_OPTIONS, 'DataFont', FReportPageData.FontDataSize);
    IniFile.WriteInteger (TRADELOG_OPTIONS, 'LeftMargin', FReportPageData.Margins.Left);
    IniFile.WriteInteger (TRADELOG_OPTIONS, 'RightMargin', FReportPageData.Margins.Right);
    IniFile.WriteInteger (TRADELOG_OPTIONS, 'TopMargin', FReportPageData.Margins.Top);
    IniFile.WriteInteger (TRADELOG_OPTIONS, 'BottomMargin', FReportPageData.Margins.Bottom);
    IniFile.WriteBool (TRADELOG_OPTIONS, 'ShowFull', FReportPageData.PreviewFullScreen);
    IniFile.WriteBool (TRADELOG_OPTIONS, 'ShowWidth', FReportPageData.FitToWidth);
    IniFile.WriteInteger (TRADELOG_OPTIONS, 'Orient', Integer(FReportPageData.Orientation));
    IniFile.WriteBool (TRADELOG_OPTIONS, 'UseColor', FReportPageData.UseColor);
  finally
    // WriteReportPage
  end;
end;


procedure TTLSettings.ReadReportPageSettings;
begin
  try
    FReportPageData.FontHeadingSize :=  IniFile.ReadInteger (TRADELOG_OPTIONS, 'HeadFont', 14);
    FReportPageData.FontDataSize := IniFile.ReadInteger (TRADELOG_OPTIONS, 'DataFont', 7);
    FReportPageData.PreviewFullScreen := IniFile.ReadBool (TRADELOG_OPTIONS, 'ShowFull', false);
    FReportPageData.FitToWidth := IniFile.ReadBool (TRADELOG_OPTIONS, 'ShowWidth', true);
    FReportPageData.Margins.Left := IniFile.ReadInteger (TRADELOG_OPTIONS, 'LeftMargin', 500);
    FReportPageData.Margins.Right := IniFile.ReadInteger (TRADELOG_OPTIONS, 'RightMargin', 500);
    FReportPageData.Margins.Top := IniFile.ReadInteger (TRADELOG_OPTIONS, 'TopMargin', 500);
    FReportPageData.Margins.Bottom := IniFile.ReadInteger (TRADELOG_OPTIONS, 'BottomMargin', 500);
    FReportPageData.UseColor := IniFile.ReadBool (TRADELOG_OPTIONS, 'UseColor', false);
    FReportPageData.Orientation := TPrinterOrientation(IniFile.ReadInteger(TRADELOG_OPTIONS, 'Orient', 0));
  finally
    // ReadReportPageSettings
  end;
end;


procedure TTLSettings.ReadUserEMailSettings;
//var
//  webData:string;
begin
  try
//    try
//      webData:= readURLEx('http://www.tradelogsoftware.com/support/get-email-addr/?regcode=' + regcode);
//      FEmail := parseHTML(webData,'<email>','</email>');
//      FUserName := parseHTML(webData,'<name>','</name>');
//    except
//      // We will ignore this exception for now.
//    end;
    if Length(Trim(FEMail)) = 0 then FEMail := 'support@tradelogsoftware.com';
    if Length(Trim(FUserName)) = 0 then FUserName := 'Cogenta Computing';
    FUserCredentialsReceived := True;
  finally
    // ReadUserEMailSettings
  end;
end;


procedure TTLSettings.RemoveTrailingBackSlash(var path: String);
begin
  if RightStr(path, 1)= '\' then delete(path, Length(Path), 1);
end;


function TTLSettings.GetHelpFileName: String;
begin
  Result := FInstallDir + HELP_FILE_NAME;
end;


function TTLSettings.GetImporTDir: String;
begin
   Result := FDataDir + DIR_IMPORT;
end;


// API calls, version 2: all are POST, in JSON format
// brokerconnect.live/api/v2/configs/bbio
// brokerconnect.live/api/v2/configs/etfs
// brokerconnect.live/api/v2/configs/futures
// brokerconnect.live/api/v2/configs/strategies
// All have just one parameter: UserToken
// All respond with either a list OR "Error": "UserToken does not exist"
// --------------------------------------------------
// This method will get an option file from the Tradelog Internet site}
// --------------------------------------------------
function TTLSettings.GetInitialOptionFile(OptionType: String) : Boolean;
var
  InternetFile, LocalFileName, sExt : string;
  MyFile : TextFile;
begin
//  screen.Cursor := crHourglass;
  try
    Result := False;
    if (OptionType = FILE_ETFs) then
      sExt := EXT_TSV
    else
      sExt := EXT_CONFIG;
    InternetFile := TradeLogOptionsUrl + OptionType + sEXT;
    LocalFileName := SettingsDir + '\' + OptionType + sEXT;
    // --------------------------------
    try
      Result := GetConfigData(v2UserToken, OptionType, LocalFileName);
    except
      // We don't want to fail on startup if we cannot get the files, so
      // we'll just create blank ones for now and ignore the exception.
      // Even though we did not get connected we need to write some file
      // for the future, so write a blank one.
      AssignFile(MyFile, LocalFileName);
      Rewrite(MyFile);
      CloseFile(MyFile);
    end
  finally
//    screen.Cursor := crDefault; // to prevent freezing program!
  end;
end; // GetInitialOptionFile


function TTLSettings.GetLogDir: String;
begin
  Result := FUserFolder + '\.' + TRADELOG + DIR_LOG;
end;


function TTLSettings.GetLogFileName: String;
begin
  Result := TRADELOG + '.csl';
end;


function TTLSettings.GetMTMVersion: Boolean;
begin
  Result := (taxidVer and (TLVer = 'TradeLog') )
    or (Pos('Pro', TLVer) > 0)
    or (Pos('MTM', TLVer) > 0)
    or (Pos('Trial', TLVer) > 0);   //2014-03-25 Trial now includes MTM
end;


procedure TTLSettings.GetUserCredentials;
begin
  if Not FUserCredentialsReceived then ReadUserEMailSettings;
end;


function TTLSettings.getMutualFundFile: String;
begin
  Result := SettingsDir + '\' + FILE_MUTUAL_FUNDS + EXT_CONFIG;
end;


function TTLSettings.GetMyDocumentsFolder: String;
begin
  Result := FMyDocumentsFolder;
end;


function TTLSettings.GetRegistrationURL: String;
begin
  Result := REGISTRATION_URL;
end;


function TTLSettings.GetRegistryEntries(RootName : String): TStringList;
var
  SubKeyNames : TStringList;
  Name : String;
  Value : TRegKeyInfo;
  TradeLogIni : TRegIniFile;
begin
  try
    Result := TStringList.Create;
    TradeLogIni := TRegIniFile.Create(RootName);
    try
      SubKeyNames := TStringList.Create;
      try
        TradeLogIni.GetValueNames(SubKeyNames);
        {Get all the values for this key}
        for Name in SubKeyNames do
          if Name <> 'tlv' then
            Result.Append(RootName + '\' + Name + '=' + TradeLogIni.GetDataAsString(Name));
        {Get all the sub keys and loop through them, getting data for them.}
        TradeLogIni.GetKeyNames(SubKeyNames);
        for Name in SubKeyNames do
          Result.AddStrings(GetRegistryEntries(RootName + '\' + Name));
      finally
        SubKeyNames.Free;
      end;
    finally
      TradeLogIni.Free;
    end;
  finally
    // GetRegistryEntries
  end;
end;


function TTLSettings.GetReportDir: String;
begin
  Result := DataDir + DIR_REPORTS;
end;


function TTLSettings.GetSettingsDir: String;
begin
  Result := FUserFolder + '\.' + TRADELOG + DIR_SETTINGS;
end;


// ------------------------------------
// Save Trade Type Lists
// ------------------------------------
procedure TTLSettings.SaveFutureListToFile;
var
  i : Integer;
  myFile : TextFile;
  item : PFutureItem;
begin
  //rj Logger.EnterMethod(self, 'SaveFutureListToFile');
  try
    AssignFile(myFile, FutureOptionsFile);
    try
      Rewrite(myFile);
      try
        for i := 0 to FFutureList.Count - 1 do begin
          item := FFutureList[i];
          WriteLn(myFile, Trim(item.Name) + '=' + FloatToStr(item.Value));
        end;
      finally
        // Close the file
        CloseFile(myFile);
      end;
    except
      on E : Exception do
        MessageDlg(FutureOptionsFile
        + ' configuration file could not be saved for the following reason:' + CR //
        + CR //
        + E.Message + CR //
        + CR //
        + 'Possible causes: the file is locked by Windows or ' + CR //
        + 'your windows user does not have write permissions to the folder.',
        mtError, [mbOK], 0);
    end;
  finally
    // SaveFutureListToFile
  end;
end;


// --------------------------
// Used to save 2-field lists
// --------------------------
procedure TTLSettings.SaveSymbolListToFile(FileName : String; MyList : TList);
var
  i : Integer;
  myFile : TextFile;
  item : PSymbolItem;
  sEXT : string;
  bTSV : boolean;
begin
  try
    AssignFile(myFile, FileName);
    sEXT := uppercase(rightstr(FileName,4));
    bTSV := (sEXT = '.TSV');
    try
      Rewrite(myFile);
      try
        for i := 0 to MyList.Count - 1 do begin
          item := MyList[i];
          if bTSV then
            WriteLn(myFile, item.Symbol + ' = ' + item.Multiplier //
              + TAB + item.Symbol + TAB + item.Multiplier + TAB + item.Descriptn)
          else if Length(item.Multiplier) > 0 then
            WriteLn(myFile, item.Symbol + ' = ' + item.Multiplier)
          else
            WriteLn(myFile, item.Symbol)
        end;
      finally
        CloseFile(myFile);
      end;
    except
      on E : Exception do
        MessageDlg(FileName + ' configuration file could not be saved' + CR //
        + 'for the following reason:' + CR //
        + CR //
        + E.Message +  CR //
        + CR //
        + 'Possible causes: the file is locked by Windows or ' + CR //
        + 'your windows user does not have write permissions to the folder.', mtError, [mbOK], 0);
    end;
  finally
    // SaveSymbolListToFile
  end;
end;


procedure TTLSettings.SetAcctName(const Value: String);
begin
  if not TrialVersion and (Value <> FAcctName) then begin
    FAcctName := Value;
    IniFile.WriteString (TRADELOG_OPTIONS, 'AcctName', FAcctName);
  end;
end;


procedure TTLSettings.SetNameOnreports(const Value: String);
begin
  if not TrialVersion and (Value <> FNameOnReports) then begin
    FNameOnReports := Value;
    IniFile.WriteString (TRADELOG_OPTIONS, 'NameOnReports', FNameOnReports);
  end;
end;


procedure TTLSettings.SetBCTimeout(const Value: Integer);
begin
  if FBCTimeout <> Value then begin
    FBCTimeout := Value;
    IniFile.WriteInteger(TRADELOG_OPTIONS, 'BCTimeout', FBCTimeout);
  end;
end;


procedure TTLSettings.SetChartDataList(const Value: TChartDataList);
begin
  FChartDataList := Value;
  FChartDataList.SaveData;
end;


procedure TTLSettings.SetCommission(const Value: Double);
begin
  FCommission := Value;
  IniFile.WriteString(TRADELOG_OPTIONS, 'Comm', FloatToStr(Value, Settings.UserFmt));
end;


procedure TTLSettings.SetDataDir(const Value: String);
begin
  try
    if (FDataDir <> Value) then begin
      FDataDir := Value;
      // If a backslash is on the end then remove it.
      removeTrailingBackSlash(FDataDir);
      // Change to the directory to ensure that it is the current directory.
      ForceDirectories(fDataDir);
      Chdir(FDataDir);
      //Write the DataDir to the Registry
      IniFile.WriteString(TRADELOG, 'InstallDir5', FDataDir);
      //Make sure the Import, Reports and Backup Folders are created when they change Data directory.
      if not DirectoryExists(ImportDir) then ForceDirectories(ImportDir);
      if not DirectoryExists(ReportDir) then ForceDirectories(ReportDir);
      if not DirectoryExists(BackupDir) then ForceDirectories(BackupDir);
      if not DirectoryExists(UndoDir) then   ForceDirectories(UndoDir);
    end;
  finally
    // SetDataDir
  end;
end;


procedure TTLSettings.SetDisp8949Code(const Value: Boolean);
begin
  FDisp8949Code := Value;
  IniFile.WriteBool(TRADELOG_OPTIONS, 'Show8949Code', FDisp8949Code);
end;


procedure TTLSettings.SetOldWS(const Value: Boolean);
begin
  FOldWS := Value;
  //IniFile.WriteBool(TRADELOG_OPTIONS, 'OldWS', FOldWS);
end;


procedure TTLSettings.setDispAcct(const Value: Boolean);
begin
  FDispAcct := Value;
  IniFile.WriteBool(TRADELOG_OPTIONS, 'ShowAcct', FDispAcct);
end;


procedure TTLSettings.setDispImport(const Value: Boolean);
begin
  FDispImport := Value;
  IniFile.WriteBool(TRADELOG_OPTIONS, 'ShowInstructions', FDispImport);
end;


procedure TTLSettings.setDispMTaxLots(const Value: Boolean);
begin
  FDispMTaxLots := Value;
  IniFile.WriteBool(TRADELOG_OPTIONS, 'MatchedTaxLots', FDispMTaxLots);
end;


procedure TTLSettings.setDispNotes(const Value: Boolean);
begin
  FDispNotes := Value;
  IniFile.WriteBool(TRADELOG_OPTIONS, 'ShowNotes', FDispNotes);
end;


procedure TTLSettings.setDispOptTicks(const Value: Boolean);
begin
  FDispOptTicks := Value;
  IniFile.WriteBool(TRADELOG_OPTIONS, 'OptionTickers', FDispOptTicks);
end;


procedure TTLSettings.setDispQS(const Value: Boolean);
begin
  FDispQS := Value;
  IniFile.WriteBool(TRADELOG_OPTIONS, 'DisplayQuickStart', FDispQS);
end;


procedure TTLSettings.SetDispStrategies(const Value: Boolean);
begin
  FDispStrategies := Value;
  IniFile.WriteBool(TRADELOG_OPTIONS, 'ShowStrategies', FDispStrategies);
end;


procedure TTLSettings.SetDispSupportCenter(const Value: Boolean);
begin
  FDispSupportCenter := Value;
  IniFile.WriteBool(TRADELOG_OPTIONS, 'ShowSupportCenteronStartup', FDispSupportCenter);
end;


procedure TTLSettings.SetDispQuickTour(const Value: Boolean);
begin
  FDispQuickTour := Value;
  IniFile.WriteBool(TRADELOG_OPTIONS, 'ShowQuickTouronStartup', FDispQuickTour);
end;


procedure TTLSettings.setDispTimeBool(const Value: Boolean);
begin
  FDispTimeBool := Value;
  IniFile.WriteBool(TRADELOG_OPTIONS, 'OptionTime', FDispTimeBool);
end;


procedure TTLSettings.SetNewInstall(const Value: Integer);
begin
  FNewInstall := Value;
  IniFile.WriteInteger(TRADELOG_SETUP, 'NewInstall', 1);
end;


procedure TTLSettings.setDispWSDefer(const Value: Boolean);
begin
  FDispWSDefer := Value;
  IniFile.WriteBool(TRADELOG_OPTIONS, 'inclWashSales', FDispWSdefer);
end;


procedure TTLSettings.SetSkinName(const Value: string);
begin
  FSkinName := Value;
  IniFile.WriteString (TRADELOG_OPTIONS, 'SkinName', FSkinName);
end;


procedure TTLSettings.SetLegacyBC(const Value: boolean);
begin
  FLegacyBC := Value;
  IniFile.WriteBool (TRADELOG_OPTIONS, 'LegacyBC', FLegacyBC);
end;

// ------------------------------------
// User Email and Password settings
// ------------------------------------
procedure TTLSettings.SetUserEmail(const Value: String);
begin
  try
    if (FUserEmail <> Value) then begin
      FUserEmail := Value;
      IniFile.WriteString(TRADELOG, 'UserEmail', FUserEmail);
    end;
  finally
    // SetUserEmail
  end;
end;

procedure TTLSettings.SetUserPassword(const Value: String);
begin
  try
//    if (FPassword <> Value) then begin
      FPassword := Value;
      IniFile.WriteString(TRADELOG, 'upw', Dencrypt(FPassword, ''));
//    end;
  except
    sm('error');
  end; // SetUserPassword
end;

procedure TTLSettings.SetKeepPwd(const Value: Boolean);
begin
  FKeepPwd := Value;
  IniFile.WriteBool(TRADELOG_OPTIONS, 'KP', FKeepPwd);
end;

// ------------------------------------
// Reset Special Types
// ------------------------------------
procedure TTLSettings.ResetBroadBasedOptions;
begin
  GetInitialOptionFile(FILE_BROAD_BASED_OPTIONS);
  LoadSymbolListFromFile(BroadBasedOptionsFile, FBBIOList);
end;

procedure TTLSettings.ResetETFs;
begin
    GetInitialOptionFile(FILE_ETFs);
    LoadSymbolListFromFile(ETFsFile, FETFsList);
end;

procedure TTLSettings.ResetFutureOptions;
begin
   GetInitialOptionFile(FILE_FUTURE_OPTIONS);
   LoadFutureListFromFile;
end;

procedure TTLSettings.ResetMutualFunds;
begin
//  screen.Cursor := crHourglass;
//  try
    GetInitialOptionFile(FILE_MUTUAL_FUNDS);
    LoadSymbolListFromFile(MutualFundFile, FMutualFundList);
//  finally
//  screen.Cursor := crDefault;
//  end;
end;

procedure TTLSettings.ResetStrategyOptions;
begin
  GetInitialOptionFile(FILE_STRATEGY_OPTIONS)
end;


// ------------------------------------
// Set Special Types
// ------------------------------------
procedure TTLSettings.SetETFsList(const Value: TLETFList);
begin
  FETFsList := Value;
  //SaveSymbolListToFile(ETFsFile, FETFsList);
end;

procedure TTLSettings.SetFutureList(const Value: TList);
begin
  FFutureList := Value;
//  SaveFutureListToFile;   //this saves way too many times 2013-12-31
end;

procedure TTLSettings.SetMutualFundList(const Value: TLSymbolList);
begin
  FMutualFundList := Value;
  SaveSymbolListToFile(MutualFundFile, FMutualFundList);
end;

procedure TTLSettings.SetBBIOList(const Value: TLBBIOList);
begin
  FBBIOList := Value;
end;
// procedure TTLSettings.SetBBIOList(const Value: TList);
// begin
//   FBBIOList := Value;
//   SaveSymbolListToFile(BroadBasedOptionsFile, FBBIOList);
// end;

// ------------------------------------

procedure TTLSettings.SetDispWSHolding(const Value: Boolean);
begin
  FDispWSHolding := Value;
  IniFile.WriteBool(TRADELOG_OPTIONS, 'ShowWSHolding', FDispWSHolding);
end;


procedure TTLSettings.SetFeeBought(const Value: Boolean);
begin
  if FFeeBought <> Value then begin
    FFeeBought := Value;
    IniFile.WriteBool(TRADELOG_OPTIONS, 'FeeBought', FFeeBought);
  end;
end;


procedure TTLSettings.SetFeePerShare(const Value: Boolean);
begin
  if FFeePerShare <> Value then begin
    FFeePerShare := Value;
    IniFile.WriteBool(TRADELOG_OPTIONS, 'PerShare', FFeePerShare);
  end;
end;


procedure TTLSettings.SetFeeSold(const Value: Boolean);
begin
  if FFeeSold <> Value then begin
    FFeeSold := Value;
    IniFile.WriteBool(TRADELOG_OPTIONS, 'FeeSold', FFeeSold);
  end;
end;


procedure TTLSettings.SetSecFee(const Value: Double);
begin
  if FSecFee <> Value then begin
    FSecFee := Value;
    IniFile.WriteString(TRADELOG_OPTIONS, 'SECFee', FloatToStr(SecFee, Settings.UserFmt));
  end;
end;


procedure TTLSettings.SetGTTTaxPrep(const Value: String);
begin
  if FGTTTaxPrep <> Value then begin
    FGTTTaxPrep := Value;
    IniFile.WriteString(TRADELOG_SETUP, 'GTTTaxPrep', FGTTTaxPrep);
  end;
end;


procedure TTLSettings.SetIsEIN(const Value: Boolean);
begin
  if FIsEin <> Value then begin
    FIsEIN := Value;
    Inifile.WriteBool (TRADELOG_OPTIONS, 'IsEIN', FIsEIN);
  end;
end;


procedure TTLSettings.SetMainFormData(const Value: TMainFormData);
begin
  if FMainFormData <> Value then begin
    FMainFormData := Value;
    WriteMainFormData;
  end;
end;



procedure TTLSettings.SetRegCode(const Value: String);
begin
  if FRegCode <> Value then begin
    FRegCode := Trim(Value);
    IniFile.WriteString (TRADELOG_SETUP, 'RC4', Dencrypt(FRegCode + '|' + FVersion, ''));
  end;
end;


procedure TTLSettings.SetRegName(const Value: String);
begin
  if FRegName <> Value then begin
    FRegName := Value;
    IniFile.WriteString (TRADELOG_SETUP, 'RN', FRegName);
  end;
end;


procedure TTLSettings.SetReportPageData(const Value: TReportPageData);
begin
  FReportPageData := Value;
  WriteReportPage;
end;


procedure TTLSettings.SetSSN(const Value: String);
begin
  if FSSN <> Value then begin
    FSSN := Value;
    IniFile.WriteString (TRADELOG_OPTIONS, 'ss', dencrypt(FSSN,''));
  end;
end;


procedure TTLSettings.SetTLVer(const Value: String);
begin
  if (Value <> FVersion) then
    IniFile.WriteString(TRADELOG, 'tlv', dencrypt(FVersion, ''));
end;


procedure TTLSettings.SetUserBackupDate(const Value: Boolean);
begin
  FUserBackupDate := Value;
  IniFile.WriteBool(TRADELOG, 'UserBackupDate', FUserBackupDate);
end;


procedure TTLSettings.SetUserBackupDir(const Value: String);
begin
  FUserBackupDir := Value;
  if RightStr(FUserBackupDir, 1) = '\' then
    FUserBackupDir := LeftStr(FUserBackupDir, Length(FUserBackupDir) - 1);
  IniFile.WriteString(TRADELOG, 'UserBackupDir', FUserBackupDir);
end;


// ------------------------------------
// Settings Files
// ------------------------------------
procedure TTLSettings.VerifySettingsFiles;
var
  Success : Boolean;
begin
  try
    Success := False;
    if Not DirectoryExists(SettingsDir) then begin
    { So the settings folder does not exist in the Installation Location so
      let's look for it elsewhere and move it to the appropriate place.
      First look in the DataDirectory Location, if it's not there then look
      in the previous Tradelog standard location
        UserHome/MyDocuments/TradeLog/Settings.
      If it's not there then finally try and get the settings from the
      Internet Location.
    }
      //First create our new settings location
      ForceDirectories(SettingsDir);
      try
        //Try and move the files from the Install directory Settings
        Success := MoveSettingsFiles(InstallDir + DIR_SETTINGS);
        //Next let's try and move files from the current Data Directory
        if Not Success then
          Success := MoveSettingsFiles(DataDir + DIR_SETTINGS);
        //If that failed than let's try and move files from the old InstallDataDir default location
        if Not Success then
          Success := MoveSettingsFiles(MyDocumentsFolder + '\' + TRADELOG + DIR_SETTINGS);
      except
        //We do not want this to cause an exception in the application so if for some reason the files
        //cannot be moved then we will just attempt to create them with default values, in the initialize method
      end;
    end;
  finally
    // VerifySettingsFiles
  end;
end;


function TTLSettings.MoveSettingsFiles(FromDir : String) : Boolean;
var
  FileName : String;
begin
  // copy settings files in "FromDir" to current directory
  try
    Result := False;
    if DirectoryExists(FromDir) then begin
      FileName := FromDir + '\' + FILE_FUTURE_OPTIONS + EXT_CONFIG;
      if FileExists(FileName) then
        CopyFile(PWideChar(FileName), PWideChar(FutureOptionsFile), True);
      FileName := FromDir + '\' + FILE_STRATEGY_OPTIONS + EXT_CONFIG;
      if FileExists(FileName) then
        CopyFile(PWideChar(FileName), PWideChar(StrategyOptionsFile), True);
      FileName := FromDir + '\' + FILE_BROAD_BASED_OPTIONS + EXT_CONFIG;
      if FileExists(FileName) then
        CopyFile(PWideChar(FileName), PWideChar(BroadBasedOptionsFile), True);
      FileName := FromDir + '\' + FILE_CHART_CONFIG + EXT_CONFIG;
      if FileExists(FileName) then
        CopyFile(PWideChar(FileName), PWideChar(ChartConfigFile), True);
      Result := True;
    end;
  finally
    // MoveSettingsFiles
  end;
end;

procedure TTLSettings.SaveSettings;
begin
  try
    Settings.NewInstall := 1;
    // future: save a checksum to detect registry hacking
    WriteReportPage;
    WriteMainFormData;
    WriteLastOpenFiles;
    ChartDataList.SaveData;
    SaveFutureListToFile;
    SaveSymbolListToFile(BroadBasedOptionsFile, FBBIOList);
    SaveSymbolListToFile(ETFsFile, FETFsList);
    SaveSymbolListToFile(MutualFundFile, FMutualFundList);
  finally
    // SaveSettings
  end;
end;


// ------------------------------------
// Folders
// ------------------------------------
function TTLSettings.GetUndoDir: String;
begin
  Result := DataDir + DIR_UNDO;
end;

function TTLSettings.GetUpdateDir: String;
begin
  Result := FUserFolder + '\.' + TRADELOG + DIR_UPDATES;
end;

function TTLSettings.GetWindowsSpecialFolder(Folder : Integer): string;
var
  r: Bool;
  path: array[0..Max_Path] of Char;
begin
  r := ShGetSpecialFolderPath(0, path, Folder, False) ;
  if not r then
    Result := ''
  else
    Result := Path;
end;


// ------------------------------------
//
// ------------------------------------
function TTLSettings.GetWebSiteURL: String;
begin
  Result := WEB_SITE_URL;
end;

// ------------------------------------
// TLBBIOList
// ------------------------------------
function TLBBIOList.Add(BBIOItem: PBBIOItem) : Integer;
begin
  Result := inherited Add(BBIOItem);
end;

destructor TLBBIOList.Destroy;
var
  I : Integer;
begin
  for I := 0 to Count - 1 do
    FreeMem(Items[i]);
  inherited;
end;

function TLBBIOList.Get(Index: Integer): PBBIOItem;
begin
   Result := PBBIOItem(inherited Get(Index));
end;

function TLBBIOList.indexOf(Symbol: String): Integer;
var
  I : Integer;
  BBIOItem : PBBIOItem;
begin
  Result := -1;
  for I := 0 to Count - 1 do begin
    BBIOItem := Get(I);
    if POS(Symbol, (BBIOItem.Symbol + ' = '))=1 then begin
      Result := I;
      break;
    end;
  end;
end;

// ------------------------------------
// TLSymbolList
// ------------------------------------
function TLSymbolList.Add(SymbolItem: PSymbolItem) : Integer;
begin
  Result := inherited Add(SymbolItem);
end;

destructor TLSymbolList.Destroy;
var
  I : Integer;
begin
  for I := 0 to Count - 1 do
    FreeMem(Items[i]);
  inherited;
end;

function TLSymbolList.Get(Index: Integer): PSymbolItem;
begin
   Result := PSymbolItem(inherited Get(Index));
end;

function TLSymbolList.indexOf(Symbol: String): Integer;
var
  I : Integer;
  SymbolItem : PSymbolItem;
begin
  Result := -1;
  for I := 0 to Count - 1 do begin
    SymbolItem := Get(I);
    if SymbolItem.Symbol = Symbol then begin
      Result := I;
      break;
    end;
  end;
end;

// ------------------------------------
// TLETFList
// ------------------------------------
function TLETFList.Add(ETFItem: PETFItem) : Integer;
begin
  Result := inherited Add(ETFItem);
end;

destructor TLETFList.Destroy;
var
  I : Integer;
begin
  for I := 0 to Count - 1 do
    FreeMem(Items[i]);
  inherited;
end;

function TLETFList.Get(Index: Integer): PETFItem;
begin
   Result := PETFItem(inherited Get(Index));
end;

function TLETFList.indexOf(Symbol: String): Integer;
var
  I : Integer;
  ETFItem : PETFItem;
begin
  Result := -1;
  for I := 0 to Count - 1 do begin
    ETFItem := Get(I);
    if POS(Symbol, (ETFItem.Symbol + ' = '))=1 then begin
      Result := I;
      break;
    end;
  end;
end;

// ------------------------------------
// TMainFormData
// ------------------------------------
constructor TMainFormData.Create;
begin
  try
    Inherited Create;
    FStatus := -1;
    FTop := -1;
    FLeft := -1;
    FHeight := -1;
    FWidth := -1;
  finally
    // Create
  end;
end;

procedure TMainFormData.GetData(var MainForm: TForm);
begin
  try
    //If status is -1 then we have never saved these values before so just
    //let the main form open in the default way.
    if FStatus <> -1 then begin
      if FStatus = Integer(wsMaximized) then
        MainForm.WindowState := wsMaximized
      else begin
        MainForm.WindowState := wsNormal;
        MainForm.Top := FTop;
        MainForm.Left := FLeft;
        MainForm.Width := FWidth;
        MainForm.Height := FHeight;
      end;
    end;
  finally
    // GetData
  end;
end;

procedure TMainFormData.SetData(MainForm: TForm);
begin
  try
    if MainForm.WindowState = wsMaximized then
      FStatus := Integer(wsMaximized)
    else begin
      FStatus := Integer(wsNormal);
      FTop := MainForm.Top;
      FLeft := MainForm.Left;
      FWidth := MainForm.Width;
      FHeight := MainForm.Height;
    end;
  finally
    // SetData
  end;
end;


// ------------------------------------
// TChartData
// ------------------------------------
procedure TChartData.Assign(Source: TPersistent);
var
  C : TChartData;
  Time : Double;
begin
  try
    if Source is TChartData then begin
      C := TChartData(Source);
      ChartIntervals := C.ChartIntervals;
      ChartSeperator := C.ChartSeperator;
      for Time in C.ChartTimes do
        ChartTimes.Add(Time);
    end
    else
      Inherited;
  finally
    // Assign
  end;
end;

constructor TChartData.Create;
begin
  FChartTimes := TList<Double>.Create;
end;

destructor TChartData.Destroy;
begin
  FChartTimes.Free;
  inherited;
end;


// ------------------------------------
// TChartDataList
// ------------------------------------
constructor TChartDataList.create(FileName: String);
begin
  try
    inherited Create;
    FFileName := FileName;
    if Not FileExists(FFileName) then
      WriteDefaultChartConfigSection;
    FActiveSection := DEFAULT_CHART_SECTION;
    ReadConfigFile;
  finally
    //
  end;
end;

function TChartDataList.GetActiveChartData: TChartData;
begin
  if not TryGetValue(ActiveSection, Result) then
    raise EChartDataException.Create('Active Section is invalid: ' + ActiveSection);
end;


procedure TChartDataList.ReadConfigFile;
var
  IniFile : TIniFile;
  Sections : TStringList;
  Section : String;
  Data : TChartData;
  I: Integer;
  S : String;
  Fmt : TFormatSettings;
begin
  try
    IniFile := TIniFile.Create(FFileName);
    Fmt := GetInternalLocaleFmt;
    try
      Sections := TStringList.Create;
      try
        IniFile.ReadSections(Sections);
        for Section in Sections do begin
          Data := TChartData.Create;
          Data.ChartIntervals := IniFile.ReadInteger(Section, 'Intervals', 3);
          Data.ChartSeperator := Char(IniFile.ReadString(Section, 'Sep', '.')[1]);
          for I := 0 to 10 do begin
            S := IniFile.ReadString(Section, IntToStr(I), '0');
            Data.ChartTimes.Add(StrToFloat(S, Fmt));
          end;
          {Chop of TOS_ for the String List identifier}
          Add(Copy(Section, 5), Data);
        end;
      finally
        Sections.Free;
      end;
    finally
      IniFile.Free;
    end;
  finally
    // ReadConfigFile
  end;
end;

procedure TChartDataList.SaveData;
var
  Section : String;
  SectionName : String;
  IniFile : TIniFile;
  I : Integer;
  S : String;
begin
  try
    {Delete the file and rewrite the entire thing, just in case some sections were removed}
    SysUtils.DeleteFile(FFileName);
    IniFile := TIniFile.Create(FFileName);
    try
      for Section in Keys do begin
        SectionName := CHART_SECTION_PREFIX + Section;
        if IniFile.SectionExists(SectionName) then
          IniFile.EraseSection(SectionName);
        IniFile.WriteInteger(SectionName, 'Intervals', Items[Section].ChartIntervals);
        IniFile.WriteString(SectionName, 'Sep', Items[Section].ChartSeperator);
        for I := 0 to Items[Section].ChartIntervals do begin
          S := FloatToStr(Items[Section].ChartTimes[I], GetInternalLocaleFmt);
          IniFile.WriteString(SectionName, IntToStr(I), S);
        end;
      end;
    finally
      IniFile.Free;
    end;
  finally
    // SaveData
  end;
end;


procedure TChartDataList.WriteDefaultChartConfigSection;
var
  F : TextFile;
  IniFile : TIniFile;
  InternalFmt : TFormatSettings;
begin
  try
    IniFile := TIniFile.Create(FFileName);
    try
      InternalFmt := GetInternalLocaleFmt;
      IniFile.WriteInteger(CHART_SECTION_PREFIX + DEFAULT_CHART_SECTION, 'Intervals', 3);
      IniFile.WriteString(CHART_SECTION_PREFIX + DEFAULT_CHART_SECTION, 'Sep', '.');
      IniFile.WriteString(CHART_SECTION_PREFIX + DEFAULT_CHART_SECTION, '0', FloatToStr(StrToTime('16:30:00', InternalFmt), InternalFmt));
      IniFile.WriteString(CHART_SECTION_PREFIX + DEFAULT_CHART_SECTION, '1', FloatToStr(StrToTime('09:00:00', InternalFmt), InternalFmt));
      IniFile.WriteString(CHART_SECTION_PREFIX + DEFAULT_CHART_SECTION, '2', FloatToStr(StrToTime('11:00:00', InternalFmt), InternalFmt));
      IniFile.WriteString(CHART_SECTION_PREFIX + DEFAULT_CHART_SECTION, '3', FloatToStr(StrToTime('13:00:00', InternalFmt), InternalFmt));
    finally
      IniFile.Free;
    end;
  finally
    // WriteDefaultShartConfigSection
  end;
end;


procedure TChartDataList.SetActiveSection(const Value: String);
begin
  try
    if ContainsKey(Value) then
      FActiveSection := Value
    else
      raise EChartDataException.Create('Invalid Chart TOD Section Name: ' + Value + CR + 'Cannot set Active Section');
  finally
  end;
end;


Initialization
  Settings := TTLSettings.Create;


Finalization
  Settings.Free;


end.
