CREATE SCHEMA reiterlog;

CREATE TABLE reiterlog.tab_recebimento( Seq_recebimento integer not NULL
                                      , dta_recebimento date not null
                                      , dta_atualizacao timestamp not null
                                      , ind_status char(2) not null
                                      , ind_tipo char(1) not null
                                      , ind_finalizado char(1) not null
                                      , CONSTRAINT pky_recebimento 
                                          PRIMARY key(seq_recebimento));

COMMENT ON COLUMN reiterlog.tab_recebimento.ind_tipo
  IS 'E - Entrada de Nota
      D - Devolucao';

COMMENT ON COLUMN reiterlog.tab_recebimento.ind_status
  IS 'AE - Aguardando Envio
      PE - Processando Envio
      AR - Aguardando Retorno
	  PR - Processando Retorno
	  F - Finalizado';

COMMENT ON COLUMN reiterlog.tab_recebimento.ind_finalizado
  IS 'S - SIM
      N - NAO';
                                          
CREATE TABLE reiterlog.tab_recebimento_item( Seq_recebimento INTEGER not NULL
                                           , seq_item integer not null
                                           , cod_item integer not null
                                           , qtd_convertida double precision not null
                                           , qtd_item double precision not null
                                           , cod_unidade integer not null
                                           , qtd_unidade double precision not null
                                           , qtd_retornada double precision Default 0
										   , qtd_diferenca double precision Default 0
                                           , CONSTRAINT pky_recebimento_item 
                                               Primary Key(seq_recebimento, seq_item)
                                           , CONSTRAINT fky_recebimento_item
                                               FOREIGN Key(seq_recebimento)
                                               REFERENCES reiterlog.tab_recebimento(seq_recebimento));

create table reiterlog.tab_separacao( seq_separacao integer not NULL
                                    , dta_separacao date not null
                                    , dta_atualizacao timestamp not null
                                    , ind_status char(2) not null
                                    , ind_tipo char(1) not null
                                    , ind_finalizado char(1) not null
                                    , CONSTRAINT pky_separacao
                                        PRIMARY key(seq_separacao));
										
COMMENT ON COLUMN reiterlog.tab_separacao.ind_tipo
  IS 'S - Saida de Mercadoria
      D - Devolucao Para Fornecedor';

COMMENT ON COLUMN reiterlog.tab_separacao.ind_status
  IS 'AE - Aguardando Envio
      PE - Processando Envio
      AR - Aguardando Retorno
	  PR - Processando Retorno
	  F - Finalizado';

COMMENT ON COLUMN reiterlog.tab_separacao.ind_finalizado
  IS 'S - SIM
      N - NAO';										
                                          
create table reiterlog.tab_separacao_item( seq_separacao INTEGER not NULL
                                         , seq_item integer not null
                                         , cod_item integer not null
                                         , qtd_convertida double precision not null
                                         , qtd_item double precision not null
                                         , cod_unidade integer not null
                                         , qtd_unidade double precision not null
                                         , qtd_retornada double precision Default 0
										 , qtd_diferenca double precision Default 0
                                         , CONSTRAINT pky_separacao_item 
                                             Primary Key(seq_separacao, seq_item)
                                         , CONSTRAINT fky_separacao_item
                                             FOREIGN Key(seq_separacao)
                                             REFERENCES reiterlog.tab_separacao(seq_separacao));
                                      
CREATE SEQUENCE reiterlog.gen_rel_almoxarifado_intermediario;

CREATE TABLE reiterlog.tab_rel_almoxarifado_intermediario( seq_rel_almoxarifado_intermediario INTEGER Default NEXTVAL('reiterlog.gen_rel_almoxarifado_intermediario')
                                                        , cod_empresa integer not null
                                                        , cod_almoxarifado_intermediario integer not null
                                                        , cod_almoxarifado_final integer not null
														, cod_almoxarifado_diferenca integer not null
                                                        , ind_tipo char(1) not null Default 'A'
                                                        , CONSTRAINT pky_rel_almoxarifado_intermediario
                                                            Primary Key(seq_rel_almoxarifado_intermediario));

COMMENT ON COLUMN reiterlog.tab_rel_almoxarifado_intermediario.ind_tipo
  IS 'E - Entrada
      D - Devolucao
      A - Ambos';

CREATE TABLE reiterlog.tab_parametro_integracao( seq_parametro INTEGER NOT NULL 
                                               , des_parametro varchar(500) not null
                                               , val_parametro VARCHAR(500) not null
											   , CONSTRAINT pky_parametro_integracao
                                                   PRIMARY KEY(seq_parametro));	

INSERT INTO reiterlog.tab_parametro_integracao( seq_parametro
                                              , des_parametro
                                              , val_parametro)
                                        VALUES(  1
                                              , 'Empresas que realizam a integração'
                                              , '');
											  
INSERT INTO reiterlog.tab_parametro_integracao( seq_parametro
                                              , des_parametro
                                              , val_parametro)
                                        VALUES(  2
                                              , 'Data do Ultimo Envio da Separacao'
                                              , to_char(CURRENT_DATE - 1,'YYYY/MM/DD HH:MI'));											  

CREATE TABLE reiterlog.tmp_retorno_separacao( seq_separacao integer not null
                                            , cod_item INTEGER not null
                                            , qtd_item double precision not null
                                            , dta_arquivo TIMESTAMP not null);
											
CREATE TABLE reiterlog.tmp_retorno_recebimento( num_cnpj_for varchar(16) not NULL
                                              , num_nf varchar(9) not null  
                                              , num_serie_nf varchar(3)
                                              , cod_item integer not null
                                              , qtd_item double PRECISION not null
                                              , dta_arquivo TIMESTAMP not null);
											  
CREATE OR REPLACE FUNCTION reiterlog.sp_insere_separacao( iSeqPreVenda INTEGER
                                                        , sTipo char(1))
RETURNS void AS
$body$
BEGIN
  IF NOT EXISTS(SELECT 1
                  FROM reiterlog.tab_separacao a
                 WHERE a.seq_separacao = iSeqPreVenda) THEN
  
    INSERT INTO reiterlog.tab_separacao( seq_separacao
                                       , dta_separacao
                                       , dta_atualizacao
                                       , ind_status
                                       , ind_tipo
                                       , ind_finalizado)
                                 VALUES( iSeqPreVenda
                                       , CURRENT_DATE
                                       , CURRENT_TIMESTAMP
                                       , 'AE'
                                       , sTipo
                                       , 'N');
  END IF;  
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER;

ALTER TABLE tab_item_pre_venda ADD ind_wms_reiterlog char(1);

CREATE OR REPLACE FUNCTION reiterlog.fc_int_reiterlog_pre_venda (
)
RETURNS trigger AS
$body$
DECLARE
  bUtilizaIntReiterLog Boolean;
  bExisteSeparacao Boolean;
  bExisteTabela Boolean;  
  sEmpresas varchar(500);
  iSeqPreVenda Integer;
  iCodEmpresa Integer;
  sTipo Char(1);
  sOLdStatus char(2);
BEGIN
  bExisteTabela := Exists(Select 1
                            from pg_tables a  
                           where a.schemaname = 'reiterlog'
                             and a.tablename = 'tab_parametro_integracao');
  
  if bExisteTabela then
    sEmpresas = Coalesce((Select a.val_parametro
                            from reiterlog.tab_parametro_integracao a
                           where a.seq_parametro = 1),'');
    if (sEmpresas <> '') then
      IF (upper(tg_op) = 'DELETE') THEN
        iCodEmpresa = OLD.cod_empresa;
        iSeqPreVenda = OLD.seq_pre_venda;
        sOLdStatus   = OLD.ind_status;
      else
        iCodEmpresa = New.cod_empresa;
        iSeqPreVenda = New.seq_pre_venda;
        
        IF (upper(tg_op) = 'UPDATE') THEN
          sOLdStatus   = OLD.ind_status;
        else 
          sOLdStatus   = '';
        end if;
      end if;
      
      bUtilizaIntReiterLog = EXISTS(Select 1 
                                      from tab_empresa a
                                     where a.cod_empresa = iCodEmpresa 
                                       and a.cod_empresa = Any(CAST(regexp_split_to_array(sEmpresas, ',') as INTEGER[])));
      IF bUtilizaIntReiterLog then
        Select case when coalesce(b.ind_devolucao, 'N') = 'S'
                    then 'D'
                    Else 'S'
                end as Tipo
          into sTipo 
          from tab_pre_venda a
          join tab_natureza_operacao b on b.cod_natureza_operacao = a.cod_natureza_operacao    
         where a.seq_pre_venda = iSeqPreVenda;
        
        bExisteSeparacao = EXISTS(Select 1 
                                    from reiterlog.tab_separacao a
                                   where a.seq_separacao = iSeqPreVenda
                                     and a.ind_status <> 'LE'); 
        
        IF bExisteSeparacao THEN
          IF (upper(tg_op) = 'DELETE') THEN
            RAISE EXCEPTION 'Pre venda vinculada a integração do Reiter Log não será possível deletar'; 
          ELSIF NOT EXISTS(Select 1
                            from reiterlog.tab_separacao a
                           where a.seq_separacao = iSeqPreVenda
                             and a.ind_status in ('PR', 'LE')) THEN
                                                          
            IF (sOLdStatus <> NEW.ind_status) AND
               (NEW.ind_status IN ('FP', 'FA', 'CC', 'FF')) THEN
              
              IF NOT EXISTS(Select 1
                            from reiterlog.tab_separacao a
                           where a.seq_separacao = iSeqPreVenda
                             and a.ind_finalizado = 'S') THEN
                 RAISE EXCEPTION 'Pre Venda Aguardando finalizar a integracao com o WMS da Reiter Log';            
              END IF;
            ELSIF (sOLdStatus <> NEW.ind_status) AND
                  (sOLdStatus = 'AP') THEN
              RAISE EXCEPTION 'Pre Venda Aguardando finalizar a integracao com o WMS da Reiter Log';
            END IF;
          END IF;
          
          IF EXISTS(Select 1
                      from reiterlog.tab_separacao a
                     where a.seq_separacao = iSeqPreVenda
                       and a.ind_status = 'LE') THEN
            IF (sOLdStatus <> NEW.ind_status) AND
               (NEW.ind_status IN ('FA', 'CC', 'FF')) THEN
               
              Update reiterlog.tab_separacao a set ind_status = 'F'
                                             where a.ind_status = 'LE'
                                               and a.seq_separacao = iSeqPreVenda;
            END IF;
          END IF;   
        ELSIF (upper(tg_op) <> 'DELETE') THEN
          IF (NEW.ind_status = 'AP') AND
             (not EXISTS(Select 1 
                           from reiterlog.tab_separacao a
                          where a.seq_separacao = iSeqPreVenda
                            and a.ind_status = 'LE')) THEN
			if Exists(Select 1
			            from tab_item_pre_venda a
					   where a.seq_pre_venda = iSeqPreVenda) then				
              EXECUTE reiterlog.sp_insere_separacao(iSeqPreVenda, sTipo);
              UPDATE tab_item_pre_venda set ind_wms_reiterlog = 'S'
                                    where seq_pre_venda = iSeqPreVenda;
			end if;
                                    
          ELSIF (sOLdStatus <> NEW.ind_status) AND
                (NEW.ind_status IN ('FA', 'CC', 'FF')) AND
                (EXISTS(Select 1
                          from reiterlog.tab_separacao a
                         where a.seq_separacao = iSeqPreVenda
                           and a.ind_status = 'LE')) THEN 
                           
            Update reiterlog.tab_separacao a set ind_status = 'F'
                                           where a.ind_status = 'LE'
                                             and a.seq_separacao = iSeqPreVenda;               
                           
          END IF;
        END IF;
      END IF;                                
    END IF;                                             
  END IF;
  
  IF (upper(tg_op) = 'DELETE') THEN
    return OLD;
  ELSE
    return NEW;
  END IF;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;


CREATE TRIGGER tg_int_reiterlog_pre_venda
  AFTER INSERT OR UPDATE OR DELETE 
  ON public.tab_pre_venda FOR EACH ROW 
  EXECUTE PROCEDURE reiterlog.fc_int_reiterlog_pre_venda();

CREATE OR REPLACE FUNCTION reiterlog.sp_insere_item_separacao( iSeqPreVenda INTEGER
                                                             , iSeqItem Integer
                                                             , iCodItem Integer
                                                             , qtdConvertida Double Precision
                                                             , qtdItem Double Precision
                                                             , icodUnidade INTEGER)
RETURNS void AS
$body$
DECLARE
  qtdUnidade Double Precision;
BEGIN
  qtdunidade = (qtdConvertida / qtdItem);
  IF NOT EXISTS(SELECT 1
                  FROM reiterlog.tab_separacao_item a
                 WHERE a.seq_separacao = iSeqPreVenda
                   and a.seq_item = iSeqItem) THEN
    INSERT INTO reiterlog.tab_separacao_item( seq_separacao
                                            , seq_item
                                            , cod_item
                                            , qtd_convertida
                                            , qtd_item
                                            , cod_unidade
                                            , qtd_unidade
                                            , qtd_retornada
                                            , qtd_diferenca)
                                      VALUES( iSeqPreVenda
                                            , iSeqItem
                                            , iCodItem
                                            , qtdConvertida
                                            , qtdItem
                                            , icodUnidade
                                            , qtdUnidade
                                            , 0
                                            , 0);                      
  END IF;  
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER;

CREATE OR REPLACE FUNCTION reiterlog.fc_int_reiterlog_item_pre_venda (
)
RETURNS trigger AS
$body$
DECLARE
  bUtilizaIntReiterLog Boolean;
  bExisteSeparacao Boolean;
  bExisteTabela Boolean;
  sEmpresas varchar(500);
  iCodEmpresa Integer;
  iSeqPreVenda Integer;
  iCodItem Integer;
  qtdItem Double PRECISION;
  sStatus char(2);    
BEGIN
  bExisteTabela := Exists(Select 1
                            from pg_tables a  
                           where a.schemaname = 'reiterlog'
                             and a.tablename = 'tab_parametro_integracao');
  IF bExisteTabela THEN
    sEmpresas = Coalesce((Select a.val_parametro
                            from reiterlog.tab_parametro_integracao a
                           where a.seq_parametro = 1),'');
                           
    IF sEmpresas <> '' THEN
      IF (upper(tg_op) = 'DELETE') THEN
        iSeqPreVenda = OLD.seq_pre_venda;
        iCodItem = OLD.cod_item;
		qtdItem = OLD.qtd_item;
      else
        iSeqPreVenda = New.seq_pre_venda;
        iCodItem = NEW.cod_item;
		qtdItem  = NEW.qtd_item;
      end if;
      
      Select a.cod_empresa
        INTO iCodEmpresa
        from tab_pre_venda a
       where a.seq_pre_venda = iSeqPreVenda;        
      
      bUtilizaIntReiterLog = EXISTS(Select 1 
                                      from tab_empresa a
                                     where a.cod_empresa = iCodEmpresa 
                                       and a.cod_empresa = Any(CAST(regexp_split_to_array(sEmpresas, ',') as INTEGER[])));
      
      IF bUtilizaIntReiterLog THEN
        Select a.ind_status
          INTO sStatus
          from tab_pre_venda a
         where a.seq_pre_venda = iSeqPreVenda;
        
        bExisteSeparacao = EXISTS(Select 1 
                                    from reiterlog.tab_separacao_item a
                                   where a.seq_separacao = iSeqPreVenda
                                     AND a.cod_item = iCodItem
                                     and a.qtd_item = qtdItem);
        IF bExisteSeparacao THEN
          IF (upper(tg_op) = 'DELETE') THEN
            IF (OLD.QTD_ENTREGUE_CONVERTIDA > 0) THEN
              IF NOT EXISTS(Select 1
                              from reiterlog.tab_separacao a
                             where a.seq_separacao = iSeqPreVenda
                               and a.ind_status in ('LE')) THEN
                 RAISE EXCEPTION 'DELETE ITEM Pre venda vinculada a integração do Reiter Log não será possível excluir o item';
              end IF; 
            END IF;
                        
          ELSIF ((NEW.qtd_item <> OLD.qtd_item) OR
                 (NEW.QTD_ITEM_CONVERTIDO <> OLD.QTD_ITEM_CONVERTIDO) OR
                 (NEW.COD_UNIDADE_VENDA <> OLD.COD_UNIDADE_VENDA) OR
                 (NEW.QTD_ITEM_CANCELADO <> OLD.QTD_ITEM_CANCELADO) OR
                 (NEW.QTD_ENTREGUE_CONVERTIDA <> OLD.QTD_ENTREGUE_CONVERTIDA) OR
                 (NEW.QTD_ENTREGUE <> OLD.QTD_ENTREGUE) OR
                 (NEW.QTD_ATENDIDA <> OLD.QTD_ATENDIDA)) THEN
            IF NOT EXISTS(Select 1
                            from reiterlog.tab_separacao a
                           where a.seq_separacao = iSeqPreVenda
                             and a.ind_status in ('PR', 'LE')) THEN
               RAISE EXCEPTION 'A undiade e a quantidade do item nao pode ser alterada devia a integração do wms da Reiter Log.';              
            END IF;
          END IF;          
        ELSIF (upper(tg_op) = 'UPDATE') AND
              (Coalesce(NEW.ind_wms_reiterlog, 'N') = 'S') THEN
          EXECUTE reiterlog.sp_insere_item_separacao( iSeqPreVenda
                                                    , iSeqItem
                                                    , NEW.cod_item
                                                    , NEW.qtd_item_convertido
                                                    , NEW.qtd_item
                                                    , NEW.cod_unidade_venda);
        END IF;
      END IF;
    END IF;                       
  END IF;
  
  IF (upper(tg_op) = 'DELETE') THEN
    return OLD;
  ELSE
    return NEW;
  END IF;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER;

CREATE TRIGGER tg_int_reiterlog_item_pre_venda
  AFTER INSERT OR UPDATE OR DELETE 
  ON public.tab_item_pre_venda FOR EACH ROW 
  EXECUTE PROCEDURE reiterlog.fc_int_reiterlog_item_pre_venda(); 


CREATE OR REPLACE FUNCTION reiterlog.fc_int_reiterlog_item_nfe (
)
RETURNS trigger AS
$body$
DECLARE
  bUtilizaIntReiterLog Boolean;
  bExisteTabela Boolean;
  bExisteRecebimento Boolean;
  sEmpresas Varchar(500);
  iCodEmpresa Integer;      
  iSeqNota Integer;
BEGIN  
  bExisteTabela = Exists(Select 1
                           from pg_tables a  
                          where a.schemaname = 'reiterlog'
                            and a.tablename = 'tab_parametro_integracao');
                             
  IF bExisteTabela THEN
    sEmpresas = Coalesce((Select a.val_parametro
                            from reiterlog.tab_parametro_integracao a
                           where a.seq_parametro = 1),'');
    IF sEmpresas <> '' THEN
      IF (upper(tg_op) = 'DELETE') THEN        
        iSeqNota = OLD.seq_nota;
      ELSE
        iSeqNota = New.Seq_nota;
      END IF;
      
      Select a.cod_empresa
        INTO iCodEmpresa
        from tab_nota_fiscal_entrada a
       where a.seq_nota = iSeqNota;
      
      bUtilizaIntReiterLog = EXISTS(Select 1 
                                      from tab_empresa a
                                     where a.cod_empresa = iCodEmpresa 
                                       and a.cod_empresa = Any(CAST(regexp_split_to_array(sEmpresas, ',') as INTEGER[]))); 
      
      IF bUtilizaIntReiterLog THEN
       bExisteRecebimento = EXISTS(Select 1 
                                     from reiterlog.tab_recebimento a
                                    where a.seq_recebimento = iSeqNota);
       IF bExisteRecebimento THEN
         IF (upper(tg_op) = 'UPDATE') THEN
           IF ((OLD.Cod_almoxarifado <> NEW.cod_almoxarifado) AND
               (OLD.qtd_item <> New.qtd_item) AND
               (OLD.qtd_item_convertido <> New.qtd_item_convertido) AND
               (OLD.cod_unidade_compra <> NEW.cod_unidade_compra))  THEN
             RAISE EXCEPTION 'Nao e permitido alterar Almoxarifado, Unidade ou a quantidade do item devido a integracao do wms da Reiter Log.';
           END IF;
         END IF;
       ELSIF (upper(tg_op) = 'INSERT') THEN
         IF NOT EXISTS(Select 1
                         from reiterlog.tab_rel_almoxarifado_intermediario a
                        where a.cod_almoxarifado_intermediario = NEW.Cod_almoxarifado) THEN
           RAISE EXCEPTION 'E necessario selecionar um almoxarifado Intermediario devido a integracao do wms da Reiter Log.';             
         END IF;
       END IF;                                    
      END IF;                                 
    END IF;                        
  END IF;
  
  IF (upper(tg_op) = 'DELETE') THEN
    return OLD;
  ELSE
    return NEW;
  END IF;  
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER;

CREATE TRIGGER tg_int_reiterlog_item_nfe
  AFTER INSERT OR UPDATE OR DELETE 
  ON public.tab_item_nfe FOR EACH ROW 
  EXECUTE PROCEDURE reiterlog.fc_int_reiterlog_item_nfe();

CREATE TABLE reiterlog.tab_log_integracao( dta_inicio TIMESTAMP not null
                                         , des_log text not NULL
                                         , dta_fim TIMESTAMP not null);

CREATE SEQUENCE reiterlog.gen_cad_usuario;

CREATE TABLE reiterlog.tab_cad_usuario( seq_cad_usuario integer Default NEXTVAL('reiterlog.gen_cad_usuario')
                                , des_usuario varchar(60) not null
                                , des_senha varchar(32) not null
                                , ind_tipo char(1)
                                , CONSTRAINT pky_cad_usuario
                                     Primary Key(seq_cad_usuario));
									 
COMMENT ON COLUMN reiterlog.tab_cad_usuario.ind_tipo
  IS 'A - Administrador
      U - Usuario';									 
                                     
CREATE SEQUENCE reiterlog.gen_acesso_integracao;

CREATE TABLE reiterlog.tab_acesso_integracao( seq_acesso_integracao integer Default NEXTVAL('reiterlog.gen_acesso_integracao')
                                      , des_acesso_integracao varchar(100) not null
                                      , CONSTRAINT pky_acesso_integracao
                                           Primary Key(seq_acesso_integracao));

CREATE TABLE reiterlog.tab_acesso_usuario( seq_cad_usuario integer not null
                                   , seq_acesso_integracao integer not null
                                   , CONSTRAINT pky_acesso_usuario
                                        Primary Key(seq_cad_usuario, seq_acesso_integracao)
                                   , CONSTRAINT fky_acesso_usuario
                                        FOREIGN Key (seq_cad_usuario)
                                        REFERENCES reiterlog.tab_cad_usuario(seq_cad_usuario)
                                   , CONSTRAINT fky_acesso_usuario_a
                                        FOREIGN Key (seq_acesso_integracao)
                                        REFERENCES reiterlog.tab_acesso_integracao(seq_acesso_integracao));                                           



INSERT INTO reiterlog.tab_acesso_integracao (seq_acesso_integracao, des_acesso_integracao)
                                     VALUES (1, 'Configuracao - Base de Dados')
                                          , (2, 'Configuracao - E-mail')
                                          , (3, 'Configuracao - Ftp')
                                          , (4, 'Configuracao - Parametros')
                                          , (5, 'Configuracao - Almoxarifado Intermediario')
                                          , (6, 'Configuracao - Processo de Integração')
                                          , (7, 'Movimentacao - Recebimento - Enviar NF de Entrada')
                                          , (8, 'Movimentacao - Recebimento - Cancelar o envio da NF de Entrada')
                                          , (9, 'Movimentacao - Recebimento - Monitoramento')
                                          , (10, 'Movimentacao - Separacao - Cancelar Envio da Pré Vendas')
                                          , (11, 'Movimentacao - Separacao - Monitoramento')
                                          , (12, 'Movimentacao - Log do Processo');	

ALTER TABLE reiterlog.tab_recebimento ADD seq_trans_almox_principal integer;

ALTER TABLE reiterlog.tab_recebimento ADD seq_trans_almox_diferenca integer;

ALTER TABLE reiterlog.tab_recebimento add num_nota varchar(10);

ALTER TABLE reiterlog.tab_recebimento add num_serie varchar(3);

ALTER TABLE reiterlog.tab_recebimento add num_CNPJ varchar(18);

UPDATE reiterlog.tab_recebimento a set num_nota = (Select aa.num_nota
                                                     from tab_nota_fiscal_entrada aa
                                                    where aa.seq_nota = a.seq_recebimento)
                                     , num_serie = (Select aa.num_serie
                                                      from tab_nota_fiscal_entrada aa
                                                     where aa.seq_nota = a.seq_recebimento)
                                     , num_CNPJ = (Select bb.num_cnpj_cpf
                                                     from tab_nota_fiscal_entrada aa
                                                     join tab_pessoa bb on bb.cod_pessoa = aa.cod_pessoa_fornecedor
                                                    where aa.seq_nota = a.seq_recebimento);

ALTER TABLE reiterlog.tab_separacao add des_log text default '';										  

COMMENT ON COLUMN reiterlog.tab_separacao.ind_status
  IS 'AE - Aguardando Envio
      PE - Processando Envio
      AR - Aguardando Retorno
	  PR - Processando Retorno
	   F - Finalizado
      LE - Liberar Edicao Pre Venda';
	  
ALTER TABLE reiterlog.tab_recebimento add des_log text default '';	  