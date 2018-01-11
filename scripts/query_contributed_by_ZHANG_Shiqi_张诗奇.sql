--
-- Query contributed by 张诗奇 (ZHANG Shiqi)
--

create or replace function check_pk(schema_name varchar)
returns table(violate_table VARCHAR (64))
LANGUAGE plpgsql
AS $$
begin
  return query
  select cast(a.table_name as varchar)
  from
    (select table_name
     from INFORMATION_SCHEMA.TABLES
     where table_schema = schema_name) t
  left outer join
    (select table_name
     from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
     where constraint_type = 'PRIMARY KEY'
     and table_schema = schema_name) a
  on a.table_name = t.table_name
  where a.table_name is null;
END;
$$;

select * from check_pk('s11510580');
