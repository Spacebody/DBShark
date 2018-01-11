--
-- Query contributed by 张晓文 (ZHANG Xiaowen)
--
-- Change schema name 's11510746' to meet your need
select table_names.table_name,'No Primary Key' as NOTICE
  from (select table_name
          from information_schema.tables
          where table_type = 'BASE TABLE'
                and table_schema = 's11510746') table_names
  where table_names.table_name
        not in (select table_name FROM information_schema.table_constraints
      WHERE table_schema = 's11510746' and constraint_type = 'PRIMARY KEY')
