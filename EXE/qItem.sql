SELECT a.seq_item                         
     , a.cod_item                         
     , a.qtd_item                         
  FROM reiterlog.tab_seq_separacao_item a 
 WHERE a.seq_separacao = :seq_separacao   
   AND a.cod_item = :cod_item             
 Order By a.seq_item asc                  
