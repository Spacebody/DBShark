--
-- Query contributed by 王海燕 (WANG Haiyan)
--
select table_name as no_primary_key_table
from information_schema.tables 
where table_name not in 
	(select table_name 
	 from information_schema.TABLE_CONSTRAINTS 
	 where constraint_type = 'Primary Key')
and table_schema = 's11410246' 
and table_type = 'BASE TABLE';

