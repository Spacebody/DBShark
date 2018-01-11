--
-- Query contributed by 曾一帆 (ZENG Yifan)
--
--Isolate tables (reference no other table, referenced by no other table) 
--sometimes justified (parameter table, log table), but sometimes just a big mistake

SELECT table_name
from INFORMATION_SCHEMA.TABLES t
WHERE table_type = 'BASE TABLE'
and not exists (SELECT 1 FROM
  (SELECT DISTINCT table_name from INFORMATION_SCHEMA.KEY_COLUMN_USAGE u
join (select constraint_name from
  INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS
union all
select unique_constraint_name from
  INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS) x
on u.constraint_name = x.constraint_name) y
WHERE t.table_name = y.table_name);