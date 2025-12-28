unit baseline;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, RzLabel, RzEdit,
  RzButton, Vcl.ExtCtrls, Vcl.Grids, RzGrids, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB, cxDBData,
  cxGridCustomTableView, cxGridTableView, cxGridLevel,
  cxClasses, cxGridCustomView, cxGrid, cxLabel, cxMemo, cxTextEdit,
  cxDropDownEdit, cxBlobEdit, cxRichEdit, RzPanel, Vcl.DBCtrls, RzDBEdit,
  Vcl.ComCtrls, RzSplit, Vcl.OleCtrls, SHDocVw;

type
  TpnlBaseline = class(TForm)
    pnlTitle: TPanel;
    pnlTitleLeft: TPanel;
    lblTitle: TLabel;
    pnlClose: TPanel;
    btnClose: TRzButton;
    pnlBtn: TPanel;
    pnl1: TPanel;
    pnl2: TPanel;
    Panel1: TPanel;
    btnGetMoreInfo: TRzButton;
    wb1: TWebBrowser;
    wb2: TWebBrowser;
    btnEnterBaseline: TRzButton;
    btnBegin: TRzButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnGetMoreInfoClick(Sender: TObject);
    procedure btnBeginClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure wb1DocumentComplete(ASender: TObject; const pDisp: IDispatch;
      const URL: OleVariant);
    procedure wb2DocumentComplete(ASender: TObject; const pDisp: IDispatch;
      const URL: OleVariant);
    procedure btnEnterBaselineClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  pnlBaseline: TpnlBaseline;

implementation

{$R *.dfm}

Uses
  main, TLSettings, funcproc, baseline1, MSHTML, activeX, TLfile, globalVariables;


procedure loadHTML(wb : TWebBrowser; HTMLCode: string);
var
  sl: TStringList;
  ms: TMemoryStream;
  Document : IHTMLDocument2;
  Element : IHTMLElement;
begin
  wb.Navigate('about:blank') ;
  while wb.ReadyState < READYSTATE_INTERACTIVE do
    Application.ProcessMessages;
  HTMLcode:='<html><head>'+
    '<style>'+
    'body{margin:0;padding:0;font:11pt Tahoma}'+
    'p{margin:10px 0 0 0;padding:6px;border:3px solid red;}'+
    'ul{padding:0; margin:-4px 0 8px 20px;} '+
    'li{padding:0; margin:10p 0 0 0;}'+
    'div{float:left;text-align:center;width:320px;}'+
    'blockquote{padding:0 0 0 10px;margin:0;}'+
    'hr{line-height:1px;}'+
    '</style>'+
    '<head>'+
    '<body>'+
    HTMLcode+'</body></html>';
  if Assigned(wb.Document) then begin
     sl := TStringList.Create;
     try
       ms := TMemoryStream.Create;
       try
         sl.Text := HTMLCode;
         sl.SaveToStream(ms) ;
         ms.Seek(0, 0) ;
         (wb.Document as IPersistStreamInit).Load(TStreamAdapter.Create(ms)) ;
       finally
         ms.Free;
       end;
     finally
       sl.Free;
     end;
  end;
end;


procedure TpnlBaseline.FormActivate(Sender: TObject);
begin
  glbBLWizOpen := true; // not sure if this works here
end;

procedure TpnlBaseline.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
//  frmMain.menu := frmMain.MainMenu; // 2021-05-10 MB - no longer used
  frmMain.EnableTabItems('enableEdits'); // 2021-06-28 MB - enable all
  frmMain.EnableMenuToolsAll;
  frmMain.pnlTools.Show;
  freeAndNil(pnlBaseline);     //freeing baseline also frees baseline1
  frmMain.SetupToolBarMenuBar(false); // 2022-01-24 MB
end;


procedure TpnlBaseline.FormCreate(Sender: TObject);
begin
  parent := frmMain;
  align := alClient;
end;


procedure TpnlBaseline.FormShow(Sender: TObject);
begin
  disableMenuTools;
  frmMain.menu := nil;
  frmMain.pnlTools.Hide;
  pnl2.Align := alClient;
  loadHTML(wb1,'Entering baseline positions is an <b>IMPORTANT STEP</b> for <b>FIRST-TIME TRADELOG USERS ONLY</b>.<br>'+
    ' - If you used TradeLog last year, please exit this wizard.');
  loadHTML(wb2,'<ul><li>Baseline positions are the positions you held open going into the start of the first tax year using TradeLog.</li>'+
    '<li>TradeLog has no way of automatically identifying your baseline positions.'+
    ' This wizard will ask you to enter some information from your <b>December '+lastTaxYear+' Statement</b> for this brokerage account.'+
    ' TradeLog will then use imported data to help complete your baseline positions.</li>'+
    '<li>This process only needs to be done once for each account. TradeLog will automatically keep track of the'+
    ' baseline positions for each subsequent tax year when you run the End Tax Year procedure.</li>'+
    '<li>If you did not have any positions held open at the end of '+lastTaxYear+' then you do not need to enter baseline'+
    ' positions, you can Exit this wizard. If you are not sure, then we recommend continuing with this wizard.</li></ul>'
    );
  btnBegin.Default := true;
end;


procedure TpnlBaseline.wb1DocumentComplete(ASender: TObject;
  const pDisp: IDispatch; const URL: OleVariant);
begin
  with wb1 do begin
    OleObject.document.body.style.overflowX := 'hidden';
    OleObject.document.body.style.overflowY := 'hidden';
    OleObject.document.body.style.borderstyle := 'none';
  end;
end;


procedure TpnlBaseline.wb2DocumentComplete(ASender: TObject;
  const pDisp: IDispatch; const URL: OleVariant);
begin
  with wb2 do begin
    OleObject.document.body.style.overflowX := 'hidden';
    OleObject.document.body.style.overflowY := 'auto';
    OleObject.document.body.style.borderstyle := 'none';
  end;
end;


procedure TpnlBaseline.btnCloseClick(Sender: TObject);
begin
  glbBLWizOpen := false;
  close;
end;


procedure TpnlBaseline.btnEnterBaselineClick(Sender: TObject);
begin
  pnlBaseline.hide;
  frmMain.EnterOpenPositions1Click(Sender);
  close;
end;


procedure TpnlBaseline.btnGetMoreInfoClick(Sender: TObject);
begin
  webURL(supportSiteURL + 'hc/en-us/sections/115000956834');
end;


procedure TpnlBaseline.btnBeginClick(Sender: TObject);
begin
  //self attaches this form to pnlBaseline so when baseline is freed, baselin1 gets freed as well
  pnlBaseline1 := TpnlBaseline1.Create(self);
  pnlBaseline1.show;
  pnlBaseline.hide;
end;


procedure TpnlBaseline.FormResize(Sender: TObject);
var
  c, gap : integer;
begin
  // center the buttons
  c := pnlBtn.Width div 2;
  btnBegin.Left := (c - btnBegin.Width - 50);
  btnEnterBaseline.Left := c + 50;
  // adjust font if necessary
  if width < 600 then
    font.Size := 8
  else if width < 1020 then
    font.Size := 10
  else
    font.Size := 12;
end;


end.
