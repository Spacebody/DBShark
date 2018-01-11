--
-- Query contributed by 石晗峰 (SHI Hanfeng)
--
select * from information_schema.tables
where tables.table_name not like '%log%'
order by table_schema