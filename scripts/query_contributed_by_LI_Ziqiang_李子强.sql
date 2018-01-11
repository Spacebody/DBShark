--
-- Query contributed by 李子强 (LI Ziqiang)
--
select
  n.nspname    as "Schema",
  c.relname    as "Table Name",
  c.relhaspkey as "Has PK"
from pg_catalog.pg_class c
  join pg_namespace n
    on (
    c.relnamespace = n.OID
    and n.nspname not in ('information_schema', 'pg_catalog')
    and c.relkind = 'r'
    )
order by n.nspname asc, c.relname asc,c.relhaspkey desc;