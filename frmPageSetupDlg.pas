unit frmPageSetupDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, Printers, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Menus, cxButtons, dxSkinsCore, dxSkinHighContrast, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver;

type

  TPageSetupDlg = class(TForm)
    pnlMain: TPanel;
    grpMargins: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    edMarginLeft: TEdit;
    edMarginTop: TEdit;
    edMarginRight: TEdit;
    edMarginBottom: TEdit;
    rgOrientation: TRadioGroup;
    ckRedNegativeValues: TCheckBox;
    grpFontSizes: TGroupBox;
    Label9: TLabel;
    Label10: TLabel;
    cbFontHeadings: TComboBox;
    cbFontData: TComboBox;
    grpInitialPreview: TGroupBox;
    ckFullScreen: TCheckBox;
    btnFitToPage: TRadioButton;
    btnFitToWidth: TRadioButton;
    pnlButtons: TPanel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
//    procedure ckUseEinClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
   constructor Create(AOwner: TComponent); overload;
   procedure saveData;
  public
    { Public declarations }
    constructor Create; reintroduce; overload;
    class function Execute : TModalResult;
  end;


implementation

uses
  TLSettings, TLFile;

Const
    SSNWidth : Integer = 30;
    EINWidth : Integer = 100;
    SSNLabel : String = 'Social Security Number:';
    EINLabel : String = 'Employer Identification Number:';
    SSN1Length : Integer = 3;
    SSN2Length : Integer = 2;
    SSN3Length : Integer = 4;
    EIN1Length : Integer = 2;
    EIN2Length : Integer = 7;


{$R *.dfm}

procedure TPageSetupDlg.saveData;
var
  PageSetupData : TReportPageData;
begin
  PageSetupData := Settings.ReportPageData;
  PageSetupData.FontHeadingSize := StrToInt(cbFontHeadings.Text);
  PageSetupData.FontDataSize := StrToInt(cbFontData.Text);
  PageSetupData.PreviewFullScreen := ckFullScreen.Checked;
  PageSetupData.FitToWidth := btnFitToWidth.Checked;

  PageSetupData.Orientation := TPrinterOrientation(rgOrientation.ItemIndex);
  PageSetupData.Margins.Left := Trunc(StrToFloat(edMarginLeft.Text) * 1000);
  PageSetupData.Margins.Right := Trunc(StrToFloat(edMarginRight.Text) * 1000);
  PageSetupData.Margins.Top := Trunc(StrToFloat(edMarginTop.Text) * 1000);
  PageSetupData.Margins.Bottom := Trunc(StrToFloat(edMarginBottom.Text) * 1000);
  PageSetupData.UseColor := ckRedNegativeValues.Checked;
//  Settings.IsEin := ckUseEin.Checked;
  //If they have nothing in box 1 then we will zero SSN out otherwise we will
  //capture it into the SSN value.
//  if Length(ProHeader.taxpayer) > 0 then
//  begin
//    Settings.SSN := ProHeader.taxpayer; // + '-' + edSSN2.Text;
//    if Not Settings.IsEin then
//      Settings.SSN := Settings.SSN +  '-' + edSSN3.Text;
//  end
//  else
//    Settings.SSN := '';
  Settings.NameOnReports := ProHeader.taxFile;
  Settings.ReportPageData := PageSetupData;
end;


//procedure TPageSetupDlg.ckUseEinClick(Sender: TObject);
//begin
//  lbSSNDash2.visible := not ckUseEin.checked;
//  edSSN3.visible := not ckUseEin.checked;
//  edSSN1.Text := '';
//  edSSN2.Text := '';
//  edSSN3.Text := '';
//  if ckUseEin.checked then
//  begin
//    edSSN2.Width := EINWidth;
//    lbSSNEIN.Caption := EINLabel;
//    edSSN1.MaxLength := EIN1Length;
//    edSSN2.MaxLength := EIN2Length;
//  end
//  else
//  begin
//    edSSN2.Width := SSNWidth;
//    lbSSNEIN.Caption := SSNLabel;
//    edSSN1.MaxLength := SSN1Length;
//    edSSN2.MaxLength := SSN2Length;
//  end;
//end;

constructor TPageSetupDlg.Create;
begin
   raise Exception.Create('Constructor Disabled, Use Execute Class Method Instead.')
end;

constructor TPageSetupDlg.Create(AOwner: TComponent);
begin
  inherited;
end;

class function TPageSetupDlg.Execute : TModalResult;
var
  PageSetupData : TReportPageData;
begin
  With create(Nil) Do
  begin
    PageSetupData := Settings.ReportPageData;
    cbFontHeadings.Text := IntToStr(PageSetupData.FontHeadingSize);
    cbFontData.Text := IntToStr(PageSetupData.FontDataSize);
    ckFullScreen.Checked := PageSetupData.PreviewFullScreen;
    btnFitToWidth.Checked := PageSetupData.FitToWidth;
    btnFitToPage.Checked := Not PageSetupData.FitToWidth;
//    ckUseEin.Checked := Settings.IsEin;
//    if Settings.IsEin then
//    begin
//      edSSN1.Text := Copy(Settings.SSN, 1, EIN1Length);
//      edSSN2.Text := Copy(Settings.SSN, 4, EIN2Length);
//      edSSN3.Text := '';
//    end
//    else
//    begin
//      edSSN1.Text := Copy(Settings.SSN, 1, SSN1Length);
//      edSSN2.Text := Copy(Settings.SSN, 5, SSN2Length);
//      edSSN3.Text := Copy(Settings.SSN, 8, SSN3Length);
//    end;
    rgOrientation.ItemIndex := Integer(PageSetupData.Orientation);
    edMarginLeft.Text := FloatToStr(PageSetupData.Margins.Left / 1000);
    edMarginRight.Text := FloatToStr(PageSetupData.Margins.Right / 1000);
    edMarginTop.Text := FloatToStr(PageSetupData.Margins.Top / 1000);
    edMarginBottom.Text := FloatToStr(PageSetupData.Margins.Bottom / 1000);
    ckRedNegativeValues.Checked := PageSetupData.UseColor;
//    if settings.NameOnReports='' then edHeaderName.Text := Settings.AcctName
//    else edHeaderName.Text := Settings.NameOnreports;
    Result := showModal;
    if Result = mrOk then
      saveData;
  end;

end;

procedure TPageSetupDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TPageSetupDlg.FormCreate(Sender: TObject);
begin
//  ckUseEinClick(Sender);
end;

end.
