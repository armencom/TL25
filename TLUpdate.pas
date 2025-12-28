unit TLUpdate;

// Update functionality for Tradelog
interface

uses SysUtils, Windows, Messages, Forms, Classes, SyncObjs, Dialogs, TLCommonLib, Graphics, TLRegister;

// functions and procedures

var
  xs : string;

//const BLOCKING_TIMEOUT = 10;

function DetermineDownloadableVersion: string;
procedure DetermineInstalledVersion;
procedure UpdateTradeLogExe(beta: boolean = false);


implementation

uses Shlobj, TLSettings, ShellAPI, funcProc, controls, main, winInet, TL_API, globalVariables;

const
  UPDATE_URL = 'https://support.tradelogsoftware.com/hc/en-us/articles/10061386077207';
  UPDATE_HISTORY='#History';
  UPDATE_FILE_URL = 'https://tradelog.com/tradelog-software/';
  UPDATE_FILE = 'setupTL20';
  UPDATE_EXT = '.exe';
  CHECK_UPDATE_FAILED_MESSAGE = 'Check For Update Failed!';
  GET_UPDATE_FAILED_MESSAGE = 'Getting Update Failed!';
  UPDATE_FAILED_HINT = 'Your internet Connection is unavailable! Please check your connection.';
  READY_TO_INSTALL_HINT = 'Ready to Install . . .  Click on the yellow message';
  NUMBER_OF_TRIES = 2;
  RETRY_TIMEOUT = 10;

var
  x1 : string;

// functions and procedures

function GetWindowsSpecialFolder(Folder : Integer): string;
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


function DetermineDownloadableVersion: string;
var
  s, s1, sVer, t, t1, sYY, sMM, sDD, xs : string;
  lstFlds, lstVer : TStrings;
begin
  result := 'error'; // assume failure
  s := GetVersion('latest');
  t := parseBetween(s, '[', ']');
  // [
  //  {                                    lstFlds[i]
  //   "id":8,                                0,1
  //   "Version":"020.03.00.00",              2,3
  //   "RelDate":"23-10-27",                  4,5
  //   "Description":"Improved Get Support.", 6,7
  //   "MustUpgrade":0                        8,9
  //  }
  // ]
  t := parseHTML(t, '{', '}');
  lstFlds := ParseV2APIResponse(t);
//  s1 := parseFirst(t, ','); // id
  // --- version number -----
  s := lstFlds[3]; // Version
  s := delquotes(s);
  lstVer := parseCSV(s,'.');
  if lstVer.Count < 3 then exit;
  giMajVer := StrToIntDef(lstVer[0],0);
  giMinVer := StrToIntDef(lstVer[1],0);
  giRelVer := StrToIntDef(lstVer[2],0);
  giBldVer := StrToIntDef(lstVer[3],0);
  gsVersion := IntToStr(giMajVer)+'.'+IntToStr(giMinVer) //
    +'.'+IntToStr(giRelVer)+'.'+IntToStr(giBldVer); // <--- latest version
  // --- release date -------
  t1 := lstFlds[5]; // RelDate
  sDD := delquotes(t1);
  sYY := '20' + parseFirst(sDD, '-');
  sMM := parseFirst(sDD, '-');
  gsRelDate := sYY+'.'+sMM+'.'+sDD; // <--- release date of latest version
  // --- description --------
  t := lstFlds[7]; // Description
  gsRelDesc := delquotes(t); // <--- description of latest version
  // --- combined result ----
  result := gsVersion + ' - ' + gsRelDate + CRLF + gsRelDesc;
//  // override for testing
//  gsVersion := '20.3.2.0 - 2024.01.19'; // <--- latest version
//  result := '20.3.2.0 - 2024.01.19' + CRLF + 'SPECIAL TEST VERSION.';
end;


procedure DetermineInstalledVersion;
var
  Fmt : TFormatSettings;
  FFileDate : TDateTime;
begin
  FileAge(Application.ExeName, FFileDate);
  Fmt.ShortDateFormat := 'yyyy.mm.dd';
  gsInstallDate := Trim(DateTimeToStr(FFileDate, Fmt)); // <-- exe creation date and...
  gsInstallVer := GetVersionInfo('FileVersion'); // <--- version number of installed exe
  gsBeta := GetVersionInfo('Comments'); //
  if gsBeta = 'BETA' then gsBeta := ' ' + char(946) else gsBeta := '';
end;


function DownloadTLSetup(URL: string; fileName: string): boolean;
const
  BLOCK_SIZE = 1024;
var
  InetHandle: Pointer;
  URLHandle: Pointer;
  FileHandle: Cardinal;
  BytesRead: Cardinal;
  DownloadBuffer: Pointer;
  Buffer: array [1 .. BLOCK_SIZE] of byte;
  BytesWritten: Cardinal;
  stopUpdate : boolean;
begin
  result := false;
  InetHandle := InternetOpen(PWideChar(URL), 0, 0, 0, 0);
  if not Assigned(InetHandle) then RaiseLastOSError;
  try
    URLHandle := InternetOpenUrl(InetHandle, PWideChar(URL), 0, 0, INTERNET_FLAG_RELOAD, 0);
    if not Assigned(URLHandle) then RaiseLastOSError;
    try
//      screen.Cursor := crHourglass; //
      FileHandle := CreateFile(PWideChar(fileName),
        GENERIC_WRITE, FILE_SHARE_WRITE, 0,
        CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
      if FileHandle = INVALID_HANDLE_VALUE then begin
        mDlg('Unable to download the setup file this way.' + cr //
          + cr //
          + 'Please login to Tradelog.com and download from there.' //
          ,mtError,[mbOK],1);
        exit;
      end;
      try
        DownloadBuffer := @Buffer;
        repeat
          // code for exiting routine when ESC key hit
          Application.ProcessMessages;
          if GetKeyState(VK_ESCAPE) and 128 = 128 then StopUpdate := True;
          if StopUpdate then break;
          if not InternetReadFile(URLHandle, DownloadBuffer, BLOCK_SIZE, BytesRead) //
          or not WriteFile(FileHandle, DownloadBuffer^, BytesRead, BytesWritten, 0) //
          then
            RaiseLastOSError;
        until BytesRead = 0;
      finally
        CloseHandle(FileHandle);
      end;
    finally
      InternetCloseHandle(URLHandle);
    end;
  finally
    InternetCloseHandle(InetHandle);
  end;
//  screen.Cursor:= crDefault;
  result := true;
end;


function DownloadSetup(URL: string; fileName: string):boolean;
const
  BLOCK_SIZE = 1024;
var
  InetHandle: Pointer;
  URLHandle: Pointer;
  FileHandle: Cardinal;
  BytesRead: Cardinal;
  DownloadBuffer: Pointer;
  Buffer: array [1 .. BLOCK_SIZE] of byte;
  BytesWritten: Cardinal;
  stopUpdate : boolean;
begin
  result := false;
  InetHandle := InternetOpen(PWideChar(URL), 0, 0, 0, 0);
  if not Assigned(InetHandle) then RaiseLastOSError;
  try
    URLHandle := InternetOpenUrl(InetHandle, PWideChar(URL), 0, 0, INTERNET_FLAG_RELOAD, 0);
    if not Assigned(URLHandle) then RaiseLastOSError;
    try
      screen.Cursor := crHourglass;
      // CREATE_ALWAYS deletes the file if exists
      FileHandle := CreateFile(PWideChar(fileName),
        GENERIC_WRITE, FILE_SHARE_WRITE, 0,
        CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
      if FileHandle = INVALID_HANDLE_VALUE then begin
        exit(false);
      end;
      try
        DownloadBuffer := @Buffer;
        repeat
          if not InternetReadFile(URLHandle, DownloadBuffer, BLOCK_SIZE, BytesRead) //
          or not WriteFile(FileHandle, DownloadBuffer^, BytesRead, BytesWritten, 0) //
          then
            RaiseLastOSError;
        until BytesRead = 0;
      finally
        CloseHandle(FileHandle);
      end;
    finally
      InternetCloseHandle(URLHandle);
    end;
  finally
    InternetCloseHandle(InetHandle);
  end;
  result := true;
end;


procedure UpdateTradeLogExe(beta: boolean = false);
var
  j : integer;
  s, x, sUserFolder : string;
  zFileName, zParams, zDir: array [0 .. 127] of Char;
begin
  sUserFolder := GetWindowsSpecialFolder(CSIDL_PROFILE)+'\.TradeLog';
  // same as regular update, only gets the beta instead
  randomize;
  j := random($7FFFFFFF);
  x := inttostr(j);
  Screen.Cursor := crHourglass;
  try
    // code from Help>Update
    randomize;
    j := random($7FFFFFFF);
    x := inttostr(j);
    s := 'https://tradelog.com/tradelog-software/';
    if beta then s := s + 'beta/';
    s := s + 'setupTL20.exe?ver=' + x;
    if DownloadSetup(s, sUserFolder + '\setupTL20.exe')
    then begin
      Screen.Cursor := crDefault;
      if (screen.ActiveForm = nil) then
        ShellExecute(frmMain.handle, //
        nil, //
        StrPCopy(zFileName, 'setupTL20.exe'), //
        StrPCopy(zParams, ''),
        StrPCopy(zDir, sUserFolder), SW_SHOW)
      else
        ShellExecute(screen.activeform.handle, //
        nil, //
        StrPCopy(zFileName, 'setupTL20.exe'), //
        StrPCopy(zParams, ''),
        StrPCopy(zDir, sUserFolder), SW_SHOW);
      bCancelLogin := true;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;


end.
