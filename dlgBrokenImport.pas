unit dlgBrokenImport;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TdlgBrokenImpHelp = class(TForm)
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
  dlgBrokenImpHelp: TdlgBrokenImpHelp;


implementation

uses
  funcProc;

{$R *.dfm}

procedure TdlgBrokenImpHelp.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
  exit;
end;

procedure TdlgBrokenImpHelp.btnProceedClick(Sender: TObject);
begin
  ModalResult := mrOK;
  exit;
end;


procedure TdlgBrokenImpHelp.Label3Click(Sender: TObject);
begin
  // display help
  webURL(supportSiteURL + 'hc/en-us/articles/115004393953');
end;

procedure TdlgBrokenImpHelp.Label3MouseEnter(Sender: TObject);
begin // mouseover
  Label3.Font.Style := [fsUnderline];
end;

procedure TdlgBrokenImpHelp.Label3MouseLeave(Sender: TObject);
begin
  Label3.Font.Style := [];
end;

end.
