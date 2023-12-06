USE datawarehousesample
INSERT INTO [datawarehousesample].[dbo].[DimTitles]
(TitleId, TitleName, TitleType, PublisherKey, TitlePrice, PublishedDateKey)
SELECT
[TitleId]           = CAST(ISNULL([title_id], -1) AS nvarchar(12)),
[TitleName]         = CAST(ISNULL([title], 'Unknown') AS nvarchar(100)),
[TitleType]         = CASE CAST(ISNULL([type], 'Unknown') AS nvarchar(50))
                        WHEN 'business'     THEN N'Business'
                        WHEN 'mod_cook'     THEN N'Modern Cooking'
                        WHEN 'popular_comp' THEN N'Popular Computing'
                        WHEN 'psychology'   THEN N'Psychology'
                        WHEN 'trad_cook'    THEN N'Traditional Cooking'
                        WHEN 'UNDECIDED'    THEN N'Undecided'
                        END,
[PublisherKey]      = ISNULL([datawarehousesample].[dbo].[DimPublishers].[PublisherKey], -1),
[TitlePrice]        = CAST(ISNULL([price], -1) AS DECIMAL(18, 4)),
[PublishedDateKey]  = ISNULL([datawarehousesample].[dbo].[DimDates].[DateKey], -1)
FROM [Pubs].[dbo].[Titles] Join [datawarehousesample].[dbo].[DimPublishers]
ON [Pubs].[dbo].[Titles].[pub_id] = [datawarehousesample].[dbo].[DimPublishers].[PublisherId]
Left Join [datawarehousesample].[dbo].[DimDates]
ON [Pubs].[dbo].[Titles].[pubdate] = [datawarehousesample].[dbo].[DimDates].[Date]
--GO
SET IDENTITY_INSERT [datawarehousesample].[dbo].[DimTitles] ON
--GO
INSERT INTO [datawarehousesample].[dbo].[DimTitles]
(TitleKey, TitleID, TitleName, TitleType, PublisherKey, TitlePrice, PublishedDateKey)
SELECT -1, 'Unknown', 'Unknown', 'Unknown', -1, -1, -1
--GO
SET IDENTITY_INSERT [datawarehousesample].[dbo].[DimTitles] OFF
--go