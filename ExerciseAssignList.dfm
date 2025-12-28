object frmExerciseAssign: TfrmExerciseAssign
  Left = 1
  Top = 1
  Caption = 'Options to Exercise and Assign'
  ClientHeight = 323
  ClientWidth = 821
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 821
    Height = 323
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object pnlButtons: TPanel
      Left = 640
      Top = 0
      Width = 181
      Height = 323
      Align = alRight
      AutoSize = True
      BevelEdges = [beLeft, beBottom]
      BevelKind = bkFlat
      BevelOuter = bvNone
      Color = clInfoBk
      ParentBackground = False
      TabOrder = 0
      object lblNotes: TLabel
        AlignWithMargins = True
        Left = 14
        Top = 85
        Width = 162
        Height = 15
        Margins.Left = 14
        Margins.Top = 5
        Align = alTop
        Caption = 'Notes:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        ExplicitWidth = 41
      end
      object pnlBtns: TPanel
        Left = 0
        Top = 0
        Width = 179
        Height = 42
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 10
        Margins.Bottom = 5
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentBackground = False
        TabOrder = 0
        object btnExercise: TcxButton
          AlignWithMargins = True
          Left = 10
          Top = 10
          Width = 50
          Height = 27
          Margins.Left = 10
          Margins.Top = 10
          Margins.Right = 5
          Margins.Bottom = 5
          Align = alLeft
          Caption = 'Exercise'
          Default = True
          Enabled = False
          LookAndFeel.Kind = lfOffice11
          TabOrder = 0
          Font.Charset = ANSI_CHARSET
          Font.Color = clBtnText
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
          OnClick = btnExerciseClick
        end
        object btnClose: TcxButton
          AlignWithMargins = True
          Left = 119
          Top = 10
          Width = 50
          Height = 27
          Margins.Left = 5
          Margins.Top = 10
          Margins.Right = 10
          Margins.Bottom = 5
          Align = alRight
          Cancel = True
          Caption = 'Close'
          LookAndFeel.Kind = lfOffice11
          TabOrder = 1
          Font.Charset = ANSI_CHARSET
          Font.Color = clBtnText
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
          OnClick = btnCloseClick
        end
        object btnSkip: TcxButton
          AlignWithMargins = True
          Left = 65
          Top = 10
          Width = 49
          Height = 27
          Hint = 'mark a stock as not from an exercised option'
          Margins.Left = 0
          Margins.Top = 10
          Margins.Right = 0
          Margins.Bottom = 5
          Align = alClient
          Caption = 'Skip'
          TabOrder = 2
          OnClick = btnSkipClick
        end
      end
      object pnlNotes: TPanel
        AlignWithMargins = True
        Left = 10
        Top = 103
        Width = 159
        Height = 124
        Margins.Left = 10
        Margins.Top = 0
        Margins.Right = 10
        Margins.Bottom = 10
        Align = alClient
        AutoSize = True
        BevelOuter = bvNone
        ParentBackground = False
        ParentColor = True
        TabOrder = 1
        object lblSkip: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 35
          Width = 153
          Height = 39
          Align = alTop
          Caption = 
            'Or select a record in the grid above and click the Skip button t' +
            'o skip the record.'
          WordWrap = True
          ExplicitWidth = 151
        end
        object lblExercise: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 153
          Height = 26
          Align = alTop
          Caption = 'Click the Exercise button to exercise.'
          WordWrap = True
          ExplicitWidth = 132
        end
      end
      object pnlWarn: TPanel
        AlignWithMargins = True
        Left = 0
        Top = 242
        Width = 179
        Height = 79
        Margins.Left = 0
        Margins.Top = 5
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alBottom
        AutoSize = True
        BevelOuter = bvNone
        Color = clYellow
        ParentBackground = False
        TabOrder = 2
        Visible = False
        object Label2: TLabel
          AlignWithMargins = True
          Left = 10
          Top = 10
          Width = 166
          Height = 16
          Margins.Left = 10
          Margins.Top = 10
          Align = alTop
          Caption = 'DIRECTIONS:'
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          Transparent = True
          ExplicitWidth = 96
        end
        object lblText: TLabel
          AlignWithMargins = True
          Left = 10
          Top = 29
          Width = 159
          Height = 40
          Margins.Left = 10
          Margins.Top = 0
          Margins.Right = 10
          Margins.Bottom = 10
          Align = alTop
          BiDiMode = bdLeftToRight
          Caption = 'notes . . .'
          Color = clBtnFace
          Constraints.MinHeight = 40
          Constraints.MinWidth = 100
          ParentBiDiMode = False
          ParentColor = False
          Transparent = True
          WordWrap = True
          ExplicitWidth = 100
        end
      end
      object pnlAutoEx: TPanel
        Left = 0
        Top = 42
        Width = 179
        Height = 38
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 10
        Margins.Bottom = 10
        Align = alTop
        AutoSize = True
        BevelEdges = [beBottom]
        BevelKind = bkFlat
        BevelOuter = bvNone
        ParentBackground = False
        TabOrder = 3
        object Label1: TLabel
          AlignWithMargins = True
          Left = 30
          Top = 3
          Width = 146
          Height = 30
          Align = alClient
          Caption = 'Automatically Exercise as many as possible'
          WordWrap = True
          ExplicitWidth = 122
          ExplicitHeight = 26
        end
        object pnlCB: TPanel
          AlignWithMargins = True
          Left = 10
          Top = 3
          Width = 14
          Height = 30
          Margins.Left = 10
          Align = alLeft
          AutoSize = True
          BevelOuter = bvNone
          TabOrder = 0
          object cbAutoEx: TCheckBox
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 11
            Height = 14
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alTop
            TabOrder = 0
          end
        end
      end
    end
    object pnlLeft: TPanel
      Left = 0
      Top = 0
      Width = 640
      Height = 323
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object pnlTop: TPanel
        Left = 0
        Top = 0
        Width = 640
        Height = 52
        Align = alTop
        AutoSize = True
        BevelEdges = []
        BevelKind = bkFlat
        BevelOuter = bvNone
        TabOrder = 0
        object Label4: TLabel
          AlignWithMargins = True
          Left = 8
          Top = 5
          Width = 624
          Height = 44
          Margins.Left = 8
          Margins.Top = 5
          Margins.Right = 8
          Align = alClient
          Caption = 
            'TradeLog discovered the following options which can now be exerc' +
            'ised. Please select an option record below. This will isolate th' +
            'e corresponding stock and option records in the grid above. Then' +
            ' click the Exercise button to the right. '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
          ExplicitWidth = 623
          ExplicitHeight = 45
        end
      end
      object cxGrid1: TcxGrid
        Left = 0
        Top = 52
        Width = 640
        Height = 271
        Align = alClient
        BevelEdges = [beBottom]
        BevelInner = bvNone
        BevelOuter = bvNone
        BevelKind = bkFlat
        TabOrder = 1
        object cxGrid1TableView1: TcxGridTableView
          Navigator.Buttons.CustomButtons = <>
          OnFocusedRecordChanged = cxGrid1TableView1FocusedRecordChanged
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsCustomize.ColumnFiltering = False
          OptionsCustomize.ColumnGrouping = False
          OptionsCustomize.ColumnHidingOnGrouping = False
          OptionsCustomize.ColumnMoving = False
          OptionsCustomize.ColumnSorting = False
          OptionsCustomize.DataRowSizing = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsData.Inserting = False
          OptionsSelection.CellSelect = False
          OptionsSelection.HideFocusRectOnExit = False
          OptionsSelection.InvertSelect = False
          OptionsSelection.UnselectFocusedRecordOnExit = False
          OptionsView.ColumnAutoWidth = True
          OptionsView.GroupByBox = False
          Styles.Background = cxStyle1
          Styles.ContentEven = cxStyle3
          Styles.ContentOdd = cxStyle4
          Styles.Selection = cxStyle1
          Styles.Header = cxStyle1
          object cxGrid1TableView1_Desc: TcxGridColumn
            Caption = 'Description'
            Visible = False
          end
          object cxGrid1TableView1_TrNum: TcxGridDBColumn
            Caption = 'TrNum'
            DataBinding.ValueType = 'Integer'
            PropertiesClassName = 'TcxTextEditProperties'
            Properties.MaxLength = 0
            Properties.ReadOnly = True
            MinWidth = 40
            SortIndex = 1
            SortOrder = soAscending
            Width = 40
          end
          object cxGrid1TableView1_Date: TcxGridDBColumn
            Caption = 'Date'
            DataBinding.ValueType = 'DateTime'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.ReadOnly = True
            Properties.ShowTime = False
            MinWidth = 84
            Width = 86
          end
          object cxGrid1TableView1_OpenClose: TcxGridDBColumn
            Caption = 'O/C'
            PropertiesClassName = 'TcxTextEditProperties'
            Properties.Alignment.Horz = taCenter
            Properties.MaxLength = 1
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            MinWidth = 40
            Width = 40
          end
          object cxGrid1TableView1_LongShort: TcxGridDBColumn
            Caption = 'L/S'
            PropertiesClassName = 'TcxTextEditProperties'
            Properties.Alignment.Horz = taCenter
            Properties.MaxLength = 1
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            MinWidth = 40
            Width = 40
          end
          object cxGrid1TableView1_Ticker: TcxGridDBColumn
            Caption = 'Ticker'
            PropertiesClassName = 'TcxTextEditProperties'
            Properties.ReadOnly = True
            MinWidth = 150
            SortIndex = 0
            SortOrder = soAscending
            Width = 439
          end
          object cxGrid1TableView1_Contracts: TcxGridDBColumn
            Caption = 'Contracts'
            DataBinding.ValueType = 'Float'
            PropertiesClassName = 'TcxTextEditProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Alignment.Vert = taVCenter
            Properties.MaxLength = 0
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            MinWidth = 50
            Width = 79
          end
          object cxGrid1TableView1_StrikePrice: TcxGridDBColumn
            Caption = 'Price'
            DataBinding.ValueType = 'Currency'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.Alignment.Horz = taCenter
            Properties.MaxLength = 0
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            MinWidth = 50
            Width = 50
          end
          object cxGrid1TableView1_Type: TcxGridDBColumn
            Caption = 'Type/Mult'
            PropertiesClassName = 'TcxTextEditProperties'
            Properties.Alignment.Horz = taCenter
            Properties.MaxLength = 0
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            MinWidth = 70
            Width = 70
          end
          object cxGrid1TableView1_ExpireDate: TcxGridDBColumn
            Caption = 'Expire Date'
            DataBinding.ValueType = 'DateTime'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.ReadOnly = True
            Properties.ShowTime = False
            Visible = False
            Width = 79
          end
          object cxGrid1TableView1_Expired: TcxGridDBColumn
            Caption = 'Expired'
            DataBinding.ValueType = 'Boolean'
            PropertiesClassName = 'TcxCheckBoxProperties'
            Properties.ReadOnly = True
            Visible = False
            Width = 46
          end
        end
        object cxGrid1TableView2: TcxGridTableView
          Navigator.Buttons.CustomButtons = <>
          Navigator.Buttons.First.Visible = True
          Navigator.Buttons.PriorPage.Visible = True
          Navigator.Buttons.Prior.Visible = True
          Navigator.Buttons.Next.Visible = True
          Navigator.Buttons.NextPage.Visible = True
          Navigator.Buttons.Last.Visible = True
          Navigator.Buttons.Insert.Visible = True
          Navigator.Buttons.Append.Visible = False
          Navigator.Buttons.Delete.Visible = True
          Navigator.Buttons.Edit.Visible = True
          Navigator.Buttons.Post.Visible = True
          Navigator.Buttons.Cancel.Visible = True
          Navigator.Buttons.Refresh.Visible = True
          Navigator.Buttons.SaveBookmark.Visible = True
          Navigator.Buttons.GotoBookmark.Visible = True
          Navigator.Buttons.Filter.Visible = True
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsCustomize.ColumnFiltering = False
          OptionsCustomize.ColumnGrouping = False
          OptionsCustomize.ColumnHidingOnGrouping = False
          OptionsCustomize.ColumnMoving = False
          OptionsCustomize.ColumnSorting = False
          OptionsCustomize.DataRowSizing = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsData.Inserting = False
          OptionsSelection.CellSelect = False
          OptionsSelection.HideFocusRectOnExit = False
          OptionsSelection.InvertSelect = False
          OptionsSelection.UnselectFocusedRecordOnExit = False
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.Header = False
          Styles.Background = cxStyle1
          Styles.Content = cxStyle3
          Styles.Selection = cxStyle3
          object cxGrid1TableView2_Desc: TcxGridColumn
            Caption = 'Description'
            Visible = False
          end
          object cxGrid1TableView2_IT: TcxGridColumn
            Caption = 'Item'
            DataBinding.ValueType = 'Integer'
            Visible = False
            Options.Editing = False
          end
          object cxGrid1TableView2_TrNum: TcxGridColumn
            Caption = 'TrNum'
            DataBinding.ValueType = 'Integer'
            Options.Editing = False
          end
          object cxGrid1TableView2_Date: TcxGridColumn
            Caption = 'Date'
            Options.Editing = False
          end
          object cxGrid1TableView2_OC: TcxGridColumn
            Caption = 'O/C'
            Options.Editing = False
          end
          object cxGrid1TableView2_LS: TcxGridColumn
            Caption = 'L/S'
            Options.Editing = False
          end
          object cxGrid1TableView2_Ticker: TcxGridColumn
            Caption = 'Ticker'
            Options.Editing = False
          end
          object cxGrid1TableView2_Shares: TcxGridColumn
            Caption = 'Shares'
            Options.Editing = False
          end
          object cxGrid1TableView2_Price: TcxGridColumn
            Caption = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Options.Editing = False
          end
          object cxGrid1TableView2_Type: TcxGridColumn
            Caption = 'Type/Mult'
            Options.Editing = False
          end
          object cxGrid1TableView2_Commission: TcxGridColumn
            Caption = 'Comm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Visible = False
            Options.Editing = False
          end
          object cxGrid1TableView2_Amount: TcxGridColumn
            Caption = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Visible = False
            Options.Editing = False
          end
          object cxGrid1TableView2_Notes: TcxGridColumn
            Caption = 'Noted'
            Visible = False
            Options.Editing = False
          end
          object cxGrid1TableView2_Strategy: TcxGridColumn
            Caption = 'Strategy'
            Visible = False
            Options.Editing = False
          end
        end
        object cxGrid1Level1: TcxGridLevel
          GridView = cxGrid1TableView1
        end
      end
    end
  end
  object cxStyleRepository1: TcxStyleRepository
    Left = 72
    Top = 112
    PixelsPerInch = 96
    object cxStyle1: TcxStyle
      AssignedValues = [svColor, svTextColor]
      Color = clBtnFace
      TextColor = clBlack
    end
    object cxStyle2: TcxStyle
      AssignedValues = [svColor]
      Color = clActiveBorder
    end
    object cxStyle3: TcxStyle
      AssignedValues = [svColor, svTextColor]
      Color = clWhite
      TextColor = clBlack
    end
    object cxStyle4: TcxStyle
      AssignedValues = [svColor]
      Color = clMoneyGreen
    end
    object cxStyle5: TcxStyle
      AssignedValues = [svColor]
      Color = clGradientInactiveCaption
    end
  end
end
