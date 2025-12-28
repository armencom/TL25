unit selImpMethod;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, dxGDIPlusClasses, Vcl.ExtCtrls;

type
  TfrmSelImpMethod = class(TForm)
    btnCancel: TButton;
    Image2: TImage;
    Image3: TImage;
    Label2: TLabel;
    Label3: TLabel;
    Image1: TImage;
    Label1: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Label3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSelImpMethod: TfrmSelImpMethod;

implementation

{$R *.dfm}

Uses
  clipbrd, funcProc, import, TLFile, Main;

procedure TfrmSelImpMethod.btnCancelClick(Sender: TObject);
begin
  modalResult:= mrCancel;
end;


procedure TfrmSelImpMethod.FormActivate(Sender: TObject);
begin
  Position := poMainFormCenter;
  Image3.Enabled := true; // Excel always available!
  Label3.Enabled := true;
  if (TradeLogFile.CurrentAccount.FileImportFormat = 'Other') then begin
    Image1.Enabled := false; // BC disabled
    Label1.Enabled := false;
    Image2.Enabled := false; // from File disabled
    Label2.Enabled := false;
  end
  else begin
    Image2.Enabled := true; // from File enabled
    Label2.Enabled := true;
    if (TradeLogFile.CurrentAccount.FileImportFormat = 'IB') //
    then begin
      Image1.Enabled := true; // BC enabled
      Label1.Enabled := true;
    end //
    else if (TradeLogFile.CurrentAccount.ImportFilter.FastLinkable = true) //
    and (TradeLogFile.CurrentAccount.PlaidAcctId <> '') //
    then begin
      Image1.Enabled := true; // BC enabled
      Label1.Enabled := true;
    end
    else begin
      Image1.Enabled := false; // BC disabled
      Label1.Enabled := false;
    end; // if BC type or not
  end; // if Other or not
  setFocus;
end;


// ------------------------------------
// ImportMethod values
// This one method is defined in the read method defined by the value of
// ImportFunction above. The following values represent different
// combinations that should be shown to the user as follows:
// 0 = Do Not show Import Methods - broker has only one method.
// 1 = BrokerConnect only
// 2 = WebImport only
// 3 = DownloadFile only
// 10 = BrokerConnect and DownloadFile (no Web)
// 20 = BrokerConnect, WebImport and DownloadFile (all 3).
// 30 = BrokerConnect and WebImport (no DownloadFile).
// 40 = WebImport and DownloadFile (no BC)
// 50 = Yodlee BrokerConnect and DownloadFile - 2020-02-26 MB - New!
// Additionally "Select Each Time" Is always shown as the first item in the list. }
// ------------------------------------
//procedure TfrmSelImpMethod.FormShow(Sender: TObject);
//var
//  impMethod : integer;
//begin
//  ImpMethod := TradeLogFile.CurrentAccount.ImportFilter.ImportMethod;
//  if ImpMethod = 10 then
//    rbWeb.visible := false
//  else if ImpMethod = 30 then
//    rbCSV.visible := false
//  else if ImpMethod = 40 then
//    rbBC.visible := false
//  else if ImpMethod = 50 then
//    rbBC.visible := false;
//end;


procedure TfrmSelImpMethod.Image1Click(Sender: TObject);
begin
  sImpMethod := 'BC';
  modalResult:= mrOK;
end;

procedure TfrmSelImpMethod.Image2Click(Sender: TObject);
begin
  sImpMethod := 'File';
  modalResult:= mrOK;
end;

procedure TfrmSelImpMethod.Image3Click(Sender: TObject);
begin
  sImpMethod := 'Excel';
  modalResult:= mrOK;
end;


procedure TfrmSelImpMethod.Label1Click(Sender: TObject);
begin
  sImpMethod := 'BC';
  modalResult:= mrOK;
end;

procedure TfrmSelImpMethod.Label2Click(Sender: TObject);
begin
  sImpMethod := 'File';
  modalResult:= mrOK;
end;

procedure TfrmSelImpMethod.Label3Click(Sender: TObject);
begin
  sImpMethod := 'Excel';
  modalResult:= mrOK;
end;

end.
