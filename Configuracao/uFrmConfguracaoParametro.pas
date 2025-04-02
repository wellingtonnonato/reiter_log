unit uFrmConfguracaoParametro;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmPadrao, ComCtrls, ExtCtrls, uDataModulo, DB,
  ZAbstractRODataset, ZAbstractDataset, ZDataset, StdCtrls, DBCtrls, Grids,
  DBGrids, DBClient, Math, Buttons;

type
  TFrmConfguracaoParametro = class(TfrmPadrao)
    pgPrincipal: TPageControl;
    MenuLateral: TTreeView;
    tbsEmpresa: TTabSheet;
    cdsEmpresaCadastradas: TClientDataSet;
    dsEmrpesaCadastradas: TDataSource;
    GroupBox1: TGroupBox;
    DBGrid1: TDBGrid;
    cdsEmpresaCadastradascod_empresa: TIntegerField;
    cdsEmpresaCadastradasnom_empresa: TStringField;
    cdsEmpresaCadastradasnum_cnpj: TStringField;
    spdGravar: TSpeedButton;
    spnCancelar: TSpeedButton;
    cdsEmpresaCadastradasind_selecao: TStringField;
    procedure FormShow(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure MenuLateralChange(Sender: TObject; Node: TTreeNode);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure spdGravarClick(Sender: TObject);
    procedure spnCancelarClick(Sender: TObject);
  private
    { Private declarations }
    procedure CarregaEmpresas;
    procedure GravaParametros;
    function PegarNomeTabela(sCampoHit : String) : String;
    function PegarNomeCampo(sCampoHit : String) : String;
    Function AtualizaParametro(iSeqParametro : Integer; sValor : String) : Boolean;
  public
    { Public declarations }
  end;

var
  FrmConfguracaoParametro: TFrmConfguracaoParametro;

implementation

uses
 uProcessosFunctionGeral;

{$R *.dfm}

procedure TFrmConfguracaoParametro.FormShow(Sender: TObject);
begin
  inherited;
  if not dmPrincipal.Conectado then
  begin
    MsgSistema('É necessário configurar a conexão com a Base de Dados'
              , 'E');

    PostMessage(Handle, WM_CLOSE, 0, 0);
  end;

  CarregaEmpresas;
end;

procedure TFrmConfguracaoParametro.DBGrid1DrawColumnCell(Sender: TObject;
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

procedure TFrmConfguracaoParametro.DBGrid1DblClick(Sender: TObject);
begin
  inherited;
  if ((Sender as TDBGrid).DataSource.Dataset.IsEmpty) then
    Exit;

  (Sender as TDBGrid).DataSource.Dataset.Edit;

  (Sender as TDBGrid).DataSource.Dataset.FieldByName('ind_selecao').AsString :=
    IfThen((Sender as TDBGrid).DataSource.Dataset.FieldByName('ind_selecao').AsString = 'S', 'N', 'S');

  (Sender as TDBGrid).DataSource.Dataset.Post;
end;

procedure TFrmConfguracaoParametro.CarregaEmpresas;
var qConsulta : TZQuery;
    sEmpresa : String;
begin
  qConsulta := NewZQuery;
  sEmpresa  := ConsultaValorParametro(1);

  try
    with qConsulta do
    begin
      Close;
      Sql.Clear;

      if sEmpresa <> '' then
      begin
        Sql.Add('SELECT cast(case when Exists(Select 1                                   ');
        Sql.Add('                               from tab_empresa aa                      ');
        Sql.Add('                              where aa.cod_empresa = a.cod_empresa      ');
        Sql.Add('                                and aa.cod_empresa in ('+ sEmpresa +')) ');
        Sql.Add('                 then ''S''                                             ');
        Sql.Add('                 else ''N''                                             ');
        Sql.Add('             end as char(1)) as ind_selecao                             ');
      end
      else
      begin
        Sql.Add('SELECT cast(''N'' as char(1)) as ind_selecao                            ');
      end;

      Sql.Add('     , a.cod_empresa                                                    ');
      Sql.Add('     , coalesce(a.nom_fantasia, a.nom_razao_social) as nom_empresa      ');
      Sql.Add('     , a.num_cnpj                                                       ');
      Sql.Add('  FROM tab_empresa a                                                    ');
      Sql.Add(' Order By a.cod_empresa                                                 ');
      Open;
      First;
    end;

    PopularClientDataSet(cdsEmpresaCadastradas, qConsulta);
    cdsEmpresaCadastradas.First;
  finally
    FreeAndNil(qConsulta);
  end;
end;

procedure TFrmConfguracaoParametro.MenuLateralChange(Sender: TObject;
  Node: TTreeNode);
begin
  inherited;
  pgPrincipal.ActivePageIndex := MenuLateral.Selected.SelectedIndex;
end;

procedure TFrmConfguracaoParametro.DBGrid1TitleClick(Column: TColumn);
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

procedure TFrmConfguracaoParametro.GravaParametros;
var i, iTag, c : Integer;
    ListValor, ListErroParametro : TStringList;
    sNomeCampo, sNomeTabela, sNomeClientDataSet : String;
    ComponetClientDataSet : TComponent;
begin
  if not dmPrincipal.zConexao.InTransaction then
    dmPrincipal.zConexao.StartTransaction;

  ListValor         := TStringList.Create;
  ListErroParametro := TStringList.Create;
  try
    for i := 0 to Self.ComponentCount - 1 do
    begin
      if Self.Components[i].Tag <> 0 then
      begin
        iTag := Self.Components[i].Tag;

        if (Self.Components[i].ClassName = 'TDBGrid') then
        begin
          sNomeCampo            := PegarNomeCampo(TDBGrid(Self.Components[i]).Hint);
          sNomeClientDataSet    := TClientDataSet(TDBGrid(Self.Components[i]).DataSource.Dataset).Name;
          ComponetClientDataSet := FindComponent(sNomeClientDataSet);

          with TClientDataSet(ComponetClientDataSet) do
          begin
            if State in [dsEdit, dsInsert] then
              Post;

            ListValor.Clear;
            Last;
            First;

            while not Eof do
            begin
              if FieldByName('ind_selecao').AsString = 'S' then
              begin
                ListValor.Add(FieldByName(sNomeCampo).AsString);
              end;

              Next;
            end;

            if VerificaRegistro( 'reiterlog.tab_parametro_integracao'
                               , 'seq_parametro'
                               , iTag) then
            begin
              if not AtualizaParametro(iTag, ListValor.CommaText) then
              begin
                ListErroParametro.Add(IntToStr(iTag) +  ' - ' + ListValor.CommaText);
              end;
            end;
          end;
        end;
      end;
    end;

    try
      dmPrincipal.zConexao.Commit;
    except
      on E : Exception do
      begin
        ListErroParametro.Add(E.Message);
        dmPrincipal.zConexao.Rollback;
      end;
    end;
  finally
    if ListErroParametro.CommaText <> '' then
    begin
      MsgSistema('Erros ao inserir os parametros: '+ #13#10 +
                 ListErroParametro.CommaText, 'E');
    end;

    FreeAndNil(ListValor);
    FreeAndNil(ListErroParametro);
  end;
end;

function TFrmConfguracaoParametro.PegarNomeTabela(
  sCampoHit: String): String;
var a, b : integer;
begin
  a := length(sCampoHit);
  b := pos(',', sCampoHit);

  Result := Trim(copy( sCampoHit
                     , 1
                     , b - 1));
end;

function TFrmConfguracaoParametro.PegarNomeCampo(
  sCampoHit: String): String;
var a, b : integer;
begin
  a := length(sCampoHit);
  b := pos(',', sCampoHit);

  Result := Trim(copy( sCampoHit
                     , b + 1
                     , a - b));
end;

function TFrmConfguracaoParametro.AtualizaParametro(
  iSeqParametro: Integer; sValor : String): Boolean;
var qAtu : TZQuery;
begin
  Result := True;
  qAtu := NewZQuery;

  try
    with qAtu do
    begin
      try
        Close;
        Sql.Clear;
        Sql.Add('UPDATE reiterlog.tab_parametro_integracao SET val_parametro = :val_parametro ');
        Sql.Add('                                        WHERE seq_parametro = :seq_parametro ');

        ParamByName('seq_parametro').AsInteger := iSeqParametro;
        ParamByName('val_parametro').AsString  := sValor;
        ExecSQL;
      Except
        Result := False;
      end;
    end;
  finally
    FreeAndNil(qAtu);
  end;
end;

procedure TFrmConfguracaoParametro.spdGravarClick(Sender: TObject);
begin
  inherited;
  GravaParametros;
  ModalResult := mrOK;
end;

procedure TFrmConfguracaoParametro.spnCancelarClick(Sender: TObject);
begin
  inherited;
  ModalResult := mrCancel;
end;

end.
