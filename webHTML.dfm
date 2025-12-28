object frmWebHTML: TfrmWebHTML
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'frmWebHTML'
  ClientHeight = 317
  ClientWidth = 482
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object webBrowser1: TWebBrowser
    Left = 0
    Top = 59
    Width = 482
    Height = 258
    Align = alBottom
    TabOrder = 0
    OnBeforeNavigate2 = webBrowser1BeforeNavigate2
    OnNavigateComplete2 = webBrowser1NavigateComplete2
    OnDocumentComplete = webBrowser1DocumentComplete
    ExplicitTop = 72
    ExplicitWidth = 430
    ControlData = {
      4C000000D1310000AA1A00000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126200000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object btnCancel: TButton
    Left = 384
    Top = 16
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = btnCancelClick
  end
  object timerWebHTML: TTimer
    Enabled = False
    Interval = 2000
    OnTimer = timerWebHTMLTimer
    Left = 8
    Top = 8
  end
end
