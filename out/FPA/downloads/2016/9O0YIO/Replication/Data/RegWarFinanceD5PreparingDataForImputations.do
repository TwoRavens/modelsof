# delimit ;
clear;
*version 13;
set matsize 400;
set more off;



log using "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Data/PreparingDataForImputations.log", replace;

*********************************************************************;
*Author: Jeff Carter                                                *;
*Date: Saturday, December 6, 2014                                        *;
*Purpose: Preparing Data for Imputations for War Finance Paper     *;
*********************************************************************;

use "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Data/RegWarFinanceD5Merged.dta", clear;

xtset ccode year;

keep  ccode year abbrev v_gdp cap milex energy rgdp96pc region1 number polity2 war rpe_gdp v_g q_g q_gdp xr taxratio totrev realdebt2 territorialwar relcap ;

*** Addressing Missing Values  ***;

replace milex = . if milex == -9;
replace energy = . if energy == -9;
replace number = . if number == -9;
replace polity2 = . if polity2 < -10;
replace rgdp96pc = . if rgdp96pc == -9;
replace cap = . if cap == -9;

** Setting Variables in Number of US Dollars ;
replace milex = milex*1000;  *current US Dollars;
replace v_gdp = v_gdp*1000000; *current national currency;
replace q_gdp = q_gdp*1000000; *constant 2005 national currency;
gen deflator = (v_gdp/q_gdp)*100;
gen v_gdpUS = v_gdp/xr; *current US dollars;
gen q_gdpUS = q_gdp/xr; *constant 2005 US dollars;

replace v_g=v_g*1000000; *in current national currency;
replace v_g=v_g/xr; * in current US dollars;
replace q_g=q_g*1000000; *in constant national currency;

*** Creating Variables ***;

* Spending Distribution ;


gen distribution =  milex/v_g;
replace distribution = 1-distribution;
replace distribution = distribution*100;
replace distribution = . if distribution <0;

* Non-Military Spending  ;

gen nonmil = v_g-milex;
replace nonmil = . if nonmil <0;
replace nonmil = log(nonmil);


* Taxes ;

gen taxrev = taxratio*q_gdp;
replace taxratio = taxratio*100;
replace taxrev = log(taxrev);

*Debt *;

rename realdebt2 debt;
replace debt = log(debt);


* Deficit *;

gen revenue = totrev*q_gdp;
gen revbalance = revenue-q_g;
gen revbalanceratio = revbalance/q_gdp;
replace revenue = log(revenue);
*replace revbalance = revbalance/1000000000;


* Inflation *;
gen nominalgrowth = ((D.v_gdp)/l.v_gdp)*100;
gen realgrowth = ((D.q_gdp)/l.q_gdp)*100;
gen inflation = nominalgrowth-realgrowth;

* War Duration ;

gen peace = 0;
replace peace = 1 if war == 0;
btscs peace year ccode, gen(warduration);
replace warduration = warduration+1 if war == 1;
replace warduration = 0 if peace == 1;

* Polity2 ;

replace polity2 = polity2 + 10;


* GDP per capita ;

rename rgdp96pc gdppc;
replace gdppc = log(gdppc);


* GDP *;

rename q_gdp gdp;
replace gdp = log(gdp);

* Military Spending *;
replace milex = log(milex);


* Regional Dummies ;

gen Americas = 0;
replace Americas = 1 if region1 == 5;

gen Africa = 0;
replace Africa = 1 if region1 == 3;

gen MiddleEast = 0;
replace MiddleEast = 1 if region1 == 2;

gen Asia = 0;
replace Asia = 1 if region1 ==4;



drop abbrev  energy region1 v_g v_gdp q_g deflator nominalgrowth v_gdpUS q_gdpUS peace xr;

saveold "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Data/RegWarFinanceD5.dta", replace;
