unit frmNewStrategies;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, //
  Graphics, Controls, Forms, //
  Dialogs, StdCtrls, Main, ExtCtrls, FuncProc;

type
  TNewStrategies = class(TForm)
    lstStrategy: TListBox;
    btnAddToStrategyList: TButton;
    pnlMessage: TPanel;
    lblMsg1: TLabel;
    lblMsg2: TLabel;
    btnCancel: TButton;
    btnSelectAll: TButton;
    procedure btnAddToStrategyListClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnSelectAllClick(Sender: TObject);

  private
    { Private declarations }
    procedure LoadStrategyList;

  public
    StrategyList : TList;
    function newStrategiesCount: integer;
    { Public declarations }
  end;

  StrategyItem = packed record
    Name : string;
  end;
  PStrategyItem = ^StrategyItem;
var
  NewStrategies: TNewStrategies;

implementation

{$R *.dfm}

uses TLSettings, TLFile;

function TNewStrategies.newStrategiesCount: integer;
  var
  i, j, k : integer;
  isContain, isInStrategy : Boolean;
  item : PStrategyItem;
begin
  if TradeLogFile.Count > 0 then
  begin
    LoadStrategyList;
    lstStrategy.Items.Clear;
    isContain := false;
    with frmMain do begin
      for i:= 0 to TradeLogFile.Count - 1 do
      begin
        for j := 0 to StrategyList.Count - 1 do
        begin
          item := StrategyList[j];
          if (TradeLogFile[I].Strategy = item.Name) or
          (TradeLogFile[I].Strategy = EmptyStr) then
          begin
            isContain := true;
            break;
          end;
        end;
        if (not isContain) and (TradeLogFile[I].Strategy <> EmptyStr) then
        begin
          if lstStrategy.Count > 0 then
          begin
            isInStrategy := false;
            for k := 0 to lstStrategy.Count - 1 do
              if lstStrategy.Items[k] = TradeLogfile[I].Strategy then
                isInStrategy := true;

            if not isInStrategy then
              lstStrategy.Items.Add(TradeLogFile[I].Strategy);
          end
          else
            lstStrategy.Items.Add(TradeLogFile[I].Strategy);
        end
        else
          isContain := false;
      end;
    end;
  end;
  Result := lstStrategy.Count;
end;

procedure TNewStrategies.LoadStrategyList;
var
  text : string;
  myFile : TextFile;
  item : PStrategyItem;
begin
  StrategyList := TList.Create;
  //Load the values from the configuration file into StrategyList.
  AssignFile(myFile, Settings.StrategyOptionsFile);
  Reset(myFile);
  while not Eof(myFile) do
  begin
    ReadLn(myFile, text);
    new(item);
    FillChar(item^, SizeOf(item^), 0);
    item.Name := text;
    StrategyList.Add(item);
  end;
  CloseFile(myFile);
end;

procedure TNewStrategies.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TNewStrategies.btnSelectAllClick(Sender: TObject);
var
  i : integer;
begin
  for i := 0 to lstStrategy.Items.Count - 1  do
    lstStrategy.Selected[i]:= true;
end;

procedure TNewStrategies.btnAddToStrategyListClick(Sender: TObject);
var
  i : integer;
  item : PStrategyItem;
  myFile : TextFile;
begin
  if lstStrategy.SelCount > 0 then begin
    // Add new Strategies to the StrategyList.
    for i := 0 to lstStrategy.Count - 1 do
    begin
      if lstStrategy.Selected[i] then begin
        new(item);
        FillChar(item^, SizeOf(item^), 0);
        item.Name := lstStrategy.Items.Strings[i];
        StrategyList.Add(item);
      end;
    end;

    AssignFile(myFile, Settings.StrategyOptionsFile);
    Rewrite(myFile);
    // Write Strategies to the Config File.
    for i := 0 to StrategyList.Count - 1 do
    begin
      item := StrategyList[i];
      WriteLn(myFile, item.Name);
    end;
    // Close the file
    CloseFile(myFile);
    lstStrategy.DeleteSelected;
    if lstStrategy.Items.Count = 0 then self.Close;
  end
  else
    ShowMessage('Please select the strategies to add to the Strategy list.');
end;

procedure TNewStrategies.FormActivate(Sender: TObject);
begin
  Position := poMainFormCenter;
end;

procedure TNewStrategies.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  StrategyList.Free;
end;

end.
