--
-- Query contributed by 白冰 (BAI Bing)
--
--select the question "Tables without a primary key (very easy) - only acceptable for log tables."
create table if not exists table_pk_infromation(id serial,
												table_schema varchar(30),
												table_name varchar(30),
												has_pk varchar(3)
);
insert into table_pk_infromation(table_schema,table_name,has_pk)
select table_schema , table_name ,
	(
		case has_pk_num
		when 0 then 'NO'
		when 1 then 'YES'
		end
	) as has_pk from
	(select table_schema , table_name , max(is_pk) as has_pk_num from (
		select table_schema , table_name ,
			(
				case constraint_type
				when 'PRIMARY KEY' then 1
				else 0
				end
			) as is_pk
		from information_schema.table_constraints) tb
	group by table_name , table_schema) tb2;

select * from table_pk_infromation;

drop table table_pk_infromation;