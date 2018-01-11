--
-- Query contributed by 谢宜 (XIE Yi)
--
-- Percentage of single-column indexes
select cast((select count(*) from pg_catalog.pg_index where indnatts = 1) as float) /
cast((select count(*) from pg_catalog.pg_index) as float) * 100 percentage;

-- Redundant indexes
select n.nspname schemaname, relname tablename from
(select indrelid, indkey, count(*) cnt from pg_catalog.pg_index group by indrelid, indkey) ci
join pg_catalog.pg_class cl on ci.indrelid = cl.oid
join pg_catalog.pg_namespace n on cl.relnamespace = n.oid
where cnt > 1;

-- Useless indexes
select n.nspname schemaname, tcl.relname tablename, icl.relname indexname from (
select indexrelid, indrelid, indkey from pg_catalog.pg_index where array_length(indkey, 1) = 1) si
join pg_catalog.pg_class icl on icl.oid = si.indexrelid
join pg_catalog.pg_class tcl on tcl.oid = si.indrelid
join pg_catalog.pg_namespace n on tcl.relnamespace = n.oid
where exists (
select null from pg_catalog.pg_index pi where array_length(indkey, 1) > 1 and si.indkey[0] = any(pi.indkey) and si.indrelid = pi.indrelid);