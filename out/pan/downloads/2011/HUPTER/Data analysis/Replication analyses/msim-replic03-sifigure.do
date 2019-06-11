
* Open log 
**********
capture log close
log using "Data analysis\Replication analyses\msim-replic03-sifigure.log", replace


* *******************************************
* Generate Figure 1 in Supporting Information
* *******************************************

* Programme:	msim-replic03-sifigure1.do
* Project:		Measuring similarity
* Author:		Frank Haege, Department of Politics and Administration, University of Limerick
* Contact:		frank.haege@ul.ie

* Description
*************
* This do-file generates Figure 1 in the supporting information to the article.


* Set up Stata
**************
version 11
clear all
macro drop _all
set linesize 80
set memory 500m
set more off

	
* Generate left panel of SI-Figure 1
*************************************

* Merge datasets of parameter estimates and confidence intervals
use "Data analysis\Replication analyses\msim-replic01-crescenzi2007-m3.dta", clear
append using "Data analysis\Replication analyses\msim-replic01-crescenzi2007-m3a.dta"
append using "Data analysis\Replication analyses\msim-replic01-crescenzi2007-m3b.dta"
append using "Data analysis\Replication analyses\msim-replic01-crescenzi2007-m3c.dta"
append using "Data analysis\Replication analyses\msim-replic01-crescenzi2007-m3d.dta"

* Generate variable for parameter estimate number
sort idstr
by idstr: generate parmno = _n

* Generate variable for similarity measure number
sort parmno idstr 
by parmno: generate simno = _n
label define simnol 1 "Original {it:S}" 2 "{it:S} (abs. dist.)" 3 "{it:S} (sqrd. dist.)" 4 "Scott's {&pi}" 5 "Cohen's {&kappa}", replace
label value simno simnol
tab simno

* Plot the parameter estimates and confidence intervals of different measures
eclplot estimate min95 max95 simno if parmno == 8, hori /*
	*/ ciopts(lcolor(white)) estopts(mcolor(white)) /*
	*/ ylabel(, valuelabel) yscale(range(0.75 5.25)) /*
	*/ xline(0, lcolor(white) lpattern(-)) ytitle("") /*
	*/ xtitle("") t2title("{bf:(a) Crescenzi (2007)}") t1title(" ") /*
	*/ saving("Data analysis\Replication analyses\msim-replic03-sifigure-crescenzi2007.gph", replace)
	
	
* Generate right panel of SI-Figure 1
*************************************

* Merge datasets of parameter estimates and confidence intervals
use "Data analysis\Replication analyses\msim-replic02-salehyan2008-m2.dta", clear
append using "Data analysis\Replication analyses\msim-replic02-salehyan2008-m2b.dta"
append using "Data analysis\Replication analyses\msim-replic02-salehyan2008-m2e.dta"
append using "Data analysis\Replication analyses\msim-replic02-salehyan2008-m2f.dta"

* Generate variable for parameter estimate number
sort idstr
by idstr: generate parmno = _n

* Generate variable for similarity measure number
sort parmno idstr 
by parmno: generate simno = _n
label define simnol 1 "Original {it:S}" 2 "{it:S} (sqrd. dist.)" 3 "Scott's {&pi}" 4 "Cohen's {&kappa}" 
label value simno simnol
tab simno

* Plot the parameter estimates and confidence intervals of different measures
eclplot estimate min95 max95 simno if parmno == 23, hori /*
	*/ ciopts(lcolor(white)) estopts(mcolor(white)) /*
	*/ ylabel(, valuelabel) yscale(range(0.75 4.25)) /*
	*/ xline(0, lcolor(white) lpattern(-)) ytitle("") /*
	*/ xtitle("") t2title("{bf:(b) Salehyan (2008)}") t1title(" ") /*
	*/ saving("Data analysis\Replication analyses\msim-replic03-sifigure-salehyan2008.gph", replace)

	
* Generate SI-Figure 1
**********************

graph combine /*
	*/ "Data analysis\Replication analyses\msim-replic03-sifigure-crescenzi2007.gph" /*
	*/ "Data analysis\Replication analyses\msim-replic03-sifigure-salehyan2008.gph" /*
	*/ , scale(1.8) ysize(3) saving("Data analysis\Replication analyses\msim-replic03-sifigure-figure1.gph", replace)	
	

* Exit do-file
log close
exit
