object frm1099more: Tfrm1099more
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Information'
  ClientHeight = 894
  ClientWidth = 650
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  Visible = True
  OnClose = FormClose
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlHelpProceeds: TPanel
    Left = 0
    Top = 0
    Width = 650
    Height = 147
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    AutoSize = True
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    Visible = False
    object lblProceedsNote1: TLabel
      AlignWithMargins = True
      Left = 20
      Top = 31
      Width = 620
      Height = 36
      Margins.Left = 20
      Margins.Top = 0
      Margins.Right = 10
      Margins.Bottom = 8
      Align = alTop
      AutoSize = False
      Caption = 
        '1. Some brokers do not provide a Total Gross Proceeds number, or' +
        ' do not provide a total of only the amount reported to the IRS. ' +
        'In such cases you may have to add the total for each section on ' +
        'the 1099-B that is reported to the IRS.'
      WordWrap = True
    end
    object lblHelpProceeds: TLabel
      AlignWithMargins = True
      Left = 10
      Top = 5
      Width = 268
      Height = 16
      Margins.Left = 10
      Margins.Top = 5
      Margins.Right = 20
      Margins.Bottom = 10
      Align = alTop
      Caption = 'Help for Entering Gross Proceeds (Sales):'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object lblProceedsNote2: TLabel
      AlignWithMargins = True
      Left = 20
      Top = 75
      Width = 620
      Height = 52
      Margins.Left = 20
      Margins.Top = 0
      Margins.Right = 10
      Margins.Bottom = 20
      Align = alTop
      AutoSize = False
      Caption = 
        '2. Most brokers group securities on the 1099-B to correspond to ' +
        'Form 8949 categories: the sales proceeds for sections correspond' +
        'ing to Form 8949 Box A, B, D, and/or E are reported to the IRS -' +
        ' add the total sales for those sections to enter into TradeLog. ' +
        '(Box C and Box F categories are NOT reported to the IRS).'
      WordWrap = True
    end
  end
  object pnlHelpCost: TPanel
    Left = 0
    Top = 162
    Width = 650
    Height = 274
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 10
    Alignment = taLeftJustify
    AutoSize = True
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    Visible = False
    object notesTotals: TLabel
      AlignWithMargins = True
      Left = 10
      Top = 5
      Width = 184
      Height = 16
      Margins.Left = 10
      Margins.Top = 5
      Margins.Right = 20
      Margins.Bottom = 10
      Align = alTop
      Caption = 'Help for Entering Cost Basis:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object lblCostNote1a: TLabel
      AlignWithMargins = True
      Left = 30
      Top = 71
      Width = 610
      Height = 36
      Margins.Left = 30
      Margins.Top = 0
      Margins.Right = 10
      Margins.Bottom = 8
      Align = alTop
      AutoSize = False
      Caption = 
        '- Short-term cost basis reported to the IRS is the section corre' +
        'sponding to Form 8949 box A (prior to 2013 tax year this was con' +
        'sidered Box A, Part I, Short-term).'
      WordWrap = True
      ExplicitTop = 81
      ExplicitWidth = 460
    end
    object lblCostNote1b: TLabel
      AlignWithMargins = True
      Left = 30
      Top = 115
      Width = 610
      Height = 36
      Margins.Left = 30
      Margins.Top = 0
      Margins.Right = 10
      Margins.Bottom = 4
      Align = alTop
      AutoSize = False
      Caption = 
        '- Long-term cost basis reported to the IRS is the section corres' +
        'ponding to Form 8949 box D (prior to 2013 tax year this was cons' +
        'idered Box A, Part II, Long-term).'
      WordWrap = True
      ExplicitTop = 125
      ExplicitWidth = 460
    end
    object lnk8949Category: TLabel
      AlignWithMargins = True
      Left = 30
      Top = 241
      Width = 126
      Height = 13
      Cursor = crHandPoint
      Hint = 'View your Subscription Renewal and Upgrade options'
      Margins.Left = 30
      Margins.Top = 0
      Margins.Right = 10
      Margins.Bottom = 20
      Align = alTop
      Caption = 'IRS Form 8949 Categories'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      OnClick = lnk8949CategoryClick
    end
    object lblCostNote1: TLabel
      AlignWithMargins = True
      Left = 20
      Top = 31
      Width = 601
      Height = 26
      Margins.Left = 20
      Margins.Top = 0
      Margins.Right = 10
      Margins.Bottom = 14
      Align = alTop
      Caption = 
        '1. Only report the total cost basis reported to the IRS for cove' +
        'red securities. Most brokers group securities on the 1099-B to c' +
        'orrespond to Form 8949 categories:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object lblCostNote2: TLabel
      AlignWithMargins = True
      Left = 10
      Top = 165
      Width = 630
      Height = 52
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 0
      Align = alTop
      AutoSize = False
      Caption = 
        '2. If your broker does not group securities on the 1099-B you sh' +
        'ould request them to do so as this is important information need' +
        'ed for Form 8949. Alternatively, you may have to add up the tota' +
        'l of the cost-basis for securities indicated as covered - cost b' +
        'asis reported to the IRS.'
      WordWrap = True
      ExplicitTop = 175
      ExplicitWidth = 480
    end
    object lblCostNote3: TLabel
      AlignWithMargins = True
      Left = 10
      Top = 217
      Width = 630
      Height = 24
      Margins.Left = 10
      Margins.Top = 0
      Margins.Right = 10
      Margins.Bottom = 0
      Align = alTop
      AutoSize = False
      Caption = 
        'For more information about reporting categories, see our tax top' +
        'ic:'
      WordWrap = True
      ExplicitTop = 231
    end
  end
  object pnlHelpDetails: TPanel
    AlignWithMargins = True
    Left = -2
    Top = 455
    Width = 650
    Height = 330
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 10
    AutoSize = True
    BevelEdges = []
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 2
    Visible = False
    object notesDet2: TLabel
      AlignWithMargins = True
      Left = 30
      Top = 46
      Width = 609
      Height = 26
      Margins.Left = 30
      Margins.Top = 0
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alTop
      Caption = 
        'It is optional whether your broker will adjust gross sales for p' +
        'remiums from option exercises. Check this box only if your broke' +
        'r indicates they have adjusted for option premiums on the 1099-B' +
        '.'
      WordWrap = True
    end
    object Label2: TLabel
      AlignWithMargins = True
      Left = 10
      Top = 5
      Width = 345
      Height = 16
      Margins.Left = 10
      Margins.Top = 5
      Margins.Right = 20
      Margins.Bottom = 10
      Align = alTop
      Caption = 'Help for Items That Where Included on  Your 1099-B:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object lblOptPrem: TLabel
      AlignWithMargins = True
      Left = 20
      Top = 31
      Width = 266
      Height = 13
      Margins.Left = 20
      Margins.Top = 0
      Margins.Right = 10
      Margins.Bottom = 2
      Align = alTop
      Caption = 'Sales Adjusted for Option Premiums check box:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object pnlPre2014cb: TPanel
      AlignWithMargins = True
      Left = 0
      Top = 82
      Width = 650
      Height = 242
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 6
      Align = alClient
      AutoSize = True
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitHeight = 276
      object lblOptions: TLabel
        AlignWithMargins = True
        Left = 20
        Top = 2
        Width = 106
        Height = 13
        Margins.Left = 20
        Margins.Top = 2
        Margins.Right = 10
        Margins.Bottom = 2
        Align = alTop
        Caption = 'Options check box:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object notesDet1: TLabel
        AlignWithMargins = True
        Left = 30
        Top = 17
        Width = 583
        Height = 26
        Margins.Left = 30
        Margins.Top = 0
        Margins.Right = 10
        Margins.Bottom = 10
        Align = alTop
        Caption = 
          'Options usually are not reported on 1099-B. Check this box only ' +
          'if your broker did report options. This box should remain un-che' +
          'cked for most users.'
        WordWrap = True
      end
      object lblMutFunds: TLabel
        AlignWithMargins = True
        Left = 20
        Top = 55
        Width = 138
        Height = 13
        Margins.Left = 20
        Margins.Top = 2
        Margins.Right = 10
        Margins.Bottom = 2
        Align = alTop
        Caption = 'Mutual Funds check box:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object notesMut: TLabel
        AlignWithMargins = True
        Left = 30
        Top = 70
        Width = 604
        Height = 26
        Margins.Left = 30
        Margins.Top = 0
        Margins.Right = 10
        Margins.Bottom = 10
        Align = alTop
        Caption = 
          'Most brokers report mutual funds as non-covered securities on th' +
          'e 1099-B. However a few brokers opt to not report at all. If you' +
          'r broker did not report Mutual Funds on the 1099-B then uncheck ' +
          'this box.'
        WordWrap = True
      end
      object lblETF: TLabel
        AlignWithMargins = True
        Left = 20
        Top = 108
        Width = 114
        Height = 13
        Margins.Left = 20
        Margins.Top = 2
        Margins.Right = 10
        Margins.Bottom = 2
        Align = alTop
        Caption = 'ETF/ETNs check box:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object notesETF: TLabel
        AlignWithMargins = True
        Left = 30
        Top = 123
        Width = 601
        Height = 26
        Margins.Left = 30
        Margins.Top = 0
        Margins.Right = 10
        Margins.Bottom = 10
        Align = alTop
        Caption = 
          'Brokers vary in their reporting of ETF/ETNs. Most brokers are in' +
          'cluding these as covered securities on 1099-B. If your broker re' +
          'ported these as non-covered securities then uncheck this box.'
        WordWrap = True
      end
      object lnk8949Code: TLabel
        AlignWithMargins = True
        Left = 40
        Top = 159
        Width = 317
        Height = 13
        Cursor = crHandPoint
        Hint = 'View your Subscription Renewal and Upgrade options'
        Margins.Left = 40
        Margins.Top = 0
        Margins.Right = 10
        Margins.Bottom = 4
        Align = alTop
        Caption = 'Click Here for Instructions on How to Change the Form 8949 Code'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        OnClick = lnk8949CodeClick
      end
      object lblDrips: TLabel
        AlignWithMargins = True
        Left = 20
        Top = 186
        Width = 92
        Height = 13
        Margins.Left = 20
        Margins.Top = 10
        Margins.Right = 10
        Margins.Bottom = 2
        Align = alTop
        Caption = 'Drips check box:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object notesDrip: TLabel
        AlignWithMargins = True
        Left = 30
        Top = 201
        Width = 608
        Height = 26
        Margins.Left = 30
        Margins.Top = 0
        Margins.Right = 10
        Margins.Bottom = 10
        Align = alTop
        Caption = 
          'Most brokers report DRIPs as non-covered securities on 1099-B. H' +
          'owever a few brokers opt to not report at all. If your broker di' +
          'd not report DRIPs on the 1099-B then uncheck this box.'
        WordWrap = True
      end
    end
  end
  object pnlUGtut: TPanel
    AlignWithMargins = True
    Left = 0
    Top = 830
    Width = 650
    Height = 64
    Margins.Left = 0
    Margins.Top = 10
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alBottom
    AutoSize = True
    BevelEdges = [beTop]
    BevelKind = bkFlat
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 3
    object lnkTutorial: TLabel
      AlignWithMargins = True
      Left = 10
      Top = 36
      Width = 194
      Height = 16
      Cursor = crHandPoint
      Hint = 'View your Subscription Renewal and Upgrade options'
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alTop
      Caption = 'Click Here to view Online Tutorial '
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      OnClick = lnkTutorialClick
    end
    object lnkUG1099: TLabel
      AlignWithMargins = True
      Left = 10
      Top = 10
      Width = 359
      Height = 16
      Cursor = crHandPoint
      Hint = 'View your Subscription Renewal and Upgrade options'
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 0
      Align = alTop
      Caption = 'Click here to view User Guide Step 5: Reconcile 1099 Proceeds'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      OnClick = lnkUG1099Click
    end
  end
end
