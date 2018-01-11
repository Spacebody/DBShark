--
-- Query contributed by 谢文涛 (XIE Wentao)
--
-- This script displays whether each table in a given schema has a primary key (or primary keys) or not.

SELECT
  DISTINCT
  t.table_name,
  CASE
  WHEN constraint_name IS NULL
    THEN 'without pk'
  ELSE 'with pk'
  END AS pk
FROM information_schema.tables t
  LEFT JOIN (SELECT
               table_name,
               constraint_name
             FROM information_schema.key_column_usage
             WHERE table_schema = 'public'
                   AND (constraint_name LIKE '%pk'
                        OR constraint_name LIKE '%pkey')) c
    ON c.table_name = t.table_name
WHERE table_schema = 'public';