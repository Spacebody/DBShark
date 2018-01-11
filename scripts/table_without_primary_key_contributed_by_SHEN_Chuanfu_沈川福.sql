--
-- Query contributed by 沈川福 (SHEN Chuanfu)
--
select inftab.table_schema,
       inftab.table_name
from information_schema.tables inftab
where table_type = 'BASE TABLE'
  and table_schema not in ('pg_catalog', 'information_schema')
  and not exists (select *
                  from information_schema.key_column_usage infokcu
                  where infokcu.table_name = inftab.table_name
                    and infokcu.table_schema = inftab.table_schema)