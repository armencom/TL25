unit frmExpireDate;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, RzButton, RzCmboBx;

type
  TdlgExpireDate = class(TForm)
    cbMonth: TRzComboBox;
    cbDay: TRzComboBox;
    cbYear: TRzComboBox;
    btnOK: TRzButton;
    lblDay: TLabel;
    lblMon: TLabel;
    lblYear: TLabel;
    btnCancel: TRzButton;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dlgExpireDate: TdlgExpireDate;

implementation

uses
  baseline1;

{$R *.dfm}

procedure TdlgExpireDate.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  dlgExpireDate.Free;
end;

procedure TdlgExpireDate.FormShow(Sender: TObject);
var
  i:integer;
begin
  dlgExpireDate.top:= ClientToScreen(pnlBaseline1.lblExpDate.ClientOrigin).y;
  dlgExpireDate.left:= ClientToScreen(pnlBaseline1.lblExpDate.ClientOrigin).x;
  for i := 1 to 31 do
    cbDay.AddItem(intToStr(i),self);
end;

end.
