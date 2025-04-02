unit uDataModulo;

interface

uses
  SysUtils, Classes, ADODB, DB, IniFiles, ZAbstractConnection, ZConnection,
  ZAbstractRODataset, ZAbstractDataset, ZDataset, ZDbcIntfs, Types, ZClasses;

type
  TdmPrincipal = class(TDataModule)
    zConexao: TZConnection;
    ZQuery1: TZQuery;
  private
    { Private declarations }
    _sBaseDados, _sServidor, _sUsuario, _sSenha : String;
    _iPorta : Integer;

    procedure LerArquivoIniBaseDados;
  public
    { Public declarations }
    function ConectaDataBase : Boolean;
    function Conectado : Boolean;
  end;

var
  dmPrincipal: TdmPrincipal;

implementation

uses
 uProcessosFunctionGeral, uFrmAguarde;

{$R *.dfm}

{ TdmPrincipal }

function TdmPrincipal.ConectaDataBase: Boolean;
var Aguarde : TFrmAguarde;
begin
  Result     := False;

  try
    LerIni;

    try
      Aguarde := TFrmAguarde.ShowMsg('Validando Conexão a Base de Dados');

      with zConexao, DadosConexao do
      begin
        if (BaseDados = '') or
           (Servidor = '') or
           (Usuario = '') or
           (Senha = '') then
        begin
          Result := False;
          Exit;
        end;


        if Connected then
          Disconnect;

        Database    := BaseDados;
        HostName    := Servidor;
        Port        := Porta;
        User        := Usuario;
        Password    := Senha;
        Connect;

        Result := Connected;
      end;
    finally
      Aguarde.CloseMsg;
    end;
  except
    on E : Exception do
    begin
      MsgSistema( E.Message, 'E');
      Exit;
    end;
  end;
end;

function TdmPrincipal.Conectado: Boolean;
begin
  Result := zConexao.Connected;
end;

procedure TdmPrincipal.LerArquivoIniBaseDados;
var ArqIni : TIniFile;
    diretorio : String;
begin
  diretorio := ParamStr(0);
  diretorio := ExtractFilePath(diretorio);
  ArqIni    := TIniFile.Create(diretorio + 'ReiterLog.ini');

  try
    _sServidor  := ArqIni.ReadString('BaseDados', 'Servidor', '');
    _sBaseDados := ArqIni.ReadString('BaseDados', 'Alias', '');
    _sUsuario   := ArqIni.ReadString('BaseDados', 'Usuario', '');
    _sSenha     := DescodificarTexto(ArqIni.ReadString('BaseDados', 'Senha', ''));
    _iPorta     := ArqIni.ReadInteger('BaseDados', 'Porta', 5432);
  finally
    FreeAndNil(ArqIni);
  end;
end;

end.
