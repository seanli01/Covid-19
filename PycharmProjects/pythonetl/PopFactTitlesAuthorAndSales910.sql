USE datawarehousesample
INSERT INTO [datawarehousesample].[dbo].[FactTitlesAuthors]
(TitleKey, AuthorKey, AuthorOrder)
SELECT
[TitleKey]      = ISNULL(titles.TitleKey, -1),
[AuthorKey]     = ISNULL(authors.AuthorKey, -1),
[AuthorOrder]   = au_ord
FROM pubs.dbo.titleauthor AS titleauthor
JOIN datawarehousesample.dbo.DimTitles AS titles
ON titleauthor.Title_id = titles.TitleId
JOIN datawarehousesample.dbo.DimAuthors AS authors
ON titleauthor.Au_id = authors.AuthorId
WHERE NOT EXISTS    (SELECT TOP 1 'I already exist' FROM
                    [datawarehousesample].[dbo].[FactTitlesAuthors] fact
                    WHERE fact.AuthorKey    = authors.AuthorKey
                    AND fact.TitleKey       = titles.TitleKey)



INSERT INTO [datawarehousesample].[dbo].[FactSales]
(OrderNumber, OrderDateKey, TitleKey, StoreKey, SalesQuantity)
SELECT
[OrderNumber]   = CAST(sales.ord_num AS nvarchar(50)),
[OrderDateKey]  = ISNULL(dates.DateKey, -1),
[TitleKey]      = ISNULL(titles.TitleKey, -1),
[StoreKey]      = ISNULL(stores.StoreKey, -1),
[SalesQuantity] = sales.Qty
FROM pubs.dbo.sales AS sales
JOIN datawarehousesample.dbo.DimDates AS dates
ON sales.ord_date = dates.[date]
JOIN datawarehousesample.dbo.DimTitles AS titles
ON sales.Title_id = titles.TitleId
JOIN datawarehousesample.dbo.DimStores AS stores
ON sales.Stor_id = stores.StoreId
WHERE NOT EXISTS    (SELECT TOP 1 'I already exist' FROM
                    [datawarehousesample].[dbo].[FactSales] as fact
                    WHERE sales.ord_num = fact.OrderNumber
                    AND dates.DateKey   = fact.OrderDateKey
                    AND titles.TitleKey = fact.TitleKey
                    AND stores.StoreKey = fact.StoreKey)