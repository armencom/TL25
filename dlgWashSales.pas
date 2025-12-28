unit dlgWashSales;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TdlgWSsettings = class(TForm)
    chkShortLong: TCheckBox;
    chkStkOpt: TCheckBox;
    chkOptStk: TCheckBox;
    chkSubstantially: TCheckBox;
    btnDefaults: TButton;
    btnCancel: TButton;
    btnApply: TButton;
    lblLegalWarning: TLabel;
    lblHelpLink: TLabel;
    procedure btnApplyClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnDefaultsClick(Sender: TObject);
    procedure lblHelpLinkClick(Sender: TObject);
    procedure lblHelpLinkMouseEnter(Sender: TObject);
    procedure lblHelpLinkMouseLeave(Sender: TObject);
    procedure chkSubstantiallyClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dlgWSsettings: TdlgWSsettings;

implementation

uses
  FuncProc;

{$R *.dfm}

procedure TdlgWSsettings.btnApplyClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TdlgWSsettings.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TdlgWSsettings.btnDefaultsClick(Sender: TObject);
begin
  chkShortLong.Checked := true;
  chkStkOpt.Checked := true;
  chkOptStk.Checked := true;
  chkSubstantially.Checked := true;
end;

procedure TdlgWSsettings.chkSubstantiallyClick(Sender: TObject);
begin
  if (chkSubstantially.Checked = false) then begin
    // When a user unchecks the 4th wash sale setting box,
    // it technically makes the 2nd and 3rd options irrelevant.
    chkStkOpt.Checked := false;
    chkOptStk.Checked := false;
    chkStkOpt.Enabled := false;
    chkOptStk.Enabled := false;
  end
  else begin
    chkStkOpt.Enabled := true;
    chkOptStk.Enabled := true;
  end;
end;

// ------------------------------------
//        Label1 (hyperlink)
// ------------------------------------
procedure TdlgWSsettings.lblHelpLinkClick(Sender: TObject);
begin // click
  webURL(supportSiteURL + 'hc/en-us/articles/4403367434135');
end;

procedure TdlgWSsettings.lblHelpLinkMouseEnter(Sender: TObject);
begin // mouseover
  lblHelpLink.Font.Style := [fsUnderline];
end;


procedure TdlgWSsettings.lblHelpLinkMouseLeave(Sender: TObject);
begin
  lblHelpLink.Font.Style := [];
end;

end.
