--
-- Query contributed by 万昌龙 (WAN Changlong)
--
select distinct table_name,
        'Has no primary key' hint
        from information_schema.columns 
        where table_schema = current_schema 
        and table_name not in(
            select table_name 
            from information_schema.table_constraints 
            where constraint_type like 'PRIMARY%' 
            and table_schema = current_schema);