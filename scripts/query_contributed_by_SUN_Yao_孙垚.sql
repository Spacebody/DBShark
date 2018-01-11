--
-- Query contributed by 孙垚 (SUN Yao)
--
select * from information_schema.TABLES
where table_name not in(select DISTINCT table_name from information_schema.TABLE_CONSTRAINTS
                                        where constraint_type = 'PRIMARY KEY')
      and table_schema not like 'pg_catalog'
      and table_schema not like 'information_schema'
      and table_type like 'BASE TABLE'