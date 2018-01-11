--
-- Query contributed by 杨晓苏 (YANG Xiaosu)
--
-- Tables without a primary key (very easy) - only acceptable for log tables.
SELECT
  n.nspname    AS "Schema",
  c.relname    AS "Table Name"
FROM
  pg_catalog.pg_class c
  JOIN
  pg_namespace n
    ON (
    c.relnamespace = n.oid
    AND n.nspname NOT IN ('information_schema', 'pg_catalog')
    AND c.relkind = 'r'
    )
WHERE c.relhaspkey = 'f'
ORDER BY c.relhaspkey, c.relname;