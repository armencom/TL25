unit TLSupport;

interface

uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls,
  IdFTP,IdFTPCommon, IdExplicitTLSClientServerBase, IdBaseComponent,
  IdSMTP, IdAttachment, IdMessage, IdMessageParts, IdEMailAddress, IdAttachmentFile,
  IdComponent, IdTCPConnection, IdTCPClient,  SCIZipFile, TLWinInet,
  System.IOUtils;

type
  TLSupportLib = class
  private
    class procedure AddFile(FolderName : String; PathAndFileName : String;  zipFile : TZipFile);
    class procedure AddImportFolder(FolderName : String; PathToFiles : String; DirMask : String; ZipFile : TZipFile);
    class procedure AddFolder(FolderName : String; PathToFiles : String; DirMask: String;  ZipFile : TZipFile);
    class procedure AddFolders(FolderName : String; StartDir : String; FileMask: String;  ZipFile : TZipFile);
    class function GetTempFile(BaseFileName : String) : String;
  public
    class function CreateSupportfile(TrFileName: String; IncludeImportFiles : Boolean) : String;
    class function GetSupportFile(SuptFileName : String) : String;
    // upload Zip file
    class function PSCP_Send(SuptFileName : String; sUploadFile : string) : boolean;
    class procedure SendSupportFile(sUploadFile : string);
    // other
    class procedure createErrorLog(fileName, s : String);
  end;

var
  sFilespec1, sFilespec2, sFilespec3 : string;
  sCustomerEmailAddress : string;

implementation

uses
  fmProgress,
  Web, TLRegister, TLSettings,
  pngimage, OleAuto, IDUri,
  TLCommonLib, funcProc,
  WinAPI.ShellAPI,
  uDM;

const
  NET_FW_PROFILE2_DOMAIN  = 1;
  NET_FW_PROFILE2_PRIVATE = 2;
  NET_FW_PROFILE2_PUBLIC  = 4;
  NET_FW_IP_PROTOCOL_TCP = 6;
  NET_FW_IP_PROTOCOL_UDP = 17;
  NET_FW_IP_PROTOCOL_ICMPv4 = 1;
  NET_FW_IP_PROTOCOL_ICMPv6 = 58;

  NET_FW_ACTION_ALLOW = 1;
  NET_FW_ACTION_BLOCK = 0;

  SFTPpart1 : string = '"%ProgramFiles(x86)%\TradeLog\pscp.exe" -batch -pw %1 -P 22 "';
  SFTPpart2 : string = '" "tradelog-backup@45.56.119.22:/home/tradelog-backup/backup"';
  SFTPpwd : string = 'a8c22a2c2c3979d4502b9e7fe654510cbca27181';


//---------------------------------------------------------
class procedure TLSupportLib.createErrorLog(fileName, s : String);
var
  FS: TFileStream;
  Flags: Word;
begin
  Try
    if Not DirectoryExists(Settings.LogDir) then
      ForceDirectories(Settings.LogDir);
  Except
    mDlg('Could not create ' + Settings.LogDir, mtError,[mbOK],0);
    exit;
  End;
  s := s + chr(13);
  Flags := fmOpenReadWrite;
  if not FileExists(fileName) then
    Flags := Flags or fmCreate;
  FS := TFileStream.Create(fileName, Flags);
  try
    FS.Position := FS.Size;  // Will be 0 if file created, end of text if not
    FS.Write(s[1], Length(s) * SizeOf(Char));
    s := cr+lf;   //add end of line characters
    FS.Write(s[1], Length(s) * SizeOf(Char));
  finally
    FS.Free;
  end;
end;

//---------------------------------------------------------
//Adds all files in folder and is not recursive.
//---------------------------------------------------------

//---------------------------------------------------------
//PURPOSE: Add a single file to the zip archive and read
// the data into the data element of the TZipFile.
//FolderName = Name to give the folder in the ZIP file
// e.g. 'Undo'
// if FolderName is blank, just add to root of Zip file
//PathAndFileName = the full path\name.ext to the file to zip
// e.g. 'C:\Users\MarkB\Documents\TradeLog\Undo\2013 Trial UNDOLIST.txt'
//---------------------------------------------------------
class procedure TLSupportLib.AddFile(FolderName : String; PathAndFileName : String;  zipFile : TZipFile);
var
  buffer : TStringList;
  // ------------------------
  function getFile : AnsiString;
  var
   FileStream : TFileStream;
   Bytes : TBytes;
  begin
    Result := '';
    FileStream := TFileStream.Create(PathAndFileName, fmOpenRead or fmShareDenyWrite);
    try
      if (FileStream.Size > 0) then
      begin
        SetLength(Bytes, FileStream.Size);
        FileStream.Read(Bytes[0], FileStream.Size);
        Result := TEncoding.ANSI.GetString(Bytes);
      end;
    finally
      FileStream.Free;
    end;
  end;
begin // --------------------
  if Length(FolderName) > 0 then
    ZipFile.AddFile(FolderName + '\' + ExtractFileName(PathAndFileName))
  ELSE
    ZipFile.AddFile(ExtractFileName(PathAndFileName));
  zipFile.Data[zipFile.count - 1] := getFile;
end;


//---------------------------------------------------------
//PURPOSE: Add an entire folder to a Zip file
//FolderName = Name to give the folder in the ZIP
// e.g. 'Undo'
// if FolderName is blank, just add to root of Zip file
//DirMask = spec of files to include (may use ? and *)
// e.g. '*.*' or '2013 Trial UNDO?.tdz' (note '?')
//PathToFiles = directory the files are in
// e.g. 'C:\Users\MarkB\Documents\TradeLog\Undo'
// would add all UNDO TDZ files that start with '2013 Trial'
//ZipFile = name of output ZipFile
//---------------------------------------------------------
class procedure TLSupportLib.AddImportFolder(FolderName : String; PathToFiles : String; DirMask : String; ZipFile : TZipFile);
var
  SystemTime, LocalTime: TSystemTime;
  dtOldest, dtNewest, dtAccessed : TDateTime;
  fad : TWin32FileAttributeData;
  buffer : TStringList;
  SR : TSearchRec;
begin
  // only include import files which were...
  dtAccessed := now - 30; // ...accessed in last 30 days, or
  dtOldest := StrToDate('1/1/' + LastTaxYear); // ...created between 1/1/LastTaxYear
  dtNewest := StrToDate('1/31/' + NextTaxYear); // and 1/31/NextTaxYear
  // ...and do NOT include subdirectories
  if FindFirst(PathToFiles + '\' + DirMask, faAnyFile - faDirectory, SR) = 0 then
  repeat
    if (SR.TimeStamp >= dtOldest) //
    and (SR.TimeStamp <= dtNewest) then
      addFile(FolderName, PathToFiles + '\' + SR.Name, ZipFile)
    else begin
      GetFileAttributesEx(PChar(SR.Name), GetFileExInfoStandard, @fad);
      FileTimeToSystemTime(fad.ftLastAccessTime, SystemTime);
      if SystemTimeToTzSpecificLocalTime(nil, SystemTime, LocalTime) then
        if (SystemTimeToDateTime(LocalTime) >= dtAccessed) then
          addFile(FolderName, PathToFiles + '\' + SR.Name, ZipFile);
    end; // if Access, Modify dates
  until FindNext(SR) <> 0;
  FindClose(SR);
end;


class procedure TLSupportLib.AddFolder(FolderName : String; PathToFiles : String; DirMask: String;  ZipFile : TZipFile);
var
  buffer : TStringList;
  SR: TSearchRec;
begin
  if FindFirst(PathToFiles + '\' + DirMask, faAnyFile - faDirectory, SR) = 0 then
  repeat
    addFile(FolderName, PathToFiles + '\' + SR.Name, ZipFile);
  until FindNext(SR) <> 0;
  FindClose(SR);
end;


class procedure TLSupportLib.AddFolders(FolderName: String; StartDir: String; FileMask: String; zipFile: TZipFile);
var
  SR: TSearchRec;
  DirList: TStringList;
  IsFound: Boolean;
  i: Integer;
begin
  // Build a list of subdirectories
  try
    DirList := TStringList.Create;
    IsFound := FindFirst(StartDir + '\' + FolderName + '\*.*',
      faAnyFile, SR) = 0;
    while IsFound do begin
      if ((SR.Attr and faDirectory) <> 0) and (SR.Name[1] <> '.') then
        DirList.Add(StartDir + '\' + FolderName + '\' + SR.Name);
      IsFound := FindNext(SR) = 0;
    end;
    FindClose(SR);
    // Scan the list of subdirectories
    for i := 0 to DirList.count - 1 do begin
      FolderName := stringReplace(DirList[i], StartDir+'\', '', [rfReplaceAll]);
      AddFolder(FolderName, DirList[i], FileMask, zipFile);
    end;
  finally
    DirList.Free;
  end;
end;


//---------------------------------------------------------
// Creates ZIP file with correct name, etc.
//---------------------------------------------------------
class function TLSupportLib.CreateSupportFile(TrFileName : String; IncludeImportFiles : Boolean) : String;
var
  zipFile : TZipFile;
  sFileName, sDirMask, sErrMsg : String;
  SR: TSearchRec;
begin
  screen.Cursor := crHourglass;
  Result := GetTempFile('TSF');
  ZipFile := TZipFile.Create;
  sErrMsg := '';
  try
    // --- add the selected TDF file --
    if (Length(TrFileName) > 0) //
    and FileExists(Settings.DataDir + '\' + TrFileName) then begin
      try
        AddFile('', Settings.DataDir + '\' + TrFileName, ZipFile);
      except
        sErrMsg := 'Unable to attach requested file.' + CR;
      end;
    end;
    // --- add screenshot -------------
    if FileExists(Settings.LogDir + '\ScreenShot.png') then begin
      AddFile('', Settings.LogDir + '\ScreenShot.png', ZipFile);
    end;
    // --- add diagnostics ------------
    if FileExists(Settings.LogDir + '\diagnostics.txt') then begin
      AddFile('', Settings.LogDir + '\diagnostics.txt', ZipFile);
      deletefile(Settings.LogDir + '\diagnostics.txt');
    end;
    // --- add Baseline folder --------
    try
      AddFolders('Baseline', Settings.DataDir, '*.txt', ZipFile);
    except
      sErrMsg := 'Unable to attach requested file.' + CR;
    end;
    // --- add error.log file ---------
    if FileExists(Settings.LogDir + '\' + 'error.log') then begin
      try
        AddFile('Logs', Settings.LogDir + '\' + 'error.log', ZipFile);
      except
        sErrMsg := 'Unable to attach requested file.' + CR;
      end;
    end;
    // --------------------------------
    // add sFile #1 if selected
    if (sFilespec1 <> '') and FileExists(sFilespec1) then
    try
      AddFile('', sFilespec1, ZipFile);
    except
      sErrMsg := sErrMsg + 'Unable to attach requested file ' + sFilespec1 + CR;
    end;
    // add sFile #2
    if (sFilespec2 <> '') and FileExists(sFilespec2) then
    try
      AddFile('', sFilespec2, ZipFile);
    except
      sErrMsg := sErrMsg + 'Unable to attach requested file ' + sFilespec2 + CR;
    end;
    // add sFile #3
    if (sFilespec3 <> '') and FileExists(sFilespec3) then
    try
      AddFile('', sFilespec3, ZipFile);
    except
      sErrMsg := sErrMsg + 'Unable to attach requested file ' + sFilespec3 + CR;
    end;
    // --------------------------------
    if length(sErrMsg) > 1 then
      sm(sErrMsg + 'Sending partial data now.');
    // --- add the CodeSite Log file --
    if FileExists(Settings.LogDir + '\' + Settings.LogFileName) then
      AddFile('Logs', Settings.LogDir + '\' + Settings.LogFileName, ZipFile);
    // --- add the Settings files -----
    AddFolder('Settings', Settings.SettingsDir, '*.*', ZipFile);
    // --------------------------------
    // add UNDO folder\files for the selected account
    sDirMask := copy(TrFileName, 1, Pos('.tdf', TrFileName) - 1) + ' UNDO?.tdz';
    AddFolder('Undo', Settings.UndoDir, sDirMask, ZipFile);
    sFileName := copy(TrFileName, 1, Pos('.tdf', TrFileName) - 1)  + ' UNDOLIST.txt';
    if FileExists(Settings.UndoDir + '\' + sFileName) then
      AddFile('Undo', Settings.UndoDir + '\' + sFileName, ZipFile);
    // --------------------------------
    // add Import folder\files for account IF checked
    if IncludeImportFiles then begin
      AddImportFolder('Import', Settings.ImportDir, '*.*', ZipFile);
    end;
    // --------------------------------
    // finish
    Application.ProcessMessages;
    ZipFile.SaveToFile(Result);
  finally
    zipFile.free;
  end;
end;


class function TLSupportLib.GetTempFile(BaseFileName : String): String;
var
  TempFile: array[0..MAX_PATH - 1] of Char;
  TempPath: array[0..MAX_PATH - 1] of Char;
begin
  GetTempPath(MAX_PATH, TempPath);
  if GetTempFileName(TempPath, PChar(BaseFileName), 0, TempFile) = 0 then
    raise Exception.Create('GetTempFileName API failed. ' + SysErrorMessage(GetLastError) );
  Result := String(TempFile);
end;


//---------------------------------------------------------
// send support files to TradeLogSoftware.com FTP server
//---------------------------------------------------------
class function TLSupportLib.GetSupportFile(SuptFileName : String) : String;
var
  Ftp : TIDFTP;
  sDFile : string;
begin
  FTP := TidFTP.Create(nil);
  FTP.TransferType := ftBinary;
  FTP.Passive := True;
  Result := '';
  try
    sDFile := suptFileName;
    if fileExists(suptFileName) then begin
      sDFile := inputbox('Overwrite Destination File','Overwrite or rename?',sDFile);
    end;
    sDFile := Settings.DataDir + '\' + sDFile;
    FTP.Host := 'ftp.tradelogsoftware.com';
    FTP.Port := 21;
    FTP.Username := 'armencom';
    FTP.Password := 'GnZQ9ZXx3ek4}@-U';
    FTP.Connect;
    if FTP.Connected then begin
      screen.Cursor := crHourglass;
      FTP.ChangeDir('xUploads');
      FTP.Get(SuptFileName, sDFile, true, true);
      sleep(1000);
//        FTP.Get(Result + '.png', false);
        Application.ProcessMessages;
      FTP.Disconnect;
    end;
  finally
    FTP.Free;
    screen.Cursor := crDefault;
    if fileExists(sDFile) then
      sm('The file was downloaded into folder' + CRLF //
        + Settings.DataDir)
    else
      sm('Please check ' + Settings.DataDir + CRLF //
        + 'for the download file.');
  end;
end;


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

// --- the following is not used anywhere ---
//function ExecWithCmdLine(AName, CLine: string;
//  var pInfo: TProcessInformation; var iErr: int64): boolean;
//var
//  sInfo: TStartupInfo;
//  AppName, AppWDir, CmdLine: string;
//begin
//  AppName := AName; //Full path & name of Your App.
//  AppWDir := ExtractFileDir(AppName);
//  CmdLine := ' ' + CLine;
//  ZeroMemory(@pInfo, SizeOf(pInfo));
//  ZeroMemory(@sInfo, sizeof(TStartupInfo));
//  sInfo.cb      :=  sizeof(TStartupInfo);
//  sInfo.dwFlags :=  STARTF_FORCEONFEEDBACK or STARTF_FORCEOFFFEEDBACK;
//  Result := CreateProcess(PWideChar(AppName),
//              PWideChar(CmdLine), nil, nil, False,
//              CREATE_DEFAULT_ERROR_MODE or
//              CREATE_NEW_PROCESS_GROUP  or
//              NORMAL_PRIORITY_CLASS or
//              CREATE_NO_WINDOW,
//              nil, PWideChar(AppWDir), sInfo, pInfo);
//  if not Result then
//    iErr := GetLastError;
//end;
{
  commandLine := 'C:\Windows\System32\cmd.exe';

  if not CreateProcess(
    PChar(nil),         // no module name (use command line)
    PChar(commandLine), // Command Line
    @buffer[0],
    nil,                // Process handle not inheritable
    nil,                // Thread handle not inheritable
    False,              // Don't inherit handles
    0,                  // No creation flags
    nil,                // Use parent's environment block
    PChar(nil),         // Use parent's starting directory
    si,                 // Startup Info
    pi                  // Process Info (call by var)
  );
}


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


//-----------------------------------------------
// send support files via SFTP / Putty
//-----------------------------------------------
class function TLSupportLib.PSCP_Send(SuptFileName : String; sUploadFile : string) : boolean;
var
  hProcess: DWord;
  iErr: int64;
  sDir, sZipFile, sPSCP, sMsg, s: string;
  pw1, pw2 : PWideChar;
  sOutFile, ext, BatchFileName : string;
  BatFile : textFile;
  f : TdlgProgress;
  i : integer;
  bSuccess : boolean;
begin
  try
    sMsg := 'Problem encountered sending file to Customer Support.';
    if not fileExists(suptFileName) then exit(false);
    bSuccess := true; // assume success until it fails
    // ------------
    screen.Cursor := crHourglass;
    sDir := Settings.DataDir; // GetCurrentDir;
    sZipFile := sDir + '\' + sUploadFile + '.zip';
    try
      pw1 := pChar(SuptFileName);
      pw2 := pChar(sZipFile);
    except
      bSuccess := false; // assume success until it fails
      sm('ERROR 540 - ' + sMsg);
      exit(false);
    end;
    if not copyfile(pw1, pw2, false) then begin
      bSuccess := true; // assume success until it fails
      exit(false);
    end;
    // ------------
    sOutFile := sDir + '\upload.txt';
    if fileExists(sOutFile) then deletefile(sOutFile); // don't allow injection!
    // ------------
    BatchFileName := Settings.DataDir + '\pscp' //
      + formatdatetime('yyyymmdd-hhmmss', now)+ '.bat';
    if fileExists(BatchFileName) then deletefile(BatchFileName); // don't allow injection!
    AssignFile(BatFile, BatchFileName);
    Rewrite(BatFile);
      if not Developer then begin
        write(BatFile, '@echo off' + CRLF);
      end;
      write(BatFile, '@echo Sending support file.' + CRLF);
      write(BatFile, '@echo Please stand by.' + CRLF);
      write(BatFile, '@echo ...' + CRLF);
      write(BatFile, 'cd "' + sDir + '\"' + CRLF);
    sPSCP := SFTPpart1 + sDir + '\' + sUploadFile + '.zip' + SFTPpart2 + ' >upload.txt';
      write(BatFile, sPSCP + CRLF);
      if Developer then begin
        write(BatFile, '@echo debug check:' + CRLF);
        write(BatFile, 'type upload.txt' + CRLF);
        write(BatFile, 'pause' + CRLF)
      end else begin
        write(BatFile, 'exit' + CRLF);
      end;
    CloseFile(BatFile);
    // ------------
    hProcess := screen.activeform.handle;
    iErr := 0;
    // execute the batch file with password as a parameter
    chdir(pChar(sDir));
    f := TdlgProgress.Create(nil);
    f.InitProgressBar('Uploading support file', 1, 30, 1);
    f.Show;
    f.ContinueProgressBar(0);
    if not ExecWithShell(BatchFileName, SFTPpwd, '', hProcess, iErr, Developer) then begin
      bSuccess := false; // assume success until it fails
      sMsg := 'Error during upload.';
    end else begin
      i := 1;
      while i < 31 do begin
        sleep(500); // wait 0.500 seconds
        i := i + 1;
        if f.ContinueProgressBar(i) = false then break;
      end;
    end;
  finally
    f.Hide;
    f.Destroy; // done with progress bar
    // ------------
    deletefile(BatchFileName); // the batch file
    sleep(2000); // 2 secs
    if not fileExists(sOutFile) then sleep(1000);
    // ------------
    screen.Cursor := crDefault; // return mouse control
    if fileExists(sOutFile) then begin
      if SearchFileForString(sOutFile, '100%') then begin
        sMsg := 'File sent to Customer Support.';
        bSuccess := true;
      end
      else begin
        sMsg := 'Error uploading file.';
        bSuccess := false;
      end;
      deletefile(sOutFile); // upload.txt file
    end
    else begin
      bSuccess := false;
    end;
    if (bSuccess = false) or SuperUser then
      sm(sMsg);
    if not bSuccess then begin
      // copy the zip file to send later...
      copyfile(PChar(sZipFile), PChar(Settings.DataDir + '\MySupportFile.zip'), false); // the zip file
    end;
    deletefile(sZipFile); // the zip file
    deletefile(SuptFileName); // the tmp file
  end;
  result := bSuccess;
end; // TLSupportLib.PSCP_Send


//---------------------------------------------------------
// send support files to TradeLogSoftware.com FTP server
//---------------------------------------------------------
// Ralph add update securebridge
class procedure TLSupportLib.SendSupportFile(sUploadFile : string);
var sFile: string;
begin
  with DM do begin
    // 1. Setup Storage
    SSHClient.KeyStorage := FileStorage; // Usually linked to itself or a file

    // 2. Setup SSH Client
    SSHClient.HostName := '45.56.119.22';
    SSHClient.Port := 22;
    SSHClient.User := 'tradelog-backup';
    SSHClient.Password := 'a8c22a2c2c3979d4502b9e7fe654510cbca27181';

    // Link SFTP to the SSH Client
    SFTPClient.SSHClient := SSHClient;

    try
      // Connect to the server
      SSHClient.Connect;

      // Initialize SFTP protocol
      SFTPClient.Initialize;

      // 3. Upload the file
      // Syntax: UploadFile(LocalFileName, RemoteFileName, Append)
      sFile := '/home/tradelog-backup/backup/' + TPath.GetFileNameWithoutExtension(sUploadFile) + formatdatetime('yyyymmdd-hhmmsszzz', Now) + '.zip';
      SFTPClient.UploadFile(sUploadFile, sFile, False);

      ShowMessage('Upload Successful!');
    finally
      SSHClient.Disconnect;
    end;
  end;
end;


end.
