object fManualEntry: TfManualEntry
  Left = 0
  Top = 0
  Caption = 'Manual Entry'
  ClientHeight = 299
  ClientWidth = 905
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIForm
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Grid: TcxGrid
    Left = 0
    Top = 0
    Width = 905
    Height = 258
    Align = alClient
    TabOrder = 0
    object Table: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      Navigator.Buttons.PriorPage.Visible = False
      Navigator.Buttons.NextPage.Visible = False
      Navigator.Buttons.Edit.Visible = False
      Navigator.Buttons.Post.Visible = False
      Navigator.Buttons.Cancel.Visible = False
      Navigator.Buttons.Refresh.Visible = False
      Navigator.Buttons.SaveBookmark.Visible = False
      Navigator.Buttons.Filter.Visible = False
      DataController.DataSource = dsTrades
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = 'Items: 0'
          Kind = skCount
          FieldName = 'Date'
          Column = Date
        end
        item
          Kind = skSum
          FieldName = 'Price'
          Column = TablePrice
        end
        item
          Kind = skSum
          FieldName = 'Comm'
          Column = TableComm
        end>
      DataController.Summary.SummaryGroups = <>
      OptionsBehavior.FocusCellOnTab = True
      OptionsBehavior.FocusFirstCellOnNewRecord = True
      OptionsBehavior.GoToNextCellOnEnter = True
      OptionsBehavior.FocusCellOnCycle = True
      OptionsCustomize.ColumnMoving = False
      OptionsData.Appending = True
      OptionsView.Footer = True
      OptionsView.GroupByBox = False
      Styles.ContentEven = cxStyle20
      Styles.StyleSheet = GridTableViewStyleSheetDevExpress
      object TableRecId: TcxGridDBColumn
        Caption = 'Line #'
        DataBinding.FieldName = 'RecId'
        PropertiesClassName = 'TcxSpinEditProperties'
        Properties.ReadOnly = True
        Properties.SpinButtons.Visible = False
        SortIndex = 0
        SortOrder = soAscending
        Styles.Content = cxStyle10
        Width = 58
      end
      object Date: TcxGridDBColumn
        DataBinding.FieldName = 'Date'
        PropertiesClassName = 'TcxDateEditProperties'
        Properties.AssignedValues.EditFormat = True
        Properties.ImmediatePost = True
        Properties.ShowTime = False
        Width = 70
      end
      object TableTime: TcxGridDBColumn
        DataBinding.FieldName = 'Time'
        PropertiesClassName = 'TcxTimeEditProperties'
        Width = 71
      end
      object TableOC: TcxGridDBColumn
        DataBinding.FieldName = 'OC'
        PropertiesClassName = 'TcxComboBoxProperties'
        Properties.CaseInsensitive = False
        Properties.DropDownListStyle = lsFixedList
        Properties.ImmediateDropDownWhenActivated = True
        Properties.ImmediatePost = True
        Properties.ImmediateUpdateText = True
        Properties.Items.Strings = (
          'B'
          'Bought'
          'Buy'
          'Buy to Cover'
          'Buy to Open'
          'C'
          'Close'
          'Open'
          'P'
          'Purchase'
          'S'
          'Sell'
          'Sell Short'
          'Sell to Close'
          'Sell to Open'
          'Sold')
        Properties.ValidationOptions = []
        Width = 95
      end
      object TableLS: TcxGridDBColumn
        DataBinding.FieldName = 'LS'
        PropertiesClassName = 'TcxComboBoxProperties'
        Properties.DropDownListStyle = lsFixedList
        Properties.ImmediatePost = True
        Properties.Items.Strings = (
          ''
          'Entry'
          'Exit'
          'S')
        Width = 60
      end
      object TableTicker: TcxGridDBColumn
        DataBinding.FieldName = 'Ticker'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.CharCase = ecUpperCase
        Properties.ValidateOnEnter = True
      end
      object TableShr: TcxGridDBColumn
        DataBinding.FieldName = 'Shr'
        PropertiesClassName = 'TcxSpinEditProperties'
        Properties.ImmediatePost = True
        Properties.MinValue = 0.000100000000000000
        Properties.ValueType = vtFloat
        Width = 80
      end
      object TablePrice: TcxGridDBColumn
        DataBinding.FieldName = 'Price'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Width = 80
      end
      object TableComm: TcxGridDBColumn
        DataBinding.FieldName = 'Comm'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Width = 80
      end
      object TableType: TcxGridDBColumn
        DataBinding.FieldName = 'Type'
        PropertiesClassName = 'TcxComboBoxProperties'
        Properties.DropDownListStyle = lsFixedList
        Properties.ImmediatePost = True
        Properties.Items.Strings = (
          'CTN'
          'CUR'
          'DCY'
          'DRP'
          'ETF'
          'FUT'
          'MUT'
          'OPT'
          'STK'
          'VTN')
        Properties.Sorted = True
        Width = 70
      end
      object TableMult: TcxGridDBColumn
        DataBinding.FieldName = 'Mult'
        PropertiesClassName = 'TcxSpinEditProperties'
        Properties.ImmediatePost = True
        Width = 54
      end
      object TableRate: TcxGridDBColumn
        DataBinding.FieldName = 'Rate'
        PropertiesClassName = 'TcxSpinEditProperties'
        Properties.ImmediatePost = True
        Properties.MinValue = 0.000100000000000000
        Properties.ValueType = vtFloat
        Width = 55
      end
    end
    object GridLevel1: TcxGridLevel
      GridView = Table
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 258
    Width = 905
    Height = 41
    Align = alBottom
    TabOrder = 5
    object btnImport: TcxButton
      Left = 809
      Top = 1
      Width = 95
      Height = 39
      Align = alRight
      Caption = '&Import'
      TabOrder = 0
      OnClick = btnImportClick
    end
    object btnCancel: TcxButton
      Left = 714
      Top = 1
      Width = 95
      Height = 39
      Align = alRight
      Caption = '&Cancel'
      TabOrder = 1
      OnClick = btnCancelClick
    end
  end
  object Trades: TdxMemData
    Indexes = <>
    Persistent.Data = {
      5665728FC2F5285C8FFE3F0C000000040000000C000300496400140000000100
      05004461746500140000000100050054696D650014000000010003004F430014
      000000010003004C530014000000010007005469636B65720014000000010004
      005368720008000000070006005072696365000800000007000500436F6D6D00
      1400000001000500547970650008000000060005004D756C7400080000000600
      05005261746500}
    SortOptions = []
    BeforePost = TradesBeforePost
    OnNewRecord = TradesNewRecord
    Left = 112
    Top = 96
    object TradesId: TAutoIncField
      FieldName = 'Id'
    end
    object TradesDate: TStringField
      FieldName = 'Date'
    end
    object TradesTime: TStringField
      FieldName = 'Time'
    end
    object TradesOC: TStringField
      FieldName = 'OC'
    end
    object TradesLS: TStringField
      FieldName = 'LS'
    end
    object TradesTicker: TStringField
      FieldName = 'Ticker'
    end
    object TradesShr: TStringField
      FieldName = 'Shr'
    end
    object TradesPrice: TCurrencyField
      FieldName = 'Price'
    end
    object TradesComm: TCurrencyField
      FieldName = 'Comm'
    end
    object TradesType: TStringField
      FieldName = 'Type'
    end
    object TradesMult: TFloatField
      FieldName = 'Mult'
    end
    object TradesRate: TFloatField
      FieldName = 'Rate'
    end
  end
  object dsTrades: TDataSource
    DataSet = Trades
    Left = 112
    Top = 144
  end
  object dxBarManager1: TdxBarManager
    AutoDockColor = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    DockColor = clBtnFace
    ImageOptions.LargeIcons = True
    ImageOptions.UseLargeImagesForLargeIcons = True
    PopupMenuLinks = <>
    UseSystemFont = True
    Left = 607
    Top = 65527
    DockControlHeights = (
      0
      0
      0
      0)
    object bbClear: TdxBarLargeButton
      Caption = 'Clear'
      Category = 0
      Hint = 'Clear'
      Visible = ivAlways
      ButtonStyle = bsChecked
      LargeImageIndex = 0
      SyncImageIndex = False
      ImageIndex = 0
    end
    object bbSimple: TdxBarLargeButton
      Caption = 'Simple'
      Category = 0
      Hint = 'Simple'
      Visible = ivAlways
      ButtonStyle = bsChecked
      LargeImageIndex = 1
      SyncImageIndex = False
      ImageIndex = 1
    end
    object bbAdvanced: TdxBarLargeButton
      Caption = 'Advanced'
      Category = 0
      Hint = 'Advanced'
      Visible = ivAlways
      ButtonStyle = bsChecked
      LargeImageIndex = 2
      SyncImageIndex = False
      ImageIndex = 2
    end
    object bbTicker: TdxBarLargeButton
      Caption = 'Ticker'
      Category = 0
      Hint = 'Ticker'
      Visible = ivAlways
      ButtonStyle = bsChecked
      LargeImageIndex = 15
      SyncImageIndex = False
      ImageIndex = 15
    end
    object bbTrade: TdxBarLargeButton
      Caption = 'Trade #'
      Category = 0
      Hint = 'Trade #'
      Visible = ivAlways
      ButtonStyle = bsChecked
      LargeImageIndex = 9
      SyncImageIndex = False
      ImageIndex = 9
    end
    object bbStrategy: TdxBarLargeButton
      Caption = 'Strategy'
      Category = 0
      Hint = 'Strategy'
      Visible = ivAlways
      ButtonStyle = bsChecked
      LargeImageIndex = 14
      SyncImageIndex = False
      ImageIndex = 14
    end
    object dxBarLargeButton7: TdxBarLargeButton
      Caption = 'New Button'
      Category = 0
      Hint = 'New Button'
      Visible = ivAlways
    end
    object bbNote: TdxBarButton
      Caption = 'Comment'
      Category = 0
      Hint = 'Comment'
      Visible = ivAlways
      ButtonStyle = bsChecked
      ImageIndex = 0
    end
    object bbDuplicate: TdxBarButton
      Caption = 'Duplicate'
      Category = 0
      Hint = 'Duplicate'
      Visible = ivAlways
      ButtonStyle = bsChecked
      ImageIndex = 0
    end
    object bbValidOption: TdxBarButton
      Caption = 'Valid Option'
      Category = 0
      Hint = 'Valid Option'
      Visible = ivAlways
      ButtonStyle = bsChecked
      ImageIndex = 0
    end
    object bbStocks: TdxBarButton
      Caption = 'Stocks'
      Category = 0
      Hint = 'Stocks'
      Visible = ivAlways
      ButtonStyle = bsChecked
    end
    object bbOptions: TdxBarButton
      Caption = 'Options'
      Category = 0
      Hint = 'Options'
      Visible = ivAlways
      ImageIndex = 1
    end
    object bbMutualFunds: TdxBarButton
      Caption = 'Mutual Funds'
      Category = 0
      Hint = 'Mutual Funds'
      Visible = ivAlways
      ButtonStyle = bsChecked
    end
    object bbETNETFs: TdxBarButton
      Caption = 'ETN/ETFs'
      Category = 0
      Hint = 'ETN/ETFs'
      Visible = ivAlways
      ButtonStyle = bsChecked
    end
    object bbFutures: TdxBarButton
      Caption = 'Futures'
      Category = 0
      Hint = 'Futures'
      Visible = ivAlways
      ButtonStyle = bsChecked
    end
    object bbCurrency: TdxBarButton
      Caption = 'Currency'
      Category = 0
      Hint = 'Currency'
      Visible = ivAlways
      ButtonStyle = bsChecked
    end
    object bbVTNs: TdxBarButton
      Caption = 'VTNs'
      Category = 0
      Hint = 'VTNs'
      Visible = ivAlways
      ButtonStyle = bsChecked
    end
    object bbCTNs: TdxBarButton
      Caption = 'CTNs'
      Category = 0
      Hint = 'CTNs'
      Visible = ivAlways
      ButtonStyle = bsChecked
    end
    object bbDigitalCurrency: TdxBarButton
      Caption = 'Digital Currency'
      Category = 0
      Hint = 'Digital Currency'
      Visible = ivAlways
      ButtonStyle = bsChecked
    end
    object bbDrips: TdxBarButton
      Caption = 'Drips'
      Category = 0
      Hint = 'Drips'
      Visible = ivAlways
      ButtonStyle = bsChecked
    end
    object dxBarButton14: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object dxBarButton15: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object beAccounts: TcxBarEditItem
      Category = 0
      Visible = ivAlways
      PropertiesClassName = 'TcxCheckGroupProperties'
      Properties.Items = <
        item
          Caption = 'MTM'
        end
        item
          Caption = 'IRA'
        end
        item
          Caption = 'Cash'
        end>
    end
    object beMatched: TcxBarEditItem
      Category = 0
      Visible = ivAlways
      PropertiesClassName = 'TcxCheckGroupProperties'
      Properties.Items = <
        item
          Caption = 'Matched Tax Lots'
        end
        item
          Caption = 'Exercise / Assigns'
        end>
    end
    object bbNew: TdxBarButton
      Caption = 'New'
      Category = 0
      Hint = 'New'
      Visible = ivAlways
    end
    object beMTM: TcxBarEditItem
      Caption = 'MTM'
      Category = 0
      Hint = 'MTM'
      Visible = ivAlways
      ShowCaption = True
      Width = 0
      PropertiesClassName = 'TcxCheckBoxProperties'
      Properties.ImmediatePost = True
      InternalEditValue = False
    end
    object beIRA: TcxBarEditItem
      Caption = 'IRA'
      Category = 0
      Hint = 'IRA'
      Visible = ivAlways
      ShowCaption = True
      Width = 0
      PropertiesClassName = 'TcxCheckBoxProperties'
      Properties.ImmediatePost = True
      InternalEditValue = False
    end
    object beCash: TcxBarEditItem
      Caption = 'Cash'
      Category = 0
      Hint = 'Cash'
      Visible = ivAlways
      ShowCaption = True
      Width = 0
      PropertiesClassName = 'TcxCheckBoxProperties'
      Properties.ImmediatePost = True
      InternalEditValue = False
    end
    object beExerciseAssigns: TcxBarEditItem
      Caption = 'Exercise / Assigns'
      Category = 0
      Hint = 'Exercise / Assigns'
      Visible = ivAlways
      ShowCaption = True
      Width = 0
      PropertiesClassName = 'TcxCheckBoxProperties'
      Properties.ImmediatePost = True
      InternalEditValue = False
    end
    object beMatchedTaxLots: TcxBarEditItem
      Caption = 'Matched Tax Lots'
      Category = 0
      Hint = 'Matched Tax Lots'
      Visible = ivAlways
      ShowCaption = True
      Width = 0
      PropertiesClassName = 'TcxCheckBoxProperties'
      Properties.ImmediatePost = True
      InternalEditValue = False
    end
    object beViewTime: TcxBarEditItem
      Caption = 'Time'
      Category = 0
      Hint = 'Time'
      Visible = ivAlways
      ShowCaption = True
      Width = 0
      PropertiesClassName = 'TcxCheckBoxProperties'
      Properties.ImmediatePost = True
      InternalEditValue = False
    end
    object beViewOptionTk: TcxBarEditItem
      Caption = 'Option Tk'
      Category = 0
      Hint = 'Option Tk'
      Visible = ivAlways
      ShowCaption = True
      Width = 0
      PropertiesClassName = 'TcxCheckBoxProperties'
      Properties.ImmediatePost = True
      InternalEditValue = False
    end
    object beViewStrategy: TcxBarEditItem
      Caption = 'Strategy'
      Category = 0
      Hint = 'Strategy'
      Visible = ivAlways
      ShowCaption = True
      Width = 0
      PropertiesClassName = 'TcxCheckBoxProperties'
      Properties.ImmediatePost = True
      InternalEditValue = False
    end
    object beViewMatched: TcxBarEditItem
      Caption = 'Matched'
      Category = 0
      Hint = 'Matched'
      Visible = ivAlways
      ShowCaption = True
      Width = 0
      PropertiesClassName = 'TcxCheckBoxProperties'
      Properties.ImmediatePost = True
      InternalEditValue = False
    end
    object beViewWSHoldDt: TcxBarEditItem
      Caption = 'WS Hold Dt'
      Category = 0
      Hint = 'WS Hold Dt'
      Visible = ivAlways
      ShowCaption = True
      Width = 0
      PropertiesClassName = 'TcxCheckBoxProperties'
      Properties.ImmediatePost = True
      InternalEditValue = False
    end
    object beViewNotes: TcxBarEditItem
      Caption = 'Notes'
      Category = 0
      Hint = 'Notes'
      Visible = ivAlways
      ShowCaption = True
      Width = 0
      PropertiesClassName = 'TcxCheckBoxProperties'
      Properties.ImmediatePost = True
      InternalEditValue = False
    end
    object beView8949Code: TcxBarEditItem
      Caption = '8949 Code'
      Category = 0
      Hint = '8949 Code'
      Visible = ivAlways
      ShowCaption = True
      Width = 0
      PropertiesClassName = 'TcxCheckBoxProperties'
      Properties.ImmediatePost = True
      InternalEditValue = False
    end
    object beViewWashSales: TcxBarEditItem
      Caption = 'Wash Sales'
      Category = 0
      Hint = 'Wash Sales'
      Visible = ivAlways
      ShowCaption = True
      Width = 0
      PropertiesClassName = 'TcxCheckBoxProperties'
      Properties.ImmediatePost = True
      InternalEditValue = False
    end
    object bbRecordsAdd: TdxBarLargeButton
      Caption = 'Add'
      Category = 0
      Hint = 'Add'
      Visible = ivAlways
      LargeImageIndex = 17
    end
    object bbRecordsInsert: TdxBarLargeButton
      Caption = 'Insert'
      Category = 0
      Hint = 'Insert'
      Visible = ivAlways
      LargeImageIndex = 19
    end
    object bbRecordsEdit: TdxBarLargeButton
      Caption = 'Edit'
      Category = 0
      Hint = 'Edit'
      Visible = ivAlways
      LargeImageIndex = 18
    end
    object bbRecordsDelete: TdxBarLargeButton
      Caption = 'Delete'
      Category = 0
      Hint = 'Delete'
      Visible = ivAlways
      LargeImageIndex = 20
    end
    object bbRecordsDeleteAll: TdxBarLargeButton
      Caption = 'Delete All'
      Category = 0
      Hint = 'Delete All'
      Visible = ivAlways
      LargeImageIndex = 21
    end
    object bbRecordsCut: TdxBarLargeButton
      Caption = 'Cut'
      Category = 0
      Hint = 'Cut'
      Visible = ivAlways
      LargeImageIndex = 22
    end
    object bbRecordsCopy: TdxBarLargeButton
      Caption = 'Copy'
      Category = 0
      Hint = 'Copy'
      Visible = ivAlways
      LargeImageIndex = 23
    end
    object bbRecordsPaste: TdxBarLargeButton
      Caption = 'Paste'
      Category = 0
      Hint = 'Paste'
      Visible = ivAlways
      LargeImageIndex = 24
    end
    object bbRecordsSelectAll: TdxBarLargeButton
      Caption = 'Select All'
      Category = 0
      Hint = 'Select All'
      Visible = ivAlways
      LargeImageIndex = 25
    end
    object bbEditLongShort: TdxBarLargeButton
      Tag = 1
      Caption = 'Long/Short'
      Category = 0
      Hint = 'Long/Short'
      Visible = ivAlways
      LargeImageIndex = 27
    end
    object bbEditStrategy: TdxBarLargeButton
      Tag = 2
      Caption = 'Strategy'
      Category = 0
      Hint = 'Strategy'
      Visible = ivAlways
      LargeImageIndex = 28
    end
    object bbEditTicker: TdxBarLargeButton
      Tag = 3
      Caption = 'Ticker'
      Category = 0
      Hint = 'Ticker'
      Visible = ivAlways
      LargeImageIndex = 29
    end
    object bbEditABCcode: TdxBarLargeButton
      Tag = 4
      Caption = 'ABC code'
      Category = 0
      Hint = 'ABC code'
      Visible = ivAlways
      LargeImageIndex = 26
    end
    object bbAccountAdd: TdxBarLargeButton
      Tag = 1
      Caption = 'Add'
      Category = 0
      Hint = 'Add'
      Visible = ivAlways
      LargeImageIndex = 30
    end
    object bbAccountBaseline: TdxBarLargeButton
      Tag = 2
      Caption = 'Baseline'
      Category = 0
      Hint = 'Baseline'
      Visible = ivAlways
      LargeImageIndex = 31
    end
    object bbAccountEdit: TdxBarLargeButton
      Tag = 3
      Caption = 'Edit'
      Category = 0
      Hint = 'Edit'
      Visible = ivAlways
      LargeImageIndex = 34
    end
    object bbAccountDelete: TdxBarLargeButton
      Tag = 4
      Caption = 'Delete'
      Category = 0
      Hint = 'Delete'
      Visible = ivAlways
      LargeImageIndex = 33
    end
    object bbAccountTransfer: TdxBarLargeButton
      Tag = 5
      Caption = 'Transfer'
      Category = 0
      Hint = 'Transfer'
      Visible = ivAlways
      LargeImageIndex = 35
    end
    object bbAccountChecklist: TdxBarLargeButton
      Tag = 6
      Align = iaRight
      Caption = 'Checklist'
      Category = 0
      Hint = 'Checklist'
      Visible = ivAlways
      LargeImageIndex = 32
    end
    object bbAdjustCost: TdxBarLargeButton
      Tag = 1
      Caption = 'Adj Cost'
      Category = 0
      Hint = 'Adj Cost'
      Visible = ivAlways
      LargeImageIndex = 36
    end
    object bbAdjustCorporateAction: TdxBarLargeButton
      Tag = 2
      Caption = 'Corporate Action'
      Category = 0
      Hint = 'Corporate Action'
      Visible = ivAlways
      LargeImageIndex = 37
    end
    object bbAdjustExercise: TdxBarLargeButton
      Tag = 3
      Caption = 'Exercise'
      Category = 0
      Hint = 'Exercise'
      Visible = ivAlways
      LargeImageIndex = 38
    end
    object bbAdjustExpire: TdxBarLargeButton
      Tag = 4
      Caption = 'Expire'
      Category = 0
      Hint = 'Expire'
      Visible = ivAlways
      LargeImageIndex = 39
    end
    object bbMatchLot: TdxBarLargeButton
      Tag = 1
      Caption = 'Match Lot'
      Category = 0
      Hint = 'Match Lot'
      Visible = ivAlways
      LargeImageIndex = 43
    end
    object bbUnMatch: TdxBarLargeButton
      Tag = 2
      Caption = 'UnMatch'
      Category = 0
      Hint = 'UnMatch'
      Visible = ivAlways
      LargeImageIndex = 46
    end
    object bbMatchOrder: TdxBarLargeButton
      Tag = 3
      Caption = 'Order'
      Category = 0
      Hint = 'Order'
      Visible = ivAlways
      LargeImageIndex = 44
    end
    object bbMatchLS: TdxBarLargeButton
      Tag = 4
      Caption = 'LS'
      Category = 0
      Hint = 'LS'
      Visible = ivAlways
      LargeImageIndex = 42
    end
    object bbMatchForce: TdxBarLargeButton
      Tag = 5
      Caption = 'Force'
      Category = 0
      Hint = 'Force'
      Visible = ivAlways
      LargeImageIndex = 41
    end
    object bbReMatch: TdxBarLargeButton
      Tag = 6
      Caption = 'ReMatch'
      Category = 0
      Hint = 'ReMatch'
      Visible = ivAlways
      LargeImageIndex = 45
    end
    object bbMatchCalcWS: TdxBarLargeButton
      Tag = 7
      Caption = 'Calc WS'
      Category = 0
      Hint = 'Calc WS'
      Visible = ivAlways
      LargeImageIndex = 40
    end
    object dxBarLargeButton9: TdxBarLargeButton
      Caption = 'New Button'
      Category = 0
      Hint = 'New Button'
      Visible = ivAlways
    end
    object dxBarLargeButton10: TdxBarLargeButton
      Caption = 'New Button'
      Category = 0
      Hint = 'New Button'
      Visible = ivAlways
    end
    object beMatchWsShortNLong: TcxBarEditItem
      Caption = 'WsShortNLong'
      Category = 0
      Hint = 'WsShortNLong'
      Visible = ivAlways
      ShowCaption = True
      Width = 0
      PropertiesClassName = 'TcxCheckBoxProperties'
      Properties.ImmediatePost = True
      InternalEditValue = False
    end
    object cxBarEditItem2: TcxBarEditItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      PropertiesClassName = 'TcxCheckGroupProperties'
      Properties.Items = <>
    end
    object beMatchWsUnderlying: TcxBarEditItem
      Caption = 'WsUnderlying'
      Category = 0
      Hint = 'WsUnderlying'
      Visible = ivAlways
      ShowCaption = True
      Width = 0
      PropertiesClassName = 'TcxCheckBoxProperties'
      Properties.ImmediatePost = True
      InternalEditValue = False
    end
    object dxBarSubItem1: TdxBarSubItem
      Caption = 'New SubItem'
      Category = 0
      Visible = ivAlways
      ItemLinks = <>
    end
    object beMatchWsClosedTrig: TcxBarEditItem
      Caption = 'WsClosedTrig'
      Category = 0
      Hint = 'WsClosedTrig'
      Visible = ivAlways
      ShowCaption = True
      Width = 0
      PropertiesClassName = 'TcxCheckBoxProperties'
      Properties.ImmediatePost = True
      InternalEditValue = False
    end
    object cxBarEditItem5: TcxBarEditItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      ShowCaption = True
      Width = 0
      PropertiesClassName = 'TcxCheckBoxProperties'
      Properties.ImmediatePost = True
    end
    object beMatchWsOpt2Stk: TcxBarEditItem
      Caption = 'WsOPT2STK'
      Category = 0
      Hint = 'WsOPT2STK'
      Visible = ivAlways
      ShowCaption = True
      Width = 0
      PropertiesClassName = 'TcxCheckBoxProperties'
      Properties.ImmediatePost = True
      InternalEditValue = False
    end
    object beMatchWsSTK2Opt: TcxBarEditItem
      Caption = 'WsSTK2OPT'
      Category = 0
      Hint = 'WsSTK2OPT'
      Visible = ivAlways
      ShowCaption = True
      Width = 0
      PropertiesClassName = 'TcxCheckBoxProperties'
      Properties.ImmediatePost = True
      InternalEditValue = False
    end
    object bbImportBaseLine: TdxBarLargeButton
      Tag = 1
      Caption = 'BaseLine'
      Category = 0
      Hint = 'BaseLine'
      Visible = ivAlways
      LargeImageIndex = 47
    end
    object bbImportAuto: TdxBarLargeButton
      Tag = 2
      Caption = 'Auto Import'
      Category = 0
      Hint = 'Auto Import'
      Visible = ivAlways
      LargeImageIndex = 48
    end
    object bbImportFile: TdxBarLargeButton
      Tag = 3
      Caption = 'File'
      Category = 0
      Hint = 'File'
      Visible = ivAlways
      LargeImageIndex = 50
    end
    object bbImportWeb: TdxBarLargeButton
      Tag = 4
      Caption = 'Web'
      Category = 0
      Hint = 'Web'
      Visible = ivAlways
      LargeImageIndex = 51
    end
    object bbImportExcel: TdxBarLargeButton
      Tag = 5
      Caption = 'Excel'
      Category = 0
      Hint = 'Excel'
      Visible = ivAlways
      LargeImageIndex = 49
    end
    object bbUndo_small: TdxBarButton
      Caption = 'New Button'
      Category = 0
      Enabled = False
      Hint = 'Undo'
      Visible = ivAlways
      LargeImageIndex = 27
    end
    object bbRedo_small: TdxBarButton
      Caption = 'New Button'
      Category = 0
      Enabled = False
      Hint = 'New Button'
      Visible = ivAlways
    end
    object dxBarLargeButton1: TdxBarLargeButton
      Caption = 'Ticker Lookup'
      Category = 0
      Hint = 'Ticker Lookup'
      Visible = ivAlways
      LargeImageIndex = 53
    end
    object dxBarLargeButton2: TdxBarLargeButton
      Caption = 'Tutorials'
      Category = 0
      Hint = 'Tutorials'
      Visible = ivAlways
      LargeImageIndex = 54
    end
    object dxBarLargeButton3: TdxBarLargeButton
      Caption = 'User Guide'
      Category = 0
      Hint = 'User Guide'
      Visible = ivAlways
      LargeImageIndex = 55
    end
    object dxBarLargeButton4: TdxBarLargeButton
      Caption = 'Get Support'
      Category = 0
      Hint = 'Get Support'
      Visible = ivAlways
      LargeImageIndex = 52
    end
    object bbOptons: TdxBarButton
      Caption = 'Options'
      Category = 0
      Hint = 'Options'
      Visible = ivAlways
    end
    object dxBarButton1: TdxBarButton
      Caption = 'New Button'
      Category = 0
      Hint = 'New Button'
      Visible = ivAlways
    end
    object bbExit: TdxBarButton
      Caption = 'Exit'
      Category = 0
      Hint = 'Exit'
      Visible = ivAlways
    end
    object bbNewOptions: TdxBarButton
      Caption = 'Options'
      Category = 0
      Hint = 'Options'
      Visible = ivAlways
    end
    object dxBarButton2: TdxBarButton
      Caption = 'Sign In'
      Category = 0
      Hint = 'Sign In'
      Visible = ivAlways
    end
    object dxBarLargeButton5: TdxBarLargeButton
      Caption = '&Reconcile 1099-B Sales / Proceeds'
      Category = 0
      Hint = 'Reconcile 1099-B Sales / Proceeds'
      Visible = ivAlways
    end
    object dxBarLargeButton6: TdxBarLargeButton
      Caption = '&Wash Sale Details'
      Category = 0
      Hint = 'Wash Sale Details'
      Visible = ivAlways
    end
    object dxBarLargeButton8: TdxBarLargeButton
      Caption = '&Potential Wash Sales'
      Category = 0
      Hint = 'Potential Wash Sales'
      Visible = ivAlways
    end
    object dxBarLargeButton11: TdxBarLargeButton
      Caption = 'Form &8949 (for IRS Schedule D)'
      Category = 0
      Hint = 'Form 8949 (for IRS Schedule D)'
      Visible = ivAlways
    end
    object dxBarLargeButton12: TdxBarLargeButton
      Caption = '&Gains && Losses (For State Schedule D Only)'
      Category = 0
      Hint = 'Gains && Losses (For State Schedule D Only)'
      Visible = ivAlways
    end
    object dxBarLargeButton13: TdxBarLargeButton
      Caption = 'Section 1256 Contracts (for Form 6781)'
      Category = 0
      Hint = 'Section 1256 Contracts (for Form 6781)'
      Visible = ivAlways
    end
    object dxBarLargeButton14: TdxBarLargeButton
      Caption = 'Forex / Currencies'
      Category = 0
      Hint = 'Forex / Currencies'
      Visible = ivAlways
    end
    object dxBarLargeButton15: TdxBarLargeButton
      Caption = 'MTM Accounting (for Form 4797)'
      Category = 0
      Hint = 'MTM Accounting (for Form 4797)'
      Visible = ivAlways
    end
    object dxBarLargeButton16: TdxBarLargeButton
      Caption = 'Form 8949 (for IRS Schedule D)'
      Category = 0
      Hint = 'Form 8949 (for IRS Schedule D)'
      Visible = ivAlways
    end
    object dxBarLargeButton17: TdxBarLargeButton
      Caption = 'MTM Accounting (for Form 4797)'
      Category = 0
      Hint = 'MTM Accounting (for Form 4797)'
      Visible = ivAlways
    end
    object dxBarLargeButton18: TdxBarLargeButton
      Caption = 'Forex / Currencies'
      Category = 0
      Hint = 'Forex / Currencies'
      Visible = ivAlways
    end
    object dxBarLargeButton19: TdxBarLargeButton
      Caption = 'Section 1256 Contracts (for Form 6781)'
      Category = 0
      Hint = 'Section 1256 Contracts (for Form 6781)'
      Visible = ivAlways
    end
    object dxBarLargeButton20: TdxBarLargeButton
      Caption = 'Gains && Losses (Schedule D-1 Substitute)'
      Category = 0
      Hint = 'Gains & Losses (Schedule D-1 Substitute)'
      Visible = ivAlways
    end
    object dxBarLargeButton21: TdxBarLargeButton
      Caption = 'Realized P&&L'
      Category = 0
      Hint = 'Realized P&L'
      Visible = ivAlways
    end
    object dxBarLargeButton22: TdxBarLargeButton
      Caption = '&Detail'
      Category = 0
      Hint = 'Detail'
      Visible = ivAlways
    end
    object dxBarLargeButton23: TdxBarLargeButton
      Caption = '&Chart'
      Category = 0
      Hint = 'Chart'
      Visible = ivAlways
    end
    object dxBarLargeButton24: TdxBarLargeButton
      Caption = '&Summary'
      Category = 0
      Hint = 'Summary'
      Visible = ivAlways
    end
    object dxBarLargeButton25: TdxBarLargeButton
      Caption = '&Performance'
      Category = 0
      Hint = 'Performance'
      Visible = ivAlways
    end
    object dxBarLargeButton26: TdxBarLargeButton
      Caption = 'Report &Setup'
      Category = 0
      Hint = 'Report Setup'
      Visible = ivAlways
    end
    object dxBarLargeButton27: TdxBarLargeButton
      Caption = 'New Button'
      Category = 0
      Hint = 'New Button'
      Visible = ivAlways
    end
    object cxBarEditItem1: TcxBarEditItem
      Caption = 'Open as of'
      Category = 0
      Hint = 'Open as of'
      Visible = ivAlways
    end
    object dxBarButton3: TdxBarButton
      Align = iaCenter
      Caption = 'Year End'
      Category = 0
      Hint = 'Year End'
      Visible = ivAlways
    end
    object dxBarDateCombo1: TdxBarDateCombo
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00DDDDDDDDDDDD
        DDDDDDDD00000000000DDDDD0FFFFFFFFF0D00000F0000000F0D0FFF0FFFFFFF
        FF0D0F000FFF11FFFF0D0FFF0FFF11FFFF0D0FF10FFFF11FFF0D0FF10FFFFF11
        FF0D0FF10FF11111FF0D0FF10FFFFFFFFF0D0FF104444444440D0FFF04444444
        440D044400000000000D04444444440DDDDD00000000000DDDDD}
    end
    object dxBarSubItem2: TdxBarSubItem
      Caption = 'New SubItem'
      Category = 0
      Visible = ivAlways
      ItemLinks = <>
    end
    object dxBarButton4: TdxBarButton
      Caption = 'New Button'
      Category = 0
      Hint = 'New Button'
      Visible = ivAlways
    end
    object cxBarEditItem3: TcxBarEditItem
      Align = iaCenter
      Caption = 'Open as of:'
      Category = 0
      Hint = 'Open as of:'
      Visible = ivAlways
      PropertiesClassName = 'TcxLabelProperties'
    end
    object cxBarEditItem4: TcxBarEditItem
      Category = 0
      Visible = ivAlways
      PropertiesClassName = 'TcxDateEditProperties'
    end
    object dxBarEdit1: TdxBarEdit
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
    end
    object dxBarLargeButton28: TdxBarLargeButton
      Caption = 'Transfer Opens'
      Category = 0
      Hint = 'Transfer Opens'
      Visible = ivAlways
    end
    object dxBarLargeButton29: TdxBarLargeButton
      Caption = 'Market Prices'
      Category = 0
      Hint = 'Market Prices'
      Visible = ivAlways
    end
    object dxBarLargeButton30: TdxBarLargeButton
      Caption = 'Expire Options'
      Category = 0
      Hint = 'Expire Options'
      Visible = ivAlways
    end
    object dxBarLargeButton31: TdxBarLargeButton
      Caption = 'Quick Start'
      Category = 0
      Hint = 'Quick Start'
      Visible = ivAlways
    end
    object dxBarLargeButton32: TdxBarLargeButton
      Caption = 'Support Center'
      Category = 0
      Hint = 'Support Center'
      Visible = ivAlways
    end
    object dxBarLargeButton33: TdxBarLargeButton
      Caption = 'New Features'
      Category = 0
      Hint = 'New Features'
      Visible = ivAlways
    end
    object dxBarLargeButton34: TdxBarLargeButton
      Caption = 'Register'
      Category = 0
      Hint = 'Register'
      Visible = ivAlways
    end
    object dxBarLargeButton35: TdxBarLargeButton
      Caption = 'Update'
      Category = 0
      Hint = 'Update'
      Visible = ivAlways
    end
    object dxBarLargeButton36: TdxBarLargeButton
      Caption = 'Debug Logging'
      Category = 0
      Hint = 'Debug Logging'
      Visible = ivAlways
    end
    object dxBarLargeButton37: TdxBarLargeButton
      Caption = 'New Button'
      Category = 0
      Hint = 'New Button'
      Visible = ivAlways
    end
    object dxBarLargeButton38: TdxBarLargeButton
      Caption = 'Purchase'
      Category = 0
      Hint = 'Purchase'
      Visible = ivAlways
    end
    object dxBarLargeButton39: TdxBarLargeButton
      Caption = 'About'
      Category = 0
      Hint = 'About'
      Visible = ivAlways
    end
    object dxBarLargeButton40: TdxBarLargeButton
      Caption = 'Debug Level'
      Category = 0
      Hint = 'Debug Level'
      Visible = ivAlways
    end
    object dxBarLargeButton41: TdxBarLargeButton
      Caption = 'Global &Options'
      Category = 0
      Hint = 'Global Options'
      Visible = ivAlways
    end
    object dxBarLargeButton42: TdxBarLargeButton
      Caption = 'BrokerConnect Timeout'
      Category = 0
      Hint = 'BrokerConnect Timeout'
      Visible = ivAlways
    end
    object dxBarLargeButton43: TdxBarLargeButton
      Caption = 'Display Quick Start Panel'
      Category = 0
      Hint = 'Display Quick Start Panel'
      Visible = ivAlways
    end
    object dxBarLargeButton44: TdxBarLargeButton
      Caption = '&New'
      Category = 0
      Hint = 'New'
      Visible = ivAlways
      LargeImageIndex = 24
      SyncImageIndex = False
      ImageIndex = 26
    end
    object dxBarLargeButton45: TdxBarLargeButton
      Caption = '&Open'
      Category = 0
      Hint = 'Open'
      Visible = ivAlways
      LargeImageIndex = 25
      SyncImageIndex = False
      ImageIndex = 27
    end
    object dxBarLargeButton47: TdxBarLargeButton
      Caption = '&Close'
      Category = 0
      Enabled = False
      Hint = 'Close'
      Visible = ivAlways
      LargeImageIndex = 21
      SyncImageIndex = False
      ImageIndex = 23
    end
    object dxBarLargeButton49: TdxBarLargeButton
      Caption = 'PW Reset Code'
      Category = 0
      Hint = 'PW Reset Code'
      Visible = ivNever
    end
    object bbFile_Save: TdxBarLargeButton
      Caption = '&Save'
      Category = 0
      Enabled = False
      Hint = 'Save'
      Visible = ivAlways
      LargeImageIndex = 28
      SyncImageIndex = False
      ImageIndex = 30
    end
    object bbFile_Edit: TdxBarLargeButton
      Caption = '&Edit'
      Category = 0
      Enabled = False
      Hint = 'Edit'
      Visible = ivAlways
      LargeImageIndex = 68
      SyncImageIndex = False
      ImageIndex = 11
    end
    object dxBarLargeButton52: TdxBarLargeButton
      Caption = '&Backup / Restore'
      Category = 0
      Hint = 'Backup / Restore'
      Visible = ivAlways
      LargeImageIndex = 20
      SyncImageIndex = False
      ImageIndex = 22
    end
    object bbFile_EndTaxYear: TdxBarLargeButton
      Caption = 'End Tax &Year'
      Category = 0
      Enabled = False
      Hint = 'End Tax Year'
      Visible = ivAlways
      LargeImageIndex = 22
      SyncImageIndex = False
      ImageIndex = 24
    end
    object bbFile_ReverseEndYear: TdxBarLargeButton
      Caption = '&Reverse End Tax Year'
      Category = 0
      Enabled = False
      Hint = 'Reverse End Tax Year'
      Visible = ivAlways
      LargeImageIndex = 27
      SyncImageIndex = False
      ImageIndex = 29
    end
    object btnLastFile1: TdxBarButton
      Caption = 'New Button'
      Category = 0
      Hint = 'New Button'
      Visible = ivAlways
    end
    object btnLastFile2: TdxBarButton
      Caption = 'New Button'
      Category = 0
      Hint = 'New Button'
      Visible = ivAlways
    end
    object btnLastFile3: TdxBarButton
      Caption = 'New Button'
      Category = 0
      Hint = 'New Button'
      Visible = ivAlways
    end
    object btnLastFile4: TdxBarButton
      Caption = 'New Button'
      Category = 0
      Hint = 'New Button'
      Visible = ivAlways
    end
    object dxBarLargeButton56: TdxBarLargeButton
      Caption = '&Add'
      Category = 0
      Hint = 'Add'
      Visible = ivAlways
      LargeImageIndex = 0
    end
    object dxBarLargeButton57: TdxBarLargeButton
      Caption = '&Delete'
      Category = 0
      Hint = 'Delete'
      Visible = ivAlways
      LargeImageIndex = 1
    end
    object dxBarLargeButton58: TdxBarLargeButton
      Caption = '&Edit'
      Category = 0
      Hint = 'Edit'
      Visible = ivAlways
      LargeImageIndex = 2
    end
    object dxBarLargeButton60: TdxBarLargeButton
      Caption = '&Transfer'
      Category = 0
      Hint = 'Transfer Open Positions'
      Visible = ivAlways
      LargeImageIndex = 3
    end
    object dxBarLargeButton61: TdxBarLargeButton
      Caption = '&Year End Checklist'
      Category = 0
      Hint = 'Year End Checklist'
      Visible = ivAlways
      LargeImageIndex = 5
    end
    object dxBarLargeButton62: TdxBarLargeButton
      Caption = 'Commission'
      Category = 0
      Hint = 'Commission'
      Visible = ivNever
    end
    object dxBarLargeButton68: TdxBarLargeButton
      Caption = 'Delete'
      Category = 0
      Hint = 'Delete'
      Visible = ivAlways
      LargeImageIndex = 15
    end
    object dxBarLargeButton69: TdxBarLargeButton
      Caption = 'Delete All'
      Category = 0
      Hint = 'Delete All'
      Visible = ivAlways
      LargeImageIndex = 16
    end
    object dxBarLargeButton74: TdxBarLargeButton
      Caption = '8949 Code'
      Category = 0
      Hint = '8949 Code'
      Visible = ivAlways
    end
    object dxBarLargeButton76: TdxBarLargeButton
      Caption = '&Cusip to Ticker'
      Category = 0
      Hint = 'Cusip to Ticker'
      Visible = ivAlways
      LargeImageIndex = 61
      SyncImageIndex = False
      ImageIndex = 12
    end
    object dxBarLargeButton78: TdxBarLargeButton
      Caption = '&Stock Descr to Ticker'
      Category = 0
      Hint = 'Stock Descr to Ticker Symbol'
      Visible = ivAlways
      LargeImageIndex = 12
      SyncImageIndex = False
      ImageIndex = 13
    end
    object dxBarLargeButton79: TdxBarLargeButton
      Caption = '&Stock Split'
      Category = 0
      Hint = 'Stock Split'
      Visible = ivAlways
      LargeImageIndex = 6
    end
    object dxBarLargeButton80: TdxBarLargeButton
      Caption = 'Cost &Basis'
      Category = 0
      Hint = 'Cost Basis'
      Visible = ivAlways
      LargeImageIndex = 7
    end
    object dxBarLargeButton82: TdxBarLargeButton
      Caption = '&Expire'
      Category = 0
      Hint = 'Expire'
      Visible = ivAlways
      LargeImageIndex = 9
    end
    object dxBarLargeButton83: TdxBarLargeButton
      Caption = 'E&xcercise'
      Category = 0
      Hint = 'Excercise'
      Visible = ivAlways
      LargeImageIndex = 8
    end
    object dxBarLargeButton85: TdxBarLargeButton
      Caption = '&Assign Strategy'
      Category = 0
      Hint = 'Assign Strategy'
      Visible = ivAlways
      LargeImageIndex = 15
      SyncImageIndex = False
      ImageIndex = 16
    end
    object dxBarLargeButton86: TdxBarLargeButton
      Caption = '&Note '
      Category = 0
      Hint = 'Assign Note '
      Visible = ivAlways
      LargeImageIndex = 13
      SyncImageIndex = False
      ImageIndex = 14
    end
    object dxBarLargeButton87: TdxBarLargeButton
      Caption = '&Match'
      Category = 0
      Hint = 'Match'
      Visible = ivAlways
      LargeImageIndex = 47
      SyncImageIndex = False
      ImageIndex = 48
    end
    object dxBarLargeButton88: TdxBarLargeButton
      Caption = '&UnMatch'
      Category = 0
      Hint = 'UnMatch'
      Visible = ivAlways
      LargeImageIndex = 49
      SyncImageIndex = False
      ImageIndex = 50
    end
    object dxBarLargeButton89: TdxBarLargeButton
      Caption = 'Re&order'
      Category = 0
      Hint = 'Reorder'
      Visible = ivAlways
      LargeImageIndex = 45
      SyncImageIndex = False
      ImageIndex = 46
    end
    object dxBarLargeButton90: TdxBarLargeButton
      Caption = '&Rematch'
      Category = 0
      Hint = 'Rematch'
      Visible = ivAlways
      LargeImageIndex = 48
      SyncImageIndex = False
      ImageIndex = 49
    end
    object dxBarLargeButton91: TdxBarLargeButton
      Caption = '&Force Match'
      Category = 0
      Hint = 'Force Match'
      Visible = ivAlways
      LargeImageIndex = 46
      SyncImageIndex = False
      ImageIndex = 47
    end
    object dxBarLargeButton92: TdxBarLargeButton
      Caption = 'New Button'
      Category = 0
      Hint = 'New Button'
      Visible = ivAlways
    end
    object dxBarLargeButton93: TdxBarLargeButton
      Caption = 'Add Record'
      Category = 0
      Hint = 'Add Record'
      Visible = ivAlways
      LargeImageIndex = 50
      SyncImageIndex = False
      ImageIndex = 51
    end
    object dxBarLargeButton95: TdxBarLargeButton
      Caption = 'Enter Baseline Positions'
      Category = 0
      Hint = 'Enter Baseline Positions'
      Visible = ivNever
      LargeImageIndex = 41
      SyncImageIndex = False
      ImageIndex = 42
    end
    object dxBarLargeButton96: TdxBarLargeButton
      Caption = '&Insert Record'
      Category = 0
      Hint = 'Insert Record'
      Visible = ivAlways
      LargeImageIndex = 57
      SyncImageIndex = False
      ImageIndex = 58
    end
    object dxBarLargeButton97: TdxBarLargeButton
      Caption = '&Ticker'
      Category = 0
      Hint = 'Ticker'
      Visible = ivAlways
      LargeImageIndex = 32
      SyncImageIndex = False
      ImageIndex = 34
    end
    object dxBarLargeButton98: TdxBarLargeButton
      Caption = 'Trade &No'
      Category = 0
      Hint = 'Trade No'
      Visible = ivAlways
      LargeImageIndex = 33
      SyncImageIndex = False
      ImageIndex = 35
    end
    object dxBarSubItem3: TdxBarSubItem
      Caption = 'New SubItem'
      Category = 0
      Visible = ivAlways
      ItemLinks = <>
    end
    object dxBarLargeButton99: TdxBarLargeButton
      Caption = 'Futures'
      Category = 0
      Hint = 'Futures'
      Visible = ivAlways
    end
    object dxBarLargeButton100: TdxBarLargeButton
      Caption = 'Currencies'
      Category = 0
      Hint = 'Currencies'
      Visible = ivAlways
    end
    object dxBarLargeButton101: TdxBarLargeButton
      Caption = 'MTM Accounts'
      Category = 0
      Hint = 'MTM Accounts'
      Visible = ivAlways
    end
    object dxBarLargeButton102: TdxBarLargeButton
      Caption = 'Cash Accounts'
      Category = 0
      Hint = 'Cash Accounts'
      Visible = ivAlways
    end
    object dxBarLargeButton103: TdxBarLargeButton
      Caption = 'IRA Accounts'
      Category = 0
      Hint = 'IRA Accounts'
      Visible = ivAlways
    end
    object dxBarLargeButton104: TdxBarLargeButton
      Caption = 'Grid Filter Dialog'
      Category = 0
      Hint = 'Grid Filter Dialog'
      Visible = ivAlways
    end
    object dxBarLargeButton105: TdxBarLargeButton
      Caption = 'Matched Tab Lots'
      Category = 0
      Hint = 'Matched Tab Lots'
      Visible = ivAlways
    end
    object dxBarLargeButton106: TdxBarLargeButton
      Caption = 'Exercises / Assigns'
      Category = 0
      Hint = 'Exercises / Assigns'
      Visible = ivAlways
    end
    object dxBarLargeButton107: TdxBarLargeButton
      Caption = 'Duplicate Trades'
      Category = 0
      Hint = 'Duplicate Trades'
      Visible = ivAlways
    end
    object dxBarLargeButton108: TdxBarLargeButton
      Caption = 'Invalid Option Tickers'
      Category = 0
      Hint = 'Invalid Option Tickers'
      Visible = ivAlways
    end
    object dxBarLargeButton112: TdxBarLargeButton
      Caption = '&Reconcile 1099-B'
      Category = 0
      Hint = 'Reconcile 1099-B Sales / Proceeds'
      Visible = ivAlways
    end
    object dxBarLargeButton113: TdxBarLargeButton
      Caption = 'Potential Wash Sales'
      Category = 0
      Hint = 'Potential Wash Sales'
      Visible = ivAlways
    end
    object dxBarLargeButton114: TdxBarLargeButton
      Caption = 'Wash Sale'
      Category = 0
      Hint = 'Wash Sale'
      Visible = ivAlways
    end
    object dxBarLargeButton115: TdxBarLargeButton
      Caption = 'New Button'
      Category = 0
      Hint = 'New Button'
      Visible = ivAlways
    end
    object dxBarLargeButton116: TdxBarLargeButton
      Caption = 'New Button'
      Category = 0
      Hint = 'New Button'
      Visible = ivAlways
    end
    object dxBarLargeButton117: TdxBarLargeButton
      Caption = 'New Button'
      Category = 0
      Hint = 'New Button'
      Visible = ivAlways
    end
    object dxBarLargeButton118: TdxBarLargeButton
      Caption = 'New Button'
      Category = 0
      Hint = 'New Button'
      Visible = ivAlways
    end
    object dxBarLargeButton119: TdxBarLargeButton
      Caption = 'New Button'
      Category = 0
      Hint = 'New Button'
      Visible = ivAlways
    end
    object dxBarLargeButton120: TdxBarLargeButton
      Caption = 'New Button'
      Category = 0
      Hint = 'New Button'
      Visible = ivAlways
    end
    object dxBarLargeButton121: TdxBarLargeButton
      Caption = 'New Button'
      Category = 0
      Hint = 'New Button'
      Visible = ivAlways
    end
    object dxBarLargeButton122: TdxBarLargeButton
      Caption = 'New Button'
      Category = 0
      Hint = 'New Button'
      Visible = ivAlways
    end
    object dxBarLargeButton123: TdxBarLargeButton
      Caption = 'New Button'
      Category = 0
      Hint = 'New Button'
      Visible = ivAlways
    end
    object dxBarLargeButton124: TdxBarLargeButton
      Caption = 'New Button'
      Category = 0
      Hint = 'New Button'
      Visible = ivAlways
    end
    object dxBarButton13: TdxBarButton
      Caption = 'Form 8949'
      Category = 0
      Hint = 'Form 8949'
      Visible = ivAlways
      LargeImageIndex = 45
    end
    object dxBarButton16: TdxBarButton
      Caption = '&Forex / Currencies'
      Category = 0
      Hint = 'Forex / Currencies'
      Visible = ivAlways
    end
    object dxBarButton17: TdxBarButton
      Caption = '&Gains & Losses'
      Category = 0
      Hint = 'Gains & Losses'
      Visible = ivAlways
    end
    object dxBarButton18: TdxBarButton
      Caption = '&Section 1256'
      Category = 0
      Hint = 'Section 1256'
      Visible = ivAlways
    end
    object dxBarButton19: TdxBarButton
      Caption = 'Sec 475 &MTM'
      Category = 0
      Hint = 'Sec 475 MTM'
      Visible = ivAlways
    end
    object dxBarButton20: TdxBarButton
      Caption = 'Form 8949 IRS'
      Category = 0
      Hint = 'Form 8949 IRS'
      Visible = ivAlways
    end
    object dxBarButton21: TdxBarButton
      Caption = 'Section 1256 Sched '#39'D'#39
      Category = 0
      Hint = 'Section 1256 Sched '#39'D'#39
      Visible = ivAlways
    end
    object dxBarButton22: TdxBarButton
      Caption = 'Forex / Currencies'
      Category = 0
      Hint = 'Forex / Currencies'
      Visible = ivAlways
    end
    object dxBarButton23: TdxBarButton
      Caption = 'MTM Accounting'
      Category = 0
      Hint = 'MTM Accounting'
      Visible = ivAlways
    end
    object dxBarButton24: TdxBarButton
      Caption = 'Gains & Losses IRS'
      Category = 0
      Hint = 'Gains  Losses IRS'
      Visible = ivAlways
    end
    object dxBarButton25: TdxBarButton
      Caption = 'Realized P&L'
      Category = 0
      Hint = 'Realized PL'
      Visible = ivAlways
    end
    object dxBarButton26: TdxBarButton
      Caption = 'Chart'
      Category = 0
      Hint = 'Chart'
      Visible = ivAlways
    end
    object dxBarButton27: TdxBarButton
      Caption = '&Detail'
      Category = 0
      Hint = 'Detail'
      Visible = ivAlways
    end
    object dxBarButton28: TdxBarButton
      Caption = 'Performance'
      Category = 0
      Hint = 'Performance'
      Visible = ivAlways
      ImageIndex = 66
      LargeImageIndex = 67
    end
    object dxBarButton29: TdxBarButton
      Caption = 'S&ummary'
      Category = 0
      Hint = 'Summary'
      Visible = ivAlways
    end
    object dxBarLargeButton125: TdxBarLargeButton
      Caption = 'Report Set&up'
      Category = 0
      Hint = 'Report Setup'
      Visible = ivAlways
      LargeImageIndex = 64
      SyncImageIndex = False
      ImageIndex = 63
    end
    object dxBarLargeButton126: TdxBarLargeButton
      Caption = 'Matched'
      Category = 0
      Hint = 'Matched'
      Visible = ivAlways
    end
    object dxBarLargeButton127: TdxBarLargeButton
      Caption = 'Wash Sale Holdings'
      Category = 0
      Hint = 'Wash Sale Holdings'
      Visible = ivAlways
    end
    object dxBarLargeButton128: TdxBarLargeButton
      Caption = '8949 Code'
      Category = 0
      Hint = '8949 Code'
      Visible = ivAlways
    end
    object dxBarLargeButton129: TdxBarLargeButton
      Caption = 'Quick Start'
      Category = 0
      Hint = 'Quick Start'
      Visible = ivAlways
    end
    object dxBarLargeButton130: TdxBarLargeButton
      Caption = 'Wash Sales'
      Category = 0
      Hint = 'Wash Sales'
      Visible = ivAlways
    end
    object dxBarLargeButton131: TdxBarLargeButton
      Caption = 'Time'
      Category = 0
      Hint = 'Time'
      Visible = ivAlways
    end
    object dxBarLargeButton132: TdxBarLargeButton
      Caption = 'Strategies'
      Category = 0
      Hint = 'Strategies'
      Visible = ivAlways
    end
    object dxBarLargeButton133: TdxBarLargeButton
      Caption = 'Option Tickers'
      Category = 0
      Hint = 'Option Tickers'
      Visible = ivAlways
    end
    object dxBarLargeButton134: TdxBarLargeButton
      Caption = 'Notes'
      Category = 0
      Hint = 'Notes'
      Visible = ivAlways
    end
    object dxBarLargeButton137: TdxBarLargeButton
      Caption = 'Support Center'
      Category = 0
      Hint = 'Support Center'
      Visible = ivAlways
      LargeImageIndex = 36
      SyncImageIndex = False
      ImageIndex = 38
    end
    object dxBarLargeButton138: TdxBarLargeButton
      Caption = 'New Button'
      Category = 0
      Hint = 'New Button'
      Visible = ivAlways
    end
    object dxBarLargeButton141: TdxBarLargeButton
      Caption = 'Register'
      Category = 0
      Hint = 'Register'
      Visible = ivAlways
    end
    object dxBarLargeButton142: TdxBarLargeButton
      Caption = 'Update'
      Category = 0
      Hint = 'Update'
      Visible = ivAlways
    end
    object dxBarLargeButton143: TdxBarLargeButton
      Caption = 'Get Suport'
      Category = 0
      Hint = 'Get Suport'
      Visible = ivAlways
      LargeImageIndex = 35
      SyncImageIndex = False
      ImageIndex = 37
    end
    object dxBarLargeButton144: TdxBarLargeButton
      Caption = 'Debug Logging'
      Category = 0
      Hint = 'Debug Logging'
      Visible = ivNever
    end
    object dxBarLargeButton146: TdxBarLargeButton
      Caption = 'About'
      Category = 0
      Hint = 'About'
      Visible = ivAlways
      LargeImageIndex = 34
      SyncImageIndex = False
      ImageIndex = 36
    end
    object dxBarLargeButton147: TdxBarLargeButton
      Caption = 'Debug Level'
      Category = 0
      Hint = 'Debug Level'
      Visible = ivNever
    end
    object cxBarEditItem6: TcxBarEditItem
      Align = iaClient
      Category = 0
      MergeKind = mkNone
      Visible = ivAlways
      Width = 0
      PropertiesClassName = 'TcxImageProperties'
      CanSelect = False
      LargeGlyph.Data = {
        F6120000424DF612000000000000360000002800000028000000280000000100
        180000000000C0120000C40E0000C40E00000000000000000000FF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFDE25D19874738F79668F79668F79668F79668F79668F7966
        8F79668F79668F79668F79668F79668F79668F79668F79668F79668F79669973
        73DE24D3FF00FFFF00FFFF00FFFF00FF955FDB5496C25396C25396C25396C253
        96C25396C25396C25396C25396C25396C25396C25396C25396C25396C25396C2
        8E7D6FC4B09FD4C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1
        B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B0C3AF9E9A7374FF00FFFF
        00FFFF00FFFF00FF5495C375C1F376C2F576C2F576C2F576C2F576C2F576C2F5
        76C2F576C2F576C2F576C2F576C2F576C2F576C2F576C2F58F7966D4C1B0D4C1
        B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4
        C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B08F7966FF00FFFF00FFFF00FFFF00FF
        5396C276C2F576C2F576C2F576C2F576C2F576C2F576C2F576C2F576C2F576C2
        F576C2F576C2F576C2F576C2F576C2F58F7966D4C1B0D4C1B0D4C1B0D4C1B0D4
        C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B0
        D4C1B0D4C1B0D4C1B08F7966FF00FFFF00FFFF00FFFF00FF5396C276C2F576C2
        F576C2F576C2F576C2F576C2F576C2F576C2F576C2F576C2F576C2F576C2F576
        C2F576C2F576C2F58F7966D4C1B0D4C1B0FFFFFFFFFFFFD4C1B0D4C1B0FFFFFF
        FFFFFFD4C1B0D4C1B0FFFFFFFFFFFFD4C1B0D4C1B08F8FF78F8FF7D4C1B0D4C1
        B08F7966FF00FFFF00FFFF00FFFF00FF5396C276C2F576C2F576C2F5FFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        8F7966D4C1B0D4C1B0FFFFFFFFFFFFD4C1B0D4C1B0FFFFFFFFFFFFD4C1B0D4C1
        B0FFFFFFFFFFFFD4C1B0D4C1B08F8FF78F8FF7D4C1B0D4C1B08F7966FF00FFFF
        00FFFF00FFFF00FF5396C276C2F576C2F576C2F5FFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8F7966D4C1B0D4C1
        B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4
        C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B08F7966FF00FFFF00FFFF00FFFF00FF
        5396C276C2F576C2F576C2F5FFFFFFFFFFFFD1D1F1C5C5EEFFFFFFDFC6B3F6EF
        E9DCDCF5BABAEAFFFFFFFFFFFFFFFFFF8F7966D4C1B0D4C1B0D4C1B0D4C1B0D4
        C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B0
        D4C1B0D4C1B0D4C1B08F7966FF00FFFF00FFFF00FFFF00FF5396C276C2F576C2
        F576C2F5FFFFFFFFFFFF9090DF7272D6FFFFFFB57A4EEAD9CCAEAEE75A5ACFFF
        FFFFFFFFFFFFFFFF8F7966D4C1B0D4C1B0FFFFFFFFFFFFD4C1B0D4C1B0FFFFFF
        FFFFFFD4C1B0D4C1B0FFFFFFFFFFFFD4C1B0D4C1B0A3EEFFA3EEFFD4C1B0D4C1
        B08F7966FF00FFFF00FFFF00FFFF00FF5396C276C2F576C2F576C2F5FFFFFFFF
        FFFF9090DF7171D6FFFFFFB57A4EEAD9CCAEAEE75959CFFFFFFFFFFFFFFFFFFF
        8F7966D4C1B0D4C1B0FFFFFFFFFFFFD4C1B0D4C1B0FFFFFFFFFFFFD4C1B0D4C1
        B0FFFFFFFFFFFFD4C1B0D4C1B0A3EEFFA3EEFFD4C1B0D4C1B08F7966FF00FFFF
        00FFFF00FFFF00FF5396C276C2F576C2F576C2F5FFFFFFFFFFFF9090DF7171D6
        FFFFFFB57A4EEAD9CCAEAEE75959CFFFFFFFFFFFFFFFFFFF8F7966D4C1B0D4C1
        B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4
        C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B08F7966FF00FFFF00FFFF00FFFF00FF
        5396C276C2F576C2F576C2F5FFFFFFFFFFFF9090DF7171D6FFFFFFDFC6B3F6EF
        E9AEAEE75959CFFFFFFFFFFFFFFFFFFF8F7966D4C1B0D4C1B0D4C1B0D4C1B0D4
        C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B0
        D4C1B0D4C1B0D4C1B08F7966FF00FFFF00FFFF00FFFF00FF5396C276C2F576C2
        F576C2F5FFFFFFFFFFFF9090DF7171D6FFFFFFFFFFFFFFFFFFC5C5EE8989DDFF
        FFFFFFFFFFFFFFFF8F7966D4C1B0D4C1B0FFFFFFFFFFFFD4C1B0D4C1B0FFFFFF
        FFFFFFD4C1B0D4C1B0FFFFFFFFFFFFD4C1B0D4C1B0A3EEFFA3EEFFD4C1B0D4C1
        B08F7966FF00FFFF00FFFF00FFFF00FF5396C276C2F576C2F576C2F5FFFFFFFF
        FFFF9191DF7575D7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        8F7966D4C1B0D4C1B0FFFFFFFFFFFFD4C1B0D4C1B0FFFFFFFFFFFFD4C1B0D4C1
        B0FFFFFFFFFFFFD4C1B0D4C1B0A3EEFFA3EEFFD4C1B0D4C1B08F7966FF00FFFF
        00FFFF00FFFF00FF5396C276C2F576C2F576C2F5FFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8F7966D4C1B0D4C1
        B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4
        C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B08F7966FF00FFFF00FFFF00FFFF00FF
        5396C276C2F576C2F576C2F5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8F7966D4C1B0D4C1B0D4C1B0D4C1B0D4
        C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B0D4C1B0
        D4C1B0D4C1B0D4C1B08F7966FF00FFFF00FFFF00FFFF00FF5396C276C2F576C2
        F576C2F5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFF8F7966EBDFD6EBDFD6EBDFD6EBDFD6EBDFD6EBDFD6EBDFD6
        EBDFD6EBDFD6EBDFD6EBDFD6EBDFD6EBDFD6EBDFD6EBDFD6EBDFD6EBDFD6EBDF
        D68F7966FF00FFFF00FFFF00FFFF00FF5396C276C2F576C2F576C2F5FFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        8F7966EBDFD6EBDFD6EBDFD6EBDFD6EBDFD6EBDFD6EBDFD6EBDFD6EBDFD6EBDF
        D6EBDFD6EBDFD6EBDFD6EBDFD6EBDFD6EBDFD6EBDFD6EBDFD68F7966FF00FFFF
        00FFFF00FFFF00FF5396C276C2F576C2F576C2F5FFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8F7966EBDFD6EBDF
        D6769C5E769C5E769C5E769C5E769C5E769C5E769C5E769C5E769C5E769C5E76
        9C5E769C5E769C5E769C5EEBDFD6EBDFD68F7966FF00FFFF00FFFF00FFFF00FF
        5396C276C2F576C2F576C2F5FFFFFFFFFFFFFFFFFFEFF3EC9FBB8F7CA0657DA0
        65A0BB8FEFF4EDFFFFFFFFFFFFFFFFFF8F7966EBDFD6EBDFD6769C5EBDE0BABD
        E0BABDE0BABDE0BABDE0BABDE0BABDE0BABDE0BABDE0BABDE0BABDE0BABDE0BA
        769C5EEBDFD6EBDFD68F7966FF00FFFF00FFFF00FFFF00FF5396C276C2F576C2
        F576C2F5FFFFFFFFFFFFEAEFE680A46A9DC090B7DBB3B7DAB29CC09080A46BEF
        F4EDFFFFFFFFFFFF8F7966EBDFD6EBDFD6769C5EBDE0BABDE0BABDE0BABDE0BA
        BDE0BABDE0BABDE0BABDE0BABDE0BABDE0BABDE0BABDE0BA769C5EEBDFD6EBDF
        D68F7966FF00FFFF00FFFF00FFFF00FF5396C276C2F576C2F576C2F5FFFFFFFF
        FFFF9DBA8D9DC090BDE0BABDE0BABDE0BABDE0BA9CC08FA0BC90FFFFFFFFFFFF
        8F7966EBDFD6EBDFD6769C5E769C5E769C5E769C5E769C5E769C5E769C5E769C
        5E769C5E769C5E769C5E769C5E769C5E769C5EEBDFD6EBDFD68F7966FF00FFFF
        00FFFF00FFFF00FF5396C276C2F576C2F576C2F5FFFFFFFFFFFF7BA065B6DAB1
        BDE0BABDE0BABDE0BABDE0BAB6D9B17DA065FFFFFFFFFFFF8F7966EBDFD6EBDF
        D6EBDFD6EBDFD6EBDFD6EBDFD6EBDFD6EBDFD6EBDFD6EBDFD6EBDFD6EBDFD6EB
        DFD6EBDFD6EBDFD6EBDFD6EBDFD6EBDFD68F7966FF00FFFF00FFFF00FFFF00FF
        5396C276C2F576C2F576C2F5FFFFFFFFFFFF7CA065B6D9B1BDE0BABDE0BA4D40
        364D40364D4036504539FFFFFFFFFFFF9A8574E1D3C8EBDFD6EBDFD6EBDFD6EB
        DFD6EBDFD6EBDFD6EBDFD6EBDFD6EBDFD6EBDFD6EBDFD6EBDFD6EBDFD6EBDFD6
        EBDFD6EBDFD6E0D2C79B7276FF00FFFF00FFFF00FFFF00FF5396C276C2F576C2
        F576C2F5FFFFFFFFFFFF9FBB8F9DC090BDE0BABDE0BA4D40369C8B7873665768
        6752FFFFFFFFFFFFDED7D19B87778F79668F79668F79668F79668F79668F7966
        8F79668F79668F79668F79668F79668F79668F79668F79668F79668F79669C72
        76DE24D3FF00FFFF00FFFF00FFFF00FF5396C276C2F576C2F576C2F5FFFFFFFF
        FFFFEFF3EC80A46B9DC090B4D8AE4D40367A6B5C53483BDDDFD8FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF76C2
        F576C2F576C2F55396C2FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FF5396C276C2F576C2F576C2F5FFFFFFFFFFFFFFFFFFEFF3EC
        9FBB8F7FA36951473A676551D6D8CFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF76C2F576C2F576C2F553
        96C2FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        5396C276C2F576C2F576C2F5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFF76C2F576C2F576C2F55396C2FF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF5396C276C2F576C2
        F576C2F5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFF76C2F576C2F576C2F55396C2FF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FF5396C276C2F576C2F576C2F5FFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF76C2
        F576C2F576C2F55396C2FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FF5396C276C2F576C2F576C2F5FFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF76C2F576C2F576C2F553
        96C2FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        5396C276C2F576C2F576C2F5FFFFFFFFFFFFFFFFFFFFFFFFDED7D19A87768F79
        668F79668F79668F79668F79668F79668F79668F79668F79668F79669B8776DE
        D8D3FFFFFFFFFFFFFFFFFFFFFFFF76C2F576C2F576C2F55396C2FF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF5396C276C2F576C2
        F576C2F5FFFFFFFFFFFFFFFFFFFFFFFF9B87768F79668F79668F79668F79668F
        79668F79668F79668F79668F79668F79668F79668F79669C8877FFFFFFFFFFFF
        FFFFFFFFFFFF76C2F576C2F576C2F55396C2FF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FF5396C276C2F576C2F576C2F576C2F576
        C2F576C2F576C2F58F79668F79668F79668F79668F796690786992766B92766B
        90786A8F79668F79668F79668F79668F796676C2F576C2F576C2F576C2F576C2
        F576C2F576C2F55396C2FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FF5396C276C2F576C2F576C2F576C2F576C2F576C2F576C2F5
        8F79668F79668F79668F796690786AAC5A8DF40CEFF30DEFAB5A8C8F786A8F79
        668F79668F79668F796676C2F576C2F576C2F576C2F576C2F576C2F576C2F553
        96C2FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        5495C375C0F276C2F576C2F576C2F576C2F576C2F576C2F58F79668F79668F79
        668F796693756BF30DEFFF00FFFF00FFF20EEE93756C8F79668F79668F79668F
        796676C2F576C2F576C2F576C2F576C2F576C2F575C0F25595C3FF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF955FDB5594C35396
        C25396C25396C25396C25396C25396C28F79668F79668F79668F796692756CF2
        0EEEFF00FFFF00FFF10FEC93746C8F79668F79668F79668F79665396C25396C2
        5396C25396C25396C25396C25594C3965EDCFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFC440AEB05593F110EBF010EB
        AF5692C440AFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFD02FCC440AE9D6A799D6A79C440AEFD02FCFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
    end
    object chViewMatched: TcxBarEditItem
      Caption = '&Matched'
      Category = 0
      Hint = 'Matched'
      Visible = ivAlways
      ShowCaption = True
      Width = 0
      PropertiesClassName = 'TcxCheckBoxProperties'
      Properties.ImmediatePost = True
      InternalEditValue = False
    end
    object chViewNotes: TcxBarEditItem
      Caption = '&Notes'
      Category = 0
      Hint = 'Notes'
      Visible = ivAlways
      ShowCaption = True
      Width = 0
      PropertiesClassName = 'TcxCheckBoxProperties'
      Properties.ImmediatePost = True
      InternalEditValue = False
    end
    object chViewOptionTickers: TcxBarEditItem
      Caption = '&Option Tickers'
      Category = 0
      Hint = 'Option Tickers'
      Visible = ivAlways
      ShowCaption = True
      Width = 0
      PropertiesClassName = 'TcxCheckBoxProperties'
      Properties.ImmediatePost = True
      InternalEditValue = False
    end
    object chViewStrategies: TcxBarEditItem
      Caption = '&Strategies'
      Category = 0
      Hint = 'Strategies'
      Visible = ivAlways
      ShowCaption = True
      Width = 0
      PropertiesClassName = 'TcxCheckBoxProperties'
      Properties.ImmediatePost = True
      InternalEditValue = False
    end
    object chViewTime: TcxBarEditItem
      Caption = '&Time'
      Category = 0
      Hint = 'Time'
      Visible = ivAlways
      ShowCaption = True
      Width = 0
      PropertiesClassName = 'TcxCheckBoxProperties'
      Properties.ImmediatePost = True
      InternalEditValue = False
    end
    object chViewWashSales: TcxBarEditItem
      Caption = 'Wash Sales'
      Category = 0
      Hint = 'Wash Sales'
      Visible = ivAlways
      ShowCaption = True
      Width = 0
      PropertiesClassName = 'TcxCheckBoxProperties'
      Properties.ImmediatePost = True
      InternalEditValue = False
    end
    object chViewQuickStart: TcxBarEditItem
      Caption = 'Quick Start'
      Category = 0
      Hint = 'Quick Start'
      Visible = ivAlways
      ShowCaption = True
      Width = 0
      PropertiesClassName = 'TcxCheckBoxProperties'
      Properties.ImmediatePost = True
      InternalEditValue = False
    end
    object cxBarEditItem14: TcxBarEditItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      PropertiesClassName = 'TcxCheckGroupProperties'
      Properties.Items = <>
    end
    object chViewAdjust: TcxBarEditItem
      Caption = '&Adjustment'
      Category = 0
      Hint = 'Adjustment'
      Visible = ivAlways
      ShowCaption = True
      Width = 0
      PropertiesClassName = 'TcxCheckBoxProperties'
      Properties.ImmediatePost = True
      InternalEditValue = False
    end
    object chViewWashSaleHoldings: TcxBarEditItem
      Caption = 'Wash Sale &Holding'
      Category = 0
      Hint = 'Wash Sale Holding'
      Visible = ivAlways
      ShowCaption = True
      Width = 0
      PropertiesClassName = 'TcxCheckBoxProperties'
      Properties.ImmediatePost = True
      InternalEditValue = False
    end
    object dxBarButton30: TdxBarButton
      Caption = 'E&xit'
      Category = 0
      Hint = 'Exit'
      Visible = ivAlways
      LargeImageIndex = 5
    end
    object dxBarLargeButton148: TdxBarLargeButton
      Caption = 'E&xit'
      Category = 0
      Hint = 'Exit'
      Visible = ivAlways
      LargeImageIndex = 23
      SyncImageIndex = False
      ImageIndex = 25
    end
    object dxBarLargeButton149: TdxBarLargeButton
      Caption = 'E&xit'
      Category = 0
      Hint = 'Exit'
      Visible = ivAlways
    end
    object bbUndo_Large: TdxBarLargeButton
      Caption = '&Undo'
      Category = 0
      Enabled = False
      Hint = 'Undo'
      Visible = ivAlways
      LargeImageIndex = 18
      SyncImageIndex = False
      ImageIndex = 19
    end
    object bbRedo_Large: TdxBarLargeButton
      Caption = '&Redo'
      Category = 0
      Enabled = False
      Hint = 'Redo'
      Visible = ivAlways
      LargeImageIndex = 14
      SyncImageIndex = False
      ImageIndex = 15
    end
    object dxBarSubItem4: TdxBarSubItem
      Caption = '8949 Code'
      Category = 0
      Visible = ivAlways
      ItemLinks = <>
    end
    object cxBarEditItem17: TcxBarEditItem
      Caption = '8949 Code'
      Category = 0
      Hint = '8949 Code'
      Visible = ivAlways
      PropertiesClassName = 'TcxCheckComboBoxProperties'
      Properties.Items = <
        item
          Description = 'Clear'
        end
        item
          Description = 'A'
        end
        item
          Description = 'B'
        end
        item
          Description = 'C'
        end>
    end
    object cxBarEditItem18: TcxBarEditItem
      Caption = '8949 Code'
      Category = 0
      Hint = '8949 Code'
      Visible = ivAlways
      PropertiesClassName = 'TcxComboBoxProperties'
      Properties.Items.Strings = (
        'Clear'
        'A'
        'B'
        'C')
    end
    object cxBarEditItem19: TcxBarEditItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      ShowCaption = True
      PropertiesClassName = 'TcxComboBoxProperties'
    end
    object dxBarCombo1: TdxBarCombo
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      ShowCaption = True
      ItemIndex = -1
    end
    object cxBarEditItem20: TcxBarEditItem
      Caption = '8949 Code'
      Category = 0
      Hint = '8949 Code'
      Visible = ivAlways
      PropertiesClassName = 'TcxLabelProperties'
    end
    object cxBarEditItem21: TcxBarEditItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      PropertiesClassName = 'TcxComboBoxProperties'
    end
    object cxBarEditItem22: TcxBarEditItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      PropertiesClassName = 'TcxLabelProperties'
    end
    object cxBarEditItem23: TcxBarEditItem
      Caption = '8949 Code'
      Category = 0
      Hint = '8949 Code'
      Visible = ivAlways
      ShowCaption = True
      PropertiesClassName = 'TcxComboBoxProperties'
      Properties.Items.Strings = (
        'Clear'
        'A'
        'B'
        'C')
    end
    object dxBarButton31: TdxBarButton
      Caption = '&Wash Sale Details'
      Category = 0
      Hint = 'Wash Sale Details'
      Visible = ivAlways
    end
    object dxBarButton32: TdxBarButton
      Caption = '&Potential Wash Sales'
      Category = 0
      Hint = 'Potential Wash Sales'
      Visible = ivAlways
      ImageIndex = 64
      LargeImageIndex = 65
    end
    object dxBarButton33: TdxBarButton
      Caption = 'New Button'
      Category = 0
      Hint = 'New Button'
      Visible = ivAlways
    end
    object dxBarLargeButton152: TdxBarLargeButton
      Caption = 'Form &8949'
      Category = 0
      Hint = 'Form 8949 (for IRS Schedule D)'
      Visible = ivAlways
      LargeImageIndex = 66
      SyncImageIndex = False
      ImageIndex = 65
    end
    object dxBarLargeButton153: TdxBarLargeButton
      Caption = 'Performance'
      Category = 0
      Hint = 'Performance'
      Visible = ivAlways
      LargeImageIndex = 46
    end
    object dxBarLargeButton154: TdxBarLargeButton
      Caption = 'Realized P&&L'
      Category = 0
      Hint = 'Realized P&L'
      Visible = ivAlways
      LargeImageIndex = 43
    end
    object dxBarButton36: TdxBarButton
      Caption = 'MTM'
      Category = 0
      Hint = 'MTM'
      Visible = ivAlways
    end
    object dxBarButton37: TdxBarButton
      Caption = 'IRA'
      Category = 0
      Hint = 'IRA'
      Visible = ivAlways
    end
    object dxBarButton38: TdxBarButton
      Caption = 'Cash'
      Category = 0
      Hint = 'Cash'
      Visible = ivAlways
    end
    object dxBarStatic1: TdxBarStatic
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
    end
    object btnBaseline: TdxBarLargeButton
      Caption = 'Baselines'
      Category = 0
      Hint = 'Baselines'
      Visible = ivAlways
      LargeImageIndex = 4
    end
    object btnFromFile: TdxBarLargeButton
      Caption = 'from &File'
      Category = 0
      Hint = 'from File'
      Visible = ivAlways
      LargeImageIndex = 41
      SyncImageIndex = False
      ImageIndex = 42
    end
    object btnFromWeb: TdxBarLargeButton
      Caption = 'from &Web'
      Category = 0
      Enabled = False
      Hint = 'from Web'
      Visible = ivAlways
      LargeImageIndex = 42
      SyncImageIndex = False
      ImageIndex = 43
    end
    object btnFromExcel: TdxBarLargeButton
      Caption = 'from &Excel'
      Category = 0
      Enabled = False
      Hint = 'from Excel'
      Visible = ivAlways
      LargeImageIndex = 40
      SyncImageIndex = False
      ImageIndex = 41
    end
    object dxBarButton43: TdxBarButton
      Caption = 'New Button'
      Category = 0
      Hint = 'New Button'
      Visible = ivAlways
    end
    object dxBarLargeButton48: TdxBarLargeButton
      Caption = '&Grid Filter'
      Category = 0
      Hint = 'Grid Filter'
      Visible = ivAlways
      LargeImageIndex = 30
      SyncImageIndex = False
      ImageIndex = 32
    end
    object dxBarLargeButton50: TdxBarLargeButton
      Caption = '&Advanced '
      Category = 0
      Hint = 'Advanced '
      Visible = ivAlways
      LargeImageIndex = 29
      SyncImageIndex = False
      ImageIndex = 31
    end
    object dxBarLargeButton51: TdxBarLargeButton
      Caption = '&Simple'
      Category = 0
      Visible = ivAlways
      LargeImageIndex = 31
      SyncImageIndex = False
      ImageIndex = 33
    end
    object cxBarEditItem24: TcxBarEditItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      PropertiesClassName = 'TcxCheckComboBoxProperties'
      Properties.Items = <>
    end
    object cbFindAdjusted: TdxBarCombo
      Align = iaRight
      Caption = 'Adjusted'
      Category = 0
      Hint = 'Adjusted'
      Visible = ivAlways
      Items.Strings = (
        ''
        'Matched'
        'Exercised / Assigned')
      ItemIndex = 0
    end
    object cbFindErrorCheck: TdxBarCombo
      Align = iaRight
      Caption = 'Error Check'
      Category = 0
      Hint = 'Error Check'
      Visible = ivAlways
      Items.Strings = (
        ''
        'Duplicate Trades'
        'Invalid Option Tickers')
      ItemIndex = 0
    end
    object cbFindAccounts: TdxBarCombo
      Align = iaRight
      Caption = 'Accounts'
      Category = 0
      Hint = 'Accounts'
      Visible = ivAlways
      Items.Strings = (
        ''
        'MTM'
        'IRA'
        'Cash')
      ItemIndex = 0
    end
    object dxBarLargeButton53: TdxBarLargeButton
      Caption = 'Preferences'
      Category = 0
      Hint = 'Preferences'
      Visible = ivNever
    end
    object btnViewWashSales: TdxBarButton
      Caption = '&Wash Sales'
      Category = 0
      Hint = 'Wash Sales'
      Visible = ivAlways
      ButtonStyle = bsChecked
    end
    object btnViewQuickStart: TdxBarButton
      Caption = '&Quick Start'
      Category = 0
      Hint = 'Quick Start'
      Visible = ivAlways
      ButtonStyle = bsChecked
    end
    object dxBarLargeButton54: TdxBarLargeButton
      Caption = '&Baselines'
      Category = 0
      Hint = 'Baselines'
      Visible = ivAlways
      LargeImageIndex = 4
    end
    object btnRecordsEdit: TdxBarLargeButton
      Caption = '&Edit'
      Category = 0
      Hint = 'Edit'
      Visible = ivAlways
      LargeImageIndex = 56
      SyncImageIndex = False
      ImageIndex = 57
    end
    object btnRecordsSplitTrade: TdxBarLargeButton
      Caption = '&Split Trade'
      Category = 0
      Hint = 'Split Trade'
      Visible = ivAlways
      LargeImageIndex = 60
      SyncImageIndex = False
      ImageIndex = 61
    end
    object btnRecordsConsolidatePartialFills: TdxBarLargeButton
      Caption = 'Consolidate Partial &Fills'
      Category = 0
      Hint = 'Consolidate Partial Fills'
      Visible = ivAlways
      LargeImageIndex = 51
      SyncImageIndex = False
      ImageIndex = 52
    end
    object dxBarLargeButton55: TdxBarLargeButton
      Caption = '&Transfer'
      Category = 0
      Hint = 'Transfer'
      Visible = ivAlways
      LargeImageIndex = 3
    end
    object dxBarLargeButton94: TdxBarLargeButton
      Caption = '&Copy'
      Category = 0
      Hint = 'Copy'
      Visible = ivAlways
      LargeImageIndex = 52
      SyncImageIndex = False
      ImageIndex = 53
    end
    object dxBarLargeButton109: TdxBarLargeButton
      Caption = '&Paste'
      Category = 0
      Hint = 'Paste'
      Visible = ivAlways
      LargeImageIndex = 58
      SyncImageIndex = False
      ImageIndex = 59
    end
    object dxBarLargeButton150: TdxBarLargeButton
      Caption = '&Select All'
      Category = 0
      Hint = 'Select All'
      Visible = ivAlways
      LargeImageIndex = 59
      SyncImageIndex = False
      ImageIndex = 60
    end
    object btnRecordsDelete: TdxBarLargeButton
      Caption = '&Delete'
      Category = 0
      Hint = 'Delete'
      Visible = ivAlways
      LargeImageIndex = 54
      SyncImageIndex = False
      ImageIndex = 55
    end
    object btnRecordsDeleteAll: TdxBarLargeButton
      Caption = 'De&lete All'
      Category = 0
      Hint = 'Delete All'
      Visible = ivAlways
      LargeImageIndex = 55
      SyncImageIndex = False
      ImageIndex = 56
    end
    object btnEditEdit: TdxBarLargeButton
      Caption = '&Edit'
      Category = 0
      Hint = 'Edit'
      Visible = ivAlways
      LargeImageIndex = 19
      SyncImageIndex = False
      ImageIndex = 21
    end
    object dxBarLargeButton63: TdxBarLargeButton
      Caption = '&L/S'
      Category = 0
      Hint = 'L/S'
      Visible = ivAlways
      LargeImageIndex = 44
      SyncImageIndex = False
      ImageIndex = 45
    end
    object btnEditTicker: TdxBarLargeButton
      Caption = '&Ticker'
      Category = 0
      Hint = 'Ticker'
      Visible = ivAlways
      LargeImageIndex = 11
    end
    object dxBarLargeButton66: TdxBarLargeButton
      Caption = 'Type/&Mult'
      Category = 0
      Hint = 'Type/Mult'
      Visible = ivAlways
      LargeImageIndex = 17
      SyncImageIndex = False
      ImageIndex = 18
    end
    object dxBarLargeButton67: TdxBarLargeButton
      Caption = '&Long/Short'
      Category = 0
      Hint = 'Long/Short'
      Visible = ivAlways
      LargeImageIndex = 16
      SyncImageIndex = False
      ImageIndex = 17
    end
    object dxImportSettings: TdxBarLargeButton
      Caption = 'Import &Settings'
      Category = 0
      Hint = 'Import Settings'
      Visible = ivAlways
      LargeImageIndex = 43
      SyncImageIndex = False
      ImageIndex = 44
    end
    object dxBrokerConnect: TdxBarLargeButton
      Caption = '&Broker Connect'
      Category = 0
      Hint = 'Broker Connect'
      Visible = ivAlways
      LargeImageIndex = 39
      SyncImageIndex = False
      ImageIndex = 40
    end
    object dxBarLargeButton71: TdxBarLargeButton
      Caption = 'Global Settings'
      Category = 0
      Hint = 'Global Settings'
      Visible = ivAlways
      LargeImageIndex = 37
      SyncImageIndex = False
      ImageIndex = 39
    end
    object dxBarLargeButton46: TdxBarLargeButton
      Caption = 'Adj &Code'
      Category = 0
      Hint = 'Adj Code'
      Visible = ivAlways
      LargeImageIndex = 10
    end
    object dxBarLargeButton59: TdxBarLargeButton
      Caption = 'Skins'
      Category = 0
      Hint = 'Skins'
      Visible = ivAlways
    end
    object dxBarListItem1: TdxBarListItem
      Caption = 'Skins'
      Category = 0
      Visible = ivAlways
      Items.Strings = (
        'Silver'
        'Blue'
        'Black'
        'High Contrast')
    end
    object dxBarLargeButton72: TdxBarLargeButton
      Caption = '&Year End Checklist'
      Category = 0
      Hint = 'Year End Checklist'
      Visible = ivAlways
      LargeImageIndex = 5
      SyncImageIndex = False
      ImageIndex = 5
    end
    object dxBarLargeButton73: TdxBarLargeButton
      Caption = 'P&erformance'
      Category = 0
      Hint = 'Performance'
      Visible = ivAlways
      LargeImageIndex = 67
      SyncImageIndex = False
      ImageIndex = 66
    end
    object dxBarLargeButton75: TdxBarLargeButton
      Caption = '&Chart'
      Category = 0
      Hint = 'Chart'
      Visible = ivAlways
      LargeImageIndex = 63
      SyncImageIndex = False
      ImageIndex = 62
    end
    object dxBarButton7: TdxBarButton
      Caption = 'Realized P&&&L'
      Category = 0
      Hint = 'Realized P&&L'
      Visible = ivAlways
    end
    object dxBarLargeButton77: TdxBarLargeButton
      Caption = '&Potential Wash Sales'
      Category = 0
      Hint = 'Potential Wash Sales'
      Visible = ivAlways
      LargeImageIndex = 65
      SyncImageIndex = False
      ImageIndex = 64
    end
    object dxBarButton8: TdxBarButton
      Caption = '&Reconcile 1099-B'
      Category = 0
      Hint = 'Reconcile 1099-B Sales / Proceeds'
      Visible = ivAlways
    end
    object dxBtnWSsettings: TdxBarLargeButton
      Caption = 'Wash Sale settings'
      Category = 0
      Hint = 'Wash Sale settings'
      Visible = ivAlways
      LargeImageIndex = 62
      SyncImageIndex = False
      ImageIndex = -1
    end
    object checkbox: TcxBarEditItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      ShowCaption = True
      Width = 0
      PropertiesClassName = 'TcxCheckBoxProperties'
      Properties.ImmediatePost = True
    end
    object dxBarButton5: TdxBarButton
      Caption = 'New Button'
      Category = 0
      Hint = 'New Button'
      Visible = ivAlways
    end
    object dxBarLargeButton81: TdxBarLargeButton
      Caption = 'Register'
      Category = 0
      Hint = 'Register'
      Visible = ivAlways
    end
    object dxBarLargeButton84: TdxBarLargeButton
      Caption = 'Update'
      Category = 0
      Hint = 'Update'
      Visible = ivAlways
    end
    object mruLastFile: TdxBarMRUListItem
      Caption = 'Recent &Files'
      Category = 0
      Visible = ivAlways
      ImageIndex = 9
      LargeImageIndex = 9
    end
    object dxBarLargeButton64: TdxBarLargeButton
      Caption = 'Adj &Code'
      Category = 0
      Hint = 'Adj Code'
      Visible = ivAlways
      LargeImageIndex = 10
      SyncImageIndex = False
      ImageIndex = 10
    end
    object dxBarLargeButton65: TdxBarLargeButton
      Caption = 'Trade Type Settings'
      Category = 0
      Hint = 'Trade Type Settings'
      Visible = ivAlways
      LargeImageIndex = 37
      SyncImageIndex = False
      ImageIndex = 39
    end
    object dxBarLargeButton70: TdxBarLargeButton
      Caption = 'File Settings'
      Category = 0
      Hint = 'File Settings'
      Visible = ivAlways
      LargeImageIndex = 37
    end
    object cbFindInstrament: TcxBarEditItem
      Caption = 'Instrument'
      Category = 0
      Hint = 'Instrument'
      Visible = ivAlways
      PropertiesClassName = 'TcxCheckComboBoxProperties'
      Properties.EditValueFormat = cvfCaptions
      Properties.ImmediateDropDownWhenActivated = True
      Properties.ImmediatePost = True
      Properties.Items = <
        item
          Description = 'Stocks'
          ShortDescription = 'STK'
        end
        item
          Description = 'Options'
          ShortDescription = 'OPT'
        end
        item
          Description = 'Mutual Funds'
          ShortDescription = 'MUT'
        end
        item
          Description = 'ETF/ETNs'
          ShortDescription = 'ETF'
        end
        item
          Description = 'VTNs'
          ShortDescription = 'VTN'
        end
        item
          Description = 'CTNs'
          ShortDescription = 'CTN'
        end
        item
          Description = 'Digital Currency'
          ShortDescription = 'DCY'
        end
        item
          Description = 'Drips'
          ShortDescription = 'DRP'
        end
        item
          Description = 'Futures'
          ShortDescription = 'FUT'
        end
        item
          Description = 'Currencies'
          ShortDescription = 'CUR'
        end>
    end
    object dxBarListItem2: TdxBarListItem
      Caption = 'New Item'
      Category = 0
      Visible = ivAlways
      Items.Strings = (
        'one'
        'two'
        'three'
        'four')
    end
    object dxBarListItem3: TdxBarListItem
      Caption = 'New Item'
      Category = 0
      Visible = ivAlways
    end
    object chInstrument2: TcxBarEditItem
      Caption = 'Instrament'
      Category = 0
      Hint = 'Instrament'
      Visible = ivAlways
      PropertiesClassName = 'TcxCheckGroupProperties'
      Properties.Columns = 3
      Properties.EditValueFormat = cvfStatesString
      Properties.ImmediatePost = True
      Properties.Items = <
        item
          Caption = 'STK'
        end
        item
          Caption = 'Options'
        end
        item
          Caption = 'Mutual Funds'
        end
        item
          Caption = 'ETF/ETNs'
        end
        item
          Caption = 'VTNs'
        end
        item
          Caption = 'CTNs'
        end
        item
          Caption = 'Digital Currency'
        end
        item
          Caption = 'Drips'
        end
        item
          Caption = 'Futures'
        end
        item
          Caption = 'Currencies'
        end>
    end
    object cxBarEditItem8: TcxBarEditItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      PropertiesClassName = 'TcxLabelProperties'
    end
    object lblInstrument: TcxBarEditItem
      Caption = 'Instrument'
      Category = 0
      Hint = 'Instrument'
      Visible = ivAlways
      PropertiesClassName = 'TcxLabelProperties'
      Properties.Alignment.Horz = taLeftJustify
    end
    object chInstrument: TcxBarEditItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      PropertiesClassName = 'TcxCheckGroupProperties'
      Properties.Items = <
        item
          Caption = 'STK'
        end
        item
          Caption = 'OPT'
        end
        item
          Caption = 'MUT'
        end>
    end
  end
  object cxStyleRepository1: TcxStyleRepository
    Left = 448
    Top = 152
    PixelsPerInch = 96
    object cxStyle1: TcxStyle
      AssignedValues = [svColor]
      Color = 15451300
    end
    object cxStyle2: TcxStyle
      AssignedValues = [svColor]
      Color = 15451300
    end
    object cxStyle3: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = 12937777
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      TextColor = clWhite
    end
    object cxStyle4: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = 12937777
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      TextColor = clWhite
    end
    object cxStyle5: TcxStyle
      AssignedValues = [svColor, svTextColor]
      Color = 16247513
      TextColor = clBlack
    end
    object cxStyle6: TcxStyle
      AssignedValues = [svColor, svTextColor]
      Color = 16445924
      TextColor = clBlack
    end
    object cxStyle7: TcxStyle
      AssignedValues = [svColor, svTextColor]
      Color = 15850688
      TextColor = clBlack
    end
    object cxStyle8: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = 12937777
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      TextColor = clWhite
    end
    object cxStyle9: TcxStyle
      AssignedValues = [svColor]
      Color = 15451300
    end
    object cxStyle10: TcxStyle
      AssignedValues = [svColor, svTextColor]
      Color = 4707838
      TextColor = clBlack
    end
    object cxStyle11: TcxStyle
      AssignedValues = [svColor]
      Color = 15451300
    end
    object cxStyle12: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = 16711164
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      TextColor = clSilver
    end
    object cxStyle13: TcxStyle
      AssignedValues = [svColor, svTextColor]
      Color = 12937777
      TextColor = clWhite
    end
    object cxStyle14: TcxStyle
      AssignedValues = [svColor]
      Color = 15451300
    end
    object cxStyle15: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = 16247513
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      TextColor = clBlack
    end
    object cxStyle16: TcxStyle
      AssignedValues = [svColor, svTextColor]
      Color = 16247513
      TextColor = clBlack
    end
    object cxStyle17: TcxStyle
      AssignedValues = [svColor, svTextColor]
      Color = 16247513
      TextColor = clBlack
    end
    object cxStyle18: TcxStyle
      AssignedValues = [svColor, svTextColor]
      Color = 14811135
      TextColor = clBlack
    end
    object cxStyle19: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = 14811135
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      TextColor = clNavy
    end
    object cxStyle20: TcxStyle
      AssignedValues = [svColor]
      Color = 14872561
    end
    object cxStyle21: TcxStyle
      AssignedValues = [svColor, svTextColor]
      Color = 4707838
      TextColor = clBlack
    end
    object cxStyle22: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = 12937777
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      TextColor = clWhite
    end
    object cxStyle23: TcxStyle
      AssignedValues = [svColor]
      Color = 15451300
    end
    object cxStyle24: TcxStyle
      AssignedValues = [svColor, svTextColor]
      Color = 4707838
      TextColor = clBlack
    end
    object cxStyle25: TcxStyle
      AssignedValues = [svColor]
      Color = 15451300
    end
    object cxStyle26: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = 14811135
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      TextColor = clNavy
    end
    object cxStyle27: TcxStyle
      AssignedValues = [svColor, svTextColor]
      Color = 12937777
      TextColor = clWhite
    end
    object GridTableViewStyleSheetDevExpress: TcxGridTableViewStyleSheet
      Caption = 'DevExpress'
      Styles.Background = cxStyle14
      Styles.Content = cxStyle15
      Styles.ContentEven = cxStyle16
      Styles.ContentOdd = cxStyle17
      Styles.FilterBox = cxStyle18
      Styles.Inactive = cxStyle23
      Styles.IncSearch = cxStyle24
      Styles.Selection = cxStyle27
      Styles.Footer = cxStyle19
      Styles.Group = cxStyle20
      Styles.GroupByBox = cxStyle21
      Styles.Header = cxStyle19
      Styles.Indicator = cxStyle25
      Styles.Preview = cxStyle26
      BuiltIn = True
    end
  end
end
