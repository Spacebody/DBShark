--
-- Query contributed by 陈淑仪 (CHEN Shuyi)
--
DROP TABLE IF EXISTS check_multileg;
SELECT
  table_name                    AS tbl_name,
  table_name :: REGCLASS :: OID AS oid,
  table_type                    AS type,
  CASE WHEN fk_cnt.cnt > 2
    THEN TRUE
  ELSE FALSE END                AS is_multileg
INTO check_multileg
FROM information_schema.tables
  JOIN (SELECT
          conrelid,
          count(*) AS cnt
        FROM pg_constraint
        WHERE contype = 'f' AND confrelid != conrelid
        GROUP BY conrelid) fk_cnt ON table_name :: REGCLASS :: OID = conrelid
WHERE table_schema = 'public';