object frmTypeMult: TfrmTypeMult
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Change Type/Mult'
  ClientHeight = 203
  ClientWidth = 274
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlMain: TPanel
    Left = 0
    Top = 70
    Width = 274
    Height = 133
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object Label1: TLabel
      AlignWithMargins = True
      Left = 10
      Top = 10
      Width = 261
      Height = 13
      Margins.Left = 10
      Margins.Top = 10
      Align = alTop
      Caption = 'Change Type/Mult of selected records to:'
      ExplicitWidth = 197
    end
    object cboTypeMult: TComboBox
      AlignWithMargins = True
      Left = 10
      Top = 36
      Width = 254
      Height = 21
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alTop
      CharCase = ecUpperCase
      TabOrder = 0
    end
    object btnOK: TButton
      Left = 40
      Top = 70
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      TabOrder = 1
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 146
      Top = 70
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 2
      OnClick = btnCancelClick
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 274
    Height = 70
    Align = alTop
    AutoSize = True
    BevelEdges = [beBottom]
    BevelKind = bkFlat
    BevelOuter = bvNone
    TabOrder = 1
    object note: TLabel
      AlignWithMargins = True
      Left = 10
      Top = 10
      Width = 38
      Height = 13
      Margins.Top = 10
      Caption = 'NOTE:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object noteTxt: TLabel
      Left = 10
      Top = 29
      Width = 246
      Height = 39
      Caption = 
        'Broad-Based Index Options, Futures, Mutual Funds, and ETF/ETNs m' +
        'ust be changed using the Trade Type Settings, found in the User ' +
        'menu.'
      WordWrap = True
    end
  end
end
