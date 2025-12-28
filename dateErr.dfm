object frmDateErr: TfrmDateErr
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'frmDateErr'
  ClientHeight = 181
  ClientWidth = 258
  Color = clBtnFace
  DefaultMonitor = dmDesktop
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 131
    Width = 258
    Height = 50
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object btnHelp: TButton
      Left = 10
      Top = 11
      Width = 75
      Height = 25
      Caption = 'Online HELP'
      TabOrder = 0
      Visible = False
      OnClick = btnHelpClick
    end
    object btnOK: TButton
      Left = 91
      Top = 12
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      TabOrder = 1
      OnClick = btnOKClick
    end
  end
  object lblMsg: TMemo
    AlignWithMargins = True
    Left = 10
    Top = 10
    Width = 238
    Height = 111
    Margins.Left = 10
    Margins.Top = 10
    Margins.Right = 10
    Margins.Bottom = 10
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 1
  end
end
