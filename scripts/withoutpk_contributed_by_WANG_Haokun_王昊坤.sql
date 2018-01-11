--
-- Query contributed by 王昊坤 (WANG Haokun)
--
select n.nspname as "User",c.relname as "Table Name",c.relhaspkey as "Has PK" 
from pg_catalog.pg_class c join pg_namespace n on (c.relnamespace = n.oid
											and n.nspname not in ('information_schema', 'pg_catalog')
											and c.relkind='r')
where c.relhaspkey = 'f'
order by n.nspname, c.relname;