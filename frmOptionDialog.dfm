object frmOptDialog: TfrmOptDialog
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'TradeLog Options'
  ClientHeight = 429
  ClientWidth = 648
  Color = clBtnFace
  DefaultMonitor = dmMainForm
  DragMode = dmAutomatic
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object btnCancel: TButton
    Left = 209
    Top = 397
    Width = 75
    Height = 25
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
    OnClick = btnCancelClick
  end
  object btnOK: TButton
    Left = 370
    Top = 397
    Width = 75
    Height = 25
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = btnOKClick
  end
  object tabPages: TPageControl
    Left = 7
    Top = 7
    Width = 633
    Height = 383
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    ActivePage = TabETNs
    TabOrder = 2
    object tabGlobal: TTabSheet
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Global'
      ImageIndex = 1
      object lblCtrlW: TLabel
        Left = 270
        Top = 167
        Width = 32
        Height = 13
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Ctrl+W'
      end
      object lblCtrlT: TLabel
        Left = 270
        Top = 145
        Width = 28
        Height = 13
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Ctrl+T'
      end
      object lblCtrlAltO: TLabel
        Left = 270
        Top = 101
        Width = 47
        Height = 13
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Ctrl+Alt+O'
      end
      object lblCtrlAltM: TLabel
        Left = 270
        Top = 58
        Width = 48
        Height = 13
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Ctrl+Alt+M'
      end
      object lblCtrlN: TLabel
        Left = 270
        Top = 80
        Width = 29
        Height = 13
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Ctrl+N'
      end
      object lblCtrlAltS: TLabel
        Left = 270
        Top = 123
        Width = 46
        Height = 13
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Ctrl+Alt+S'
      end
      object Label1: TLabel
        Left = 270
        Top = 35
        Width = 46
        Height = 13
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Ctrl+Alt+A'
        Visible = False
      end
      object Label2: TLabel
        Left = 13
        Top = 11
        Width = 125
        Height = 13
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Display /Hide columns'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold, fsUnderline]
        ParentFont = False
      end
      object lblCtrlQ: TLabel
        Left = 270
        Top = 303
        Width = 29
        Height = 13
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Ctrl+Q'
      end
      object Label3: TLabel
        Left = 270
        Top = 188
        Width = 46
        Height = 13
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Ctrl+Alt+C'
      end
      object Label4: TLabel
        Left = 270
        Top = 208
        Width = 47
        Height = 13
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Ctrl+Alt+H'
      end
      object chkMTaxLots: TCheckBox
        Left = 13
        Top = 57
        Width = 171
        Height = 18
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Display &Matched'
        TabOrder = 0
      end
      object chkNotes: TCheckBox
        Left = 13
        Top = 79
        Width = 170
        Height = 18
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Display &Notes'
        TabOrder = 1
      end
      object chkOptTicks: TCheckBox
        Left = 13
        Top = 101
        Width = 170
        Height = 16
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Display &Option Tickers'
        TabOrder = 2
      end
      object chkTime: TCheckBox
        Left = 13
        Top = 145
        Width = 170
        Height = 16
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Display &Time'
        TabOrder = 3
      end
      object chkWSdefer: TCheckBox
        Left = 12
        Top = 167
        Width = 170
        Height = 16
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Display &Wash Sale Deferrals'
        TabOrder = 4
      end
      object splitLineBottom: THeader
        Left = 12
        Top = 230
        Width = 250
        Height = 1
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        TabOrder = 5
      end
      object Header1: THeader
        Left = 13
        Top = 324
        Width = 250
        Height = 1
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        TabOrder = 6
      end
      object chkStrategies: TCheckBox
        Left = 13
        Top = 123
        Width = 170
        Height = 15
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Display &Strategies'
        TabOrder = 7
      end
      object chkAcct: TCheckBox
        Left = 13
        Top = 35
        Width = 250
        Height = 15
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Display Broker &Account (combined files only)'
        TabOrder = 8
        Visible = False
      end
      object chkQS: TCheckBox
        Left = 13
        Top = 300
        Width = 180
        Height = 16
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Display &Quick Start Panel'
        TabOrder = 9
      end
      object chk8949Code: TCheckBox
        Left = 12
        Top = 188
        Width = 170
        Height = 16
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Display 8949 &Code'
        TabOrder = 10
      end
      object ckWSHoldingDate: TCheckBox
        Left = 12
        Top = 208
        Width = 170
        Height = 16
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Display Wash Sale Holding Date'
        TabOrder = 11
      end
      object chkLegacyBC: TCheckBox
        Left = 13
        Top = 329
        Width = 286
        Height = 15
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Use Legacy BrokerConnect for Fidelity and E*Trade'
        TabOrder = 12
      end
    end
    object tabBroadBased: TTabSheet
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Broad-Based Index Options'
      object lblCurrentSymbol: TLabel
        Left = 13
        Top = 11
        Width = 102
        Height = 13
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Index Option Symbols'
      end
      object lblNewSymbol: TLabel
        Left = 326
        Top = 11
        Width = 59
        Height = 13
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'New Symbol'
      end
      object lblMultiplier: TLabel
        Left = 326
        Top = 57
        Width = 41
        Height = 13
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Multiplier'
      end
      object btnRemove: TButton
        Left = 326
        Top = 176
        Width = 85
        Height = 25
        Cursor = 214
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Remove >>'
        TabOrder = 4
        OnClick = btnRemoveClick
      end
      object btnAdd: TButton
        Left = 326
        Top = 119
        Width = 85
        Height = 25
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = '<< Add'
        TabOrder = 3
        OnClick = btnAddClick
      end
      object txtSymbol: TEdit
        Left = 326
        Top = 30
        Width = 112
        Height = 21
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        CharCase = ecUpperCase
        MaxLength = 12
        TabOrder = 1
      end
      object txtMultiplier: TEdit
        Left = 326
        Top = 76
        Width = 112
        Height = 21
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        CharCase = ecUpperCase
        MaxLength = 12
        TabOrder = 2
      end
      object lstBBIOs: TListView
        Left = 13
        Top = 28
        Width = 291
        Height = 245
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Columns = <
          item
            Caption = 'Symbol'
            MaxWidth = 200
            Width = 135
          end
          item
            Caption = 'Multiplier'
            MaxWidth = 200
            Width = 135
          end>
        ColumnClick = False
        GridLines = True
        MultiSelect = True
        ReadOnly = True
        RowSelect = True
        SortType = stBoth
        TabOrder = 0
        ViewStyle = vsReport
      end
      object btnRestoreBBIndexOptions: TButton
        Left = 100
        Top = 287
        Width = 100
        Height = 25
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Restore Defaults'
        TabOrder = 5
        OnClick = btnRestoreBBIndexOptionsClick
      end
    end
    object tabFutures: TTabSheet
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Futures'
      ImageIndex = 3
      object lblFuturesCount: TLabel
        Left = 13
        Top = 11
        Width = 72
        Height = 13
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Futures Symbol'
      end
      object lblFuSymbol: TLabel
        Left = 326
        Top = 11
        Width = 59
        Height = 13
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'New Symbol'
      end
      object lblFuMultiplier: TLabel
        Left = 326
        Top = 57
        Width = 41
        Height = 13
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Multiplier'
      end
      object btnRestoreFuturesSettings: TButton
        Left = 100
        Top = 287
        Width = 100
        Height = 25
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Restore Defaults'
        TabOrder = 5
        OnClick = btnRestoreFuturesSettingsClick
      end
      object lstFuture: TListView
        Left = 13
        Top = 30
        Width = 291
        Height = 245
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Columns = <
          item
            Caption = 'Symbol'
            MaxWidth = 200
            Width = 135
          end
          item
            Caption = 'Multiplier'
            MaxWidth = 200
            Width = 135
          end>
        ColumnClick = False
        GridLines = True
        MultiSelect = True
        ReadOnly = True
        RowSelect = True
        SortType = stBoth
        TabOrder = 0
        ViewStyle = vsReport
      end
      object btnFuRemove: TButton
        Left = 326
        Top = 176
        Width = 85
        Height = 25
        Cursor = 214
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Remove >>'
        TabOrder = 4
        OnClick = btnFuRemoveClick
      end
      object txtFuMultiplier: TEdit
        Left = 326
        Top = 76
        Width = 112
        Height = 21
        Hint = 
          'Multiplier is the dollar value of each whole point of the contra' +
          'ct price.'
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        CharCase = ecUpperCase
        MaxLength = 12
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
      end
      object txtFuSymbol: TEdit
        Left = 326
        Top = 30
        Width = 112
        Height = 21
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        CharCase = ecUpperCase
        MaxLength = 12
        TabOrder = 1
      end
      object btnFuAdd: TButton
        Left = 326
        Top = 119
        Width = 85
        Height = 25
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = '<< Add'
        TabOrder = 3
        OnClick = btnFuAddClick
      end
    end
    object tabStrategies: TTabSheet
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Strategy Setup'
      ImageIndex = 4
      object lblCurrentStrategy: TLabel
        Left = 13
        Top = 15
        Width = 78
        Height = 13
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Trade Strategies'
      end
      object lblNewStrategy: TLabel
        Left = 320
        Top = 15
        Width = 86
        Height = 13
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Add New Strategy'
      end
      object lstStrategy: TListBox
        Left = 13
        Top = 32
        Width = 291
        Height = 245
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        ItemHeight = 13
        MultiSelect = True
        Sorted = True
        TabOrder = 0
      end
      object btnRestoreStrategies: TButton
        Left = 100
        Top = 287
        Width = 100
        Height = 25
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Restore Defaults'
        TabOrder = 1
        OnClick = btnRestoreStrategiesClick
      end
      object btnRemoveStrategy: TButton
        Left = 320
        Top = 119
        Width = 85
        Height = 25
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Remove >>'
        TabOrder = 2
        OnClick = btnRemoveStrategyClick
      end
      object btnAddStrategy: TButton
        Left = 320
        Top = 73
        Width = 85
        Height = 25
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = '<< Add'
        TabOrder = 3
        OnClick = btnAddStrategyClick
      end
      object txtStrategy: TEdit
        Left = 320
        Top = 32
        Width = 291
        Height = 21
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        MaxLength = 40
        TabOrder = 4
      end
    end
    object tabMutFunds: TTabSheet
      Caption = 'Mutual Funds'
      ImageIndex = 4
      object lblNewFundSymbol: TLabel
        Left = 385
        Top = 15
        Width = 118
        Height = 13
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'New Mutual FundSymbol'
      end
      object lblFundCount: TLabel
        Left = 25
        Top = 15
        Width = 96
        Height = 13
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Mutual Fund Symbol'
      end
      object btnRestoreFunds: TButton
        Left = 105
        Top = 283
        Width = 100
        Height = 25
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Restore Defaults'
        TabOrder = 0
        OnClick = btnRestoreFundsClick
      end
      object btnRemoveFund: TButton
        Left = 385
        Top = 136
        Width = 85
        Height = 25
        Cursor = 214
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Remove >>'
        TabOrder = 1
        OnClick = btnRemoveFundClick
      end
      object btnAddFund: TButton
        Left = 385
        Top = 87
        Width = 85
        Height = 25
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = '<< Add'
        TabOrder = 2
        OnClick = btnAddFundClick
      end
      object txtNewFund: TEdit
        Left = 385
        Top = 38
        Width = 112
        Height = 21
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        CharCase = ecUpperCase
        MaxLength = 12
        TabOrder = 3
      end
      object lstFunds: TListBox
        Left = 25
        Top = 33
        Width = 245
        Height = 245
        ItemHeight = 13
        Sorted = True
        TabOrder = 4
      end
    end
    object TabETNs: TTabSheet
      Caption = 'ETF/ETN'
      ImageIndex = 5
      object lblETNNewSymbol: TLabel
        Left = 395
        Top = 9
        Width = 109
        Height = 13
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'New ETF/ETN Symbol'
      end
      object lblETNCount: TLabel
        Left = 18
        Top = 9
        Width = 84
        Height = 13
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'ETF/ETN Symbol'
      end
      object lblETNsubType: TLabel
        Left = 395
        Top = 55
        Width = 46
        Height = 13
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Sub-Type'
      end
      object Label5: TLabel
        Left = 18
        Top = 268
        Width = 345
        Height = 39
        Caption = 
          'Select a symbol to make updates, or type a new symbol to add. To' +
          ' edit a '#13'symbol: Select the symbol in the list, make needed chan' +
          'ges above, then '#13'click the Add/Update button to save the change.'
      end
      object lblDescrip: TLabel
        Left = 395
        Top = 213
        Width = 128
        Height = 13
        Caption = 'New ETF/ETN Description'
      end
      object btnETNRestore: TButton
        Left = 18
        Top = 318
        Width = 100
        Height = 25
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Restore Defaults'
        TabOrder = 0
        OnClick = btnETNRestoreClick
      end
      object btnETNremove: TButton
        Left = 395
        Top = 318
        Width = 100
        Height = 25
        Cursor = 214
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Remove >>'
        TabOrder = 1
        OnClick = btnETNremoveClick
      end
      object btnETNAdd: TButton
        Left = 395
        Top = 283
        Width = 100
        Height = 24
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = '<< Add/Update'
        TabOrder = 2
        OnClick = btnETNAddClick
      end
      object txtETNNew: TEdit
        Left = 395
        Top = 26
        Width = 159
        Height = 21
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        CharCase = ecUpperCase
        MaxLength = 12
        TabOrder = 3
      end
      object lstETNs: TListView
        Left = 18
        Top = 26
        Width = 359
        Height = 239
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Columns = <
          item
            Caption = 'Symbol'
            MaxWidth = 100
            Width = 55
          end
          item
            Caption = 'SubType'
            MaxWidth = 100
            Width = 55
          end
          item
            Caption = 'Description'
            Width = 240
          end>
        ColumnClick = False
        GridLines = True
        MultiSelect = True
        ReadOnly = True
        RowSelect = True
        SortType = stBoth
        TabOrder = 4
        ViewStyle = vsReport
        OnSelectItem = lstETNsSelectItem
      end
      object pnlETNsubType: TPanel
        Left = 395
        Top = 73
        Width = 214
        Height = 126
        BorderStyle = bsSingle
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 5
        object Label6: TLabel
          Left = 27
          Top = 24
          Width = 125
          Height = 13
          Caption = '(Debt Security ETF/ETNs)'
        end
        object Label7: TLabel
          Left = 27
          Top = 64
          Width = 156
          Height = 13
          Caption = '(Prepaid Forward Contract ETNs)'
        end
        object Label8: TLabel
          Left = 27
          Top = 103
          Width = 78
          Height = 13
          Caption = '(Currency ETNs)'
        end
        object rbETN: TRadioButton
          Left = 11
          Top = 8
          Width = 153
          Height = 17
          Caption = 'ETF/ETN'
          Checked = True
          TabOrder = 0
          TabStop = True
          OnClick = rbETNClick
        end
        object rbVTN: TRadioButton
          Left = 11
          Top = 48
          Width = 153
          Height = 17
          Caption = 'VTN'
          TabOrder = 1
          OnClick = rbVTNClick
        end
        object rbCTN: TRadioButton
          Left = 11
          Top = 88
          Width = 153
          Height = 17
          Caption = 'CTN'
          TabOrder = 2
          OnClick = rbCTNClick
        end
      end
      object btnETNclear: TButton
        Left = 559
        Top = 25
        Width = 50
        Height = 23
        Caption = 'Clear'
        TabOrder = 6
        OnClick = btnETNclearClick
      end
      object txtETFdescrip: TMemo
        Left = 395
        Top = 229
        Width = 214
        Height = 36
        TabOrder = 7
      end
    end
  end
  object btnImport: TButton
    Left = 7
    Top = 397
    Width = 75
    Height = 25
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Import'
    Default = True
    ModalResult = 1
    TabOrder = 3
    OnClick = btnImportClick
  end
  object Button1: TButton
    Left = 498
    Top = 397
    Width = 75
    Height = 25
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Table'
    Default = True
    ModalResult = 1
    TabOrder = 4
    OnClick = Button1Click
  end
  object qBBIO: TFDQuery
    BeforePost = qBBIOBeforePost
    DetailFields = 'Ticker;Multiplier'
    Connection = DM.fDB
    SQL.Strings = (
      'SELECT * FROM config_bbio;')
    Left = 511
    Top = 27
  end
  object dsBBIO: TDataSource
    DataSet = qBBIO
    Left = 524
    Top = 26
  end
end
