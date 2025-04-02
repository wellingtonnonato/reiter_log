inherited FrmLogIntegracao: TFrmLogIntegracao
  Left = 404
  Top = 163
  Width = 505
  Height = 362
  Caption = 'Log do Processo de Integra'#231#227'o Reiter Log X Emsys'
  OldCreateOrder = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlPrincipal: TPanel
    Width = 489
    Height = 283
    object Label1: TLabel
      Left = 40
      Top = 16
      Width = 3
      Height = 13
    end
    object GroupBox1: TGroupBox
      Left = 0
      Top = 0
      Width = 489
      Height = 65
      Align = alTop
      Caption = 'Per'#237'odo de Execu'#231#227'o do Processo'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      object Label2: TLabel
        Left = 24
        Top = 16
        Width = 32
        Height = 13
        Caption = 'Inicio'
      end
      object Label3: TLabel
        Left = 187
        Top = 16
        Width = 20
        Height = 13
        Caption = 'Fim'
      end
      object eddInicio: TEdit
        Left = 24
        Top = 35
        Width = 121
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
      object eddFim: TEdit
        Left = 187
        Top = 35
        Width = 121
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
    end
    object mmLog: TMemo
      Left = 0
      Top = 65
      Width = 489
      Height = 218
      Align = alClient
      Lines.Strings = (
        'mmLog')
      TabOrder = 1
    end
  end
  inherited pnlBotoes: TPanel
    Top = 283
    Width = 489
    object spnAtualizar: TSpeedButton
      Left = 376
      Top = 11
      Width = 89
      Height = 22
      Caption = 'Atualizar'
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        1800000000000003000000000000000000000000000000000000000000000000
        0000000000000000005A490EC49E1EF0C226E2B723987A180E0B020000000000
        000000000000000000000000000000000000008B7016F0C226F0C226F0C226F0
        C226ECBF25C09B1EC09B1EBE981D090701000000000000000000000000000000
        E0B423F0C226F0C226F0C226F0C226E6BA24C09B1EC09B1EC09B1EC09B1EC09B
        1E2A2206000000000000000000CBA41FF0C226F0C226F0C226F0C226DCB122C0
        9B1EC09B1EC09B1EC09B1EC09B1EC09B1EC09B1E090701000000292106F0C226
        F0C226F0C226F0C226F3E1A1FFFFFFFFFFFFFFFFFFFEFEFEC5A331C09B1EC09B
        1EC09B1EBE981D000000E8BD25F0C226F0C226F0C226FBF2D4FEFDFCC29E25C0
        9B1EC09B1EF6DB80FFFFFFC5A330C09B1EC09B1EC09B1E0E0B02F0C226F0C226
        F0C226CBA72EFFFFFFC09B1EC09B1EC8A11FEABD25C09B1ED7C072D7C072C09B
        1EC09B1EC09B1E7A6212F0C226F0C226FEFBF4F5EFDCFCFBF7F9F5E9DBB122D4
        AB21C09B1EC09B1EC09C21FFFFFFC19D24C09B1EC09B1ECEA720F0C226F0C226
        F0C533FFFFFFFFFFFFEEC22DC29C1EC09B1EC09B1EC09B1EFFFFFFFFFFFFFFFF
        FFC09C20E8BB24F0C226F0C226F0C226F0C226F0C226E6BA24C09B1EC09B1EC0
        9B1EC09B1EC09B1ECEB151FFFFFFCAAB44EEC125F0C226C49E1EF0C226F0C226
        F0C226F0C226FFFFFFD2B85FC09B1EC09B1EC09B1EC09B1EFDFCF9E7D8A5F0C2
        26F0C226F0C2265A490E9A7B18F0C226F0C226F0C226F1C93FFFFFFFF9F6EBDC
        C883E5D7A5FFFFFFFCF6E0F0C226F0C226F0C226F0C226000000000000F0C226
        F0C226F0C226F0C226F0C226F7DF8FFCF4DAFAEEC3F2CA45F0C226F0C226F0C2
        26F0C2268B7016000000000000261F06F0C226F0C226F0C226F0C226F0C226F0
        C226F0C226F0C226F0C226F0C226F0C226E0B423000000000000000000000000
        271F06F0C226F0C226F0C226F0C226F0C226F0C226F0C226F0C226F0C226CBA4
        1F000000000000000000000000000000000000000000997B18F0C226F0C226F0
        C226F0C226F0C226E8BD25292106000000000000000000000000}
      OnClick = spnAtualizarClick
    end
  end
end
