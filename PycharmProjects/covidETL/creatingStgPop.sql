
drop table [covid].[dbo].stg_source_pop
create table [covid].[dbo].stg_source_pop(
countriesAndTerritories varchar(50) not null,
[location] varchar(50) not null,
continent varchar(50) not null,
Population_Year int not null,
[population] numeric(20,2) not null




)

select * from [covid].[dbo].stg_source_pop