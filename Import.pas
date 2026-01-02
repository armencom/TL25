unit Import;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, Math,
  StdCtrls, ExtCtrls, ComCtrls, OleCtrls, Buttons, StrUtils, CommDlg, ComObj,
  IdGlobal, // needed to use function IsNumberic(str)
  TLFile;

// --------------------------
// misc parsing functions
// --------------------------

function monNum(s : string): string;
function numToMon(monNum :string):string;
function changeFutMult(Trades : TTradeList; bAdjContr : boolean = false): boolean;

function delLeadingZeros(s : string) : string;
function delTrailingZeros(s : string): string;

function ParseLastN(var s : string; sep : string): string;

function ValidTradeDate(ImportDate : string; LastTradeDate : string;
  var NextDateOn : boolean): boolean;
procedure GetImpDateLast;
function LongDateStr(DateStr : string): string;

procedure GetImpStrListFromWebGet(PasteRecs : boolean);
procedure GetImpStrListFromClip(PasteRecs : boolean);
procedure GetImpStrListFromFile(format, ext, FileName : string);
function GetStrFromFile(format, ext : string): string;

procedure ReverseImpTradesDate(R : integer);

procedure SortImpByDate(R : integer);
procedure SortImpByDateOC(b, e : integer);
//procedure SortImpByDateOCNEW(b, e : integer);

function AssignShortSell : boolean;
function AssignShortBuy : boolean;

procedure CheckForDataConvertErr;

procedure ForceMatchTrades;

// function BrokerHasTimeOfDay:boolean;  //This function is never called

function isFutureOpt(tick : string): boolean;

function futuresMult(s, prf : string; BrokerID : integer): string;
function futures_index(tick : string): string;

function futuresMult_IB(tick : string): double;
//function futures_IB(tick : string): boolean;

//function futuresMonth(m : string): string;
function formatFut(s : string): string;
function formatTime(tmStr : string): string;

// function formatRJTopt(tick, dtStr: string; expOption: boolean): string;
// still used by ReadSLK, but backward reference only, no need for prototype

//procedure SaveStrToFile(const FileName : TFileName; const content : string);
procedure fixImpTradesOutOfOrder(R : integer);

// --------------------------
// Import Filter Read Methods
// --------------------------

function ReadAllyInvest(): integer;
function ReadAmeritrade(): integer;
function ReadAssent(): integer;

function ReadBOA(): integer;

function ReadCenterPoint(): integer;
function ReadCobra(): integer;
function ReadCurvature(): integer;

function ReadeRegal(): integer;

function ReadETrade(): integer;
function ReadExcel(bFromGrid : boolean = false): integer;

function ReadFidelity(): integer;
function ReadFolioFN(): integer;

function ReadGlobex(): integer;
function ReadGoldmanSachs(): integer;

function ReadHarris(): integer;
function ReadHilltop(): integer;

function ReadIB(): integer;
function ReadInvestrade(): integer;

function readJPMorganChase(): integer;
function ReadJPR(): integer;

function ReadLightspeed(): integer;

function ReadManualEntry(bFromGrid : boolean = false): integer;
function ReadMorganStanley(): integer;

function readNinja(): integer;

function ReadOpenECry(): integer;

function ReadPaste(): integer;
function ReadPenson(): integer;
function ReadPershing(): integer;
function ReadPreferred(): integer;
function ReadProTrader(): integer;

function ReadQFX(): integer;
function ReadQIF(): integer;

function ReadRobinhood(): integer;
function ReadRydexRFS(): integer;

function ReadSchwab(): integer;
function ReadScottrade(): integer;
function ReadSLK(): integer;
function ReadSLKcsv(): integer;
function ReadSLKweb(): integer;
function ReadSWS(): integer;

function Readtastyworks(): integer;
function ReadTerra(): integer;
function ReadTOS(): integer;
function ReadTradeMonsterCSV(ImpStrList : TStringList): integer;
function ReadTradeMonster(): integer;
function ReadTradeStation(): integer;
function ReadTradeZero(): integer;
function ReadTRowe(): integer;

function ReadUNX(): integer;

function ReadVanguard(): integer;
function ReadVision(): integer;

function ReadPassiv(): integer;

//procedure readTXF;


// --- Main import handlers -----------
procedure FileImport(PasteRecs : boolean; Baseline : boolean = false);
procedure BCImport();

var
  BrownCo, ETProSWS, Penson2, bApexActivity, bMBTrading : boolean;
  glNumCancelledTrades, LastI, optAssign : integer;
  Reordering, TDWyearend, TDWmonthly, delRecNoSave, EtradeXLS, etradeHist : boolean;
  changedFuturesList : TList;
  ImpStrList : TStringList; // many routines assume access to this.
  OFXDateStart, OFXDateEnd : TDateTime;
//  OFXFile : string;

  // from FileImport
  impTicksList : TStringList;
  FutureWarning, bFileSaved : boolean;
  msgImp : string; // used for import messages

  // misc import global variables
  ImpTradesList : TList;
  ImportHasCusips, ImportHasDescr : boolean;
  ImpDateLast, DataConvErrRec, sFileType, sImpMethod : string;
  DataConvErrCnt : integer;

implementation

uses
  FuncProc, Main, RecordClasses, ClipBrd, //
  TLRegister, dateUtils, editSplit, frmOFX, //
  WebGet, Web, importCSV, webImport, OpenTrades, //
  DataConvError, TLSettings, TLCommonLib, //
  TLImportFilters, TLImportReadMethods, TLLogging, TLDateUtils, //
  TL_Passiv, // used by GetListPassivTransactions
  dlgImport, // dlgBrokenImport,
  ShellAPI, //
  MessageDlg, Baseline, baseline1, GlobalVariables;

type
  TSplit = record
    dte : string;
    tick : string[9];
    split : double;
  end;

const
  CODE_SITE_CATEGORY = 'Import';
  CODE_SITE_DETAIL_CATEGORY = 'Import-Detail';
  CRC_XLS2CSV = 166227868;

var
  MMTrNum, NumConverted, CorrectedTrades : integer;
  MMwashShOpen : double;
  Splits : array [1 .. 9999] of TSplit;
  msg, DataConvErrStr : string;
  ErrLog : textfile;
  Etrade1099, EtradeCSV : boolean;
  openTrList : array of TTradesOpen;
  TSweb : boolean;
//  isOFX,
  bcImp : boolean;
  Shares, Amt, Price : double;
  ClipTxt, tick, dte : string;
//  OFXImport : TTLImport;


function numToMon(monNum :string):string;
begin
  if monNum = '01' then result := 'JAN'
  else if monNum = '02' then result := 'FEB'
  else if monNum = '03' then result := 'MAR'
  else if monNum = '04' then result := 'APR'
  else if monNum = '05' then result := 'MAY'
  else if monNum = '06' then result := 'JUN'
  else if monNum = '07' then result := 'JUL'
  else if monNum = '08' then result := 'AUG'
  else if monNum = '09' then result := 'SEP'
  else if monNum = '10' then result := 'OCT'
  else if monNum = '11' then result := 'NOV'
  else if monNum = '12' then result := 'DEC';
end;

function NextUserDateStr(InDateStr : string): string;
begin
  result := DateToStr(xStrToDate(InDateStr, Settings.InternalFmt) + 1, Settings.InternalFmt);
end;

function isDateGreater(TestDate, CompareDate : string): boolean;
begin
  result := xStrToDate(TestDate, Settings.InternalFmt) > xStrToDate(CompareDate,
    Settings.InternalFmt);
end;


// ------------------------------------
// ------------------------------------
function MinFromDate(dtFrom, dtLastImp : TDate): string;
begin
  result := 'error'; // assume no good until proven good
  dtBegTaxYr := xStrToDate('01/01/' + TaxYear, Settings.InternalFmt);
  dtEndTaxYr := xStrToDate('12/31/' + TaxYear, Settings.InternalFmt);
  // ------------------------
  if (dtLastImp + 1) < dtBegTaxYr then
    dtFrom := dtBegTaxYr
  else
    dtFrom := (dtLastImp + 1);
  // ------------------------
  NextTaxYear := IntToStr(strToInt(TaxYear) + 1);
  dtJan31NY := xStrToDate('01/31/' + NextTaxYear, Settings.InternalFmt);
  if (dtLastImp > dtJan31NY) then exit; // it's an error
  result := DateToStr(dtFrom, Settings.InternalFmt);
end;

// ------------------------------------
// ------------------------------------
function MaxToDate(dtTo, dtLastImp : TDate): string;
begin
  result := 'error'; // assume no good until proven good
  if (dtTo < dtLastImp) then
    dtTo := dtLastImp + 1;
  if (dtTo >= Today) then exit; // can't import past yesterday
  // ------------------------
  dtBegTaxYr := xStrToDate('01/01/' + TaxYear, Settings.InternalFmt);
  dtEndTaxYr := xStrToDate('12/31/' + TaxYear, Settings.InternalFmt);
  // ------------------------
  NextTaxYear := IntToStr(strToInt(TaxYear) + 1);
  dtOct16NY := xStrToDate('10/16/' + NextTaxYear, Settings.InternalFmt);
  if (dtLastImp > dtJan31NY) then exit; // it's an error
  result := DateToStr(dtTo, Settings.InternalFmt);
end;


// ------------------------------------
// Is it valid to import this date?
// ------------------------------------
function ValidTradeDate(ImportDate : string; LastTradeDate : string; var NextDateOn : boolean)
  : boolean;
var
  NextDate : string;
begin
  if ImpBaseline then begin
    result := true;
    exit;
  end;
  if isDateGreater(ImportDate, LastTradeDate) then begin
    // If the ImportDate is greater then the LastTradeDate, the record is valid
    result := true;
    exit;
  end
  else if NextDateOn then begin
    // If we have already queried the user and the date <= the lastTradeDate,
    // it's NOT a valid record so return false.
    result := false;
    exit;
  end
  else begin
    // If we got here then it means that the ImportDate <= the LastTradeDate
    // and we have never asked the user if we should import these trades or not,
    // so lets ask them...
    NextDate := NextUserDateStr(ImpDateLast);
    if mDlg('Trades already imported up to ' + ImpDateLast + cr + cr //
      + 'Do you wish to import from ' + NextDate + ' onward?' + cr + cr //
      + 'Click YES to skip all trades prior to ' + NextDate + cr + cr //
      + 'Click NO to import all of the dates on this page', mtWarning, [mbNo, mbYes], 0) = mrYes
    then begin
      // If they say YES then we will set a flag to short circuit this method
      // for all trades that are less than the last trade date returning false.
      // Also their affirmative answer makes this current record invalid so return false.
      NextDateOn := true;
      result := false;
    end
    else begin
      // If they say NO then just set the GlobalImpDateLast to some date way
      // in the past so that all records are considered valid. Of course,
      // that includes this record so return true.
      ImpDateLast := '01/01/1900';
      result := true;
    end;
  end;
end;

// converts 1 digit day/mo to 2 digits and 2 digit yr to 4 digit
function LongDateStr(DateStr : string): string;
var
  DayStr, MoStr, YrStr : string;
begin
  while pos('-', DateStr) > 0 do begin
    insert('/', DateStr, pos('-', DateStr));
    delete(DateStr, pos('-', DateStr), 1);
  end;
  // change date from d/m/yy to dd/mm/yyyy
  DayStr := copy(DateStr, 1, pos('/', DateStr) - 1); { get day }
  if length(DayStr) = 1 then
    DayStr := '0' + DayStr;
  delete(DateStr, 1, pos('/', DateStr));
  MoStr := copy(DateStr, 1, pos('/', DateStr) - 1); { get month }
  if length(MoStr) = 1 then
    MoStr := '0' + MoStr;
  delete(DateStr, 1, pos('/', DateStr));
  YrStr := trim(DateStr); { get year }
  if length(YrStr) = 2 then
    if pos('9', YrStr) = 1 then
      YrStr := '19' + YrStr
    else
      YrStr := '20' + YrStr;
  result := DayStr + '/' + MoStr + '/' + YrStr;
end;

function MMMtoMM(s : string): string;
begin
  if s = 'JAN' then result := '01'
  else if s = 'FEB' then result := '02'
  else if s = 'MAR' then result := '03'
  else if s = 'APR' then result := '04'
  else if s = 'MAY' then result := '05'
  else if s = 'JUN' then result := '06'
  else if s = 'JUL' then result := '07'
  else if s = 'AUG' then result := '08'
  else if s = 'SEP' then result := '09'
  else if s = 'OCT' then result := '10'
  else if s = 'NOV' then result := '11'
  else if s = 'DEC' then result := '12'
  else result := '00';
end;

function dateDDMMMYY(DateStr : string): string;
var
  dd, mm, mmm, yyyy : string;
begin
  // dd-mmm-yy format  ie: 5-Apr-11
  if (pos('-', DateStr) = 0) then begin
    result := 'invalid';
    exit;
  end;
  dd := copy(DateStr, 1, pos('-', DateStr) - 1);
  if length(dd) = 1 then
    dd := '0' + dd;
  delete(DateStr, 1, pos('-', DateStr));
  mmm := uppercase(copy(DateStr, 1, pos('-', DateStr) - 1));
  mm := MMMtoMM(mmm);
  yyyy := parseLast(DateStr, '-');
  // test for 2 or 4 digit year
  if length(yyyy) = 2 then
    DateStr := mm + '/' + dd + '/20' + yyyy
  else
    DateStr := mm + '/' + dd + '/' + yyyy;
  result := DateStr;
end;

// ------------------------------------
//
// ------------------------------------
//function remQuotes(s : string): string;
//var
//  pQopen, pQclose, pComma : integer;
//  str : string;
//begin
//  if pos('"', s) = 0 then begin
//    result := s;
//    exit;
//  end;
//  while pos('"', s) > 0 do begin
//    pQopen := pos('"', s);
//    delete(s, pQopen, 1);
//    pQclose := pos('"', s);
//    delete(s, pQclose, 1);
//    str := copy(s, pQopen, pQclose - pQopen);
//    // sm(str);
//    pComma := pos(',', str);
//    if pComma > 0 then
//      delete(s, pQopen + pComma - 1, 1);
//    result := s;
//  end;
//end;

function delLeadingZeros(s : string) : string;
var
  i, n : integer;
begin
  // remove leading zeros from string
  s := trim(s);
  while (length(s) > 0) and (leftStr(s, 1) = '0') do
    delete(s, 1, 1);
  if (leftStr(s, 1) = '.') then s := '0' + s;
  result := s;
end;

function delTrailingZeros(s : string): string;
begin
  // remove trailing zeros from string
  s := trim(s);
  while (pos('.', s) > 0) and (rightStr(s, 1) = '0') do
    delete(s, length(s), 1);
  if (rightStr(s, 1) = '.') then
    delete(s, length(s), 1);
  result := s;
end;

// ------------------------------------
function monPos(var s : string): integer;
begin
  s := uppercase(s);
  if (pos('JAN', s) > 0) then result := pos(' JAN', s) + 1
  else if (pos('FEB', s) > 0) then result := pos(' FEB', s) + 1
  else if (pos('MAR', s) > 0) then result := pos(' MAR', s) + 1
  else if (pos('APR', s) > 0) then result := pos(' APR', s) + 1
  else if (pos('MAY', s) > 0) then result := pos(' MAY', s) + 1
  else if (pos('JUN', s) > 0) then result := pos(' JUN', s) + 1
  else if (pos('JUL', s) > 0) then result := pos(' JUL', s) + 1
  else if (pos('AUG', s) > 0) then result := pos(' AUG', s) + 1
  else if (pos('SEP', s) > 0) then result := pos(' SEP', s) + 1
  else if (pos('OCT', s) > 0) then result := pos(' OCT', s) + 1
  else if (pos('NOV', s) > 0) then result := pos(' NOV', s) + 1
  else if (pos('DEC', s) > 0) then result := pos(' DEC', s) + 1
  else result := 0;
end;


function chgOptExpYr(opStr, dStr : string): string;
var
  p, y : integer;
  oMon, oYr : string;
  expdate : TDate;
begin
  // sm(opStr+cr+dStr);
  // get option month and year
  p := monPos(opStr);
  oMon := copy(opStr, p, 3);
  oYr := copy(opStr, p + 3, 2);
  // sm(oMon+cr+oYr);
  try
    expdate := getOptExpDate(oMon, oYr);
    if (xStrToDate(dStr, Settings.UserFmt) > expdate) then begin
      // increment year
      y := strToInt(oYr);
      inc(y);
      oYr := IntToStr(y);
      if length(oYr) = 1 then
        oYr := '0' + oYr;
      opStr := copy(opStr, 1, p + 2) + oYr + rightStr(opStr, length(opStr) - p - 4);
    end;
    // sm(opStr);
    result := opStr;
  except
  end;
end;


function monNum(s : string): string;
begin
  s := uppercase(s);
  if (s = 'JAN') then result := '01'
  else if (s = 'FEB') then result := '02'
  else if (s = 'MAR') then result := '03'
  else if (s = 'APR') then result := '04'
  else if (s = 'MAY') then result := '05'
  else if (s = 'JUN') then result := '06'
  else if (s = 'JUL') then result := '07'
  else if (s = 'AUG') then result := '08'
  else if (s = 'SEP') then result := '09'
  else if (s = 'OCT') then result := '10'
  else if (s = 'NOV') then result := '11'
  else if (s = 'DEC') then result := '12';
end;

function monYrSpacePos(var s : string): integer;
begin
  s := uppercase(s);
  if (pos('JAN ', s) > 0) then result := pos('JAN ', s)
  else if (pos('FEB ', s) > 0) then result := pos('FEB ', s)
  else if (pos('MAR ', s) > 0) then result := pos('MAR ', s)
  else if (pos('APR ', s) > 0) then result := pos('APR ', s)
  else if (pos('MAY ', s) > 0) then result := pos('MAY ', s)
  else if (pos('JUN ', s) > 0) then result := pos('JUN ', s)
  else if (pos('JUL ', s) > 0) then result := pos('JUL ', s)
  else if (pos('AUG ', s) > 0) then result := pos('AUG ', s)
  else if (pos('SEP ', s) > 0) then result := pos('SEP ', s)
  else if (pos('OCT ', s) > 0) then result := pos('OCT ', s)
  else if (pos('NOV ', s) > 0) then result := pos('NOV ', s)
  else if (pos('DEC ', s) > 0) then result := pos('DEC ', s)
  else result := 0;
end;


function monYrSpaceDel(var s : string): string;
begin
  s := uppercase(s);
  if (pos('JAN ', s) > 0) then
    result := copy(s, 1, pos('JAN ', s) - 1) + 'JAN' + copy(s, pos('JAN ', s) + 4,
      length(s) - pos('JAN ', s) + 2)
  else if (pos('FEB ', s) > 0) then
    result := copy(s, 1, pos('FEB ', s) - 1) + 'FEB' + copy(s, pos('FEB ', s) + 4,
      length(s) - pos('FEB ', s) + 2)
  else if (pos('MAR ', s) > 0) then
    result := copy(s, 1, pos('MAR ', s) - 1) + 'MAR' + copy(s, pos('MAR ', s) + 4,
      length(s) - pos('MAR ', s) + 2)
  else if (pos('APR ', s) > 0) then
    result := copy(s, 1, pos('APR ', s) - 1) + 'APR' + copy(s, pos('APR ', s) + 4,
      length(s) - pos('APR ', s) + 2)
  else if (pos('MAY ', s) > 0) then
    result := copy(s, 1, pos('MAY ', s) - 1) + 'MAY' + copy(s, pos('MAY ', s) + 4,
      length(s) - pos('MAY ', s) + 2)
  else if (pos('JUN ', s) > 0) then
    result := copy(s, 1, pos('JUN ', s) - 1) + 'JUN' + copy(s, pos('JUN ', s) + 4,
      length(s) - pos('JUN ', s) + 2)
  else if (pos('JUL ', s) > 0) then
    result := copy(s, 1, pos('JUL ', s) - 1) + 'JUL' + copy(s, pos('JUL ', s) + 4,
      length(s) - pos('JUL ', s) + 2)
  else if (pos('AUG ', s) > 0) then
    result := copy(s, 1, pos('AUG ', s) - 1) + 'AUG' + copy(s, pos('AUG ', s) + 4,
      length(s) - pos('AUG ', s) + 2)
  else if (pos('SEP ', s) > 0) then
    result := copy(s, 1, pos('SEP ', s) - 1) + 'SEP' + copy(s, pos('SEP ', s) + 4,
      length(s) - pos('SEP ', s) + 2)
  else if (pos('OCT ', s) > 0) then
    result := copy(s, 1, pos('OCT ', s) - 1) + 'OCT' + copy(s, pos('OCT ', s) + 4,
      length(s) - pos('OCT ', s) + 2)
  else if (pos('NOV ', s) > 0) then
    result := copy(s, 1, pos('NOV ', s) - 1) + 'NOV' + copy(s, pos('NOV ', s) + 4,
      length(s) - pos('NOV ', s) + 2)
  else if (pos('DEC ', s) > 0) then
    result := copy(s, 1, pos('DEC ', s) - 1) + 'DEC' + copy(s, pos('DEC ', s) + 4,
      length(s) - pos('DEC ', s) + 2)
  else
    result := s;
end;


// ------------------------------------
//
// ------------------------------------
procedure FixPrCmAmt(var pr, cm, Amt : double; BuySell, Fix : string);
begin
  if Fix = 'p' then begin
    // fix price
  end
  else if Fix = 'c' then begin
    // fix commission
  end
  else if Fix = 'a' then begin
    // fix amount
  end
  else begin
    // error?
  end;
end;


// ------------------------------------
// Uses Length of Sep instead of one to get T
// ------------------------------------
function ParseLastN(var s : string; sep : string): string;
var
  t : string;
  i, p : integer;
begin
  if s = '' then result := '';
  // copy string up to cr
  p := length(s);
  for i := p downto 1 do begin
    t := copy(s, i, length(sep));
    if t = sep then begin
      p := i;
      break;
    end;
  end;
  if (p = length(s)) then
    result := ''
  else begin
    result := copy(s, p + 1, length(s) - p);
    s := copy(s, 1, p - 1);
  end;
end; // ParseLastN


// ------------------------------------
// AnsiReverseString

/// //////// IMPORT PROCEDURES ///////////////////////////

// --------------------------------------------------------
// set webGetData before calling
// --------------------------------------------------------
procedure GetImpStrListFromWebGet(PasteRecs : boolean);
var
  i : integer;
  s : string;
begin
  if webGetData = '' then exit;
  try
    ImpStrList.clear;
    s := webGetData; // <-- data must already be in this var
    s := AdjustLineBreaks(s); // uses SysUtils
    deletingRecords := true;
    // make sure at least one CRLF for loop
    s := s + chr(13) + chr(10);
    // Get  Records
    if pos(chr(13), s) > 0 then begin
      i := 0;
      while pos(chr(10), s) > 0 do begin
        ImpStrList.Add(copy(s, 1, pos(chr(13), s) - 1));
        delete(s, 1, pos(chr(10), s));
        inc(i);
        if (frac(i / 100) = 0) then
          StatBar('Reading: ' + IntToStr(i));
      end;
    end;
    StatBar('off');
    setLength(ImpTrades, ImpStrList.Count + 1);
    s := '';
    deletingRecords := false;
    clipBoard.clear;
  finally
    StatBar('off');
  end;
end; // GetImpStrListFromWebGet


procedure GetImpStrListFromClip(PasteRecs : boolean);
var
  i : integer;
  s, t : string;
begin
  try
    ImpStrList.clear;
    s := clipBoard.astext;
    s := AdjustLineBreaks(s);
    if (length(trim(s)) = 0) then exit;
    if (TradeLogFile.CurrentAccount.FileImportFormat <> 'Fidelity') //
    and (TradeLogFile.CurrentAccount.FileImportFormat <> 'optionsXpress') //
    and (TradeLogFile.CurrentAccount.FileImportFormat <> 'IB') //
    then begin
      saveImportAsFile(s, '', '', Settings.InternalFmt);
    end; // if
    deletingRecords := true;
    // make sure there is at least one carriage linefeed
    s := s + chr(13) + chr(10);
    // Get  Records
    if pos(chr(13), s) > 0 then begin
      i := 0;
      while pos(chr(10), s) > 0 do begin
        t := copy(s, 1, pos(chr(13), s) - 1);
        if t <> '' then // don't add blank lines - 2016-08-23 MB
          ImpStrList.Add(t);
        delete(s, 1, pos(chr(10), s));
        inc(i);
        if (frac(i / 100) = 0) then // progress
          StatBar('Reading: ' + IntToStr(i));
      end;
    end;
    setLength(ImpTrades, ImpStrList.Count + 1);
    s := '';
    deletingRecords := false;
    clipBoard.clear;
  finally
    //
  end;
end; // GetImpStrListFromClip


// ----------------------------------------------
//
// ----------------------------------------------
procedure readFileIntoStrList(FileName : string);
var
  ImpFile : textfile;
  line : string;
  FileStream : TStreamReader;
  X : integer;
  cancelImport : boolean;
begin
  try
    screen.Cursor := crHourglass; // must wait!
    ImpStrList.clear;
    line := '';
    cancelImport := false;
    try
      if FileExists(FileName) then begin
        frmMain.update;
        try
          FileStream := TStreamReader.Create(FileName);
          // Get  Records
          while not FileStream.EndOfStream do begin
            line := FileStream.ReadLine;
            if cancelImport then break;
            Application.ProcessMessages;
            if GetKeyState(VK_ESCAPE) and 128 = 128 then
              cancelImport := true;
            X := ImpStrList.Count;
            if (X > 0) and (frac(X / 100) = 0) then
              StatBar('Reading from file: ' + IntToStr(X));
            // fixed for UNIX chr(10) EOL marker
            if (pos(chr(10), line) > 0) then begin
              while pos(chr(10), line) > 0 do begin
                ImpStrList.Add(copy(line, 1, pos(chr(10), line) - 1));
                delete(line, 1, pos(chr(10), line));
              end;
            end
            // fix for files with NO LF marker
            else if (pos(chr(13), line) > 0) //
              and (TradeLogFile.CurrentAccount.FileImportFormat = 'Scottrade') //
            then begin // fix for NO EOL marker
              while pos(chr(13), line) > 0 do begin
                ImpStrList.Add(copy(line, 1, pos(chr(13), line) - 1));
                delete(line, 1, pos(chr(13), line));
              end;
            end
            else if line <> '' then // 2017-09-14 MB - skip blank lines.
              ImpStrList.Add(line);
          end;
        finally
          FileStream.Free;
        end;
      end;
    except
      on EInOutError do
        sm('COULD NOT OPEN FILE' + cr //
            + 'It may be already open.');
    end;
    setLength(ImpTrades, ImpStrList.Count + 1);
  finally
    screen.Cursor := crDefault; // release mouse
  end;
end; // readFileIntoStrList


// ------------------------------------
// private functions used by XLS
// ------------------------------------
function CalcCRC32(AStream : TStream): Cardinal;
const CRCTable : array[0 .. 255] of DWord = ($00000000, $77073096, $EE0E612C, $990951BA, $076DC419,
    $706AF48F, $E963A535, $9E6495A3, $0EDB8832, $79DCB8A4, $E0D5E91E, $97D2D988, $09B64C2B,
    $7EB17CBD, $E7B82D07, $90BF1D91, $1DB71064, $6AB020F2, $F3B97148, $84BE41DE, $1ADAD47D,
    $6DDDE4EB, $F4D4B551, $83D385C7, $136C9856, $646BA8C0, $FD62F97A, $8A65C9EC, $14015C4F,
    $63066CD9, $FA0F3D63, $8D080DF5, $3B6E20C8, $4C69105E, $D56041E4, $A2677172, $3C03E4D1,
    $4B04D447, $D20D85FD, $A50AB56B, $35B5A8FA, $42B2986C, $DBBBC9D6, $ACBCF940, $32D86CE3,
    $45DF5C75, $DCD60DCF, $ABD13D59, $26D930AC, $51DE003A, $C8D75180, $BFD06116, $21B4F4B5,
    $56B3C423, $CFBA9599, $B8BDA50F, $2802B89E, $5F058808, $C60CD9B2, $B10BE924, $2F6F7C87,
    $58684C11, $C1611DAB, $B6662D3D, $76DC4190, $01DB7106, $98D220BC, $EFD5102A, $71B18589,
    $06B6B51F, $9FBFE4A5, $E8B8D433, $7807C9A2, $0F00F934, $9609A88E, $E10E9818, $7F6A0DBB,
    $086D3D2D, $91646C97, $E6635C01, $6B6B51F4, $1C6C6162, $856530D8, $F262004E, $6C0695ED,
    $1B01A57B, $8208F4C1, $F50FC457, $65B0D9C6, $12B7E950, $8BBEB8EA, $FCB9887C, $62DD1DDF,
    $15DA2D49, $8CD37CF3, $FBD44C65, $4DB26158, $3AB551CE, $A3BC0074, $D4BB30E2, $4ADFA541,
    $3DD895D7, $A4D1C46D, $D3D6F4FB, $4369E96A, $346ED9FC, $AD678846, $DA60B8D0, $44042D73,
    $33031DE5, $AA0A4C5F, $DD0D7CC9, $5005713C, $270241AA, $BE0B1010, $C90C2086, $5768B525,
    $206F85B3, $B966D409, $CE61E49F, $5EDEF90E, $29D9C998, $B0D09822, $C7D7A8B4, $59B33D17,
    $2EB40D81, $B7BD5C3B, $C0BA6CAD, $EDB88320, $9ABFB3B6, $03B6E20C, $74B1D29A, $EAD54739,
    $9DD277AF, $04DB2615, $73DC1683, $E3630B12, $94643B84, $0D6D6A3E, $7A6A5AA8, $E40ECF0B,
    $9309FF9D, $0A00AE27, $7D079EB1, $F00F9344, $8708A3D2, $1E01F268, $6906C2FE, $F762575D,
    $806567CB, $196C3671, $6E6B06E7, $FED41B76, $89D32BE0, $10DA7A5A, $67DD4ACC, $F9B9DF6F,
    $8EBEEFF9, $17B7BE43, $60B08ED5, $D6D6A3E8, $A1D1937E, $38D8C2C4, $4FDFF252, $D1BB67F1,
    $A6BC5767, $3FB506DD, $48B2364B, $D80D2BDA, $AF0A1B4C, $36034AF6, $41047A60, $DF60EFC3,
    $A867DF55, $316E8EEF, $4669BE79, $CB61B38C, $BC66831A, $256FD2A0, $5268E236, $CC0C7795,
    $BB0B4703, $220216B9, $5505262F, $C5BA3BBE, $B2BD0B28, $2BB45A92, $5CB36A04, $C2D7FFA7,
    $B5D0CF31, $2CD99E8B, $5BDEAE1D, $9B64C2B0, $EC63F226, $756AA39C, $026D930A, $9C0906A9,
    $EB0E363F, $72076785, $05005713, $95BF4A82, $E2B87A14, $7BB12BAE, $0CB61B38, $92D28E9B,
    $E5D5BE0D, $7CDCEFB7, $0BDBDF21, $86D3D2D4, $F1D4E242, $68DDB3F8, $1FDA836E, $81BE16CD,
    $F6B9265B, $6FB077E1, $18B74777, $88085AE6, $FF0F6A70, $66063BCA, $11010B5C, $8F659EFF,
    $F862AE69, $616BFFD3, $166CCF45, $A00AE278, $D70DD2EE, $4E048354, $3903B3C2, $A7672661,
    $D06016F7, $4969474D, $3E6E77DB, $AED16A4A, $D9D65ADC, $40DF0B66, $37D83BF0, $A9BCAE53,
    $DEBB9EC5, $47B2CF7F, $30B5FFE9, $BDBDF21C, $CABAC28A, $53B39330, $24B4A3A6, $BAD03605,
    $CDD70693, $54DE5729, $23D967BF, $B3667A2E, $C4614AB8, $5D681B02, $2A6F2B94, $B40BBE37,
    $C30C8EA1, $5A05DF1B, $2D02EF8D);
var
  LBytesRead : integer;
  LBuffer : array[1 .. 65521] of byte;
  LLoopI : Word;
begin
  result := $FFFFFFFF;
  repeat
    LBytesRead := AStream.Read(LBuffer, SizeOf(LBuffer));
    for LLoopI := 1 to LBytesRead do begin
      result := (result shr 8) xor CRCTable[LBuffer[LLoopI] xor (result and $000000FF)];
    end;
  until LBytesRead = 0;
  result := not result;
end;

function GetCRC32(AFileName : string) : DWord;
var
  LStream : TStream;
begin
  LStream := TFileStream.Create(AFileName, fmOpenRead, fmShareDenyWrite);
  try
    result := CalcCRC32(LStream);
  finally
    LStream.Free;
  end;
end;

/// / ---------------------------------------------+
/// / Read Excel data into ImpStrList
/// / ---------------------------------------------+
// procedure readExcelIntoStrList(FileName : string);
// var
// ExcelFile, WorkBook, WorkSheet, arrData : variant;
// iRow, iCol, nRows, nCols, X : integer;
// sFile, sCell, S, line, sPath, sUtil: string;
// cancelImport: boolean;
// begin
// sPath := ExtractFileDir(Application.ExeName);
// sUtil := sPath + '\XLS2CSV.exe';
// if fileexists(sUtil) = false then begin
// sm('XLS2CSV utility is missing.' + CR //
// + 'Please reinstall TradeLog.');
// exit;
// end;
// // ------------------------------------------------
// if GetCRC32(sUtil) <> CRC_XLS2CSV then begin
// SM('XLS2CSV utility may be damaged.' + CR //
// + 'Please reinstall TradeLog.');
// exit;
// end;
// // ------------------------------------------------
// // CRC is confirmed, so run the utility
// sFile := FileName;
// s := parselast(sFile, '.'); // remove extension
// sFile := sFile + '.csv'; // replace with CSV
// s := '"' + FileName + '" "' + sFile + '"';
// ShellExecute(0, 'open', PChar(sUtil), PChar(s), nil, SW_SHOW);
// // Now, load the data from the CSV file...
// readFileIntoStrList(sFile);
// end;

// ---------------------------------------------+
// Read Excel data into ImpStrList
// ---------------------------------------------+
procedure readExcelIntoStrList(FileName : string);
var
  ExcelFile, WorkBook, WorkSheet, arrData : variant;
  iRow, iCol, nRows, nCols, X : integer;
  sFile, sCell, s, line, sep : string;
  cancelImport : boolean;
begin
  try
    screen.Cursor := crHourglass; // must wait
    ImpStrList.clear;
    line := '';
    cancelImport := false;
    try
      if FileExists(FileName) then begin
        try
          // Open Excel OLE
          try
            ExcelFile := CreateOleObject('Excel.Application');
          except
            on EInOutError do begin
              sm('UNABLE TO LAUNCH EXCEL.');
            end;
          end;
          // Handle WoorkBook
          if not VarIsNull(ExcelFile) then begin
            try
              WorkBook := ExcelFile.WorkBooks.Open(FileName);
              // if (superuser) then // for customer support
              // sm('Opened Excel file:' + CR + WorkBook.name)
              // else
              sleep(1000); // delay one second
            except
              on e : Exception do begin
                sm('unable to open Excel file' + cr //
                    + 'Error: ' + e.Message);
              end;
            end; // try...except
            if not VarIsNull(WorkBook) then begin
              // Handle Sheet
              WorkSheet := WorkBook.WorkSheets.Item[1];
              if not VarIsNull(WorkSheet) then begin
                nRows := WorkSheet.Usedrange.EntireRow.Count;
                nCols := WorkSheet.Usedrange.EntireColumn.Count;
                arrData := WorkSheet.Usedrange.Value; // get all
              end; // if WorkSheet
            end; // if WorkBook
          end; // if ExcelFile
        finally
          ExcelFile.WorkBooks.close; // done
        end;
        // format and insert data into ImpStrList
        for iRow := 1 to nRows do begin
          for iCol := 1 to nCols do begin
            sCell := arrData[iRow, iCol];
            if (sCell = '') then
              s := ''
            else if (sCell[1] <> '"') //
              and (pos(',', sCell) > 0) then
              s := '"' + sCell + '"'
            else
              s := sCell;
            // --------------
            if iCol = 1 then
              line := s
            else
              line := line + TAB + s;
            Application.ProcessMessages;
            if GetKeyState(VK_ESCAPE) and 128 = 128 then
              cancelImport := true;
          end; // for iCol
          if cancelImport then
            break;
          ImpStrList.Add(line);
          X := ImpStrList.Count;
          if (X > 0) and (frac(X / 100) = 0) then
            StatBar('Reading from file: ' + IntToStr(X));
        end; // for iRow
      end
      else begin // file not found
        sm('file not found.');
      end; // if FileExists
    except
      on EInOutError do
        sm('COULD NOT OPEN FILE' + cr //
            + 'It may be already open.');
    end;
    setLength(ImpTrades, ImpStrList.Count + 1);
  finally
    screen.Cursor := crDefault; // release mouse
  end;
end; // readExcelIntoStrList


// ------------------------------------
procedure GetImpStrListFromFile(format, ext, FileName : string);
var
  PickFiles : TStringList;
  ImpDir, ext1, ext2, extStr, newPath, localFileName : string;
begin
  sFileType := 'txt';
  try
    ImpDir := Settings.ImportDir;
    frmMain.OpenDialog.FileName := FileName;
    if FileName = '' then begin
      newPath := '';
      PickFiles := TStringList.Create;
      PickFiles.Capacity := 1;
      extStr := format + ' Trade history files ';
      if (pos('|', ext) > 0) then begin
        ext1 := copy(ext, 1, pos('|', ext) - 1);
        ext2 := copy(ext, pos('|', ext) + 1, 255);
        extStr := extStr + '(*.' + ext1 + ' or *.' + ext2 + ')|*.' + ext1 + ';*.' + ext2;
        ext := '';
      end
      else
        extStr := extStr + '(*.' + ext + ')|*.' + ext;;
      // ---
      with frmMain do begin
        if OpenFileDialog(extStr, ImpDir, format + ' Import', newPath, PickFiles, false, false) //
        then
          FileName := newPath + '\' + PickFiles[0];
        // 2020-07-08 MB - handle XLSX, XLS, CSV, or TXT files
        if (rightStr(FileName, 4) = 'xlsx') //
        or (rightStr(FileName, 3) = 'xls') then begin
          readExcelIntoStrList(FileName);
          sFileType := 'xls';
        end
        else begin
          readFileIntoStrList(FileName);
          sFileType := 'csv';
        end; // type of file
      end; // with
    end // user-selected file
    else begin // file spec'd in call
      if not FileExists(FileName) then exit;
      // *** no provision for reading XLS? files this way ***
      readFileIntoStrList(FileName);
      sFileType := 'txt';
      localFileName := assignImpBackupFilename(dateStart, dateEnd, Settings.InternalFmt);
      if FileExists(localFileName) then
        deleteFile(localFileName);
      // save copy of import file
      copyFile(pChar(FileName), pChar(localFileName), false);
    end; // if filename provided in call
  finally
    PickFiles.Destroy;
  end;
end; // GetImpStrListFromFile


function GetStrFromFile(format, ext : string): string;
var
  ImpFile : textfile;
  ImpDir, line, ext1, ext2, extStr, newPath, s, FileName : string;
  X : integer;
  cancelImport : boolean;
  newFiles : TStringList;
begin // GetStrFromFile
  try
    line := '';
    cancelImport := false;
    ImpDir := Settings.ImportDir;
    begin
      newPath := '';
      newFiles := TStringList.Create;
      newFiles.Capacity := 1;
      extStr := format + ' Trade history files ';
      if (pos('|', ext) > 0) then begin
        ext1 := copy(ext, 1, pos('|', ext) - 1);
        ext2 := copy(ext, pos('|', ext) + 1, 255);
        extStr := extStr + '(*.' + ext1 + ' or *.' + ext2 + ')|*.' + ext1 + ';*.' + ext2;
        ext := '';
      end
      else
        extStr := extStr + '(*.' + ext + ')|*.' + ext;;
      with frmMain do begin
        if OpenFileDialog(extStr, ImpDir, format + ' Import', newPath, newFiles, false, false) then
          try
            FileName := newPath + '\' + newFiles[0];
            if FileExists(FileName) then begin
              frmMain.update;
              AssignFile(ImpFile, FileName);
              reset(ImpFile);
              StatBar('Opening File for reading - PLEASE WAIT!');
              // Get  Records
              while not EOF(ImpFile) do begin
                if cancelImport then break;
                Readln(ImpFile, line);
                Application.ProcessMessages;
                if (GetKeyState(VK_ESCAPE) and 128) = 128 then
                  cancelImport := true;
                inc(X);
                if (X > 0) and (frac(X / 100) = 0) then
                  StatBar('Reading from file: ' + IntToStr(X));
                s := s + line + cr;
              end;
              CloseFile(ImpFile);
              StatBar('off');
            end;
          except
            on EInOutError do
              sm('COULD NOT OPEN FILE');
          end;
      end;
    end;
    result := s;
  finally
    // GetStrFromFile
  end;
end;


// ------------------------------------
procedure ReverseImpTradesDate(R : integer);
var
  i : integer;
  Sort : TTradeArray;
begin
  try
    try
      Sort := nil;
      setLength(Sort, R + 1);
      for i := 1 to R do begin
        Sort[i] := ImpTrades[R + 1 - i];
        if SuperUser and (Sort[i].prf = '') then
          sm('bad type-mult in ' + IntToStr(i) + ') ' + Sort[i].tk);
      end;
      ImpTrades := nil;
      setLength(ImpTrades, R + 1);
      for i := 1 to R do begin
        ImpTrades[i] := Sort[i];
        ImpTrades[i].it := i; // NumRecs + i;
        if SuperUser and (ImpTrades[i].prf = '') then
          sm('bad type-mult in ' + IntToStr(i) + ') ' + ImpTrades[i].tk);
      end;
      Sort := nil;
    finally
      // nothing
    end;
  finally
    // ReverseImpTradesDate
  end;
end;
// ------------------------------------
// procedure ReverseShortTrades(R: integer);
// var
// i: integer;
// Sort: TTradeArray;
// begin
// try
// try
// Sort := nil;
// setLength(Sort, R + 1);
// for i := 1 to R do begin
// Sort[i] := ImpTrades[R + 1 - i];
// if SuperUser and (Sort[i].prf = '') then
// sm('bad type-mult in ' + inttostr(i) + ') ' + Sort[i].tk);
// end;
// ImpTrades := nil;
// setLength(ImpTrades, R + 1);
// for i := 1 to R do begin
// ImpTrades[i] := Sort[i];
// ImpTrades[i].it := i; // NumRecs + i;
// if (i > 1) then begin
// if (ImpTrades[i].tk < ImpTrades[i-1].tk) then begin
// ImpTrades[i-1].it := ImpTrades[i].it;
// ImpTrades[i].it := i; // NumRecs + i;
// end; // if tk out of order
// if (ImpTrades[i].tk = ImpTrades[i-1].tk) //
// and (ImpTrades[i-1].ls = 'L') and (ImpTrades[i-1].oc = 'O') //
// and (ImpTrades[i].ls = 'S') and (ImpTrades[i].oc = 'O') //
// and (ImpTrades[i-1].sh = ImpTrades[i].sh) then begin
// ImpTrades[i-1].it := ImpTrades[i].it; // buy followed by sell short
// ImpTrades[i].it := i; //
// end; // if tk out of order
// end; // if i > 1
// end; // for i
// Sort := nil;
// finally
// // nothing
// end;
// finally
// // ReverseImpTradesDate
// end;
// end;


// ------------------------------------
procedure GetImpDateLast;
var
  i : integer;
begin
  ImpDateLast := '01/01/1900';
  for i := 0 to TradeLogFile.Count - 1 do begin
    if (TradeLogFile[i].Broker = TradeLogFile.CurrentBrokerID) //
    and (TradeLogFile[i].Date >= xStrToDate(ImpDateLast, Settings.InternalFmt)) //
    then begin
      ImpDateLast := DateToStr(TradeLogFile[i].Date, Settings.InternalFmt);
    end; // if
  end; // for i
end;


procedure SortImpByDate(R : integer);
var
  i, X, d : integer;
  DateList : TStringList;
  Sort : TTradeArray;
begin
  try
    DateList := TStringList.Create;
    DateList.clear;
    with frmMain do begin
      Enabled := false;
      Sort := nil;
      setLength(Sort, R + 1);
      // put all dates into DateList
      for i := 1 to R do begin
        if (DateList.IndexOf(YYYYMMDD_Ex(ImpTrades[i].DT, Settings.InternalFmt)) = -1) then begin
          DateList.Add(YYYYMMDD_Ex(ImpTrades[i].DT, Settings.InternalFmt));
        end; // if
      end; // for
      DateList.sorted := true;
      StatBar('Sorting imported data by date. Please Wait . . .');
      X := 0;
      for d := 0 to DateList.Count - 1 do begin
        for i := 1 to R do begin
          if YYYYMMDD_Ex(ImpTrades[i].DT, Settings.InternalFmt) = DateList[d] then begin
            // StatBar('Sorting imported data by date ' + MMDDYYYY(DateList[d]));
            inc(X);
            Sort[X] := ImpTrades[i];
          end; // if
        end; // for i
      end; // for d
      ImpTrades := nil;
      setLength(ImpTrades, R + 1);
      for i := 1 to R do
        ImpTrades[i] := Sort[i];
      Enabled := true;
      Sort := nil;
      if pos('Sorting by', frmMain.stMessage.caption) > 0 then
        StatBar('off');
      DateList.Destroy;
    end;
  finally
    //
  end;
end; // SortImpByDate


function formatTime(tmStr : string): string;
var
  AmPm, s : string;
begin
  try
    if tmStr = '' then begin
      result := '';
      exit;
    end;
    tmStr := trim(uppercase(tmStr));
    if (pos('PM', tmStr) = length(tmStr) - 1) or (pos('AM', tmStr) = length(tmStr) - 1) then begin
      AmPm := rightStr(tmStr, 2);
      delete(tmStr, length(tmStr) - 1, 2);
      tmStr := trim(tmStr);
    end;
    if pos(':', tmStr) > 0 then begin
      if (pos(':', tmStr) = 2) and ((length(tmStr) = 7) or (length(tmStr) = 4)) then
        tmStr := '0' + tmStr;
      if (length(tmStr) = 5) then
        tmStr := tmStr + ':00';
    end
    else begin
      if length(tmStr) = 3 then
        tmStr := '0' + tmStr + '00'
      else if length(tmStr) = 4 then
        tmStr := tmStr + '00';
      if length(tmStr) = 5 then
        tmStr := '0' + tmStr;
      tmStr := copy(tmStr, 1, 2) + ':' + copy(tmStr, 3, 2) + ':' + copy(tmStr, 5, 2);
    end;
    if AmPm = 'PM' then begin
      try
        s := copy(tmStr, 1, 2);
        if s <> '12' then begin
          if leftStr(s, 1) = '0' then
            delete(s, 1, 1);
          s := IntToStr(strToInt(s) + 12);
          if length(s) = 1 then
            s := '0' + s;
          tmStr := s + ':' + copy(tmStr, 4, 2) + ':' + copy(tmStr, 7, 2);
        end;
      except
      end;
    end;
    result := tmStr;
  finally
    // formatTime
  end;
end;


/// /////////// TRADE MATCHING PROCEDURES ////////////////////

function AssignShorts : boolean;
begin
  if bApexActivity then begin
    result := false;
    exit;
  end;
  with TradeLogFile.CurrentAccount do begin
    if Penson2 then
      result := true
    else begin
      result := TDWyearend //
        or importFilter.AssignShortBuy //
        or ((importFilter.FilterName = 'Other') // 2021-05-25 MB - fka Excel-Text
          and AutoAssignShorts);
    end; // if/else
    if not(result) //
      and not(importFilter.AutoAssignShorts) then begin
      if importFilter.AutoAssignShorts then
        result := true
      else begin
        if importFilter.FilterName = 'Lightspeed' then
          result := ETProSWS
        else if importFilter.FilterName = 'E-Trade' then
          result := EtradeCSV or BrownCo;
//        else if importFilter.FilterName = 'Fidelity' then
//          result := importingOFX;
      end;
    end;
  end;
end;


function AssignShortSell : boolean;
begin
  result := false;
  if not(AssignShorts) then exit;
  result := TradeLogFile.CurrentAccount.AutoAssignShorts;
end;


function AssignShortBuy : boolean;
var
  DoIt : boolean;
begin
  result := TradeLogFile.CurrentAccount.AutoAssignShorts;
  if result then exit;
  DoIt := TDWyearend or TradeLogFile.CurrentAccount.SLConvert;
  if not(DoIt) and not(TradeLogFile.CurrentAccount.importFilter.AssignShortBuy) then begin
    if TradeLogFile.CurrentAccount.importFilter.AssignShortBuy then
      DoIt := true
    else begin
      if TradeLogFile.CurrentAccount.importFilter.FilterName = 'Lightspeed' then
        result := ETProSWS
      else if TradeLogFile.CurrentAccount.importFilter.FilterName = 'E-Trade' then
        result := EtradeCSV or BrownCo;
//      else if TradeLogFile.CurrentAccount.importFilter.FilterName = 'Fidelity' then
//        result := importingOFX;
    end;
  end;
  if DoIt then
    result := true
end;


//function DelSemiColons(s : string): string;
//begin
//  while pos(':', s) > 0 do
//    delete(s, pos(':', s), 1);
//  result := s;
//end;


         // =====================================
         // IMPORT FILTERS            |
         // =====================================

function ReadAssent(): integer;
var
  i, j, R, hour : integer;
  ImpDate, CmStr, SECStr, NASDStr, AMEXStr, TimeStr, PMStr, PrStr, ShStr, line, sep, opTick, descr,
    trNum : string;
  Amount, Commis : double;
  oc, ls : string;
  ImpNextDateOn, newFormat, contracts, noNASDAmexFees, cancels : boolean;
begin
  // updated 2010-02-13 for cancel trades C and T buy/sell codes
  try
    Commis := 0;
    Amount := 0;
    R := 0;
    GetImpDateLast;
    DataConvErrRec := '';
    DataConvErrStr := '';
    contracts := false;
    newFormat := false;
    noNASDAmexFees := false;
    cancels := false;
    ImpNextDateOn := false;
    ImpTrades := nil;
    setLength(ImpTrades, R + 1);
    GetImpDateLast;
    sep := ',';
    ImpStrList := TStringList.Create;
    // --------------------------------
    GetImpStrListFromClip(false); // only method is Web/paste
    // --------------------------------
    if ImpStrList.Count < 1 then begin
      ImpStrList.Destroy;
      result := 0;
      exit;
    end;
    // --------------------------------
    for i := 0 to ImpStrList.Count - 1 do begin
      inc(R);
      if R < 1 then R := 1;
      line := uppercase(ImpStrList[i]);
      if pos(TAB, line) > 0 then
        sep := TAB
      else
        sep := ' ';
      if pos('CLEARANCE ACTIVITY DETAIL', line) > 0 then begin
        newFormat := true;
        dec(R);
        Continue;
      end;
      if (pos('COMM REGFEE PROFIT', line) > 0) //
      or (pos('COMM TRANFEE PROFIT', line) > 0) //
      then begin
        noNASDAmexFees := true;
        dec(R);
        Continue;
      end;
      if pos('SYMBOL:', line) > 0 then begin
        line := trim(line);
        tick := trim(parseHTML(line, ':', '|'));
        tick := trim(tick);
        if pos(' - ', tick) > 0 then
          tick := copy(tick, 1, pos(' - ', tick) - 1);
        delete(line, 1, pos('|', line));
        // check for options   6-5-08
        descr := trim(parseHTML(line, ':', '|'));
        descr := uppercase(descr); // sm(descr);
        if pos('@', descr) > 0 then
          if (pos('CALL', descr) = length(descr) - 3) //
          or (pos('PUT', descr) = length(descr) - 2) //
          then begin
            contracts := true;
            delete(descr, pos('@ ', descr), 2);
            delete(descr, pos(' ' + '''', descr), 2);
            // delete space from option ticker
            if pos(' ', tick) > 0 then
              delete(tick, pos(' ', tick), 1);
            opTick := tick;
            tick := descr;
          end
          else
            contracts := false;
        dec(R);
        Continue;
      end;
      // Open/Close
      oc := copy(line, 1, pos(sep, line) - 1);
      oc := trim(oc);
      if (oc = 'C') or (oc = 'T') then begin
        oc := 'X';
        cancels := true;
      end
      else if (oc = 'B') or (oc = 'ER') //
      then begin
        oc := 'O';
      end
      else if (oc = 'S') or (oc = 'SS') or (oc = 'EX') //
      then begin
        oc := 'C';
      end
      else begin
        dec(R);
        Continue;
      end;
      ls := 'L';
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // del exchange
      ShStr := copy(line, 1, pos(sep, line) - 1);
      if not IsFloat(ShStr) then begin
        delete(line, 1, pos(sep, line));
        line := trim(line);
        ShStr := copy(line, 1, pos(sep, line) - 1);
      end;
      // shares
      if (ShStr = '0') or (ShStr = '') then begin
        dec(R);
        Continue;
      end;
      ShStr := delCommas(ShStr);
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // price
      PrStr := copy(line, 1, pos(sep, line) - 1);
      PrStr := delCommas(PrStr);
      delete(line, 1, pos(sep, line));
      line := trim(line);
      if newFormat then begin
        CmStr := PrStr;
        PrStr := ShStr;
        ShStr := CmStr;
        CmStr := '0.00';
      end;
      // comm
      CmStr := copy(line, 1, pos(sep, line) - 1);
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // SEC Fee
      SECStr := copy(line, 1, pos(sep, line) - 1);
      delete(line, 1, pos(sep, line));
      line := trim(line);
      if noNASDAmexFees then begin
        // sm('noNASDAmexFees');
        NASDStr := '0.00';
        AMEXStr := '0.00';
      end
      else begin // NASD Fee
        NASDStr := copy(line, 1, pos(sep, line) - 1);
        delete(line, 1, pos(sep, line));
        line := trim(line);
        // AMEX Fee
        AMEXStr := copy(line, 1, pos(sep, line) - 1);
        delete(line, 1, pos(sep, line));
        line := trim(line);
      end;
      // Net profit
      delete(line, 1, pos(sep, line) - 1);
      line := trim(line);
      // Date
      ImpDate := LongDateStr(copy(line, 1, pos(' ', line) - 1));
      if not ValidTradeDate(ImpDate, ImpDateLast, ImpNextDateOn) then begin
        dec(R);
        Continue;
      end;
      delete(line, 1, pos(' ', line));

      // Time
      line := trim(line);
      TimeStr := copy(line, 1, pos(sep, line) - 1);
      delete(line, 1, pos(sep, line));
      // AM/PM
      line := trim(line);
      PMStr := copy(line, 1, pos(sep, line) - 1);
      delete(line, 1, pos(sep, line));
      if (PMStr = 'AM') and (length(TimeStr) = 7) then
        TimeStr := '0' + TimeStr;
      if TimeStr <> '' then begin
        if (PMStr = 'PM') then begin
          hour := strToInt(copy(TimeStr, 1, pos(':', TimeStr) - 1));
          if hour < 12 then
            hour := hour + 12;
          TimeStr := IntToStr(hour) + copy(TimeStr, pos(':', TimeStr), 6);
        end; // if 'PM'
      end; // if <> ''
      trNum := trim(parseLast(line, sep)); // add trNum to notes field
      try
        Shares := StrToFloat(ShStr, Settings.InternalFmt);
        if Shares < 0 then
          Shares := -Shares;
        Price := StrToFloat(PrStr, Settings.InternalFmt);
        Amount := 0;
        Commis := StrToFloat(CmStr, Settings.InternalFmt) + StrToFloat(SECStr, Settings.InternalFmt)
          + StrToFloat(NASDStr, Settings.InternalFmt) + StrToFloat(AMEXStr, Settings.InternalFmt);
      except
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        dec(R);
        Continue;
      end;
      ImpTrades[R].it := TradeLogFile.Count + R;
      ImpTrades[R].DT := ImpDate;
      ImpTrades[R].tm := trim(TimeStr);
      ImpTrades[R].oc := oc;
      ImpTrades[R].ls := ls;
      ImpTrades[R].tk := tick;
      ImpTrades[R].sh := Shares;
      ImpTrades[R].pr := Price;
      if contracts then
        ImpTrades[R].prf := 'OPT-100'
      else
        ImpTrades[R].prf := 'STK-1';
      ImpTrades[R].opTk := opTick;
      ImpTrades[R].cm := Commis;
      ImpTrades[R].am := Amount;
      ImpTrades[R].no := trNum;
    end;
    // --------------------------------
    StatBar('off');
    ImpStrList.Destroy;
    // --------------------------------
    if cancels then begin
      for i := 1 to R do begin
        StatBar('Matching Cancelled Trades: ' + IntToStr(i));
        for j := 1 to R do begin
          if (ImpTrades[i].oc = 'X') // is a cancel
            and (ImpTrades[i].no = ImpTrades[j].no) // trNum matches
            and (i <> j) then begin // not just the same trade
            glNumCancelledTrades := glNumCancelledTrades + 2;
            ImpTrades[i].oc := '';
            ImpTrades[i].ls := '';
            ImpTrades[i].tm := '';
            ImpTrades[j].oc := '';
            ImpTrades[j].ls := '';
            ImpTrades[j].tm := '';
            break;
          end;
        end;
      end;
      // reset notes field
      for j := 1 to i do begin
        ImpTrades[i].no := '';
      end;
    end;
    // --------------------------------
    result := R;
    if R = 0 then
      sm('No Records to Import');
  finally
    //
  end;
end; // ReadAssent


    // --------------------------------
    // Ameritrade
    // --------------------------------

function ReadAmeritradeCSVinst(ImpStrList : TStringList): integer;
var
  i, R, p : integer;
  ImpDate, oc, ls, PrStr, prfStr, AmtStr, ShStr, CmStr, line, sep, NextDate, BuySell, opTick,
    callPut, strike, exYr, exMo, exDa : string;
  Amount, Commis, mult : double;
  contracts, ImpNextDateOn : boolean;
begin
  R := 0;
  Amount := 0;
  Commis := 0;
  DataConvErrRec := '';
  DataConvErrStr := '';
  ImpNextDateOn := false;
  sep := ',';
  for i := 0 to ImpStrList.Count - 1 do begin
    opTick := '';
    PrStr := '';
    inc(R);
    if R < 1 then
      R := 1;
    line := uppercase(ImpStrList[i]);
    line := trim(line);
    line := line + ',';
    if (pos('/', line) <> 2) and (pos('/', line) <> 3) and (pos('-', line) <> 3) then begin
      dec(R);
      if (i = ImpStrList.Count - 1) and (R = 0) then begin
        result := 0;
        exit;
      end;
      Continue;
    end;
    sep := ',';
    ImpDate := trim(copy(line, 1, pos(sep, line) - 1));
    // replace dashes with slashes
    while pos('-', ImpDate) > 0 do begin
      p := pos('-', ImpDate);
      delete(ImpDate, p, 1);
      insert('/', ImpDate, p);
    end;
    ImpDate := LongDateStr(ImpDate);
    if not ValidTradeDate(ImpDate, ImpDateLast, ImpNextDateOn) then begin
      dec(R);
      Continue;
    end;
    delete(line, 1, pos(sep, line)); // delete date
    line := trim(line); // descr
    // get price from descr becuase price is rounded to 2 decimals
    if (pos('"', line)= 1) then
      sep := '",'
    else
      sep := ',';
    PrStr := trim(copy(line, 1, pos(sep, line) - 1));
    PrStr := delQuotes(PrStr);
    delete(PrStr, 1, pos('@', PrStr));
    if (pos('"', line)= 1) then
      delete(line, 1, pos('",', line)+ 1)
    else
      delete(line, 1, pos(sep, line));
    line := trim(line);
    // tick
    tick := trim(copy(line, 1, pos(sep, line) - 1));
    delete(line, 1, pos(sep, line));
    line := trim(line);
    // O/C
    oc := trim(copy(line, 1, pos(sep, line) - 1));
    if (pos('SELL', oc) > 0) then begin
      oc := 'C';
      ls := 'L';
    end
    else if (pos('BUY', oc) > 0) then begin
      oc := 'O';
      ls := 'L';
    end
    else if (pos('SHORT', oc) > 0) then begin
      oc := 'O';
      ls := 'S';
    end
    else if (pos('COVER', oc) > 0) then begin
      oc := 'C';
      ls := 'S';
    end
    else begin
      dec(R);
      Continue;
    end;
    delete(line, 1, pos(sep, line));
    line := trim(line);
    // shares
    if (pos('"', line)= 1) then
      sep := '",'
    else
      sep := ',';
    ShStr := trim(copy(line, 1, pos(sep, line) - 1));
    ShStr := delQuotes(ShStr);
    ShStr := delCommas(ShStr);
    delete(line, 1, pos(sep, line));
    if sep = '",' then
      delete(line, 1, 1);
    line := trim(line);
    // price
    if (pos('"', line)= 1) then
      sep := '",'
    else
      sep := ',';
    // if price not found in descr field
    if PrStr = '' then begin
      PrStr := trim(copy(line, 1, pos(sep, line) - 1));
      PrStr := delQuotes(PrStr);
      if (pos('$', PrStr)= 1) then
        delete(PrStr, 1, 1);
      PrStr := delCommas(PrStr);
    end;
    delete(line, 1, pos(sep, line));
    if sep = '",' then
      delete(line, 1, 1);
    line := trim(line);
    // amount
    if (pos('"', line)= 1) then
      sep := '",'
    else
      sep := ',';
    AmtStr := trim(copy(line, 1, pos(sep, line) - 1));
    AmtStr := delQuotes(AmtStr);
    AmtStr := DelParenthesis(AmtStr);
    AmtStr := delCommas(AmtStr);
    if (pos('$', AmtStr)= 1) then
      delete(AmtStr, 1, 1);
    delete(line, 1, pos(sep, line));
    if sep = '",' then
      delete(line, 1, 1);
    line := trim(line);
    sep := ',';
    CmStr := trim(copy(line, 1, pos(sep, line) - 1));
    CmStr := delCommas(CmStr);
    if (pos('$', CmStr)= 1) then
      delete(CmStr, 1, 1);
    prfStr := 'STK-1';
    mult := 1;
    // sm('R: '+inttostr(R)+cr+impdate+' '+oc+ls+' '+tick+cr+'sh: '+shstr+' pr: '+prstr+cr+'amt: '+amtstr+' comm: '+cmStr);
    // continue;
    try
      Shares := StrToFloat(ShStr, Settings.InternalFmt);
      if Shares < 0 then
        Shares := -Shares;
      Amount := StrToFloat(AmtStr, Settings.InternalFmt);
      if Amount < 0 then
        Amount := -Amount;
      Price := StrToFloat(PrStr, Settings.InternalFmt);
      if Price < 0 then
        Price := -Price;
      if CmStr = '' then
        Commis := 0
      else
        Commis := StrToFloat(CmStr, Settings.InternalFmt);
      if (((oc = 'O') and (ls = 'L')) or ((oc = 'C') and (ls = 'S'))) then begin
        if Shares * Price > Amount then begin
          Price := Amount / Shares;
          Commis := 0;
        end
        else
          Commis := Amount - (Shares * Price * mult)
      end
      else
        Commis := (Shares * Price * mult) - Amount;
      ImpTrades[R].it := TradeLogFile.Count + R;
      ImpTrades[R].DT := ImpDate;
      ImpTrades[R].tm := '';
      ImpTrades[R].oc := oc;
      ImpTrades[R].ls := ls;
      ImpTrades[R].tk := tick;
      ImpTrades[R].sh := Shares;
      ImpTrades[R].pr := Price;
      ImpTrades[R].prf := prfStr;
      ImpTrades[R].cm := rndto2(Commis);
      ImpTrades[R].opTk := opTick;
      ImpTrades[R].am := Amount;
    except
      DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr + cr;
      dec(R);
      Continue;
    end;
  end;
  StatBar('off');
  if R > 1 then
    if xStrToDate(ImpTrades[1].DT) > xStrToDate(ImpTrades[R].DT) then
      ReverseImpTradesDate(R);
  result := R;
end; // ReadAmeritradeCSVinst


function ReadAmeritradeCSV(ImpStrList : TStringList): integer;
var
  i, j, p, R, selection : integer;
  ImpDate, TimeStr, CmStr, PrStr, prfStr, AmtStr, ShStr, line, line2, sep, idnum, NextDate, junk,
    BuySell, oldOpTk, newOpTk, opTick, callPut, strike, exYr, exMo, exDa : string;
  Amount, Commis, mult : double;
  CSVimp, contracts, cancels, ImpNextDateOn, dividend, divSh, divAmt, noPrice, hasExpires, expires,
    opChg : boolean;
  ImpStrList2 : TStringList;
  myDate : TDate;
  oc, ls : string;
begin
  try
    R := 0;
    Amount := 0;
    Commis := 0;
    DataConvErrRec := '';
    DataConvErrStr := '';
    cancels := false;
    CSVimp := false;
    ImpNextDateOn := false;
    expires := false;
    hasExpires := false;
    opChg := false;
    GetImpDateLast;
    sep := ',';
    // --------------------------------
    // test if TDA Institutional account
    for i := 0 to ImpStrList.Count - 1 do begin
      line := ImpStrList[i];
      line := trim(line);
      line := line + ',';
      // DATE,TRANSACTION ID,DESCRIPTION,QUANTITY,SYMBOL,PRICE,COMMISSION,AMOUNT,REG FEE,SHORT-TERM RDM FEE,FUND REDEMPTION FEE, DEFERRED SALES CHARGE,TEMP_COMPOSITE
      if pos('DATE,DESCRIPTION,SYMBOL,TRANS TYPE,QUANTITY,PRICE,NET AMOUNT,COMMISSION,TRANS ID',
        uppercase(line)) = 1 then begin
        result := ReadAmeritradeCSVinst(ImpStrList);
        exit;
      end;
    end;
    // --------------------------------
    ImpStrList2 := TStringList.Create;
    if ImpStrList.Count < 1 then begin
      result := 0;
      exit;
    end;
    divSh := false;
    divAmt := false;
    // --------------------------------
    for i := 0 to ImpStrList.Count - 1 do begin
      ImpStrList2.Add(ImpStrList[i]);
    end;
    // --------------------------------
    for i := 0 to ImpStrList.Count - 1 do begin
      if opChg then begin
        opChg := false;
        Continue;
      end;
      dividend := false;
      expires := false;
      opTick := '';
      inc(R);
      if R < 1 then R := 1;
      noPrice := false;
      line := uppercase(ImpStrList[i]);
      line := trim(line);
      line := line + ',';
      if pos('***END OF FILE***', line) > 0 then begin
        dec(R);
        break;
      end;
      // delete double decimal points from shares, price, comm, amount
      if pos('..', line) > 0 then
        while pos('..', line) > 0 do
          delete(line, pos('..', line), 1);
      if (pos('/', line) <> 2) and (pos('/', line) <> 3) and (pos('-', line) <> 3) then begin
        dec(R);
        if (i = ImpStrList.Count - 1) and (R = 0) then begin
          result := 0;
          exit;
        end;
        Continue;
      end;
      sep := ',';
      // ------------------------------
      ImpDate := trim(copy(line, 1, pos(sep, line) - 1));
      // replace dashes with slashes
      while pos('-', ImpDate) > 0 do begin
        p := pos('-', ImpDate);
        delete(ImpDate, p, 1);
        insert('/', ImpDate, p);
      end;
      ImpDate := LongDateStr(ImpDate);
      if not ValidTradeDate(ImpDate, ImpDateLast, ImpNextDateOn) then begin
        dec(R);
        Continue;
      end;
      delete(line, 1, pos(sep, line)); // delete date
      line := trim(line);
      TimeStr := trim(copy(line, 1, pos(sep, line) - 1));
      delete(line, 1, pos(sep, line)); // delete trans id
      // ------------------------------
      line := trim(line);
      oc := trim(copy(line, 1, pos(sep, line) - 1));
      contracts := false;
      if pos('CONTRACTS', line) > 0 then
        contracts := true;
      BuySell := oc;
      // ------------------------------
      // get rid junk transactions
      if (pos('SHORT TERM CAPITAL GAINS', oc) > 0) //
      or (pos('LONG TERM GAIN DISTRIBUTION', oc) > 0) //
      or (pos('MONEY MARKET REDEMPTION', oc) > 0) //
      or (pos('MONEY MARKET PURCHASE', oc) > 0) //
      then begin
        dec(R);
        Continue;
      end;
      // ------------------------------
      if (pos('REMOVAL OF OPTION DUE TO', oc) > 0) then begin
        // 2010-02-05 decided NOT to import option expirations
        // better off expiring them manually in TradeLog
        dec(R);
        Continue;
        { OC:='E';
          LS:= 'L';
          expires:= true;
          hasExpires:= true;
          contracts:= true;
 }
      end
      else if (pos('OPTION POSITION CHANGE', oc) > 0) or
        (pos('OPTION REORGANIZATION/CORPORATE ACTION', oc) > 0) then begin
        opChg := true;
        // get old option ticker
        oldOpTk := parseLast(oc, '(');
        delete(oldOpTk, pos(')', oldOpTk), 1);
        // get new option ticker
        if i = ImpStrList.Count - 1 then begin
          dec(R);
          Continue;
        end
        else begin
          newOpTk := ImpStrList[i + 1];
          for j := 1 to 4 do
            delete(newOpTk, 1, pos(sep, newOpTk));
          newOpTk := copy(newOpTk, 1, pos(sep, newOpTk) - 1);
          for j := R downto 1 do begin
            if ImpTrades[j].tk = oldOpTk then
              ImpTrades[j].tk := newOpTk;
          end;
          dec(R);
          Continue;
        end;
      end
      else if (pos('BUY TO OPEN', oc) > 0) or (pos('BOUGHT TO OPEN', oc) > 0) then begin
        oc := 'O';
        ls := 'L';
        contracts := true;
      end
      else if (pos('SELL TO CLOSE', oc) > 0) or (pos('SOLD TO CLOSE', oc) > 0) then begin
        oc := 'C';
        ls := 'L';
        contracts := true;
      end
      else if (pos('BUY TO CLOSE', oc) > 0) or (pos('BOUGHT TO CLOSE', oc) > 0) then begin
        oc := 'C';
        ls := 'S';
        contracts := true;
      end
      else if (pos('SELL TO OPEN', oc) > 0) or (pos('SOLD TO OPEN', oc) > 0) then begin
        oc := 'O';
        ls := 'S';
        contracts := true;
      end
      else if pos('BUY TO COVER', oc) > 0 then begin
        oc := 'O';
        ls := 'L';
      end
      // added 7-18-05
      else if pos('BOUGHT TO COVER', oc) > 0 then begin
        oc := 'C';
        ls := 'S';
      end
      else if (pos('SELL SHORT', oc) > 0) then begin
        oc := 'C';
        ls := 'L';
      end
      // added 7-18-05
      else if (pos('SOLD SHORT', oc) > 0) then begin
        oc := 'O';
        ls := 'S';
      end
      else if (pos('SOLD', oc) > 0) then begin
        oc := 'C';
        ls := 'L';
      end
      else if (pos('SELL', oc) > 0) then begin
        oc := 'C';
        ls := 'L';
      end
      else if (pos('BOUGHT', oc) > 0) then begin
        oc := 'O';
        ls := 'L';
      end
      else if (pos('BUY', oc) > 0) then begin
        oc := 'O';
        ls := 'L';
      end
      else if (pos('DIVIDEND REINVESTMENT (CASH DEBIT)', oc) > 0) and not divSh then begin
        dividend := true;
        oc := 'O';
        ls := 'L';
        delete(line, 1, pos(sep, line)); // del descr, qty
        delete(line, 1, pos(sep, line));
        tick := copy(line, 1, pos(sep, line) - 1);
        delete(line, 1, pos(sep, line)); // del price, comm
        delete(line, 1, pos(sep, line));
        delete(line, 1, pos(sep, line));
        AmtStr := trim(copy(line, 1, pos(sep, line) - 1));
        ShStr := '0.00';
        PrStr := '0.00';
        // sm('CASH DEBIT'+cr+tick+'  sh: '+shStr+'  am: '+amtStr);
        divAmt := true;
        for j := i to ImpStrList2.Count - 1 do begin
          line2 := uppercase(ImpStrList2[j]) + ',';
          delete(line2, 1, pos(sep, line2));
          delete(line2, 1, pos(sep, line2)); // delete dat & trans id
          oc := trim(copy(line2, 1, pos(sep, line2) - 1));
          if (pos('DIVIDEND REINVESTMENT (SHARES) (' + tick, oc) > 0) then begin
            oc := 'O';
            ls := 'L';
            delete(line2, 1, pos(sep, line2)); // del descr
            // get shares and ticker
            ShStr := trim(copy(line2, 1, pos(sep, line2) - 1));
            delete(line2, 1, pos(sep, line2));
            divSh := true;
            ImpStrList2[j] := '';
            // sm('SHARES'+cr+tick+'  sh: '+shStr+'  am: '+amtStr);
            break;
          end;
        end;
      end
      else if (pos('DIVIDEND REINVESTMENT (SHARES)', oc) > 0) and not divAmt then begin
        dividend := true;
        oc := 'O';
        ls := 'L';
        delete(line, 1, pos(sep, line)); // del descr
        ShStr := trim(copy(line, 1, pos(sep, line) - 1));
        delete(line, 1, pos(sep, line));
        tick := trim(copy(line, 1, pos(sep, line) - 1));
        AmtStr := '0.00';
        PrStr := '0.00';
        // sm('SHARES'+cr+tick+'  sh: '+shStr+'  am: '+amtStr);
        divSh := true;
        for j := i to ImpStrList2.Count - 1 do begin
          line2 := uppercase(ImpStrList2[j]) + ',';
          delete(line2, 1, pos(sep, line2));
          delete(line2, 1, pos(sep, line2)); // delete dat & trans id
          oc := trim(copy(line2, 1, pos(sep, line2) - 1));
          if (pos('DIVIDEND REINVESTMENT (CASH DEBIT) (' + tick, oc) > 0) then begin
            oc := 'O';
            ls := 'L';
            delete(line2, 1, pos(sep, line2));
            // del descr, qty, symbol, price, comm
            delete(line2, 1, pos(sep, line2));
            delete(line2, 1, pos(sep, line2));
            delete(line2, 1, pos(sep, line2));
            delete(line2, 1, pos(sep, line2));
            AmtStr := trim(copy(line2, 1, pos(sep, line2) - 1));
            divAmt := true;
            ImpStrList2[j] := '';
            // sm('CASH'+cr+tick+'  sh: '+shStr+'  am: '+amtStr);
            break;
          end;
        end;
      end
      else begin
        dec(R);
        Continue;
      end;
      // ------------------------------
      if not dividend then begin
        // delete descr
        delete(line, 1, pos(sep, line));
        ShStr := trim(copy(line, 1, pos(sep, line) - 1));
        delete(line, 1, pos(sep, line));
        tick := trim(copy(line, 1, pos(sep, line) - 1));
        delete(line, 1, pos(sep, line));
        PrStr := trim(copy(line, 1, pos(sep, line) - 1));
        if PrStr = '' then PrStr := '0.00';
        delete(line, 1, pos(sep, line));
        CmStr := trim(copy(line, 1, pos(sep, line) - 1));
        if CmStr = '' then CmStr := '0.00';
        delete(line, 1, pos(sep, line));
        AmtStr := copy(line, 1, pos(sep, line) - 1);
        // delete commas
        AmtStr := delCommas(AmtStr);
        // delete $ sign
        while pos('$', AmtStr) > 0 do
          delete(AmtStr, pos('$', AmtStr), 1);
        // delete dashes at end
        while copy(AmtStr, length(AmtStr), 1) = '-' do
          delete(AmtStr, length(AmtStr), 1);
        AmtStr := trim(AmtStr);
        // added the following lines so this works only for option tickers
        if contracts and (pos(' CALL', tick) = 0) and (pos(' PUT', tick) = 0) then
          while pos('.', tick) > 0 do begin
            p := pos('.', tick);
            delete(tick, p, 1);
          end;
      end; // if not dividend
      // ------------------------------
      // sm('R: '+inttostr(R)+cr+impdate+' '+timeStr+' '+oc+ls+' '+tick+cr+'sh:'+shstr+' pr: '+prstr+' amt: '+amtstr);
      // continue;
      try
        Shares := StrToFloat(ShStr, Settings.InternalFmt);
        if Shares < 0 then Shares := -Shares;
        Amount := StrToFloat(AmtStr, Settings.InternalFmt);
        if dividend then begin
          // sm('end1'+cr+'sh: '+shStr+'  am: '+amtStr);
          if (divSh = false) or (divAmt = false) then begin
            dec(R);
            Continue;
          end;
          // sm('end2'+cr+'sh: '+shStr+'  am: '+amtStr);
          if Amount < 0 then Amount := -Amount;
          Price := Amount / Shares;
          dividend := false;
          divSh := false;
          divAmt := false;
          ShStr := '';
          AmtStr := '';
          Amount := 0;
          Commis := 0;
        end
        else
          Price := StrToFloat(PrStr, Settings.InternalFmt);
        // ------------------
        if not expires then begin
          if noPrice then
            Price := Amount / Shares;
          // --- find cancel or correction trades 3-22-04
          if (((oc = 'O') and (ls = 'L')) //
              or ((oc = 'C') and (ls = 'S'))) and (compareValue(Amount, 0, NEARZERO) > 0) then begin
            cancels := true;
            oc := 'X';
          end;
          if (((oc = 'C') and (ls = 'L')) //
          or ((oc = 'O') and (ls = 'S'))) //
          and (compareValue(Amount, 0, NEARZERO) < 0) then begin
            cancels := true;
            oc := 'X';
          end;
        end;
        if Amount < 0 then Amount := -Amount;
        // ----------------------------
        // fix for options with no buy/sell identifier
        // IDEA: instead of comparing the difference, why not the ratio (aka estimated multiplier)?
        // non-options will be 1, but options will be 10, 100, etc. - 2018-08-31 MB
        // ----------------------------
        if (pos('TO OPEN', BuySell) = 0) //
          and (pos('TO CLOSE', BuySell) = 0) then begin
          if (Amount /(Shares * Price) > 5) then
            contracts := true; // 2018-09-11 MB - estimated multiplier
        end;
        // ----------------------------
        // 2012-02-10 DE - for TOS options with no to open / to close
        if contracts //
          or (pos(' CALL', tick) > 0) //
          or (pos(' PUT', tick) > 0) then begin
          // 2010-02-04 new option format: "UUF Feb 21 2009 6.0 Call"
          if (pos(' CALL', tick) = length(tick) - 4) or (pos(' PUT', tick) = length(tick) - 3) then
          begin
            tick := trim(tick);
            opTick := tick;
            callPut := parseLast(tick, ' ');
            strike := parseLast(tick, ' ');
            strike := delTrailingZeros(strike);
            exYr := parseLast(tick, ' ');
            exYr := rightStr(exYr, 2);
            exDa := parseLast(tick, ' ');
            if length(exDa)= 1 then
              exDa := '0' + exDa; // 2020-09-11 MB - Fix Exp Date format
            exMo := parseLast(tick, ' ');
            // 2018-09-11 MB - handle case of OPRA embedded in Option Ticker
            if (length(tick) > 10) // too long
              and (pos(' ', tick) > 0) then
              tick := parsefirst(tick, ' ');
            // mini options
            if rightStr(tick, 1)= '7' then begin
              delete(tick, length(tick), 1);
              mult := 10;
              prfStr := 'OPT-10';
            end
            else begin
              mult := 100;
              prfStr := 'OPT-100';
            end;
            tick := tick + ' ' + exDa + exMo + exYr + ' ' + strike + ' ' + callPut;
          end;
        end
        else begin
          mult := 1;
          prfStr := 'STK-1';
        end;
        // ----------------------------
        if not dividend and (Amount <> 0) then begin
          if (((oc = 'O') and (ls = 'L')) //
              or ((oc = 'C') and (ls = 'S'))) then begin
            if Shares * Price > Amount then begin
              Price := Amount / Shares;
              Commis := 0;
            end
            else
              Commis := Amount - (Shares * Price * mult)
          end
          else
            Commis := (Shares * Price * mult) - Amount;
        end;
        // ----------------------------
        if expires then Commis := 0;
        ImpTrades[R].it := TradeLogFile.Count + R;
        ImpTrades[R].DT := ImpDate;
        ImpTrades[R].tm := ''; // timeStr;
        ImpTrades[R].oc := oc;
        ImpTrades[R].ls := ls;
        ImpTrades[R].tk := tick;
        ImpTrades[R].sh := Shares;
        ImpTrades[R].pr := Price;
        ImpTrades[R].prf := prfStr;
        ImpTrades[R].cm := rndto2(Commis);
        ImpTrades[R].opTk := opTick;
        ImpTrades[R].am := Amount;
      except
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr + cr;
        dec(R);
        Continue;
      end;
    end; // big for loop
    // --------------------------------
    StatBar('off');
    // sm('R: '+inttostr(R)+cr+ImpTrades[1].dt+cr+ImpTrades[R].dt);
    if hasExpires then begin
      for i := 1 to R do begin
        StatBar('Expiring Options: ' + IntToStr(i));
        if ImpTrades[i].oc = 'E' then begin
          for j := i downto 1 do begin
            if (ImpTrades[j].tk = ImpTrades[i].tk)
            // and (i<>j)      removed 2010-02-04
            then begin
              ImpTrades[i].oc := 'C';
              ImpTrades[i].ls := ImpTrades[j].ls;
              break;
            end;
          end;
        end;
      end;
    end;
    // --------------------------------
    // delete all expirations not matched
    if expires then begin
      for i := 1 to R do begin
        if ImpTrades[i].oc = 'E' then begin
          ImpTrades[i].oc := '';
          ImpTrades[i].ls := '';
          ImpTrades[i].tm := '';
        end;
      end;
    end;
    // --------------------------------
    if R > 1 then
      if xStrToDate(ImpTrades[1].DT) > xStrToDate(ImpTrades[R].DT) then
        ReverseImpTradesDate(R);
    if cancels then begin
      for i := 1 to R do begin
        StatBar('Matching Cancelled Trades: ' + IntToStr(i));
        for j := i downto 1 do begin
          if (ImpTrades[i].oc = 'X') and (ImpTrades[i].tk = ImpTrades[j].tk)
          // and (ImpTrades[i].ls = ImpTrades[j].ls)
            and (format('%1.5f', [ImpTrades[i].sh], Settings.UserFmt) = format('%1.5f',
              [ImpTrades[j].sh], Settings.UserFmt)) and
            (format('%1.5f', [ImpTrades[i].pr], Settings.UserFmt) = format('%1.5f',
              [ImpTrades[j].pr], Settings.UserFmt))
          // and (format('%1.2f',[ImpTrades[i].cm],Settings.UserFmt)
          // = format('%1.2f',[-ImpTrades[j].cm],Settings.UserFmt))
            and (format('%1.2f', [ImpTrades[i].am], Settings.UserFmt) = format('%1.2f',
              [ImpTrades[j].am], Settings.UserFmt)) and (ImpTrades[i].prf = ImpTrades[j].prf) and
            (ImpTrades[j].oc <> '') and (i <> j) then begin
            // with ImpTrades[i] do msgTxt:= msgTxt+dt+tab+tk+tab+oc+ls+tab+floatToStr(sh)+tab+floatToStr(pr)+tab+floatToStr(am)+cr;
            // with ImpTrades[j] do msgTxt:= msgTxt+dt+tab+tk+tab+oc+ls+tab+floatToStr(sh)+tab+floatToStr(pr)+tab+floatToStr(am)+cr+cr;
            glNumCancelledTrades := glNumCancelledTrades + 2;
            ImpTrades[i].oc := '';
            ImpTrades[i].ls := '';
            ImpTrades[i].tm := '';
            ImpTrades[j].oc := '';
            ImpTrades[j].ls := '';
            ImpTrades[j].tm := '';
            break;
          end;
        end;
      end;
    end;
    // clipboard.asText:= msgTxt; sm(msgTxt); msgTxt:='';
    result := R;
    ImpStrList2.Destroy;
  finally
    // ReadAmeritradeCSV
  end;
end;


function ReadAmeritrade(): integer;
var
  R : integer;
begin
  R := 0;
  DataConvErrRec := '';
  DataConvErrStr := '';
  ImpStrList := TStringList.Create; // reserve memory
  ImpStrList.clear;
  try
    // --------------------------------
    // options: File, BC
    if sImpMethod = 'BC' then begin // imBrokerConnect:
      formGet.showmodal;
      if cancelURL then
        exit;
//      if OFX then
//        exit(-1)
//      else
        getTDAmeritradeCSV(OFXDateStart, OFXDateEnd);
      GetImpStrListFromWebGet(false);
      result := ReadAmeritradeCSV(ImpStrList);
      exit;
    end
    // --------------------------------
    else if sImpMethod = 'File' then begin // CSVImport
      GetImpStrListFromFile('Ameritrade', 'csv', '');
      result := ReadAmeritradeCSV(ImpStrList);
      exit;
    end
    // --------------------------------
    else if sImpMethod = 'Web' then begin //
      getTDAmeritradeCSV(OFXDateStart, OFXDateEnd);
      GetImpStrListFromWebGet(false);
      result := ReadAmeritradeCSV(ImpStrList);
      exit;
    end;
    // --------------------------------
    exit; // web import - no longer available
  finally
    ImpStrList.Destroy; // always release memory!
  end;
end; // ReadAmeritrade


// ==============================================
// Bank of America / Merrill Lynch / Merrill Edge
// ==============================================

function ReadBOA(): integer;
var
  i, j, k, R, iDt, iOC, iLS, iTk, iShr, iPr, iAmt : integer;
  NextDate, ImpDate, CmStr, PrStr, prfStr, AmtStr, ShStr, junk, opTick, line, sep, callPut, strike,
    expMo, expDa, expYr, opNoSt, opNoEx, s, t, oc, ls : string;
  Shares, Price, Amount, Commis, Fees, mult : double;
  ImpNextDateOn, contracts, hasOpNoSt, hasOpNoEx, colAcctReg, colAcctNum, settleDate, zeroPrice,
    cancels : boolean;
  fieldLst : TStrings;
  // ============================================
  // procedure SetFieldNumbers();
  // var
  // j : integer;
  // begin
  // // find/map Ninja CSV fields
  // k := 0;
  // for j := 0 to (fieldLst.Count - 1) do begin
  // if fieldLst[j] = 'TRADE DATE' then begin // Date/Time
  // iDt := j;
  // k := k or 1;
  // end
  // else if fieldLst[j] = 'DESCRIPTION' then begin // Open/Close
  // iOC := j;
  // iLS := j;
  // k := k or 2;
  // end
  // else if (fieldLst[j] = 'QTY') or (fieldLst[j] = 'QUANTITY') then begin // Shares/Contracts
  // iShr := j;
  // k := k or 4;
  // end
  // else if fieldLst[j] = 'INSTRUMENT' then begin // Ticker
  // iTk := j;
  // k := k or 8;
  // end
  // else if fieldLst[j] = 'ACTION' then begin // Buy/Sell (Long/Short)
  // iLS := j;
  // k := k or 16;
  // end
  // else if fieldLst[j] = 'PRICE' then begin
  // iPr := j;
  // k := k or 32;
  // end
  // else if fieldLst[j] = 'COMMISSION' then begin // Comm
  // iCm := j;
  // k := k or 64;
  // end; // note: 'RATE' field is conversion factor
  // end;
  // end;
  // --------------------------------------------
  function ReadMerrillEdge2017(): integer;
  var
    iRow, iCol : integer;
    lineLst : TStrings;
  begin
    // ------------------------------
    contracts := false;
    settleDate := false;
    opTick := '';
    expMo := '';
    expDa := '';
    expYr := '';
    strike := '';
    R := 0;
    // ------------------------------
    lineLst := ParseCSV(line);
    for iRow := 0 to (ImpStrList.Count - 1) do begin
      line := ImpStrList[iRow];
      line := trim(line);
      if line = '' then Continue;
      lineLst := ParseCSV(line, ',', '"');
      // --------------------
      // [iDt] Trade Date
      ImpDate := lineLst[0];
      if (pos('/', ImpDate) < 2) or (pos('/', ImpDate) > 3) then Continue;
      ImpDate := LongDateStr(ImpDate);
      if not ValidTradeDate(ImpDate, ImpDateLast, ImpNextDateOn) then Continue;
      inc(R);
      if R < 1 then R := 1;
      // --------------------
      // [iOC, iLS] Get O/C and L/S from Description 1
      s := lowercase(lineLst[iOC]);
      s := delQuotes(s); // some have quotes around them
      if pos('sale', s) > 0 then begin // either OL or CS
        if pos(' short', s) > 0 then begin
          oc := 'O';
          ls := 'S';
        end
        else begin
          oc := 'C';
          ls := 'L';
        end;
      end
      else if pos('purchase', s) > 0 then begin // either CL or OS
        if pos(' short', s) > 0 then begin
          oc := 'C';
          ls := 'S';
        end
        else begin
          oc := 'O';
          ls := 'L';
        end;
      end
      else begin
        dec(R);
        Continue;
      end;
      // --------------------
      // [iTk] Symbol / CUSIP
      tick := lineLst[iTk];
      // --------------------
      // [iShr] Quantity (shares)
      ShStr := delQuotes(lineLst[iShr]);
      if ShStr = '' then ShStr := '0';
      // --------------------
      // [iPr] Price
      PrStr := delQuotes(lineLst[iPr]);
      if PrStr = '' then PrStr := '0';
      // --------------------
      // [iAmt] Amount
      AmtStr := delQuotes(lineLst[iAmt]);
      AmtStr := DelParenthesis(AmtStr);
      AmtStr := delCommas(AmtStr);
      if AmtStr = '' then AmtStr := '0';
      // --------------------
      try
        Amount := CurrToFloat(AmtStr);
        if Amount = -1 then begin
          dec(R);
          inc(i);
          Continue;
        end;
        if Amount < 0 then Amount := -Amount;
        Price := CurrToFloat(PrStr);
        if Price = -1 then begin
          dec(R);
          inc(i);
          Continue;
        end;
        if Price < 0 then Price := -Price; // ABS(Price)
        Shares := CurrToFloat(ShStr);
        if Shares < 0 then Shares := -Shares;
        if contracts then begin
          ImpTrades[R].prf := 'OPT-100';
          mult := 100;
        end
        else begin
          ImpTrades[R].prf := 'STK-1';
          mult := 1;
        end;
        // comm
        if ls = 'L' then begin
          if (oc = 'O') then
            Commis := Amount - (Shares * Price * mult)
          else
            Commis := (Shares * Price * mult) - Amount;
        end
        else if ls = 'S' then begin
          if (oc = 'O') then
            Commis := (Shares * Price * mult) - Amount
          else
            Commis := Amount - (Shares * Price * mult);
        end;
        ImpTrades[R].it := TradeLogFile.Count + R;
        ImpTrades[R].DT := ImpDate;
        ImpTrades[R].tm := '';
        ImpTrades[R].oc := oc;
        ImpTrades[R].ls := ls;
        ImpTrades[R].tk := tick;
        ImpTrades[R].sh := StrFmtToFloat('%1.5f', [Shares], Settings.InternalFmt);
        ImpTrades[R].pr := StrFmtToFloat('%1.5f', [Price], Settings.InternalFmt);
        ImpTrades[R].opTk := opTick;
        ImpTrades[R].am := Amount;
        ImpTrades[R].cm := Commis;
        inc(i);
      except
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        dec(R);
        inc(i);
        Continue;
      end;
    end;
    result := R;
  end; // ReadMerrillEdge2017
  // --- NEW -----------------------------------
  // 0 Trade Date            8/15/2017
  // 1 Settlement Date  NU   08/18/2017 Pending
  // 2 Account          NU   CMA-Edge 25X-61P17
  // 3 Description           Pending Purchase  ADVANSIX INC SHS COVER SHORT ACTUAL...
  // 4 Type             NU
  // 5 Symbol/ CUSIP         ASIX
  // 6 Quantity              70
  // 7 Price                 $32.27
  // 8 Amount                ($2,259.04)
  // ============================================
begin // ReadBOA
  try
    // 2011-03-23
    DataConvErrRec := '';
    DataConvErrStr := '';
    R := 0;
    Commis := 0;
    ImpNextDateOn := false;
    opNoSt := '';
    opNoEx := '';
    hasOpNoSt := false;
    hasOpNoEx := false;
    zeroPrice := false;
    ImpStrList := TStringList.Create;
    ImpTrades := nil;
    setLength(ImpTrades, R + 1);
    GetImpDateLast;
    // ------------------------------------------
    GetImpStrListFromFile('BOA-Merrill', 'csv', ''); // only method is CSV
    // ------------------------------------------
    if ImpStrList.Count < 1 then begin
      ImpStrList.Destroy;
      result := 0;
      exit;
    end;
    // ------------------------------------------
    // Trade Date,Settlement Date,Pending/Settled,Account Nickname,Account Registration,
    // Type,Description 1 ,Description 2,Symbol/CUSIP #,Quantity,Price ($),Amount ($)
    // ------------------------------------------
    // test for acct reg columns
    colAcctReg := false;
    colAcctNum := false;
    j := (ImpStrList.Count - 1);
    if j > 10 then j := 10; // don't search more than 11 fields (0 to 10)
    for i := 0 to j do begin
      line := lowercase(ImpStrList[i]);
      if pos('account registration', line) > 0 then
        colAcctReg := true;
      if pos('account #', line) > 0 then
        colAcctNum := true;
      if pos('trade date  ,settlement date  ,account ,description', line) > 0 then begin
        iDt := 0;
        iOC := 3;
        iLS := 3;
        iTk := 5;
        iShr := 6;
        iPr := 7;
        iAmt := 8;
        result := ReadMerrillEdge2017;
        exit;
      end
      else if pos('"trade date " ,"settlement date " ,"description"', line) > 0 then begin
        iDt := 0;
        iOC := 2;
        iLS := 2;
        iTk := 4;
        iShr := 5;
        iPr := 6;
        iAmt := 7;
        result := ReadMerrillEdge2017;
        exit;
      end;
    end;
    // ------------
    i := 0;
    j := 0;
    cancels := false;
    // -------------------------------------
    // Main Loop
    // -------------------------------------
    while i <= ImpStrList.Count - 1 do begin
      contracts := false;
      settleDate := false;
      opTick := '';
      expMo := '';
      expDa := '';
      expYr := '';
      strike := '';
      inc(R);
      if R < 1 then R := 1;
      sep := ',';
      line := ImpStrList[i];
      line := trim(line);
      // ----------
      // impdate
      ImpDate := delQuotes(trim(copy(line, 1, pos(sep, line) - 1)));
      if (ImpDate = '--') then begin
        settleDate := true;
        delete(line, 1, pos(sep, line));
        trim(line);
        ImpDate := delQuotes(trim(copy(line, 1, pos(sep, line) - 1)));
      end;
      if (pos('/', ImpDate) <> 3) //
      and (pos('/', ImpDate) <> 2) then begin
        dec(R);
        if (i = ImpStrList.Count - 1) and (R = 0) then begin
          sm('Bank of America Import Error' + cr //
              + cr //
              + 'Please re-select entire report');
          result := 0;
          exit;
        end;
        inc(i);
        Continue;
      end;
      // ----------
      ImpDate := LongDateStr(ImpDate);
      if not ValidTradeDate(ImpDate, ImpDateLast, ImpNextDateOn) then begin
        dec(R);
        inc(i);
        Continue;
      end;
      // del Trade Date, Settlement Date, Pending/Settled, Account, Type
      if settleDate then
        for j := 1 to 4 do
          delete(line, 1, pos(sep, line))
      else
        for j := 1 to 5 do
          delete(line, 1, pos(sep, line));
      // end if
      // ----------
      if colAcctReg then
        delete(line, 1, pos(sep, line));
      // ----------
      if colAcctNum then
        delete(line, 1, pos(sep, line));
      // ----------
      // open/close - Descr 1
      oc := uppercase(delQuotes(copy(line, 1, pos(sep, line) - 1)));
      if (pos('BOUGHT', oc) = 1) or (pos('PURCHASE', oc) = 1) //
      or (pos('DIVD REINV', oc) = 1) or (pos('BUY', oc) = 1) //
      or (pos('OPTION PURCHASE', oc) = 1) // 2017-03-03 MB - NEW for 2017 Options
      or (pos('REINVESTMENT SHARE', oc) = 1) // 2017-03-17 MB - NEW for 2017 Divd Reinv
      then begin
        oc := 'O';
        ls := 'L';
      end
      else if (pos('SOLD', oc) = 1) or (pos('SALE', oc) = 1) or (pos('SELL', oc) = 1) //
      or (pos('OPTION SALE', oc) = 1) // 2017-03-05 MB - NEW for 2017 Options
      or (pos('FRACTIONAL SHARE SALE', oc) = 1) // 2017-03-17 MB - NEW
      then begin
        oc := 'C';
        ls := 'L';
      end
      else if (pos('TRADE CORRECTION', oc) = 1) then begin
        cancels := true;
        oc := 'X';
        ls := 'L';
      end
      else begin
        // OPTION EXPIRE, etc.
        dec(R);
        inc(i);
        Continue;
      end;
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // 2015-05/19 - get "short sale" and "cover short" from Descr 2 column
      if (pos('SHORT SALE', line)> 0) then begin
        oc := 'O';
        ls := 'S';
      end
      else if (pos('COVER SHORT', line)> 0) then begin
        oc := 'C';
        ls := 'S';
      end;
      // fix for comma in Descr 2 column  2011-02-17
      if pos('"', line) = 1 then
        junk := copy(line, 1, pos('",', line) - 1)
      else
        junk := copy(line, 1, pos(sep, line) - 1);
      while (pos(',', junk) > 0) do begin
        delete(junk, pos(',', junk), 1);
        delete(line, pos(',', line), 1);
      end;
      junk := delQuotes(junk);
      // Skip these cancel or correction trades
      if (pos('TRANSACTION CXL', junk) > 0) //
        or (pos('TRANSACTION CORR', junk) > 0) then begin
        dec(R);
        inc(i);
        Continue;
      end;
      // --------------------------------------------------
      // 2017-03-17 MB - New logic for dividend reinvestments
      // and Fractional Share Sales vs. Regular Buy/Sell
      // --------------------------------------------------
      if (pos(' QTY SOLD .', junk) > 0) then begin
        t := parseLast(junk, ' QTY SOLD '); // shares
        ShStr := parseLast(t, ' '); // just leave number
        t := parseLast(junk, ' SALE PRICE $'); // price
        PrStr := parseLast(t, '$');
        PrStr := delCommas(PrStr);
        t := line; // amount
        AmtStr := parseLast(t, ',');
        AmtStr := delCommas(AmtStr);
        AmtStr := delQuotes(AmtStr);
        delete(line, 1, pos(sep, line)); // ticker
        tick := delQuotes(copy(line, 1, pos(sep, line) - 1));
      end
      // --------------------------------------------------
      else if (pos(' REINV ', junk) > 0) then begin
        if pos(' QUANTITY BOT ', junk) > 0 then begin
          t := parseLast(junk, ' QUANTITY BOT '); // shares
          t := copy(t, 14); // everything after the token
        end
        else if pos(' REINV SHRS ', junk) > 0 then begin
          t := parseLast(junk, ' REINV SHRS '); // shares
          t := copy(t, 12); // everything after the token
        end
        else
          t := '';
        t := trim(t); // remove leading/trailinng blanks
        if pos(' ', t) = 0 then
          ShStr := t
        else
          ShStr := parsefirst(t, ' '); // just leave the number
        t := parseLast(junk, ' REINV PRICE $'); // price
        PrStr := parseLast(t, '$');
        PrStr := delCommas(PrStr);
        if pos(' REINV AMOUNT $', junk) > 0 then
          t := parseLast(junk, ' REINV AMOUNT $') // amount
        else if pos(' REINV AMT $', junk) > 0 then
          t := parseLast(junk, ' REINV AMT $') // amount
        else
          t := '';
        AmtStr := parseLast(t, '$');
        AmtStr := delCommas(AmtStr);
        delete(line, 1, pos(sep, line)); // ticker
        tick := delQuotes(copy(line, 1, pos(sep, line) - 1));
      end
      // --------------------------------------------------
      else begin // regular buy/sell trades
        // check if option trade
        if (pos('CALL ', junk) = 1) then begin
          contracts := true;
          callPut := 'CALL';
        end
        else if (pos('PUT ', junk) = 1) then begin
          contracts := true;
          callPut := 'PUT';
        end
        else begin
          contracts := false;
          callPut := '';
        end;
        // parse call/put
        if contracts then delete(junk, 1, pos(' ', junk));
        junk := trim(junk);
        // if option trade, parse descr 2 column
        if contracts and (pos('(', junk) = 1) then begin
          // ex: CALL (DIA) SPDR DOW JONES INDL MAY 22 10 $117 (100 SHS)OPENING TRANSACTION
          delete(junk, 1, pos('(', junk));
          // parse underlying ticker
          tick := copy(junk, 1, pos(')', junk) - 1);
          delete(junk, 1, pos(')', junk));
          expMo := trim(copy(junk, 1, pos('$', junk) - 1));
          expYr := parseLast(expMo, ' ');
          expDa := parseLast(expMo, ' ');
          expMo := parseLast(expMo, ' ');
          junk := trim(copy(junk, 1, pos('(', junk) - 1));
          strike := parseLast(junk, ' ');
          delete(strike, pos('$', strike), 1);
          tick := tick + ' ' + expDa + expMo + expYr + ' ' + strike + ' ' + callPut;
        end
        else if contracts then begin
          // ex: PUT  AMR    00006.000 AMR CORP DEL EXP 01-22-11 CLOSE TRAN AMR       JAN    6.00000 UNSOLICITED ORDER
          // ex: PUT  DIS    00032.000 DISNEY (WALT) CO COM STK EXP 10-16-10 CLOSE TRAN DIS       OCT   32.00000 UNSOLICITED ORDER
          // parse underlying ticker
          tick := parsefirst(junk, ' ');
          junk := trim(junk);
          t := parsefirst(junk, ' '); // hold strike price for later
          delete(junk, 1, pos('EXP ', junk) + 3); // 2021-10-08 MB - 'EXP <date>', NOT 'EXPRESS'
          junk := trim(junk);
          expMo := copy(junk, 1, 2); // 2017-03-04 MB
          s := getExpMo(expMo); // hold month for later
          expDa := copy(junk, 4, 2);
          expYr := copy(junk, 7, 2);
          delete(junk, 1, pos(' ', junk));
          junk := trim(junk);
          if (pos('OPEN TRAN', junk) > 0) and (oc = 'C') then begin
            oc := 'O';
            ls := 'S';
          end
          else if (pos('CLOSE TRAN', junk) > 0) and (oc = 'O') then begin
            oc := 'C';
            ls := 'S';
          end;
          if pos('CLIENT ENTERED.', junk)> 0 then
            junk := copy(junk, 1, pos('CLIENT ENTERED.', junk)- 1);
          junk := trim(junk);
          // 2015-08-04 fix for:
          if pos('PER ADVISORY AGREEMENT.', junk)> 0 then
            delete(junk, pos('PER ADVISORY AGREEMENT.', junk), 23);
          junk := trim(junk);
          strike := parseLast(junk, ' ');
          strike := delTrailingZeros(strike);
          junk := trim(junk);
          expMo := parseLast(junk, ' ');
          if length(expMo) <> 3 then begin
            expMo := s;
            while pos('0', t) = 1 do
              delete(t, 1, 1);
            strike := t;
          end;
          tick := tick + ' ' + expDa + expMo + expYr + ' ' + strike + ' ' + callPut;
          // if length(tick) > 22 then sm(tick);
        end;
        delete(line, 1, pos(sep, line));
        line := trim(line);
        // symbol/cusip = ticker
        if contracts then begin
          opTick := delQuotes(copy(line, 1, pos(sep, line) - 1));
        end
        else begin
          tick := delQuotes(copy(line, 1, pos(sep, line) - 1));
        end;
        delete(line, 1, pos(sep, line));
        line := trim(line);
        // shares
        ShStr := delQuotes(copy(line, 1, pos(sep, line) - 1));
        delete(line, 1, pos(sep, line));
        line := trim(line);
        // fix for prices with commas ie: GOOG "1,170.91","-117,096.30"
        if (pos('"', line) = 1) then begin
          PrStr := delQuotes(copy(line, 1, pos('"' + sep, line) - 1));
          delete(line, 1, pos('"' + sep, line)+ 1)
        end
        else begin
          PrStr := delQuotes(copy(line, 1, pos(sep, line) - 1));
          delete(line, 1, pos(sep, line));
        end;
        line := trim(line);
        // delete commas
        PrStr := delCommas(PrStr);
        if (PrStr = '--') then begin
          zeroPrice := true;
          PrStr := '0.00';
        end;
        // amount
        AmtStr := delQuotes(line);
        // delete parenthesis
        AmtStr := DelParenthesis(AmtStr);
        // delete commas
        AmtStr := delCommas(AmtStr);
        delete(line, 1, pos(sep, line));
        line := trim(line);
      end; // IF REINV ELSE BUY/SELL
      // --------------------------------------------------
      try
        Amount := CurrToFloat(AmtStr);
        if Amount = -1 then begin
          dec(R);
          inc(i);
          Continue;
        end;
        if Amount < 0 then Amount := -Amount;
        Price := CurrToFloat(PrStr);
        if Price = -1 then begin
          dec(R);
          inc(i);
          Continue;
        end;
        if Price < 0 then Price := -Price; // ABS(Price)
        Shares := CurrToFloat(ShStr);
        if Shares < 0 then Shares := -Shares;
        if contracts then begin
          ImpTrades[R].prf := 'OPT-100';
          mult := 100;
        end
        else begin
          ImpTrades[R].prf := 'STK-1';
          mult := 1;
        end;
        // comm
        if ls = 'L' then begin
          if (oc = 'O') then
            Commis := Amount - (Shares * Price * mult)
          else
            Commis := (Shares * Price * mult) - Amount;
        end
        else if ls = 'S' then begin
          if (oc = 'O') then
            Commis := (Shares * Price * mult) - Amount
          else
            Commis := Amount - (Shares * Price * mult);
        end;
        ImpTrades[R].it := TradeLogFile.Count + R;
        ImpTrades[R].DT := ImpDate;
        ImpTrades[R].tm := '';
        ImpTrades[R].oc := oc;
        ImpTrades[R].ls := ls;
        ImpTrades[R].tk := tick;
        ImpTrades[R].sh := StrFmtToFloat('%1.5f', [Shares], Settings.InternalFmt);
        ImpTrades[R].pr := StrFmtToFloat('%1.5f', [Price], Settings.InternalFmt);
        ImpTrades[R].opTk := opTick;
        ImpTrades[R].am := Amount;
        ImpTrades[R].cm := Commis;
        inc(i);
      except
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        dec(R);
        inc(i);
        Continue;
      end;
    end; // while loop
    // -------------------------------------
    if zeroPrice then
      mDlg('Some trades did not have a price per share' + cr + cr //
        + 'Please find all trades where price is zero' + cr //
        + 'and enter into the correct price into the Price column.', mtWarning, [mbOK], 0);
    if hasOpNoEx then
      sm('The following option trades may not have the right underlying stock ticker symbol:' + cr + cr //
        + opNoEx + cr + 'Please edit these trades.');
    // -------------------------------------
    if cancels then begin // 2017-03-08 MB need to do this before all of the ABS(x)
      for i := 1 to R do begin
        if (ImpTrades[i].oc = 'X') then begin
          for j := 1 to R do begin
            if (ImpTrades[j].oc <> '') and (ImpTrades[i].tk = ImpTrades[j].tk) and (i <> j) then
            begin
              if (ABS(ImpTrades[i].sh - ImpTrades[j].sh) < 0.0001) and
                (ABS(ImpTrades[i].am - ImpTrades[j].am) < 0.0001) and
                (ImpTrades[i].prf = ImpTrades[j].prf) then begin
                ImpTrades[i].oc := '';
                ImpTrades[i].ls := '';
                ImpTrades[i].tm := '';
                ImpTrades[j].oc := '';
                ImpTrades[j].ls := '';
                ImpTrades[j].tm := '';
                break;
              end; // if opposite
            end; // same ticker
          end; // for j
        end; // if OC = X
      end; // for i
    end; // if cancels
    // -------------------------------------
    // for i:= 1 to R do begin
    // ImpTrades[i].tm:= '';
    // if ImpTrades[i].oc = 'X' then begin
    // sm('CANCELLED TRADE NOT MATCHED!'+cr+cr
    // +'Open/Close is marked with an "X"');
    // break;
    // end;
    // end;
    // -------------------------------------
    if R > 1 then begin
      if (xStrToDate(ImpTrades[1].DT) > xStrToDate(ImpTrades[R].DT)) then
        ReverseImpTradesDate(R);
      fixImpTradesOutOfOrder(R); // 2015-05/19 trades hopelessly out of order
    end;
    ImpStrList.Destroy;
    result := R;
  finally
    // ReadBOA
  end;
end; // ReadBOA


         // ---------------------------
         // Cobra
         // ---------------------------

function ReadCobraXLS(): integer;
// --------------------------
// 2020-21 Cobra Format:
// 0 - DT - Date	8/26/2020	8/26/2020
// 1 - OC - Action	Sell	Buy
// 2 - SH - Quantity	-25	100
// 3 - TK - Symbol	CRM	TWTR
// 4 - DS - Description	SALESFORCE COM INC	TWITTER INC
// 5 - PR - Price	274.38	41.02
// 6 - AM - Amount	-6858.39	4102.8
// 7 - LS - Type	Short	Margin
// 8 - NU - Trailer
// --------------------------
var
  i, j, k, p, R : integer;
  iDt, iOC, iLS, iTyp, iTk, iShr, iPr, iAmt, iComm, iDesc, numFields : integer;
  // import field numbers
  sTmp, ImpDate, opTick, opUnder, opStrike, opYr, opMon, opDay, opCP, PrStr, prfStr, AmtStr, comStr,
    ShStr, line, sep, junk, NextDate, descr, secType : string;
  Shares, Amount, Commis, Net, mult : double;
  contracts, cancels, ImpNextDateOn, divReinv, bFoundHeader : boolean;
  oc, ls : string;
  fieldLst : TStrings; // for parsing individual lines
  // ------------------------
  // new 2022 format:
  // 0	Date	10/10/2022
  // 1	Quantity	200
  // 2	Symbol	AAPL
  // 3	Description	APPLE INC
  // 4	Price	139.65
  // 5	TransFee (NU)
  // 6	ECNTaker (NU)
  // 7	ECNMaker (NU)
  // 8	ORFFee (NU)
  // 9	TAFFee (NU)
  // 10	SECFee (NU)
  // 11	Amount	-27931.2
  // 12	Type	Margin
  // 13	Commissions	-1
  // ------------------------
  procedure SetFieldNumbers();
  var
    j : integer;
  begin
    k := 0;
    for j := 0 to (fieldLst.Count - 1) do begin
      if (fieldLst[j] = 'DATE') then begin
        iDt := j;
        k := k or 1;
      end
      else if (fieldLst[j] = 'ACTION') then begin
        iOC := j; // for 'BOUGHT' or 'SOLD'
        k := k or 2;
      end
      else if (fieldLst[j] = 'DESCRIPTION') then begin
        iDesc := j;
        iAmt := j;
        k := k or 4;
      end
      else if (fieldLst[j] = 'SYMBOL') then begin
        iTk := j;
        k := k or 8;
      end
      else if (fieldLst[j] = 'QUANTITY') then begin
        iShr := j;
        k := k or 16;
      end
      else if (fieldLst[j] = 'PRICE') then begin
        iPr := j;
        k := k or 32;
      end
      else if (fieldLst[j] = 'AMOUNT') then begin
        iAmt := j; // negative means BUY
        k := k or 64;
      end
      else if (fieldLst[j] = 'TYPE') then begin
        iLS := j; // SHORT or MARGIN
        k := k or 128;
      end;
    end;
  end;
// procedure SetFieldNumbers;
// begin
// iDt := 0; // m/d/yyyy
// iOC := 1; // SELL or BUY
// iShr := 2;
// iTk := 3; //
// iDesc := 4;
// iPr := 5;
// iAmt := 6;
// iLS := 7; // SHORT or MARGIN
// end;
  // ------------------------
  function ReadDate(sDate : string) : string;
  var
    lstDateParts : TStrings;
    sMM, sDD, sYY : string;
  begin
    result := ''; // default
    // note: auto-detect date format
    if (pos('/', sDate) > 0) then begin
      lstDateParts := ParseCSV(sDate, '/');
    end
    else if (pos('-', sDate) > 0)then begin
      lstDateParts := ParseCSV(sDate, '-')
    end
    else begin
      exit; // not a valid date
    end;
    if lstDateParts = nil then exit; // error
    if lstDateParts.Count <> 3 then exit; // error
    sMM := lstDateParts[0];
    sDD := lstDateParts[1];
    sYY := lstDateParts[2];
    // ----------------------
    if length(sYY) > 4 then // could be Date/Time
      sYY := copy(sYY, 1, pos(' ', sYY));
    // ----------------------
    if length(sMM) = 4 then begin // it's YYYY-MM-DD format!
      sYY := lstDateParts[0];
      sMM := lstDateParts[1];
      sDD := lstDateParts[2];
    end;
    // ----------------------
    if (strToInt(sMM) > 12) then begin // it's DD-MM-YYYY format!
      sDD := lstDateParts[0];
      sMM := lstDateParts[1];
      sYY := lstDateParts[2];
    end;
    // ----------------------
    if length(sMM) = 1 then
      sMM := '0' + sMM;
    if length(sDD) = 1 then
      sDD := '0' + sDD;
    if length(sYY) = 2 then
      sYY := '20' + sYY;
    // ----------------------
    result := sMM + '/' + sDD + '/' + sYY; // internal format
  end;
  // ------------------------
  // From WedBush:
  // Action	Meaning
  // Sell   Sell
  // Buy    Buy
  // BO 	  Buy to Open
  // SC 	  Sell to Cover
  // Stock Journal 	Stock Moved between accounts or account types
  // Buy Cancel
  // CO 	  Cancel Option
  // BC 	  Buy to Cover
  // SO 	  Sell to Open
  // Option_Expiration
  // Sell Cancel
  procedure DecodeOCLS(s1 : string; s2 : string);
  begin
    // note: sets variables OC and LS directly
    oc := '';
    if s2 = 'SHORT' then begin
      ls := 'S';
    end
    else begin
      ls := 'L';
    end;
    if s1 = 'SELL' then begin //
      if s2 = 'SHORT' then begin
        oc := 'O';
        ls := 'S';
      end
      else begin
        oc := 'C';
        ls := 'L';
      end;
    end
    else if s1 = 'BUY' then begin //
      if s2 = 'SHORT' then begin
        oc := 'C';
        ls := 'S';
      end
      else begin
        oc := 'O';
        ls := 'L';
      end;
    end
    else if s1 = 'BO' then begin // Buy to Open
      oc := 'O';
      ls := 'L';
    end
    else if s1 = 'SC' then begin // Sell to Cover
      oc := 'C';
      ls := 'L';
    end
    else if s1 = 'STOCK JOURNAL' then begin // Stock Moved between accounts or account types
      oc := ''; // do not import
    end
    else if s1 = 'BUY CANCEL' then begin //
      oc := 'X';
      if s2 = 'SHORT' then begin
        ls := 'S';
      end
      else begin
        ls := 'L';
      end;
      cancels := true;
    end
    else if s1 = 'CO' then begin // Cancel Option
      oc := 'X';
      ls := 'L';
      cancels := true;
    end
    else if s1 = 'BC' then begin // Buy to Cover
      oc := 'C';
      ls := 'S';
    end
    else if s1 = 'SO' then begin // Sell to Open
      oc := 'O';
      ls := 'S';
    end
    else if s1 = 'OPTION_EXPIRATION' then begin
      oc := ''; // do not import
    end
    else if s1 = 'SELL CANCEL' then begin
      oc := 'X';
      if s2 = 'SHORT' then begin
        ls := 'S';
      end
      else begin
        ls := 'L';
      end;
      cancels := true;
    end
    else begin //
      oc := 'E';
      ls := 'L';
    end;
  end;
  // ------------------------
  function DecodeOptTk(sTk : string) : string;
  var
    sTemp : string;
    n : integer;
    lstOptTkParts : TStrings; // for parsing Option Tickers
  begin
    // Reset all local vars
    opUnder := '';
    opStrike := '';
    opYr := '';
    opMon := '';
    opDay := '';
    opCP := '';
    // Cobra-Wedbush format:
    // ---------------------  --------------------
    // Symbol: AAPL 325.0200605C
    // tick $$$.$YYMMDD|
    // C or P
    // ---------------------  --------------------
    opUnder := parsefirst(sTk, ' ');
    opCP := copy(sTk, length(sTk), 1);
    if opCP = 'C' then
      opCP := 'CALL'
    else if opCP = 'P' then
      opCP := 'PUT'
    else
      exit('');
    delete(sTk, length(sTk), 1);
    opDay := copy(sTk, length(sTk)- 1, 2);
    opMon := copy(sTk, length(sTk)- 3, 2);
    opMon := getExpMo(opMon);
    opYr := copy(sTk, length(sTk)- 5, 2);
    delete(sTk, length(sTk)- 5, 6);
    opStrike := sTk;
    if leftStr(opStrike, 1) = '$' then
      delete(opStrike, 1, 1);
    opStrike := delTrailingZeros(opStrike); // 2017-10-09 MB Remove trailing zeros for matching
    result := opUnder + ' ' + opDay + opMon + opYr + ' ' + opStrike + ' ' + opCP;
  end;
  // ------------------------
//  procedure ShowCancelled(i : integer; j : integer);
//  var
//    s : string;
//  begin
//    s := IntToStr(i) + TAB + ImpTrades[i].ls + TAB + ImpTrades[i].no + TAB +
//      floattostr(ImpTrades[i].cm) + CRLF //
//      + IntToStr(j) + TAB + ImpTrades[j].ls + TAB + ImpTrades[j].no + TAB +
//      floattostr(ImpTrades[i].cm);
//    clipBoard.clear;
//    clipBoard.astext := s;
//    sm(s);
//  end;
  // ------------------------
//  procedure ShowImpTrades;
//  var
//    i : integer;
//    s : string;
//  begin
//    s := '';
//    for i := 1 to high(ImpTrades) do begin
//      s := s + IntToStr(i) + ' ' + ImpTrades[i].oc + ' ' + ImpTrades[i].ls + ' ' //
//        + floattostr(ImpTrades[i].sh) + ' @ ' + floattostr(ImpTrades[i].pr) + ' ' //
//        + ImpTrades[i].tk + ' ' + ImpTrades[i].no + CRLF;
//    end;
//    clipBoard.clear;
//    clipBoard.astext := s;
//    sm(s);
//  end;
// ------------------------
begin // ReadCobraXLS
  try
    sep := TAB; // assume XLS data is TAB-delimited
    bFoundHeader := false;
    DataConvErrRec := '';
    DataConvErrStr := '';
    Commis := 0;
    Net := 0;
    R := 0;
    EtradeXLS := true;
    cancels := false;
    ImpNextDateOn := false;
    GetImpDateLast;
    if ImpStrList.Count < 1 then begin
      result := 0;
      exit;
    end;
    // ------------------------------------------
    for i := 0 to (ImpStrList.Count - 1) do begin
      line := ImpStrList[i];
      line := uppercase(trim(line));
      if line = '' then Continue;
      fieldLst := ParseCSV(line, TAB); // try TAB first
      // ------------------------------
      if not bFoundHeader then begin
        if (pos('DATE', line) > 0) //
          and (pos('SYMBOL', line) > 0) //
          and (pos('QUANTITY', line) > 0) //
          and (pos('AMOUNT', line) > 0) //
        then begin
          if fieldLst.Count < 5 then Continue;
          SetFieldNumbers;
          numFields := fieldLst.Count;
          if SuperUser and ((k and 253) <> 253) then // make iOC optional
            sm('there appear to be fields missing.');
          bFoundHeader := true; // don't do this anymore
          R := 0; // start now
        end;
        Continue; // don't process anything until we recognize the header
      end;
      if fieldLst.Count > numFields then begin
        DataConvErrRec := DataConvErrRec + line + cr;
        Continue; // record has extra commas!
      end;
      // ------------------------------
      j := fieldLst.Count - 1;
      if fieldLst[j] = 'CUS AUTO ADJUST' then Continue; // skip it
      tick := trim(fieldLst[iTk]); // ticker
      if tick = '' then Continue;
      // --------------------
      // reset local vars
      // --------------------
      mult := 1;
      opTick := '';
      contracts := false;
      divReinv := false;
      // --------------------
      // date
      // --------------------
      // [iDt] Trade Date
      sTmp := fieldLst[iDt];
      ImpDate := ReadDate(sTmp);
      if ImpDate = '' then Continue;
      if not ValidTradeDate(ImpDate, ImpDateLast, ImpNextDateOn) then Continue;
      // --------------------
      // DE: do not import expires and assigns because we don't know if short or lomg!!!
      if (pos('OPTION EXPIRE', sTmp) > 0) //
      or (pos('OPTION ASSIGNMENT', sTmp) > 0) then begin
        Continue;
      end;
      // --------------------
      inc(R); // otherwise assume we have another valid record (for now)
      if R < 1 then R := 1;
      StatBar('Reading: ' + IntToStr(R));
      // --------------------
      // [iAmt] amount
      AmtStr := trim(uppercase(fieldLst[iAmt]));
      if AmtStr = '0' then begin
        DataConvErrRec := DataConvErrRec + 'Missing amount for ticker: ' + tick + CRLF +
          ImpStrList[i] + cr + lf + cr + lf;
        dec(R);
        Continue;
      end;
      delete(AmtStr, pos(',', AmtStr), 1);
      Amount := FracDecToFloat(AmtStr);
      // --------------------
      // [iOC] open/close
      if (k = 255) then begin //
        sTmp := trim(uppercase(fieldLst[iOC]));
        if (sTmp = '') then
          Continue;
        DecodeOCLS(fieldLst[iOC], fieldLst[iLS]);
        if (oc = '') then begin
          dec(R);
          Continue;
        end;
      end
      else if Amount < 0 then begin // k = 253
        sTmp := fieldLst[iLS]; // BUY
        if sTmp = 'SHORT' then begin
          oc := 'C';
          ls := 'S';
        end
        else begin
          oc := 'O';
          ls := 'L';
        end;
      end
      else begin
        sTmp := fieldLst[iLS]; // SELL
        if sTmp = 'SHORT' then begin
          oc := 'O';
          ls := 'S';
        end
        else begin
          oc := 'C';
          ls := 'L';
        end;
      end;
      // --------------------
      // [iTyp] SecurityType
      if pos(' ', tick) > 0 then begin // ------------------ OPTION
        sTmp := DecodeOptTk(tick);
        if (sTmp = '') then begin
          contracts := false;
        end
        else begin
          contracts := true;
          opTick := tick;
          tick := sTmp;
        end;
      end;
      // --------------------
      // [iShr] shares
      ShStr := trim(uppercase(fieldLst[iShr]));
      ShStr := DelParenthesis(ShStr); // remove parentheses
      delete(ShStr, pos(',', ShStr), 1); // remove commas
      // do not import cancels with no number of shares
      if (oc = 'X') and (ShStr = '0') then begin
        dec(R);
        Continue;
      end;
      // --------------------
      // [iPr] price
      PrStr := trim(uppercase(fieldLst[iPr]));
      // --------------------
      // [iDescr] descr
      descr := trim(uppercase(fieldLst[iDesc]));
      // delete all quotes
      while pos('"', descr) > 0 do
        delete(descr, pos('"', descr), 1);
      // delete all commas
      while pos(',', descr) > 0 do
        delete(descr, pos(',', descr), 1);
      // special case: dividend reinvestments
      p := pos('REIN @', descr);
      if divReinv and (p > 0) then begin
        PrStr := copy(descr, p + 6);
        PrStr := trim(PrStr);
      end;
      // --------------------
      // options
      if contracts then begin
        // special cases: weekly, mini-options
        if rightStr(opUnder, 1)= '7' then begin
          delete(tick, length(opUnder), 1);
          mult := 10;
          prfStr := 'OPT-10';
        end
        else if mult = 1 then begin
          mult := 100;
          prfStr := 'OPT-100';
        end;
      end
      else begin
        mult := 1;
        prfStr := 'STK-1';
      end;
      // ------------------------------
      try
        Shares := StrToFloat(ShStr, Settings.InternalFmt);
        if Shares < 0 then
          Shares := -Shares;
        Price := FracDecToFloat(PrStr);
        // Amount
        if Amount < 0 then
          Amount := -Amount;
        if divReinv and (Price = 0) //
          and (Amount <> 0) and (Shares <> 0) then begin
          Price := rndto5(Amount / Shares);
          if Price < 0 then Price := -Price; // ABS(Price)
        end;
        // fix for when no price and no shares
        if divReinv and (Price = 0) and (Shares = 0) then begin
          dec(R);
          Continue;
        end;
        // comm
        if ((oc = 'O') and (ls = 'L')) or ((oc = 'C') and (ls = 'S')) then
          Commis := Amount - (Shares * Price * mult)
        else if ((oc = 'C') and (ls = 'L')) or ((oc = 'O') and (ls = 'S')) then
          Commis := (Shares * Price * mult) - Amount;
        if Commis < 0 then
          Commis := -Commis;
        // ----------------------------
        ImpTrades[R].it := TradeLogFile.Count + R;
        ImpTrades[R].DT := ImpDate;
        ImpTrades[R].tm := '';
        ImpTrades[R].oc := oc;
        ImpTrades[R].ls := ls;
        ImpTrades[R].tk := tick;
        ImpTrades[R].sh := Shares;
        ImpTrades[R].pr := Price;
        ImpTrades[R].prf := prfStr;
        ImpTrades[R].cm := Commis;
        ImpTrades[R].am := Net;
        ImpTrades[R].opTk := opTick;
// ImpTrades[R].no := IntToStr(R); // for troubleshooting
      except
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr + lf;
        dec(R);
        Continue;
      end;
    end; // loop
    // --------------------------------
    ReverseImpTradesDate(R); // file is date descending
    SortImpByDateOC(1, R); // short, long, cancels
    // --------------------------------
    if cancels then begin
      for i := 1 to R do begin
        for j := 1 to R do begin
          if (ImpTrades[i].oc = 'X') //
            and (ImpTrades[i].tk = ImpTrades[j].tk) //
            and (ImpTrades[i].ls = ImpTrades[j].ls) // 2020-10-16 MB added LS check
            and (ABS(ImpTrades[i].sh - ImpTrades[j].sh) < 0.00005) //
            and (ABS(ImpTrades[i].pr - ImpTrades[j].pr) < 0.00005) //
            and (ImpTrades[i].prf = ImpTrades[j].prf) //
            and (ImpTrades[j].oc <> '') //
            and (i <> j) then begin
            glNumCancelledTrades := glNumCancelledTrades + 2;
            ImpTrades[i].oc := '';
            ImpTrades[i].ls := '';
            ImpTrades[i].tm := '';
            ImpTrades[j].oc := '';
            ImpTrades[j].ls := '';
            ImpTrades[j].tm := '';
            break;
          end; // if ImpTrades
        end; // for j
      end; // for i
    end; // if cancels
    // ------------------------------------------
    result := R;
  finally
    // ReadCobraXLS
  end;
end;


function ReadCobra(): integer;
var
  ImpNextDateOn : boolean;
begin
  ImpNextDateOn := false;
  try
    ImpStrList := TStringList.Create;
    ImpTrades := nil;
    // move to Import.pas, add call to
    // ------------------------
    GetImpStrListFromFile('Cobra', 'csv|xls?', ''); // CSV or XLS/XLSX
    if (sFileType = 'xls') or (sFileType = 'xlsx') then begin
      result := ReadCobraXLS;
    end
    else begin
      result := ReadCobraCSV;
    end;
    // ------------------------
  finally
    ImpStrList.Destroy;
  end;
end; // ReadCobra


         // ------------------------------
         // Curvature Securities - Fields
         // ------------------------------

function ReadCurvatureCSV(): integer;
var
  i, j, k, n, start, eend, R, Q, iFmt : integer;
  iDt, iBS, iTk, iTyp, iShr, iPr, iAmt : integer; // import fields
  line, junk, sep, sTmp, ImpDate, CmStr, feeStr, PrStr, AmtStr, ShStr, typeStr, optDesc, //
    optOC, opYr, opMon, opDay, opStrike, opCP, optTick, oc, ls, errLogTxt, opStrik2, sNote : string;
  Amount, Commis, Fees, Shares, mult : double;
  contracts, Adj, optExpEx, ImpNextDateOn, bonds, newColFormat, miniOptions, futures, //
    bFoundHeader, cancels, assigns : boolean;
  fieldLst : TStrings;
  // ----------------------------------
  procedure ClearFieldNums();
  begin
    iDt := 0;
    iTk := 0;
    iBS := 0;
    iTyp := 0;
    iShr := 0;
    iPr := 0;
    iAmt := 0;
  end;
  // ----------------------------------
  // CSV Fields (2025-04-08)
  //    Trns Id	475156
  //    Account Id	1921
  //    Correspondent	XXXX
  //    Account No	XXXXXXXX
  //    Account Name	John Doe
  //    Master Account No	XXXXXXXX
  //    Eff Settle Date	10/4/23
  //    Broker	Non Broker Dealer
  //    Type	Client
  //    Capacity	Agency
  // DT Eff Trade Date	10/2/23
  // TK Symbol	TSLA
  //    Symbol Description	TESLA INC                      COM
  //    Cusip	88160R101
  // TY Asset Type	E
  //    Created At
  //    System Date
  //    Trade Date
  //    Trade At
  //    Settle Date
  //    Entry Type	TRD
  // BS Side	Sell Short
  // SH Qty	-8
  // PR Price	$242.76
  //    Gross Amt	$1,942.08
  //    Reg Fee	($0.02)
  //    Taf Fee	($0.01)
  // CM Fees	-0.04
  // AM Net Amt	$1,942.04
  //    Description
  //    Batch No	92108572-13A3-43AD-A061-7B151A1370D2
  //    Status	Executed
  //    Created By
  //    Executing Venue	LAMP
  //    External Id
  //    Order Id	231002-111
  //    Vendor	258
  //    Contra Account No	CNS
  //    Commission	($0.01)
  //    Contra Correspondent
  //    Contra Account Id	309
  //    Original Cusip	88160R101
  //    Entry Type Description	Trade Entry
  //    Rep
  //    Branch	CV01
  //    Compress Type
  //    Compress Count	1
  //    Compress Id	0
  //    Trader Id	RA0001
  //    Reference Id
  //    Other Fees
  //    Other Fees2	0
  //    Tax Withholding	0
  // ----------------------------------
  procedure SetFieldNumbers();
  var
    j : integer;
    s : string;
  begin
    // find/map Curvature CSV fields
    k := 0;
    ClearFieldNums;
    // --------------------------------
    // 	DT	EFF TRADE DATE	10/2/23
    // 	TK	SYMBOL    	TSLA
    // 	  	SYMBOL DESCRIPTION	TESLA INC                      COM
    // 	  	CUSIP      	88160R101
    // 	  	ASSET TYPE	E
    // 	TY	ENTRY TYPE	TRD
    // 	BS	SIDE      	Sell Short
    // 	SH	QTY       	-8
    // 	PR	PRICE     	$242.76
    // 	  	GROSS AMT 	$1,942.08
    // 	  	FEES      	-0.04
    // 	AM	NET AMT    	$1,942.04
    // 	  	DESCRIPTION
    // 	  	COMMISSION	($0.01)
    // 	  	ORIGINAL CUSIP	88160R101
    // --------------------------------
    for j := 0 to (fieldLst.Count - 1) do begin
      s := uppercase(trim(fieldLst[j]));
      if (s = 'EFF TRADE DATE') then begin
        iDt := j;
        k := k or 1;
      end
      else if (s = 'SYMBOL') then begin //
        iTk := j;
        k := k or 2;
      end
      else if (s = 'ENTRY TYPE') then begin //
        iTyp := j;
        k := k or 4;
      end
      else if (s = 'SIDE') //
      then begin //
        iBS := j;
        k := k or 8;
      end
      else if s = 'QTY' then begin //
        iShr := j;
        k := k or 16;
      end
      else if s = 'PRICE' then begin //
        iPr := j;
        k := k or 32;
      end
      else if (s = 'NET AMT') then begin //
        iAmt := j;
        k := k or 64;
      end; // if cases
    end; // for j
    s := ''; // this line is just for placing a breakpoint!
  end;
  // ------------------------
  // CALL SQUARE INC CLASS A AT 85.000
  // EXPIRES 01/17/2020 CLOSING VFIFO
  // tk       v
  // PYPL 220211C00125000
  // tick yymmdd^$$$$$...
  // ------------------------
  function DecodeOptTk(var sTk : string) : string;
  var
    n : integer;
    opYr, opMon, opDay, opStrike, opCP, opStrik2 : string;
  begin
    // Reset all local vars
    result := '';
    opStrike := '';
    opStrik2 := '';
    opYr := '';
    opMon := '';
    opDay := '';
    opCP := '';
    // --------------------
    // PYPL 220211C00125000
    // Tick YYMMDDX$$$$$ccc
    // ---------------------
    result := parsefirst(sTk, ' ');
    sTk := trim(sTk); // 2022-03-21 MB - remove extra space(s)
    opYr := copy(sTk, 1, 2);
    opMon := copy(sTk, 3, 2);
    opMon := getExpMo(opMon);
    opDay := copy(sTk, 5, 2);
    opCP := copy(sTk, 7, 1);
    if opCP = 'C' then
      opCP := 'CALL'
    else
      opCP := 'PUT';
    opStrike := copy(sTk, 8, 5);
    opStrik2 := copy(sTk, 13, 3);
    n := strToInt(opStrike);
    opStrike := IntToStr(n); // removes leading zeros
    n := strToInt(opStrik2);
    if (n > 0) then
      opStrike := opStrike + '.' + IntToStr(n);
    opStrike := delTrailingZeros(opStrike); // for matching
    result := result + ' ' + opDay + opMon + opYr + ' ' + opStrike + ' ' + opCP;
  end;
// --------------------------------------------
begin // ReadCurvatureCSV
  bFoundHeader := false; // header not found yet
  // in case these are missing, flag to skip them.
  cancels := false;
  contracts := false;
  R := 0;
  try
    DataConvErrRec := '';
    DataConvErrStr := '';
    Commis := 0;
    ImpNextDateOn := false;
    // --------------------------------
    if ImpStrList.Count < 1 then begin
      ImpStrList.Destroy;
      result := 0;
      exit;
    end;
    fieldLst := TStrings.Create;
    // --------------------------------
    i := -1;
    while i < (ImpStrList.Count - 1) do begin
      inc(i); // make it work like a for/next
      contracts := false; // reset flags
      // ------------------------------
      line := ImpStrList[i];
      line := uppercase(line); // search line for UPPERCASE tokens...
      // ------------------------------
      if pos('"""', line) = 1 then
        line := copy(line, 3);
      // parse all columns into string list
      fieldLst := ParseCSV(line);
      // ------------------------------
      if not bFoundHeader then begin
        if ((pos('EFF TRADE DATE', line) > 0) //
        and (pos('SYMBOL', line) > 0)) //
        then begin // decode header
          SetFieldNumbers;
          if SuperUser then begin
            if (k <> 127) then
              sm('SU, there appear to be fields missing.');
          end;
          bFoundHeader := true; // don't do this anymore
          R := 0; // start now
        end;
        Continue; // don't process anything until we find the header!
      end; // header not found yet
      // ------------------------------
      if pos('ERROR', line) > 0 then begin
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        sm('Centerpoint reported an error.' + cr //
            + 'Please reduce the date range and try again.');
        result := 0;
        exit; // do not try to load any more trades!
      end;
      // --- ticker -------------------
      tick := trim(fieldLst[iTk]);
      if tick = '' then begin
        Continue;
      end;
      // -- PRF = Type/Mult -----------
      typeStr := trim(fieldLst[iTyp]);
      if (typeStr <> 'TRD') then continue;
      typeStr := 'STK-1'; // Make everything a stock
      mult := 1;
      contracts := false;
      // --- Date ---------------------
      ImpDate := fieldLst[iDt]; // format: YYYY-MM-DDT00:00:00-hh:mm
      if (iFmt = 1) then begin
        ImpDate := leftStr(ImpDate, 10); // keep only YYYY-MM-DD
      end;
      if (pos('-', ImpDate) = 5) then begin
        ImpDate := StringReplace(ImpDate, '-', '', [rfReplaceAll]);
        ImpDate := MMDDYYYY(ImpDate); // it comes in yyyy-mm-dd
      end;
      if (pos('/', ImpDate) = 2) then begin
        ImpDate := '0' + ImpDate;
      end;
      if (iFmt = 2) and (pos('/', ImpDate)=0) then begin
        ImpDate := MMDDYYYY(ImpDate); // NEW for iFmt 2
      end;
      if not isdate(ImpDate) then begin
        sm('Cannot determine the transaction date of this trade:' + cr + line);
      end;
      if not ValidTradeDate(ImpDate, ImpDateLast, ImpNextDateOn) then begin
        Continue;
      end;
      if UserDateStrNotGreater(ImpDate, ImpDateLast) then begin
        if mDlg('Trades already imported for ' + ImpDate + cr //
            + cr //
            + 'Continue?', mtWarning, [mbNo, mbYes], 0) = mrNo then begin
          result := R;
          exit;
        end
        else
          ImpDateLast := '01/01/1900';
      end;
      // --- # shares -----------------
      ShStr := fieldLst[iShr];
      ShStr := delCommas(ShStr);
      try
        Shares := CurrToFloat(ShStr);
      except
        Shares := 0;
      end;
      // --- OC and LS --------------------------
      // iBS = buy or sell - for all types
      // iOC = open or close - for OPT types
      // iLS = short or <blank> - for STK types
      oc := 'E'; // default to
      ls := 'E'; // Error
      junk := trim(fieldLst[iBS]);
      sTmp := trim(fieldLst[iBS]);
      sNote := '';
      if (junk = 'SELL') then begin
        oc := 'C';
        ls := 'L';
      end
      else if (junk = 'SELL SHORT') then begin
        oc := 'O';
        ls := 'S';
      end
      else begin
        oc := 'O';
        ls := 'L';
      end; // if junk
      if (oc = 'E') then continue;
      if (ls = 'E') then continue;
      // ------------------------------
      inc(R); // if it gets this far, count it
      // ------------------------------
      if contracts then begin
        if pos('  ', tick) > 1 then
          tick := replacestr(tick, '  ', ' ');
        junk := DecodeOptTk(tick);
        if junk = '' then begin
          dec(R);
          Continue;
        end
        else begin
          tick := junk;
        end;
      end;
      // --- price --------------------
      PrStr := fieldLst[iPr];
      delete(PrStr, pos('$', PrStr), 1);
      PrStr := delCommas(PrStr);
      if (xStrToFloat(PrStr) = 0) then
        PrStr := '0.00';
      AmtStr := fieldLst[iAmt];
      // --- Sanity check! ------------
      try
        Shares := CurrToFloat(ShStr);
        if Shares < 0 then
          Shares := -Shares; // ABS
        Price := CurrToFloat(PrStr);
        if Price < 0 then
          Price := -Price; // ABS
        Amount := ABS(CurrToFloat(AmtStr));
        // --- Commission -------------
        if (((oc = 'O') and (ls = 'L')) //
        or ((oc = 'C') and (ls = 'S'))) then begin
          Commis := Amount - (Shares * Price * mult)
        end
        else begin
          Commis := (Shares * Price * mult) - Amount;
        end;
        // ------ set import record fields ------
        ImpTrades[R].it := TradeLogFile.Count + R;
        ImpTrades[R].DT := ImpDate;
        ImpTrades[R].oc := oc;
        ImpTrades[R].ls := ls;
        ImpTrades[R].tk := tick;
        ImpTrades[R].sh := Shares;
        ImpTrades[R].pr := Price;
        ImpTrades[R].prf := typeStr;
        ImpTrades[R].cm := Commis;
        ImpTrades[R].am := Amount;
        ImpTrades[R].no := sNote;
      except
        // DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        dec(R);
        Continue;
      end;
    end; // while
    // --------------------------------
    ReverseImpTradesDate(R);
    if cancels then begin
      for i := 1 to R do begin
        if (ImpTrades[i].oc = 'X') then
          for j := i + 1 downto 1 do begin
            if (ImpTrades[i].tk = ImpTrades[j].tk) //
              and (ImpTrades[i].sh = ImpTrades[j].sh) //
              and (ImpTrades[i].pr = ImpTrades[j].pr) //
              and (format('%1.2f', [ImpTrades[i].pr], Settings.UserFmt) = format('%1.2f',
                [ImpTrades[j].pr], Settings.UserFmt)) //
              and (ImpTrades[j].oc <> '') //
              and (i <> j) then begin
              glNumCancelledTrades := glNumCancelledTrades + 2;
              ImpTrades[i].oc := '';
              ImpTrades[i].ls := '';
              ImpTrades[j].oc := '';
              ImpTrades[j].ls := '';
              break;
            end;
          end;
      end;
    end;
    for i := 1 to R do begin
      if ImpTrades[i].oc = 'X' then begin
        sm('CANCEL TRADES NOT MATCHED!' + cr + cr +
            'Cancel Trades have Open/Close marked with an "X"');
        break;
      end;
    end;
    result := R;
    ImpStrList.Destroy;
  finally
    contracts := false; // just a place to put a breakpoint
  end;
end; // ReadCenterPointCSV


function ReadCurvature(): integer;
var
  R : integer;
begin
  try
    R := 0;
    ImpStrList := TStringList.Create;
    ImpTrades := nil;
    setLength(ImpTrades, R + 1);
    GetImpDateLast;
    // ----------------------
    if FileExists(Settings.ImportDir + '\download.csv') then
      deleteFile(Settings.ImportDir + '\download.csv');
    // ----------------------
    GetImpStrListFromFile('*', 'csv', ''); // from CSV file only
    result := ReadCurvatureCSV;
    // ----------------------
    exit;
  finally
    // DONE
  end;
end; // ReadCurvatureCSV


         // ---------------------------
         // Regal
         // ---------------------------

function ReadeRegal(): integer;
var
  i, j, R : integer;
  ImpDate, CmStr, PrStr, prfStr, AmtStr, ShStr, line, line2, line3, sep : string;
  Amount, Commis, Shares, mult : double;
  unknown, cancels, ImpNextDateOn, contracts : boolean;
  oc, ls : string;
begin
  try
    // NOTE: eRegal uses Investrade import filter
    DataConvErrRec := '';
    DataConvErrStr := '';
    Commis := 0;
    R := 0;
    cancels := false;
    ImpNextDateOn := false;
    ImpStrList := TStringList.Create;
    ImpTrades := nil;
    setLength(ImpTrades, R + 1);
    GetImpDateLast;
    // Web Import -
    GetImpStrListFromClip(false);
    if ImpStrList.Count < 1 then begin
      ImpStrList.Destroy;
      result := 0;
      exit;
    end;
    // ------------
    for i := 0 to ImpStrList.Count - 1 do begin
      contracts := false;
      unknown := false;
      inc(R);
      if R < 1 then R := 1;
      line := trim(ImpStrList[i]);
      if pos(TAB, line) > 0 then
        sep := TAB
      else
        sep := ' ';
      ImpDate := trim(copy(line, 1, pos(sep, line) - 1));
      if (pos('/', ImpDate) <> 3) and (pos('/', ImpDate) <> 2) then begin
        dec(R);
        if (i = ImpStrList.Count - 1) and (R = 0) then begin
          if ImpNextDateOn then begin
            sm('No transactions later than ' + ImpDateLast);
          end
          else begin
            DataConvErrRec := 'No Data Selected';
            sm('eRegal Import Error' + cr + cr + 'Please reselect entire report');
          end;
          result := 0;
          exit;
        end;
        Continue;
      end;
      ImpDate := LongDateStr(ImpDate);
      if not ValidTradeDate(ImpDate, ImpDateLast, ImpNextDateOn) then begin
        dec(R);
        Continue;
      end;
      // delete trade date
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // delete settle date
      delete(line, 1, pos(sep, line));
      line := trim(line);
      line := trim(lowercase(line));
      // open / close
      oc := copy(line, 1, pos(sep, line));
      if (pos('sold', oc) > 0) or (pos('sell', oc) > 0) then begin
        if (pos('cancel', oc) > 0) then begin
          cancels := true;
          oc := 'X';
        end
        else begin
          oc := 'C';
        end;
      end
      else if (pos('bought', oc) > 0) or (pos('buy', oc) > 0) then begin
        if (pos('cancel', oc) > 0) then begin
          cancels := true;
          oc := 'X';
        end
        else begin
          oc := 'O';
        end;
      end
      else if (pos('unknown', oc) > 0) then begin
        unknown := true;
        oc := 'C';
      end
      else begin
        dec(R);
        Continue;
      end;
      ls := 'L';
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // delete margin
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // ticker
      tick := trim(copy(line, 1, pos(sep, line)));
      tick := uppercase(tick);
      delete(line, 1, pos(sep, line));
      // options
      if (pos('call', line) > 0) or (pos('put', line) > 0) then
        contracts := true;
      //
      if i + 1 <= ImpStrList.Count - 1 then
        line2 := trim(ImpStrList[i + 1])
      else
        line2 := '';
      //
      if i + 2 <= ImpStrList.Count - 1 then
        line3 := trim(ImpStrList[i + 2])
      else
        line3 := '';
      //
      AmtStr := parseLast(line, sep);
      if IsFloat(AmtStr) then begin
        // if IsFloatEx(AmtStr,ImportFmt) then begin
        PrStr := parseLast(line, sep);
        ShStr := parseLast(line, sep);
      end
      else if (pos('/', line2) <> 3) and ((pos('/', line3) = 3) or (line3 = '')) then begin
        AmtStr := parseLast(line2, sep);
        PrStr := parseLast(line2, sep);
        ShStr := parseLast(line2, sep);
      end
      else if (pos('/', line2) <> 3) and (pos('/', line3) <> 3) then begin
        AmtStr := parseLast(line3, sep);
        PrStr := parseLast(line3, sep);
        ShStr := parseLast(line3, sep);
      end
      else begin
        PrStr := parseLast(line, sep);
        ShStr := parseLast(line, sep);
      end;
      delete(ShStr, pos(',', ShStr), 1);
      delete(ShStr, pos('-', ShStr), 1);
      if unknown and (pos('-', AmtStr) > 0) then
        oc := 'O';
      // comm
      // Todd Flora - Change from custom DP field
      // to standard decimal seperator field
      // Old Line: CmStr:= '0'+ Settings.UserFmt.DecmlSep + '00';
      CmStr := '0' + Settings.UserFmt.DecimalSeparator + '00';
      if contracts then begin
        prfStr := 'OPT-100';
        mult := 100;
      end
      else begin
        prfStr := 'STK-1';
        mult := 1;
      end;
      try
        ImpTrades[R].it := TradeLogFile.Count + R;
        ImpTrades[R].DT := ImpDate;
        ImpTrades[R].oc := oc;
        ImpTrades[R].ls := ls;
        ImpTrades[R].tk := tick;
        Price := FracDecToFloat(PrStr);
        Amount := CurrToFloat(AmtStr);
        if Amount < 0 then Amount := -Amount;
        Shares := StrToFloat(ShStr, Settings.InternalFmt);
        if oc = 'O' then begin
          Commis := Amount - (Shares * Price * mult);
        end
        else if oc = 'C' then begin
          Commis := (Shares * Price * mult) - Amount;
        end;
        ImpTrades[R].sh := Shares;
        ImpTrades[R].pr := Price;
        ImpTrades[R].prf := prfStr;
        ImpTrades[R].cm := Commis;
        ImpTrades[R].am := Amount;
      except
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        dec(R);
        Continue;
      end;
    end;
    if R > 1 then
      if xStrToDate(ImpTrades[1].DT) > xStrToDate(ImpTrades[R].DT) then
        ReverseImpTradesDate(R);
    if cancels then begin
      for i := 1 to R do begin
        if (ImpTrades[i].oc = 'X') then
          for j := i downto 1 do begin
            if (ImpTrades[i].tk = ImpTrades[j].tk) //
            and (ImpTrades[i].sh = ImpTrades[j].sh) //
            and (ImpTrades[i].pr = ImpTrades[j].pr) //
            and (ImpTrades[j].oc <> '') //
            and (i <> j) then begin
              glNumCancelledTrades := glNumCancelledTrades + 2;
              ImpTrades[i].oc := '';
              ImpTrades[i].ls := '';
              // j
              ImpTrades[j].oc := '';
              ImpTrades[j].ls := '';
              break;
            end;
          end;
      end;
    end;
    for i := 1 to R do begin
      if ImpTrades[i].oc = 'X' then begin
        sm('CANCEL TRADES NOT MATCHED!' + cr + cr +
            'Cancel Trades have Open/Close marked with an "X"');
        break;
      end;
    end;
    result := R;
    ImpStrList.Destroy;
  finally
    // ReadeRegal
  end;
end;


         // ---------------------------
         // E*Trade
         // ---------------------------

function ReadEtradeXLSyearEnd(ImpStrList : TStringList): integer;
var
  i, j, p, R : integer;
  ImpDate, opTick, opUnder, opStrike, opDay, opMon, opYr, opCP, PrStr, prfStr, AmtStr, comStr,
    ShStr, line, sep, junk, NextDate, descr : string;
  Shares, Amount, Commis, Net, mult : double;
  contracts, cancels, ImpNextDateOn, divReinv, newOptFormat : boolean;
  oc, ls : string;
label
  EtradeCSVimp;
begin
  try
    DataConvErrRec := '';
    DataConvErrStr := '';
    Commis := 0;
    Net := 0;
    R := 0;
    EtradeXLS := true;
    cancels := false;
    ImpNextDateOn := false;
    if ImpStrList.Count < 1 then begin
      result := 0;
      exit;
    end;
    // --------------------------------
    for i := 0 to ImpStrList.Count - 1 do begin
      inc(R);
      if R < 1 then R := 1;
      StatBar('Reading: ' + IntToStr(R));
      contracts := false;
      opTick := '';
      divReinv := false;
      sep := ',';
      descr := '';
      line := ImpStrList[i];
      // date
      ImpDate := trim(copy(line, 1, pos(sep, line) - 1));
      line := trim(line);
      delete(line, 1, pos(sep, line));
      if ((pos('/', ImpDate) <> 2) and (pos('/', ImpDate) <> 3)) then begin
        dec(R);
        Continue;
      end;
      ImpDate := LongDateStr(ImpDate);
      if not ValidTradeDate(ImpDate, ImpDateLast, ImpNextDateOn) then begin
        dec(R);
        Continue;
      end;
      // try
      // ImpDate:= LongDateStr(Impdate);
      // if UserDateStrNotGreater(ImpDate,ImpDateLast) then begin
      // if ImpNextDateOn then begin
      // dec(R);
      // continue;
      // end;
      // NextDate:= NextUserDateStr(ImpDateLast);

      // if mDlg('Trades already imported up to '+ ImpDateLast + cr+cr +
      // 'Do you wish to import from ' +NextDate+ ' onward?'+cr+cr+
      // 'Click YES to skip all trades prior to '+NextDate+cr+cr+
      // 'Click NO to import all of the dates on this page',
      // mtWarning,[mbNo,mbYes],0) = mrNo then
      // ImpDateLast:= '01/01/1900'
      // else begin
      // ImpNextDateOn:= true;
      // dec(R);
      // continue;
      // end;
      // end;
      // except
      // end;
      // ----------
      // open/close
      oc := trim(copy(line, 1, pos(sep, line) - 1));
      // 3-1-07 do not import expires and assigns
      // because we don't know if short or lomg!!!
      if (pos('Option Expire', oc) > 0) or (pos('Option Assignment', oc) > 0) then begin
        dec(R);
        Continue;
      end;
      if (pos('Buy Open', oc) > 0) or (pos('Buy To Open', oc) > 0) then begin
        oc := 'O';
        ls := 'L';
        contracts := true;
      end
      else if pos('Sell To Close', oc) > 0 then begin
        oc := 'C';
        ls := 'L';
        contracts := true;
      end
      else if (pos('Sell Open', oc) > 0) or (pos('Sell To Open', oc) > 0) then begin
        oc := 'O';
        ls := 'S';
        contracts := true;
      end
      else if pos('Buy To Close', oc) > 0 then begin
        oc := 'C';
        ls := 'S';
        contracts := true;
      end
      else if pos('Expire', oc) > 0 then begin
        oc := 'C';
        ls := 'L';
        contracts := true;
      end
      else if pos('Cancel ', oc) > 0 then begin
        if pos('COVER SHORT', line) > 0 then begin
          // OC:= 'C';
          oc := 'X';
          ls := 'S';
        end
        else if pos('Buy', oc) > 0 then begin
          // OC:= 'O';
          oc := 'X';
          ls := 'L';
        end
        else if pos('SHORT', line) > 0 then begin
          // OC:= 'O';
          oc := 'X';
          ls := 'S';
        end
        else if pos('Sell', oc) > 0 then begin
          // OC:= 'C';
          oc := 'X';
          ls := 'L';
        end;
        // ImpTrades[R].no:= 'cancel';
        cancels := true;
        if (pos('CALL ', line) > 0) or (pos('PUT ', line) > 0) then
          contracts := true;
      end
      else if pos('Sell Short', oc) > 0 then begin
        oc := 'O';
        ls := 'S';
      end
      else if pos('Buy To Cover', oc) > 0 then begin
        oc := 'C';
        ls := 'S';
      end
      else if (pos('Buy', oc) > 0) or (pos('BUY', oc) > 0) then begin
        oc := 'O';
        ls := 'L';
      end
      else if pos('Sell', oc) > 0 then begin
        oc := 'C';
        ls := 'L';
      end
      else begin
        dec(R);
        Continue;
      end;
      if (pos('STK SPLIT', line) > 0) then begin
        dec(R);
        Continue;
      end;
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // ticker
      tick := trim(copy(line, 1, pos(sep, line) - 1));
      delete(tick, pos('-', tick), 1);
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // delete cusip
      junk := trim(copy(line, 1, pos(sep, line) - 1));
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // descr in quotes
      descr := '';
      if pos('"', line) > 0 then begin
        descr := trim(copy(line, 1, pos('",', line) - 1));
        // delete all quotes
        while pos('"', descr) > 0 do
          delete(descr, pos('"', descr), 1);
        // delete all commas
        while pos(',', descr) > 0 do
          delete(descr, pos(',', descr), 1);
        delete(line, 1, pos('",', line));
        // sm(descr);
      end;
      // options
      if contracts then begin
        opTick := tick;
        if descr <> '' then
          tick := uppercase(descr)
        else
          tick := trim(copy(line, 1, pos(sep, line) - 1));
        // delete all quotes
        while pos('"', tick) > 0 do
          delete(tick, pos('"', tick), 1);
        if (pos(' CALL ', tick) > 0) or (pos(' PUT', tick) > 0) or (pos(' CALL(', tick) > 0) or
          (pos(' PUT(', tick) > 0) then begin // new format
          // 2  SOJ Jan 16 '10  $31 Call (SPY)   PROSHARES TR PSHS ULT S&P 500 COVER SHORT
          if isInt(leftStr(tick, 1)) then
            delete(tick, 1, pos(' ', tick));
          tick := trim(tick);
          opUnder := parsefirst(tick, ' ');
          tick := trim(tick);
          opMon := parsefirst(tick, ' ');
          tick := trim(tick);
          opDay := parsefirst(tick, ' ');
          tick := trim(tick);
          opYr := parsefirst(tick, ' ');
          tick := trim(tick);
          delete(opYr, pos('''', opYr), 1);
          opStrike := parsefirst(tick, ' ');
          tick := trim(tick);
          delete(opStrike, pos('$', opStrike), 1);
          opCP := parsefirst(tick, ' ');
          tick := trim(tick);
          if pos('(', opCP) > 0 then begin
            opUnder := parseLast(opCP, '(');
            delete(opUnder, pos(')', opUnder), 1);
          end;
          tick := opUnder + ' ' + opDay + opMon + opYr + ' ' + opStrike + ' ' + opCP;
        end
        else if (pos('CALL ', tick) = 1) or (pos('PUT', tick) = 1) then begin
        // old format
          // added for Harris garbage
          if (pos('    100', tick) > 0) then
            delete(tick, pos('    100', tick), 7);
          // delete Etrade crap
          p := pos('-', tick);
          if p > 0 then begin
            delete(tick, p, 1);
            insert(' ', tick, p);
          end;
          if pos('COVER SHORT', tick) > 0 then
            delete(tick, pos('COVER SHORT', tick), 11);
          tick := trim(tick);
          if pos('CLOSING CONTRACT', tick) > 0 then
            delete(tick, pos('CLOSING CONTRACT', tick), 16);
          tick := trim(tick);
          if pos('AMEX', tick) > 0 then
            delete(tick, pos('AMEX', tick), 4);
          tick := trim(tick);
          if pos('CBOE', tick) > 0 then
            delete(tick, pos('CBOE', tick), 4);
          tick := trim(tick);
          if pos(' SHORT', tick) > 0 then
            delete(tick, pos(' SHORT', tick), 6);
          tick := trim(tick);
          if pos('LONG TERM OPTIONS ', tick) > 0 then
            delete(tick, pos('LONG TERM OPTIONS ', tick), 18);
          tick := trim(tick);
          if pos('ADJ CASH DIVIDEND', tick) > 0 then
            delete(tick, pos('ADJ CASH DIVIDEND', tick), 17);
          tick := trim(tick);
          opYr := ParseLastN(tick, '/');
          opYr := copy(opYr, 3, 2);
          junk := ParseLastN(tick, 'PBW EXP');
          tick := trim(tick);
          junk := ParseLastN(tick, 'EXP');
          tick := trim(tick);
          // sm(tick+cr+junk);
          // double when stock split info
          junk := ParseLastN(tick, 'EXP');
          tick := trim(tick);
          // sm(tick+cr+junk);
          junk := ParseLastN(tick, 'ADJ ');
          tick := trim(tick);
          if pos('*', tick) > 0 then begin
            junk := parseLast(tick, '*');
            while pos('*', tick) > 0 do
              delete(tick, pos('*', tick), 1);
          end;
          tick := trim(tick);
          opCP := copy(tick, 1, pos(' ', tick) - 1);
          delete(tick, 1, pos(' ', tick));
          // sm(opCP);
          if pos('DEL :', tick) > 0 then
            tick := trim(copy(tick, 1, pos('DEL :', tick) - 1));
          // sm(tick);
          opStrike := ParseLastN(tick, ' ');
          // sm(opStrike+cr+tick);
          // fix for no space between month and strike
          if not IsFloat(opStrike) then begin
            // if not IsFloatEx(opStrike,ImportFmt) then begin
            opMon := copy(opStrike, 1, 3);
            delete(opStrike, 1, 3);
          end
          else
            opMon := ParseLastN(tick, ' ');
          while pos('0', opStrike) = 1 do
            delete(opStrike, 1, pos('0', opStrike));
          opUnder := tick;
          if tick <> '' then
            opUnder := tick;
          tick := opUnder + ' ' + opMon + opYr + ' ' + opStrike + ' ' + opCP;
          // delete all double spaces
          while pos('  ', tick) > 0 do
            delete(tick, pos('  ', tick), 1);
        end
        else begin
          while pos('  ', tick) > 0 do
            delete(tick, pos('  ', tick), 1);
          delete(tick, 1, pos(' ', tick) - 1);
          // added for the following format: NORTHFIELD LABORATORIES INC JAN (2007) 20  CALL
          if (pos(' (20', tick) > 0) and (pos(') ', tick) > 0) then begin
            // for long stock tickers
            if (pos(' (20', tick) > 26) then begin
              p := pos(' (20', tick);
              delete(tick, 26, p - 30);
            end;
            delete(tick, pos(' (20', tick), 4);
            delete(tick, pos(') ', tick), 1);
          end
          else
            junk := parseLast(tick, '(');
          tick := trim(tick);
          // sm(tick);
          delete(tick, pos('-', tick), 1);
          delete(tick, pos('$', tick), 1);
          if pos('CALLS', tick) > 0 then
            delete(tick, pos('CALLS', tick) + 4, 1);
          if pos('PUTS', tick) > 0 then
            delete(tick, pos('PUTS', tick) + 3, 1);
          // sm(tick);
        end;
      end;
      // stock splits - do not import
      if pos('STK SPLIT ON', line) > 0 then begin
        sm('Stock split for ticker: ' + tick + cr + cr //
          + 'Please adjust for this after the import');
        dec(R);
        Continue;
      end;
      // spin offs - import but alert user
      if pos('SPINOFF', line) > 0 then begin
        sm('Stock spinoff for ticker: ' + tick + cr + cr //
          + 'Please adjust for this after the import');
        dec(R);
        Continue;
      end;
      // dividend reinvestments
      if descr = '' then
        descr := trim(copy(line, 1, pos(sep, line) - 1));
      if (pos('REIN @', descr) > 0) then begin
        delete(descr, 1, pos('REIN @', descr) + 6);
        descr := trim(descr);
        if pos(' ', descr) > 0 then
          descr := trim(copy(descr, 1, pos(' ', descr) - 1));
        divReinv := true;
      end
      else if (pos('REINVEST PRICE ', descr) > 0) then begin
        delete(descr, 1, pos('REINVEST PRICE', descr) + 15);
        descr := trim(descr);
        delete(descr, 1, pos('$', descr));
        descr := trim(descr);
        if pos(' ', descr) > 0 then
          descr := trim(copy(descr, 1, pos(' ', descr) - 1));
        divReinv := true;
      end;
      // delete description
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // shares
      ShStr := trim(copy(line, 1, pos(sep, line) - 1));
      ShStr := DelParenthesis(ShStr);
      delete(ShStr, pos(',', ShStr), 1);
      delete(line, 1, pos(sep, line));
      // do not import cancels with no number of shares
      if (oc = 'X') and (ShStr = '0') then begin
        dec(R);
        Continue;
      end;
      // price
      PrStr := trim(copy(line, 1, pos(sep, line) - 1));
      if (PrStr = '0') and divReinv then begin
        PrStr := descr;
      end;
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // comm
      comStr := trim(copy(line, 1, pos(sep, line) - 1));
      delete(line, 1, pos(sep, line));
      line := trim(line);
      if pos('N/A', comStr) > 0 then
        comStr := '0.00';
      // amount
      AmtStr := line;
      try
        Shares := StrToFloat(ShStr, Settings.InternalFmt);
        Price := FracDecToFloat(PrStr);
        Amount := FracDecToFloat(AmtStr);
        if contracts then begin
          mult := 100;
          prfStr := 'OPT-100';
        end
        else begin
          mult := 1;
          prfStr := 'STK-1';
        end;
        // comm
        if ((oc = 'O') and (ls = 'L')) or ((oc = 'C') and (ls = 'S')) then
          Commis := Amount - (Shares * Price * mult)
        else if ((oc = 'C') and (ls = 'L')) or ((oc = 'O') and (ls = 'S')) then
          Commis := (Shares * Price * mult) - Amount;
        if divReinv then begin
          Commis := 0;
          Amount := 0;
        end;
        if Commis < 0 then Commis := -Commis;
        ImpTrades[R].it := TradeLogFile.Count + R;
        ImpTrades[R].DT := ImpDate;
        ImpTrades[R].tm := '';
        ImpTrades[R].oc := oc;
        ImpTrades[R].ls := ls;
        ImpTrades[R].tk := tick;
        ImpTrades[R].sh := Shares;
        ImpTrades[R].pr := Price;
        ImpTrades[R].prf := prfStr;
        ImpTrades[R].cm := Commis;
        ImpTrades[R].am := Amount;
        ImpTrades[R].opTk := opTick;
      except
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        dec(R);
        Continue;
      end;
    end; // for
    SortImpByDateOC(1, R);
    if cancels then begin
      for i := 1 to R do begin
        for j := R downto 1 do begin
          if (ImpTrades[i].oc = 'X') and (xStrToDate(ImpTrades[i].DT) >= xStrToDate(ImpTrades[j].DT)
            ) and (ImpTrades[i].tk = ImpTrades[j].tk) and
            (format('%1.5f', [ImpTrades[i].sh], Settings.UserFmt) = format('%1.5f',
              [ImpTrades[j].sh], Settings.UserFmt)) and
            (format('%1.5f', [ImpTrades[i].pr], Settings.UserFmt) = format('%1.5f',
              [ImpTrades[j].pr], Settings.UserFmt)) and
            (format('%1.2f', [ImpTrades[i].am], Settings.UserFmt) = format('%1.2f',
              [ImpTrades[j].am], Settings.UserFmt)) and (ImpTrades[i].prf = ImpTrades[j].prf) and
            (ImpTrades[j].oc <> '') and (ImpTrades[i].ls = ImpTrades[j].ls) and (i <> j) then begin
            // sm(floattostr(ImpTrades[j].sh,Settings.UserFmt)+'  '+floattostr(ImpTrades[j].pr,Settings.UserFmt)+'  '+floattostr(ImpTrades[j].am,Settings.UserFmt));
            StatBar('Matching Cancelled Trades: ' + ImpTrades[i].DT);
            glNumCancelledTrades := glNumCancelledTrades + 2;
            ImpTrades[i].oc := '';
            ImpTrades[i].ls := '';
            ImpTrades[i].tm := '';
            // jth
            ImpTrades[j].oc := '';
            ImpTrades[j].ls := '';
            ImpTrades[j].tm := '';
            break;
          end;
        end;
      end;
    end;
    result := R;
  finally
    // ReadEtradeXLSyearEnd
  end;
end;


// ----------------------------------------------
function ReadEtradeXLS(ImpStrList : TStringList): integer;
var
  i, j, p, R : integer;
  iDt, iOC, iLS, iTyp, iTk, iShr, iPr, iAmt, iComm, iDesc : integer; // import field numbers
  sTmp, ImpDate, opTick, opUnder, opStrike, opYr, opMon, opDay, opCP, PrStr, prfStr, AmtStr, comStr,
    ShStr, line, sep, junk, NextDate, descr, secType : string;
  Shares, Amount, Commis, Net, mult : double;
  contracts, cancels, ImpNextDateOn, divReinv : boolean;
  oc, ls, sqYr, Y202 : string;
  lineLst : TStrings; // for parsing individual lines
  // ------------------------
  procedure SetFieldNumbers;
  begin
    // TransactionDate,TransactionType,SecurityType,Symbol,Quantity,Amount,Price,Commission,Description
    // 0               1               2            3      4        5      6     7          8
    // ETrade:
    // 2/5/2016, Bought, EQ, GIMO, 200, -4831.99,24.11,9.99, GIGAMON INC                   COM
    // 08/08/17, Bought To Cover, OPTN, RUTW Aug 31 '17 $1425 Call, 3, -3124.56, 10.41, 1.5, RUT Aug 31 '17 $1425 Call
    // OptionHouse:
    // 07/21/17, Bought, EQ, VXX, 200, -2244.95, 11.2, 4.95, Bought 200 VXX (IPATH S&P 500 VIX SHORT-TERM FUTURES ETN)@ 1
    // 08/04/17, Sold Short, OPTN, RUT----170831P01410000, -3, 5721.84, 19.08, 2.16, Short 3 RUT Aug 31 '17 $1410 Put (RUT)@ 19.080000
    iDt := 0; // m/d/yyyy OR mm/dd/yy
    iOC := 1;
    iLS := 1;
    iTyp := 2; // EQ = STK, OPTN = OPT
    iTk := 3; // 2 Option Ticker formats
    iShr := 4;
    iAmt := 5;
    iPr := 6;
    iComm := 7;
    iDesc := 8;
  end;
  // ------------------------
  function ReadDate(sDate : string) : string;
  var
    lstDateParts : TStrings;
    sMM, sDD, sYY : string;
  begin
    result := ''; // default
    // note: auto-detect date format
    if (pos('/', sDate) > 0) then begin
      lstDateParts := ParseCSV(sDate, '/');
    end
    else if (pos('-', sDate) > 0)then begin
      lstDateParts := ParseCSV(sDate, '-')
    end
    else begin
      exit; // not a valid date
    end;
    if lstDateParts = nil then
      exit; // error
    if lstDateParts.Count <> 3 then
      exit; // error
    sMM := lstDateParts[0];
    sDD := lstDateParts[1];
    sYY := lstDateParts[2];
    // ----------------------
    if length(sMM) = 4 then begin // it's YYYY-MM-DD format!
      sYY := lstDateParts[0];
      sMM := lstDateParts[1];
      sDD := lstDateParts[2];
    end;
    // ----------------------
    if (strToInt(sMM) > 12) then begin // it's DD-MM-YYYY format!
      sDD := lstDateParts[0];
      sMM := lstDateParts[1];
      sYY := lstDateParts[2];
    end;
    // ----------------------
    if length(sMM) = 1 then
      sMM := '0' + sMM;
    if length(sDD) = 1 then
      sDD := '0' + sDD;
    if length(sYY) = 2 then
      sYY := '20' + sYY;
    // ----------------------
    result := sMM + '/' + sDD + '/' + sYY; // internal format
  end;
  // ------------------------
  procedure DecodeOCLS(sTrans : string);
  begin
    // note: sets variables OC and LS directly
    oc := '';
    ls := '';
    if (pos('BUY TO OPEN', sTrans) = 1) or (pos('BOUGHT TO OPEN', sTrans) = 1) then begin
      oc := 'O';
      ls := 'L';
    end
    else if (pos('SELL TO CLOSE', sTrans) = 1) or (pos('SOLD TO CLOSE', sTrans) = 1) then begin
      oc := 'C';
      ls := 'L';
    end
    else if (pos('SELL TO OPEN', sTrans) = 1) //
      or (pos('SOLD SHORT', sTrans) = 1) //
      or (pos('SOLD OPEN', sTrans) = 1) //
      or (pos('SOLD TO OPEN', sTrans) = 1) //
    then begin
      oc := 'O';
      ls := 'S';
    end
    else if (pos('BUY TO CLOSE', sTrans) = 1) //
      or (pos('BOUGHT TO COVER', sTrans) = 1) //
      or (pos('BOUGHT TO CLOSE', sTrans) = 1) //
    then begin
      oc := 'C';
      ls := 'S';
    end
    else if pos('EXPIRE', sTrans) > 0 then begin
      oc := 'C';
      ls := 'L';
      contracts := true;
    end
    else if pos('CANCEL', sTrans) > 0 then begin
      oc := 'X';
      ls := 'L';
      cancels := true;
    end
    else if (pos('DIVIDEND', sTrans) > 0) //
      and (pos('CASH DIV', line) = 0) then begin
      oc := 'O';
      ls := 'L';
      divReinv := true;
    end
    else if (pos('BOUGHT', sTrans) = 1) //
      or (pos('BUY', sTrans) = 1) then begin
      oc := 'O';
      ls := 'L';
    end
    else if (pos('SOLD', sTrans) = 1) //
      or (pos('SELL', sTrans) = 1) then begin
      oc := 'C';
      ls := 'L';
    end;
  end;
  // ------------------------
  function DecodeOptTk(sTk : string) : string;
  var
    sTemp : string;
    n, m : integer;
    lstOptTkParts : TStrings; // for parsing Option Tickers
  begin
    // Reset all local vars
    opTick := '';
    opUnder := '';
    opStrike := '';
    opYr := '';
    opMon := '';
    opDay := '';
    opCP := '';
    // auto-detect format:
    // Symbol: RUTW Aug 31 '17 $1425 Call  RUT----170831P01410000
    // Descr:  RUT Aug 31 '17 $1425 Call   RUT Aug 31 '17 $1410 Put
    // ---------------------  --------------------
    // Aug 31 '17 $1425 Call  17 08 31 P 01410 000
    // MMM DD  YY  $$$$ XXXX  YY MM DD X $$$$$.$$$
    // ---------------------  --------------------
    // Tickr    RUTW				  RUT
    // ExpDate  Aug 31 '17    170831     = 31AUG17
    // Strike$  1425          1410
    // CallPut  CALL          PUT
    // ---------------------  --------------------
    // RUT 31AUG17 1425 CALL  RUT 31AUG17 1410 PUT
    // ---------------------  --------------------
    if (pos('--', sTk) > 1) then begin // MB - reduced from 4 dashes to 2.
      // Symbol: RUT----170831P01410000
      // Descr:  RUT Aug 31 '17 $1410 Put
      m := pos('--', sTk)- 1;
      opUnder := copy(sTk, 1, m);
      m := m + 1;
      if length(sTk) > 8 then
        while (sTk[m] = '-') and (m < 8) do
          m := m + 1;
      sTemp := copy(sTk, m);
// delete(sTemp, 1, pos('----', sTk)+ 3);
      opTick := opUnder + ' ' + sTemp;
      opYr := copy(sTemp, 1, 2);
      opMon := copy(sTemp, 3, 2);
      opMon := getExpMo(opMon);
      opDay := copy(sTemp, 5, 2);
      opCP := copy(sTemp, 7, 1);
      if opCP = 'C' then
        opCP := 'CALL'
      else
        opCP := 'PUT';
      opStrike := copy(sTemp, 8, 5);
      n := strToInt(opStrike);
      opStrike := IntToStr(n); // removes leading zeros
      delete(sTemp, 1, 12);
      n := strToInt(sTemp);
      if (n > 0) then
        opStrike := opStrike + '.' + IntToStr(n);
    end
    else if (pos(' ', sTk) > 0) then begin
      // Symbol: RUTW Aug 31 '17 $1425 Call
      // Descr:  RUT Aug 31 '17 $1425 Call
      opTick := sTk;
      lstOptTkParts := ParseCSV(sTk, ' ');
      opUnder := lstOptTkParts[0];
      opMon := lstOptTkParts[1];
      opDay := lstOptTkParts[2];
      opYr := lstOptTkParts[3];
      if (length(opYr) > 2) then
        opYr := rightStr(opYr, 2)
      else if (length(opYr) <> 2) then
        opYr := '';
      opStrike := lstOptTkParts[4];
      if leftStr(opStrike, 1) = '$' then
        delete(opStrike, 1, 1);
      opCP := lstOptTkParts[5];
    end
    else begin
      result := sTk; // return unchanged to indicate the problem
      exit;
    end;
    opStrike := delTrailingZeros(opStrike); // 2017-10-09 MB Remove trailing zeros for matching
    result := opUnder + ' ' + opDay + opMon + opYr + ' ' + opStrike + ' ' + opCP;
  end;
// ------------------------
begin // ReadEtradeXLS
  sqYr := ' ' + chr(39) + '2';
  Y202 := ' 202';
  try
    DataConvErrRec := '';
    DataConvErrStr := '';
    Commis := 0;
    Net := 0;
    R := 0;
    EtradeXLS := true;
    cancels := false;
    ImpNextDateOn := false;
    if ImpStrList.Count < 1 then begin
      result := 0;
      exit;
    end;
    // ------------------------------------------
    // test if year end Excel file
    // ------------------------------------------
    for i := 0 to ImpStrList.Count - 1 do begin
      line := ImpStrList[i];
      if pos('Trade Date,Order Type,Security,Cusip', line) > 0 then begin
        result := ReadEtradeXLSyearEnd(ImpStrList); // year-end file
        exit;
      end
      else if pos('TransactionDate,TransactionType,SecurityType,', line) = 1 then begin
        break; // the default CSV file
      end;
    end;
    // ------------------------------------------
    // TransactionDate,TransactionType,SecurityType,Symbol,Quantity,Amount,Price,Commission,Description
    // ------------------------------------------
    SetFieldNumbers;
    for i := 0 to (ImpStrList.Count - 1) do begin
      line := ImpStrList[i];
      line := trim(line);
      if line = '' then
        Continue;
      lineLst := ParseCSV(line);
      // lineLst := parseCSV(line, ',', '"');
      // --------------------
      // reset local vars
      // --------------------
      mult := 1;
      tick := '';
      opTick := '';
      contracts := false;
      divReinv := false;
      // --------------------
      // date
      // --------------------
      // [iDt] Trade Date
      sTmp := lineLst[iDt];
      ImpDate := ReadDate(sTmp);
      if ImpDate = '' then Continue;
      if not ValidTradeDate(ImpDate, ImpDateLast, ImpNextDateOn) then Continue;
      inc(R); // otherwise assume we have another valid record (for now)
      if R < 1 then R := 1;
      StatBar('Reading: ' + IntToStr(R));
      // --------------------
      // [iOC] open/close
      sTmp := trim(uppercase(lineLst[iOC]));
      // DE: do not import expires and assigns because we don't know if short or lomg!!!
      if (pos('OPTION EXPIRE', sTmp) > 0) //
      or (pos('OPTION ASSIGNMENT', sTmp) > 0) //
      then begin
        dec(R);
        Continue;
      end;
      if (pos('DIVIDEND', sTmp) > 0) then begin
        if (pos('CASH DIV', line) = 0) then begin
          oc := 'O';
          ls := 'L';
          divReinv := true;
        end
        else begin
          dec(R); // skip it
          Continue;
        end;
      end
      else begin
        DecodeOCLS(sTmp);
        if oc = '' then begin
          dec(R);
          Continue;
        end;
      end;
      // --------------------
      // [iTyp] SecurityType
      sTmp := trim(uppercase(lineLst[iTyp]));
      if (sTmp = 'MMF') then begin // ---------------------------- MONEY MARKET
        // do not import Money Market Funds
        dec(R);
        Continue;
      end
      else if (sTmp = 'EQ') then begin // ------------------------------- STOCK
        contracts := false;
        tick := trim(uppercase(lineLst[iTk])); // ticker
      end
      else if (sTmp = 'OPTN') then begin // ---------------------------- OPTION
        contracts := true;
        // [iDes] SecurityType
        sTmp := trim(uppercase(lineLst[iTk]));
        tick := DecodeOptTk(sTmp);
      end
      else if (sTmp = 'MF') then begin // ------------------------- MUTUAL FUND
        contracts := false; // use lookup table for type-mult
        tick := trim(uppercase(lineLst[iTk])); // ticker
      end
      else if (sTmp = '') then begin // -------------------------- Not specified
        contracts := false; // this is a special for Larry Ashton 2022-03-04
        tick := trim(uppercase(lineLst[iTk])); // ticker
        if pos('CALL', tick) > 1 then
          contracts := true
        else if pos('PUT', tick) > 1 then
          contracts := true;
      end
      else begin
        contracts := false;
      end;
      if pos(sqYr, tick) > 0 then begin // found single quote
        sTmp := replacestr(tick, sqYr, Y202);
        tick := DecodeOptTk(sTmp);
      end;
      // --------------------
      // [iShr] shares
      ShStr := trim(uppercase(lineLst[iShr]));
      ShStr := DelParenthesis(ShStr); // remove parentheses
      delete(ShStr, pos(',', ShStr), 1); // remove commas
      // do not import cancels with no number of shares
      if (oc = 'X') and (ShStr = '0') then begin
        dec(R);
        Continue;
      end;
      // --------------------
      // [iAmt] amount
      AmtStr := trim(uppercase(lineLst[iAmt]));
      if AmtStr = '0' then begin
        DataConvErrRec := DataConvErrRec + 'Missing amount for ticker: ' + tick + CRLF +
          ImpStrList[i] + cr + lf + cr + lf;
        dec(R);
        Continue;
      end;
      delete(AmtStr, pos(',', AmtStr), 1);
      // --------------------
      // [iPr] price
      PrStr := trim(uppercase(lineLst[iPr]));
      // --------------------
      // [iComm] comm
      comStr := trim(uppercase(lineLst[iComm]));
      if pos('N/A', comStr) > 0 then
        comStr := '0.00';
      // --------------------
      // [iDescr] descr
      descr := trim(uppercase(lineLst[iDesc]));
      // delete all quotes
      while pos('"', descr) > 0 do
        delete(descr, pos('"', descr), 1);
      // delete all commas
      while pos(',', descr) > 0 do
        delete(descr, pos(',', descr), 1);
      // special case: dividend reinvestments
      p := pos('REIN @', descr);
      if divReinv and (p > 0) then begin
        PrStr := copy(descr, p + 6);
        if pos('   REC ', PrStr)> 3 then
          PrStr := leftStr(PrStr, pos('   REC ', PrStr));
        PrStr := trim(PrStr);
      end;
      // --------------------
      // options
      if contracts then begin
        // special cases: weekly, mini-options
        if rightStr(opUnder, 1)= '7' then begin
          delete(tick, length(opUnder), 1);
          mult := 10;
          prfStr := 'OPT-10';
        end
        else if mult = 1 then begin
        // fix for mini options -ie: mult=10 set above
          mult := 100;
          prfStr := 'OPT-100';
        end;
      end;
      // ------------------------------
      try
        Shares := StrToFloat(ShStr, Settings.InternalFmt);
        if Shares < 0 then
          Shares := -Shares;
        Price := FracDecToFloat(PrStr);
        Amount := FracDecToFloat(AmtStr);
        if Amount < 0 then
          Amount := -Amount;
        if divReinv and (Price = 0) //
          and (Amount <> 0) and (Shares <> 0) then begin
          Price := rndto5(Amount / Shares);
          if Price < 0 then Price := -Price; // ABS(Price)
        end;
        // fix for when no price and no shares
        if divReinv and (Price = 0) and (Shares = 0) then begin
          dec(R);
          Continue;
        end;
        // ----------------------------
        if not contracts then begin
          mult := 1;
          prfStr := 'STK-1';
        end;
        // comm
        if ((oc = 'O') and (ls = 'L')) or ((oc = 'C') and (ls = 'S')) then
          Commis := Amount - (Shares * Price * mult)
        else if ((oc = 'C') and (ls = 'L')) or ((oc = 'O') and (ls = 'S')) then
          Commis := (Shares * Price * mult) - Amount;
        if Commis < 0 then
          Commis := -Commis;
        // ----------------------------
        ImpTrades[R].it := TradeLogFile.Count + R;
        ImpTrades[R].DT := ImpDate;
        ImpTrades[R].tm := '';
        ImpTrades[R].oc := oc;
        ImpTrades[R].ls := ls;
        ImpTrades[R].tk := tick;
        ImpTrades[R].sh := Shares;
        ImpTrades[R].pr := Price;
        ImpTrades[R].prf := prfStr;
        ImpTrades[R].cm := Commis;
        ImpTrades[R].am := Net;
        ImpTrades[R].opTk := opTick;
      except
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr + lf;
        dec(R);
        Continue;
      end;
    end; // loop
    // --------------------------------
    // csv file is date descending
    ReverseImpTradesDate(R);
    SortImpByDateOC(1, R);
    if cancels then begin
      for i := 1 to R do begin
        for j := 1 to R do begin
          if (ImpTrades[i].oc = 'X') and (ImpTrades[i].tk = ImpTrades[j].tk) and
            (format('%1.5f', [ImpTrades[i].sh], Settings.UserFmt) = format('%1.5f',
              [ImpTrades[j].sh], Settings.UserFmt)) and
            (format('%1.5f', [ImpTrades[i].pr], Settings.UserFmt) = format('%1.5f',
              [ImpTrades[j].pr], Settings.UserFmt)) and (ImpTrades[i].prf = ImpTrades[j].prf) and
            (ImpTrades[j].oc <> '') and (i <> j) then begin
            glNumCancelledTrades := glNumCancelledTrades + 2;
            ImpTrades[i].oc := '';
            ImpTrades[i].ls := '';
            ImpTrades[i].tm := '';
            ImpTrades[j].oc := '';
            ImpTrades[j].ls := '';
            ImpTrades[j].tm := '';
            break;
          end;
        end;
      end;
    end;
    // ------------------------------------------
    result := R;
  finally
    // ReadEtradeXLS
  end;
end;


// ------------------------------------
function ReadETrade(): integer;
var
  i, R : integer;
  OrderNum, LastOrderNum : string;
  ImpNextDateOn : boolean;
begin
  DataConvErrRec := '';
  DataConvErrStr := '';
  OrderNum := '';
  LastOrderNum := '';
  R := 0;
  ImpNextDateOn := false;
  ImpStrList := TStringList.Create;
  ImpStrList.clear; // initialize memory
  try
    ImpTrades := nil;
    setLength(ImpTrades, R + 1);
    GetImpDateLast;
    // --------------------------------
    // options: File, BC
    if sImpMethod = 'BC' then begin // imBrokerConnect:
      formGet.showmodal;
      if cancelURL then
        exit;
        GetImpStrListFromWebGet(false);
      result := ReadEtradeXLS(ImpStrList);
      exit;
    end
    // --------------------------------
    else if sImpMethod = 'File' then begin // imFileImport: CSVImport
      EtradeCSV := true;
      GetImpStrListFromFile('E*Trade', 'csv|xls', '');
      result := ReadEtradeXLS(ImpStrList);
    end
    // --------------------------------
    else if sImpMethod = 'Web' then begin //
      GetImpStrListFromWebGet(false);
      result := ReadEtradeXLS(ImpStrList);
      exit;
    end; // case of ImportMethod
    // ------------------------------------------
  finally
    ImpStrList.Destroy;
  end;
end; // ReadETrade


// ------------------------------------
function ReadLightspeed(): integer;
begin
  result := ReadLightspeedCSV(false);
  exit;
end;
// ------------------------------------


{ ACCOUNT	ACTIVITY DATE	SETTLEMENT DATE	ACTIVITY	QUANTITY	DESCRIPTION	SYMBOL/CUSIP	PRICE ($)	AMOUNT ($)	CASH BALANCE ($)*	COMM ($)	TYPE
  xxx	07/20/2016	07/21/2016	Bought	200	PUT STANDARD & POORS DEP REC AT 205.000 EXPIRES 08/19/2016	SPY 160819P00205000	0.46	-9,206.00	0		Long Margin
}
function ReadMorganStanleyCSV : integer;
var
  i, j, start, eend, R, Q : integer;
  junk, sep, ImpDate, CmStr, PrStr, AmtStr, ShStr, line, AdjEntryStr, optDesc, optOC, opYr, opMon,
    opDay, opStrike, opCP : string;
  Amount, Commis, Shares, mult : double;
  contracts, Adj, optExpEx, ImpNextDateOn, bonds, newColFormat, miniOptions, bFoundHeader : boolean;
  oc, ls : string;
  lineLst : TStrings;
  // -----------------------------
  function OccurrencesOfChar(const sSource : string; const CharToCount : Char): integer;
  var
    C : Char;
  begin
    result := 0;
    for C in sSource do begin
      if C = CharToCount then
        inc(result);
    end;
  end;
// -----------------------------
begin
  // ReadMorganStanleyCSV
  bFoundHeader := false;
  try
    AdjEntryStr := '';
    DataConvErrRec := '';
    DataConvErrStr := '';
    R := 0;
    Adj := false;
    ImpNextDateOn := false;
    newColFormat := false;
    if ImpStrList.Count < 1 then begin
// ImpStrList.destroy;
      result := 0;
      exit;
    end;
    lineLst := TStrings.Create;
    // --------------------------------
    i := -1;
    while i < (ImpStrList.Count - 1) do begin
      inc(i); // make it work like a for/next
      contracts := false;
      miniOptions := false;
      optExpEx := false;
      bonds := false;
      inc(R);
      line := ImpStrList[i];
      line := uppercase(line);
      if not bFoundHeader then begin
      // Transaction Date,Activity,... ,Symbol,... ,Quantity,Price($),Amount($)
        if (pos('ACTIVITY', line) > 0) //
        and (pos('SYMBOL', line) > 0) //
        and (pos('QUANTITY', line) > 0) then
          bFoundHeader := true;
        Continue;
      end;
      if R < 1 then R := 1;
      // ------------------------------
      Q := OccurrencesOfChar(line, '"');
      if Q = 1 then begin
        junk := ImpStrList[i];
        optDesc := parseLast(junk, '"');
      end;
      // now see if the description field was broken up by CR/LF
      while (i < ImpStrList.Count - 1) and (Q mod 2 = 1) and (Q > 0) do begin
        inc(i);
        if ImpStrList[i] = 'OPENING' then
          optOC := 'O'
        else if ImpStrList[i] = 'CLOSING' then
          optOC := 'C';
        // string continues on next line
        line := line + '|' + ImpStrList[i];
        Q := OccurrencesOfChar(line, '"');
      end;
      // ------------------------------
      // parse all columns into string list
      lineLst := ParseCSV(line);
      if pos('too many transactions', line) > 0 then begin
        sm('The date range you have selected contains too many transactions.' + cr +
            'A maximum of 1500 transactions can be obtained at once.' + cr +
            'Please reduce the date range for your Schwab report and try again.');
        result := 0;
        exit;
      end;
      sep := ',';
      // 0. ACCOUNT	        xxx
      // 1. ACTIVITY DATE   07/20/2016
      // 2. SETTLEMENT DATE 07/21/2016
      // 3. ACTIVITY        Bought
      // 4. QUANTITY        200
      // 5. DESCRIPTION     PUT STANDARD & POORS DEP REC AT 205.000 EXPIRES 08/19/2016
      // OPENING
      // PREFERENTIAL RATE
      // Ref: 202Q5662 SEC ID: ERT15
      // 6. SYMBOL/CUSIP    SPY 160819P00205000
      // 7. PRICE ($)       0.46
      // 8. AMOUNT ($)      -9,206.00
      // 9. CASH BALANCE($)* 0
      // 10. COMM ($)
      // 11. TYPE           Long Margin
      // --- Date ---
      ImpDate := lineLst[1];
      if length(ImpDate) > 10 then
        ImpDate := leftStr(ImpDate, 10);
      if (pos('/', ImpDate) <> 3) and (pos('/', ImpDate) <> 2) then begin
        if (i = ImpStrList.Count - 1) and (R = 1) then begin
          // DataConvErrRec:= 'No records imported';
          sm('There were no trades for this date range');
          result := 0;
          exit;
        end;
        dec(R);
        Continue;
      end;
      ImpDate := LongDateStr(ImpDate);
      if not ValidTradeDate(ImpDate, ImpDateLast, ImpNextDateOn) then begin
        dec(R);
        Continue;
      end;
      // --- long/short ---
      if pos('LONG', uppercase(trim(lineLst[11]))) = 1 then
        ls := 'L'
      else if pos('SHORT', uppercase(trim(lineLst[11]))) = 1 then
        ls := 'S'
      else begin
        sm('Cannot determine if this trade is long or short:' + cr + lineLst[11]);
        Continue; // skip the record if we can't tell which
      end;
      // --- open/close ---
      if uppercase(trim(lineLst[3])) = 'BOUGHT' then
        if ls = 'L' then
          oc := 'O'
        else
          oc := 'C'
      else if uppercase(trim(lineLst[3])) = 'SOLD' then
        if ls = 'L' then
          oc := 'C'
        else
          oc := 'O'
      else begin
        sm('Cannot determine if this trade is open or close:' + cr + lineLst[3]);
        Continue; // skip the record if we can't tell which
      end;
      // --- description ---
      junk := lineLst[5];
      // is it an option?
      if pos('PUT ', uppercase(junk)) = 1 then
        contracts := true
      else if pos('CALL ', uppercase(junk)) = 1 then
        contracts := true
      else
        contracts := false;
      // --- # shares ---
      ShStr := lineLst[4];
      ShStr := delCommas(ShStr);
      // --- ticker
      if pos(' ', lineLst[6]) > 1 then
        tick := copy(lineLst[6], 1, pos(' ', lineLst[6])- 1)
      else
        tick := lineLst[6];
      // --- options
      if contracts then begin
        // first, calculate the option ticker
        opCP := parsefirst(optDesc, ' ');
        opYr := parseLast(optDesc, ' ');
        opMon := parsefirst(opYr, '/');
        opDay := parsefirst(opYr, '/');
        opMon := getExpMo(opMon);
        if length(opYr) = 4 then
          opYr := copy(opYr, 3, 2);
        junk := parseLast(optDesc, ' '); // 'EXPIRES'
        opStrike := parseLast(optDesc, ' ');
        opStrike := delTrailingZeros(opStrike);
        tick := trim(tick);
        if rightStr(tick, 1) = '7' then begin
          delete(tick, length(tick), 1);
          miniOptions := true;
        end;
        tick := tick + ' ' + opDay + opMon + opYr + ' ' + opStrike + ' ' + opCP;
        // must also check OC and LS based on a combination of the
        // Bought, Opening = Open, Long
        // Sold, Opening = Open, Short
        // Bought, Closing = Close, Short
        // Sold, Closing = Close, Long
        if (optOC <> '') and (optOC <> oc) then begin
          oc := optOC;
          if ls = 'L' then
            ls := 'S'
          else
            ls := 'L';
        end;
      end
      else
        optDesc := ''; // NOT an option contract
      // end if
      // --- price
      PrStr := lineLst[7];
      delete(PrStr, pos('$', PrStr), 1);
      PrStr := delCommas(PrStr);
      if optExpEx then
        PrStr := '0.00';
      // --- commission
      CmStr := lineLst[10];
      delete(CmStr, pos('$', CmStr), 1);
      CmStr := delCommas(CmStr);
      if optExpEx or (CmStr = '') or (pos('*', CmStr) > 0) then
        CmStr := '0.00';
      // --- amount
      AmtStr := lineLst[8];
      delete(AmtStr, pos('$', AmtStr), 1);
      AmtStr := delCommas(AmtStr);
      if optExpEx then
        AmtStr := '0.00';
      // --------------------
      try
        Shares := StrToFloat(ShStr, Settings.InternalFmt);
        if Shares = 0 then begin
          dec(R);
          Continue;
        end;
        if Shares < 0 then
          Shares := -Shares
        else if optExpEx then begin
          oc := 'O';
          ls := 'L';
        end;
        Price := StrToFloat(PrStr, Settings.InternalFmt);
        Commis := StrToFloat(CmStr, Settings.InternalFmt);
        if (leftStr(AmtStr, 1)= '(') and (rightStr(AmtStr, 1)= ')') then
          AmtStr := '-' + copy(AmtStr, 2, length(AmtStr)- 2);
        Amount := CurrToFloat(AmtStr);
        if Amount < 0 then begin
          // sm('negative amount' + CR + 'OC = ' + oc + CR + 'ls = ' + LS);
          Amount := -Amount;
        end;
        // comm
        if bonds then begin
          Commis := CurrToFloat(CmStr);
          if ((oc = 'C') and (ls = 'L')) or ((oc = 'O') and (ls = 'S')) then begin
            // test if price should be divided by 100
            if (Shares * Price / 99) + Commis > Amount then begin
              Price := (Amount + Commis) / Shares;
              tick := junk;
            end;
          end
          else begin
            // test if price should be divided by 100
            if (Shares * Price / 99) - Commis > Amount then begin
              Price := (Amount - Commis) / Shares;
              tick := junk;
            end;
          end;
        end
        else if contracts then
          if miniOptions then begin
            mult := 10;
            ImpTrades[R].prf := 'OPT-10'
          end
          else begin
            mult := 100;
            ImpTrades[R].prf := 'OPT-100'
          end
        else begin
          mult := 1;
          ImpTrades[R].prf := 'STK-1';
        end;
        if ((oc = 'C') and (ls = 'L')) or ((oc = 'O') and (ls = 'S')) then
          Commis := Amount - (Shares * mult * Price)
        else
          Commis := (Shares * mult * Price) - Amount;
        if Commis < 0 then
          Commis := -Commis;
        ImpTrades[R].DT := ImpDate;
        ImpTrades[R].oc := oc;
        ImpTrades[R].ls := ls;
        ImpTrades[R].tk := trim(tick);
        ImpTrades[R].opTk := trim(optDesc);
        ImpTrades[R].sh := Shares;
        ImpTrades[R].pr := Price;
        ImpTrades[R].am := Amount;
        ImpTrades[R].cm := rndto2(Commis);
      except
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        dec(R);
        Continue;
      end;
      ImpTrades[R].it := TradeLogFile.Count + R;
    end;
    // --------------------------------
    if (R = 0) and (bFoundHeader = false) then
      sm('no header row found in data file');
    result := R;
  finally
    lineLst.Free;
    // ReadMorganStanleyCSV
  end;
end;


// ------------------------------------
function ReadMorganStanleyXLS : integer;
// -------------------------------------
var
  i, k, R, numFields : integer;
  iDt, iOC, iTk, iShr, iPr, iAmt, iCUSIP, iDesc : integer; // import field numbers
  sTmp, ImpDate, opTick, opUnder, opStrike, opYr, opMon, opDay, opCP, PrStr, prfStr, AmtStr, ShStr,
    line, junk, NextDate, descr : string;
  sep : Char;
  Shares, Amount, Commis, Net, mult : double;
  contracts, cancels, ImpNextDateOn, divReinv, bFoundHeader : boolean;
  oc, ls, sTick : string;
  fieldLst : TStrings; // for parsing individual lines
  // ----------------------------------
  // Activity Date	 03/05/2020	09/30/2020
  // DT Transaction Date 03/05/2020	09/30/2020
  // OC Activity       Sold	Dividend Reinvestment
  // Check Number
  // Card Number
  // DS Description	   NUVEEN PENN INVT QUAL?	etc.
  // TK Symbol	       NQP	MVRXX
  // QQ Cusip	         670972108	61747C707
  // SH Quantity	     479.000	1.840
  // PR Price($)	     14.82	1.00
  // AM Amount($)	     7,094.28	-1.84
  // Running Balance	 9,150.78	etc.
  // ----------------------------------
  procedure SetFieldNumbers();
  var
    j : integer;
  begin
    // find/map Morgan Stanley CSV fields
    k := 0;
    for j := 0 to (fieldLst.Count - 1) do begin
      if (fieldLst[j] = 'TRANSACTION DATE') //
      then begin
        iDt := j;
        k := k or 1;
      end
      else if (fieldLst[j] = 'ACTIVITY') // for 'BOUGHT' or 'SOLD'
      then begin
        iOC := j;
        k := k or 2;
      end
      else if (fieldLst[j] = 'DESCRIPTION') //
      then begin
        iDesc := j;
        iAmt := j;
        k := k or 4;
      end
      else if (fieldLst[j] = 'SYMBOL') //
      then begin
        iTk := j;
        k := k or 8;
      end
      else if (fieldLst[j] = 'CUSIP') //
      then begin
        iCUSIP := j;
        k := k or 16;
      end
      else if (fieldLst[j] = 'QUANTITY') //
      then begin
        iShr := j;
        k := k or 32;
      end
      else if (pos('PRICE', fieldLst[j]) = 1) //
      then begin
        iPr := j;
        k := k or 64;
      end
      else if (pos('AMOUNT', fieldLst[j]) = 1) //
      then begin
        iAmt := j;
        k := k or 128;
      end;
    end;
  end;
  // ----------------------------------
//  function IsNum(s : string) : boolean;
//  begin
//    if pos('.', s) > 0 then
//      delete(s, pos('.', s), 1);
//    result := IsNumber(s);
//  end;
  // ------------------------
  // CALL SQUARE INC CLASS A AT 85.000
  // EXPIRES 01/17/2020 CLOSING VFIFO
  // tk       v
  // SQ 200117C00085000
  // yymmdd $$$$$...
  // ------------------------
  function DecodeOptTk(var sTk : string) : string;
  var
    n : integer;
    opYr, opMon, opDay, opStrike, opCP, opStrik2 : string;
  begin
    // Reset all local vars
    opStrike := '';
    opStrik2 := '';
    opYr := '';
    opMon := '';
    opDay := '';
    opCP := '';
    // --------------------
    // CALL SQUARE INC CLASS A AT 85.000
    // EXPIRES 01/17/2020 CLOSING VFIFO
    // SQ 200117C00085000
    // Tk YYMMDDX$$$$$ccc
    // --------------------
    // Tickr    SQ
    // ExpDate  01/17/2020
    // Strike$  85.000
    // CallPut  Call
    // ---------------------
    // SQ 17JAN20 85 CALL
    // ---------------------
    opYr := copy(sTk, 1, 2);
    opMon := copy(sTk, 3, 2);
    opMon := getExpMo(opMon);
    opDay := copy(sTk, 5, 2);
    opCP := copy(sTk, 7, 1);
    if opCP = 'C' then
      opCP := 'CALL'
    else
      opCP := 'PUT';
    opStrike := copy(sTk, 8, 5);
    opStrik2 := copy(sTk, 13, 3);
    n := strToInt(opStrike);
    opStrike := IntToStr(n); // removes leading zeros
    n := strToInt(opStrik2);
    if (n > 0) then
      opStrike := opStrike + '.' + IntToStr(n);
    opStrike := delTrailingZeros(opStrike); // for matching
    result := opDay + opMon + opYr + ' ' + opStrike + ' ' + opCP;
  end;
// ----------------------------------
begin // ReadMorganStanleyXLS
  // ----------------------------------
  DataConvErrRec := '';
  DataConvErrStr := '';
  Commis := 0;
  Net := 0;
  R := 0;
  setLength(ImpTrades, R); // max size
  sep := TAB; // 2021-12-17 MB
  // --------------------------------
  bFoundHeader := false;
  DataConvErrRec := '';
  DataConvErrStr := '';
  cancels := false;
  ImpNextDateOn := false;
  GetImpDateLast;
  if ImpStrList.Count < 1 then begin
    result := 0;
    exit;
  end;
  // --------------------------------
  for i := 0 to (ImpStrList.Count - 1) do begin
    line := ImpStrList[i];
    line := uppercase(line); // search line for UPPERCASE tokens...
    if line = '' then
      Continue;
    if replacestr(line, ',', '') = '' then begin
      Continue;
    end;
    // parse all columns into string list
    fieldLst := ParseCSV(line, sep); // try TAB first
    // ------------------------------
    if not bFoundHeader then begin
      if (pos('ACTIVITY', line) > 0) //
        and (pos('QUANTITY', line) > 0) //
        and (pos('AMOUNT', line) > 0) //
      then begin
        if fieldLst.Count < 5 then begin
          Continue;
        end;
        SetFieldNumbers;
        numFields := fieldLst.Count;
        if SuperUser and (k <> 255) then
          sm('there appear to be fields missing.');
        bFoundHeader := true; // don't do this anymore
        R := 0; // start now
      end;
      Continue; // don't process anything until we recognize the header
    end;
    if fieldLst.Count > numFields then begin
      DataConvErrRec := DataConvErrRec + line + cr;
      Continue; // record has extra commas!
    end;
    // ------------------------------
    if pos('ERROR', line) > 0 then begin
      sm('The broker reported an error in the data.' + cr //
          + 'Please reduce the date range and try again.');
      result := 0;
      exit;
    end;
    // --------------------
    // [iDt] Trade Date
    sTmp := trim(fieldLst[iDt]);
    if (sTmp = '') then begin
      if (R < 1) then
        Continue // silently skip beginning blanks
      else
        break; // done if find blank line after valid line(s).
    end;
    if not isdate(sTmp) then begin
      if (R > 0) then
        break; // must be done.
      Continue;
    end;
    if not ValidTradeDate(sTmp, ImpDateLast, ImpNextDateOn) then
      Continue;
    ImpDate := sTmp;
    // --------------------
    // DE: do not import expires and assigns because we don't know if short or lomg!!!
    sTick := trim(fieldLst[iTk]); // ticker
    if (length(trim(replacestr(sTick, '-', ''))) < 2) then begin
      sTick := trim(fieldLst[iCUSIP]);
    end;
    // --------------------
    // reset local vars
    // --------------------
    mult := 1;
    opTick := '';
    contracts := false;
    divReinv := false;
    // --------------------
    ls := 'L'; // assume
    sTmp := fieldLst[iOC];
    if sTmp = 'BOUGHT' then
      oc := 'O'
    else if sTmp = 'SOLD' then
      oc := 'C'
    else if sTmp = 'DIVIDEND REINVESTMENT' then begin
      oc := 'O'; // 2020-11-03 MB - added DRiP trades
      divReinv := true;
    end
    else // activity type is beyond scope of import - MB
      Continue;
    // --------------------
    inc(R); // get this far, count it.
    // --------------------
    // Check symbol for option trade
    contracts := false;
    prfStr := 'STK-1';
    mult := 1;
    descr := fieldLst[iDesc];
    if divReinv then begin
      // prfStr := 'DRP-1';
    end
    else if pos(' ', sTick) > 0 then begin
      // AAPL 181102P00215000 --> AAPL 02NOV18 215 PUT
      junk := sTick;
      sTick := parsefirst(junk, ' ');
      junk := trim(junk);
      if length(junk) = 15 then begin // the right size
        sTick := sTick + ' ' + DecodeOptTk(junk);
        contracts := true;
        prfStr := 'OPT-100';
        mult := 100;
      end;
    end;
    // --------------------
    ShStr := fieldLst[iShr];
    PrStr := fieldLst[iPr];
    AmtStr := fieldLst[iAmt];
    // --------------------
    try
      Shares := StrToFloat(ShStr, Settings.InternalFmt);
      if Shares = 0 then begin
        dec(R);
        Continue;
      end;
      if Shares < 0 then
        Shares := -Shares;
      // --------------------
      Price := StrToFloat(PrStr, Settings.InternalFmt);
      // --------------------
      if (leftStr(AmtStr, 1)= '(') and (rightStr(AmtStr, 1)= ')') then
        AmtStr := '-' + copy(AmtStr, 2, length(AmtStr)- 2);
      Amount := CurrToFloat(AmtStr);
      if Amount < 0 then begin
        Amount := -Amount;
      end;
      // --------------------
      // check for obvious errors:
      if ABS(Amount -(Shares * Price)) > ABS(0.5 * Amount) then
        DataConvErrRec := DataConvErrRec //
          + 'shares*price not even close to amount:' + CRLF //
          + floattostr(Shares) + '*$' + floattostr(Price) + ' >< $' + floattostr(Amount) + CRLF //
          + line + CRLF;
      // --------------------
      // comm
      if ((oc = 'C') and (ls = 'L')) or ((oc = 'O') and (ls = 'S')) then
        Commis := Amount - (Shares * mult * Price)
      else
        Commis := (Shares * mult * Price) - Amount;
      if Commis < 0 then
        Commis := -Commis;
      // --------------------
      if high(ImpTrades) < R then
        setLength(ImpTrades, R + 1);
      ImpTrades[R].DT := ImpDate;
      ImpTrades[R].oc := oc;
      ImpTrades[R].ls := ls;
      ImpTrades[R].tk := trim(sTick);
      ImpTrades[R].prf := prfStr;
      ImpTrades[R].sh := Shares;
      ImpTrades[R].pr := Price;
      ImpTrades[R].am := Amount;
      ImpTrades[R].cm := rndto2(Commis);
    except
      DataConvErrRec := DataConvErrRec + line + cr;
      dec(R);
      Continue;
    end;
    ImpTrades[R].it := TradeLogFile.Count + R;
    // ------------------------------------------
  end; // for loop
  if R = 0 then begin
    result := -1;
    exit;
  end;
  ReverseImpTradesDate(R);
  result := R;
end;

// ------------------------------------
// ENTRY POINT
// ------------------------------------
function ReadMorganStanley(): integer;
var
  i, R, colCnt, custCol, asOfDateCol : integer;
  junk, ImpDate, opTk, oc, ls, PrStr, ShStr, AmtStr, typeStr, line, descr : string;
  bHasCancels, contracts, ImpNextDateOn : boolean;
begin
  // ReadMorganStanley
  R := 0;
  ImpNextDateOn := false;
  ImpStrList := TStringList.Create;
  ImpTrades := nil;
  // move to Import.pas, add call to
  GetImpStrListFromFile('MorganStanley', 'csv|xls?', '');
  if (sFileType = 'xls') or (sFileType = 'xlsx') then begin
    StatBar('Importing from Excel (XLS) file - PLEASE WAIT');
    result := ReadMorganStanleyXLS;
  end
  else begin
    result := ReadMorganStanleyCSV;
  end;
  ImpStrList.Destroy;
  try
    ImportHasDescr := false;
    custCol := 0;
    asOfDateCol := 0;
  finally
    // ReadMorganStanley
  end;
end;


         // -----------------
         // Centerpoint
         // -----------------

function ReadCenterPointCSV(): integer;
var
  i, j, k, n, start, eend, R, Q, iFmt : integer;
  iDt, iBS, iOC, iLS, iTk, iTyp, iShr, iPr, iAmt, iCm : integer; // import fields
  line, junk, sep, sTmp, ImpDate, CmStr, feeStr, PrStr, AmtStr, ShStr, typeStr, optDesc, //
    optOC, opYr, opMon, opDay, opStrike, opCP, optTick, oc, ls, errLogTxt, opStrik2, sNote : string;
  Amount, Commis, Fees, Shares, mult : double;
  contracts, Adj, optExpEx, ImpNextDateOn, bonds, newColFormat, miniOptions, futures, //
    bFoundHeader, cancels, assigns : boolean;
  fieldLst : TStrings;
  // ----------------------------------
  procedure ClearFieldNums();
  begin
    iDt := 0;
    iTk := 0;
    iBS := 0;
    iOC := 0;
    iLS := 0;
    iTyp := 0;
    iShr := 0;
    iPr := 0;
    iAmt := 0;
  end;
  // ----------------------------------
  procedure SetFieldNumbers();
  var
    j : integer;
    s : string;
  begin
    // find/map Centerpoint CSV fields
    k := 0;
    ClearFieldNums;
    // iFmt now set in main procedure
    // --------------------------------
    for j := 0 to (fieldLst.Count - 1) do begin
      s := trim(fieldLst[j]);
      if (s = 'TRADE_DATE') or (s = 'TRADE DATE') //
      or (s = 'TRANSACTION DATE') then begin
        iDt := j;
        k := k or 1;
      end
      else if (s = 'INSTRUMENT.NAME') //
      or (s = 'SYMBOL') then begin //
        iTk := j;
        k := k or 2;
      end
      else if (s = 'SIDE_DIRECTION') //
      or (s = 'TRANSACTION CODE') //
      or (s = 'TRANSACTION TYPE') then begin //
        iBS := j;
        k := k or 4;
      end
      else if (s = 'LONG SHORT INDICATOR') //
      or (s = 'SIDE_QUALIFIER') //
      or (s = 'SIDE QUALIFIER') //
      then begin //
        iLS := j;
        k := k or 512;
      end
      else if s = 'SIDE_POSITION' then begin //
        iOC := j;
        k := k or 1024; // only exists in iFmt #1
        iFmt := 1;
      end
      else if (s = 'INSTRUMENT.SECTOR') //
      or (s = 'TYPE') then begin //
        iTyp := j;
        k := k or 16;
      end
      else if s = 'QUANTITY' then begin //
        iShr := j;
        k := k or 32;
      end
      else if s = 'PRICE' then begin //
        iPr := j;
        k := k or 64;
      end
      else if (s = 'NET_AMOUNT') //
      or (s = 'NET AMOUNT') then begin //
        iAmt := j;
        k := k or 128;
      end
      else if (s = 'TOTAL FEES') //
      or (s = 'FEE_SUM') then begin //
        iCm := j;
        k := k or 256;
      end; // if cases
    end; // for j
    s := ''; // this line is just for placing a breakpoint!
  end;
  // ------------------------
  // CALL SQUARE INC CLASS A AT 85.000
  // EXPIRES 01/17/2020 CLOSING VFIFO
  // tk       v
  // PYPL 220211C00125000
  // tick yymmdd^$$$$$...
  // ------------------------
  function DecodeOptTk(var sTk : string) : string;
  var
    n : integer;
    opYr, opMon, opDay, opStrike, opCP, opStrik2 : string;
  begin
    // Reset all local vars
    result := '';
    opStrike := '';
    opStrik2 := '';
    opYr := '';
    opMon := '';
    opDay := '';
    opCP := '';
    // --------------------
    // PYPL 220211C00125000
    // Tick YYMMDDX$$$$$ccc
    // ---------------------
    result := parsefirst(sTk, ' ');
    sTk := trim(sTk); // 2022-03-21 MB - remove extra space(s)
    opYr := copy(sTk, 1, 2);
    opMon := copy(sTk, 3, 2);
    opMon := getExpMo(opMon);
    opDay := copy(sTk, 5, 2);
    opCP := copy(sTk, 7, 1);
    if opCP = 'C' then
      opCP := 'CALL'
    else
      opCP := 'PUT';
    opStrike := copy(sTk, 8, 5);
    opStrik2 := copy(sTk, 13, 3);
    n := strToInt(opStrike);
    opStrike := IntToStr(n); // removes leading zeros
    n := strToInt(opStrik2);
    if (n > 0) then
      opStrike := opStrike + '.' + IntToStr(n);
    opStrike := delTrailingZeros(opStrike); // for matching
    result := result + ' ' + opDay + opMon + opYr + ' ' + opStrike + ' ' + opCP;
  end;
// --------------------------------------------
begin // ReadCenterPointCSV
  bFoundHeader := false; // haven't found the header yet
  // in case these are missing, flag to skip them.
  cancels := false;
  contracts := false;
  R := 0;
  try
    DataConvErrRec := '';
    DataConvErrStr := '';
    Commis := 0;
    ImpNextDateOn := false;
    // --------------------------------
    if ImpStrList.Count < 1 then begin
      ImpStrList.Destroy;
      result := 0;
      exit;
    end;
    iLS := 0; // no Long/Short indicator?
    fieldLst := TStrings.Create;
    // --------------------------------
    i := -1;
    while i < (ImpStrList.Count - 1) do begin
      inc(i); // make it work like a for/next
      contracts := false; // reset flags
      // ------------------------------
      line := ImpStrList[i];
      line := uppercase(line); // search line for UPPERCASE tokens...
      // ------------------------------
      if pos('"""', line) = 1 then
        line := copy(line, 3);
      // parse all columns into string list
      fieldLst := ParseCSV(line);
      // ------------------------------
      if not bFoundHeader then begin
        if (pos('PRICE', line) = 0) //
        or (pos('QUANTITY', line) = 0) //
        then continue; // invalid header
        // ---
        if ((pos('TRADE_DATE', line) > 0) //
         or (pos('TRADE DATE', line) > 0)) //
        and ((pos('INSTRUMENT.NAME', line) > 0) //
          or (pos('SYMBOL', line) > 0)) //
        then begin // header format #2 or 2a
          iFmt := 2;
          SetFieldNumbers;
          if SuperUser then begin
            if ((iFmt = 2) and (k <> 999)) //
            or ((iFmt = 1) and (k <> 2039)) then
              sm('there appear to be fields missing.');
          end;
          bFoundHeader := true; // don't do this anymore
          R := 0; // start now
        end;
        Continue; // don't process anything until we find the header!
      end; // header not found yet
      // ------------------------------
      if pos('ERROR', line) > 0 then begin
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        sm('Centerpoint reported an error.' + cr //
            + 'Please reduce the date range and try again.');
        result := 0;
        exit;
      end;
      // --- ticker -------------------
      tick := trim(fieldLst[iTk]);
      if tick = '' then begin
        Continue;
      end;
      // -- PRF = Type/Mult -----------
      if iFmt = 1 then
        typeStr := trim(fieldLst[iTyp])
      else if length(tick) > 14 then
        typeStr := 'OPTION'
      else
        typeStr := 'STK-1';
      if (typeStr = 'OPTION') then begin
        typeStr := 'OPT-100';
        mult := 100;
        contracts := true;
      end
      else begin
        typeStr := 'STK-1'; // Make everything a stock
        mult := 1;
        contracts := false;
      end;
      // --- Date ---------------------
      ImpDate := fieldLst[iDt]; // format: YYYY-MM-DDT00:00:00-hh:mm
      if (iFmt = 1) then begin
        ImpDate := leftStr(ImpDate, 10); // keep only YYYY-MM-DD
      end;
      if (pos('-', ImpDate) = 5) then begin
        ImpDate := StringReplace(ImpDate, '-', '', [rfReplaceAll]);
        ImpDate := MMDDYYYY(ImpDate); // it comes in yyyy-mm-dd
      end;
      if (pos('/', ImpDate) = 2) then begin
        ImpDate := '0' + ImpDate;
      end;
      if (iFmt = 2) and (pos('/', ImpDate)=0) then begin
        ImpDate := MMDDYYYY(ImpDate); // NEW for iFmt 2
      end;
      if not isdate(ImpDate) then begin
        sm('Cannot determine the transaction date of this trade:' + cr + line);
      end;
      if not ValidTradeDate(ImpDate, ImpDateLast, ImpNextDateOn) then begin
        Continue;
      end;
      if UserDateStrNotGreater(ImpDate, ImpDateLast) then begin
        if mDlg('Trades already imported for ' + ImpDate + cr //
            + cr //
            + 'Continue?', mtWarning, [mbNo, mbYes], 0) = mrNo then begin
          result := R;
          exit;
        end
        else
          ImpDateLast := '01/01/1900';
      end;
      // --- # shares -----------------
      ShStr := fieldLst[iShr];
      ShStr := delCommas(ShStr);
      try
        Shares := CurrToFloat(ShStr);
      except
        Shares := 0;
      end;
      // --- OC and LS --------------------------
      // iBS = buy or sell - for all types
      // iOC = open or close - for OPT types
      // iLS = short or <blank> - for STK types
      oc := 'E'; // default values
      ls := 'E'; // are E for ERROR
      junk := trim(fieldLst[iBS]);
      if contracts then begin // Options
        sTmp := trim(fieldLst[iOC]);
        sNote := '';
        if (junk = 'BUY') then begin
          if (sTmp = 'CLOSE') then begin
            oc := 'C';
            ls := 'S';
          end
          else begin
            oc := 'O';
            ls := 'L';
          end;
        end
        else if (junk = 'SELL') then begin
          if (sTmp = 'OPEN') then begin
            oc := 'O';
            ls := 'S';
          end
          else begin
            oc := 'C';
            ls := 'L';
          end;
        end;
      end // option types
      else begin // stock types
        sTmp := trim(fieldLst[iLS]);
        sNote := '';
        if (junk = 'SELL') then begin
          if (sTmp = 'SHORT') then begin
            oc := 'O';
            ls := 'S';
          end
          else begin
            oc := 'C';
            ls := 'L';
          end;
        end
        else if (junk = 'SELLSHORT') then begin // NEW for iFmt 2
          oc := 'O';
          ls := 'S';
        end
        else if (junk = 'BUY') then begin
          if (sTmp = 'SHORT') then begin
            oc := 'C';
            ls := 'S';
          end
          else begin
            oc := 'O';
            ls := 'L';
          end;
        end
      end; // type cases
      // ------------------------------
      inc(R); // if it gets this far, count it
      // ------------------------------
      if contracts then begin
        if pos('  ', tick) > 1 then
          tick := replacestr(tick, '  ', ' ');
        junk := DecodeOptTk(tick);
        if junk = '' then begin
          dec(R);
          Continue;
        end
        else begin
          tick := junk;
        end;
      end;
      // --- price --------------------
      PrStr := fieldLst[iPr];
      delete(PrStr, pos('$', PrStr), 1);
      PrStr := delCommas(PrStr);
      if (xStrToFloat(PrStr) = 0) then
        PrStr := '0.00';
      // --- conversion rate
      // amount
      AmtStr := fieldLst[iAmt];
      // --- Commission ---------------
      CmStr := trim(fieldLst[iCm]);
      try
        Shares := CurrToFloat(ShStr);
        if Shares < 0 then
          Shares := -Shares; // ABS
        Price := CurrToFloat(PrStr);
        if Price < 0 then
          Price := -Price; // ABS
        Amount := ABS(CurrToFloat(AmtStr));
        Commis := CurrToFloat(CmStr);
        // ------ set import record fields ------
        ImpTrades[R].it := TradeLogFile.Count + R;
        ImpTrades[R].DT := ImpDate;
        ImpTrades[R].oc := oc;
        ImpTrades[R].ls := ls;
        ImpTrades[R].tk := tick;
        ImpTrades[R].sh := Shares;
        ImpTrades[R].pr := Price;
        ImpTrades[R].prf := typeStr;
        ImpTrades[R].cm := Commis;
        ImpTrades[R].am := Amount;
        ImpTrades[R].no := sNote;
      except
        // DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        dec(R);
        Continue;
      end;
    end; // while
    // --------------------------------
    ReverseImpTradesDate(R);
// ReverseShortTrades(R);
    if cancels then begin
      for i := 1 to R do begin
        if (ImpTrades[i].oc = 'X') then
          for j := i + 1 downto 1 do begin
            if (ImpTrades[i].tk = ImpTrades[j].tk) //
              and (ImpTrades[i].sh = ImpTrades[j].sh) //
              and (ImpTrades[i].pr = ImpTrades[j].pr) //
              and (format('%1.2f', [ImpTrades[i].pr], Settings.UserFmt) = format('%1.2f',
                [ImpTrades[j].pr], Settings.UserFmt)) //
              and (ImpTrades[j].oc <> '') //
              and (i <> j) then begin
              glNumCancelledTrades := glNumCancelledTrades + 2;
              ImpTrades[i].oc := '';
              ImpTrades[i].ls := '';
              ImpTrades[j].oc := '';
              ImpTrades[j].ls := '';
              break;
            end;
          end;
      end;
    end;
    for i := 1 to R do begin
      if ImpTrades[i].oc = 'X' then begin
        sm('CANCEL TRADES NOT MATCHED!' + cr + cr +
            'Cancel Trades have Open/Close marked with an "X"');
        break;
      end;
    end;
    result := R;
    ImpStrList.Destroy;
  finally
    contracts := false; // just a place to put a breakpoint
  end;
end; // ReadCenterPointCSV


function ReadCenterPoint(): integer;
var
  R : integer;
begin
  try
    R := 0;
    ImpStrList := TStringList.Create;
    ImpTrades := nil;
    setLength(ImpTrades, R + 1);
    GetImpDateLast;
    // ----------------------
    if FileExists(Settings.ImportDir + '\download.csv') then
      deleteFile(Settings.ImportDir + '\download.csv');
    // ----------------------
    GetImpStrListFromFile('*', 'csv', ''); // from CSV file only
    result := ReadCenterPointCSV;
    // ----------------------
    exit;
  finally
    // CenterPoint (ClearStreet)
  end;
end;


// ------------------------------------
// This code is designed for the following fields:
// Instrument, Action, Qty, Price, Time, ID, E/X, Position, Order ID, Name, Commission, Rate, Account, Connection,
// ------------------------------------
// NOTE: some users provide the following columns (delimiter could be either comma or tab):
// Trade-#,Instrument,Account,Strategy,Market pos.,Quantity,Entry price,Exit price,
// Entry time,Exit time,Entry name,Exit name,Profit,Cum. profit,Commission,MAE,MFE,ETD,Bars,
// ------------------------------------
function ReadNinjaCSV(ImpStrList : TStringList) : integer;
var
  i, j, k, start, eend, R, Q : integer;
  iDt, iTm, iTyp, iOC, iLS, iTk, iDesc, iShr, iPr, iAmt, iCm : integer; // import field numbers
  junk, sep, ImpDate, ImpTime, CmStr, feeStr, PrStr, AmtStr, ShStr, line, typeStr, optDesc, //
  oc, ls, dd, mm, yyyy, errLogTxt, dtFmt : string;
  Amount, Commis, Fees, Shares, mult : double;
  contracts, Adj, optExpEx, ImpNextDateOn, bonds, newColFormat, miniOptions, futures, //
    bFoundHeader, cancels, assigns : boolean;
  fieldLst : TStrings;
  // ----------------------------------
  // 1  Instrument  CL 02-19, ES 09-17
  // 2  Action      Buy, Sell
  // 3  Qty         1
  // 4  Price       51.9
  // 5  Time        1/10/2019 10:17
  // 6  ID          2.13E+11
  // 7  E/X         Entry, Exit
  // 8  Position    1L, -, 1S
  // 9  Order ID    1176224653
  // 10  Name        Long1_8, Stop loss, Short1_2
  // 11  Commission  2.15
  // 12  Rate        1
  // 13  Account     Jeremiah Horn!Mirus!Y1737
  // 14  Connection  NinjaTrader Continuum (Live)
  // ----------------------------------
  // NOTES:
  // 1 Intrument is Futures Ticker
  // CL = Crude Oil, ES = E-mini S&P 500
  // Maturation Dates MM-YY (09-17 = SEP17)
  // ----------------------------------
  // 7 E/X determines Open/Close; must combine
  // with 2 Action to determine Long/Short
  // LONG trade: Buy+Entry, Sell+Exit
  // SHORT trade: Sell+Entry, Buy+Exit
  // ----------------------------------
  // 12 Rate could be conversion rate?
  // ----------------------------------
  procedure SetFieldNumbers();
  var
    j : integer;
  begin
    // find/map Ninja CSV fields
    k := 0;
    for j := 0 to (fieldLst.Count - 1) do begin
      if fieldLst[j] = 'TIME' then begin // Date/Time
        iDt := j;
        k := k or 1;
      end
      else if fieldLst[j] = 'E/X' then begin // Open/Close
        iOC := j;
        k := k or 2;
      end
      else if (fieldLst[j] = 'QTY') or (fieldLst[j] = 'QUANTITY') then begin // Shares/Contracts
        iShr := j;
        k := k or 4;
      end
      else if fieldLst[j] = 'INSTRUMENT' then begin // Ticker
        iTk := j;
        k := k or 8;
      end
      else if fieldLst[j] = 'ACTION' then begin // Buy/Sell (Long/Short)
        iLS := j;
        k := k or 16;
      end
      else if fieldLst[j] = 'PRICE' then begin
        iPr := j;
        k := k or 32;
      end
      else if fieldLst[j] = 'COMMISSION' then begin // Comm
        iCm := j;
        k := k or 64;
      end; // note: 'RATE' field is conversion factor
    end;
  end;
// --------------------------------------------
begin
  // ReadNinjaCSV
  bFoundHeader := false; // haven't found the header yet
  DataConvErrRec := '';
  // in case these are missing, flag to skip them.
  cancels := false;
  R := 0;
  // ----------------------------------
  try
    DataConvErrRec := '';
    DataConvErrStr := '';
    Adj := false;
    ImpNextDateOn := false;
    newColFormat := false;
    if ImpStrList.Count < 1 then begin
      ImpStrList.Destroy;
      result := 0;
      exit;
    end;
    fieldLst := TStrings.Create;
    // --------------------------------
    i := -1;
    while i < (ImpStrList.Count - 1) do begin
      inc(i); // make it work like a for/next
      contracts := false; // reset flags
      assigns := false;
      futures := false;
      miniOptions := false;
      optExpEx := false;
      bonds := false;
      // ------------------------------
      line := ImpStrList[i];
      line := uppercase(line); // search line for UPPERCASE tokens...
      // parse all columns into string list
      fieldLst := ParseCSV(line);
      if not bFoundHeader then begin
        if (pos('TIME', line) > 0) and (pos('ACTION', line) > 0) //
          and (pos('INSTRUMENT', line) > 0) then begin
          SetFieldNumbers;
          if SuperUser and (k <> 127) then
            sm('there appear to be fields missing.');
          bFoundHeader := true; // don't do this anymore
          R := 0; // start now
        end;
        Continue; // don't process anything until we recognize the header
      end;
      // ------------------------------
      if pos('ERROR', line) > 0 then begin
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        sm('Ninja reported an error.' + cr + 'Please reduce the date range and try again.');
        result := 0;
        exit;
      end;
      // --- Date ---------------------
      ImpTime := fieldLst[iDt]; // format: M/DD/YYYY H:MM:SS AM
      ImpDate := parsefirst(ImpTime, ' ');
      if (ImpDate = '') and (pos('/', ImpTime)> 1) then begin
        ImpDate := ImpTime;
        ImpTime := '';
      end;
      if (pos('-', Impdate) = 3) and (pos('-', Impdate, 4) = 7) then begin
        // probably dd-mmm-yy format
        dd := parsefirst(Impdate,'-');
        mm := parsefirst(Impdate, '-');
        mm := getExpMoNum(mm);
        yyyy := Impdate;
        if length(yyyy)=2 then yyyy := '20'+yyyy;
        Impdate := dd + '/' + mm + '/' + yyyy;
      end;
      if pos('/', ImpDate) = 2 then
        ImpDate := '0' + ImpDate;
      if not isdate(ImpDate) then
        sm('Cannot determine the transaction date of this trade:' + cr + line);
      if not ValidTradeDate(ImpDate, ImpDateLast, ImpNextDateOn) then begin
        Continue;
      end;
      if UserDateStrNotGreater(ImpDate, ImpDateLast) then begin
        if mDlg('Trades already imported for ' + ImpDate + cr //
            + cr //
            + 'Continue?', mtWarning, [mbNo, mbYes], 0) = mrNo then begin
          result := R;
          exit;
        end
        else
          ImpDateLast := '01/01/1900';
      end;
      inc(R); // if it gets this far, count it
      if pos(':', ImpTime) = 2 then
        ImpTime := '0' + ImpTime;
      // --- ticker -------------------
      tick := trim(fieldLst[iTk]);
      tick := formatFut(tick);
      // --- OC and LS ----------------
      junk := trim(fieldLst[iOC]);
      if (junk = 'ENTRY') then
        oc := 'O'
      else if (junk = 'EXIT') then
        oc := 'C'
      else
        oc := 'E'; // error
      // ---
      junk := trim(fieldLst[iLS]);
      if (junk = 'BUY') then begin
        if (oc = 'O') then
          ls := 'L' // open long
        else if (oc = 'C') then
          ls := 'S' // open short
        else
          ls := 'E'; // error
      end
      else if (junk = 'SELL') then begin
        if (oc = 'O') then
          ls := 'S' // close short
        else if (oc = 'C') then
          ls := 'L' // close long
        else
          ls := 'E'; // error
      end
      else
        ls := 'E'; // error
      // --- # shares -----------------
      ShStr := fieldLst[iShr];
      ShStr := delCommas(ShStr);
      // --- price --------------------
      PrStr := fieldLst[iPr];
      delete(PrStr, pos('$', PrStr), 1);
      PrStr := delCommas(PrStr);
      if (xStrToFloat(PrStr) = 0) then
        PrStr := '0.00';
      // --- Commission ---------------
      Commis := 0;
      CmStr := fieldLst[iCm];
      // --- amount -------------------
      Amount := 0; // let TL compute it
      // --- type ---------------------
      typeStr := futuresMult(tick, '', TradeLogFile.CurrentBrokerID);
      try
        Shares := CurrToFloat(ShStr);
        if Shares < 0 then
          Shares := -Shares;
        Price := CurrToFloat(PrStr);
        if Price < 0 then
          Price := -Price;
        if TradeLogFile.CurrentAccount.importFilter.SupportsCommission //
          and (TradeLogFile.CurrentAccount.Commission > 0) then
          Commis := TradeLogFile.CurrentAccount.Commission * Shares / 2
        else
          Commis := CurrToFloat(CmStr);
        if Commis < 0 then
          Commis := -Commis;
        ImpTrades[R].it := TradeLogFile.Count + R;
        ImpTrades[R].DT := ImpDate;
        ImpTrades[R].tm := ImpTime;
        ImpTrades[R].oc := oc;
        ImpTrades[R].ls := ls;
        ImpTrades[R].tk := tick;
        ImpTrades[R].sh := Shares;
        ImpTrades[R].pr := Price;
        ImpTrades[R].prf := typeStr;
        ImpTrades[R].cm := Commis;
        ImpTrades[R].am := Amount;
      except
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        dec(R);
        Continue;
      end;
    end; // while
    ImpStrList.Destroy;
    ReverseImpTradesDate(R);
    result := R;
  finally
    // readNinja
  end;
end;

// ------------------------------------
// ENTRY POINT
// ------------------------------------
function readNinja(): integer;
var
  R : integer;
begin
  // readNinja
  try
    R := 0;
    ImpStrList := TStringList.Create;
    ImpTrades := nil;
    setLength(ImpTrades, R + 1);
    GetImpDateLast;
    if FileExists(Settings.ImportDir + '\download.csv') then
      deleteFile(Settings.ImportDir + '\download.csv');
    GetImpStrListFromFile('NinjaTrader', 'csv', '');
    result := ReadNinjaCSV(ImpStrList);
    exit;
  finally
    // ReadNinja
  end;
end;


         // ------------------------------------+
         // Read Excel data from clipboard   |
         // ------------------------------------+

function ReadExcel(bFromGrid : boolean = false): integer;
var
  i, R, NextLotNum : integer;
  ImpDate, tmStr, OCstr, LSstr, PrStr, ShStr, CmStr, AmtStr, typeStr, line, sep, junk, exYr, exMo,
    under, multStr, convStr, lotStr : string;
  Shares, Amount, Commis, mult : double;
  ImpNextDateOn, contracts, timeOfDay : boolean;
  oc, ls : string;
begin
  try
    DataConvErrRec := '';
    DataConvErrStr := '';
    R := 0;
    ImpNextDateOn := false;
    NextLotNum := TradeLogFile.NextMatchNumber;
    ImpStrList := TStringList.Create;
    ImpTrades := nil;
    setLength(ImpTrades, R + 1);
    GetImpDateLast;
    // ----------------------
    GetImpStrListFromClip(false); // <--- Copy from Excel, Paste into TL
    // ----------------------
    if ImpStrList.Count = 0 then begin
      sm('There was no no data on the clipboard to import.' + cr +
          'Did you copy your data to the Windows clipboard?');
      result := 0;
      exit;
    end;
    // ------- optional fields --------
    if (pos('TIME', uppercase(ImpStrList[0])) > 0) then
      timeOfDay := true
    else
      timeOfDay := false;
    // --------------------------------
    for i := 0 to ImpStrList.Count - 1 do begin
      contracts := false;
      inc(R);
      if R < 1 then
        R := 1;
      sep := TAB;
      line := trim(ImpStrList[i]) + sep;
      // remove the ID column
      if bFromGrid then
        delete(line, 1, pos(sep, line));
      ImpDate := trim(copy(line, 1, pos(sep, line)));
      if (pos('/', ImpDate) = 0) then begin
        dec(R);
        if (i = ImpStrList.Count - 1) and (R = 0) then begin
          DataConvErrRec := 'No Data Selected';
          sm('Import Error' + cr + cr + 'Please reselect entire table');
          exit(0);
        end;
        Continue;
      end;
      ImpDate := LongDateStr(ImpDate);
      try
        if not ValidTradeDate(ImpDate, ImpDateLast, ImpNextDateOn) then begin
          dec(R);
          Continue;
        end;
      except
        mDlg(ImpDate + ' is an invalid date!' + cr + cr //
            + 'Please fix this in your sheet and re-import', mtError,[mbOK], 1);
        exit(0);
      end;
      delete(line, 1, pos(sep, line));
      line := lowercase(line);
      if frac(R / 100) = 0 then
        StatBar('Importing ' + IntToStr(R));
      // ------------------------------
      // time
      if timeOfDay then begin
        tmStr := trim(copy(line, 1, pos(sep, line)));
        delete(line, 1, pos(sep, line));
        tmStr := formatTime(tmStr);
      end;
      // ------------------------------
      // open/close
      OCstr := trim(copy(line, 1, pos(sep, line)));
      if (pos('b', OCstr) = 1) or (pos('p', OCstr) = 1) or (pos('o', OCstr) = 1) then
        oc := 'O'
      else if (pos('w', OCstr) = 1) then
        oc := 'W'
      else if (pos('s', OCstr) = 1) or (pos('c', OCstr) = 1) then
        oc := 'C'
      else begin
        dec(R);
        Continue;
      end;
      // ------------------------------
      // long/short
      // NOTE: The way Dave designed this, simply using O with S does NOT
      // result in an open short position! Do that with "Sell to Open"
      ls := 'L';
      if (pos('short', OCstr) > 0) or (pos('cover', OCstr) > 0) then begin
        if oc = 'C' then
          oc := 'O'
        else if oc = 'O' then
          oc := 'C';
        ls := 'S';
      end
      else if (pos('open', OCstr) > 0) then begin
        if oc = 'C' then begin
          oc := 'O';
          ls := 'S';
        end;
      end
      else if (pos('close', OCstr) > 0) then begin
        if oc = 'O' then begin
          oc := 'C';
          ls := 'S';
        end;
      end;
      delete(line, 1, pos(sep, line));
      if ls = 'L' then begin
        ls := uppercase(trim(copy(line, 1, pos(sep, line))));
        if (pos('S', ls) = 1) then begin
          ls := 'S';
          if oc = 'O' then
            oc := 'C'
          else if oc = 'C' then
            oc := 'O';
        end
        else if (pos('ENTRY', ls) > 0) then begin
          if oc = 'C' then begin
            oc := 'O';
            ls := 'S';
          end
          else
            ls := 'L';
        end
        else if (pos('EXIT', ls) > 0) then begin
          if oc = 'O' then begin
            oc := 'C';
            ls := 'S';
          end
          else
            ls := 'L';
        end
        else
          ls := 'L';
      end;
      delete(line, 1, pos(sep, line));
      // ------------------------------
      // ticker
      tick := trim(copy(line, 1, pos(sep, line)));
      tick := uppercase(tick);
      delete(line, 1, pos(sep, line));
      // ------------------------------
      // shares
      ShStr := trim(copy(line, 1, pos(sep, line)));
      delete(line, 1, pos(sep, line));
      // ------------------------------
      // price
      PrStr := trim(copy(line, 1, pos(sep, line)));
      delete(line, 1, pos(sep, line));
      // ------------------------------
      // comm
      Commis := 0;
      CmStr := trim(copy(line, 1, pos(sep, line)));
      delete(line, 1, pos(sep, line));
      // ------------------------------
      // amount
      Amount := 0;
      if not bFromGrid then begin
        AmtStr := trim(copy(line, 1, pos(sep, line)));
        delete(line, 1, pos(sep, line));
      end;
      // ------------------------------
      // type
      typeStr := trim(uppercase(copy(line, 1, pos(sep, line))));
      delete(line, 1, pos(sep, line));
      // ------------------------------
      // mult
      multStr := trim(uppercase(copy(line, 1, pos(sep, line))));
      delete(line, 1, pos(sep, line));
      // ------------------------------
      // conversion rate
      convStr := trim(uppercase(copy(line, 1, pos(sep, line))));
      delete(line, 1, pos(sep, line));
      // ------------------------------
      // tax lots
      lotStr := trim(uppercase(copy(line, 1, pos(sep, line))));
      delete(line, 1, pos(sep, line));
      if (lotStr <> '') then begin
        if isInt(lotStr) then
          lotStr := IntToStr((strToInt(lotStr) + NextLotNum - 1));
      end;
      // ------------------------------
      // type/mult
      if (pos('O', typeStr) = 1) then begin
        typeStr := 'OPT-100';
        mult := 100;
      end
      else if (pos('F', typeStr) = 1) then begin
        tick := formatFut(tick);
        if (multStr <> '') and IsFloat(multStr) then
          typeStr := 'FUT-' + multStr
        else
          typeStr := futuresMult(tick, '', TradeLogFile.CurrentBrokerID);
        if (convStr <> '') and IsFloat(convStr) then begin
          try
            multStr := parseLast(typeStr, '-');
            mult := StrToFloat(multStr, Settings.InternalFmt) *
              StrToFloat(convStr, Settings.InternalFmt);
            typeStr := 'FUT-' + floattostr(mult, Settings.InternalFmt);
          except
            // nothing
          end;
        end;
        AmtStr := '';
      end
      else if (pos('C', typeStr) = 1) then begin
        typeStr := 'CUR-1';
        if (convStr <> '') and IsFloat(convStr) then
          typeStr := 'CUR-' + convStr;
        AmtStr := '';
      end
      else if (pos('D', typeStr) = 1) then begin // 2018-02-22 MB new type D --> DCY
        typeStr := 'DCY-1'; // Digital Currency
        if (convStr <> '') and IsFloat(convStr) then
          typeStr := 'DCY-' + convStr;
        AmtStr := '';
      end
      else begin
        mult := 1;
        typeStr := 'STK-1';
      end;
      if (pos('FUT', typeStr) = 0) and (pos('CUR', typeStr) = 0) then begin
        // delete spaces
        if length(tick) < 8 then begin
          while pos(' ', tick) > 0 do
            delete(tick, pos(' ', tick), 1);
          // delete dashes
          while pos('-', tick) > 0 do
            delete(tick, pos('-', tick), 1);
          // delete dots
          while pos('.', tick) > 0 do
            delete(tick, pos('.', tick), 1);
        end;
      end;
      // ------------------------------
      try
        Shares := CurrToFloat(ShStr);
        if Shares < 0 then
          Shares := -Shares;
        // ------------------
        Price := CurrToFloat(PrStr);
        if Price < 0 then
          Price := -Price;
        // ------------------
        if CmStr <> '' then begin
          Commis := CurrToFloat(CmStr);
          if Commis < 0 then
            Commis := -Commis;
        end;
        // ------------------
        if (AmtStr <> '') then begin
          Amount := CurrToFloat(AmtStr);
          if (oc <> 'W') and (Amount < 0) then
            Amount := -Amount;
        end;
        // ------------------
        // calc comm from amount
        if Amount <> 0 then begin
          if oc = 'W' then begin
            Commis := 0;
          end
          else if ls = 'L' then begin
            if (oc = 'O') then
              Commis := Amount - (Shares * Price * mult)
            else
              Commis := (Shares * Price * mult) - Amount;
          end
          else if ls = 'S' then begin
            if (oc = 'O') then
              Commis := (Shares * Price * mult) - Amount
            else
              Commis := Amount - (Shares * Price * mult);
          end;
        end;
        // ----------------------------
        ImpTrades[R].it := TradeLogFile.Count + R;
        ImpTrades[R].DT := ImpDate;
        ImpTrades[R].tm := tmStr;
        ImpTrades[R].oc := oc;
        ImpTrades[R].ls := ls;
        ImpTrades[R].tk := tick;
        ImpTrades[R].sh := Shares;
        ImpTrades[R].pr := Price;
        ImpTrades[R].prf := typeStr;
        ImpTrades[R].cm := Commis;
        ImpTrades[R].am := Amount;
        ImpTrades[R].m := lotStr;
      except
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        dec(R);
        Continue;
      end;
      { comm }
    end;
    ImpStrList.Destroy;
    SortImpByDate(R);
    result := R;
  finally
    // ReadExcel
  end;
end;


// --------------------------------------------------------
// #####          #        ##       #
// #      #       #  ###    #   #   #
// #          ##### #   #   #     ##### #  #
// ####  ##  #    # #####   #  ##   #    ##
// #      #  #    # #       #   #   #     #
// #     ###  #####  ##### ### ###  ###  ##
// --------------------------------------------------------

function readFidelity_CSV(webCopy : boolean): integer;
var
  i, j, l, p, R : integer;
  ImpDate, PrStr, prfStr, AmtStr, ShStr, CommStr, feeStr, intStr, line, sep, NextDate, descr,
    strikePr, exDay, exMon, exYr, putCall, opTick, s, junk, sType, oc, ls, t : string;
  Amount, Commis, newComm, mult : double;
  acctCol, contracts, cancels, ImpNextDateOn, fracSh, newCSV, newOptFormat, bonds,
    miniOptions : boolean;
begin // ReadFidelity_CSV
  Amount := 0;
  Commis := 0;
  R := 0;
  GetImpDateLast;
  DataConvErrRec := '';
  DataConvErrStr := '';
  cancels := false;
  ImpNextDateOn := false;
  sep := ',';
  newCSV := false;
  acctCol := false;
  // ------------------------
  if not webCopy then begin
    ImpStrList := TStringList.Create;
    GetImpStrListFromFile('Fidelity', 'csv', '');
  end;
  // ------------------------
  if ImpStrList.Count < 1 then begin
    ImpStrList.Destroy;
    result := 0;
    exit;
  end;
  // ------------------------
  try
    for i := 0 to ImpStrList.Count - 1 do begin
      miniOptions := false;
      contracts := false;
      opTick := '';
      fracSh := false;
      bonds := false;
      inc(R);
      if R < 1 then
        R := 1;
      line := trim(uppercase(ImpStrList[i]));
      if (line = '') then begin
        dec(R);
        Continue;
      end;
    // remove tabs
      while pos(TAB, line) > 0 do
        delete(line, pos(TAB, line), 1);
      line := trim(line);
      if (pos('EXCHANGE QUANTITY', line) > 0) then
        newCSV := true;
      if (pos(',ACCOUNT,', line) > 0) then
        acctCol := true;
      ImpDate := trim(copy(line, 1, pos(sep, line) - 1));
      if pos('/', ImpDate) <> 3 then begin
        dec(R);
        Continue;
      end;
      if not ValidTradeDate(ImpDate, ImpDateLast, ImpNextDateOn) then begin
        dec(R);
        Continue;
      end;
      delete(line, 1, pos(sep, line));
      line := trim(line);
      if acctCol then begin
        delete(line, 1, pos(sep, line));
        line := trim(line);
      end;
    // open/close long/short
      oc := lowercase(trim(copy(line, 1, pos(sep, line) - 1))); // sm(oc);
      if (pos('buy cancelled', oc) > 0) then begin
        oc := 'X';
        ls := 'L';
        cancels := true;
      end
      else if (pos('sell cancelled', oc) > 0) or (pos('sale cancelled', oc) > 0) then begin
        oc := 'X';
        ls := 'L';
        cancels := true;
      end
      else if (pos('you bought', oc) > 0) //
      or (pos('reinvestment', oc) > 0) then begin
      // --- type -----------
        if (pos(' call make whole ', oc) > 0) then
          bonds := true
        else if (pos(' call ', oc) > 0) or (pos(' put ', oc) > 0) then
          contracts := true; // original code
      // --- LS -------------
        if pos('short', oc) > 0 then begin
          oc := 'C';
          ls := 'S';
        end
        else if (pos('opening transaction', oc) > 0) then begin
          oc := 'O';
          ls := 'L';
          contracts := true;
        end
        else if pos('closing transaction', oc) > 0 then begin
          oc := 'C';
          ls := 'S';
          contracts := true;
        end
        else begin
          oc := 'O';
          ls := 'L';
        end;
      end
      else if pos('you sold', oc) > 0 then begin
      // --- type -----------
        if (pos(' call make whole ', oc) > 0) then
          bonds := true
        else if (pos(' call ', oc) > 0) or (pos(' put ', oc) > 0) then
          contracts := true; // original code
        if pos('short', oc) > 0 then begin
          oc := 'O';
          ls := 'S';
        end
        else if pos('opening transaction', oc) > 0 then begin
          if pos('short', oc) > 0 then begin
            oc := 'O';
            ls := 'S';
          end
          else begin
            oc := 'O';
            ls := 'S';
            contracts := true;
          end;
        end
        else if pos('closing transaction', oc) > 0 then begin
        // fixed 4-12-02
          oc := 'C';
          ls := 'L';
          contracts := true;
        end
        else begin
          oc := 'C';
          ls := 'L';
        // end;
        end;
      end
      else if (pos('in lieu of frx share', oc) > 0) then begin
        fracSh := true;
        oc := 'O';
        ls := 'L';
        contracts := false;
      end
      else begin // you sold
        dec(R);
        Continue;
      end;
      delete(line, 1, pos(sep, line));
      line := trim(line);
    // ticker
      tick := trim(copy(line, 1, pos(sep, line) - 1));
    // added to filter out money market accounts
      if ((pos('XX', tick) > 0) and (pos('XX', tick) = length(tick) - 1) and (pos('F', tick) = 1))
        or (tick = 'FCASH') then begin
        dec(R);
        Continue;
      end;
      if pos('-', tick) = 1 then
        delete(tick, 1, 1);
      delete(line, 1, pos(sep, line));
      line := trim(line);
    // descr
      if contracts then begin
        opTick := tick;
        descr := trim(copy(line, 1, pos(sep, line) - 1));
      // PUT (LEAP 2009) (ZKK SULPHCO INC COM JAN 5 (100 SHS) (ZKK
      // CALL (TBT) PROSHARES JAN 48 (100 SHS)
      // get rid of SHS)
        p := pos('SHS)', descr);
        if p > 0 then begin
          if pos('(10 SHS)', descr)> 0 then
            miniOptions := true
          else
            miniOptions := false;
          descr := trim(leftStr(descr, p - 1));
          strikePr := ParseLastN(descr, ' (');
        end;
        strikePr := parseLast(descr, ' ');
        if pos('/', strikePr) > 0 then begin
        // change fractions to decimal
          strikePr := fracToDecStr(strikePr);
          strikePr := parseLast(descr, ' ') + strikePr;
        end;
        exMon := parseLast(descr, ' ');
      // test for year and day
        if isInt(exMon) then begin
          exYr := exMon;
          exDay := parseLast(descr, ' ');
          exMon := parseLast(descr, ' ');
        end
        else
          exYr := '';
        if pos('LEAP ', descr) > 0 then begin
        // CALL(LEAP 2010) (WSK PROSHARES
          exYr := copy(descr, pos('LEAP ', descr) + 7, 2);
          if pos('(LEAP', descr) > 0 then begin
            delete(descr, pos('(LEAP', descr), pos(')', descr) - pos('(LEAP', descr) + 1);
          end;
          putCall := copy(descr, 1, pos(' ', descr) - 1);
          delete(descr, 1, pos(' ', descr));
          descr := trim(descr);
          if pos('(', descr) > 0 then begin
            tick := parseLast(descr, '(');
            tick := parsefirst(tick, ' ');
            descr := descr + tick;
            tick := '';
            delete(descr, pos('(', descr), pos(' ', descr) - pos('(', descr) + 1);
          end;
        end
        else begin
          if pos('(', descr) > 0 then begin
            if pos(')', descr) > 0 then begin
              tick := parseLast(descr, ')');
              tick := parseLast(descr, '(');
              descr := descr + tick;
              tick := '';
              delete(descr, pos('(', descr), pos(')', descr) - pos('(', descr) + 1);
            end
            else begin
            // no closing paranthesis ie: CALL (F FORD MTR CO DEL
              tick := parseLast(descr, '(');
              tick := copy(tick, 1, pos(' ', tick) - 1);
              descr := descr + tick;
            end;
          end;
          putCall := copy(descr, 1, pos(' ', descr) - 1);
          delete(descr, 1, pos(' ', descr));
        end;
      //
        if pos('SECTOR ', descr) > 0 then
          delete(descr, 1, pos('SECTOR ', descr) + 6);
        if pos('TR SHS', descr) > 0 then
          delete(descr, pos('TR SHS', descr), 6);
      //
        if exYr = '' then begin
          if getExpMoNum(exMon) >= copy(ImpDate, 1, 2) then begin
            exYr := copy(ImpDate, 9, 2);
          end
          else begin
            exYr := IntToStr(strToInt(copy(ImpDate, 9, 2)) + 1);
            if length(exYr) = 1 then
              exYr := '0' + exYr;
          end;
        end;
      // delete paranethesis and option ticker symbol
        if pos('(', descr) > 0 then
          delete(descr, 1, pos(' ', descr));
        if rightStr(descr, 1)= '7' then
          delete(descr, length(descr), 1);
      //
        newOptFormat := false;
        s := opTick;
        l := length(s);
      // test for new option format
      // first test if cusip
        if (not isInt(copy(s, 1, 1))) and (isInt(rightStr(s, 1))) then
          for j := 2 to l do begin
            if (length(s) > 7) and (isInt(copy(s, j, 1))) then begin
              newOptFormat := true;
              break;
            end;
          end;
        if newOptFormat then begin
        // CMED100220C15
        // VZ 111 01 22 P 28 ???
          exDay := '';
        // get pos of C or P
          for p := l downto 7 do
            if copy(s, p, 1) = 'P' then begin
              putCall := 'PUT';
              strikePr := rightStr(s, l - p);
              delete(s, p, l - p + 1);
              break;
            end
            else if copy(s, p, 1) = 'C' then begin
              putCall := 'CALL';
              strikePr := rightStr(s, l - p);
              delete(s, p, l - p + 1);
              break;
            end;
          exDay := rightStr(s, 2);
          l := length(s);
          delete(s, l - 1, 2);
          exMon := rightStr(s, 2);
          exMon := getExpMo(exMon);
          l := length(s);
          delete(s, l - 1, 2);
          exYr := rightStr(s, 2);
          l := length(s);
          delete(s, l - 1, 2);
        // check if extra digit in year - ie: VZ 111 01 22 P 28 ???
          l := length(s);
          if isInt(rightStr(s, 1)) then
            delete(s, l, 1);
        end;
        if pos('$', strikePr) = 1 then
          delete(strikePr, 1, 1);
        descr := copy(descr, 1, 20); // limit to 1st 20 char's
        if newOptFormat then
          tick := s + ' ' + exDay + exMon + exYr + ' ' + strikePr + ' ' + putCall
        else
          tick := descr + ' ' + exDay + exMon + exYr + ' ' + strikePr + ' ' + putCall;
      // end if
      end
      else begin
      // added 2010-07-13 for Bonds
        descr := trim(copy(line, 1, pos(sep, line) - 1));
        if (pos('UNITED STATES TREAS', descr) > 0) then
          bonds := true
        else if (pos('CALL MAKE WHOLE', descr) > 0) then
          bonds := true
        else
          bonds := false;
      end;
      delete(line, 1, pos(sep, line));
      line := trim(line);
    // 2014-05-09 to filter out cash div reinvestments
      if (pos('CASH', descr) = 1) then begin
        dec(R);
        Continue;
      end;
    // 2015-06-17 DE ticker = 3 word description
      if (tick = '') //
        or isInt(rightStr(tick, 3)) // ticker is a cusip
      then
        tick := trim(copy(descr, 1, 40)); // 2019-02-06 MB - used to be parseWords(descr, 3);
    // Security Type  2015-06-17 DE  fix for short sales
      sType := uppercase(trim(copy(line, 1, pos(sep, line) - 1)));
      if not contracts and (sType = 'SHORT') then
        if ((oc = 'O') and (ls = 'L')) then begin
          oc := 'C';
          ls := 'S';
        end
        else if ((oc = 'C') and (ls = 'L')) then begin
          oc := 'O';
          ls := 'S';
        end;
      delete(line, 1, pos(sep, line));
      line := trim(line);
    // shares
      if newCSV then begin // delete exchange qty and currency columns
        delete(line, 1, pos(sep, line));
        line := trim(line);
        delete(line, 1, pos(sep, line));
        line := trim(line);
      end;
      ShStr := trim(copy(line, 1, pos(sep, line) - 1));
      if ShStr = '' then begin
        dec(R);
        Continue;
      end;
      delete(line, 1, pos(sep, line));
      line := trim(line);
    // price
      if newCSV then // delete currency column
      begin
        delete(line, 1, pos(sep, line));
      end;
      PrStr := trim(copy(line, 1, pos(sep, line) - 1));
      delete(line, 1, pos(sep, line));
      line := trim(line);
    // comm
      if newCSV then begin // delete exchange rate column
        delete(line, 1, pos(sep, line));
      end;
      CommStr := trim(copy(line, 1, pos(sep, line) - 1));
      delete(line, 1, pos(sep, line));
      line := trim(line);
    // fees
      feeStr := trim(copy(line, 1, pos(sep, line) - 1));
      delete(line, 1, pos(sep, line));
      line := trim(line);
    // int
      intStr := trim(copy(line, 1, pos(sep, line) - 1));
      delete(line, 1, pos(sep, line));
      line := trim(line);
    // amount
      AmtStr := trim(copy(line, 1, pos(sep, line) - 1));
    // ----------------------
      try
        Shares := StrToFloat(ShStr, Settings.InternalFmt);
      // set long/short for cancelled trades
        if ((oc = 'X') and (Shares < 0)) //
          or ((oc = 'X') and (sType = 'SHORT')) then
          ls := 'S';
        if Shares < 0 then begin
          Shares := -Shares;
          if fracSh then
            oc := 'C';
        end;
        Price := StrToFloat(PrStr, Settings.InternalFmt);
      // if bonds then price:= price/100;
        Amount := StrToFloat(AmtStr, Settings.InternalFmt);
      // fix for BUY CANCELLED with positive amount
        if (oc = 'X') // and (LS = 'L')
          and (Amount > 0) then
          Amount := -Amount;
      // find cancel or correction Trades 3-22-04
        if (((oc = 'O') and (ls = 'L')) or ((oc = 'C') and (ls = 'S'))) //
          and (Amount > 0) then begin
          cancels := true;
          oc := 'X';
        end;
        if (((oc = 'C') and (ls = 'L')) or ((oc = 'O') and (ls = 'S'))) //
          and (Amount < 0) then begin
          cancels := true;
          oc := 'X';
        end;
        if Amount < 0 then
          Amount := -Amount;
        if CommStr = '' then
          CommStr := '0.00';
        if feeStr = '' then
          feeStr := '0.00';
        if intStr = '' then
          intStr := '0.00';
        Commis := StrToFloat(CommStr, Settings.InternalFmt) +
          StrToFloat(feeStr, Settings.InternalFmt) + StrToFloat(intStr, Settings.InternalFmt);
        if contracts then begin
          if bonds then
            sm('ERROR: bonds and contracts both detected.');
        // mini options
          if miniOptions then begin
            mult := 10;
            prfStr := 'OPT-10';
          end
          else begin
            mult := 100;
            prfStr := 'OPT-100';
          end;
        end
        else begin
          mult := 1;
          prfStr := 'STK-1';
        end;
      // --------------------
        if bonds then begin
          if (((oc = 'O') and (ls = 'L')) or ((oc = 'C') and (ls = 'S'))) then
            Price := (Amount - Commis) / Shares
          else
            Price := (Amount + Commis) / Shares;
        end
        else if miniOptions then begin
        // ignore huge Fees and recalc commis
          if (((oc = 'O') and (ls = 'L')) or ((oc = 'C') and (ls = 'S'))) then
            Commis := (Shares * Price * mult) - Amount
          else
            Commis := Amount - (Shares * Price * mult);
          if Commis < 0 then
            Commis := -Commis;
        end
        else begin // calculate correct price if price is rounded
          if (((oc = 'O') and (ls = 'L')) or ((oc = 'C') and (ls = 'S'))) then
            Price := (Amount - Commis) / Shares / mult
          else
            Price := (Amount + Commis) / Shares / mult;
        end;
      except
        dec(R);
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
      end;
      ImpTrades[R].it := TradeLogFile.Count + R;
      ImpTrades[R].tr := 0;
      ImpTrades[R].DT := ImpDate;
      ImpTrades[R].tm := '';
      ImpTrades[R].oc := oc;
      ImpTrades[R].ls := ls;
      ImpTrades[R].tk := tick;
      ImpTrades[R].sh := Shares;
      ImpTrades[R].pr := Price;
      ImpTrades[R].prf := prfStr;
      ImpTrades[R].cm := Commis;
      ImpTrades[R].am := Amount;
      ImpTrades[R].no := '';
      ImpTrades[R].m := '';
      ImpTrades[R].br := IntToStr(TradeLogFile.CurrentBrokerID);
      ImpTrades[R].opTk := opTick;
    end;
  except
    on e : Exception do begin
      if (DEBUG_MODE > 1) and SuperUser then begin
        t := clipBoard.astext; // save
        clipBoard.astext := 'ERROR importing line #' + IntToStr(i) + CRLF //
          + e.ClassName + ': ' + e.Message;
        sm(clipBoard.astext);
        clipBoard.astext := t; // restore
        R := 0; // abort
      end;
    end;
  end;
  StatBar('off');
  ImpStrList.Destroy;
  if R > 1 then begin
    ReverseImpTradesDate(R);
  end;
  if (R > 0) and cancels then begin
    for i := 1 to R do begin
      StatBar('Matching Cancelled Trades: ' + IntToStr(i));
      for j := 1 to R do begin
        if (ImpTrades[i].oc = 'X') //
        and (ImpTrades[i].tk = ImpTrades[j].tk) //
        and (rndTo6(ImpTrades[i].sh) = rndTo6(ImpTrades[j].sh)) //
        and (rndto2(ImpTrades[i].am) = rndto2(ImpTrades[j].am)) //
        and (ImpTrades[i].prf = ImpTrades[j].prf) //
        and (ImpTrades[i].ls = ImpTrades[j].ls) //
        and (ImpTrades[j].oc <> '') //
        and (i <> j) then begin
          glNumCancelledTrades := glNumCancelledTrades + 2;
          ImpTrades[i].oc := '';
          ImpTrades[i].ls := '';
          ImpTrades[i].tm := '';
          ImpTrades[j].oc := '';
          ImpTrades[j].ls := '';
          ImpTrades[j].tm := '';
          break;
        end;
      end;
    end;
  end;
  fixImpTradesOutOfOrder(R);
  result := R;
end; // ReadFidelity_CSV


function ReadFidelityCSV2(): integer;
var
  i, j, k, R, Q, iFmt : integer;
  iDt, iBS, iOC, iLS, iTk, iTyp, iShr, iPr, iAmt, iFee, iCm : integer; // import fields
  line, junk, sep, sTmp, ImpDate, CmStr, feeStr, PrStr, AmtStr, ShStr, typeStr, optDesc, //
    optOC, opYr, opMon, opDay, opStrike, opCP, optTick, oc, ls, errLogTxt, opStrik2, sNote : string;
  Amount, Commis, Fees, Shares, mult : double;
  contracts, Adj, optExpEx, ImpNextDateOn, bonds, newColFormat, miniOptions, futures, //
    bFoundHeader, cancels, assigns, divReinv : boolean;
  fieldLst : TStrings;
  // ----------------------------------
  procedure ClearFieldNums();
  begin
    iDt := 0;
    iTk := 0;
    iBS := 0;
    iOC := 0;
    iLS := 0;
    iTyp := 0;
    iShr := 0;
    iPr := 0;
    iAmt := 0;
    iFmt := 0;
    iFee := 0;
    iCm := 0;
  end;
  // ----------------------------------
  procedure SetFieldNumbers();
  var
    j : integer;
    s : string;
  begin
    // find/map Centerpoint CSV fields
    k := 0; // column check
    Q := 0; // highest j
    ClearFieldNums;
    iFmt := 1;
    for j := 0 to (fieldLst.Count - 1) do begin
      s := trim(fieldLst[j]);
      if pos('SECURITY ', s) = 1 then begin // 2024-05-23 MB
        s := copy(s, 10, length(s)-9);
      end;
      if s = 'RUN DATE' then begin //
        iDt := j;
        if (j > Q) then Q := j;
        k := k or 1;
      end
      else if s = 'SYMBOL' then begin //
        iTk := j;
        if (j > Q) then Q := j;
        k := k or 2;
      end
      else if s = 'ACTION' then begin //
        iBS := j;
        iOC := j;
        if (j > Q) then Q := j;
        k := k or 4;
      end
      else if (s = 'DESCRIPTION') then begin //
        iLS := j;
        if (j > Q) then Q := j;
        k := k or 8;
      end
      else if (s = 'TYPE') then begin //
        iTyp := j;
        if (j > Q) then Q := j;
        k := k or 16;
      end
      else if s = 'QUANTITY' then begin //
        iShr := j;
        if (j > Q) then Q := j;
        k := k or 32;
      end
      else if pos('PRICE', s) = 1 then begin //
        iPr := j;
        if (j > Q) then Q := j;
        k := k or 64;
      end
      else if pos('AMOUNT', s) = 1 then begin //
        iAmt := j;
        if (j > Q) then Q := j;
        k := k or 128;
      end
      // Commission,Fees
      else if pos('FEE', s) = 1 then begin //
        iFee := j;
        if (j > Q) then Q := j;
        k := k or 256;
      end
      else if pos('COMMISSION', s) = 1 then begin //
        iCm := j;
        if (j > Q) then Q := j;
        k := k or 512;
      end; // if cases
    end; // for j
    s := ''; // this line is just for placing a breakpoint!
  end;
  // ------------------------
  // sets OC and LS
  procedure DecodeOCLS(sActn, sTick, sDesc : string);
  begin
    // note: sets variables OC and LS directly
    oc := 'E';
    ls := 'E';
    divReinv := false;
    // ---- ACTION ----
    // YOU BOUGHT
    // YOU SOLD
    // YOU BOUGHT ... SHORT COVER
    // YOU SOLD ... SHORT SALE
    // YOU SOLD ... OPENING TRANSACTION
    // YOU BOUGHT ... CLOSING TRANSACTION
    //
    // ---- SYMBOL ----
    // <STOCK>
    // <OPTION> TICK YYMMDD?$$$
    //
    // ---- DESCRIPTION ----
    // <COMPANY>
    // <OPTION> CALL/PUT (TICK) COMPANY MMM DD YY $### (MUL SHS)
    // NOTE FROM TRADELOG.COM HELP:
    // BONDS - are entered as a security description exactly as
    // seen on your broker's monthly or end year tax statement
    // (ex. CALIFORNIA ST GO BDS ST)
    //
    // ---- SECURITY TYPE ----
    //
    if (pos('YOU BOUGHT', sActn) = 1) then begin
      if (pos('SHORT COVER', sActn) > 0) //
      or (pos('CLOSING TRANSACTION', sActn) > 0) //
      then begin
        oc := 'C';
        ls := 'S';
      end
      else begin
        oc := 'O';
        ls := 'L';
      end;
    end
    else if (pos('YOU SOLD', sActn) = 1) then begin
      if (pos('SHORT SALE', sActn) > 0) //
      or (pos('OPENING TRANSACTION', sActn) > 0) //
      then begin
        oc := 'O';
        ls := 'S';
      end
      else begin
        oc := 'C';
        ls := 'L';
      end;
    end
    else if (pos('SELL TO OPEN', sActn) = 1) //
      or (pos('SOLD SHORT', sActn) = 1) //
    then begin
      oc := 'O';
      ls := 'S';
    end
    else if (pos('BUY TO CLOSE', sActn) = 1) //
      or (pos('BOUGHT TO COVER', sActn) = 1) //
    then begin
      oc := 'C';
      ls := 'S';
    end
    else if pos('EXPIRE', sActn) > 0 then begin
      oc := 'C';
      ls := 'L';
      contracts := true;
    end
    else if pos('CANCEL', sActn) > 0 then begin
      oc := 'X';
      ls := 'L';
      cancels := true;
    end
    else if (pos('REINVEST', sActn) = 1) then begin
      oc := 'O';
      ls := 'L';
      divReinv := true;
    end
    else if (pos('BOUGHT', sActn) = 1) then begin //
      oc := 'O';
      ls := 'L';
    end
    else if (pos('SOLD', sActn) = 1) then begin //
      oc := 'C';
      ls := 'L';
    end
    else begin
      oc := 'E';
      ls := 'E';
    end;
    // --- if Description overrides ---
  end;
  // ------------------------
  // CALL SQUARE INC CLASS A AT 85.000
  // EXPIRES 01/17/2020 CLOSING VFIFO
  // tk       v
  // PYPL 220211C00125000
  // tick yymmdd^$$$$$...
  // ------------------------
  function DecodeOptTk(var sTk : string) : string;
  var
    n : integer;
    opYr, opMon, opDay, opStrike, opCP, opStrik2 : string;
  begin
    // Reset all local vars
    result := '';
    opStrike := '';
    opStrik2 := '';
    opYr := '';
    opMon := '';
    opDay := '';
    opCP := '';
    // --------------------
    // PYPL 220211C00125000
    // Tick YYMMDDX$$$$$ccc
    // ---------------------
    result := parsefirst(sTk, ' ');
    if sTk = '' then begin // assume format is like '-TSLA240202C182.5'
      sTk := result;
      opStrike := '';
      for n := length(sTk) downto 1 do begin
        if (sTk[n] = 'C') or (sTk[n] = 'P') then begin
          opCP := sTk[n];
          break;
        end
        else begin
          opStrike := sTk[n] + opStrike;
        end;
      end;
      sTk := leftStr(sTk, n);
      n := length(sTk)-6;
      opYr := copy(sTk, n, 2);
      opMon := copy(sTk, n+2, 2);
      opMon := getExpMo(opMon);
      opDay := copy(sTk, n+4, 2);
      result := leftStr(sTk, n-1);
    end
    else begin
      sTk := trim(sTk); // 2022-03-21 MB - remove extra space(s)
      opYr := copy(sTk, 1, 2);
      opMon := copy(sTk, 3, 2);
      opMon := getExpMo(opMon);
      opDay := copy(sTk, 5, 2);
      opCP := copy(sTk, 7, 1);
      opStrike := copy(sTk, 8, 5);
      opStrik2 := copy(sTk, 13, 3);
      n := strToInt(opStrike);
      opStrike := IntToStr(n); // removes leading zeros
      n := strToInt(opStrik2);
      if (n > 0) then
        opStrike := opStrike + '.' + IntToStr(n);
    end;
    if opCP = 'C' then
      opCP := 'CALL'
    else
      opCP := 'PUT';
    opStrike := delTrailingZeros(opStrike); // for matching
    result := result + ' ' + opDay + opMon + opYr + ' ' + opStrike + ' ' + opCP;
  end;
// --------------------------------------------
begin // ReadFidelityCSV2
  bFoundHeader := false; // haven't found the header yet
  // in case these are missing, flag to skip them.
  cancels := false;
  contracts := false;
  R := 0;
  try
    DataConvErrRec := '';
    DataConvErrStr := '';
    Commis := 0;
    ImpNextDateOn := false;
    // --------------------------------
    if ImpStrList.Count < 1 then begin
      ImpStrList.Destroy;
      result := 0;
      exit;
    end;
    iLS := 0; // no Long/Short indicator?
    fieldLst := TStrings.Create;
    // --------------------------------
    i := -1;
    while i < (ImpStrList.Count - 1) do begin
      inc(i); // make it work like a for/next
      contracts := false; // reset flags
      // ------------------------------
      line := ImpStrList[i];
      line := uppercase(line); // search line for UPPERCASE tokens...
      // ------------------------------
      if pos('"""', line) = 1 then
        line := copy(line, 3);
      // parse all columns into string list
      fieldLst := ParseCSV(line);
      if fieldLst.Count < Q then begin
        // sm('bad line: ' + line);
        Continue;
      end;
      if not bFoundHeader then begin
        if (pos('RUN DATE', line) > 0) // header format #1
          and (pos('SYMBOL', line) > 0) //
          and (pos('QUANTITY', line) > 0) then begin
          SetFieldNumbers;
          if SuperUser and (k <> 1023) then
            sm('there appear to be fields missing.');
          bFoundHeader := true; // don't do this anymore
          R := 0; // start now
        end;
        Continue; // don't process anything until we find the header!
      end; // header not found yet
      // ------------------------------
      if pos('ERROR', line) > 0 then begin
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        sm('Centerpoint reported an error.' + cr //
            + 'Please reduce the date range and try again.');
        result := 0;
        exit;
      end;
      // --- skip impossible records --
      // if Symbol is blank and Description is "No Description", always skip
      tick := trim(fieldLst[iTk]);
      if tick = '' then begin
      // if SuperUser then sm('blank ticker');
        continue;
      end;
      // if Quantity = 0, always skip
      ShStr := fieldLst[iShr];
      if ShStr = '' then begin
//        if SuperUser then sm('blank qty');
        continue;
      end;
      // if Price and Amount are both $0.00, always skip
      PrStr := fieldLst[iPr];
      delete(PrStr, pos('$', PrStr), 1);
      PrStr := delCommas(PrStr);
      AmtStr := fieldLst[iAmt];
      if (trim(prStr) = '') //
      or (trim(AmtStr) = '') then begin
//        if SuperUser then sm('price or amt blank');
        continue;
      end;
      if (strtofloat(prStr) = 0) //
      and (strtofloat(AmtStr) = 0) then begin
        continue;
      end;
      // (this handles the possibility of commission exactly cancelling out Qty*Price)
      // if Action begins with "ASSIGNED", "EXPIRED PUT", "EXPIRED CALL", "EXERCISED",
      // "NORMAL DISTR PARTIAL", "FED TAX", or "STATE TAX", always skip
      junk := trim(fieldLst[iBS]);
      if POS('EXPIRED CALL ', junk) = 1 then begin
        Continue;
      end;
      if POS('EXPIRED PUT ', junk) = 1 then begin
        Continue;
      end;
      if POS('ASSIGNED ', junk) = 1 then begin
        Continue;
      end;
      if POS('EXERCISED ', junk) = 1 then begin
        Continue;
      end;
      if POS('NORMAL DISTR ', junk) = 1 then begin
        Continue;
      end;
      if POS('FED TAX', junk) = 1 then begin
        Continue;
      end;
      if POS('STATE TAX', junk) = 1 then begin
        Continue;
      end;
      optDesc := trim(fieldLst[iLS]);
      // if Action begins with "REINVESTMENT CASH" or "INTEREST EARNED CASH",
      // and Description is "CASH", skip.
      // This may cause us to miss an occassional DRP, but it's probably better
      // than always importing and getting bad records!
      if (POS('REINVESTMENT CASH', junk) = 1) //
      or (POS('INTEREST EARNED CASH', junk) = 1) //
      then begin
        if optDesc = 'CASH' then
          Continue;
      end;
      // Go ahead and import if Action begins with "DIVIDEND RECEIVED"
      // or "IN LIEU OF", so long as none of the above rules are violated.
      if (POS('DIVIDEND RECEIVED', junk) = 1) //
      or (POS('IN LIEU OF', junk) = 1) //
      then begin
        if optDesc = 'CASH' then
          Continue;
      end;
      // Determine the type using the following logic:
      // --- ticker -------------------
      if leftStr(tick, 1) = '-' then begin
        tick := copy(tick, 2, length(tick)-1);
      end;
      if tick = '' then
        Continue;
      // -- PRF = Type/Mult -----------
      if iFmt = 1 then
        typeStr := trim(fieldLst[iTyp])
      else
        typeStr := 'STK-1';
      // if Description begins with "CALL" or "PUT"
      // and Symbol is more than 8 characters long, it's an OPT-100
      // everything else is a STK-1
      // unless/until the Symbol matches TradeType table (ETF, etc.)
      if (POS('CALL ', optDesc) = 1) //
      or (POS('PUT ', optDesc) = 1) then
        typeStr := 'OPTION';
      sTmp := trim(fieldLst[iOC]);
      if (typeStr = 'OPTION') then begin
        typeStr := 'OPT-100';
        mult := 100;
        contracts := true;
      end
      else if (pos(' PUT ', sTmp) > 1) //
      or (pos(' CALL ', sTmp) > 1) then begin
        typeStr := 'OPT-100';
        mult := 100;
        contracts := true;
      end
      else begin
        typeStr := 'STK-1'; // Make everything a stock
        mult := 1;
        contracts := false;
      end;
      // --- Date ---------------------
      ImpDate := trim(fieldLst[iDt]); // format: YYYY-MM-DDT00:00:00-hh:mm
      ImpDate := replacestr(ImpDate, '-', '/');
      if IsNumeric(leftStr(ImpDate,1))=false then begin // may be MMM-dd-yyyy format
        opMon := parsefirst(ImpDate, '/');
        opMon := getExpMoNum(opMon);
        ImpDate := opMon + '/' + ImpDate;
      end;
      if iFmt = 1 then begin
        if isdate(ImpDate)=false then begin
          sm('Cannot determine the transaction date of this trade:' + cr + line);
          Continue;
        end;
      end
      else if iFmt = 2 then begin
        ImpDate := MMDDYYYY(ImpDate); // NEW for iFmt 2
      end;
      if not ValidTradeDate(ImpDate, ImpDateLast, ImpNextDateOn) then begin
        DataConvErrRec := DataConvErrRec + 'invalid date: ' + ImpStrList[i] + cr;
        Continue;
      end;
      if UserDateStrNotGreater(ImpDate, ImpDateLast) then begin
        if mDlg('Trades already imported for ' + ImpDate + cr + cr //
          + 'Continue?', mtWarning, [mbNo, mbYes], 0) = mrNo then begin
          result := R;
          exit;
        end
        else
          ImpDateLast := '01/01/1900';
      end;
      // --- # shares -----------------
      ShStr := delCommas(ShStr);
      try
        Shares := CurrToFloat(ShStr);
      except
        Shares := 0;
      end;
      // --- OC and LS --------------------------
      junk := trim(fieldLst[iBS]);
      DecodeOCLS(junk, tick, sTmp);
      if oc = 'E' then Continue;
      if ls = 'E' then Continue;
      // ------------------------------
      inc(R); // if it gets this far, count it
      // ------------------------------
      if contracts then begin
        if pos('  ', tick) > 1 then
          tick := replacestr(tick, '  ', ' ');
        junk := DecodeOptTk(tick);
        if junk = '' then begin
          dec(R);
          Continue;
        end
        else begin
          tick := junk;
        end;
      end;
      // --- price --------------------
      if (xStrToFloat(PrStr) = 0) then
        PrStr := '0.00';
      // --- conversion rate
      // --- Fees & Commissions -------
      CmStr := trim(fieldLst[iCm]);
      feeStr := trim(fieldLst[iFee]);
      try
        Shares := CurrToFloat(ShStr);
        if Shares < 0 then Shares := -Shares; // ABS(Shares)
        Price := CurrToFloat(PrStr);
        if Price < 0 then Price := -Price; // ABS(Price)
        Amount := ABS(CurrToFloat(AmtStr)); // ABS(Amt)
        Commis := CurrToFloat(CmStr) + CurrToFloat(feeStr);
        // --- calculate Commission ---
        if ls = 'L' then begin
          if (oc = 'O') then
            Commis := Amount - (Shares * Price * mult)
          else
            Commis := (Shares * Price * mult) - Amount;
        end
        else if ls = 'S' then begin
          if (oc = 'O') then
            Commis := (Shares * Price * mult) - Amount
          else
            Commis := Amount - (Shares * Price * mult);
        end;
        // ------ set import record fields ------
        ImpTrades[R].it := TradeLogFile.Count + R;
        ImpTrades[R].DT := ImpDate;
        ImpTrades[R].oc := oc;
        ImpTrades[R].ls := ls;
        ImpTrades[R].tk := tick;
        ImpTrades[R].sh := Shares;
        ImpTrades[R].pr := Price;
        ImpTrades[R].prf := typeStr;
        ImpTrades[R].cm := RoundToDec(Commis, 8);
        ImpTrades[R].am := Amount;
        ImpTrades[R].no := sNote;
      except
        dec(R);
        Continue;
      end;
    end; // while
    // --------------------------------
    ReverseImpTradesDate(R);
// ReverseShortTrades(R);
    if cancels then begin
      for i := 1 to R do begin
        if (ImpTrades[i].oc = 'X') then
          for j := i + 1 downto 1 do begin
            if (ImpTrades[i].tk = ImpTrades[j].tk) //
              and (ImpTrades[i].sh = ImpTrades[j].sh) //
              and (ImpTrades[i].pr = ImpTrades[j].pr) //
              and (format('%1.2f', [ImpTrades[i].pr], Settings.UserFmt) = format('%1.2f',
                [ImpTrades[j].pr], Settings.UserFmt)) //
              and (ImpTrades[j].oc <> '') //
              and (i <> j) then begin
              glNumCancelledTrades := glNumCancelledTrades + 2;
              ImpTrades[i].oc := '';
              ImpTrades[i].ls := '';
              ImpTrades[j].oc := '';
              ImpTrades[j].ls := '';
              break;
            end;
          end;
      end;
    end;
    for i := 1 to R do begin
      if ImpTrades[i].oc = 'X' then begin
        sm('CANCEL TRADES NOT MATCHED!' + cr + cr +
            'Cancel Trades have Open/Close marked with an "X"');
        break;
      end;
    end;
    result := R;
    ImpStrList.Destroy;
  finally
    contracts := false; // just a place to put a breakpoint
  end;
end; // ReadFidelityCSV2


function ReadFidelity(): integer;
var
  R : integer;
begin
  try
    R := 0;
    ImpStrList := TStringList.Create;
    ImpTrades := nil;
    setLength(ImpTrades, R + 1);
    GetImpDateLast;
    // ----------------------
    if FileExists(Settings.ImportDir + '\download.csv') then
      deleteFile(Settings.ImportDir + '\download.csv');
    // ----------------------
    GetImpStrListFromFile('*', 'csv', ''); // from CSV file only
    result := ReadFidelityCSV2;
    // ----------------------
    exit;
  finally
    //
  end;
end; // ReadFidelity


         // -----------------
         // Folio
         // -----------------

function ReadFolioFN(): integer;
var
  i, R : integer;
  Shares, mult, Commis : double;
  Flds, prfStr, stock, exMoYr, putCall : string;
  NextDate : TDate;
  nextDateOnward : boolean;
  oc, ls : string;
begin
  try
    DataConvErrRec := '';
    DataConvErrStr := '';
    ImpStrList := TStringList.Create;
    ImpTrades := nil;
    setLength(ImpTrades, 1);
    GetImpDateLast;
    nextDateOnward := false;
    // --- QIF ----------------------------------
    GetImpStrListFromFile('FolioFN QIF', 'qif', '');
    // ------------------------------------------
    R := 0;
    i := 0;
    dte := '';
    oc := '';
    ls := '';
    tick := '';
    Shares := 0;
    Price := 0;
    Commis := 0;
    Amt := 0;
    while i < ImpStrList.Count - 1 do begin
      inc(i);
      Flds := ImpStrList[i];
      while pos(chr(13), Flds) > 0 do
        delete(Flds, pos(chr(13), Flds), 1);
      if pos('D', Flds) = 1 then begin // date
        inc(R);
        delete(Flds, 1, 1);
        if pos('''', Flds) > 0 then begin
          while pos(' ', Flds) > 0 do
            delete(Flds, pos(' ', Flds), 1);
          dte := copy(Flds, 1, pos('''', Flds) - 1);
          delete(Flds, 1, pos('''', Flds));
          // added 1-2-02 to fix date problem
          Flds := trim(Flds);
          if length(Flds) = 1 then
            dte := dte + '/200' + Flds
          else if length(Flds) = 2 then
            dte := dte + '/20' + Flds
          else if length(Flds) = 4 then
            dte := dte + '/' + Flds;
        end
        else
          dte := copy(Flds, 1, 10);
        dte := LongDateStr(dte);
        Continue;
      end
      else
        try
          if pos('N', Flds) = 1 then begin { o/c, l/s }
            delete(Flds, 1, 1);
            oc := lowercase(trim(Flds));
            ls := 'L';
            if (pos('sellshort', oc) > 0) //
              or (pos('shtsell', oc) > 0) then begin
              oc := 'C';
              // LS:= 'S';
            end
            else if (pos('cvrshrt', oc) > 0) then begin
              oc := 'O';
              // LS:= 'S';
            end
            else if (pos('buy', oc) > 0) then
              oc := 'O'
            else if (pos('sell', oc) > 0) then
              oc := 'C'
            else begin
              dec(R);
              while pos('^', Flds) = 0 do begin
                inc(i);
                Flds := ImpStrList[i];
              end;
            end;
            Continue;
          end
          else if pos('M', Flds) = 1 then begin { skip total }
            if (pos('Voided', Flds) > 0) then begin
              dec(R);
              while pos('^', Flds) = 0 do begin
                inc(i);
                Flds := ImpStrList[i];
              end;
            end;
            Continue;
          end
          else if pos('C', Flds) = 1 then
            Continue { skip C - what is it?? }
          else if pos('U', Flds) = 1 then
            Continue { skip total }
          else if pos('Y', Flds) = 1 then begin { ticker }
            delete(Flds, 1, 1);
            Flds := trim(Flds);
            while pos('*', Flds) > 0 do
              delete(Flds, pos('*', Flds), 1);
            tick := Flds;
            Continue;
          end
          else if pos('I', Flds) = 1 then begin { price }
            delete(Flds, 1, 1);
            Flds := trim(Flds);
            while pos(' ', Flds) > 0 do
              delete(Flds, pos(' ', Flds), 1);
            while pos(',', Flds) > 0 do
              delete(Flds, pos(',', Flds), 1);
            Price := StrToFloat(Flds, Settings.InternalFmt);
            Continue;
          end
          else if pos('Q', Flds) = 1 then begin { shares }
            delete(Flds, 1, 1);
            while pos(',', Flds) > 0 do
              delete(Flds, pos(',', Flds), 1);
            Flds := trim(Flds);
            while pos(' ', Flds) > 0 do
              delete(Flds, pos(' ', Flds), 1);
            Shares := StrToFloat(Flds, Settings.InternalFmt);
            Continue;
          end
          else if pos('T', Flds) = 1 then begin { amt }
            delete(Flds, 1, 1);
            while pos(',', Flds) > 0 do
              delete(Flds, pos(',', Flds), 1);
            trim(Flds);
            Amt := StrToFloat(Flds, Settings.InternalFmt);
            Continue;
          end
          else if pos('O', Flds) = 1 then begin { comm }
            delete(Flds, 1, 1);
            Flds := trim(Flds);
            while pos(',', Flds) > 0 do
              delete(Flds, pos(',', Flds), 1);
            while pos(' ', Flds) > 0 do
              delete(Flds, pos(' ', Flds), 1);
            Commis := StrToFloat(Flds, Settings.InternalFmt);
            Continue;
          end
          else if pos('^', Flds) = 1 then begin
            if (pos('PUT ', tick) = 1) //
              or (pos('CALL ', tick) = 1) then begin
              Shares := Shares / 100;
              mult := 100;
              prfStr := 'OPT-100';
              putCall := trim(copy(tick, 1, pos(' ', tick) - 1));
              delete(tick, 1, pos(' ', tick));
              tick := trim(tick);
              stock := trim(copy(tick, 1, pos(' ', tick) - 1));
              delete(tick, 1, pos(' ', tick));
              tick := trim(tick);
              exMoYr := trim(copy(tick, 1, pos(' ', tick) - 1)) + copy(dte, 9, 2);
              delete(tick, 1, pos(' ', tick));
              tick := trim(tick);
              tick := stock + ' ' + exMoYr + ' ' + tick + ' ' + putCall;
            end
            else begin
              mult := 1;
              prfStr := 'STK-1';
              if oc = 'O' then begin
                if (floattostrf(Amt, ffFixed, 8, 2, Settings.UserFmt)
                    = floattostrf(Shares * Price * 100 + Commis, ffFixed, 8, 2, Settings.UserFmt))
                then begin
                  mult := 100;
                  prfStr := 'OPT-100';
                end;
              end
              else if oc = 'C' then begin
                if (floattostrf(Amt, ffFixed, 8, 2, Settings.UserFmt)
                    = floattostrf(Shares * Price * 100 - Commis, ffFixed, 8, 2, Settings.UserFmt))
                then begin
                  mult := 100;
                  prfStr := 'OPT-100';
                end;
              end;
            end;
            // fixed problem with no SEC fees included in comm  1/4/02
            if (Amt <> 0) and (oc = 'O') then
              Commis := Amt - (Shares * Price * mult)
            else if (Amt <> 0) and (oc = 'C') then
              Commis := (Shares * Price * mult) - Amt;
            // ----------------------------------
            ImpTrades[R].it := TradeLogFile.Count + R;
            ImpTrades[R].DT := dte;
            ImpTrades[R].oc := oc;
            ImpTrades[R].ls := ls;
            ImpTrades[R].tk := tick;
            ImpTrades[R].sh := Shares;
            ImpTrades[R].pr := Price;
            ImpTrades[R].prf := prfStr;
            ImpTrades[R].cm := Commis;
            ImpTrades[R].am := Amt;
            // get rid of cash trust funds
            if (pos('TR US GOVT FD', tick) > 0) or (pos('FDIC SWEEP', tick) > 0) then
              dec(R);
            // check if dates already imported
            if UserDateStrNotGreater(dte, ImpDateLast) then begin
              NextDate := NextUserDate(ImpDateLast);
              if not nextDateOnward then begin
                if mDlg('Trades already imported for ' + ImpDateLast + cr + cr //
                    + 'Continue importing from ' + DateToStr(NextDate, Settings.UserFmt) //
                    + ' onward?' + cr, mtWarning, [mbNo, mbYes], 0) = mrNo then begin
                  result := 0;
                  exit;
                end
                else
                  nextDateOnward := true;
                dec(R);
              end
              else begin
                dec(R);
                if R < 0 then
                  R := 0;
              end;
            end;
            dte := '';
            oc := '';
            ls := '';
            tick := '';
            Shares := 0;
            Price := 0;
            Commis := 0;
            Amt := 0;
          end;
        except
          DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
          dec(R);
          Continue;
        end;
    end;
    ImpStrList.Destroy;
    SortImpByDate(R);
    result := R;
  finally
    // ReadFolioFN
  end;
end;


         // -----------------
         // Globex
         // -----------------

function ReadGlobex(): integer;
var
  i, R : integer;
  CurrYearStr, ImpDate, TimeStr, PrStr, prfStr, ShStr, line, sep : string;
  Price, mult, Amount, Commis : double;
  ClickedOK, contracts, ImpNextDateOn : boolean;
  oc, ls : string;
begin
  DataConvErrRec := '';
  DataConvErrStr := '';
  ImpNextDateOn := false;
  Amount := 0;
  Commis := 0;
  Price := 0;
  R := 0;
  ImpStrList := TStringList.Create;
  try
    ImpTrades := nil;
    setLength(ImpTrades, R + 1);
    GetImpDateLast;
    // --------------------------------
    // options: File, Web(paste)
    if sImpMethod = 'File' then begin // imFileImport: CSVImport
      GetImpStrListFromFile('Globex', 'txt', ''); // Import from CSV file
    end
    // --------------------------------
    else if sImpMethod = 'Web' then begin //
      GetImpStrListFromClip(false); // Import from Clipboard
    end
    else begin // only 2 choices
      if mDlg('Import from Web?' + cr //
          + cr //
          + 'Click No to import from Text File', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        GetImpStrListFromClip(false)
      else
        GetImpStrListFromFile('Globex', 'txt', '');
    end; // case of ImportMethod
    // --------------------------------
    sep := TAB;
    CurrYearStr := '';
    if ImpStrList.Count < 1 then begin
      result := 0;
      exit;
    end;
    for i := 0 to ImpStrList.Count - 1 do begin
      contracts := false;
      inc(R);
      if R < 1 then
        R := 1;
      line := trim(ImpStrList[i]) + sep;
      // date
      ImpDate := trim(copy(line, 1, pos(sep, line)));
      if pos('/', ImpDate) = 0 then begin
        dec(R);
        Continue;
      end;
      // fixed for Globex GLWin and Trading Technologies execution platform
      if length(ImpDate) < 6 then begin
        if CurrYearStr = '' then
          repeat
            CurrYearStr := copy(DateToStr(Date, Settings.InternalFmt),
              length(DateToStr(Date, Settings.InternalFmt)) - 3, 4);
            ClickedOK := myInputQuery('Please enter year of data file', '', CurrYearStr,
              frmMain.Handle);
            if not ClickedOK then begin
              result := 0;
              exit;
            end;
            if isInt(CurrYearStr) then
              break;
            sm('Year must be a number' + cr + 'ex: "2002"');
          until not ClickedOK;
        ImpDate := ImpDate + '/' + CurrYearStr;
      end;
      ImpDate := LongDateStr(ImpDate);
      if (i = ImpStrList.Count - 1) and (R = 0) then begin
        DataConvErrRec := 'No Data Selected';
        sm('Globex Import Error' + cr + cr + 'Please reselect entire report');
        result := 0;
        exit;
      end;
      if not ValidTradeDate(ImpDate, ImpDateLast, ImpNextDateOn) then begin
        dec(R);
        Continue;
      end;
      delete(line, 1, pos(sep, line));
      { time }
      TimeStr := trim(copy(line, 1, pos(sep, line) - 1));
      delete(line, 1, pos(sep, line));
      delete(line, 1, pos(sep, line));
      delete(line, 1, pos(sep, line));
      { ticker }
      tick := trim(copy(line, 1, pos(sep, line)));
      tick := uppercase(tick);
      delete(line, 1, pos(sep, line));
      { oc }
      oc := trim(copy(line, 1, pos(sep, line)));
      if oc = 'B' then
        oc := 'O'
      else if oc = 'S' then
        oc := 'C';
      ls := 'L';
      delete(line, 1, pos(sep, line));
      { shares }
      ShStr := trim(copy(line, 1, pos(sep, line) - 1));
      ShStr := DelParenthesis(ShStr);
      delete(line, 1, pos(sep, line));
      { price }
      PrStr := trim(copy(line, 1, pos(sep, line) - 1));
      delete(PrStr, pos('.', PrStr), 3);
      delete(line, 1, pos(sep, line));
      { amount }
      { comm }
      try
        Shares := strToInt(ShStr);
        Commis := Settings.SECFee * Shares;
        tick := formatFut(tick);
        prfStr := futuresMult(tick, '', TradeLogFile.CurrentBrokerID);
        if PrStr = '' then
          Price := 0
        else
          Price := FracDecToFloat(PrStr) / 100;
      except
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        dec(R);
        Continue;
      end;
      // ------------------------------
      ImpTrades[R].it := TradeLogFile.Count + R;
      ImpTrades[R].DT := ImpDate;
      ImpTrades[R].tm := formatTime(TimeStr);
      ImpTrades[R].oc := oc;
      ImpTrades[R].ls := ls;
      ImpTrades[R].tk := tick;
      ImpTrades[R].sh := Shares;
      ImpTrades[R].pr := Price;
      ImpTrades[R].prf := prfStr;
      ImpTrades[R].am := Amount;
      ImpTrades[R].cm := Commis;
    end;
  finally
    StatBar('off');
    result := R;
    ImpStrList.Destroy;
  end;
end; // ReadGlobex


         // ---------------------------
         // Goldman Sachs (Old code)
         // ---------------------------

function ReadGoldmanSachsOld(ImpStrList : TStringList): integer;
var
  i, j, p, R : integer;
  Shares, mult, Commis, Princ : double;
  ImpFile : textfile;
  PrincStr, line, sep, ImpDate, TimeStr, ShStr, PrStr, prfStr, AmtStr, CommStr, feeStr, fee2Str,
    myHour, callPut, strike, exYr, exMo, exDa : string;
  contracts, expire, timeOfDay, myPM, newFormat, cancels, optFormat : boolean;
  oc, ls : string;
begin
  R := 0;
  DataConvErrRec := '';
  DataConvErrStr := '';
  Commis := 0;
  R := 0;
  timeOfDay := false;
  cancels := false;
  sep := ',';
  // new format 2011-03-22:
  // "Account Number","Activity Type","Symbol/Description","Trade Date","Settle Date/ValueDate","Process Date","Quantity","Blotter","Settle CCY Price","Settle CCY Principal Amount","Total Settle CCY Clr, Comm, Brokerage Fees","Settle CCY Interest","Total Settle CCY Fees","Total Settle CCY Regulatory Fees","Total Settle CCY Rebates","Settle CCY Net Amount","Settle CCY Notional Value","Settle CCY Code",
  // "7EJF1209","P&L","","12/31/2009","12/31/2009","12/31/2009","0","","0","-19739.38","0","0","0","0","0","-19739.38","0","USD"
  // ----------
  // old format:
  // "Account Number","Activity Type","Quantity","Symbol","Trade Date","Settle Date/Value Date","USD Price","USD Net Amt/Net Notional Value","Den Curr Net Amt/Net Notional Value","Den Curr Code","Settle Curr Net Amt/Net Notional Value","Settle Curr Code",
  // "4MG01209","Buy","5000","AHM      ","08/03/2007","08/08/2007","0.71","-3587.5","-3587.5","USD","-3587.5","USD"
  // test for new format
  newFormat := false;
  for i := 0 to ImpStrList.Count - 1 do begin
    line := ImpStrList[i];
    line := trim(line);
    if (pos('Symbol/Description', line) > 0) then begin
      newFormat := true;
      break;
    end;
  end;
  for i := 0 to ImpStrList.Count - 1 do begin
    contracts := false;
    expire := false;
    optFormat := false;
    inc(R);
    if R < 1 then
      R := 1;
    line := ImpStrList[i];
    line := trim(line);
    if (pos('Execution Time', line) > 0) then
      timeOfDay := true;
    // delete all quotes
    while pos('"', line) > 0 do begin
      delete(line, pos('"', line), 1);
    end;
    // delete acct
    delete(line, 1, pos(sep, line));
    line := trim(line);
    // Long/Short
    ls := 'L';
    // Buy/Sell
    oc := uppercase(copy(line, 1, pos(sep, line) - 1));
    // replace double-spaces with single-space
    while pos('  ', oc) > 0 do
      delete(oc, pos('  ', oc), 1);
    // --- process OC/LS ----
    if (oc = 'OE') or (oc = 'OX') or (oc = 'OA') then begin
      oc := 'C';
      expire := true;
    end
    else if (oc = 'BUY CXL') or ((pos('BUY', oc) = 1) and (pos('CANCEL', oc) > 0)) then begin
      oc := 'X';
      cancels := true;
    end
    else if (oc = 'SELL CXL') or ((pos('SELL', oc) = 1) and (pos('CANCEL', oc) > 0)) then begin
      oc := 'X';
      ls := 'S';
      cancels := true;
    end
    else if (oc = 'COVER BUY') or (oc = 'BUY TO CLOSE') then begin
      oc := 'C';
      ls := 'S';
    end
    else if (oc = 'BUY') or (oc = 'BUY TO OPEN') then begin
      oc := 'O';
    end
    else if (oc = 'SHORT SELL') or (oc = 'SELL TO OPEN') then begin
      oc := 'O';
      ls := 'S';
      line := trim(line);
    end
    else if (oc = 'SELL') or (oc = 'SELL TO CLOSE') then begin
      oc := 'C';
    end
    else begin
      dec(R);
      Continue;
    end;
    delete(line, 1, pos(sep, line));
    line := trim(line);
    // Shares
    if newFormat = false then begin
      ShStr := copy(line, 1, pos(sep, line) - 1);
      ShStr := DelParenthesis(ShStr);
      ShStr := delCommas(ShStr);
      if ShStr = '0' then begin
        dec(R);
        Continue;
      end;
      if expire then begin
        if (pos('-', ShStr) = 1) then
          ls := 'L'
        else
          ls := 'S';
      end;
      delete(line, 1, pos(sep, line));
      line := trim(line);
    end;
    // ticker
    tick := copy(line, 1, pos(sep, line) - 1);
    tick := trim(tick);
    if (pos('CALL', tick) = 1) or (pos('PUT', tick) = 1) then begin
      contracts := true;
    end
    else if (pos(' C', tick) > 0) and (pos(' C', tick) = length(tick) - 1) then begin
      tick := tick + 'ALL';
      contracts := true;
    end
    else if (pos(' P', tick) > 0) and (pos(' P', tick) = length(tick) - 1) then begin
      tick := tick + 'UT';
      contracts := true;
    end;
    if contracts then begin
      p := pos(' 1/2', tick);
      if p > 0 then begin
        delete(tick, p, 4);
        insert('.5', tick, p);
      end;
      // sample option descr: "BAC    AUG 03 2012     7.000 P"
      // test for multiple spaces
      if (pos('  ', tick) > 0) then
        optFormat := true;
      // delete multiple spaces
      if optFormat then begin
        while (pos('  ', tick)> 0) do
          delete(tick, pos('  ', tick), 1);
        // reformat option ticker
        callPut := parseLast(tick, ' ');
        strike := parseLast(tick, ' ');
        strike := delTrailingZeros(strike);
        exYr := parseLast(tick, ' ');
        if length(exYr)> 2 then
          exYr := rightStr(exYr, 2);
        exDa := parseLast(tick, ' ');
        exMo := parseLast(tick, ' ');
        tick := trim(tick)+ ' ' + exDa + exMo + exYr + ' ' + strike + ' ' + callPut;
      end;
    end;
    // date
    delete(line, 1, pos(sep, line));
    line := trim(line);
    ImpDate := copy(line, 1, pos(sep, line) - 1);
    if (pos('/', ImpDate) <> 2) and (pos('/', ImpDate) <> 3) then begin
      dec(R);
      Continue;
    end;
    ImpDate := LongDateStr(ImpDate);
    delete(line, 1, pos(sep, line));
    line := trim(line);
    // time of day - Goldman Sachs
    if timeOfDay then begin
      TimeStr := copy(line, 1, pos(sep, line) - 1);
      if pos('n/a', TimeStr) > 0 then
        TimeStr := '00:00:00';
      if (pos('PM', TimeStr) > 0) then
        myPM := true
      else
        myPM := false;
      delete(TimeStr, pos('PM', TimeStr), 2);
      delete(TimeStr, pos('AM', TimeStr), 2);
      TimeStr := trim(TimeStr);
      TimeStr := formatTime(TimeStr);
      if myPM then begin
        try
          myHour := copy(TimeStr, 1, 2);
          if (myHour <> '12') then
            myHour := IntToStr(strToInt(myHour) + 12);
          delete(TimeStr, 1, 2);
          TimeStr := myHour + TimeStr;
        except
        end;
      end;
      delete(line, 1, pos(sep, line));
      line := trim(line);
    end
    else
      TimeStr := '';
    TimeStr := formatTime(TimeStr);
    // delete settle date
    delete(line, 1, pos(sep, line));
    line := trim(line);
    if newFormat then begin
      // delete process date
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // shares
      ShStr := copy(line, 1, pos(sep, line) - 1);
      ShStr := DelParenthesis(ShStr);
      ShStr := delCommas(ShStr);
      if ShStr = '0' then begin
        dec(R);
        Continue;
      end;
      if expire then begin
        if (pos('-', ShStr) = 1) then
          ls := 'L'
        else
          ls := 'S';
      end;
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // delete blotter
      delete(line, 1, pos(sep, line));
      line := trim(line);
    end;
    // price
    PrStr := copy(line, 1, pos(sep, line) - 1);
    PrStr := DelParenthesis(PrStr);
    PrStr := delCommas(PrStr);
    delete(line, 1, pos(sep, line));
    line := trim(line);
    if newFormat then begin
      delete(line, 1, pos(sep, line));
      CommStr := copy(line, 1, pos(sep, line) - 1);
      Commis := StrToFloat(CommStr);
      delete(line, 1, pos(sep, line));
      delete(line, 1, pos(sep, line));
      CommStr := copy(line, 1, pos(sep, line) - 1);
      Commis := Commis + StrToFloat(CommStr);
      delete(line, 1, pos(sep, line));
      CommStr := copy(line, 1, pos(sep, line) - 1);
      Commis := Commis + StrToFloat(CommStr);
      delete(line, 1, pos(sep, line));
      delete(line, 1, pos(sep, line));
      // amount
      AmtStr := copy(line, 1, pos(sep, line) - 1);
      CommStr := floattostr(Commis);
      feeStr := '';
      fee2Str := '';
    end
    else begin // old format
      // amount
      AmtStr := copy(line, 1, pos(sep, line) - 1);
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // comm
      CommStr := copy(line, 1, pos(sep, line) - 1);
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // delete next 2 fields
      delete(line, 1, pos(sep, line));
      line := trim(line);
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // settle fees
      feeStr := copy(line, 1, pos(sep, line) - 1);
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // regulatory fees
      fee2Str := copy(line, 1, pos(sep, line) - 1);
      delete(line, 1, pos(sep, line));
      line := trim(line);
    end;
    // --------------------------------
    try
      Price := StrToFloat(PrStr, Settings.InternalFmt);
      if Price < 0 then
        Price := -Price;
      Shares := StrToFloat(ShStr, Settings.InternalFmt);
      if Shares < 0 then
        Shares := -Shares;
      if contracts then begin
        mult := 100;
        prfStr := 'OPT-100';
        if (pos(' JAN ', tick) > 0) then
          delete(tick, pos(' JAN ', tick) + 4, 1)
        else if (pos(' FEB ', tick) > 0) then
          delete(tick, pos(' FEB ', tick) + 4, 1)
        else if (pos(' MAR ', tick) > 0) then
          delete(tick, pos(' MAR ', tick) + 4, 1)
        else if (pos(' APR ', tick) > 0) then
          delete(tick, pos(' APR ', tick) + 4, 1)
        else if (pos(' MAY ', tick) > 0) then
          delete(tick, pos(' MAY ', tick) + 4, 1)
        else if (pos(' JUN ', tick) > 0) then
          delete(tick, pos(' JUN ', tick) + 4, 1)
        else if (pos(' JUL ', tick) > 0) then
          delete(tick, pos(' JUL ', tick) + 4, 1)
        else if (pos(' AUG ', tick) > 0) then
          delete(tick, pos(' AUG ', tick) + 4, 1)
        else if (pos(' SEP ', tick) > 0) then
          delete(tick, pos(' SEP ', tick) + 4, 1)
        else if (pos(' OCT ', tick) > 0) then
          delete(tick, pos(' OCT ', tick) + 4, 1)
        else if (pos(' NOV ', tick) > 0) then
          delete(tick, pos(' NOV ', tick) + 4, 1)
        else if (pos(' DEC ', tick) > 0) then
          delete(tick, pos(' DEC ', tick) + 4, 1);
      end
      else begin
        mult := 1;
        prfStr := 'STK-1';
      end;
      if newFormat then
        Amt := StrToFloat(AmtStr, Settings.InternalFmt)
      else
        Amt := StrToFloat(AmtStr, Settings.InternalFmt) + StrToFloat(CommStr, Settings.InternalFmt)
          + StrToFloat(feeStr, Settings.InternalFmt) + StrToFloat(fee2Str, Settings.InternalFmt);
      if Amt < 0 then
        Amt := -Amt;
      if expire then
        Amt := 0;
      if Commis < 0 then
        Commis := -Commis;
      { old code calculated Commis from Amt - (Shares * Price * Mult),
        but new code assumes Commis is correct, computes Price. }
      if ((oc = 'O') and (ls = 'L')) //
        or ((oc = 'C') and (ls = 'S')) //
        or ((oc = 'X') and (ls = 'L')) then
        Price := (Amt - Commis) / Shares / mult
        // amount is neg
      else if ((oc = 'C') and (ls = 'L')) //
        or ((oc = 'O') and (ls = 'S')) then
        Price := (Amt + Commis) / Shares / mult; // amount is pos
      Price := -rndto5(Price);
      if Price < 0 then
        Price := -Price;
      if (oc = 'X') and (ls = 'L') and (Commis < 0) then
        Commis := -Commis;
      // Amt := 0;
      ImpTrades[R].it := TradeLogFile.Count + R;
      ImpTrades[R].tr := 0;
      ImpTrades[R].DT := ImpDate;
      ImpTrades[R].tm := TimeStr;
      ImpTrades[R].oc := oc;
      ImpTrades[R].ls := ls;
      ImpTrades[R].tk := tick;
      ImpTrades[R].sh := Shares;
      ImpTrades[R].pr := Price;
      ImpTrades[R].prf := prfStr;
      ImpTrades[R].cm := Commis;
      ImpTrades[R].am := Amt;
    except
      DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
      dec(R);
      Continue;
    end;
  end;
  if cancels then
    matchCancels(R);
  ImpStrList.Destroy;
  result := R;
end; // GolmanSachsOLD


function ReadGoldmanSachs(): integer;
var
  i, j, R : integer;
  Shares, mult, Commis : double;
  line, sep, ImpDate, ShStr, PrStr, prfStr, AmtStr, descr, opTick, underlying, exDay, exMon, exYr,
    strike, callPut : string;
  contracts, oldFormat, tradesFormat, allTransFormat, cancels, forex : boolean;
  oc, ls : string;
begin
  try
    R := 0;
    DataConvErrRec := '';
    DataConvErrStr := '';
    Commis := 0;
    R := 0;
    cancels := false;
    ImpStrList := TStringList.Create;
    ImpTrades := nil;
    setLength(ImpTrades, R + 1);
    GetImpDateLast;
    // ----------------------
    GetImpStrListFromFile('Goldman Sachs', 'csv|xls', '');
    // ----------------------
    if ImpStrList.Count < 2 then begin
      ImpStrList.Destroy;
      result := 0;
      exit;
    end;
    sep := ',';
    // ----------------------
    for i := 0 to ImpStrList.Count - 1 do
      if (pos(TAB, ImpStrList[i]) > 0) then begin
        sep := TAB;
        break;
      end;
    // new report format 2011-11-28:
    // Trades report:
    // Transaction Date	Settlement Date	Transaction Type	Qty	Symbol	Description	Trade Price	Settlement Amount	Settlement Ccy
    // All Transactions report:
    // Transaction Type	Transaction Date	Qty	Symbol	Description	Activity Class	Trade Price	Settlement Amount	Settlement Ccy
    // test for report format
    oldFormat := false;
    tradesFormat := false;
    allTransFormat := false;
    for i := 0 to ImpStrList.Count - 1 do begin
      line := ImpStrList[i];
      line := trim(line);
      if (pos('Transaction Date', line) = 1) then begin
        tradesFormat := true;
        break;
      end
      else if (pos('Transaction Type', line) = 1) then begin
        allTransFormat := true;
        break;
      end
      else if (pos('Account Number', line) > 0) then begin
        oldFormat := true;
        break;
      end;
    end;
    if allTransFormat then begin
      sm('This Excel file is the wrong report format!' + cr + cr +
          'Please go back to the Goldman Sachs Private Wealth Management web site' + cr +
          'and select "Trades" in the "Choose An Existing View" drop-down box,' + cr +
          're-download the Excel file, and try the import again!');
      R := 0;
      exit;
    end;
    if oldFormat then begin
      result := ReadGoldmanSachsOld(ImpStrList);
      exit;
    end;
    // ----------------------
    for i := 0 to ImpStrList.Count - 1 do begin
      contracts := false;
      // expire:= false;
      forex := false;
      inc(R);
      if R < 1 then
        R := 1;
      line := ImpStrList[i];
      line := trim(line);
      // delete all quotes
      while pos('"', line) > 0 do begin
        delete(line, pos('"', line), 1);
      end;
      // date
      ImpDate := copy(line, 1, pos(sep, line) - 1);
      ImpDate := dateDDMMMYY(ImpDate);
      if (ImpDate = 'invalid') then begin
        dec(R);
        Continue;
      end;
      delete(line, 1, pos(sep, line));
      trim(line);
      if tradesFormat then begin
        delete(line, 1, pos(sep, line)); // del settlement date
        line := trim(line);
        // Long/Short
        ls := 'L';
        // Transaction Type - Buy/Sell
        oc := uppercase(copy(line, 1, pos(sep, line) - 1));
        if (oc = 'BUY TO COVER') or (oc = 'PURCHASE TO COVER') or (oc = 'CLOSE BUY') then begin
          oc := 'C';
          ls := 'S';
        end
        else if (oc = 'BUY') or (oc = 'OPEN BUY') then begin
          oc := 'O';
        end
        else if (oc = 'SHORT SELL') or (oc = 'OPEN SELL') then begin
          oc := 'O';
          ls := 'S';
          line := trim(line);
        end
        else if (oc = 'SELL') or (oc = 'SALE') or (oc = 'CLOSE SELL') then begin
          oc := 'C';
        end
        else begin
          dec(R);
          Continue;
        end;
        delete(line, 1, pos(sep, line));
        line := trim(line);
      end;
      // shares
      ShStr := copy(line, 1, pos(sep, line) - 1);
      ShStr := delCommas(ShStr);
      delete(line, 1, pos(sep, line));
      trim(line);
      // ticker
      tick := copy(line, 1, pos(sep, line) - 1);
      trim(tick);
      if pos('*', tick) = 1 then
        delete(tick, 1, 1);
      delete(line, 1, pos(sep, line));
      trim(line);
      // descr
      descr := uppercase(copy(line, 1, pos(sep, line) - 1));
      if tick = '' then
        tick := descr;
      if pos('FX', descr) = 1 then
        forex := true;
      if (pos('CALL/', descr) > 0) or (pos('PUT/', descr) > 0) then begin
        // ie: CALL/MOS1               @ 70 EXP 01/22/2011
        // ie: CALL/GS(GPYLQ)          @ 185 EXP 12/19/2009
        contracts := true;
        opTick := tick;
        callPut := copy(descr, 1, pos('/', descr) - 1);
        delete(descr, 1, pos('/', descr));
        underlying := copy(descr, 1, pos('@', descr) - 1);
        if (pos('(', underlying) > 0) then
          delete(underlying, 1, pos('(', underlying));
        underlying := trim(underlying);
        if rightStr(underlying, 1) = '1' then
          delete(underlying, length(underlying), 1);
        delete(descr, 1, pos('@', descr));
        trim(descr);
        strike := copy(descr, 1, pos('EXP ', descr) - 1);
        // 2021-10-08 MB - 'EXP <date>', NOT 'EXPRESS'
        trim(strike);
        exYr := parseLast(descr, '/');
        if length(exYr) = 4 then
          exYr := rightStr(exYr, 2);
        exDay := parseLast(descr, '/');
        if length(exDay) = 1 then
          exDay := '0' + exDay;
        exMon := parseLast(descr, ' ');
        exMon := getExpMo(exMon);
        tick := underlying + ' ' + exDay + exMon + exYr + ' ' + strike + ' ' + callPut;
      end;
      delete(line, 1, pos(sep, line));
      trim(line);
      // price
      PrStr := copy(line, 1, pos(sep, line) - 1);
      PrStr := DelParenthesis(PrStr);
      PrStr := delCommas(PrStr);
      delete(line, 1, pos(sep, line));
      trim(line);
      // amount
      AmtStr := copy(line, 1, pos(sep, line) - 1);
      AmtStr := DelParenthesis(AmtStr);
      AmtStr := delCommas(AmtStr);
      delete(line, 1, pos(sep, line));
      trim(line);
      // --------------------
      try
        Price := StrToFloat(PrStr, Settings.InternalFmt);
        if Price < 0 then
          Price := -Price;
        Shares := StrToFloat(ShStr, Settings.InternalFmt);
        if Shares < 0 then
          Shares := -Shares;
        Amt := StrToFloat(AmtStr, Settings.InternalFmt);
        if Amt < 0 then
          Amt := -Amt;
        // if expire then Amt:=0;
        if contracts then begin
          mult := 100;
          prfStr := 'OPT-100';
        end
        else if forex then begin
          mult := Amt / (Shares * Price);
          prfStr := 'CUR-' + floattostr(mult);
        end
        else begin
          mult := 1;
          prfStr := 'STK-1';
        end;
        Commis := 0;
        if ((oc = 'O') and (ls = 'L')) or ((oc = 'C') and (ls = 'S')) or ((oc = 'X') and (ls = 'L'))
        then
          Commis := Amt - (Shares * Price * mult)
        else if ((oc = 'C') and (ls = 'L')) or ((oc = 'O') and (ls = 'S')) then
          Commis := (Shares * Price * mult) - Amt;
        if (oc = 'X') and (ls = 'L') and (Commis < 0) then
          Commis := -Commis;
        Amt := 0;
        ImpTrades[R].it := TradeLogFile.Count + R;
        ImpTrades[R].tr := 0;
        ImpTrades[R].DT := ImpDate;
        ImpTrades[R].tm := '';
        ImpTrades[R].oc := oc;
        ImpTrades[R].ls := ls;
        ImpTrades[R].tk := tick;
        ImpTrades[R].opTk := opTick;
        ImpTrades[R].sh := Shares;
        ImpTrades[R].pr := Price;
        ImpTrades[R].prf := prfStr;
        ImpTrades[R].cm := Commis;
        ImpTrades[R].am := Amt;
      except
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        dec(R);
        Continue;
      end;
    end;
    // ----------------------
    if cancels then begin
      for i := 1 to R do begin
        StatBar('Matching Cancelled Trades: ' + IntToStr(i));
        for j := i downto 1 do begin
          if (ImpTrades[i].oc = 'X') and (ImpTrades[i].tk = ImpTrades[j].tk) and
            (format('%1.5f', [ImpTrades[i].sh], Settings.UserFmt) = format('%1.5f',
              [ImpTrades[j].sh], Settings.UserFmt)) and
            (format('%1.5f', [ImpTrades[i].pr], Settings.UserFmt) = format('%1.5f',
              [ImpTrades[j].pr], Settings.UserFmt)) and
            (format('%1.2f', [ImpTrades[i].cm], Settings.UserFmt) = format('%1.2f',
              [ImpTrades[j].cm], Settings.UserFmt)) and (ImpTrades[i].prf = ImpTrades[j].prf) and
            (ImpTrades[j].oc <> '') and (i <> j) then begin
            glNumCancelledTrades := glNumCancelledTrades + 2;
            ImpTrades[i].oc := '';
            ImpTrades[i].ls := '';
            ImpTrades[i].tm := '';
            ImpTrades[j].oc := '';
            ImpTrades[j].ls := '';
            ImpTrades[j].tm := '';
            break;
          end;
        end;
      end;
    end;
    ImpStrList.Destroy;
    result := R;
  finally
    // ReadGoldmanSachs
  end;
end;

         // ---------------------------
         // Harris
         // ---------------------------

function ReadHarris(): integer;
var
  i, j, p, R : integer;
  ImpDate, PrStr, prfStr, AmtStr, ShStr, line, sep, junk : string;
  Price, mult, Amount, Commis : double;
  ImpNextDateOn, expired, contracts, TrCancelled, cancels : boolean;
  oc, ls : string;
begin
  try
    DataConvErrRec := '';
    DataConvErrStr := '';
    Commis := 0;
    R := 0;
    cancels := false;
    ImpNextDateOn := false;
    ImpTrades := nil;
    setLength(ImpTrades, R + 1);
    GetImpDateLast;
    ImpStrList := TStringList.Create;
    // --------------------------------
    GetImpStrListFromFile('Harris', 'txt', '');
    // --------------------------------
    if ImpStrList.Count < 1 then begin
      ImpStrList.Destroy;
      result := 0;
      exit;
    end;
    for i := 0 to ImpStrList.Count - 1 do begin
      expired := false;
      contracts := false;
      TrCancelled := false;
      inc(R);
      if R < 1 then
        R := 1;
      line := ImpStrList[i];
      line := trim(line);
      sep := TAB;
      // change all ", and ," to tabs
      while pos('",', line) > 0 do begin
        p := pos('",', line);
        delete(line, p, 2);
        insert(TAB, line, p);
      end;
      // change all ," and ," to tabs
      while pos(',"', line) > 0 do begin
        p := pos(',"', line);
        delete(line, p, 2);
        insert(TAB, line, p);
      end;
      // delete all quotes
      while pos('"', line) > 0 do
        delete(line, pos('"', line), 1);
      // change all double-tabs to single-tabs
      while pos(TAB + TAB, line) > 0 do
        delete(line, pos(TAB + TAB, line), 1);
      line := trim(line);
      if (pos('/', line) = 0) or (pos('/', line) > 3) then begin
        if (i = ImpStrList.Count - 1) and (R = 1) then begin
          DataConvErrRec := 'No records imported';
          sm('No trades to import');
          result := 0;
          exit;
        end;
        dec(R);
        Continue;
      end; // date
      ImpDate := copy(line, 1, pos(sep, line));
      ImpDate := trim(ImpDate);
      ImpDate := LongDateStr(ImpDate);
      if not ValidTradeDate(ImpDate, ImpDateLast, ImpNextDateOn) then begin
        dec(R);
        Continue;
      end;
      // cancels
      // delete cancels but not correct trades 3-24-04
      // if pos('Cancel',line)>0 then
      // TrCancelled:= true;
      // long/short
      if pos('Short', line) > 0 then
        ls := 'S'
      else
        ls := 'L';
      // delete Short/Margin and Security
      junk := parseLast(line, sep);
      if (pos('Cash', junk) = 0) and (pos('Margin', junk) = 0) and (pos('Short', junk) = 0) then
        junk := parseLast(line, sep);
      line := trim(line);
      // amount
      AmtStr := parseLast(line, sep);
      AmtStr := delCommas(AmtStr);
      delete(AmtStr, pos('-', AmtStr), 1); // delete minus sign
      line := trim(line);
      // price
      PrStr := parseLast(line, sep);
      line := trim(line);
      // shares
      ShStr := parseLast(line, sep);
      if pos('contracts', line) > 0 then
        contracts := true;
      line := trim(line);
      // open/close
      if pos('OPTION ASSIGNED', line) > 0 then begin
        delete(line, 1, pos('ASSIGNED', line) + 8);
        line := trim(line);
        expired := true;
        oc := 'C';
      end
      else if pos('OPTION EXPIRED', line) > 0 then begin
        delete(line, 1, pos('EXPIRED', line) + 7);
        line := trim(line);
        expired := true;
        oc := 'C';
      end
      else begin
        oc := parseLast(line, sep);
        if pos('Sell', oc) > 0 then begin
          if ls = 'L' then
            oc := 'C'
          else
            oc := 'O';
        end
        else if pos('Buy', oc) > 0 then begin
          if ls = 'L' then
            oc := 'O'
          else
            oc := 'C';
        end
        else begin
          dec(R);
          Continue;
        end;
      end;
      line := trim(line);
      if pos('Cancel', line) > 0 then begin
        cancels := true;
        oc := 'X';
      end;
      // ticker
      if expired then begin
        tick := trim(line);
      end
      else
        tick := parseLast(line, sep);
      // delete dash from option symbol so we can price it
      delete(tick, pos('-', tick), 1);
      // --------------------
      try
        Amount := CurrToFloat(AmtStr);
        if Amount < 0 then
          Amount := -Amount;
        Price := StrToFloat(PrStr, Settings.InternalFmt);
        if Price < 0 then
          Price := -Price;
        Shares := trunc(StrToFloat(ShStr, Settings.InternalFmt));
        if contracts or expired then begin
          prfStr := 'OPT-100';
          mult := 100;
        end
        else begin
          prfStr := 'STK-1';
          mult := 1;
        end;
        if ((oc = 'O') and (ls = 'L')) or ((oc = 'C') and (ls = 'S')) then
          Commis := Amount - (Shares * Price * mult)
        else if ((oc = 'C') and (ls = 'L')) or ((oc = 'O') and (ls = 'S')) then
          Commis := -Amount + (Shares * Price * mult);
        ImpTrades[R].it := TradeLogFile.Count + R;
        ImpTrades[R].DT := ImpDate;
        ImpTrades[R].tm := '';
        ImpTrades[R].oc := oc;
        ImpTrades[R].ls := ls;
        ImpTrades[R].tk := tick;
        ImpTrades[R].sh := Shares;
        ImpTrades[R].pr := Price;
        ImpTrades[R].prf := prfStr;
        ImpTrades[R].cm := Commis;
        ImpTrades[R].am := Amount;
        if TrCancelled then begin
          // delete cancels
          dec(R);
          Continue;
        end;
      except
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        dec(R);
        Continue;
      end;
    end;
    if R > 1 then
      if xStrToDate(ImpTrades[1].DT) > xStrToDate(ImpTrades[R].DT) then
        ReverseImpTradesDate(R);
    if cancels then begin
      for i := 1 to R do begin
        StatBar('Matching Cancelled Trades: ' + IntToStr(i));
        if (ImpTrades[i].oc = 'X') then
          for j := R downto 1 do begin
            if (ImpTrades[i].tk = ImpTrades[j].tk) and
              (format('%1.5f', [ImpTrades[i].sh], Settings.UserFmt) = format('%1.5f',
                [ImpTrades[j].sh], Settings.UserFmt)) and
              (format('%1.5f', [ImpTrades[i].pr], Settings.UserFmt) = format('%1.5f',
                [ImpTrades[j].pr], Settings.UserFmt)) and (ImpTrades[i].prf = ImpTrades[j].prf) and
              (ImpTrades[j].oc <> '') and (i <> j) then begin
              glNumCancelledTrades := glNumCancelledTrades + 2;
              ImpTrades[i].oc := '';
              ImpTrades[i].ls := '';
              ImpTrades[i].tm := '';
              ImpTrades[j].oc := '';
              ImpTrades[j].ls := '';
              ImpTrades[j].tm := '';
              break;
            end;
          end;
      end;
    end;
    ImpStrList.Destroy;
    result := R;
  finally
    // ReadHarris
  end;
end;


         // -----------------
         // Hilltop
         // -----------------

function ReadHilltopCSV(): integer;
var
  i, j, k, n, start, eend, R, Q : integer;
  iDt, iTm, iTyp, iOC, iLS, iTk, iDesc, iShr, iPr, iAmt : integer; // import field numbers
  junk, sep, ImpDate, ImpTime, oc, ls, line, typeStr, sTk : string;
  CmStr, feeStr, PrStr, AmtStr, ShStr, errLogTxt : string;
  optOC, opExpDt, opFmt, opYr, opMon, opDay, opStrike, opCP, optTick, optDesc, opStrik2 : string;
  Amount, Commis, Fees, Shares, mult : double;
  contracts, Adj, optExpEx, ImpNextDateOn, bonds, newColFormat, miniOptions, futures, //
    bFoundHeader, cancels, assigns : boolean;
  fieldLst : TStrings;
  // ---- CSV format as of JUNE 2020 ----------------------
  // NOTE: No quotes around text - just comma-separated
  // Entry Date	      2019-05-22     YYYY-MM-DD
  // DT	Trade Date	      2019-05-22     YYYY-MM-DD
  // Trade Number
  // OC	Transaction	      BOT           some blank
  // CUSIP	            67424L100
  // TK	Symbol	          TAF or .BYND190802P00185000
  // DS	Description       EX: blank or TAF  SO -114 BYND 190802P185 @ $12.00
  // TY	Security Type	    Equity or Options
  // SH	Quantity	        100 or -114           +/- = buy/sell
  // Base Currency	    USD
  // PR	Price ($)	        1.475 or 12
  // Away Commissions ($)	all rows blank
  // Commissions ($)	  0 or -57
  // Fees ($)	        0 or -2.83
  // AM	Net Amount ($)	  -147.5 or 136740.2        +/- = buy/sell
  // Settlement Date	  2019-05-24     YYYY-MM-DD
  // Account
  // NOTE: we will trust sign of quantity, not amount
  // ------------------------------------------------------
  procedure SetFieldNumbers();
  var
    j : integer;
  begin
    // find/map Hilltop/Investrade CSV fields
    k := 0;
    iDt := 0;
    iTk := 0;
    iOC := 0;
    iDesc := 0;
    iTyp := 0;
    iShr := 0;
    iPr := 0;
    iAmt := 0;
    // ------------
    for j := 0 to (fieldLst.Count - 1) do begin
      if fieldLst[j] = 'ENTRY DATE' then begin // Date/Time
        iDt := j;
        k := k or 1;
      end
      else if (fieldLst[j] = 'SYMBOL') // CSV
        or (fieldLst[j] = 'SECURITY') // XLSX
      then begin // Ticker
        iTk := j;
        k := k or 2;
      end
      else if fieldLst[j] = 'TRANSACTION' then begin // BOT, SOLD,
        iOC := j;
        k := k or 4;
      end
      else if fieldLst[j] = 'DESCRIPTION' then begin // option ticker
        iDesc := j;
        k := k or 8;
      end
      else if fieldLst[j] = 'SECURITY TYPE' then begin // Equity/Options
        iTyp := j;
        k := k or 16;
      end
      else if (fieldLst[j] = 'QUANTITY') then begin // Shares/Contracts
        iShr := j;
        k := k or 32;
      end
      else if trim(fieldLst[j]) = 'PRICE ($)' then begin
        iPr := j;
        k := k or 64;
      end
      else if fieldLst[j] = 'NET AMOUNT ($)' then begin // Amount
        iAmt := j;
        k := k or 128;
      end; // note: 'RATE' field is conversion factor
    end;
  end;
  // ----------------------------------
  function FormatExpDate(sDate : string): string;
  var
    sDelim, s1, s2, s3, sWork : string;
    i, j, y, m, d, v1, v2, v3 : integer;
  begin
    result := '';
    // look for delimiter first (support '/', '-', or '.')
    if pos('/', sDate)> 1 then
      sDelim := '/'
    else if pos('-', sDate)> 1 then
      sDelim := '-'
    else if pos('.', sDate)> 1 then
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
    s1 := parsefirst(s2, sDelim);
    if pos(sDelim, s2) < 2 then
      exit;
    s3 := parseLast(s2, sDelim);
    // --------------
    if opFmt = 'dmy' then begin
      result := s1 + getExpMo(s2) + s3;
    end
    else if opFmt = 'mdy' then begin
      result := s2 + getExpMo(s1) + s3;
    end
    else if opFmt = 'ymd' then begin
      result := s3 + getExpMo(s2) + s1;
    end;
  end;
  // ----------------------------------
  // for i = 1 to count
  // Parse option ticker into parts
  // reformat option ticker
  // loop
  // ----------------------------------
  function BuildOptTicker(sTk : string): string;
  var
    j, n : integer;
  begin
    result := sTk; // initial value
    // --------------------
    if opCP = 'C' then
      opCP := 'CALL'
    else
      opCP := 'PUT';
    // --------------------
    if pos('.', opStrike) > 1 then
      opStrik2 := parseLast(opStrike, '.')
    else begin
      j := length(opStrike)- 2; // AAPL200117P00310000 <-- strike price variable size
      if j > 4 then begin // $$$$.000 <-- 3 decimals assumed if no dot
        opStrik2 := copy(opStrike, j, 3);
        opStrike := copy(opStrike, 1, j - 1);
      end;
    end;
    // --------------------
    try
      n := strToInt(opStrike); // removes leading zeros
      opStrike := IntToStr(n) + '.' + opStrik2;
    except
      on e : Exception do begin
        sm('ERROR in OPT ticker: ' + cr //
            + tick + cr //
            + e.Message);
        exit;
      end;
    end;
    opStrike := delTrailingZeros(opStrike); // 2017-10-09 MB Remove trailing zeros for matching
    result := optTick + ' ' + FormatExpDate(opExpDt) + ' ' + opStrike + ' ' + opCP;
    exit;
  end;
  // ----------------------------------
  // PARSE OPTION TICKER
  // TK = .BYND190802P00185000
  // symbYYMMDD^strike$$
  // or   .TSLA190125P282.50
  // break it into the major components:
  // opExpDt, opStrike, opCP, optTick
  // ----------------------------------
  function ParseOptTick(sTk : string): boolean;
  var
    j, n : integer;
  begin
    n := length(sTk);
    j := n;
    if sTk[1] = '.' then
      sTk := copy(sTk, 2);
    // --- find C/P, StrikePrice ---
    while (j > 6) do begin
      if (sTk[j] = 'C') or (sTk[j] = 'P') then
        break;
      dec(j);
    end;
    if j < 6 then
      exit(false);
    opStrike := copy(sTk, j + 1);
    opCP := sTk[j];
    // --- find expDate ---
    opExpDt := '';
    n := j;
    while (j > 1) do begin
      dec(j);
      if pos(sTk[j], '1234567890') < 1 then
        break;
    end;
    if j < 1 then
      exit(false);
    opExpDt := copy(sTk, j + 1, n - j - 1); // up to C/P, format unknown
    optTick := copy(sTk, 1, j);
    // --------------------
    exit(true);
  end;
  // ----------------------------------
  procedure FindExpDateFmt(iStart : integer);
  var
    j : integer;
  begin
    opFmt := '?';
    if iStart >= ImpStrList.Count then
      exit;
    for j := iStart to (ImpStrList.Count - 1) do begin
      line := ImpStrList[j];
      line := uppercase(line);
      if pos('"""', line) = 1 then
        line := copy(line, 3);
      fieldLst := ParseCSV(line);
      tick := trim(fieldLst[iTk]);
      if tick = '' then
        Continue;
      optDesc := trim(fieldLst[iDesc]);
      typeStr := trim(fieldLst[iTyp]);
      if (pos('OPT', typeStr) = 1) then begin
        ParseOptTick(tick);
        opFmt := GetDateStrFmt(opExpDt);
        if opFmt <> '?' then
          break;
      end
      else
        Continue;
      if opFmt <> '?' then
        exit;
    end; // for j loop
    if opFmt = '?' then
      sm('unable to determine format of expiration dates.');
  end;

// --------------------------------------------
begin // ReadHilltopCSV
  // 1. find headers
  // 2. determine date format(s)
  // 3. process data import
  bFoundHeader := false; // haven't found the header yet
  // in case these are missing, flag to skip them.
  cancels := false;
  contracts := false;
  R := 0;
  try
    DataConvErrRec := '';
    DataConvErrStr := '';
    Commis := 0;
    ImpNextDateOn := false;
    // --------------------------------
    if ImpStrList.Count < 1 then begin
      ImpStrList.Destroy;
      result := 0;
      exit;
    end;
    iLS := 0; // no Long/Short indicator?
    fieldLst := TStrings.Create;
    // --------------------------------
    i := -1;
    while i < (ImpStrList.Count - 1) do begin
      inc(i); // make it work like a for/next
      contracts := false; // reset flags
      // ------------------------------
      line := ImpStrList[i];
      line := uppercase(line); // search line for UPPERCASE tokens...
      // ------------------------------
      if pos('"""', line) = 1 then
        line := copy(line, 3);
      // parse all columns into string list
      fieldLst := ParseCSV(line);
      if not bFoundHeader then begin
        if (pos('SECURITY', line) > 0) //
          and (pos('QUANTITY', line) > 0) //
          and (pos('DATE', line) > 0) then begin
          SetFieldNumbers;
          if SuperUser and (k <> 255) then
            sm('there appear to be fields missing.');
          FindExpDateFmt(i + 1); // get expDate format one time
          bFoundHeader := true; // don't do this anymore
          R := 0; // start now
        end;
        Continue; // don't process anything until we recognize the header
      end;
      // ------------------------------
      if pos('ERROR', line) > 0 then begin
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        sm('Hilltop reported an error.' + cr //
            + 'Please reduce the date range and try again.');
        result := 0;
        exit;
      end;
      // --- ticker -------------------
      tick := trim(fieldLst[iTk]);
      if tick = '' then
        Continue;
      optDesc := trim(fieldLst[iDesc]);
      // -- PRF = Type/Mult -----------
      typeStr := trim(fieldLst[iTyp]);
      if (pos('OPT', typeStr) = 1) then begin
        typeStr := 'OPT-100';
        mult := 100;
        contracts := true;
      end
      else begin
        typeStr := 'STK-1';
        mult := 1;
      end;
      // --- Date ---------------------
      ImpDate := fieldLst[iDt]; // format: YYYY-MM-DD
      if pos('-', ImpDate) = 5 then begin
        ImpDate := StringReplace(ImpDate, '-', '', [rfReplaceAll]);
        ImpDate := MMDDYYYY(ImpDate); // it comes in yyyy-mm-dd
      end;
      if pos('/', ImpDate) = 2 then
        ImpDate := '0' + ImpDate;
      if not isdate(ImpDate) then
        sm('Cannot determine the transaction date of this trade:' + cr + line);
      if not ValidTradeDate(ImpDate, ImpDateLast, ImpNextDateOn) then begin
// DataConvErrRec := DataConvErrRec + 'invalid date: ' + ImpStrList[i] + cr;
        Continue;
      end;
      if UserDateStrNotGreater(ImpDate, ImpDateLast) then begin
        if mDlg('Trades already imported for ' + ImpDate + cr //
            + cr //
            + 'Continue?', mtWarning, [mbNo, mbYes], 0) = mrNo then begin
          result := R;
          exit;
        end
        else
          ImpDateLast := '01/01/1900';
      end;
      if pos(':', ImpTime) = 2 then begin
        ImpTime := '0' + ImpTime;
      end;
      // --- # shares -----------------
      ShStr := fieldLst[iShr];
      ShStr := delCommas(ShStr);
      try
        Shares := CurrToFloat(ShStr);
      except
        Shares := 0;
      end;
      // --- OC and LS ----------------
      // PURCHASE, SALE, SALE - CANCEL, SHORT SALE, SHORT SALE BUYBACK
      junk := trim(fieldLst[iOC]);
      oc := 'E'; // default values
      ls := 'E'; // are E for ERROR
      if pos('CANCELLATION', junk) > 0 then begin
        oc := 'X';
        cancels := true;
      end
      else if (Shares < 0) then begin // shares decreasing --> SELL
        if pos('TO OPEN', junk) > 0 then begin
          oc := 'O';
          ls := 'S';
        end
        else begin
          oc := 'C';
          ls := 'L';
        end;
        Shares := -Shares; // ABS value
      end
      else begin // shares increasing --> BUY
        if pos('TO CLOSE', junk) > 0 then begin
          oc := 'C';
          ls := 'S';
        end
        else begin
          oc := 'O';
          ls := 'L';
        end;
      end;
      // ------------------------------
      inc(R); // if it gets this far, count it
      // ------------------------------
      if contracts then begin
        if ParseOptTick(tick) = false then begin
          dec(R);
          Continue;
        end
        else begin // able to parse
          tick := BuildOptTicker(tick);
          // tick := optTick + ' ' + opDay + opMon + opYr + ' ' + opStrike + ' ' + opCP;
        end;
      end;
      // --- price --------------------
      PrStr := fieldLst[iPr];
      delete(PrStr, pos('$', PrStr), 1);
      PrStr := delCommas(PrStr);
      if (xStrToFloat(PrStr) = 0) then
        PrStr := '0.00';
      // --- conversion rate
      // amount
      AmtStr := fieldLst[iAmt];
      // --- Commission ---------------
      Commis := 0;
      try
        Shares := CurrToFloat(ShStr);
        if Shares < 0 then
          Shares := -Shares; // ABS
        Price := CurrToFloat(PrStr);
        if Price < 0 then
          Price := -Price; // ABS
        Amount := ABS(CurrToFloat(AmtStr));
        // 2019-04-29 MB - add code to handle Buy/Sell separately
        if ((oc = 'O') and (ls = 'L')) or ((oc = 'C') and (ls = 'S')) then // BUY
          Commis := ABS(Amount) - ABS(Shares * Price * mult)
        else // // SELL
          Commis := ABS(Shares * Price * mult) - ABS(Amount);
        // 2019-04-29 MB - removed ABS(Commis) because rebates are allowed per Jason D.
        // ------ set import record fields ------
        ImpTrades[R].it := TradeLogFile.Count + R;
        ImpTrades[R].DT := ImpDate;
        ImpTrades[R].tm := ImpTime;
        ImpTrades[R].oc := oc;
        ImpTrades[R].ls := ls;
        ImpTrades[R].tk := tick;
        ImpTrades[R].sh := Shares;
        ImpTrades[R].pr := Price;
        ImpTrades[R].prf := typeStr;
        ImpTrades[R].cm := Commis;
        ImpTrades[R].am := Amount;
      except
        // DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        dec(R);
        Continue;
      end;
    end; // while
    // --------------------------------
    ReverseImpTradesDate(R);
    if cancels then begin
      for i := 1 to R do begin
        if (ImpTrades[i].oc = 'X') then
          for j := i + 1 downto 1 do begin
            if (ImpTrades[i].tk = ImpTrades[j].tk) //
              and (ImpTrades[i].sh = ImpTrades[j].sh) //
              and (ImpTrades[i].pr = ImpTrades[j].pr) //
              and (format('%1.2f', [ImpTrades[i].pr], Settings.UserFmt) = format('%1.2f',
                [ImpTrades[j].pr], Settings.UserFmt)) //
              and (ImpTrades[j].oc <> '') //
              and (i <> j) then begin
              glNumCancelledTrades := glNumCancelledTrades + 2;
              ImpTrades[i].oc := '';
              ImpTrades[i].ls := '';
              ImpTrades[j].oc := '';
              ImpTrades[j].ls := '';
              break;
            end;
          end;
      end;
    end;
    // --------------------------------
    for i := 1 to R do begin
      if ImpTrades[i].oc = 'X' then begin
        sm('CANCEL TRADES NOT MATCHED!' + cr + cr +
            'Cancel Trades have Open/Close marked with an "X"');
        break;
      end;
    end;
    result := R;
    ImpStrList.Destroy;
  finally
    // ReadHilltopCSV
  end;
end;


function ReadHilltop(): integer;
var
  R : integer;
begin
  try
    R := 0;
    ImpStrList := TStringList.Create;
    ImpTrades := nil;
    setLength(ImpTrades, R + 1);
    GetImpDateLast;
    // ----------------------
    if FileExists(Settings.ImportDir + '\download.csv') then
      deleteFile(Settings.ImportDir + '\download.csv');
    // ----------------------
    GetImpStrListFromFile('*', 'csv|xls?', ''); // from CSV or XLS? file
    result := ReadHilltopCSV;
    // ----------------------
    exit;
  finally
    // ReadHilltop
  end;
end;


         // ---------------------------
         // Interactive Brokers (IB)
         // ---------------------------

function ReadIBflexOLD(FileName : string): integer;
var
  i, j, R : integer;
  ImpDate, CmStr, PrStr, AmtStr, ShStr, line, optTick, sep, TimeStr, typeStr, descr, usdStr,
    multStr, foreignCurrStr, NextDate, exchange : string;
  Amount, Commis, mult, currMult : double;
  CommStr : string;
  contracts, futures, CurrencyTrades, optfutures, stocks, ImpNextDateOn : boolean;
  oc, ls : string;
begin
  ImpDate := '';
  DataConvErrRec := '';
  DataConvErrStr := '';
  ImpTrades := nil;
  R := 0;
  ImpNextDateOn := false;
  ImpStrList := TStringList.Create;
  ImpStrList.clear;
  ImpTrades := nil;
  setLength(ImpTrades, R + 1);
  GetImpDateLast;
  // ----------------------------------
  if FileName <> '' then
    GetImpStrListFromFile('', '', FileName)
  else
    try
      GetImpStrListFromClip(false);
    except
      sm('Error getting IB flex data from clipboard');
    end;
  // ----------------------------------
  sep := '|';
  if ImpStrList.Count < 1 then begin
    ImpStrList.Destroy;
    result := 0;
    exit;
  end;
  // ----------------------------------
  for i := 0 to ImpStrList.Count - 1 do begin
    inc(R);
    if R < 1 then
      R := 1;
    line := trim(ImpStrList[i]);
    stocks := false;
    futures := false;
    contracts := false;
    optfutures := false;
    CurrencyTrades := false;
    mult := 1;
    if (pos('ST|', line) = 1) then
      stocks := true
    else if (pos('FT|', line) = 1) then
      futures := true
    else if (pos('OT|', line) = 1) then
      contracts := true
    else if (pos('FOT|', line) = 1) then
      optfutures := true
    else if (pos('CT|', line) = 1) then
      CurrencyTrades := true
    else begin
      dec(R);
      Continue;
    end;
    // delete up to ticker
    delete(line, 1, pos(sep, line));
    line := trim(line);
    delete(line, 1, pos(sep, line));
    line := trim(line);
    // ticker
    if contracts or optfutures or futures then begin
      optTick := trim(copy(line, 1, pos(sep, line) - 1));
      delete(line, 1, pos(sep, line));
      line := trim(line);
      tick := trim(copy(line, 1, pos(sep, line) - 1));
      delete(line, 1, pos(sep, line));
      line := trim(line);
      if copy(tick, length(tick), 1) = 'C' then
        tick := tick + 'ALL'
      else if copy(tick, length(tick), 1) = 'P' then
        tick := tick + 'UT';
      // sm('ticker = '+tick);
    end
    else begin
      tick := trim(copy(line, 1, pos(sep, line) - 1));
      delete(line, 1, pos(sep, line));
      line := trim(line);
      descr := trim(copy(line, 1, pos(sep, line) - 1));
      delete(line, 1, pos(sep, line));
      line := trim(line);
    end;
    // exchange
    if futures or optfutures or stocks or contracts then begin
      exchange := trim(copy(line, 1, pos(sep, line) - 1));
      delete(line, 1, pos(sep, line));
      line := trim(line);
      if futures then
        tick := tick + ' ' + exchange
      else if optfutures then begin
        multStr := trim(copy(line, 1, pos(sep, line) - 1));
        delete(line, 1, pos(sep, line));
        line := trim(line);
      end;
    end;
    // opt futures multiplier
    oc := trim(copy(line, 1, pos(sep, line) - 1));
    delete(line, 1, pos(sep, line));
    line := trim(line);
    if pos('BUY', oc) > 0 then
      oc := 'O'
    else if pos('SELL', oc) > 0 then
      oc := 'C';
    // L/S
    ls := 'L';
    // base currency multiplier
    if futures then begin
      multStr := trim(copy(line, 1, pos(sep, line) - 1));
      delete(line, 1, pos(sep, line));
      line := trim(line);
    end
    else if stocks or contracts then
      multStr := '1';
    // DP to DE: This value is never used!
    // date
    ImpDate := trim(copy(line, 1, pos(sep, line) - 1));
    delete(line, 1, pos(sep, line));
    line := trim(line);
    ImpDate := LongDateStr(copy(ImpDate, 5, 2) + '/' + copy(ImpDate, 7, 2) + '/' +
        copy(ImpDate, 1, 4));
    if not ValidTradeDate(ImpDate, ImpDateLast, ImpNextDateOn) then begin
      dec(R);
      Continue;
    end;
    // time
    TimeStr := trim(copy(line, 1, pos(sep, line) - 1));;
    delete(line, 1, pos(sep, line));
    line := trim(line);
    // base currency
    usdStr := trim(copy(line, 1, pos(sep, line) - 1));
    delete(line, 1, pos(sep, line));
    line := trim(line);
    // shares
    ShStr := trim(copy(line, 1, pos(sep, line) - 1));
    delete(line, 1, pos(sep, line));
    line := trim(line);
    // price
    PrStr := trim(copy(line, 1, pos(sep, line) - 1));
    delete(line, 1, pos(sep, line));
    line := trim(line);
    // amount
    AmtStr := trim(copy(line, 1, pos(sep, line) - 1));
    delete(line, 1, pos(sep, line));
    line := trim(line);
    // comm
    CommStr := trim(copy(line, 1, pos(sep, line) - 1));
    delete(line, 1, pos(sep, line));
    line := trim(line);
    // mult
    foreignCurrStr := line;
    // --------------------------------
    try
      Shares := StrToFloat(ShStr, Settings.InternalFmt);
      Commis := StrToFloat(CommStr, Settings.InternalFmt);
      if stocks then begin
        mult := StrToFloat(foreignCurrStr, Settings.InternalFmt);
        typeStr := 'STK-' + floattostr(mult, Settings.UserFmt);
      end
      else if contracts then begin
        mult := StrToFloat(foreignCurrStr, Settings.InternalFmt);
        typeStr := 'OPT-' + floattostr(mult * 100, Settings.UserFmt);
      end
      else if futures then begin
        Amount := 0;
        mult := StrToFloat(multStr, Settings.InternalFmt) * StrToFloat(foreignCurrStr,
          Settings.InternalFmt);
        if (pos('(STK)', tick) > 0) then
          typeStr := 'SSF-' + floattostr(mult, Settings.UserFmt)
        else
          typeStr := 'FUT-' + floattostr(mult, Settings.UserFmt);
      end
      else if optfutures then begin
        Amount := 0;
        mult := StrToFloat(multStr, Settings.InternalFmt) * StrToFloat(foreignCurrStr,
          Settings.InternalFmt);
        typeStr := 'FUT-' + floattostr(mult, Settings.UserFmt);
      end
      else if CurrencyTrades then begin
        Amount := 0;
        mult := StrToFloat(foreignCurrStr, Settings.InternalFmt);
        typeStr := 'CUR-' + floattostr(mult, Settings.UserFmt);
      end
      else
        typeStr := 'STK-1';
      if (Shares < 0) then
        Shares := -Shares;
      Price := StrToFloat(PrStr, Settings.InternalFmt);
      if Price < 0 then
        Price := -Price;
      Amount := StrToFloat(AmtStr, Settings.InternalFmt);
      if Amount < 0 then
        Amount := -Amount;
      // recalc commis
      mult := StrToFloat(foreignCurrStr, Settings.InternalFmt);
      Commis := Commis * mult;
      ImpTrades[R].it := TradeLogFile.Count + R;
      ImpTrades[R].DT := ImpDate;
      ImpTrades[R].tm := TimeStr;
      ImpTrades[R].tk := tick;
      ImpTrades[R].oc := oc;
      ImpTrades[R].ls := ls;
      ImpTrades[R].sh := Shares;
      ImpTrades[R].pr := Price;
      ImpTrades[R].prf := typeStr;
      ImpTrades[R].cm := Commis;
      ImpTrades[R].am := Amount;
      ImpTrades[R].no := '';
      ImpTrades[R].m := '';
      ImpTrades[R].br := IntToStr(TradeLogFile.CurrentBrokerID);
      ImpTrades[R].opTk := optTick;
    except
      DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
      dec(R);
      Continue;
    end;
  end;
  ImpStrList.Destroy;
  result := R;
  SortImpByDate(R);
  if R = 0 then
    sm('There were no trades in the statement for this date');
end; // ReadIBFlexOld


function ReadIBflex(FileName : string): integer;
var
  i, j, p, R : integer;
  ImpDate, CmStr, PrStr, AmtStr, ShStr, line, optTick, sep, TimeStr, typeStr, descr, usdStr,
    multStr, foreignCurrStr, NextDate, exchange, ibcodes, trID, junk : string;
  Amount, Commis, mult, currMult : double;
  oc, ls, CommStr, s : string;
  contracts, futures, CurrencyTrades, optfutures, stocks, ImpNextDateOn, cancels, bonds, bills,
    tbills, exchangeBlank, miniOptions : boolean;
begin
  try
    ImpDate := '';
    DataConvErrRec := '';
    DataConvErrStr := '';
    ImpTrades := nil;
    R := 0;
    ImpNextDateOn := false;
    ImpStrList := TStringList.Create;
    ImpStrList.clear;
    cancels := false;
    exchangeBlank := false;
    ImpTrades := nil;
    setLength(ImpTrades, R + 1);
    GetImpDateLast;
    if FileName <> '' then
      GetImpStrListFromFile('', '', FileName)
    else
      try
        // check for old flex format
        if pos('ACCOUNT_INFORMATION' + CRLF + 'AI|', clipBoard.astext) > 0 then begin
          result := ReadIBflexOLD(''); // <--- the only place that calls this
          exit;
        end;
        GetImpStrListFromClip(false);
      except
        on e : Exception do begin
          sm('Error getting IB flex data from clipboard' + CRLF //
              + e.Message);
        end;
      end;
    sep := '|';
    if ImpStrList.Count < 1 then begin
      ImpStrList.Destroy;
      result := 0;
      exit;
    end;
    // --------------------------------
    for i := 0 to ImpStrList.Count - 1 do begin
      inc(R);
      if R < 1 then
        R := 1;
      line := trim(ImpStrList[i]);
      stocks := false;
      futures := false;
      contracts := false;
      optfutures := false;
      bonds := false;
      CurrencyTrades := false;
      mult := 1;
      optTick := '';
      if (pos('STK_TRD|', line) = 1) then
        stocks := true
      else if (pos('FUND_TRD|', line) = 1) then
        stocks := true
      else if (pos('BOND_TRD|', line) = 1) then
        bonds := true
      else if (pos('BILL_TRD|', line) = 1) then
        bonds := true
      else if (pos('TBILL_TRD|', line) = 1) then
        bonds := true
      else if (pos('OPT_TRD|', line) = 1) then
        contracts := true
      else if (pos('FUT_TRD|', line) = 1) then
        futures := true
      else if (pos('FSFOP_TRD|', line) = 1) then
        optfutures := true
      else if (pos('FOP_TRD|', line) = 1) then
        optfutures := true
      else if (pos('CASH_TRD|', line) = 1) then
        CurrencyTrades := true
      else if (pos('WAR_TRD|', line) = 1) then // 2022-02-11 MB
        stocks := true
      else begin
        dec(R);
        Continue;
      end;
      // delete first field
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // trade ID
      trID := trim(copy(line, 1, pos(sep, line) - 1));
      if not isInt(trID) then
        trID := '';
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // ticker
      if contracts or optfutures or futures then begin
        // Line: FUT_TRD|365763680|ESH7|ES 17MAR17|GLOBEX|...
        // optTick: ESH7
        optTick := trim(copy(line, 1, pos(sep, line) - 1));
        delete(line, 1, pos(sep, line));
        line := trim(line);
        // tick: ES 17MAR17
        tick := trim(copy(line, 1, pos(sep, line) - 1));
        // for tickers like RDS A 03APR20 32.5 C
        if (pos(' ', tick, 1)= 4) //
          and (pos(' ', tick, 5)= 6) then begin
          // 2022-08-11 MB - remove space in 4th position
          tick := copy(tick, 1, 3) + copy(tick, 5, length(tick)- 4);
        end;
        delete(line, 1, pos(sep, line));
        line := trim(line);
        if copy(tick, length(tick), 1) = 'C' then
          tick := tick + 'ALL'
        else if copy(tick, length(tick), 1) = 'P' then
          tick := tick + 'UT';
        // tick: ES 17MAR17 (no change for a FUT Contract!)
        // delete extra zero from strike price - ie: ROC 16APR11 45.0 PUT
        p := pos('.0 ', tick);
        if p > 0 then
          delete(tick, p, 2);
      end
      else begin
        tick := trim(copy(line, 1, pos(sep, line) - 1));
        delete(line, 1, pos(sep, line));
        line := trim(line);
        descr := trim(copy(line, 1, pos(sep, line) - 1));
        delete(line, 1, pos(sep, line));
        line := trim(line);
      end;
      // exchange
      exchange := trim(copy(line, 1, pos(sep, line) - 1));
      if (exchange = '--') and (pos('FUT_TRD|', line) = 1) then begin
        exchangeBlank := true;
        exchange := 'GLOBEX';
      end;
      delete(line, 1, pos(sep, line));
      line := trim(line);
      if futures then
        tick := tick + ' ' + exchange // EX: ES 17MAR17 GLOBEX
      else if optfutures then begin
        // multStr := trim(copy(line,1,pos(sep,line)-1));
        // delete(line,1,pos(sep,line));    line:= trim(line);
      end;
      tick := uppercase(tick);
      // open/close
      oc := trim(copy(line, 1, pos(sep, line) - 1));
      delete(line, 1, pos(sep, line));
      line := trim(line);
      if pos('BUYTOOPEN', oc) > 0 then begin
        oc := 'O';
        ls := 'L';
      end
      else if pos('SELLTOOPEN', oc) > 0 then begin
        oc := 'O';
        ls := 'S';
      end
      else if pos('BUYTOCLOSE', oc) > 0 then begin
        oc := 'C';
        ls := 'S';
      end
      else if pos('SELLTOCLOSE', oc) > 0 then begin
        oc := 'C';
        ls := 'L';
      end
      else if pos('BUY', oc) > 0 then begin
        oc := 'O';
        ls := 'L';
      end
      else if pos('SELL', oc) > 0 then begin
        oc := 'C';
        ls := 'L';
      end;
      // delete IB code
      ibcodes := trim(lowercase(copy(line, 1, pos(sep, line) - 1)));
      if (pos('ca', ibcodes) > 0) or (pos('co', ibcodes) > 0) then begin
        cancels := true;
        oc := 'X';
      end;
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // ------------------------------
      // date
      // ------------------------------
      ImpDate := trim(copy(line, 1, pos(sep, line) - 1));
      delete(line, 1, pos(sep, line));
      line := trim(line);
      ImpDate := LongDateStr(copy(ImpDate, 5, 2) //
          + '/' + copy(ImpDate, 7, 2) //
          + '/' + copy(ImpDate, 1, 4));
// // allow for Fri trades when importing starting with Mon
// if (dayOfWeek(StrToDate(ImpDateLast, Settings.InternalFmt)) = 6) then begin
// if (ImpDate < ImpDateLast) then begin // but allow ImpDate >= ImpDateLast
//   dec(R);
//   Continue;
// end;
// end
// else
      if not ValidTradeDate(ImpDate, ImpDateLast, ImpNextDateOn) then begin
        dec(R);
        Continue;
      end;
      // ------------------------------
      // time
      // ------------------------------
      TimeStr := trim(copy(line, 1, pos(sep, line) - 1));
      // test for time = 012-07-0
      if (pos('-', TimeStr)> 0) then begin
        // change dashes to semicolon
        TimeStr := StringReplace(TimeStr, '-', ':', [rfReplaceAll]);
      end;
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // ------------------------------
      // base currency
      // ------------------------------
      usdStr := trim(copy(line, 1, pos(sep, line) - 1));
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // if usdStr='USD' then usd:= true else usd:= false;
      // shares
      ShStr := trim(copy(line, 1, pos(sep, line) - 1));
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // mult
      multStr := trim(copy(line, 1, pos(sep, line) - 1));
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // price
      PrStr := trim(copy(line, 1, pos(sep, line) - 1));
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // amount
      AmtStr := trim(copy(line, 1, pos(sep, line) - 1));
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // comm
      CommStr := trim(copy(line, 1, pos(sep, line) - 1));
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // base currency factor
      foreignCurrStr := line;
      // make sure we get one
      if (foreignCurrStr = '') //
        or (not IsFloat(foreignCurrStr)) then
        foreignCurrStr := '1.00';
      // ------------------------------
      try
        Shares := StrToFloat(ShStr, Settings.InternalFmt);
        // fix for no buy/sell codes for currency
        if oc = '' then begin
          if Shares < 0 then
            oc := 'C'
          else
            oc := 'O';
        end;
        Price := StrToFloat(PrStr, Settings.InternalFmt);
        if Price < 0 then
          Price := -Price;
        Amount := StrToFloat(AmtStr, Settings.InternalFmt);
        if Amount < 0 then
          Amount := -Amount;
        Commis := -StrToFloat(CommStr, Settings.InternalFmt);
        if stocks then begin
          mult := StrToFloat(foreignCurrStr, Settings.InternalFmt);
          typeStr := 'STK-' + floattostr(mult, Settings.UserFmt);
        end
        else if bonds then begin
          mult := 0.01;
          typeStr := 'STK-0.01';
        end
        else if contracts then begin
          // mini options
          if IsFloat(multStr) then
            mult := StrToFloat(multStr, Settings.InternalFmt);
          mult := mult * StrToFloat(foreignCurrStr, Settings.InternalFmt);
          typeStr := 'OPT-' + floattostr(mult, Settings.UserFmt);
        end
        else if futures then begin
          Amount := 0;
          mult := StrToFloat(multStr, Settings.InternalFmt) //
            * StrToFloat(foreignCurrStr, Settings.InternalFmt);
          if (pos('(STK)', tick) > 0) then
            typeStr := 'SSF-' + floattostr(mult, Settings.UserFmt)
          else
            typeStr := 'FUT-' + floattostr(mult, Settings.UserFmt);
        end
        else if optfutures then begin
          Amount := 0;
          mult := StrToFloat(multStr, Settings.InternalFmt) //
            * StrToFloat(foreignCurrStr, Settings.InternalFmt);
          typeStr := 'FUT-' + floattostr(mult, Settings.UserFmt);
        end
        else if CurrencyTrades then begin
          Amount := 0;
          mult := StrToFloat(foreignCurrStr, Settings.InternalFmt);
          typeStr := 'CUR-' + floattostr(mult, Settings.UserFmt);
        end
        else
          typeStr := 'STK-1';
        if (Shares < 0) then
          Shares := -Shares;
        // recalc commis
        mult := StrToFloat(foreignCurrStr, Settings.InternalFmt);
        if not CurrencyTrades then
          Commis := Commis * mult;
        // ----------------------------
        ImpTrades[R].it := TradeLogFile.Count + R;
        ImpTrades[R].DT := ImpDate;
        ImpTrades[R].tm := TimeStr;
        ImpTrades[R].tk := tick;
        ImpTrades[R].oc := oc;
        ImpTrades[R].ls := ls;
        ImpTrades[R].sh := Shares;
        ImpTrades[R].pr := Price;
        ImpTrades[R].prf := typeStr;
        ImpTrades[R].cm := Commis;
        ImpTrades[R].am := Amount;
        ImpTrades[R].no := trID;
        ImpTrades[R].m := '';
        ImpTrades[R].br := IntToStr(TradeLogFile.CurrentBrokerID);
        ImpTrades[R].opTk := optTick;
      except
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        dec(R);
        Continue;
      end;
    end; // for i := 0 to ImpStrList.Count - 1
    // --------------------------------
    if exchangeBlank then
      sm('IB reported some Futures tradess with exchange = "--"' + cr //
          + 'these were imported as Exchange = "Globex"');
    ImpStrList.Destroy;
    result := R;
    SortImpByDate(R);
    // --------------------------------
    if cancels then begin
      StatBar('Matching Cancelled Trades');
      // first pass match with trID
      for i := 1 to R do begin
        // statBar('Matching Cancelled Trades: '+intToStr(i));
        for j := 1 to R do begin
          if (ImpTrades[i].oc = 'X') and (ImpTrades[i].no <> '') and
            (ImpTrades[i].tk = ImpTrades[j].tk) and (ImpTrades[i].no = ImpTrades[j].no) and
            (format('%1.5f', [ImpTrades[i].sh], Settings.UserFmt) = format('%1.5f',
              [ImpTrades[j].sh], Settings.UserFmt)) and
            (format('%1.5f', [ImpTrades[i].pr], Settings.UserFmt) = format('%1.5f',
              [ImpTrades[j].pr], Settings.UserFmt)) and
            (format('%1.5f', [ImpTrades[i].cm], Settings.UserFmt) = format('%1.5f',
              [-ImpTrades[j].cm], Settings.UserFmt)) and (ImpTrades[j].oc <> '') and (i <> j) then
          begin
            glNumCancelledTrades := glNumCancelledTrades + 2;
            ImpTrades[i].oc := ''; // i
            ImpTrades[i].ls := '';
            ImpTrades[i].tm := '';
            ImpTrades[i].tk := '';
            ImpTrades[i].no := '';
            ImpTrades[j].oc := ''; // j
            ImpTrades[j].ls := '';
            ImpTrades[j].tm := '';
            ImpTrades[j].tk := '';
            ImpTrades[j].no := '';
            break;
          end;
        end; // for j
      end; // for i
      // second pass if no trade ID - match to time stamp
      for i := 1 to R do begin
        // statBar('Matching Cancelled Trades: '+intToStr(i));
        for j := 1 to R do begin
          if (ImpTrades[i].oc = 'X') and (ImpTrades[i].tk = ImpTrades[j].tk) and
            (ImpTrades[i].tm = ImpTrades[j].tm) and
            (format('%1.5f', [ImpTrades[i].sh], Settings.UserFmt) = format('%1.5f',
              [ImpTrades[j].sh], Settings.UserFmt)) and
            (format('%1.5f', [ImpTrades[i].pr], Settings.UserFmt) = format('%1.5f',
              [ImpTrades[j].pr], Settings.UserFmt)) and
            (format('%1.5f', [ImpTrades[i].cm], Settings.UserFmt) = format('%1.5f',
              [-ImpTrades[j].cm], Settings.UserFmt)) and (ImpTrades[j].oc <> '') and (i <> j) then
          begin
            StatBar(ImpTrades[i].tk + '  ' + ImpTrades[j].tm + '  ' + ImpTrades[j].no + cr +
                ImpTrades[j].no);
            glNumCancelledTrades := glNumCancelledTrades + 2;
            ImpTrades[i].oc := ''; // i
            ImpTrades[i].ls := '';
            ImpTrades[i].tm := '';
            ImpTrades[i].tk := '';
            ImpTrades[i].no := '';
            ImpTrades[j].oc := ''; // j
            ImpTrades[j].ls := '';
            ImpTrades[j].tm := '';
            ImpTrades[j].tk := '';
            ImpTrades[j].no := '';
            break;
          end;
        end; // for j
      end; // for i
    end;
    // --------------------------------
    // clear notes column
    for i := 1 to R do
      ImpTrades[i].no := '';
    if R = 0 then
      sm('There were no trades in the statement for this date');
  finally
    // ReadIBFlex
  end;
end;


// ------------------------------------
function ReadIB() : integer; // 2020-01-21 MB
var
  X, impMode : integer;
  ImpDir, line, newPath, FileName, sImpFile : string;
  ImpFile : textfile;
  newFiles : TStringList;
  FileStream : TStreamReader;
  cancelImport : boolean;
begin
  result := 0;
  impMode := 0; // error condition; 1=BC, 2=Paste, 3=File
  webGetData := ''; // initialize
  // ----------------------------------
  // all IB methods put data into webGetData
  // ----------------------------------
  if sImpMethod = 'BC' then begin // imBrokerConnect:
    formGet.showmodal;
    if cancelURL then
      exit;
    getIBflex(OFXDateStart, OFXDateEnd);
  end
  // --------------------------------
  else if sImpMethod = 'Web' then begin //
    webGetData := clipBoard.astext; // Clipboard Import
  end
  // --------------------------------
  else if sImpMethod = 'File' then begin // imFileImport
    impMode := 3; // file import only
    // select file
    ImpDir := Settings.ImportDir;
    newPath := '';
    newFiles := TStringList.Create;
    newFiles.Capacity := 1;
    cancelImport := false;
    X := 0;
    if frmMain.OpenFileDialog( //
      'IB/TradeLog data files (*.tlg or *.csv)|*.tlg;*.csv', //
      ImpDir, 'IB Import', newPath, newFiles, false, false //
      ) then begin
      try
        FileName := newPath + '\' + newFiles[0];
        if FileExists(FileName) then begin
          FileStream := TStreamReader.Create(FileName);
          // Get  Records
          while not FileStream.EndOfStream do begin
            if cancelImport then
              break;
            line := FileStream.ReadLine;
            X := X + 1;
            if X = 1 then
              webGetData := line
            else
              webGetData := webGetData + lf + line;
            Application.ProcessMessages;
            if GetKeyState(VK_ESCAPE) //
              and 128 = 128 then
              cancelImport := true;
          end; // while
        end; // if fileExists
      finally
        FileStream.Free;
      end; // try...finally
      clipBoard.astext := webGetData; // 2020-01-22 MB - odd, but it works
    end; // if OpenFileDialog
  end // if sImpMethod = 'File'
  else begin // import method dialog
    exit(0); // canceled
  end; // case of sImpMethod
  // --------------------------------
  // now, read the data
  // --------------------------------
  if pos('ACCOUNT_INFORMATION', webGetData) > 0 then begin
    result := ReadIBflex(''); // <--- the only place that calls this
    exit;
  end
  else
    result := 0;
  // end if
end; // ReadIB


// ------------------------------------
// Investrade Import routines
// ------------------------------------

function ReadInvestradeOld(): integer;
var
  i, j, p, R : integer;
  ImpDate, tmStr, PrStr, prfStr, AmtStr, ShStr, line, sep, junk : string;
  Amount, Commis, mult : double;
  unknown, cancels, ImpNextDateOn, contracts : boolean;
  oc, ls : string;
begin
  try
    DataConvErrRec := '';
    DataConvErrStr := '';
    Commis := 0;
    R := 0;
    cancels := false;
    ImpNextDateOn := false;
    ImpStrList := TStringList.Create;
    ImpTrades := nil;
    setLength(ImpTrades, R + 1);
    GetImpDateLast;
    // --------------------------------
    if ImpStrList.Count < 1 then begin
      ImpStrList.Destroy;
      result := 0;
      exit;
    end;
    // --------------------------------
    for i := 0 to ImpStrList.Count - 1 do begin
      contracts := false;
      unknown := false;
      inc(R);
      if R < 1 then
        R := 1;
      line := trim(ImpStrList[i]);
      // convert tabs to spaces
      while (pos(TAB, line) > 0) do begin
        p := pos(TAB, line);
        insert(' ', line, p);
        delete(line, p + 1, 1);
      end;
      sep := ' ';
      if (pos('Trade Date Settlement Date Activity Type Account Type Symbol Description Quantity',
          line) > 0) then begin
        result := ReadInvestradeOld;
        exit;
      end;
      // date
      ImpDate := trim(copy(line, 1, pos(sep, line) - 1));
      if (pos('/', ImpDate) <> 3) then begin
        dec(R);
        if (i = ImpStrList.Count - 1) and (R = 0) then begin
          if ImpNextDateOn then begin
            sm('No transactions later than ' + ImpDateLast);
          end
          else begin
            sm('InvesTrade Import Error' + cr + cr + 'Please reselect entire report');
          end;
          result := 0;
          exit;
        end;
        Continue;
      end;
      ImpDate := LongDateStr(ImpDate);
      if not ValidTradeDate(ImpDate, ImpDateLast, ImpNextDateOn) then begin
        dec(R);
        Continue;
      end;
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // time
      tmStr := trim(copy(line, 1, pos(sep, line) - 1));
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // settle date?
      junk := trim(copy(line, 1, pos(sep, line) - 1));
      delete(line, 1, pos(sep, line));
      line := trim(line);
      line := trim(lowercase(line));
      // o/c l/s
      ls := 'L';
      oc := copy(line, 1, pos(sep, line));
      if (pos('bought', oc) > 0) or (pos('buy', oc) > 0) then begin
        if (pos('cancel', line) > 0) then begin
          cancels := true;
          oc := 'X';
        end
        else if (pos('to open', line) > 0) then begin
          oc := 'O';
          contracts := true;
          delete(line, 1, pos('to open', line) + 7);
        end
        else if (pos('to close', line) > 0) then begin
          oc := 'C';
          contracts := true;
          delete(line, 1, pos('to close', line) + 8);
        end
        else
          oc := 'O';
      end
      else if (pos('sold', oc) > 0) or (pos('sell', oc) > 0) then begin
        oc := 'C';
        if (pos('cancel', line) > 0) then begin
          cancels := true;
          oc := 'X';
        end
        else if (pos('to open', line) > 0) then begin
          oc := 'O';
          contracts := true;
          delete(line, 1, pos('to open', line) + 7);
        end
        else if (pos('to close', line) > 0) then begin
          oc := 'C';
          contracts := true;
          delete(line, 1, pos('to close', line) + 8);
        end
        else
          oc := 'C';
      end
      else if (pos('unknown', oc) > 0) then begin
        unknown := true;
        oc := 'C';
      end
      else begin
        dec(R);
        Continue;
      end;
      delete(line, 1, pos(sep, line));
      line := trim(line);
      if (pos('cancel', line) > 0) then begin
        delete(line, 1, pos(sep, line));
        line := trim(line);
      end;
      // shares
      ShStr := trim(copy(line, 1, pos(sep, line)));
      delete(ShStr, pos(',', ShStr), 1);
      delete(ShStr, pos('-', ShStr), 1);
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // ticker
      tick := trim(copy(line, 1, pos(sep, line)));
      tick := uppercase(tick);
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // price
      PrStr := trim(copy(line, 1, pos(sep, line)));
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // amt
      AmtStr := trim(copy(line, 1, pos(sep, line)));
      // ------------------------------
      try
        if contracts then begin
          mult := 100;
          prfStr := 'OPT-100';
        end
        else begin
          mult := 1;
          prfStr := 'STK-1';
        end;
        Shares := StrToFloat(ShStr, Settings.InternalFmt);
        if Shares < 0 then
          Shares := -Shares;
        // comm
        Price := CurrToFloat(PrStr);
        if Price < 0 then
          Price := -Price;
        Amount := CurrToFloat(AmtStr);
        if Amount < 0 then
          Amount := -Amount;
        if Amount <> 0 then begin
          if (((oc = 'O') and (ls = 'L')) or ((oc = 'C') and (ls = 'S'))) then
            Commis := Amount - (Shares * Price * mult)
          else
            Commis := (Shares * Price * mult) - Amount;
        end;
        ImpTrades[R].it := TradeLogFile.Count + R;
        ImpTrades[R].DT := ImpDate;
        ImpTrades[R].tm := tmStr;
        ImpTrades[R].oc := oc;
        ImpTrades[R].ls := ls;
        ImpTrades[R].tk := tick;
        ImpTrades[R].sh := Shares;
        ImpTrades[R].pr := Price;
        ImpTrades[R].prf := prfStr;
        ImpTrades[R].cm := Commis;
        ImpTrades[R].am := Amount;
      except
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        dec(R);
        Continue;
      end;
    end;
    ReverseImpTradesDate(R);
    if cancels then begin
      for i := 1 to R do begin
        if (ImpTrades[i].oc = 'X') then
          for j := i + 1 downto 1 do begin
            if (ImpTrades[i].tk = ImpTrades[j].tk) //
              and (ImpTrades[i].sh = ImpTrades[j].sh) //
              and (ImpTrades[i].pr = ImpTrades[j].pr) //
              and (format('%1.2f', [ImpTrades[i].pr], Settings.UserFmt) = format('%1.2f',
                [ImpTrades[j].pr], Settings.UserFmt)) //
              and (i <> j) then begin
              glNumCancelledTrades := glNumCancelledTrades + 2;
              ImpTrades[i].oc := '';
              ImpTrades[i].ls := '';
              ImpTrades[j].oc := '';
              ImpTrades[j].ls := '';
              break;
            end;
          end;
      end;
    end;
    for i := 1 to R do begin
      if ImpTrades[i].oc = 'X' then begin
        sm('CANCEL TRADES NOT MATCHED!' + cr + cr //
            + 'Cancel Trades have Open/Close marked with an "X"');
        break;
      end;
    end;
    result := R;
    ImpStrList.Destroy;
  finally
    // ReadInvestradeOld
  end;
end;


//function ReadInvestradeCSV1(): integer;
//var
//  i, j, p, R : integer;
//  ImpDate, tmStr, PrStr, prfStr, AmtStr, ShStr, line, sep, junk : string;
//  Amount, Commis, mult : double;
//  cancels, ImpNextDateOn, contracts, myOld : boolean;
//  oc, ls : string;
//begin
//  try
//    DataConvErrRec := '';
//    DataConvErrStr := '';
//    Commis := 0;
//    R := 0;
//    cancels := false;
//    ImpNextDateOn := false;
//    myOld := false;
//    // --------------------------------
//    // NOTE: ImpStrList already populated
//    // by ReadInvestrade routine
//    // --------------------------------
//    for i := 0 to ImpStrList.Count - 1 do begin
//      line := trim(ImpStrList[i]);
//      if (pos('Trade Date', line) = 1) then begin
//        myOld := true;
//        break;
//      end;
//    end;
//    if myOld then begin
//      result := ReadInvestradeOld;
//      exit;
//    end;
//    for i := 0 to ImpStrList.Count - 1 do begin
//      contracts := false;
//      inc(R);
//      if R < 1 then
//        R := 1;
//      line := trim(ImpStrList[i]);
//      // convert tabs to spaces
//      while (pos(TAB, line) > 0) do begin
//        p := pos(TAB, line);
//        insert(' ', line, p);
//        delete(line, p + 1, 1);
//      end;
//      sep := ' ';
//      // delete Acct Type
//      junk := trim(copy(line, 1, pos(sep, line) - 1));
//      delete(line, 1, pos(sep, line));
//      line := trim(line);
//      // ticker
//      tick := trim(copy(line, 1, pos(sep, line)));
//      tick := uppercase(tick);
//      delete(line, 1, pos(sep, line));
//      line := trim(line);
//      // o/c l/s
//      ls := 'L';
//      line := trim(lowercase(line));
//      if (pos('bought', line) > 0) then begin
//        if (pos('cancel', line) > 0) then begin
//          cancels := true;
//          oc := 'X';
//        end
//        else if (pos('to open', line) > 0) then begin
//          oc := 'O';
//          contracts := true;
//          delete(line, 1, pos('to open', line) + 7);
//        end
//        else if (pos('to close', line) > 0) then begin
//          oc := 'C';
//          contracts := true;
//          delete(line, 1, pos('to close', line) + 8);
//        end
//        else begin
//          oc := 'O';
//          delete(line, 1, pos('bought', line) + 6);
//        end;
//      end
//      else if (pos('sold', line) > 0) then begin
//        oc := 'C';
//        if (pos('cancel', line) > 0) then begin
//          cancels := true;
//          oc := 'X';
//        end
//        else if (pos('to open', line) > 0) then begin
//          oc := 'O';
//          contracts := true;
//          delete(line, 1, pos('to open', line) + 7);
//        end
//        else if (pos('to close', line) > 0) then begin
//          oc := 'C';
//          contracts := true;
//          delete(line, 1, pos('to close', line) + 8);
//        end
//        else begin
//          oc := 'C';
//          delete(line, 1, pos('sold', line) + 4);
//        end;
//      end
//      else if (pos('unknown', line) > 0) then begin
//        oc := 'C';
//        delete(line, 1, pos('unknown', line) + 7);
//      end
//      else begin
//        dec(R);
//        Continue;
//      end;
//      if (pos('cancel', line) > 0) then begin
//        delete(line, 1, pos('cancel', line) + 5);
//        line := trim(line);
//      end;
//      line := trim(line);
//      // shares
//      ShStr := trim(copy(line, 1, pos(sep, line)));
//      delete(ShStr, pos(',', ShStr), 1);
//      delete(ShStr, pos('-', ShStr), 1);
//      delete(line, 1, pos(sep, line));
//      line := trim(line);
//      // price
//      PrStr := trim(copy(line, 1, pos(sep, line)));
//      delete(line, 1, pos(sep, line));
//      line := trim(line);
//      // amt
//      AmtStr := trim(copy(line, 1, pos(sep, line)));
//      delete(line, 1, pos(sep, line));
//      line := trim(line);
//      // date
//      ImpDate := trim(copy(line, 1, pos(sep, line) - 1));
//      if (pos('/', ImpDate) <> 3) then begin
//        dec(R);
//        if (i = ImpStrList.Count - 1) and (R = 0) then begin
//          if ImpNextDateOn then begin
//            sm('No transactions later than ' + ImpDateLast);
//          end
//          else begin
//            sm('InvesTrade Import Error' + cr + cr + 'Please reselect entire report');
//          end;
//          result := 0;
//          exit;
//        end;
//        Continue;
//      end;
//      ImpDate := LongDateStr(ImpDate);
//      if not ValidTradeDate(ImpDate, ImpDateLast, ImpNextDateOn) then begin
//        dec(R);
//        Continue;
//      end;
//      // time
//      tmStr := '';
//      // ------------------------------
//      try
//        if contracts then begin
//          mult := 100;
//          prfStr := 'OPT-100';
//        end
//        else begin
//          mult := 1;
//          prfStr := 'STK-1';
//        end;
//        Shares := StrToFloat(ShStr, Settings.InternalFmt);
//        if Shares < 0 then
//          Shares := -Shares;
//        // comm
//        Price := CurrToFloat(PrStr);
//        if Price < 0 then
//          Price := -Price;
//        Amount := CurrToFloat(AmtStr);
//        if Amount < 0 then
//          Amount := -Amount;
//        if Amount <> 0 then begin
//          if (((oc = 'O') and (ls = 'L')) or ((oc = 'C') and (ls = 'S'))) then
//            Commis := Amount - (Shares * Price * mult)
//          else
//            Commis := (Shares * Price * mult) - Amount;
//        end;
//        ImpTrades[R].it := TradeLogFile.Count + R;
//        ImpTrades[R].DT := ImpDate;
//        ImpTrades[R].tm := tmStr;
//        ImpTrades[R].oc := oc;
//        ImpTrades[R].ls := ls;
//        ImpTrades[R].tk := tick;
//        ImpTrades[R].sh := Shares;
//        ImpTrades[R].pr := Price;
//        ImpTrades[R].prf := prfStr;
//        ImpTrades[R].cm := Commis;
//        ImpTrades[R].am := Amount;
//      except
//        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
//        dec(R);
//        Continue;
//      end;
//    end;
//    ReverseImpTradesDate(R);
//    if cancels then begin
//      for i := 1 to R do begin
//        if (ImpTrades[i].oc = 'X') then
//          for j := i + 1 downto 1 do begin
//            if (ImpTrades[i].tk = ImpTrades[j].tk) //
//              and (ImpTrades[i].sh = ImpTrades[j].sh) //
//              and (ImpTrades[i].pr = ImpTrades[j].pr) //
//              and (format('%1.2f', [ImpTrades[i].pr], Settings.UserFmt) = format('%1.2f',
//                [ImpTrades[j].pr], Settings.UserFmt)) //
//              and (ImpTrades[j].oc <> '') //
//              and (i <> j) then begin
//              glNumCancelledTrades := glNumCancelledTrades + 2;
//              ImpTrades[i].oc := '';
//              ImpTrades[i].ls := '';
//              ImpTrades[j].oc := '';
//              ImpTrades[j].ls := '';
//              break;
//            end;
//          end;
//      end;
//    end;
//    for i := 1 to R do begin
//      if ImpTrades[i].oc = 'X' then begin
//        sm('CANCEL TRADES NOT MATCHED!' + cr + cr +
//            'Cancel Trades have Open/Close marked with an "X"');
//        break;
//      end;
//    end;
//    result := R;
//    ImpStrList.Destroy;
//  finally
//    // ReadInvestradeCSV1
//  end;
//end;


function ReadInvestradeCSV(): integer;
var
  i, j, k, n, start, eend, R, Q : integer;
  iDt, iTm, iTyp, iOC, iLS, iTk, iDesc, iShr, iPr, iAmt : integer; // import field numbers
  junk, sep, ImpDate, ImpTime, CmStr, feeStr, PrStr, AmtStr, ShStr, line, typeStr, optDesc, sTk, //
    optOC, opYr, opMon, opDay, opStrike, opCP, optTick, oc, ls, errLogTxt, opStrik2 : string;
  Amount, Commis, Fees, Shares, mult : double;
  contracts, Adj, optExpEx, ImpNextDateOn, bonds, newColFormat, miniOptions, futures, //
    bFoundHeader, cancels, assigns : boolean;
  fieldLst : TStrings;
  // ---- New CSV format 2020 ---------
  // Account          215756177
  // Account Name	    Dsida Mike
  // TK  Symbol   	      AAPL 200117P270
  // Cusip	          "
  // **  Description      PUT: APPLE INC Jan 17, 2020 @ 270
  // DT  Date	            12/16/2019
  // SHR Quantity	        20
  // OC  Transaction      Buy to Close
  // PR  Executed Price	  3.45
  // AMT Dollar Amount    6905.43
  // TYP Type	            opt
  // Current Balance  -626304.65
  // Settle Date	    12/17/2019
  // Sales Credit	    0.00%
  // Prior Balance	  -619399.22
  // CM Commission	      3.99
  // FEE Miscellaneous Fees	1
  // FEE SEC Fees	        0
  // Check Number	    0
  // Transaction Number	20191216 14DSLL9
  // ----------------------------------
  procedure SetFieldNumbers();
  var
    j : integer;
  begin
    // find/map Hilltop/Investrade CSV fields
    k := 0;
    for j := 0 to (fieldLst.Count - 1) do begin
      if fieldLst[j] = 'SYMBOL' then begin // Ticker
        iTk := j;
        k := k or 1;
      end
      else if fieldLst[j] = 'DESCRIPTION' then begin // Buy/Sell (Long/Short)
        iDesc := j;
        k := k or 2;
      end
      else if fieldLst[j] = 'DATE' then begin // Date/Time
        iDt := j;
        k := k or 4;
      end
      else if (fieldLst[j] = 'QUANTITY') then begin // Shares/Contracts
        iShr := j;
        k := k or 8;
      end
      else if fieldLst[j] = 'TRANSACTION' then begin // Open/Close
        iOC := j;
        k := k or 16;
      end
      else if trim(fieldLst[j]) = 'EXECUTED PRICE' then begin
        iPr := j;
        k := k or 32;
      end
      else if fieldLst[j] = 'DOLLAR AMOUNT' then begin // Amount
        iAmt := j;
        k := k or 64;
      end
      else if fieldLst[j] = 'TYPE' then begin // Open/Close
        iTyp := j;
        k := k or 128;
      end; // note: 'RATE' field is conversion factor
    end;
  end;

// --------------------------------------------
begin // ReadInvestradeCSV
  bFoundHeader := false; // haven't found the header yet
  // in case these are missing, flag to skip them.
  cancels := false;
  contracts := false;
  R := 0;
  try
    DataConvErrRec := '';
    DataConvErrStr := '';
    Commis := 0;
    ImpNextDateOn := false;
    // --------------------------------
    if ImpStrList.Count < 1 then begin
      ImpStrList.Destroy;
      result := 0;
      exit;
    end;
    iLS := 0; // no Long/Short indicator?
    fieldLst := TStrings.Create;
    // --------------------------------
    i := -1;
    while i < (ImpStrList.Count - 1) do begin
      inc(i); // make it work like a for/next
      contracts := false; // reset flags
      // ------------------------------
      line := ImpStrList[i];
      line := uppercase(line); // search line for UPPERCASE tokens...
      // ------------------------------
      if pos('"""', line) = 1 then
        line := copy(line, 3);
      // parse all columns into string list
      fieldLst := ParseCSV(line);
      if not bFoundHeader then begin
        if (pos('SYMBOL', line) > 0) //
          and (pos('QUANTITY', line) > 0) //
          and (pos('DATE', line) > 0) then begin
          SetFieldNumbers;
          if SuperUser and (k <> 255) then
            sm('there appear to be fields missing.');
          bFoundHeader := true; // don't do this anymore
          R := 0; // start now
        end;
        Continue; // don't process anything until we recognize the header
      end;
      // ------------------------------
      if pos('ERROR', line) > 0 then begin
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        sm('Investrade reported an error.' + cr + 'Please reduce the date range and try again.');
        result := 0;
        exit;
      end;
      // --- ticker -------------------
      tick := trim(fieldLst[iTk]);
      if tick = '' then
        Continue;
      // -- PRF = Type/Mult -----------
      typeStr := trim(fieldLst[iTyp]);
      if (pos('OPT', typeStr) = 1) then begin
        typeStr := 'OPT-100';
        mult := 100;
        contracts := true;
      end
      else begin
        typeStr := 'STK-1';
        mult := 1;
      end;
      // --- Date ---------------------
      ImpDate := fieldLst[iDt]; // format: M/DD/YYYY H:MM
      if pos('/', ImpDate) = 2 then
        ImpDate := '0' + ImpDate;
      if not isdate(ImpDate) then
        sm('Cannot determine the transaction date of this trade:' + cr + line);
      if not ValidTradeDate(ImpDate, ImpDateLast, ImpNextDateOn) then begin
// DataConvErrRec := DataConvErrRec + 'invalid date: ' + ImpStrList[i] + cr;
        Continue;
      end;
      if UserDateStrNotGreater(ImpDate, ImpDateLast) then begin
        if mDlg('Trades already imported for ' + ImpDate + cr //
            + cr //
            + 'Continue?', mtWarning, [mbNo, mbYes], 0) = mrNo then begin
          result := R;
          exit;
        end
        else
          ImpDateLast := '01/01/1900';
      end;
      if pos(':', ImpTime) = 2 then begin
        ImpTime := '0' + ImpTime;
      end;
      // --- OC and LS ----------------
      // PURCHASE, SALE, SALE - CANCEL, SHORT SALE, SHORT SALE BUYBACK
      junk := trim(fieldLst[iOC]);
      oc := 'E'; // default values
      ls := 'E'; // are E for ERROR
      if (junk = 'BUY') or (junk = 'PURCHASE') //
        or (junk = 'BUY TO OPEN') then begin
        oc := 'O';
        ls := 'L';
      end
      else if (junk = 'SELL') or (junk = 'SALE') //
        or (junk = 'SELL TO CLOSE') then begin
        oc := 'C';
        ls := 'L';
      end
      else if (pos('CANCEL', junk) > 0) then begin
        oc := 'X';
        cancels := true;
      end
      else if (junk = 'SHORT SALE') //
        or (junk = 'SELL TO OPEN') then begin
        oc := 'O';
        ls := 'S';
      end
      else if (junk = 'SHORT SALE BUYBACK') or (junk = 'BUY TO CLOSE') then begin
        oc := 'C';
        ls := 'S';
      end
      else begin // error
        // DataConvErrRec := DataConvErrRec + 'unknown OC/LS: ' + ImpStrList[i] + cr;
        oc := 'E';
        ls := 'E';
        Continue;
      end;
      // ------------------------------
      inc(R); // if it gets this far, count it
      // ------------------------------
      // option: TICK yymmddC$$$$$ccc
      if contracts then begin
        sTk := tick;
        optTick := parsefirst(sTk, ' '); // separate underlying ticker
        sTk := trim(sTk); // remove leading/trailing spaces, if any
        opYr := copy(sTk, 1, 2);
        opMon := copy(sTk, 3, 2);
        opMon := getExpMo(opMon);
        opDay := copy(sTk, 5, 2);
        opCP := copy(sTk, 7, 1);
        if opCP = 'C' then
          opCP := 'CALL'
        else
          opCP := 'PUT';
        if length(sTk) < 15 then begin
          // AAPL 200117P270
          opStrike := copy(sTk, 8);
          if pos('.', opStrike) > 1 then
            opStrik2 := parseLast(opStrike, '.')
          else
            opStrik2 := '00';
        end
        else begin
          opStrike := copy(sTk, 8, 5);
          opStrik2 := copy(sTk, 13, 3);
        end;
        try
          n := strToInt(opStrike);
          opStrike := IntToStr(n); // removes leading zeros
          n := strToInt(opStrik2);
        except
          on e : Exception do begin
            sm('ERROR in OPT ticker: ' + e.Message);
          end;
        end;
        if (n > 0) then
          opStrike := opStrike + '.' + IntToStr(n);
        opStrike := delTrailingZeros(opStrike); // 2017-10-09 MB Remove trailing zeros for matching
        tick := optTick + ' ' + opDay + opMon + opYr + ' ' + opStrike + ' ' + opCP;
      end;
      // --- # shares -----------------
      ShStr := fieldLst[iShr];
      ShStr := delCommas(ShStr);
      // --- price --------------------
      PrStr := fieldLst[iPr];
      delete(PrStr, pos('$', PrStr), 1);
      PrStr := delCommas(PrStr);
      if (xStrToFloat(PrStr) = 0) then
        PrStr := '0.00';
      // --- conversion rate
      // amount
      AmtStr := fieldLst[iAmt];
      // --- Commission ---------------
      Commis := 0;
      try
        Shares := CurrToFloat(ShStr);
        if Shares < 0 then
          Shares := -Shares; // ABS
        Price := CurrToFloat(PrStr);
        if Price < 0 then
          Price := -Price; // ABS
        Amount := ABS(CurrToFloat(AmtStr));
        // 2019-04-29 MB - add code to handle Buy/Sell separately
        if ((oc = 'O') and (ls = 'L')) or ((oc = 'C') and (ls = 'S')) then // BUY
          Commis := ABS(Amount) - ABS(Shares * Price * mult)
        else // // SELL
          Commis := ABS(Shares * Price * mult) - ABS(Amount);
        // 2019-04-29 MB - removed ABS(Commis) because rebates are allowed per Jason D.
        // ------ set import record fields ------
        ImpTrades[R].it := TradeLogFile.Count + R;
        ImpTrades[R].DT := ImpDate;
        ImpTrades[R].tm := ImpTime;
        ImpTrades[R].oc := oc;
        ImpTrades[R].ls := ls;
        ImpTrades[R].tk := tick;
        ImpTrades[R].sh := Shares;
        ImpTrades[R].pr := Price;
        ImpTrades[R].prf := typeStr;
        ImpTrades[R].cm := Commis;
        ImpTrades[R].am := Amount;
      except
        // DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        dec(R);
        Continue;
      end;
    end; // while
    // --------------------------------
    ReverseImpTradesDate(R);
    if cancels then begin
      for i := 1 to R do begin
        if (ImpTrades[i].oc = 'X') then
          for j := i + 1 downto 1 do begin
            if (ImpTrades[i].tk = ImpTrades[j].tk) //
              and (ImpTrades[i].sh = ImpTrades[j].sh) //
              and (ImpTrades[i].pr = ImpTrades[j].pr) //
              and (format('%1.2f', [ImpTrades[i].pr], Settings.UserFmt) = format('%1.2f',
                [ImpTrades[j].pr], Settings.UserFmt)) //
              and (ImpTrades[j].oc <> '') //
              and (i <> j) then begin
              glNumCancelledTrades := glNumCancelledTrades + 2;
              ImpTrades[i].oc := '';
              ImpTrades[i].ls := '';
              ImpTrades[j].oc := '';
              ImpTrades[j].ls := '';
              break;
            end;
          end;
      end;
    end;
    for i := 1 to R do begin
      if ImpTrades[i].oc = 'X' then begin
        sm('CANCEL TRADES NOT MATCHED!' + cr + cr +
            'Cancel Trades have Open/Close marked with an "X"');
        break;
      end;
    end;
    result := R;
    ImpStrList.Destroy;
  finally
    // ReadInvestradeCSV
  end;
end;

// Investrade ENTRY POINT
function ReadInvestrade(): integer;
var
  R : integer;
begin
  try
    R := 0;
    ImpStrList := TStringList.Create;
    ImpTrades := nil;
    setLength(ImpTrades, R + 1);
    GetImpDateLast;
    // ----------------------
    if FileExists(Settings.ImportDir + '\download.csv') then
      deleteFile(Settings.ImportDir + '\download.csv');
    // ----------------------
    GetImpStrListFromFile('*', 'csv', '');
    // ----------------------
    result := ReadInvestradeCSV;
    exit;
  finally
    // ReadInvestrade
  end;
end;


// ------------------------------------
// NOTE: some users provide the following columns (delimiter could be either comma or tab):
// Trade-#,Instrument,Account,Strategy,Market pos.,Quantity,Entry price,Exit price,
// Entry time,Exit time,Entry name,Exit name,Profit,Cum. profit,Commission,MAE,MFE,ETD,Bars,
// ------------------------------------
function ReadJPMorganChaseCSV(ImpStrList : TStringList) : integer;
var
  i, j, k, n, start, eend, R, Q : integer;
  iDt, iTm, iTyp, iOC, iLS, iTk, iDesc, iShr, iPr, iAmt : integer; // import field numbers
  junk, sep, ImpDate, ImpTime, PrStr, AmtStr, ShStr, line, typeStr, optDesc, sTk, sDesc, //
    optOC, opYr, opMon, opDay, opStrike, opCP, optTick, oc, ls, errLogTxt, opStrik2 : string;
  Amount, Commis, Fees, Shares, mult : double;
  contracts, Adj, optExpEx, ImpNextDateOn, bonds, newColFormat, miniOptions, futures, //
    bFoundHeader, cancels, assigns : boolean;
  fieldLst : TStrings;
  // --------------------------------------------
  // 1*Trade Date        01/08/2019    iDt, ImpDate
  // 2 Post Date         01/08/2019
  // 3 Settlement Date   01/10/2019
  // 4 Account Name      n/u
  // 5 Account Number    n/u
  // 6 Account Type      n/u
  // 7*Type              Buy           iOC, OC
  // 8*Description       (see below)   iDesc, typeStr
  // "AGNC INVESTMENT CORP COMMON STOCK UNSOLICITED..."
  // 9 Cusip             00123Q104
  // 10*Ticker            AGNC          iTk, sTk
  // 11*SECURITY TYPE     stock         iTyp, typeStr
  // 12 Local Currency    USD
  // 13*Price USD         17.86         iPr, PrStr
  // 14 Price Local       n/u
  // 15*Quantity          9.00000       iShr, ShStr
  // 16 Cost USD
  // 17 Cost Local
  // 18 G/L Short USD
  // 19 G/L Short Local
  // 20 G/L Long USD
  // 21 G/L Long Local
  // 22*Amount USD        -160.74       iAmt, AmtStr
  // 23 Amount Local      n/u
  // 24 Balance           n/u
  // 25 Commissions USD
  // 26 Commissions Local
  // 27 Tran Code
  // 28 Tran Code Description  Buy
  // 29 Broker
  // 30 Check Number
  // 31 Tax Withheld
  // ------------------------------------------------------
  // NOTES: Options have the following differences:
  // ------------------------------------------------------
  procedure SetFieldNumbers();
  var
    j : integer;
  begin
    // find/map JPMorganChase CSV fields
    k := 0;
    for j := 0 to (fieldLst.Count - 1) do begin
      if fieldLst[j] = 'TRADE DATE' then begin // Date/Time
        iDt := j;
        k := k or 1;
      end
      else if fieldLst[j] = 'TYPE' then begin // Open/Close
        iOC := j;
        k := k or 2;
      end
      else if (fieldLst[j] = 'QUANTITY') then begin // Shares/Contracts
        iShr := j;
        k := k or 4;
      end
      else if fieldLst[j] = 'TICKER' then begin // Ticker
        iTk := j;
        k := k or 8;
      end
      else if fieldLst[j] = 'SECURITY TYPE' then begin // STK/OPT
        iTyp := j;
        k := k or 16;
      end
      else if fieldLst[j] = 'PRICE USD' then begin
        iPr := j;
        k := k or 32;
      end
      else if fieldLst[j] = 'AMOUNT USD' then begin // Comm
        iAmt := j;
        k := k or 64;
      end
      else if fieldLst[j] = 'DESCRIPTION' then begin // Misc.
        iDesc := j;
        k := k or 128;
      end; // note: 'RATE' field is conversion factor
    end;
  end;
// --------------------------------------------
begin // ReadJPMorganChaseCSV
  bFoundHeader := false; // haven't found the header yet
  DataConvErrRec := '';
  // in case these are missing, flag to skip them.
  cancels := false;
  contracts := false;
  R := 0;
  // ----------------------------------
  try
    DataConvErrRec := '';
    DataConvErrStr := '';
    Adj := false;
    ImpNextDateOn := false;
    newColFormat := false;
    if ImpStrList.Count < 1 then begin
      ImpStrList.Destroy;
      result := 0;
      exit;
    end;
    iLS := 0; // no Long/Short indicator?
    fieldLst := TStrings.Create;
    // --------------------------------
    i := -1;
    while i < (ImpStrList.Count - 1) do begin
      inc(i); // make it work like a for/next
      contracts := false; // reset flags
      assigns := false;
      futures := false;
      miniOptions := false;
      optExpEx := false;
      bonds := false;
      // ------------------------------
      line := ImpStrList[i];
      line := uppercase(line); // search line for UPPERCASE tokens...
      // parse all columns into string list
      fieldLst := ParseCSV(line);
      if not bFoundHeader then begin
        if (pos('TRADE DATE', line) > 0) and (pos('TYPE', line) > 0) //
          and (pos('TICKER', line) > 0) then begin
          SetFieldNumbers;
          if SuperUser and (k <> 255) then
            sm('there appears to be a field missing.');
          bFoundHeader := true; // don't do this anymore
          R := 0; // start now
        end;
        Continue; // don't process anything until we recognize the header
      end;
      // ------------------------------
      if pos('ERROR', line) > 0 then begin
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        sm('J P Morgan Chase reported an error.' + cr +
            'Please reduce the date range and try again.');
        result := 0;
        exit;
      end;
      // --- ticker -------------------
      tick := trim(fieldLst[iTk]);
      if tick = '' then
        Continue;
      // -- PRF = Type/Mult -----------
      typeStr := fieldLst[iTyp];
      sDesc := trim(fieldLst[iDesc]); // used for PRF, LS, options
      if pos('OPTION', typeStr) = 1 then begin
        typeStr := 'OPT-100';
        mult := 100;
        contracts := true;
      end
      else if (typeStr = 'STOCK') then begin
        typeStr := 'STK-1';
        mult := 1;
      end
      else if (pos('MUTUAL', typeStr) = 1) then begin
        typeStr := 'MUT-1';
        mult := 1;
      end
      else if (typeStr = 'MONEY') then begin
        typeStr := 'STK-1';
        mult := 1;
      end
      else if (trim(typeStr) = '') then begin // blank security type
        if (pos('PUT', sDesc)= 1) or (pos('CALL', sDesc)= 1) then begin
          typeStr := 'OPT-100';
          mult := 100;
          contracts := true;
        end
        else begin // not sure, so assume stock
          typeStr := 'STK-1';
          mult := 1;
        end
      end // end blank security type
      else begin
        Continue; // unrecognized security type
      end;
      // --- Date ---------------------
      ImpDate := fieldLst[iDt]; // needed format: M/DD/YYYY H:MM
      if pos('/', ImpDate) = 2 then
        ImpDate := '0' + ImpDate;
      // 2020-07-10 MB - handle various date formats
      if pos('/', ImpDate) = 5 then begin // YYYY/MM/DD
        junk := ImpDate;
        opYr := parsefirst(junk, '/');
        opMon := parsefirst(junk, '/');
        opDay := junk;
        ImpDate := opDay + '/' + opMon + '/' + opYr;
      end
      else if (pos('/', ImpDate) = 0) //
        and (pos('-', ImpDate) = 0) then begin // hardest - no delimiter
        if (strToInt(copy(ImpDate, 1, 4)) > 2000) then begin // assume YYYYMMDD format
          junk := ImpDate;
          if (length(ImpDate) = 8) then //
            ImpDate := copy(junk, 5, 2) + '/' + copy(junk, 7, 2) + '/' + copy(junk, 1, 4)
          else if (length(junk) = 10) then // assume it has date dividers
            ImpDate := copy(junk, 6, 5) + '/' + copy(junk, 1, 4);
          // else do nothing
        end;
      end; // -----
      if not isdate(ImpDate) then
        sm('Cannot determine the transaction date of this trade:' + cr + line);
      if not ValidTradeDate(ImpDate, ImpDateLast, ImpNextDateOn) then begin
// DataConvErrRec := DataConvErrRec + 'invalid date: ' + ImpStrList[i] + cr;
        Continue;
      end;
      if UserDateStrNotGreater(ImpDate, ImpDateLast) then begin
        if mDlg('Trades already imported for ' + ImpDate + cr //
            + cr //
            + 'Continue?', mtWarning, [mbNo, mbYes], 0) = mrNo then begin
          result := R;
          exit;
        end
        else
          ImpDateLast := '01/01/1900';
      end;
      if pos(':', ImpTime) = 2 then begin
        ImpTime := '0' + ImpTime;
      end;
      // --- OC and LS ----------------
      junk := trim(fieldLst[iOC]); // used for OC
      oc := 'E'; // default values
      ls := 'E'; // are E for ERROR
      if (junk = 'BUY') or (junk = 'PURCHASE') then begin
        if contracts and (pos(sDesc, ' CLOSING CONTRACT ') > 0) then begin
          oc := 'C';
          ls := 'S';
        end
        else begin
          oc := 'O';
          ls := 'L';
        end;
      end
      else if (junk = 'SELL') or (junk = 'SALE') then begin
        oc := 'C';
        ls := 'L';
        if contracts and (pos(sDesc, ' OPEN CONTRACT ') > 0) then begin
          oc := 'O';
          ls := 'S';
        end
        else begin
          oc := 'C';
          ls := 'L';
        end;
      end
      else if (pos('CANCEL', junk) > 0) then begin
        oc := 'X';
        cancels := true;
      end
      else if (junk = 'SHORT SALE') then begin
        oc := 'O';
        ls := 'S';
      end
      else if (junk = 'SHORT SALE BUYBACK') then begin
        oc := 'C';
        ls := 'S';
      end
      else if (junk = 'REINVEST') then begin
        oc := 'O';
        ls := 'L';
      end
      else begin // error
        // DataConvErrRec := DataConvErrRec + 'unknown OC/LS: ' + ImpStrList[i] + cr;
        oc := 'E';
        ls := 'E';
        Continue; // can't determine what it is, must skip it
      end;
      // ------------------------------
      inc(R); // if it gets this far, count it
      // ------------------------------
      // option: TICK yymmddC$$$$$ccc
      // or TICK mmm dd CALL/PUT $$.cc
      if contracts then begin
        sTk := tick;
        optTick := parsefirst(sTk, ' '); // separate underlying ticker
        sTk := trim(sTk); // remove leading/trailing spaces, if any
        if pos(' ', sTk)= 0 then begin
          opYr := copy(sTk, 1, 2);
          opMon := copy(sTk, 3, 2);
          opMon := getExpMo(opMon);
          opDay := copy(sTk, 5, 2);
          opCP := copy(sTk, 7, 1);
          if opCP = 'C' then
            opCP := 'CALL'
          else
            opCP := 'PUT';
          if length(sTk) < 15 then
            sm('sTk too short: ' + sTk);
          opStrike := copy(sTk, 8, 5);
          opStrik2 := copy(sTk, 13, 3);
          try
            n := strToInt(opStrike);
            opStrike := IntToStr(n); // removes leading zeros
            n := strToInt(opStrik2);
          except
            on e : Exception do begin
              sm('ERROR in OPT ticker: ' + e.Message);
            end;
          end;
          if (n > 0) then
            opStrike := opStrike + '.' + IntToStr(n);
          opStrike := delTrailingZeros(opStrike);
          // 2017-10-09 MB Remove trailing zeros for matching
          tick := optTick + ' ' + opDay + opMon + opYr + ' ' + opStrike + ' ' + opCP;
        end
        else begin
          // Must get expiration date from description, like this:
          // CALL MSFT 02/14/20 195 MICROSOFT CORP CLOSING CONTRACT...
          // C/P  Tick mm/dd/yy $$$
          opCP := parsefirst(sDesc, ' '); // remove CALL or PUT
          junk := parsefirst(sDesc, ' '); // remove ticker
          junk := parsefirst(sDesc, ' '); // <-- EXP DATE
          opMon := parsefirst(junk, '/');
          opMon := getExpMo(opMon);
          opDay := parsefirst(junk, '/');
          opYr := junk;
          // maybe better to get strike price from ticker
          // FEB 20 CALL 195.00
          junk := tick;
          opStrike := parseLast(junk, ' ');
          opStrike := delTrailingZeros(opStrike);
          tick := optTick + ' ' + opDay + opMon + opYr + ' ' + opStrike + ' ' + opCP;
        end;
      end;
      // --- # shares -----------------
      ShStr := fieldLst[iShr];
      ShStr := delCommas(ShStr);
      // --- price --------------------
      PrStr := fieldLst[iPr];
      delete(PrStr, pos('$', PrStr), 1);
      PrStr := delCommas(PrStr);
      if (xStrToFloat(PrStr) = 0) then
        PrStr := '0.00';
      // --- conversion rate
      // amount
      AmtStr := fieldLst[iAmt];
      // --- Commission ---------------
      Commis := 0;
      try
        Shares := CurrToFloat(ShStr);
        if Shares < 0 then
          Shares := -Shares; // ABS
        Price := CurrToFloat(PrStr);
        if Price < 0 then
          Price := -Price; // ABS
        Amount := ABS(CurrToFloat(AmtStr));
        // 2021-04-13 MB - add code to handle $0 price
        if (Price < 0.0001) then
          Price := Amount / Shares
        else begin // only can do this if price, qty and amt all provided
          // 2019-04-29 MB - add code to handle Buy/Sell separately
          if ((oc = 'O') and (ls = 'L')) or ((oc = 'C') and (ls = 'S')) then // BUY
            Commis := ABS(Amount) - ABS(Shares * Price * mult)
          else // // SELL
            Commis := ABS(Shares * Price * mult) - ABS(Amount);
        end;
        // 2019-04-29 MB - removed ABS(Commis) because rebates are allowed per Jason D.
        // ------ set import record fields ------
        ImpTrades[R].it := TradeLogFile.Count + R;
        ImpTrades[R].DT := ImpDate;
        ImpTrades[R].tm := ImpTime;
        ImpTrades[R].oc := oc;
        ImpTrades[R].ls := ls;
        ImpTrades[R].tk := tick;
        ImpTrades[R].sh := Shares;
        ImpTrades[R].pr := Price;
        ImpTrades[R].prf := typeStr;
        ImpTrades[R].cm := Commis;
        ImpTrades[R].am := Amount;
      except
        // DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        dec(R);
        Continue;
      end;
    end; // while
    // --------------------------------
    if cancels then begin
      for i := 1 to R do begin
        if (ImpTrades[i].oc <> 'X') then
          Continue; // not a cancel
        StatBar('Matching Cancelled Trades: ' + IntToStr(i));
        for j := (i + 2) downto 1 do begin // NOTE: CANCEL can come before OR after trade to cancel
          if (i = j) then
            Continue; // can't match itself!
          if j > R then
            Continue; // don't go out of bounds
          if (ImpTrades[i].tk <> ImpTrades[j].tk) then
            Continue; // not same ticker
          // could be a match, let's check the rest...
          if (compareValue(ABS(ImpTrades[i].sh), ABS(ImpTrades[j].sh), 0.0001) <> 0) then
            Continue; // shares don't match
          if (compareValue(ABS(ImpTrades[i].pr), ABS(ImpTrades[j].pr), 0.0001) <> 0) then
            Continue; // prices don't match
          if (compareValue(ABS(ImpTrades[i].am), ABS(ImpTrades[j].am), 0.0001) <> 0) then
            Continue; // amounts don't match
          if (ImpTrades[i].prf = ImpTrades[j].prf) //
            and (ImpTrades[j].oc <> '') then begin
            glNumCancelledTrades := glNumCancelledTrades + 2;
            // --- I ---
            ImpTrades[i].oc := '';
            ImpTrades[i].ls := '';
            ImpTrades[i].tm := '';
            // --- J ---
            ImpTrades[j].oc := '';
            ImpTrades[j].ls := '';
            ImpTrades[j].tm := '';
            break;
          end; // if everything else matches
        end; // for j = 1 downto
      end; // for i = 1 to R
    end; // if cancels
    // --------------------------------
    ImpStrList.Destroy;
    ReverseImpTradesDate(R);
    result := R;
  finally
    // readJPMorganChaseCSV
  end;
end;


function readJPMorganChase(): integer;
var
  R : integer;
begin
  // readJPMorganChase
  try
    R := 0;
    ImpStrList := TStringList.Create;
    ImpTrades := nil;
    setLength(ImpTrades, R + 1);
    GetImpDateLast;
    if FileExists(Settings.ImportDir + '\download.csv') then
      deleteFile(Settings.ImportDir + '\download.csv');
    GetImpStrListFromFile('JP Morgan', 'csv', '');
    result := ReadJPMorganChaseCSV(ImpStrList);
    exit;
  finally
    // ReadJPMorganChase
  end;
end;


// ------------------------------------
//
// ------------------------------------

function ReadJPR(): integer;
var
  i, j, R : integer;
  ImpDate, PrStr, prfStr, AmtStr, ShStr, line, sep : string;
  Shares, Amount, Commis : double;
  ImpNextDateOn, TrCorrected : boolean;
  oc, ls : string;
begin
  // rj Logger.EnterMethod('ReadJPR');
  try
    R := 0;
    DataConvErrRec := '';
    DataConvErrStr := '';
    TrCorrected := false;
    ImpNextDateOn := false;
    ImpStrList := TStringList.Create;
    ImpTrades := nil;
    setLength(ImpTrades, R + 1);
    GetImpDateLast;
    GetImpStrListFromClip(false);
    if ImpStrList.Count < 1 then begin
      ImpStrList.Destroy;
      result := 0;
      exit;
    end;
    for i := 0 to ImpStrList.Count - 1 do begin
      inc(R);
      if R < 1 then
        R := 1;
      sep := ' ';
      line := trim(ImpStrList[i]);
      { Long/Short }
      if (pos('Margin Short', line) > 0) then begin
        ls := 'S';
        delete(line, 1, pos('Margin Short', line) + 12);
        line := trim(line);
      end
      else if (pos('Margin', line) > 0) then begin
        ls := 'L';
        delete(line, 1, pos(sep, line));
        line := trim(line);
      end
      else if (pos('Short', line) > 0) then begin
        ls := 'S';
        delete(line, 1, pos(sep, line));
        line := trim(line);
      end
      else begin
        dec(R);
        if (i = ImpStrList.Count - 1) and (R = 0) then begin
          sm('JPR Import Error' + cr + cr + 'Either no trades are present in report' + cr //
              + cr //
              + 'or report is not selected properly');
          result := 0;
          exit;
        end;
        Continue;
      end;
      ImpDate := LongDateStr(trim(copy(line, 1, pos(sep, line))));
      if not ValidTradeDate(ImpDate, ImpDateLast, ImpNextDateOn) then begin
        dec(R);
        Continue;
      end;
      delete(line, 1, pos(sep, line));
      line := trim(line);
      { Open/Close }
      line := uppercase(line);
      oc := line;
      if pos('CANCEL', oc) > 0 then begin
        TrCorrected := true;
        oc := 'O';
        ls := 'L';
        delete(line, 1, pos('CANCEL', line) + 6);
      end
      else if pos('BUY TO COVER SHORT', oc) > 0 then begin
        oc := 'C';
        ls := 'S';
        delete(line, 1, pos('BUY TO COVER SHORT', line) + 18);
      end
      else if pos('SELL SHORT', oc) > 0 then begin
        oc := 'O';
        ls := 'S';
        delete(line, 1, pos('SELL SHORT', line) + 10);
      end
      else if pos('SELL', oc) > 0 then begin
        oc := 'C';
        ls := 'L';
        delete(line, 1, pos('SELL', line) + 4);
      end
      else if pos('BUY', oc) > 0 then begin
        oc := 'O';
        ls := 'L';
        delete(line, 1, pos('BUY', line) + 3);
      end;
      line := trim(line);
      // sm(line);
      // continue;
      { ticker }
      // added line below to get rid of space before "OLD"
      if pos(' OLD', line) > 0 then
        delete(line, pos(' OLD', line), 1);
      tick := trim(copy(line, 1, pos(sep, line)));
      while pos('.', tick) > 0 do
        delete(tick, pos('.', tick), 1);
      delete(line, 1, pos(sep, line));
      line := trim(line);
      { shares }
      // delete executed
      delete(line, 1, pos(sep, line));
      line := trim(line);
      ShStr := trim(copy(line, 1, pos('.', line) - 1));
      ShStr := DelParenthesis(ShStr);
      ShStr := delCommas(ShStr);
      // ShStr:= Del1000SepEx(ShStr,ImportFmt);
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // delete prior qty
      delete(line, 1, pos(sep, line));
      line := trim(line);
      { price }
      if pos('/', line) > 0 then begin
        PrStr := trim(copy(line, 1, pos(sep, line)));
        delete(line, 1, pos(sep, line));
        line := trim(line);
        if pos('/', line) > 0 then begin
          PrStr := PrStr + ' ' + trim(copy(line, 1, pos(sep, line)));
          delete(line, 1, pos(sep, line));
          line := trim(line);
        end;
      end
      else begin
        PrStr := trim(copy(line, 1, pos(sep, line)));
        delete(line, 1, pos(sep, line));
        line := trim(line);
      end;
      { amount }
      AmtStr := trim(copy(line, 1, pos(sep, line)));
      AmtStr := delCommas(AmtStr);
      // AmtStr:= Del1000SepEx(AmtStr,ImportFmt);
      // sm(impdate+tab+OC+LS+tab+ShStr+tab+tick+tab+prstr+tab+amtstr);
      // continue;
      prfStr := 'STK-1';
      try
        ImpTrades[R].it := TradeLogFile.Count + R;
        ImpTrades[R].DT := ImpDate;
        ImpTrades[R].tm := '';
        ImpTrades[R].oc := oc;
        ImpTrades[R].ls := ls;
        ImpTrades[R].tk := tick;
        Shares := StrToFloat(ShStr, Settings.InternalFmt);
        // Shares:= StrToFloat(ShStr,ImportFmt);
        if Shares < 0 then
          Shares := -Shares;
        ImpTrades[R].sh := Shares;
        Price := FracDecToFloat(PrStr);
        // Price:= FracDecToFloatEx(PrStr,ImportFmt);
        ImpTrades[R].pr := Price;
        ImpTrades[R].prf := prfStr;
        Amount := CurrToFloat(AmtStr);
        if Amount < 0 then Amount := -Amount;
        ImpTrades[R].am := Amount;
        Commis := Amount - (Shares * Price);
        if Commis < 0 then Commis := -Commis; // always positive?
        ImpTrades[R].cm := Commis;
        if TrCorrected then begin
          for j := 1 to R do
            with ImpTrades[j] do begin
              if (j = R) then begin
                sm('Cancel trade for ' + ImpTrades[R].tk + ' dated ' + ImpTrades[R].DT + cr //
                  + 'NOT Matched and NOT imported' + cr //
                  + cr //
                  + 'Please find the original trade and delete it!');
              end;
              if (tk = ImpTrades[R].tk) and (pr = ImpTrades[R].pr) and (am = ImpTrades[R].am) and
                (sh = ImpTrades[R].sh) then begin
                // added to catch all corrections
                ImpTrades[j].it := 0;
                ImpTrades[j].tr := 0;
                ImpTrades[j].oc := '';
                ImpTrades[j].ls := '';
                ImpTrades[j].tk := '';
                ImpTrades[j].sh := 0;
                ImpTrades[j].pr := 0;
                ImpTrades[j].cm := 0;
                dec(R);
                TrCorrected := false;
                break;
              end;
            end;
        end;
      except
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        dec(R);
        Continue;
      end;
      { comm }
    end;
    ReverseImpTradesDate(R);
    ImpStrList.Destroy;
    result := R;
  finally
    // ReadJPR
  end;
end; // ReadJPR


function ReadPenson2(): integer;
var
  C, i, j, p, R : integer;
  Commis : double;
  ImpFile : textfile;
  junk, line, ImpDate, TimeStr, ShStr, PrStr, AmtStr, CmStr, NextDate, optTick, strike, exDay,
    exMon, exYr, putCall, underTick, s : string;
  Fees, mult : double;
  TrCorrected, contracts, miniOptions, futures, ImpNextDateOn : boolean;
  oc, ls : string;
begin
  // is this APEX???
  DataConvErrRec := '';
  DataConvErrStr := '';
  Commis := 0;
  R := 0;
  TrCorrected := false;
  CorrectedTrades := 0;
  ImpNextDateOn := false;
  TimeStr := '';
  Penson2 := true;
  for i := 0 to ImpStrList.Count - 1 do begin
    futures := false;
    inc(R);
    if R < 1 then
      R := 1;
    line := ImpStrList[i];
    // delete all quotes
    while pos('"', line) > 0 do begin
      delete(line, pos('"', line), 1);
    end;
    // futures
    if (pos('Futures', line) > 0) or (pos('Index Based', line) > 0) then
      futures := true;
    // add extra comma if no comma exists
    if (pos('Index Based', line) > 0) and (pos('Index Based,', line) = 0) then
      line := line + ',';
    // Long/Short
    if trim(copy(line, 1, pos(',', line) - 1)) = 'Short' then
      ls := 'S'
    else
      ls := 'L';
    // impdate
    ImpDate := trim(copy(line, 1, pos(',', line) - 1));
    if (pos('/', ImpDate) <> 2) and (pos('/', ImpDate) <> 3) then begin
      dec(R);
      Continue;
    end;
    { Todd Flora - Add Locale Parameter
      Old Line: if not IsLongDateEx(impDate,Settings.InternalFmt) then begin }
    if not IsLongDateEx(ImpDate, Settings.InternalFmt, EnglishUS) then begin
      ImpDate := LongDateStr(ImpDate);
    end;
    delete(line, 1, pos(',', line));
    ImpDate := LongDateStr(ImpDate);
    if not ValidTradeDate(ImpDate, ImpDateLast, ImpNextDateOn) then begin
      dec(R);
      Continue;
    end;
    ImpTrades[R].DT := ImpDate;
    // del AccountTypeDescription
    delete(line, 1, pos(',', line));
    // Open/Close
    oc := copy(line, 1, pos(',', line) - 1);
    if oc = 'Qualified Dividend' then begin
      dec(R);
      Continue;
    end
    else if oc = 'BTO' then begin
      oc := 'O';
      ls := 'L';
      contracts := true;
    end
    else if oc = 'STO' then begin
      oc := 'O';
      ls := 'S';
      contracts := true;
    end
    else if oc = 'BTC' then begin
      oc := 'C';
      ls := 'S';
      contracts := true;
    end
    else if oc = 'STC' then begin
      oc := 'C';
      ls := 'L';
      contracts := true;
    end
    /// ////////////////////////////
    else if ls = 'L' then begin
      if (oc = 'B') then begin
        oc := 'O';
      end
      else if (oc = 'C') then begin
        oc := 'X';
        TrCorrected := true;
      end
      else if (oc = 'S') then begin
        oc := 'C';
      end
      else if (oc = 'T') then begin
        oc := 'X';
        TrCorrected := true;
      end
      else begin
        dec(R);
        Continue;
      end;
    end
    else if ls = 'S' then begin
      if (oc = 'B') then begin
        oc := 'C';
      end
      else if (oc = 'C') then begin
        oc := 'X';
        TrCorrected := true;
      end;
      if (oc = 'S') then begin
        oc := 'O';
      end
      else if (oc = 'T') then begin
        oc := 'X';
        TrCorrected := true;
      end
      else begin
        dec(R);
        Continue;
      end;
    end
    else begin
      dec(R);
      Continue;
    end;
    delete(line, 1, pos(',', line));
    // Symbol, Cusip
    if (pos(',Call,', line) > 0) or (pos(',Put,', line) > 0) then
      contracts := true
    else
      contracts := false;
    miniOptions := false; // default
    if contracts then begin
      optTick := copy(line, 1, pos(',', line) - 1);
      while pos(' ', optTick) > 0 do
        delete(optTick, pos(' ', optTick), 1);
      if rightStr(optTick, 1) = '7' then
        miniOptions := true;
    end
    else begin
      optTick := '';
      tick := copy(line, 1, pos(',', line) - 1);
    end;
    if contracts then begin
      underTick := copy(line, 1, pos(',', line) - 1);
      if (pos('.', underTick)= 1) then
        delete(underTick, 1, 1);
    end;
    // del Symbol
    delete(line, 1, pos(',', line));
    // del Cusip
    delete(line, 1, pos(',', line));
    // no ticker symbol - use ActivityDescription
    if (tick = '') and not contracts then
      tick := copy(line, 1, pos(',', line) - 1);
    // ActivityDescription
    // new options: NVS 2010 Jan 16 P @ 50.000
    if contracts then begin
      tick := trim(copy(line, 1, pos(',', line) - 1));
      optTick := tick;
      strike := parseLast(tick, ' ');
      strike := delTrailingZeros(strike);
      junk := parseLast(tick, '@');
      tick := trim(tick);
      putCall := parseLast(tick, ' ');
      if putCall = 'P' then
        putCall := 'PUT'
      else if putCall = 'C' then
        putCall := 'CALL';
      exDay := parseLast(tick, ' ');
      exMon := parseLast(tick, ' ');
      exYr := parseLast(tick, ' ');
      if length(exYr) = 4 then
        exYr := rightStr(exYr, 2);
      if underTick = '' then
        tick := trim(tick) + ' ' + exDay + exMon + exYr + ' ' + strike + ' ' + putCall
      else
        tick := trim(underTick) + ' ' + exDay + exMon + exYr + ' ' + strike + ' ' + putCall;
      // end if underTick
      if pos(' ''', tick) > 0 then
        delete(tick, pos(' ''', tick), 2);
      if pos('.00', tick) > 0 then
        delete(tick, pos('.00', tick), 3);
      if pos('.50', tick) > 0 then
        delete(tick, pos('.50', tick) + 2, 1);
    end;
    tick := uppercase(tick);
    // del  ActivityDescription
    delete(line, 1, pos(',', line));
    // del  SecuritySubDescription
    delete(line, 1, pos(',', line));
    // qty
    p := pos(',', line);
    ShStr := trim(copy(line, 1, p - 1));
    // 1-6-06 delete two decimals
    if pos('..', ShStr) > 0 then
      delete(ShStr, pos('..', ShStr), 1);
    delete(line, 1, p);
    // price
    p := pos(',', line);
    PrStr := copy(line, 1, p - 1);
    // delete two decimals
    if pos('..', PrStr) > 0 then
      delete(PrStr, pos('..', PrStr), 1);
    delete(line, 1, p);
    // del Currency
    delete(line, 1, pos(',', line));
    // del PrincipalAmount
    delete(line, 1, pos(',', line));
    // NetAmount
    AmtStr := copy(line, 1, pos(',', line) - 1);
    // delete two decimals
    if pos('..', AmtStr) > 0 then
      delete(AmtStr, pos('..', AmtStr), 1);
    // sm(Impdate+tab+TimeStr+tab+oc+ls+tab+tick+tab+shstr+tab+prstr+tab+amtstr);
    // continue;
    try
      Price := StrToFloat(PrStr, Settings.InternalFmt);
      Shares := StrToFloat(ShStr, Settings.InternalFmt);
      if Shares < 0 then
        Shares := -Shares;
      Amt := StrToFloat(AmtStr, Settings.InternalFmt);
      if Amt < 0 then
        Amt := -Amt;
      if contracts then
        if miniOptions then begin
          ImpTrades[R].prf := 'OPT-10';
          mult := 10;
        end
        else begin
          ImpTrades[R].prf := 'OPT-100';
          mult := 100;
        end
      else begin
        ImpTrades[R].prf := 'STK-1';
        mult := 1;
      end;
      if futures then begin
        // cmStr:= ParseLast(Line,',');
        CmStr := AmtStr;
        Commis := StrToFloat(CmStr, Settings.InternalFmt);
        if Commis < 0 then
          Commis := -Commis;
      end
      else begin
        // added 2-22-02 so that we import the Total Amt and backout the comm/fees/ecn
        if (oc = 'O') and (ls = 'L') then
          Commis := Amt - (Shares * Price * mult)
        else if (oc = 'C') and (ls = 'L') then
          Commis := (Shares * Price * mult) - Amt
        else if (oc = 'O') and (ls = 'S') then
          Commis := (Shares * Price * mult) - Amt
        else if (oc = 'C') and (ls = 'S') then
          Commis := Amt - (Shares * Price * mult);
      end;
      // sm(Impdate+tab+TimeStr+tab+oc+ls+tab+tick+tab+shstr+tab+prstr+tab+cmstr);
      ImpTrades[R].it := TradeLogFile.Count + R;
      ImpTrades[R].tr := 0;
      ImpTrades[R].DT := ImpDate;
      ImpTrades[R].tm := TimeStr;
      ImpTrades[R].oc := oc;
      ImpTrades[R].ls := ls;
      ImpTrades[R].tk := tick;
      ImpTrades[R].opTk := optTick;
      ImpTrades[R].sh := Shares;
      ImpTrades[R].pr := Price;
      ImpTrades[R].cm := Commis;
      ImpTrades[R].am := Amt;
    except
      DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
      dec(R);
      Continue;
    end;
  end;
  if TrCorrected then begin
    for i := 1 to R do begin
      if (ImpTrades[i].oc = 'X') then
        for j := R downto 1 do begin
          if (ImpTrades[i].tk = ImpTrades[j].tk) and (ImpTrades[i].DT = ImpTrades[j].DT) and
            (ImpTrades[i].tm = ImpTrades[j].tm) and (ImpTrades[i].ls = ImpTrades[j].ls) and
            (ImpTrades[i].sh = ImpTrades[j].sh) and
            (format('%1.5f', [ImpTrades[i].pr], Settings.UserFmt) = format('%1.5f',
              [ImpTrades[j].pr], Settings.UserFmt)) and (i <> j) then begin
            glNumCancelledTrades := glNumCancelledTrades + 2;
            ImpTrades[i].oc := '';
            ImpTrades[i].ls := '';
            ImpTrades[j].oc := '';
            ImpTrades[j].ls := '';
            break;
          end;
        end;
    end;
  end;
  for i := 1 to R do begin
    if ImpTrades[i].oc = 'X' then begin
      sm('CANCEL TRADES NOT MATCHED!' + cr + cr +
          'Cancel Trades have Open/Close marked with an "X"');
      break;
    end;
  end;
  StatBar('off');
  ImpStrList.Destroy;
  if R > 0 then
    ReverseImpTradesDate(R);
  result := R;
end; // ReadPenson2


// -------------------------
// also use this for Apex
// -------------------------
function ReadPenson(): integer;
var
  C, i, j, p, R : integer;
  Commis : double;
  ImpFile : textfile;
  junk, line, ImpDate, TimeStr, ShStr, PrStr, AmtStr, CmStr, NextDate, optTick, strike, exDay,
    exMon, exWk, exYr, putCall, underTick, s : string;
  Fees, mult : double;
  extraCols, TrCorrected, AcctNumFmt, TrailerFld, contracts, futures, ImpNextDateOn, cusipSymbol,
    delLastCol, newOptFormat, bracket, tagNum, ISIN, bApexActivity, bApexActiv2017 : boolean;
  oc, ls : string;
  lineLst : TStrings;
begin
  try
    // 2011-11-21 fix for eOption adding extra TagNumber column
    // 2010-12-20 updated for futures options
    StatBar('PLEASE WAIT - Importing trade history . . . ');
    DataConvErrRec := '';
    DataConvErrStr := '';
    Commis := 0;
    R := 0;
    TrCorrected := false;
    CorrectedTrades := 0;
    AcctNumFmt := false;
    TrailerFld := false;
    extraCols := false;
    delLastCol := false;
    cusipSymbol := false;
    ImpNextDateOn := false;
    tagNum := false;
    ISIN := false;
    bApexActivity := false;
    bMBTrading := false;
    bApexActiv2017 := false; // 2017-01-31 MB - new format Jan. 2017
    ImpStrList := TStringList.Create;
    ImpTrades := nil;
    setLength(ImpTrades, R + 1);
    GetImpDateLast;
    // ----------------------
    if bcImp then begin
      sleep(3000);
      GetImpStrListFromFile('', '', Settings.ImportDir + '\TOS-ExportData.txt')
    end
    else
      GetImpStrListFromFile('Apex', 'csv|txt', '');
    // ----------------------
    if ImpStrList.Count < 1 then begin
      ImpStrList.Destroy;
      result := 0;
      exit;
    end;
    // test for Apex Activities.csv file
    for i := 0 to ImpStrList.Count - 1 do begin
      if i > 10 then
        break;
      line := ImpStrList[i];
      if (pos('"Type","Account","Trade Date","Settle Date","Tag #"', line) > 0) then begin
        bApexActivity := true;
        break;
      end
      else if (pos('AccountNumber,AccountTypeDescription,OfficeCode,', line)= 1) then begin
        bMBTrading := true;
        break;
      end
      // 2017-01-31 MB - New Format
      else if (pos('Type,Trade Date,Settle Date,Symbol,Description', line)= 1) //
        or (pos('"Type","Trade Date","Settle Date","Symbol","Description",', line)= 1) then begin
        bApexActiv2017 := true;
        break;
      end;
    end;
    // ----------------------
    if bApexActivity then begin
      result := ReadApexCSV();
      exit;
    end
    else if bMBTrading then begin
      result := ReadMBTradingCSV();
      exit;
    end
    else if bApexActiv2017 then begin // 2017-01-31 MB
      result := ReadApex2017();
      exit;
    end;
    // ----------------------
    for i := 0 to ImpStrList.Count - 1 do begin
      futures := false;
      newOptFormat := false;
      bracket := false;
      exDay := '';
      exWk := '';
      exMon := '';
      exYr := '';
      inc(R);
      if R < 1 then
        R := 1;
      line := ImpStrList[i];
      lineLst := ParseCSV(line);
      // delete all quotes
      while pos('"', line) > 0 do begin
        delete(line, pos('"', line), 1);
      end;
      // --------------------
      // test for other column format
      // TradeDate,AccountTypeDescription,TransactionType,Symbol,Cusip,ActivityDescription,SecuritySubDescription,Quantity,Price,Currency,PrincipalAmount,NetAmount,TradeNumber
      junk := line;
      junk := parseLast(junk, ',');
      if (junk = 'TradeNumber') or (junk = 'TagNumber') then begin
        result := ReadPenson2();
        exit;
      end;
      // --------------------
      junk := line;
      if (pos(',TagNumber,', junk) > 0) then
        tagNum := true;
      if (pos(',ISIN,', junk) > 0) then
        ISIN := true;
      // futures
      if (pos('Futures', line) > 0) or (pos('Index Based', line) > 0) then
        futures := true;
      // investrade
      if pos('Cusip,Symbol', line) > 0 then
        cusipSymbol := true;
      // add extra comma if no comma exists
      if (pos('Index Based', line) > 0) and (pos('Index Based,', line) = 0) then
        line := line + ',';
      // Long/Short
      if trim(copy(line, 1, pos(',', line) - 1)) = 'Short' then
        ls := 'S'
      else
        ls := 'L';
      if (pos('AccountNumber', line) > 0) or (pos('AccountTypeDescription', line) > 0) then
        AcctNumFmt := true;
      // delete acct no fld
      if AcctNumFmt then begin
        delete(line, 1, pos(',', line));
      end;
      // added 10-13-05 for new MB Trading Trade Activity report format
      if pos('ProcessDate,SecurityTypeCategoryDescription,Trailer', line) > 0 then begin
        extraCols := true;
      end
      else if pos('Trailer', line) > 0 then begin
        TrailerFld := true;
      end;
      if pos('EntryDate', line) > 0 then begin
        delLastCol := true;
      end;
      // delete extra columns
      if extraCols then begin
        junk := parseLast(line, ','); // trailer
        junk := parseLast(line, ','); // SecurityTypeCategoryDescription
        junk := parseLast(line, ','); // ProcessDate
      end;
      // new Cybertrader? 2-24-07
      if delLastCol then begin
        junk := parseLast(line, ','); // EntryDate
      end;
      if TrailerFld then begin
        junk := parseLast(line, ','); // TrailerFld
      end;
      // impdate
      ImpDate := trim(copy(line, 1, pos(',', line) - 1));
      if (pos('/', ImpDate) <> 2) and (pos('/', ImpDate) <> 3) then begin
        dec(R);
        Continue;
      end;
      delete(line, 1, pos(',', line));
      if not IsLongDateEx(ImpDate, Settings.InternalFmt, EnglishUS) then begin
        ImpDate := LongDateStr(ImpDate);
      end;
      ImpDate := LongDateStr(ImpDate);
      if not ValidTradeDate(ImpDate, ImpDateLast, ImpNextDateOn) then begin
        dec(R);
        Continue;
      end;
      ImpTrades[R].DT := ImpDate;
      // Delete settle date
      delete(line, 1, pos(',', line));
      // time
      p := pos(',', line);
      TimeStr := trim(copy(line, 1, p - 1));
      delete(line, 1, pos(',', line));
      TimeStr := TimeStr;
      if length(TimeStr) = 4 then
        TimeStr := TimeStr + '00';
      if (length(TimeStr) = 6) then
        TimeStr := copy(TimeStr, 1, 2) + ':' + copy(TimeStr, 3, 2) + ':' + copy(TimeStr, 5, 2);
      // del TrNum
      delete(line, 1, pos(',', line));
      // del TagNumber
      if tagNum then
        delete(line, 1, pos(',', line));
      // CUSIP ticker
      if (pos(' CALL,', line) > 0) or (pos(' PUT,', line) > 0) or (pos(' @ ', line) > 0) or
        (pos('[', line) = 1) or (pos(']', line) = 1) then
        contracts := true
      else
        contracts := false;
      //
      if (pos(' CALL,', line) = 0) and (pos(' PUT,', line) = 0) and (pos(' @ ', line) > 0) then
        newOptFormat := true
      else
        newOptFormat := false;
      //
      if newOptFormat then begin
        optTick := copy(line, 1, pos(',', line) - 1);
        while pos(' ', optTick) > 0 do
          delete(optTick, pos(' ', optTick), 1);
      end
      else begin
        optTick := '';
        if not contracts then begin
          if cusipSymbol then
            delete(line, 1, pos(',', line));
          tick := copy(line, 1, pos(',', line) - 1);
        end
        // [ZB0H1200 = call   ]ZB0H1120 = put
        // [ZB0H1200 = ZBH0 120.0 calls
        // [9CW20X1210 = weekly futures option - W2 = week 2
        // test for brackets
        else if (pos('[', line) = 1) or (pos(']', line) = 1) then begin
          bracket := true;
          s := copy(line, 1, pos(',', line) - 1);
          // get strike
          strike := '';
          while isInt(rightStr(s, 1)) do begin
            strike := rightStr(s, 1) + strike;
            delete(s, length(s), 1);
          end;
          // delete 1 digit 1200 = 120
          // delete(strike,length(strike),1);
          // get expire month
          exMon := rightStr(s, 1);
          delete(s, length(s), 1);
          exMon := getFutExpMonth(exMon);
          // exMon:= getExpMonth(exMon);
          // test for weekly options  [9C W2 0 X1210
          exWk := rightStr(s, 3);
          if leftStr(exWk, 1) = 'W' then begin
            exYr := rightStr(s, 1);
            delete(s, length(s), 1);
            exYr := '1' + exYr;
            exWk := rightStr(s, 1);
            delete(s, length(s), 1);
            // delete the 'W'
            delete(s, length(s), 1);
          end
          else begin
            exWk := '';
            // get expire year
            exYr := rightStr(s, 1);
            delete(s, length(s), 1);
            if exYr < '8' then
              exYr := '1' + exYr
            else
              exYr := '0' + exYr;
          end;
          if exWk <> '' then begin
            // change week number to day
            exDay := getExDayFromWeek(exWk, exMon, exYr);
          end;
          if rightStr(s, 1) = 'O' then // O for option
            delete(s, length(s), 1);
          // call/put
          if leftStr(s, 1) = '[' then begin
            delete(s, 1, 1);
            tick := s + ' ' + exDay + exMon + exYr + ' ' + strike + ' CALL';
          end
          else if leftStr(s, 1) = ']' then begin
            delete(s, 1, 1);
            tick := s + ' ' + exDay + exMon + exYr + ' ' + strike + ' PUT';
          end;
        end
        else begin
          optTick := copy(line, 1, pos(',', line) - 1);
          while pos(' ', optTick) > 0 do
            delete(optTick, pos(' ', optTick), 1);
        end;
      end;
      if cusipSymbol then
        delete(line, 1, pos(',', line));
      if (cusipSymbol and contracts) or not cusipSymbol then begin
        underTick := copy(line, 1, pos(',', line) - 1);
        if (pos('.', underTick) = 1) then begin
          // cusipSymbol = ".SPX"
          delete(underTick, pos('.', underTick), 1); // delete period
        end
        else
          underTick := '';
        delete(line, 1, pos(',', line)); // delete symbol

      end;
      if ISIN then
        delete(line, 1, pos(',', line)); // delete ISIN
      // description
      // new options: NVS 2010 Jan 16 P @ 50.000
      // old options: GS Jul '07 @ 210.00 CALL
      if newOptFormat then begin
        tick := trim(copy(line, 1, pos(',', line) - 1));
        optTick := tick;
        strike := parseLast(tick, ' ');
        strike := delTrailingZeros(strike);
        junk := parseLast(tick, '@');
        tick := trim(tick);
        putCall := parseLast(tick, ' ');
        if putCall = 'P' then
          putCall := 'PUT'
        else if putCall = 'C' then
          putCall := 'CALL';
        // expiration date
        exDay := parseLast(tick, ' ');
        if length(exDay) = 1 then
          exDay := '0' + exDay;
        exMon := parseLast(tick, ' ');
        // test for space ie: missing ticker  "2012" vs "SPY 2012"
        if (pos(' ', tick)> 0) then
          exYr := parseLast(tick, ' ')
        else
          exYr := tick;
        if length(exYr) = 4 then
          exYr := rightStr(exYr, 2);
        // ticker
        if (underTick = '') or (isInt(copy(underTick, 2, 2))) then
          tick := trim(tick) + ' ' + exDay + exMon + exYr + ' ' + strike + ' ' + putCall
        else
          tick := trim(underTick) + ' ' + exDay + exMon + exYr + ' ' + strike + ' ' + putCall;
      end
      else if contracts and not bracket then begin
        tick := trim(copy(line, 1, pos(',', line) - 1));
        if pos('*', tick) > 0 then
          delete(tick, pos('*', tick), 1);
        if pos('@ ', tick) > 0 then
          delete(tick, pos('@ ', tick), 2);
        // changed 2009-01-26 for 2010 and above options
        if pos(' ''', tick) > 0 then
          delete(tick, pos(' ''', tick), 2);
        if pos('.00', tick) > 0 then
          delete(tick, pos('.00', tick), 3);
        if pos('.50', tick) > 0 then
          delete(tick, pos('.50', tick) + 2, 1);
      end;
      tick := uppercase(tick);
      // del  Desc
      delete(line, 1, pos(',', line));
      // Open/Close
      oc := copy(line, 1, pos(',', line) - 1);
      // added 11-25-03 for option trades
      if oc = 'BTO' then begin
        oc := 'O';
        ls := 'L';
        contracts := true;
      end
      else if oc = 'STO' then begin
        oc := 'O';
        ls := 'S';
        contracts := true;
      end
      else if oc = 'BTC' then begin
        oc := 'C';
        ls := 'S';
        contracts := true;
      end
      else if oc = 'STC' then begin
        oc := 'C';
        ls := 'L';
        contracts := true;
      end
      else if ls = 'L' then begin
        if (oc = 'B') then begin
          oc := 'O';
        end
        else if (oc = 'C') then begin
          oc := 'X';
          TrCorrected := true;
        end
        else if (oc = 'S') then begin
          oc := 'C';
        end
        else if (oc = 'T') then begin

          oc := 'X';
          TrCorrected := true;
        end;
      end
      else if ls = 'S' then begin
        if (oc = 'B') then begin
          oc := 'C';
        end
        else if (oc = 'C') then begin
          oc := 'X';
          TrCorrected := true;
        end;
        if (oc = 'S') then begin
          oc := 'O';
        end
        else if (oc = 'T') then begin
          oc := 'X';
          TrCorrected := true;
        end;
      end;
      delete(line, 1, pos(',', line));
      // qty
      p := pos(',', line);
      ShStr := trim(copy(line, 1, p - 1));
      // 1-6-06 delete two decimals
      if pos('..', ShStr) > 0 then
        delete(ShStr, pos('..', ShStr), 1);
      delete(line, 1, p);
      // price
      p := pos(',', line);
      PrStr := copy(line, 1, p - 1);
      // 1-6-06 delete two decimals
      if pos('..', PrStr) > 0 then
        delete(PrStr, pos('..', PrStr), 1);
      delete(line, 1, p);
      junk := parseLast(line, ','); // del CurrCode
      // amt
      AmtStr := parseLast(line, ',');
      if pos('..', AmtStr) > 0 then
        delete(AmtStr, pos('..', AmtStr), 1);
      try
        Price := StrToFloat(PrStr, Settings.InternalFmt);
        Shares := StrToFloat(ShStr, Settings.InternalFmt);
        if Shares < 0 then
          Shares := -Shares;
        Amt := StrToFloat(AmtStr, Settings.InternalFmt);
        if Amt < 0 then
          Amt := -Amt;
        if contracts then begin
          ImpTrades[R].prf := 'OPT-100';
          mult := 100;
        end
        else begin
          ImpTrades[R].prf := 'STK-1';
          mult := 1;
        end;
        //
        if futures then begin
          // cmStr:= ParseLast(Line,',');
          CmStr := AmtStr;
          Commis := StrToFloat(CmStr, Settings.InternalFmt);
          if Commis < 0 then
            Commis := -Commis;
          tick := formatFut(tick);
          ImpTrades[R].prf := futuresMult(tick, '', TradeLogFile.CurrentBrokerID);
        end
        else begin
          // added 2-22-02 so that we import the Total Amt and backout the comm/fees/ecn
          if (oc = 'O') and (ls = 'L') then
            Commis := Amt - (Shares * Price * mult)
          else if (oc = 'C') and (ls = 'L') then
            Commis := (Shares * Price * mult) - Amt
          else if (oc = 'O') and (ls = 'S') then
            Commis := (Shares * Price * mult) - Amt
          else if (oc = 'C') and (ls = 'S') then
            Commis := Amt - (Shares * Price * mult);
        end;
        ImpTrades[R].it := TradeLogFile.Count + R;
        ImpTrades[R].tr := 0;
        ImpTrades[R].DT := ImpDate;
        ImpTrades[R].tm := TimeStr;
        ImpTrades[R].oc := oc;
        ImpTrades[R].ls := ls;
        ImpTrades[R].tk := tick;
        ImpTrades[R].opTk := optTick;
        ImpTrades[R].sh := Shares;
        ImpTrades[R].pr := Price;
        ImpTrades[R].cm := Commis;
        ImpTrades[R].am := Amt;
      except
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        dec(R);
        Continue;
      end;
    end;
    // ------------
    if TrCorrected then begin
      for i := 1 to R do begin
        if (ImpTrades[i].oc = 'X') then
          for j := R downto 1 do begin
            if (ImpTrades[i].tk = ImpTrades[j].tk) and (ImpTrades[i].DT = ImpTrades[j].DT) and
              (ImpTrades[i].tm = ImpTrades[j].tm) and (ImpTrades[i].ls = ImpTrades[j].ls) and
              (ImpTrades[i].sh = ImpTrades[j].sh) and
              (format('%1.5f', [ImpTrades[i].pr], Settings.UserFmt) = format('%1.5f',
                [ImpTrades[j].pr], Settings.UserFmt)) and (i <> j) then begin
              glNumCancelledTrades := glNumCancelledTrades + 2;
              ImpTrades[i].oc := '';
              ImpTrades[i].ls := '';
              ImpTrades[j].oc := '';
              ImpTrades[j].ls := '';
              break;
            end;
          end;
      end;
    end;
    // ------------
    for i := 1 to R do begin
      if ImpTrades[i].oc = 'X' then begin
        sm('CANCEL TRADES NOT MATCHED!' + cr + cr +
            'Cancel Trades have Open/Close marked with an "X"');
        break;
      end;
    end;
    StatBar('off');
    ImpStrList.Destroy;
    if R > 0 then
      SortImpByDate(R);
    result := R;
  finally
    // ReadPenson
  end;
end;


// ------------------------------------
// ------------------------------------
function ReadPershingXLS : integer;
var
  i, j, k, R, numFields : integer;
  iDt, iOC, iLS, iTk, iCu, iAm, iSh, iPr, iCm, iMu : integer; // import field numbers
  sTmp, line, junk, ImpDate, NextDate, //
    opTick, opUnder, opStrike, opYr, opMon, opDay, opCP, sPr, sTyp, sMult, sAmt, sTick, sQty, sDes,
    sCom : string;
  oc, ls : string;
  Shares, Amount, Commis, mult, Amt2 : double;
  contracts, cancels, ImpNextDateOn, divReinv, bFoundHeader, bSkipAmtErr : boolean;
  fieldLst : TStrings; // for parsing individual lines
  sep : Char;
  // ----------------------------------
  procedure ClearFieldNumbers;
  begin
    iDt := 0;
    iTk := 0;
    iCu := 0;
    iOC := 0;
    iAm := 0;
    iSh := 0;
    iPr := 0;
    iCm := 0;
    iLS := 0;
    iMu := 0;
  end;
  // ----------------------------------
  procedure SetFieldNumbers;
  var
    j : integer;
  begin
    // find/map Pershing history fields
    k := 0;
    for j := 0 to (fieldLst.Count - 1) do begin
      if (fieldLst[j] = 'TRADE DATE') then begin
        iDt := j;
        k := k or 1;
      end
      else if (fieldLst[j] = 'SECURITY ID') then begin
        iTk := j;
        k := k or 2;
      end
      else if (fieldLst[j] = 'CUSIP') then begin
        iCu := j;
        k := k or 4;
      end
      else if (fieldLst[j] = 'DESCRIPTION') then begin // BUY or SELL
        iOC := j;
        k := k or 8;
      end
      else if (pos('NET AMOUNT', fieldLst[j]) = 1) then begin
        iAm := j;
        k := k or 16;
      end
      else if (fieldLst[j] = 'QUANTITY') then begin
        iSh := j;
        k := k or 32;
      end
      else if (pos('PRICE', fieldLst[j]) = 1) then begin
        iPr := j;
        k := k or 64;
      end
      else if (pos('COMMISSION/FEES', fieldLst[j]) = 1) then begin
        iCm := j;
        k := k or 128;
      end
      else if (pos('ACCOUNT TYPE', fieldLst[j]) = 1) then begin
        iLS := j;
        k := k or 256;
      end
      else if (pos('DETAILS', fieldLst[j]) = 1) then begin
        iMu := j;
        k := k or 512;
      end;
    end;
  end;
  // ----------------------------------
  function IsNum(s : string) : boolean;
  begin
    if pos('.', s) > 0 then
      delete(s, pos('.', s), 1);
    result := IsNumber(s);
  end;
  // ----------------------------------
  procedure DecodeOCLS(s1 : string; s2 : string);
  begin
    // note: sets variables OC and LS directly
    oc := '';
    if s2 = 'SHORT' then begin
      ls := 'S';
    end
    else begin
      ls := 'L';
    end;
    if s1 = 'SELL' then begin //
      if s2 = 'SHORT' then begin
        oc := 'O';
        ls := 'S';
      end
      else begin
        oc := 'C';
        ls := 'L';
      end;
    end
    else if s1 = 'BUY' then begin //
      if s2 = 'SHORT' then begin
        oc := 'C';
        ls := 'S';
      end
      else begin
        oc := 'O';
        ls := 'L';
      end;
    end
    else if s1 = 'BO' then begin // Buy to Open
      oc := 'O';
      ls := 'L';
    end
    else if s1 = 'SC' then begin // Sell to Cover
      oc := 'C';
      ls := 'L';
    end
    else if s1 = 'STOCK JOURNAL' then begin //
      oc := ''; // do not import
    end
    else if s1 = 'BUY CANCEL' then begin //
      oc := 'X';
      if s2 = 'SHORT' then begin
        ls := 'S';
      end
      else begin
        ls := 'L';
      end;
      cancels := true;
    end
    else if s1 = 'CO' then begin // Cancel Option
      oc := 'X';
      ls := 'L';
      cancels := true;
    end
    else if s1 = 'BC' then begin // Buy to Cover
      oc := 'C';
      ls := 'S';
    end
    else if s1 = 'SO' then begin // Sell to Open
      oc := 'O';
      ls := 'S';
    end
    else if s1 = 'OPTION_EXPIRATION' then begin
      oc := ''; // do not import
    end
    else if s1 = 'SELL CANCEL' then begin
      oc := 'X';
      if s2 = 'SHORT' then begin
        ls := 'S';
      end
      else begin
        ls := 'L';
      end;
      cancels := true;
    end
    else begin //
      oc := 'E';
      ls := 'L';
    end;
  end;
  // ------------------------
  function DecodeOptTk(var sTk : string) : string;
  var
    opTmp : string;
    n : integer;
  begin
    // Reset all local vars
    opTmp := sTk;
    opStrike := '';
    opYr := '';
    opMon := '';
    opDay := '';
    opCP := '';
    // ---------------------
    // ---------------------
    opStrike := parseLast(opTmp, ' ');
    opCP := parseLast(opTmp, ' ');
    if opCP = 'C' then
      opCP := 'CALL'
    else if opCP = 'P' then
      opCP := 'PUT'
    else
      exit('');
    opTmp := trim(opTmp);
    opMon := copy(opTmp, 1, 2);
    opMon := getExpMo(opMon);
    opDay := copy(opTmp, 3, 2);
    opYr := copy(opTmp, 7, 2); // just get last 2 digits
    opStrike := delTrailingZeros(opStrike); // for matching
    result := opDay + opMon + opYr + ' ' + opStrike + ' ' + opCP;
  end;
// --------------------------------
// --------------------------------
begin // ReadPershingXLS
  try
    bSkipAmtErr := false; // if they don't want to see any more
    Commis := 0;
    sep := TAB; // for Excel files
    ClearFieldNumbers;
    cancels := false;
    R := 0;
    GetImpDateLast;
    tick := 'ERROR';
    DataConvErrRec := '';
    DataConvErrStr := '';
    ImpNextDateOn := false;
    // --------------------------------
    if ImpStrList.Count < 1 then begin
      result := 0;
      exit;
    end;
    // --------------------------------
    bFoundHeader := false;
    // --------------------------------
    for i := 0 to (ImpStrList.Count - 1) do begin
      contracts := false;
      mult := 1; // default
      // ------------------------------
      line := ImpStrList[i];
      line := uppercase(line);
      if line = '' then Continue;
      if replacestr(line, ',', '') = '' then Continue;
      fieldLst := ParseCSV(line, sep); // try TAB first
      if (fieldLst.Count < iDt) then Continue; // bad record
      if not bFoundHeader then begin
        if (pos('DATE', line) > 0) //
        and (pos('QUANTITY', line) > 0) //
        and (pos('AMOUNT', line) > 0) //
        then begin
          if fieldLst.Count < 5 then Continue;
          SetFieldNumbers;
          numFields := fieldLst.Count;
          if SuperUser and (k <> 1023) then
            sm('there appear to be fields missing.');
          bFoundHeader := true; // don't do this anymore
          R := 0; // start now
        end;
        Continue; // don't process anything until we recognize the header
      end; // if not found header
      if fieldLst.Count > numFields then begin
        DataConvErrRec := DataConvErrRec + line + cr;
        Continue; // record has extra commas!
      end;
      // ------------------------------
      if pos('ERROR', line) > 0 then begin
        sm('The broker reported an error in the data.' + cr //
          + 'Please reduce the date range and try again.');
        result := 0;
        exit;
      end;
      // --------------------
      // [iDt] Trade Date
      sTmp := trim(fieldLst[iDt]);
      if (sTmp = '') then begin
        Continue // silently skip beginning blanks
      end;
      if not isdate(sTmp) then begin
        Continue; // go until first good line found.
      end;
      if not ValidTradeDate(sTmp, ImpDateLast, ImpNextDateOn) then
        Continue;
      ImpDate := sTmp;
      // --------------------
      // Ticker
      sTick := trim(fieldLst[iTk]); // ticker
      opTick := '';
      mult := 1;
      divReinv := false;
      junk := fieldLst[iMu];
      // --------------------
      // [iTyp] SecurityType
      sTyp := parsefirst(junk, ' ');
      sMult := parsefirst(junk, ' ');
      if IsNumeric(sMult) then
        mult := StrToFloat(sMult)
      else
        mult := 1;
      sMult := floattostr(mult);
      sMult := delTrailingZeros(sMult);
      if (sTyp = 'CALL') or (sTyp = 'PUT') then begin
        sTyp := 'OPT-' + sMult;
        contracts := true;
        junk := sTick;
        sTick := parsefirst(junk, ' ');
        junk := trim(junk);
        if length(junk) > 5 then //
          sTick := sTick + ' ' + DecodeOptTk(junk);
      end
      else begin
        sTyp := 'STK-' + sMult;
        contracts := false;
      end;
      // --------------------
      // OC, LS
      // --------------------
      ls := fieldLst[iLS];
      if (pos('SHORT', ls) = 1) then
        ls := 'S'
      else
        ls := 'L';
      // --------------------
      sTmp := fieldLst[iOC];
      if (pos('BUY', sTmp) = 1) //
      or (pos('CORR-BUY', sTmp) = 1) //
      then begin
        if ls = 'L' then
          oc := 'O'
        else
          oc := 'C';
      end
      else if (pos('SELL', sTmp) = 1) //
      or (pos('CORR-SELL', sTmp) = 1) //
      then begin
        if ls = 'L' then
          oc := 'C'
        else
          oc := 'O';
      end
      else if (pos('CXL-SELL', sTmp) = 1) //
      or (pos('CXL-BUY', sTmp) = 1) //
      then begin // cancel
        oc := 'X'; // cancel
        cancels := true;
      end
      else begin // beyond the scope of import
        if SuperUser then begin
          sm('Cannot determine if this trade is open or close:' + cr //
              + line);
          Continue; // skip the record if we can't tell which
        end; // if SuperUser
      end; // else unknown OC
      // --------------------
      inc(R); // get this far, count it.
      // --------------------
      try
        // #shares/contracts
        sQty := fieldLst[iSh];
        sQty := delCommas(sQty);
        if IsNum(sQty) then
          Shares := StrToFloat(sQty, Settings.InternalFmt)
        else if SuperUser then
          sm('ERROR importing #Shares:' + cr + sQty + ' is not a number');
        if Shares = 0 then begin
          dec(R);
          Continue;
        end;
        if Shares < 0 then
          Shares := -Shares;
        // ------------------
        // price
        sPr := fieldLst[iPr];
        delete(sPr, pos('$', sPr), 1);
        sPr := delCommas(sPr);
        if IsNum(sPr) then
          Price := StrToFloat(sPr, Settings.InternalFmt)
        else if SuperUser then
          sm('ERROR importing Price:' + cr + sPr + ' is not a number');
        // ------------------
        // comm
        sCom := fieldLst[iCm];
        delete(sCom, pos('$', sCom), 1);
        sCom := delCommas(sCom);
        if IsNum(sCom) then
          Commis := StrToFloat(sCom, Settings.InternalFmt)
        else if SuperUser then
          sm('ERROR importing Commission:' + cr + sCom + ' is not a number');
        if Commis < 0 then Commis := -Commis;
        // ------------------
        // amount
        sAmt := fieldLst[iAm];
        if (pos('$', sAmt) > 0) then
          delete(sAmt, pos('$', sAmt), 1);
        sAmt := delCommas(sAmt);
        if (sAmt = '') or (pos('*', sAmt) > 0) then
          sAmt := '0.00';
        if (leftStr(sAmt, 1)= '(') and (rightStr(sAmt, 1)= ')') then
          sAmt := '-' + copy(sAmt, 2, length(sAmt)- 2); // chg neg from "()" to "-"
        if IsNum(sAmt) then
          Amount := CurrToFloat(sAmt)
        else if SuperUser then
          sm('ERROR importing Amount:' + cr + sAmt + ' is not a number')
        else begin
          Amount := Commis - (Shares * Price * mult); // last resort
        end;
        // ------------------
        // check for obvious errors:
        if ((oc = 'O') and (ls = 'L')) // BUY
          or (((oc = 'C') or (oc = 'M')) and (ls = 'S')) then
          Amt2 := -(Shares * Price * mult) - Commis
        else if (((oc = 'C') or (oc = 'M')) and (ls = 'L')) // SELL
          or ((oc = 'O') and (ls = 'S')) then
          Amt2 := (Shares * Price * mult) - Commis
        else if (oc = 'X') then
          Amt2 := Amount; // it's a cancel anyway
        // using amt = (qty*price*mult) - commis
        if ABS(Amount - Amt2) > ABS(0.1 * Amount) then
          DataConvErrRec := DataConvErrRec //
            + 'shares*price not even close to amount:' + CRLF //
            + floattostr(Shares) + ' * $' + floattostr(Price) //
            + ' >< $' + floattostr(Amount) + CRLF //
            + line + CRLF;
        // --------------------
        ImpTrades[R].it := TradeLogFile.Count + R;
        ImpTrades[R].DT := ImpDate;
        ImpTrades[R].oc := oc;
        ImpTrades[R].ls := ls;
        ImpTrades[R].tk := trim(sTick);
        ImpTrades[R].prf := sTyp;
        ImpTrades[R].sh := Shares;
        ImpTrades[R].pr := Price;
        ImpTrades[R].am := Amount;
        ImpTrades[R].cm := rndto2(Commis);
      except
        DataConvErrRec := DataConvErrRec + 'Error adding ' + ImpStrList[i] + CRLF;
        dec(R);
        Continue;
      end;
    end; // while
    // --------------------------------
    if R = 0 then begin
      result := -1;
      exit;
    end;
// if R <> High(ImpTrades) then
// sm('R = ' + IntToStr(R) + CRLF //
// + 'count = ' + IntToStr(High(ImpTrades)));
    // --------------------------------
    if R > 1 then begin // see if trades in reverse order
      if (xStrToDate(ImpTrades[1].DT) > xStrToDate(ImpTrades[R].DT)) then
        ReverseImpTradesDate(R);
      fixImpTradesOutOfOrder(R);
    end;
    // --------------------------------
    if cancels then begin // match cancels
      for i := 1 to R do begin
        if (ImpTrades[i].oc <> 'X') then
          Continue; // only looking for 'X'
        StatBar('Matching Cancelled Trades: ' + IntToStr(i));
        for j := 1 to R do begin // try to find cancelled trade
          if (ImpTrades[i].oc = 'X') //
            and (ImpTrades[j].oc <> 'X') // can't both be X
            and (ImpTrades[i].ls = ImpTrades[j].ls) //
            and (ImpTrades[i].tk = ImpTrades[j].tk) // same ticker
            and (ImpTrades[i].prf = ImpTrades[j].prf) // same type
            and (i <> j) then begin
            // --------------------
            if (ABS(ImpTrades[i].sh - ImpTrades[j].sh) < 0.00005) //
              and (ABS(ImpTrades[i].pr - ImpTrades[j].pr) < 0.00005) //
            then begin
              ImpTrades[i].oc := ''; // i
              ImpTrades[i].ls := '';
              ImpTrades[i].tm := '';
              ImpTrades[j].oc := ''; // j
              ImpTrades[j].ls := '';
              ImpTrades[j].tm := '';
              glNumCancelledTrades := glNumCancelledTrades + 2;
              break;
            end; // equal value
          end; // refers to same trade
        end; // for j
      end; // for i = 1 to R
    end; // if cancels
    // --------------------------------
    result := R;
  finally
    fieldLst.Free;
  end;
end; // ReadPershingXLS


function ReadPershing(): integer;
var
  ImpNextDateOn : boolean;
begin
  ImpNextDateOn := false;
  try
    ImpStrList := TStringList.Create;
    ImpTrades := nil;
    // ----------------------
    GetImpStrListFromFile('Pershing', 'xls?', '');
    // ----------------------
    if (sFileType = 'xls') or (sFileType = 'xlsx') then begin
      StatBar('Importing from Excel (XLS) file - PLEASE WAIT');
      result := ReadPershingXLS;
    end
    else begin
      result := 0;
      exit;
    end;
    // ------------------------
  finally
    ImpStrList.Destroy;
  end;
end; // ReadPershing


// ------------------------------------
// ------------------------------------
function ReadPreferred(): integer;
var
  i, hour, R : integer;
  ImpDate, PrStr, AmtStr, ShStr, line, optTick, sep, TimeStr, s, exYr : string;
  Amount, Commis, mult : double;
  contracts, futures : boolean;
  oc, ls : string;
  Year, Month, Day : Word;
begin
  try
    DataConvErrRec := '';
    DataConvErrStr := '';
    Amount := 0;
    mult := 0;
    R := 0;
    sep := '';
    ImpStrList := TStringList.Create;
    ImpTrades := nil;
    setLength(ImpTrades, R + 1);
    GetImpDateLast;
    GetImpStrListFromClip(false);
    if ImpStrList.Count < 1 then begin
      ImpStrList.Destroy;
      result := 0;
      exit;
    end;
    // test for separator - tab or comma
    for i := 0 to ImpStrList.Count - 1 do begin
      line := ImpStrList[i];
      if pos(TAB, line) > 0 then begin
        sep := TAB;
        break;
      end
      else if pos(',', line) > 0 then begin
        sep := ',';
        break;
      end;
    end;
    for i := 0 to ImpStrList.Count - 1 do begin
      contracts := false;
      TimeStr := '';
      line := ImpStrList[i];
      if pos(sep, line) <= 0 then
        Continue;
      inc(R);
      if R < 1 then
        R := 1;
      // date
      line := line + sep;
      ImpDate := copy(line, 1, pos(sep, line) - 1);
      ImpDate := trim(ImpDate);
      if (pos('/', ImpDate) <> 2) //
      and (pos('/', ImpDate) <> 3) //
      then begin
        dec(R);
        Continue;
      end;
      // time
      // add for futures
      if pos(':', ImpDate) > 0 then begin
        TimeStr := ImpDate;
        ImpDate := copy(ImpDate, 1, pos(' ', ImpDate) - 1);
        delete(TimeStr, 1, pos(' ', TimeStr));
        if pos(':', TimeStr) = 2 then
          TimeStr := '0' + TimeStr;
        if (pos('00:00:00', TimeStr) > 0) or (pos(':', TimeStr) = 0) then
          TimeStr := '';
        if pos(' AM', TimeStr) > 0 then
          delete(TimeStr, pos(' AM', TimeStr), 3);
        if pos(' PM', TimeStr) > 0 then begin
          delete(TimeStr, pos(' PM', TimeStr), 3);
          if (copy(TimeStr, 1, 2) = '12') then begin
            hour := strToInt(copy(TimeStr, 1, 2));
          end
          else
            hour := strToInt(copy(TimeStr, 1, 2)) + 12;
          delete(TimeStr, 1, 2);
          TimeStr := IntToStr(hour) + TimeStr;
        end;
      end;
      ImpDate := LongDateStr(ImpDate);
      if UserDateStrNotGreater(ImpDate, ImpDateLast) then
        if mDlg('Preferred Trades already imported for ' + ImpDate + cr + cr + 'Continue?',
          mtWarning, [mbNo, mbYes], 0) = mrNo then begin
          result := 0;
          exit;
        end
        else
          ImpDateLast := LongDateStr('01/01/1900');
      // delete(line,1,pos(' ',line));
      delete(line, 1, pos(sep, line));
      // delete acct number
      delete(line, 1, pos(sep, line));
      // ticker
      optTick := trim(copy(line, 1, pos(sep, line) - 1));
      delete(optTick, pos('/', optTick), 1);
      delete(line, 1, pos(sep, line));
      tick := trim(copy(line, 1, pos(sep, line) - 1));
      delete(line, 1, pos(sep, line));
      // sm(optTick+cr+tick);
      if tick <> optTick then begin
        DecodeDate(xStrToDate(ImpDate, Settings.UserFmt), Year, Month, Day);
        exYr := rightStr(IntToStr(Year), 2);
        s := optTick;
        if pos('DEC', s) > 0 then
          tick := tick + ' DEC' + exYr + ' ' + rightStr(s, length(s) - pos('DEC', s) - 2)
        else if pos('NOV', s) > 0 then
          tick := tick + ' NOV' + exYr + ' ' + rightStr(s, length(s) - pos('NOV', s) - 2)
        else if pos('OCT', s) > 0 then
          tick := tick + ' OCT' + exYr + ' ' + rightStr(s, length(s) - pos('OCT', s) - 2)
        else if pos('SEP', s) > 0 then
          tick := tick + ' SEP' + exYr + ' ' + rightStr(s, length(s) - pos('SEP', s) - 2)
        else if pos('AUG', s) > 0 then
          tick := tick + ' AUG' + exYr + ' ' + rightStr(s, length(s) - pos('AUG', s) - 2)
        else if pos('JUL', s) > 0 then
          tick := tick + ' JUL' + exYr + ' ' + rightStr(s, length(s) - pos('JUL', s) - 2)
        else if pos('JUN', s) > 0 then
          tick := tick + ' JUN' + exYr + ' ' + rightStr(s, length(s) - pos('JUN', s) - 2)
        else if pos('MAY', s) > 0 then
          tick := tick + ' MAY' + exYr + ' ' + rightStr(s, length(s) - pos('MAY', s) - 2)
        else if pos('APR', s) > 0 then
          tick := tick + ' APR' + exYr + ' ' + rightStr(s, length(s) - pos('APR', s) - 2)
        else if pos('MAR', s) > 0 then
          tick := tick + ' MAR' + exYr + ' ' + rightStr(s, length(s) - pos('MAR', s) - 2)
        else if pos('FEB', s) > 0 then
          tick := tick + ' FEB' + exYr + ' ' + rightStr(s, length(s) - pos('FEB', s) - 2)
        else if pos('JAN', s) > 0 then
          tick := tick + ' JAN' + exYr + ' ' + rightStr(s, length(s) - pos('JAN', s) - 2);
        s := rightStr(tick, 1);
        if s = 'C' then
          tick := leftStr(tick, length(tick) - 1) + ' CALL'
        else if s = 'P' then
          tick := leftStr(tick, length(tick) - 1) + ' PUT';
        tick := chgOptExpYr(tick, ImpDate);
        contracts := true;
      end;
      if pos('/', tick) > 0 then
        futures := true
      else
        futures := false;
      delete(tick, pos('/', tick), 1);
      try
        // shares
        ShStr := copy(line, 1, pos(sep, line) - 1);
        Shares := StrToFloat(ShStr, Settings.InternalFmt);
        if contracts then begin
          mult := 100;
          ImpTrades[R].prf := 'OPT-100';
        end
        else if futures then begin
          ImpTrades[R].prf := futuresMult(tick, '', TradeLogFile.CurrentBrokerID);
        end
        else begin
          mult := 1;
          ImpTrades[R].prf := 'STK-1';
        end;
        // open/close long/short
        if Shares < 0 then begin
          oc := 'C';
          Shares := -Shares;
        end
        else
          oc := 'O';
        ls := 'L';
        delete(line, 1, pos(sep, line));
        // price
        PrStr := copy(line, 1, pos(sep, line) - 1);
        Price := FracDecToFloat(PrStr);
        delete(line, 1, pos(sep, line));
        // amount
        AmtStr := trim(copy(line, 1, pos('.', line) + 2));
        AmtStr := delCommas(AmtStr);
        Amount := CurrToFloat(AmtStr);
        if Amount < 0 then
          Amount := -Amount;
        // time
        if TimeStr = '' then begin
          delete(line, 1, pos(sep, line));
          line := trim(line);
          TimeStr := trim(parseLast(line, sep));
          if (TimeStr = '00:00:00') or (pos(':', TimeStr) = 0) then
            TimeStr := '';
        end;
        ImpTrades[R].DT := ImpDate;
        ImpTrades[R].tm := TimeStr;
        ImpTrades[R].oc := oc;
        ImpTrades[R].ls := ls;
        ImpTrades[R].tk := tick;
        ImpTrades[R].sh := Shares;
        ImpTrades[R].pr := Price;
        ImpTrades[R].am := Amount;
      except
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        dec(R);
        Continue;
      end;
      { comm }
      if oc = 'O' then
        Commis := (Shares * Price * mult) - Amount
      else
        Commis := Amount - (Shares * Price * mult);
      if Commis < 0 then
        Commis := -Commis;
      ImpTrades[R].cm := Commis;
      ImpTrades[R].it := TradeLogFile.Count + R;
    end;
    ImpStrList.Destroy;
    ReverseImpTradesDate(R);
    result := R;
  finally
    // ReadPreferred
  end;
end;

         // ---------------------------
         // ProTrader
         // ---------------------------

function ReadProTraderOLD(FileName : string): integer;
var
  i, l, R, z, FldsIndex, LastFldsIndex : integer;
  ImpDate, TimeStr, CmStr, PrStr, prfStr, AmtStr, ShStr, line, sep, FldName : string;
  Shares, mult, Amount, Commis : double;
  contracts, ImpNextDateOn : boolean;
  Flds : TStringList;
  oc, ls : string;
begin
  try
    DataConvErrRec := '';
    DataConvErrStr := '';
    Amount := 0;
    Commis := 0;
    Shares := 0;
    R := 0;
    l := 0;
    ImpNextDateOn := false;
    ImpStrList := TStringList.Create;
    Flds := TStringList.Create;
    ImpTrades := nil;
    setLength(ImpTrades, R + 1);
    GetImpDateLast;
    GetImpDateLast;
    GetImpStrListFromFile('', '', FileName);
    sep := TAB;
    if ImpStrList.Count < 1 then begin
      ImpStrList.Destroy;
      result := 0;
      exit;
    end;
    for i := 0 to ImpStrList.Count - 1 do begin
      line := trim(ImpStrList[i]) + sep;
      // Get field names
      if i = 0 then begin
        while pos(sep, line) > 0 do begin
          FldName := trim(copy(line, 1, pos(sep, line)));
          // delete spaces
          while pos(' ', FldName) > 0 do
            delete(FldName, pos(' ', FldName), 1);
          Flds.Add(FldName);
          delete(line, 1, pos(sep, line));
        end;
        if (Flds.IndexOf('EntryDate') = -1) or (Flds.IndexOf('Quantity') = -1) or
          (Flds.IndexOf('Symbol') = -1) or (Flds.IndexOf('Action') = -1) or
          (Flds.IndexOf('Time') = -1) or (Flds.IndexOf('Price') = -1) or
          (Flds.IndexOf('NetMoney') = -1) or (Flds.IndexOf('SecurityDescription') = -1) then begin
          sm('IMPORT ERROR : MISSING FIELDS' + cr + cr //
              + 'THE FOLLOWING FIELDS MUST BE INCLUDED:' + cr + cr //
              + TAB + 'Entry Date' + cr //
              + TAB + 'Quantity' + cr //
              + TAB + 'Symbol' + cr //
              + TAB + 'Action' + cr //
              + TAB + 'Price' + cr //
              + TAB + 'Net Money' + cr //
              + TAB + 'Security Description');
          result := 0;
          exit;
        end;
        Continue;
      end;
      contracts := false;
      inc(R);
      if R < 1 then
        R := 1;
      line := trim(line);
      FldsIndex := Flds.IndexOf('EntryDate');
      LastFldsIndex := Flds.IndexOf('EntryDate');
      for z := 1 to FldsIndex do begin
        delete(line, 1, pos(sep, line));
      end;
      ImpDate := trim(copy(line, 1, pos(sep, line)));
      if (pos('/', ImpDate) = 0) then begin
        dec(R);
        if (i = ImpStrList.Count - 1) and (R = 0) then begin
          if ImpNextDateOn then begin
            sm('No transactions later than ' + ImpDateLast);
          end
          else begin
            DataConvErrRec := 'No Data Selected';
            sm('ETG Import Error' + cr + cr + 'Please reselect entire report');
          end;
          result := 0;
          exit;
        end;
        Continue;
      end;
      ImpDate := LongDateStr(ImpDate);
      if not ValidTradeDate(ImpDate, ImpDateLast, ImpNextDateOn) then begin
        dec(R);
        Continue;
      end;
      FldsIndex := Flds.IndexOf('Quantity') - LastFldsIndex;
      LastFldsIndex := Flds.IndexOf('Quantity');
      for z := 1 to FldsIndex do begin
        delete(line, 1, pos(sep, line));
      end;
      { shares }
      ShStr := trim(copy(line, 1, pos(sep, line) - 1));
      ShStr := DelParenthesis(ShStr);
      ShStr := delCommas(ShStr);
      // ShStr:= Del1000SepEx(ShStr,ImportFmt);
      FldsIndex := Flds.IndexOf('Symbol') - LastFldsIndex;
      LastFldsIndex := Flds.IndexOf('Symbol');
      for z := 1 to FldsIndex do begin
        delete(line, 1, pos(sep, line));
      end;
      { ticker }
      tick := copy(line, 1, pos(sep, line));
      tick := uppercase(tick);
      FldsIndex := Flds.IndexOf('Action') - LastFldsIndex;
      LastFldsIndex := Flds.IndexOf('Action');
      for z := 1 to FldsIndex do begin
        delete(line, 1, pos(sep, line));
      end;
      { oc }
      oc := trim(copy(line, 1, pos(sep, line)));
      if oc = 'B' then
        oc := 'O'
      else if oc = 'S' then
        oc := 'C';
      ls := 'L';
      FldsIndex := Flds.IndexOf('Time') - LastFldsIndex;
      LastFldsIndex := Flds.IndexOf('Time');
      for z := 1 to FldsIndex do begin
        delete(line, 1, pos(sep, line));
      end;
      { time }
      TimeStr := trim(copy(line, 1, pos(sep, line) - 1));
      if length(TimeStr) = 6 then
        TimeStr := copy(TimeStr, 1, 4)
      else if length(TimeStr) = 5 then
        TimeStr := copy(TimeStr, 1, 3);
      FldsIndex := Flds.IndexOf('Price') - LastFldsIndex;
      LastFldsIndex := Flds.IndexOf('Price');
      for z := 1 to FldsIndex do begin
        delete(line, 1, pos(sep, line));
      end;
      { price }
      PrStr := trim(copy(line, 1, pos(sep, line) - 1));
      FldsIndex := Flds.IndexOf('NetMoney') - LastFldsIndex;
      LastFldsIndex := Flds.IndexOf('NetMoney');
      for z := 1 to FldsIndex do begin
        delete(line, 1, pos(sep, line));
      end;
      { amount }
      AmtStr := copy(line, 1, pos(sep, line) - 1);
      { comm }
      FldsIndex := Flds.IndexOf('SecurityDescription') - LastFldsIndex;
      LastFldsIndex := Flds.IndexOf('SecurityDescription');
      for z := 1 to FldsIndex do begin
        delete(line, 1, pos(sep, line));
      end;
      // if tick is option get option symbol from SecDescr field
      if pChar(copy(tick, 1, 1)) = ' ' then begin
        contracts := true;
        if pos(sep, line) > 0 then
          tick := trim(copy(line, 1, pos(sep, line)))
        else
          tick := trim(line);
      end
      else
        contracts := false;
      tick := trim(tick);
      while pos('  ', tick) > 0 do
        delete(tick, pos('  ', tick), 1);
      try
        Shares := StrToFloat(ShStr, Settings.InternalFmt);
        if contracts then begin
          mult := 100;
          prfStr := 'OPT-100';
        end
        else begin
          mult := 1;
          prfStr := 'STK-1';
        end;
        if PrStr = '' then
          Price := 0
        else
          Price := FracDecToFloat(PrStr);
        Amount := CurrToFloat(AmtStr);
        if Amount < 0 then
          Amount := -Amount;
        if oc = 'O' then
          Commis := Amount - (Shares * Price * mult)
        else
          Commis := (Shares * Price * mult) - Amount;
      except
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        dec(R);
        Continue;
      end;
      ImpTrades[R].it := TradeLogFile.Count + R;
      ImpTrades[R].DT := ImpDate;
      ImpTrades[R].tm := TimeStr;
      ImpTrades[R].oc := oc;
      ImpTrades[R].ls := ls;
      ImpTrades[R].tk := tick;
      ImpTrades[R].sh := Shares;
      ImpTrades[R].pr := Price;
      ImpTrades[R].prf := prfStr;
      ImpTrades[R].am := Amount;
      ImpTrades[R].cm := Commis;
    end;
    StatBar('off');
    ImpStrList.Destroy;
    Flds.Destroy;
    result := R;
  finally
    // ReadProTraderOLD
  end;
end;


function ReadProTraderInstinet(FileName : string): integer;
var
  i, j, R : integer;
  ImpDate, TimeStr, CmStr, SECStr, PrStr, prfStr, AmtStr, NetAmtStr, ShStr, line, sep : string;
  Shares, Amount, Commis : double;
  contracts, ImpNextDateOn, Liquidity, ExecBroker, NetProceeds : boolean;
  oc, ls : string;
begin
  try
    // new Instinet reports 02-21/02
    DataConvErrRec := '';
    DataConvErrStr := '';
    Amount := 0;
    Commis := 0;
    Shares := 0;
    R := 0;
    ImpNextDateOn := false;
    Liquidity := false;
    ExecBroker := false;
    NetProceeds := false;
    ImpStrList := TStringList.Create;
    ImpTrades := nil;
    setLength(ImpTrades, R + 1);
    GetImpDateLast;
    GetImpStrListFromFile('', '', FileName);
    if pos(TAB, ImpStrList[0]) > 0 then
      sep := TAB
    else
      sep := ' ';
    if ImpStrList.Count < 1 then begin
      ImpStrList.Destroy;
      result := 0;
      exit;
    end;
    for i := 0 to ImpStrList.Count - 1 do begin
      line := trim(ImpStrList[i]) + sep;
      if pos('Liquidity', line) > 0 then
        Liquidity := true;
      if pos('ExecBroker', line) > 0 then
        ExecBroker := true;
      if pos('GrossProceeds', line) > 0 then begin
        NetProceeds := true;
      end;
      contracts := false;
      inc(R);
      if R < 1 then
        R := 1;
      if (pos('/', line) = 0) then begin
        dec(R);
        if (i = ImpStrList.Count - 1) and (R = 0) then begin
          if ImpNextDateOn then
            sm('No transactions later than ' + ImpDateLast)
          else
            sm('No Trade Data to import');
          // -----
          result := 0;
          exit;
        end;
        Continue;
      end;
      // delete Acct Name, Number, & Type
      delete(line, 1, pos('/', line) - 3);
      line := trim(line);
      // Date
      ImpDate := LongDateStr(copy(line, 1, pos(sep, line) - 1));
      if not ValidTradeDate(ImpDate, ImpDateLast, ImpNextDateOn) then begin
        dec(R);
        Continue;
      end;
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // Time
      TimeStr := copy(line, 1, pos(sep, line) - 1);
      if length(TimeStr) = 6 then
        TimeStr := copy(TimeStr, 1, 4)
      else if length(TimeStr) = 5 then
        TimeStr := copy(TimeStr, 1, 3);
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // ticker
      tick := copy(line, 1, pos(sep, line) - 1);
      tick := uppercase(tick);
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // oc
      oc := copy(line, 1, pos(sep, line) - 1);
      if pos('SS', oc) > 0 then
        oc := 'C'
      else if pos('S', oc) > 0 then
        oc := 'C'
      else if pos('B', oc) > 0 then
        oc := 'O';
      ls := 'L';
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // shares
      ShStr := copy(line, 1, pos(sep, line) - 1);
      ShStr := delCommas(ShStr);
      // ShStr:= Del1000SepEx(ShStr,ImportFmt);
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // price
      PrStr := copy(line, 1, pos(sep, line) - 1);
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // delete Market & MMID & Liquidity
      delete(line, 1, pos('$', line));
      { line:=trim(line);
        delete(line,1,pos(sep,line));
        line:=trim(line);
        if ExecBroker then begin
        delete(line,1,pos(sep,line));
        line:=trim(line);
        end;
        if Liquidity then begin
        delete(line,1,pos(sep,line));
        line:=trim(line);
        end; }
      // comm
      CmStr := copy(line, 1, pos(sep, line) - 1);
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // SEC Fee
      SECStr := copy(line, 1, pos(sep, line) - 1);
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // amount
      if NetProceeds then begin
        for j := 1 to 12 do begin
          delete(line, 1, pos(sep, line));
          // line:=trim(line);
        end;
        NetAmtStr := copy(line, 1, pos(sep, line) - 1);
        delete(line, 1, pos(sep, line));
        line := trim(line);
        AmtStr := copy(line, 1, pos(sep, line) - 1);
      end
      else begin
        AmtStr := copy(line, 1, pos(sep, line) - 1);
        delete(line, 1, pos(sep, line));
        line := trim(line);
      end;
      try
        Shares := StrToFloat(ShStr, Settings.InternalFmt);
        if contracts then
          prfStr := 'OPT-100'
        else
          prfStr := 'STK-1';
        Price := CurrToFloat(PrStr);
        if NetProceeds then begin
          Commis := CurrToFloat(AmtStr) - CurrToFloat(NetAmtStr);
          if Commis < 0 then
            Commis := -Commis;
        end
        else begin
          Commis := CurrToFloat(CmStr);
          Commis := Commis + CurrToFloat(SECStr);
        end;
        Amount := CurrToFloat(AmtStr);
        Price := (Amount + Commis) / Shares;
        if Amount < 0 then
          Amount := -Amount;
        if Shares < 0 then
          Shares := -Shares;
        if Price < 0 then
          Price := -Price;
      except
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        dec(R);
        Continue;
      end;
      ImpTrades[R].it := TradeLogFile.Count + R;
      ImpTrades[R].DT := ImpDate;
      ImpTrades[R].tm := TimeStr;
      ImpTrades[R].oc := oc;
      ImpTrades[R].ls := ls;
      ImpTrades[R].tk := tick;
      ImpTrades[R].sh := Shares;
      ImpTrades[R].pr := Price;
      ImpTrades[R].prf := prfStr;
      ImpTrades[R].am := Amount;
      ImpTrades[R].cm := Commis;
    end;
    StatBar('off');
    ImpStrList.Destroy;
    result := R;
  finally
    // ReadProTraderInstinet
  end;
end;

function ReadProTrader(): integer;
var
  ImpDir, line, newPath, FileName : string;
  ImpFile : textfile;
  newFiles : TStringList;
begin
  try
    ImpDir := Settings.ImportDir;
    newPath := '';
    newFiles := TStringList.Create;
    newFiles.Capacity := 1;
    with frmMain do begin
      if OpenFileDialog('ETG data files (*.txt or *.asp)|*.txt;*.asp', ImpDir,
        TradeLogFile.CurrentAccount.FileImportFormat + ' Import', newPath, newFiles, false, false)
      then
        try
          FileName := newPath + '\' + newFiles[0];
          if FileExists(FileName) then begin
            AssignFile(ImpFile, FileName);
            reset(ImpFile);
            while not EOF(ImpFile) do begin
              Readln(ImpFile, line);
              if (pos('Account Name', line) > 0) or (pos('AccountName', line) > 0) then begin
                result := ReadProTraderInstinet(FileName);
                exit;
              end
              else begin
                result := ReadProTraderOLD(FileName);
                exit;
              end;
            end;
            CloseFile(ImpFile);
          end;
        except
          on EInOutError do
            sm('FILE IS ALREADY OPEN' + cr + cr + 'PLEASE CLOSE FIRST');
        end;
      result := 0;
    end;
  finally
    // ReadProTrader
  end;
end;


function ReadQIF(): integer;
var
  i, R : integer;
  Shares, mult, Commis : double;
  Flds, prfStr, stock, exMoYr, putCall : string;
  oc, ls : string;
begin
  try
    DataConvErrRec := '';
    DataConvErrStr := '';
    R := 0;
    ImpStrList := TStringList.Create;
    ImpTrades := nil;
    setLength(ImpTrades, R + 1);
    GetImpDateLast;
    GetImpStrListFromFile('Quicken', 'qif', '');
    R := 0;
    i := 0;
    dte := '';
    oc := '';
    ls := '';
    tick := '';
    Shares := 0;
    Price := 0;
    Commis := 0;
    Amt := 0;
    while i < ImpStrList.Count - 1 do begin
      inc(i);
      Flds := ImpStrList[i];
      while pos(chr(13), Flds) > 0 do
        delete(Flds, pos(chr(13), Flds), 1);
      { date }
      if pos('D', Flds) = 1 then begin
        inc(R);
        delete(Flds, 1, 1);
        if pos('''', Flds) > 0 then begin
          while pos(' ', Flds) > 0 do begin
            delete(Flds, pos(' ', Flds), 1);
          end;
          dte := copy(Flds, 1, pos('''', Flds) - 1);
          delete(Flds, 1, pos('''', Flds));
          // added 1-2-02 to fix date problem
          Flds := trim(Flds);
          if length(Flds) = 1 then
            dte := dte + '/200' + Flds
          else if length(Flds) = 2 then
            dte := dte + '/20' + Flds
          else if length(Flds) = 4 then
            dte := dte + '/' + Flds;;
          dte := LongDateStr(dte);
        end
        else begin
          dte := LongDateStr(copy(Flds, 1, 10));
        end;
        Continue;
      end
      else
        try
          if pos('N', Flds) = 1 then begin { o/c, l/s }
            delete(Flds, 1, 1);
            oc := lowercase(trim(Flds));
            ls := 'L';
            if (pos('sellshort', oc) > 0) or (pos('shtsell', oc) > 0) then begin
              oc := 'C';
            end
            else if (pos('cvrshrt', oc) > 0) then begin
              oc := 'O';
            end
            else if (pos('buy', oc) > 0) then
              oc := 'O'
            else if (pos('reinvdiv', oc) > 0) then
              oc := 'O'
            else if (pos('reinvlg', oc) > 0) then
              oc := 'O'
            else if (pos('sell', oc) > 0) then
              oc := 'C'
            else begin
              dec(R);
              while pos('^', Flds) = 0 do begin
                inc(i);
                Flds := ImpStrList[i];
              end;
            end;
            Continue;
          end
          else if pos('M', Flds) = 1 then begin { skip total }
            if (pos('Voided', Flds) > 0) then begin
              dec(R);
              while pos('^', Flds) = 0 do begin
                inc(i);
                Flds := ImpStrList[i];
              end;
            end;
            Continue;
          end
          else if pos('C', Flds) = 1 then begin { skip C - what is it?? }
            Continue;
          end
          else if pos('U', Flds) = 1 then begin { skip total }
            Continue;
          end
          else if pos('Y', Flds) = 1 then begin { ticker }
            delete(Flds, 1, 1);
            Flds := trim(Flds);
            while pos('*', Flds) > 0 do
              delete(Flds, pos('*', Flds), 1);
            tick := Flds;
            Continue;
          end
          { price }
          else if pos('I', Flds) = 1 then begin
            delete(Flds, 1, 1);
            Flds := trim(Flds);
            while pos(' ', Flds) > 0 do
              delete(Flds, pos(' ', Flds), 1);
            while pos(',', Flds) > 0 do
              delete(Flds, pos(',', Flds), 1);
            { while pos(ImportFmt.ThsndsSep,flds)>0 do
              delete(flds,pos(ImportFmt.ThsndsSep,flds),length(
              ImportFmt.ThsndsSep)); }
            Price := StrToFloat(Flds, Settings.InternalFmt);
            // Price:= StrToFloat(Flds,ImportFmt);
            Continue;
          end
          else if pos('Q', Flds) = 1 then begin { shares }
            delete(Flds, 1, 1);
            while pos(',', Flds) > 0 do
              delete(Flds, pos(',', Flds), 1);
            { while pos(ImportFmt.ThsndsSep,flds)>0 do
              delete(flds,pos(ImportFmt.ThsndsSep,flds),length(
              ImportFmt.ThsndsSep)); }
            Flds := trim(Flds);
            while pos(' ', Flds) > 0 do
              delete(Flds, pos(' ', Flds), 1);
            Shares := StrToFloat(Flds, Settings.InternalFmt);
            Continue;
          end
          else if pos('T', Flds) = 1 then begin { amt }
            delete(Flds, 1, 1);
            while pos(',', Flds) > 0 do
              delete(Flds, pos(',', Flds), 1);
            { while pos(ImportFmt.ThsndsSep,flds)>0 do
              delete(flds,pos(ImportFmt.ThsndsSep,flds),length(
              ImportFmt.ThsndsSep)); }
            trim(Flds);
            Amt := StrToFloat(Flds, Settings.InternalFmt);
            Continue;
          end
          { comm }
          else if pos('O', Flds) = 1 then begin
            delete(Flds, 1, 1);
            Flds := trim(Flds);
            while pos(',', Flds) > 0 do
              delete(Flds, pos(',', Flds), 1);
            { while pos(ImportFmt.ThsndsSep,flds)>0 do
              delete(flds,pos(ImportFmt.ThsndsSep,flds),length(
              ImportFmt.ThsndsSep)); }
            while pos(' ', Flds) > 0 do
              delete(Flds, pos(' ', Flds), 1);
            Commis := StrToFloat(Flds, Settings.InternalFmt);
            Continue;
          end
          else if pos('^', Flds) = 1 then begin
            // added 9/22/04 for options
            if (pos('PUT ', tick) = 1) or (pos('CALL ', tick) = 1) then begin
              Shares := Shares / 100;
              mult := 100;
              prfStr := 'OPT-100';
              putCall := trim(copy(tick, 1, pos(' ', tick) - 1));
              delete(tick, 1, pos(' ', tick));
              tick := trim(tick);
              stock := trim(copy(tick, 1, pos(' ', tick) - 1));
              delete(tick, 1, pos(' ', tick));
              tick := trim(tick);
              exMoYr := trim(copy(tick, 1, pos(' ', tick) - 1)) + copy(dte, 9, 2);
              delete(tick, 1, pos(' ', tick));
              tick := trim(tick);
              tick := stock + ' ' + exMoYr + ' ' + tick + ' ' + putCall;
            end
            else begin
              mult := 1;
              prfStr := 'STK-1';
              if oc = 'O' then begin
                if (floattostrf(Amt, ffFixed, 8, 2, Settings.UserFmt)
                    = floattostrf(Shares * Price * 100 + Commis, ffFixed, 8, 2, Settings.UserFmt))
                then begin
                  mult := 100;
                  prfStr := 'OPT-100';
                end;
              end
              else if oc = 'C' then begin
                if (floattostrf(Amt, ffFixed, 8, 2, Settings.UserFmt)
                    = floattostrf(Shares * Price * 100 - Commis, ffFixed, 8, 2, Settings.UserFmt))
                then begin
                  mult := 100;
                  prfStr := 'OPT-100';
                end;
              end;
            end;
            // fixed problem with no SEC fees included in comm  1/4/02
            if (Amt <> 0) and (oc = 'O') then
              Commis := Amt - (Shares * Price * mult)
              // Amt:= -(Shares * Price) - Commis
            else if (Amt <> 0) and (oc = 'C') then
              // Amt:= (Shares * Price) - Commis;
              Commis := (Shares * Price * mult) - Amt;
            ImpTrades[R].it := TradeLogFile.Count + R;
            ImpTrades[R].DT := dte;
            ImpTrades[R].oc := oc;
            ImpTrades[R].ls := ls;
            ImpTrades[R].tk := tick;
            ImpTrades[R].sh := Shares;
            ImpTrades[R].pr := Price;
            ImpTrades[R].prf := prfStr;
            ImpTrades[R].cm := Commis;
            ImpTrades[R].am := Amt;
            dte := '';
            oc := '';
            ls := '';
            tick := '';
            Shares := 0;
            Price := 0;
            Commis := 0;
            Amt := 0;
          end;
        except
          DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
          dec(R);
          Continue;
        end;
    end;
    ImpStrList.Destroy;
    SortImpByDate(R);
    result := R;
  finally
    // ReadQIF
  end;
end;


function ReadQFX(): integer;
var
  i, R : integer;
  Shares, mult, Commis : double;
  Flds, prfStr, stock, exMoYr, putCall, s : string;
  oc, ls : string;
begin
  try
    DataConvErrRec := '';
    DataConvErrStr := '';
    R := 0;
//    isOFX := false;
    ImpTrades := nil;
    setLength(ImpTrades, R + 1);
    GetImpDateLast;
    s := GetStrFromFile('Quicken QFX', 'QFX|qfx');
    R := 0;
    i := 0;
    dte := '';
    oc := '';
    ls := '';
    tick := '';
    Shares := 0;
    Price := 0;
    Commis := 0;
    Amt := 0;
    // check if OFX or QFX
//    if (pos('<?OFX', s) > 0) or (pos('</DTTRADE', s) > 0) then begin
//      isOFX := true;
//    end;
    // ----------------------
    // format lines
    s := AdjustLineBreaks(s);
    if (pos('<OFX>', s) > 0) then begin
      delete(s, 1, pos('<OFX>', s) - 1); // sm(s);
//      if isOFX then
//        R := e_ParseOFXreply(s)
//      else
        R := parseQFX(s);
    end
    else
      R := 0;
    // ----------------------
    SortImpByDate(R);
    result := R;
  finally
    // ReadQFX
  end;
end;


// ----------------------------------------------
// Accepts ONLY US-formatted String Input
// Output is User-Fprmatted
// ----------------------------------------------
function formatRJTopt(tick, dtStr : string; expOption : boolean): string;
var
  p : integer;
  strike, xYr, PutCallStr : string;
begin
  try
    p := 0;
    tick := trim(tick);
    while pos('*', tick) > 0 do
      delete(tick, pos('*', tick), 1);
    while pos('&', tick) > 0 do
      delete(tick, pos('&', tick), 1);
    xYr := copy(TaxYear, 3, 2);
    if pos('TRD ', tick) = 1 then
      delete(tick, 1, 4);
    if pos('AMEX', tick) = length(tick) - 3 then
      delete(tick, pos('AMEX', tick), 4);
    if pos('CBOT', tick) = length(tick) - 3 then
      delete(tick, pos('CBOT', tick), 4);
    if pos('CBOE', tick) = length(tick) - 3 then
      delete(tick, pos('CBOE', tick), 4);
    if pos('PSE', tick) = length(tick) - 2 then
      delete(tick, pos('PSE', tick), 3);
    //
    if pos('PUT ', tick) = 1 then begin
      PutCallStr := ' PUT';
      delete(tick, 1, 4);
    end
    else if pos('CALL ', tick) = 1 then begin
      PutCallStr := ' CALL';
      delete(tick, 1, 5);
    end;
    //
    if pos('JAN', tick) > 0 then begin
      p := pos('JAN', tick);
      if not expOption then
        if xStrToDate(dtStr) > getOptExpDate('JAN', xYr) then begin
          xYr := IntToStr(strToInt(xYr) + 1);
          if length(xYr) = 1 then
            xYr := '0' + xYr;
        end;
    end
    else if pos('FEB', tick) > 0 then begin
      p := pos('FEB', tick);
      if not expOption then
        if xStrToDate(dtStr) > getOptExpDate('FEB', xYr) then begin
          xYr := IntToStr(strToInt(xYr) + 1);
          if length(xYr) = 1 then
            xYr := '0' + xYr;
        end;
    end
    else if pos('MAR', tick) > 0 then begin
      p := pos('MAR', tick);
      if not expOption then
        if xStrToDate(dtStr) > getOptExpDate('MAR', xYr) then begin
          xYr := IntToStr(strToInt(xYr) + 1);
          if length(xYr) = 1 then
            xYr := '0' + xYr;
        end;
    end
    else if pos('APR', tick) > 0 then begin
      p := pos('APR', tick);
      if not expOption then
        if xStrToDate(dtStr) > getOptExpDate('APR', xYr) then begin
          xYr := IntToStr(strToInt(xYr) + 1);
          if length(xYr) = 1 then
            xYr := '0' + xYr;
        end;
    end
    else if pos('MAY', tick) > 0 then begin
      p := pos('MAY', tick);
      if not expOption then
        if xStrToDate(dtStr) > getOptExpDate('MAY', xYr) then begin
          xYr := IntToStr(strToInt(xYr) + 1);
          if length(xYr) = 1 then
            xYr := '0' + xYr;
        end;
    end
    else if pos('JUN', tick) > 0 then begin
      p := pos('JUN', tick);
      if not expOption then
        if xStrToDate(dtStr) > getOptExpDate('JUN', xYr) then begin
          xYr := IntToStr(strToInt(xYr) + 1);
          if length(xYr) = 1 then
            xYr := '0' + xYr;
        end;
    end
    else if pos('JUL', tick) > 0 then begin
      p := pos('JUL', tick);
      if not expOption then
        if xStrToDate(dtStr) > getOptExpDate('JUL', xYr) then begin
          xYr := IntToStr(strToInt(xYr) + 1);
          if length(xYr) = 1 then
            xYr := '0' + xYr;
        end;
    end
    else if pos('AUG', tick) > 0 then begin
      p := pos('AUG', tick);
      if not expOption then
        if xStrToDate(dtStr) > getOptExpDate('AUG', xYr) then begin
          xYr := IntToStr(strToInt(xYr) + 1);
          if length(xYr) = 1 then
            xYr := '0' + xYr;
        end;
    end
    else if pos('SEP', tick) > 0 then begin
      p := pos('SEP', tick);
      if not expOption then
        if xStrToDate(dtStr) > getOptExpDate('SEP', xYr) then begin
          xYr := IntToStr(strToInt(xYr) + 1);
          if length(xYr) = 1 then
            xYr := '0' + xYr;
        end;
    end
    else if pos('OCT', tick) > 0 then begin
      p := pos('OCT', tick);
      if not expOption then
        if xStrToDate(dtStr) > getOptExpDate('OCT', xYr) then begin
          xYr := IntToStr(strToInt(xYr) + 1);
          if length(xYr) = 1 then
            xYr := '0' + xYr;
        end;
    end
    else if pos('NOV', tick) > 0 then begin
      p := pos('NOV', tick);
      if not expOption then
        if xStrToDate(dtStr) > getOptExpDate('NOV', xYr) then begin
          xYr := IntToStr(strToInt(xYr) + 1);
          if length(xYr) = 1 then
            xYr := '0' + xYr;
        end;
    end
    else if pos('DEC', tick) > 0 then begin
      p := pos('DEC', tick);
      if not expOption then
        if xStrToDate(dtStr) > getOptExpDate('DEC', xYr) then begin
          xYr := IntToStr(strToInt(xYr) + 1);
          if length(xYr) = 1 then
            xYr := '0' + xYr;
        end;
    end;
    //
    strike := trim(copy(tick, p + 3, length(tick) - p + 3));
    if pos('0', strike) = 1 then
      delete(strike, 1, 1);
    if pos('/', strike) > 0 then begin
      // strike is fractional-convert to decimal
      strike := floattostr(FracDecToFloat(strike), Settings.UserFmt);
    end;
    tick := copy(tick, 1, p - 1) + copy(tick, p, 3) + xYr + ' ' + strike + PutCallStr;
    result := tick;
  finally
    // formatRJTopt
  end;
end;


function ReadRydexRFS(): integer;
var
  i, j, R : integer;
  Commis : double;
  line, ImpDate, ShStr, PrStr, CmStr, cancelStr, NextDate : string;
  TrCorrected, contracts, ImpNextDateOn : boolean;
  oc, ls : string;
begin
  try
    DataConvErrRec := '';
    DataConvErrStr := '';
    R := 0;
    contracts := false;
    ImpNextDateOn := false;
    TrCorrected := false;
    CorrectedTrades := 0;
    ImpStrList := TStringList.Create;
    ImpTrades := nil;
    setLength(ImpTrades, R + 1);
    GetImpDateLast;
    GetImpStrListFromFile('RydexRFS', 'csv', '');
    if ImpStrList.Count < 1 then begin
      ImpStrList.Destroy;
      result := 0;
      exit;
    end;
    for i := 0 to ImpStrList.Count - 1 do begin
      inc(R);
      if R < 1 then
        R := 1;
      line := ImpStrList[i];
      // delete all quotes
      while pos('"', line) > 0 do begin
        delete(line, pos('"', line), 1);
      end;
      // add extra comma
      line := line + ',';
      // impdate
      ImpDate := trim(copy(line, 1, pos(',', line) - 1));
      if not IsLongDate(ImpDate) then begin
        // if not IsLongDateEx(impDate,ImportFmt) then begin
        dec(R);
        Continue;
      end;
      delete(line, 1, pos(',', line));
      // Date
      ImpDate := LongDateStr(ImpDate);
      if not ValidTradeDate(ImpDate, ImpDateLast, ImpNextDateOn) then begin
        dec(R);
        Continue;
      end;
      ImpTrades[R].DT := ImpDate;
      // Delete account and short name
      delete(line, 1, pos(',', line));
      delete(line, 1, pos(',', line));
      // qty
      ShStr := trim(copy(line, 1, pos(',', line) - 1));
      delete(line, 1, pos(',', line));
      // --------------------
      // Open/Close
      oc := lowercase(copy(line, 1, pos(',', line) - 1));
      if oc = 'by' then begin
        oc := 'O';
        ls := 'L';
      end
      else if oc = 'sl' then begin
        oc := 'C';
        ls := 'L';
      end
      else if oc = 'ss' then begin
        oc := 'O';
        ls := 'S';
      end
      else if oc = 'cs' then begin
        oc := 'C';
        ls := 'S';
      end
      else begin
        dec(R);
        Continue;
      end;
      delete(line, 1, pos(',', line));
      // --------------------
      // Delete source and txn
      delete(line, 1, pos(',', line));
      cancelStr := uppercase(copy(line, 1, pos(',', line) - 1));
      if pos('CANCEL', cancelStr) > 0 then begin
        TrCorrected := true;
        oc := 'X';
      end;
      delete(line, 1, pos(',', line));
      // ticker
      tick := uppercase(copy(line, 1, pos(',', line) - 1));
      delete(line, 1, pos(',', line));
      // price
      PrStr := copy(line, 1, pos(',', line) - 1);
      delete(line, 1, pos(',', line));
      // comm
      CmStr := copy(line, 1, pos(',', line) - 1);
      delete(line, 1, pos(',', line));
      // sm(Impdate+tab+oc+ls+tab+tick+tab+shstr+tab+prstr+tab+cmstr);
      // continue;
      try
        Shares := StrToFloat(ShStr, Settings.InternalFmt);
        // shares:= strToFloat(ShStr,ImportFmt);
        if Shares < 0 then
          Shares := -Shares;
        Price := StrToFloat(PrStr, Settings.InternalFmt);
        // price:= StrToFloat(prStr,ImportFmt);
        if Price < 0 then
          Price := -Price;
        Commis := StrToFloat(CmStr, Settings.InternalFmt);
        // commis:= StrToFloat(cmStr,ImportFmt);
        Amt := 0;
        ImpTrades[R].it := TradeLogFile.Count + R;
        ImpTrades[R].tr := 0;
        ImpTrades[R].DT := ImpDate;
        ImpTrades[R].tm := '';
        ImpTrades[R].oc := oc;
        ImpTrades[R].ls := ls;
        ImpTrades[R].tk := tick;
        ImpTrades[R].sh := Shares;
        ImpTrades[R].pr := Price;
        if contracts then
          ImpTrades[R].prf := 'OPT-100'
        else
          ImpTrades[R].prf := 'STK-1';
        ImpTrades[R].cm := Commis;
        ImpTrades[R].am := Amt;
      except
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        dec(R);
        Continue;
      end;
    end;
    // ----------------------
    if TrCorrected then begin
      for i := 1 to R do begin
        if (ImpTrades[i].oc = 'X') then
          for j := R downto 1 do begin
            if (ImpTrades[i].tk = ImpTrades[j].tk) and (ImpTrades[i].DT = ImpTrades[j].DT) and
              (ImpTrades[i].ls = ImpTrades[j].ls) and (ImpTrades[i].sh = ImpTrades[j].sh) and
              (format('%1.5f', [ImpTrades[i].pr], Settings.UserFmt) = format('%1.5f',
                [ImpTrades[j].pr], Settings.UserFmt)) and (i <> j) then begin
              ImpTrades[i].oc := '';
              ImpTrades[i].ls := '';
              ImpTrades[j].oc := '';
              ImpTrades[j].ls := '';
              break;
            end;
          end;
      end;
    end;
    // ----------------------
    for i := 1 to R do begin
      if ImpTrades[i].oc = 'X' then begin
        sm('CANCEL TRADES NOT MATCHED!' + cr + cr +
            'Cancel Trades have Open/Close marked with an "X"');
        break;
      end;
    end;
    StatBar('off');
    ImpStrList.Destroy;
    if R > 0 then
      SortImpByDate(R);
    result := R;
  finally
    // ReadRydexRFS
  end;
end;


// ------------------------------------
// Robinhood
// ------------------------------------
function ReadRobinhoodCSV(ImpStrList : TStringList): integer;
var
  i, j, k, start, eend, R, Q, iCSVtype, iMaxField, nCSVfields : integer;
  iDt, iOC, iTk, iDesc, iShr, iPr, iAmt, iTyp : integer; // import field numbers
  junk, sep, ImpDate, ImpTime, CmStr, feeStr, PrStr, AmtStr, ShStr, typeStr, line, sCUSIP,
    optDesc, optOC, opYr, opMon, opDay, opStrike, opCP, oc, ls, dd, mm, yyyy, errLogTxt : string;
  Amount, Commis, Fees, Shares, mult : double;
  contracts, Adj, optExpEx, ImpNextDateOn, bonds, newColFormat, miniOptions, futures, bFoundHeader,
    cancels : boolean;
  fieldLst : TStrings;
  // --------------------------------------------
  // Fld Idx FieldName      Example
  // --------------------------------------------
  // DT  1   Activity Date  12/31/2019
  // 2   Process Date   12/31/2019
  // 3   Settle Date    1/3/2020
  // 4   Account Type   2
  // TK  5   Instrument     DIS
  // DSC 6   Description    Disney
  // OC  7   Trans Code     SELL
  // SH  8   Quantity       -5
  // PR  9   Price          $143.78
  // AM  10  Amount         $718.89
  // 11  Suppressed     N
  // --------------------------------------------
  procedure SetFieldNumbers();
  var
    j : integer;
  begin
    // Robinhood
    iCSVtype := 1;
    k := 0;
    iTyp := -1; // default to STK
    nCSVfields := fieldLst.Count;
    for j := 0 to (nCSVfields - 1) do begin
      if fieldLst[j] = 'ACTIVITY DATE' then begin
        iDt := j;
        k := k or 1;
        if j > iMaxField then
          iMaxField := j;
      end
      else if fieldLst[j] = 'INSTRUMENT' then begin
        iTk := j;
        k := k or 2;
        if j > iMaxField then
          iMaxField := j;
      end
      else if fieldLst[j] = 'DESCRIPTION' then begin
        // options: META 12/16/2022 Call $130.00
        iDesc := j;
        k := k or 4;
        if j > iMaxField then
          iMaxField := j;
      end
      else if fieldLst[j] = 'TRANS CODE' then begin
        iOC := j;
        k := k or 8;
        if j > iMaxField then
          iMaxField := j;
      end
      else if fieldLst[j] = 'QUANTITY' then begin
        iShr := j;
        k := k or 16;
        if j > iMaxField then
          iMaxField := j;
      end
      else if fieldLst[j] = 'PRICE' then begin
        iPr := j;
        k := k or 32;
        if j > iMaxField then
          iMaxField := j;
      end
      else if fieldLst[j] = 'AMOUNT' then begin
        iAmt := j;
        k := k or 64;
        if j > iMaxField then
          iMaxField := j;
      end;
    end;
  end;
  // --------------------------------------------
  procedure SetFieldNumbers2(); // from rhtcsv
  var
    j : integer;
  begin
    // Robinhood (rhtcsv Chrome extension)
    iCSVtype := 2;
    k := 0;
    nCSVfields := fieldLst.Count;
    for j := 0 to (nCSVfields - 1) do begin
      if fieldLst[j] = 'DATE' then begin
        iDt := j;
        k := k or 1;
        if j > iMaxField then
          iMaxField := j;
      end
      else if fieldLst[j] = 'SYMBOL' then begin
        // options: FVRR $195 Call 5/21/2021
        iTk := j;
        k := k or 2;
        if j > iMaxField then
          iMaxField := j;
      end
      else if fieldLst[j] = 'DETAILS' then begin
        iDesc := j;
        k := k or 4;
        if j > iMaxField then
          iMaxField := j;
      end
      else if fieldLst[j] = 'ACTION' then begin
        iOC := j;
        k := k or 8;
        if j > iMaxField then
          iMaxField := j;
      end
      else if fieldLst[j] = 'QUANTITY' then begin
        iShr := j;
        k := k or 16;
        if j > iMaxField then
          iMaxField := j;
      end
      else if fieldLst[j] = 'PRICE' then begin
        iPr := j;
        k := k or 32;
        if j > iMaxField then
          iMaxField := j;
      end
      else if fieldLst[j] = 'AMOUNT' then begin
        iAmt := j;
        k := k or 64;
        if j > iMaxField then
          iMaxField := j;
      end
      else if fieldLst[j] = 'TYPE' then begin
        iTyp := j;
        k := k or 128;
        if j > iMaxField then
          iMaxField := j;
      end;
    end;
  end;
// ----------------------------------------------
begin // ReadRobinhoodCSV
  bFoundHeader := false; // let's us know we haven't found the header yet
  iDt := 0;
  iOC := 0;
  iTk := 0;
  iDesc := 0;
  iShr := 0;
  iPr := 0;
  iAmt := 0;
  DataConvErrRec := '';
  iMaxField := 0;
  nCSVfields := 0;
  // in case these are missing, flag to skip them.
  cancels := false;
  R := 0;
  // moved this code to above TRY block
  sCUSIP := '';
  DataConvErrRec := '';
  DataConvErrStr := '';
  Adj := false;
  ImpNextDateOn := false;
  newColFormat := false;
  // --------------------------------------------
  try
    if ImpStrList.Count < 1 then begin
      ImpStrList.Destroy;
      result := 0;
      exit;
    end;
    fieldLst := TStrings.Create;
    // --------------------------------
    i := -1;
    while i < (ImpStrList.Count - 1) do begin
      inc(i); // make it work like a for/next
      contracts := false;
      optExpEx := false;
      // ------------------------------
      line := ImpStrList[i];
      line := uppercase(line); // search line for UPPERCASE tokens...
      // ------------------------------
      // parse all columns into string list
      fieldLst := ParseCSV(line);
      if not bFoundHeader then begin
        if (pos('ACTIVITY DATE', line) > 0) // csv from RH website
          and (pos('INSTRUMENT', line) > 0) then begin //
          SetFieldNumbers;
          if SuperUser and (k <> 127) then
            sm('there appear to be fields missing.');
          bFoundHeader := true; // don't do this anymore
          R := 0; // start now
        end
        else if (pos('DATE', line) > 0) // csv from RHtoCSV Chrome ext.
          and (pos('TYPE', line) > 0) //
          and (pos('SYMBOL', line) > 0) //
          and (pos('QUANTITY', line) > 0) then begin //
          SetFieldNumbers2;
          if SuperUser and ((k or 4) <> 255) then // Desc./Details opt'l
            sm('there appear to be fields missing.');
          bFoundHeader := true; // don't do this anymore
          R := 0; // start now
        end;
        Continue; // don't process anything until we recognize the header
      end;
      // ------------------------------
      while (fieldLst.Count < nCSVfields) do begin
        inc(i);
        if i >= ImpStrList.Count then break; // out of lines
        junk := ImpStrList[i];
        junk := uppercase(junk); // search line for UPPERCASE tokens...
        line := line + ' ' + junk;
        fieldLst := ParseCSV(line);
      end;
      if (fieldLst.Count > nCSVfields) and SuperUser then begin
        sm('possible bad record:' + crlf + line);
      end;
      if fieldLst.Count < iMaxField then begin
        if (SuperUser) and (fieldLst.Count > 1) then
          sm('not enough fields in line ' + IntToStr(i) + CRLF + line);
        Continue;
      end;
      if pos('ERROR', line) > 0 then begin
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        sm('Robinhood reported an error.' + cr //
         + 'Please reduce the date range and try again.');
        result := 0;
        exit;
      end;
      // --- Date ---------------------
      ImpDate := fieldLst[iDt]; // format: MM/DD/YYYY
      if not isdate(ImpDate) then begin
        if (fieldLst.Count > 1) and SuperUser then
          sm('WARNING: TradeLog cannot determine' + crlf //
           + 'the transaction date of this line:' + crlf //
           + crlf //
           + line);
        Continue;
      end;
      if not ValidTradeDate(ImpDate, ImpDateLast, ImpNextDateOn) then begin
        // DataConvErrRec := DataConvErrRec + 'date already imported: ' + ImpStrList[i] + cr;
        Continue;
      end;
      // Robinhood OC/LS types
      // --- OC and LS --------
      // Known Trans Code List:
      // ACH
      // BTC	     Buy To Close
      // BTO       Buy To Open
      // BUY	     Buy
      // CDIV      Cash Dividend
      // DCF       Deposit Cash Funds
      // FSWP
      // GDBP
      // GOLD
      // INT       interest
      // MDIV
      // MINT
      // NOA
      // OASGN	   Option Assigned
      // OEXCS	   Option Exercised
      // OEXP	     Option Expired
      // REC
      // SELL
      // SPR
      // STC       Sell to close
      // STO	     Sell To Open
      // ----------------------
      if (iOC > (fieldLst.Count - 1)) then begin
        if (SuperUser) and (fieldLst.Count > 1) then
          sm('Not enough fields in line ' + IntToStr(i) + CRLF + line);
        Continue;
      end;
      junk := fieldLst[iOC]; // temporary variable use
      if (fieldLst[iOC] = 'BUY') // Buy to Open (Long)
      or (fieldLst[iOC] = 'BTO') then begin
        oc := 'O';
        ls := 'L';
      end
      else if (fieldLst[iOC] = 'STO') then begin
        oc := 'O';
        ls := 'S';
      end
      else if (fieldLst[iOC] = 'BTC') then begin
        oc := 'C';
        ls := 'S';
      end
      else if (fieldLst[iOC] = 'SELL') // Sell to Close (Long)
        or (fieldLst[iOC] = 'STC') then begin
        oc := 'C';
        ls := 'L';
      end
      else begin
//        sm('unknown buy/sell in line: ' + crlf + line);
        oc := 'E';
        ls := 'E';
        Continue;
      end;
      inc(R); // if it gets this far, count it
      // --- # shares ---
      ShStr := fieldLst[iShr];
      ShStr := delCommas(ShStr);
      // --- ticker -----
      tick := trim(fieldLst[iTk]);
      // --- is it an option?
      contracts := false; // default is NO
      if iCSVtype = 1 then begin
        // look at description
        junk := trim(fieldLst[iDesc]);
        if (pos(' CALL ', junk) > 4) //
        or (pos(' PUT ', junk) > 4) then begin
          if pos('COVERED CALL', junk) < 1 then
            contracts := true;
        end;
      end
      else if iCSVtype = 2 then begin
        // look at ticker
        if (pos(' ', tick) > 0) //
        and (length(tick) > 6) then
          contracts := true
        else
          contracts := false;
      end;
      // -- type/mult ---
      if (iTyp = -1) then begin // legacy format has no type field
        if contracts then begin
          typeStr := 'OPT-100';
          mult := 100;
        end
        else begin
          typeStr := 'STK-1';
          mult := 1;
        end;
      end
      else if (fieldLst[iTyp] = 'CRYPTO') then begin // new
        typeStr := 'DCY-1'; // Digital Currency
        mult := 1;
      end
      else if (fieldLst[iTyp] = 'OPTION') then begin // guessing!
        typeStr := 'OPT-100'; // Digital Currency
        mult := 100;
      end
      else begin
        typeStr := 'STK-1';
        mult := 1;
      end;
      // // --- futures --------
      // if futures then begin
      //   junk := tick; // holder
      //   // last digit indicates year
      //   opYr := '1' + rightstr(junk, 1);
      //   if not IsNumber(opYr) then
      //     futures := false
      //   else if StrToInt('20' + opYr) < StrToInt(TaxYear) then
      //     opYr := '2' + rightstr(opYr, 1);
      //   delete(junk, length(junk), 1); // remove last char
      //   // lookup month code
      //   opMon := getFutExpMonth(rightstr(junk, 1));
      //   delete(junk, length(junk), 1); // remove last char
      //   // remaining chars are the underlying ticker
      //   tick := junk + ' ' + opMon + opYr;
      // end;
      // --- options --------
      if contracts then begin
        // first, calculate the option ticker
        // QQQ   20180119C  160.000
        // ---   yyyymmdd*  $$$.###
        if iCSVtype = 2 then
          junk := tick; // fmt: FVRR $195 Call 5/21/2021
        // else if =1 then fmt: META 12/16/2022 Call $130.00
        optDesc := parsefirst(junk, ' ');
        // there is another format, however:
        // UVXY $24 Call 10/8/2021
        // tick $SP C/P  exp. date
        if iCSVtype = 2 then begin
          opStrike := parsefirst(junk, ' ');
          opYr := parseLast(junk, '/');
          if length(opYr) = 4 then
            opYr := copy(opYr, 3);
          opDay := parseLast(junk, '/');
          if length(opDay) < 2 then
            opDay := '0' + opDay;
          opMon := parseLast(junk, ' ');
          if length(opMon) < 2 then
            opMon := '0' + opMon;
        end
        else begin // CSVtype 1
          opStrike := parseLast(junk, ' ');
          opMon := parsefirst(junk, '/');
          if length(opMon) < 2 then
            opMon := '0' + opMon;
          opDay := parsefirst(junk, '/');
          if length(opDay) < 2 then
            opDay := '0' + opDay;
          opYr := parsefirst(junk, ' ');
          if length(opYr) = 4 then
            opYr := copy(opYr, 3);
        end;
        if (opYr = '') or (opDay = '') then begin // NOT an option
          contracts := false;
          optDesc := '';
        end else begin
          opMon := getExpMo(opMon); // convert to TLA
          if (opMon = '') then begin // NOT really an option!
            contracts := false;
          end
          else begin // maybe it IS an option
            if (tick = '') and (length(optDesc) <= 4) then begin
              tick := optDesc;
            end;
            optDesc := ''; // either way, reset this
            // ------------------
            opCP := trim(junk);
            // ------------------
            if pos('$', opStrike)= 1 then
              opStrike := copy(opStrike, 2);
            opStrike := delCommas(opStrike);
            opStrike := delTrailingZeros(opStrike);
            if StrToFloat(opStrike) = 0 then begin
              contracts := false; // CAN'T be an option!
              optDesc := '';
            end else begin
              optDesc := tick + ' ' + opDay + opMon + opYr + ' ' + opStrike + ' ' + opCP;
            end;
            // EX: MSFT 21DEC17 15 CALL
          end; // if opMon not found
        end; // if opYr or opDay blank
      end
      else
        optDesc := ''; // NOT an option contract
      // end if contracts
      if (contracts = true) then begin
        if (opCP <> 'CALL') and (opCP <> 'PUT') then begin
          contracts := false; // CAN'T be an option!
          optDesc := '';
        end;
      end;
      // --- amount ---
      AmtStr := fieldLst[iAmt];
      if (pos('$', AmtStr) > 0) then
        delete(AmtStr, pos('$', AmtStr), 1);
      AmtStr := delCommas(AmtStr);
      if (AmtStr = '') or (pos('*', AmtStr) > 0) then
        AmtStr := '0.00';
      // ----------------------------
      if contracts then begin
        mult := 100;
        typeStr := 'OPT-100';
        tick := optDesc;
      end
      else if futures then begin
        mult := 100;
        typeStr := 'FUT-0';
      end
      else begin
        mult := 1;
        typeStr := 'STK-1';
      end;
      // --------------------
      try
        Shares := StrToFloat(ShStr, Settings.InternalFmt);
        if Shares = 0 then begin
          dec(R);
          Continue;
        end;
        if Shares < 0 then
          Shares := -Shares;
        // ----------------------------
        if (leftStr(AmtStr, 1)= '(') and (rightStr(AmtStr, 1)= ')') then
          AmtStr := '-' + copy(AmtStr, 2, length(AmtStr)- 2);
        Amount := CurrToFloat(AmtStr);
        if Amount < 0 then
          Amount := -Amount; // ABS()
        // ----------------------------
        // force commission to be zero, adjust the price.
        Commis := 0;
        Price := Amount /(Shares * mult);
        // ----------------------------
        ImpTrades[R].DT := ImpDate;
        ImpTrades[R].tm := ImpTime;
        ImpTrades[R].oc := oc;
        ImpTrades[R].ls := ls;
        ImpTrades[R].tk := trim(tick);
        ImpTrades[R].opTk := ''; // trim(optDesc);
        ImpTrades[R].sh := Shares;
        ImpTrades[R].pr := Price;
        ImpTrades[R].prf := typeStr;
        ImpTrades[R].am := Amount;
        ImpTrades[R].cm := rndto2(Commis) + rndto2(Fees);
      except
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        dec(R);
        Continue;
      end;
      ImpTrades[R].it := TradeLogFile.Count + R;
    end;
    // --------------------------------
    ReverseImpTradesDate(R); // Robinhood reports newest first
    if cancels then begin
      for i := 1 to R do begin
        if (ImpTrades[i].oc <> 'X') then
          Continue; // not a cancel
        StatBar('Matching Cancelled Trades: ' + IntToStr(i));
        for j := (i + 1) downto 1 do begin // NOTE: CANCEL can come before OR after trade to cancel
          if j > R then
            Continue; // don't go out of bounds
          if (ImpTrades[i].tk <> ImpTrades[j].tk) then
            Continue; // not same ticker
          // could be a match, let's check the rest...
          if (format('%1.5f', [ImpTrades[i].sh], Settings.UserFmt) = format('%1.5f',
              [ImpTrades[j].sh], Settings.UserFmt)) //
            and (format('%1.5f', [ImpTrades[i].pr], Settings.UserFmt) = format('%1.5f',
              [ImpTrades[j].pr], Settings.UserFmt)) //
            and (format('%1.2f', [ImpTrades[i].cm], Settings.UserFmt) = format('%1.2f',
              [ImpTrades[j].cm], Settings.UserFmt)) //
            and (ImpTrades[i].prf = ImpTrades[j].prf) //
            and (ImpTrades[j].oc <> '') and (i <> j) then begin
            // with ImpTrades[i] do
            //   msgTxt:= msgTxt + dt+tab+tk+tab+oc+ls+tab+floatToStr(sh)+tab+floatToStr(pr)+tab+floatToStr(am)+cr;
            glNumCancelledTrades := glNumCancelledTrades + 2;
            // --- I ---
            ImpTrades[i].oc := '';
            ImpTrades[i].ls := '';
            ImpTrades[i].tm := '';
            // --- J ---
            ImpTrades[j].oc := '';
            ImpTrades[j].ls := '';
            ImpTrades[j].tm := '';
            break;
          end; // if everything else matches
        end; // for j = 1 downto
      end; // for i = 1 to R
    end; // if cancels
    // --------------------------------
    ImpStrList.Destroy;
    result := R;
  finally
    fieldLst.Free;
    if length(DataConvErrRec) > 1 then begin
      AssignFile(ErrLog, Settings.DataDir + '\error.log');
      rewrite(ErrLog);
      errLogTxt := 'ERROR :' + msgTxt + '; Detailed Message: ' + '"' + DataConvErrRec + '"';
      try
        write(ErrLog, errLogTxt);
        errLogTxt := '';
      finally
        CloseFile(ErrLog);
      end;
    end; // end if DataConvErrRec
    // ReadRobinhoodCSV
  end;
end;

// ------------------------------------
// ENTRY POINT
// ------------------------------------
function ReadRobinhood(): integer;
var
  R : integer;
begin
  try
    R := 0;
    ImpStrList := TStringList.Create;
    ImpTrades := nil;
    setLength(ImpTrades, R + 1);
    GetImpDateLast;
    if FileExists(Settings.ImportDir + '\download.csv') then
      deleteFile(Settings.ImportDir + '\download.csv');
    GetImpStrListFromFile('Robinhood', 'csv', '');
    result := ReadRobinhoodCSV(ImpStrList);
    exit;
  finally
    // ReadRobinhood
  end;
end;

         // -----------------
         // Charles Schwab
         // -----------------

function ReadSchwabCSV(ImpStrList : TStringList): integer;
var
  i, j, k, start, eend, R : integer;
  iDt, iOC, iTk, iDes, iPr, iShr, iCm, iAmt : integer; // import fields
  ImpDate, oc, ls, PrStr, ShStr, AmtStr, CmStr,
   junk, sep, line, AdjEntryStr : string;
  // note: for some reason, tick is a unit-level string var.
  optDesc, opUnder, opYr, opMon, opDay, opStrike, opCP : string;
  Amount, Commis, Shares, mult : double;
  contracts, Adj, optExpEx, ImpNextDateOn,
   bonds, newColFormat, miniOptions, bFoundHeader : boolean;
  lineLst : TStrings;
  // ----------------------------------
  procedure ClearFieldNums();
  begin
    iDt := 0;
    iOC := 0;
    iTk := 0;
    iDes := 0;
    iPr := 0;
    iShr := 0;
    iCm := 0;
    iAmt := 0;
  end;
  // ----------------------------------
  procedure SetFieldNumbers();
  var
    j : integer;
    s : string;
  begin
    // find/map Schwab CSV fields
    k := 0;
    ClearFieldNums;
    // As of 2024-10-29, Schwab CSV has the following fields:
    // ---- CSV contains many more fields
    // iDt  Date	1/16/24
    // iOC  Action	Buy to Open
    // iTk  Symbol	SPY 01/16/2024 475.00 P
    // iDes Description	PUT SPDR S&P 500 $475 EXP 01/16/24
    //               or TDA TRAN - Bought 100 (BPYPP) @15.0999
    // iPr  Price	$0.33
    // iShr Quantity	1
    // iCm  Fees & Comm	$0.66
    // iAmt Amount	($33.66)
    // --------------------------------
    // here are the TDA CSV fields (for legacy files):
    // iDt  DATE (m/d/yy) e.g. 1/5/17
    //      TRANSACTION ID,
    // iDes DESCRIPTION, Bought 1 JNJ   170421C00125000 Apr 21 2017 125.0 Call @ 0.75
    // iShr QUANTITY,    1     yymmdd   $$.
    // iTk  SYMBOL,      JNJ   170421C00125000 Apr 21 2017 125.0 Call
    // iPr  PRICE,       0.75
    // iCm  COMMISSION,  <not used; must recalc>
    // iAmt AMOUNT       -82
    // --------------------------------
    for j := 0 to (lineLst.Count - 1) do begin
      s := trim(lineLst[j]);
      if s = 'DATE' then begin //
        iDt := j;
        k := k or 1;
      end
      else if s = 'ACTION' then begin //
        iOC := j;
        k := k or 2;
      end
      else if s = 'SYMBOL' then begin //
        iTk := j;
        k := k or 4;
      end
      else if s = 'DESCRIPTION' then begin //
        iDes := j;
        k := k or 8;
      end
      else if s = 'PRICE' then begin //
        iPr := j;
        k := k or 16;
      end
      else if s = 'QUANTITY' then begin //
        iShr := j;
        k := k or 32;
      end
      else if s = 'FEES & COMM' then begin //
        iCm := j;
        k := k or 64;
      end
      else if s = 'AMOUNT' then begin //
        iAmt := j;
        k := k or 128;
      end; // if cases
    end; // for j
    s := ''; // this line is just for placing a breakpoint!
  end;
// --------------------------
begin // ReadSchwabCSV
// --------------------------
  AdjEntryStr := '';
  DataConvErrRec := '';
  DataConvErrStr := '';
  R := 0;
  Adj := false;
  ImpNextDateOn := false;
  newColFormat := false;
  try
    if ImpStrList.Count < 1 then begin
      ImpStrList.Destroy;
      result := 0;
      exit;
    end;
    lineLst := TStrings.Create;
    for i := 0 to ImpStrList.Count - 1 do begin
      contracts := false;
      miniOptions := false;
      optExpEx := false;
      bonds := false;
      inc(R);
      if R < 1 then R := 1;
      // --------------------
      line := ImpStrList[i];
      line := uppercase(line); // search line for UPPERCASE tokens...
      lineLst := ParseCSV(line);
      // --------------------
      if not bFoundHeader then begin
        if (pos('DATE', line) > 0) // header format #1
        and (pos('SYMBOL', line) > 0) //
        and (pos('QUANTITY', line) > 0) //
        then begin
          if (pos('TRANSACTION', line) > 1) then begin
            result := ReadAmeritradeCSV(ImpStrList);
            exit; // pass TDA CSV file
          end; // old TDA CSV file
          SetFieldNumbers;
          if SuperUser and (k <> 255) then
            sm('there appear to be fields missing.');
          bFoundHeader := true; // don't do this anymore
          R := 0; // start now
        end;
        Continue; // don't process anything until we find the header!
      end; // header not found yet
      // --- date -----------
      ImpDate := lineLst[iDt];
      if length(ImpDate) > 10 then begin
        junk := ImpDate;
        if pos(' as of ', junk) > 0 then begin
          ImpDate := ParseLast(junk, ' ');
        end else begin
          ImpDate := leftStr(ImpDate, 10);
        end;
      end;
      if (pos('/', ImpDate) <> 3) //
      and (pos('/', ImpDate) <> 2) //
      then begin
        if (i = ImpStrList.Count - 1) and (R = 1) then begin
          // DataConvErrRec:= 'No records imported';
          sm('There were no trades for this date range');
          result := 0;
          exit;
        end;
        dec(R);
        Continue;
      end;
      ImpDate := LongDateStr(ImpDate);
      if not ValidTradeDate(ImpDate, ImpDateLast, ImpNextDateOn) //
      then begin
        dec(R);
        Continue;
      end;
      // --- buy/sell -------
      // old[1] = new[1] = Action
      // open/close, long/short
      oc := uppercase(trim(lineLst[iOC]));
      if (pos('CANCEL', oc) > 0) then begin
        Adj := true;
        oc := 'X';
      end
      else if (pos('SELL SHORT', oc) > 0) then begin
        oc := 'O';
        ls := 'S';
      end
      else if (pos('BUY TO OPEN', oc) > 0) then begin
        oc := 'O';
        ls := 'L';
        contracts := true;
      end
      else if (pos('BUY TO CLOSE', oc) > 0) then begin
        oc := 'C';
        ls := 'S';
        contracts := true;
      end
      else if (pos('SELL TO OPEN', oc) > 0) then begin
        oc := 'O';
        ls := 'S';
        contracts := true;
      end
      else if (pos('SELL TO CLOSE', oc) > 0) then begin
        oc := 'C';
        ls := 'L';
        contracts := true;
      end
      // 2014-03-06 Dividend Reinvestments
      else if (pos('BUY', oc) > 0) //
        or (pos('REINVEST SHARES', oc) > 0) //
      then begin
        oc := 'O';
        ls := 'L';
      end
      else if (pos('SELL', oc) > 0) then begin
        oc := 'C';
        ls := 'L';
      end
      else if (pos('type: EXPIRED', line) > 0) then begin
        optExpEx := true;
        oc := 'C';
        ls := 'L';
      end
      else begin
        oc := '';
        dec(R);
        Continue;
      end;
      if (pos('ADJUSTING ENTRY', line) > 0) then begin
        Adj := true;
        oc := 'X';
      end;
      // --- shares ---------
      if not newColFormat then begin
        ShStr := lineLst[iShr];
        if optExpEx and (pos('-', ShStr) = 0) then
          ls := 'S';
      end;
      // --- ticker ---------
      tick := lineLst[iTk];
      delete(tick, pos('"', tick), 1);
      if (pos('SW', tick) = 1) //
      and (pos('XX', tick) = length(tick) - 1) //
      then begin
        dec(R);
        Continue;
      end;
      // --- description ----
      junk := lineLst[iDes];
      if tick = '' then
        tick := junk;
      // added 10-22-08 for Warrants - import as stocks
      if (pos('WTSWARRANTS', junk) > 0) then
        contracts := false;
      // changed 6-20-08 for Bonds and to not flag Preferred Stocks as bonds
      if (pos('%', junk) > 0) //
      and (pos('DUE', junk) > 0) //
      and (pos('/', junk) > 0) //
      and (pos('+', tick) = 0) //
      then begin
        while pos('  ', junk) > 0 do
          delete(junk, pos('  ', junk), 1);
        bonds := true;
      end;
      // if no other way to ID option...
      if not contracts then
        if (pos('CALL ', junk) = 1) //
        or (pos('PUT ', junk) = 1) then
          contracts := true;
      // --- options --------
      if contracts then begin
        if (pos(' C', tick) = length(tick) - 1) //
        or (pos(' P', tick) = length(tick) - 1) then begin
          // Schwab's new option symbol format:
          // WXYZ 05/22/2010 20.00 C
          opCP := parseLast(tick, ' ');
          if opCP = 'C' then
            opCP := 'CALL'
          else if opCP = 'P' then
            opCP := 'PUT';
          opStrike := parseLast(tick, ' ');
          opStrike := delTrailingZeros(opStrike);
          opYr := parseLast(tick, '/');
          delete(opYr, 1, 2);
          opDay := parseLast(tick, '/');
          opMon := parseLast(tick, ' ');
          opMon := getExpMo(opMon);
          tick := trim(tick);
          if rightStr(tick, 1) = '7' then begin
            delete(tick, length(tick), 1);
            miniOptions := true;
          end;
          tick := tick + ' ' + opDay + opMon + opYr + ' ' + opStrike + ' ' + opCP;
        end
        else begin
          optDesc := junk;
          if pos('type: EXPIRED', optDesc) > 0 then
            delete(optDesc, pos('type: EXPIRED', optDesc), 13);
          optDesc := trim(optDesc);
          // delete quotes, extra spaces
          while pos('"', optDesc) > 0 do
            delete(optDesc, pos('"', optDesc), 1);
          while pos('  ', optDesc) > 0 do
            delete(optDesc, pos('  ', optDesc), 1);
          opYr := parseLast(optDesc, '/');
          opDay := parseLast(optDesc, '/');
          opMon := parseLast(optDesc, ' ');
          opMon := getExpMo(opMon);
          junk := ParseLastN(optDesc, 'EXP');
          opStrike := trim(parseLast(optDesc, '$'));
          if pos('ADJ', opStrike) > 0 then
            delete(opStrike, pos('ADJ', opStrike), 3);
          opStrike := trim(opStrike);
          opCP := copy(optDesc, 1, pos(' ', optDesc) - 1);
          delete(optDesc, 1, pos(' ', optDesc));
          opUnder := optDesc;
          optDesc := tick;
          // BYY   100417C00 underlying is still not right - should be BBY, strike = zero
          // test if OPRA symbol ie: DNDN  100619C00
          tick := opUnder + ' ' + opDay + opMon + opYr + ' ' + opStrike + ' ' + opCP;
        end;
      end
      else begin
        optDesc := ''; // NOT an option contract
      end; // if
      // --- shares ---------
      if newColFormat then begin
        ShStr := lineLst[iShr]; //
        if optExpEx and (pos('-', ShStr) = 0) then
          ls := 'S';
      end;
      // --- price ----------
      PrStr := lineLst[iPr]; // trim(copy(line, 1, pos(sep, line) - 1));
      delete(PrStr, pos('$', PrStr), 1);
      PrStr := delCommas(PrStr); // 2018-03-12 MB - for prices > $999.99
      if optExpEx then
        PrStr := '0.00';
      // --- Amt/Com --------
      if newColFormat then begin
        // amount
//        if iAmt >= lineLst.count then begin // 2024.12.06 MB - experimental
//          sm('Bad record: Amount is missing' + CRLF // modify splitRecord
//          + line + CRLF // to allow user to enter amount OR to skip record.
//          + 'TradeLog will skip this record.');
//          dec(R);
//          Continue;
//        end;
        AmtStr := lineLst[iAmt]; // parseLast(line, sep);
        delete(AmtStr, pos('$', AmtStr), 1);
        AmtStr := delCommas(AmtStr);
        if optExpEx then
          AmtStr := '0.00';
        // cmStr
        CmStr := lineLst[iCm];
        delete(CmStr, pos('$', CmStr), 1);
        if optExpEx or (CmStr = '') or (pos('*', CmStr) > 0) then
          CmStr := '0.00';
      end
      else begin
        // cmStr
        CmStr := lineLst[iCm]; // parseLast(line, sep);
        delete(CmStr, pos('$', CmStr), 1);
        if optExpEx or (CmStr = '') or (pos('*', CmStr) > 0) then
          CmStr := '0.00';
        // amount
//        if iAmt >= lineLst.count then begin // 2024.12.06 MB - experimental
//          sm('Bad record: Amount is missing' + CRLF // modify splitRecord
//          + line + CRLF // to allow user to enter amount OR to skip record.
//          + 'TradeLog will skip this record.');
//          dec(R);
//          Continue;
//        end;
        AmtStr := lineLst[iAmt];
        delete(AmtStr, pos('$', AmtStr), 1);
        AmtStr := delCommas(AmtStr);
        if optExpEx then
          AmtStr := '0.00';
      end;
      // --- StrToFloat ---------------
      try
        if pos(',', ShStr) > 0 then // 2022-06-30 MB
          ShStr := replacestr(ShStr, ',', ''); // remove commas
        Shares := StrToFloat(ShStr, Settings.InternalFmt);
        if Shares = 0 then begin
          dec(R);
          Continue;
        end;
        if Shares < 0 then
          Shares := -Shares
        else if optExpEx then begin
          oc := 'O';
          ls := 'L';
        end;
        // --- Price --------
        if (trim(PrStr)= '') then
          Price := 0 // blank = $0
        else begin
          Price := StrToFloat(PrStr, Settings.InternalFmt);
          Price := ABS(Price);
        end;
        // --- Commis -------
        if (trim(CmStr)= '') then
          Commis := 0 // blank
        else
          Commis := StrToFloat(CmStr, Settings.InternalFmt);
        // --- Amount -------
        if (trim(AmtStr)= '') then
          AmtStr := '0'; // blank
        if (leftStr(AmtStr, 1)= '(') and (rightStr(AmtStr, 1)= ')') then
          AmtStr := '-' + copy(AmtStr,2,length(AmtStr)-2); // remove parentheses, add minus
        Amount := CurrToFloat(AmtStr);
        // --- comm
        if bonds then begin
          Commis := CurrToFloat(CmStr);
          if ((oc = 'C') and (ls = 'L')) // sell
          or ((oc = 'O') and (ls = 'S')) //
          then begin
            // test if price should be divided by 100
            if (Shares * Price / 99) + Commis > Amount then begin
              Price := (Amount + Commis) / Shares;
              tick := junk;
            end;
          end
          else begin
            // test if price should be divided by 100
            if (Shares * Price / 99) - Commis > Amount then begin
              Price := (Amount - Commis) / Shares;
              tick := junk;
            end;
          end;
          ImpTrades[R].prf := 'STK-1'; // 2017-04-26 MB need type-mult for BONDS
        end // bonds
        else if contracts then
          if miniOptions then begin
            mult := 10;
            ImpTrades[R].prf := 'OPT-10'
          end
          else begin
            mult := 100;
            ImpTrades[R].prf := 'OPT-100'
          end
        else begin
          mult := 1;
          ImpTrades[R].prf := 'STK-1';
        end;
        // --- Amt/Com ----------------
        // Price always > $0
        Price := abs(Price);
        // Shares always > 0
        // Shares := abs(Shares);
        mult := abs(mult);
        // Amount & Commis can be +/-
        // ----------------------------
        if ((oc = 'C') and (ls = 'L')) // -- SELL
        or ((oc = 'O') and (ls = 'S')) //
        then begin // SELL, so Amt > $0
          Amount := abs(Amount);
          Commis := (Shares * mult * Price) - Amount;
        end
        else begin // --- BUY, so Amt < $0 ------
          if (Amount > 0) then Amount := -Amount;
          Commis := (-Shares * mult * Price) - Amount;
        end;
        // ---
        ImpTrades[R].DT := ImpDate;
        ImpTrades[R].oc := oc;
        ImpTrades[R].ls := ls;
        ImpTrades[R].tk := trim(tick);
        ImpTrades[R].opTk := trim(optDesc);
        ImpTrades[R].sh := Shares;
        ImpTrades[R].pr := Price;
        ImpTrades[R].am := Amount;
        ImpTrades[R].cm := rndto8(Commis);
        ImpTrades[R].no := lineLst[iDes];
      except
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        dec(R);
        Continue;
      end;
      ImpTrades[R].it := TradeLogFile.Count + R;
    end;
    if R > 1 then
      if xStrToDate(ImpTrades[1].DT) > xStrToDate(ImpTrades[R].DT) then
        ReverseImpTradesDate(R);
    fixImpTradesOutOfOrder(R);
    if Adj then begin
      for i := 1 to R do begin
        StatBar('Matching Adjusting Entries: ' + IntToStr(i));
        for j := i downto 0 do begin
          if (ImpTrades[i].oc = 'X') and (ImpTrades[i].tk = ImpTrades[j].tk) and
            (format('%1.5f', [ImpTrades[i].sh], Settings.UserFmt) = format('%1.5f',
              [ImpTrades[j].sh], Settings.UserFmt)) and
            (format('%1.5f', [ImpTrades[i].pr], Settings.UserFmt) = format('%1.5f',
              [ImpTrades[j].pr], Settings.UserFmt)) and
            (format('%1.2f', [ImpTrades[i].am], Settings.UserFmt) = format('%1.2f',
              [ImpTrades[j].am], Settings.UserFmt)) and (ImpTrades[i].prf = ImpTrades[j].prf) and
            (i <> j) then begin
            ImpTrades[i].oc := '';
            ImpTrades[i].ls := '';
            ImpTrades[i].tm := '';
            ImpTrades[j].oc := '';
            ImpTrades[j].ls := '';
            ImpTrades[j].tm := '';
            break;
          end;
        end;
      end;
      for i := 1 to R do begin
        StatBar('Checking for Non-Matched Adjusting Entries: ' + IntToStr(i));
        if ImpTrades[i].oc = 'X' then begin
          sm('ADJUSTING ENTRIES COULD NOT BE MATCHED!' + cr + cr +
              'All Adjusting Entries have the Open/Close column ' + cr + 'marked with an "X"' + cr +
              cr + 'Please find these transactions and decide' + cr +
              'whether they should be matched and deleted' + cr + 'or otherwise');
          break;
        end;
      end;
      if AdjEntryStr <> '' then
        sm('Please note:' + cr + cr //
          + 'Schwab trades history report included an' + cr //
          + cr + AdjEntryStr //
          + cr + 'PLEASE VERIFY THESE TRANSACTIONS.');
    end;
    ImpStrList.Destroy;
    result := R;
  finally
    lineLst.Free;
  end;
end; // ReadSchwabCSV


// ----------------------------------------------
function ReadSchwab(): integer;
var
  R : integer;
begin
  try
    R := 0;
    ImpStrList := TStringList.Create;
    ImpTrades := nil;
    setLength(ImpTrades, R + 1);
    GetImpDateLast;
    if FileExists(Settings.ImportDir + '\download.csv') then
      deleteFile(Settings.ImportDir + '\download.csv');
    // ------------------------------------------
    GetImpStrListFromFile('Schwab', 'csv', '');
    result := ReadSchwabCSV(ImpStrList);
  finally
    // ReadSchwab
  end;
end;


// -----------------------------------+
// Scottrade
// -----------------------------------+

// ------------------------------------
// Read CSV from Scottrade-TDA
// ------------------------------------
function ReadTDAScottradeCSV(ImpStrList : TStringList): integer;
var
  i, j, k, R : integer;
  iDt, iTm, iTyp, iOC, iLS, iTk, iDesc, iShr, iPr, iAmt, iCm : integer; // import field numbers
  junk, sep, ImpDate, ImpTime, CmStr, feeStr, PrStr, AmtStr, ShStr, line, AdjEntryStr, //
    optDesc, optOC, opYr, opMon, opDay, opStrike, opCP, oc, ls, dd, mm, yyyy, errLogTxt : string;
  Amount, Commis, Fees, Shares, mult : double;
  contracts, Adj, optExpEx, ImpNextDateOn, bonds, newColFormat, miniOptions, futures, bFoundHeader,
    cancels : boolean;
  fieldLst, DescLst : TStrings;
  // --------------------------------------------
  // Fld Idx FieldName     Example
  // --------------------------------------------
  // ----- NEW FORMAT -----
  // DT  00  DATE           1/5/2017
  // 01  TRANSACTION ID 2734537703
  // DES 02* DESCRIPTION    Bought 50 VEEV @ 41.235
  // Sold 2 LOW   180119C00092500 Jan 19 2018 92.5 Call @ 1.55
  // SH  03  QUANTITY       50
  // TK  04  SYMBOL         VEEV
  // LOW   180119C00092500 Jan 19 2018 92.5 Call
  // PR  05  PRICE          41.235
  // CM  06  COMMISSION     8.35
  // AMT 07  AMOUNT         -2068.75
  // (other fields follow, but are ignored)
  // --------------------------------------------
  procedure SetFieldNums();
  var
    j : integer;
  begin
    // Scottrade 2018
    k := 0;
    for j := 0 to (fieldLst.Count - 1) do begin
      if fieldLst[j] = 'DATE' then begin
        iDt := j;
        k := k or 1;
      end
      else if fieldLst[j] = 'DESCRIPTION' then begin
        iDesc := j;
        k := k or 2;
      end
      else if fieldLst[j] = 'QUANTITY' then begin
        iShr := j;
        k := k or 4;
      end
      else if fieldLst[j] = 'SYMBOL' then begin
        iTk := j;
        k := k or 8;
      end
      else if fieldLst[j] = 'PRICE' then begin
        iPr := j;
        k := k or 16;
      end
      else if fieldLst[j] = 'COMMISSION' then begin
        iCm := j;
        k := k or 32;
      end
      else if fieldLst[j] = 'AMOUNT' then begin
        iAmt := j;
        k := k or 64;
      end;
      // good = 127
    end;
  end;
// --------------------------------------------
begin
  // ReadTDAScottradeCSV
  bFoundHeader := false; // let's us know we haven't found the header yet
  iDt := 0;
  iTk := 0;
  iDesc := 0;
  iShr := 0;
  iPr := 0;
  iAmt := 0;
  // in case these are missing, flag to skip them.
  // iCm := -1;
  iTm := -1;
  cancels := false;
  R := 0;
  DataConvErrRec := '';
  DataConvErrStr := '';
  // --------------------------------
  GetImpDateLast;
  try
    // created 2018-04-12 MB
    AdjEntryStr := '';
    DataConvErrRec := '';
    DataConvErrStr := '';
    Adj := false;
    ImpNextDateOn := false;
    newColFormat := false;
    if ImpStrList.Count < 1 then begin
      ImpStrList.Destroy;
      result := 0;
      exit;
    end;
    fieldLst := TStrings.Create;
    DescLst := TStrings.Create;
    // --------------------------------
    i := -1;
    while i < (ImpStrList.Count - 1) do begin
      inc(i); // make it work like a for/next
      contracts := false;
      futures := false;
      miniOptions := false;
      optExpEx := false;
      bonds := false;
      // ------------------------------
      line := ImpStrList[i];
      line := uppercase(line); // UPPERCASE string tokens
      // ------------------------------
      if pos('ERROR', line) > 0 then begin
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        sm('Scottrade reported an error.' + cr + 'Please reduce the date range and try again.');
        result := 0;
        exit;
      end;
      // ------------------------------
      fieldLst := ParseCSV(line); // parse all columns into string list
      // ------------------------------
      // Determine File Format
      // ------------------------------
      if not bFoundHeader then begin
        if (pos('DATE', line) > 0) //
          and (pos('DESCRIPTION', line) > 0) //
          and (pos('QUANTITY', line) > 0) //
          and (pos('SYMBOL', line) > 0) //
        then begin // new format
          SetFieldNums;
          if k = 127 then begin
            bFoundHeader := true; // don't do this anymore
            R := 0; // start now
          end
          else if SuperUser then begin
            sm('there appear to be fields missing:' + cr //
                + line);
          end;
        end;
        Continue; // don't process anything until we recognize the header
      end;
      // ------------------------------
      if fieldLst.Count < 8 then
        Continue; // bad line
      if pos('MISCELLANEOUS JOURNAL ENTRY', fieldLst[iDesc]) > 0 then
        Continue; // skip
      if pos('ORDINARY DIVIDEND', fieldLst[iDesc]) > 0 then
        Continue; // skip
      if pos('REDEMPTION', fieldLst[iDesc]) > 0 then
        Continue; // skip
      // ------------------------------
      // --- Date ---------------------
      ImpDate := fieldLst[iDt]; // format already MM/DD/YYYY
      if pos('/', ImpDate) < 2 then
        Continue; // not a valid date
      if not isdate(ImpDate) then
        sm('Cannot determine the transaction date of this trade:' + cr + line);
      if not ValidTradeDate(ImpDate, ImpDateLast, ImpNextDateOn) then begin
        // DataConvErrRec := DataConvErrRec + 'invalid date: ' + ImpStrList[i] + cr;
        Continue;
      end;
      inc(R); // if it gets this far, count it
      // No Time of day in this format
      ImpTime := '';
      // --- OC and LS ---
      // I've never seen a short, so assume all are long for now
      if pos('BOUGHT', fieldLst[iDesc]) = 1 then begin
        oc := 'O';
        ls := 'L';
      end
      else if pos('SOLD', fieldLst[iDesc]) = 1 then begin
        oc := 'C';
        ls := 'L';
      end
      else begin // error
        DataConvErrRec := DataConvErrRec + 'unknown OC/LS: ' + ImpStrList[i] + cr;
        oc := 'E';
        ls := 'E';
        dec(R);
        Continue;
      end;
      // --- # shares ---
      ShStr := fieldLst[iShr];
      ShStr := delCommas(ShStr);
      // --- ticker ---
      tick := trim(fieldLst[iTk]);
      // is it an option?
      if (pos(' ', tick) > 0) and (length(tick) > 6) then
        contracts := true
      else
        contracts := false;
      // --- options --------
      // Scottrade Option Format as of 4/12/2018 MB
      // Description = Symbol + ' @ ' + Price (with QTY inserted in Symbol)
      // OC  Qty Tk   OptionTicker    MMM DD YYYY Strk C/P    Price
      // DESCRIPTION: Sold 2 LOW   180119C00092500 Jan 19 2018 92.5 Call @ 1.55
      // SYMBOL:             LOW   180119C00092500 Jan 19 2018 92.5 Call
      // QUANTITY: 2                                        PRICE: 1.55
      // ALSO, the OptionTicker code appears to match as well:
      // 18-01-19 C 00092.500
      // YY-MM-DD * $$$$$.000
      if contracts then begin
        // parse the option ticker
        optDesc := fieldLst[iDesc];
        if length(optDesc) < 9 then
          contracts := false
        else begin
          junk := parsefirst(optDesc, ' '); // Bought or Sold (not used here)
          junk := parsefirst(optDesc, ' '); // Shares (not used here)
          tick := parsefirst(optDesc, ' '); // Ticker
          optDesc := trim(optDesc); // may contain more than one space
          junk := parsefirst(optDesc, ' '); // Option Ticker (not used)
          opMon := parsefirst(optDesc, ' '); // MMM
          opDay := parsefirst(optDesc, ' '); // DD
          opYr := parsefirst(optDesc, ' '); // YYYY
          opYr := rightStr(opYr, 2); // YY
          opStrike := parsefirst(optDesc, ' ');
          opStrike := delTrailingZeros(opStrike);
          opCP := parsefirst(optDesc, ' '); // CALL or PUT
          if (opCP <> 'CALL') and (opCP <> 'PUT') then
            contracts := false;
        end;
      end;
      // --------------------
      if contracts then begin
        optDesc := tick + ' ' + opDay + opMon + opYr + ' ' + opStrike + ' ' + opCP;
        // EX: MSFT 21DEC17 15 CALL
      end
      else
        optDesc := ''; // NOT an option contract
      // --------------------
      // --- price ---
      PrStr := fieldLst[iPr];
      delete(PrStr, pos('$', PrStr), 1);
      PrStr := delCommas(PrStr);
      // --- amount ---
      AmtStr := fieldLst[iAmt];
      if (pos('$', AmtStr) > 0) then
        delete(AmtStr, pos('$', AmtStr), 1);
      AmtStr := delCommas(AmtStr);
      if (AmtStr = '') or (pos('*', AmtStr) > 0) then
        AmtStr := '0.00';
      // --------------------
      try
        Shares := StrToFloat(ShStr, Settings.InternalFmt);
        if Shares = 0 then begin
          dec(R);
          Continue;
        end;
        if Shares < 0 then
          Shares := -Shares;
        // ----------------------------
        Price := StrToFloat(PrStr, Settings.InternalFmt);
        // Commis := StrToFloat(CmStr, Settings.InternalFmt);
        // Fees := StrToFloat(FeeStr, Settings.InternalFmt);
        if (leftStr(AmtStr, 1)= '(') and (rightStr(AmtStr, 1)= ')') then
          AmtStr := '-' + copy(AmtStr, 2, length(AmtStr)- 2);
        Amount := CurrToFloat(AmtStr);
        if Amount < 0 then begin
          // sm('negative amount' + CR + 'OC = ' + oc + CR + 'ls = ' + LS);
          Amount := -Amount;
        end;
        // ----------------------------
        if contracts then begin
          mult := 100;
          ImpTrades[R].prf := 'OPT-100';
          tick := optDesc;
        end
        else if futures then begin
          mult := 100;
          ImpTrades[R].prf := 'FUT-0';
        end
        else begin
          mult := 1;
          ImpTrades[R].prf := 'STK-1';
        end;
        // ----------------------------
        // ignore the comm and fees fields and just calculate commission
        if ((oc = 'C') and (ls = 'L')) or ((oc = 'O') and (ls = 'S')) then
          Commis := Amount - (Shares * mult * Price)
        else
          Commis := (Shares * mult * Price) - Amount;
        if Commis < 0 then
          Commis := -Commis;
        // ----------------------------
        ImpTrades[R].DT := ImpDate;
        ImpTrades[R].tm := ImpTime;
        ImpTrades[R].oc := oc;
        ImpTrades[R].ls := ls;
        ImpTrades[R].tk := trim(tick);
        ImpTrades[R].opTk := ''; // trim(optDesc);
        ImpTrades[R].sh := Shares;
        ImpTrades[R].pr := Price;
        ImpTrades[R].am := Amount;
        ImpTrades[R].cm := rndto2(Commis) + rndto2(Fees);
      except
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        dec(R);
        Continue;
      end;
      ImpTrades[R].it := TradeLogFile.Count + R;
    end;
    // --------------------------------
    if cancels then begin
      for i := 1 to R do begin
        if (ImpTrades[i].oc <> 'X') then
          Continue; // not a cancel
        StatBar('Matching Cancelled Trades: ' + IntToStr(i));
        for j := (i + 1) downto 1 do begin // NOTE: CANCEL can come before OR after trade to cancel
          if j > R then
            Continue; // don't go out of bounds
          if (ImpTrades[i].tk <> ImpTrades[j].tk) then
            Continue; // not same ticker
          // could be a match, let's check the rest...
          if (format('%1.5f', [ImpTrades[i].sh], Settings.UserFmt) = format('%1.5f',
              [ImpTrades[j].sh], Settings.UserFmt)) //
            and (format('%1.5f', [ImpTrades[i].pr], Settings.UserFmt) = format('%1.5f',
              [ImpTrades[j].pr], Settings.UserFmt)) //
            and (format('%1.2f', [ImpTrades[i].cm], Settings.UserFmt) = format('%1.2f',
              [ImpTrades[j].cm], Settings.UserFmt)) //
            and (ImpTrades[i].prf = ImpTrades[j].prf) //
            and (ImpTrades[j].oc <> '') and (i <> j) then begin
            // with ImpTrades[i] do msgTxt:= msgTxt+dt+tab+tk+tab+oc+ls+tab+floatToStr(sh)+tab+floatToStr(pr)+tab+floatToStr(am)+cr;
            glNumCancelledTrades := glNumCancelledTrades + 2;
            // --- I ---
            ImpTrades[i].oc := '';
            ImpTrades[i].ls := '';
            ImpTrades[i].tm := '';
            // --- J ---
            ImpTrades[j].oc := '';
            ImpTrades[j].ls := '';
            ImpTrades[j].tm := '';
            break;
          end; // if everything else matches
        end; // for j = 1 downto
      end; // for i = 1 to R
    end; // if cancels
    // --------------------------------
    ImpStrList.Destroy;
    result := R;
  finally
    fieldLst.Free;
    if length(DataConvErrRec) > 1 then begin
      AssignFile(ErrLog, Settings.DataDir + '\error.log');
      rewrite(ErrLog);
      errLogTxt := 'ERROR :' + msgTxt + '; Detailed Message: ' + '"' + DataConvErrRec + '"';
      try
        write(ErrLog, errLogTxt);
        errLogTxt := '';
      finally
        CloseFile(ErrLog);
      end;
    end; // end if DataConvErrRec
    // ReadTDAScottradeCSV
  end;
end;

// ----- OLD FORMAT ---------
// DT	DATE	1/5/2017	1/2/2018
// TRANS ID	2734537703	2808150780
// DES	DESCRIPN	Bought 50 VEEV @ 41.235	Sold 2 LOW   180119C00092500 Jan 19 2018 92.5 Call @ 1.55
// SH	QUANTITY	50	2
// TK	SYMBOL  	VEEV	LOW   180119C00092500 Jan 19 2018 92.5 Call
// PR	PRICE   	41.235	1.55
// CM	COMMISSN	7	8.35
// AMT	AMOUNT  	-2068.75	301.65
// (other fields follow, but are ignored)
// WHERE OC, LS COME FROM DES AND WHERE OPT COMES FROM TK
// --------------------------
function ReadScottradeCSV(ImpStrList : TStringList): integer;
var
  i, j, R : integer;
  ImpDate, tmStr, CmStr, PrStr, prfStr, AmtStr, ShStr, line, sep, strike, exDay, exMo, exYr, cp,
    opTk : string;
  Shares, Amount : double;
  ImpNextDateOn, isBond, contracts, cancels, settleDate, interest : boolean;
  oc, ls : string;
  Comm : double;
begin
  try
    DataConvErrRec := '';
    DataConvErrStr := '';
    R := 0;
    sep := ',';
    cancels := false;
    settleDate := false;
    interest := false;
    isBond := false;
    ImpNextDateOn := false;
    if ImpStrList.Count < 1 then begin
      ImpStrList.Destroy;
      result := 0;
      exit;
    end;
    for i := 0 to ImpStrList.Count - 1 do begin
      contracts := false;
      inc(R);
      if R < 1 then
        R := 1;
      line := uppercase(ImpStrList[i]); // to be case insensitive 2016-10-24 MB
      // also changed string constants to uppercase
      prfStr := '';
      // delete all quotes if line begins with " // 2001-03-19 DE
      if pos('"', line) = 1 then begin
        while pos('"', line) > 0 do
          delete(line, pos('"', line), 1);
      end;
      // BOTH SettleDate AND Interest
      if (pos('SETTLEDDATE', line) > 0) and (pos('INTEREST', line) > 0) then begin
        settleDate := true;
        interest := true;
        dec(R);
        Continue;
      end;
      // ONLY SettleDate
      if pos('SETTLEDDATE', line) > 0 then begin
        settleDate := true;
        dec(R);
        Continue;
      end;
      // ONLY Interest
      if pos('INTEREST', line) > 0 then begin
        interest := true;
        dec(R);
        Continue;
      end;
      // Skip Option Expires and Excercise/Assigns
      if (pos('OPTION EXPIRED', line) > 0) or (pos('OPTION ASSIGNED', line) > 0) then begin
        dec(R); // skip expires and assignments 2016-10-24 MB
        Continue;
      end;
      // compensate for trade # in 1st column - 03/27/2001
      if not contracts then begin
        if (pos('EQUITY ', line) > 0) then
          delete(line, 1, pos('EQUITY ', line) + 7);
        if (pos('BOND ', line) > 0) then
          delete(line, 1, pos('BOND ', line) + 5);
        if (pos('FUND ', line) > 0) then
          delete(line, 1, pos('FUND ', line) + 5);
      end;
      // ticker
      tick := trim(copy(line, 1, pos(sep, line) - 1));
      // delete(tick, pos('#', tick), 1);
      opTk := tick;
      // don't import old option tickers with # signs - these are options expires
      if pos('#', tick) > 1 then begin
        contracts := true;
        delete(tick, pos('#', tick), 1);
      end
      else if pos('.', tick) = 1 then begin
        contracts := true;
        delete(tick, pos('.', tick), 1);
      end
      else if (pos('CONTRACTS OF OPTION', line) > 0) then begin
        // new format: "FEW 17.00 FEB 10 C"
        contracts := true;
        exDay := '';
        cp := parseLast(tick, ' ');
        if cp = 'C' then
          cp := 'CALL'
        else if cp = 'P' then
          cp := 'PUT';
        // test for new option format:
        // 2014-03-20 "SPY JAN 25 2013 149.50 C"
        exYr := parseLast(tick, ' ');
        if (pos('.', exYr)> 0) then begin
          strike := exYr;
          // fix for 1200.00 getting imported as 12
          while (rightStr(strike, 1)= '0') do
            delete(strike, length(strike), 1);
          if (rightStr(strike, 1)= '.') then
            delete(strike, length(strike), 1);
          exYr := parseLast(tick, ' ');
          if (length(exYr)= 4) then
            exYr := rightStr(exYr, 2);
          exDay := parseLast(tick, ' ');
          exMo := parseLast(tick, ' ');
          tick := tick + ' ' + exDay + exMo + exYr + ' ' + strike + ' ' + cp;
        end
        else begin
          // test for weekly options
          // BIDU 135.00 AUG 11 WK4 C
          if (pos('WK', exYr) = 1) then begin
            exDay := rightStr(exYr, 1);
            exYr := parseLast(tick, ' ');
            exMo := parseLast(tick, ' ');
            exDay := getExDayFromWeek(exDay, exMo, exYr);
            if exDay = '' then begin
              mDlg(opTk + cr + cr + 'This was erroneously reported as a WEEK 5 weekly option,' + cr
                  + 'however, there were only 4 Fridays in ' + exMo + ' 20' + exYr + cr + cr +
                  'Therefore, these will be imported as standard monthly options', mtError,
                [mbOK], 1);
              // DataConvErrRec:= DataConvErrRec + ImpStrList[i]+cr;
            end;
          end
          // test for quarterly options
          // LVS 44.00 SEP 11 Q3 C
          else if (pos('Q1', exYr) > 0) or (pos('Q4', exYr) > 0) then begin
            exDay := '31';
            exYr := parseLast(tick, ' ');
            exMo := parseLast(tick, ' ');
          end
          else if (pos('Q2', exYr) > 0) or (pos('Q3', exYr) > 0) then begin
            exDay := '30';
            exYr := parseLast(tick, ' ');
            exMo := parseLast(tick, ' ');
          end
          else
            exMo := parseLast(tick, ' ');
          // end if
          strike := parseLast(tick, ' ');
          strike := delTrailingZeros(strike);
          tick := tick + ' ' + exDay + exMo + exYr + ' ' + strike + ' ' + cp;
        end;
      end;
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // shares
      ShStr := trim(copy(line, 1, pos(sep, line) - 1));
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // price
      PrStr := copy(line, 1, pos(sep, line) - 1);
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // long/short
      if pos('SHORT', line) > 0 then begin
        ls := 'S';
        delete(line, pos('SHORT', line) - 2, 7);
      end
      else
        ls := 'L';
      // open/close
      oc := uppercase(trim(copy(line, 1, pos(sep, line) - 1)));
      if pos('SOLD SHORT', line) > 0 then begin
        oc := 'O';
        ls := 'S';
      end
      else if pos('BOUGHT TO COVER', line) > 0 then begin
        oc := 'C';
        ls := 'S';
      end
      else if (pos('CXL', oc) > 0) or (pos('CANCEL', oc) > 0) then begin
        cancels := true;
        oc := 'X';
      end
      else if (pos('BUY TO OPEN', oc) > 0) then begin
        oc := 'O';
        ls := 'L';
      end
      else if (pos('BUY TO CLOSE', oc) > 0) then begin
        oc := 'C';
        ls := 'S';
      end
      else if (pos('SELL TO OPEN', oc) > 0) then begin
        oc := 'O';
        ls := 'S';
      end
      else if (pos('SELL TO CLOSE', oc) > 0) then begin
        oc := 'C';
        ls := 'L';
      end
      else if (pos('DIVIDEND REINVEST', oc) > 0) then begin
        oc := 'O';
      end
      else if (pos('BUY', oc) > 0) then begin
        if ls = 'L' then
          oc := 'O'
        else
          oc := 'C';
      end
      else if (pos('SELL', oc) > 0) then begin
        if ls = 'L' then
          oc := 'C'
        else
          oc := 'O';
      end
      else if (oc = 'EXPIRED') or (oc = 'OPTION EXERCISED') or (oc = 'OPTION ASSIGNED') then begin
        if (oc = 'EXPIRED') then
          contracts := true;
        if pos('-', ShStr) > 0 then begin
          oc := 'C';
          ls := 'L'
        end
        else begin
          oc := 'C';
          ls := 'S'
        end;
      end
      else if (oc = 'STOCK RECEIPT') and (rightStr(tick, 2) <> ' C') and (rightStr(tick, 2) <> ' P')
      then begin
      // ie: C 5.00 MAR 10 C,20,0,Stock Receipt, <-- is an option
        if ls = 'L' then
          oc := 'O'
        else
          oc := 'C';
      end
      else if (oc = 'STOCK DIVIDEND') then begin
        oc := 'O';
      end
      else if (oc = 'STOCK ADJUSTMENT') or (oc = 'STOCK DELIVERY') then begin
        // OC:= 'O';
        dec(R);
        Continue;
      end
      else begin
        dec(R);
        Continue;
      end;
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // date
      ImpDate := trim(copy(line, 1, pos(sep, line) - 1));
      if pos('/', ImpDate) <= 0 then begin
        dec(R);
        Continue;
      end;
      ImpDate := LongDateStr(ImpDate);
      if not ValidTradeDate(ImpDate, ImpDateLast, ImpNextDateOn) then begin
        dec(R);
        Continue;
      end;
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // settle date
      if settleDate then begin
        delete(line, 1, pos(sep, line));
        line := trim(line);
      end;
      // interest
      if interest then begin
        delete(line, 1, pos(sep, line));
        line := trim(line);
      end;
      // princ
      if pos('"', line) > 0 then begin
        delete(line, 1, pos('.', line) + 4);
        line := trim(line);
      end
      else begin
        delete(line, 1, pos(sep, line));
        line := trim(line);
      end;
      // comm
      CmStr := copy(line, 1, pos(sep, line) - 1);
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // fees
      delete(line, 1, pos(sep, line));
      line := trim(line);
      if settleDate then begin
        delete(line, 1, pos(sep, line)); // cusip
        delete(line, 1, pos(sep, line)); // descr
        delete(line, 1, pos(sep, line)); // ActionID
        tmStr := ''; // copy(line, 1, pos(sep, line) - 1);
        // no longer use TrNum as time field
      end
      else begin
        while pos('"', line) > 0 do
          delete(line, pos('"', line), 1);
        if pos('MARGIN', line) > 0 then
          AmtStr := copy(line, 1, pos('MARGIN', line) - 2)
        else if pos('CASH', line) > 0 then
          AmtStr := copy(line, 1, pos('CASH', line) - 2)
        else if pos('SCOTTRADE', line) > 0 then
          AmtStr := copy(line, 1, pos('SCOTTRADE', line) - 2)
        else
          AmtStr := trim(line);
      end;
      // ------------------------------
      try
        Shares := StrToFloat(ShStr, Settings.InternalFmt);
        if Shares < 0 then
          Shares := -Shares;
        if prfStr = '' then begin
          if contracts then
            prfStr := 'OPT-100'
          else
            prfStr := 'STK-1';
        end;
        Price := StrToFloat(PrStr, Settings.InternalFmt);
        if Price < 0 then
          Price := -Price;
        if isBond then
          Price := Price / 100;
        Comm := StrToFloat(CmStr, Settings.InternalFmt);
        if Comm < 0 then
          Comm := -Comm;
        Amount := 0; // why not use AmtStr? - MB
        // ------------------
        ImpTrades[R].it := TradeLogFile.Count + R;
        ImpTrades[R].DT := ImpDate;
        ImpTrades[R].tm := tmStr;
        ImpTrades[R].oc := oc;
        ImpTrades[R].ls := ls;
        ImpTrades[R].tk := tick;
        ImpTrades[R].sh := Shares;
        ImpTrades[R].pr := Price;
        ImpTrades[R].prf := prfStr;
        ImpTrades[R].cm := Comm;
        ImpTrades[R].am := Amount;
      except
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        dec(R);
        Continue;
      end;
    end;
    if R > 0 then
      if xStrToDate(ImpTrades[1].DT) > xStrToDate(ImpTrades[R].DT) then
        ReverseImpTradesDate(R);
    // ----------------------
    if cancels then begin
      for i := 1 to R do begin
        if (ImpTrades[i].oc = 'X') then
          for j := 1 to R do begin
            if (ImpTrades[i].tk = ImpTrades[j].tk) and (ImpTrades[i].sh = ImpTrades[j].sh) and
              (ImpTrades[i].pr = ImpTrades[j].pr) and
              (format('%1.2f', [ImpTrades[i].cm], Settings.UserFmt) = format('%1.2f',
                [ImpTrades[j].cm], Settings.UserFmt)) and (ImpTrades[j].oc <> '') and (i <> j) then
            begin
              // i
              ImpTrades[i].oc := '';
              ImpTrades[i].ls := '';
              // j
              ImpTrades[j].oc := '';
              ImpTrades[j].ls := '';
              break;
            end;
          end;
      end;
    end;
    // ----------------------
    for i := 1 to R do begin
      if ImpTrades[i].oc = 'X' then begin
        sm('CANCEL TRADES NOT MATCHED!' + cr + cr +
            'Cancel Trades have Open/Close marked with an "X"');
        break;
      end;
    end;
    ImpStrList.Destroy;
    result := R;
  finally
    // ReadScottradeCSV
  end;
end;


function ReadScottrade(): integer;
var
  R : integer;
  line : string;
  // ------------------------
  function OldScottradeFormat : boolean;
  begin
    line := uppercase(line); // UPPERCASE string tokens
    if (pos('SYMBOL', line) > 0) //
      and (pos('QUANTITY', line) > 0) //
      and (pos('PRICE', line) > 0) //
      and (pos('ACTIONNAMEUS', line) > 0) //
      and (pos('TRADEDATE', line) > 0) //
      and (pos('RECORDTYPE', line) > 0) //
    then // old format
      result := true
    else
      result := false;
    exit;
  end;
// ------------------------
begin // ReadScottrade
  try
    R := 0;
    ImpStrList := TStringList.Create;
    ImpTrades := nil;
    setLength(ImpTrades, R + 1);
    GetImpDateLast;
    if FileExists(Settings.ImportDir + '\download.csv') then
      deleteFile(Settings.ImportDir + '\download.csv');
    // --------------------------------
    // options: File, BC
    if sImpMethod = 'BC' then begin // BrokerConnect
      formGet.showmodal;
      if cancelURL then
        exit;
//      if OFX then
//        exit(-1);
      sleep(1000);
      GetImpStrListFromFile('', '', Settings.ImportDir + '\download.csv');
      line := ImpStrList[0];
      if OldScottradeFormat then // old format
        result := ReadScottradeCSV(ImpStrList) // old format
      else
        result := ReadTDAScottradeCSV(ImpStrList); // new format
      exit;
    end
    // ----------------------
    else if sImpMethod = 'File' then begin // CSV Import
      GetImpStrListFromFile('Scottrade', 'csv', '');
      line := ImpStrList[0];
      if OldScottradeFormat then
        result := ReadScottradeCSV(ImpStrList) // old format
      else
        result := ReadTDAScottradeCSV(ImpStrList); // new format
      exit;
    end; // case block
    // ----------------------
  finally
    // ReadScottrade
  end;
end;

    // ----------------------
    // SWS
    // ----------------------

function ReadSWS(): integer;
var
  i, R : integer;
  Shares, mult, Commis : double;
  ImpDate, TimeStr, ShStr, PrStr, prfStr, AmtStr, DataErr, linestr, DataStr : string;
  MargImpDir, TradeNbr : string;
  Amount : double;
  TradeNbrs, MargFileList : TStringList;
  exceptionTrades : boolean;
  oc, ls : string;
begin
  try
    DataConvErrRec := '';
    DataConvErrStr := '';
    TradeNbrs := TStringList.Create;
    MargFileList := TStringList.Create;
    TradeNbrs.sorted := true;
    TradeNbrs.clear;
    MargFileList.clear;
    Amount := 0;
    Commis := 0;
    R := 0;
    Shares := 0;
    DataErr := '';
    DataStr := '';
    linestr := '';
    exceptionTrades := false;
    MargImpDir := Settings.InstallDir + '\margin';
    GetImpDateLast;
    ImpStrList := TStringList.Create;
    GetImpStrListFromClip(false);
    ImpDate := '';
    if ImpStrList.Count < 1 then begin
      ImpStrList.Destroy;
      result := 0;
      exit;
    end;
    for i := 0 to ImpStrList.Count - 1 do begin
      inc(R);
      if R < 1 then
        R := 1;
      // get one line at a time
      linestr := trim(ImpStrList[i]);
      // start importing non day trades
      if (pos('Non Day Trades', linestr) > 0) or exceptionTrades then begin
        exceptionTrades := false;
        dec(R);
        Continue;
      end;
      // skip exception trades
      if (pos('Exception Trades', linestr) > 0) or exceptionTrades then begin
        exceptionTrades := true;
        dec(R);
        Continue;
      end;
      // end import Reg T Trades
      if pos('Reg T Trades', linestr) > 0 then begin
        dec(R);
        break;
      end;
      if (ImpDate = '') and (pos('Trade Date', linestr) > 0) then begin
        // valid margin report                          DATE
        ImpDate := copy(linestr, pos('Trade Date', linestr) + 11, 10);
        ImpDate := trim(ImpDate);
        if ImpDate = '' then
          if mDlg('No data to import', mtWarning, [mbNo, mbYes], 0) = mrNo then begin
            result := 0;
            exit;
          end;
        // check if report already imported
        if IsLongDate(ImpDate) then begin
          ImpDate := LongDateStr(ImpDate);
          if UserDateStrNotGreater(ImpDate, ImpDateLast) then begin
            if mDlg('Trades already imported for ' + ImpDate + cr + cr //
                + 'Continue?', mtWarning, [mbNo, mbYes], 0) = mrNo //
            then begin
              result := 0;
              exit;
            end
            else

              ImpDateLast := LongDateStr('01/01/1900');
          end;
        end;
        dec(R);
        Continue;
      end;
      // test for cancelled trades & skip
      if (pos('Cancelled Trade', linestr) > 0) or (pos('As Of Trade', linestr) > 0) then begin
        dec(R);
        delete(DataStr, 1, pos('<BR>', DataStr) + 4);
        Continue;
      end;
      { time }
      TimeStr := copy(linestr, 1, 5);
      // skip lines that have no time
      if pos(':', TimeStr) <> 3 then begin
        dec(R);
        delete(DataStr, 1, pos('<BR>', DataStr) + 3);
        Continue;
      end;
      delete(linestr, 1, 5);
      // test for Exception Trades - do not inlcude
      TradeNbr := trim(copy(linestr, 1, 11));
      if pos('/', TradeNbr) > 0 then begin
        // skip lines where Trade Nbr is a date - cancel order
        dec(R);
        delete(DataStr, 1, pos('<BR>', DataStr) + 4);
        Continue;
      end;
      delete(linestr, 1, 11);
      { long/short }
      ls := trim(copy(linestr, 1, 2));
      if (ls = 's') or (ls = 'S') then
        ls := 'S'
      else if ls = 'm' then
        ls := 'L';
      delete(linestr, 1, 2);
      { open/close }
      oc := lowercase(trim(copy(linestr, 1, 2)));
      if ls = 'L' then begin
        if oc = 'b' then
          oc := 'O'
        else if oc = 's' then
          oc := 'C';
      end
      else if ls = 'S' then begin
        if oc = 'b' then
          oc := 'C'
        else if oc = 's' then
          oc := 'O';
      end;
      delete(linestr, 1, 2);
      linestr := trim(linestr);
      // Shares
      ShStr := trim(copy(linestr, 1, pos(' ', linestr) - 1));
      ShStr := delCommas(ShStr);
      delete(ShStr, pos('L', ShStr), 1);
      delete(ShStr, pos('S', ShStr), 1);
      // delete(LineStr,1,9);
      delete(linestr, 1, pos(' ', linestr));
      linestr := trim(linestr);
      // tick
      tick := trim(copy(linestr, 1, pos(' ', linestr) - 1));
      delete(linestr, 1, pos(' ', linestr));
      linestr := trim(linestr);
      // Price
      // space between ticker and price, and price and amount
      PrStr := trim(copy(linestr, 1, pos(' ', linestr) - 1));
      PrStr := delCommas(PrStr);
      // delete(LineStr,1,13);
      delete(linestr, 1, pos(' ', linestr));
      linestr := trim(linestr);
      // Amount
      AmtStr := trim(copy(linestr, 1, pos('.', linestr) + 2));
      AmtStr := delCommas(AmtStr);
      // delete line
      delete(DataStr, 1, pos('<BR>', DataStr) + 3);
      mult := 1;
      prfStr := 'STK-1';
      try
        Shares := StrToFloat(ShStr, Settings.InternalFmt);
        if Shares < 0 then
          Shares := -Shares;
        Price := StrToFloat(PrStr, Settings.InternalFmt);
        Amount := StrToFloat(AmtStr, Settings.InternalFmt);
        if Amount < 0 then
          Amount := -Amount;
        // test for options
        if (oc = 'O') then begin
          if (rndto2((Shares * Price * 100) - 5) <= rndto2(Amount)) and
            (rndto2((Shares * Price * 100) + 5) >= rndto2(Amount)) then begin
            mult := 100;
            prfStr := 'OPT-100';
          end;
        end
        else if (oc = 'C') then begin
          if (rndto2((Shares * Price * 100) + 5) >= rndto2(Amount)) and
            (rndto2((Shares * Price * 100) - 5) <= rndto2(Amount)) then begin
            mult := 100;
            prfStr := 'OPT-100';
          end;
        end;
        if pos('.FEE', tick) <= 0 then
          // if it's a sale
          if ((oc = 'C') and (ls = 'L')) or ((oc = 'O') and (ls = 'S')) then begin
            Commis := (Shares * Price * mult) - Amount;
          end
          else
            Commis := Amount - (Shares * Price * mult);
      except
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr + lf;
        dec(R);
        Continue;
      end;
      setLength(ImpTrades, R + 1);
      ImpTrades[R].it := TradeLogFile.Count + R;
      ImpTrades[R].DT := ImpDate;
      ImpTrades[R].tm := TimeStr;
      ImpTrades[R].oc := oc;
      ImpTrades[R].ls := ls;
      ImpTrades[R].tk := tick;
      ImpTrades[R].sh := Shares;
      ImpTrades[R].pr := Price;
      ImpTrades[R].prf := prfStr;
      ImpTrades[R].am := Amount;
      ImpTrades[R].cm := Commis;
      if pos('FEE', tick) > 0 then begin
        ImpTrades[R].tr := -2;
        ImpTrades[R].tk := 'Fee';
        ImpTrades[R].oc := '';
        ImpTrades[R].ls := '';
        ImpTrades[R].am := -Amount;
        ImpTrades[R].cm := 0;
      end;
      // end; {while not EOF}
      // end;  {for j}
    end;
    result := R;
    TradeNbrs.Destroy;
  finally
    // ReadSWS
  end;
end;

    // ----------------------
    // SLK
    // ----------------------

function ReadSLKcsv(): integer;
var
  i, p, R : integer;
  Shares, mult, Commis, Princ : double;
  PrincStr, line, sep, ImpDate, ShStr, PrStr, prfStr, AmtStr : string;
  contracts : boolean;
  oc, ls : string;
begin
  try
    DataConvErrRec := '';
    DataConvErrStr := '';
    Commis := 0;
    R := 0;
    ImpStrList := TStringList.Create;
    ImpTrades := nil;
    setLength(ImpTrades, R + 1);
    GetImpDateLast;
    GetImpStrListFromFile('SLK', 'csv', '');
    sep := ',';
    if ImpStrList.Count < 1 then begin
      ImpStrList.Destroy;
      result := 0;
      exit;
    end;
    for i := 0 to ImpStrList.Count - 1 do begin
      contracts := false;
      inc(R);
      if R < 1 then
        R := 1;
      line := ImpStrList[i];
      line := trim(line);
      // delete all quotes
      while pos('"', line) > 0 do begin
        delete(line, pos('"', line), 1);
      end;
      // delete acct
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // Buy/Sell
      oc := copy(line, 1, pos(sep, line) - 1);
      if pos('Buy', oc) > 0 then
        oc := 'O'
      else if pos('Sell', oc) > 0 then
        oc := 'C'
      else begin
        dec(R);
        Continue;
      end;
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // Long/Short
      ls := 'L';
      // Shares
      ShStr := copy(line, 1, pos(sep, line) - 1);
      ShStr := delCommas(ShStr);
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // ticker
      tick := copy(line, 1, pos(sep, line) - 1);
      tick := trim(tick);
      if (pos('CALL', tick) = 1) //
        or (pos('PUT', tick) = 1) then begin
        contracts := true;
      end
      else if (pos(' C', tick) = length(tick) - 1) then begin
        tick := tick + 'ALL';
        contracts := true;
      end
      else if (pos(' P', tick) = length(tick) - 1) then begin
        tick := tick + 'UT';
        contracts := true;
      end;
      if contracts then begin
        p := pos(' 1/2', tick);
        if p > 0 then begin
          delete(tick, p, 4);
          insert('.5', tick, p);
        end;
      end;
      // date
      delete(line, 1, pos(sep, line));
      line := trim(line);
      ImpDate := copy(line, 1, pos(sep, line) - 1);
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // delete settle date
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // price
      PrStr := copy(line, 1, pos(sep, line) - 1);
      PrStr := delCommas(PrStr);
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // amount
      AmtStr := copy(line, 1, pos(sep, line) - 1);
      AmtStr := delCommas(AmtStr);
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // princ amount
      PrincStr := copy(line, 1, pos(sep, line) - 1);
      PrincStr := delCommas(AmtStr);
      // --------------------
      try
        Price := StrToFloat(PrStr, Settings.InternalFmt);
        if Price < 0 then
          Price := -Price;
        Shares := StrToFloat(ShStr, Settings.InternalFmt);
        if Shares < 0 then
          Shares := -Shares;
        if contracts then begin
          mult := 100;
          prfStr := 'OPT-100';
          if (pos('JAN 0', tick) > 0) then
            delete(tick, pos('JAN 0', tick) + 3, 1)
          else if (pos('FEB 0', tick) > 0) then
            delete(tick, pos('FEB 0', tick) + 3, 1)
          else if (pos('MAR 0', tick) > 0) then
            delete(tick, pos('MAR 0', tick) + 3, 1)
          else if (pos('APR 0', tick) > 0) then
            delete(tick, pos('APR 0', tick) + 3, 1)
          else if (pos('MAY 0', tick) > 0) then
            delete(tick, pos('MAY 0', tick) + 3, 1)
          else if (pos('JUN 0', tick) > 0) then
            delete(tick, pos('JUN 0', tick) + 3, 1)
          else if (pos('JUL 0', tick) > 0) then
            delete(tick, pos('JUL 0', tick) + 3, 1)
          else if (pos('AUG 0', tick) > 0) then
            delete(tick, pos('AUG 0', tick) + 3, 1)
          else if (pos('SEP 0', tick) > 0) then
            delete(tick, pos('SEP 0', tick) + 3, 1)
          else if (pos('OCT 0', tick) > 0) then
            delete(tick, pos('OCT 0', tick) + 3, 1)
          else if (pos('NOV 0', tick) > 0) then
            delete(tick, pos('NOV 0', tick) + 3, 1)
          else if (pos('DEC 0', tick) > 0) then
            delete(tick, pos('DEC 0', tick) + 3, 1);
        end
        else begin
          mult := 1;
          prfStr := 'STK-1';
        end;
        Amt := StrToFloat(AmtStr, Settings.InternalFmt);
        if Amt < 0 then Amt := -Amt; // ABS(Amt)
        Princ := StrToFloat(PrincStr, Settings.InternalFmt);
        if Princ < 0 then
          Princ := -Princ;
        // calc commission
        if (oc = 'O') and (ls = 'L') then
          Commis := Amt - (Shares * Price * mult)
        else if (oc = 'C') and (ls = 'L') then
          Commis := (Shares * Price * mult) - Amt
        else if (oc = 'O') and (ls = 'S') then
          Commis := (Shares * Price * mult) - Amt
        else if (oc = 'C') and (ls = 'S') then
          Commis := Amt - (Shares * Price * mult);
        ImpTrades[R].it := TradeLogFile.Count + R;
        ImpTrades[R].tr := 0;
        ImpTrades[R].DT := ImpDate;
        ImpTrades[R].tm := '';
        ImpTrades[R].oc := oc;
        ImpTrades[R].ls := ls;
        ImpTrades[R].tk := tick;
        ImpTrades[R].sh := Shares;
        ImpTrades[R].pr := Price;
        ImpTrades[R].prf := prfStr;
        ImpTrades[R].cm := Commis;
        ImpTrades[R].am := Amt;
      except
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        dec(R);
        Continue;
      end;
    end;
    ImpStrList.Destroy;
    result := R;
  finally
    // ReadSLKcsv
  end;
end;


function ReadSLKweb(): integer;
var
  i, R : integer;
  mult, Commis, Princ : double;
  PrincStr, line, sep, ImpDate, ShStr, PrStr, prfStr, AmtStr : string;
  contracts : boolean;
  oc, ls : string;
begin
  try
    DataConvErrRec := '';
    DataConvErrStr := '';
    Commis := 0;
    R := 0;
    ImpStrList := TStringList.Create;
    ImpTrades := nil;
    setLength(ImpTrades, R + 1);
    GetImpDateLast;
    GetImpStrListFromClip(false);
    sep := ' ';
    if ImpStrList.Count < 1 then begin
      ImpStrList.Destroy;
      result := 0;
      exit;
    end;
    for i := 0 to ImpStrList.Count - 1 do begin
      contracts := false;
      inc(R);
      if R < 1 then
        R := 1;
      line := ImpStrList[i];
      line := trim(line);
      // delete all quotes
      while pos('"', line) > 0 do begin
        delete(line, pos('"', line), 1);
      end;
      // delete acct
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // Buy/Sell
      oc := copy(line, 1, pos(sep, line) - 1);
      if pos('Buy', oc) > 0 then
        oc := 'O'
      else if pos('Sell', oc) > 0 then
        oc := 'C'
      else begin
        dec(R);
        Continue;
      end;
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // Long/Short
      ls := 'L';
      // Shares
      ShStr := copy(line, 1, pos(sep, line) - 1);
      ShStr := delCommas(ShStr);
      ShStr := DelParenthesis(ShStr);
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // ticker
      tick := copy(line, 1, pos(sep, line) - 1);
      tick := trim(tick);
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // date
      ImpDate := LongDateStr(copy(line, 1, pos(sep, line) - 1));
      if (pos('CALL', tick) = 1) or (pos('PUT', tick) = 1) then begin
        contracts := true;
        tick := formatRJTopt(tick, ImpDate, false);
      end;
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // delete settle date
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // price
      PrStr := copy(line, 1, pos(sep, line) - 1);
      PrStr := delCommas(PrStr);
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // amount
      AmtStr := copy(line, 1, pos(sep, line) - 1);
      AmtStr := delCommas(AmtStr);
      AmtStr := DelParenthesis(AmtStr);
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // princ amount
      PrincStr := copy(line, 1, pos(sep, line) - 1);
      PrincStr := delCommas(AmtStr);
      PrincStr := DelParenthesis(PrincStr);
      // ------------------------------
      try
        Price := StrToFloat(PrStr, Settings.InternalFmt);
        // price:= StrToFloat(prStr,ImportFmt);
        if Price < 0 then
          Price := -Price;
        Shares := StrToFloat(ShStr, Settings.InternalFmt);
        if Shares < 0 then
          Shares := -Shares;
        if contracts then begin
          mult := 100;
          prfStr := 'OPT-100';
        end
        else begin
          mult := 1;
          prfStr := 'STK-1';
        end;
        Amt := StrToFloat(AmtStr, Settings.InternalFmt);
        if Amt < 0 then
          Amt := -Amt;
        Princ := StrToFloat(PrincStr, Settings.InternalFmt);
        if Princ < 0 then
          Princ := -Princ;
        // calc commission
        if (oc = 'O') and (ls = 'L') then
          Commis := Amt - (Shares * Price * mult)
        else if (oc = 'C') and (ls = 'L') then
          Commis := (Shares * Price * mult) - Amt
        else if (oc = 'O') and (ls = 'S') then
          Commis := (Shares * Price * mult) - Amt
        else if (oc = 'C') and (ls = 'S') then
          Commis := Amt - (Shares * Price * mult);
        ImpTrades[R].it := TradeLogFile.Count + R;
        ImpTrades[R].tr := 0;
        ImpTrades[R].DT := ImpDate;
        ImpTrades[R].tm := '';
        ImpTrades[R].oc := oc;
        ImpTrades[R].ls := ls;
        ImpTrades[R].tk := tick;
        ImpTrades[R].sh := Shares;
        ImpTrades[R].pr := Price;
        ImpTrades[R].prf := prfStr;
        ImpTrades[R].cm := Commis;
        ImpTrades[R].am := Amt;
      except
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        dec(R);
        Continue;
      end;
    end;
    ImpStrList.Destroy;
    result := R;
  finally
    // ReadSLKweb
  end;
end;


function ReadSLK(): integer;
begin
  try
    case TradeLogFile.CurrentAccount.ImportMethod of
    imFileImport :
      result := ReadSLKcsv; // CSV Import
    imWebImport :
      result := ReadSLKweb; // Clipboard Import
    else begin
      if mDlg('Import from SLK web site?' + cr //
          + cr //
          + 'Click No to import from text file', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
        result := ReadSLKcsv
      else
        result := ReadSLKweb;
      end;
    end;
  finally
    // ReadSLK
  end;
end;


// ------------------------------------
// tastyworks
// ------------------------------------

function ReadtastyworksCSV2(ImpStrList : TStringList): integer;
var
  i, j, k, start, eend, R, Q : integer;
  iDt, iTm, iTyp, iPRF, iOC, iLS, iTk, iDesc, iShr, iPr, iAmt, iCm : integer;
  // import field numbers
  iUndly, iExpDt, iStrik, iCP : integer; // more import field numbers
  junk, sep, ImpDate, ImpTime, CmStr, feeStr, PrStr, AmtStr, ShStr, line, AdjEntryStr, //
    optDesc, optUndly, opYr, opMon, opDay, opStrike, opCP, opTick, //
    oc, ls, dd, mm, yyyy, errLogTxt : string;
  Amount, Commis, Fees, Shares, mult : double;
  contracts, Adj, optExpEx, ImpNextDateOn, bonds, newColFormat, miniOptions, futures, futopt,
    bFoundHeader, cancels : boolean;
  fieldLst : TStrings;
  // --------------------------------------------
  // Fld Idx FieldName     Example
  // --------------------------------------------
  // DT     Date            2022-12-15T09:16:12-0700
  // Type            Trade
  // OC/LS  Action          BUY_TO_CLOSE
  // OpTk   Symbol          ./MESH3EXZ2  221230P3820
  // FUT    Instrument Type Future Option
  // Description     <must be parsed>
  // ex: "Bought 1 /MESH3 EXZ2 12/30/22 Put 3820.00 @ 25.25"
  // Bought
  // 1
  // /MESH3
  // EXZ2
  // 12/30/22
  // Put
  // 3820
  // iMult                  @ 25.25  // per contract value
  // AMT     Value          -126.25
  // SH      Quantity       1
  // Average Price  -126.25
  // Commissions    0
  // CM      Fees           -0.46
  // --      Multiplier     1        <--- just wrong!
  // Root Symbol    ./MESH3EXZ2
  // iUndly  Underlying Symbol  /MESH3
  // iExpDt  Expiration Date 12/30/22
  // iStrike Strike Price   3820
  // C/P     Call or Put    PUT
  // Order #        246681145
  // --------------------------------------------------------------------------
  procedure SetFieldNumbers_fut();
  var
    j : integer;
  begin
    // find/map tastyworks CSV fields
    k := 0;
    for j := 0 to (fieldLst.Count - 1) do begin
      if fieldLst[j] = 'TYPE' then begin
        iTyp := j;
      end;
      if fieldLst[j] = 'INSTRUMENT TYPE' then begin
        iPRF := j;
        k := k or 1;
      end
      else if fieldLst[j] = 'ACTION' then begin
        iOC := j;
        iLS := j;
        k := k or 2;
      end
      else if fieldLst[j] = 'SYMBOL' then begin
        iTk := j;
        k := k or 4;
      end
      else if fieldLst[j] = 'VALUE' then begin
        iAmt := j;
        k := k or 8;
      end
      else if fieldLst[j] = 'DESCRIPTION' then begin
        iDesc := j;
        k := k or 16;
      end
      else if fieldLst[j] = 'QUANTITY' then begin
        iShr := j;
        k := k or 32;
      end
      else if (fieldLst[j] = 'DATE') then begin
        iDt := j;
        iTm := j;
        k := k or 64;
      end
      else if fieldLst[j] = 'UNDERLYING SYMBOL' then begin
        iUndly := j;
        k := k or 128;
      end
      else if fieldLst[j] = 'EXPIRATION DATE' then begin
        iExpDt := j;
        k := k or 256;
      end
      else if fieldLst[j] = 'STRIKE PRICE' then begin
        iStrik := j;
        k := k or 512;
      end
      else if fieldLst[j] = 'CALL OR PUT' then begin
        iCP := j;
        k := k or 1024;
      end;
    end; // for j
  end;
// --------------------------------------------
begin // ReadtastyworksCSV
  bFoundHeader := false; // let's us know we haven't found the header yet
  iDt := 0;
  iTyp := 0;
  iOC := 0;
  iLS := 0;
  iTk := 0;
  iDesc := 0;
  iShr := 0;
  iPr := 0;
  iAmt := 0;
  DataConvErrRec := '';
  // in case these are missing, flag to skip them.
  iTm := -1;
  cancels := false;
  R := 0;
  try
    // created 2023-04-27
    AdjEntryStr := '';
    DataConvErrRec := '';
    DataConvErrStr := '';
    Adj := false;
    ImpNextDateOn := false;
    newColFormat := false;
    if ImpStrList.Count < 1 then begin
      ImpStrList.Destroy;
      result := 0;
      exit;
    end;
    fieldLst := TStrings.Create;
    // --------------------------------
    i := -1;
    while i < (ImpStrList.Count - 1) do begin
      inc(i); // make it work like a for/next
      contracts := false;
      futures := false;
      miniOptions := false;
      optExpEx := false;
      bonds := false;
      // ------------------------------
      line := ImpStrList[i];
      line := uppercase(line); // from here on, search line for UPPERCASE string tokens...
      // parse all columns into string list
      fieldLst := ParseCSV(line); // still going to be uppercase since not before uppercase()
      if not bFoundHeader then begin
        if (pos('ACTION', line) > 0) //
          and (pos('DATE', line) > 0) //
          and (pos('SYMBOL', line) > 0) then begin
          SetFieldNumbers_fut;
          if SuperUser and (k <> 2047) then
            sm('there appear to be fields missing.');
          // could check for negative values here.
          bFoundHeader := true; // don't do this anymore
          R := 0; // start now
        end;
        Continue; // don't process anything until we recognize the header
      end;
      // ------------------------------
      if pos('ERROR', line) > 0 then begin
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        sm('tastytrade reported an error.' + cr //
          + 'Please reduce the date range and try again.');
        result := 0;
        exit;
      end;
      // ------------------------------
      // we only do trades for now...
      if (fieldLst[iTyp] <> 'TRADE') then
        Continue;
      // ------------------------------
      futopt := false; // init
      futures := false;
      if (pos('FUTURE OPTION', fieldLst[iPRF]) > 0) then
        futopt := true
      else if (pos('FUTURES', fieldLst[iPRF]) > 0) then
        futures := true // 2023-04-21 MB - FUT support
      else
        sm(fieldLst[iPRF]);
      // --- Date ---------------------
      junk := fieldLst[iDt]; // format: MM/DD/YY
      if pos('T', junk) > 0 then
        ImpDate := parsefirst(junk, 'T')
      else
        ImpDate := junk;
      if pos('-', ImpDate) = 5 then begin
        ImpDate := StringReplace(ImpDate, '-', '', [rfReplaceAll]);
        ImpDate := MMDDYYYY(ImpDate); // it comes in yyyy-mm-dd
      end;
      if not isdate(ImpDate) then
        sm('Cannot determine the transaction date of this trade:' + cr + line);
      if not ValidTradeDate(ImpDate, ImpDateLast, ImpNextDateOn) then begin
        // DataConvErrRec := DataConvErrRec + 'invalid date: ' + ImpStrList[i] + cr;
        Continue;
      end;
      inc(R); // if it gets this far, count it
      // --- Time of day -
      if iTm < 0 then
        ImpTime := ''
      else begin
        junk := fieldLst[iTm]; // format: yyyy-mm-ddThh:mm:ss.nnn
        ImpTime := parseLast(junk, 'T'); // time follows letter "T"
        if pos('-', ImpTime) > 0 then begin
          junk := ImpTime;
          ImpTime := parsefirst(junk, '-');
        end;
      end;
      // --- OC and LS ---
      if fieldLst[iOC] = 'BUY_TO_OPEN' then begin
        oc := 'O';
        ls := 'L';
      end
      else if fieldLst[iOC] = 'SELL_TO_OPEN' then begin
        oc := 'O';
        ls := 'S';
      end
      else if fieldLst[iOC] = 'BUY_TO_CLOSE' then begin
        oc := 'C';
        ls := 'S';
      end
      else if fieldLst[iOC] = 'SELL_TO_CLOSE' then begin
        oc := 'C';
        ls := 'L';
      end
      else if fieldLst[iOC] = 'BUY' then begin
        if fieldLst[iLS] = 'SHORT' then begin
          oc := 'C';
          ls := 'S';
        end
        else begin
          oc := 'O';
          ls := 'L';
        end;
      end
      else if fieldLst[iOC] = 'SELL' then begin
        if fieldLst[iLS] = 'SHORT' then begin
          oc := 'O';
          ls := 'S';
        end
        else begin
          oc := 'C';
          ls := 'L';
        end;
      end
      else if pos('CANCEL', fieldLst[iOC]) = 1 then begin
        oc := 'X';
        cancels := true;
      end
      else begin // error
        DataConvErrRec := DataConvErrRec + 'unknown OC/LS: ' + ImpStrList[i] + cr;
        oc := 'E';
        ls := 'E';
      end;
      // --- # shares ---
      ShStr := fieldLst[iShr];
      ShStr := delCommas(ShStr);
      // --- ticker ---
      tick := trim(fieldLst[iTk]);
      if leftStr(tick, 2) = './' then begin
        tick := copy(tick, 3);
      end;
      // is it an option? fixed-width fields:
      // NFLX  20210820P  495.000 <- with spaces
      // NDXP  20210825P14550.000 <- no spaces
      // 123456789012345678901234 <-- 24 chars
      if (copy(tick, 7, 2)= '20') and (length(tick)> 10) then
        contracts := true
      else
        contracts := false;
      // ------------------------------
      // optDesc, opYr, opMon, opDay, opStrike, opCP
      // iUndly, iExpDt, iStrik, iCP
      optUndly := trim(fieldLst[iUndly]);
      if leftStr(optUndly, 1) = '/' then begin
        optUndly := copy(optUndly, 2);
      end;
      opStrike := delTrailingZeros(fieldLst[iStrik]);
      opCP := trim(fieldLst[iCP]);
      // --- future options -----------
      if futopt then begin
        opTick := tick; // move it to here
        junk := trim(fieldLst[iExpDt]); // holder
        // expiration date in m/d/y format
        opYr := parseLast(junk, '/');
        if not IsNumber(opYr) then begin
          futures := false;
          break; // out of this if block
        end;
        if length(opYr) > 2 then
          opYr := rightStr(opYr, 2);
        // day of month
        opDay := parseLast(junk, '/');
        // lookup month code
        opMon := getExpMo(junk);
        // underlying ticker
// tick := optUndly + ' ' + opMon + opYr + ' ' + opStrike + ' ' + opCP;
        tick := optUndly + ' ' + opDay + opMon + opYr + ' ' + opStrike + ' ' + opCP;
      end;
      // --- options --------
      // fixed-width fields:
      // NDXP  20210825P14550.000
      // |-----|---|-|-||--------
      // 123456789012345678901234
      if contracts then begin
        // first, calculate the option ticker
        // QQQ   20180119C  160.000
        // ---   yyyymmdd*  $$$.###
        junk := trim(tick); // holder
        tick := trim(copy(junk, 1, 6));
        opYr := copy(junk, 9, 2);
        opMon := copy(junk, 11, 2);
        opDay := copy(junk, 13, 2);
        opCP := copy(junk, 15, 1);
        opStrike := trim(copy(junk, 16, 9));
        opStrike := delTrailingZeros(opStrike);
        // ------------------
        if opCP = 'C' then
          opCP := 'CALL'
        else if opCP = 'P' then
          opCP := 'PUT'
        else
          contracts := false;
      end;
      // --------------------
      if contracts then begin
        opMon := getExpMo(opMon); // convert to TLA
        optDesc := tick + ' ' + opDay + opMon + opYr + ' ' + opStrike + ' ' + opCP;
        // EX: MSFT 21DEC17 15 CALL
      end
      else
        optDesc := ''; // NOT an option contract
      // --------------------------------------------------------------------------
      // Futures - can be entered using future symbols (ex.: "ESM6" or "ESM06")
      // or TradeLog-standard option symbol format (ex.: "ES DEC11")
      // Futures Options - can only be entered using TradeLog standardized futures
      // option symbol format (ex.: "ES DEC11 1030 CALL")
      // --- price ---
      if futopt then begin
        junk := fieldLst[iDesc];
        PrStr := parseLast(junk, '@');
      end
      else
        PrStr := fieldLst[iPr];
      delete(PrStr, pos('$', PrStr), 1);
      PrStr := delCommas(PrStr);
      if optExpEx then
        PrStr := '0.00';
      // --- amount ---
      AmtStr := fieldLst[iAmt];
      if (pos('$', AmtStr) > 0) then
        delete(AmtStr, pos('$', AmtStr), 1);
      AmtStr := delCommas(AmtStr);
      if (AmtStr = '') or (pos('*', AmtStr) > 0) then
        AmtStr := '0.00';
      // ------------------------------
      // Per Renee: The price in the Description column following the "@"
      // is the trade price per option rounded to 2 decimal places.
      // "/MES" contracts are for options on 5 futures contracts.
      // the Value column is the unrounded trade price X multiplier (5).
      // EX: Desc = "Bought 1 /MESH3EXZ2 12/30/22 PUT 3820.00 @ 25.25"
      // Value = $126.25; Quantity = 1; Multiplier = 1 (WRONG);
      // Price = $126.25 / 5 = $25.25
      // ------------------------------
      try
        Shares := StrToFloat(ShStr, Settings.InternalFmt);
        if Shares = 0 then begin
          dec(R);
          Continue;
        end;
        if Shares < 0 then
          Shares := -Shares;
        // ----------------------------
        Price := StrToFloat(PrStr, Settings.InternalFmt);
        if (leftStr(AmtStr, 1)= '(') and (rightStr(AmtStr, 1)= ')') then
          AmtStr := '-' + copy(AmtStr, 2, length(AmtStr)- 2);
        Amount := CurrToFloat(AmtStr);
        if Amount < 0 then
          Amount := -Amount;
        // ----------------------------
        if contracts then begin
          mult := 100;
          ImpTrades[R].prf := 'OPT-100';
          tick := optDesc;
        end
        else if futures then begin
          mult := 100;
          ImpTrades[R].prf := 'FUT-0';
        end
        else if futopt then begin
          mult := 5;
          ImpTrades[R].prf := 'FUT-5';
        end
        else begin
          mult := 1;
          ImpTrades[R].prf := 'STK-1';
        end;
        // ----------------------------
        // ignore the comm and fees fields and just calculate commission
        if ((oc = 'C') and (ls = 'L')) or ((oc = 'O') and (ls = 'S')) then
          Commis := Amount - (Shares * mult * Price)
        else
          Commis := (Shares * mult * Price) - Amount;
        if Commis < 0 then
          Commis := -Commis;
        // ----------------------------
        ImpTrades[R].DT := ImpDate;
        ImpTrades[R].tm := ImpTime;
        ImpTrades[R].oc := oc;
        ImpTrades[R].ls := ls;
        ImpTrades[R].tk := trim(tick);
        ImpTrades[R].opTk := ''; // trim(optDesc);
        ImpTrades[R].sh := Shares;
        ImpTrades[R].pr := Price;
        ImpTrades[R].am := Amount;
        ImpTrades[R].cm := rndto2(Commis) + rndto2(Fees);
      except
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        dec(R);
        Continue;
      end;
      ImpTrades[R].it := TradeLogFile.Count + R;
    end;
    // --------------------------------
    if cancels then begin
      for i := 1 to R do begin
        if (ImpTrades[i].oc <> 'X') then
          Continue; // not a cancel
        StatBar('Matching Cancelled Trades: ' + IntToStr(i));
        for j := (i + 1) downto 1 do begin // NOTE: CANCEL can come before OR after trade to cancel
          if j > R then
            Continue; // don't go out of bounds
          if (ImpTrades[i].tk <> ImpTrades[j].tk) then
            Continue; // not same ticker
          // could be a match, let's check the rest...
          if (format('%1.5f', [ImpTrades[i].sh], Settings.UserFmt) = format('%1.5f',
              [ImpTrades[j].sh], Settings.UserFmt)) //
            and (format('%1.5f', [ImpTrades[i].pr], Settings.UserFmt) = format('%1.5f',
              [ImpTrades[j].pr], Settings.UserFmt)) //
            and (format('%1.2f', [ImpTrades[i].cm], Settings.UserFmt) = format('%1.2f',
              [ImpTrades[j].cm], Settings.UserFmt)) //
            and (ImpTrades[i].prf = ImpTrades[j].prf) //
            and (ImpTrades[j].oc <> '') and (i <> j) then begin
            // with ImpTrades[i] do
            // msgTxt:= msgTxt+dt+tab+tk+tab+oc+ls+tab+floatToStr(sh)
            // +tab+floatToStr(pr)+tab+floatToStr(am)+cr;
            glNumCancelledTrades := glNumCancelledTrades + 2;
            // --- I ---
            ImpTrades[i].oc := '';
            ImpTrades[i].ls := '';
            ImpTrades[i].tm := '';
            // --- J ---
            ImpTrades[j].oc := '';
            ImpTrades[j].ls := '';
            ImpTrades[j].tm := '';
            break;
          end; // if everything else matches
        end; // for j = 1 downto
      end; // for i = 1 to R
    end; // if cancels
    // --------------------------------
    ImpStrList.Destroy;
    result := R;
  finally
    fieldLst.Free;
    if length(DataConvErrRec) > 1 then begin
      AssignFile(ErrLog, Settings.DataDir + '\error.log');
      rewrite(ErrLog);
      errLogTxt := 'ERROR :' + msgTxt + '; Detailed Message: ' + '"' + DataConvErrRec + '"';
      try
        write(ErrLog, errLogTxt);
        errLogTxt := '';
      finally
        CloseFile(ErrLog);
      end;
    end; // end if DataConvErrRec
  end;
end; // ReadtastyworksCSV2

function ReadtastyworksCSV(ImpStrList : TStringList): integer;
var
  i, j, k, start, eend, R, Q : integer;
  iDt, iTm, iTyp, iOC, iLS, iTk, iDesc, iShr, iPr, iAmt, iCm : integer; // import field numbers
  junk, sep, ImpDate, ImpTime, CmStr, feeStr, PrStr, AmtStr, ShStr, line, AdjEntryStr, optDesc,
    optOC, opYr, opMon, opDay, opStrike, opCP, oc, ls, dd, mm, yyyy, errLogTxt : string;
  Amount, Commis, Fees, Shares, mult : double;
  contracts, Adj, optExpEx, ImpNextDateOn, bonds, newColFormat, miniOptions, futures, bFoundHeader,
    cancels : boolean;
  fieldLst : TStrings;
  // --------------------------------------------
  // Fld Idx FieldName     Example
  // --------------------------------------------
  // 1   Type          TRADES
  // LS  2   Account       GENERAL_MARGIN, SHORT
  // DT  3   Trade Date    11/7/2017
  // 4   Settle Date   11/8/2017
  // 5   Tag #         L3224
  // TM  6   Timestamp     2017-11-07T11:01:59.000
  // TK  7   Symbol        IWM   20171215P  141.000
  // DES 8   Description
  // OC* 9   Trade Action  SELL_TO_OPEN, BUY_TO_CLOSE
  // SH  10  Qty           -1,    1
  // PR  11  Price         $0.78
  // CM  12  Fees          $0.16
  // CM  13  Commissions   $1.00
  // AMT 14  Net Amount    $76.84, ($60.14)
  // 15  Trailer       472
  // 16  Transfer Direction  INCOMING, OUTGOING
  // * OC and LS both come from this field
  // PRF must be determined from the ticker?
  // --------------------------------------------
  procedure SetFieldNumbers();
  var
    j : integer;
  begin
    // find/map tastyworks CSV fields
    k := 0;
    for j := 0 to (fieldLst.Count - 1) do begin
      if fieldLst[j] = 'TYPE' then begin
        iTyp := j;
        k := k or 1;
      end
      else if fieldLst[j] = 'ACCOUNT' then begin
        iLS := j; // optional
      end
      else if fieldLst[j] = 'TRADE DATE' then begin
        iDt := j;
        k := k or 2;
      end
      else if fieldLst[j] = 'TRADE ACTION' then begin
        iOC := j;
        k := k or 4;
      end
      else if fieldLst[j] = 'NET AMOUNT' then begin
        iAmt := j;
        k := k or 8;
      end
      else if fieldLst[j] = 'DESCRIPTION' then begin
        iDesc := j;
        k := k or 16;
      end
      else if fieldLst[j] = 'PRICE' then begin
        iPr := j;
        k := k or 32;
      end
      else if fieldLst[j] = 'QTY' then begin
        iShr := j;
        k := k or 64;
      end
      else if fieldLst[j] = 'SYMBOL' then begin
        iTk := j;
        k := k or 128;
      end
      else if fieldLst[j] = 'TIMESTAMP' then begin
        iTm := j; // optional
      end;
    end;
  end;
// --------------------------------------------
begin // ReadtastyworksCSV
  bFoundHeader := false; // let's us know we haven't found the header yet
  iDt := 0;
  iTyp := 0;
  iOC := 0;
  iLS := -1; // to let us know there IS no field for this
  iTk := 0;
  iDesc := 0;
  iShr := 0;
  iPr := 0;
  iAmt := 0;
  iTm := -1; // in case there IS no timestamp field
  DataConvErrRec := '';
  cancels := false;
  R := 0;
  try
    // created 2017-12-14
    AdjEntryStr := '';
    DataConvErrRec := '';
    DataConvErrStr := '';
    Adj := false;
    ImpNextDateOn := false;
    newColFormat := false;
    if ImpStrList.Count < 1 then begin
      ImpStrList.Destroy;
      result := 0;
      exit;
    end;
    fieldLst := TStrings.Create;
    // --------------------------------
    i := -1;
    while i < (ImpStrList.Count - 1) do begin
      inc(i); // make it work like a for/next
      contracts := false;
      futures := false;
      miniOptions := false;
      optExpEx := false;
      bonds := false;
      // ------------------------------
      line := ImpStrList[i];
      line := uppercase(line); // from here on, search line for UPPERCASE string tokens...
      // parse all columns into string list
      fieldLst := ParseCSV(line); // still going to be uppercase since not before uppercase()
      // ------------------------------
      if not bFoundHeader then begin
        if (pos('TYPE', line) > 0) //
          and (pos('TRADE DATE', line) > 0) //
          and (pos('SYMBOL', line) > 0) then begin
          SetFieldNumbers;
          if SuperUser and (k <> 255) then
            sm('there appear to be fields missing.');
          // could check for negative values here.
          bFoundHeader := true; // don't do this anymore
          R := 0; // start now
        end // ------------------------
        else if (pos('ACTION', line) > 0) //
          and (pos('DATE', line) > 0) //
          and (pos('SYMBOL', line) > 0) then begin
          result := ReadtastyworksCSV2(ImpStrList);
          exit;
        end;
        Continue; // don't process anything until we recognize the header
      end; // if not bFoundHeader
      // ------------------------------
      if pos('ERROR', line) > 0 then begin
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        sm('tastytrade reported an error.' + cr //
          + 'Please reduce the date range and try again.');
        result := 0;
        exit;
      end;
      // ------------------------------
      if fieldLst[iTyp] <> 'TRADES' then
        Continue; // we only do trades for now...
      if (iLS >= 0) and (iLS < fieldLst.Count) then
        if fieldLst[iLS] = 'FUTURES' then
          Continue; // skip futures for now...
      // --- Date ---------------------
      ImpDate := fieldLst[iDt]; // format: MM/DD/YY
      if pos('-', ImpDate) = 5 then begin
        ImpDate := StringReplace(ImpDate, '-', '', [rfReplaceAll]);
        ImpDate := MMDDYYYY(ImpDate); // it comes in yyyy-mm-dd
      end;
      if not isdate(ImpDate) then
        sm('Cannot determine the transaction date of this trade:' + cr + line);
      if not ValidTradeDate(ImpDate, ImpDateLast, ImpNextDateOn) then begin
        // DataConvErrRec := DataConvErrRec + 'invalid date: ' + ImpStrList[i] + cr;
        Continue;
      end;
      inc(R); // if it gets this far, count it
      // --- Time of day -
      if iTm < 0 then
        ImpTime := ''
      else begin
        junk := fieldLst[iTm]; // format: yyyy-mm-ddThh:mm:ss.nnn
        ImpTime := parseLast(junk, 'T'); // time follows letter "T"
      end;
      // --- OC and LS ---
      if fieldLst[iOC] = 'BUY_TO_OPEN' then begin
        oc := 'O';
        ls := 'L';
      end
      else if fieldLst[iOC] = 'SELL_TO_OPEN' then begin
        oc := 'O';
        ls := 'S';
      end
      else if fieldLst[iOC] = 'BUY_TO_CLOSE' then begin
        oc := 'C';
        ls := 'S';
      end
      else if fieldLst[iOC] = 'SELL_TO_CLOSE' then begin
        oc := 'C';
        ls := 'L';
      end
      else if fieldLst[iOC] = 'BUY' then begin
        if (iLS >= 0) and (iLS < fieldLst.Count) then begin
          if fieldLst[iLS] = 'SHORT' then begin
            oc := 'C';
            ls := 'S';
          end
          else begin
            oc := 'O';
            ls := 'L';
          end;
        end
        else if pos('SHORT', fieldLst[iDesc]) > 0 then begin
          oc := 'C';
          ls := 'S';
        end
        else begin
          oc := 'O';
          ls := 'L';
        end;
      end
      else if fieldLst[iOC] = 'SELL' then begin
        if (iLS >= 0) and (iLS < fieldLst.Count) then begin
          if fieldLst[iLS] = 'SHORT' then begin
            oc := 'O';
            ls := 'S';
          end
          else begin
            oc := 'C';
            ls := 'L';
          end;
        end
        else if pos('SHORT', fieldLst[iDesc]) > 0 then begin
          oc := 'O';
          ls := 'S';
        end
        else begin
          oc := 'C';
          ls := 'L';
        end;
      end
      else if pos('CANCEL', fieldLst[iOC]) = 1 then begin
        oc := 'X';
        cancels := true;
      end
      else begin // error
        DataConvErrRec := DataConvErrRec + 'unknown OC/LS: ' + ImpStrList[i] + cr;
        oc := 'E';
        ls := 'E';
      end;
      // --- # shares ---
      ShStr := fieldLst[iShr];
      ShStr := delCommas(ShStr);
      // --- ticker ---
      tick := trim(fieldLst[iTk]);
      // is it an option? fixed-width fields:
      // NFLX  20210820P  495.000 <- with spaces
      // NDXP  20210825P14550.000 <- no spaces
      // 123456789012345678901234 <-- 24 chars
      if (copy(tick, 7, 2)= '20') and (length(tick)> 10) then
// if ((pos(' ',tick) > 0) and (length(tick) > 6) then
        contracts := true
      else
        contracts := false;
      // --- futures --------
      if futures then begin
        junk := tick; // holder
        // last digit indicates year
        opYr := '1' + rightStr(junk, 1);
        if not IsNumber(opYr) then
          futures := false
        else if strToInt('20' + opYr) < strToInt(TaxYear) then
          opYr := '2' + rightStr(opYr, 1);
        delete(junk, length(junk), 1); // remove last char
        // lookup month code
        opMon := getFutExpMonth(rightStr(junk, 1));
        delete(junk, length(junk), 1); // remove last char
        // remaining chars are the underlying ticker
        tick := junk + ' ' + opMon + opYr;
      end;
      // --- options --------
      // fixed-width fields:
      // NDXP  20210825P14550.000
      // |-----|---|-|-||--------
      // 123456789012345678901234
      if contracts then begin
        // first, calculate the option ticker
        // QQQ   20180119C  160.000
        // ---   yyyymmdd*  $$$.###
        junk := trim(tick); // holder
        tick := trim(copy(junk, 1, 6));
        opYr := copy(junk, 9, 2);
        opMon := copy(junk, 11, 2);
        opDay := copy(junk, 13, 2);
        opCP := copy(junk, 15, 1);
        opStrike := trim(copy(junk, 16, 9));
        opStrike := delTrailingZeros(opStrike);
        // ------------------
// junk := trim(junk);
// if length(junk) < 9 then
// contracts := false
// else begin
// opYr := copy(junk, 3, 2);
// opMon := copy(junk, 5, 2);
// opDay := copy(junk, 7, 2);
// opCP := copy(junk, 9, 1);
        if opCP = 'C' then
          opCP := 'CALL'
        else if opCP = 'P' then
          opCP := 'PUT'
        else
          contracts := false;
// end;
      end;
      // --------------------
      if contracts then begin
        opMon := getExpMo(opMon); // convert to TLA
        optDesc := tick + ' ' + opDay + opMon + opYr + ' ' + opStrike + ' ' + opCP;
        // EX: MSFT 21DEC17 15 CALL
      end
      else
        optDesc := ''; // NOT an option contract
      // --- price ---
      PrStr := fieldLst[iPr];
      delete(PrStr, pos('$', PrStr), 1);
      PrStr := delCommas(PrStr);
      if optExpEx then
        PrStr := '0.00';
      // --- amount ---
      AmtStr := fieldLst[iAmt];
      if (pos('$', AmtStr) > 0) then
        delete(AmtStr, pos('$', AmtStr), 1);
      AmtStr := delCommas(AmtStr);
      if (AmtStr = '') or (pos('*', AmtStr) > 0) then
        AmtStr := '0.00';
      // --------------------
      try
        Shares := StrToFloat(ShStr, Settings.InternalFmt);
        if Shares = 0 then begin
          dec(R);
          Continue;
        end;
        if Shares < 0 then
          Shares := -Shares;
        // ----------------------------
        Price := StrToFloat(PrStr, Settings.InternalFmt);
        if (leftStr(AmtStr, 1)= '(') and (rightStr(AmtStr, 1)= ')') then
          AmtStr := '-' + copy(AmtStr, 2, length(AmtStr)- 2);
        Amount := CurrToFloat(AmtStr);
        if Amount < 0 then
          Amount := -Amount;
        // ----------------------------
        if contracts then begin
          mult := 100;
          ImpTrades[R].prf := 'OPT-100';
          tick := optDesc;
        end
        else if futures then begin
          mult := 100;
          ImpTrades[R].prf := 'FUT-0';
        end
        else begin
          mult := 1;
          ImpTrades[R].prf := 'STK-1';
        end;
        // ----------------------------
        // ignore the comm and fees fields and just calculate commission
        if ((oc = 'C') and (ls = 'L')) or ((oc = 'O') and (ls = 'S')) then
          Commis := Amount - (Shares * mult * Price)
        else
          Commis := (Shares * mult * Price) - Amount;
        if Commis < 0 then
          Commis := -Commis;
        // ----------------------------
        ImpTrades[R].DT := ImpDate;
        ImpTrades[R].tm := ImpTime;
        ImpTrades[R].oc := oc;
        ImpTrades[R].ls := ls;
        ImpTrades[R].tk := trim(tick);
        ImpTrades[R].opTk := ''; // trim(optDesc);
        ImpTrades[R].sh := Shares;
        ImpTrades[R].pr := Price;
        ImpTrades[R].am := Amount;
        ImpTrades[R].cm := rndto2(Commis) + rndto2(Fees);
      except
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        dec(R);
        Continue;
      end;
      ImpTrades[R].it := TradeLogFile.Count + R;
    end;
    // --------------------------------
    if cancels then begin
      for i := 1 to R do begin
        if (ImpTrades[i].oc <> 'X') then
          Continue; // not a cancel
        StatBar('Matching Cancelled Trades: ' + IntToStr(i));
        for j := (i + 1) downto 1 do begin // NOTE: CANCEL can come before OR after trade to cancel
          if j > R then
            Continue; // don't go out of bounds
          if (ImpTrades[i].tk <> ImpTrades[j].tk) then
            Continue; // not same ticker
          // could be a match, let's check the rest...
          if (format('%1.5f', [ImpTrades[i].sh], Settings.UserFmt) = format('%1.5f',
              [ImpTrades[j].sh], Settings.UserFmt)) //
            and (format('%1.5f', [ImpTrades[i].pr], Settings.UserFmt) = format('%1.5f',
              [ImpTrades[j].pr], Settings.UserFmt)) //
            and (format('%1.2f', [ImpTrades[i].cm], Settings.UserFmt) = format('%1.2f',
              [ImpTrades[j].cm], Settings.UserFmt)) //
            and (ImpTrades[i].prf = ImpTrades[j].prf) //
            and (ImpTrades[j].oc <> '') and (i <> j) then begin
            // with ImpTrades[i] do
            // msgTxt:= msgTxt+dt+tab+tk+tab+oc+ls+tab+floatToStr(sh)
            // +tab+floatToStr(pr)+tab+floatToStr(am)+cr;
            glNumCancelledTrades := glNumCancelledTrades + 2;
            // --- I ---
            ImpTrades[i].oc := '';
            ImpTrades[i].ls := '';
            ImpTrades[i].tm := '';
            // --- J ---
            ImpTrades[j].oc := '';
            ImpTrades[j].ls := '';
            ImpTrades[j].tm := '';
            break;
          end; // if everything else matches
        end; // for j = 1 downto
      end; // for i = 1 to R
    end; // if cancels
    // --------------------------------
    ImpStrList.Destroy;
    result := R;
  finally
    fieldLst.Free;
    if length(DataConvErrRec) > 1 then begin
      AssignFile(ErrLog, Settings.DataDir + '\error.log');
      rewrite(ErrLog);
      errLogTxt := 'ERROR :' + msgTxt + '; Detailed Message: ' + '"' + DataConvErrRec + '"';
      try
        write(ErrLog, errLogTxt);
        errLogTxt := '';
      finally
        CloseFile(ErrLog);
      end;
    end; // end if DataConvErrRec
  end;
end; // ReadtastyworksCSV


function Readtastyworks(): integer;
var
  R : integer;
  t : string;
begin
  try
    R := 0;
    ImpStrList := TStringList.Create;
    ImpTrades := nil;
    setLength(ImpTrades, R + 1);
    GetImpDateLast;
    if FileExists(Settings.ImportDir + '\download.csv') then
      deleteFile(Settings.ImportDir + '\download.csv');
    t := TradeLogFile.CurrentAccount.FileImportFormat;
    // tastyworks, or another which uses the same format
    GetImpStrListFromFile(t, 'csv', '');
    result := ReadtastyworksCSV(ImpStrList);
    exit;
  finally
    // Readtastyworks
  end;
end;


         // ---------------------------
         // Ally Invest
         // ---------------------------

function ReadAllyInvestCSV(ImpStrList : TStringList): integer;
var
  i, j, k, start, eend, R, Q : integer;
  iDt, iTm, iTyp, iOC, iLS, iTk, iDesc, iShr, iPr, iAmt, iCm : integer; // import field numbers
  junk, sep, ImpDate, ImpTime, CmStr, feeStr, PrStr, AmtStr, ShStr, line, AdjEntryStr, optDesc,
    optOC, opYr, opMon, opDay, opStrike, opCP, oc, ls, dd, mm, yyyy, errLogTxt : string;
  Amount, Commis, Fees, Shares, mult : double;
  contracts, Adj, optExpEx, ImpNextDateOn, bonds, newColFormat, miniOptions, futures, bFoundHeader,
    cancels, assigns : boolean;
  fieldLst : TStrings;
  // --------------------------------------------
  // Fld Idx FieldName     Example
  // --------------------------------------------
  // DT  1  Date      2/21/2017 = m/dd/yyyy
  // OC* 2  Activity  Bought,	Sold, Sold to Open, ???
  // SH  3  Quantity  100
  // TK  4  Symbol    NTRI
  // DES 5  Description NUTRISYSTEM INC, TPC Mar 17 2017 35.00 Call
  // PR  6  Price     $37.64
  // 7  Comm.     3.5
  // 8  Fees      $0.14
  // AMT 9  Amount    ($3,767.78), $94.76
  // NOTE: we won't use Comm. or Fees, we'll just compute from AMT - (SH*PR)
  // * OC and LS both come from this field
  // ** PRF must be determined from the DES
  // --------------------------------------------
  procedure SetFieldNumbers();
  var
    j : integer;
  begin
    // TradeKing (via Ally)
    k := 0;
    for j := 0 to (fieldLst.Count - 1) do begin
      if fieldLst[j] = 'DATE' then begin
        iDt := j;
        k := k or 1;
      end
      else if fieldLst[j] = 'ACTIVITY' then begin
        iOC := j;
        k := k or 2;
      end
      else if fieldLst[j] = 'QUANTITY' then begin
        iShr := j;
        k := k or 4;
      end
      else if fieldLst[j] = 'SYMBOL' then begin
        iTk := j;
        k := k or 8;
      end
      else if fieldLst[j] = 'DESCRIPTION' then begin
        iDesc := j;
        k := k or 16;
      end
      else if fieldLst[j] = 'PRICE' then begin
        iPr := j;
        k := k or 32;
      end
      else if fieldLst[j] = 'AMOUNT' then begin
        iAmt := j;
        k := k or 64;
      end;
    end;
  end;
// --------------------------------------------
begin // ReadAllyInvestCSV
  bFoundHeader := false;
  iDt := 0;
  iTyp := 0;
  iOC := 0;
  iLS := 0;
  iTk := 0;
  iDesc := 0;
  iShr := 0;
  iPr := 0;
  iAmt := 0;
  DataConvErrRec := '';
  // in case these are missing, flag to skip them.
  cancels := false;
  R := 0;
  try
    AdjEntryStr := '';
    DataConvErrRec := '';
    DataConvErrStr := '';
    Adj := false;
    ImpNextDateOn := false;
    newColFormat := false;
    if ImpStrList.Count < 1 then begin
      ImpStrList.Destroy;
      result := 0;
      exit;
    end;
    fieldLst := TStrings.Create;
    // --------------------------------
    i := -1;
    while i < (ImpStrList.Count - 1) do begin
      inc(i); // make it work like a for/next
      contracts := false; // reset flags
      assigns := false;
      futures := false;
      miniOptions := false;
      optExpEx := false;
      bonds := false;
      // ------------------------------
      line := ImpStrList[i];
      line := uppercase(line); // from here on, search line for UPPERCASE string tokens...
      // parse all columns into string list
      fieldLst := ParseCSV(line); // still going to be uppercase since not before uppercase()
      if not bFoundHeader then begin
        if (pos('DATE', line) > 0) and (pos('ACTIVITY', line) > 0) and (pos('SYMBOL', line) > 0)
        then begin
          SetFieldNumbers;
          if SuperUser and (k <> 127) then
            sm('there appear to be fields missing.');
          bFoundHeader := true; // don't do this anymore
          R := 0; // start now
        end;
        Continue; // don't process anything until we recognize the header
      end;
      // ------------------------------
      if pos('ERROR', line) > 0 then begin
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        sm('TradeKing reported an error.' + cr + 'Please reduce the date range and try again.');
        result := 0;
        exit;
      end;
      // --- Date ---------------------
      ImpDate := fieldLst[iDt]; // format: MM/DD/YY
      if trim(ImpDate) = '' then
        Continue; // not a real data record
      if pos('/', ImpDate) = 2 then
        ImpDate := '0' + ImpDate;
      if not isdate(ImpDate) then begin
        sm('Cannot determine the transaction date of this trade:' + cr + line);
        Continue;
      end;
      if not ValidTradeDate(ImpDate, ImpDateLast, ImpNextDateOn) then begin
        // DataConvErrRec := DataConvErrRec + 'invalid date: ' + ImpStrList[i] + cr;
        Continue;
      end;
      inc(R); // if it gets this far, count it
      ImpTime := '';
      // --- ticker ---
      tick := trim(fieldLst[iTk]);
      // is it an option?
      if (pos(' C', tick) > 1) or (pos(' P', tick) > 1) then
        contracts := true
      else
        contracts := false;
      // --- # shares ---
      ShStr := fieldLst[iShr];
      ShStr := delCommas(ShStr);
      // --- OC and LS ---
      /// 2020-03-20 MB - Activity codes
      // Category	Activity1         Activity2
      // Skip	    Bookkeeping       ---
      // Skip	    Dividend          Interest
      // ExAs     Assigned          Exercised
      // ExAs	    Expired           ---
      // O L	    Bought            Bought to Open
      // C S	    Bought to Close   Buy to Cover
      // C L	    Sold              Sold to Close
      // O S	    Sell Short        Sold to Open
      junk := trim(fieldLst[iOC]);
      if (junk = 'BOUGHT') //
        or (junk = 'BOUGHT TO OPEN') then begin
        oc := 'O';
        ls := 'L';
      end
      else if (junk = 'BOUGHT TO CLOSE') //
        or (junk = 'BUY TO COVER') then begin
        oc := 'C';
        ls := 'S';
      end
      else if (junk = 'SOLD') //
        or (junk = 'SOLD TO CLOSE') then begin
        oc := 'C';
        ls := 'L';
      end
      else if (junk = 'SOLD TO OPEN') //
        or (junk = 'SELL SHORT') then begin
        oc := 'O';
        ls := 'S';
      end
      // Assigns come in pairs (one stock, one option)
      // Date     	 | 1/19/2018 | 1/19/2018
      // Activity 	 | Assigned  | Assigned
      // Quantity 	 | -100      | 1
      // Symbol      | SCHN      | SCHN Call
      // Description | SCHNITZER | SCHN Jan 19 2018 34.00 Call
      // Price       | $34.00    |
      // Comm.       | 3.5       | 0
      // Fees        | $0.09     |
      // Amount      | $3,396.41 |
      // NOTE: some fields are blank
      else if junk = 'ASSIGNED' then begin
        assigns := true;
        if pos('-', ShStr) = 1 then begin
          oc := 'C';
          ls := 'L';
        end
        else begin
          oc := 'O';
          ls := 'L';
        end;
      end
      else if junk = 'EXERCISED' then begin
        assigns := true;
        if pos('-', ShStr) = 1 then begin
          oc := 'C';
          ls := 'L';
        end
        else begin
          oc := 'O';
          ls := 'L';
        end;
      end
      else begin
        dec(R);
        Continue; // record not supported
      end;
      // --- options --------
      if contracts then begin
        junk := fieldLst[iDesc]; // description
        opCP := parseLast(junk, ' ');
        // first, calculate the option ticker
        // TPC MAR 17 2017 35.00 CALL
        // ---  yyyymmdd*  $$.## C/P
        tick := parsefirst(junk, ' ');
        opStrike := parseLast(junk, ' ');
        opStrike := delTrailingZeros(opStrike);
        // ------------------
        junk := trim(junk); // only exp. date remains (MMM dd yyyy)
        if length(junk) < 9 then
          contracts := false
        else begin
          opYr := parseLast(junk, ' ');
          if length(opYr)= 4 then
            opYr := copy(opYr, 3);
          opMon := parsefirst(junk, ' ');
          opDay := trim(junk);
          optDesc := tick + ' ' + opDay + opMon + opYr + ' ' + opStrike + ' ' + opCP;
          // EX: MSFT 21DEC17 15 CALL
        end;
      end;
      // --- price ---
      if assigns and contracts then begin
        PrStr := '0.00';
        AmtStr := '0.00';
      end
      else begin
        PrStr := fieldLst[iPr];
        delete(PrStr, pos('$', PrStr), 1);
        PrStr := delCommas(PrStr);
        // if optExpEx then PrStr := '0.00';
        // --- amount ---
        AmtStr := fieldLst[iAmt];
        if (pos('$', AmtStr) > 0) then
          delete(AmtStr, pos('$', AmtStr), 1);
        AmtStr := delCommas(AmtStr);
        if (AmtStr = '') or (pos('*', AmtStr) > 0) then
          AmtStr := '0.00';
      end;
      // --------------------
      try
        Shares := StrToFloat(ShStr, Settings.InternalFmt);
        if Shares = 0 then begin
          dec(R);
          Continue;
        end;
        if Shares < 0 then
          Shares := -Shares;
        // ----------------------------
        Price := StrToFloat(PrStr, Settings.InternalFmt);
        // Commis := StrToFloat(CmStr, Settings.InternalFmt);
        // Fees := StrToFloat(FeeStr, Settings.InternalFmt);
        if (leftStr(AmtStr, 1)= '(') and (rightStr(AmtStr, 1)= ')') then
          AmtStr := '-' + copy(AmtStr, 2, length(AmtStr)- 2);
        Amount := CurrToFloat(AmtStr);
        if Amount < 0 then begin
          // sm('negative amount' + CR + 'OC = ' + oc + CR + 'ls = ' + LS);
          Amount := -Amount;
        end;
        // ----------------------------
        if contracts then begin
          mult := 100;
          ImpTrades[R].prf := 'OPT-100';
          tick := optDesc;
        end
        else if futures then begin
          mult := 100;
          ImpTrades[R].prf := 'FUT-0';
        end
        else begin
          mult := 1;
          ImpTrades[R].prf := 'STK-1';
        end;
        // ----------------------------
        // ignore the comm and fees fields and just calculate commission
        if ((oc = 'C') and (ls = 'L')) or ((oc = 'O') and (ls = 'S')) then
          Commis := Amount - (Shares * mult * Price)
        else
          Commis := (Shares * mult * Price) - Amount;
        if Commis < 0 then
          Commis := -Commis;
        // ----------------------------
        ImpTrades[R].DT := ImpDate;
        ImpTrades[R].tm := ImpTime;
        ImpTrades[R].oc := oc;
        ImpTrades[R].ls := ls;
        ImpTrades[R].tk := trim(tick);
        ImpTrades[R].opTk := ''; // trim(optDesc);
        ImpTrades[R].sh := Shares;
        ImpTrades[R].pr := Price;
        ImpTrades[R].am := Amount;
        ImpTrades[R].cm := rndto2(Commis) + rndto2(Fees);
      except
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        dec(R);
        Continue;
      end;
      ImpTrades[R].it := TradeLogFile.Count + R;
    end;
    // --------------------------------
    if R > 1 then
      if xStrToDate(ImpTrades[1].DT) > xStrToDate(ImpTrades[R].DT) then
        ReverseImpTradesDate(R);
    ImpStrList.Destroy;
    result := R;
  finally
    fieldLst.Free;
    if length(DataConvErrRec) > 1 then begin
      AssignFile(ErrLog, Settings.DataDir + '\error.log');
      rewrite(ErrLog);
      errLogTxt := 'ERROR :' + msgTxt + '; Detailed Message: ' + '"' + DataConvErrRec + '"';
      try
        write(ErrLog, errLogTxt);
        errLogTxt := '';
      finally
        CloseFile(ErrLog);
      end;
    end; // end if DataConvErrRec
    // ReadAllyInvestCSV
  end;
end;

function ReadAllyInvest(): integer;
var
  R : integer;
begin
  try
    R := 0;
    ImpStrList := TStringList.Create;
    ImpTrades := nil;
    setLength(ImpTrades, R + 1);
    GetImpDateLast;
    // Only accepts CSV file import
    if FileExists(Settings.ImportDir + '\download.csv') then
      deleteFile(Settings.ImportDir + '\download.csv');
    // --------------------------------
    GetImpStrListFromFile('Ally Invest', 'csv', '');
    result := ReadAllyInvestCSV(ImpStrList);
    // --------------------------------
    exit;
  finally
    // ReadAllyInvest
    screen.Cursor := crDefault;
  end;
end;


         // ---------------------------
         // Terra
         // ---------------------------

function ReadTerraCSV(): integer;
var
  i, R : integer;
  monYr, ImpDate, TimeStr, CmStr, PrStr, prfStr, AmtStr, ShStr, line, fees1, fees2, fees3, sep,
    under, exDa, exMo, exYr, strike, callPut, opTick : string;
  Amount, Commis, mult : double;
  futures, contracts : boolean;
  oc, ls : string;
begin
  try
    DataConvErrRec := '';
    DataConvErrStr := '';
    R := 0;
    sep := ',';
    futures := false;
    GetImpDateLast;
    GetImpStrListFromFile('Terra Nova', 'csv', '');
    if ImpStrList.Count < 1 then begin
      ImpStrList.Destroy;
      result := 0;
      exit;
    end;
    { Get  Records }
    for i := 0 to ImpStrList.Count - 1 do begin
      contracts := false;
      opTick := '';
      line := ImpStrList[i];
      if pos('Commodity_code', line) > 0 then begin
        futures := true;
        Continue;
      end;
      inc(R);
      if R < 1 then
        R := 1;
      if futures then
        delete(line, 1, pos(sep, line)); // delete acct #
      ImpDate := copy(line, 1, pos(sep, line) - 1); // date
      ImpDate := trim(ImpDate);
      if pos('/', ImpDate) < 1 then begin
        dec(R);
        Continue;
      end;
      ImpDate := LongDateStr(ImpDate);
      delete(line, 1, pos(sep, line));
      // time
      if futures then
        TimeStr := ''
      else begin
        TimeStr := trim(copy(line, 1, pos(sep, line) - 1));
        delete(line, 1, pos(sep, line));
      end;
      { O/C  L/S }
      oc := trim(copy(line, 1, pos(sep, line) - 1));
      if (pos('Short Sell', line) > 0) or (pos('Short Sale', line) > 0) or (pos('SS', line) = 1)
      then begin
        oc := 'C';
        ls := 'L';
      end
      else if (pos('Buy to Cover Short', line) > 0) or (pos('BCS', line) = 1) then begin
        oc := 'O';
        ls := 'L';
      end
      else if (pos('Buy to Open', line) > 0) or (pos('BO', line) = 1) then begin
        oc := 'O';
        ls := 'L';
        contracts := true;
      end
      else if (pos('Sell to Close', line) > 0) or (pos('SC', line) = 1) then begin
        oc := 'C';
        ls := 'L';
        contracts := true;
      end
      else if (pos('Buy to Close', line) > 0) or (pos('BC', line) = 1) then begin
        oc := 'C';
        ls := 'S';
        contracts := true;
      end
      else if (pos('Sell to Open', line) > 0) or (pos('SO', line) = 1) then begin
        oc := 'O';
        ls := 'S';
        contracts := true;
      end
      else if (pos('Buy', oc) > 0) or (pos('B', oc) = 1) then begin
        oc := 'O';
        ls := 'L';
      end
      else if (pos('Sell', oc) > 0) or (pos('S', oc) = 1) then begin
        oc := 'C';
        ls := 'L';
      end;
      delete(line, 1, pos(sep, line));
      // shares
      ShStr := copy(line, 1, pos(sep, line) - 1);
      delete(line, 1, pos(sep, line));
      // ticker
      tick := trim(copy(line, 1, pos(sep, line) - 1));
      // delete any plus signs in ticker
      while (pos('+', tick) > 0) do
        delete(tick, pos('+', tick), 1);
      delete(line, 1, pos(sep, line));
      if contracts then begin // options
        // new format: SWF   100320P00028.000
        opTick := tick;
        under := parsefirst(tick, ' ');
        tick := trim(tick);
        exYr := leftStr(tick, 2);
        delete(tick, 1, 2);
        exMo := leftStr(tick, 2);
        delete(tick, 1, 2);
        exMo := getExpMo(exMo);
        exDa := leftStr(tick, 2);
        delete(tick, 1, 2);
        callPut := leftStr(tick, 1);
        delete(tick, 1, 1);
        if callPut = 'P' then
          callPut := 'PUT'
        else if callPut = 'C' then
          callPut := 'CALL';
        strike := trim(tick);
        strike := delTrailingZeros(strike);
        // delete leading zeros - ie: 00028
        while (leftStr(strike, 1) = '0') do
          delete(strike, 1, 1);
        tick := under + ' ' + exDa + exMo + exYr + ' ' + strike + ' ' + callPut;
      end
      else if futures then begin
        delete(line, 1, pos(sep, line)); // delete month, year
        delete(line, 1, pos(sep, line));
        monYr := trim(copy(line, 1, pos(sep, line) - 1));
        delete(monYr, pos(' ', monYr), 1); // delete space between month and year
        tick := tick + ' ' + copy(monYr, 1, 5);
        delete(line, 1, pos(sep, line));
      end;
      // price
      PrStr := copy(line, 1, pos(sep, line) - 1);
      delete(line, 1, pos(sep, line));
      if futures then begin
        fees1 := copy(line, 1, pos(sep, line) - 1);
        delete(fees1, pos('-', fees1), 1);
        delete(line, 1, pos(sep, line));
        CmStr := copy(line, 1, pos(sep, line) - 1);
        delete(CmStr, pos('-', CmStr), 1);
        delete(line, 1, pos(sep, line));
        fees2 := copy(line, 1, pos(sep, line) - 1);
        delete(fees2, pos('-', fees2), 1);
        delete(line, 1, pos(sep, line));
        fees3 := copy(line, 1, pos(sep, line) - 1);
        delete(fees3, pos('-', fees3), 1);
        delete(line, 1, pos(sep, line));
        AmtStr := '0.00';
      end
      else begin
        AmtStr := copy(line, 1, pos(sep, line) - 1); // princ amt
        delete(line, 1, pos(sep, line));
        // comm
        fees1 := copy(line, 1, pos(sep, line) - 1);
        delete(line, 1, pos(sep, line));
      end;
      // --------------------
      try
        Shares := strToInt(ShStr);
        if Shares < 0 then
          Shares := -Shares;
        Price := StrToFloat(PrStr, Settings.InternalFmt);
        if Price < 0 then
          Price := -Price;
        Amount := StrToFloat(AmtStr, Settings.InternalFmt);
        if Amount < 0 then
          Amount := -Amount;
        Commis := StrToFloat(fees1, Settings.InternalFmt);
        // added 8/5/04 when TNO cannot get buy/sell code right for options
        if (format('%1.2m', [Shares * Price * 100], Settings.UserFmt) = format('%1.2m', [Amount],
            Settings.UserFmt)) then
          contracts := true;
        if contracts then begin
          mult := 100;
          prfStr := 'OPT-100';
        end
        else if futures then begin
          prfStr := futuresMult(tick, '', TradeLogFile.CurrentBrokerID);
        end
        else begin
          mult := 1;
          prfStr := 'STK-1';
        end;
        ImpTrades[R].it := TradeLogFile.Count + R;
        ImpTrades[R].DT := ImpDate;
        ImpTrades[R].tm := TimeStr;
        ImpTrades[R].oc := oc;
        ImpTrades[R].ls := ls;
        ImpTrades[R].tk := tick;
        ImpTrades[R].opTk := opTick;
        ImpTrades[R].sh := Shares;
        ImpTrades[R].pr := Price;
        ImpTrades[R].prf := prfStr;
        ImpTrades[R].cm := Commis;
      except
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        dec(R);
        Continue;
      end;
    end;
    result := R;
  finally
    // ReadTerraCSV
  end;
end;


function ReadTerra(): integer;
begin
  try
    ImpStrList := TStringList.Create;
    try
      ImpStrList.clear;
      ImpTrades := nil;
      setLength(ImpTrades, 1);
      result := ReadTerraCSV;
    finally
      ImpStrList.Free;
    end;
  finally
    // ReadTerra
  end;
end;


function ReadTOS(): integer;
var
  i, j, p, R, z : integer;
  Commis : double;
  line, ImpDate, TimeStr, ShStr, PrStr, AmtStr, CmStr : string;
  mult : double;
  TrCorrected, AcctNumFmt, TrailerFld, contracts, futures : boolean;
begin
  try
    // 2011-11-02 added BC support
    bcImp := false;
    if FileExists(Settings.ImportDir + '\TOS-ExportData.txt') then
      deleteFile(Settings.ImportDir + '\TOS-ExportData.txt');
    // --------------------------------
    // options: File, BC
    if sImpMethod = 'BC' then begin // imBrokerConnect:
      bcImp := true;
      if formGet.showmodal = mrOk then
//        if OFX then
//          exit(-1)
//        else
          result := ReadPenson();
      exit;
    end
    // --------------------------------
    else if sImpMethod = 'File' then begin // CSVImport
      result := ReadPenson();
    end;
    exit;
  finally
    //
  end;
end; // ReadTOS


         // ---------------------------
         // TradeStation
         // ---------------------------

function ReadTradeStationCSV(ImpStrList : TStringList): integer;
var
  i, R : integer;
  Shares, mult, Commis, Princ : double;
  ImpFile : textfile;
  PrincStr, line, sep, ImpDate, TimeStr, ShStr, PrStr, prfStr, AmtStr, NextDate, optStr, expDt,
    expMo, strikePr, optTick : string;
  contracts, ImpNextDateOn, missingPutCall, newFormat : boolean;
  oc, ls : string;
begin
  try
    TSweb := false;
    DataConvErrRec := '';
    DataConvErrStr := '';
    Commis := 0;
    R := 0;
    ImpNextDateOn := false;
    GetImpDateLast;
    if ImpStrList.Count < 1 then begin
      ImpStrList.Destroy;
      result := 0;
      exit;
    end;
    // test for new column format 2013-02-25
    for i := 0 to ImpStrList.Count - 1 do begin
      line := ImpStrList[i];
      line := trim(line);
      if (pos('CurrencyCode,Commission,Description,Activity Time,Order ID', line)> 0) then begin
        newFormat := true;
      end;
    end;
    // ----------------------
    for i := 0 to ImpStrList.Count - 1 do begin
      contracts := false;
      missingPutCall := false;
      optTick := '';
      inc(R);
      if R < 1 then
        R := 1;
      if (i = ImpStrList.Count - 1) and (R <= 1) and ImpNextDateOn then begin
        sm('No transactions later than ' + ImpDateLast);
        result := 0;
        exit;
      end;
      line := ImpStrList[i];
      line := trim(line);
      if pos(TAB, line) > 0 then begin
        while pos(TAB, line) > 0 do begin
          insert(',', line, pos(TAB, line));
          delete(line, pos(TAB, line), 1);
        end;
      end;
      sep := ',';
      // delete all quotes
      while pos('"', line) > 0 do
        delete(line, pos('"', line), 1);
      // delete acct
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // Long/Short
      ls := copy(line, 1, pos(sep, line) - 1);
      if pos('Short', ls) > 0 then
        ls := 'S'
      else
        ls := 'L';
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // delete Trade ind
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // Buy/Sell
      oc := copy(line, 1, pos(sep, line) - 1);
      if pos('Buy', oc) > 0 then begin
        if ls = 'L' then
          oc := 'O'
        else
          oc := 'C';
      end
      else if pos('Sell', oc) > 0 then begin
        if ls = 'L' then
          oc := 'C'
        else
          oc := 'O';
      end
      else if (pos('Exp', oc) > 0) or (pos('EXP', oc) > 0) then begin
        oc := 'C'
      end
      else begin
        dec(R);
        Continue;
      end;
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // Shares
      ShStr := copy(line, 1, pos(sep, line) - 1);
      ShStr := delCommas(ShStr);
      ShStr := DelParenthesis(ShStr);
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // delete Cusip
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // delete ADP
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // ticker
      tick := copy(line, 1, pos(sep, line) - 1);
      tick := trim(tick);
      if tick = 'QQQ' then
        tick := 'QQQQ';
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // call/put
      optStr := copy(line, 1, pos(sep, line) - 1);
      optStr := trim(optStr);
      if (optStr = 'CALL') or (optStr = 'PUT') then
        contracts := true;
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // CallPut column blank - check last column 1-8-08
      if (optStr = '') and (copy(line, 1, pos(sep, line) - 1) <> '')
      // underlying tick not blank
      then begin
        optStr := parseLast(line, sep);
        if (pos('P ', optStr) = 1) then begin
          optStr := 'PUT';
          contracts := true;
          missingPutCall := true;
        end
        else if (pos('C ', optStr) = 1) then begin
          optStr := 'CALL';
          contracts := true;
          missingPutCall := true;
        end
        else begin
          optStr := '';
          contracts := false;
        end;
      end;
      // underlying ticker
      if contracts then begin
        optTick := tick;
        tick := copy(line, 1, pos(sep, line) - 1);
      end;
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // expire date
      if contracts then begin
        expDt := copy(line, 1, pos(sep, line) - 1);
        if length(expDt) < 10 then
          expDt := LongDateStr(expDt);
        expMo := copy(expDt, 1, 2);
        if expMo = '01' then
          expMo := 'JAN'
        else if expMo = '02' then
          expMo := 'FEB'
        else if expMo = '03' then
          expMo := 'MAR'
        else if expMo = '04' then
          expMo := 'APR'
        else if expMo = '05' then
          expMo := 'MAY'
        else if expMo = '06' then
          expMo := 'JUN'
        else if expMo = '07' then
          expMo := 'JUL'
        else if expMo = '08' then
          expMo := 'AUG'
        else if expMo = '09' then
          expMo := 'SEP'
        else if expMo = '10' then
          expMo := 'OCT'
        else if expMo = '11' then
          expMo := 'NOV'
        else if expMo = '12' then
          expMo := 'DEC';
        expMo := copy(expDt, 4, 2) + expMo + copy(expDt, 9, 2);
      end;
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // strike price
      if contracts then begin
        strikePr := copy(line, 1, pos(sep, line) - 1);
        // get rid of trailing zeros
        if pos('.', strikePr) > 0 then begin
          while (copy(strikePr, length(strikePr), 1) = '0') do
            delete(strikePr, length(strikePr), 1);
        end;
        if pos('.', strikePr) = length(strikePr) then
          delete(strikePr, length(strikePr), 1);
        tick := trim(tick);
        if TaxYear = '2004' then
          if tick = 'QQQ' then
            tick := 'QQQQ';
        tick := tick + ' ' + expMo + ' ' + strikePr + ' ' + optStr
      end;
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // date
      ImpDate := LongDateStr(copy(line, 1, pos(sep, line) - 1));
      delete(line, 1, pos(sep, line));
      line := trim(line);
      if not ValidTradeDate(ImpDate, ImpDateLast, ImpNextDateOn) then begin
        dec(R);
        Continue;
      end;
      // delete Settle date
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // delete activity date
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // price
      PrStr := copy(line, 1, pos(sep, line) - 1);
      PrStr := delCommas(PrStr);
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // amount
      AmtStr := copy(line, 1, pos(sep, line) - 1);
      AmtStr := delCommas(AmtStr);
      AmtStr := DelParenthesis(AmtStr);
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // US dollars
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // US Description
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // time column
      if newFormat then begin
        delete(line, 1, pos(sep, line));
        line := trim(line);
      end;
      if (pos(',', line) > 0) then begin
        TimeStr := copy(line, 1, pos(sep, line) - 1);
        TimeStr := parseLast(TimeStr, ' ');
        if length(TimeStr) > 8 then
          TimeStr := copy(TimeStr, 1, 8);
        if length(TimeStr) = 4 then
          TimeStr := TimeStr + '00';
        if (length(TimeStr) = 6) then
          TimeStr := copy(TimeStr, 1, 2) + ':' + copy(TimeStr, 3, 2) + ':' + copy(TimeStr, 5, 2);
      end
      else
        TimeStr := '';
      //
      if tick = '' then begin
        tick := copy(line, 1, 20);
        sm('ERROR TICKER SYMBOL MISSING FOR:' + cr + cr + tick + cr + cr + ImpDate);
      end;
      // delete any asterisks from ticker
      while pos('*', tick) > 0 do
        delete(tick, pos('*', tick), 1);
      // sm(Impdate+tab+TimeStr+tab+oc+ls+tab+tick+tab+shstr+tab+prstr+tab+amtstr);
      // continue;
      try
        Price := StrToFloat(PrStr, Settings.InternalFmt);
        if Price < 0 then
          Price := -Price;
        Shares := StrToFloat(ShStr, Settings.InternalFmt);
        if Shares < 0 then
          Shares := -Shares;
        if contracts then begin
          ImpTrades[R].prf := 'OPT-100';
          mult := 100;
          if not missingPutCall then
            Shares := Shares / 100;
        end
        else begin
          ImpTrades[R].prf := 'STK-1';
          mult := 1;
        end;
        Amt := StrToFloat(AmtStr, Settings.InternalFmt);
        if Amt < 0 then
          Amt := -Amt;
        if (oc = 'O') and (ls = 'L') then
          Commis := Amt - (Shares * Price * mult)
        else if (oc = 'C') and (ls = 'L') then
          Commis := (Shares * Price * mult) - Amt
        else if (oc = 'O') and (ls = 'S') then
          Commis := (Shares * Price * mult) - Amt
        else if (oc = 'C') and (ls = 'S') then
          Commis := Amt - (Shares * Price * mult);
        // ------------------
        ImpTrades[R].it := TradeLogFile.Count + R;
        ImpTrades[R].tr := 0;
        ImpTrades[R].DT := ImpDate;
        ImpTrades[R].tm := TimeStr;
        ImpTrades[R].oc := oc;
        ImpTrades[R].ls := ls;
        ImpTrades[R].tk := tick;
        ImpTrades[R].opTk := optTick;
        ImpTrades[R].sh := Shares;
        ImpTrades[R].pr := Price;
        ImpTrades[R].cm := Commis;
        ImpTrades[R].am := Amt;
      except
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        dec(R);
        Continue;
      end;
    end;
    ReverseImpTradesDate(R);
    ImpStrList.Destroy;
    result := R;
  finally
    // ReadTradeStationCSV
  end;
end;

// ------------------------------------
function ReadTradeStation(): integer;
// ------------------------------------
var
  R : integer;
  startDt : TDate;
begin
  try
    R := 0;
    ImpStrList := TStringList.Create;
    ImpTrades := nil;
    gBCImpStep := imBC_beforeLogin;
    setLength(ImpTrades, R + 1);
    // --------------------------------
    // options: File, BC
    if sImpMethod = 'BC' then begin // imBrokerConnect:
      GetImpDateLast;
      startDt := dateOf(now() - 1);
        // set start date to Mon thru Fri
      if dayOfWeek(startDt) = 1 then
        startDt := startDt - 2
      else if dayOfWeek(startDt) = 7 then
        startDt := dateOf(startDt - 1);
      if startDt = xStrToDate(ImpDateLast, Settings.InternalFmt) then begin
        sm('Trades already imported up to ' + ImpDateLast + cr + cr +
            'Please wait till tomorrow to import again');
        result := 0;
        exit;
      end;
      formGet.showmodal;
      if cancelURL then
        exit;
      GetImpStrListFromWebGet(false);
      result := ReadTradeStationCSV(ImpStrList);
      exit;
    end
    // --------------------------------
    else if sImpMethod = 'File' then begin // CSVImport
      GetImpStrListFromFile('TradeStation', 'csv', '');
      result := ReadTradeStationCSV(ImpStrList);
      exit;
    end;
  finally
    // ReadTradeStation
  end;
end;


         // -----------------
         // TradeMonster
         // -----------------

function ReadTradeMonsterCSV(ImpStrList : TStringList): integer;
var
  C, i, j, p, R : integer;
  Commis : double;
  ImpFile : textfile;
  trType, descr, dd, mmm, mm, yyyy, strike, callPut, opTk, sType, expdate, openClose, line, ImpDate,
    TimeStr, ShStr, PrStr, AmtStr, NextDate, junk, opNoTk, exYr, exMo : string;
  mult : double;
  optExp, contracts, ImpNextDateOn, hasOpNoTk, cancels : boolean;
  oc, ls : string;
begin
  try
    // updated 2011-11-22 fix for dates with single digit days
    DataConvErrRec := '';
    DataConvErrStr := '';
    Commis := 0;
    R := 0;
    ImpNextDateOn := false;
    opNoTk := '';
    hasOpNoTk := false;
    cancels := false;
    GetImpDateLast;
    if ImpStrList.Count < 1 then begin
      ImpStrList.Destroy;
      result := 0;
      exit;
    end;
    for i := 0 to ImpStrList.Count - 1 do begin
      contracts := false;
      optExp := false;
      opTk := '';
      trType := '';
      inc(R);
      if R < 1 then
        R := 1;
      line := ImpStrList[i];
      // delete all quotes
      while pos('"', line) > 0 do begin
        delete(line, pos('"', line), 1);
      end;
      if line = '' then begin
        dec(R);
        Continue;
      end;
      // add extra comma if no comma exists
      line := line + ',';
      // delete trans id fld
      delete(line, 1, pos(',', line));
      ImpDate := trim(copy(line, 1, pos(',', line) - 1));
      if (pos('-', ImpDate) = 0) and (pos('/', ImpDate) = 0) then begin
        dec(R);
        Continue;
      end;
      // dd-mmm-yy format
      if (pos('-', ImpDate) > 1) then begin
        dd := copy(ImpDate, 1, pos('-', ImpDate) - 1);
        delete(ImpDate, 1, pos('-', ImpDate));
        mmm := uppercase(copy(ImpDate, 1, pos('-', ImpDate) - 1));
        mm := MMMtoMM(mmm);
        yyyy := parseLast(ImpDate, '-');
        // test for 2 or 4 digit year
        if length(yyyy) = 2 then
          ImpDate := mm + '/' + dd + '/20' + yyyy
        else
          ImpDate := mm + '/' + dd + '/' + yyyy;
      end
      else
        ImpDate := LongDateStr(ImpDate);
      delete(line, 1, pos(',', line));
      ImpDate := LongDateStr(ImpDate);
      if not ValidTradeDate(ImpDate, ImpDateLast, ImpNextDateOn) then begin
        dec(R);
        Continue;
      end;
      // time
      TimeStr := trim(copy(line, 1, pos(',', line) - 1));
      delete(line, 1, pos(',', line));
      // del type
      trType := trim(copy(line, 1, pos(',', line) - 1));
      if (pos('Corporate Action', trType) > 0) or (pos('Withdrawal', trType) > 0) or
        (pos('Expiration', trType) > 0) // expirations only have ticker symbol
      then begin
        dec(R);
        Continue;
      end;
      delete(line, 1, pos(',', line));
      // del descr
      descr := trim(copy(line, 1, pos(',', line) - 1));
      if (pos('SYMBOL_CHANGE', descr) > 0) then begin
        dec(R);
        Continue;
      end;
      delete(line, 1, pos(',', line));
      // strike
      strike := trim(copy(line, 1, pos(',', line) - 1));
      delete(line, 1, pos(',', line));
      // Call or put
      callPut := trim(copy(line, 1, pos(',', line) - 1));
      if (callPut = 'CALL') or (callPut = 'PUT') then
        contracts := true; // 2015-03-11
      delete(line, 1, pos(',', line));
      // Open/Close (Side column)
      oc := uppercase(copy(line, 1, pos(',', line) - 1));
      if oc = 'BUY' then begin
        oc := 'O';
        ls := 'L';
      end
      else if oc = 'SELL' then begin
        oc := 'C';
        ls := 'L';
      end
      else begin
        dec(R);
        Continue;
      end;
      delete(line, 1, pos(',', line));
      // correction trades - must match to trade and delete both
      if (pos('Adjustment', trType) > 0) then begin
        oc := 'X';
        cancels := true;
      end;
      // qty
      ShStr := trim(copy(line, 1, pos(',', line) - 1));
      delete(line, 1, pos(',', line));
      // symbol
      tick := trim(copy(line, 1, pos(',', line) - 1));
      delete(line, 1, pos(',', line));
      // price
      PrStr := trim(copy(line, 1, pos(',', line) - 1));
      delete(line, 1, pos(',', line));
      // underlying ticker
      opTk := trim(copy(line, 1, pos(',', line) - 1));
      delete(line, 1, pos(',', line));
      // del fees
      delete(line, 1, pos(',', line));
      // del comm
      delete(line, 1, pos(',', line));
      // amt
      AmtStr := trim(copy(line, 1, pos(',', line) - 1));
      delete(line, 1, pos(',', line));
      // sec type
      sType := uppercase(trim(copy(line, 1, pos(',', line) - 1)));
      if sType = 'OPTION' then
        contracts := true;
      delete(line, 1, pos(',', line));
      // exp date
      expdate := trim(copy(line, 1, pos(',', line) - 1));
      delete(line, 1, pos(',', line));
      // del descr
      delete(line, 1, pos(',', line));
      // open/close
      openClose := uppercase(trim(copy(line, 1, pos(',', line) - 1)));
      delete(line, 1, pos(',', line));
      // --------------------
      try
        Price := StrToFloat(PrStr, Settings.InternalFmt);
        Shares := StrToFloat(ShStr, Settings.InternalFmt);
        if Shares < 0 then
          Shares := -Shares;
        Amt := StrToFloat(AmtStr, Settings.InternalFmt);
        if Amt < 0 then
          Amt := -Amt;
        if contracts then begin
          if (strike = '0') and (callPut = '') and (opTk = '') and not isInt(leftStr(tick, 1)) and
            isInt(rightStr(tick, 6)) then begin
            opTk := tick;
            // parse out OPRA symbol "OQR E 2210 C 040000"
            strike := rightStr(tick, 6);
            // add decimal point
            strike := leftStr(strike, 3) + '.' + rightStr(strike, 3);
            // trim trailing zeros from strike
            delTrailingZeros(strike);
            // trim zeros from beginning of strike;
            while leftStr(strike, 1) = '0' do
              delete(strike, 1, 1);
            delete(tick, length(tick) - 5, 6);
            callPut := rightStr(tick, 1);
            if callPut = 'C' then
              callPut := 'CALL'
            else if callPut = 'P' then
              callPut := 'PUT';
            delete(tick, length(tick), 1);
            exYr := rightStr(tick, 2);
            delete(tick, length(tick) - 3, 4);
            exMo := rightStr(tick, 1);
            delete(tick, length(tick), 1);
            if not isInt(exMo) then
              exMo := getExpMonth(exMo);
            tick := uppercase(tick + ' ' + exMo + exYr + ' ' + strike + ' ' + callPut);
            hasOpNoTk := true;
            if pos(tick, opNoTk) = 0 then
              opNoTk := opNoTk + tick + cr;
            ImpTrades[R].prf := 'OPT-100';
            mult := 100;
          end
          else begin
            // trim trailing zeros from strike
            if (pos('.', strike) > 1) then
              strike := delTrailingZeros(strike);
            // new exp date format: 21-Nov-09 or 21-Nov-2009
            if pos('-', expdate) > 0 then begin
              if length(expdate) = 11 then
                delete(expdate, 8, 2); // 4 digit year
              // delete dashes from expdate
              while pos('-', expdate) > 0 do
                delete(expdate, pos('-', expdate), 1);
            end
            else if pos('/', expdate) > 0 then begin // new exp date format: 03/19/11 or 03/19/2011
              if length(expdate) = 10 then
                delete(expdate, 7, 2); // 4 digit year
              mm := copy(expdate, 1, 2);
              mm := getExpMo(mm);
              dd := copy(expdate, 4, 2);
              yyyy := copy(expdate, 7, 2);
              expdate := dd + mm + yyyy;
            end;
            // check to make sure expire year is correct
            if rightStr(expdate, 2) < rightStr(ImpDate, 2) then
              expdate := copy(expdate, 1, length(expdate) - 2) + rightStr(ImpDate, 2);
            // 2015-03-11 test for weekly options
            if (pos(opTk + '7', tick)= 1) then begin
              ImpTrades[R].prf := 'OPT-10';
              mult := 10;
            end
            else begin
              ImpTrades[R].prf := 'OPT-100';
              mult := 100;
            end;
            ImpTrades[R].opTk := tick;
            tick := uppercase(opTk + ' ' + expdate + ' ' + strike + ' ' + callPut);
          end;
        end
        else begin
          ImpTrades[R].prf := 'STK-1';
          mult := 1;
        end;
        // long/short
        if (openClose = 'OPEN') then begin
          if (oc = 'C') then begin // sell
            oc := 'O';
            ls := 'S';
          end
          else begin // buy
            oc := 'O';
            ls := 'L';
          end;
        end
        else if (openClose = 'CLOSE') then begin
          if (oc = 'O') then begin // buy
            oc := 'C';
            ls := 'S';
          end
          else begin // sell
            oc := 'C';
            ls := 'L';
          end;
        end;
        if (oc = 'O') and (ls = 'L') then
          Commis := Amt - (Shares * Price * mult)
        else if (oc = 'C') and (ls = 'L') then
          Commis := (Shares * Price * mult) - Amt
        else if (oc = 'O') and (ls = 'S') then
          Commis := (Shares * Price * mult) - Amt
        else if (oc = 'C') and (ls = 'S') then
          Commis := Amt - (Shares * Price * mult);
        ImpTrades[R].it := TradeLogFile.Count + R;
        ImpTrades[R].tr := 0;
        ImpTrades[R].DT := ImpDate;
        ImpTrades[R].tm := TimeStr;
        ImpTrades[R].oc := oc;
        ImpTrades[R].ls := ls;
        ImpTrades[R].tk := tick;
        ImpTrades[R].sh := Shares;
        ImpTrades[R].pr := Price;
        ImpTrades[R].cm := Commis;
        ImpTrades[R].am := Amt;
        ImpTrades[R].no := '';
        ImpTrades[R].strategy := '';
        ImpTrades[R].m := '';
        ImpTrades[R].br := IntToStr(TradeLogFile.CurrentBrokerID);
      except
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        dec(R);
        Continue;
      end;
    end;
    if cancels then begin
      for i := 1 to R do begin
        if (ImpTrades[i].oc = 'X') then
          for j := 1 to R do begin
            if (ImpTrades[i].tk = ImpTrades[j].tk) and (ImpTrades[i].sh = ImpTrades[j].sh) and
              (ImpTrades[i].pr = ImpTrades[j].pr) and (ImpTrades[j].oc <> '') and (i <> j) then
            begin
              ImpTrades[i].oc := '';
              ImpTrades[i].ls := '';
              ImpTrades[j].oc := '';
              ImpTrades[j].ls := '';
              break;
            end;
          end;
      end;
    end;
    StatBar('off');
    if hasOpNoTk then
      sm('The following option trades may not have the right underlying stock ticker symbol:' + cr +
          cr + opNoTk + cr + 'Please edit these trades.');
    if R > 0 then
      SortImpByDate(R);
    result := R;
  finally
    // ReadTradeMonsterCSV
  end;
end;


function ReadTradeMonster(): integer;
var
  R : integer;
begin
  try
    R := 0;
    ImpStrList := TStringList.Create;
    ImpTrades := nil;
    setLength(ImpTrades, R + 1);
    GetImpDateLast;
    // --------------------------------
    if sImpMethod = 'BC' then begin // BrokerConnect:
      formGet.showmodal;
      if cancelURL then
        exit;
      getTMCSV(OFXDateStart, OFXDateEnd);
      GetImpStrListFromWebGet(false);
      result := ReadTradeMonsterCSV(ImpStrList);
      exit;
    end
    // --------------------------------
    else if sImpMethod = 'File' then begin // CSVImport
      GetImpStrListFromFile('TradeMonster', 'csv', '');
      result := ReadTradeMonsterCSV(ImpStrList);
      exit;
    end;
    // --------------------------------
  finally
    // ReadTradeMonster
  end;
end;


// ------------------------------------
// TradeZero
// ------------------------------------
function ReadTradeZeroCSV(ImpStrList : TStringList): integer;
var
  i, j, k, start, eend, R, Q, iFmt, nDateErrors : integer;
  iDt, iLS, iTk, iShr, iPr, iAmt, iTime, iGross : integer; // import field numbers
  junk, sep, ImpDate, ImpTime, CmStr, feeStr, PrStr, AmtStr, ShStr, line, //
    oc, ls, dd, mm, yyyy, opTick, sPRF : string;
  Amount, Commis, Fees, Shares, mult, Gross : double;
  contracts, Adj, optExpEx, ImpNextDateOn, bonds, miniOptions, bFoundHeader, cancels : boolean;
  fieldLst : TStrings;
  dtExec : TDateTime;
  // ----------------------------------------------------------------
  // ## FIELD (OLD)    EXAMPLE       FIELD (NEW)     EXAMPLE
  // 0. Account                      Tr No           227517587
  // DT  1. T/D            11/1/2016  DT Trade Date      6/13/2019
  // 2. S/D            11/4/2016     Settle Date     6/17/2019
  // 3. Currency       USD           Account         <sometext>
  // 4. Type           3             Company Name    <customer>
  // LS  5. Side           SS            Account Type    M
  // TK  6. Symbol         NUGT       TK Symbol          CODA
  // SH  7. Qty            500        LS Side            SS
  // PR  8. Price          14.88      SH QTY             -200
  // 9. Exec Time      8:39:07    PR Price           12.9
  // 10. Comm           2.5           Gross Amount    2580
  // 11. SEC            0.17       AM Net Amount      2579.91
  // 12. TAF            0.06          Commission      0
  // 13. NSCC           0.033         Reg Fee         -0.06
  // 14. Nasdaq         0.00785       PTFPF           0
  // 15. ECN Remove     0             ECN Fee         0
  // 16. ECN Add        0             TAF Fee         -0.03
  // 17. Gross Proceeds 7440          ORF Fee
  // AM 18. Net Proceeds   7437.22915    Broker Fee
  // 19. Clr Broker     NSDQ          Fees            0.09
  // 20. Liq            7
  // 21. Note
  // ----------------------------------------------------------------
  procedure SetFieldNumbers;
  var
    j : integer;
  begin
    // find/map TradeZero CSV fields
    k := 0;
    for j := 0 to (fieldLst.Count - 1) do begin
      if (fieldLst[j] = 'T/D') // Date/Time
        or (fieldLst[j] = 'TRADE DATE') then begin
        iDt := j;
        k := k or 1;
      end
      else if (fieldLst[j] = 'SYMBOL') then begin // Ticker
        iTk := j;
        k := k or 2;
      end
      else if (fieldLst[j] = 'SIDE') then begin // Long/Short
        iLS := j;
        k := k or 4;
      end
      else if (fieldLst[j] = 'QTY') then begin // Shares/Contracts
        iShr := j;
        k := k or 8;
      end
      else if (fieldLst[j] = 'PRICE') then begin // PR
        iPr := j;
        k := k or 16;
      end
      else if (fieldLst[j] = 'NET PROCEEDS') // AMT
        or (fieldLst[j] = 'NET AMOUNT') then begin
        iAmt := j;
        k := k or 32;
      end
      else if (fieldLst[j] = 'EXEC TIME') then begin // Time
        iTime := j;
        // note: do not alter k for time field
      end
      else if (copy(fieldLst[j], 1, 6) = 'GROSS ') then begin // Time
        iGross := j;
        // note: do not alter k for Gross either
      end; // note: 'RATE' field is conversion factor
    end; // for j
  end;
  // ------------------------
  function ParseOption(s : string): string;
  var
    n, i : integer;
    sUnd, sExp, sCP, sStrike, sYY, sMM, sDD : string;
  begin
    n := length(s);
    sUnd := '';
    sExp := '';
    sCP := '';
    sStrike := '';
    result := '';
    for i := n downto 1 do begin
      if sCP = '' then begin
        if isnumeric(s[i]) then begin
          sStrike := s[i] + sStrike;
        end // get sStrike
        else begin
          if uppercase(s[i]) = 'C' then
            sCP := 'CALL'
          else if uppercase(s[i]) = 'P' then
            sCP := 'PUT'
          else exit; // not an option
          if length(sStrike) < 6 then exit; // not an option
          sStrike := delLeadingZeros(leftstr(sStrike, length(sStrike)-3)) //
            + delTrailingZeros('.' + rightstr(sStrike,3));
        end; // get sCP
      end else begin
        if isnumeric(s[i]) then begin
          sExp := s[i] + sExp; // exp. date
        end else begin
          if length(sExp) <> 6 then exit; // not an option
          sYY := leftstr(sExp,2);
          sDD := rightstr(sExp,2);
          sMM := copy(sExp, 3, 2);
          sMM := getExpMo(sMM);
          sExp := sDD + sMM + sYY;
          sUnd := leftstr(s,i);
          result := sUnd + ' ' + sExp + ' ' + sStrike + ' ' + sCP;
        end;
      end;
    end;
  end; // ParseOption
// ------------------------------------
begin
  bFoundHeader := false;
  cancels := false;
  iDt := 0;
  iLS := 0;
  iTk := 0;
  iShr := 0;
  iPr := 0;
  iAmt := 0;
  iTime := -1;
  R := 0;
  iFmt := 0;
  nDateErrors := 0;
  try
    // redesigned 2020-09-17 MB
    DataConvErrRec := '';
    R := 0;
    Adj := false;
    ImpNextDateOn := false;
    iFmt := 0;
    // --------------------------------
    if ImpStrList.Count < 1 then begin
      ImpStrList.Destroy;
      result := 0;
      exit;
    end;
    fieldLst := TStrings.Create;
    // --------------------------------
    i := -1;
    while i < (ImpStrList.Count - 1) do begin
      inc(i); // make it work like a for/next
      contracts := false;
      miniOptions := false;
      optExpEx := false;
      bonds := false;
      // ------------------------------
      line := ImpStrList[i];
      line := uppercase(line);
      // parse all columns into string list
      fieldLst := ParseCSV(line);
      if (fieldLst.Count < iDt) then
        Continue; // bad record
      if not bFoundHeader then begin
        if (pos('SYMBOL', line) > 0) //
          and (pos('QTY', line) > 0) then begin
          SetFieldNumbers;
          if SuperUser and (k <> 63) then
            sm('there appear to be fields missing.');
          bFoundHeader := true; // don't do this again
        end;
        R := 0; // start now
        Continue; // don't process anything until we recognize header
      end; // if bFoundHeader
      // ------------------------------
      if pos('too many transactions', line) > 0 then begin
        sm('The date range you have selected contains too many transactions.' + cr +
            'A maximum of 1500 transactions can be obtained at once.' + cr +
            'Please reduce the date range for your Schwab report and try again.');
        result := 0;
        exit;
      end;
      sep := ',';
      // --- Date -----------
      ImpDate := fieldLst[iDt]; // format: mm/d/yyyy
      if length(ImpDate) > 6 then begin // MIN: m/d/yy
        mm := parsefirst(ImpDate, '/');
        dd := parsefirst(ImpDate, '/');
        if length(dd) = 1 then
          dd := '0' + dd;
        yyyy := ImpDate;
        if length(yyyy) = 2 then
          ImpDate := mm + '/' + dd + '/20' + yyyy
        else
          ImpDate := mm + '/' + dd + '/' + yyyy;
      end;
      if not isDate(ImpDate) then begin
        nDateErrors := nDateErrors + 1;
        if nDateErrors < 2 then begin
          sm('Cannot determine the transaction date:' + cr //
            + ImpDate + cr //
            + 'mm/dd/yyyy format expected.');
        end;
        continue;
      end;
      if not ValidTradeDate(ImpDate, ImpDateLast, ImpNextDateOn) then begin
        Continue;
      end;
      inc(R); // if it gets this far, count it
      // --- buy/sell + long/short ---
      junk := uppercase(trim(fieldLst[iLS]));
      // SS, BC, B, S -- which I assume are Sell Short, Buy to Close, Buy and Sell
      if (junk = 'SS') then begin
        // Sell Short --> O/S
        oc := 'O';
        ls := 'S';
      end
      else if (junk = 'BC') then begin
        // Buy to Close --> C/S
        oc := 'C';
        ls := 'S';
      end
      else if (junk = 'B') then begin
        // Buy --> O/L
        oc := 'O';
        ls := 'L';
      end
      else if (junk = 'S') then begin
        // Sell --> C/L
        oc := 'C';
        ls := 'L';
      end
      else begin
        sm('Cannot determine if this trade is open or close:' + cr + line);
        Continue; // skip the record if we can't tell which
      end;
      // --- description ----
      // --- # shares -------
      ShStr := fieldLst[iShr];
      ShStr := delCommas(ShStr);
      // --- ticker ---
      tick := trim(fieldLst[iTk]);
      // --- options --------
      if length(tick) > 9 then begin
        opTick := ParseOption(tick);
        contracts := not(opTick = '');
      end;
      // --- price ----------
      PrStr := fieldLst[iPr];
      delete(PrStr, pos('$', PrStr), 1);
      PrStr := delCommas(PrStr);
      if optExpEx then
        PrStr := '0.00';
      // --- commission -----
      // calculate (below)
      // --- amount ---------
      AmtStr := fieldLst[iAmt];
      if (pos('$', AmtStr) > 0) then
        delete(AmtStr, pos('$', AmtStr), 1);
      AmtStr := delCommas(AmtStr);
      if (AmtStr = '') or (pos('*', AmtStr) > 0) then
        AmtStr := '0.00';
      // --------------------
      try
        Shares := StrToFloat(ShStr, Settings.InternalFmt);
        if Shares = 0 then begin
          dec(R);
          Continue;
        end;
        if Shares < 0 then
          Shares := -Shares;
        // ----------------------------
        Price := StrToFloat(PrStr, Settings.InternalFmt);
        if (leftStr(AmtStr, 1)= '(') and (rightStr(AmtStr, 1)= ')') then
          AmtStr := '-' + copy(AmtStr, 2, length(AmtStr)- 2);
        Amount := CurrToFloat(AmtStr);
        if Amount < 0 then begin
          Amount := -Amount;
        end;
        // ----------------------------
        // assume stock for now
        if contracts then begin
          sPRF := 'OPT-100';
          mult := 100;
          junk := tick;
          tick := opTick;
          opTick := junk;
          contracts := false;
        end else begin
          mult := 1;
          sPRF := 'STK-1';
        end;
        // ----------------------------
        // ignore the comm and fees fields and just calculate commission
        if ((oc = 'O') and (ls = 'L')) or ((oc = 'C') and (ls = 'S')) then // buy
          Commis := Amount - (Shares * mult * Price) // Amount = Gross + Commis
        else // sell
          Commis := (Shares * mult * Price) - Amount; // Amount = Gross - Commis
        // ----------------------------
        // time (if any)
        if iTime >= 0 then begin
          ImpTime := trim(fieldLst[iTime]);
          try
            dtExec := StrToTime(ImpTime);
          except
            ImpTime := ''; // discard invalid time
          end;
        end;
        // ----------------------------
        ImpTrades[R].DT := ImpDate;
        ImpTrades[R].tm := ImpTime;
        ImpTrades[R].oc := oc;
        ImpTrades[R].ls := ls;
        ImpTrades[R].tk := trim(tick);
        ImpTrades[R].prf := sPRF;
        ImpTrades[R].opTk := trim(opTick);
        ImpTrades[R].sh := Shares;
        ImpTrades[R].pr := Price;
        ImpTrades[R].am := Amount;
        ImpTrades[R].cm := rndto2(Commis);
      except
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        dec(R);
        Continue;
      end; // try...except
      ImpTrades[R].it := TradeLogFile.Count + R;
    end; // while
    // --------------------------------
    if R > 1 then begin // 2020/09/22 - MB - if trades in reverse order
      if (xStrToDate(ImpTrades[1].DT) > xStrToDate(ImpTrades[R].DT)) then
        ReverseImpTradesDate(R);
      fixImpTradesOutOfOrder(R);
    end;
    // --------------------------------
    ImpStrList.Destroy;
    result := R;
  finally
    fieldLst.Free;
    // ReadTradeZeroCSV
  end;
end;


// ENTRY POINT
function ReadTradeZero(): integer;
var
  R : integer;
begin
  try
    R := 0;
    ImpStrList := TStringList.Create;
    ImpTrades := nil;
    setLength(ImpTrades, R + 1);
    GetImpDateLast;
    if FileExists(Settings.ImportDir + '\download.csv') then
      deleteFile(Settings.ImportDir + '\download.csv');
    GetImpStrListFromFile('TradeZero', 'csv', '');
    result := ReadTradeZeroCSV(ImpStrList);
    exit;
  finally
    // ReadTradeZero
  end;
end;


         // -----------------
         // T. Rowe Price
         // -----------------

function ReadTRoweCSV(ImpStrList : TStringList) : integer;
var
  i, j, k, start, eend, R, Q : integer;
  iDt, iOC, iTk, iDesc, iShr, iPr, iAmt : integer; // import field numbers
  junk, sep, ImpDate, PrStr, AmtStr, ShStr, line, prfStr, //
    oc, ls, dd, mm, yyyy, errLogTxt : string;
  Amount, Commis, Fees, Shares, mult : double;
  contracts, Adj, optExpEx, ImpNextDateOn, bonds, newColFormat, miniOptions, futures, //
    bFoundHeader, cancels, assigns : boolean;
  fieldLst : TStrings;
  // --- TRowePrice --------
  // 1  --  Account Type	      Joint Tenant
  // 2  DT  Trade Date	        12/23/2019 (mm/dd/yyyy)
  // 3  OC  Transaction Type	  SELL	BUY
  // 4  DES Transaction Details	DIREXION SHS ETF TR DAILY SM CAP BEAR 3X SHS NEW UNSOLICITED ORDER
  // 5  --  Account Name	      Joint Tenant - Brokerage
  // 6  TK  Account Ticker	    TZA
  // 7  --  Account Number	    T3P15108-0
  // 8  --  Owners	            Mary Beth Ford, Richard W. Ford
  // 9  AMT Net Dollar Amount	  $59,380.49
  // 10 SHR Quantity	            1,690.00
  // 11 PR  Price	              $35.14
  // note: AMT, SHR and PR are always positive
  // ----------------------------------
  procedure SetFieldNumbers();
  var
    j : integer;
  begin
    // find/map TRowe CSV fields
    k := 0;
    for j := 0 to (fieldLst.Count - 1) do begin
      if fieldLst[j] = 'TRADE DATE' then begin // MM/DD/YYYY
        iDt := j;
        k := k or 1;
      end
      else if fieldLst[j] = 'TRANSACTION TYPE' then begin // SELL or BUY
        iOC := j;
        k := k or 2;
      end
      else if (fieldLst[j] = 'QUANTITY') then begin // Shares/Contracts
        iShr := j;
        k := k or 4;
      end
      else if fieldLst[j] = 'ACCOUNT TICKER' then begin // Ticker
        iTk := j;
        k := k or 8;
      end
      else if fieldLst[j] = 'TRANSACTION DETAILS' then begin // DESCRIPTION
        iDesc := j;
        k := k or 16;
      end
      else if fieldLst[j] = 'PRICE' then begin
        iPr := j;
        k := k or 32;
      end
      else if fieldLst[j] = 'NET DOLLAR AMOUNT' then begin // Comm
        iAmt := j;
        k := k or 64;
      end; // note: 'RATE' field is conversion factor
    end;
  end;
// --------------------------------------------
begin
  bFoundHeader := false; // haven't found the header yet
  DataConvErrRec := '';
  // in case these are missing, flag to skip them.
  cancels := false;
  R := 0;
  // ----------------------------------
  try
    if ImpStrList.Count < 1 then begin
      ImpStrList.Destroy;
      result := 0;
      exit;
    end;
    // -----------------
    DataConvErrRec := '';
    DataConvErrStr := '';
    Adj := false;
    ImpNextDateOn := false;
    newColFormat := false;
    // -----------------
    // 2020-07-24 MB - for now, we'll only support stocks
    prfStr := 'STK-1';
    mult := 1;
    // -----------------
    fieldLst := TStrings.Create;
    // --------------------------------
    i := -1;
    while i < (ImpStrList.Count - 1) do begin
      inc(i); // make it work like a for/next
      contracts := false; // reset flags
      assigns := false;
      futures := false;
      miniOptions := false;
      optExpEx := false;
      bonds := false;
      // ------------------------------
      line := ImpStrList[i];
      line := uppercase(line); // search line for UPPERCASE tokens...
      // parse all columns into string list
      fieldLst := ParseCSV(line);
      if not bFoundHeader then begin
        if (pos('DATE', line) > 0) and (pos('QUANTITY', line) > 0) //
          and (pos('TICKER', line) > 0) then begin
          SetFieldNumbers;
          if SuperUser and (k <> 127) then
            sm('there appear to be fields missing.');
          bFoundHeader := true; // don't do this anymore
          R := 0; // start now
        end;
        Continue; // don't process anything until we recognize the header
      end;
      // ------------------------------
      if pos('ERROR', line) > 0 then begin
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        sm('Ninja reported an error.' + cr + 'Please reduce the date range and try again.');
        result := 0;
        exit;
      end;
      // ------------------------------
      // --- Date ---------------------
      // ------------------------------
      ImpDate := fieldLst[iDt]; // format: M/DD/YYYY
      if pos('/', ImpDate) = 2 then
        ImpDate := '0' + ImpDate;
      if not isdate(ImpDate) then
        sm('Cannot determine the transaction date of this trade:' + cr + line);
      if not ValidTradeDate(ImpDate, ImpDateLast, ImpNextDateOn) then begin
// DataConvErrRec := DataConvErrRec + 'invalid date: ' + ImpStrList[i] + cr;
        Continue;
      end;
      if UserDateStrNotGreater(ImpDate, ImpDateLast) then begin
        if mDlg('Trades already imported for ' + ImpDate + cr //
            + cr //
            + 'Continue?', mtWarning, [mbNo, mbYes], 0) = mrNo then begin
          result := R;
          exit;
        end
        else
          ImpDateLast := '01/01/1900';
      end;
      // --- ticker -------------------
      tick := trim(fieldLst[iTk]);
      if tick = '' then
        tick := trim(fieldLst[iDesc]);
      // --- OC and LS ----------------
      junk := trim(fieldLst[iOC]);
      if (junk = 'BUY') then begin
        oc := 'O';
        ls := 'L';
      end
      else if (junk = 'SELL') then begin
        oc := 'C';
        ls := 'L';
      end
      else begin
        oc := 'E'; // error
        ls := 'E';
        Continue;
      end;
      inc(R); // if it gets this far, count it
      // --- # shares -----------------
      ShStr := fieldLst[iShr];
      ShStr := delCommas(ShStr);
      // --- price --------------------
      PrStr := fieldLst[iPr];
      delete(PrStr, pos('$', PrStr), 1);
      PrStr := delCommas(PrStr);
      if (xStrToFloat(PrStr) = 0) then
        PrStr := '0.00';
      // --- Amount -------------------
      Amount := 0;
      AmtStr := fieldLst[iAmt];
      delete(AmtStr, pos('$', AmtStr), 1);
      AmtStr := delCommas(AmtStr);
      if (xStrToFloat(AmtStr) = 0) then
        AmtStr := '0.00';
      // --- Commission ---------------
      Commis := 0;
      try
        Shares := CurrToFloat(ShStr);
        if Shares < 0 then
          Shares := -Shares;
        // ----------------------------
        Price := CurrToFloat(PrStr);
        if Price < 0 then
          Price := -Price;
        // ----------------------------
        Amount := CurrToFloat(AmtStr);
        if (((oc = 'O') and (ls = 'L')) or ((oc = 'C') and (ls = 'S'))) then
          Commis := Amount - (Price * Shares * mult)
        else
          Commis := (Shares * Price * mult) - Amount;
        // ----------------------------
        ImpTrades[R].it := TradeLogFile.Count + R;
        ImpTrades[R].DT := ImpDate;
        ImpTrades[R].oc := oc;
        ImpTrades[R].ls := ls;
        ImpTrades[R].tk := tick;
        ImpTrades[R].sh := Shares;
        ImpTrades[R].pr := Price;
        ImpTrades[R].prf := prfStr;
        ImpTrades[R].cm := Commis;
        ImpTrades[R].am := Amount;
      except
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        dec(R);
        Continue;
      end;
    end; // while
    ImpStrList.Destroy;
    ReverseImpTradesDate(R);
    result := R;
  finally
    // ReadTRoweCSV
  end;
end;

// ENTRY POINT
function ReadTRowe(): integer;
var
  i, R : integer;
  NextDate, ImpDate, CmStr, PrStr, prfStr, AmtStr, ShStr, line, sep : string;
  Shares, Amount, Commis : double;
  contracts, ImpNextDateOn : boolean;
  oc, ls : string;
begin
  try
    R := 0;
    ImpStrList := TStringList.Create;
    ImpTrades := nil;
    setLength(ImpTrades, R + 1);
    GetImpDateLast;
    // ----------------------
    GetImpStrListFromFile('TRowe Price', 'csv', ''); // Import from CSV file
    result := ReadTRoweCSV(ImpStrList);
  finally
    // ReadTRowe
  end;
end;

         // -----------------
         // UNX
         // -----------------

function ReadUNX(): integer;
var
  i, R : integer;
  Shares, Commis, Princ : double;
  PrincStr, line, sep, ImpDate, TimeStr, ShStr, PrStr, CmStr, feeStr : string;
  contracts : boolean;
  oc, ls : string;
begin
  try
    DataConvErrRec := '';
    DataConvErrStr := '';
    R := 0;
    ImpStrList := TStringList.Create;
    ImpTrades := nil;
    setLength(ImpTrades, R + 1);
    GetImpDateLast;
    GetImpStrListFromFile('UNX', 'csv', '');
    sep := ',';
    if ImpStrList.Count < 1 then begin
      ImpStrList.Destroy;
      result := 0;
      exit;
    end;
    for i := 0 to ImpStrList.Count - 1 do begin
      contracts := false;
      inc(R);
      if R < 1 then
        R := 1;
      StatBar('Importing ' + IntToStr(i));
      line := ImpStrList[i];
      line := trim(line);
      // delete all quotes
      while pos('"', line) > 0 do begin
        delete(line, pos('"', line), 1);
      end;
      // delete acct id / assset id
      delete(line, 1, pos(sep, line));
      line := trim(line);
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // ticker
      tick := copy(line, 1, pos(sep, line) - 1);
      tick := trim(tick);
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // delete descr & cusip
      delete(line, 1, pos(sep, line));
      line := trim(line);
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // date
      ImpDate := copy(line, 1, pos(' ', line) - 1);
      ImpDate := trim(ImpDate);
      delete(line, 1, pos(' ', line));
      line := trim(line);
      // time
      TimeStr := copy(line, 1, pos(sep, line) - 1);
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // Open/Close - Long/Short
      oc := copy(line, 1, pos(sep, line) - 1);
      if pos('BUY', oc) > 0 then begin
        oc := 'O';
        ls := 'L';
      end
      else if pos('SELL', oc) > 0 then begin
        oc := 'C';
        ls := 'L';
      end
      else if pos('SHORT', oc) > 0 then begin
        oc := 'O';
        ls := 'S';
      end
      else if pos('COVER', oc) > 0 then begin
        oc := 'C';
        ls := 'S';
      end
      else begin
        dec(R);
        if (i = ImpStrList.Count - 1) and (R = 0) then
          sm('No Records Imported');
        Continue;
      end;
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // Shares
      ShStr := copy(line, 1, pos(sep, line) - 1);
      ShStr := delCommas(ShStr);
      // ShStr:= Del1000SepEx(ShStr,ImportFmt);
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // price
      PrStr := copy(line, 1, pos(sep, line) - 1);
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // princ amount
      PrincStr := copy(line, 1, pos(sep, line) - 1);
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // comm
      CmStr := copy(line, 1, pos(sep, line) - 1);
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // fees
      feeStr := copy(line, 1, pos(sep, line) - 1);
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // --------------------
      try
        Shares := StrToFloat(ShStr, Settings.InternalFmt);
        if Shares < 0 then
          Shares := -Shares;
        Price := StrToFloat(PrStr, Settings.InternalFmt);
        if Price < 0 then
          Price := -Price;
        Princ := StrToFloat(PrincStr, Settings.InternalFmt);
        if Princ < 0 then
          Princ := -Princ;
        if format('%1.2m', [Shares * Price * 100], Settings.UserFmt)
          = format('%1.2m', [Princ], Settings.UserFmt) then
          ImpTrades[R].prf := 'OPT-100'
        else
          ImpTrades[R].prf := 'STK-1';
        Commis := StrToFloat(CmStr, Settings.InternalFmt) +
          StrToFloat(feeStr, Settings.InternalFmt);
        ImpTrades[R].it := TradeLogFile.Count + R;
        ImpTrades[R].tr := 0;
        ImpTrades[R].DT := ImpDate;
        ImpTrades[R].tm := TimeStr;
        ImpTrades[R].oc := oc;
        ImpTrades[R].ls := ls;
        ImpTrades[R].tk := tick;
        ImpTrades[R].sh := Shares;
        ImpTrades[R].pr := Price;
        ImpTrades[R].cm := Commis;
        ImpTrades[R].am := 0;
      except
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        dec(R);
        Continue;
      end;
    end;
    ImpStrList.Destroy;
    result := R;
  finally
    // ReadUNX
  end;
end;

         // -----------------
         // Vanguard
         // -----------------

function ReadVanguard(): integer;
var
  i, j, R : integer;
  Shares, Commis, Princ, Amount, mult : double;
  NextDate, PrincStr, line, sep, ImpDate, descr, ShStr, PrStr, prfStr, CmStr, AmtStr, junk, skkTk,
    exMo, exDa, exYr, strike, callPut, opTick, dateSep : string;
  contracts, expires, divReinv, lastYrTrades, impLastYrTrades, ImpNextDateOn, correct, corrections,
    isMutualFundAcct : boolean;
  oc, ls : string;
begin
  try
    DataConvErrRec := '';
    DataConvErrStr := '';
    R := 0;
    expires := false;
    lastYrTrades := false;
    impLastYrTrades := false;
    corrections := false;
    isMutualFundAcct := false;
    ImpStrList := TStringList.Create;
    ImpTrades := nil;
    setLength(ImpTrades, R + 1);
    GetImpDateLast;
    GetImpStrListFromFile('Vanguard', 'csv', '');
    sep := ',';
    if ImpStrList.Count < 1 then begin
      ImpStrList.Destroy;
      result := 0;
      exit;
    end;
    for i := 0 to ImpStrList.Count - 1 do begin
      junk := '';
      contracts := false;
      divReinv := false;
      correct := false;
      inc(R);
      if R < 1 then
        R := 1;
      StatBar('Importing ' + IntToStr(i));
      line := ImpStrList[i];
      line := trim(line);
      if rightStr(line, 1) <> ',' then
        line := line + ',';
      // delete all quotes
      while pos('"', line) > 0 do begin
        delete(line, pos('"', line), 1);
      end;
      // Account Number,Trade Date,Settlement Date,Transaction Type,Transaction Description,Investment Name,Symbol,Shares,Share Price,
      // Principal Amount,Commission Fees,Net Amount,Accrued Interest,Account Type,
      if pos('Account Number, Trade Date, Process Date, Transaction Type, Transaction Description, Investment Name, Share Price, Shares, Gross Amount, Net Amount,',
        line) > 0 then
        isMutualFundAcct := true;
      sep := ',';
      // delete acct #
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // date
      ImpDate := copy(line, 1, pos(sep, line) - 1);
      if pos('-', ImpDate) = 5 then begin
        junk := parsefirst(ImpDate, '-');
        ImpDate := replacestr(ImpDate, '-', '/') + '/' + junk;
      end;
      if pos('/', ImpDate) = 2 then begin // 2020-06-04 MB - handle single-digit months
        ImpDate := '0' + ImpDate;
      end;
      if pos('/', ImpDate) <> 3 then begin
        dec(R);
        Continue;
      end;
      // --------------------
      // do not import last years trades
      dtBegTaxYr := xStrToDate('01/01/' + TaxYear, Settings.InternalFmt);
      if not impLastYrTrades //
        and (xStrToDate(ImpDate, Settings.InternalFmt) < dtBegTaxYr) then begin
        if not lastYrTrades then
          if mDlg('Some trades in this CSV file are from last year' + cr //
              + cr + 'Do you wish to import these?', mtWarning, [mbNo, mbYes], 0) = mrYes then
            impLastYrTrades := true;
        lastYrTrades := true;
        dec(R);
        Continue;
      end;
      // --------------------
      // do not import duplicate trades
      if UserDateStrNotGreater(ImpDate, ImpDateLast) then begin
        if ImpNextDateOn then begin
          dec(R);
          Continue;
        end;
        NextDate := NextUserDateStr(ImpDateLast);
        if mDlg('Trades already imported up to ' + ImpDateLast + cr + cr +
            'Do you wish to import from ' + NextDate + ' onward?' + cr + cr +
            'Click YES to skip all trades prior to ' + NextDate + cr + cr +
            'Click NO to import all of the dates on this page', mtWarning,[mbNo, mbYes], 0) = mrNo
        then begin
          ImpDateLast := '01/01/1900';
        end
        else begin
          ImpNextDateOn := true;
          dec(R);
          Continue;
        end;
      end;
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // delete settle date
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // --------------------
      // Open/Close - Long/Short
      oc := copy(line, 1, pos(sep, line) - 1);
      if (pos('Cancel', oc) > 0) or (pos('MONEY MARKET', line) > 0) then begin
        dec(R);
        Continue;
      end
      else if (pos('Sell Correction', oc) > 0) then begin
        oc := 'C';
        ls := 'L';
        correct := true;
        corrections := true;
      end
      else if (pos('Buy Correction', oc) > 0) then begin
        oc := 'O';
        ls := 'L';
        correct := true;
        corrections := true;
      end
      else if (pos('Sell to open', oc) > 0) then begin
        oc := 'O';
        ls := 'S';
      end
      else if (pos('Buy to close', oc) > 0) then begin
        oc := 'C';
        ls := 'S';
      end
      else if (pos('Buy', oc) > 0) or (pos('Distribution', oc) > 0) then begin
        oc := 'O';
        ls := 'L';
      end
      else if pos('Sell', oc) > 0 then begin
        oc := 'C';
        ls := 'L';
      end
      else if (pos('Other', oc) > 0) and (pos('FRACTIONAL SHARES', line) > 0) then begin
        if pos('LIQUIDATION', line) > 0 then begin // 2010-07-12
          oc := 'C';
          ls := 'L';
        end
        else begin
          oc := 'O';
          ls := 'L';
        end;
      end
      else if ((pos('Dividend', oc) > 0) and (pos('REINVEST', line) > 0)) or
        ((pos('Reinvestment', oc) > 0) { and (pos('Dividend Reinvestment', line) > 0) } ) or
        (pos('Reinvested dividend', line) > 0) then begin
        oc := 'O';
        ls := 'L';
        divReinv := true;
      end
      else if (pos('Other', oc) > 0) and (pos('OPTION EXPIRED', line) > 0) then begin
        oc := 'E';
        ls := 'L';
        expires := true;
      end
      else begin
        dec(R);
        if (i = ImpStrList.Count - 1) and (R = 0) then
          sm('No Records Imported');
        Continue;
      end;
      delete(line, 1, pos(sep, line));
      // --------------------
      line := trim(line);
      // delete descr  & name
      if not isMutualFundAcct then begin
        junk := copy(line, 1, pos(sep, line) - 1);
        delete(line, 1, pos(sep, line));
        line := trim(line);
      end;
      // --------------------
      descr := copy(line, 1, pos(sep, line) - 1);
      if (pos('CALL ', descr) = 1) //
      or (pos('PUT ', descr) = 1) then
        contracts := true;
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // ticker
      tick := copy(line, 1, pos(sep, line) - 1);
      tick := trim(tick);
      if length(tick) < 1 then
        tick := descr;
      if length(tick) < 1 then
        Continue; // no ticker!
      // --------------------
      if contracts then begin
        // old option ticker symbol "SZC-CY"
        if (pos('-', tick) > 0) then begin
          // use descr - "CALL    100 STANDARDAND POORS           EXP 06-20-09 @ 88   OPENING TRANSACTION"
          opTick := tick;
          if pos('OPENING TRANSACTION', descr) > 0 then
            descr := copy(descr, 1, pos('OPENING TRANSACTION', descr) - 1);
          if pos('CLOSING TRANSACTION', descr) > 0 then
            descr := copy(descr, 1, pos('CLOSING TRANSACTION', descr) - 1);
          descr := trim(descr);
          // delete all chars at right that are not an integer
          if not isInt(rightStr(descr, 1)) then begin
            while not isInt(rightStr(descr, 1)) do begin
              delete(descr, length(descr), 1);
            end;
          end;
          if pos('@', descr) > 0 then begin
            strike := ParseLastN(descr, '@');
            strike := trim(strike);
            descr := trim(descr);
            strike := delTrailingZeros(strike);
          end;
          if pos('-', descr) > 0 then begin
            dateSep := '-';
          end
          else if pos('/', descr) > 0 then begin
            dateSep := '/';
          end;
          exYr := parseLast(descr, dateSep);
          exDa := parseLast(descr, dateSep);
          exMo := parseLast(descr, ' ');
          exMo := getExpMo(exMo);
          junk := ParseLastN(descr, 'EXP');
          descr := trim(descr);
          // CALL BANK AMER CORP     $15         EXP 07/18/09 - no @ sign
          if pos('$', descr) > 0 then begin
            strike := ParseLastN(descr, '$');
            strike := trim(strike);
            descr := trim(descr);
            strike := delTrailingZeros(strike);
          end;
          callPut := parsefirst(descr, ' ');
          descr := trim(descr);
          // delete number of shares if present
          if isInt(copy(descr, 1, 1)) then
            delete(descr, 1, pos(' ', descr));
          descr := copy(descr, 1, 20);
          tick := descr + ' ' + exDa + exMo + exYr + ' ' + strike + ' ' + callPut;
        end
        else
        // 2016-10-04 std OPRA option format (ie: BLCM150619C00025000 )
          if (pos(' ', tick) = 0) then begin
            tick := reformatOptionSymbol(tick, '');
          end
          else if (pos(' EXP', tick) > 0) then begin
            // CALL VERIZON COMMNS INC $35.50 EXP 07/28/23
            //     ^                  ^^     ^^^^^
            opTick := tick;
            callPut := parsefirst(tick, ' ');
            // --- expiration date ----
            junk := parseLast(tick, ' '); // 1st try
            if pos('/', junk) < 1 then begin
              junk := parseLast(tick, ' '); // 2nd try
              if pos('/', junk) < 1 then begin
                junk := parseLast(tick, ' '); // 3rd try
                if pos('/', junk) < 1 then begin
                  junk := parseLast(tick, ' '); // 4th & last
                end;
              end;
            end;
            if isdate(junk) = false then begin
              Continue;
            end;
            exYr := parseLast(junk, '/');
            exMo := parsefirst(junk, '/');
            exMo := getExpMo(exMo);
            exDa := junk;
            // --- strike price -------
            strike := parseLast(tick, ' '); // EXP
            strike := parseLast(tick, '$'); // $###
            strike := delTrailingZeros(strike);
            tick := trim(tick) + ' ' + exDa + exMo + exYr + ' ' + strike + ' ' + callPut;
          end
          else begin
          // new option symbol  "JPM 100918 C 39.00"
            opTick := tick;
            // --- strike price -------
            strike := parseLast(tick, ' ');
            strike := delTrailingZeros(strike);
            callPut := parseLast(tick, ' ');
            if callPut = 'C' then
              callPut := 'CALL'
            else if callPut = 'P' then
              callPut := 'PUT';
            // --- expiration date ----
            junk := parseLast(tick, ' ');
            exYr := leftStr(junk, 2);
            exDa := rightStr(junk, 2);
            exMo := copy(junk, 3, 2);
            exMo := getExpMo(exMo);
            tick := tick + ' ' + exDa + exMo + exYr + ' ' + strike + ' ' + callPut;
          end;
      end;
      if tick = '' then
        tick := descr;
      delete(line, 1, pos(sep, line));
      line := trim(line);
      if isMutualFundAcct then begin
        // price
        PrStr := copy(line, 1, pos(sep, line) - 1);
        delete(line, 1, pos(sep, line));
        line := trim(line);
        // Shares
        ShStr := copy(line, 1, pos(sep, line) - 1);
        ShStr := delCommas(ShStr);
        delete(line, 1, pos(sep, line));
        line := trim(line);
      end
      else begin
        // Shares
        ShStr := copy(line, 1, pos(sep, line) - 1);
        ShStr := delCommas(ShStr);
        delete(line, 1, pos(sep, line));
        line := trim(line);
        // price
        PrStr := copy(line, 1, pos(sep, line) - 1);
        delete(line, 1, pos(sep, line));
        line := trim(line);
      end;
      // --------------------
      // princ amount
      PrincStr := copy(line, 1, pos(sep, line) - 1);
      delete(line, 1, pos(sep, line));
      line := trim(line);
      if not isMutualFundAcct then begin
        // comm
        CmStr := copy(line, 1, pos(sep, line) - 1);
        delete(line, 1, pos(sep, line));
        line := trim(line);
      end
      else
        CmStr := '0.00';
      // amount
      AmtStr := copy(line, 1, pos(sep, line) - 1);
      delete(line, 1, pos(sep, line));
      // --------------------
      line := trim(line);
      if pos('SHORT', line) > 0 then begin
        if oc = 'O' then begin
          oc := 'C';
          ls := 'S';
        end
        else if oc = 'C' then begin
          oc := 'O';
          ls := 'S';
        end;
      end;
      // --------------------
      try
        Shares := StrToFloat(ShStr, Settings.InternalFmt);
        if Shares < 0 then begin
          // if OC='O' then OC:= 'C';
          Shares := -Shares;
        end;
        Price := StrToFloat(PrStr, Settings.InternalFmt);
        if Price < 0 then
          Price := -Price;
        Princ := StrToFloat(PrincStr, Settings.InternalFmt);
        if Princ < 0 then
          Princ := -Princ;
        Amount := StrToFloat(AmtStr, Settings.InternalFmt);
        if Amount < 0 then
          Amount := -Amount;
        if divReinv then begin
          Price := rndto5(Amount / Shares);
          if Price < 0 then
            Price := -Price;
        end;
        if contracts then begin
          prfStr := 'OPT-100';
          mult := 100;
        end
        else begin
          prfStr := 'STK-1';
          mult := 1;
        end;
        // fees not included in commission
        if ((oc = 'C') and (ls = 'L')) // a sale
          or ((oc = 'O') and (ls = 'S')) then
          Commis := (Shares * Price * mult) - Amount
        else if ((oc = 'O') and (ls = 'L')) // a buy
          or ((oc = 'C') and (ls = 'S')) then
          Commis := Amount - (Shares * Price * mult);
        // ------------------
        ImpTrades[R].it := TradeLogFile.Count + R;
        ImpTrades[R].tr := 0;
        ImpTrades[R].DT := ImpDate;
        ImpTrades[R].tm := '';
        ImpTrades[R].oc := oc;
        ImpTrades[R].ls := ls;
        ImpTrades[R].tk := tick;
        ImpTrades[R].sh := Shares;
        ImpTrades[R].pr := Price;
        ImpTrades[R].prf := prfStr;
        ImpTrades[R].cm := Commis;
        ImpTrades[R].am := 0;
        ImpTrades[R].opTk := opTick;
        if correct then
          ImpTrades[R].no := 'Correction';
      except
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        dec(R);
        Continue;
      end;
    end;
    // ----------------------
    if corrections then begin
      for i := 1 to R do begin
        for j := R downto 1 do begin
          if (ImpTrades[i].no = 'Correction') and (ImpTrades[i].DT = ImpTrades[j].DT) and
            (ImpTrades[i].tk = ImpTrades[j].tk) and
            (format('%1.5f', [ImpTrades[i].sh], Settings.UserFmt) = format('%1.5f',
              [ImpTrades[j].sh], Settings.UserFmt)) and
            (format('%1.5f', [ImpTrades[i].pr], Settings.UserFmt) = format('%1.5f',
              [ImpTrades[j].pr], Settings.UserFmt)) and (ImpTrades[i].prf = ImpTrades[j].prf) and
            (ImpTrades[j].oc <> '') and (ImpTrades[j].no <> 'Correction') and (i <> j) then begin
            ImpTrades[i].no := '';
            ImpTrades[j].oc := '';
            ImpTrades[j].ls := '';
            ImpTrades[j].tm := '';
            ImpTrades[j].no := '';
            break;
          end;
        end;
      end;
      // --------------------
      for i := 1 to R do begin
        ImpTrades[i].tm := '';
        if ImpTrades[i].no = 'Correction' then begin
          sm('CORRECTION TRADES NOT MATCHED!' + cr + cr + 'See the notes column for corrections');
          break;
        end;
      end;
    end;
    // ----------------------
    if expires then begin
      for i := 1 to R do begin
        StatBar('Expiring Options: ' + IntToStr(i));
        if ImpTrades[i].oc = 'E' then begin
          for j := i downto 1 do begin
            if (ImpTrades[j].tk = ImpTrades[i].tk) then begin
              ImpTrades[i].oc := 'C';
              ImpTrades[i].ls := ImpTrades[j].ls;
              break;
            end;
          end;
        end;
      end;
    end;
    // ----------------------
    if R > 1 then
      ReverseImpTradesDate(R);
    SortImpByDateOC(1, R);
    ImpStrList.Destroy;
    result := R;
  finally
    // ReadVanguard
  end;
end;

         // -----------------
         // OpenECry
         // -----------------

function ReadOpenECry(): integer;
var
  i, R : integer;
  tkStr, MoStr, YrStr, NextDate, ImpDate, CommStr, PrStr, prfStr, AmtStr, ShStr, line, sep, my32,
    opTick, callPut : string;
  Shares, Amount, Commis, mult : double;
  contracts, ImpNextDateOn : boolean;
  oc, ls : string;
begin
  try
    DataConvErrRec := '';
    DataConvErrStr := '';
    Amount := 0;
    Commis := 0;
    R := 0;
    Shares := 0;
    ImpNextDateOn := false;
    ImpStrList := TStringList.Create;
    ImpTrades := nil;
    setLength(ImpTrades, R + 1);
    GetImpDateLast;
    GetImpStrListFromClip(false);
    if ImpStrList.Count < 1 then begin
      ImpStrList.Destroy;
      result := 0;
      exit;
    end;
    for i := 0 to ImpStrList.Count - 1 do begin
      contracts := false;
      inc(R);
      if R < 1 then
        R := 1;
      line := trim(ImpStrList[i]);
      if pos(TAB, line) > 0 then
        sep := TAB
      else
        sep := ' ';
      // date
      ImpDate := copy(line, 1, pos(sep, line) - 1);
      if (pos('/', ImpDate) <> 3) then begin
        dec(R);
        if (i = ImpStrList.Count - 1) and (R = 0) then begin
          if ImpNextDateOn then begin
            sm('No transactions later than ' + ImpDateLast);
          end
          else begin
            sm('Options Express Import Error' + cr + cr + 'No data copied' + cr + cr +
                'Please reselect entire report');
          end;
          result := 0;
          exit;
        end;
        Continue;
      end;
      ImpDate := LongDateStr(ImpDate);
      if not ValidTradeDate(ImpDate, ImpDateLast, ImpNextDateOn) then begin
        dec(R);
        Continue;
      end;
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // OC
      oc := copy(line, 1, pos(sep, line) - 1);
      if pos('Buy', oc) > 0 then begin
        oc := 'O';
      end
      else if (pos('Sell', oc) > 0) then begin
        oc := 'C';
      end
      else begin
        dec(R);
        Continue;
      end;
      line := trim(line);
      delete(line, 1, pos(sep, line));
      // long short
      ls := copy(line, 1, pos(sep, line) - 1);
      ls := 'L';
      if (ls = 'S') then begin
        if (oc = 'O') then
          oc := 'C'
        else if (oc = 'C') then
          oc := 'O';
      end;
      line := trim(line);
      delete(line, 1, pos(sep, line));
      // ticker
      tick := copy(line, 1, pos(sep, line) - 1);
      if pos('(', tick) > 0 then
        tick := copy(tick, 1, pos('(', tick) - 1);
      // check for options
      if pos(' ', tick) > 3 then begin
        contracts := true;
        opTick := parseLast(tick, ' ');
        if pos('C', opTick) = 1 then
          callPut := 'CALL'
        else if pos('P', opTick) = 1 then
          callPut := 'PUT'
        else
          contracts := false;
        if contracts then begin
          delete(tick, 1, 1);
          delete(opTick, 1, 1);
          opTick := ' ' + opTick + ' ' + callPut;
        end
        else
          opTick := '';
        // remove "O" from the ticker
        if (pos('O', tick) = 1) then
          delete(tick, 1, 1);
        // remove "-" from ticker
        if (pos('-', tick) > 0) then
          delete(tick, pos('-', tick), 1);
      end;
      tkStr := copy(tick, 1, length(tick) - 2);
      MoStr := copy(tick, length(tick) - 1, 1);
      MoStr := getFutCodeExpMo(MoStr);
      if copy(tick, length(tick), 1) > '7' then
        YrStr := '0' + copy(tick, length(tick), 1)
      else
        YrStr := '1' + copy(tick, length(tick), 1);
      tick := tkStr + ' ' + MoStr + YrStr;
      // added for options
      if contracts then
        tick := tick + opTick;
      prfStr := futuresMult(tick, '', TradeLogFile.CurrentBrokerID);
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // shares
      ShStr := copy(line, 1, pos(sep, line) - 1);
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // price
      PrStr := copy(line, 1, pos(sep, line) - 1);
      // T-Bonds - price is in 32's options are in 64's
      if pos(' ', PrStr) > 0 then begin
        my32 := parseLast(PrStr, ' ');
        // sm(my32);
        try
          if contracts and (pos('ZB', tick) = 1) then
            PrStr := floattostr((StrToFloat(PrStr, Settings.InternalFmt) + StrToFloat(my32,
                  Settings.InternalFmt) / 64), Settings.InternalFmt)
          else
            PrStr := floattostr((StrToFloat(PrStr, Settings.InternalFmt) + StrToFloat(my32,
                  Settings.InternalFmt) / 32), Settings.InternalFmt);
        except
          sm('error converting T-Bond price:' + cr + ImpStrList[i]);
        end;
        // sm(prStr);
      end;
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // comm
      CommStr := copy(line, 1, pos(sep, line) - 1);
      delete(line, 1, pos(sep, line));
      line := trim(line);
      // amount
      AmtStr := trim(line);
      // --------------------
      try
        Shares := StrToFloat(ShStr, Settings.InternalFmt);
        Price := StrToFloat(PrStr, Settings.InternalFmt);
        if CommStr = '' then
          Commis := 0
        else
          Commis := StrToFloat(CommStr, Settings.InternalFmt);
        Amount := 0;
      except
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        dec(R);
        Continue;
      end;
      ImpTrades[R].it := TradeLogFile.Count + R;
      ImpTrades[R].DT := ImpDate;
      ImpTrades[R].oc := oc;
      ImpTrades[R].ls := ls;
      ImpTrades[R].tk := tick;
      ImpTrades[R].sh := Shares;
      ImpTrades[R].pr := Price;
      ImpTrades[R].prf := prfStr;
      ImpTrades[R].cm := Commis;
      ImpTrades[R].am := Amount;
    end;
    result := R;
    ImpStrList.Destroy;
  finally
    // ReadOpenECry
  end;
end;


         // -----------------
         // Vision
         // -----------------

function ReadVisionCSV(ImpStrList : TStringList; iFileFmt : integer): integer;
var
  i, j, k, start, eend, R, Q, n, iDataVer, iCUSIP, //
    iDt, iTyp, iOC, iLS, iTk, iDesc, iShr, iPr, iAmt, iCm, iFee : integer; // import field numbers
  junk, sep, ImpDate, CmStr, feeStr, PrStr, AmtStr, ShStr, line, MulStr,
    // tick, // for some reason, tick is a unit variable
  optDesc, optOC, opYr, opMon, opDay, opStrike, opCP, oc, ls, dd, mm, yyyy, errMsg : string;
  Amount, Commis, Fees, Shares, mult, Amt2 : double;
  contracts, Adj, optExpEx, ImpNextDateOn, bonds, newColFormat, miniOptions, bFoundHeader, cancels,
    bSkipAmtErr : boolean;
  fieldLst : TStrings;
  // --------------------------------------------
  // CSV FIELDS
  // --------------------------------------------
  // FLD  #  HEADING            Example
  // --------------------------------------------
  // LS   1  ACCOUNT_TYPE       MARGIN
  // OC   2  ACTION             Sale
  // 3  ACTIVITY_CODE
  // AMT  4  AMOUNT             15946.96
  // 5  AS_OF_DATE
  // 6  CHECK_NUMBER
  // COM  7  COMMISSION             6
  // 8  COMMISSION_IN_GROSS    N
  // 9  CONTRA_BROKER
  // *** 10  CUSIP              G63637105
  // 11  CUSTOMER           62003264
  // DES 12  DESCRIPTION        NABRIVA THERAPEUTICS PLC SHS
  // 13  EFFECTIVE_DATE     Thu
  // 14  EXCHANGE_RATE      1
  // COM 15  FEES               7.04
  // 16  FROM_LOCATION
  // 17  FRONT_EXEC         POIN
  // 18  HELD_CURRENCY_CODE USD
  // 19  INTEREST           0
  // 20  MATURITY_DATE
  // 21  MISC_FEE           0
  // 22  NFA_FEE            0
  // TR  23  ORDER_NUMBER       N1419F99
  // 24  OUTPUT_CURRENCY_CODE   USD
  // 25  PAYEE
  // PR  26  PRICE              6.65
  // 27  PRINCIPAL          -15960
  // SH  28  QUANTITY           -2400
  // 29  SALES_CREDIT       0
  // 30  SEC_FEE            0
  // 31  SECURITY_CLASS_CODE
  // PRF 32  SECURITY_TYPE      EQUITY
  // 33  STATE_TAX          0
  // TK  34  SYMBOL             EQUITY NBRV
  // 35  TAX_EXEMPT_STATUS  N/A
  // 36  TAXES              0
  // 37  TO_LOCATION
  // DT  38  TRANSACTION_DATE   Tue, 28 Nov 2017 12:00:00 am EST
  // 39  USER_DEFINED_ACTION
  // --------------------------------------------
  procedure SetCSVFields();
  var
    j : integer;
  begin
    // find/map Vision Financial CSV fields
    k := 0;
    for j := 0 to (fieldLst.Count - 1) do begin
      if (fieldLst[j] = 'ACCOUNT_TYPE') // for 'SHORT'
        or (fieldLst[j] = 'ACCOUNT TYPE') //
      then begin
        iLS := j;
        k := k or 1;
      end
      else if (fieldLst[j] = 'ACTION') // for 'SALE/PURCHASE' or 'SOLD/BOT'
        or (fieldLst[j] = 'TRANSACTION') //
      then begin
        iOC := j;
        k := k or 2;
      end
      else if (fieldLst[j] = 'AMOUNT') // for
        or (pos('NET AMOUNT', fieldLst[j]) = 1) //
      then begin
        iAmt := j;
        k := k or 4;
      end
      else if (pos('COMMISSION', fieldLst[j]) = 1) //
      then begin
        iCm := j;
        k := k or 8;
      end
      else if (pos('FEES', fieldLst[j]) = 1) //
      then begin
        iFee := j;
        k := k or 1024;
      end
      else if (fieldLst[j] = 'DESCRIPTION') //
      then begin
        iDesc := j;
        k := k or 16;
      end
      else if (pos('PRICE', fieldLst[j]) = 1) //
      then begin
        iPr := j;
        k := k or 32;
      end
      else if (fieldLst[j] = 'QUANTITY') //
      then begin
        iShr := j;
        k := k or 64;
      end
      else if (fieldLst[j] = 'SYMBOL') // 2017
        or (fieldLst[j] = 'SECURITY') // 2019
      then begin
        iTk := j;
        k := k or 128;
      end
      else if (fieldLst[j] = 'TRANSACTION_DATE') //
      then begin
        iDt := j;
        k := k or 256;
        iDataVer := 2017;
      end
      else if (fieldLst[j] = 'TRADE DATE') //
      then begin
        iDt := j;
        k := k or 256;
        iDataVer := 2019;
      end
      else if (fieldLst[j] = 'SECURITY_TYPE') // 2017
        or (fieldLst[j] = 'SECURITY TYPE') // 2019
      then begin
        iTyp := j;
        k := k or 512;
      end
      else if (fieldLst[j] = 'CUSIP') //
      then begin
        iCUSIP := j;
        k := k or 2048;
      end;
    end;
  end;
  // --------------------------------------------
  // XLSX FIELDS (4/4/2022)
  // --------------------------------------------
  // FLD  #  HEADING            Example
  // --------------------------------------------
  // 1	 ENTRY DATE	        1/7/2021
  // DT	 2	 TRADE DATE	        1/7/2021
  // 3	 TRADE NUMBER       NA05A
  // OC	 4	 TRANSACTION        Buy (or Sell)
  // 5	 ACCOUNTNUMBER      62002134
  // 6	 ACCOUNTNAME     	  MARK OLEN MCINTOSH
  // 7	 ACCTNATURE	        INDIVIDUAL
  // *** 8	 CUSIP   	          88337K302
  // TK	 9	 SECURITY           NCTY
  // DES 10	 DESCRIPTION     	  THE9 LTD SPON ADS NEW
  // PRF 11  SECURITY TYPE      Equity
  // SH	 12	 QUANTITY	          300
  // 13	 BASE CURRENCY      USD
  // PR  14	 PRICE ($)          18.6003
  // COM 15	 COMMISSIONS ($)	  -1.2
  // FEE 16	 FEES($)            -0.68
  // AMT 17	 NET AMOUNT ($)     -5,701.88
  // 18	 SETTLEMENT DATE    1/11/2021
  // LS	 19	 ACCOUNT TYPE       SHORT
  // 20	 INTEREST ($)	      0
  // 21	 MISC FEE	          0
  // --------------------------------------------
  procedure SetXLSFields();
  var
    j : integer;
  begin
    // find/map Vision Financial XLSx fields
    k := 0;
    for j := 0 to (fieldLst.Count - 1) do begin
      if (fieldLst[j] = 'ACCOUNT TYPE') // for 'SHORT'
      then begin
        iLS := j;
        k := k or 1;
      end
      else if (fieldLst[j] = 'TRANSACTION') //
      then begin
        iOC := j;
        k := k or 2;
      end
      else if (pos('NET AMOUNT', fieldLst[j]) = 1) //
      then begin
        iAmt := j;
        k := k or 4;
      end
      else if (pos('COMMISSION', fieldLst[j]) = 1) //
      then begin
        iCm := j;
        k := k or 8;
      end
      else if (pos('FEES', fieldLst[j]) = 1) //
      then begin
        iFee := j;
        k := k or 1024;
      end
      else if (fieldLst[j] = 'DESCRIPTION') //
      then begin
        iDesc := j;
        k := k or 16;
      end
      else if (pos('PRICE', fieldLst[j]) = 1) //
      then begin
        iPr := j;
        k := k or 32;
      end
      else if (fieldLst[j] = 'QUANTITY') //
      then begin
        iShr := j;
        k := k or 64;
      end
      else if (fieldLst[j] = 'SECURITY') //
      then begin
        iTk := j;
        k := k or 128;
      end
      else if (fieldLst[j] = 'TRADE DATE') //
      then begin
        iDt := j;
        k := k or 256;
        iDataVer := 2019;
      end
      else if (fieldLst[j] = 'SECURITY TYPE') //
      then begin
        iTyp := j;
        k := k or 512;
      end
      else if (fieldLst[j] = 'CUSIP') //
      then begin
        iCUSIP := j;
        k := k or 2048;
      end;
    end;
  end;
  // ----------------------------------
  function IsNum(s : string) : boolean;
  begin
    if pos('.', s) > 0 then
      delete(s, pos('.', s), 1);
    result := IsNumber(s);
  end;

// ----------------------------------
begin // ReadVisionCSV
  bFoundHeader := false; // let's us know we haven't found the header yet
  bSkipAmtErr := false; // 2021-06-21 MB
  iDt := 0;
  iTyp := 0;
  iOC := 0;
  iLS := 0;
  iTk := 0;
  iDesc := 0;
  iShr := 0;
  iPr := 0;
  iAmt := 0;
  iCm := 0;
  cancels := false;
  R := 0;
  try
    tick := 'ERROR';
    DataConvErrRec := '';
    DataConvErrStr := '';
    Adj := false;
    ImpNextDateOn := false;
    newColFormat := false;
    if ImpStrList.Count < 1 then begin
      ImpStrList.Destroy;
      result := 0;
      exit;
    end;
    fieldLst := TStrings.Create;
    // --------------------------------
    i := -1;
    while i < (ImpStrList.Count - 1) do begin
      inc(i); // make it work like a for/next
      contracts := false;
      miniOptions := false;
      optExpEx := false;
      bonds := false;
      mult := 1; // default
      // ------------------------------
      line := ImpStrList[i];
      line := uppercase(line);
      // parse all columns into string list
      if iFileFmt = 1 then
        fieldLst := ParseCSV(line)
      else // if iFileFmt = 2 then
        fieldLst := ParseCSV(line, TAB);
      if (fieldLst.Count < iDt) then
        Continue; // bad record
      if not bFoundHeader then begin
        if (pos('ACCOUNT TYPE', line) > 0) then begin
          if iFileFmt = 1 then
            SetCSVFields
          else // if iFileFmt = 2 then
            SetXLSFields;
          if SuperUser and (k <> 4095) then
            sm('there appear to be fields missing.');
          bFoundHeader := true; // don't do this anymore
          R := 0; // start now
        end;
        Continue; // don't process anything until we recognize the header
      end;
      // ------------------------------
      if pos('too many transactions', line) > 0 then begin
        sm('The date range you have selected contains too many transactions.' + cr //
            + 'A maximum of 1500 transactions can be obtained at once.' + cr //
            + 'Please reduce the date range for your Schwab report and try again.');
        result := 0;
        exit;
      end;
      sep := ',';
      // --- Date ---
      ImpDate := fieldLst[iDt]; // format: ddd, dd mmm yyyy hh:mm:ss ampm timezone
      if (length(ImpDate)= 10) and (pos('-', ImpDate)= 5) then begin
        junk := parsefirst(ImpDate, '-');
        ImpDate := trim(ImpDate + '/' + junk);
        junk := parsefirst(ImpDate, '-');
        ImpDate := trim(junk + '/' + ImpDate);
      end
      else if length(ImpDate) > 10 then begin
        junk := parsefirst(ImpDate, ' '); // remove leading ddd
        delete(ImpDate, 12, length(ImpDate)- 11); // remove trailing time,
        // which is always 12:00 am by the way.
        // ImpDate now in dd mmm yyyy format
        dd := parsefirst(ImpDate, ' ');
        if length(dd) = 1 then
          dd := '0' + dd;
        yyyy := parseLast(ImpDate, ' ');
        mm := MMMtoMM(uppercase(ImpDate));
        if length(yyyy) = 2 then
          ImpDate := mm + '/' + dd + '/20' + yyyy
        else
          ImpDate := mm + '/' + dd + '/' + yyyy;
      end;
      if isdate(ImpDate) = false then
        Continue;
      if not ValidTradeDate(ImpDate, ImpDateLast, ImpNextDateOn) then begin
        Continue;
      end;
      inc(R); // if it gets this far, count it
      // --- long/short, open/close ---
      junk := uppercase(trim(fieldLst[iOC]));
      if (pos('SHORT', uppercase(trim(fieldLst[iLS]))) = 1) //
      then begin
        ls := 'S'; // definitely
        if (junk = 'SOLD') // 2019
          or (junk = 'SALE') // 2017
          or (junk = 'SELL') // 2021
        then
          oc := 'O' // open short
        else if (junk = 'BOT') // 2019
          or (junk = 'PURCHASE') // 2017
          or (junk = 'BUY') // 2021
        then
          oc := 'C' // close short
        else if (pos(' CANCELLATION', junk) > 0) //
        then begin
          cancels := true;
          oc := 'X';
        end
        else begin
          oc := 'E'; // error
          if SuperUser then begin
            sm('Cannot determine if this short trade is open or close:' + cr //
                + line);
            Continue; // skip the record if we can't tell which
          end;
        end;
      end
      else begin // typicall MARGIN
        // --- purchase/sale --> open/close ---
        if (junk = 'PURCHASE TO OPEN') //
        then begin
          oc := 'O';
          ls := 'L';
        end
        else if (junk = 'PURCHASE TO CLOSE') //
        then begin
          oc := 'C';
          ls := 'S';
        end
        else if (junk = 'BOT') // 2019
          or (junk = 'PURCHASE') // 2017
          or (junk = 'BUY') // 2021
        then begin
          oc := 'O';
          ls := 'L';
        end
        else if (junk = 'SALE TO CLOSE') //
        then begin
          ls := 'L';
          oc := 'C';
        end
        else if (junk = 'SALE TO OPEN') //
        then begin
          ls := 'S';
          oc := 'O';
        end
        else if (junk = 'SHORT SALE') //
        then begin
          ls := 'S';
          oc := 'O';
        end
        else if (junk = 'SOLD') // 2019
          or (junk = 'SALE') // 2017
          or (junk = 'SELL') // 2021
        then begin
          oc := 'C';
          ls := 'L';
        end
        else if (pos(' CANCELLATION', junk) > 0) //
        then begin
          cancels := true;
          oc := 'X';
          ls := 'L';
        end
        else begin
          if SuperUser then begin
            sm('Cannot determine if this trade is open or close:' + cr //
                + line);
            Continue; // skip the record if we can't tell which
          end;
        end; // else unknown OC
      end; // else MARGIN
      // --- # shares ---
      ShStr := fieldLst[iShr];
      ShStr := delCommas(ShStr);
      // --- ticker ---
      junk := trim(fieldLst[iTk]); // ticker/symbol
      if junk = '' then
        junk := trim(fieldLst[iCUSIP]); // try CUSIP
      if junk = '' then
        junk := trim(fieldLst[iDesc]); // settle for Description
      if (iDataVer = 2019) then
        tick := junk
      else
        tick := parseLast(junk, ' '); // remove EQUITY or OPTION
      // --- type
      // is it an option?
      if (pos('OPTION', uppercase(fieldLst[iTyp])) = 1) then begin
        contracts := true;
        mult := 100;
      end
      else begin
        contracts := false;
        mult := 1;
        optDesc := ''; // NOT an option contract
      end;
      // --- options
      // parse tick:
      // OPTION CGC101918C60 = TTTmmddyyC$$
      // OPTION NBEV111618C7 = TTTTmmddyyC$
      if contracts then begin
        optDesc := tick;
        tick := '';
        j := 1;
        n := length(optDesc);
        while j < n do begin
          if pos(optDesc[j], '1234567890') > 0 then
            break;
          tick := tick + optDesc[j];
          j := j + 1;
        end;
        // --- Expiration Date ---
        if (n - j) > 2 then begin
          mm := optDesc[j] + optDesc[j + 1];
          j := j + 2;
        end;
        if (n - j) > 2 then begin
          dd := optDesc[j] + optDesc[j + 1];
          j := j + 2;
        end;
        if (n - j) > 2 then begin
          yyyy := optDesc[j] + optDesc[j + 1];
          j := j + 2;
        end;
        // --- C/P ---
        if (n > j) then begin
          opCP := optDesc[j];
          j := j + 1;
        end;
        // --- Strike price ---
        opStrike := ''; // start clear
        while j <= n do begin
          opStrike := opStrike + optDesc[j];
          j := j + 1;
        end;
        // --- CALL/PUT ---
        if opCP = 'C' then
          opCP := 'CALL'
        else if opCP = 'P' then
          opCP := 'PUT'
        else
          opCP := 'ERR';
        // --- Option Ticker (Tick ddMMMyy C/P $$$) ---
        tick := tick + ' ' + dd + getExpMo(mm) + yyyy + ' ' + opStrike + ' ' + opCP;
      end;
      // --- price ---
      PrStr := fieldLst[iPr];
      delete(PrStr, pos('$', PrStr), 1);
      PrStr := delCommas(PrStr);
      if optExpEx then
        PrStr := '0.00';
      // --- commission ---
      CmStr := fieldLst[iCm];
      // --- add'l fees ---
      feeStr := fieldLst[iFee];
      // --- amount ---
      AmtStr := fieldLst[iAmt];
      if (pos('$', AmtStr) > 0) then
        delete(AmtStr, pos('$', AmtStr), 1);
      AmtStr := delCommas(AmtStr);
      if (AmtStr = '') or (pos('*', AmtStr) > 0) then
        AmtStr := '0.00';
      // --------------------
      if (trim(tick) = '') then begin
        tick := trim(fieldLst[iCUSIP]);
        // tick := trim(fieldLst[iTk]); // description
      end;
      // --------------------
      try
        if IsNum(ShStr) then
          Shares := StrToFloat(ShStr, Settings.InternalFmt)
        else if SuperUser then
          sm('ERROR importing #Shares:' + cr + ShStr + ' is not a number');
        if Shares = 0 then begin
          dec(R);
          Continue;
        end;
        // ----------------------------
        if IsNum(PrStr) then
          Price := StrToFloat(PrStr, Settings.InternalFmt)
        else if SuperUser then
          sm('ERROR importing Price:' + cr + PrStr + ' is not a number');
        //
        if IsNum(CmStr) then
          Commis := StrToFloat(CmStr, Settings.InternalFmt)
        else if SuperUser then
          sm('ERROR importing Commission:' + cr + CmStr + ' is not a number');
        //
        if IsNum(feeStr) then
          Fees := StrToFloat(feeStr, Settings.InternalFmt)
        else if SuperUser then
          sm('ERROR importing Fees:' + cr + feeStr + ' is not a number');
        //
        if (leftStr(AmtStr, 1)= '(') and (rightStr(AmtStr, 1)= ')') then
          AmtStr := '-' + copy(AmtStr, 2, length(AmtStr)- 2); // change negatives from "()" to "-"
        if IsNum(AmtStr) then
          Amount := CurrToFloat(AmtStr)
        else if SuperUser then
          sm('ERROR importing Amount:' + cr + AmtStr + ' is not a number')
        else
          Amount := -(Shares * Price * mult) - (Commis + Fees); // last resort
        // ----------------------------
        if contracts then begin
          ImpTrades[R].prf := 'OPT-100';
        end
        else begin
          ImpTrades[R].prf := 'STK-1';
        end;
        // ----------------------------
        if iFileFmt = 1 then begin
          // ----------------------------
          // For Vision Financial CSV, use these formulas:
          // Total Commission := Commis + Fees
          if (oc = 'X') then begin
            Commis := -(Amount +(Shares * Price * mult)+ Fees);
          end
          else if (iDataVer = 2019) then begin
            Commis := -(Commis);
            Fees := -(Fees);
          end;
          Amt2 := -(Shares * Price * mult) - (Commis + Fees); // last resort
          // SAME for both BUY and SELL because broker already has correct signs
          if (ABS(Amount - Amt2) > 0.01) then begin
            if (SuperUser = true) and (bSkipAmtErr = false) then begin
              errMsg := 'WARNING: Imported Amount: ' + AmtStr + cr //
                + 'for ' + tick + ' does not match' + cr //
                + 'computed amount: ' + floattostr(Amt2) + cr + 'Continue to see this message?';
              if mDlg(errMsg, mtError, [mbYes, mbNo], 1) = mrNo then
                bSkipAmtErr := true;
            end;
            Commis := Amount - (Shares * Price * mult) - Fees;
          end;
        end
        else begin // if iFmt = 2 then
          // ----------------------------
          // For Vision Financial XLS, use these formulas:
          // ----------------------------
          Amt2 := -(Shares * Price * mult) + Commis + Fees; // 2022-04-13 MB
          if ((Amount - Amt2) > 0.01) then begin
            // in this case, it could be necessary to flip sign of fees
            if ((ABS(Amount) - ABS(-(Shares * Price * mult) + Commis - Fees)) < 0.01) then begin
              Fees := -Fees;
              Amt2 := -(Shares * Price * mult) + Commis + Fees;
            end
            else begin
              // new cm = amt + (Sh*Pr) - fee
              Commis := Amount + (Shares * Price * mult) - Fees;
            end;
            if ((Amount - Amt2) > 0.01) //
              and (SuperUser = true) //
              and (bSkipAmtErr = false) then begin
              errMsg := 'WARNING: Imported Amount: ' + AmtStr + cr //
                + 'for ' + tick + ' does not match' + cr //
                + 'computed amount: ' + floattostr(Amt2) + cr //
                + 'Continue to see this message?';
              if mDlg(errMsg, mtError, [mbYes, mbNo], 1) = mrNo then
                bSkipAmtErr := true;
            end;
          end;
        end;
        ImpTrades[R].DT := ImpDate;
        ImpTrades[R].oc := oc;
        ImpTrades[R].ls := ls;
        ImpTrades[R].tk := trim(tick);
        ImpTrades[R].opTk := trim(optDesc);
        ImpTrades[R].sh := ABS(Shares); // TL curr ver wants this always positive
        ImpTrades[R].pr := Price;
        ImpTrades[R].am := Amount;
        ImpTrades[R].cm := rndto2(Commis + Fees);
      except
// DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        dec(R);
        Continue;
      end;
      ImpTrades[R].it := TradeLogFile.Count + R;
    end; // while
    // --------------------------------
    if R > 1 then begin // 2020/09/14 - MB - if trades in reverse order
      if (xStrToDate(ImpTrades[1].DT) > xStrToDate(ImpTrades[R].DT)) then
        ReverseImpTradesDate(R);
      fixImpTradesOutOfOrder(R);
    end;
    // --------------------------------
    if cancels then begin
      for i := 1 to R do begin
        if (ImpTrades[i].oc <> 'X') then
          Continue; // only looking for 'X'
        StatBar('Matching Cancelled Trades: ' + IntToStr(i));
        for j := 1 to R do begin // try to find cancelled trade
          if (ImpTrades[j].oc <> 'X') // can't both be 'X'!
            and (ImpTrades[i].tk = ImpTrades[j].tk) // same ticker
            and (ImpTrades[i].prf = ImpTrades[j].prf) // same type
            and (i <> j) then begin
            if (ABS(ImpTrades[i].sh) - ABS(ImpTrades[j].sh) < 0.0001) // #shares
              and (ABS(ImpTrades[i].am) - ABS(ImpTrades[j].am) < 0.0001) // $amount
            then begin
              ImpTrades[i].oc := ''; // i
              ImpTrades[i].ls := '';
              ImpTrades[i].tm := '';
              ImpTrades[j].oc := ''; // j
              ImpTrades[j].ls := '';
              ImpTrades[j].tm := '';
              glNumCancelledTrades := glNumCancelledTrades + 2;
              break;
            end; // equal value
          end; // refers to same trade
        end; // for j
      end; // for i = 1 to R
    end; // if cancels
    // --------------------------------
    ImpStrList.Destroy;
    result := R;
  finally
    fieldLst.Free;
  end;
end; // ReadVisionCSV

// ENTRY POINT
function ReadVision(): integer;
var
  R : integer;
begin
  try
    R := 0;
    ImpStrList := TStringList.Create;
    ImpTrades := nil;
    setLength(ImpTrades, R + 1);
    GetImpDateLast;
    if FileExists(Settings.ImportDir + '\download.csv') then
      deleteFile(Settings.ImportDir + '\download.csv');
    // ----------------------
    GetImpStrListFromFile('Vision', 'csv|xls?', ''); // CSV or XLS/XLSX
    // ----------------------
    if (sFileType = 'xls') or (sFileType = 'xlsx') then begin
      result := ReadVisionCSV(ImpStrList, 2); // XLS?
    end
    else begin
      result := ReadVisionCSV(ImpStrList, 1); // CSV
    end;
    // ----------------------
    exit;
  finally
    // if SuperUser then sm('leaving ReadVision');
  end;
end; // ReadVision


         // -----------------
         // Paste
         // -----------------

function ReadPaste(): integer;
var
  i, j, R, n : integer;
  ImpDate, Tme, PrStr, prfStr, ShStr, CmStr, AmtStr, noteStr, opTkStr, line, oc, ls, sep, mStr,
    stgStr, brStr, abcStr, HoldingDate, junk : string;
  Amount, Commis, Shares : double;
  contracts, optTick, hasNotes, hasStrategy, hasTime, hasMatchedLots, hasBroker, hasOpen,
    hasUniqueId, hasABC, hasWSSort, hasMSort, hasHoldingDate, hasAcctType : boolean;
  lineLst : TStrings;
begin
  try
    DataConvErrRec := '';
    DataConvErrStr := '';
    R := 0;
    GetImpDateLast;
    hasStrategy := false;
    optTick := false;
    hasMatchedLots := false;
    hasNotes := false;
    hasTime := false;
    hasBroker := false;
    hasUniqueId := false;
    hasABC := false;
    hasHoldingDate := false;
    ImpStrList := TStringList.Create;
    // ImpTrades:= nil;
    // setlength(ImpTrades,R+1);
    GetImpDateLast;
    // ----------------------
    GetImpStrListFromClip(true);
    // ----------------------
    if ImpStrList.Count < 1 then begin
      ImpStrList.Destroy;
      result := 0;
      exit;
    end;
    lineLst := TStrings.Create;
    // ------- Which columns are we pasting? --------------
    // Line #0 is always the header w/ field names.
    line := ImpStrList[0];
    if pos('Strategy', line) > 0 then
      hasStrategy := true;
    if pos('Opt OPRA Symbol', line) > 0 then
      optTick := true;
    if pos('Broker Account', line) > 0 then
      hasBroker := true;
    if pos('Matched', line) > 0 then
      hasMatchedLots := true;
    if pos('Notes', line) > 0 then
      hasNotes := true;
    if pos('Time', line) > 0 then
      hasTime := true;
    if pos('Open', line) > 0 then
      hasOpen := true;
    if pos('Item', line) > 0 then
      hasUniqueId := true;
    if pos('8949 Code', line) > 0 then
      hasABC := true;
    if pos('AcctType', line) > 0 then
      hasAcctType := true;
    if pos('Holding Date', line) > 0 then
      hasHoldingDate := true;
    if pos('mSort', line) > 0 then
      hasMSort := true;
    if pos('WS Sort', line) > 0 then
      hasWSSort := true;
    // ----------- Loop through Records to Paste --------------------
    for i := 1 to (ImpStrList.Count - 1) do begin
      contracts := false;
      noteStr := '';
      line := ImpStrList[i];
      if line = '' then
        Continue;
      // count records
      inc(R);
      if R < 1 then
        R := 1;
      // parse all columns into string list
      lineLst := ParseCSV(line, TAB);
      n := lineLst.Count - 1;
      // note: parsing from last to first assumes you know how many fields
      // there are, so let's parse from first to last instead.
      // ---------- possible grid columns ---------------------------
      j := -1; // error condition
      // 0: Item Id
      if hasUniqueId then begin
        inc(j);
      end;
      // 1: TradeNum;
      inc(j); // don't use it - must renumber!
      // 2: Date;
      inc(j);
      ImpDate := trim(lineLst[j]);
      if (pos(Settings.UserFmt.DateSeparator, ImpDate) = 0) then begin
        dec(R);
        if (i = ImpStrList.Count - 1) and (R = 0) then begin
          DataConvErrRec := 'No Data Selected';
          sm('Edit, Paste Import Error' + cr + cr + 'Please reselect entire table');
          result := 0;
          exit;
        end;
        Continue;
      end;
      ImpDate := DateToStr(xStrToDate(ImpDate, Settings.UserFmt), Settings.InternalFmt);
      if UserDateStrNotGreater(ImpDate, ImpDateLast) then begin
        if mDlg('Trades already imported for ' + ImpDate + cr + cr + 'Continue?', mtWarning,
          [mbNo, mbYes], 0) = mrNo then begin
          result := R - 1;
          exit;
        end
        else
          ImpDateLast := LongDateStr('01/01/1900');
      end;
      // 3: Time
      if hasTime then begin
        inc(j);
        Tme := trim(lowercase(lineLst[j])); // 2022-01-07 MB - was hard-coded to [2]
      end;
      // 4: OC;
      inc(j);
      oc := trim(lineLst[j]);
      oc := uppercase(oc);
      // 5: LS;
      inc(j);
      ls := trim(lineLst[j]);
      ls := uppercase(ls);
      // 6: Ticker;
      inc(j);
      tick := trim(lineLst[j]);
      tick := uppercase(tick);
      // 7: Shares;
      inc(j);
      ShStr := trim(lineLst[j]);
      ShStr := DelParenthesis(ShStr);
      // 8: Price;
      inc(j);
      PrStr := trim(lineLst[j]);
      // 9: TypeMult;
      inc(j);
      prfStr := uppercase(trim(lineLst[j]));
      // 10: Commission;
      inc(j);
      CmStr := trim(trim(lineLst[j]));
      CmStr := DelParenthesis(CmStr);
      // 11: Amount;
      inc(j);
      AmtStr := trim(trim(lineLst[j]));
      // if AmtStr = '' then AmtStr := trim(line); // ???
      if pos('(', AmtStr) > 0 then begin
        AmtStr := DelParenthesis(AmtStr);
        AmtStr := '-' + AmtStr;
      end;
      // 12: PL;
      inc(j);
      // 13: Note;
      if (n > j) and hasNotes then begin
        inc(j);
        noteStr := trim(lineLst[j]);
      end;
      // 14: Open;
      if (n > j) and hasOpen then begin
        inc(j);
      end;
      // 15: Matched;
      if (n > j) and hasMatchedLots then begin
        inc(j);
        mStr := trim(lineLst[j]);
        // If the Matched value is not for exercise of option then don't paste it
        // If we paste it then we get issues with the renumber function not working
        // if all transactions that are part of a manual match are not copied.
        if pos('Ex', mStr) = 0 then
          mStr := '';
      end;
      // 16: Broker; // Always use the CurrentBroker ID for the br field.
      brStr := IntToStr(TradeLogFile.CurrentBrokerID);
      // 17: OptionTicker;
      if (n > j) and optTick then begin
        inc(j);
        opTkStr := trim(lineLst[j]); // 2021-12-08 MB - was hard-coded to 15, but not always right!
      end;
      // 18: TypeMult
      // 19: Strategy;
      if (n > j) and hasStrategy then begin
        inc(j);
        stgStr := trim(lineLst[j]);
      end;
      // 20: ABCCode;
      if (n > j) and hasABC then begin
        inc(j);
        abcStr := lineLst[j];
      end;
      // 21: getAcctType;
      if (n > j) and hasAcctType then begin
        inc(j);
      end;
      // 22: WSHoldingDate
      if (n > j) and hasHoldingDate then begin
        inc(j);
        HoldingDate := lineLst[j];
      end;
      // 23: Matched
      // 24: getUnderlying(Trade);
      // ----- Now let's put it into ImpTrades[] ----------
      try
        if ls = 'S' then begin
          if (oc = 'O') and AssignShortSell then begin
            oc := 'C';
            ls := 'L';
          end
          else if (oc = 'C') and AssignShortBuy then begin
            oc := 'O';
            ls := 'L';
          end;
        end;
        Shares := StrToFloat(ShStr, Settings.UserFmt);
        Price := FracDecToFloatEx(PrStr, Settings.UserFmt);
        Commis := CurrToFloatEx(CmStr, Settings.UserFmt);
        Amount := CurrToFloatEx(AmtStr, Settings.UserFmt);
        // ----------------------------
        ImpTrades[R].it := TradeLogFile.Count + R;
        ImpTrades[R].DT := ImpDate;
        ImpTrades[R].tm := Tme;
        ImpTrades[R].oc := oc;
        ImpTrades[R].ls := ls;
        ImpTrades[R].tk := tick;
        ImpTrades[R].sh := Shares;
        ImpTrades[R].pr := Price;
        ImpTrades[R].prf := prfStr;
        ImpTrades[R].cm := Commis;
        ImpTrades[R].am := Amount;
        ImpTrades[R].no := noteStr;
        ImpTrades[R].m := mStr;
        ImpTrades[R].opTk := opTkStr;
        ImpTrades[R].br := brStr;
        ImpTrades[R].strategy := stgStr;
        ImpTrades[R].abc := abcStr;
        ImpTrades[R].HoldingDate := HoldingDate;
      except
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        dec(R);
        Continue;
      end;
    end; // for loop
    result := R;
    setLength(ImpTrades, R + 1);
  finally
    if (result <> R) then
      sm('error occured in Paste function.');
  end;
end; // ReadPaste


                    // --------------------------
                    // UTILITY ROUTINES
                    // --------------------------

procedure CheckForDataConvertErr;
var
  i : integer;
  frmDataConvErr : TFrmDataConvErr;
begin
  StatBar('Checking for Data Import Conversion Errors');
  if DataConvErrRec <> '' then begin
    if DataConvErrRec = 'No records imported' then
      exit;
    frmDataConvErr := TFrmDataConvErr.Create(frmMain);
    with frmDataConvErr do begin
      frmDataConvErr.memo1.Text := DataConvErrRec;
      frmDataConvErr.showmodal;
      frmDataConvErr.Free;
    end;
    DataConvErrStr := TradeLogFile.CurrentAccount.FileImportFormat + cr //
      + DataConvErrRec + cr + cr //
      + clipBoard.astext;
    AssignFile(ErrLog, Settings.DataDir + '\error.log');
    rewrite(ErrLog);
    try
      for i := 1 to length(DataConvErrStr) do begin
        if copy(DataConvErrStr, 1, 1) = cr then
          writeln(ErrLog)
        else
          write(ErrLog, copy(DataConvErrStr, 1, 1));
        delete(DataConvErrStr, 1, 1);
      end;
    finally
      CloseFile(ErrLog);
      StatBar('off');
    end;
  end;
end;


//procedure SaveStrToFile(const FileName : TFileName; const content : string);
//begin
//  with TFileStream.Create(FileName, fmCreate) do
//    try
//      write(Pointer(content)^, length(content));
//    finally
//      Free;
//    end;
//end;


// --------------------------
procedure ForceMatchTrades;
var
  i : integer;
  R : integer;
  UndoFunc : string;
  msg : string;
  TradeList : TTradeList;
begin
  if not CheckRecordLimit or oneYrLocked or isAllBrokersSelected or (TradeLogFile.Count = 0) then
    exit;
  // --------------
  msg := '';
  TradeList := nil;
  try
    with frmMain.cxGrid1TableView1.DataController do begin
      // ForceMatch Selected Records
      if (GetSelectedCount > 0) and not bImporting then begin
        TradeList := TTradeList.Create;
        msg := 'Force Match Selected Records?' + cr + cr;
        for i := 0 to GetSelectedCount - 1 do begin
          R := GetRowInfo(GetSelectedRowIndex(i)).RecordIndex;
          TradeList.Add(TradeLogFile[R]);
        end;
      end
      // ForceMatch Filtered Records
      else if (FilteredRecordCount > 0) and not frmMain.btnShowAll.Down and not bImporting then
      begin
        TradeList := TTradeList.Create;
        msg := 'Force Match Filtered Records?' + cr + cr;
        for i := 0 to FilteredRecordCount - 1 do begin
          R := FilteredRecordIndex[i];
          TradeList.Add(TradeLogFile[R]);
        end;
      end
      // ForceMatch All Records in Selected Account
      else begin
        clearFilter;
        msg := 'Force Match ALL Records in Current Account? ' + cr + cr;
        // TradeList := TradeLogFile.TradeList;
      end;
    end; // <-- with
    msg := msg + 'Note: This will change some shorts to long and some longs to short' + cr +
      'and it will split some transations into two.' + cr + cr +
      'Are you sure this is what you want to do?';
    if mDlg(msg, mtWarning, [mbYes, mbNo], 0) = mrNo then begin
      screen.Cursor := crDefault;
      exit;
    end;
    screen.Cursor := crHourglass;
    // turn off grid update
    frmMain.cxGrid1TableView1.BeginUpdate;
    /// // Do TLFile ForceMatch /////
    if (TradeList = nil) then
      TradeLogFile.MatchAll(true)
    else begin
      ReadFilter;
      TradeList := TradeLogFile.Match(TradeList, true);
    end;
    TradeLogFile.Reorganize;
    // ----------------------
    if not bImporting then begin
      UndoFunc := 'Force Match Trades';
      frmMain.btnShowAll.Click;
      frmMain.cxGrid1TableView1.DataController.ClearSelection;
      TradeRecordsSource.DataChanged;
    end
    else
      UndoFunc := '';
    if (TradeList <> nil) then begin
      clearFilter;
      WriteFilter(true);
    end;
    FindTradeIssues;
    SaveTradeLogFile(UndoFunc, bImporting);
    if not bImporting then begin
      dispProfit(true, 0, 0, 0, 0);
    end;
  finally
    frmMain.cxGrid1TableView1.EndUpdate;
    screen.Cursor := crDefault;
    if not bImporting then
      repaintGrid;
    // Note: TradeList gets freed in TradeLogFile.Match
  end;
end;


                    // --------------------------
                    // SORTING ROUTINES
                    // --------------------------

procedure SortImpByDateOC(b, e : integer);
var
  i, j, X : integer;
  DateList : TStringList;
  Sort : TTradeArray;
begin
  try
    DateList := TStringList.Create;
    DateList.clear;
    for i := b to e do begin
      with ImpTrades[i] do begin
        // sm(inttostr(i)+' '+dt);
        if DateList.IndexOf(YYYYMMDD_Ex(DT, Settings.InternalFmt)) = -1 then
          DateList.Add(YYYYMMDD_Ex(DT, Settings.InternalFmt));
      end;
    end;
    DateList.Sort;
    StatBar('Fixing trades out of order');
    // msgTxt:=''; for i:= 0 to dateList.count-1 do MsgTxt:= MsgTxt +intToStr(i)+'  '+dateList[i] +cr; sm(MsgTxt);
    X := 0;
    Sort := nil;
    setLength(Sort, e - b + 2);
    for i := 0 to DateList.Count - 1 do begin
      // get open shorts first
      for j := b to e do begin
        with ImpTrades[j] do begin
          if (oc = 'O') and (ls = 'S') and (YYYYMMDD_Ex(DT, Settings.InternalFmt) = DateList[i])
          then begin
            inc(X);
            Sort[X] := ImpTrades[j];
          end;
        end;
      end;
      // get open longs next
      for j := b to e do begin
        with ImpTrades[j] do begin
          if (oc = 'O') and (ls = 'L') and (YYYYMMDD_Ex(DT, Settings.InternalFmt) = DateList[i])
          then begin
            inc(X);
            Sort[X] := ImpTrades[j];
          end;
        end;
      end;
      // get close trades
      for j := b to e do begin
        with ImpTrades[j] do begin
          if (oc = 'C') and (YYYYMMDD_Ex(DT, Settings.InternalFmt) = DateList[i]) then begin
            inc(X);
            Sort[X] := ImpTrades[j];
          end;
        end;
      end;
      // get cancel trades
      for j := b to e do begin
        with ImpTrades[j] do begin
          if ((oc = 'X') or (oc = '')) and (YYYYMMDD_Ex(DT, Settings.InternalFmt) = DateList[i])
          then begin
            inc(X);
            Sort[X] := ImpTrades[j];
          end;
        end;
      end;
      StatBar('Fixing trades out of order: ' + MMDDYYYY(DateList[i]));
    end;
    // copy sorted trades back to Trades array
    for i := 1 to high(Sort) do begin
      ImpTrades[b + i - 1] := Sort[i];
    end;
    Sort := nil;
    DateList.Destroy;
  finally
     //
  end;
end; // SortImpByDteOC


//procedure SortImpByDateOCNEW(b, e : integer);
//var
//  h, i, j, X : integer;
//  closedSh, openSh : double;
//  DateList, itemList, tickList : TStringList;
//  Sort : TTradeArray;
//begin
//  try
//    DateList := TStringList.Create;
//    DateList.clear;
//    itemList := TStringList.Create;
//    itemList.clear;
//    tickList := TStringList.Create;
//    tickList.clear;
//    // put all ticks into tickList - added 3-1-02
//    for i := b to e do begin
//      if tickList.IndexOf(ImpTrades[i].tk) = -1 then
//        tickList.Add(ImpTrades[i].tk);
//    end;
//    tickList.Sort;
//    // for i:= 0 to dateList.count-1 do MsgTxt:= MsgTxt +dateList[i] +tab;
//    // sm(MsgTxt);
//    X := 0;
//    closedSh := 0;
//    Sort := nil;
//    setLength(Sort, e - b + 10);
//    for h := 0 to tickList.Count - 1 do begin
//      openSh := 0;
//      StatBar('Sorting - ' + copy(tickList[h], 1, 1));
//      // put all dates into DateList - changed 3-1-02
//      DateList.clear;
//      for i := b to e do begin
//        if (DateList.IndexOf(YYYYMMDD_Ex(ImpTrades[i].DT, Settings.InternalFmt)) = -1) and
//          (tickList[h] = ImpTrades[i].tk) then
//          DateList.Add(YYYYMMDD_Ex(ImpTrades[i].DT, Settings.InternalFmt));
//      end;
//      DateList.Sort;
//      for i := 0 to DateList.Count - 1 do begin
//        // get close trades total shares
//        closedSh := 0;
//        for j := b to e do begin
//          with ImpTrades[j] do begin
//            if (oc = 'C') and (YYYYMMDD_Ex(DT, Settings.InternalFmt) = DateList[i]) and
//              (tickList[h] = tk) then begin
//              closedSh := closedSh + sh;
//            end;
//          end;
//        end;
//        // get open trades first
//        for j := b to e do begin
//          with ImpTrades[j] do begin
//            if (((oc = 'O') and (ls = 'L')) or ((oc = 'O') and (ls = 'S'))) and
//              (YYYYMMDD_Ex(DT, Settings.InternalFmt) = DateList[i]) and (tickList[h] = tk) and
//              (((i = DateList.Count - 1) and (sh <= closedSh)) or (sh <= closedSh - openSh)) then
//            begin
//              inc(X);
//              Sort[X] := ImpTrades[j];
//              openSh := openSh + sh;
//              itemList.Add(IntToStr(it));
//            end;
//          end;
//        end;
//        // get close trades
//        for j := b to e do begin
//          with ImpTrades[j] do begin
//            if (((oc = 'C') and (ls = 'L')) or ((oc = 'C') and (ls = 'S'))) and
//              (YYYYMMDD_Ex(DT, Settings.InternalFmt) = DateList[i]) and (tickList[h] = tk) and
//              (sh <= openSh) then begin
//              inc(X);
//              Sort[X] := ImpTrades[j];
//              openSh := openSh - sh;
//              itemList.Add(IntToStr(it));
//            end;
//          end;
//        end;
//        itemList.Sort;
//      end;
//      for i := 0 to DateList.Count - 1 do begin
//        // get balance of open trades
//        for j := b to e do begin
//          with ImpTrades[j] do begin
//            if (((oc = 'O') and (ls = 'L')) or ((oc = 'O') and (ls = 'S'))) and
//              (YYYYMMDD_Ex(DT, Settings.InternalFmt) = DateList[i]) and (tickList[h] = tk) and
//              (itemList.IndexOf(IntToStr(it)) = -1) then begin
//              inc(X);
//              Sort[X] := ImpTrades[j];
//              openSh := openSh + sh;
//              itemList.Add(IntToStr(it));
//            end;
//          end;
//        end;
//        // get balance of close trades
//        for j := b to e do begin
//          with ImpTrades[j] do begin
//            if (((oc = 'C') and (ls = 'L')) or ((oc = 'C') and (ls = 'S'))) and
//              (YYYYMMDD_Ex(DT, Settings.InternalFmt) = DateList[i]) and (tickList[h] = tk) and
//              (itemList.IndexOf(IntToStr(it)) = -1) then begin
//              inc(X);
//              Sort[X] := ImpTrades[j];
//              openSh := openSh - sh;
//              itemList.Add(IntToStr(it));
//            end;
//          end;
//        end;
//        // get cancel trades
//        for j := b to e do begin
//          with ImpTrades[j] do begin
//            if (oc = 'X') and (YYYYMMDD_Ex(DT, Settings.InternalFmt) = DateList[i]) and
//              (tickList[h] = tk) and (itemList.IndexOf(IntToStr(it)) = -1) then begin
//              inc(X);
//              Sort[X] := ImpTrades[j];
//              openSh := openSh - sh;
//              itemList.Add(IntToStr(it));
//            end;
//          end;
//        end;
//      end;
//    end;
//    // copy sorted trades back to Trades array
//    setLength(Sort, X + 1);
//    for i := 1 to X do begin
//      ImpTrades[b + i - 1] := Sort[i];
//    end;
//    Sort := nil;
//    DateList.Destroy;
//    itemList.Destroy;
//    tickList.Destroy;
//    StatBar('off');
//  finally
//    //
//  end;
//end; // SortImpByDateOCNew


                    // --------------------------
                    // FUTURES
                    // --------------------------

function isFutureOpt(tick : string): boolean;
begin
  try
    // currencies
    if (pos('EUR ', tick) = 1) or (pos('6A ', tick) = 1) or (pos('AD ', tick) = 1) or
      (pos('6B ', tick) = 1) or (pos('BP ', tick) = 1) or (pos('6C ', tick) = 1) or
      (pos('CD ', tick) = 1) or (pos('6E ', tick) = 1) or (pos('EC ', tick) = 1) or
      (pos('6J ', tick) = 1) or (pos('JY ', tick) = 1) or (pos('6M ', tick) = 1) or
      (pos('MP ', tick) = 1) or (pos('6S ', tick) = 1) or (pos('SF ', tick) = 1) or
      (pos('DX ', tick) = 1)
    // indexes e-minis:
      or (pos('DD ', tick) = 1) or (pos('CR ', tick) = 1) or (pos('ZDJ ', tick) = 1) or
      (pos('DJ ', tick) = 1) or (pos('NQ ', tick) = 1) or (pos('ER2 ', tick) = 1) or
      (pos('ES ', tick) = 1) or (pos('EMD ', tick) = 1) or (pos('RS1 ', tick) = 1) or
      (pos('YM ', tick) = 1) or (pos('VIX ', tick) = 1)
    // full indexes
      or (pos('GI ', tick) = 1) or (pos('RL ', tick) = 1) or (pos('ND ', tick) = 1) or
      (pos('ZND ', tick) = 1) or (pos('MD ', tick) = 1) or (pos('ZMD ', tick) = 1) or
      (pos('NK ', tick) = 1) or (pos('NKD ', tick) = 1) or (pos('RL ', tick) = 1) or
      (pos('ZRL ', tick) = 1) or (pos('SP ', tick) = 1) or (pos('ZSP ', tick) = 1) or
      (pos('CM ', tick) = 1) or (pos('DX ', tick) = 1)
    // interest rates
      or (pos('TY ', tick) = 1) or (pos('ZN ', tick) = 1) or (pos('TU ', tick) = 1) or
      (pos('ZT ', tick) = 1) or (pos('US ', tick) = 1) or (pos('ZB ', tick) = 1) or
      (pos('FB ', tick) = 1) or (pos('ZF ', tick) = 1) or (pos('ED ', tick) = 1) or
      (pos('GE ', tick) = 1) or (pos('ZQ ', tick) = 1) or (pos('FF ', tick) = 1) or
      (pos('EM ', tick) = 1) or (pos('GLB ', tick) = 1) or (pos('GLTL ', tick) = 1) or
      (pos('YE ', tick) = 1) or (pos('MB ', tick) = 1) or (pos('ZU ', tick) = 1)
    // energies
      or (pos('CL ', tick) = 1) or (pos('YC ', tick) = 1) or (pos('HO ', tick) = 1) or
      (pos('YO ', tick) = 1) or (pos('QM ', tick) = 1) or (pos('QU ', tick) = 1) or
      (pos('QH ', tick) = 1) or (pos('QG ', tick) = 1) or (pos('NG ', tick) = 1) or
      (pos('YN ', tick) = 1) or (pos('HU ', tick) = 1) or (pos('YQ ', tick) = 1)
    // Metals
      or (pos('AL ', tick) = 1) or (pos('YL ', tick) = 1) or (pos('HG ', tick) = 1) or
      (pos('YH ', tick) = 1) or (pos('GC ', tick) = 1) or (pos('YG ', tick) = 1) or
      (pos('ZG ', tick) = 1) or (pos('ZYG ', tick) = 1) or (pos('YI ', tick) = 1) or
      (pos('PA ', tick) = 1) or (pos('YA ', tick) = 1) or (pos('PL ', tick) = 1) or
      (pos('YP ', tick) = 1) or (pos('SI ', tick) = 1) or (pos('YV ', tick) = 1) or
      (pos('ZI ', tick) = 1) then
      result := true
    else
      result := false;
  finally
    //
  end;
end; // isFutureOpt


function futuresMult_IB(tick : string): double;
begin
  try
    // e-minis:
    if pos('ES ', tick) = 1 then
      result := 50
    else if pos('NQ ', tick) = 1 then
      result := 20
    else if pos('SP ', tick) = 1 then
      result := 250
    // currencies
    else if pos('AUD ', tick) = 1 then
      result := 100000
    else if pos('CAD ', tick) = 1 then
      result := 100000
    else if pos('CHF ', tick) = 1 then
      result := 125000
    else if pos('GBP ', tick) = 1 then
      result := 62500
    else if pos('EUR ', tick) = 1 then
      result := 125000
    else if pos('MXP ', tick) = 1 then
      result := 500000
    else if pos('JPY ', tick) = 1 then
      result := 12500000
    else if pos('NKD ', tick) = 1 then
      result := 5
    // currencies
    else if pos('6A ', tick) = 1 then
      result := 100000
    else if pos('6B ', tick) = 1 then
      result := 62500
    else if pos('6C ', tick) = 1 then
      result := 100000
    else if pos('6E ', tick) = 1 then
      result := 125000
    else if pos('6J ', tick) = 1 then
      result := 12500000
    else if pos('JY ', tick) = 1 then
      result := 12500000
    else if pos('6M ', tick) = 1 then
      result := 500000
    else if pos('MP ', tick) = 1 then
      result := 500000
    else if pos('6S ', tick) = 1 then
      result := 125000
    else if pos('SF ', tick) = 1 then
      result := 125000
    else if pos('DX ', tick) = 1 then
      result := 1000
    // mini Euro
    else if pos('E7 ', tick) = 1 then
      result := 62500
    else if pos('GE ', tick) = 1 then
      result := 2500
    // Mini DOWS:
    else if pos('YM ', tick) = 1 then
      result := 5
    else if pos('YJ ', tick) = 1 then
      result := 2
    // T-Bonds, T-Notes:
    else if pos('ZB ', tick) = 1 then
      result := 1000
    else if pos('ZN ', tick) = 1 then
      result := 1000
    else if pos('ZF ', tick) = 1 then
      result := 1000
    else if pos('ZT ', tick) = 1 then
      result := 2000
    // European indexes:
    else if pos('ESTX50 ', tick) = 1 then
      result := 10
    else if pos('FESX ', tick) = 1 then
      result := 10
    else if pos('DAX ', tick) = 1 then
      result := 25
    else if pos('Z ', tick) = 1 then
      result := 1000
    // FTSE
    // mini Metals
    else if pos('YG ', tick) = 1 then
      result := xStrToFloat('33.2')
    else if pos('YI ', tick) = 1 then
      result := 1000
    // Metals
    else if pos('ZI ', tick) = 1 then
      result := 5000
    // silver
    else if pos('ZG ', tick) = 1 then
      result := 100
    // gold
    else if pos('HG ', tick) = 1 then
      result := 25000
    // copper
    // oil, crude oil
    else if pos('QM ', tick) = 1 then
      result := 500
    else if (pos('CL ', tick) = 1) then
      result := 1000
    else if (pos('COIL ', tick) = 1) then
      result := 1000
    // natural gas
    else if pos('QG ', tick) = 1 then
      result := 2500
    // Russell 2000
    else if pos('ER2 ', tick) = 1 then
      result := 100
    // Retail Microsector index
    else if (pos('XRTS ', tick) = 1) then
      result := 500
    // Neikki
    else if (pos('JNI ', tick) = 1) then
      result := 1000
    else if (pos('NIY ', tick) = 1) then
      result := 500
    else if (pos('SSI ', tick) = 1) then
      result := 500
    // All others are Single Stock Futures
    else
      result := 100;
  finally
    //
  end;
end; // futuresMult_IB


//// NOTE: For decimal values, write code in form:
//function futuresMult_TNO(tick : string): double;
//begin
//  // currencies
//  if pos('6A ', tick) = 1 then
//    result := 100000
//  else if pos('6B ', tick) = 1 then
//    result := 62500
//  else if pos('6C ', tick) = 1 then
//    result := 100000
//  else if pos('6E ', tick) = 1 then
//    result := 125000
//  else if pos('6J ', tick) = 1 then
//    result := 12500000
//  else if pos('6M ', tick) = 1 then
//    result := 500000
//  else if pos('6F ', tick) = 1 then
//    result := 125000
//  // indexes
//  // e-minis:
//  else if pos('ES ', tick) = 1 then
//    result := 50
//  else if pos('NQ ', tick) = 1 then
//    result := 20
//  else if pos('ER2 ', tick) = 1 then
//    result := 100
//  else if pos('EMD ', tick) = 1 then
//    result := 500
//  else if pos('RS1 ', tick) = 1 then
//    result := 100
//  // full indexes
//  else if pos('GI ', tick) = 1 then
//    result := 250
//  else if pos('RL ', tick) = 1 then
//    result := 500
//  else if pos('ND ', tick) = 1 then
//    result := 100
//  else if pos('SP ', tick) = 1 then
//    result := 250
//  else if pos('MD ', tick) = 1 then
//    result := 500
//  else if pos('NK ', tick) = 1 then
//    result := 5
//  else if pos('YM ', tick) = 1 then
//    result := 500
//  else if pos('DJ ', tick) = 1 then
//    result := 200
//  else if pos('CM ', tick) = 1 then
//    result := 500
//  else if pos('DX ', tick) = 1 then
//    result := 1000
//  // interest rates
//  else if pos('ZQ ', tick) = 1 then
//    result := 5000000
//  else if pos('ZU ', tick) = 1 then
//    result := 100000
//  else if pos('ZN ', tick) = 1 then
//    result := 100000
//  else if pos('ZF ', tick) = 1 then
//    result := 100000
//  else if pos('ZB ', tick) = 1 then
//    result := 100000
//  else if pos('ZT ', tick) = 1 then
//    result := 200000
//  else if pos('GE ', tick) = 1 then
//    result := 2500
//  // energies
//  // all others are SSF
//  else
//    result := 100;
//end;


//function futuresMonth(m : string): string;
//begin
//  if m = 'F' then
//    result := 'JAN';
//  if m = 'G' then
//    result := 'FEB';
//  if m = 'H' then
//    result := 'MAR';
//  if m = 'J' then
//    result := 'APR';
//  if m = 'K' then
//    result := 'MAY';
//  if m = 'M' then
//    result := 'JUN';
//  if m = 'N' then
//    result := 'JUL';
//  if m = 'Q' then
//    result := 'AUG';
//  if m = 'U' then
//    result := 'SEP';
//  if m = 'V' then
//    result := 'OCT';
//  if m = 'X' then
//    result := 'NOV';
//  if m = 'Z' then
//    result := 'DEC';
//end;


function formatFut(s : string): string;
var
  exYr, exMo, under : string;
  l : integer;
begin
  try
    l := length(s);
    // ESH1 or ESH11
    if (pos(' ', s) = 0) then begin
      // if two digit year ie: 11
      if (isInt(rightStr(s, 2))) then begin
        exYr := rightStr(s, 2);
        exMo := rightStr(s, 3);
        exMo := leftStr(exMo, 1);
        exMo := getFutExpMonth(exMo);
        under := leftStr(s, l - 3);
        result := under + ' ' + exMo + exYr;
      end
      // if one digit year ie: 1
      else if (not isInt(rightStr(s, 2))) then begin
        exYr := rightStr(s, 1);
        exYr := '1' + exYr;
        exMo := rightStr(s, 2);
        exMo := leftStr(exMo, 1);
        exMo := getFutExpMonth(exMo);
        under := leftStr(s, l - 2);
        result := under + ' ' + exMo + exYr;
      end
    end
    // ticker has a space and a dash ie: ES 03-11
    else if (pos('-', s) > 0) then begin
      // if two digit year ie: 11
      if (isInt(rightStr(s, 2))) then begin
        exYr := parseLast(s, '-');
        exMo := parseLast(s, ' ');
        exMo := getExpMo(exMo);
        result := s + ' ' + exMo + exYr;
      end;
    end
    else
      result := s;
  finally
    //
  end;
end; // formatFut


function futuresMult(s, prf : string; BrokerID : integer): string;
var
  Item : PFutureItem;
  i : integer;
  tk, mult, symbol : string;
  changeMult, changed, found : boolean;
  chgRec : pChgdRec;
  FutureList : TList;
begin
  try
    if BrokerID = 0 then
      raise Exception.Create('Invalid Broker ID: Cannot determine FuturesMult');
    if (TradeLogFile.FileHeader[BrokerID].importFilter.FilterName = 'IB') then begin
      result := prf;
      exit;
    end;
    tk := trim(s);
    if prf = '' then
      prf := 'FUT-0';
    result := '';
    changed := false;
    found := false;
    changeMult := false;
    mult := parseLast(prf, '-');
    symbol := copy(s, 1, pos(' ', s) - 1);
    if mult = '0' then
      changed := true;
    if not changed then
      for i := 0 to changedFuturesList.Count - 1 do begin
        chgRec := changedFuturesList[i];
        if (chgRec.sym = symbol) then begin
          changed := true;
          if (chgRec.chngd = true) then
            changeMult := true;
          break;
        end;
      end;
    // Return the appropriate future multiplier from the global list
    for i := 0 to Settings.FutureList.Count - 1 do begin
      Item := Settings.FutureList[i];
      // test if futures symbol is found in global futures list
      if (pos(trim(Item.name) + ' ', tk) = 1) then begin
        found := true;
        // test if imported mult = mult in futures list
        if Item.Value <> StrToFloat(mult, Settings.InternalFmt) then begin
          if bImporting and not changed then begin
            new(chgRec);
            if mDlg(s + cr //
                + 'mult = ' + mult + cr //
                + cr //
                + 'The above imported futures multiplier' + cr //
                + 'does not match the Trade Type futures multiplier' + cr //
                + 'mult = ' + floattostr(Item.Value, Settings.InternalFmt) + cr //
                + cr //
                + 'Change Trade Type futures multiplier to match?' + cr, mtConfirmation,
              [mbYes, mbNo], 0) = mrYes then begin
              Item.Value := StrToFloat(mult, Settings.InternalFmt);
              chgRec.chngd := true;
            end
            else
              chgRec.chngd := false;
            chgRec.sym := symbol;
            changedFuturesList.Add(chgRec);
          end
          else if changeMult then begin
            // silent change mult in list
            Item.Value := StrToFloat(mult, Settings.InternalFmt);
          end;
        end;
        result := 'FUT-' + floattostr(Item.Value, Settings.UserFmt);
        break;
      end;
    end;
    // future is not in the list
    FutureList := Settings.FutureList;
    if not found and bImporting and (mult <> '0') then begin
      new(Item);
      Item.name := symbol;
      Item.Value := StrToFloat(mult, Settings.InternalFmt);
      FutureList.Add(Item);
      result := 'FUT-' + floattostr(Item.Value, Settings.UserFmt);
    end;
    Settings.FutureList := FutureList;
    if result = '' then
      result := 'FUT-0';
  finally
    //
  end;
end; // futuresMult


// 2018-05-02 MB - updated for new BBIO objects
function futures_index(tick : string): string;
var
  pBBIO : PBBIOItem;
  i : integer;
begin
  try
    tick := trim(tick);
    result := '';
    // Return the appropriate BBindex multiplier
    for i := 0 to Settings.BBIOList.Count - 1 do begin
      pBBIO := Settings.BBIOList[i];
      if (pos(trim(pBBIO.symbol) + ' ', tick) = 1) then begin
        result := 'FUT-' + pBBIO.mult;
        break;
      end;
    end;
    if result = '' then
      result := 'OPT-100';
  except
    on e : Exception do begin
      mDlg('error encountered while checking for broad-based index options: ' //
          + e.Message, mtWarning, [mbOK], 0);
    end;
  end; // try...except
end; // futures_index


//function futures_IB(tick : string): boolean;
//begin
//  try
//    if (
//        (pos('JAN0', tick) > 0)
//     or (pos('FEB0', tick) > 0)
//     or (pos('MAR0', tick) > 0)
//     or (pos('APR0', tick) > 0)
//     or (pos('MAY0', tick) > 0)
//     or (pos('JUN0', tick) > 0)
//     or (pos('JUL0', tick) > 0)
//     or (pos('AUG0', tick) > 0)
//     or (pos('SEP0', tick) > 0)
//     or (pos('OCT0', tick) > 0)
//     or (pos('NOV0', tick) > 0)
//     or (pos('DEC0', tick) > 0)
//    )
//    and (
//         (copy(tick, length(tick), 1) <> 'C')
//     and (copy(tick, length(tick), 1) <> 'P')
//     and (pos('CALL', tick) = 0)
//     and (pos('PUT', tick) = 0)
//    ) then
//      result := true
//    else
//      result := false;
//  finally
//    // futures_IB
//  end;
//end;


// ====================================
// Handle changes to FUT multipliers
// ====================================
function changeFutMult(Trades : TTradeList; bAdjContr : boolean = false): boolean;
var
  i : integer;
  impTr : PTrade;
  typeStr, mult, mult2 : string;
  nOldMult, nNewMult : double;
  Trade : TTLTrade;
begin
  result := false;
  changedFuturesList := TList.Create;
  try
    for Trade in Trades do begin
      typeStr := Trade.TypeMult;
      mult := parseLast(typeStr, '-');
      nOldMult := StrToFloatDef(mult, 1);
      // change futures multipliers - must come before change index options 2010-02-25
      if (pos('FUT-', Trade.TypeMult) = 1) then begin
        typeStr := futuresMult(Trade.Ticker, Trade.TypeMult, Trade.Broker);
        mult2 := copy(typeStr, pos('-', typeStr)+ 1);
        // change futures trades first
        if (typeStr <> 'FUT-0') and (pos('FUT-', Trade.TypeMult) = 1) and
          (pos(' CALL', Trade.Ticker) = 0) and (pos(' PUT', Trade.Ticker) = 0) then begin
          Trade.TypeMult := typeStr;
          if bAdjContr then begin // 2016-12-12 MB - Adjust #Contracts
            nNewMult := StrToFloatDef(mult2, 1);
            if (nOldMult <> 0) and (nNewMult <> 0) then begin
              // adjust shares to keep #contracts the same
              Trade.Shares := Trade.Shares * nOldMult / nNewMult;
            end;
          end;
        end;
        // next change futures options
        if (typeStr = 'FUT-0') and
          (((pos(' CALL', Trade.Ticker) = length(Trade.Ticker) - 4) and
              (pos(' CALL', Trade.Ticker) > 1)) or
            ((pos(' PUT', Trade.Ticker) = length(Trade.Ticker) - 3) and
              (pos(' PUT', Trade.Ticker) > 1))) then begin
          // change future option back to option if deleted from bb index or futures list
          if futures_index(Trade.Ticker) = 'OPT-100' then
            Trade.TypeMult := 'OPT-100'
          else if TradeLogFile.FileHeader[Trade.Broker].FileImportFormat = 'IB' then begin
            typeStr := futures_index(Trade.Ticker);
            if typeStr <> 'OPT-100' then
              Trade.TypeMult := typeStr;
          end
          else
            Trade.TypeMult := futures_index(Trade.Ticker);
        end;
      end
      else if (pos('OPT-', Trade.TypeMult) = 1) or
        ((pos(' CALL', Trade.Ticker) = length(Trade.Ticker) - 4) and
          (pos(' CALL', Trade.Ticker) > 1)) or
        ((pos(' PUT', Trade.Ticker) = length(Trade.Ticker) - 3) and (pos(' PUT', Trade.Ticker) > 1))
      then begin
        typeStr := futures_index(Trade.Ticker);
        if typeStr <> 'OPT-100' then
          Trade.TypeMult := typeStr;
        if TradeLogFile.FileHeader[Trade.Broker].FileImportFormat = 'IB' then
          Trade.TypeMult := parsefirst(typeStr, '-') + '-' + mult;
      end;
    end;
  finally
    result := changedFuturesList.Count > 0;
    FreeAndNil(changedFuturesList);
  end;
end;


                    // --------------------------
                    // OTHER
                    // --------------------------

//procedure ClearTList(List : TList);
//var
//  i : integer;
//begin
//  if List <> nil then
//    for i := 0 to List.Count - 1 do
//      Dispose(List[i]);
//  List.clear;
//end;


//procedure readTXF;
//var
//  i, R : integer;
//  line, cat, od, cd, sales, cost, prof : string;
//begin
//  try
//    R := 0;
//    ImpStrList := TStringList.Create;
//    GetImpStrListFromFile('TXF File', 'txf', '');
//    if ImpStrList.Count < 1 then begin
//      ImpStrList.Destroy;
//      sm('No records in TXF file');
//      exit;
//    end; // if Count < 1
//    msgTxt := '';
//    for i := 0 to ImpStrList.Count - 1 do begin
//      line := ImpStrList[i];
//      if copy(line, 1, 1) = 'P' then begin
//        cat := ImpStrList[i - 3];
//        od := ImpStrList[i + 1];
//        delete(od, 1, 1);
//        cd := ImpStrList[i + 2];
//        delete(cd, 1, 1);
//        // skip long term trades
//        if TTLDateUtils.MoreThanOneYearBetween(xStrToDate(od), xStrToDate(cd)) then
//          Continue;
//        cost := ImpStrList[i + 3];
//        sales := ImpStrList[i + 4];
//        delete(line, 1, 1);
//        msgTxt := msgTxt + line + TAB;
//        msgTxt := msgTxt + od + TAB;
//        msgTxt := msgTxt + cd + TAB;
//        delete(sales, 1, 1);
//        msgTxt := msgTxt + sales + TAB;
//        delete(cost, 1, 1);
//        msgTxt := msgTxt + cost + TAB;
//        prof := format('%1.2f', [StrToFloat(sales, Settings.UserFmt) - StrToFloat(cost,
//              Settings.UserFmt)], Settings.UserFmt);
//        msgTxt := msgTxt + prof + cr;
//        // add an extra line for wash sale
//        if cat = 'N682' then
//          msgTxt := msgTxt + cr;
//        inc(R);
//        Continue;
//      end; // if 1st char = 'P'
//    end; // for i loop
//    clipBoard.astext := msgTxt;
//    sm(IntToStr(R) + ' records copied OK from TXF file');
//  finally
//    //
//  end;
//end; // readTXF


procedure fixImpTradesOutOfOrder(R : integer);
var
  i, j : integer;
  Sort : TTradeArray;
begin
  try
    // fix trades out of order
    setLength(Sort, R + 1);
    j := 0;
    // put all open shorts first
    for i := 1 to R do begin
      with ImpTrades[i] do begin
        if (oc = 'O') and (ls = 'S') then begin
          inc(j);
          Sort[j] := ImpTrades[i];
        end; // if
      end; // with
    end; // for
    // put all close shorts next
    for i := 1 to R do begin
      with ImpTrades[i] do begin
        if (oc = 'C') and (ls = 'S') or (oc = 'X') and (ls = 'S') then begin
          inc(j);
          Sort[j] := ImpTrades[i];
        end; // if
      end; // with
    end; // for
    // put all open longs next
    for i := 1 to R do begin
      with ImpTrades[i] do begin
        if (oc = 'O') and (ls = 'L') or (oc = 'X') and (ls = 'L') then begin
          inc(j);
          Sort[j] := ImpTrades[i];
        end; // if
      end; // with
    end; // for
    // put all close longs next
    for i := 1 to R do begin
      with ImpTrades[i] do begin
        if (oc = 'C') and (ls = 'L') then begin
          inc(j);
          Sort[j] := ImpTrades[i];
        end; // if
      end; // with
    end; // for
    // reload ImpTrades array
    ImpTrades := nil;
    Finalize(ImpTrades);
    setLength(ImpTrades, R + 1);
    for i := 1 to R do begin
      with ImpTrades[i] do begin
        ImpTrades[i] := Sort[i];
      end; // with
    end; // for
    Sort := nil;
  finally
    //
  end;
end; // fixImpTradesOutOfOrder


    // ------------------------------------------
    // Top-Level Import Routines (and support)
    // ------------------------------------------

// ----------------------------------
procedure noRecsImportedMsg;
begin
  if ImpBaseline then
    mDlg('No trade records to import' + cr + cr //
        + ' Please retry the import making sure to follow the import instructions.' + cr + cr //
        + ' If you confirm you did not have trades during this date range, you can click' + cr //
        + ' the "Next" button in the lower right corner to proceed to the next step.' + cr, //
      mtInformation, [mbOK], 0)
  else
    mDlg('No trade records to import', mtInformation, [mbOK], 0);
  setLength(ImpTrades, 0);
end;

// ----------------------------------
function TradeBeyondEndDate(DT : TDate): boolean;
begin
  result := false;
  // test for import date limitation
  // 2017-02-09 MB - allow importing up to Oct. 16th of the next year (extension deadline)
  if (DT > xStrToDate('10/16/' + NextTaxYear, Settings.InternalFmt)) then begin
    msgImp := 'Cannot import trades past 10/16/' + NextTaxYear + ' in a ' + TaxYear + ' file.';
    result := true;
  end;
end;

// ----------------------------------
procedure HandleMiniOptions(var myTrade : TTrade);
var
  stkTick : string;
begin
  // mini options - underlying stock ticker end with a "7"
  if (pos('OPT', myTrade.prf)= 1) then begin
    stkTick := copy(myTrade.tk, 1, pos(' ', myTrade.tk)- 1);
    if (rightStr(stkTick, 1)= '7') then begin
      // remove 7 from underlying stock ticker
      delete(myTrade.tk, pos('7', myTrade.tk), 1);
      // change type/mult
      myTrade.prf := 'OPT-10';
    end;
  end;
end;

// ----------------------------------
function CheckRecordLimit : boolean;
begin
  result := false;
  if (length(Settings.RecLimit) > 0) //
    and (TradeLogFile.Count >= strToInt(Settings.RecLimit)) then begin
    mDlg(Settings.TLVer + ' limited to ' + Settings.RecLimit + ' records' + cr + cr //
        + 'You have reached the record limit for your license. Import cannot continue!' + cr //
        + 'Please upgrade to a higher record limit to import additional records.', //
      mtWarning, [mbOK], 0);
    result := true;
  end;
end;

//// ----------------------------------
//function ImportOFXData : integer;
//var
//  TradeList : TTradeList;
//  Trade : TTLTrade;
//  errMsg, errLogTxt, errAdvice : string;
//  RecCnt : integer;
//begin
//  // ----------------------------------
//  // Check for OFX errors
//  if OFXImport.ErrorOccurred then begin
//    if (DEBUG_MODE > 1) and SuperUser then begin
//      TMessageDialog.Execute(msgImp, TradeLogFile.CurrentAccount.FileImportFormat //
//          + ' OFX Error Message: ' + cr + cr + OFXImport.ErrorMessage, '',
//        'OFX Login Error', mtError);
//    end;
//    // --------------------------------
//    if (TradeLogFile.CurrentAccount.FileImportFormat = 'Charles Schwab') // 2019-12-05 MB
//      and (pos('User needs to review security settings', OFXImport.ErrorMessage) = 1) then begin
//      msgImp := 'It appears you have not enabled 3rd party access.';
//      errAdvice := 'Please enable through Schwab and try again.';
//    end
//    else if (pos('password', lowercase(OFXImport.ErrorMessage))> 0) //
//      or (pos('username', lowercase(OFXImport.ErrorMessage))> 0) //
//      or (pos('user name', lowercase(OFXImport.ErrorMessage))> 0) then begin
//      msgImp := 'INVALID USERNAME OR PASSWORD';
//      errAdvice := 'Please correct the problem and try again';
//    end
//    else if pos('account', lowercase(OFXImport.ErrorMessage))> 0 then begin
//      msgImp := 'INVALID ACCOUNT NUMBER';
//      errAdvice := 'Please correct the problem and try again';
//    end
//    else begin
//      msgImp := 'GENERAL OFX LOGIN ERROR';
//      errAdvice := 'Please contact your BROKER for assistance.';
//    end;
//    // --------------------------------
//    // reformat ErrorMessage to 60 chars wide
//    errMsg := wrapText(OFXImport.ErrorMessage, 60);
//    AssignFile(ErrLog, Settings.DataDir + '\logs\error.log');
//    rewrite(ErrLog);
//    errLogTxt := uppercase(TradeLogFile.CurrentAccount.FileImportFormat) //
//      + ' OFX ERROR ' + msgImp + '; Detailed Message: ' + '"' + errMsg + '"';
//    try
//      write(ErrLog, errLogTxt);
//      errLogTxt := '';
//    finally
//      CloseFile(ErrLog);
//    end;
//    // --------------------------------
//    msgImp := uppercase(TradeLogFile.CurrentAccount.FileImportFormat) + ' OFX ERROR ' + cr //
//      + cr //
//      + msgImp + cr + errAdvice + cr + cr + 'Detailed Message:' + cr + '"' + errMsg + '"';
//    mDlg(msgImp, mtError,[mbOK], 0);
//    exit(-1);
//  end; // if ErrorOccurred
//  // ----------------------------------
//  // Save to disk file
//  OFXImport.SaveToFile(Settings.ImportDir + '\' //
//      + TradeLogFile.CurrentAccount.FileImportFormat + '_' //
//      + FormatDateTime('yyyyMMdd', OFXDateStart) + '_' //
//      + FormatDateTime('yyyyMMdd', OFXDateEnd) + '.ofx');
//  // ----------------------------------
//  result := 0;
//  TradeList := OFXImport.GetTradeList;
//  if TradeList.Count = 0 then
//    exit(0);
//  try
//    RecCnt := TradeList.Count;
//    // added 2014-07-11 to support OFX for baseline
//    if ImpBaseline then
//      setLength(ImpTrades, TradeList.Count + 1);
//    for Trade in TradeList do begin
//      // If a broker provides data just outside of what was requested, ignore it.
//      // Also, if the user tries to get data beyond the extension deadline for a
//      // given tax Year (eg. Past 10/16/NextTaxYear) - stop that as well
//      if (Trade.Date < OFXDateStart) //
//        or (Trade.Date > OFXDateEnd) //
//        or TradeBeyondEndDate(Trade.Date) then begin
//        Continue;
//        Trade.Free;
//      end;
//      if (pos('FUT', Trade.TypeMult) = 1) //
//        and (not Settings.MTMVersion or taxidVer) then
//        FutureWarning := true;
//      // do not import fidelity cash transactions
//      if (Trade.Ticker = 'FCASH') then
//        Continue;
//      // fix for OPT-0
//      if (Trade.TypeMult = 'OPT-0') then
//        Trade.TypeMult := 'OPT-100';
//      inc(result);
//      // added to support OFX for baseline
//      if ImpBaseline then begin
//        Trade.calcAmount; // 2015-04-04 MB - needed so Schwab commission is correct
//        ImpTrades[result].it := Trade.ID;
//        ImpTrades[result].DT := DateToStr(Trade.Date, Settings.UserFmt);
//        ImpTrades[result].tm := Trade.Time;
//        ImpTrades[result].oc := Trade.oc;
//        ImpTrades[result].ls := Trade.ls;
//        ImpTrades[result].tk := Trade.Ticker;
//        ImpTrades[result].sh := Trade.Shares;
//        ImpTrades[result].pr := Trade.Price;
//        ImpTrades[result].prf := Trade.TypeMult;
//        ImpTrades[result].cm := Trade.Commission;
//        ImpTrades[result].opTk := Trade.OptionTicker;
//        ImpTrades[result].am := Trade.Amount;
//        HandleMiniOptions(ImpTrades[result]);
//      end
//      else
//        TradeLogFile.AddTrade(Trade);
//      // get list of imported tickers
//      if (impTicksList.IndexOf(Trade.Ticker) = -1) then
//        impTicksList.Add(Trade.Ticker);
//      if CheckRecordLimit then
//        break;
//    end;
//  finally
//    TradeList.Free;
//  end;
//end;


                    // --------------------------
                    // Import Manual Entry Data
                    // --------------------------

function ReadManualEntry(bFromGrid : boolean = false): integer;
var
  i, X, RecCnt, ErrorCnt : integer;
  Trade : TTLTrade;
  FutureWarning, bFileSaved : boolean;
  msgText, msgErr : string;
  ImportReadMethods : TImportReadMethods;
  // ----------------------------------
  procedure noRecsImportedMsg;
  begin
    if ImpBaseline then
      mDlg('No trade records to import' + cr + cr +
          ' Please retry the import making sure to follow the import instructions.' + cr + cr //
          + ' If you confirm you did not have trades during this date range, you can click' + cr //
          + ' the "Next" button in the lower right corner to proceed to the next step.' + cr, //
        mtInformation, [mbOK], 0)
    else
      mDlg('No trade records to import', mtInformation, [mbOK], 0);
    setLength(ImpTrades, 0);
  end;
  // ----------------------------------
  function CheckRecordLimit : boolean;
  begin
    result := false;
    if (length(Settings.RecLimit) > 0) and (TradeLogFile.Count >= strToInt(Settings.RecLimit)) then
    begin
      mDlg(Settings.TLVer + ' limited to ' + Settings.RecLimit + ' records' + cr + cr +
          'You have reached the record limit for your license. Import cannot continue!' + cr +
          'Please upgrade to a higher record limit to import additional records.', mtWarning,
        [mbOK], 0);
      result := true;
    end;
  end;
  // ----------------------------------
  function TradeBeyondEndDate(DT : TDate): boolean;
  begin
    result := false;
    // test for import date limitation
    // 2017-02-09 MB - allow importing up to Oct. 16th of the next year (extension deadline)
    if (DT > xStrToDate('10/16/' + NextTaxYear, Settings.InternalFmt)) then begin
      msgText := 'Cannot import trades past 10/16/' + NextTaxYear + ' in a ' + TaxYear + ' file.';
      result := true;
    end;
  end;
// ----------------------------------
begin // ReadManualEntry
  try
    impTicksList := TStringList.Create;
    ImportReadMethods := TImportReadMethods.Create;
    changedFuturesList := TList.Create;
    Etrade1099 := false;
    TDWyearend := false;
    TDWmonthly := false;
    ImportHasCusips := false;
    FutureWarning := false;
    bFileSaved := false;
//    OFX := false;
//    OFXImport := nil;
//    OFXFile := '';
    glNumCancelledTrades := 0;
    with frmMain do begin
      setLength(ImpTrades, 0);
      DataConvErrRec := '';
      CorrectedTrades := 0;
      NumConverted := 0;
      TradeLogFile.TradeNums.Importing := true;
      screen.Cursor := crHourglass;
      // -----------------------------+
      // Import Trades                |
      // -----------------------------+
      TLDisable;
      try
        try
          RecCnt := ReadExcel(bFromGrid); // <---- 2021-05-02 RJ - grid or clipboard
        except
          on e : Exception do begin
            if cancelURL then begin
              mDlg('Import Cancelled by User', mtInformation, [mbOK], 0);
              if ImpBaseline then
                impCancelled := true;
              cancelURL := false;
            end
            else
              mDlg('Import Failed with the following message: ' //
                  + e.Message, mtWarning, [mbOK], 0);
            exit;
          end;
        end; // try...except
      finally
        TLEnable;
      end; // try...finally
    end; // with
    // ----------------------------------------
    if cancelURL then begin
      mDlg('Import Cancelled', mtInformation, [mbOK], 0);
      if ImpBaseline then
        impCancelled := true;
      cancelURL := false;
      exit;
    end;
    if RecCnt < 1 then begin
      StatBar('off');
      if webgetTimedOut then begin
        mDlg('BrokerConnect Timed Out' + cr //
          + 'Please try again later.', mtInformation, [mbOK], 0);
        webgetTimedOut := false;
      end
      else
        noRecsImportedMsg;
      exit;
    end;
    StatBar('Trade History Download Complete');
    screen.Cursor := crHourglass;
    X := TradeLogFile.Count;
    msgTxt := '';
    try
      ErrorCnt := 0;
      // Add all imported Trades to TradeLogFile
      for i := 1 to high(ImpTrades) do begin
        // Sometimes an invalid line can come from the import routine
        // so if it has NO ID, and NO Date, then skip it.
        if (ImpTrades[i].it = 0) and (length(ImpTrades[i].DT) = 0) then
          Continue;
        // delete corrected trades
        if (ImpTrades[i].ls = '') and (ImpTrades[i].oc = '') then begin
          inc(CorrectedTrades);
          Continue;
        end;
        // change all ticker to caps
        ImpTrades[i].tk := uppercase(ImpTrades[i].tk);
        HandleMiniOptions(ImpTrades[i]);
        ImpTrades[i].it := i + X;
        ImpTrades[i].br := IntToStr(TradeLogFile.CurrentBrokerID);
        if not ImpBaseline then begin
          Trade := TTLTrade.Create(ImpTrades[i]);
          if TradeBeyondEndDate(Trade.Date) then begin
            Trade.Free;
            Continue;
          end;
          if (pos('FUT', Trade.TypeMult) = 1) and not Settings.MTMVersion then
            FutureWarning := true;
            // *****add imported trades to TradeLogFile******
          TradeLogFile.AddTrade(Trade);
          if CheckRecordLimit then
            break;
            // get list of imported tickers
          if (impTicksList.IndexOf(ImpTrades[i].tk) = -1) then
            impTicksList.Add(ImpTrades[i].tk)
        end; // <-- if not ImpBaseline
      end; // <-- for loop
    except
      on e : Exception do begin
        msgErr := msgErr + 'Error: ' + e.Message;
        inc(ErrorCnt);
      end;
    end;
    if msgText <> '' then
      mDlg(msgText, mtWarning, [mbOK], 0);
    msgText := '';
    if ErrorCnt > 0 then
      mDlg('Warning: ' + IntToStr(i) + ' trade record(s) could not be imported' + cr //
          + cr + msgErr, mtError, [mbOK], 0);
    // ----------------------------------------
    // if NOT importing baseline positions
    if not isFormOpen('panelBaseline') then begin
      // This must be after the tradelog file is updated so move it as necessary.
      changeFutMult(TradeLogFile.TradeList);
      StatBar('Matching Downloaded Data');
      // only match imported tickers
      if impTicksList.Count > 0 then // 2017-05-12 MB - skip if nothing to match
        TradeLogFile.Match(impTicksList); // 2016-06-27 MB - removed ForceMatch
      if TradeLogFile.Count > 1 then
        TradeLogFile.Reorganize;
      // check for data coversion errors
      CheckForDataConvertErr;
      // update grid
      TradeRecordsSource.DataChanged;
      bFileSaved := SaveTradeLogFile('Excel Import', false, true, RecCnt);
      // change company names to stock tickers
      if bFileSaved then
        ChangeStockDescrtoTickerSymbol(true);
      // No brokers currently use this                `
      if ImportHasCusips and (TradeLogFile.Count > 0) then
        changeCusips;
    end; // <-- if NOT importing baseline positions
//    importingOFX := false;
//    OFX := false;
    ETProSWS := false;
    etradeHist := false;
    // check for new Future Multipliers, Strategies, etc. not in Global lists
    if not isFormOpen('panelBaseline') then
      CheckForNewData;
  finally
    result := RecCnt;
    impTicksList.Free;
    ImportReadMethods.Free;
    StatBar('off');
    screen.Cursor := crDefault;
    TradeLogFile.TradeNums.Importing := false;
    frmMain.btnImport.Enabled := not isAllBrokersSelected; // in case of error
  end;
end; // ReadManualEntry


                    // --------------------------
                    // New BrokerConnect
                    // --------------------------

// ------------------------------------
// Save JSON data
// ------------------------------------
procedure SaveJSONdata(sData, sFileType : string);
var
  sFile, sTmp, ext, localFileName : string;
  localFile : textfile;
begin
  try
    // get a unique name for the import backup file
    sFile := TradeLogFile.CurrentAccount.FileImportFormat;
    delete(sFile, pos('*', sFile), 1);
    delete(sFile, pos(',', sFile), 1);
    ext := TradeLogFile.CurrentAccount.importFilter.ImportFileExtension;
    localFileName := Settings.ImportDir + '\' + sFile + '_' //
      + FormatDateTime('yyyymmdd-hhmmss', now)+ '.' + sFileType + '.txt'; //
    // --- Open the file ----
    AssignFile(localFile, localFileName);
    rewrite(localFile);
    // --- finish -----------
    write(localFile, sData);
    CloseFile(localFile);
  except
    on e : Exception do begin
      if SuperUser then begin
        mDlg('Unable to save JSON data to file' + cr //
          + localFileName + cr //
          + 'Error Message: ' + e.Message + cr //
          + '(click OK to continue.)', mtError, [mbOK], 0);
      end; // if
    end; // on E
  end; // try...except
end; // SaveJSONdata


// ------------------------------------
// Save data as CSV
// ------------------------------------
procedure saveImportData(sDate1, sDate2 : string);
var
  i : integer;
  sFile, ext, localFileName, line : string;
  localFile : textfile;
begin
  try
    // get a unique name for the import backup file
    sFile := TradeLogFile.CurrentAccount.FileImportFormat;
    delete(sFile, pos('*', sFile), 1);
    delete(sFile, pos(',', sFile), 1);
    ext := TradeLogFile.CurrentAccount.importFilter.ImportFileExtension;
    localFileName := Settings.ImportDir + '\' + sFile + '_' + sDate1 + '_' + sDate2 + ext;
    AssignFile(localFile, localFileName);
    rewrite(localFile);
    for i := 0 to ImpStrList.Count - 1 do begin
      line := ImpStrList[i];
      writeln(localFile, line);
    end;
    CloseFile(localFile);
  finally
    // so
  end;
end;


// takes a date in mm/dd/yyyy format and converts
// it to yyyy-mm-dd format to send to Yodlee API.
function FormatYodleeDate(dtArg : TDate): string;
var
  sDt : string;
begin
  sDt := YYYYMMDD(DateToStr(dtArg));
  result := copy(sDt, 1, 4) + '-' + copy(sDt, 5, 2) + '-' + copy(sDt, 7, 2);
end;

// takes an option ticker from Yodless and parses
// it to create a standard TradeLog option ticker
function FormatYodleeOption(sTk, desc : string): string;
var
  l, m : integer;
  junk, opStrike, opExpDt, opMo, opDy, opYr, opCP, opTk : string;
  nStrike : double;
begin
  result := sTk; // returns unchanged if error occurs
  junk := trim(sTk);
  m := length(junk);
  if pos(' ', junk) = 0 then begin // parse without spaces
    // ticker format is [tk]yymmdd?$$$$$ccc
    // or [tk]yymmdd?$$[.c]
    // and should be parsed from right to left
    // looking for 'C' or 'P' first
    // where underlying ticker can be 3 or 4 chars
    // expiration date is in yymmdd format
    // c/p = call/put
    // and strike price assumes 3 decimal places
    opStrike := rightStr(junk, 9);
    if (pos('C', opStrike) > 0) then
      opStrike := parseLast(opStrike, 'C')
    else if (pos('P', opStrike) > 0) then
      opStrike := parseLast(opStrike, 'P')
    else
      exit; // failed
    try
      l := length(opStrike);
      delete(junk, (m - l + 1), l);
      if (l > 4) and (pos('.', opStrike)= 0) then begin
        nStrike := StrToFloat(opStrike)/ 1000;
        opStrike := floattostrf(nStrike, ffFixed, 5, 3);
      end;
      opStrike := delTrailingZeros(opStrike);
    except
      exit;
    end;
    opCP := rightStr(junk, 1);
    if opCP = 'C' then
      opCP := 'CALL'
    else if opCP = 'P' then
      opCP := 'PUT'
    else
      exit;
    opExpDt := leftStr(rightStr(junk, 7), 6);
  // opExpDt := replaceStr(opExpDt,'-','/');
    if pos('/', opExpDt) > 1 then begin // assumes m/d/yy variation
      opMo := parsefirst(opExpDt, '/');
      opDy := parsefirst(opExpDt, '/');
      opYr := opExpDt;
      if isdate(opDy + '/' + opMo + '/' + opYr) then
        opExpDt := opDy + getExpMo(opMo) + opYr
      else
        exit; // not a valid exp date
    end
    else begin // assumes yymmdd
      opYr := copy(opExpDt, 1, 2);
      opMo := copy(opExpDt, 3, 2);
      opDy := copy(opExpDt, 5, 2);
      opExpDt := opDy + getExpMo(opMo) + opYr;
    end;
    opTk := leftStr(junk, length(junk)- 7);
    // EX: "MSFT 14DEC12 15 CALL"
  end
  else begin // parse with spaces
    // EX: tastyworks        RH 03/26/21 PUT 440.00
    opStrike := parseLast(junk, ' ');
    opStrike := delTrailingZeros(opStrike);
    opCP := parseLast(junk, ' ');
    if opCP = 'C' then
      opCP := 'CALL'
    else if opCP = 'P' then
      opCP := 'PUT';
    opExpDt := parseLast(junk, ' ');
  // opExpDt := replaceStr(opExpDt,'-','/');
// if pos('/',opExpDt) > 1 then begin // assumes m/d/yy variation
    opMo := parsefirst(opExpDt, '/');
    opDy := parsefirst(opExpDt, '/');
    opYr := opExpDt;
// end
// else begin // assumes yymmdd
// opYr := copy(opExpDt,1,2);
// opMo := copy(opExpDt,3,2);
// opDy := copy(opExpDt,5,2);
// end;
    opExpDt := opDy + getExpMo(opMo) + opYr;
    opTk := junk;
  end;
  result := opTk + ' ' + opExpDt + ' ' + opStrike + ' ' + opCP;
end;

      // -----------------------------+
      // Import via Passiv/Snaptrade  |
      // -----------------------------+

function ReadPassiv(): integer;
var
  i, k, R, numFields, X, nErr : integer;
  iDt, iOC, iDes, iTk, iShr, iPr, iCm, iAmt, iTyp,
    iOpTk, iUnderly, iOpStk, iOpExp, iOpCP, iMini, iOBS : integer;
  ImpDate, ImpTime, oc, desc, tk, ShStr, PrStr, CmStr, AmtStr, prfStr,
    opTick, opStrike, opExpDt, opCP, opMini, opYr, opMo, opDy : string;
  sFromDate, sToDate, sDt1, sDt2, sLoginName, sBroker, sBrokerId, sAcctId,
    line, junk, s, ls, cp, bs, sInsId, sBadBS, sOBS : string;
  contracts, bFoundHeader : boolean;
  Commis, nTmp, mult : double;
  fieldLst : TStrings;
  tmpDT : TDateTime;
  // ----------------------------------
  procedure SetFieldNumbers();
  var
    j : integer;
  begin // find/map Passiv fields
    k := 0;
    for j := 0 to (fieldLst.Count - 1) do begin
      if (fieldLst[j] = 'DATE') then begin
        iDt := j;
        k := k or 1; // required field
      end
      else if (fieldLst[j] = 'OCLS') then begin // for 'BOUGHT' or 'SOLD'
        iOC := j;
        k := k or 2;
      end
      else if (fieldLst[j] = 'META') then begin
        iDes := j;
        k := k or 4;
      end
      else if (fieldLst[j] = 'TICK') then begin
        iTk := j;
        k := k or 8;
      end
      else if (fieldLst[j] = 'QTY') then begin
        iShr := j;
        k := k or 16;
      end
      else if (fieldLst[j] = 'COMM') then begin
        iCm := j;
        k := k or 32;
      end
      else if (fieldLst[j] = 'PRC') then begin
        iPr := j;
        k := k or 64;
      end
      else if (fieldLst[j] = 'AMT') then begin
        iAmt := j;
        k := k or 128;
      end
      else if (fieldLst[j] = 'TYPE') then begin
        iTyp := j;
        k := k or 256;
      end
      else if (fieldLst[j] = 'OPTICK') then begin
        iOpTk := j;
        k := k or 512;
      end
      else if (fieldLst[j] = 'STRIKE') then begin
        iOpStk := j;
        k := k or 1024;
      end
      else if (fieldLst[j] = 'EXPDT') then begin
        iOpExp := j;
        k := k or 2048;
      end
      else if (fieldLst[j] = 'CP') then begin
        iOpCP := j;
        k := k or 4096;
      end
      else if (fieldLst[j] = 'MINI') then begin
        iMini := j;
        k := k or 8192;
      end
      else if (fieldLst[j] = 'OBS') then begin
        iOBS := j;
        k := k or 16384;
      end
      else if (fieldLst[j] = 'UNDERLYING') then begin
        iUnderly := j;
      end;
    end;
  end;
  // ----------------------------------
  procedure DecodeOCLS;
  begin
    if trim(sOBS) = '' then
      bs := replacestr(bs, '_', ' ') // 2024-07-05 MB - treat underscore same as space
    else
      bs := replacestr(sOBS, '_', ' '); // for options
    oc := 'E'; // assume error if not found
    ls := 'L';
    if (bs = 'BUY') or (bs = 'BOUGHT') then begin
      if (pos('SHORT CALL', desc)> 1) //
      or (pos('BOUGHT TO COVER', desc)> 1) //
      then begin
        oc := 'C';
        ls := 'S';
      end
      else begin
        oc := 'O';
        ls := 'L';
      end;
    end
    else if (bs = 'SELL') or (bs = 'SOLD') then begin
      if (pos('SHORT CALL', desc)> 1) //
      or (pos('SOLD SHORT ', desc)> 1) //
      then begin
        oc := 'O';
        ls := 'S';
      end
      else begin
        oc := 'C';
        ls := 'L';
      end;
    end
    else if (bs = 'BUY_TO_OPEN') or (bs = 'BUY TO OPEN') //
    or (bs = 'BOUGHT TO OPEN') then begin
      oc := 'O';
      ls := 'L';
    end
    else if (bs = 'SELL TO CLOSE') or (bs = 'SOLD TO CLOSE') //
    then begin
      oc := 'C';
      ls := 'L';
    end
    else if (bs = 'DIVIDEND_REINVESTMENT') //
    or (bs = 'REINVEST') then begin
      oc := 'O';
      ls := 'L';
    end
    else if (bs = 'SELL TO OPEN') or (bs = 'SHORT SELL') then begin
      oc := 'O';
      ls := 'S';
    end
    else if (bs = 'BUY TO CLOSE') or (bs = 'BOUGHT TO COVER') then begin
      oc := 'C';
      ls := 'S';
    end
    else begin
      if pos(bs, sBadBS) < 1 then
        sBadBS := sBadBS + CRLF + bs;
      oc := 'E';
      ls := 'L';
    end;
    // --- description may override ---
    if (pos('BOUGHT CLOSING TRANSACTION', desc)> 1) then begin
      oc := 'C';
      ls := 'S';
    end
    else if (pos('SOLD OPENING TRANSACTION', desc)> 1) then begin
      oc := 'O';
      ls := 'S';
    end
    else if (pos(' LONG ', desc)> 1) then begin
      if (ls <> 'L') then begin
        nErr := nErr + 1;
        if (nErr < 2) then
          sm('bs = ' + bs + CRLF //
            + 'ls = ' + ls + CRLF //
            + 'desc = ' + desc);
      end;
    end
    else if (pos('SOLD SHORT ', desc)> 1) //
    or (pos('BOUGHT TO COVER', desc)> 1) //
    then begin
      if (ls <> 'S') then begin
        nErr := nErr + 1;
        if (nErr < 2) then begin
          sm('bs = ' + bs + CRLF //
            + 'ls = ' + ls + CRLF //
            + 'desc = ' + desc);
        end;
      end;
    end;
  end;
  // ------------------------
  procedure DownloadTransData;
  var
    dt1, dt2, dtMax : TDate;
    nDtStep, nBefore, nDnload : integer;
    bFlag : boolean;
    function InitDateStepSize: integer;
    begin
      if v2RecLimit <= 1500 then
        result := 256 // investor
      else if v2RecLimit <= 5000 then
        result := 128 // trader
      else if v2RecLimit <= 15000 then
        result := 32 // trader
      else if v2RecLimit <= 45000 then
        result := 16 // trader
      else
        result := 8; // elite
    end;
  begin
    // --- INIT -------------
    bFlag := true;
    nDtStep := InitDateStepSize; // based on product level
    nBefore := 0;
    nDnload := 0;
    dt1 := OFXDateStart;
    dt2 := IncDay(dt1, nDtStep);
    dtMax := OFXDateEnd;
    if (dt2 > dtMax) then dt2 := dtMax;
    // --- LOOP -------------
    while (dt1 <= dtMax) do begin
      sDt1 := FormatYodleeDate(dt1); // , settings.InternalFmt);
      sDt2 := FormatYodleeDate(dt2); // , settings.InternalFmt);
      s := ''; // reset
      nBefore := ImpStrList.Count;
      try
        if SuperUser and (DEBUG_MODE > 2) then begin
          s := GetPassivRawTrans(v2ClientToken, sLoginName, sDt1, sDt2, sBrokerId, sAcctId);
          if s <> '' then begin
            junk := replacestr(s, '[', '[' + CRLF);
            junk := replacestr(junk, ']', CRLF + ']');
          end;
          SaveJSONdata(junk, 'RAW');
        end;
        s := GetPassivTrans(v2ClientToken, sLoginName, sDt1, sDt2, sBrokerId, sAcctId);
        if SuperUser and (DEBUG_MODE > 2) then begin
          if s <> '' then begin
            junk := replacestr(s, '[', '[' + CRLF);
            junk := replacestr(junk, ']', CRLF + ']');
          end;
          SaveJSONdata(junk, 'JSON');
        end;
      except
        on e : Exception do begin
          sm('ERROR:' + CRLF + e.ClassName + ': ' + e.Message);
          exit;
        end;
      end; // try..except
      // Load into StrList
      if (pos('ERROR', s) = 1) then
        sm(s)
      else if (s = '') then
        showmessage('There is no BrokerConnect data to import.')
      else begin // = 'OK'
        ReadPassivIntoStrList(s, bFlag, sAcctId);
        bFlag := false; // 1st time only
        nDnload := ImpStrList.Count - nBefore;
        if (nDtStep > 2)
        and (nDnload > 5000) then begin
          nDtStep := nDtStep div 2;
        end
        else if (nDtStep < 256)
        and (nDnload < 3000) then begin
          nDtStep := nDtStep * 2;
        end;
      end;
      nBefore := ImpStrList.Count;
      dt1 := IncDay(dt2, 1);
      dt2 := IncDay(dt1, nDtStep);
      if (dt2 > dtMax) then dt2 := dtMax;
    end; // while dt1 <= dtMax
  end;
// ----------------------------------
begin
  R := 0;
  sBadBS := 'unknown buy/sell:';
  bFoundHeader := false;
  DataConvErrRec := '';
  DataConvErrStr := '';
  GetImpDateLast;
  sBroker := TradeLogFile.CurrentAccount.FileImportFormat;
  // --------------------------------
  ImpStrList := TStringList.Create;
  // --- get AcctId ---------
  sAcctId := TradeLogFile.CurrentAccount.PlaidAcctId;
  if (sAcctId = '') then begin
    sm('This account has not been linked yet.' + cr //
      + 'Please use Import Setup.');
    exit;
  end;
  sFromDate := FormatYodleeDate(OFXDateStart);
  sToDate := FormatYodleeDate(OFXDateEnd);
  // --- get Name, BrokerId -----------
  sLoginName := TradeLogFile.CurrentAccount.OFXUserName;
  sBrokerId := GetPassivBrokerId(v2ClientToken, sLoginName, sBroker);
  // --- get Trans --------------------
  sInsId := TradeLogFile.CurrentAccount.importFilter.InstitutionId;
  StatBar('Downloading from broker, please wait.');
  // --- LOOP -------------
  DownloadTransData;
  if ImpStrList.Count < 1 then begin
    result := 0;
    exit;
  end;
  if SuperUser then saveImportData(sFromDate, sToDate);
  // ----------------------
  ImpTrades := nil;
  setLength(ImpTrades, ImpStrList.Count); // max size
  X := TradeLogFile.Count; // highest trade# (not used?)
  DataConvErrCnt := 0; // reset
  // --- process each trade ---------
  for i := 0 to ImpStrList.Count - 1 do begin
    line := ImpStrList[i];
    line := uppercase(line); // search line for UPPERCASE tokens...
    StatBar('Processing ' + IntToStr(i+1) + ' of ' + IntToStr(ImpStrList.Count));
    // parse all columns into string list
    if line = '' then
      Continue;
    if replacestr(line, ',', '') = '' then begin
      Continue;
    end;
    // parse all columns into string list
    fieldLst := ParseCSV(line, TAB);
    // ------------------------------
    if not bFoundHeader then begin
      if (pos('TICK', line) > 0) //
      and (pos('QTY', line) > 0) //
      and (pos('AMT', line) > 0) //
      then begin
        SetFieldNumbers;
        numFields := fieldLst.Count;
        if SuperUser and (k <> 32767) then
          sm('there appear to be fields missing.');
        bFoundHeader := true; // don't do this anymore
        R := 0; // start now
      end;
      Continue; // don't process anything until we recognize the header
    end;
    if fieldLst.Count > numFields then begin
      DataConvErrRec := DataConvErrRec + line + cr;
      Continue; // record has extra commas!
    end;
    // ------------------------------
    if pos('ERROR', line) > 0 then begin
      sm('The broker reported an error in the data.' + cr //
        + 'Please reduce the date range and try again.');
      result := 0;
      exit;
    end;
    // --- OC/LS ----------
    bs := fieldLst[iOC]; // buy/sell
    desc := fieldLst[iDes]; // description
    sOBS := fieldLst[iOBS]; // option buy-sell indicator
    DecodeOCLS;
    if (oc = 'E') then begin
      Continue; // unrecognized type
    end;
    // --- Date -----------
    ImpDate := fieldLst[iDt];
    if (length(ImpDate) > 10) and (ImpDate[11] = 'T') then begin
      ImpTime := parseLast(ImpDate, 'T');
      if rightStr(ImpTime, 1) = 'Z' then begin // indicates UTC time
        ImpTime := leftStr(ImpTime, length(ImpTime)- 1); // remove z
        ImpTime := leftstr(ImpTime, 8);
        if isTime(ImpTime) then begin
          tmpDT := StrToTime(ImpTime);
          tmpDT := IncHour(tmpDT, -5);
          ImpTime := FormatDateTime('hh:mm:ss', tmpDT);
        end else begin
          sm(ImpTime + ' is not a valid time');
        end;
      end;
    end
    else begin
      ImpTime := '';
    end;
    ImpDate := yyyymmddToUSDate(ImpDate);
    if not isdate(ImpDate) then begin
      sm('bad date in line ' + IntToStr(i));
    end;
    if (pos(':', ImpTime) = 3) //
    and (pos(':', ImpTime, 4) = 6) then begin
      ImpTime := leftStr(ImpTime, 8);
    end;
    if not istime(ImpTime) then begin
      ImpTime := '';
    end;
    // --- check shares ---
    ShStr := trim(fieldLst[iShr]);
    try
      Shares := ABS(StrToFloat(ShStr, Settings.InternalFmt));
      Shares := rndto8(Shares); //
      if ABS(Shares) < NEARZERO then begin
        DataConvErrCnt := DataConvErrCnt + 1;
        if SuperUser and (DataConvErrCnt <= 3) then begin
          sm('Zero shares in line' + CRLF + line);
        end;
        Continue;
      end;
    except
      Continue; // skip trade if shares are zero or non-numeric
    end;
    // --- ticker ---------
    tk := trim(fieldLst[iTk]); // ticker field
    // --- type -----------
    junk := fieldLst[iTyp];
    opTick := trim(fieldLst[iOpTk]);
    if (opTick <> '') then begin
      contracts := true;
      if tk = '' then begin
        tk := fieldLst[iUnderly];
      end;
      // opTick, opStrike, opExpDt, opCP, opMini
      // iOpTk,  iOpStk,  iOpExp,  iOpCP, iMini
      opExpDt := fieldLst[iOpExp]; // YYYY-MM-DD
      opYr := copy(opExpDt, 3, 2);
      opMo := copy(opExpDt, 6, 2);
      opDy := copy(opExpDt, 9, 2);
      opExpDt := opDy + getExpMo(opMo) + opYr;
      opCP := fieldLst[iOpCP];
      opStrike := fieldLst[iOpStk];
      opStrike := delTrailingZeros(opStrike);
      opMini := fieldLst[iMini];
      if (opMini = 'true') then begin
        mult := 10;
        prfStr := 'OPT-10';
      end
      else begin
        mult := 100.0;
        prfStr := 'OPT-100'; // assume mult = 100
      end;
      // ----------------------
      if (tk = '') then begin
        if Developer or (v2UserEmail = DEBUG_EMAIL) then begin
          sm('bad option ticker:' + ' ' + opExpDt + ' ' + opStrike + ' ' + opCP);
        end;
      end; // -----------------------------------------
      tk := tk + ' ' + opExpDt + ' ' + opStrike + ' ' + opCP;
    end
    else begin
      contracts := false;
      mult := 1.0;
      if fieldLst[iTyp] = 'CRYPTOCURRENCY' then
        prfStr := 'DCY-1'
      else if fieldLst[iTyp] = 'ETF' then
        prfStr := 'ETF-1'
      else if fieldLst[iTyp] = '' then
        Continue // unknown type
      else
        prfStr := 'STK-1'; // assume mult = 1
      // end if block
      tk := trim(fieldLst[iTk]);
      opTick := ''; // not an option
    end;
    // --- cannot use w/o ticker symbol!
    if (tk = '') then begin
      if Developer then sm('blank ticker:' + crlf + line);
      continue;
    end;
    // --- amt, shr, pr, com ----
    AmtStr := trim(fieldLst[iAmt]);
    ShStr := trim(fieldLst[iShr]);
    PrStr := trim(fieldLst[iPr]);
    CmStr := trim(fieldLst[iCm]);
    try
      Shares := ABS(StrToFloat(ShStr, Settings.InternalFmt));
      if ABS(Shares) <= NEARZERO then begin
        if Developer then sm('zero shares: ' + CRLF + line);
        continue;
      end;
      // --- good record ----
      Amt := ABS(StrToFloat(AmtStr, Settings.InternalFmt));
      Price := ABS(StrToFloat(PrStr, Settings.InternalFmt));
      // --- commission and/or price ----------
      if CmStr = '' then
        Commis := 0
      else
        Commis := StrToFloat(CmStr, Settings.InternalFmt);
      // end if block
      // ------------------
      Shares := rndTo6(Shares); // 2024-02-08 MB - Temporary solution
      Amt := rndTo6(Amt);
      Price := rndTo6(Price);
      // ------------------
      if ((oc = 'O') and (ls = 'L')) //
      or ((oc = 'C') and (ls = 'S')) then begin // BUY
        nTmp := Commis;
        Commis := Amt - (Shares * Price * mult);
        if ABS(Amt - (Price*Shares*mult + Commis)) >= 0.005 then begin
          if SuperUser then sm('Error calculating commission in line' + CRLF + line);
        end;
      end
      else if ((oc = 'C') and (ls = 'L')) //
      or ((oc = 'O') and (ls = 'S')) then begin // SELL
        nTmp := Commis;
        Commis := (Shares * Price * mult) - Amt;
        if ABS(Amt - (Price*Shares*mult - Commis)) >= 0.005 then begin
          if SuperUser then sm('Error calculating commission in line' + CRLF + line);
        end;
      end;
      Commis := rndto8(Commis); // 2024-02-28 MB
      // ------------------
      inc(R); // finally count it
      ImpTrades[R].it := TradeLogFile.Count + R;
      ImpTrades[R].DT := ImpDate;
      ImpTrades[R].tm := ImpTime;
      ImpTrades[R].oc := oc;
      ImpTrades[R].ls := ls;
      ImpTrades[R].tk := tk;
      ImpTrades[R].sh := ABS(Shares);
      ImpTrades[R].pr := Price;
      ImpTrades[R].prf := prfStr; // type-mult
      ImpTrades[R].cm := rndto2(Commis);
      ImpTrades[R].opTk := opTick;
      ImpTrades[R].am := Amt;
      // if Developer then ImpTrades[R].no := CmStr;
    except
      DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr + cr;
      Continue;
    end;
  end; // --- for loop ------------------------
  ImpStrList.Destroy; // memory!
  // --- check if trades in reverse order -------
  if (R > 1) then begin
    if xStrToDate(ImpTrades[1].DT) > xStrToDate(ImpTrades[R].DT) then begin
      ReverseImpTradesDate(R);
    end;
  end;
  if (R > 0) then begin // only if something to do
    // --- see if out of order, same date ---------
    SortImpByDateOC(1, R);
    // // --- see if any cancels exist ---------------
    // if cancels then begin
    //   for i := 1 to R do begin
    //     for j := 1 to R do begin
    //       if (ImpTrades[i].oc = 'X') //
    //       and (ImpTrades[i].tk = ImpTrades[j].tk) //
    //       and (rndTo5(ImpTrades[i].sh) = rndTo5(ImpTrades[j].sh)) //
    //       and (rndTo5(ImpTrades[i].pr) = rndTo5(ImpTrades[j].pr)) //
    //       and (ImpTrades[i].prf = ImpTrades[j].prf) //
    //       and (ImpTrades[j].oc <> '') and (i <> j) then begin
    //         glNumCancelledTrades := glNumCancelledTrades + 2;
    //         ImpTrades[i].oc := '';
    //         ImpTrades[i].ls := '';
    //         ImpTrades[i].tm := '';
    //         ImpTrades[j].oc := '';
    //         ImpTrades[j].ls := '';
    //         ImpTrades[j].tm := '';
    //         break;
    //       end; // if...
    //     end; // next j
    //   end; // next i
    // end; // if cancels
  end; // if (R > 0)
  if Developer or (v2UserEmail = DEBUG_EMAIL) then begin
    sm(sBadBS);
  end;
  // ------------------------------------------
  result := R;
end; // ReadPassiv


// ----------------------------------------------
// BrokerConnect import
procedure BCImport();
var
  i, X, RecCnt, ErrorCnt, R : integer;
  Trade : TTLTrade;
  FutureWarning, bFileSaved : boolean;
  msgText, msgErr, sBroker : string;
  impTicksList : TStringList;
  ImportReadMethods : TImportReadMethods;
  F : TdlgImport;
  // ----------------------------------
  // ----------------------------------
  procedure noRecsImportedMsg;
  begin
    if ImpBaseline then
      mDlg('No trade records to import' + cr + cr +
          ' Please retry the import making sure to follow the import instructions.' + cr + cr //
          + ' If you confirm you did not have trades during this date range, you can click' + cr //
          + ' the "Next" button in the lower right corner to proceed to the next step.' + cr, //
        mtInformation, [mbOK], 0)
    else
      mDlg('No trade records to import', mtInformation, [mbOK], 0);
    setLength(ImpTrades, 0);
  end;
  // ----------------------------------
  procedure miniOptions(var myTrade : TTrade);
  var
    stkTick : string;
  begin
    // mini options - underlying stock ticker end with a "7"
    if (pos('OPT', myTrade.prf)= 1) then begin
      stkTick := copy(myTrade.tk, 1, pos(' ', myTrade.tk)- 1);
      if (rightStr(stkTick, 1)= '7') then begin
        // remove 7 from underlying stock ticker
        delete(myTrade.tk, pos('7', myTrade.tk), 1);
        // change type/mult
        myTrade.prf := 'OPT-10';
      end;
    end;
  end;
  // ----------------------------------
  function CheckRecordLimit : boolean;
  begin
    result := false;
    if (length(Settings.RecLimit) > 0) and (TradeLogFile.Count >= strToInt(Settings.RecLimit)) then
    begin
      mDlg(Settings.TLVer + ' limited to ' + Settings.RecLimit + ' records' + cr + cr +
          'You have reached the record limit for your license.' + ' Import cannot continue!' + cr +
          'Please upgrade to a higher record limit to import additional records.', mtWarning,
        [mbOK], 0);
      result := true;
    end;
  end;
  // ----------------------------------
  function TradeBeyondEndDate(DT : TDate): boolean;
  begin
    result := false;
    // test for import date limitation
    // allow importing up to Oct. 16th of next year (extension deadline)
    if (DT > xStrToDate('10/16/' + NextTaxYear, Settings.InternalFmt)) then begin
      msgText := 'Cannot import trades past 10/16/' + NextTaxYear + ' in a ' + TaxYear + ' file.';
      result := true;
    end;
  end;
  // ----------------------------------
//  function ImportOFXData : integer;
//  var
//    TradeList : TTradeList;
//    Trade : TTLTrade;
//    errMsg, errLogTxt, errAdvice : string;
//  begin
//    // ----------------------------------
//    // Check for OFX errors
//    // ----------------------------------
//    if OFXImport.ErrorOccurred then begin
//      if (DEBUG_MODE > 1) and SuperUser then begin
//        TMessageDialog.Execute(msgTxt, TradeLogFile.CurrentAccount.FileImportFormat +
//            ' OFX Error Message: ' + cr + cr + OFXImport.ErrorMessage, '',
//          'OFX Login Error', mtError);
//      end;
//      // --------------------------------
//      if (pos('password', lowercase(OFXImport.ErrorMessage))> 0) //
//        or (pos('username', lowercase(OFXImport.ErrorMessage))> 0) //
//        or (pos('user name', lowercase(OFXImport.ErrorMessage))> 0) then begin
//        msgTxt := 'INVALID USERNAME OR PASSWORD';
//        errAdvice := 'Please correct the problem and try again';
//      end
//      else if pos('account', lowercase(OFXImport.ErrorMessage))> 0 then begin
//        msgTxt := 'INVALID ACCOUNT NUMBER';
//        errAdvice := 'Please correct the problem and try again';
//      end
//      else begin
//        msgTxt := 'GENERAL OFX LOGIN ERROR';
//        errAdvice := 'Please contact your BROKER for assistance.';
//      end;
//      // --------------------------------
//      // reformat ErrorMessage to 60 chars wide
//      errMsg := wrapText(OFXImport.ErrorMessage, 60);
//      AssignFile(ErrLog, Settings.DataDir + '\logs\error.log');
//      rewrite(ErrLog);
//      errLogTxt := uppercase(TradeLogFile.CurrentAccount.FileImportFormat) + ' OFX ERROR ' + msgTxt
//        + '; Detailed Message: ' + '"' + errMsg + '"';
//      try
//        write(ErrLog, errLogTxt);
//        errLogTxt := '';
//      finally
//        CloseFile(ErrLog);
//      end;
//      // --------------------------------
//      msgTxt := uppercase(TradeLogFile.CurrentAccount.FileImportFormat) + ' OFX ERROR ' + cr + cr +
//        msgTxt + cr + errAdvice + cr + cr + 'Detailed Message:' + cr + '"' + errMsg + '"';
//      mDlg(msgTxt, mtError,[mbOK], 0);
//      exit(-1);
//    end; // if ErrorOccurred
//    // ----------------------------------
//    OFXImport.SaveToFile(Settings.ImportDir + '\' + TradeLogFile.CurrentAccount.FileImportFormat +
//        '_' + FormatDateTime('yyyyMMdd', OFXDateStart) + '_' + FormatDateTime('yyyyMMdd',
//        OFXDateEnd) + '.ofx');
//    result := 0;
//    TradeList := OFXImport.GetTradeList;
//    if TradeList.Count = 0 then
//      exit(0);
//    try
//      RecCnt := TradeList.Count;
//      // added 2014-07-11 to support OFX for baseline
//      if ImpBaseline then
//        setLength(ImpTrades, TradeList.Count + 1);
//      for Trade in TradeList do begin
//        // Some brokers might provide data just outside of what was requested.
//        // If so, ignore it. Also, the user might try and get data beyond the
//        // natural EndDate for a given tax Year (eg. Past 1/31/NextTaxYear for
//        // a Cash file or Past 12/31/TaxYear for MTM - stop this as well
//        if (Trade.Date < OFXDateStart) //
//          or (Trade.Date > OFXDateEnd) //
//          or TradeBeyondEndDate(Trade.Date) then begin
//          Continue;
//          Trade.Free;
//        end;
//        if (pos('FUT', Trade.TypeMult) = 1) //
//          and (not Settings.MTMVersion or taxidVer) then
//          FutureWarning := true;
//        // do not import fidelity cash transactions
//        if (Trade.Ticker = 'FCASH') then
//          Continue;
//        // fix for OPT-0
//        if (Trade.TypeMult = 'OPT-0') then
//          Trade.TypeMult := 'OPT-100';
//        inc(result);
//        // added to support OFX for baseline
//        if ImpBaseline then begin
//          Trade.calcAmount; // 2015-04-04 MB - needed so Schwab commission is correct
//          ImpTrades[result].it := Trade.ID;
//          ImpTrades[result].DT := DateToStr(Trade.Date, Settings.UserFmt);
//          ImpTrades[result].tm := Trade.Time;
//          ImpTrades[result].oc := Trade.oc;
//          ImpTrades[result].ls := Trade.ls;
//          ImpTrades[result].tk := Trade.Ticker;
//          ImpTrades[result].sh := Trade.Shares;
//          ImpTrades[result].pr := Trade.Price;
//          ImpTrades[result].prf := Trade.TypeMult;
//          ImpTrades[result].cm := Trade.Commission;
//          ImpTrades[result].opTk := Trade.OptionTicker;
//          ImpTrades[result].am := Trade.Amount;
//          miniOptions(ImpTrades[result]);
//        end
//        else
//          TradeLogFile.AddTrade(Trade);
//        // get list of imported tickers
//        if (impTicksList.IndexOf(Trade.Ticker) = -1) then
//          impTicksList.Add(Trade.Ticker);
//        if CheckRecordLimit then
//          break;
//      end;
//    finally
//      TradeList.Free;
//    end;
//  end;
// ----------------------------------
// ----------------------------------
begin
  try
    impTicksList := TStringList.Create;
    ImportReadMethods := TImportReadMethods.Create;
    changedFuturesList := TList.Create;
    Etrade1099 := false;
    TDWyearend := false;
    TDWmonthly := false;
    ImportHasCusips := false;
    FutureWarning := false;
    bFileSaved := false;
//    OFX := false;
//    OFXImport := nil;
//    OFXFile := '';
    glNumCancelledTrades := 0;
    with frmMain do begin
      setLength(ImpTrades, 0);
      DataConvErrRec := '';
      CorrectedTrades := 0;
      NumConverted := 0;
      TradeLogFile.TradeNums.Importing := true;
      screen.Cursor := crHourglass;
      RecCnt := 0;
      // -----------------------------+
      // Import via Passiv            |
      // -----------------------------+
      if (TradeLogFile.CurrentAccount.importFilter.FastLinkable) //
//    and not(Settings.LegacyBC //
      and ((TradeLogFile.CurrentAccount.importFilter.FilterName = 'E-Trade') //
        or (TradeLogFile.CurrentAccount.importFilter.FilterName = 'Fidelity')) //
      then begin
        // --- get date range -----
        F := TdlgImport.Create(nil);
        try
          if F.showmodal = mrCancel then
            exit;
        finally
          FreeAndNil(F);
        end;
        sBroker := TradeLogFile.CurrentAccount.importFilter.FilterName;
        // ------------------
        RecCnt := ReadPassiv; // <---- get transaction history!
        // ------------------
        if RecCnt < 1 then begin
          sm('No trades to import');
          exit;
        end;
      end
      // -----------------------------+
      // Import via OFX, etc.         |
      // -----------------------------+
      else begin // select import filter
        TLDisable;
        try
          try
            RecCnt := ImportReadMethods.Call
              (TradeLogFile.CurrentAccount.importFilter.ImportFunction);
          except
            on e : Exception do begin
              if cancelURL then begin
                mDlg('Import Cancelled by User', mtInformation, [mbOK], 0);
                if ImpBaseline then
                  impCancelled := true;
                cancelURL := false;
              end
              else
                mDlg('Import Failed with the following message: ' //
                    + e.Message, mtWarning, [mbOK], 0);
              exit;
            end;
          end;
        finally
          TLEnable;
        end;
        // this keeps TL from crashing when importing, undoing, and then
        // importing a different number of records  - why????
        sleep(1000);
      end; // if Yodlee or Legacy
      // ----------------------------------------
//      if OFX then begin // import via OFX
//      // ----------------------------------------
//        StatBar('Getting OFX Data from Broker . . . Please Wait!');
//        screen.Cursor := crHourglass;
//        OFXImport := GetTLImportClass(TradeLogFile.CurrentAccount.importFilter);
//        if (length(OFXFile) > 0) then begin
//          OFXImport.LoadFromFile(OFXFile)
//        end
//        else begin
//          OFXImport.GetOFXData(TradeLogFile.CurrentAccount.OFXUserName, //
//            TradeLogFile.CurrentAccount.OFXPassword, //
//
//            TradeLogFile.CurrentAccount.OFXAccount, //
//            OFXDateStart, OFXDateEnd + 1);
//        end;
//        RecCnt := ImportOFXData;
//        if RecCnt < 1 then begin
//          StatBar('off');
//          if (RecCnt = 0) then
//            noRecsImportedMsg;
//          exit;
//        end;
//      end // OFX
//      // ----------------------------------------
//      else
      begin // import via import filters
      // ----------------------------------------
        if cancelURL then begin
          mDlg('Import Cancelled', mtInformation, [mbOK], 0);
          if ImpBaseline then
            impCancelled := true;
          cancelURL := false;
          exit;
        end;
        if RecCnt < 1 then begin
          StatBar('off');
          if webgetTimedOut then begin
            mDlg('BrokerConnect Timed Out' + cr + 'Please try again later.', mtInformation,
              [mbOK], 0);
            webgetTimedOut := false;
          end;
          exit;
        end;
        StatBar('Trade History Download Complete');
        screen.Cursor := crHourglass;
        X := TradeLogFile.Count;
        msgImp := '';
        try
          ErrorCnt := 0;
          // Add all imported Trades to TradeLogFile
          for i := 1 to high(ImpTrades) do begin
            // if it has NO ID, and NO Date, it's invalid, so skip it.
            if (ImpTrades[i].it = 0) and (length(ImpTrades[i].DT) = 0) then
              Continue;
            // delete corrected trades
            if (ImpTrades[i].ls = '') and (ImpTrades[i].oc = '') then begin
              inc(CorrectedTrades);
              Continue;
            end;
            // change all ticker to caps
            ImpTrades[i].tk := uppercase(ImpTrades[i].tk);
            HandleMiniOptions(ImpTrades[i]);
            ImpTrades[i].it := i + X;
            ImpTrades[i].br := IntToStr(TradeLogFile.CurrentBrokerID);
            if not ImpBaseline then begin
              Trade := TTLTrade.Create(ImpTrades[i]);
              if TradeBeyondEndDate(Trade.Date) then begin
                Trade.Free;
                Continue;
              end;
              if (pos('FUT', Trade.TypeMult) = 1) and not Settings.MTMVersion then
                FutureWarning := true;
                // *** add imported trades to TradeLogFile ***
              TradeLogFile.AddTrade(Trade);
              if CheckRecordLimit then
                break;
                // get list of imported tickers
              if (impTicksList.IndexOf(ImpTrades[i].tk) = -1) then
                impTicksList.Add(ImpTrades[i].tk)
            end; // <-- if not ImpBaseline
          end; // <-- for loop
        except
          on e : Exception do begin
            msgErr := msgErr + 'Error: ' + e.Message;
            inc(ErrorCnt);
          end;
        end;
        if msgImp <> '' then
          mDlg(msgImp, mtWarning, [mbOK], 0);
        msgImp := '';
        if ErrorCnt > 0 then
          mDlg('Warning: ' + IntToStr(i) //
              + ' trade record(s) could not be imported' + cr //
              + cr + msgErr, mtError, [mbOK], 0);
      end; // <-- if import via import filters
      // ----------------------------------------
      // if NOT importing baseline positions
      if not isFormOpen('panelBaseline') then begin
        // This must be after the tradelog file is updated so move it as necessary.
        changeFutMult(TradeLogFile.TradeList);
        StatBar('Matching Downloaded Data');
          // only match imported tickers
        if impTicksList.Count > 0 then // 2017-05-12 MB - skip if nothing to match
          TradeLogFile.Match(impTicksList); // 2016-06-27 MB - removed ForceMatch
        if TradeLogFile.Count > 1 then
          TradeLogFile.Reorganize;
          // check for data coversion errors
        CheckForDataConvertErr;
          // update grid
        TradeRecordsSource.DataChanged;
        bFileSaved := SaveTradeLogFile('Import', false, true, RecCnt);
          // change company names to stock tickers
        if bFileSaved then
          ChangeStockDescrtoTickerSymbol(true);
          // No brokers currently use this                `
        if ImportHasCusips and (TradeLogFile.Count > 0) then
          changeCusips;
// panelQS.doQuickStart(4, 1);
      end; // <-- if NOT importing baseline positions
//      importingOFX := false;
//      OFX := false;
      ETProSWS := false;
      etradeHist := false;
        // check for new Future Multipliers, Strategies, etc. not in Global lists
      if not isFormOpen('panelBaseline') then
        CheckForNewData;
    end; // <-- with frmMain
  finally
    impTicksList.Free;
    ImportReadMethods.Free;
    StatBar('off');
    screen.Cursor := crDefault;
    TradeLogFile.TradeNums.Importing := false;
    frmMain.btnImport.Enabled := not isAllBrokersSelected; // in case of error
  end;
end; // BCImport


// --------------------------
// NEW File Import
// --------------------------

procedure FileImport(PasteRecs : boolean; Baseline : boolean = false);
var
  i, X, RecCnt, ErrorCnt : integer;
  Trade : TTLTrade;
  FutureWarning, bFileSaved : boolean;
  msgText, msgErr : string;
  impTicksList : TStringList;
  ImportReadMethods : TImportReadMethods;
  // ----------------------------------
  procedure noRecsImportedMsg;
  begin
    if ImpBaseline then
      mDlg('No trade records to import' + cr + cr +
          ' Please retry the import making sure to follow the import instructions.' + cr + cr //
          + ' If you confirm you did not have trades during this date range, you can click' + cr //
          + ' the "Next" button in the lower right corner to proceed to the next step.' + cr, //
        mtInformation, [mbOK], 0)
    else
      mDlg('No trade records to import', mtInformation, [mbOK], 0);
    setLength(ImpTrades, 0);
  end;
  // ----------------------------------
  function CheckRecordLimit : boolean;
  begin
    result := false;
    if (length(Settings.RecLimit) > 0) and (TradeLogFile.Count >= strToInt(Settings.RecLimit)) then
    begin
      mDlg(Settings.TLVer + ' limited to ' + Settings.RecLimit + ' records' + cr + cr +
          'You have reached the record limit for your license. Import cannot continue!' + cr +
          'Please upgrade to a higher record limit to import additional records.', mtWarning,
        [mbOK], 0);
      result := true;
    end;
  end;
  // ----------------------------------
  function TradeBeyondEndDate(DT : TDate): boolean;
  begin
    result := false;
    // test for import date limitation
    // 2017-02-09 MB - allow importing up to Oct. 16th of the next year (extension deadline)
    if (DT > xStrToDate('10/16/' + NextTaxYear, Settings.InternalFmt)) then begin
      msgText := 'Cannot import trades past 10/16/' + NextTaxYear + ' in a ' + TaxYear + ' file.';
      result := true;
    end;
  end;
// ----------------------------------
begin // FileImport
  try
    impTicksList := TStringList.Create;
    ImportReadMethods := TImportReadMethods.Create;
    changedFuturesList := TList.Create;
    Etrade1099 := false;
    TDWyearend := false;
    TDWmonthly := false;
    ImportHasCusips := false;
    FutureWarning := false;
    bFileSaved := false;
//    OFX := false;
//    OFXImport := nil;
//    OFXFile := '';
    glNumCancelledTrades := 0;
    with frmMain do begin
      setLength(ImpTrades, 0);
      DataConvErrRec := '';
      CorrectedTrades := 0;
      NumConverted := 0;
      TradeLogFile.TradeNums.Importing := true;
      screen.Cursor := crHourglass;
      // -----------------------------+
      // Import Trades                |
      // -----------------------------+
      if PasteRecs then
        RecCnt := ReadPaste
      else begin // select import filter
        TLDisable;
        try
          try
            RecCnt := ImportReadMethods.Call
              (TradeLogFile.CurrentAccount.importFilter.ImportFunction);
          except
            on e : Exception do begin
              if cancelURL then begin
                mDlg('Import Cancelled by User', mtInformation, [mbOK], 0);
                if ImpBaseline then
                  impCancelled := true;
                cancelURL := false;
              end
              else
                mDlg('Import Failed with the following message: ' + e.Message, mtWarning,
                  [mbOK], 0);
              exit;
            end;
          end;
        finally
          TLEnable;
        end;
      end;
      // this keeps TL from crashing when importing, undoing, and then
      // importing a different number of records  - why????
      sleep(1000);
      // ----------------------------------------
//      if OFX then begin // import via OFX
//        sm('OFX error');
//      end
//      // ----------------------------------------
//      else
      begin // import via import filters
      // ----------------------------------------
        if cancelURL then begin
          mDlg('Import Cancelled', mtInformation, [mbOK], 0);
          if ImpBaseline then
            impCancelled := true;
          cancelURL := false;
          exit;
        end;
        if RecCnt < 1 then begin
          StatBar('off');
          if webgetTimedOut then begin
            mDlg('BrokerConnect Timed Out' + cr + 'Please try again later.', mtInformation,
              [mbOK], 0);
            webgetTimedOut := false;
          end
          else
            noRecsImportedMsg;
          exit;
        end;
        StatBar('Trade History Download Complete');
        screen.Cursor := crHourglass;
        X := TradeLogFile.Count;
        msgTxt := '';
        try
          ErrorCnt := 0;
          // Add all imported Trades to TradeLogFile
          for i := 1 to high(ImpTrades) do begin
            // Sometimes an invalid line can come from the import routine
            // so if it has NO ID, and NO Date, then skip it.
            if (ImpTrades[i].it = 0) and (length(ImpTrades[i].DT) = 0) then
              Continue;
            // delete corrected trades
            if (ImpTrades[i].ls = '') and (ImpTrades[i].oc = '') then begin
              inc(CorrectedTrades);
              Continue;
            end;
            // change all ticker to caps
            ImpTrades[i].tk := uppercase(ImpTrades[i].tk);
            HandleMiniOptions(ImpTrades[i]);
            ImpTrades[i].it := i + X;
            ImpTrades[i].br := IntToStr(TradeLogFile.CurrentBrokerID);
            if not ImpBaseline then begin
              Trade := TTLTrade.Create(ImpTrades[i]);
              if TradeBeyondEndDate(Trade.Date) then begin
                Trade.Free;
                Continue;
              end;
              if (pos('FUT', Trade.TypeMult) = 1) and not Settings.MTMVersion then
                FutureWarning := true;
              // *****add imported trades to TradeLogFile******
              TradeLogFile.AddTrade(Trade);
              if CheckRecordLimit then
                break;
              // get list of imported tickers
              if (impTicksList.IndexOf(ImpTrades[i].tk) = -1) then
                impTicksList.Add(ImpTrades[i].tk)
            end; // <-- if not ImpBaseline
          end; // <-- for loop
        except
          on e : Exception do begin
            msgErr := msgErr + 'Error: ' + e.Message;
            inc(ErrorCnt);
          end;
        end;
        if msgText <> '' then
          mDlg(msgText, mtWarning, [mbOK], 0);
        msgText := '';
        if ErrorCnt > 0 then
          mDlg('Warning: ' + IntToStr(i) + ' trade record(s) could not be imported' + cr + cr +
              msgErr, mtError, [mbOK], 0);
      end; // <-- if import via import filters
      // ----------------------------------------
      // if NOT importing baseline positions
      if not isFormOpen('panelBaseline') then begin
        // This must be after the tradelog file is updated so move it as necessary.
        changeFutMult(TradeLogFile.TradeList);
        StatBar('Matching Downloaded Data');
        // only match imported tickers
        if impTicksList.Count > 0 then // 2017-05-12 MB - skip if nothing to match
          TradeLogFile.Match(impTicksList); // 2016-06-27 MB - removed ForceMatch
        if TradeLogFile.Count > 1 then
          TradeLogFile.Reorganize;
        // check for data coversion errors
        if SuperUser then
          CheckForDataConvertErr;
        // update grid
        TradeRecordsSource.DataChanged;
        if PasteRecs then
          bFileSaved := SaveTradeLogFile('Paste', false, true, RecCnt)
        else if not Baseline then
          bFileSaved := SaveTradeLogFile('Import', false, true, RecCnt);
        // change company names to stock tickers
        if bFileSaved then
          ChangeStockDescrtoTickerSymbol(true);
        // No brokers currently use this                `
        if ImportHasCusips //
          and (TradeLogFile.Count > 0) //
          and not Baseline then
          changeCusips;
// panelQS.doQuickStart(4, 1);
      end; // <-- if NOT importing baseline positions
      // ----------------------------------------
//      importingOFX := false;
//      OFX := false;
      ETProSWS := false;
      etradeHist := false;
      // check for new Future Multipliers, Strategies, etc. not in Global lists
      if not isFormOpen('panelBaseline') then
        CheckForNewData;
    end; // <-- with frmMain
    // --------------------------------
    X := TradeLogFile.CurrentBrokerID;
    TradeLogFile.Refresh; // 2022-03-08 MB
    TradeLogFile.CloneList; // same
    TradeLogFile.CurrentBrokerID := X;
    // --------------------------------
  finally
    impTicksList.Free;
    ImportReadMethods.Free;
    StatBar('off');
    screen.Cursor := crDefault;
    TradeLogFile.TradeNums.Importing := false;
    frmMain.btnImport.Enabled := not isAllBrokersSelected; // in case of error
  end;
end; // FileImport

initialization

end.
