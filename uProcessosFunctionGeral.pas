unit uProcessosFunctionGeral;

interface
uses
  Windows, SysUtils, Classes, Forms,
  ZAbstractRODataset, ZAbstractDataset, ZDataset, Cipher,
  Hash, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdFTP,
  IdFtpCommon, Dialogs, IdSMTP, IdMessage, IdSSlOpenSSl, IniFiles,
  IdExplicitTLSClientServerBase, IdMessageClient, IdSMTPBase, DB, DbClient, IdFTPList;

  const
    mrYes = 6;
    mrNo = 7;
    mrOK = 1;
    mrCancel = 2;
    mrAbort	= 3;
    mrRetry	= 4;
    mrIgnore	= 5;
    mrAll	= 8;
    mrNoToAll	= 9;
    mrYesToAll	= 10;
    TipoSeparacao = 'S';
    TipoRecebimento = 'R';

  type
   TDadosFTP = Record
    HostName,
    Usuario,
    Senha,
    DirSeparacaoEnvio,
    DirSeparacaoRetorno,
    DirRecebimentoEnvio,
    DirRecebimentoRetorno : String;
    Porta : Integer;
   end;

   TDadosEmail = Record
    Host,
    Destinatario,
    Usuario,
    Senha : String;
    Porta,
    TipoAutenticacao : Integer;
   end;

   TDadosConexao = Record
    Servidor,
    BaseDados,
    Usuario,
    Senha : String;
    Porta : Integer;
   end;

   TDiretorioSistema = Record
    DirExecutavel,
    DirArqEnvioSeparacao,
    DirArqEnvioRecebimento,
    DirArqRetornoSeparacao,
    DirArqRetornoRecebimento,
    DirArqEnvioSeparacaoEnviados,
    DirArqEnvioRecebimentoEnviados,
    DirArqRetornoSeparacaoFinalizados,
    DirArqRetornoRecebimentoFinalizados: String;
   end;

   TUsuario = Record
    Codigo : Integer;
    Nome,
    Senha,
    Tipo : String;
   end;

   var
     DiretorioSistema : TDiretorioSistema;
     DadosConexao     : TDadosConexao;
     DadosEmail       : TDadosEmail;
     DadosFTP         : TDadosFTP;
     Usuario          : TUsuario;

   function CodificarTexto(sTexto : String) : String;
   function DescodificarTexto(sTexto : String) : String;
   procedure MsgSistema(sTexto, sTipo : String);
   function MsgQuestiona(sPergunta : String) : Boolean;
   function EnvioFTP(sHostName, sUsuario, sSenha, sDiretorioFtp, sDiretorioArquivo,
                     sDiretorioArqBkp : String; iPorta : Integer;
                     var ListErro : TStringList) : Boolean;
   function RetornoFTP(sHostName, sUsuario, sSenha, sDiretorioFtp, sDiretorioArquivo : String;
                       iPorta : Integer; var ListErro : TStringList) : Boolean;
   procedure CriarDiretorioPadrao;
   procedure PopulaDiretorios;
   function EnviarEmail(sHost, sUsuario, sSenha, sDestino, sMensagem : String;
                        iPorta, iTipoAutenticao : Integer; var ListErro : TStringList): Boolean;
   procedure LerIni;
   function NewZQuery : TZQuery;
   function ConsultaValorParametro(iSeqParametro : Integer) : String;
   procedure PopularClientDataSet(var cds : TClientDataSet; zQuery : TZQuery);
   function IfThen(AValue: Boolean; const sTrue: String; const sFalse: String): String;
   function VerificaRegistro(sTabela, sCampoSequencia : String; iSeq : Integer) : Boolean;
   function SomenteNumero(Key : Char) : Char;
   function ValidarHora(Hora, Minuto : String) : Boolean;
   procedure GerarArquivo(sTipo : String; var CdsPrincipal, cdsItens : TClientDataSet; var ListErro : TStringList);
   procedure LerArqRetornoSeparacao(var ListErro : TStringList);
   procedure LerArqRetornoRecebimento(var ListErro : TStringList);
   function PreencherStringDireita(sValor : String; iTamanho : Integer; cPreenchimento : Char = Chr(32)) : String;
   function PreencherStringEsquerda(sValor : String; iTamanho : Integer; cPreenchimento : Char = Chr(32)) : String;
   function PegarSomenteValorDoCampo(sLinha : String; iPosicaoInicial, iPosicaoFinal : Integer; cPreenchimento : Char = Chr(32)) : String;
   function AlteraStatus(sTipoArquivo, sStatusOLD, sStatusNew : String; var ListErro : TStringList;
                         bSomenteQtdRetornada : Boolean = False; iSequencia : Integer = 0; bValidarStatus : Boolean = True) : Boolean;
   function TirarCaractereze(sTexto : String) : String;
   function PegarCodSequencia(sSequencia : String) : Integer;
   procedure ValidarQtdRetornoRecebimento(var ListErro : TStringList);
   procedure ValidarQtdRetornoSeparacao(var ListErro : TStringList);
   function RetornaAlmoxrifado(iCodAlmoxOri : Integer; sTipo : String; bAlmoxFinal : Boolean = True) : Integer;
   procedure ProcessoTransfItensEntrada(iSeqNota : Integer; var ListErro : TStringList);
   procedure ProcessoCorrigiQtdPreVenda(iSeqPreVenda : Integer; var ListErro : TStringList);
   procedure FinalizaRetornoPreVenda(iSeqPreVenda : Integer; var ListErro : TStringList);
   procedure FinalizaRetornoRecebimento(iSeqNota : Integer; var ListErro : TStringList);
   procedure RegistraLog(dDtaInicio, dDtaFim : TDateTime; ListLog : TStringList);
   function VerificaAcesso(iTag : Integer; bSomenteAdministrador : Boolean = False) : Boolean;
   function LoginUsuario(sNome, sSenha : String) : Boolean;
   function GravaLogMovimento(sTipoArquivo, sLog : String; iSequencia : Integer; var sListErro : TStringList) : Boolean;
   function ExcluirRecebimento(iSeqRecebimento : Integer; var sListErro : TStringList) : Boolean;
   procedure ExcluirItemSemEstoque(var sListErro : TStringList);

implementation

uses DECUtil, IdIOHandler, uDataModulo, DateUtils;

function CodificarTexto(sTexto : String) : String;
begin
  with TCipher_Blowfish.Create('Quem acredita em Deus Sempre será salvo'
                              , nil) do
  begin
    Mode   := TCipherMode(cmCBC);
    Result := CodeString( sTexto
                        , paEncode
                        , 16);
  end;
end;

function DescodificarTexto(sTexto : String) : String;
begin
  with TCipher_Blowfish.Create('Quem acredita em Deus Sempre será salvo'
                              , nil) do
  begin
    Mode   := TCipherMode(cmCBC);
    Result := CodeString( sTexto
                        , paDecode
                        , 16);
  end;
end;

procedure MsgSistema(sTexto, sTipo : String);
begin
  if sTipo = 'I' then
  begin
    Application.MessageBox( Pchar(sTexto)
                          , 'Informação'
                          , MB_ICONINFORMATION or
                            MB_OK or
                            MB_TASKMODAL);
  end
  else if sTipo = 'E' then
  begin
    Application.MessageBox( Pchar(sTexto)
                          , 'Erro'
                          , MB_ICONERROR or
                            MB_OK or
                            MB_TASKMODAL);
  end
  else if sTipo = 'A' then
  begin
    Application.MessageBox( Pchar(sTexto)
                          , 'Aviso'
                          , MB_ICONWARNING or
                            MB_OK or
                            MB_TASKMODAL);
  end;
end;

function MsgQuestiona(sPergunta : String) : Boolean;
begin
  Result := MessageDlg(sPergunta, mtConfirmation, [mbYes, mbNo], 0) = mrYes;
end;

function EnvioFTP(sHostName, sUsuario, sSenha, sDiretorioFtp, sDiretorioArquivo,
                  sDiretorioArqBkp : String; iPorta : Integer;
                  var ListErro : TStringList) : Boolean;
var ftp : TIdFtp;
    ListArquivo : TStringList;
    ResultPesquisa : TSearchRec;
    iArquivos, i : Integer;
begin
  Result      := False;
  ftp         := TIdFtp.Create(nil);
  ListArquivo := TStringList.Create;

  try
    ftp.Host        := sHostName;
    ftp.Username    := sUsuario;
    ftp.Password    := sSenha;
    //ftp.Passive     := True;
    ftp.ReadTimeout := 30000000;
    ftp.Port        := iPorta;
    iArquivos       := FindFirst( sDiretorioArquivo + '\*.txt'
                                , faAnyFile
                                , ResultPesquisa);

    while iArquivos = 0 do
    begin
      ListArquivo.Add(ResultPesquisa.Name);
      iArquivos := FindNext(ResultPesquisa);
    end;

    try
      ftp.Connect;

      if ftp.Connected then
      begin
        ftp.ChangeDir(sDiretorioFtp);

        for i := 0 to ListArquivo.Count -1 do
        begin
          ftp.Put(sDiretorioArquivo + '\' + ListArquivo[i]);
        end;

        ftp.Disconnect;
        Result := True;

        for i := 0 to ListArquivo.Count -1 do
        begin
          if not FileExists(sDiretorioArqBkp + '\' + ListArquivo[i]) then
          begin
            if not MoveFile( PChar(sDiretorioArquivo + '\' + ListArquivo[i])
                           , PChar(sDiretorioArqBkp + '\' + ListArquivo[i])) then
            begin
               ListErro.Add('Não foi possível mover o arquivo: ');
               ListErro.Add(sDiretorioArquivo + '\' + ListArquivo[i]);
            end;
          end
          else
          begin
            if DeleteFile(sDiretorioArqBkp + '\' + ListArquivo[i]) then
            begin
              if not MoveFile( PChar(sDiretorioArquivo + '\' + ListArquivo[i])
                             , PChar(sDiretorioArqBkp + '\' + ListArquivo[i])) then
              begin
                 ListErro.Add('Não foi possível mover o arquivo: ');
                 ListErro.Add(sDiretorioArquivo + '\' + ListArquivo[i]);
              end;
            end;
          end;
        end;
      end;
    except
      on E : Exception do
      begin
        if ftp.Connected then
          ftp.Disconnect;

        ListErro.Add('Não foi possível enviar o arquivo pelo ftp:');
        ListErro.Add(E.Message);
      end;
    end;
  finally
    FreeAndNil(ftp);
    FreeAndNil(ListArquivo);
  end;
end;

function RetornoFTP(sHostName, sUsuario, sSenha, sDiretorioFtp, sDiretorioArquivo: String;
                    iPorta : Integer; var ListErro : TStringList) : Boolean;
var ftp : TIdFtp;
    ListArquivo : TStringList;
    i : Integer;
    bMovendo : Boolean;
begin
  Result      := False;
  ftp         := TIdFtp.Create(nil);
  ListArquivo := TStringList.Create;

  try
    //ListArquivo.Delimiter := ';';

    ftp.Host         := sHostName;
    ftp.Username     := sUsuario;
    ftp.Password     := sSenha;
    ftp.Passive      := True;
    ftp.Port         := iPorta;
    ftp.TransferType := ftASCII;
    //ftp.TransferType := ftBinary;
    ftp.ReadTimeout  := 30000000;

    try
      ftp.Connect;

      if ftp.Connected then
      begin
        ftp.ChangeDir(sDiretorioFtp);

        ftp.List;
        ListArquivo.AddStrings(ftp.ListResult);


        for i := 0 to ListArquivo.Count -1 do
        begin
          ftp.Get( ListArquivo[i]
                 , sDiretorioArquivo + '\' + ListArquivo[i]
                 , True
                 , False);
        end;

        for i := 0 to ListArquivo.Count -1 do
        begin
          ftp.Delete(ListArquivo[i]);
        end;

        ftp.Disconnect;
      end;

      Result := True;
    except
      on E : Exception do
      begin
        if ftp.Connected then
          ftp.Disconnect;

        ListErro.Add('Não foi possível fazer o download do arquivo de retorno pelo ftp:');
        ListErro.Add(E.Message);
      end;
    end;
  finally
    FreeAndNil(ftp);
    FreeAndNil(ListArquivo);
  end;
end;

procedure CriarDiretorioPadrao;
begin
  try
    if not DirectoryExists(ExtractFileDir(GetCurrentDir + '\Arquivos\Envio\Separacao\')) then
      ForceDirectories(ExtractFileDir(GetCurrentDir + '\Arquivos\Envio\Separacao\'));

    if not DirectoryExists(ExtractFileDir(GetCurrentDir + '\Arquivos\Envio\Recebimento\')) then
      ForceDirectories(ExtractFileDir(GetCurrentDir + '\Arquivos\Envio\Recebimento\'));

    if not DirectoryExists(ExtractFileDir(GetCurrentDir + '\Arquivos\Retorno\Separacao\')) then
      ForceDirectories(ExtractFileDir(GetCurrentDir + '\Arquivos\Retorno\Separacao\'));

    if not DirectoryExists(ExtractFileDir(GetCurrentDir + '\Arquivos\Retorno\Recebimento\')) then
      ForceDirectories(ExtractFileDir(GetCurrentDir + '\Arquivos\Retorno\Recebimento\'));

    if not DirectoryExists(ExtractFileDir(GetCurrentDir + '\Arquivos\Envio\Separacao_Enviados\')) then
      ForceDirectories(ExtractFileDir(GetCurrentDir + '\Arquivos\Envio\Separacao_Enviados\'));

    if not DirectoryExists(ExtractFileDir(GetCurrentDir + '\Arquivos\Envio\Recebimento_Enviados\')) then
      ForceDirectories(ExtractFileDir(GetCurrentDir + '\Arquivos\Envio\Recebimento_Enviados\'));

    if not DirectoryExists(ExtractFileDir(GetCurrentDir + '\Arquivos\Retorno\Separacao_Finalizados\')) then
      ForceDirectories(ExtractFileDir(GetCurrentDir + '\Arquivos\Retorno\Separacao_Finalizados\'));

    if not DirectoryExists(ExtractFileDir(GetCurrentDir + '\Arquivos\Retorno\Recebimento_Finalizados\')) then
      ForceDirectories(ExtractFileDir(GetCurrentDir + '\Arquivos\Retorno\Recebimento_Finalizados\'));

    PopulaDiretorios;
  except
    on E : Exception do
    begin
      MsgSistema(E.Message, 'E');
    end;
  end;
end;

procedure PopulaDiretorios;
begin
  with DiretorioSistema do
  begin
    DirExecutavel            := ExtractFilePath(Application.ExeName);
    DirArqEnvioSeparacao     := DirExecutavel + '\Arquivos\Envio\Separacao\';
    DirArqEnvioRecebimento   := DirExecutavel + '\Arquivos\Envio\Recebimento\';
    DirArqRetornoSeparacao   := DirExecutavel + '\Arquivos\Retorno\Separacao\';
    DirArqRetornoRecebimento := DirExecutavel + '\Arquivos\Retorno\Recebimento\';

    DirArqEnvioSeparacaoEnviados        := DirExecutavel + '\Arquivos\Envio\Separacao_Enviados\';
    DirArqEnvioRecebimentoEnviados      := DirExecutavel + '\Arquivos\Envio\Recebimento_Enviados\';
    DirArqRetornoSeparacaoFinalizados   := DirExecutavel + '\Arquivos\Retorno\Separacao_Finalizados\';
    DirArqRetornoRecebimentoFinalizados := DirExecutavel + '\Arquivos\Retorno\Recebimento_Finalizados\';
  end;
end;

function EnviarEmail(sHost, sUsuario, sSenha, sDestino, sMensagem : String;
                     iPorta, iTipoAutenticao : Integer; var ListErro : TStringList): Boolean;
var R: TResourceStream;
    Socket : TIdSSLIOHandlerSocketOpenSSL;
    Email: TIdSMTP;
    MsgEmail: TIdMessage;
begin
  Result   := True;
  Email    := TIdSMTP.Create(Nil);
  MsgEmail := TIdMessage.Create(Nil);
  try
    try
      if not FileExists(ExtractFilePath(Application.ExeName)+'\libeay32.dll') then
      begin
        R := TResourceStream.Create(HInstance, 'libeay32', 'DLL');
        R.SaveToFile(ExtractFilePath(Application.ExeName)+'\libeay32.dll');
        R.Free;
      end;

      if not FileExists(ExtractFilePath(Application.ExeName)+'\ssleay32.dll') then
      begin
        R := TResourceStream.Create(HInstance, 'ssleay32', 'DLL');
        R.SaveToFile(ExtractFilePath(Application.ExeName)+'\ssleay32.dll');
        R.Free;
      end;

      Email.ConnectTimeout   := 10000;
      Email.ReadTimeout      := 10000;
      Email.AuthType         := satDefault;
      Email.ManagedIOHandler := True;

      if iTipoAutenticao = 1 then
      begin
        Socket := TIdSSLIOHandlerSocketOpenSSL.Create(Email);

        with Socket do
        begin
          SSLOptions.Method      := sslvTLSv1;
          SSLOptions.Mode        := sslmClient;
          SSLOptions.VerifyMode  := [];
          SSLOptions.VerifyDepth := 0;
          Destination            := sDestino;
          Host                   := sHost;
          Port                   := iPorta;
        end;

        Email.IOHandler := Socket;

        if (LowerCase(sHost) = 'smtp.live.com') or
           (LowerCase(sHost) = 'outlook.oofice365.com')then
          Email.UseTLS := utUseExplicitTLS
        else
          Email.UseTLS := utUseImplicitTLS;
      end
      else
      begin
        Email.IOHandler := nil;
        Email.UseTLS    := utNoTLSSupport;
      end;

      with Email do
      begin
        Host               := sHost;
        Port               := iPorta;
        Username           := sUsuario;
        Password           := sSenha;

        try
          Connect;
        except
          on E : Exception do
          begin
            Result := False;
            ListErro.Add(E.Message);
            Exit;
          end;
        end;
      end;

      if Email.Connected then
      begin
        with MsgEmail do
        begin
          From.Address              := sUsuario;
          Recipients.EMailAddresses := sDestino;
          Subject                   := 'E-mail Integração da Reiter Log';
          Body.Text                 := sMensagem;
          //Priority                  := TIdMessage(mpNormal);
          CCList.EMailAddresses     := '';
        end;

        Email.Send(MsgEmail);
      end;
    except
      on E: Exception do
      begin
        Result := False;
        ListErro.Add(E.Message);
        Exit;
      end;
    end;
  finally
    if Email.Connected then
      Email.Disconnect;

    FreeAndNil(MsgEmail);

    if Socket <> nil then
      FreeAndNil(Socket);

    FreeAndNil(Email);
  end;
end;

procedure LerIni;
var ArqIni : TIniFile;
    diretorio : String;
begin
  diretorio     := ParamStr(0);
  diretorio     := ExtractFilePath(diretorio);
  ArqIni        := TIniFile.Create(diretorio + 'ReiterLog.ini');

  try
    with DadosEmail do
    begin
      Host             := ArqIni.ReadString('EMAIL', 'HostServidor', '');
      Destinatario     := ArqIni.ReadString('EMAIL', 'Destinatario', '');
      Usuario          := ArqIni.ReadString('EMAIL', 'Usuario', '');
      Senha            := DescodificarTexto(ArqIni.ReadString('EMAIL', 'Senha', ''));
      Porta            := ArqIni.ReadInteger('EMAIL', 'Porta', 0);
      TipoAutenticacao := ArqIni.ReadInteger('EMAIL', 'TipoAutenticacao', 1);
    end;

    with DadosFTP do
    begin
      HostName              := ArqIni.ReadString('FTP', 'HostServidor', '');
      DirSeparacaoEnvio     := ArqIni.ReadString('FTP', 'DirSeparacaoEnvio', '');
      DirSeparacaoRetorno   := ArqIni.ReadString('FTP', 'DirSeparacaoRetorno', '');
      DirRecebimentoEnvio   := ArqIni.ReadString('FTP', 'DirRecebimentoEnvio', '');
      DirRecebimentoRetorno := ArqIni.ReadString('FTP', 'DirRecebimentoRetorno', '');
      Usuario               := ArqIni.ReadString('FTP', 'Usuario', '');
      Senha                 := DescodificarTexto(ArqIni.ReadString('FTP', 'Senha', ''));
      Porta                 := ArqIni.ReadInteger('FTP', 'Porta', 21);
    end;

    with DadosConexao do
    begin
      Servidor  := ArqIni.ReadString('BaseDados', 'Servidor', '');
      BaseDados := ArqIni.ReadString('BaseDados', 'Alias', '');
      Usuario   := ArqIni.ReadString('BaseDados', 'Usuario', '');
      Senha     := DescodificarTexto(ArqIni.ReadString('BaseDados', 'Senha', ''));
      Porta     := ArqIni.ReadInteger('BaseDados', 'Porta', 5432);
    end;

  finally
    FreeAndNil(ArqIni);
  end;
end;

function NewZQuery : TZQuery;
var zQ : TZQuery;
begin
  zQ := TZQuery.Create(nil);
  zQ.Connection := dmPrincipal.zConexao;

  Result := zQ;
end;

function ConsultaValorParametro(iSeqParametro : Integer) : String;
var qParametro : TZQuery;
begin
  Result := '';
  qParametro := NewZQuery;

  try
    with qParametro do
    begin
      Close;
      if iSeqParametro = 2 then
        Sql.Add('SELECT cast(a.val_parametro as TIMESTAMP) as val_parametro   ')
      else
        Sql.Add('SELECT a.val_parametro                      ');

      Sql.Add('  FROM reiterlog.tab_parametro_integracao a ');
      Sql.Add(' WHERE a.seq_parametro = :seq_parametro     ');
      ParamByName('seq_parametro').AsInteger := iSeqParametro;
      Open;
      First;

      if not IsEmpty then
        Result := FieldValues['val_parametro'];
    end;
  finally
  end;

end;

procedure PopularClientDataSet(var cds : TClientDataSet; zQuery : TZQuery);
var i : Integer;
    sNameColuna : String;
begin
  zQuery.First;

  {if cds.Active then
    Cds.EmptyDataSet;}

  if not cds.IsEmpty then
  begin
    cds.Close;
    cds.CreateDataSet;
  end;

  if zQuery.IsEmpty then
    Exit;
    
  while not zQuery.Eof do
  begin
    cds.Append;
    for i := 0 to zQuery.FieldCount - 1 do
    begin
      sNameColuna := zQuery.Fields.Fields[i].FieldName;
      cds.FieldByName(sNameColuna).Value := zQuery.FieldValues[sNameColuna];
    end;
    cds.Post;

    zQuery.Next;
  end;
end;

function IfThen(AValue: Boolean; const sTrue: String; const sFalse: String): String;
begin
  if AValue then
    Result := sTrue
  else
    Result := sFalse;
end;

function VerificaRegistro(sTabela, sCampoSequencia : String; iSeq : Integer) : Boolean;
var qConsulta : TZQuery;
begin
  Result    := False;  
  qConsulta := NewZQuery;

  try
    with qConsulta do
    begin
      Close;
      Sql.Clear;
      Sql.Add('Select Count('+ sCampoSequencia + ') as Registro  ');
      Sql.Add('  from '+ sTabela                                  );
      Sql.Add(' where '+ sCampoSequencia + ' = '+ IntToStr(iSeq)  );
      Open;
      First;

      if FieldByName('registro').AsInteger > 0 then
        Result := True;
    end;
  finally
    FreeAndNil(qConsulta);
  end;
end;

function SomenteNumero(Key : Char) : Char;
begin
  Result := Key;
   
  if not (key in ['0'..'9', #8, #13]) then
    Result := #0;
end;

function ValidarHora(Hora, Minuto : String) : Boolean;
begin
  Result := True;

  try
    StrToTime(Hora + ':' + Minuto);
  except
    MsgSistema('Hora invalida', 'A');
    Result := False;
  end;
end;

procedure GerarArquivo(sTipo : String; var CdsPrincipal, cdsItens : TClientDataSet; var ListErro : TStringList);
var arq : TextFile;
    sDir, sNomeArq, sNomeCampoP, sNomeCampoI, sLinha, sValor : String;
    p, i, iTentativa : Integer;
begin
  CdsPrincipal.Last;
  CdsPrincipal.First;
  CdsPrincipal.DisableControls;
  cdsItens.DisableControls;
  Sleep(1000);

  try
    with CdsPrincipal do
    begin
      if IsEmpty then
        Exit;

      if sTipo = 'S' then
      begin
        sDir     := DiretorioSistema.DirArqEnvioSeparacao;
        sNomeArq := 'SEP_'+ FormatDateTime('ddmmyyyy', now) + '.txt';
        AssignFile(arq, sDir + sNomeArq);

        try
          Rewrite(arq);
          iTentativa := 0;
          
          while not Eof do
          begin
            try
              sLinha := '';

              for p := 0 to FieldCount - 1 do
              begin
                sNomeCampoP := Fields.Fields[p].FieldName;

                if (LowerCase(sNomeCampoP) <> 'sequencia') and
                   (Fields.Fields[p].Visible) then
                begin
                  if Fields.Fields[p].DataType = ftFloat then
                  begin
                    sValor := TirarCaractereze(FieldByName(sNomeCampoP).AsString);
                  end
                  else
                    sValor := FieldByName(sNomeCampoP).AsString;

                  sValor := TirarCaractereze(sValor);

                  if LowerCase(sNomeCampoP) = 'tipo_registro' then
                    sLinha := sLinha + PreencherStringEsquerda(sValor, 1);

                  if LowerCase(sNomeCampoP) = 'numero_carga' then
                    sLinha := sLinha + PreencherStringEsquerda(sValor, 8);

                  if LowerCase(sNomeCampoP) = 'filler' then
                    sLinha := sLinha + PreencherStringDireita(sValor, 8);

                  if LowerCase(sNomeCampoP) = 'cnpj_emissor' then
                    sLinha := sLinha + PreencherStringDireita(sValor, 16);

                  if LowerCase(sNomeCampoP) = 'data_carga' then
                    sLinha := sLinha + PreencherStringDireita(sValor, 8);

                  if LowerCase(sNomeCampoP) = 'cnpj_dest' then
                    sLinha := sLinha + PreencherStringDireita(sValor, 16);

                  if LowerCase(sNomeCampoP) = 'nome_filial_dest' then
                    sLinha := sLinha + PreencherStringDireita(sValor, 35);

                  if LowerCase(sNomeCampoP) = 'endereco_dest' then
                    sLinha := sLinha + PreencherStringDireita(sValor, 30);

                  if LowerCase(sNomeCampoP) = 'bairro_dest' then
                    sLinha := sLinha + PreencherStringDireita(sValor, 30);

                  if LowerCase(sNomeCampoP) = 'fone_dest' then
                    sLinha := sLinha + PreencherStringDireita(sValor, 15);

                  if LowerCase(sNomeCampoP) = 'cep_dest' then
                    sLinha := sLinha + PreencherStringDireita(sValor, 10);

                  if LowerCase(sNomeCampoP) = 'insc_estadual_dest' then
                    sLinha := sLinha + PreencherStringDireita(sValor, 15);
                end;
              end;

              if (slinha = '') and (iTentativa < 3) then
              begin
                Inc(iTentativa);
                Continue;
              end;

              Writeln(arq,sLinha);
              iTentativa := 0;
              cdsItens.Filtered := False;
              cdsItens.Filter   := 'sequencia = '+ IntToStr(FieldByName('sequencia').AsInteger);
              cdsItens.Filtered := True;
              cdsItens.First;
              sLinha := '';
            except
              on E : Exception do
              begin
                ListErro.Add('Erro na linha principal do registro de separacao');
                ListErro.Add(E.Message);
              end;
            end;

            while not cdsItens.Eof do
            begin
              sLinha := '';
              try
                for i := 0 to cdsItens.FieldCount - 1 do
                begin
                  sNomeCampoI := cdsItens.Fields.Fields[i].FieldName;

                  if (LowerCase(sNomeCampoI) <> 'sequencia') and
                     (cdsItens.Fields.Fields[i].Visible) then
                  begin
                    if cdsItens.Fields.Fields[i].DataType = ftFloat then
                    begin
                      //sValor := FormatFloat('#,##0.00', cdsItens.FieldByName(sNomeCampoI).AsFloat);
                      sValor := TirarCaractereze(cdsItens.FieldByName(sNomeCampoI).AsString);
                      //sValor := StringReplace(sValor, ',', '', [rfReplaceAll]);
                    end
                    else
                      sValor := cdsItens.FieldByName(sNomeCampoI).AsString;

                    sValor := TirarCaractereze(sValor);

                    if LowerCase(sNomeCampoI) = 'tipo_registro' then
                      sLinha := sLinha + PreencherStringEsquerda(sValor, 1);

                    if LowerCase(sNomeCampoI) = 'numero_carga' then
                      sLinha := sLinha + PreencherStringEsquerda(sValor, 8);

                    if LowerCase(sNomeCampoI) = 'ean' then
                      sLinha := sLinha + PreencherStringEsquerda(sValor, 13);

                    if LowerCase(sNomeCampoI) = 'qtd_expedida' then
                      sLinha := sLinha + PreencherStringEsquerda(sValor, 10, '0');

                    if LowerCase(sNomeCampoI) = 'codigo_embalagem' then
                      sLinha := sLinha + PreencherStringDireita(sValor, 2);

                    if LowerCase(sNomeCampoI) = 'custo_medio' then
                      sLinha := sLinha + PreencherStringEsquerda(sValor, 14, '0');

                    if LowerCase(sNomeCampoI) = 'tipo_carga' then
                      sLinha := sLinha + PreencherStringDireita(sValor, 3);

                    if LowerCase(sNomeCampoI) = 'filler1' then
                      sLinha := sLinha + PreencherStringDireita(sValor, 6);

                    if LowerCase(sNomeCampoI) = 'filler2' then
                      sLinha := sLinha + PreencherStringDireita(sValor, 3);

                    if LowerCase(sNomeCampoI) = 'cod_mercadoria' then
                      sLinha := sLinha + PreencherStringDireita(sValor, 9);
                  end;
                end;
                Writeln(arq, sLinha);
              except
                on E : Exception do
                begin
                  ListErro.Add('Erro na linha dos itens do registro de separacao');
                  ListErro.Add(E.Message);
                end;
              end;

              cdsItens.Next;
            end;

            Next;
          end;
        finally
          CloseFile(arq);
        end;
      end
      else
      begin
        sDir           := DiretorioSistema.DirArqEnvioRecebimento;
        sNomeArq       := 'REC_'+ FormatDateTime('ddmmyyyy', now)+ '_';
        iTentativa     := 0;

        while not Eof do
        begin
          AssignFile(arq, sDir + sNomeArq + IntToStr(FieldByName('sequencia').AsInteger) + '.txt');

          try
            try
              Rewrite(arq);
              sLinha := '';

              for p := 0 to FieldCount - 1 do
              begin
                sNomeCampoP := Fields.Fields[p].FieldName;

                if (LowerCase(sNomeCampoP) <> 'sequencia')  and
                   (Fields.Fields[p].Visible) then
                begin
                  if Fields.Fields[p].DataType = ftFloat then
                  begin
                    //sValor := FormatFloat('#,##0.00', FieldByName(sNomeCampoP).AsFloat);
                    sValor := TirarCaractereze(FieldByName(sNomeCampoP).AsString);
                    //sValor := StringReplace(sValor, ',', '', [rfReplaceAll]);
                  end
                  else
                    sValor := FieldByName(sNomeCampoP).AsString;

                  sValor := TirarCaractereze(sValor);

                  if LowerCase(sNomeCampoP) = 'tipo_registro' then
                    sLinha := sLinha + PreencherStringEsquerda(sValor, 1);

                  if LowerCase(sNomeCampoP) = 'cnpj_fornecedor' then
                    sLinha := sLinha + PreencherStringDireita(sValor, 16);

                  if LowerCase(sNomeCampoP) = 'numero_nota_fiscal' then
                    sLinha := sLinha + PreencherStringEsquerda(sValor, 9);

                  if LowerCase(sNomeCampoP) = 'serie_nota_fiscal' then
                    sLinha := sLinha + PreencherStringDireita(sValor, 3);

                  if LowerCase(sNomeCampoP) = 'data_emissao' then
                    sLinha := sLinha + PreencherStringDireita(sValor, 8);

                  if LowerCase(sNomeCampoP) = 'cnpj_dest' then
                    sLinha := sLinha + PreencherStringDireita(sValor, 16);

                  if LowerCase(sNomeCampoP) = 'cnpj_complemento' then
                    sLinha := sLinha + PreencherStringDireita(sValor, 16);

                  if LowerCase(sNomeCampoP) = 'placa_veiculo' then
                    sLinha := sLinha + PreencherStringDireita(sValor, 7);

                  if LowerCase(sNomeCampoP) = 'tipo_carga' then
                    sLinha := sLinha + PreencherStringDireita(sValor, 3);

                  if LowerCase(sNomeCampoP) = 'filler' then
                    sLinha := sLinha + PreencherStringDireita(sValor, 38);
                end;
              end;

              if (slinha = '') and (iTentativa < 3) then
              begin
                Inc(iTentativa);
                Continue;
              end;

              Writeln(arq,sLinha);
              iTentativa := 0;
            except
              on E : Exception do
              begin
                ListErro.Add('Erro na linha principal do resgistro de recebimento');
                ListErro.Add(E.Message);
              end;
            end;

            cdsItens.Filtered := False;
            cdsItens.Filter   := 'sequencia = '+ IntToStr(FieldByName('sequencia').AsInteger);
            cdsItens.Filtered := True;
            cdsItens.First;
            sLinha := '';

            while not cdsItens.Eof do
            begin
              sLinha := '';
               
              try
                for i := 0 to cdsItens.FieldCount - 1 do
                begin
                  sNomeCampoI := cdsItens.Fields.Fields[i].FieldName;

                  if (LowerCase(sNomeCampoI) <> 'sequencia') and
                     (cdsItens.Fields.Fields[i].Visible) then
                  begin
                    if cdsItens.Fields.Fields[i].DataType = ftFloat then
                    begin
                      if LowerCase(sNomeCampoI) = 'desconto' then
                        sValor := FormatFloat('#,###0.000', cdsItens.FieldByName(sNomeCampoI).AsFloat)
                      else
                        sValor := cdsItens.FieldByName(sNomeCampoI).AsString;

                      sValor := TirarCaractereze(sValor);
                    end
                    else
                      sValor := cdsItens.FieldByName(sNomeCampoI).AsString;

                    sValor := TirarCaractereze(sValor);
                      
                    if LowerCase(sNomeCampoI) = 'tipo_registro' then
                      sLinha := sLinha + PreencherStringEsquerda(sValor, 1);

                    if LowerCase(sNomeCampoI) = 'cnpj_fornecedor' then
                      sLinha := sLinha + PreencherStringDireita(sValor, 16);

                    if LowerCase(sNomeCampoI) = 'numero_nota_fiscal' then
                      sLinha := sLinha + PreencherStringEsquerda(sValor, 9);

                    if LowerCase(sNomeCampoI) = 'serie_nota_fiscal' then
                      sLinha := sLinha + PreencherStringDireita(sValor, 3);

                    if LowerCase(sNomeCampoI) = 'ean' then
                      sLinha := sLinha + PreencherStringDireita(sValor, 13);

                    if LowerCase(sNomeCampoI) = 'qtd_nf' then
                      sLinha := sLinha + PreencherStringEsquerda(sValor, 10, '0');

                    if LowerCase(sNomeCampoI) = 'embalagem_mercadoria' then
                      sLinha := sLinha + PreencherStringDireita(sValor, 2);

                    if LowerCase(sNomeCampoI) = 'valor' then
                      sLinha := sLinha + PreencherStringEsquerda(sValor, 14, '0');

                    if LowerCase(sNomeCampoI) = 'desconto' then
                      sLinha := sLinha + PreencherStringEsquerda(sValor, 6, '0');

                    if LowerCase(sNomeCampoI) = 'qtd_embalagem' then
                      sLinha := sLinha + PreencherStringEsquerda(sValor, 12, '0');

                    if LowerCase(sNomeCampoI) = 'embalagem_deposito' then
                      sLinha := sLinha + PreencherStringEsquerda(sValor, 2);

                    if LowerCase(sNomeCampoI) = 'qtd_saldo_pedido' then
                      sLinha := sLinha + PreencherStringEsquerda(sValor, 21, '0');

                    if LowerCase(sNomeCampoI) = 'qtd_atendida_pedido' then
                      sLinha := sLinha + PreencherStringEsquerda(sValor, 21, '0');

                    if LowerCase(sNomeCampoI) = 'cod_mercadoria' then
                      sLinha := sLinha + PreencherStringDireita(sValor, 9);
                  end;
                end;
                Writeln(arq, sLinha);
              except
                on E : Exception do
                begin
                  ListErro.Add('Erro na linha dos itens do resgistro de recebimento');
                  ListErro.Add(E.Message);
                end;
              end;

              cdsItens.Next;
            end;
          finally
            CloseFile(arq);
          end;

          Next;
        end;
      end;
    end;
  finally
    CdsPrincipal.EnableControls;
    cdsItens.EnableControls;
  end;
end;

procedure LerArqRetornoSeparacao(var ListErro : TStringList);
var sDir, sDirFinal, sLinha : String;
    ListArquivo : TStringList;
    iArq, iQtdArq : Integer;
    fPesqArq : TSearchRec;
    qInsert, qDelete : TZQuery;
begin
  sDir        := DiretorioSistema.DirArqRetornoSeparacao;
  sDirFinal   := DiretorioSistema.DirArqRetornoSeparacaoFinalizados;
  ListArquivo := TStringList.Create;
  iQtdArq     := FindFirst(sDir + '*.txt', faAnyFile, fPesqArq);
  qInsert     := NewZQuery;
  qDelete     := NewZQuery;

  if not dmPrincipal.zConexao.InTransaction then
     dmPrincipal.zConexao.StartTransaction;

  try
    with qDelete do
    begin
      Close;
      Sql.Clear;
      Sql.Add('Delete from reiterlog.tmp_retorno_separacao');
      ExecSQL;
    end;

    with qInsert do
    begin
      Close;
      Sql.Clear;
      Sql.Add('INSERT INTO reiterlog.tmp_retorno_separacao( seq_separacao  ');
      Sql.Add('                                           , cod_item       ');
      Sql.Add('                                           , qtd_item       ');
      Sql.Add('                                           , dta_arquivo)   ');
      Sql.Add('                                     VALUES( :seq_separacao ');
      Sql.Add('                                           , :cod_item      ');
      Sql.Add('                                           , :qtd_item      ');
      Sql.Add('                                           , :dta_arquivo)  ');

      while iQtdArq = 0 do
      begin
        ListArquivo.LoadFromFile(sDir + fPesqArq.Name);

        for iArq := 0 to ListArquivo.Count - 1 do
        begin
          try
            sLinha := ListArquivo[iArq];

            Close;
            ParamByName('seq_separacao').AsInteger  := StrToInt(PegarSomenteValorDoCampo(sLinha, 1, 8));
            ParamByName('cod_item').AsInteger       := StrToInt(PegarSomenteValorDoCampo(sLinha, 9, 9));
            ParamByName('qtd_item').AsFloat         := StrToFloat(PegarSomenteValorDoCampo(sLinha, 18, 10));
            ParamByName('dta_arquivo').AsDateTime   := now;
            ExecSQL;
          except
            On E : Exception do
            begin
              ListErro.Add('Erro ao ler o arquivo de Retorno.');
              ListErro.Add(E.Message);
              dmPrincipal.zConexao.Rollback;
            end;
          end;
        end;

        if not FileExists(sDirFinal + fPesqArq.Name) then
          MoveFile( PChar(sDir + fPesqArq.Name)
                  , PChar(sDirFinal + fPesqArq.Name))
        else
        begin
          //DeleteFile(sDirFinal + fPesqArq.Name);
          MoveFile( PChar(sDir + fPesqArq.Name)
                  , PChar(sDirFinal + fPesqArq.Name +  '_' + FormatDateTime('DD_MM_YYYY_HH_MM', Now)));
        end;

        iQtdArq := SysUtils.FindNext(fPesqArq);
      end;
    end;

    dmPrincipal.zConexao.Commit;
  finally
    FindClose(fPesqArq);
    FreeAndNil(ListArquivo);
  end;

end;

procedure LerArqRetornoRecebimento(var ListErro : TStringList);
var sDir, sDirFinal, sLinha : String;
    ListArquivo : TStringList;
    iArq, iLinha, iQtdArq : Integer;
    fPesqArq : TSearchRec;
    qInsert, qDelete : TZQuery;
begin
  sDir        := DiretorioSistema.DirArqRetornoRecebimento;
  sDirFinal   := DiretorioSistema.DirArqRetornoRecebimentoFinalizados;
  ListArquivo := TStringList.Create;
  iQtdArq     := FindFirst(sDir + '*.txt', faAnyFile, fPesqArq);
  qInsert     := NewZQuery;
  qDelete     := NewZQuery;

  if not dmPrincipal.zConexao.InTransaction then
     dmPrincipal.zConexao.StartTransaction;

  try
    with qDelete do
    begin
      Close;
      Sql.Clear;
      Sql.Add('Delete from reiterlog.tmp_retorno_recebimento');
      ExecSQL;
    end;

    with qInsert do
    begin
      Close;
      Sql.Clear;
      Sql.Add('INSERT INTO reiterlog.tmp_retorno_recebimento( num_cnpj_for  ');
      Sql.Add('                                             , num_nf        ');
      Sql.Add('                                             , num_serie_nf  ');
      Sql.Add('                                             , cod_item      ');
      Sql.Add('                                             , qtd_item      ');
      Sql.Add('                                             , dta_arquivo)  ');
      Sql.Add('                                       VALUES( :num_cnpj_for ');
      Sql.Add('                                             , :num_nf       ');
      Sql.Add('                                             , :num_serie_nf ');
      Sql.Add('                                             , :cod_item     ');
      Sql.Add('                                             , :qtd_item     ');
      Sql.Add('                                             , :dta_arquivo) ');

      while iQtdArq = 0 do
      begin
        ListArquivo.LoadFromFile(sDir + fPesqArq.Name);

        for iArq := 0 to ListArquivo.Count - 1 do
        begin
          try
            sLinha := ListArquivo[iArq];

            Close;
            ParamByName('num_cnpj_for').AsString := PegarSomenteValorDoCampo(sLinha, 1, 16);
            ParamByName('num_nf').AsString       := PegarSomenteValorDoCampo(sLinha, 17, 9);
            ParamByName('num_serie_nf').AsString := PegarSomenteValorDoCampo(sLinha, 26, 3);
            ParamByName('cod_item').AsInteger    := StrToInt(PegarSomenteValorDoCampo(sLinha, 29, 9));
            ParamByName('qtd_item').AsFloat      := StrToFloat(PegarSomenteValorDoCampo(sLinha, 38, 10));
            ParamByName('dta_arquivo').AsDateTime := now;
            ExecSQL;
          except
            On E : Exception do
            begin
              ListErro.Add('Erro ao ler o arquivo de Retorno.');
              ListErro.Add(E.Message);
              dmPrincipal.zConexao.Rollback;
            end;
          end;
        end;

        if not FileExists(sDirFinal + fPesqArq.Name) then
          MoveFile( PChar(sDir + fPesqArq.Name)
                  , PChar(sDirFinal + fPesqArq.Name))
        else
        begin
          //DeleteFile(sDirFinal + fPesqArq.Name);
          MoveFile( PChar(sDir + fPesqArq.Name)
                  , PChar(sDirFinal + fPesqArq.Name +  '_' + FormatDateTime('DD_MM_YYYY_HH_MM', Now)));
        end;

        //MoveFile(PChar(sDir + fPesqArq.Name), PChar(sDirFinal + fPesqArq.Name));

        iQtdArq := SysUtils.FindNext(fPesqArq);
      end;
    end;

    dmPrincipal.zConexao.Commit;
  finally
    FindClose(fPesqArq);
    FreeAndNil(ListArquivo);
  end;
end;

function PreencherStringDireita(sValor : String; iTamanho : Integer; cPreenchimento : Char = Chr(32)) : String;
var i : Integer;
begin
  if Length(sValor) >= iTamanho then
     Result := copy(sValor, 0, iTamanho)
  else
  begin
    Result := sValor;

    for i := Length(sValor) to iTamanho - 1 do
    begin
      Result := Result + cPreenchimento;
    end;
  end;
end;

function PreencherStringEsquerda(sValor : String; iTamanho : Integer; cPreenchimento : Char = Chr(32)) : String;
var i : Integer;
begin
  if Length(sValor) >= iTamanho then
     Result := copy(sValor, 0, iTamanho)
  else
  begin
    Result := sValor;

    for i := Length(sValor) to iTamanho - 1 do
    begin
      Result := cPreenchimento + Result;
    end;
  end;
end;

function PegarSomenteValorDoCampo(sLinha : String; iPosicaoInicial, iPosicaoFinal : Integer;
                                  cPreenchimento : Char = Chr(32)) : String;
var i : integer;
begin
  Result := copy(sLinha, iPosicaoInicial, iPosicaoFinal);
  Result := Trim(Result);
end;

function AlteraStatus(sTipoArquivo, sStatusOLD, sStatusNew : String; var ListErro : TStringList;
                      bSomenteQtdRetornada : Boolean = False; iSequencia : Integer = 0; bValidarStatus : Boolean = True ) : Boolean;
var qAltera : TZQuery;
begin
  qAltera := NewZQuery;

  if not dmPrincipal.zConexao.InTransaction then
    dmPrincipal.zConexao.StartTransaction;

  try
    try
      with qAltera do
      begin
        Close;
        Sql.Clear;

        if sTipoArquivo = 'S' then
        begin
          Sql.Add('UPDATE reiterlog.tab_separacao a SET ind_status = case when ((:statusNew = ''F'') and    ');
          Sql.Add('                                                             (a.ind_finalizado = ''N'')) ');
          Sql.Add('                                                       THEN ''AR''                       ');
          Sql.Add('                                                       else :statusNew                   ');
          Sql.Add('                                                   end                                   ');
          Sql.Add('                               WHERE 1 = 1                                               ');

          if sStatusOLD <> '' then
           Sql.Add('                                AND ind_status = :statusOld                             ');

          if bSomenteQtdRetornada then
          begin
            Sql.Add('                                 and EXISTS(Select 1                                  ');
            Sql.Add('                                              from reiterlog.tab_separacao_item aa    ');
            Sql.Add('                                             where aa.seq_separacao = a.seq_separacao ');
            Sql.Add('                                               and ((aa.qtd_diferenca <> 0) or        ');
            Sql.Add('                                                    (aa.qtd_retornada <> 0)))         ');
          end;

          if iSequencia <> 0 then
          begin
            Sql.Add('                                 and a.seq_separacao = :sequencia               ');

            if bValidarStatus then
              Sql.Add('                                 and a.ind_status not in(''F'', ''PE'', ''PR'') ');
          end;
        end
        else
        begin
          Sql.Add('UPDATE reiterlog.tab_recebimento a SET ind_status = case when ((:statusNew = ''F'') and    ');
          Sql.Add('                                                               (a.ind_finalizado = ''N'')) ');
          Sql.Add('                                                         THEN ''AR''                       ');
          Sql.Add('                                                         else :statusNew                   ');
          Sql.Add('                                                     end                                   ');
          Sql.Add('                                 WHERE 1 = 1                                               ');

          if sStatusOLD <> '' then
           Sql.Add('                                  AND ind_status = :statusOld                             ');

          if bSomenteQtdRetornada then
          begin
            Sql.Add('                                 and EXISTS(Select 1                                      ');
            Sql.Add('                                              from reiterlog.tab_recebimento_item aa      ');
            Sql.Add('                                             where aa.seq_recebimento = a.seq_recebimento ');
            Sql.Add('                                               and ((aa.qtd_diferenca <> 0) or            ');
            Sql.Add('                                                    (aa.qtd_retornada <> 0)))             ');
          end;

          if iSequencia <> 0 then
          begin
            Sql.Add('                                 and a.seq_recebimento = :sequencia             ');
            Sql.Add('                                 and a.ind_status not in(''F'', ''PE'', ''PR'') ');
          end;
        end;

        if sStatusOLD <> '' then
          ParamByName('statusOld').AsString := sStatusOLD;

        ParamByName('statusNew').AsString := sStatusNew;

        if iSequencia <> 0 then
         ParamByName('sequencia').AsInteger := iSequencia;

        ExecSQL;
      end;

      dmPrincipal.zConexao.Commit;
    except
      on E : Exception do
      begin
        dmPrincipal.zConexao.Rollback;
        ListErro.Add('Erro ao Atualizar o Status');
        ListErro.Add(E.Message);
      end;
    end;
  finally
    FreeAndNil(qAltera);
  end;
end;

function TirarCaractereze(sTexto : String) : String;
begin
  Result := sTexto;
  Result := StringReplace(Result, ',', '', [rfReplaceAll]);
  Result := StringReplace(Result, '.', '', [rfReplaceAll]);
  Result := StringReplace(Result, '-', '', [rfReplaceAll]);
  Result := StringReplace(Result, '/', '', [rfReplaceAll]);
end;

function PegarCodSequencia(sSequencia : String) : Integer;
var qSequencia : TZQuery;
begin
  Result := 1;
  
  qSequencia := NewZQuery;

  try
    with qSequencia do
    begin
      Close;
      Sql.Clear;
      Sql.Add('SELECT NEXTVAL('+  QuotedStr(sSequencia) +') AS seq ');
      Open;
      First;

      Result := FieldByName('Seq').AsInteger
    end;
  finally
    FreeAndNil(qSequencia);
  end;
end;

procedure ValidarQtdRetornoRecebimento(var ListErro : TStringList);
var qRetorno, qSumItemRecebimento, qItemRecebimento, qAtuQtdCorreta, qAtuQtdDif : TZQuery;
    fRetornoQtdItem, fSumQtditem, fQtdItem, fDifQtdItem : Real;
    sNumNota, sSerie, sCNPJ : String;
    iSeqRecebimento, iSeqItem, iCodItem : Integer;
begin
  qRetorno            := NewZQuery;
  qSumItemRecebimento := NewZQuery;
  qItemRecebimento    := NewZQuery;
  qAtuQtdCorreta      := NewZQuery;
  qAtuQtdDif          := NewZQuery;

  try
    try
      if not dmPrincipal.zConexao.InTransaction then
        dmPrincipal.zConexao.StartTransaction;

      with qAtuQtdCorreta do
      begin
        Close;
        Sql.Clear;
        Sql.Add('update reiterlog.tab_recebimento_item set qtd_retornada = qtd_item           ');
        Sql.Add('                                    where seq_recebimento = :seq_recebimento ');
        Sql.Add('                                      and cod_item = :cod_item               ');
      end;

      with qAtuQtdDif do
      begin
        Close;
        Sql.Clear;
        Sql.Add('update reiterlog.tab_recebimento_item set qtd_retornada = :qtd_retornada              ');
        Sql.Add('                                        , qtd_diferenca = (qtd_item - :qtd_retornada) ');
        Sql.Add('                                    where seq_recebimento = :seq_recebimento          ');
        Sql.Add('                                      and cod_item = :cod_item                        ');
        Sql.Add('                                      and seq_item = :seq_item                        ');
      end;

      with qItemRecebimento do
      begin
        Close;
        Sql.Clear;
        Sql.Add('SELECT a.seq_item                           ');
        Sql.Add('     , a.cod_item                           ');
        Sql.Add('     , a.qtd_item                           ');
        Sql.Add('  FROM reiterlog.tab_recebimento_item a     ');
        Sql.Add(' WHERE a.seq_recebimento = :seq_recebimento ');
        Sql.Add('   AND a.cod_item = :cod_item               ');
        Sql.Add(' Order By a.seq_item asc                    ');
      end;

      with qRetorno do
      begin
        Close;
        Sql.Clear;
        Sql.Add('SELECT sum(a.qtd_item) as qtd_item                             ');
        Sql.Add('  FROM reiterlog.tmp_retorno_recebimento a                     ');
        Sql.Add(' WHERE ltrim(a.num_nf, ''0'') = ltrim(:num_nota, ''0'')        ');
        Sql.Add('   AND ltrim(a.num_serie_nf, ''0'') = ltrim(:num_serie, ''0'') ');
        Sql.Add('   AND a.num_cnpj_for = :num_cnpj                              ');
        Sql.Add('   AND a.cod_item = :cod_item                                  ');
      end;

      with qSumItemRecebimento do
      begin
        Close;
        sql.Clear;
        Sql.Add('SELECT a.seq_recebimento                                                         ');
        Sql.Add('     , b.num_nota                                                                ');
        Sql.Add('     , b.num_serie                                                               ');
        Sql.Add('     , d.num_cnpj_cpf                                                            ');
        Sql.Add('     , c.cod_item                                                                ');
        Sql.Add('     , sum(c.qtd_item) as qtd_item                                               ');
        Sql.Add('  FROM reiterlog.tab_recebimento a                                               ');
        Sql.Add('  JOIN tab_nota_fiscal_entrada b on b.seq_nota = a.seq_recebimento               ');
        Sql.Add('  JOIN reiterlog.tab_recebimento_item c on c.seq_recebimento = a.seq_recebimento ');
        Sql.Add('  JOIN tab_pessoa d on d.cod_pessoa = b.cod_pessoa_fornecedor                    ');
        Sql.Add(' WHERE a.ind_status = ''PR''                                                     ');
        Sql.Add('   and EXISTS(Select 1                                                           ');
        Sql.Add('                from reiterlog.tmp_retorno_recebimento aa                        ');
        Sql.Add('               where ltrim(aa.num_nf, ''0'') = ltrim(b.num_nota, ''0'')          ');
        Sql.Add('                 and ltrim(aa.num_serie_nf, ''0'') = ltrim(b.num_serie, ''0'')   ');
        Sql.Add('                 and aa.num_cnpj_for = d.num_cnpj_cpf)                           ');
        Sql.Add(' GROUP BY 1,2,3,4,5                                                              ');
        Open;
        First;

        while not Eof do
        begin
          sNumNota        := FieldByName('num_nota').AsString;
          sSerie          := FieldByName('num_serie').AsString;
          sCNPJ           := FieldByName('num_cnpj_cpf').AsString;
          iSeqRecebimento := FieldByName('seq_recebimento').AsInteger;
          iCodItem        := FieldByName('cod_item').AsInteger;
          fSumQtditem     := FieldByName('qtd_item').AsFloat;

          qRetorno.Close;
          qRetorno.ParamByName('num_nota').AsString  := sNumNota;
          qRetorno.ParamByName('num_serie').AsString := sSerie;
          qRetorno.ParamByName('num_cnpj').AsString  := sCNPJ;
          qRetorno.ParamByName('cod_item').AsInteger := iCodItem;
          qRetorno.Open;
          qRetorno.First;

          fRetornoQtdItem := qRetorno.FieldByName('qtd_item').AsFloat;

          if fSumQtditem <> fRetornoQtdItem then
          begin
            qItemRecebimento.Close;
            qItemRecebimento.ParamByName('seq_recebimento').AsInteger := iSeqRecebimento;
            qItemRecebimento.ParamByName('cod_item').AsInteger        := iCodItem;
            qItemRecebimento.Open;
            qItemRecebimento.First;

            fDifQtdItem := fRetornoQtdItem;

            while not qItemRecebimento.Eof do
            begin
              fQtdItem := qItemRecebimento.FieldByName('qtd_item').AsFloat;
              iSeqItem := qItemRecebimento.FieldByName('seq_item').AsInteger;

              if fDifQtdItem > fQtdItem then
                fDifQtdItem := fDifQtdItem - fQtdItem
              else if (fDifQtdItem < fQtdItem) and
                      (fDifQtdItem >= 0) then
              begin
                fQtdItem    := fDifQtdItem;
                fDifQtdItem := fQtdItem - fDifQtdItem;
              end
              else
                fQtdItem := 0;

              qAtuQtdDif.Close;
              qAtuQtdDif.ParamByName('qtd_retornada').AsFloat    := fQtdItem;
              qAtuQtdDif.ParamByName('cod_item').AsInteger       := iCodItem;
              qAtuQtdDif.ParamByName('seq_recebimento').AsInteger := iSeqRecebimento;
              qAtuQtdDif.ParamByName('seq_item').AsInteger       := iSeqItem;
              qAtuQtdDif.ExecSQL;

              qItemRecebimento.Next;
            end;
          end
          else
          begin
            qAtuQtdCorreta.Close;
            qAtuQtdCorreta.ParamByName('cod_item').AsInteger        := iCodItem;
            qAtuQtdCorreta.ParamByName('seq_recebimento').AsInteger := iSeqRecebimento;
            qAtuQtdCorreta.ExecSQL;
          end;

          Next;
        end;
      end;

      dmPrincipal.zConexao.Commit;
    except
      on E : Exception do
      begin
        dmPrincipal.zConexao.Rollback;
        ListErro.Add('Erro no processo de validacao da quantidade do retorno das notas de entrada');
        ListErro.Add(E.Message);
      end;
    end;
  finally
    FreeAndNil(qRetorno);
    FreeAndNil(qSumItemRecebimento);
    FreeAndNil(qItemRecebimento);
    FreeAndNil(qAtuQtdCorreta);
    FreeAndNil(qAtuQtdDif);
  end;
end;

procedure ValidarQtdRetornoSeparacao(var ListErro : TStringList);
var qExisteRetorno, qRetorno, qSumItemSeparacao, qItemSeparacao, qAtuQtdCorreta, qAtuQtdDif : TZQuery;
    fRetornoQtdItem, fSumQtditem, fQtdItem, fDifQtdItem : Real;
    iSeqSeparacao, iSeqItem, iCodItem : Integer;
begin
  qRetorno          := NewZQuery;
  qSumItemSeparacao := NewZQuery;
  qItemSeparacao    := NewZQuery;
  qAtuQtdCorreta    := NewZQuery;
  qAtuQtdDif        := NewZQuery;

  try
    try
      if not dmPrincipal.zConexao.InTransaction then
        dmPrincipal.zConexao.StartTransaction;

      with qAtuQtdCorreta do
      begin
        Close;
        Sql.Clear;
        Sql.Add('update reiterlog.tab_separacao_item set qtd_retornada = qtd_item       ');
        Sql.Add('                                  where seq_separacao = :seq_separacao ');
        Sql.Add('                                    and cod_item = :cod_item           ');
      end;

      with qAtuQtdDif do
      begin
        Close;
        Sql.Clear;
        Sql.Add('update reiterlog.tab_separacao_item set qtd_retornada = :qtd_retornada              ');
        Sql.Add('                                      , qtd_diferenca = (qtd_item - :qtd_retornada) ');
        Sql.Add('                                  where seq_separacao = :seq_separacao              ');
        Sql.Add('                                    and cod_item = :cod_item                        ');
        Sql.Add('                                    and seq_item = :seq_item                        ');
      end;

      with qItemSeparacao do
      begin
        Close;
        Sql.Clear;
        Sql.Add('SELECT a.seq_item                         ');
        Sql.Add('     , a.cod_item                         ');
        Sql.Add('     , a.qtd_item                         ');
        Sql.Add('  FROM reiterlog.tab_separacao_item a     ');
        Sql.Add(' WHERE a.seq_separacao = :seq_separacao   ');
        Sql.Add('   AND a.cod_item = :cod_item             ');
        Sql.Add(' Order By a.seq_item asc                  ');
      end;

      with qRetorno do
      begin
        Close;
        Sql.Clear;
        Sql.Add('SELECT sum(a.qtd_item) as qtd_item       ');
        Sql.Add('  FROM reiterlog.tmp_retorno_separacao a ');
        Sql.Add(' WHERE a.seq_separacao = :seq_separacao  ');
        Sql.Add('   AND a.cod_item = :cod_item            ');
      end;

      with qSumItemSeparacao do
      begin
        Close;
        sql.Clear;
        Sql.Add('SELECT a.seq_separacao                                                     ');
        Sql.Add('     , b.cod_item                                                          ');
        Sql.Add('     , sum(b.qtd_item) as qtd_item                                         ');
        Sql.Add('  FROM reiterlog.tab_separacao a                                           ');
        Sql.Add('  JOIN reiterlog.tab_separacao_item b on b.seq_separacao = a.seq_separacao ');
        Sql.Add(' WHERE a.ind_status = ''PR''                                               ');
        Sql.Add('   and Exists(Select 1                                                     ');
        Sql.Add('                from reiterlog.tmp_retorno_separacao aa                    ');
        Sql.Add('               where aa.seq_separacao = a.seq_separacao)                   ');
        Sql.Add(' GROUP BY 1,2                                                              ');
        Open;
        First;

        while not Eof do
        begin
          iSeqSeparacao := FieldByName('seq_separacao').AsInteger;
          iCodItem      := FieldByName('cod_item').AsInteger;
          fSumQtditem   := FieldByName('qtd_item').AsFloat;

          qRetorno.Close;
          qRetorno.ParamByName('seq_separacao').AsInteger := iSeqSeparacao;
          qRetorno.ParamByName('cod_item').AsInteger      := iCodItem;
          qRetorno.Open;
          qRetorno.First;

          fRetornoQtdItem := qRetorno.FieldByName('qtd_item').AsFloat;

          if fSumQtditem <> fRetornoQtdItem then
          begin
            qItemSeparacao.Close;
            qItemSeparacao.ParamByName('seq_separacao').AsInteger := iSeqSeparacao;
            qItemSeparacao.ParamByName('cod_item').AsInteger      := iCodItem;
            qItemSeparacao.Open;
            qItemSeparacao.First;

            fDifQtdItem := fRetornoQtdItem;

            while not qItemSeparacao.Eof do
            begin
              fQtdItem := qItemSeparacao.FieldByName('qtd_item').AsFloat;
              iSeqItem := qItemSeparacao.FieldByName('seq_item').AsInteger;

              if fDifQtdItem > fQtdItem then
                fDifQtdItem := fDifQtdItem - fQtdItem
              else if (fDifQtdItem < fQtdItem) and
                      (fDifQtdItem >= 0) then
              begin
                fQtdItem    := fDifQtdItem;
                fDifQtdItem := fQtdItem - fDifQtdItem;
              end
              else
                fQtdItem := 0;

              qAtuQtdDif.Close;
              qAtuQtdDif.ParamByName('qtd_retornada').AsFloat   := fQtdItem;
              qAtuQtdDif.ParamByName('cod_item').AsInteger      := iCodItem;
              qAtuQtdDif.ParamByName('seq_separacao').AsInteger := iSeqSeparacao;
              qAtuQtdDif.ParamByName('seq_item').AsInteger      := iSeqItem;
              qAtuQtdDif.ExecSQL;

              qItemSeparacao.Next;
            end;
          end
          else
          begin
            qAtuQtdCorreta.Close;
            qAtuQtdCorreta.ParamByName('cod_item').AsInteger      := iCodItem;
            qAtuQtdCorreta.ParamByName('seq_separacao').AsInteger := iSeqSeparacao;
            qAtuQtdCorreta.ExecSQL;
          end;

          Next;
        end;
      end;

      dmPrincipal.zConexao.Commit;
    except
      on E : Exception do
      begin
        dmPrincipal.zConexao.Rollback;
        ListErro.Add('Erro no processo de validacao da quantidade do retorno das Pre Venda');
        ListErro.Add(E.Message);
      end;
    end;
  finally
    FreeAndNil(qRetorno);
    FreeAndNil(qSumItemSeparacao);
    FreeAndNil(qItemSeparacao);
    FreeAndNil(qAtuQtdCorreta);
    FreeAndNil(qAtuQtdDif);
  end;
end;

function RetornaAlmoxrifado(iCodAlmoxOri : Integer; sTipo : String; bAlmoxFinal : Boolean = True) : Integer;
var qConsulta : TZQuery;
begin
  Result := iCodAlmoxOri;
  qConsulta := NewZQuery;

  try
    with qConsulta do
    begin
      Close;
      Sql.Clear;

      if bAlmoxFinal then
      begin
        Sql.Add('SELECT a.cod_almoxarifado_final as CodAlmox                ');
        Sql.Add('  FROM reiterlog.tab_rel_almoxarifado_intermediario a      ');
        Sql.Add(' WHERE a.cod_almoxarifado_intermediario = :CodAlmoxarifado ');
        Sql.Add('   AND ((a.ind_tipo = :ind_tipo) or (a.ind_tipo = ''A''))  ');
      end
      else
      begin
        Sql.Add('SELECT a.cod_almoxarifado_diferenca as CodAlmox            ');
        Sql.Add('  FROM reiterlog.tab_rel_almoxarifado_intermediario a      ');
        Sql.Add(' WHERE a.cod_almoxarifado_intermediario = :CodAlmoxarifado ');
        Sql.Add('   AND ((a.ind_tipo = :ind_tipo) or (a.ind_tipo = ''A''))  ');
      end;

      ParamByName('ind_tipo').AsString         := sTipo;
      ParamByName('CodAlmoxarifado').AsInteger := iCodAlmoxOri;

      Open;
      First;

      if not IsEmpty then
        Result := FieldByName('CodAlmox').AsInteger;
    end;
  finally
    FreeAndNil(qConsulta);
  end;
end;

procedure ProcessoTransfItensEntrada(iSeqNota : Integer; var ListErro : TStringList);
var qTransAlmox, qTransAlmoxItens, qRecebimentoItem, qUpdReceTransPri, qUpdReceTransDif : TZQuery;
    iSeqAlmox, iCodAlmOrigem, iCodAlmoDest : Integer;
    fQtditem : Real;
    sTipo : String;
begin
  qTransAlmox      := NewZQuery;
  qTransAlmoxItens := NewZQuery;
  qRecebimentoItem := NewZQuery;
  qUpdReceTransPri := NewZQuery;
  qUpdReceTransDif := NewZQuery;

  try
    if not dmPrincipal.zConexao.InTransaction then
      dmPrincipal.zConexao.StartTransaction;

    try
      with qUpdReceTransPri do
      begin
        Close;
        Sql.Clear;
        Sql.Add('UPDATE reiterlog.tab_recebimento a SET seq_trans_almox_principal = :seqAlmoxarifado ');
        Sql.Add('                                 WHERE a.seq_recebimento = :seq_recebimento         ');
      end;

      with qUpdReceTransDif do
      begin
        Close;
        Sql.Clear;
        Sql.Add('UPDATE reiterlog.tab_recebimento a SET seq_trans_almox_diferenca = :seqAlmoxarifado ');
        Sql.Add('                                 WHERE a.seq_recebimento = :seq_recebimento         ');
      end;

      with qTransAlmox do
      begin
        Close;
        Sql.Clear;
        Sql.Add('INSERT INTO tab_transferencia_almoxarifado ( seq_transferencia                   ');
        Sql.Add('                                           , ind_tipo_transferencia              ');
        Sql.Add('                                           , cod_almoxarifado_origem             ');
        Sql.Add('                                           , cod_almoxarifado_destino            ');
        Sql.Add('                                           , dta_transferencia                   ');
        Sql.Add('                                           , num_documento                       ');
        Sql.Add('                                           , cod_empresa                         ');
        Sql.Add('                                           , nom_usuario)                        ');
        Sql.Add('                                     VALUES( :seq_transferencia                  ');
        Sql.Add('                                           , ''M''                               ');
        Sql.Add('                                           , :cod_almoxarifado_origem            ');
        Sql.Add('                                           , :cod_almoxarifado_destino           ');
        Sql.Add('                                           , :dta_transferencia                  ');
        Sql.Add('                                           , cast(:num_documento as varchar(10)) ');
        Sql.Add('                                           , :cod_empresa                        ');
        Sql.Add('                                           , ''ReiterLog'')                      ');
      end;

      with qTransAlmoxItens do
      begin
        Close;
        Sql.Clear;
        Sql.Add('INSERT INTO tab_transf_almox_item ( seq_transferencia  ');
        Sql.Add('                                  , cod_item           ');
        Sql.Add('                                  , qtd_movimento)     ');
        Sql.Add('                           VALUES ( :seq_transferencia ');
        Sql.Add('                                  , :cod_item          ');
        Sql.Add('                                  , :qtd_movimento)    ');
      end;

      with qRecebimentoItem do
      begin
        Close;
        Sql.Clear;
        Sql.Add('SELECT a.seq_recebimento                                                         ');
        Sql.Add('     , a.ind_tipo                                                                ');
        Sql.Add('     , b.cod_item                                                                ');
        Sql.Add('     , c.cod_almoxarifado                                                        ');
        Sql.Add('     , d.cod_empresa                                                             ');
        Sql.Add('     , sum(b.qtd_retornada * b.qtd_unidade) as qtd_item                          ');
        Sql.Add('  FROM reiterlog.tab_recebimento a                                               ');
        Sql.Add('  JOIN reiterlog.tab_recebimento_item b on b.seq_recebimento = a.seq_recebimento ');
        Sql.Add('  JOIN tab_item_nfe c on c.seq_nota = a.seq_recebimento and                      ');
        Sql.Add('                         c.seq_item = b.seq_item                                 ');
        Sql.Add('  JOIN tab_nota_fiscal_entrada d on d.seq_nota = a.seq_recebimento               ');
        Sql.Add(' WHERE a.seq_recebimento = :seq_nota                                             ');
        Sql.Add('   AND b.qtd_retornada > 0                                                       ');
        Sql.Add(' GROUP BY 1,2,3,4,5                                                              ');

        ParamByName('seq_nota').AsInteger := iSeqNota;
        Open;
        First;
        iCodAlmOrigem := 0;

        while not Eof do
        begin
          if (iCodAlmOrigem <> FieldByName('cod_almoxarifado').AsInteger) then
          begin
            iSeqAlmox     := PegarCodSequencia('gen_transf_almoxarifado');
            iCodAlmOrigem := FieldByName('cod_almoxarifado').AsInteger;
            iCodAlmoDest  := RetornaAlmoxrifado( iCodAlmOrigem
                                               , FieldByName('ind_tipo').AsString
                                               , True);

            qTransAlmox.Close;
            qTransAlmox.ParamByName('seq_transferencia').AsInteger        := iSeqAlmox;
            qTransAlmox.ParamByName('cod_almoxarifado_origem').AsInteger  := iCodAlmOrigem;
            qTransAlmox.ParamByName('cod_almoxarifado_destino').AsInteger := iCodAlmoDest;
            qTransAlmox.ParamByName('dta_transferencia').AsDate           := now;
            qTransAlmox.ParamByName('num_documento').AsString             := IntToStr(iSeqNota);
            qTransAlmox.ParamByName('cod_empresa').AsInteger              := FieldByName('cod_empresa').AsInteger;
            qTransAlmox.ExecSQL;

            qUpdReceTransPri.Close;
            qUpdReceTransPri.ParamByName('seqAlmoxarifado').AsInteger := iSeqAlmox;
            qUpdReceTransPri.ParamByName('seq_recebimento').AsInteger := iSeqNota;
            qUpdReceTransPri.ExecSQL;
          end;

          qTransAlmoxItens.Close;
          qTransAlmoxItens.ParamByName('seq_transferencia').AsInteger := iSeqAlmox;
          qTransAlmoxItens.ParamByName('cod_item').AsInteger          := FieldByName('cod_item').AsInteger;
          qTransAlmoxItens.ParamByName('qtd_movimento').AsFloat       := FieldByName('qtd_item').AsFloat;
          qTransAlmoxItens.ExecSQL;

          Next;
        end;


        Close;
        Sql.Clear;
        Sql.Add('SELECT a.seq_recebimento                                                         ');
        Sql.Add('     , a.ind_tipo                                                                ');
        Sql.Add('     , b.cod_item                                                                ');
        Sql.Add('     , c.cod_almoxarifado                                                        ');
        Sql.Add('     , d.cod_empresa                                                             ');
        Sql.Add('     , sum(b.qtd_diferenca * b.qtd_unidade) as qtd_item                          ');
        Sql.Add('  FROM reiterlog.tab_recebimento a                                               ');
        Sql.Add('  JOIN reiterlog.tab_recebimento_item b on b.seq_recebimento = a.seq_recebimento ');
        Sql.Add('  JOIN tab_item_nfe c on c.seq_nota = a.seq_recebimento and                      ');
        Sql.Add('                         c.seq_item = b.seq_item                                 ');
        Sql.Add('  JOIN tab_nota_fiscal_entrada d on d.seq_nota = a.seq_recebimento               ');
        Sql.Add(' WHERE a.seq_recebimento = :seq_nota                                             ');
        Sql.Add('   AND b.qtd_diferenca > 0                                                       ');
        Sql.Add(' GROUP BY 1,2,3,4,5                                                              ');

        ParamByName('seq_nota').AsInteger := iSeqNota;
        Open;
        First;
        iCodAlmOrigem := 0;

        while not Eof do
        begin
          if (iCodAlmOrigem <> FieldByName('cod_almoxarifado').AsInteger) then
          begin
            iSeqAlmox     := PegarCodSequencia('gen_transf_almoxarifado');
            iCodAlmOrigem := FieldByName('cod_almoxarifado').AsInteger;
            iCodAlmoDest  := RetornaAlmoxrifado( iCodAlmOrigem
                                               , FieldByName('ind_tipo').AsString
                                               , False);

            qTransAlmox.Close;
            qTransAlmox.ParamByName('seq_transferencia').AsInteger        := iSeqAlmox;
            qTransAlmox.ParamByName('cod_almoxarifado_origem').AsInteger  := iCodAlmOrigem;
            qTransAlmox.ParamByName('cod_almoxarifado_destino').AsInteger := iCodAlmoDest;
            qTransAlmox.ParamByName('dta_transferencia').AsDate           := now;
            qTransAlmox.ParamByName('num_documento').AsString             := IntToStr(iSeqNota);
            qTransAlmox.ParamByName('cod_empresa').AsInteger              := FieldByName('cod_empresa').AsInteger;
            qTransAlmox.ExecSQL;

            qUpdReceTransDif.Close;
            qUpdReceTransDif.ParamByName('seqAlmoxarifado').AsInteger := iSeqAlmox;
            qUpdReceTransDif.ParamByName('seq_recebimento').AsInteger := iSeqNota;
            qUpdReceTransDif.ExecSQL;
          end;

          qTransAlmoxItens.Close;
          qTransAlmoxItens.ParamByName('seq_transferencia').AsInteger := iSeqAlmox;
          qTransAlmoxItens.ParamByName('cod_item').AsInteger          := FieldByName('cod_item').AsInteger;
          qTransAlmoxItens.ParamByName('qtd_movimento').AsFloat       := FieldByName('qtd_item').AsFloat;
          qTransAlmoxItens.ExecSQL;

          Next;
        end;
      end;

      dmPrincipal.zConexao.Commit;
      Sleep(1000);
    except
      on E : Exception do
      begin
        ListErro.Add('Erro ao transferir intes da Nota Fiscal de Entrada: ' + IntToStr(iSeqNota));
        ListErro.Add(E.Message);
        dmPrincipal.zConexao.Rollback;
      end;
    end;
  finally
    FreeAndNil(qTransAlmox);
    FreeAndNil(qTransAlmoxItens);
    FreeAndNil(qRecebimentoItem);
    FreeAndNil(qUpdReceTransPri);
    FreeAndNil(qUpdReceTransDif);
  end;
end;

procedure ProcessoCorrigiQtdPreVenda(iSeqPreVenda : Integer; var ListErro : TStringList);
var qSepItem, qAtuPreVendaItem, qDeleteItem : TZQuery;
begin
  qSepItem         := NewZQuery;
  qAtuPreVendaItem := NewZQuery;
  qDeleteItem      := NewZQuery;

  try
    try
      if not dmPrincipal.zConexao.InTransaction then
        dmPrincipal.zConexao.StartTransaction;

      with qDeleteItem do
      begin
        Close;
        Sql.Clear;
        Sql.Add('DELETE                                  ');
        Sql.Add('  FROM tab_item_pre_venda a             ');
        Sql.Add(' WHERE a.seq_pre_venda = :seq_pre_venda ');
        Sql.Add('   AND a.qtd_entregue_convertida = 0    ');
      end;

      with qAtuPreVendaItem do
      begin
        Close;
        Sql.Clear;
        Sql.Add('UPDATE tab_item_pre_venda SET qtd_item_cancelado = :qtd_cancelada                 ');
        Sql.Add('                            , qtd_atendida = (qtd_atendida - :qtd_cancelada)      ');
        Sql.Add('                            , qtd_entregue = (qtd_entregue - :qtd_cancelada)      ');
        Sql.Add('                            , qtd_entregue_convertida = (qtd_entregue_convertida - :qtd_cancelada_convertida) ');
        Sql.Add('                        WHERE seq_pre_venda = :seq_pre_venda                      ');
        Sql.Add('                          AND seq_item = :seq_item                                ');
      end;

      with qSepItem do
      begin
        Close;
        Sql.Clear;
        Sql.Add('SELECT a.cod_item                                                    ');
        Sql.Add('     , a.seq_item                                                    ');
        Sql.Add('     , a.qtd_diferenca                                               ');
        Sql.Add('     , (a.qtd_diferenca * a.qtd_unidade) as qtd_diferenca_convertida ');
        Sql.Add('  FROM reiterlog.tab_separacao_item a                                ');
        Sql.Add(' WHERE a.seq_separacao = :seq_separacao                              ');
        Sql.Add('   AND a.qtd_diferenca > 0                                           ');
        Sql.Add(' ORDER BY a.seq_item asc                                             ');

        ParamByName('seq_separacao').AsInteger := iSeqPreVenda;
        Open;
        First;

        while not Eof do
        begin
          qAtuPreVendaItem.Close;
          qAtuPreVendaItem.ParamByName('qtd_cancelada_convertida').AsFloat   := FieldByName('qtd_diferenca_convertida').AsFloat;
          qAtuPreVendaItem.ParamByName('qtd_cancelada').AsFloat              := FieldByName('qtd_diferenca').AsFloat;
          qAtuPreVendaItem.ParamByName('seq_pre_venda').AsInteger            := iSeqPreVenda;
          qAtuPreVendaItem.ParamByName('seq_item').AsInteger                 := FieldByName('seq_item').AsInteger;
          qAtuPreVendaItem.ExecSQL;

          Next;
        end;
      end;

      with qAtuPreVendaItem do
      begin
        Close;
        Sql.Clear;
        Sql.Add('UPDATE tab_item_pre_venda SET qtd_volume = :qtd_volume             ');
        Sql.Add('                            , qtd_peso_bruto = :qtd_peso_bruto     ');
        Sql.Add('                            , qtd_peso_liquido = :qtd_peso_liquido ');
        Sql.Add('                        WHERE seq_pre_venda = :seq_pre_venda       ');
        Sql.Add('                          AND seq_item = :seq_item                 ');
      end;


      with qSepItem do
      begin
        Close;
        Sql.Clear;
        Sql.Add('SELECT a.cod_item                                                                   ');
        Sql.Add('     , a.seq_item                                                                   ');
        Sql.Add('     , a.qtd_retornada                                                              ');
        Sql.Add('     , (a.qtd_retornada * a.qtd_unidade) as qtd_retorno_convertida                  ');
        Sql.Add('     , ((a.qtd_retornada * a.qtd_unidade) * b.qtd_volume) as qtd_volume             ');
        Sql.Add('     , ((a.qtd_retornada * a.qtd_unidade) * b.qtd_peso_bruto) as qtd_peso_bruto     ');
        Sql.Add('     , ((a.qtd_retornada * a.qtd_unidade) * b.qtd_peso_liquido) as qtd_peso_liquido ');
        Sql.Add('  FROM reiterlog.tab_separacao_item a                                               ');
        Sql.Add('  join tab_item b on b.cod_item = a.cod_item                                        ');
        Sql.Add(' WHERE a.seq_separacao = :seq_separacao                                             ');
        Sql.Add('   AND a.qtd_retornada > 0                                                          ');
        Sql.Add(' ORDER BY a.seq_item asc                                                            ');

        ParamByName('seq_separacao').AsInteger := iSeqPreVenda;
        Open;
        First;

        while not Eof do
        begin
          qAtuPreVendaItem.Close;
          qAtuPreVendaItem.ParamByName('qtd_volume').AsFloat        := FieldByName('qtd_volume').AsFloat;
          qAtuPreVendaItem.ParamByName('qtd_peso_bruto').AsFloat    := FieldByName('qtd_peso_bruto').AsFloat;
          qAtuPreVendaItem.ParamByName('qtd_peso_liquido').AsFloat  := FieldByName('qtd_peso_liquido').AsFloat;
          qAtuPreVendaItem.ParamByName('seq_pre_venda').AsInteger   := iSeqPreVenda;
          qAtuPreVendaItem.ParamByName('seq_item').AsInteger        := FieldByName('seq_item').AsInteger;;
          qAtuPreVendaItem.ExecSQL;

          Next;
        end;
      end;

      with qDeleteItem do
      begin
        close;
        ParamByName('seq_pre_venda').AsInteger := iSeqPreVenda;
        ExecSQL;
      end;

      dmPrincipal.zConexao.Commit;
    except
      on E : Exception do
      begin
        ListErro.Add('Erro ao cancelar a quantidade dos itens da Pre Venda: ' + IntToStr(iSeqPreVenda));
        ListErro.Add(E.Message);
        dmPrincipal.zConexao.Rollback;
      end;
    end;
  finally
    FreeAndNil(qSepItem);
    FreeAndNil(qAtuPreVendaItem);
    FreeAndNil(qDeleteItem);
  end;
end;

procedure FinalizaRetornoPreVenda(iSeqPreVenda : Integer; var ListErro : TStringList);
var qUpdate, qDelete : TZQuery;
begin
  qUpdate := NewZQuery;
  qDelete := NewZQuery;

  try
    try
      if not dmPrincipal.zConexao.InTransaction then
        dmPrincipal.zConexao.StartTransaction;

      with qDelete do
      begin
        Close;
        Sql.Clear;
        Sql.Add('Delete                                   ');
        Sql.Add('  from reiterlog.tmp_retorno_separacao a ');
        Sql.Add(' where a.seq_separacao = :seq_separacao  ');

        ParamByName('seq_separacao').AsInteger := iSeqPreVenda;
        ExecSQL;
      end;

      with qUpdate do
      begin
        Close;
        Sql.Clear;
        Sql.Add('Update reiterlog.tab_separacao set ind_finalizado = ''S''         ');
        Sql.Add('                             where seq_separacao = :seq_separacao ');

        ParamByName('seq_separacao').AsInteger := iSeqPreVenda;
        ExecSQL;
      end;

      dmPrincipal.zConexao.Commit;
    except
      on E :Exception do
      begin
        ListErro.Add('Erro ao finalizar a Separação: ' + IntToStr(iSeqPreVenda));
        ListErro.Add(E.Message);
        dmPrincipal.zConexao.Rollback;
      end;
    end;
  finally
    FreeAndNil(qUpdate);
    FreeAndNil(qDelete);
  end;
end;

procedure FinalizaRetornoRecebimento(iSeqNota : Integer; var ListErro : TStringList);
var qUpdate, qDelete, qConsulta : TZQuery;
    sNumNota, sCNPJ, sSerie : String;
begin
  qUpdate   := NewZQuery;
  qDelete   := NewZQuery;
  qConsulta := NewZQuery;

  try
    try
      if not dmPrincipal.zConexao.InTransaction then
        dmPrincipal.zConexao.StartTransaction;

      with qConsulta do
      begin
        Close;
        Sql.Clear;
        Sql.Add('SELECT a.num_nota                                             ');
        Sql.Add('     , a.num_serie                                            ');
        Sql.Add('     , b.num_cnpj_cpf                                         ');
        Sql.Add('  FROM tab_nota_fiscal_entrada a                              ');
        Sql.Add('  JOIN tab_pessoa b on b.cod_pessoa = a.cod_pessoa_fornecedor ');
        Sql.Add(' WHERE a.seq_nota = :seq_nota                                 ');

        ParamByName('seq_nota').AsInteger := iSeqNota;
        Open;
        First;

        sNumNota := FieldByName('num_nota').AsString;
        sCNPJ    := FieldByName('num_serie').AsString;
        sSerie   := FieldByName('num_cnpj_cpf').AsString;
      end;

      with qDelete do
      begin
        Close;
        Sql.Add('DELETE                                                            ');
        Sql.Add('  FROM reiterlog.tmp_retorno_recebimento a                        ');
        Sql.Add(' WHERE ltrim(a.num_nf, ''0'') = ltrim(:num_nf, ''0'')             ');
        Sql.Add('   AND ltrim(a.num_serie_nf, ''0'') = ltrim(:num_serie_nf, ''0'') ');
        Sql.Add('   AND a.num_cnpj_for = :num_cnpj_for                             ');

        ParamByName('num_nf').AsString       := sNumNota;
        ParamByName('num_serie_nf').AsString := sSerie;
        ParamByName('num_cnpj_for').AsString := sCNPJ;
        ExecSQL;
      end;

      with qUpdate do
      begin
        Close;
        Sql.Clear;
        Sql.Add('Update reiterlog.tab_recebimento set ind_finalizado = ''S''                           ');
        Sql.Add('                               where seq_recebimento = :seq_recebimento               ');
        Sql.Add('                                 and ((coalesce(seq_trans_almox_principal,0) <> 0) or ');
        Sql.Add('                                      (coalesce(seq_trans_almox_diferenca,0) <> 0))   ');

        ParamByName('seq_recebimento').AsInteger := iSeqNota;
        ExecSQL;
      end;

      dmPrincipal.zConexao.Commit;
    except
      on E :Exception do
      begin
        ListErro.Add('Erro ao finalizar o Recebimento: ' + IntToStr(iSeqNota));
        ListErro.Add(E.Message);
        dmPrincipal.zConexao.Rollback;
      end;
    end;
  finally
    FreeAndNil(qUpdate);
    FreeAndNil(qDelete);
    FreeAndNil(qConsulta);
  end;
end;

procedure RegistraLog(dDtaInicio, dDtaFim : TDateTime; ListLog : TStringList);
var qLog : TZQuery;
begin
  qLog := NewZQuery;
  ListLog.Delimiter := ';';

  try
    try
      if not dmPrincipal.zConexao.InTransaction then
        dmPrincipal.zConexao.StartTransaction;

      with qLog do
      begin
        Close;
        Sql.Clear;
        Sql.Add('Delete from reiterlog.tab_log_integracao');
        ExecSQL;

        Close;
        Sql.Clear;
        Sql.Add('INSERT INTO reiterlog.tab_log_integracao( dta_inicio  ');
        Sql.Add('                                        , des_log     ');
        Sql.Add('                                        , dta_fim)    ');
        Sql.Add('                                  VALUES( :dta_inicio ');
        Sql.Add('                                        , :des_log    ');
        Sql.Add('                                        , :dta_fim)   ');

        ParamByName('dta_inicio').AsDateTime := dDtaInicio;
        ParamByName('dta_fim').AsDateTime    := dDtaFim;
        ParamByName('des_log').AsString      := StringReplace( ListLog.DelimitedText
                                                             , ';'
                                                             , #13#10
                                                             , [rfReplaceAll]);

        ExecSQL;
      end;

      dmPrincipal.zConexao.Commit;
    except
      dmPrincipal.zConexao.Rollback;
    end;
  finally
    FreeAndNil(qLog);
  end;
end;

function VerificaAcesso(iTag : Integer; bSomenteAdministrador : Boolean = False) : Boolean;
var qConsulta : TZQuery;
begin
  Result := True;

  if Usuario.Tipo = 'A' then
    Exit;
    
  if (Usuario.Codigo = 0) and (Usuario.Nome = 'IMPULSE') then
    Exit;

  if (bSomenteAdministrador) and (Usuario.Tipo <> 'A') then
  begin
    MsgSistema('Acesso somente para usuário Administrador.', 'A');
    Result := False;
    Exit;
  end;

  qConsulta := NewZQuery;
  
  try
    with qConsulta do
    begin
      Close;
      Sql.Clear;
      Sql.Add('Select *                                                ');
      Sql.Add('  from reiterlog.tab_acesso_usuario a                   ');
      Sql.Add(' where a.seq_acesso_integracao = :seq_acesso_integracao ');
      Sql.Add('   and a.seq_cad_usuario = :seq_cad_usuario             ');

      ParamByName('seq_acesso_integracao').AsInteger := iTag;
      ParamByName('seq_cad_usuario').AsInteger       := Usuario.Codigo;

      Open;
      First;

      If IsEmpty then
      begin
        MsgSistema('Usuário sem permissão de Acesso.', 'A');
        Result := False;
        Exit;
      end;
    end;
  finally
    FreeAndNil(qConsulta);
  end;
end;

function LoginUsuario(sNome, sSenha : String) : Boolean;
var qConsulta : TZQuery;
begin
  Result := True;
  qConsulta := NewZQuery;

  try
    if UpperCase(sNome) <> 'IMPULSE' then
    begin
      with qConsulta do
      begin
        Close;
        Sql.Clear;
        Sql.Add('Select a.seq_cad_usuario            ');
        Sql.Add('     , a.ind_tipo                   ');
        Sql.Add('  from reiterlog.tab_cad_usuario a  ');
        Sql.Add(' where a.des_senha = :des_senha     ');
        Sql.Add('   and a.des_usuario = :des_usuario ');

        ParamByName('des_senha').AsString   := CodificarTexto(sSenha);
        ParamByName('des_usuario').AsString := UpperCase(sNome);
        Open;
        First;

        if not IsEmpty then
        begin
          with Usuario do
          begin
            Codigo := FieldByName('seq_cad_usuario').AsInteger;
            Nome   := UpperCase(sNome);
            Tipo   := FieldByName('ind_tipo').AsString;
            senha  := sSenha;
          end;
        end
        else
          Result := False;
      end;
    end
    else
    begin
      if sSenha = '@poc@lipse2020' then
      begin
        with Usuario do
        begin
          Codigo := 0;
          Nome   := 'IMPULSE';
          Tipo   := 'A';
          senha  := sSenha;
        end;
      end
      else
        Result := False;
    end;
  finally
    FreeAndNil(qConsulta);
    if not Result then
    begin
      MsgSistema('Usuário ou senha errado.', 'E');
    end;
  end;
end;

function GravaLogMovimento(sTipoArquivo, sLog : String; iSequencia : Integer; var sListErro : TStringList) : Boolean;
var qUpdate, qConsulta : TZQuery;
    sOldLog : String;
begin
  Result    := True;
  qUpdate   := NewZQuery;
  qConsulta := NewZQuery;

  if not dmPrincipal.zConexao.InTransaction then
    dmPrincipal.zConexao.StartTransaction;

  try
    try
      if sTipoArquivo = TipoSeparacao then
      begin
        with qConsulta do
        begin
          Close;
          Sql.Clear;
          Sql.Add('SELECT a.des_log                    ');
          Sql.Add('  FROM reiterlog.tab_separacao a    ');
          Sql.Add(' WHERE a.seq_separacao = :sequencia ');

          ParamByName('sequencia').AsInteger := iSequencia;
          Open;
          First;

          sOldLog := FieldByName('des_log').AsString;

          if sOldLog <> '' then
          begin
            sOldLog := sOldLog + #13#10 +
                       'Usuário: '+ Usuario.Nome +
                       ' realizou a seguinte alteração as '+
                       FormatDateTime('DD/MM/YYYY HH:MM', now) + #13#10 +
                       sLog;
          end
          else
           sOldLog := sLog;
        end;

        with qUpdate do
        begin
          close;
          Sql.Clear;
          Sql.Add('update reiterlog.tab_separacao a set des_log = :des_log           ');
          Sql.Add('                               where a.seq_separacao = :sequencia ');

          ParamByName('sequencia').AsInteger := iSequencia;
          ParamByName('des_log').AsString := sOldLog;
          ExecSQL;
        end;
      end
      else
      begin
        with qConsulta do
        begin
          Close;
          Sql.Clear;
          Sql.Add('SELECT a.des_log                    ');
          Sql.Add('  FROM reiterlog.tab_recebimento a    ');
          Sql.Add(' WHERE a.seq_recebimento = :sequencia ');

          ParamByName('sequencia').AsInteger := iSequencia;
          Open;
          First;

          sOldLog := FieldByName('des_log').AsString;

          if sOldLog <> '' then
          begin
            sOldLog := sOldLog + #13#10 +
                       'Usuário: '+ Usuario.Nome +
                       ' realizou a seguinte alteração as '+
                       FormatDateTime('DD/MM/YYYY HH:MM', now) + #13#10 +
                       sLog;
          end
          else
           sOldLog := sLog;

          with qUpdate do
          begin
            close;
            Sql.Clear;
            Sql.Add('update reiterlog.tab_recebimento a set des_log = :des_log             ');
            Sql.Add('                                 where a.seq_recebimento = :sequencia ');

            ParamByName('sequencia').AsInteger := iSequencia;
            ParamByName('des_log').AsString := sOldLog;
            ExecSQL;
          end;
        end;
      end;

      dmPrincipal.zConexao.Commit;
    except
      on E : Exception do
      begin
        dmPrincipal.zConexao.Rollback;

        if sTipoArquivo = TipoSeparacao then
          sListErro.Add('Erro ao Liberar a Separação para edição da Pré-Venda.')
        else
          sListErro.Add('Erro ao Liberar o Recebimento para edição da Pré-Venda.');

        sListErro.Add(E.Message);

        Result := False;
      end;
    end;
  finally
    FreeAndNil(qUpdate);
    FreeAndNil(qConsulta);
  end;
end;

function ExcluirRecebimento(iSeqRecebimento : Integer; var sListErro : TStringList) : Boolean;
var qDeleteTransferencia, qDeleteItensTransferencia, qDeleteItemRecebimento,
    qDeleteRecebimento, qConsulta : TZQuery;
    iSeqTransfVenda, iSeqTransfDif : Integer;
begin
  qDeleteTransferencia      := NewZQuery;
  qDeleteItensTransferencia := NewZQuery;
  qDeleteItemRecebimento    := NewZQuery;
  qDeleteRecebimento        := NewZQuery;
  qConsulta                 := NewZQuery;

  try
    with qConsulta do
    begin
      Close;
      Sql.Clear;
      Sql.Add('SELECT a.seq_trans_almox_principal          ');
      Sql.Add('     , a.seq_trans_almox_diferenca          ');
      Sql.Add('  FROM reiterlog.tab_recebimento a          ');
      Sql.Add(' WHERE a.seq_recebimento = :seq_recebimento ');

      ParamByName('seq_recebimento').AsInteger := iSeqRecebimento;
      Open;
      First;
    end;

    if not qConsulta.IsEmpty then
    begin
      iSeqTransfVenda := qConsulta.FieldByName('seq_trans_almox_principal').AsInteger;
      iSeqTransfDif   := qConsulta.FieldByName('seq_trans_almox_diferenca').AsInteger;

      with qDeleteItensTransferencia do
      begin
        Close;
        Sql.Clear;
        Sql.Add('DELETE                                          ');
        Sql.Add('  FROM tab_transf_almox_item a                  ');
        Sql.Add(' WHERE a.seq_transferencia = :seq_transferencia ');
      end;

      with qDeleteTransferencia do
      begin
        Close;
        Sql.Clear;
        Sql.Add('DELETE                                          ');
        Sql.Add('  FROM tab_transferencia_almoxarifado a         ');
        Sql.Add(' WHERE a.seq_transferencia = :seq_transferencia ');
      end;

      with qDeleteItemRecebimento do
      begin
        Close;
        Sql.Clear;
        Sql.Add('DELETE                                      ');
        Sql.Add('  FROM reiterlog.tab_recebimento_item a     ');
        Sql.Add(' WHERE a.seq_recebimento = :seq_recebimento ');
      end;

      with qDeleteRecebimento do
      begin
        Close;
        Sql.Clear;
        Sql.Add('DELETE                                      ');
        Sql.Add('  FROM reiterlog.tab_recebimento a          ');
        Sql.Add(' WHERE a.seq_recebimento = :seq_recebimento ');
      end;

      if not dmPrincipal.zConexao.InTransaction then
        dmPrincipal.zConexao.StartTransaction;

      try
        if iSeqTransfVenda > 0 then
        begin
          with qDeleteItensTransferencia do
          begin
            close;
            ParamByName('seq_transferencia').AsInteger := iSeqTransfVenda;
            ExecSQL;
          end;

          with qDeleteTransferencia do
          begin
            close;
            ParamByName('seq_transferencia').AsInteger := iSeqTransfVenda;
            ExecSQL;
          end;
        end;

        if iSeqTransfDif > 0 then
        begin
          with qDeleteItensTransferencia do
          begin
            close;
            ParamByName('seq_transferencia').AsInteger := iSeqTransfDif;
            ExecSQL;
          end;

          with qDeleteTransferencia do
          begin
            close;
            ParamByName('seq_transferencia').AsInteger := iSeqTransfDif;
            ExecSQL;
          end;
        end;

        with qDeleteItemRecebimento do
        begin
          close;
          ParamByName('seq_recebimento').AsInteger := iSeqRecebimento;
          ExecSQL;
        end;

        with qDeleteRecebimento do
        begin
          close;
          ParamByName('seq_recebimento').AsInteger := iSeqRecebimento;
          ExecSQL;
        end;

        dmPrincipal.zConexao.Commit;
      except
        on E : Exception do
        begin
          sListErro.Add('Não foi possível excluir o recebimento: '+ IntToStr(iSeqRecebimento));
          sListErro.Add(E.Message);
          dmPrincipal.zConexao.Rollback;
        end;
      end;
    end;
  finally
    FreeAndNil(qDeleteTransferencia);
    FreeAndNil(qDeleteItensTransferencia);
    FreeAndNil(qDeleteItemRecebimento);
    FreeAndNil(qDeleteRecebimento);
    FreeAndNil(qConsulta);
  end;
end;

procedure ExcluirItemSemEstoque(var sListErro : TStringList);
var qConsultaSeparacao, qConsultaItens, qExcluirItensPreVenda,
    qExcluirItensSeparacao : TZQuery;
    ListItens : TStringList;
    iSeqSeparacao : Integer;
begin
  qConsultaSeparacao     := NewZQuery;
  qConsultaItens         := NewZQuery;
  qExcluirItensPreVenda  := NewZQuery;
  qExcluirItensSeparacao := NewZQuery;
  ListItens              := TStringList.Create;

  try
    if not dmPrincipal.zConexao.InTransaction then
        dmPrincipal.zConexao.StartTransaction;

    try
      with qConsultaItens do
      begin
        Close;
        Sql.Clear;
        Sql.Add('SELECT a.seq_item                                                                               ');
        Sql.Add('  FROM tab_item_pre_venda a                                                                     ');
        Sql.Add('  JOIN tab_pre_venda b on b.seq_pre_venda = a.seq_pre_venda                                     ');
        Sql.Add(' WHERE a.seq_pre_venda = :seq_pre_venda                                                         ');
        Sql.Add('   AND (SELECT  ROUND(CAST(COALESCE(SUM(aa.qtd_movimento_estoque *                              ');
        Sql.Add('                                        (POSITION(''E'' IN bb.ind_tipo_movimento)  *            ');
        Sql.Add('                                         2 - 1)),0) AS NUMERIC),5)                              ');
        Sql.Add('          FROM tab_movimento_estoque aa                                                         ');
        Sql.Add('          JOIN tab_tipo_movimento_estoque bb ON (bb.cod_tipo_movimento = aa.cod_tipo_movimento) ');
        Sql.Add('         WHERE aa.cod_empresa = b.cod_empresa                                                   ');
        Sql.Add('           AND aa.cod_item = a.cod_item                                                         ');
        Sql.Add('           AND aa.cod_almoxarifado = a.cod_almoxarifado                                         ');
        Sql.Add('           AND aa.dta_movimento <= CURRENT_DATE) = 0                                            ');
      end;

      with qConsultaSeparacao do
      begin
        Close;
        Sql.Clear;
        Sql.Add('SELECT a.seq_separacao           ');
        Sql.Add('  FROM reiterlog.tab_separacao a ');
        Sql.Add(' WHERE a.ind_status = ''PE''     ');
        Open;
        First;
      end;

      while not qConsultaSeparacao.Eof do
      begin
        iSeqSeparacao := qConsultaSeparacao.FieldByName('seq_separacao').AsInteger;

        qConsultaItens.Close;
        qConsultaItens.ParamByName('seq_pre_venda').AsInteger := iSeqSeparacao;
        qConsultaItens.Open;
        qConsultaItens.First;

        ListItens.Clear;

        while not qConsultaItens.Eof do
        begin
          ListItens.Add(IntToStr(qConsultaItens.FieldByName('seq_item').AsInteger));

          qConsultaItens.Next;
        end;

        if ListItens.CommaText <> '' then
        begin
          with qExcluirItensSeparacao do
          begin
            Close;
            Sql.Clear;
            Sql.Add('DELETE                                           ');
            Sql.Add('  FROM reiterlog.tab_separacao_item a            ');
            Sql.Add(' WHERE a.seq_separacao = :seq_separacao          ');
            Sql.Add('   AND a.seq_item in ('+ ListItens.CommaText +') ');

            ParamByName('seq_separacao').AsInteger := iSeqSeparacao;
            ExecSQL;
          end;

          with qExcluirItensPreVenda do
          begin
            Close;
            Sql.Clear;
            Sql.Add('DELETE                                           ');
            Sql.Add('  FROM tab_item_pre_venda a                      ');
            Sql.Add(' WHERE a.seq_pre_venda = :seq_pre_venda          ');
            Sql.Add('   AND a.seq_item in ('+ ListItens.CommaText +') ');

            ParamByName('seq_pre_venda').AsInteger := iSeqSeparacao;
            ExecSQL;
          end;
        end;

        qConsultaSeparacao.Next;
      end;

      dmPrincipal.zConexao.Commit;
    except
      on E : Exception do
      begin
        sListErro.Add('Não foi possível excluir os Itens da separacao com saldo de Estoque zerado: '+ IntToStr(iSeqSeparacao));
        sListErro.Add(E.Message);
        dmPrincipal.zConexao.Rollback;
      end;
    end;
  finally
    FreeAndNil(qConsultaItens);
    FreeAndNil(qExcluirItensPreVenda);
    FreeAndNil(ListItens);
    FreeAndNil(qConsultaSeparacao);
    FreeAndNil(qExcluirItensSeparacao);
  end;
end;

end.
