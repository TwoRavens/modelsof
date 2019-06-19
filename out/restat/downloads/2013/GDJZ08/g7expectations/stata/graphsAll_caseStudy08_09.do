

* This programs draw histograms for each year-month (variable and country)

clear
set more off
set mem 150m
*version 8.2
*version 9.1
#delimit;
set scheme s1mono;

local basepath "C:\Jirka\Research\g7expectations\g7expectations\";
cd "`basepath'stata\";

capture log close;
log using graphsAll_caseStudy08_09.do.log, replace;

cd "`basepath'stata/graphs";

local Ccodes cn fr ge it jp uk us ea;
local variable infl gdp ip inv cons un r3m;	

********************************************************************************;
**************  Figure 20 (Disagreement plot);

* Load consensus data;
use "`basepath'Data//dataUpdate_april15/disagreementAggr_all.dta", replace;

tsset time, monthly;

* Some transformations;
********************************************************************************;		
qui gen yr=string(year-100*int(year/100));
qui replace yr = "00" if yr=="0";
qui replace yr = "01" if yr=="1";
qui replace yr = "02" if yr=="2";
qui replace yr = "03" if yr=="3";
qui replace yr = "04" if yr=="4";
qui replace yr = "05" if yr=="5";
qui replace yr = "06" if yr=="6";
qui replace yr = "07" if yr=="7";
qui replace yr = "08" if yr=="8";
qui replace yr = "09" if yr=="9";

gen ear3miqr=.; gen ear3mmean=.;
gen maxRecession=.; gen minRecession=.;

* The recession indicator;
foreach C of local Ccodes {;
	gen `C'Recession=0;
	gen `C'Mlabel="";
	replace `C'Mlabel=yr if year>2007;
	};
	
replace usMlabel=yr if year>2007;

* Canada not yet in recession [Apr 09];
global cnStartRec "2009m3";
global frStartRec "2008m2";
global geStartRec "2008m4";
global itStartRec "2007m8";
global jpStartRec "2008m2";
global ukStartRec "2008m5";
global usStartRec "2007m12";
global eaStartRec "2008m1";

replace frRecession=1 if tin($frStartRec,2009m3);
replace geRecession=1 if tin($geStartRec,2009m3);
replace itRecession=1 if tin($itStartRec,2009m3);
replace jpRecession=1 if tin($jpStartRec,2009m3);
replace ukRecession=1 if tin($ukStartRec,2009m3);
replace usRecession=1 if tin($usStartRec,2009m3);
replace eaRecession=1 if tin($eaStartRec,2009m3);

*****************************************************************************;
* Disagreement (Figure 20);
*****************************************************************************************************;
sca maxTemp=0;

foreach C of local Ccodes {;
	qui sum `C'gdpiqr if tin(2007m1,2009m3);
	sca maxTemp0=(r(max));
	sca maxTemp=max(maxTemp,maxTemp0);

};

global maxTemp=maxTemp;
global xStep=0.5;

local graphlist "";
foreach C of local Ccodes {;
	local header = upper("`C'");
	local graphlist "`graphlist' `C'gdpinfldisagr_post06";
	global startRec1 "`C'StartRec"; global startRec $$startRec1;		

	graph twoway 
		(scatteri $maxTemp `=m($startRec)' $maxTemp  `=m(2009m3)' if tin(2007m1,2009m3), bcolor(gs11) recast(area))
		(line `C'infliqr time if tin(2007m1,2009m3), clwidth(medthin) lcolor(black))
		(line `C'gdpiqr time if tin(2007m1,2009m3), 
		clpattern(l) clwidth(medthick) lcolor(black)), title(`header') name(`C'gdpinfldisagr_post06) legend(off) xtitle("") ytitle("") yscale(r(0 $maxTemp)) ylabel(0($xStep)$maxTemp) xlabel(564(12)588,format(%tmCY))  xmtick(564(1)590);

	graph save `C'gdpinfldisagr_post06 `C'gdpinfldisagr_post06, asis replace;
};

graph combine `graphlist', rows(2) cols(4) graphregion(margin(l=12 r=12)) 
			imargin(zero) scale(0.75) name(gdpinfldisagr_post06);
graph save gdpinfldisagr_post06 gdpinfldisagr_post06, asis replace;
graph export gdpinfldisagr_post06.eps, replace;

foreach C of local Ccodes {; erase `C'gdpinfldisagr_post06.gph; };
graph drop _all;


* Kernels (Figures 21, 22 and others);
*******************************************************;
cd "`basepath'\Stata\Graphs\";
set scheme s2color;

foreach var of local variable {;

	* Read in the data;
	********************************************************************************;		
	use "`basepath'Data/dataUpdate_april15/___`var'_2xstacked.dta", clear;

	tsset id time, monthly;
	iis id; tis time;
	tsset;

	gen `var'4Q= ( (13-month)*`var'0 + (month-1)*`var'1 )/12;
	
	local graphlist "";

	foreach C of local Ccodes {;
	
		if "`C'"~="ea"|"`var'"~="r3m" {; * No observations on euro area interest rates!;

			sum `var'4Q if country=="`C'";
			global xMax=round(r(max)+.5);
			global xMin=round(r(min)-.5);
			*set scheme s2color;
			local header = upper("`C'`var'");
				
			global xlabStart=-6; global xlabEnd=5;
			/*if "`var'"=="gdp" {; global xlabStart=-6; global xlabEnd=3; };
			if "`var'"=="infl" {; global xlabStart=-3; global xlabEnd=5; };
			*/;

			graph twoway 
			(kdensity `var'4Q if year==2007 & (month==6) & country=="`C'", xscale(range(-4 3)) xlabel($xlabStart(1)$xlabEnd, labsize(vsmall)) xtitle("") ytitle("") ylabel(,labsize(vsmall))) 
			(kdensity `var'4Q if year==2008 & (month==9) & country=="`C'", xscale(range(-4 3)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
			(kdensity `var'4Q if year==2008 & (month==10) & country=="`C'", xscale(range(-4 3)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
			(kdensity `var'4Q if year==2008 & (month==11) & country=="`C'", xscale(range(-4 3)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
			(kdensity `var'4Q if year==2008 & (month==12) & country=="`C'", xscale(range(-4 3)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
			(kdensity `var'4Q if year==2009 & (month==1) & country=="`C'", xscale(range(-4 3)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
			(kdensity `var'4Q if year==2009 & (month==2) & country=="`C'", xscale(range(-4 3)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
			(kdensity `var'4Q if year==2009 & (month==3) & country=="`C'", xscale(range(-4 3)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")),
			 title(`header', size(small)) 
			name(`C'`var'CaseMthlySelection) legend(off) plotr(fcolor(white) lcolor(white)) graphr(fcolor(white) lcolor(white)) 		legend(cols(4) lab(1 "2007M6") lab(2 "2008M1") lab(3 "2008M4") lab(4 "2008M7") lab(5 "2008M8") lab(6 "2008M9") lab(7 "2008M10") lab(8 "2008M11") lab(9 "2008M12") lab(10 "2009M1") lab(11 "2009M2") lab(12 "2009M3"));

			graph save `C'`var'CaseMthlySelection `C'`var'CaseMthlySelection, asis replace;
			*graph export `C'`var'CaseMthlySelection.eps, replace;

			local graphlist "`graphlist' `C'`var'CaseMthlySelection";
		};

	};
	 
	grc1leg `graphlist', rows(4) cols(2) graphregion(margin(l=12 r=12)) imargin(zero) scale(0.75) name(`var'CaseMthlySelection) xcommon  graphr(fcolor(white) lcolor(white)) plotr(fcolor(white) lcolor(white));
	
	graph save `var'CaseMthlySelection `var'CaseMthlySelection, asis replace;
	graph export `var'CaseMthlySelection.eps, replace;
	
	if "`var'"=="r3m" {; line r3m4Q t, name(ear3mCaseMthlySelection); 
	graph save ear3mCaseMthlySelection ear3mCaseMthlySelection, asis replace;
	}; * draw a dummy r3m figure for the euro area;
	
	foreach C of local Ccodes {; erase `C'`var'CaseMthlySelection.gph; };
	
};

gr combine eagdpCaseMthlySelection eainflCaseMthlySelection usgdpCaseMthlySelection usinflCaseMthlySelection, rows(2) cols(2) graphregion(margin(l=12 r=12)) imargin(zero) scale(0.75) name(bigCCaseMthlySelectionEaUS) xcommon  graphr(fcolor(white) lcolor(white)) plotr(fcolor(white) lcolor(white));

graph save bigCCaseMthlySelectionEaUS bigCCaseMthlySelectionEaUS, asis replace;
graph export bigCCaseMthlySelectionEaUS.eps, replace;

grc1leg eagdpCaseMthlySelection eainflCaseMthlySelection usgdpCaseMthlySelection usinflCaseMthlySelection ukgdpCaseMthlySelection ukinflCaseMthlySelection jpgdpCaseMthlySelection jpinflCaseMthlySelection, rows(4) cols(2) graphregion(margin(l=12 r=12)) imargin(zero) scale(0.75) name(bigCCaseMthlySelection) xcommon  graphr(fcolor(white) lcolor(white)) plotr(fcolor(white) lcolor(white));

graph save bigCCaseMthlySelection bigCCaseMthlySelection, asis replace;
graph export bigCCaseMthlySelection.eps, replace;

grc1leg gegdpCaseMthlySelection geinflCaseMthlySelection frgdpCaseMthlySelection frinflCaseMthlySelection itgdpCaseMthlySelection itinflCaseMthlySelection cngdpCaseMthlySelection cninflCaseMthlySelection, rows(4) cols(2) graphregion(margin(l=12 r=12)) imargin(zero) scale(0.75) name(otherCCaseMthlySelection) xcommon  graphr(fcolor(white) lcolor(white)) plotr(fcolor(white) lcolor(white));

graph save otherCCaseMthlySelection otherCCaseMthlySelection, asis replace;
graph export otherCCaseMthlySelection.eps, replace;

******** Individual plots for slides;
*****************************************************************************************************;
drop _all;
local variable gdp;	


foreach var of local variable {;

	* Read in the data;
	********************************************************************************;		
	use "`basepath'Data/dataUpdate_april15/___`var'_2xstacked.dta", clear;

	tsset id time, monthly;
	iis id; tis time;
	tsset;

	gen `var'4Q= ( (13-month)*`var'0 + (month-1)*`var'1 )/12;


	/*
	global xlabStart=0; global xlabEnd=4; label var infl4Q "";

	graph twoway 
	(kdensity infl4Q if year==2007 & (month==6) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd, labsize(vsmall)) xtitle("") ytitle("") ylabel(,labsize(vsmall))) 
	(kdensity infl4Q if year==2007 & (month==9) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity infl4Q if year==2007 & (month==10) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity infl4Q if year==2008 & (month==1) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity infl4Q if year==2008 & (month==4) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity infl4Q if year==2008 & (month==7) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity infl4Q if year==2008 & (month==8) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity infl4Q if year==2008 & (month==9) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity infl4Q if year==2008 & (month==10) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity infl4Q if year==2008 & (month==11) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity infl4Q if year==2008 & (month==12) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity infl4Q if year==2009 & (month==1) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity infl4Q if year==2009 & (month==2) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity infl4Q if year==2009 & (month==3) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")),
	name(eainflCaseMthlySelectionAll) legend(cols(4) lab(1 "2007M6") lab(2 "2007M9") lab(3 "2007M10") lab(4 "2008M1") lab(5 "2008M4") lab(6 "2008M7")  lab(7 "2008M8") lab(8 "2008M9")lab(9 "2008M10") lab(10 "2008M11") lab(11 "2008M12") lab(12 "2009M1") lab(13 "2009M2") lab(14 "2009M3") size(vsmall)) graphr(fcolor(white) lcolor(white))  plotr(fcolor(white) lcolor(white));

	graph save eainflCaseMthlySelectionAll eainflCaseMthlySelectionAll, asis replace;
	graph export eainflCaseMthlySelectionAll.eps, replace;
	*/

	global xlabStart=-3; global xlabEnd=3; label var gdp4Q "";

	graph twoway 
	(kdensity gdp4Q if year==2007 & (month==6) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd, labsize(vsmall)) xtitle("") ytitle("") ylabel(,labsize(vsmall))) 
	(kdensity gdp4Q if year==2007 & (month==9) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2007 & (month==10) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==1) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==4) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==7) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==8) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==9) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==10) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==11) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==12) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2009 & (month==1) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2009 & (month==2) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2009 & (month==3) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")),
	name(eagdpCaseMthlySelectionAll) legend(cols(4) lab(1 "2007M6") lab(2 "2007M9") lab(3 "2007M10") lab(4 "2008M1") lab(5 "2008M4") lab(6 "2008M7")  lab(7 "2008M8") lab(8 "2008M9")lab(9 "2008M10") lab(10 "2008M11") lab(11 "2008M12") lab(12 "2009M1") lab(13 "2009M2") lab(14 "2009M3") size(vsmall)) graphr(fcolor(white) lcolor(white))  plotr(fcolor(white) lcolor(white));

	graph save eagdpCaseMthlySelectionAll eagdpCaseMthlySelectionAll, asis replace;
	graph export eagdpCaseMthlySelectionAll.eps, replace;

	graph twoway 
	(kdensity gdp4Q if year==2007 & (month==6) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd, labsize(vsmall)) xtitle("") ytitle("") ylabel(,labsize(vsmall))) 
	(kdensity gdp4Q if year==2007 & (month==9) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2007 & (month==10) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==1) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==4) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==7) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==8) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==9) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==10) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==11) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==12) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2009 & (month==1) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2009 & (month==2) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2009 & (month==3) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")),
	name(eagdpCaseMthlySelectionGraph1) legend(cols(4) lab(1 "2007M6") lab(2 "") lab(3 "") lab(4 "") lab(5 "") lab(6 "")  lab(7 "") lab(8 "")lab(9 "") lab(10 "") lab(11 "") lab(12 "") lab(13 "") lab(14 "") size(vsmall)) graphr(fcolor(white) lcolor(white))  plotr(fcolor(white) lcolor(white));

	graph save eagdpCaseMthlySelectionGraph1 eagdpCaseMthlySelectionGraph1, asis replace;
	graph export eagdpCaseMthlySelectionGraph1.eps, replace;

	graph twoway 
	(kdensity gdp4Q if year==2007 & (month==6) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd, labsize(vsmall)) xtitle("") ytitle("") ylabel(,labsize(vsmall))) 
	(kdensity gdp4Q if year==2007 & (month==9) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2007 & (month==10) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==1) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==4) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==7) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==8) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==9) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==10) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==11) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==12) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2009 & (month==1) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2009 & (month==2) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2009 & (month==3) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")),
	name(eagdpCaseMthlySelectionGraph2) legend(cols(4) lab(1 "2007M6") lab(2 "2007M9") lab(3 "") lab(4 "") lab(5 "") lab(6 "")  lab(7 "") lab(8 "")lab(9 "") lab(10 "") lab(11 "") lab(12 "") lab(13 "") lab(14 "") size(vsmall)) graphr(fcolor(white) lcolor(white))  plotr(fcolor(white) lcolor(white));

	graph save eagdpCaseMthlySelectionGraph2 eagdpCaseMthlySelectionGraph2, asis replace;
	graph export eagdpCaseMthlySelectionGraph2.eps, replace;

	graph twoway 
	(kdensity gdp4Q if year==2007 & (month==6) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd, labsize(vsmall)) xtitle("") ytitle("") ylabel(,labsize(vsmall))) 
	(kdensity gdp4Q if year==2007 & (month==9) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2007 & (month==10) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==1) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==4) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==7) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==8) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==9) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==10) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==11) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==12) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2009 & (month==1) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2009 & (month==2) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2009 & (month==3) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")),
	name(eagdpCaseMthlySelectionGraph3) legend(cols(4) lab(1 "2007M6") lab(2 "2007M9") lab(3 "2007M10") lab(4 "") lab(5 "") lab(6 "")  lab(7 "") lab(8 "")lab(9 "") lab(10 "") lab(11 "") lab(12 "") lab(13 "") lab(14 "") size(vsmall)) graphr(fcolor(white) lcolor(white))  plotr(fcolor(white) lcolor(white));

	graph save eagdpCaseMthlySelectionGraph3 eagdpCaseMthlySelectionGraph3, asis replace;
	graph export eagdpCaseMthlySelectionGraph3.eps, replace;

	graph twoway 
	(kdensity gdp4Q if year==2007 & (month==6) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd, labsize(vsmall)) xtitle("") ytitle("") ylabel(,labsize(vsmall))) 
	(kdensity gdp4Q if year==2007 & (month==9) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2007 & (month==10) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==1) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==4) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==7) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==8) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==9) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==10) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==11) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==12) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2009 & (month==1) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2009 & (month==2) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2009 & (month==3) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")),  
	name(eagdpCaseMthlySelectionGraph4) legend(cols(4) lab(1 "2007M6") lab(2 "2007M9") lab(3 "2007M10") lab(4 "2008M1") lab(5 "") lab(6 "")  lab(7 "") lab(8 "")lab(9 "") lab(10 "") lab(11 "") lab(12 "") lab(13 "") lab(14 "") size(vsmall)) graphr(fcolor(white) lcolor(white))  plotr(fcolor(white) lcolor(white));

	graph save eagdpCaseMthlySelectionGraph4 eagdpCaseMthlySelectionGraph4, asis replace;
	graph export eagdpCaseMthlySelectionGraph4.eps, replace;

	graph twoway 
	(kdensity gdp4Q if year==2007 & (month==6) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd, labsize(vsmall)) xtitle("") ytitle("") ylabel(,labsize(vsmall))) 
	(kdensity gdp4Q if year==2007 & (month==9) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2007 & (month==10) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==1) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==4) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==7) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==8) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==9) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==10) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==11) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==12) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2009 & (month==1) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2009 & (month==2) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2009 & (month==3) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")),

	name(eagdpCaseMthlySelectionGraph5) legend(cols(4) lab(1 "2007M6") lab(2 "2007M9") lab(3 "2007M10") lab(4 "2008M1") lab(5 "2008M4") lab(6 "")  lab(7 "") lab(8 "")lab(9 "") lab(10 "") lab(11 "") lab(12 "") lab(13 "") lab(14 "") size(vsmall)) graphr(fcolor(white) lcolor(white))  plotr(fcolor(white) lcolor(white));

	graph save eagdpCaseMthlySelectionGraph5 eagdpCaseMthlySelectionGraph5, asis replace;
	graph export eagdpCaseMthlySelectionGraph5.eps, replace;


	graph twoway 
	(kdensity gdp4Q if year==2007 & (month==6) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd, labsize(vsmall)) xtitle("") ytitle("") ylabel(,labsize(vsmall))) 
	(kdensity gdp4Q if year==2007 & (month==9) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2007 & (month==10) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==1) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==4) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==7) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==8) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==9) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==10) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==11) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==12) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2009 & (month==1) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2009 & (month==2) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2009 & (month==3) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")),  
	name(eagdpCaseMthlySelectionGraph6) legend(cols(4) lab(1 "2007M6") lab(2 "2007M9") lab(3 "2007M10") lab(4 "2008M1") lab(5 "2008M4") lab(6 "2008M7") lab(7 "") lab(8 "")lab(9 "") lab(10 "") lab(11 "") lab(12 "") lab(13 "") lab(14 "") size(vsmall)) graphr(fcolor(white) lcolor(white))  plotr(fcolor(white) lcolor(white));

	graph save eagdpCaseMthlySelectionGraph6 eagdpCaseMthlySelectionGraph6, asis replace;
	graph export eagdpCaseMthlySelectionGraph6.eps, replace;


	graph twoway 
	(kdensity gdp4Q if year==2007 & (month==6) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd, labsize(vsmall)) xtitle("") ytitle("") ylabel(,labsize(vsmall))) 
	(kdensity gdp4Q if year==2007 & (month==9) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2007 & (month==10) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==1) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==4) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==7) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==8) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==9) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==10) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==11) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==12) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2009 & (month==1) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2009 & (month==2) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2009 & (month==3) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")),  
	name(eagdpCaseMthlySelectionGraph7) legend(cols(4) lab(1 "2007M6") lab(2 "2007M9") lab(3 "2007M10") lab(4 "2008M1") lab(5 "2008M4") lab(6 "2008M7") lab(7 "2008M8") lab(8 "")lab(9 "") lab(10 "") lab(11 "") lab(12 "") lab(13 "") lab(14 "") size(vsmall)) graphr(fcolor(white) lcolor(white))  plotr(fcolor(white) lcolor(white));

	graph save eagdpCaseMthlySelectionGraph7 eagdpCaseMthlySelectionGraph7, asis replace;
	graph export eagdpCaseMthlySelectionGraph7.eps, replace;


	graph twoway 
	(kdensity gdp4Q if year==2007 & (month==6) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd, labsize(vsmall)) xtitle("") ytitle("") ylabel(,labsize(vsmall))) 
	(kdensity gdp4Q if year==2007 & (month==9) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2007 & (month==10) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==1) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==4) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==7) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==8) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==9) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==10) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==11) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==12) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2009 & (month==1) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2009 & (month==2) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2009 & (month==3) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")),  
	name(eagdpCaseMthlySelectionGraph8) legend(cols(4) lab(1 "2007M6") lab(2 "2007M9") lab(3 "2007M10") lab(4 "2008M1") lab(5 "2008M4") lab(6 "2008M7") lab(7 "2008M8")lab(8 "2008M9") lab(9 "") lab(10 "") lab(11 "") lab(12 "") lab(13 "") lab(14 "") size(vsmall)) graphr(fcolor(white) lcolor(white))  plotr(fcolor(white) lcolor(white));

	graph save eagdpCaseMthlySelectionGraph8 eagdpCaseMthlySelectionGraph8, asis replace;
	graph export eagdpCaseMthlySelectionGraph8.eps, replace;

	graph twoway 
	(kdensity gdp4Q if year==2007 & (month==6) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd, labsize(vsmall)) xtitle("") ytitle("") ylabel(,labsize(vsmall))) 
	(kdensity gdp4Q if year==2007 & (month==9) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2007 & (month==10) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==1) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==4) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==7) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==8) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==9) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==10) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==11) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==12) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2009 & (month==1) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2009 & (month==2) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2009 & (month==3) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")),  
	name(eagdpCaseMthlySelectionGraph9) legend(cols(4) lab(1 "2007M6") lab(2 "2007M9") lab(3 "2007M10") lab(4 "2008M1") lab(5 "2008M4") lab(6 "2008M7") lab(7 "2008M8")lab(8 "2008M9") lab(9 "2008M10") lab(10 "") lab(11 "") lab(12 "") lab(13 "") lab(14 "") size(vsmall)) graphr(fcolor(white) lcolor(white))  plotr(fcolor(white) lcolor(white));

	graph save eagdpCaseMthlySelectionGraph9 eagdpCaseMthlySelectionGraph9, asis replace;
	graph export eagdpCaseMthlySelectionGraph9.eps, replace;

	graph twoway 
	(kdensity gdp4Q if year==2007 & (month==6) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd, labsize(vsmall)) xtitle("") ytitle("") ylabel(,labsize(vsmall))) 
	(kdensity gdp4Q if year==2007 & (month==9) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2007 & (month==10) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==1) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==4) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==7) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==8) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==9) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==10) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==11) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==12) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2009 & (month==1) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2009 & (month==2) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2009 & (month==3) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")),  
	name(eagdpCaseMthlySelectionGraph10) legend(cols(4) lab(1 "2007M6") lab(2 "2007M9") lab(3 "2007M10") lab(4 "2008M1") lab(5 "2008M4") lab(6 "2008M7") lab(7 "2008M8")lab(8 "2008M9") lab(9 "2008M10") lab(10 "2008M11") lab(11 "") lab(12 "") lab(13 "") lab(14 "") size(vsmall)) graphr(fcolor(white) lcolor(white))  plotr(fcolor(white) lcolor(white));

	graph save eagdpCaseMthlySelectionGraph10 eagdpCaseMthlySelectionGraph10, asis replace;
	graph export eagdpCaseMthlySelectionGraph10.eps, replace;


	graph twoway 
	(kdensity gdp4Q if year==2007 & (month==6) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd, labsize(vsmall)) xtitle("") ytitle("") ylabel(,labsize(vsmall))) 
	(kdensity gdp4Q if year==2007 & (month==9) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2007 & (month==10) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==1) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==4) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==7) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==8) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==9) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==10) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==11) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==12) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2009 & (month==1) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2009 & (month==2) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2009 & (month==3) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")),  
	name(eagdpCaseMthlySelectionGraph11) legend(cols(4) lab(1 "2007M6") lab(2 "2007M9") lab(3 "2007M10") lab(4 "2008M1") lab(5 "2008M4") lab(6 "2008M7") lab(7 "2008M8")lab(8 "2008M9") lab(9 "2008M10") lab(10 "2008M11") lab(11 "2008M12") lab(12 "") lab(13 "") lab(14 "") size(vsmall)) graphr(fcolor(white) lcolor(white))  plotr(fcolor(white) lcolor(white));

	graph save eagdpCaseMthlySelectionGraph11 eagdpCaseMthlySelectionGraph11, asis replace;
	graph export eagdpCaseMthlySelectionGraph11.eps, replace;


	graph twoway 
	(kdensity gdp4Q if year==2007 & (month==6) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd, labsize(vsmall)) xtitle("") ytitle("") ylabel(,labsize(vsmall))) 
	(kdensity gdp4Q if year==2007 & (month==9) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2007 & (month==10) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==1) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==4) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==7) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==8) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==9) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==10) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==11) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==12) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2009 & (month==1) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2009 & (month==2) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2009 & (month==3) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")),  
	name(eagdpCaseMthlySelectionGraph12) legend(cols(4) lab(1 "2007M6") lab(2 "2007M9") lab(3 "2007M10") lab(4 "2008M1") lab(5 "2008M4") lab(6 "2008M7") lab(7 "2008M8")lab(8 "2008M9") lab(9 "2008M10") lab(10 "2008M11") lab(11 "2008M12")  lab(12 "2009M1") lab(13 "") lab(14 "") size(vsmall)) graphr(fcolor(white) lcolor(white))  plotr(fcolor(white) lcolor(white));

	graph save eagdpCaseMthlySelectionGraph12 eagdpCaseMthlySelectionGraph12, asis replace;
	graph export eagdpCaseMthlySelectionGraph12.eps, replace;


	graph twoway 
	(kdensity gdp4Q if year==2007 & (month==6) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd, labsize(vsmall)) xtitle("") ytitle("") ylabel(,labsize(vsmall))) 
	(kdensity gdp4Q if year==2007 & (month==9) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2007 & (month==10) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==1) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==4) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==7) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==8) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==9) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==10) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==11) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2008 & (month==12) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2009 & (month==1) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2009 & (month==2) & country=="ea", xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")) 
	(kdensity gdp4Q if year==2009 & (month==3) & country=="ea", lcolor(none) xscale(range($xlabStart $xlabStart)) xlabel($xlabStart(1)$xlabEnd) xtitle("") ytitle("")),  
	name(eagdpCaseMthlySelectionGraph13) legend(cols(4) lab(1 "2007M6") lab(2 "2007M9") lab(3 "2007M10") lab(4 "2008M1") lab(5 "2008M4") lab(6 "2008M7") lab(7 "2008M8")lab(8 "2008M9") lab(9 "2008M10") lab(10 "2008M11") lab(11 "2008M12")  lab(12 "2009M1") lab(13 "2009M2")  lab(14 "") size(vsmall)) graphr(fcolor(white) lcolor(white))  plotr(fcolor(white) lcolor(white));

	graph save eagdpCaseMthlySelectionGraph13 eagdpCaseMthlySelectionGraph13, asis replace;
	graph export eagdpCaseMthlySelectionGraph13.eps, replace;
};

cd "`basepath'stata\";

***************************************************************************************;
log close;
