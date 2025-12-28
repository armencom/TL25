object dlgImportSetup: TdlgImportSetup
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Import Settings'
  ClientHeight = 295
  ClientWidth = 413
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
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBroker: TPanel
    Left = 0
    Top = 0
    Width = 413
    Height = 84
    Align = alTop
    BevelOuter = bvNone
    Padding.Bottom = 17
    TabOrder = 1
    object Label2: TLabel
      Left = 16
      Top = 2
      Width = 150
      Height = 15
      Caption = 'BrokerConnect Settings'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edAcctName: TcxTextEdit
      Left = 182
      Top = 53
      Hint = 'A descriptive Name that will appear on the tab display'
      Enabled = False
      Style.BorderStyle = ebs3D
      TabOrder = 3
      Width = 219
    end
    object lblAcctName: TcxLabel
      Left = 80
      Top = 53
      Hint = 
        'This is a combination of Broker and Account number as is unique ' +
        'to this combination.'
      Caption = 'account name:'
      ParentFont = False
      Style.BorderColor = clBtnFace
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -13
      Style.Font.Name = 'Microsoft Sans Serif'
      Style.Font.Style = []
      Style.Shadow = False
      Style.TextStyle = []
      Style.TransparentBorder = False
      Style.IsFontAssigned = True
      Properties.ShadowedColor = clBtnFace
      Transparent = True
    end
    object edBroker: TcxTextEdit
      Left = 182
      Top = 24
      Hint = 'A descriptive Name that will appear on the tab display'
      Properties.ReadOnly = True
      Style.BorderStyle = ebs3D
      TabOrder = 0
      Width = 219
    end
    object lblBroker: TcxLabel
      Left = 88
      Top = 24
      Caption = 'broker name:'
      ParentFont = False
      Style.BorderColor = clBtnFace
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -13
      Style.Font.Name = 'Microsoft Sans Serif'
      Style.Font.Style = []
      Style.Shadow = False
      Style.TextStyle = []
      Style.TransparentBorder = False
      Style.IsFontAssigned = True
      Properties.ShadowedColor = clBtnFace
      Transparent = True
    end
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 259
    Width = 413
    Height = 36
    Align = alBottom
    BevelOuter = bvNone
    Padding.Top = 9
    Padding.Bottom = 9
    TabOrder = 3
    object btnCancel: TcxButton
      Left = 182
      Top = 5
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
      OnClick = btnCancelClick
    end
    object btnOK: TcxButton
      Left = 326
      Top = 1
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
  object pnlPlaid: TPanel
    Left = 0
    Top = 84
    Width = 413
    Height = 119
    Align = alTop
    BevelOuter = bvNone
    Padding.Bottom = 17
    TabOrder = 0
    object lblInstructions: TLabel
      Left = 44
      Top = 7
      Width = 357
      Height = 13
      Caption = 
        'Select the linked broker account associated with this account ta' +
        'b (or link it):'
    end
    object cboAcctName: TcxComboBox
      Left = 182
      Top = 28
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
      Properties.OnChange = cboAcctNamePropertiesChange
      Style.LookAndFeel.Kind = lfStandard
      StyleDisabled.LookAndFeel.Kind = lfStandard
      StyleFocused.BorderColor = clWindowFrame
      StyleFocused.LookAndFeel.Kind = lfStandard
      StyleHot.LookAndFeel.Kind = lfStandard
      TabOrder = 0
      Width = 219
    end
    object btnFastLink: TcxButton
      Left = 16
      Top = 28
      Width = 131
      Height = 38
      Caption = 'Link Account(s)'
      Colors.Normal = clLime
      TabOrder = 1
      OnClick = btnFastLinkClick
    end
    object cboAcctId: TcxComboBox
      Left = 182
      Top = 56
      Enabled = False
      TabOrder = 2
      OnClick = cboAcctIdClick
      Width = 219
    end
    object btnUnlink: TcxButton
      Left = 16
      Top = 72
      Width = 131
      Height = 38
      Caption = 'UnLink Broker'
      Colors.Normal = clLime
      TabOrder = 3
      OnClick = btnUnlinkClick
    end
  end
  object pnlCredentials: TPanel
    Left = 0
    Top = 203
    Width = 413
    Height = 51
    Align = alTop
    BevelOuter = bvNone
    Padding.Bottom = 17
    TabOrder = 2
    object lblPwd: TcxLabel
      Left = 114
      Top = 26
      Caption = 'query ID:'
      ParentFont = False
      Style.BorderColor = clBtnFace
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -13
      Style.Font.Name = 'Microsoft Sans Serif'
      Style.Font.Style = []
      Style.Shadow = False
      Style.TextStyle = []
      Style.TransparentBorder = False
      Style.IsFontAssigned = True
      Properties.ShadowedColor = clBtnFace
      Transparent = True
    end
    object edPwd: TcxTextEdit
      Left = 182
      Top = 26
      Hint = 'A descriptive Name that will appear on the tab display'
      Properties.EchoMode = eemPassword
      Properties.PasswordChar = '*'
      Style.BorderStyle = ebs3D
      TabOrder = 2
      Visible = False
      Width = 219
    end
    object edUser: TcxTextEdit
      Left = 182
      Top = 2
      Hint = 'A descriptive Name that will appear on the tab display'
      Style.BorderStyle = ebs3D
      TabOrder = 1
      OnExit = edUserExit
      Width = 219
    end
    object lblUser: TcxLabel
      Left = 131
      Top = 2
      Caption = 'token:'
      ParentFont = False
      Style.BorderColor = clBtnFace
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -13
      Style.Font.Name = 'Microsoft Sans Serif'
      Style.Font.Style = []
      Style.Shadow = False
      Style.TextStyle = []
      Style.TransparentBorder = False
      Style.IsFontAssigned = True
      Properties.ShadowedColor = clBtnFace
      Transparent = True
    end
  end
end
