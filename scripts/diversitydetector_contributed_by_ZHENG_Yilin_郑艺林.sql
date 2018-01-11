--
-- Query contributed by 郑艺林 (ZHENG Yilin)
--
-- script show several columns with the same name but with different data type or length(at least one is different)
-- four columns showed in the table
-- first column shows the column name which is duplicated in different tables
-- second column, in json, shows the table name and the data type and the length of the column in the table 
-- third column shows whether exists diverse data type or not 
-- forth column shows if any data length differs
drop table if exists columns_collections;
create table columns_collections(table_name varchar(45) not null UNIQUE,
											   details json,
												 diverse_data_type varchar(45) not null,
                         diverse_length varchar(45) not null);
insert into columns_collections
select column_name,
        cast('{'||string_agg('"'||table_name||'": ["'||
                             data_type||'", '||
                             case when character_maximum_length is null then 'null'
                             else cast(character_maximum_length as varchar)
                             end
                             ||']', ', ') ||'}' as json),
				case when count(distinct data_type) > 1 then 'Yes'
				else 'No' end,
	      case when count(distinct character_maximum_length) > 1 then 'Yes'
				else 'No' end
from information_schema.columns
where table_schema = current_schema
group by column_name
having count(distinct table_name) > 1 and (count(distinct data_type) > 1 or count(distinct character_maximum_length) > 1);

select * from columns_collections;

