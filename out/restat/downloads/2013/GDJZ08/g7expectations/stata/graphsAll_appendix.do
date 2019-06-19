
clear
set more off
set mem 150m
*version 8.2
*version 9.1
#delimit;
set scheme s1mono;

local basepath "C:\Jirka\Research\g7expectations\g7expectations\";
cd "`basepath'stata/";

capture log close;
log using graphsAll_appendix.log, replace;

cd "`basepath'docs/paper/figures/appendix";

local Ccodes cn fr ge it jp uk us;

*Note graphsAll works only with "infl" as the measure of inflation, for other alternatives use graphs;
local variable infl gdp ip inv cons r3m un;
*local variable r3m;

global geBreak "1991M12";
global geBreakPlusOne "1992M01";
global itBreak "1992M07";
global itBreakPlusOne "1992M08";

foreach var of local variable {;

	* Read in the data;
	********************************************************************************;		

	* Load consensus data;
	use "`basepath'Data/___`var'_2xstacked.dta", clear;

	tsset id time, monthly;
	iis id; tis time;
	tsset;
	
	* Some transformations;
	********************************************************************************;		
	* Generate moving average inflation expectations;
	gen `var'4Q= ( (13-month)*`var'0 + (month-1)*`var'1 )/12;
	if "`var'"=="r3m" {; 	* Interest rate is different (fixed horizon);
		replace `var'4Q=`var'1; 
	};

	gen `var'4Ql12= L12.`var'4Q;		* shift inflation expectations a la the ECB paper;
	qui gen `var'_change = `var'-L12.`var';
	gen `var'4QeL12=L12.`var'4Q-`var';		* forecast errors;
	gen `var'f12=F12.`var';
	gen alt`var'f12=.;
	
	if "`var'"=="un" {;
		replace alt`var'f12=`var'f12 if tin(1985M01,1990M12)&country=="ge"; replace `var'f12=. if tin(1985M01,1991M01)&country=="ge";
		replace alt`var'f12=`var'f12 if tin(1985M01,1991M09)&country=="it"; replace `var'f12=. if tin(1985M01,1991M09)&country=="it";
	}; 
	
	label var `var'4Q "Expectations";
	label var `var' "Actual";
	label var `var'iqr4Q "IQR";
	label var `var'stdev4Q "St. Dev.";
	label var `var'mean4Q "Mean";
	label var `var'median4Q "Median";
	label var `var'nobs4Q "N. Obs.";


	qui gen yr=string(year-100*int(year/100));
	qui replace yr = "00" if yr=="0";
	qui replace yr = "01" if yr=="1";
	qui replace yr = "02" if yr=="2";
	qui replace yr = "03" if yr=="3";
	qui replace yr = "04" if yr=="4";
	qui replace yr = "05" if yr=="5";
	qui replace yr = "06" if yr=="6";

	gen maxRecession=.; gen minRecession=.;

	* Graph the consensus forecast;
	********************************************************************************;		
	local graphlist "";
	foreach C of local Ccodes {;
		qui sum `var'f12 if country=="`C'"&time~=.;
		sca max4Q=r(max);
		sca min4Q=r(min);
		replace maxRecession=.; replace minRecession=.;
		replace maxRecession=max4Q*recession if country=="`C'";;
		replace minRecession=min4Q*recession if country=="`C'";;

		local header = upper("`C'");
		local graphlist "`graphlist' Cons4Q`C'";
		graph twoway 
			(area minRecession time if country=="`C'", color(gs11)) 
	 		(area maxRecession time if country=="`C'", color(gs11))
			(line `var'mean4Q  `var'f12 t, clwidth(medthick medthick) lcolor(black gray)) if country=="`C'"&mod(id,100)==5, title(`header') name(Cons4Q`C') legend(off) xlabel(360(60)540,format(%tmCY)) xtitle("");
		graph save Cons4Q`C' Cons4Q`C', asis replace;
	};

	graph combine `graphlist', rows(2) cols(4) graphregion(margin(l=12 r=12)) 
				imargin(zero) scale(0.75) name(`var'Cons4Q);
	graph save `var'Cons4Q `var'Cons4Q, asis replace;
	graph export `var'Cons4Q.eps, replace;
	foreach C of local Ccodes {; erase Cons4Q`C'.gph; };


	* Number of respondents;
	********************************************************************************;		
	local graphlist "";
	foreach C of local Ccodes {;
		local header = upper("`C'");
		local graphlist "`graphlist' Nobs4Q`C'";
		graph twoway (bar `var'nobs4Q t) if country=="`C'"&mod(id,100)==5, title(`header') name(Nobs4Q`C') legend(off) yscale(range(0 36)) xlabel(360(60)540,format(%tmCY)) xtitle("");
		graph save Nobs4Q`C' Nobs4Q`C', asis replace;
	};

	graph combine `graphlist', rows(2) cols(4) graphregion(margin(l=12 r=12)) imargin(zero) scale(0.75) name(`var'Nobs4Q);
	graph save `var'Nobs4Q `var'Nobs4Q, asis replace;
	graph export `var'Nobs4Q.eps, replace;

	foreach C of local Ccodes {; erase Nobs4Q`C'.gph; };
	graph drop _all;

};

drop _all;


*****************************************************************************************;
** New data set;
*****************************************************************************************;
* Read in the data;
********************************************************************************;		

* Load consensus data;
use "`basepath'Data/disagreementAggr.dta", replace;
*gen time=_n+299;

tsset time, monthly;

* Some transformations;
********************************************************************************;		
gen maxRecession=.; gen minRecession=.;
qui gen yr=string(year-100*int(year/100));
qui replace yr = "00" if yr=="0";
qui replace yr = "01" if yr=="1";
qui replace yr = "02" if yr=="2";
qui replace yr = "03" if yr=="3";
qui replace yr = "04" if yr=="4";
qui replace yr = "05" if yr=="5";
qui replace yr = "06" if yr=="6";

* Graph Output gaps and GDP;
********************************************************************************;		
local graphlist "";
foreach C of local Ccodes {;
	qui sum `C'outputGapExpost if time~=.;
	sca max4Q=ceil(r(max));
	sca min4Q=floor(r(min));
	qui sum `C'outputGapInit if time~=.;
	sca max4Q=max(ceil(r(max)),max4Q);
	sca min4Q=min(floor(r(min)),min4Q,0);
	replace maxRecession=.; replace minRecession=.;
	replace maxRecession=max4Q*`C'Recession;
	replace minRecession=min4Q*`C'Recession;
	local header = upper("`C'");
	local graphlist "`graphlist' gap`C'";
	graph twoway 
		(area minRecession time, color(gs11)) 
		(area maxRecession time, color(gs11))
		(line `C'gdp time, lpattern(-) clwidth(medium) lcolor(black))
		(line `C'outputGapExpost `C'outputGapInit time, 
		clpattern(l) clwidth(medthick) lcolor(black)), title(`header') name(gap`C') legend(off) xtitle("") xlabel(360(60)540,format(%tmCY));

	graph save gap`C' gap`C', asis replace;

};

graph combine `graphlist', rows(2) cols(4) graphregion(margin(l=12 r=12)) 
			imargin(zero) scale(0.75) name(gapAll);
graph save gapAll gapAll, asis replace;
graph export gapAll.eps, replace;

foreach C of local Ccodes {; erase gap`C'.gph; };
graph drop _all;

* UCSV uncertainty;
*****************************************************************************************************;
foreach var of local variable {;
        
        sca max4Q=0;
	foreach C of local Ccodes {;
	        gen d`C'`var'Sq=(`C'`var'-L12.`C'`var')^2;
		qui sum d`C'`var'Sq if time~=.;
		sca max4Qtemp=(r(max));
		sca max4Q=max(max4Q,max4Qtemp);
		};

	local graphlist "";
	foreach C of local Ccodes {;
		sca min4Q=0;
		replace maxRecession=.; replace minRecession=.;
		replace maxRecession=max4Q*`C'Recession;
		replace minRecession=min4Q*`C'Recession;
		local header = upper("`C'");
		local graphlist "`graphlist' `C'`var'varepsilon";
		graph twoway 
			(area minRecession time, color(gs11)) 
			(area maxRecession time, color(gs11))
			(line d`C'`var'Sq time, c(l) yaxis(1) clwidth(medthick) lcolor(black))
			(line `C'`var'varepsilon `C'`var'vareta time, 
			clpattern(dash dot) yaxis(2) clwidth(medthick) lcolor(black)), title(`header') name(`C'`var'varepsilon) legend(off) xtitle("") xlabel(360(60)540,format(%tmCY));

		graph save `C'`var'varepsilon `C'`var'varepsilon, asis replace;
	};

	graph combine `graphlist', rows(2) cols(4) graphregion(margin(l=12 r=12)) 
				imargin(zero) scale(0.75) name(`var'varAll);
	graph save `var'varAll `var'varAll, asis replace;
	graph export `var'varAll.eps, replace;

	foreach C of local Ccodes {; erase `C'`var'varepsilon.gph; };
	graph drop _all;
};


sca correlAv=0; sca counter=0;
foreach var of local variable {;

	foreach C of local Ccodes {;

		correl d`C'`var'Sq `C'`var'varepsilon if tin($startSmpl,$endSmpl); 
		sca correlTemp=r(rho);
		sca correlAv=correlAv+correlTemp;
		sca counter=counter+1;
	};

};

sca correlAv=correlAv/counter;
disp "Average Correlation Bw Perm variance and Delta x Squared: " correlAv;

*****************************************************************************;

cd "`basepath'stata/";
log close;
