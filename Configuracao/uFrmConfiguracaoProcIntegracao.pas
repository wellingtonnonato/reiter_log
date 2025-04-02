unit uFrmConfiguracaoProcIntegracao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmPadrao, ExtCtrls, StdCtrls, DBCtrls;

type
  TFrmConfiguracaoProcIntegracao = class(TfrmPadrao)
    pnEmpresa: TPanel;
    Label1: TLabel;
    DBLookupComboBox1: TDBLookupComboBox;
    GroupBox1: TGroupBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmConfiguracaoProcIntegracao: TFrmConfiguracaoProcIntegracao;

implementation

{$R *.dfm}

end.
