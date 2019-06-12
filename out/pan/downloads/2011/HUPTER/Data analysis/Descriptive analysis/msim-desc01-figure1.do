
* Open log 
**********
capture log close
log using "Data analysis\Descriptive analysis\msim-desc01-figure1.log", replace


* *****************************************************************************************************
* Construction of plots of dyadic similarity values of United Kingdom during Cold War period (Figure 1)
* *****************************************************************************************************

* Programme:	msim-desc01-figure1.do
* Project:		Measuring similarity
* Author:		Frank Haege, Department of Politics and Administration, University of Limerick
* Contact:		frank.haege@ul.ie

* Description
*************
* This do-file generates line plots of the dyadic similarity values of the UK with other members of the UN security council during the Cold War 1950-1990.
* The measures are based on valued alliance relationships between all COW state system members.
* The input datasets are the system version of the COW State System Membership List (v2004.1) and
* the undirected dyadic version (with one record per dyad-year) of the COW Formal Interstate Alliance dataset (v3.03)
* (the data management do-files include further details about the original sources and the subsequent data manipulations made to generate the measures used here).


* Set up Stata
**************
version 11
clear all
macro drop _all
set linesize 80
set more off
set memory 500m
set scheme s1rcolor


* Generate Figure 1
*******************

* Load similarity measures for directed dyads based on valued alliance data
use "Datasets\Derived\msim-data11b-allysimvalued2.dta", clear

* Generate dyad abbreviation variable
generate dabb = cabb1 + "_" + cabb2
label var dabb "Dyad abbreviation" 

* Generate dyad code variable
egen dcode = group(dabb)
label var dcode "Dyad code"
order year nob tnobs cabb1 cabb2 dabb dcode

* Drop non-UK dyads
drop if cabb1 ~= "UKG"

* Drop years before 1950 and after 1990
drop if year < 1950
drop if year > 1990
keep if dabb == "UKG_USA" | dabb == "UKG_FRN" | dabb == "UKG_RUS" | dabb == "UKG_CHN"


* S plot (squared distance metric)
twoway /*
	*/ (connect srsvas year if dabb == "UKG_USA" & year > 1949 & year < 1991 /*
	*/ , msymbol(i) lpattern(l) lcolor(white) lwidth(medium)) /*
	*/ (connect srsvas year if dabb == "UKG_FRN" & year > 1949 & year < 1991 /*
	*/ , msymbol(i) lpattern(dash) lcolor(white) lwidth(medium)) /*
	*/ (connect srsvas year if dabb == "UKG_RUS" & year > 1949 & year < 1991 /*
	*/ , msymbol(i) lpattern(longdash) lcolor(white) lwidth(medium)) /*
	*/ (connect srsvas year if dabb == "UKG_CHN" & year > 1949 & year < 1991 /*
	*/ , msymbol(i) lpattern(shortdash) lcolor(white) lwidth(medium)) /*
		*/ , legend(label(1 "UK - United States") label(2 "UK - France") label(3 "UK - Soviet Union") label(4 "UK - China") /*
		*/ cols(1) ring(0) position(5) order(2 1 4 3) region(lpattern(blank))) /*
		*/ yscale(range(-1 1)) yline(0, lcolor(white) lpattern(.)) /*
		*/ ytitle("Similarity", size(medlarge) margin(medsmall)) /*
		*/ ylabel(-1 -.5:1) t2title("{bf:(a) Signorino and Ritter's {it:S}}") t1title(" ") /*
		*/ xtitle("", size(medlarge) margin(medsmall)) xsize(4) xlabel(, angle(45)) /*
		*/ saving("Data analysis\Descriptive analysis\msim-desc01-figure1-graph1.gph", replace)

		
* Pi plot
twoway /*
	*/ (connect piva year if dabb == "UKG_USA" & year > 1949 & year < 1991 /*
	*/ , msymbol(i) lpattern(l) lcolor(white) lwidth(medium)) /*
	*/ (connect piva year if dabb == "UKG_FRN" & year > 1949 & year < 1991 /*
	*/ , msymbol(i) lpattern(dash) lcolor(white) lwidth(medium)) /*
	*/ (connect piva year if dabb == "UKG_RUS" & year > 1949 & year < 1991 /*
	*/ , msymbol(i) lpattern(longdash) lcolor(white) lwidth(medium)) /*
	*/ (connect piva year if dabb == "UKG_CHN" & year > 1949 & year < 1991 /*
	*/ , msymbol(i) lpattern(shortdash) lcolor(white) lwidth(medium)) /*
		*/ , legend(label(1 "UK - United States") label(2 "UK - France") label(3 "UK - Soviet Union") label(4 "UK - China") /*
		*/ cols(1) ring(0) position(5) order(2 1 4 3) region(lpattern(blank))) /*
		*/ yscale(range(-1 1)) yline(0, lcolor(white) lpattern(.)) /*
		*/ ytitle(" ", size(medlarge) margin(medsmall)) /*
		*/ ylabel(-1 -.5:1) t2title("{bf:(b) Scott's {&pi}}") t1title(" ") /*
		*/ xtitle("", size(medlarge) margin(medsmall)) xsize(4) xlabel(, angle(45)) /*
		*/ saving("Data analysis\Descriptive analysis\msim-desc01-figure1-graph2.gph", replace)

		
* Kappa plot
twoway /*
	*/ (connect kappava year if dabb == "UKG_USA" & year > 1949 & year < 1991 /*
	*/ , msymbol(i) lpattern(l) lcolor(white) lwidth(medium)) /*
	*/ (connect kappava year if dabb == "UKG_FRN" & year > 1949 & year < 1991 /*
	*/ , msymbol(i) lpattern(dash) lcolor(white) lwidth(medium)) /*
	*/ (connect kappava year if dabb == "UKG_RUS" & year > 1949 & year < 1991 /*
	*/ , msymbol(i) lpattern(longdash) lcolor(white) lwidth(medium)) /*
	*/ (connect kappava year if dabb == "UKG_CHN" & year > 1949 & year < 1991 /*
	*/ , msymbol(i) lpattern(shortdash) lcolor(white) lwidth(medium)) /*
		*/ , legend(label(1 "UK - United States") label(2 "UK - France") label(3 "UK - Soviet Union") label(4 "UK - China") /*
		*/ cols(1) ring(0) position(5) order(2 1 4 3) region(lpattern(blank))) /*
		*/ yscale(range(-1 1)) yline(0, lcolor(white) lpattern(.)) /*
		*/ ytitle(" ", size(medlarge) margin(medsmall)) /*
		*/ ylabel(-1 -.5:1) t2title("{bf:(c) Cohen's {&kappa}}") t1title(" ") /*
		*/ xtitle("", size(medlarge) margin(medsmall)) xsize(4) xlabel(, angle(45)) /*
		*/ saving("Data analysis\Descriptive analysis\msim-desc01-figure1-graph3.gph", replace)


* Combine graphs into a single plot
graph combine /*
	*/ "Data analysis\Descriptive analysis\msim-desc01-figure1-graph1.gph" /*
	*/ "Data analysis\Descriptive analysis\msim-desc01-figure1-graph2.gph" /*
	*/ "Data analysis\Descriptive analysis\msim-desc01-figure1-graph3.gph" /*
	*/ , cols(3) imargin(tiny) ysize(3) scale(1.3) /*
	*/ saving("Data analysis\Descriptive analysis\msim-desc01-figure1-graph.gph", replace)


* Exit do-file
log close
exit
