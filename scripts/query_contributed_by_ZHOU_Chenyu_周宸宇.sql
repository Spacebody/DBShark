--
-- Query contributed by 周宸宇 (ZHOU Chenyu)
--
SELECT table_schema, table_name, 'No PK' AS problem
FROM information_schema.tables
WHERE table_schema || '.' || table_name NOT IN (
  SELECT table_schema || '.' || table_name AS "table"
  FROM information_schema.table_constraints
  WHERE constraint_type = 'PRIMARY KEY'
)
UNION
SELECT table_schema, table_name, 'No Unique' AS problem
FROM information_schema.tables
WHERE table_schema || '.' || table_name NOT IN (
  SELECT table_schema || '.' || table_name AS "table"
  FROM information_schema.table_constraints
  WHERE constraint_type = 'UNIQUE'
);
