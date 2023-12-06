
USE DW_Sample
SELECT 
d.datename as Date,
SUM([SalesQuantity]) as SalesQuantity,
COUNT(*) as NumberOfSales
FROM [DW_Sample].[dbo].[FactSales] s join DimDates d ON s.orderdatekey = d.DateKey
GROUP BY d.datename