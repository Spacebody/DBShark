--
-- Query contributed by 马策 (MA Ce)
--
--No.1  check tables that have no references or referees
--inspired by Peter Eisentraut's check-primary-key code
select 'catalog_name'||table_catalog ||' '|| 'schema'||table_schema ||' '||'table:'||table_name||' is isolated'  
    from information_schema.table_constraints
    where (table_catalog, table_schema, table_name) not in 
(select--fisrt select all tables that have be constrained by foriegn keys
    table_cons.table_catalog, table_cons.table_schema, table_cons.table_name 
from 
    information_schema.table_constraints as table_cons 
    join information_schema.key_column_usage as keyColumn_Usage
      on table_cons.constraint_catalog = keyColumn_Usage.constraint_catalog
      and table_cons.constraint_schema  = keyColumn_Usage.constraint_schema
      and table_cons.constraint_name = keyColumn_Usage.constraint_name
      where constraint_type = 'FOREIGN KEY'
union 
select--second select all tables that keys as other tables foriegn keys
    table_cons.table_catalog, table_cons.table_schema, table_cons.table_name 
  from 
    information_schema.table_constraints as table_cons 
    join information_schema.constraint_column_usage as constraint_col_u
      on table_cons.constraint_catalog = constraint_col_u.constraint_catalog
      and table_cons.constraint_schema  = constraint_col_u.constraint_schema
      and constraint_col_u.constraint_name = table_cons.constraint_name
    where constraint_type = 'FOREIGN KEY')
and table_schema not in ('information_schema', 'pg_catalog')
group by table_catalog, table_schema, table_name;--except for tables that are system ones

--No.2 find tables that have no primary keys
--Credit Peter Eisentraut  
select table_catalog, table_schema, table_name
    from information_schema.table_constraints
    where (table_catalog, table_schema, table_name) NOT IN
          (select table_catalog, table_schema, table_name
               from information_schema.table_constraints
               where constraint_type = 'PRIMARY KEY')
      and table_schema NOT IN ('information_schema', 'pg_catalog')
      group by table_catalog, table_schema, table_name;

--CeMA 11410172