object AssignStrategy: TAssignStrategy
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Select Strategy'
  ClientHeight = 430
  ClientWidth = 327
  Color = clBtnFace
  DragKind = dkDock
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object lblStrategyCount: TLabel
    Left = 16
    Top = 19
    Width = 80
    Height = 13
    Caption = 'Trade Strategies'
  end
  object lstStrategy: TListBox
    Left = 16
    Top = 38
    Width = 291
    Height = 323
    ItemHeight = 13
    TabOrder = 0
  end
  object btnAssign: TButton
    Left = 136
    Top = 384
    Width = 75
    Height = 25
    Caption = 'Assign'
    Default = True
    TabOrder = 1
    OnClick = btnAssignClick
  end
  object btnCancel: TButton
    Left = 232
    Top = 384
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = btnCancelClick
  end
end
