unit uFrmMonitoramentoSeparacao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, DB, DBClient, Grids, DBGrids, StdCtrls, ComCtrls,
  DBCtrls, Buttons, uDataModulo, ZAbstractRODataset, ZAbstractDataset, ZDataset;

type
  TFrmMonitoramentoSeparacao = class(TForm)
    pnFiltro: TPanel;
    spnPesquisar: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    cbbEmpresa: TDBLookupComboBox;
    cbbCliente: TDBLookupComboBox;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    dtaIni: TDateTimePicker;
    dtaFim: TDateTimePicker;
    cbbStatus: TComboBox;
    DBGrid1: TDBGrid;
    dsEmpresa: TDataSource;
    cdsEmpresa: TClientDataSet;
    cdsEmpresacod_empresa: TIntegerField;
    cdsEmpresaempresa: TStringField;
    dsSeparacao: TDataSource;
    cdsSeparacao: TClientDataSet;
    TmSeparacao: TTimer;
    cdsCliente: TClientDataSet;
    cdsClientecod_cliente: TIntegerField;
    cdsClienteCliente: TStringField;
    dsClientes: TDataSource;
    cdsSeparacaoseq_pre_venda: TIntegerField;
    cdsSeparacaonum_pre_venda: TStringField;
    cdsSeparacaodta_emissao: TDateTimeField;
    cdsSeparacaonom_pessoa: TStringField;
    cdsSeparacaonum_cnpj_cpf: TStringField;
    cdsSeparacaostatus: TStringField;
    cdsSeparacaoval_total_pre_venda: TFloatField;
    spnRetornarStatus: TSpeedButton;
    cdsSeparacaoind_status: TStringField;
    spnLiberarEdicao: TSpeedButton;
    cdsSeparacaoind_selecao: TStringField;
    chkPararAtualizacaoGrid: TCheckBox;
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure spnPesquisarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure dsSeparacaoDataChange(Sender: TObject; Field: TField);
    procedure spnRetornarStatusClick(Sender: TObject);
    procedure spnLiberarEdicaoClick(Sender: TObject);
    procedure TmSeparacaoTimer(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
  private
    { Private declarations }
    _sStatus : String;
    _iCodCliente, _iCodEmpresa : Integer;
    _dDtaIni, _dDtaFim : TDate;
    procedure CarregarCombos;
    procedure MontarSql;
  public
    { Public declarations }
  end;

var
  FrmMonitoramentoSeparacao: TFrmMonitoramentoSeparacao;

implementation

uses
 uProcessosFunctionGeral, uFrmAguarde;

{$R *.dfm}

{ TFrmMonitoramentoSeparacao }

procedure TFrmMonitoramentoSeparacao.CarregarCombos;
var qConsulta : TZQuery;
    sEmpresa : String;
begin
  sEmpresa  := ConsultaValorParametro(1);
  qConsulta := NewZQuery;

  try
    with qConsulta do
    begin
      Close;
      Sql.Clear;
      Sql.Add('SELECT a.cod_empresa                                                                 ');
      Sql.Add('     , cast(a.cod_empresa ||'' - ''||                                                ');
      Sql.Add('            coalesce(a.nom_fantasia, a.nom_razao_social) as varchar(100)) as Empresa ');
      Sql.Add('  FROM tab_empresa a                                                                 ');
      Sql.Add(' WHERE a.cod_empresa in ('+ sEmpresa +')                                             ');
      Sql.Add(' ORDER BY a.cod_empresa asc                                                          ');

      Open;
      First;
    end;

    PopularClientDataSet(cdsEmpresa, qConsulta);

    with qConsulta do
    begin
      Close;
      Sql.Clear;
      Sql.Add('SELECT a.cod_pessoa as cod_cliente                                            ');
      Sql.Add('     , cast(a.cod_pessoa ||'' - ''|| a.nom_pessoa as varchar(100)) as Cliente ');
      Sql.Add('  FROM tab_pessoa a                                                           ');
      Sql.Add(' WHERE coalesce(a.ind_cliente, ''N'') = ''S''                                 ');
      Sql.Add('   and Exists(Select 1                                                        ');
      Sql.Add('                from tab_pre_venda aa                                         ');
      Sql.Add('               where aa.cod_pessoa_cliente = a.cod_pessoa)                    ');
      Sql.Add(' ORDER BY a.nom_pessoa asc                                                    ');
      Open;
      First;
    end;

    PopularClientDataSet(cdsCliente, qConsulta);
  finally
    FreeAndNil(qConsulta);
  end;
end;

procedure TFrmMonitoramentoSeparacao.MontarSql;
var qConsulta : TZQuery;
begin
  qConsulta := NewZQuery;


  with qConsulta do
  begin
    Close;
    Sql.Clear;
    Sql.Add('SELECT cast(''N'' as char(1)) as ind_selecao                           ');
    Sql.Add('     , b.seq_pre_venda                                                 ');
    Sql.Add('     , b.num_pre_venda                                                 ');
    Sql.Add('     , b.dta_emissao                                                   ');
    Sql.Add('     , c.nom_pessoa                                                    ');
    Sql.Add('     , c.num_cnpj_cpf                                                  ');
    Sql.Add('     , cast(case a.ind_status when ''AE'' THEN ''Aguardando Envio''    ');
    Sql.Add('                              when ''PE'' THEN ''Processando Envio''   ');
    Sql.Add('                              when ''AR'' THEN ''Aguardando Retorno''  ');
    Sql.Add('                              when ''PR'' THEN ''Processando Retorno'' ');
    Sql.Add('                              when ''F''  THEN ''Finalizado''          ');
    Sql.Add('                              when ''LE'' THEN ''Liberado p/ Editar''  ');
    Sql.Add('             end as VARCHAR(60)) as status                             ');
    Sql.Add('     , b.val_total_pre_venda                                           ');
    Sql.Add('     , a.ind_status                                                    ');
    Sql.Add('  FROM reiterlog.tab_separacao a                                       ');
    Sql.Add('  JOIN tab_pre_venda b on b.seq_pre_venda = a.seq_separacao            ');
    Sql.Add('  JOIN tab_pessoa c on c.cod_pessoa = b.cod_pessoa_cliente             ');
    Sql.Add(' WHERE a.dta_separacao BETWEEN :DataIni and :DataFim                   ');
    Sql.Add('   AND ((a.ind_status = :ind_status) or (:ind_status = ''T''))         ');
    Sql.Add('   AND ((b.cod_pessoa_cliente = :cod_cliente) or (:cod_cliente = 0))   ');
    Sql.Add('   AND ((b.cod_empresa = :cod_empresa) or (:cod_empresa = 0))          ');

    ParamByName('DataIni').AsDate        := _dDtaIni;
    ParamByName('DataFim').AsDate        := _dDtaFim;
    ParamByName('ind_status').AsString   := _sStatus;
    ParamByName('cod_cliente').AsInteger := _iCodCliente;
    ParamByName('cod_empresa').AsInteger := _iCodEmpresa;

    Open;
    First;
  end;

  PopularClientDataSet(cdsSeparacao, qConsulta);
end;

procedure TFrmMonitoramentoSeparacao.DBGrid1TitleClick(Column: TColumn);
var vlbMesmoCampo: Boolean;
    vloIndices: TStrings;
    vliCont: Integer;
begin
  inherited;
  vlbMesmoCampo := False;
  vloIndices    := TStringList.Create;
  TClientDataSet(Column.Grid.DataSource.DataSet).GetIndexNames(vloIndices);
  TClientDataSet(Column.Grid.DataSource.DataSet).IndexName := EmptyStr;
  vliCont       := vloIndices.IndexOf('idx' + Column.FieldName);

  if vliCont >= 0 then
  begin
    vlbMesmoCampo := not (ixDescending in TClientDataSet(Column.Grid.DataSource.DataSet).IndexDefs[vliCont].Options);
    TClientDataSet(Column.Grid.DataSource.DataSet).DeleteIndex('idx' + Column.FieldName);
  end;

  TClientDataSet(Column.Grid.DataSource.DataSet).AddIndex( 'idx' + Column.FieldName, Column.FieldName
                                                         , []
                                                         , IfThen( vlbMesmoCampo
                                                                 , Column.FieldName
                                                                 , ''));

  TClientDataSet(Column.Grid.DataSource.DataSet).IndexName := 'idx' + Column.FieldName;
end;

procedure TFrmMonitoramentoSeparacao.spnPesquisarClick(Sender: TObject);
var Aguarde : TFrmAguarde;
begin
  TmSeparacao.Enabled := False;

  _dDtaIni := dtaIni.Date;
  _dDtaFim := dtaFim.Date;

  if cbbEmpresa.KeyValue <> null then
    _iCodEmpresa := cbbEmpresa.KeyValue
  else
    _iCodEmpresa := 0;

  if cbbCliente.KeyValue <> null then
    _iCodCliente := cbbCliente.KeyValue
  else
    _iCodCliente := 0;

  if cbbStatus.ItemIndex = 0 then
    _sStatus := 'T'
  else if cbbStatus.ItemIndex = 1 then
    _sStatus := 'AE'
  else if cbbStatus.ItemIndex = 2 then
    _sStatus := 'PE'
  else if cbbStatus.ItemIndex = 3 then
    _sStatus := 'AR'
  else if cbbStatus.ItemIndex = 4 then
    _sStatus := 'PR'
  else if cbbStatus.ItemIndex = 5 then
    _sStatus := 'F'
  else if cbbStatus.ItemIndex = 6 then
    _sStatus := 'LE'
  else
    _sStatus := 'T';

  TmSeparacao.Interval := 60000;
  TmSeparacao.Enabled := True;
  Aguarde := TFrmAguarde.ShowMsg('Pesquisando');

  try
    MontarSql;
  finally
    Aguarde.CloseMsg;
  end
end;

procedure TFrmMonitoramentoSeparacao.FormCreate(Sender: TObject);
begin
  TmSeparacao.Enabled := False;
end;

procedure TFrmMonitoramentoSeparacao.FormShow(Sender: TObject);
var Aguarde : TFrmAguarde;
begin
  inherited;
  Aguarde := TFrmAguarde.ShowMsg('Carregando Dados para Preenchimento da tela');

  try
    CarregarCombos;
    dtaIni.Date := Now - 1;
    dtaFim.Date := Now;
  finally
    Aguarde.CloseMsg;
  end;

  {if not dmPrincipal.Conectado then
  begin
    MsgSistema('É necessário configurar a conexão com a Base de Dados'
              , 'E');

    PostMessage(Handle, WM_CLOSE, 0, 0);
  end;}
end;

procedure TFrmMonitoramentoSeparacao.dsSeparacaoDataChange(Sender: TObject;
  Field: TField);
begin
  {if cdsSeparacaoind_status.AsString = 'AR' then
    spnRetornarStatus.Enabled := True
  else
    spnRetornarStatus.Enabled := False;

  if cdsSeparacaoind_status.AsString = 'F' then
    spnLiberarEdicao.Enabled := True
  else
    spnLiberarEdicao.Enabled := False;}
end;

procedure TFrmMonitoramentoSeparacao.spnRetornarStatusClick(
  Sender: TObject);
var ListErro : TStringList;
    bManterParadoGrid : Boolean;
begin
  if not VerificaAcesso(0, True) then
    Exit;

  if not MsgQuestiona('Deseja Realmente alterar o Status?' +#13#10 +
                      'Esse processo irá retornar o status somente das Separações que estão Aguardando o Retorno') then
    Exit;

  ListErro := TStringList.Create;

  if chkPararAtualizacaoGrid.Checked then
    bManterParadoGrid := True
  else
  begin
    bManterParadoGrid := False;
    chkPararAtualizacaoGrid.Checked := TRue;
  end;

  cdsSeparacao.First;
  cdsSeparacao.DisableControls;

  try
    while not cdsSeparacao.Eof do
    begin
      if cdsSeparacaoind_selecao.AsString = 'S' then
      begin
        AlteraStatus( TipoSeparacao
                    , 'AR'
                    , 'AE'
                    , ListErro
                    , False
                    , cdsSeparacaoseq_pre_venda.AsInteger);

        GravaLogMovimento( TipoSeparacao
                         , 'Alterando o Status de Aguardando Retorno para Aguardando Envio.'
                         , cdsSeparacaoseq_pre_venda.AsInteger
                         , ListErro);
      end;

      cdsSeparacao.Next;
    end;
  finally
    if ListErro.CommaText <> '' then
      MsgSistema(ListErro.CommaText, 'E');

    FreeAndNil(ListErro);
    cdsSeparacao.EnableControls;
    MontarSql;

    if not bManterParadoGrid then
      chkPararAtualizacaoGrid.Checked := False;
  end;

end;

procedure TFrmMonitoramentoSeparacao.spnLiberarEdicaoClick(
  Sender: TObject);
var ListErro : TStringList;
    bManterParadoGrid : Boolean;
begin
  if not VerificaAcesso(0, True) then
    Exit;

  if not MsgQuestiona('Deseja Realmente Liberar a Pré-Venda para Edição?' + #13#10 +
                      'Esse processo irá liberar somente as Separações Finalizadas e '+
                      'as que estão Aguardando Retorno') then
    Exit;

  ListErro := TStringList.Create;

  if chkPararAtualizacaoGrid.Checked then
    bManterParadoGrid := True
  else
  begin
    bManterParadoGrid := False;
    chkPararAtualizacaoGrid.Checked := TRue;
  end;

  cdsSeparacao.First;
  cdsSeparacao.DisableControls;

  try
    while not cdsSeparacao.Eof do
    begin
      if cdsSeparacaoind_selecao.AsString = 'S' then
      begin
        AlteraStatus( TipoSeparacao
                    , ''
                    , 'LE'
                    , ListErro
                    , False
                    , cdsSeparacaoseq_pre_venda.AsInteger
                    , False);

        {AlteraStatus( TipoSeparacao
                    , 'AR'
                    , 'LE'
                    , ListErro
                    , False
                    , cdsSeparacaoseq_pre_venda.AsInteger
                    , False);}

        GravaLogMovimento( TipoSeparacao
                         , 'Liberou a separação para edição na pré venda.'
                         , cdsSeparacaoseq_pre_venda.AsInteger
                         , ListErro);
      end;

      cdsSeparacao.Next;
    end;

    MontarSql;
  finally
    if ListErro.CommaText <> '' then
      MsgSistema(ListErro.CommaText, 'E');

    FreeAndNil(ListErro);

    cdsSeparacao.EnableControls;
    MontarSql;

    if not bManterParadoGrid then
      chkPararAtualizacaoGrid.Checked := False;
  end;

end;

procedure TFrmMonitoramentoSeparacao.TmSeparacaoTimer(Sender: TObject);
begin
  if not chkPararAtualizacaoGrid.Checked then
    MontarSql;
end;

procedure TFrmMonitoramentoSeparacao.DBGrid1DblClick(Sender: TObject);
begin
  inherited;
  if ((Sender as TDBGrid).DataSource.Dataset.IsEmpty) then
    Exit;

  (Sender as TDBGrid).DataSource.Dataset.Edit;

  (Sender as TDBGrid).DataSource.Dataset.FieldByName('ind_selecao').AsString :=
    IfThen((Sender as TDBGrid).DataSource.Dataset.FieldByName('ind_selecao').AsString = 'S', 'N', 'S');

  (Sender as TDBGrid).DataSource.Dataset.Post;
end;

procedure TFrmMonitoramentoSeparacao.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var Check: Integer;
    R: TRect;
begin
  inherited;
  if ((Sender as TDBGrid).DataSource.Dataset.IsEmpty) then
    Exit;

  // Desenha um checkbox no dbgrid
  if LowerCase(Column.FieldName) = 'ind_selecao' then
  begin
    TDBGrid(Sender).Canvas.FillRect(Rect);

    if ((Sender as TDBGrid).DataSource.Dataset.FieldByName('ind_selecao').AsString = 'S') then
      Check := DFCS_CHECKED
    else
      Check := 0;

    R := Rect;
    InflateRect(R, -2, -2); { Diminue o tamanho do CheckBox }
    DrawFrameControl(TDBGrid(Sender).Canvas.Handle, R, DFC_BUTTON,
      DFCS_BUTTONCHECK or Check);
  end;
end;

end.
