unit bcFunctions;

interface

uses
  Windows, Messages, forms, SysUtils, Classes, clipbrd, variants, activeX, funcProc, comObj,
  Tlhelp32, ShellApi;

procedure KillProcess(hWindowHandle : HWND); // For Windows NT/2000/XP
function KillTask(ExeFileName : string): Integer; // For Windows 9x/ME/2000/XP
function FindWindowByTitle(WindowTitle : string): HWND;
function oleGetStr(value : oleVariant): string;
procedure SimulateKeyDown(Key : byte);
procedure SimulateKeystroke(Key : byte; extra : DWORD);
procedure mySendKeys(s : string);

implementation

uses
  TLSettings;


procedure KillProcess(hWindowHandle : HWND); // For Windows NT/2000/XP
var
  hprocessID : Integer;
  processHandle : THandle;
  DWResult : DWORD;
begin
  SendMessageTimeout(hWindowHandle, WM_CLOSE, 0, 0,
    SMTO_ABORTIFHUNG or SMTO_NORMAL, 5000, DWResult);
  // ------------------------
  if isWindow(hWindowHandle) then begin
    // PostMessage(hWindowHandle, WM_QUIT, 0, 0);
    { Get the process identifier for the window }
    GetWindowThreadProcessID(hWindowHandle, @hprocessID);
    if hprocessID <> 0 then begin
      { Get the process handle }
      processHandle := OpenProcess(PROCESS_TERMINATE or PROCESS_QUERY_INFORMATION,
        False, hprocessID);
      if processHandle <> 0 then begin
        { Terminate the process }
        TerminateProcess(processHandle, 0);
        CloseHandle(processHandle);
      end;
    end;
  end;
end;


function KillTask(ExeFileName : string): Integer; // For Windows 9x/ME/2000/XP
const
  PROCESS_TERMINATE = $0001;
var
  ContinueLoop : BOOL;
  FSnapshotHandle : THandle;
  FProcessEntry32 : TProcessEntry32;
begin
  Result := 0;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  // ------------------------
  while Integer(ContinueLoop) <> 0 do begin
    if (UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) = UpperCase(ExeFileName)) or
      (UpperCase(FProcessEntry32.szExeFile) = UpperCase(ExeFileName)) then
      Result := Integer(TerminateProcess(OpenProcess(PROCESS_TERMINATE, BOOL(0),
            FProcessEntry32.th32ProcessID), 0));
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;


function FindWindowByTitle(WindowTitle : string): HWND;
var
  NextHandle : HWND;
  NextTitle : array[0 .. 260] of char;
begin
  // Get the first window
  NextHandle := GetWindow(Application.Handle, GW_HWNDFIRST);
  while NextHandle > 0 do begin
    // retrieve its text
    GetWindowText(NextHandle, NextTitle, 255);
    Application.ProcessMessages;
    // statbar(StrPas(NextTitle));
    if Pos(WindowTitle, StrPas(NextTitle)) <> 0 then begin
      Result := NextHandle;
      Exit;
    end
    else // Get the next window
      NextHandle := GetWindow(NextHandle, GW_HWNDNEXT);
  end;
  Result := 0;
end;


function oleGetStr(value : oleVariant): string;
var
  index, lowVal, highVal : Integer;
  oleArray : PSafeArray;
  oleObj : oleVariant;
begin
  Result := '';
  try
    case VarType(value) of
    varEmpty, varNull :
      Result := '';
    varSmallint, varInteger, varByte, varError :
      Result := IntToStr(value);
    varSingle, varDouble, varCurrency :
      Result := FloatToStr(value, Settings.UserFmt);
    varDate :
      Result := DateTimeToStr(value, Settings.UserFmt);
    varOleStr, varStrArg, varString :
      Result := value;
    varBoolean :
      if value then
        Result := 'True'
      else
        Result := 'False';
    varDispatch, // do not remove IDispatch!
    varVariant, varUnknown, varTypeMask :
      begin
        VarAsType(value, varOleStr);
        Result := value;
      end;
  else
    if VarIsArray(value) then begin
      VarArrayLock(value);
      index := VarArrayDimCount(value);
      lowVal := VarArrayLowBound(value, index);
      highVal := VarArrayHighBound(value, index);
      oleArray := TVariantArg(value).pArray;
      // ----------
      for index := lowVal to highVal do begin
        SafeArrayGetElement(oleArray, index, oleObj);
        Result := Result + oleGetStr(oleObj) + #13#10;
      end;
      // ----------
      VarArrayUnlock(value);
      Delete(Result, length(Result) - 1, 2);
    end
    else
      Result := ''; // varAny, varByRef
    end;
  except
    // do nothing, just capture
  end;
end;


procedure SimulateKeyDown(Key : byte);
begin
  keybd_event(Key, 0, 0, 0);
end;


procedure SimulateKeyUp(Key : byte);
begin
  keybd_event(Key, 0, KEYEVENTF_KEYUP, 0);
end;


procedure SimulateKeystroke(Key : byte; extra : DWORD);
begin
  keybd_event(Key, extra, 0, 0);
  keybd_event(Key, extra, KEYEVENTF_KEYUP, 0);
end;


procedure mySendKeys(s : string);
var
  i : Integer;
  flag : BOOL;
  w : word;
begin
  // Get the state of the caps lock key
  flag := not GetKeyState(VK_CAPITAL) and 1 = 0;
  // If the caps lock key is on then turn it off
  if flag then
    SimulateKeystroke(VK_CAPITAL, 0);
  // ------------------------
  for i := 1 to length(s) do begin
    w := VkKeyScan(s[i]);
    // If there is not an error in the key translation
    if ((HiByte(w) <> $FF) and (LoByte(w) <> $FF)) then begin
     // If the key requires the shift key down - hold it down
      if HiByte(w) and 1 = 1 then
        SimulateKeyDown(VK_SHIFT);
      // Send the VK_KEY
      SimulateKeystroke(LoByte(w), 0);
      // If the key required the shift key down - release it
      if HiByte(w) and 1 = 1 then
        SimulateKeyUp(VK_SHIFT);
    end;
  end;
  // if the caps lock key was on at start, turn it back on
  if flag then
    SimulateKeystroke(VK_CAPITAL, 0);
end;

end.
