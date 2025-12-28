unit HintModule;

interface

uses
  SysUtils, Classes,  Controls, Types;

const
  HideHintPauseMillis = 10000;
  CR = #13;
  LF = #10;
  CRLF = CR + LF;

resourcestring
  {Cash Account Type Hint}
  srbGrpAccountTypes0Hint = 'Regular Cash Basis (Taxable) - ' +
      'This is the standard account type for all cash basis accounting';
  {IRA Account Type Hint}
  srbGrpAccountTypes1Hint = 'IRA (Non Taxable) - ' +
      'This is the Individual Retirement Account type and is non taxable. ' +
      'Be aware that wash sales that flow from a cash basis account to ' +
      'an IRA account will be lost forever';
  {MTM Account Type Hint}
  srbGrpAccountTypes2Hint = 'MTM (Taxable) - ' +
      'This is the Mark To Market account type. ' +
      'All transactions are closed at the end of the year based on the ' +
      'current market price as of December 31st and a new opening position ' +
      'is created in the next year file as of January 1st at the closing price';
  {Accounts Tab Zero (All Accounts Tab) Hint}
  stabAccounts0Hint = 'Combined view of all accounts!' + CRLF +'No Editing can occur in this ' +
      'tab.' + CRLF +'Please select a specific ' + CRLF + 'account tab to edit records.';
  {Accounts Tab, an Active Account Message}
  stabAccountsHint = 'Account Name: %s!' + CRLF + 'Click to edit records for this account.';
  {Accounts Tab, the Plus Tab Message}
  stabAccountsPlusHint = 'Click (+) to add or import an Account';


type
  TmoduleHints = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
    procedure ShowHint(var HintStr: string; var CanShow: Boolean;
      var HintInfo: THintInfo);
  end;

var
  moduleHints: TmoduleHints;

implementation

{$R *.dfm}

uses RzRadGrp, RzTabs, Forms, Graphics;

procedure TmoduleHints.DataModuleCreate(Sender: TObject);
begin
  Application.HintHidePause := HideHintPauseMillis;
end;

procedure TmoduleHints.ShowHint(var HintStr: string; var CanShow: Boolean;
  var HintInfo: THintInfo);
var
  ControlHeight, Item : Integer;
  ControlRect : TRect;
  RadioGroup : TrzRadioGroup;
  TabAccounts : TrzTabControl;
begin
  if (HintInfo.HintControl <> nil) //
  and (Length(HintInfo.HintControl.Name) > 0) //
  then begin
    if (HintInfo.HintControl.Name =  'rbGrpAccountType') then begin
      RadioGroup := TrzRadioGroup(HintInfo.HintControl);
      ControlHeight := (RadioGroup.Height) div RadioGroup.Items.Count;
      Item := HintInfo.CursorPos.Y div ControlHeight;
      case Item of
        0 : HintStr := srbGrpAccountTypes0Hint;
        1 : HintStr := srbGrpAccountTypes1Hint;
        2 : HintStr := srbGrpAccountTypes2Hint
      end;
      ControlRect := RadioGroup.ClientRect;
      ControlRect.Top := ControlRect.Top + ControlHeight * Item;
      ControlRect.Bottom := ControlRect.Top + ControlHeight;
      HintInfo.CursorRect := ControlRect;
      CanShow := True;
    end
    else if (HintInfo.HintControl.Name = 'TabAccounts') then begin
      TabAccounts := TrzTabControl(HintInfo.HintControl);
      Item := tabAccounts.TabAtPos(HintInfo.CursorPos.X, HintInfo.CursorPos.Y);
      CanShow := True;
      if Item = 0 then
        HintStr := stabAccounts0Hint
      else if Item = TabAccounts.Tabs.Count - 1 then
        HintStr := stabAccountsPlusHint
      else if Item > 0 then
        HintStr := Format(stabAccountsHint, [TabAccounts.Tabs[Item].Caption])
      else
        CanShow := False;
    end
    else
      CanShow := True;
  end
  else
    CanShow := True;
end;

end.
