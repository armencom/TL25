unit OSIdentifier;

interface

uses
  Winapi.Windows,
  System.SysUtils,
  VCL.Dialogs,
  Classes,
  NB30,
  Forms,
  Messages,
  Variants,
  StdCtrls,
  ExtCtrls,
  ComCtrls;


procedure GetOSInfo;

// ----------------

implementation

uses
  TLSettings,
  TLCommonLib,
  funcProc,
  StrUtils,
  TL_API, globalVariables,
  WinAPI.ShellAPI;

// ----------------------------------------------
//
// ----------------------------------------------
function ExecWithShell(AName, CLine: string; run_mode: string;
  var hProcess: DWord; var iErr: int64; bVis : boolean = false): boolean;
var
  ShExecInfo: TShellExecuteInfo;
begin
  Result := False;
  hProcess := 0;
  ZeroMemory(@ShExecInfo, SizeOf(ShExecInfo));
  ShExecInfo.cbSize := sizeof(ShExecInfo);
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


//-----------------------------------------------
// Search text file for a text string (T/F)
//-----------------------------------------------
function SearchFileForString(sFile, sSearch : string): Boolean;
var
  myFile : TextFile;
  text : string;
begin
  Result := false;
  AssignFile(myFile, sFile);
  try
    Reset(myFile);
    while not Eof(myFile) do begin
      ReadLn(myFile, text);
      if Pos(sSearch, text) > 0 then
        exit(TRUE);
    end;
  finally
    CloseFile(myFile);
  end;
end;


//-----------------------------------------------
// send support files via SFTP / Putty
//-----------------------------------------------
procedure GetOSInfo;
var
  hProcess: DWord;
  iErr: int64;
  sDir, sZipFile, sPSCP, sMsg, s: string;
  pw1, pw2 : PWideChar;
  sOutFile, ext, BatchFileName : string;
  BatFile : textFile;
  i : integer;
begin
  try
    sDir := Settings.DataDir; // GetCurrentDir;
    sOutFile := sDir + '\upload.txt';
    deletefile(sDir + '\sema4.txt');
    if fileExists(sOutFile) then deletefile(sOutFile); // don't allow injection!
    // ------------
    BatchFileName := sDir + '\getOS' //
      + formatdatetime('yyyymmdd-hhmmss', now)+ '.bat';
    if fileExists(BatchFileName) then deletefile(BatchFileName); // don't allow injection!
    AssignFile(BatFile, BatchFileName);
    Rewrite(BatFile);
      if not Developer then begin
        write(BatFile, '@echo off' + CRLF);
      end;
      write(BatFile, 'systeminfo | findstr /B /C:"OS Name" /C:"OS Version" > "' + sOutFile + '"' + CRLF);
      write(BatFile, CRLF);
      write(BatFile, 'ipconfig /all | findstr /C:"Physical Address" >> "' + sOutFile + '"' + CRLF);
      write(BatFile, CRLF);
      write(BatFile, 'setlocal' + CRLF);
      write(BatFile, 'for /f "tokens=2 delims==" %%i in (''wmic computersystem get manufacturer /value ^| findstr "="'') do set "Manufacturer=%%i"' + CRLF);
      write(BatFile, 'for /f "tokens=2 delims==" %%i in (''wmic computersystem get model /value ^| findstr "="'') do set "Model=%%i"' + CRLF);
      write(BatFile, 'if /i "%Manufacturer%"=="Parallels Software International Inc." (' + CRLF);
      write(BatFile, '  echo Parallels: TRUE >> ' + sOutFile + CRLF);
      write(BatFile, ') else if /i "%Model%"=="Parallels Virtual Platform" (' + CRLF);
      write(BatFile, '  echo Parallels: TRUE >> ' + sOutFile + CRLF);
      write(BatFile, ') else (' + CRLF);
      write(BatFile, '  echo Parallels: FALSE >> ' + sOutFile + CRLF);
      write(BatFile, ')' + CRLF);
      write(BatFile, 'echo done > ' + sDir + '\sema4.txt' + CRLF);
      write(BatFile, 'cd "' + sDir + '\"' + CRLF);
    CloseFile(BatFile);
    // ------------
    hProcess := screen.activeform.handle;
    iErr := 0;
    // execute the batch file with password as a parameter
    chdir(pChar(sDir));
    if not ExecWithShell(BatchFileName, '', '', hProcess, iErr, Developer) then begin
      gsOSName := 'ERROR';
    end;
  finally
    sleep(3000); // 3 seconds
    if not fileExists(sDir + '\sema4.txt') then sleep(2000);
    if not fileExists(sDir + '\sema4.txt') then sleep(1000);
    try
      deletefile(BatchFileName); // the batch file
    except
      LogEntry(v2UserToken, 'OS Name', 'ERROR deleting BAT file.', 'UPDATE');
    end;
    try
      deletefile(sDir + '\sema4.txt');
    except
      LogEntry(v2UserToken, 'OS Name', 'ERROR deleting semaphore.', 'UPDATE');
    end;
  end;
  // ------------
  if fileExists(sOutFile) then begin
    AssignFile(BatFile, sOutFile);
    reset(BatFile);
  end
  else begin
    LogEntry(v2UserToken, 'OS Name', 'ERROR', 'UPDATE');
    gsOSName := 'ERROR';
    exit;
  end;
  // OS Name:                   Microsoft Windows 10 Pro
  // OS Version:                10.0.19045 N/A Build 19045
  //    Physical Address. . . . . . . . . : F8-B1-56-AB-91-9B
  //    Physical Address. . . . . . . . . : B0-39-56-8E-EA-4D
  // Parallels: FALSE
  try
    i := 1;
    while not Eof(BatFile) do begin
      ReadLn(BatFile, sMsg);
      if pos('. . ', sMsg) > 0 then sMsg := ReplaceStr(sMsg, '. ', '');
      s := parseFirst(sMsg, ':');
      s := trim(s);
      sMsg := trim(sMsg);
      if s = 'OS Name' then begin
        gsOSName := sMsg;
      end
      else if s = 'OS Version' then begin
        gsOSVer := sMsg;
      end
      else if s = 'Physical Address' then begin
        if i <= 5 then gsMACaddr[i] := sMsg;
        i := i + 1; // number of MAC addresses
      end
      else if s = 'Parallels' then begin
        gbParallels := (sMsg = 'TRUE');
      end;
      LogEntry(v2UserToken, s, sMsg, 'UPDATE');
      sleep(100);
    end;
  finally
    CloseFile(BatFile);
    deletefile(sOutFile); // upload.txt file
  end;
end; //


end.
