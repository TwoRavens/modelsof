/*

	This .do file replicates the analysis in Kinne, Brandon, "IGO Membership,
	Network Convergence, and Credible Signaling in Militarized Disputes,"
	Journal of Peace Research.
	
	This file should be used in combination with the included R files to
	conduct the full replication.

	All estimations were performed on a Linux/Unix machine. If you're using
	Windows, the forward slashes in directory names must be converted to
	back slashes. You might have to do some other stuff, too. Email me if
	you have problems: brandon.kinne@utdallas.edu

*/

clear
clear matrix
set mem 1000m /* Ignore if using Stata 12 */

cd DIRECTORY_WHERE_YOU_UNZIPPED_REPLICATION_ARCHIVE/JPR_Replication
mkdir Logs
mkdir To_R
mkdir Tables
mkdir Figures

use Data/zData.dta, clear
local today = c(current_date)
log using Logs/Stata.output.log
tsset dyadid year, yearly

drop if year < 1970

/* Set a baseline model */
local base = "s_wt_glo igos demlow dep_ab sum_lncap allies contig lndist systsize peaceyrs_mid _spline1_mid _spline2_mid _spline3_mid"

***********
* TABLE 1 *
***********

eststo clear

eststo: logit mid `base', vce(cluster dyadid) nolog /* Baseline model */

forvalues i = 1(2)5 {
	eststo: logit mid requivlag`i' `base', vce(cluster dyadid) nolog
}

esttab using Tables/Table1.tex, se replace nogaps pr2 aic bic sca(N_g N_clust ll) star(* 0.05 ** 0.01 *** 0.001) drop(syst* peace* _spline*)
eststo clear

***********
* TABLE 2 *
***********

/* Fixed effects model */
xtlogit mid requivlag5 `base', fe noskip
estimates store est1

/* Mixed effects model. WARNING! This model will take anywhere
from a few days to a few WEEKS to estimate, depending on your
computing power! Proceed with caution...	*/
xtmelogit mid requivlag5 s_wt_glo igos demlow dep_ab sum_lncap allies contig lndist systsize peaceyrs_mid || _all: R.ccode1 || ccode2:
estimates store est2

/* Use k-adic data */
preserve
use Data/zDataKad.dta, clear
relogit mid requivlag5 s_wt_glo igos demlow dep_ab sum_lncap allies contig lndist ndpeace [pweight=ipweight], cluster(kad_id)
estimates store est3
estimates save kadic, replace
restore

/* Add a dummy column for SAOM (estimated in R) */
logit mid
estimates store est4

estimates use kadic
esttab est1 est2 est3 est4 using Tables/Table2.tex, se replace nogaps pr2 aic bic sca(N_g N_clust ll) star(* 0.05 ** 0.01 *** 0.001) drop(syst* peace* _spline* ndpeace)
eststo clear


********************************************
* Predicted probabilities for each measure *
********************************************

forvalues i = 1(1)20 { /* Rescale convergence measures to [0,1] interval */
	summ requivlag`i'
	gen requivlag`i'V2 = requivlag`i' + abs(r(min))
	summ requivlag`i'V2
	replace requivlag`i'V2 = requivlag`i'V2/r(max)
	corr requivlag`i' requivlag`i'V2
}

egen eqindx = fill(0(10)100)
replace eqindx=. if eqindx>100
levelsof eqindx, local(lev)
forvalues p=1(2)5 {
	gen pr`p' = .
	quietly estsimp logit mid requivlag`p'V2 `base', vce(cluster dyadid) nolog
	setx mean
	foreach l of local lev {
		/* Fill in percentiles */
		setx requivlag`p'V2 `l'/100
		quietly simqi, prval(1) genpr(pr)
		sum pr, meanonly
		replace pr`p' = r(mean) if eqindx==`l'
		drop pr
	}
	drop b1-b15
}

preserve
drop if pr1==.
outsheet pr1 pr3 pr5 using To_R/PreProbs.dat, nonames replace
restore
drop pr1 pr3 pr5 eqindx


*****************************************
* Predicted probabilities over 20 years *
*****************************************

gen prmid = .
gen prsd = .

forvalues i=1(1)20 { /* Use a one standard deviation increase here */
	quietly estsimp logit mid requivlag`i'V2 `base' if requivlag20V2!=., vce(cluster dyadid) nolog
	setx mean
	quietly simqi, prval(1) genpr(pr1)
	summ requivlag`i'V2 if requivlag20V2!=.
	setx requivlag`i'V2 r(mean)+r(sd)
	quietly simqi, prval(1) genpr(pr2)
	gen test = ((pr2-pr1)/pr1)*100
	summ test
	replace prmid = r(mean) in `i'
	replace prsd = r(sd) in `i'
	drop pr1 pr2 test
	drop b1-b15
}

preserve
drop if prmid==.
outsheet prmid prsd using To_R/20yrProbs.dat, nonames replace
restore
drop requivlag1V2-requivlag20V2 prmid prsd


***********************************
* Compare measures of preferences *
***********************************

/* First save a correlation table */
corrtex requivlag5 tau_glob tau5 s_wt_glo swt5 s3un s3un5, file(Tables/Correlations.tex) replace digits(3)

foreach var of varlist requivlag5 tau_glob tau5 s_wt_glo swt5 s3un s3un5 {
	/* Rescale between zero and one */
	quietly summ `var'
	replace `var' = `var' + abs(r(min))
	quietly summ `var'
	replace `var' = `var' / r(max)
}

egen eqindx = fill(0(10)100)
replace eqindx=. if eqindx>100
levelsof eqindx, local(lev)
gen prefMN = .
gen prefSE = .
gen requivMN = .
gen requivSE = .
local base_alt = "igos demlow dep_ab sum_lncap allies contig lndist systsize peaceyrs_mid _spline1_mid _spline2_mid _spline3_mid"
local c = 1
foreach var of varlist tau_glob tau5 s_wt_glo swt5 s3un s3un5 {
	gen pr`var' = .
	gen sd`var' = .
	gen repr`var' = .
	gen resd`var' = .
	quietly estsimp logit mid `var' requivlag5 `base_alt', vce(cluster dyadid) nolog
		/* Capture estimates and standard errors first */
		replace requivMN = _b[requivlag5] in `c'
		replace requivSE = _se[requivlag5] in `c'
		replace prefMN = _b[`var'] in `c'
		replace prefSE = _se[`var'] in `c'
		local c = `c' + 1
	setx mean
	foreach l of local lev {
		/* First do the preferences measure */
		setx `var' `l'/100
		quietly simqi, prval(1) genpr(pr)
		sum pr
		replace pr`var' = r(mean) if eqindx==`l'
		replace sd`var' = r(sd) if eqindx==`l'
		drop pr
	}
	setx mean
	foreach l of local lev {
		/* Then do network convergence measure */
		setx requivlag5 `l'/100
		quietly simqi, prval(1) genpr(pr)
		sum pr
		replace repr`var' = r(mean) if eqindx==`l'
		replace resd`var' = r(sd) if eqindx==`l'
		drop pr
	}
	drop b1-b15
}

preserve
keep eqindx prtau_glob - resds3un5
drop if prtau_glob==.
outsheet using To_R/Equiv-Prefs_Probs.dat, nonames replace
restore

preserve
keep prefMN prefSE requivMN requivSE
drop if prefMN == .
outsheet using To_R/Equiv-Prefs_Ests.dat, nonames replace
restore

drop eqindx-resds3un5


***************************************************************************
* Effect of convergence with IGOs disaggregated by structure and function *
***************************************************************************

gen mn = .
gen se = .
gen dmn = .
gen dse = .
local c = 1
foreach var of varlist relequivf1s2d5 relequivf2s2d5 relequivf3s2d5 relequivf1s36d5 relequivf2s36d5 relequivf3s36d5 relequivf1s79d5 relequivf2s79d5 relequivf3s79d5 relequivs1d5 relequivs2d5 relequivs3d5 relequivf2d5 relequivf36d5 relequivf79d5 {

	/* Rescale */
	quietly summ `var'
	gen new`var' = `var' + abs(r(min))
	quietly summ new`var'
	replace new`var' = new`var' / r(max)
	
	/* This part records means and standard errors only */
	quietly logit mid new`var' `base', vce(cluster dyadid) nolog
	replace mn = _b[new`var'] in `c'
	replace se = _se[new`var'] in `c'
	drop new`var'

	/* This part generates % change in predicted probability */
	quietly estsimp logit mid `var' `base', vce(cluster dyadid) nolog
	setx mean
	quietly simqi, prval(1) genpr(pr1)
	quietly summ `var'
	setx `var' r(mean)+r(sd)
	quietly simqi, prval(1) genpr(pr2)	
	gen d = ((pr2-pr1)/pr1)*100
	summ d
	replace dmn = r(mean) in `c'
	replace dse = r(sd) in `c'
	drop pr1 pr2 b1-b15 d
	local c = `c' + 1

}

preserve
keep mn se dmn dse
drop if mn==.
outsheet using To_R/Structure-Function_Estimates.dat, nonames replace
restore

/* EL FIN! Now run the R file... */
