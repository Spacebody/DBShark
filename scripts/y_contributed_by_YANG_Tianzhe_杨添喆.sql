--
-- Query contributed by 杨添喆 (YANG Tianzhe)
--
--Several columns have the same name in different tables but different data types (or different lengths)
select * from 
	(select column_name,table_name,data_type,character_maximum_length from information_schema.columns where table_schema = 's11510631') as a 
join 
	(select column_name,table_name,data_type,character_maximum_length from information_schema.columns where table_schema = 's11510631') as b  
on (a.column_name=b.column_name) and (a.table_name<>b.table_name)
where (a.data_type <> b.data_type) or (a.character_maximum_length<>b.character_maximum_length)

--In the schema, all varchar columns have the same (default or "safe") length -sloppy design.
select 1 as If_Sloppy_design 
from 
	(select min(character_maximum_length), max(character_maximum_length) from 
		(select column_name,character_maximum_length from information_schema.columns where table_schema = 's11510631' and data_type = 'character varying') 
	as a) 
as c
join 
	(select min(character_maximum_length), max(character_maximum_length) from 
		(select column_name,character_maximum_length from information_schema.columns where table_schema = 's11510631' and data_type = 'character varying') 
	as b) 
as d on c.min=d.max
