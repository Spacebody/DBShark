--
-- Query contributed by 宋培彦 (SONG Peiyan)
--
-- find tables which have no primary key
-- using mysql
SELECT TABLE_NAME
FROM information_schema.TABLES
WHERE TABLE_NAME not in(
SELECT TABLE_NAME 
FROM information_schema.TABLE_CONSTRAINTS 
WHERE CONSTRAINT_TYPE = 'PRIMARY KEY');