object dlgBrokerSelect: TdlgBrokerSelect
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Select Account'
  ClientHeight = 235
  ClientWidth = 264
  Color = clBtnFace
  DragMode = dmAutomatic
  ParentFont = True
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 264
    Height = 235
    Align = alClient
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 0
    object rbExistingAccount: TRzRadioButton
      Left = 34
      Top = 24
      Width = 130
      Height = 15
      Caption = 'Select existing Account'
      TabOrder = 0
      OnClick = rbExistingAccountClick
    end
    object rbNewAccount: TRzRadioButton
      Left = 34
      Top = 159
      Width = 118
      Height = 15
      Caption = 'Create New Account'
      TabOrder = 1
      OnClick = rbNewAccountClick
    end
    object pnlButtons: TPanel
      Left = 0
      Top = 194
      Width = 264
      Height = 41
      Align = alBottom
      BevelOuter = bvNone
      ShowCaption = False
      TabOrder = 2
      object btnCancel: TRzButton
        Left = 43
        Top = 8
        Cancel = True
        ModalResult = 2
        Caption = '&Cancel'
        TabOrder = 0
      end
      object btnOK: TRzButton
        Left = 146
        Top = 8
        Default = True
        ModalResult = 1
        Caption = '&OK'
        TabOrder = 1
        OnClick = btnOKClick
      end
    end
    object lstBrokers: TRzListBox
      Left = 34
      Top = 47
      Width = 197
      Height = 101
      ItemHeight = 13
      TabOrder = 3
    end
  end
end
