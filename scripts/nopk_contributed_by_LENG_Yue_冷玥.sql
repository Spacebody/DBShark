--
-- Query contributed by 冷玥 (LENG Yue)
--
-- Find table without a primary key
SELECT
    n.nspname AS "Schema",
    c.relname AS "Table Name"
FROM
    pg_catalog.pg_class c
JOIN
    pg_namespace n
ON (
        c.relnamespace = n.oid
    AND n.nspname NOT IN ('information_schema', 'pg_catalog')
    AND c.relkind='r'
)
    WHERE c.relhaspkey = FALSE
ORDER BY n.nspname, c.relname;