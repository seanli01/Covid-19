use covid
create table logs.Log_Examples_Task(
	ETL_Task_ID int identity(1,1) not null,
	ETL_ID int not null,
	ETL_Task_Name varchar(100) null,
	StartTime datetime null,
	EndTime datetime null,
	Error_Flag bit null,
	Error_msg varchar(max) null

)
drop table logs.Log_Examples_ETL
create table logs.Log_Examples_ETL(
	ETL_ID int identity(1,1) not null,
	Source_ID int not null,
	StartTime datetime null,
	EndTime datetime null,
	Error_Flag bit null,

)