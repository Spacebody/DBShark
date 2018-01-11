--
-- Query contributed by 蔡泽鹏 (CAI Zepeng)
--
/*备份数据库的存储过程*/

if exists(

 select * from movies

  where name='fims_backup_db' and xtype='p'

          )

begin

 drop proc fims_backup_db

end

go

 

create proc fims_backup_db

@flag varchar(20) out,

@backup_db_name varchar(128),

@filename varchar(1000)  --路径＋文件名字

as

declare @sql nvarchar(4000),@par nvarchar(1000)

if not exists(

 select * from master..sysdatabases

  where name=@backup_db_name

  )

begin

 select @flag='db not exist'  /*数据库不存在*/

 return

end

else

begin

 if right(@filename,1)<>'/' and charindex('/',@filename)<>0

 begin

  select @par='@filename varchar(1000)'

  select @sql='BACKUP DATABASE '+@backup_db_name+' to disk=@filename with init'

  execute sp_executesql @sql,@par,@filename

  select @flag='ok'

  return

 end

 else

 begin

  select @flag='file type error'  /*参数@filename输入格式错误*/

  return

 end

end

 

GO

 

/*还原数据库的过程*/

if exists(

 select * from movies

  where name='pr_restore_db' and xtype='p'

          )

begin

 drop proc pr_restore_db

end

go

 

CREATE  proc pr_restore_db   

@flag varchar(20) out,    /*过程运行的状态标志,是输入参数*/     

@restore_db_name nvarchar(128),  /*要恢复的数据名字*/

@filename nvarchar(260)         /*备份文件存放的路径+备份文件名字*/

as

declare @proc_result tinyint  /*返回系统存储过程xp_cmdshell运行结果*/

declare @loop_time smallint  /*循环次数*/

declare @max_ids smallint    /*@tem表的ids列最大数*/

declare @file_bak_path nvarchar(260)  /*原数据库存放路径*/

declare @flag_file bit   /*文件存放标志*/

declare @master_path nvarchar(260)  /*数据库master文件路径*/

declare @sql nvarchar(4000),@par nvarchar(1000)

declare @sql_sub nvarchar(4000)

declare @sql_cmd nvarchar(100)

declare @sql_kill nvarchar(100)

/*

判断参数@filename文件格式合法性，以防止用户输入类似d: 或者 c:/a/ 等非法文件名

参数@filename里面必须有'/'并且不以'/'结尾

*/

if right(@filename,1)<>'/' and charindex('/',@filename)<>0

begin

 select @sql_cmd='dir '+@filename

 EXEC @proc_result = master..xp_cmdshell @sql_cmd,no_output

 IF (@proc_result<>0)  /*系统存储过程xp_cmdshell返回代码值:0(成功）或1（失败）*/

 begin

  select @flag='not exist'   /*备份文件不存在*/

  return  /*退出过程*/

 end

 /*创建临时表,保存由备份集内包含的数据库和日志文件列表组成的结果集*/

 create table #tem(

     LogicalName nvarchar(128), /*文件的逻辑名称*/

     PhysicalName nvarchar(260) , /*文件的物理名称或操作系统名称*/

     Type char(1),  /*数据文件 (D) 或日志文件 (L)*/

     FileGroupName nvarchar(128), /*包含文件的文件组名称*/

     [Size] numeric(20,0),  /*当前大小（以字节为单位）*/

     [MaxSize] numeric(20,0)  /*允许的最大大小（以字节为单位）*/

   )

 /*

 创建表变量，表结构与临时表基本一样

 就是多了两列,

 列ids（自增编号列）,

 列file_path,存放文件的路径

 */

 declare @tem table(      

     ids smallint identity,  /*自增编号列*/

     LogicalName nvarchar(128),

     PhysicalName nvarchar(260),

     File_path nvarchar(260),

     Type char(1), 

     FileGroupName nvarchar(128)

   )

 insert into #tem

  execute('restore filelistonly from disk='''+@filename+'''')

 /*将临时表导入表变量中,并且计算出相应得路径*/

 insert into @tem(LogicalName,PhysicalName,File_path,Type,FileGroupName) 

  select LogicalName,PhysicalName,dbo.fn_GetFilePath(PhysicalName),Type,FileGroupName

   from #tem

 if @@rowcount>0

 begin

  drop table #tem

 end

 select @loop_time=1

 select @max_ids=max(ids)  /*@tem表的ids列最大数*/

  from @tem

 while @loop_time<=@max_ids

 begin

  select @file_bak_path=file_path

   from @tem where ids=@loop_time

  select @sql_cmd='dir '+@file_bak_path

  EXEC @proc_result = master..xp_cmdshell @sql_cmd,no_output

  /*系统存储过程xp_cmdshell返回代码值:0(成功）或1（失败）*/

  IF (@proc_result<>0)

   select @loop_time=@loop_time+1 

  else

   BREAK /*没有找到备份前数据文件原有存放路径，退出循环*/

 end

 select @master_path=''

 if @loop_time>@max_ids

  select @flag_file=1   /*备份前数据文件原有存放路径存在*/

 else

 begin

  select @flag_file=0  /*备份前数据文件原有存放路径不存在*/

  select @master_path=dbo.fn_GetFilePath(filename)

   from master..sysdatabases

   where name='master'

 end

 select @sql_sub=''

 /*type='d'是数据文件,type='l'是日志文件 */

 /*@flag_file=1时新的数据库文件还是存放在原来路径，否则存放路径和master数据库路径一样*/

 select @sql_sub=@sql_sub+'move '''+LogicalName+''' to '''

   +case type

         when 'd' then case @flag_file

             when 1 then  File_path

      else @master_path

          end   

         when 'l' then case  @flag_file

      when 1 then  File_path

      else @master_path

          end   

   end

   +case type

    when 'd' then @restore_db_name

           +'_DATA'

           +convert(sysname,ids)  /*给文件编号*/

           +'.'

           +right(PhysicalName,3)  /*给文件加入后缀名,mdf or ndf*/

           +''',' 

    when 'l' then @restore_db_name

           +'_LOG'

           +convert(sysname,ids)   /*给文件编号*/

           +'.'

           +right(PhysicalName,3)  /*给文件加入后缀名,mdf or ndf*/

           +''',' 

    end

   from @tem

 select @sql='RESTORE DATABASE @db_name FROM DISK=@filename with '

 select @sql=@sql+@sql_sub+'replace'

 select @par='@db_name nvarchar(128),@filename nvarchar(260)'

 /*关闭相关进程，把相应进程状况导入临时表中*/

 select identity(int,1,1) ids, spid

  into #temp

  from master..sysprocesses

  where dbid=db_id(@restore_db_name)

 if @@rowcount>0 --找到相应进程

 begin  

  select @max_ids=max(ids)

   from #temp

  select @loop_time=1

  while @loop_time<=@max_ids

  begin

   select @sql_kill='kill '+convert(nvarchar(20),spid)

    from #temp

    where ids=@loop_time

   execute sp_executesql @sql_kill

   select @loop_time=@loop_time+1

  end

 end

 drop table #temp

 execute sp_executesql @sql,@par,@db_name=@restore_db_name,@filename=@filename

 select @flag='ok'   /*操作成功*/

end

else

begin

 SELECT @flag='file type error'  /*参数@filename输入格式错误*/

end

 

 

GO

 

/*创建函数,得到文件得路径*/

if exists(

 select * from movies

  where name='fn_GetFilePath' and xtype='fn'

        )

begin

 drop function fn_GetFilePath

end

go

 

create function fn_GetFilePath(@filename nvarchar(260))

returns nvarchar(260)  

as

begin

 declare @file_path nvarchar(260)

 declare @filename_reverse nvarchar(260)

 select @filename_reverse=reverse(@filename)

 select @file_path=substring(@filename,1,len(@filename)+1-charindex('/',@filename_reverse))

 return @file_path

end
GO

 

/*输入参数,执行备份过程的过程*/

 

CREATE PROCEDURE Pr_BackupDataBase

  @DataBaseName varchar(255),/*需要备份的数据库名*/

  @BackupPath varchar(255)/*数据库备份的完整路径*/

 As

declare @fl varchar(10)

execute fims_backup_db @fl out,@DataBaseName,@BackupPath

select @fl

GO

 

/*输入参数,执行还原过程的过程*/

 

CREATE PROCEDURE Pr_RestoreDataBase

  @DataBaseName varchar(255),/*还原后的数据库名*/

  @BackupPath varchar(255)/*数据库备份的完整路径*/

AS

declare @fl varchar(20)

exec pr_restore_db @fl out,@DataBaseName,@BackupPath

select @fl

GO