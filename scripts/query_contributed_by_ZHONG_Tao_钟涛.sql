--
-- Query contributed by 钟涛 (ZHONG Tao)
--
-- DBMS：MySQL5.7
-- check tables without indexs
	select nit.tn
		from (select TABLE_NAME tn, count(INDEX_NAME) cin
			from information_schema.STATISTICS group by TABLE_NAME) nit
			where nit.cin = 0;