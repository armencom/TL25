object frmOptionDialogTest: TfrmOptionDialogTest
  Left = 0
  Top = 0
  Caption = 'TradeLog Options'
  ClientHeight = 446
  ClientWidth = 475
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 405
    Width = 475
    Height = 41
    Align = alBottom
    TabOrder = 0
    object btnCancel: TButton
      Left = 323
      Top = 1
      Width = 75
      Height = 39
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Align = alLeft
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 0
    end
    object btnOK: TButton
      Left = 398
      Top = 1
      Width = 75
      Height = 39
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Align = alLeft
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 1
      OnClick = btnOKClick
    end
    object btnRestoreDefaults: TButton
      Left = 151
      Top = 1
      Width = 172
      Height = 39
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Align = alLeft
      Caption = 'Restore Defaults'
      TabOrder = 2
      OnClick = btnRestoreDefaultsClick
    end
    object Button1: TButton
      Left = 76
      Top = 1
      Width = 75
      Height = 39
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Align = alLeft
      Cancel = True
      Caption = '&Delete'
      TabOrder = 3
      OnClick = Button1Click
    end
    object btnAdd: TButton
      Left = 1
      Top = 1
      Width = 75
      Height = 39
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Align = alLeft
      Cancel = True
      Caption = '&Add'
      TabOrder = 4
      OnClick = btnAddClick
    end
  end
  object tabPages: TPageControl
    Left = 7
    Top = 4
    Width = 458
    Height = 383
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    ActivePage = TabETNs
    TabOrder = 1
    OnChange = tabPagesChange
    object tabGlobal: TTabSheet
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Global'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object lblCtrlW: TLabel
        Left = 270
        Top = 167
        Width = 35
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
        Width = 31
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
        Width = 54
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
        Width = 54
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
        Width = 32
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
        Width = 52
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
        Width = 53
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
        Width = 33
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
        Width = 53
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
        Width = 53
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
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object grdBBIO: TcxGrid
        Left = 18
        Top = 27
        Width = 407
        Height = 325
        TabOrder = 0
        object tvBBIO: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          ScrollbarAnnotations.CustomAnnotations = <>
          DataController.DataSource = ds
          DataController.DetailKeyFieldNames = 'id'
          DataController.Options = [dcoAssignGroupingValues, dcoAssignMasterDetailKeys, dcoSaveExpanding, dcoFocusTopRowAfterSorting, dcoImmediatePost]
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          NewItemRow.Visible = True
          OptionsBehavior.AlwaysShowEditor = True
          OptionsBehavior.FocusCellOnTab = True
          OptionsBehavior.FocusFirstCellOnNewRecord = True
          OptionsData.Appending = True
          OptionsView.ColumnAutoWidth = True
          OptionsView.GroupByBox = False
          object tvBBIOTicker: TcxGridDBColumn
            Caption = 'Symbol'
            DataBinding.FieldName = 'Ticker'
            PropertiesClassName = 'TcxTextEditProperties'
            SortIndex = 0
            SortOrder = soAscending
            Width = 118
          end
          object tvBBIOMultiplier: TcxGridDBColumn
            DataBinding.FieldName = 'Multiplier'
            PropertiesClassName = 'TcxSpinEditProperties'
            Properties.AssignedValues.MinValue = True
            HeaderAlignmentHorz = taRightJustify
            Width = 77
          end
          object tvBBIODescription: TcxGridDBColumn
            DataBinding.FieldName = 'Description'
            PropertiesClassName = 'TcxTextEditProperties'
            Width = 210
          end
        end
        object tv2: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          ScrollbarAnnotations.CustomAnnotations = <>
          DataController.DetailKeyFieldNames = 'id'
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          object tv2id: TcxGridDBColumn
            DataBinding.FieldName = 'id'
          end
          object tv2ConfigList: TcxGridDBColumn
            DataBinding.FieldName = 'ConfigList'
          end
          object tv2Symbol: TcxGridDBColumn
            DataBinding.FieldName = 'Symbol'
          end
          object tv2Multiplier: TcxGridDBColumn
            DataBinding.FieldName = 'Multiplier'
          end
          object tv2Description: TcxGridDBColumn
            DataBinding.FieldName = 'Description'
          end
        end
        object grdBBIOLevel1: TcxGridLevel
          GridView = tvBBIO
        end
      end
    end
    object tabFutures: TTabSheet
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Futures'
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object grdFutures: TcxGrid
        Left = 18
        Top = 27
        Width = 407
        Height = 325
        TabOrder = 0
        object tvFutures: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          ScrollbarAnnotations.CustomAnnotations = <>
          DataController.DataSource = ds
          DataController.DetailKeyFieldNames = 'id'
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          NewItemRow.Visible = True
          OptionsBehavior.FocusCellOnTab = True
          OptionsData.Appending = True
          OptionsView.ColumnAutoWidth = True
          OptionsView.GroupByBox = False
          object tvFuturesSymbol: TcxGridDBColumn
            DataBinding.FieldName = 'Symbol'
            PropertiesClassName = 'TcxTextEditProperties'
            SortIndex = 0
            SortOrder = soAscending
            Width = 60
          end
          object tvFuturesMultiplier: TcxGridDBColumn
            DataBinding.FieldName = 'Multiplier'
            PropertiesClassName = 'TcxSpinEditProperties'
            Properties.AssignedValues.MinValue = True
            HeaderAlignmentHorz = taRightJustify
            Width = 49
          end
          object tvFuturesDescription: TcxGridDBColumn
            DataBinding.FieldName = 'Description'
            PropertiesClassName = 'TcxTextEditProperties'
            Width = 163
          end
        end
        object cxGridDBTableView2: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          ScrollbarAnnotations.CustomAnnotations = <>
          DataController.DataSource = ds
          DataController.DetailKeyFieldNames = 'id'
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          object cxGridDBColumn4: TcxGridDBColumn
            DataBinding.FieldName = 'id'
          end
          object cxGridDBColumn5: TcxGridDBColumn
            DataBinding.FieldName = 'ConfigList'
          end
          object cxGridDBColumn6: TcxGridDBColumn
            DataBinding.FieldName = 'Symbol'
          end
          object cxGridDBColumn7: TcxGridDBColumn
            DataBinding.FieldName = 'Multiplier'
          end
          object cxGridDBColumn8: TcxGridDBColumn
            DataBinding.FieldName = 'Description'
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = tvFutures
        end
      end
    end
    object tabStrategies: TTabSheet
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Strategy Setup'
      ImageIndex = 4
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object grdStrategy: TcxGrid
        Left = 18
        Top = 27
        Width = 407
        Height = 325
        TabOrder = 0
        object tvStrategy: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          ScrollbarAnnotations.CustomAnnotations = <>
          DataController.DataSource = ds
          DataController.DetailKeyFieldNames = 'id'
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          NewItemRow.Visible = True
          OptionsBehavior.FocusCellOnTab = True
          OptionsData.Appending = True
          OptionsView.ColumnAutoWidth = True
          OptionsView.GroupByBox = False
          object tvStrategyList: TcxGridDBColumn
            Caption = 'Symbol'
            DataBinding.FieldName = 'List'
            PropertiesClassName = 'TcxTextEditProperties'
            SortIndex = 0
            SortOrder = soAscending
          end
        end
        object cxGridDBTableView4: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          ScrollbarAnnotations.CustomAnnotations = <>
          DataController.DataSource = ds
          DataController.DetailKeyFieldNames = 'id'
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          object cxGridDBColumn9: TcxGridDBColumn
            DataBinding.FieldName = 'id'
          end
          object cxGridDBColumn10: TcxGridDBColumn
            DataBinding.FieldName = 'ConfigList'
          end
          object cxGridDBColumn11: TcxGridDBColumn
            DataBinding.FieldName = 'Symbol'
          end
          object cxGridDBColumn12: TcxGridDBColumn
            DataBinding.FieldName = 'Multiplier'
          end
          object cxGridDBColumn13: TcxGridDBColumn
            DataBinding.FieldName = 'Description'
          end
        end
        object cxGridLevel2: TcxGridLevel
          GridView = tvStrategy
        end
      end
    end
    object tabMutFunds: TTabSheet
      Caption = 'Mutual Funds'
      ImageIndex = 4
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object grdMut: TcxGrid
        Left = 18
        Top = 27
        Width = 407
        Height = 325
        TabOrder = 0
        object tvMut: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          ScrollbarAnnotations.CustomAnnotations = <>
          DataController.DataSource = ds
          DataController.DetailKeyFieldNames = 'id'
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          NewItemRow.Visible = True
          OptionsBehavior.FocusCellOnTab = True
          OptionsData.Appending = True
          OptionsView.ColumnAutoWidth = True
          OptionsView.GroupByBox = False
          object tvMutTicker: TcxGridDBColumn
            Caption = 'Symbol'
            DataBinding.FieldName = 'Ticker'
            SortIndex = 0
            SortOrder = soAscending
            Width = 67
          end
          object tvMutDescription: TcxGridDBColumn
            DataBinding.FieldName = 'Description'
            Width = 222
          end
        end
        object cxGridLevel3: TcxGridLevel
          GridView = tvMut
        end
      end
    end
    object TabETNs: TTabSheet
      Caption = 'ETF/ETN'
      ImageIndex = 5
      DesignSize = (
        450
        355)
      object grdETF: TcxGrid
        Left = 18
        Top = 27
        Width = 407
        Height = 325
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        object tvETF: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          ScrollbarAnnotations.CustomAnnotations = <>
          DataController.DataSource = ds
          DataController.DetailKeyFieldNames = 'id'
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          NewItemRow.Visible = True
          OptionsBehavior.FocusCellOnTab = True
          OptionsData.Appending = True
          OptionsView.ColumnAutoWidth = True
          OptionsView.GroupByBox = False
          object tvETFTicker: TcxGridDBColumn
            Caption = 'Symbol'
            DataBinding.FieldName = 'Ticker'
            PropertiesClassName = 'TcxTextEditProperties'
            SortIndex = 0
            SortOrder = soAscending
            Width = 58
          end
          object tvETFType: TcxGridDBColumn
            Caption = 'SubType'
            DataBinding.FieldName = 'Type'
            PropertiesClassName = 'TcxComboBoxProperties'
            Properties.Items.Strings = (
              'ETF/ETN'
              'VTN'
              'CTN')
            Width = 56
          end
          object tvETFDescription: TcxGridDBColumn
            DataBinding.FieldName = 'Description'
            PropertiesClassName = 'TcxTextEditProperties'
            Width = 226
          end
        end
        object cxGridLevel4: TcxGridLevel
          GridView = tvETF
        end
      end
    end
  end
  object lblTab: TcxLabel
    Left = 29
    Top = 32
    Caption = 'ETF/ETN Symbol'
    Style.TextStyle = [fsBold]
  end
  object qry: TFDQuery
    BeforePost = qryBeforePost
    AfterPost = qryAfterPost
    AfterDelete = qryAfterPost
    DetailFields = 'Ticker;Multiplier'
    Connection = DM.fDB
    SQL.Strings = (
      ''
      'select * from _cBroadBased')
    Left = 399
    Top = 59
  end
  object ds: TDataSource
    DataSet = qry
    Left = 396
    Top = 106
  end
  object qcnt: TFDQuery
    BeforePost = qryBeforePost
    AfterPost = qryAfterPost
    AfterDelete = qryAfterPost
    DetailFields = 'Ticker;Multiplier'
    Connection = DM.fDB
    SQL.Strings = (
      'SELECT * FROM config_etfs')
    Left = 439
    Top = 59
  end
end
