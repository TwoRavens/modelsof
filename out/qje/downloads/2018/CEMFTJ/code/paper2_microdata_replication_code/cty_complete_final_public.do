/***
 This program generates the final County level Dataset final_cty.dta
 Inputs: raw estimates by County sent out of IRS and covariates produced using public data 
 Output: final County level Dataset final_cty.dta
***/

clear all 
set maxvar 32000
set matsize 11000
set more off

global db "${dropbox}"
cd "$db/movers/analysis"

********************************************************************************
*************************** CTY LEVEL DATASET **********************************
********************************************************************************

global geo cty
global cz_pop_cutoff 25000
global cty_pop_cutoff 10000

* 1) Use CTY CZ crosswalk

use crosswalks/cty_cz_cw.dta, clear

* 2) Use CTY and CZ population 

	* 2.1) CTY population
		preserve
		use "covariates/all_data/cty_pop.dta", clear
		rename pop2000 cty_pop2000
			* recode to 1990 counties 
			replace cty =12025  if cty == 12086
			replace cty = 2231 if cty == 2232
			tempfile ctypop
			save `ctypop'
		restore
		merge 1:1 cty using `ctypop', nogen keep(match)
	
			
	* 2.2) CZ population 
	merge m:1 cz using "covariates/all_data/cz_pop.dta", nogen keep(match)
	rename pop2000 cz_pop2000
	label var cz_pop2000 " CZ Population in 2000 Census"

	
* 2) Merge with CTY estimates, set as missing if below pop cutoff and de-mean the estimates

	* 2.0) Generate nb of county by CZ
	bys cz: gen cty_by_cz = _N

	* 2.1) Baseline beta j 
	
	foreach outcome in kr26 { 
	foreach spec in _cc2 _cc _cc3 _am_cc2 _bm_cc2 _f_cc2 _m_cc2 _sp_cc2 _tp_cc2 _pbo_cc2 _pmi_cc2 { 

	merge 1:1 cty using beta/beta_final/CTY/used_specs/cty_in_cz_`outcome'`spec'.dta, nogen 
	bys cz: egen n_cty_nonmiss_`outcome'`spec' = count(Bj_p25_cty_`outcome'`spec')
	foreach ppp in 1 25 50 75 99 {
	replace Bj_p`ppp'_cty_`outcome'`spec'=. if (cz_pop2000<${cz_pop_cutoff}|cty_pop2000<${cty_pop_cutoff}|n_cty_nonmiss_`outcome'`spec'<cty_by_cz)
	replace Bj_p`ppp'_cty_`outcome'`spec'_se=. if (cz_pop2000<${cz_pop_cutoff}|cty_pop2000<${cty_pop_cutoff}|n_cty_nonmiss_`outcome'`spec'<cty_by_cz)
	label var Bj_p`ppp'_cty_`outcome'`spec' "Raw Causal Place Effect"
	label var Bj_p`ppp'_cty_`outcome'`spec'_se "Raw Standard error"
	}
	}
	}

	foreach outcome in c1823 { 
	foreach spec in _cc2 _f_cc2 _m_cc2 _sp_cc2 _tp_cc2 {
	merge 1:1 cty using beta/beta_final/CTY/used_specs/cty_in_cz_`outcome'`spec'.dta, nogen 
	bys cz: egen n_cty_nonmiss_`outcome'`spec' = count(Bj_p25_cty_`outcome'`spec')
	foreach ppp in 1 25 50 75 99 {
	replace Bj_p`ppp'_cty_`outcome'`spec'=. if (cz_pop2000<${cz_pop_cutoff}|cty_pop2000<${cty_pop_cutoff}|n_cty_nonmiss_`outcome'`spec'<cty_by_cz)
	replace Bj_p`ppp'_cty_`outcome'`spec'_se=. if (cz_pop2000<${cz_pop_cutoff}|cty_pop2000<${cty_pop_cutoff}|n_cty_nonmiss_`outcome'`spec'<cty_by_cz)
	label var Bj_p`ppp'_cty_`outcome'`spec' "Raw Causal Place Effect"
	label var Bj_p`ppp'_cty_`outcome'`spec'_se "Raw Standard error"
	}
	}
	}
	
	* 2.2) Other outcomes

	foreach outcome in kir26 kir26_f kir26_m kfi26 kfi26_m kfi26_f kii26 kii26_m kii26_f km26 kr26_sq kr26_coli tlpbo_16 { 
	foreach spec in _cc2 {
	
	if "`outcome'" == "kr26_coli" {
		merge 1:1 cty using beta/beta_final/CTY/used_specs/cty_in_cz_kr26_coli1996_cc2.dta, nogen 
		rename *coli1996* *coli*
	}
	else {
		merge 1:1 cty using beta/beta_final/CTY/used_specs/cty_in_cz_`outcome'`spec'.dta, nogen 
	}
	

	bys cz: egen n_cty_nonmiss_`outcome'`spec' = count(Bj_p25_cty_`outcome'`spec')

	foreach ppp in 1 25 50 75 99 {
	replace Bj_p`ppp'_cty_`outcome'`spec'=. if (cz_pop2000<${cz_pop_cutoff}|cty_pop2000<${cty_pop_cutoff}|n_cty_nonmiss_`outcome'`spec'<cty_by_cz)
	replace Bj_p`ppp'_cty_`outcome'`spec'_se=. if (cz_pop2000<${cz_pop_cutoff}|cty_pop2000<${cty_pop_cutoff}|n_cty_nonmiss_`outcome'`spec'<cty_by_cz)
	label var Bj_p`ppp'_cty_`outcome'`spec' "Raw Causal Place Effect"
	label var Bj_p`ppp'_cty_`outcome'`spec'_se "Raw Standard error"
	}
	}
	}
	
	* 2.3) Split Sample 
	
	foreach outcome in  kr26 { 
	foreach spec in _cc2{
	foreach splitsample in _c0 _c1 {
	merge 1:1 cty using beta/beta_final/CTY/used_specs/cty_in_cz_`outcome'`spec'`splitsample'.dta, nogen 
	bys cz: egen n_cty_nonmiss_`outcome'`spec'`splitsample' = count(Bj_p25_cty_`outcome'`spec'`splitsample')

	foreach ppp in 1 25 50 75 99 {
	replace Bj_p`ppp'_cty_`outcome'`spec'`splitsample'=. if (cz_pop2000<${cz_pop_cutoff}|cty_pop2000<${cty_pop_cutoff}|n_cty_nonmiss_`outcome'`spec'`splitsample'<cty_by_cz)
	label var Bj_p`ppp'_cty_`outcome'`spec'`splitsample' "Raw Causal Place Effect: Split Sample "
	}
	}
	}
	}
	* 2.4) Split Sample TLPBO
	
	foreach outcome in  tlpbo_16 kr26_16 { 
	foreach spec in _cc2{
	foreach splitsample in _ss1 _ss2 {
	merge 1:1 cty using beta/beta_final/CTY/used_specs/cty_in_cz_`outcome'`spec'`splitsample'.dta, nogen 
	bys cz: egen n_cty_nonmiss_`outcome'`spec'`splitsample' = count(Bj_p25_cty_`outcome'`spec'`splitsample')

	foreach ppp in 1 25 50 75 99 {
	replace Bj_p`ppp'_cty_`outcome'`spec'`splitsample'=. if (cz_pop2000<${cz_pop_cutoff}|cty_pop2000<${cty_pop_cutoff}|n_cty_nonmiss_`outcome'`spec'`splitsample'<cty_by_cz)
	label var Bj_p`ppp'_cty_`outcome'`spec'`splitsample' "Raw Causal Place Effect: Split Sample "
	}
	}
	}
	}

	
* 3) Merge with CZ estimates 

	*3.1) Baseline beta j 
			
	foreach outcome in kr26 { 
	foreach spec in _cc2 _cc _cc3 _am_cc2 _bm_cc2 _f_cc2 _m_cc2 _sp_cc2 _tp_cc2 _pbo_cc2 _pmi_cc2 { 
	merge m:1 cz using beta/beta_final/CZ/used_specs/cz_`outcome'`spec'.dta, nogen 
	
	foreach ppp in 1 25 50 75 99 {
	replace Bj_p`ppp'_cz`outcome'`spec'=. if cz_pop2000<${cz_pop_cutoff} | cty_pop2000<${cty_pop_cutoff}
	replace Bj_p`ppp'_cz`outcome'`spec'_se=. if cz_pop2000<${cz_pop_cutoff} | cty_pop2000<${cty_pop_cutoff}
	su Bj_p`ppp'_cz`outcome'`spec' [w=cz_pop2000/cty_by_cz]
	replace Bj_p`ppp'_cz`outcome'`spec' = Bj_p`ppp'_cz`outcome'`spec'-r(mean)
	}
	}
	}

	foreach outcome in c1823 { 
	foreach spec in _cc2 _f_cc2 _m_cc2 _sp_cc2 _tp_cc2 {
	merge m:1 cz using beta/beta_final/CZ/used_specs/cz_`outcome'`spec'.dta, nogen 
	foreach ppp in 1 25 50 75 99 {
	replace Bj_p`ppp'_cz`outcome'`spec'=. if cz_pop2000<${cz_pop_cutoff} | cty_pop2000<${cty_pop_cutoff}
	replace Bj_p`ppp'_cz`outcome'`spec'_se=. if cz_pop2000<${cz_pop_cutoff} | cty_pop2000<${cty_pop_cutoff}
	su Bj_p`ppp'_cz`outcome'`spec' [w=cz_pop2000/cty_by_cz]
	replace Bj_p`ppp'_cz`outcome'`spec' = Bj_p`ppp'_cz`outcome'`spec'-r(mean)
	}
	}
	}
	
	*3.2) Other outcomes
	
	foreach outcome in  kir26 kir26_f kir26_m km26 kfi26 kfi26_m kfi26_f kii26 kii26_f kii26_m kr26_sq kr26_coli1996 tlpbo_16 { 
	foreach spec in _cc2{
	merge m:1 cz using beta/beta_final/CZ/used_specs/cz_`outcome'`spec'.dta, nogen 
	foreach ppp in 1 25 50 75 99 {
	replace Bj_p`ppp'_cz`outcome'`spec'=. if cz_pop2000<${cz_pop_cutoff} | cty_pop2000<${cty_pop_cutoff}
	replace Bj_p`ppp'_cz`outcome'`spec'_se=. if cz_pop2000<${cz_pop_cutoff} | cty_pop2000<${cty_pop_cutoff}
	su Bj_p`ppp'_cz`outcome'`spec' [w=cz_pop2000/cty_by_cz]
	replace Bj_p`ppp'_cz`outcome'`spec' = Bj_p`ppp'_cz`outcome'`spec'-r(mean)
	}
	}
	}
	
	* 3.3) Split Sample 
	
	foreach outcome in  kr26 { 
	foreach spec in _cc2{
	foreach splitsample in _c0 _c1 _16_ss1 _16_ss2{
	merge m:1 cz using beta/beta_final/CZ/used_specs/cz_`outcome'`spec'`splitsample'.dta, nogen 
	foreach ppp in 1 25 50 75 99 {
	replace Bj_p`ppp'_cz`outcome'`spec'`splitsample'=. if cz_pop2000<${cz_pop_cutoff} | cty_pop2000<${cty_pop_cutoff}
	replace Bj_p`ppp'_cz`outcome'`spec'`splitsample'_se=. if cz_pop2000<${cz_pop_cutoff} | cty_pop2000<${cty_pop_cutoff}
	su Bj_p`ppp'_cz`outcome'`spec'`splitsample' [w=cz_pop2000/cty_by_cz]
	replace Bj_p`ppp'_cz`outcome'`spec'`splitsample' = Bj_p`ppp'_cz`outcome'`spec'`splitsample'-r(mean)
	}
	}
	}
	}
	* 3.4) Split Sample TLPBO
	
	foreach outcome in  tlpbo_16 { 
	foreach spec in _cc2{
	foreach splitsample in _ss1 _ss2 {
	merge m:1 cz using beta/beta_final/CZ/used_specs/cz_`outcome'`spec'`splitsample'.dta, nogen 
	foreach ppp in 1 25 50 75 99 {
	replace Bj_p`ppp'_cz`outcome'`spec'`splitsample'=. if cz_pop2000<${cz_pop_cutoff} | cty_pop2000<${cty_pop_cutoff}
	replace Bj_p`ppp'_cz`outcome'`spec'`splitsample'_se=. if cz_pop2000<${cz_pop_cutoff} | cty_pop2000<${cty_pop_cutoff}
	su Bj_p`ppp'_cz`outcome'`spec'`splitsample' [w=cz_pop2000/cty_by_cz]
	replace Bj_p`ppp'_cz`outcome'`spec'`splitsample' = Bj_p`ppp'_cz`outcome'`spec'`splitsample'-r(mean)
	}
	}
	}
	}

	
*4) Generate CTY + CZ estimates

	*4.1) Baseline beta j 

	foreach outcome in kr26 { 
	foreach spec in _cc2 _cc _cc3 _am_cc2 _bm_cc2 _f_cc2 _m_cc2 _sp_cc2 _tp_cc2 _pbo_cc2 _pmi_cc2 { 
	foreach ppp in 1 25 50 75 99 {
	* generate CTY + CZ spec
	gen Bj_p`ppp'_cz_cty_`outcome'`spec' = Bj_p`ppp'_cz`outcome'`spec' + Bj_p`ppp'_cty_`outcome'`spec'
	label var Bj_p`ppp'_cz_cty_`outcome'`spec' "Raw Causal Place Effect: County and CZ"
	
	* Use CZ estimate if there is only one county in the CZ
	replace Bj_p`ppp'_cz_cty_`outcome'`spec' = Bj_p`ppp'_cz`outcome'`spec' if Bj_p`ppp'_cty_`outcome'`spec'==. & cty_by_cz==1
	
	* Override for Las Vegas (cz 37901, cty == 32003) for kr26_m and kir26_m because it happens to be disconnected
	if "`outcome'"=="kr26"{
	if "`spec'"=="_m_cc2"{
	replace Bj_p`ppp'_cz_cty_`outcome'`spec' = Bj_p`ppp'_cz`outcome'`spec' if Bj_p`ppp'_cty_`outcome'`spec'==. & cty==32003
	}
	}
	
	* generate cty + cz s.e.
	gen Bj_p`ppp'_cz_cty_`outcome'`spec'_se = sqrt(Bj_p`ppp'_cz`outcome'`spec'_se^2 + (Bj_p`ppp'_cty_`outcome'`spec'_se)^2)
	replace Bj_p`ppp'_cz_cty_`outcome'`spec'_se = Bj_p`ppp'_cz`outcome'`spec'_se if Bj_p`ppp'_cz_cty_`outcome'`spec'_se ==. & Bj_p`ppp'_cz_cty_`outcome'`spec'~=.

	drop Bj_p`ppp'_cz`outcome'`spec'
	drop Bj_p`ppp'_cz`outcome'`spec'_se
	}
	}
	}

	foreach outcome in c1823 { 
	foreach spec in _cc2 _f_cc2 _m_cc2 _sp_cc2 _tp_cc2 {
	foreach ppp in 1 25 50 75 99 {
	* generate CTY + CZ spec
	gen Bj_p`ppp'_cz_cty_`outcome'`spec' = Bj_p`ppp'_cz`outcome'`spec' + Bj_p`ppp'_cty_`outcome'`spec'
	label var Bj_p`ppp'_cz_cty_`outcome'`spec' "Raw Causal Place Effect: County and CZ"
	
	* Use CZ estimate if there is only one county in the CZ
	replace Bj_p`ppp'_cz_cty_`outcome'`spec' = Bj_p`ppp'_cz`outcome'`spec' if Bj_p`ppp'_cty_`outcome'`spec'==. & cty_by_cz==1
	
	* generate cty + cz s.e.
	gen Bj_p`ppp'_cz_cty_`outcome'`spec'_se = sqrt(Bj_p`ppp'_cz`outcome'`spec'_se^2 + (Bj_p`ppp'_cty_`outcome'`spec'_se)^2)
	replace Bj_p`ppp'_cz_cty_`outcome'`spec'_se = Bj_p`ppp'_cz`outcome'`spec'_se if Bj_p`ppp'_cz_cty_`outcome'`spec'_se ==. & Bj_p`ppp'_cz_cty_`outcome'`spec'~=.
	
	drop Bj_p`ppp'_cz`outcome'`spec'
	drop Bj_p`ppp'_cz`outcome'`spec'_se
	}
	}
	}
	
	*4.2) Other outcomes
	
	foreach outcome in kir26 kir26_f kir26_m km26 kfi26 kfi26_m kfi26_f kii26 kii26_f kii26_m kr26_sq kr26_coli tlpbo_16 { 
	foreach spec in _cc2{
	foreach ppp in 1 25 50 75 99 {
	
	if "`outcome'" == "kr26_coli" {
		capture rename *coli1996* *coli*
	}
	
	* generate CTY + CZ spec
	gen Bj_p`ppp'_cz_cty_`outcome'`spec' = Bj_p`ppp'_cz`outcome'`spec' + Bj_p`ppp'_cty_`outcome'`spec'
	
	* generate cty + cz s.e.
	gen Bj_p`ppp'_cz_cty_`outcome'`spec'_se = sqrt(Bj_p`ppp'_cz`outcome'`spec'_se^2 + (Bj_p`ppp'_cty_`outcome'`spec'_se)^2)
	replace Bj_p`ppp'_cz_cty_`outcome'`spec'_se = Bj_p`ppp'_cz`outcome'`spec'_se if Bj_p`ppp'_cz_cty_`outcome'`spec'_se ==. & Bj_p`ppp'_cz_cty_`outcome'`spec'~=.
	label var Bj_p`ppp'_cz_cty_`outcome'`spec' "Raw Causal Place Effect: County and CZ"
	
	* Use CZ estimate if there is only one county in the CZ
	replace Bj_p`ppp'_cz_cty_`outcome'`spec' = Bj_p`ppp'_cz`outcome'`spec' if Bj_p`ppp'_cty_`outcome'`spec'==. & cty_by_cz==1
	* Override for Las Vegas (cz 37901, cty == 32003) for kr26_m and kir26_m because it happens to be disconnected
	if "`outcome'"=="kir26_m"{
	replace Bj_p`ppp'_cz_cty_`outcome'`spec' = Bj_p`ppp'_cz`outcome'`spec' if Bj_p`ppp'_cty_`outcome'`spec'==. & cty==32003
	}
	drop Bj_p`ppp'_cz`outcome'`spec'
	drop Bj_p`ppp'_cz`outcome'`spec'_se
	}
	}
	}
	
	* 4.3) Split Sample 
	
	foreach outcome in  kr26 { 
	foreach spec in _cc2{
	foreach splitsample in _c0 _c1 {
	foreach ppp in 1 25 50 75 99 {
	* generate CTY + CZ spec
	gen Bj_p`ppp'_cz_cty_`outcome'`spec'`splitsample' = Bj_p`ppp'_cz`outcome'`spec'`splitsample' + Bj_p`ppp'_cty_`outcome'`spec'`splitsample'
	label var Bj_p`ppp'_cz_cty_`outcome'`spec'`splitsample' "Raw Causal Place Effect: County and CZ"
	
	*Use CZ estimate if there is only one county in the CZ
	replace Bj_p`ppp'_cz_cty_`outcome'`spec'`splitsample' = Bj_p`ppp'_cz`outcome'`spec'`splitsample' if Bj_p`ppp'_cty_`outcome'`spec'`splitsample'==. & cty_by_cz==1
	
	* generate cty + cz s.e.
	gen Bj_p`ppp'_cz_cty_`outcome'`spec'`splitsample'_se = sqrt(Bj_p`ppp'_cz`outcome'`spec'`splitsample'_se^2 + (Bj_p`ppp'_cty_`outcome'`spec'`splitsample'_se)^2)
	replace Bj_p`ppp'_cz_cty_`outcome'`spec'`splitsample'_se = Bj_p`ppp'_cz`outcome'`spec'`splitsample'_se if Bj_p`ppp'_cz_cty_`outcome'`spec'`splitsample'_se ==. & Bj_p`ppp'_cz_cty_`outcome'`spec'`splitsample'~=.

	drop Bj_p`ppp'_cz`outcome'`spec'`splitsample'
	drop Bj_p`ppp'_cz`outcome'`spec'`splitsample'_se
	}
	}
	}
	}
	
	* 4.4) Split Sample TLPBO
	
	foreach outcome in  tlpbo_16 { 
	foreach spec in _cc2{
	foreach splitsample in _ss1 _ss2 {
	foreach ppp in 1 25 50 75 99 {
	
	* generate CTY + CZ spec
	gen Bj_p`ppp'_czcty_`outcome'`spec'`splitsample' = Bj_p`ppp'_cz`outcome'`spec'`splitsample' + Bj_p`ppp'_cty_`outcome'`spec'`splitsample'
	label var Bj_p`ppp'_czcty_`outcome'`spec'`splitsample' "Raw Causal Place Effect: County and CZ"
	
	*Use CZ estimate if there is only one county in the CZ
	replace Bj_p`ppp'_czcty_`outcome'`spec'`splitsample' = Bj_p`ppp'_cz`outcome'`spec'`splitsample' if Bj_p`ppp'_cty_`outcome'`spec'`splitsample'==. & cty_by_cz==1
	
	* generate cty + cz s.e.
	gen Bj_p`ppp'_czcty_`outcome'`spec'`splitsample'_se = sqrt(Bj_p`ppp'_cz`outcome'`spec'`splitsample'_se^2 + (Bj_p`ppp'_cty_`outcome'`spec'`splitsample'_se)^2)
	replace Bj_p`ppp'_czcty_`outcome'`spec'`splitsample'_se = Bj_p`ppp'_cz`outcome'`spec'`splitsample'_se if Bj_p`ppp'_czcty_`outcome'`spec'`splitsample'_se ==. & Bj_p`ppp'_czcty_`outcome'`spec'`splitsample'~=.
	
	drop Bj_p`ppp'_cz`outcome'`spec'`splitsample'
	drop Bj_p`ppp'_cz`outcome'`spec'`splitsample'_se
	}
	}
	}
	}
	
	* 4.5) Split Sample kr26
	
	foreach outcome in kr26{ 
	foreach spec in _cc2{
	foreach age in _16 {
	foreach splitsample in _ss1 _ss2 {
	foreach ppp in 1 25 50 75 99 {

	* generate CTY + CZ spec
	gen Bj_p`ppp'_cz_cty_`outcome'`age'`spec'`splitsample' = Bj_p`ppp'_cz`outcome'`spec'`age'`splitsample' + Bj_p`ppp'_cty_`outcome'`age'`spec'`splitsample'
	label var Bj_p`ppp'_cz_cty_`outcome'`age'`spec'`splitsample' "Raw Causal Place Effect: County and CZ"
	
	*Use CZ estimate if there is only one county in the CZ
	replace Bj_p`ppp'_cz_cty_`outcome'`age'`spec'`splitsample' = Bj_p`ppp'_cz`outcome'`spec'`age'`splitsample' if Bj_p`ppp'_cty_`outcome'`age'`spec'`splitsample'==. & cty_by_cz==1
	
	* generate cty + cz s.e.
	gen Bj_p`ppp'_cz_cty_`outcome'`age'`spec'`splitsample'_se = sqrt(Bj_p`ppp'_cz`outcome'`spec'`age'`splitsample'_se^2 + (Bj_p`ppp'_cty_`outcome'`age'`spec'`splitsample'_se)^2)
	replace Bj_p`ppp'_cz_cty_`outcome'`age'`spec'`splitsample'_se = Bj_p`ppp'_cz`outcome'`spec'`age'`splitsample'_se if Bj_p`ppp'_cz_cty_`outcome'`age'`spec'`splitsample'_se ==. & Bj_p`ppp'_cz_cty_`outcome'`age'`spec'`splitsample'~=.

	drop Bj_p`ppp'_cz`outcome'`spec'`age'`splitsample'
	drop Bj_p`ppp'_cz`outcome'`spec'`age'`splitsample'_se
	}
	}
	}
	}
	}
	
	* 4.6) cleanup 
	
	* Drop nb of county by CZ
	drop cty_by_cz n_cty_nonmiss_*

	
* 5) merge with covariates

		* 5.1) Crosswalks
			
			*5.1.1) CTY CSA 
				preserve
				use crosswalks/cty_csa.dta, clear
					replace cty = 12025  if cty == 12086
					replace cty = 2231 if cty == 2232
				tempfile csa
				save `csa'
				restore
				merge 1:1 cty using `csa', nogen keep(1 3) keepusing(csa* cbsa*)
			
			*5.1.2) CTY MSA
			merge m:1 cz using covariates/all_data/old/analysis_revision_v1.dta, nogen keepusing(intersects_msa)
			label var intersects_msa "MSA Indicator"
			
			*5.1.2) CTY State and Names
			merge 1:1 cty using crosswalks/cty_state_cw_1990.dta, nogen keep(1 3) keepusing(state* fips)
			label var fips "State FIPS Code"
			label var statename "State Name"
				
		* 5.2) Names
	
			* 5.2.1) CTY names
				merge 1:1 cty using  "crosswalks/cty_names_cw_1990.dta", nogen keep(match) keepusing(county)
				rename county county_name
				label var county_name "county Name"

			* 5.2.2) CZ names 
				merge m:1 cz using  "crosswalks/cz_names.dta", nogen keep(match) keepusing(czname)
				rename czname cz_name
				label var cz_name "CZ Name"
				
			* 5.2.3) State names
				merge m:1 fips using crosswalks/FIPS_State_cw.dta, nogen keep(match) keepusing(stateabbrv)
				rename fips state_id
				label var stateabbrv "State Abbreviation"
					
		*5.3 ) merge on to county correlates 
	
			* 5.3.1) Merge on correlates
				preserve
				use "covariates/all_data/${geo}_characteristics_v2", clear
				
				global varlist cs_race_bla poor_share cs_race_theil_2000 cs00_seg_inc cs00_seg_inc_pov25 cs00_seg_inc_aff75 frac_traveltime_lt15 ///
				hhinc00 gini inc_share_1perc gini99 frac_middleclass ///
				taxrate subcty_total_taxes_pc subcty_total_expenditure_pc eitc_exposure tax_st_diff_top20 ///
				ccd_exp_tot ccd_pup_tch_ratio score_r dropout_r ///
				num_inst_pc tuition gradrate_r ///
				cs_labforce cs_elf_ind_man frac_worked1416 ///
				mig_inflow mig_outflow cs_born_foreign ///
				scap_ski90pcm rel_tot crime_violent crime_total ///
				cs_fam_wkidsinglemom cs_divorced cs_married ///
				med_house_price_bm med_house_price_am med_rent_bm med_rent_am ///
				log_pop_density low_inc_ht median_inc_ht unemp_rate commute_time
				
				gen log_pop_density = log(pop_density)
				drop pop_density
				gen commute_time= 1- frac_traveltime_lt15
				
				order cty ${varlist}
				
					replace cty =12025  if cty == 12086
					replace cty = 2231 if cty == 2232
				tempfile covariates
				save `covariates'
				restore 
				merge 1:1 cty using `covariates', nogen keep(match)
			
				
			* 5.3.2) Standardize correlates
				foreach var of varlist cs_race_bla - commute_time {
				label var `var' "Covariates"
				gen o_`var' = `var'
				areg o_`var' [w=cty_pop2000], a(cz) 
				predict `var'_dm if e(sample), r 
				label var `var'_dm "de-meaned"
				drop o_`var'
				su `var'_dm [w=cty_pop2000], d
				gen `var'_st = (`var'_dm-r(mean))/r(sd)
				su `var'_st [w=cty_pop2000], d
				label var `var'_st "standardized Covariates"
				drop `var'_dm
				}

*6) Stayers predictions
	
	*6.1) Pooled 
	
	foreach outcome in kr26 kr26_am kr26_bm kr26_f kr26_m kr26_sp kr26_tp ///
	c1823 c1823_f c1823_m c1823_sp c1823_tp ///
	kir26 kir26_f kir26_m ///
	kfi26 kfi26_m kfi26_f ///
	kii26 kii26_m kii26_f ///
	km26 kr26_sq kr26_coli1996 ///
	c19 c1820  ///
	dm2 dm2_m dm2_f ///
	kr30 kr30_f kr30_m kir30 kir30_f kir30_m kfi30 kfi30_m kfi30_f kii30 kii30_m kii30_f km30 km30_m km30_f{
	
	preserve 
	use irsdata/place_effect_final/pe_cty_`outcome'.dta, clear
	foreach p in 1 25 50 75 99 {
	if "`outcome'"=="kfi26" | "`outcome'"=="kfi26_m" | "`outcome'"=="kfi26_f" | "`outcome'"=="kii26" | "`outcome'"=="kii26_f" | "`outcome'"=="kii26_m" ///
	 | "`outcome'"=="kfi30" | "`outcome'"=="kfi30_m" | "`outcome'"=="kfi30_f" | "`outcome'"=="kii30" | "`outcome'"=="kii30_f" | "`outcome'"=="kii30_m"{
	gen e_rank_b_`outcome'_p`p' = (i_`outcome' +(`p'/100)*s_`outcome') if n_`outcome' > 250
	label var e_rank_b_`outcome'_p`p' "Stayers E Rank"
	}
	else{
	gen e_rank_b_`outcome'_p`p' = 100*(i_`outcome' +(`p'/100)*s_`outcome')  if n_`outcome' > 250 
	label var e_rank_b_`outcome'_p`p' "Stayers E Rank"
	}
	}
	tempfile o`outcome'
	save `o`outcome''
	restore 
	merge 1:1 cty using `o`outcome'', nogen keepusing(e_rank_b*)
	}

	* Quadratic Specs
	foreach outcome in p90_24 p90_26 p90_30 kw24 kw26 kw30 {
	preserve 
	use irsdata/place_effect_final/pe_sq_cty_`outcome'.dta, clear
	foreach p in 1 25 50 75 99 {
	gen e_rank_b_`outcome'_p`p' = 100*(i_`outcome' +(`p'/100)*s_`outcome'+(`p'/100)^2*q_`outcome') if n_`outcome' > 250 	
	label var e_rank_b_`outcome'_p`p' "Stayers E Rank"
	}
	tempfile o`outcome'`cohort'
	save `o`outcome'`cohort''
	restore
	merge 1:1 cty using `o`outcome'`cohort'', nogen keepusing(e_rank_b*)
	}
	
	*6.2) By age 
	forvalues age = 20(1)32 {
	preserve 
	use irsdata/place_effect_final/pe_cty_kr`age'.dta, clear
	foreach p in 1 25 50 75 99 {
	gen e_rank_b_kr`age'_p`p' = 100*(i_kr`age' +(`p'/100)*s_kr`age') if n_kr`age' > 250  	
	label var e_rank_b_kr`age'_p`p' "Stayers E Rank"
	}
	tempfile o`age'
	save `o`age''
	restore 
	merge 1:1 cty using `o`age'', nogen keepusing(e_rank_b*)
	}
	
	*6.3) By cohort 
	foreach outcome in kr26 kr24 c1823 c19 {
	forvalues cohort = 1980(1)1988 {
	preserve
	use irsdata/place_effect_final/pe_ctycohort_`outcome'.dta, clear
	keep if cohort == `cohort'
	foreach p in 1 25 50 75 99 {
	gen e_rank_b_`outcome'_p`p'_`cohort' = 100*(i_`outcome' +(`p'/100)*s_`outcome') if n_`outcome' > 250 & cohort == `cohort' // censor at 250 obs 	
	label var e_rank_b_`outcome'_p`p'_`cohort' "Stayers E Rank"
	}
	tempfile o`outcome'`cohort'
	save `o`outcome'`cohort''
	restore
	merge 1:1 cty using `o`outcome'`cohort'', nogen keepusing(e_rank_b*)
	}
	}
	drop *e_rank_b_kr26_*1987 *e_rank_b_kr26_*1988 *e_rank_b_c1823_*1980
		
	* 6.4) Teen Labor 83-86 Cohorts
	preserve
	use "$dropbox/movers/analysis/irsdata/place_effect_final/pe_ctycohort_tl16", clear
	g e_rank_b_tl16_p25_8386 = i_tl16 + 0.25*s_tl16
	g e_rank_b_tl16_p75_8386 = i_tl16 + 0.75*s_tl16

	collapse (rawsum) n_tl16 (mean) e_rank_b_tl16_p25_8386 e_rank_b_tl16_p75_8386 [w=n_tl16] ///
		if inrange(cohort,1983,1986), by(cty)

	replace e_rank_b_tl16_p25_8386 = . if n_tl16<250
	replace e_rank_b_tl16_p75_8386 = . if n_tl16<250
	tempfile tl8386
	save `tl8386'
	restore
	merge 1:1 cty using `tl8386', nogen keepusing(e_rank_b*)

* 7) Quintile transition matrix  

	preserve
	use "irsdata/qt_trans_mat_final/cty_stayers_quintile_transmat.dta", clear
	rename par_cty_1996 cty 
	label var cty ""
	merge 1:1 cty using "irsdata/place_effect_final/pe_cty_kr26.dta" , keepusing(n_kr26) keep(master match) nogen
	drop if n_kr26 < 250 
	drop X* n_kr26
	rename par* stayers_par*
	forvalues i=1(1)5{
	forvalues j=1(1)5{
	label var stayers_par`i'_to_kid`j' "Quintile Transition Matrix"
	}
	}
	tempfile transition
	save `transition'
	restore 
	merge 1:1 cty using `transition', nogen  
	

*8) Fraction of parents in each national income decile

	preserve
	use "irsdata/other_final/cty_decile_frac.dta", clear
	merge 1:1 cty using "irsdata/place_effect_final/pe_cty_kr26.dta" , keepusing(n_kr26) keep(master match) nogen
	drop if n_kr26 < 250 
	drop if cty==.
	drop n_cty n_kr26
	forvalues i=1(1)10{
	label var frac_`i' " Fraction of Parents in National Income Decile"
	}
	tempfile decile_freq
	save `decile_freq'
	restore 
	merge 1:1 cty using `decile_freq', nogen 
	
* 9) drop p1, p50 and p99
drop *_p1* *_p50* *_p99*	

* 10) Summarize all variables in the dataset to make sure they have relevant values

order cty county_name cty_pop2000 cz cz_name cz_pop2000 state* csa csa_name cbsa cbsa_name intersects_msa 

cap log close 
log using beta/beta_complete_final/final_cty_check.smcl, replace 
di in red " WITHOUT WEIGHTS"
fsum _all
di in red " WITH POP WEIGHTS"
fsum *_st  [w=cty_pop2000]
log close 

* 11) Add bootstrapped county-within-CZ standard errors
local pctile 25 75
foreach p of local pctile {
foreach outcome in kr26 { 
foreach spec in _cc2 {
preserve
merge m:1 cz using "beta/beta_complete_final/final_cz_v5.dta", nogen keepusing(Bj_p`p'_cz`outcome'`spec'_bs_se)
	if "`outcome'" == "kr26" & "`spec'" == "_cc2" {
	g Bj_p`p'_cz_cty_`outcome'`spec'_bs_se = sqrt(Bj_p`p'_cty_`outcome'`spec'_se^2+(Bj_p`p'_cz`outcome'`spec'_bs_se^2))
	replace Bj_p`p'_cz_cty_`outcome'`spec'_bs_se = Bj_p`p'_cz`outcome'`spec'_bs_se if Bj_p`p'_cz_cty_`outcome'`spec'_bs_se ==. & Bj_p`p'_cz_cty_`outcome'`spec'~=.
	}
keep cty Bj_p`p'_cz_cty_`outcome'`spec'_bs_se
tempfile bs_cz_cty_p`p'
save `bs_cz_cty_p`p'', replace
restore
}
}
}

foreach p of local pctile {
	merge 1:1 cty using `bs_cz_cty_p`p'', nogen
	}

* 12) save

compress
save beta/beta_complete_final/final_cty_v5.dta, replace
