unit uDM;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, REST.Types,
  REST.Client, REST.Response.Adapter, Data.Bind.Components,
  Data.Bind.ObjectScope, FireDAC.Comp.ScriptCommands, FireDAC.Stan.Util,
  FireDAC.Comp.Script, VCL.ComCtrls, ScBridge, ScSSHClient, ScSFTPClient;


type
  TDM = class(TDataModule)
    DriverLink: TFDPhysSQLiteDriverLink;
    fDB: TFDConnection;
    ds: TDataSource;
    qry: TFDQuery;
    qUpdateTables: TFDQuery;
    RESTRequest1: TRESTRequest;
    RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter;
    RESTClient1: TRESTClient;
    RESTResponse1: TRESTResponse;
    DataSource2: TDataSource;
    MemTable: TFDMemTable;
    qSetUpConfig: TFDQuery;
    FDScript1: TFDScript;
    FDSQLiteBackup: TFDSQLiteBackup;
    qBBIO: TFDQuery;
    dsBBIO: TDataSource;
    qcnt: TFDQuery;
    SFTPClient: TScSFTPClient;
    SSHClient: TScSSHClient;
    FileStorage: TScFileStorage;
    procedure SSHClientServerKeyValidate(Sender: TObject; NewServerKey: TScKey;
      var Accept: Boolean);

type
  TRow = TArray<string>;
  TRows = TList<TRow>;

  private
    FRows: TRows;
  public
    property Rows: TRows read FRows write FRows;
    function GetTableValues(const TableName: string; const Where: string = ''): TRows;

    procedure CreateConfigBBIO;

    procedure InsertIntoConfigBBIO;
    procedure InsertIntoConfigETFS;
    procedure InsertIntoConfigFutures;
    procedure InsertIntoConfigMUTS;
    procedure InsertIntoConfigStrategies;

    procedure ReadIntoConfigBBIO;
    procedure ReadIntoConfigETFS;
    procedure ReadIntoConfigFutures;
    procedure ReadIntoConfigMUTS;
    procedure ReadIntoConfigStrategies;

    procedure BackUpDb(backup : string);
  end;

  const url = 'https://bctest.brokerconnect.live/api/v3/configs/';

var
  DM: TDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDM.CreateConfigBBIO;
begin
  DM.qcnt.SQL.Clear;
  DM.qcnt.SQL.Text :=
    'DROP TABLE IF EXISTS config_bbio;';
  DM.qcnt.ExecSQL;
end;

function TDM.GetTableValues(const TableName: string; const Where: string = ''): TRows;
var
  q: TFDquery;
  Row: TRow;
  i: Integer;
begin
  Result := TRows.Create;
  q := TFDquery.Create(nil);
  try
    q.Connection := fDB;
    q.SqL.Text := 'SELECT * FROM ' + TableName + ' ' + Where;
    q.Open;

    while not q.Eof do
    begin
      SetLength(Row, q.FieldCount);
      for i := 0 to q.FieldCount - 1 do
        Row[i] := q.Fields[i].AsString;
      Result.Add(Row);
      q.Next;
    end;
  finally
    q.Free;
  end;
end;

procedure TDM.BackUpDb(backup: string);
begin
  DM.fDB.Connected := True;
  DM.FDSQLiteBackup.DriverLink := DriverLink;
  DM.FDSQLiteBackup.DatabaseObj := fDB.CliObj;
  DM.FDSQLiteBackup.DestDatabase := backup;
  DM.FDSQLiteBackup.Backup;
end;

procedure TDM.InsertIntoConfigBBIO;
var
  Q: TFDQuery;
begin
  RestClient1.BaseURL := url + 'bbio';
  RESTRequest1.Execute;


  Q := TFDQuery.Create(nil);
  try
    Q.Connection := fDB;
    MemTable.First;
    while not MemTable.Eof do
    begin
      Q.SQL.Text :=
        'INSERT INTO _cBroadBaseds (ConfigList, Ticker, Multiplier, Description) ' +
        'VALUES (:ConfigList, :Ticker, :Multiplier, :Description)';
      Q.Params.ParamByName('ConfigList').AsString := MemTable.FieldByName('ConfigList').AsString;
      Q.Params.ParamByName('Ticker').AsString := MemTable.FieldByName('Ticker').AsString;
      Q.Params.ParamByName('Multiplier').AsInteger := MemTable.FieldByName('Multiplier').AsInteger;
      Q.Params.ParamByName('Description').AsString := MemTable.FieldByName('Description').AsString;
      Q.ExecSQL;
      MemTable.Next;
    end;
  finally
    Q.Free;
  end;
end;

procedure TDM.ReadIntoConfigBBIO;
var
  Item: TListItem;
begin
(*
  FDConnection1.Connected := True;

  qry.SQL.Text := 'SELECT id, name, value FROM config_bbio';
  qry.Open;

  ListView1.Items.BeginUpdate;
  try
    ListView1.Items.Clear;

    while not FDQuery1.Eof do
    begin
      Item := ListView1.Items.Add;
      Item.Caption := qry.FieldByName('id').AsString;   // main caption
      Item.SubItems.Add(qry.FieldByName('name').AsString);  // first subitem
      Item.SubItems.Add(qry.FieldByName('value').AsString); // second subitem

      qry.Next;
    end;
  finally
    ListView1.Items.EndUpdate;
  end;
*)
end;


procedure TDM.InsertIntoConfigETFS;
var
  Q: TFDQuery;
begin
  RestClient1.BaseURL := url + 'etfs';
  RESTRequest1.Execute;

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := fDB;
    MemTable.First;
    while not MemTable.Eof do
    begin
      Q.SQL.Text :=
        'INSERT INTO _cEtfs (Legacy, Ticker, Type, Description, AssetClass) ' +
        'VALUES (:Legacy, :Ticker, :Type, :Description, :AssetClass)';
      Q.Params.ParamByName('Legacy').AsString := MemTable.FieldByName('Legacy').AsString;
      Q.Params.ParamByName('Ticker').AsString := MemTable.FieldByName('Ticker').AsString;
      Q.Params.ParamByName('Type').AsString := MemTable.FieldByName('Type').AsString;
      Q.Params.ParamByName('Description').AsString := MemTable.FieldByName('Description').AsString;
      Q.Params.ParamByName('AssetClass').AsString := MemTable.FieldByName('AssetClass').AsString;
      Q.ExecSQL;
      MemTable.Next;
    end;
  finally
    Q.Free;
  end;
end;

procedure TDM.ReadIntoConfigETFS;
begin
//
end;

procedure TDM.InsertIntoConfigFutures;
var
  Q: TFDQuery;
begin
  RestClient1.BaseURL := url + 'futures';
  RESTRequest1.Execute;

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := fDB;
    MemTable.First;
    while not MemTable.Eof do
    begin
      Q.SQL.Text :=
        'INSERT INTO _cFutures (ConfigList, Symbol, Multiplier, Description) ' +
        'VALUES (:ConfigList, :Symbol, :Multiplier, :Description)';
      Q.Params.ParamByName('ConfigList').AsString := MemTable.FieldByName('ConfigList').AsString;
      Q.Params.ParamByName('Symbol').AsString := MemTable.FieldByName('Symbol').AsString;
      Q.Params.ParamByName('Multiplier').AsInteger := MemTable.FieldByName('Multiplier').AsInteger;
      Q.Params.ParamByName('Description').AsString := MemTable.FieldByName('Description').AsString;
      Q.ExecSQL;
      MemTable.Next;
    end;
  finally
    Q.Free;
  end;
end;

procedure TDM.ReadIntoConfigFutures;
begin
//
end;

procedure TDM.InsertIntoConfigMUTS;
var
  Q: TFDQuery;
  i, BatchSize: Integer;
begin
  RestClient1.BaseURL := url + 'muts';
  RESTRequest1.Execute;

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := fDB;
    Q.SQL.Text :=
      'INSERT INTO _cMuts (Ticker, Description) VALUES (:Ticker, :Description)';
    Q.Params.ArraySize := 100; // Set batch size

    i := 0;
    MemTable.First;
    while not MemTable.Eof do
    begin
      Q.Params[0].AsStrings[i] := MemTable.FieldByName('Ticker').AsString;
      Q.Params[1].AsStrings[i] := MemTable.FieldByName('Description').AsString;

      Inc(i);
      MemTable.Next;

      if (i = Q.Params.ArraySize) or MemTable.Eof then
      begin
        Q.Execute(Q.Params.ArraySize);
        i := 0;
      end;
    end;
  finally
    Q.Free;
  end;
end;

procedure TDM.ReadIntoConfigMUTS;
begin
//
end;


procedure TDM.InsertIntoConfigStrategies;
var
  Q: TFDQuery;
begin
  RestClient1.BaseURL := url + 'strategies';
  RESTRequest1.Execute;

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := fDB;
    MemTable.First;
    while not MemTable.Eof do
    begin
      Q.SQL.Text := 'INSERT INTO _cStrategies (List) VALUES (:List)';
      Q.Params.ParamByName('List').AsString := MemTable.FieldByName('List').AsString;
      Q.ExecSQL;
      MemTable.Next;
    end;
  finally
    Q.Free;
  end;
end;

procedure TDM.ReadIntoConfigStrategies;
begin
//
end;

procedure TDM.SSHClientServerKeyValidate(Sender: TObject; NewServerKey: TScKey;
  var Accept: Boolean);
begin
  Accept := true;
end;

end.
