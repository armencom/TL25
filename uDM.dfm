object DM: TDM
  OldCreateOrder = False
  Height = 487
  Width = 858
  object DriverLink: TFDPhysSQLiteDriverLink
    Left = 15
    Top = 8
  end
  object fDB: TFDConnection
    Params.Strings = (
      'JournalMode=WAL'
      
        'Database=C:\Users\Ralph\Documents\TradeLog\TL25\2025 Ralph Jones' +
        '.tdf'
      'CacheSize=16384'
      'LockingMode=Normal'
      'Synchronous=Normal'
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 63
    Top = 5
  end
  object ds: TDataSource
    Left = 184
    Top = 8
  end
  object qry: TFDQuery
    ConnectionName = 
      'C:\Users\Ralph\Documents\Delphi\TradeLog\2017 Timothy J OKeeffe.' +
      'tdb'
    SQL.Strings = (
      
        'SELECT count(name) nameCount FROM sqlite_master WHERE type="tabl' +
        'e" AND name="tdfFlags"')
    Left = 111
    Top = 11
  end
  object qUpdateTables: TFDQuery
    ConnectionName = 
      'C:\Users\Ralph\Documents\Delphi\TradeLog\2017 Timothy J OKeeffe.' +
      'tdb'
    SQL.Strings = (
      
        'CREATE TABLE IF NOT EXISTS tdfFlags ("sName" TEXT PRIMARY KEY, "' +
        'sFlag" TEXT(1));'
      'CREATE TABLE IF NOT EXISTS WebGet ("sURL" TEXT, "sReply" TEXT);')
    Left = 111
    Top = 67
  end
  object RESTRequest1: TRESTRequest
    Client = RESTClient1
    Method = rmPOST
    Params = <
      item
        Name = 'UserToken'
        Options = [poDoNotEncode]
        Value = 'edfd91b6-71a6-11ed-b13e-f23c938e66e4'
      end
      item
        Kind = pkHTTPHEADER
        Name = 'api'
        Options = [poDoNotEncode]
        Value = '0vztgJ4I8Drao4r9cVLGWqqzsNOVaQyTBVb4uK3zXygw5FkJ64N5FqlRPJXfX7HM'
      end>
    Response = RESTResponse1
    SynchronizedEvents = False
    Left = 368
    Top = 16
  end
  object RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter
    Dataset = MemTable
    FieldDefs = <>
    Response = RESTResponse1
    Left = 368
    Top = 120
  end
  object RESTClient1: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'utf-8, *;q=0.8'
    BaseURL = 'https://bctest.brokerconnect.live/api/v3/configs/muts'
    Params = <>
    RaiseExceptionOn500 = False
    Left = 368
    Top = 64
  end
  object RESTResponse1: TRESTResponse
    ContentType = 'application/json'
    Left = 368
    Top = 176
  end
  object DataSource2: TDataSource
    DataSet = MemTable
    Left = 368
    Top = 232
  end
  object MemTable: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    Left = 368
    Top = 280
  end
  object qSetUpConfig: TFDQuery
    Connection = fDB
    SQL.Strings = (
      'DROP TABLE IF EXISTS config_bbio;'
      'DROP TABLE IF EXISTS config_etfs;'
      'DROP TABLE IF EXISTS config_futures;'
      'DROP TABLE IF EXISTS config_muts;'
      'DROP TABLE IF EXISTS config_strategies;'
      ''
      
        'CREATE TABLE IF NOT EXISTS config_bbio ('#10'  id INTEGER PRIMARY KE' +
        'Y AUTOINCREMENT,'#10'  ConfigList TEXT,'#10'  Ticker TEXT,'#10'  Multiplier ' +
        'INTEGER,'#10'  Description TEXT'#10');'
      
        'CREATE INDEX IF NOT EXISTS idx_config_bbio_ticker ON config_bbio' +
        '(Ticker);'
      ''
      
        'CREATE TABLE IF NOT EXISTS config_etfs ( ID INTEGER PRIMARY KEY ' +
        'AUTOINCREMENT, Legacy TEXT, Ticker TEXT, Type TEXT, Description ' +
        'TEXT, AssetClass  TEXT);'
      'CREATE INDEX IF NOT EXISTS etfsTicker ON config_etfs (Ticker);'
      ''
      
        'CREATE TABLE IF NOT EXISTS config_futures (id INTEGER PRIMARY KE' +
        'Y AUTOINCREMENT, ConfigList  TEXT, Symbol TEXT, Multiplier INTEG' +
        'ER, Description TEXT);'
      
        'CREATE INDEX IF NOT EXISTS futuresConfigList ON config_futures (' +
        ' ConfigList ASC );'
      ''
      
        'CREATE TABLE IF NOT EXISTS config_muts ( id INTEGER PRIMARY KEY ' +
        'AUTOINCREMENT, Ticker TEXT, Description TEXT);'
      
        'CREATE INDEX IF NOT EXISTS mutsTicker ON config_muts ( Ticker AS' +
        'C );'
      ''
      
        'CREATE TABLE IF NOT EXISTS config_strategies ( id INTEGER PRIMAR' +
        'Y KEY AUTOINCREMENT, List TEXT);'
      
        'CREATE INDEX IF NOT EXISTS strategiesList ON config_strategies (' +
        ' List ASC );'
      '')
    Left = 368
    Top = 336
  end
  object FDScript1: TFDScript
    SQLScripts = <>
    Connection = fDB
    Params = <>
    Macros = <>
    Left = 432
    Top = 336
  end
  object FDSQLiteBackup: TFDSQLiteBackup
    DriverLink = DriverLink
    Catalog = 'MAIN'
    DestCatalog = 'MAIN'
    Left = 104
    Top = 144
  end
  object qBBIO: TFDQuery
    Connection = fDB
    SQL.Strings = (
      'SELECT * FROM config_bbio;')
    Left = 607
    Top = 3
  end
  object dsBBIO: TDataSource
    Left = 636
    Top = 2
  end
  object qcnt: TFDQuery
    DetailFields = 'Ticker;Multiplier'
    Connection = fDB
    SQL.Strings = (
      ''
      'SELECT Count(*) AS cnt FROM config_bbio')
    Left = 103
    Top = 211
  end
  object SFTPClient: TScSFTPClient
    SSHClient = SSHClient
    Left = 792
    Top = 352
  end
  object SSHClient: TScSSHClient
    HostName = '45.56.119.22'
    User = 'tradelog-backup'
    Password = 'a8c22a2c2c3979d4502b9e7fe654510cbca27181'
    KeyStorage = FileStorage
    OnServerKeyValidate = SSHClientServerKeyValidate
    Left = 792
    Top = 432
  end
  object FileStorage: TScFileStorage
    Left = 792
    Top = 392
  end
end
