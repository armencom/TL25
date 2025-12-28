unit dlgInputVal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, //
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, //
  BaseDialog;

type
  TdlgInputValue = class(TBaseDlg)
    lblInstructions: TLabel;
    lblPrompt: TLabel;
    Edit1: TEdit;
    lblLink: TLabel;
    btnOK: TButton;
    btnCancel: TButton;
    procedure lblLinkClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
    constructor Create(AOwner: TComponent); overload;
  public
    { Public declarations }
    constructor Create; reintroduce; overload;
    class function Execute(
      sTitle : string;
      sInstructions : string;
      sPrompt : string;
      sLinkText : string;
      sLinkURL : string;
      var sValue : string
    ) : TModalResult; overload;
end;

var
  dlgInputValue: TdlgInputValue;
  sURL : string;

implementation

uses
  FuncProc;

{$R *.dfm}

procedure TdlgInputValue.lblLinkClick(Sender: TObject);
begin
  webURL(sURL);
end;


{By redeclaring this constructor as private we are effectively hiding it so that it cannot be called.
  It just needs to call the inherited constructor}
constructor TdlgInputValue.Create(AOwner: TComponent);
begin
  inherited;
end;

procedure TdlgInputValue.btnCancelClick(Sender: TObject);
begin
  modalResult := mrCancel;
end;

procedure TdlgInputValue.btnOKClick(Sender: TObject);
var
  s : string;
  n : double;
begin
  // Make sure the amount is a non-zero number
  s := edit1.Text;
  try
    n := StrToFloat(s);
  except
    n := 0;
  end;
  // Verify all Required fields have been filled in correctly.
  if n = 0 then begin
    mDlg('Please enter number of shares/contracts to split.', mtError, [mbOK], 0);
    modalResult := mrNone;
    exit;
  end;
  modalResult := mrOK;
end;

constructor TdlgInputValue.Create;
begin
  raise Exception.Create('Constructor is disabled for dialog boxes, Use the execute class method instead.')
end;


class function TdlgInputValue.Execute(
  sTitle : string;
  sInstructions : string;
  sPrompt : string;
  sLinkText : string;
  sLinkURL : string;
  var sValue : string
) : TModalResult;
begin
  With create(nil) do begin
    if Length(sTitle) > 0 then
      Caption := sTitle;
    lblInstructions.Caption := sInstructions;
    lblPrompt.Caption := sPrompt;
    edit1.Text := sValue;
    lblLink.Caption := sLinkText;
    sURL := sLinkURL;
    Result := showModal;
    if Result = mrOk then
      sValue := edit1.Text
    else
      sValue := '';
    close;
  end;
  Screen.Cursor := crDefault;
end;

procedure TdlgInputValue.FormActivate(Sender: TObject);
begin
  inherited;
  //
end;

procedure TdlgInputValue.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;


procedure TdlgInputValue.FormCreate(Sender: TObject);
begin
  inherited;
  //
end;


end.
