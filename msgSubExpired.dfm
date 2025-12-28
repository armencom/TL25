object frmSubExpired: TfrmSubExpired
  Left = 0
  Top = 0
  AutoSize = True
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Subscription Expired'
  ClientHeight = 288
  ClientWidth = 345
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object pnlMsg: TPanel
    AlignWithMargins = True
    Left = 20
    Top = 20
    Width = 305
    Height = 193
    Margins.Left = 20
    Margins.Top = 20
    Margins.Right = 20
    Margins.Bottom = 20
    Align = alClient
    AutoSize = True
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitLeft = 216
    ExplicitTop = 40
    ExplicitWidth = 185
    ExplicitHeight = 41
    object lblMsg: TLabel
      Left = 0
      Top = 0
      Width = 305
      Height = 193
      Align = alClient
      WordWrap = True
      ExplicitWidth = 3
      ExplicitHeight = 13
    end
  end
  object pnlBtns: TPanel
    Left = 0
    Top = 233
    Width = 345
    Height = 55
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object tnRenew: TRzButton
      Left = 125
      Top = 19
      Caption = 'RENEW'
      TabOrder = 0
    end
    object btnRegister: TRzButton
      Left = 20
      Top = 19
      Caption = 'REGISTER'
      TabOrder = 1
    end
    object RzButton1: TRzButton
      Left = 220
      Top = 19
      Width = 105
      Caption = 'RENEW LATER'
      TabOrder = 2
    end
  end
end
