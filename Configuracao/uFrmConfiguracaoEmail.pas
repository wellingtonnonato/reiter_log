unit uFrmConfiguracaoEmail;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmPadrao, ExtCtrls, Buttons, StdCtrls, IniFiles;

type
  TFrmConfiguracaoEmail = class(TfrmPadrao)
    lbl1: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edsDestinatario: TEdit;
    edsUsuario: TEdit;
    edsSenha: TEdit;
    ednPorta: TEdit;
    edsHost: TEdit;
    SpeedButton1: TSpeedButton;
    spdGravar: TSpeedButton;
    spnCancelar: TSpeedButton;
    cbbTipoAutenticacao: TComboBox;
    Label5: TLabel;
    OpenDialog1: TOpenDialog;
    procedure spdGravarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure spnCancelarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmConfiguracaoEmail: TFrmConfiguracaoEmail;

implementation

uses
 uProcessosFunctionGeral;

{$R *.dfm}

procedure TFrmConfiguracaoEmail.spdGravarClick(Sender: TObject);
var ArqIni : TIniFile;
    diretorio : String;
begin
  inherited;
  diretorio := ParamStr(0);
  diretorio := ExtractFilePath(diretorio);
  ArqIni    := TIniFile.Create(diretorio + 'ReiterLog.ini');

  try
    ArqIni.WriteString('EMAIL', 'HostServidor', edsHost.Text);
    ArqIni.WriteInteger('EMAIL', 'Porta', StrToIntDef(ednPorta.Text, 0));
    ArqIni.WriteInteger('EMAIL', 'TipoAutenticacao', cbbTipoAutenticacao.ItemIndex);
    ArqIni.WriteString('EMAIL', 'Usuario', edsUsuario.Text);
    ArqIni.WriteString('EMAIL', 'Senha', CodificarTexto(edsSenha.Text));
    ArqIni.WriteString('EMAIL', 'Destinatario', edsDestinatario.Text);
    ModalResult := mrOk;
  finally
    FreeAndNil(ArqIni);
  end;
end;

procedure TFrmConfiguracaoEmail.FormShow(Sender: TObject);
begin
  inherited;
  LerIni;

  with DadosEmail do
  begin
    edsHost.Text := Host;
    edsUsuario.Text := Usuario;
    edsSenha.Text := Senha;
    edsDestinatario.Text := Destinatario;
    ednPorta.Text := IntToStr(Porta);
  end;
end;

procedure TFrmConfiguracaoEmail.SpeedButton1Click(Sender: TObject);
var ListTeste : TStringList;
begin
  inherited;
  ListTeste := TStringList.Create;

  try
    if EnviarEmail( edsHost.Text
                , edsUsuario.Text
                , edsSenha.Text
                , edsDestinatario.Text
                , 'Teste de Envio de E-mail da Integração Reiter Log'
                , StrToInt(ednPorta.Text)
                , cbbTipoAutenticacao.ItemIndex
                , ListTeste) then
      MsgSistema('E-mail enviado com sucesso!', 'I')
    else
      MsgSistema(ListTeste.CommaText, 'E');
  finally
    FreeAndNil(ListTeste);
  end;
end;

procedure TFrmConfiguracaoEmail.spnCancelarClick(Sender: TObject);
begin
  inherited;
  ModalResult := mrCancel;
end;

end.
