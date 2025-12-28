object panelMsg: TpanelMsg
  Left = 0
  Top = 0
  AutoSize = True
  ClientHeight = 190
  ClientWidth = 852
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnCreate = FormCreate
  OnHide = FormHide
  PixelsPerInch = 96
  TextHeight = 13
  object pnlMsg: TPanel
    Left = 0
    Top = 0
    Width = 764
    Height = 190
    Align = alClient
    BevelEdges = []
    BevelOuter = bvNone
    BorderWidth = 3
    Color = clWhite
    Padding.Left = 10
    Padding.Top = 2
    Padding.Bottom = 2
    TabOrder = 0
    object lblMsgLg: TLabel
      AlignWithMargins = True
      Left = 16
      Top = 34
      Width = 742
      Height = 16
      Align = alTop
      Caption = 'ERROR'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      ExplicitWidth = 54
    end
    object lblMsg: TRichEdit
      Left = 13
      Top = 53
      Width = 748
      Height = 132
      Margins.Left = 8
      Align = alClient
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      Lines.Strings = (
        'message text')
      ParentColor = True
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
    end
    object pnlSelectErrors: TPanel
      Left = 13
      Top = 5
      Width = 748
      Height = 26
      Margins.Left = 0
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      Color = clWhite
      TabOrder = 1
      object lbSelectErrors: TRzLabel
        Left = 345
        Top = 0
        Width = 403
        Height = 26
        Align = alClient
        Caption = '  <-- Click to see and resolve additional errors.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 26367
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        BlinkIntervalOff = 100
        BlinkIntervalOn = 100
        ExplicitWidth = 319
        ExplicitHeight = 16
      end
      object cbErrors: TRzComboBox
        Left = 0
        Top = 0
        Width = 345
        Height = 24
        Align = alLeft
        AllowEdit = False
        Ctl3D = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        FlatButtonColor = clInactiveCaption
        FrameStyle = fsGroove
        FrameVisible = True
        FramingPreference = fpCustomFraming
        ParentCtl3D = False
        ParentFont = False
        ReadOnlyColor = clBtnHighlight
        TabOrder = 0
        OnChange = cbErrorsChange
        OnClick = cbErrorsClick
      end
    end
  end
  object pnlBtns: TPanel
    Left = 764
    Top = 0
    Width = 88
    Height = 190
    Align = alRight
    BevelOuter = bvNone
    Color = clWhite
    TabOrder = 1
    object btnCancel: TcxButton
      Left = 22
      Top = 9
      Width = 50
      Height = 25
      Caption = 'Close'
      LookAndFeel.Kind = lfOffice11
      TabOrder = 0
      OnClick = btnCancelClick
    end
    object btnGetHelp: TcxButton
      Left = 22
      Top = 43
      Width = 50
      Height = 25
      HelpContext = 14800
      Caption = 'Help'
      LookAndFeel.Kind = lfOffice11
      TabOrder = 1
      OnClick = btnGetHelpClick
    end
  end
end
