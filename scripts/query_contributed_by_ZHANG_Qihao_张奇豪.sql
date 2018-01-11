--
-- Query contributed by 张奇豪 (ZHANG Qihao)
--
select n.nspname as "schema",
        c.relname as "table_name",
        case
        when c.relhaspkey = 'f' then 'no primary key '
        end as result
from pg_class c
join pg_namespace n
on c.relnamespace = n.oid
  and n.nspname not in ('information_schema', 'pg_catalog')
  -- not include thoese table belongs to system
  and c.relkind = 'r'
  -- check those ordinary table
where c.relhaspkey = 'f'  -- filter table with no primary key
order by c.relname


