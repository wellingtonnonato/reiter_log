unit uFrmAguarde;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls;

type
  TFrmAguarde = class(TForm)
    Panel1: TPanel;
    lbMensagem: TLabel;
    BarraProgresso: TProgressBar;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Init(Mensagem: String; ValorMaximo: Integer);
    procedure InicializaBarraProgresso(ValorMaximo: Integer);
    procedure IncrementaBarraProgresso(Valor: Integer);
    procedure AtualizaProgresso;
  private
    { Private declarations }
  public
    { Public declarations }
    PodeFechar : Boolean;
    class function ShowMsg(Mensagem: String; MaxValue: Integer = 0): TFrmAguarde;
    procedure SetMsg(Mensagem: String);
    procedure CloseMsg;
  end;

var
  FrmAguarde: TFrmAguarde;

implementation

{$R *.dfm}

{ TFrmAguarde }

procedure TFrmAguarde.CloseMsg;
begin
  PodeFechar := True;
  Close;
  Application.ProcessMessages;
end;

procedure TFrmAguarde.SetMsg(Mensagem: String);
begin
  lbMensagem.Caption := Mensagem;
  Application.ProcessMessages;
end;

class function TFrmAguarde.ShowMsg(Mensagem: String; MaxValue: Integer): TFrmAguarde;
var Icone : TIcon;
begin
  Result := TFrmAguarde.Create(Application);
  Result.lbMensagem.Caption := Mensagem;

  if MaxValue > 0 then
    Result.InicializaBarraProgresso(MaxValue);

  Result.Show;
  Application.ProcessMessages;
end;

procedure TFrmAguarde.FormCreate(Sender: TObject);
begin
  PodeFechar := False;
end;

procedure TFrmAguarde.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrmAguarde.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := PodeFechar;
end;

procedure TFrmAguarde.FormShow(Sender: TObject);
begin
  Application.ProcessMessages;
end;

procedure TFrmAguarde.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_F8) and (Shift = [ssCtrl]) then
  begin
    PodeFechar := True;
    Close;
  end;
end;

procedure TFrmAguarde.AtualizaProgresso;
begin
  BarraProgresso.Position := BarraProgresso.Position + 1;
  Application.ProcessMessages;
end;

procedure TFrmAguarde.IncrementaBarraProgresso(Valor: Integer);
begin
  BarraProgresso.Position := Valor;
  Application.ProcessMessages;
end;

procedure TFrmAguarde.InicializaBarraProgresso(ValorMaximo: Integer);
begin
  Height := 150;
  BarraProgresso.Position := 0;

  if ValorMaximo = 0 then
    ValorMaximo := 1;

  BarraProgresso.Max     := ValorMaximo;
  BarraProgresso.Visible := True;
  Application.ProcessMessages;
end;

procedure TFrmAguarde.Init(Mensagem: String; ValorMaximo: Integer);
begin
  SetMsg(Mensagem);
  InicializaBarraProgresso(ValorMaximo);
end;

end.
