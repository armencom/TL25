object dlgDCYWarning: TdlgDCYWarning
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'DCY Trades Warning'
  ClientHeight = 224
  ClientWidth = 325
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
    Width = 303
    Height = 91
    Caption = 
      'One or more accounts contains digital assets, cryptocurrency '#13'or' +
      ' other transactions labeled as DCY type in TradeLog. This '#13'versi' +
      'on of TradeLog does not support reporting those assets '#13'on Form ' +
      '8949 for the 2025 tax year (with 1099-DA reporting). '#13'Please con' +
      'tact our support team for assistance with those '#13'assets. Please ' +
      'send a copy of your TradeLog data file and '#13'your 1099-DA provide' +
      'd by your broker/exchange.'
  end
  object Label2: TLabel
    Left = 8
    Top = 112
    Width = 303
    Height = 26
    Caption = 
      'You can continue and generate Form 8949 for securities '#13'reported' +
      ' on 1099-B using this version.'
  end
  object Label3: TLabel
    Left = 8
    Top = 152
    Width = 263
    Height = 13
    Caption = 'How TradeLog Handles Cryptocurrency (Digital Assets)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMenuHighlight
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    OnClick = Label3Click
    OnMouseEnter = Label3MouseEnter
    OnMouseLeave = Label3MouseLeave
  end
  object btnOK: TButton
    Left = 120
    Top = 184
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 0
    OnClick = btnOKClick
  end
end
