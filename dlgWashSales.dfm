object dlgWSsettings: TdlgWSsettings
  Left = 0
  Top = 0
  Hint = 'These settings affect all Wash Sales in this file.'
  BorderStyle = bsDialog
  Caption = 'Wash Sale Settings'
  ClientHeight = 316
  ClientWidth = 366
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lblLegalWarning: TLabel
    Left = 8
    Top = 8
    Width = 344
    Height = 39
    Caption = 
      'Warning: changing these settings will alter tax reporting and'#13'co' +
      'uld have legal consequences. You should consult with a tax'#13'profe' +
      'ssional before changing from default settings.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblHelpLink: TLabel
    Left = 16
    Top = 72
    Width = 219
    Height = 13
    Caption = 'Click here to learn more about these settings.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    OnClick = lblHelpLinkClick
    OnMouseEnter = lblHelpLinkMouseEnter
    OnMouseLeave = lblHelpLinkMouseLeave
  end
  object chkShortLong: TCheckBox
    Left = 8
    Top = 107
    Width = 337
    Height = 17
    Caption = 'Adjust Wash Sales Between Shorts and Longs'
    TabOrder = 0
  end
  object chkStkOpt: TCheckBox
    Left = 8
    Top = 147
    Width = 337
    Height = 17
    Caption = 'Adjust Wash Sales from Stock to Option Positions'
    TabOrder = 1
  end
  object chkOptStk: TCheckBox
    Left = 8
    Top = 187
    Width = 337
    Height = 17
    Caption = 'Adjust Wash Sales from Options to Stock Positions'
    TabOrder = 2
  end
  object chkSubstantially: TCheckBox
    Left = 8
    Top = 227
    Width = 337
    Height = 17
    Caption = 'Adjust Wash Sales Between Trades for Same Underlying Ticker'
    TabOrder = 3
    OnClick = chkSubstantiallyClick
  end
  object btnDefaults: TButton
    Left = 8
    Top = 264
    Width = 84
    Height = 41
    Caption = 'Defaults'
    TabOrder = 4
    OnClick = btnDefaultsClick
  end
  object btnCancel: TButton
    Left = 160
    Top = 264
    Width = 84
    Height = 41
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 5
    OnClick = btnCancelClick
  end
  object btnApply: TButton
    Left = 264
    Top = 264
    Width = 85
    Height = 41
    Caption = 'Apply'
    Default = True
    TabOrder = 6
    OnClick = btnApplyClick
  end
end
