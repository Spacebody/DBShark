--
-- Query contributed by 张恺玥 (ZHANG Kaiyue)
--
select distinct table_name, 'Tables where all columns have the same varchar datatype (with the same length).' message
from(select table_name,
         count(table_name)over (partition by table_name) character_cnt,
         x.cnt whole_cnt, 
         min(character_maximum_length) over(partition by table_name) as minimum,
         max(character_maximum_length) over(partition by table_name) as maximum
from(select table_name,
       column_name,
       ordinal_position,
       data_type,
       character_maximum_length,
       count(*) over (partition by table_name) cnt
from information_schema.columns
where table_schema = current_schema) x
where x.data_type like 'character %'
order by table_name, ordinal_position) y
where y.maximum = y.minimum and y.character_cnt = y.whole_cnt
;
--create table test (c1 varchar(8),c2 varchar(8),c3 varchar(8))