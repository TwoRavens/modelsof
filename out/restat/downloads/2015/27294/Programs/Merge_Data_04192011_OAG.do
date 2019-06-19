#delimit;
clear all;
set mem 5g;
set matsize 800;
set more off;

cd "../Data";

*************************************************************************;
*** It's same as Merge_Data_04192011.do but this one keeps all carriers from OAG ****;
*************************************************************************;

use origin dest day HHI using
        "oag_04192011.dta", clear;
gen year = year(day);
gen quarter = quarter(day);
drop day;
duplicates drop;
egen trend = group(year quarter);
egen od = group(origin dest);
tsset od trend;
gen HHI_1yr_lag = l4.HHI;
gen HHI_halfyear_lag = l2.HHI;
gen HHI_1qr_lag = l1.HHI;
drop trend od HHI;
sort origin dest year quarter;
save ash, replace;

*****************************************;

use "Dates_of_Interest.dta", clear;
sort flightdate;
tempfile temp;
save `temp', replace;

*************************************************************************;
*************************************************************************;
*************************************************************************;
*************************************************************************;
*************************************************************************;

use oag_04192011, clear;
gen year = year(day);
gen quarter = quarter(day);
sort origin dest year quarter;
dmerge origin dest year quarter using ash, nokeep;
drop _m year quarter;

rename day flightdate;
sort flightdate;
dmerge flightdate using `temp';
tab _merge;
keep if _merge == 3;
drop _merge;

destring flt_num, replace;

display "Outliers, OAG";

tab outliers;

gen year=year(flightdate);
gen quarter = quarter(flightdate);
compress;
save `temp', replace;

***** identify the percentage of flights with fastest time ****;

gen fastest = (flt_time1 <= min_flt_time + 1 & outliers == 0);

xcollapse (mean) perc_fastest_time = fastest if outliers == 0, by(origin dest year quarter) saving(ash, replace);
dmerge origin dest year quarter using ash;
drop _m fastest;

xcollapse (mean) mean_flt_time = flt_time1 (median) median_flt_time = flt_time1 (p25) p25_flt_time = flt_time1
	(p75) p75_flt_time = flt_time1 (max) max_flt_time = flt_time1 if outliers == 0, by(origin dest year quarter) saving(ash, replace);
dmerge origin dest year quarter using ash;
drop _m ;


save `temp', replace;


sort flightdate origin dest flt_num opcarrier;
merge flightdate origin dest flt_num opcarrier using delays1997_2007_help,
        keep(opcarrier tailnum flt_num origin dest depdelay arrdelay 
                actualelapsedtime flightdate flight_in_day late_arrival scheduled_buffer total_actual_time crselapsedtime);
tab _merge;

save `temp', replace;

keep if _m == 2;
keep opcarrier tailnum flt_num origin dest depdelay arrdelay 
                actualelapsedtime flightdate flight_in_day late_arrival scheduled_buffer total_actual_time crselapsedtime;
sort flightdate origin dest flt_num opcarrier;
cap drop _m*;
save `temp'1, replace;

use `temp', clear;
keep if _m == 3;
sort flightdate origin dest flt_num opcarrier;
save `temp', replace;

*** fix CO into XE and merge again ***;

use `temp' if opcarrier == "CO" | opcarrier == "AA", clear;
replace opcarrier = "XE" if opcarrier == "CO";
replace opcarrier = "MQ" if opcarrier == "AA";

drop _merge;
sort flightdate origin dest flt_num opcarrier;
merge flightdate origin dest flt_num opcarrier using `temp'1,
        keep(opcarrier tailnum flt_num origin dest depdelay arrdelay 
                actualelapsedtime flightdate flight_in_day late_arrival scheduled_buffer total_actual_time crselapsedtime);
tab _merge;
append using `temp';
rename crselapsedtime schelapsedtime;
duplicates report;
tab _merge;
drop if _merge == 1;
tab _merge;
drop if _merge == 2;
drop _merge;

* gen year=year(flightdate);
* gen quarter = quarter(flightdate);
compress;
save `temp', replace;

***************************************************************;
***** MERGE DATA ON FARES, INSTRUMENTS, LOAD FACTORS AND INTERNET ;
***************************************************************;

dmerge year quarter origin dest opcarrier using Weighted_Variables, nokeep;
rename _merge _m_WeightedVar;
tab _m_W;

dmerge year quarter origin dest opcarrier using Fare_1_0_0_0_1, nokeep;
rename _merge _m_Fare;
tab _m_F;

dmerge year quarter origin dest opcarrier using Load_Factors, nokeep;
rename _merge _m_LF;
tab _m_LF;

tab _m_W _m_F;
tab _m_W _m_LF;
tab _m_F _m_LF;

tab _m_W outliers;
tab _m_F outliers;
tab _m_LF outliers;

keep if _m_W == 3 & _m_F == 3 & _m_LF == 3;

drop if outliers == 1;
drop _m_W _m_F outliers;
drop if Fare == .;
compress;
save Sample_04192011_OAG, replace;
