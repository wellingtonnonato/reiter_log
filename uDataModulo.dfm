object dmPrincipal: TdmPrincipal
  OldCreateOrder = False
  Left = 442
  Top = 194
  Height = 428
  Width = 594
  object zConexao: TZConnection
    ControlsCodePage = cGET_ACP
    AutoEncodeStrings = True
    Properties.Strings = (
      'AutoEncodeStrings=ON')
    AutoCommit = False
    Port = 5432
    Protocol = 'postgresql-9'
    Left = 104
    Top = 112
  end
  object ZQuery1: TZQuery
    Params = <>
    Left = 160
    Top = 112
  end
end
