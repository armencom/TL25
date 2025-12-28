unit TLCompatibility;

interface

uses
  funcProc, StrUtils, SysUtils, DateUtils, TLFile, TLSettings, TLDateUtils,
  TLCommonLib, TLDatabase, TLWinInet, //TLLogging, cxGridCustomTableView, dxCore,
  clipBrd;

procedure CheckETYdateForWSflag(FileName, tYear: string; sRegCode: string = ''); // 2016-11-07 MB
procedure SetWSCompatibilityFlag(FileName: String);

var
  bWSCompatibility: boolean;


implementation

uses
  GainsLosses, GlobalVariables;

const
  WSBugStart = '3/15/2016';
  WSBugEnd = '12/1/2016';


/// *****************************************************************
/// Determine whether we need bWSCompatibility set for this file
/// *****************************************************************
procedure CheckETYdateForWSflag(FileName, tYear: string; sRegCode: string = ''); // 2016-11-07 MB
var
  TrFileNameNoExt, test, regCheckURL, reply, sFlag, sYrCode, sRow, sETYdate, sLastETYdate, t: string;
  i, j: integer;
  bFound: boolean;
  // ------------------------
  procedure FindLastETY;
  begin
    reply := uppercase(readURL(regCheckURL));
    if SuperUser and (DEBUG_MODE > 5) then begin
      t := clipboard.AsText; // preserve
      clipboard.astext := reply;
      sm('paste get-taxfilelog reply now');
      clipboard.astext := t; // restore
    end;
    // just keep the table part
    reply := ParseHTML(reply,
      '<TABLE CELLPADDING="3" CELLSPACING="0" BORDER="1" WIDTH="100%">',
      '</TABLE>');
    i := POS('</TR>', reply);
    if i > 0 then delete(reply, 1, (i + 4));
    // find the LAST ETY for this file
    bFound := false; // not found yet
    repeat
      test := ParseHTML(reply, '<TR>', '</TR>');
      if POS('END TAX YEAR', test) > 0 then
        if POS(uppercase(TrFileNameNoExt), test) > 0 then begin
          sRow := test; // save the latest match
          bFound := true; // ETY, correct filename
        end;
      delete(reply, 1, length(test)+9);
    until (test = '');
    if SuperUser and (DEBUG_MODE > 5) and bFound then begin
      t := clipboard.AsText; // preserve
      clipboard.astext := sRow;
      sm('TaxFile Log sRow: ' + CRLF + sRow);
      clipboard.astext := t; // restore
    end;
  end;
  // ------------------------
  procedure GetETYdate;
  begin
    // sRow contains the ETY date
    i := POS(uppercase(TrFileNameNoExt), sRow);
    if (i > 0) then begin
      delete(sRow, 1, i);
      sETYdate := ParseHTML(sRow, '<TD>', '</TD>');;
    end;
  end;
  // ------------------------
begin
  // ONLY check if flag isn't already set, since we don't want to uncheck it!
  if bWSCompatibility then exit;
  // skip if there is no regCode to test! (i.e. leave flag unchanged)
  if (ProHeader.regCode = '') and (ProHeader.regCodeAcct = '') then exit;
  // skip if it's not an 'F' or a 'G' regCode
  sYrCode := uppercase(copy(sRegCode,1,1));
  if not ((sYrCode = 'G') or (sYrCode = 'F')) then exit;
  // skip is not taxIDver
  if not taxidVer then exit;
  if not isDate(tYear) then tYear := TaxYear;
  if (tYear >= '2016') then exit;
  // --------- end skip code ----------
  // 1. Get the TaxFile filename we want to find
  // remove file extension
  TrFileNameNoExt := FileName;
  if pos('\',FileName) > 0 then
    test := parselast(TrFileNameNoExt,'\')
  else
    test := TrFileNameNoExt;
  TrFileNameNoExt := RemoveFileExtension(test); // 2017-04-11 MB - redundant?
  // ----------------------
  // 2. Check the tdfFlags table in the file
  sFlag := dbGetFlag('bWSCompatibility');
  if (sFlag = 'T') then begin
    bWSCompatibility := true;
    exit; // don't change once set
  end
  else if (sFlag = 'F') then begin
    bWSCompatibility := false;
    exit; // don't change once set
  end;
  // ----------------------
  // neither, so need to calculate it
  bFound := false;
  sETYdate := '';
  sLastETYdate := '';
  bWSCompatibility := (tYear = '2015'); // default TRUE for 2015 only
  TrFileNameNoExt := ProHeader.taxFile;
  // make sure text filename begins with taxyear!
  if not isNumber(copy(TrFileNameNoExt,1,4)) then
    TrFileNameNoExt := tYear + ' ' + TrFileNameNoExt;
  // ----------------------
  // 3a. Test current RegCode
  if sRegCode = '' then
    regCheckURL := siteURL + 'taxfile/get-taxfilelog?regcode='
      + Settings.regCode
  else
    regCheckURL := siteURL + 'taxfile/get-taxfilelog?regcode=' + sRegCode;
  FindLastETY;
  GetETYdate;
  sLastETYdate := sETYdate;
  // ----------------------
  // 3b. Test other possible 2015 RegCode
  if not bFound and (sRegCode <> '') then begin
    if (sYrCode = 'G') then
      test := 'F' + copy(sRegCode,2)
    else if (sYrCode = 'F') then
      test := 'G' + copy(sRegCode,2);
    regCheckURL := siteURL + 'taxfile/get-taxfilelog?regcode=' + test;
    reply := uppercase(readURL(regCheckURL));
    FindLastETY;
    GetETYdate;
    if isdate(sETYdate) then begin
      if not isdate(sLastETYdate) then
        sLastETYdate := sETYdate
      else if StrToDate(sETYdate) > StrToDate(sLastETYdate) then
        sLastETYdate := sETYdate;
    end;
  end;
  // ----------------------
  // 3b. Test other possible 2015 RegCode
  if not bFound and (ProHeader.regCodeAcct <> '') then begin
    regCheckURL := siteURL + 'taxfile/get-taxfilelog?regcode='
      + ProHeader.regCodeAcct;
    reply := uppercase(readURL(regCheckURL));
    FindLastETY;
    GetETYdate;
    if isdate(sETYdate) then begin
      if not isdate(sLastETYdate) then
        sLastETYdate := sETYdate
      else if StrToDate(sETYdate) > StrToDate(sLastETYdate) then
        sLastETYdate := sETYdate;
    end;
  end;
  // ----------------------
  if length(sLastETYdate) > 10 then begin
    test := copy(sLastETYdate,6,2)
      + '/' + copy(sLastETYdate,9,2)
      + '/' + copy(sLastETYdate,1,4);
    bWSCompatibility := IsInDateRange(test, WSBugStart, WSBugEnd);
  end;
  if SuperUser and (DEBUG_MODE > 0) then
    sm('Last ETY on ' + sLastETYdate + CRLF
      + 'bWSCompatibility: ' + booltostr(bWSCompatibility, true));
end;


procedure SetWSCompatibilityFlag(FileName: String);
var
  sName, sFlag: string;
begin
  // ASSUME: dbFileConnect is still in effect
  // bWSCompatibility - do we need to use the old WS code?
  // ASSUME: dbUpdateTables was called by dbFileCreate
  sName := 'bWSCompatibility';
  sFlag := dbGetFlag(sName);
  if (sFlag = '') then begin
    CheckETYdateForWSflag(FileName, ProHeader.regCode);
    if bWSCompatibility then sFlag := 'T' else sFlag := 'F';
    dbSetFlag(sName, sFlag);
  end;
  // any others could go here.
  // ASSUME dbFileDisconnect will be called later.
end;


end.
