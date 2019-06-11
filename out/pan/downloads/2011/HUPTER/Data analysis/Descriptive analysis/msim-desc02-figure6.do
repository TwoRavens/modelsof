
* Open log 
**********
capture log close
log using "Data analysis\Descriptive analysis\msim-desc02-figure6.log", replace


* ***********************************************************************************************************************
* Construction of plots of empirical distributions of similarity measures based on alliance and UN voting data (Figure 6)
* ***********************************************************************************************************************

* Programme:	msim-desc02-figure6.do
* Project:		Measuring similarity
* Author:		Frank Haege, Department of Politics and Administration, University of Limerick
* Contact:		frank.haege@ul.ie

* Description
*************
* This do-file generates histograms to compare the univariate distributions of different similarity measures.
* The measures are based on valued alliance and valued UN voting relationships between all COW state system members (who were also UN members in the case of the latter data source).
* The input datasets are the system version of the COW State System Membership List (v2004.1),
* the undirected dyadic version (with one record per dyad-year) of the COW Formal Interstate Alliance dataset (v3.03),
* and the United Nations General Assembly Voting dataset (v1) collected by Voeten and Merdzanovic
* (the data management do-files include further details about the original sources and the generation of the datasets used here).


* Set up Stata
**************
version 11
clear all
macro drop _all
set linesize 80
set more off
set memory 500m
set scheme s1rcolor


* Generate Figure 6
*******************

* Load similarity measures for undirected dyads based on valued alliance data
use "Datasets\Derived\msim-data11a-allysimvalued1.dta", clear

* Generate histograms of similarity variables based on alliance data
hist srsvas, xlabel(-1 -0.5:1) ylabel(0 .1:.3) yscale(range(0 .32)) frac nodraw /*
	*/ l1title("Fraction", size(medsmall)) ytitle("") xtitle("") b1title("") color(white) /*
	*/ t2title("{bf:{it:S} (sqrd. dist.)}") /*
	*/ saving("Data analysis\Descriptive analysis\msim-desc02-figure6-graph1.gph", replace)
hist piva, xlabel(-1 -0.5:1) ylabel(0 .1:.3) yscale(range(0 .32)) frac nodraw /*
	*/ l1title("Fraction", size(medsmall)) ytitle("") xtitle("") b1title("") color(white) /*
	*/ t2title("{bf:Scott's {&pi}}") /*
	*/ saving("Data analysis\Descriptive analysis\msim-desc02-figure6-graph2.gph", replace)
hist kappava, xlabel(-1 -0.5:1) ylabel(0 .1:.3) yscale(range(0 .32)) frac nodraw /*
	*/ l1title("Fraction", size(medsmall)) ytitle("") xtitle("") b1title("") color(white) /*
	*/ t2title("{bf:Cohen's {&kappa}}") /*
	*/ saving("Data analysis\Descriptive analysis\msim-desc02-figure6-graph3.gph", replace)

	
* Load similarity measures for undirected dyads based on valued UN voting data
use "Datasets\Derived\msim-data11e-votesimvalued1.dta", clear

* Generate histograms of similarity variables based on UN voting data
hist srsvvs, xlabel(-1 -0.5:1) ylabel(0 .1:.3) yscale(range(0 .32)) frac nodraw /*
	*/ l1title("Fraction", size(medsmall)) ytitle("") xtitle("") b1title("") color(white) /*
	*/ t2title("{bf:{it:S} (sqrd. dist.)}") /*
	*/ saving("Data analysis\Descriptive analysis\msim-desc02-figure6-graph4.gph", replace)
hist pivv, xlabel(-1 -0.5:1) ylabel(0 .1:.3) yscale(range(0 .32)) frac nodraw /*
	*/ l1title("Fraction", size(medsmall)) ytitle("") xtitle("") b1title("") color(white) /*
	*/ t2title("{bf:Scott's {&pi}}") /*
	*/ saving("Data analysis\Descriptive analysis\msim-desc02-figure6-graph5.gph", replace)
hist kappavv, xlabel(-1 -0.5:1) ylabel(0 .1:.3) yscale(range(0 .32)) frac nodraw /*
	*/ l1title("Fraction", size(medsmall)) ytitle("") xtitle("") b1title("") color(white) /*
	*/ t2title("{bf:Cohen's {&kappa}}") /*
	*/ saving("Data analysis\Descriptive analysis\msim-desc02-figure6-graph6.gph", replace)

	
* Combine histograms into a single plot
graph combine /*
	*/ "Data analysis\Descriptive analysis\msim-desc02-figure6-graph1.gph" /*
	*/ "Data analysis\Descriptive analysis\msim-desc02-figure6-graph2.gph" /*
	*/ "Data analysis\Descriptive analysis\msim-desc02-figure6-graph3.gph" /*
	*/ "Data analysis\Descriptive analysis\msim-desc02-figure6-graph4.gph" /*
	*/ "Data analysis\Descriptive analysis\msim-desc02-figure6-graph5.gph" /*
	*/ "Data analysis\Descriptive analysis\msim-desc02-figure6-graph6.gph" /*
	*/ , cols(3) scale(1.4) imargin(vsmall) ycommon xcommon /*
	*/ l1title("UN voting data  			Alliance data", size(small)) /*
	*/ saving("Data analysis\Descriptive analysis\msim-desc02-figure6-graph.gph", replace)

	
* Exit do-file
log close
exit
