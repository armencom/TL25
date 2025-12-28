{ -----------------------------------------------------------------------------
 Unit Name: pbmarquee
 Author:    Alex Sporyk
 Date:      06-Apr-2006
 Purpose:   Progress Bar Marquee Controller
 History:   0.1
 Added comment by DP: This is freeware!   Slightly modified by DP
----------------------------------------------------------------------------- }

unit pbmarquee;

interface

uses
  Windows, Classes, Controls, SysUtils, Messages;

type

  TControlProgressBarPaint = procedure(Sender : TObject; BoundsRect, TrackerRect : TRect) of object;

  TControlProgressBar = class(TControl)
    private
      FPosition, FMin, FMax : Int64;
      FHandle : HWND;

      _progress : TRect;
      marquee : Boolean;

      c, lock : Boolean;
      delta, _pos : Integer;

      FOnPaint : TControlProgressBarPaint;

      procedure SetPosition(Value : Int64);
      procedure SetMin(Value : Int64);
      procedure SetMax(Value : Int64);
    protected
      procedure _WndProc(var Message : TMessage);
    public
      constructor Create(AOwner : TComponent); override;
      destructor Destroy; override;

      procedure MarqueeStart;
      procedure MarqueeStop;

      procedure Invalidate; override;
      procedure Repaint; override;
      procedure SetBounds(ALeft, ATop, AWidth, AHeight : Integer); override;
    published
      property Max : Int64 read FMax write SetMax default 100;
      property Min : Int64 read FMin write SetMin default 0;
      property Position : Int64 read FPosition write SetPosition default 0;

      property OnPaint : TControlProgressBarPaint read FOnPaint write FOnPaint;
  end;

implementation

{ TControlProgressBar }

constructor TControlProgressBar.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  lock := True;
  Width := 150;
  Height := 20;
  Max := 100;
  Min := 0;
  Position := 0;
  _pos := 0;
  _progress := BoundsRect;
  _progress.Right := _progress.Left;
  marquee := False;
  FOnPaint := nil;
  FHandle := 0;
  Visible := False;
  lock := False;
end;

destructor TControlProgressBar.Destroy;
begin
  Windows.KillTimer(FHandle, 1);
  if FHandle > 0 then
    Classes.DeallocateHWnd(FHandle);
  inherited Destroy;
end;


procedure TControlProgressBar.Invalidate;
var ws, i, tw : Integer;
begin
  inherited;
  if lock then
    Exit;
  if Max > 0 then
    i := Round((Position * 200)/(Max - Min))
  else
    i := 0;
  if not marquee then begin
    ws := ClientWidth;
    _progress := ClientRect;
    if i = 0 then
      _progress.Right := 0
    else if i = 100 then
      _progress.Right := ClientWidth
    else
      _progress.Right := Round((ws / 200)* i);
  end
  else begin
    ws := ClientWidth;
    if (i <= 0) or (i >= 100) then
      tw := ws div 50
    else
      tw := Round((ws / 200)* i);
    _progress := ClientRect;
    if not c then begin
      _progress.Left := _progress.Left + _pos;
      _progress.Right := _progress.Left + tw;
    end
    else begin
      _progress.Left := 0;
      _progress.Right := _pos;
      if _pos >= tw then begin
        _pos := delta;
        _progress.Left := _progress.Left + _pos;
        _progress.Right := _progress.Left + tw;
        c := False;
      end;
    end;
    inc(_pos, delta);
    if _progress.Right >= ws then
      _progress.Right := ws;
    if _progress.Left >= ws then begin
      _progress.Left := 0;
      _progress.Right := 0;
      c := True;
      _pos := 0;
    end;
  end;
  Repaint;
end;


procedure TControlProgressBar.MarqueeStart;
begin
  marquee := True;
  delta := Width div 200;
  _pos := 0;
  c := False;
  FHandle := Classes.AllocateHWnd(_WndProc);
  Windows.SetTimer(FHandle, 1, 50,nil);
end;


procedure TControlProgressBar.MarqueeStop;
begin
  Windows.KillTimer(FHandle, 1);
  if FHandle > 0 then
    Classes.DeallocateHWnd(FHandle);
  FHandle := 0;
  marquee := False;
  _pos := 0;
end;


procedure TControlProgressBar.Repaint;
begin
  if Assigned(FOnPaint) then
    FOnPaint(Self, BoundsRect, _progress);
end;


procedure TControlProgressBar.SetBounds(ALeft, ATop, AWidth, AHeight : Integer);
begin
  inherited;
  Invalidate;
end;


procedure TControlProgressBar.SetMax(Value : Int64);
begin
  if Value = FMax then
    Exit;
  FMax := Value;
  Invalidate;
end;


procedure TControlProgressBar.SetMin(Value : Int64);
begin
  if Value = FMin then
    Exit;
  FMin := Value;
  Invalidate;
end;


procedure TControlProgressBar.SetPosition(Value : Int64);
begin
  if Value = FPosition then
    Exit;
  FPosition := Value;
  Invalidate;
end;


procedure TControlProgressBar._WndProc(var Message : TMessage);
begin
  case message.Msg of
  WM_TIMER :begin
      Invalidate;
    end;
else
  message.Result := DefWindowProc(FHandle, message.Msg, message.WParam, message.lParam);
  end;
end;

end.
