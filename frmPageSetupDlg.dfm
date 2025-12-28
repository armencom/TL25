object PageSetupDlg: TPageSetupDlg
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  BorderWidth = 1
  Caption = 'Report Setup'
  ClientHeight = 271
  ClientWidth = 327
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 327
    Height = 243
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitHeight = 332
    object grpMargins: TGroupBox
      Left = 122
      Top = 99
      Width = 189
      Height = 86
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Margins (Inches)'
      TabOrder = 3
      object Label5: TLabel
        Left = 13
        Top = 28
        Width = 21
        Height = 13
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Left:'
      end
      object Label6: TLabel
        Left = 13
        Top = 54
        Width = 22
        Height = 13
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Top:'
      end
      object Label7: TLabel
        Left = 93
        Top = 28
        Width = 28
        Height = 13
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Right:'
      end
      object Label8: TLabel
        Left = 98
        Top = 56
        Width = 36
        Height = 13
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Bottom:'
      end
      object edMarginLeft: TEdit
        Left = 39
        Top = 26
        Width = 34
        Height = 21
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Alignment = taCenter
        TabOrder = 0
      end
      object edMarginTop: TEdit
        Left = 39
        Top = 54
        Width = 34
        Height = 21
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Alignment = taCenter
        TabOrder = 2
      end
      object edMarginRight: TEdit
        Left = 138
        Top = 26
        Width = 34
        Height = 21
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Alignment = taCenter
        TabOrder = 1
      end
      object edMarginBottom: TEdit
        Left = 138
        Top = 54
        Width = 34
        Height = 21
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Alignment = taCenter
        TabOrder = 3
      end
    end
    object rgOrientation: TRadioGroup
      Left = 13
      Top = 107
      Width = 105
      Height = 86
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Orientation'
      ItemIndex = 0
      Items.Strings = (
        'Portrait'
        'Landscape')
      TabOrder = 2
    end
    object ckRedNegativeValues: TCheckBox
      Left = 13
      Top = 210
      Width = 125
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Red Negative Values'
      TabOrder = 4
    end
    object grpFontSizes: TGroupBox
      Left = 13
      Top = 9
      Width = 170
      Height = 86
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Font Sizes'
      TabOrder = 0
      object Label9: TLabel
        Left = 18
        Top = 28
        Width = 48
        Height = 13
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Headings:'
      end
      object Label10: TLabel
        Left = 18
        Top = 53
        Width = 26
        Height = 13
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Data:'
      end
      object cbFontHeadings: TComboBox
        Left = 97
        Top = 26
        Width = 48
        Height = 21
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        DropDownCount = 10
        TabOrder = 0
        Items.Strings = (
          '10'
          '11'
          '12'
          '13'
          '14'
          '15'
          '16'
          '17'
          '18'
          '19'
          '20')
      end
      object cbFontData: TComboBox
        Left = 97
        Top = 50
        Width = 48
        Height = 21
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        DropDownCount = 10
        TabOrder = 1
        Items.Strings = (
          '5'
          '6'
          '7'
          '8'
          '9'
          '10'
          '11'
          '12'
          '')
      end
    end
    object grpInitialPreview: TGroupBox
      Left = 192
      Top = 9
      Width = 121
      Height = 86
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Initial Preview'
      TabOrder = 1
      object ckFullScreen: TCheckBox
        Left = 17
        Top = 21
        Width = 79
        Height = 14
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Full Screen'
        TabOrder = 0
      end
      object btnFitToPage: TRadioButton
        Left = 17
        Top = 43
        Width = 92
        Height = 14
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Fit to Page'
        Checked = True
        TabOrder = 1
        TabStop = True
      end
      object btnFitToWidth: TRadioButton
        Left = 17
        Top = 63
        Width = 92
        Height = 13
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Fit to Width'
        TabOrder = 2
      end
    end
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 243
    Width = 327
    Height = 28
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 332
    object cxButton1: TcxButton
      Left = 252
      Top = 2
      Width = 61
      Height = 21
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = '&OK'
      Default = True
      LookAndFeel.Kind = lfOffice11
      ModalResult = 1
      TabOrder = 0
    end
    object cxButton2: TcxButton
      Left = 186
      Top = 2
      Width = 61
      Height = 21
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Cancel = True
      Caption = '&Cancel'
      LookAndFeel.Kind = lfOffice11
      ModalResult = 2
      TabOrder = 1
    end
  end
end
