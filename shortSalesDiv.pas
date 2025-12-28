unit shortSalesDiv;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RzButton, Vcl.StdCtrls,
  Vcl.ExtCtrls;

type
  TpanelShortSaleDiv = class(TForm)
    pnlInstr: TPanel;
    pnlTitle: TPanel;
    pnlTitleLeft: TPanel;
    lblTitle: TLabel;
    pnlClose: TPanel;
    btnClose: TRzButton;
    pnlSteps: TPanel;
    pnlInstrText: TPanel;
    lblInstrText: TLabel;
    pnlGetMoreInfo: TPanel;
    btnMoreInfo: TRzButton;
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  panelShortSaleDiv: TpanelShortSaleDiv;

implementation

{$R *.dfm}

uses
  TLCommonLib, TLSettings, funcProc, Main, recordClasses;


procedure TpanelShortSaleDiv.FormCreate(Sender: TObject);
begin
  parent := frmMain;
  align := alTop;
end;

procedure TpanelShortSaleDiv.FormShow(Sender: TObject);
begin
  filterByLS('S');
  filterByType('STK');
  FilterByOpenTrades('C');

  top := frmMain.cxGrid1.Top - 2;
  height := 100;
end;

procedure TpanelShortSaleDiv.btnCloseClick(Sender: TObject);
begin
  Close;
end;

end.
