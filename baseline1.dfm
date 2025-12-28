object pnlBaseline1: TpnlBaseline1
  Left = 0
  Top = 0
  Margins.Left = 0
  Margins.Top = 0
  Margins.Right = 0
  Margins.Bottom = 0
  VertScrollBar.Tracking = True
  BorderIcons = []
  BorderStyle = bsNone
  ClientHeight = 889
  ClientWidth = 1107
  Color = clWhite
  DefaultMonitor = dmMainForm
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 18
  object pnlStep5: TPanel
    Left = 157
    Top = 389
    Width = 950
    Height = 186
    Margins.Left = 0
    Margins.Right = 0
    Margins.Bottom = 0
    BevelEdges = [beBottom]
    BevelOuter = bvNone
    TabOrder = 8
    Visible = False
    object Panel4: TPanel
      Left = 800
      Top = 0
      Width = 150
      Height = 186
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object btnContinueImporting: TRzButton
        Left = 30
        Top = 66
        Width = 100
        Height = 50
        Default = True
        Caption = 'Continue Importing'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        TabStop = False
        OnClick = btnContinueImportingClick
      end
      object btnFinish: TRzButton
        Left = 32
        Top = 10
        Width = 100
        Height = 36
        Default = True
        Caption = 'Finish'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        TabStop = False
        OnClick = btnFinishClick
      end
    end
    object Panel5: TPanel
      AlignWithMargins = True
      Left = 0
      Top = 0
      Width = 800
      Height = 166
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 20
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object RzPanel2: TRzPanel
        AlignWithMargins = True
        Left = 10
        Top = 102
        Width = 790
        Height = 43
        Margins.Left = 10
        Margins.Top = 2
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        AutoSize = True
        BorderOuter = fsNone
        Color = clWhite
        Padding.Right = 10
        TabOrder = 0
        object RzLabel19: TRzLabel
          AlignWithMargins = True
          Left = 7
          Top = 10
          Width = 780
          Height = 33
          Margins.Left = 0
          Margins.Top = 10
          Margins.Right = 0
          Margins.Bottom = 0
          AutoSize = False
          Caption = 
            '....Or click the "Continue Importing" button to import more of y' +
            'our trade history to see if TradeLog can find these trade record' +
            's.'
          Color = clWhite
          ParentColor = False
          WordWrap = True
          BlinkIntervalOff = 100
          BlinkIntervalOn = 100
        end
      end
      object RzPanel4: TRzPanel
        AlignWithMargins = True
        Left = 10
        Top = 60
        Width = 790
        Height = 40
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        AutoSize = True
        BorderOuter = fsNone
        Color = clWhite
        Padding.Right = 10
        TabOrder = 1
        object RzLabel24: TRzLabel
          Left = 15
          Top = 0
          Width = 765
          Height = 40
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alClient
          AutoSize = False
          Caption = 
            'When ALL entries have been made, please click the "Finish" butto' +
            'n to enter these in the main grid and exit the wizard.'
          Color = clWhite
          ParentColor = False
          WordWrap = True
          BlinkIntervalOff = 100
          BlinkIntervalOn = 100
        end
        object RzLabel25: TRzLabel
          Left = 0
          Top = 0
          Width = 15
          Height = 40
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alLeft
          AutoSize = False
          Caption = #8226
          Color = clWhite
          ParentColor = False
          BlinkIntervalOff = 100
          BlinkIntervalOn = 100
        end
      end
      object RzPanel1: TRzPanel
        AlignWithMargins = True
        Left = 10
        Top = 10
        Width = 790
        Height = 40
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        AutoSize = True
        BorderOuter = fsNone
        Color = clWhite
        Padding.Right = 10
        TabOrder = 2
        object RzLabel2: TRzLabel
          Left = 15
          Top = 0
          Width = 765
          Height = 40
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alClient
          AutoSize = False
          Caption = 
            'Please lookup and enter the Date, Price, and Commission or Amoun' +
            't for these positions from your monthly statements and enter in ' +
            'the grid below.'
          Color = clWhite
          ParentColor = False
          WordWrap = True
          BlinkIntervalOff = 100
          BlinkIntervalOn = 100
          ExplicitHeight = 39
        end
        object RzLabel3: TRzLabel
          Left = 0
          Top = 0
          Width = 15
          Height = 40
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alLeft
          AutoSize = False
          Caption = #8226
          Color = clWhite
          ParentColor = False
          BlinkIntervalOff = 100
          BlinkIntervalOn = 100
          ExplicitHeight = 39
        end
      end
    end
  end
  object pnlStep3: TPanel
    Left = 157
    Top = 255
    Width = 945
    Height = 87
    Margins.Left = 0
    Margins.Right = 0
    Margins.Bottom = 0
    BevelEdges = [beBottom]
    BevelOuter = bvNone
    TabOrder = 6
    Visible = False
    object wbStep3: TWebBrowser
      AlignWithMargins = True
      Left = 10
      Top = 10
      Width = 665
      Height = 67
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 20
      Margins.Bottom = 10
      ParentCustomHint = False
      Align = alClient
      ParentShowHint = False
      ShowHint = False
      TabOrder = 1
      OnDocumentComplete = wbStep3DocumentComplete
      ExplicitWidth = 703
      ExplicitHeight = 70
      ControlData = {
        4C000000BB440000ED0600000000000000000000000000000000000000000000
        000000004C000000000000000000000001000000E0D057007335CF11AE690800
        2B2E126209000000000000004C0000000114020000000000C000000000000046
        8000000000000000000000000000000000000000000000000000000000000000
        00000000000000000100000000000000000000000000000000000000}
    end
    object pnlImport: TPanel
      Left = 695
      Top = 0
      Width = 250
      Height = 87
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object btnImport: TRzButton
        Left = 136
        Top = 10
        Width = 100
        Height = 50
        Hint = 'Click the Import Help button for assistance.'
        Default = True
        Caption = 'Import'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = btnImportClick
      end
      object btnImpUG: TRzButton
        Left = 14
        Top = 10
        Width = 100
        Height = 36
        Default = True
        Caption = 'Import Help'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = btnImpUGClick
      end
    end
  end
  object pnlStep1: TPanel
    Left = 35
    Top = 0
    Width = 946
    Height = 211
    BevelEdges = [beBottom]
    BevelKind = bkFlat
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 3
    OnResize = pnlStep1Resize
    object pnlStep1btns: TPanel
      Left = 0
      Top = 144
      Width = 946
      Height = 64
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object pnlUnsettled: TPanel
        Left = 350
        Top = 0
        Width = 350
        Height = 64
        Margins.Left = 2
        Margins.Top = 20
        Margins.Right = 0
        Margins.Bottom = 10
        Align = alLeft
        BevelOuter = bvNone
        Constraints.MinWidth = 350
        TabOrder = 0
        object pnlBtnUnsettled: TPanel
          AlignWithMargins = True
          Left = 0
          Top = 5
          Width = 300
          Height = 59
          Margins.Left = 0
          Margins.Top = 5
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alLeft
          BevelOuter = bvNone
          TabOrder = 0
          object btnUnsettled: TRzButton
            Left = 70
            Top = 4
            Width = 100
            Height = 36
            Caption = 'Go to Step 3'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnClick = btnUnsettledClick
          end
        end
      end
      object pnlHoldings: TPanel
        Left = 0
        Top = 0
        Width = 350
        Height = 64
        Margins.Left = 0
        Margins.Top = 20
        Margins.Right = 0
        Margins.Bottom = 10
        Align = alLeft
        Anchors = []
        BevelOuter = bvNone
        Constraints.MinWidth = 350
        UseDockManager = False
        TabOrder = 1
        object pnlBtnHoldings: TPanel
          AlignWithMargins = True
          Left = 0
          Top = 5
          Width = 300
          Height = 59
          Margins.Left = 0
          Margins.Top = 5
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alLeft
          BevelOuter = bvNone
          Constraints.MinWidth = 120
          TabOrder = 0
          object btnHoldings: TRzButton
            Left = 77
            Top = 4
            Width = 100
            Height = 36
            Default = True
            Caption = 'Go to Step 2'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnClick = btnHoldingsClick
          end
        end
      end
    end
    object wbStep1: TWebBrowser
      AlignWithMargins = True
      Left = 10
      Top = 10
      Width = 916
      Height = 67
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 20
      Margins.Bottom = 0
      ParentCustomHint = False
      Align = alTop
      ParentShowHint = False
      ShowHint = False
      TabOrder = 1
      OnDocumentComplete = wbStep1DocumentComplete
      ExplicitWidth = 968
      ControlData = {
        4C000000AC5E0000ED0600000000000000000000000000000000000000000000
        000000004C000000000000000000000001000000E0D057007335CF11AE690800
        2B2E126209000000000000004C0000000114020000000000C000000000000046
        8000000000000000000000000000000000000000000000000000000000000000
        00000000000000000100000000000000000000000000000000000000}
    end
    object wbStep1a: TWebBrowser
      AlignWithMargins = True
      Left = 10
      Top = 77
      Width = 916
      Height = 67
      Margins.Left = 10
      Margins.Top = 0
      Margins.Right = 20
      Margins.Bottom = 0
      ParentCustomHint = False
      Align = alTop
      ParentShowHint = False
      ShowHint = False
      TabOrder = 2
      OnDocumentComplete = wbStep1aDocumentComplete
      ExplicitWidth = 968
      ControlData = {
        4C000000AC5E0000ED0600000000000000000000000000000000000000000000
        000000004C000000000000000000000001000000E0D057007335CF11AE690800
        2B2E126209000000000000004C0000000114020000000000C000000000000046
        8000000000000000000000000000000000000000000000000000000000000000
        00000000000000000100000000000000000000000000000000000000}
    end
  end
  object pnlMain: TPanel
    Left = 0
    Top = 581
    Width = 1107
    Height = 263
    Align = alBottom
    BevelEdges = []
    BevelKind = bkFlat
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    Padding.Left = 20
    Padding.Top = 20
    Padding.Bottom = 10
    ParentBackground = False
    ParentColor = True
    ParentFont = False
    TabOrder = 0
    Visible = False
    object pnlType: TPanel
      AlignWithMargins = True
      Left = 671
      Top = 23
      Width = 226
      Height = 227
      Align = alRight
      AutoSize = True
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      object lblInstrType: TLabel
        Left = 12
        Top = 48
        Width = 63
        Height = 16
        Alignment = taRightJustify
        Caption = 'Instr Type:'
      end
      object lblTick: TLabel
        Left = 0
        Top = 83
        Width = 75
        Height = 16
        Alignment = taRightJustify
        Caption = 'Stock Ticker:'
      end
      object lblShares: TLabel
        Left = 17
        Top = 118
        Width = 58
        Height = 16
        Alignment = taRightJustify
        Caption = '# Shares:'
      end
      object lblContrMult: TLabel
        Left = 7
        Top = 153
        Width = 68
        Height = 16
        Alignment = taRightJustify
        Caption = 'Contr  Mult:'
        Visible = False
      end
      object lblLS: TLabel
        Left = 7
        Top = 13
        Width = 68
        Height = 16
        Alignment = taRightJustify
        Caption = 'Long/Short:'
      end
      object edShares: TEdit
        Left = 81
        Top = 115
        Width = 110
        Height = 24
        Alignment = taCenter
        DoubleBuffered = False
        HideSelection = False
        ParentDoubleBuffered = False
        TabOrder = 1
        OnExit = edSharesExit
      end
      object cboTypeMult: TRzComboBox
        Left = 81
        Top = 45
        Width = 145
        Height = 24
        DropDownCount = 10
        TabOrder = 4
        OnChange = cboTypeMultChange
      end
      object cboContrMult: TRzComboBox
        Left = 81
        Top = 150
        Width = 68
        Height = 24
        TabOrder = 2
        Visible = False
        Items.Strings = (
          '100'
          '10')
      end
      object cboLS: TRzComboBox
        Left = 81
        Top = 10
        Width = 68
        Height = 24
        TabOrder = 3
        Text = 'Long'
        Items.Strings = (
          'Long'
          'Short')
      end
      object edTick: TRzEdit
        Left = 81
        Top = 79
        Width = 145
        Height = 24
        Text = ''
        AutoSelect = False
        AutoSize = False
        CharCase = ecUpperCase
        HideSelection = False
        TabOrder = 0
      end
      object btnGetOpenPos: TRzButton
        Left = 79
        Top = 186
        Width = 100
        Height = 36
        Hint = 'Restore open positions list from text file.'
        Caption = 'Restore List'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 5
        TabStop = False
        OnClick = btnGetOpenPosClick
      end
    end
    object pnlAdd: TPanel
      Left = 900
      Top = 20
      Width = 207
      Height = 233
      Align = alRight
      BevelEdges = []
      BevelOuter = bvNone
      TabOrder = 1
      object pnlOption: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 201
        Height = 140
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 0
        Visible = False
        object lblStrike: TLabel
          Left = 18
          Top = 72
          Width = 70
          Height = 16
          Alignment = taRightJustify
          Caption = 'Strike Price:'
        end
        object lblCallPut: TLabel
          Left = 39
          Top = 105
          Width = 49
          Height = 16
          Alignment = taRightJustify
          Caption = 'Call/Put:'
        end
        object lblExpdate: TLabel
          Left = 20
          Top = 6
          Width = 91
          Height = 16
          Alignment = taRightJustify
          Caption = 'Expiration Date:'
        end
        object cboCallPut: TRzComboBox
          Left = 94
          Top = 102
          Width = 91
          Height = 24
          TabOrder = 4
        end
        object edStrike: TEdit
          Left = 94
          Top = 69
          Width = 91
          Height = 24
          Alignment = taCenter
          TabOrder = 3
          OnExit = edStrikeExit
        end
        object cboDay: TRzComboBox
          Left = 144
          Top = 32
          Width = 40
          Height = 24
          TabOrder = 2
          OnChange = cboDayChange
        end
        object cboMonth: TRzComboBox
          Left = 86
          Top = 32
          Width = 53
          Height = 24
          TabOrder = 1
          OnChange = cboMonthChange
          Items.Strings = (
            'JAN'
            'FEB'
            'MAR'
            'APR'
            'MAY'
            'JUN'
            'JUL'
            'AUG'
            'SEP'
            'OCT'
            'NOV'
            'DEC')
        end
        object cboYear: TRzComboBox
          Left = 21
          Top = 32
          Width = 59
          Height = 24
          TabOrder = 0
          OnChange = cboYearChange
        end
        object cboDayOfWeek: TRzComboBox
          Left = 130
          Top = 0
          Width = 53
          Height = 24
          TabOrder = 5
          OnChange = cboDayOfWeekChange
          Items.Strings = (
            'JAN'
            'FEB'
            'MAR'
            'APR'
            'MAY'
            'JUN'
            'JUL'
            'AUG'
            'SEP'
            'OCT'
            'NOV'
            'DEC')
        end
      end
      object btnAdd: TRzButton
        Left = 92
        Top = 192
        Width = 100
        Height = 36
        Default = True
        Caption = 'Add to List'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        TabStop = False
        OnClick = btnAddClick
      end
      object bntRemove: TRzButton
        Left = 62
        Top = 144
        Width = 130
        Height = 36
        Default = True
        Caption = 'Remove from List'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        TabStop = False
        OnClick = bntRemoveClick
      end
    end
    object pnlGrid: TPanel
      Left = 20
      Top = 20
      Width = 648
      Height = 233
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 2
      object cxGrid1: TcxGrid
        AlignWithMargins = True
        Left = 0
        Top = 0
        Width = 628
        Height = 233
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 20
        Margins.Bottom = 0
        Align = alClient
        BevelEdges = []
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = cxcbsNone
        Constraints.MaxWidth = 650
        Constraints.MinWidth = 150
        TabOrder = 0
        TabStop = False
        LookAndFeel.Kind = lfStandard
        LookAndFeel.NativeStyle = False
        RootLevelOptions.DetailFrameWidth = 1
        object cxGrid1TableView1: TcxGridTableView
          Navigator.Buttons.CustomButtons = <>
          Navigator.Buttons.First.Visible = False
          Navigator.Buttons.PriorPage.Visible = False
          Navigator.Buttons.Prior.Visible = False
          Navigator.Buttons.Next.Visible = False
          Navigator.Buttons.NextPage.Visible = False
          Navigator.Buttons.Last.Visible = False
          Navigator.Buttons.Insert.Visible = False
          Navigator.Buttons.Append.Hint = 'Add Record'
          Navigator.Buttons.Append.Visible = True
          Navigator.Buttons.Delete.Hint = 'Delete Record'
          Navigator.Buttons.Delete.Visible = True
          Navigator.Buttons.Edit.Hint = 'Edit REcord'
          Navigator.Buttons.Edit.Visible = True
          Navigator.Buttons.Post.Enabled = False
          Navigator.Buttons.Post.Visible = False
          Navigator.Buttons.Cancel.Visible = False
          Navigator.Buttons.Refresh.Enabled = False
          Navigator.Buttons.Refresh.Visible = False
          Navigator.Buttons.SaveBookmark.Enabled = False
          Navigator.Buttons.SaveBookmark.Visible = False
          Navigator.Buttons.GotoBookmark.Enabled = False
          Navigator.Buttons.GotoBookmark.Visible = False
          Navigator.Buttons.Filter.Visible = False
          Navigator.InfoPanel.Visible = True
          FilterBox.CustomizeDialog = False
          FilterBox.Visible = fvNever
          DataController.Filter.PercentWildcard = '*'
          DataController.Options = []
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <
            item
            end>
          DataController.Summary.SummaryGroups = <>
          Filtering.MRUItemsList = False
          Filtering.ColumnFilteredItemsList = True
          Filtering.ColumnMRUItemsList = False
          Filtering.ColumnPopup.ApplyMultiSelectChanges = fpacOnButtonClick
          NewItemRow.InfoText = 'Click here to add a new Record'
          OptionsBehavior.AlwaysShowEditor = True
          OptionsBehavior.DragHighlighting = False
          OptionsBehavior.DragOpening = False
          OptionsBehavior.DragScrolling = False
          OptionsBehavior.FocusCellOnTab = True
          OptionsBehavior.FocusFirstCellOnNewRecord = True
          OptionsBehavior.IncSearchItem = colTicker
          OptionsBehavior.NavigatorHints = True
          OptionsBehavior.ColumnHeaderHints = False
          OptionsBehavior.ExpandMasterRowOnDblClick = False
          OptionsCustomize.ColumnFiltering = False
          OptionsCustomize.ColumnGrouping = False
          OptionsCustomize.ColumnHidingOnGrouping = False
          OptionsCustomize.ColumnMoving = False
          OptionsData.CancelOnExit = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsData.Inserting = False
          OptionsSelection.CellSelect = False
          OptionsSelection.HideFocusRectOnExit = False
          OptionsSelection.InvertSelect = False
          OptionsView.FocusRect = False
          OptionsView.NavigatorOffset = 600
          OptionsView.ScrollBars = ssVertical
          OptionsView.ShowEditButtons = gsebForFocusedRecord
          OptionsView.ColumnAutoWidth = True
          OptionsView.ExpandButtonsForEmptyDetails = False
          OptionsView.GridLineColor = clSilver
          OptionsView.GroupByBox = False
          OptionsView.GroupFooters = gfVisibleWhenExpanded
          OptionsView.ShowColumnFilterButtons = sfbAlways
          object colDate: TcxGridColumn
            Caption = 'Date'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.ImmediatePost = True
            Properties.ValidateOnEnter = False
            Properties.OnInitPopup = colDatePropertiesInitPopup
            Properties.OnValidate = colDatePropertiesValidate
            MinWidth = 100
            Width = 100
          end
          object colOC: TcxGridColumn
            Caption = 'O/C'
            PropertiesClassName = 'TcxTextEditProperties'
            Properties.Alignment.Horz = taCenter
            HeaderAlignmentHorz = taCenter
            MinWidth = 40
            Options.Editing = False
            Width = 40
          end
          object colLS: TcxGridColumn
            Caption = 'L/S'
            PropertiesClassName = 'TcxTextEditProperties'
            Properties.Alignment.Horz = taCenter
            HeaderAlignmentHorz = taCenter
            MinWidth = 40
            Width = 40
          end
          object colTicker: TcxGridColumn
            Caption = 'Ticker'
            PropertiesClassName = 'TcxTextEditProperties'
            Properties.CharCase = ecUpperCase
            Properties.MaxLength = 40
            MinWidth = 75
            Width = 174
          end
          object colShares: TcxGridColumn
            Caption = 'Sh/Contr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.Alignment.Horz = taCenter
            Properties.DecimalPlaces = 5
            Properties.DisplayFormat = '0.#####'
            Properties.EditFormat = '0.#####'
            HeaderAlignmentHorz = taCenter
            MinWidth = 50
            Options.Editing = False
            Width = 89
          end
          object colPrice: TcxGridColumn
            Caption = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 6
            Properties.DisplayFormat = ',0.######;(,0.######)'
            Properties.EditFormat = ',0.######;(,0.######)'
            Properties.OnEditValueChanged = colPricePropertiesEditValueChanged
            Properties.OnValidate = colPricePropertiesValidate
          end
          object colTypeMult: TcxGridColumn
            Caption = 'Type/Mult'
            PropertiesClassName = 'TcxTextEditProperties'
            Properties.Alignment.Horz = taCenter
            HeaderAlignmentHorz = taCenter
            MinWidth = 50
            Options.Editing = False
            Options.SortByDisplayText = isbtOn
            Width = 85
          end
          object colComm: TcxGridColumn
            Caption = 'Comm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.DisplayFormat = True
            Properties.UseThousandSeparator = True
            Properties.OnEditValueChanged = colCommPropertiesEditValueChanged
            Properties.OnValidate = colCommPropertiesValidate
            MinWidth = 50
          end
          object colAmt: TcxGridColumn
            Caption = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.OnEditValueChanged = colAmtPropertiesEditValueChanged
            Properties.OnValidate = colAmtPropertiesValidate
            MinWidth = 100
            Width = 100
          end
        end
        object cxGrid1Level1: TcxGridLevel
          GridView = cxGrid1TableView1
          Options.DetailFrameColor = clScrollBar
        end
      end
    end
  end
  object pnlTitle: TPanel
    Left = 0
    Top = 0
    Width = 1107
    Height = 45
    Align = alTop
    BevelEdges = []
    BevelKind = bkFlat
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 1
    object pnlTitleLeft: TPanel
      Left = 0
      Top = 0
      Width = 569
      Height = 41
      BevelOuter = bvNone
      TabOrder = 1
      object lblTitle: TLabel
        AlignWithMargins = True
        Left = 10
        Top = 5
        Width = 556
        Height = 33
        Margins.Left = 10
        Margins.Top = 5
        Align = alClient
        AutoSize = False
        Caption = 'Baseline Positions Wizard'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -24
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
    end
    object pnlClose: TPanel
      Left = 957
      Top = 0
      Width = 150
      Height = 45
      Align = alRight
      Alignment = taRightJustify
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      object btnClose: TRzButton
        Left = 55
        Top = 14
        Cancel = True
        Caption = 'Exit'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        TabStop = False
        OnClick = btnCloseClick
      end
    end
  end
  object pnlLastNext: TPanel
    Left = 0
    Top = 844
    Width = 1107
    Height = 45
    Align = alBottom
    BevelEdges = [beBottom]
    BevelKind = bkFlat
    BevelOuter = bvNone
    Constraints.MinHeight = 45
    ParentBackground = False
    TabOrder = 2
    Visible = False
    object pnlStep4right: TPanel
      AlignWithMargins = True
      Left = 920
      Top = 0
      Width = 167
      Height = 43
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 20
      Margins.Bottom = 0
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object btnNext: TRzButton
        Left = 92
        Top = 10
        Margins.Top = 6
        Margins.Bottom = 6
        Caption = 'Next'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = True
        ParentFont = False
        TabOrder = 0
        TabStop = False
        OnClick = btnNextClick
      end
      object btnLast: TRzButton
        Left = 0
        Top = 10
        Margins.Top = 6
        Margins.Bottom = 6
        Caption = 'Previous'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = True
        ParentFont = False
        TabOrder = 1
        TabStop = False
        OnClick = btnLastClick
      end
    end
  end
  object pnlStep4: TPanel
    Left = 0
    Top = 389
    Width = 950
    Height = 172
    Margins.Left = 0
    Margins.Right = 0
    Margins.Bottom = 0
    AutoSize = True
    BevelEdges = [beBottom]
    BevelOuter = bvNone
    TabOrder = 5
    Visible = False
    object pnlFinish: TPanel
      Left = 800
      Top = 0
      Width = 150
      Height = 172
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object btnFind: TRzButton
        Left = 32
        Top = 10
        Width = 100
        Height = 36
        Default = True
        Caption = 'Find'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        TabStop = False
        OnClick = btnFindClick
      end
    end
    object Panel2: TPanel
      AlignWithMargins = True
      Left = 0
      Top = 0
      Width = 800
      Height = 152
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 20
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object pnl4Instr3: TRzPanel
        AlignWithMargins = True
        Left = 10
        Top = 110
        Width = 790
        Height = 40
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        AutoSize = True
        BorderOuter = fsNone
        Color = clWhite
        Padding.Right = 10
        TabOrder = 0
        object RzLabel18: TRzLabel
          AlignWithMargins = True
          Left = 0
          Top = 10
          Width = 676
          Height = 18
          Margins.Left = 0
          Margins.Top = 10
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alClient
          Caption = 
            'Please click the "Find" button to have TradeLog automatically fi' +
            'nd and enter your open position records.'
          Color = clWhite
          ParentColor = False
          WordWrap = True
          BlinkIntervalOff = 100
          BlinkIntervalOn = 100
        end
      end
      object pnl4Instr2: TRzPanel
        AlignWithMargins = True
        Left = 10
        Top = 60
        Width = 790
        Height = 40
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        AutoSize = True
        BorderOuter = fsNone
        Color = clWhite
        Padding.Right = 10
        TabOrder = 1
        object RzLabel20: TRzLabel
          Left = 15
          Top = 0
          Width = 765
          Height = 40
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alClient
          AutoSize = False
          Caption = 
            'This list will be used to find your actual open position trades ' +
            'from the downloaded trade history, and these will be entered int' +
            'o the main TradeLog record grid. '
          Color = clWhite
          ParentColor = False
          WordWrap = True
          BlinkIntervalOff = 100
          BlinkIntervalOn = 100
          ExplicitWidth = 764
        end
        object RzLabel21: TRzLabel
          Left = 0
          Top = 0
          Width = 15
          Height = 40
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alLeft
          AutoSize = False
          Caption = #8226
          Color = clWhite
          ParentColor = False
          BlinkIntervalOff = 100
          BlinkIntervalOn = 100
        end
      end
      object pnl4Instr1: TRzPanel
        AlignWithMargins = True
        Left = 10
        Top = 10
        Width = 790
        Height = 40
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        AutoSize = True
        BorderOuter = fsNone
        Color = clWhite
        Padding.Right = 10
        TabOrder = 2
        object RzLabel22: TRzLabel
          Left = 15
          Top = 0
          Width = 643
          Height = 18
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alClient
          Caption = 
            'The list below should now be an accurate list of your positions ' +
            'carried open at the end of last year.'
          Color = clWhite
          ParentColor = False
          WordWrap = True
          BlinkIntervalOff = 100
          BlinkIntervalOn = 100
        end
        object RzLabel23: TRzLabel
          Left = 0
          Top = 0
          Width = 15
          Height = 40
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alLeft
          AutoSize = False
          Caption = #8226
          Color = clWhite
          ParentColor = False
          BlinkIntervalOff = 100
          BlinkIntervalOn = 100
          ExplicitHeight = 39
        end
      end
    end
  end
  object pnlStepx: TPanel
    Left = 0
    Top = 45
    Width = 1107
    Height = 50
    Align = alTop
    BevelEdges = [beBottom]
    BevelOuter = bvNone
    TabOrder = 7
    object lblStepa: TRzLabel
      AlignWithMargins = True
      Left = 160
      Top = 20
      Width = 236
      Height = 20
      Margins.Left = 0
      Margins.Top = 20
      Margins.Right = 0
      Margins.Bottom = 2
      Align = alLeft
      Caption = 'Holdings as of December 31, '
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      BlinkIntervalOff = 100
      BlinkIntervalOn = 100
      BorderSides = [sdBottom]
      BorderColor = clBtnShadow
      BorderWidth = 1
    end
    object lblStep: TRzLabel
      AlignWithMargins = True
      Left = 10
      Top = 20
      Width = 150
      Height = 20
      Margins.Left = 10
      Margins.Top = 20
      Margins.Right = 0
      Margins.Bottom = 2
      Align = alLeft
      Caption = 'STEP 1: Check for '
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      BlinkIntervalOff = 100
      BlinkIntervalOn = 100
      BorderSides = [sdBottom]
      BorderColor = clBtnShadow
      BorderWidth = 1
    end
    object lblLastYear: TRzLabel
      AlignWithMargins = True
      Left = 396
      Top = 20
      Width = 52
      Height = 28
      Margins.Left = 0
      Margins.Top = 20
      Margins.Right = 0
      Margins.Bottom = 2
      Align = alLeft
      AutoSize = False
      Caption = '2013'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      BlinkIntervalOff = 100
      BlinkIntervalOn = 100
      BorderSides = [sdBottom]
      BorderColor = clBtnShadow
      BorderWidth = 1
      ExplicitLeft = 400
    end
  end
  object pnlStep2: TPanel
    Left = 5
    Top = 221
    Width = 950
    Height = 160
    Margins.Left = 0
    Margins.Right = 0
    Margins.Bottom = 0
    AutoSize = True
    BevelEdges = [beBottom]
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 4
    Visible = False
    object pnl2Instr2: TRzPanel
      AlignWithMargins = True
      Left = 10
      Top = 60
      Width = 940
      Height = 40
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alTop
      AutoSize = True
      BorderOuter = fsNone
      Color = clWhite
      Padding.Right = 10
      TabOrder = 0
      object RzLabel1: TRzLabel
        Left = 15
        Top = 0
        Width = 915
        Height = 40
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alClient
        AutoSize = False
        Caption = 
          'Click the "Add to List" button to add each position to the list ' +
          'of holdings. The final list should match the list of holdings in' +
          ' the statement. '
        Color = clWhite
        ParentColor = False
        WordWrap = True
        BlinkIntervalOff = 100
        BlinkIntervalOn = 100
        ExplicitWidth = 914
      end
      object RzLabel9: TRzLabel
        Left = 0
        Top = 0
        Width = 15
        Height = 40
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alLeft
        AutoSize = False
        Caption = #8226
        Color = clWhite
        ParentColor = False
        BlinkIntervalOff = 100
        BlinkIntervalOn = 100
      end
    end
    object pnl2Instr3: TRzPanel
      AlignWithMargins = True
      Left = 10
      Top = 110
      Width = 940
      Height = 40
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 0
      Margins.Bottom = 10
      Align = alTop
      AutoSize = True
      BorderOuter = fsNone
      Color = clWhite
      Padding.Right = 10
      TabOrder = 1
      object RzLabel10: TRzLabel
        AlignWithMargins = True
        Left = 0
        Top = 0
        Width = 930
        Height = 40
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 
          'When finished, click the "Next" button at the bottom to continue' +
          ' to "Step 3: Accounting for Trades Pending Settlement."'
        Color = clWhite
        ParentColor = False
        WordWrap = True
        BlinkIntervalOff = 100
        BlinkIntervalOn = 100
        ExplicitWidth = 929
      end
    end
    object pnl2Instr1: TRzPanel
      AlignWithMargins = True
      Left = 10
      Top = 10
      Width = 940
      Height = 40
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alTop
      BorderOuter = fsNone
      Color = clWhite
      Padding.Right = 10
      TabOrder = 2
      object RzLabel11: TRzLabel
        Left = 15
        Top = 0
        Width = 892
        Height = 18
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alClient
        Caption = 
          'Enter the details for each position listed in the "Holdings as o' +
          'f December 31" section of your brokerage statement using the fie' +
          'lds below. '
        Color = clWhite
        ParentColor = False
        WordWrap = True
        BlinkIntervalOff = 100
        BlinkIntervalOn = 100
      end
      object RzLabel13: TRzLabel
        Left = 0
        Top = 0
        Width = 15
        Height = 40
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alLeft
        AutoSize = False
        Caption = #8226
        Color = clWhite
        ParentColor = False
        BlinkIntervalOff = 100
        BlinkIntervalOn = 100
        ExplicitHeight = 39
      end
    end
  end
  object tmrTickFocus: TTimer
    Enabled = False
    OnTimer = tmrTickFocusTimer
    Left = 748
    Top = 1600
  end
end
