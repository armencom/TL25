unit TLFile;

interface

uses
  Classes, SysUtils, Generics.Collections, Generics.Defaults, Math, TLImportFilters, TLCommonLib,
  ClipBrd;

type
  ETLFileException = class(Exception);
  ETLFileCombineException = class(ETLFileException);
  ELTFileInvalidYearException = class(ETLFileException);
  ETLFileMultiAccountImportException = class(ETLFileException);
  ETLFileCombineConvertException = class(ETLFileCombineException);
  ETLFileCurrencyException = class(ETLFileCombineException);

  TProHeader = record
    regCode : string; // regCode of registered user
    regCodeAcct : string; // regCode of accountant
    taxFile : string; // ie "2014 John Q. Public"
    taxpayer : string; // ssn or ein
    canETY : integer; // 1 = yes
    TDFpassword : string; // password to open this TDF
    IsEIN : integer; // 1 = yes
    email : string; // user email for login/FastLink
  end;
  // NOTE: this is NOT the order of the fields in the TDF!
  // TDF layout is:
  // 0 headertype = -99 for ProHeader
  // 1 regCode
  // 2 taxFile
  // 3 SSN (encrypted)
  // 4 Accountant regCode
  // 5 canETY
  // 6 TDFpassword
  // 7 isEIN
  // 8 EmailAddress

  // Base Trade Record in TL ver 5 on
  TTrade = packed record
    it : integer; // Unique Record Number
    tr : integer; // Trade Number
    dt : string[20]; // Date
    tm : string[15]; // Time
    oc : string[1]; // Type or Month: O(pen), C(lose), M(TM), W(ash Deferral),
    // N (July), or Z (December)
    ls : string[6]; // Trade Type: L(ong) or S(hort)
    tk : string[40]; // Ticker Symbol
    sh : double; // Shares
    pr : double; // Price
    prf : string[20]; // Equity Type - Multiplier
    cm : double; // Commission
    am : double; // Amount
    no : string[200]; // Note (User supplied)
    strategy : string[50]; // Strategy
    m : string[20]; // Matched Tax Lots
    br : string[40]; // Broker (Combined files)
    opTk : string[30]; // Option Ticker
    abc : string[1]; // A, B, C the codes for the 8949
    HoldingDate : string[20];
  end;

  PTrade = ^TTrade;
  TTradeArray = array of TTrade;

  TTLTradeNum = class;

  // Base Trade Record in TL ver 9 on

  // ************************** IMPORTANT NOTE ********************************
  // Please read this before modifying this Object. Whenever you add fields to
  // the TTLTrade object, you must also modify the Import.pas ReadPaste method
  // to accomodate copying and pasting any new fields.
  TTLTrade = class(TPersistent)
    private
      FHasNegShares : boolean;
      bCalcOff : boolean;
      FID : integer;
      FTradeNum : integer;
      FDate : TDate;
      FTime : string;
      FOC : Char;
      FLS : Char;
      FTicker : string;
      FShares : double;
      FPrice : double;
      FTypeMult : string;
      FCommission : double;
      FAmount : double;
      FCost : double;
      FNote : string;
      FStrategy : string;
      FMatched : string;
      FBroker : integer;
      FOptionTicker : string;
      FABCCode : string;
      FEdited : boolean;
      FTLTradeNum : TTLTradeNum;
      FPL : double;
      FWSMatchedShares : double;
      FWSHoldingDate : string;
      FOFXTransID : string;
      procedure SetABCCode(const Value : string);
      procedure SetAmount(const Value : double);
      procedure SetBroker(const Value : integer);
      procedure SetCommission(const Value : double);
      procedure SetDate(const Value : TDate);
      procedure SetID(const Value : integer);
      procedure SetLS(const Value : Char);
      procedure SetMatched(const Value : string);
      procedure SetNote(const Value : string);
      procedure SetOC(const Value : Char);
      procedure SetOptionTicker(const Value : string);
      procedure SetPrice(const Value : double);
      procedure SetShares(const Value : double);
      procedure SetStrategy(const Value : string);
      procedure SetTicker(const Value : string);
      procedure SetTime(const Value : string);
      procedure SetTradeNum(const Value : integer);
      procedure SetTypeMult(const Value : string);
      procedure CalcPL;
      function GetMultiplier : double;
      function GetOpen : boolean;
      function GetDate : TDate;
      function GetPL : double;
      procedure SetPL(const Value : double);
    // function GetHasNegShares: Boolean;
    // procedure SetHasNegShares(const Value: boolean);
      function GetOpenShares : double;
      function GetIsStockType : boolean;
      function GetTradeType : string;
      function GetWSHoldingDate : TDate;
      procedure SetWSHoldingDate(const Value : TDate);
    public
      // ---------- Constructors ----------------
      constructor Create; overload;
      // Used by Import process. Creates a new TTLTrade Object from the old Record Format
      constructor Create(Trade : TTrade); overload;
      // Used to create one TTLTrade Object from another TTLTrade Object
      constructor Create(Trade : TTLTrade); overload;
      // ---------- general routines ------------
      procedure CalcAmount;
      function AsString : string;
      function AsStringList : TStringList;
      procedure Assign(Trade : TPersistent); override;
      // ---------- Object properties -----------
      property CalcOff : boolean read bCalcOff write bCalcOff default false;
      property ID : integer read FID write SetID; // Unique Record Number -->
      property TradeNum : integer read FTradeNum write SetTradeNum; // Trade Number -->
      property Date : TDate read GetDate write SetDate; // Date <-- -->
      property Time : string read FTime write SetTime; // Time      -->
      property oc : Char read FOC write SetOC; // Type: O(pen), C(lose), M(TM), W(ash Deferral)
      // or Month: N (July), or Z (December)                        -->
      property ls : Char read FLS write SetLS; // Trade Type: L(ong) or S(hort) -->
      property Ticker : string read FTicker write SetTicker; // Ticker Symbol -->
      property Shares : double read FShares write SetShares; //     -->
      // could be Shares or Option Contracts.
      property Price : double read FPrice write SetPrice; // Price  -->
      property TypeMult : string read FTypeMult write SetTypeMult; // -->
      // Equity Type + Multiplier
      property TradeType : string read GetTradeType; //             -->
      property Commission : double read FCommission write SetCommission; // Commission -->
      property Amount : double read FAmount write SetAmount; // Amount -->
      property Note : string read FNote write SetNote; // Note (User supplied) -->
      property strategy : string read FStrategy write SetStrategy; // Strategy -->
      property Matched : string read FMatched write SetMatched; // Matched Tax Lots -->
      property Broker : integer read FBroker write SetBroker; // Broker (Combined files) -->
      property OptionTicker : string read FOptionTicker write SetOptionTicker; // Option Ticker -->
      property ABCCode : string read FABCCode write SetABCCode; // A,B,C the codes for the 8949 -->
      property Edited : boolean read FEdited;
      property Multiplier : double read GetMultiplier; //          -->
      property PL : double read GetPL write SetPL; //          <-- -->
      property OFXTransID : string read FOFXTransID write FOFXTransID;
      property Open : boolean read GetOpen; //                 <--
      property OpenShares : double read GetOpenShares; //      <--
      property HasNegShares : boolean read FHasNegShares write FHasNegShares;
      property IsStockType : boolean read GetIsStockType; //   <--
      property WSMatchedShares : double read FWSMatchedShares write FWSMatchedShares;
      property WSHoldingDate : TDate read GetWSHoldingDate write SetWSHoldingDate; // <-- -->
    { ********** Read Important Note above before adding any additional fields to TTLTrade******* }
  end;

 // Date Comparer for Sort by Date.
  TTradeComparer = TComparer<TTLTrade>;

  // New Delphi Generics TList which allows casting of the type that the list will hold.
  // This list has all the functionality of the generic TList object but strongly types
  // the inbound and outbound values.
  TTradeList = class(TList<TTLTrade>)
    private
      FSortBy : string;
      function CompareDates(const Item1, Item2 : TTLTrade): integer;
      function CompareTime(const Item1, Item2 : TTLTrade): integer;
      function CompareItem(const Item1, Item2 : TTLTrade): integer;
      function CompareTrNumber(const Item1, Item2 : TTLTrade): integer;
      function CompareTickers(const Item1, Item2 : TTLTrade) : integer;
      function CompareLSDescending(const Item1, Item2 : TTLTrade) : integer;
      function CompareOCAscending(const Item1, Item2 : TTLTrade) : integer;
      function CompareOCDescending(const Item1, Item2 : TTLTrade) : integer;
      function CompareWashSales(const Item1, Item2 : TTLTrade) : integer;
      function CompareWashSalesDesc(const Item1, Item2 : TTLTrade): integer;
      function CompareBroker(const Item1, Item2 : TTLTrade) : integer;
    public
      constructor Create;
      procedure FreeAll;
      procedure SortByDate;
      procedure SortByOpenClose;
      procedure SortByTrNumber;
      procedure SortByTicker;
      procedure SortByTickerForMatching;
  end;

  TTLFile = class;

  // Enumerated type representing all the items on the End Of Year CheckList, This is save
  // in the header for each account and can be expanded just by adding another item to this
  // list, All the code surrounding will adapt to additional items without any change to TLFile.
  TCheckList = (clExpireOptions, clExerciseOptions, clOpenPositions, clReconcile1099);

  // --------------------------------------------------------
  // ordered vars to match file layout.
  // --------------------------------------------------------
  TTLFileHeader = class
    private
    // --- file header --------------------------
      FVersion : integer; // 1) -9 = file version.
      FPlaidAcctId : string; // 2) Plaid account id (prev 'TradeLog')
      FDate : string; // 3) Date the file was created.
      FTime : string; // 4) time the file was created
      FIra : boolean; // 5) this an IRA Account
      FBaseCurrencyLocale : integer; // 6) base Currency Locale
      FFileImportFormat : string; // 7) FileImportFormat (Ameritrade, Schwab etc.)
      FMutualFunds1099 : boolean; // 8) Are the next 3 reported on the 1099 from broker?
      FDrips1099 : boolean; // 9)
      FGrossSales1099 : string; // 10)
      FImportMethod : TTLImportMethod; // 11) default import Mehtod (-1 if none).
      FSLConvert : boolean; // 12) Boolean 1=True / 0=false.
      // 13) credentials ------
      FOFXAccount : string;
      FOFXUserName : string;
      FOFXPassword : string;
      // ----------------------
      FOptions1099 : boolean; // 14)
      FTaxYear : string; // 15)
      FBrokerID : integer; // 16) just the grid tab number
      FAccountName : string; // 17)
      FMTM : boolean; // 18)
      FETFETN1099 : boolean; // 19)
      FCostBasis1099ST : string; // 20)
      FSalesAdjOptions1099 : boolean; // 21)
      FCostBasis1099LT : string; // 22)
      FCommission : double; // 23)
      FAutoAssignShorts : boolean; // 24)
      FMTMLastYear : boolean; // 25)
      FMTMForFutures : boolean; // 26)
      FAutoAssignShortsOptions : boolean; // 27)
      FCheckListItems : string; // 28) this is a bit-mapped string
      FYearEndDone : boolean; // 29)
      FNo1099 : boolean; // 30)
      FShortOptGL : boolean; // 31)
      FOptions2013 : boolean; // 32)
      // ----------------------------------------
      FFileLocale : string;
      // InternalLocale, Set to -1 once we are in a newer version 8 file. Again probably not needed
      FParent : TTLFile;
      FImportFilter : TTLImportFilter;
      // --- Sub-PROPERTIES of FImportFilter: ---
      // BrokerHasTimeOfDay: boolean;
      // SLConvert: Boolean;
      // AssignShortBuy: Boolean;
      // AutoAssignShorts: Boolean;
      // AutoAssignShortsOptions: Boolean;
      // BaseCurrLCID: integer;
      // BrokerCode : string;
      // CurrencySymbol: string;
      // CurrencyDesc : String;
      // ListText: string;
      // FilterName: string;
      // InstructPage: string;
      // ImportFunction : String;
      // ImportMethod : integer;
      // FastLinkable : Boolean;
      // SupportsCommission : Boolean;
      // SupportsFlexibleCurrency : Boolean;
      // SupportsFlexibleAssignment : Boolean;
      // ImportFileExtension : String;
    // OFXConnect : Boolean;
    // OFXFile : Boolean;
    // OFXFIID : String;
    // OFXFIOrg : String;
    // OFXBrokerID : String;
    // OFXURL : String;
      // OFXMonths : integer;
      // OFXMaxMonths : integer;
    // OFXDescOrder : Boolean;
    // OFXClass : String;
      // FixShortsOOOrder : Boolean;
      // ForceMatchStocks : Boolean;
      // ForceMatchOptions : Boolean;
      // ForceMatchFutures : Boolean;
      // ForceMatchCurrencies : Boolean;
      FAccountNameChanged : boolean;
      // ----------------------------------------
      procedure ProcessHeaderLine(HeaderLine : string; pTaxYear : string; pBrokerID : integer;
        BrokerOverride : boolean = false);
      function GetFileHeaderRow : string;
      procedure SetBaseCurrencyLocale(const Value : integer);
      procedure SetImportMethod(const Value : TTLImportMethod);
      procedure SetFileImportFormat(const Value : string);
      procedure SetCommission(const Value : double);
      function GetAutoAssignShorts : boolean;
      procedure SetAutoAssignShorts(const Value : boolean);
      function GetAutoAssignShortsOptions : boolean;
      procedure SetAutoAssignShortsOptions(const Value : boolean);
      function GetIsUsCurrency : boolean;
      function GetAccountName : string;
      procedure SetAccountName(const Value : string);
      function GetMTMLastYear : boolean;
      procedure SetMTM(const Value : boolean);
      function GetCheckListItem(Item : TCheckList): boolean;
      procedure SetCheckListItem(Item : TCheckList; const Value : boolean);
      function GetCheckListComplete : boolean;
      function GetBeforeCheckList : boolean;
      function EncodedPassword : string;
    public
      constructor Create(Parent : TTLFile); overload;
      constructor Create(Parent : TTLFile; HeaderLine : string; pTaxYear : string;
        pBrokerID : integer; BrokerOverride : boolean = false); overload;
      constructor CreateNew(Parent : TTLFile; FileImportFormat : string;
        ImportMethod : TTLImportMethod; TaxYear : string; BaseCurrencyLocale : integer;
        IraAcct : boolean; MTM : boolean; SLConvert : boolean; Commission : double = 0);
      procedure ConvertImportMethod(Value : integer);
      procedure UpdateImportFilter;
      procedure ResetCheckList;
      // ----------------------------------------
      property Version : integer read FVersion;
      property PlaidAcctId : string read FPlaidAcctId write FPlaidAcctId; // for BC
      property Date : string read FDate;
      property Time : string read FTime;
      property BaseCurrencyLocale : integer read FBaseCurrencyLocale write SetBaseCurrencyLocale;
      property IsUSCurrency : boolean read GetIsUsCurrency;
      property FileImportFormat : string read FFileImportFormat write SetFileImportFormat; // for Import
      property FileLocale : string read FFileLocale;
      property ImportMethod : TTLImportMethod read FImportMethod write SetImportMethod; // for Import
      property SLConvert : boolean read FSLConvert write FSLConvert;
      property Ira : boolean read FIra write FIra;
      property MTM : boolean read FMTM write SetMTM;
      property MTMLastYear : boolean read GetMTMLastYear write FMTMLastYear;
      property MutualFunds1099 : boolean read FMutualFunds1099 write FMutualFunds1099;
      property Drips1099 : boolean read FDrips1099 write FDrips1099;
      property Options1099 : boolean read FOptions1099 write FOptions1099;
      property ShortOptGL : boolean read FShortOptGL write FShortOptGL;
      property Options2013 : boolean read FOptions2013 write FOptions2013;
      property SalesAdjOptions1099 : boolean read FSalesAdjOptions1099 write FSalesAdjOptions1099;
      property ETFETN1099 : boolean read FETFETN1099 write FETFETN1099;
      property No1099 : boolean read FNo1099 write FNo1099;
      property GrossSales1099 : string read FGrossSales1099 write FGrossSales1099;
      property CostBasis1099ST : string read FCostBasis1099ST write FCostBasis1099ST;
      property CostBasis1099LT : string read FCostBasis1099LT write FCostBasis1099LT;
      property BrokerID : integer read FBrokerID write FBrokerID;
      property OFXPassword : string read FOFXPassword write FOFXPassword; // for IB only
      property URLPassword : string read EncodedPassword; // not used
      property OFXUserName : string read FOFXUserName write FOFXUserName; // for BC and IB
      property OFXAccount : string read FOFXAccount write FOFXAccount; // account number
      property TaxYear : string read FTaxYear write FTaxYear;
      property AccountName : string read GetAccountName write SetAccountName; // for Tab caption
      property FileHeaderRow : string read GetFileHeaderRow;
      property ImportFilter : TTLImportFilter read FImportFilter; // the Import Object
      property Commission : double read FCommission write SetCommission;
      property AutoAssignShorts : boolean read GetAutoAssignShorts write SetAutoAssignShorts;
      property AutoAssignShortsOptions : boolean read GetAutoAssignShortsOptions
        write SetAutoAssignShortsOptions;
      // ----------------------------------------
      property Parent : TTLFile read FParent;
      property AccountNameChanged : boolean read FAccountNameChanged;
      property MTMForFutures : boolean read FMTMForFutures write FMTMForFutures;
      property CheckListItem[Item : TCheckList] : boolean read GetCheckListItem
        write SetCheckListItem;
      property CheckListComplete : boolean read GetCheckListComplete;
      property BeforeCheckList : boolean read GetBeforeCheckList;
      property YearEndDone : boolean read FYearEndDone write FYearEndDone;
  end;

  TTLFileHeaders = class(TObjectList<TTLFileHeader>)
    private
      function GetNextBrokerID : integer;
    public
      property NextBrokerID : integer read GetNextBrokerID;
  end;


  TTLTradeNumList = class;

  TTLTradeNum = class(TTradeList)
    private
      FHasNegShares : boolean;
      FParent : TTLTradeNumList;
      function GetLS : Char;
      function GetShares : double;
      function GetWShares : double;
      function GetTicker : string;
      function GetTradeNum : integer;
      function GetMatched : string;
      function GetComplete : boolean;
      function GetWashSalesOnly : boolean;
    // function GetHasNegShares: Boolean;
    // procedure SetHasNegShares(const Value: Boolean);
      function GetTypeMult : string;
      function GetDate : TDate;
      function GetAmount : double;
      function GetAveragePrice : double;
      function GetOptionTicker : string;
      function GetMultiplier : double;
      function GetLastDate : TDate;
      function GetSharesAsOf(AsOfDate : TDate): double;
      function GetAmountAsOf(AsOfDate : TDate): double;
      function GetAveragePriceAsOf(AsOfDate : TDate): double;
      function GetBrokerID : integer;
      function GetSection481OK : boolean;
      function GetOpeningMTMRecord : TTLTrade;
      function GetTradeType : string;
      function GetHighID : integer;
      function GetIsOpenOptionInTaxYear : boolean;
    public
      constructor Create; overload;
      function Add(Value : TTLTrade; CalcPL : boolean = true): integer;
      procedure UpdateSection481(Price : double);
      procedure TransferOpenPosition(BrokerID : integer; NewTradeNum : integer;
        var ORecDatesList : TList<double>);
      property Parent : TTLTradeNumList read FParent;
      property TradeNum : integer read GetTradeNum;
      property Ticker : string read GetTicker;
      property ls : Char read GetLS;
      property Shares : double read GetShares;
      property WShares : double read GetWShares;
      property SharesAsOf[AsOfDate : TDate] : double read GetSharesAsOf;
      property Matched : string read GetMatched;
      property Complete : boolean read GetComplete;
      property HasNegShares : boolean read FHasNegShares write FHasNegShares;
      property TypeMult : string read GetTypeMult;
      property Date : TDate read GetDate;
      property LastDate : TDate read GetLastDate;
      property Amount : double read GetAmount;
      property AmountAsOf[AsOfDate : TDate] : double read GetAmountAsOf;
      property AveragePrice : double read GetAveragePrice;
      property AveragePriceAsOf[AsOfDate : TDate] : double read GetAveragePriceAsOf;
      property OptionTicker : string read GetOptionTicker;
      property Multiplier : double read GetMultiplier;
      property TradeType : string read GetTradeType;
      property WashSalesOnly : boolean read GetWashSalesOnly;
      property BrokerID : integer read GetBrokerID;
      property Section481OK : boolean read GetSection481OK;
      property OpeningMTMRecord : TTLTrade read GetOpeningMTMRecord;
      property HighID : integer read GetHighID;
      property IsOpenOptionInTaxYear : boolean read GetIsOpenOptionInTaxYear;
  end;

// FClosedTradeNums = class(TObjectList<TTLTradeNum>)

  TTLTradeNumList = class(TObjectList<TTLTradeNum>)
    private
      FParent : TTLFile;
      FImporting : boolean;
      FNextTradeNum : integer;
      FClosedTradeNums : TTLTradeNumList; // MB - Could cause problems!
      function GetNextTradeNum : integer;
      procedure SetNextTradeNum(const Value : integer);
      function GetOpenSharesTotal : double;
    // Match just the trades passed in
      function DoMatch(Trades : TTradeList; ForceMatch : boolean = false;
        FixTradesOOOrder : boolean = false) : TTradeList; overload;
      function GetOpenOptionsExist : boolean;
    public
      constructor Create(Parent : TTLFile); overload;
      constructor Create(Parent : TTLFile; OwnsObjects : boolean); overload;
      destructor Destroy; override;
      // Can't override Add function, but we will call inherited one
      // after we set the parent Property to the list we are being added to.
      function Add(Value : TTLTradeNum) : integer;
      // Initialize List without doing any matching
      // This method is used to add TradeNum records to the list
      // without actually doing any matching
      procedure Initialize;
      // This method is used to add a trade and match it to existing trades
      procedure AddTrade(Trade : TTLTrade; ForceMatch : boolean = false;
        FixTradesOOOrder : boolean = false);
      // Remove a trade from the list
      procedure DeleteTrade(Trade : TTLTrade);
      // Match the entire file
      function MatchAll(ForceMatch : boolean = false; FixTradesOOOrder : boolean = false)
        : TTradeList;
      // Match just the trades passed in
      function Match(Trades : TTradeList; ForceMatch : boolean = false;
        FixTradesOOOrder : boolean = false) : TTradeList; overload;
      // Match all trades for a Comma seperated list of tickers
      function Match(Tickers : TStringList; ForceMatch : boolean = false;
        FixTradesOOOrder : boolean = false) : TTradeList; overload;
      // Find a trade number object based on a trade num,
      // look in both the open trades and closing trades
      function FindTradeNum(Trade : TTLTrade) : TTLTradeNum; overload;
      function FindTradeNum(TradeNum : integer) : TTLTradeNum; overload;
      // Get Next Trade Num and increment internal counter
      property NextTradeNum : integer read GetNextTradeNum write SetNextTradeNum;
      // When we are importing this can be set so that the AssignShorts behavior is used
      property Importing : boolean read FImporting write FImporting;
       // If a Trade Number is complete, then it is added to this list.
       // we keep the open Trade numbers list as short as possible for performance purposes.
      property ClosedTradeNums : TTLTradeNumList read FClosedTradeNums;
      property OpenSharesTotal : double read GetOpenSharesTotal;
      property Parent : TTLFile read FParent;
      // If Open Options Exist in the current tax year this will return true.
      property OpenOptionsExist : boolean read GetOpenOptionsExist;
  end;

  TTLTradeNumComparer = TComparer<TTLTradeNum>;


  TTLFile = class
    private
      FTrades : TTradeList;
      FTradesSaved : TTradeList;
      FTradeNums : TTLTradeNumList;
      FTLFileHeaders : TTLFileHeaders;
      FFileName : string;
      FNoTimeInData : boolean;
      FMultiplierIsZero : boolean;
      FCurrentBroker : integer;
      FCurrentHeader : TTLFileHeader;
      FFileNeedsSaving : boolean;
      FStatusCallBack : TLBasicStatusCallBack;
      FBrokerFiles : TStringList;
      FShowStatus : boolean;
      FFileCleaned : boolean;
      FLastID : integer;
      FNegShareTrades : TTradeList;
      FCancelledTrades : TTradeList;
      FMisMatchedTrades : TTradeList;
      FMisMatchedLS : TTradeList;
      FZeroOrLessTrades : TTradeList;
      constructor Create; overload;
      //
      procedure ReadFile(FileName : string; BrokerOverride : boolean = false;
        LastTrNumber : integer = 0);
      function ReadHeaderLine(Value : string; pTaxYear : string;
        BrokerOverride : boolean = false): integer;
      function ReadDataLine(Line : string; Fmt : TFormatSettings; pBrokerID : integer;
        BrokerOverride : boolean = false; LastTrNumber : integer = 0) : TTLTrade;
      function GetCount : integer;
      function GetMultiBrokerFile : boolean;
      function GetBrokerIDByName(BrokerName : string): integer;
      function GetTrade(Index : integer): TTLTrade;
      function GetFileHeader(BrokerID : integer): TTLFileHeader;
      function GetFileHeaderIndex(BrokerID : integer): integer;
      function GetBackwardCompatibleLocaleSettings(FileLocale : string): TFormatSettings;
      procedure SetCurrentBroker(const Value : integer);
      function GetCurrentHeader : TTLFileHeader;
      function GetCostBasis1099STAllBrokers : string;
      function GetGrossSales1099AllBrokers : string;
      function GetCostBasis1099LTAllBrokers : string;
      procedure DoStatus(Msg : string);
      function ChangeMutEtfRec(Ticker, TypeMult : string) : string;
      function GetHasMTMThisYear : boolean;
      function GetHasMTMLastYear : boolean;
      function GetMultiplierAsDouble(Mult : string; CurrencySmbl : string): double;
      function GetNextMatchNumber : integer;
      function GetNextExerciseTag : string;
      function GetNextID : integer;
      // Sets ID, TradeNum, Broker if not already set
      procedure InitializeTrade(var Trade : TTLTrade);
      function GetHasNegShares : boolean;
      function GetRecordLimitExceeded : boolean;
      function GetOpenPositions(AsOfDate : TDate): TTLTradeNumList;
      function GetLastDateImported : TDate;
      function GetHasOptions : boolean;
      function GetOpenTrades : TTradeList;
      function GetTaxYear : integer;
      function GetUSCurrency : boolean;
      function GetLastTaxYear : integer;
      function GetNextTaxYear : integer;
      function GetMTMStatus(Year : integer) : boolean;
      function GetCurrentAcctType : string;
      function GetHasAccountType(AccountType : TTLAccountType): boolean;
      function GetHasCTNType : boolean;
      function GetHasVTNType : boolean;
      function GetIsAllMTM(): boolean;
      function GetCurrentAcctHasRecords : boolean;
      function GetCurrentAcctName : string;
      function GetMTMClosedPositions(AsOfDate : TDate): TTLTradeNumList;
      function GetCancelledTrades : TTradeList;
      function GetHasCancelledTrades : boolean;
      function GetNegShareTrades : TTradeList;
      function GetHasNegShareTrades : boolean;
      function GetHasInvalidOptionTickers : boolean;
// function GetHasMisMatchedOptionTypes: Boolean;
      function GetHasMisMatchedTypes : boolean;
      function GetHasMisMatchedLS : boolean;
      function GetMisMatchedTrades : TTradeList;
      function GetMisMatchedLS : TTradeList;
      function GetZeroOrLessTrades : TTradeList;
      function GetHasZeroOrLessTrades : boolean;
      procedure VerifyTrade(Trade : TTLTrade);
      procedure calcProfit;
      function GetCurrentBaseCurrencyFmt : TFormatSettings;
      function GetAllCheckListsComplete : boolean;
      function GetBeforeCheckList : boolean;
      function GetHasAnyTradeIssues : boolean;
      procedure SetYearEndDone(const Value : boolean);
      function GetYearEndDone : boolean;
      function GetEarliestDate : TDate;
      function GetCheckListOn : boolean;
    public
      destructor Destroy; override;
      procedure CreateLists(Revert : boolean = false);
      procedure getNegShareList;
      procedure SetOFXCredentials(BrokerID : integer; Account, UserName, Password : string);
      constructor OpenFile(FileName : string; StatusCallBack : TLBasicStatusCallBack = nil);
      constructor CreateNextYear(AFileName : string; NewTaxYear : string; Headers : TTLFileHeaders;
        StatusCallBack : TLBasicStatusCallBack = nil);
      constructor CreateNew(FileName : string; FileImportFormat : string;
        ImportMethod : TTLImportMethod; TaxYear : string; BaseCurrencyLocale : integer;
        IraAcct : boolean; MTM : boolean; SLConvert : boolean;
        StatusCallBack : TLBasicStatusCallBack = nil; Commission : double = 0);
      function VerifyEOYCheckList(ForceAllOn : boolean = false) : boolean;
      // split out CombineFile as separate function - 2016-05-03 MB
      function CombineFile(FileName : string) : boolean;
      function AddFile(FileName : string) : boolean;
      procedure AddAccount(Header : TTLFileHeader; BrokerOverride : boolean = false);
      procedure DeleteAccount; overload;
      procedure DeleteAccount(BrokerID : integer); overload;
      procedure DeleteAllAccountsByType(AccountType : TTLAccountType);
      procedure ClearAll(SaveFile : boolean = true);
      function SaveFile(ForceOverwrite : boolean = false; bClear : boolean = false) : integer;
      function SaveFileAs(FileName :string; FilePath :string = ''; TaxYear : integer = 0;
        ForceOverwrite : boolean = false; bClear : boolean = false) : integer;
      function AddTrade(Trade : TTLTrade; Initializing : boolean = false) : integer;
      procedure UpdateTrade(Trade : TTLTrade);
      function DeleteTrade(Trade : TTLTrade; resetChkLst : boolean = true) : boolean;
      function InsertTrade(RecNum : integer; Trade : TTLTrade) : integer;
      procedure SortByDate;
      procedure SortByTrNumber;
      procedure SortByOpenClose;
      procedure SortByTicker;
      function VerifyUniqueAccountName(const Value : string; BrokerID : integer) : boolean;
      // Search the entire file for an associated Open trade for an M Trade
      function FindAssociatedOpenTrade(MTMTrade : TTLTrade) : TTLTrade;
      // Removes MTM Records for Current Broker
      function RemoveSection481 : boolean;
      // Just Renumber the Item Field
      procedure RenumberItemField;
      // Just Renumber the Trades
      procedure RenumberTrades;
      // Match the trades for all account,
      // then reogranize the file by renumbering
      // then sorting by Trade Number
      procedure MatchAndReorganizeAllAccounts(FixTradesOOOrder : boolean = false;
        RenumberID : boolean = false);
      // Match the trades by calling MatchAll,
      // then reogranize the file by renumbering
      // then sort by Trade Number
      procedure MatchAndReorganize(FixTradesOOOrder : boolean = false;
        RenumberID : boolean = false);
      // Match the Entire Account
      function MatchAll(ForceMatch : boolean = false; FixTradesOOOrder : boolean = false)
        : TTradeList;
      // Match just the trades passed in
      function Match(Trades : TTradeList; ForceMatch : boolean = false;
        FixTradesOOOrder : boolean = false) : TTradeList; overload;
      // Match all trades for a Comma seperated list of tickers
      function Match(Tickers : TStringList; ForceMatch : boolean = false;
        FixTradesOOOrder : boolean = false) : TTradeList; overload;
      // Match all trades for a ticker
      function Match(Ticker : string; ForceMatch : boolean = false;
        FixTradesOOOrder : boolean = false) : TTradeList; overload;
      function SaveTList(var pTList : TList<TTLTrade>) : integer;
      // Renumber and Reorganize the file
      // by Trade Number, RenumberID if param is true
      procedure Reorganize(RenumberID : boolean = true);
      // Refresh the file from the disk
      procedure Refresh;
      procedure RefreshOpens;
      procedure Revert;
      procedure CloneList;
      function GetInvalidOptionTickers : string;
      function GetOptionTypeDiscrepancies : string; // new 2016-09-30 MB
      function UpdateMultiplierIsZero : boolean;
      function MakeTradeRowLine(TradeRow : TTLTrade): string;
      function MakeTradeRowHeadings : string;
      procedure ClearOPRASymbols;
      procedure MoveRecord(StartIndex, EndIndex : integer);
      // This method will look at all the Open TradeNums and if by chance they
      // have been closed, will move them to the closed positions list
      procedure VerifyOpenPositions;
      // Loop through entire file and verify type are correct.
      procedure applyChangesToTypeMults(bAdjContr : boolean = false);
      procedure UpdateTypeMultipliers;
      procedure AddToClipStr(Trade : TTLTrade; ColsToSkip : TList<integer>;
        var ClipStringList : TStringList);
      property BrokerIDByName[BrokerName : string]: integer read GetBrokerIDByName;
      property Count : integer read GetCount;
      property FileHeaders : TTLFileHeaders read FTLFileHeaders;
      property FileHeader[BrokerID : integer]: TTLFileHeader read GetFileHeader;
      property FileHeaderIndex[BrokerID : integer] : integer read GetFileHeaderIndex;
      property Trade[index : integer]: TTLTrade read GetTrade; default;
      property TradeList : TTradeList read FTrades;
      property FileName : string read FFileName write FFileName;
      property NoTimeInData : boolean read FNoTimeInData;
      property MultiBrokerFile : boolean read GetMultiBrokerFile;
      property MultiplierIsZero : boolean read FMultiplierIsZero;
      property CurrentBrokerID : integer read FCurrentBroker write SetCurrentBroker;
      property CurrentAccount : TTLFileHeader read GetCurrentHeader;
      property CurrentBaseCurrencyFmt : TFormatSettings read GetCurrentBaseCurrencyFmt;
      property FileConverted : boolean read FFileNeedsSaving;
      property FileCleaned : boolean read FFileCleaned;
      property GrossSales1099AllBrokers : string read GetGrossSales1099AllBrokers;
      property CostBasis1099STAllBrokers : string read GetCostBasis1099STAllBrokers;
      property CostBasis1099LTAllBrokers : string read GetCostBasis1099LTAllBrokers;
      property StatusCallBack : TLBasicStatusCallBack read FStatusCallBack write FStatusCallBack;
      property ShowStatus : boolean read FShowStatus write FShowStatus;
      property HasMTMThisYear : boolean read GetHasMTMThisYear;
      property HasMTMLastYear : boolean read GetHasMTMLastYear;
      property TradeNums : TTLTradeNumList read FTradeNums;
      property NegShareTradeNums : TTradeList read FNegShareTrades;
      property NextMatchNumber : integer read GetNextMatchNumber;
      property NextExerciseTag : string read GetNextExerciseTag;
      property NextID : integer read GetNextID;
      property HasNegShares : boolean read GetHasNegShareTrades;
      property HasCancelledTrades : boolean read GetHasCancelledTrades;
      property HasInvalidOptionTickers : boolean read GetHasInvalidOptionTickers;
// property HasMisMatchedOptionTypes : Boolean read GetHasMisMatchedOptionTypes;
      property HasMisMatchedTypes : boolean read GetHasMisMatchedTypes;
      property HasMisMatchedLS : boolean read GetHasMisMatchedLS;
      property HasZeroOrLessTrades : boolean read GetHasZeroOrLessTrades;
      property HasAnyTradeIssues : boolean read GetHasAnyTradeIssues;
      property LastDateImported : TDate read GetLastDateImported;
      property EarliestDate : TDate read GetEarliestDate;
      property HasOptions : boolean read GetHasOptions;
      property RecordLimitExceeded : boolean read GetRecordLimitExceeded;
      property YearEndDone : boolean read GetYearEndDone write SetYearEndDone;
      property OpenPositions[AsOfDate : TDate] : TTLTradeNumList read GetOpenPositions;
      property MTMClosedPositions[AsOfDate : TDate] : TTLTradeNumList read GetMTMClosedPositions;
      property OpenTrades : TTradeList read GetOpenTrades;
      property TaxYear : integer read GetTaxYear;
      property LastTaxYear : integer read GetLastTaxYear;
      property NextTaxYear : integer read GetNextTaxYear;
      property IsUSCurrency : boolean read GetUSCurrency;
      property CurrentAcctType : string read GetCurrentAcctType;
      property CurrentAcctHasRecords : boolean read GetCurrentAcctHasRecords;
      property CurrentAcctName : string read GetCurrentAcctName;
      property HasAccountType[AccountType : TTLAccountType] : boolean read GetHasAccountType;
      property HasCTNType : boolean read GetHasCTNType;
      property HasVTNType : boolean read GetHasVTNType;
      property IsAllMTM : boolean read GetIsAllMTM;
      property NegShareTrades : TTradeList read GetNegShareTrades;
      property CancelledTrades : TTradeList read GetCancelledTrades;
      property MisMatchedTrades : TTradeList read GetMisMatchedTrades;
      property MisMatchedLS : TTradeList read GetMisMatchedLS;
      property ZeroOrLessTrades : TTradeList read GetZeroOrLessTrades;
      property FileNeedsSaving : boolean read FFileNeedsSaving;
      property AllCheckListsComplete : boolean read GetAllCheckListsComplete;
      property BeforeCheckList : boolean read GetBeforeCheckList;
      property CheckListOn : boolean read GetCheckListOn;
  end;

  TTLFiles = TList<TTLFile>;


// NOTE: added '0' for names - 2016-05-11 MB
const
  validCharacters : set of Char = ['A' .. 'z', '1' .. '9', '0', '&', '.', ' ', '''', '-'];

var
  TradeLogFile : TTLFile;
  ProHeader : TProHeader; // used to store the pro file header line data
  TempProHdr : TProHeader; // 2017-03-10 MB - use to test files before we load them
  // Imp Trades list used mainly in Import but also other places
  ImpTrades : TTradeArray;
  glEditListItems : TList<integer>;
  glEditListTicks : TStringList;
  ETYinProgress : boolean = false; // only true during ETY - 2016-07-12 MB

// Functions specific to Files
function VerifyV5OrGreaterData(FileName : string): boolean;
function GetDataVersion(FileName : string): integer;
function IsValidFileName(const FileName : string): boolean;
function ReformatInvalidFileName(FileName : string): string;
procedure initProHeader(fName :string);
procedure getProHeader(FileName : string);
procedure clearProHeader;
procedure ClearTempProHdr; // 2017-04-03 MB - made public so OpenTradeLogFile can call it.

implementation

uses
  Forms, Dialogs, Controls, StrUtils, IOUtils, //
  TLSettings, TLDatabase, TLLogging, //
  FuncProc, Import, AccountSetup, GlobalVariables; //

const
  TRADE_LOG = 'TradeLog';
  CODE_SITE_CATEGORY = 'TLFile';
  CODE_SITE_DETAIL_CATEGORY = 'TLFile-Detail';

var
  bFoundBlankType : boolean;
  NeedToSave : boolean;


// ----------------------------------------
// NEW 2019-01-24 MB - support for reading
// SSN/EIN either encrypted or not
// ----------------------------------------
function ReadSSN(s : string) : string;
var
  sFlag : string;
begin
  sFlag := dbGetFlag('bSSNencrypted');
  if (sFlag = 'T') then
    result := DecryptStr(s)
  else
    result := s;
end;

function GetTDFFlag(s : string) : boolean;
var
  sFlag : string;
begin
  sFlag := dbGetFlag(s);
  if (sFlag = 'F') then
    result := false
  else
    result := true; // this is the default
end;

// ----------------------------------------
// NEW 2016-12-20 MB - Allows TradeLog to
// support special characters in passwords
// ----------------------------------------
function TTLFileHeader.EncodedPassword : string;
var
  i, n : integer;
  s : string;
begin
  result := '';
  s := FOFXPassword;
  // URL encoding replaces unsafe ASCII characters with a "%" followed by two hexadecimal digits.
  // spc %20
  // !  %21
  // "  %22
  // #  %23
  // $  %24
  // %  %25
  // &  %26
  // '  %27
  // (  %28
  // )  %29
  // *  %2A
  // +  %2B
  // ,  %2C
  // -  %2D
  // .  %2E
  // /  %2F
  // URLs cannot contain spaces.
  // URL encoding normally replaces a space with a plus (+) sign or with %20.
  n := length(s);
  for i := 1 to n do begin
    if s[i] = ' ' then
      result := result + '%20'
    else if s[i] = '!' then
      result := result + '%21'
    else if s[i] = '"' then
      result := result + '%22'
    else if s[i] = '#' then
      result := result + '%23'
    else if s[i] = '$' then
      result := result + '%24'
    else if s[i] = '%' then
      result := result + '%25'
    else if s[i] = '&' then
      result := result + '%26'
    else if s[i] = '@' then
      result := result + '%40'
    else if not(s[i] in ['A' .. 'Z', 'a' .. 'z', '0', '1' .. '9', '-', '_', '~', '.']) then
      result := result + '%' + inttohex(ord(s[i]), 2)
    else
      result := result + s[i];
  end;
end;


// ----------------------------------------------
// Initialize ProHeader (for newly converted file only)
procedure initProHeader(fName :string);
var
  sEmail : string;
begin
  try
    // Pro User ONLY sets regCodeAcct, NOT regCode
    if ProVer then begin
      ProHeader.regCodeAcct := Settings.regCode;
// ProHeader.regCodeAcct := Settings.UserEmail; // 2022-11-27 MB - is this better?
    end
    else if not superUser then begin
      ProHeader.regCode := Settings.regCode;
      ProHeader.email := Settings.UserEmail;
    end;
    // must extract taxpayer name from fName.
    // format of fName: 'taxyear firstname lastname'
    if (fName[5] = ' ') and isnumber(leftstr(fName, 4)) then
      ProHeader.taxFile := copy(fName, 6)
    else
      ProHeader.taxFile := fName;
//    ProHeader.taxpayer := Settings.SSN;
    ProHeader.canETY := 0;
    ProHeader.TDFpassword := '';
//    if Settings.IsEIN then
//      ProHeader.IsEIN := 1
//    else
//      ProHeader.IsEIN := 0;
    sEmail := Settings.UserEmail;
    if messagedlg('We have your email address on file as' + CR //
      + CR + sEmail + CR //
      + CR + 'Is this correct?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      ProHeader.email := sEmail
    else
      ProHeader.email := inputbox('Update Email Address',
        'Please enter the correct email address:', sEmail);
  except
    if SuperUser then sm('error in initProHeader');
  end;
end;

procedure clearProHeader;
begin
  try
    ProHeader.regCodeAcct := '';
    ProHeader.regCode := '';
    ProHeader.taxFile := '';
    ProHeader.taxpayer := '';
    ProHeader.canETY := 0;
    ProHeader.TDFpassword := '';
    ProHeader.IsEIN := 0;
    ProHeader.email := '';
  except
    if SuperUser then sm('error in clearProHeader');
  end;
end;


function IsValidFileName(const FileName : string): boolean;
var
  c : Char;
begin
  try
    for c in FileName do begin
      result := CharInSet(c, validCharacters);
      if not result then
        break;
    end;
  except
    if SuperUser then sm('error in IsValidFileName');
  end;
end;


function ReformatInvalidFileName(FileName : string): string;
var
  c : Char;
begin
  try
    // delete all double spaces - added 2016-03-19 DE
    while (pos('  ', FileName) > 0) do
      delete(FileName, pos('  ', FileName), 1);
    // end new code
    for c in FileName do begin
      if CharInSet(c, validCharacters) then
        result := result + c;
    end;
  except
    if SuperUser then
      sm('error in ReformatInvalidFileName');
  end;
end;


function VerifyV5OrGreaterData(FileName : string): boolean;
var
  Version : integer;
begin
  try
    Version := GetDataVersion(FileName);
    // test if encrypted DB taxID ver
    if (Version > 0) then
      result := true
    else
      // If it is -5 or smaller then we likely have a valid file.
      result := (-4 > Version);
  except
    if SuperUser then sm('error in VerifyV5OrGreaterData');
    // VerifyV5OrGreraterData
  end;
end;


// ------------------------
procedure ClearTempProHdr;
begin
  try
    TempProHdr.regCode := '';
    TempProHdr.regCodeAcct := '';
    TempProHdr.taxFile := '';
    TempProHdr.taxpayer := '';
    TempProHdr.canETY := 0;
    TempProHdr.TDFpassword := '';
    TempProHdr.IsEIN := 0;
    TempProHdr.email := '';
  except
    if SuperUser then sm('error in ClearTempProHdr');
  end;
end;

// ------------------------
// read ProHeader from file
// 2017-03-10 MB - Load into TempProHdr!
procedure getProHeader(FileName : string);
var
  Value, Line, sFlag : string;
  i : integer;
  txtFile : textFile;
  ColData : TStringList;
  // ------------------------
begin
  try // finally
    ColData := TStringList.Create;
    ColData.StrictDelimiter := true;
    ColData.Delimiter := #9;
    if not dbFileConnect(FileName, false) then
      Exit;
    try // except
      lineList := TStringList.Create;
      ClearTempProHdr; // 2017-03-10 MB Clear before reading
      // save lineList while file is open so we can view it
      // as plain text (using Ctrl-Shift-Z)
      getLinesFromDB(lineList, 2);
      for i := 0 to lineList.Count - 1 do begin
        Line := lineList[i]; // sm(line);
        ColData.DelimitedText := Line;
        // ----------------------------------------
        // get pro version header into TempProHdr
        if (ColData.Strings[0] = '-99') then begin
          TempProHdr.regCode := ColData.Strings[1];
          TempProHdr.taxFile := ColData.Strings[2]; // the name on the tax return
          TempProHdr.taxpayer := ReadSSN(ColData.Strings[3]); // the ID#: SSN or EIN
          if (ColData.Count > 4) then begin
            TempProHdr.regCodeAcct := ColData.Strings[4];
          end;
          if (ColData.Count > 5) then
            TempProHdr.canETY := StrToInt(ColData.Strings[5]);
          if (ColData.Count > 6) then
            TempProHdr.TDFpassword := ColData.Strings[6];
          // ----- IsEIN -----
          if (ColData.Count > 7) then
            TempProHdr.IsEIN := StrToInt(ColData.Strings[7])
          else if (length(ProHeader.taxpayer) = 11) then
            TempProHdr.IsEIN := 0
          else if (ProHeader.taxpayer = '') then begin
            if Settings.IsEIN then
              TempProHdr.IsEIN := 1
            else
              TempProHdr.IsEIN := 0;
          end
          else
            TempProHdr.IsEIN := 1;
        // ----- email -----
        if (ColData.Count > 8) then
          TempProHdr.email := (ColData.Strings[8]);
        // end if
        end
        else if (ColData.Strings[0] = '-9') then begin
          TaxYear := ColData.Strings[14]; // get tax year from 1st account header
        end;
      end; // for loop
    except
      if SuperUser then sm('error in getProHeader');
    end;
  finally
    dbFileDisconnect;
    ColData.Free;
  end;
end;


// ------------------------------------
// base value (from 1st field):
// nothing = 0
// chr(201) = encrypted DB
// -9 = text TDF
// other number = old TradeLog file
// ------------------------------------
function GetDataVersion(FileName : string): integer;
var
  Value, Line, sDebugMsg : string;
  txtFile : textFile;
  iDebugVal : integer;
  // --------------------------
  procedure firstbyte;
  begin
    iDebugVal := ord(Value[1]);
    sDebugMsg := '[' + IntToStr(iDebugVal) + ']';
    iDebugVal := ord(Value[2]);
    sDebugMsg := sDebugMsg + '[' + IntToStr(iDebugVal) + ']';
    sm('Please report these codes to TradeLog Support:' + CR //
        + sDebugMsg);
  end;
// --------------------------
begin
  Screen.Cursor := crHourGlass; // because this can take awhile...
  try // outer finally
    isDBfile := false;
    result := 0;
    AssignFile(txtFile, FileName);
    reset(txtFile);
    try // inner finally
      Readln(txtFile, Line);
      Value := ParseFirst(Line, Tab);
      // -----------------------------------
      // case of first tab-delimited value:
      // file is blank
      try // except
        if (Value = '') then begin
          result := 0;
        end
        else if Value[1] = chr(45) then begin // char = <minus>
          if isInt(Value) then
            result := StrToInt(Value)
          else
            result := -9;
        end
        // check if file is encrypted DB
        else begin // if Value[1] = chr(201) then // char = É
          isDBfile := true; // assume it is
          result := 1; // base value
          // ***
          // need to read into TempProHdr, not the real ProHeader!
          // ***
          getProHeader(FileName);
          // TempProHdr used to read but not update pro file header line data
          if TempProHdr.regCode <> '' then
            result := result + 1;
          if TempProHdr.regCodeAcct <> '' then
            result := result + 2;
            // RegCode, AcctCode, Result
            // <blank>, <blank> , 1
            // RegCode, <blank> , 2
            // <blank>, AcctCode, 3
            // RegCode, AcctCode, 4
            // ----------------------------
            // Get CustomerToken for BC
            // ----------------------------
          gsCustomerToken := v2ClientToken;
          // GetAuthenticate(TempProHdr.email, TempProHdr.regCode);
        end;
      except
        if SuperUser then sm('error in GetDataVersion');
      end;
    finally
      closeFile(txtFile);
    end;
  finally
    Screen.Cursor := crDefault; // don't exit without fixing cursor!
  end;
end; // GetDataVersion


// ----------------
// TFileHeader
// ----------------

procedure TTLFileHeader.ConvertImportMethod(Value : integer);
var
  LeftInt, RightInt : integer;
begin
  try // except
    Value := Abs(Value);
    LeftInt := Trunc(Value / 10);
    RightInt := Value mod 10;
    // Just in case we can't decide, default it to select each time.
    FImportMethod := imSelectEachTime;
    // The following values represent different combinations
    // that should be shown to the user as follows:
    // LeftInt              RightInt
    // 10 = BrokerConnect = 1 and Download File = 2.
    // 20 = BrokerConnect = 1, DownloadFile = 2 and WebImport = 3.
    // 30 = BrokerConnect = 1 and WebImport = 2.
    // 40 = DownloadFile = 1 and WebImport = 2
    // 50 = Yodlee and DownloadFile
    case RightInt of
    0 :
      FImportMethod := imSelectEachTime;
    1 :
      FImportMethod := imBrokerConnect;
    2 :
      FImportMethod := imFileImport;
    3 :
      FImportMethod := imWebImport;
    4 :
      FImportMethod := imYodlee;
    end;
  except
    if SuperUser then sm('error in ConvertImportMethod');
    // ConvertImportMethod
  end;
end;


constructor TTLFileHeader.Create(Parent : TTLFile; HeaderLine : string; pTaxYear : string;
  pBrokerID : integer; BrokerOverride : boolean = false);
begin
  try // except
    Create(Parent); // the TLFile object
    ProcessHeaderLine(HeaderLine, pTaxYear, pBrokerID, BrokerOverride);
    UpdateImportFilter;
  except
    if SuperUser then sm('error creating TTLFileHeader');
  end;
end;

constructor TTLFileHeader.CreateNew(Parent : TTLFile; FileImportFormat : string;
  ImportMethod : TTLImportMethod; TaxYear : string; BaseCurrencyLocale : integer; IraAcct : boolean;
  MTM : boolean; SLConvert : boolean; Commission : double = 0);
begin
  try // except
    Create(Parent); // the TLFile object
    if not isInt(TaxYear) then
      raise ETLFileException.Create('Tax Year Must be an integer, cannot create file, TaxYear: '
        + TaxYear);
    FFileImportFormat := FileImportFormat;
    UpdateImportFilter;
    self.ImportMethod := ImportMethod;
    FTaxYear := TaxYear;
    if BaseCurrencyLocale > 0 then
      self.BaseCurrencyLocale := BaseCurrencyLocale
    else
      self.BaseCurrencyLocale := EnglishUS;
    FIra := IraAcct;
    FMTM := MTM;
    FSLConvert := SLConvert;
    FCommission := Commission;
  except
    if SuperUser then sm('error creating new TTLFileHeader');
  end;
end;


constructor TTLFileHeader.Create(Parent : TTLFile);
var
  i : TCheckList;
begin
  FParent := Parent;
  FVersion := -9;
  FPlaidAcctId := '';
  FDate := datetostr(now, Settings.UserFmt);
  FTime := timetostr(now, Settings.UserFmt);
  FIra := false;
  FBaseCurrencyLocale := EnglishUS;
  FFileImportFormat := '';
  FMutualFunds1099 := true;
  FSalesAdjOptions1099 := false;
  FDrips1099 := true;
  FMTM := false;
  FMTMLastYear := false;
  FFileLocale := '-1';
  FGrossSales1099 := '';
  FCostBasis1099ST := '';
  FCostBasis1099LT := '';
  FImportMethod := imSelectEachTime;
  FSLConvert := false;
  FOFXPassword := '';
  FOFXUserName := '';
  FOFXAccount := '';
  FOptions1099 := false;
  FETFETN1099 := true;
  FBrokerID := -1;
  FTaxYear := '';
  FAccountName := '';
  FImportFilter := TTLImportFilter.Create;
  FCommission := 0;
  FAccountNameChanged := false;
  FMTMForFutures := false;
  FCheckListItems := '';
  for i := low(TCheckList) to high(TCheckList) do
    FCheckListItems := FCheckListItems + '0';
  FYearEndDone := false;
  FNo1099 := false;
end;


procedure TTLFileHeader.ProcessHeaderLine(HeaderLine, pTaxYear : string; pBrokerID : integer;
  BrokerOverride : boolean = false);
var
  Value : string;
  IntValue : integer;
  OldFileHeader : boolean;
  CheckListItem : TCheckList;
begin
  try
    { FIELD 1 - File Version }
    Value := ParseFirst(HeaderLine, Tab);
    if (Value <> '-9') and (Value <> '-5') then
      raise ETLFileException.Create('Invalid Header Row, Must Start with -5 or -9');
    OldFileHeader := (Value = '-5');
    // always write back file ver 9, so force this here
    FVersion := -9;
    // FIELD 2 - TradeLog File Identifier
    // If old File type then ignore field #2.
    Value := ParseFirst(HeaderLine, Tab);
    if (Value = TRADE_LOG) then
      FPlaidAcctId := ''
    else
      FPlaidAcctId := Value;
    // FIELD 3 - File Date
    Value := ParseFirst(HeaderLine, Tab);
    FDate := Value;
    // FIELD 4 - File Time
    Value := ParseFirst(HeaderLine, Tab);
    FTime := Value;
    // FIELD 5 - IS this an IRA
    // If this is the old file format then we were not using this field.
    Value := ParseFirst(HeaderLine, Tab);
    if isInt(Value) and not OldFileHeader then
      FIra := StrToBool(Value)
    else
      FIra := false;
    // FIELD 6 - Base Currency Locale
    Value := ParseFirst(HeaderLine, Tab);
    if isInt(Value) then
      FBaseCurrencyLocale := StrToInt(Value)
    else
      FBaseCurrencyLocale := 0;
    if FBaseCurrencyLocale < 1 then
      FBaseCurrencyLocale := 1033; // EnglishUS
    // FIELD 7 - Import Format - Broker Name
    Value := ParseFirst(HeaderLine, Tab);
    FFileImportFormat := Value;
    // --- legacy conversions ---------
    if (FFileImportFormat = 'Ameritrade') then
      FFileImportFormat := 'Schwab'
    else if (FFileImportFormat = 'Charles Schwab') then
      FFileImportFormat := 'Schwab'
    else if (FFileImportFormat = 'Etrade') //
    or (FFileImportFormat = 'ETrade') then
      FFileImportFormat := 'E-Trade'
    else if (FFileImportFormat = 'optionsXpress') then
      FFileImportFormat := 'Other'
    else if (FFileImportFormat = 'Penson') then
      FFileImportFormat := 'Apex'
    else if (FFileImportFormat = 'Excel-Text') then
      FFileImportFormat := 'Other'
    else if (FFileImportFormat = 'tastyworks') then
      FFileImportFormat := 'tastytrade'
    else if (FFileImportFormat = 'TOS') then // Think of Swim
      FFileImportFormat := 'Schwab'
    else if (FFileImportFormat = 'TDAmeritrade') then
      FFileImportFormat := 'Schwab'
    else if (FFileImportFormat = 'Centerpoint') then
      FFileImportFormat := 'CenterPoint'
    else if (FFileImportFormat = 'COR') then
      FFileImportFormat := 'Axos';
    // FIELD 8 - Is MutualFunds Checked on 1099
    // In the old file format we had a Locale in this field,
    // but we were no longer using it.
    Value := ParseFirst(HeaderLine, Tab);
    if isInt(Value) and not OldFileHeader then
      FMutualFunds1099 := StrToBool(Value)
    else
      FMutualFunds1099 := true;
    // FIELD 9 - Is Drips Checked on 1099
    // In Old Format, this is the old FileLocale
    // otherwise we'll use -1 for the new internal format.
    // and assume that this value is now the MutualFunds Flag.
    Value := ParseFirst(HeaderLine, Tab);
    if isInt(Value) and not OldFileHeader then begin
      FDrips1099 := StrToBool(Value);
      FFileLocale := '-1';
    end
    else begin
      FDrips1099 := true;
      FFileLocale := Value;
    end;
    // FIELD 10 - 1099 Gross Sales Value
    // 1099 Gross Sales Value
    Value := ParseFirst(HeaderLine, Tab);
    if length(Value) > 0 then
      FGrossSales1099 := Value;
    // FIELD 11 - Import Method
    Value := ParseFirst(HeaderLine, Tab);
    if isInt(Value) then begin
      IntValue := StrToInt(Value);
      if (IntValue < 0) or (IntValue > 3) then begin
        ConvertImportMethod(IntValue);
        if FParent <> nil then
          FParent.FFileCleaned := true;
      end
      else
        FImportMethod := TTLImportMethod(IntValue);
    end
    else
      FImportMethod := imSelectEachTime;
    // FIELD 12 - SL Convert Value
    Value := ParseFirst(HeaderLine, Tab);
    if isInt(Value) then
      FSLConvert := StrToBool(Value)
    else
      FSLConvert := false;
    // Field 13 OFX Credentials
    Value := ParseFirst(HeaderLine, Tab);
    try
      // If this fails, set everything to null
      // and they will have to enter it again.
      if not isDBfile then
        Value := dencrypt(Value, '');
      FOFXPassword := parseLast(Value, '|');
      FOFXUserName := parseLast(Value, '|');
      FOFXAccount := Value;
    except
      FOFXPassword := '';
      FOFXUserName := '';
      FOFXAccount := '';
    end;
    // Field 14 Options on the 1099
    Value := ParseFirst(HeaderLine, Tab);
    if isInt(Value) and not OldFileHeader then
      FOptions1099 := StrToBool(Value)
    else
      FOptions1099 := false;
    // Field 15 Tax Year
    Value := ParseFirst(HeaderLine, Tab);
    if length(Value) > 0 then
      FTaxYear := Value
    else if pTaxYear <> '' then
      FTaxYear := pTaxYear;
    // Field 16 Broker ID
    Value := ParseFirst(HeaderLine, Tab);
    if (length(Value) > 0) and not BrokerOverride then
      FBrokerID := StrToInt(Value)
    else if pBrokerID <> -1 then
      FBrokerID := pBrokerID;
    // Field 17 Account Name
    Value := ParseFirst(HeaderLine, Tab);
    if (length(Value) > 0) then
      FAccountName := RemoveParens(Value);
    // FIELD 18 - IS this an MTM Accounting File
    Value := ParseFirst(HeaderLine, Tab);
    if isInt(Value) then
      FMTM := StrToBool(Value)
    else
      FMTM := false;
    // FIELD 19 - IS ETF, ETN
    Value := ParseFirst(HeaderLine, Tab);
    if isInt(Value) then
      FETFETN1099 := StrToBool(Value)
    else
      FETFETN1099 := true;
    // FIELD 20 - 1099 Cost Basis ST Value
    Value := ParseFirst(HeaderLine, Tab);
    if length(Value) > 0 then
      FCostBasis1099ST := Value;
    // FIELD 21 - 1099 Sales Adjusted for Option Premiums
    Value := ParseFirst(HeaderLine, Tab);
    if length(Value) > 0 then
      FSalesAdjOptions1099 := StrToBool(Value)
    else
      FSalesAdjOptions1099 := false;
    // FIELD 22 - 1099 Cost Basis LT Value
    Value := ParseFirst(HeaderLine, Tab);
    if length(Value) > 0 then
      FCostBasis1099LT := Value;
    // FIELD 23 - Round Trip Commission
    Value := ParseFirst(HeaderLine, Tab);
    if length(Value) > 0 then
      FCommission := StrToFloat(Value);
    // Field 24 - AutoAssignShorts
    Value := ParseFirst(HeaderLine, Tab);
    if isInt(Value) then
      FAutoAssignShorts := StrToBool(Value)
    else
      FAutoAssignShorts := false;
    // Field 25 - MTMLastYear
    Value := ParseFirst(HeaderLine, Tab);
    if isInt(Value) then
      FMTMLastYear := StrToBool(Value)
    else
      FMTMLastYear := false;
   // Field 26 - MTMElectionType
    Value := ParseFirst(HeaderLine, Tab);
    if isInt(Value) then
      FMTMForFutures := StrToBool(Value)
    else
      FMTMForFutures := false;
    // Field 27 - AutoAssignShortsOptions
    Value := ParseFirst(HeaderLine, Tab);
    if isInt(Value) then
      FAutoAssignShortsOptions := StrToBool(Value)
    else begin
      FAutoAssignShortsOptions := false;
      FParent.FFileNeedsSaving := true;
    end;
    // Field 28 - CheckListItems
    // The local variable FCheckListItems needs to be the right length based
    // on the items in the TCheckList, therefore if for some reason the string
    // in the file is not the same length as the TCheckList type then we don't
    // just want to set it into the local variable as this would change the
    // length and cause the getter code to fail. Rather we want to read each
    // item as if they were separate fields and set them that way.
    // If the File does not contain a value, then we are opening a file that
    // has never run with this version so initialize this field in the file,
    // If on the other hand the Value from the file is there but shorter than
    // the TCheckList this means we have added a new TCheckList item so again
    // we will set FFileConverted so that this new item gets initialized into
    // the file.
    Value := ParseFirst(HeaderLine, Tab);
    // if this is an earlier file created before this new functionality, then
    // just save a '9' in the field, so that we know not to show the checklist
    // or any other functionality related to it unless we are importing into a
    // file that already has checklistOn. In that case checklist needs to be
    // on for all files even if old.
    if (length(Value) = 0) and not Parent.CheckListOn and (StrToInt(FTaxYear) < 2012) then
      FCheckListItems := '9'
    else
      // Store checklist items as as bit flags in a string.
      // For instance, if there are four items in the TCheckList enumerated
      // type, we store 4 characters in the string to represent the on or off
      // state of the 4 checklist items. If all are OFF then the value read
      // from the file will be 0000; if they're all ON, 1111; if some are on
      // and some off then a combination of zero's and ones. E.g. 0101 means
      // first one off, second on, third off, forth on etc.; since an
      // enumerated type is nothing more than a numbered list starting with
      // zero, we can take the integer representation of the type and just
      // check that position in the string for the on/off value for the
      // checklist item. Since strings are one-based and types are zero-based
      // we need to add one to the integer representation to get the right
      // character position of the value string.
      for CheckListItem := low(TCheckList) to high(TCheckList) do begin
        IntValue := integer(CheckListItem) + 1;
        if (length(Value) > 0) then begin
          // Once we have the integer value, set the internal FCheckListItems
          // string character position to the value of each of the read in
          // values position. The reason why we process this one character at
          // a time rather than just settign FCheckListItems := Value is that
          // when we initialize if we have added to the enumerated type
          // representing the checkListItems then the string will now be larger
          // than what is stored in the file. So when we add items this code
          // will just work for additional items and nothing other than the
          // enumerated type checlkistitems will need to be changed.
          if IntValue <= length(Value) then
            FCheckListItems[IntValue] := Value[IntValue]
          else
            // If the Value is shorter then the number in check list items,
            // then we have added checklist items during initialization, so
            // make sure we save this change.
            FParent.FFileNeedsSaving := true;
        end
        else // if value does not exist in file yet then we need to add an initial value for this field
          FParent.FFileNeedsSaving := true;
      end;
    // Field 29 - YearEndDone, This SHOULD be just a file header element, but
    // since we didn't have a file header, it's stored in each account header.
    Value := ParseFirst(HeaderLine, Tab);
    if isInt(Value) then
      FYearEndDone := StrToBool(Value)
    else begin
      FYearEndDone := false;
      FParent.FFileNeedsSaving := true;
    end;
    // FIELD 30 - No 1099 Reconciliation check box
    Value := ParseFirst(HeaderLine, Tab);
    if isInt(Value) then
      FNo1099 := StrToBool(Value)
    else begin
      FNo1099 := false;
      FParent.FFileNeedsSaving := true;
    end;
    // FIELD 31 - Short option G/L Reconciliation check box
    Value := ParseFirst(HeaderLine, Tab);
    if isInt(Value) then
      FShortOptGL := StrToBool(Value)
    else begin
      FShortOptGL := false;
      FParent.FFileNeedsSaving := true;
    end;
    // FIELD 32 - Options 2013 1099 Reconciliation check box
    Value := ParseFirst(HeaderLine, Tab);
    if isInt(Value) then
      FOptions2013 := StrToBool(Value)
    else begin
      FOptions2013 := false;
      FParent.FFileNeedsSaving := true;
    end;
    // --------------------------------
    if not FParent.FFileNeedsSaving then
      FParent.FFileNeedsSaving := OldFileHeader;
  except
    if SuperUser then sm('error in ProcessHeaderLine');
    // ProcessHeaderLine
  end;
end;


procedure TTLFileHeader.ResetCheckList;
var
  i : integer;
  L : integer;
begin
  try
    if FCheckListItems <> '9' then begin
      L := length(FCheckListItems);
      FCheckListItems := '';
      for i := 0 to L - 1 do
        FCheckListItems := FCheckListItems + '0';
    end;
  except
    if SuperUser then sm('error in ResetCheckList');
    // ResetCheckList
  end;
end;


procedure TTLFileHeader.SetAccountName(const Value : string);
var
  Header : TTLFileHeader;
begin
  if (pos('(', Value) > 0) or (pos(')', Value) > 0) then
    raise ETLFileException.Create('Account name cannot have opening or closing parenthesis');
  if FParent.VerifyUniqueAccountName(Value, BrokerID) then
    FAccountName := Value
  else
    raise ETLFileException.Create('Account Name must be unique!');
end;


procedure TTLFileHeader.SetAutoAssignShorts(const Value : boolean);
begin
  if ImportFilter.SupportsFlexibleAssignment then
    FAutoAssignShorts := Value
  // else just leave it unchanged (like it did before).
end;

procedure TTLFileHeader.SetAutoAssignShortsOptions(const Value : boolean);
begin
  if ImportFilter.SupportsFlexibleAssignment then
    FAutoAssignShortsOptions := Value;
end;

procedure TTLFileHeader.SetBaseCurrencyLocale(const Value : integer);
begin
  FBaseCurrencyLocale := Value;
  FImportFilter.BaseCurrLCID := FBaseCurrencyLocale;
end;


procedure TTLFileHeader.SetCheckListItem(Item : TCheckList; const Value : boolean);
var
  i : integer;
  c : Char;
begin
  try // except
    i := integer(Item) + 1;
    if Value then
      c := '1'
    else
      c := '0';
    // ------------------------
    if FCheckListItems[i] <> c then begin
      FCheckListItems[i] := c;
      FParent.FFileNeedsSaving := true;
    end;
  except
    if SuperUser then sm('error in SetCheckListItem');
  end;
end;

procedure TTLFileHeader.SetCommission(const Value : double);
begin
  if ImportFilter.SupportsCommission then
    FCommission := Value
  else
    FCommission := 0;
end;


procedure TTLFileHeader.SetFileImportFormat(const Value : string);
var
  OldFileImportFormat : string;
begin
  OldFileImportFormat := FFileImportFormat;
  FFileImportFormat := Value;
  try // except
    UpdateImportFilter;
    // When the broker is changed reset these flags to the broker default.
    FSLConvert := FImportFilter.SLConvert;
    FAutoAssignShorts := FImportFilter.AutoAssignShorts;
    FAutoAssignShorts := FImportFilter.AutoAssignShortsOptions;
  except
    on E : ETLFileException do begin
      FFileImportFormat := OldFileImportFormat;
      if SuperUser then sm('error in SetFileImportFormat');
      raise E;
    end;
  end;
end;


procedure TTLFileHeader.SetImportMethod(const Value : TTLImportMethod);
begin
  FImportMethod := Value;
end;


procedure TTLFileHeader.SetMTM(const Value : boolean);
begin
  FMTM := Value;
  if FMTM = false then begin
    FMTMLastYear := false;
  end;
end;


procedure TTLFileHeader.UpdateImportFilter;
var
  ImportFilter : TTLImportFilter;
begin
  try // except
    if length(FFileImportFormat) > 0 then begin
      if ImportFilters.TryGetValue(FFileImportFormat, ImportFilter) then begin
        FImportFilter.Update(ImportFilter);
        // default currency
        if FImportFilter.SupportsFlexibleCurrency then
          FImportFilter.BaseCurrLCID := FBaseCurrencyLocale;
      end
    end;
  except
    if SuperUser then sm('error in UpdateImportFilter');
  end;
end;


function TTLFileHeader.GetAccountName : string;
begin
  if length(FAccountName) > 0 then
    result := FAccountName
  else
    result := '';
end;

function TTLFileHeader.GetAutoAssignShorts : boolean;
begin
  if ImportFilter.SupportsFlexibleAssignment then
    result := FAutoAssignShorts
  else
    result := ImportFilter.AutoAssignShorts;
  // use default value.
end;

function TTLFileHeader.GetAutoAssignShortsOptions : boolean;
begin
  { if ImportFilter.SupportsFlexibleAssignment then
    Result := FAutoAssignShortsOptions
  else }
  result := ImportFilter.AutoAssignShortsOptions;
end;


function TTLFileHeader.GetBeforeCheckList : boolean;
begin
  result := FCheckListItems = '9';
end;


function TTLFileHeader.GetCheckListComplete : boolean;
var
  i : TCheckList;
begin
  if BeforeCheckList then
    Exit(true);
  result := true;
{ if not CheckListItem[clExpireOptions]
  or not CheckListItem[clExerciseOptions]
  or not CheckListItem[clOpenPositions]
  then
    Exit(false); }
  for i := low(TCheckList) to high(TCheckList) do begin
    if not CheckListItem[i] then
      Exit(false);
  end;
end;


function TTLFileHeader.GetCheckListItem(Item : TCheckList): boolean;
var
  CurrentAcct : integer;
begin
  CurrentAcct := FParent.CurrentBrokerID;
  FParent.CurrentBrokerID := BrokerID;
  try
    { If we have no options then this check item is unnecessary so
      Just return true }
    try // except
      if (Item in [clExpireOptions, clExerciseOptions]) //
        and not FParent.HasOptions then
        Exit(true)
      { If this is an IRA Account as well we don't need to reconcile so return true }
      else if (Item = clReconcile1099) //
        and FParent.CurrentAccount.Ira then
        Exit(true);
      result := StrToBool(FCheckListItems[integer(Item) + 1]);
    except
      if SuperUser then sm('error in GetCheckListItem');
    end;
  finally
    FParent.CurrentBrokerID := CurrentAcct;
  end;
end;


function TTLFileHeader.GetFileHeaderRow : string;
var
  sLogin : string;
begin
  try // except
    // if file is encrypted no need to encrypt login
    if isDBfile or taxidVer then
      sLogin := Trim(FOFXAccount) + '|' //
        + Trim(FOFXUserName) + '|' //
        + Trim(FOFXPassword)
    else
      sLogin := dencrypt(Trim(FOFXAccount) + '|' //
        + Trim(FOFXUserName) + '|' //
        + Trim(FOFXPassword), '');
    // ------------------------
    result := // columns when pasted into Excel
      IntToStr(FVersion) + Tab // A
      + FPlaidAcctId + Tab // B
      + FDate + Tab // C
      + FTime + Tab // D
      + BoolToStr(FIra) + Tab // E
      + IntToStr(FBaseCurrencyLocale) + Tab // F
      + FFileImportFormat + Tab // G
      + BoolToStr(FMutualFunds1099) + Tab // H
      + BoolToStr(FDrips1099) + Tab // I
      + FGrossSales1099 + Tab // J
      + IntToStr(integer(FImportMethod)) + Tab // K
      + BoolToStr(FSLConvert) + Tab // L
      + sLogin + Tab // M
      + BoolToStr(FOptions1099) + Tab // N
      + FTaxYear + Tab // O
      + IntToStr(FBrokerID) + Tab // P
      + FAccountName + Tab // Q
      + BoolToStr(FMTM) + Tab // R
      + BoolToStr(FETFETN1099) + Tab // S
      + FCostBasis1099ST + Tab // T
      + BoolToStr(FSalesAdjOptions1099) + Tab // U
      + FCostBasis1099LT + Tab // V
      + FloatToStr(FCommission) + Tab // W
      + BoolToStr(FAutoAssignShorts) + Tab // X
      + BoolToStr(FMTMLastYear) + Tab // Y
      + BoolToStr(FMTMForFutures) + Tab // Z
      + BoolToStr(FAutoAssignShortsOptions) + Tab // AA
      + FCheckListItems + Tab // AB
      + BoolToStr(FYearEndDone) + Tab // AC
      + BoolToStr(FNo1099) + Tab // AD
      + BoolToStr(ShortOptGL) + Tab // AE
      + BoolToStr(FOptions2013); // AF
  except
    if SuperUser then sm('error in GetFileHeaderRow');
  end;
end;


function TTLFileHeader.GetIsUsCurrency : boolean;
begin
  result := FBaseCurrencyLocale = EnglishUS;
end;

function TTLFileHeader.GetMTMLastYear : boolean;
begin
  result := FMTMLastYear;
end;

{ TTLFile }

procedure TTLFile.AddAccount(Header : TTLFileHeader; BrokerOverride : boolean = false);
begin
  try // except
    if Header.ImportFilter.BaseCurrLCID <> FileHeaders[0].ImportFilter.BaseCurrLCID then
      raise ETLFileCurrencyException.Create
        ('Currency Type Error: Multiple currencies not allowed in the same file.');
    if not BrokerOverride then
      Header.BrokerID := FTLFileHeaders.NextBrokerID;
    FTLFileHeaders.Add(Header);
  except
    if SuperUser then sm('error in TTLFile.AddAccount');
  end;
end;


// Split out CombineFile from ReadFile and made into a separate routine
// to support multi-account imports - 2016-05-03 MB
function TTLFile.CombineFile(FileName : string) : boolean;
var
  i, nMaxBRid, oldBRid, newBRid, nMaxTRnum, oldTRnum, newTRnum : integer;
  Fmt : TFormatSettings;
  LastTradeAdded : TTLTrade;
  ColData : TStringList;
  FileStream : TStreamReader;
  Line, TaxYear, s : string;
  Trade : TTLTrade;
  TLHeader : TTLFileHeader;
  // ------------------------
  function CombineHeader(Value : string; pTaxYear : string): integer;
  begin
    FTLFileHeaders.Add(TTLFileHeader.Create(self, Value, TaxYear, result, true));
  end;
  // ------------------------
  function ReadHeader2(Value : string; pTaxYear : string; BrokerOverride : boolean = false)
    : integer;
  begin
    if not BrokerOverride then
      result := FTLFileHeaders.NextBrokerID;
    FTLFileHeaders.Add(TTLFileHeader.Create(self, Value, pTaxYear, result, BrokerOverride));
  end;
// ------------------------
begin
  try // except
    result := true;
    TaxYear := IntToStr(TradeLogFile.TaxYear);
    nMaxTRnum := 0;
    // Fix for Account Import when current file is empty - 2016-06-01 MB
    nMaxBRid := FTLFileHeaders.NextBrokerID;
    if Count > 0 then begin
      // get highest BR#, TR#
      for Trade in FTrades do begin
        if (Trade.TradeNum > nMaxTRnum) then
          nMaxTRnum := Trade.TradeNum;
      end;
    end;
    Line := '';
    DoStatus('Reading Data File');
    Screen.Cursor := crHourGlass;
    try
      ColData := TStringList.Create;
      ColData.StrictDelimiter := true;
      ColData.Delimiter := #9;
      // --------------------------------
      // First, get data into lineList[i]
      // --------------------------------
      lineList := TStringList.Create; // save for Ctrl-Shift-Z
      // ------- Read from DB file --------
      if isDBfile then begin
        try
          // open file to merge, get data
          if not dbFileConnect(FileName, false) then Exit;
          getLinesFromDB(lineList);
        finally
          dbFileDisconnect;
        end;
      end
      // ------- read from tdf file ----------
      else begin // file is *.tdf
        try
          FileStream := TStreamReader.Create(FileName);
          while not FileStream.EndOfStream do begin
            Line := FileStream.ReadLine;
            lineList.Add(Line);
          end; // <-- while not EOF(txtFile)
        finally
          FileStream.Free;
        end;
      end;
      // --------------------------------
      // Now, loop through lineList[i]
      // --------------------------------
      for i := 0 to lineList.Count - 1 do begin
        Line := lineList[i]; // sm(line);
        ColData.DelimitedText := Line;
        if ColData.Strings[0] = '' then
          continue;
        if (ColData.Strings[0] = '-99') then
          continue; // skip pro header
        if (leftstr(ColData.Strings[0], 1) = '-') then begin
          // broker account header --> translate BRid and add to TLFile
          oldBRid := StrToInt(ColData.Strings[15]);
          newBRid := oldBRid + nMaxBRid - 1;
          TLHeader := TTLFileHeader.Create(self, Line, TaxYear, newBRid, true);
          // I just want to make pass the correct account to AccountSetup!!!
          if TdlgAccountSetup.Execute(TLHeader, true, TLHeader.MTMLastYear, TLHeader.MTM,
            'Account was imported; please verify account settings') = mrOK then
            FTLFileHeaders.Add(TLHeader);
          // --------------------------------------------
          // make sure we have a usable accountname
          // --------------------------------------------
          s := FTLFileHeaders.Last.AccountName; // just look it up once
          if length(s) = 0 then
            FTLFileHeaders.Last.FAccountName := copy(FileName, 6, length(FileName) - 9)
          else if RightStr(s, 4) = '.tdf' then
            FTLFileHeaders.Last.FAccountName := copy(s, 6, length(s) - 9);
          // -------------------
          if FTLFileHeaders.Last.ImportFilter.BaseCurrLCID <> FTLFileHeaders.First.ImportFilter.BaseCurrLCID
          then begin
            Revert;
            FTLFileHeaders.Remove(FTLFileHeaders.Last);
            raise ETLFileCurrencyException.Create
              ('Currency Type Error: Multiple currencies not allowed in the same file.');
          end; // -------------------
          if FTLFileHeaders.Last.TaxYear <> FTLFileHeaders.First.TaxYear then begin
            Revert;
            FTLFileHeaders.Remove(FTLFileHeaders.Last);
            raise ELTFileInvalidYearException.Create('You can only add files for the tax year: ' //
              + FTLFileHeaders.First.TaxYear + ' to this file');
          end; // -------------------
          Fmt := GetBackwardCompatibleLocaleSettings(FileHeaders.Last.FileLocale);
        end
        else begin
          // trade detail record --> translate BRid AND TRnum, add to TLFile
          oldBRid := StrToInt(ColData.Strings[14]);
          newBRid := oldBRid + nMaxBRid - 1;
          oldTRnum := StrToInt(ColData.Strings[1]);
          newTRnum := oldTRnum + nMaxTRnum;
          // Populate the TradeNumList
          // assumption: all trades are in the correct order
          LastTradeAdded := ReadDataLine(Line, Fmt, newBRid, true, newTRnum);
        end;
      end;
    finally
      ColData.Free;
    end;
    // close merge file
    // renumber current file
    // ----------------------------------
    CreateLists;
    CloneList;
    DoStatus('Loading Grid');
    // Make sure that all checklist items are on.
    VerifyEOYCheckList(true);
  except
    if SuperUser then sm('error in TTLFile.CombineFile');
  end;
end;


// ----------------------------------------------
function TTLFile.AddFile(FileName : string) : boolean;
var
  TaxYear, s : string;
begin
  result := true;
  try // except
    if Count > 0 then
      ReadFile(FileName, true, FTrades.Last.TradeNum)
    else
      ReadFile(FileName, true);
    // -------------------
    s := FTLFileHeaders.Last.AccountName;
    if length(s) = 0 then begin
      { Just trying to make sure we have an account Name }
      FTLFileHeaders.Last.FAccountName := copy(FileName, 6, length(FileName) - 9);
    end
    else if RightStr(s, 4) = '.tdf' then begin
      // this is the old file name lopp off the year and extenstion
      // Use the FAccountName private variable to avoid the unique name issue
      FTLFileHeaders.Last.FAccountName := copy(s, 6, length(s) - 9);
    end; // -------------------
    if not VerifyUniqueAccountName(s, FTLFileHeaders.Last.BrokerID) then begin
      FTLFileHeaders.Last.AccountName := s + '-' + IntToStr(FTLFileHeaders.Last.BrokerID);
    end; // -------------------
    if FTLFileHeaders.Last.ImportFilter.BaseCurrLCID <> FTLFileHeaders.First.ImportFilter.BaseCurrLCID
    then begin
      Revert;
      FTLFileHeaders.Remove(FTLFileHeaders.Last);
      raise ETLFileCurrencyException.Create
        ('Currency Type Error: Multiple currencies not allowed in the same file.');
    end; // -------------------
    if FTLFileHeaders.Last.TaxYear <> FTLFileHeaders.First.TaxYear then begin
      Revert;
      FTLFileHeaders.Remove(FTLFileHeaders.Last);
      raise ELTFileInvalidYearException.Create('You can only add files for the tax year: ' //
          + FTLFileHeaders.First.TaxYear + ' to this file');
    end; // -------------------
    // Make sure that all checklist items are on.
    VerifyEOYCheckList(true);
  except
    if SuperUser then sm('error in TTLFile.AddFile');
  end;
end;


function TTLFile.AddTrade(Trade : TTLTrade; Initializing : boolean = false) : integer;
begin
  // Sets ID, TradeNum, Broker if not already set
  try // except
    InitializeTrade(Trade);
    result := FTrades.Add(Trade);
    VerifyTrade(Trade);
    if not Initializing and not EnteringEndYearPrice then
      FileHeader[Trade.Broker].ResetCheckList;
  except
    if SuperUser then sm('error in TTLFile.AddTrade');
  end;
end;


function TTLFile.ChangeMutEtfRec(Ticker, TypeMult : string): string;
var
  i, j : integer;
begin
  try
    result := TypeMult;
    // 2018-05-02 MB - moved to top to simplify logic
    if ((TradeLogFile.CurrentBrokerID <> 0) // individual broker account
        and (CurrentAccount.ImportFilter.BaseCurrLCID <> EnglishUS)) // and NOT US currency
    then
      Exit; // NOTE: do not change for foreign currency accounts
    // ASSUME: mini-options can change to MUT or ETF type, but not OPT-100?
    if (pos('OPT-100', TypeMult)= 0) // NOT OPT-100
    and (pos('SSF', TypeMult)= 0) // NOT a Single-Stock Future
    and (pos('FUT', TypeMult)= 0) // NOT a Future
    and (pos('CUR', TypeMult)= 0) // NOT Currency
    and (pos('DCY', TypeMult)= 0) // NOT Digital Currency
    and (pos('DRP', TypeMult)= 0) // NOT a Drip
    then begin
      // see if this ticker SEEMS to be in one of these lists
      j := Settings.MutualFundList.IndexOf(Ticker);
      i := Settings.ETFsList.IndexOf(Ticker);
      // now confirm if it REALLY is in the list (not a partial match)
      if (j >= 0) and (Ticker = Settings.MutualFundList[j].Symbol) then
        result := 'MUT-1'
      else if (i >= 0) and (Ticker = Settings.ETFsList[i].Symbol) then
        result := Settings.ETFsList[i].subType + '-1'
      else if (pos('MUT', TypeMult)= 1) // if it's not in either list, but it WAS a MUT...
      or (pos('ETF', TypeMult)= 1) // ...or an ETF type (which means it probably WAS in
      or (pos('VTN', TypeMult)= 1) // the one of these lists but was later removed)...
      or (pos('CTN', TypeMult)= 1) //
      then begin
        result := 'STK-1'; // 2018-06-01 MB - change back to STK
      end;
    end;
  except
    on E : Exception do begin
      mDlg('Error in ChangeMutEtfRec(' + Ticker + ', ' + TypeMult + ')' + CR //
          + E.Message, mtError, [mbOK], 0);
    end;
  end;
end;


procedure TTLFile.ClearAll(SaveFile : boolean);
var
  i : integer;
  Trade : TTLTrade;
begin
  try // except
    for i := FTrades.Count - 1 downto 0 do begin
      if (FCurrentBroker = 0) or (FTrades[i].Broker = FCurrentBroker) then
        DeleteTrade(FTrades[i]);
    end;
    if SaveFile then begin
      self.SaveFile(true);
    end;
  except
    if SuperUser then sm('error in TTLFile.ClearAll');
  end;
end;


procedure TTLFile.ClearOPRASymbols;
var
  Trade : TTLTrade;
begin
  for Trade in FTrades do begin
    if (FCurrentBroker = 0) or (Trade.Broker = FCurrentBroker) then
      Trade.OptionTicker := '';
  end;
  SaveFile(true);
end;


procedure TTLFile.CloneList;
var
  Trade : TTLTrade;
begin
  try // except
    for Trade in FTradesSaved do
      Trade.Free;
    FTradesSaved.Clear;
    // Make a backup copy of Trades so when the revert we don't have to reread the file from disk.
    for Trade in FTrades do
      FTradesSaved.Add(TTLTrade.Create(Trade));
  except
    if SuperUser then sm('error in TTLFile.CloneList');
  end;
end;


function TTLFile.GetAllCheckListsComplete : boolean;
var
  FileHeader : TTLFileHeader;
begin
  result := true;
  try // except
    for FileHeader in FTLFileHeaders do begin
      if not FileHeader.CheckListComplete then begin
        Exit(false);
      end;
    end;
  except
    if SuperUser then sm('error in GetAllCheckListsComplete');
  end;
end;


function TTLFile.GetBackwardCompatibleLocaleSettings(FileLocale : string) : TFormatSettings;
begin
  try // except
  { Changed to accomodate both int and string fileLocale. This is to allow for
    backward compatibility when dealing with files that had the old FileLocale saved
    in them. The last conversion changed this value to -1.
    Once a file has been converted with this latest version,
    FileLocale will no longer be part of the file Header }
    if (length(FileLocale) = 0) then begin
      // If fileLocale is not a valid integer and also not the Internal String
      // then we are going to attempt to use the USFormat for opening this file.
      GetLocaleFormatSettings(EnglishUS, result)
    end
    else if isInt(FileLocale) and (StrToInt(Trim(FileLocale)) > 0) then begin
      // OK so it is an integer and greater than zero so let's look up the Locale
      GetLocaleFormatSettings(StrToInt(FileLocale), result);
    end
    else begin
    // OK so it's not blank and it's not a valid integer
    // so let's try the internal Format. Must be equal to -1 or something.
      result := Settings.InternalFmt;
    end;
  except
    if SuperUser then
      sm('error in GetBackwardCompatibleLocaleSettings');
  end;
end;


function TTLFile.GetBeforeCheckList : boolean;
begin
  if FCurrentBroker = 0 then
    Exit(true);
  result := CurrentAccount.BeforeCheckList;
end;


{ Creates a blank file with the File Header and FileName specified.
  Primarily used to create the next year file }
constructor TTLFile.CreateNextYear(AFileName : string; NewTaxYear : string;
  Headers : TTLFileHeaders; StatusCallBack : TLBasicStatusCallBack = nil);
var
  NewHeader : TTLFileHeader;
  Header : TTLFileHeader;
  NewFileName : string;
begin
  try // except
    FStatusCallBack := StatusCallBack;
    Create;
    NewFileName := NewTaxYear + copy(AFileName, 5);
    FFileName := NewFileName;
    for Header in Headers do begin
      // create the new header object...
      NewHeader := TTLFileHeader.CreateNew(self, Header.FileImportFormat, Header.ImportMethod,
        NewTaxYear, Header.BaseCurrencyLocale, Header.Ira, Header.MTM, Header.SLConvert);
      // ...then copy some more settings
      NewHeader.OFXPassword := Header.OFXPassword;
      NewHeader.OFXUserName := Header.OFXUserName;
      NewHeader.OFXAccount := Header.OFXAccount;
      NewHeader.BrokerID := Header.BrokerID;
      NewHeader.AccountName := Header.AccountName;
      NewHeader.Commission := Header.Commission;
      NewHeader.MTMForFutures := Header.MTMForFutures; // 2023-04-13 MB
      NewHeader.AutoAssignShorts := Header.AutoAssignShorts;
      NewHeader.AutoAssignShortsOptions := Header.AutoAssignShortsOptions;
      // If we are creating a new header and the last year header was MTM then MTMLastYear is True.
      if Header.MTM then
        NewHeader.MTMLastYear := true;
      FTLFileHeaders.Add(NewHeader);
    end;
    CurrentBrokerID := 0;
  except
    if SuperUser then sm('error in TTLFile.CreateNextYear');
  end;
end;


constructor TTLFile.CreateNew(FileName, FileImportFormat : string; ImportMethod : TTLImportMethod;
  TaxYear : string; BaseCurrencyLocale : integer; IraAcct : boolean; MTM : boolean;
  SLConvert : boolean; StatusCallBack : TLBasicStatusCallBack = nil; Commission : double = 0);
var
  InitialHeader : TTLFileHeader;
begin
  try // except
    FStatusCallBack := StatusCallBack;
    Create;
    FFileName := FileName;
    InitialHeader := TTLFileHeader.CreateNew(self, FileImportFormat, ImportMethod, TaxYear,
      BaseCurrencyLocale, IraAcct, MTM, SLConvert, Commission);
    InitialHeader.BrokerID := 1;
    FTLFileHeaders.Add(InitialHeader);
    CurrentBrokerID := 0;
  except
    if SuperUser then sm('error in TTLFile.CreateNew');
  end;
end;


// Just used to initialize all variables. This is a private constructor
// that is called at the beginning of each public constructor to make
// sure initialization is complete
constructor TTLFile.Create;
begin
  try // except
    FTrades := TTradeList.Create;
    FTradesSaved := TTradeList.Create;
    FTradeNums := TTLTradeNumList.Create(self);
    FTLFileHeaders := TTLFileHeaders.Create;
    FFileName := '';
    FNoTimeInData := true;
    FMultiplierIsZero := false;
    FFileNeedsSaving := false;
    FFileCleaned := false;
    FShowStatus := true;
    FBrokerFiles := nil;
    FLastID := 0;
    FNegShareTrades := TTradeList.Create;
    FCancelledTrades := TTradeList.Create;
    FMisMatchedTrades := TTradeList.Create;
    FMisMatchedLS := TTradeList.Create;
    FZeroOrLessTrades := TTradeList.Create;
    glEditListItems := TList<integer>.Create;
    glEditListTicks := TStringList.Create;
  except
    if SuperUser then sm('error in TTLFile.Create');
  end;
end;


procedure TTLFile.CreateLists(Revert : boolean);
var
  Trade : TTLTrade;
  CurrentTradeNumber, i : integer;
  TradeNum : TTLTradeNum;
  bNegSh : boolean;
  t : string;
// --------------------------
  procedure reset_msgTxt;
  begin
    msgTxt := 'ID' + Tab + 'TrNum:' + Tab + 'ticker:' + Tab //
      + 'date:' + Tab // + 'time:' + tab
      + 'OC:' + Tab + 'LS:' + Tab //
      + 'shares:' + Tab + 'TypeMult:' + Tab //
      + 'Matched:' + Tab + 'broker:' + CRLF;
    i := 0;
  end;
// --------------------------
  procedure add_msgTxt;
  begin
    inc(i);
    msgTxt := msgTxt + IntToStr(Trade.ID) + Tab //
      + IntToStr(Trade.TradeNum) + Tab //
      + copy(Trade.Ticker, 1, 25) + Tab //
      + datetostr(Trade.Date) + Tab // + Trade.time + tab
      + Trade.oc + Tab + Trade.ls + Tab //
      + FloatToStr(Trade.Shares, Settings.UserFmt) + Tab //
      + Trade.TypeMult + Tab + Trade.Matched + Tab //
      + IntToStr(Trade.Broker) + CRLF;
  end;
// --------------------------
begin
  try // except
    FNegShareTrades.Clear;
    FZeroOrLessTrades.Clear;
    FMisMatchedTrades.Clear;
    FCancelledTrades.Clear;
    FTradeNums.Clear;
    FTradeNums.ClosedTradeNums.Clear;
    CurrentTradeNumber := 0;
    TradeNum := nil;
    if Revert then begin
      for Trade in FTrades do begin
        Trade.Free;
      end;
      FTrades.Clear;
      for Trade in FTradesSaved do begin
        FTrades.Add(TTLTrade.Create(Trade));
      end;
    end; // if revert
  // THIS NEEDS REFACTORING FOR SPEED -->
  // ALL WE NEED ARE AN OPEN AND CLOSED TRNUM TLIST RATHER THAN THIS HUGE CLASS
    DoStatus('Creating trade numbers');
    Screen.Cursor := crHourGlass;
    if superUser and (DEBUG_MODE > 8) then begin
      reset_msgTxt;
    end;
    for Trade in FTrades do begin
      if superUser and (DEBUG_MODE > 8) then begin
        add_msgTxt;
      end;
    // Verify the data in the trade and if not valid then add to an invalid list.
      VerifyTrade(Trade);
      if (Trade.TradeNum <> CurrentTradeNumber) then begin
        CurrentTradeNumber := Trade.TradeNum;
        if (TradeNum <> nil) // for first record TradeNum is nil
          and (TradeNum.Shares = 0) then begin
          FTradeNums.ClosedTradeNums.Add(FTradeNums.Extract(TradeNum));
        end;
        bNegSh := false;
        TradeNum := TTLTradeNum.Create;
        FTradeNums.Add(TradeNum);
      end;
    // if (TradeNum.Shares < 0) then
      if (compareValue(TradeNum.Shares, 0, NEARZERO) < 0) then
        bNegSh := true;
      TradeNum.Add(Trade);
    // if (TradeNum.Shares < 0)
      if (compareValue(TradeNum.Shares, 0, NEARZERO) < 0) or bNegSh then begin
        if superUser and (DEBUG_MODE > 8) then begin
        // t := clipBoard.AsText; // preserve
          clipboard.astext := 'trade # ' + IntToStr(i) + CR + msgTxt;
          sm('SuperUser: Paste to notepad' + CR //
              + 'Trade # ' + IntToStr(i) + CR //
              + copy(msgTxt, 1, 60000));
        // clipBoard.AsText := t; // restore
          clipboard.Clear;
          reset_msgTxt;
        end;
        Trade.HasNegShares := true;
        TradeNum.HasNegShares := true;
        FNegShareTrades.Add(Trade);
        bNegSh := false;
      end;
    end;
  // LAST record
    if (TradeNum <> nil) and (TradeNum.Shares = 0) then
      FTradeNums.ClosedTradeNums.Add(FTradeNums.Extract(TradeNum));
  // Finally set the next trade number.
    FTradeNums.NextTradeNum := CurrentTradeNumber + 1;
  // <-- END OF REFACTORING
    calcProfit;
  except
    if superUser then
      sm('error in TTLFile.CreateLists');
  end;
end;


// ----------------------------------------------
// call this after any edit to see if old issues
// were resolved or if new ones were created.
// ----------------------------------------------
procedure TTLFile.getNegShareList;
var
  TradeNum : TTLTradeNum;
  Trade : TTLTrade;
  iLastTrNum : integer;
  openSh : double;
  sType, sLS : string;
  function GetTypePart(sTypeMult : string): string;
  begin
    result := copy(sTypeMult, 1, pos('-', sTypeMult) - 1);
  end;
begin
  iLastTrNum := 0;
  openSh := 0;
  try // except
    FNegShareTrades.Clear;
    FCancelledTrades.Clear;
    FMisMatchedTrades.Clear;
    FMisMatchedLS.Clear;
    // --- check ALL Trades -------------
    for Trade in FTrades do begin
      if (Trade.TradeNum <> iLastTrNum) then begin
        iLastTrNum := Trade.TradeNum;
        openSh := 0;
        sType := Trade.TypeMult;
        sLS := Trade.ls;
      end
      else begin
        if (Trade.TypeMult <> sType) then begin
          if ((GetTypePart(Trade.TypeMult) = 'STK') //
          and (GetTypePart(Trade.TypeMult) <> GetTypePart(sType)))
          // DE 2015-12-07 currencies can have diff multipliers
          or ((GetTypePart(Trade.TypeMult) = 'CUR') //
          and (GetTypePart(Trade.TypeMult) <> GetTypePart(sType))) //
          then
            FMisMatchedTrades.Add(Trade); // mismatched type
        end;
        // mismatched LS
        if Trade.ls <> sLS then begin
          FMisMatchedLS.Add(Trade);
        end;
      end;
      if (Trade.oc = 'C') or (Trade.oc = 'M') then
        openSh := openSh - Trade.Shares
      else
        openSh := openSh + Trade.Shares;
      // if (openSh < 0) then
      if (compareValue(openSh, 0, NEARZERO) < 0) then begin
        Trade.HasNegShares := true;
        FNegShareTrades.Add(Trade);
      end;
      // check for cancelled trades
      if (Trade.oc = 'X') then
        FCancelledTrades.Add(Trade);
    end;
  except
    if SuperUser then sm('error in getNegShareList');
  end;
end;


{ Create with a valid file that already exists }
constructor TTLFile.OpenFile(FileName : string; StatusCallBack : TLBasicStatusCallBack = nil);
var
  i : integer;
  ck : TCheckList;
  Header, Header2 : TTLFileHeader;
  sErr : string;
begin
  try
    FStatusCallBack := StatusCallBack;
    sErr := 'create file in memory.';
    Create;
    sErr := '';
    if pos('\', FileName) > 0 then begin
      FFileName := ExtractFileName(FileName);
      sErr := 'change file directory.';
      Settings.DataDir := ExtractFilePath(FileName);
      sErr := '';
    end
    else
      FFileName := FileName;
    NeedToSave := false;
    bFoundBlankType := false;
    if not FileExists(FFileName) then
      raise ETLFileException.Create('The request file could not be found: ' + FileName +
          ' To create a new file call the CreateNew method.');
    sErr := 'read file into memory.';
    ReadFile(FFileName);
    sErr := '';
    if FBrokerFiles <> nil then begin
      // This is a combined file that needs to be recreated so go for it.
      sErr := 're-create file headers in memory.';
      FTLFileHeaders.Clear;
      sErr := 'clearing trades in memory.';
      FTrades.Clear;
      sErr := '';
      try
        ReadFile(FBrokerFiles[0], true);
        for i := 1 to FBrokerFiles.Count - 1 do
          AddFile(FBrokerFiles[i]);
      except
        raise ETLFileCombineConvertException.Create('Possible Missing File(s):' + CR +
            FBrokerFiles.Text);
      end;
    end;
    // Set the current Broker to zero which means all brokers.
    CurrentBrokerID := 0;
    // If this is the very old dat file extension then replace the extension.
    if ExtractFileExt(FFileName) = 'dat' then begin
      ChangeFileExt(FFileName, '.tdf');
      NeedToSave := true;
    end;
    { If this is not a multibroker file and the account name is blank then this is a file
      that was converted from an earlier version and we need to set the account name to the file name
      minus year and extension. }
    if not MultiBrokerFile and (length(FTLFileHeaders[0].FAccountName) = 0) then begin
      sErr := 'change file metadata.';
      FTLFileHeaders[0].FAccountName := copy(FFileName, 6, length(FFileName) - 9);
      FTLFileHeaders[0].FAccountNameChanged := true;
      NeedToSave := true;
      sErr := '';
    end
    else begin
      // Otherwise just make sure all account names have been converted
      // and year and extension removed
      sErr := 'update file headers.';
      for Header in FTLFileHeaders do begin
        if RightStr(Header.AccountName, 4) = '.tdf' then begin
          { this is the old file name lopp off the year and extenstion
            Use the FAccountName private variable to avoid the unique name issue }
          Header.FAccountName := copy(Header.AccountName, 6, length(Header.AccountName) - 9);
          Header.FAccountNameChanged := true;
          NeedToSave := true;
        end;
      end;
    end;
    if MultiBrokerFile then begin
      for Header in FTLFileHeaders do begin
        if FTLFileHeaders.First.ImportFilter.BaseCurrLCID <> Header.ImportFilter.BaseCurrLCID then
          raise ETLFileException.Create('Accounts have Differing Currency Types.');
      end;
    end;
    sErr := '';
    NeedToSave := (NeedToSave or VerifyEOYCheckList);
    if NeedToSave or bFoundBlankType then begin
      FFileNeedsSaving := true;
      DoStatus('Saving file...');
      sErr := 'save file.';
      SaveFile(true);
      sErr := '';
    end;
  except
    on E : Exception do begin
      if sErr = '' then
        sm('Error attempting to Open File.' + CR + E.Message)
      else
        sm('Error in Open File while attempting to ' + sErr + CR + E.Message);
    end;
  end;
end; // OpenFile


procedure TTLFile.DeleteAccount;
begin
  if CurrentBrokerID > 0 then
    DeleteAccount(CurrentBrokerID)
  else
    raise ETLFileException.Create('Cannot delete account when there is no current account set');
end;


procedure TTLFile.DeleteAccount(BrokerID : integer);
var
  i : integer;
  Trade : TTLTrade;
  Header : TTLFileHeader;
begin
  if BrokerID > 0 then begin
    DoStatus('Deleting all records for account: ' + CurrentAccount.AccountName);
    try
      ClearAll(false);
      DoStatus('Removing Account Information');
      for i := FTLFileHeaders.Count - 1 downto 0 do begin
        if FTLFileHeaders[i].BrokerID = BrokerID then begin
          Header := FTLFileHeaders.Extract(FTLFileHeaders[i]);
          Header.Free;
          break;
        end;
      end;
      // Just in case we just deleted the current Broker Account then reset current broker to zero.
      if BrokerID = CurrentBrokerID then
        CurrentBrokerID := 0;
    finally
      DoStatus('off');
    end;
  end;
end;


procedure TTLFile.DeleteAllAccountsByType(AccountType : TTLAccountType);
var
  i : integer;
begin
  for i := FTLFileHeaders.Count - 1 downto 0 do begin
    case AccountType of
    atIRA :
      if FTLFileHeaders[i].Ira then begin
        CurrentBrokerID := FTLFileHeaders[i].BrokerID;
        DeleteAccount;
      end;
    atMTM :
      if FTLFileHeaders[i].MTM then begin
        CurrentBrokerID := FTLFileHeaders[i].BrokerID;
        DeleteAccount;
      end;
    atCash :
      if not FTLFileHeaders[i].Ira and not FTLFileHeaders[i].MTM then begin
        CurrentBrokerID := FTLFileHeaders[i].BrokerID;
        DeleteAccount;
      end;
    end;
  end;
end;


function TTLFile.DeleteTrade(Trade : TTLTrade; resetChkLst : boolean = true): boolean;
var
  i : integer;
begin
  i := FTrades.IndexOf(Trade);
  result := i > -1;
  try // except
    if result then begin
      // Remove myself from the TradeNum List I am attached to.
      if FTrades[i].FTLTradeNum <> nil then begin
        // added try...except to trap errors - 2016-03-23 MB
        try
          FTrades[i].FTLTradeNum.Extract(FTrades[i]);
        except
          on E : Exception do begin
            if (1 = 0) then // only show to SuperUser; disabled - 2016-03-23 MB
              ShowMessage('Error in DeleteTrade' + CRLF //
                + 'Exception class name = ' + E.ClassName + CRLF //
                + 'Exception message = ' + E.Message);
          end;
        end;
      end;
      // Also if this was a cancelled trade being deleted then remove it from the Cancelled Trade List.
      if (FCancelledTrades.IndexOf(Trade) > -1) then
        FCancelledTrades.Remove(Trade);
      // Also remove from Mismatched Trades list.
      if (FMisMatchedTrades.IndexOf(Trade) > -1) then
        FMisMatchedTrades.Remove(Trade);
      // Also remove from Mismatched LS list.
      if (FMisMatchedLS.IndexOf(Trade) > -1) then
        FMisMatchedLS.Remove(Trade);
      // Remove trade from ZeroOrLess list if it exists.
      if (FZeroOrLessTrades.IndexOf(Trade) > -1) then
        FZeroOrLessTrades.Remove(Trade);
      FTrades[i].Free;
      FTrades.delete(i);
      if resetChkLst then
        FileHeader[Trade.Broker].ResetCheckList;
    end;
  except
    if SuperUser then sm('error in x');
  end;
end;


destructor TTLFile.Destroy;
var
  Trade : TTLTrade;
begin
  try // except
    // Trade Numbers list and Closed Trade Numbers list.
    FreeAndNil(FTradeNums);
    // Since the FTLFileHeaders List is an object list it will free it's elements automatically.
    FreeAndNil(FTLFileHeaders);
    // Since the TTradeList is not an Object List we need to explicitly free each trade.
    for Trade in FTradesSaved do begin
      if Trade <> nil then
        Trade.Free;
    end;
    FreeAndNil(FTrades);
    FreeAndNil(FTradesSaved);
    FreeAndNil(FBrokerFiles);
    FreeAndNil(FCancelledTrades);
    FreeAndNil(FMisMatchedTrades);
    FreeAndNil(FMisMatchedLS);
    FreeAndNil(FZeroOrLessTrades);
    FreeAndNil(FNegShareTrades);
    // added 2015-08-01 so we can edit multiple records
    FreeAndNil(glEditListItems);
    FreeAndNil(glEditListTicks);
    inherited;
  except
    if SuperUser then sm('error in x');
  end;
end;


procedure TTLFile.DoStatus(Msg : string);
begin
  try
    if FShowStatus then begin
      if Assigned(FStatusCallBack) then
        FStatusCallBack(Msg);
    end;
  except
    if SuperUser then sm('error in TTLFile.DoStatus');
  end;
end;


function TTLFile.GetInvalidOptionTickers : string;
var
  i : integer;
  s : string;
begin
  result := '';
  try
  for i := 0 to FTrades.Count - 1 do begin
    // Skip of not in current broker
    if (CurrentBrokerID > 0) and (FTrades[i].Broker <> CurrentBrokerID) then
      continue;
    s := FTrades[i].TypeMult;
    if ((pos('OPT', s) = 1) or ((pos('FUT', s) = 1) and ((pos('PUT', s) > 0) or (pos('CALL', s) > 0)
          ))) and not CheckOptionFormat(FTrades[i].Ticker) then begin
      if length(result) > 0 then
        result := result + ',';
      result := result + IntToStr(FTrades[i].ID);
    end;
  end;
  except
    if SuperUser then sm('Error in GetInvalidOptionTickers');
  end;
end;


function TTLFile.GetOptionTypeDiscrepancies : string;
var
  i, j : integer;
  x, y : TStringList;
  s, t : string;
begin
  result := '';
  x := TStringList.Create;
  y := TStringList.Create;
  for i := 0 to FTrades.Count - 1 do begin
    s := copy(FTrades[i].TypeMult, 1, 3); // the trade type
    t := FTrades[i].Ticker; // the ticker
    if ((pos('FUT', s) = 1) and ((pos('PUT', s) > 0) or (pos('CALL', s) > 0))) or (pos('OPT', s) = 1)
    then begin
      t := parseUnderlying(t); // the underlying ticker
      j := x.IndexOf(t); // is it already in the list?
      if j >= 0 then begin
        if y[j] = s then
          continue; // does the type match?
        if length(result) > 0 then
          result := result + ',';
        result := result + t; // error
      end
      else begin
        x.Add(t);
        y.Add(s);
      end;
    end;
  end;
  x.Free;
  y.Free;
end;


function TTLFile.GetLastDateImported : TDate;
var
  Trade : TTLTrade;
begin
  result := xStrToDate('01/01/1970', Settings.InternalFmt);
  for Trade in FTrades do begin
    if ((CurrentBrokerID = 0) or (CurrentBrokerID = Trade.Broker)) and (Trade.Date > result) then
      result := Trade.Date;
  end;
end;


function TTLFile.GetLastTaxYear : integer;
begin
  result := TaxYear - 1;
end;


function TTLFile.GetBrokerIDByName(BrokerName : string): integer;
var
  i : integer;
begin
  result := 0;
  // Note: added begin...end to make code easier to read - 2016-05-06 MB
  for i := 0 to FTLFileHeaders.Count - 1 do begin
    if FTLFileHeaders.Items[i].AccountName = BrokerName then begin
      result := FTLFileHeaders.Items[i].BrokerID;
      break; // also added 'break' for speed - no need to keep looking!
    end;
  end;
end;


function TTLFile.GetMisMatchedTrades : TTradeList;
begin
  result := FMisMatchedTrades;
end;


function TTLFile.GetMisMatchedLS : TTradeList;
begin
  result := FMisMatchedLS;
end;


function TTLFile.GetMTMClosedPositions(AsOfDate : TDate): TTLTradeNumList;
var
  TradeNum : TTLTradeNum;
begin
  result := TTLTradeNumList.Create(self, false);
  for TradeNum in FTradeNums.ClosedTradeNums do begin
    if (FCurrentBroker > 0) and (FCurrentBroker <> TradeNum.BrokerID) then
      continue;
    if (TradeNum.Date <= AsOfDate) and (TradeNum.SharesAsOf[AsOfDate] = 0) and
      (TradeNum.Last.oc = 'M') then
      result.Add(TradeNum);
  end;
end;


function TTLFile.GetMTMStatus(Year : integer): boolean;
var
  i : integer;
  y, m, D : Word;
begin
  result := false;
  for i := 0 to FTrades.Count - 1 do begin
    DecodeDate(FTrades[i].Date, y, m, D);
    if (y = Year) and (FTrades[i].oc = 'M') and
      ((FCurrentBroker = 0) or (FCurrentBroker = FTrades[i].Broker)) then begin
      result := true;
      break;
    end;
  end;
end;


function TTLFile.GetMultiBrokerFile : boolean;
begin
  result := FTLFileHeaders.Count > 1;
end;


function TTLFile.GetMultiplierAsDouble(Mult : string; CurrencySmbl : string): double;
var
  D : string;
begin
  D := CurrencySmbl;
  while (pos(D, Mult) > 0) do
    delete(Mult, pos(D, Mult), length(D));
  D := Settings.UserFmt.ThousandSeparator;
  while (pos(D, Mult) > 0) do
    delete(Mult, pos(D, Mult), length(D));
  result := StrToFloat(Mult, Settings.UserFmt);
end;


function TTLFile.GetNextExerciseTag : string;
var
  Trade : TTLTrade;
  i : integer;
  s : string;
begin
  i := 0;
  for Trade in FTrades do begin
    if pos('Ex-', Trade.Matched) = 1 then begin
      s := copy(Trade.Matched, 4);
      if isInt(s) and (StrToInt(s) > i) then
        i := StrToInt(s);
    end;
  end;
  result := 'Ex-' + IntToStr(i + 1);
end;


function TTLFile.GetNextID : integer;
begin
  inc(FLastID);
  result := FLastID;
end;


function TTLFile.GetNextMatchNumber : integer;
var
  Trade : TTLTrade;
begin
  result := 0;
  for Trade in FTrades do begin
    if isInt(Trade.Matched) then begin
      if StrToInt(Trade.Matched) > result then
        result := StrToInt(Trade.Matched);
    end;
  end;
  inc(result);
end;


function TTLFile.GetNextTaxYear : integer;
begin
  result := TaxYear + 1;
end;


// ----------------------------------------------
// Find the Open Positions here!
// ----------------------------------------------
function TTLFile.GetOpenPositions(AsOfDate : TDate): TTLTradeNumList;
var
  i : integer;
  TradeNum : TTLTradeNum;
  Qty : double;
begin
  result := TTLTradeNumList.Create(self, false);
  if AsOfDate >= LastDateImported then begin
    for TradeNum in FTradeNums do begin
      if (FCurrentBroker > 0) and (FCurrentBroker <> TradeNum.BrokerID) then
        continue;
      Qty := TradeNum.Shares;
      if (compareValue(Qty, 0, NEARZERO) > 0) then begin
        result.Add(TradeNum);
      end;
    end;
  end
  else begin
    // First Loop through the Open Positions and if the As Of Date is Greater than the
    // open date then it is still valid
    for TradeNum in FTradeNums do begin
      if (FCurrentBroker > 0) //
      and (FCurrentBroker <> TradeNum.BrokerID) //
      then begin
        continue;
      end;
      if (TradeNum.Date <= AsOfDate) //
      and (compareValue(TradeNum.SharesAsOf[AsOfDate], 0, NEARZERO) > 0) //
      then begin
        result.Add(TradeNum);
      end;
    end;
    for TradeNum in FTradeNums.ClosedTradeNums do begin
      if (FCurrentBroker > 0) and (FCurrentBroker <> TradeNum.BrokerID) then
        continue;
      if (TradeNum.Date <= AsOfDate) and (TradeNum.LastDate > AsOfDate)
      // and (TradeNum.SharesAsOf[AsOfDate] > 0) then
        and (compareValue(TradeNum.SharesAsOf[AsOfDate], 0, NEARZERO) > 0) then
        result.Add(TradeNum);
    end;
  end;
end;


function TTLFile.GetOpenTrades : TTradeList;
var
  TradeNum : TTLTradeNum;
  i : integer;
  OpenShares : double;
  Trade : TTLTrade;
  NewTradeNum : TTLTradeNum;
begin
  result := TTradeList.Create;
  for TradeNum in FTradeNums do begin
    if (FCurrentBroker > 0) and (TradeNum.BrokerID <> FCurrentBroker) then
      continue;
    { Walk backwards through the trades and just get Open records with Open Shares left on them }
    OpenShares := TradeNum.Shares;
    NewTradeNum := TTLTradeNum.Create;
    for i := TradeNum.Count - 1 downto 0 do begin
      // Create a new trade record because we will modify it and don't want to modify the underlying one.
      Trade := TTLTrade.Create(TradeNum[i]);
      if TradeNum[i].oc = 'O' then begin
        if (TradeNum[i].Shares = OpenShares) then begin
          result.Add(Trade);
          NewTradeNum.Add(Trade);
          break;
        end
        else if(TradeNum[i].Shares > OpenShares) then begin
          Trade.Shares := OpenShares;
          Trade.Commission := OpenShares / TradeNum[i].Shares * TradeNum[i].Commission;
          Trade.CalcAmount;
          result.Add(Trade);
          NewTradeNum.Add(Trade);
          break;
        end
        else if (TradeNum[i].Shares < OpenShares) then begin
          result.Add(Trade);
          NewTradeNum.Add(Trade);
          OpenShares := OpenShares - Trade.Shares;
        end;
      end;
    end;
    // Now add a closing record for the open Trade.
    Trade := TTLTrade.Create;
    Trade.oc := 'C';
    Trade.Ticker := TradeNum.Ticker;
    Trade.Date := Date;
    Trade.ls := TradeNum.ls;
    Trade.Shares := TradeNum.Shares;
    Trade.OptionTicker := TradeNum.OptionTicker;
    Trade.TypeMult := TradeNum.TypeMult;
    Trade.TradeNum := TradeNum.TradeNum;
    Trade.ID := TradeNum.Last.ID + 1;
    Trade.Broker := TradeNum.BrokerID;
    NewTradeNum.Add(Trade, false);
    result.Add(Trade);
  end; { for TradeNum In FTradeNums }
  result.SortByTrNumber;
end;


function TTLFile.GetRecordLimitExceeded : boolean;
begin
  if Settings.RecLimit = '' then
    result := false
  else
    result := Count > StrToInt(Settings.RecLimit);
end;


function TTLFile.GetCancelledTrades : TTradeList;
begin
  result := FCancelledTrades;
end;


function TTLFile.GetNegShareTrades : TTradeList;
begin
  result := FNegShareTrades;
end;


function TTLFile.GetCheckListOn : boolean;
var
  Header : TTLFileHeader;
begin
  for Header in FTLFileHeaders do begin
    if not Header.BeforeCheckList then
      Exit(true);
  end;
  result := false;
end;


function TTLFile.GetCostBasis1099LTAllBrokers : string;
var
  i : integer;
  F : Extended;
  B : boolean;
begin
  B := false;
  F := 0;
  result := '';
  for i := 0 to FTLFileHeaders.Count - 1 do begin
    if (IsFloat(FTLFileHeaders[i].CostBasis1099LT)) and not FTLFileHeaders[i].Ira then begin
      B := true;
      F := F + StrToFloat(FTLFileHeaders[i].CostBasis1099LT);
    end;
  end;
  if B then
    result := FloatToStr(F);
end;


function TTLFile.GetCostBasis1099STAllBrokers : string;
var
  i : integer;
  F : Extended;
  B : boolean;
begin
  B := false;
  result := '';
  F := 0;
  for i := 0 to FTLFileHeaders.Count - 1 do begin
    if (IsFloat(FTLFileHeaders[i].CostBasis1099ST)) and not FTLFileHeaders[i].Ira then begin
      B := true;
      F := F + StrToFloat(FTLFileHeaders[i].CostBasis1099ST);
    end;
  end;
  if B then
    result := FloatToStr(F);
end;


function TTLFile.GetCount : integer;
begin
  result := FTrades.Count;
end;


function TTLFile.GetCurrentAcctHasRecords : boolean;
var
  Trade : TTLTrade;
begin
  if CurrentBrokerID = 0 then
    Exit(FTrades.Count > 0)
  else begin
    for Trade in FTrades do begin
      if Trade.Broker = CurrentBrokerID then
        Exit(true);
    end;
  end;
end;


function TTLFile.GetCurrentAcctName : string;
var
  Header : TTLFileHeader;
begin
  result := '';
  if CurrentBrokerID = 0 then begin
    for Header in FTLFileHeaders do begin
      if (length(result) > 0) then
        result := result + ', ';
      result := result + Header.AccountName;
    end;
  end
  else
    result := CurrentAccount.AccountName;
end;


function TTLFile.GetCurrentAcctType : string;
begin
  if CurrentBrokerID = 0 then
    result := 'ALL'
  else begin
    if CurrentAccount.MTM then
      result := 'MTM'
    else if CurrentAccount.Ira then
      result := 'IRA'
    else
      result := 'CASH';
  end
end;


function TTLFile.GetCurrentBaseCurrencyFmt : TFormatSettings;
var
  i : integer;
  BaseCurrLCID : integer;
begin
  { If we are on s specific broker account and they support non US currency,
   then return the appropriate Fmt }
  if (CurrentBrokerID > 0) and (CurrentAccount.ImportFilter.SupportsFlexibleCurrency) and
    (CurrentAccount.ImportFilter.BaseCurrLCID <> EnglishUS) then
    GetLocaleFormatSettings(TradeLogFile.CurrentAccount.ImportFilter.BaseCurrLCID, result)
  else if (CurrentBrokerID = 0) and (FileHeaders.Count > 0) and
    (FileHeaders[0].ImportFilter.SupportsFlexibleCurrency) and
    (FileHeaders[0].ImportFilter.BaseCurrLCID <> EnglishUS) then begin
    { If we are on all brokers and the first broker supports non US,
     then see if all do, and if they all match, if so return the matching Fmt }
    BaseCurrLCID := FileHeaders[0].ImportFilter.BaseCurrLCID;
    for i := 1 to FileHeaders.Count - 1 do begin
      if (not FileHeaders[i].ImportFilter.SupportsFlexibleCurrency) or
        (BaseCurrLCID <> FileHeaders[i].BaseCurrencyLocale) then begin
        Exit(Settings.InternalFmt);
      end;
    end;
    { If we got here then all support flexible currency and all match so return the matching fmt }
    GetLocaleFormatSettings(BaseCurrLCID, result);
  end
  else
    result := Settings.InternalFmt;
end;


function TTLFile.GetCurrentHeader : TTLFileHeader;
begin
  if (CurrentBrokerID = 0) then
    raise ETLFileException.Create
      ('Current Header is not available when Current Broker ID is set to Zero');
  result := FCurrentHeader;
end;


function TTLFile.GetEarliestDate : TDate;
var
  Trade : TTLTrade;
begin
  if FTrades.Count = 0 then
    Exit(EncodeDate(TaxYear, 1, 1));
  result := FTrades[0].Date;
  for Trade in FTrades do begin
    if Trade.Date < result then
      result := Trade.Date;
  end;
end;


function TTLFile.GetFileHeader(BrokerID : integer): TTLFileHeader;
var
  i : integer;
begin
  result := nil;
  for i := 0 to FTLFileHeaders.Count - 1 do begin
    if FTLFileHeaders.Items[i].BrokerID = BrokerID then begin
      result := FTLFileHeaders.Items[i];
      Exit;
    end;
  end;
end;


function TTLFile.GetFileHeaderIndex(BrokerID : integer): integer;
var
  i : integer;
begin
  result := -1;
  for i := 0 to FTLFileHeaders.Count - 1 do begin
    if FTLFileHeaders.Items[i].BrokerID = BrokerID then
      result := i;
  end;
end;


function TTLFile.GetGrossSales1099AllBrokers : string;
var
  i : integer;
  F : Extended;
  B : boolean;
begin
  B := false;
  result := '';
  F := 0;
  for i := 0 to FTLFileHeaders.Count - 1 do begin
    if IsFloat(FTLFileHeaders[i].GrossSales1099) then begin
      B := true;
      F := F + StrToFloat(FTLFileHeaders[i].GrossSales1099);
    end;
  end;
  if B then
    result := FloatToStr(F);
end;


function TTLFile.GetHasAccountType(AccountType : TTLAccountType): boolean;
var
  Header : TTLFileHeader;
begin
  result := false;
  for Header in FTLFileHeaders do begin
    case AccountType of
    atMTM :
      if Header.MTM then
        Exit(true);
    atIRA :
      if Header.Ira then
        Exit(true);
    atCash :
      if not Header.MTM and not Header.Ira then
        Exit(true);
    end;
  end;
end;

function TTLFile.GetIsAllMTM(): boolean;
var
  Header : TTLFileHeader;
begin
  result := true;
  for Header in FTLFileHeaders do begin
    if not Header.MTM then
      Exit(false);
  end;
end;


// ====================================
function TTLFile.GetHasAnyTradeIssues : boolean;
begin
  if HasNegShares then
    Exit(true);
  if HasCancelledTrades then
    Exit(true);
  if HasInvalidOptionTickers then
    Exit(true);
  if HasMisMatchedTypes then
    Exit(true);
  if HasZeroOrLessTrades then
    Exit(true);
  result := false; // if it gets this far 2015-04-03 MB
end;


function TTLFile.GetHasCancelledTrades : boolean;
var
  Trade : TTLTrade;
begin
  result := false;
  try
  if (FCurrentBroker = 0) and (FCancelledTrades.Count > 0) then
    Exit(true);
  for Trade in FCancelledTrades do begin
    if (Trade.Broker = FCurrentBroker) then
      Exit(true);
  end;
  except
    if SuperUser then sm('Error in GetHasCancelledTrades');
  end;
end;


function TTLFile.GetHasNegShareTrades : boolean;
var
  Trade : TTLTrade;
begin
  result := false;
  try
  if (FCurrentBroker = 0) and (FNegShareTrades.Count > 0) then
    Exit(true);
  except
    sm('Error in GetHasNegShareTrades count');
  end;
  try
  for Trade in FNegShareTrades do begin
    if (Trade.Broker = FCurrentBroker) then
      Exit(true);
  end;
  except
    if SuperUser then sm('Error in GetHasNegShareTrades loop');
  end;
end;


function TTLFile.GetHasInvalidOptionTickers : boolean;
begin
  result := length(GetInvalidOptionTickers) > 0;
end;


function TTLFile.GetHasMisMatchedTypes : boolean;
var
  Trade : TTLTrade;
begin
  result := false;
  try
  if (FCurrentBroker = 0) and (FMisMatchedTrades.Count > 0) then
    Exit(true);
  for Trade in FMisMatchedTrades do begin
    if (Trade.Broker = FCurrentBroker) then
      Exit(true);
  end;
  except
    if SuperUser then sm('Error in GetHasMisMatchedTypes');
  end;
end;


function TTLFile.GetHasMisMatchedLS : boolean;
var
  Trade : TTLTrade;
begin
  result := false;
  try
  if (FCurrentBroker = 0) and (FMisMatchedLS.Count > 0) then
    Exit(true);
  for Trade in FMisMatchedLS do begin
    if (Trade.Broker = FCurrentBroker) then
      Exit(true);
  end;
  except
    if SuperUser then sm('Error in GetHasMisMatchedLS');
  end;
end;


function TTLFile.GetHasMTMLastYear : boolean;
begin
  result := GetMTMStatus(LastTaxYear);
end;


function TTLFile.GetHasMTMThisYear : boolean;
begin
  result := GetMTMStatus(TaxYear);
end;


function TTLFile.GetHasNegShares : boolean;
var
  TradeNum : TTLTradeNum;
begin
  result := false;
  DoStatus('Searching For Trade Match Errors');
  Screen.Cursor := crHourGlass;
  try
    for TradeNum in FTradeNums do begin
      if ((FCurrentBroker = 0) or (TradeNum.BrokerID = FCurrentBroker)) and (TradeNum.HasNegShares)
      then begin
        result := true;
        Exit;
      end;
    end;
  finally
    DoStatus('off');
  end;
end;


function TTLFile.GetHasOptions : boolean;
var
  Trade : TTLTrade;
begin
  result := false;
  try
  for Trade in FTrades do begin
    if ((FCurrentBroker = 0) or (FCurrentBroker = Trade.Broker)) and
      IsOption(Trade.TypeMult, Trade.Ticker) then
      Exit(true);
  end;
  except
    if SuperUser then sm('Error in GetHasOptions');
  end;
end;

// ----------------------------------------------
// 2018-06-01 MB - New func
// ----------------------------------------------
function TTLFile.GetHasCTNType : boolean;
var
  Trade : TTLTrade;
begin
  result := false;
  for Trade in FTrades do begin
    if ((FCurrentBroker = 0) or (FCurrentBroker = Trade.Broker)) and (pos('CTN', Trade.TypeMult) = 1)
    then
      Exit(true);
  end;
end;

function TTLFile.GetHasVTNType : boolean;
var
  Trade : TTLTrade;
begin
  result := false;
  for Trade in FTrades do begin
    if ((FCurrentBroker = 0) or (FCurrentBroker = Trade.Broker)) and (pos('VTN', Trade.TypeMult) = 1)
    then
      Exit(true);
  end;
end;


function TTLFile.GetHasZeroOrLessTrades : boolean;
var
  Trade : TTLTrade;
begin
  result := false;
  try
  if (FCurrentBroker = 0) and (FZeroOrLessTrades.Count > 0) then
    Exit(true);
  for Trade in FZeroOrLessTrades do begin
    if (Trade.Broker = FCurrentBroker) then
      Exit(true);
  end;
  except
    if SuperUser then sm('Error in GetHasZeroOrLessTrades');
  end;
end;


function TTLFile.GetTaxYear : integer;
var
  y, m, D : Word;
begin
  if FTLFileHeaders.Count > 0 then
    result := StrToInt(FTLFileHeaders[0].TaxYear)
  else begin
    DecodeDate(now, y, m, D);
    result := y;
  end;
end;


function TTLFile.GetTrade(Index : integer): TTLTrade;
begin
  result := FTrades[index];
end;


function TTLFile.GetUSCurrency : boolean;
begin
  { All Brokers should have the same currency type
   So if Zero is US then all should be. }
  if CurrentBrokerID = 0 then
    Exit(FTLFileHeaders[0].IsUSCurrency);
  result := CurrentAccount.IsUSCurrency;
end;


function TTLFile.GetYearEndDone : boolean;
begin
  result := FileHeaders[0].YearEndDone;
end;


function TTLFile.GetZeroOrLessTrades : TTradeList;
begin
  result := FZeroOrLessTrades;
end;


{ Sets ID, TradeNum, Broker if not already set }
procedure TTLFile.InitializeTrade(var Trade : TTLTrade);
begin
  if (Trade.Broker = 0) then begin
    if (CurrentBrokerID > 0) then
      Trade.Broker := CurrentAccount.BrokerID
    else
      raise ETLFileException.Create('You cannot add a trade when the current Broker ID is zero');
  end;
  { When doing an add trade we will assume that we always need a new Id even if one is provided }
  { Get the next tradenum for now }
  if Trade.TradeNum = 0 then
    Trade.TradeNum := FTradeNums.NextTradeNum;
  if Trade.ID = 0 then
    Trade.ID := NextID;
  if Trade.oc <> 'W' then
    Trade.CalcAmount;
end;


function TTLFile.InsertTrade(RecNum : integer; Trade : TTLTrade): integer;
begin
  { Insert Record Num is out of range so just add this trade to the end of the file }
  if (RecNum < 0) or (RecNum > Count) then begin
    result := AddTrade(Trade);
    Exit;
  end;
  { Sets ID, TradeNum, Broker if not already set }
  InitializeTrade(Trade);
  FTrades.Insert(RecNum, Trade);
  result := RecNum;
  FileHeader[Trade.Broker].ResetCheckList;
end;


function TTLFile.MakeTradeRowHeadings : string;
begin // columns when pasted into Excel
  result := 'UniqueID' + Tab + // A
    'TrNum' + Tab + // B
    'Date' + Tab + // C
    'Time' + Tab + // D
    'O/C' + Tab + // E
    'L/S' + Tab + // F
    'Ticker' + Tab + // G
    'Sh/Contr' + Tab + // H
    'Price' + Tab + // I
    'Type/Mult' + Tab + // J
    'Comm' + Tab + // K
    'Amount' + Tab + // L
    'Notes' + Tab + // M
    'Matched Lots' + Tab + // N
    'Broker Account' + Tab + // O
    'Opt OPRA Symbol' + Tab + // P
    'Strategy' + Tab + // Q
    'ABC'; // R
end;


function TTLFile.MakeTradeRowLine(TradeRow : TTLTrade): string;
var
  abcStr, s : string;
const
  myCodes : set of Char = ['A' .. 'F'];
begin
  with TradeRow do begin
    // --------------------------------
    s := leftstr(ABCCode + '   ', 3);
    // this is fix for writing extra lines with writeln
    if (s[1] in myCodes) then
      abcStr := s[1]
    else
      abcStr := ' ';
    // --------------------------------
    if (s[2] = 'X') then
      abcStr := abcStr + 'X'
    else
      abcStr := abcStr + ' ';
    // --------------------------------
    if (s[3] = 'L') then
      abcStr := abcStr + 'L'
    else if (s[3] = 'S') then
      abcStr := abcStr + 'S'
    else
      abcStr := abcStr + ' ';
    // --------------------------------
    // remove quotes!
    if pos('"', Note) > 0 then
      Note := ReplaceStr(Note, '"', '');
    // columns when pasted into Excel.....................
    result := IntToStr(ID) + Tab + // A
      IntToStr(TradeNum) + Tab + // B
      datetostr(FDate, Settings.InternalFmt) + Tab + // C
      UserTimeToInternalTime(Time, true) + Tab + // D
      oc + Tab + // E
      ls + Tab + // F
      Ticker + Tab + // G
      FloatToStr(Shares, Settings.InternalFmt) + Tab + // H
      FloatToStr(Price, Settings.InternalFmt) + Tab + // I
      TypeMult + Tab + // J
      Trim(format('%8.2f', [Commission], Settings.InternalFmt)) + Tab + // K
      FloatToStr(Amount, Settings.InternalFmt) + Tab + // L
      Note + Tab + // M
      Matched + Tab + // N
      IntToStr(Broker) + Tab + // O
      OptionTicker + Tab + // P
      strategy + Tab + // Q
      abcStr + Tab + // R
      FWSHoldingDate; // S
  end;
end;


function TTLFile.Match(Trades : TTradeList; ForceMatch, FixTradesOOOrder : boolean): TTradeList;
var
  Managed : boolean;
begin
  Managed := false;
  try
    if Trades = FTrades then begin
      Trades := TTradeList.Create;
      Trades.AddRange(FTrades);
      Managed := true;
    end;
    result := TradeNums.Match(Trades, ForceMatch, FixTradesOOOrder);
  finally
    if Managed then
      Trades.Free;
  end;
end;


function TTLFile.Match(Tickers : TStringList; ForceMatch, FixTradesOOOrder : boolean): TTradeList;
begin
  result := TradeNums.Match(Tickers, ForceMatch, FixTradesOOOrder)
end;


function TTLFile.Match(Ticker : string; ForceMatch, FixTradesOOOrder : boolean): TTradeList;
var
  List : TStringList;
begin
  List := TStringList.Create;
  try
    List.Add(Ticker);
    result := Match(List, ForceMatch, FixTradesOOOrder);
  finally
    List.Free;
  end;
end;


function TTLFile.MatchAll(ForceMatch, FixTradesOOOrder : boolean) : TTradeList;
begin
  result := TradeNums.MatchAll(ForceMatch, FixTradesOOOrder);
end;


// ----------------------------------------------
// Read one line of TDF data into TradeLog.
// ----------------------------------------------
function TTLFile.ReadDataLine(Line : string; Fmt : TFormatSettings; pBrokerID : integer;
  BrokerOverride : boolean = false; LastTrNumber : integer = 0) : TTLTrade;
var
  t, p : integer;
  NumRecs : integer;
  Trade : TTLTrade;
  Value, BrString, exDay, sJunk : string;
  D : TDateTime;
begin
  result := nil;
  t := countTabs(Line);
  if (Line = '') or (t = 0) or (pos('12/30/1899', Line) > 0) then
    Exit;
  // this is a patch for when there are garbage and extra tabs
  while t > 18 do begin
    parseLast(Line, Tab);
    t := countTabs(Line);
  end;
  // We don't want the side effects of calculating amounts etc so
  // let's use the Field variables, not the properties
  Trade := TTLTrade.Create;
  with Trade do begin
    if t = 18 then begin
      Value := parseLast(Line, Tab); // 18
      if (length(Value) > 0) and (Value <> '0') and TryStrToDate(Value, D, Settings.InternalFmt)
      then
        FWSHoldingDate := Value
      else
        FWSHoldingDate := '';
      // -- ABCcode ---------
      Value := leftstr(parseLast(Line, Tab)+ '   ', 3); // 16
      if superUser and (DEBUG_MODE > 3) and (Value[3] <> ' ') then
        sm('SuperUser:' + CRLF //
            + 'TradeLog found ' + Value[3] + ' in line ' + Line + CRLF //
            + 'Clearing it automatically.');
      Value[3] := ' '; // 2022-01-27 MB force all to be clear for now <------------------
      FABCCode := Value; // should always be 3 chars now
      // -- Strategy --------
      FStrategy := parseLast(Line, Tab); // 15
      FOptionTicker := parseLast(Line, Tab); // 14
      if FStrategy = FOptionTicker then
        FStrategy := '';
      BrString := parseLast(Line, Tab); // 13 - Broker
        // if not isInt(BrString) then sm(line);
      if isInt(BrString) then
        FBroker := StrToInt(BrString);
      FMatched := parseLast(Line, Tab); // 12
      FNote := parseLast(Line, Tab); // 11
    end
    // ------- different format -------
    else if t = 17 then begin
      Value := parseLast(Line, Tab); // 17
      if length(Value) > 0 then
        FABCCode := Value[1];
      // fix to clear garbage
      if (FABCCode <> 'A') //
      and (FABCCode <> 'B') //
      and (FABCCode <> 'C') //
      and (FABCCode <> ' ') //
      then begin
        FABCCode := ' ';
        FFileCleaned := true;
      end;
      FStrategy := parseLast(Line, Tab); // 16
      FOptionTicker := parseLast(Line, Tab); // 15
      if FStrategy = FOptionTicker then
        FStrategy := '';
      BrString := parseLast(Line, Tab); // 14 - Broker
        // if not isInt(BrString) then sm(line);
      if isInt(BrString) then
        FBroker := StrToInt(BrString);
      FMatched := parseLast(Line, Tab); // 13
      FNote := parseLast(Line, Tab); // 12
    end
    // ------- different format -------
    else if t = 16 then begin
      FStrategy := parseLast(Line, Tab); // 15
      FOptionTicker := parseLast(Line, Tab); // 14
      if FStrategy = FOptionTicker then
        FStrategy := '';
      BrString := parseLast(Line, Tab); // 13 - Broker
      if isInt(BrString) then
        FBroker := StrToInt(BrString);
      FMatched := parseLast(Line, Tab); // 12
      FNote := parseLast(Line, Tab); // 11
    end
    // ------- different format -------
    else if t = 15 then begin
      FOptionTicker := parseLast(Line, Tab); // 14
      BrString := parseLast(Line, Tab); // 13 - Broker
      if isInt(BrString) then
        FBroker := StrToInt(BrString);
      FMatched := parseLast(Line, Tab); // 12
      FNote := parseLast(Line, Tab); // 11
      FStrategy := '';
    end
    // ------- different format -------
    else if t = 14 then begin
      FOptionTicker := '';
      BrString := parseLast(Line, Tab); // 13 - Broker
      if isInt(BrString) then
        FBroker := StrToInt(BrString);
      FMatched := parseLast(Line, Tab); // 12
      FNote := parseLast(Line, Tab); // 11
      FStrategy := '';
    end
    // ------- different format -------
    else if t = 13 then begin
      FOptionTicker := '';
      BrString := '';
      FMatched := parseLast(Line, Tab); // 12
      FNote := parseLast(Line, Tab); // 11
      FStrategy := '';
    end
    // ------- different format -------
    else if t = 12 then begin
      FOptionTicker := '';
      BrString := '';
      FMatched := '';
      FNote := parseLast(Line, Tab); // 11
      FStrategy := '';
    end
    // ------- different format -------
    else if t = 11 then begin
      FOptionTicker := '';
      FMatched := '';
      BrString := '';
      FNote := '';
      FStrategy := '';
    end;
    // If this was a V5 file that needs to be converted, Indicated by
    // FFileConverted = true and also a Combined file, indicated by
    // the br field containing a non integer value, then Collect a list
    // of Broker File Names so that we can recreate the combined file
    if (length(BrString) > 0) and not isInt(BrString) and FFileNeedsSaving then begin
      if FBrokerFiles = nil then
        FBrokerFiles := TStringList.Create;
      if FBrokerFiles.IndexOf(BrString) = -1 then
        FBrokerFiles.Add(BrString);
      FBroker := pBrokerID;
    end
    else if (length(BrString) > 0) and not isInt(BrString) then begin
      FBroker := 1;
      FFileCleaned := true;
    end;
    // ----- end format decoding ------
    if (length(Trim(BrString)) = 0) or BrokerOverride then
      FBroker := pBrokerID;
    FAmount := xstrToFloatEx(parseLast(Line, Tab), true, Fmt);
    FCommission := xstrToFloatEx(parseLast(Line, Tab), true, Fmt);
    // --- Read/check Type-Mult field ---
    Value := uppercase(parseLast(Line, Tab));
    p := pos('-', Value); // first dash
    if p = 1 then begin
      bFoundBlankType := true; // Type is blank --> NO GOOD! (Fix below)
    end;
    if pos('-', Value, p + 1) > 0 then begin
      // TypeMult has two or more dashes --> NO GOOD!
      sJunk := ParseFirst(Value, '-');
    end;
    FTypeMult := Value;
    if not FMultiplierIsZero and
      (GetMultiplierAsDouble(copy(TypeMult, pos('-', TypeMult) + 1, length(TypeMult)), '&') = 0)
    then
      FMultiplierIsZero := true;
    FPrice := xstrToFloatEx(parseLast(Line, Tab), true, Fmt);
    FShares := xstrToFloatEx(parseLast(Line, Tab), false, Fmt);
    FTicker := uppercase(parseLast(Line, Tab)); // 2013-08-28 make sure ticker column is all caps
    FTicker := Trim(FTicker); // leading spaces mess up BBIO
    if (FTicker = '') then
      Exit; // ------>
    // 2013-11-06 MB - make sure option expiration day code is 2 digits
    // 2020-09-21 MB - fix expiration date in option format for FUT, OPT
    if ((pos('FUT', FTypeMult)= 1) and (pos(' ', FTicker)> 0)) //
      or (pos('OPT', FTypeMult)= 1) then begin
      // get pos of first space
      p := pos(' ', FTicker);
      exDay := copy(FTicker, pos(' ', FTicker)+ 1, length(FTicker)- pos(' ', FTicker)+ 1);
      if not isInt(leftstr(exDay, 2)) and isInt(leftstr(exDay, 1)) then begin
        FTicker := copy(FTicker, 1, pos(' ', FTicker)) + '0' + exDay;
        // sm(FTicker);
      end;
      // remove trailing zeros from strike price from ticker
      while ((pos('0 CALL', FTicker) > 0) and (pos('.', FTicker) > 0)) do
        delete(FTicker, pos('0 CALL', FTicker), 1);
      while ((pos('0 PUT', FTicker) > 0) and (pos('.', FTicker) > 0)) do
        delete(FTicker, pos('0 PUT', FTicker), 1);
      // delete decimal
      while ((pos('. CALL', FTicker) > 0) and (pos('.', FTicker) > 0)) do
        delete(FTicker, pos('. CALL', FTicker), 1);
      while ((pos('. PUT', FTicker) > 0) and (pos('.', FTicker) > 0)) do
        delete(FTicker, pos('. PUT', FTicker), 1);
    end;
    Value := parseLast(Line, Tab);
    if length(Value) > 0 then
      FLS := Value[1];
    Value := parseLast(Line, Tab);
    if length(Value) > 0 then
      FOC := Value[1];
    FTime := parseLast(Line, Tab);
    if FNoTimeInData then
      FNoTimeInData := length(Trim(Time)) = 0;
    { This conversion error only occurs when a file was in the old David Pressman format where the date was stored in
      the user date format. Also the Users Format in Regional Settings must have been changed since the files was saved.
      At some point if ever we decide that there are no longer any old files out there in the pressman format
      this try except block can be removed as files in the new Internal format will never have this issue. }
    try
      Value := parseLast(Line, Tab);
      FDate := xStrToDate(Value, Fmt);
      // FDate := longDateStrEx(Value, Fmt, Settings.UserFmt);
    except
      on E : EConvertError do begin
        raise ETLFileException.Create('Date Conversion Error: Date: "' + Value +
            '" Cannot be converted using Format: "' + Settings.UserFmt.ShortDateFormat + '"' + CR +
            CR + 'Possible Cause: Windows Regional Settings for "Short Date Fomat" have been changed since this file was last saved.'
            + CR + 'You must reset this format in Regional Settings to match the above date before this file can be opened.');
      end;
    end;
    FTradeNum := xStrToInt(parseLast(Line, Tab));
    // When combining files this will renumber each successive
    // file from the last Transaction of the previous file.
    // Also we will continue ID Numbers from the last one.
    if LastTrNumber > 0 then begin
      FTradeNum := FTradeNum + LastTrNumber;
      FID := NextID;
    end
    else begin // item number - must be sequential
      FID := xStrToInt(Line);
      if FID > FLastID then
        FLastID := FID;
    end;
    // Finally make sure the MTM Flag for the broker is set when M records exist.
    // This fixes an issue with reports when M records exist but MTM is false in the header.
    if (Trade.oc = 'M') and (pos('FUT', Trade.TypeMult) = 0) and not FileHeader[Trade.Broker].MTM
    then begin
      FileHeader[Trade.Broker].MTM := true;
      FFileCleaned := true;
    end;
  end;
  // set FileNeedsSaving (but NOT YearEndDone) - 2016-11-23 MB
  if not YearEndDone then begin
    FFileNeedsSaving :=
      ((Trade.oc = 'M') and (Trade.Date > xStrToDate('01/01/' + FileHeader[Trade.Broker].TaxYear,
          Settings.InternalFmt)));
  end;
  AddTrade(Trade, true);
  { When we are loading the rows, the edited property needs to be reset to false after all is done }
  Trade.FEdited := false;
  result := Trade;
end;


// ------------------------------------------------------------------
// 2016-05-03 MB - ONLY used to read a file (no longer for combine)
procedure TTLFile.ReadFile(FileName : string; BrokerOverride : boolean = false;
  LastTrNumber : integer = 0);
var
  Line, tYear, sEmail : string;
  i, n, NewBrokerID, CurrentTradeNumber, HeaderCount : integer;
  Fmt : TFormatSettings;
  TradeNum : TTLTradeNum;
  LastTradeAdded : TTLTrade;
  ColData, BrList : TStringList;
  FileStream : TStreamReader;
  // ------------------------
  procedure getColData(var ColData : TStringList; Line :string);
  begin
    // read header lines
    if (ColData.Strings[0] = '-5') or (ColData.Strings[0] = '-9') then begin
      { If BrokerOverride is true that means we are adding another file to an existing file
        if HeaderCount > 0 then we have already processed one header, Currently we do not support
        adding a file with multiple accounts to another file, so throw an exception here to stop this. }
      if (HeaderCount > 0) and BrokerOverride then begin
        raise ETLFileMultiAccountImportException.Create
          ('You cannot add a Multi Account file to another file, only single account files can be added.');
      end;
      inc(HeaderCount);
      NewBrokerID := ReadHeaderLine(Line, copy(FileName, 1, 4), BrokerOverride);
      Fmt := GetBackwardCompatibleLocaleSettings(FileHeaders.Last.FileLocale);
    end
    else begin // read trade record lines
      if ColData.Strings[0] = '' then
        Exit;
      // Populate the TradeNumList, with the assumption that all trades are in the correct order
      LastTradeAdded := ReadDataLine(Line, Fmt, NewBrokerID, BrokerOverride, LastTrNumber);
    end;
  end;
// ------------------------
begin
  bFoundBlankType := false; // 2019-02-06 MB - set in ReadLine, fixed at end of this proc
  tYear := '';
  Line := '';
  CurrentTradeNumber := 0;
  HeaderCount := 0;
  TradeNum := nil;
//  DoStatus('Reading Data File');
  Screen.Cursor := crHourGlass;
  try
    BrList := TStringList.Create; // 2022-10-04 MB
    ColData := TStringList.Create;
    ColData.StrictDelimiter := true;
    ColData.Delimiter := #9;
    // ------- Read from DB file --------
    if isDBfile then begin
      // clear, then read ProHeader here
      clearProHeader;
      // ...but keep TempProHdr for now
      // ClearTempProHdr;
      try
      // RJ the FileName should contain the  path
        if not dbFileConnect(lastFileName, false) then
          Exit;
        lineList := TStringList.Create;
        // save lineList while file is open so we can view it as plain text (Ctrl-Shift-Z)
        getLinesFromDB(lineList);
        n := lineList.Count - 1; // number of lines - before deleting any
        i := 0; // start loop
        while i <= n do begin

          Line := lineList[i]; // sm(line);
          ColData.DelimitedText := Line;
//          if SuperUser and (ColData.Count < 8) then begin
//            sm('i = ' + inttostr(i) + ', line = ' + line);
//          end;
          if (ColData.Strings[0] = '-99') then begin // -- read ProHeader -----
            // UNLESS File\Combine (aka bImportingAccounts)
            if not bImportingAccounts then begin // -----------------
              ProHeader.regCode := ColData.Strings[1];
              ProHeader.taxFile := ColData.Strings[2];
              ProHeader.taxpayer := ReadSSN(ColData.Strings[3]);
              // ----- Accountant -----
              if (ColData.Count > 4) then
                ProHeader.regCodeAcct := ColData.Strings[4];
              // ----- registered TaxFile? -----
              if (ColData.Count > 5) then
                ProHeader.canETY := StrToInt(ColData.Strings[5]);
              // ----- password-protected? -----
              if (ColData.Count > 6) then
                ProHeader.TDFpassword := ColData.Strings[6];
              // ----- IsEIN -----
              if (ColData.Count > 7) then
                ProHeader.IsEIN := StrToInt(ColData.Strings[7])
              else if (length(ProHeader.taxpayer) = 11) then
                ProHeader.IsEIN := 0
              else if (ProHeader.taxpayer = '') then begin
                if Settings.IsEIN then
                  ProHeader.IsEIN := 1
                else
                  ProHeader.IsEIN := 0;
              end
              else
                ProHeader.IsEIN := 1;
              // ----- email -----
              if (ColData.Count > 8) then // 2021-02-26 - MB - New!
                ProHeader.email := (ColData.Strings[8])
              else
                ProHeader.email := '';
            end; // end if NOT bImportingAccounts -------------------
          end // if = -99
          else if (ColData.Strings[0] = '-9') then begin
            if (tYear = '') then
              tYear := ColData.Strings[14];
            BrList.Add(ColData.Strings[15]); // list of all brokers
            getColData(ColData, Line);
          end // if = -9
          else begin // is the broker in the BrList?
            if (BrList.IndexOf(ColData.Strings[14]) >= 0) then
              getColData(ColData, Line) // load the record
            else begin // orphan trade, so remove it
              lineList.delete(i); // remove the invalid record
              dec(n); // one less line now
              dec(i); // also back up one, for inc(i)
              NeedToSave := true;
            end
          end; // if ColData.Strings[0]
          inc(i); // loop counter
        end; // while i <= N
        // 2021-01-27 MB - read Wash Sale Engine settings
        bWashShortAndLong := GetTDFFlag('bWashShortAndLong');
        bWashUnderlying := GetTDFFlag('bWashUnderlying');
        bWashStock2Opt := GetTDFFlag('bWashStock2Opt');
        bWashOpt2Stock := GetTDFFlag('bWashOpt2Stock');
      finally
        // ok to read, but can't write here!
        dbFileDisconnect;
        // lineList.Free;  // this gets freed when closing the file
      end;
    end
    // ------- read from tdf file ----------
    else begin // file is *.tdf
      lineList := TStringList.Create;
      try
        FileStream := TStreamReader.Create(FileName);
        while not FileStream.EndOfStream do begin
          Line := FileStream.ReadLine;
          if Line = '' then
            continue; // 2017-02-02 MB - skip blank lines
          ColData.DelimitedText := Line;
          // we don't expect any ProHeader here!
          getColData(ColData, Line);
        end; // <-- while not EOF(txtFile)
      finally
        FileStream.Free;
      end;
    end;
  finally
    ColData.Free;
  end;
  if bFoundBlankType then begin
    if messagedlg('Some trades are missing type data.' + CR //
        + 'Applying User \ Trade Type settings should correct them.' + CR //
        + 'Click OK to apply now.', mtError, [mbOK, mbCancel], 1) = mrOK then begin
    // 2019-02-25 MB - support UNDO
      SaveTradesBack('auto fix types');
      UpdateTypeMultipliers; // 2019-02-06 MB - fix blank types
    end
    else
      bFoundBlankType := false; // user chooses to ignore
  end;
  try
    CreateLists;
    CloneList;
  except
    sm('error creating lists.');
  end;
//  DoStatus('Loading Grid');
end;


function TTLFile.ReadHeaderLine(Value : string; pTaxYear : string;
  BrokerOverride : boolean = false): integer;
begin
  result := FTLFileHeaders.NextBrokerID;
  FTLFileHeaders.Add(TTLFileHeader.Create(self, Value, pTaxYear, result, BrokerOverride));
end;


procedure TTLFile.Refresh;
var
  Trade : TTLTrade;
begin
  for Trade in FTrades do
    Trade.Free;
  for Trade in FTradesSaved do
    Trade.Free;
  FTrades.Clear;
  FTradesSaved.Clear;
  FCancelledTrades.Clear;
  FZeroOrLessTrades.Clear;
  FMisMatchedTrades.Clear;
  FMisMatchedLS.Clear;
  FTLFileHeaders.Clear;
  FTradeNums.ClosedTradeNums.Clear;
  FTradeNums.Clear;
  ReadFile(FFileName);
end;

procedure TTLFile.RefreshOpens;
var
  Trade : TTLTrade;
  t : string;
begin
  try
    t := 'freeing trades';
    for Trade in FTrades do
      Trade.Free;
    t := 'freeing trades saved';
    for Trade in FTradesSaved do
      Trade.Free;
    t := 'clearing trades';
    FTrades.Clear;
    t := 'clearing trades saved';
    FTradesSaved.Clear;
    t := 'clearing trades canceled';
    FCancelledTrades.Clear;
    t := 'clearing trades zero or less';
    FZeroOrLessTrades.Clear;
    t := 'clearing matched trades';
    FMisMatchedTrades.Clear;
    t := 'clearing mismatched LS trades';
    FMisMatchedLS.Clear;
    t := 'clearing file headers';
    FTLFileHeaders.Clear;
    t := 'clearing closed trade numbers';
    FTradeNums.ClosedTradeNums.Clear;
    t := 'clearing trade numbers';
    FTradeNums.Clear;
    t := 'reading file';
    ReadFile(FFileName);
  except
    sm('error in ' + t);
  end;
end;

// Only remove MTMRecords for LastTaxYear, and their associated open records,
// This is used when changing account type from MTM Back To Cash or IRA, so that
// we can remove the records that were created when the selected account type MTM
function TTLFile.RemoveSection481 : boolean;
var
  TradeNum : TTLTradeNum;
  MTMClosedTrades : TTLTradeNumList;
  Trade : TTLTrade;
  OTrade : TTLTrade;
  MTrade : TTLTrade;
  OTradeNum : TTLTradeNum;
begin
  // RemoveSection481
  try
    result := false;
    if CurrentBrokerID = 0 then
      Exit; // -------->
    { If this was also MTM Last Year then there is nothing to remove }
    if CurrentAccount.MTMLastYear then
      Exit; // --->
    MTMClosedTrades := TradeLogFile.MTMClosedPositions
      [xStrToDate('12/31/' + IntToStr(TradeLogFile.LastTaxYear))];
    for TradeNum in MTMClosedTrades do begin
      MTrade := nil;
      for Trade in TradeNum do
        if (Trade.oc = 'M') and (pos('23:59', Trade.Time) > 0) and
          (Trade.Date = xStrToDate('12/31/' + IntToStr(LastTaxYear))) and
          (Trade.Broker = CurrentBrokerID) then begin
          MTrade := Trade;
          break;
        end;
      if MTrade = nil then
        continue;
      { Now we have to loop through the entire file looking for the opening record. I know how bad this
        is but I don't see any other way to do this with a flat file. }
      for Trade in FTrades do begin
        if Trade.Broker <> CurrentBrokerID then
          continue;
        if (Trade.Ticker = MTrade.Ticker) and (Trade.oc = 'O') and
          (Trade.Date = xStrToDate('01/01/' + IntToStr(TaxYear))) and (Trade.Time = '00:00:00') and
          (Trade.Price = MTrade.Price) then begin
          OTrade := Trade;
          OTradeNum := FTradeNums.FindTradeNum(Trade);
          break;
        end;
      end;
      if OTrade <> nil then begin
        if isInt(MTrade.Matched) and isInt(OTrade.Matched) then begin
          // We are assuming at this point that this was a matched lot and when
          // we created the MTM Closing Record and Opening Record we split the
          // Matched lots, so now that we are removing the MTM Closing Record and
          // opening record we now need to put the match lots back together
          for Trade in OTradeNum do begin
            if (Trade <> OTrade) and (Trade.Matched = OTrade.Matched) then
              Trade.Matched := MTrade.Matched;
          end;
        end;
        DeleteTrade(OTrade);
      end;
      DeleteTrade(MTrade);
      result := true;
    end;
    if result then
      MatchAndReorganize;
  finally
    // RemoveSection481
  end;
end;


procedure TTLFile.RenumberItemField;
var
  i : integer;
begin
  try
    DoStatus('Creating Unique IDs');
    for i := 0 to FTrades.Count - 1 do
      FTrades.Items[i].ID := i + 1;
  finally
    DoStatus('off');
  end;
end;


procedure TTLFile.MatchAndReorganize(FixTradesOOOrder : boolean; RenumberID : boolean);
var
  i : integer;
begin
  if CurrentBrokerID = 0 then
    raise ETLFileException.Create('Matching cannot be run when there is no Current Broker');
  DoStatus('Matching Trades');
  Screen.Cursor := crHourGlass;
  try
    TradeNums.MatchAll(false, FixTradesOOOrder);
    DoStatus('Reorganizing Data');
    Reorganize(RenumberID or FixTradesOOOrder);
  finally
    DoStatus('off');
  end;
end;


procedure TTLFile.MatchAndReorganizeAllAccounts(FixTradesOOOrder, RenumberID : boolean);
var
  FileHeader : TTLFileHeader;
  CurrentBroker : integer;
begin
  CurrentBroker := self.CurrentBrokerID;
  for FileHeader in FTLFileHeaders do begin
    self.CurrentBrokerID := FileHeader.BrokerID;
    // Match all then Reorganize. which includes sorting and renumbering
    self.MatchAll(false, FixTradesOOOrder);
  end;
  self.Reorganize(true);
  self.CurrentBrokerID := CurrentBroker;
end;


procedure TTLFile.MoveRecord(StartIndex, EndIndex : integer);
var
  Trade : TTLTrade;
begin
  { If the indexes are the same then nothing to do }
  if StartIndex = EndIndex then
    Exit;
  { If Either Index it out of range then this is an error }
  if (StartIndex < 0) or (StartIndex > Count) then
    raise ETLFileException.Create('Start Index Out Of Range: ' + IntToStr(StartIndex));
  if (EndIndex < 0) or (EndIndex > Count) then
    raise ETLFileException.Create('End Index Out Of Range: ' + IntToStr(EndIndex));
  // ----
  Trade := FTrades.Items[StartIndex];
  FTrades.Remove(Trade);
  FTrades.Insert(EndIndex, Trade);
  RenumberItemField;
  Match(Trade.Ticker);
  RenumberTrades;
end;


procedure TTLFile.RenumberTrades;
// Resequence the trade numbers by date
var
  i, OldIdx, NewTrNumber, LastTrNumber : integer;
  bFound : boolean;
  NewNums : TList<integer>;
begin
  NewNums := TList<integer>.Create;
  try
    DoStatus('Assigning Trade Numbers');
    // get all OLD TrNums into a list and sequentially renumber them starting with 1
    FTrades.SortByTrNumber;
    NewTrNumber := 0;
    LastTrNumber := 0;
    for i := 0 to FTrades.Count - 1 do begin
      if (FTrades[i].TradeNum <> LastTrNumber) then begin
        inc(NewTrNumber);
        LastTrNumber := FTrades[i].TradeNum;
        FTrades[i].TradeNum := NewTrNumber;
        NewNums.Add(0);
      end
      else
        FTrades[i].TradeNum := NewTrNumber;
    end;
    // now loop thru trades sorted by date and and sequentially renumber them starting with 1
    FTrades.SortByDate;
    NewTrNumber := 0;
    for i := 0 to FTrades.Count - 1 do begin
      OldIdx := FTrades[i].TradeNum - 1;
      // Trade Num has not been assigned
      if (NewNums[OldIdx] = 0) then begin
        inc(NewTrNumber);
        NewNums[OldIdx] := NewTrNumber;
        FTrades[i].TradeNum := NewTrNumber;
      end
      else begin // assign new trade number
        FTrades[i].TradeNum := NewNums[OldIdx];
      end;
    end;
  finally
    NewNums.Free;
    DoStatus('off');
  end;
end;


procedure TTLFile.Reorganize(RenumberID : boolean = true);
var
  i : integer;
begin
  Screen.Cursor := crHourGlass;
  RenumberTrades;
  Screen.Cursor := crHourGlass;
  SortByTrNumber;
  Screen.Cursor := crHourGlass;
  if RenumberID then
    RenumberItemField;
  Screen.Cursor := crHourGlass;
  getNegShareList;
end;


procedure TTLFile.Revert;
begin
  CreateLists(true);
end;


// ------------------------------------
// SaveFile makes the call shorter
// ------------------------------------
function TTLFile.SaveFile(ForceOverwrite : boolean = false; bClear : boolean = false) : integer;
begin
  result := SaveFileAs(FFileName, Settings.DataDir, 0, ForceOverwrite, bClear);
end;

// ------------------------------------
// SaveFileAs is the main routine
// ------------------------------------
function TTLFile.SaveFileAs(FileName : string; FilePath : string = ''; TaxYear : integer = 0;
  ForceOverwrite : boolean = false; bClear : boolean = false): integer;
var
  Line : string;
  i, lastTrNum : integer;
  Trade : TTLTrade;
  WriteInternalData : boolean;
  AFileHeader : TTLFileHeader;
  FileStream : TStreamWriter;
  // ---------------------------
  // use stream to write to file
  function StreamInit(const FileName : string): TStreamWriter;
  begin
    result := TStreamWriter.Create(FileName, true);
    result.AutoFlush := true; // Flush automatically after write
    result.NewLine := sLineBreak; // Use system line breaks
  end;
  // ---------------------------
  procedure StreamClose(const StreamWriter : TStreamWriter);
  begin
    StreamWriter.Free;
  end;
  // ---------------------------
  function TorF(bVal : boolean): string;
  begin
    if bVal = true then
      result := 'T'
    else
      result := 'F';
  end;
// ---------------------------
begin
  // added begin/end to some blocks for clarity - 2015-12-16 MB
  Screen.Cursor := crHourGlass; // disable mouse
  DoStatus('Saving File');
  if FilePath[length(FilePath)] <> '\' then
    FilePath := FilePath + '\';
  // ---------------------------
  // Are we writing the internal data or just saving the data with another
  // file name or location? We need to know this because we don't want to
  // change the internal file data if we are really 'saving as' and not just
  // saving the existing file.
  WriteInternalData := (FilePath + FileName = Settings.DataDir + '\' + FFileName);
  // ---------------------------
  // Change the tax year for all headers if they pass one in.
  if (TaxYear > 0) and (TaxYear <> self.TaxYear) then begin
    for AFileHeader in FileHeaders do begin
      AFileHeader.FTaxYear := IntToStr(TaxYear);
    end;
  end;
  // ---------------------------
  if FileExistsCaseInsensitive(FilePath + FileName) //
    and not ForceOverwrite then begin
    if mDlg(FileName + ' already exists.' + CR //
        + 'Do you wish to overwrite it?', //
      mtWarning, [mbYes, mbNo], 0) <> mrYes then begin
      result := -1;
      Exit;
    end;
  end;
  // ------------------------------------------------------
  // NOTE: This code literally deletes the TDF file here...
  // ------------------------------------------------------
  if FileExistsCaseInsensitive(FilePath + FileName) //
    and not DeleteFile(FilePath + FileName) then
    raise ETLFileException.Create('Could Not Delete existing file, Error: ' //
        + GetLastErrorMessage(GetLastError));
  // ---------------------------
  try
    if superUser and (DEBUG_MODE > 3) then
      sm('SuperUser: FSortBy = ' + FTrades.FSortBy);
    if (FTrades.FSortBy <> 'tr') then
      FTrades.SortByTrNumber;
    result := FTrades.Count; // number of trade records
    // if FTrades.Count < 1 then isDBfile := true; // it's a NEW file!
    // ------------------------------------------
    // save file encrypted
    if isDBfile then begin // all new taxid ver files are to be encrypted
      try // ----------------------------------------------
        // ...and re-creates a new [empty] DB file...
        if not dbFileCreate(FilePath + FileName) then
          Exit;
        // ------------------------------------------------
        // add ProHeader line
        if ProVer then begin
          ProHeader.regCodeAcct := Settings.regCode;
          ProHeader.TDFpassword := '';
        end;
        if superUser then begin
          if (ProHeader.regCode = Settings.regCode) then
            ProHeader.regCode := ''; // clear superUser regcode
          if (ProHeader.regCodeAcct = Settings.regCode) then
            ProHeader.regCodeAcct := '';
        end;
        Line := '-99' + Tab + ProHeader.regCode + Tab + //
          ProHeader.taxFile + Tab + //
          EncryptStr(ProHeader.taxpayer) + Tab + //
          ProHeader.regCodeAcct + Tab + //
          IntToStr(ProHeader.canETY) + Tab + //
          ProHeader.TDFpassword + Tab + //
          IntToStr(ProHeader.IsEIN) + Tab + //
          ProHeader.email; // 2021-02-26 MB - New for TradeLog20
        // write taxFile line to db file
        dbBeginTrans;
        if not dbInsertLine(Line) then begin
          messagedlg('Writing Pro Header Line', mtError, [mbOK], 1);
          Exit;
        end
        else begin
          dbSetFlag('bSSNencrypted', 'T'); // set flag to TRUE for all
          // 2021-01-27 MB - save Wash Sale Engine settings
          dbSetFlag('bWashShortAndLong', TorF(bWashShortAndLong));
          dbSetFlag('bWashUnderlying', TorF(bWashUnderlying));
          dbSetFlag('bWashStock2Opt', TorF(bWashStock2Opt));
          dbSetFlag('bWashOpt2Stock', TorF(bWashOpt2Stock));
        end;
        // ------------------
        // write header lines
        for i := 0 to FTLFileHeaders.Count - 1 do begin
          Line := FTLFileHeaders.Items[i].GetFileHeaderRow;
          // write line to db file
          if not dbInsertLine(Line) then begin
            messagedlg('Writing Broker Acct Header Line', mtError, [mbOK], 1);
            Exit;
          end;
        end;
        // ------------------------------------------------
        // loop thru trades if not clearing or not on All Accounts tab
        if not bClear or not IsAllBrokersSelected then begin
          // write trade record lines
          for i := 0 to result - 1 do begin
            Trade := FTrades.Items[i]; // assumes FTrades already sorted
            // ---- any trades out of order? ----
            if superUser and (DEBUG_MODE > 0) and (i > 0) //
            and (lastTrNum > Trade.TradeNum) then begin
              sm('SuperUser: mis-sorted trade found' + CR //
                  + 'lastTrNum = ' + IntToStr(lastTrNum) + CR //
                  + 'thisTrNum = ' + IntToStr(Trade.TradeNum));
            end;
            lastTrNum := Trade.TradeNum;
            // ----------------------------------
            // clear trades for selected account - fast delete all!
            if bClear and (Trade.Broker = TradeLogFile.CurrentBrokerID) then
              continue;
            // ----------------------------------
            // write line to db file
            Line := MakeTradeRowLine(Trade);
            if not dbInsertLine(Line) then begin
              messagedlg('Writing Trade Record Line', mtError, [mbOK], 1);
              Exit;
            end;
            // Now that the trade has been saved, turn off the edited flag
            if WriteInternalData then
              Trade.FEdited := false;
          end;
        end;
      finally
        dbCommitTrans;
        // --------------------------------------
        // read/set flags -- SAVE data here!
        // SetWSCompatibilityFlag(FileName); // 2021-01-27 MB - disabled
        // Best place to save this data, based on testing
        // WHY? Because I wanted to make sure we ALWAYS check a TaxId file on open.
        // if SuperUser and (DEBUG_MODE > 4) then // 2021-01-27 MB - disabled
        // sm('bWSCompatibility=' + booltostr(bWSCompatibility));
        // --------------------------------------
        dbFileDisconnect;
      end;
    end
    // ------------------------------------------
    else begin // save file as plain text
      try
        FileStream := StreamInit(FilePath + FileName);
        // --------------------------------------
        // write header lines
        for i := 0 to FTLFileHeaders.Count - 1 do begin
          Line := FTLFileHeaders.Items[i].GetFileHeaderRow;
          FileStream.WriteLine(Line);
        end;
        // --------------------------------------
        // loop thru trades if not clearing or not on All Accounts tab
        if not bClear or not IsAllBrokersSelected then
         // write trade record lines
          if (result > 0) then begin
            for i := 0 to result - 1 do begin
              Trade := FTrades.Items[i];
              // --- any trades out of order? ---
              if superUser and (DEBUG_MODE > 0) and (i > 0) //
              and (lastTrNum > Trade.TradeNum) then begin
                sm('SuperUser: mis-sorted trade found' + CR //
                    + 'lastTrNum = ' + IntToStr(lastTrNum) + CR //
                    + 'thisTrNum = ' + IntToStr(Trade.TradeNum));
              end;
              lastTrNum := Trade.TradeNum;
              // --------------------------------
              // clear trades for selected account
              if bClear and (Trade.Broker = TradeLogFile.CurrentBrokerID) then
                continue;
              // --------------------------------
              Line := MakeTradeRowLine(Trade);
              // writeln(txtFile, Line);
              FileStream.WriteLine(Line);
              // Now that the trade has been saved, turn off the edited flag
              if WriteInternalData then
                Trade.FEdited := false;
            end;
          end;
      finally
        StreamClose(FileStream);
      end;
    // ------------------------------------------
    end; // if isDBfile or not?
    // ------------------------------------------
    // If we wrote less records because of record limits then refresh the file,
    // so that it just contains the max records allowed
    if (result < Count) and WriteInternalData then
      Refresh;
    CloneList;
    if WriteInternalData then
      FFileNeedsSaving := false;
  finally
    DoStatus('off');
  end;
end; // SaveFileAs


// ------------------------------------
//
// ------------------------------------
function TTLFile.SaveTList(var pTList : TList<TTLTrade>) : integer;
var
  Line : string;
  txtFile : textFile;
  i : integer;
  Trade : TTLTrade;
  Msg : string;
  WriteInternalData : boolean;
  AFileHeader : TTLFileHeader;
  sFileName, sFilePath : string;
  iTaxYear : integer;
  bForceOverwrite : boolean;
begin
  Screen.Cursor := crHourGlass;
  Msg := 'Saving File';
  DoStatus(Msg);
  bForceOverwrite := true;
  sFileName := FFileName;
  sFilePath := Settings.DataDir;
  if sFilePath[length(sFilePath)] <> '\' then
    sFilePath := sFilePath + '\';
  WriteInternalData := (sFilePath + sFileName = Settings.DataDir + '\' + FFileName);
  if (TaxYear > 0) and (TaxYear <> self.TaxYear) then begin
    for AFileHeader in FileHeaders do begin
      AFileHeader.FTaxYear := IntToStr(TaxYear);
    end;
  end;
  if FileExistsCaseInsensitive(sFilePath + sFileName) and not bForceOverwrite then
    raise ETLFileException.Create('FileName: ' + FileName + ' already exists. Cannot overwrite!');
  if FileExistsCaseInsensitive(sFilePath + sFileName) and not DeleteFile(sFilePath + sFileName) then
    raise ETLFileException.Create('Could Not Delete existing file, Error: ' +
        GetLastErrorMessage(GetLastError));
  try
    result := pTList.Count; // number of trade records
    if taxidVer then begin // all new taxid ver files are to be encrypted
      try
        if not dbFileCreate(sFilePath + sFileName) then
          Exit;
        if ProVer then begin
          ProHeader.regCodeAcct := Settings.regCode;
        end;
        Line := '-99' + Tab + ProHeader.regCode + Tab + //
          ProHeader.taxFile + Tab + //
          ProHeader.taxpayer + Tab + //
          ProHeader.regCodeAcct + Tab + //
          IntToStr(ProHeader.canETY) + Tab + //
          ProHeader.TDFpassword;
        if not dbInsertLine(Line) then begin
          messagedlg('Writing Pro Header Line', mtError,[mbOK], 1);
          Exit;
        end;
        for i := 0 to FTLFileHeaders.Count - 1 do begin
          Line := FTLFileHeaders.Items[i].GetFileHeaderRow;
          if not dbInsertLine(Line) then begin
            messagedlg('Writing Broker Acct Header Line', mtError, [mbOK], 1);
            Exit;
          end;
        end;
        for i := 0 to result - 1 do begin
          Trade := pTList.Items[i];
          Line := MakeTradeRowLine(Trade);
          if not dbInsertLine(Line) then begin
            messagedlg('Writing Trade Record Line', mtError, [mbOK], 1);
            Exit;
          end;
          if WriteInternalData then
            Trade.FEdited := false;
        end;
      finally
        // ----------------------------
        // read/set flags -- SAVE data here!
        // SetWSCompatibilityFlag(FileName); // 2021-01-27 MB - disabled
        // Best place to save this data, based on testing
        // WHY? Because I wanted to make sure we ALWAYS check a TaxId file on open.
        // if SuperUser and (DEBUG_MODE > 4) then // 2021-01-27 MB - disabled
        // sm('bWSCompatibility=' + booltostr(bWSCompatibility));
        // ----------------------------
        dbFileDisconnect;
      end;
    end
    else begin // save file as plain text
      try
        AssignFile(txtFile, sFilePath + sFileName);
        Rewrite(txtFile);
        for i := 0 to FTLFileHeaders.Count - 1 do begin
          Line := FTLFileHeaders.Items[i].GetFileHeaderRow;
          writeln(txtFile, Line);
        end;
        if (result > 0) then begin
          for i := 0 to result - 1 do begin
            Trade := pTList.Items[i]; // option to use a different TTrades list
            Line := MakeTradeRowLine(Trade);
            writeln(txtFile, Line);
            if WriteInternalData then
              Trade.FEdited := false;
          end;
        end;
      finally
        Close(txtFile);
      end;
    end;
    if (result < Count) and WriteInternalData then
      Refresh;
    CloneList;
    if WriteInternalData then
      FFileNeedsSaving := false;
  finally
    DoStatus('off');
  end;
end;


procedure TTLFile.SetCurrentBroker(const Value : integer);
var
  i : integer;
begin
// if Value <> FCurrentBroker then begin
    // This will happen when we are on the All tab.
  if Value = 0 then begin
    FCurrentBroker := 0;
    FCurrentHeader := FTLFileHeaders[0];
    Exit;
  end;
    // If we find the broker ID then set it.
  for i := 0 to FTLFileHeaders.Count - 1 do begin
    if FTLFileHeaders.Items[i].BrokerID = Value then begin
      FCurrentBroker := Value;
      FCurrentHeader := FTLFileHeaders.Items[i];
      Exit;
    end;
  end;
    // If we got here then it wasn't zero and we didn't find the broker so
    // let the calling process know with an exception.
  raise ETLFileException.Create('Invalid Broker ID: ' + IntToStr(Value));
// end;
end;


procedure TTLFile.SetOFXCredentials(BrokerID : integer; Account, UserName, Password : string);
var
  i : integer;
begin
  for i := 0 to FTLFileHeaders.Count - 1 do begin
    if FTLFileHeaders.Items[i].FBrokerID = BrokerID then begin
      FTLFileHeaders.Items[i].OFXAccount := Account;
      FTLFileHeaders.Items[i].OFXUserName := UserName;
      FTLFileHeaders.Items[i].OFXPassword := Password;
      break;
    end;
  end;
  raise Exception.Create('Not a valid Broker ID for this file: ' + IntToStr(BrokerID));
end;


procedure TTLFile.SetYearEndDone(const Value : boolean);
var
  Header : TTLFileHeader;
begin
  for Header in FTLFileHeaders do
    Header.YearEndDone := Value;
end;


procedure TTLFile.SortByDate;
begin
  try
    DoStatus('Sorting by Date');
    FTrades.SortByDate;
  finally
    DoStatus('off');
  end;
end;

procedure TTLFile.SortByOpenClose;
begin
  try
    DoStatus('Sorting by Open/Close');
    FTrades.SortByOpenClose;
  finally
    DoStatus('off');
  end;
end;


procedure TTLFile.SortByTicker;
begin
  try
    DoStatus('Sorting by Ticker');
    FTrades.SortByTicker;
  finally
    DoStatus('off');
  end;
end;


procedure TTLFile.SortByTrNumber;
var
  TradeNum : TTLTradeNum;
  x, iMaxTrNum : integer; // new
begin
  try
    DoStatus('Sorting by Trade Number');
    FTrades.SortByTrNumber;
    // Also sort the TradeNum Lists the same
    for TradeNum in FTradeNums do
      TradeNum.SortByTrNumber;
    for TradeNum in FTradeNums.ClosedTradeNums do
      TradeNum.SortByTrNumber;
    // ------------ begin new code --------------
    // delete all Unused TradeNums
    // added check count to prevent error - 2016-03-25 MB
    if (FTrades.Count > 0) then begin
      // changed from FTrades.Count to TradeLogFile.FTrades.Count 2016-05-11 MB
      // iMaxTrNum := TradeLogFile.Trade[FTrades.Count-1].FTradeNum; // old code
      iMaxTrNum := TradeLogFile.Trade[TradeLogFile.FTrades.Count - 1].FTradeNum;
      x := 0;
      while x < TradeLogFile.TradeNums.Count do begin
        TradeNum := TradeLogFile.TradeNums[x];
        if TradeNum.TradeNum > iMaxTrNum then
          TradeLogFile.TradeNums.delete(x)
        else
          inc(x);
      end;
    end;
    // ------------ end new code ----------------
  finally
    DoStatus('off');
  end;
end;


function TTLFile.UpdateMultiplierIsZero : boolean;
var
  i, j : integer;
  Mult : double;
begin
  FMultiplierIsZero := false;
  for i := 0 to FTrades.Count - 1 do begin
    // First check for a dash in the field.
    j := pos('-', FTrades[i].TypeMult);
    if j = 0 then begin // IF no dash then three is no multiplier.
      FMultiplierIsZero := true;
      break;
    end;
    // Next get the value after the dash and see if it is zero.
    if not IsFloat(copy(FTrades[i].TypeMult, j + 1)) then begin
    // If what is after the dash is not an integer then we have no multiplier.
      FMultiplierIsZero := true;
      break;
    end;
    // Finally read the multiplier off of the end of the field and check it for zero.
    Mult := StrToFloat(copy(FTrades[i].TypeMult, j + 1));
    if Mult = 0 then begin
      // if we do have a valid integer but is still zero then we have a problem.
      FMultiplierIsZero := true;
      break;
    end;
  end;
  result := FMultiplierIsZero;
end;

{ Update a trade if it exists, otherwise add it if not.
  FTrades comparitor will compare the it field, if it is equal both contains and IndexOf
  will return the appropriate entry
}
procedure TTLFile.UpdateTrade(Trade : TTLTrade);
var
  i : integer;
begin
  i := FTrades.IndexOf(Trade);
  if i > -1 then begin
    // If the pointer is equal, The trade is already in the list
    // So we will ignore this call to Update since modifying a trade
    // that is already in the list is all that is necessary.
    // Otherwise assign the trade.
    if Pointer(FTrades[i]) <> Pointer(Trade) then
      FTrades[i].Assign(Trade);
    // If it is no longer a cancelled trade then remove it from the cancelled trade list
    if (FCancelledTrades.IndexOf(FTrades[i]) > -1) and (FTrades[i].oc <> 'X') then
      FCancelledTrades.Remove(FTrades[i]);
    if (FMisMatchedTrades.IndexOf(FTrades[i]) > -1) and
      (FTradeNums.FindTradeNum(FTrades[i]).TradeType = FTrades[i].TradeType) then
      FMisMatchedTrades.Remove(FTrades[i]);
    if (FMisMatchedLS.IndexOf(FTrades[i]) > -1) and
      (FTradeNums.FindTradeNum(FTrades[i]).ls = FTrades[i].ls) then
      FMisMatchedLS.Remove(FTrades[i]);
    if (FZeroOrLessTrades.IndexOf(FTrades[i]) > -1)
    // and (FTrades[I].Shares > 0)
      and (compareValue(FTrades[i].Shares, 0, NEARZERO) > 0)
    // and (FTrades[I].Price >= 0)
      and (compareValue(FTrades[i].Price, 0, NEARZERO) >= 0) then
      FZeroOrLessTrades.Remove(FTrades[i]);
  end
  else
    AddTrade(Trade);
  FileHeader[Trade.Broker].ResetCheckList;
end;


procedure TTLFile.applyChangesToTypeMults(bAdjContr : boolean = false);
var
  i : integer;
  impTr : PTrade;
  typeStr, Mult, mult2 : string;
  nOldMult, nNewMult : double;
  Trade : TTLTrade;
begin
// for Trade in FTrades do begin
// typeStr := Trade.TypeMult;
// mult := parseLast(typeStr, '-');
// nOldMult := StrToFloatDef(mult, 1);
// // check types in this order...
// if (Settings.BBIOList.IndexOf(Trade.Ticker) > -1) // BBIO
// or (Settings.FutureList.IndexOf(Trade.Ticker) > -1) then begin // FUT
// Trade.TypeMult := typeStr;
// if bAdjContr then begin // 2016-12-12 MB - Adjust #Contracts
// nNewMult := StrToFloatDef(mult2, 1);
// if (nOldMult <> 0) AND (nNewMult <> 0) then begin
// // adjust shares to keep #contracts the same
// Trade.Shares := Trade.Shares * nOldMult / nNewMult;
// end;
// end;
// end
// else if (Settings.MutualFundList.IndexOf(Trade.Ticker) > -1) then begin // MUT
// if (mult <> '1') then
// sm('error: multiplier ' + mult + ' not allowed for type ' + Trade.TypeMult);
// Trade.TypeMult := 'MUT-1';
// end
// else begin
// i := Settings.ETFsList.IndexOf(Trade.Ticker);
// if (mult <> '1') then
// sm('error: multiplier ' + mult + ' not allowed for type ' + Trade.TypeMult);
// if (i > -1) then
// Trade.TypeMult := Settings.ETFsList[i].subType + '-1';
// end;
// end; // for Trade...
end;


// only used by Trade Type AND blank type error fix
procedure TTLFile.UpdateTypeMultipliers;
type
  PMyList = ^AList;

  AList = record
    tick : string;
    yesno : boolean;
  end;
var
  i : integer;
  bFound : boolean;
  Trade : TTLTrade;
  fuItem : PFutureItem;
  sMult, tUnderly, tLast : string;
  dMult : double;
  myList : TList;
  ARecord : PMyList;
  // ------------------------
  function TypeDebugMsg(t : string) : boolean;
  begin
    sm('ticker: ' + Trade.Ticker + CR //
        + 'old: ' + Trade.TypeMult + CR //
        + 'new: ' + t + '-' + sMult);
  end;
// ------------------------
begin
  for Trade in FTrades do begin
    // --------------------------------
    // Special types
    // --------------------------------
    if (pos('CUR-', Trade.TypeMult) > 0) // Currency type
      or (pos('DCY-', Trade.TypeMult) > 0) // Digital Currency
      or (pos('FUT-', Trade.TypeMult) > 0) // FUT - skip or don't skip Futures?
      or (pos('SSF-', Trade.TypeMult) > 0) // Single-stock Fund
      or (pos('DRP-', Trade.TypeMult) > 0) // Direct ReInvestment Position
    then
      continue; // skip these types of trades (must manually change!)
    // --------------------------------
    dMult := GetMult(Trade.TypeMult); // get Mult
    sMult := FloatToStr(dMult); // save for later
    // --------------------------------
    if IsOption(Trade.TypeMult, Trade.Ticker, true) then begin // OPT types: FUT (BBIO)
    // --------------------------------
      // first, get underlying ticker
      i := pos(' ', Trade.Ticker);
      tUnderly := copy(Trade.Ticker, 1, i - 1);
      bFound := false;
      // 2018-05-30 MB - next, see if it REALLY matches a BBIO
      i := Settings.BBIOList.IndexOf(tUnderly);
      if (i > -1) // if it's in the BBIO list and...
        and (tUnderly = Settings.BBIOList[i].Symbol) // no partial matches!
      then begin
        if (Trade.TypeMult <> 'FUT-' + sMult) then begin
          if (tUnderly <> tLast) then begin
            tLast := tUnderly;
// TypeDebugMsg('FUT');
          end;
          Trade.TypeMult := 'FUT-' + sMult; // Index Option
        end;
        bFound := true;
      end
      else if (Trade.TypeMult <> 'OPT-' + sMult) then begin
        if (tUnderly <> tLast) then begin
          tLast := tUnderly;
// TypeDebugMsg('OPT');
        end;
        Trade.TypeMult := 'OPT-' + sMult;
      end;
    end
    // --------------------------------
    else begin // STK types: MUT, FUT (non BBIO), ETF/CTN/VTN
    // --------------------------------
      tUnderly := Trade.Ticker;
      bFound := false;
      // --------------------
      // if it's in the MUT list, set the type
      if (Settings.MutualFundList.IndexOf(tUnderly) >= 0) then begin
        if (Trade.TypeMult <> 'MUT-' + sMult) then begin
          if (tUnderly <> tLast) then begin
            tLast := tUnderly;
// TypeDebugMsg('MUT');
          end;
          Trade.TypeMult := 'MUT-' + sMult; // convert type to MUT
        end;
        bFound := true;
      end;
      // --------------------
      if not bFound then begin // look in Futures List
        for i := 0 to Settings.FutureList.Count - 1 do begin
          fuItem := Settings.FutureList[i];
// if (fuItem.Name <> trim(fuItem.Name)) then
// sm('trailing space? [' + fuItem.Name + ']');
          if (fuItem.Name = tUnderly) then begin
            if (Trade.TypeMult <> 'FUT-' + sMult) then begin
              if (tUnderly <> tLast) then begin
                tLast := tUnderly;
// TypeDebugMsg('FUT');
              end;
              // do nothing in this case
// Trade.TypeMult := 'FUT-' + sMult; // 2018-05-30 MB - disabled per Jason
            end;
// if abs(dMult - fuItem.Value) > 0.001 then
// sm('Multipliers do not match' + CR //
// + 'value in table: ' + floattostr(fuItem.Value) + CR //
// + 'value in trade: ' + sMult);
// bFound := true; // 2019-08-06 MB - disable this too
// break; // or else we'll never test for ETF/ETN !!!
          end;
        end;
      end;
      // --------------------
      if not bFound then begin // look in ETFs List
        i := Settings.ETFsList.IndexOf(tUnderly);
        if (i > -1) // if it's in the ETF list...
          and (Trade.Ticker = Settings.ETFsList[i].Symbol) // no partial matches!
        then begin
          if (Trade.TypeMult <> Settings.ETFsList[i].subType + '-' + sMult) then begin
            if (tUnderly <> tLast) then begin
              tLast := tUnderly;
// TypeDebugMsg(Settings.ETFsList[i].subType);
// OR
// messagedlg('ticker: ' + Trade.Ticker + CR //
// + 'old: ' + Trade.TypeMult + CR //
// + 'new: ' + Settings.ETFsList[i].subType + '-' + sMult + CR //
// + 'Want to update the ETFs List?', mtConfirmation, [mbYes,mbNo]) = mrYes then begin
// end;
            end;
            Trade.TypeMult := Settings.ETFsList[i].subType + '-' + sMult; // convert to ETF type
          end;
          bFound := true;
        end;
      end;
      // --------------------
      // if it gets here it should be STK
      if not bFound then begin
        if (Trade.TypeMult <> 'STK-1') // not already a STK
          and (pos('FUT-', Trade.TypeMult) < 1) // 2018-05-30 MB - and NOT a FUT
        then begin
          if (tUnderly <> tLast) then begin
            tLast := tUnderly;
// TypeDebugMsg('STK');
// OR
// messagedlg('ticker: ' + Trade.Ticker + CR //
// + 'old: ' + Trade.TypeMult + CR //
// + 'new: ' + Settings.ETFsList[i].subType + '-' + sMult + CR //
// + 'Want to update the ETFs List?', mtConfirmation, [mbYes,mbNo]) = mrYes then begin
// end;
          end;
          Trade.TypeMult := 'STK-' + sMult; // convert deleted MUT, ETF to STK (but not FUT)
        end;
      end;
    end; // if isOption or not
    // --------------------------------
  end; // for Trade...
end;


// This method serves two purposes
// 1) when a file is opened, if we have a EOY mismatch, some accounts off and some on,
// it will turn on those accounts that are off
// 2) When we are importing we will force all on since essentially we are creating a new file
// and the rule that files before EOY don't get this functionality is invalidated.
function TTLFile.VerifyEOYCheckList(ForceAllOn : boolean = false) : boolean;
var
  Header : TTLFileHeader;
  i : TCheckList;
begin
  result := false;
  if (MultiBrokerFile and CheckListOn) or (ForceAllOn) then begin
    { If at least one is on then turn them all on. }
    for Header in FTLFileHeaders do begin
      if Header.BeforeCheckList then begin
        Header.FCheckListItems := '';
        result := true;
        for i := low(TCheckList) to high(TCheckList) do
          Header.FCheckListItems := Header.FCheckListItems + '0';
      end;
    end;
  end;
end;


procedure TTLFile.VerifyOpenPositions;
var
  i : integer;
  TradeNum : TTLTradeNum;
begin
  for i := FTradeNums.Count - 1 downto 0 do begin
    if FTradeNums[i].Shares = 0 then begin
      TradeNum := FTradeNums.Extract(FTradeNums[i]);
      FTradeNums.ClosedTradeNums.Add(TradeNum);
    end;
  end;
end;


procedure TTLFile.VerifyTrade(Trade : TTLTrade);
begin
  // If this is a cancelled Trade make sure it is added.
  if (Trade.oc = 'X') and (FCancelledTrades.IndexOf(Trade) = -1) then
    FCancelledTrades.Add(Trade);
  // If  shares or price is Zero or negative then add it to the list.
  // if ((RndTo5(Trade.Shares) <= 0) or (RndTo5(Trade.Price) < 0))
  if (compareValue(Trade.Shares, 0, NEARZERO) <= 0) or (compareValue(Trade.Price, 0, NEARZERO) < 0)
    and (FZeroOrLessTrades.IndexOf(Trade) = -1) then
    FZeroOrLessTrades.Add(Trade);
end;


procedure TTLFile.AddToClipStr(Trade : TTLTrade; ColsToSkip : TList<integer>;
  var ClipStringList : TStringList);
var
  s : string;
begin
  s := '';
  if (ColsToSkip.IndexOf(0) = -1) then
    s := IntToStr(Trade.FID) + Tab;
  s := s + IntToStr(Trade.FTradeNum) + Tab + datetostr(Trade.FDate, Settings.UserFmt);
  if (ColsToSkip.IndexOf(3) = -1) then
    s := s + Tab + Trade.FTime;
  s := s + Tab + Trade.FOC + Tab + Trade.FLS + Tab + Trade.FTicker + Tab +
    FloatToStr(Trade.FShares, Settings.UserFmt) + Tab + FloatToStr(Trade.FPrice, Settings.UserFmt) +
    Tab + Trade.FTypeMult + Tab + FloatToStr(Trade.FCommission, Settings.UserFmt) + Tab +
    FloatToStr(Trade.FAmount, Settings.UserFmt) + Tab + FloatToStr(Trade.FPL, Settings.UserFmt);
  if (ColsToSkip.IndexOf(13) = -1) then
    s := s + Tab + Trade.FNote;
  if (ColsToSkip.IndexOf(15) = -1) then
    s := s + Tab + Trade.FMatched;
  if (ColsToSkip.IndexOf(16) = -1) then
    s := s + Tab + IntToStr(Trade.FBroker);
  if (ColsToSkip.IndexOf(17) = -1) then
    s := s + Tab + Trade.FOptionTicker;
  if (ColsToSkip.IndexOf(19) = -1) then
    s := s + Tab + Trade.FStrategy;
  if (ColsToSkip.IndexOf(20) = -1) then
    s := s + Tab + Trade.FABCCode;
  if (ColsToSkip.IndexOf(22) = -1) then
    s := s + Tab + Trade.FWSHoldingDate;
  ClipStringList.append(s);
end;


function TTLFile.VerifyUniqueAccountName(const Value : string; BrokerID : integer): boolean;
var
  Header : TTLFileHeader;
begin
  // Verify that the account name is not already used.
  result := true;
  if FTLFileHeaders <> nil then begin
    for Header in FTLFileHeaders do begin
      if Header.BrokerID <> BrokerID then begin
        if Value = Header.AccountName then
          Exit(false);
      end;
    end;
  end;
end;


{ TTradeList }

{ Sort functions and routines. }

function TTradeList.CompareBroker(const Item1, Item2 : TTLTrade): integer;
begin
  result := 0;
  if Item1.Broker < Item2.Broker then
    result := -1
  else if Item1.Broker > Item2.Broker then
    result := 1
end;


function TTradeList.CompareDates(const Item1, Item2 : TTLTrade): integer;
begin
  result := 0;
  if Item1.Date < Item2.Date then
    result := -1
  else if Item1.Date > Item2.Date then
    result := 1
end;


function TTradeList.CompareTime(const Item1, Item2 : TTLTrade): integer;
begin
  result := 0;
  if (length(Item1.Time) > 0) and (length(Item2.Time) > 0) then begin
    if Item1.Time < Item2.Time then
      result := -1
    else if Item1.Time > Item2.Time then
      result := 1
  end
  // or if one record has time and the other does not sort the one without time above the one with time.
  else if (length(Item1.Time) = 0) and (length(Item2.Time) > 0) then
    result := -1
  else if (length(Item1.Time) > 0) and (length(Item2.Time) = 0) then
    result := 1;
end;


function TTradeList.CompareItem(const Item1, Item2 : TTLTrade): integer;
begin
  result := 0;
  if Item1.ID < Item2.ID then
    result := -1
  else if Item1.ID > Item2.ID then
    result := 1
end;


function TTradeList.CompareTrNumber(const Item1, Item2 : TTLTrade): integer;
begin
  result := 0;
  if Item1.TradeNum < Item2.TradeNum then
    result := -1
  else if Item1.TradeNum > Item2.TradeNum then
    result := 1
end;


function TTradeList.CompareWashSales(const Item1, Item2 : TTLTrade): integer;
begin
  { This compare pushes wash sales to the top of the TrNumber group. }
  result := 0;
  if (Item1.oc = 'W') and (Item2.oc <> 'W') then
    result := -1
  else if (Item2.oc = 'W') and (Item1.oc <> 'W') then
    result := 1;
end;


function TTradeList.CompareWashSalesDesc(const Item1, Item2 : TTLTrade): integer;
begin
  { This compare pushes wash sales to the top of the TrNumber group. }
  result := 0;
  if (Item1.oc = 'W') and (Item2.oc <> 'W') then
    result := 1
  else if (Item2.oc = 'W') and (Item1.oc <> 'W') then
    result := -1;
end;


constructor TTradeList.Create;
begin
  inherited Create(TTradeComparer.Construct(
        function(const Item1, Item2 : TTLTrade): integer
    begin
      result := 0;
      if (Item1 <> nil) and (Item2 <> nil) then begin
        if Item1.ID < Item2.ID then
          result := -1
        else if Item1.ID > Item2.ID then
          result := 1;
      end;
    end));
end;


procedure TTradeList.FreeAll;
var
  Trade : TTLTrade;
begin
  if self <> nil then begin
    for Trade in self do
      Trade.Free;
    self.Free;
  end;
end;


function TTradeList.CompareTickers(const Item1, Item2 : TTLTrade) : integer;
begin
  result := 0;
  if Item1.Ticker < Item2.Ticker then
    result := -1
  else if Item1.Ticker > Item2.Ticker then
    result := 1
end;


function TTradeList.CompareLSDescending(const Item1, Item2 : TTLTrade) : integer;
begin
  result := 0;
  if Item1.ls < Item2.ls then
    result := 1
  else if Item1.ls > Item2.ls then
    result := -1
end;


function TTradeList.CompareOCAscending(const Item1, Item2 : TTLTrade) : integer;
begin
  result := 0;
  if Item1.oc > Item2.oc then
    result := 1
  else if Item1.oc < Item2.oc then
    result := -1
end;


function TTradeList.CompareOCDescending(const Item1, Item2 : TTLTrade) : integer;
begin
  result := 0;
  if Item1.oc < Item2.oc then
    result := 1
  else if Item1.oc > Item2.oc then
    result := -1
end;


procedure TTradeList.SortByDate;
begin
  FSortBy := 'dt';
  Sort(TTradeComparer.Construct(
    function(const Item1, Item2 : TTLTrade): integer
    begin
      result := CompareDates(Item1, Item2);
      if (result = 0) and ((length(Item1.Time) > 0) or (length(Item2.Time) > 0)) then
        result := CompareTime(Item1, Item2);
      if result = 0 then
        result := CompareItem(Item1, Item2);
      if result = 0 then
        result := CompareBroker(Item1, Item2);
    end));
end;


procedure TTradeList.SortByOpenClose;
begin
  FSortBy := 'OC';
  Sort(TTradeComparer.Construct(
    function(const Item1, Item2 : TTLTrade): integer
    begin
      result := CompareTickers(Item1, Item2);
      if result = 0 then
        result := CompareDates(Item1, Item2);
      if (result = 0) and ((length(Item1.Time) > 0) or (length(Item2.Time) > 0)) then
        result := CompareTime(Item1, Item2);
      if result = 0 then
        result := CompareLSDescending(Item1, Item2);
      if result = 0 then
        result := CompareOCDescending(Item1, Item2);
      if result = 0 then
        result := CompareItem(Item1, Item2);
      if result = 0 then
        result := CompareBroker(Item1, Item2);
    end));
end;


procedure TTradeList.SortByTicker;
begin
  FSortBy := 'tk';
  Sort(TTradeComparer.Construct(
    function(const Item1, Item2 : TTLTrade): integer
    begin
      result := CompareTickers(Item1, Item2);
      if result = 0 then
        result := CompareDates(Item1, Item2);
      if (result = 0) and ((length(Item1.Time) > 0) or (length(Item2.Time) > 0)) then
        result := CompareTime(Item1, Item2);
      if result = 0 then
        result := CompareItem(Item1, Item2);
      if result = 0 then
        result := CompareBroker(Item1, Item2);
    end));
end;


procedure TTradeList.SortByTickerForMatching;
begin
  FSortBy := 'ws';
  Sort(TTradeComparer.Construct(
    function(const Item1, Item2 : TTLTrade): integer
    begin
      result := CompareTickers(Item1, Item2);
      // put W recs at top of list
      if (result = 0) then
        result := CompareWashSalesDesc(Item1, Item2);
      if (result = 0) then
        result := CompareDates(Item1, Item2);
      if (result = 0) and ((length(Item1.Time) > 0) or (length(Item2.Time) > 0)) then
        result := CompareTime(Item1, Item2);
      if (result = 0) then
        result := CompareItem(Item1, Item2);
      if (result = 0) then
        result := CompareBroker(Item1, Item2);
    end));
end;


procedure TTradeList.SortByTrNumber;
begin
  FSortBy := 'tr';
  Sort(TTradeComparer.Construct(
    function(const Item1, Item2 : TTLTrade): integer
    begin
      result := CompareTrNumber(Item1, Item2);
    { Always push wash sales to the top of the list for a TrNumber }
      if result = 0 then
        result := CompareWashSales(Item1, Item2);
      if result = 0 then
        result := CompareDates(Item1, Item2);
      if (result = 0) and ((length(Item1.Time) > 0) or (length(Item2.Time) > 0)) then
        result := CompareTime(Item1, Item2);
      if (result = 0) then
        result := CompareOCDescending(Item1, Item2);
      if result = 0 then
        result := CompareItem(Item1, Item2);
      if result = 0 then
        result := CompareBroker(Item1, Item2);
    end));
end;


{ TTLTrade }

constructor TTLTrade.Create;
begin
  FID := 0;
  FTradeNum := 0;
  FTicker := '';
  FDate := 0;
  FTime := '';
  FOC := ' ';
  FLS := ' ';
  FMatched := '';
  FBroker := 0;
  FPrice := 0;
  FShares := 0;
  FCommission := 0;
  FAmount := 0;
  FTypeMult := 'STK-1';
  FNote := '';
  FStrategy := '';
  FABCCode := ' ';
  FOptionTicker := '';
  FEdited := false;
  FWSMatchedShares := 0;
  FWSHoldingDate := '';
end;


constructor TTLTrade.Create(Trade : TTrade);
var
  D : TDateTime;
begin
  Create;
  FID := Trade.it;
  FTradeNum := Trade.tr;
  FDate := xStrToDate(Trade.dt, Settings.InternalFmt);
  FTime := Trade.tm;
  FTicker := Trade.tk;
  if length(Trim(Trade.oc)) > 0 then
    FOC := WideChar(Trade.oc[1])
  else
    FOC := ' ';
  // ----------------------------------
  if length(Trim(Trade.ls)) > 0 then
    FLS := WideChar(Trade.ls[1])
  else
    FLS := ' ';
  FShares := Trade.sh;
  FCommission := Trade.cm;
  FAmount := Trade.am;
  FPrice := Trade.pr;
  FTypeMult := Trade.prf;
  FNote := Trade.no;
  FMatched := Trade.m;
  FABCCode := WideChar(Trade.abc[1]);
  FOptionTicker := Trade.opTk;
  if (length(Trade.HoldingDate) > 0) and (TryStrToDate(Trade.HoldingDate, D, Settings.InternalFmt))
  then
    FWSHoldingDate := Trade.HoldingDate;
  if isInt(Trade.br) then
    FBroker := StrToInt(Trade.br)
  else
    FBroker := 0;
  FStrategy := Trade.strategy;
end;


procedure TTLTrade.Assign(Trade : TPersistent);
begin
  if Trade is TTLTrade then begin
    FID := TTLTrade(Trade).ID;
    FTradeNum := TTLTrade(Trade).TradeNum;
    FDate := TTLTrade(Trade).FDate;
    FTime := TTLTrade(Trade).Time;
    FTicker := TTLTrade(Trade).Ticker;
    FOC := TTLTrade(Trade).oc;
    FLS := TTLTrade(Trade).ls;
    FShares := TTLTrade(Trade).Shares;
    FCommission := TTLTrade(Trade).Commission;
    FAmount := TTLTrade(Trade).Amount;
    FPrice := TTLTrade(Trade).Price;
    FTypeMult := TTLTrade(Trade).TypeMult;
    FNote := TTLTrade(Trade).Note;
    FMatched := TTLTrade(Trade).Matched;
    FABCCode := TTLTrade(Trade).ABCCode;
    FOptionTicker := TTLTrade(Trade).OptionTicker;
    FBroker := TTLTrade(Trade).Broker;
    FStrategy := TTLTrade(Trade).strategy;
    FWSHoldingDate := TTLTrade(Trade).FWSHoldingDate;
  end
  else
    inherited Assign(Trade);
end;


constructor TTLTrade.Create(Trade : TTLTrade);
begin
  Create;
  Assign(Trade);
end;


function TTLTrade.GetDate : TDate;
begin
  result := FDate; // xStrToDate(FDate, Settings.UserFmt);
end;


function TTLTrade.GetMultiplier : double;
var
  s : string;
begin
  result := 1;
  s := FTypeMult;
  delete(s, 1, pos('-', s));
  if IsFloatEx(s, Settings.UserFmt) then
    result := StrToFloat(s, Settings.UserFmt)
end;


function TTLTrade.GetIsStockType : boolean;
begin
  result := TLCommonLib.IsStockType(FTypeMult);
end;


function TTLTrade.GetOpen : boolean;
begin
  result := true;
  if FTLTradeNum <> nil then
    result := not FTLTradeNum.Complete;
end;


function TTLTrade.GetOpenShares : double;
var
  i : integer;
begin
  result := 0;
  if FTLTradeNum <> nil then begin
    for i := 0 to FTLTradeNum.Count - 1 do begin
      if CharInSet(FTLTradeNum[i].oc, ['M', 'C']) then
        result := result - FTLTradeNum[i].Shares
      else if FTLTradeNum[i].oc <> 'W' then
        result := result + FTLTradeNum[i].Shares;
      if self = FTLTradeNum[i] then
        break;
    end;
  end
  else if oc <> 'W' then
    result := Shares;
end;


function TTLTrade.GetPL : double;
begin
  result := FPL;
end;


procedure TTLTrade.SetPL(const Value : double);
begin
  FPL := Value;
end;


function TTLTrade.GetTradeType : string;
begin
  result := TypeMult;
  if (pos('-', result) > 0) then
    result := copy(result, 1, pos('-', result) - 1);
end;


function TTLTrade.GetWSHoldingDate : TDate;
begin
  if length(FWSHoldingDate) > 0 then
    result := xStrToDate(FWSHoldingDate, Settings.InternalFmt)
  else
    result := 0;
end;


procedure TTLTrade.CalcAmount;
var
  i, Idx : integer;
  Mult : double;
begin
  if CalcOff then
    Exit; // turn CalcAmount ON/OFF 5/13/2015 MB
  try
    if (FOC = 'W') or (FShares = 0) then
      Exit;
    // 2014-03-08 Schwab OFX wrong commission problem:
    // if commission is wrong then we do NOT want to recalc the amount
    // and we should always use amount before commission
    // ------------------------------------------
    // 2015-04-07 fix for Schwab options not getting the right commission
    Mult := GetMultiplier;
//    if (OFX and (FAmount = 0)) or not OFX then begin
      // calc amount
      if (((FOC = 'O') and (FLS = 'L')) //
      or (CharInSet(FOC, ['C', 'M']) and (FLS = 'S'))) then
        FAmount := -RndTo5(FShares * FPrice * Mult + FCommission)
      else if (((FOC = 'O') and (FLS = 'S')) //
        or (CharInSet(FOC, ['C', 'M']) and (FLS = 'L'))) then
        FAmount := RndTo5(FShares * FPrice * Mult - FCommission);
//    end
//    else begin
//      // recalc commis
//      if (((FOC = 'O') and (FLS = 'L')) //
//        or (CharInSet(FOC, ['C', 'M']) and (FLS = 'S'))) then begin
//        FCommission := -RndTo5(FShares * FPrice * Mult) - FAmount;
//      end
//      else if (((FOC = 'O') and (FLS = 'S')) //
//        or (CharInSet(FOC, ['C', 'M']) and (FLS = 'L'))) then
//        FCommission := RndTo5(FShares * FPrice * Mult) - FAmount;
//    end;
    CalcPL; // For this record
    // Must also calculate PL for everything below this record, since
    // changing it could change PL for everything that comes after it.
    // Assume this record has already been added to the TLFile.
    // Otherwise skip this for now
    if (FTLTradeNum <> nil) and (FTLTradeNum.Count > 0) then begin
      Idx := FTLTradeNum.IndexOf(self);
      if (Idx > -1) and (Idx < FTLTradeNum.Count - 1) then begin
        for i := Idx + 1 to FTLTradeNum.Count - 1 do
          FTLTradeNum[i].CalcPL
      end;
    end;
  except
    on E : Exception do begin
      if superUser then
        sm('Error: ' + E.Message);
    end;
  end;
end; // CalcAmount


// 2015-07-13 Calcs P&L after loading entire file
procedure TTLFile.calcProfit;
var
  i, j, x, y, iTr, iTrLast : integer;
  closeSh, openSh, openAmt, cost : double;
  OpenList : TTradeList;
  myTrade : TTLTrade;
  // ------------------------
  procedure calcCost(bAmt : boolean = false);
  begin
    if bAmt then begin
      if (myTrade.ls = 'L') then
        cost := cost - openAmt
      else
        cost := cost + openAmt;
    end
    else begin
      if (myTrade.ls = 'L') then
        cost := cost - (openAmt / openSh * closeSh)
      else
        cost := cost + (openAmt / openSh * closeSh);
    end;
    // sm('cost = '+floatToSTr(Cost));
  end;

// ------------------------
begin
  x := 0;
  iTrLast := 0;
  openSh := 0;
  openAmt := 0;
  OpenList := TTradeList.Create;
  DoStatus('Calculating Profit/Loss');
  for i := 0 to TradeList.Count - 1 do begin
    // loop thru close records only
    if not CharInSet(TradeList[i].oc, ['C', 'M', 'W']) then
      continue;
    // wash sale deferrals
    if TradeList[i].oc = 'W' then begin
      TradeList[i].PL := TradeList[i].Amount;
      continue;
    end;
    // set variables
    cost := 0;
    closeSh := TradeList[i].Shares;
    iTr := TradeList[i].TradeNum;
    // load OpenList for each close TradeNum
    if iTr > iTrLast then begin
      OpenList.Clear;
      for j := x to TradeList.Count - 1 do begin
        if (TradeList[j].TradeNum > iTr) then
          break;
        if (TradeList[j].TradeNum <> iTr) then
          continue;
        if (TradeList[j].oc <> 'O') then
          continue;
        OpenList.Add(TradeList[j]);
      end;
      // sm('TrNum = '+intToStr(iTr)+cr+'myTradeList.Count = '+IntToStr(myTradeList.Count));
      x := i; // start inner loop at first record of new TrNum
      y := -1; // reset open trade list index
      openSh := 0;
      openAmt := 0;
    end;
    iTrLast := iTr;
    // sm('closeSh = '+floatToStr(closeSh));
    // loop thru openList to get cost basis
    for j := 0 to OpenList.Count - 1 do begin
      // do not use opens that have already been used for cost basis
      if j <= y then
        continue;
      myTrade := OpenList[j];
      // use
      if (openSh = 0) then begin
        openSh := myTrade.Shares;
        openAmt := myTrade.Amount;
      end;
      if (RndTo5(closeSh) > RndTo5(openSh)) then begin
        calcCost(true);
        closeSh := closeSh - openSh;
        openSh := 0;
        openAmt := 0;
        y := j;
      end
      else if (RndTo5(closeSh) = RndTo5(openSh)) then begin
        calcCost;
        closeSh := 0;
        openSh := 0;
        openAmt := 0;
        y := j;
        break;
      end
      else if (RndTo5(closeSh) < RndTo5(openSh)) then begin
        calcCost;
        openAmt := openAmt * (openSh - closeSh) / openSh;
        openSh := openSh - closeSh;
        closeSh := 0;
        break;
      end;
    end;
    // save close record P&L
    if TradeList[i].ls = 'L' then
      TradeList[i].PL := RndTo5(TradeList[i].Amount - cost)
    else
      TradeList[i].PL := RndTo5(TradeList[i].Amount + cost);
  end;
  FreeAndNil(OpenList);
end;


// 2015-07-13 Calcs P&L each time a record is added
// *** THIS ROUTINE MASSIVELY SLOWS DOWN OPENING LARGE FILES ***
// loadRecords now uses calcProfit instead
procedure TTLTrade.CalcPL;
var
  cost : double;
  openSh, closeSh, ClosedPrior : double;
  Trade : TTLTrade;
begin
  try
    // If this record has not been added to the file yet it will
    // not have a TradeNumList associated with it.
    // Therefore we will just return zero for now.
    if FTLTradeNum = nil then begin
      FPL := 0;
      Exit;
    end;
    cost := 0;
    openSh := 0;
    closeSh := 0;
    ClosedPrior := 0;
    if oc = 'O' then
      FPL := 0
    else if oc = 'W' then
      FPL := Amount
    else begin // Close or MTM Record
      // This is a Close Record with no previous open record,
      // Therefore we do not report a profit and loss on this
      // as it is considered a negative share error.
      if (FTLTradeNum.Count = 0) //
        or (FTLTradeNum[0].ID = ID) then begin
        FPL := 0;
        Exit;
      end;
      // First need to calculate what has already been closed before this
      for Trade in FTLTradeNum do begin
        // We have arrived at this record so stop looking for close records.
        if Trade.ID = FID then
          break;
        // We need to add up the previously closed records for use later
        if CharInSet(Trade.oc, ['C', 'M']) then
          ClosedPrior := ClosedPrior + Trade.Shares
      end;
      closeSh := Shares;
      for Trade in FTLTradeNum do begin
        if CharInSet(Trade.oc, ['C', 'M', 'W']) then
          continue;
        if (ClosedPrior > NEARZERO) //
        and (Trade.Shares <= ClosedPrior) //
        then begin
          ClosedPrior := ClosedPrior - Trade.Shares;
          continue;
        end;
        // If we got here and ClosedPrior is still greater than zero then
        // we need to just use from Trade.Shares what was not already closed.
        if openSh = 0 then begin
          openSh := Trade.Shares - ClosedPrior;
          ClosedPrior := 0;
        end;
        if (RndTo5(closeSh) > RndTo5(openSh)) then begin
          // if (Trade.Shares > 0) then
          if (compareValue(Trade.Shares, 0, NEARZERO) > 0) then begin
            if (Trade.ls = 'L') then
              cost := cost - Trade.Amount / Trade.Shares * openSh
            else
              cost := cost + Trade.Amount / Trade.Shares * openSh;
          end;
          closeSh := closeSh - openSh;
          openSh := 0;
        end
        else if (RndTo5(closeSh) = RndTo5(openSh)) then begin
          // if (Trade.Shares > 0)
          if (compareValue(Trade.Shares, 0, NEARZERO) > 0)
          // and (CloseSh > 0) then
            and (compareValue(closeSh, 0, NEARZERO) > 0) then begin
            if (Trade.ls = 'L') then
              cost := cost - Trade.Amount / Trade.Shares * closeSh
            else
              cost := cost + Trade.Amount / Trade.Shares * closeSh;
          end;
          openSh := 0;
          closeSh := 0;
          break;
        end
        else if (RndTo5(closeSh) < RndTo5(openSh)) then begin
          if (Trade.ls = 'L') then
            cost := cost - Trade.Amount / Trade.Shares * closeSh
          else
            cost := cost + Trade.Amount / Trade.Shares * closeSh;
          openSh := openSh - closeSh;
          closeSh := 0;
          break;
        end;
      end;
      if ls = 'L' then
        FPL := Amount - cost
      else
        FPL := Amount + cost;
      FPL := RndTo5(FPL);
    end;
  except
    on E : Exception do begin
      if superUser then
        sm('Error: ' + E.Message);
    end;
  end;
end; // CalcPL


procedure TTLTrade.SetABCCode(const Value : string);
begin
  if (Value <> FABCCode) then begin
    FABCCode := Value;
    FEdited := true;
  end;
end;

procedure TTLTrade.SetAmount(const Value : double);
begin
  if (Value <> FAmount) then begin
    FAmount := Value;
    FEdited := true;
  end;
end;

procedure TTLTrade.SetBroker(const Value : integer);
begin
  if (Value <> FBroker) then begin
    FBroker := Value;
    FEdited := true;
  end;
end;

procedure TTLTrade.SetCommission(const Value : double);
begin
  if (Value <> FCommission) then begin
    FCommission := Value;
    FEdited := true;
    CalcAmount;
  end;
end;

procedure TTLTrade.SetDate(const Value : TDate);
begin
  if (Value <> FDate) then begin
    FDate := Value;
    FEdited := true;
  end;
end;

procedure TTLTrade.SetID(const Value : integer);
begin
  if (Value <> FID) then begin
    FID := Value;
    FEdited := true;
  end;
end;

procedure TTLTrade.SetLS(const Value : Char);
begin
  if (Value <> FLS) then begin
    FLS := Value;
    FEdited := true;
    CalcAmount;
  end;
end;

procedure TTLTrade.SetMatched(const Value : string);
begin
  if (Value <> FMatched) then begin
    FMatched := Value;
    FEdited := true;
  end;
end;

procedure TTLTrade.SetNote(const Value : string);
begin
  if (Value <> FNote) then begin
    FNote := Value;
    FEdited := true;
  end;
end;

procedure TTLTrade.SetOC(const Value : Char);
begin
  if (Value <> FOC) then begin
    FOC := Value;
    FEdited := true;
    CalcAmount;
  end;
end;

procedure TTLTrade.SetOptionTicker(const Value : string);
begin
  if (Value <> FOptionTicker) then begin
    FOptionTicker := Value;
    FEdited := true;
  end;
end;

procedure TTLTrade.SetPrice(const Value : double);
begin
  if (Value <> FPrice) then begin
    FPrice := Value;
    FEdited := true;
    CalcAmount;
  end;

end;

procedure TTLTrade.SetShares(const Value : double);
begin
  if (Value <> FShares) then begin
    FShares := RndTo5(Value);
    FEdited := true;
    CalcAmount;
  end;

end;

procedure TTLTrade.SetStrategy(const Value : string);
begin
  if (Value <> FStrategy) then begin
    FStrategy := Value;
    FEdited := true;
  end;
end;

procedure TTLTrade.SetTicker(const Value : string);
begin
  if (Value <> FTicker) then begin
    FTicker := Value;
    FEdited := true;
  end;
end;

procedure TTLTrade.SetTime(const Value : string);
begin
  if (Value <> FTime) then begin
    FTime := Value;
    FEdited := true;
  end;
end;

procedure TTLTrade.SetTradeNum(const Value : integer);
begin
  if (Value <> FTradeNum) then begin
    FTradeNum := Value;
    FEdited := true;
  end;
end;

procedure TTLTrade.SetTypeMult(const Value : string);
begin
  if (Value <> FTypeMult) then begin
    FTypeMult := Value;
    FEdited := true;
  end;
end;

procedure TTLTrade.SetWSHoldingDate(const Value : TDate);
begin
  FWSHoldingDate := datetostr(Value, Settings.InternalFmt);
end;


function TTLTrade.AsString : string;
begin
  result := 'ID: ' + IntToStr(FID) + ', ';
  result := result + 'TradeNum: ' + IntToStr(FTradeNum) + ', ';
  result := result + 'Date: ' + datetostr(FDate, Settings.UserFmt) + ', ';
  if length(FTime) > 0 then
    result := result + 'Time: ' + FTime + ', ';
  result := result + 'OpenClose: ' + FOC + ', ';
  result := result + 'LongShort: ' + FLS + ', ';
  result := result + 'Ticker: ' + FTicker + ', ';
  result := result + 'TypeMult: ' + FTypeMult + ', ';
  result := result + 'Sh/Cont: ' + FloatToStr(FShares) + ', ';
  result := result + 'Price: ' + FloatToStr(FPrice) + ', ';
  result := result + 'Commission: ' + FloatToStr(FCommission) + ', ';
  result := result + 'Amount: ' + FloatToStr(FAmount) + ', ';
  result := result + 'PL: ' + FloatToStr(FPL) + ', ';
  result := result + 'Strategy: ' + FStrategy + ', ';
  result := result + 'Matched: ' + FMatched + ', ';
  result := result + 'ABCCode: ' + FABCCode + ', ';
  result := result + 'OptTicker: ' + FOptionTicker + ', ';
  result := result + 'Note: ' + FNote + ', ';
  result := result + 'BrokerID: ' + IntToStr(FBroker);
  if (length(FWSHoldingDate) > 0) and (FWSHoldingDate <> '0') then
    result := result + ', WSHoldingDate: ' + datetostr(WSHoldingDate, Settings.UserFmt);
end;


function TTLTrade.AsStringList : TStringList;
begin
  result := TStringList.Create;
  result.Add('ID: ' + IntToStr(FID));
  result.Add('TradeNum: ' + IntToStr(FTradeNum));
  result.Add('Date: ' + datetostr(FDate, Settings.UserFmt));
  result.Add('Time: ' + FTime);
  result.Add('OpenClose: ' + FOC);
  result.Add('LongShort: ' + FLS);
  result.Add('Ticker: ' + FTicker);
  result.Add('TypeMult: ' + FTypeMult);
  result.Add('Sh/Cont: ' + FloatToStr(FShares));
  result.Add('Price: ' + FloatToStr(FPrice));
  result.Add('Commission: ' + FloatToStr(FCommission));
  result.Add('Amount: ' + FloatToStr(FAmount));
  result.Add('PL: ' + FloatToStr(FPL));
  result.Add('Strategy: ' + FStrategy);
  result.Add('Matched: ' + FMatched);
  result.Add('ABCCode: ' + FABCCode);
  result.Add('OptTicker: ' + FOptionTicker);
  result.Add('Note: ' + FNote);
  result.Add('BrokerID: ' + IntToStr(FBroker));
  if (length(FWSHoldingDate) > 0) and (FWSHoldingDate <> '0') then
    result.Add('WSHoldingDate: ' + datetostr(WSHoldingDate, Settings.UserFmt))
  else
    result.Add('WSHoldingDate: ')
end;


{ TTLOpenTradeNums }

function TTLTradeNum.Add(Value : TTLTrade; CalcPL : boolean = true): integer;
begin
  result := inherited Add(Value);
  Value.FTLTradeNum := self;
  if (Parent <> nil) and (Parent.Parent <> nil) then begin
    if (Value.TradeType <> TradeType) then
      Parent.Parent.MisMatchedTrades.Add(Value)
    else if (Parent.Parent.MisMatchedTrades.IndexOf(Value) > -1) then
      Parent.Parent.MisMatchedTrades.Extract(Value);
    if (Value.ls <> ls) then
      Parent.Parent.MisMatchedLS.Add(Value)
    else if (Parent.Parent.MisMatchedLS.IndexOf(Value) > -1) then
      Parent.Parent.MisMatchedLS.Extract(Value);
    if (Parent.Parent.ZeroOrLessTrades.IndexOf(Value) > -1) //
    and (compareValue(Value.Shares, 0, NEARZERO) > 0) //
    and (compareValue(Value.Price, 0, NEARZERO) >= 0) //
    then
      Parent.Parent.ZeroOrLessTrades.Extract(Value);
    if (Parent.Parent.CancelledTrades.IndexOf(Value) > -1) //
    and (Value.oc <> 'X') then
      Parent.Parent.CancelledTrades.Extract(Value);
  end;
end;


constructor TTLTradeNum.Create;
begin
  inherited Create;
end;


function TTLFile.FindAssociatedOpenTrade(MTMTrade : TTLTrade): TTLTrade;
var
  Trade : TTLTrade;
begin
  for Trade in TradeList do
    if (Trade.Date = MTMTrade.Date + 1) and (Trade.Time = '00:00:00') //
    and (Trade.Ticker = MTMTrade.Ticker) and (Trade.Shares = MTMTrade.Shares) //
    and (Trade.Price = MTMTrade.Price) and (Trade.oc = 'O') //
    and (Trade.Broker = MTMTrade.Broker) then begin
      Exit(Trade);
    end;
  Exit(nil);
end;


procedure TTLTradeNum.UpdateSection481(Price : double);
var
  Trade, MTrade, OTrade : TTLTrade;
  EndOfLastYear : TDate;
  StartOfThisYear : TDate;
  TotalShares : double;
  NextMatchNumber : integer;
begin
  EndOfLastYear := xStrToDate('12/31/' + IntToStr(Parent.Parent.LastTaxYear));
  StartOfThisYear := xStrToDate('01/01/' + IntToStr(Parent.Parent.TaxYear));
  NextMatchNumber := 0;
  TotalShares := 0;
  MTrade := nil;
  OTrade := nil;
  for Trade in self do begin
    if (Trade.Date = EndOfLastYear) and (Trade.oc = 'M') and (Trade.Time = '23:59:59') then
      MTrade := Trade
    else if (Trade.Date <= EndOfLastYear) and (Trade.oc = 'O') then
      TotalShares := TotalShares + Trade.Shares;
  end;
  if not Parent.Parent.CurrentAccount.MTMLastYear then begin
    { If we got here and Trade is nil then there is no M Trade
      so if we were not MTM Last Year then Create the M Record to Close Last Year's position }
    if (MTrade = nil) then begin
      MTrade := TTLTrade.Create;
      MTrade.TradeNum := self.TradeNum;
      MTrade.Date := EndOfLastYear;
      MTrade.oc := 'M';
      MTrade.ls := self.ls;
      MTrade.Ticker := self.Ticker;
      MTrade.TypeMult := self.TypeMult;
      MTrade.Price := Price;
      MTrade.Shares := TotalShares;
      MTrade.Broker := self.BrokerID;
      MTrade.Time := '23:59:59';
      MTrade.Matched := self.Matched;
      { Update Trade will update an existing trade of add a new trade if it doesn't exist. }
      Parent.Parent.AddTrade(MTrade);
    end
    else begin { Otherwise update the existing record to reflect the right share amount }
      OTrade := Parent.Parent.FindAssociatedOpenTrade(MTrade);
      MTrade.Shares := TotalShares;
      Parent.Parent.UpdateTrade(MTrade);
    end;
    { If we got here and the OTrade is nil then there is no open record with this price
    so add it. }
    if OTrade = nil then begin
      OTrade := TTLTrade.Create(MTrade);
      OTrade.ID := 0;
      OTrade.TradeNum := 0;
      OTrade.oc := 'O';
      OTrade.Date := xStrToDate('01/01/' + IntToStr(Parent.Parent.TaxYear));
      OTrade.Time := '00:00:00';
      { If this was a matched lot then we need to assign a new Matched lot number to the open
        record as well as any records in the current tax year that were matched to this group. }
      if isInt(OTrade.Matched) then begin
        OTrade.Matched := IntToStr(Parent.Parent.NextMatchNumber);
        for Trade in self do begin
          if (Trade.Date > EndOfLastYear) and isInt(Trade.Matched) then
            Trade.Matched := OTrade.Matched;
        end;
      end;
      Parent.Parent.AddTrade(OTrade);
    end
    else begin { Otherwise update the share amount of the existing record. }
      OTrade.Shares := MTrade.Shares;
      Parent.Parent.UpdateTrade(OTrade);
    end;
  end
  else if OpeningMTMRecord <> nil then
    OpeningMTMRecord.Price := Price;
  // We just want to update the Open Shares price record
end;


function TTLTradeNum.GetAmount : double;
var
  Trade : TTLTrade;
begin
  result := 0;
  for Trade in self do begin
    if Trade.oc <> 'W' then
      result := result + Trade.Amount
  end;
end;


function TTLTradeNum.GetAmountAsOf(AsOfDate : TDate): double;
var
  Trade : TTLTrade;
begin
  result := self.SharesAsOf[AsOfDate] * self.AveragePriceAsOf[AsOfDate] * self.Multiplier;
end;


function TTLTradeNum.GetAveragePrice : double;
var
  Trade : TTLTrade;
  i : integer;
  OpenShares : double;
begin
  result := 0;
  OpenShares := self.Shares;
  for i := self.Count - 1 downto 0 do begin
    Trade := self[i];
    if Trade.oc = 'O' then begin
      if (Trade.Shares <= OpenShares) then begin
        result := result + Abs(Trade.Amount);
        OpenShares := rndTo5(OpenShares - Trade.Shares);
      end
      else begin
        result := result + Abs(((OpenShares / Trade.Shares) * Trade.Amount));
        OpenShares := 0;
      end;
      if OpenShares = 0 then
        break;
    end;
  end;
  if result > 0 then
    result := RndTo5(result / Multiplier / self.Shares);
end;


function TTLTradeNum.GetAveragePriceAsOf(AsOfDate : TDate): double;
var
  Trade : TTLTrade;
  i : integer;
  OpenShares : double;
begin
  if AsOfDate > self.LastDate then
    Exit(GetAveragePrice);
  result := 0;
  OpenShares := self.SharesAsOf[AsOfDate];
  for i := Count - 1 downto 0 do begin
    Trade := Items[i];
    if Trade.Date <= AsOfDate then begin
      if Trade.oc = 'O' then begin
        if (Trade.Shares <= OpenShares) then begin
          result := result + Abs(Trade.Amount);
          OpenShares := rndTo5(OpenShares - Trade.Shares);
        end
        // else if OpenShares > 0 then
        else if (compareValue(OpenShares, 0, NEARZERO) > 0) then begin
          result := result + Abs(((OpenShares / Trade.Shares) * Trade.Amount));
          OpenShares := 0;
        end;
        // if OpenShares = 0 then
        if (compareValue(OpenShares, 0, NEARZERO) = 0) then
          break;
      end;
    end;
  end;
  if result > 0 then
    result := RndTo5(result / Multiplier / self.SharesAsOf[AsOfDate]);
end;


function TTLTradeNum.GetBrokerID : integer;
begin
  result := 0;
  if Count > 0 then
    result := Items[0].Broker;
end;


function TTLTradeNum.GetWashSalesOnly : boolean;
var
  Trade : TTLTrade;
begin
  result := true;
  for Trade in self do begin
    if Trade.oc <> 'W' then begin
      result := false;
      Exit;
    end;
  end;
end;


// ----------------------------------------------
// Transfer Open Positions (O & W records)
// ----------------------------------------------
procedure TTLTradeNum.TransferOpenPosition(
  BrokerID: integer;
  NewTradeNum: integer;
  var ORecDatesList: TList<double>);
var
  i, i2: integer;
  Trade: TTLTrade;
  OpenShares, OpenWShares: double;
  nRatio: double;
  s: string;
begin
  OpenShares := Shares; // property calls GetShares
  OpenWShares := WShares; // property calls GetWShares
  if OpenWShares > OpenShares then
    OpenWShares := OpenShares; // can be less, but not more!
  self.SortByDate;
  // --------------
//  s := 'ID TR Date OC Shares' + CRLF;
//  for i := Count - 1 downto 0 do begin // assumes FIFO only!
//    s := s + inttostr(self[i].FID) + ' ' //
//      + inttostr(self[i].TradeNum) + ' ' //
//      + datetostr(self[i].Date) + ' ' //
//      + self[i].oc + ' ' //
//      + floattostr(self[i].FShares) + CRLF;
//  end;
//  sm(s);
  // --- loop #1 --------------------------------
  for i := Count - 1 downto 0 do begin // assumes FIFO only!
    // --------------------------------
    if (OpenWShares > 0) //
    and (self[i].oc = 'W') then begin
      if (ORecDatesList.IndexOf(self[i].Date) < 0) then
        continue; // W must have matching O
      // --------------------
      if self[i].Shares <= OpenWShares then begin
        Trade := self.Extract(self[i]);
        Trade.Broker := BrokerID; // new account.
        Trade.TradeNum := NewTradeNum;
        OpenWShares := OpenWShares - Trade.Shares;
        if OpenWShares < 0 then
          OpenWShares := 0;
      end //
      // --------------------
      else begin // need to split
        Trade := TTLTrade.Create(self[i]);
        Trade.TradeNum := NewTradeNum;
        Trade.ID := 0;
        Trade.Broker := BrokerID;
        nRatio := OpenWShares / Trade.Shares;
        Trade.Amount := Trade.Amount * nRatio;
        if Trade.Commission > NEARZERO then
          Trade.Commission := Trade.Commission * nRatio;
        Trade.Shares := OpenWShares;
        Parent.Parent.AddTrade(Trade);
        self[i].Amount := self[i].Amount - Trade.Amount;
        if (self[i].Commission > Trade.Commission) then
          self[i].Commission := self[i].Commission - Trade.Commission;
        self[i].Shares := self[i].Shares - OpenWShares;
        OpenWShares := 0;
      end; // if self[i].Shares
    end // if W block
    // --------------------------------
    else if (OpenShares > NEARZERO) //
    and (self[i].oc = 'O') then begin
      // --------------------
      if (ORecDatesList.IndexOf(self[i].Date) < 0) then
        ORecDatesList.Add(self[i].Date);
      if self[i].Shares <= OpenShares then begin // whole trade
        Trade := self.Extract(self[i]);
        Trade.Broker := BrokerID; // new account.
        Trade.TradeNum := NewTradeNum;
        OpenShares := OpenShares - Trade.Shares;
      end // ----------------
      else begin // Trade is partially open; need to split shares
        Trade := TTLTrade.Create(self[i]);
        Trade.TradeNum := NewTradeNum;
        Trade.ID := 0;
        Trade.Broker := BrokerID;
        nRatio := OpenShares / Trade.Shares;
        Trade.Amount := Trade.Amount * nRatio;
        if Trade.Commission > NEARZERO then
          Trade.Commission := Trade.Commission * (OpenShares / Trade.Shares);
        Trade.Shares := OpenShares;
        Parent.Parent.AddTrade(Trade);
        self[i].Amount := self[i].Amount - Trade.Amount;
        if CompareValue(self[i].Commission, 0, NEARZERO) > 0 then
          self[i].Commission := self[i].Commission - Trade.Commission;
        self[i].Shares := self[i].Shares - Trade.Shares;
        OpenShares := 0;
      end; // if self[i].Shares
      // --------------------
    end; // if W or O block
    // --------------------------------
  end; // for i loop #1
  // --------------------------------------------
end; // TTLTradeNum.TransferOpenPosition


function TTLTradeNum.GetComplete : boolean;
var
  Trade : TTLTrade;
begin
  result := false;
  // Make sure there is at least one Open Record. If there is then
  // if shares are zero we are done with this trade.
  // otherwise we may just have wash sale records up to this point so it is not complete.
  for Trade in self do begin
    if Trade.oc = 'O' then begin
      result := (Shares = 0);
      Exit;
    end;
  end;
end;


function TTLTradeNum.GetDate : TDate;
begin
  result := 0;
  if Count > 0 then
    result := Items[0].Date;
end;


function TTLTradeNum.GetLastDate : TDate;
begin
  result := 0;
  if Count > 0 then
    result := Last.Date;
end;


function TTLTradeNum.GetLS : Char;
begin
  result := ' ';
  if Count > 0 then
    result := Items[0].ls;
end;


function TTLTradeNum.GetMatched : string;
begin
  result := '';
  if Count > 0 then
    result := Items[0].Matched;
end;


function TTLTradeNum.GetMultiplier : double;
var
  s : string;
begin
  result := 1;
  s := TypeMult;
  System.delete(s, 1, pos('-', s));
  if IsFloatEx(s, Settings.UserFmt) then
    result := StrToFloat(s, Settings.UserFmt)
end;

function TTLTradeNum.GetOpeningMTMRecord : TTLTrade;
var
  Trade : TTLTrade;
begin
  result := nil;
  for Trade in self do begin
    if (Trade.oc = 'O') //
    and (Trade.Date = StrToDate('01/01/' + IntToStr(Parent.Parent.TaxYear))) //
    and (Trade.Time = '00:00:00') then begin
      Exit(Trade);
    end;
  end;
end;


function TTLTradeNum.GetOptionTicker : string;
begin
  result := '';
  if Count > 0 then
    result := Items[0].OptionTicker;
end;


function TTLTradeNum.GetHighID : integer;
var
  Trade : TTLTrade;
begin
  result := 0;
  for Trade in self do
    if Trade.ID > result then
      result := Trade.ID;
end;

function TTLTradeNum.GetIsOpenOptionInTaxYear : boolean;
var
  ExpireDate : TDateTime;
  s : string;
begin
  result := false;
  // if (Shares > 0)
  if (compareValue(Shares, 0, NEARZERO) > 0) //
  and (IsOption(TypeMult, Ticker)) then begin
    s := Ticker;
    ParseFirst(s, ' ');
    s := ParseFirst(s, ' ');
    ExpireDate := ConvertExpDate(s);
    if ExpireDate <= xStrToDate('12/31/' + IntToStr(FParent.FParent.TaxYear)) then
      Exit(true);
  end;

end;

function TTLTradeNum.GetSection481OK : boolean;
var
  Trade : TTLTrade;
  LastYrOpenShares : double;
  YearEndDate : TDate;
begin
  YearEndDate := xStrToDate('12/31/' + IntToStr(Parent.Parent.LastTaxYear));
  result := SharesAsOf[YearEndDate] = 0;
end;


function TTLTradeNum.GetShares : double;
var
  Trade : TTLTrade;
begin
  result := 0;
  // Add Open Records, Subtract Close records including MTM Recs.
  // Ignore Wash Sale Deferrals (W)
  for Trade in self do begin
    if Trade.oc = 'O' then
      result := result + Trade.Shares
    else if (Trade.oc = 'C') or (Trade.oc = 'M') then
      result := result - Trade.Shares;
  end;
  result := RndTo5(result);
end;

function TTLTradeNum.GetWShares : double;
var
  Trade : TTLTrade;
begin
  result := 0;
  for Trade in self do begin
    if Trade.oc = 'W' then
      result := result + Trade.Shares;
  end;
  result := RndTo5(result);
end;

function TTLTradeNum.GetSharesAsOf(AsOfDate : TDate): double;
var
  Trade : TTLTrade;
begin
  if AsOfDate > self.LastDate then
    Exit(GetShares);
  result := 0;
  for Trade in self do begin
    if Trade.Date <= AsOfDate then begin
      if Trade.oc = 'O' then
        result := result + Trade.Shares
      else if CharInSet(Trade.oc, ['C', 'M']) then
        result := result - Trade.Shares;
    end;
  end;
  result := RndTo5(result);
end;


function TTLTradeNum.GetTicker : string;
begin
  result := '';
  if Count > 0 then
    result := Items[0].Ticker;
end;


function TTLTradeNum.GetTradeNum : integer;
begin
  result := -1;
  if Count > 0 then
    Exit(Items[0].TradeNum)
end;


function TTLTradeNum.GetTradeType : string;
begin
  result := '';
  if Count > 0 then
    Exit(Items[0].TradeType);
end;


function TTLTradeNum.GetTypeMult : string;
begin
  result := '';
  if Count > 0 then
    result := Items[0].TypeMult;
end;


{ TTLOpenTradeList }

function TTLTradeNumList.Add(Value : TTLTradeNum): integer;
begin
  Value.FParent := self;
  result := inherited Add(Value);
end;


// ----------------------------------------------
// Add a Trade to the TradeNumList
// ==============================================
procedure TTLTradeNumList.AddTrade(Trade : TTLTrade; ForceMatch : boolean = false;
FixTradesOOOrder : boolean = false);
var
  TradeNum : TTLTradeNum;
  NewTradeNum : boolean;
  i, iERL : integer;
  multA : double;
  // ---------------------------------------
  // Determine if a W Record matched a trade num,
  // The W Record shares must be <= open trade shares
  // in addition to the usual matching criteria
  // so we must loop through the Trade Num's trades
  // in order to determine this}
  // ---------------------------------------
  function isWRecordMatched(t : TTLTrade; TN : TTLTradeNum) : boolean;
  var
    OpenTrade : TTLTrade;
  begin
    if (t.oc <> 'W') then
      Exit(false);
    result := false;
    // DE 2016-03-10 Updated so no W Rec matches an open Rec unless the dates match
    if (TN.BrokerID = t.Broker) and (TN.Ticker = t.Ticker) //
      and ((pos('Ex', TN.Matched)= 1) or (TN.Matched = t.Matched)) //
      and (TN.ls = t.ls) then begin
      // first find exact match
      for OpenTrade in TN do begin
        if (OpenTrade.oc = 'O') and (t.Shares = OpenTrade.Shares) //
          and (t.Date <= OpenTrade.Date) // should this be = date?
        then begin
          t.TradeNum := TN.TradeNum;
          OpenTrade.WSMatchedShares := OpenTrade.WSMatchedShares + t.Shares;
          TN.Add(t, false);
          Exit(true);
        end;
      end;
      // then see if Open has more shares open than W Rec
      for OpenTrade in TN do begin
        if (OpenTrade.oc = 'O') //
          and (t.Shares <= OpenTrade.Shares - OpenTrade.WSMatchedShares) //
          and (t.Date <= OpenTrade.Date) // should this be = date?
        then begin
          t.TradeNum := TN.TradeNum;
          OpenTrade.WSMatchedShares := OpenTrade.WSMatchedShares + t.Shares;
          TN.Add(t, false);
          Exit(true);
        end;
      end;
    end;
  end;
  // ---------------------------------------
  // Matching Logic is based on the following concepts:
  // 1) Assign Short Buy: If the tickers match but S/L does not AND
  // there is an Open position AND an Open Position exists before this
  // record with shares greater than or equal to current trade
  // then Convert Open to a Close and toggle the L/S Field and Match them.
  // This Only happens if
  // a) ImportFilter AssignShortBuy = true (not user editable)
  // b) Force Match
  // c) AutoAssignShorts = true (User Editable only for Excel Import)
  //
  // 2) Assign Short Sell: If the tickers match but the S/L does not AND
  // this is a Closed Position AND an Open Position exists before this
  // record, or a Close trade is the first trade for a Ticker
  // then Change to Open and Toggle L/S field
  // This Only Happens if
  // a) AutoAssignShort = true (User Editable only for Excel Import)
  // b) Force Match
  //
  // 3) SLConvert: If A Close Record Matches an open TradeNum
  // But the shares are greater than the open shares for the TradeNum,
  // then Take the excess shares and Create a new Open position out of them,
  // Toggle S/L,
  // modify the existing trade Shares to Close the previous open trade.
  // Example, MSFT O/L 500, Followed by MSFT C/L 1000,
  // breaks the MSFT C/L into two pieces of 500 each,
  // MSFT C/L 500 which matches the O/L 500 and closes the tradeNum,
  // and MSFT O/S 500 which creates a new TradeNum.
  // Only Happens if
  // a) SLConvert (User editable in account form) = true
  // b) Force Match.
  //
  // 4) Force Match: Do both AutoAssignShorts
  // (Assign ShortBuy, and Assign ShortSell) and SLConvert.
  //
  // 5) Toggle Short Long: For Selected Records Toggle Short/Long positions,
  // (toggle O/C and L/S fields), then rematch
  //
  // 6) FixTradesOOOrder: SortByOpenClose, and attempt a rematch.
  // ---------------------------------------
  function TradeMatches : boolean;
  var
    NewTrade : TTLTrade;
    // --------------------------------
    // When we are not force matching by User Selection
    // but a broker override is set to true then we want
    // to forcematch anyway for that type.
    function IsForceMatch : boolean;
    begin
      result := false;
      if ForceMatch then
        Exit(true);
      if (FParent.FileHeader[Trade.Broker].ImportFilter.ForceMatchStocks) and
        IsStockType(Trade.TypeMult) then
        Exit(true);
      if (FParent.FileHeader[Trade.Broker].ImportFilter.ForceMatchOptions) and
        (StartsText('OPT', Trade.TypeMult)) then
        Exit(true);
      if (FParent.FileHeader[Trade.Broker].ImportFilter.ForceMatchCurrencies) and
        (StartsText('CUR', Trade.TypeMult)) then
        Exit(true);
      if (FParent.FileHeader[Trade.Broker].ImportFilter.ForceMatchFutures) and
        (StartsText('FUT', Trade.TypeMult)) then
        Exit(true);
    end;
  // --------------
  begin
    try
      iERL := 6484;
      result := false;
      // Trades that are not part of the same broker cannot be matched.
      if Trade.Broker <> TradeNum.BrokerID then
        Exit(false);
      // --------------------------------
      // Matched Tax Lots Logic        //
      // --------------------------------
      // If record was matched using Matched Tax Lots,
      // then we are matched!
      iERL := 6492;
      if isInt(TradeNum.Matched) //
      and isInt(Trade.Matched) //
      and (TradeNum.Matched = Trade.Matched) //
      and (not TradeNum.HasNegShares) then begin
        Trade.TradeNum := TradeNum.TradeNum;
        TradeNum.Add(Trade, false);
        Exit(true);
      end
      else if isInt(TradeNum.Matched) //
      or isInt(Trade.Matched) then
        Exit(false);
      // if one or the other has a number and the above condition
      // failed then it means they are matched using matched tax lots just
      // not to each other, so return false
      //
      // If the tickers don't match then no need to keep looking as we are done
      iERL := 6505;
      if (TradeNum.Ticker <> Trade.Ticker) // 2016-03-10 DE - added Type match
        or (leftstr(TradeNum.TypeMult, 3) <> leftstr(Trade.TypeMult, 3)) then
        Exit(false);
      // ------------
      multA := GetMult(TradeNum.TypeMult);
      // if the type/mult doesn't match then continue 2014-02-03
      if (pos('OPT', TradeNum.TypeMult)= 1) // added 2014-02-05
        and (TradeNum.TypeMult <> Trade.TypeMult) //
        and ((multA = 10) or (multA = 100)) // added 2015-02-18 for non-USD options
      then
        Exit(false);
      // --------------------
      // If there are open shares on the TradeNum and both the ticker
      // and Long Short Field match, then we are close to a possible match;
      // Check the Shares and also the SLConvert
      iERL := 6520;
      if (TradeNum.Ticker = Trade.Ticker) //
        and (TradeNum.ls = Trade.ls) then begin
        // If this is a wash Sale record then Check for a match.
        if Trade.oc = 'W' then begin
          if isWRecordMatched(Trade, TradeNum) then
            Exit;
        end;
        // ------------------
        // If this an Open record and We are not in a negative share condition, or a
        // close record with enough shares available to satisfy then this is a match
        // NOTE: The TradeNum.WashSaleOnly flag specifies that more than just Wash Sales
        // have already been match, If only Wash Sales exist in this tradeNum then the
        // shares will be zero, but we don't want to stop under this condition.
        // ------------------
        if ( //
        (Trade.oc = 'O') //
        and ( //
          (TradeNum.WashSalesOnly) //
          or (compareValue(Trade.Shares, 0, NEARZERO) > 0) //
          ) //
        ) then begin
          Trade.TradeNum := TradeNum.TradeNum;
          TradeNum.Add(Trade, false);
          Exit(true);
        end;
        // --------
        if (CharInSet(Trade.oc, ['C', 'M'])) //
        and (compareValue(TradeNum.Shares, Trade.Shares, NEARZERO) >= 0) //
        then begin
          Trade.TradeNum := TradeNum.TradeNum;
          TradeNum.Add(Trade, false);
          Exit(true);
        end
      end; // if TradeNum.Ticker
      // --------------------------------
      // Assign Short Buy Logic For    //
      // --------------------------------
      // Tickers are equal but Long Short is not so
      // If AssignShortBuy is true and importing and this is an O/L then
      // if the Trade does not exceed the needed number of shares then
      // let's assign the short buy
      iERL := 6552;
      // --------
      if not FixTradesOOOrder then begin //
        if (TradeNum.Ticker = Trade.Ticker) then begin //
          if (Trade.oc = 'O') and (Trade.ls = 'L') then begin //
//            if not OFX then begin //
              if (Trade.Shares <= TradeNum.Shares) then begin
                if (FParent.FileHeader[Trade.Broker].ImportFilter.AssignShortBuy //
                  or (FParent.FileHeader[Trade.Broker].ImportFilter.AutoAssignShortsOptions //
                  and ((pos('OPT-', Trade.TypeMult)= 1) //
                    or (pos('FUT-', Trade.TypeMult)= 1) //
                  ) //
                  and Importing //
                  ) //
                  // Turn on for futures during import, no matter what a brokers setting is
                  or (FImporting and (pos('FUT-', Trade.TypeMult) = 1)) //
                ) then begin //
                  // Matches, so set the TradeNumber
                  Trade.TradeNum := TradeNum.TradeNum;
                  // Change the Open to Close
                  Trade.FOC := 'C';
                  Trade.FLS := 'S';
                  TradeNum.Add(Trade, false);
                  Exit(true);
                end;
              end; // if Trade.Shares <= TradeNum.Shares
//            end; // if not OFX
          end; // if O/L
        end; // if tickers match
      end; // if not FixOOO
      // -------------------------------------
      // Assign Short Buy Logic For         //
      // ForceMatch and AutoAssignShorts    //
      // -------------------------------------
      iERL := 6576;
      if (TradeNum.Ticker = Trade.Ticker) //
      and ( IsForceMatch //
       or ( FParent.FileHeader[Trade.Broker].AutoAssignShorts //
         and not FixTradesOOOrder ) //
       or ( (FParent.FileHeader[Trade.Broker].ImportFilter.AutoAssignShortsOptions) //
        and ( (pos('OPT-', Trade.TypeMult)= 1) //
          or (pos('FUT-', Trade.TypeMult)= 1) ) //
        and Importing //
        and not FixTradesOOOrder ) //
       // Turn on for futures during import, no matter what broker setting is
       or ( FImporting and (pos('FUT-', Trade.TypeMult) = 1) ) //
      ) //
      and (Trade.oc = 'O') and (TradeNum.ls <> Trade.ls) //
      and (Trade.Shares <= TradeNum.Shares) then begin
        // Tickers are equal but Long Short is not, so
        // If AutoAssignShorts = true
        // or we are Force matching
        // and we have an Open position,
        // then if the Trade is also an Open position
        // and does not exceed the needed number of shares
        // then let's assign the short buy
        Trade.TradeNum := TradeNum.TradeNum;
        // Change the Open to Close
        Trade.FOC := 'C';
        // Toggle the LS
        if Trade.ls = 'L' then
          Trade.FLS := 'S'
        else
          Trade.FLS := 'L';
        TradeNum.Add(Trade, false);
        Exit(true);
      end
      // --------------------------------
      // Assign Short Sell Logic       //
      // --------------------------------
      else if (TradeNum.Ticker = Trade.Ticker) //
      and ( IsForceMatch //
      or ( FParent.FileHeader[Trade.Broker].AutoAssignShorts //
        and not FixTradesOOOrder ) //
      or ( //
       ( FParent.FileHeader[Trade.Broker].ImportFilter.AutoAssignShortsOptions ) //
       and ( ( pos('OPT-', Trade.TypeMult) = 1 ) //
          or ( pos('FUT-', Trade.TypeMult) = 1 ) //
        ) //
        and Importing //
        and not FixTradesOOOrder //
        ) //
        // Turn on for futures during import, no matter what a brokers setting is
        or ( FImporting and (pos('FUT-', Trade.TypeMult) = 1) ) //
      ) //
      and (Trade.oc = 'C') //
      and (TradeNum.ls <> Trade.ls) //
      and (compareValue(TradeNum.Shares, 0, NEARZERO) > 0) then begin
        // Tickers are equal but Long Short is not so
        // If we are Force matching or AutoAssignShorts = true
        // and we have a Close position,
        // then if the Trade is also a Close Position
        // and does not exceed the needed number of shares
        // then let's assign the short Sell
        Trade.TradeNum := TradeNum.TradeNum;
        // Change the Open to Close
        Trade.FOC := 'O';
        // Toggle the LS
        if Trade.ls = 'L' then
          Trade.FLS := 'S'
        else
          Trade.FLS := 'L';
        TradeNum.Add(Trade, false);
        Exit(true); // Result := true;
        // Still need to check SLConvert Logic so don't exit
      end;
      // ------------------------------
      // SLConvert Logic             //
      // ------------------------------
      // If this is a close record but the shares are greater then
      // that available and we are Converting Short Longs
      // then we need to break this trade up into two pieces.
      //
      // SPECIAL NOTE: We use the Private variables of the trade class in this routine
      // (The ones starting with F)
      // so that we don't trigger the Calc Amount Method so many times.
      // CalcAmount is called later when a trade is added to the file.
      iERL := 6645;
      if (TradeNum.Ticker = Trade.Ticker) //
      and (compareValue(TradeNum.Shares, 0, NEARZERO) > 0) //
      and (compareValue(Trade.Shares, TradeNum.Shares, NEARZERO) > 0) //
      and ( //
        ((TradeNum.ls = Trade.ls) and (Trade.oc = 'C')) //
        or ((TradeNum.ls <> Trade.ls) and (Trade.oc = 'O')) //
      ) //
      and ( //
        FParent.FileHeader[Trade.Broker].SLConvert //
        or IsForceMatch //
        // Turn on for futures during import, no matter what a brokers setting is
        or (FImporting and (pos('FUT-', Trade.TypeMult) = 1)) //
      ) then begin
        NewTrade := TTLTrade.Create(Trade);
        // Reset the trade num so it will be matched
        NewTrade.TradeNum := 0;
        // Reset the ID so that it is given a new Id
        NewTrade.ID := 0;
        // Set the shares to the shares above what is needed to satisfy
        // the TradeNumbers total open shares.
        NewTrade.FShares := Trade.Shares - TradeNum.Shares;
        // Split the commission and the price between the 2 trades
        // based on the percentage of shares each will get.
        // 2015-06-30 fixed comm split bug - changed TradeNum.Shares to NewTrade.FShares
        NewTrade.FCommission := NewTrade.Commission * (NewTrade.FShares / Trade.Shares);
        Trade.FCommission := Trade.Commission - NewTrade.Commission;
        // ------------------------------
        // 2017-08-22 MB Fix for incorrect commission after SLConv split
        NewTrade.FPrice := NewTrade.Price;
        NewTrade.FAmount := NewTrade.Amount * (NewTrade.FShares / Trade.Shares); // quick & dirty
        Trade.FAmount := Trade.FAmount - NewTrade.FAmount;
        // end
        // ------------------------------
        // Reverse the OC and LS Values for the New Trade
        // Set the current Trades Shares to the remainder
        Trade.FShares := TradeNum.Shares;
        // Make sure the TradeNumber of the current trade is matched to
        // this trade number group.
        Trade.TradeNum := TradeNum.TradeNum;
        // If we started with an open trade, then flip the current trade
        // to a close; otherwise flip the new Trade to an Open
        if Trade.oc = 'O' then begin
          Trade.FOC := 'C';
          if Trade.ls = 'L' then
            Trade.FLS := 'S'
          else
            Trade.FLS := 'L';
        end
        else begin
          NewTrade.FOC := 'O';
          if NewTrade.ls = 'L' then
            NewTrade.FLS := 'S'
          else
            NewTrade.FLS := 'L';
        end;
        TradeNum.Add(Trade, true);
        // Add new Trade to Parent List.
        // This will not affect the list we are processing, since we don't
        // process the parent list directly but only a copy of the list.
        FParent.AddTrade(NewTrade);
        // Now the new trade needs be processed next, so recursively call
        // the addTrade method, so that it get processed in the right order.
        AddTrade(NewTrade, ForceMatch, FixTradesOOOrder);
        Exit(true);
      end;
    except
      on E : Exception do begin
        if superUser then
          mDlg('Error in TradeMatches near line ' + IntToStr(iERL) + CR //
            + E.Message, mtError, [mbOK], 0);
      end;
    end;
  end;
// --------------------------------------------
begin
  try
    iERL := 6814;
    if FixTradesOOOrder and ForceMatch then
      raise ETLFileException.Create
        ('Fix Trades Out of Order and Force Match are mutually exclusive ' +
        'and cannot both be specified when matching.');
    // Reset WS Matched Shares, so that if called again it will match wash sales properly
    Trade.WSMatchedShares := 0;
    // W Records are now sorted to the bottom of the Trade Number List
    // for a ticker so they are matched last.
    // --------------------------------------------
    // NOTE: During Import we want to match to Open Trades,
    // but in a ReMatch we want to match O Recs in date order
    if (Trade.oc = 'W') then begin
    // next, see if it matches a closed TradeNum
      iERL := 6828;
      for i := 0 to FClosedTradeNums.Count - 1 do begin
        if isWRecordMatched(Trade, FClosedTradeNums[i]) then
          Exit;
      end;
    end;
    // ---- the first loop was added on 2016-07-13 (Dave's code) ----
    // NOTE: Moved to AFTER the closed trades on 2016-07-29 MB
    // first, see if it matches an open TradeNum
    iERL := 6837;
    for i := 0 to FParent.TradeNums.Count - 1 do begin
      if isWRecordMatched(Trade, FParent.TradeNums[i]) then
        Exit;
    end;
  except
    on E : Exception do begin
      if superUser then
        mDlg('Error in AddTrade(' + Trade.Ticker + ')' + CR //
          + 'in/after line ' + IntToStr(iERL) + CR //
          + E.Message, mtError, [mbOK], 0);
    end;
  end;
  // ---- end 2016-07-13 code change ------------------------------
  try
    // --------------------------------------------
    // Loop through the existing TradeNumbers object and see if the trade matches
    // If the Trade Matches then it will be added to the TradeNum list
    // ***  THIS CLOSES THE LAST TRADE OPENED FIRST,  ***
    // ***  RATHER THAN CLOSING THE SHORT TRADE FIRST ***
    iERL := 6856;
    for i := (Count - 1) downto 0 do begin
      if (i + 1)> Count then
        sm('bug found');
      TradeNum := Items[i];
      // If existing TradeNum record has zero shares, the trade cannot match
      // since it is closed. This should never happen, since once a trade is
      // complete below it's removed from active trade list, but just in case.
      if TradeNum.Complete then
        continue;
      iERL := 6866;
      if TradeMatches then begin
        // Zero record Extract it since we don't want to slow down the process
        // by having unopen trade numbers in the list. We use extract instead
        // of remove because it does not call free on the object being
        // extracted like remove does. Put this item in a closed TradeNums list
        // so we can get to it if we need it. This may be unnecessary as each
        // TradeNums list is attached to each Trade.
        iERL := 6874;
        if TradeNum.Complete then
          FClosedTradeNums.Add(Extract(TradeNum));
        Exit;
      end;
    end;
  except
    on E : Exception do begin
      if superUser then
        mDlg('Error in AddTrade(' + Trade.Ticker + ')' + CR //
          + 'in/after line ' + IntToStr(iERL) + CR //
          + E.Message, mtError, [mbOK], 0);
    end;
  end;
  // ----------------
  try
    // If we got here then the trade number is not in the list and
    // so we need to create a new TradeNumber record.
    // But first lets see if we are Auto Assigning Shorts or force matcing
    // if we are then this is the first trade for this new trade number and if
    // it is a close record, then Assign Short Sell dictates that it be converted
    // to an Open. CloseLong to OpenShort or CloseShort to OpenLong.
    // The other half of AutoAssignShorts is handled in the
    // TradeMatches method above, since we never touch this code once the first
    // record exists for a trade number.
    iERL := 6899;
    if ((ForceMatch) or (FParent.FileHeader[Trade.Broker].AutoAssignShorts and not FixTradesOOOrder)
      or ((FParent.FileHeader[Trade.Broker].ImportFilter.AutoAssignShortsOptions) and
      ((pos('OPT-', Trade.TypeMult)= 1) or (pos('FUT-', Trade.TypeMult)= 1)) and Importing and
      not FixTradesOOOrder)
    // Turn on for futures during import, no matter what a brokers setting is
      or (FImporting and (pos('FUT-', Trade.TypeMult) = 1) and (pos(' PUT', Trade.Ticker) = 0) and
      (pos(' CALL', Trade.Ticker) = 0))) and (Trade.oc = 'C') then begin
      iERL := 6908;
      Trade.FOC := 'O';
      if (Trade.ls = 'L') then
        Trade.FLS := 'S'
      else
        Trade.FLS := 'L';
    end;
  except
    on E : Exception do begin
      if superUser then
        mDlg('Error in AddTrade(' + Trade.Ticker + ')' + CR //
          + 'in/after line ' + IntToStr(iERL) + CR //
          + E.Message, mtError, [mbOK], 0);
    end;
  end;
  // ----------------
  try
    // Assign the next tradeNumber to this trade
    iERL := 6926;
    Trade.TradeNum := NextTradeNum;
    // Create a new Trade Number list item
    iERL := 6929;
    TradeNum := TTLTradeNum.Create;
    // Add the Open Trade Record to the Open Trade List
    iERL := 6932;
    Add(TradeNum);
    // Add the TTLTrade Record to the new Open Trade Record
    iERL := 6935;
    TradeNum.Add(Trade, false);
  except
    on E : Exception do begin
      if superUser then
        mDlg('Error in AddTrade(' + Trade.Ticker + ')' + CR //
          + 'in/after line ' + IntToStr(iERL) + CR //
          + E.Message, mtError, [mbOK], 0);
    end;
  end;
end; // AddTrade


function TTLTradeNumList.GetNextTradeNum : integer;
begin
  result := FNextTradeNum;
  inc(FNextTradeNum);
end;


function TTLTradeNumList.GetOpenOptionsExist : boolean;
var
  i : integer;
begin
  result := false;
  for i := 0 to self.Count - 1 do
    if (self[i].BrokerID = Parent.CurrentBrokerID) and self[i].IsOpenOptionInTaxYear then
      Exit(true);
end;


function TTLTradeNumList.GetOpenSharesTotal : double;
var
  TradeNum : TTLTradeNum;
begin
  result := 0;
  for TradeNum in self do
    result := result + TradeNum.Shares;
end;


procedure TTLTradeNumList.Initialize;
var
  Trade : TTLTrade;
  CurrentTradeNumber : integer;
  TradeNum : TTLTradeNum;
begin
  CurrentTradeNumber := 0;
  TradeNum := nil;
  for Trade in FParent.TradeList do begin
    if Trade.TradeNum <> CurrentTradeNumber then begin
      CurrentTradeNumber := Trade.TradeNum;
      if (TradeNum <> nil) then
        // if (TradeNum.Shares > 0) then
        if (compareValue(TradeNum.Shares, 0, NEARZERO) > 0) then
          Add(TradeNum)
        else
          TradeNum.Free;
      TradeNum := TTLTradeNum.Create;
    end;
    TradeNum.Add(Trade);
  end;
  if TradeNum <> nil then
    // if (TradeNum.Shares > 0) then
    if (compareValue(TradeNum.Shares, 0, NEARZERO) > 0) then
      Add(TradeNum)
    else
      TradeNum.Free;
end;


procedure TTLTradeNumList.SetNextTradeNum(const Value : integer);
begin
  FNextTradeNum := Value;
end;


// ------------------------------------
// Two versions of Match function:
// ------------------------------------
function TTLTradeNumList.Match(Tickers : TStringList; ForceMatch : boolean = false;
FixTradesOOOrder : boolean = false) : TTradeList;
var
  Trade : TTLTrade;
  TradeList : TTradeList;
begin
  if Parent.CurrentBrokerID = 0 then
    raise ETLFileException.Create('Matching cannot be run when there is no Current Broker');
  // make a list of all trades with the selected ticker(s).
  TradeList := TTradeList.Create;
  for Trade in FParent.TradeList do begin
    if (Trade.Broker <> Parent.CurrentBrokerID) then
      continue; // speed
    if (Tickers.IndexOf(Trade.Ticker) > -1) then begin
      TradeList.Add(Trade);
    end; // if
  end; // for Trade
  result := DoMatch(TradeList, ForceMatch, FixTradesOOOrder);
end;

// ------------------------------------
function TTLTradeNumList.Match(Trades : TTradeList; ForceMatch, FixTradesOOOrder : boolean)
  : TTradeList;
var
  List : TStringList;
  Trade : TTLTrade;
  CurrentTicker : string;
begin
  if Parent.CurrentBrokerID = 0 then
    raise ETLFileException.Create('Matching cannot be run when there is no Current Broker');
  List := TStringList.Create;
  CurrentTicker := '';
  try
    List.Duplicates := dupAccept;
    for Trade in Trades do
      if (CurrentTicker <> Trade.Ticker) //
      and (Parent.CurrentBrokerID = Trade.Broker) //
      then begin
        List.Add(Trade.Ticker);
        CurrentTicker := Trade.Ticker;
      end;
    result := Match(List, ForceMatch, FixTradesOOOrder);
  finally
    List.Free;
  end;
end;


function TTLTradeNumList.MatchAll(ForceMatch : boolean = false; FixTradesOOOrder : boolean = false)
  : TTradeList;
var
  Trades : TTradeList;
  Trade : TTLTrade;
begin
  if Parent.CurrentBrokerID = 0 then
    raise ETLFileException.Create('Matching cannot be run when there is no Current Broker');
  FParent.DoStatus('Matching Trades');
  Screen.Cursor := crHourGlass;
  { If this is a single broker file and since we are doing all records we can clear the TradeNumList
    so that the next match method can skip the remove all trade number records
    from tickers list code, this is a performance enhancement item, when they have only one account }
  Trades := TTradeList.Create;
  try
    if not Parent.MultiBrokerFile then begin
      Clear;
      FClosedTradeNums.Clear;
      FNextTradeNum := 1;
      Trades.AddRange(Parent.TradeList);
    end
    else begin
      for Trade in Parent.TradeList do
        if Trade.Broker = Parent.CurrentBrokerID then
          Trades.Add(Trade);
    end;
    result := DoMatch(Trades, ForceMatch, FixTradesOOOrder);
  finally
    Trades.Free;
  end;
end;


// ----------------------------------------------
// Throughout this process we might be adding trades to the parent's list
// (SLConvert). Therefore do not allow the parents list to be used with this
// method; always require a copy of the TLFile.TradeList to be used so that
// any trades added during this process will not be processed twice.
// Sample Code to make a copy of the list is
// MyTradeList := TTradeList.Create;
// MyTradeList.AddRange(TradeLogFile.TradeList);
// ----------------------------------------------
function TTLTradeNumList.DoMatch(Trades : TTradeList; ForceMatch : boolean = false;
FixTradesOOOrder : boolean = false): TTradeList;
var
  Trade : TTLTrade;
  Ticker : string;
  i, ERL : integer;
begin
  ERL := 7104;
  if Trades = Parent.TradeList then
    raise ETLFileException.Create
      ('Matching must not be done on the TLFile internal list - Please make a copy of the list and pass it to this method');
  try
    if FixTradesOOOrder then
      Trades.SortByOpenClose
    else
      Trades.SortByTickerForMatching;
  except
    on E : Exception do begin
      mDlg('Error in sort before DoMatch' + CR //
        + E.Message, mtError, [mbOK], 0);
    end;
  end; // 2022-07-27 MB - try... except
  ERL := 7118;
  // If we are matching the entire file then TradeNumList will have been
  // cleared by the MatchAll method above so in this case there is no need
  // to remove trade number records for tickers
  i := 0; // initialize local variable
  if (Count > 0) or (FClosedTradeNums.Count > 0) then begin
    // First remove all trade number records for the tickers listed.
    Ticker := '';
    for Trade in Trades do begin
      if Trade.Ticker <> Ticker then begin
        Ticker := Trade.Ticker;
        for i := Count - 1 downto 0 do begin
          // Only working with Current Broker ID so don't remove others
          if Items[i].BrokerID <> Parent.CurrentBrokerID then
            continue;
          if Items[i].Ticker = Ticker then begin
            Remove(Items[i]);
            continue;
          end;
        end;
        for i := FClosedTradeNums.Count - 1 downto 0 do begin
          // Only working with Current Broker ID so don't remove others
          if FClosedTradeNums[i].BrokerID <> Parent.CurrentBrokerID then
            continue;
          if FClosedTradeNums[i].Ticker = Ticker then
            FClosedTradeNums.Remove(FClosedTradeNums[i]);
        end;
      end;
    end;
  end;
  ERL := 7147;
  // Now add the trades using the AddTrade method so that they are matched
  try // 2021-12-03 MB
    for Trade in Trades do begin
      // Verify that the right Type Multiplier is setup for this record
      ERL := 7152;
      Trade.TypeMult := Parent.ChangeMutEtfRec(Trade.Ticker, Trade.TypeMult);
      ERL := 7154;
      AddTrade(Trade, ForceMatch, FixTradesOOOrder);
      ERL := 7156;
      Trade.CalcAmount;
    end;
  except // 2021-12-03 MB - exception block
    on E : Exception do begin
      mDlg('Error in trade ' + Trade.Ticker + CR //
        + 'in line ' + IntToStr(ERL) + CR //
        + E.Message, mtError, [mbOK], 0);
    end;
  end; // 2021-12-03 MB - try... except
  result := Trades;
end;


constructor TTLTradeNumList.Create(Parent : TTLFile; OwnsObjects : boolean);
begin
  inherited Create(TTLTradeNumComparer.Construct(
    function(const Item1, Item2 : TTLTradeNum) : integer
    begin
      result := 0;
      if (Item1 <> nil) or (Item2 <> nil) then begin
        if Item1.TradeNum < Item2.TradeNum then
          result := -1
        else if Item1.TradeNum > Item2.TradeNum then
          result := 1;
        if result = 0 then begin
          if (Item1.ls = 'L') and (Item2.ls = 'S') then
            result := -1
          else if (Item1.ls = 'S') and (Item2.ls = 'L') then
            result := 1;
        end;
      end;
    end), OwnsObjects);
  FImporting := false;
  FParent := Parent;
  FClosedTradeNums := TTLTradeNumList.Create;
  FNextTradeNum := 1;
end;


constructor TTLTradeNumList.Create(Parent : TTLFile);
begin
  Create(Parent, true);
end;


procedure TTLTradeNumList.DeleteTrade(Trade : TTLTrade);
var
  TradeNum : TTLTradeNum;
begin
  for TradeNum in self do begin
    if (TradeNum.Contains(Trade)) then begin
      TradeNum.Remove(Trade);
      // If, after removing the Open Trade, we no longer have any
      // trades left, remove the List from Open Trades
      if TradeNum.Count = 0 then begin
        Remove(TradeNum);
        TradeNum.Free;
      end;
      Exit;
    end;
  end;
  // If We Got here then the trade does not exist in Open Trades List.
end;


destructor TTLTradeNumList.Destroy;
begin
  inherited;
end;


function TTLTradeNumList.FindTradeNum(TradeNum : integer): TTLTradeNum;
var
  TradeNumber : TTLTradeNum;
  Idx : integer;
begin
  result := nil;
  for TradeNumber in self do begin
    if TradeNumber.TradeNum = TradeNum then
      Exit(TradeNumber);
  end;
  for TradeNumber in ClosedTradeNums do begin
    if TradeNumber.TradeNum = TradeNum then
      Exit(TradeNumber);
  end;
end;


function TTLTradeNumList.FindTradeNum(Trade : TTLTrade): TTLTradeNum;
begin
  result := FindTradeNum(Trade.TradeNum);
end;

{ TTLFileHeaders }

function TTLFileHeaders.GetNextBrokerID : integer;
var
  Header : TTLFileHeader;
begin
  if Count = 0 then
    Exit(1);
  result := 1;
  for Header in self do
    if Header.BrokerID > result then
      result := Header.BrokerID;
  Exit(result + 1);
end;


initialization

// rj   Logger := TCodeSite//rj Logger.Create(nil);
// rj Logger.Category := CODE_SITE_CATEGORY;
// rj   TLLoggers.RegisterLogger(CODE_SITE_CATEGORY, Logger);
// rj   DetailLogger := TCodeSite//rj Logger.Create(nil);
// rj   DetailLogger.Category := CODE_SITE_DETAIL_CATEGORY;
// rj   TLLoggers.RegisterLogger(CODE_SITE_DETAIL_CATEGORY, DetailLogger);

end.
