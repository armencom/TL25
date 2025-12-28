unit dlgConsolidation;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RzButton, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TdlgConsolidate = class(TForm)
    Label2: TLabel;
    btnCancel: TButton;
    Panel1: TPanel;
    Label1: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    btnCurrAcct: TRzButton;
    btnAllAccts: TRzButton;
    procedure btnCurrAcctClick(Sender: TObject);
    procedure btnAllAcctsClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dlgConsolidate : TdlgConsolidate;
  iConsolidateMethod : integer; // 1 = careful; 2 = maximum

implementation

{$R *.dfm}

procedure TdlgConsolidate.btnAllAcctsClick(Sender: TObject);
begin
  if RadioButton1.Checked then
    iConsolidateMethod := 1
  else
    iConsolidateMethod := 2;
  modalResult := mrAll;
end;

procedure TdlgConsolidate.btnCancelClick(Sender: TObject);
begin
  iConsolidateMethod := 0;
  modalResult := mrCancel;
end;

procedure TdlgConsolidate.btnCurrAcctClick(Sender: TObject);
begin
  if RadioButton1.Checked then
    iConsolidateMethod := 1
  else
    iConsolidateMethod := 2;
  modalResult := mrYes;
end;

end.
