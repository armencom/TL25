object NewBBIFU: TNewBBIFU
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'New Futures Options Found'
  ClientHeight = 380
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
  PixelsPerInch = 96
  TextHeight = 13
  object btnAddToFutures: TButton
    Left = 334
    Top = 128
    Width = 171
    Height = 25
    Caption = 'Add to Futures List >>'
    TabOrder = 1
    OnClick = btnAddToFuturesClick
  end
  object btnAddToBBIndex: TButton
    Left = 334
    Top = 167
    Width = 171
    Height = 25
    Caption = 'Add to BBIndex Options List >>'
    TabOrder = 2
    OnClick = btnAddToBBIndexClick
  end
  object pnlMessage: TPanel
    Left = 0
    Top = 0
    Width = 514
    Height = 122
    Color = clWindow
    ParentBackground = False
    TabOrder = 5
    object lblMsg1: TLabel
      Left = 21
      Top = 6
      Width = 458
      Height = 26
      Caption = 
        'This data file contains the following Broad-Based Index Options ' +
        'or Options on Futures not listed in your Global Options configur' +
        'ation.'
      WordWrap = True
    end
    object lblMsg2: TLabel
      Left = 21
      Top = 86
      Width = 484
      Height = 32
      AutoSize = False
      Caption = 
        'Please select each Symbol and update the modifier. Then Click on' +
        ' either the Add to futures list button or the add to BBIndex Opt' +
        'ions List button. Please do this for each symbol in the list.'
      WordWrap = True
    end
    object Label1: TLabel
      Left = 21
      Top = 38
      Width = 460
      Height = 39
      Caption = 
        'In order to avoid errors on your TradeLog Tax Forms you must spe' +
        'ficy an appropriate multiplier and add each symbol to the future' +
        's list or the Broad Based Options List. The multiplier must be g' +
        'reater than zero.'
      WordWrap = True
    end
  end
  object lstBBIFU: TListView
    Left = 21
    Top = 128
    Width = 291
    Height = 245
    Columns = <
      item
        Caption = 'Symbol'
        MaxWidth = 200
        Width = 135
      end
      item
        Caption = 'Multiplier'
        MaxWidth = 200
        Width = 135
      end>
    ColumnClick = False
    GridLines = True
    HideSelection = False
    MultiSelect = True
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
  end
  object btnCancel: TButton
    Left = 430
    Top = 348
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 4
    OnClick = btnCancelClick
  end
  object btnSelectAll: TButton
    Left = 334
    Top = 348
    Width = 75
    Height = 25
    Caption = 'Select All'
    TabOrder = 3
    OnClick = btnSelectAllClick
  end
  object btnChgMult: TButton
    Left = 334
    Top = 208
    Width = 171
    Height = 25
    Caption = '<< Change Multiplier'
    TabOrder = 6
    OnClick = btnChgMultClick
  end
end
