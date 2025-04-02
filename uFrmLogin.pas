unit uFrmLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmPadrao, StdCtrls, ExtCtrls, Buttons;

type
  TFrmLogin = class(TfrmPadrao)
    Impulse: TImage;
    Label4: TLabel;
    Label2: TLabel;
    edsUsuario: TEdit;
    edsSenha: TEdit;
    spnGravar: TSpeedButton;
    spnCancelar: TSpeedButton;
    procedure spnCancelarClick(Sender: TObject);
    procedure spnGravarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation

uses
 uProcessosFunctionGeral;

{$R *.dfm}

procedure TFrmLogin.spnCancelarClick(Sender: TObject);
begin
  inherited;
  ModalResult := mrCancel;
end;

procedure TFrmLogin.spnGravarClick(Sender: TObject);
begin
  inherited;
  ModalResult := mrNone;

  if not LoginUsuario( edsUsuario.Text
                     , edsSenha.Text) then
    Exit;

  ModalResult := mrOK;
end;

end.
