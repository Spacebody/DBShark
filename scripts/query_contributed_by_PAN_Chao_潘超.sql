--
-- Query contributed by 潘超 (PAN Chao)
--
select t1.table_schema, t1.table_name, 
    case when t2.constraint_type is null
        then 'No primary key'
        else 'Have the primary key'
    end
    from information_schema.tables t1
        left join information_schema.table_constraints t2 
        on t1.table_schema = t2.table_schema 
            and t1.table_name = t2.table_name
    where t1.table_type = 'BASE TABLE' 
        and (t2.constraint_type = 'PRIMARY KEY' or t2.constraint_type is null);