unit HelpMsg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, ExtCtrls, Menus, cxLookAndFeelPainters, cxButtons,
  cxGraphics, cxLookAndFeels;

type
  TfrmHelpMsg = class(TForm)
    lblMsg: TMemo;
    btnCancel: TcxButton;
    btnGetHelp: TcxButton;
    btnDispNeg: TcxButton;
    procedure btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnGetHelpClick(Sender: TObject);
    procedure btnDispNegClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
  end;

  procedure ShowHelpMsg(capTxt,msgStr:string);

var
  frmHelpMsg: TfrmHelpMsg;

implementation

uses Main, FuncProc, TLRegister, RecordClasses, cxFilter, Web, TLSettings;

var
  dispHlpMsg:boolean;

{$R *.DFM}

procedure TfrmHelpMsg.btnCancelClick(Sender: TObject);
begin
  close;
end;

procedure TfrmHelpMsg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  if not dispHlpMsg then
    NegClosedTrNums.Free;
  dispHlpMsg:= false;
  NegClosedTrNums.Clear;
  NegClosedTrNums.Free;
end;

procedure TfrmHelpMsg.btnGetHelpClick(Sender: TObject);
begin
  HtmlHelp(GetDesktopWindow, pchar(Settings.HelpFileName), HH_HELP_CONTEXT, 19200) ;
end;

procedure TfrmHelpMsg.btnDispNegClick(Sender: TObject);
var
  i:integer;
  AFiltList: TcxFilterCriteriaItemList;
begin

  with frmMain.cxGrid1TableView1 do
  with DataController.filter do begin
    DataController.ClearSelection;
    active:= true;
    beginUpdate;
    ClearFilter; //root.clear;
    AFiltList := Root.AddItemList(fboOr);
    for i:= 0 to NegClosedTrNums.count-1 do begin
      //sm(NegClosedTrNums[i]);
      AFiltList.AddItem(items[1],foEqual,strToInt(NegClosedTrNums[i]),NegClosedTrNums[i]);
    end;
    endUpdate;
  end;
  close;
  dispProfit(true,0,0,0,0);
  MainFilterStream.Clear;
end;

procedure TfrmHelpMsg.FormShow(Sender: TObject);
begin
  frmmain.cxGrid1.layoutchanged;
  btnDispNeg.top:= lblMsg.height + 20;
  btnCancel.top:= btnDispNeg.top + btnDispNeg.Height + 10;
  btngethelp.top:= btnCancel.top;
  height:= btnCancel.Top + btnCancel.Height + 50;
  btnDispNeg.setfocus;
end;

procedure ShowHelpMsg(capTxt,msgStr:string);
begin

  dispHlpMsg:= true;

  frmHelpMsg:=TfrmHelpMsg.Create(frmMain);

  with frmHelpMsg do begin

    if capTxt='1' then
      capTxt:= 'NEGATIVE SHARES ERROR'
    else begin
      btnDispNeg.visible:= false;
      btnGetHelp.visible:= false;
      btnCancel.caption:='OK';
      btnCancel.left:= 72;
    end;
    caption:= capTxt;

    lblMsg.lines.clear;
    while pos(cr,msgStr)>0 do begin
      if copy(msgStr,1,pos(cr,msgStr)-1)='' then
        lblMsg.lines.add('')
      else
        lblMsg.lines.add(copy(msgStr,1,pos(cr,msgStr)-1));
      delete(msgStr,1,pos(cr,msgStr));
    end;

    lblMsg.height:= lblMsg.lines.count * 15;
    if lblMsg.height > frmMain.height-135 then begin
      lblMsg.height:= frmMain.height-135;
      lblMsg.scrollbars:=ssVertical;
    end;
    height:= lblMsg.height+115;

    showModal;
  end;
end;

end.
