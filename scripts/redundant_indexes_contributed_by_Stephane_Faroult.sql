-- 
--  Contributed by Stéphane Faroult
--
--  Lists for the current schema indexes that start with the same column(s)
--  as another index on the same table.
--  The other index can be used for the same queries ... dropping the
--  index with the fewer number of columns, unless it enforces a constraint,
--  shouldn't affect queries, and would require less work when inserting/deleting
--  and updating the columns in the index.
--
--  Note that you may sometimes find in an index unique columns + other columns.
--  This is a trick to find all the data required by a query in the index without
--  requiring an additional access to the table. Not very common.
--
select z.table_name,
       z.index_name,
       z.redundant_with || '(' ||       
          string_agg(z.attname, ',') 
          || ')' || z.redundant_with_type as redundant_with
from (select y.toid,
             y.table_name,
             y.index_name,
             y.redundant_with,
             y.redundant_with_type,
             a.attname,
             y.n
      from (select toid,
                   table_name,
                   index_name,
                   redundant_with,
                   redundant_with_type,
                   unnest(cols) colnum,
                   generate_subscripts(cols, 1) AS n
            from (select ct.oid as toid,
                         ct.relname  table_name,
                         ltrim(case nsi.nspname
                                 when nst.nspname then ''
                                 else nsi.nspname
                               end || '.' ||ci.relname, '.')
                              ||'('||a.attname||')'
                              ||case
                                  when i.indisprimary then '(PK)'
                                  when i.indisunique then '(U)'
                                  else ''
                                end index_name,
                         ltrim(case nsi2.nspname
                                 when nst.nspname then ''
                                 else nsi2.nspname
                               end || '.' || ci2.relname, '.') redundant_with,
                         case
                           when i2.indisprimary then '(PK)'
                           when i2.indisunique then '(U)'
                           else ''
                         end redundant_with_type,
                        i2.indkey as cols
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
                       join pg_attribute a
                         on a.attrelid = ct.oid
                        and a.attnum = i.indkey[0]
                       join pg_index i2
                         on i2.indrelid = i.indrelid
                        and i2.indexrelid <> i.indexrelid
                        and i2.indkey[0] = i.indkey[0]
                       join pg_class ci2
                         on ci2.oid = i2.indexrelid
                        and ci2.relkind = 'i'
                       join pg_namespace nsi2
                         on nsi2.oid = ci2.relnamespace
                  where nst.nspname = current_schema()
                    and i.indnatts = 1) x) y
          join pg_attribute a
            on a.attrelid = y.toid
           and a.attnum = y.colnum
      order by y.table_name, y.index_name, y.redundant_with, y.n) z
group by z.table_name, z.index_name,
         z.redundant_with, z.redundant_with_type
order by z.table_name,
         z.index_name,
         z.redundant_with
;
