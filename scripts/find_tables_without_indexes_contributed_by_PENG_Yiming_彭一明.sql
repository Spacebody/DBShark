--
-- Query contributed by 彭一明 (PENG Yiming)
--
SELECT tablename FROM pg_tables
WHERE hasindexes IS FALSE;