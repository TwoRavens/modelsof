#delimit;
clear;
set more off;

global temp /Sastemp;
global path ~;
set mem 500m;

/*================================================
 Program: air_pollution.do
 Author:  Avi Ebenstein 
 Created: August 2008
 Purpose: Calculate average optical clarity at the
          river basin level and the province level.
=================================================*/
  
insheet using ~/pollution/GIS/air_pollution/longterm_particulatesbybasin.csv,clear;

gen airpollution=mean;

forvalues i=1/6{;
                preserve;
collapse (mean) airpollution [w=area], by(level`i');
label var airpollution "Average air quality";
rename airpollution airpollution`i';                
save ~/research/pollution/datafiles/air_pollution_level`i', replace;
                restore;
              };

use ~/pollution/datafiles/air_pollution_level1,clear;
forvalues j=1/6{;
                append using ~/pollution/datafiles/air_pollution_level`j';
              };
save ~/pollution/datafiles/air_pollution_levels, replace;

use ~/pollution/GIS/county_points/countycentroids_watersheds.dta, replace;
rename provgb provnum;
sort level6;
merge level6 using ~/pollution/datafiles/air_pollution_level6;
keep if _merge==3;
collapse (mean) airpollution, by(provnum);
save ~/pollution/datafiles/air_pollution_province, replace;
