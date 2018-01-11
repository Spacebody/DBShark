--
-- Query contributed by 黄博 (HUANG Bo)
--
create table table_with_PK(table_name	varchar(30),					constraint_schema	varchar(30));insert into table_with_PK(constraint_schema, table_name)	select constraint_schema, table_name from information_schema.table_constraints ck		where ck.constraint_type = 'PRIMARY KEY';select * from table_with_PK;