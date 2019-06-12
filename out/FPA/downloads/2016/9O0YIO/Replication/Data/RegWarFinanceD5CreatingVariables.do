# delimit ;
clear;
*version 13;
set matsize 400;
set more off;



log using "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Data/CreatingVariables.log", replace;

*********************************************************************;
*Author: Jeff Carter                                                *;
*Date: Sunday, December 7, 2014                                      *;
*Purpose: Creating Variables    *;
***********************************************************************;


*** Data Set 1  ***;
use "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Data/RegWarFinanceD5-imp1.dta", clear;

gen warduration2 = warduration^2;
gen warduration3 = warduration^3;

gen polity_war = polity2*war;

gen polity_duration = polity2*warduration;
gen polity_duration2 = polity2*warduration2;
gen polity_duration3 = polity2*warduration3;

replace warduration = warduration/10;
replace warduration2 = warduration2/10;
replace warduration3 = warduration3/10;

replace polity_duration = polity_duration/10;
replace polity_duration2 = polity_duration2/10;
replace polity_duration3 = polity_duration3/10;

rename polity2 polity;

gen polity_territorial = polity*territorialwar;

gen war_territorial = war*territorial;

replace inflation = log(inflation);

replace relcap = (relcap*-1)+1 if relcap !=0;

gen polity_war_relcap = polity*war*relcap;

xtset ccode year;

replace milex = exp(milex);
replace milex = milex/1000000;
gen dmilex=d.milex;
gen polity_dmilex = polity*dmilex;
gen war_dmilex = war*dmilex;
gen polity_war_dmilex=polity*war*dmilex;

sum;
saveold "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Data/RegWarFinanceD5-imp1.dta", replace;

clear;


*** Data Set 2  ***;
use "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Data/RegWarFinanceD5-imp2.dta", clear;

gen warduration2 = warduration^2;
gen warduration3 = warduration^3;

gen polity_war = polity2*war;

gen polity_duration = polity2*warduration;
gen polity_duration2 = polity2*warduration2;
gen polity_duration3 = polity2*warduration3;

replace warduration = warduration/10;
replace warduration2 = warduration2/10;
replace warduration3 = warduration3/10;

replace polity_duration = polity_duration/10;
replace polity_duration2 = polity_duration2/10;
replace polity_duration3 = polity_duration3/10;

rename polity2 polity;

gen polity_territorial = polity*territorialwar;

gen war_territorial = war*territorial;

replace inflation = log(inflation);

replace relcap = (relcap*-1)+1 if relcap !=0;

gen polity_war_relcap = polity*war*relcap;

xtset ccode year;

replace milex = exp(milex);
replace milex = milex/1000000;
gen dmilex=d.milex;
gen polity_dmilex = polity*dmilex;
gen war_dmilex = war*dmilex;
gen polity_war_dmilex=polity*war*dmilex;

sum;
saveold "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Data/RegWarFinanceD5-imp2.dta", replace;

clear;


*** Data Set 3  ***;
use "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Data/RegWarFinanceD5-imp3.dta", clear;

gen warduration2 = warduration^2;
gen warduration3 = warduration^3;

gen polity_war = polity2*war;

gen polity_duration = polity2*warduration;
gen polity_duration2 = polity2*warduration2;
gen polity_duration3 = polity2*warduration3;

replace warduration = warduration/10;
replace warduration2 = warduration2/10;
replace warduration3 = warduration3/10;

replace polity_duration = polity_duration/10;
replace polity_duration2 = polity_duration2/10;
replace polity_duration3 = polity_duration3/10;

rename polity2 polity;

gen polity_territorial = polity*territorialwar;

gen war_territorial = war*territorial;

replace inflation = log(inflation);

replace relcap = (relcap*-1)+1 if relcap !=0;

gen polity_war_relcap = polity*war*relcap;

xtset ccode year;

replace milex = exp(milex);
replace milex = milex/1000000;
gen dmilex=d.milex;
gen polity_dmilex = polity*dmilex;
gen war_dmilex = war*dmilex;
gen polity_war_dmilex=polity*war*dmilex;

sum;
saveold "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Data/RegWarFinanceD5-imp3.dta", replace;

clear;


*** Data Set 4  ***;
use "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Data/RegWarFinanceD5-imp4.dta", clear;

gen warduration2 = warduration^2;
gen warduration3 = warduration^3;

gen polity_war = polity2*war;

gen polity_duration = polity2*warduration;
gen polity_duration2 = polity2*warduration2;
gen polity_duration3 = polity2*warduration3;

replace warduration = warduration/10;
replace warduration2 = warduration2/10;
replace warduration3 = warduration3/10;

replace polity_duration = polity_duration/10;
replace polity_duration2 = polity_duration2/10;
replace polity_duration3 = polity_duration3/10;

rename polity2 polity;

gen polity_territorial = polity*territorialwar;

gen war_territorial = war*territorial;

replace inflation = log(inflation);

replace relcap = (relcap*-1)+1 if relcap !=0;

gen polity_war_relcap = polity*war*relcap;

xtset ccode year;

replace milex = exp(milex);
replace milex = milex/1000000;
gen dmilex=d.milex;
gen polity_dmilex = polity*dmilex;
gen war_dmilex = war*dmilex;
gen polity_war_dmilex=polity*war*dmilex;

sum;
saveold "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Data/RegWarFinanceD5-imp4.dta", replace;

clear;


*** Data Set 5  ***;
use "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Data/RegWarFinanceD5-imp5.dta", clear;

gen warduration2 = warduration^2;
gen warduration3 = warduration^3;

gen polity_war = polity2*war;

gen polity_duration = polity2*warduration;
gen polity_duration2 = polity2*warduration2;
gen polity_duration3 = polity2*warduration3;

replace warduration = warduration/10;
replace warduration2 = warduration2/10;
replace warduration3 = warduration3/10;

replace polity_duration = polity_duration/10;
replace polity_duration2 = polity_duration2/10;
replace polity_duration3 = polity_duration3/10;

rename polity2 polity;

gen polity_territorial = polity*territorialwar;

gen war_territorial = war*territorial;

replace inflation = log(inflation);

replace relcap = (relcap*-1)+1 if relcap !=0;

gen polity_war_relcap = polity*war*relcap;

xtset ccode year;

replace milex = exp(milex);
replace milex = milex/1000000;
gen dmilex=d.milex;
gen polity_dmilex = polity*dmilex;
gen war_dmilex = war*dmilex;
gen polity_war_dmilex=polity*war*dmilex;

sum;
saveold "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Data/RegWarFinanceD5-imp5.dta", replace;

clear;


