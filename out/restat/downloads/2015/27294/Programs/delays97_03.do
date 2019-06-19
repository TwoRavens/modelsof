#delimit;
clear all;
set mem 5g;
set more off;

cd "../Data";

tempfile temp;

cap log close;
log using delays97_03.smcl, replace;

forvalues year = 1997/2003 {;
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

use `temp'19971, clear;
forvalues month = 2/12 {;
                append using `temp'1997`month';
        };

forvalues year = 1998/2003 {;
        forvalues month = 1/12 {;
                append using `temp'`year'`month';
        };
};
save delays1997_2003, replace;

log close;
exit;
