object dlgProgress: TdlgProgress
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Please wait...'
  ClientHeight = 188
  ClientWidth = 451
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  OnPaint = FormPaint
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 451
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    Visible = False
    object Label1: TLabel
      Left = 10
      Top = 10
      Width = 193
      Height = 19
      Margins.Left = 20
      Margins.Top = 10
      Margins.Right = 20
      Margins.Bottom = 10
      Caption = 'What we are doing now'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      Visible = False
    end
  end
  object pnlMid: TPanel
    Left = 0
    Top = 41
    Width = 451
    Height = 60
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object Label2: TLabel
      Left = 10
      Top = 10
      Width = 144
      Height = 13
      Caption = 'Total # of records to convert:'
    end
    object Label3: TLabel
      Left = 10
      Top = 29
      Width = 143
      Height = 13
      Caption = 'Total # of records converted:'
    end
    object Label4: TLabel
      Left = 236
      Top = 10
      Width = 6
      Height = 13
      Alignment = taRightJustify
      Caption = '0'
    end
    object Label5: TLabel
      Left = 236
      Top = 29
      Width = 6
      Height = 13
      Alignment = taRightJustify
      Caption = '0'
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 125
    Width = 451
    Height = 63
    Align = alClient
    TabOrder = 2
    object lblElapsedTime: TLabel
      Left = 10
      Top = 24
      Width = 69
      Height = 13
      Cursor = crDrag
      Caption = 'Elapsed Time: '
    end
    object lblRemaining: TLabel
      Left = 172
      Top = 24
      Width = 103
      Height = 13
      Caption = 'est. Time Remaining: '
      Visible = False
    end
    object btnCancel: TButton
      Left = 350
      Top = 20
      Width = 81
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 0
      Visible = False
      OnClick = btnCancelClick
    end
  end
  object pnlProgBar: TPanel
    Left = 0
    Top = 101
    Width = 451
    Height = 24
    Align = alTop
    Color = clWhite
    ParentBackground = False
    TabOrder = 3
    object ProgressBar1: TLabel
      Left = 1
      Top = 1
      Width = 3
      Height = 13
      Color = clBlue
      ParentColor = False
      Transparent = False
    end
    object lblProgBar: TLabel
      Left = 1
      Top = 1
      Width = 449
      Height = 22
      Align = alClient
      Alignment = taCenter
      Caption = '0%'
      ExplicitWidth = 17
      ExplicitHeight = 13
    end
  end
end
