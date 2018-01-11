--
-- Query contributed by 曾一帆 (ZENG Yifan)
--
--Tables without a primary key (very easy) - only acceptable for log tables.

select table_name from INFORMATION_SCHEMA.TABLES t where  table_type = 'BASE TABLE'
and not exists (select 1 from (SELECT table_name from information_schema.table_constraints
WHERE table_schema = 's11410285' and constraint_type = 'PRIMARY KEY') x
where t.table_name = x.table_name);