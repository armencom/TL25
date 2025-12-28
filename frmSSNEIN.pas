unit frmSSNEIN;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore,
  dxSkinHighContrast, dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxGDIPlusClasses, cxImage;

type
  TdlgSSNEIN = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Label2: TLabel;
    MaskEdit1: TMaskEdit;
    btnOK: TButton;
    Label4: TLabel;
    Label3: TLabel;
    lblMoreInfo: TLabel;
    RadioButton3: TRadioButton;
    cxImage1: TcxImage;
    procedure FormCreate(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lblMoreInfoClick(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dlgSSNEIN: TdlgSSNEIN;

implementation

uses
  globalVariables, funcproc, TLSettings;

{$R *.dfm}

procedure TdlgSSNEIN.btnOKClick(Sender: TObject);
begin
  modalresult := mrOK;
end;


procedure TdlgSSNEIN.FormCreate(Sender: TObject);
begin
  MaskEdit1.EditText := '';
  Settings.IsEIN := false; // 2024-02-23 MB default
  RadioButton1.Checked := true; // default
end;

procedure TdlgSSNEIN.FormShow(Sender: TObject);
begin
  MaskEdit1.SetFocus;
end;


procedure TdlgSSNEIN.lblMoreInfoClick(Sender: TObject);
begin
  webURL('https://support.tradelogsoftware.com/hc/en-us/articles/4403915562647');
end;


procedure TdlgSSNEIN.RadioButton1Click(Sender: TObject);
begin
  MaskEdit1.EditMask := 'aaa-aa-aaaa'; // SSN
  Settings.IsEIN := false; // 2024-02-23 MB
end;

procedure TdlgSSNEIN.RadioButton2Click(Sender: TObject);
begin
  MaskEdit1.EditMask := 'aa-aaaaaaa'; // EIN
  Settings.IsEIN := true; // 2024-02-23 MB
end;

procedure TdlgSSNEIN.RadioButton3Click(Sender: TObject);
begin
  MaskEdit1.EditMask := 'aaa-aa-aaaa'; // SSN
  MaskEdit1.EditText := '___-__-____';
  Settings.IsEIN := false; // 2024-02-23 MB
end;


end.
