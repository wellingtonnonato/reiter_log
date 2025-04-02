unit uFrmUsuarios;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmPadrao, ExtCtrls, DB, Grids, DBGrids, DBClient,
  ZAbstractRODataset, ZAbstractDataset, ZDataset, Buttons;

type
  TFrmUsuarios = class(TfrmPadrao)
    cdsUsuario: TClientDataSet;
    dsUsuario: TDataSource;
    DBGrid1: TDBGrid;
    cdsUsuarioseq_cad_usuario: TIntegerField;
    cdsUsuariodes_usuario: TStringField;
    cdsUsuarioind_tipo: TStringField;
    spnInserir: TSpeedButton;
    spnAlterar: TSpeedButton;
    spnExcluir: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure spnExcluirClick(Sender: TObject);
    procedure spnInserirClick(Sender: TObject);
    procedure spnAlterarClick(Sender: TObject);
    procedure DBGrid1TitleClick(Column: TColumn);
  private
    { Private declarations }
    procedure MontarSql;
  public
    { Public declarations }
  end;

var
  FrmUsuarios: TFrmUsuarios;

implementation

uses
 uProcessosFunctionGeral, uDataModulo, uFrmCadastroUsuario;

{$R *.dfm}

{ TFrmUsuarios }

procedure TFrmUsuarios.MontarSql;
var qConsulta : TZQuery;
begin
  qConsulta := NewZQuery;

  try
    with qConsulta do
    begin
      Close;
      Sql.Clear;
      Sql.Add('SELECT a.seq_cad_usuario                     ');
      Sql.Add('     , a.des_usuario                         ');
      Sql.Add('     , cast(case when a.ind_tipo = ''A''     ');
      Sql.Add('                 then ''Administrador''      ');
      Sql.Add('                 else ''Usuário''            ');
      Sql.Add('             end as varchar(60)) as ind_tipo ');
      Sql.Add('  FROM reiterlog.tab_cad_usuario a           ');
      Open;
      First;
    end;

    PopularClientDataSet(cdsUsuario, qConsulta);
  finally
    FreeAndNil(qConsulta);
  end;
end;

procedure TFrmUsuarios.FormShow(Sender: TObject);
begin
  inherited;
  MontarSql;
end;

procedure TFrmUsuarios.spnExcluirClick(Sender: TObject);
var qDelete : TZQuery;
begin
  inherited;
  if not MsgQuestiona('Deseja Realmente Excluir o Usuário?') then
    Exit;

  qDelete := NewZQuery;

  try
    try
      if not dmPrincipal.zConexao.InTransaction then
        dmPrincipal.zConexao.StartTransaction;

      with qDelete do
      begin
        Close;
        Sql.Clear;
        Sql.Add('DELETE                                      ');
        Sql.Add('  FROM reiterlog.tab_cad_usuario a          ');
        Sql.Add(' WHERE a.seq_cad_usuario = :seq_cad_usuario ');

        ParamByName('seq_cad_usuario').AsInteger := cdsUsuarioseq_cad_usuario.AsInteger;
        ExecSQL;
      end;
    except
      on E : Exception do
      begin
        dmPrincipal.zConexao.Rollback;
        MsgSistema(E.Message, 'E');
      end;
    end;
  finally
    FreeAndNil(qDelete);
  end;
end;

procedure TFrmUsuarios.spnInserirClick(Sender: TObject);
var FCadUsu : TFrmCadastroUsuario;
begin
  inherited;
  FCadUsu := TFrmCadastroUsuario.Create(nil);

  try
    FCadUsu.iCodUsuario := 0;
    FCadUsu.ShowModal;
  finally
    FreeAndNil(FCadUsu);
    MontarSql;
  end;
end;

procedure TFrmUsuarios.spnAlterarClick(Sender: TObject);
var FCadUsu : TFrmCadastroUsuario;
begin
  inherited;
  FCadUsu := TFrmCadastroUsuario.Create(nil);

  try
    FCadUsu.iCodUsuario := cdsUsuarioseq_cad_usuario.AsInteger;
    FCadUsu.ShowModal;
  finally
    FreeAndNil(FCadUsu);
    MontarSql;
  end;
end;

procedure TFrmUsuarios.DBGrid1TitleClick(Column: TColumn);
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

end.
