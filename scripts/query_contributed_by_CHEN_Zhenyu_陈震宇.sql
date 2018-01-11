--
-- Query contributed by 陈震宇 (CHEN Zhenyu)
--
SELECT table_catalog, table_schema, table_name
    FROM information_schema.tables
    WHERE (table_catalog, table_schema, table_name) NOT IN
          (SELECT table_catalog, table_schema, table_name
               FROM information_schema.table_constraints
               WHERE constraint_type = 'PRIMARY KEY')
      AND table_schema NOT IN ('information_schema', 'pg_catalog');
