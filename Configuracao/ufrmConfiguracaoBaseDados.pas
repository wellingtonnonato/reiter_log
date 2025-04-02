unit uFrmConfiguracaoBaseDados;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmPadrao, ExtCtrls, StdCtrls, Buttons, IniFiles, ZDbcIntfs, Types, ZClasses;

type
  TFrmConfiguracaoBaseDados = class(TfrmPadrao)
    lbl1: TLabel;
    edsBaseDados: TEdit;
    Label1: TLabel;
    edsUsuario: TEdit;
    Label2: TLabel;
    edsSenha: TEdit;
    Label3: TLabel;
    ednPorta: TEdit;
    Label4: TLabel;
    edsServidor: TEdit;
    spdGravar: TSpeedButton;
    spnCancelar: TSpeedButton;
    SpeedButton1: TSpeedButton;
    procedure spdGravarClick(Sender: TObject);
    procedure spnCancelarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
    procedure LerIni;
  public
    { Public declarations }
  end;

var
  FrmConfiguracaoBaseDados: TFrmConfiguracaoBaseDados;

implementation

uses
 uProcessosFunctionGeral, uDataModulo, ZAbstractConnection;

{$R *.dfm}

procedure TFrmConfiguracaoBaseDados.LerIni;
var ArqIni : TIniFile;
    diretorio : String;
begin
  diretorio := ParamStr(0);
  diretorio := ExtractFilePath(diretorio);
  ArqIni    := TIniFile.Create(diretorio + 'ReiterLog.ini');

  try
    edsServidor.Text  := ArqIni.ReadString('BaseDados', 'Servidor', '');
    edsBaseDados.Text := ArqIni.ReadString('BaseDados', 'Alias', '');
    edsUsuario.Text   := ArqIni.ReadString('BaseDados', 'Usuario', '');
    edsSenha.Text     := DescodificarTexto(ArqIni.ReadString('BaseDados', 'Senha', ''));
    ednPorta.Text     := IntToStr(ArqIni.ReadInteger('BaseDados', 'Porta', 5432));
  finally
    FreeAndNil(ArqIni);
  end;
end;

procedure TFrmConfiguracaoBaseDados.spdGravarClick(Sender: TObject);
var ArqIni : TIniFile;
    diretorio : String;
begin
  inherited;
  diretorio := ParamStr(0);
  diretorio := ExtractFilePath(diretorio);
  ArqIni    := TIniFile.Create(diretorio + 'ReiterLog.ini');

  try
    ArqIni.WriteString('BaseDados', 'Servidor', edsServidor.Text);
    ArqIni.WriteString('BaseDados', 'Alias', edsBaseDados.Text);
    ArqIni.WriteString('BaseDados', 'Usuario', edsUsuario.Text);
    ArqIni.WriteString('BaseDados', 'Senha', CodificarTexto(edsSenha.Text));
    ArqIni.WriteInteger('BaseDados', 'Porta', StrToInt(ednPorta.Text));
    ModalResult := mrOk;
  finally
    FreeAndNil(ArqIni);
  end;
end;

procedure TFrmConfiguracaoBaseDados.spnCancelarClick(Sender: TObject);
begin
  inherited;
  ModalResult := mrCancel;
end;

procedure TFrmConfiguracaoBaseDados.FormShow(Sender: TObject);
begin
  inherited;
  LerIni;
end;

procedure TFrmConfiguracaoBaseDados.SpeedButton1Click(Sender: TObject);
begin
  inherited;
  try
    with dmPrincipal.zConexao do
    begin
      if Connected then
        Disconnect;

      try
        Database := edsBaseDados.Text;
        HostName := edsServidor.Text;
        Port     := StrToInt(ednPorta.Text);
        User     := edsUsuario.Text;
        Password := edsSenha.Text;
        Connect;

        if Connected then
        begin
          MsgSistema('Conexão Realizada com Sucesso.', 'I');
        end;
      finally
        if Connected then
          Disconnect;
      end;
    end;
  except
    on E : Exception do
    begin
      MsgSistema( E.Message, 'E');
      Exit;
    end;
  end;
end;

end.
