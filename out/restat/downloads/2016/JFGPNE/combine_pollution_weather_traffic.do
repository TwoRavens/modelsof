#delimit;
** REPLACE FILE PATH WITH PATH TO RELEVANT REPLICATION FILES;
local fileloc = "~/KMS_REPLICATION";
set logtype text;
capture log close combine_pwt;

log using `fileloc'/log_files/combine_pollution_weather_traffic.txt, name(combine_pwt) replace;
set more off;
clear all;

**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
**XXXXXX COMBINING TRAFFIC, POLLUTION, BIRTH, AND WEATHER DATA SETS XXXXXXX
**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;

use `fileloc'/data/weather_data/20mile_weather_KMS.dta, clear;

joinby mother_zip week using `fileloc'/data/emissions_data/20mile_pollution_KMS.dta;

joinby mother_zip week using `fileloc'/data/traffic_data/dta_files/5mile_traffic.dta, unmatched(master);

drop _merge;

joinby mother_zip week using `fileloc'/data/traffic_data/dta_files/10mile_traffic.dta, unmatched(master);

drop _merge;

joinby mother_zip week using `fileloc'/data/traffic_data/dta_files/15mile_traffic.dta, unmatched(master);

drop _merge;

joinby mother_zip week using `fileloc'/data/traffic_data/dta_files/20mile_traffic.dta, unmatched(master);

drop _merge;

** Remove those with no traffic data;
egen rowsum = rowtotal(flow*);
drop if rowsum == 0;
drop rowsum;

** Replace missing with zeros;
foreach var in 
tot_flow_5 
tot_flow_10 
tot_flow_15 
tot_flow_20

tot_flow_weight_5 
tot_flow_weight_10 
tot_flow_weight_15 
tot_flow_weight_20

flow_by_length_5 
flow_by_length_10 
flow_by_length_15 
flow_by_length_20

flow_by_length_weight_5 
flow_by_length_weight_10 
flow_by_length_weight_15 
flow_by_length_weight_20

loops_5
loops_10
loops_15
loops_20

  {;
	replace `var' = 0 if `var' == .;
	replace `var' = `var'/10000000 if `var' > 300 /* this makes sure we only replace the traffic values, not the loop counts */;
}; 

** Add event "month" variable;
gen week_of_year = week(dofw(week));
 
** Now merge to week, where "month" is month of event, not month of birth; 
** NOTE: month here is not actual 12 month section, but 13 different 4 week periods. This is to avoid weekly analysis overlapping months;
count;
joinby week_of_year using `fileloc'/data/week_to_thirteen_month_year.dta;
count;

drop week_of_year;
rename fake_month event_month_approx;	

save `fileloc'/data/weekly_pollution_weather_traffic_KMS.dta, replace;

log close combine_pwt;
