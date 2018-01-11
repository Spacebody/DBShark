--
-- Query contributed by 何睿智 (HE Ruizhi)
--
select table_schema,table_name,constraint_type from information_schema.table_constraints
where (table_schema,table_name) not in 
	(select table_schema,
			table_name
	from information_schema.table_constraints
	where constraint_type='PRIMARY KEY')