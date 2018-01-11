--
-- Query contributed by 章松涛 (ZHANG Songtao)
--
-- Find The same column name and give Description
create table information(table_schema varchar(30),table_name varchar(30),column_name varchar(30),data_type varchar(30));
insert into information(table_schema ,table_name,column_name ,data_type)
select table_schema,table_name,column_name,data_type
from information_schema.columns
where table_name like '%'
and table_schema = current_schema;

select 'There is a duplicated name in table: ' || table_name|| '.' || b.column_name||' which occurs in other tables' from information a
inner join (select info.column_name,count(*)  from information info 
group by info.column_name
having count(*) > 1) b
on a.column_name = b.column_name;

drop table information;