--EXEC master.dbo.sp_dropserver @server=N'SQL2012_MultiDim', @droplogins='droplogins'
--GO

EXEC master.dbo.sp_addlinkedserver
@server = N'SQL2012_MultiDim',
@srvproduct = '',
@provider = N'MSOLAP',
@datasrc = N'Sherlock\sql2012_MultiDim',
@catalog = N'DW_Sample_SSAS'


SELECT *
FROM OPENQUERY 
(SQL2012_MultiDim,
'SELECT NON EMPTY { [Measures].[SalesQuantity], [Measures].[NumberOfSales] } ON COLUMNS, 
NON EMPTY { ([DimDates].[Date].[Date].ALLMEMBERS ) } DIMENSION PROPERTIES MEMBER_CAPTION, 
MEMBER_UNIQUE_NAME ON ROWS FROM [DW_Sample_Cube] 
CELL PROPERTIES VALUE, BACK_COLOR, FORE_COLOR, 
FORMATTED_VALUE, FORMAT_STRING, FONT_NAME, FONT_SIZE, FONT_FLAGS 
')



SELECT 
CAST("[DimDates].[Date].[Date].[Member_Caption]" AS nvarchar (50)) AS DateName,
CAST("[Measures].[SalesQuantity]" AS int) AS SalesQuantity,
CAST("[Measures].[NumberOfSales]" AS int) AS NumberOfSales
FROM OPENQUERY 
(SQL2012_MultiDim,
'SELECT NON EMPTY { [Measures].[SalesQuantity], [Measures].[NumberOfSales] } ON COLUMNS, 
NON EMPTY { ([DimDates].[Date].[Date].ALLMEMBERS ) } DIMENSION PROPERTIES MEMBER_CAPTION, 
MEMBER_UNIQUE_NAME ON ROWS FROM [DW_Sample_Cube] 
')

EXCEPT

SELECT 
d.datename As DateName,
SUM([SalesQuantity]) as SalesQuantity,
COUNT(*) as SalesCount
FROM [DW_Sample].[dbo].[FactSales] s 
join [DW_Sample].[dbo].[DimDates] d ON s.orderdatekey = d.DateKey
GROUP BY d.datename



