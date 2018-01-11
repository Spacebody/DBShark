--
-- Query contributed by 许梦婷 (XU Mengting)
--
select distinct x.table_name from 
(select * from information_schema.table_constraints
where table_schema='s11510243'
except
select * from information_schema.table_constraints
    where table_schema='s11510243' and constraint_type='PRIMARY KEY') x