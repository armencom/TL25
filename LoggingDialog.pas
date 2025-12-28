unit LoggingDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, Vcl.StdCtrls, cxButtons, RzPanel, RzRadGrp,
  Vcl.ExtCtrls, BaseDialog, Generics.Collections, RzLabel;

type
  TLoggingDlg = class(TBaseDlg)
    pnlMain: TPanel;
    ckLoggers: TRzCheckGroup;
    pnlButtons: TPanel;
    btnOK: TcxButton;
    btnCancel: TcxButton;
    pnlMessage: TPanel;
    RzLabel1: TRzLabel;
  private
    { Private declarations }
    function GetVirtualWidth(S : String) : Integer;
  protected
    procedure SetupForm; override;
    procedure SaveData; override;
  public
    { Public declarations }
  end;

implementation

uses
  TLLogging;

{$R *.dfm}

{ TLoggingDlg }

function TLoggingDlg.GetVirtualWidth(S : String) : integer;
var
  ACanvas : TControlCanvas;
begin
  ACanvas := TControlCanvas.Create;
  try
    TControlCanvas(ACanvas).Control := self;
    ACanvas.Font.Assign(Font);
    result:=ACanvas.TextWidth(S);
  finally
    ACanvas.Free;
  end;
end;

procedure TLoggingDlg.SaveData;
var
  I: Integer;
begin
  //Write to Settings and Activate Deactive Loggers
  for I := 0 to ckLoggers.Items.Count - 1 do
    TLLoggers.LoggerEnabled[ckLoggers.Items[I]] := ckLoggers.ItemChecked[I];
end;

procedure TLoggingDlg.SetupForm;
var
  I: Integer;
  Category : String;
  Categories : TArray<String>;
  ItemWidth : Integer;
begin
  //Read all the loggers registered and add a check box to the checkbox list for each one.
  Categories := TLLoggers.LogCategories;
  TArray.Sort<String>(Categories);
  ItemWidth := 0;
  for I := Low(Categories) to High(Categories) do
  begin
    Category := Categories[I];
    if ItemWidth < GetVirtualWidth(Category) then
      ItemWidth := GetVirtualWidth(Category);
    ckLoggers.Items.Add(Category);
    ckLoggers.ItemChecked[I] := TLLoggers.LoggerEnabled[Category];
  end;

  Height := 100 + pnlButtons.Height + pnlMessage.Height + Trunc(((ckLoggers.ItemHeight + 3)  * I) / ckLoggers.Columns);
  Width := 150 + (ItemWidth * 2)
end;

end.
