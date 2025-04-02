unit uFrmCadastroUsuario;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmPadrao, ExtCtrls, DB, Buttons, Grids, DBGrids, DBClient,
  StdCtrls, ZAbstractRODataset, ZAbstractDataset, ZDataset;

type
  TFrmCadastroUsuario = class(TfrmPadrao)
    pnUsuario: TPanel;
    Label4: TLabel;
    edsUsuario: TEdit;
    Label2: TLabel;
    edsSenha: TEdit;
    Label1: TLabel;
    cbbTipo: TComboBox;
    gbAcesso: TGroupBox;
    cdsAcesso: TClientDataSet;
    dsAcesso: TDataSource;
    DBGrid1: TDBGrid;
    spnGravar: TSpeedButton;
    spnCancelar: TSpeedButton;
    cdsAcessoind_selecao: TStringField;
    cdsAcessoseq_acesso_integracao: TIntegerField;
    cdsAcessodes_acesso_integracao: TStringField;
    procedure FormShow(Sender: TObject);
    procedure spnCancelarClick(Sender: TObject);
    procedure spnGravarClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure cbbTipoChange(Sender: TObject);
  private
    { Private declarations }
    procedure MontarSql;
    function ValidarPreenchimento : Boolean;
    function VerificarNomeUsuario : Boolean;
    function BuscaCodUsuario : Integer;
  public
    { Public declarations }
    iCodUsuario : Integer;
  end;

var
  FrmCadastroUsuario: TFrmCadastroUsuario;

implementation

uses
 uProcessosFunctionGeral, uDataModulo;

{$R *.dfm}

{ TFrmCadastroUsuario }

procedure TFrmCadastroUsuario.MontarSql;
var qConsulta : TZQuery;
begin
  qConsulta := NewZQuery;

  try
    with qConsulta do
    begin
      Close;
      Sql.Clear;
      Sql.Add('SELECT a.des_usuario                        ');
      Sql.Add('     , a.ind_tipo                           ');
      Sql.Add('     , a.des_senha                          ');
      Sql.Add('  FROM reiterlog.tab_cad_usuario a          ');
      Sql.Add(' WHERE a.seq_cad_usuario = :seq_cad_usuario ');

      ParamByName('seq_cad_usuario').AsInteger := iCodUsuario;
      Open;
      First;

      if not IsEmpty then
      begin
        edsUsuario.text := FieldByName('des_usuario').AsString;
        edsSenha.Text   := DescodificarTexto(FieldByName('des_senha').AsString);

        if FieldByName('ind_tipo').AsString = 'A' then
          cbbTipo.ItemIndex := 0
        else
          cbbTipo.ItemIndex := 1;
      end;

      Close;
      Sql.Clear;
      Sql.Add('SELECT Cast(case :seq_cad_usuario when ''0'' then ''N''                                                            ');
      Sql.Add('                                  else case when EXISTS(SELECT 1                                                   ');
      Sql.Add('                                                          FROM reiterlog.tab_acesso_usuario aa                     ');
      Sql.Add('                                                         WHERE aa.seq_cad_usuario = :seq_cad_usuario               ');
      Sql.Add('                                                           AND aa.seq_acesso_integracao = a.seq_acesso_integracao) ');
      Sql.Add('                                            then ''S''                                                             ');
      Sql.Add('                                            else ''N''                                                             ');
      Sql.Add('                                        end                                                                        ');
      Sql.Add('             end as Char(1)) as ind_selecao                                                                        ');
      Sql.Add('     , a.seq_acesso_integracao                                                                                     ');
      Sql.Add('     , a.des_acesso_integracao                                                                                     ');
      Sql.Add('  FROM reiterlog.tab_acesso_integracao a                                                                           ');

      ParamByName('seq_cad_usuario').AsInteger := iCodUsuario;
      Open;
      First;
    end;

    PopularClientDataSet(cdsAcesso, qConsulta);
  finally
    FreeAndNil(qConsulta);
  end;
end;

procedure TFrmCadastroUsuario.FormShow(Sender: TObject);
begin
  inherited;
  MontarSql; 
end;

procedure TFrmCadastroUsuario.spnCancelarClick(Sender: TObject);
begin
  inherited;
  ModalResult := mrCancel;
end;

function TFrmCadastroUsuario.ValidarPreenchimento: Boolean;
begin
  Result := True;

  if (edsUsuario.Text = '') then
  begin
    MsgSistema('Preencher o Usuário', 'A');
    edsUsuario.SetFocus;
    Result := False;
    Exit;
  end;

  if edsSenha.Text = '' then
  begin
    MsgSistema('Preencher a Senha do Usuário', 'A');
    edsSenha.SetFocus;
    Result := False;
    Exit;
  end;

  if cbbTipo.ItemIndex = -1 then
  begin
    MsgSistema('Selecionar o Tipo do Usuário', 'A');
    cbbTipo.SetFocus;
    Result := False;
    Exit;
  end;
end;

function TFrmCadastroUsuario.VerificarNomeUsuario: Boolean;
var qConsulta : TZQuery;
begin
  Result := True;

  if edsUsuario.Text = 'IMPULSE' then
  begin
    Result := False;
    MsgSistema('Usuário padrão do Sistema não pode ser cadastrado.', 'A');
    Exit;
  end;

  qConsulta := NewZQuery;

  try
    with qConsulta do
    begin
      Close;
      Sql.Clear;
      Sql.Add('SELECT a.seq_cad_usuario                           ');
      Sql.Add('  FROM reiterlog.tab_cad_usuario a                 ');
      Sql.Add(' WHERE a.des_usuario = :des_usuario                ');
      Sql.Add('   AND ((a.seq_cad_usuario <> :seq_cad_usuario) or ');
      Sql.Add('        (:seq_cad_usuario = 0))                    ');

      ParamByName('des_usuario').AsString      := edsUsuario.Text;
      ParamByName('seq_cad_usuario').AsInteger := iCodUsuario;
      Open;
      First;

      if not IsEmpty then
      begin
        Result := False;
        MsgSistema('Usuário já cadastrado com esse nome.', 'A');
        Exit;
      end;
    end;
  finally
    FreeAndNil(qConsulta);
  end;
end;

function TFrmCadastroUsuario.BuscaCodUsuario: Integer;
var qConsulta : TZQuery;
begin
  Result := 0;

  qConsulta := NewZQuery;

  try
    with qConsulta do
    begin
      Close;
      Sql.Clear;
      Sql.Add('SELECT a.seq_cad_usuario                           ');
      Sql.Add('  FROM reiterlog.tab_cad_usuario a                 ');
      Sql.Add(' WHERE a.des_usuario = :des_usuario                ');

      ParamByName('des_usuario').AsString      := edsUsuario.Text;
      Open;
      First;

      if not IsEmpty then
      begin
        Result := FieldByName('seq_cad_usuario').AsInteger;
      end;
    end;
  finally
    FreeAndNil(qConsulta);
  end;
end;

procedure TFrmCadastroUsuario.spnGravarClick(Sender: TObject);
var qAcesso, qUsuario : TZQuery;
begin
  inherited;
  ModalResult := mrNone;
  
  if not ValidarPreenchimento then
    Exit;

  if not VerificarNomeUsuario then
    Exit;

  qAcesso  := NewZQuery;
  qUsuario := NewZQuery;

  try
    try
      if not dmPrincipal.zConexao.InTransaction then
        dmPrincipal.zConexao.StartTransaction;

      if iCodUsuario <> 0 then
      begin
        with qAcesso do
        begin
          Close;
          Sql.Clear;
          Sql.Add('Delete                                      ');
          Sql.Add('  from reiterlog.tab_acesso_usuario a       ');
          Sql.Add(' where a.seq_cad_usuario = :seq_cad_usuario ');

          ParamByName('seq_cad_usuario').AsInteger := iCodUsuario;
          ExecSQL;
        end;

        with qUsuario do
        begin
          Close;
          Sql.Clear;
          Sql.Add('update reiterlog.tab_cad_usuario a set ind_tipo = :ind_tipo                 ');
          Sql.Add('                                     , des_senha = :des_senha               ');
          Sql.Add('                                     , des_usuario = :des_usuario           ');
          Sql.Add('                                 where a.seq_cad_usuario = :seq_cad_usuario ');

          if cbbTipo.ItemIndex = 0 then
            ParamByName('ind_tipo').AsString := 'A'
          else
            ParamByName('ind_tipo').AsString := 'U';

          ParamByName('des_senha').AsString        := CodificarTexto(edsSenha.Text);
          ParamByName('des_usuario').AsString      := edsUsuario.Text;
          ParamByName('seq_cad_usuario').AsInteger := iCodUsuario;
          ExecSQL;
        end;
      end
      else
      begin
        with qUsuario do
        begin
          Close;
          Sql.Clear;
          Sql.Add('Insert into reiterlog.tab_cad_usuario ( ind_tipo      ');
          Sql.Add('                                      , des_senha     ');
          Sql.Add('                                      , des_usuario)  ');
          Sql.Add('                               Values ( :ind_tipo     ');
          Sql.Add('                                      , :des_senha    ');
          Sql.Add('                                      , :des_usuario) ');

          if cbbTipo.ItemIndex = 0 then
            ParamByName('ind_tipo').AsString := 'A'
          else
            ParamByName('ind_tipo').AsString := 'U';

          ParamByName('des_senha').AsString        := CodificarTexto(edsSenha.Text);
          ParamByName('des_usuario').AsString      := edsUsuario.Text;
          ExecSQL;

          iCodUsuario := BuscaCodUsuario;
        end;
      end;

      if (iCodUsuario <> 0) and
         (cbbTipo.ItemIndex = 1) then
      begin
        with qAcesso do
        begin
          Close;
          Sql.Clear;
          Sql.Add('Insert into reiterlog.tab_acesso_usuario( seq_cad_usuario         ');
          Sql.Add('                                        , seq_acesso_integracao)  ');
          Sql.Add('                                 Values ( :seq_cad_usuario        ');
          Sql.Add('                                        , :seq_acesso_integracao) ');

          cdsAcesso.First;

          while not cdsAcesso.Eof do
          begin
            if cdsAcessoind_selecao.AsString = 'S' then
            begin
              Close; 
              ParamByName('seq_cad_usuario').AsInteger       := iCodUsuario;
              ParamByName('seq_acesso_integracao').AsInteger := cdsAcessoseq_acesso_integracao.AsInteger;
              ExecSQL;
            end;

            cdsAcesso.Next;
          end;
        end;
      end;

      dmPrincipal.zConexao.Commit;
      ModalResult := mrOK;
    except
      on E : Exception do
      begin
        dmPrincipal.zConexao.Rollback;
        MsgSistema(E.Message, 'E');
      end;
    end;
  finally
    FreeAndNil(qAcesso);
    FreeAndNil(qUsuario);
  end;
end;

procedure TFrmCadastroUsuario.DBGrid1DblClick(Sender: TObject);
begin
  inherited;
  if ((Sender as TDBGrid).DataSource.Dataset.IsEmpty) then
    Exit;

  (Sender as TDBGrid).DataSource.Dataset.Edit;

  (Sender as TDBGrid).DataSource.Dataset.FieldByName('ind_selecao').AsString :=
    IfThen((Sender as TDBGrid).DataSource.Dataset.FieldByName('ind_selecao').AsString = 'S', 'N', 'S');

  (Sender as TDBGrid).DataSource.Dataset.Post;
end;

procedure TFrmCadastroUsuario.DBGrid1DrawColumnCell(Sender: TObject;
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

procedure TFrmCadastroUsuario.DBGrid1TitleClick(Column: TColumn);
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

procedure TFrmCadastroUsuario.cbbTipoChange(Sender: TObject);
begin
  inherited;
  if cbbTipo.ItemIndex = 0 then
    gbAcesso.Enabled := False
  else
    gbAcesso.Enabled := True;
end;

end.
