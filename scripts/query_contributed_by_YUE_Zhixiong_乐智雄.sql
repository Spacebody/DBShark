--
-- Query contributed by 乐智雄 (YUE Zhixiong)
--
-- Tables without a primary key (very easy) - only acceptable for log tables.

SELECT t.relname table_without_primaryKey
FROM (
	SELECT c.oid, c.relname, n.nspname
	FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace
	WHERE c.relkind = 'r' AND n.nspname IN('s11410441')
) AS t LEFT OUTER JOIN pg_constraint c ON c.contype = 'p' AND c.conrelid = t.oid
WHERE c.conname IS NULL;


select table_name table_without_primaryKey from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
where table_name not in	(select table_name from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
where constraint_type = 'PRIMARY KEY');




