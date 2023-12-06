        INSERT INTO [datawarehousesample].[logs].[Log_Examples_Task](ETL_ID,ETL_Task_Name, StartTime, EndTime,Error_Flag,Error_msg)

		values(1,'hello', GETDATE(), getdate(), 0,'a')

		 select * from [datawarehousesample].[logs].[Log_Examples_Task]
		 truncate table [datawarehousesample].[logs].[Log_Examples_ETL]  
		 
		 drop table [datawarehousesample].[logs].[Log_Examples_ETL]

		 select * from [datawarehousesample].[dbo].[FactTitlesAuthors]


		 CREATE TABLE [logs].[Log_Examples_ETL](
			[ETL_ID] [int] IDENTITY(1,1) NOT NULL,
			[Source_ID] [int] NOT NULL,
			[Source_Type] [varchar](100) NULL,
			[StartTime] [datetime] NULL,
			[EndTime] [datetime] NULL,
			[Error_Flag] [bit] NULL
			) on [primary]


		create table [logs].[source](
	[Source_ID][int]identity(1,1) not null,
	[Source_type][varchar](100) null

)

insert into [datawarehousesample].[logs].[source](
	Source_Type)

values (

	'Database'
	)