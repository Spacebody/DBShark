--
-- Query contributed by 曾歆勋 (ZENG Xinxun)
--
create or replace function allNullTable(schema varchar)
RETURNS table(
table_schemas varchar
  ,table_names varchar
)
as $$
DECLARE
begin
  RETURN QUERY
          select cast(table_schema as varchar) ts, cast(table_name as varchar) tn
          FROM information_schema.tables
          LEFT OUTER JOIN
            (select table_schema s, table_name t,count(*) n FROM information_schema.columns WHERE is_nullable='NO' GROUP BY s,t) sub
            on(table_schema = sub.s and table_name= sub.t)
WHERE(n is null or n=1) and table_schema = schema and table_type='BASE TABLE';
end;
$$ language plpgsql;

create or replace function allNullTable()
RETURNS table(
table_schemas varchar
  ,table_names varchar
)
as $$
DECLARE
begin
  RETURN QUERY
          select cast(table_schema as varchar) ts, cast(table_name as varchar) tn
          FROM information_schema.tables
          LEFT OUTER JOIN
            (select table_schema s, table_name t,count(*) n FROM information_schema.columns WHERE is_nullable='NO' GROUP BY s,t) sub
            on(table_schema = sub.s and table_name= sub.t)
WHERE (n is null or n=1) and table_schema != 'information_schema' and table_type='BASE TABLE';
end;
$$ language plpgsql;

SELECT * from allNullTable();