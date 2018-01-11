--
-- Query contributed by 傅伟 (FU Wei)
--
select table_name no_PK_talbes
from information_schema.tables 
where not exists (select *
			   from information_schema.table_constraints
			   where constraint_type = 'PRIMARY KEY');