#delimit;
clear;
set mem 550M;

/* This table requires the use of data from Bureau van Dijk's Amadeus database; see instructions below */

/* create constraint veriables for Amadeus firms; constraints are responses averaged by country 2 digit sector, size and year */

use data\final_data;

log using "$logs/table5.txt", text replace


local variables2 = "constrqA constrqB constrqD constrqE constrqF constrqG constrqH constrqJ constrqK constrqL constrqM constrqN constrqO
			constrqP constrqC constrqALL15";
			
foreach var of local variables2 {;
	egen BI_`var' = mean(`var'), by(country_name prod2DIG sizeb year);
	};

contract country_name prod2DIG sizeb year BI_*;
rename prod2DIG sector;
rename sizeb size;
rename country_name country;
rename year c_year;
sort country c_year sector size;
save data\ad_constraints, replace;

/* To estimate the regressions in table 5, a file with the following information from firms in Amadeus is needed (because of data availability restrictions
	the paper uses :
	- identifying information: country, year, 2-digit sector (derived from uscor; drop sectors <= 10 and >= 94)
	- ownership information organized as follows (uotype is the ultimate owner type in Amadeus and ulholcou is the 2 letter country code of the ultimate
		owner of a cirm, the cntrycde is the country code of the firm):
		gen owner = 1 if uotype == "Individual(s) or family(ies)";
		replace owner = 2 if uotype == "Financial company" | uotype == "Bank" | uotype == "Insurance company" | uotype == "Mutual & Pension fund/Trust/Nominee";
		replace owner = 3 if uotype == "State, Public authority";
		replace owner = 4 if uotype == "Industrial company";
		replace owner = 5 if uotype == "Foundation" | uotype == "Employees/Managers";
		gen foreign = (ulholcou != cntrycde & ulholcou != "n.a.");
	- accounting information (variable names in parentheses: Turnover (turn), Employees (empl), Total assets (toas), Exports (expt), as well as the number
		of months the accounts are for (months), the units they are in (unit) and the USD exchange rate (exrate_u)
	- a variable c_year (to merge Amadeus data with the 2002 constraints in years 2002 and earlier and with the 2005 constraints in later years):
		gen c_year = 2002 if year <=2002;
		replace c_year = 2005 if year > 2002;

*/

****************;
use id_numbe turn empl toas expt country year months unit exrate_u sector using data\ad_data_final if year > 1997;
sort id_numbe;

merge id_numbe using data\ad_own_final;
keep if _merge == 3;
drop _merge;

gen size = 1 if empl < 50;
replace size = 2 if empl < 200 & size ==.;
replace size = 3 if empl < 10000 & size ==.;
drop if year ==.;
drop if size ==.;


gen c_year = 2002 if year <=2002;
replace c_year = 2005 if year > 2002;
sort country c_year sector size;

merge country c_year sector size using data\ad_constraints;
keep if _merge == 3;

drop _merge;
**********************;
/*
merge country c_year sector size using data\AMADEUS
*/

local prod "empl toas exp";
local own "i.owner foreign";
local dummies "i.country*i.year";

local cluster "country c_year sector size";

local constr = "BI_constrqA BI_constrqB  BI_constrqC BI_constrqD BI_constrqE BI_constrqF BI_constrqG BI_constrqH BI_constrqJ BI_constrqK BI_constrqL
	BI_constrqM BI_constrqN BI_constrqO BI_constrqP BI_constrqALL15";
local constr2 = "BI_constrqB  BI_constrqC BI_constrqD BI_constrqF BI_constrqG BI_constrqK BI_constrqM BI_constrqN BI_constrqP";
	
label variable BI_constrqA  "ACCESS TO FINANCING";
label variable BI_constrqB  "COST OF FINANCING";
label variable BI_constrqC  "INFRASTRUCTURE";
label variable BI_constrqD  "TAX RATES";
label variable BI_constrqE  "TAX ADMINISTRATION";
label variable BI_constrqF  "CUSTOM/FOREIGN TRADE REGULATIONS";
label variable BI_constrqG  "BUSINESS LICENCING & PERMIT";
label variable BI_constrqH  "LABOUR REGULATIONS";
label variable BI_constrqJ  "UNCERTAINTY ABOUT REGULATORY POLICIES";
label variable BI_constrqK  "MACROECONOMIC INSTABILITY";
label variable BI_constrqL  "FUNCTIONING OF THE JUDICIARY";
label variable BI_constrqM  "CORRUPTION";
label variable BI_constrqN  "STREET CRIME THEFT & DISORDER";
label variable BI_constrqO  "ORGANISED CRIME MAFIA";
label variable BI_constrqP  "ANTI-COMPETITIVE PRACTICES";


egen clstr = group(`cluster');

drop if empl ==. | toas ==. | turn ==.;
drop if country == "Macedonia" | country == "Slovenia" | country == "Hungary";

foreach var of varlist empl toas turn expt{;
	replace `var' = ln(`var'*(12/months)*(10^unit)) if `var' !=.;
	};
	
gen exp = (expt > 0 & expt !=.);


xi: regress turn `prod' `own' `constr2' `dummies', cluster(clstr);
	xi: outreg2 `prod' `own' `constr2' using "$tables\table5", replace bdec(3) se aster(se) bracket label;

xi: regress turn `prod' `own' `dummies', cluster(clstr);
	xi: outreg2 `prod' `own' using "$tables\table5", append bdec(3) se aster(se) bracket label;


foreach var of varlist `constr2'{;
xi: regress turn `prod' `own' `var' `dummies', cluster(clstr);
	xi: outreg2 `prod' `own' `var' using "$tables\table5", append bdec(3) se aster(se) bracket label;
	};
	
xi: regress turn `prod' `own' BI_constrqALL15 `dummies', cluster(clstr);
	xi: outreg2 `prod' `own' BI_constrqALL15 using "$tables\table5", append bdec(3) se aster(se) bracket label;

xi: regress turn `prod' `own' `constr2' `dummies', cluster(clstr);
	xi: outreg2 `prod' `own' `constr2' using "$tables\table5", append bdec(3) se aster(se) bracket label;


log close
