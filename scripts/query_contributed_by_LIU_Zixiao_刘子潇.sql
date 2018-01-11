--
-- Query contributed by 刘子潇 (LIU Zixiao)
--

-- check if exists redundent indexs (for mysql)
	select i1.TABLE_SCHEMA 'schema', i1.TABLE_NAME 'table', i1.COLUMN_NAME 
	'column', i1.INDEX_NAME 'index1', i2.INDEX_NAME 'index2'
	from 
		INFORMATION_SCHEMA.STATISTICS i1
		join INFORMATION_SCHEMA.STATISTICS i2   
		on i1.TABLE_NAME = i2.TABLE_NAME 
		and i1.COLUMN_NAME = i2.COLUMN_NAME 
		where i1.TABLE_SCHEMA = i2.TABLE_SCHEMA 
		and i1.SEQ_IN_INDEX = i2.SEQ_IN_INDEX 
		and i1.INDEX_NAME <> i2.INDEX_NAME  
;

-- check if exists a table (or tables) without indexs (for mysql)
	select a.table
		from (select TABLE_NAME 'table', count(INDEX_NAME) cnt 
			from information_schema.STATISTICS group by TABLE_NAME) a 
			where a.cnt = 0
;

-- check the isolated table(s) (for mysql)
	select table_name FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
		where referenced_table_schema is null
		
-- check if exists a table (or tables) without PK (for postgresql)
	select c.relname
		from pg_catalog.pg_class c
			join pg_namespace n
			on c.relnamespace = n.oid
			    where n.nspname <> 'information_schema' 
			    and n.nspname <> 'pg_catalog' 
			    and c.relkind = 'r'
				and c.relhaspkey is false
				and n.nspname = 's11510447';


--