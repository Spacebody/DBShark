--
-- Query contributed by 戴志豪 (DAI Zhihao)
--
-- This query looks for tables where all columns can be null except perhaps a system-generated number
select b.table_catalog, b.table_schema, b.table_name, a.nullable_column_count from (
	select table_catalog, table_schema, table_name, count(*) column_count 
	from information_schema.columns
	group by table_catalog, table_schema, table_name
) b
join (
	select table_catalog, table_schema, table_name, count(*) nullable_column_count
	from (
		select table_catalog, table_schema, table_name, is_nullable 
		from information_schema.columns
		-- Since "System columns (oid, etc.) are not included" in "information_schema" in PostgreSQL,
		-- here we will not filter the value of is_generated
		-- You may need to add that condition if you're using this script on a different DBMS.
		where is_nullable='YES'
		) nullable_columns
	group by table_catalog, table_schema, table_name
) a
on a.table_catalog=b.table_catalog 
	and b.table_schema=a.table_schema 
	and b.table_name=a.table_name
where b.column_count=a.nullable_column_count 
	and b.table_schema not in ('pg_catalog', 'information_schema');