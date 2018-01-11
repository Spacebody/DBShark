--
-- Query contributed by 张冬阳 (ZHANG Dongyang)
--

--Tables without a primary key (very easy) - only acceptable for log tables.
select * from information_schema.tables
where table_name not in (
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE)


--Tables where all columns have the same varchar datatype (with the same length) - smells of sloppy design.
select table_name,data_type
from(
select m.table_name,count(*),max(data_type) as data_type
from
(select table_name,data_type
from information_schema.columns
group by table_name,data_type) m
group by m.table_name) n
where n.count=1 
and data_type='character varying'

