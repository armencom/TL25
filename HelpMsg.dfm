object frmHelpMsg: TfrmHelpMsg
  Left = 283
  Top = 101
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Error Condition'
  ClientHeight = 129
  ClientWidth = 294
  Color = clBtnFace
  DefaultMonitor = dmMainForm
  DragKind = dkDock
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblMsg: TMemo
    Left = 8
    Top = 8
    Width = 278
    Height = 25
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    BorderStyle = bsNone
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      'lblMsg')
    ParentFont = False
    TabOrder = 0
  end
  object btnCancel: TcxButton
    Left = 56
    Top = 96
    Width = 75
    Height = 25
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Cancel = True
    Caption = 'Cancel'
    LookAndFeel.Kind = lfOffice11
    TabOrder = 1
    OnClick = btnCancelClick
  end
  object btnGetHelp: TcxButton
    Left = 158
    Top = 96
    Width = 75
    Height = 25
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Help'
    LookAndFeel.Kind = lfOffice11
    TabOrder = 2
    OnClick = btnGetHelpClick
  end
  object btnDispNeg: TcxButton
    Left = 56
    Top = 55
    Width = 177
    Height = 25
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Display all trades with neg Shares'
    Default = True
    LookAndFeel.Kind = lfOffice11
    TabOrder = 3
    WordWrap = True
    OnClick = btnDispNegClick
  end
end
