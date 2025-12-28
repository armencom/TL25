object dlgSuper: TdlgSuper
  Left = 0
  Top = 0
  AutoSize = True
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Super User '
  ClientHeight = 264
  ClientWidth = 369
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlButtons: TPanel
    Left = 0
    Top = 208
    Width = 369
    Height = 56
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object btnChange: TButton
      Left = 190
      Top = 19
      Width = 69
      Height = 23
      Caption = 'Change'
      TabOrder = 0
      OnClick = btnChangeClick
    end
    object btnCopy: TButton
      Left = 9
      Top = 19
      Width = 84
      Height = 23
      Caption = 'Copy Text File'
      TabOrder = 1
      OnClick = btnCopyClick
    end
    object btnCancel: TButton
      Left = 111
      Top = 19
      Width = 70
      Height = 23
      Cancel = True
      Caption = 'Cancel'
      Default = True
      TabOrder = 2
      OnClick = btnCancelClick
    end
    object btnResetTaxfile: TButton
      Left = 274
      Top = 19
      Width = 84
      Height = 23
      Caption = 'Reset TaxFile'
      TabOrder = 3
      OnClick = btnResetTaxfileClick
    end
  end
  object pnlFileName: TPanel
    Left = 0
    Top = 0
    Width = 369
    Height = 37
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    Padding.Left = 9
    Padding.Top = 4
    Padding.Right = 9
    Padding.Bottom = 9
    TabOrder = 1
    object lblFileName: TLabel
      AlignWithMargins = True
      Left = 9
      Top = 10
      Width = 65
      Height = 13
      Margins.Left = 0
      Margins.Top = 6
      Margins.Right = 9
      Margins.Bottom = 0
      Align = alLeft
      Caption = 'File Name:'
      Constraints.MinWidth = 65
    end
    object edFileName: TEdit
      AlignWithMargins = True
      Left = 83
      Top = 8
      Width = 185
      Height = 20
      Margins.Left = 0
      Margins.Top = 4
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alLeft
      TabOrder = 0
      ExplicitHeight = 21
    end
  end
  object pnlRegUser: TPanel
    Left = 0
    Top = 37
    Width = 369
    Height = 37
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    Padding.Left = 9
    Padding.Top = 4
    Padding.Right = 9
    Padding.Bottom = 9
    TabOrder = 2
    object lblRegUser: TLabel
      AlignWithMargins = True
      Left = 9
      Top = 10
      Width = 65
      Height = 13
      Margins.Left = 0
      Margins.Top = 6
      Margins.Right = 9
      Margins.Bottom = 0
      Align = alLeft
      Caption = 'Reg User:'
      Constraints.MinWidth = 65
    end
    object edRegUser: TEdit
      AlignWithMargins = True
      Left = 83
      Top = 8
      Width = 185
      Height = 20
      Margins.Left = 0
      Margins.Top = 4
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alLeft
      TabOrder = 0
      ExplicitHeight = 21
    end
  end
  object pnlAcct: TPanel
    Left = 0
    Top = 74
    Width = 369
    Height = 37
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    Padding.Left = 9
    Padding.Top = 4
    Padding.Right = 9
    Padding.Bottom = 9
    TabOrder = 3
    object lblAcct: TLabel
      AlignWithMargins = True
      Left = 9
      Top = 10
      Width = 65
      Height = 13
      Margins.Left = 0
      Margins.Top = 6
      Margins.Right = 9
      Margins.Bottom = 0
      Align = alLeft
      Caption = 'Accountant'
      Constraints.MinWidth = 65
    end
    object edAcct: TEdit
      AlignWithMargins = True
      Left = 83
      Top = 8
      Width = 185
      Height = 20
      Margins.Left = 0
      Margins.Top = 4
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alLeft
      TabOrder = 0
      ExplicitHeight = 21
    end
  end
  object pnlPW: TPanel
    Left = 0
    Top = 149
    Width = 369
    Height = 38
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    Padding.Left = 9
    Padding.Top = 4
    Padding.Right = 9
    Padding.Bottom = 9
    TabOrder = 4
    object lblPW: TLabel
      AlignWithMargins = True
      Left = 9
      Top = 10
      Width = 65
      Height = 13
      Margins.Left = 0
      Margins.Top = 6
      Margins.Right = 9
      Margins.Bottom = 0
      Align = alLeft
      Caption = 'Password:'
      Constraints.MinWidth = 65
    end
    object edPW: TEdit
      AlignWithMargins = True
      Left = 83
      Top = 8
      Width = 185
      Height = 21
      Margins.Left = 0
      Margins.Top = 4
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alLeft
      TabOrder = 0
    end
    object btnResetPW: TButton
      Left = 289
      Top = 6
      Width = 69
      Height = 23
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Caption = 'Reset Code'
      TabOrder = 1
      OnClick = btnResetPWClick
    end
  end
  object pnlSSNEIN: TPanel
    Left = 0
    Top = 111
    Width = 369
    Height = 38
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    Padding.Left = 9
    Padding.Top = 4
    Padding.Right = 9
    Padding.Bottom = 9
    TabOrder = 5
    object lblSSNEIN: TLabel
      AlignWithMargins = True
      Left = 9
      Top = 10
      Width = 65
      Height = 13
      Margins.Left = 0
      Margins.Top = 6
      Margins.Right = 9
      Margins.Bottom = 0
      Align = alLeft
      Caption = 'User Email:'
      Constraints.MinWidth = 65
    end
    object edUserEmail: TEdit
      AlignWithMargins = True
      Left = 83
      Top = 8
      Width = 185
      Height = 21
      Margins.Left = 0
      Margins.Top = 4
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alLeft
      TabOrder = 0
    end
  end
  object pnlCanETY: TPanel
    Left = 0
    Top = 187
    Width = 369
    Height = 29
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    Padding.Left = 9
    Padding.Top = 4
    Padding.Right = 9
    Padding.Bottom = 9
    TabOrder = 6
    object cbCanETY: TCheckBox
      Left = 84
      Top = 4
      Width = 90
      Height = 16
      Caption = 'Can ETY'
      TabOrder = 0
    end
  end
end
