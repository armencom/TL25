unit TypeMult;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmTypeMult = class(TForm)
    pnlMain: TPanel;
    Label1: TLabel;
    cboTypeMult: TComboBox;
    btnOK: TButton;
    btnCancel: TButton;
    Panel1: TPanel;
    note: TLabel;
    noteTxt: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    sTypMul : string;
  end;


implementation

{$R *.dfm}

uses
  main, FuncProc, TLCommonLib;


procedure TfrmTypeMult.btnOKClick(Sender: TObject);
var
  S : String;
begin
  sTypMul := cboTypeMult.Text; // read once, then keep safe here
  if (Pos('ETF', sTypMul) > 0) //
  or (Pos('CTN', sTypMul) > 0) //
  or (Pos('VTN', sTypMul) > 0) //
  or (Pos('FUT', sTypMul) > 0) //
  or (Pos('MUT', sTypMul) > 0)
  then begin
     mDlg('Broad-Based Index Options, Futures, Mutual Funds, and' + CR //
       + 'ETF/ETNs must be changed using the Trade Type settings' + CR //
       + '(found under the User Menu).', mtError, [mbOK], 0);
     cboTypeMult.ItemIndex := 0;
     exit;
  end
  else begin
    if (Pos('STK', sTypMul) = 1) //
    or (Pos('OPT', sTypMul) = 1) //
    or (Pos('SSF', sTypMul) = 1) //
    or (Pos('DCY', sTypMul) = 1) //
    or (Pos('DRP', sTypMul) = 1) //
    or (Pos('CUR', sTypMul) = 1)then begin
      if Pos('-', sTypMul) <> 4 then begin
        mDlg('Type Multiplier must be in the format Typ-#,' + CR //
          + 'where Typ is a valid 3-letter type,' + CR //
          + 'and # is the multiplier.' + CR //
          + CR //
          + 'There is no dash in your entry, or' + CR //
          + 'the dash is not in position 4 of your entry.', mtError, [mbOK], 0);
        exit;
      end
      else begin
        S := cboTypeMult.Text;
        delete(S, 1, pos('-', S));
        if not IsFloat(S) then begin
          mDlg('Multipier portion of Type-Multiplier must be a number.',
            mtError, [mbOK], 0);
          exit;
        end;
        if S = '0' then begin
          mDlg('Multiplier portion of Type-Multiplier,' + CR //
            + 'must be greater than zero.', mtError, [mbOK], 0);
          exit;
        end;
      end;
    end
    else begin
      mDlg('Type portion of Type-Multiplier must be' + CR //
        + 'one of the following:' + CR //
        + CR //
        + '  (STK, OPT, SSF, DCY, DRP, CUR)', mtError, [mbOK], 0);
      cboTypeMult.ItemIndex := 0;
      exit;
    end;
  end;
  modalResult:=mrOK;
end;


procedure TfrmTypeMult.FormShow(Sender: TObject);
var
  i:integer;
begin
  cboTypeMult.Items.Add('STK-1');
  cboTypeMult.Items.Add('OPT-10');
  cboTypeMult.Items.Add('OPT-100');
  cboTypeMult.Items.Add('SSF-100');
  cboTypeMult.Items.Add('DRP-1');
  cboTypeMult.Items.Add('DCY-1');
  cboTypeMult.Items.Add('CUR-1');
  cboTypeMult.ItemIndex:=0;
end;

procedure TfrmTypeMult.btnCancelClick(Sender: TObject);
begin
  close;
end;

end.
