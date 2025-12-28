object LoggingDlg: TLoggingDlg
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Debug Logging'
  ClientHeight = 345
  ClientWidth = 305
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 305
    Height = 345
    Align = alClient
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 0
    ExplicitWidth = 295
    ExplicitHeight = 335
    object ckLoggers: TRzCheckGroup
      AlignWithMargins = True
      Left = 10
      Top = 123
      Width = 285
      Height = 171
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alClient
      Caption = 'Select Logs to Activate'
      CaptionFont.Charset = DEFAULT_CHARSET
      CaptionFont.Color = clWindowText
      CaptionFont.Height = -12
      CaptionFont.Name = 'Tahoma'
      CaptionFont.Style = [fsBold]
      Columns = 2
      GroupStyle = gsStandard
      SpaceEvenly = True
      StartXPos = 30
      StartYPos = 10
      TabOrder = 0
      ExplicitWidth = 275
      ExplicitHeight = 161
    end
    object pnlButtons: TPanel
      Left = 0
      Top = 304
      Width = 305
      Height = 41
      Align = alBottom
      BevelOuter = bvNone
      Caption = 'pnlButtons'
      ShowCaption = False
      TabOrder = 1
      ExplicitTop = 294
      ExplicitWidth = 295
      object btnOK: TcxButton
        Left = 62
        Top = 8
        Width = 75
        Height = 25
        Caption = '&OK'
        Default = True
        ModalResult = 1
        TabOrder = 0
      end
      object btnCancel: TcxButton
        Left = 158
        Top = 8
        Width = 75
        Height = 25
        Cancel = True
        Caption = '&Cancel'
        ModalResult = 2
        TabOrder = 1
      end
    end
    object pnlMessage: TPanel
      Left = 0
      Top = 0
      Width = 305
      Height = 113
      Align = alTop
      BevelOuter = bvNone
      Caption = 'pnlMessage'
      ShowCaption = False
      TabOrder = 2
      ExplicitWidth = 295
      object RzLabel1: TRzLabel
        AlignWithMargins = True
        Left = 8
        Top = 8
        Width = 289
        Height = 97
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 8
        Align = alClient
        Caption = 
          'Debug logging is used by TradeLog Support to determine what may ' +
          'be happening when you are experiencing issues with TradeLog. Ple' +
          'ase do not turn on Logging unless instructed by Support as some ' +
          'Loggers can generate lots of data and create a very large log fi' +
          'le.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        BlinkIntervalOff = 1000
        BlinkIntervalOn = 100
        ExplicitWidth = 279
        ExplicitHeight = 96
      end
    end
  end
end
