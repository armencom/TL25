object frmWebBrowserPopup: TfrmWebBrowserPopup
  Left = 0
  Top = 0
  ClientHeight = 337
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object WebBrowser1: TWebBrowser
    Left = 0
    Top = 35
    Width = 635
    Height = 302
    Align = alClient
    TabOrder = 0
    OnFileDownload = WebBrowser1FileDownload
    ExplicitTop = 192
    ExplicitHeight = 145
    ControlData = {
      4C000000A1410000361F00000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126200000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 0
    Width = 635
    Height = 35
    Align = alTop
    BevelOuter = bvSpace
    TabOrder = 1
    object btnUpdate: TcxButton
      Left = 16
      Top = 4
      Width = 121
      Height = 25
      Caption = 'Get Update'
      LookAndFeel.Kind = lfOffice11
      TabOrder = 0
      Font.Charset = ANSI_CHARSET
      Font.Color = clBtnText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      OnClick = btnUpdateClick
    end
    object pnlClose: TPanel
      Left = 449
      Top = 1
      Width = 185
      Height = 33
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      object btnClose: TcxButton
        Left = 94
        Top = 3
        Width = 75
        Height = 25
        Cancel = True
        Caption = 'Close'
        LookAndFeel.Kind = lfOffice11
        TabOrder = 0
        Font.Charset = ANSI_CHARSET
        Font.Color = clBtnText
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        OnClick = btnCloseClick
      end
    end
  end
end
