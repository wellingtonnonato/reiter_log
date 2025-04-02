unit uFrmLogIntegracao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmPadrao, ExtCtrls, Buttons, StdCtrls, ZAbstractRODataset,
  ZAbstractDataset, ZDataset;

type
  TFrmLogIntegracao = class(TfrmPadrao)
    Label1: TLabel;
    GroupBox1: TGroupBox;
    eddInicio: TEdit;
    eddFim: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    mmLog: TMemo;
    spnAtualizar: TSpeedButton;
    procedure spnAtualizarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure MontarSql;
  public
    { Public declarations }
  end;

var
  FrmLogIntegracao: TFrmLogIntegracao;

implementation

uses
 uProcessosFunctionGeral, DB;

{$R *.dfm}

{ TFrmLogIntegracao }

procedure TFrmLogIntegracao.MontarSql;
var qLog : TZQuery;
begin
  qLog := NewZQuery;

  try
    with qLog do
    begin
      Close;
      Sql.Clear;
      Sql.Add('SELECT a.dta_inicio                   ');
      Sql.Add('     , a.dta_fim                      ');
      Sql.Add('     , a.des_log                      ');
      Sql.Add('  FROM reiterlog.tab_log_integracao a ');
      Open;
      First;

      if not IsEmpty then
      begin
        eddInicio.Text := DateTimeToStr(FieldByName('dta_inicio').AsDateTime);
        eddFim.Text    := DateTimeToStr(FieldByName('dta_fim').AsDateTime);
        mmLog.Text     := FieldByName('des_log').AsString;
      end;
    end;
  finally
    FreeAndNil(qLog);
  end;
end;

procedure TFrmLogIntegracao.spnAtualizarClick(Sender: TObject);
begin
  inherited;
  MontarSql;
end;

procedure TFrmLogIntegracao.FormShow(Sender: TObject);
begin
  inherited;
  MontarSql;
end;

end.
