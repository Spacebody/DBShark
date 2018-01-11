--
-- Query contributed by 李佳星 (LI Jiaxing)
--

///
select table_name
from information_schema.key_column_usage 
left outer join
(select table_name as name1
  from( 
  select constraint_name, table_name,column_name, 
                                case  
                                when constraint_name like '%_pk'then '1'
                                when constraint_name like '%_uq' then '2'
                                else '3'  end as judge
  from information_schema.key_column_usage
  where table_name in (select table_name from information_schema.tables)
  and constraint_schema='s11510685') as object
 where object.judge = '1'
 group by table_name)as b on table_name=b.name1
 where table_name in (select table_name from information_schema.tables)
    and constraint_schema='s11510685'
 group by table_name
