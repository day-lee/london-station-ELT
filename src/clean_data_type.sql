create table tfl_station_annual_traffic_cleaned as 
select 
mode,
mnlc,
masc, 
station_name,
coverage,
source, 
-- convert string to numeric, replace '---' with null, remove comma
replace(nullif(entry_mon, '---'), ',','')::numeric as entry_mon,
replace(nullif(entry_midweek_tue_thu, '---'), ',', '')::numeric as entry_midweek_tue_thu,
replace(nullif(entry_fri, '---'), ',','')::numeric as entry_fri,
replace(nullif(entry_sat, '---'),',','')::numeric as entry_sat,
replace(nullif(entry_sun, '---'), ',','')::numeric as entry_sun,
replace(nullif(exit_mon, '---'), ',','')::numeric as exit_mon,
replace(nullif(exit_midweek_tue_thu, '---'), ',', '')::numeric as exit_midweek_tue_thu,
replace(nullif(exit_fri, '---'), ',', '')::numeric as exit_fri,
replace(nullif(exit_sat, '---'), ',', '')::numeric as exit_sat,
replace(nullif(exit_sun, '---'), ',', '')::numeric as exit_sun,
replace(nullif(weekly,'---'), ',', '')::numeric as weekly, 
-- string hypon can cause problem, use "" to state the column name
REPLACE(NULLIF("12-week", '---'), ',', '')::NUMERIC AS "12-week",
replace(nullif(annualised, '---'), ',', '')::numeric as annualised,
-- convert data_year to date type
(data_year::text || '-01-01')::date as year_date 
from tfl_station_annual_traffic_raw 

--drop table tfl_station_annual_traffic_cleaned 