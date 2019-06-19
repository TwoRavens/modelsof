#delimit;
clear all;
set mem 5g;
set more off;

cd "../Data";

tempfile temp;

cap log close;
log using delays04_09.smcl, replace;

forvalues year = 2004/2009 {;
        forvalues month = 1/12 {;

                insheet using On_Time_On_Time_Performance_`year'_`month'.csv, clear;
                keep flightdate uniquecarrier airlineid tailnum flightnum origin dest crsdeptime
                 deptime taxiout wheelsoff wheelson taxiin crsarrtime arrtime depdelay arrdelay
                 cancelled diverted distance
 		     crselapsedtime actualelapsedtime;
		    tostring wheelsoff wheelson, replace;
                compress;
                save `temp'`year'`month', replace;

             *   erase On_Time_On_Time_Performance_`year'_`month'.csv;
        };
}; 

use `temp'20041, clear;
forvalues month = 2/12 {;
                append using `temp'2004`month';
        };

forvalues year = 2005/2009 {;
        forvalues month = 1/12 {;
                append using `temp'`year'`month';
        };
};
compress;
save delays2005_2009, replace;

log close;
exit;
