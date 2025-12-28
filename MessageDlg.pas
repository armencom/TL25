unit MessageDlg;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseDialog, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, Vcl.StdCtrls, cxButtons, Vcl.ExtCtrls, dxSkinsCore,
  dxSkinHighContrast, dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver;

type
  TMessageDialog = class(TBaseDlg)
    Panel1: TPanel;
    pnlButtons: TPanel;
    Panel3: TPanel;
    lbHeaderMessage: TLabel;
    memoBodyMessage: TMemo;
    cxButton1: TcxButton;
    pnlThirdMessage: TPanel;
    lbFooterMessage: TLabel;
    imgIcon: TImage;
  private
    { Private declarations }
  public
    { Public declarations }
    class function Execute(HeaderMsg, BodyOfMsg, FooterMsg : String;
      FormCaption : String = ''; DlgType : TMsgDlgType = mtInformation) : TModalResult; reintroduce;

  end;

var
  MessageDialog: TMessageDialog;


implementation

{$R *.dfm}
var
  IconIDs: array[TMsgDlgType] of PChar = (IDI_EXCLAMATION, IDI_HAND,
    IDI_ASTERISK, IDI_QUESTION, nil);

{ TForm1 }


class function TMessageDialog.Execute(HeaderMsg, BodyOfMsg, FooterMsg : String;
  FormCaption : String = ''; DlgType : TMsgDlgType = mtInformation): TModalResult;
var
  IconID : PChar;
begin
  With create(Application.MainForm) Do
  begin
    IconID := IconIDs[DlgType];
    if IconID <> nil then
    begin
      ImgIcon.Visible := True;
      ImgIcon.Picture.Icon.Handle := LoadIcon(0, IconID);
      ImgIcon.SetBounds(15,15,32,32);
      lbHeaderMessage.Margins.Left := 75;
    end
    else
    begin
      ImgIcon.Visible := False;
      lbHeaderMessage.Margins.Left := 20;
    end;

    if Length(FormCaption) > 0 then
      Caption := FormCaption;
    if Length(HeaderMsg) > 0 then
      lbHeaderMessage.Caption := HeaderMsg;
    if Length(BodyOfMsg) > 0 then
      memoBodyMessage.Lines.Text := BodyOfMsg;
    if Length(FooterMsg) > 0 then
      lbFooterMessage.Caption := FooterMsg;
    Result := showModal;
  end;
end;

end.
