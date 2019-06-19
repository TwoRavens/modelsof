/*trying to do the one-step analysis*/


#delimit ;
clear; program drop _all; drop _all;
set mem 3000m;
set matsize 2000;
cap log close;
set more off;
*global datadir="H:\DHS\data";
global datadir="L:\MacroCrises&DHS\";
global tablesdir="H:\DHS\Tables\Jed";
global logsdir="H:\DHS\Tables\Jed";
log using "$logsdir\onestepTable2.log", replace;


use "$datadir\data_for_onestage", clear;
local covars "wb_aob wb_aob2 wb_aob3 wb_bord wb_bord2 wb_bord3 wb_years_edu wb_years_edu2 wb_years_edu3 wb_gender wb_twin wb_rural";

*getting rid of rwanda 1991-1997;

drop if country == "Rwanda" & year == 1991;
drop if country == "Rwanda" & year == 1992;
drop if country == "Rwanda" & year == 1993;
drop if country == "Rwanda" & year == 1994;
drop if country == "Rwanda" & year == 1995;
drop if country == "Rwanda" & year == 1996;
drop if country == "Rwanda" & year == 1997;

*rescaling;
replace wb_infant_mortality = 1000*wb_infant_mortality;

reg wb_infant_mortality ln_gdp_pc dcountry* tcountry*, robust cluster(country);
outreg ln_gdp_pc using "$tablesdir\onestepTable2.out", nocons nolabel bdec(2) 3aster se br replace;
reg wb_infant_mortality ln_gdp_pc dcountry* tcountry* t2country*, robust cluster(country);
outreg ln_gdp_pc using "$tablesdir\onestepTable2.out", nocons nolabel bdec(2) 3aster se br append;

reg wb_infant_mortality ln_gdp_pc dcountry* tcountry* t2country* t3country*, robust cluster(country);
outreg ln_gdp_pc using "$tablesdir\onestepTable2.out", nocons nolabel bdec(2) 3aster se br append;

reg wb_infant_mortality ln_gdp_pc `covars' dcountry* tcountry*, robust cluster(country);
outreg ln_gdp_pc using "$tablesdir\onestepTable2.out", nocons nolabel bdec(2) 3aster se br append;
reg wb_infant_mortality ln_gdp_pc `covars' dcountry* tcountry* t2country*, robust cluster(country);
outreg ln_gdp_pc using "$tablesdir\onestepTable2.out", nocons nolabel bdec(2) 3aster se br append;
reg wb_infant_mortality ln_gdp_pc `covars' dcountry* tcountry* t2country* t3country*, robust cluster(country);
outreg ln_gdp_pc using "$tablesdir\onestepTable2.out", nocons nolabel bdec(2) 3aster se br append;

*now only women with at least two births;

*first identifying the mother;
sort country;
egen countrynum = group(country);

sort country wb_syear wb_momid;
egen mother = group(country wb_syear wb_momid);

sort mother;
egen numchild = count(wb_infant_mortality), by(mother);
keep if numchild >= 2;

reg wb_infant_mortality ln_gdp_pc dcountry* tcountry*, robust cluster(country);
outreg ln_gdp_pc using "$tablesdir\onestepTable2.out", nocons nolabel bdec(2) 3aster se br append;
reg wb_infant_mortality ln_gdp_pc dcountry* tcountry* t2country*, robust cluster(country);
outreg ln_gdp_pc using "$tablesdir\onestepTable2.out", nocons nolabel bdec(2) 3aster se br append;
reg wb_infant_mortality ln_gdp_pc dcountry* tcountry* t2country* t3country*, robust cluster(country);
outreg ln_gdp_pc using "$tablesdir\onestepTable2.out", nocons nolabel bdec(2) 3aster se br append;

*now the FE, let's see if this works;

xtreg wb_infant_mortality ln_gdp_pc tcountry*, fe i(mother) vce(cluster countrynum);
outreg ln_gdp_pc using "$tablesdir\onestepTable2.out", nocons nolabel bdec(2) 3aster se br append;
xtreg wb_infant_mortality ln_gdp_pc tcountry* t2country*, fe i(mother) vce(cluster countrynum);
outreg ln_gdp_pc using "$tablesdir\onestepTable2.out", nocons nolabel bdec(2) 3aster se br append;
xtreg wb_infant_mortality ln_gdp_pc tcountry* t2country* t3country*, fe i(mother) vce(cluster countrynum);
outreg ln_gdp_pc using "$tablesdir\onestepTable2.out", nocons nolabel bdec(2) 3aster se br append;


log close;


