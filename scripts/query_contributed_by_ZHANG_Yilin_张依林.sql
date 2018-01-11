--
-- Query contributed by 张依林 (ZHANG Yilin)
--
-- Tables without a primary key
SELECT n.nspname AS "Schema",c.relname AS "Table Name",'No PK' AS "State"
FROM
 pg_catalog.pg_class c
JOIN
 pg_namespace n
ON (
 c.relnamespace = n.oid
 AND n.nspname NOT IN ('information_schema', 'pg_catalog')
 AND c.relkind='r'
)
WHERE c.relhaspkey = 'f'
ORDER BY c.relname
;