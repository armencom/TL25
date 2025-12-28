object frmEditSplit: TfrmEditSplit
  Left = 221
  Top = 102
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Adjust for Stock Split'
  ClientHeight = 158
  ClientWidth = 408
  Color = clBtnFace
  DefaultMonitor = dmMainForm
  DragKind = dkDock
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 248
    Top = 16
    Width = 102
    Height = 16
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = '<- select ticker'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 248
    Top = 48
    Width = 86
    Height = 16
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = '<- enter split'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 248
    Top = 80
    Width = 121
    Height = 16
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = '<- enter split date'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 112
    Top = 48
    Width = 23
    Height = 20
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'for'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object editNewTicker: TcxTextEdit
    Left = 16
    Top = 48
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Properties.Alignment.Horz = taCenter
    Properties.CharCase = ecUpperCase
    TabOrder = 1
    Visible = False
    Width = 225
  end
  object dateSplit: TcxDateEdit
    Left = 76
    Top = 80
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    EditValue = 37987d
    Properties.Alignment.Horz = taCenter
    Properties.ReadOnly = False
    Properties.ShowTime = False
    Properties.UseLeftAlignmentOnEditing = False
    Style.LookAndFeel.Kind = lfStandard
    Style.PopupBorderStyle = epbsDefault
    StyleDisabled.LookAndFeel.Kind = lfStandard
    StyleFocused.LookAndFeel.Kind = lfStandard
    StyleHot.LookAndFeel.Kind = lfStandard
    TabOrder = 4
    Width = 97
  end
  object editSplit1: TcxTextEdit
    Left = 32
    Top = 48
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    AutoSize = False
    Properties.Alignment.Horz = taCenter
    TabOrder = 2
    Text = '2'
    Height = 21
    Width = 73
  end
  object editSplit2: TcxTextEdit
    Left = 144
    Top = 48
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    AutoSize = False
    Properties.Alignment.Horz = taCenter
    TabOrder = 3
    Text = '1'
    Height = 21
    Width = 73
  end
  object btnOK: TcxButton
    Left = 88
    Top = 120
    Width = 75
    Height = 25
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'OK'
    Default = True
    LookAndFeel.Kind = lfStandard
    TabOrder = 7
    OnClick = btnOKClick
  end
  object btnCancel: TcxButton
    Left = 264
    Top = 120
    Width = 75
    Height = 25
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Cancel = True
    Caption = 'Cancel'
    LookAndFeel.Kind = lfStandard
    TabOrder = 6
    OnClick = btnCancelClick
  end
  object editTick: TcxComboBox
    Left = 16
    Top = 16
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Properties.Alignment.Horz = taCenter
    Properties.CharCase = ecUpperCase
    Properties.ImmediateUpdateText = True
    Properties.ReadOnly = False
    Properties.Sorted = True
    Style.LookAndFeel.Kind = lfStandard
    Style.PopupBorderStyle = epbsDefault
    StyleDisabled.LookAndFeel.Kind = lfStandard
    StyleFocused.LookAndFeel.Kind = lfStandard
    StyleHot.LookAndFeel.Kind = lfStandard
    TabOrder = 0
    Width = 225
  end
  object btnNewTick: TcxButton
    Left = 104
    Top = 120
    Width = 75
    Height = 25
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'OK'
    Default = True
    Enabled = False
    LookAndFeel.Kind = lfStandard
    TabOrder = 5
    Visible = False
    OnClick = btnNewTickClick
  end
end
