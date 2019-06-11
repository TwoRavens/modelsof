*****************************************************************************
*		Elite Co-optation, Repression, and Coups in Autocracies

*		Vincenzo Bove & Mauricio Rivera

* 		Software: Stata 13

*****************************************************************************

use "Data.dta", clear

global mean "Mlinstability Mlmilexch Mlmilper Mlmilexpc Mlrgdppc MlGDPch"
**  (averages of all the covariates over the period 1950-2004)


xtset ccode year 

***********************************
* Table 1   
***********************************


* Model 1: Baseline
probit hcoup autleg3 Purges lrgdppc lGDPch linstab lmilexch lmilper lmilexpc sumhcoups, cluster(ccode) 

	
* Model 2: Baseline + regimes	
probit hcoup autleg3 Purges lrgdppc lGDPch linstab lmilexch lmilper lmilexpc sumhcoups gwf_party ///
	gwf_party gwf_military gwf_personal, cluster(ccode) 

	
* Model 3: Baseline + FE
xtprobit hcoup autleg3 Purges lrgdppc lGDPch linstab lmilexch lmilper lmilexpc sumhcoups $mean,  vce(r) 


* Model 4: Baseline + regimes + FE
xtprobit hcoup autleg3 Purges lrgdppc lGDPch linstab lmilexch lmilper lmilexpc sumhcoups gwf_party ///
	gwf_military gwf_personal $mean,  vce(r) 

 
* Model 5: Baseline + civil liberties (FH) + horizontal repression (PTS)	
probit hcoup autleg3 Purges lrgdppc lGDPch linstab lmilexch lmilper lmilexpc sumhcoups gwf_party ///
	gwf_military gwf_personal l.fh_cl l.gd_ptss, cluster(ccode)  


 
***********************************
* Table 2   
***********************************

 
* Model 6
probit hcoup l1.autleg3 l1.Purges lrgdppc lGDPch linstab lmilexch lmilper lmilexpc sumhcoups, ///
	cluster(ccode) 

* Model 7
probit hcoup l2.autleg3 l2.Purges lrgdppc lGDPch linstab lmilexch lmilper lmilexpc sumhcoups, ///
	cluster(ccode) 

* Model 8
probit hcoup l3.autleg3 l3.Purges lrgdppc lGDPch linstab lmilexch lmilper lmilexpc sumhcoups, ///
	cluster(ccode) 




***********************************
* Fig 1 and 2
***********************************



probit hcoup i.autleg3 Purges lrgdppc lGDPch linstab lmilexch lmilper lmilexpc sumhcoups, cluster(ccode) robust

margins  i.autleg3,  atmeans  level(90)

marginsplot, ylin(0, lc(red)) recast(line) ciopts(color(black))   ytitle("Pr(Coup)") title("")

 
probit hcoup  i.Purges lrgdppc lGDPch linstab lmilexch lmilper lmilexpc sumhcoups, cluster(ccode) robust

margins  i.Purges,  atmeans  level(90)

marginsplot, ylin(0, lc(red)) recast(line)  ciopts(color(black))   ytitle("Pr(Coup)") title("")  
 
 
 

***********************************
* Fig 3
***********************************
 
 probit hcoup autleg3 Purges lrgdppc lGDPch linstab lmilexch lmilper lmilexpc sumhcoups,  cluster(ccode) robust
 
lroc, nograph

predict full, xb

probit hcoup autleg3 Purges lrgdppc lGDPch  lmilexch lmilper lmilexpc sumhcoups,  cluster(ccode) robust
 
lroc, nograph

predict dissent, xb


probit hcoup autleg3 Purges lrgdppc lGDPch linstab lmilexch lmilper  sumhcoups,  cluster(ccode) robust
 
lroc, nograph

predict pcMilex, xb


probit hcoup  Purges lrgdppc lGDPch linstab lmilexch lmilper lmilexpc sumhcoups,  cluster(ccode) robust
 
lroc, nograph

predict legisl, xb

probit hcoup   lrgdppc lGDPch linstab lmilexch lmilper lmilexpc sumhcoups,  cluster(ccode) robust
 
lroc, nograph

predict leg_purges, xb


roccomp hcoup full dissent  pcMilex legisl leg_purges , graph summary  plot1opts(msymbol(none) lwidth(tiny)) ///
 plot2opts(msymbol(none) lwidth(tiny))plot3opts( msymbol(none)  lwidth(tiny)) plot4opts(msymbol(none) lwidth(tiny)) ///
  plot5opts(msymbol(none) lwidth(tiny)) ytitle("True Positive Rate") xtitle("False Positive Rate") title("Roc plots")


***********************************
* Fig 4
***********************************

use"Data.dta", clear
 
local run=1
while `run'<=10 {
	tempfile dataset`run'
	qui probit hcoup autleg3 Purges lrgdppc lGDPch linstab lmilexch lmilper lmilexpc sumhcoups,  vce(cluster ccode)
	preserve
		keep if e(sample)
		xtile group=uniform(), nq(4) 
			
		gen fitted=.
		forval i=1/4 {
			tempvar fitted`i'
			qui probit hcoup autleg3 Purges lrgdppc lGDPch linstab lmilexch lmilper lmilexpc sumhcoups if group==`i', vce(cluster ccode)
			qui predict fitted`i', pr
			replace fitted=fitted`i' if group==`i'
		}
		roctab hcoup fitted
		gen area=`r(area)' 
		gen lo=`r(lb)' 
		gen hi=`r(ub)'
		keep if _n==1
		keep area lo hi 
		gen run=`run'
		save "`dataset`run''", replace
		
	local run=`run'+1
	restore
}

use "`dataset1'",clear
foreach file in  "`dataset2'" "`dataset3'" "`dataset4'" "`dataset5'" "`dataset6'" "`dataset7'" "`dataset8'" "`dataset9'" "`dataset10'" {
	append using "`file'"
}

sum area

 

twoway (scatter area   run) (rcap hi lo   run ), xtitle("Cycle Run - Full Sample") ytitle("Total Area Under Curve") ///
xlabel(1(1)10)  ylabel(0.7(0.1)1.0) yline( `r(mean)', lpattern(dash))  legen(off) name(graph1, replace)


use"Data.dta", clear
 

local run=1
while `run'<=10 {
	tempfile dataset`run'
	qui probit hcoup autleg3 Purges lrgdppc lGDPch  lmilexch lmilper lmilexpc sumhcoups,  vce(cluster ccode)
	preserve
		keep if e(sample)
		xtile group=uniform(), nq(4) 
			
		gen fitted=.
		forval i=1/4 {
			tempvar fitted`i'
			qui probit hcoup autleg3 Purges lrgdppc lGDPch   lmilexch lmilper lmilexpc sumhcoups if group==`i', vce(cluster ccode)
			qui predict fitted`i', pr
			replace fitted=fitted`i' if group==`i'
		}
		roctab hcoup fitted
		gen area=`r(area)' 
		gen lo=`r(lb)' 
		gen hi=`r(ub)'
		keep if _n==1
		keep area lo hi 
		gen run=`run'
		save "`dataset`run''", replace
		
	local run=`run'+1
	restore
}

use "`dataset1'",clear
foreach file in  "`dataset2'" "`dataset3'" "`dataset4'" "`dataset5'" "`dataset6'" "`dataset7'" "`dataset8'" "`dataset9'" "`dataset10'" {
	append using "`file'"
}

sum area

 
twoway (scatter area   run) (rcap hi lo   run ), xtitle("Cycle Run - Dissent") ytitle("Total Area Under Curve") ///
xlabel(1(1)10)  ylabel(0.7(0.1)1.0) yline( `r(mean)', lpattern(dash))  legen(off) name(graph2, replace)





***********************************
* Fig 5
***********************************
 
 use"Data.dta", clear
 
local run=1
while `run'<=10 {
	tempfile dataset`run'
	qui probit hcoup   Purges lrgdppc lGDPch linstab lmilexch lmilper lmilexpc sumhcoups,  vce(cluster ccode)
	preserve
		keep if e(sample)
		xtile group=uniform(), nq(4) 
			
		gen fitted=.
		forval i=1/4 {
			tempvar fitted`i'
			qui probit hcoup  Purges lrgdppc lGDPch linstab lmilexch lmilper lmilexpc sumhcoups if group==`i', vce(cluster ccode)
			qui predict fitted`i', pr
			replace fitted=fitted`i' if group==`i'
		}
		roctab hcoup fitted
		gen area=`r(area)' 
		gen lo=`r(lb)' 
		gen hi=`r(ub)'
		keep if _n==1
		keep area lo hi 
		gen run=`run'
		save "`dataset`run''", replace
		
	local run=`run'+1
	restore
}

use "`dataset1'",clear
foreach file in  "`dataset2'" "`dataset3'" "`dataset4'" "`dataset5'" "`dataset6'" "`dataset7'" "`dataset8'" "`dataset9'" "`dataset10'" {
	append using "`file'"
}

sum area

twoway (scatter area   run) (rcap hi lo   run ), xtitle("Cycle Run - Legislatures") ytitle("Total Area Under Curve") ///
xlabel(1(1)10)  ylabel(0.6(0.1)0.9) yline( `r(mean)', lpattern(dash))  legen(off) name(graph3, replace)

 use"Data.dta", clear
 
 
local run=1
while `run'<=10 {
	tempfile dataset`run'
	qui probit hcoup   lrgdppc lGDPch linstab lmilexch lmilper lmilexpc sumhcoups,  vce(cluster ccode)
	preserve
		keep if e(sample)
		xtile group=uniform(), nq(4) 
			
		gen fitted=.
		forval i=1/4 {
			tempvar fitted`i'
			qui probit hcoup   lrgdppc lGDPch linstab lmilexch lmilper lmilexpc sumhcoups if group==`i', vce(cluster ccode)
			qui predict fitted`i', pr
			replace fitted=fitted`i' if group==`i'
		}
		roctab hcoup fitted
		gen area=`r(area)' 
		gen lo=`r(lb)' 
		gen hi=`r(ub)'
		keep if _n==1
		keep area lo hi 
		gen run=`run'
		save "`dataset`run''", replace
		
	local run=`run'+1
	restore
}

use "`dataset1'",clear
foreach file in  "`dataset2'" "`dataset3'" "`dataset4'" "`dataset5'" "`dataset6'" "`dataset7'" "`dataset8'" "`dataset9'" "`dataset10'" {
	append using "`file'"
}

sum area

 

twoway (scatter area   run) (rcap hi lo   run ), xtitle("Cycle Run - Legislatures + Purges") ytitle("Total Area Under Curve") ///
xlabel(1(1)10)  ylabel(0.6(0.1)0.9) yline( `r(mean)', lpattern(dash))  legen(off) name(graph4, replace)


graph combine graph1 graph2, ycommon

 
graph combine graph3 graph4, ycommon


		
