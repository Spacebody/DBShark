--
-- Query contributed by 林杰 (LIN Jie)
--
-- find tables without a primary key
SELECT
  table_catalog,
  table_schema,
  table_name
FROM information_schema.tables
WHERE (table_catalog,
       table_schema,
       table_name) NOT IN
      (SELECT
         table_catalog,
         table_schema,
         table_name
       FROM information_schema.table_constraints
       WHERE constraint_type = 'PRIMARY KEY')
      AND table_schema NOT IN ('information_schema',
                               'pg_catalog')
      AND table_type = 'BASE TABLE';
