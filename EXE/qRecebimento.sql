SELECT a.seq_recebimento                                                      
     , b.num_nota                                                             
     , b.num_serie                                                            
     , b.dta_emissao                                                          
     , b.dta_entrada                                                          
     , c.nom_pessoa                                                           
     , c.num_cnpj_cpf                                                         
     , cast(case a.ind_status when 'AE' THEN 'Aguardando Envio'           
                              when 'PE' THEN 'Processando Envio'          
                              when 'AR' THEN 'Aguardando Retorno'         
                              when 'PR' THEN 'Processando Retorno'        
                              when 'F'  THEN 'Finalizado'                 
             end as VARCHAR(60)) as status                                    
     , a.ind_status                                                           
  FROM reiterlog.tab_recebimento a                                            
  JOIN tab_nota_fiscal_entrada b on b.seq_nota = a.seq_recebimento            
  JOIN tab_pessoa c on c.cod_pessoa = b.cod_pessoa_fornecedor                 
 WHERE a.dta_recebimento BETWEEN :DataIni and :DataFim                        
   --AND ((a.ind_status = :ind_status) or (:ind_status = 'T'))                
   AND ((b.cod_pessoa_fornecedor = :cod_fornecedor) or (:cod_fornecedor = 0)) 
   AND ((b.cod_empresa = :cod_empresa) or (:cod_empresa = 0))                 
