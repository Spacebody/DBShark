--
-- Query contributed by 葛林飞 (GE Linfei)
--
--Tables where all columns can be null except perhaps a system-generated number - never justifiable.

select p.table_name 
from (select table_name,count(*) as num_of_column 
	from information_schema.columns 
	group by table_name) as p
join (select table_name,count(*) as num_of_null 
	from information_schema.columns 
	where is_nullable='YES' 
	group by table_name) as q on q.table_name=p.table_name
where num_of_column = num_of_null + 1;