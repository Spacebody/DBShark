--
-- Query contributed by 张帝文 (ZHANG Diwen)
--
--I select this question
--In the schema, all varchar columns have the same (default or "safe") length -
--sloppy design.

create table check(name varchar(10) not null,
					datatype varchar(10) not null,
					length int not null)
insert into check(name, datatype, length)
select name,type_name(system_type_id)as data_type,max_length as data_length
from sys.columns
where data_type = 'varchar'；

select count(*)
from check
group by length