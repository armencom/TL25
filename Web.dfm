object frmWeb: TfrmWeb
  Left = 314
  Top = 108
  BorderStyle = bsSingle
  Caption = 'brokerConnect'
  ClientHeight = 440
  ClientWidth = 736
  Color = clBtnFace
  DragMode = dmAutomatic
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDefault
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object WebBrowser1: TWebBrowser
    Left = 0
    Top = 70
    Width = 736
    Height = 179
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Align = alTop
    TabOrder = 0
    OnBeforeNavigate2 = WebBrowser1BeforeNavigate2
    OnNewWindow2 = WebBrowser1NewWindow2
    OnNavigateComplete2 = WebBrowser1NavigateComplete2
    OnDocumentComplete = WebBrowser1DocumentComplete
    ExplicitWidth = 667
    ControlData = {
      4C000000114C0000801200000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E12620E000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object statusBar1: TPanel
    Left = 0
    Top = 416
    Width = 736
    Height = 24
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Align = alBottom
    BevelOuter = bvNone
    Font.Charset = ANSI_CHARSET
    Font.Color = clBtnText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 1
    object lblStat: TLabel
      AlignWithMargins = True
      Left = 2
      Top = 3
      Width = 4
      Height = 16
      Margins.Left = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Align = alClient
      Alignment = taCenter
      Font.Charset = ANSI_CHARSET
      Font.Color = clBtnText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
  end
  object cxRichEdit: TcxRichEdit
    Left = 0
    Top = 30
    Margins.Left = 2
    Margins.Top = 0
    Margins.Right = 2
    Margins.Bottom = 2
    Align = alTop
    ParentFont = False
    Properties.HideScrollBars = False
    Properties.ReadOnly = True
    Lines.Strings = (
      'Select All Trades from the drop down Type box,'
      'Then enter a Date Range and click the GO button'
      '')
    Style.BorderColor = clWhite
    Style.Edges = []
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -15
    Style.Font.Name = 'MS Sans Serif'
    Style.Font.Style = []
    Style.IsFontAssigned = True
    TabOrder = 2
    Visible = False
    Height = 40
    Width = 736
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 736
    Height = 30
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    object edURL: TLabel
      AlignWithMargins = True
      Left = 10
      Top = 6
      Width = 200
      Height = 16
      Margins.Left = 10
      Margins.Top = 6
      Align = alLeft
      Color = clWhite
      Constraints.MaxHeight = 16
      Constraints.MinHeight = 16
      Constraints.MinWidth = 200
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Layout = tlCenter
      ExplicitTop = 7
    end
    object Panel3: TPanel
      Left = 640
      Top = 0
      Width = 96
      Height = 30
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object btnClose: TcxButton
        Left = 24
        Top = 4
        Width = 60
        Height = 22
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Cancel = True
        Caption = 'Cancel'
        LookAndFeel.Kind = lfOffice11
        TabOrder = 0
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        OnClick = btnCloseClick
      end
    end
  end
  object tmrIB: TTimer
    Enabled = False
    Interval = 2000
    OnTimer = tmrIBTimer
    Left = 686
    Top = 282
  end
  object tmrWebTimeout: TTimer
    Enabled = False
    Interval = 15000
    OnTimer = tmrWebTimeoutTimer
    Left = 572
    Top = 282
  end
end
