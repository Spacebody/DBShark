--
-- Query contributed by 王辰轩 (WANG Chenxuan)
--
select table_name from information_schema.TABLES
where table_name not in (select table_name from information_schema.KEY_COLUMN_USAGE)