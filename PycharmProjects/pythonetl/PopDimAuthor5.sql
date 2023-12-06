USE datawarehousesample
INSERT INTO [datawarehousesample].[dbo].[DimAuthors]
(AuthorId, AuthorName, AuthorState)
SELECT
[AuthorId]      = CAST(au_id as nchar(12)),
[AuthorName]    = CAST((au_fname + ' ' + au_lname) as nvarchar(100)),
[AuthorState]   = CAST(state as nchar(12))
FROM Pubs.dbo.Authors
--GO
SET IDENTITY_INSERT [datawarehousesample].[dbo].[DimAuthors] ON
--GO
INSERT INTO [datawarehousesample].[dbo].[DimAuthors]
(AuthorKey, AuthorID, AuthorName, AuthorState)
SELECT -1, 'Unknown', 'Unknown', 'Unknown'
--GO
SET IDENTITY_INSERT [datawarehousesample].[dbo].[DimAuthors] OFF
--GO