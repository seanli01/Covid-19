USE datawarehousesample
INSERT INTO [datawarehousesample].[dbo].[DimPublishers]
(PublisherId, PublisherName)
SELECT
[PublisherId]   = CAST(pub_id as nchar(12)),
[PublisherName] = CAST(pub_name as nvarchar(50))
FROM pubs.dbo.publishers
--GO
SET IDENTITY_INSERT [datawarehousesample].[dbo].[DimPublishers] ON
--GO
INSERT INTO [datawarehousesample].[dbo].[DimPublishers]
(PublisherKey, PublisherId, PublisherName)
SELECT -1, 'Unknown', 'Unknown'
--GO
SET IDENTITY_INSERT [datawarehousesample].[dbo].[DimPublishers] OFF
--GO