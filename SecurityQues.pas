unit SecurityQues;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RzButton, Vcl.StdCtrls, Vcl.Mask,
  RzEdit, RzLabel, Vcl.ExtCtrls;

type
  TdlgSecurityQues = class(TForm)
    Panel1: TPanel;
    RzLabel1: TRzLabel;
    lblQues: TRzLabel;
    RzLabel2: TRzLabel;
    edAnswer: TRzEdit;
    btnContinue: TButton;
    btnCancel: TButton;
    cbRemDevice: TCheckBox;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dlgSecurityQues: TdlgSecurityQues;

implementation

{$R *.dfm}

uses
  funcproc;

procedure TdlgSecurityQues.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if (modalResult = mrOK)
  and (edAnswer.Text = '') then
  begin
    mDlg('Answer cannot be blank', mtWarning, [mbOK], 1);
    canClose := false;
  end;
end;

end.
