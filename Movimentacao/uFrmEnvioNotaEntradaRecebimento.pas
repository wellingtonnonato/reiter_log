unit uFrmEnvioNotaEntradaRecebimento;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmPadrao, ExtCtrls, Buttons, Grids, DBGrids, ComCtrls,
  StdCtrls, DBCtrls, DB, DBClient, uDataModulo,
  ZAbstractRODataset, ZAbstractDataset, ZDataset;

type
  TFrmEnvioNotaEntradaRecebimento = class(TfrmPadrao)
    spnEnviarRecebimento: TSpeedButton;
    cdsNF: TClientDataSet;
    dsNF: TDataSource;
    cdsNFind_selecao: TStringField;
    cdsNFseq_nota: TIntegerField;
    cdsNFnum_nota: TStringField;
    cdsNFdes_fornecedor: TStringField;
    cdsNFdta_entrada: TDateTimeField;
    cdsNFdta_emissao: TDateTimeField;
    cdsNFcnpj_fornecedor: TStringField;
    cdsNFEmpresa: TStringField;
    pnFiltro: TPanel;
    DBGrid1: TDBGrid;
    spnPesquisar: TSpeedButton;
    cbbEmpresa: TDBLookupComboBox;
    Label1: TLabel;
    Label2: TLabel;
    cbbFornecedor: TDBLookupComboBox;
    GroupBox1: TGroupBox;
    dtaIni: TDateTimePicker;
    Label3: TLabel;
    dtaFim: TDateTimePicker;
    cdsEmpresa: TClientDataSet;
    dsEmpresa: TDataSource;
    cdsEmpresacod_empresa: TIntegerField;
    cdsEmpresaempresa: TStringField;
    cdsFornecedor: TClientDataSet;
    dsFornecedor: TDataSource;
    cdsFornecedorcod_fornecedor: TIntegerField;
    cdsFornecedorfornecedor: TStringField;
    procedure FormShow(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure spnPesquisarClick(Sender: TObject);
    procedure spnEnviarRecebimentoClick(Sender: TObject);
  private
    { Private declarations }
    Procedure CarregarCombos;
    Procedure MontarSql;
    Procedure InsereRecebimento(iSeqNota : Integer);
  public
    { Public declarations }
  end;

var
  FrmEnvioNotaEntradaRecebimento: TFrmEnvioNotaEntradaRecebimento;

implementation

uses
 uProcessosFunctionGeral, uFrmAguarde;

{$R *.dfm}

procedure TFrmEnvioNotaEntradaRecebimento.FormShow(Sender: TObject);
var Aguarde : TFrmAguarde;
begin
  inherited;
  Aguarde := TFrmAguarde.ShowMsg('Carregando Dados para Preenchimento da tela.');

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

procedure TFrmEnvioNotaEntradaRecebimento.DBGrid1DrawColumnCell(
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

procedure TFrmEnvioNotaEntradaRecebimento.DBGrid1DblClick(Sender: TObject);
begin
  inherited;
  if ((Sender as TDBGrid).DataSource.Dataset.IsEmpty) then
    Exit;

  (Sender as TDBGrid).DataSource.Dataset.Edit;

  (Sender as TDBGrid).DataSource.Dataset.FieldByName('ind_selecao').AsString :=
    IfThen((Sender as TDBGrid).DataSource.Dataset.FieldByName('ind_selecao').AsString = 'S', 'N', 'S');

  (Sender as TDBGrid).DataSource.Dataset.Post;
end;

procedure TFrmEnvioNotaEntradaRecebimento.DBGrid1TitleClick(
  Column: TColumn);
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

procedure TFrmEnvioNotaEntradaRecebimento.CarregarCombos;
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

procedure TFrmEnvioNotaEntradaRecebimento.MontarSql;
var qConsulta : TZQuery;
begin
  qConsulta := NewZQuery;

  with qConsulta do
  begin
    Close;
    Sql.Clear;
    Sql.Add('SELECT cast(''N'' as char(1)) as ind_selecao                                         ');
    Sql.Add('     , a.seq_nota                                                                    ');
    Sql.Add('     , a.num_nota                                                                    ');
    Sql.Add('     , cast(b.cod_pessoa ||'' - ''||                                                 ');
    Sql.Add('            b.nom_pessoa as varchar(100)) as des_fornecedor                          ');
    Sql.Add('     , a.dta_entrada                                                                 ');
    Sql.Add('     , a.dta_emissao                                                                 ');
    Sql.Add('     , b.num_cnpj_cpf as cnpj_fornecedor                                             ');
    Sql.Add('     , cast(c.cod_empresa ||'' - ''||                                                ');
    Sql.Add('            coalesce(c.nom_fantasia, c.nom_razao_social) as varchar(100)) as empresa ');
    Sql.Add('  FROM tab_nota_fiscal_entrada a                                                     ');
    Sql.Add('  JOIN tab_pessoa b on b.cod_pessoa = a.cod_pessoa_fornecedor                        ');
    Sql.Add('  JOIN tab_empresa c on c.cod_empresa = a.cod_empresa                                ');
    Sql.Add(' WHERE a.dta_entrada BETWEEN :dataIni and :dataFim                                   ');
    Sql.Add('   AND NOT EXISTS(SELECT 1                                                           ');
    Sql.Add('                    FROM REITERLOG.TAB_RECEBIMENTO AA                                ');
    Sql.Add('                   WHERE AA.SEQ_RECEBIMENTO = A.SEQ_NOTA)                            ');

    if cbbFornecedor.KeyValue <> null then
      Sql.Add('   AND a.cod_pessoa_fornecedor = :cod_Fornecedor ');

    if cbbEmpresa.KeyValue <> Null then
      Sql.Add('   AND a.cod_empresa = :cod_empresa ');

    ParamByName('dataIni').AsDate := dtaIni.Date;
    ParamByName('dataFim').AsDate := dtaFim.Date;

    if cbbFornecedor.KeyValue <> null then
      ParamByName('cod_Fornecedor').AsInteger := cbbFornecedor.KeyValue;

    if cbbEmpresa.KeyValue <> Null then
      ParamByName('cod_empresa').AsInteger := cbbEmpresa.KeyValue;

    Open;
    First;
  end;

  PopularClientDataSet(cdsNF, qConsulta);
end;

procedure TFrmEnvioNotaEntradaRecebimento.spnPesquisarClick(
  Sender: TObject);
var Aguarde : TFrmAguarde;
begin
  inherited;
  Aguarde := TFrmAguarde.ShowMsg('Pesquisando');

  try
    MontarSql;
  finally
    Aguarde.CloseMsg;
  end;
end;


procedure TFrmEnvioNotaEntradaRecebimento.InsereRecebimento(iSeqNota : Integer);
var qInsere : TZQuery;
begin
  qInsere := NewZQuery;

  try
    if not dmPrincipal.zConexao.InTransaction then
      dmPrincipal.zConexao.StartTransaction;

    try
      with qInsere do
      begin
        Close;
        Sql.Clear;
        Sql.Add('INSERT INTO reiterlog.tab_recebimento( seq_recebimento                                                             ');
        Sql.Add('                                     , dta_recebimento                                                             ');
        Sql.Add('                                     , dta_atualizacao                                                             ');
        Sql.Add('                                     , ind_status                                                                  ');
        Sql.Add('                                     , ind_tipo                                                                    ');
        Sql.Add('                                     , ind_finalizado                                                              ');
        Sql.Add('                                     , seq_trans_almox_principal                                                   ');
        Sql.Add('                                     , seq_trans_almox_diferenca                                                   ');
        Sql.Add('                                     , num_nota                                                                    ');
        Sql.Add('                                     , num_serie                                                                   ');
        Sql.Add('                                     , num_cnpj)                                                                   ');
        Sql.Add('                               SELECT a.seq_nota                                                                   ');
        Sql.Add('                                    , CURRENT_DATE                                                                 ');
        Sql.Add('                                    , CURRENT_TIMESTAMP                                                            ');
        Sql.Add('                                    , cast(''AE'' as char(2))                                                      ');
        Sql.Add('                                    , cast(case when coalesce(b.ind_devolucao, ''N'') = ''S''                      ');
        Sql.Add('                                                then ''D''                                                         ');
        Sql.Add('                                                else ''E''                                                         ');
        Sql.Add('                                            end as char(1))                                                        ');
        Sql.Add('                                    , ''N''                                                                        ');
        Sql.Add('                                    , Null                                                                         ');
        Sql.Add('                                    , Null                                                                         ');
        Sql.Add('                                    , a.num_nota                                                                   ');
        Sql.Add('                                    , a.num_serie                                                                  ');
        Sql.Add('                                    , c.num_cnpj_cpf                                                               ');
        Sql.Add('                                 FROM tab_nota_fiscal_entrada a                                                    ');
        Sql.Add('                                 JOIN tab_natureza_operacao b on b.cod_natureza_operacao = a.cod_natureza_operacao ');
        Sql.Add('                                 JOIN tab_pessoa c on c.cod_pessoa = a.cod_pessoa_fornecedor                       ');
        Sql.Add('                                WHERE a.seq_nota = :seq_nota                                                       ');

        ParamByName('seq_nota').Asinteger := iSeqNota;
        ExecSQL;

        Close;
        Sql.Clear;
        Sql.Add('INSERT INTO reiterlog.tab_recebimento_item( seq_recebimento                                                ');
        Sql.Add('                                          , seq_item                                                       ');
        Sql.Add('                                          , cod_item                                                       ');
        Sql.Add('                                          , qtd_convertida                                                 ');
        Sql.Add('                                          , qtd_item                                                       ');
        Sql.Add('                                          , cod_unidade                                                    ');
        Sql.Add('                                          , qtd_unidade                                                    ');
        Sql.Add('                                          , qtd_retornada                                                  ');
        Sql.Add('                                          , qtd_diferenca)                                                 ');
        Sql.Add('                                     SELECT a.seq_nota                                                     ');
        Sql.Add('                                          , a.seq_item                                                     ');
        Sql.Add('                                          , a.cod_item                                                     ');
        Sql.Add('                                          , a.qtd_item_convertido                                          ');
        Sql.Add('                                          , a.qtd_item                                                     ');
        Sql.Add('                                          , a.cod_unidade_compra                                           ');
        Sql.Add('                                          , cast((a.qtd_item_convertido / a.qtd_item) as Double Precision) ');
        Sql.Add('                                          , 0                                                              ');
        Sql.Add('                                          , 0                                                              ');
        Sql.Add('                                       FROM tab_item_nfe a                                                 ');
        Sql.Add('                                      WHERE a.seq_nota = :seq_nota                                         ');

        ParamByName('seq_nota').Asinteger := iSeqNota;
        ExecSQL;
      end;

      dmPrincipal.zConexao.Commit;
    except
      on E : Exception do
      begin
        MsgSistema(E.Message, 'E');
        dmPrincipal.zConexao.Rollback;
      end;
    end;
  finally
    FreeAndNil(qInsere);
  end;
end;

procedure TFrmEnvioNotaEntradaRecebimento.spnEnviarRecebimentoClick(
  Sender: TObject);
var ListNfErro : TStringList;
    qConsulta : TZQuery;
begin
  inherited;
  ListNfErro := TStringList.Create;
  qConsulta  := NewZQuery;
  cdsNF.DisableControls;
  cdsNF.First;

  try
    with qConsulta do
    begin
      Close;
      Sql.Clear;
      Sql.Add('SELECT count(a.seq_item) as QtdReg                                               ');
      Sql.Add('  FROM tab_item_nfe a                                                            ');
      Sql.Add(' WHERE a.seq_nota = :seq_nota                                                    ');
      Sql.Add('   AND not Exists(SELECT 1                                                       ');
      Sql.Add('                    FROM reiterlog.tab_rel_almoxarifado_intermediario aa         ');
      Sql.Add('                   WHERE aa.cod_almoxarifado_intermediario = a.cod_almoxarifado) ');
    end;

    while not cdsNF.Eof do
    begin
      if cdsNFind_selecao.AsString = 'S' then
      begin
        with qConsulta do
        begin
          Close;
          ParamByName('seq_nota').AsInteger := cdsNFseq_nota.AsInteger;
          Open;
          First;

          if FieldByName('QtdReg').AsInteger > 0 then
          begin
            if ListNfErro.CommaText = '' then
              ListNfErro.Add('Não foi possível enviar NF de Entrada, pois existe itens '+
                             'com o almoxarifado diferente do almoxarifado intermediario '+
                             'configurado para o WMS do Reiter Log.');

            ListNfErro.Add(IntToStr(cdsNFseq_nota.AsInteger));
          end
          else
          begin
            InsereRecebimento(cdsNFseq_nota.AsInteger);
            GravaLogMovimento( TipoRecebimento
                             , 'Enviando para a Integração.'
                             , cdsNFseq_nota.AsInteger
                             , ListNfErro);
          end;
        end;
      end;

      cdsNF.Next;
    end;
  finally
    if ListNfErro.CommaText <> '' then
      MsgSistema(ListNfErro.CommaText, 'A');

    FreeAndNil(ListNfErro);
    FreeAndNil(qConsulta);
    cdsNF.EnableControls;
    MontarSql;
  end;
end;

end.
