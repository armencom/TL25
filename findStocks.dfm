object frmFindStocks: TfrmFindStocks
  Left = 0
  Top = 0
  Caption = 'Filter Grid'
  ClientHeight = 380
  ClientWidth = 601
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object btnOK: TcxButton
    Left = 505
    Top = 331
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    LookAndFeel.Kind = lfOffice11
    TabOrder = 0
    OnClick = btnOKClick
  end
  object btnCancel: TcxButton
    Left = 300
    Top = 331
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    LookAndFeel.Kind = lfOffice11
    ModalResult = 2
    TabOrder = 1
    OnClick = btnCancelClick
  end
  object rgOption: TGroupBox
    Left = 284
    Top = 183
    Width = 110
    Height = 98
    Caption = 'OPTION TYPE:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    Visible = False
    object rbOptAll: TRadioButton
      Left = 16
      Top = 25
      Width = 75
      Height = 17
      Caption = '&Both'
      Checked = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      TabStop = True
    end
    object rbPuts: TRadioButton
      Left = 16
      Top = 48
      Width = 75
      Height = 17
      Caption = '&Puts'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object rbCalls: TRadioButton
      Left = 16
      Top = 71
      Width = 75
      Height = 17
      Caption = '&Calls'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
  end
  object rgInstr: TGroupBox
    Left = 8
    Top = 8
    Width = 580
    Height = 153
    Caption = 'INSTRUMENT TYPE:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    object rbStocks: TRadioButton
      Left = 32
      Top = 26
      Width = 130
      Height = 17
      Caption = '&Stocks && Bonds'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = rbStocksClick
    end
    object rbFutures: TRadioButton
      Left = 383
      Top = 24
      Width = 85
      Height = 17
      Hint = 'Futures are reported on Form 6781'
      Caption = '&Futures'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = rbFuturesClick
    end
    object rbCurr: TRadioButton
      Left = 383
      Top = 56
      Width = 85
      Height = 17
      Hint = 'Currencies are reported on 1040 line 21'
      Caption = '&Currencies'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = rbCurrClick
    end
    object rbStkOptSSF: TRadioButton
      Left = 32
      Top = 116
      Width = 297
      Height = 17
      Hint = 'All Instruments that get reported on Schedule D'
      Caption = '&Schedule D Instruments (all of the above)'
      Checked = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      TabStop = True
      OnClick = rbStocksClick
    end
    object rbOptions: TRadioButton
      Left = 188
      Top = 86
      Width = 130
      Height = 17
      Caption = '&Options'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnClick = rbOptionsClick
    end
    object rbSSF: TRadioButton
      Left = 188
      Top = 56
      Width = 130
      Height = 17
      Caption = '&SSF'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      OnClick = rbSSFClick
    end
    object rbMutFunds: TRadioButton
      Left = 32
      Top = 56
      Width = 130
      Height = 17
      Caption = '&Mutual Funds'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      OnClick = rbStocksClick
    end
    object rbETFs: TRadioButton
      Left = 32
      Top = 86
      Width = 130
      Height = 17
      Caption = '&ETF/ETN'#39's'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
      OnClick = rbStocksClick
    end
    object rbDrips: TRadioButton
      Left = 188
      Top = 24
      Width = 130
      Height = 17
      Caption = '&Drips'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 8
      OnClick = rbStocksClick
    end
    object pnlSepLine: TPanel
      Left = 325
      Top = 13
      Width = 1
      Height = 134
      BevelEdges = [beRight]
      BevelKind = bkFlat
      BevelOuter = bvNone
      TabOrder = 9
    end
  end
  object rgSL: TGroupBox
    Left = 8
    Top = 183
    Width = 110
    Height = 98
    Caption = 'SHORT / LONG:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    object rbSL: TRadioButton
      Left = 16
      Top = 25
      Width = 90
      Height = 17
      Caption = '&Both'
      Checked = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      TabStop = True
    end
    object rbShort: TRadioButton
      Left = 16
      Top = 48
      Width = 90
      Height = 17
      Caption = '&Short'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object rbLong: TRadioButton
      Left = 17
      Top = 71
      Width = 90
      Height = 17
      Caption = '&Long'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
  end
  object rgPS: TGroupBox
    Left = 139
    Top = 183
    Width = 126
    Height = 98
    Caption = 'PURCH / SALES'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    object rbPS: TRadioButton
      Left = 16
      Top = 25
      Width = 100
      Height = 17
      Caption = '&Both'
      Checked = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      TabStop = True
    end
    object rbPurch: TRadioButton
      Left = 16
      Top = 48
      Width = 100
      Height = 17
      Caption = '&Purchases'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object rbSales: TRadioButton
      Left = 16
      Top = 71
      Width = 100
      Height = 17
      Caption = '&Sales'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
  end
  object cbClearFilt: TCheckBox
    Left = 114
    Top = 339
    Width = 159
    Height = 17
    Caption = 'Clear All Other Filters'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
  end
  object rgFut: TGroupBox
    Left = 417
    Top = 183
    Width = 163
    Height = 122
    Caption = 'FUTURE TYPE:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 7
    Visible = False
    object rbFutAll: TRadioButton
      Left = 11
      Top = 23
      Width = 140
      Height = 17
      Caption = 'Futures &All'
      Checked = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      TabStop = True
      OnClick = rbFutAllClick
    end
    object rbFutContr: TRadioButton
      Left = 11
      Top = 46
      Width = 140
      Height = 17
      Caption = 'Futures &Contracts'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = rbFutContrClick
    end
    object rbFutOpt: TRadioButton
      Left = 11
      Top = 71
      Width = 140
      Height = 17
      Caption = 'Futures &Options'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = rbFutOptClick
    end
    object rbIndex: TRadioButton
      Left = 11
      Top = 94
      Width = 140
      Height = 17
      Caption = 'Broad-Based &Index'
      Enabled = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = rbIndexClick
    end
  end
  object btnReset: TcxButton
    Left = 401
    Top = 331
    Width = 75
    Height = 25
    Hint = 'Reset all selections'
    Caption = 'RESET'
    LookAndFeel.Kind = lfOffice11
    TabOrder = 8
    OnClick = btnResetClick
  end
  object cbTaxYr: TCheckBox
    Left = 114
    Top = 307
    Width = 133
    Height = 17
    Hint = 'Filter by current tax year - clears all other filters '
    Caption = 'Current Tax Year'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 9
    OnClick = cbTaxYrClick
  end
end
