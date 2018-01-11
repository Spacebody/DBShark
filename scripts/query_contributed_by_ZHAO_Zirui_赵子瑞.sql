--
-- Query contributed by 赵子瑞 (ZHAO Zirui)
--
create table if not exists pk_info(id serial,
												table_schema varchar(30),
												table_name varchar(30),
												has_pk varchar(20)
);
insert into pk_info(table_schema,table_name,has_pk)
select tb.table_schema , tb.table_name ,
	(
		case constraint_type
		when 'PRIMARY KEY' then 'Has PK'
		else 'Dont has PK'
		end
	) as has_pk
	from
	(select t1.table_name , t1.table_schema , t2.constraint_type from
		(select table_schema,table_name from information_schema.table_constraints
		group by table_schema,table_name) t1
		left join
			(select table_schema,table_name,constraint_type from information_schema.table_constraints
			where constraint_type = 'PRIMARY KEY') t2
		on t1.table_schema = t2.table_schema and t1.table_name=t2.table_name) tb;

select * from pk_info;

drop table pk_info;