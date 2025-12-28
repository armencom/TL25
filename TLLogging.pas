unit TLLogging;

interface

// VERY IMPORTANT: No Uses from other Tradelog specific units can appear in this class,
// as it must not try and load any TradeLog unit that has a logger until it is initialized,
// Also in the DPR file this unit must appear above all other tradeLog units.

uses
  SysUtils, Classes,
  Generics.Collections, Registry;

// Since the TLLogger must be the first unit initialized, it cannot "use"
// any other Tradelog units, or you'll get an Access Violation
// Therefore since we will save the Loggers enabled settings to the Registry we cannot use
// TLSettings. The TLLogging class will have to handle saving it's settings itself.

type

  ETLLoggingException = class(Exception);

  TTLLogging = class
  private
    IniFile : TRegIniFile;
    FLoggersEnabled : TDictionary<String, Boolean>;
    function GetCategoryCount: Integer;
    function GetCategory(Idx: Integer): String;
    function GetLoggerEnabled(Category: String): Boolean;
    procedure SetLoggerEnabled(Category: String; const Value: Boolean);
    function GetLogCategories: TArray<String>;
  public
    constructor Create;
    destructor Destroy; override;
    procedure LoadSettings;
    procedure SaveSettings;
    procedure UnRegisterLogger(Category : String);
    property LogCategoryCount : Integer read GetCategoryCount;
    property LogCategory[Idx : Integer] : String read GetCategory;
    property LogCategories : TArray<String> read GetLogCategories;
    property LoggerEnabled[Category : String] : Boolean read GetLoggerEnabled write SetLoggerEnabled;
  end;

var
  TLLoggers : TTLLogging;

implementation

const
  SOFTWARE = 'Software';
  TRADELOG = 'TradeLog';
  TRADELOG_LOGGERS = TRADELOG + '\Loggers';

{ TTLLogging }

constructor TTLLogging.Create;
begin
  IniFile:= TRegIniFile.Create (SOFTWARE);
  FLoggersEnabled := TDictionary<String, Boolean>.Create;
  LoadSettings;
end;

destructor TTLLogging.Destroy;
begin
  FLoggersEnabled.Free;
  IniFile.Free;
end;

function TTLLogging.GetCategory(Idx: Integer): String;
begin
//
end;

function TTLLogging.GetCategoryCount: Integer;
begin
//
end;


function TTLLogging.GetLogCategories: TArray<String>;
begin
//
end;

function TTLLogging.GetLoggerEnabled(Category: String): Boolean;
begin
  if FLoggersEnabled.ContainsKey(Category) then
    Result := FLoggersEnabled.Items[Category]
  else
    raise ETLLoggingException.Create('GetLoggerEnabled: Category does not exist: ' + Category);
end;


procedure TTLLogging.LoadSettings;
var
  Names : TStringList;
  I: Integer;
begin
  Names := TStringList.Create;
  try
    IniFile.ReadSection(TRADELOG_LOGGERS, Names);
    for I := 0 to Names.Count - 1 do
      FLoggersEnabled.Add(Names[I], StrToBool(IniFile.ReadString(TRADELOG_LOGGERS, Names[I], '0')));
  finally
    Names.Free;
  end;
end;

procedure TTLLogging.SaveSettings;
var
  Category : String;
begin
  for Category in FLoggersEnabled.Keys do
    IniFile.WriteString(TRADELOG_LOGGERS, Category, BoolToStr(FLoggersEnabled.Items[Category]));
end;


procedure TTLLogging.SetLoggerEnabled(Category: String; const Value: Boolean);
begin
  //
end;

procedure TTLLogging.UnRegisterLogger(Category: String);
begin
  //
end;

initialization
  TLLoggers := TTLLogging.Create;

finalization
  TLLoggers.SaveSettings;
  TLLoggers.Free;
end.

