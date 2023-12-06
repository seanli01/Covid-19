create table logs.Log_Examples_Task(
	ETL_Task_ID int identity(1,1) not null,
	ETL_ID int not null,
	ETL_Task_Name varchar(100) null,
	StartTime datetime null,
	EndTime datetime null,
	Error_Flag bit null,
	Error_msg varchar(max) null

)

create table logs.Log_Examples_ETL(
	ETL_ID int identity(1,1) not null,
	System_ID int not null,
	Source_ID int not null,
	Source_Type varchar(100),
	StartTime datetime null,
	EndTime datetime null,
	Error_Flag bit null,

)