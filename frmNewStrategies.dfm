object NewStrategies: TNewStrategies
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'New Strategies Found'
  ClientHeight = 356
  ClientWidth = 513
  Color = clBtnFace
  DragKind = dkDock
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object lstStrategy: TListBox
    Left = 20
    Top = 86
    Width = 291
    Height = 245
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    ItemHeight = 13
    MultiSelect = True
    TabOrder = 0
  end
  object btnAddToStrategyList: TButton
    Left = 336
    Top = 86
    Width = 169
    Height = 25
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Add to Strategies List >>'
    TabOrder = 1
    OnClick = btnAddToStrategyListClick
  end
  object pnlMessage: TPanel
    Left = -1
    Top = 0
    Width = 514
    Height = 70
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Color = clWindow
    ParentBackground = False
    TabOrder = 2
    object lblMsg1: TLabel
      Left = 21
      Top = 10
      Width = 288
      Height = 26
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 
        'Data file contains the following strategy item(s) not listed in ' +
        'your configuration.'
      WordWrap = True
    end
    object lblMsg2: TLabel
      Left = 21
      Top = 36
      Width = 476
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      AutoSize = False
      Caption = 
        'Please select the Strategies you would like to add and click the' +
        ' Add to Strategies List button.'
    end
  end
  object btnCancel: TButton
    Left = 430
    Top = 306
    Width = 75
    Height = 25
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 4
    OnClick = btnCancelClick
  end
  object btnSelectAll: TButton
    Left = 336
    Top = 306
    Width = 75
    Height = 25
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Select All'
    TabOrder = 3
    OnClick = btnSelectAllClick
  end
end
