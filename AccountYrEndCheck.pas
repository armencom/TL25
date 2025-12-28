unit AccountYrEndCheck;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, Menus, StdCtrls,
  cxButtons, RzButton, RzRadChk, RzLabel, BaseDialog, Vcl.ImgList, dxSkinsCore, dxSkinHighContrast,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver;

type
  TExitOperation = (eoCancel, eoExpireOptions, eoExerciseOptions, eoOpenPositions, eoReconcile1099);

  TdlgAccountYrEndCheck = class(TBaseDlg)
    ckYearEndOpens: TRzCheckBox;
    lbAccountCheck: TStaticText;
    ckExpiredOptions: TRzCheckBox;
    ckExercisedOptions: TRzCheckBox;
    ck1099Recon: TRzCheckBox;
    btnCancel: TcxButton;
    btnOK: TcxButton;
    btnExpireOptions: TcxButton;
    btnExerciseAssign: TcxButton;
    btnOpenPos: TcxButton;
    btn1099Recon: TcxButton;
    lbInstructions: TRzLabel;
    btnExpireOptionsHelp: TcxButton;
    btnExerciseAssignHelp: TcxButton;
    btnOpenPositionsHelp: TcxButton;
    btnReconcileHelp: TcxButton;
    ImageList1: TImageList;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ckExpiredOptionsClick(Sender: TObject);
    procedure ckExercisedOptionsClick(Sender: TObject);
    procedure ckYearEndOpensClick(Sender: TObject);
    procedure ck1099ReconClick(Sender: TObject);
    procedure btn1099ReconClick(Sender: TObject);
    procedure btnOpenPosClick(Sender: TObject);
    procedure btnExerciseAssignClick(Sender: TObject);
    procedure btnExpireOptionsClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnExerciseAssignHelpClick(Sender: TObject);
    procedure btnExpireOptionsHelpClick(Sender: TObject);
    procedure btnOpenPositionsHelpClick(Sender: TObject);
    procedure btnReconcileHelpClick(Sender: TObject);
  private
    FLoading : Boolean;
  protected
    procedure SaveData; override;
    procedure SetupForm; override;
  public
    class function Execute: TExitOperation;
  end;

implementation

uses TLFile, FuncProc, TLSettings;

var
  ExitOperation : TExitOperation;

{$R *.dfm}

procedure TdlgAccountYrEndCheck.btn1099ReconClick(Sender: TObject);
begin
  ExitOperation := eoReconcile1099;
  ModalResult := mrOK;
end;

procedure TdlgAccountYrEndCheck.btnExerciseAssignClick(Sender: TObject);
begin
  ExitOperation := eoExerciseOptions;
  ModalResult := mrOK;
end;

procedure TdlgAccountYrEndCheck.btnExerciseAssignHelpClick(Sender: TObject);
begin
  webURL(supportSiteURL + 'hc/en-us/articles/115004501894'); // 2019-01-18 MB
end;

procedure TdlgAccountYrEndCheck.btnExpireOptionsClick(Sender: TObject);
begin
  ExitOperation := eoExpireOptions;
  ModalResult := mrOK;
end;

procedure TdlgAccountYrEndCheck.btnExpireOptionsHelpClick(Sender: TObject);
begin
  webURL(supportSiteURL + 'hc/en-us/articles/115004506994');
end;

procedure TdlgAccountYrEndCheck.btnOKClick(Sender: TObject);
begin
  ExitOperation := eoCancel;
end;

procedure TdlgAccountYrEndCheck.btnOpenPosClick(Sender: TObject);
begin
  ExitOperation := eoOpenPositions;
  ModalResult := mrOK;
end;

procedure TdlgAccountYrEndCheck.btnOpenPositionsHelpClick(Sender: TObject);
begin
  webURL(supportSiteURL + 'hc/en-us/articles/115004332453');
end;

procedure TdlgAccountYrEndCheck.btnReconcileHelpClick(Sender: TObject);
begin
  webURL(supportSiteURL + 'hc/en-us/articles/115004333333');
end;

procedure TdlgAccountYrEndCheck.ck1099ReconClick(Sender: TObject);
begin
  if not FLoading then
    if (TradeLogFile.TaxYear > 2010) and (ck1099Recon.Checked) and
       ((TradeLogFile.CurrentAccount.GrossSales1099 = '') or
        (not TradeLogFile.CurrentAccount.MTM and
        (TradeLogFile.CurrentAccount.CostBasis1099ST = ''))) then
    begin
       mDlg('Sorry 1099 reconciliation data is still missing! You must run the' + CR //
        + '1099 Reconciliation report for this account and enter Gross Sales' + CR //
        + 'and for Cash Account Types Short Term Cost Basis before you can ' + CR //
        + 'check this box!', mtWarning, [mbOK], 0);
       ck1099Recon.Checked := False;
    end;
  btn1099Recon.Enabled := not ck1099Recon.Checked;
end;

procedure TdlgAccountYrEndCheck.ckExercisedOptionsClick(Sender: TObject);
begin
  btnExerciseAssign.Enabled := not ckExercisedOptions.Checked;
end;

procedure TdlgAccountYrEndCheck.ckExpiredOptionsClick(Sender: TObject);
begin
  if Not FLoading then
    if ckExpiredOptions.Checked and TradeLogFile.TradeNums.OpenOptionsExist then
    begin
      mDlg('Sorry open Options still exist! You must either exercise or expire' + CR //
        + 'all options for the current tax year before you can check this box', mtWarning, [mbOK], 0);
      ckExpiredOptions.Checked := False;
      btnExpireOptions.Enabled := True;
      exit;
    end;

  btnExpireOptions.Enabled := not ckExpiredOptions.Checked;
end;

procedure TdlgAccountYrEndCheck.ckYearEndOpensClick(Sender: TObject);
begin
  btnOpenPos.Enabled := not ckYearEndOpens.Checked;
end;

procedure TdlgAccountYrEndCheck.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TdlgAccountYrEndCheck.SaveData;
begin
  TradeLogFile.CurrentAccount.CheckListItem[clExpireOptions] := ckExpiredOptions.Checked;
  TradeLogFile.CurrentAccount.CheckListItem[clExerciseOptions] := ckExercisedOptions.Checked;
  TradeLogFile.CurrentAccount.CheckListItem[clOpenPositions] := ckYearEndOpens.Checked;
  TradeLogFile.CurrentAccount.CheckListItem[clReconcile1099] := ck1099Recon.Checked;
end;

procedure TdlgAccountYrEndCheck.SetupForm;
begin
  FLoading := True;
  lbAccountCheck.Caption := lbAccountCheck.Caption + ' ['  + TradeLogFile.CurrentAccount.AccountName + ']';
  ckExpiredOptions.Enabled := TradeLogFile.HasOptions;
  btnExpireOptionsHelp.Enabled := ckExpiredOptions.Enabled;
  ckExercisedOptions.Enabled := ckExpiredOptions.Enabled;
  btnExerciseAssignHelp.Enabled := ckExercisedOptions.Enabled;
  ck1099Recon.Enabled := not TradeLogFile.CurrentAccount.IRA;
  btnReconcileHelp.Enabled := ck1099Recon.Enabled;
  ckExpiredOptions.Checked := TradeLogFile.CurrentAccount.CheckListItem[clExpireOptions];
  ckExercisedOptions.Checked := TradeLogFile.CurrentAccount.CheckListItem[clExerciseOptions];
  ckYearEndOpens.Checked := TradeLogFile.CurrentAccount.CheckListItem[clOpenPositions];
  ck1099Recon.Checked := TradeLogFile.CurrentAccount.CheckListItem[clReconcile1099] or TradeLogFile.CurrentAccount.No1099;
  FLoading := False;
end;

class function TdlgAccountYrEndCheck.Execute : TExitOperation;
var
  Btn : TModalResult;
begin
    Btn := inherited Execute;
    if Btn = mrCancel then
      Result := eoCancel
    else
      Result := ExitOperation;
end;

end.
