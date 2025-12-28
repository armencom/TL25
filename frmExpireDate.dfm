object dlgExpireDate: TdlgExpireDate
  Left = 0
  Top = 0
  AutoSize = True
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Expiration Date'
  ClientHeight = 135
  ClientWidth = 182
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  Padding.Left = 20
  Padding.Top = 20
  Padding.Right = 20
  Padding.Bottom = 20
  OldCreateOrder = False
  Position = poDefault
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object lblDay: TLabel
    Left = 20
    Top = 20
    Width = 21
    Height = 16
    Caption = 'Day'
  end
  object lblMon: TLabel
    Left = 66
    Top = 20
    Width = 35
    Height = 16
    Caption = 'Month'
  end
  object lblYear: TLabel
    Left = 122
    Top = 20
    Width = 26
    Height = 16
    Caption = 'Year'
  end
  object cbMonth: TRzComboBox
    Left = 66
    Top = 42
    Width = 50
    Height = 24
    TabOrder = 0
    Text = 'JAN'
    Items.Strings = (
      'JAN'
      'FEB'
      'MAR'
      'APR'
      'MAY'
      'JUN'
      'JUL'
      'AUG'
      'SEP'
      'OCT'
      'NOV'
      'DEC')
  end
  object cbDay: TRzComboBox
    Left = 20
    Top = 42
    Width = 40
    Height = 24
    TabOrder = 1
    Text = '01'
  end
  object cbYear: TRzComboBox
    Left = 122
    Top = 42
    Width = 40
    Height = 24
    TabOrder = 2
    Text = '14'
  end
  object btnOK: TRzButton
    Left = 102
    Top = 90
    Width = 60
    Default = True
    ModalResult = 1
    Caption = 'OK'
    TabOrder = 3
  end
  object btnCancel: TRzButton
    Left = 20
    Top = 90
    Width = 60
    Cancel = True
    ModalResult = 2
    Caption = 'Cancel'
    TabOrder = 4
  end
end
