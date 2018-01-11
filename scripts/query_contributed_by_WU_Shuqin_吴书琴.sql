--
-- Query contributed by 吴书琴 (WU Shuqin)
--
-- check tables without a primary key

CREATE TABLE if not exists BadDesign(BadType VARCHAR(50) NOT NULL , Info VARCHAR(100) NOT NULL);
ALTER TABLE ONLY BadDesign ADD CONSTRAINT BadDesign_pk PRIMARY KEY (BadType, Info);
insert into BadDesign(BadType, Info)
SELECT 'Table without primary key',allTable.table_name
FROM (SELECT table_name
   FROM information_schema.TABLE_CONSTRAINTS
   WHERE table_schema = 's11510212'
   GROUP BY table_name) allTable
    LEFT JOIN
  (SELECT table_name
   FROM information_schema.TABLE_CONSTRAINTS
   WHERE table_schema = 's11510212'
         AND constraint_type = 'PRIMARY KEY') havePK
  ON havePK.table_name = allTable.table_name
WHERE havePK.table_name IS NULL;
SELECT * FROM BadDesign;
DROP TABLE BadDesign;