unit findStocks;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, cxLookAndFeelPainters, StdCtrls, cxRadioGroup, cxButtons,
  cxControls, cxContainer, cxEdit, cxGroupBox, ExtCtrls, cxGraphics,
  cxLookAndFeels;

type
  TfrmFindStocks = class(TForm)
    btnOK: TcxButton;
    btnCancel: TcxButton;
    rgOption: TGroupBox;
    rbOptAll: TRadioButton;
    rbPuts: TRadioButton;
    rbCalls: TRadioButton;
    rgInstr: TGroupBox;
    rbStocks: TRadioButton;
    rbFutures: TRadioButton;
    rbCurr: TRadioButton;
    rgSL: TGroupBox;
    rbSL: TRadioButton;
    rbShort: TRadioButton;
    rbLong: TRadioButton;
    rgPS: TGroupBox;
    rbPS: TRadioButton;
    rbPurch: TRadioButton;
    rbSales: TRadioButton;
    cbClearFilt: TCheckBox;
    rgFut: TGroupBox;
    rbFutAll: TRadioButton;
    rbFutContr: TRadioButton;
    rbFutOpt: TRadioButton;
    rbIndex: TRadioButton;
    btnReset: TcxButton;
    rbStkOptSSF: TRadioButton;
    cbTaxYr: TCheckBox;
    rbOptions: TRadioButton;
    rbSSF: TRadioButton;
    rbMutFunds: TRadioButton;
    rbETFs: TRadioButton;
    rbDrips: TRadioButton;
    pnlSepLine: TPanel;
    procedure cbTaxYrClick(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
    procedure rbFutContrClick(Sender: TObject);
    procedure rbFutAllClick(Sender: TObject);
    procedure rbIndexClick(Sender: TObject);
    procedure rbFutOptClick(Sender: TObject);
    procedure rbCurrClick(Sender: TObject);
    procedure rbSSFClick(Sender: TObject);
    procedure rbStocksClick(Sender: TObject);
    procedure rbFuturesClick(Sender: TObject);
    procedure rbOptionsClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function findStocksDlg : Boolean;

var
  frmFindStocks: TfrmFindStocks;

implementation

{$R *.dfm}

uses
  funcProc,recordClasses, TLCommonLib;


procedure TfrmFindStocks.btnCancelClick(Sender: TObject);
begin
  hide;
  modalResult:= mrCancel;
end;


procedure TfrmFindStocks.btnOKClick(Sender : TObject);
begin
  hide;
  modalResult := mrOK;
  if cbTaxYr.checked then
    filterByDateRange(xStrToDate('01/01/' + taxyear), xStrToDate('12/31/' + taxyear));
  //
  if rbStocks.checked then
    filterByType('STK', cbClearFilt.checked)
  else if rbOptions.checked then
    filterByType('OPT', cbClearFilt.checked)
  else if rbSSF.checked then
    filterByType('SSF', cbClearFilt.checked)
  else if rbStkOptSSF.checked then
    filterByType('schedD', cbClearFilt.checked)
  else if rbFutures.checked then
    filterByType('FUT', cbClearFilt.checked)
  else if rbCurr.checked then
    filterByType('CUR', cbClearFilt.checked)
  else if rbETFs.checked then
    filterByType('ETF', cbClearFilt.checked);
  if rbMutFunds.checked then
    filterByType('MUT', cbClearFilt.checked);
  //
  if rbLong.checked then
    filterByLS('L')
  else if rbShort.checked then
    filterByLS('S');
  //
  if rbPurch.checked then
    filterPurchSales('P')
  else if rbSales.checked then
    filterPurchSales('S');
  //
  if rbPuts.checked then
    filterCallPut('* PUT')
  else if rbCalls.checked then
    filterCallPut('* CALL');
  //
  if rbFutContr.checked then
    filterByType('FUTonly', cbClearFilt.checked)
  else if rbFutOpt.checked then
    filterByType('FUTopt', cbClearFilt.checked)
  else if rbIndex.checked then
    filterByType('', cbClearFilt.checked);
end;


procedure TfrmFindStocks.btnResetClick(Sender: TObject);
begin
  rbSL.checked:= true;
  rbPS.checked:= true;
  rbOptAll.checked:= true;
  rbFutAll.checked:= true;
  cbClearFilt.checked:= false;
  cbTaxYr.checked:= false;
end;


procedure TfrmFindStocks.cbTaxYrClick(Sender: TObject);
begin
  if cbTaxYr.checked then begin
    cbClearFilt.checked:= false;
    cbClearFilt.Enabled:= false;
  end else begin
    cbClearFilt.checked:= false;
    cbClearFilt.Enabled:= true;
  end;
end;


procedure TfrmFindStocks.FormActivate(Sender: TObject);
begin
{  //fix for program crash when changing split date
  if ActivatingDialog then exit;
  ActivatingDialog := true;
  Position := poMainFormCenter;      }
end;


procedure TfrmFindStocks.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ModalResult := mrOK;
  repaintGrid;
end;


procedure TfrmFindStocks.FormShow(Sender: TObject);
begin
  repaintGrid;
end;


procedure TfrmFindStocks.rbFutAllClick(Sender: TObject);
begin
  rgOption.visible:= false;
  rbOptAll.checked:= true;
end;

procedure TfrmFindStocks.rbFutContrClick(Sender: TObject);
begin
  rgOption.visible:= false;
  rbOptAll.checked:= true;
end;

procedure TfrmFindStocks.rbFutOptClick(Sender: TObject);
begin
  rgOption.visible:= true;
  rbOptAll.checked:= true;
end;

procedure TfrmFindStocks.rbIndexClick(Sender: TObject);
begin
  rgOption.visible:= true;
  rbOptAll.checked:= true;
end;

procedure TfrmFindStocks.rbCurrClick(Sender: TObject);
begin
  btnReset.click;
  rgOption.visible:= false;
  rgFut.visible:= false;
end;

procedure TfrmFindStocks.rbFuturesClick(Sender: TObject);
begin
  btnReset.Click;
  rgOption.visible:= false;
  rgFut.visible:= true;
end;

procedure TfrmFindStocks.rbOptionsClick(Sender: TObject);
begin
  rgOption.visible:= true;
  rgFut.visible:= false;
  btnReset.click;
end;


procedure TfrmFindStocks.rbSSFClick(Sender: TObject);
begin
  btnReset.click;
  rgOption.visible:= false;
  rgFut.visible:= false;
end;

procedure TfrmFindStocks.rbStocksClick(Sender: TObject);
begin
  btnReset.Click;
  rgOption.visible:= false;
  rgFut.visible:= false;
end;

function findStocksDlg : Boolean;
begin
  frmFindStocks.Position := poMainFormCenter;
  Result := frmFindStocks.ShowModal = mrOK;
end;

end.
