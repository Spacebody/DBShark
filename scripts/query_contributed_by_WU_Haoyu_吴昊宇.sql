--
-- Query contributed by 吴昊宇 (WU Haoyu)
--
-- Redundant indexes
select n.nspname schemaname, relname tablename 
from(
	select indrelid, indkey, 
	count(*) counter 
	from pg_catalog.pg_index 
	group by indrelid, indkey) C
join pg_catalog.pg_class clog 
	on C.indrelid = clog.oid
join pg_catalog.pg_namespace n 
	on clog.relnamespace = n.oid
where counter > 1;