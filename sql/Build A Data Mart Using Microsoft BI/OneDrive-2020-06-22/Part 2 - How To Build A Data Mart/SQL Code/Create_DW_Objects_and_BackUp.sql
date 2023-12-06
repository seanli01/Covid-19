/*
STEP 1
Check if the database we wish to create is already in place and if so
drop it and recreate it with files (log and data) located as per 
description above. Next, assign login SA (administrator) as the database 
owner and set the recovery model to BULKED_LOGGED.
*/
USE [master]
GO
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'DW_Sample')
BEGIN
-- Close connections to the DW_Sample database
ALTER DATABASE [DW_Sample] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
DROP DATABASE [DW_Sample]
END
GO
CREATE DATABASE [DW_Sample] ON PRIMARY
( NAME = N'DW_Sample'
, FILENAME = N'C:\DW_Sample_Files\DW_Sample.mdf'
, SIZE = 10MB
, MAXSIZE = 1GB
, FILEGROWTH = 10MB )
LOG ON
( NAME = N'DW_Sample_log'
, FILENAME = N'C:\DW_Sample_Files\DW_Sample_log.LDF'
, SIZE = 1MB
, MAXSIZE = 1GB
, FILEGROWTH = 10MB)
GO
--Assign database ownership to login SA
EXEC [DW_Sample].dbo.sp_changedbowner @loginame = N'SA', @map = false
GO
--Change the recovery model to BULK_LOGGED
ALTER DATABASE [DW_Sample] SET RECOVERY BULK_LOGGED
GO

/*
STEP 2
Create individual objects i.e. fact and dimension tables and create
foreign keys to establish referential integrity between individual tables
*/
USE [DW_Sample]
GO
--Create the Dimension Tables
CREATE TABLE [dbo].[DimStores](
[StoreKey] [int] NOT NULL PRIMARY KEY IDENTITY (1, 1),
[StoreId] [nchar](12) NOT NULL,
[StoreName] [nvarchar](50) NOT NULL,
[StoreAddress] [nvarchar] (80) NOT NULL,
[StoreCity] [nvarchar] (40) NOT NULL,
[StoreState] [nvarchar] (12) NOT NULL,
[StoreZip] [nvarchar] (12) NOT NULL,
[IsCurrent] [int] NOT NULL
)
GO
CREATE TABLE [dbo].[DimPublishers](
[PublisherKey] [int] NOT NULL PRIMARY KEY IDENTITY (1, 1),
[PublisherId] [nchar](12) NOT NULL,
[PublisherName] [nvarchar](50) NOT NULL
)
GO
CREATE TABLE [dbo].[DimDates](
[DateKey] int NOT NULL PRIMARY KEY IDENTITY (1, 1),
[Date] datetime NOT NULL,
[DateName] nVarchar(50),
[Month] int NOT NULL,
[MonthName] nVarchar(50) NOT NULL,
[Quarter] int NOT NULL,
[QuarterName] nVarchar(50) NOT NULL,
[Year] int NOT NULL,
[YearName] nVarchar(50) NOT NULL
)
GO
CREATE TABLE [dbo].[DimAuthors](
[AuthorKey] [int] NOT NULL PRIMARY KEY IDENTITY (1, 1),
[AuthorId] [nchar](12) NOT NULL,
[AuthorName] [nvarchar](100) NOT NULL,
[AuthorState] [nchar](12) NOT NULL
)
GO
CREATE TABLE [dbo].[DimTitles](
[TitleKey] [int] NOT NULL PRIMARY KEY IDENTITY (1, 1),
[TitleId] [nvarchar](12) NOT NULL,
[TitleName] [nvarchar](100) NOT NULL,
[TitleType] [nvarchar](50) NOT NULL,
[PublisherKey] [int] NOT NULL,
[TitlePrice] [decimal](18, 4) NOT NULL,
[PublishedDateKey] [int] NOT NULL
)
GO
--Create the Fact Tables
CREATE TABLE [dbo].[FactTitlesAuthors](
[TitleKey] [int] NOT NULL,
[AuthorKey] [int] NOT NULL,
[AuthorOrder] [int] NOT NULL,
CONSTRAINT [PK_FactTitlesAuthors] PRIMARY KEY CLUSTERED
( [TitleKey] ASC, [AuthorKey] ASC )
)
GO
CREATE TABLE [dbo].[FactSales](
[OrderNumber] [nvarchar](50) NOT NULL,
[OrderDateKey] [int] NOT NULL,
[TitleKey] [int] NOT NULL,
[StoreKey] [int] NOT NULL,
[SalesQuantity] [int] NOT NULL,
CONSTRAINT [PK_FactSales] PRIMARY KEY CLUSTERED
( [OrderNumber] ASC,[OrderDateKey] ASC, [TitleKey] ASC, [StoreKey] ASC )
)
GO
--Add Foreign Keys
ALTER TABLE [dbo].[DimTitles] WITH CHECK ADD CONSTRAINT [FK_DimTitles_DimPublishers]
FOREIGN KEY([PublisherKey]) REFERENCES [dbo].[DimPublishers] ([PublisherKey])
GO
ALTER TABLE [dbo].[FactTitlesAuthors] WITH CHECK ADD CONSTRAINT
[FK_FactTitlesAuthors_DimAuthors]
FOREIGN KEY([AuthorKey]) REFERENCES [dbo].[DimAuthors] ([AuthorKey])
GO
ALTER TABLE [dbo].[FactTitlesAuthors] WITH CHECK ADD CONSTRAINT
[FK_FactTitlesAuthors_DimTitles]
FOREIGN KEY([TitleKey]) REFERENCES [dbo].[DimTitles] ([TitleKey])
GO
ALTER TABLE [dbo].[FactSales] WITH CHECK ADD CONSTRAINT [FK_FactSales_DimStores]
FOREIGN KEY([StoreKey]) REFERENCES [dbo].[DimStores] ([Storekey])
GO
ALTER TABLE [dbo].[FactSales] WITH CHECK ADD CONSTRAINT [FK_FactSales_DimTitles]
FOREIGN KEY([TitleKey]) REFERENCES [dbo].[DimTitles] ([TitleKey])
GO
ALTER TABLE [dbo].[FactSales] WITH CHECK ADD CONSTRAINT [FK_FactSales_DimDates]
FOREIGN KEY([OrderDateKey]) REFERENCES [dbo].[DimDates] ([DateKey])
GO
ALTER TABLE [dbo].[DimTitles] WITH CHECK ADD CONSTRAINT [FK_DimTitles_DimDates]
FOREIGN KEY([PublishedDateKey]) REFERENCES [dbo].[DimDates] ([DateKey])
GO

/*
STEP 3
Back up new database to disk placing the file in the directory nominated
and restore database using the back up file replacing the one already created
with the backed up one
*/
BACKUP DATABASE [DW_Sample]
TO DISK =
N'C:\DW_Sample_Files\DW_Sample_BackUp\DW_Sample.bak'
GO
USE [Master]
RESTORE DATABASE [DW_Sample]
FROM DISK =
N'C:\DW_Sample_Files\DW_Sample_BackUp\DW_Sample.bak'
WITH REPLACE
GO
ALTER DATABASE [DW_Sample] 
SET MULTI_USER