use datawarehousesample

set identity_insert [datawarehousesample].[dbo].[DimDates] ON
--go


insert into [datawarehousesample].[dbo].[DimDates](
[DateKey],
[Date],
[DateName],
[Month],
[MonthName],
[Quarter],
[QuarterName],
[Year],
[YearName])

SELECT
[DateKey] = -1,
[Date] = CAST( '01/01/1900' as nvarchar(50)),
[DateName]      = CAST('Unknown_Day' as nvarchar(50)),
[Month]         = -1,
[MonthName]     = CAST('Unknown_Month' as nvarchar(50)),
[Quarter]       = -1,
[QuarterName]   = CAST('Unknown_Quarter' as nvarchar(50)),
[Year]          = -1,
[YearName]      = CAST('Unknown_Year' as nvarchar(50))


SET identity_insert [datawarehousesample].[dbo].[DimDates] off


--USE datwarehousesample
SELECT
[Pubs].[dbo].[Sales].qty,
[Order_Date_Key] = ISNULL([datawarehousesample].[dbo].[DimDates].[DateKey], -1)
FROM [Pubs].[dbo].[Sales]
LEFT JOIN [datawarehousesample].[dbo].[DimDates]
ON [Pubs].[dbo].[Sales].[ord_date] = [datawarehousesample].[dbo].[DimDates].[Date]