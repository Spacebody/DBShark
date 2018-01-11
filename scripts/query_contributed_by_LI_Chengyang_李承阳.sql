--
-- Query contributed by 李承阳 (LI Chengyang)
--
-- Postgresql check primary key
-- Reference:
-- 1. https://www.postgresql.org/docs/9.3/static/catalogs.html
-- 2. https://www.postgresql.org/docs/9.3/static/catalog-pg-class.html
-- 3. https://www.postgresql.org/docs/9.3/static/catalog-pg-namespace.html
-- 4. https://www.postgresql.org/docs/9.3/static/information-schema.html

SELECT
    n.nspname AS "Schema",
    c.relname AS "Table",
    c.relhaspkey AS "PK Exist"
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
;
