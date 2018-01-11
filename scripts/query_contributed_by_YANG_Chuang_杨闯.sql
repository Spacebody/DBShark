--
-- Query contributed by 杨闯 (YANG Chuang)
--
--Tables without a primary key (very easy) - only acceptable for log tables
select distinct t1.table_name from information_schema.TABLE_CONSTRAINTS t1
      where not exists(select t2.table_name from information_schema.TABLE_CONSTRAINTS t2
                                where t2.table_name= t1.table_name and t2.constraint_type='PRIMARY KEY');
