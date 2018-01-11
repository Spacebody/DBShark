--
-- Query contributed by 蔡源稻 (CAI Yuandao)
--
select table_name, column_name, ordinal_position, data_type from information_schema.columns
where table_name = 'movies' and table_schema = 'public'

SELECT
    n.nspname AS "Schema",
    c.relname AS "Table Name",
    c.relhaspkey AS "Has PK"
FROM
    pg_catalog.pg_class c
JOIN
    pg_namespace n
ON (
        c.relnamespace = n.oid
    AND n.nspname NOT IN ('information_schema', 'pg_catalog')
    AND c.relkind='r'
)
ORDER BY c.relhaspkey, c.relname

select 'drop table ' ||
       table_name || ';'
from information_schema.tables
where table_name like 'TMP%'


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