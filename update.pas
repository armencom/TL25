unit update;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, Menus, cxControls,
  cxContainer, cxEdit, cxProgressBar, StdCtrls, cxButtons, ExtCtrls;

type
  TpanelUpdate = class(TForm)
    pnlUpdate: TPanel;
    lblImportant: TLabel;
    lblMsg: TLabel;
    pbDLupdate: TcxProgressBar;
    Panel1: TPanel;
    btnUpdate: TcxButton;
    procedure btnUpdateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure showUpdate(ver:string);
  end;

var
  panelUpdate: TpanelUpdate;

implementation

{$R *.dfm}

uses
  main,funcProc,TLregister,TLsettings,quickStart, TLUpdate;

procedure TpanelUpdate.FormCreate(Sender: TObject);
begin
  parent:= frmMain;
end;

procedure TpanelUpdate.showUpdate(ver:string);
begin
  exit;

  if oneYrLocked then exit;
  lblMsg.caption:= 'Version: '+ver+' is Now Available!';
  height:=30;
  align:= alBottom;
  show;
  top:=frmMain.statusBar.Top-20;
end;

procedure TpanelUpdate.btnUpdateClick(Sender: TObject);
begin
  UpdateInformation.GetAndInstallUpdate;
end;


end.
