object pnlBaseline: TpnlBaseline
  Left = 0
  Top = 0
  VertScrollBar.Tracking = True
  BorderStyle = bsNone
  ClientHeight = 543
  ClientWidth = 1006
  Color = clWhite
  DefaultMonitor = dmMainForm
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 19
  object pnlTitle: TPanel
    Left = 0
    Top = 0
    Width = 1006
    Height = 44
    Align = alTop
    AutoSize = True
    BevelEdges = []
    BevelKind = bkFlat
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 0
    object pnlTitleLeft: TPanel
      Left = 0
      Top = 3
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
      Left = 891
      Top = 0
      Width = 115
      Height = 44
      Align = alRight
      Alignment = taRightJustify
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      object btnClose: TRzButton
        Left = 20
        Top = 8
        Cancel = True
        Caption = 'Exit'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = btnCloseClick
      end
      object btnClose1: TRzButton
        Left = 20
        Top = 8
        Cancel = True
        Caption = 'Exit'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = btnClose1Click
      end
    end
  end
  object pnlBtn: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 476
    Width = 1000
    Height = 64
    Align = alBottom
    Anchors = [akLeft, akBottom]
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    DesignSize = (
      1000
      64)
    object btnEnterBaseline: TRzButton
      Left = 490
      Top = 10
      Width = 210
      Height = 38
      Anchors = []
      Caption = 'Enter Baseline Manually'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = btnEnterBaselineClick
    end
    object btnBegin: TRzButton
      Left = 249
      Top = 10
      Width = 210
      Height = 38
      Anchors = []
      Caption = 'Begin Baseline Wizard'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = btnBeginClick
    end
  end
  object pnl1: TPanel
    Left = 0
    Top = 44
    Width = 1006
    Height = 66
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object Panel1: TPanel
      Left = 856
      Top = 0
      Width = 150
      Height = 66
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object btnGetMoreInfo: TRzButton
        Left = 10
        Top = 14
        Width = 120
        Height = 30
        Cancel = True
        Caption = 'Get More Info'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = btnGetMoreInfoClick
      end
    end
    object wb1: TWebBrowser
      AlignWithMargins = True
      Left = 10
      Top = 10
      Width = 846
      Height = 56
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alClient
      TabOrder = 1
      OnDocumentComplete = wb1DocumentComplete
      ExplicitWidth = 910
      ControlData = {
        4C00000070570000CA0500000000000000000000000000000000000000000000
        000000004C000000000000000000000001000000E0D057007335CF11AE690800
        2B2E126208000000000000004C0000000114020000000000C000000000000046
        8000000000000000000000000000000000000000000000000000000000000000
        00000000000000000100000000000000000000000000000000000000}
    end
  end
  object pnl2: TPanel
    Left = 0
    Top = 110
    Width = 1006
    Height = 239
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    object wb2: TWebBrowser
      AlignWithMargins = True
      Left = 10
      Top = 10
      Width = 976
      Height = 219
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 20
      Margins.Bottom = 10
      Align = alClient
      TabOrder = 0
      OnDocumentComplete = wb2DocumentComplete
      ExplicitWidth = 1040
      ControlData = {
        4C000000DF640000A21600000000000000000000000000000000000000000000
        000000004C000000000000000000000001000000E0D057007335CF11AE690800
        2B2E126208000000000000004C0000000114020000000000C000000000000046
        8000000000000000000000000000000000000000000000000000000000000000
        00000000000000000100000000000000000000000000000000000000}
    end
  end
end
