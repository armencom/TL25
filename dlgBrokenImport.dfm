object dlgBrokenImpHelp: TdlgBrokenImpHelp
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'This BrokerConnect no longer available.'
  ClientHeight = 157
  ClientWidth = 347
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 314
    Height = 39
    Caption = 
      'Schwab BrokerConnect is unavailable. We are working to resolve t' +
      'he problems with a new Schwab API. Please use the CSV import met' +
      'hod in the interim.'
    WordWrap = True
  end
  object Label2: TLabel
    Left = 8
    Top = 80
    Width = 306
    Height = 26
    Caption = 
      'Click Proceed if you would like TradeLog to change your default ' +
      'import method to download, or Cancel to leave as-is.'
    WordWrap = True
  end
  object Label3: TLabel
    Left = 80
    Top = 53
    Width = 180
    Height = 13
    Caption = 'Click here for CSV import instructions.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = Label3Click
    OnMouseEnter = Label3MouseEnter
    OnMouseLeave = Label3MouseLeave
  end
  object btnCancel: TButton
    Left = 136
    Top = 117
    Width = 88
    Height = 32
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 0
    OnClick = btnCancelClick
  end
  object btnProceed: TButton
    Left = 240
    Top = 117
    Width = 88
    Height = 32
    Caption = 'Proceed'
    TabOrder = 1
    OnClick = btnProceedClick
  end
end
