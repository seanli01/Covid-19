/*
STEP 1
Drop foreign key constraints
*/
USE DW_Sample
--DROP FOREIGN KEYS
ALTER TABLE [dbo].[DimTitles] DROP CONSTRAINT [FK_DimTitles_DimPublishers]
ALTER TABLE [dbo].[FactTitlesAuthors] DROP CONSTRAINT [FK_FactTitlesAuthors_DimAuthors]
ALTER TABLE [dbo].[FactTitlesAuthors] DROP CONSTRAINT [FK_FactTitlesAuthors_DimTitles]
ALTER TABLE [dbo].[FactSales] DROP CONSTRAINT [FK_FactSales_DimStores]
ALTER TABLE [dbo].[FactSales] DROP CONSTRAINT [FK_FactSales_DimTitles]
ALTER TABLE [dbo].[FactSales] DROP CONSTRAINT [FK_FactSales_DimDates]
ALTER TABLE [dbo].[DimTitles] DROP CONSTRAINT [FK_DimTitles_DimDates]
GO

/*
STEP 2
Truncate all data mart tables
*/
--DELETE FROM ALL TABLES WITHOUT RESETTING THEIR IDENTITY AUTO NUMBER
--DELETE FROM [dbo].[FactSales]
--DELETE FROM [dbo].[FactTitlesAuthors]
--DELETE FROM [dbo].[DimTitles]
--DELETE FROM [dbo].[DimPublishers]
--DELETE FROM [dbo].[DimStores]
--DELETE FROM [dbo].[DimAuthors]
--DELETE FROM [dbo].[DimDates]
--TRUNCATE ALL TABLES AND RESET THEIR IDENTITY AUTO NUMBER

USE DW_Sample
TRUNCATE TABLE [dbo].[FactSales]
TRUNCATE TABLE [dbo].[FactTitlesAuthors]
TRUNCATE TABLE [dbo].[DimTitles]
TRUNCATE TABLE [dbo].[DimPublishers]
TRUNCATE TABLE [dbo].[DimStores]
TRUNCATE TABLE [dbo].[DimAuthors]
TRUNCATE TABLE [dbo].[DimDates]
GO



/*
STEP 3
Populate DimDates table with date and its derrived values data
*/
--DECLARE DATE VARIABLES FOR DATE PERIOD
DECLARE @StartDate datetime	= '01/01/1990'
DECLARE @EndDate datetime	= '01/01/1995'
DECLARE @DateInProcess datetime
SET @DateInProcess		= @StartDate
WHILE @DateInProcess	< = @EndDate
BEGIN
	SET NOCOUNT ON
--LOOP THROUGH INDIVIDUAL DATES DEFINED BY TIME PERIOD
		INSERT INTO DimDates (
		[Date],
		[DATENAME],
		[Month],
		[MonthName],
		[QUARTER],
		[QUARTERName],
		[YEAR],
		[YEARName])
		VALUES (
		@DateInProcess,
		CONVERT(varchar(50), @DateInProcess, 110) + ', ' + DATENAME(WEEKDAY, @DateInProcess ),
		MONTH( @DateInProcess),
		CAST(YEAR(@DateInProcess) as nvarchar(4)) + ' - ' + DATENAME(MONTH, @DateInProcess ), 
		DATENAME( QUARTER, @DateInProcess ),
		Cast(YEAR(@DateInProcess) as nvarchar(4)) + ' - ' + 'Q' + DATENAME(QUARTER, @DateInProcess ),
		YEAR(@DateInProcess),
		Cast(YEAR(@DateInProcess) as nvarchar(4)))
	SET @DateInProcess = DATEADD(DAY, 1, @DateInProcess)
END



/*
STEP 4
Append Unknown values to DimDates table 
*/
SET IDENTITY_INSERT [DW_Sample].[dbo].[DimDates] ON
GO
Insert Into [DW_Sample].[dbo].[DimDates]
([DateKey],
[Date],
[DateName],
[Month],
[MonthName],
[Quarter],
[QuarterName],
[Year], [YearName])
SELECT
[DateKey]		= -1,
[Date]			= CAST( '01/01/1900' as nvarchar(50)),
[DateName]		= CAST('Unknown_Day' as nvarchar(50)),
[Month]			= -1,
[MonthName]		= CAST('Unknown_Month' as nvarchar(50)),
[Quarter]		= -1,
[QuarterName]	= CAST('Unknown_Quarter' as nvarchar(50)),
[Year]			= -1,
[YearName]		= CAST('Unknown_Year' as nvarchar(50))
GO
SET IDENTITY_INSERT [DW_Sample].[dbo].[DimDates] OFF
GO



/*
STEP 5
Populate DimAuthors dimensions with source data
*/
INSERT INTO [DW_Sample].[dbo].[DimAuthors]
(AuthorId, AuthorName, AuthorState)
SELECT
[AuthorId]		= CAST(au_id as nchar(12)),
[AuthorName]	= CAST((au_fname + ' ' + au_lname) as nvarchar(100)),
[AuthorState]	= CAST(state as nchar(12))
FROM Pubs.dbo.Authors
GO
SET IDENTITY_INSERT [DW_Sample].[dbo].[DimAuthors] ON
GO
INSERT INTO [DW_Sample].[dbo].[DimAuthors]
(AuthorKey, AuthorID, AuthorName, AuthorState)
SELECT -1, 'Unknown', 'Unknown', 'Unknown'
GO
SET IDENTITY_INSERT [DW_Sample].[dbo].[DimAuthors] OFF
GO



/*
STEP 6
Populate DimPublishers dimension with source data
*/
INSERT INTO [DW_Sample].[dbo].[DimPublishers]
(PublisherId, PublisherName)
SELECT
[PublisherId]	= CAST(pub_id as nchar(12)),
[PublisherName] = CAST(pub_name as nvarchar(50))
FROM pubs.dbo.publishers
GO
SET IDENTITY_INSERT [DW_Sample].[dbo].[DimPublishers] ON
GO
INSERT INTO [DW_Sample].[dbo].[DimPublishers]
(PublisherKey, PublisherId, PublisherName)
SELECT -1, 'Unknown', 'Unknown'
GO
SET IDENTITY_INSERT [DW_Sample].[dbo].[DimPublishers] OFF
GO



/*
STEP 7
Populate DimTitles dimension with source data
*/
INSERT INTO [DW_Sample].[dbo].[DimTitles]
(TitleId, TitleName, TitleType, PublisherKey, TitlePrice, PublishedDateKey)
SELECT
[TitleId]			= CAST(ISNULL([title_id], -1) AS nvarchar(12)),
[TitleName]			= CAST(ISNULL([title], 'Unknown') AS nvarchar(100)),
[TitleType]			= CASE CAST(ISNULL([type], 'Unknown') AS nvarchar(50))
						WHEN 'business'		THEN N'Business'
						WHEN 'mod_cook'		THEN N'Modern Cooking'
						WHEN 'popular_comp' THEN N'Popular Computing'
						WHEN 'psychology'	THEN N'Psychology'
						WHEN 'trad_cook'	THEN N'Traditional Cooking'
						WHEN 'UNDECIDED'	THEN N'Undecided'
						END, 
[PublisherKey]		= ISNULL([DW_Sample].[dbo].[DimPublishers].[PublisherKey], -1),
[TitlePrice]		= CAST(ISNULL([price], -1) AS DECIMAL(18, 4)),
[PublishedDateKey]	= ISNULL([DW_Sample].[dbo].[DimDates].[DateKey], -1)
FROM [Pubs].[dbo].[Titles] Join [DW_Sample].[dbo].[DimPublishers]
ON [Pubs].[dbo].[Titles].[pub_id] = [DW_Sample].[dbo].[DimPublishers].[PublisherId]
Left Join [DW_Sample].[dbo].[DimDates] 
ON [Pubs].[dbo].[Titles].[pubdate] = [DW_Sample].[dbo].[DimDates].[Date]
GO
SET IDENTITY_INSERT [DW_Sample].[dbo].[DimTitles] ON
GO
INSERT INTO [DW_Sample].[dbo].[DimTitles]
(TitleKey, TitleID, TitleName, TitleType, PublisherKey, TitlePrice, PublishedDateKey)
SELECT -1, 'Unknown', 'Unknown', 'Unknown', -1, -1, -1
GO
SET IDENTITY_INSERT [DW_Sample].[dbo].[DimTitles] OFF
GO




/*
STEP 8
Populate DimStores dimension table with source data assuming that some attributes
have been defined as either Type 1 or Type 2 Slowly Changing Dimensions
*/
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
GO

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

BEGIN
	IF EXISTS (SELECT 1 FROM [DW_Sample].[dbo].[DimStores] WHERE StoreKey = -1)
		BEGIN
			RETURN
		END
	ELSE
		BEGIN
		SET IDENTITY_INSERT [DW_Sample].[dbo].[DimStores] ON
		INSERT INTO [DW_Sample].[dbo].[DimStores]
		(StoreKey, StoreID, StoreName, StoreAddress, StoreCity, StoreState, StoreZip, IsCurrent)
		SELECT -1, 'Unknown', 'Unknown', 'Unknown', 'Unknown', 'Unknown', 'Unknown',-1
		SET IDENTITY_INSERT [DW_Sample].[dbo].[DimStores] OFF
		END
END



/*
STEP 9
Populate FactTitlesAuthors fact table with source data assuming that
if historical load has already been run, only new values should be inserted. 
*/
INSERT INTO [DW_Sample].[dbo].[FactTitlesAuthors]
(TitleKey, AuthorKey, AuthorOrder)
SELECT
[TitleKey]		= ISNULL(titles.TitleKey, -1),
[AuthorKey]		= ISNULL(authors.AuthorKey, -1),
[AuthorOrder]	= au_ord
FROM pubs.dbo.titleauthor AS titleauthor
JOIN DW_Sample.dbo.DimTitles AS titles
ON titleauthor.Title_id = titles.TitleId
JOIN DW_Sample.dbo.DimAuthors AS authors
ON titleauthor.Au_id = authors.AuthorId
WHERE NOT EXISTS	(SELECT TOP 1 'I already exist' FROM
					[DW_Sample].[dbo].[FactTitlesAuthors] fact
					WHERE fact.AuthorKey	= authors.AuthorKey
					AND fact.TitleKey		= titles.TitleKey)




/*
STEP 10
Populate FactSales fact table with source data assuming that
if historical load has already been run, only new values should be inserted. 
*/
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



/*
STEP 11
Recreate all foreign key constraints 
*/
ALTER TABLE [dbo].[DimTitles] WITH CHECK ADD CONSTRAINT [FK_DimTitles_DimPublishers]
FOREIGN KEY ([PublisherKey]) REFERENCES [dbo].[DimPublishers] ([PublisherKey])
ALTER TABLE [dbo].[FactTitlesAuthors] WITH CHECK ADD CONSTRAINT [FK_FactTitlesAuthors_DimAuthors]
FOREIGN KEY ([AuthorKey]) REFERENCES [dbo].[DimAuthors] ([AuthorKey])
ALTER TABLE [dbo].[FactTitlesAuthors] WITH CHECK ADD CONSTRAINT [FK_FactTitlesAuthors_DimTitles]
FOREIGN KEY ([TitleKey]) REFERENCES [dbo].[DimTitles] ([TitleKey])
ALTER TABLE [dbo].[FactSales] WITH CHECK ADD CONSTRAINT [FK_FactSales_DimStores]
FOREIGN KEY ([StoreKey]) REFERENCES [dbo].[DimStores] ([Storekey])
ALTER TABLE [dbo].[FactSales] WITH CHECK ADD CONSTRAINT [FK_FactSales_DimTitles]
FOREIGN KEY ([TitleKey]) REFERENCES [dbo].[DimTitles] ([TitleKey])
ALTER TABLE [dbo].[FactSales] WITH CHECK ADD CONSTRAINT [FK_FactSales_DimDates]
FOREIGN KEY([OrderDateKey]) REFERENCES [dbo].[DimDates] ([DateKey])
ALTER TABLE [dbo].[DimTitles] WITH CHECK ADD CONSTRAINT [FK_DimTitles_DimDates]
FOREIGN KEY([PublishedDateKey]) REFERENCES [dbo].[DimDates] ([DateKey])

