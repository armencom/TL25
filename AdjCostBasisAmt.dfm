object dlgAdjCostBasisAmt: TdlgAdjCostBasisAmt
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Adjust Cost Basis Amount'
  ClientHeight = 116
  ClientWidth = 416
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object lblPrompt: TLabel
    Left = 8
    Top = 11
    Width = 267
    Height = 16
    Caption = 'Please enter the dollar amount to adjust by:  $'
  end
  object edValue: TEdit
    Left = 292
    Top = 8
    Width = 113
    Height = 24
    TabOrder = 0
    Text = '0.00'
  end
  object RadioButton1: TRadioButton
    Left = 8
    Top = 48
    Width = 113
    Height = 17
    Caption = 'Increase +'
    Checked = True
    TabOrder = 1
    TabStop = True
  end
  object RadioButton2: TRadioButton
    Left = 8
    Top = 80
    Width = 113
    Height = 17
    Caption = 'Decrease -'
    TabOrder = 2
  end
  object btnOK: TButton
    Left = 332
    Top = 68
    Width = 75
    Height = 40
    Caption = 'OK'
    Default = True
    TabOrder = 3
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 242
    Top = 68
    Width = 75
    Height = 40
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 4
    OnClick = btnCancelClick
  end
  object cboPerShare: TComboBox
    Left = 292
    Top = 30
    Width = 113
    Height = 24
    Style = csDropDownList
    ItemIndex = 0
    TabOrder = 5
    Text = 'per trade'
    Items.Strings = (
      'per trade'
      'per share')
  end
end
