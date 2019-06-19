#delimit;
clear;
set mem 1g;
set matsize 800;
set more off;

cd "../Data";

tempfile temp;

insheet using T_T100_SEGMENT_US_CARRIER_1997.csv, clear;

keep if region == "D";
keep if class == "F" | class == "L";
drop if seats ==0;
keep if aircraft_config == 1;
drop aircraft_config region ;
keep origin  origin_state_abr ;
keep if origin_state_abr != "";
duplicates drop;
save `temp', replace;

foreach name in 1998 2000 2001 2003 2007  {;

insheet using T_T100_SEGMENT_US_CARRIER_`name'.csv, clear;

                keep if  aircraft_config == 1;
                keep if region == "D";
                keep if class == "F"  | class == "L"; 
                drop if seats ==0;
                keep origin  origin_state_abr ;
                keep if origin_state_abr != "";
                duplicates drop;

                append using `temp';
                save `temp', replace;
        };

duplicates drop;
rename origin_state_abr state;

sort origin state;
save "airport_state.dta", replace;
