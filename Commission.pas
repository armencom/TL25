unit Commission;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask;

type
  TfrmCommission = class(TForm)
    Label1: TLabel;
    btnCancel: TButton;
    btnOK: TButton;
    mskComm: TEdit;
    Label2: TLabel;
    mskSEC: TEdit;
    Label3: TLabel;
    rbPerShare: TRadioButton;
    rbTotAmt: TRadioButton;
    cbSold: TCheckBox;
    cbBought: TCheckBox;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCommission: TfrmCommission;

implementation
uses Main, FuncProc, TLSettings, TLCommonLib;
{$R *.DFM}


procedure TfrmCommission.btnOKClick(Sender: TObject);
begin
  with frmMain do
  begin
	  if mskComm.text <> '' then
      Settings.Commission := (CurrToFloatEx(mskComm.text, Settings.UserFmt))
    else
      Settings.Commission := 0;

    if mskSEC.text <> '' then
      Settings.SecFee := StrToFloat(mskSEC.text, Settings.UserFmt)
    else
      Settings.SecFee := 0;
    Settings.FeePerShare := frmCommission.rbPerShare.Checked;
    Settings.FeeSold :=frmCommission.cbSold.Checked;
    Settings.FeeBought := frmCommission.cbBought.Checked;
  end;
end;

procedure TfrmCommission.btnCancelClick(Sender: TObject);
begin
	frmCommission.hide;
end;

procedure TfrmCommission.FormActivate(Sender: TObject);
begin
//  Position := poMainFormCenter;
  mskComm.text:= floattostrf(Settings.Commission,ffFixed,8,2,Settings.UserFmt);
  mskSEC.text:= floattostrf(Settings.SECfee,ffFixed,8,8,Settings.UserFmt);
end;

procedure TfrmCommission.FormCreate(Sender: TObject);
begin
  if Settings.FeePerShare then
  begin
    rbPerShare.checked:= true;
    rbTotAmt.checked:= false;
  end else
  begin
    rbPerShare.checked:= false;
    rbTotAmt.checked:= true;
  end;

  cbSold.Checked := Settings.FeeSold;
  cbBought.Checked := Settings.FeeBought;
end;

end.
