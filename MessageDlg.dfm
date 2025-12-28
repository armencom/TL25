object MessageDialog: TMessageDialog
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Tradelog Message'
  ClientHeight = 345
  ClientWidth = 436
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 436
    Height = 65
    Align = alTop
    BevelOuter = bvNone
    BorderWidth = 1
    BorderStyle = bsSingle
    Caption = 'Panel1'
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    ShowCaption = False
    TabOrder = 0
    object lbHeaderMessage: TLabel
      AlignWithMargins = True
      Left = 101
      Top = 11
      Width = 310
      Height = 39
      Margins.Left = 100
      Margins.Top = 10
      Margins.Right = 20
      Margins.Bottom = 10
      Align = alClient
      AutoSize = False
      Color = 16510691
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = True
      WordWrap = True
      ExplicitLeft = 104
    end
    object imgIcon: TImage
      Left = 11
      Top = 6
      Width = 52
      Height = 49
    end
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 309
    Width = 436
    Height = 36
    Align = alBottom
    BevelOuter = bvNone
    Caption = 'pnlButtons'
    ShowCaption = False
    TabOrder = 1
    object cxButton1: TcxButton
      Left = 175
      Top = 5
      Width = 75
      Height = 25
      Caption = '&OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 65
    Width = 436
    Height = 143
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel3'
    ParentBackground = False
    ShowCaption = False
    TabOrder = 2
    object memoBodyMessage: TMemo
      AlignWithMargins = True
      Left = 20
      Top = 5
      Width = 396
      Height = 133
      Margins.Left = 20
      Margins.Top = 5
      Margins.Right = 20
      Margins.Bottom = 5
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object pnlThirdMessage: TPanel
    Left = 0
    Top = 208
    Width = 436
    Height = 101
    Align = alBottom
    BevelOuter = bvNone
    Caption = 'pnlThirdMessage'
    ParentBackground = False
    ShowCaption = False
    TabOrder = 3
    object lbFooterMessage: TLabel
      AlignWithMargins = True
      Left = 20
      Top = 10
      Width = 396
      Height = 86
      Margins.Left = 20
      Margins.Top = 10
      Margins.Right = 20
      Margins.Bottom = 5
      Align = alClient
      Alignment = taCenter
      AutoSize = False
      Color = 16510691
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
      WordWrap = True
      ExplicitLeft = 224
      ExplicitTop = 24
      ExplicitWidth = 85
      ExplicitHeight = 13
    end
  end
end
