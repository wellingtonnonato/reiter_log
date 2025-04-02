unit uFrmPrincipal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, Grids, DBGrids, DB, DBClient, Buttons,
  ZAbstractRODataset, ZAbstractDataset, ZDataset, ExtCtrls, IniFiles;

type
  TreadProcesso = class(TThread)
    public
      constructor Create;
      procedure Execute; override;
  end;

  TfrmPrincipal = class(TForm)
    mmPrincipal: TMainMenu;
    Configuraes1: TMenuItem;
    Monitoramento1: TMenuItem;
    Processo1: TMenuItem;
    AcessoBaseDados1: TMenuItem;
    Email1: TMenuItem;
    Ftp1: TMenuItem;
    Envio1: TMenuItem;
    Retorno1: TMenuItem;
    Parametros1: TMenuItem;
    AlmoxarifadoIntermediario1: TMenuItem;
    IntegraoReiterLog1: TMenuItem;
    Label1: TLabel;
    Label2: TLabel;
    ednRecebimento: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    ednHora: TEdit;
    Label5: TLabel;
    ednMinuto: TEdit;
    Label6: TLabel;
    SpnIniciar: TSpeedButton;
    spnStop: TSpeedButton;
    NotadeEntrada1: TMenuItem;
    Monitoramento2: TMenuItem;
    Monitoramento3: TMenuItem;
    PrVendas1: TMenuItem;
    CancelaroenviodaNFdeEntrada1: TMenuItem;
    cdsSeparacao: TClientDataSet;
    cdsSeparacaoItem: TClientDataSet;
    cdsSeparacaosequencia: TIntegerField;
    cdsSeparacaotipo_registro: TIntegerField;
    cdsSeparacaonumero_carga: TIntegerField;
    cdsSeparacaofiller: TStringField;
    cdsSeparacaocnpj_emissor: TStringField;
    cdsSeparacaodata_carga: TStringField;
    cdsSeparacaocnpj_dest: TStringField;
    cdsSeparacaonome_filial_dest: TStringField;
    cdsSeparacaoendereco_dest: TStringField;
    cdsSeparacaobairro_dest: TStringField;
    cdsSeparacaofone_dest: TStringField;
    cdsSeparacaocep_dest: TStringField;
    cdsSeparacaoinsc_estadual_dest: TStringField;
    cdsSeparacaoItemsequencia: TIntegerField;
    cdsSeparacaoItemtipo_registro: TIntegerField;
    cdsSeparacaoItemnumero_carga: TIntegerField;
    cdsSeparacaoItemean: TStringField;
    cdsSeparacaoItemqtd_expedida: TFloatField;
    cdsSeparacaoItemcodigo_embalagem: TStringField;
    cdsSeparacaoItemcusto_medio: TFloatField;
    cdsSeparacaoItemtipo_carga: TStringField;
    cdsSeparacaoItemfiller1: TStringField;
    cdsSeparacaoItemfiller2: TStringField;
    cdsSeparacaoItemcod_mercadoria: TIntegerField;
    cdsRecebimento: TClientDataSet;
    cdsRecebimentoItem: TClientDataSet;
    cdsRecebimentosequencia: TIntegerField;
    cdsRecebimentotipo_registro: TIntegerField;
    cdsRecebimentocnpj_fornecedor: TStringField;
    cdsRecebimentonumero_nota_fiscal: TStringField;
    cdsRecebimentoserie_nota_fiscal: TStringField;
    cdsRecebimentodata_emissao: TStringField;
    cdsRecebimentocnpj_dest: TStringField;
    cdsRecebimentocnpj_complemento: TStringField;
    cdsRecebimentoplaca_veiculo: TStringField;
    cdsRecebimentotipo_carga: TStringField;
    cdsRecebimentofiller: TStringField;
    cdsRecebimentoItemsequencia: TIntegerField;
    cdsRecebimentoItemtipo_registro: TIntegerField;
    cdsRecebimentoItemcnpj_fornecedor: TStringField;
    cdsRecebimentoItemnumero_nota_fiscal: TStringField;
    cdsRecebimentoItemserie_nota_fiscal: TStringField;
    cdsRecebimentoItemean: TStringField;
    cdsRecebimentoItemqtd_nf: TFloatField;
    cdsRecebimentoItemembalagem_mercadoria: TStringField;
    cdsRecebimentoItemvalor: TFloatField;
    cdsRecebimentoItemdesconto: TFloatField;
    cdsRecebimentoItemqtd_embalagem: TFloatField;
    cdsRecebimentoItemqtd_saldo_pedido: TFloatField;
    cdsRecebimentoItemqtd_atendida_pedido: TFloatField;
    cdsRecebimentoItemcod_mercadoria: TIntegerField;
    cdsRecebimentoItemembalagem_deposito: TStringField;
    CadastroUsuario1: TMenuItem;
    Image1: TImage;
    Timer1: TTimer;
    lbVersao: TLabel;
    Log1: TMenuItem;
    procedure AcessoBaseDados1Click(Sender: TObject);
    procedure Email1Click(Sender: TObject);
    procedure Ftp1Click(Sender: TObject);
    procedure Processo1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Parametros1Click(Sender: TObject);
    procedure AlmoxarifadoIntermediario1Click(Sender: TObject);
    procedure ednRecebimentoKeyPress(Sender: TObject; var Key: Char);
    procedure ednHoraKeyPress(Sender: TObject; var Key: Char);
    procedure ednMinutoKeyPress(Sender: TObject; var Key: Char);
    procedure ednHoraExit(Sender: TObject);
    procedure ednMinutoExit(Sender: TObject);
    procedure NotadeEntrada1Click(Sender: TObject);
    procedure CancelaroenviodaNFdeEntrada1Click(Sender: TObject);
    procedure PrVendas1Click(Sender: TObject);
    procedure Monitoramento2Click(Sender: TObject);
    procedure Monitoramento3Click(Sender: TObject);
    procedure SpnIniciarClick(Sender: TObject);
    procedure CadastroUsuario1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure spnStopClick(Sender: TObject);
    procedure Log1Click(Sender: TObject);
  private
    { Private declarations }
    _bLoginOK : Boolean;
    _bProcessoEmExecucao : Boolean;
    FTheard : TreadProcesso;
    procedure ValidarCampoHora;
    procedure ExecutarProcessoArquivoSeparacao(var ListErro : TStringList);
    procedure ExecutarProcessoArquivoRecebimento(var ListErro : TStringList);
    procedure ExecutarProcessoRetornoSeparacao(var ListErro : TStringList);
    procedure ExecutarProcessoRetornoRecebimento(var ListErro : TStringList);
    procedure ProcessoArquivo;
    procedure DesativarAtivarBotoes;
    function BuscarBuild : String;
    procedure UpdateDataUltimaSeparacao(var ListErro : TStringList);
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  uFrmConfiguracaoBaseDados, uFrmPadrao, uFrmConfiguracaoEmail, uFrmConfiguracaoFtp, uDataModulo, uProcessosFunctionGeral, uFrmConfguracaoParametro, uFrmConfiguracaoAlmoxarifado, uFrmEnvioNotaEntradaRecebimento, uFrmCancelaNotaEntradaRecebimento, uFrmCancelarEnvioPreVendaSeparacao, uFrmMonitoramentoRecebimento, uFrmMonitoramentoSeparacao, uFrmUsuarios, uFrmLogin, uFrmLogIntegracao, uFrmAguarde;

{$R *.dfm}

procedure TfrmPrincipal.AcessoBaseDados1Click(Sender: TObject);
var frmConfiguracao : TFrmConfiguracaoBaseDados;
begin
  if not VerificaAcesso(AcessoBaseDados1.Tag) then
    Exit;

  frmConfiguracao := TFrmConfiguracaoBaseDados.Create(nil);

  try
    frmConfiguracao.ShowModal;
  finally
    FreeAndNil(frmConfiguracao);
  end;
end;

procedure TfrmPrincipal.Email1Click(Sender: TObject);
var frmConfEmail : TFrmConfiguracaoEmail;
begin
  if not VerificaAcesso(Email1.Tag) then
    Exit;

  frmConfEmail := TFrmConfiguracaoEmail.Create(nil);

  try
    frmConfEmail.ShowModal;
  finally
    FreeAndNil(frmConfEmail);
  end;
end;

procedure TfrmPrincipal.Ftp1Click(Sender: TObject);
var frmConfFtp : TFrmConfiguracaoFtp;
begin
  if not VerificaAcesso(FTP1.Tag) then
    Exit;

  frmConfFtp := TFrmConfiguracaoFtp.Create(nil);

  try
    frmConfFtp.ShowModal;
  finally
    FreeAndNil(frmConfFtp);
  end;
end;

procedure TfrmPrincipal.Processo1Click(Sender: TObject);
begin
  {if dmPrincipal.ConectaDataBase then
  begin
    MsgSistema('Conecetado com sucesso.', 'I');
  end^}
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
var frmConfiguracao : TFrmConfiguracaoBaseDados;
    fLogin : TFrmLogin;
    ArqIni : TIniFile;
    diretorio : String;
begin
  CriarDiretorioPadrao;

  if not dmPrincipal.ConectaDataBase then
  begin
    MsgSistema('É necessário configurar o acesso a Base de Dados.', 'A');

    frmConfiguracao := TFrmConfiguracaoBaseDados.Create(nil);

    try
      frmConfiguracao.ShowModal;
    finally
      FreeAndNil(frmConfiguracao);
    end;

    if not dmPrincipal.ConectaDataBase then
    begin
      MsgSistema('É necessário configurar a conexão com a Base de Dados', 'E');
      PostMessage(Handle, WM_CLOSE, 0, 0);
    end;
  end;

  fLogin := TFrmLogin.Create(Nil);

  try
    if fLogin.ShowModal = mrOK then
      _bLoginOK := True
    else
      _bLoginOK := False;
  finally
    FreeAndNil(fLogin);
  end;

  if not _bLoginOK then
  begin
    PostMessage(Handle, WM_CLOSE, 0, 0);
  end;

  _bProcessoEmExecucao := False;
  lbVersao.Caption := 'Versão: ' + BuscarBuild;

  diretorio     := ParamStr(0);
  diretorio     := ExtractFilePath(diretorio);
  ArqIni        := TIniFile.Create(diretorio + 'ReiterLog.ini');

  try
    ednRecebimento.Text := ArqIni.ReadString('TempoIntegracao', 'Recebimento', '0');
    ednHora.Text        := ArqIni.ReadString('TempoIntegracao', 'HoraSeparacao', '00');
    ednMinuto.text      := ArqIni.ReadString('TempoIntegracao', 'MinutoSeparacao', '00');
  finally
    FreeAndNil(ArqIni);
  end;
end;

procedure TfrmPrincipal.Parametros1Click(Sender: TObject);
var frmConfParametro : TFrmConfguracaoParametro;
begin
  if not VerificaAcesso(Parametros1.Tag) then
    Exit;

  frmConfParametro := TFrmConfguracaoParametro.Create(nil);

  try
    frmConfParametro.ShowModal;
  finally
    FreeAndNil(frmConfParametro);
  end;
end;

procedure TfrmPrincipal.AlmoxarifadoIntermediario1Click(Sender: TObject);
var frmConfAlmox : TFrmConfiguracaoAlmoxarifado;
begin
  if not VerificaAcesso(AlmoxarifadoIntermediario1.Tag) then
    Exit;

  frmConfAlmox := TFrmConfiguracaoAlmoxarifado.Create(nil);

  try
    frmConfAlmox.ShowModal;
  finally
    FreeAndNil(frmConfAlmox);
  end;
end;

procedure TfrmPrincipal.ednRecebimentoKeyPress(Sender: TObject;
  var Key: Char);
begin
  Key := SomenteNumero(Key);
end;

procedure TfrmPrincipal.ednHoraKeyPress(Sender: TObject; var Key: Char);
begin
  Key := SomenteNumero(Key);
end;

procedure TfrmPrincipal.ednMinutoKeyPress(Sender: TObject; var Key: Char);
begin
  Key := SomenteNumero(Key);
end;

procedure TfrmPrincipal.ednHoraExit(Sender: TObject);
begin
  ValidarCampoHora;
end;

procedure TfrmPrincipal.ValidarCampoHora;
begin
  if (ednMinuto.Text <> '') and
     (ednHora.Text <> '') then
  begin
    if not ValidarHora(ednHora.Text, ednMinuto.Text) then
    begin
      if (StrToInt(ednhora.Text) > 23) or
         (StrToInt(ednhora.Text) < 0) then
      begin
        ednHora.SetFocus;
      end
      else
      begin
        ednMinuto.SetFocus;
      end;
    end;
  end;
end;

procedure TfrmPrincipal.ednMinutoExit(Sender: TObject);
begin
  ValidarCampoHora;
end;

procedure TfrmPrincipal.NotadeEntrada1Click(Sender: TObject);
var frmEnvioNotaEntrada : TFrmEnvioNotaEntradaRecebimento;
begin
  if not VerificaAcesso(NotadeEntrada1.Tag) then
    Exit;

  frmEnvioNotaEntrada := TFrmEnvioNotaEntradaRecebimento.Create(nil);

  try
    frmEnvioNotaEntrada.ShowModal;
  finally
    FreeAndNil(frmEnvioNotaEntrada);
  end;
end;

procedure TfrmPrincipal.CancelaroenviodaNFdeEntrada1Click(Sender: TObject);
var frmCancelaNotaEntrada : TFrmCancelaNotaEntradaRecebimento;
begin
  if not VerificaAcesso(CancelaroenviodaNFdeEntrada1.Tag) then
    Exit;

  frmCancelaNotaEntrada := TFrmCancelaNotaEntradaRecebimento.Create(nil);

  try
    frmCancelaNotaEntrada.ShowModal;
  finally
    FreeAndNil(frmCancelaNotaEntrada);
  end;
end;

procedure TfrmPrincipal.PrVendas1Click(Sender: TObject);
var frmCancelaPreVenda : TFrmCancelarEnvioPreVendaSeparacao;
begin
  if not VerificaAcesso(PrVendas1.Tag) then
    Exit;

  frmCancelaPreVenda := TFrmCancelarEnvioPreVendaSeparacao.Create(nil);

  try
    frmCancelaPreVenda.ShowModal;
  finally
    FreeAndNil(frmCancelaPreVenda);
  end;
end;

procedure TfrmPrincipal.Monitoramento2Click(Sender: TObject);
var frmMonitoraRecebimento : TFrmMonitoramentoRecebimento;
begin
  if not VerificaAcesso(Monitoramento2.Tag) then
    Exit;

  frmMonitoraRecebimento := TFrmMonitoramentoRecebimento.Create(nil);

  try
    frmMonitoraRecebimento.ShowModal;
  finally
    FreeAndNil(frmMonitoraRecebimento);
  end;
end;

procedure TfrmPrincipal.Monitoramento3Click(Sender: TObject);
var frmMonitoraSeparacao : TFrmMonitoramentoSeparacao;
begin
  if not VerificaAcesso(Monitoramento3.Tag) then
    Exit;

  frmMonitoraSeparacao := TFrmMonitoramentoSeparacao.Create(nil);

  try
    frmMonitoraSeparacao.ShowModal;
  finally
    FreeAndNil(frmMonitoraSeparacao);
  end;
end;

procedure TfrmPrincipal.ExecutarProcessoArquivoSeparacao(var ListErro : TStringList);
var qConsulta : TZQuery;
begin
  qConsulta := NewZQuery;

  try
    AlteraStatus( TipoSeparacao
                , 'AE'
                , 'PE'
                , ListErro);

    //ExcluirItemSemEstoque(ListErro);

    with qConsulta do
    begin
      Close;
      Sql.Clear;
      Sql.Add('SELECT a.seq_separacao as sequencia                                           ');
      Sql.Add('     , cast(1 as Integer) as tipo_registro                                    ');
      Sql.Add('     , a.seq_separacao as numero_carga                                        ');
      Sql.Add('     , cast(''00000000'' as varchar(8)) as filler                             ');
      Sql.Add('     , cast(c.num_cnpj as varchar(16)) as cnpj_emissor                        ');
      Sql.Add('     , cast(to_char(b.dta_emissao, ''DDMMYYYY'') as varchar(8)) as data_carga ');
      Sql.Add('     , cast(d.num_cnpj_cpf as varchar(16)) as cnpj_dest                       ');
      Sql.Add('     , cast(d.nom_pessoa as varchar(35)) nome_filial_dest                     ');
      Sql.Add('     , cast(d.des_logradouro as varchar(30)) as endereco_dest                 ');
      Sql.Add('     , cast(d.nom_bairro as varchar(30)) as bairro_dest                       ');
      Sql.Add('     , cast(d.num_telefone_1 as varchar(15)) as fone_dest                     ');
      Sql.Add('     , cast(d.num_cep as varchar(10)) as cep_dest                             ');
      Sql.Add('     , cast(d.num_ie_rg as varchar(15)) as insc_estadual_dest                 ');
      Sql.Add('  FROM reiterLog.tab_separacao a                                              ');
      Sql.Add('  JOIN tab_pre_venda b on b.seq_pre_venda = a.seq_separacao                   ');
      Sql.Add('  JOIN tab_empresa c on c.cod_empresa = b.cod_empresa                         ');
      Sql.Add('  JOIN tab_pessoa d on d.cod_pessoa = b.cod_pessoa_cliente                    ');
      Sql.Add(' WHERE a.ind_status = ''PE''                                                  ');
      Open;
      First;
    end;

    PopularClientDataSet(cdsSeparacao, qConsulta);

    with qConsulta do
    begin
      Close;
      Sql.Clear;
      Sql.Add('SELECT a.seq_separacao as sequencia                                                              ');
      Sql.Add('     , cast(2 as INTEGER) as tipo_registro                                                       ');
      Sql.Add('     , a.seq_separacao as numero_carga                                                           ');
      Sql.Add('     , cast(c.cod_barra as varchar(13)) as ean                                                   ');
      Sql.Add('     , cast(b.qtd_item as Double Precision) as qtd_expedida                                      ');
      Sql.Add('     , cast(d.sgl_unidade as varchar(2)) as codigo_embalagem                                     ');
      Sql.Add('     , cast(e.val_custo_medio as Double Precision) as custo_medio                                ');
      Sql.Add('     , cast(''PBS'' as char(3)) as tipo_carga                                                    ');
      Sql.Add('     , cast(''000000'' as char(6)) as filler1                                                    ');
      Sql.Add('     , cast('''' as char(3)) as filler2                                                          ');
      Sql.Add('     , c.cod_item as cod_mercadoria                                                              ');
      Sql.Add('  FROM reiterlog.tab_separacao a                                                                 ');
      Sql.Add('  JOIN reiterlog.tab_separacao_item b on b.seq_separacao = a.seq_separacao                       ');
      Sql.Add('  JOIN tab_item c on c.cod_item = b.cod_item                                                     ');
      Sql.Add('  JOIN tab_unidade d on d.cod_unidade = b.cod_unidade                                            ');
      Sql.Add('  JOIN tab_item_pre_venda e on e.seq_pre_venda = b.seq_separacao AND                             ');
      Sql.Add('                              e.seq_item = b.seq_item                                            ');
      Sql.Add('  JOIN tab_pre_venda f on f.seq_pre_venda = a.seq_separacao                                      ');
      Sql.Add(' WHERE a.ind_status = ''PE''                                                                     ');
      Sql.Add('   AND ((SELECT  ROUND(CAST(COALESCE(SUM(aa.qtd_movimento_estoque *                              ');
      Sql.Add('                                         (POSITION(''E'' IN bb.ind_tipo_movimento)  *            ');
      Sql.Add('                                         2 - 1)),0) AS NUMERIC),5)                               ');
      Sql.Add('           FROM tab_movimento_estoque aa                                                         ');
      Sql.Add('           JOIN tab_tipo_movimento_estoque bb ON (bb.cod_tipo_movimento = aa.cod_tipo_movimento) ');
      Sql.Add('          WHERE aa.cod_empresa = f.cod_empresa                                                   ');
      Sql.Add('            AND aa.cod_item = b.cod_item                                                         ');
      Sql.Add('            AND aa.cod_almoxarifado = e.cod_almoxarifado                                         ');
      Sql.Add('            AND aa.dta_movimento <= CURRENT_DATE) > 0)                                           ');
      Open;
      First;
    end;

    PopularClientDataSet(cdsSeparacaoItem, qConsulta);
    Sleep(1000);
    GerarArquivo( TipoSeparacao
                , cdsSeparacao
                , cdsSeparacaoItem
                , ListErro);

    with DadosFtp do
    begin
      EnvioFTP( HostName
              , Usuario
              , Senha
              , DirSeparacaoEnvio
              , DiretorioSistema.DirArqEnvioSeparacao
              , DiretorioSistema.DirArqEnvioSeparacaoEnviados
              , Porta
              , ListErro);
    end;
    
    AlteraStatus( TipoSeparacao
                , 'PE'
                , 'AR'
                , ListErro);
  finally
    FreeAndNil(qConsulta);
  end;
end;

procedure TfrmPrincipal.SpnIniciarClick(Sender: TObject);
var ArqIni : TIniFile;
    diretorio : String;
begin
  if not VerificaAcesso(0, True) then
    Exit;

  if StrToIntDef(ednRecebimento.Text,0) < 5 then
  begin
    MsgSistema('O tempo minimo de envio é do recebimento é 5 minutos.', 'A');
    ednRecebimento.SetFocus;
    Exit;
  end;

  diretorio := ParamStr(0);
  diretorio := ExtractFilePath(diretorio);
  ArqIni    := TIniFile.Create(diretorio + 'ReiterLog.ini');

  try
    ArqIni.WriteString('TempoIntegracao', 'Recebimento', ednRecebimento.Text);
    ArqIni.WriteString('TempoIntegracao', 'HoraSeparacao', ednHora.Text);
    ArqIni.WriteString('TempoIntegracao', 'MinutoSeparacao', ednMinuto.Text);
  finally
    FreeAndNil(ArqIni);
  end;

  if (FTheard <> nil) and
     (not FTheard.Terminated) then
    Exit;

  FTheard := TreadProcesso.Create;
  DesativarAtivarBotoes;
  ProcessoArquivo;
end;

procedure TfrmPrincipal.ExecutarProcessoArquivoRecebimento(var ListErro : TStringList);
var qConsulta : TZQuery;
begin
  qConsulta := NewZQuery;

  try
    AlteraStatus( TipoRecebimento
                , 'AE'
                , 'PE'
                , ListErro);

    with qConsulta do
    begin
      Close;
      Sql.Clear;
      Sql.Add('SELECT a.seq_recebimento as sequencia                                                    ');
      Sql.Add('     , cast(1 as INTEGER) as tipo_registro                                               ');
      Sql.Add('     , cast(c.num_cnpj_cpf as varchar(16)) as cnpj_fornecedor                            ');
      Sql.Add('     , cast(b.num_nota  as varchar(9)) as numero_nota_fiscal                             ');
      Sql.Add('     , cast(b.num_serie as char(3)) as serie_nota_fiscal                                 ');
      Sql.Add('     , cast(to_char(b.dta_emissao, ''DDMMYYYY'') as varchar(8)) as data_emissao          ');
      Sql.Add('     , cast(d.num_cnpj as varchar(16)) as cnpj_dest                                      ');
      Sql.Add('     , cast(coalesce(e.num_cnpj_cpf, c.num_cnpj_cpf) as varchar(16)) as cnpj_complemento ');
      Sql.Add('     , cast(b.num_placa_veiculo as varchar(7)) as placa_veiculo                          ');
      Sql.Add('     , cast(''PBS'' as char(3)) as tipo_carga                                            ');
      Sql.Add('     , cast('''' as varchar(38)) as filler                                               ');
      Sql.Add('  FROM reiterlog.tab_recebimento a                                                       ');
      Sql.Add('  JOIN tab_nota_fiscal_entrada b on b.seq_nota = a.seq_recebimento                       ');
      Sql.Add('  JOIN tab_pessoa c on c.cod_pessoa = b.cod_pessoa_fornecedor                            ');
      Sql.Add('  JOIN tab_empresa d on d.cod_empresa = b.cod_empresa                                    ');
      Sql.Add('  LEFT join tab_pessoa e on e.cod_pessoa = b.cod_pessoa_transportador                    ');
      Sql.Add(' WHERE a.ind_status = ''PE''                                                             ');
      Open;
      First;
    end;

    PopularClientDataSet(cdsRecebimento, qConsulta);

    with qConsulta do
    begin
      Close;
      Sql.Clear;
      Sql.Add('SELECT a.seq_recebimento as sequencia                              ');
      Sql.Add('     , cast(2 as INTEGER) as tipo_registro                         ');
      Sql.Add('     , cast(c.num_cnpj_cpf as varchar(16)) as cnpj_fornecedor      ');
      Sql.Add('     , cast(b.num_nota  as varchar(9)) as numero_nota_fiscal       ');
      Sql.Add('     , cast(b.num_serie as char(3)) as serie_nota_fiscal           ');
      Sql.Add('     , cast(d.cod_barra as varchar(13)) as ean                     ');
      Sql.Add('     , cast(d.qtd_item as Double Precision) as qtd_nf              ');
      Sql.Add('     , cast(f.sgl_unidade as char(2)) as embalagem_mercadoria      ');
      Sql.Add('     , cast(d.val_unitario as Double PRECISION) as valor           ');
      Sql.Add('     , cast(d.val_desconto as DOUBLE PRECISION) as desconto        ');
      Sql.Add('     , cast(a.qtd_unidade as DOUBLE PRECISION) as  qtd_embalagem   ');
      Sql.Add('     , cast(g.sgl_unidade as char(2)) as embalagem_deposito        ');
      Sql.Add('     , cast(0  as DOUBLE PRECISION) as qtd_saldo_pedido            ');
      Sql.Add('     , cast(0  as DOUBLE PRECISION) as qtd_atendida_pedido         ');
      Sql.Add('     , cast(a.cod_item as Integer) as cod_mercadoria               ');
      Sql.Add('  FROM reiterlog.tab_recebimento_item a                            ');
      Sql.Add('  JOIN tab_nota_fiscal_entrada b on b.seq_nota = a.seq_recebimento ');
      Sql.Add('  JOIN tab_pessoa c on c.cod_pessoa = b.cod_pessoa_fornecedor      ');
      Sql.Add('  JOIN tab_item_nfe d on d.seq_nota = a.seq_recebimento and        ');
      Sql.Add('                         d.seq_item = a.seq_item                   ');
      Sql.Add('  JOIN tab_item e on e.cod_item = d.cod_item                       ');
      Sql.Add('  JOIN tab_unidade f on f.cod_unidade = d.cod_unidade_compra       ');
      Sql.Add('  JOIN tab_unidade g on g.cod_unidade = e.cod_unidade              ');
      Sql.Add(' WHERE Exists(SELECT 1                                             ');
      Sql.Add('                FROM reiterlog.tab_recebimento aa                  ');
      Sql.Add('               WHERE aa.ind_status = ''PE''                        ');
      Sql.Add('                 AND aa.seq_recebimento = a.seq_recebimento)       ');
      Open;
      First;
    end;

    PopularClientDataSet(cdsRecebimentoItem, qConsulta);
    Sleep(1000);
    GerarArquivo( TipoRecebimento
                , cdsRecebimento
                , cdsRecebimentoItem
                , ListErro);

    with DadosFtp do
    begin
      EnvioFTP( HostName
              , Usuario
              , Senha
              , DirRecebimentoEnvio
              , DiretorioSistema.DirArqEnvioRecebimento
              , DiretorioSistema.DirArqEnvioRecebimentoEnviados
              , Porta
              , ListErro);
    end;

    AlteraStatus( TipoRecebimento
                , 'PE'
                , 'AR'
                , ListErro);

  finally
    FreeAndNil(qConsulta);
  end;
end;

procedure TfrmPrincipal.ProcessoArquivo;
var ListErro, ListLog : TStringList;
    sHoraRecebimento : String;
    dDtaInicio, dDtaFim, dDtaSeparacao, dDtaSeparacaoUltima : TDateTime;
    bEnviaEmail : Boolean;
    sDataSeparacao : String;
    Aguarde : TFrmAguarde;
begin
  if not _bProcessoEmExecucao then
  begin
    _bProcessoEmExecucao := True;
    bEnviaEmail          := False;
    ListErro             := TStringList.Create;
    ListLog              := TStringList.Create;
    sHoraRecebimento     := ednHora.Text + ':' + ednMinuto.Text;
    dDtaInicio           := Now;
    dDtaSeparacao        := StrtoDateTime(DateToStr(dDtaInicio) + sHoraRecebimento);
    dDtaSeparacaoUltima  := StrToDateTime(ConsultaValorParametro(2));

    Aguarde := TFrmAguarde.ShowMsg('Executando Integração ReiterLog X Emsys');

    try
      if ((dDtaSeparacao > dDtaSeparacaoUltima) and
         (dDtaSeparacao <= now)) then
      begin
        ListErro.Clear;
        ExecutarProcessoArquivoSeparacao(ListErro);
        UpdateDataUltimaSeparacao(ListErro);

        if (ListErro.CommaText <> '') then
        begin
          bEnviaEmail := True;
          ListLog.Add('Erro no processo de Envio de Separação.');
          ListLog.AddStrings(ListErro);
        end
        else
        begin
          ListLog.Add('Processo de Envio de Separação executado com Sucesso.');
        end;
      end;

      ListErro.Clear;

      ExecutarProcessoArquivoRecebimento(ListErro);

      if (ListErro.CommaText <> '') then
      begin
        bEnviaEmail := True;
        ListLog.Add('Erro no processo de Envio de Recebimento.');
        ListLog.AddStrings(ListErro);
      end
      else
      begin
        ListLog.Add('Processo de Envio de Recebimento executado com Sucesso.');
      end;

      ListErro.Clear;
      ExecutarProcessoRetornoSeparacao(ListErro);

      if (ListErro.CommaText <> '') then
      begin
        bEnviaEmail := True;
        ListLog.Add('Erro no processo de Retorno de Separação.');
        ListLog.AddStrings(ListErro);
      end
      else
      begin
        ListLog.Add('Processo de Retorno de Separação executado com Sucesso.');
      end;

      ListErro.Clear;
      ExecutarProcessoRetornoRecebimento(ListErro);

      if (ListErro.CommaText <> '') then
      begin
        bEnviaEmail := True;
        ListLog.Add('Erro no processo de Retorno de Recebimento.');
        ListLog.AddStrings(ListErro);
      end
      else
      begin
        ListLog.Add('Processo de Retorno de Recebimento executado com Sucesso.');
      end;

    finally
      if bEnviaEmail then
      begin
        with DadosEmail do
        begin
          EnviarEmail( Host
                     , Usuario
                     , Senha
                     , Destinatario
                     , StringReplace(ListLog.DelimitedText, ';', #13#10, [rfReplaceAll])
                     , Porta
                     , TipoAutenticacao
                     , ListErro);
        end;

        if ListErro.Text <> '' then
        begin
           ListLog.Add('Erro no processo de Envio de E-mail.');
           ListLog.AddStrings(ListErro);
        end
        else
        begin
          ListLog.Add('E-mail Enviado com sucesso.');
        end;
      end;

      dDtaFim := now;
      RegistraLog(dDtaInicio, dDtaFim, ListLog);
      FreeAndNil(ListErro);
      FreeAndNil(ListLog);
      _bProcessoEmExecucao := False;
      Aguarde.CloseMsg;
    end;
  end;
end;

procedure TfrmPrincipal.ExecutarProcessoRetornoSeparacao(
  var ListErro: TStringList);
var qConsulta : TZQuery;
    sErro : String;
begin
  qConsulta := NewZQuery;

  try
    AlteraStatus( TipoSeparacao
                , 'AR'
                , 'PR'
                , ListErro);

    with DadosFtp do
    begin
      RetornoFTP( HostName
                , Usuario
                , Senha
                , DirSeparacaoRetorno
                , DiretorioSistema.DirArqRetornoSeparacao
                , Porta
                , ListErro);
    end;

    LerArqRetornoSeparacao(ListErro);
    Sleep(1000);
    ValidarQtdRetornoSeparacao(ListErro);

    AlteraStatus( TipoSeparacao
                , 'PR'
                , 'AR'
                , ListErro);

    AlteraStatus( TipoSeparacao
                , 'AR'
                , 'PR'
                , ListErro
                , True);

    with qConsulta do
    begin
      Close;
      Sql.Clear;
      Sql.Add('SELECT a.seq_separacao           ');
      Sql.Add('  FROM reiterlog.tab_separacao a ');
      Sql.Add(' WHERE a.ind_status = ''PR''     ');
      Open;
      First;

      while not Eof do
      begin
        sErro := ListErro.CommaText;

        ProcessoCorrigiQtdPreVenda( FieldByName('seq_separacao').AsInteger
                                  , ListErro);

        if sErro = ListErro.CommaText then
          FinalizaRetornoPreVenda( FieldByName('seq_separacao').AsInteger
                                 , ListErro);

        Next;
      end;
    end;

    AlteraStatus( TipoSeparacao
                , 'PR'
                , 'F'
                , ListErro);

  finally
    FreeAndnil(qConsulta);
  end;
end;

procedure TfrmPrincipal.ExecutarProcessoRetornoRecebimento(
  var ListErro: TStringList);
var qConsulta : TZQuery;
    sErro : String;
begin
  qConsulta := NewZQuery;

  try
    AlteraStatus( TipoRecebimento
                , 'AR'
                , 'PR'
                , ListErro);

    with DadosFtp do
    begin
      RetornoFTP( HostName
                , Usuario
                , Senha
                , DirRecebimentoRetorno
                , DiretorioSistema.DirArqRetornoRecebimento
                , Porta
                , ListErro);
    end;

    LerArqRetornoRecebimento(ListErro);
    Sleep(1000);
    ValidarQtdRetornoRecebimento(ListErro);

    AlteraStatus( TipoRecebimento
                , 'PR'
                , 'AR'
                , ListErro);

    AlteraStatus( TipoRecebimento
                , 'AR'
                , 'PR'
                , ListErro
                , True);

    with qConsulta do
    begin
      Close;
      Sql.Clear;
      Sql.Add('SELECT a.seq_recebimento           ');
      Sql.Add('  FROM reiterlog.tab_recebimento a ');
      Sql.Add(' WHERE a.ind_status = ''PR''       ');
      Open;
      First;

      while not Eof do
      begin
        sErro := ListErro.CommaText;

        ProcessoTransfItensEntrada( FieldByName('seq_recebimento').AsInteger
                                  , ListErro);

        if sErro = ListErro.CommaText then
          FinalizaRetornoRecebimento( FieldByName('seq_recebimento').AsInteger
                                    , ListErro);

        Next;
      end;
    end;

    AlteraStatus( TipoRecebimento
                , 'PR'
                , 'F'
                , ListErro);
  finally
    FreeAndnil(qConsulta);
  end;
end;

procedure TfrmPrincipal.CadastroUsuario1Click(Sender: TObject);
var FUsuario : TFrmUsuarios;
begin
  if not VerificaAcesso(0, True) then
    Exit;

  FUsuario := TFrmUsuarios.Create(nil);

  try
    FUsuario.ShowModal;
  finally
    FreeAndNil(FUsuario);
  end;
end;

{ TreadProcesso }

constructor TreadProcesso.Create;
begin
  inherited Create(False);
end;

procedure TreadProcesso.Execute;
begin
  inherited;
  with frmPrincipal do
  begin
    Timer1.Interval := (StrToInt(ednRecebimento.Text) * 1000) * 60;
    Timer1.Enabled := True;
  end;
end;

procedure TfrmPrincipal.Timer1Timer(Sender: TObject);
begin
  ProcessoArquivo;
end;

procedure TfrmPrincipal.DesativarAtivarBotoes;
begin
  if not spnStop.Enabled then
  begin
    SpnIniciar.Enabled := False;
    spnStop.Enabled    := True;
  end
  else
  begin
    SpnIniciar.Enabled := True;
    spnStop.Enabled    := False;
  end;
end;

procedure TfrmPrincipal.spnStopClick(Sender: TObject);
var qConsulta : TZQuery;
    ListLog : TStringList;
    dDtaInicio : TDateTime;
begin
  if not VerificaAcesso(0, True) then
    Exit;
    
  if not SpnIniciar.Enabled then
  begin
    if not MsgQuestiona('Deseja Realmente parar a integração?') then
      Exit;

    dDtaInicio := now;

    if (FTheard <> nil) and
       (not FTheard.Terminated) then
       FTheard.Terminate;

    Timer1.Enabled := False;
    DesativarAtivarBotoes;

    qConsulta := NewZQuery;
    ListLog   := TStringList.Create;

    try
      with qConsulta do
      begin
        Close;
        Sql.Clear;
        Sql.Add('Select a.des_log                      ');
        Sql.Add('  from reiterlog.tab_log_integracao a ');
        Open;
        First;
        ListLog.Add(StringReplace( FieldByName('des_log').AsString
                                 , #13#10
                                 , ';'
                                 , [rfReplaceAll]));
      end;

      ListLog.Delimiter := ';';
      ListLog.Add('Processo parado pelo usuário: '+ Usuario.Nome);

      RegistraLog(dDtaInicio, now, ListLog);
      _bProcessoEmExecucao := False;
    finally
      FreeAndNil(qConsulta);
      FreeAndNil(ListLog);
    end;
  end;
end;

function TfrmPrincipal.BuscarBuild: String;
var
  VerInfoSize: Cardinal;
  VerValueSize: Cardinal;
  Dummy: Cardinal;
  PVerInfo: Pointer;
  PVerValue: PVSFixedFileInfo;
begin
  Result := '';
  VerInfoSize := GetFileVersionInfoSize(PChar(Application.ExeName), Dummy);
  GetMem(PVerInfo, VerInfoSize);
  try
    if GetFileVersionInfo(PChar(Application.ExeName), 0, VerInfoSize, PVerInfo) then
      if VerQueryValue(PVerInfo, '\', Pointer(PVerValue), VerValueSize) then
        with PVerValue^ do
          Result := Format('%d.%d.%d.%d', [
            HiWord(dwFileVersionMS), //Major
            LoWord(dwFileVersionMS), //Minor
            HiWord(dwFileVersionLS), //Release
            LoWord(dwFileVersionLS)]); //Build
  finally
    FreeMem(PVerInfo, VerInfoSize);
  end;
end;

procedure TfrmPrincipal.UpdateDataUltimaSeparacao(var ListErro : TStringList);
var qUpdate : TZQuery;
begin
  qUpdate := NewZQuery;

  try
    try
      if not dmPrincipal.zConexao.InTransaction then
        dmPrincipal.zConexao.StartTransaction;
        
      with qUpdate do
      begin
        Close;
        Sql.Clear;
        Sql.Add('update reiterlog.tab_parametro_integracao set val_parametro = to_char(CURRENT_TIMESTAMP,''YYYY/MM/DD HH:MI'') ');
        Sql.Add('                                        where seq_parametro = 2                                               ');
        ExecSQL;
      end;

      dmPrincipal.zConexao.Commit;
    except
      On E : Exception do
      begin
        dmPrincipal.zConexao.Rollback;
        ListErro.Add('Erro na atualizacao da ultima data de envio da separacao');
        ListErro.Add(E.Message);
      end;
    end;
  finally
    FreeAndNil(qUpdate);
  end;
end;

procedure TfrmPrincipal.Log1Click(Sender: TObject);
var FLog : TFrmLogIntegracao;
begin
  if not VerificaAcesso(Log1.Tag, True) then
    Exit;

  FLog := TFrmLogIntegracao.Create(nil);

  try
    FLog.ShowModal;
  finally
    FreeAndNil(FLog);
  end;
end;

end.
