#delimit;
clear;
set more off;

global temp /Sastemp;
global path ~;
set maxvar 32000;
set mem 5000m;

capture log close;
log using $path/pollution/logfiles/dsp_basins.log, replace;

/*================================================
 Program: dsp_basins.do
 Author:  Avi Ebenstein
 Created: August 2008
 Purpose: 1. Take the county data which has already been assigned a watershed.
          2. Merge by county (CNTYGB) with the census data.
          3. Merge by county (gbcode) with the DSP data. Only keep 145.
          4. Merge by basin with water pollution measures.
          5. Merge by basin with air pollution measures.
          6. Merge by basin with rainfall measures.
          7. Merge by basin with emission.
          8. Merge by county with stream information. Currently gives us the Pfafsetter code and system.

=================================================*/
 
****************************************************;
* Step 1 - Use county data with watersheds assigned ;
****************************************************;

use ~/pollution/GIS/county_points/countycentroids_watersheds, replace;
keep gbcode fid_1 id gbcnty provgb citygb eprov ecity ecnty level* et_x et_y;

****************************************************;
* Step 2 - Merge with census tabulations by county  ;
****************************************************;

gen CNTYGB=gbcnty;

sort CNTYGB;
merge CNTYGB using ~/research/pollution/datafiles/census_data;
tab _merge;
keep if _merge==1|_merge==3;
drop _merge;

gsort gbcode -pop;
by gbcode: keep if _n==1;
 
****************************************************;
* Step 3 - Merge with DSP death rates by site       ;
****************************************************;

tostring gbcode, replace;
sort gbcode;
merge gbcode using ~/dsp/datafiles/merge_data_site;
tab _merge; 
keep if _merge==3;
drop _merge;

****************************************************;
* Step 4 - Merge with water pollution data by basin ;
****************************************************;

forvalues j=1/6{;
                sort level`j';
                merge level`j' using ~/pollution/datafiles/water_pollution_level`j';
                tab _merge;
                keep if _merge==1|_merge==3;
                capture drop _merge;
              };

gen mylevel=0;

global mylist "overall_q permanga_n a_n lead oils volatile_p bod mercury dissolved_";
foreach i of global mylist{;
                           gen `i'=0;
                           forvalues j=1/6{;
                           replace `i'=`i'_level`j' if `i'_level`j'~=.;
                           replace mylevel=`j'      if `i'_level`j'~=.;                
                                          };
                         };

label var mylevel "Precision of basin";

**************************************************;
* Step 5 - Merge with air pollution data by basin ;
**************************************************;

gen airpollution=0;
gen myairlevel=0;

forvalues j=1/6{;
                sort level`j';
                merge level`j' using ~/pollution/datafiles/air_pollution_level`j';
                tab _merge;
                keep if _merge==1|_merge==3;
                capture drop _merge;
                replace airpollution=airpollution`j' if airpollution`j'~=.;
                replace myairlevel=`j'               if airpollution`j'~=.;
              };

gen lnairpollution=ln(airpollution);

****************************************;
* Step 6 - Merge with rainfall by basin ;
****************************************;

gen rainfall=.;
forvalues i=3/6{;                
capture drop _merge;
sort level`i';
merge level`i' using ~/pollution/datafiles/rainfall_level`i';               
keep if _merge==1|_merge==3;
replace rainfall=rainfall`i' if rainfall`i'~=.;                
              };
capture drop _merge;

************************************;
* Step 7 - Merge with stream info   ;
************************************;
* a. connects DSP to waterpoints    ;
* b. connects DSP to closest stream ;
* c. connects DSP to up-down basins ;
************************************;

sort CNTYGB;
merge CNTYGB using ~/pollution/datafiles/riversystem_info;

*************************;
* This needs to be fixed ;
*************************;

keep if _merge==1|_merge==3;

************************;
* Clean things up a bit ;
************************;

drop *_level*;
drop _merge;
capture drop dummy;
gen dummy=1;
sort dummy;

****************************************************;
* Step 8 - Merge with emissions by basin            ;
****************************************************;

forvalues i=3/4{;
capture drop output*;                
sort dummy;                
merge dummy using ~/pollution/datafiles/output_level`i'_wide;                
capture drop _merge;
gen basin_output_`i'=0;
gen upstream_output1_`i'=0;
gen upstream_output2_`i'=0;
gen downstream_output_`i'=0;

forvalues j=0(1)10000{;
capture                       replace basin_output_`i'=output_tot`j' if level`i'==`j';
capture                       replace upstream_output1_`i'=output_tot`j' if up1_l`i'==`j';
capture                       replace upstream_output2_`i'=output_tot`j' if up2_l`i'==`j';
capture                       replace downstream_output_`i'=output_tot`j' if down_l`i'==`j';
                      };
gen lnbasinoutput`i'=ln(basin_output_`i');
                
gen lnupstreamoutput1_`i'=ln(upstream_output1_`i');
gen lnupstreamoutput2_`i'=ln(upstream_output2_`i');
                
gen lnudownstreamoutput2_`i'=ln(downstream_output_`i');
gen upstream_output_tot`i'=(upstream_output1_`i'+upstream_output2_`i')/1000000;
gen ln_upstream_output_tot`i'=ln((upstream_output1_`i'+upstream_output2_`i')/1000000);
replace ln_upstream_output_tot`i'=0 if ln_upstream_output_tot`i'==.;                
gen basin_output_tot`i'=(basin_output_`i')/10000000;                
              };

capture drop output*;

********************;
/*
forvalues i=6/6{;
capture drop emissions*;                
sort dummy;                
merge dummy using ~/pollution/datafiles/emissions_level`i'_wide;
capture drop _merge;
gen basin_emissions_`i'=0;
gen upstream_emissions1_`i'=0;
gen upstream_emissions2_`i'=0;
gen downstream_emissions_`i'=0;

forvalues j=0(10)100000{;
capture                       replace basin_emissions_`i'=emissions`j' if level`i'==`j';
capture                       replace upstream_emissions1_`i'=emissions`j' if up1_l`i'==`j';
capture                       replace upstream_emissions2_`i'=emissions`j' if up2_l`i'==`j';
capture                       replace downstream_emissions_`i'=emissions`j' if down_l`i'==`j';
                      };
                
gen lnbasinemissions`i'=ln(basin_emissions_`i');
                
gen lnupstreamemissions1_`i'=ln(upstream_emissions1_`i');
gen lnupstreamemissions2_`i'=ln(upstream_emissions2_`i');
                
gen lnudownstreamemissions2_`i'=ln(downstream_emissions_`i');
gen upstream_emissions_tot`i'=(upstream_emissions1_`i'+upstream_emissions2_`i')/1000000;
gen basin_emissions_tot`i'=(basin_emissions_`i')/10000000;                
              };

drop emissions*;
*/

forvalues i=1/6{;
                sort level`i';
                merge level`i' using ~/pollution/datafiles/basinsize_level`i';
                keep if _merge==1|_merge==3;
                drop _merge;
};

****************************;
* Define north-south divide ;
****************************;

replace rsystem="Songhua R" if ecnty=="Longjing";
encode rsystem, gen(rnumber);

gen rivercat=.;
replace rivercat=1 if rnumber==2|rnumber==3|rnumber==5|rnumber==10|rnumber==4;
replace rivercat=2 if rnumber==1|rnumber==7|rnumber==8|rnumber==9|rnumber==6;

********************************;
* End of program                ;
********************************;

save ~/pollution/datafiles/dsp_basins.dta, replace;

********************************;
* This is for excel purposes    ;
********************************;

outsheet CNTYGB eprov ecity ecnty gbcode level1 level2 level3 level4 level5 level6
city county pop
overall_q bod
cancer_m cancer_f heart_m heart_f
deathrate9 deathrate10 maledr9 maledr10 femaledr9 femaledr10 
deathrate_09* maledr_09* femaledr_09*
urbcat 
manufacturing1 manufacturing2 farming3 production totemployed
share_coal share_firewood share_mining share_tap_water1 farmer production
share_ferrous share_nonferrous
using ~/pollution/outfiles/dsp_basins.csv, replace;
