--
-- Query contributed by 曾歆勋 (ZENG Xinxun)
--
create or replace function notUniqueTable(schema varchar)
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
            (select constraint_schema s, table_name t,count(constraint_type) n from information_schema.table_constraints WHERE constraint_type='PRIMARY KEY' OR constraint_type='UNIQUE' GROUP BY s,t) sub
            on(table_schema = sub.s and table_name= sub.t)
WHERE(n is null or n = 1) and table_schema = schema and table_name not LIKE '%log' and table_type='BASE TABLE';
end;
$$ language plpgsql;

create or replace function notUniqueTable()
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
            (select constraint_schema s, table_name t,count(constraint_type) n from information_schema.table_constraints WHERE constraint_type='PRIMARY KEY' OR constraint_type='UNIQUE' GROUP BY s,t) sub
            on(table_schema = sub.s and table_name= sub.t)
WHERE(n is null or n = 1) and table_schema != 'information_schema' and table_schema not LIKE '%log' and table_name not LIKE '%log' and table_type='BASE TABLE';
end;
$$ language plpgsql;

SELECT * from notUniqueTable();