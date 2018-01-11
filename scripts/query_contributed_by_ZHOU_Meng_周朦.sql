--
-- Query contributed by 周朦 (ZHOU Meng)
--

create table if not exists pk_info(id serial,
							table_name varchar(50),
							if_has_pk int)

													
insert into pk_info(table_name,if_has_pk)
select * from(
select informations.table_name,sum(if_has_pk)if_has_pk 
from( 
	select ist.table_schema,
			case 
				when ist.table_name is not null then ist.table_schema||':'||ist.table_name
			end as table_name,
			case 
				when ist.constraint_type = 'PRIMARY KEY' then 1
				else 0 
			end as if_has_pk
			from information_schema.table_constraints ist
		)informations
		group by informations.table_name)new_information
		where new_information.if_has_pk = 0

select table_name,case
				when if_has_pk = 0 then 'dont have pk'
				end as if_has_pk 
				from pk_info

drop table pk_info