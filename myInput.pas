unit myInput;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmInput = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    btnOK: TButton;
    btnCancel: TButton;
    procedure btnCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
  private
    //
  public
    inputStr:string;
    procedure display(aCaption, aPrompt, aDefault : string; AllUpperCase : Boolean = False);
    procedure display2(aCaption, aPrompt, aDefault, aBtn1, aBtn2 : string; AllUpperCase : Boolean = False);
  end;

var
  frmInput: TfrmInput;

implementation

{$R *.DFM}

uses
  funcProc;

Var
  btnOKTop,btnCancelTop,Edit1TOP: integer;

procedure TfrmInput.btnCancelClick(Sender: TObject);
begin
  modalResult:= mrCancel;
  inputStr:= '';
  close;
  repaintGrid;
end;

procedure TfrmInput.FormActivate(Sender: TObject);
begin
  Position := poMainFormCenter;
  if Label1.height>13 then begin
    Edit1.top:= Edit1Top + Label1.height-13;
    btnOk.top:= btnOkTop + Label1.height-13;
    btnCancel.top:= btnCancelTop + Label1.height-13;
    Edit1.SetFocus;
  end;
end;

procedure TfrmInput.display(aCaption,aPrompt,aDefault:string; AllUpperCase : Boolean = False);
begin
  with frmInput do begin
    caption:= aCaption;
    Label1.caption:= aPrompt;
    Edit1.Text:= aDefault;
    if AllUpperCase then
      edit1.CharCase := ecUpperCase
    else
      edit1.CharCase := ecNormal;
    showModal;
  end;
end;

procedure TfrmInput.display2(aCaption, aPrompt, aDefault, aBtn1, aBtn2 : string; AllUpperCase : Boolean = False);
begin
  with frmInput do begin
    caption:= aCaption;
    Label1.caption:= aPrompt;
    Edit1.Text:= aDefault;
    if AllUpperCase then
      edit1.CharCase := ecUpperCase
    else
      edit1.CharCase := ecNormal;
    btnOk.Caption := aBtn1;
    btnCancel.Caption := aBtn2;
    showModal;
  end;
end;

procedure TfrmInput.Edit1Change(Sender: TObject);
begin
  if Edit1.Text ='' then
    btnOK.Enabled := false
  else
    btnOK.Enabled := true;
end;

procedure TfrmInput.btnOKClick(Sender: TObject);
begin
  modalResult:= mrOK;
  inputStr:= Edit1.text;
  close;
  repaintGrid;
end;

procedure TfrmInput.FormCreate(Sender: TObject);
begin
  Edit1Top:=  Edit1.top;
  btnOkTop:= btnOk.top;
  btnCancelTop:= btnCancel.top;
end;

end.
