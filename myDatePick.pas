unit myDatePick;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, cxControls, cxContainer, cxEdit, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters,
  Vcl.ComCtrls, dxCore, cxDateUtils;

type
  TfrmDatePick = class(TForm)
    Label1: TLabel;
    btnOK: TButton;
    btnCancel: TButton;
    cxDate: TcxDateEdit;
    procedure btnCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cxDatePropertiesChange(Sender: TObject);
  private
    //
  public
    datePicked:TDate;
    procedure display(aCaption,aPrompt:string;aDefault:Tdate);
  end;

var
  frmDatePick: TfrmDatePick;

implementation

{$R *.DFM}

uses
  funcProc, TLCommonLib, TLSettings;

Var
  btnOKTop,btnCancelTop,cxDateTop: integer;

procedure TfrmDatePick.btnCancelClick(Sender: TObject);
begin
  modalResult:= mrCancel;
  datePicked:= 0;
  close;
  repaintGrid;
end;

procedure TfrmDatePick.FormActivate(Sender: TObject);
begin
  Position := poMainFormCenter;
  if Label1.height>13 then begin
    cxDate.top:= cxDateTop + Label1.height-13;
    btnOk.top:= btnOkTop + Label1.height-13;
    btnCancel.top:= btnCancelTop + Label1.height-13;
  end;
  cxdate.SetFocus;
end;

procedure TfrmDatePick.display(aCaption,aPrompt:string; aDefault:Tdate);
begin
  with frmDatePick do begin
    caption:= aCaption;
    Label1.caption:= aPrompt;
    cxdate.date:= aDefault;
    showModal;
  end;
end;

procedure TfrmDatePick.btnOKClick(Sender: TObject);
begin
  modalResult:= mrOK;
  try
    datePicked := StrToDate(cxdate.Text);
  except
    datePicked := cxdate.Date;
  end;
  close;
  repaintGrid;
end;

procedure TfrmDatePick.cxDatePropertiesChange(Sender: TObject);
begin
  {2014-02-13 no longer required
  if cxDate.Date > xstrToDate('01/31/'+nextTaxYear,Settings.InternalFmt) then begin
    mDlg('Cannot expire options in this file past 01/31/'+nextTaxYear,
      mtWarning, [mbOK], 0);
    cxDate.Date := xstrToDate('01/31/'+nextTaxYear,Settings.InternalFmt);
  end;     }
end;

procedure TfrmDatePick.FormCreate(Sender: TObject);
begin
  cxDateTop:=  cxDate.top;
  btnOkTop:= btnOk.top;
  btnCancelTop:= btnCancel.top;
end;

end.
