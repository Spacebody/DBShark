--
-- Query contributed by 范治宇 (FAN Zhiyu)
--
select total.table_schema,total.table_name, pk.table_name
from information_schema.tables total
left join (select table_schema, table_name
	   from information_schema.TABLE_CONSTRAINTS
	   where constraint_type = 'PRIMARY KEY') pk
on total.table_name = pk.table_name and total.table_schema = pk.table_schema
where total.table_type = 'BASE TABLE'and total.table_schema not LIKE '%log' and total.table_schema != 'information_schema' and pk.table_name is null

