--
-- Query contributed by 方一栋 (FANG Yidong)
--
-- Tables where all columns have the same varchar datatype (with the same length) smells of sloppy design.
select table_schema, table_name, length_num, varchar_num
from(
    select table_schema, table_name, count(distinct character_maximum_length) length_num, count(*) varchar_num
    from information_schema.columns col
    where character_maximum_length is not null
    and data_type = 'character varying'
    and exists
    (select null
            from information_schema.columns 
            where table_schema = col.table_schema and table_name = col.table_name
            having count(distinct data_type) = 1
    )
    group by table_schema, table_name
) result
where length_num = 1 and varchar_num>2