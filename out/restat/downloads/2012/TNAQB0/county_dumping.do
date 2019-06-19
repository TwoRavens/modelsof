clear
set more off
set mem 2500m
set maxvar 32000

**************************************
** reshape both the dumping file and
** output file from wide(year on the 
** x-axis) to long (year on the y-axis
***************************************

global path ~/research/pollution

***reshape jing's file
clear
use ~/data/china/manufacturing/caojing/countyoutput.dta
rename output98 output1998
rename output99 output1999
rename output00 output2000
rename output01 output2001
rename output02 output2002
rename output03 output2003
rename output05 output2005

reshape long output, i(county industry) j(year)
sort industry
save $path/dumping/countyoutput2.dta, replace

**************************************
*** match the industry output
*** data to the indusry match dataset
*** and collapse into dumping_industry
*** county year level
**************************************


***merge jing's data with the concordance data
clear
set mem 2500m
use $path/dumping/industry_match.dta
rename output_industry industry
sort industry
merge industry using $path/dumping/countyoutput2, uniqmaster
tab _merge
drop _merge
sort dumping_industry year
rename industry output_industry

***trim down to the dumping_industry level
bysort county year dumping_industry: egen output2 = sum(output)
replace output = output2
drop output2

tab year dumping_industry
duplicates drop year county dumping_industry, force
tab year dumping_industry

sort dumping_industry
save $path/dumping/countyoutput_reshaped.dta, replace

!rm $path/dumping/countyoutput2.dta


*************************************
** prepare the dumping_by_industry
** file for merge
*************************************

***reshape the industry level dumping file
clear
use $path/dumping/dumping_by_industry.dta
reshape long year, i(dumping_industry) j(yr)
rename year dumping
rename yr year

***recategorize the dumping industry

gen drop_flag = 1 if dumping_industry == 16
replace drop_flag = 1 if dumping_industry == 22
replace dumping_industry = 15 if dumping_industry == 16
replace dumping_industry = 19 if dumping_industry == 22

bysort year dumping_industry: egen dumping2 = sum(dumping)
drop dumping
rename dumping2 dumping

drop if drop_flag == 1

duplicates report dumping_industry year

save $path/dumping/dumping_by_industry_reshaped.dta, replace


*************************************************************;
* Remake table of 1998-2000 comparsion of dumping and output ;
*************************************************************;

#delimit;

***********************************;
* Merge with countyoutput_reshaped ;
***********************************;

use $path/dumping/countyoutput_reshaped.dta,clear;
keep if year>=1998 & year<=2000;                    
collapse (sum) output,  by(dumping_industry);
save $path/dumping/output_98to00, replace;

*******************;
  
use $path/dumping/dumping_by_industry_reshaped.dta, clear;
encode industry_name_e,gen(myind) label(myindlbl);
keep if year>=1998 & year<=2000;                    
collapse (sum) dumping, by(dumping_industry);
save $path/dumping/dumping_98to00,replace;
sort dumping_industry;
merge dumping_industry using $path/dumping/output_98to00;
tab _merge;
gen ratio=dumping/output*1000000;

**************************************;
* Table of amounts - appendix table 5 ;
**************************************;

list, clean;

use $path/dumping/dumping_by_industry_reshaped.dta, clear;
keep if year==2000;
gen dummy=1;
keep dummy dumping dumping_industry;
reshape wide dumping, i(dummy) j(dumping_industry);
sort dummy;
save $path/dumping/dumping_wide, replace;


*******************************************************************************************;
* Calculate county-level dumping by assuming each county produces with the same technology ;
*******************************************************************************************;

clear;
use $path/dumping/countyoutput_reshaped.dta,clear;
keep if year==2003;
collapse (sum) output,  by(dumping_industry county);
reshape wide output, i(county) j(dumping_industry);
gen dummy=1;
sort dummy;
merge dummy using $path/dumping/dumping_wide;
tab _merge;
drop _merge;                    
gen county_dumping_tot=0;                    
global industrylist "2 3 4 5 6 7 8 9 10 11 12 13 14 15 17 18 19 20 21";
foreach i of global industrylist{;
                                 egen totoutput`i'=sum(output`i');
                                 gen outputshare`i'=output`i'/totoutput`i';                                 
                                 gen county_dumping`i'=outputshare`i'*dumping`i';
                                 replace county_dumping_tot=county_dumping_tot+county_dumping`i';
                               };
egen county_dumping_national=sum(county_dumping_tot);
gen dumping_share_national=county_dumping_tot/county_dumping_national;

tostring county,gen(cntygb);
gen provnum=substr(cntygb,1,2);
destring provnum, replace;                    
bysort provnum: egen county_dumping_province=sum(county_dumping_tot);
gen dumping_share_province=county_dumping_tot/county_dumping_province;                    
sort provnum;
save $path/dumping/county_weights2003, replace;

**************************************************;
* Merge with dumping data by province (and year?) ;
**************************************************;

use $path/dumping/dumping1990to2006, replace;                    

global replacevar "total_dumping mercury cadmium chromium lead arsenic volitized_phenol cyanide petroleum_types chemical_oxygen
	volitized_phenol_cleanup cyanide_cleanup petroleum_cleanup chemical_oxygen_cleanup suspended";

gen extend_year = year;

foreach varname of global replacevar{;
	replace extend_year = 2000 if missing(`varname') == 1;
	bysort extend_year provnum: egen `varname'2 = min(`varname');
	replace `varname' = `varname'2;
	drop `varname'2;
};
sort provnum;
save $path/dumping/dumping1990to2006_extend, replace;

keep if year==2003 & provnum~=0;
sort provnum;                    
save $path/dumping/dumping2003_extend, replace;
             
********************************************************************************************************;
* These data are from "manufacturing points full join no bad" from scott (which is actually a bad file) ;
********************************************************************************************************;

use ~/research/pollution/GIS/county_output/manufacturing_points_basins.dta;
drop output*;
capture drop _merge;
sort county;
save /Sastemp/manufacturing_points_basins, replace;

****************************;

#delimit;
use $path/dumping/county_weights2003, replace;       
sort provnum;
merge provnum using $path/dumping/dumping2003_extend;
tab _merge;
keep if _merge==1|_merge==3;
drop _merge;

**************************************************************************;

sort county;
merge county using /Sastemp/manufacturing_points_basins.dta;
tab _merge;

*****************************************************;
* Some points are not in an identifiable river basin ;
* because Jing's geographic coordinates were weird   ;
* for a small fraction of the observations           ;
*****************************************************;

keep if _merge==1|_merge==3;

*******************************;
* Different types of emissions ;
*******************************;

global emissiontypes "total_dumping mercury cadmium chromium lead arsenic volitized_phenol cyanide petroleum_types chemical_oxygen";
global cleanuptypes "volitized_phenol_cleanup cyanide_cleanup petroleum_cleanup chemical_oxygen_cleanup";

global chemvar "total_dumping ammonium suspended mercury cadmium chromium lead arsenic volitized_phenol cyanide petroleum_types chemical_oxygen ammonium_cleanup volitized_phenol_cleanup cyanide_cleanup petroleum_cleanup chemical_oxygen_cleanup";

keep county level1 level2 level3 level4 level5 level6 $chemvar output* dumping* *cleanup province;

******************************************************************************************;
* Each emission is allocated to each county by assigning some share of provincial dumping ;
******************************************************************************************;

foreach emission of global chemvar{;
gen `emission'_cnty=dumping_share_province*`emission';

*******************;

bysort province: gen `emission'_prov=`emission'*(_n==1);
egen `emission'_total=sum(`emission'_prov);
gen `emission'_cntynat=dumping_share_national*`emission'_total;

rename `emission' `emission'_orig;
gen `emission'=`emission'_cnty;
};

save ~/research/pollution/datafiles/county_dumping, replace;

