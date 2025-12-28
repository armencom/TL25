unit fmProgress;

interface

uses
  Winapi.Windows, Winapi.Messages, //
  System.Classes, //
  Vcl.Forms, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Controls, Vcl.ComCtrls;

type
  TdlgProgress = class(TForm)
    pnlTop: TPanel;
    Label1: TLabel;
    pnlMid: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Panel1: TPanel;
    lblElapsedTime: TLabel;
    lblRemaining: TLabel;
    btnCancel: TButton;
    pnlProgBar: TPanel;
    ProgressBar1: TLabel;
    lblProgBar: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    sElapsed, sRemaining: string;
    procedure DisplayMessage(s1, s2, s3, s4, s5: string);
    procedure InitProgressBar(sDescription: string; iMin, iMax, iMode: integer);
    function ContinueProgressBar(iValue: integer): boolean;
  end;

var
  dlgProgress: TdlgProgress;
  bProgContinue: boolean;
  nPercent : double;

implementation

{$R *.dfm}

uses
  System.SysUtils, System.DateUtils, System.Variants, //
  Vcl.Graphics, Vcl.Dialogs, //
  // TradeLog units
//  frmMain, //
  globalVariables;

var
  dtStart, dtNow, dtElapsed, dtRemaining: Tdatetime;
  giProgBarMin: integer;
  giProgBarMax: integer;
  giProgBarRange: integer;
  giProgBarVal: integer;

//  ----------------------------------------------------------
//  HOW TO USE THIS UNIT:
//  1) var fProg: TdlgProgress
//  2) fProg := TdlgProgress.Create(nil);
//  3) fProg.Show;
//  4) fProg.InitProgressBar(...)
//  5) to display a message, fProg.DisplayMessage(...)
//  6) to update the progress bar, use function
//  ContinueProgressBar; if it returns true, keep
//  going, but if false, terminate the process.
//  7) fProg.Free;
//  ----------------------------------------------------------

procedure TdlgProgress.btnCancelClick(Sender: TObject);
begin
  bProgContinue := false;
end;

// -----------------------------------------------------
//  Layout: [ s1 ]
//  [ s2 ]            [ s4 ]
//  [ s3 ]            [ s5 ]
// -----------------------------------------------------
procedure TdlgProgress.DisplayMessage(s1, s2, s3, s4, s5: string);
begin
  // could get fancy and keep old value if empty string,
  // or erase old value if delete character = #
  Label1.Caption := s1;
  Label2.Caption := s2;
  Label3.Caption := s3;
  Label4.Caption := s4;
  Label5.Caption := s5;
  Application.ProcessMessages; // allow button click, etc.
  ProgressBar1.Refresh;
end;

procedure TdlgProgress.FormPaint(Sender: TObject);
begin
  progressbar1.Height := pnlProgBar.Height;
  if (nPercent > 50) then
    lblProgBar.Font.Color := clWhite
  else
    lblProgBar.Font.Color := clBlack;
end;

procedure TdlgProgress.FormShow(Sender: TObject);
begin
  height := 180;
end;

// -----------------------------------------------------
//  sDescription: tell us what we are doing
//  iMin, iMax: the range of values in the progress bar
// -----------------------------------------------------
procedure TdlgProgress.InitProgressBar(sDescription: string;
  iMin, iMax, iMode: integer);
begin
  bProgContinue := true; // assume we continue until told to cancel
  Caption := sDescription;
  giProgBarMin := iMin;
  giProgBarMax := iMax;
  giProgBarRange := (iMax - iMin);
  nPercent := 0;
  ProgressBar1.Width := 0;
  dtStart := now();
  if iMode = 1 then begin
    lblElapsedTime.Visible := false;
    lblRemaining.Visible := false;
    btnCancel.Visible := false;
    Label2.Visible := false;
    Label3.Visible := false;
    Label4.Visible := false;
    Label5.Visible := false;
  end;
  Application.ProcessMessages;
end;


// -----------------------------------------------------
//  iValue: new value of the progress bar
// -----------------------------------------------------
function TdlgProgress.ContinueProgressBar(iValue: integer): boolean;
begin
  btnCancel.Show;
  // ----- progress in terms of minutes ----------
  dtNow := now();
  // first, use dtEnd for elapsed time
  dtElapsed := IncSecond((dtNow - dtStart), 1);
  if dtElapsed > 1 then
    sElapsed := 'elapsed time: ' + FormatDateTime('h:nn:ss', dtElapsed)
  else
    sElapsed := 'elapsed time: ' + FormatDateTime('nn:ss', dtElapsed);
  lblElapsedTime.Caption := sElapsed;
  // now, compute estimated time remaining
  if iValue > giProgBarMin then
    dtRemaining := dtElapsed * (giProgBarMax - iValue) / (iValue - giProgBarMin);
  sRemaining := 'est time remaining: ' + FormatDateTime('nn:ss', dtRemaining);
  lblRemaining.Caption := sRemaining;
  // ----- progress in terms of records ---------
  Label5.Caption := FormatFloat('#,##0', iValue);
  if iValue < giProgBarMin then begin
    giProgBarVal := giProgBarMin;
    nPercent := 0;
  end
  else if iValue > giProgBarMax then begin
    giProgBarVal := giProgBarMax;
    nPercent := 100;
  end
  else
    nPercent := trunc(iValue / giProgBarMax * 100);
  lblProgBar.Caption := FloatToStrF(nPercent, ffFixed, 4, 0) + '%';
  if nPercent > 50 then
    lblProgBar.Font.Color := clWhite
  else
    lblProgBar.Font.Color := clBlue;
  // --------------------------------------------
  ProgressBar1.Width := trunc(nPercent * pnlProgBar.Width / 100.00);
  Application.ProcessMessages;
  ProgressBar1.update;
  result := bProgContinue;
end;


end.
