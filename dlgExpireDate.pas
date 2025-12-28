unit dlgExpireDate;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, RzButton, RzCmboBx;

type
  TfrmExpireDate = class(TForm)
    cbMonth: TRzComboBox;
    cbDay: TRzComboBox;
    cbYear: TRzComboBox;
    btnOK: TRzButton;
    lblDay: TLabel;
    lblMon: TLabel;
    lblYear: TLabel;
    btnCancel: TRzButton;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmExpireDate: TfrmExpireDate;

implementation

{$R *.dfm}

procedure TfrmExpireDate.FormShow(Sender: TObject);
var
  i:integer;
begin
  for i := 1 to 31 do
    cbDay.AddItem(intToStr(i),self);
end;

end.
