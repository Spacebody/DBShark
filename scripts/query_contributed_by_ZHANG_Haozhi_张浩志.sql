--
-- Query contributed by 张浩志 (ZHANG Haozhi)
--
-- Tables that have no other unique constraint than a system-generated numerical identifier
-- Print unique constrain column in table 'movies'
SELECT pg_CONSTRAINT.conname FROM pg_CONSTRAINT
WHERE pg_CONSTRAINT.conrelid in
(SELECT  pg_class.oid FROM pg_class WHERE relname = 'movies')
and pg_CONSTRAINT.contype = 'u';