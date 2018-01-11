--
-- Query contributed by 刘浩 (LIU Hao)
--
select 'table without PK: ' ||
       table_name || ';'
from information_schema.tables
where table_name not in 
(select table_name from information_schema.TABLE_CONSTRAINTS
where constraint_type = 'PRIMARY KEY') 

