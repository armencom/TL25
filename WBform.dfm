object frmWB: TfrmWB
  Left = 0
  Top = 0
  HorzScrollBar.Visible = False
  BorderIcons = []
  BorderStyle = bsNone
  ClientHeight = 170
  ClientWidth = 140
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDesigned
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object WB: TWebBrowser
    Left = 8
    Top = 8
    Width = 121
    Height = 150
    TabOrder = 0
    OnNavigateComplete2 = WBNavigateComplete2
    OnDocumentComplete = WBDocumentComplete
    OnNavigateError = WBNavigateError
    ControlData = {
      4C000000810C0000810F00000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
end
