--
-- Query contributed by 倪子恒 (NI Ziheng)
--
SELECT DISTINCT *
FROM information_schema.tables
WHERE table_schema = 'public'
      AND table_name NOT IN (
  SELECT table_name
  FROM information_schema.table_constraints
  WHERE constraint_type = 'PRIMARY KEY'
        AND table_schema = 'public');
