--
-- Query contributed by 郑钿彬 (ZHENG Tianbin)
--
select table_schema,table_name,constraint_type, 'NO' primary_key_constraint from information_schema.table_constraints
where (table_schema,table_name) not in
	(select table_schema,
			table_name
	from information_schema.table_constraints
	where constraint_type='PRIMARY KEY')
