unit importCSV;
// This unit is for parsing CSV trade history files.

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, Dialogs;


procedure matchCancels(R:integer; bLS:boolean=true);
function reformatOptionSymbol(op:string; descr:string='') : string;

/// CSV import filters ///
function ReadApexCSV(): integer;
function ReadApex2017(): integer; // MB 2017-01-31
function ReadCobraCSV(): integer;
function ReadAxos(): integer;
function ReadETC(): integer;
function ReadLightspeedCSV(webCopy:boolean): integer;
function ReadMBTradingCSV(): integer;

implementation

uses
  Import, FuncProc, StrUtils,
  TLFile, TLCommonLib, TLSettings, TLWinInet,
  TLImportFilters, TLImportReadMethods,
  TLLogging,
  clipbrd; //, selImpMethod;

const
  CODE_SITE_CATEGORY = 'ImportCSV';

Var
  // --------------------------------------------
  // Field numbers
  // --------------------------------------------
  iDt, iTyp, iOC, iLS, iTk, iDesc, iShr, iPr, iAmt, iCm : integer;


function getCSVstrList(csvTxt : string = 'csv') : integer;
begin
  ImpStrList := TStringList.Create;
  ImpStrList.clear;
  GetImpDateLast;
  GetImpStrListFromFile(TradeLogFile.CurrentAccount.FileImportFormat, csvTxt, '');
  result := ImpStrList.Count;
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


procedure matchCancels(R:integer; bLS:boolean=true);
var
  i, j: integer;
  iAmt, jAmt : double;
begin
  for i := 1 to R do begin
    statBar('Matching Cancelled Trades: ' + intToStr(i));
    // make sure both amounts are positive
    iAmt := rndTo2(ImpTrades[i].am);
      if (iAmt < 0) then iAmt := -iAmt;
    for j := 1 to R do begin
      if (ImpTrades[i].OC <> 'X')
      or (ImpTrades[i].tk <> ImpTrades[j].tk)
      or (ImpTrades[i].prf <> ImpTrades[j].prf)
      or (i = j)
      then continue;
      // compare long/shorts
      if (TradeLogFile.CurrentAccount.ImportFilter.FilterName = 'Cobra') then begin
        // don't match a cancel buy with sell
        if  (ImpTrades[i].LS = 'L')
        and (ImpTrades[j].OC = 'C') and (ImpTrades[j].LS = 'L')
        then continue;
        // don't match a cancel sell with buy
        if  (ImpTrades[i].LS = 'S')
        and (ImpTrades[j].OC = 'O') and (ImpTrades[j].LS = 'L')
        then continue;
      end
      else if ( bLS and (ImpTrades[i].LS <> ImpTrades[j].LS) ) then
        continue;
      // compare shares
      if (rndTo6(ImpTrades[i].sh) <> rndTo6(ImpTrades[j].sh)) then
        continue;
      // finally compare amounts
      jAmt := rndTo2(ImpTrades[j].am);
      if (jAmt < 0) then jAmt := -jAmt;
      if (iAmt = jAmt) then begin
        glNumCancelledTrades := glNumCancelledTrades + 2;
        ImpTrades[i].OC := '';
        ImpTrades[i].LS := '';
        ImpTrades[i].tm := '';
        ImpTrades[j].OC := '';
        ImpTrades[j].LS := '';
        ImpTrades[j].tm := '';
        break;
      end;
    end;
  end;
end;


function loadImpTradesArray(i,R:integer;
  dt,tm,oc,ls,tk,ShStr,PrStr,AmtStr,typeStr,cmStr:String):integer;
var
  multStr : String;
  shares, price, commis, amount, mult : double;
begin
  //load impTrades array with imported trade record fields
  commis := 0;
  try
    Shares := CurrToFloat(ShStr);
    if Shares < 0 then Shares := -Shares;
    //
    Price := CurrToFloat(PrStr);
    if Price < 0 then Price := -Price;
    //
    if (cmStr <> '') then
      commis := strToFloat(cmStr)
    else
      commis := 0;
    //
    multStr := typeStr;
    multStr := parseLast(multStr, '-');
    mult := strToFloat(multStr);
    //
    if (AmtStr <> '') then
      Amount := CurrToFloat(AmtStr)
    else begin
      if ((OC = 'O') and (LS = 'L')) or ((OC = 'C') and (LS = 'S')) then
        Amount := -( (Shares * Price * mult) + commis )
      else if ((OC = 'C') and (LS = 'L')) or ((OC = 'O') and (LS = 'S')) then
        Amount := (Shares * Price * mult) - Commis;
    end;
    //
    if (Amount < 0) then Amount := -Amount;
    //calculate commis
    if (commis = 0) then begin
      if ((OC = 'O') and (LS = 'L')) or ((OC = 'C') and (LS = 'S')) then
        Commis := Amount - (Shares * Price * mult)
      else if ((OC = 'C') and (LS = 'L')) or ((OC = 'O') and (LS = 'S')) then
        Commis := (Shares * Price * mult) - Amount;
    end;
    ImpTrades[R].it := TradeLogFile.Count + R;
    ImpTrades[R].dt := dt;
    ImpTrades[R].tm := tm;
    ImpTrades[R].OC := OC;
    ImpTrades[R].LS := LS;
    ImpTrades[R].tk := tk;
    ImpTrades[R].sh := Shares;
    ImpTrades[R].pr := Price;
    ImpTrades[R].prf := typeStr;
    ImpTrades[R].cm := Commis;
    ImpTrades[R].am := Amount;
    result:= R;
  except
    DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
    dec(R);
    result := R;
  end;
end;

// ===============================
/// CSV FIELD PARSING ROUTINES ///
// ===============================

function parseDate(dt : string) : string;
var
  junk, myDay, myMon, myYear : string;
begin
  result := '';
  //test for date format: Mon, 04 Jan 2013 12:00:00 am EST
  //                      Wed, 03 Apr 2013 12:00:00 am EDT
  if ( (length(dt) = 31) and (pos(',',dt)>0) )
  or (length(dt) = 32) //depends whether date has comma or not
  then begin
    //delete Mon-Sun text
    junk := parseFirst(dt,' ');
    //get day
    myDay := parseFirst(dt,' ');
    //get month
    myMon := parseFirst(dt,' ');
    myMon := monNum(myMon);
    //get year
    myYear := parseFirst(dt,' ');
    //put it all together in Tradelog long date internal format
    //sm(myMon +'/'+ myDay +'/'+ myYear);
    result := myMon +'/'+ myDay +'/'+ myYear;
  end;
end;


//function reformatTime(s:string):string;
//begin
//  if (length(s) = 0) then
//    s := '00:00'
//  else if (length(s) = 3) then begin
//    insert(':',s,2);
//    s := '0'+ s;
//  end
//  else if (length(s) = 4) then
//    insert(':',s,3);
//  result := s + ':00';
//end;


function formatStrike(s:string):string;
begin
  if (length(s) < 8) then begin
    result := delTrailingZeros(s);
    exit;
  end
  else begin // eg : 00047500  = 47.5
    //insert decimal point
    insert('.',s,6);
    s := delTrailingZeros(s);
    //delete leading zeros
    while (leftStr(s,1)='0') do
      delete(s,1,1);
    result := s;
  end;
end;


function getOpTickFromSymbol(tk : string) : string;
var
  s, newTk : string;
begin
  // TSLA1431M185
  tk := trim(tk);
  while not isInt(leftStr(tk,1)) do begin
    s := leftStr(tk,1);
    newTk := newTk + s;
    delete(tk,1,1);
  end;
  //test for mini options - pass the 7 if found
  if (leftStr(tk,1) = '7') then
    newTk := newTk + leftStr(tk,1);
  result := newTk;
end;


// ------------------------------------
function reformatOptionSymbol(op:string; descr:string='') : string;
var
  opTk, exDa, exMo, ExYr, cp, strike, junk : String;
begin
  ///// Exp Date: mo,da,yr
  // AB^^^111613C00065000   - 21 char CBOE option symbol
  // M     111613C00047000
  // CRUS111613C21          - Cor Clearing
  // ----------------------------------
  ///// Exp Date: yr, mo,da  - Lighstpeed
  // SPY   150130P00201000
  // TSLA  150206P00202500
  // ----------------------------------
  //parse from left to right
  //get underlying ticker
  while not isInt(junk) do begin
    junk := leftStr(op,1);
      if isInt(junk)
      and (junk <> '7') // 7 = mini option
      and (copy(op, 2, 1) <> ' ')
      then
        break;
      //get rid of ^ chars or spaces
      if  (junk <> ' ')
      and (junk <> '^')
      then
        opTk := opTk + junk;
    delete(op,1,1);
  end;
  while (leftStr(op,1)=' ') do
    delete(op,1,1); // remove leading spaces
  if (TradeLogFile.CurrentAccount.FileImportFormat <> 'Axos') //
  and (TradeLogFile.CurrentAccount.FileImportFormat <> 'COR') then begin
    //get expiration year
    exYr := leftStr(op,2);
      delete(op,1,2);
  end;
  //get expiration month
  exMo := leftStr(op,2);
    exMo := numToMon(exMo);
    delete(op,1,2);
  //get expiration day
  exDa := leftStr(op,2);
    delete(op,1,2);
  if (TradeLogFile.CurrentAccount.FileImportFormat = 'Axos') //
  or (TradeLogFile.CurrentAccount.FileImportFormat = 'COR') then begin
    //get expiration year
    exYr := leftStr(op,2);
      delete(op,1,2);
  end;
  //get call/put
  cp := leftStr(op,1);
    if cp='C' then
      cp := 'CALL'
    else if cp='P' then
      cp := 'PUT';
    delete(op,1,1);
  //strike
  strike := op;
  strike := formatStrike(strike);
  //put it all together
  result := opTk +' '+ exDa+exMo+exYr +' '+ strike +' '+ cp;
end;


function reformatOptionDescr(descr:string;opTk:string=''):string;
var
  exDa, exMo, ExYr, cp, strike, junk : String;
  p : integer;
begin
  // COR:        "CALL NETFLIX INC $155 EXP 04/20/13"
  // Cobra:      "PUT TESLA MOTORS INC $185        EXP 01/31/14 "
  // Wedbush:    "PUT PRANA BIOTECHNOLOGY $7          EXP 04/19/14 LTD SPONS ADR"
  // Just2Trade: "CALL NETFLIX INC $155 EXP 04/20/13"
  descr := trim(descr);
  // fix for extra chars after expire date 2014-06-25
  p := pos('EXP ',descr);
  if (length(descr) > p + 12) then
    delete(descr, p+12, length(descr) - p + 13);
    // sm(descr);
  // test if descr is good to parse
  if  ((pos('CALL ',descr)=1) or (pos('PUT ',descr)=1))
  and (pos('EXP ',descr) > 0) then begin // 2021-10-08 MB - 'EXP <date>', NOT 'EXPRESS'
    cp := parseFirst(descr,' ');
    exYr := rightStr(descr,2);
      junk := parseLast(descr,'/');
    exDa := rightStr(descr,2);
      junk := parseLast(descr,'/');
    exMo := rightStr(descr,2);
      exMo := numToMon(exMo);
      junk := parseLast(descr,' EXP '); // distinguish 'EXP <date>' from 'EXPRESS'
      descr := trim(descr);
    strike := parselast(descr,'$');
      if pos(' ',descr)>0 then importHasDescr := true;
    if (opTk <> '') then
      result := opTk +' '+ exDa+exMo+exYr +' '+ strike +' '+ cp
    else
      result := trim(descr) +' '+ exDa+exMo+exYr +' '+ strike +' '+ cp;
  end else
    result := descr;
end;


/// CSV IMPORT FILTERS ///

function ReadApexCSV(): integer;
var
  I, R, colCnt : integer;
  ImpDate, sTime, tick, OC, LS, PrStr, ShStr, AmtStr, typeStr, line, descr, tradeType : string;
  sUnderlying, sStrike, sCallPut, sExpDa, sExpMo, sExpYr, sJunk : string;
  contracts, impNextDateOn : boolean;
  lineLst : TStrings;
begin
  try
    bApexActivity := true;
    TradeLogFile.CurrentAccount.AutoAssignShorts := false;
    R := 0;
    lineLst := TStrings.Create;
    for I := 0 to ImpStrList.Count - 1 do begin
      contracts := false;
      Inc(R);
      if R < 1 then R := 1;
      line := uppercase(trim(ImpStrList[I]));
      // parse all columns into string list
      lineLst := ParseCSVtext(line);
      // --- CSV COLUMN MAP -----------------------------------------
      //  0-Type             = "Trades" for now - ToDo: see if exercise/assign noted in this column
      //    1-Account        = General Margin only
      //  2-TradeDate        = 4/19/15  <-- need to change to 04/19/2015
      //    3-SettleDate
      //    4- Tag #
      //  5-TimeStamp        = 5/22/15 13:09:00 <-- need to remove date
      //  6-Symbol           = FDX   20170120C  150.000  <-- this will work for options
      //  7-Description      = CALL FDX    01/20/17   15
      //  8-TradeAction      = Buy To Open, Sell To Close, etc
      //  9-Quantity         = -200.000
      //  10-Price           = 54.31000
      //  11-Fees            = $0.07   <-- need to remove dollar sign
      //  12-Commission      = $10.00  <-- need to remove dollar sign
      //  13-NetAmount       = -2950.07
      //  14-Trailer
      //  5-Transfer Direction
      // ------------------------------------------------------------
      // get trade record fields from csv file
      tradeType := uppercase(lineLst[0]);
      // skip if not a trade record
      if (pos('TRADE', tradeType) = 0) then begin
        dec(R);
        Continue;
      end;
      ImpDate := lineLst[2];
      ImpDate := longDateStr(ImpDate);
      if (ImpDate = '') or not ValidTradeDate(ImpDate, ImpDateLast, impNextDateOn) then begin
        dec(R);
        Continue;
      end;
      sTime := lineLst[5];
        // 5/22/15 13:09:00
      sTime := parseLast(sTime, ' ');
      OC := uppercase(lineLst[8]);
      tick := uppercase(lineLst[6]);
      descr := uppercase(lineLst[7]);
      ShStr := lineLst[9];
      PrStr := lineLst[10];
      AmtStr := lineLst[13];
      // open/close
      if (pos('BUY', OC) > 0) then begin
        if (pos('CLOSE', OC) > 0) or (pos('SHORT', OC) > 0) // not sure yet about short sales
        then begin
          OC := 'C';
          LS := 'S';
        end
        else begin
          OC := 'O';
          LS := 'L';
        end;
      end
      else if (pos('SELL', OC) = 1) then begin
        if (pos('OPEN', OC) > 0) or (pos('SHORT', OC) > 0) // not sure yet about short sales
        then begin
          OC := 'O';
          LS := 'S';
        end
        else begin
          OC := 'C';
          LS := 'L';
        end;
      end
      else begin
        dec(R);
        Continue;
      end;
      // test for options
      if (pos('CALL ', descr) = 1) or (pos('PUT ', descr) = 1) then begin
        contracts := true;
        typeStr := 'OPT-100';
      end
      else begin
        contracts := false;
        typeStr := 'STK-1';
      end;
      // options
      if contracts then begin
        // FDX   20170120C  150.000
        tick := trim(tick);
        sUnderlying := parseFirst(tick, ' ');
        sStrike := trim(parseLast(tick, ' '));
        sStrike := delTrailingZeros(sStrike);
        tick := trim(tick);
        sCallPut := rightStr(tick, 1);
        if (sCallPut = 'P') then
          sCallPut := 'PUT'
        else if (sCallPut = 'C') then
          sCallPut := 'CALL';
        sExpYr := midStr(tick, 3, 2);
        sExpMo := midStr(tick, 5, 2);
        sExpMo := getExpMo(sExpMo);
        sExpDa := midStr(tick, 7, 2);
        tick := sUnderlying + ' ' + sExpDa + sExpMo + sExpYr + ' ' + sStrike + ' ' + sCallPut;
      end;
        // sm(Impdate+' '+cr+OC+LS+'  '+tick+cr+shstr+cr+PrStr+cr+AmtStr+cr+typeStr);  continue;
      R := loadImpTradesArray(I, R, ImpDate, sTime, OC, LS, tick, ShStr, PrStr, AmtStr,
        typeStr, '');
    end;
    result := R;
  finally
    lineLst.Free;
  end;
end; // ReadApexCSV

// 2017-01-31 MB - added new import for new format
function ReadApex2017(): integer;
var
  I, R, colCnt : integer;
  ImpDate, sTime, tick, OC, LS, PrStr, ShStr, AmtStr, typeStr, line, descr, tradeType : string;
  sUnderlying, sStrike, sCallPut, sExpDa, sExpMo, sExpYr, sJunk : string;
  contracts, impNextDateOn : boolean;
  lineLst : TStrings;
begin
  try
    bApexActivity := true;
    TradeLogFile.CurrentAccount.AutoAssignShorts := false;
    R := 0;
    lineLst := TStrings.Create;
    for I := 0 to ImpStrList.Count - 1 do begin
      contracts := false;
      Inc(R);
      if R < 1 then
        R := 1;
      line := uppercase(trim(ImpStrList[I]));
      // parse all columns into string list
      lineLst := ParseCSVtext(line);
      { CSV COLUMN MAP
        0-Type                        = "Trades" only - need to see if exercise/assign are noted in this column
        1-TradeDate                   = 2017-01-15  <-- need to change to 01/15/2017
          2-SettleDate
        3-Symbol                      = FDX   20170120C  150.000  <-- this will work for options
        4-Description                 = CALL FDX    01/20/17   15
        5-TradeAction                 = Buy To Open, Sell To Close, etc
        6-Quantity                    = -200.000
        7-Price                      = 54.31000
        8-NetAmount                  = -2950.07
 }
      // get trade record fields from csv file
      tradeType := uppercase(lineLst[0]);
        // skip of not a trade record
      if (pos('TRADE', tradeType) = 0) then begin
        dec(R);
        Continue;
      end;
      ImpDate := lineLst[1];
      if pos('-', ImpDate) = 5 then begin
        ImpDate := StringReplace(ImpDate, '-', '', [rfReplaceAll]);
        ImpDate := MMDDYYYY(ImpDate); // it comes in yyyy-mm-dd
      end;
        // else do nothing - 2017-07-14 MB - added "/" case
      ImpDate := longDateStr(ImpDate);
      if (ImpDate = '') or not ValidTradeDate(ImpDate, ImpDateLast, impNextDateOn) then begin
        dec(R);
        Continue;
      end;
      OC := uppercase(lineLst[5]);
      tick := uppercase(lineLst[3]);
      descr := uppercase(lineLst[4]);
      // 2017-02-24 MB - Apex now putting option ticker info in field 3 only
      if (trim(descr) = '') and (Length(tick) > 11) then begin
        if (pos('P ', tick, 8) > 9) then begin
          descr := 'PUT ' + tick;
          contracts := true;
        end
        else if (pos('C ', tick, 8) > 9) then begin
          descr := 'CALL ' + tick;
          contracts := true;
        end
        else
          contracts := true;
      end;
      // end changes 2017-02-24 MB
      ShStr := lineLst[6];
      PrStr := lineLst[7];
      AmtStr := lineLst[8];
      // open/close
      if (pos('BUY', OC) > 0) then begin
        if (pos('CLOSE', OC) > 0) or (pos('SHORT', OC) > 0) // not sure yet about short sales
        then begin
          OC := 'C';
          LS := 'S';
        end
        else begin
          OC := 'O';
          LS := 'L';
        end;
      end
      else if (pos('SELL', OC) = 1) then begin
        if (pos('OPEN', OC) > 0) or (pos('SHORT', OC) > 0) // not sure yet about short sales
        then begin
          OC := 'O';
          LS := 'S';
        end
        else begin
          OC := 'C';
          LS := 'L';
        end;
      end
      else begin
        dec(R);
        Continue;
      end;
      // test for options
      if (pos('CALL ', descr) = 1) or (pos('PUT ', descr) = 1) then begin
        contracts := true;
        typeStr := 'OPT-100';
      end
      else begin
        contracts := false;
        typeStr := 'STK-1';
      end;
      // options
      if contracts then begin
        // FDX   20170120C  150.000
        tick := trim(tick);
        sUnderlying := parseFirst(tick, ' ');
        tick := trim(tick); // 2017-02-24 MB - too many spaces between underlying and exp. date!
        sStrike := trim(parseLast(tick, ' '));
        sStrike := delTrailingZeros(sStrike);
        tick := trim(tick);
        sCallPut := rightStr(tick, 1);
        if (sCallPut = 'P') then
          sCallPut := 'PUT'
        else if (sCallPut = 'C') then
          sCallPut := 'CALL';
        sExpYr := midStr(tick, 3, 2);
        sExpMo := midStr(tick, 5, 2);
        sExpMo := getExpMo(sExpMo);
        sExpDa := midStr(tick, 7, 2);
        tick := sUnderlying + ' ' + sExpDa + sExpMo + sExpYr + ' ' + sStrike + ' ' + sCallPut;
        descr := ''; // 2017-02-24 MB to prevent "convert descriptions to tickers"
      end;
        // sm(Impdate+' '+cr+OC+LS+'  '+tick+cr+shstr+cr+PrStr+cr+AmtStr+cr+typeStr);  continue;
      R := loadImpTradesArray(I, R, ImpDate, sTime, OC, LS, tick, ShStr, PrStr, AmtStr,
        typeStr, '');
    end;
    result := R;
  finally
    lineLst.Free;
  end;
end; // ReadApex2017


// ----------------------------------------------
function ReadCobraCSV(): integer;
var
  i, p, R, colCnt, custCol, asOfDateCol: integer;
  junk, ImpDate, tick, opTk, OC, LS, PrStr, ShStr, AmtStr, typeStr, line, descr: String;
  bHasCancels, contracts, impNextDateOn: boolean;
  lineLst : TStrings;
begin
  // To do: move this to Import.pas
  try
    R := 0;
    lineLst := TStrings.create;
    importHasDescr := false;
    custCol := 0;
    asOfDateCol := 0;
    if getCSVstrList = 0 then begin
      sm('There is no data to import.');
      Result := 0;
      exit;
    end;
    for i := 0 to ImpStrList.Count - 1 do begin
      contracts := False;
      inc(R);
      if R < 1 then R := 1;
      line := uppercase(trim(ImpStrList[i]));
      //parse all columns into string list
      lineLst := ParseCSVtext(line);
      //count columns
      colCnt := lineLst.Count;
      if (colCnt < 7) then begin
        dec(R);
        continue;
      end;
      { CSV COLUMN MAP
        "Date"0,"Action"1,"Quantity"2,"Symbol"3,"Description"4,"Price"5,"Amount"6,""7
      }
      //get trade record fields from csv file
      impDate := lineLst[0];
      OC := lineLst[1];
      //LS := lineLst[X];
      tick := trim(lineLst[3]);   //added trim 2014-06-25
      descr := lineLst[4];
      ShStr := lineLst[2];
      PrStr := lineLst[5];
      AmtStr := lineLst[6];
      if (impDate = '') or not isInt(copy(impDate,1,1))
      or not ValidTradeDate(ImpDate, ImpDateLast, ImpNextDateOn)
      then begin
        dec(R);
        continue;
      end;
      //long/short
      LS := 'L'; //must auto assign shorts
      // open/close
      if (pos('CANCEL-BUY', OC) = 1) then begin
        OC := 'X';
        LS := 'S';   // cancels a SELL
        bHasCancels := true;
      end
      else if (pos('CANCEL-SELL', OC) = 1) then begin
        OC := 'X';
        LS := 'L';    // cancels a BUY
        bHasCancels := true;
      end
      else if (pos('BUY', OC) = 1) then begin
        OC := 'O';
      end
      else if pos('SELL', OC) = 1 then begin
        OC := 'C'
      end
      else begin
        dec(R);
        continue;
      end;
      //test for options
      if (pos('PUT ',descr)=1) or (pos('CALL ',descr)=1) then begin
        contracts:=true;
        typeStr := 'OPT-100';
      end
      else begin
        contracts:=false;
        typeStr := 'STK-1';
      end;
      // if cusip use description instead
      if isInt(leftStr(tick, 3)) then
        tick := descr;
      //options
      if contracts then begin
        // symbol: "TSLA1431M185"  <-- need to get option ticker from symbol
        opTk := getOpTickFromSymbol(tick);
        // test for mini options
        if (rightStr(opTk,1) ='7') then begin
          delete(opTk,length(opTk),1);
          typeStr := 'OPT-10';
        end;
        // "PUT TESLA MOTORS INC $185   EXP 01/31/14 DEL"
        // "PUT SPDR S&P 500 ETF TR $160   EXP 07/20/13 UNIT SER 1"
        // "PUT PRANA BIOTECHNOLOGY $7   EXP 04/19/14 LTD SPONS ADR"
        tick := reformatOptionDescr(descr,opTk);
      end;
        //sm(Impdate+' '+cr+OC+LS+'  '+tick+cr+shstr+cr+PrStr+cr+AmtStr+cr+typeStr);  continue;
      R := loadImpTradesArray(i,R,impDate,'',oc,ls,tick,ShStr,PrStr,AmtStr,typeStr,'');
    end;
    ReverseImpTradesDate(R);
    if bHasCancels then matchCancels(R);
    Result := R;
  finally
    ImpStrList.free;
    lineLst.Free;
  end;
end; // ReadCobraCSV


// ==============================================
// COR Clearing / Speedtrader
// ==============================================
function ReadAxos(): integer;
var
  i, R, iDt, iTk, iShr, iPr, iAmt, k : integer;
  ImpDate, tick, OC, LS, PrStr, ShStr, AmtStr, typeStr, line, descr,
   opTick, opUnder, opStrike, opYr, opMon, opDay, opCP : string;
  contracts, hasCancels, impNextDateOn, bFoundHeader : boolean;
  shares, price, commis, amount, mult, nStrk : double;
  lineLst : TStrings;
  // --------------------------------------------
  // CSV COLUMN MAP (2 possibilities)
  // --------------------------------------------
  //  0 Trade Date	12/19/24             mm/dd/yy
  //  1 Settle Date	12/20/24
  //  2 Type	      MARGIN
  //  3 Symbol	    QQQ C 12/19/2024 516 = option
  //  4 Qty	        -1            negative = sell
  //  5 Price	      $2.74
  //  6 Principal	  $274.00
  //  7 SEC	        $0.01
  //  8 Commissions	$1.00
  //  9 ECN	        $0.00
  // 10 Net Amount	$272.99        negative = buy
  // --------------------------------------------
  // NOTES: there are no indicators for buy/sell,
  // long/short, or stock/option - these must all
  // be interpreted from other fields.
  // --------------------------------------------
  procedure SetFieldNums();
  var
    j : integer;
  begin
    // AXOS - 2025
    k := 0;
    for j := 0 to (lineLst.Count-1) do begin
      if lineLst[j] = 'TRADE DATE' then begin
        iDt := j;
        k := k OR 1;
      end
      else if lineLst[j] = 'SYMBOL' then begin
        iTk := j;
        k := k OR 2;
      end
      else if lineLst[j] = 'QTY' then begin
        iShr := j;
        k := k OR 4;
      end
      else if lineLst[j] = 'PRICE' then begin
        iPr := j;
        k := k OR 8;
      end
      else if lineLst[j] = 'NET AMOUNT' then begin
        iAmt := j;
        k := k OR 16;
      end;
    end;
    bFoundHeader := true;
  end;
  // --------------------------------------------
  function DecodeOptTk(sTk : string) : string;
  var
    sTemp : string;
    n : integer;
    lstOptTkParts : TStrings; // for parsing Option Tickers
  begin
    sTemp := sTk; // for debugging
    // Reset all local vars
    opUnder := '';
    opStrike := '';
    opYr := '';
    opMon := '';
    opDay := '';
    opCP := '';
    // --------------------------------
    // Symbol: QQQ C 12/19/2024 516
    //         tk CP mm/dd/yyyy $$$
    // --------------------------------
    opUnder := parsefirst(sTk, ' ');
    opCP := parsefirst(sTk, ' ');
    if opCP = 'C' then
      opCP := 'CALL'
    else if opCP = 'P' then
      opCP := 'PUT'
    else
      exit('');
    opStrike := parselast(sTk, ' '); // strike X mult
    if leftStr(opStrike, 1) = '$' then begin
      delete(opStrike, 1, 1);
    end;
    nStrk := strtofloat(opStrike);
    sTk := trim(sTk);
    opMon := parsefirst(sTk, '/');
    if length(opMon) < 2 then begin
      opMon := rightstr('00' + opMon, 2);
    end;
    opMon := getExpMo(opMon); // MMM
    opYr := parselast(sTk, '/');
    if length(opYr) > 2 then begin
      opYr := rightstr(opYr, 2);
    end;
    opDay := trim(sTk);
    opStrike := FloatToStr(nStrk);
    result := opUnder + ' ' + opDay + opMon + opYr + ' ' + opStrike + ' ' + opCP;
    contracts := true; // if it gets this far w/o error
  end;
  // --------------------------------------------
begin // ReadAxos
  hasCancels := false;
  bFoundHeader := false;
  R := 0;
  try
    iDt := -1; // let's us know we haven't found the header yet
    lineLst := TStrings.Create;
    // ----------------------
    // ONLY method is CSV/TXT file
    if getCSVstrList = 0 then begin
      sm('There is no data to import.');
      result := 0;
      exit;
    end;
    // ----------------------
    for i := 0 to ImpStrList.Count - 1 do begin
      contracts := false;
      line := uppercase(trim(ImpStrList[i]));
      // parse all columns into string list
      lineLst := ParseCSVtext(line);
      // ------------------------------
      // Determine File Format
      // ------------------------------
      if not bFoundHeader then begin
        if (pos('TYPE,SYMBOL,', line) > 0) // NO quotes at all
        and (pos('TRADE DATE', line) > 0) // 2025-05-07 MB
        then begin // Trade Date,Settle Date,Type,Symbol,Qty,Price,...,Net Amount
          SetFieldNums;
          if k = 31 then begin
            bFoundHeader := true; // don't do this anymore
            R := 0; // start now
          end
          else if (SuperUser or Developer) then begin
            sm('There appear to be fields missing:' + cr //
              + line);
          end;
        end;
        continue; // don't process anything until we recognize the header
      end;
      // ----------------------------------------------------------------
      // Trade Date Symbol_______________  Qty Price	 Net     Buy/  STK/
      // mm/dd/yy   Tk c/p expireDt $Strk              Amount  Sell? OPT?
      // 12/19/24   QQQ C 12/19/2024 516	 -1	 $2.74  $272.99  SELL  OPT
      // 12/19/24   QQQ C 12/19/2024 516	  1  $2.62 -$263.00	 BUY 	 OPT
      // ----------------------------------------------------------------
      // get trade record fields from csv file
      ImpDate := lineLst[iDt];
      tick := lineLst[iTk];
      ShStr := lineLst[iShr];
      PrStr := lineLst[iPr];
      AmtStr := lineLst[iAmt];
      if (leftstr(AmtStr,1) = '(') //
      and (rightstr(AmtStr,1) = ')') //
      then begin
        AmtStr := '-' + parsehtml(AmtStr,'(',')');
      end;
      // date format (mm/dd/yy) is already correct
      if (ImpDate = '') //
      or not ValidTradeDate(ImpDate, ImpDateLast, impNextDateOn) //
      then begin
        Continue;
      end;
      Inc(R); // this might be a good row, so count it...
      if R < 1 then R := 1;
      // convert text to numbers
      try
        Shares := CurrToFloat(ShStr);
        Price := CurrToFloat(PrStr);
        Amount := CurrToFloat(AmtStr);
        // multiplier
        if Price <> 0 then begin
          mult := round(ABS(Amount / Price));
        end;
        // option or stock type?
        typeStr := 'STK'; // assume for now
        contracts := false; // assume for now
        opTick := DecodeOptTk(tick);
        if contracts then begin
          mult := 100;
          typeStr := 'OPT-100';
          tick := opTick;
        end
        else begin
          mult := 1;
          typeStr := 'STK-1';
        end;
        // check sign of Shr & Amt for buy/sell
        LS := 'L'; // must assume long, let TL determine if short
        if (Shares < 0) then begin // confirm it's a sell
          if (Amount >= 0) then begin
            OC := 'C'; // close long
          end
          else begin
            OC := 'E'; // contradictory
            continue;
          end;
        end
        else if (Shares > 0) then begin // confirm it's a buy
          if (Amount < 0) then begin
            OC := 'O'; // open long
          end
          else begin
            OC := 'E'; // contradictory
            continue;
          end;
        end
        else begin // skip this trade
          OC := 'E'; // contradictory
          continue;
        end;
        // simplified commission formula
        Commis := Amount - (-Shares * Price * mult);
        //
      except
        DataConvErrRec := DataConvErrRec + ImpStrList[i] + cr;
        dec(R);
        continue;
      end;
      // good record, so add it
      ImpTrades[R].it := TradeLogFile.Count + R;
      ImpTrades[R].dt := ImpDate;
      ImpTrades[R].tm := '';
      ImpTrades[R].OC := OC;
      ImpTrades[R].LS := LS;
      ImpTrades[R].tk := tick;
      ImpTrades[R].sh := abs(Shares); // always positive
      ImpTrades[R].pr := abs(Price); // always positive
      ImpTrades[R].prf := typeStr;
      ImpTrades[R].cm := -Commis; // negative means you PAID
      ImpTrades[R].am := Amount; // positive means you RECV'D
      result:= R;
    end; // for loop
    fixImpTradesOutOfOrder(R);
    result := R;
  finally
    ImpStrList.Free;
    lineLst.Free;
  end;
end; // ReadAxos


// ----------------------------------------------
// Also Used for SpeedTrader Pro*
// ------ handler and old format reader ---------
function ReadETC(): integer;
var
  sTest : string;
  lineLst : TStrings;
  // ----------- Speedtrader Pro ----------------
  function ReadSpeedTrader(): integer;
  var
    I, R, colCnt : integer;
    ImpDate, tick, OC, LS, PrStr, ShStr, AmtStr, typeStr, line, S : string;
    impNextDateOn : boolean;
    lineLst : TStrings;
    // ----------------------
    function ConvLongDateStr(sLongDate : string): string;
    var
      sMm, sDd, sYy, t : string;
    begin
      // EX: Mon, 17 Oct 2016 12:00:00 am EDT
      S := parseFirst(sLongDate, ','); // Mon,
      t := trim(sLongDate);
      sDd := parseFirst(t, ' '); // 17 = day of month
      S := parseFirst(t, ' '); // Oct
      S := uppercase(S);
      sMm := getExpMoNum(S);
      sYy := parseFirst(t, ' '); // 2016 = year
      result := sMm + '/' + sDd + '/' + sYy;
    end;
  // ----------------------------------
  // NOTE: Regular Speedtrader (not Pro)
  // ----------------------------------
  begin
    try
      R := 0;
      for I := 1 to ImpStrList.Count - 1 do begin
        Inc(R);
        if R < 1 then
          R := 1;
        line := uppercase(trim(ImpStrList[I]));
        if Length(line)< 100 then begin
          dec(R);
          Continue;
        end;
        // parse all columns into string list
        lineLst := ParseCSVtext(line);
        // count columns
        colCnt := lineLst.Count;
        if (colCnt < 18) then begin
          dec(R);
          Continue;
        end;
        // CSV COLUMN MAP
        // ----- new format 2017-02-23 MB -----------------
        //##  Import	 Field name	        Example1	       Example2
        // 0           account_type	      MARGIN	         MARGIN
        // 1	OC       action	            Sale	           Purchase
        // 2	         activity_code
        // 3	AmtStr   amount	            5379.83	         -5459.74
        // 4	ImpDate  as_of_date	        Mon, 17 Oct 2016 12:00:00 am EDT (same in each)
        // 5 	         check_number
        // 6	comm     commission	        18.23	           16.72
        // 7	         commission_in_gross	N	               N
        // 8	         contra_broker
        // 9	tick     cusip	            674870407	       674870407
        //10	         customer	          88701740	       88701740
        //11	desc     description	      OCEAN POWER TECHNOLOGIES INC PAR $ (same in each)
        //12	         effective_date	    Thu, 20 Oct 2016 12:00:00 am EDT (same in each)
        //13	         exchange_rate	    1	               1
        //14	         fees	              0.12	           -0.04
        //15	         from_location
        //16	         held_currency_code	USD	        (same for both)
        //17	         interest	          0	          (same for both)
        //18	         maturity_date
        //19	         order_number
        //20	         output_currency_code USD	      (same for both)
        //21	         payee
        //22	PrStr    price	            3.1754	         3.2018
        //23	         principal	        5398.18	         -5443.06
        //24	ShStr    quantity	          -1700	           1700
        //25	         sales_credit	      0	               0
        //26	         security_class_code
        //27	         security_type	    EQUITY	    (same for both)
        //28	         symbol	            EQUITY OPTT	(same for both; looks like ticker!)
        //29	         tax_exempt_status  N/A	             N/A
        //30	         taxes	            0	               0
        //31	         to_location
        //32	         transaction_date	  Mon, 17 Oct 2016 12:00:00 am EDT (same in each)
        //33	         user_defined_action
        // ------------------------------------------------
        // get trade record fields from csv file
        // skip non trade lines
        S := uppercase(lineLst[1]); // action type
        if (S = 'SALE') then
          OC := 'C'
        else if (S = 'PURCHASE') then
          OC := 'O'
        else begin
          dec(R);
          Continue;
        end;
        // Date
        ImpDate := lineLst[4];
        ImpDate := ConvLongDateStr(ImpDate);
        if (ImpDate = '') or not ValidTradeDate(ImpDate, ImpDateLast, impNextDateOn) then begin
          dec(R);
          Continue;
        end;
        LS := 'L'; // always must assume Long at first
        // description (no ticker)
        tick := lineLst[28];
        S := parseFirst(tick, ' ');
        if (S <> 'EQUITY') or (tick = 'EQUITY') or (tick = '') then
          tick := lineLst[9]; // use CUSIP
        ShStr := lineLst[24];
        PrStr := lineLst[22];
        AmtStr := lineLst[3];
        // --
        typeStr := 'STK-1'; // assume always
        // sm(Impdate+' '+cr+OC+LS+'  '+tick+cr+shstr+cr+PrStr+cr+AmtStr+cr+typeStr);  continue;
        R := loadImpTradesArray(I, R, ImpDate, '', OC, LS, tick, ShStr, PrStr, AmtStr, typeStr, '');
      end;
      fixImpTradesOutOfOrder(R);
    finally
      result := R;
    end;
  end; // ReadSpeedTrader

  // ----------------------------------
  function ReadoldETC(): integer;
  var
    I, j, R, colCnt : integer;
    ImpDate, tick, OC, LS, PrStr, ShStr, AmtStr, typeStr, line, S : string;
    impNextDateOn : boolean;
    lineLst : TStrings;
  begin // ReadoldETC
    try
      R := 0;
      for I := 0 to ImpStrList.Count - 1 do begin
        Inc(R);
        if R < 1 then
          R := 1;
        line := uppercase(trim(ImpStrList[I]));
        if Length(line)< 100 then begin
          dec(R);
          Continue;
        end;
        // parse all columns into string list
        lineLst := ParseCSVtext(line);
        // count columns
        colCnt := lineLst.Count;
        if (colCnt < 18) then begin
          dec(R);
          Continue;
        end;
        // check for new format - 2017-06-23 - MB
        if (colCnt >= 20) then begin
          for j := 5 to 17 do begin
            lineLst[j - 1] := lineLst[j];
          end;
          for j := 19 to (colCnt - 1) do begin
            lineLst[j - 2] := lineLst[j];
          end;
          colCnt := (colCnt - 2);
        end;
        // CSV COLUMN MAP
        // ----- old format ---------------------
        //  1	= 0
        //  Tr No	= 1
        //  System Date	= 2
        //  Trade Date	= 3  ie: 2015-05-13 <or may be mm/dd/yyyy>
        //    <may have optional Settle Date>
        //  Account	= 4
        //  Company Name = 5
        //  Account Type = 6
        //  Symbol = 7
        //  Side = 8  ie: B, S, SS
        //  QTY	= 9
        //  Price	= 10
        //  Gross Amount = 11
        //  Net Amount = 12
        //  Commission = 13
        //  Reg Fee	= 14
        //  PTFPF	= 15
        //  ECN Fee	= 16
        //    <may have optional TAF Fee>
        //  Broker Fee	= 17
        //  Fees = 18
        // --------------------------------------
        // get trade record fields from csv file
        ImpDate := lineLst[3];
        // skip header line
        if (isInt(leftStr(ImpDate, 4))) then begin
          // reformat date ie: 2015-01-02 to 01/02/2015
          ImpDate := midStr(ImpDate, 6, 2)+ '/' + rightStr(ImpDate, 2)+ '/' + leftStr(ImpDate, 4);
        end
        else if (isInt(rightStr(ImpDate, 4))) then begin
          // impDate may already be in m/d/yyyy format
        end
        else begin
          dec(R);
          Continue;
        end;
        // sm(impDate);
        tick := lineLst[7];
        OC := lineLst[8];
        ShStr := lineLst[9];
        PrStr := lineLst[10];
        AmtStr := lineLst[12];
        if (ImpDate = '') or not ValidTradeDate(ImpDate, ImpDateLast, impNextDateOn) then begin
          dec(R);
          Continue;
        end;
        LS := 'L';
        if (OC = 'B') then
          OC := 'O'
        else if (OC = 'S') then
          OC := 'C'
        else if (OC = 'SS') then begin
          OC := 'O';
          LS := 'S';
        end
        else begin
          dec(R);
          Continue;
        end;
        // --
        typeStr := 'STK-1';
        // sm(Impdate+' '+cr+OC+LS+'  '+tick+cr+shstr+cr+PrStr+cr+AmtStr+cr+typeStr);  continue;
        R := loadImpTradesArray(I, R, ImpDate, '', OC, LS, tick, ShStr, PrStr, AmtStr, typeStr, '');
      end;
      fixImpTradesOutOfOrder(R);
    finally
      result := R;
    end;
  end; // ReadOldETC

  // ----------------------------------
begin
  // ReadETC
  try
    lineLst := TStrings.Create;
    importHasDescr := false;
    // CSV Import -----------
    if (getCSVstrList = 0) //
    or (ImpStrList.Count < 1) then begin
      sm('There is no data to import.');
      result := 0;
    end
    else begin
      sTest := lowercase(trim(ImpStrList[0]));
      if pos('"account_type","action","activity_code","amount","as_of_date",', sTest) = 1 then
        result := ReadSpeedTrader
      else
        result := ReadoldETC;
    end; // -----------------
  finally
    ImpStrList.Free;
    lineLst.Free;
  end;
end; // ReadETC


         // ---------------------------
         //         Lightspeed
         // ---------------------------

function ReadLightspeedCSV(webCopy:boolean): integer;
var
  i, j, p, R, colCnt, custCol, asOfDateCol: integer;
  junk, ImpDate, sTime, tick, opTk, OC, LS, PrStr, ShStr, AmtStr,
    sType, feeStr, cmStr, currStr, convStr, line, descr: String;
  hh, mm, ss : string;
  bCancel, hasCancels, contracts, impNextDateOn: boolean;
  commis : double;
  lineLst, timeLst : TStrings;
  function fixtime(s : string) : string;
  begin
    if (length(s) = 4) then begin
      hh := copy(s,0,2);
      mm := copy(s,2,2);
      result := hh + ':' + mm + ':00';
    end
    else if (pos(':',s)>0) then begin
      timeLst := parsecsvtext(s,':');
      if (timeLst.Count < 2) then
        result := s
      else begin
        hh := timeLst[0];
        while length(hh) < 2 do hh := '0' + hh;
        mm := timeLst[1];
        if timeLst.Count = 2 then
          result := hh + ':' + mm + ':00'
        else
          result := hh + ':' + mm + ':' + timeLst[2];
      end;
    end;
  end;
begin
  // ReadLightpseed
  try
    R := 0;
    lineLst := TStrings.create;
    importHasDescr := false;
    hasCancels := false;
    custCol := 0;
    asOfDateCol := 0;
    // -----------------
    if not webCopy then
      getCSVstrList //                <---
    else
      GetImpDateLast;
    screen.Cursor := crHourglass;
    // -----------------
    if (ImpStrList.Count = 0) then begin
      Result := 0;
      exit;
    end;
    // -----------------
    for i := 0 to ImpStrList.Count - 1 do begin
      contracts := false;
      bCancel := false;
      inc(R);
      if R < 1 then R := 1;
      line := uppercase(trim(ImpStrList[i]));
      if (pos(',',line) = 0) then begin
        dec(R);
        continue;
      end;
      // ---------------
      //parse all columns into string list
      lineLst := ParseCSVtext(line);
      //count columns
      colCnt := lineLst.Count;
      if (colCnt < 7) then
      begin
        dec(R);
        continue;
      end;
      // -----------------
      // CSV COLUMN MAP
      //  date,time,type,b/s,symbol,desc,qty,price,fees,comm,curr,conv
      //get trade record fields from csv file
      impDate := lineLst[0];
      sTime := fixtime(lineLst[1]);
      if not IsTime(sTime) then
        if length(sTime)=4 then
          sTime := leftstr(sTime,2) + ':' + rightstr(sTime,2)
        else if (length(sTime)=7) then
          sTime := '0' + sTime
        else
          sTime := '';
      sType := lowercase(lineLst[2]);
      OC := lineLst[3];
      tick := trim(lineLst[4]);
      descr := lineLst[5];
      ShStr := lineLst[6];
      PrStr := lineLst[7];
      feeStr := lineLst[8];
      cmStr := lineLst[9];
      currStr := lineLst[10];
      convStr := lineLst[11];
      AmtStr := '';
      // --------------------
      if (impDate = '')
      or not isInt(copy(impDate,1,1))
      or not ValidTradeDate(ImpDate, ImpDateLast, ImpNextDateOn)
      then begin
        dec(R);
        continue;
      end;
      // --- long/short -----
      if (pos('TO OPEN',OC) > 0)
      or (pos('TO CLOSE',OC) > 0)
      then
        contracts := true;
      // --------------------
      if (pos('CANCEL',OC) > 0) then
      begin
        bCancel := true;
        hasCancels := true;
      end;
      // --- open/close -----
      if (pos('LONG BUY', OC) = 1)
      or (pos('BUY TO OPEN', OC) = 1)
      or (OC = 'B')
      then begin
        OC := 'O';
        LS := 'L';
      end else
      if (pos('LONG SALE', OC) = 1)
      or (pos('LONG SELL', OC) = 1)
      or (pos('SELL TO CLOSE', OC) = 1)
      or (OC = 'C')
      then begin
        OC := 'C';
        LS := 'L';
      end else
      if (pos('SHORT SALE', OC) = 1)
      or (pos('SELL TO OPEN', OC) = 1)
      or (OC = 'S')
      then begin
        OC := 'O';
        LS := 'S';
      end else
      if (pos('BUY TO COVER', OC) = 1)
      or (pos('BUY TO CLOSE', OC) = 1)
      or (OC = 'T')
      then begin
        OC := 'C';
        LS := 'S';
      end else
      begin
        dec(R);
        continue;
      end;
      // --------------------
      if bCancel then OC := 'X';
      // --------------------
      //test for options
      if (pos('put',sType)=1)
      or (pos('call',sType)=1)
      or (contracts = true)
      then begin
        contracts:=true;
        sType := 'OPT-100';
      end else
      begin
        contracts:=false;
        sType := 'STK-1';
        tick := trim(tick);
      end;
      // --------------------
      //options
      if contracts then
      begin
        // symbol: CYBR141122C00001020  or  AAPL160115C00008100
        opTk := getOpTickFromSymbol(tick);
        // test for mini options
        if (rightStr(opTk,1) ='7') then
        begin
          delete(opTk,length(opTk),1);
          sType := 'OPT-10';
        end;
        tick := reformatOptionSymbol(tick, descr);
        if CheckOptionFormat(tick) = false then
          tick := reformatOptionSymbol(descr);
      end
      else begin
        if not isTickerSymbol(tick) then
          tick := descr; // for Lightspeed, use descr instead of CUSIP - MB
      end;
      // ---------------
      commis := strToFloat(cmStr); //removed '+ strToFloat(feeStr)' - 2015-02-23 MB
      cmStr := floatToStr(commis);
      // ---------------
      R := loadImpTradesArray(i,R,impDate,sTime,oc,ls,tick,ShStr,PrStr,AmtStr,sType,cmStr);
    end; // for i := 0 to ImpStrList.Count - 1
    // ----------------------
    if hasCancels then matchCancels(R);
//    ReverseImpTradesDate(R);
    Result := R;
  finally
    ImpStrList.free;
    lineLst.Free;
    screen.Cursor := crDefault;
  end;
end; // ReadLightspeed


function ReadMBTradingCSV(): integer;
var
  i, R, colCnt: integer;
  ImpDate, sTime, tick, OC, LS, PrStr, ShStr, AmtStr, typeStr, line, descr, tradeType: String;
  sUnderlying, sStrike, sCallPut, sExpDa, sExpMo, sExpYr, sJunk : string;
  contracts, impNextDateOn: boolean;
  lineLst : TStrings;
  function IsDate(str: string): Boolean;
  var
    dt: TDateTime;
  begin
    Result := True;
    try
      dt := StrToDate(str);
    except
      Result := False;
    end;
  end;
begin
  try
    bMBTrading := true;
    TradeLogFile.CurrentAccount.AutoAssignShorts := false;
    R := 0;
    lineLst := TStrings.create;
    for i := 0 to ImpStrList.Count - 1 do
    begin
      contracts := False;
      inc(R);
      if R < 1 then R := 1;
      line := uppercase(trim(ImpStrList[i]));
      // skip if not a trade record
      if (pos('ACCOUNTNUMBER,ACCOUNTTYPEDESCRIPTION,OFFICECODE,', line)=1) then
      begin
        dec(R);
        continue;
      end;
      //parse all columns into string list
      lineLst := ParseCSVtext(line);
      { CSV COLUMN MAP
        0-AccountNumber
        1-AccountTypeDescription  = some useful codes, like "Short"
          2-OfficeCode
          3-RegisteredRepCode
        4-TradeDate               = 1/19/15  <-- need to change to 01/19/2015
          5-ExecutionTime
          6-SettlementDate
          7-OriginalTradeNumber
          8-TradeNumber
        9-BuySellCode             = "B" or "S"
        10-Symbol                 = not sure if useful
        11-CUSIP                  = CUSIP
        12-Quantity               = positive (B) OR negative (S)
        13-Price                  = always positive
          14-PrincipalAmount        = qty * price
        15-CommissionGrossCalculated = postive (reduces negatives)
        16-OtherCommission           = add to 15
        17-NetAmount              = 14 + 15 + 16
          18-ExecutingBrokerBack
          19-EntryDate
          20-ProcessDate
          21-Currencycode
          22-Trailer
      }
      //get trade record fields from csv file
      tradeType := uppercase(lineLst[1]);
      impDate := lineLst[4];
      // skip if not a trade record
      // or outside of our date range
      impDate := longDateStr(impDate);
      if (impDate = '') or not isDate(impDate) //
      or not ValidTradeDate(ImpDate, ImpDateLast, ImpNextDateOn) then begin
        dec(R);
        continue;
      end;
      sTime := ''; // we can't use execution time can we?
      if lineLst[1] = 'Short' then begin // Short buy=close, sell=open
        LS := 'S';
        if lineLst[9] = 'B' then
          OC := 'C'
        else
          OC := 'O';
      end
      else begin // Long buy=open, sell=close
        LS := 'L';
        if lineLst[9] = 'B' then
          OC := 'O'
        else
          OC := 'C';
      end;
      tick := uppercase(lineLst[10]); // Symbol
      descr := uppercase(lineLst[10]); // Symbol
      ShStr := lineLst[12]; // Qty
      PrStr := lineLst[13]; // Price
      AmtStr := lineLst[17]; // Net Amount
      //test for options (I'm guessing here!)
      if (pos('CALL ',descr) = 1) or (pos('PUT ',descr) = 1) then begin
        contracts := true;
        typeStr := 'OPT-100';
      end
      else begin
        contracts := false;
        typeStr := 'STK-1';
      end;
      //options
      if contracts then begin
        // FDX   20170120C  150.000
        tick := trim(tick);
        sUnderlying := parseFirst(tick, ' ');
        sStrike := trim(parseLast(tick, ' '));
          sStrike := delTrailingZeros(sStrike);
        tick := trim(tick);
        sCallPut := rightStr(tick, 1);
          if (sCallPut = 'P') then sCallPut := 'PUT' else
          if (sCallPut = 'C') then sCallPut := 'CALL';
        sExpYr := midStr(tick, 3, 2);
        sExpMo := midStr(tick, 5, 2);
          sExpMo := getExpMo(sExpMo);
        sExpDa := midStr(tick, 7, 2);
        tick := sUnderlying +' '+ sExpDa +sExpMo+sExpYr +' '+ sStrike +' '+ sCallPut;
      end;
      R := loadImpTradesArray(i,R,impDate,sTime,oc,ls,tick,ShStr,PrStr,AmtStr,typeStr,'');
    end;
    Result := R;
  finally
    lineLst.Free;
  end;
end; // ReadMBTradingCSV


initialization

end.
