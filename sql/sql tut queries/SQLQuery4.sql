alter proc getproductlist(@year as int)
AS
Begin
Declare @productlist as varchar(max)
SET @productlist =' '

SELECt
	@productlist =@productlist + product_name + char(10)

FROM production.products

WHERE 
	model_year = @year
order by product_name
--PRINT @productlist
select @productlist
END

exec getproductlist 2018