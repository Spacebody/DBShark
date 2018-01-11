--
-- Query contributed by 梁丹怡 (LIANG Danyi)
--
--
-- To find a list of names
-- of isolate tables in current schema
--
SELECT table_name
FROM information_schema.tables
where table_schema = current_schema
AND table_name NOT IN
    (select table_name
    from information_schema.table_constraints
    where table_schema = current_schema)
;
