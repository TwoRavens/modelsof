#delimit;
clear all;
set mem 5g;
set more off;

cd "../Data";

tempfile temp;

forvalues year = 1990/2007 {;
        forvalues month = 4/4 {;

                insheet using On_Time_On_Time_Performance_`year'_`month'.csv, clear;
                keep flightdate origin dest crselapsedtime;
				keep if dow(flightdate)==4;
				
		         compress;
				save `temp'`year'`month', replace;

               };
}; 

use `temp'19904, clear;
forvalues year = 1991/2007 {;
        forvalues month = 4/4 {;
                append using `temp'`year'`month';
        };
};

gen year = year(flightdate);
gen quarter = quarter(flightdate);
gen month = month(flightdate);
gen day_of_month = day(flightdate);
gen day_of_week = dow(flightdate);
rename crselapsedtime flt_time1;	             

dmerge origin dest using DistNS, nokeep;
drop _m;
save `temp', replace;

keep year quarter month day_of_month;
duplicates drop;
bysort year quarter month (day_of_month): gen rk = _n_;
keep if rk == 3;
rename day_of_month first_third_thursday;
save `temp'1, replace;

use `temp', clear;
dmerge year quarter month using `temp'1;
keep if day_of_month = first_third_thursday;

save 90_07_scheduled_data, replace;
