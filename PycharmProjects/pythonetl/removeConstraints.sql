
use datawarehousesample
--dropping foreign keys
alter table [dbo].[DimTitles] drop constraint [FK_DimTitles_DimDates]
alter table [dbo].[DimTitles] drop constraint [FK_DimTitles_DimPublishers]
alter table [dbo].[FactSales] drop constraint [FK_FactSales_DimDates]
alter table [dbo].[FactSales] drop constraint [FK_FactSales_DimStores]
alter table [dbo].[FactSales] drop constraint [FK_FactSales_DimTitles]
alter table [dbo].[FactTitlesAuthors] drop constraint [FK_FactTitlesAuthors_DimAuthors]
alter table [dbo].[FactTitlesAuthors] drop constraint [FK_FactTitlesAuthors_DimTitles]






