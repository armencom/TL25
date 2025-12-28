unit BrokerSelectDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseDialog, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, Menus, cxControls,
  cxContainer, cxEdit, cxListBox, StdCtrls, cxButtons, cxRadioGroup, ExtCtrls, RzLstBox, RzButton,
  RzRadChk;

type
  TdlgBrokerSelect = class(TBaseDlg)
    pnlMain: TPanel;
    rbExistingAccount: TRzRadioButton;
    rbNewAccount: TRzRadioButton;
    pnlButtons: TPanel;
    btnCancel: TRzButton;
    btnOK: TRzButton;
    lstBrokers: TRzListBox;
    procedure btnOKClick(Sender: TObject);
    procedure rbNewAccountClick(Sender: TObject);
    procedure rbExistingAccountClick(Sender: TObject);
  private
    { Private declarations }

  protected
    procedure SaveData; override;
    procedure SetupForm; override;
  public
    { Public declarations }
    class function Execute(var BrokerID : Integer; FormCaption : String = ''): TModalResult; overload;
  end;

implementation

{$R *.dfm}

uses TLFile, FuncProc;

var
  FBrokerID : Integer;

          // --------------------------
          //      TdlgBrokerSelect
          // Used by the Transfer Open
          // Positions function.
          // --------------------------

procedure TdlgBrokerSelect.btnOKClick(Sender: TObject);
begin
  if (rbExistingAccount.Checked) and
     (lstBrokers.ItemIndex = -1)  then
  begin
    mDlg('You must first select an Account from the list or click "Create New Account" to continue',
        mtError, [mbOK], 0);
    modalResult := mrNone;
  end;
end;

class function TdlgBrokerSelect.Execute(var BrokerID : Integer; FormCaption : String = ''): TModalResult;
begin
  FBrokerID := BrokerID;
  Result := inherited Execute(FormCaption);
  if Result = mrOK then
    BrokerID := FBrokerID;
end;

procedure TdlgBrokerSelect.rbExistingAccountClick(Sender: TObject);
begin
  lstBrokers.Enabled := rbExistingAccount.Checked;
end;

procedure TdlgBrokerSelect.rbNewAccountClick(Sender: TObject);
begin
  lstBrokers.Enabled := not rbNewAccount.Checked;
  if not lstBrokers.Enabled then
    lstBrokers.ItemIndex := -1;
end;

procedure TdlgBrokerSelect.SaveData;
var
  Header : TTLFileHeader;
begin
  FBrokerID := -1;
  if rbNewAccount.Checked then
    FBrokerID := 0
  else
    for Header in TradeLogFile.FileHeaders do
      if Header.AccountName = lstBrokers.Items[lstBrokers.ItemIndex] then
        FBrokerID := Header.BrokerID;
end;

procedure TdlgBrokerSelect.SetupForm;
var
  Header : TTLFileHeader;
begin
  rbExistingAccount.Enabled := TradeLogFile.FileHeaders.Count > 1;
  lstBrokers.Enabled := rbExistingAccount.Enabled;

  if not rbExistingAccount.Enabled then
    rbNewAccount.Checked := True
  else
  begin
    for Header in TradeLogFile.FileHeaders do
      if Header.BrokerID <> TradeLogFile.CurrentBrokerID then
        lstBrokers.Items.Add(Header.AccountName);
    rbExistingAccount.Checked := True;
  end;
end;

end.
