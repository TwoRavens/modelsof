#delimit;
clear;
set more off;

global temp /Sastemp;
global path ~;
set mem 5000m;

/*================================================
 Program: diet_diet.do
 Author:  Avi Ebenstein
 Created: August 2008
=================================================*/

* ID is combination of a1 and b101 for rural sample;
use ~/data/china/chns/diet_public;
tostring hhid,replace;
gen province=substr(hhid,1,2);
destring province,replace;
collapse kcal carbo fat protein,by(province);
save ~/pollution/datafiles/diet_rates, replace;

use ~/pollution/datafiles/dsp_basins, clear;
rename province provname;
gen province=provgb;
sort province;
merge province using ~/pollution/datafiles/diet_rates;
keep if _merge==3;

save ~/pollution/datafiles/diet_data, replace;
