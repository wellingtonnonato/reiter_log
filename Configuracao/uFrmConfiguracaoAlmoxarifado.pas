unit uFrmConfiguracaoAlmoxarifado;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmPadrao, ExtCtrls, DB, DBClient, Buttons, Grids, DBGrids,
  StdCtrls, DBCtrls, ZAbstractRODataset, ZAbstractDataset, ZDataset;

type
  TFrmConfiguracaoAlmoxarifado = class(TfrmPadrao)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    DBGrid1: TDBGrid;
    spnInserir: TSpeedButton;
    SpnExcluir: TSpeedButton;
    spdGravar: TSpeedButton;
    spnCancelar: TSpeedButton;
    cdsEmpresa: TClientDataSet;
    dsEmpresa: TDataSource;
    cdsEmpresacod_empresa: TIntegerField;
    cdsEmpresanom_empresa: TStringField;
    cdsAlmoxInt: TClientDataSet;
    dsAlmoxInt: TDataSource;
    cdsAlmoxIntcod_almoxarifado: TIntegerField;
    cdsAlmoxIntdes_almoxarifado: TStringField;
    cdsAlmoxPri: TClientDataSet;
    dsAlmoxPri: TDataSource;
    cdsAlmoxPricod_almoxarifado: TIntegerField;
    cdsAlmoxPrides_almoxarifado: TStringField;
    cdsCadastro: TClientDataSet;
    dsCadastro: TDataSource;
    cdsCadastrocod_empresa: TIntegerField;
    cdsCadastrocod_almoxarifado_intermediario: TIntegerField;
    cdsCadastrocod_almoxarifado_final: TIntegerField;
    cdsCadastrodes_almoxarifado_intermediario: TStringField;
    cdsCadastrodes_almoxarifado_final: TStringField;
    cdsEmpresaempresa: TStringField;
    cdsAlmoxIntalmoxarifado: TStringField;
    cdsAlmoxPrialmoxarifado: TStringField;
    cbbEmpresa: TDBLookupComboBox;
    cbbAlmoxInt: TDBLookupComboBox;
    cbbAlmoxPri: TDBLookupComboBox;
    cdsCadastrosequencia: TIntegerField;
    Label4: TLabel;
    cbbAlmoxDiferenca: TDBLookupComboBox;
    cdsCadastrocod_almoxarifado_diferenca: TIntegerField;
    cdsCadastrodes_almoxarifado_diferenca: TStringField;
    cdsCadastroind_tipo: TStringField;
    cdsCadastromovimentacao: TStringField;
    cbbMovimentacao: TComboBox;
    Label5: TLabel;
    cdsAlmoxDiferenca: TClientDataSet;
    dsAlmoxDiferenca: TDataSource;
    cdsAlmoxDiferencacod_amoxarifado: TIntegerField;
    cdsAlmoxDiferencades_almoxarifado: TStringField;
    cdsAlmoxDiferencaalmoxarifado: TStringField;
    procedure FormShow(Sender: TObject);
    procedure dsEmpresaDataChange(Sender: TObject; Field: TField);
    procedure FormCreate(Sender: TObject);
    procedure SpnExcluirClick(Sender: TObject);
    procedure spnInserirClick(Sender: TObject);
    procedure spdGravarClick(Sender: TObject);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure spnCancelarClick(Sender: TObject);
  private
    { Private declarations }
    ListDelete : TStringList;
    procedure CarregarEmpresa;
    procedure CarregarAlmoxarifado;
    procedure CarregarGrid;
    function ValidarPreenchimento : Boolean;
    procedure InserirGrid;
    procedure GravarCadastro;
  public
    { Public declarations }
  end;

var
  FrmConfiguracaoAlmoxarifado: TFrmConfiguracaoAlmoxarifado;

implementation

uses uDataModulo, uProcessosFunctionGeral;

{$R *.dfm}

procedure TFrmConfiguracaoAlmoxarifado.CarregarAlmoxarifado;
var qConsulta : TZQuery;
begin
  if cbbEmpresa.KeyValue = null then
    Exit;

  cbbAlmoxInt.KeyValue       := null;
  cbbAlmoxPri.KeyValue       := null;
  cbbAlmoxDiferenca.KeyValue := null;

  qConsulta := NewZQuery;

  try
    with qConsulta do
    begin
      Close;
      Sql.Clear;
      Sql.Add('SELECT a.cod_almoxarifado                                       ');
      Sql.Add('     , a.des_almoxarifado                                       ');
      Sql.Add('     , cast(a.cod_almoxarifado ||'' - ''||                      ');
      Sql.Add('            a.des_almoxarifado as VARCHAR(100)) as almoxarifado ');
      Sql.Add('  FROM tab_almoxarifado a                                       ');
      Sql.Add(' WHERE a.cod_empresa = :cod_empresa                             ');
      Sql.Add(' Order by a.cod_almoxarifado asc                                ');
      ParamByName('cod_empresa').AsInteger := cbbEmpresa.KeyValue;
      Open;
      First;
    end;

    PopularClientDataSet(cdsAlmoxInt, qConsulta);
    PopularClientDataSet(cdsAlmoxPri, qConsulta);
    PopularClientDataSet(cdsAlmoxDiferenca, qConsulta);
  Finally
    FreeAndNil(qConsulta);
  end;
end;

procedure TFrmConfiguracaoAlmoxarifado.CarregarEmpresa;
var qConsulta : TZQuery;
    sEmpresa : String;
begin
  qConsulta := NewZQuery;
  sEmpresa  := ConsultaValorParametro(1);

  try
    if sEmpresa = '' then
    begin
      MsgSistema('É necessário configurar a Empresa no Parametros.', 'E');
      Exit;
    end;


    with qConsulta do
    begin
      Close;
      Sql.Clear;
      Sql.Add('SELECT a.cod_empresa                                                                 ');
      Sql.Add('     , coalesce(a.nom_fantasia, a.nom_razao_social) as nom_empresa                   ');
      Sql.Add('     , cast(a.cod_empresa ||'' - ''||                                                ');
      Sql.Add('            coalesce(a.nom_fantasia, a.nom_razao_social) as varchar(100)) as empresa ');
      Sql.Add('  FROM tab_empresa a                                                                 ');
      Sql.Add(' WHERE a.cod_empresa in ('+ sEmpresa +')                                             ');
      Sql.Add(' Order by a.cod_empresa asc                                                          ');
      Open;
      First;
    end;

    PopularClientDataSet(cdsEmpresa, qConsulta);
  Finally
    FreeAndNil(qConsulta);
  end;
end;

procedure TFrmConfiguracaoAlmoxarifado.FormShow(Sender: TObject);
begin
  inherited;
  if not dmPrincipal.Conectado then
  begin
    MsgSistema('É necessário configurar a conexão com a Base de Dados'
              , 'E');

    PostMessage(Handle, WM_CLOSE, 0, 0);
  end;

  CarregarEmpresa;
  CarregarGrid;
end;

procedure TFrmConfiguracaoAlmoxarifado.dsEmpresaDataChange(Sender: TObject;
  Field: TField);
begin
  inherited;
  CarregarAlmoxarifado;
  cbbMovimentacao.ItemIndex := -1;
end;

procedure TFrmConfiguracaoAlmoxarifado.CarregarGrid;
var qConsulta : TZQuery;
begin
  qConsulta := NewZQuery;

  with qConsulta do
  begin
    Close;
    Sql.Clear;
    Sql.Add('SELECT a.seq_rel_almoxarifado_intermediario as sequencia                           ');
    Sql.Add('     , a.ind_tipo                                                                  ');
    Sql.Add('     , CAST(case a.ind_tipo                                                        ');
    Sql.Add('            when ''A'' then ''Ambas''                                              ');
    Sql.Add('            when ''E'' then ''Entrada''                                            ');
    Sql.Add('            when ''D'' then ''Devolução''                                          ');
    Sql.Add('             end as varchar(60)) as Movimentacao                                   ');
    Sql.Add('     , a.cod_empresa                                                               ');
    Sql.Add('     , a.cod_almoxarifado_intermediario                                            ');
    Sql.Add('     , b.des_almoxarifado as des_almoxarifado_intermediario                        ');
    Sql.Add('     , a.cod_almoxarifado_final                                                    ');
    Sql.Add('     , c.des_almoxarifado as des_almoxarifado_final                                ');
    Sql.Add('     , a.cod_almoxarifado_diferenca                                                ');
    Sql.Add('     , d.des_almoxarifado as des_almoxarifado_diferenca                            ');
    Sql.Add('  FROM reiterlog.tab_rel_almoxarifado_intermediario a                              ');
    Sql.Add('  JOIN tab_almoxarifado b on b.cod_almoxarifado = a.cod_almoxarifado_intermediario ');
    Sql.Add('  JOIN tab_almoxarifado c on c.cod_almoxarifado = a.cod_almoxarifado_final         ');
    Sql.Add('  JOIN tab_almoxarifado d on d.cod_almoxarifado = a.cod_almoxarifado_diferenca     ');
    Open;
    First;
  end;

  PopularClientDataSet(cdsCadastro, qConsulta);
end;

procedure TFrmConfiguracaoAlmoxarifado.FormCreate(Sender: TObject);
begin
  inherited;
  ListDelete := TStringList.Create;
end;

procedure TFrmConfiguracaoAlmoxarifado.SpnExcluirClick(Sender: TObject);
begin
  inherited;
  if cdsCadastro.IsEmpty then
    Exit;

  if cdsCadastrosequencia.AsInteger > 0 then
    ListDelete.Add(IntToStr(cdsCadastrosequencia.AsInteger));

  cdsCadastro.Delete;
end;

procedure TFrmConfiguracaoAlmoxarifado.spnInserirClick(Sender: TObject);
begin
  inherited;
  if not ValidarPreenchimento then
    Exit;

  InserirGrid;
end;

function TFrmConfiguracaoAlmoxarifado.ValidarPreenchimento: Boolean;
begin
  Result := True;

  if cbbEmpresa.KeyValue = null then
  begin
    MsgSistema('É necessário selecionar a empresa', 'A');
    Result := False;
    cbbEmpresa.SetFocus;
    Exit;
  end;

  if cbbAlmoxInt.KeyValue = null then
  begin
    MsgSistema('É necessário selecionar o almoxarifado intermediario', 'A');
    Result := False;
    cbbAlmoxInt.SetFocus;
    Exit;
  end;

  if cbbAlmoxPri.KeyValue = null then
  begin
    MsgSistema('É necessário selecionar o almoxarifado principal', 'A');
    Result := False;
    cbbAlmoxPri.SetFocus;
    Exit;
  end;

  if cbbAlmoxDiferenca.KeyValue = null then
  begin
    MsgSistema('É necessário selecionar o almoxarifado de diferença', 'A');
    Result := False;
    cbbAlmoxDiferenca.SetFocus;
    Exit;
  end;

  if cbbMovimentacao.ItemIndex < 0 then
  begin
    MsgSistema('É necessário selecionar o tipo da movimentação', 'A');
    Result := False;
    cbbMovimentacao.SetFocus;
    Exit;
  end;

  if cbbAlmoxInt.KeyValue = cbbAlmoxPri.KeyValue then
  begin
    MsgSistema('O almoxarifado intermediario é o mesmo do principal', 'A');
    Result := False;
    cbbAlmoxInt.SetFocus;
    Exit;
  end;

  if (cbbAlmoxDiferenca.KeyValue = cbbAlmoxInt.KeyValue) or
     (cbbAlmoxDiferenca.KeyValue = cbbAlmoxPri.KeyValue) then
  begin
    MsgSistema('O almoxarifado de diferença tem que ser diferente dos demais almoxarifados', 'A');
    Result := False;
    cbbAlmoxDiferenca.SetFocus;
    Exit;
  end;

  if cbbMovimentacao.ItemIndex = 0 then
  begin
    cdsCadastro.First;

    if cdsCadastro.locate('cod_empresa; cod_almoxarifado_intermediario'
                         , VarArrayOf([ cbbEmpresa.KeyValue
                                      , cbbAlmoxInt.KeyValue])
                         , []) then
    begin
      MsgSistema('Almoxarifado Intermediario já cadastrado', 'A');
      Result := False;
      cbbAlmoxInt.SetFocus;
      Exit;
    end;
  end
  else if cbbMovimentacao.ItemIndex = 1 then
  begin
    cdsCadastro.First;

    if cdsCadastro.locate('cod_empresa; cod_almoxarifado_intermediario; ind_tipo'
                         , VarArrayOf([ cbbEmpresa.KeyValue
                                      , cbbAlmoxInt.KeyValue
                                      , 'E'])
                         , []) then
    begin
      MsgSistema('Almoxarifado Intermediario já cadastrado', 'A');
      Result := False;
      cbbAlmoxInt.SetFocus;
      Exit;
    end;

    if cdsCadastro.locate('cod_empresa; cod_almoxarifado_intermediario; ind_tipo'
                         , VarArrayOf([ cbbEmpresa.KeyValue
                                      , cbbAlmoxInt.KeyValue
                                      , 'A'])
                         , []) then
    begin
      MsgSistema('Almoxarifado Intermediario já cadastrado para ambas movimentações', 'A');
      Result := False;
      cbbAlmoxInt.SetFocus;
      Exit;
    end;
  end
  else
  begin
    cdsCadastro.First;

    if cdsCadastro.locate('cod_empresa; cod_almoxarifado_intermediario; ind_tipo'
                         , VarArrayOf([ cbbEmpresa.KeyValue
                                      , cbbAlmoxInt.KeyValue
                                      , 'D'])
                         , []) then
    begin
      MsgSistema('Almoxarifado Intermediario já cadastrado', 'A');
      Result := False;
      cbbAlmoxInt.SetFocus;
      Exit;
    end;

    if cdsCadastro.locate('cod_empresa; cod_almoxarifado_intermediario; ind_tipo'
                         , VarArrayOf([ cbbEmpresa.KeyValue
                                      , cbbAlmoxInt.KeyValue
                                      , 'A'])
                         , []) then
    begin
      MsgSistema('Almoxarifado Intermediario já cadastrado para ambas movimentações', 'A');
      Result := False;
      cbbAlmoxInt.SetFocus;
      Exit;
    end;
  end;
end;

procedure TFrmConfiguracaoAlmoxarifado.spdGravarClick(Sender: TObject);
var qInsert, qDelete : TZQuery;
begin
  inherited;
  GravarCadastro;
  ModalResult := mrOK;
end;

procedure TFrmConfiguracaoAlmoxarifado.GravarCadastro;
var qInsert, qDelete : TZQuery;
begin
  qInsert := NewZQuery;
  qDelete := NewZQuery;
  cdsCadastro.DisableControls;

  if not dmPrincipal.zConexao.InTransaction then
     dmPrincipal.zConexao.StartTransaction;

  try
    try
      if ListDelete.CommaText <> '' then
      begin
        with qDelete do
        begin
          Close;
          Sql.Clear;
          Sql.Add('DELETE                                                                      ');
          Sql.Add('  FROM reiterlog.tab_rel_almoxarifado_intermediario a                       ');
          Sql.Add(' WHERE a.seq_rel_almoxarifado_intermediario in ('+ ListDelete.CommaText +') ');
          ExecSql;
        end;
      end;

      with qInsert do
      begin
        Close;
        Sql.Clear;
        Sql.Add('INSERT INTO reiterlog.tab_rel_almoxarifado_intermediario( cod_empresa                     ');
        Sql.Add('                                                        , cod_almoxarifado_intermediario  ');
        Sql.Add('                                                        , cod_almoxarifado_final          ');
        Sql.Add('                                              									 , cod_almoxarifado_diferenca      ');
        Sql.Add('                                                        , ind_tipo)                       ');
        Sql.Add('                                                  VALUES( :cod_empresa                    ');
        Sql.Add('                                                        , :cod_almoxarifado_intermediario ');
        Sql.Add('                                                        , :cod_almoxarifado_final         ');
        Sql.Add('                                                   				 , :cod_almoxarifado_diferenca     ');
        Sql.Add('                                                        , :ind_tipo)                      ');

        cdsCadastro.First;

        while not cdsCadastro.Eof do
        begin
          if cdsCadastrosequencia.AsInteger = 0 then
          begin
            Close;
            ParamByName('cod_empresa').AsInteger                    := cdsCadastrocod_empresa.AsInteger;
            ParamByName('cod_almoxarifado_intermediario').AsInteger := cdsCadastrocod_almoxarifado_intermediario.AsInteger;
            ParamByName('cod_almoxarifado_final').AsInteger         := cdsCadastrocod_almoxarifado_final.AsInteger;
            ParamByName('cod_almoxarifado_diferenca').AsInteger     := cdsCadastrocod_almoxarifado_diferenca.AsInteger;
            ParamByName('ind_tipo').AsString                        := cdsCadastroind_tipo.AsString;
            ExecSQL;
          end;

          cdsCadastro.Next;
        end;
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
    FreeAndNil(qInsert);
    FreeAndNil(qDelete);
    cdsCadastro.EnableControls;
  end;
end;

procedure TFrmConfiguracaoAlmoxarifado.DBGrid1TitleClick(Column: TColumn);
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

procedure TFrmConfiguracaoAlmoxarifado.spnCancelarClick(Sender: TObject);
begin
  inherited;
  ModalResult := mrCancel;
end;

procedure TFrmConfiguracaoAlmoxarifado.InserirGrid;
begin
  cdsAlmoxInt.First;
  cdsAlmoxInt.Locate('cod_almoxarifado'
                    , cbbAlmoxInt.KeyValue
                    , []);

  cdsAlmoxPri.First;
  cdsAlmoxPri.Locate('cod_almoxarifado'
                    , cbbAlmoxPri.KeyValue
                    , []);

  cdsAlmoxDiferenca.First;
  cdsAlmoxDiferenca.Locate('cod_almoxarifado'
                          , cbbAlmoxDiferenca.KeyValue
                          , []);

  cdsCadastro.Append;
  cdsCadastrosequencia.AsInteger                      := 0;
  cdsCadastrocod_empresa.AsInteger                    := cbbEmpresa.KeyValue;
  cdsCadastrocod_almoxarifado_intermediario.AsInteger := cbbAlmoxInt.KeyValue;
  cdsCadastrodes_almoxarifado_intermediario.AsString  := cdsAlmoxIntdes_almoxarifado.AsString;
  cdsCadastrocod_almoxarifado_final.AsInteger         := cbbAlmoxPri.KeyValue;
  cdsCadastrodes_almoxarifado_final.AsString          := cdsAlmoxPrides_almoxarifado.AsString;
  cdsCadastrocod_almoxarifado_diferenca.AsInteger     := cbbAlmoxDiferenca.KeyValue;
  cdsCadastrodes_almoxarifado_diferenca.AsString      := cdsAlmoxDiferencades_almoxarifado.AsString;
  cdsCadastromovimentacao.AsString                    := cbbMovimentacao.Text;

  if cbbMovimentacao.ItemIndex = 0 then
    cdsCadastroind_tipo.AsString := 'A'
  else if cbbMovimentacao.ItemIndex = 1 then
    cdsCadastroind_tipo.AsString := 'E'
  else if cbbMovimentacao.ItemIndex = 2 then
    cdsCadastroind_tipo.AsString := 'D';

  cdsCadastro.Post;
end;

end.
