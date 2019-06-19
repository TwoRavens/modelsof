#delimit;
** REPLACE FILE PATH WITH PATH TO RELEVANT REPLICATION FILES;
local fileloc = "~/KMS_REPLICATION";
set logtype text;
capture log close building_hazard_model;

log using `fileloc'/log_files/building_hazard_model.txt, name(building_hazard_model) replace;
set more off;
clear all;

pause on;

** Limit births to those with traffic data to save on calculation time;
use `fileloc'/data/weekly_pollution_weather_traffic_KMS.dta, clear;
levelsof mother_zip, local(zips);

** Relevant timeframe - 2002 through 2007, last birth in 2006;
use `fileloc'/data/birth_data/daily_births_and_deaths.dta if birth_week >= tw(2002w1), clear;

gen keep_this = 0;
foreach zip of local zips {;
	qui replace keep_this = 1 if mother_zip == `zip';
};
tab keep_this;
keep if keep_this == 1;
drop keep_this;
gsort mother_zip, g(zipcount);
sum zipcount;
drop zipcount;


** Drop fetal deaths;
drop if fetal_death == 1;

** Generate death variable for sampling purposes;
gen died = (death_week ~= .);
sum died;
count if died == 1;

gen age_in_weeks = death_week - birth_week;
replace age_in_weeks = 52 if age_in_weeks == .;

** Generate indicator for auto trauma;
gen auto_trauma = (death_number == 1);

** Add location data;
preserve;
insheet using `fileloc'/data/zip2msa.csv, clear;

rename v1 mother_zip;
destring mother_zip, replace force;
rename v2 msa;
destring msa, replace force;
drop if msa == 9999;
rename v4 share;
destring share, replace force;
** assign zip to msa with largest share;
keep if share > 0.5;

keep mother_zip msa;
tempfile ziptomsa;
save `ziptomsa';
restore;

count;
joinby mother_zip using `ziptomsa';
count;

** Add "quarter" and "month" factors;
gen birth_week_of_year = week(birth_date);
gen week_of_year = birth_week_of_year;

count;
joinby week_of_year using `fileloc'/data/week_to_thirteen_month_year.dta;
count;

drop week_of_year;
rename fake_month birth_month_approx;	
rename fake_quarter birth_quarter_approx;
	
**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;
**XXXXXXXXXXXXXXXXXXXX SPLITTING BY SUBGROUPS XXXXXXXXXXXXXXXXXXXXXXXXX;
**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;

** ALL;

preserve;

	count;
	gen total_births = r(N);
	
	gen weight = 1;
			
	** Collapse data;
	collapse total_births low_weight premature male white black asian hisp other_race HS_grad college_grad twins trip_or_more medicaid care_first_tri  teen_mom age19_25 age26_30 age31_35 age36up first_born second_born third_born fourth_or_more birth_year prenatal_start death_date death_week birth_month_approx birth_quarter_approx msa (sum) weight, by(mother_zip birth_week age_in_weeks died auto_trauma) fast;
	
	tab died;
	tab weight;
	tab weight if died == 1;
			
	keep total_births birth_year prenatal_start mother_zip male white black asian other_race hisp HS_grad college_grad twins trip_or_more medicaid care_first_tri low_weight teen_mom age19_25 age26_30 age31_35 age36up first_born second_born third_born fourth_or_more premature death_date birth_week death_week age_in_weeks birth_month_approx weight auto_trauma birth_quarter_approx msa ;

	** Merge on trimester data;
	** Adding trimester exposure;
	joinby mother_zip birth_week using `fileloc'/data/emissions_data/20mile_trimesters_KMS.dta;
	
	** Expand to one observation per week alive;
	gen group_id = _n;
	expand (age_in_weeks + 1);
	sort group_id;
	
	by group_id : gen weeks_alive = _n - 1;
	gen week = birth_week + weeks_alive;
		
	** Merge on pollution, weather, and traffic data;
	joinby mother_zip week using `fileloc'/data/weekly_pollution_weather_traffic_KMS.dta;
	rename week merging_week;
	drop year;
	
	** Generate new death measure Ð died is now zero for each week the infant survived, and 1 ONLY in the week of death (hazard model). In the case of no death, this is zero for all weeks;
	gen died = 0;
	replace died = 1 if merging_week == death_week;
			
	compress;

	sum total_births;
	
	save `fileloc'/data/KMS_hazard_collapsed_all.dta, replace;

restore; 




** LOW WEIGHT;

preserve;

	count;
	gen total_births = r(N);
	
	gen weight = 1;
	
	** Collapse data;
	collapse total_births male premature  white black asian hisp other_race HS_grad college_grad twins trip_or_more medicaid care_first_tri  teen_mom age19_25 age26_30 age31_35 age36up first_born second_born third_born fourth_or_more birth_year prenatal_start death_date death_week birth_month_approx birth_quarter_approx msa   (sum) weight, by(mother_zip birth_week age_in_weeks died auto_trauma low_weight) fast;
	
	tab died;
	tab weight;
	tab weight if died == 1;
			
	keep total_births birth_year prenatal_start mother_zip male white black asian other_race hisp HS_grad college_grad twins trip_or_more medicaid care_first_tri low_weight teen_mom age19_25 age26_30 age31_35 age36up first_born second_born third_born fourth_or_more premature death_date birth_week death_week age_in_weeks birth_month_approx weight auto_trauma birth_quarter_approx msa   premature;
	
	** Merge on trimester data;
	** Adding trimester exposure;
	joinby mother_zip birth_week using `fileloc'/data/emissions_data/20mile_trimesters_KMS.dta;
	
	** Expand to one observation per week alive;
	gen group_id = _n;
	expand (age_in_weeks + 1);
	sort group_id;
	
	by group_id : gen weeks_alive = _n - 1;
	gen week = birth_week + weeks_alive;
		
	** Merge on pollution, weather, and traffic data;
	joinby mother_zip week using `fileloc'/data/weekly_pollution_weather_traffic_KMS.dta;
	rename week merging_week;
	drop year;
	
	gen died = 0;
	replace died = 1 if merging_week == death_week;
	
	compress;

	sum total_births;
	
	save `fileloc'/data/KMS_hazard_collapsed_low_weight.dta, replace;
 
restore; 




** PREMATURE;

preserve;

	count;
	gen total_births = r(N);
	
	gen weight = 1;
	
	** Collapse data;
	collapse total_births male low_weight white black asian hisp other_race HS_grad college_grad twins trip_or_more medicaid care_first_tri  teen_mom age19_25 age26_30 age31_35 age36up first_born second_born third_born fourth_or_more birth_year prenatal_start death_date death_week birth_month_approx birth_quarter_approx msa   (sum) weight, by(mother_zip birth_week age_in_weeks died auto_trauma premature) fast;
	
	tab died;
	tab weight;
	tab weight if died == 1;
			
	** Note - drop HS_dropout here to save space, and it's dropped due to collinearity anyway;
	keep total_births birth_year prenatal_start mother_zip male white black asian other_race hisp HS_grad college_grad twins trip_or_more medicaid care_first_tri low_weight teen_mom age19_25 age26_30 age31_35 age36up first_born second_born third_born fourth_or_more premature death_date birth_week death_week age_in_weeks birth_month_approx weight auto_trauma birth_quarter_approx msa   premature;
	
	** Merge on trimester data;
	** Adding trimester exposure;
	joinby mother_zip birth_week using `fileloc'/data/emissions_data/20mile_trimesters_KMS.dta;
	
	** Expand to one observation per week alive;
	gen group_id = _n;
	expand (age_in_weeks + 1);
	sort group_id;
	
	by group_id : gen weeks_alive = _n - 1;
	gen week = birth_week + weeks_alive;
		
	** Merge on pollution, weather, and traffic data;
	joinby mother_zip week using `fileloc'/data/weekly_pollution_weather_traffic_KMS.dta;
	rename week merging_week;
	drop year;
	
	gen died = 0;
	replace died = 1 if merging_week == death_week;
	
	compress;

	sum total_births;
	
	save `fileloc'/data/KMS_hazard_collapsed_premature.dta, replace;
 
restore; 



** RACE - BLACK;

preserve;

	count;
	gen total_births = r(N);
	
	gen weight = 1;
	
	** Collapse data;
	collapse total_births male low_weight premature white asian hisp other_race HS_grad college_grad twins trip_or_more medicaid care_first_tri  teen_mom age19_25 age26_30 age31_35 age36up first_born second_born third_born fourth_or_more birth_year prenatal_start death_date death_week birth_month_approx birth_quarter_approx msa   (sum) weight, by(mother_zip birth_week age_in_weeks died auto_trauma black) fast;
	
	tab died;
	tab weight;
	tab weight if died == 1;
			
	** Note - drop HS_dropout here to save space, and it's dropped due to collinearity anyway;
	keep total_births birth_year prenatal_start mother_zip male white black asian other_race hisp HS_grad college_grad twins trip_or_more medicaid care_first_tri low_weight teen_mom age19_25 age26_30 age31_35 age36up first_born second_born third_born fourth_or_more premature death_date birth_week death_week age_in_weeks birth_month_approx weight auto_trauma birth_quarter_approx msa   black;
	
	** Merge on trimester data;
	** Adding trimester exposure;
	joinby mother_zip birth_week using `fileloc'/data/emissions_data/20mile_trimesters_KMS.dta;
	
	** Expand to one observation per week alive;
	gen group_id = _n;
	expand (age_in_weeks + 1);
	sort group_id;
	
	by group_id : gen weeks_alive = _n - 1;
	gen week = birth_week + weeks_alive;
		
	** Merge on pollution, weather, and traffic data;
	joinby mother_zip week using `fileloc'/data/weekly_pollution_weather_traffic_KMS.dta;
	rename week merging_week;
	drop year;
	
	gen died = 0;
	replace died = 1 if merging_week == death_week;
	
	compress;

	sum total_births;
	
	save `fileloc'/data/KMS_hazard_collapsed_black.dta, replace;
 
restore; 

** MEDICAID;

preserve;

	count;
	gen total_births = r(N);
	
	gen weight = 1;
	
	** Collapse data;
	collapse total_births male low_weight premature white black asian hisp other_race HS_grad college_grad twins trip_or_more care_first_tri  teen_mom age19_25 age26_30 age31_35 age36up first_born second_born third_born fourth_or_more birth_year prenatal_start death_date death_week birth_month_approx birth_quarter_approx msa   (sum) weight, by(mother_zip birth_week age_in_weeks died auto_trauma medicaid) fast;
	
	tab died;
	tab weight;
	tab weight if died == 1;
			
	** Note - drop HS_dropout here to save space, and it's dropped due to collinearity anyway;
	keep total_births birth_year prenatal_start mother_zip male white black asian other_race hisp HS_grad college_grad twins trip_or_more medicaid care_first_tri low_weight teen_mom age19_25 age26_30 age31_35 age36up first_born second_born third_born fourth_or_more premature death_date birth_week death_week age_in_weeks birth_month_approx weight auto_trauma birth_quarter_approx msa   medicaid;
	
	** Merge on trimester data;
	** Adding trimester exposure;
	joinby mother_zip birth_week using `fileloc'/data/emissions_data/20mile_trimesters_KMS.dta;
	
	** Expand to one observation per week alive;
	gen group_id = _n;
	expand (age_in_weeks + 1);
	sort group_id;
	
	by group_id : gen weeks_alive = _n - 1;
	gen week = birth_week + weeks_alive;
		
	** Merge on pollution, weather, and traffic data;
	joinby mother_zip week using `fileloc'/data/weekly_pollution_weather_traffic_KMS.dta;
	rename week merging_week;
	drop year;
	
	gen died = 0;
	replace died = 1 if merging_week == death_week;
	
	compress;

	sum total_births;
	
	save `fileloc'/data/KMS_hazard_collapsed_medicaid.dta, replace;
 
restore; 

** HIGH SCHOOL GRADS;

preserve;
	count;
	gen total_births = r(N);
	
	gen weight = 1;
	
	** Collapse data;
	collapse total_births male low_weight premature white black asian hisp other_race college_grad twins trip_or_more medicaid care_first_tri  teen_mom age19_25 age26_30 age31_35 age36up first_born second_born third_born fourth_or_more birth_year prenatal_start death_date death_week birth_month_approx birth_quarter_approx msa   (sum) weight, by(mother_zip birth_week age_in_weeks died auto_trauma HS_grad) fast;
	
	tab died;
	tab weight;
	tab weight if died == 1;
			
	** Note - drop HS_dropout here to save space, and it's dropped due to collinearity anyway;
	keep total_births birth_year prenatal_start mother_zip male white black asian other_race hisp HS_grad college_grad twins trip_or_more medicaid care_first_tri low_weight teen_mom age19_25 age26_30 age31_35 age36up first_born second_born third_born fourth_or_more premature death_date birth_week death_week age_in_weeks birth_month_approx weight auto_trauma birth_quarter_approx msa  ;
	
	** Merge on trimester data;
	** Adding trimester exposure;
	joinby mother_zip birth_week using `fileloc'/data/emissions_data/20mile_trimesters_KMS.dta;
	
	** Expand to one observation per week alive;
	gen group_id = _n;
	expand (age_in_weeks + 1);
	sort group_id;
	
	by group_id : gen weeks_alive = _n - 1;
	gen week = birth_week + weeks_alive;
		
	** Merge on pollution, weather, and traffic data;
	joinby mother_zip week using `fileloc'/data/weekly_pollution_weather_traffic_KMS.dta;
	rename week merging_week;
	drop year;
	
	gen died = 0;
	replace died = 1 if merging_week == death_week;
	
	compress;

	sum total_births;
	
	save `fileloc'/data/KMS_hazard_collapsed_HS_grad.dta, replace;
 
restore; 

** HISPANIC;

preserve;

	count;
	gen total_births = r(N);
	
	gen weight = 1;
	
	** Collapse data;
	collapse total_births male low_weight premature white black asian other_race HS_grad college_grad twins trip_or_more medicaid care_first_tri  teen_mom age19_25 age26_30 age31_35 age36up first_born second_born third_born fourth_or_more birth_year prenatal_start death_date death_week birth_month_approx birth_quarter_approx msa   (sum) weight, by(mother_zip birth_week age_in_weeks died auto_trauma hisp) fast;
	
	tab died;
	tab weight;
	tab weight if died == 1;
			
	** Note - drop HS_dropout here to save space, and it's dropped due to collinearity anyway;
	keep total_births birth_year prenatal_start mother_zip male white black asian other_race hisp HS_grad college_grad twins trip_or_more medicaid care_first_tri low_weight teen_mom age19_25 age26_30 age31_35 age36up first_born second_born third_born fourth_or_more premature death_date birth_week death_week age_in_weeks birth_month_approx weight auto_trauma birth_quarter_approx msa  ;
	
	** Merge on trimester data;
	** Adding trimester exposure;
	joinby mother_zip birth_week using `fileloc'/data/emissions_data/20mile_trimesters_KMS.dta;
	
	** Expand to one observation per week alive;
	gen group_id = _n;
	expand (age_in_weeks + 1);
	sort group_id;
	
	by group_id : gen weeks_alive = _n - 1;
	gen week = birth_week + weeks_alive;
		
	** Merge on pollution, weather, and traffic data;
	joinby mother_zip week using `fileloc'/data/weekly_pollution_weather_traffic_KMS.dta;
	rename week merging_week;
	drop year;
	
	gen died = 0;
	replace died = 1 if merging_week == death_week;
	
	compress;

	sum total_births;
	
	save `fileloc'/data/KMS_hazard_collapsed_hisp.dta, replace;

restore; 


log close building_hazard_model;
  