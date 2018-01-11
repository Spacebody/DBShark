--
-- Query contributed by 华正昌 (HUA Zhengchang)
--
DROP TABLE IF EXISTS check_isolate;
DROP TABLE IF EXISTS check_pk;

SELECT
  table_name                    AS tbl_name,
  table_name :: REGCLASS :: OID AS oid,
  table_type                    AS type,
  TRUE                          AS is_iso
INTO check_isolate
FROM information_schema.tables
WHERE table_schema = 'public';


SELECT
  table_name                    AS tbl_name,
  table_name :: REGCLASS :: OID AS oid,
  table_type                    AS type,
  FALSE                         AS has_pk
INTO check_pk
FROM information_schema.tables
WHERE table_schema = 'public';


UPDATE check_isolate
SET is_iso = FALSE
WHERE oid IN (SELECT DISTINCT confrelid
              FROM pg_constraint
              WHERE contype = 'f' AND conrelid IN (SELECT oid
                                                   FROM check_isolate)) -- referenced by others
      OR oid IN (SELECT conrelid
                 FROM pg_constraint
                 WHERE contype = 'f' AND confrelid != 0); -- referenced others


UPDATE check_pk
SET has_pk = TRUE
WHERE oid IN (SELECT conrelid
              FROM pg_constraint
              WHERE contype = 'p');




