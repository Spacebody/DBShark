--
-- Query contributed by 张笑通 (ZHANG Xiaotong)
--
--list all tables withour PK for postgreSQL
--11510394 ��Цͨ
select n.nspname as "Schema Name",c.relname as "Table Name",c.relhaspkey as "Has PK" 
from
 pg_catalog.pg_class c
 join pg_namespace n
	on (
	 c.relnamespace = n.oid
 	and n.nspname not in ('information_schema', 'pg_catalog')
 	and c.relkind='r'
	)
where c.relhaspkey = 'f'
order by c.relhaspkey, c.relname
;