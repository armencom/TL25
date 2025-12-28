object frmSubExpired: TfrmSubExpired
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Subscription Expired'
  ClientHeight = 381
  ClientWidth = 486
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 106
  TextHeight = 14
  object pnlMsg: TPanel
    AlignWithMargins = True
    Left = 22
    Top = 22
    Width = 442
    Height = 295
    Margins.Left = 22
    Margins.Top = 22
    Margins.Right = 22
    Margins.Bottom = 0
    Align = alClient
    AutoSize = True
    BevelOuter = bvNone
    TabOrder = 0
    object msg2: TLabel
      AlignWithMargins = True
      Left = 0
      Top = 144
      Width = 442
      Height = 54
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 11
      Align = alTop
      Caption = 
        'If you have already renewed your subscription you will need to c' +
        'lick on the REGISTER button below and enter the new Reg Code you' +
        ' received when you renewed (located on your invoice).'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      WordWrap = True
      ExplicitTop = 141
      ExplicitWidth = 443
    end
    object msg1: TLabel
      AlignWithMargins = True
      Left = 0
      Top = 97
      Width = 442
      Height = 36
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 11
      Align = alTop
      Caption = 
        'Therefore, you will only have limted functionality such as openi' +
        'ng and viewing your existing data files. '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      WordWrap = True
      ExplicitTop = 96
      ExplicitWidth = 427
    end
    object msg3: TLabel
      AlignWithMargins = True
      Left = 0
      Top = 209
      Width = 442
      Height = 36
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 11
      Align = alTop
      Caption = 
        'If you have not yet renewed, please click on the RENEW NOW butto' +
        'n below to go to our online renewal page.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      WordWrap = True
      ExplicitTop = 204
      ExplicitWidth = 416
    end
    object msg4: TLabel
      AlignWithMargins = True
      Left = 0
      Top = 256
      Width = 442
      Height = 36
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 11
      Align = alTop
      Caption = 
        'If you would like to continue without renewing, click the RENEW ' +
        'LATER button below. '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      WordWrap = True
      ExplicitTop = 249
      ExplicitWidth = 415
    end
    object pnlReg: TPanel
      Left = 0
      Top = 0
      Width = 442
      Height = 42
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      TabOrder = 0
      object lbl1: TLabel
        Left = -5
        Top = 0
        Width = 128
        Height = 18
        Alignment = taRightJustify
        Caption = 'Registration Code  :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label1: TLabel
        Left = 17
        Top = 24
        Width = 106
        Height = 18
        Alignment = taRightJustify
        Caption = 'Registered To  :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object lblRegCode: TLabel
        Left = 142
        Top = 0
        Width = 120
        Height = 18
        Caption = 'xxxx-xxxx-xxxx'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblRegName: TLabel
        Left = 142
        Top = 24
        Width = 182
        Height = 18
        Caption = 'Cogenta Computing, Inc.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
    object pnlExpDate: TPanel
      AlignWithMargins = True
      Left = 0
      Top = 53
      Width = 442
      Height = 44
      Margins.Left = 0
      Margins.Top = 11
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      TabOrder = 1
      object lblExpDate: TLabel
        AlignWithMargins = True
        Left = 231
        Top = 11
        Width = 98
        Height = 22
        Margins.Left = 0
        Margins.Top = 11
        Margins.Right = 0
        Margins.Bottom = 11
        Align = alLeft
        Caption = '01/01/2013'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitLeft = 216
        ExplicitHeight = 18
      end
      object lblExpOn: TLabel
        AlignWithMargins = True
        Left = 0
        Top = 11
        Width = 220
        Height = 22
        Margins.Left = 0
        Margins.Top = 11
        Margins.Right = 11
        Margins.Bottom = 11
        Align = alLeft
        Caption = 'Your subscription expired on:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitHeight = 18
      end
    end
  end
  object pnlBtns: TPanel
    Left = 0
    Top = 317
    Width = 486
    Height = 64
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btnRenew: TRzButton
      Left = 186
      Top = 20
      Width = 108
      Height = 27
      Caption = 'RENEW NOW'
      TabOrder = 0
      OnClick = btnRenewClick
    end
    object btnRegister: TRzButton
      Left = 22
      Top = 20
      Width = 107
      Height = 27
      Default = True
      Caption = 'REGISTER'
      TabOrder = 1
      OnClick = btnRegisterClick
    end
    object btnLater: TRzButton
      Left = 356
      Top = 20
      Width = 108
      Height = 27
      Cancel = True
      ModalResult = 8
      Caption = 'RENEW LATER'
      TabOrder = 2
    end
  end
end
