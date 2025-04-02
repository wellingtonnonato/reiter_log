inherited FrmConfguracaoParametro: TFrmConfguracaoParametro
  Left = 321
  Top = 217
  Width = 656
  Height = 471
  Caption = 'FrmConfguracaoParametro'
  OldCreateOrder = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlPrincipal: TPanel
    Width = 640
    Height = 392
    object pgPrincipal: TPageControl
      Left = 97
      Top = 0
      Width = 543
      Height = 392
      ActivePage = tbsEmpresa
      Align = alClient
      TabOrder = 0
      object tbsEmpresa: TTabSheet
        Caption = 'Empresas'
        TabVisible = False
        object GroupBox1: TGroupBox
          Left = 0
          Top = 0
          Width = 535
          Height = 137
          Align = alTop
          Caption = 'Empresas para Integra'#231#227'o'
          TabOrder = 0
          object DBGrid1: TDBGrid
            Tag = 1
            Left = 2
            Top = 15
            Width = 531
            Height = 120
            Hint = 'tab_empresa,cod_empresa'
            Align = alClient
            DataSource = dsEmrpesaCadastradas
            TabOrder = 0
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
                FieldName = 'cod_empresa'
                Width = 50
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'nom_empresa'
                Width = 260
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'num_cnpj'
                Visible = True
              end>
          end
        end
      end
    end
    object MenuLateral: TTreeView
      Left = 0
      Top = 0
      Width = 97
      Height = 392
      Align = alLeft
      Indent = 19
      TabOrder = 1
      OnChange = MenuLateralChange
      Items.Data = {
        01000000210000000000000000000000FFFFFFFFFFFFFFFF0000000000000000
        08456D707265736173}
    end
  end
  inherited pnlBotoes: TPanel
    Top = 392
    Width = 640
    object spdGravar: TSpeedButton
      Left = 485
      Top = 10
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
      Left = 562
      Top = 10
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
  object cdsEmpresaCadastradas: TClientDataSet
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'ind_selecao'
        DataType = ftString
        Size = 1
      end
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
        Name = 'num_cnpj'
        DataType = ftString
        Size = 18
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 141
    Top = 352
    Data = {
      8B0000009619E0BD0100000018000000040000000000030000008B000B696E64
      5F73656C6563616F01004900000001000557494454480200020001000B636F64
      5F656D707265736104000100000000000B6E6F6D5F656D707265736101004900
      00000100055749445448020002003C00086E756D5F636E706A01004900000001
      000557494454480200020012000000}
    object cdsEmpresaCadastradasind_selecao: TStringField
      DisplayLabel = 'X'
      FieldName = 'ind_selecao'
      Size = 1
    end
    object cdsEmpresaCadastradascod_empresa: TIntegerField
      DisplayLabel = 'C'#243'digo'
      DisplayWidth = 15
      FieldName = 'cod_empresa'
    end
    object cdsEmpresaCadastradasnom_empresa: TStringField
      DisplayLabel = 'Empresa'
      DisplayWidth = 77
      FieldName = 'nom_empresa'
      Size = 60
    end
    object cdsEmpresaCadastradasnum_cnpj: TStringField
      DisplayLabel = 'CNPJ'
      DisplayWidth = 27
      FieldName = 'num_cnpj'
      Size = 18
    end
  end
  object dsEmrpesaCadastradas: TDataSource
    DataSet = cdsEmpresaCadastradas
    Left = 173
    Top = 352
  end
end
