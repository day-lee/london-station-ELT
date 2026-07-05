with filled_lu_traffic as (
select
	tsatc.mode,
	tsatc.station_name,
	tsatc.coverage,
-- fill the missing annualised traffic for LU stations with LO stations
	round(case when tsatc.coverage = '---see LO---' then tsatc2.annualised
else tsatc.annualised end)::integer as annualised
from
	tfl_station_annual_traffic_cleaned tsatc
left join tfl_station_annual_traffic_cleaned tsatc2  
on
	tsatc.station_name = tsatc2.station_name
	and tsatc2.mode = 'LO'
where
	tsatc.mode = 'LU'
),
-- notice there is no 'with' in the second CTE, because it is already defined in the first CTE
lu_ranked_traffic as (
select
-- window function to rank the stations by annualised traffic, partitioned by mode
	row_number() over(partition by mode order by annualised desc nulls last) as rank,
	mode,
	station_name,
	annualised as "Annualised_En/Ex"
from
	filled_lu_traffic
)

-- top 10 London Underground(LU) stations by annualised traffic
select
	*
from
	lu_ranked_traffic
limit 10;
