#delimit;
clear all;
set mem 5g;
set matsize 800;
set more off;

cd "../Data";

cap log close;
log using delays97_07_Step2.smcl, replace;

*************************************************************************;

tempfile temp;

use "Dates_of_Interest.dta", clear;
sort flightdate;
save `temp', replace;

*************************************************************************;

use flightdate uniquecarrier tailnum flightnum origin dest  
         crsdeptime depdelay crsarrtime arrdelay deptime arrtime 
                 crselapsedtime actualelapsedtime diverted cancelled using delays2004_2009 
                 if substr(flightdate,1,4) == "2007", clear;

gen year = substr(flightdate,1,4);
gen month = substr(flightdate,6,2);
gen day =substr(flightdate,9,2);

drop flightdate;
destring year month day, replace;

gen flightdate = mdy(month,day,year);
format flightdate %td;

drop month day year;

dmerge flightdate using `temp';
keep if _m == 3;
drop _m;
save `temp'07, replace;

*************************************************;

use flightdate uniquecarrier tailnum flightnum origin dest  
         crsdeptime depdelay crsarrtime arrdelay deptime arrtime 
                 crselapsedtime actualelapsedtime diverted cancelled using delays1997_2003, clear;

gen year = substr(flightdate,1,4);
gen month = substr(flightdate,6,2);
gen day =substr(flightdate,9,2);

drop flightdate;
destring year month day, replace;

gen flightdate = mdy(month,day,year);
format flightdate %td;

drop month day year;

dmerge flightdate using `temp';
keep if _m == 3;
drop _m;
append using `temp'07;

**********************************;

display "Total # obs";
count;

drop if cancelled == 1 | diverted == 1;
drop cancelled diverted;
display "#Obs after deleting obs for cancelled or diverted flights";
count;

drop if tailnum == "";

display "#Obs after deleting obs with missing tail number";
count;

**************************************************************************;
/*** recode CRS and actual dep and arr times on 0 / 1440 scale - this in order to ****/
/*** infer CRS dep/arr times from actual and the delay in minutes where CRS dep/arr time ***/
/*** is recorded as 0                                                             ****/

foreach name in crsarrtime arrtime crsdeptime deptime {;

                gen x = `name' / 100;
                gen hour = int(x);
                gen y = (x - hour) * 100;
                gen min = round(y);

                gen `name'1 = hour * 60 + min;

                drop x y hour min;

};

replace  crsdeptime1 =  deptime1 -  depdelay if  crsdeptime == 0;
replace  crsarrtime1 =  arrtime1 -  arrdelay if  crsarrtime == 0;

drop if crsdeptime1 < 0 | crsarrtime1 < 0;
display "#obs after deleting flights departing or arriving in the previous day";
count;

*******************************************************************;

sort flightdate uniquecarrier tailnum crsdeptime1;
bysort  flightdate uniquecarrier tailnum: egen flight_in_day= seq();
gen late_arrival=0;
replace late_arrival= arrdelay[_n-1];
replace late_arrival=0 if flight_in==1;

rename crsdeptime1 schdeparture;
rename crsarrtime1 scharrival ;

gen previous_scharrival=0;
replace previous_scharrival= scharrival[_n-1];
replace previous_scharrival=0 if flight_in==1;

gen previous_arrival = dest[_n-1];

gen scheduled_buffer = schdeparture - previous_scharrival;
replace scheduled_buffer = 240 if flight_in==1 | previous_arrival != origin;
drop scharrival schdeparture previous_scharrival previous_arrival;

gen total_actual_time=actualelapsedtime + depdelay;
rename uniquecarrier opcarrier;

keep opcarrier flightnum origin dest depdelay arrdelay actualelapsedtime total_actual_time
        flight_in_day late_arrival scheduled_buffer flightdate
        tailnum crsdeptime crsarrtime deptime arrtime crselapsedtime;

/*** delete outliers - delays > 6 hours****/

drop if depdelay > 360 | arrdelay > 360;

display "#obs after deleting outliers - delays > 6 hours";
count;

replace opcarrier = "AA" if opcarrier == "TW" & (year(flightdate) >= 2002 | (year(flightdate)== 2001 & quarter(flightdate) >= 2));
replace opcarrier = "US" if opcarrier == "HP" & (year(flightdate) >= 2006 | (year(flightdate)== 2005 & quarter(flightdate) >= 4));

rename flightnum flt_num;
compress;

sort flightdate origin dest flt_num opcarrier;
save delays1997_2007_help, replace;

log close;
exit;
