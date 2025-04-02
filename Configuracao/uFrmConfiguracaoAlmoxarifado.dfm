inherited FrmConfiguracaoAlmoxarifado: TFrmConfiguracaoAlmoxarifado
  Left = 506
  Top = 174
  Width = 540
  Height = 446
  Caption = 'Configura'#231#227'o de Almoxarifado Intermediario'
  OldCreateOrder = True
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlPrincipal: TPanel
    Width = 524
    Height = 373
    object Label1: TLabel
      Left = 24
      Top = 27
      Width = 44
      Height = 13
      Caption = 'Empresa:'
    end
    object Label2: TLabel
      Left = 24
      Top = 51
      Width = 126
      Height = 13
      Caption = 'Almoxarifado Intermediario:'
    end
    object Label3: TLabel
      Left = 24
      Top = 74
      Width = 106
      Height = 13
      Caption = 'Almoxarifado Principal:'
    end
    object spnInserir: TSpeedButton
      Left = 354
      Top = 150
      Width = 73
      Height = 22
      Caption = 'Inserir'
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        1800000000000003000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        000000000000000000000000000000000000000000000000006F431EDF7B37E2
        813CE58841E68C41000000000000000000000000000000000000000000000000
        0000000000000000006F421CDE7A37E2803BE58740E58B400000000000000000
        000000000000000000000000000000000000000000000000006E421CDD7835E1
        7E3AE4853FE48A3F000000000000000000000000000000000000000000000000
        0000000000000000006E421BDC7634DF7C38E2823DE3883D0000000000000000
        000000000000000000000000000000000000000000000000006E421ADB7332DE
        7936E17E3AE1853B000000000000000000000000000000000000D2783CD6783A
        D46F2CD5702CD7742EDC7B31DA7030DC7534DF7B37E3853BE3873BE48A3DE68C
        3FE78D41E78E41000000D3703FD46C36D56E37D56A31D36426D6682AD86D2DDA
        7231DC7634DF7B37E17E3AE2823DE4843FE58740E58841000000D37040D36A35
        D46D37D66F37D77139D76E33D6692BD86D2EDA7231DC7533DE7936DF7C38E07E
        3AE1803BE2813C000000D37140D36A36D36B36D56D37D66F38D77239D9743ADA
        773BDC793DDC793BDD7A3BDE7C3CDF7E3DE08141E183430000006743306B4631
        6B452E6B452B6B4428A66B3BD77239D9733AD9763BDE833E6E441E6F441F6F45
        1F6F44206F45210000000000000000000000000000000000006B4428D66F38D7
        7139D87339D87C3B000000000000000000000000000000000000000000000000
        0000000000000000006B452BD56D37D66F37D77039D7793B0000000000000000
        000000000000000000000000000000000000000000000000006B452ED36B36D4
        6D37D56E37D5783A000000000000000000000000000000000000000000000000
        0000000000000000006B4631D36936D36A35D46C36D476390000000000000000
        00000000000000000000000000000000000000000000000000674331D37140D3
        7040D3703FD1773C000000000000000000000000000000000000}
      OnClick = spnInserirClick
    end
    object SpnExcluir: TSpeedButton
      Left = 440
      Top = 150
      Width = 73
      Height = 22
      Caption = 'Excluir'
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        1800000000000003000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000003030900000000000000000000000000
        000000000000000000000000000014143D000000000000000000000000030309
        8C8CF57C7CE90000000000000000000000000000000000000000001E1E508F8F
        F74848A40000000000000000007979E88F8FF78F8FF77C7CE900000000000000
        00000000000000001E1E508F8FF78F8FF78F8FF714143D000000000000000000
        7B7BE98F8FF78F8FF77C7CE90000000000000000001E1E508F8FF78F8FF78F8F
        F71E1E500000000000000000000000000000007B7BE98F8FF78F8FF77C7CE900
        00001E1E508F8FF78F8FF78F8FF71E1E50000000000000000000000000000000
        0000000000007B7BE98F8FF78F8FF77C7CE98F8FF78F8FF78F8FF71E1E500000
        000000000000000000000000000000000000000000000000007B7BE98F8FF78F
        8FF78F8FF78F8FF71E1E50000000000000000000000000000000000000000000
        0000000000000000001E1E508F8FF78F8FF78F8FF77C7CE90000000000000000
        000000000000000000000000000000000000000000001E1E508F8FF78F8FF78F
        8FF78F8FF78F8FF77C7CE9000000000000000000000000000000000000000000
        0000001E1E508F8FF78F8FF78F8FF71E1E507B7BE98F8FF78F8FF77C7CE90000
        000000000000000000000000000000001E1E508F8FF78F8FF78F8FF71E1E5000
        00000000007B7BE98F8FF78F8FF77C7CE90000000000000000000000001E1E50
        8F8FF78F8FF78F8FF71E1E500000000000000000000000007B7BE98F8FF78F8F
        F77C7CE90000000000000000004848A48F8FF78F8FF71E1E5000000000000000
        00000000000000000000007B7BE98F8FF78C8CF5030309000000000000000000
        4848A41E1E500000000000000000000000000000000000000000000000007979
        E803030900000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000}
      OnClick = SpnExcluirClick
    end
    object Label4: TLabel
      Left = 24
      Top = 98
      Width = 112
      Height = 13
      Caption = 'Almoxarifado Diferen'#231'a:'
    end
    object Label5: TLabel
      Left = 24
      Top = 124
      Width = 73
      Height = 13
      Caption = 'Movimenta'#231#227'o:'
    end
    object DBGrid1: TDBGrid
      Left = 24
      Top = 183
      Width = 489
      Height = 184
      DataSource = dsCadastro
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      OnTitleClick = DBGrid1TitleClick
      Columns = <
        item
          Expanded = False
          FieldName = 'sequencia'
          Visible = False
        end
        item
          Expanded = False
          FieldName = 'cod_empresa'
          Width = 50
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ind_tipo'
          Visible = False
        end
        item
          Expanded = False
          FieldName = 'movimentacao'
          Width = 80
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'cod_almoxarifado_intermediario'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'des_almoxarifado_intermediario'
          Width = 150
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'cod_almoxarifado_final'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'des_almoxarifado_final'
          Width = 150
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'cod_almoxarifado_diferenca'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'des_almoxarifado_diferenca'
          Width = 150
          Visible = True
        end>
    end
    object cbbEmpresa: TDBLookupComboBox
      Left = 154
      Top = 23
      Width = 359
      Height = 21
      KeyField = 'cod_empresa'
      ListField = 'empresa'
      ListSource = dsEmpresa
      TabOrder = 1
    end
    object cbbAlmoxInt: TDBLookupComboBox
      Left = 154
      Top = 48
      Width = 359
      Height = 21
      KeyField = 'cod_almoxarifado'
      ListField = 'almoxarifado'
      ListSource = dsAlmoxInt
      TabOrder = 2
    end
    object cbbAlmoxPri: TDBLookupComboBox
      Left = 154
      Top = 73
      Width = 359
      Height = 21
      KeyField = 'cod_almoxarifado'
      ListField = 'almoxarifado'
      ListSource = dsAlmoxPri
      TabOrder = 3
    end
    object cbbAlmoxDiferenca: TDBLookupComboBox
      Left = 154
      Top = 97
      Width = 359
      Height = 21
      KeyField = 'cod_almoxarifado'
      ListField = 'almoxarifado'
      ListSource = dsAlmoxDiferenca
      TabOrder = 4
    end
    object cbbMovimentacao: TComboBox
      Left = 154
      Top = 121
      Width = 359
      Height = 21
      ItemHeight = 13
      TabOrder = 5
      Items.Strings = (
        'Ambas'
        'Entrada'
        'Devolu'#231#227'o')
    end
  end
  inherited pnlBotoes: TPanel
    Top = 373
    Width = 524
    Height = 35
    object spdGravar: TSpeedButton
      Left = 356
      Top = 4
      Width = 71
      Height = 22
      Caption = 'Gravar'
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        1800000000000003000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        00000000000000000000000000D6AC00DDBA00E3C600E9D200EFDE00F4E800F7
        EF00F6EC00F1E300ECD800E6CC00E0C000DBB400624D000000004D3C00D8AF00
        DFC130F9F5E7F9F5E7F9F5E7F9F5E7F9F5E7F9F5E7F9F5E7F9F5E7F9F5E7F5EF
        D8DBB500D5A8000000004F3D00D8AE00EEDC7FFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDBB500D5A8000000004E3C00D6AB00
        EDDA7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFDAB200D4A5000000004E3B00D4A700ECD87FFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD7AD00D2A1000000004D3900D2A100
        EAD47FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFD4A700CF9C000000004B3600CE9A00E8D07FFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD19F00CC95000000004A3300CA9200
        E6CC7EFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFCC9600C88D00000000483000C68900CA9100CD9800D09E00D2A300D4A600D5
        A700D4A700D3A500D1A100CF9B00CC9500C88D00C48400000000472D00C17F00
        C58600C88D00C89300CA9700CB9900CB9A00CB9A00CA9800C99500C89100C68A
        00C38300BF7B00000000452900BC7500C07C00C28200E5E1DEEEECEAE8E5E2DC
        D7D2CCC5BEBBB1A7A89B8EB18828C17F00BE7800BA7100000000432500B76A00
        BA7100BD7600DBD7D2E8E5E2EEECEAE5E2DED7D2CC956E12AD9D80B58A2DBC74
        00B96E00533E00000000432400B36100B56500B76A00D1CBC4E0DBD7EBE9E6EC
        EAE7E1DDD9A7800BBBAC8CB88B32B668004D3A000000000000001B1500B36100
        B36100B36100C5BDB5D6D0CAE3E0DCEEEBE9EAE7E4D0C08ECCC3B2BB8D364534
        00000000000000000000000000171300453A00453A0046423E4C4A4752504E57
        5654595857555453504E4C2D2915000000000000000000000000}
      OnClick = spdGravarClick
    end
    object spnCancelar: TSpeedButton
      Left = 440
      Top = 4
      Width = 73
      Height = 22
      Caption = 'Cancelar'
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        1800000000000003000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000001011404043204043204043204043204043204
        04320404320404320404320404320404320404320000000000000000001112C7
        1314DF1314DF1314DF1314DF1314DF1314DF1314DF1314DF1314DF1314DF1314
        DF1314DF0404320000000000001112C61314DD1314DD1314DD1314DC1314DC13
        14DC1314DC1314DC1314DC1314DC1314DC1314DC0404330000000000001011C4
        1213D91213D9C2C3F54A4BE21213D91213D91213D81213D8F3F4FD1B1CDA1213
        D81213D80404330000000000001011C11213D54142DAFFFFFFFFFFFF4A4BDF12
        13D51213D5F3F3FDFFFFFFF3F3FA1213D41213D40404330000000000001011BF
        1213D21213D24848B5FFFFFFFFFFFF4A4BDCF3F4FCFFFFFFF3F3FA1011C51213
        D11213D10404330000000000001011BC1213CE1213CE1112CE4848B5FFFFFFFF
        FFFFFFFFFFF3F3FA1011C21112CD1112CD1112CD0404330000000000000F10BA
        1112CA1112CA1112CA1112CAF3F3FAFFFFFFFFFFFF4949CD1112CA1112CA1112
        C91112C90404330000000000000F10B81112C71112C71112C6F3F4FCFFFFFFF3
        F3FAFFFFFFFFFFFF494AD41112C61112C61112C60404330000000000000F10B5
        1112C31112C3F3F4FCFFFFFFF3F3FA1011BA4748B4FFFFFFFFFFFF494AD11011
        C21011C20404330000000000000E0FB31011BF191ABAFFFFFFF3F3FA0F10B710
        11BF1011BF4748B3FFFFFFC1C1E51011BE1011BE0404330000000000000E0FB0
        1011BC1011BC1718A70F10B41011BB1011BB1011BB1011BB3D3EAF0F10BA1011
        BB1011BB0404330000000000000E0FAE1011B81011B81011B81011B81011B810
        11B71011B71011B71011B71011B71011B71011B70404330000000000000C0C9A
        0E0FAB0E0FAB0E0FAB0E0FAB0E0FAB0E0FAB0E0FAB0E0FAB0E0FAB0E0FAB0E0F
        AB0E0FAA01011400000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000}
      OnClick = spnCancelarClick
    end
  end
  object cdsEmpresa: TClientDataSet
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'cod_empresa'
        DataType = ftInteger
      end
      item
        Name = 'nom_empresa'
        DataType = ftString
        Size = 60
      end
      item
        Name = 'empresa'
        DataType = ftString
        Size = 100
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 536
    Top = 136
    Data = {
      6A0000009619E0BD0100000018000000030000000000030000006A000B636F64
      5F656D707265736104000100000000000B6E6F6D5F656D707265736101004900
      00000100055749445448020002003C0007656D70726573610100490000000100
      0557494454480200020064000000}
    object cdsEmpresacod_empresa: TIntegerField
      FieldName = 'cod_empresa'
    end
    object cdsEmpresanom_empresa: TStringField
      FieldName = 'nom_empresa'
      Size = 60
    end
    object cdsEmpresaempresa: TStringField
      FieldName = 'empresa'
      Size = 100
    end
  end
  object dsEmpresa: TDataSource
    DataSet = cdsEmpresa
    OnDataChange = dsEmpresaDataChange
    Left = 568
    Top = 136
  end
  object cdsAlmoxInt: TClientDataSet
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'cod_almoxarifado'
        DataType = ftInteger
      end
      item
        Name = 'des_almoxarifado'
        DataType = ftString
        Size = 60
      end
      item
        Name = 'almoxarifado'
        DataType = ftString
        Size = 100
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 536
    Top = 168
    Data = {
      790000009619E0BD010000001800000003000000000003000000790010636F64
      5F616C6D6F786172696661646F0400010000000000106465735F616C6D6F7861
      72696661646F0100490000000100055749445448020002003C000C616C6D6F78
      6172696661646F01004900000001000557494454480200020064000000}
    object cdsAlmoxIntcod_almoxarifado: TIntegerField
      FieldName = 'cod_almoxarifado'
    end
    object cdsAlmoxIntdes_almoxarifado: TStringField
      FieldName = 'des_almoxarifado'
      Size = 60
    end
    object cdsAlmoxIntalmoxarifado: TStringField
      FieldName = 'almoxarifado'
      Size = 100
    end
  end
  object dsAlmoxInt: TDataSource
    DataSet = cdsAlmoxInt
    Left = 568
    Top = 168
  end
  object cdsAlmoxPri: TClientDataSet
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'cod_almoxarifado'
        DataType = ftInteger
      end
      item
        Name = 'des_almoxarifado'
        DataType = ftString
        Size = 60
      end
      item
        Name = 'almoxarifado'
        DataType = ftString
        Size = 100
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 536
    Top = 200
    Data = {
      790000009619E0BD010000001800000003000000000003000000790010636F64
      5F616C6D6F786172696661646F0400010000000000106465735F616C6D6F7861
      72696661646F0100490000000100055749445448020002003C000C616C6D6F78
      6172696661646F01004900000001000557494454480200020064000000}
    object cdsAlmoxPricod_almoxarifado: TIntegerField
      FieldName = 'cod_almoxarifado'
    end
    object cdsAlmoxPrides_almoxarifado: TStringField
      FieldName = 'des_almoxarifado'
      Size = 60
    end
    object cdsAlmoxPrialmoxarifado: TStringField
      FieldName = 'almoxarifado'
      Size = 100
    end
  end
  object dsAlmoxPri: TDataSource
    DataSet = cdsAlmoxPri
    Left = 568
    Top = 200
  end
  object cdsCadastro: TClientDataSet
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'sequencia'
        DataType = ftInteger
      end
      item
        Name = 'cod_empresa'
        DataType = ftInteger
      end
      item
        Name = 'ind_tipo'
        DataType = ftString
        Size = 1
      end
      item
        Name = 'movimentacao'
        DataType = ftString
        Size = 60
      end
      item
        Name = 'cod_almoxarifado_intermediario'
        DataType = ftInteger
      end
      item
        Name = 'des_almoxarifado_intermediario'
        DataType = ftString
        Size = 60
      end
      item
        Name = 'cod_almoxarifado_final'
        DataType = ftInteger
      end
      item
        Name = 'des_almoxarifado_final'
        DataType = ftString
        Size = 60
      end
      item
        Name = 'cod_almoxarifado_diferenca'
        DataType = ftInteger
      end
      item
        Name = 'des_almoxarifado_diferenca'
        DataType = ftString
        Size = 60
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 539
    Top = 264
    Data = {
      740100009619E0BD01000000180000000A000000000003000000740109736571
      75656E63696104000100000000000B636F645F656D7072657361040001000000
      000008696E645F7469706F01004900000001000557494454480200020001000C
      6D6F76696D656E746163616F0100490000000100055749445448020002003C00
      1E636F645F616C6D6F786172696661646F5F696E7465726D6564696172696F04
      000100000000001E6465735F616C6D6F786172696661646F5F696E7465726D65
      64696172696F0100490000000100055749445448020002003C0016636F645F61
      6C6D6F786172696661646F5F66696E616C0400010000000000166465735F616C
      6D6F786172696661646F5F66696E616C01004900000001000557494454480200
      02003C001A636F645F616C6D6F786172696661646F5F6469666572656E636104
      000100000000001A6465735F616C6D6F786172696661646F5F6469666572656E
      63610100490000000100055749445448020002003C000000}
    object cdsCadastrosequencia: TIntegerField
      FieldName = 'sequencia'
    end
    object cdsCadastrocod_empresa: TIntegerField
      DisplayLabel = 'Empresa'
      FieldName = 'cod_empresa'
    end
    object cdsCadastroind_tipo: TStringField
      FieldName = 'ind_tipo'
      Size = 1
    end
    object cdsCadastromovimentacao: TStringField
      DisplayLabel = 'Movimenta'#231#227'o'
      FieldName = 'movimentacao'
      Size = 60
    end
    object cdsCadastrocod_almoxarifado_intermediario: TIntegerField
      DisplayLabel = 'Intermediario'
      FieldName = 'cod_almoxarifado_intermediario'
    end
    object cdsCadastrodes_almoxarifado_intermediario: TStringField
      DisplayLabel = 'Des. Intermediario'
      FieldName = 'des_almoxarifado_intermediario'
      Size = 60
    end
    object cdsCadastrocod_almoxarifado_final: TIntegerField
      DisplayLabel = 'Principal'
      FieldName = 'cod_almoxarifado_final'
    end
    object cdsCadastrodes_almoxarifado_final: TStringField
      DisplayLabel = 'Des. Principal'
      FieldName = 'des_almoxarifado_final'
      Size = 60
    end
    object cdsCadastrocod_almoxarifado_diferenca: TIntegerField
      DisplayLabel = 'Diferen'#231'a'
      FieldName = 'cod_almoxarifado_diferenca'
    end
    object cdsCadastrodes_almoxarifado_diferenca: TStringField
      DisplayLabel = 'Des. Diferen'#231'a'
      FieldName = 'des_almoxarifado_diferenca'
      Size = 60
    end
  end
  object dsCadastro: TDataSource
    DataSet = cdsCadastro
    Left = 571
    Top = 264
  end
  object cdsAlmoxDiferenca: TClientDataSet
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'cod_almoxarifado'
        DataType = ftInteger
      end
      item
        Name = 'des_almoxarifado'
        DataType = ftString
        Size = 60
      end
      item
        Name = 'almoxarifado'
        DataType = ftString
        Size = 100
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 536
    Top = 232
    Data = {
      790000009619E0BD010000001800000003000000000003000000790010636F64
      5F616C6D6F786172696661646F0400010000000000106465735F616C6D6F7861
      72696661646F0100490000000100055749445448020002003C000C616C6D6F78
      6172696661646F01004900000001000557494454480200020064000000}
    object cdsAlmoxDiferencacod_amoxarifado: TIntegerField
      FieldName = 'cod_almoxarifado'
    end
    object cdsAlmoxDiferencades_almoxarifado: TStringField
      FieldName = 'des_almoxarifado'
      Size = 60
    end
    object cdsAlmoxDiferencaalmoxarifado: TStringField
      FieldName = 'almoxarifado'
      Size = 100
    end
  end
  object dsAlmoxDiferenca: TDataSource
    DataSet = cdsAlmoxDiferenca
    Left = 568
    Top = 232
  end
end
