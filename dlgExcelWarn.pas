unit dlgExcelWarn;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TdlgExcelWarning = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Panel1: TPanel;
    Button2: TButton;
    Button3: TButton;
    procedure Label4Click(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Label4MouseEnter(Sender: TObject);
    procedure Label4MouseLeave(Sender: TObject);
    procedure Label5MouseEnter(Sender: TObject);
    procedure Label5MouseLeave(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dlgExcelWarning: TdlgExcelWarning;

implementation

uses
  FuncProc;

{$R *.dfm}

procedure TdlgExcelWarning.Button1Click(Sender: TObject);
begin
  modalResult := mrNo;
end;

procedure TdlgExcelWarning.Button2Click(Sender: TObject);
begin
  modalResult := mrCancel;
end;

procedure TdlgExcelWarning.Button3Click(Sender: TObject);
begin
  modalResult := mrYes;
end;


// ----------------------------------------------
// Click here for Supported Broker instructions.
// ----------------------------------------------
procedure TdlgExcelWarning.Label4Click(Sender: TObject);
begin
  weburl(supportSiteURL + 'hc/en-us/categories/115000437733');
end;

procedure TdlgExcelWarning.Label4MouseEnter(Sender: TObject);
begin
  Label4.Font.Style := [fsUnderline];
end;

procedure TdlgExcelWarning.Label4MouseLeave(Sender: TObject);
begin
  Label4.Font.Style := [];
end;


// ------------------------------------
// Click here for those instructions.
// ------------------------------------
procedure TdlgExcelWarning.Label5Click(Sender: TObject);
begin
  weburl(supportSiteURL + 'hc/en-us/sections/115001069794');
end;


procedure TdlgExcelWarning.Label5MouseEnter(Sender: TObject);
begin
  Label5.Font.Style := [fsUnderline];
end;

procedure TdlgExcelWarning.Label5MouseLeave(Sender: TObject);
begin
  Label5.Font.Style := [];
end;

end.
