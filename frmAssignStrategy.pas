unit frmAssignStrategy;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, //
  Controls, Forms, Dialogs, StdCtrls, Main, cxCustomData, //
  RecordClasses, FuncProc;

type
  TAssignStrategy = class(TForm)
    lstStrategy: TListBox;
    lblStrategyCount: TLabel;
    btnAssign: TButton;
    btnCancel: TButton;
    procedure LoadStrategies;
    procedure btnCancelClick(Sender: TObject);
    procedure btnAssignClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    function StrategyCount:Integer;
    { Public declarations }
  end;

var
  AssignStrategy: TAssignStrategy;
  allowEditing : Boolean;

implementation

uses TLSettings;

{$R *.dfm}

procedure TAssignStrategy.btnAssignClick(Sender: TObject);
var
  i,aRow,aRec:Integer;
  aRowInfo: TcxRowInfo;
begin
  if lstStrategy.ItemIndex = -1 then begin
    sm('Please select a strategy.');
    exit;
  end;

  SaveTradesBack('Assign Strategy');
  with frmMain.cxGrid1TableView1.DataController do
  begin
    beginUpdate;
    try
    for i:= 0 to GetSelectedCount-1  do
    begin
      aRow := GetSelectedRowIndex(i);
      aRowInfo := GetRowInfo(aRow);
      aRec:= aRowInfo.RecordIndex;
      if lstStrategy.Items.Strings[lstStrategy.ItemIndex] = 'None' then
        Values[aRec,19] := EmptyStr
      else
        Values[aRec,19] := lstStrategy.Items.Strings[lstStrategy.ItemIndex];
      allowEditing := true;
    end;
    finally
      EndUpdate;
    end;
  end;
  hide; close;
  saveGridData(false);
end;

procedure TAssignStrategy.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TAssignStrategy.LoadStrategies;
begin
  lstStrategy.Items.LoadFromFile(Settings.StrategyOptionsFile);
  if lstStrategy.Items.Names[0] <> 'None' then
    lstStrategy.Items.Insert(0,'None');
  lblStrategyCount.Caption:= 'Trade Strategies - Count = ' + intToStr(lstStrategy.Items.Count);
end;

function TAssignStrategy.StrategyCount: Integer;
begin
  lstStrategy.Items.Clear;
  LoadStrategies;
  result := lstStrategy.Items.Count;
end;

procedure TAssignStrategy.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    Position := poMainFormCenter;
end;

end.

