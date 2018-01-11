--
-- Query contributed by 曾琦 (ZENG Qi)
--
-- print pk of table 'movies'
select pg_constraint.conname as pk_name from pg_constraint  inner join pg_class
 on pg_constraint.conrelid = pg_class.oid where pg_class.relname = 'movies' and pg_constraint.contype='p'