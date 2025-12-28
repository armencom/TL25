object frmUnderlying: TfrmUnderlying
  Left = 312
  Top = 110
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'frmUnderlying'
  ClientHeight = 272
  ClientWidth = 394
  Color = clBtnFace
  DefaultMonitor = dmMainForm
  DragKind = dkDock
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object cxTicks: TcxGrid
    AlignWithMargins = True
    Left = 10
    Top = 94
    Width = 374
    Height = 127
    Margins.Left = 10
    Margins.Top = 0
    Margins.Right = 10
    Margins.Bottom = 0
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    LookAndFeel.Kind = lfFlat
    RootLevelOptions.DetailFrameColor = clWindowFrame
    object cxTicksTable: TcxGridTableView
      Navigator.Buttons.CustomButtons = <>
      OnCellClick = cxTicksTableCellClick
      OnCustomDrawCell = cxTicksTableCustomDrawCell
      DataController.Options = [dcoImmediatePost]
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      DataController.Summary.Options = [soSelectedRecords]
      OptionsBehavior.ImmediateEditor = False
      OptionsBehavior.ExpandMasterRowOnDblClick = False
      OptionsCustomize.ColumnFiltering = False
      OptionsCustomize.ColumnGrouping = False
      OptionsCustomize.ColumnHidingOnGrouping = False
      OptionsCustomize.ColumnMoving = False
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsView.ScrollBars = ssVertical
      OptionsView.ShowEditButtons = gsebForFocusedRecord
      OptionsView.ColumnAutoWidth = True
      OptionsView.DataRowHeight = 18
      OptionsView.GroupByBox = False
      object cxDescr: TcxGridColumn
        Caption = 'Description:'
        MinWidth = 250
        Options.Editing = False
        Options.Filtering = False
        Options.Focusing = False
        Options.IncSearch = False
        Options.Grouping = False
        Options.Moving = False
        Options.Sorting = False
        SortIndex = 0
        SortOrder = soAscending
        Width = 250
      end
      object cxTick: TcxGridColumn
        Caption = 'Ticker Symbol:'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taCenter
        Properties.AutoSelect = False
        HeaderAlignmentHorz = taCenter
        MinWidth = 122
        Options.Editing = False
        Options.Filtering = False
        Options.Focusing = False
        Options.IncSearch = False
        Options.ShowEditButtons = isebAlways
        Options.Grouping = False
        Options.Moving = False
        Options.Sorting = False
        Width = 122
      end
    end
    object cxTicksLevel1: TcxGridLevel
      GridView = cxTicksTable
    end
  end
  object pnlInstr: TPanel
    Left = 0
    Top = 0
    Width = 394
    Height = 50
    Align = alTop
    AutoSize = True
    BevelEdges = []
    BevelKind = bkFlat
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 1
    object lblInstr: TLabel
      AlignWithMargins = True
      Left = 10
      Top = 10
      Width = 334
      Height = 16
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 4
      Align = alTop
      Caption = 'Please enter the correct stock symbol from the list below:'
      WordWrap = True
    end
    object lblInstr2: TLabel
      AlignWithMargins = True
      Left = 10
      Top = 30
      Width = 203
      Height = 16
      Margins.Left = 10
      Margins.Top = 0
      Margins.Right = 10
      Margins.Bottom = 4
      Align = alTop
      Caption = 'Click on a line to change the ticker.'
      Visible = False
      WordWrap = True
    end
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 221
    Width = 394
    Height = 51
    Align = alBottom
    BevelEdges = [beTop]
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 2
    object btnCancel: TButton
      Left = 150
      Top = 18
      Width = 75
      Height = 25
      Hint = 'Cancels the entire routine'
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 0
      OnClick = btnCancelClick
    end
    object btnOK: TButton
      Left = 309
      Top = 18
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 1
    end
  end
  object pnlDescTick: TPanel
    Left = 0
    Top = 50
    Width = 394
    Height = 44
    Align = alTop
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 3
    object lblDesc: TLabel
      AlignWithMargins = True
      Left = 14
      Top = 22
      Width = 65
      Height = 13
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Caption = 'Description'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label1: TLabel
      Left = 171
      Top = 0
      Width = 100
      Height = 13
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Alignment = taCenter
      AutoSize = False
      Caption = 'Ticker Symbol:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object edTick: TEdit
      Left = 284
      Top = 0
      Width = 100
      Height = 21
      Alignment = taCenter
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnChange = edTickChange
    end
  end
  object cxStyleRepository1: TcxStyleRepository
    Left = 62
    Top = 172
    PixelsPerInch = 96
  end
end
