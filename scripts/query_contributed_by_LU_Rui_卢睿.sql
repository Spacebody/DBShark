--
-- Query contributed by 卢睿 (LU Rui)
--
select table_name, 
	cast('Tables do not have unique constraint comparing to a system-generated numerical identifier.' as varchar) hint
from(select distinct table_name
	from information_schema.columns
	where 
	    table_name not in 
	       (select distinct table_name 
	               from information_schema.TABLE_CONSTRAINTS
	               union select table_name 
	               		from information_schema.columns 
	               			where column_default like 'nextval%' )) tbn
		and table_schema = current_schema
;