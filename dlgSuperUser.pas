unit dlgSuperUser;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TdlgSuper = class(TForm)
    pnlButtons: TPanel;
    btnChange: TButton;
    pnlFileName: TPanel;
    lblFileName: TLabel;
    edFileName: TEdit;
    pnlRegUser: TPanel;
    lblRegUser: TLabel;
    edRegUser: TEdit;
    pnlAcct: TPanel;
    lblAcct: TLabel;
    edAcct: TEdit;
    pnlPW: TPanel;
    lblPW: TLabel;
    edPW: TEdit;
    pnlSSNEIN: TPanel;
    lblSSNEIN: TLabel;
    edUserEmail: TEdit;
    btnCopy: TButton;
    pnlCanETY: TPanel;
    cbCanETY: TCheckBox;
    btnCancel: TButton;
    btnResetPW: TButton;
    btnResetTaxfile: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure btnChangeClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCancelClick(Sender: TObject);
    procedure btnResetPWClick(Sender: TObject);
    procedure btnResetTaxfileClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dlgSuper: TdlgSuper;

implementation

{$R *.dfm}

Uses
  TLFile, funcProc, TLCommonLib, clipBrd, Main;


procedure TdlgSuper.btnCancelClick(Sender: TObject);
begin
  Close;
end;


procedure TdlgSuper.btnChangeClick(Sender: TObject);
begin
  ProHeader.taxFile := edFileName.Text;
  ProHeader.regCode := edRegUser.Text;
  ProHeader.regCodeAcct := edAcct.Text;
  ProHeader.email := edUserEmail.Text;
  ProHeader.TDFpassword := edPW.Text;
  if cbCanETY.Checked then
     ProHeader.canETY := 1
  else
    ProHeader.canETY := 0;
  SaveTradeLogFile('', true);
  Close;
end;


procedure TdlgSuper.btnCopyClick(Sender: TObject);
var
  i : integer;
  sLine : string;
begin
  // note: lineList is a global in TLCommonLib - 2016-01-26 MB
  clipBoard.Clear; // 2023-06-22 MB added to prevent error
  clipBoard.AsText := '';
  sLine := '';
  if lineList.Count < 2 then begin
    showmessage('There is nothing to copy to the clipboard.');
    exit;
  end;
  // ProHeader line
  sLine := lineList[0];
  clipBoard.AsText := sLine;
  if pos('-99', sline) <> 1 then begin
    sm('This function only works on encrypted files.');
    exit;
  end;
  // skip ProHeader line
  sLine := lineList[1];
  if lineList.Count > 2 then begin
    for i := 2 to lineList.count - 1 do begin
      sLine := sLine + crlf + lineList[i];
    end;
  end;
  // remove extra carriage return at end
  if copy(sLine,length(sLine),1) = CR then
    delete (sLine, length(sLine), 1);
  // save file as plain text tdf
  clipBoard.AsText := sLine;
  showmessage('Plain text tdf file data has been copied to clipboard.');
end;


procedure TdlgSuper.btnResetPWClick(Sender: TObject);
begin
  showFileResetPW;
end;

procedure TdlgSuper.btnResetTaxfileClick(Sender: TObject);
begin
  frmMain.mnuFileResetUser;
end;

procedure TdlgSuper.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action := caFree
end;

procedure TdlgSuper.FormShow(Sender: TObject);
begin
  edFileName.Text := ProHeader.taxFile;
  edRegUser.Text := ProHeader.regCode;
  edAcct.Text := ProHeader.regCodeAcct;
  edUserEmail.Text := ProHeader.email;
  edPW.Text := ProHeader.TDFpassword;
  if ProHeader.canETY = 1 then
    cbCanETY.Checked := true
  else
    cbCanETY.Checked := false;
end;


end.
