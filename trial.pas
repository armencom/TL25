unit Trial;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls, Menus, cxLookAndFeelPainters, cxButtons,
  cxGraphics, cxLookAndFeels, dxSkinsCore, dxSkinHighContrast, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver;

type
  TfrmTrial = class(TForm)
    imgTrial: TImage;
    pnlTop: TPanel;
    txtDaysLeft: TLabel;
    pnlTopRight: TPanel;
    btnBuy: TcxButton;
    btnLater: TcxButton;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure btnBuyClick(Sender: TObject);
    procedure btnLaterClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmTrial: TfrmTrial;
  trialDaysLeft:integer;

implementation

{$R *.dfm}

uses
  funcproc,main,recordClasses,TLRegister,TLSettings,splash,quickStart,
  messagePanel,ShellAPI, TLCommonLib;

procedure enableMenu;
begin
  with frmMain do begin
    Enabled:= true;
//    file1.enabled:=true;
//    mnuAcct_Add.enabled:=true;
    find.enabled:=true;
    mnuOptions.enabled:=true;
    reports1.enabled:=true;
  end;
end;

procedure TfrmTrial.btnBuyClick(Sender: TObject);
begin
  webURL('https://www.tradelogsoftware.com/purchase/');
  frmMain.close;
end;

procedure TfrmTrial.btnLaterClick(Sender: TObject);
begin
  close;
end;


procedure TfrmTrial.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if (paramCount=0)
  and (TrFileName='')
  then
    panelSplash.show
  else begin
    frmMain.pnlTools.Visible := True;
    FindTradeIssues;
    frmMain.cxGrid1.SetFocus;
  end;
  panelQS.show;
  enableMenu;
end;


procedure TfrmTrial.FormCreate(Sender: TObject);
begin
  parent:= frmMain;
  align:= alClient;
end;

procedure TfrmTrial.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if key=27 then close;
end;

procedure TfrmTrial.FormShow(Sender: TObject);
begin

  trialDaysLeft:= 30 - trunc(now-xStrToDate(Settings.DateInstalled, Settings.InternalFmt));

  with frmMain do begin
    Purchase1.visible:= true;  //help, purchase menu item
    if trialDaysLeft>0 then
      if trialDaysLeft<8 then
        txtDaysLeft.caption:=
        'You only have '+intToStr(trialDaysLeft)+' DAYS LEFT in your TradeLog Free Trial'
      else
        txtDaysLeft.caption:=
        'You have '+intToStr(trialDaysLeft)+' DAYS LEFT in your TradeLog Free Trial'
    else begin
//      File1.Enabled:= false;
      Update1.visible:= false;
      stMessage.caption:= '30 DAY TRIAL EXPIRED!';
      txtDaysLeft.caption:= 'Your TradeLog Free Trial has EXPIRED.';
    end;
  end;
  if panelMsg.visible then panelMsg.Hide;

  frmTrial.setfocus;
end;


end.
