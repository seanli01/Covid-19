use covid
select * from stg_source_total_cases

declare @start_date DATE = '2019-12-31'
declare @end_date DATE = '2040-12-31' 

while @start_date < @end_date
begin 
insert into DimDate (
DateKey,
Date,
Day,
DayName,
Month,
MonthName,
Quarter,
Year
)

values( 
format(@start_date,'yyyyMMdd'),
@start_date,
datepart(day, @start_date),
datename(day, @start_date),
datepart(month, @start_date),
datename(month, @start_date),
datepart(quarter, @start_date),
datepart(year, @start_date)

)

set @start_date = DATEADD(dd,1,@start_date)

end
select * from DimDate
	







