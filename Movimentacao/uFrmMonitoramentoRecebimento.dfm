object FrmMonitoramentoRecebimento: TFrmMonitoramentoRecebimento
  Left = 386
  Top = 194
  Width = 800
  Height = 500
  Caption = 'Monitoramento do Processo de Recebimento'
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
      Left = 425
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
      Width = 57
      Height = 13
      Caption = 'Fornecedor:'
    end
    object Label4: TLabel
      Left = 11
      Top = 67
      Width = 33
      Height = 13
      Caption = 'Status:'
    end
    object spnRetornarStatus: TSpeedButton
      Left = 522
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
    object spnExcluirRecebimento: TSpeedButton
      Left = 649
      Top = 64
      Width = 127
      Height = 22
      Caption = 'Excluir Recebimento'
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
      OnClick = spnExcluirRecebimentoClick
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
    object cbbFornecedor: TDBLookupComboBox
      Left = 71
      Top = 35
      Width = 342
      Height = 21
      KeyField = 'cod_fornecedor'
      ListField = 'fornecedor'
      ListSource = dsFornecedor
      TabOrder = 1
    end
    object GroupBox1: TGroupBox
      Left = 425
      Top = 5
      Width = 351
      Height = 51
      Caption = 'Per'#237'odo de Entrada'
      TabOrder = 2
      object Label3: TLabel
        Left = 110
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
        Left = 128
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
      ItemIndex = 0
      TabOrder = 3
      Text = 'Todos'
      Items.Strings = (
        'Todos'
        'Aguardando Envio'
        'Processando Envio'
        'Aguardando Retorno'
        'Processando Retorno'
        'Finalizado')
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
    Height = 349
    Align = alClient
    DataSource = dsRecebimento
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
        FieldName = 'num_nota'
        ReadOnly = True
        Width = 60
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'num_serie'
        ReadOnly = True
        Width = 30
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
        FieldName = 'dta_entrada'
        ReadOnly = True
        Width = 80
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'nom_pessoa'
        ReadOnly = True
        Width = 230
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'num_cnpj_cpf'
        ReadOnly = True
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'status'
        ReadOnly = True
        Width = 135
        Visible = True
      end>
  end
  object TmRecebimento: TTimer
    Enabled = False
    OnTimer = TmRecebimentoTimer
    Left = 200
    Top = 216
  end
  object cdsRecebimento: TClientDataSet
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'ind_selecao'
        DataType = ftString
        Size = 1
      end
      item
        Name = 'seq_recebimento'
        DataType = ftInteger
      end
      item
        Name = 'num_nota'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'num_serie'
        DataType = ftString
        Size = 3
      end
      item
        Name = 'dta_emissao'
        DataType = ftDateTime
      end
      item
        Name = 'dta_entrada'
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
      2F0100009619E0BD01000000180000000A0000000000030000002F010B696E64
      5F73656C6563616F01004900000001000557494454480200020001000F736571
      5F7265636562696D656E746F0400010000000000086E756D5F6E6F7461010049
      0000000100055749445448020002000A00096E756D5F73657269650100490000
      0001000557494454480200020003000B6474615F656D697373616F0800080000
      0000000B6474615F656E747261646108000800000000000A6E6F6D5F70657373
      6F610100490000000100055749445448020002003C000C6E756D5F636E706A5F
      6370660100490000000100055749445448020002001200067374617475730100
      490000000100055749445448020002003C000A696E645F737461747573010049
      00000001000557494454480200020002000000}
    object cdsRecebimentoind_selecao: TStringField
      DisplayLabel = 'X'
      FieldName = 'ind_selecao'
      Size = 1
    end
    object cdsRecebimentoseq_recebimento: TIntegerField
      FieldName = 'seq_recebimento'
    end
    object cdsRecebimentonum_nota: TStringField
      DisplayLabel = 'Nro. Nota'
      FieldName = 'num_nota'
      Size = 10
    end
    object cdsRecebimentonum_serie: TStringField
      DisplayLabel = 'Serie'
      FieldName = 'num_serie'
      Size = 3
    end
    object cdsRecebimentodta_emissao: TDateTimeField
      DisplayLabel = 'Dta. Emiss'#227'o'
      FieldName = 'dta_emissao'
    end
    object cdsRecebimentodta_entrada: TDateTimeField
      DisplayLabel = 'Dta. Entrada'
      FieldName = 'dta_entrada'
    end
    object cdsRecebimentonom_pessoa: TStringField
      DisplayLabel = 'Fornecedor'
      FieldName = 'nom_pessoa'
      Size = 60
    end
    object cdsRecebimentonum_cnpj_cpf: TStringField
      DisplayLabel = 'CNPJ Fornecedor'
      FieldName = 'num_cnpj_cpf'
      Size = 18
    end
    object cdsRecebimentostatus: TStringField
      DisplayLabel = 'Status'
      FieldName = 'status'
      Size = 60
    end
    object cdsRecebimentoind_status: TStringField
      FieldName = 'ind_status'
      Size = 2
    end
  end
  object dsRecebimento: TDataSource
    DataSet = cdsRecebimento
    OnDataChange = dsRecebimentoDataChange
    Left = 128
    Top = 216
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
  object dsEmpresa: TDataSource
    DataSet = cdsEmpresa
    Left = 128
    Top = 136
  end
  object dsFornecedor: TDataSource
    DataSet = cdsFornecedor
    Left = 128
    Top = 168
  end
  object cdsFornecedor: TClientDataSet
    Active = True
    Aggregates = <>
    Params = <>
    Left = 168
    Top = 168
    Data = {
      500000009619E0BD01000000180000000200000000000300000050000E636F64
      5F666F726E656365646F7204000100000000000A666F726E656365646F720100
      4900000001000557494454480200020064000000}
    object cdsFornecedorcod_fornecedor: TIntegerField
      FieldName = 'cod_fornecedor'
    end
    object cdsFornecedorfornecedor: TStringField
      FieldName = 'fornecedor'
      Size = 100
    end
  end
end
