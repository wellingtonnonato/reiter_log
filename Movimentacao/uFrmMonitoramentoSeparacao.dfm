object FrmMonitoramentoSeparacao: TFrmMonitoramentoSeparacao
  Left = 340
  Top = 134
  Width = 800
  Height = 480
  Caption = 'Monitoramento da do Processo de Separa'#231#227'o'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnFiltro: TPanel
    Left = 0
    Top = 0
    Width = 784
    Height = 113
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object spnPesquisar: TSpeedButton
      Left = 424
      Top = 64
      Width = 89
      Height = 22
      Caption = 'Pesquisar'
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        1800000000000003000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000A49292E7D5D5
        E7D5D5E7D5D5E7D5D5E7D5D5E7D5D5E7D5D5E7D5D5E7D5D5E7D5D5E7D5D5E0CE
        CE8E8282080808010000DDC2C3FDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFD
        FDFDFDFDFDFDFDFDFDFDFDF5F5F5A4A4A41D1D1D9D9D9D171313DCC0C0FDFDFD
        FDFDFDFDFDFDFDFDFDFDFDFDFCFCFCF9F9F9F8F8F8FCFCFCF9F9F9AEAEAE3030
        30B8B8B8FDFDFD171313DABDBEFDFDFDFDFDFDFDFDFDFDFDFDF7F7F7D0D0D0CA
        CACAC9C9C9C6C6C6CBCBCB3F3F3FC5C5C5FDFDFDFDFDFD171313D9BBBCFAFAFA
        FAFAFAFAFAFAF7F7F7CBCBCBF5F3F3FCFCFCFAF9F9F5F3F3A0A1A1EEEEEEFAFA
        FAFAFAFAFAFAFA171313D8B9B9F5F5F5F5F5F5F5F5F5DFDFDFF0EDEDF5F3F3F7
        F6F6F6F5F5F3F0F0EFEBEBD6D6D6F5F5F5F5F5F5F5F5F5171313D6B6B7F0F0F0
        F0F0F0F0F0F0D3D3D3EEEAEAF3F0F0F5F3F3F5F3F3F2EFEFECE8E8DCDCDCF0F0
        F0F0F0F0F0F0F0171313D4B3B4EBEBEBEBEBEBEBEBEBD1D1D1F5F4F4F6F4F4F7
        F5F5F7F5F5F6F4F4F4F3F3E3E3E3EBEBEBEBEBEBEBEBEB171212D2B0B1E7E7E7
        E7E7E7E7E7E7E5E5E5EFEEEEFAFAFAF9F8F8F9F8F8F7F6F6F1F0F0E5E5E5E7E7
        E7E7E7E7E7E7E7161111CFAAABE1E1E1E1E1E1E1E1E1E1E1E1CACACAF3F2F2F8
        F8F8F8F8F8F5F5F5D9D9D9E1E1E1E1E1E1E1E1E1E1E1E1161010DEC3C3E2CCCC
        E2CCCCE2CCCCE2CCCCE2CCCCE1CBCBC9BEBECBC0C0E1CBCBE2CCCCE2CCCCE2CC
        CCE2CCCCE2CCCC150F0FDEC3C3DDC0C0DDC0C0DDC0C0DDC0C0DDC0C0DDC0C0DD
        C0C0DDC0C0DDC0C0CDAAAABC9292C09595C29999DDC1C1150F0F100B0B312626
        3126263126263126263126263126263126263126263126263126263126263126
        2631262631262600000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000}
      OnClick = spnPesquisarClick
    end
    object Label1: TLabel
      Left = 11
      Top = 14
      Width = 44
      Height = 13
      Caption = 'Empresa:'
    end
    object Label2: TLabel
      Left = 11
      Top = 38
      Width = 35
      Height = 13
      Caption = 'Cliente:'
    end
    object Label4: TLabel
      Left = 11
      Top = 67
      Width = 33
      Height = 13
      Caption = 'Status:'
    end
    object spnRetornarStatus: TSpeedButton
      Left = 524
      Top = 64
      Width = 120
      Height = 22
      Caption = 'Retornar Status'
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        1800000000000003000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        00000000000000000000000000000E0302000000000000000000000000000000
        0000000000000000000000000000000000000000000000000100008A1B17BD24
        1F00000000000000000000000000000000000000000000000000000000000000
        0000000000470E0CBF241F100303BE241F000000000000000000000000000000
        000000000000000000000000000000140403BF251F470E0C000000000000BE24
        1F0000000000000000000000000000000000000000000000000100008A1B178B
        1B17010000000000000000000000BE241F000000000000000000000000000000
        000000000000470E0CBF241F130403000000000000000000000000000000BE24
        1F000000000000000000000000000000140403BF251F470E0C00000000000000
        0000000000000000000000000000BE241F000000000000000000000000010000
        AC211C671411000000000000000000000000000000000000000000000000BE24
        1F0000000000000000000000000000000000002B0807C7262128080700000000
        0000000000000000000000000000BE241F000000000000000000000000000000
        0000000000000000006C1512A8201B070101000000000000000000000000BE24
        1F000000000000000000000000000000000000000000000000000000070101AB
        211C671411000000000000000000BE241F000000000000000000000000000000
        0000000000000000000000000000000000002B0807C72621280807000000BE24
        1F00000000000000000000000000000000000000000000000000000000000000
        00000000000000006C1512A4201BBD241F000000000000000000000000000000
        000000000000000000000000000000000000000000000000000000070101901B
        1700000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000}
      OnClick = spnRetornarStatusClick
    end
    object spnLiberarEdicao: TSpeedButton
      Left = 656
      Top = 64
      Width = 120
      Height = 22
      Caption = 'Liberar p/ Editar'
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        1800000000000003000000000000000000000000000000000000000000000000
        0000000000000202021E1E1D24242313131025242425242410100F0000000000
        000000000000000000000000000000000000002221207A7956BABA65C5C568C7
        C769C5C568C1C167A4A4614E4E48010101000000000000000000000000000000
        0D0D0C8E8E5BCACA69C9C969CBCB69CBCB69CBCB69CACA69C9C969C9C9694746
        420000000000000000000000000000003B3B39CBCB69C9C969CBCB6959584F54
        534B55544CA5A561C9C969C9C9698F8E5B030303000000000000000000000000
        4D4C45CBCB69C9C969C9C969838359020201353432C9C969C9C969C9C969ABAB
        620909090000000000000000000000004D4C45CBCB69C9C969C9C96996955D18
        1816504F49CACA69C9C969C9C969ABAB62090909000000000000000000000000
        4D4C45CBCB69C9C969CBCB694E4D470000000D0D0CABAA62C9C969C9C969ABAB
        620909090000000000000000000000004D4C45CBCB69C9C969C9C96982825826
        2625434240C6C668C9C969C9C969ABAB62090909000000000000000000000000
        4D4C45CBCB69C9C969C9C969CACA69C2C267C9C969C9C969C9C969C9C969ABAB
        620909090000000000000000000000004D4C45CCCC6ACACA69CACA69CACA69C9
        C969CACA69CACA69CACA69CACA69ACAC62090909000000000000000000000000
        46454255544B55544B55544B55544B666638605F435A594D5A594F55544B5453
        4B0909090000000000000000000000000000000000001C1B1A2D2C2A0C0B0B00
        000000000060605D908F8D000000000000000000000000000000000000000000
        0000000000002D2D2AD6D6D513131200000000000060605D8F8F8C0000000000
        000000000000000000000000000000000000000000001E1E1CD4D4D43A393600
        00000909098B8A88696865000000000000000000000000000000000000000000
        0000000000000000005E5E5BD2D2D17B7A779D9C9ABABAB82524220000000000
        000000000000000000000000000000000000000000000000000303033D3D3A6A
        69665857541D1D1C000000000000000000000000000000000000}
      OnClick = spnLiberarEdicaoClick
    end
    object cbbEmpresa: TDBLookupComboBox
      Left = 71
      Top = 11
      Width = 342
      Height = 21
      KeyField = 'cod_empresa'
      ListField = 'empresa'
      ListSource = dsEmpresa
      TabOrder = 0
    end
    object cbbCliente: TDBLookupComboBox
      Left = 71
      Top = 35
      Width = 342
      Height = 21
      KeyField = 'cod_cliente'
      ListField = 'Cliente'
      ListSource = dsClientes
      TabOrder = 1
    end
    object GroupBox1: TGroupBox
      Left = 424
      Top = 5
      Width = 352
      Height = 51
      Caption = 'Per'#237'odo de Emiss'#227'o'
      TabOrder = 2
      object Label3: TLabel
        Left = 141
        Top = 22
        Width = 6
        Height = 13
        Caption = #224
      end
      object dtaIni: TDateTimePicker
        Left = 8
        Top = 19
        Width = 97
        Height = 21
        Date = 44065.720084305550000000
        Time = 44065.720084305550000000
        TabOrder = 0
      end
      object dtaFim: TDateTimePicker
        Left = 184
        Top = 19
        Width = 97
        Height = 21
        Date = 44065.720084305550000000
        Time = 44065.720084305550000000
        TabOrder = 1
      end
    end
    object cbbStatus: TComboBox
      Left = 71
      Top = 64
      Width = 342
      Height = 21
      ItemHeight = 13
      TabOrder = 3
      Text = 'Todos'
      Items.Strings = (
        'Todos'
        'Aguardando Envio'
        'Processando Envio'
        'Aguardando Retorno'
        'Processando Retorno'
        'Finalizado'
        'Liberado p/ Editar')
    end
    object chkPararAtualizacaoGrid: TCheckBox
      Left = 71
      Top = 88
      Width = 337
      Height = 17
      Caption = 'Parar a atualiza'#231#227'o automatica da Tela'
      TabOrder = 4
    end
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 113
    Width = 784
    Height = 329
    Align = alClient
    DataSource = dsSeparacao
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDrawColumnCell = DBGrid1DrawColumnCell
    OnDblClick = DBGrid1DblClick
    OnTitleClick = DBGrid1TitleClick
    Columns = <
      item
        Expanded = False
        FieldName = 'ind_selecao'
        Width = 30
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'seq_pre_venda'
        ReadOnly = True
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'num_pre_venda'
        ReadOnly = True
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'dta_emissao'
        ReadOnly = True
        Width = 80
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'nom_pessoa'
        ReadOnly = True
        Width = 210
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'num_cnpj_cpf'
        ReadOnly = True
        Width = 100
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'status'
        ReadOnly = True
        Width = 115
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'val_total_pre_venda'
        ReadOnly = True
        Visible = True
      end>
  end
  object dsEmpresa: TDataSource
    DataSet = cdsEmpresa
    Left = 128
    Top = 136
  end
  object cdsEmpresa: TClientDataSet
    Active = True
    Aggregates = <>
    Params = <>
    Left = 168
    Top = 136
    Data = {
      4A0000009619E0BD0100000018000000020000000000030000004A000B636F64
      5F656D7072657361040001000000000007656D70726573610100490000000100
      0557494454480200020064000000}
    object cdsEmpresacod_empresa: TIntegerField
      FieldName = 'cod_empresa'
    end
    object cdsEmpresaempresa: TStringField
      FieldName = 'empresa'
      Size = 100
    end
  end
  object dsSeparacao: TDataSource
    DataSet = cdsSeparacao
    OnDataChange = dsSeparacaoDataChange
    Left = 128
    Top = 216
  end
  object cdsSeparacao: TClientDataSet
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'ind_selecao'
        DataType = ftString
        Size = 1
      end
      item
        Name = 'seq_pre_venda'
        DataType = ftInteger
      end
      item
        Name = 'num_pre_venda'
        DataType = ftString
        Size = 12
      end
      item
        Name = 'dta_emissao'
        DataType = ftDateTime
      end
      item
        Name = 'nom_pessoa'
        DataType = ftString
        Size = 60
      end
      item
        Name = 'num_cnpj_cpf'
        DataType = ftString
        Size = 18
      end
      item
        Name = 'status'
        DataType = ftString
        Size = 60
      end
      item
        Name = 'val_total_pre_venda'
        DataType = ftFloat
      end
      item
        Name = 'ind_status'
        DataType = ftString
        Size = 2
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 160
    Top = 216
    Data = {
      1C0100009619E0BD0100000018000000090000000000030000001C010B696E64
      5F73656C6563616F01004900000001000557494454480200020001000D736571
      5F7072655F76656E646104000100000000000D6E756D5F7072655F76656E6461
      0100490000000100055749445448020002000C000B6474615F656D697373616F
      08000800000000000A6E6F6D5F706573736F6101004900000001000557494454
      48020002003C000C6E756D5F636E706A5F637066010049000000010005574944
      5448020002001200067374617475730100490000000100055749445448020002
      003C001376616C5F746F74616C5F7072655F76656E646108000400000000000A
      696E645F73746174757301004900000001000557494454480200020002000000}
    object cdsSeparacaoind_selecao: TStringField
      DisplayLabel = 'X'
      FieldName = 'ind_selecao'
      Size = 1
    end
    object cdsSeparacaoseq_pre_venda: TIntegerField
      DisplayLabel = 'Seq. Pr'#233' Venda'
      FieldName = 'seq_pre_venda'
    end
    object cdsSeparacaonum_pre_venda: TStringField
      DisplayLabel = 'Nro. Pr'#233' Venda'
      FieldName = 'num_pre_venda'
      Size = 12
    end
    object cdsSeparacaodta_emissao: TDateTimeField
      DisplayLabel = 'Dta. Emiss'#227'o'
      FieldName = 'dta_emissao'
    end
    object cdsSeparacaonom_pessoa: TStringField
      DisplayLabel = 'Cliente'
      FieldName = 'nom_pessoa'
      Size = 60
    end
    object cdsSeparacaonum_cnpj_cpf: TStringField
      DisplayLabel = 'CNPJ'
      FieldName = 'num_cnpj_cpf'
      Size = 18
    end
    object cdsSeparacaostatus: TStringField
      DisplayLabel = 'Status'
      FieldName = 'status'
      Size = 60
    end
    object cdsSeparacaoval_total_pre_venda: TFloatField
      DisplayLabel = 'R$ Total'
      FieldName = 'val_total_pre_venda'
      DisplayFormat = '#,##0.00'
    end
    object cdsSeparacaoind_status: TStringField
      FieldName = 'ind_status'
      Size = 2
    end
  end
  object TmSeparacao: TTimer
    Enabled = False
    OnTimer = TmSeparacaoTimer
    Left = 200
    Top = 216
  end
  object cdsCliente: TClientDataSet
    Active = True
    Aggregates = <>
    Params = <>
    Left = 152
    Top = 171
    Data = {
      4A0000009619E0BD0100000018000000020000000000030000004A000B636F64
      5F636C69656E7465040001000000000007436C69656E74650100490000000100
      0557494454480200020064000000}
    object cdsClientecod_cliente: TIntegerField
      FieldName = 'cod_cliente'
    end
    object cdsClienteCliente: TStringField
      FieldName = 'Cliente'
      Size = 100
    end
  end
  object dsClientes: TDataSource
    DataSet = cdsCliente
    Left = 120
    Top = 169
  end
end
