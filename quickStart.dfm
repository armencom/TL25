object panelQS: TpanelQS
  Left = 0
  Top = 0
  HorzScrollBar.Tracking = True
  ClientHeight = 124
  ClientWidth = 955
  Color = 16772313
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnHide = FormHide
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 955
    Height = 124
    Align = alClient
    BevelOuter = bvNone
    Constraints.MinHeight = 27
    ParentColor = True
    TabOrder = 0
    object pnlDetails: TPanel
      Left = 0
      Top = 26
      Width = 955
      Height = 98
      Margins.Top = 0
      Margins.Bottom = 5
      Align = alClient
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      OnResize = pnlDetailsResize
      object wbDetails: TWebBrowser
        AlignWithMargins = True
        Left = 10
        Top = 3
        Width = 935
        Height = 89
        Margins.Left = 10
        Margins.Right = 10
        Margins.Bottom = 6
        Align = alClient
        TabOrder = 0
        ControlData = {
          4C000000A3600000330900000000000000000000000000000000000000000000
          000000004C000000000000000000000001000000E0D057007335CF11AE690800
          2B2E126203000000000000004C0000000114020000000000C000000000000046
          8000000000000000000000000000000000000000000000000000000000000000
          00000000000000000100000000000000000000000000000000000000}
      end
    end
    object pnlTop: TPanel
      Left = 0
      Top = 0
      Width = 955
      Height = 26
      Align = alTop
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 1
      object pnlBtns: TPanel
        Left = 695
        Top = 0
        Width = 260
        Height = 26
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alRight
        Alignment = taLeftJustify
        BevelEdges = []
        BevelOuter = bvNone
        UseDockManager = False
        ParentColor = True
        ParentShowHint = False
        ShowCaption = False
        ShowHint = True
        TabOrder = 0
        VerticalAlignment = taAlignTop
        object btnViewTut: TcxButton
          Left = 97
          Top = 3
          Width = 100
          Height = 20
          Hint = 'View Online Tutorials'
          Caption = 'Online Tutorials'
          LookAndFeel.Kind = lfOffice11
          LookAndFeel.NativeStyle = True
          TabOrder = 1
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
          WordWrap = True
          OnClick = btnViewTutClick
        end
        object btnHelp: TcxButton
          Left = 201
          Top = 3
          Width = 50
          Height = 20
          Hint = 'TradeLog User Guide'
          Caption = 'Help'
          LookAndFeel.Kind = lfOffice11
          LookAndFeel.NativeStyle = True
          TabOrder = 0
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
          WordWrap = True
          OnClick = btnHelpClick
        end
      end
      object pnlStep: TPanel
        Left = 0
        Top = 0
        Width = 695
        Height = 26
        Align = alClient
        BevelOuter = bvNone
        Color = 16772313
        ParentBackground = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        object qsTitle: TLabel
          AlignWithMargins = True
          Left = 10
          Top = 6
          Width = 100
          Height = 16
          Hint = 
            'Use Ctrl-Q to Show/Hide this panel or Options, Global Options, D' +
            'isplay QS Panel'
          Margins.Right = 6
          Caption = 'QUICK START'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object cboStep: TcxComboBox
          AlignWithMargins = True
          Left = 119
          Top = 4
          Hint = 
            'Use Ctrl-Q to Show/Hide this panel or Options, Global Options, D' +
            'isplay QS Panel'
          Margins.Top = 1
          Margins.Bottom = 1
          ParentFont = False
          Properties.MaxLength = 0
          Properties.OnChange = cboStepPropertiesChange
          Style.BorderStyle = ebsUltraFlat
          Style.Font.Charset = ANSI_CHARSET
          Style.Font.Color = clWindowText
          Style.Font.Height = -12
          Style.Font.Name = 'Microsoft Sans Serif'
          Style.Font.Style = [fsBold]
          Style.HotTrack = False
          Style.LookAndFeel.Kind = lfOffice11
          Style.TransparentBorder = False
          Style.ButtonStyle = btsSimple
          Style.PopupBorderStyle = epbsDefault
          Style.IsFontAssigned = True
          StyleDisabled.LookAndFeel.Kind = lfOffice11
          StyleFocused.LookAndFeel.Kind = lfOffice11
          StyleHot.LookAndFeel.Kind = lfOffice11
          TabOrder = 0
          Width = 322
        end
        object btnNext: TcxButton
          Left = 447
          Top = 3
          Width = 50
          Height = 20
          Hint = 'Current Step Complete - Goto Next Step'
          ParentCustomHint = False
          Caption = 'Next'
          LookAndFeel.Kind = lfOffice11
          LookAndFeel.NativeStyle = True
          TabOrder = 1
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
          WordWrap = True
          OnClick = btnNextClick
        end
      end
    end
  end
end
