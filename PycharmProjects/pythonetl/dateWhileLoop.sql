use datawarehousesample

declare @start_year datetime = '01/01/1990'
declare @end_year datetime = '01/01/1995'

declare @ongoing_date datetime

set @ongoing_date = @start_year
SELECT CONVERT(varchar(50), @ongoing_date, 110) + ', ' + DATENAME(WEEKDAY, @ongoing_date )

WHILE @ongoing_date <= @end_year

BEGIN

	SET nocount on
	insert into DimDates(
	[Date],
	[DateName],
	[Month],
	[MonthName],
	[Quarter],
	[QuarterName],
	[Year],
	[YearName]
	)
	VALUES(
	@ongoing_date,
	CONVERT(varchar(50), @ongoing_date, 110)+ ', ' + DATENAME(WEEKDAY, @ongoing_date),
	MONTH(@ongoing_date),
	CAST(YEAR(@ongoing_date) as varchar(4)) + ' - ' + DATENAME(MONTH, @ongoing_date),
	DATENAME(QUARTER, @ongoing_date),
	CAST(YEAR(@ongoing_date) as varchar(4)) + ' - ' + 'QUARTER:' + DATENAME(QUARTER, @ongoing_date),
	YEAR(@ongoing_date),
	DATENAME(YEAR, @ongoing_date)
	)

	SET @ongoing_date = DATEADD(DAY,1, @ongoing_date)
END













