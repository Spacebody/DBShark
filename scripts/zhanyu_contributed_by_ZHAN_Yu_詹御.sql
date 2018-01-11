--
-- Query contributed by 詹御 (ZHAN Yu)
--

-- check if exists a table without PK (for mysql)
	select temp.table 'tablename'
			from (select TABLE_NAME 'table', count(INDEX_NAME) cnt_num 
				from 
				information_schema.STATISTICS 
				where INDEX_NAME = 'PRIMARY'
				group by TABLE_NAME) temp 
				where temp.cnt_num = 0;