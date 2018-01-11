--
-- Contributed by Stéphane Faroult
--
-- Lists views on views in the database (except in the data dictionary)
--
-- Views on view may be quite slow to query ...
--
with recursive v(view_schema,
                 view_name,
                 table_schema,
                 table_name,
                 view_level,
                 view_path) as
     (select vtu.view_schema,
             vtu.view_name,
             vtu.table_schema,
             vtu.table_name,
             0 as view_level,
             cast(vtu.view_name as text) as view_path
     from information_schema.view_table_usage vtu
          join information_schema.tables t
            on t.table_schema = vtu.table_schema
           and t.table_name = vtu.table_name
     where t.table_type = 'VIEW'
       and t.table_schema not in ('pg_catalog',
                                  'information_schema')
     union all
     select v.table_schema,
            v.table_name,
            vtu.table_schema,
            vtu.table_name,
            v.view_level + 2 as view_level,
            cast(v.view_path||'/'||v.table_name as text)
     from v
          join information_schema.view_table_usage vtu
            on vtu.view_schema = v.table_schema
           and vtu.view_name = v.table_name)
select lpad('', v.view_level, ' ') || view_schema || '.' || view_name as "View",
       table_schema || '.' || table_name as "Depends on view"
from v
order by view_path
;

