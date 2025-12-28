object dlgInputValue: TdlgInputValue
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Input Value'
  ClientHeight = 139
  ClientWidth = 345
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
  DesignSize = (
    345
    139)
  PixelsPerInch = 96
  TextHeight = 13
  object lblInstructions: TLabel
    Left = 8
    Top = 8
    Width = 61
    Height = 13
    Caption = 'Instructions:'
  end
  object lblPrompt: TLabel
    Left = 8
    Top = 50
    Width = 38
    Height = 13
    Caption = 'Prompt:'
  end
  object lblLink: TLabel
    Left = 8
    Top = 79
    Width = 230
    Height = 13
    Alignment = taCenter
    Anchors = [akLeft, akTop, akRight]
    Caption = 'https://support.tradelogsoftware.com/hc/en-us'
    Color = clRed
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMenuHighlight
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    OnClick = lblLinkClick
  end
  object Edit1: TEdit
    Left = 128
    Top = 47
    Width = 209
    Height = 21
    TabOrder = 0
    Text = 'Edit1'
  end
  object btnOK: TButton
    Left = 262
    Top = 98
    Width = 75
    Height = 33
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 160
    Top = 98
    Width = 75
    Height = 33
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = btnCancelClick
  end
end
