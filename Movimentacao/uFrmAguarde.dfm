object FrmAguarde: TFrmAguarde
  Left = 514
  Top = 283
  Width = 330
  Height = 127
  Caption = 'Aguarde'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 314
    Height = 89
    Align = alTop
    TabOrder = 0
    object lbMensagem: TLabel
      Left = 1
      Top = 1
      Width = 312
      Height = 13
      Align = alTop
      Alignment = taCenter
      Caption = 'MENSAGEM'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
      WordWrap = True
    end
    object BarraProgresso: TProgressBar
      Left = 1
      Top = 14
      Width = 312
      Height = 17
      Align = alTop
      TabOrder = 0
      Visible = False
    end
  end
end
