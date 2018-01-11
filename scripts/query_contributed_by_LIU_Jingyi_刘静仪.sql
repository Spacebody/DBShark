--
-- Query contributed by 刘静仪 (LIU Jingyi)
--
--1.Tables without a primary key (very easy) - only acceptable for log tables.

SELECT n.nspname AS "Schema",c.relname AS "table_name",case when c.relhaspkey='f' then 'No_PK' else 'YES_PK' end AS "Has_PK" 
FROM
 pg_class c
JOIN
 pg_namespace n
ON (
 c.relnamespace = n.oid
 AND n.nspname IN ('public','s11510122')--or others
 AND c.relkind='r'
)
ORDER BY n.nspname,c.relhaspkey
;



--2. Several columns have the same name in different tables but different data types (or different lengths)

with prep as(
select n.nspname,c.relname,a.attname,a.attlen,a.atttypid
from pg_attribute a
join pg_class c on (c.oid=a.attrelid and c.relkind='r')
join pg_namespace n on (n.oid=c.relnamespace and  n.nspname IN ('public','s11510122'))
)
select p.nspname as "Schema",p.relname as "table_name",p.attname as "column",
case when p.attname in(
select t.attname  
from prep t 
join prep b on b.attname=t.attname
where  t.atttypid<>b.atttypid
or t.attlen<>b.attlen ---recognize different length,as for 'int2','int4'
) then 'YES' else 'NO' end as Is_same_Cname
from prep p 
order by p.attname;