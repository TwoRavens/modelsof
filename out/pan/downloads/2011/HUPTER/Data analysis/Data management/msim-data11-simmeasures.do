
* Open log 
**********
capture log close
log using "Data analysis\Data management\msim-data11-simmeasures.log", replace


* **********************************
* Calculation of similarity measures
* **********************************

* Programme:	msim-data11-simmeasures.do
* Project:		Measuring similarity
* Author:		Frank Haege, Department of Politics and Administration, University of Limerick
* Contact:		frank.haege@ul.ie

* Description
*************
* This do-file calculates Signorino and Ritter's S, Cohen's kappa, and Scott's pi.
* The input datasets consist of component variables for directed and undirected dyads derived from valued and binary alliance as well as UN voting relationships.


* Set up Stata
**************
version 11
clear all
macro drop _all
set linesize 80
set more off


* Valued alliance data for directed dyads (two observations per dyad)
*********************************************************************

* Load dataset
use "Datasets\Derived\msim-data10b-allysimvalued2.dta", clear

* Generate Signorino & Ritter's S based on squared distance metric

* Unweigted version
generate denomsrsvas = ((3-0)^2*nobs)/2
label var denomsrsvas "Unweighted S denominator (squared distances, valued alliance data)"
generate srsvas = 1-(ssd/denomsrsvas)
label var srsvas "Unweighted S (squared distances, alliance data)"

* Weighted version
generate denomsrswvas = (ssdwm)/2
label var denomsrswvas "Weighted S denominator (squared distances, valued alliance data)"
generate srswvas = 1-(ssdw/denomsrswvas)
label var srswvas "Weighted S (squared distances, valued alliance data)"

* Generate Signorino & Ritter's S based on absolute distance metric

* Unweigted version
generate denomsrsvaa = ((3-0)*nobs)/2
label var denomsrsvaa "Unweighted S denominator (absolute distances, valued alliance data)"
generate srsvaa = 1-(sad/denomsrsvaa)
label var srsvaa "Unweighted S (absolute distances, valued alliance data)"

* Weigted version
generate denomsrswvaa = (sadwm)/2
label var denomsrswvaa "Weighted S denominator (absolute distances, valued alliance data)"
generate srswvaa = 1-(sadw/denomsrswvaa)
label var srswvaa "Weighted S (absolute distances, valued alliance data)"

* Generate Cohen's kappa based on squared distance metric
generate denomkappava = ss1+ss2 - (2/nobs)*s1*s2
label var denomkappava "Kappa denominator (squared distances, valued alliance data)"
generate kappava = 1-(ssd/denomkappava)
label var kappava "Kappa (squared distances, valued alliance data)"

* Generate Scott's pi based on squared distance metric
generate denompiva = ss1+ss2 - (s1+s2)^2/(nobs*2)
label var denompiva "Pi denominator (squared distances, valued alliance data)"
generate piva = 1-(ssd/denompiva)
label var piva "Pi (squared distances, valued alliance data)"

* Save dataset
compress
save "Datasets\Derived\msim-data11b-allysimvalued2.dta", replace


* Valued alliance data for undirected dyads (one observation per dyad)
**********************************************************************

* Load dataset
use "Datasets\Derived\msim-data10a-allysimvalued1.dta", clear

* Generate Signorino & Ritter's S based on squared distance metric

* Unweigted version
generate denomsrsvas = ((3-0)^2*nobs)/2
label var denomsrsvas "Unweighted S denominator (squared distances, valued alliance data)"
generate srsvas = 1-(ssd/denomsrsvas)
label var srsvas "Unweighted S (squared distances, valued alliance data)"

* Weighted version
generate denomsrswvas = (ssdwm)/2
label var denomsrswvas "Weighted S denominator (squared distances, valued alliance data)"
generate srswvas = 1-(ssdw/denomsrswvas)
label var srswvas "Weighted S (squared distances, valued alliance data)"

* Generate Signorino & Ritter's S based on absolute distance metric

* Unweigted version
generate denomsrsvaa = ((3-0)*nobs)/2
label var denomsrsvaa "Unweighted S denominator (absolute distances, valued alliance data)"
generate srsvaa = 1-(sad/denomsrsvaa)
label var srsvaa "Unweighted S (absolute distances, valued alliance data)"

* Weigted version
generate denomsrswvaa = (sadwm)/2
label var denomsrswvaa "Weighted S denominator (absolute distances, valued alliance data)"
generate srswvaa = 1-(sadw/denomsrswvaa)
label var srswvaa "Weighted S (absolute distances, valued alliance data)"

* Generate Cohen's kappa based on squared distance metric
generate denomkappava = ss1+ss2 - (2/nobs)*s1*s2
label var denomkappava "Kappa denominator (squared distances, valued alliance data)"
generate kappava = 1-(ssd/denomkappava)
label var kappava "Kappa (squared distances, valued alliance data)"

* Generate Scott's pi based on squared distance metric
generate denompiva = ss1+ss2 - (s1+s2)^2/(nobs*2)
label var denompiva "Pi denominator (squared distances, valued alliance data)"
generate piva = 1-(ssd/denompiva)
label var piva "Pi (squared distances, valued alliance data)"

* Save dataset
compress
save "Datasets\Derived\msim-data11a-allysimvalued1.dta", replace


* Binary alliance data for directed dyads (two observations per dyad)
*********************************************************************

* Load dataset
use "Datasets\Derived\msim-data10d-allysimbinary2.dta", clear

* Generate Signorino & Ritter's S

* Unweigted version
generate denomsrsba = ((1-0)^2*nobs)/2
label var denomsrsba "Unweighted S denominator (binary alliance data)"
generate srsba = 1-(ssd/denomsrsba)
label var srsba "Unweighted S (binary alliance data)"

* Weigted version
generate denomsrswba = ((1-0)^2)/2
label var denomsrswba "Weighted S denominator (binary alliance data)"
generate srswba = 1-(ssdw/denomsrswba)
label var srswba "Weighted S (binary alliance data)"

* Generate Cohen's kappa
generate denomkappaba = ss1+ss2 - (2/nobs)*s1*s2
label var denomkappaba "Kappa denominator (binary alliance data)"
generate kappaba = 1-(ssd/denomkappaba)
label var kappaba "Kappa (binary alliance data)"

* Generate Scott's pi
generate denompiba = ss1+ss2 - (s1+s2)^2/(nobs*2)
label var denompiba "Pi denominator (binary alliance data)"
generate piba = 1-(ssd/denompiba)
label var piba "Pi (binary alliance data)"

* Save dataset
compress
save "Datasets\Derived\msim-data11d-allysimbinary2.dta", replace


* Binary alliance data for undirected dyads (one observation per dyad)
**********************************************************************

* Load dataset
use "Datasets\Derived\msim-data10c-allysimbinary1.dta", clear

* Generate Signorino & Ritter's S

* Unweigted version
generate denomsrsba = ((1-0)^2*nobs)/2
label var denomsrsba "Unweighted S denominator (binary alliance data)"
generate srsba = 1-(ssd/denomsrsba)
label var srsba "Unweighted S (binary alliance data)"

* Weigted version
generate denomsrswba = ((1-0)^2)/2
label var denomsrswba "Weighted S denominator (binary alliance data)"
generate srswba = 1-(ssdw/denomsrswba)
label var srswba "Weighted S (binary alliance data)"

* Generate Cohen's kappa
generate denomkappaba = ss1+ss2 - (2/nobs)*s1*s2
label var denomkappaba "Kappa denominator (binary alliance data)"
generate kappaba = 1-(ssd/denomkappaba)
label var kappaba "Kappa (binary alliance data)"

* Generate Scott's pi
generate denompiba = ss1+ss2 - (s1+s2)^2/(nobs*2)
label var denompiba "Pi denominator (binary alliance data)"
generate piba = 1-(ssd/denompiba)
label var piba "Pi (binary alliance data)"

* Save dataset
compress
save "Datasets\Derived\msim-data11c-allysimbinary1.dta", replace


* Valued UN voting data for directed dyads (two observations per dyad)
**********************************************************************

* Load dataset
use "Datasets\Derived\msim-data10f-votesimvalued2.dta", clear

* Drop dyads that did not vote on the same issue during a year
drop if nobs == 0

* Generate Signorino & Ritter's S based on squared distance metric
generate denomsrsvvs = ((3-1)^2*nobs)/2
label var denomsrsvvs "Unweighted S denominator (squared distances, valued UN voting data)"
generate srsvvs = 1-(ssd/denomsrsvvs)
label var srsvvs "Unweighted S (squared distances, valued UN voting data)"

* Generate Signorino & Ritter's S based on absolute distance metric
generate denomsrsvva = ((3-1)*nobs)/2
label var denomsrsvva "Unweighted S denominator (absolute distances, valued UN voting data)"
generate srsvva = 1-(sad/denomsrsvva)
label var srsvva "Unweighted S (absolute distances, valued UN voting data)"

* Generate Cohen's kappa based on squared distance metric
generate denomkappavv = ss1+ss2 - (2/nobs)*s1*s2
label var denomkappavv "Kappa denominator (squared distances, valued UN voting data)"
generate kappavv = 1-(ssd/denomkappavv) if denomkappavv ~= 0
replace kappavv = 0 if denomkappavv == 0
label var kappavv "Kappa (squared distances, valued UN voting data)"

* Generate Scott's pi based on squared distance metric
generate denompivv = ss1+ss2 - (s1+s2)^2/(nobs*2)
label var denompivv "Pi denominator (squared distances, valued UN voting data)"
generate pivv = 1-(ssd/denompivv) if denompivv ~= 0
replace pivv = 0 if denompivv == 0
label var pivv "Pi (squared distances, valued UN voting data)"

* Save dataset
compress
save "Datasets\Derived\msim-data11f-votesimvalued2.dta", replace


* Valued UN voting data for undirected dyads (one observation per dyad)
***********************************************************************

* Load dataset
use "Datasets\Derived\msim-data10e-votesimvalued1.dta", clear

* Drop dyads that did not vote on the same issue during a year
drop if nobs == 0

* Generate Signorino & Ritter's S based on squared distance metric
generate denomsrsvvs = ((3-1)^2*nobs)/2
label var denomsrsvvs "Unweighted S denominator (squared distances, valued UN voting data)"
generate srsvvs = 1-(ssd/denomsrsvvs)
label var srsvvs "Unweighted S (squared distances, valued UN voting data)"

* Generate Signorino & Ritter's S based on absolute distance metric
generate denomsrsvva = ((3-1)*nobs)/2
label var denomsrsvva "Unweighted S denominator (absolute distances, valued UN voting data)"
generate srsvva = 1-(sad/denomsrsvva)
label var srsvva "Unweighted S (absolute distances, valued UN voting data)"

* Generate Cohen's kappa based on squared distance metric
generate denomkappavv = ss1+ss2 - (2/nobs)*s1*s2
label var denomkappavv "Kappa denominator (squared distances, valued UN voting data)"
generate kappavv = 1-(ssd/denomkappavv) if denomkappavv ~= 0
replace kappavv = 0 if denomkappavv == 0
label var kappavv "Kappa (squared distances, valued UN voting data)"

* Generate Scott's pi based on squared distance metric
generate denompivv = ss1+ss2 - (s1+s2)^2/(nobs*2)
label var denompivv "Pi denominator (squared distances, valued UN voting data)"
generate pivv = 1-(ssd/denompivv) if denompivv ~= 0
replace pivv = 0 if denompivv == 0
label var pivv "Pi (squared distances, valued UN voting data)"

* Save dataset
compress
save "Datasets\Derived\msim-data11e-votesimvalued1.dta", replace


* Exit do-file
log close
exit
