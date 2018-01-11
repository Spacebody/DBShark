--
-- Query contributed by 王耕昕 (WANG Gengxin)
--
--Tables with or without a primary key.
select c.table_name, 
	case when (select count(*)
		from (select table_name
			from information_schema.table_constraints
			where table_schema = current_schema
			and constraint_type = 'PRIMARY KEY'
			group by table_name) p
		where p.table_name = c.table_name) > 0 then true else false
	end as has_pk 
from (select table_name, constraint_type
			from information_schema.table_constraints
			where table_schema = current_schema
			) c
group by table_name
;
