object dlgAccountSetup: TdlgAccountSetup
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Account Setup'
  ClientHeight = 427
  ClientWidth = 423
  Color = clBtnFace
  DefaultMonitor = dmMainForm
  DragMode = dmAutomatic
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  ShowHint = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlButtons: TPanel
    Left = 0
    Top = 385
    Width = 423
    Height = 42
    Align = alBottom
    AutoSize = True
    BevelOuter = bvNone
    Padding.Top = 9
    Padding.Bottom = 9
    TabOrder = 3
    object btnCancel: TcxButton
      Left = 156
      Top = 9
      Width = 75
      Height = 24
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Cancel = True
      Caption = 'CANCEL'
      LookAndFeel.Kind = lfOffice11
      ModalResult = 2
      TabOrder = 0
    end
    object btnOK: TcxButton
      Left = 326
      Top = 9
      Width = 75
      Height = 24
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'OK'
      Default = True
      LookAndFeel.Kind = lfOffice11
      ModalResult = 1
      TabOrder = 1
      OnClick = btnOKClick
    end
  end
  object pnlName: TPanel
    Left = 0
    Top = 200
    Width = 423
    Height = 70
    Align = alBottom
    AutoSize = True
    BevelEdges = [beTop]
    BevelKind = bkFlat
    BevelOuter = bvNone
    Padding.Bottom = 9
    TabOrder = 0
    object lbAccountName: TStaticText
      Left = 10
      Top = 39
      Width = 135
      Height = 20
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      AutoSize = False
      Caption = 'Account Name:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object edAccountName: TcxTextEdit
      Left = 150
      Top = 37
      Hint = 'A descriptive Name that will appear on the tab display'
      Style.BorderStyle = ebs3D
      TabOrder = 1
      OnExit = edAccountNameExit
      OnKeyPress = edAccountNameKeyPress
      Width = 251
    end
    object lbAccountInformation: TStaticText
      AlignWithMargins = True
      Left = 10
      Top = 10
      Width = 411
      Height = 20
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 2
      Margins.Bottom = 2
      Align = alTop
      AutoSize = False
      Caption = 'Account Information'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
    end
  end
  object pnlAcctType: TPanel
    Left = 0
    Top = 270
    Width = 423
    Height = 115
    Align = alBottom
    AutoSize = True
    BevelOuter = bvNone
    Padding.Top = 9
    TabOrder = 1
    object rbGrpAccountType: TRzRadioGroup
      Left = 24
      Top = 9
      Width = 377
      Height = 106
      BorderSides = []
      Caption = 'Account Type'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ItemFont.Charset = DEFAULT_CHARSET
      ItemFont.Color = clWindowText
      ItemFont.Height = -11
      ItemFont.Name = 'Microsoft Sans Serif'
      ItemFont.Style = []
      Items.Strings = (
        'Regular Cash Basis (Taxable)'
        'IRA (Non Taxable)'
        'MTM (Taxable)')
      ParentFont = False
      SpaceEvenly = True
      TabOrder = 0
      VerticalSpacing = 6
      OnChanging = rbGrpAccountTypeChanging
      OnClick = rbGrpAccountTypeClick
      object lblMTMPlug: TRzLabel
        Left = 132
        Top = 40
        Width = 214
        Height = 15
        Caption = 'Available with TRADER or ELITE Levels'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -12
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        Visible = False
        BlinkIntervalOff = 100
        BlinkIntervalOn = 100
      end
      object ckMTMLastYear: TRzCheckBox
        Left = 133
        Top = 61
        Width = 170
        Height = 17
        Hint = 'Check this if you used MTM Accounting Last Year.'
        Caption = 'Did you use MTM last year?'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        State = cbUnchecked
        TabOrder = 0
      end
      object ckMTMForFutures: TRzCheckBox
        Left = 133
        Top = 82
        Width = 160
        Height = 17
        Hint = 'Check this if you elected to process Futures as MTM'
        Caption = 'MTM Elected for Futures?'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        State = cbUnchecked
        TabOrder = 1
      end
    end
  end
  object pnlBroker: TPanel
    Left = 0
    Top = 0
    Width = 423
    Height = 125
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    Padding.Bottom = 17
    TabOrder = 2
    object lbReadOnly: TRzLabel
      Left = 324
      Top = 71
      Width = 56
      Height = 13
      Caption = '(Read Only)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      Visible = False
      BlinkIntervalOff = 100
      BlinkIntervalOn = 100
    end
    object lbImportFilter: TStaticText
      Left = 10
      Top = 41
      Width = 156
      Height = 20
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      AutoSize = False
      Caption = 'Import Filter:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = lbImportFilterClick
    end
    object cboImpFilt: TcxComboBox
      Left = 190
      Top = 41
      Hint = 'Select an import filter from the list.'
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Properties.DropDownListStyle = lsFixedList
      Properties.DropDownRows = 20
      Properties.ImmediatePost = True
      Properties.ImmediateUpdateText = True
      Properties.PostPopupValueOnTab = True
      Properties.Sorted = True
      Properties.OnChange = cboImpFiltPropertiesChange
      Properties.OnEditValueChanged = cboImpFiltPropertiesEditValueChanged
      Style.LookAndFeel.Kind = lfStandard
      StyleDisabled.LookAndFeel.Kind = lfStandard
      StyleFocused.BorderColor = clWindowFrame
      StyleFocused.LookAndFeel.Kind = lfStandard
      StyleHot.LookAndFeel.Kind = lfStandard
      TabOrder = 1
      Width = 211
    end
    object StaticText1: TStaticText
      AlignWithMargins = True
      Left = 10
      Top = 10
      Width = 130
      Height = 20
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 2
      Margins.Bottom = 2
      Align = alTop
      Caption = 'Broker Information'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
    end
    object ckAutoAssignShorts: TRzCheckBox
      Left = 198
      Top = 70
      Width = 108
      Height = 15
      Hint = 
        'Automatically assign shorts to longs and longs to shorts. '#13#13'If n' +
        'o long trades are open, sales will import as "open, short" and '#13 +
        #13'If no short trades are open, buys will import as "close, short ' +
        '"'#13#13'If (Read Only) in red then this option cannot be changed for ' +
        'the import filter selected'
      Caption = 'Auto Assign Shorts'
      ReadOnlyColor = clRed
      State = cbUnchecked
      TabOrder = 3
      OnClick = ckAutoAssignShortsClick
    end
    object ckSLConvert: TRzCheckBox
      Left = 198
      Top = 93
      Width = 113
      Height = 15
      Hint = 
        'Short/Long Conversion:'#13#13'A single buy transaction will close'#13'a lo' +
        'ng trade and open a new short trade,'#13#13'and'#13#13'a single sell transac' +
        'tion will close'#13'a short trade and open a new long trade.'
      Caption = 'Short/Long Convert'
      State = cbUnchecked
      TabOrder = 4
      OnClick = ckSLConvertClick
    end
  end
  object pnlImpMethod: TPanel
    Left = 0
    Top = 125
    Width = 423
    Height = 74
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    Padding.Top = 9
    Padding.Bottom = 9
    TabOrder = 4
    object stBase: TStaticText
      Left = 10
      Top = 9
      Width = 156
      Height = 20
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      AutoSize = False
      Caption = 'Base Currency:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object cboBaseCurrency: TcxComboBox
      Left = 190
      Top = 9
      Hint = 
        'Since this broker supports flexible currency please select the c' +
        'urrency you are trading in'
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Properties.DropDownListStyle = lsFixedList
      Properties.ImmediatePost = True
      Properties.ImmediateUpdateText = True
      Properties.PostPopupValueOnTab = True
      Properties.Sorted = True
      Style.LookAndFeel.Kind = lfStandard
      StyleDisabled.LookAndFeel.Kind = lfStandard
      StyleFocused.BorderColor = clWindowFrame
      StyleFocused.LookAndFeel.Kind = lfStandard
      StyleHot.LookAndFeel.Kind = lfStandard
      TabOrder = 1
      Width = 211
    end
    object txtComm: TStaticText
      Left = 10
      Top = 45
      Width = 154
      Height = 20
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      AutoSize = False
      Caption = 'Commission per RT:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Microsoft Sand'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object edComm: TcxCurrencyEdit
      Left = 190
      Top = 42
      Hint = 
        'Since this broker supports Round trip commission please specify ' +
        'the default amount to use.'
      Properties.DisplayFormat = '##0.00'
      Properties.EditFormat = '##0.00'
      Style.BorderStyle = ebs3D
      TabOrder = 3
      Width = 121
    end
  end
end
