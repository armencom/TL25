object dlgPickTaxFiles: TdlgPickTaxFiles
  Left = 0
  Top = 0
  BorderIcons = []
  Caption = 'File Keys for this Registered User'
  ClientHeight = 387
  ClientWidth = 357
  Color = clBtnFace
  Constraints.MinHeight = 425
  Constraints.MinWidth = 371
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlMain: TPanel
    Left = 0
    Top = 53
    Width = 357
    Height = 334
    Margins.Top = 0
    Align = alClient
    BevelOuter = bvNone
    Padding.Left = 9
    Padding.Right = 9
    Padding.Bottom = 9
    ShowCaption = False
    TabOrder = 0
    object pnlButtons: TPanel
      Left = 9
      Top = 284
      Width = 339
      Height = 41
      Align = alBottom
      BevelOuter = bvNone
      ShowCaption = False
      TabOrder = 0
      object btnClose: TRzButton
        Left = 264
        Top = 16
        Cancel = True
        ModalResult = 2
        Caption = '&Close'
        TabOrder = 0
        OnClick = btnCloseClick
      end
      object btnReset: TRzButton
        Left = 88
        Top = 16
        Default = True
        ModalResult = 1
        Caption = 'Reset'
        TabOrder = 1
        OnClick = btnResetClick
      end
      object btnCopy: TRzButton
        Left = 0
        Top = 16
        Hint = 'Copy lits to Winodws clipboard'
        Default = True
        Caption = 'Copy'
        TabOrder = 2
        OnClick = btnCopyClick
      end
      object btnDelete: TRzButton
        Left = 176
        Top = 16
        Default = True
        ModalResult = 6
        Caption = 'Delete'
        TabOrder = 3
        OnClick = btnDeleteClick
      end
    end
    object lstTaxfiles: TRzListBox
      Left = 9
      Top = 0
      Width = 339
      Height = 284
      Align = alClient
      ItemHeight = 13
      MultiSelect = True
      TabOrder = 1
      OnClick = lstTaxfilesClick
    end
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 357
    Height = 53
    Align = alTop
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    DesignSize = (
      357
      53)
    object lblTaxFiles: TLabel
      AlignWithMargins = True
      Left = 169
      Top = 9
      Width = 59
      Height = 13
      Margins.Left = 0
      Margins.Top = 9
      Margins.Right = 4
      Margins.Bottom = 9
      Caption = 'lblTaxFiles'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label1: TLabel
      AlignWithMargins = True
      Left = 9
      Top = 7
      Width = 145
      Height = 13
      Margins.Left = 9
      Margins.Top = 9
      Margins.Right = 4
      Margins.Bottom = 9
      Anchors = [akLeft]
      AutoSize = False
      Caption = 'Total linked File Keys: '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 9
      Top = 30
      Width = 145
      Height = 13
      Anchors = [akLeft]
      AutoSize = False
      Caption = 'Number of File Keys available:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblAvailable: TLabel
      AlignWithMargins = True
      Left = 169
      Top = 30
      Width = 65
      Height = 13
      Caption = 'lblAvailable'
    end
    object btnTracking: TRzButton
      Left = 273
      Top = 14
      Default = True
      Caption = 'Tracking'
      TabOrder = 0
      OnClick = btnTrackingClick
    end
  end
end
