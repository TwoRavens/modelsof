#delimit;
clear all;
set mem 5g;
set matsize 800;
set more off;

cd "../Data";

*************************************************************************;

tempfile temp;

use "Dates_of_Interest.dta", clear;
sort flightdate;
save `temp', replace;

*************************************************************************;
*************************************************************************;
*************************************************************************;
*************************************************************************;
*************************************************************************;

use oag, clear;
rename day flightdate;
sort flightdate;
merge flightdate using `temp';
tab _merge;
keep if _merge == 3;
drop _merge;

destring flt_num, replace;

display "Outliers, OAG";

tab outliers;


save `temp'oag, replace;

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
save `temp'1, replace;

use `temp', clear;
keep if _m == 3;
sort flightdate origin dest flt_num opcarrier;
save `temp', replace;

*** fix CO into XE and merge again ***;

use `temp'oag if opcarrier == "CO" | opcarrier == "AA", clear;                
replace opcarrier = "XE" if opcarrier == "CO";
replace opcarrier = "MQ" if opcarrier == "AA";

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

gen year=year(flightdate);
gen quarter = quarter(flightdate);
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
drop _m* outliers;
drop if Fare == .;
compress;
save Sample, replace;
