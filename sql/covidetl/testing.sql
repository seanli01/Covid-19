truncate table logs.Log_Examples_ETL
truncate table logs.Log_Examples_Task

truncate table FactCovid

('42S22', "[42S22] [Microsoft][ODBC SQL Server Driver][SQL Server]Invalid column name 'Year'. (207) (SQLExecDirectW)")
select * from logs.Log_Examples_ETL 

select * from logs.Log_Examples_Task --where ETL_ID=2
[Errno 2] No such file or directory: 'PopFactCovidTotDeaths.sql'
[Errno 2] No such file or directory: 'PopFactPopulation.sql'
('42S22', "[42S22] [Microsoft][ODBC SQL Server Driver][SQL Server]Invalid column name 'Year'. (207) (SQLExecDirectW)")
('42S22', "[42S22] [Microsoft][ODBC SQL Server Driver][SQL Server]Invalid column name 'total_deaths'. (207) (SQLExecDirectW); [42S22] [Microsoft][ODBC SQL Server Driver][SQL Server]Invalid column name 'TotalDeaths'. (207); [42S22] [Microsoft][ODBC SQL Server Driver][SQL Server]Invalid column name 'TotalDeaths'. (207)")

select *
from [dbo].[FactCovid]

select *
from [dbo].[FactPopulation]


select * from DimCountry