/*doing the analysis for Table 6 cubic spec*/


#delimit ;
clear; program drop _all; drop _all;
set mem 2000m;
set matsize 2000;
cap log close;
set more off;
*global datadir="H:\DHS\data";
global datadir="L:\MacroCrises&DHS\";
global tablesdir="H:\DHS\Tables\Jed";
global logsdir="H:\DHS\Tables\Jed";
log using "$logsdir\onestepTable7.log", replace;

*local country count to take advantage of missing countries;
local numcountry = 59;

use "$datadir\data_for_onestage.dta", clear;

local covars "wb_aob wb_aob2 wb_aob3 wb_bord wb_bord2 wb_bord3 wb_years_edu wb_years_edu2 wb_years_edu3 wb_gender wb_twin wb_rural";
local onesd = .0344;


*rescaling;
replace wb_infant_mortality = 1000*wb_infant_mortality;

*generating the resids;
reg wb_infant_mortality dcountry* tcountry* t2country* t3country*, robust cluster(country);
predict IMR_detrend if e(sample), resid;

reg wb_infant_mortality dcountry* tcountry* t2country* t3country* if wb_gender == 0, robust cluster(country);
predict IMR_detrendM if e(sample) & wb_gender == 0, resid;

reg wb_infant_mortality dcountry* tcountry* t2country* t3country* if wb_gender == 1, robust cluster(country);
predict IMR_detrendF if e(sample) & wb_gender == 1, resid;


/*First knot at 0*/
local knot = 0*`onesd';

mkspline gdpbreak1 `knot' gdpbreak2 = ln_gdppc_cubic;

reg IMR_detrendM gdpbr*, robust cluster(country);
outreg gdpbr* using "$tablesdir\onestepTable7.out", nocons nolabel bdec(2) 3aster se br append;

reg IMR_detrendF gdpbr*, robust cluster(country);
outreg gdpbr* using "$tablesdir\onestepTable7.out", nocons nolabel bdec(2) 3aster se br append;

drop gdpbr*;

/*Now knots at -1,1 SDs*/

local knot1 = -1*`onesd';
local knot2 = `onesd';

mkspline gdpbreak1 `knot1' gdpbreak2 `knot2' gdpbreak3 = ln_gdppc_cubic;

reg IMR_detrendM gdpbr*, robust cluster(country);
outreg gdpbr* using "$tablesdir\onestepTable7.out", nocons nolabel bdec(2) 3aster se br append;

reg IMR_detrendF gdpbr*, robust cluster(country);
outreg gdpbr* using "$tablesdir\onestepTable7.out", nocons nolabel bdec(2) 3aster se br append;

drop gdpbr*;

/*Now knots at -1.5,1.5 SDs*/

local knot1 = -1.5*`onesd';
local knot2 = 1.5*`onesd';

mkspline gdpbreak1 `knot1' gdpbreak2 `knot2' gdpbreak3 = ln_gdppc_cubic;

reg IMR_detrendM gdpbr*, robust cluster(country);
outreg gdpbr* using "$tablesdir\onestepTable7.out", nocons nolabel bdec(2) 3aster se br append;

reg IMR_detrendF gdpbr*, robust cluster(country);
outreg gdpbr* using "$tablesdir\onestepTable7.out", nocons nolabel bdec(2) 3aster se br append;

drop gdpbr*;

/*Now knots at -2,2 SDs*/

local knot1 = -2*`onesd';
local knot2 = 2*`onesd';

mkspline gdpbreak1 `knot1' gdpbreak2 `knot2' gdpbreak3 = ln_gdppc_cubic;

reg IMR_detrendM gdpbr*, robust cluster(country);
outreg gdpbr* using "$tablesdir\onestepTable7.out", nocons nolabel bdec(2) 3aster se br append;

reg IMR_detrendF gdpbr*, robust cluster(country);
outreg gdpbr* using "$tablesdir\onestepTable7.out", nocons nolabel bdec(2) 3aster se br append;

drop gdpbr*;



log close;


