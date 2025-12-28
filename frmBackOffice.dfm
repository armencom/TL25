object dlgBackOffice: TdlgBackOffice
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Back Office functions'
  ClientHeight = 265
  ClientWidth = 645
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblEmailAddr: TLabel
    Left = 13
    Top = 38
    Width = 69
    Height = 13
    Caption = 'email address:'
  end
  object Label2: TLabel
    Left = 13
    Top = 8
    Width = 109
    Height = 16
    Caption = 'User Information'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblUserName: TLabel
    Left = 13
    Top = 66
    Width = 52
    Height = 13
    Caption = 'User Name'
  end
  object lblDateCreated: TLabel
    Left = 464
    Top = 30
    Width = 65
    Height = 13
    Caption = 'Date Created'
  end
  object lblTrialExpires: TLabel
    Left = 464
    Top = 66
    Width = 58
    Height = 13
    Caption = 'Trial Expires'
  end
  object lblFileKeyInfo: TLabel
    Left = 13
    Top = 179
    Width = 78
    Height = 16
    Caption = 'File Key Info'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblNumTotal: TLabel
    Left = 13
    Top = 200
    Width = 32
    Height = 13
    Caption = '#Total'
  end
  object lblNumUsed: TLabel
    Left = 120
    Top = 200
    Width = 32
    Height = 13
    Caption = '#Used'
  end
  object lblAvail: TLabel
    Left = 221
    Top = 200
    Width = 31
    Height = 13
    Caption = '#Avail'
  end
  object edEmailAddr: TEdit
    Left = 93
    Top = 30
    Width = 237
    Height = 21
    TabOrder = 0
    OnChange = edEmailAddrChange
  end
  object btnAddFileKey: TButton
    Left = 544
    Top = 200
    Width = 93
    Height = 37
    Caption = 'Add Paid File Key'
    Enabled = False
    TabOrder = 5
    OnClick = btnAddFileKeyClick
  end
  object edUserName: TEdit
    Left = 93
    Top = 62
    Width = 237
    Height = 21
    Color = clGradientInactiveCaption
    ReadOnly = True
    TabOrder = 2
  end
  object edDateCreated: TEdit
    Left = 539
    Top = 30
    Width = 95
    Height = 21
    Color = clGradientInactiveCaption
    ReadOnly = True
    TabOrder = 1
  end
  object edTrialExpires: TEdit
    Left = 539
    Top = 62
    Width = 95
    Height = 21
    Color = clGradientInactiveCaption
    ReadOnly = True
    TabOrder = 3
  end
  object pnlSubs: TPanel
    Left = 8
    Top = 99
    Width = 629
    Height = 70
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 4
    VerticalAlignment = taAlignTop
    object lblSubscription: TLabel
      Left = 5
      Top = 7
      Width = 113
      Height = 16
      Caption = 'Subscription info:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblProduct: TLabel
      Left = 8
      Top = 30
      Width = 37
      Height = 13
      Caption = 'Product'
    end
    object lblSubExpires: TLabel
      Left = 228
      Top = 30
      Width = 72
      Height = 13
      Caption = 'Expiraton Date'
    end
    object edProduct: TEdit
      Left = 84
      Top = 30
      Width = 121
      Height = 19
      Color = clGradientInactiveCaption
      ReadOnly = True
      TabOrder = 0
    end
    object edSubExpires: TEdit
      Left = 316
      Top = 30
      Width = 92
      Height = 19
      Color = clGradientInactiveCaption
      ReadOnly = True
      TabOrder = 1
    end
    object btnChangeSub: TButton
      Left = 519
      Top = 17
      Width = 93
      Height = 37
      Caption = 'Add Subscription'
      TabOrder = 2
      Visible = False
      OnClick = btnChangeSubClick
    end
  end
  object edTotal: TEdit
    Left = 55
    Top = 201
    Width = 50
    Height = 21
    Color = clGradientInactiveCaption
    ReadOnly = True
    TabOrder = 6
    Text = '0'
  end
  object edUsed: TEdit
    Left = 158
    Top = 201
    Width = 49
    Height = 21
    Color = clGradientInactiveCaption
    ReadOnly = True
    TabOrder = 7
    Text = '0'
  end
  object edAvail: TEdit
    Left = 258
    Top = 201
    Width = 49
    Height = 21
    Color = clGradientInactiveCaption
    ReadOnly = True
    TabOrder = 8
    Text = '0'
  end
  object btnSearch: TButton
    Left = 346
    Top = 30
    Width = 93
    Height = 37
    Caption = 'Find Email'
    TabOrder = 9
    OnClick = btnSearchClick
  end
  object btnListFileKeys: TButton
    Left = 325
    Top = 200
    Width = 93
    Height = 37
    Caption = 'List File Keys'
    TabOrder = 10
    OnClick = btnListFileKeysClick
  end
  object btnAddFreeKey: TButton
    Left = 440
    Top = 201
    Width = 97
    Height = 36
    Caption = 'Add Free File Key'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 11
    OnClick = btnAddFreeKeyClick
  end
end
