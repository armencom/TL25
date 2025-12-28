unit ReadMe;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ShellAPI,
  StdCtrls, ExtCtrls, ComCtrls, ToolWin, Menus, cxLookAndFeelPainters, cxButtons,
  jpeg, cxGraphics, cxLookAndFeels, dxGDIPlusClasses, dxSkinsCore, dxSkinHighContrast,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver;

type
  TfrmReadMe = class(TForm)
    richNewfeatures: TRichEdit;
    richReadMe: TRichEdit;
    btnClose: TcxButton;
    btnPrint: TcxButton;
    btnTestConnection: TcxButton;
    btnReadMe: TcxButton;
    Image1: TImage;
    txtVer: TLabel;
    txtCR: TLabel;
    txtSuptExp: TLabel;
    txtProd: TLabel;
    txtReg: TLabel;
    Label1: TLabel;
    txtDate: TLabel;
    procedure btnCloseClick(Sender: TObject);
    procedure btnReadMeClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure btnTestConnectionClick(Sender: TObject);
    procedure txtRegClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmReadMe: TfrmReadMe;

implementation

uses Main,TLRegister, funcProc, clipbrd, TLSettings, Ping2;

{$R *.DFM}

var
  readMeRead:boolean;

procedure TfrmReadMe.btnCloseClick(Sender: TObject);
begin
  if readMeRead
  or (pos('About',caption)>0)
  then begin
    modalresult:= mrCancel;
  end else
    btnreadMe.click;
end;

procedure TfrmReadMe.btnReadMeClick(Sender: TObject);
begin
  if richNewFeatures.Visible then begin
    richNewFeatures.Visible:= false;
    richReadMe.Visible:= true;
    btnReadMe.caption:= 'New Features';
    frmReadMe.caption:= 'Read Me';
    readMeRead:= true;
  end else begin
    richNewFeatures.Visible:= true;
    richReadMe.Visible:= false;
    btnReadMe.caption:= 'Read Me';
    frmReadMe.caption:= 'New Features';
  end;
end;


procedure TfrmReadMe.btnTestConnectionClick(Sender: TObject);
Var
  s : string;
  i, n : integer;
begin
  n := 0;
  s := 'brokerconnect.live';
  for i := 1 to 4 do
    if PingHost(s) then inc(n);
  if n = 4 then
    sm('PASS: 100% able to ping the website.')
  else if n = 0 then
    sm('FAIL: unable to ping the website at all.')
  else
    sm('Ping website succeeded ' + IntToStr(n) + ' of 4 tries.');
end;


procedure TfrmReadMe.btnPrintClick(Sender: TObject);
var
  printDialog:TPrintDialog;
begin
  // Create a printer selection dialog
  printDialog := TPrintDialog.Create(frmReadMe);
  try
    if printDialog.Execute then begin
      if richNewFeatures.Visible then
        richNewFeatures.print('')
      else begin
        richReadMe.print('');
      end;
    end;
  finally
    printDialog.Free;
  end;
  close;
end;

procedure TfrmReadMe.FormActivate(Sender: TObject);
begin
  btnClose.SetFocus;
end;

procedure TfrmReadMe.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=27 then btnClose.click;
end;

procedure TfrmReadMe.txtRegClick(Sender: TObject);
Var
 s:string;
begin
  s:= Settings.Regcode;
  clipboard.AsText:= s;
  with richNewfeatures do begin
    //selectAll;
  end;
  close;
end;

end.
