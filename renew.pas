unit renew;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, Menus, StdCtrls,
  cxButtons, ExtCtrls;

type
  TpanelRenew = class(TForm)
    pnlUpdate: TPanel;
    lblImportant: TLabel;
    lblMsg: TLabel;
    Panel1: TPanel;
    btnRenew: TcxButton;
    procedure btnRenewClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure renewMsg(exp:boolean;expDate:string);
  end;

var
  panelRenew: TpanelRenew;

implementation

{$R *.dfm}

uses
  main,funcProc,TLregister,TLsettings,quickStart;

procedure TpanelRenew.btnRenewClick(Sender: TObject);
begin
  webURL('https://www.tradelogsoftware.com/purchase/?regcode='+regCode);
end;

procedure TpanelRenew.FormCreate(Sender: TObject);
begin
  parent:= frmMain;
end;

procedure TpanelRenew.renewMsg(exp:boolean;expDate:string);
begin
  if exp then begin
    lblMsg.caption:= 'Your annual subscription expired on: '+expDate;
    panelRenew.color:= clYellow;
  end else begin
    lblMsg.caption:= 'Your annual subscription will expire on: '+expDate;
    panelRenew.color:= $00B7FFFF;
  end;
  height:=30;
  align:= alBottom;
  show;
  top:= frmMain.statusBar.Top-20;
end;


end.
