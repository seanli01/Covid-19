USE datawarehousesample
SELECT
[Pubs].[dbo].[Sales].qty,
[Order_Date_Key] = ISNULL(datawarehousesample.[dbo].[DimDates].[DateKey], -1)
FROM [Pubs].[dbo].[Sales]
LEFT JOIN datawarehousesample.[dbo].[DimDates]
ON [Pubs].[dbo].[Sales].[ord_date] = datawarehousesample.[dbo].[DimDates].[Date]