--
-- Query contributed by 白银川 (BAI Yinchuan)
--
SELECT n.nspname AS "Schema", c.relname AS "Table_Name", c.relhaspkey AS "has_PK"
FROM pg_catalog.pg_class c
JOIN pg_namespace n
	ON c.relnamespace = n.oid AND n.nspname NOT IN ('information_schema', 'pg_catalog') AND c.relkind = 'r'
WHERE c.relhaspkey = 'f'
ORDER BY c.relhaspkey, c.relname
;