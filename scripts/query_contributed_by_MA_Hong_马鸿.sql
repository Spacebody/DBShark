--
-- Query contributed by 马鸿 (MA Hong)
--
SELECT DISTINCT table_name
FROM information_schema.tables

WHERE table_name NOT IN (
  SELECT table_name  FROM  information_schema.table_constraints
      where constraint_type = 'PRIMARY KEY'
      and table_schema = 'public'
)
  and table_schema not like '%log'
  and table_schema != 'information_schema'
  and table_schema = 'public';