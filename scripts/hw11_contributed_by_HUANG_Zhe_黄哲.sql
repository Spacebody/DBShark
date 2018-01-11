--
-- Query contributed by 黄哲 (HUANG Zhe)
--
--QUERY 1
--Tables without a primary key (very easy) - only acceptable for log tables.
SELECT
  t.table_name as TABLE_NOT_PRIMARY_KEY
FROM information_schema.tables t
WHERE t.table_schema = 'public' AND t.table_name NOT IN (
  SELECT table_name
  FROM information_schema.table_constraints
  WHERE table_schema NOT IN ('information_schema', 'pg_catalog') AND
        constraint_type != 'PRIMARY KEY'
);

--QUERY 2
--Tables where all columns can be null except perhaps a system-generated number - never justifiable.
SELECT DISTINCT t3.table_name as Tables_where_all_columns_are_null
FROM (
       SELECT
         t.table_name,
         t.column_name,
         t.is_nullable,
         count(t.is_nullable)
         OVER (
           PARTITION BY t.table_name ) num1,
         t1.num2
       FROM information_schema.columns t
         INNER JOIN (SELECT
                       t.table_name,
                       t.column_name,
                       t.is_nullable,
                       count(t.column_name)
                       OVER (
                         PARTITION BY t.table_name ) num2
                     FROM information_schema.columns t
                     WHERE table_schema NOT IN ('information_schema', 'pg_catalog')) t1
           ON t1.table_name = t.table_name AND t1.column_name = t.column_name
       WHERE table_schema NOT IN ('information_schema', 'pg_catalog') AND t.is_nullable = 'NO') t3
WHERE t3.num1 = t3.num2;

--QUERY 3
--Several columns have the same name in different tables but different data types (or different lengths)
SELECT
  ttt.table_name,
  ttt.column_name,
  ttt.data_type
FROM
  (SELECT
     tt.table_name,
     tt.column_name,
     tt.data_type,
     count(tt.column_name)
     OVER (
       PARTITION BY tt.column_name, tt.data_type ) num
   FROM (
          SELECT
            t.table_name,
            t.column_name,
            t.data_type,
            count(t.column_name)
            OVER (
              PARTITION BY t.column_name ) num
          FROM information_schema.columns t
          WHERE t.table_schema NOT IN ('information_schema', 'pg_catalog')) tt
   WHERE tt.num >= 2) ttt
WHERE ttt.num = 1;