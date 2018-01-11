--
-- Query contributed by 王泽淮 (WANG Zehuai)
--
select table_name, cast('Tables that have no other unique constraint than a system-generated numerical identifier.' as varchar) hint
from(select distinct table_name
	from information_schema.columns
	where table_schema = current_schema
	   and table_name not in 
	       (select distinct table_name 
	               from information_schema.TABLE_CONSTRAINTS
	               union select table_name from information_schema.columns where column_default like 'nextval%' )) x
;