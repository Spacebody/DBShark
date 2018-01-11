--
-- Query contributed by 周瀚 (ZHOU Han)
--
select table_name
from information_schema.table_constraints
where table_schema='public'
except
select table_name
from information_schema.table_constraints
where table_schema='public' and constraint_type='PRIMARY KEY'

