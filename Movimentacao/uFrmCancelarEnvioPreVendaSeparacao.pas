unit uFrmCancelarEnvioPreVendaSeparacao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmPadrao, ExtCtrls, Grids, DBGrids, ComCtrls, StdCtrls,
  DBCtrls, Buttons, uDataModulo, ZAbstractRODataset, ZAbstractDataset, ZDataset,
  DB, DBClient;

type
  TFrmCancelarEnvioPreVendaSeparacao = class(TfrmPadrao)
    pnFiltro: TPanel;
    spnPesquisar: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    cbbEmpresa: TDBLookupComboBox;
    cbbCliente: TDBLookupComboBox;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    dtaIni: TDateTimePicker;
    dtaFim: TDateTimePicker;
    DBGrid1: TDBGrid;
    spnEnviarRecebimento: TSpeedButton;
    Label4: TLabel;
    cdsEmpresa: TClientDataSet;
    dsEmpresa: TDataSource;
    cdsCliente: TClientDataSet;
    dsClientes: TDataSource;
    cdsEmpresacod_empresa: TIntegerField;
    cdsEmpresaempresa: TStringField;
    cdsClientecod_cliente: TIntegerField;
    cdsClienteCliente: TStringField;
    cdsPreVenda: TClientDataSet;
    dsPreVenda: TDataSource;
    cdsPreVendaind_selecao: TStringField;
    cdsPreVendaseq_pre_venda: TIntegerField;
    cdsPreVendanum_pre_venda: TStringField;
    cdsPreVendadta_emissao: TDateTimeField;
    cdsPreVendaCliente: TStringField;
    cdsPreVendaval_total_pre_venda: TFloatField;
    procedure FormShow(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure spnEnviarRecebimentoClick(Sender: TObject);
    procedure spnPesquisarClick(Sender: TObject);
  private
    { Private declarations }
    procedure MontarSql;
    procedure CarregarCombos;
    procedure DeletarRegistro(iSeqPreVenda : Integer);
  public
    { Public declarations }
  end;

var
  FrmCancelarEnvioPreVendaSeparacao: TFrmCancelarEnvioPreVendaSeparacao;

implementation

uses
 uProcessosFunctionGeral, uFrmAguarde;

{$R *.dfm}

{ TFrmCancelarEnvioPreVendaSeparacao }

procedure TFrmCancelarEnvioPreVendaSeparacao.CarregarCombos;
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

procedure TFrmCancelarEnvioPreVendaSeparacao.MontarSql;
var qConsulta : TZQuery;
    iCodCliente, iCodEmpresa : Integer;
begin
  qConsulta   := NewZQuery;
  iCodCliente := 0;
  iCodEmpresa := 0;

  if cbbCliente.KeyValue <> null then
    iCodCliente := cbbCliente.KeyValue;

  if cbbEmpresa.KeyValue <> Null then
    iCodEmpresa := cbbEmpresa.KeyValue;

  try
    with qConsulta do
    begin
      Close;
      Sql.Clear;
      Sql.Add('SELECT CAST(''N'' as char(1)) as ind_selecao                          ');
      Sql.Add('     , a.seq_pre_venda                                                ');
      Sql.Add('     , a.num_pre_venda                                                ');
      Sql.Add('     , a.dta_emissao                                                  ');
      Sql.Add('     , cast(a.cod_pessoa_cliente ||'' - ''||                          ');
      Sql.Add('            b.nom_pessoa as varchar(100)) as Cliente                  ');
      Sql.Add('     , a.val_total_pre_venda                                          ');
      Sql.Add('  FROM tab_pre_venda a                                                ');
      Sql.Add('  JOIN tab_pessoa b on b.cod_pessoa = a.cod_pessoa_cliente            ');
      Sql.Add(' WHERE a.dta_emissao BETWEEN :DataIni and :DataFim                    ');
      Sql.Add('   AND ((a.cod_pessoa_cliente = :cod_cliente) or (:cod_cliente = 0))  ');
      Sql.Add('   AND ((a.cod_empresa = :cod_empresa) or (:cod_empresa = 0))         ');
      Sql.Add('   AND Exists(Select 1                                                ');
      Sql.Add('                from reiterlog.tab_separacao aa                       ');
      Sql.Add('               where aa.seq_separacao = a.seq_pre_venda               ');
      Sql.Add('                 and aa.ind_status = ''AE'')                          ');
      Sql.Add(' ORDER BY a.dta_emissao asc                                           ');

      ParamByName('DataIni').AsDateTime       := dtaIni.Date;
      ParamByName('DataFim').AsDateTime       := dtaFim.Date;
      ParamByName('cod_cliente').AsInteger    := iCodCliente;
      ParamByName('cod_empresa').AsInteger    := iCodEmpresa;

      Open;
      First;
    end;

    PopularClientDataSet(cdsPreVenda, qConsulta);
  finally
    FreeAndNil(qConsulta);
  end;
end;

procedure TFrmCancelarEnvioPreVendaSeparacao.FormShow(Sender: TObject);
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

procedure TFrmCancelarEnvioPreVendaSeparacao.DBGrid1DblClick(
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

procedure TFrmCancelarEnvioPreVendaSeparacao.DBGrid1DrawColumnCell(
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

procedure TFrmCancelarEnvioPreVendaSeparacao.DBGrid1TitleClick(
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

procedure TFrmCancelarEnvioPreVendaSeparacao.DeletarRegistro(
  iSeqPreVenda: Integer);
var qDelete : TZQuery;
begin
  qDelete := NewZQuery;
    
  try
    if not dmPrincipal.zConexao.InTransaction then
      dmPrincipal.zConexao.StartTransaction;

    try
      with qDelete do
      begin
        Close;
        Sql.Clear;
        Sql.Add('DELETE                                                  ');
        Sql.Add('  FROM reiterlog.tab_separacao_item a                   ');
        Sql.Add(' WHERE a.seq_separacao = :iSeqPreVenda                  ');
        Sql.Add('   AND EXISTS(SELECT 1                                  ');
        Sql.Add('                FROM reiterlog.tab_separacao aa         ');
        Sql.Add('               WHERE aa.seq_separacao = a.seq_separacao ');
        Sql.Add('                 AND aa.ind_status = ''AE'')            ');

        ParamByName('iSeqPreVenda').Asinteger := iSeqPreVenda;

        ExecSQL;

        Close;
        Sql.Clear;
        Sql.Add('DELETE                                 ');
        Sql.Add('  FROM reiterlog.tab_separacao a       ');
        Sql.Add(' WHERE a.seq_separacao = :iSeqPreVenda ');
        Sql.Add('   AND a.ind_status = ''AE''           ');

        ParamByName('iSeqPreVenda').Asinteger := iSeqPreVenda;
        
        ExecSQL;

        Close;
        Sql.Clear;
        Sql.Add('Update tab_item_pre_venda set ind_wms_reiterlog = ''N''    ');
        Sql.Add('                        WHERE seq_pre_venda = :iSeqPreVenda ');

        ParamByName('iSeqPreVenda').Asinteger := iSeqPreVenda;
        
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

procedure TFrmCancelarEnvioPreVendaSeparacao.spnEnviarRecebimentoClick(
  Sender: TObject);
begin
  inherited;
  if not MsgQuestiona('Deseja realmenta cancelar o envio dessa separação?') then
    Exit;

  cdsPreVenda.DisableControls;
  cdsPreVenda.First;

  try
    while not cdsPreVenda.Eof do
    begin
      if cdsPreVendaind_selecao.AsString = 'S' then
        DeletarRegistro(cdsPreVendaseq_pre_venda.AsInteger);

      cdsPreVenda.Next;
    end;
  finally
    cdsPreVenda.EnableControls;
    MontarSql;
  end;
end;

procedure TFrmCancelarEnvioPreVendaSeparacao.spnPesquisarClick(
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

end.
