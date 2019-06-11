
* Open log 
**********
capture log close
log using "Data analysis\Replication analyses\msim-replic01-crescenzi2007.log", replace


* ***************************************************************
* Replication of survival analyses in Table 1 of Crescenzi (2007)
* ***************************************************************

* Programme:	msim-replic01-crescenzi2007.do
* Project:		Measuring similarity
* Author:		Frank Haege, Department of Politics and Administration, University of Limerick
* Contact:		frank.haege@ul.ie

* Description
*************
* This do-file replicates the survival analysis in Table 1 of Crescenzi (2007: 391) using different similarity indices.
* The replications of model 3 using the original S measure, Cohen's Kappa, and Scott's Pi are reported in the supporting information.
* Reference: Mark J. C. Crescenzi (2007) 'Reputation and Interstate Conflict'. American Journal of Political Science 51(2): 382-396.
* I thank Mark Crescenzi for providing his replication dataset and do-file.
* (see http://www.unc.edu/depts/polisci/data/ajps07.zip [5 March 2010]).


* Set up Stata
**************
version 11
clear all
macro drop _all
set linesize 80
set more off
set memory 500m


* Replication of Crescenzi's results using the original S measure
*****************************************************************

* Load original dataset
use "Data analysis\Replication analyses\Crescenzi 2007 Interstate conflict, AJPS\ajps_rr_2.dta", clear 

* Label variables in original dataset
label var RISc_min "Reputation"
label var I "Interaction history"
label var RI "Reputation x interaction history"
label var contigdum "Contiguity"
label var lcaprat "Capability ratio (logged)"
label var minmin "Minor powers"
label var smldmat "Regime"
label var S "S (abs. distances, Crescenzi)"
label var ccode1 "Country code 1 (COW)"
label var ccode2 "Country code 2 (COW)"
label var dyadid "Dyad ID"
label var year "Year"

* Drop unneeded variables
keep RISc_min I RI contigdum lcaprat minmin smldmat S dyadid ccode1 ccode2 year _*
drop _merge1 _merge2

* Model 1: Base model
stcox I contigdum lcaprat minmin smldmat S, cl(dyadid) nohr
estimates store m1

* Model 2: RISc standalone model
stcox RISc_min, cl(dyadid) nohr
estimates store m2

* Model 3: Full model
stcox RISc_min I RI contigdum minmin lcaprat smldmat S, cl(dyadid) nohr
estimates store m3
parmest, label list(parm estimate min* max*) saving("Data analysis\Replication analyses\msim-replic01-crescenzi2007-m3.dta", replace) idstr(m3)

* Print model estimates
estout m3 m2 m1, cells(b(star fmt(2)) se(par fmt(2))) stats(N N_fail ll chi2, fmt(0 0 0 1))
* Exact replication of models 1 to 3, except that the second digit of the S-score coefficient in model 3 is 2 instead of 1
* This is most likely due to a rounding error in the original table. Also, the original table seems to report incorrect sample sizes.


* Replication using chance-corrected agreement indices
******************************************************

* Merge Crescenzi's data with chance-corrected agreement indices (directed dyadic data based on valued alliance relationships)
sort year ccode1 ccode2
merge year ccode1 ccode2 using "Datasets\Derived\msim-data11b-allysimvalued2.dta", unique

* Check merge results
tab _merge if year < 1817 
drop if year == 1816 & _merge == 2
tab _merge if ccode1 == ccode2
drop if ccode1 == ccode2 & _merge == 2
tab year if _merge == 2
tab _merge, m
* Not clear why these dyads are not part of Crescenzi's sample
* Checked COW system data again, the dyads are clearly missing in Crescenzi's sample
drop if _merge == 2
drop _merge

* Check and compare similarity scores
corr S srsvaa srsvas kappava piva
twoway scatter S srsvaa, msymbol(p)
sum S srsvaa srsvas, d
list S srsvaa in 1/50
list cabb1 cabb2 S srsvaa srsvas kappava piva if /*
	*/ (cabb1 == "UKG" | cabb1 == "USA" | cabb1 == "RUS" | cabb1 == "FRN" | cabb1 == "CHN") & /*
	*/ (cabb2 == "UKG" | cabb2 == "USA" | cabb2 == "RUS" | cabb2 == "FRN" | cabb2 == "CHN") & year == 1985
* Original S score is slightly different from my S score, probably because of differences in the state system sample
* In general, the EUgene S score is very similar to, but not identical with my S score calculated from the COW alliance data

* Merge with EUgene similarity data
sort ccode1 ccode2 year
merge ccode1 ccode2 year using "Datasets\Derived\msim-data12-eugene.dta", unique
tab _merge, m

* Drop additional observations coming from EUgene data
drop if _merge == 2
drop _merge

* Compare similarity measures
pwcorr S srsvaa s_un_glo s_wt_glo
twoway scatter S srsvaa, msymbol(p)
twoway scatter S s_un_glo, msymbol(p)
twoway scatter srsvaa s_un_glo, msymbol(p)
* Inconsistent effect of similarity variable is not the result of differences
* between EUgene data and my similarity data.
generate diff1 = S-srsvaa
twoway scatter diff1 year, msymbol(p)
generate diff2 = S-s_un_glo
twoway scatter diff2 year, msymbol(p)
generate diff3 = srsvaa-s_un_glo
twoway scatter diff3 year, msymbol(p)
* My similarity measure shows negligible deviations from the EUgene measure
* Neither my nor the EUgene measure is consistent with the measure used in the article

* Re-label chance-corrected agreement indices for presentation of regression results
label var srsvaa "S (abs. distances)"
label var srsvas "S (sqrd. distances)"
label var kappava "Cohen's kappa"
label var piva "Scott's pi"


* Model 1 in Table 1 (Crescenzi 2007)
*************************************

* Base model with my S measure using absolute distances
stcox I contigdum lcaprat minmin smldmat srsvaa, cl(dyadid) nohr
estimates store m1a

* Base model with S using squared distances
stcox I contigdum lcaprat minmin smldmat srswvas, cl(dyadid) nohr
estimates store m1b

* Base model with pi as similarity measure
stcox I contigdum lcaprat minmin smldmat piva, cl(dyadid) nohr
estimates store m1c

* Base model with kappa as similarity measure
stcox I contigdum lcaprat minmin smldmat kappava, cl(dyadid) nohr
estimates store m1d

* Print model estimates
estout m1 m1a m1b m1c m1d, cells(b(star fmt(2)) se(par fmt(2))) stats(N N_fail ll chi2, fmt(0 0 0 1))


* Model 3 in Table 1 (Crescenzi 2007)
*************************************

* Full model with my S measure using absolute distances
stcox RISc_min I RI contigdum minmin lcaprat smldmat srsvaa, cl(dyadid) nohr
estimates store m3a
parmest, label list(parm estimate min* max*) saving("Data analysis\Replication analyses\msim-replic01-crescenzi2007-m3a.dta", replace) idstr(m3a)

* Full model with S using squared distances
stcox RISc_min I RI contigdum minmin lcaprat smldmat srsvas, cl(dyadid) nohr
estimates store m3b
parmest, label list(parm estimate min* max*) saving("Data analysis\Replication analyses\msim-replic01-crescenzi2007-m3b.dta", replace) idstr(m3b)

* Full model model with pi as similarity measure
stcox RISc_min I RI contigdum minmin lcaprat smldmat piva, cl(dyadid) nohr
estimates store m3c
parmest, label list(parm estimate min* max*) saving("Data analysis\Replication analyses\msim-replic01-crescenzi2007-m3c.dta", replace) idstr(m3c)

* Full model with kappa as similarity measure
stcox RISc_min I RI contigdum minmin lcaprat smldmat kappava, cl(dyadid) nohr
estimates store m3d
parmest, label list(parm estimate min* max*) saving("Data analysis\Replication analyses\msim-replic01-crescenzi2007-m3d.dta", replace) idstr(m3d)

	
* Generate SI-Appendix Table 1
******************************
 
* Print model estimates
estout m3 m3a m3b m3c m3d using "Data analysis\Replication analyses\msim-replic01-crescenzi2007-table.txt" /*
	*/ , replace title("Replication of Crescenzi's (2007) Cox survival analysis of dispute onset (Model 3)") /*
	*/ label collabels(none) legend starlevels(* 0.05) /*
	*/ mlabels("Original S (abs. distances)" "S (abs. distances)" /*
	*/ "S (sqrd. distances)" "Scott's Pi" "Cohen's Kappa") /*
	*/ cells(b(star fmt(2)) se(par fmt(2))) /*
	*/ stats(N N_fail ll chi2, fmt(0 0 2 2) star(chi2) /*
	*/ labels("N" "Failures" "Log likelihood" "Chi-squared")) 


* Exit do-file
log close
exit
