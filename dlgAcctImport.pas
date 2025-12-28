unit dlgAcctImport;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TdlgCanProHelp = class(TForm)
    btnCancel: TButton;
    btnProceed: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure Label3Click(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnProceedClick(Sender: TObject);
    procedure Label3MouseEnter(Sender: TObject);
    procedure Label3MouseLeave(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dlgCanProHelp: TdlgCanProHelp;


implementation

uses
  funcProc;

{$R *.dfm}

procedure TdlgCanProHelp.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
  exit;
end;

procedure TdlgCanProHelp.btnProceedClick(Sender: TObject);
begin
  ModalResult := mrOK;
  exit;
end;

procedure TdlgCanProHelp.Label3Click(Sender: TObject);
begin
  // display help
  webURL(supportSiteURL + 'hc/en-us/categories/115000437733');
end;

procedure TdlgCanProHelp.Label3MouseEnter(Sender: TObject);
begin // mouseover
  Label3.Font.Style := [fsUnderline];
end;

procedure TdlgCanProHelp.Label3MouseLeave(Sender: TObject);
begin
  Label3.Font.Style := [];
end;

end.
