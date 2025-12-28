object dlgFileSave: TdlgFileSave
  Left = 310
  Top = 117
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'New Data File'
  ClientHeight = 500
  ClientWidth = 526
  Color = clBtnFace
  Constraints.MinHeight = 499
  Constraints.MinWidth = 532
  DefaultMonitor = dmMainForm
  DragKind = dkDock
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  Scaled = False
  OnActivate = FormActivate
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlAMain: TPanel
    Left = 0
    Top = 0
    Width = 526
    Height = 165
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    VerticalAlignment = taAlignTop
    object lblTaxReturn: TLabel
      Left = 14
      Top = 7
      Width = 236
      Height = 15
      BiDiMode = bdLeftToRight
      Caption = 'TAX RETURN YEAR FOR YOUR FILE:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = [fsBold]
      ParentBiDiMode = False
      ParentFont = False
    end
    object lblTaxYear: TLabel
      Left = 18
      Top = 27
      Width = 46
      Height = 13
      BiDiMode = bdLeftToRight
      Caption = 'Tax Year:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentBiDiMode = False
      ParentFont = False
    end
    object lblTaxpayer: TLabel
      Left = 14
      Top = 64
      Width = 217
      Height = 13
      Caption = 'FULL NAME USED ON TAX RETURN:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblTaxpayerTip: TLabel
      Left = 18
      Top = 84
      Width = 256
      Height = 13
      Caption = 'It is not necessary to use two names when filing jointly.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblTaxpayerName: TLabel
      Left = 18
      Top = 107
      Width = 78
      Height = 13
      Caption = 'Taxpayer Name:'
    end
    object lblHyperLink1: TLabel
      Left = 80
      Top = 131
      Width = 285
      Height = 13
      Caption = 'Learn about how we use and secure your private information'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMenuHighlight
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      OnClick = lblHyperLink1Click
      OnMouseEnter = lblHyperLink1MouseEnter
      OnMouseLeave = lblHyperLink1MouseLeave
    end
    object cboProTaxYear: TcxComboBox
      Left = 115
      Top = 26
      Hint = 'Select Tax Year this file applies to.'
      Properties.Alignment.Horz = taCenter
      Properties.OnChange = cboProTaxYearPropertiesChange
      Style.LookAndFeel.Kind = lfStandard
      StyleDisabled.LookAndFeel.Kind = lfStandard
      StyleFocused.LookAndFeel.Kind = lfStandard
      StyleHot.LookAndFeel.Kind = lfStandard
      TabOrder = 0
      Text = 'cboProTaxYear'
      Width = 89
    end
    object txtTaxpayer: TcxTextEdit
      Left = 115
      Top = 104
      Hint = 'Please provide a file name for this file.'
      Style.LookAndFeel.Kind = lfStandard
      StyleDisabled.LookAndFeel.Kind = lfStandard
      StyleFocused.LookAndFeel.Kind = lfStandard
      StyleHot.LookAndFeel.Kind = lfStandard
      TabOrder = 1
      Text = 'txtTaxpayer'
      OnEnter = txtTaxpayerEnter
      OnExit = txtTaxpayerExit
      Width = 250
    end
    object cxImage1: TcxImage
      Left = 58
      Top = 130
      AutoSize = True
      Picture.Data = {
        0B546478504E47496D61676589504E470D0A1A0A0000000D4948445200000010
        0000001008060000001FF3FF610000000467414D410000B18F0BFC6105000001
        8749444154384F7D524D4B4241149D5F94D5DF88FA0511B588B28D2D7AEA3617
        2E14D322EC4309EDAD82D2D4858BC822092BC8BE40E9F55C146652062A7D9806
        AF77C6A7BD374E1D383033F79E3B73EF1CC2C3842B336809E4ED7321C92B846E
        17B01E771DF76BE1BF31BD74396017E598335169BA9355454F9CD936E5DD49EF
        05BF90D99F1D71EC941F5921CBF948A938B37A35ACC9DAC0CD3CF14AAA4EC99E
        A388E125825888B349278586725F695166E48621065AC542948A3130B6677FAA
        46859DFDC36B8B9EE9739CF1CAD7A8276D2298B03E006EA4EB4A5AFAECEEE5E7
        96B276D8DBCA6C3067254258F6B1013D63D977E5AEDCE4C684B0E4530B487F16
        58576F7DAA7E2B8B7BC6E777088F104B3067E305C1E4F5877290FF6D85A52590
        13081CC6330EB8BC5FA3E4C59C8997E698EFA88FFE041CC64BDA3A7BA3E4C5D4
        D945A8188029542315D9245AE0B4B78063BB549CF2644D9ABC0DD8130E639359
        426CF6DF0C69322350150E834958217AB68A72D4EC3E6FF7FD1F301C9804DF04
        62DD1D980184FC007F3473F3D8134DA20000000049454E44AE426082}
      TabOrder = 2
    end
  end
  object pnlcFileName: TPanel
    Left = 0
    Top = 165
    Width = 526
    Height = 68
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    VerticalAlignment = taAlignTop
    Visible = False
    object lbTaxYear: TLabel
      Left = 8
      Top = 8
      Width = 79
      Height = 13
      ParentCustomHint = False
      Caption = 'Select Tax Year:'
    end
    object lblMustBe: TLabel
      Left = 212
      Top = 8
      Width = 297
      Height = 13
      Caption = 'THIS MUST BE THE YEAR OF YOUR TAX RETURN'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lbAcctName: TLabel
      Left = 8
      Top = 40
      Width = 50
      Height = 13
      Caption = 'File Name:'
    end
    object cboTaxYear: TcxComboBox
      Left = 104
      Top = 8
      Hint = 'Select Tax Year this file applies to.'
      Properties.Alignment.Horz = taCenter
      Style.LookAndFeel.Kind = lfStandard
      StyleDisabled.LookAndFeel.Kind = lfStandard
      StyleFocused.LookAndFeel.Kind = lfStandard
      StyleHot.LookAndFeel.Kind = lfStandard
      TabOrder = 0
      Text = 'cboTaxYear'
      Width = 89
    end
    object txtFileName: TcxTextEdit
      Left = 104
      Top = 41
      Hint = 'Please provide a file name for this file.'
      Style.LookAndFeel.Kind = lfStandard
      StyleDisabled.LookAndFeel.Kind = lfStandard
      StyleFocused.LookAndFeel.Kind = lfStandard
      StyleHot.LookAndFeel.Kind = lfStandard
      TabOrder = 1
      Width = 293
    end
  end
  object pnlxPassword: TPanel
    Left = 0
    Top = 233
    Width = 526
    Height = 136
    Align = alTop
    BevelEdges = [beTop, beBottom]
    BevelKind = bkFlat
    BevelOuter = bvNone
    TabOrder = 2
    VerticalAlignment = taAlignTop
    object lblRegCustomer: TLabel
      Left = 18
      Top = 40
      Width = 85
      Height = 13
      Caption = 'File Registered to:'
    end
    object Label2: TLabel
      Left = 14
      Top = 12
      Width = 344
      Height = 13
      Caption = 'FILE REGISTRATION DETAILS (UPDATED AFTER SAVING)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object txtEmail: TcxTextEdit
      Left = 18
      Top = 68
      Hint = 'Please provide a file name for this file.'
      Enabled = False
      Properties.ReadOnly = True
      Style.BorderStyle = ebs3D
      Style.LookAndFeel.Kind = lfStandard
      StyleDisabled.LookAndFeel.Kind = lfStandard
      StyleFocused.LookAndFeel.Kind = lfStandard
      StyleHot.LookAndFeel.Kind = lfStandard
      TabOrder = 0
      Text = 'txtEmail'
      OnEnter = txtTaxpayerEnter
      OnExit = txtTaxpayerExit
      Width = 319
    end
    object btnEmail: TButton
      Left = 244
      Top = 98
      Width = 93
      Height = 21
      Caption = 'Update Email'
      TabOrder = 1
      OnClick = btnEmailClick
    end
  end
  object pnlySelect: TPanel
    Left = 0
    Top = 369
    Width = 526
    Height = 80
    Align = alTop
    BevelKind = bkFlat
    BevelOuter = bvNone
    TabOrder = 3
    VerticalAlignment = taAlignTop
    object txtFolderName: TLabel
      Left = 22
      Top = 51
      Width = 92
      Height = 13
      Caption = 'Taxpayer Name:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clHighlight
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblFileFolderHdr: TLabel
      Left = 12
      Top = 8
      Width = 79
      Height = 13
      Caption = 'FILE FOLDER'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lbFileLocation: TLabel
      Left = 16
      Top = 32
      Width = 289
      Height = 13
      Caption = 'Create TradeLog file in the following folder on your hard drive:'
    end
    object btnSelFolder: TcxButton
      Left = 427
      Top = 10
      Width = 80
      Height = 25
      Caption = 'Select Folder'
      TabOrder = 0
      OnClick = btnSelFolderClick
    end
  end
  object pnlzButtons: TPanel
    Left = 0
    Top = 449
    Width = 526
    Height = 50
    Align = alTop
    BevelEdges = [beTop]
    BevelKind = bkFlat
    BevelOuter = bvNone
    TabOrder = 4
    VerticalAlignment = taAlignTop
    object btnOK: TcxButton
      Left = 165
      Top = 10
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      LookAndFeel.Kind = lfOffice11
      ModalResult = 1
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TcxButton
      Left = 254
      Top = 10
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      LookAndFeel.Kind = lfOffice11
      ModalResult = 2
      TabOrder = 1
    end
    object btnHelp: TcxButton
      Left = 342
      Top = 10
      Width = 75
      Height = 25
      Caption = 'Help'
      LookAndFeel.Kind = lfOffice11
      TabOrder = 2
      OnClick = btnHelpClick
    end
  end
end
