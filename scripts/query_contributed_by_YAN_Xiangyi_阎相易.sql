--
-- Query contributed by 阎相易 (YAN Xiangyi)
--
-- Find table without a primary key
select
    n.nspname as "schema",
    c.relname as "name_table"
from
    pg_catalog.pg_class c
join
    pg_namespace n
on (
        c.relnamespace = n.oid
    and c.relkind='r'
    and n.nspname not in ('information_schema', 'pg_catalog')
)
    where c.relhaspkey = FALSE
order by n.nspname, c.relname;
