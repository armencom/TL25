object frm1099info: Tfrm1099info
  Left = 0
  Top = 0
  AutoSize = True
  BorderIcons = [biSystemMenu]
  Caption = '1099-B Information'
  ClientHeight = 504
  ClientWidth = 799
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlImportant: TPanel
    AlignWithMargins = True
    Left = 0
    Top = 398
    Width = 799
    Height = 69
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alBottom
    AutoSize = True
    BevelEdges = []
    BevelKind = bkFlat
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object lblImportant: TLabel
      AlignWithMargins = True
      Left = 10
      Top = 5
      Width = 104
      Height = 16
      Margins.Left = 10
      Margins.Top = 5
      Margins.Right = 20
      Margins.Bottom = 4
      Align = alTop
      Caption = 'Important Notes:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Micrsoft sans serif'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object lblImportant1: TLabel
      AlignWithMargins = True
      Left = 10
      Top = 25
      Width = 439
      Height = 13
      Margins.Left = 10
      Margins.Top = 0
      Margins.Right = 10
      Margins.Bottom = 4
      Align = alTop
      Caption = 
        '1. Only the 1099-B Gross Proceeds (Total Sales) amount is used t' +
        'o reconcile to your 1099.  '
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object lblImportant2: TLabel
      AlignWithMargins = True
      Left = 10
      Top = 42
      Width = 567
      Height = 13
      Margins.Left = 10
      Margins.Top = 0
      Margins.Right = 10
      Margins.Bottom = 14
      Align = alTop
      Caption = 
        '2. All other information gathered on this form will be used to m' +
        'ake any necessary adjustments to your IRS Form 8949.'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
  end
  object pnl1099: TPanel
    Left = 0
    Top = 80
    Width = 799
    Height = 319
    Margins.Bottom = 0
    Align = alTop
    BevelEdges = [beBottom]
    BevelKind = bkFlat
    BevelOuter = bvNone
    TabOrder = 1
    object pnl1099Left: TPanel
      Left = 0
      Top = 0
      Width = 319
      Height = 317
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alLeft
      AutoSize = True
      BevelEdges = [beRight]
      BevelKind = bkFlat
      BevelOuter = bvNone
      TabOrder = 0
      object pnl1099Cost: TPanel
        AlignWithMargins = True
        Left = 0
        Top = 158
        Width = 317
        Height = 155
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 20
        Align = alTop
        AutoSize = True
        BevelEdges = []
        BevelKind = bkFlat
        BevelOuter = bvNone
        TabOrder = 1
        object Label3: TLabel
          AlignWithMargins = True
          Left = 10
          Top = 66
          Width = 287
          Height = 16
          Margins.Left = 10
          Margins.Top = 10
          Margins.Right = 20
          Margins.Bottom = 0
          Align = alTop
          AutoSize = False
          Caption = 'Amounts REPORTED TO THE IRS (Covered)'
          Color = clBtnFace
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          WordWrap = True
        end
        object pnlCostLT: TPanel
          AlignWithMargins = True
          Left = 0
          Top = 125
          Width = 317
          Height = 30
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alTop
          Alignment = taRightJustify
          AutoSize = True
          BevelEdges = []
          BevelOuter = bvNone
          BorderWidth = 1
          TabOrder = 1
          object Panel1: TPanel
            Left = 131
            Top = 1
            Width = 185
            Height = 28
            Align = alRight
            BevelOuter = bvNone
            TabOrder = 0
            object ed1099CostLT: TcxCurrencyEdit
              AlignWithMargins = True
              Left = 0
              Top = 0
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 20
              Margins.Bottom = 0
              Align = alTop
              Properties.Alignment.Horz = taCenter
              Properties.Alignment.Vert = taVCenter
              Properties.DisplayFormat = '###,###,###,###,###,##0.00'
              Properties.UseDisplayFormatWhenEditing = True
              Properties.UseLeftAlignmentOnEditing = False
              Properties.UseThousandSeparator = True
              Style.BorderStyle = ebsFlat
              TabOrder = 0
              Width = 165
            end
          end
          object Panel3: TPanel
            AlignWithMargins = True
            Left = 11
            Top = 1
            Width = 120
            Height = 28
            Margins.Left = 10
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 1
            object lblCostLT: TLabel
              AlignWithMargins = True
              Left = 0
              Top = 0
              Width = 110
              Height = 16
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 10
              Align = alTop
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'Long-Term Amount: '
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              WordWrap = True
              ExplicitWidth = 111
            end
          end
        end
        object pnlLine: TPanel
          AlignWithMargins = True
          Left = 10
          Top = 10
          Width = 297
          Height = 1
          Margins.Left = 10
          Margins.Top = 10
          Margins.Right = 10
          Margins.Bottom = 4
          Align = alTop
          BevelEdges = [beTop]
          BevelKind = bkFlat
          BevelOuter = bvNone
          TabOrder = 2
        end
        object pnlCostTop: TPanel
          Left = 0
          Top = 15
          Width = 317
          Height = 41
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 3
          object blbCost: TLabel
            AlignWithMargins = True
            Left = 10
            Top = 10
            Width = 177
            Height = 19
            Margins.Left = 10
            Margins.Top = 10
            Margins.Right = 30
            Margins.Bottom = 12
            Align = alClient
            Caption = 'COST BASIS'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            ExplicitWidth = 75
            ExplicitHeight = 16
          end
          object pnlCostHelp: TPanel
            Left = 217
            Top = 0
            Width = 100
            Height = 41
            Align = alRight
            BevelOuter = bvNone
            TabOrder = 0
            DesignSize = (
              100
              41)
            object btnHelpCost: TcxButton
              AlignWithMargins = True
              Left = 0
              Top = 10
              Width = 80
              Height = 25
              Margins.Left = 0
              Margins.Top = 10
              Margins.Right = 0
              Margins.Bottom = 0
              Anchors = [akTop, akRight]
              Caption = 'Get More Info'
              LookAndFeel.Kind = lfUltraFlat
              TabOrder = 0
              TabStop = False
              Font.Charset = ANSI_CHARSET
              Font.Color = clBtnText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              OnClick = btnHelpCostClick
            end
          end
        end
        object pnlCostST: TPanel
          AlignWithMargins = True
          Left = 0
          Top = 92
          Width = 317
          Height = 33
          Margins.Left = 0
          Margins.Top = 10
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alTop
          Alignment = taRightJustify
          AutoSize = True
          BevelEdges = []
          BevelOuter = bvNone
          BorderWidth = 1
          TabOrder = 0
          object Panel5: TPanel
            Left = 131
            Top = 1
            Width = 185
            Height = 31
            Align = alRight
            BevelOuter = bvNone
            TabOrder = 0
            object ed1099CostSt: TcxCurrencyEdit
              AlignWithMargins = True
              Left = 0
              Top = 0
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 20
              Margins.Bottom = 0
              Align = alTop
              Properties.Alignment.Horz = taCenter
              Properties.Alignment.Vert = taVCenter
              Properties.DisplayFormat = '###,###,###,###,###,##0.00'
              Properties.UseDisplayFormatWhenEditing = True
              Properties.UseLeftAlignmentOnEditing = False
              Properties.UseThousandSeparator = True
              Style.BorderStyle = ebsFlat
              TabOrder = 0
              Width = 165
            end
          end
          object Panel6: TPanel
            AlignWithMargins = True
            Left = 11
            Top = 1
            Width = 120
            Height = 31
            Margins.Left = 10
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 1
            object lblCostST: TLabel
              AlignWithMargins = True
              Left = 0
              Top = 0
              Width = 110
              Height = 16
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 10
              Align = alTop
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'Short-Term Amount: '
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              WordWrap = True
              ExplicitWidth = 111
            end
          end
        end
      end
      object pnlProceeds: TPanel
        AlignWithMargins = True
        Left = 10
        Top = 0
        Width = 307
        Height = 158
        Margins.Left = 10
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        TabOrder = 0
        object lblProceedsInfo: TLabel
          Left = 0
          Top = 52
          Width = 307
          Height = 13
          Margins.Left = 10
          Margins.Top = 0
          Margins.Right = 20
          Align = alTop
          Caption = 'Total sales amount REPORTED TO THE IRS'
          Color = clBtnFace
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          WordWrap = True
          ExplicitWidth = 205
        end
        object lblProceedsOptions: TLabel
          AlignWithMargins = True
          Left = 10
          Top = 129
          Width = 277
          Height = 26
          Margins.Left = 10
          Margins.Top = 4
          Margins.Right = 20
          Align = alTop
          AutoSize = False
          Caption = 
            'For Tax years prior to 2014, please do NOT include proceeds from' +
            ' Option trades.'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          WordWrap = True
        end
        object Label1: TLabel
          AlignWithMargins = True
          Left = 0
          Top = 69
          Width = 307
          Height = 13
          Margins.Left = 0
          Margins.Top = 4
          Margins.Right = 0
          Align = alTop
          Caption = '(short-term + long-term)'
          Color = clBtnFace
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          WordWrap = True
          ExplicitWidth = 119
        end
        object pnProceedsTop: TPanel
          AlignWithMargins = True
          Left = 0
          Top = 10
          Width = 307
          Height = 32
          Margins.Left = 0
          Margins.Top = 10
          Margins.Right = 0
          Margins.Bottom = 10
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object lblProceeds: TLabel
            AlignWithMargins = True
            Left = 0
            Top = 0
            Width = 155
            Height = 32
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 30
            Margins.Bottom = 0
            Align = alLeft
            Caption = 'GROSS SALES PROCEEDS'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            ExplicitHeight = 16
          end
          object Panel2: TPanel
            Left = 440
            Top = 26
            Width = 185
            Height = 41
            Caption = 'Panel2'
            TabOrder = 0
          end
          object pnlProceedsHelp: TPanel
            Left = 207
            Top = 0
            Width = 100
            Height = 32
            Margins.Left = 0
            Margins.Top = 10
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alRight
            BevelOuter = bvNone
            TabOrder = 1
            DesignSize = (
              100
              32)
            object btnHelpProceeds: TcxButton
              AlignWithMargins = True
              Left = 2
              Top = 0
              Width = 80
              Height = 25
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 0
              Anchors = [akTop, akRight]
              Caption = 'Get More Info'
              LookAndFeel.Kind = lfUltraFlat
              TabOrder = 0
              TabStop = False
              Font.Charset = ANSI_CHARSET
              Font.Color = clBtnText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              OnClick = btnHelpProceedsClick
            end
          end
        end
        object pnlProceedsAmt: TPanel
          AlignWithMargins = True
          Left = 0
          Top = 95
          Width = 307
          Height = 30
          Margins.Left = 0
          Margins.Top = 10
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alTop
          AutoSize = True
          BevelOuter = bvNone
          TabOrder = 1
          object lblAmount: TLabel
            AlignWithMargins = True
            Left = 10
            Top = 3
            Width = 107
            Height = 24
            Margins.Left = 10
            Margins.Right = 10
            Align = alClient
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Proceeds Amount:'
            ExplicitHeight = 25
          end
          object pnlSales: TPanel
            Left = 127
            Top = 0
            Width = 180
            Height = 30
            Align = alRight
            BevelOuter = bvNone
            TabOrder = 0
            object ed1099Sales: TcxCurrencyEdit
              AlignWithMargins = True
              Left = 0
              Top = 0
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 20
              Margins.Bottom = 0
              Align = alTop
              ParentFont = False
              Properties.Alignment.Horz = taCenter
              Properties.Alignment.Vert = taVCenter
              Properties.DisplayFormat = '###,###,###,###,###,##0.00'
              Properties.UseDisplayFormatWhenEditing = True
              Properties.UseLeftAlignmentOnEditing = False
              Properties.UseThousandSeparator = True
              Style.BorderStyle = ebsFlat
              Style.Font.Charset = ANSI_CHARSET
              Style.Font.Color = clWindowText
              Style.Font.Height = -11
              Style.Font.Name = 'Tahoma'
              Style.Font.Style = []
              Style.IsFontAssigned = True
              TabOrder = 0
              Width = 160
            end
          end
        end
      end
    end
    object pnl1099Details: TPanel
      Left = 319
      Top = 0
      Width = 480
      Height = 317
      Margins.Left = 10
      Margins.Top = 0
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alClient
      AutoSize = True
      BevelEdges = []
      BevelKind = bkFlat
      BevelOuter = bvNone
      TabOrder = 1
      object lblDetails2: TLabel
        AlignWithMargins = True
        Left = 10
        Top = 75
        Width = 460
        Height = 36
        Margins.Left = 10
        Margins.Top = 0
        Margins.Right = 10
        Margins.Bottom = 5
        Align = alTop
        AutoSize = False
        Caption = 
          'If you are not sure what information is or is not reported to th' +
          'e IRS please click the Get More Info button to learn more.'
        WordWrap = True
        ExplicitWidth = 459
      end
      object lblDetails1: TLabel
        AlignWithMargins = True
        Left = 10
        Top = 51
        Width = 460
        Height = 24
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 10
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = 'CHECK all items that were REPORTED TO THE IRS on Form 1099-B'
        WordWrap = True
        ExplicitWidth = 459
      end
      object pnl1099included: TPanel
        AlignWithMargins = True
        Left = 0
        Top = 198
        Width = 480
        Height = 94
        Margins.Left = 0
        Margins.Top = 10
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        AutoSize = True
        BevelEdges = []
        BevelOuter = bvNone
        TabOrder = 0
        object cb1099Drips: TCheckBox
          AlignWithMargins = True
          Left = 20
          Top = 52
          Width = 450
          Height = 16
          Margins.Left = 20
          Margins.Top = 10
          Margins.Right = 10
          Margins.Bottom = 0
          TabStop = False
          Align = alTop
          Caption = '4. Drips'
          TabOrder = 3
        end
        object cb1099MutFunds: TCheckBox
          AlignWithMargins = True
          Left = 20
          Top = 78
          Width = 450
          Height = 16
          Margins.Left = 20
          Margins.Top = 10
          Margins.Right = 10
          Margins.Bottom = 0
          TabStop = False
          Align = alTop
          Caption = '5. Mutual Funds'
          TabOrder = 1
        end
        object cb1099Options: TCheckBox
          AlignWithMargins = True
          Left = 20
          Top = 0
          Width = 450
          Height = 16
          Margins.Left = 20
          Margins.Top = 0
          Margins.Right = 10
          Margins.Bottom = 0
          TabStop = False
          Align = alTop
          Caption = '2. Options - Not Included in Tax Years Prior to 2014'
          TabOrder = 0
          OnClick = cb1099OptionsClick
        end
        object cb1099ETFs: TCheckBox
          AlignWithMargins = True
          Left = 20
          Top = 26
          Width = 450
          Height = 16
          Margins.Left = 20
          Margins.Top = 10
          Margins.Right = 10
          Margins.Bottom = 0
          TabStop = False
          Align = alTop
          Caption = '3. ETF/ETNs'
          TabOrder = 2
        end
      end
      object Panel7: TPanel
        Left = 0
        Top = 0
        Width = 480
        Height = 41
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        TabOrder = 1
        object lblDetails: TLabel
          AlignWithMargins = True
          Left = 10
          Top = 10
          Width = 108
          Height = 31
          Margins.Left = 10
          Margins.Top = 10
          Margins.Bottom = 0
          Align = alLeft
          Caption = '1099-B DETAILS:'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          ExplicitHeight = 16
        end
        object Panel8: TPanel
          Left = 380
          Top = 0
          Width = 100
          Height = 41
          Align = alRight
          BevelOuter = bvNone
          TabOrder = 0
          DesignSize = (
            100
            41)
          object btnHelpDetails: TcxButton
            AlignWithMargins = True
            Left = 0
            Top = 10
            Width = 80
            Height = 25
            Margins.Left = 0
            Margins.Top = 10
            Margins.Right = 0
            Margins.Bottom = 0
            Anchors = [akTop, akRight]
            Caption = 'Get More Info'
            LookAndFeel.Kind = lfUltraFlat
            TabOrder = 0
            TabStop = False
            Font.Charset = ANSI_CHARSET
            Font.Color = clBtnText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            OnClick = btnHelpDetailsClick
          end
        end
      end
      object cbOptPrem: TCheckBox
        AlignWithMargins = True
        Left = 20
        Top = 116
        Width = 450
        Height = 16
        Margins.Left = 20
        Margins.Top = 0
        Margins.Right = 10
        Margins.Bottom = 0
        TabStop = False
        Align = alTop
        Caption = '1. Sales Adjusted for Option Premiums'
        TabOrder = 2
        WordWrap = True
      end
      object cbOpt2013: TCheckBox
        AlignWithMargins = True
        Left = 20
        Top = 172
        Width = 450
        Height = 16
        Margins.Left = 20
        Margins.Top = 10
        Margins.Right = 10
        Margins.Bottom = 0
        TabStop = False
        Align = alTop
        Caption = '3. Broker Reported Options Opened Prior to 2014'
        TabOrder = 3
        Visible = False
        WordWrap = True
      end
      object cbOptGL: TCheckBox
        AlignWithMargins = True
        Left = 20
        Top = 142
        Width = 451
        Height = 20
        Margins.Left = 20
        Margins.Top = 10
        Margins.Right = 9
        Margins.Bottom = 0
        TabStop = False
        Align = alTop
        Caption = 
          '2. Broker Reported Gain/Loss INSTEAD OF the Actual Proceeds for ' +
          'Short Options'
        TabOrder = 4
        Visible = False
        WordWrap = True
      end
    end
  end
  object pnlBtns: TPanel
    Left = 0
    Top = 467
    Width = 799
    Height = 37
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alBottom
    Anchors = [akLeft]
    BevelEdges = [beTop]
    BevelKind = bkFlat
    BevelOuter = bvNone
    BorderWidth = 5
    ParentBackground = False
    TabOrder = 2
    object btn1099Cancel: TcxButton
      AlignWithMargins = True
      Left = 21
      Top = 6
      Width = 75
      Height = 25
      Margins.Top = 6
      Cancel = True
      Caption = 'Cancel'
      LookAndFeel.Kind = lfFlat
      ModalResult = 2
      TabOrder = 0
      TabStop = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clBtnText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object btn1099OK: TcxButton
      AlignWithMargins = True
      Left = 633
      Top = 6
      Width = 121
      Height = 25
      Margins.Top = 6
      Caption = 'Run 1099 Recon Rpt'
      Default = True
      LookAndFeel.Kind = lfFlat
      ModalResult = 1
      TabOrder = 1
      TabStop = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clBtnText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object btnPrint: TcxButton
      AlignWithMargins = True
      Left = 411
      Top = 6
      Width = 75
      Height = 25
      Margins.Top = 6
      Caption = 'Print'
      LookAndFeel.Kind = lfFlat
      TabOrder = 2
      TabStop = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clBtnText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      OnClick = btnPrintClick
    end
    object btnReset: TcxButton
      AlignWithMargins = True
      Left = 315
      Top = 6
      Width = 75
      Height = 25
      Margins.Top = 6
      Caption = 'Reset Form'
      LookAndFeel.Kind = lfFlat
      TabOrder = 3
      TabStop = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clBtnText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      OnClick = btnResetClick
    end
  end
  object pnlNo1099: TPanel
    Left = 0
    Top = 0
    Width = 799
    Height = 40
    Align = alTop
    BevelEdges = [beBottom]
    BevelKind = bkFlat
    BevelOuter = bvNone
    TabOrder = 3
    object pnlNo1099text: TLabel
      AlignWithMargins = True
      Left = 120
      Top = 12
      Width = 568
      Height = 26
      Margins.Left = 0
      Margins.Top = 12
      Margins.Right = 10
      Margins.Bottom = 0
      Align = alClient
      AutoSize = False
      Caption = 
        'My broker is not required to provide a 1099-B, or I did not rece' +
        'ive a 1099-B for this account.'
      WordWrap = True
    end
    object pnlNo1099cb: TPanel
      Left = 0
      Top = 0
      Width = 120
      Height = 38
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alLeft
      Alignment = taLeftJustify
      BevelOuter = bvNone
      TabOrder = 0
      object cbNo1099: TCheckBox
        AlignWithMargins = True
        Left = 12
        Top = 10
        Width = 94
        Height = 18
        Margins.Left = 12
        Margins.Top = 10
        Margins.Right = 14
        Margins.Bottom = 10
        TabStop = False
        Align = alClient
        Caption = ' No 1099-B'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        OnClick = cbNo1099Click
      end
    end
    object pnlNo1099btn: TPanel
      Left = 698
      Top = 0
      Width = 101
      Height = 38
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      DesignSize = (
        101
        38)
      object btnOK: TcxButton
        Left = 5
        Top = 7
        Width = 75
        Height = 25
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Anchors = []
        Cancel = True
        Caption = 'OK'
        Default = True
        Enabled = False
        LookAndFeel.Kind = lfFlat
        ModalResult = 2
        TabOrder = 0
        Font.Charset = ANSI_CHARSET
        Font.Color = clBtnText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        OnClick = btnOKClick
      end
    end
  end
  object pnlEnterTheFollowing: TPanel
    Left = 0
    Top = 40
    Width = 799
    Height = 40
    Align = alTop
    Anchors = []
    BevelEdges = [beBottom]
    BevelKind = bkFlat
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 4
    object Label2: TLabel
      AlignWithMargins = True
      Left = 10
      Top = 10
      Width = 327
      Height = 16
      Margins.Left = 10
      Margins.Top = 10
      Align = alClient
      Caption = 'Enter the following information from your 1099-B :'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
end
