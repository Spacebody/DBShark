--
-- Query contributed by 李帅霖 (LI Shuailin)
--
--the following is to check those classes that don't have primary keys in your DB schema.
--by Seolen Li, 2017.12.29

SELECT
  ns.nspname    AS "Users",
  c.relname    AS "Table_Name",
  c.relhaspkey AS "Has_Primary_Key"
FROM
  pg_catalog.pg_class c
  JOIN
  pg_namespace ns
    ON (
    c.relnamespace = ns.oid
    AND ns.nspname NOT IN ('information_schema', 'pg_catalog')
    AND c.relkind = 'r'
    )
WHERE c.relhaspkey = 'f'           --t if true and f if false
ORDER BY c.relhaspkey, ns.nspname,c.relname;