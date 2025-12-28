object dlgCanProHelp: TdlgCanProHelp
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'What is Account Import?'
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
    Width = 327
    Height = 26
    Caption = 
      'This function is used to merge an account maintained in a separa' +
      'te '#13'TradeLog file with the current file and will create a new ac' +
      'count tab.'
  end
  object Label2: TLabel
    Left = 8
    Top = 48
    Width = 326
    Height = 26
    Caption = 
      'If you are trying to import trade history, please cancel this fu' +
      'nction '#13'and use the import button on the toolbar.'
  end
  object Label3: TLabel
    Left = 12
    Top = 80
    Width = 305
    Height = 13
    Caption = 
      'Click here to see the instructions for your specific broker onli' +
      'ne.'
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
    Top = 112
    Width = 88
    Height = 32
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 0
    OnClick = btnCancelClick
  end
  object btnProceed: TButton
    Left = 240
    Top = 112
    Width = 88
    Height = 32
    Caption = 'Proceed'
    TabOrder = 1
    OnClick = btnProceedClick
  end
end
