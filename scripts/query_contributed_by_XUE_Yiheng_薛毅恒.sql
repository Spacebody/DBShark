--
-- Query contributed by 薛毅恒 (XUE Yiheng)
--
--Tables without a primary key
select
  inf.table_name as NO_PRIMARY_KEY_TABLE
from information_schema.tables inf
where inf.table_schema = 'public' and inf.table_name NOT in 
(
  select table_name from information_schema.table_constraints where 
  table_schema NOT in ('information_schema', 'pg_catalog')and 
  constraint_type <> 'PRIMARY KEY'
);