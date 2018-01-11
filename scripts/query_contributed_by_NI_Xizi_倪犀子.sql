--
-- Query contributed by 倪犀子 (NI Xizi)
--
-- Question 3
-- List all the table that do not have primary key
SELECT NSP.nspname AS "SCHEMA",
  PC.relname AS "TABLE NAME",
  PC.relhaspkey AS "IF HAS PRIMARY KEY"
FROM pg_catalog.pg_class PC
JOIN pg_namespace NSP
ON PC.relnamespace = NSP.OID
AND NSP.nspname <> 'pg_catalog'
AND PC.relkind = 'r'
ORDER BY PC.relhaspkey;