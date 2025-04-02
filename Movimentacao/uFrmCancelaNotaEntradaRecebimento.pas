unit uFrmCancelaNotaEntradaRecebimento;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmPadrao, ExtCtrls, Grids, DBGrids, ComCtrls, StdCtrls,
  DBCtrls, Buttons, DB, DBClient, uDataModulo,
  ZAbstractRODataset, ZAbstractDataset, ZDataset;

type
  TFrmCancelaNotaEntradaRecebimento = class(TfrmPadrao)
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
    spnEnviarRecebimento: TSpeedButton;
    dsEmpresa: TDataSource;
    cdsEmpresa: TClientDataSet;
    cdsEmpresacod_empresa: TIntegerField;
    cdsEmpresaempresa: TStringField;
    dsFornecedor: TDataSource;
    cdsFornecedor: TClientDataSet;
    cdsFornecedorcod_fornecedor: TIntegerField;
    cdsFornecedorfornecedor: TStringField;
    dsNF: TDataSource;
    cdsNF: TClientDataSet;
    cdsNFind_selecao: TStringField;
    cdsNFseq_nota: TIntegerField;
    cdsNFnum_nota: TStringField;
    cdsNFdes_fornecedor: TStringField;
    cdsNFdta_entrada: TDateTimeField;
    cdsNFdta_emissao: TDateTimeField;
    cdsNFcnpj_fornecedor: TStringField;
    cdsNFEmpresa: TStringField;
    Label4: TLabel;
    procedure DBGrid1DblClick(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure FormShow(Sender: TObject);
    procedure spnPesquisarClick(Sender: TObject);
    procedure spnEnviarRecebimentoClick(Sender: TObject);
  private
    { Private declarations }
    procedure CarregarCombos;
    procedure MontarSql;
    procedure DeletarRegistro(iSeqNota : Integer);
  public
    { Public declarations }
  end;

var
  FrmCancelaNotaEntradaRecebimento: TFrmCancelaNotaEntradaRecebimento;

implementation

uses
 uProcessosFunctionGeral, uFrmAguarde;

{$R *.dfm}

procedure TFrmCancelaNotaEntradaRecebimento.CarregarCombos;
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

procedure TFrmCancelaNotaEntradaRecebimento.DBGrid1DblClick(
  Sender: TObject);
begin
  inherited;
  if ((Sender as TDBGrid).DataSource.Dataset.IsEmpty) then
    Exit;

  (Sender as TDBGrid).DataSource.Dataset.Edit;

  (Sender as TDBGrid).DataSource.Dataset.FieldByName('ind_selecao').AsString :=
    IfThen((Sender as TDBGrid).DataSource.Dataset.FieldByName('ind_selecao').AsString = 'S', 'N', 'S');

  (Sender as TDBGrid).DataSource.Dataset.Post;
end;

procedure TFrmCancelaNotaEntradaRecebimento.DBGrid1DrawColumnCell(
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

procedure TFrmCancelaNotaEntradaRecebimento.DBGrid1TitleClick(
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

procedure TFrmCancelaNotaEntradaRecebimento.DeletarRegistro(
  iSeqNota: Integer);
var qDelete : TZQuery;
begin
  if not MsgQuestiona('Deseja realmenta cancelar o envio da Nota de Fisca de Entrada'+
                  ' para o Recebimento?') then
    Exit;

  qDelete := NewZQuery;
    
  try
    if not dmPrincipal.zConexao.InTransaction then
      dmPrincipal.zConexao.StartTransaction;

    try
      with qDelete do
      begin
        Close;
        Sql.Clear;
        Sql.Add('DELETE                                                      ');
        Sql.Add('  FROM reiterlog.tab_recebimento_item a                     ');
        Sql.Add(' WHERE a.seq_recebimento = :iSeqNota                        ');
        Sql.Add('   AND EXISTS(SELECT 1                                      ');
        Sql.Add('                FROM reiterlog.tab_recebimento aa           ');
        Sql.Add('               WHERE aa.seq_recebimento = a.seq_recebimento ');
        Sql.Add('                 AND aa.ind_status = ''AE'')                ');

        ParamByName('iSeqNota').Asinteger := iSeqNota;

        ExecSQL;

        Close;
        Sql.Clear;
        Sql.Add('DELETE                               ');
        Sql.Add('  FROM reiterlog.tab_recebimento a   ');
        Sql.Add(' WHERE a.seq_recebimento = :iSeqNota ');
        Sql.Add('   AND a.ind_status = ''AE''         ');

        ParamByName('iSeqNota').Asinteger := iSeqNota;
        
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
    FreeAndNil(qDelete);
  end;
end;

procedure TFrmCancelaNotaEntradaRecebimento.FormShow(Sender: TObject);
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

procedure TFrmCancelaNotaEntradaRecebimento.MontarSql;
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
    Sql.Add('   AND EXISTS(SELECT 1                                                               ');
    Sql.Add('                FROM REITERLOG.TAB_RECEBIMENTO AA                                    ');
    Sql.Add('               WHERE AA.SEQ_RECEBIMENTO = A.SEQ_NOTA                                 ');
    Sql.Add('                 AND AA.IND_STATUS = ''AE'')                                         ');

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

procedure TFrmCancelaNotaEntradaRecebimento.spnPesquisarClick(
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

procedure TFrmCancelaNotaEntradaRecebimento.spnEnviarRecebimentoClick(
  Sender: TObject);
begin
  inherited;
  if not MsgQuestiona('Deseja realmente cancelar o envio para o Recebimento?') then
    Exit;

  cdsNF.DisableControls;
  cdsNF.First;

  try
    while not cdsNF.Eof do
    begin
      if cdsNFind_selecao.AsString = 'S' then
        DeletarRegistro(cdsNFseq_nota.AsInteger);

      cdsNF.Next;
    end;
  finally
    cdsNF.EnableControls;
    MontarSql;
  end;
end;

end.
