unit TLDatabase;

//{$I DICompilers.inc}
//{$I DISQLite3.inc}

interface

uses
// RJ Remove Vcl.Dialogs */
  Winapi.Windows, Winapi.Messages, System.Classes, System.SysUtils,  Vcl.Dialogs;
  //DISystemCompat,
  //DISQLite3DataSet, , DISQLite3Database,
//  DISQLite3Api;

function dbFileConnect(const TDBname: string; bCreate: boolean = false): boolean;
procedure dbFileDisconnect;
function dbFileCreate(fName:string): boolean;
procedure dbBeginTrans;
procedure dbCommitTrans;
function dbInsertLine(lineStr: string): boolean;
procedure getLinesFromDB(var lineList:TStringList; numLines:integer=0);

// ********************************
// ROUTINES USED FOR FLAG TABLE
// ********************************
function dbUpdateTables(): boolean; // add new tdfFlags table - 2016-11-07 MB
function dbGetFlag(sName: string): string; // read flag from tdfFlags table
function dbSetFlag(sName, sFlag: string): boolean; // set flag - 2016-11-07 MB
function TableRowCount(sTable: string): integer; // count rows in Table 2025-12-17 RJ


implementation

uses
  TLCommonLib, funcProc, globalVariables, uDM;

var
//  pDB: sqlite3_ptr;       // added pTDF for read/write DB IO - 2016-11-09 MB
  SQLiteAPIconnected, SQLiteTDFconnected : boolean; // ...and new flag also

const
  glEncrytionPW = 'armenTL14';

// ********************************
// FUNCTIONS USED IN THIS UNIT ONLY
// ********************************
function TableExists(sTable:string): boolean;
var
//  pQry: sqlite3_stmt_ptr;
  tSQL: string;
begin
  tSQL := 'SELECT count(name) nameCount FROM sqlite_master WHERE type="table" AND name="' + sTable + '"';
  try
    with DM.qry do begin
      SQL.Clear;
      Close;
      Connection := DM.fDB;
      SQL.Text := 'SELECT count(name) nameCount FROM sqlite_master WHERE type="table" AND name="' + sTable + '"';
      SQL.Text := tSQL;
      Open;
      var cnt : integer := DM.qry.Fields[0].AsInteger;
      result := true;
      Close;
    end;
  finally
    DM.qry.Close;
  end;
end;

function createTable(): boolean;
var
  i: integer;
  tSQL: string;
begin
  result := true;
  tSQL :=
    '"lineNum" INTEGER PRIMARY KEY,' + // auto-number ID
    '"lineStr" TEXT';                  // contains each line of tdf file
  try
    with DM.qry do begin
      SQL.Clear;
      Close;
      SQL.Text := 'CREATE TABLE IF NOT EXISTS tdfFile (' + tSQL + ')';
      ExecSQL;
      Close;
    end;
  finally
    DM.qry.Close;
  end;
end;

// ********************************
// FUNCTIONS USED OUTSIDE THIS UNIT
// ********************************

function dbFileConnect(const TDBname: string; bCreate: boolean = false): boolean;
begin
  result := false; // initially assume failure
  try
    with DM.fDB do begin
      Connected := false;
      ConnectionName := TDBname;
      Connected := true;

      ExecSQL('PRAGMA foreign_keys = ON');
      ExecSQL('PRAGMA page_size = 4096');
      ExecSQL('PRAGMA cache_size = 16384');
      ExecSQL('PRAGMA temp_store = MEMORY');
      ExecSQL('PRAGMA journal_mode = WAL');
      ExecSQL('PRAGMA locking_mode = NORMAL');
      ExecSQL('PRAGMA synchronous = NORMAL');
      ExecSQL('PRAGMA mmap_size = 134217728');
    end;
    // New connection to database for loading data
//    sqlite3_check(sqlite3_initialize);
//    sqlite3_check(sqlite3_open16(pWideChar(TDBname), @pDB), pDB);
    // use rekey when opening, key when reconnecting
//    if (glEncrytionPW <> '') then begin
//      if bCreate then
//        sqlite3_check(sqlite3_rekey(pDB, glEncrytionPW, length(glEncrytionPW)))
//      else
//        sqlite3_check(sqlite3_key(pDB, glEncrytionPW, length(glEncrytionPW)));
//    end;
    // got these settings from: http://qt-project.org/forums/viewthread/9090
//    sqlite3_exec_fast(pDB, 'PRAGMA page_size = 4096');
//    sqlite3_exec_fast(pDB, 'PRAGMA cache_size = 16384');
//    sqlite3_exec_fast(pDB, 'PRAGMA temp_store = MEMORY');
//    sqlite3_exec_fast(pDB, 'PRAGMA journal_mode = OFF');
//    sqlite3_exec_fast(pDB, 'PRAGMA locking_mode = NORMAL');
//    sqlite3_exec_fast(pDB, 'PRAGMA synchronous = OFF');
    SQLiteAPIconnected := true;
    result := true;
    DM.fDB.Connected := false;
    DM.fDB.DriverName := 'SQLite';
  except
    on E: Exception do
    begin
      //
      exit;
    end;
  end;

end;

procedure dbFileDisconnect;
begin
  if SQLiteAPIconnected then begin
    DM.fDB.Close;
    SQLiteAPIconnected := false;
  end;
end;


function dbFileCreate(fName:string): boolean;
begin
  result := true;
  if not dbFileConnect(fName, true) then result := false;
  if result then
    if not CreateTable then result := false; // tdfFiles
  if result then
    if not dbUpdateTables then begin
      sm('Internal error: dbUpdateTables failed.' + CRLF //
        + 'If this error persists, please contact TradeLog Support.');
      result := false; // tdfFlags
    end;
  if result then
    TrFileName := extractFileName(fName);
  // IMPORTANT: This is called by SaveFileAs and SaveTList,
  // and it leaves TradeLog connected to the database
  // so the calling routine needs to close with dbFileDisconnect.
end;


procedure dbBeginTrans;
begin
//  sqlite3_exec_fast(pDB, 'BEGIN TRANSACTION;');
end;

procedure dbCommitTrans;
begin
//  sqlite3_exec_fast(pDB, 'COMMIT TRANSACTION;');
end;


function dbInsertLine(lineStr: string): boolean;
var
  sTmp : string;
  MyClass: TObject;
begin
  result := true;
  // if Values string has quote characters, escape them
  if POS('"', lineStr) > 0 then
    sTmp := StringReplace(lineStr,'"','""', [rfReplaceAll])
  else
    sTmp := lineStr;
    try
      with DM.qry do begin
        SQL.Clear;
        SQL.Text := 'INSERT INTO tdfFile (lineStr) VALUES ("'+sTmp+'")';
        ExecSQL;
      end;
    finally
      DM.qry.Close;
    end;
end;

procedure getLinesFromDB(var lineList:TStringList; numLines:integer=0);
// stuff all tdfFile lines into lineList
var
//  pQry: sqlite3_stmt_ptr;
  sSQL, lineStr: string;
  L : integer;
begin
  L := 0;
  try
    DM.fDB.Connected := true;
    with DM.qry do begin
      SQL.Clear;
      Close;
      Connection := DM.fDB;
      SQL.Text := 'SELECT lineStr FROM tdfFile';
//      DM.fDB.DriverName := 'SQLite';
//      DM.fDB.Params.Add('DriverID=SQLite');
      Active := true;
//      var db := DM.fDB.params.database;
      while not DM.qry.EOF do begin
        inc(L);
        lineList.Add((Fields[0].asString));
        if (L >= numLines-1) and (numLines > 0) then
          break;
        next;
      end;
      Close;
    end;
  finally
    DM.qry.Close;
  end;
end;


// ********************************
// ROUTINES USED FOR FLAG TABLE
// ********************************
function dbUpdateTables(): boolean;
var
  i: integer;
  tSQL: string;
begin
  result := true;
  try
    try
      with DM.qUpdateTables do begin
        Close;
        ExecSQL;
      end;
    finally
      result := true;
    end;
  except
    on E: Exception do
    begin
      result := false;
      exit;
    end;
  end;
end;

// ------------------------------------
// Read any flag from tdfFlags table
// ------------------------------------
function dbGetFlag(sName: string): string;
var
//  pQry: sqlite3_stmt_ptr;
  sFlag, tSQL: string;
begin
  sFlag := '';
  try
    If NOT TableExists('tdfFlags') then
      exit('');
    tSQL := 'SELECT sFlag FROM tdfFlags WHERE sName="' +sName +'"';
    with DM.qry do begin
      SQL.Clear;
      Close;
      SQL.Text := tSQL;
      Open;
      result := Fields[0].AsString;
      Close;
    end;
//    sqlite3_check(sqlite3_prepare16(pDB, pWideChar(tSQL), -1, @pQry, nil), pDB);
//    try
//      if sqlite3_check(sqlite3_step(pQry), pDB) = SQLITE_ROW then begin
//        sFlag := sqlite3_column_text(pQry, 0);
//      end;
//    finally
//      sqlite3_finalize(pQry);
//      result := sFlag;
//    end;
  except
    On E: Exception do
    begin
      result := '';
    end;
  end;
end;

// ------------------------------------
// Write any flag to tdfFlags table
// ------------------------------------
function dbSetFlag(sName, sFlag: string): boolean;
var
  tSQL: string;
begin
  result := true;
  try
    tSQL := 'INSERT INTO tdfFlags ("sName", "sFlag") VALUES("'
      + sName + '","' + sFlag + '")';
    with DM.qry do begin
      SQL.Clear;
      SQL.Text := tSQL;
      ExecSQL;
    end;
//    try
//      sqlite3_exec_fast(pDB, tSQL);
//    finally
//      //
//    end;
  except
    On E: Exception do begin
      result := false;
    end;
  end;
end;

function TableRowCount(sTable: string): integer;
begin
  with DM.qcnt do begin
    Close;
    SQL.Clear;
    SQL.Text := 'SELECT Count(*) AS cnt FROM ' + sTable;
    Active := true;
    Open;
    result := FieldByName('cnt').AsInteger;
    Close;
  end;
end;

end.
