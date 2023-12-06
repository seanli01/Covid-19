DECLARE @counter INT =2

WHILE @counter >0
	BEGIN
	SET @counter = @counter -1
	print @counter
	END