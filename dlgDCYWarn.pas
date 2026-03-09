unit dlgDCYWarn;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TdlgDCYWarning = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    btnOK: TButton;
    procedure btnOKClick(Sender: TObject);
    procedure Label3MouseEnter(Sender: TObject);
    procedure Label3MouseLeave(Sender: TObject);
    procedure Label3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dlgDCYWarning: TdlgDCYWarning;

implementation

uses
  funcproc;

{$R *.dfm}

procedure TdlgDCYWarning.btnOKClick(Sender: TObject);
begin
  modalResult := mrYes;
end;

procedure TdlgDCYWarning.Label3Click(Sender: TObject);
begin
  weburl(supportSiteURL + '/hc/en-us/articles/360001914193');
end;

procedure TdlgDCYWarning.Label3MouseEnter(Sender: TObject);
begin
  Label3.Font.Style := [fsUnderline];
end;

procedure TdlgDCYWarning.Label3MouseLeave(Sender: TObject);
begin
  Label3.Font.Style := [];
end;

end.
