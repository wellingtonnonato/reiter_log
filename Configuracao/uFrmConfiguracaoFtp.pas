unit uFrmConfiguracaoFtp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmPadrao, ExtCtrls, Buttons, StdCtrls, IniFiles, FileCtrl;

type
  TFrmConfiguracaoFtp = class(TfrmPadrao)
    lbl1: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edsDirSeparacaoEnvio: TEdit;
    edsUsuario: TEdit;
    edsSenha: TEdit;
    ednPorta: TEdit;
    edsServidor: TEdit;
    spdGravar: TSpeedButton;
    spnCancelar: TSpeedButton;
    Label5: TLabel;
    edsDirRecebimentoEnvio: TEdit;
    Label6: TLabel;
    edsDirSeparacaoRetorno: TEdit;
    Label7: TLabel;
    edsDirRecebimentoRetorno: TEdit;
    procedure spdGravarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure spnCancelarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmConfiguracaoFtp: TFrmConfiguracaoFtp;

implementation

uses
 uProcessosFunctionGeral;

{$R *.dfm}

procedure TFrmConfiguracaoFtp.spdGravarClick(Sender: TObject);
var ArqIni : TIniFile;
    diretorio : String;
begin
  inherited;
  diretorio := ParamStr(0);
  diretorio := ExtractFilePath(diretorio);
  ArqIni    := TIniFile.Create(diretorio + 'ReiterLog.ini');

  try
    ArqIni.WriteString('FTP', 'HostServidor', edsServidor.Text);
    ArqIni.WriteString('FTP', 'DirSeparacaoEnvio', edsDirSeparacaoEnvio.Text);
    ArqIni.WriteString('FTP', 'DirSeparacaoRetorno', edsDirSeparacaoRetorno.Text);
    ArqIni.WriteString('FTP', 'DirRecebimentoEnvio', edsDirRecebimentoEnvio.Text);
    ArqIni.WriteString('FTP', 'DirRecebimentoRetorno', edsDirRecebimentoRetorno.Text);
    ArqIni.WriteString('FTP', 'Usuario', edsUsuario.Text);
    ArqIni.WriteString('FTP', 'Senha', CodificarTexto(edsSenha.Text));
    ArqIni.WriteInteger('FTP', 'Porta', StrToInt(ednPorta.Text));
    ModalResult := mrOk;
    LerIni;
  finally
    FreeAndNil(ArqIni);
  end;
end;

procedure TFrmConfiguracaoFtp.FormShow(Sender: TObject);
begin
  inherited;
  LerIni;

  with DadosFTP do
  begin
    edsServidor.Text              := HostName;
    edsDirSeparacaoEnvio.Text     := DirSeparacaoEnvio;
    edsDirSeparacaoRetorno.Text   := DirSeparacaoRetorno;
    edsDirRecebimentoEnvio.Text   := DirRecebimentoEnvio;
    edsDirRecebimentoRetorno.Text := DirRecebimentoRetorno;
    edsUsuario.Text               := Usuario;
    edsSenha.Text                 := Senha;
    ednPorta.Text                 := IntToStr(Porta);
  end;
end;

procedure TFrmConfiguracaoFtp.spnCancelarClick(Sender: TObject);
begin
  inherited;
  ModalResult := mrCancel;
end;

end.
