--
-- Query contributed by 陈成竹 (CHEN Chengzhu)
--
SELECT
    #CONCAT("truncate table ",table_name,";") 
table_name 
FROM
    information_schema. TABLES
WHERE
    table_schema = 'scdm'
AND TABLE_NAME NOT IN (
    SELECT
        table_name
    FROM
        information_schema.table_constraints t
    JOIN information_schema.key_column_usage k USING (
        constraint_name,
        table_schema,
        table_name
    )
    WHERE
        t.constraint_type = 'PRIMARY KEY'
    AND t.table_schema = 'scdm'
)