--
-- Contributed by Stéphane Faroult
--
-- PostgreSQL schema analysis
--
-- Detection of multiple indexes on exactly the same columns
-- of the same table, and in the same order. Not allowed by Oracle,
-- but allowed by PostgreSQL (and SQL Server, but this query will 
-- only run against PostgreSQL).
--
-- The scope is tables in the current schema (indexes may be
-- elsewhere)
--
select z.table_name,
       string_agg(z.attname, ',') as columns,
       z.indexes
from (select y.toid,
             y.table_name,
             a.attname,
             y.n,
             y.indexes
      from (select toid,
                   table_name,
                   unnest(cols) colnum,
                   generate_subscripts(cols, 1) AS n,
                   string_agg(ltrim(coalesce(index_schema, '')
                              ||'.'||index_name, '.'), ',') as indexes
            from (select ct.oid as toid,
                         ct.relname  table_name,
                         case nsi.nspname
                           when nst.nspname then null
                           else nsi.nspname
                         end index_schema,
                         ci.relname
                         ||case
                             when i.indisprimary then '(PK)'
                             when i.indisunique then '(U)'
                             else ''
                           end index_name,
                         i.indnatts  col_count,
                         i.indkey as cols
                  from pg_index i
                       join pg_class ci
                         on ci.oid = i.indexrelid
                        and ci.relkind = 'i'
                       join pg_namespace nsi
                         on nsi.oid = ci.relnamespace
                       join pg_class ct
                         on ct.oid = i.indrelid
                        and ct.relkind in ('r','t','m','p')
                       join pg_namespace nst
                         on nst.oid = ct.relnamespace
                  where nst.nspname = current_schema()) x
            group by toid, table_name, cols
            having count(*) > 1) y
    join pg_attribute a
      on a.attrelid = y.toid
     and a.attnum = y.colnum
   order by y.table_name, y.indexes, y.n) z
group by z.table_name, z.indexes
order by z.table_name
;
