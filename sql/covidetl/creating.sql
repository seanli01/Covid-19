
create table DimDate(
--[DateKey] int not null primary key identity(1,1),
[DateKey] int not null primary key ,
[Date] date not null,
[Day] int not null,
[DayName] nvarchar(50) not null,
[Month] int not null,
[MonthName] nVarchar(50) not null,
[Quarter] int not null,
[Year] int not null,


)

create table DimCountry(
[CountryKey] int not null primary key identity(1,1),
[CountryName] nvarchar(50) not null

)
select * from stg_source_total_cases

drop table DimCountry