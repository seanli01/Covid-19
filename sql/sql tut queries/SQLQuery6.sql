declare @counter int  =1


WHILE @counter <> 6
begin
	print @counter
	set @counter = @counter +1
	end


select 
	product_name,
	list_price
from 
production.products


DECLARE @name  varchar(max),
@listprice  decimal

DECLARE test CURSOR
for  
select 
	product_name,
	list_price
from 
production.products

OPEN test
fetch next from test into 

@name,
@listprice

WHILE @@FETCH_STATUS = 0 
	BEGIN
	print @name + CAST(@listprice as varchar)
	fetch next from test into
	@name,
	@listprice
	END

DEALLOCATE test