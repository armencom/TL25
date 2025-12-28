object panelSplash: TpanelSplash
  Left = 0
  Top = 0
  Margins.Left = 0
  Margins.Top = 0
  Margins.Right = 0
  Margins.Bottom = 0
  VertScrollBar.Tracking = True
  BorderIcons = []
  BorderStyle = bsNone
  ClientHeight = 461
  ClientWidth = 701
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  OnCreate = FormCreate
  OnHide = FormHide
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object pnlMain: TPanel
    Left = 26
    Top = 14
    Width = 640
    Height = 420
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    BevelOuter = bvNone
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    Padding.Left = 10
    Padding.Right = 10
    Padding.Bottom = 10
    ParentBackground = False
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    object pnlFoot: TPanel
      Left = 10
      Top = 270
      Width = 620
      Height = 140
      Margins.Left = 12
      Margins.Top = 12
      Margins.Right = 12
      Margins.Bottom = 12
      Align = alBottom
      BevelOuter = bvNone
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -44
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      Locked = True
      ParentBackground = False
      ParentFont = False
      TabOrder = 0
      object pnlTLver: TPanel
        Left = 300
        Top = 0
        Width = 320
        Height = 140
        Margins.Left = 12
        Margins.Top = 12
        Margins.Right = 12
        Margins.Bottom = 12
        Align = alRight
        BevelOuter = bvNone
        Color = clWhite
        Padding.Top = 41
        TabOrder = 0
        object txtACL: TLabel
          AlignWithMargins = True
          Left = 1
          Top = 28
          Width = 157
          Height = 15
          Hint = 'About Cogenta Computing, Inc.'
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 8
          Caption = 'Cogenta Computing, Inc.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 16744448
          Font.Height = -12
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          OnClick = txtACLClick
        end
        object txtCopyright: TLabel
          AlignWithMargins = True
          Left = 1
          Top = 48
          Width = 249
          Height = 15
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 8
          Caption = 'Copyright (C) 1999-2021 - All Rights Reserved'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object txtEULA: TLabel
          AlignWithMargins = True
          Left = 1
          Top = 68
          Width = 236
          Height = 15
          Hint = 'Click Here to view EULA'
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 8
          Caption = 'End-User License Agreement (EULA)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 16744448
          Font.Height = -12
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          OnClick = txtEULAClick
        end
        object txtPublBy: TLabel
          Left = 1
          Top = 8
          Width = 140
          Height = 15
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 12
          Caption = 'TradeLog is published by:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lnkPrivacy: TLabel
          AlignWithMargins = True
          Left = 1
          Top = 88
          Width = 161
          Height = 15
          Hint = 'Click Here to view Privacy Policy'
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 8
          Caption = 'Your Privacy and Security'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 16744448
          Font.Height = -12
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          OnClick = lnkPrivacyClick
        end
        object lblOffline: TLabel
          Left = 1
          Top = 108
          Width = 102
          Height = 15
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 12
          Caption = 'OFFLINE MODE'
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -12
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          Visible = False
        end
      end
      object pnlVer: TPanel
        Left = 0
        Top = 0
        Width = 218
        Height = 140
        Margins.Left = 12
        Margins.Top = 12
        Margins.Right = 12
        Margins.Bottom = 12
        Align = alLeft
        AutoSize = True
        BevelOuter = bvNone
        Color = clWhite
        TabOrder = 1
        object txtTLver: TLabel
          AlignWithMargins = True
          Left = 84
          Top = 8
          Width = 61
          Height = 15
          Margins.Left = 0
          Margins.Top = 6
          Margins.Right = 0
          Margins.Bottom = 0
          Caption = 'TradeLog'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object txtRelDate: TLabel
          AlignWithMargins = True
          Left = 84
          Top = 28
          Width = 124
          Height = 15
          Margins.Left = 4
          Margins.Top = 8
          Margins.Right = 0
          Margins.Bottom = 0
          Caption = ' v19.0.0.0 - 01/01/2020'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblTLVer: TLabel
          Left = 0
          Top = 8
          Width = 45
          Height = 15
          Caption = 'Product:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblRelDate: TLabel
          Left = 0
          Top = 28
          Width = 44
          Height = 15
          Caption = 'Version:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lnkRenew: TLabel
          Left = 0
          Top = 108
          Width = 169
          Height = 15
          Hint = 'View your Subscription Renewal and Upgrade options'
          Margins.Left = 20
          Margins.Top = 0
          Margins.Right = 20
          Margins.Bottom = 0
          Caption = 'Manage Your Subscription'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 16744448
          Font.Height = -12
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          OnClick = lnkRenewClick
        end
        object txtExp: TLabel
          Left = 1
          Top = 88
          Width = 57
          Height = 15
          Margins.Left = 12
          Margins.Top = 12
          Margins.Right = 12
          Margins.Bottom = 12
          Caption = 'Expires at:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object txtExpires: TLabel
          Left = 84
          Top = 88
          Width = 134
          Height = 15
          Margins.Left = 12
          Margins.Top = 12
          Margins.Right = 12
          Margins.Bottom = 12
          Caption = '12:00 AM on 04/15/2018'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object txtReg: TLabel
          Left = 1
          Top = 68
          Width = 76
          Height = 15
          Margins.Left = 12
          Margins.Top = 12
          Margins.Right = 12
          Margins.Bottom = 12
          Caption = 'Registered to:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblEmail: TLabel
          Left = 1
          Top = 48
          Width = 35
          Height = 15
          Margins.Left = 12
          Margins.Top = 12
          Margins.Right = 12
          Margins.Bottom = 12
          Caption = 'Email:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object txtEmail: TLabel
          Left = 84
          Top = 48
          Width = 52
          Height = 15
          Hint = 'Click Here to copy'
          Margins.Left = 12
          Margins.Top = 12
          Margins.Right = 12
          Margins.Bottom = 12
          Caption = 'txtEmail'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 16744448
          Font.Height = -12
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          OnClick = txtEmailClick
        end
        object txtRegUser: TLabel
          Left = 84
          Top = 68
          Width = 134
          Height = 15
          Margins.Left = 12
          Margins.Top = 12
          Margins.Right = 12
          Margins.Bottom = 12
          Caption = 'Cogenta Computing, Inc.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
      end
    end
    object Line2: TPanel
      Left = 10
      Top = 268
      Width = 620
      Height = 2
      Margins.Left = 12
      Margins.Top = 12
      Margins.Right = 12
      Margins.Bottom = 12
      Align = alBottom
      BevelOuter = bvNone
      Color = 4858714
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 4858714
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 1
    end
    object pnlFile: TPanel
      Left = 10
      Top = 0
      Width = 300
      Height = 268
      Align = alClient
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 2
      OnClick = pnlFileClick
      object imgLogo: TImage
        Left = 4
        Top = 16
        Width = 200
        Height = 55
        Margins.Left = 12
        Margins.Top = 12
        Margins.Right = 12
        Margins.Bottom = 12
        Picture.Data = {
          0B546478504E47496D61676589504E470D0A1A0A0000000D49484452000000C8
          000000370806000000499C0552000000206348524D00007A26000080840000FA
          00000080E8000075300000EA6000003A98000017709CBA513C00000009704859
          7300000EC400000EC401952B0E1B0000000774494D4507E4011C0E220B5C5080
          010000145149444154785EED9D0FAC1D531EC75F44444444448888880811BBFB
          DE13111B11F2DA548408911521361BA2DB86D8AC104208A27D645710A44BB0B1
          25F56783B26CE8FA137F5B2CA5AFD5FABFB5F55F156D29DABEFD7C8FDF19E79E
          7BE6CCDCDBFBE8B5F34D3E99F3E777CEDC3B737E3373CE9C991968D41B8DFF7E
          E026F8BA84F966F6936868E6D897305EC28D66F67FA74993266D03736015AC87
          75300653CCA451AF8413FC03C64B78C7CC7E12E1048D8344C209F68235F0255C
          0EBF815360016C846BCDB455ECCC47E193122E31B34691D8368D83F49170808F
          E035380F66C32D7015EC0C27819CE45833FF41ECCCF7A29D1B72BB99358AC4B6
          691CA44F44C33F1936C00EB00256C27C580B1F9ACD43B0DC1508C5CE6C1CA40B
          B16D1A07E913D1F01F85310BCB411EB0F03FE02B0B1F081B156E113BB371902E
          C4B6691CA44F44C35F088F5B580EA2CBA971F816A63B23A4340BFE207666E320
          5D886DD338489F88867F3FBC6561770601DFEF38C9D28F81F50AB7889DD93848
          1762DB340ED227A2E18F98330C427889A533CB9A9191912D592E86975D8150EC
          CCC641BA10DBA671903E128DFF45D010EF6FE19796E647B0EE0075E25D7A8BD8
          993F8A8350D78E70393C0F6FC1ABE04E6F65227F3B980AB36101A8CC3BF0362C
          81E7E00E380776B5625D69FCD4812DA8E31450C31F03ADE77578062E811DCCD4
          8978CF1C04FB3DE0327802F4BFB4EE37E045D07F3FC24C6B0927E89983607F08
          DC0EAFC1E7B006BE82D5F011CC878BA165FB742BEA39099E808F215CD73B702B
          EC69A64EC40F8629090E3613271AFF56A0B3841C412358B3E04EF80CD41739CE
          19B2B137426AA7D6E555ABE784283DE459B732343E75605BE20F436ABD779A59
          8B483F15FE039DFED68FE15CABA69636FEDE3986EE8A7F6B7594A1DFF214ECA4
          722C37D941B0D3FFCC1DA042BE8259E3D306B6B0E2A5A2716CB28360773EAC0A
          CA55B11116C2A055D191287702C8015375C7CC1B1A7D654B2BF76D94E7F9D655
          1C0947381EE420BAD4D27D911B617BCB763B25B5F13BE175ABE7A4283DE479B3
          D90FD606E9312D0E427C4F7837C8EF1635BA9DADDA5261B32FACB43275F9060E
          86AE1D847CFD4F9D255265ABF8027E6D552545E3E8DA41C8DF073E08EC3B458E
          729B55574BD8DF1D94AFCBF2C119635BB2ECC8412A156DEC6EA8E520A0CB0635
          A654BEA77010C2FB43957D27A8216D67D5B7893C396FD559A38CEF607E941652
          EA20E41D092A9F2A57970D70A255D9261A47570E42DE61F05D60BB292C1D9EB9
          D81DE573C2EE81A85C27E852AC6F1D64799496C23908CB6D2077A6E99647557F
          2CD2D5B75913D8F59AA483903E19D4B853653A45F51C6255B788C6D1B183903E
          0CEB03BB5EB0C8AA4F8AFCF322FB5ED2B583AC0635464FEE3A5F47BAD056B81B
          2E2C730EA2A3772A3DC63BC8DC283D46BFF93A380AF60635B473419DE894BDA7
          7D5C1B91FE646457869CE87DD06558270DBBCD4148D320C5BAC02685F6C52AD0
          3AB5ACEA83AD199F3ED07694A67174E3209F4576293E8517E12950A7BDECE81D
          72A5ADA2458333C7B627AFCED9EA13780E9E0175D43740CA2EA63B0789C546EE
          6A148BBC9C83D4C53B48EE5247BF6F2BB7D284C87B24B04DB1BF993A111F8EF2
          53BC002DA325C4B7826BA1CEC041CA4134E296B215AAF306D8C6CC9D886B80E3
          564895F1CC31F342348E8E1C84B4EB239B982F60C4CC0B0DCE5CA43EC08DA07E
          47AA9C508376031BA148BB33B049A111ACC9665E6868E6A2ED48D7A555AA4C48
          5F39888675CF84A24F303E6D6007E27B813ABCA9329E83AC4852D4B373A24C48
          CB0C4DE21A4A4DD979FE66A649917F385439498B8310577F2765274A2F95BCC8
          D73073AAAC580F5B9BA9138DA3B6830CCF1CDB82B46F229B10D5951DC225FFB4
          C03EC53D665A88B475914D88F27631D3A4C89F17D8A7E80B0751433AC78A2445
          FED9817DCCD766961576B9CB9FEFC7B74DC47367ABFF9A5956D85D1F958B891D
          44C3C3293B917E0E2112761F44E54246CDCC89C651DB41889F11E5C7B41DC553
          C26E41542E649D9939113F3CCA8FF98399966AF85277F6CA39595F38C8E5663E
          61621DEA93A4D6ED291C84B0FA2E291BCFF1669A1567AD2DB1CD8D44C50E52E6
          941BA8ABF4F23114B617466543DC3C232F1A47270EF242941FB2C2CC2A85AD3A
          F9A93A3C879AA96C6F8BF2425A9C29276C73C3C39BBD837C66A61326D67122A8
          039F5ABF2774105DE7A76C44471B14FB4551F990C241081F14E5857C606695C2
          56FD91541DA2653082C6D18983E46C6F32B35AC25EFD86543DE27A3393DD5894
          17B2D0CC2A85ED5151D990CDDE416699E926897A74B41E813FC22DA04EB96EB2
          D5BD87113A88A68DA46C445BC73A27ECF55B52F588D04146A3BC105D82A69E69
          2F235587676F5B65A70E92EB60FFD6CC6A09FB57A3F2210BCC4C761A994AD988
          D96656A9FD46176D9D28EFD9EC1DA4652E4C5D516E37B8121683A657A4EAEE84
          D04172C3C2C5F4983AC25EF3BF52F588D041EE89F2268AE2F290C651CB418667
          2CD68850CAE67B4617ED66A6B5449947DBEAF881256626BBB5515E4871A6A923
          ECCB867D376F0731B3DAA2CCEEB030ACA347840EF266941772BF99D512F69A47
          95AA47840EA267FE5336BDE63C5B656D0721AC6925291B4FCBB07395B0CFF52D
          DE36B32A07B9C1CC6A09FBB27B299BB5836C30B35AC25E9DE76EA75FE8AC901B
          76ADEB20EE1981BAC27E5A543EE4A7709019B6CA4E1C648F282FA65307B92B2A
          1FE26660488457467921A56D2E25ECCB2E11376B07F9CECC2A85ADEE30D79983
          A5F17E0D756A1A8BA6B89F0E6E1626CB5AC3BC84355D3E65235E30B35AC23E37
          AA143AC8BD515E880E0ADAFEBDA0F89F348E5A0EF2AB5137D92F65E339D04C6B
          097BDDF14ED523169B99EC96467921EED9F13AC276302A1BF2B3719087A2B231
          2BE004334F8AFCBA0E727F9417E2DE6E5157D8DF15950F091DE44F515EC8BB66
          D653D1383AE9A4E7E65F9D6566B584FD7FA3F221FF3433D93D14E5857C636695
          C25677F15375889F8D83E4E627BD6666596157F7122B77D4571DB5EE4948D8E6
          2ED742079912E585B8376AF45A348E4E1CE4C3283F2439D933A5A199AFE88E7C
          CED92E3453ADF3DC282FA678914299F6BF7899D697EBCBF4BF8360971BDB17D9
          E71E246C7689CAC4840EA229F8291B4FAD1B9BE353DD6CE0DC592B74103D90A5
          CBC3949D288667AB84ADA6D568DA4ACC3E66E244E3E8C441EE8DF243D60D8E8E
          553EA02561FBC7A86C4CF1C427E11DA3BC181AFEA21F1E624A089BAA69F23F8A
          833C68666D22AF170EA2674052E51D6696157617C5E5220A0791886B966CCA4E
          E86CB6AD99960A9BDB8332290A079188E746E71E31B34A61FB6954D6530CA14A
          348E4E1CE480283FE62F665A2A3DF7819D2634A6CA8BF7CCB410699A999BB2F5
          68E6F01E665E6868C662DDFB7824B02BE34771909566D626F27AE120FB44E562
          F633D3A4364E7347E7CFA23231B183E46EF0093D0B9E9B3D7C3CE42EE944EC20
          7A482A65E7996AA64991AFFF997B40ABE5D97E1A476D0791485B1ED9846894E8
          54336DD3F0A8738E9703FB146D73AB48D3B3E729DB10AD7B09CC81D9A0693175
          1FE8EA9983543DD8A4A3D6037027A8937B8D95EB8583E82E79AABCA7E5C818CA
          E643BD1CD9A768995F457C7BC85DF208FDE763AC881371959B0355CE215A1C44
          224D339A53B69EC761D8CC9DEC7979BDB422F758F0A7665E88C6D1A983E849C2
          946D885ECE30854B1FF7FCC9E0CCB11D88EB650DB93387F8C8AD2421F25E8F6C
          7B49CF1CE4A568835751E789C24E3AE955CF842B7F16E8C87D349C0C72D6BA77
          D9DB8E7EA4E5E66485683A8B7F502C955F46CA41F4FC7BAEDFE209D759C7BEC5
          91251A47470E22917E5F64D70B7406281D2A266F27F8DA6CBB41CFCEF7F691DB
          586C60BD8A27B5E1CBE8B5835C1595ED3517DBAA5A44BA868F53F675A9D5490F
          45BAEEDDA4ECBBA5ED390B89C6D1B1830C5EB658A342B9B954DD709A555F2A6C
          7E09B9498E6568046B77987007D91AAA26C285F4D44124ECF5BA9E543D75C90D
          15DF62AB6911E9BA4199EBB057717122CD937410893C3D3856E732AD8A27ADCA
          36D1383A7610E917972E9193E8522A55AE1334DC5BDA6F8985AD1EBF7DD2CAD6
          41B381DD538A2C27D6412436F6A150F78D2213E1201AAA2D1BA1C9A1CB11CD89
          7A30488B697F9DA4893CF52BF4A2B654B932D4B8CF1D9F3A3018A587943A8844
          BEB67737FF57E8CC75955595148DA32B07F1C2E62CC83D8C946319EC65557524
          95033D8AFB3EA8E1FB692472388D6AE906E30166EE44BCACD35EFB86632DB1D1
          7D2754D7FCB9239CEB38B3FC0D6867A558E32AED40343875BA35C254C751757D
          AEE9267EAA893AB2A9DF21568F4FCFBF6C0D9BE950E72CF61AB87B332C7D9F22
          45ADE912D89D05752FF57496D7CB2D2ADFF745E3D0A892E63BA5282635E634F4
          FD3BA72E01DD1D2F9BEFE491333D0DD947872742ACB36C36EF84DC842DC48ED0
          33E39A442847D030E5B0468E2C7B42C5BAF4DCB7DE76A83732EAF59B1AE2D4D4
          0E5DD6EC6B663D97EA06F5C9EE03BDB8412F5AD074F50BA0EDC503BD1275EBE0
          741AE800F51868E044AF5AD5BA3555A5A3395113211A9C1E93D599E566D02B40
          AF82DFE1486DF72A7E2CB1FE7D21E51CA2FD63388D1AF58B68C03A9B69042BC5
          2966961576B9E9F5F3CCAC51A3FE130D587D8A54C31695477F6C34449CBB6978
          B299366AD47FA20157BD8F77DED0E8E2E48C06F27683DC63BB6BCDB451A3FE14
          8D7857A87A4BA246B2F446C56B40AF29D50BEEF466C7AA7267D86A1A35EA5FD1
          902F8C1A762FF89755DF1B4D9A34E965D04745CEB7B8BEC0A3F8D316BF16D681
          3E7AA8CF582D03377599E5F520DB8B1497087F026E0C9AA5BE45AD7CB11E5641
          DBF73B2CCFDB154C9E3C599FCCD2C7DF7D9A3E74B2148AA9D384B706FD3EE5FF
          D5920728BBADA57964F3261C69267EBDFE33C00F83EC5E729988F0A996F667C5
          A9730BC2B782DF1E42E1D2370F92F731A88E2916D7B7B915BF19549FBE9FF71D
          A82EA53FCB7ADCA3AE849FB4B4E2ED908465FB8985F59D0BE50BFD17ADAB65EE
          19F1432C3FC6DDAB62B93D68BB2AADB8BF42F85E4B7BCAE2DA175AF7A7A04F96
          F9329EB9871D7698FECF5316F7EDE50A57618968D0B3A206BE293C64D5F64EFC
          8163EDCFF88DFEB6C5F559DC6B2CFC0DE853BAEF59DC4D9063A9C6A2F89F1497
          08AB41BBCFE9B2BCDBF25F027D7257E18D2323232D53CA4953437806FC8655F8
          191ACAAE2CB553B4F3E56C1F80F2E75B5195BDC8D2B4333EB76435E6ED2C5D0D
          580DC9FF76D9B9B7055AFC4B0B6B9D8A0B37FB94E519167753BE596AE72BFE15
          CC35F49B4AEF4D907739A88CBB61C9D23BFC8EF018284F69F3400710C55F315B
          7D434FF1E2894A8BBB6B6C96FA6292E22AFBB4855B5EBC467C2F70DBD3F2B56E
          859FB0FCAB83F462622161FD3E6D776DAF3DC0AFEB74CB57BAF27DDD67C29520
          1B39913E4CF3205CEA2ACC88867D22E41E7EAA425FA1CACE88DE24F1277CE3D1
          9FD4D23D3FCC524709C58BAF0611D6194269BF83BA0EE29E2663B9DAE2C9D7C9
          905E94F5222E0771AF20653915547E99CB4484FF03DAB92F589EBB67103848F1
          582BE17F5ADABF2DAE70EC203A18E87FEBA3F38583C0B085B3678C58F681C8AF
          410DEA7C501DF7801AA0C2FA7FAE3E7EB3CE865ABFD2F7865A0E42B9C32DAEED
          50FAC20CD942CB4D5CE21F827EC3AB965F3C7C45D81F20BD73BC6959CAD3FF59
          6D5127E23AEBC86EA1FEB725D7D2E0F7EF08BE085640D58D49219BF74037336B
          3DD4D5B5F84327DA1FD31141CBFDC1EFC0E2A82C11BFCBD2758950D741F4A9AB
          45165EEA0C1322AFCC41B4E3D5B875E4D68EF19FEED5194675EAB26F9A85DDF8
          7789831C6C69EE39170BC70E72812D9F87D041AEB0B03FF2CA5EFF4B643B85E4
          FB86A6ED2B7459E3B7B9FBA49D17F1314BD7A56EDD33C802D08142E1D2B7B358
          7EE12084F7B134FDD7F32CFC77CB9673EB92E9734BD7762F3E726971579F713A
          68FB6A5F295D0792AE5E1E3834634C0F451D0BBA19A9A9270FC25CF82BCC8023
          8666A447B8264CFC191D49F4C7FCE97D278B7FE10C4CC475F453FA0DE01DA4B8
          CE24AC8DE58E622CBD83A8916BB986865BFA2A19E543CA4154D63B6FF1841B61
          39A9D274A9723668A7B9B34D89831C6969EE09370BC70EA26B6D7FB9A2FE8196
          7290EB2CEC2609B2D459D7FFB6EC1BE1A74C99A286E6CF0C77298DA5779096E7
          EE892FB1747D7D5597A60A175F93B2B86BE42CBD83F8337DF6FE81D9840EE2F7
          8FBE1BEE1DC46D0F89B0B6A1FFDDE268CB529EB6B59CC11F245CDF87A5B69FBE
          28EB1D68AE2BD0EFE28FCCB63F74992529CD6F78DFC1D49742F5295DA51D0AFE
          A8EA460E586A836AC3F8235C7189053759F839E5A5445E9983E8124575AF05D5
          E1BE55C172A5C5638E8B1D84A51AA93AF84ABBC3D2144E3988CAEA08E877B21C
          449D5D85D7716475974484FD3577D641246C3418225BDF90FC01488D6C774BD3
          67897520D07A7589A7BE856CDC2001CB032CEE1C81657189C5F259CB2BFD2D96
          1F3A88B6B7D262FCF655DF50717FD5A0B389BB9C61A9DFD87289C5EF289E2327
          EF3870652CA9BFC51F493988EF606A27BE01BE81FAB3CCEEE01BD13BE037B8FF
          507BDC07D12777154F7EFE99F45207B1B02E3B545E8EA14104853F825D0CEFB0
          CF050EA2F21ABD929329BECA0F1258BCCD412CAE112CC585EFA4FBA3BB8EAABA
          66F79DEABFC15920A73A5BB6B1486F711089B08EDC4AD36F7C1DFC01C95DE6B0
          3CCAE2DAC6DAFEFE68EE3E77C0B27010354EC22A2FDBE4A3CAB2057FF639C2E2
          CBC16F3F5D15284D0332475BD86F1F7FB9E75E68CD52EB51BBD0B61573E0EFA0
          2B11FD2F7D4556F6BAB4565DDAFE1DBD0C7BB3123FFE12D011C28D527811D7A9
          570D523B510DF86E7646D10123AE46AB8EBB3FD23FECF309FF1954A79B5BC352
          97388A27A7A093AE237CCBFBA988BF0B6F5854F1274075E8BA59CBB0FFA3A15D
          39A19C751B50BEE77DD04E2C2EF108CBD60F48E80021BBE2CB52847504579A9B
          016B1D6E1D4D7516D5FF9543A8E14E8673400D34395B96741D2C54973B1B7B11
          D750B9AF4FF9575B9613718DD229DD6FFF9B2D4B79F7599E1B9860A97DA578B2
          1F42BAF6A3EB03B2D47A657B81CB4484D5A7539AFA74EAD728EC1E7A62B92FE8
          80B082EDA0C104ED73E57B7499FB07F802FCB69153E9ACA891523977F2D99C46
          8D1A356AD4A851A3468D1A356AD4A851A3480303FF037EEB2DA31B7CB47B0000
          000049454E44AE426082}
      end
      object imgFileNew: TImage
        Left = 4
        Top = 82
        Width = 15
        Height = 16
        Hint = 'Create a new file for your brokerage data'
        Margins.Left = 12
        Margins.Top = 12
        Margins.Right = 12
        Margins.Bottom = 12
        AutoSize = True
        ParentShowHint = False
        Picture.Data = {
          0B546478504E47496D61676589504E470D0A1A0A0000000D494844520000000F
          000000100806000000C95625040000000467414D410000B18F0BFC6105000002
          2D49444154384F9DD2ED6B52511C07F01BF40FD4CB7A5910D120755B0F366204
          7B53B0D58B5EF5A217510DA2C2A0922272AD505913F53EA837656D2C0273D0A0
          E6035ACE31B24D2D2856734D375A44A2B368B97CC86FE75EAF386523E8C097C3
          B9FC3EE7FCCEE152A78DAE5C27ED2B76D2DEFA30BE6297D953648747E7D45A6E
          0BB5DE384E7B73725B0C0A5BA42151C8D85758C9ADC2F6F8F9EC35BD639B446A
          43C0426133018D1170EE771EF9421176A73B71B5D7B643629551C52DA4B89A2A
          567061C4E71791585C4272F10BCC03234995C1BE55A235BCEF4114AD24953982
          56BEB2E121260425334E12C209DA0D95C1B25DA215DCC44DC337BF8C647615F1
          CC2F98C39F713390C099D18F75D738CAF8091EACC7C2C93BCD6138DFA770712C
          0EB9751AF7420BE87E362B3EDE3FF16E660AAE9914549E39B1DDFFC642A18085
          B6F7B0539059AA38B0311E59837B820BF894C9E1EDD79FB8E14FA08D9BC0C97E
          175477E91689D6B0C21A419B2386FDE4B5057C80CCED0FDF8851DAA3386F1842
          3E9F473F3FD827D11A16C0DAFB896BB2A1929C78D0E0C5592D8F42A1008D8173
          9DBBDE73EC72AF7E571D6E8C8C8F414FF3F896CE882997CB48A597FF64B2DF4B
          DCB0F305D545FBA47F9BB4DE1019F97EC1F408439E093CF1BE44A954823B38B9
          E49F0CBFD659078CD429D3D374073BFEA3830DAE9B236C70E5B03190EDD6F3A4
          EB02B48CE37EBB46B399023651B774D6BD9A3E4BD346B962BE23BF645237AB75
          C6B1D8BB0FB86DB168454C51D45F9B542F5EDDD875F30000000049454E44AE42
          6082}
        ShowHint = True
        OnClick = imgFileNewClick
      end
      object imgFileOpen: TImage
        Left = 4
        Top = 113
        Width = 16
        Height = 15
        Hint = 'Open an existing TradeLog file'
        Margins.Left = 12
        Margins.Top = 12
        Margins.Right = 12
        Margins.Bottom = 12
        AutoSize = True
        ParentShowHint = False
        Picture.Data = {
          0B546478504E47496D61676589504E470D0A1A0A0000000D4948445200000010
          0000000F0806000000ED734F2F0000000467414D410000B18F0BFC6105000002
          2C49444154384F95D2EB4B53611C07F0A77FA257412FACA4578111065D68620B
          8355068E2EC45C0A1684C9AAD54C4BDDF5CC1DB569DB649D9AF3D2D63087D351
          CB1BBD28616C3A5392A20BD9F6A2408F6EB9B621DFCE4E21122766073EFCE09C
          2F5F789EF3238EA692E813A364C9454916DD9464A95B7B3CD6A614E593CD3E63
          36E97274A81C0B83327CF5C9F0F9E905F84D47FD9E8642B1B7615F71FF5FB2EF
          06D485625BBD680F5FE0BF7F9EF5F4AAD1D3AD458F538B3E7E6A60B337A63A18
          6DCACAE852960D3A388C439F7650522B5FE06E95B3872C93D86EFB80BCCE77BC
          1D9DEFB1DB3E8F03E6000A4C01ECA59FAF2BA00310B5F860AA3FE3B6DC2EDE4F
          3C6D17D9139667384D3328E33DC049BA0B54BB0A9FBC15888D2A107D51B32EF6
          677E19BB959E1BAC8913575B255BD7DE8C6FA357117F5D8B95572A2C674DD621
          19D123392D2CFD86C2C78032491E730536AB0AABC1BB589DD26DA0C58FF0BFFD
          8C1810F1567F277DAD152CC334223DD5848440504822A4416AC68009A63CC415
          C8D9218F06E969F57F1524B90237756A8030F459766EE00ADF281416923D5E3C
          D8B4E6D44A4CE491AE948D8EABB88BD109868564B30B13B571CBCDA21262BF73
          8C8D877E7F48703327BE408FB7C3D716CD0A6E1BFBEF495732B3466466F4C8CC
          52C870BF2797B5791A41D7A5F9E6EBE2ADC4D55CFAD2E7AC0A0F775506471859
          70E4610E5C66DC210FF71A242DDC226F21E61B457965D4E5FC73C6AA9DC6EAC3
          9B422B0EEE322B8F6C2384905F48BA736F770A95480000000049454E44AE4260
          82}
        ShowHint = True
        OnClick = imgFileOpenClick
      end
      object lnkFileNew: TLabel
        Left = 30
        Top = 82
        Width = 110
        Height = 16
        Hint = 'Create a new file for your brokerage data'
        Margins.Left = 12
        Margins.Top = 12
        Margins.Right = 12
        Margins.Bottom = 12
        Caption = 'Create New File'
        Font.Charset = ANSI_CHARSET
        Font.Color = clHighlight
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        OnClick = imgFileNewClick
      end
      object lnkFileOpen: TLabel
        Left = 30
        Top = 113
        Width = 125
        Height = 16
        Hint = 'Open an existing TradeLog file'
        Margins.Left = 12
        Margins.Top = 12
        Margins.Right = 12
        Margins.Bottom = 12
        Caption = 'Open Existing File'
        Font.Charset = ANSI_CHARSET
        Font.Color = clHighlight
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        OnClick = imgFileOpenClick
      end
      object imgFileRecent: TImage
        Left = 4
        Top = 145
        Width = 14
        Height = 16
        Hint = 'Open an existing TradeLog file'
        Margins.Left = 12
        Margins.Top = 12
        Margins.Right = 12
        Margins.Bottom = 12
        AutoSize = True
        ParentShowHint = False
        Picture.Data = {
          0B546478504E47496D61676589504E470D0A1A0A0000000D494844520000000E
          00000010080600000026944E3A0000000467414D410000B18F0BFC6105000002
          3A49444154384F7D91496C525114867158B87357B7C6BDDA476D74D595312626
          DD188CD6A40E311ABB68ABB16A5CBD444D5B41195A783C86D298B65252842A50
          067DF04440060B0842B5D4B684212A0B372626407F1F3805219CE4CBBDB9B9DF
          FD73CFE19D93187FF44E38CAADB8283556C6E9F9299274EFE4FD5FB50B5D7404
          AD38453991FBFC15632ABD8624C9EDBF955FD54E14281CA854AA287C29619CD6
          3726B74D94DB91CDE691CB15107B970629D689FF26B7130F2B833822F3D4E99E
          F0A25F62B40B04861D2D453EFDB60EA15A06210F802F654170EC97F9D02731D9
          5A8A7C8E5E25C3F11267A82538DFC4904CA5118972EB870C340BD6F56152BCB7
          493CA88A426D61C1F843D8E0FE255EF4E22A6586F089155734364452AB608391
          B56BE4E8BE06B1931395CFDCA856AB987E6AC549A50B435A0BC2F104084510FD
          A2B9EC4AE6D3B739B36DB14124E865DC9E71C21389C31F4DE2FA2C8341AD15A1
          5802DD3216671F2E98B5F326513CFDF17B53730E2943E85204EA105C93063516
          944A2544532B303998D59BA39281CD7C71AB49AC51EBE89F7D0FF51A97350E5C
          D23A7143AE77DD9B540FAFAE6FA265E2C8D4731C9533F5B1D4CE6ADD3E404771
          FA91D1E37AE50F31BE50BA39910A61DAE14320F61EC7657610937E7452416E9E
          1E3C98B56C65F3C5F25DA9FA02AF4F6AAE1EE35EFF871B27A43618EC1E64F305
          BC08276064C348AD6D2099CE9425BA9981F33A72178F14521DCD3CEEB8735FB2
          4748EB46CC4E776289F516B506936D4834D623A06FEDE681B7ED27D8F6303F19
          1FBB250000000049454E44AE426082}
        ShowHint = True
      end
      object lbl1: TLabel
        Left = 9
        Top = 173
        Width = 15
        Height = 13
        Margins.Left = 12
        Margins.Top = 12
        Margins.Right = 12
        Margins.Bottom = 12
        AutoSize = False
        Caption = '1:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object lbl2: TLabel
        Left = 9
        Top = 194
        Width = 15
        Height = 13
        Margins.Left = 12
        Margins.Top = 12
        Margins.Right = 12
        Margins.Bottom = 12
        AutoSize = False
        Caption = '2:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object lbl3: TLabel
        Left = 9
        Top = 214
        Width = 15
        Height = 13
        Margins.Left = 12
        Margins.Top = 12
        Margins.Right = 12
        Margins.Bottom = 12
        AutoSize = False
        Caption = '3:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object lbl4: TLabel
        Left = 9
        Top = 234
        Width = 15
        Height = 13
        Margins.Left = 12
        Margins.Top = 12
        Margins.Right = 12
        Margins.Bottom = 12
        AutoSize = False
        Caption = '4:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object lnkFile1: TLabel
        Left = 30
        Top = 173
        Width = 80
        Height = 13
        Hint = 'Open this file'
        Margins.Left = 12
        Margins.Top = 12
        Margins.Right = 12
        Margins.Bottom = 12
        Caption = 'Filename 1.tdf'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = 16744448
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        OnClick = lnkFile1Click
      end
      object lnkFile2: TLabel
        Left = 30
        Top = 194
        Width = 31
        Height = 13
        Hint = 'Open this file'
        Margins.Left = 12
        Margins.Top = 12
        Margins.Right = 12
        Margins.Bottom = 12
        Caption = 'File 2'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = 16744448
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        OnClick = lnkFile2Click
      end
      object lnkFile3: TLabel
        Left = 30
        Top = 214
        Width = 31
        Height = 13
        Hint = 'Open this file'
        Margins.Left = 12
        Margins.Top = 12
        Margins.Right = 12
        Margins.Bottom = 12
        Caption = 'File 3'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = 16744448
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        OnClick = lnkFile3Click
      end
      object lnkFile4: TLabel
        Left = 30
        Top = 235
        Width = 31
        Height = 13
        Hint = 'Open this file'
        Margins.Left = 12
        Margins.Top = 12
        Margins.Right = 12
        Margins.Bottom = 12
        Caption = 'File 4'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = 16744448
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        OnClick = lnkFile4Click
      end
      object lnkFileRecent: TLabel
        Left = 30
        Top = 145
        Width = 78
        Height = 16
        Hint = 'Open an existing TradeLog file'
        Margins.Left = 12
        Margins.Top = 12
        Margins.Right = 12
        Margins.Bottom = 12
        Caption = 'Recent Files:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clDefault
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
      end
    end
    object pnlSupt: TPanel
      Left = 310
      Top = 0
      Width = 320
      Height = 268
      Align = alRight
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 3
      object lnkGuide: TLabel
        Left = 56
        Top = 70
        Width = 217
        Height = 15
        Cursor = crHelp
        Hint = 'View Quick Start Guide'
        Margins.Left = 12
        Margins.Top = 12
        Margins.Right = 12
        Margins.Bottom = 12
        Caption = 'Guide: Using TradeLog Each Year'
        Font.Charset = ANSI_CHARSET
        Font.Color = 16744448
        Font.Height = -12
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        OnClick = lnkGuideClick
      end
      object lnkWatch: TLabel
        Left = 56
        Top = 123
        Width = 181
        Height = 15
        Hint = 'View online video tutorials'
        Margins.Left = 12
        Margins.Top = 12
        Margins.Right = 12
        Margins.Bottom = 12
        Caption = 'Watch How to Use TradeLog'
        Font.Charset = ANSI_CHARSET
        Font.Color = 16744448
        Font.Height = -12
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        OnClick = lnkWatchClick
      end
      object lnkTradeLogCom: TLabel
        Left = 56
        Top = 220
        Width = 126
        Height = 15
        Hint = 'Go to our TradeLog blog'
        Margins.Left = 12
        Margins.Top = 12
        Margins.Right = 12
        Margins.Bottom = 12
        Caption = 'www.TradeLog.com'
        Font.Charset = ANSI_CHARSET
        Font.Color = 16744448
        Font.Height = -12
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        OnClick = lnkTradeLogComClick
      end
      object lnkSupport: TLabel
        Left = 56
        Top = 168
        Width = 142
        Height = 15
        Hint = 'Go to our online support center'
        Margins.Left = 12
        Margins.Top = 12
        Margins.Right = 12
        Margins.Bottom = 12
        Caption = 'Online Support Center'
        Font.Charset = ANSI_CHARSET
        Font.Color = 16744448
        Font.Height = -12
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        OnClick = lnkSupportClick
      end
      object imgGuide: TImage
        Left = 6
        Top = 68
        Width = 35
        Height = 33
        Picture.Data = {
          0B546478504E47496D61676589504E470D0A1A0A0000000D4948445200000020
          0000001E08060000004D0A1C290000000467414D410000B18F0BFC6105000000
          206348524D00007A26000080840000FA00000080E8000075300000EA6000003A
          98000017709CBA513C0000000970485973000002C5000002C50189D67FEF0000
          000774494D4507E5080E011F0B01B8A142000002A4494441545847ED97CF6B13
          4114C773552BA255236A958815DA34BB9BC61F7F8008564129FEE8412FA23D08
          8207C183072988548DDD243BBB15AB159116AD42438982F8E3A8204A75939DD9
          8D4D0894FC30A90A1EDA0651C799641AE22624696FC27EE165E1CD9BF73E2F73
          79CFD6885C83E1D53C403D2DD7D4B3F62BAA83B9972CB734B5CE2DC1A31D32DA
          C75C95722AB0C905C25D821216DBFD107A141D5F7A91C4E742D3B9363F1ADAD0
          1F3EB6597CBB8C85D755215F207A4000BA5700304E1AC23C804FD971519E00DC
          429CA704599FE06594E2241D7340C7ADA2862900CCCE63AAD8B73CBEFFF12B3E
          3116CF740E44824DC3C6F195A1F45A96A6A40E25D22204D019418613A4688A27
          B98A8517BE68DC26F8B55D1E71F202F94B5E7300FD6407FFD80E0240BFEF93B3
          058072C5BFE7F19D7739DC3B1AFFE118893D687E18EB16BC5AAF00D04B72274F
          EF91AE2B7216FCB2FEC4C62B46D0A518550316AC1640B9125FE6705F681AB791
          58670056E4315B1100A0A0F9C06C8D02507DCACCE14EF25CF4D9CC79CC5600A0
          3FD50ECB6D310034A6FC4E2DB3002C000BC002B0002C000BC002F87F00E87845
          C72C3A6ED5D3620088051B0270FA2126BB01BEFC2A85A333F3F8D7EF3FAC5CA5
          1A03280DACB500E8280DC95E00736EC5784446F6D35B6F6847B60F6872F7683C
          21BEC9E2C9F42C36B3D4022039302FC1199784C638609CE764B8874EC5E3E640
          5238C3016DC8237D3EB85BD69BD99E5192DDABAE587555DDDBEA83C387476269
          1F8151D9F3D0E5852E31F4D968414E226F0D509A0FE8F7DC83C621E75DB886A5
          298A74F8AC5054D6A7F800BAEE02D12E8E1460C775B5B1EFC3F24D644D7388DA
          ED938F13D98BCF9378E7A08EDB7D28E29623373945DD4FD732165E29BA20D245
          91BBA5AE67AE25CBDE1FDE461758D2508F5334755A5536DB5FDC29BBCEE79052
          B20000000049454E44AE426082}
      end
      object imgWatch: TImage
        Left = 6
        Top = 123
        Width = 35
        Height = 26
        Picture.Data = {
          0B546478504E47496D61676589504E470D0A1A0A0000000D4948445200000020
          0000001C080600000000C2BD220000000467414D410000B18F0BFC6105000000
          206348524D00007A26000080840000FA00000080E8000075300000EA6000003A
          98000017709CBA513C0000000774494D4507E5080E011F2DD3B524BF000001D3
          49444154484BD597BF4BC34014C78383B8AA8B0882A3509BA68B0AFE981404FF
          0DA988FF4417873A74482EAEFE01FE038EEE228A72973A48B70E1D4AC15014B1
          F17D9377128AB69668AF7DF09AF7B977EFDD4BAE77B958B65067054FDD9286A4
          2DB6710537985F1296CF052FB8675F687B4A4135273EF489193188450E706F6E
          D8158B7ED021227DE5ABD634BFF530EC418C98346B3BCD0D14D0055824CB17F5
          19D8B9B29C063B42ED691FC411C129718BD1A2BBBF863222570B7D18C11172C0
          464E30C6D03ED22E8C26A0E8AA5D0A2EC1A66939E4C1AB60C7550709CB2BE20F
          D8310B55877E31F9D027668A412C72809133CE4563602CF6357117370C5A3B03
          38FD38DF59BFF341FBE6C2D878026D40D1AB2DE67CB9300AC5585C441B05C455
          615E46295C40070696446495A329F6FDBFD0585C40387905E4CF1F660BAE3CC2
          3C72D3F092A5005BC8750EC61A3FE1E6E1244B018E57DB4C060F2E718DB7625F
          6EB1FB7792A580BC503BBA7FDE7B5A21FB0E4CEF0137579573DCADBF6429C076
          E536FAAFFA8F4BDC64F1AE874D28B47DB9CFCD3FCB4417607C0A8CFF096D576D
          70B09965B82682797AB51E1BDB88FE44C6AD00E3AF63B30792713892993D94D2
          8FF163B9F10F930A293E93B01C47FC69A62A9F6BC78468FD50851C0000000049
          454E44AE426082}
      end
      object imgSupport: TImage
        Left = 6
        Top = 168
        Width = 31
        Height = 35
        Picture.Data = {
          0B546478504E47496D61676589504E470D0A1A0A0000000D494844520000001E
          0000001E08060000003B30AEA20000000467414D410000B18F0BFC6105000000
          206348524D00007A26000080840000FA00000080E8000075300000EA6000003A
          98000017709CBA513C0000000970485973000002C5000002C50189D67FEF0000
          000774494D4507E5080E01200B59668B7E000004B249444154484BA597DB6F1B
          5510878D100201AAA005AAC24B9486DCECBDD949DC466A452934F08210287D42
          42BCB4C0BFC033ADA2A6B17DF6AC9DA449532A2E5285E0012484507901D4A006
          525FCEEE3A4E2FA1491F286908484045C8F21BFBE46AC75E379F7492F59CDBEC
          9C3933B301BF2866BE5563E2B86EDA1F685C7CAB99F6A562A367669FA73E1A23
          876F1F256E1F54E3764AE3CE3C36F23453A0D1FF4D8DDB9E6A3AF3BA95B5C24C
          1C90D3EB2714CFEEC6DB7DAC737B49331D2F62653D83673D8D3979BCE177BA65
          7F4E8D9ED19F3778CE0B638CCA1C1AF32FDA87062B3C2997F38796CAF518A6F8
          05933D6C4E0BDE688CCD9C68494CBF14199A78580E5B453D957EA43936FD72E3
          E99913619EBB01B3E3ED05E6E6F1EC1C91C3AA13898B5E980CE6733019E663A2
          BF8BFFB84B76D7048A3DA170E7B4CA690D5220070B645F93DD95691D2A1C3112
          AB67784761F60BB2AB6E4283F68BBA2916682D03AD8D4D555EAB8B3BBB144BCC
          49E75934B8B35F765524CA0A3BD454FA29F9B322B486CEC41FB43994980D8E88
          9DB26B8D30732EA89C4C637BC1847B488ACBD053D9E714E67E85C5FEA405D1C6
          35CB392EBBCBC09A87694D83E53C35E97C22C525A2ECFA3E056701AD3C8539A6
          1497B1EFD4445435DDBF43892CC6E56EE10AB9C5CDE92A25ECF7E4B032824937
          494788CD979B47AE754931BC98B9E749AB4E9E998BB2F11D52BC0138CD034A12
          57094ED7959A7EBF89151E24B961E65EA78D498110CBEE2D0EDE44436CF23125
          9EB9653052323F5614B625EC6715532C76F08CD73070F364515801C3749F8687
          FF857B7D5B8A56C1A69F95CCEEBE214565740FDFEC0BC252D87CA19B15F66292
          789B34EE4A5EF9674FFFAF07E5B8327A2F78F7EB31A7411BC83F2345ABC00A5F
          1A713825778F4A511987476F1F6A8B5FB94B0AEA09E7184D3AAB93094CA7B062
          BE7AD87DE9B728E62E75F2F4EFD5EE7BC3D8F587742EA669631CEB48007FBEA1
          E844A14F8EA90BA32F374967D714BFFAAE146D092CFB43E948ECAF0338B389D2
          0FF1A9ECF78DD63FC1903CBC7032FD8514554591BE8097BD4C8EF1D3BD6C7CE0
          EC7C4F4B224DB17CBE56205961C3C6F7646ACFBB2F6C152E6B080AEDA6DB2BA5
          3541EEFEBEF4923035EC3E5ADCB80EE70A5AE2510410BC2D1241AADCCB2BB1C1
          B978EE0C429AFD8E9FEBB41E5210673B88D4F711C56C29AE4AD9750A0E882684
          CAC588553D806C97EEE11904900C2CEB2E74C6A61A8B421CFA39CAC11DD6D621
          733D3A42A096B0FB703C2C12B3F748F196AC844C3A1A838B51290E04DAE35351
          541CCBB592C40A3073B374120F49BF6AFA24DA936E8A9284CADC6563F0E70E29
          2EE1372D12F49670C871B44952428A2BB23E2D8636A745A2B55408C01CFE0A01
          3F6C2C04ECB98A8500D172C67D1E03512116CD7887B4955D75B356FAE05C4DFB
          6E2D2BC271EC5765F9536C21D38E77FB8C4C048D55789E51B147D6A304A49AE9
          57647775A0658F6EBA57A942A4C9612E66A974AD59DE0ECC9C44293C0BABE1AE
          C25193EE74ABE5B3BC5D61FF80D8892B760E49E43FD29EEEB9DF821EF396E074
          634A32F3B85CAE7E8CFE297CC288D2274CB1C4593B860D8DEA2E7CC284CDACA5
          26B7F109B399C850BE356C4EBD85403F04252E62B3C952732EE2BA0CEBDC7933
          E2FBA32D10F81F8DE84FAB7B8F5F8D0000000049454E44AE426082}
      end
      object imgTradeLogCom: TImage
        Left = 4
        Top = 220
        Width = 33
        Height = 27
        Picture.Data = {
          0B546478504E47496D61676589504E470D0A1A0A0000000D494844520000001E
          0000001D0806000000BDA4DC0C0000000467414D410000B18F0BFC6105000000
          206348524D00007A26000080840000FA00000080E8000075300000EA6000003A
          98000017709CBA513C0000000774494D4507E5080E012118C4C3FBE1000003C3
          49444154484BBD96EF4F5B5518C79F4C89C6209890B830A70B317109D01FC0DC
          8CC6177BB37F015F9938B715055E2CF18569A15C02F1DD327BDBE2089A68BACD
          1F61C6187F614208E22B334318DC73DA742BCC4158D06CEA3AD6EC47CFBECFE9
          A1E567B7C2D8937C72EF39E7E9F3B9F7DC73CF2DB9ED89DD9EB03807D28F8973
          9E4F122F903B2C7AD15020F310F00F6F6C929B806B284F44F4104EEE80DFE831
          85372C46D9C9625C8533C89D3CED0DF6944767201A6CA7B6DE9E7CD934C9638B
          AF913F0FEE964802C2F7750DB8D0CEB0388D5BFF2CD7A993140B9B4E8A6A3E67
          96E4B9B61C7647C45BA560EA7CC935DCB6F80EE7E99C382C3E2D1466F194C72C
          3ADD767F1CDF6BC6B37CC5DE907C3D4F7415CBC70CF8DD5DDCF159AEB142CC0D
          DD1912F59E50FC209F7378C3F1375C21D9649AC8757E41FE225028A45CB65075
          21B100660DFF63B1EA8B5DC5823BEC7CC035968B33FCEC74E5CD444034EF08CA
          76863A9D374DEF8601DF57EC24AF2D26B43C2CAE3E043320C53445440A779C2A
          B3A4A200F04B55D98BC7141529CC86CE5989BC8223D7C8B093AF20693A634C63
          683256D3371BDBD9FF4F6CE7A9F5A906AE53A9582D72CBBAE2D7A913E20EA9CA
          7B45D21B15B17DC065EAAD45BB922CBEED89C8D366264A8F0EE73C0521663AE5
          09D3BB61B08B9D2CCE2FAE4D454F669CAC058813C0D16F47B15877552F853A4C
          BBD4313AA08E525D31065B0FD6350646937BFD3FA9B2E0A4222BB145F1311A00
          EA0164D5111CC1355F857A29300CF1C216C53EFA761DD15A8E82C300F29AC0AF
          10FFBD45710B1D47E13FC010F81982111C6F69590E89BE1FC0D058DB6B3706DB
          0FA9E73B7E87F8CAD6C4AB0377F52C643379B18F5ACC1051F7BF17A8EB121656
          1CE4B6DE62519AB89D2A56888FD07B6688C8BA78818249238E3F62712B554178
          392F7E97DACC10E12E27F3EF7150F499DE0DE3118A6541DC25BF206BFA69B2CE
          3F4396539E63FC39DD36D114DD0E7150FE07A6800409430A3BDA90C9266CA725
          88DF2E22EE94337AAF2ECEA2C9A6FDCBC4B7F1AD3C63FA370CACEC4B5ACAEFEE
          3BD46CBAE989AEF8C09396182B4659507E6ED2A921E29C61278B6F8139B7EDF8
          57D3684FF8ABFA6FFA0F9D1CE94DFBCAAFEB9D0A1BC6371F367FBFA7FF2A72A4
          DF653BDDF83CF614C7E9F6461C3F833F0A73EC8458DA389905F85BB3969ABEB9
          EC2BD1E9EC7C5B354FB11677F47CA49E1AC8665F0D4F641B226211A41FC022BE
          D14B35E192B69980E2615B5605A4B9F718F2BF5A5E2CBCC7DB191056629AE7B5
          D8A79F7161716D6798553D0DEE195ACDD0F606449558CD3FE2F8A7C65758D59B
          0BA2FB26BD9CA5B88C6C5E0000000049454E44AE426082}
      end
      object lblGuide: TLabel
        Left = 56
        Top = 85
        Width = 217
        Height = 16
        Caption = 'Follow these eight steps for success!'
      end
      object lblWatch: TLabel
        Left = 56
        Top = 139
        Width = 163
        Height = 16
        Caption = 'Step-by-step video tutorials'
      end
      object lblSupport: TLabel
        Left = 56
        Top = 185
        Width = 222
        Height = 16
        Caption = 'All the help you need using TradeLog'
      end
      object txtWelcome: TLabel
        AlignWithMargins = True
        Left = 4
        Top = 28
        Width = 130
        Height = 29
        Margins.Left = 0
        Margins.Top = 10
        Margins.Right = 0
        Margins.Bottom = 0
        BiDiMode = bdLeftToRight
        Caption = 'WELCOME'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = 4858714
        Font.Height = -24
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentBiDiMode = False
        ParentColor = False
        ParentFont = False
        Layout = tlCenter
      end
      object lblTradeLogCom: TLabel
        Left = 56
        Top = 237
        Width = 165
        Height = 16
        Caption = 'Education. Services. More...'
      end
    end
  end
end
