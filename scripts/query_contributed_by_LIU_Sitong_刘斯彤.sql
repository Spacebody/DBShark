--
-- Query contributed by 刘斯彤 (LIU Sitong)
--
SELECT TABLE_NAME AS table_without_primary_key
FROM information_schema.tables c1
WHERE  c1.table_schema='public'AND TABLE_NAME not in
      (SELECT c.TABLE_NAME AS n
       FROM information_schema.TABLE_CONSTRAINTS c
       WHERE c.constraint_schema='public'
       AND  c.CONSTRAINT_NAME LIKE '%pkey' or c.CONSTRAINT_NAME LIKE '%pk'
       GROUP BY c.table_name)
