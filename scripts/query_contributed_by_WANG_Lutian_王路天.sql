--
-- Query contributed by 王路天 (WANG Lutian)
--
select table_name || 'does not have primary key' 
    --'alter table ' || table_name || ' add primary key (id);'
from information_schema.tables 
where xtype='U' 
and  table_name not in 
    (select table_name 
    from information_schema.tables 
    where xtype='PK'); --找出不含有primary key的表
     