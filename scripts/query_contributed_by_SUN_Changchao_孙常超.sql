--
-- Query contributed by 孙常超 (SUN Changchao)
--
--Isolate tables (reference no other table, referenced by no other table) -
--sometimes justified (parameter table, log table), but sometimes just a big
--mistake.
SELECT
  table_schema,
  table_name,
  'ISOLATE TABLE' AS problem
FROM information_schema.tables
WHERE (table_schema, table_name) NOT IN (
  SELECT
    DISTINCT
    table_schema,
    table_name
  FROM information_schema.key_column_usage
  UNION
  SELECT
    DISTINCT
    table_schema,
    table_name
  FROM information_schema.constraint_table_usage
);

--Multiple legs relationships: unreferenced tables (many-to-many relationships)
--with foreign keys to more than two different tables. Rarely justified.
SELECT
  table_schema,
  table_name,
  'MULTIPLE LEGS RELATIONSHIPS' AS problem
FROM information_schema.table_constraints
WHERE constraint_type = 'FOREIGN KEY'
GROUP BY table_schema, table_name
HAVING count(*) > 1;

--Tables without a primary key (very easy) - only acceptable for log tables.
SELECT
  table_schema,
  table_name,
  'WITHOUT PRIMARY KEY' AS problem
FROM information_schema.tables
WHERE (table_schema, table_name) NOT IN (
  SELECT
    table_schema,
    table_name
  FROM information_schema.table_constraints
  WHERE constraint_type = 'PRIMARY KEY'
);

--Tables that have no other unique constraint than a system-generated numerical
--identifier - once again, only acceptable for log tables.
SELECT
  table_schema,
  table_name,
  'WITHOUT UNIQUE CONSTRAINT' AS problem
FROM information_schema.tables
WHERE (table_schema, table_name) NOT IN (
  SELECT
    DISTINCT
    table_schema,
    table_name
  FROM information_schema.table_constraints
  WHERE constraint_type = 'UNIQUE'
        OR constraint_type = 'PRIMARY KEY'
);

--Tables where all columns have the same varchar datatype (with the same
--length) - smells of sloppy design.
SELECT
  table_schema,
  table_name,
  'ALL COLUMNS HAVE SAME VARCHAR DATATYPE' AS problem
FROM information_schema.tables
WHERE (table_schema, table_name) IN (
  SELECT
    table_schema,
    table_name
  FROM information_schema.columns c1
  WHERE data_type = 'character'
        AND character_maximum_length = (SELECT avg(character_maximum_length)
                                        FROM information_schema.columns
                                        WHERE table_schema = c1.table_schema AND table_name = c1.table_name AND
                                              column_name = c1.column_name)
  GROUP BY table_schema, table_name
  HAVING count(*) = max(ordinal_position)
);

--Several columns have the same name in different tables but different data
--types (or different lengths)
SELECT
  c1.table_schema,
  c1.table_name,
  c1.column_name,
  c1.data_type,
  c1.character_maximum_length,
  'SAME NAME BUT DIFFERENT TYPE' AS problem
FROM information_schema.columns c1
  JOIN information_schema.columns c2
    ON c1.table_schema = c2.table_schema
WHERE c1.column_name = c2.column_name
      AND (c1.data_type != c2.data_type
           OR c1.character_maximum_length != c2.character_maximum_length)
ORDER BY c1.column_name;

--Columns that reference (in a foreign key constraint) a column of a different
--type (forbidden by MySQL, allowed by PostgreSQL)
SELECT
  c2.table_schema,c2.table_name,c2.column_name,
  c1.table_name as reference_table_name,c1.column_name as reference_column_name,
  'REFFERENCE COLUMN OF DIFFERENT TYPE' AS problem
FROM information_schema.table_constraints t
  JOIN information_schema.constraint_column_usage ccu
    ON t.table_schema = ccu.constraint_schema
      and t.constraint_name = ccu.constraint_name
  JOIN information_schema.columns c1
    ON ccu.table_schema = c1.table_schema
       AND ccu.table_name = c1.table_name
       AND ccu.column_name = c1.column_name
  JOIN information_schema.key_column_usage kcu
    ON t.table_schema = kcu.table_schema
       AND t.table_name = kcu.table_name
       AND t.constraint_name = kcu.constraint_name
  JOIN information_schema.columns c2
    ON kcu.table_schema = c2.table_schema
       AND kcu.table_name = c2.table_name
       AND kcu.column_name = c2.column_name
WHERE t.constraint_type = 'FOREIGN KEY'
      AND c1.data_type != c2.data_type;

--Tables where all columns can be null except perhaps a system-generated
--number - never justifiable.
SELECT
  table_schema,
  table_name,
  'ALL COLUMNS IS NULLABLE' AS problem
FROM information_schema.columns
WHERE (table_schema, table_name) NOT IN (
  SELECT
    DISTINCT
    table_schema,
    table_name
  FROM information_schema.columns
  WHERE is_nullable = 'NO'
);

