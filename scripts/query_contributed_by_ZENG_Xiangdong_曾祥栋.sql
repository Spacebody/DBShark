--
-- Query contributed by 曾祥栋 (ZENG Xiangdong)
--
--Tables where all columns have the same varchar datatype (with the same length) - smells of sloppy design.

select table_name from
(select * from
(select table_name, count(table_name) from
(select * from
(select table_name,column_name,data_type,character_maximum_length,min(character_maximum_length) over (partition by table_name)from information_schema.columns where table_schema = 's11510639') as a
where character_maximum_length = min and data_type = 'character varying') as b
group by table_name) as d
join
(select table_name as original_tablename, count(table_name) as original_count from
(select table_name,column_name,data_type,character_maximum_length,min(character_maximum_length) over (partition by table_name)from information_schema.columns where table_schema = 's11510639') as c
group by table_name) as e
on d.table_name = e.original_tablename) as f
where count = original_count


