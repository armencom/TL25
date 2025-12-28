unit AdjCostBasisAmt;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, StdCtrls;

type
  TdlgAdjCostBasisAmt = class(TForm)
    lblPrompt: TLabel;
    edValue: TEdit;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    btnOK: TButton;
    btnCancel: TButton;
    cboPerShare: TComboBox;
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    AdjustAmount: double;
    bPerShare: boolean;
  end;

var
  dlgAdjCostBasisAmt: TdlgAdjCostBasisAmt;

implementation

{$R *.dfm}

procedure TdlgAdjCostBasisAmt.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;


procedure TdlgAdjCostBasisAmt.btnOKClick(Sender: TObject);
var
  code: integer;
begin
  val(edValue.Text, AdjustAmount, code);
  if code <> 0 then begin
    beep;
    exit;
  end;
  if cboPerShare.ItemIndex = 1 then bPerShare := true else bPerShare := false;
  if RadioButton2.Checked then AdjustAmount := -AdjustAmount;
  ModalResult := mrOK;
end;


procedure TdlgAdjCostBasisAmt.FormCreate(Sender: TObject);
begin
  edValue.SelectAll;
end;

end.
