--
-- Query contributed by 罗钟灵 (LUO Zhongling)
--
create table table_without_PK (table_name VARCHAR(30),
                                constraint_schema varchar(30));

INSERT INTO table_without_PK (table_name, constraint_schema)
  SELECT table_name,constraint_schema FROM information_schema.constraints pk
    WHERE pk.constrain_type != 'PRIMARY KEY';

SELECT table_name FROM table_without_PK;