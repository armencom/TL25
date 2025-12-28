unit StackTrace;

interface

uses SysUtils, Classes, Graphics, Forms, Pngimage, Windows, Math;

procedure LogException(ExceptObj: TObject; ExceptAddr: Pointer; IsOS: Boolean);
procedure CreateScreenShot(WindowHandle : HWND; FileName : String);

implementation

uses
JCLDebug, JclHookExcept,
//rj CodeSiteLogging,
TLSettings;

procedure LogException(ExceptObj: TObject; ExceptAddr: Pointer; IsOS: Boolean);
var
  ExceptionSummary: string;
  ModInfo: TJclLocationInfo;
  ExceptFrame: TJclExceptFrame;
  S : TStringList;
begin
  S := TStringList.Create;
  try
    ExceptionSummary := 'EXCEPTION ClassName: (' + ExceptObj.ClassName + ') ';
    if ExceptObj is Exception then
      ExceptionSummary := ExceptionSummary + 'Message: ' + Exception(ExceptObj).Message;
    if IsOS then
      ExceptionSummary := ExceptionSummary + ' (OS Exception)';
    JclLastExceptStackListToStrings(S, True, True, True, True);
    S.Insert(0, ExceptionSummary);
    S.Insert(1, ' ');

    ModInfo := GetLocationInfo(ExceptAddr);
    S.Insert(2, Format(
      'Occured at Address: $%p in Procedure "%s", Line %d',
      [ModInfo.Address,
       ModInfo.ProcedureName,
       ModInfo.LineNumber]));
    S.Insert(3, ' ');
    S.Insert(4, 'FULL STACKTRACE:');
//rj     CodeSite.Send(csmError, ExceptionSummary , S);
  finally
    S.Free;
  end;
end;

function WindowSnap(windowHandle: HWND; bmp: Graphics.TBitmap): boolean;
var
  r: TRect;
  user32DLLHandle: THandle;
  printWindowAPI:  function(sourceHandle: HWND; destinationHandle: HDC; nFlags: UINT): BOOL; stdcall;

  begin
  result := False;
  user32DLLHandle := GetModuleHandle(user32) ;
  if user32DLLHandle <> 0 then
  begin
    @printWindowAPI := GetProcAddress(user32DLLHandle, 'PrintWindow') ;
    if @printWindowAPI <> nil then
    begin
      GetWindowRect(windowHandle, r) ;
      bmp.Width := r.Right - r.Left;
      bmp.Height := r.Bottom - r.Top;
      bmp.Canvas.Lock;
      try
        result := printWindowAPI(windowHandle, bmp.Canvas.Handle, 0) ;
      finally
        bmp.Canvas.Unlock;
      end;
    end;
  end;
end; (*WindowSnap*)

procedure CreateScreenShot(windowHandle : HWND; FileName : String);
var
  bmpMain, bmpDlg : Graphics.TBitmap;
  png : TPNGObject;
  DC : HDC;
  Win : HWnd;
  WinRect : TRect;
  Width, Height : Integer;
begin
  Application.ProcessMessages;
  bmpMain := Graphics.TBitmap.Create;
  try
    {Crete a bmp from the form passed in, ususlly the main form.}
    WindowSnap(windowHandle, BmpMain);
    {If the handle passed in is not the active form, then also capture it}
    if (Screen.ActiveForm.Handle <> windowHandle) then
    begin
      bmpDlg := Graphics.TBitmap.Create;

      try
        WindowSnap(Screen.ActiveForm.Handle, bmpDlg);
        try
          bmpMain.Canvas.Lock;
          bmpDlg.Transparent := False;
          Width := Trunc((bmpMain.Width / 2) - (bmpDlg.Width / 2));
          Height := Trunc((bmpMain.Height / 2) - (bmpDlg.Height / 2));
          bmpMain.Canvas.Draw(Width, Height, bmpDlg);
        finally
          bmpMain.Canvas.Unlock;
        end;

      finally
        bmpDlg.Free;
      end;
    end;
    png := TPNGObject.Create;
    try
      png.Assign(bmpMain);
      png.SaveToFile(FileName);
    finally
      png.Free;
    end;
  finally
    bmpMain.Free;
  end;
end;

end.
