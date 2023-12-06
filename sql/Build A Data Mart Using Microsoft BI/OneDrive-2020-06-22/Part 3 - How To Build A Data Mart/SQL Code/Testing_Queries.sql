/*
TESTING QUERY 1
Show how to reference/look up dimension value to account for NULLs 
*/
SELECT
[Pubs].[dbo].[Sales].qty,
[Order_Date_Key] = ISNULL([DW_Sample].[dbo].[DimDates].[DateKey], -1)
FROM [Pubs].[dbo].[Sales]
LEFT JOIN [DW_Sample].[dbo].[DimDates] 
ON [Pubs].[dbo].[Sales].[ord_date] = [DW_Sample].[dbo].[DimDates].[Date]



/*
TESTING QUERY 2
Show how a combination of MERGE and UPDATE will work with SCD 1 and SCD 2 dimensions
*/
BEGIN
BEGIN TRANSACTION
	USE Pubs
	UPDATE [pubs].[dbo].[stores]
	SET Stor_Name = 'New Store Name'
	WHERE stor_id = 7067
	UPDATE [pubs].[dbo].[stores]
	SET stor_address = 'New Store Address'
	WHERE stor_id = 6380
	UPDATE [pubs].[dbo].[stores]
	SET zip = '00000'
	WHERE stor_id = 7131
	
	USE DW_Sample
	INSERT INTO [DW_Sample].[dbo].[DimStores]
	(StoreID, StoreName, StoreAddress, StoreCity, StoreState, StoreZip, IsCurrent)
	SELECT
	StoreID, StoreName, StoreAddress, StoreCity, StoreState, StoreZip, 1
	FROM
		(MERGE DimStores AS Target
			USING
				(SELECT
				[StoreId]		= CAST(stor_id as nchar(12)),
				[StoreName]		= CAST(stor_name as nvarchar(50)),
				[StoreAddress]	= CAST(stor_address as nvarchar (80)),
				[StoreCity]		= CAST(city as nvarchar (40)),
				[StoreState]	= CAST(state as nvarchar (12)),
				[StoreZip]		= CAST(zip as nvarchar (12))

				FROM Pubs.dbo.Stores)
				AS [Source]
						ON Target.StoreID = Source.StoreID AND Target.IsCurrent = 1
						WHEN MATCHED AND
				(Target.StoreName <> [Source].StoreName)
					THEN UPDATE SET
					IsCurrent = 0
		WHEN NOT MATCHED BY TARGET
				THEN INSERT
				(StoreID, StoreName, StoreAddress, StoreCity, StoreState, StoreZip, IsCurrent) 
				VALUES
				([Source].StoreID,
				[Source].StoreName,
				[Source].StoreAddress,
				[Source].StoreCity,
				[Source].StoreState,
				[Source].StoreZip,
				1)
		WHEN NOT MATCHED BY SOURCE AND Target.IsCurrent = 1
				THEN UPDATE
				SET IsCurrent = 0
		OUTPUT $action as Action,[Source].*) AS MergeOutput
	WHERE MergeOutput.Action = 'UPDATE'
	AND StoreName IS NOT NULL

	UPDATE [DW_Sample].[dbo].[DimStores] 
	SET StoreAddress = source.stor_address
	FROM dimstores target INNER JOIN Pubs.dbo.Stores source 
	ON target.StoreId = source.stor_id
	AND target.storeaddress <> source.stor_address
	AND target.IsCurrent = 1 

	UPDATE [DW_Sample].[dbo].[DimStores] 
	SET StoreCity = source.city
	FROM dimstores target INNER JOIN Pubs.dbo.Stores source 
	ON target.StoreId = source.stor_id
	AND target.storecity <> source.city
	AND target.IsCurrent = 1 

	UPDATE [DW_Sample].[dbo].[DimStores] 
	SET StoreState = source.State
	FROM dimstores target INNER JOIN Pubs.dbo.Stores source 
	ON target.StoreId = source.stor_id
	AND target.storeState <> source.state
	AND target.IsCurrent = 1 

	UPDATE [DW_Sample].[dbo].[DimStores] 
	SET StoreZip = source.Zip
	FROM dimstores target INNER JOIN Pubs.dbo.Stores source 
	ON target.StoreId = source.stor_id
	AND target.StoreZip <> source.Zip
	AND target.IsCurrent = 1
	
	SELECT * FROM [DW_Sample].[dbo].[DimStores]
ROLLBACK TRANSACTION
END



/*
TESTING QUERY 3
Show how NOT EXISTS will work to prevent duplicate data being inserted in fact table
*/
BEGIN
BEGIN TRANSACTION
USE pubs
	INSERT INTO sales
	(stor_id, ord_num, ord_date, qty, payterms, title_id)
	SELECT
	'7066', 'ZZZ999', '1994-09-14', 1, 'Net 30', 'PS2091'
	SELECT * FROM sales WHERE ord_num = 'ZZZ999'
	
	DECLARE @CountOfInserts int = 0
	DECLARE @RowsAffected int = 0
	WHILE @CountOfInserts < 2
		BEGIN
			INSERT INTO [DW_Sample].[dbo].[FactSales]
			(OrderNumber, OrderDateKey, TitleKey, StoreKey, SalesQuantity)
			SELECT
			[OrderNumber]	= CAST(sales.ord_num AS nvarchar(50)),
			[OrderDateKey]	= ISNULL(dates.DateKey, -1),
			[TitleKey]		= ISNULL(titles.TitleKey, -1),
			[StoreKey]		= ISNULL(stores.StoreKey, -1),
			[SalesQuantity] = sales.Qty
			FROM pubs.dbo.sales AS sales
			JOIN DW_Sample.dbo.DimDates AS dates
			ON sales.ord_date = dates.[date]
			JOIN DW_Sample.dbo.DimTitles AS titles
			ON sales.Title_id = titles.TitleId
			JOIN DW_Sample.dbo.DimStores AS stores
			ON sales.Stor_id = stores.StoreId
			WHERE NOT EXISTS	(SELECT TOP 1 'I already exist' FROM 
								[DW_Sample].[dbo].[FactSales] as fact
								WHERE sales.ord_num	= fact.OrderNumber
								AND dates.DateKey	= fact.OrderDateKey
								AND titles.TitleKey = fact.TitleKey
								AND stores.StoreKey = fact.StoreKey)
			SET @RowsAffected = @@ROWCOUNT
			
			SELECT 'Pass number' + ' ' + CAST(@CountOfInserts + 1 as varchar (10)) + '. ' + 
			'Number of records affected = ' + CAST(@RowsAffected as varchar (10)) 
			FROM [DW_Sample].[dbo].[FactSales] WHERE OrderNumber = 'ZZZ999'
			SET @CountOfInserts = @CountOfInserts + 1
	END
ROLLBACK TRANSACTION
END



