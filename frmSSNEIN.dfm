object dlgSSNEIN: TdlgSSNEIN
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Enter SSN/EIN'
  ClientHeight = 290
  ClientWidth = 263
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 8
    Top = 241
    Width = 112
    Height = 13
    Caption = 'Enter the Taxpayer ID:'
  end
  object Label4: TLabel
    Left = 8
    Top = 8
    Width = 200
    Height = 13
    Caption = 'Add Taxpayer ID on Final Reporting'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 8
    Top = 27
    Width = 225
    Height = 52
    Caption = 
      'TradeLog does not store your Taxpayer ID.'#13'Information entered is' +
      ' added to the report '#13'preview. You are responsible to secure rep' +
      'orts'#13'printed or saved if SSN/EIN is included.'
  end
  object lblMoreInfo: TLabel
    Left = 34
    Top = 86
    Width = 202
    Height = 26
    Caption = 
      'Click here to learn how we use and secure'#13'your private informati' +
      'on.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMenuHighlight
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    OnClick = lblMoreInfoClick
  end
  object Panel1: TPanel
    Left = 8
    Top = 125
    Width = 249
    Height = 108
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 9
      Width = 153
      Height = 13
      Caption = 'Select the type of Taxpayer ID:'
    end
    object RadioButton1: TRadioButton
      Left = 16
      Top = 33
      Width = 169
      Height = 17
      Caption = 'SSN (Social Security Number)'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = RadioButton1Click
    end
    object RadioButton2: TRadioButton
      Left = 16
      Top = 56
      Width = 201
      Height = 17
      Caption = 'EIN (Employer Identification Number)'
      TabOrder = 1
      OnClick = RadioButton2Click
    end
    object RadioButton3: TRadioButton
      Left = 16
      Top = 78
      Width = 113
      Height = 17
      Caption = 'Leave blank'
      TabOrder = 2
      OnClick = RadioButton3Click
    end
  end
  object MaskEdit1: TMaskEdit
    Left = 8
    Top = 260
    Width = 152
    Height = 21
    EditMask = 'aaa-aa-aaaa;'
    MaxLength = 11
    TabOrder = 1
    Text = '   -  -    '
  end
  object btnOK: TButton
    Left = 182
    Top = 258
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 2
    OnClick = btnOKClick
  end
  object cxImage1: TcxImage
    Left = 8
    Top = 88
    AutoSize = True
    Picture.Data = {
      0B546478504E47496D61676589504E470D0A1A0A0000000D4948445200000010
      0000001008060000001FF3FF610000000467414D410000B18F0BFC6105000001
      8749444154384F7D524D4B4241149D5F94D5DF88FA0511B588B28D2D7AEA3617
      2E14D322EC4309EDAD82D2D4858BC822092BC8BE40E9F55C146652062A7D9806
      AF77C6A7BD374E1D383033F79E3B73EF1CC2C3842B336809E4ED7321C92B846E
      17B01E771DF76BE1BF31BD74396017E598335169BA9355454F9CD936E5DD49EF
      05BF90D99F1D71EC941F5921CBF948A938B37A35ACC9DAC0CD3CF14AAA4EC99E
      A388E125825888B349278586725F695166E48621065AC542948A3130B6677FAA
      46859DFDC36B8B9EE9739CF1CAD7A8276D2298B03E006EA4EB4A5AFAECEEE5E7
      96B276D8DBCA6C3067254258F6B1013D63D977E5AEDCE4C684B0E4530B487F16
      58576F7DAA7E2B8B7BC6E777088F104B3067E305C1E4F5877290FF6D85A52590
      13081CC6330EB8BC5FA3E4C59C8997E698EFA88FFE041CC64BDA3A7BA3E4C5D4
      D945A8188029542315D9245AE0B4B78063BB549CF2644D9ABC0DD8130E639359
      426CF6DF0C69322350150E834958217AB68A72D4EC3E6FF7FD1F301C9804DF04
      62DD1D980184FC007F3473F3D8134DA20000000049454E44AE426082}
    TabOrder = 3
  end
end
