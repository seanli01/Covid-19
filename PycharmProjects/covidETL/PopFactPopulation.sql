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


merge FactPopulation t using #tempFact s
on (t.[Year] = s.[Year] and t.CountryKey =s.CountryKey)

when matched then update set
	t.Population = s.Population

when not matched by target
	then insert ([Year], CountryKey, Population)
	values (s.[Year], s.CountryKey, s.Population);

	--select * from FactPopulation
	--truncate table FactPopulation