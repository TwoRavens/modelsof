cd /Users/jeff/Documents/Academic/Research/Innovation.2008/
clear
set mem 8g
set matsize 1200
set more off

*do do/newwork-clean.do
*do do/newwork-geoid.do

/* ~/Documents/Academic/Research/Innovation.2008/do/newwork-analysis.do *//* This file uses cleaned files	for analysis, for "Innovation, Cities and New Work" *//* Jeffrey Lin *//* Created April 9, 2009 */

* POOLED REGRESSION
* Model is:
* v(mgt) = a + X(gt)*beta + Z(mgt)*gamma(gt) + c(g) + u(t) + d(gt) + e(mgt)
* or:
* (1) v(mgt) = Z(mgt)*gamma(gt) + e(mgt) + delta(gt)
* (2) delta(gt) = a + X(gt)*beta + c(g) + u(t) + d(gt)

* FIRST STAGE
* Obtain estimates and cluster-robust se of delta(gt), within g,t
capture program drop fecapture
program define fecapture
	* Preamble
	compress
	qui matrix drop _all
	qui scalar drop _all
	qui drop if geoid==542 /* Drop Hawaii */
	capture keep year region statefip occ-`2'
	*sample 10
	qui replace `2'=`2'*100
	
	* First stage (k different specifications)
	local basics "hs sc col potx potx2 marr male blck asia othr fb hisp"
	local majori "ind_mfg ind_tcu ind_trd ind_svc ind_pub"
	local majoro "occ_mpr occ_tsa occ_svc occ_pcr occ_ofl"
	* Within (g,t) estimates ...
	forvalues g=1/539{	
	* ... absorb geoid only ...
	capture reg `2' if geoid==`g', vce(cluster occ)	
		capture matrix b1=e(b)
		capture matrix V1=vecdiag(e(V))
		qui local n=colsof(b1)
		qui scalar b1_`g'=b1[1,`n']
		qui scalar V1_`g'=V1[1,`n']
	* ... with basic variables ...
	capture reg `2' `basics' if geoid==`g', vce(cluster occ)
		capture matrix b2=e(b)
		capture matrix V2=vecdiag(e(V))
		qui local n=colsof(b2)
		qui scalar b2_`g'=b2[1,`n']
		qui scalar V2_`g'=V2[1,`n']
	* ... with major industry ...
	capture reg `2' `basics' `majori' if geoid==`g', vce(cluster occ)
		capture matrix b3=e(b)
		capture matrix V3=vecdiag(e(V))
		qui local n=colsof(b2)
		qui scalar b3_`g'=b3[1,`n']
		qui scalar V3_`g'=V3[1,`n']
	* ... with major occupation ...
	capture reg `2' `basics' `majori' `majoro' if geoid==`g', vce(cluster occ)
		capture matrix b4=e(b)
		capture matrix V4=vecdiag(e(V))
		qui local n=colsof(b2)
		qui scalar b4_`g'=b4[1,`n']
		qui scalar V4_`g'=V4[1,`n']
	}
	* Within (t) estimates
	qui tab geoid, gen(geoid_)
	*qui xi i.geoid|potx i.geoid|potx2, noomit
	*drop _Igeoid*
	* ... with basic variables ...
	reg `2' `basics' geoid_1-geoid_363, vce(cluster occ) noc
	capture matrix b5=e(b)
	capture matrix V5=vecdiag(e(V))
	* ... with major industry ...
	reg `2' `basics' `majori' geoid_1-geoid_363, vce(cluster occ) noc
	capture matrix b6=e(b)
	capture matrix V6=vecdiag(e(V))
	* ... with detailed industry ...
	areg `2' `basics' geoid_1-geoid_363, absorb(ind) vce(cluster occ) noc
	capture matrix b24=e(b)
	capture matrix V24=vecdiag(e(V))
	* ... non-allocated cases only ...
	reg `2' `basics' geoid_1-geoid_363 if occflag==0, vce(cluster occ) noc
	capture matrix b7=e(b)
	capture matrix V7=vecdiag(e(V))
	* ... non-migrants only ...
	reg `2' `basics' geoid_1-geoid_363 if mig==0, vce(cluster occ) noc
	capture matrix b8=e(b)
	capture matrix V8=vecdiag(e(V))
	* ... migrants only ...
	reg `2' `basics' geoid_1-geoid_363 if mig==1, vce(cluster occ) noc
	capture matrix b9=e(b)
	capture matrix V9=vecdiag(e(V))
	* ... by industry ...
	reg `2' `basics' geoid_1-geoid_363 if (ind1990>=010 & ind1990<=060), vce(cluster occ) noc
	capture matrix b10=e(b)
	capture matrix V10=vecdiag(e(V))
	reg `2' `basics' geoid_1-geoid_363 if (ind1990>=100 & ind1990<=392), vce(cluster occ) noc
	capture matrix b11=e(b)
	capture matrix V11=vecdiag(e(V))
	reg `2' `basics' geoid_1-geoid_363 if (ind1990>=400 & ind1990<=472), vce(cluster occ) noc
	capture matrix b12=e(b)
	capture matrix V12=vecdiag(e(V))
	reg `2' `basics' geoid_1-geoid_363 if (ind1990>=500 & ind1990<=691), vce(cluster occ) noc
	capture matrix b13=e(b)
	capture matrix V13=vecdiag(e(V))
	reg `2' `basics' geoid_1-geoid_363 if (ind1990>=700 & ind1990<=712), vce(cluster occ) noc
	capture matrix b14=e(b)
	capture matrix V14=vecdiag(e(V))
	reg `2' `basics' geoid_1-geoid_363 if (ind1990>=721 & ind1990<=760), vce(cluster occ) noc
	capture matrix b15=e(b)
	capture matrix V15=vecdiag(e(V))
	reg `2' `basics' geoid_1-geoid_363 if (ind1990>=761 & ind1990<=791), vce(cluster occ) noc
	capture matrix b16=e(b)
	capture matrix V16=vecdiag(e(V))
	reg `2' `basics' geoid_1-geoid_363 if (ind1990>=800 & ind1990<=893), vce(cluster occ) noc
	capture matrix b17=e(b)
	capture matrix V17=vecdiag(e(V))
	reg `2' `basics' geoid_1-geoid_363 if (ind1990>=900 & ind1990<=932), vce(cluster occ) noc
	capture matrix b18=e(b)
	capture matrix V18=vecdiag(e(V))
	* ... prime-age males ...
	reg `2' hs sc col potx potx2 marr blck asia othr fb hisp geoid_1-geoid_363 if (agr6==1 | agr7==1 | agr8==1 | agr9==1) & (male==1), vce(cluster occ) noc
	capture matrix b19=e(b)
	capture matrix V19=vecdiag(e(V))
	* ... by educational attainment ...
	reg `2' potx potx2 marr male blck asia othr fb hisp geoid_1-geoid_363 if hs==0 & sc==0 & col==0, vce(cluster occ) noc
	capture matrix b20=e(b)
	capture matrix V20=vecdiag(e(V))
	reg `2' potx potx2 marr male blck asia othr fb hisp geoid_1-geoid_363 if hs==1, vce(cluster occ) noc
	capture matrix b21=e(b)
	capture matrix V21=vecdiag(e(V))
	reg `2' potx potx2 marr male blck asia othr fb hisp geoid_1-geoid_363 if sc==1, vce(cluster occ) noc
	capture matrix b22=e(b)
	capture matrix V22=vecdiag(e(V))
	reg `2' potx potx2 marr male blck asia othr fb hisp geoid_1-geoid_363 if col==1, vce(cluster occ) noc
	capture matrix b23=e(b)
	capture matrix V23=vecdiag(e(V))
	
	* Collapse and gen geoid FE and s.e.'s
	egen tag = tag(geoid)
	qui keep if tag	
	local k = 24
	forvalues y = 1/`k' {
		qui gen gt_fe`y'=.
		qui gen gt_var`y'=.
	}	
	forvalues m = 1/4 {
	forvalues g = 1/539 {
		qui replace gt_fe`m' = b`m'_`g' if geoid==`g'
		qui replace gt_var`m' = V`m'_`g' if geoid==`g'
	}	
	}
	forvalues m = 5/`k' {
		forvalues g = 1/363 {
		qui local n=colnumb(b`m',"geoid_`g'")
		qui replace gt_fe`m' = b`m'[1,`n'] if geoid_`g'==1
		qui replace gt_var`m' = V`m'[1,`n'] if geoid_`g'==1
	}
	}
	* Weights
	forvalues z = 1/`k' {
	qui gen gt_wt`z' = 1/(gt_var`z')
	}
	
	keep geoid year	region gt_*
	sort geoid
	
	lab var gt_fe1 "Geo dummies only"
	lab var gt_fe2 "Basic controls (g,t)"
	lab var gt_fe3 "Basic controls + ind. f.e. (g,t)"
	lab var gt_fe4 "Basic controls + ind. & occ. f.e. (g,t)"
	lab var gt_fe5 "Basic controls (t)"
	lab var gt_fe6 "Basic controls + ind. f.e. (t)"
	lab var gt_fe7 "Non-allocated cases only"
	lab var gt_fe8 "Non-migrants only"
	lab var gt_fe9 "Migrants only"
	lab var gt_fe10 "Agr., min., constr. only"
	lab var gt_fe11 "Manufacturing only"
	lab var gt_fe12 "Transp., comm., util. only"
	lab var gt_fe13 "Wholesale and retail trade only"
	lab var gt_fe14 "FIRE only"
	lab var gt_fe15 "Business & repair services only"
	lab var gt_fe16 "Personal services only"
	lab var gt_fe17 "Other services only"
	lab var gt_fe18 "Public administration only"
	lab var gt_fe19 "Prime-age males only"
	
	save tmp/gt_fe_`1'_`2', replace
end

log using log/firststage.log, replace
use dta/ipums/2000/2000-wk2, clear
	fecapture 2000 new_lin
use dta/ipums/1990/1990-wk2, clear
	fecapture 1990 newtsh_convt
use dta/ipums/1980/1980-wk2, clear
	fecapture 1980 newmaster_tsh

use dta/ipums/2000/2000-wk2, clear
	fecapture 2000 new_cenx
use dta/ipums/1990/1990-wk2, clear
	fecapture 1990 newtsh_convt91

*use dta/ipums/2000/2000-wk2, clear
*	fecapture 2000 new_cen
*use dta/ipums/1990/1990-wk2, clear
*	fecapture 1990 newtsh_dlu78
*use dta/ipums/1980/1980-wk2, clear
*	fecapture 1980 new_tsh

log close






