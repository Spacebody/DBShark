--
-- Query contributed by 王林 (WANG Lin)
--
-- Question: Tables without a primary key (very easy) - only acceptable for log tables.
-- find all table that do not have PK using namespace.
SELECT
  n.nspname    AS "Schema",
  c.relname    AS "Table Name",
  /*c.relhaspkey AS "Has PK",*/
  CASE
  WHEN c.relhaspkey = FALSE
    THEN 'NO PK'
  ELSE 'Has PK'
  END          AS result

FROM
  pg_catalog.pg_class c
  JOIN
  pg_namespace n
    ON (
    c.relnamespace = n.oid
    AND n.nspname NOT IN ('information_schema', 'pg_catalog') -- remove those.
    AND c.relkind = 'r'
    )
/*WHERE c.relhaspkey = 'f'*/ -- 'f' as no primary key.
/*WHERE n.nspname = 's11510064'*/
ORDER BY c.relhaspkey, c.relname;