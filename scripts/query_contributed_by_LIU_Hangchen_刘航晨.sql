--
-- Query contributed by 刘航晨 (LIU Hangchen)
--
select table_name, cast('Tables which have same unique constraints with system numerical identifiers.' as varchar) hint
from(select distinct table_name from information_schema.columns
	where table_schema = current_schema and table_name not in 
	   (select table_name from information_schema.TABLE_CONSTRAINTS
              select table_name from information_schema.columns where column_default like 'nextval%' )
);