

ALTER PROC findingMaxList 
(@bottom as DEC,
@top AS DEC,
@word AS varchar(max))
AS
BEGIN
SELECT
    product_name,
    list_price

FROM 
	production.products
WHERE list_price >= @bottom AND
	list_price <= @top AND
	product_name like '%' + @word + '%'

ORDER BY list_price
END


exec findingMaxList 900, 1000, 'Trek'

print char(10))