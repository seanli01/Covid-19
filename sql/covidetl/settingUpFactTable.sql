

drop table [covid].[dbo].FactCovid
create table [covid].[dbo].FactCovid (
[DateKey] int not null,
[CountryKey] int not null,
[TotalCases] numeric(20,2)  null,
[NewCases] numeric(20,2)  null,
[TotalDeaths] numeric(20,2)  null,
[NewDeaths] numeric(20,2)  null,
constraint [PK_FactCovid] primary key clustered
([DateKey] ASC, [CountryKey] ASC)








)

create table [covid].[dbo].FactPopulation(
[Year] int not null,
[CountryKey] int not null,
[Population] numeric(30,2) null 
constraint [PK_FactPopulation] primary key clustered
([Year] ASC, [CountryKey] ASC)

)