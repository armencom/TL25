object dlgConsolidate: TdlgConsolidate
  Left = 0
  Top = 0
  Caption = 'Consolidate Partial Fills'
  ClientHeight = 195
  ClientWidth = 367
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 17
    Top = 120
    Width = 188
    Height = 13
    Caption = '2. Select button to begin consolidation:'
  end
  object btnCancel: TButton
    Left = 8
    Top = 146
    Width = 89
    Height = 41
    Caption = 'Cancel'
    TabOrder = 0
    OnClick = btnCancelClick
  end
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 351
    Height = 97
    TabOrder = 1
    object Label1: TLabel
      Left = 13
      Top = 13
      Width = 150
      Height = 13
      Caption = '1. Select consolidation method:'
    end
    object RadioButton1: TRadioButton
      Left = 11
      Top = 42
      Width = 339
      Height = 17
      Caption = 'Careful consolidation - do not alter wash sales or taxable G/L.'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object RadioButton2: TRadioButton
      Left = 10
      Top = 73
      Width = 340
      Height = 17
      Caption = 'Maximum consolidation - may affect wash sales and taxable G/L'
      TabOrder = 1
    end
  end
  object btnCurrAcct: TRzButton
    Left = 136
    Top = 146
    Width = 89
    Height = 41
    Caption = 'Current'#13'Account'
    TabOrder = 2
    OnClick = btnCurrAcctClick
  end
  object btnAllAccts: TRzButton
    Left = 270
    Top = 146
    Width = 89
    Height = 41
    Caption = 'All'#13'Accounts'
    TabOrder = 3
    OnClick = btnAllAcctsClick
  end
end
