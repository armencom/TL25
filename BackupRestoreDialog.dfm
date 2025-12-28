object BackupRestoreDlg: TBackupRestoreDlg
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Backup - Restore'
  ClientHeight = 355
  ClientWidth = 601
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  FormStyle = fsMDIForm
  OldCreateOrder = False
  Position = poMainFormCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 601
    Height = 355
    Align = alClient
    BevelOuter = bvNone
    ParentBackground = False
    ShowCaption = False
    TabOrder = 0
    object pnlTop: TPanel
      Left = 0
      Top = 0
      Width = 601
      Height = 41
      Align = alTop
      BevelOuter = bvNone
      ShowCaption = False
      TabOrder = 0
      object RzLabel1: TRzLabel
        Left = 18
        Top = 9
        Width = 245
        Height = 20
        Caption = 'TradeLog Backup and Restore'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        BlinkIntervalOff = 100
        BlinkIntervalOn = 100
      end
    end
    object pnlButtons: TRzPanel
      Left = 0
      Top = 309
      Width = 601
      Height = 46
      Align = alBottom
      BorderOuter = fsNone
      ParentColor = True
      TabOrder = 1
      DesignSize = (
        601
        46)
      object btnCancel: TcxButton
        Left = 408
        Top = 8
        Width = 75
        Height = 25
        Anchors = [akTop, akRight]
        Cancel = True
        Caption = '&Cancel'
        ModalResult = 2
        TabOrder = 0
      end
      object btnOK: TcxButton
        Left = 503
        Top = 8
        Width = 75
        Height = 25
        Anchors = [akTop, akRight]
        Caption = '&OK'
        Default = True
        ModalResult = 1
        TabOrder = 1
        OnClick = btnOKClick
      end
      object btnRemove: TcxButton
        Left = 18
        Top = 8
        Width = 119
        Height = 25
        Caption = 'Remove Old Backups'
        TabOrder = 2
        OnClick = btnRemoveClick
      end
    end
    object pnlClient: TRzPanel
      AlignWithMargins = True
      Left = 10
      Top = 44
      Width = 581
      Height = 262
      Margins.Left = 10
      Margins.Right = 10
      Align = alClient
      BorderOuter = fsFlatRounded
      Color = clBtnHighlight
      TabOrder = 2
      object RzLabel2: TRzLabel
        Left = 33
        Top = 11
        Width = 147
        Height = 15
        Caption = 'Current data file name:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        BlinkIntervalOff = 100
        BlinkIntervalOn = 100
      end
      object RzLabel3: TRzLabel
        Left = 65
        Top = 34
        Width = 115
        Height = 15
        Caption = 'Backup file name:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        BlinkIntervalOff = 100
        BlinkIntervalOn = 100
      end
      object lbCurrentDataFile: TRzLabel
        Left = 195
        Top = 11
        Width = 86
        Height = 15
        Caption = 'CurrentDataFile'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 16744448
        Font.Height = -12
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        BlinkIntervalOff = 100
        BlinkIntervalOn = 100
      end
      object lbBackupDataFile: TRzLabel
        Left = 195
        Top = 34
        Width = 87
        Height = 15
        Caption = 'BackupDataFile'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 16744448
        Font.Height = -12
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        BlinkIntervalOff = 100
        BlinkIntervalOn = 100
      end
      object RzLabel4: TRzLabel
        Left = 22
        Top = 85
        Width = 206
        Height = 13
        Caption = 'This may help you identify the latest backup'
        BlinkIntervalOff = 100
        BlinkIntervalOn = 100
      end
      object RzLabel5: TRzLabel
        Left = 41
        Top = 137
        Width = 59
        Height = 13
        Caption = 'Backup File:'
        BlinkIntervalOff = 100
        BlinkIntervalOn = 100
      end
      object RzLabel6: TRzLabel
        Left = 41
        Top = 202
        Width = 59
        Height = 13
        Caption = 'Restore File:'
        Enabled = False
        BlinkIntervalOff = 100
        BlinkIntervalOn = 100
      end
      object ckAddDate: TRzCheckBox
        Left = 22
        Top = 68
        Width = 210
        Height = 15
        Caption = 'Add date/timestamp to backup file name'
        State = cbUnchecked
        TabOrder = 0
        OnClick = ckAddDateClick
      end
      object rbBackup: TRzRadioButton
        Left = 22
        Top = 118
        Width = 272
        Height = 18
        Caption = 'Backup to my computer or hard drive'
        Checked = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        TabStop = True
        OnClick = rbBackupClick
      end
      object rbRestore: TRzRadioButton
        Left = 22
        Top = 183
        Width = 296
        Height = 18
        Caption = 'Restore from my computer or hard drive '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        OnClick = rbRestoreClick
      end
      object edBackupFile: TRzEdit
        Left = 41
        Top = 152
        Width = 440
        Height = 21
        Text = ''
        ReadOnly = True
        ReadOnlyColor = clWindow
        TabOrder = 3
      end
      object btnBackup: TcxButton
        Left = 493
        Top = 150
        Width = 75
        Height = 25
        Caption = 'Change ...'
        TabOrder = 4
        OnClick = btnBackupClick
      end
      object edRestoreFile: TRzEdit
        Left = 41
        Top = 219
        Width = 440
        Height = 21
        Text = ''
        Enabled = False
        FocusColor = clBtnHighlight
        ReadOnly = True
        ReadOnlyColor = clWindow
        TabOrder = 5
      end
      object btnRestore: TcxButton
        Left = 493
        Top = 216
        Width = 75
        Height = 25
        Caption = 'Select ...'
        Enabled = False
        TabOrder = 6
        OnClick = btnRestoreClick
      end
      object ckDefaultLocation: TRzCheckBox
        Left = 285
        Top = 68
        Width = 160
        Height = 15
        Caption = 'Use Default Backup Directory'
        State = cbUnchecked
        TabOrder = 7
        OnClick = ckDefaultLocationClick
      end
    end
  end
  object OpenRestoreFile: TOpenDialog
    Options = [ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Select Restore File'
    Left = 520
    Top = 56
  end
  object DeleteFileDialog: TOpenDialog
    Options = [ofAllowMultiSelect, ofPathMustExist, ofFileMustExist, ofEnableSizing, ofDontAddToRecent]
    Title = 'Select File(s) to Delete, Multi Select OK.'
    Left = 222
    Top = 360
  end
end
