object dlgPriceList: TdlgPriceList
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Confirm Year End MTM and Futures Prices'
  ClientHeight = 354
  ClientWidth = 358
  Color = clBtnFace
  DefaultMonitor = dmMainForm
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 358
    Height = 354
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object Label1: TLabel
      Left = 18
      Top = 8
      Width = 273
      Height = 26
      Caption = 
        'Please confirm all prices. If a price is empty then it must be e' +
        'ntered in the grid before you can continue.'
      WordWrap = True
    end
    object btnOK: TButton
      Left = 217
      Top = 318
      Width = 75
      Height = 25
      Caption = '&OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 80
      Top = 318
      Width = 75
      Height = 25
      Cancel = True
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 1
    end
    object grdPrices: TRzDBGrid
      Left = 18
      Top = 40
      Width = 327
      Height = 262
      DataSource = dsPriceList
      Options = [dgEditing, dgTitles, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgTitleClick, dgTitleHotTrack]
      TabOrder = 2
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Microsoft Sans Serif'
      TitleFont.Style = []
      OnKeyUp = grdPricesKeyUp
      AltRowShading = True
      AltRowShadingColor = clInactiveBorder
      Columns = <
        item
          Expanded = False
          ReadOnly = True
          Title.Caption = 'Ticker'
          Width = 226
          Visible = True
        end
        item
          Alignment = taRightJustify
          Expanded = False
          Title.Alignment = taCenter
          Title.Caption = 'Price'
          Width = 69
          Visible = True
        end>
    end
  end
  object cdsPriceList: TClientDataSet
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'Ticker'
        DataType = ftString
        Size = 40
      end
      item
        Name = 'I'
        DataType = ftInteger
      end
      item
        Name = 'Price'
        DataType = ftFloat
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    OnNewRecord = cdsPriceListNewRecord
    Left = 115
    Top = 266
  end
  object dsPriceList: TDataSource
    DataSet = cdsPriceList
    Left = 47
    Top = 266
  end
end
