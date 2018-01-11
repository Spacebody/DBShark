--
-- Query contributed by 陆克渊 (LU Keyuan)
--

select distinct x.table_name from (
select * from information_schema.table_constraints
except
select*from information_schema.table_constraints
where constraint_type='PRIMARY KEY')x


