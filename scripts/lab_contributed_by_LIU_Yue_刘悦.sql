--
-- Query contributed by 刘悦 (LIU Yue)
--
--Tables without a primary key (very easy) - only acceptable for log tables.
select
'drop table '||t.table_name||';'
from information_schema.tables t
where t.table_name not in(
	select distinct table_name from information_schema.CONSTRAINT_COLUMN_USAGE 
	where constraint_name  like'%_pk'
) 