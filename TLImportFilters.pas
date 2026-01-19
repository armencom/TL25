unit TLImportFilters;

interface

uses Classes, SysUtils, Generics.Collections, Generics.Defaults, Types;

type
  EImportFilterException = class(Exception);
  //  Makes Import Filter an interfaced object so that in the future if we need
  //  to replace it with another object type we can easily without modifying the code that
  //  uses it.
  //
  //  This may go beyond the scope of what we are doing and unnecessary at this time, but could
  //  be useful later.
  //
  // ==== HOW ImportMethod is used in the NEW VERSION =====
  // Use 1's, 10's, 100's, 1000's place (etc.)
  //
  // 1000	method
  //    X	from Plaid		=   1
  //   X	brokerconnect	=  10
  //  X	  select a file	= 100
  // ?	  future, tbd  = 1000
  //
  // * Paste from XLS is unnecessary since that method
  // will always be available for all brokers.
  //
  // EX: Plaid OR from file         = 101
  // EX: brokerconnect OR from file = 110
  // EX: from file only             = 100
  //
  TTLImportMethod = (imSelectEachTime, imBrokerConnect, imWebImport, imFileImport, imYodlee);
  // Import Filter Records as defined by the ImportFilter.cfg file. This file is currently
  // stored in the executable and is found in the project directory. Eventually this can
  // become a config file that we distribute with the exe and if found in the settings folder.
  // That way we could effectively add import filters to this file and push to the user without
  // having to recompile the executable.
  //
  TTLImportFilter = class
  private
    FAssignShortBuy : Boolean;
    FAutoAssignShorts : Boolean;
    FAutoAssignShortsOptions : Boolean;
    FBaseCurrLCID : Integer;
    FBrokerHasTimeOfDay : Boolean;
    FFilterName : String;
    FInstructPage : String;
    FListText : String;
    FSLConvert : Boolean;
    FSupportsCommission,
    FSupportsFlexibleCurrency : Boolean;
    FSupportsFlexibleAssignment : Boolean;
    FImportMethod : Integer;
    FFastLinkable : Boolean;
    FImportFunction : String;
    FImportFileExtension : String;
    FOFXFIID : String;
    FOFXFIOrg : String;
    FOFXBrokerID : String;
    FOFXURL : String;
    FOFXMonths : Integer;
    FOFXMaxMonths : Integer;
    FOFXDescOrder: Boolean;
    FOFXClass: String;
    FSupportsOFXFile : Boolean;
    FSupportsOFXConnect : Boolean;
    FFixShortsOOOrder : Boolean;
    FForceMatchStocks : Boolean;
    FForceMatchOptions : Boolean;
    FForceMatchFutures : Boolean;
    FForceMatchCurrencies : Boolean;
    FBrokerCode : string;
    FInstitutionId : string; // 2022-02-16 MB
    function GetAssignShortBuy : Boolean;
    function GetAutoAssignShorts : Boolean;
    function GetAutoAssignShortsOptions : Boolean;
    function GetBaseCurrLCID : Integer;
    procedure SetBaseCurrLCID(const Value : Integer);
    function GetBrokerHasTimeOfDay : Boolean;
    function GetCurrencySymbol : String;
    function GetFilterName : String;
    function GetInstructPage : String;
    function GetListText : String;
    function GetSLconvert : Boolean;
    function GetImportFunction : String;
    function GetImportMethod: Integer;
    function GetFastLinkable: Boolean;
    function GetSupportsCommission: Boolean;
    function GetSupportsFlexibleCurrency: Boolean;
    procedure SetImportMethod(const Value: Integer);
    function GetCurrencyDesc: String;
    function GetImportFileExtension: String;
    function GetSupportsFlexibleAssignment: Boolean;
    function GetOFXBrokerID: String;
    function GetOFXFIID: String;
    function GetOFXFIOrg: String;
    function GetOFXMonths: Integer;
    function GetOFXURL: String;
    function GetSupportsOFXConnect: Boolean;
    function GetOFXDescOrder: Boolean;
    function GetOFXMaxMonths: Integer;
    function GetOFXClass: String;
    function GetSupportsOFXFile: Boolean;
    function GetFixShortsOOOrder: Boolean;
    function GetForceMatchCurrencies: Boolean;
    function GetForceMatchFutures: Boolean;
    function GetForceMatchOptions: Boolean;
    function GetForceMatchStocks: Boolean;
    function GetBrokerCode : String;
    function GetInstitutionId : String; // 2022-02-16 MB
  public
    { Create a blank Import Filter Object with some default values.}
    constructor Create;
    { Update the import Filter with a new value.
      This method is primarily used by the TLFile object when it is updating
      it's local copy of the filter. This should NOT be used to update the
      stock filters that are read from the ImportFilters.Cfg file.
    }
    procedure Update(AFilter : TTLImportFilter);
    { Calls the associated Import method as defined in the ImportMethod field.
      This method must be declared in the published section of the
      TImportReadMethods object as defined in the TLImportReadMethods unit.
    }
    { If the broker reports TimeOfDay with the data then true else false}
    property BrokerHasTimeOfDay: boolean read GetBrokerHasTimeOfDay;
    { Do we need to do Short Long Conversion for this broker}
    property SLConvert: Boolean read GetSLconvert;
    { Are we assigning Short buys for this broker}
    property AssignShortBuy: Boolean read GetAssignShortBuy;
    { Are we auto assigning Shorts}
    property AutoAssignShorts: Boolean read GetAutoAssignShorts;
    { Are we auto assigning Short options}
    property AutoAssignShortsOptions: Boolean read GetAutoAssignShortsOptions;
    { The BaseCurrLCID is the Windows LCID value that points at the Locale to
      define the currency symbol for this broker, This will generally be set
      to zero or ENGLISH_US, Zero will default to English_US In order for this
      value to be changed the SupportsFlexibleCurrency property must be true.
    }
    property BaseCurrLCID: integer read GetBaseCurrLCID write SetBaseCurrLCID;
    { The currency symbol associated with the BaseCurrLCID.
      This is read directly form the Locale Info data for the LCID }
    property BrokerCode : string read GetBrokerCode;
    property InstitutionId : string read GetInstitutionId; // 2022-02-16 MB
    property CurrencySymbol: string read GetCurrencySymbol;
    { The description of the Locale for the Base Currency}
    property CurrencyDesc : String read GetCurrencyDesc;
    { When showing this import filter in a GUI List this is the text we will use to represent it}
    property ListText: string read GetListText;
    { This is the key value, the filter name and is stored in the header of the TLFile object}
    property FilterName: string read GetFilterName;
    { This is the instruction page associated with this broker from the online manual}
    property InstructPage: string read GetInstructPage;
    { This is the String name of the Import function to call when then Import method above is called}
    property ImportFunction : String read GetImportFunction;
    { This value defines the valid import methods for this broker;
      0, 10, 20, 30, 40 are the valid values. These numbers represent
      combinations of the TTLImportMethod types as defined above.
      0 = Do Not show Import Methods as there is only one method for this
          broker; This one method is defined in the read method [which is]
          defined by the ImportFunction value above.
      The following values represent different combinations that should be
      shown to the user as follows:
        10 = BrokerConnect and WebImport.
        20 = BrokerConnect, WebImport and DownloadFile.
        30 = BrokerConnect and DownloadFile.
        40 = WebImport and DownloadFile
      Additionally "Select Each Time" Is always shown as the first item in the list.
    }
    property ImportMethod : Integer read GetImportMethod write SetImportMethod;
    property FastLinkable : Boolean read GetFastLinkable;
    { Does this ImportFilter support a Round Trip Commission}
    property SupportsCommission : Boolean read GetSupportsCommission;
    { Does this ImportFilter support flexibile currency}
    property SupportsFlexibleCurrency : Boolean read GetSupportsFlexibleCurrency;
    property SupportsFlexibleAssignment : Boolean read GetSupportsFlexibleAssignment;
    { Import File Extension}
    property ImportFileExtension : String read GetImportFileExtension;
    { OFX Parameters for OFX supported Brokers}
    property OFXConnect : Boolean read GetSupportsOFXConnect;
    property OFXFile : Boolean read GetSupportsOFXFile;
    property OFXFIID : String read GetOFXFIID;
    property OFXFIOrg : String read GetOFXFIOrg;
    property OFXBrokerID : String read GetOFXBrokerID;
    property OFXURL : String read GetOFXURL;
    { Number of months you can request at one time}
    property OFXMonths : Integer read GetOFXMonths;
    { Maximum Number of Months you can go back}
    property OFXMaxMonths : Integer Read GetOFXMaxMonths;
    property OFXDescOrder : Boolean read GetOFXDescOrder;
    property OFXClass : String read GetOFXClass;
    property FixShortsOOOrder : Boolean read GetFixShortsOOOrder;
    property ForceMatchStocks : Boolean read GetForceMatchStocks;
    property ForceMatchOptions : Boolean read GetForceMatchOptions;
    property ForceMatchFutures : Boolean read GetForceMatchFutures;
    property ForceMatchCurrencies : Boolean read GetForceMatchCurrencies;
  end;

  { Location Objects read from the OS. Since we are just using this for base currency
    for now all we need it the LCID with it's associated description and Currency Symbol.
    There is other data associated with the Locale but since we don't need it at present we
    are not reading it in here. }
  TTLLocInfo = class
  private
    FDescription: String;
    FLCID: Integer;
    FCurrencySymbol: String;
    function GetCountry: String;
  public
    constructor Create(LCID : Integer; CurrencySymbol : String; Description : String);
    property LCID: Integer read FLCID;
    property CurrencySymbol: String read FCurrencySymbol;
    property Description: String read FDescription;
    property Country: String read GetCountry;
  end;

  { ObjectDictionary is another new Generics List that is a Key Value Pair
    implementation similar to the Java HashMap or Tree Map. The first value
    of type String is the key and the second Value of whatever object type
    is the Value. Since these are Object centric components then the objects
    will be freed automatically when the Lists free method is called.
    Also, because the Key is now a string, we can use the method
    TryGetValue(Key, ValueObject) to get the Value associated with the key.
  }
  TLocInfoList = TObjectDictionary<String, TTLLocInfo>;

  TImportFilterList = Class(TObjectDictionary<String, TTLImportFilter>)
  private
    FImportMethodSet : TStringList;
    function GetImportMethodDesc(Index: TTLImportMethod): String;
    function GetImportMethodSet(Index: Integer): TStringList;
    function GetImportMethodFromDesc(Index: String) : TTLImportMethod;
  published
  public
    constructor Create;
    destructor Destroy; override;
    property ImportMethodDesc[Index : TTLImportMethod] : String read GetImportMethodDesc;
    property ImportMethodSet[Index : Integer] : TStringList read GetImportMethodSet;
    property ImportMethodFromDesc[Index : String] : TTLImportMethod read GetImportMethodFromDesc;
  end;

  procedure InitializeImportFilters;
  procedure FinalizeImportFilters;

  procedure InitializeLocales;
  procedure FinalizeLocales;
const
  IMPORT_METHOD_SELECT = 'Select Each Time';
  IMPORT_METHOD_BROKER_CONNECT = 'BrokerConnect:Classic';
  IMPORT_METHOD_WEB_IMPORT = 'Web Import:Copy/Paste';
  IMPORT_METHOD_FILE_IMPORT = 'Download File';
  IMPORT_METHOD_YODLEE = 'BrokerConnect:Yodlee';
  EnglishUS = 1033;

var
  ImportFilters : TImportFilterList;
  LocaleInfoList : TLocInfoList;

implementation

uses uLKJson, Variants, Windows,
uDM;

function GetLocInfo(Loc: integer; InfoType: Cardinal; Len: integer): string;
var
  Buff: PChar;
begin
  GetMem(Buff, Len);
  GetLocaleInfo(Loc, InfoType, Buff, Len);
  Result := Buff;
  FreeMem(Buff);
end;


{ This is an enums call back method that is used by the windows API Call for
  getting all Locale's from the OS (EnumSystemLocales).
  Please see the Windows documentation for this function to understand how
  this call back method is used.

  Basically it is called for each Locale that is registered with windows so
  we can get the currency information for the Locales.
}
function LocalesEnumCallback(Name: Pchar): Integer; stdcall;
var
  LCID: Integer;
  Currency : String;
  Description : String;
  LocInfo : TTLLocInfo;
begin
  Result := 1;
  LCID := StrToInt('$' + Name);
  Currency := GetLocInfo(LCID, LOCALE_SCURRENCY, 6);
  if pos('?', Currency) = 0 then
  begin
    Description := GetLocaleStr(LCID, LOCALE_SLANGUAGE, '');
    LocInfo := TTLLocInfo.Create(LCID, Currency, Description);
    LocaleInfoList.Add(IntToStr(LCID), LocInfo);
  end;
end;

{ TImpFilter }

constructor TTLImportFilter.Create;
begin
  FAssignShortBuy := False;
  FAutoAssignShorts := False;
  FAutoAssignShortsOptions := False;
  FBaseCurrLCID := EnglishUS;
  FBrokerHasTimeOfDay := False;
  FSLConvert := False;
  FImportMethod := 0;
  FFilterName := '';
  FInstructPage := '0';
  FListText := '';
  FImportFunction := '';
  FSupportsCommission := False;
  FSupportsFlexibleCurrency := False;
  FSupportsFlexibleAssignment := False;
  FImportFileExtension := '.csv';
  FOFXFIID := '';
  FOFXFIOrg := '';
  FOFXBrokerID := '';
  FOFXURL := '';
  FOFXMonths := 0;
  FOFXDescOrder := False;
  FOFXMaxMonths := 0;
  FOFXClass := 'TTLImport';
  FSupportsOFXFile := False;
  FSupportsOFXConnect := False;
  FFixShortsOOOrder := False;
  FForceMatchStocks := False;
  FForceMatchOptions := False;
  FForceMatchFutures := False;
  FForceMatchCurrencies := False;
end;

procedure FinalizeImportFilters;
begin
  ImportFilters.Free;
  FinalizeLocales
end;

function TTLImportFilter.GetAssignShortBuy: Boolean;
begin
  Result := FAssignShortBuy;
end;

function TTLImportFilter.GetAutoAssignShorts: Boolean;
begin
  Result := FAutoAssignShorts;
end;

function TTLImportFilter.GetAutoAssignShortsOptions: Boolean;
begin
  Result := FAutoAssignShortsOptions;
end;

function TTLImportFilter.GetBaseCurrLCID: Integer;
begin
  if FBaseCurrLCID = 0 then
    Result := EnglishUS
  else
    Result := FBaseCurrLCID;
end;

function TTLImportFilter.GetBrokerHasTimeOfDay: Boolean;
begin
  Result := FBrokerHasTimeOfDay;
end;

{ If the Base Currency LCID exists in the list of valid Locale's
  then get it and return it's currency symbol. Otherwise do not
  throw an error but just return US currency symbol of $
}
function TTLImportFilter.GetCurrencyDesc: String;
var
  Locale : TTLLocInfo;
begin
  Result := 'English (United States)';
  if (BaseCurrLCID <> EnglishUS) //
  and (LocaleInfoList.TryGetValue(IntToStr(BaseCurrLCID), Locale)) //
  then
    Result := Locale.Description;
end;

function TTLImportFilter.GetCurrencySymbol: String;
var
  Locale : TTLLocInfo;
begin
  Result := '$';
  if (BaseCurrLCID <> EnglishUS) //
  and (LocaleInfoList.TryGetValue(IntToStr(BaseCurrLCID), Locale)) //
  then
    Result := Locale.CurrencySymbol;
end;

function TTLImportFilter.GetFilterName: String;
begin
  Result := FFilterName;
end;

function TTLImportFilter.GetFixShortsOOOrder: Boolean;
begin
  Result := FFixShortsOOOrder;
end;

function TTLImportFilter.GetForceMatchCurrencies: Boolean;
begin
  Result := FForceMatchCurrencies;
end;

function TTLImportFilter.GetForceMatchFutures: Boolean;
begin
  Result := FForceMatchFutures;
end;

function TTLImportFilter.GetForceMatchOptions: Boolean;
begin
  Result := FForceMatchOptions;
end;

function TTLImportFilter.GetForceMatchStocks: Boolean;
begin
  Result := FForceMatchStocks;
end;

function TTLImportFilter.GetImportFileExtension: String;
begin
  Result := FImportFileExtension;
end;

function TTLImportFilter.GetImportFunction: String;
begin
  Result := FImportFunction
end;

function TTLImportFilter.GetImportMethod: Integer;
begin
  Result := FImportMethod;
end;

function TTLImportFilter.GetFastLinkable: Boolean;
begin
  Result := FFastLinkable;
end; //FastLinkable

function TTLImportFilter.GetInstructPage: String;
begin
  Result := FInstructPage;
end;

function TTLImportFilter.GetListText: String;
begin
  Result := FListText;
end;

function TTLImportFilter.GetOFXBrokerID: String;
begin
  Result := FOFXBrokerID;
end;

function TTLImportFilter.GetOFXClass: String;
begin
  Result := FOFXClass;
end;

function TTLImportFilter.GetOFXDescOrder: Boolean;
begin
  Result := FOFXDescOrder;
end;

function TTLImportFilter.GetOFXFIID: String;
begin
  Result := FOFXFIID;
end;

function TTLImportFilter.GetSupportsOFXFile: Boolean;
begin
  Result := FSupportsOFXFile;
end;

function TTLImportFilter.GetOFXFIOrg: String;
begin
  Result := FOFXFIOrg;
end;

function TTLImportFilter.GetOFXMaxMonths: Integer;
begin
  Result := FOFXMaxMonths;
end;

function TTLImportFilter.GetOFXMonths: Integer;
begin
  Result := FOFXMonths;
end;

function TTLImportFilter.GetOFXURL: String;
begin
  Result := FOFXURL;
end;

function TTLImportFilter.GetSLconvert: Boolean;
begin
  Result := FSLConvert;
end;

function TTLImportFilter.GetSupportsCommission: Boolean;
begin
  Result := FSupportsCommission;
end;

function TTLImportFilter.GetSupportsFlexibleAssignment: Boolean;
begin
  Result := FSupportsFlexibleAssignment;
end;

function TTLImportFilter.GetSupportsFlexibleCurrency: Boolean;
begin
  Result := FSupportsFlexibleCurrency;
end;

function TTLImportFilter.GetSupportsOFXConnect: Boolean;
begin
  Result := FSupportsOFXConnect;
end;

function TTLImportFilter.GetBrokerCode: String;
begin
  Result := FBrokerCode;
end;

function TTLImportFilter.GetInstitutionId : String; // 2022-02-16 MB
begin
  Result := FInstitutionId;
end;


procedure InitializeImportFilters;
var
//  F : TResourceStream;
//  JSONObject : TlkJSONObject;
  Filter : TlkJSONObject;
  ImpFilter : TTLImportFilter;
  I : Integer;
  t : string;
begin
  InitializeLocales;
  ImportFilters := TImportFilterList.Create;
  try
//  exit;   // RJ August 27 to skip out of IMPORTFILTER error
  // 1. check for internet
  // 2. update ImpFilter
    with DM do begin
      RestClient1.BaseURL := url + 'importfilters';
      RESTRequest1.Execute;
//      q.Connection := fDB;
(*
      if (MemTable.RecordCount > 0) then begin
        CreateImportFilters;
        InsertIntoImportFilters;
      end;
*)    MemTable.First;
      //Read data from _importfilters table
      while not MemTable.EOF do
        try
          for I := 0 to MemTable.RecordCount - 1 do begin
            ImpFilter := TTLImportFilter.Create;
            ImpFilter.FFilterName := FieldAsString(MemTable.FieldByName('FilterName'));
            ImpFilter.FListText := FieldAsString(MemTable.FieldByName('ListText'));
            ImpFilter.FImportFunction := FieldAsString(MemTable.FieldByName('ImportFunction'));
            ImpFilter.FAssignShortBuy := FieldAsBoolOrFalse(MemTable.FieldByName('AssignShortBuy'));
            ImpFilter.FAutoAssignShorts := FieldAsBoolOrFalse(MemTable.FieldByName('AutoAssignShorts'));
            ImpFilter.FAutoAssignShortsOptions := FieldAsBoolOrFalse(MemTable.FieldByName('AutoAssignShorts'));
  //          ImpFilter.FImportMethod := FieldAsIntOrZero(MemTable.FieldByName('ImportMethod'));
  //            ImpFilter.FFastLinkable := FieldAsBoolOrFalse(MemTable.FieldByName('FastLinkable'))
            ImpFilter.FBrokerCode := FieldAsString(MemTable.FieldByName('BrokerCode'));
  //          ImpFilter.FInstitutionId := VarToStr(MemTable.FieldByName('InstitutionId')); // 2022-02-16 MB
            ImpFilter.FBrokerHasTimeOfDay := FieldAsBoolOrFalse(MemTable.FieldByName('BrokerHasTime'));
            ImpFilter.FSLConvert := FieldAsBoolOrFalse(MemTable.FieldByName('SLConvert'));
            ImpFilter.FInstructPage := FieldAsString(MemTable.FieldByName('InstructPage'));
  //            ImpFilter.FSupportsCommission := FieldAsBoolOrFalse(MemTable.FieldByName('SupportsCommission'))
            ImpFilter.FBaseCurrLCID := FieldAsIntOrZero(MemTable.FieldByName('BaseCurrLCID'));
  //            ImpFilter.FSupportsFlexibleCurrency := FieldAsBoolOrFalse(MemTable.FieldByName('SupportsFlexibleCurrency'))
  //            ImpFilter.FSupportsFlexibleAssignment := FieldAsBoolOrFalse(MemTable.FieldByName('SupportsFlexibleAssignment'))
            ImpFilter.FImportFileExtension := '.' + FieldAsString(MemTable.FieldByName('ImportFileExtension'));
            ImpFilter.FOFXFIID := FieldAsString(MemTable.FieldByName('OFXFIID'));
            ImpFilter.FOFXFIOrg := FieldAsString(MemTable.FieldByName('OFXFIOrg'));
            ImpFilter.FOFXBrokerID := FieldAsString(MemTable.FieldByName('OFXBrokerID'));
            ImpFilter.FOFXURL := FieldAsString(MemTable.FieldByName('OFXURL'));
            ImpFilter.FOFXMonths := FieldAsIntOrZero(MemTable.FieldByName('OFXMonths'));
            ImpFilter.FOFXDescOrder := FieldAsBoolOrFalse(MemTable.FieldByName('OFXDescOrder'));
            ImpFilter.FOFXMaxMonths := FieldAsIntOrZero(MemTable.FieldByName('OFXMonths'));
  //          ImpFilter.FOFXClass := FieldAsString(MemTable.FieldByName('OFXClass'));
            ImpFilter.FSupportsOFXConnect := FieldAsBoolOrFalse(MemTable.FieldByName('OFXDirectConnect'));
  //          ImpFilter.FSupportsOFXFile := FieldAsBoolOrFalse(MemTable.FieldByName('OFXFile'));
  //            ImpFilter.FFixShortsOOOrder := FieldAsBoolOrFalse(MemTable.FieldByName('FixShortsOOOrder'));
  //            ImpFilter.FForceMatchStocks := FieldAsBoolOrFalse(MemTable.FieldByName('ForceMatchStocks'));
  //            ImpFilter.FForceMatchOptions := FieldAsBoolOrFalse(MemTable.FieldByName('ForceMatchOptions'));
  //            ImpFilter.FForceMatchCurrencies := FieldAsBoolOrFalse(MemTable.FieldByName('ForceMatchCurrencies'))
  //            ImpFilter.FForceMatchFutures := FieldAsBoolOrFalse(MemTable.FieldByName('ForceMatchFutures'));

            ImportFilters.Add(ImpFilter.FilterName, ImpFilter);
            MemTable.Next;
          end;
        finally
//          JSONObject.Free;
        end;
    end;
  finally
  end;
end;


procedure TTLImportFilter.SetBaseCurrLCID(const Value: integer);
begin
  FBaseCurrLCID := Value;
end;

procedure TTLImportFilter.SetImportMethod(const Value: Integer);
begin
  FImportMethod := Value;
end;

procedure TTLImportFilter.Update(AFilter: TTLImportFilter);
begin
  FAssignShortBuy := AFilter.AssignShortBuy;
  FAutoAssignShorts := AFilter.AutoAssignShorts;
  FAutoAssignShortsOptions := AFilter.AutoAssignShortsOptions;
  FBaseCurrLCID := AFilter.BaseCurrLCID;
  FBrokerCode := AFilter.BrokerCode;
  FInstitutionId := AFilter.InstitutionId; // 2022-02-16 MB
  FBrokerHasTimeOfDay := AFilter.BrokerHasTimeOfDay;
  FFilterName := AFilter.FilterName;
  FInstructPage := AFilter.InstructPage;
  FListText := AFilter.ListText;
  FSLConvert := AFilter.SLConvert;
  FSupportsCommission := AFilter.SupportsCommission;
  FSupportsFlexibleCurrency := AFilter.SupportsFlexibleCurrency;
  FSupportsFlexibleAssignment := AFilter.SupportsFlexibleAssignment;
  FImportMethod := AFilter.ImportMethod;
  FFastLinkable := AFilter.FFastLinkable;
  FImportFunction := AFilter.ImportFunction;
  FImportFileExtension := AFilter.ImportFileExtension;
  FOFXFIID := AFilter.OFXFIID;
  FOFXFIOrg := AFilter.OFXFIOrg;
  FOFXBrokerID := AFilter.OFXBrokerID;
  FOFXURL := AFilter.OFXURL;
  FOFXMonths := AFilter.FOFXMonths;
  FOFXDescOrder := AFilter.OFXDescOrder;
  FOFXMaxMonths := AFilter.OFXMaxMonths;
  FOFXClass := AFilter.OFXClass;
  FSupportsOFXFile := AFilter.OFXFile;
  FSupportsOFXConnect := AFilter.OFXConnect;
  FFixShortsOOOrder   := AFilter.FFixShortsOOOrder;
  FForceMatchStocks := AFilter.FForceMatchStocks;
  FForceMatchOptions := AFilter.FForceMatchOptions;
  FForceMatchFutures := AFilter.FForceMatchFutures;
  FForceMatchCurrencies := AFilter.FForceMatchCurrencies;
end;

{ TTLLocInfo }

constructor TTLLocInfo.Create(LCID: Integer; CurrencySymbol, Description: String);
begin
  FLCID := LCID;
  FCurrencySymbol := CurrencySymbol;
  FDescription := Description;
end;

procedure InitializeLocales;
begin
  {Initialize the Locale List}
  LocaleInfoList := TLocInfoList.Create;
  EnumSystemLocales(@LocalesEnumCallback, LCID_INSTALLED);
end;

procedure FinalizeLocales;
begin
  LocaleInfoList.Free;
end;

function TTLLocInfo.GetCountry: String;
var
  OpenParen : Integer;
begin
  OpenParen := Pos( '(', FDescription);
  if  OpenParen > 0 then
    Result := Copy(FDescription, OpenParen + 1, Length(FDescription) - (OpenParen + 1))
  else
    Result := FDescription;
end;

{ TImportFilterList }

constructor TImportFilterList.Create;
begin
  {Since we cannot always be sure that the character case is matched from the file to what we
    are using in our config file, when we crete the underlying Object Dictionary lets also change the
    default comparer so that the TryGetValue method will do a case insensitive
    lookup of the key}
  inherited Create(TDelegatedEqualityComparer<String>.Create(
    function(const Left, Right: String): Boolean
    begin
      { Make a case insensitive comparison }
      Result := CompareText(Left, Right) = 0;
    end,
    { THasher<String> }
    function(const Value: String): Integer
    begin
      Result := Length(Value);
    end));
  FImportMethodSet := TStringList.Create;
end;

destructor TImportFilterList.Destroy;
begin
  FImportMethodSet.Free;
  inherited;
end;

function TImportFilterList.GetImportMethodDesc(Index: TTLImportMethod): String;
begin
  case Index of
    imSelectEachTime: Result := IMPORT_METHOD_SELECT;
    imBrokerConnect: Result := IMPORT_METHOD_BROKER_CONNECT;
    imWebImport: Result := IMPORT_METHOD_WEB_IMPORT;
    imFileImport: Result := IMPORT_METHOD_FILE_IMPORT;
    imYodlee: Result := IMPORT_METHOD_YODLEE;
  end;
end;

function TImportFilterList.GetImportMethodFromDesc(Index : String): TTLImportMethod;
begin
  if Index = IMPORT_METHOD_SELECT then
    Result := imSelectEachTime
  else if Index = IMPORT_METHOD_BROKER_CONNECT then
    Result := imBrokerConnect
  else if Index = IMPORT_METHOD_WEB_IMPORT then
    Result := imWebImport
  else if Index = IMPORT_METHOD_FILE_IMPORT then
    Result := imFileImport
  else if Index = IMPORT_METHOD_YODLEE then
    Result := imYodlee
  else
    raise EImportFilterException.Create('Import Method does not exist for Description: ' + Index);
end;

// --------------------------------------------------------
// The following values represent different combinations
// that should be shown to the user as follows:
//   LeftInt              RightInt
//   10 = BrokerConnect = 1 and Download File = 2.
//   20 = BrokerConnect = 1, DownloadFile = 2 and WebImport = 3
//   30 = BrokerConnect = 1 and Web Import = 2.
//   40 = DownloadFile = 1 and WebImport = 2
//   50 = Yodlee Aggregator
// --------------------------------------------------------
function TImportFilterList.GetImportMethodSet(Index: Integer): TStringList;
begin
  FImportMethodSet.Clear;
  FImportMethodSet.Add(ImportMethodDesc[imSelectEachTime]);
  case Index of
    1 : begin
      FImportMethodSet.Add(ImportMethodDesc[imBrokerConnect]);
      FImportMethodSet.Add(ImportMethodDesc[imFileImport]);
    end;
    2 : begin
      FImportMethodSet.Add(ImportMethodDesc[imBrokerConnect]);
      FImportMethodSet.Add(ImportMethodDesc[imWebImport]);
      FImportMethodSet.Add(ImportMethodDesc[imFileImport]);
    end;
    3 : begin
      FImportMethodSet.Add(ImportMethodDesc[imBrokerConnect]);
      FImportMethodSet.Add(ImportMethodDesc[imWebImport]);
    end;
    4 : begin
      FImportMethodSet.Add(ImportMethodDesc[imWebImport]);
      FImportMethodSet.Add(ImportMethodDesc[imFileImport]);
    end;
    5 : begin
      FImportMethodSet.Add(ImportMethodDesc[imYodlee]);
      FImportMethodSet.Add(ImportMethodDesc[imFileImport]);
    end;
  end;
  Result := FImportMethodSet;
end;



Initialization
//  InitializeImportFilters;

Finalization
  FinalizeImportFilters;

end.
