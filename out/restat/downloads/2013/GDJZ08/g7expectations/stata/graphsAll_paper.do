

* Subset of graphs as they appear in the paper

clear
set more off
set mem 150m
*version 8.2
*version 9.1
#delimit;
set scheme s1mono;


local basepath "C:/Jirka/Research/g7expectations/g7expectations/";
cd "`basepath'stata/";

capture log close;
log using graphsAll_paper.log, replace;


cd "`basepath'stata/graphs";

local Ccodes cn fr ge it jp uk us;
*local Ccodes it;

*Note graphsAll works only with "infl" as the measure of inflation, for other alternatives use graphs;
local variable infl gdp ip inv cons r3m un;
*local variable r3m;
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

	* Graph of individual forecasts and the underlying variable;
	********************************************************************************;		
	sort time;
	local graphlist "";
	foreach C of local Ccodes {;
		qui sum `var'f12 if country=="`C'"&time~=.;
		sca max4Q=ceil(r(max));
		sca min4Q=min(0,floor(r(min)));
		qui sum `var'4Q if country=="`C'"&time~=.;
		sca max4Q=max(ceil(r(max)),max4Q);
		sca min4Q=min(floor(r(min)),min4Q);
		global min4Q=min4Q; global max4Q=max4Q;
		replace maxRecession=.; replace minRecession=.;
		replace maxRecession=max4Q*recession if country=="`C'";
		replace minRecession=min4Q*recession if country=="`C'";
		local header = upper("`C'");
		local graphlist "`graphlist' Exp4Q`C'";
		graph twoway 
			(area minRecession time if country=="`C'", color(gs11)) 
		 	(area maxRecession time if country=="`C'", color(gs11))
		 	(scatter `var'4Q time if country=="`C'", msize(tiny) xtitle(""))
		 	(line alt`var'f12 time if country=="`C'"&mod(id,100)==5, clpattern(l) clwidth(medthick) lcolor(black))
			(line `var'f12 time if country=="`C'"&mod(id,100)==5, 
		 	clpattern(l) clwidth(medthick) lcolor(black)), title(`header') name(Exp4Q`C') yscale(range($min4Q $max4Q)) legend(off) xlabel(360(60)540,format(%tmCY));
 
		*(scatter `var'4QeL12 time if country=="`C'", msize(vsmall) xtitle(""));
		graph save Exp4Q`C' Exp4Q`C', asis replace;
	};

	graph combine `graphlist', rows(2) cols(4) graphregion(margin(l=12 r=12)) 
				imargin(zero) scale(0.75) name(`var'Exp4Q);
	graph save `var'Exp4Q `var'Exp4Q, asis replace;
	graph export `var'Exp4Q.eps, replace;
	
	foreach C of local Ccodes {; erase Exp4Q`C'.gph; };

	graph drop _all;
	
	* Graph the IQR;
	********************************************************************************;		
	local graphlist "";
	foreach C of local Ccodes {;
		qui sum `var'iqr4Q if time~=.;
		sca max4Q=r(max);
		sca min4Q=r(min);
		global max4Q=max4Q;
		global yStep=0.25;
		if "`var'"=="inv" {; global yStep=0.5; };
		replace maxRecession=.; replace minRecession=.;
		replace maxRecession=max4Q*recession if country=="`C'"; * so that the area goes all the way to 1;
		replace minRecession=recession if country=="`C'";

		local header = upper("`C'");
		local graphlist "`graphlist' Disp4Q`C'";
		graph twoway 
			(area maxRecession time if country=="`C'", color(gs11))
			(line `var'iqr4Q t, clwidth(medthick medthick) lcolor(black gray)) if country=="`C'"&mod(id,100)==5, title(`header') name(Disp4Q`C') legend(off) yscale(range(0 1.0)) xlabel(360(60)540,format(%tmCY))  xtitle("") ylabel(0($yStep)$max4Q);
		graph save Disp4Q`C' Disp4Q`C', asis replace;
		
	};

	graph combine `graphlist', rows(2) cols(4) graphregion(margin(l=12 r=12)) 
				imargin(zero) scale(0.75) name(`var'Disp4Q);
	graph save `var'Disp4Q `var'Disp4Q, asis replace;
	graph export `var'Disp4Q.eps, replace;

	foreach C of local Ccodes {; erase Disp4Q`C'.gph; };

	graph drop _all;
	



};

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

* UCSV uncertainty;
*****************************************************************************************************;
foreach var of local variable {;
        
        sca max4Q=0;
	foreach C of local Ccodes {;
		replace `C'`var'varepsilon=`C'`var'varepsilon^2;
		replace `C'`var'vareta=`C'`var'vareta^2;
		qui sum `C'`var'varepsilon if time~=.;
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
			(line `C'`var'varepsilon time, 
			clpattern(l) clwidth(medthick) lcolor(black)), title(`header') name(`C'`var'varepsilon) legend(off) xtitle("") xlabel(360(60)540,format(%tmCY));

		graph save `C'`var'varepsilon `C'`var'varepsilon, asis replace;
	};

	graph combine `graphlist', rows(2) cols(4) graphregion(margin(l=12 r=12)) 
				imargin(zero) scale(0.75) name(`var'varepsilon);
	graph save `var'varepsilon `var'varepsilon, asis replace;
	graph export `var'varepsilon.eps, replace;

	foreach C of local Ccodes {; erase `C'`var'varepsilon.gph; };
	graph drop _all;
};

*****************************************************************************;

cd "`basepath'stata/";
log close;

