--
-- Query contributed by 张楠 (ZHANG Nan)
--
-- Detect tables where all columns have the same varchar datatype (with the same length) -
-- smells of sloppy design.
-- The table names, data_type and length of the poorly designed tables will be returned
SELECT
  x.table_name sloppy_designed_tables,
  data_type,
  character_maximum_length
FROM (SELECT
        table_name,
        column_name,
        ordinal_position,
        data_type,
        character_maximum_length,
        count(*)
        OVER (
          PARTITION BY table_name )                           cnt,
        count(*)
        OVER (
          PARTITION BY table_name, data_type )                same_data_type_cnt,
        count(character_maximum_length)
        OVER
          (
          PARTITION BY table_name, character_maximum_length ) same_length_cnt
      FROM information_schema.columns
      WHERE table_schema = current_schema) x
WHERE data_type = 'character varying'
      AND cnt = same_data_type_cnt
      AND cnt = same_length_cnt
ORDER BY table_name
;
