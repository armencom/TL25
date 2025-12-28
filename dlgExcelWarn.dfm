object dlgExcelWarning: TdlgExcelWarning
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Warning'
  ClientHeight = 267
  ClientWidth = 301
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
    Width = 252
    Height = 14
    Caption = 'WAIT, are you sure you want to do this?'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 8
    Top = 32
    Width = 286
    Height = 42
    Caption = 
      'If you are importing a downloaded trade history file'#13'from a supp' +
      'orted broker, then you need to use the'#13'"from File" method.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 8
    Top = 139
    Width = 285
    Height = 28
    Caption = 
      'To import data from Excel you must first format the'#13'trade histor' +
      'y using our template and guidelines.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 8
    Top = 80
    Width = 242
    Height = 14
    Caption = 'Click here for Supported Broker instructions.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMenuHighlight
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    OnClick = Label4Click
    OnMouseEnter = Label4MouseEnter
    OnMouseLeave = Label4MouseLeave
  end
  object Label5: TLabel
    Left = 8
    Top = 179
    Width = 176
    Height = 14
    Caption = 'Click here for those instructions.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMenuHighlight
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    OnClick = Label5Click
    OnMouseEnter = Label5MouseEnter
    OnMouseLeave = Label5MouseLeave
  end
  object Button1: TButton
    Left = 28
    Top = 108
    Width = 239
    Height = 25
    Caption = 'Click here to Import from File.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = Button1Click
  end
  object Panel1: TPanel
    Left = 0
    Top = 226
    Width = 301
    Height = 41
    Align = alBottom
    TabOrder = 1
    object Button2: TButton
      Left = 192
      Top = 8
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 0
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 96
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Proceed'
      TabOrder = 1
      OnClick = Button3Click
    end
  end
end
