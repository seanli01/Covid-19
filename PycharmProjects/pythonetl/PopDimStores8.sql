USE datawarehousesample
INSERT INTO [datawarehousesample].[dbo].[DimStores]
(StoreID, StoreName, StoreAddress, StoreCity, StoreState, StoreZip, IsCurrent)
SELECT
StoreID, StoreName, StoreAddress, StoreCity, StoreState, StoreZip, 1
FROM
    (MERGE DimStores AS Target
        USING
            (SELECT
            [StoreId]       = CAST(stor_id as nchar(12)),
            [StoreName]     = CAST(stor_name as nvarchar(50)),
            [StoreAddress]  = CAST(stor_address as nvarchar (80)),
            [StoreCity]     = CAST(city as nvarchar (40)),
            [StoreState]    = CAST(state as nvarchar (12)),
            [StoreZip]      = CAST(zip as nvarchar (12))
 
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
--GO
 
UPDATE [datawarehousesample].[dbo].[DimStores]
SET StoreAddress = source.stor_address
FROM dimstores target INNER JOIN Pubs.dbo.Stores source
ON target.StoreId = source.stor_id
AND target.storeaddress <> source.stor_address
AND target.IsCurrent = 1
 
UPDATE [datawarehousesample].[dbo].[DimStores]
SET StoreCity = source.city
FROM dimstores target INNER JOIN Pubs.dbo.Stores source
ON target.StoreId = source.stor_id
AND target.storecity <> source.city
AND target.IsCurrent = 1
 
UPDATE [datawarehousesample].[dbo].[DimStores]
SET StoreState = source.State
FROM dimstores target INNER JOIN Pubs.dbo.Stores source
ON target.StoreId = source.stor_id
AND target.storeState <> source.state
AND target.IsCurrent = 1
 
UPDATE [datawarehousesample].[dbo].[DimStores]
SET StoreZip = source.Zip
FROM dimstores target INNER JOIN Pubs.dbo.Stores source
ON target.StoreId = source.stor_id
AND target.StoreZip <> source.Zip
AND target.IsCurrent = 1
 
BEGIN
    IF EXISTS (SELECT 1 FROM [datawarehousesample].[dbo].[DimStores] WHERE StoreKey = -1)
        BEGIN
            RETURN
        END
    ELSE
        BEGIN
        SET IDENTITY_INSERT [DW_Sample].[dbo].[DimStores] ON
        INSERT INTO [datawarehousesample].[dbo].[DimStores]
        (StoreKey, StoreID, StoreName, StoreAddress, StoreCity, StoreState, StoreZip, IsCurrent)
        SELECT -1, 'Unknown', 'Unknown', 'Unknown', 'Unknown', 'Unknown', 'Unknown',-1
        SET IDENTITY_INSERT [DW_Sample].[dbo].[DimStores] OFF
        END
END


USE datawarehousesample
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
 
    USE datawarehousesample
    INSERT INTO [datawarehousesample].[dbo].[DimStores]
    (StoreID, StoreName, StoreAddress, StoreCity, StoreState, StoreZip, IsCurrent)
    SELECT
    StoreID, StoreName, StoreAddress, StoreCity, StoreState, StoreZip, 1
    FROM
        (MERGE DimStores AS Target
            USING
                (SELECT
                [StoreId]       = CAST(stor_id as nchar(12)),
                [StoreName]     = CAST(stor_name as nvarchar(50)),
                [StoreAddress]  = CAST(stor_address as nvarchar (80)),
                [StoreCity]     = CAST(city as nvarchar (40)),
                [StoreState]    = CAST(state as nvarchar (12)),
                [StoreZip]      = CAST(zip as nvarchar (12))
 
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
 
    UPDATE [datawarehousesample].[dbo].[DimStores]
    SET StoreAddress = source.stor_address
    FROM dimstores target INNER JOIN Pubs.dbo.Stores source
    ON target.StoreId = source.stor_id
    AND target.storeaddress <> source.stor_address
    AND target.IsCurrent = 1
 
    UPDATE [datawarehousesample].[dbo].[DimStores]
    SET StoreCity = source.city
    FROM dimstores target INNER JOIN Pubs.dbo.Stores source
    ON target.StoreId = source.stor_id
    AND target.storecity <> source.city
    AND target.IsCurrent = 1
 
    UPDATE [datawarehousesample].[dbo].[DimStores]
    SET StoreState = source.State
    FROM dimstores target INNER JOIN Pubs.dbo.Stores source
    ON target.StoreId = source.stor_id
    AND target.storeState <> source.state
    AND target.IsCurrent = 1
 
    UPDATE [datawarehousesample].[dbo].[DimStores]
    SET StoreZip = source.Zip
    FROM dimstores target INNER JOIN Pubs.dbo.Stores source
    ON target.StoreId = source.stor_id
    AND target.StoreZip <> source.Zip
    AND target.IsCurrent = 1
 
    SELECT * FROM [datawarehousesample].[dbo].[DimStores]
ROLLBACK TRANSACTION
END