unit DataConvError;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, printers, Buttons, ToolWin, ComCtrls;

type
  TfrmDataConvErr = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    Label1: TLabel;
    spdPrint: TSpeedButton;
    Label2: TLabel;
    Label3: TLabel;
    procedure spdPrintClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TfrmDataConvErr.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=27 then close;
end;

procedure TfrmDataConvErr.spdPrintClick(Sender: TObject);
var
  PrintBuf: TextFile;
  j : integer;
begin
  AssignPrn(PrintBuf) ;
  Rewrite(PrintBuf) ;
  try
    for j := 0 to Memo1.Lines.Count-1 do
      WriteLn(PrintBuf, Memo1.Lines[j]) ;
  finally
    CloseFile(PrintBuf) ;
  end;
end;

end.
