unit uFrmMonitoramentoRecebimento;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, DBClient, ExtCtrls, Grids, DBGrids, ComCtrls,
  DBCtrls, Buttons, uDataModulo, ZAbstractRODataset, ZAbstractDataset, ZDataset;

type
  TFrmMonitoramentoRecebimento = class(TForm)
    pnFiltro: TPanel;
    spnPesquisar: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    cbbEmpresa: TDBLookupComboBox;
    cbbFornecedor: TDBLookupComboBox;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    dtaIni: TDateTimePicker;
    dtaFim: TDateTimePicker;
    DBGrid1: TDBGrid;
    TmRecebimento: TTimer;
    cdsRecebimento: TClientDataSet;
    dsRecebimento: TDataSource;
    cbbStatus: TComboBox;
    Label4: TLabel;
    cdsEmpresa: TClientDataSet;
    cdsEmpresacod_empresa: TIntegerField;
    cdsEmpresaempresa: TStringField;
    dsEmpresa: TDataSource;
    dsFornecedor: TDataSource;
    cdsFornecedor: TClientDataSet;
    cdsFornecedorcod_fornecedor: TIntegerField;
    cdsFornecedorfornecedor: TStringField;
    cdsRecebimentonum_nota: TStringField;
    cdsRecebimentonum_serie: TStringField;
    cdsRecebimentodta_emissao: TDateTimeField;
    cdsRecebimentodta_entrada: TDateTimeField;
    cdsRecebimentonom_pessoa: TStringField;
    cdsRecebimentonum_cnpj_cpf: TStringField;
    cdsRecebimentostatus: TStringField;
    spnRetornarStatus: TSpeedButton;
    cdsRecebimentoind_status: TStringField;
    cdsRecebimentoseq_recebimento: TIntegerField;
    cdsRecebimentoind_selecao: TStringField;
    chkPararAtualizacaoGrid: TCheckBox;
    spnExcluirRecebimento: TSpeedButton;
    procedure spnPesquisarClick(Sender: TObject);
    procedure TmRecebimentoTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure dsRecebimentoDataChange(Sender: TObject; Field: TField);
    procedure spnRetornarStatusClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure spnExcluirRecebimentoClick(Sender: TObject);
  private
    { Private declarations }
    _sStatus : String;
    _iCodFornecedor, _iCodEmpresa : Integer;
    _dDtaIni, _dDtaFim : TDate;
    procedure MontarSql;
    procedure CarregarCombos;
  public
    { Public declarations }
  end;

var
  FrmMonitoramentoRecebimento: TFrmMonitoramentoRecebimento;

implementation

uses
 uProcessosFunctionGeral, uFrmAguarde;

{$R *.dfm}

{ TFrmMonitoramentoRecebimento }

procedure TFrmMonitoramentoRecebimento.MontarSql;
var qConsulta : TZQuery;
begin
  qConsulta := NewZQuery;


  with qConsulta do
  begin
    Close;
    Sql.Clear;
    Sql.Add('SELECT a.seq_recebimento                                                      ');
    Sql.Add('     , b.num_nota                                                             ');
    Sql.Add('     , b.num_serie                                                            ');
    Sql.Add('     , b.dta_emissao                                                          ');
    Sql.Add('     , b.dta_entrada                                                          ');
    Sql.Add('     , c.nom_pessoa                                                           ');
    Sql.Add('     , c.num_cnpj_cpf                                                         ');
    Sql.Add('     , cast(case a.ind_status when ''AE'' THEN ''Aguardando Envio''           ');
    Sql.Add('                              when ''PE'' THEN ''Processando Envio''          ');
    Sql.Add('                              when ''AR'' THEN ''Aguardando Retorno''         ');
    Sql.Add('                              when ''PR'' THEN ''Processando Retorno''        ');
    Sql.Add('                              when ''F''  THEN ''Finalizado''                 ');
    Sql.Add('             end as VARCHAR(60)) as status                                    ');
    Sql.Add('     , a.ind_status                                                           ');
    Sql.Add('  FROM reiterlog.tab_recebimento a                                            ');
    Sql.Add('  JOIN tab_nota_fiscal_entrada b on b.seq_nota = a.seq_recebimento            ');
    Sql.Add('  JOIN tab_pessoa c on c.cod_pessoa = b.cod_pessoa_fornecedor                 ');
    Sql.Add(' WHERE a.dta_recebimento BETWEEN :DataIni and :DataFim                        ');
    Sql.Add('   AND ((a.ind_status = :ind_status) or (:ind_status = ''T''))                ');
    Sql.Add('   AND ((b.cod_pessoa_fornecedor = :cod_fornecedor) or (:cod_fornecedor = 0)) ');
    Sql.Add('   AND ((b.cod_empresa = :cod_empresa) or (:cod_empresa = 0))                 ');

    ParamByName('DataIni').AsDate       := _dDtaIni;
    ParamByName('DataFim').AsDate       := _dDtaFim;
    ParamByName('ind_status').AsString      := _sStatus;
    ParamByName('cod_fornecedor').AsInteger := _iCodFornecedor;
    ParamByName('cod_empresa').AsInteger    := _iCodEmpresa;

    Open;
    First;
  end;

  PopularClientDataSet(cdsRecebimento, qConsulta);
end;

procedure TFrmMonitoramentoRecebimento.spnPesquisarClick(Sender: TObject);
var Aguarde : TFrmAguarde;
begin
  TmRecebimento.Enabled := False;

  _dDtaIni := dtaIni.Date;
  _dDtaFim := dtaFim.Date;

  if cbbEmpresa.KeyValue <> null then
    _iCodEmpresa := cbbEmpresa.KeyValue
  else
    _iCodEmpresa := 0;

  if cbbFornecedor.KeyValue <> null then
    _iCodFornecedor := cbbFornecedor.KeyValue
  else
    _iCodFornecedor := 0;

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
  else
    _sStatus := 'T';

  TmRecebimento.Interval := 60000;
  TmRecebimento.Enabled := True;

  Aguarde := TFrmAguarde.ShowMsg('Pesquisando');

  try
    MontarSql;
  finally
    Aguarde.CloseMsg;
  end;
end;

procedure TFrmMonitoramentoRecebimento.TmRecebimentoTimer(Sender: TObject);
begin
  if not chkPararAtualizacaoGrid.Checked then
    MontarSql;
end;

procedure TFrmMonitoramentoRecebimento.FormCreate(Sender: TObject);
begin
  TmRecebimento.Enabled := False;
end;

procedure TFrmMonitoramentoRecebimento.CarregarCombos;
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
      Sql.Add('SELECT a.cod_pessoa as cod_fornecedor                                            ');
      Sql.Add('     , cast(a.cod_pessoa ||'' - ''|| a.nom_pessoa as varchar(100)) as Fornecedor ');
      Sql.Add('  FROM tab_pessoa a                                                              ');
      Sql.Add(' WHERE coalesce(a.ind_fornecedor, ''N'') = ''S''                                 ');
      Sql.Add(' ORDER BY a.nom_pessoa asc                                                       ');
      Open;
      First;
    end;

    PopularClientDataSet(cdsFornecedor, qConsulta);
  finally
    FreeAndNil(qConsulta);
  end;
end;

procedure TFrmMonitoramentoRecebimento.FormShow(Sender: TObject);
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

procedure TFrmMonitoramentoRecebimento.DBGrid1TitleClick(Column: TColumn);
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

procedure TFrmMonitoramentoRecebimento.dsRecebimentoDataChange(
  Sender: TObject; Field: TField);
begin
  {if cdsRecebimentoind_status.AsString = 'AR' then
    spnRetornarStatus.Enabled := True
  else
    spnRetornarStatus.Enabled := False;}
end;

procedure TFrmMonitoramentoRecebimento.spnRetornarStatusClick(
  Sender: TObject);
var ListErro : TStringList;
    bManterParadoGrid : Boolean;
begin
  if not VerificaAcesso(0, True) then
    Exit;

  if not MsgQuestiona('Deseja Realmente alterar o Status?'+ #13#10 +
                      'Esse processo irá retornar o status somente dos Recebimentos que estão Aguardando o Retorno') then
    Exit;

  ListErro := TStringList.Create;

  if chkPararAtualizacaoGrid.Checked then
    bManterParadoGrid := True
  else
  begin
    bManterParadoGrid := False;
    chkPararAtualizacaoGrid.Checked := TRue;
  end;

  cdsRecebimento.First;
  cdsRecebimento.DisableControls;

  try
    while not cdsRecebimento.Eof do
    begin
      if cdsRecebimentoind_selecao.AsString = 'S' then
      begin
        AlteraStatus( TipoRecebimento
                    , 'AR'
                    , 'AE'
                    , ListErro
                    , False
                    , cdsRecebimentoseq_recebimento.AsInteger);

        GravaLogMovimento( TipoRecebimento
                         , 'Alterando o Status de Aguardando Retorno para Aguardando Envio.'
                         , cdsRecebimentoseq_recebimento.AsInteger
                         , ListErro);
      end;

      cdsRecebimento.Next;
    end;

  finally
    if ListErro.CommaText <> '' then
      MsgSistema(ListErro.CommaText, 'E');

    FreeAndNil(ListErro);
    cdsRecebimento.EnableControls;
    MontarSql;

    if not bManterParadoGrid then
      chkPararAtualizacaoGrid.Checked := False;
  end;

end;

procedure TFrmMonitoramentoRecebimento.DBGrid1DblClick(Sender: TObject);
begin
  inherited;
  if ((Sender as TDBGrid).DataSource.Dataset.IsEmpty) then
    Exit;

  (Sender as TDBGrid).DataSource.Dataset.Edit;

  (Sender as TDBGrid).DataSource.Dataset.FieldByName('ind_selecao').AsString :=
    IfThen((Sender as TDBGrid).DataSource.Dataset.FieldByName('ind_selecao').AsString = 'S', 'N', 'S');

  (Sender as TDBGrid).DataSource.Dataset.Post;
end;

procedure TFrmMonitoramentoRecebimento.DBGrid1DrawColumnCell(
  Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
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

procedure TFrmMonitoramentoRecebimento.spnExcluirRecebimentoClick(
  Sender: TObject);
var ListErro : TStringList;
    bManterParadoGrid : Boolean;
begin
  if not VerificaAcesso(0, True) then
    Exit;

  if not MsgQuestiona('Deseja Realmente excluir o Recebimento?') then
    Exit;

  ListErro := TStringList.Create;

  if chkPararAtualizacaoGrid.Checked then
    bManterParadoGrid := True
  else
  begin
    bManterParadoGrid := False;
    chkPararAtualizacaoGrid.Checked := TRue;
  end;

  cdsRecebimento.First;
  cdsRecebimento.DisableControls;

  try
    while not cdsRecebimento.Eof do
    begin
      if cdsRecebimentoind_selecao.AsString = 'S' then
      begin
        ExcluirRecebimento(cdsRecebimentoseq_recebimento.AsInteger, ListErro);
      end;

      cdsRecebimento.Next;
    end;

  finally
    if ListErro.CommaText <> '' then
      MsgSistema(ListErro.CommaText, 'E');

    FreeAndNil(ListErro);
    cdsRecebimento.EnableControls;
    MontarSql;

    if not bManterParadoGrid then
      chkPararAtualizacaoGrid.Checked := False;
  end;

end;

end.
