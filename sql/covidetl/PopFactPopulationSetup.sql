

if OBJECT_ID('tempdb..#tempFact') is not null
	drop table #tempFact


select
Population_Year [Year],
location CountryKey,
Population

into #tempFact
from stg_source_pop

merge #tempFact t using DimCountry s
on (t.CountryKey = s.CountryName)

when matched then update set
	t.CountryKey = s.CountryKey;





INSERT INTO [covid].[dbo].FactPopulation (Year, CountryKey, Population)
select Year, CountryKey, Population
from #tempFact 