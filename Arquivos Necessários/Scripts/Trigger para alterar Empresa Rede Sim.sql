ALTER TABLE tab_item_pre_venda add ind_reiterlog_alteracao char(1);

CREATE OR REPLACE FUNCTION reiterlog.fc_int_reiterlog_item_pre_venda_emp (
)
RETURNS trigger AS
$body$
DECLARE
  bItemReiterLog Boolean;
  sUFCliente char(2);
  sUFEmpresa char(2);
  iCodEmpresa Integer;
  bAlterarItem Boolean;
  iCodCliente INTEGER;
  item_qtd_volume Double Precision;
  item_qtd_peso_bruto Double Precision;
  item_qtd_peso_liquido Double Precision;
  bFilial Boolean;
BEGIN
  IF (upper(tg_op) = 'INSERT') THEN
    bItemReiterLog = EXISTS(Select 1
                              from tab_item a
                             where a.cod_item = NEW.cod_item
                               and a.cod_subgrupo_item in ( 10100412
                                                          , 10100413
                                                          , 10100414
                                                          , 10100376));
    if bItemReiterLog THEN    
      bAlterarItem = False;
           
      Select a.cod_empresa
           , a.cod_pessoa_cliente
        into iCodEmpresa, iCodCliente
        from tab_pre_venda a
       where a.seq_pre_venda = new.seq_pre_venda;
        
      IF iCodEmpresa = 34 THEN
        Update tab_pre_venda a set cod_empresa = 171
                             where a.seq_pre_venda = new.seq_pre_venda
                               and a.cod_empresa = iCodEmpresa;
        bAlterarItem = True; 
      elsif iCodEmpresa = 171 then
        bFilial = Exists(Select 1
                           from tab_empresa aa
                          where aa.num_cnpj = (Select bb.num_cnpj_cpf
                                                 from tab_pessoa bb
                                                where bb.cod_pessoa = iCodCliente));      
         
        --if New.cod_almoxarifado <> 17151 THEN
        if bFilial THEN
          bAlterarItem := True;
        end if;
      end if;
       
      if bAlterarItem THEN
        Select c.sgl_estado 
          from tab_pessoa a
          into sUFCliente
          join tab_cidade b on b.cod_cidade = a.cod_cidade
          join tab_estado c on c.cod_estado = b.cod_estado
         where a.cod_pessoa = iCodCliente;
          
        Select c.sgl_estado 
          from tab_empresa a
          into sUFEmpresa
          join tab_cidade b on b.cod_cidade = a.cod_cidade
          join tab_estado c on c.cod_estado = b.cod_estado
         where a.cod_empresa = 171;
          
        Select a.qtd_volume
             , a.qtd_peso_bruto
             , a.qtd_peso_liquido 
          from tab_item a
          into item_qtd_volume
             , item_qtd_peso_bruto
             , item_qtd_peso_liquido
        where a.cod_item = new.cod_item; 
         
        new.ind_reiterlog_alteracao = 'S';
        new.cod_almoxarifado = 17151;
        new.cod_unidade_venda = 9;
        new.qtd_item_convertido = new.qtd_item;
        new.qtd_entregue_convertida = new.qtd_item;	  
        new.qtd_volume = cast(item_qtd_volume * new.qtd_item as Double Precision);
        new.qtd_peso_bruto = cast(item_qtd_peso_bruto * new.qtd_item as Double Precision);
        new.qtd_peso_liquido = cast(item_qtd_peso_liquido * new.qtd_item as Double Precision);      
   	  
        new.val_custo_unitario = cast((SELECT case when (SELECT	CustoMedio                                                                                                                         
                                                           FROM	sp_obtem_custo_medio_item ( 171
                                                                                          , 17151
                                                                                          , new.cod_item
                                                                                          , CURRENT_DATE
                                                                                          , 1) CustoMedio) <> 0 
                                                   then (SELECT	CustoMedio                                                                                                                         
                                                           FROM	sp_obtem_custo_medio_item ( 171
                                                                                          , 17151
                                                                                          , new.cod_item
                                                                                          , CURRENT_DATE
                                                                                          , 1) CustoMedio)      
                                                   else case when coalesce(aa.val_custo_unitario,0) = 0                                                                                            
                                                             then coalesce(aa.val_custo_medio,0)                                                                                                   
                                                             else aa.val_custo_unitario                                                                                                            
                                                         end                                                                                                                                       
                                               end                                                                                                                                                 
                                         FROM tab_item_empresa aa                                                                                                                                  
                                        WHERE aa.cod_item = new.cod_item                                                                                                                             
                                          AND aa.cod_empresa = 171) * (Select aa.num_fator_conversao
                                                                         from tab_unidade aa
                                                                        where aa.cod_unidade = new.cod_unidade_venda) as numeric(18,3));
                                                                           
        new.val_custo_medio = cast((SELECT case when (SELECT	CustoMedio                                                                                                                         
                                                        FROM	sp_obtem_custo_medio_item ( 171
                                                                                       , 17151
                                                                                       , new.cod_item
                                                                                       , CURRENT_DATE
                                                                                       , 1) CustoMedio) <> 0 
                                                then (SELECT	CustoMedio                                                                                                                         
                                                        FROM	sp_obtem_custo_medio_item ( 171
                                                                                       , 17151
                                                                                       , new.cod_item
                                                                                       , CURRENT_DATE
                                                                                       , 1) CustoMedio)      
                                                else case when coalesce(aa.val_custo_unitario,0) = 0                                                                                            
                                                          then coalesce(aa.val_custo_medio,0)                                                                                                   
                                                          else aa.val_custo_unitario                                                                                                            
                                                      end                                                                                                                                       
                                            end                                                                                                                                                 
                                      FROM tab_item_empresa aa                                                                                                                                  
                                     WHERE aa.cod_item = new.cod_item                                                                                                                             
                                       AND aa.cod_empresa = 171) * (Select aa.num_fator_conversao
                                                                      from tab_unidade aa
                                                                     where aa.cod_unidade = new.cod_unidade_venda) as numeric(18,3));
          
        if sUFCliente <> sUFEmpresa THEN
          new.cod_natureza_operacao = (Select aa.cod_nop_transf_saida_fe
                                         from tab_item_empresa aa
                                        where aa.cod_empresa = 171
                                          and aa.cod_item = new.cod_item);
        else
          new.cod_natureza_operacao = (Select aa.cod_nop_transf_saida_de
                                         from tab_item_empresa aa
                                        where aa.cod_empresa = 171
                                          and aa.cod_item = new.cod_item);
        end if;   
      end if;
    end if;
  ELSIF (upper(tg_op) = 'UPDATE') then 
    if ((old.ind_reiterlog_alteracao = 'S') and 
        ((new.cod_unidade_venda <> OLD.cod_unidade_venda) or 
         (new.qtd_item_convertido <> OLD.qtd_item_convertido) or
         (new.qtd_entregue_convertida <> OLD.qtd_entregue_convertida)))  then
      NEW.ind_reiterlog_alteracao = 'U';
    end if;
  END IF;  
  
  Return New;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER;

DROP TRIGGER tg_int_reiterlog_item_pre_venda_a ON public.tab_item_pre_venda;

CREATE TRIGGER tg_int_reiterlog_item_pre_venda_a
  BEFORE INSERT OR UPDATE
  ON public.tab_item_pre_venda FOR EACH ROW 
  EXECUTE PROCEDURE reiterlog.fc_int_reiterlog_item_pre_venda_emp();