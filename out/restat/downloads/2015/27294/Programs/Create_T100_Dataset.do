/*********************************************************************/
/**        This program creats a dataset from the T100 data                  ****/
/*********************************************************************/

#delimit;
clear;
set mem 1g;
set matsize 800;
set more off;

cd "../Data";

tempfile temp;

insheet using T_T100_SEGMENT_US_CARRIER_1997.csv, clear;
keep year month quarter origin dest unique_carrier region  distance class aircraft_config seats passengers;

keep if region == "D";
keep if class == "F" | class == "L";
drop if seats ==0;
keep if aircraft_config == 1;
drop aircraft_config region ;
save `temp', replace;

foreach name in 1998 2000 2001 2003 2007  {;

insheet using T_T100_SEGMENT_US_CARRIER_`name'.csv, clear;
keep year month quarter origin dest unique_carrier region  distance class aircraft_config seats passengers ;

                keep if  aircraft_config == 1;
                keep if region == "D";
                keep if class == "F"  | class == "L"; 
                drop if seats ==0;
                drop aircraft_config region ;

                append using `temp';
                save `temp', replace;
        };

keep if class == "F";

rename unique_carrier opcarrier;

replace opcarrier = "AA" if opcarrier == "TW" &
           (year >= 2002 | (year == 2001 & quarter >= 2));
replace opcarrier = "US" if opcarrier == "HP" & (year >= 2006 | (year == 2005 & quarter >= 4));

collapse (sum)  seats passengers,
        by( origin dest opcarrier year quarter);

drop if passengers == 0;

rename seats seats_t100;
rename passengers  passengers_t100;

gen load_factor = passengers_t100 / seats_t100;
compress;
sort year quarter origin dest opcarrier;
save "Load_Factors.dta", replace;
