--
-- Query contributed by 毛玉莲 (MAO Yulian)
--
-- Tables without a primary key (very easy) - only acceptable for log tables.
SELECT table_name
FROM information_schema.table_constraints
WHERE table_name NOT IN (
                              select table_name
                              from information_schema.table_constraints
                              where table_name = 'table_name' and constraint_type = 'PRIMARY KEY');

-- Several columns have the same name in different tables but different datatypes (or different lengths)
select a.column_name,a.data_type,b.column_name,b.data_type
from information_schema.columns a
JOIN information_schema.columns b
  ON a.column_name = b.column_name and a.data_type != b.data_type