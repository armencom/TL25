object panelRenew: TpanelRenew
  Left = 0
  Top = 0
  BorderStyle = bsNone
  ClientHeight = 50
  ClientWidth = 757
  Color = 12058623
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlUpdate: TPanel
    Left = 0
    Top = 0
    Width = 757
    Height = 30
    Cursor = crHandPoint
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alTop
    BevelOuter = bvNone
    BorderWidth = 1
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -27
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentBackground = False
    ParentColor = True
    ParentFont = False
    TabOrder = 0
    object lblImportant: TLabel
      AlignWithMargins = True
      Left = 11
      Top = 5
      Width = 130
      Height = 20
      Margins.Left = 10
      Margins.Top = 4
      Margins.Right = 0
      Margins.Bottom = 4
      Align = alLeft
      AutoSize = False
      Caption = 'PLEASE NOTE:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblMsg: TLabel
      AlignWithMargins = True
      Left = 151
      Top = 7
      Width = 405
      Height = 16
      Margins.Left = 10
      Margins.Top = 6
      Margins.Right = 0
      Margins.Bottom = 6
      Align = alClient
      AutoSize = False
      Caption = 'Your annual subscription'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitLeft = 124
      ExplicitWidth = 354
      ExplicitHeight = 18
    end
    object Panel1: TPanel
      Left = 556
      Top = 1
      Width = 200
      Height = 28
      Align = alRight
      Alignment = taRightJustify
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      object btnRenew: TcxButton
        AlignWithMargins = True
        Left = 30
        Top = 2
        Width = 160
        Height = 24
        Cursor = crHandPoint
        Hint = 'Download and Install Update Now'
        Margins.Left = 0
        Margins.Top = 2
        Margins.Right = 10
        Margins.Bottom = 2
        Align = alRight
        Caption = 'RENEW NOW!'
        Colors.Default = clWhite
        Colors.DefaultText = clBlack
        Colors.Hot = clYellow
        Colors.HotText = clBlack
        Layout = blGlyphBottom
        LookAndFeel.Kind = lfOffice11
        TabOrder = 0
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        OnClick = btnRenewClick
      end
    end
  end
end
