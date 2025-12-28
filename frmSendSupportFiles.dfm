object SendSupport: TSendSupport
  Left = 0
  Top = 0
  Hint = 
    'Here you can attach your broker'#39's 1099-B or monthly statement - ' +
    'whichever is needed for this support request.'
  BorderStyle = bsDialog
  Caption = 'Send Files to Support'
  ClientHeight = 535
  ClientWidth = 399
  Color = clBtnFace
  DragKind = dkDock
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblText: TLabel
    Left = 25
    Top = 143
    Width = 260
    Height = 16
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Files to be sent to TradeLog Support include:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object lblOption: TLabel
    Left = 42
    Top = 186
    Width = 95
    Height = 16
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = '2. Options folder'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object lblCurrentFile: TLabel
    Left = 42
    Top = 163
    Width = 195
    Height = 16
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = '1. Your current TradeLog data file.'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label1: TLabel
    Left = 23
    Top = 341
    Width = 348
    Height = 41
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    AutoSize = False
    Caption = 
      'Please provide a DETAILED description of the reason you are send' +
      'ing these files in the box below:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object Label2: TLabel
    Left = 33
    Top = 84
    Width = 38
    Height = 16
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Name:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 34
    Top = 114
    Width = 36
    Height = 16
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Email:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 25
    Top = 56
    Width = 43
    Height = 16
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'TL Ver:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object txtVer: TLabel
    Left = 77
    Top = 58
    Width = 4
    Height = 16
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbl1099File: TLabel
    Left = 45
    Top = 252
    Width = 45
    Height = 16
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'File #1:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Image1: TImage
    Left = 97
    Top = 253
    Width = 18
    Height = 18
    Hint = 
      'Here you can attach your broker'#39's '#13'1099-B or monthly statement -' +
      ' '#13'whichever is needed for this '#13'support request.'
    ParentShowHint = False
    Picture.Data = {
      0B546478504E47496D61676589504E470D0A1A0A0000000D4948445200000010
      0000001008060000001FF3FF610000000467414D410000B18F0BFC6105000002
      DB49444154384F6593D94F136114C5E74FE0D98869901DA12CDD404550700908
      294B51DB508A4091164A71056A50DCD000A32F266EE141D10797442306344645
      A2866DBA022DDAAA800289E2023E1893E3F74D87827292FB36BF7BEEBDDF19E6
      7F8565DF1085EFEC64C3736E7129255D50681F2242799B8BCCBBC346E6DF1309
      9FAD5458D6F52002B35BF4DDA86977A2AAD50DF571170A2C761434DAB0A3F60D
      24DAC78852DD67A38A1E0409985F02CCE99A076064C7B1D16083A4C28AF45A07
      2927249576C8ABEC48ABB64351F61AD1BBBBB8E83D8F969A50670AEF6D714352
      6EE56149850D3F7EFDE14B5AE580CCE084CCE884A2DA85A48A7EC4687AD84558
      9441C6AE26CE01584F2620AE14FE494A5EE382DC340245ED2814E631BEE2CBFA
      B04EFB54C4D08399DA5D81B11761A981B812370ACA08282390BCCE0DF97E0F14
      073C90991C88D53D67197A6D43DBE2E87E58B2CF81E58AA91A455C8D1BF1660F
      12EAC691482AB9CE83B8B2971CB35ED7054DB38B774F240D224BAC08D17008D5
      D9051C483093F50EBD83BCC10B85C547EA3D329B7CE426836092C95BAB8E3A10
      57CA2158358835BB86B1564B1A953B051C90D57B91D2F401A92726B0E9D414D2
      4E4F41D93689943A2B181A1265BD15AB94FD585D3808919A4358A9831F7B511B
      8E7D44FA992964B64D63DBF9596CBF308BD26B3348300E710C4D58AABE0FC105
      FD082E1A4248B11511C43DAE7A4CC08134026F6567907DF10B72AFCCA1B0E31B
      CA3B3E23D16463191A4FB1BA1BE2E281C0F8517A17C4B51E0107325AA79145E0
      BC8EEF28BAB980C6270BC83EEB4392D9E98F368DA758D38B08F530424BEC88AE
      1C11D025E55C9A83AA731E9617BF5173770E92836E7F90A868B6F978AA5F215C
      68409F4CDEE043EAC9497EFCFCAB73A8EF9987F1F657488FBCE5A487C7FFFD1F
      68B66334DD6CB4B61731E439656485CD162F72CF4D407B799A1CED13B25ABCBC
      F30A78B9683C6375CF581A12A96110C9668EBF363D5860E78018E62F1CAA3193
      6CA579F50000000049454E44AE426082}
    ShowHint = True
    Transparent = True
  end
  object Label5: TLabel
    Left = 45
    Top = 281
    Width = 45
    Height = 16
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'File #2:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Image2: TImage
    Left = 97
    Top = 282
    Width = 18
    Height = 19
    Hint = 
      'Here you can attach your broker'#39's '#13'1099-B or monthly statement -' +
      ' '#13'whichever is needed for this '#13'support request.'
    ParentShowHint = False
    Picture.Data = {
      0B546478504E47496D61676589504E470D0A1A0A0000000D4948445200000010
      0000001008060000001FF3FF610000000467414D410000B18F0BFC6105000002
      DB49444154384F6593D94F136114C5E74FE0D98869901DA12CDD404550700908
      294B51DB508A4091164A71056A50DCD000A32F266EE141D10797442306344645
      A2866DBA022DDAAA800289E2023E1893E3F74D87827292FB36BF7BEEBDDF19E6
      7F8565DF1085EFEC64C3736E7129255D50681F2242799B8BCCBBC346E6DF1309
      9FAD5458D6F52002B35BF4DDA86977A2AAD50DF571170A2C761434DAB0A3F60D
      24DAC78852DD67A38A1E0409985F02CCE99A076064C7B1D16083A4C28AF45A07
      2927249576C8ABEC48ABB64351F61AD1BBBBB8E83D8F969A50670AEF6D714352
      6EE56149850D3F7EFDE14B5AE580CCE084CCE884A2DA85A48A7EC4687AD84558
      9441C6AE26CE01584F2620AE14FE494A5EE382DC340245ED2814E631BEE2CBFA
      B04EFB54C4D08399DA5D81B11761A981B812370ACA08282390BCCE0DF97E0F14
      073C90991C88D53D67197A6D43DBE2E87E58B2CF81E58AA91A455C8D1BF1660F
      12EAC691482AB9CE83B8B2971CB35ED7054DB38B774F240D224BAC08D17008D5
      D9051C483093F50EBD83BCC10B85C547EA3D329B7CE426836092C95BAB8E3A10
      57CA2158358835BB86B1564B1A953B051C90D57B91D2F401A92726B0E9D414D2
      4E4F41D93689943A2B181A1265BD15AB94FD585D3808919A4358A9831F7B511B
      8E7D44FA992964B64D63DBF9596CBF308BD26B3348300E710C4D58AABE0FC105
      FD082E1A4248B11511C43DAE7A4CC08134026F6567907DF10B72AFCCA1B0E31B
      CA3B3E23D16463191A4FB1BA1BE2E281C0F8517A17C4B51E0107325AA79145E0
      BC8EEF28BAB980C6270BC83EEB4392D9E98F368DA758D38B08F530424BEC88AE
      1C11D025E55C9A83AA731E9617BF5173770E92836E7F90A868B6F978AA5F215C
      68409F4CDEE043EAC9497EFCFCAB73A8EF9987F1F657488FBCE5A487C7FFFD1F
      68B66334DD6CB4B61731E439656485CD162F72CF4D407B799A1CED13B25ABCBC
      F30A78B9683C6375CF581A12A96110C9668EBF363D5860E78018E62F1CAA3193
      6CA579F50000000049454E44AE426082}
    ShowHint = True
    Transparent = True
  end
  object Label6: TLabel
    Left = 45
    Top = 309
    Width = 45
    Height = 16
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'File #3:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Image3: TImage
    Left = 97
    Top = 310
    Width = 18
    Height = 19
    Hint = 
      'Here you can attach your broker'#39's '#13'1099-B or monthly statement -' +
      ' '#13'whichever is needed for this '#13'support request.'
    ParentShowHint = False
    Picture.Data = {
      0B546478504E47496D61676589504E470D0A1A0A0000000D4948445200000010
      0000001008060000001FF3FF610000000467414D410000B18F0BFC6105000002
      DB49444154384F6593D94F136114C5E74FE0D98869901DA12CDD404550700908
      294B51DB508A4091164A71056A50DCD000A32F266EE141D10797442306344645
      A2866DBA022DDAAA800289E2023E1893E3F74D87827292FB36BF7BEEBDDF19E6
      7F8565DF1085EFEC64C3736E7129255D50681F2242799B8BCCBBC346E6DF1309
      9FAD5458D6F52002B35BF4DDA86977A2AAD50DF571170A2C761434DAB0A3F60D
      24DAC78852DD67A38A1E0409985F02CCE99A076064C7B1D16083A4C28AF45A07
      2927249576C8ABEC48ABB64351F61AD1BBBBB8E83D8F969A50670AEF6D714352
      6EE56149850D3F7EFDE14B5AE580CCE084CCE884A2DA85A48A7EC4687AD84558
      9441C6AE26CE01584F2620AE14FE494A5EE382DC340245ED2814E631BEE2CBFA
      B04EFB54C4D08399DA5D81B11761A981B812370ACA08282390BCCE0DF97E0F14
      073C90991C88D53D67197A6D43DBE2E87E58B2CF81E58AA91A455C8D1BF1660F
      12EAC691482AB9CE83B8B2971CB35ED7054DB38B774F240D224BAC08D17008D5
      D9051C483093F50EBD83BCC10B85C547EA3D329B7CE426836092C95BAB8E3A10
      57CA2158358835BB86B1564B1A953B051C90D57B91D2F401A92726B0E9D414D2
      4E4F41D93689943A2B181A1265BD15AB94FD585D3808919A4358A9831F7B511B
      8E7D44FA992964B64D63DBF9596CBF308BD26B3348300E710C4D58AABE0FC105
      FD082E1A4248B11511C43DAE7A4CC08134026F6567907DF10B72AFCCA1B0E31B
      CA3B3E23D16463191A4FB1BA1BE2E281C0F8517A17C4B51E0107325AA79145E0
      BC8EEF28BAB980C6270BC83EEB4392D9E98F368DA758D38B08F530424BEC88AE
      1C11D025E55C9A83AA731E9617BF5173770E92836E7F90A868B6F978AA5F215C
      68409F4CDEE043EAC9497EFCFCAB73A8EF9987F1F657488FBCE5A487C7FFFD1F
      68B66334DD6CB4B61731E439656485CD162F72CF4D407B799A1CED13B25ABCBC
      F30A78B9683C6375CF581A12A96110C9668EBF363D5860E78018E62F1CAA3193
      6CA579F50000000049454E44AE426082}
    ShowHint = True
    Transparent = True
  end
  object btnSendSupport: TButton
    Left = 230
    Top = 503
    Width = 81
    Height = 25
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Send'
    Default = True
    TabOrder = 0
    OnClick = btnSendSupportClick
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 400
    Height = 53
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Color = clWindow
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 3
    object lblMessage: TLabel
      Left = 21
      Top = 11
      Width = 340
      Height = 26
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 
        'Please be advised that you are sending the following files to th' +
        'e Support Department at Cogenta Computing, Inc.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
  end
  object btnCancel: TButton
    Left = 77
    Top = 503
    Width = 81
    Height = 25
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
    OnClick = btnCancelClick
  end
  object ckbImport: TCheckBox
    Left = 25
    Top = 209
    Width = 263
    Height = 17
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = '3. Import folder (optional)    '
    Checked = True
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    State = cbChecked
    TabOrder = 1
  end
  object edName: TEdit
    Left = 77
    Top = 81
    Width = 211
    Height = 24
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
  end
  object edEmail: TEdit
    Left = 76
    Top = 111
    Width = 295
    Height = 24
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
  end
  object edDetails: TMemo
    Left = 21
    Top = 385
    Width = 354
    Height = 115
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    MaxLength = 1200
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 6
  end
  object ckbInclude1099: TCheckBox
    Left = 25
    Top = 230
    Width = 263
    Height = 17
    Caption = '4. Other Attachment(s) (optional)'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
    OnClick = ckbInclude1099Click
  end
  object edFile1: TEdit
    Left = 120
    Top = 252
    Width = 225
    Height = 24
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 8
  end
  object btnFind1: TButton
    Left = 349
    Top = 252
    Width = 26
    Height = 23
    Caption = '...'
    Enabled = False
    TabOrder = 9
    OnClick = btnFind1Click
  end
  object edFile2: TEdit
    Left = 120
    Top = 281
    Width = 225
    Height = 24
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 10
  end
  object btnFind2: TButton
    Left = 349
    Top = 281
    Width = 26
    Height = 24
    Caption = '...'
    Enabled = False
    TabOrder = 11
    OnClick = btnFind2Click
  end
  object edFile3: TEdit
    Left = 120
    Top = 309
    Width = 225
    Height = 24
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 12
  end
  object btnFind3: TButton
    Left = 349
    Top = 309
    Width = 26
    Height = 23
    Caption = '...'
    Enabled = False
    TabOrder = 13
    OnClick = btnFind3Click
  end
  object Open1099File: TOpenDialog
    Options = [ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Select Restore File'
    Left = 346
    Top = 196
  end
end
