program ProjectIntegracaoReiterLog;

uses
  Forms,
  uFrmPrincipal in 'uFrmPrincipal.pas' {frmPrincipal},
  uFrmPadrao in 'uFrmPadrao.pas' {frmPadrao},
  ufrmConfiguracaoBaseDados in 'Configuracao\ufrmConfiguracaoBaseDados.pas' {FrmConfiguracaoBaseDados},
  uFrmConfiguracaoEmail in 'Configuracao\uFrmConfiguracaoEmail.pas' {FrmConfiguracaoEmail},
  uFrmConfiguracaoFtp in 'Configuracao\uFrmConfiguracaoFtp.pas' {FrmConfiguracaoFtp},
  uProcessosFunctionGeral in 'uProcessosFunctionGeral.pas',
  uDataModulo in 'uDataModulo.pas' {dmPrincipal: TDataModule},
  uFrmConfiguracaoAlmoxarifado in 'Configuracao\uFrmConfiguracaoAlmoxarifado.pas' {FrmConfiguracaoAlmoxarifado},
  uFrmConfguracaoParametro in 'Configuracao\uFrmConfguracaoParametro.pas' {FrmConfguracaoParametro},
  uFrmConfiguracaoProcIntegracao in 'Configuracao\uFrmConfiguracaoProcIntegracao.pas' {FrmConfiguracaoProcIntegracao},
  uFrmEnvioNotaEntradaRecebimento in 'Movimentacao\uFrmEnvioNotaEntradaRecebimento.pas' {FrmEnvioNotaEntradaRecebimento},
  uFrmCancelaNotaEntradaRecebimento in 'Movimentacao\uFrmCancelaNotaEntradaRecebimento.pas' {FrmCancelaNotaEntradaRecebimento},
  uFrmCancelarEnvioPreVendaSeparacao in 'Movimentacao\uFrmCancelarEnvioPreVendaSeparacao.pas' {FrmCancelarEnvioPreVendaSeparacao},
  uFrmMonitoramentoRecebimento in 'Movimentacao\uFrmMonitoramentoRecebimento.pas' {FrmMonitoramentoRecebimento},
  uFrmMonitoramentoSeparacao in 'Movimentacao\uFrmMonitoramentoSeparacao.pas' {FrmMonitoramentoSeparacao},
  uFrmUsuarios in 'Cadastro\uFrmUsuarios.pas' {FrmUsuarios},
  uFrmCadastroUsuario in 'Cadastro\uFrmCadastroUsuario.pas' {FrmCadastroUsuario},
  uFrmLogin in 'uFrmLogin.pas' {FrmLogin},
  uFrmLogIntegracao in 'Movimentacao\uFrmLogIntegracao.pas' {FrmLogIntegracao},
  uFrmAguarde in 'Movimentacao\uFrmAguarde.pas' {FrmAguarde};

{$R *.res}

{Usuário Padrão do Sistema = IMPULSE
 Senha = @poc@lipse2020}
begin
  Application.Initialize;
  Application.Title := 'Integração Reiter Log X Emsys';
  Application.CreateForm(TdmPrincipal, dmPrincipal);
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TFrmLogIntegracao, FrmLogIntegracao);
  Application.Run;
end.
