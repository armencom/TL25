unit SubExpired;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, RzButton, Vcl.ExtCtrls;

type
  TfrmSubExpired = class(TForm)
    pnlMsg: TPanel;
    pnlBtns: TPanel;
    btnRenew: TRzButton;
    btnRegister: TRzButton;
    btnLater: TRzButton;
    pnlReg: TPanel;
    lbl1: TLabel;
    Label1: TLabel;
    lblRegCode: TLabel;
    lblRegName: TLabel;
    pnlExpDate: TPanel;
    lblExpDate: TLabel;
    lblExpOn: TLabel;
    msg2: TLabel;
    msg1: TLabel;
    msg3: TLabel;
    msg4: TLabel;
    procedure btnRegisterClick(Sender: TObject);
    procedure btnRenewClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSubExpired: TfrmSubExpired;

implementation

{$R *.dfm}

uses
  TLRegister;



procedure TfrmSubExpired.btnRegisterClick(Sender: TObject);
begin
  modalResult := 100;
end;

procedure TfrmSubExpired.btnRenewClick(Sender: TObject);
begin
  modalResult := 200;
end;

end.
