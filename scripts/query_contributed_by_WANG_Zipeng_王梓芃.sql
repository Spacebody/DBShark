--
-- Query contributed by 王梓芃 (WANG Zipeng)
--

-- Tables without a primary key (very easy) - only acceptable for log tables.
select table_name ,'Tables without a primary key'as log from information_schema.tables t
where table_name not in
  (select table_name from information_schema.table_constraints
    where constraint_type = 'PRIMARY KEY'
group by table_name) AND t.table_schema NOT IN ('pg_catalog','information_schema') ;



-- -- Tables that have no other unique constraint than a system-generated numerical identifier - once again, only acceptable for log tables.
select table_name, 'Tables that have no other unique constraint' as log from information_schema.tables where table_name not in
(select table_name from information_schema.table_constraints)
and table_schema not in('pg_catalog','information_schema') ;


-- Several columns have the same name in different tables but different data
-- types (or different lengths)
select 'same name in different table but different data type' as log,
  c1.column_name column1,c2.column_name column2
from information_schema.columns c1
join information_schema.columns c2
on c1.column_name = c2.column_name
and c1.data_type<>c2.data_type
and c1.table_name<>c2.table_name
AND c1.table_schema NOT IN ('pg_catalog','information_schema') AND c2.table_schema NOT IN ('pg_catalog','information_schema')


