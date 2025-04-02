inherited FrmConfiguracaoProcIntegracao: TFrmConfiguracaoProcIntegracao
  Left = 436
  Top = 153
  Width = 614
  Height = 426
  Caption = 'Configura'#231#227'o do Processo de Integra'#231#227'o'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlPrincipal: TPanel
    Width = 598
    Height = 347
    object pnEmpresa: TPanel
      Left = 0
      Top = 0
      Width = 598
      Height = 43
      Align = alTop
      TabOrder = 0
      object Label1: TLabel
        Left = 24
        Top = 14
        Width = 44
        Height = 13
        Caption = 'Empresa:'
      end
      object DBLookupComboBox1: TDBLookupComboBox
        Left = 104
        Top = 11
        Width = 273
        Height = 21
        TabOrder = 0
      end
    end
    object GroupBox1: TGroupBox
      Left = 0
      Top = 43
      Width = 598
      Height = 142
      Align = alTop
      Caption = 'Recebimento'
      TabOrder = 1
    end
  end
  inherited pnlBotoes: TPanel
    Top = 347
    Width = 598
  end
end
