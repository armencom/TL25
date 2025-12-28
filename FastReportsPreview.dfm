object frmFastReports: TfrmFastReports
  Left = 1
  Top = 1
  Margins.Left = 0
  Margins.Top = 0
  Margins.Right = 0
  Margins.Bottom = 0
  Caption = 'Tradelog Report Preview'
  ClientHeight = 547
  ClientWidth = 801
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnMouseWheel = FormMouseWheel
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlMain: TPanel
    Left = 0
    Top = 115
    Width = 801
    Height = 432
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alClient
    BevelEdges = []
    BevelOuter = bvNone
    Caption = 'Report Cancelled.  Please wait...'
    Color = clWhite
    Ctl3D = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentBackground = False
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 0
    object pnlTotals: TPanel
      Left = 0
      Top = 314
      Width = 801
      Height = 104
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Align = alBottom
      BevelEdges = []
      BevelOuter = bvNone
      ParentBackground = False
      TabOrder = 0
      object cxGridRptTot: TcxGrid
        AlignWithMargins = True
        Left = 0
        Top = 27
        Width = 801
        Height = 77
        Margins.Left = 0
        Margins.Top = 4
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alClient
        BevelEdges = [beBottom]
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = cxcbsNone
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        LookAndFeel.Kind = lfUltraFlat
        LookAndFeel.NativeStyle = False
        RootLevelOptions.DetailFrameColor = clBtnFace
        object cxGridRptTotTableView: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          ScrollbarAnnotations.CustomAnnotations = <>
          OnCustomDrawCell = cxGridRptTotTableViewCustomDrawCell
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsBehavior.ImmediateEditor = False
          OptionsCustomize.ColumnFiltering = False
          OptionsCustomize.ColumnGrouping = False
          OptionsCustomize.ColumnHidingOnGrouping = False
          OptionsCustomize.ColumnMoving = False
          OptionsCustomize.ColumnSorting = False
          OptionsData.CancelOnExit = False
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsData.Inserting = False
          OptionsSelection.CellSelect = False
          OptionsSelection.HideFocusRectOnExit = False
          OptionsSelection.InvertSelect = False
          OptionsSelection.UnselectFocusedRecordOnExit = False
          OptionsView.FocusRect = False
          OptionsView.ColumnAutoWidth = True
          OptionsView.GridLineColor = clBtnFace
          OptionsView.GridLines = glNone
          OptionsView.GroupByBox = False
          OptionsView.Header = False
          OptionsView.RowSeparatorColor = clBtnFace
          Styles.Background = cxStyle2
          object STLT: TcxGridDBColumn
            PropertiesClassName = 'TcxTextEditProperties'
            Properties.Alignment.Horz = taRightJustify
            Properties.ReadOnly = False
            BestFitMaxWidth = 45
            HeaderAlignmentHorz = taRightJustify
            MinWidth = 30
            Options.Editing = False
            Options.Filtering = False
            Options.Focusing = False
            Options.IncSearch = False
            Options.FilteringMRUItemsList = False
            Options.ShowEditButtons = isebNever
            Options.Grouping = False
            Options.Moving = False
            Options.SortByDisplayText = isbtOff
            Options.Sorting = False
            Width = 30
            IsCaptionAssigned = True
          end
          object colSales: TcxGridDBColumn
            PropertiesClassName = 'TcxTextEditProperties'
            Properties.Alignment.Horz = taRightJustify
            BestFitMaxWidth = 30
            HeaderAlignmentHorz = taRightJustify
            MinWidth = 30
            Options.Editing = False
            Options.Filtering = False
            Options.Focusing = False
            Options.IncSearch = False
            Options.FilteringMRUItemsList = False
            Options.ShowEditButtons = isebNever
            Options.Grouping = False
            Options.Moving = False
            Options.SortByDisplayText = isbtOff
            Options.Sorting = False
            Width = 30
            IsCaptionAssigned = True
          end
          object colCost: TcxGridDBColumn
            PropertiesClassName = 'TcxTextEditProperties'
            Properties.Alignment.Horz = taRightJustify
            BestFitMaxWidth = 30
            HeaderAlignmentHorz = taRightJustify
            MinWidth = 30
            Options.Editing = False
            Options.Filtering = False
            Options.Focusing = False
            Options.IncSearch = False
            Options.FilteringMRUItemsList = False
            Options.ShowEditButtons = isebNever
            Options.Grouping = False
            Options.Moving = False
            Options.SortByDisplayText = isbtOff
            Options.Sorting = False
            Width = 30
            IsCaptionAssigned = True
          end
          object colAdjG: TcxGridDBColumn
            PropertiesClassName = 'TcxTextEditProperties'
            Properties.Alignment.Horz = taRightJustify
            BestFitMaxWidth = 30
            HeaderAlignmentHorz = taRightJustify
            MinWidth = 30
            Options.Editing = False
            Options.Filtering = False
            Options.Focusing = False
            Options.IncSearch = False
            Options.FilteringMRUItemsList = False
            Options.ShowEditButtons = isebNever
            Options.Grouping = False
            Options.Moving = False
            Options.SortByDisplayText = isbtOff
            Options.Sorting = False
            Width = 30
          end
          object colPL: TcxGridDBColumn
            PropertiesClassName = 'TcxTextEditProperties'
            Properties.Alignment.Horz = taRightJustify
            Properties.ReadOnly = False
            BestFitMaxWidth = 30
            HeaderAlignmentHorz = taRightJustify
            MinWidth = 30
            Options.Editing = False
            Options.Filtering = False
            Options.Focusing = False
            Options.IncSearch = False
            Options.FilteringMRUItemsList = False
            Options.ShowEditButtons = isebNever
            Options.Grouping = False
            Options.Moving = False
            Options.SortByDisplayText = isbtOff
            Options.Sorting = False
            Width = 30
            IsCaptionAssigned = True
          end
          object colWS: TcxGridDBColumn
            PropertiesClassName = 'TcxTextEditProperties'
            Properties.Alignment.Horz = taRightJustify
            Properties.ReadOnly = False
            BestFitMaxWidth = 30
            HeaderAlignmentHorz = taRightJustify
            MinWidth = 30
            Options.Editing = False
            Options.Filtering = False
            Options.Focusing = False
            Options.IncSearch = False
            Options.FilteringMRUItemsList = False
            Options.ShowEditButtons = isebNever
            Options.Grouping = False
            Options.Moving = False
            Options.SortByDisplayText = isbtOff
            Options.Sorting = False
            Width = 30
            IsCaptionAssigned = True
          end
          object colWSIRa: TcxGridDBColumn
            PropertiesClassName = 'TcxTextEditProperties'
            Properties.Alignment.Horz = taRightJustify
            Properties.ReadOnly = False
            BestFitMaxWidth = 30
            HeaderAlignmentHorz = taRightJustify
            MinWidth = 30
            Options.Editing = False
            Options.Filtering = False
            Options.Focusing = False
            Options.IncSearch = False
            Options.FilteringMRUItemsList = False
            Options.ShowEditButtons = isebNever
            Options.Grouping = False
            Options.Moving = False
            Options.SortByDisplayText = isbtOff
            Options.Sorting = False
            Width = 30
          end
          object colPLactual: TcxGridDBColumn
            PropertiesClassName = 'TcxTextEditProperties'
            Properties.Alignment.Horz = taRightJustify
            BestFitMaxWidth = 30
            HeaderAlignmentHorz = taRightJustify
            MinWidth = 30
            Options.Editing = False
            Options.Filtering = False
            Options.Focusing = False
            Options.IncSearch = False
            Options.FilteringMRUItemsList = False
            Options.ShowEditButtons = isebNever
            Options.Grouping = False
            Options.Moving = False
            Options.SortByDisplayText = isbtOff
            Options.Sorting = False
            Width = 30
            IsCaptionAssigned = True
          end
          object colSpace: TcxGridDBColumn
            PropertiesClassName = 'TcxTextEditProperties'
            BestFitMaxWidth = 20
            Width = 20
          end
        end
        object cxGridRptTotLevel1: TcxGridLevel
          GridView = cxGridRptTotTableView
        end
      end
      object pnlHide: TPanel
        Left = 0
        Top = 0
        Width = 801
        Height = 23
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Align = alTop
        AutoSize = True
        BevelEdges = [beTop, beBottom]
        BevelKind = bkFlat
        BevelOuter = bvNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 1
        object lblTotals: TLabel
          Left = 10
          Top = 3
          Width = 167
          Height = 13
          Margins.Left = 2
          Margins.Top = 2
          Margins.Right = 2
          Margins.Bottom = 2
          Caption = 'REPORT COLUMN TOTALS :'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object pnlRptTotHide: TPanel
          Left = 651
          Top = 0
          Width = 150
          Height = 19
          Align = alRight
          AutoSize = True
          BevelEdges = [beLeft]
          BevelOuter = bvNone
          TabOrder = 0
          object btnHide: TcxButton
            AlignWithMargins = True
            Left = 79
            Top = 0
            Width = 61
            Height = 19
            Margins.Top = 0
            Margins.Right = 10
            Margins.Bottom = 0
            Align = alRight
            Caption = 'Hide'
            Default = True
            LookAndFeel.Kind = lfOffice11
            TabOrder = 0
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Microsoft Sans Serif'
            Font.Style = []
            ParentFont = False
            OnClick = btnHideClick
          end
          object btnHelp: TcxButton
            Left = 0
            Top = 0
            Width = 60
            Height = 20
            Caption = 'Help'
            LookAndFeel.Kind = lfOffice11
            TabOrder = 1
            Visible = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Microsoft Sans Serif'
            Font.Style = []
            ParentFont = False
          end
        end
      end
    end
    object Preview: TfrxPreview
      Left = 0
      Top = 0
      Width = 801
      Height = 95
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alTop
      ActiveFrameColor = clWhite
      BackColor = clWhite
      BevelEdges = [beTop, beBottom]
      BevelInner = bvNone
      BevelKind = bkFlat
      BevelOuter = bvNone
      BorderStyle = bsNone
      FrameColor = clWhite
      OutlineVisible = False
      OutlineWidth = 120
      PopupMenu = PopupMenu1
      ThumbnailVisible = False
      OnPageChanged = PreviewPageChanged
      UseReportHints = True
    end
    object pnlStatus: TPanel
      Left = 0
      Top = 418
      Width = 801
      Height = 14
      Align = alBottom
      BevelOuter = bvLowered
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 2
      object progrBar: TcxProgressBar
        Left = 1
        Top = 1
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        ParentCustomHint = False
        TabStop = False
        Align = alClient
        AutoSize = False
        ParentColor = False
        ParentFont = False
        ParentShowHint = False
        Properties.BeginColor = clActiveCaption
        Properties.ShowText = False
        Properties.ShowTextStyle = cxtsText
        Properties.TransparentImage = False
        ShowHint = False
        Style.BorderColor = clBtnFace
        Style.BorderStyle = ebsNone
        Style.Edges = []
        Style.LookAndFeel.Kind = lfUltraFlat
        Style.LookAndFeel.NativeStyle = False
        Style.Shadow = False
        Style.TransparentBorder = False
        StyleDisabled.LookAndFeel.Kind = lfUltraFlat
        StyleDisabled.LookAndFeel.NativeStyle = False
        StyleFocused.LookAndFeel.Kind = lfUltraFlat
        StyleFocused.LookAndFeel.NativeStyle = False
        StyleHot.LookAndFeel.Kind = lfUltraFlat
        StyleHot.LookAndFeel.NativeStyle = False
        TabOrder = 1
        Height = 12
        Width = 747
      end
      object pnlReportTime: TPanel
        Left = 748
        Top = 1
        Width = 52
        Height = 12
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 17
        Margins.Bottom = 0
        Align = alRight
        BevelEdges = [beLeft]
        BevelKind = bkFlat
        BevelOuter = bvNone
        TabOrder = 0
      end
    end
  end
  object tlBarPreview: TToolBar
    Left = 0
    Top = 0
    Width = 801
    Height = 46
    AutoSize = True
    ButtonWidth = 73
    EdgeBorders = [ebTop, ebBottom]
    EdgeOuter = esNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    Images = tbImages
    List = True
    ParentFont = False
    ParentShowHint = False
    AllowTextButtons = True
    ShowHint = True
    TabOrder = 1
    Transparent = False
    object tlbtnZoomIn: TToolButton
      Left = 0
      Top = 0
      Action = actnZoom_In
      AutoSize = True
      ImageIndex = 5
      ParentShowHint = False
      ShowHint = True
    end
    object tlbtnZoomOut: TToolButton
      Left = 24
      Top = 0
      Action = actnZoom_Out
      AutoSize = True
      ParentShowHint = False
      ShowHint = True
    end
    object tlbtnFitPage: TToolButton
      Left = 48
      Top = 0
      Action = actnZoom_Page
      AutoSize = True
      ImageIndex = 8
      ParentShowHint = False
      ShowHint = True
    end
    object tlbtnFit100: TToolButton
      Left = 72
      Top = 0
      Action = actnZoom_Page100
      AutoSize = True
      ImageIndex = 9
      ParentShowHint = False
      ShowHint = True
    end
    object tlbtnFitWidth: TToolButton
      Left = 96
      Top = 0
      Action = actnZoom_PageWidth
      AutoSize = True
      ImageIndex = 10
      ParentShowHint = False
      ShowHint = True
    end
    object pnlZoom: TPanel
      Left = 120
      Top = 0
      Width = 52
      Height = 22
      AutoSize = True
      BevelOuter = bvNone
      Ctl3D = False
      Locked = True
      ParentBackground = False
      ParentCtl3D = False
      TabOrder = 4
      object lblZoom: TLabel
        AlignWithMargins = True
        Left = 10
        Top = 2
        Width = 32
        Height = 15
        Margins.Left = 10
        Margins.Top = 2
        Margins.Right = 10
        Margins.Bottom = 0
        Align = alLeft
        Alignment = taCenter
        Caption = 'Zoom'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
      end
    end
    object txtZoomEdit: TEdit
      Left = 172
      Top = 0
      Width = 50
      Height = 22
      Alignment = taCenter
      MaxLength = 6
      NumbersOnly = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Text = ' 100'
      OnExit = txtZoomEditExit
      OnKeyUp = txtZoomEditKeyUp
    end
    object pnlPerc: TPanel
      Left = 222
      Top = 0
      Width = 31
      Height = 22
      AutoSize = True
      BevelOuter = bvNone
      Ctl3D = False
      Locked = True
      ParentBackground = False
      ParentCtl3D = False
      TabOrder = 5
      object lblPerc: TLabel
        AlignWithMargins = True
        Left = 10
        Top = 2
        Width = 11
        Height = 15
        Margins.Left = 10
        Margins.Top = 2
        Margins.Right = 10
        Margins.Bottom = 0
        Align = alLeft
        Alignment = taCenter
        Caption = '%'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
      end
    end
    object tlbtnPageFirst: TToolButton
      Left = 253
      Top = 0
      Action = actnPage_First
      AutoSize = True
      ImageIndex = 1
      ParentShowHint = False
      ShowHint = True
    end
    object tlBtnPagePrev: TToolButton
      Left = 277
      Top = 0
      Action = actnPage_Previous
      AutoSize = True
      ImageIndex = 2
      ParentShowHint = False
      ShowHint = True
    end
    object tlbtnPageNext: TToolButton
      Left = 301
      Top = 0
      Action = actnPage_Next
      AutoSize = True
      ImageIndex = 3
      ParentShowHint = False
      ShowHint = True
    end
    object tlbtnPageLast: TToolButton
      Left = 325
      Top = 0
      Action = actnPage_Last
      AutoSize = True
      ImageIndex = 4
      ParentShowHint = False
      Wrap = True
      ShowHint = True
    end
    object pnlGotoPage: TPanel
      AlignWithMargins = True
      Left = 0
      Top = 22
      Width = 81
      Height = 22
      Alignment = taRightJustify
      AutoSize = True
      BevelOuter = bvNone
      Ctl3D = False
      Locked = True
      ParentCtl3D = False
      TabOrder = 2
      StyleElements = [seFont, seClient]
      object lblGotoPage: TLabel
        AlignWithMargins = True
        Left = 10
        Top = 2
        Width = 61
        Height = 15
        Margins.Left = 10
        Margins.Top = 2
        Margins.Right = 10
        Margins.Bottom = 0
        Align = alLeft
        Alignment = taCenter
        Caption = 'Goto Page:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
      end
    end
    object txtPageEdit: TEdit
      Left = 81
      Top = 22
      Width = 49
      Height = 22
      Hint = 'Go to Page # (Ctrl+G)'
      Alignment = taCenter
      TabOrder = 1
      OnExit = txtPageEditExit
      OnKeyUp = txtPageEditKeyUp
    end
    object pnlPageOf: TPanel
      Left = 130
      Top = 22
      Width = 73
      Height = 22
      AutoSize = True
      BevelOuter = bvNone
      Ctl3D = False
      Locked = True
      ParentBackground = False
      ParentCtl3D = False
      TabOrder = 3
      object lblOfPage: TLabel
        AlignWithMargins = True
        Left = 10
        Top = 2
        Width = 53
        Height = 15
        Margins.Left = 10
        Margins.Top = 2
        Margins.Right = 10
        Margins.Bottom = 0
        Align = alLeft
        Alignment = taCenter
        Caption = 'of Page X'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
      end
    end
    object sep2: TToolButton
      Left = 203
      Top = 22
      Width = 8
      ImageIndex = 31
      Style = tbsSeparator
    end
    object tlbtnPrint: TToolButton
      Left = 211
      Top = 22
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Action = actnFile_Print
      AutoSize = True
      ImageIndex = 11
      ParentShowHint = False
      ShowHint = True
    end
    object tlbtnPageSettings: TToolButton
      Left = 235
      Top = 22
      Action = actnPrint_Settings
      AutoSize = True
      ImageIndex = 12
      ParentShowHint = False
      ShowHint = True
      Visible = False
    end
    object sep3: TToolButton
      Left = 259
      Top = 22
      Width = 8
      ImageIndex = 39
      Style = tbsSeparator
    end
    object spdCopy: TToolButton
      Left = 267
      Top = 22
      Action = actnFile_Copy
      AutoSize = True
      ParentShowHint = False
      ShowHint = True
      Style = tbsTextButton
    end
    object sep4: TToolButton
      Left = 302
      Top = 22
      Width = 8
      ImageIndex = 39
      Style = tbsSeparator
    end
    object spdPDF: TToolButton
      Left = 310
      Top = 22
      Action = actnFile_SaveToPDF
      AutoSize = True
      Caption = 'PDF'
      ParentShowHint = False
      ShowHint = True
      Style = tbsTextButton
    end
    object sep5: TToolButton
      Left = 342
      Top = 22
      Width = 8
      Enabled = False
      ImageIndex = 0
      Style = tbsSeparator
    end
    object btnTurboTax: TToolButton
      Left = 350
      Top = 22
      Action = actnExport_TurboTax
      AutoSize = True
      Enabled = False
      Style = tbsTextButton
    end
    object sep6: TToolButton
      Left = 407
      Top = 22
      Width = 8
      Enabled = False
      ImageIndex = 0
      Style = tbsSeparator
    end
    object btnTaxAct: TToolButton
      Left = 415
      Top = 22
      Action = actnExport_TaxACT
      AutoSize = True
      Enabled = False
      Style = tbsTextButton
    end
    object sep7: TToolButton
      Left = 465
      Top = 22
      Width = 8
      ImageIndex = 40
      Style = tbsSeparator
    end
    object spdExit: TToolButton
      Left = 473
      Top = 22
      Hint = 'Close Report Preview'
      Action = actnFile_Exit
      AutoSize = True
      Caption = 'CLOSE'
      ParentShowHint = False
      ShowHint = True
      Style = tbsTextButton
    end
  end
  object imDraftBackground: TcxImage
    Left = 0
    Top = 188
    Picture.Data = {
      0B546478504E47496D61676589504E470D0A1A0A0000000D494844520000028C
      000002B608020000004BB05A4A0000000467414D410000B18F0BFC610500003C
      9649444154785EEDDDEB76DA581645E17EFF67A53120AE06BB7BC57B17457CC1
      A0733F677E3F3292AA4448C243932D09F8CFFF0000A8D2E572F1DF8D8A480300
      6A743C1EA7693A9D4EFEE721116900407554E8D56AF5DFFFFE77BD5E8FDC6922
      0D00A8CBB5D066E44E13690040453E155A168BC5B09D26D200805A7C2DF4953A
      ADFFEB7F6F18441A0050853B853603CED3441A0050DEAF85163BEF3DD43C4DA4
      0100853D52E8ABA13A4DA40100253D5568334EA7893400A09819853683749A48
      0300CA389D4EF30A6D46E83491060014307B86BED57DA789340020B7C019FAAA
      FBFBBD89340020AB5885BEEAB8D3441A00904FF4428BE6E9699ACEE7B33F4647
      883400209FE885162D73B7DBBDBFBFFB63748448030032A1D0CF22D200801C28
      F40C441A00901C859E87480300D2A2D0B31169004042143A04910600A442A103
      1169004012290AFDF2F2324EA185480300E263868E8248030022D3BCEB5D8D67
      C0420B910600C4C40C1D119106004493A2D0A35D87BE45A401007130434747A4
      01001150E8148834002014854E844803008250E87488340060BE14851EF94EB1
      4F883400602666E8D4883400600E0A9D019106003C8D42E741A40100CF495168
      AE437F8B4803009E906E867E7B7BF3C7C03F883400E0519CE5CE8C4803001EC2
      0C9D1F910600FC8E421741A40100BF485168BB538C42DF47A40100F750E88288
      3400E04714BA2C220D00F81E852E8E480300BE41A16B40A401009F51E84A1069
      00C05F28743D883400E05F14BA2A441A00E0D6EBB577351E0A1D82480300FE60
      86AE109106003043578A4803C0E82874B58834000C8D42D78C4803C0B8B80E5D
      39220D0083A2D0F523D2003022CE7237814803C07052145A168BC5EBEBAB3F06
      6220D20030961467B9AF96CBE5F97CF6474230220D0003495A6843A72322D200
      308A4467B9BFA2D3B11069001842B6421B3A1D05910680FE652EB4A1D3E18834
      00742EC375E89FD0E940441A007A566486BE45A743106900E856C119FA169D9E
      8D4803409F8ACFD0B7E8F43C441A003A5455A10D9D9E814803406F2A2CB4A1D3
      CF22D200D0954AAE43FF844E3F854803403F2A2FB4A1D38F23D200D0896ACF72
      7FA54EF37D598F20D200D0832666E85BCCD38F20D200D0BC8666E85BCCD3BF22
      D200D0B614857E7979D97E483DA0D3E9FB883400342C5DA1DFDEDEDEDFDFF7FB
      7D8613E974FA27441A005A95B4D0F610793ACD3CFD13220D004DCA506843A70B
      22D200D09E14855626BF16DAD0E952883400342673A18D3ABDDBEDE87466441A
      005A52A4D086793A3F220D00CDC8761DFA27793A2D74DA1069006843C119FA56
      9EF3DE42A785480340038ACFD0B738EF9D0D910680DA555568C37D6479106900
      A85A2567B9BFB24E2BF6BED03406EF349106807A555B68C37D64A9116900A854
      8567B9BFA2D349116900A851138536743A1D220D00D54911BC448536743A1122
      0D007569AED0C63A9DFA3E3219AAD3441A002AD2D059EEAF98A7A323D200508B
      A60B6DE8745C441A00AAD041A10D9D8E8848034079DD14DAD0E95888340014D6
      59A10D9D8E82480340495D16DAE4E9F462B1E8B8D3441A008AE9B8D086793A10
      9106803252143AE2E772C7A24EF3FDD3B311690028A0FB19FA96CDD35A3D5FD1
      64FAEB34910680DC369B8D57259E6A0B6DB83E3D0F910680ACD4D1E3F11877AC
      ACBCD086EBD333106900C8ED72B9A8D3CBE5D2AB12A689421B3AFD2C220D0005
      58A7C3E7E9860A6DE8F45388340094A14E1F0E87904E37576843A71F47A401A0
      989079BAD1421B3AFD20220D0025CD9BA72B7C3FF4B3E8F42388340014F6EC3C
      6D33B4FE95FFFB66D1E95F11690028EFF14E377D96FBAB3C9D6EF7FDD3441A00
      AA609DBEFFBEACCE0A6DACD38F9F4898ADC54E136900A8C5FDEBD35D16FA8A79
      FA5B441A002AF2D3796F2B7407D7A1EFE0FAF457441A00620A9F74BFCED32314
      DAD0E94F88340044334D53949ADECED3E314DAD0E95B441A00E2B06F9F8CD554
      EBB4963954A10D9DBE22D20010C1EDF743C7EAF4DBDB9B42D2EB9D62F7D16943
      A40120D46DA14DAC4EBFBFBFFBEFC643A78548034090AF8536A35D4B4E814E13
      690098EFA7421B3A1D6EF04E13690098E97EA10D9D0EA74E6B37FA0E4DA6CE4E
      13690098E391421B3A1D2EC33C5DE7E79111690078DAE38536743A5C9EF3DEA7
      D3C91FAF0E441A009EB3D96CFC88FE0C3A1D6EC04E13690078C2BC421B3A1D2E
      CFF5E97A3A4DA401E051218536743A5C864E2F168B4A3A4DA401E021E18536CB
      E5924E071AE7BC37910680DF3D7BA7D87DCCD3E106E9349106805FC49AA16F29
      30C7E371E44FFD0C3742A7893400DC93A2D09CF18EA5FBFBC8883400FC2845A1
      39D71D57DF9D26D200F03D0ADD8A0CE7BD4BDDEF4DA401E01B14BA2DBD769A48
      03C06714BA455DDE4746A401E02F14BA5DFD759A4803C0BFE2BE1FDA50E89C3A
      EB34910600C70CDD07755ABBDD9F8064F2749A4803C01F14BA27DDCCD3441A00
      92149A4F2C29AB8F799A4803181D3374AF3A98A7893480A1252AF4344D14BA06
      AD779A4803181733F4089AEE34910630280A3D8E76AF4F13690023E2FDD0A369
      749E26D20086C30C3DA6163B4DA4018C85428FACB94E13690003A1D068ABD344
      1AC02828344C439D26D2008690A8D0BC1FBA5187C3A1894E136900FD4B51E8E5
      7249A19BD644A7893480CE3143E327F59FF726D2007A46A1715FE59D26D200BA
      C5596E3CA2E6F3DE441A409F28341E576DA78934800E25FAD44F0ADDB13A3B4D
      A401F486EBD098A7C24E1369005DA1D008515BA78934807E701D1AE1AAEA3491
      06D0096668C452CFFBB28834801E5068C455C93C4DA401348F4223851A3A4DA4
      01B48D42239DE29D26D2001A46A1915AD9EBD3441A40AB2834F228D869220DA0
      497CA618722A75DE9B4803684F8A199AF743E3BE229D26D2001A43A1514AFE4E
      1369002DA1D0282B73A78934806670A7186A90A7D3AFAFAF7A2C220DA00DCCD0
      A847EA4EAFD76B0DD3EFEFEF441A400398A1519B749DD64FBB155A8F42A401D4
      8E42A34E293A7D5B6821D200AA46A151B3B89F73F2A9D042A401D48B42A37EB1
      E6E9AF8516220DA052141AAD08EFF4B78516220DA046141A6D09E9F44F851622
      0DA03A143A84B6D1DE628BCCE675FA4EA1854803A80B850E713E9FF7FBFD7ABD
      D6AFFE9F90D1B39DBE5F6821D2002A42A14358A1AF5B4DA78B78BCD3BF165A88
      34805A50E810B7853674BA94473AFD48A1854803A802850EF1B5D0864E97A24E
      DFF9CAF3070B2D441A4079143AC44F85361AE9E874113F75FAF1420B91065018
      850E71BFD0864E97F2B5D34F155A88348092D2155AF5F2C7E8D72385369CF72E
      E5B6D3CF165A8834806298A1433C5E68C33C5D8A757A46A18548032883428778
      B6D0864E97A23CBFBEBE3E5B6821D2000AE02C778879853674BA94198516220D
      20370A1DC20ABD582C7CCB9F47A71B42A4016495A2D0CBE59219FA29DC47D60A
      220D201F0A1D42DBB8DBED4266E85BCCD34D20D20032A1D02162CDD0B7E874FD
      8834801C28748814853683ECC076116900C9252AB4164BA143ACD7EBE3F1E80F
      832A11690069314387B042C7BA0E7D8B4237814803488842876086069106900A
      67B9433043438834802434EC7A13A2A2D021B4400ADD16220D20BE448596D56A
      F5F6F6E60FD3A94467B95568ED3D0ADD16220D20B27485367D773A5DA199A15B
      44A401C4A47C6EB7DB9797178F431ABD763A51A18542378A480388EC72B9D0E9
      192834BE22D200E2A3D3CFA2D0F816910690049D7E1C85C64F88348054ACD3CB
      E5D28B9146EB9D56A177BB9D6F4C5414BA03441A404274FABE4433B4DDCB7D38
      1CFC61D02C220D202DCE7BFF84B3DCF8159106901C9DFE2AE90C4DA1BB41A401
      E440A76F696F50683C824803C8844E9B4485160ADD1F220D201F3A4DA1F11422
      0D20AB913B4DA1F12C220D20B7313B6D854EF16E340ADD31220DA080D13ACD0C
      8D7988348032C6E93433346623D2008A19A1D3E93EB144DB45A1BB47A4019464
      9DEEF57343D3CDD0147A10441A4061BDCED39CE54638220DA0BCFE3A4DA11105
      910650859E3A4DA1110B9106508B3E3A4DA1111191065011E5B3E94E5368C445
      A401D4A5DD4EDBBBAD28342222D200AAD362A76D86F6454745A14746A401D4A8
      AD4E272A34DF0F0D220DA052D6E914678F6F85779AEBD048874803A857FDF334
      854652441A40D5F2745ACB9FD1690A8DD4883480DAD5394F53686440A40134A0
      B64E27BA534CB40E141A57441A401BD4C54AEE2363864636441A4033B2CDD3CA
      B03FE417490B7D381CFC61800F441A404BCA9EF74E54E8C562C1596E7C8B4803
      688C753AC379EF4FF3B415DAFF77549CE5C64F883480F6E43FEF9DAED0CCD0B8
      8348036852CE4EA72B343334EE23D2005A95A7D3CBE572B7DB71A7188A20D200
      1A96E7FA740A141A8F20D200DAD662A729341E44A401342FCF79EF5828341E47
      A401F4A0954E53683C854803E844FD9DA6D078169106D08F9A3B4DA131039106
      D0953A3B4DA1310F9106D09BDA3A4DA1311B9106D0A17A3A4DA111824803E893
      75BAECFBA7293402116900DD2A3B4F53688423D2007A566A9EA6D088824803E8
      5CFE4E5368C442A401F42F67A729342222D2008690EDFAF46EB7F38704821169
      00A3C8D3692DFF72B9F843026188348081D069B4854803184B9EEBD3741A5110
      6900C3619E462B88348011D1693481480318149D46FD88348071A9D3BBDD8E4E
      A35A441AC0D0E8346A46A4018CCE3ACDFDDEA810910600E669548A4803C01F74
      1A1522D200E0E8346A43A481BA9CCF67A5C2FF80ECE834AA42A4818A4CD3A423
      B87E3D1C0EAA05B52E224FA797CB259DC6AF8834500B2BF4D57ABDDE6EB70CD6
      45E4E934F3347E45A4812A7C2AF42DA5FA783C2A1BEFEFEFFEB7911E9D460D88
      3450DE9D42CB62B1D0AF9BCD66BFDF93EA9CF2749AF3DEB883480385DD2FB4B1
      4EEB68AE60281BA7D38954E7C13C8DB2883450D22385FE96FE213797E541A751
      1091068A995D68A3C17AB55AEDF7FBF3F9CC609D549E4E73DE1B5F1169A08CC0
      42DF5A2C164AC8F17854AAA97522741A451069A0808885BE523FB4580DD63ACA
      730E3C05CE7B233F220DE496A2D0571AC544A9B69BCB18ACE3A2D3C88C480359
      6DB75B3F12A7676FB026D571D169E444A4817C7216DADEB5A563FD6AB552AAB9
      B92C223A8D6C88349049CE427F4B5D61B08E854E230F220DE450BCD0D7C17AFA
      7883B50EFDA43A509E4E73BFF7E08834905CF1427FA2E3BED2A254BFBEBE3258
      87609E466A441A48ABB6429BEB60ADC69C4E27C58654CF43A79114910612AAB3
      D09F7C1AAC7DD5F1B06C9D3E9FCFFE90180691065269A2D0B7EC43463558FB06
      E061741A89106920091D4CD53C3FB8364525D86C364A3537973D854E2305220D
      24A1BC297576E9B745CBE572BD5E1F8F476E2E7B1C9D4674441A48454752A5CE
      8FACCD5AAD56D3347173D983E834E222D2402A97CB45796B7798BEA52AA8D64A
      B5DA40AAEFA3D388884803091D8F473FA63E4F5378558DD79AD839701588FBC0
      EFA3D388854803096998DE6C367E4C7D92A2B8FDF8860C8DB0A90FF7CFD22A69
      BB946A6E2EFB099D4614441A486BBFDFCFBB32AD48AB8516C2C3E1A011B6AA2B
      DC5A3D15426B683797F9D6E2069D4638220DA4A5415325F303EA935465355EC7
      7A2D44BFEAF74AB5FE7B3DE7C08D365043BF5261ABEA5B8E7F3A3DFB07E041FA
      39A1D3BD22D2405A8A960ED37E349DE5764ED5EF678FE649D9DCAFD7105A4382
      718B791A218834909C8E9E7E289D45E5BBFCFDB9CD966A1D976B1BA90D37977D
      92679EA6D35D22D24072364CCF0EAAE6E6C3E1A003BD2FEE83FE28DBEDB6C213
      E0B6326AD2344D4AF5A7571863D29345A73103910672389D4E21E7A8BF0ED346
      F9D741D9A66AFFAB95D1566F369BE3F1483CF2749AEBD39D21D2400EAAA9C64A
      3F8ECEA2A1D997F51D0DAC9AB615800A6B6D83B59D03D74B0DB56AD8D3E0741A
      CF22D2400ECA92A6C990615AF5D5127C71DFD143D89BB566BF333B036D8556CF
      BEBDC3D77B307A9AE8341E47A4814C3445E9D01C72F158B3F8AF6D5303F44096
      EAAA2E545F69AD44AB771DAC7DD587619D4E7DCE834EF781480399D830ED47D0
      B9545F5FDC6F7480D6C3D579025C2CD5EBF5DADE603DDA60CD3C8D071169201F
      1D31038FCB3AECBE3EFCF15E2A81E2A7BFAFB1D5CEB4AB8BB69CAA68DDA669D2
      EB0FADADD6D9D7BE77CCD378049106B2DAEFF77EF89C45C75C2D61C629624DD5
      4A822FA53E3658EBC584066B6DDD20E7C0E9347E45A481AC34D7060ED3FAE7F3
      264EFD93D3E9A40AEAA85DE7486D142D0DD683DC5C96A7D342A71B45A481AC74
      505626FDC0398B4D9C33226D34A4EA78AD0ADAA7A0D4E963AE5E6825EDB441DF
      83B5753AF5F569A1D32D22D240563A226B400C9C9C340A1F8FC7D99D165B0D25
      B0E6549B116E2EB34E334FE32B220DE4A6D884BF3F4A5366E07C698DD751FB74
      3A290F190A1142AF4BB4C97A69A2BD17F2EAA45AD669EEF7C627441A28405D0C
      8CB43CFE76AC5FA97C5AA5EB4DE0D5D2EA69257B3D074EA7F11591060AB061DA
      8F9A736909118FB6369EDA4DE03A8E8B3F4C9534F76FB75BBDB0E82CD5793A2D
      74BA15441A2823F0BD58A28EAA52BEB878D489D78FAFC2CC908A40DA034AF5E1
      E32BC2BAA9359DC62D220D94A1A884DFB4A58132519CB458D542A90E9FF83350
      D21436BDB6E823D5793AAD1FBF6E5ED9748C480365E8F8A80371E09569455A73
      A48EE9BED0D8B4E4CBE5723C1E9B48B568976A6DED15866F439B52775A4BEEEF
      624197883450CCF97C0EBFF4AB7C66689252AD39759A261DDCFFBC85B9E2CF42
      11ED930E3E64D43A9DE2AE7B0ADD10220D14A3A3E47EBF0F0F9E16E24B4C49CD
      D00A2BD5DBEDD652ED0F5F2B3BCDA01A69CDC537A3295AEDE8F334856E0B9106
      4AD2E1D28F9D01D6EBB5DAE94B4CCC6AA78753FF54C1CA6F0217ADE1F4F1ED1D
      1FA56E2FD55AE788F334856E0E91060A0BFC9450D1507B3C1E7D71B9281EE7F3
      59F1D34B842652ADF5D4DAEAE54573A9B64E87CFD314BA45441A2849C75F1D37
      C3E7241D7F2F253E35D382A7F8D94B8DCACF812BD5A2E0D96B9A866A1DDE69FD
      8C51E8161169A0301D7FC3EF9DD62158E129581D1DFDD580699A54415FA78A69
      25B5CFF7FBBD5ED9B4D2AD904E3343B78B480385E9E0AB03A81F4D03ACD76B5F
      6239CA80B2A7A9DA5E76D43F58AB5E4AB55DD12FF812E741F33A4DA19B46A481
      F2CEE7B346E1566EF3FE955AA2246865946A6D54E5A9D6EAA9D67A61D1C41BAC
      9FED34856E1D9106AA70381CFCB01A20FCABB1E2D28B0F15429D88757372525A
      49BDAA50AAB5DA35A7FAF14EEBEFD82B0FFF9768109106AAA0303C3E1EFD4443
      A1DD125595EB07A134916AD17AAA827A79A195AFB3D6D6E9FBFB9342F7814803
      B588F25E2CCD82456EF3BE4F5111656F1FE3C35BF2B09BCBF4F242FB532BEF5B
      520DADD29D799A427783480355D031D7AE4CFB51762EA545CBF18556C93E08A5
      8977578BDD5C666FB0D6CA5755EB9F3AAD9F220ADD0D220DD44247D5699AFC40
      1BA0B62BD35F69F5149856EE2C13ADA1CAB7DD6EF502C856DEB7A4B4AF9DA6D0
      9D21D2404534AEF9B136800ED936F6554E81514B54147B7775E5A9B6D55302D7
      EBF5E974AA670FDF765ABF52E8CE1069A02297CB45C50ACF958EDABEC41668AB
      35A16AC3BF9EB9AD9656D5DE60AD468A6F4921D669BB359D42778648037589F2
      5E2C0D7C4D0CD3B75417A55AB1A97FAA165B43A55AAF2DB4DAC56FD653A7ED54
      BCFF19BD20D2405D749CD571DF4A10424355F109EF595A61BDB6D02B8CFA237D
      EB7A7359CDEFDA42A3883450171DE2F7FB7DE09DCF8A9C9650E17BB1EE53A137
      9B4DE0B617A11D2EEBF57ABBDD6A2B9868110B9106AAA3B86A9AF4C3FF5C4A9D
      66BB86A63AB5AD95F765DD77BDB9ECFCF15E38066B8420D240757458DFED767E
      C80FA0A9B495427453E82B1BACF7FBBD52AD67A1952702B521D2408D3487D981
      DE8EF8F3D830ED4BAC989DE5F695EE8EDD5CA66D6CEEEA036A40A4811A69F08A
      324C2B0F95CF70FDCDD0DFD2066A33F59AC952CD608D071169A052C7E3314ABA
      EC96E33AD90CDD7DA1CDC7BD657E739952CDCD65780491062AA5614B07743FC0
      075012EAECC12033F4B75E3EBE1653AF9F18AC711F91062AA5037794615A3DA8
      F06A68F419DAEEA9F63FB4C0066BED84DD6EC7608D9F1069A05E3A76877F52A6
      4A50DB95E9148556EAD4392D79BFDF6BA7B535A0D7F3C965A80D9106EA65C3B4
      2AEBC7F2B9D4807A8EFE56685FB318AE85B6E5EB37625FB1E57FA3057A96F5C2
      42A93E1C0E5A7F4E80C31069A06A4A9A121BDE6945CB975854EA425F29727A5D
      A2E0297B8A5FF80ECC69BD5EDB463158834803B5DB6EB77EF00EA0E3BE7D0056
      41290AFDEB6D71FABFDA703D6EF88583CCB475760EDCB7044322D240ED74980E
      BF254AD364D9F762659BA1BF65A9D6DF6FEBE632BDB068F18B52101191066AA7
      C044C99B8EF80F262D3A155A754C71A7983FC0032C754AB5B2A77F5EFF9D6556
      68CE780F8E48030D505AC2A3A2326998CE3F96D550E84F543EED8A699AAA3D07
      AE6D54A14BBDA8423D8834D0004545C374F8DD4FCA922F31173BCB5D55A18DBD
      585108ED927F5583B5CDD0141A42A48136E8A81D1E69A528E795E90A67E8AF54
      6BADE7E170A864AA6686C62D220DB44147ED2857A615B93C67BCAB9DA1BFA57D
      A2256BF95176F26CCCD0F88448036D5045F6FBBD1FCB03A89ACAA72F3499B60A
      7D65A9D654BDDD6EB5F299DF5D4DA1F11591069AA1C3B75AE547F4B9D41EC53E
      69091A2DF4ADCBE5723E9F73DE5946A1F12D220D34434770B52A3C7EEA41BA33
      DED10BAD45652EF4951E34CFBBAB29347E42A4819644792FD662B1D0309DA2D3
      1DCCD09FD85ED26E3F1C0E76135CF473E0141A771069A0253A942B5A7E740FA0
      9446FF948C9E66E8AF546BED31DBC6F08B0E57141AF71169A0313AA6FB013E80
      C6418D86BEC418FA9BA1BFA5548B9E02AD9BD630707B29347E45A481F628877E
      989F4B918E384C5BA17DD131D459E82B4BB5B65A2F746677DA0A1DFD7C063A43
      A481C6280FA7D329CA195765464BF3E5CE35C80CFD2DED3D5556A97E760F5068
      3C884803EDD1C15D47793FDE07505A025B3872A1AF946AADB0A23B4DD323B795
      691B39CB8D071169A03DAA828EF27EC80FA0D2870CD314FA13BD783A9D4EDBED
      563BF6A75A53683C8548034D522075B80F7F3B908AE24B7C1285FE893641B463
      BFBEBB9A42E359441A6855944F095536945B5FE2C328F423CE1FDF5DAD546BEB
      6C1BF547AE43E329441A68D2FBFBBB1A107E655AB3F8B31F6C42A19FA22ADB1E
      3B9D4E141ACF22D240AB54D6699A3C7473D90973F5DE17FA1B0A3D8F9E2CCE72
      6306220D344C9359945E1E0E874786E9E885D6A2B6DB2DF5027E42A4818629D2
      E1C3B4AC1EF8CA0D0A0DE447A4513595E396FF57DC389D4E1EBD00EAE57EBFF7
      257E87420345106954C44A7C3E9F3520EA57E5E7783CEAD7C30775C2E8C82ED6
      6CFB7564DA57CAA7A72FC09D646A9F47BF0E4DA181471069946489D5C15A1950
      8CA70FABD54A3DD0715CBFDA6D4DFAD57EA3FF28EBF55A7F67B7DB69F8B33B66
      C51638A628EFC512BD24F225DEA0D04041441A6528CF1657B5560DB8C6D88EE3
      8FB39C6B09166C2DD6C23F146DF2D7CFCD789676BEDAF9E9E50E8506CA22D2C8
      CA0AAA43FFE170D034AC43B61FBC63B0215BD5B7F1DA1E71046A9EB63A3CA55A
      C2ED7BB12834501C91463E3A3AAB013A4CEB603D63687ECA344D7A1DF031570F
      31586BC786D7544F8AAA6C11A5D0400D883472502935DAEA186D9F9095BAD057
      CA8C523DC254AD3DBCDFEFC377AC9E20F59E42039520D2484E07FDE3F1A8C374
      C483FEE3F4A07A68ADC0ED89DC2E9D3EDE8B15DE69E59942039520D2484B750C
      BFA7299C92A3D5D054EDABD5230DD36AA16F703528341082482309054393ABBD
      3528DBC9EDFB6C35B44A5AB12E2F546BA3EC8C856D6F0DF4DA884203218834E2
      B35A6C627CC2460A5A31BBA7CC57B723CA610DE72D0C3334108E482332C56FB7
      DB5535CF7DD5713FF4F2C837B2280A0D4441A4118DF22C71EF394AC7AE52AB22
      5A67DF802E9C637CC974200A0DC442A411878EC895DC23F614F5ECF5F5B5B3F7
      68C5FA94D079283410119146048A9C0A5D7C809B4723B556BEA74EEB6547A9E7
      824203711169843A9FCF9BCD4647673F4E37482BDF59A755CAFC37D55368203A
      228D202AF4344D4D5C84BEAFB34EE7BF324DA181148834E67B7D7D5DAFD71D14
      DAF4D4696D45CEFB032834900891C64CF621949DE9A9D37A82F29CF1D6AB340A
      0D2442A431479785364ACEEBEB6B07EFCBD24B8D699A52779A191A488A48E369
      1D17DA283C7D5427CAF762DD41A181D488349E53F63DB8D9AC56AB0EDAA34D48
      77659A42031910693C61B7DBF911BA77769DB5F593DE5AFF444F19D7A1813C88
      341E354EA18D26C50EBE87E372B944BFFD9E4203D910693C2473A1171F6E7F53
      C47ABD6EFD2632A534EE73C7596E2027228DDFE529B4F55853DAEA8302394DD3
      66B3D1EFED57FD1DFDDFCCCDD6B6FB5E68D6E9748A354C53682033228D5F242D
      B41557877E6558477FE5C4BEEE4219D0FC6AECF7FA8FE7F359FF57EB639F429A
      27D87A88C3E1E0FBA24DDA81DAB7BE3D61F452894203391169DC93B4D0AAACEC
      F77B3BA5FCF8D15F7F53FF44FF30C3E79D29D27A4DA087F3C76ED3F1788CB2A3
      EC3ABD2F14407A441A3F4A576805437D5539341CFB833DEF63CC7E5733A669F2
      E5A6D1C130AD1DA5971A514E3C6828D7D27CB9001223D2F85EBA42AB161A82ED
      24B63F58002D448B524455FDA467BF9BFEAC50EDA558C3B4B47E5E01680891C6
      3754E8E8C1D3025F5E5EB4644DCF2946B1D3E9A4212FD1D96F2D562F2C9A9E20
      B5DBB5FF7D7BC270EF18900D91C667896668BB2F4CCB4F973A0DBBE93E104D93
      7AD391D6CA1F0E07DF9830DC3E066443A4F1971433B4280F21979F1FA778441C
      193F69FDCAF4EBEBABBD932DDC344D4DBF64015A41A4F1AF1433F4F2E34BA532
      0F5EEA748AF3DE1DDC33A54D88F2226CBD5EE779D5050C8E48C3452FB432B9D9
      6C4A1DCAA3CFD3D6B6A6CBA457181177CB7EBFF7E502488648E38FE867B95568
      0D6D65EF888EDE69391E8FBEF436BDBDBDE995936F4C00BB0D90DBBC81D48834
      E2CFD0ABD54ACB2CFE9E250D8E6AAAAF530C2A930AD7FA196FBD76F1ED09A6DD
      CB95692029223DBAE833F47ABD3E9D4E95DCFDAB170A715F82E8F547D367BC45
      FB24CA302DDA1BC55F8A017D23D2438B3E43575568A3A6C66A922C974B7B2359
      D362BD17EBE5E5A5F5B78F039523D2E31AA1D026EE496F6D63EB598A384CEB49
      AFF01907BA41A40715BDD0ABD5AACE428B9ABA8DF43550D2C15B84B5FEB17E00
      96CB65EB6F1F076A46A447A40374C7D7A1BF5293B47AB1EEF4D60CEACB6D99F6
      49AC0F36297E1B3FD031223D9CD10A6DD424C535CA862BF6ADDF3B267ABEF6FB
      7D948F7CD15ED50F802F174054447A2CE35C87FE2AE2DBA6FB787FB0B62256A4
      F50288611A4881480F64E4428B2A12E504AFC2A6DEB77E595AF4C4C5FA91B0B3
      0B1DEC13A036447A1483175A9490286F3DD2E0D8FAE78E5DC5BAEFDD86695F28
      807888F41028B4D13A4739E3DD4DA425D67BB1B463B57B7DA1002221D2FDA3D0
      575A67ADBC6FC65CCBE5B29B8FC3D456E8A98C72655AF493C6196F202E22DD39
      0A7D4BAB1DE51EEF0EBEB3F2EA72B9C4BA9F4ECBE12B3780B88874CF28F4272A
      EB7EBF0F8FB476AC2FB10B87C3217C9F882672EDDE767F3C800A11E96E452F74
      CD9F29F6B8E3F1187876573DEBECAB9435FEC6FA6013ED5BDE8B054444A4FBC4
      0CFD93F04BB0FAE75A4867175FF5B2C3372F8C768E7EF6B8320DC442A43B44A1
      EF08FF48134DD23DDDDD2D6AAA764BAC617AB3D970C61B888548F78642DFA71A
      854CD276ED563BC417D70B757A9AA62857A6A5B3CB01404144BA2B14FA57E193
      B426CECBE5D2DF19DDF03D73A51F1B2DCD970B200091EE07857E44E0242DDA2D
      5D9ECED52B0F0DD3BE91C1FA3BD9001441A43B41A11FA48D0A39A9AB7FDBF197
      4944FC94503BDFE0CB05301791EE41F442F7F16EAB6F1D0E87C0495A7BBBD7BB
      9795D5589F12AA9DDCCDE7B2010511E9E631433F4ECDD86EB7819374DF7745E9
      C72964FFDCD20F922F14C05C44BA6D14FA29DAAEC0CBAE2F2F2F7D9FC5D52E8A
      F55E2CE9ECBD6A407E44BA61B13E80E2AAEF42CB39F8DDC0CBDE3F514BCF7EC4
      9FABED76DBF18F139001916E15857ED6FBFBFBEBEBAB6FED2C8BC5A2E30BD257
      7A2913EB8CB7E887CA970BE07944BA49147A06C535F05CB7D275381C7C71FDB2
      2BF7BECDC1B4CFB9CD1B988D48B787EBD0F36803B5A5BECDB3E89F0F72F2F678
      3CC6FA6093E57239C84E035220D28D61869E4D43B06FF32C1AA335140ED29BF0
      B30EB77AFAFA6D203322DD120A3D9BB631FC14EEEBEBEB20B1D1666A980E7C43
      F9957ECCC6D975405C44BA19143A44F82D63ABD56AA8CFA3D60F863639CA1D64
      5AC86EB7F3E5027806916E03850E71B95CB4BD21BDD1BFD553E08B1B8306DFF0
      4F6733F61247AF937CD1001E46A41B40A1432836DAD8C0DBA0B4C706FC5AA7F0
      B7955FA9D34A3E67BC816711E9DA712F77B8F0CFA39EA669C0C0689323FEF875
      FF3930400A44BA6A143A9CF661E0395BFB28D031A7C0D7D7D758C3B49E058669
      E05944BA5EFBFD3EE432EA5703165ADB1BDE98C13F8E63B3D9C4FA39D44F2091
      069E42A42B45A1C3A9AC513E394BFBCD97381E35F57C3E47FC6093113EB20D88
      8848D728FA9D629A26472BB4047E7A89D90DF061DDF7E9B54EC4615A8BE2CA34
      F038225D1DEEE58EE2783CFAF607D0AEE38D43A29F1FDF2331F0FD95C0E38874
      5D38CB1D45ACDB9DB6DBAD2F716CE7F339FC0EF92B8669E07144BA22CCD051A8
      D0DAF0F04FE1D04246DB757744FCE17C7979E1FC04F020225D0B66E82834A285
      BFE74A1492E3F1C8ADC857FA41D24F94EF9D601AA6D9B7C02388741598A1A350
      A1637DC722DF82FC899A1AEB4BA6ED1E6FCE52008F20D2E5459FA1C73C086A7B
      637D719316C2F9D8AFF4AA257CF7DA0F272F80800711E9C2A27FA698D162873A
      0EC67D3B2F27BABFA59741813FAE141A7816912E29FA59EEABD18E86EA4794DB
      B9178BC5344D3F7D97C6B5DC7A38FD5EBF5ED91FAFFFF1FA37BFFEA669A7D369
      F6304DA181198874311AD7FCE895C638C7444531CA3D4D2AB47DEA8B2FF71FEA
      AB76A3CAADFFA5D7559A2637FFD0E3EA9FDCFE46F41B955E7F6DBBDDEA573D0B
      7AAEF5CF8D9626B7216F88565B9BE6FBEB19141A98874897A103B4BD53C88F61
      698C70648C556851A4D5605BAC9E20ED37D17F516BF5102F2F2FB743A4DD46A0
      5F6F7F23D7FFF589FEAD68215A9442AE78ABDC628F62C1AE3FDB5A43FD44DDEE
      8747E8EF5368601E225D8C755AC76B3F92A5D1F7F13162A14531D602B5AFD44E
      45F44F5497CB6F8B1BEE23E80B2D5FD9169BBCF54C69D4AEBCD95AAB67AF2C50
      686036225D529E4E4B9747C9B8851665520B7CB6405158B3F51B055B2B60E7C9
      EDF4B836533F27E29B5D9AD6442F62F4F2C2D6FC3EFDB5FD7E4FA181D9887461
      3AE4314FCF10BDD06299AC879E35D190AD662B7536646BDB3F925DB2D95A13AD
      98AFE55DCCD04020225D9E753A7A723ED151B59B23668A4257CB866C8BE2F5C4
      B89EC7B243B67E966CF57ED2D3CF1B501091AE82759A79FA114315FA139BF5F5
      EBC785EC17FDC068C83E7EDC3A6E4F6BB660EBC7F5FE75010A0D4441A46B41A7
      1FA14217B9665C333DA7A2172E76565C3F456AB6D53A69B3F570BE067F6BFD67
      0CA80A91AE089DBE6FE419FA571F27C5FFBDA66E57B22DD87AAEF5A31537D85A
      9A96AC69DE1FEF1F141A888B48D745C73E3AFD2D0AFDB86BADF5448B9D15B721
      DB9EF48F648736DB9E91DB57062DFE5C019523D2D5C9D6E986DE1BC359EE101F
      33F6BFD9B6215B4F7DF890AD1F545BAC50682005225DA36C9D6EE2A8AABDC10C
      1DCB6DADEDD633355B3F06F3866CFD13FD735B1A85065220D295D2813243A7A5
      F263ABF60385CE40955DFDF391E3FAC193B78FAF3AFD35D8FBFD9E4203E910E9
      7AE5E974CD47580A9D930DD9D7515B3F78DBEDF6743AE987D06E17177F626EA8
      E5FA3B141A488448574D87C5613BAD6DA7D0A5DC9E1597DB215BC1B667476E7F
      032005225D3B1D0107ECB4B69A3BC5EAA1665FB32D3664EBC7D24E8903488748
      3760B44E6B7B99A1AB65B5B69F16220DA446A4DB304EA72974FD6A3BEF02748C
      483763844E53E8FA5168202722DD923C9D962247610A5D3F15BAA1CFC0013A40
      A41BD3EB3C5DA4D0DACCD56A65BFCAC7374BBDD8EFF51FCDA77BA646A6BDC10C
      0D6446A4DBD35FA7B545EAA23F7032D65ABD14D0AED3A69D4EA7E3F1A80DB44F
      C7B45F6FFF687F417F53B3E3F44109D76EB1A50D88191AC88F4837A9A74EA79E
      A1D566BD02D04328BAF2F6F6A647147FF8DFD85F16FD43955BBF6ACF5FCBADC5
      6AE196FF8E076EFD245068A00822DD2A65A3834E6B2B92165A0BB72F93B036FB
      A386B1E558B6450BB799DBA66D35BBBF819B4203A510E98665EB74A26374BA42
      6B9DB564BDBCD0ECEB0F969E3647B4A344CFCB6EB7D3EB036BB6AF568398A181
      B28874DB5485463BAD354F546875D1F2AC87F007CBCE1EDA9AAD695B73B676A0
      9AFDE7CEB49797C5075FDD8A5168A03822DDBC163B9DAED05AACA25830CF7768
      ADB46E7AF56097B4B5AA7A3D61AB5D61B62934500322DD83B63A9DA8D00A9E46
      D53AF3FC95055BBFD113A766DBC5EC6BB38BA3D040258874275AE9B4D633458A
      B44CAD582B85FE4AC1B621DB4E8C7F1AB2ED37D95068A01E44BA1FF5775A6B98
      6286D6266B186DB7D09F6843ACD9F62E6D0DD9DA697625DB3738250A0D548548
      77C53AADC3BA1F719399711C4F54686DAC36B99B427F62C1B6A755C1DEED767F
      CE897F7C209AB63D7AB62934501B22DD1B3BA0D7364F53E828ACD9DAEDF6CE6C
      3DCBB7C10E6C3685062A44A43B649D4E3D4F3F7E4CA7D02958B0F51BED04055B
      43B676F2B5D9CFA2D0409D88749FEAE93485CEC39AADE7C2AE646BC8D66E7FF9
      F81C955F876C0A0D548B4877AB864E53E8222CD8F603A0606FB7DB6BB0E553B0
      2934503322DDB3B29DA6D095D0BE92EBFBBBEC4AB6359B42039523D29DD3D159
      49CB7F1F991E97425748BBEE7AEB99DD7D46A1819A11E9FE59A773CED314BA09
      DA93EC4CA072447A083A1667EBF4F97CA6D0001005911E45B64E5F6F508A8842
      031813911E489E4E4747A1010C8B488FA5B94E5368002323D2C369A8D3141AC0
      E088F4889AE834850600223DA8CA3B4DA1014088F4B8AAED3485060043A48756
      61A72934005C11E9D155D5690A0D00B78834BCD3A93FDFFB57141A003E21D2F8
      A378A72934007C45A4E1ACD345CE7B536800F81691C6BF8A749A4203C04F8834
      FE629DCE76DE9B4203C01D44FA7BCA8695E3F6376F6F6F1FFFF39BFFDB136D51
      9E79FAE5E5E57038F4B70301201622EDA155808DFA743A9DF4ABFA61B61F142D
      CD97FACD6EB73B1E8FF6BFF437CF1F2E978B2D44BFFA725BA6ADC8D0E9C562A1
      9DA9BDE78F0A00F8DBD091565315571577BFDFABBEEBF57AB55A7DFD3A64B5E4
      D36F6ED93728EB1FEA9FAB6A2AB716A8F068E1FE306DCAD369D1CEA7D300F0AD
      E1226DED544735C3599245F5FD36C0CFB2E528DB5AB2D8CC6D43B6D80A342467
      A7B597FC510100FF1822D216488D6B4A8E4DCCEAA8DA1025CC3FB160EB37AAF5
      66B351ADF5E8F612A1A160E7E9B49E0E3A0D005F751E6935465D546634D4AACD
      EA41D230DFA10E896AA735518DB456ADA43A4FA7854E03C0273D475A477C4DCF
      9A6235CB5EE7DA1A687DF48AC16E3AF375AD1B9D068022FA8CB40EF487C34179
      D6F0EA87FFFAE845835DB7B6D3E0950FD6741A00F2EB30D2C7E3512DA96A74BE
      EFE5E5452BACA9BAF238E5EC34F77B0380F413690DA3A284A8797EB06F8A5DB1
      3E9D4E358FD4741A0072EA24D22AC776BB5DAD567E8C6F9652AD0D391E8FDAA8
      3A6B4DA701209BE623ADE959D367CDD79E67D0AB0D55F0F27113B86F674DE834
      00E4D176A47504DFED760D5D7E7E8ADD565667A5F2745A4F2B9D0630B286237D
      3C1EB37D595341CBE5D23EB6CC37BB1A741A00526B2FD276A55623660757A01F
      612709AE17AAABC2796F0048AAB148AB0A3A5867A842853452EBA589ED04DB1B
      35C8D6E96ACFFC03403A2D455A3D389D4EF6E99E03B291DA3E06BCAA1BCA98A7
      0120916622AD2CE9183D6CA16FAD56ABED765BD5556A3A0D0029B41169155A59
      6AF4534A52D0AED048AD4ED773EADB3A9DFA56BEC562C1796F00E36820D214FA
      27DA2755DDF89DA7D3C23C0D6010B5475A059A9AFDA4CF0C96CBE5E170501A7D
      7F9546A70120A2AA23AD4293E75FA9D38AE2E974F2BD565A9EEBD39CF7063082
      7A234DA19FB25EAFEB792335F33400445169A4EB29B42636E37FBEF1ED7F2C4B
      D1F23D585A9E795AE834808ED518691DDC7316FAB6C1CBE572B55A692AD514A8
      C0ECFEA112E88FF61FF517C4D6B0C24E6B6DF512478DF4BD590E9D068040D545
      FA7038A8947EF44D4F8F25DBED566D3B9D4ECA9B0EF76F6F6F0A8C7EB5DF98EB
      7FD4DFD1AFFA6BC7E3516B6BF1B666E75CF33BB44AAAA3D6D6F769395A873C9D
      D6D347A701F4A7AE48E729B48DCE2AC735CCD6B3A7AA76FD27F61B15428BD248
      A7295C73B63D8A3D5C11741A003A5051A455B80C85B6B9D9DAEC0F1CCF47B2FF
      34C94E8F971DACB502DA4CAD8FAF5C39B64FE834003CAB9648279DA16DA8D580
      AB4ED8C96A7FD494ECCCB95E1068B6FE18DD0B0CD6DA64BD5C18A7D3DAC9741A
      404FAA887486422B96454EFFEA11F59AC006EB529D56B7C6E9B4686FD369007D
      281FE9D485D620AB875021CA864A83F5E9E32BBCF29F031FB0D3CCD300FA5038
      D2A9EF14D3C15A55F007AB80CAA14DB63BCB72629E068016958C74EA42EB189D
      E7F2F3535429B16BD5BEA259D06900684EB148A72BF4CBC7D738D67F7456A894
      6A5FE92C46EB34F79101685D9948272DB40EFD29DE5E958206FDE3F19873A41E
      B0D3CCD300DA5520D2E90AAD02257A037452D6AA6C9F84CA796F006845EE48AB
      D0896AA4795485AEF022F423F4C2422375B64EEB81E83400D42F6BA4D3157AB3
      D9A8738D16DA28575A7F8DB9BE4989314F0340FDF2453A5DA1757CD7F26BE84D
      38755AEDCC936ABB3A40A701A05A99229DBAD03D51B1B2755A7B4F751CA7D3DC
      4706A02D39229DA8D0CBE5B2BF429B6C93A58CD669A1D3005A913CD22A748A7B
      B93568EA50EB8FD1232BD666B3F10D4E894E03409DD2463AD10CAD426BC9FE18
      FD52B14439F1CD4E69B7DBF9A39696A7D39CF706D08484914E37438F50E85B74
      3A053A0DA07EA9229D6E86D681D51F6324793A5DCFBECDD669BD34A1D300AA95
      24D29CE54E21F50788AA58CBE5528FE28F575A9E4E0B9D0650ADF891A6D0E9D8
      3752FB1E49409DB60F6EF3C72B8D4E03185CE44853E8D432747ABBDDD6532CCE
      7B031859CC4853E83C52775AF6FB7D3DDF53C23C0D6058D1224DA1734ADDE9E5
      72A92EFA83D5814E0318509C4853E8FC3274BAB65C71DE1BC06822449A429762
      9D56577C97C5A622D6F6E5DCCCD30086121A690A5D56D2F7656998DEEFF7B57D
      01289D06308EA04853E81A243DEFADE742C3F47B655F034AA7010C627EA42974
      3DD469EDB744E7BD379B8D3F4C4DB83E0D600433234DA16BA3FD96EEE2749D1F
      C5CA3C0DA07B73224DA1EBA49CF8AE8C6D5DD3C790DD52A7B7DBADAF65327A94
      DA4EF80318C4D3915647F96EAB6AA5FB1E0EB5B0B63BC84CD24E73C61B4059CF
      459A19BA7EE9E6E93A876949D7690A0DA0AC27229DA8D05A26858E48F36EA22B
      B5EBF5BADA62A5E834850650DCA39166866E45BA4FBAB62FB2ACF3A4B744EC34
      67B90154E2A148A72B749DB70DB7CE3A9DE2CDD37ACA6ABE852A56A72934804A
      FC1E690ADD22A554A5D14EF6DD1D8F2AD877A72934807AFC1269153AD1BDDC14
      3A35EB74F4A74F03BA42E88F51A5904E53680055B9176966E8D6A9D3294E7AAB
      64FE00B59AD7690A0DA0363F463A51A1B54C0A9D933A1DFDA4B79EC4CA876979
      AAD3DC2906A04EDF479A19BA1B8AF4F1788CFE6CEA27A4E62BD3E6F14E536800
      75FA26D25C87EECCE5725184E23EA7AA7E6D5F35FDAD5F3BCD0C0DA0669F23CD
      0CDD25B52AFAC569B5ADFE615AEE779A4203A8D95F91E63A74C74EA7933F1F91
      A8FA4D0CD3F253A7293480CAFD1B6966E8BE69EA5593FC598961B95CEA67C697
      5EBDAF9DA6D000EAE7914E716F91304357454D8AFB71A19BCDA695615A6E3B4D
      A10134E14FA413155A931685AE8D9E117F7A2251F97CD12DB04E536800ADF88F
      0A9DE25E6EA32434716FD150E20ED36A5EB55FB9F12D8DFE0D4DFF0006F79F14
      33F4955D90A6D3F5D073A12132E293AEA7B8AD48034043FE9CEEF6C36D1A74BA
      366AAAC6DF88A74F1ABA7D0C00DAE2378EF9E1360D3A5D1B0DD3FEDCC4304D13
      C33400A4F0EF5BB0FC889B069DAE8A9E088DBF8BC5C29F9E301ACADBBA7D0C00
      5AF16FA4C50FBA69A8D3BB463EA36A04CAAA9E117F6EC228D2C7E391671600A2
      FB2BD2E2C7DD34E87455F6F1DE8E354D134F2B0044F739D2E2C7DD345E5E5EE8
      7425220ED3EBF59ACBD20010DD3791163FF4A6C13C5D093D05B1DE33BD582CB8
      C71B00A2FB3ED2E247DF34E87425344C47792F9622BDE7D3E50020B61F232D7E
      004E834ED7E072B96C369BF0DBBCB5043DA19CF10680B8EE455AFC189C06D7A7
      8BD3CE3F1C0EFE7C84D1B3C9C76D02405CBF445AFC189C06F37471E7F379BD5E
      FBF31160D9D437570240137E8FB4F861380DE6E9E2A6698AF2C1267C5E0D00C4
      F550A4C50FC369304F97753A9DA2DC3EC6E78302405C8F465AFC489C069D2EE8
      7C3E2BD2E1C3F47ABDE6190480889E88B4F8C1380D3A5D8AC6DF2867BC5F5E5E
      D47B9E410088E5B9488B1F8FD3A0D3A5847F44A835FE743AF9120100C19E8EB4
      D84139113A9D9FF6B62660CDC1FE1CCCA54E2BD23C770010CB9C488B1F95D3A0
      D3F9BDBDBD69B7FB131080AFC302808866465AFCA89C06EFCBCA2CD665693D6B
      BE440040B0F991163F30A7C13C9D93F6F37EBF0F8FF476BBF52502008205455A
      FCD89C069DCEE9703884BF5B7AB3D9F07C01402CA191163F3CA741A7B309FF46
      2C0DE2BC551A00228A1069F183741A743A8FF3F9EC7B3C8022CD878E01402C71
      222D7E904E834E67A0486B3FFB1E9F4593F4CBCB0B91068058A2455AFC509D06
      9D4E4D71DD6C36BEBB67B148F3859500104BCC488B1FADD3A0D34929D24A6CE0
      0DDE9CEE06808822475AFC689D069D4E477B55890D89B4FEAD9E20220D00B1C4
      8FB4F8313B0D3A9D4894D3DDCBE592D3DD00104B92488B1FB6D3E0F3C85250A4
      032769619206808852455AFCB09D06F374748AABF62AD7A401A01E09232D7EE4
      4E83793AAEF0D3DDA22510690088256DA4C50FDE69304F4764EF930EBC716C9A
      269E0E00882579A4C50FE169D0E9585E5F5F7D9F06D8EFF7BE380040B01C9116
      3F84A741A7A3389D4EE15FB0C1F74903404499222D7E144FC33ACDD5D010DA81
      81778DC9F97C26D200104BBE488B1FC8D3E03EB2107A7DB3DD6E7D5706787D7D
      F525020082658DB4F8B13C0DCE7BCFA60958AF727C3FCEB55EAFF92413008828
      77A4C58FE86970DE7B06BDAC8912E9CD66C32B240088A840A4C50FEA69304F3F
      4BFB2AFC82F472B9DCEFF7EC760088A84CA4C50FED69D0E9A744F91813E18234
      00C4552CD2E287F63438EFFDB8C3E1E07B6D2E4DE1DAE1441A00E22A1969F163
      7C1A76BF379DBE2FD67DDD5A882F11001049E1488B1FE3D3609EFED5F97C0EFF
      0C132D41E338D7170020AEF291163FD2A7C13C7D87768B764EF867986827B387
      0120BA2A222D7EB04F834E7F4B83AFF6C97ABDF6DD34971ABFDD6ED9BD00105D
      2D91163FE4A741A7BFB5DFEF7D070550A48FC7A32F1100104F4591163FEAA741
      A73F399D4EABD5CAF74E00CDE2E7F3D9170A0088A7AE488B1FF8D3A0D357EFEF
      EF51C668D12EF5850200A2AA2ED2E2C7FE34E8B489F2EDD1A2FDC9E775034022
      35465ABC0069D0E9F3F91CE523C6649A265EF100402295465A3C02698CDC696D
      F57EBF0F7F6FB4E153C600209D7A232DDE8134C6ECF4FBFBFBE572D1B6FB5E08
      C385030048AAEA488BD7208D313B1DEB44B77DCA982F14009040ED91166F421A
      A3755A1BEB5B1E6C9A265F2800208D06222D9E8534C6E9F47EBF8FF2C668D172
      CEE7331FD60D0049B51169F138A43142A75F5F5FC33F01D42C974B6EEA06800C
      9A89B47822D2E8BBD32A7494EFA334DA57BC371A00326829D2E29548A3D74E6B
      8B22165AF8A46E00C8A3B1488B87228D2E3B7D381C7CF36298A6894FEA06803C
      DA8BB4782ED2E8ACD3710BBD5C2E19A301209B26232D1E8D34BAE974DC428B76
      8B2F1A00905EAB9116EF461A1D74FA743AF9C644324D13F78B01404E0D475ABC
      1E6934DDE9D7D7D7589F2C66B4378EC7236F8C06809CDA8EB47843D268B4D356
      E8585FA121B61F28340064D67CA4C54B9246739D8E5E6859AFD7141A00F2EB21
      D2E2314943C16BA5D3290AAD97294D5F9B078076751269F1A4A4D1C43C9DA8D0
      A7D389311A008AE827D2E26149A3F24E47BF534CD4FBC3E1C01DDD00504A5791
      16CF4B1AD5763AC50C2D5A26850680827A8BB47861D2A8B0D3E90AAD25FB6300
      004AE830D2E29D49A3AA4EABA3EBF53A6EA1178B851648A101A0B83E232D1E9C
      342AE974A2195AF8806E00A841B791160F4E1AC53B4DA101A07B3D475A3C3B69
      2890A53A4DA10160049D475A3C3E691499A7D3157ABFDFF3966800A847FF9116
      4F501AEAF476BBCDD6E97485D656F0862B00A8CA1091160F511AD93A9DB4D05A
      B83F0C00A00EA3445A3C476964E874BA424FD344A101A04203455A3C4A6924ED
      343334000C68AC488BA7298D449DA6D00030A6E1222D1EA834A2779A4203C0B0
      468CB478A6D288D8690A0D00231B34D2E2B14A234AA7ADD0BEC4A82834003461
      DC488B272B8DC04E33430300868EB478B8D298DD690A0D0090D1232D9EAF3466
      74DA0AEDFF3E2A0A0D006D21D27F78C4D278AAD3141A007045A49DA72C8D073B
      6D85E62C3700C010E97F79D0D2F8B5D3141A00F00991FE8B672D8D3B9D5644D7
      EB35850600DC22D29F79DCD2F8B6D3CCD000806F11E96F78E2D2F8D4690A0D00
      F80991FE9E872E8D6BA7293400E00E22FD23CF5D1AEAB4F2BC5EAFFDCF515168
      00E80391BEC7A397C6E283FF211E0A0D00DD20D2BFF0F435824203404F88F4EF
      3C80D5A3D000D01922FD10CF60C5283400F487483FCA6358250A0D005D22D24F
      F0245686420340AF88F4733C8CD5A0D000D03122FD34CF6305283400F48D48CF
      E1912C8A420340F788F44C9ECA422834008C8048CFE7C1CC8E4203C020887410
      CF6646141A00C641A443793CB3A0D0003014221D812734B1699A2834000C8548
      C7E1214D864203C0808874349ED30438CB0D006322D2317954A3A2D000302C22
      1D99A735120A0D002323D2F1796083711D1A000647A493F0CC06A0D00000229D
      8AC776160A0D0010229D9027F749141A006088745A1EDE87516800C015914ECE
      F3FB000A0D00B845A473F008DF45A101009F10E94C3CC53FA0D00080AF88743E
      1EE42FACD0EFEFEFFEF70000F840A4B3F22CDFA0D000809F10E9DC3CCE1F2834
      00E00E225D008506003C82489741A10100BFF8DFFFFE0F9499CE037DCD732A00
      00000049454E44AE426082}
    TabOrder = 2
    Visible = False
    Height = 101
    Width = 140
  end
  object pnlWarning: TPanel
    Left = 0
    Top = 46
    Width = 801
    Height = 69
    Align = alTop
    AutoSize = True
    BevelEdges = [beBottom]
    BevelKind = bkFlat
    BevelOuter = bvNone
    Color = clInfoBk
    ParentBackground = False
    TabOrder = 3
    Visible = False
    object lbl1: TLabel
      Left = 61
      Top = 6
      Width = 523
      Height = 16
      Caption = 
        'All tax reports will appear in DRAFT mode until the following st' +
        'eps have been completed:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblCheckListMessage: TLabel
      Left = 10
      Top = 26
      Width = 446
      Height = 16
      Caption = 
        '* All items in the Year End Checklist have been completed for ea' +
        'ch account.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblEndTaxYrMessage: TLabel
      Left = 10
      Top = 46
      Width = 326
      Height = 16
      Caption = '* The End Tax Year procedure has been run on this file.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 9
      Top = 6
      Width = 46
      Height = 16
      Caption = 'NOTE:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object pnlHelp: TPanel
      Left = 706
      Top = 0
      Width = 95
      Height = 67
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object btnYECHelp: TcxButton
        Left = 19
        Top = 23
        Width = 59
        Height = 25
        Hint = 'Ending Tax Year'
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Help '
        LookAndFeel.Kind = lfOffice11
        OptionsImage.ImageIndex = 0
        OptionsImage.Images = ImageList1
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        OnClick = btnYECHelpClick
      end
    end
  end
  object frxPDFExport1: TfrxPDFExport
    ShowDialog = False
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    DataOnly = False
    EmbedFontsIfProtected = False
    OpenAfterExport = False
    PrintOptimized = True
    Outline = False
    Background = True
    HTMLTags = False
    Quality = 50
    Transparency = False
    Author = 'FastReport'
    Subject = 'FastReport PDF export'
    ProtectionFlags = [ePrint, eModify, eCopy, eAnnot]
    HideToolbar = False
    HideMenubar = False
    HideWindowUI = False
    FitWindow = False
    CenterWindow = False
    PrintScaling = False
    PdfA = False
    PDFStandard = psNone
    PDFVersion = pv17
    Left = 595
    Top = 426
  end
  object MainMenu1: TMainMenu
    Images = tbImages
    Left = 52
    Top = 426
    object mnuFile: TMenuItem
      Caption = '&Report'
      object mnuFileCopy: TMenuItem
        Action = actnFile_Copy
        Caption = '&Copy Rows to Clipboard'
      end
      object mnuFileSavePDF: TMenuItem
        Action = actnFile_SaveToPDF
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object mnuFileExit: TMenuItem
        Action = actnFile_Exit
      end
    end
    object mnuPage: TMenuItem
      Caption = 'Pa&ge'
      object mnuPageFirst: TMenuItem
        Action = actnPage_First
        ImageIndex = 1
      end
      object mnuPagePrevious: TMenuItem
        Action = actnPage_Previous
        ImageIndex = 2
      end
      object mnuPageNext: TMenuItem
        Action = actnPage_Next
        ImageIndex = 3
      end
      object mnuPageLast: TMenuItem
        Action = actnPage_Last
        ImageIndex = 4
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object mnuPageGoto: TMenuItem
        Caption = '&Go to Page #'
        Hint = 'Go to specified page'
        ImageIndex = 6
        ShortCut = 16455
      end
    end
    object mnuPrint: TMenuItem
      Caption = '&Print'
      object Print1: TMenuItem
        Action = actnFile_Print
        ImageIndex = 11
      end
      object PrinterSettings1: TMenuItem
        Action = actnPrint_Settings
      end
    end
    object mnuZoom: TMenuItem
      Caption = '&Zoom'
      object mnuZoomIn: TMenuItem
        Action = actnZoom_In
        ImageIndex = 5
      end
      object mnuZoomOut: TMenuItem
        Action = actnZoom_Out
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object mnuZoomFitWidth: TMenuItem
        Action = actnZoom_PageWidth
        ImageIndex = 10
      end
      object mnuZoomMultiplePages: TMenuItem
        Action = actnZoom_Page100
        Caption = 'Restore to 100%'
        ImageIndex = 9
      end
      object mnuZoomFitPage: TMenuItem
        Action = actnZoom_Page
        Caption = 'Whole &Page'
        ImageIndex = 8
      end
    end
    object mnuExports: TMenuItem
      Caption = 'Exports'
      object mnuTurboTax: TMenuItem
        Action = actnExport_TurboTax
      end
      object mnuTaxAct: TMenuItem
        Action = actnExport_TaxACT
      end
    end
  end
  object ActionList1: TActionList
    Left = 269
    Top = 426
    object actnFile_Print: TAction
      Category = 'File'
      Caption = '&Print'
      Hint = 'Print report'
      ImageIndex = 8
      ShortCut = 16464
      OnExecute = actnFile_PrintExecute
    end
    object actnFile_SaveToPDF: TAction
      Category = 'File'
      Caption = '&Save As PDF'
      Hint = 'Save report as PDF File'
      ShortCut = 16467
      OnExecute = actnFile_SaveToPDFExecute
    end
    object actnFile_Exit: TAction
      Category = 'File'
      Caption = 'E&xit'
      Hint = 'Exit Report Preview'
      OnExecute = actnFile_ExitExecute
    end
    object actnPage_First: TAction
      Category = 'Page'
      Caption = '&First'
      Hint = 'Move to first page'
      ImageIndex = 10
      ShortCut = 36
      OnExecute = actnPage_FirstExecute
    end
    object actnPage_Next: TAction
      Category = 'Page'
      Caption = '&Next'
      Hint = 'Move to next page'
      ImageIndex = 14
      OnExecute = actnPage_NextExecute
    end
    object actnPage_Previous: TAction
      Category = 'Page'
      Caption = 'P&revious'
      Hint = 'Move to previous page'
      ImageIndex = 12
      OnExecute = actnPage_PreviousExecute
    end
    object actnPage_Last: TAction
      Category = 'Page'
      Caption = '&Last'
      Hint = 'Move to last page'
      ImageIndex = 16
      ShortCut = 35
      OnExecute = actnPage_LastExecute
    end
    object actnZoom_In: TAction
      Category = 'Zoom'
      Caption = 'Zoom &In'
      Hint = 'Zoom In '
      ImageIndex = 20
      ShortCut = 120
      OnExecute = actnZoom_InExecute
    end
    object actnZoom_Out: TAction
      Category = 'Zoom'
      Caption = 'Zoom &Out'
      Hint = 'Zoom Out'
      ImageIndex = 0
      ShortCut = 121
      OnExecute = actnZoom_OutExecute
    end
    object actnZoom_PageWidth: TAction
      Category = 'Zoom'
      Caption = 'Fit to Page &Width'
      Hint = 'Zoom to fit page width'
      ImageIndex = 32
      ShortCut = 16471
      OnExecute = actnZoom_PageWidthExecute
    end
    object actnZoom_Page100: TAction
      Category = 'Zoom'
      Caption = 'Fit to 100&'
      Hint = 'Zoom to 100%'
      ImageIndex = 18
      ShortCut = 16456
      OnExecute = actnZoom_Page100Execute
    end
    object actnZoom_Page: TAction
      Category = 'Zoom'
      Caption = 'Fit to &Page'
      Hint = 'Zoom to fit page'
      ImageIndex = 30
      ShortCut = 16454
      OnExecute = actnZoom_PageExecute
    end
    object actnFile_Copy: TAction
      Category = 'File'
      Caption = 'Copy'
      Hint = 'Copy Rows to Clipboard'
      ShortCut = 16451
      OnExecute = actnFile_CopyExecute
    end
    object actnPrint_Settings: TAction
      Category = 'Print'
      Caption = 'Print Settings'
      Hint = 'Open the Print Setup Dialog'
      ImageIndex = 13
      OnExecute = actnPrint_SettingsExecute
    end
    object actnExport_TurboTax: TAction
      Category = 'Exports'
      Caption = 'TurboTax'
      Hint = 'Export to Turbo Tax TXF File'
      OnExecute = actnExport_TurboTaxExecute
    end
    object actnExport_TaxACT: TAction
      Category = 'Exports'
      Caption = 'TaxACT'
      Hint = 'Export to TaxACT CSV File'
      OnExecute = actnExport_TaxACTExecute
    end
  end
  object tbImages: TImageList
    Left = 378
    Top = 426
    Bitmap = {
      494C01010D00F000040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000004000000001002000000000000040
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000CBCBCB35B7B7B749F8F8F807000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000E4E4E41BADB3B5FF8D9496FF5F6365FAB8B9B9480000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000092949488BEBEBE43999E9FB2E4EEF1FFE5F0F2FF697071FFE7E7
      E718000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000008F8D8C7D6661
      5EBC66615DBB8F9495FC7D8689FF434546D6505657FED8E5E6FFE6EFF2FF7C7E
      7E94000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000857872BD8974
      68FF8C7970FF796F69FFDEE8EAFF61686AFFBCC7C9FFDBE6E9FFDEE9EBFF8585
      868D000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000A2A2A26D727272C0544F4CE38888
      83FF637A77FF6B8481FF838D8EFFDAE1E4FFE2E9EBFFDBE2E6FFD9E4E6FF6267
      69FD4E4E4EC5F8F8F80700000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008F9090CAB6B6B6FF5A5A59FF7774
      6EFF708A87FF7A9393FF778D97FF61738FFF606D6CFF696F6EFFB4BBBEFFD6E3
      E5FF81898DFF9A9A9B74FCFCFC03000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008E8F90F4B2B3B5FF474848FF4541
      3FFF505353FF4E5253FF4C4D4FFF4A4D51FF4B4E4FFF4B4A48FF393A3AFF949C
      9FFFA5ADD3FF585D84FF747677A2000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000999A9AFFADAEB1FFADADAEFFABA9
      A8FFA9A8A8FFA5A5A5FFAAA8A7FFABA8A8FFABA9A8FFABA8A7FFA9A8A8FFADB0
      B1FF66697CFFBAC8CEFF8C9798FFF0F0F00F0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CACBCCF7E4E8ECFFECF0F2FFE9EE
      F0FFDFE4E7FFE1E5E9FFE1E5EAFFE2E6E9FFE3E6EAFFEFF1F4FFF2F4F6FFABAE
      B0FFE4E6E7FFA7A9A9679CA1A18C000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000ACAEAF98D7DDE1FFE0E4E8FFE2E5
      E9FFD7DEE0FFD8DADCFFD6DCDFFFDEE1E3FFE1E6E8FFE5E8EAFFDFE4E7FFDEE4
      E8FFC4C9CBFF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000EEEEEE12CCD3D7FFC2CACDFF7B74
      6FFFCFDDDFFFCEDADCFFD0DDE0FF626363FF636261FF969593FFAEB3B5FFD8DF
      E3FF9A9B9CB00000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000009EA3A4D7A3A8ABFC8381
      7EFFDDECEFFFE5F2F5FFE1F1F3FFE0F0F1FFDDEDEFFFA2A3A0FF949C9FFCA6AD
      B0FEEEEEEE110000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000989B
      99FFE5F3F6FFF0FDFFFFE9F8F9FFE1F1F4FFDFEFF0FFA4A8A6FFEBEBEB140000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FAFAFA05A4AA
      AAFFE4F2F5FFEEFBFEFFEDFBFEFFE4F3F6FFDFEFF2FFB6BCBAFFD8D8D8270000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000EEEEEE11987C
      6CFF997C6CFF9C7E6DFFA1816EFFA0816EFF9E7F6CFF9D7E6CFFD2D2D22F0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C6000000
      0000C6C6C6000000000000000000000000000000000084840000848484008484
      0000848484008484000084848400848400008484840084840000848484008484
      0000848484008484000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C60000000000000000000000000084848400848400008484
      8400000000000000000000000000000000000000000000000000000000008484
      8400848400008484840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C60000FFFF0000FFFF0000FFFF00C6C6C600C6C6
      C600000000000000000000000000000000000000000084840000848484008484
      0000000000000000000000000000000000000000000000000000000000008484
      0000848484008484000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600848484008484840084848400C6C6C600C6C6
      C60000000000C6C6C60000000000000000000000000084848400848400008484
      8400000000000000000084000000840000008400000000000000000000008484
      8400848400008484840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C600C6C6C600000000000000000084840000848484008484
      0000000000000000000000000000000000000000000000000000000000008484
      0000848484008484000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C6000000
      0000C6C6C60000000000C6C6C600000000000000000084848400848400008484
      8400000000000000000084000000840000000000000000000000000000008484
      8400848400008484840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400000000000000000000008400
      0000000000000000000000000000000000000000000000000000000000008400
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C6C6
      C60000000000C6C6C60000000000000000000000000084840000848484008484
      0000000000000000000000000000000000000000000000000000000000008484
      0000848484008484000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400000000000000840000008400
      0000000000000000000000000000000000000000000000000000000000008400
      000084000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000C6C6C60000000000C6C6C600000000000000000084848400848400008484
      8400000000000000000084000000840000008400000000000000000000008484
      8400848400008484840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400000084000000840000008400
      0000840000000000000000000000000000000000000000000000840000008400
      0000840000008400000000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000084840000848484008484
      0000000000000000000000000000000000000000000000000000000000008484
      0000848484008484000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400000000000000840000008400
      0000000000000000000000000000000000000000000000000000000000008400
      0000840000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000084848400848400008484
      8400000000000000000000000000000000000000000000000000000000008484
      8400848400008484840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400000000000000000000008400
      0000000000000000000000000000000000000000000000000000000000008400
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000084840000848484008484
      0000848484008484000084848400848400008484840084840000848484008484
      0000848484008484000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF00000084000000840000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000C6FFCE00C6FF
      CE00C6FFCE00C6FFCE00C6FFCE00C6FFCE00C6C6C600C6FFCE00C6FFCE00C6FF
      CE00C6FFCE00C6FFCE00C6FFCE000000000000000000FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      000084000000FF00000084000000000000000000000084848400848484008484
      8400848484008484840084848400848484008484840084848400FFFFFF000000
      0000000000000000000000000000000000000000000000000000C6FFCE00C6FF
      CE00C6FFCE00C6FFCE00C6FFCE00C6FFCE00C6C6C600C6FFCE00C6FFCE00C6FF
      CE00C6FFCE00C6FFCE00C6FFCE0000000000848484008400000084000000FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000848484008400000084000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF0000008400
      0000FF00000084000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000C6FFCE00C6FF
      CE00C6FFCE00C6FFCE00C6FFCE00C6FFCE00C6C6C600C6FFCE00C6FFCE00C6FF
      CE00C6FFCE00C6FFCE00C6FFCE00000000008484840084000000840000008400
      000084000000FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000848484008400000084000000FFFFFF000000000000000000000000000000
      000000000000000000000000000000000000000000008484840084000000FF00
      0000840000000000000000000000000000000000000084848400848484008484
      8400848484008484840084848400848484008484840084848400FFFFFF000000
      0000000084000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C6C6C600FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000008484840084000000840000008400
      0000840000008400000084000000FFFFFF00FFFFFF00FFFFFF00000000000000
      0000848484008400000084000000FFFFFF000000000000000000000000000000
      00008484840084848400848484008484840084848400FFFFFF00C6C6C6008400
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000084000000840000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C6C6C600FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000008484840084000000840000008400
      00008400000084000000840000008400000084000000FFFFFF00FFFFFF00FFFF
      FF00848484008400000084000000FFFFFF000000000000000000000000000000
      00000000000000000000000000000000000000000000C6C6C600848484000000
      0000000000000000000000000000000000000000000084848400848484008484
      8400848484008484840084848400848484008484840084848400FFFFFF000000
      0000000084000000840000008400000000000000000000000000C6FFCE00C6FF
      CE00C6FFCE00C6FFCE00C6FFCE00C6FFCE00C6C6C600C6FFCE00C6FFCE00C6FF
      CE00C6FFCE00C6FFCE00C6FFCE00000000008484840084000000840000008400
      000084000000840000008400000084000000840000008400000084000000FFFF
      FF00848484008400000084000000FFFFFF00000000000000000000000000C6C6
      C600FFFF0000FFFFFF00FFFF0000FFFF00008484000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000084000000840000008400000084000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C6C6C600FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000008484840084000000840000008400
      0000840000008400000084000000840000008400000084000000840000000000
      0000848484008400000084000000FFFFFF000000000084848400C6C6C600FFFF
      0000FFFFFF008400000084000000FFFF0000FFFFFF0084840000000000000000
      0000000000000000000000000000000000000000000084848400848484008484
      8400848484008484840084848400848484008484840084848400FFFFFF000000
      0000000084000000840000008400000000000000000000000000000000000000
      000000000000000000000000000000000000C6C6C600FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000008484840084000000840000008400
      0000840000008400000084000000840000008400000084848400000000000000
      0000848484008400000084000000FFFFFF000000000084848400FFFF0000FFFF
      FF00FFFF00008400000084000000FFFF0000FFFF0000FFFF0000000000008484
      84000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      00000000840000008400000000000000000031D60000218C0000218C0000218C
      0000218C0000218C0000218C00006B6B6B00BD390000BD390000BD390000BD39
      0000BD390000BD390000BD390000000000008484840084000000840000008400
      0000840000008400000084000000848484000000000000000000000000000000
      0000848484008400000084000000FFFFFF000000000084848400FFFFFF008400
      00008400000084000000840000008400000084000000FFFF0000000000008484
      84000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      00000000840000000000000000000000000031D60000218C0000FFFFFF00218C
      0000218C0000FFFFFF00FFFFFF006B6B6B00FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000000000008484840084000000840000008400
      0000840000008484840000000000000000000000000000000000000000000000
      0000848484008400000084000000FFFFFF000000000084848400FFFFFF008400
      00008400000084000000840000008400000084000000FFFF0000000000008484
      84000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      00000000000000000000000000000000000031D60000218C0000FFFFFF00218C
      0000218C0000FFFFFF00218C00006B6B6B00C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600000000008484840084000000840000008484
      8400000000000000000000000000000000000000000000000000000000000000
      0000848484008400000084000000FFFFFF000000000084848400FFFF0000FFFF
      FF00FFFFFF008400000084000000FFFFFF00FFFF0000FFFFFF00000000008484
      8400000000000000000000000000000000000000000084848400848484008484
      84008484840084848400848484008484840084848400FFFFFF00FFFFFF000000
      00000000000000000000000000000000000031D60000218C0000FFFFFF00218C
      0000218C0000FFFFFF00218C00006B6B6B00BD390000BD390000BD390000BD39
      0000BD390000BD390000BD390000BD3900008484840084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000084848400848484008484840000000000000000000000000084848400FFFF
      0000FFFFFF008400000084000000FFFF0000FFFFFF0084840000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      00000000000000000000000000000000000031D60000FFFFFF00FFFFFF00FFFF
      FF00218C0000FFFFFF00218C00006B6B6B00BD390000BD390000BD390000BD39
      0000BD390000BD390000BD390000BD3900000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400FFFF0000FFFFFF00FFFF0000FFFFFF008484000000000000000000000000
      0000000000000000000000000000000000000000000084848400848484008484
      8400848484008484840084848400848484008484840084848400FFFFFF000000
      00000000000000000000000000000000000031D60000218C0000218C0000218C
      0000218C0000218C0000218C00006B6B6B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848484008484840084848400848484008484840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000031D6000031D6000031D6000031D6
      000031D6000031D6000031D6000031D600000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF0000008400000084000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      000084000000FF000000840000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF0000008400
      0000FF000000840000000000000000000000848484008400000084000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF008400000084000000FFFFFF000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00840000008400
      0000FFFFFF000000000000000000000000000000000000000000000000008484
      84008400000084000000FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000008484840084000000FF00
      000084000000000000000000000000000000848484008400000084000000FFFF
      FF00000000000000000000000000000000000000000000000000FFFFFF008400
      0000840000008400000084000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000FFFFFF008400000084000000840000008400
      0000FFFFFF000000000000000000000000000000000000000000000000008484
      840084000000840000008400000084000000FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008484840084848400848484008484840084848400FFFFFF00C6C6C6008400
      000000000000000000000000000000000000848484008400000084000000FFFF
      FF0000000000000000000000000000000000FFFFFF0084000000840000008400
      0000840000008400000084000000FFFFFF000000000000000000000000000000
      000000000000FFFFFF0084000000840000008400000084000000840000008400
      0000FFFFFF000000000000000000000000000000000000000000000000008484
      8400840000008400000084000000840000008400000084000000FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C6C6C600848484000000
      000000000000000000000000000000000000848484008400000084000000FFFF
      FF000000000000000000FFFFFF00840000008400000084000000840000008400
      0000840000008400000084000000FFFFFF00000000000000000000000000FFFF
      FF00840000008400000084000000840000008400000084000000840000008400
      0000FFFFFF000000000000000000000000000000000000000000000000008484
      8400840000008400000084000000840000008400000084000000840000008400
      0000FFFFFF00FFFFFF00FFFFFF0000000000000000000000000000000000C6C6
      C600FFFF0000FFFFFF00FFFF0000FFFF00008484000000000000000000000000
      000000000000000000000000000000000000848484008400000084000000FFFF
      FF00000000008400000084000000840000008400000084000000840000008400
      0000840000008400000084000000FFFFFF0000000000FFFFFF00840000008400
      0000840000008400000084000000840000008400000084000000840000008400
      0000FFFFFF000000000000000000000000000000000000000000000000008484
      8400840000008400000084000000840000008400000084000000840000008400
      00008400000084000000FFFFFF00000000000000000084848400C6C6C600FFFF
      0000FFFFFF00FFFF0000FFFFFF00FFFF0000FFFFFF0084840000000000000000
      000000000000000000000000000000000000848484008400000084000000FFFF
      FF00848484008400000084000000840000008400000084000000840000008400
      0000840000008400000084000000FFFFFF000000000084848400840000008400
      0000840000008400000084000000840000008400000084000000840000008400
      0000FFFFFF000000000000000000000000000000000000000000000000008484
      8400840000008400000084000000840000008400000084000000840000008400
      0000840000008400000000000000000000000000000084848400FFFF0000FFFF
      FF00FFFF0000FFFFFF00FFFF0000FFFFFF00FFFF0000FFFF0000000000008484
      840000000000000000000000000000000000848484008400000084000000FFFF
      FF00848484008484840084848400840000008400000084000000840000008400
      0000840000008400000084000000FFFFFF000000000084848400848484008484
      8400840000008400000084000000840000008400000084000000840000008400
      0000FFFFFF000000000000000000000000000000000000000000000000008484
      8400840000008400000084000000840000008400000084000000840000008400
      0000848484000000000000000000000000000000000084848400FFFFFF008400
      00008400000084000000840000008400000084000000FFFF0000000000008484
      840000000000000000000000000000000000848484008400000084000000FFFF
      FF00000000000000000084848400848484008484840084000000840000008400
      0000840000008400000084000000FFFFFF000000000000000000000000008484
      8400848484008484840084000000840000008400000084000000840000008400
      0000FFFFFF000000000000000000000000000000000000000000000000008484
      8400840000008400000084000000840000008400000084000000848484000000
      0000000000000000000000000000000000000000000084848400FFFFFF008400
      00008400000084000000840000008400000084000000FFFF0000000000008484
      840000000000000000000000000000000000848484008400000084000000FFFF
      FF00000000000000000000000000000000008484840084848400848484008400
      0000840000008400000084000000FFFFFF000000000000000000000000000000
      0000000000008484840084848400848484008400000084000000840000008400
      0000FFFFFF000000000000000000000000000000000000000000000000008484
      8400840000008400000084000000840000008484840000000000000000000000
      0000000000000000000000000000000000000000000084848400FFFF0000FFFF
      FF00FFFFFF00FFFFFF00FFFF0000FFFFFF00FFFF0000FFFFFF00000000008484
      840000000000000000000000000000000000848484008400000084000000FFFF
      FF00000000000000000000000000000000000000000000000000848484008484
      8400848484008400000084000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000848484008484840084848400840000008400
      0000FFFFFF000000000000000000000000000000000000000000000000008484
      8400840000008400000084848400000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000084848400FFFF
      0000FFFFFF00FFFFFF00FFFFFF00FFFF0000FFFFFF0084840000000000000000
      0000000000000000000000000000000000008484840084848400848484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848484008484840084848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400848484008484
      8400000000000000000000000000000000000000000000000000000000008484
      8400848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400FFFF0000FFFFFF00FFFF0000FFFFFF008484000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848484008484840084848400848484008484840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000400000000100010000000000000200000000000000000000
      000000000000000000000000FFFFFF00FE3F000000000000FC1F000000000000
      F80F000000000000C00F000000000000C00F0000000000000003000000000000
      0001000000000000000100000000000000000000000000000001000000000000
      000700000000000000070000000000008007000000000000E01F000000000000
      C01F000000000000C01F000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFC007
      800380038003800300017FFD7FFD000100014005781D000107C17FFD7FFD0001
      04414005783D000007C17FFD7FFD000004C14005686D800007C17FFD4FE5C000
      044140050441E00107C17FFD4FE5E00700014005682DF00700017FFD7FFDF003
      800380038003F803FFFFFFFFFFFFFFFFFFFFFFF9FFFFFFFFFFFFFFF0801FC000
      8FF8FFE0801FC00003F0FFC1801FC00000F0FF838017C0000030F0078013C000
      0000E00F8011C0000000C01F8010C0000010801F801100000030800F80130000
      00F0800F8017000003F0800F801F00000FF0800F801F00003FF1C01F801F0000
      FFFFE03F801F00FFFFFFF07FFFFF00FFFFF9FFFFFFFFFFFFFFF0FFFFFFFFFFFF
      FFE08FFCFFE7F1FFFFC10FF0FF87E07FFF830FC0FE07E01FF0070F00F807E007
      E00F0C00E007E001C01F08008007E001801F00008007E003800F00008007E007
      800F0C00E007E01F800F0F00F807E07F800F0FC0FE07E1FFC01F1FF1FF8FE7FF
      E03FFFFFFFFFFFFFF07FFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object PopupMenu1: TPopupMenu
    Left = 161
    Top = 426
    object mnuPopZoomIn: TMenuItem
      Action = actnZoom_In
    end
    object mnuPopZoomOut: TMenuItem
      Action = actnZoom_Out
    end
  end
  object PrintDialog1: TPrintDialog
    OnShow = PrintDialog1Show
    Options = [poPageNums]
    Left = 703
    Top = 426
  end
  object frxCheckBoxObject1: TfrxCheckBoxObject
    Left = 812
    Top = 426
  end
  object cxStyleRepository1: TcxStyleRepository
    Left = 666
    Top = 282
    PixelsPerInch = 96
    object cxStyle1: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -8
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      TextColor = clInfoText
    end
  end
  object cxStyleRepository2: TcxStyleRepository
    Left = 792
    Top = 282
    PixelsPerInch = 96
    object cxStyle2: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      TextColor = clInfoText
    end
  end
  object ImageList1: TImageList
    Left = 486
    Top = 426
    Bitmap = {
      494C010102000800040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      000000000000000000000000000000000000000000000000000000000000E5E5
      E500C0C0C000666666004C4C4C004C4C4C004C4C4C004C4C4C004C4C4C008080
      8000CCCCCC00E2EFF1000000000000000000000000000000000000000000CCCC
      CC00999999009999990099999900999999009999990099999900999999009999
      9900CCCCCC00E2EFF10000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000E5E5E500B2B2
      B200ECC6D900E5E5E500E5E5E500E5E5E500E5E5E500E5E5E500C0C0C0004C4C
      4C00646F7100B2B2B200E5E5E500000000000000000000000000CCCCCC009999
      9900ECC6D900CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC009999
      990099999900B2B2B200CCCCCC00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E5E5E500C0C0C000E5E5
      E500FFFFFF00E5E5E500CC999900CC999900CCCCCC00E2EFF100FFFFFF00E5E5
      E5008080800066666600B2B2B200E2EFF10000000000CCCCCC0099999900CCCC
      CC00FFFFFF00CCCCCC00CCCCCC00CCCCCC00CCCCCC00E2EFF100FFFFFF00CCCC
      CC009999990099999900B2B2B200E2EFF1000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000CCCCCC00E5E5E500FFFF
      FF00CC999900CC660000CC663300CC999900CC663300CC663300CC999900FFFF
      FF00E5E5E500646F7100646F7100CCCCCC000000000099999900CCCCCC00FFFF
      FF00CCCCCC009999990099999900CCCCCC009999990099999900CCCCCC00FFFF
      FF00CCCCCC009999990099999900CCCCCC000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E5E5E500E5E5E500FFFFFF00CC66
      6600CC330000CC660000CC999900FFFFFF00CC996600CC330000CC330000CC99
      9900FFFFFF00E5E5E5004C4C4C0099999900CCCCCC0099999900FFFFFF00CCCC
      CC009999990099999900CCCCCC00FFFFFF00999999009999990099999900CCCC
      CC00FFFFFF00CCCCCC0099999900999999000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E5E5E500FFFFFF00CC999900CC33
      0000CC663300CC663300CC663300CC996600CC663300CC663300CC663300CC33
      0000CCCCCC00E5E5E500999999006666660099999900FFFFFF00CCCCCC009999
      9900999999009999990099999900999999009999990099999900999999009999
      9900CCCCCC00CCCCCC0099999900999999000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E5E5E500FFFFFF00CC663300CC66
      3300CC663300CC663300CC996600E5E5E500CC663300CC663300CC663300CC66
      3300CC666600FFFFFF00CCCCCC004C4C4C0099999900FFFFFF00999999009999
      9900999999009999990099999900CCCCCC009999990099999900999999009999
      9900CCCCCC00FFFFFF00CCCCCC00999999000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E5E5E500E5E5E500CC663300CC66
      3300CC663300CC663300CC996600FFFFFF00FF999900CC330000CC663300CC66
      3300CC663300E2EFF100E5E5E5004C4C4C0099999900CCCCCC00999999009999
      9900999999009999990099999900FFFFFF00CCCCCC0099999900999999009999
      990099999900E2EFF100CCCCCC00999999000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E5E5E500FFCCCC00CC663300CC66
      3300CC663300CC663300CC663300CCCC9900FFFFFF00CC996600CC663300CC66
      3300CC663300E2EFF100E5E5E5004C4C4C0099999900FFCCCC00999999009999
      9900999999009999990099999900CCCCCC00FFFFFF0099999900999999009999
      990099999900E2EFF100CCCCCC00999999000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E5E5E500E5E5E500CC663300CC66
      3300CC663300CC663300CC663300CC330000CCCCCC00FFFFFF00CC663300CC66
      3300CC663300FFFFFF00E5E5E5006666660099999900CCCCCC00999999009999
      990099999900999999009999990099999900CCCCCC00FFFFFF00999999009999
      990099999900FFFFFF00CCCCCC00999999000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E5E5E500FFFFFF00FF996600CC66
      3300CC996600E5E5E500CC666600CC330000CC996600FFFFFF00CC996600CC66
      0000CC996600FFFFFF00CCCCCC0099A8AC0099999900FFFFFF00999999009999
      990099999900CCCCCC00CCCCCC009999990099999900FFFFFF00999999009999
      990099999900FFFFFF00CCCCCC0099A8AC000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E5E5E500E2EFF100FFFFCC00FF99
      3300CC996600FFFFFF00FFFFFF00FFCC9900FFFFFF00FFFFFF00CC663300FF66
      3300FFFFFF00E5E5E50099999900E5E5E50099999900E2EFF100CCCCCC009999
      990099999900FFFFFF00FFFFFF00CCCCCC00FFFFFF00FFFFFF00999999009999
      9900FFFFFF00CCCCCC0099999900CCCCCC000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E5E5E500FFFFFF00F2EA
      BF00FF996600FF999900E5E5E500E2EFF100E5E5E500FF996600FF996600FFCC
      CC00FFFFFF00F2EABF00C0C0C000000000000000000099999900FFFFFF00CCCC
      CC0099999900CCCCCC00CCCCCC00E2EFF100CCCCCC009999990099999900FFCC
      CC00FFFFFF00CCCCCC0099999900000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E5E5E500E5E5E500FFFF
      FF00FFFFFF00FFFFCC00FFCC9900FFCC9900FFCC9900FFCC9900FFFFFF00FFFF
      FF00E5E5E500C0C0C000E2EFF10000000000000000000000000099999900FFFF
      FF00FFFFFF00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00FFFFFF00FFFF
      FF00CCCCCC0099999900E2EFF100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000E5E5E500FFCC
      CC00E5E5E500FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00E5E5E500FFCC
      CC00CCCCCC00E2EFF10000000000000000000000000000000000000000009999
      990099999900FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00999999009999
      990099999900E2EFF10000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000E5E5E500FFCCCC00FFCCCC00FFCCCC00F2EABF00FFCCCC00E5E5E500E5E5
      E500000000000000000000000000000000000000000000000000000000000000
      0000CCCCCC009999990099999900999999009999990099999900CCCCCC00CCCC
      CC00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00E003E00300000000C001C00100000000
      8000800000000000800080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000080018001000000008001C00100000000
      C003E00300000000F00FF00F0000000000000000000000000000000000000000
      000000000000}
  end
end
