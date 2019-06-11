
* Open log 
**********
capture log close
log using "Data analysis\Replication analyses\msim-replic02-salehyan2008.log", replace


* ***********************************************************
* Replication of Models 1 and 2 in Table 1 of Salehyan (2008)
* ***********************************************************

* Programme:	msim-replic02-salehyan2008.do
* Project:		Measuring similarity
* Author:		Frank Haege, Department of Politics and Administration, University of Limerick
* Contact:		frank.haege@ul.ie

* Description
*************
* This do-file replicates models 1 and 2 in Table 1 of Salehyan (2008: 797) using different similarity measures.
* The replications of model 2 using the original S measure, Cohen's Kappa, and Scott's Pi is reported in the supporting information.
* Reference: Idehan Salehyan (2008) 'The Externalities of Civil Strife: Refugees as a Source of International Conflict'.
* American Journal of Political Science 52(4): 787-801.
* I thank Idean Salehyan for providing his replication dataset and do-file
* (see http://www.cas.unt.edu/~idean/AJPS%20Replication.zip [5 March 2010]).


* Set up Stata
**************
version 11
clear all
macro drop _all
set linesize 80
set memory 500m
set more off


* Replication of Salehyan's results using the original S measure
****************************************************************

* Load original dataset
use "Data analysis\Replication analyses\Salehyan 2008 Civil strife, AJPS\RefugeesWar_directed.dta", clear 

* Data manipulations based on Salehyan's original replication do-file (refugee_regressions2.do)

* Generate interaction terms 
gen mccapshare = capshare - 0.5
gen capref1 = mccapshare * logref1
gen capref2 = mccapshare * logref2

* Drop variables	
drop civwar1
drop civwar2

* Generate new civil war variables
gen civwar1=uppcivcon1
gen civwar2=uppcivcon2

* Label variables in original dataset
label var logref1 "Refugee stock in initiator"
label var logref2 "Refugee stock from initiator"
label var capref1 "Ref. in initiator x capability"
label var capref2 "Ref. from initiator x capability"
label var civwar1 "Civil war in initiator"
label var civwar2 "Civil war in target"
label var dem1 "Democratic initiator"
label var dem2 "Democratic target"
label var demdem "Both democratic"
label var trans1 "Transitional initiator"
label var trans2 "Transitional target"
label var transtrans "Both transitional"
label var contig "Contiguity"
label var colcont "Colonial contiguity"
label var capshare "Capability share"
label var s_wt_glo "Weighted S (absolute distances, valued alliance data [Salehyan's measure])"
label var depend1 "Initiator's trade dependence"
label var depend2 "Target's trade dependence"
label var igos "Shared IGO membership"
label var lpcyrs "Peace years"
label var lpcyrs1 "Spline 1"
label var lpcyrs2 "Spline 2"
label var lpcyrs3 "Spline 3"

* List of model variables
local var mzinit_lead logref1 logref2 civwar1 civwar2 dem1 dem2 demdem trans1 trans2 /*
	*/ transtrans contig colcont capshare s_wt_glo depend1 depend2 igos lpcyrs*

* Drop variables
keep year ccode1 ccode2 capref1 capref2 dyad `var'

* Drop irrelevant observations
drop if year < 1955

* Drop observations for which one of the model variables has missing values
* These observations were automatically dropped from the original analysis
egen miss = rowmiss(`var' capref1 capref2)
drop if miss > 0

* Model 1 without interaction terms
probit `var', cluster(dyad)
estimates store m1

* Model 2 with interaction terms
probit `var' capref1 capref2, cluster(dyad)
estimates store m2

* Print model estimates
estout m1 m2, label legend cells(b(star fmt(3)) se(par fmt(3))) stats(N chi2 ll, fmt(0 1 2))
* Exact replication of original results presented in Table 1 of Salehyan (2008)


* Replication using chance-corrected agreement indices
******************************************************

* Merge Salehyan's data with chance-corrected agreement indices (directed dyadic data based on valued alliance relationships)
sort year ccode1 ccode2
merge year ccode1 ccode2 using "Datasets\Derived\msim-data11b-allysimvalued2.dta", unique

* Generate lagged S value (weighted, absolute differences)
sort ccode1 ccode2 year
generate srswvaal = .
replace srswvaal = srswvaa[_n-1] if ccode1 == ccode1[_n-1] & ccode2 == ccode2[_n-1]
replace srswvaal = . if ccode1 ~= ccode1[_n-1] | ccode2 ~= ccode2[_n-1]
label var srswvaal "Weighted S lagged (absolute distances, valued alliance data)"

* Check merge results and drop unneeded observations
drop if (year < 1955 | year > 2000) & _merge == 2
drop if ccode1 == ccode2 & _merge == 2
tab year if _merge == 2
tab _merge, m
* Most of these dyads are not part of Salehyan's sample because it is restricted to politically relevant dyads
* However, up to 22,000 dyads might have been dropped from Salehyan's sample because one of the variables had a missing value
drop if _merge == 2

* Check and compare similarity scores
rename s_wt_glo Sw
corr Sw srswvaa srswvaal srswvas srsvaa srsvas kappava piva
twoway scatter Sw srswvaa, msymbol(p)
generate diff = Sw - srswvaa
twoway scatter diff year, msymbol(p)
* Minor differences are consistent with minor differences to EUgene data
sum Sw srswvaa srswvaal srswvas srsvaa srsvas, d
list cabb1 cabb2 year Sw srswvaa srswvaal srswvas in 1/50
* Note: Similarity values in Salehyan's study are not lagged by one year as they are clearly more similar to unlagged S values
* Furthermore, lagging the S values would have resulted in a loss of observations and therefore a smaller sample size
list cabb1 cabb2 Sw srswvaa srswvaal srsvas kappava piva if /*
	*/ (cabb1 == "UKG" | cabb1 == "USA" | cabb1 == "RUS" | cabb1 == "FRN" | cabb1 == "CHN") & /*
	*/ (cabb2 == "UKG" | cabb2 == "USA" | cabb2 == "RUS" | cabb2 == "FRN" | cabb2 == "CHN") & year == 1985

* Re-label agreement indices for presentation of regression analysis
label var srsvaa "S (abs. distances)"
label var srsvas "S (sqrd. distances)"
label var kappava "Cohen's kappa"
label var piva "Scott's pi"


* Model 1 in Table 1 (Salehyan 2008)
************************************

* List of model variables
local var mzinit_lead logref1 logref2 civwar1 civwar2 dem1 dem2 demdem trans1 trans2 /*
	*/ transtrans contig colcont capshare depend1 depend2 igos lpcyrs*

* Original model with weighted S using absolute distances
probit `var' Sw, cluster(dyad)
estimates store m1

* Model with weighted S using absolute distances
probit `var' srswvaa, cluster(dyad)
estimates store m1a

* Model with weighted S using squared distances
probit `var' srswvas, cluster(dyad)
estimates store m1b

* Model with S using absolute distances
probit `var' srsvaa, cluster(dyad)
estimates store m1c

* Model with S using squared distances
probit `var' srsvas, cluster(dyad)
estimates store m1d

* Model with Scott's pi
probit `var' piva, cluster(dyad)
estimates store m1e

* Model with Cohen's kappa
probit `var' kappava, cluster(dyad)
estimates store m1f

* Print model estimates
estout m1 m1a m1b m1c m1d m1e m1f, label /*
	*/ cells(b(star fmt(3)) se(par fmt(3))) stats(N chi2 ll, fmt(0 1 2))

* Print model estimates
estout m1 m1a m1b m1c m1d m1e m1f, cells(b(star fmt(2)) se(par fmt(2))) stats(N chi2 ll, fmt(0 2 2) star(chi2))
	

* Model 2 in Table 1 (Salehyan 2008)
************************************

* List of model variables with interactions
local intvar mzinit_lead logref1 logref2 capref1 capref2 civwar1 civwar2 dem1 dem2 demdem trans1 trans2 /*
	*/ transtrans contig colcont capshare depend1 depend2 igos lpcyrs*

* Original model with weighted S using absolute distances
probit `intvar' Sw, cluster(dyad)
estimates store m2
parmest, label list(parm estimate min* max*) saving("Data analysis\Replication analyses\msim-replic02-salehyan2008-m2.dta", replace) idstr(m2)

* Model with weighted S using absolute distances
probit `intvar' srswvaa, cluster(dyad)
estimates store m2a

* Model with weighted S using squared distances
probit `intvar' srswvas, cluster(dyad)
estimates store m2b
parmest, label list(parm estimate min* max*) saving("Data analysis\Replication analyses\msim-replic02-salehyan2008-m2b.dta", replace) idstr(m2b)

* Model with S using absolute distances
probit `intvar' srsvaa, cluster(dyad)
estimates store m2c

* Model with S using squared distances
probit `intvar' srsvas, cluster(dyad)
estimates store m2d

* Model with Scott's pi
probit `intvar' piva, cluster(dyad)
estimates store m2e
parmest, label list(parm estimate min* max*) saving("Data analysis\Replication analyses\msim-replic02-salehyan2008-m2e.dta", replace) idstr(m2e)

* Model with Cohen's kappa
probit `intvar' kappava, cluster(dyad)
estimates store m2f
parmest, label list(parm estimate min* max*) saving("Data analysis\Replication analyses\msim-replic02-salehyan2008-m2f.dta", replace) idstr(m2f)

* Print model estimates
estout m2 m2a m2b m2c m2d m2e m2f, cells(b(star fmt(2)) se(par fmt(2))) stats(N chi2 ll, fmt(0 2 2) star(chi2))

	
* Generate SI-Appendix Table 2
******************************

* Print selected model estimates
estout m2 m2b m2e m2f using "Data analysis\Replication analyses\msim-replic02-salehyan2008-table.txt" /*
	*/ , replace title("Replication of Salehyan's (2008) probit regression analysis of militarized interstate dispute onset (Model 2)") /*
	*/ label collabels(none) legend starlevels(* 0.05) /*
	*/ mlabels("Original weighted S (abs. distances)" "Weighted S (sqrd. distances)" "Scott's Pi" "Cohen's Kappa") /*
	*/ cells(b(star fmt(2)) se(par fmt(2))) /*
	*/ stats(N chi2 ll, fmt(0 2 2) star(chi2) /*
	*/ labels("N" "Chi-squared" "Log likelihood")) 
	

* Exit do-file
log close
exit
