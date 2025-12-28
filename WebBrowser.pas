unit WebBrowser;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, SHDocVw, StdCtrls, Buttons, ExtCtrls, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Menus, cxButtons, dxSkinsCore,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010,
  dxSkinWhiteprint, dxSkinXmas2008Blue, dxSkinBasic, dxSkinMetropolis,
  dxSkinMetropolisDark, dxSkinOffice2013DarkGray, dxSkinOffice2013LightGray,
  dxSkinOffice2013White, dxSkinOffice2016Colorful, dxSkinOffice2016Dark,
  dxSkinOffice2019Black, dxSkinOffice2019Colorful, dxSkinOffice2019DarkGray,
  dxSkinOffice2019White, dxSkinTheBezier, dxSkinVisualStudio2013Blue,
  dxSkinVisualStudio2013Dark, dxSkinVisualStudio2013Light;

type
  TfrmWebBrowserPopup = class(TForm)
    WebBrowser1: TWebBrowser;
    pnlButtons: TPanel;
    btnUpdate: TcxButton;
    pnlClose: TPanel;
    btnClose: TcxButton;
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure WebBrowser1DocumentComplete(ASender: TObject;
      const pDisp: IDispatch; var URL: OleVariant);
    procedure btnUpdateClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure WebBrowser1BeforeNavigate2(ASender: TObject;
      const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
      Headers: OleVariant; var Cancel: WordBool);
    procedure WebBrowser1FileDownload(ASender: TObject;
      ActiveDocument: WordBool; var Cancel: WordBool);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmWebBrowserPopup: TfrmWebBrowserPopup;

implementation

{$R *.dfm}

uses
  funcProc, TLupdate, Main;

procedure TfrmWebBrowserPopup.btnCloseClick(Sender: TObject);
begin
  Close;
end;

//
procedure TfrmWebBrowserPopup.btnUpdateClick(Sender: TObject);
begin
  sm('do software update');
//  if Not UpdateInformation.Updating then begin
//    if mDlg('Tradelog will close and install version ' + UpdateInformation.UpdateVersion + '!' + cr //
//      + cr //
//      + 'Are you sure you want to install the update now?', mtWarning, [mbOK, mbCancel], 0) = mrOK //
//    then begin
//      Enabled := False;
//      frmMain.Enabled := False;
//      if UpdateInformation.UpdateReadyToInstall then
//        UpdateInformation.InstallUpdate
//      else
//        UpdateInformation.GetAndInstallUpdate;
//    end;
//  end;
end;

procedure TfrmWebBrowserPopup.FormCreate(Sender: TObject);
begin
  BorderStyle := bsNone;
  Parent := frmMain;
end;


procedure TfrmWebBrowserPopup.FormShow(Sender: TObject);
begin
  Width := frmMain.ClientWidth;
  Height := frmMain.ClientHeight - frmMain.StatusBar.Height;
  WebBrowser1.Navigate('https://support.tradelogsoftware.com/hc/en-us/articles/10061386077207');
  WebBrowser1.SetFocus;
end;

procedure TfrmWebBrowserPopup.WebBrowser1BeforeNavigate2(ASender: TObject;
  const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
  Headers: OleVariant; var Cancel: WordBool);
begin
  if URL <> 'https://support.tradelogsoftware.com/hc/en-us/articles/10061386077207' then
    Cancel := True;
end;

procedure TfrmWebBrowserPopup.WebBrowser1DocumentComplete(ASender: TObject; const pDisp: IDispatch; var URL: OleVariant);
begin
  statBar('off');
end;

procedure TfrmWebBrowserPopup.WebBrowser1FileDownload(ASender: TObject;
  ActiveDocument: WordBool; var Cancel: WordBool);
begin
  Cancel := True;
end;

end.
