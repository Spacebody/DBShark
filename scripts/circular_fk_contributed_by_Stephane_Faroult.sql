--
-- Contributed by Stéphane Faroult
--
-- PostgreSQL schema analysis
--
-- Detection of circular foreign keys, other than self-references.
-- (T1 -> T2 -> ... -> T1)
--
-- The scope is the database.
--
with recursive q(table_schema, table_name,
                 ref_table_schema, ref_table_name)  as
    (select tc.table_schema,
            tc.table_name,
            tcu.table_schema as ref_table_schema,
            tcu.table_name as ref_table_name
     from information_schema.table_constraints tc
          join information_schema.constraint_table_usage tcu
            on tcu.constraint_schema = tc.constraint_name
           and tcu.constraint_name = tc.constraint_name
     where (tc.table_schema <> tcu.table_schema
           or tc.table_name <> tcu.table_name)
       and tc.constraint_type= 'FOREIGN KEY'
     union all
     select tc.table_schema,
            tc.table_name,
            tcu.table_schema as ref_table_schema,
            tcu.table_name as ref_table_name
     from q
          join information_schema.table_constraints tc
            on tc.table_schema = q.ref_table_schema
           and tc.table_name = q.ref_table_name
          join information_schema.constraint_table_usage tcu
            on tcu.constraint_schema = tc.constraint_name
           and tcu.constraint_name = tc.constraint_name
     where (tc.table_schema <> tcu.table_schema
           or tc.table_name <> tcu.table_name)
       and tc.constraint_type= 'FOREIGN KEY')
select table_schema || '.' || table_name as table_name 
from (select table_schema, table_name
      from q
      limit 5000) x
group by table_schema,
         table_name
having count(*) > 100 
;
