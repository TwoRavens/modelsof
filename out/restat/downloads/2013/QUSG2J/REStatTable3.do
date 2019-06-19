/*trying to do the one-step analysis*/


#delimit ;

clear; program drop _all; drop _all;
set mem 1000m;
set matsize 2000;
cap log close;
set more off;
global datadir="L:\MacroCrises&DHS\";
*global datadir="H:\DHS\data";
global tablesdir="H:\DHS\Tables\Jed";
global logsdir="H:\DHS\Tables\Jed";
log using "$logsdir\onestepbirthtiming1.log", replace;

*local country count to take advantage of missing countries;
local numcountry = 59;

use "$datadir\data_for_onestage.dta", clear;


local covars "wb_aob wb_aob2 wb_aob3 wb_bord wb_bord2 wb_bord3 wb_years_edu wb_years_edu2 wb_years_edu3 wb_gender wb_twin wb_rural";


*getting rid of rwanda 1991-1997;

drop if country == "Rwanda" & year == 1991;
drop if country == "Rwanda" & year == 1992;
drop if country == "Rwanda" & year == 1993;
drop if country == "Rwanda" & year == 1994;
drop if country == "Rwanda" & year == 1995;
drop if country == "Rwanda" & year == 1996;
drop if country == "Rwanda" & year == 1997;


local covars "wb_aob wb_aob2 wb_aob3 wb_bord wb_bord2 wb_bord3 wb_years_edu wb_years_edu2 wb_years_edu3 wb_gender wb_twin wb_rural";


replace wb_infant_mortality = 1000*wb_infant_mortality;
replace wb_neonatal = 1000*wb_neonatal;
replace wb_postneonatal = 1000*wb_postneonatal;


*now unweighted;

reg wb_infant_mortality ln_gdp_pc_lag ln_gdp_pc ln_gdp_pc_lead dcountry* tcountry*, robust cluster(country);
outreg ln_gdp_pc_lag ln_gdp_pc ln_gdp_pc_lead using "$tablesdir\onestepbirthtiming.out", nocons nolabel bdec(2) 3aster se br append;
reg wb_infant_mortality ln_gdp_pc_lag ln_gdp_pc ln_gdp_pc_lead dcountry* tcountry* t2country*, robust cluster(country);
outreg ln_gdp_pc_lag ln_gdp_pc ln_gdp_pc_lead using "$tablesdir\onestepbirthtiming.out", nocons nolabel bdec(2) 3aster se br append;
reg wb_infant_mortality ln_gdp_pc_lag ln_gdp_pc ln_gdp_pc_lead dcountry* tcountry* t2country* t3country*, robust cluster(country);;
outreg ln_gdp_pc_lag ln_gdp_pc ln_gdp_pc_lead using "$tablesdir\onestepbirthtiming.out", nocons nolabel bdec(2) 3aster se br append;

reg wb_infant_mortality inutero firstmonth next11 dcountry* tcountry*, robust cluster(country);
outreg inutero firstmonth next11 using "$tablesdir\onestepbirthtiming.out", nocons nolabel bdec(2) 3aster se br append;
reg wb_infant_mortality inutero firstmonth next11 dcountry* tcountry* t2country*, robust cluster(country);
outreg inutero firstmonth next11 using "$tablesdir\onestepbirthtiming.out", nocons nolabel bdec(2) 3aster se br append;
reg wb_infant_mortality inutero firstmonth next11 dcountry* tcountry* t2country* t3country*, robust cluster(country);
outreg inutero firstmonth next11 using "$tablesdir\onestepbirthtiming.out", nocons nolabel bdec(2) 3aster se br append;



log close;

stop;

