--
-- Query contributed by 谢文涛 (XIE Wentao)
--
-- This script displays the tables where all columns have the same varchar data type (of same length).

SELECT
  table_name,
  data_type,
  character_maximum_length max_length
FROM
  (SELECT
     *,
     count(*)
     OVER (
       PARTITION BY table_name ) cnt
   FROM
     (SELECT
        table_name,
        data_type,
        character_maximum_length
      FROM information_schema.columns
      WHERE table_schema = 'public'
      GROUP BY table_name, data_type, character_maximum_length) x) y
WHERE cnt = 1
      AND data_type LIKE 'character%';