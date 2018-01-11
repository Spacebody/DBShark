--
-- Query contributed by 叶飞杨 (YE Feiyang)
--

/*  problem 3  */

select table_name from INFORMATION_SCHEMA.TABLES a where table_schema = 's11410203'
and not exists (
    select * from (
                    SELECT table_name from information_schema.table_constraints WHERE constraint_type = 'PRIMARY KEY' and  table_schema = 's11410203' ) b
where a.table_name = b.table_name);