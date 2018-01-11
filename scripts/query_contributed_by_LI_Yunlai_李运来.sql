--
-- Query contributed by 李运来 (LI Yunlai)
--
-- check primary key, P :Primary key
-- one "YES" per PK, no "YES" when no PK;
SELECT  
 case CONSTRAINT_TYPE  
 when "P" then "YES"
 else "NO"
 end checkPK 
 FROM 
 information_schema.TABLE_CONSTRAINTS ct
 WHERE 
 table_schema = current_schema
 and ct.CONSTRAINT_TYPE = "P"

 