	/********************************
0_data.do

GD December 2015

This finishes the clean up of the data and deals with number of novelties in the revision including pmsa information, updating population numbers and changing the population ranks on that basis.

The second part of the file produces the tables of descriptive statistics in the paper

*********************************/


************************ Other upstram steps not done here *************;

* trip_vmt_09_revised.do -- this is slightly revised file that keeps the information on pmsa and not only msa;
* This was done only for 2009 as the 2001 file only has information on cmsa;

* merge_trip_revised.do -- the file was slightly modified too keep information about the pmsa in 2009;



**************  Start  ********************************************************;

*set up;
#delimit;
clear all;

set memory 3g;

set matsize 5000;
set more 1;
quietly capture log close;
cd;

global data_source  D:\S_congestion\data_processing\data_generated\ ;

global data_original D:\S_congestion\data_processing\data\Revision ;


***************************************************************************************************************;
******************** Set up working file and create average trip distance instrument     **********************;
***************************************************************************************************************;

* To be done only once;

if  1 == 1 {;
	
*log using data/setup, text replace;

use "$data_source\npts_trip";

* generate the inverse of speed;
gen p = 1/mph_trip;
gen l_p = ln(p);

replace year = 95 if year == 1995;
replace year = 01 if year == 2001;
replace year = 09 if year == 2009;

*race variables;
gen black =0;
replace black = 1 if race==2;
gen hispanic =0;
replace hispanic = 1 if race==3;
drop race;

* generate time dummies;
drop if strttime<0;
drop if strttime>2400;
gen start= floor(strttime/100);
forvalues t = 0(1)23 {;
gen depart_`t' = 0;
replace depart_`t' = 1 if `t'== start;
};

* gen compact time variables;
gen start1 = strttime/100;
gen start2 = start1*start1;
gen start3 = start2*start1;
gen start4 = start3*start1;

*gen compact income and education variables;
gen income1 = hh_income/1000;
gen income2 = income1*income1;
gen educ1 = hh_education;
gen educ2 = educ1*educ1;

drop p start strttime trvl_min;

sort msa pid  trip_number;
gen obs_number = _n;

compress; 

save "$data_source\npts.dta", replace;

use "$data_source\npts";

*get rid all trip types in small number in their msa; 

gen t=1;
collapse (sum) t trpmiles, by (msa year whytrp90);

* drops if 3 or less observation of a given type in a city;
drop if t<3;

rename trpmiles ag_miles;
sort msa year whytrp90;
save "$data_source\temp.dta", replace;

use "$data_source\npts.dta";
sort msa year whytrp90;
merge msa year whytrp90 using "$data_source\temp.dta";
tab _merge;
drop if _merge == 1;
drop _merge;
gen inst_ownA = (ag_miles - trpmiles)/(t-1);
drop t ag_miles;

replace pmsa=msa if pmsa==.;

save "$data_source\npts.dta", replace;
erase "$data_source\temp.dta";

};





***************************************************************************************************************;
******************** Update population using 2010 census                                 **********************;
***************************************************************************************************************;


if  1 ==1 {;

use "$data_original\county2msa.dta";

keep county pmsa;

save "$data_source\temp.dta", replace;

use "$data_original\county_charact_2015.dta";

merge m:m county using $data_source\temp.dta;

keep if _merge==3;

keep msa pmsa county pop1960 pop1990 pop2000 pop2010;

save "$data_source\county_temp.dta", replace;

collapse (sum) pop1960 pop1990 pop2000 pop2010, by (msa);

drop if msa==.;

*New Haven has no observation in 2001;
drop if msa==5483; 

egen rank_msa=rank(pop2010);
replace rank_msa = 275 -rank_msa;

save "$data_source\msa_temp.dta", replace;


use "$data_source\county_temp.dta";

replace pmsa=msa if pmsa==.;


*New Haven has no observation in 2001;
drop if msa==5483; 

collapse (sum) pop1960 pop1990 pop2000 pop2010, by (pmsa);

drop if pmsa==.;

egen rank_pmsa=rank(pop2010);

replace rank_pmsa = 316 -rank_pmsa;

save "$data_source\pmsa_temp.dta", replace;

keep rank_pmsa pmsa;
save "$data_source\pmsa_temp2.dta", replace;

* HPMS DATA WILL BE NEEDED;

use "$data_source\npts.dta";

merge m:m msa using $data_source\msa_temp.dta;

drop if _merge==2;
drop _merge;

merge m:m pmsa using $data_source\pmsa_temp2.dta;

drop if _merge==2;
drop _merge;

replace year = 95 if year == 1995;
replace year = 01 if year == 2001;
replace year = 09 if year == 2009;


*******Trip-level panel*****************************;

*convert miles into kilometers;
gen trpmiles_km = trpmiles*1.609344;
gen mph_trip_km = mph_trip*1.609344;

save $data_source\working_npts.dta, replace;
};



***************************************************************************************************************;
******************** Generate Table 1 for Speed project (Summary Statistics)            **********************;
***************************************************************************************************************;

*** Descriptive stats generated by Victor using table_speed_180911.do incorporated here;

if  1 == 1 {;
use "$data_source\npts_trip.dta";

log using $data_source\table_vic, text replace;

merge m:m msa using $data_source\msa_temp.dta;

drop if _merge==2;
drop _merge;

merge m:m pmsa using $data_source\pmsa_temp2.dta;

drop if _merge==2;
drop _merge;

replace year = 95 if year == 1995;
replace year = 01 if year == 2001;
replace year = 09 if year == 2009;


*******Trip-level panel*****************************;

*convert miles into kilometers;
gen trpmiles_km = trpmiles*1.609344;
gen mph_trip_km = mph_trip*1.609344;

keep if rank_msa <= 100;

*get summary statistics for table;

****** Set up svyset *****************;
*NHTS is survey data. I use stata commands for survey data.
*I define only on strata (the whole sample) and the unit of observation is each trip (an observation);
*The weights are pweight (regular survey weigtht) - invert probability of being of being sampled;
*wtperfin is person weight (or equivalently when computing averages) trip weight, that are person weight divided by 365);

svyset _n [pweight = wtperfin];

*the command estat sd computes the standard error of the variable itself (as opposed to that of the mean);
*not very efficient representation of information, but need number of observation somewhere;
foreach year in 95 01 09 {;
foreach var in trpmiles_km trvl_min mph_trip_km {;

dis "The year is  "  "`year'";
svy: mean `var' if year == `year';
estat sd;
};
};

*get trip_number average on a per driver basis;

by pid, sort: gen nvals = _n == 1;
drop if nvals == 0;

foreach year in 95 01 09 {;
dis "The year is  "  "`year'";
svy: mean trip_number if year == `year';
estat sd;
};

********Msa-level panel*****************************;

save $data_source\temp.dta, replace;

use "$data_source\npts_msa";

merge m:m msa using $data_source\msa_temp.dta;



keep if rank_msa <= 100;


*convert miles into km's and express in 1000,000s;
foreach var in vmt_trip_uw  {;
foreach year in 95 01 09 {;
gen `var'_km_`year' = `var'_`year'*1.609344/1000000;
};
};

foreach year in 95 01 09 {;
replace vtime_trip_uw_`year' = vtime_trip_uw_`year'/1000000;
};

foreach var in ln_km_MRU  ln_km_IH {;
foreach year in 95 01 09 {;
gen `var'_000s_`year' = `var'_`year'/1000;
};
};


gen pop_95b = (pop1990 * pop2000)^0.5;
gen pop_01b = (pop2000^0.9 * pop2010^0.1);
gen pop_09b = (pop2000^0.1 * pop2010^0.9);


pwcorr pop_95 pop_95b pop_01 pop_01b pop2000 pop_09 pop_09b pop2010;

*get summary statistics for table;
sum vmt_trip_uw_km_95 vtime_trip_uw_95 ln_km_IH_000s_95 ln_km_MRU_000s_95 pop_95b;
sum vmt_trip_uw_km_01 vtime_trip_uw_01 ln_km_IH_000s_01 ln_km_MRU_000s_01 pop_01b;
sum vmt_trip_uw_km_09 vtime_trip_uw_09 ln_km_IH_000s_09 ln_km_MRU_000s_09 pop_09b;



save $data_source\temp.dta, replace;



***************************************************************************************************************;
************      Generate Table 2 for Speed project (Summary Statistics by Trip purpose)       ***************;
***************************************************************************************************************;


use "$data_source\npts_trip";

svyset _n [pweight = wtperfin];


merge m:m msa using $data_source\msa_temp.dta;

drop if _merge==2;
drop _merge;

merge m:m pmsa using $data_source\pmsa_temp2.dta;

drop if _merge==2;
drop _merge;

keep if rank_msa <= 100;

replace year = 95 if year == 1995;
replace year = 01 if year == 2001;
replace year = 09 if year == 2009;

*Trip-level panel;

*convert miles into kilometers;
gen trpmiles_km = trpmiles*1.609344;
gen mph_trip_km = mph_trip*1.609344;

*consolidate trip purpose (others, unavailable, etc)
replace whytrp90 = 11 if (whytrp90 == 11 | whytrp90 == 98 | whytrp90 == 99);
 
foreach purp in 1 2 3 4 5 6 7 8 10 11 {;
foreach year in 95 01 09 {;
display "Purpose and year are   " "`purp'_`year'";
svy: mean trpmiles_km if (whytrp90 == `purp' & year == `year');
estat sd;
};
};


svy: tab whytrp90;



************** Generate percentage of lane and traffic on Interstate Highways in 2009    **********************;

save "$data_source\temp.dta", replace;

use "$data_source\npts_msa";

merge m:m msa using $data_source\msa_temp.dta;

drop if _merge==2;
drop _merge;


keep if rank_msa <= 100;

*generate percentage of lanes that are IH;
egen sum_IH = sum(ln_km_IH_09);
egen sum_MRU = sum(ln_km_MRU_09);
gen ratio_lanes_IHMRU = sum_IH/(sum_IH+sum_MRU);
dis ratio_lanes_IHMRU;


*generate percentage of lanes on IH;
egen sum_vmt_IH = sum(vmt_IH_09);
egen sum_vmt_MRU = sum(vmt_MRU_09);
gen ratio_vmt_IHMRU = sum_vmt_IH/(sum_vmt_IH+sum_vmt_MRU);
dis ratio_vmt_IHMRU;


log close;



};





exit;


