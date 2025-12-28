object dlgAdjCodes: TdlgAdjCodes
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Tax Adjustment Codes'
  ClientHeight = 486
  ClientWidth = 501
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
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 481
    Height = 201
    Caption = 'Assign Form 8949 Category'
    TabOrder = 0
    object Label1: TLabel
      Left = 32
      Top = 172
      Width = 207
      Height = 13
      Caption = 'Click here to learn how to use these codes.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clHighlight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      OnClick = Label1Click
      OnMouseEnter = Label1MouseEnter
      OnMouseLeave = Label1MouseLeave
    end
    object Label4: TLabel
      Left = 32
      Top = 40
      Width = 244
      Height = 13
      Caption = '(Tradelog will report with box A or D of Form 8949)'
    end
    object Label5: TLabel
      Left = 32
      Top = 81
      Width = 242
      Height = 13
      Caption = '(Tradelog will report with box B or E of Form 8949)'
    end
    object Label6: TLabel
      Left = 32
      Top = 123
      Width = 243
      Height = 13
      Caption = '(Tradelog will report with box C or F of Form 8949)'
    end
    object RadioButton1: TRadioButton
      Left = 16
      Top = 16
      Width = 360
      Height = 25
      Caption = 
        '(A) reported on Form 1099-B showing basis was reported to the IR' +
        'S.'
      TabOrder = 0
    end
    object RadioButton2: TRadioButton
      Left = 16
      Top = 62
      Width = 377
      Height = 17
      Caption = 
        '(B) reported on Form 1099-B showing basis was NOT reported to th' +
        'e IRS.'
      TabOrder = 1
    end
    object RadioButton3: TRadioButton
      Left = 16
      Top = 100
      Width = 360
      Height = 17
      Caption = '(C) not reported to you on Form 1099-B.'
      TabOrder = 2
    end
    object RadioButton4: TRadioButton
      Left = 16
      Top = 146
      Width = 360
      Height = 17
      Caption = 'Clear (let TradeLog determine IRS code.)'
      Checked = True
      TabOrder = 3
      TabStop = True
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 224
    Width = 481
    Height = 81
    Caption = 'Wash Sales'
    TabOrder = 1
    object Label2: TLabel
      Left = 32
      Top = 50
      Width = 192
      Height = 13
      Caption = 'Click here to learn how to use this code.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clHighlight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      OnClick = Label2Click
      OnMouseEnter = Label2MouseEnter
      OnMouseLeave = Label2MouseLeave
    end
    object CheckBox1: TCheckBox
      Left = 16
      Top = 24
      Width = 438
      Height = 17
      Caption = 
        '(X) Do not include this trade in wash sale calculations (exempt ' +
        'trade).'
      TabOrder = 0
    end
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 311
    Width = 481
    Height = 120
    Caption = 'Special Holding Period'
    TabOrder = 2
    Visible = False
    object Label3: TLabel
      Left = 32
      Top = 94
      Width = 207
      Height = 13
      Caption = 'Click here to learn how to use these codes.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clHighlight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      OnClick = Label3Click
      OnMouseEnter = Label3MouseEnter
      OnMouseLeave = Label3MouseLeave
    end
    object RadioButton5: TRadioButton
      Left = 16
      Top = 16
      Width = 360
      Height = 17
      Caption = '(L) This trade is always Long-term.'
      TabOrder = 0
    end
    object RadioButton6: TRadioButton
      Left = 16
      Top = 42
      Width = 360
      Height = 17
      Caption = '(S) This trade is always Short-term.'
      TabOrder = 1
    end
    object RadioButton7: TRadioButton
      Left = 16
      Top = 68
      Width = 360
      Height = 17
      Caption = 'Clear (let TradeLog determine Long or Short term).'
      Checked = True
      TabOrder = 2
      TabStop = True
    end
  end
  object Button1: TButton
    Left = 408
    Top = 437
    Width = 85
    Height = 41
    Caption = 'Apply'
    Default = True
    TabOrder = 3
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 304
    Top = 437
    Width = 84
    Height = 41
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 4
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 8
    Top = 437
    Width = 84
    Height = 41
    Caption = 'Clear All'
    TabOrder = 5
    OnClick = Button3Click
  end
end
