unit fm1099Info;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxTextEdit, Menus, cxButtons,
  cxMaskEdit, cxCurrencyEdit, RzPanel, dxSkinsCore, dxSkinHighContrast, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver;

type

  Tfrm1099info = class(TForm)
    pnlImportant: TPanel;
    lblImportant: TLabel;
    lblImportant1: TLabel;
    pnlProceeds: TPanel;
    pnl1099: TPanel;
    pnl1099Left: TPanel;
    pnl1099Cost: TPanel;
    pnlCostLT: TPanel;
    pnl1099Details: TPanel;
    pnl1099included: TPanel;
    cb1099Drips: TCheckBox;
    cb1099MutFunds: TCheckBox;
    cb1099Options: TCheckBox;
    cb1099ETFs: TCheckBox;
    lblImportant2: TLabel;
    pnlBtns: TPanel;
    btn1099Cancel: TcxButton;
    btn1099OK: TcxButton;
    btnPrint: TcxButton;
    btnReset: TcxButton;
    pnlNo1099: TPanel;
    pnlNo1099cb: TPanel;
    cbNo1099: TCheckBox;
    pnlLine: TPanel;
    pnlNo1099text: TLabel;
    pnlNo1099btn: TPanel;
    btnOK: TcxButton;
    pnlEnterTheFollowing: TPanel;
    Label2: TLabel;
    pnProceedsTop: TPanel;
    lblProceeds: TLabel;
    Panel2: TPanel;
    pnlProceedsHelp: TPanel;
    btnHelpProceeds: TcxButton;
    lblProceedsInfo: TLabel;
    pnlProceedsAmt: TPanel;
    lblAmount: TLabel;
    pnlSales: TPanel;
    ed1099Sales: TcxCurrencyEdit;
    lblProceedsOptions: TLabel;
    pnlCostTop: TPanel;
    blbCost: TLabel;
    pnlCostHelp: TPanel;
    btnHelpCost: TcxButton;
    Panel1: TPanel;
    Panel3: TPanel;
    lblCostLT: TLabel;
    pnlCostST: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    lblCostST: TLabel;
    ed1099CostSt: TcxCurrencyEdit;
    ed1099CostLT: TcxCurrencyEdit;
    Label3: TLabel;
    Panel7: TPanel;
    Panel8: TPanel;
    btnHelpDetails: TcxButton;
    lblDetails: TLabel;
    lblDetails2: TLabel;
    lblDetails1: TLabel;
    cbOptPrem: TCheckBox;
    cbOpt2013: TCheckBox;
    cbOptGL: TCheckBox;
    Label1: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnPrintClick(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
    procedure cbNo1099Click(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure cb1099OptionsClick(Sender: TObject);
    procedure btnHelpProceedsClick(Sender: TObject);
    procedure btnHelpCostClick(Sender: TObject);
    procedure btnHelpDetailsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure WMMoving(var Msg: TWMMoving);
    message WM_MOVING;
  public
    { Public declarations }
  end;

var
  frm1099info : Tfrm1099info;


implementation

{$R *.dfm}

uses
  FuncProc, TLFile, TLSettings, Main, fm1099more;


procedure Tfrm1099info.WMMoving(var Msg: TWMMoving) ;
var
  workArea: TRect;
begin
  //this function restricts moving 1099 dialog outside of main form rectangular area
  //get Main form rect area
  workArea.top := frmMain.top;
  workArea.left := frmMain.left;
  workArea.bottom := frmMain.top + frmMain.height;
  workArea.right := frmMain.left + frmMain.width;
  if frmMain.WindowState = wsMaximized then begin
    //assume an 8 pixel border
    workArea.top := workArea.top+8;
    workArea.left := workArea.left+8;
    workArea.bottom := workArea.bottom-8;
    workArea.right := workArea.right-8;
  end;
  with Msg.DragRect^ do begin
    if Left < workArea.Left then
      OffsetRect(Msg.DragRect^, workArea.Left - Left, 0) ;
    if Top < workArea.Top then
      OffsetRect(Msg.DragRect^, 0, workArea.Top - Top) ;
    if Right > workArea.Right then
      OffsetRect(Msg.DragRect^, workArea.Right - Right, 0) ;
    if Bottom > workArea.Bottom then
      OffsetRect(Msg.DragRect^, 0, workArea.Bottom - Bottom) ;
  end;
  inherited;
end;


procedure Tfrm1099info.btnHelpProceedsClick(Sender: TObject);
begin
  webURL(supportSiteURL + 'hc/en-us/sections/115000954613');
end;


procedure Tfrm1099info.btnHelpCostClick(Sender: TObject);
begin
  webURL(supportSiteURL + 'hc/en-us/sections/115000954613');
end;


procedure Tfrm1099info.btnHelpDetailsClick(Sender: TObject);
begin
  webURL(supportSiteURL + 'hc/en-us/sections/115000954613');
end;


procedure Tfrm1099info.btnOKClick(Sender: TObject);
begin
  TradeLogFile.CurrentAccount.No1099 := cbNo1099.Checked;
  TradeLogFile.CurrentAccount.CheckListItem[clReconcile1099] := cbNo1099.Checked ;
  TradeLogFile.SaveFile(true);
  close;
end;


procedure Tfrm1099info.btnPrintClick(Sender: TObject);
begin
  print;
end;


procedure Tfrm1099info.btnResetClick(Sender: TObject);
begin
  if mDlg('Resetting these values will clear all previously entered values' + CR //
    + 'and save them to your TradeLog File.' + CR //
    + CR //
    + 'Are you sure you want to reset your 1099 values?', mtWarning, [mbYes, mbNo], 0) = mrYes //
  then begin
    SaveTradesBack('1099 Info Reset');
    cbNo1099.Checked := false;
    cb1099Drips.Checked := True;
    cb1099MutFunds.Checked := True;
    cb1099Options.Checked := False;
    cb1099ETFs.Checked := True;
    cbOptPrem.Checked := False;
    ed1099Sales.EditValue := Null;
    ed1099CostST.EditValue := Null;
    ed1099CostLT.EditValue := Null;
    TradeLogFile.CurrentAccount.No1099 := cbOptGL.Checked;
    TradeLogFile.CurrentAccount.No1099 := cbOpt2013.Checked;
    TradeLogFile.CurrentAccount.No1099 := cbNo1099.Checked;
    TradeLogFile.CurrentAccount.ETFETN1099 := cb1099ETFs.Checked;
    TradeLogFile.CurrentAccount.MutualFunds1099 := cb1099MutFunds.Checked;
    TradeLogFile.CurrentAccount.Drips1099 := cb1099Drips.Checked;
    TradeLogFile.CurrentAccount.Options1099 := cb1099Options.Checked;
    TradeLogFile.CurrentAccount.SalesAdjOptions1099 := cbOptPrem.Checked;
    TradeLogFile.CurrentAccount.GrossSales1099 := '';
    TradeLogFile.CurrentAccount.CostBasis1099ST := '';
    TradeLogFile.CurrentAccount.CostBasis1099LT := '';
    TradeLogFile.SaveFile(True);
  end;
end;


procedure Tfrm1099info.cb1099OptionsClick(Sender: TObject);
begin
  if cb1099Options.Checked then begin
    if (Taxyear < '2014') then begin
      if mDlg('For tax years prior to 2014, most brokers DID NOT ' + cr //
        + 'report Options trades to the IRS on their 1099-B.' + cr //
        + cr //
        + 'Are you sure your broker reported Options trades to the IRS?' + cr //
        , mtWarning,[mbYes,mbNo],0) = mrNo
      then
        cb1099Options.Checked := false;
    end;
  end;
end;


procedure Tfrm1099info.cbNo1099Click(Sender: TObject);
begin
  pnl1099.Visible := not cbNo1099.checked;
  btnPrint.Enabled :=  not cbNo1099.checked;
  btn1099OK.Enabled :=  not cbNo1099.checked;
  btnOK.Enabled := not pnl1099.Visible;
  pnlImportant.Visible := pnl1099.Visible;
end;


procedure Tfrm1099info.FormActivate(Sender: TObject);
begin
  if pnl1099.Visible then ed1099Sales.setFocus;
end;


procedure Tfrm1099info.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    if modalResult = mrOk then begin
      TradeLogFile.CurrentAccount.ShortOptGL := cbOptGL.Checked;
      TradeLogFile.CurrentAccount.Options2013 := cbOpt2013.Checked;
      TradeLogFile.CurrentAccount.No1099 := cbNo1099.Checked;
      TradeLogFile.CurrentAccount.Drips1099 := cb1099Drips.Checked;
      TradeLogFile.CurrentAccount.MutualFunds1099 := cb1099MutFunds.Checked;
      TradeLogFile.CurrentAccount.Options1099 := cb1099Options.Checked;
      TradeLogFile.CurrentAccount.ETFETN1099 := cb1099ETFs.Checked;
      TradeLogFile.CurrentAccount.SalesAdjOptions1099 := cbOptPrem.Checked;
      if ed1099Sales.Value = Null then
        TradeLogFile.CurrentAccount.GrossSales1099 := ''
      else
        TradeLogFile.CurrentAccount.GrossSales1099 := floatToStr(ed1099Sales.Value);
      if ed1099CostST.Value = Null then
        TradeLogFile.CurrentAccount.CostBasis1099ST := ''
      else
        TradeLogFile.CurrentAccount.CostBasis1099ST := floatToStr(ed1099CostST.Value);
      if ed1099CostLT.Value = Null then
        TradeLogFile.CurrentAccount.CostBasis1099LT := ''
      else
        TradeLogFile.CurrentAccount.CostBasis1099LT := floatToStr(ed1099CostLT.Value);
      SaveTradeLogFile('',True);
    end;
  Action := caFree;
end;


procedure Tfrm1099info.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  msgTxt : String;
begin
  //cancel button clicked
  if (modalResult = mrCancel) or (TradeLogFile.TaxYear > 2012) then exit;
  msgTxt:= '';
  if not cbNo1099.checked and (ed1099Sales.Text = '') then begin
    canClose := false;
    msgTxt := 'Gross Proceeds amount cannot be left blank.' + cr //
      + '  Please enter an amount or check the' + cr //
      + '  "I Have No 1099-B for this Account" check box.' + cr;
  end;
  if (ed1099CostSt.Text = '') and (not TradeLogFile.CurrentAccount.MTM) then
  begin
    canClose := false;
    msgTxt := msgTxt +cr
      + 'Short-Term Cost Basis amount cannot be left blank.' +cr
      + '  Please enter a zero if your 1099 does not show a Short-Term Cost Basis'
      + cr;
  end;
  if msgTxt <> '' then mDlg(msgTxt, mtWarning, [mbOK], 0);
end;


procedure Tfrm1099info.FormCreate(Sender: TObject);
begin
    Screen.Cursor := crHourGlass;
    try
      cbOptGL.Checked := TradeLogFile.CurrentAccount.ShortOptGL;
      cbOpt2013.Checked := TradeLogFile.CurrentAccount.Options2013;
      cbNo1099.Checked := TradeLogFile.CurrentAccount.No1099;
      cb1099Drips.Checked := TradeLogFile.CurrentAccount.Drips1099;
      cb1099MutFunds.Checked := TradeLogFile.CurrentAccount.MutualFunds1099;
      cb1099Options.Checked := (TradelogFile.TaxYear > 2013) or TradeLogFile.CurrentAccount.Options1099;
      cb1099ETFs.Checked := TradeLogFile.CurrentAccount.ETFETN1099;
      cbOptPrem.Checked := TradeLogFile.CurrentAccount.SalesAdjOptions1099;
      if (TradeLogFile.CurrentAccount.GrossSales1099 = '0.00')
      or (TradeLogFile.CurrentAccount.GrossSales1099 = '') then
        ed1099Sales.EditValue := Null
      else
        ed1099Sales.EditValue := TradeLogFile.CurrentAccount.GrossSales1099;
      // end if
      if (TradeLogFile.CurrentAccount.CostBasis1099ST = '0.00')
      or (TradeLogFile.CurrentAccount.CostBasis1099ST = '') then
        ed1099CostST.EditValue := Null
      else
        ed1099CostST.EditValue := TradeLogFile.CurrentAccount.CostBasis1099ST;
      // end if
      if (TradeLogFile.CurrentAccount.CostBasis1099LT = '0.00')
      or (TradeLogFile.CurrentAccount.CostBasis1099LT = '') then
        ed1099CostLT.EditValue := Null
      else
        ed1099CostLT.EditValue := TradeLogFile.CurrentAccount.CostBasis1099LT;
    finally
      Screen.Cursor := crDefault;
    end;
end;


procedure Tfrm1099info.FormShow(Sender: TObject);
begin
  pnlImportant.Visible := (TradeLogfile.TaxYear > 2010) and not TradeLogFile.CurrentAccount.MTM;
  pnl1099Details.Visible := pnlImportant.Visible;
  if TradeLogFile.TaxYear > 2012 then pnl1099Cost.Hide;
  if TradeLogFile.TaxYear > 2013 then lblProceedsOptions.visible := false;
  if (TradeLogFile.TaxYear >= 2014) then begin
    if (TradeLogFile.CurrentAccount.FileImportFormat <> 'BOA') then
      cbOptPrem.Checked := true;
    cb1099Options.Hide;
    cb1099ETFs.Hide;
    cb1099Drips.Hide;
    cb1099MutFunds.Hide;
    cbOptGL.Show;
    cbOpt2013.Show;
  end;
  if TradeLogFile.CurrentAccount.MTM then begin
    pnl1099Details.Visible := true;
    lblDetails2.Visible := false;
    pnl1099Included.Visible := false;
    cbOptGL.Visible := true;
    pnl1099Cost.Hide;
    Height := pnlProceeds.Height + pnlBtns.Height + pnlNo1099.Height + 60;
  end
  else begin
    pnl1099.AutoSize := true;
    pnl1099.Align := alClient;
    Height := pnl1099.Height + pnlBtns.Height + pnlNo1099.Height + 40;
  end;
end;


end.
