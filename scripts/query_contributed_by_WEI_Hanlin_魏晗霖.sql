--
-- Query contributed by 魏晗霖 (WEI Hanlin)
--

-- check if exists redundent indexs (for mysql)
	select t1.TABLE_SCHEMA 'schema', t1.TABLE_NAME 'table', t1.COLUMN_NAME 
	'column', t1.INDEX_NAME 'index1', t2.INDEX_NAME 'index2'
	from 
		INFORMATION_SCHEMA.STATISTICS t1
		join INFORMATION_SCHEMA.STATISTICS t2   
		on t1.TABLE_NAME = t2.TABLE_NAME 
		and t1.COLUMN_NAME = t2.COLUMN_NAME 
		where t1.TABLE_SCHEMA = t2.TABLE_SCHEMA 
		and t1.SEQ_IN_INDEX = t2.SEQ_IN_INDEX 
		and t1.INDEX_NAME <> t2.INDEX_NAME
;