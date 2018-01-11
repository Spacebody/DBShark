--
-- Query contributed by 易尚儒 (YI Shangru)
--
select cast(c.relname as varchar) as table_name, cast(t.relname as varchar) as index_name, problem from
	(select indrelid, indexrelid,cast('Duplicate Index'as varchar) as problem
		from pg_index
		group by indrelid, indkey, indexrelid
    		having count(*) > 1) usele_in
     join pg_class c
     on c.oid = indrelid
     join pg_class t
     on t.oid = indexrelid
union all
	select cast(c.relname as varchar)as table_name, cast(t.relname as varchar)as index_name, problem from
	(select indrelid, indexrelid,cast('Useless index'as varchar) as problem
		from pg_index
		group by indrelid, indkey, indexrelid
	     having count(*) > 1) usele_in
	     join pg_class c
	     on c.oid = indrelid
	     join pg_class t
	     on t.oid = indexrelid
