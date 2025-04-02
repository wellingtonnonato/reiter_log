inherited FrmEnvioNotaEntradaRecebimento: TFrmEnvioNotaEntradaRecebimento
  Left = 404
  Top = 224
  Caption = 'Enviar Nota Fiscal de Entrada para o Recebimento'
  OldCreateOrder = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlPrincipal: TPanel
    object pnFiltro: TPanel
      Left = 0
      Top = 0
      Width = 784
      Height = 73
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object spnPesquisar: TSpeedButton
        Left = 672
        Top = 32
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
        Width = 239
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
    end
    object DBGrid1: TDBGrid
      Left = 0
      Top = 73
      Width = 784
      Height = 248
      Align = alClient
      DataSource = dsNF
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
          FieldName = 'seq_nota'
          Width = 60
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'num_nota'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'des_fornecedor'
          Width = 200
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'dta_entrada'
          Width = 70
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'dta_emissao'
          Width = 70
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'cnpj_fornecedor'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Empresa'
          Width = 200
          Visible = True
        end>
    end
  end
  inherited pnlBotoes: TPanel
    object spnEnviarRecebimento: TSpeedButton
      Left = 616
      Top = 8
      Width = 145
      Height = 22
      Caption = 'Enviar p/Recebimento'
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        1800000000000003000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        00000000000000000000000000000000000000000000000000000000009D5E13
        0000000000000000000000000000000000000000000000000000000000000000
        00000000000000000000000000E5881EE5881ED57E1C1D110300000000000000
        0000000000000000000000000000000000000000000000000000000000E5881E
        E5881EE5881EE5881EE5881E5D370C0000000000000000000000000000000000
        00000000000000000000000000E5881EE5881EE5881EE5881EE5881EE5881EE5
        881E9D5E13000000000000000000000000000000000000000000000000E5881E
        E5881EE5881EE5881EE5881EE5881EE5881EE5881EE5881ED57E1C1D11030000
        000000000000000000000000000000000000000503003F25087D4A10BA6E18E5
        881EE5881EE5881EE5881EE5881EE5881E5D370C000000000000000000000000
        000000000000000000000000000000110A024F2F0A8B5312C87719E5881EE588
        1EE5881E7E4A100000000000006E410EAA6516E1851DE5881EE5881EE5881EE5
        881EE5881EE5881EE5881EE2861D3B2307000000000000000000000000E5881E
        E5881EE5881EE5881EE5881EE5881EE5881EE5881EBE70170905010000000000
        00000000000000000000000000E5881EE5881EE5881EE5881EE5881EE5881E7E
        4A10000000000000000000000000000000000000000000000000000000E5881E
        E5881EE5881EE2861D3B23070000000000000000000000000000000000000000
        00000000000000000000000000E5881EBE701709050100000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000}
      OnClick = spnEnviarRecebimentoClick
    end
  end
  object cdsNF: TClientDataSet
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'ind_selecao'
        DataType = ftString
        Size = 1
      end
      item
        Name = 'seq_nota'
        DataType = ftInteger
      end
      item
        Name = 'num_nota'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'des_fornecedor'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'dta_entrada'
        DataType = ftDateTime
      end
      item
        Name = 'dta_emissao'
        DataType = ftDateTime
      end
      item
        Name = 'cnpj_fornecedor'
        DataType = ftString
        Size = 16
      end
      item
        Name = 'Empresa'
        DataType = ftString
        Size = 100
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 168
    Top = 329
    Data = {
      F30000009619E0BD010000001800000008000000000003000000F3000B696E64
      5F73656C6563616F010049000000010005574944544802000200010008736571
      5F6E6F74610400010000000000086E756D5F6E6F746101004900000001000557
      49445448020002000A000E6465735F666F726E656365646F7201004900000001
      000557494454480200020064000B6474615F656E747261646108000800000000
      000B6474615F656D697373616F08000800000000000F636E706A5F666F726E65
      6365646F72010049000000010005574944544802000200100007456D70726573
      6101004900000001000557494454480200020064000000}
    object cdsNFind_selecao: TStringField
      DisplayLabel = 'X'
      FieldName = 'ind_selecao'
      Size = 1
    end
    object cdsNFseq_nota: TIntegerField
      DisplayLabel = 'Seq. Nota'
      FieldName = 'seq_nota'
    end
    object cdsNFnum_nota: TStringField
      DisplayLabel = 'Nro. Nota'
      FieldName = 'num_nota'
      Size = 10
    end
    object cdsNFdes_fornecedor: TStringField
      DisplayLabel = 'Fornecedor'
      FieldName = 'des_fornecedor'
      Size = 100
    end
    object cdsNFdta_entrada: TDateTimeField
      DisplayLabel = 'Dta. Entrada'
      FieldName = 'dta_entrada'
    end
    object cdsNFdta_emissao: TDateTimeField
      DisplayLabel = 'Dta. Emiss'#227'o'
      FieldName = 'dta_emissao'
    end
    object cdsNFcnpj_fornecedor: TStringField
      DisplayLabel = 'CNPJ Fornecedor'
      DisplayWidth = 18
      FieldName = 'cnpj_fornecedor'
      Size = 16
    end
    object cdsNFEmpresa: TStringField
      FieldName = 'Empresa'
      Size = 100
    end
  end
  object dsNF: TDataSource
    DataSet = cdsNF
    Left = 136
    Top = 329
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
  object dsFornecedor: TDataSource
    DataSet = cdsFornecedor
    Left = 128
    Top = 168
  end
end
