unit TLCommonLib;

interface

uses SysUtils, Classes, Windows, StrUtils, DateUtils, Forms, Graphics, dialogs;

type
  TLBasicStatusCallback = procedure(Msg : String) of Object;
  TLStatusCallback = procedure(Msg : String; Hint : String; Color : TColor) of Object;
  TTLAccountType = (atCash, atIRA, atMTM);


function GetEasternTime: TDateTime;

function ReversePos(const SubStr,S:string):Integer; // 2018-03-09 MB

function ProperCase(S:String) : String;
function IsInt(s: string): boolean;
function IsFloat(s: string): boolean;
function IsFloatEx(s: string; Fmt: TFormatSettings): boolean;

function GetDateStrFmt(sDate : string): string; // NEW 2023-03-29 MB

function US_DateStr(s: String; Fmt: TFormatSettings): String;
function US_DateStrLong(DateStr: string): string;
Function UserDateToInternalDate(UserDate: String): String;
Function UserTimeToInternalTime(UserTime: String; Make24Hr: boolean): String;
function countTabs(s: string): integer;
function IsLongDate(s: string): boolean;

function xStrToFloatEx(s: string; IsCurr: Boolean; Fmt: TFormatSettings): extended;
function LongDateStrEx(DateStr: String; InFmt, OutFmt: TFormatSettings): String;
function xStrToInt(s: string): integer;

function xStrToDate(const s: string): TDateTime; overload;
function xStrToDate(const s: string; Fmt: TFormatSettings): TDateTime; overload;

function yyyymmddToUSDate(s : string): string;

function ReplaceMonthName(const s : String; var Fmt : TFormatSettings) : String;
function ReadUrlEx(URL:string; Timeout : integer = 20000) : String;
function ParseHTML(Html, OpenTag, CloseTag : String) : String;

function CheckOptionFormat(Ticker : String) : Boolean;
function ValidExpDate(Value : String) : Boolean;
function ConvertExpDate(Value: String): TDateTime;

function rndTo2(amt: double): double;
function rndTo5(amt: double): double;
function rndTo6(amt: double): double;
function rndTo8(amt: double): double;
function rndTo10(amt: double): double;

function GetInetFile(const fileURL, FileName: String): boolean;

function EncryptStr(const S:String): String;
function DecryptStr(const S:String): String;
function dEnCrypt(Str: string; Key: string): string;

// Returns the Error Code and Windows API Message associated with the ErrorCode parameter.
// Pass GetLastError to this function oo get the last error's message.
// If the message is not found then the error code is returned.
function GetLastErrorMessage(ErrorCode: integer): String;

function StrFmtToFloat(const Format: string; const Args: array of const ;
  const FormatSettings: TFormatSettings): extended;
function FloatToStrFmt(const Format: string; const Args: array of const ;
  const FormatSettings: TFormatSettings): string;
function GetLocInfo(Loc: integer; InfoType: Cardinal; Len: integer): string;

function fracToDecStr(s:string):string;

function ParseLast(var S: String; sep : String) : String;
function ParseFirst(var S: String; sep : String) : String;
function parseBetween(var S : string; OpenTag, CloseTag :string): string;
function parseWords(s:string; N:Integer): string;

function IsStockType(TypeMult : String) : Boolean;
function IsOption(Prf: String; Ticker: String;futures: boolean = true): Boolean;

function CountOfChar(C : Char; S : String) : Integer;
function RemoveParens(Value : String) : String;

function MakeMultiLine(Value : String; BreakOn : Integer) : String;

function GetAppVersion : String;

function MemoryUsed: cardinal;

function getExpMoNum(s: string): string;
function getExpMo(s: string): string;
function formatTkSort(tk,typeMult,acctType:string) : string;
function GetAccountTypeAsChar(AcctType : TTLAccountType) : Char;

function OccurrencesOfChar(const S: string; const C: char): integer;

function settlementStartDate(lastDayOfYear:TDate):TDate;

function StripNonAlpha(s : string) : string;

function getStockTicker(sDesc : string; var foundTickList : TStringList) : boolean;
function findTicksWithStockDescr(bImporting:Boolean):TStringList;
function isTickerSymbol(s:string): boolean;
function parseUnderlying(s:string): string;
function replaceUnderlying(s, sUnderlying:string): string;

/// The next 3 functions added 2016-11-10 MB
function IsNumber(str: string): Boolean; // e.g. IsNumber('2016')
function IsDate(str: string): Boolean; // e.g. IsDate('11/10/16')
function IsInDateRange(sTestDate, sDate1, sDate2: string): boolean;


var
  MsgTxt,   // Used in a lot of places for message text}
  SortBy,   // Sorting and Grid Display variables, to show how the grid is filtered and sorted
  TrFileName, LastFileName : string;

  b8949,
  renumFldChanged,  // Keeps track of whether a field that requires renumbering was changed
  StopReport,       // Used when trying to stop a report with Escape Key
  StopUpdate : Boolean;  // Used in a lot of places for message text

  lineList : TStringList;  // keeps track of plain text file lines
  BrList : TStringList; // keeps track of broker accounts

  currSubscr, taxidVer, isDBFile, bImportingAccounts, addExistingAcct, //
  nonTaxFile, cancelURL, bEditsDisabled : Boolean;

  ProVer, ProManager, SuperUser, Developer : boolean;

  iVer, iFormL, iFormT, iFormW, iFormH : integer;

const
  EnglishUS = 1033;
  tab = chr(9);
  lf = chr(10);
  cr = chr(13);
  crlf = chr(13) + chr(10);
  qc = chr(39);
  alt = 18;
  sMsgGetCSV = 'Getting Trade History CSV File';

implementation

uses
  IdGlobal, // needed to use function IsNumberic(str)
  TLSettings, TLFile, SysConst, WinInet, TLWinInet, //
  TLLogging, TL_Passiv, globalVariables,
  Main, clipbrd;

type
  EReadUrlException = class(Exception);

const
  CODE_SITE_CATEGORY = 'TLCommonLib';


// ------------------------------------
function GetEasternTime: TDateTime;
var
  T: TSystemTime;
  TZ: TTimeZoneInformation;
begin
  // Get Current time in UTC
  GetSystemTime(T);
  // Setup Timezone Information for Eastern Time
  TZ.Bias:= 0;
  // DST ends at First Sunday in November at 2am
  TZ.StandardBias:= 300;
  TZ.StandardDate.wYear:= 0;
  TZ.StandardDate.wMonth:= 11; // November
  TZ.StandardDate.wDay:= 1; // First
  TZ.StandardDate.wDayOfWeek:= 0; // Sunday
  TZ.StandardDate.wHour:= 2;
  TZ.StandardDate.wMinute:= 0;
  TZ.StandardDate.wSecond:= 0;
  TZ.StandardDate.wMilliseconds:= 0;
  // DST starts at Second Sunday in March at 2am
  TZ.DaylightBias:= 240;
  TZ.DaylightDate.wYear:= 0;
  TZ.DaylightDate.wMonth:= 3; // March
  TZ.DaylightDate.wDay:= 2; // Second
  TZ.DaylightDate.wDayOfWeek:= 0; // Sunday
  TZ.DaylightDate.wHour:= 2;
  TZ.DaylightDate.wMinute:= 0;
  TZ.DaylightDate.wSecond:= 0;
  TZ.DaylightDate.wMilliseconds:= 0;
  // Convert UTC to Eastern Time
  Win32Check(SystemTimeToTzSpecificLocalTime(@TZ, T, T));
  // Convert to and return as TDateTime
  Result := EncodeDate(T.wYear, T.wMonth, T.wDay) +
   EncodeTime(T.wHour, T.wMinute, T.wSecond, T.wMilliSeconds);
end;


// ------------------------------------
function ReversePos(const SubStr, S : string) : Integer;
var
  i, l : integer;
begin
  Result := 0;
  l := length(SubStr);
  for i := length(S) - l + 1 downto 1 do begin
    if copy(S, i, l) = SubStr then begin
      Result := i;
      break;
    end;
  end;
end;


// ------------------------------------
function CountOfChar(C : Char; S : String) : Integer;
begin
  Result := Length(S) - Length(StringReplace(S, C, '', [rfReplaceAll, rfIgnoreCase]));
end;


// ------------------------------------
function IsStockType(TypeMult : String): Boolean;
begin
  Result := (pos('STK', TypeMult) = 1) //
         or (pos('DRP', TypeMult) = 1) //
         or (pos('MUT', TypeMult) = 1) //
         or (pos('ETF', TypeMult) = 1) //
         or (pos('SSF', TypeMult) = 1);
end;


// ------------------------------------
function IsOption(Prf: String; Ticker: String; futures: boolean = true): Boolean;
var
  pBBIO: PBBIOItem;
  i: integer;
begin
  // break the compound IF into sections
  if not CheckOptionFormat(Ticker) then begin
    Result := false;
    exit; // if this fails, the rest doesn't matter
  end;
  if (Pos('OPT', Prf) = 1) then begin
    Result := true;
    exit; // if OPT, no need to check anything else
  end;
  if futures then begin // allow ANY futures
    Result := (Pos('FUT', Prf) = 1);
    exit;
  end
  else begin // ONLY allow BBIOs
    // this argument is ONLY used by Ex/As function, so OK to modify.
    // Need a way to allow BBIO but no other FUT (for Ex/As) - 2015-05-01 MB
    Result := false; // until proven true
    for i := 0 to Settings.BBIOList.Count - 1 do begin // 2018-04-10 MB
      pBBIO := Settings.BBIOList[i];
      if (pos(trim(pBBIO.symbol) + ' ', Ticker) = 1) then begin
        Result := true;
        break;
      end;
    end;
  end;
end;

// ------------------------------------
// why not keep rndTo2, rndTo5, ... rndTo10, but make them all '%1.10f'?
// also can replace all StrFmtToFloat calls

function rndTo2(amt: double): double;
begin
  Result := StrFmtToFloat('%1.2f', [amt], Settings.UserFmt);
end;

function rndTo5(amt: double): double;
begin
  Result := StrFmtToFloat('%1.5f', [amt], Settings.UserFmt);
end;

function rndTo6(amt: double): double;
begin
  Result := StrFmtToFloat('%1.6f', [amt], Settings.UserFmt);
end;

function rndTo8(amt: double): double;
begin
  Result := StrFmtToFloat('%1.8f', [amt], Settings.UserFmt);
end;

function rndTo10(amt: double): double;
begin
  Result := StrFmtToFloat(DECIMALS10, [amt], Settings.UserFmt);
end;

// ------------------------------------

function ParseHTML(Html, OpenTag, CloseTag : String) : String;
begin
  Delete(Html, 1, Pos(OpenTag , Html) + length(OpenTag) - 1);
  Result:= Trim(Copy(Html, 1, Pos(CloseTag, Html) - 1));
end;


function MemoryUsed: cardinal;
var
  st: TMemoryManagerState;
  sb: TSmallBlockTypeState;
begin
  GetMemoryManagerState(st);
  result := st.TotalAllocatedMediumBlockSize + st.TotalAllocatedLargeBlockSize;
  for sb in st.SmallBlockTypeStates do begin
    result := result + sb.UseableBlockSize * sb.AllocatedBlockCount;
  end;
end;


// --------------------------------------------------------
// EXAMPLE:
// fileURL = 'http://website.com/folder/file.ext'
// FileName = 'C:\<path>\file.ext'
// --------------------------------------------------------
function GetInetFile(const fileURL, FileName: String): boolean;
const
  BufferSize = 65536;
var
  hSession, hURL: HInternet;
  Buffer: array [1 .. BufferSize] of Byte;
  BufferLen: DWORD;
  f: File;
  sAppName: string;
  directory: String;
  s: TStringList;
begin
  directory := ExtractFilePath(FileName);
  Result := false;
  sAppName := ExtractFileName(Application.ExeName);
  hSession := InternetOpen(PChar(sAppName), INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  try
    hURL := InternetOpenURL(hSession, PChar(fileURL), nil, 0, INTERNET_FLAG_RELOAD, 0);
    try
      if hURL <> nil then begin
        AssignFile(f, FileName);
        Rewrite(f, 1);
        try
          repeat
            if InternetReadFile(hURL, @Buffer, SizeOf(Buffer), BufferLen) then begin
              //code for exiting routine when ESC key hit
              Application.ProcessMessages;
              if GetKeyState(VK_ESCAPE) and 128 = 128 then StopUpdate := True;
              if StopUpdate then break;
              BlockWrite(f, Buffer, BufferLen);
              if pos('setupTL',FileName)>0 then
                frmMain.stUpdateMsg.caption := 'Downloading Update . . . ' //
                  + format('%*.*n', [2, 1, fileSize(f)/1000000]) //
                  + ' mb - click Escape to cancel';
                frmMain.rbStatusBar.Panels[2].Text := 'Downloading Update . . . ' //
                  + format('%*.*n', [2, 1, fileSize(f)/1000000]) //
                  + ' mb - click Escape to cancel';
            end
            else
              raise EInOutError.Create('Internet Connection Failed. '
                + GetLastErrorMessage(GetLastError));
          until BufferLen = 0;
          if fileSize(f) > 0 then begin
            Result := True;
          end;
        finally
          CloseFile(f);
          if StopUpdate then result := false;
        end;
      end
      else
        raise EInOutError.Create('Internet Connection Failed. '
          + GetLastErrorMessage(GetLastError));
    finally
      InternetCloseHandle(hURL)
    end
  finally
    InternetCloseHandle(hSession)
  end;
  // Now lets make sure the file is not just a page not found XML Error.
  s := TStringList.Create;
  try
    s.LoadFromFile(FileName);
    if (Pos('Page Not Found', s.Text) > 0) //
    or (Pos('<HTML>', s.Text) > 0) //
    or (Pos('<html>', s.Text) > 0) //
    or (Pos('<Html>', s.Text) > 0) then begin
      SysUtils.DeleteFile(FileName);
      Result := false;
    end;
  finally
    s.Free;
  end;
end;


function ReadUrlEx(URL:string; Timeout : integer = 20000) : String;
var
  Buffer: array[1..32000] of AnsiChar;
  OpBuffer : integer;
  BytesRead : DWORD;
  HInet: HINTERNET;
  HFile: HINTERNET;
  Str:string;
begin
  try
    Str:='';
    Result:= '';
    fillChar(Buffer, 0, SizeOf(Buffer));
    if (Timeout > 999) then
      OpBuffer := Timeout
    else
      OpBuffer := 10000; //Value is in milliseconds
    HInet := InternetOpen(PChar(Application.title), INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
    try
      //could not connect to the Internet
      if HInet = nil then
        raise EReadUrlException.Create('Opening the Internet Connection Failed: ' + GetLastErrorMessage(GetLastError));
      InternetSetOption(HInet, INTERNET_OPTION_RECEIVE_TIMEOUT, @OpBuffer, SizeOf(OpBuffer));
      HFile:= InternetOpenURL(HInet, PChar(url), '', 0, INTERNET_FLAG_RELOAD, 0);
      try
        //page not found or not returned
        if HFile=nil then
          raise EReadUrlException.Create('URL Cannot Be Read: ' + URL + ' ' + GetLastErrorMessage(GetLastError));
        repeat
          //code for exiting routine when ESC key hit
          Application.ProcessMessages;
          if GetKeyState(VK_ESCAPE) and 128 = 128 then StopUpdate := True;
          if StopUpdate then begin
            Str:='Canceled';
            break;
          end;
          if InternetReadFile(HFile, @Buffer, SizeOf(Buffer), BytesRead) then
            Str:= Str + Copy(Buffer,1,BytesRead)
          else
            raise EInOutError.Create('InternetReadFile failed to read next packet. ' + GetLastErrorMessage(GetLastError));
          Application.ProcessMessages;
        until bytesRead = 0;
      finally
        InternetCloseHandle(HFile);
      end;
    finally
      InternetCloseHandle(HInet);
    end;
    result := Str;
  finally
    // TLCommonLib.ReadURLEX
  end;
end;


// -------------------------+
function EncryptStr(const s:String) : String;
var
  I, x : integer;
begin
  Result := s;
  x := 5;
  for I := 1 to Length(s) do begin
    if Byte(s[I])=12 then continue; // don't encode TAB (9 XOR 5 = 12)
    Result[I] := Char(Byte(s[I]) xor x);
  end;
end; // Encrypt string (use with Decrypt)

function DecryptStr(const s:String) : String;
var
  I, x : integer;
begin
  Result := s;
  x := 5;
  for I := 1 to Length(s) do begin
    if Byte(s[I])=9 then continue; // don't decode TAB
    Result[I] := Char(Byte(s[I]) xor x);
  end;
end; // Decrypt Str (use with Encrypt)

// -------------------------+
function dEnCrypt(Str: string; Key: string): string;
var
  X, Y: integer;
  A: Byte;
begin
  if length(Str) > 0 then begin
    if Key = '' then Key := 'd1duOsy3n6qrPr2eF9u';
    Y := 1;
    for X := 1 to length(Str) do begin
      A := (ord(Str[X]) and $0F) //
      xor (ord(Key[Y]) and $0F);
      Str[X] := char((ord(Str[X]) and $F0) + A);
      inc(Y);
      if Y > length(Key) then Y := 1;
    end;
  end;
  Result := Str;
end; // toggle en/decryption


// -------------------------+
function ProperCase(S:String) : String;
var
  K : Integer;
  str : string;
begin
  // makes all words 1st char Uppercase
  if (s = '') then begin
    result:= s;
    exit;
  end;
  // delete all double spaces
  while (pos('  ',s) > 0) do
    delete(s,pos('  ',s),1);
  // get rid of all non-alpha chars, except spaces
  str := '';
  for k := 0 to Length(s) do begin
    if s[k] in ['A'..'z', '.', ' ', '''', '-'] then begin
      str := str + s[k];
    end;
  end;
  s := str;
  s := lowercase(s);
  S[1] := UpCase(S[1]);
  for K := 2 to Length(S) do begin
    // make all words 1st char Uppercase
    if S[K] = ' ' then S[K+1] := UpCase(S[K+1]);
    // make char after apostrophe uppercase - ex: O'Conner
    if S[K] = '''' then S[K+1] := UpCase(S[K+1]);
    // make char after hyphen uppercase - ex: O'Conner
    if S[K] = '-' then S[K+1] := UpCase(S[K+1]);
    // make char after Mc uppercase - ex: McDonald
    if (S[K-1] = 'M') and (S[K] = 'c') then S[K+1] := UpCase(S[K+1]);
    // fix for LLC
    if (S[K-1] = 'L') and (S[K] = 'l') and (s[k+1] = 'c') then begin
      S[K] := UpCase(S[K]);
      S[K+1] := UpCase(S[K+1]);
    end;
    // fix for III = the third
    if (S[K-1] = 'I') and (S[K] = 'i') and (s[k+1] = 'i') then begin
      S[K] := UpCase(S[K]);
      S[K+1] := UpCase(S[K+1]);
    end;
    // fix for II = the second
    if (S[K-1] = 'I') and (S[K] = 'i') and (K = length(s)) then begin
      S[K] := UpCase(S[K]);
    end;
  end;
  Result := S;
end;


function IsInt(s: string): boolean;
const
  MyNums : Array[0..9] of String = ('0','1','2','3','4','5','6','7','8','9');
var
  i: integer;
  c: string;
begin
  if Length(Trim(s)) = 0 then
    Exit(False);
    c := copy(s, 1, 1);
    if not ((c = '-') or StrUtils.MatchText(c, MyNums)) then Exit(False);
    for i := 2 to Length(s) do begin
      c := copy(s, i, 1);
      if not StrUtils.MatchText(c, MyNums) then Exit(False);
    end;
    Result := True;
end;


// ----------------------------------------------
// Verifies the following:
// 1) Date must be 10 characters
// 2) Positions 3 and 5 must be slash (/)
// 3) All other characters must be numeric
// So only returns true if date is in format
//  ##/##/####
// NOTE: Could make sure 0<mm<13 and 0<dd<32
// ----------------------------------------------
function IsLongDate(s: string): boolean;
var
  i: integer;
  c: string;
begin
  if (s = '') then begin
    Result := false;
    exit;
  end;
  if Length(s) = 10 then begin
    for i := 1 to 10 do begin
      c := copy(s, i, 1);
      if ((i = 3) or (i = 6)) then begin
        if (c <> '/') then begin
          Result := false;
          exit;
        end;
      end
      else if not IsInt(c) then begin
        Result := false;
        exit;
      end;
    end;
  end
  else begin
    Result := false;
    exit;
  end;
  Result := True;
end;


function IsFloat(s: string): boolean;
var
  MyNums: TStringList;
  i: integer;
  c: string;
begin
  if (s = '--') then begin
    Result := false;
    exit;
  end;
  MyNums := TStringList.Create;
  try
    MyNums.add('0');
    MyNums.add('1');
    MyNums.add('2');
    MyNums.add('3');
    MyNums.add('4');
    MyNums.add('5');
    MyNums.add('6');
    MyNums.add('7');
    MyNums.add('8');
    MyNums.add('9');
    MyNums.add('.');
    // fixed 2-27-02 for negative amount
    c := copy(s, 1, 1);
    if not((c = '-') or (MyNums.indexOf(c) > -1)) then begin
      Result := false;
      exit;
    end;
    for i := 2 to Length(s) do begin
      c := copy(s, i, 1);
      if MyNums.indexOf(c) = -1 then begin
        Result := false;
        exit;
      end;
    end;
    Result := True;
  finally
    MyNums.Free;
  end;
end;


Function UserDateToInternalDate(UserDate: String): String;
var
  temp: TDateTime;
begin
  if Length(UserDate) = 0 then
    Result := ''
  else begin
    temp := xStrToDate(UserDate, Settings.UserFmt);
    Result := DateToStr(temp, Settings.InternalFmt);
  end;
end;


Function UserTimeToInternalTime(UserTime: String; Make24Hr: boolean): String;
var
  temp: TDateTime;
  Hr, Mn, Sc, Msc: word;
  Hour, Min, Sec: String;
begin
  try
    if Length(UserTime) = 0 then
      Result := ''
    else if Make24Hr then begin
      DecodeTime(StrToTime(UserTime, Settings.UserFmt), Hr, Mn, Sc, Msc);
      Hour := IntToStr(Hr);
      Min := IntToStr(Mn);
      Sec := IntToStr(Sc);
      while Length(Hour) < 2 do
        Hour := '0' + Hour;
      while Length(Min) < 2 do
        Min := '0' + Min;
      while Length(Sec) < 2 do
        Sec := '0' + Sec;
      Result := Hour + Settings.InternalFmt.TimeSeparator + Min +
        Settings.InternalFmt.TimeSeparator + Sec;
    end
    else begin
      //If for some reason this blows up then let's just return zero length string for the time.
      temp := StrToTime(UserTime, Settings.UserFmt);
      Result := TimeToStr(temp, Settings.InternalFmt);
  end;
  except
    Result := ''
  end;
end;


function countTabs(s: string): integer;
var
  t: integer;
begin
  t := 0;
  while Pos(tab, s) > 0 do begin
    inc(t);
    delete(s, Pos(tab, s), 1);
  end;
  Result := t;
end;

function xStrToFloatEx(s: string; IsCurr: Boolean; Fmt: TFormatSettings): extended;
// Once we removed DP's extra fields in the TFormatSettings object the IsCurr
// Boolean parameter has become unnecessary. We have left it here so that we don't
// need to modify each line where this function is used.
var
  i: integer;
  OldSep, NewSep: string;
begin
  if s = '' then begin
    Result := 0;
    exit;
  end;
  if Pos('..', s) > 0 then delete(s, Pos('..', s), 1);
  OldSep := Fmt.DecimalSeparator;
  NewSep := Settings.UserFmt.DecimalSeparator;
  i := Pos(OldSep, s);
  if i > 0 then begin
    delete(s, i, Length(OldSep));
    Insert(NewSep, s, i);
  end;
  try
    Result := StrToFloat(s, Settings.UserFmt);
  except
    Result := 0;
  end;
end;


function LongDateStrEx(DateStr: String; InFmt, OutFmt: TFormatSettings): String;
var
  i, j, k, m: integer;
begin
  // Replace non-conforming '-' date separators
  if InFmt.DateSeparator <> '-' then
    while Pos('-', DateStr) > 0 do begin
      Insert(InFmt.DateSeparator, DateStr, Pos('-', DateStr));
      delete(DateStr, Pos('-', DateStr), 1);
    end;
  Result := US_DateStr(DateStr, InFmt);
  Result := DateToStr(xStrToDate(US_DateStrLong(Result), Settings.InternalFmt),
    OutFmt);
end;


function xStrToInt(s: string): integer;
begin
  if s = '' then
    Result := 0
  else
    Result := StrToInt(s);
end;


function GetLastErrorMessage(ErrorCode: integer): String;
var
  Buff: Array [0 .. 2048] of char;
  i: DWORD;
begin
  i := FormatMessage(FORMAT_MESSAGE_IGNORE_INSERTS +
      FORMAT_MESSAGE_FROM_SYSTEM, nil, ErrorCode,
    // requested message identifier
    0, Buff, 2024, Nil);
  if i > 0 then
    Result := 'ErrorCode: ' + IntToStr(ErrorCode) + ' - ' + Buff
  else
    Result := 'ErrorCode: ' + IntToStr(ErrorCode);
end;


// ------------------------------------
// Purpose: determine format of date
// only consider 3 possibilities:
// d/m/y, m/d/y, and y/m/d
// but / can also be - or even .
// ------------------------------------
function GetDateStrFmt(sDate : string): string;
var
  sDelim, s1, s2, s3 : string;
  i, j, y, m, d, v1, v2, v3, vMon : integer;
begin
  // initialize
  result := '?';
  vMon := 0;
  // look for delimiter first (support '/', '-', or '.')
  if pos('/', sDate)>1 then
    sDelim := '/'
  else if pos('-', sDate)>1 then
    sDelim := '-'
  else if pos('.', sDate)>1 then
    sDelim := '.'
  else if length(sDate) = 6 then begin
    sDate := copy(sDate, 1, 2) + '/' + copy(sDate, 3, 2) + '/' + copy(sDate, 5, 2);
    sDelim := '/';
  end
  else
    exit;
  // --------------
  // parse by delimiter - must be 3 segments!
  s2 := sDate;
  s1 := ParseFirst(s2, sDelim);
  if pos(sDelim, s2) < 2 then exit;
  s3 := ParseLast(s2, sDelim);
  if trim(s2) = '' then exit;
  // --------------
  // get values of 3 segments
  if (isnumeric(s1)=false) and (length(s1)=3) then begin
    vMon := 1;
    s1 := getExpMoNum(s1);
  end;
  v1 := StrToIntDef(s1, 0);
  if (isnumeric(s2)=false) and (length(s2)=3) then begin
    vMon := 2;
    s2 := getExpMoNum(s2);
  end;
  v2 := StrToIntDef(s2, 0);
  if (isnumeric(s3)=false) and (length(s3)=3) then begin
    vMon := 3;
    s3 := getExpMoNum(s3);
  end;
  v3 := StrToIntDef(s3, 0);
  // ----- 32/01/?? ----
  if (v1 > 31) and (v2 < 13) then begin
    result := 'ymd';
    exit;
  end;
  // ----- 13/01/?? ----
  if (v1 > 12) and (v2 < 13) then begin
    if (v3 > 31) then result := 'dmy'; // else leave ?
    exit;
  end;
  // ----- 01/13/?? ----
  if (v1 < 13) and (v2 > 12) then begin
    if (v2 < 32) then result := 'mdy';
    exit;
  end;
  // ----- 01/01/32 ----
  if (v1 < 13) and (v2 < 13) then begin
    if (v2 > 32) then result := 'not ymd';
    exit;
  end;
  // ----- use vMon -----
  if (result = '?') and (vMon > 0) then begin
    if (vMon = 1) and (v2 < 32) then result := 'mdy';
    if (vMon = 2) and (v1 > 31) then result := 'ymd';
    if (vMon = 2) and (v3 > 31) then result := 'dmy';
//    if (vMon = 2) and (result = '?') then result := '?m?';
  end;
end;


// Accepts ONLY Internal formatted string!
function xStrToDate(const s: string): TDateTime;
var
  DateOrdr: integer;
  t : string;
  Yr, Mo, Dy : word;
begin
  // convert string in m/d/yyyy, mm/dd/yyyy, etc. to TDate
  Result := xStrToDate(s, Settings.InternalFmt);
//  t := s;
//  Mo := StrToInt(parseFirst(t, '/'));
//  Yr := StrToInt(ParseLast(t, '/'));
//  Dy := StrToInt(t);
//  Result := EncodeDate(Yr, Mo, Dy);
end;


//Replace Month Name with Number also in Fmt.ShortDateFormat change format to numeric.
function ReplaceMonthName(const s : String; var Fmt : TFormatSettings) : String;
var
  i : Integer;
  // ------------------------
  Function TwoDigitMonth(Month: integer): String;
  begin
    Result := IntToStr(Month);
    if Length(Result) < 2 then
      Result := '0' + Result;
  end;
  // ------------------------
begin
  // First if the ShortMonthName or LongMonthName is in the current String then replace it
  // with the month number, Also replace the FormatString in the tempFmt variable to expect
  // a numeric format value rather than a short or long name. Start with LongDate format
  // As checking for Pos('MMM' when long date is set will also return > 0
  Result := s;
  if (Pos('MMMM', UpperCase(Fmt.ShortDateFormat)) > 0) then begin
    Fmt.ShortDateFormat := StringReplace(Fmt.ShortDateFormat, 'MMMM', 'MM', [rfIgnoreCase]);
    for i := 1 to Length(Fmt.LongMonthNames) do begin
      if Pos(UpperCase(Fmt.LongMonthNames[i]), UpperCase(S)) > 0 then begin
        Result := StringReplace(S, Fmt.LongMonthNames[i], TwoDigitMonth(i), [rfIgnoreCase]);
        break;
      end;
    end;
  end
  else if (Pos('MMM', UpperCase(Fmt.ShortDateFormat)) > 0) then begin
    Fmt.ShortDateFormat := StringReplace(Fmt.ShortDateFormat, 'MMM', 'MM', [rfIgnoreCase]);
    for i := 1 to Length(Fmt.ShortMonthNames) do begin
      if Pos(UpperCase(Fmt.ShortMonthNames[i]), UpperCase(S)) > 0 then begin
        Result := StringReplace(S, Fmt.ShortMonthNames[i], TwoDigitMonth(i), [rfIgnoreCase]);
        break;
      end;
    end;
  end;
end;


// --------------------------------------------------------
// Accepts both InternalFormatted and UserFormatted String
// Fmt variable must match for settings type of String.
function xStrToDate(const s: string; Fmt: TFormatSettings): TDateTime;
var
  dt: String;
  i: integer;
  tempFmt: TFormatSettings;
begin
  if s = '' then begin
    exit(2); // error trap + speed
  end;
  // --------------------------------------------
  // Special processing for textual month in dates. This works around an issue
  // with Delphi StrToDate function when the month format is short or long month names
  // Delphi SysUtils.StrToDate expects a number followed by the DateSeperator followed
  // by another number, so in the case of a format like dd-MMM-yyyy the second value
  // will be a shortMonthName not a number and this causes the StrToDate function to fail.
  tempFmt := Fmt;
  dt := ReplaceMonthName(S, tempFmt);
  // Next we will convert this date using the modified ShortDateFormat
  Result := StrToDate(dt, tempFmt);
end;


// ------------------------------------
// if in yyyy-mm-dd hh:mm:ss.uuu format
// ------------------------------------
function yyyymmddToUSDate(s : string): string; // to mm/dd/yyyy
var
  t : string;
begin
  s := StringReplace( s, '-', '', [rfReplaceAll]);
  if (s = 'null') or (s = '') then begin
    result := '';
    exit;
  end;
  if length(s) > 8 then s := LeftStr(s, 8);
  s := copy(s,5,2) + '/' + copy(s,7,2) + '/' + copy(s,1,4);
  result := s; // StrToDate(s);
end;


// --------------------------------------------------------
function CheckOptionFormat(Ticker : String) : Boolean;
var
  Value : String;
begin
  Result := False;
  // ----------------------------------
  // EXERCISED: If exercised on the end then get next field.
  Value := ParseLast(Ticker, ' ');
  if Trim(Value) = 'EXERCISED' then Value := ParseLast(Ticker, ' ');
  // ----------------------------------
  // CALL/PUT: If not call or put then exit with false.
  if (Value <> 'CALL') and (Value <> 'PUT') then exit;
  // stocks won't get past this! - 2015-12-04 MB
  // ----------------------------------
  // STRIKE PRICE: If Not Float then exit with False
  Value := ParseLast(Ticker, ' ');
  if Not IsFloat(Value) then exit;
  // ----------------------------------
  // OPTION EXPIRE DATE Valid formats ddMMMYY, dMMMYY, MMMYY.
  // If not in one of these then exit with false.
  Value := ParseLast(Ticker, ' ');
  if Not ValidExpDate(Value) then exit;
  // At this point we should have underlying ticker only.
  // There should be no spaces. IF there is a space now then it means that
  // possibly the Day and Month had a space between them.
  // Since MMMYY is a valid month format then the valieExpDate would not fail
  // but this will pick up where the Day number has a space after it.
  // ----------------------------------
  // 2015-12-04 MB we need this to catch invalid option tickers!
  if Pos(' ', Ticker) > 0 then exit;
  // ----------------------------------
  // STOCK TICKER: Cannot be blank, if so then exit with false.
  if Length(Trim(Ticker)) = 0 then exit;
  // ----------------------------------
  // Option Ticker is valid so return true.
  Result := True;
end;


function ValidExpDate(Value : String) : Boolean;
var
  M : String;
  D, Y : String;
  I : Integer;
  // ----------------------------------
  function ValidShortMonth(Value : String) : Boolean;
  var
      I: Integer;
  begin
    Result := False;
    for I := 1 to Length(Settings.InternalFmt.ShortMonthNames) do
      if UpperCase(Settings.InternalFmt.ShortMonthNames[I]) = UpperCase(Value)
      then begin
        Result := True;
        exit;
      end;
  end;
  // ----------------------------------
begin
  Result := False;
  if (Length(Value) < 5) or (Length(Value) > 7) then exit;
  if Length(Value) = 5 then begin
    D := '';
    M := Copy(Value, 1, 3);
    Y := Copy(Value, 4,2);
  end
  else if Length(Value) = 6 then begin
    D := '0' + Copy(Value, 1, 1);
    M := Copy(Value, 2, 3);
    Y := Copy(Value, 5, 2);
  end
  else begin
    D := Copy(Value, 1, 2);
    M := Copy(Value, 3, 3);
    Y := Copy(Value, 6, 2);
  end;
  //Check Month Short Name correct according to InternalFmt month names.
  if Not ValidShortMonth(M) then exit;
  //Check Day between 1 and 31
  if Length(D) > 0 then begin
    if D[1] = '0' then D := Copy(D, 2, 1);
    if Not IsInt(D) then exit;
    I := StrToInt(D);
    if (I < 1) or (I > 31) then exit;
  end;
  //Check year between 0 and 99.
  if Y[1] = '0' then Y := Copy(Y, 2, 1);
  if not IsInt(Y) then exit;
  I := StrToInt(Y);
  if (I < 0) or (I > 99) then exit;
  //If we got here then we are golden.
  Result := True;
end;


function ConvertExpDate(Value: String): TDateTime;
var
  Fmt : TFormatSettings;
  AdvanceToFriday : Boolean;
begin
  //change the ShortDateFormat to resemble the data we expect.
  Fmt := Settings.InternalFmt;
  Fmt.ShortDateFormat := 'dd-MMM-yy';
  Fmt.DateSeparator := '-';
  AdvanceToFriday := False;
  if Length(Value) = 5 then begin //Format must be MMMYY (ie Jan11, Feb10 etc).
    Value := '15' + Value; //The earliest in the month for the 3rd Friday is the 15th so start from here.
    AdvanceToFriday := True; //After we convert the date we will make sure it is on Friday.
  end
  else if Length(Value) = 6 then
    Value := '0' + Value
  else if Length(Value) <> 7 then
    raise EConvertError.Create('Invalid Date Format, Must be ''ddMMMyy''');
  // ----------------------------------
  //Since StrToDate requires a seperator give it one in position 3 and 7
  Insert('-', Value, 3);
  Insert('-', Value, 7);
  Result := xStrToDate(Value, fmt);
  if AdvanceToFriday then
    while (DayOfWeek(Result)) <> 6 do // If we are already on Friday then this while will be skipped.
      Result := Result + 1;
end;


function fracToDecStr(s:string):string;
var
  s2:string;
  f:double;
begin
  //change fractions to decimal
  s2:= parseFirst(s,'/');
  f:= strToInt(s2)/strToInt(s);
  s2:= floatToStr(f,Settings.InternalFmt);
  if leftStr(s2,1)='0' then delete(s2,1,1);
  result:= s2;
end;


function StrFmtToFloat(const Format: string; const Args: array of const ;
  const FormatSettings: TFormatSettings): extended;
var
  s: String;
begin
  s := '';
  FmtStr(s, Format, Args, FormatSettings);
  if not TextToFloat(PChar(s), Result, fvExtended, FormatSettings) then
    raise EConvertError.CreateResFmt(@SInvalidFloat, [s]);
end;


function FloatToStrFmt(const Format: string; const Args: array of const ;
  const FormatSettings: TFormatSettings): string;
var
  Buffer: array [0 .. 63] of char;
  s: String;
  Val: extended;
begin
  s := '';
  FmtStr(s, Format, Args, FormatSettings);
  if not TextToFloat(PChar(s), Val, fvExtended, FormatSettings) then
    raise EConvertError.CreateResFmt(@SInvalidFloat, [s]);
  SetString(Result, Buffer, FloatToText(Buffer, Val, fvExtended, ffGeneral, 15,
      0, FormatSettings));
end;


function GetLocInfo(Loc: integer; InfoType: Cardinal; Len: integer): string;
var
  Buff: PChar;
begin
  GetMem(Buff, Len);
  GetLocaleInfo(Loc, InfoType, Buff, Len);
  Result := Buff;
  FreeMem(Buff);
end;


function IsFloatEx(s: string; Fmt: TFormatSettings): boolean;
var
  MyNums: TStringList;
  i: integer;
  c: string;
begin
  if (s = '--') then begin
    Result := false;
    exit;
  end;
  MyNums := TStringList.Create;
  try
    MyNums.add('0');
    MyNums.add('1');
    MyNums.add('2');
    MyNums.add('3');
    MyNums.add('4');
    MyNums.add('5');
    MyNums.add('6');
    MyNums.add('7');
    MyNums.add('8');
    MyNums.add('9');
    MyNums.add(Fmt.DecimalSeparator);
    // fixed 2-27-02 for negative amount
    c := copy(s, 1, 1);
    if not((c = '-') or (MyNums.indexOf(c) > -1)) then begin
      Result := false;
      exit;
    end;
    for i := 2 to Length(s) do begin
      c := copy(s, i, 1);
      if MyNums.indexOf(c) = -1 then begin
        Result := false;
        exit;
      end;
    end;
    Result := True;
  finally
    MyNums.Free;
  end;
end;


// Returns DateStr in US Format
function US_DateStr(s: String; Fmt: TFormatSettings): String;
begin
  if Length(s) = 0 then begin
    Result := '';
    exit;
  end;
  If Pos('-', Fmt.DateSeparator) = 0 then
    while Pos('-', s) > 0 do begin
      Insert(Fmt.DateSeparator, s, Pos('-', s));
      delete(s, Pos('-', s), 1);
    end;
  Result := DateToStr(xStrToDate(s, Fmt), Settings.InternalFmt);
end;


// DateStr MUST be in US Format!
// Returns Long Date String in US Format
function US_DateStrLong(DateStr: string): string;
var
  DayStr, MoStr, YrStr: string;
begin
  // change date to dd/mm/yyyy
  DayStr := copy(DateStr, 1, Pos('/', DateStr) - 1); { get day }
  if Length(DayStr) = 1 then DayStr := '0' + DayStr;
  delete(DateStr, 1, Pos('/', DateStr));
  MoStr := copy(DateStr, 1, Pos('/', DateStr) - 1); { get month }
  if Length(MoStr) = 1 then MoStr := '0' + MoStr;
  delete(DateStr, 1, Pos('/', DateStr));
  YrStr := Trim(DateStr); { get year }
  if Length(YrStr) = 2 then
    if Pos('9', YrStr) = 1 then
      YrStr := '19' + YrStr
    else
      YrStr := '20' + YrStr;
  Result := DayStr + '/' + MoStr + '/' + YrStr;
end;


// ------------------------------------
//
// ------------------------------------
function ParseLast(var S : string; sep :string):string;
var
  T :string;
  i, p, x : Integer;
begin
  if S = '' then
    Result := '';
  p := length(S);
  x := length(sep);
  for i := p downto 1 do begin
    T := copy(S, i, x);
    if T = sep then begin
      p := i;
      break;
    end;
  end;
  if p = length(S) then
    Result := ''
  else
    Result := copy(S, p + 1, length(S)- p);
  S := copy(S, 1, p - 1);
end;


// ------------------------------------
//
// ------------------------------------
function ParseFirst(var S : string; sep :string):string;
var
  T : string;
  i, p : Integer;
begin
  if length(S) = 0 then begin
    Result := '';
    exit;
  end;
  p := length(S);
  for i := 1 to p do begin
    T := copy(S, i, 1);
    if T = sep then begin
      p := i - 1;
      break;
    end;
  end;
  // If all that is left is a sep character then clear and return.
  if (S = sep) then begin
    Result := '';
    S := '';
    exit;
  end;
  if p = length(S) then begin
    Result := S;
    S := '';
  end
  else begin
    Result := copy(S, 1, p);
    S := copy(S, p + 2);
  end;
end;


// ------------------------------------
//
// ------------------------------------
function parseBetween(var S : string; OpenTag, CloseTag :string): string;
var
  T : string;
begin
  result := s;
  T := ParseFirst(result, OpenTag);
  T := ParseLast(result, CloseTag);
end;

// ------------------------------------
//
// ------------------------------------
function parseWords(s:string; N:Integer): string;
var
  i : integer;
  sNew : string;
begin
  sNew := '';
  // parses a string into N number of words
  for i := 1 to N do begin
    sNew := sNew +' '+ parseFirst(s, ' ');
    //sm(sNew);
  end;
  result := trim(sNew);
end;


function RemoveParens(Value : String) : String;
var
  I : Integer;
begin
  Result := '';
  for I := 1 to Length(Value) do
    if not CharInSet(Value[I], ['(', ')']) then
      Result := Result + Value[I];
end;


function MakeMultiLine(Value : String; BreakOn : Integer) : String;
var
  Idx : Integer;
begin
  Result := Value;
  Idx := BreakOn;
  while (Idx < Length(Result)) do begin
    Idx := PosEx(' ', Value, Idx);
    if (Idx = 0) then Break;
    Insert(CRLF, Result, Idx);
    Idx := Idx +BreakOn
  end;
end;


function GetAppVersion : String;
var
  Size, Size2: DWord;
  Pt, Pt2: Pointer;
begin
  Size := GetFileVersionInfoSize(PChar (ParamStr (0)), Size2);
  if Size > 0 then begin
    GetMem (Pt, Size);
    try
      GetFileVersionInfo (PChar (ParamStr (0)), 0, Size, Pt);
      VerQueryValue (Pt, '\', Pt2, Size2);
      with TVSFixedFileInfo (Pt2^) do begin
        Result:= IntToStr (HiWord (dwFileVersionMS)) //
         + '.' + IntToStr (LoWord (dwFileVersionMS)) //
         + '.' + IntToStr (HiWord (dwFileVersionLS)) //
         + '.' + IntToStr (LoWord (dwFileVersionLS));
      end;
    finally
     FreeMem (Pt);
    end;
  end;
end;


function StripNonAlpha(s:string): string;
var
  i : integer;
  sNew : string;
begin
  sNew := '';
  for i := 1 to length(s) do begin
    if s[i] in ['a'..'z', 'A'..'Z', ' ', '-'] then begin
      sNew := sNew + s[i];
    end;
  end;
  result := sNew;
end;


function getStockTicker(sDesc : string; var foundTickList : TStringList) : boolean;
var
  s, sName, sTick, sDescrFound, lookupURL : string;
  bTickFound : boolean;
  // ------------------------
  procedure addTicker(sDescrFound, sTick : string);
  begin
    // remove dash from ticker
    delete(sTick, pos('-',sTick), 1);
    if (sTick <> '') and (sDescrFound <> '') and isTickerSymbol(sTick) then begin
      if (foundTickList.IndexOf(sDescrFound + ' | ' + sTick) = -1) then begin
        foundTickList.add(sDescrFound + ' | ' + sTick);
        bTickFound := true;
      end;
    end;
  end;
  // ------------------------
begin
  bTickFound := false;
  sTick := '';
  sDescrFound := '';
  result := false;
  sDesc := StripNonAlpha(sDesc);
  sName := TradeLogFile.CurrentAccount.OFXUserName;
  if sName = '' then sName := 'mark';
  sTick := GetTickerSymbol(sDesc);
  if (pos('ERR', sTick)=1) then exit(false);
  if (sTick <> '') //
  and (length(sTick) < 5) then begin //
    sDescrFound := sDesc; //
    addTicker(sDescrFound, sTick); //
  end;
  result := bTickFound;
  //if foundTickList.Count > 0 then result := true;
end;


function formatTkSort(tk,typeMult,acctType:string) : string;
var
  yrMoDa,day,mon,yr,strike,callPut,exchange:string;
begin
  if acctType <> '' then acctType := '-' + acctType;
  //format options
  if pos('OPT-',typeMult)>0 then begin
    if pos(' EXERCISED',tk)>0 then delete(tk,pos(' EXERCISED',tk),10);
    if (pos(' CALL',tk)>0) or (pos(' PUT',tk)>0) then begin
      callPut:= parselast(tk,' ');
      strike := parselast(tk,' ');
      if pos('/',strike)>0 then strike:= parselast(tk,' ')+strike;
      yrMoDa  := parselast(tk,' ');
      if length(yrMoDa)=7 then begin
        yr:= copy(yrMoDa,6,2);
        day:= copy(yrMoDa,1,2);
        mon:= getExpMoNum(copy(yrMoDa,3,3));
        yrMoDa:= yr+mon+day;
        //sm(yrMoDa);
      end
      else
        yrMoDa:= copy(yrMoDa,4,2)+getExpMoNum(copy(yrMoDa,1,3));
      //sm(tk+yrMoDa+strike+callPut);
      result:= tk+acctType+yrMoDa;
    end
    else begin
      result:= tk+acctType+yrMoDa;
    end;
  end
  //format futures
  else if (pos('FUT-',typeMult)>0) then begin
    if (pos(' CALL',tk)>0) or (pos(' PUT',tk)>0) then begin
      callPut:= parselast(tk,' ');
      strike := parselast(tk,' ');
      yrMoDa  := parselast(tk,' ');
      if length(yrMoDa)=7 then
        yrMoDa:= copy(yrMoDa,6,2)+getExpMoNum(copy(yrMoDa,3,3))
      else
        yrMoDa:= copy(yrMoDa,4,2)+getExpMoNum(copy(yrMoDa,1,3));
      //sm(tk+yrMoDa+strike+callPut);
      result:= tk+yrMoDa;//+strike+callPut;
    end
    else begin
      //check if future symbol has a space
      if (pos(' ',tk)=0) then begin
        result:=tk;
        exit;
      end;
      exchange:= parselast(tk,' ');
      //test for exchange
      if isFloatEx(copy(exchange,4,2),Settings.UserFmt) then begin
        yrMoDa:= exchange;
        exchange:='';
      end
      else
        yrMoDa  := parselast(tk,' ');
      yrMoDa:= copy(yrMoDa,4,2)+getExpMoNum(copy(yrMoDa,1,3));
      //sm(tk+yrMoDa+exchange);
      result:= tk+yrMoDa+exchange;
    end;
  end
  //format single-stock futures
  else if pos('SSF-',typeMult)>0 then begin
      //test for (STK)
      exchange:= copy(tk,1,pos(' (',tk)-1);
      if exchange<>'' then tk:= exchange;
      yrMoDa:= parseLast(tk,' ');
      if length(yrMoDa)=7 then
        yrMoDa:= copy(yrMoDa,6,2)+getExpMoNum(copy(yrMoDa,3,3))
      else
        yrMoDa:= copy(yrMoDa,4,2)+getExpMoNum(copy(yrMoDa,1,3));
      //sm(tk+yrMoDa);
      result:= tk+yrMoDa;
  end
  else
    result:=tk+acctType;
end;


function getExpMoNum(s: string): string;
begin
  if s = 'JAN' then      Result := '01' //
  else if s = 'FEB' then Result := '02' //
  else if s = 'MAR' then Result := '03' //
  else if s = 'APR' then Result := '04' //
  else if s = 'MAY' then Result := '05' //
  else if s = 'JUN' then Result := '06' //
  else if s = 'JUL' then Result := '07' //
  else if s = 'AUG' then Result := '08' //
  else if s = 'SEP' then Result := '09' //
  else if s = 'OCT' then Result := '10' //
  else if s = 'NOV' then Result := '11' //
  else if s = 'DEC' then Result := '12';
end;


function getExpMo(s: string): string;
begin
  if s = '01' then      Result := 'JAN' //
  else if s = '02' then Result := 'FEB' //
  else if s = '03' then Result := 'MAR' //
  else if s = '04' then Result := 'APR' //
  else if s = '05' then Result := 'MAY' //
  else if s = '06' then Result := 'JUN' //
  else if s = '07' then Result := 'JUL' //
  else if s = '08' then Result := 'AUG' //
  else if s = '09' then Result := 'SEP' //
  else if s = '10' then Result := 'OCT' //
  else if s = '11' then Result := 'NOV' //
  else if s = '12' then Result := 'DEC';
end;


function GetAccountTypeAsChar(AcctType : TTLAccountType) : Char;
begin
  Result := ' ';
  case AcctType of
    atCash: Result := 'C';
    atIRA:  Result := 'I';
    atMTM:  Result := 'M';
  end;
end;


function OccurrencesOfChar(const S: string; const C: char): integer;
var
  i: Integer;
begin
  result := 0;
  for i := 1 to Length(S) do begin
    if S[i] = C then inc(result);
  end;
end;


function settlementStartDate(lastDayOfYear:TDate):TDate;
var
  i, x, y : integer;
begin
  if lastDayOfYear > EncodeDate(2024,05,28) then
    y := 1 // 2024-06-04 MB - new IRS guideline
  else if lastDayOfYear > EncodeDate(2017,09,05) then
    y := 2 // 2018-03-28 MB - new IRS guideline
  else
    y := 3; // old rule: settle in 3 days
  x := 0;
  // get last trading day which will settle in calendar year
  for i := 0 to 4 do begin
    if (dayOfWeek(lastDayOfYear - i) <> 7)
    and (dayOfWeek(lastDayOfYear - i) <> 1) then
      inc(x);
    if (x = y) then begin
      result :=  lastDayOfYear - i;
      break;
    end;
  end;
end;


function replaceUnderlying(s, sUnderlying:string): string;
var
  i, c : integer;
  sBalOfOptionSymbol : string;
begin
  // "JC PENNEY CO INC 21SEP13 13 PUT" becomes "JCP 21SEP13 13 PUT"
  s := trim(s);
  c := countOfChar(' ', s);
  for i := 0 to c - 3 do
    delete(s, 1, pos(' ', s));
  result := sUnderlying +' '+ s;
end;


function parseUnderlying(s:string): string;
var
  i, c : integer;
  sUnder : string;
begin
  // ie: MSFT 18JAN15 45 CALL
  // ie: Microsoft Corporation 18JAN15 45 CALL
  sUnder := '';
  s := trim(s);
  // get rid of " EXERCISED"
  if (pos(' EXERCISED',  s) > 0) then begin
    delete(s, pos(' EXERCISED', s), 10);
  end;
  c := countOfChar(' ', s);
  for i := 0 to c - 3 do
    sUnder := sUnder +' '+ parseFirst(s, ' ');
  result := trim(sUnder);
end;


function isTickerSymbol(s:string): boolean;
begin
  // valid tickers are only 5 chars or less - ie: MSFT
  // or 7 chars or less with a period  - ie: COVD.EX
  if ( (pos('.',s) > 0) and (length(s) <= 7) )
  or ( (pos('.',s) = 0) and (length(s) <= 5) )
  then
    result := true
  else
    result := false;
end;


function findTicksWithStockDescr(bImporting:Boolean): TStringList;
var
  i : integer;
  sDesc : string;
  tickList : TStringList;
  isDesc : boolean;
begin
  tickList := TStringList.Create;
  tickList.clear;
  for i := 0 to TradeLogFile.count - 1 do begin
    isDesc := false;
    // do not check other accounts if importing
    if bImporting and (TradeLogFile.CurrentBrokerID <> TradeLogFile[i].broker)
    then continue;
    // get stock description (or ticker) from stocks and options
    if IsStockType(TradeLogFile[i].TypeMult) then
      sDesc := copy(TradeLogFile[i].Ticker, 1, 40) // 2019-02-06 MB - change per Jason
      // used to be: parseWords(TradeLogFile[i].Ticker, 4) // first 4 words only
    else if isOption(TradeLogFile[i].TypeMult, TradeLogFile[i].Ticker, false)
    then begin
      // parse underlying
      sDesc := parseUnderlying(TradeLogFile[i].Ticker);
    end;
    // skip if cusip    SOME DESCRIPTIONS END IN NUMBERS ??? ARRGGGHHHH
    //if (isInt(rightStr(sDesc, 3))) then continue;
    // description string test
    if not isTickerSymbol(sDesc) and (tickList.IndexOf(sDesc) = - 1) then
      tickList.Add(sDesc);
  end;
  result := tickList;
end;


function IsNumber(str: string): Boolean;
begin
  result := isNumeric(str);
end;

function IsDate(str: string): Boolean;
var
  dt: TDateTime;
begin
  if str = '' then exit(false);
  try
    dt := StrToDateDef(str, 1/1/1900);
    if dt <= 1/1/1900 then // 2020-10-21 MB - changed from = to <=
      result := false
    else
      result := true; // 2020-10-21 MB - made true result explicit
  except
    result := False;
  end;
end;

function IsInDateRange(sTestDate, sDate1, sDate2: string): boolean;
var
  dtTst, dt1, dt2: TDate;
begin
  result := false;
  if not IsDate(sTestDate) then exit;
  if not IsDate(sDate1) then exit;
  if not IsDate(sDate2) then exit;
  dtTst := StrToDate(sTestDate);
  dt1 := StrToDate(sDate1);
  dt2 := StrToDate(sDate2);
  if (dtTst < dt1) or (dtTst > dt2) then exit;
  result := true;
end;


initialization
//rj   Logger := TCodeSite//rj Logger.Create(nil);
  //rj Logger.Category := CODE_SITE_CATEGORY;
//rj   TLLoggers.RegisterLogger(CODE_SITE_CATEGORY, Logger);
end.
