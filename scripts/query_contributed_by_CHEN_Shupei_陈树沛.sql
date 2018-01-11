--
-- Query contributed by 陈树沛 (CHEN Shupei)
--
SELECT
	'table ' ||
    c.relname || ' has no primary key'
FROM
    pg_catalog.pg_class c
JOIN
    pg_namespace n
ON (
    c.relnamespace = n.oid
    AND n.nspname NOT IN ('information_schema', 'pg_catalog')
    AND c.relkind='r'
)
where n.nspname = 's11510319' and c.relhaspkey is false
ORDER BY c.relhaspkey, c.relname