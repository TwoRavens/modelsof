/***
 This program generates the final Commuting Zone level Dataset final_cz.dta
 Inputs: raw estimates by CZ sent out of IRS and covariates produced using public data
 Output: final Commuting Zone level Dataset final_cz.dta
***/

clear all 
set matsize 11000
set maxvar 32000
set more off

global db "${dropbox}"
cd "$db/movers/analysis"

********************************************************************************
*************************** CZ LEVEL DATASET ***********************************
********************************************************************************

global geo cz
global cz_pop_cutoff 25000

* 1) use population 
use covariates/all_data/cz_pop.dta, clear
label var pop2000 "County Population in 2000 Census"

* 2) merge beta j estimates, set as missing below pop cutoff and de-mean 
		
		* 2.1) Baseline beta
		
		foreach outcome in kr26 { 
		foreach spec in _cc2 _cc _cc3 _am_cc2 _bm_cc2 _f_cc2 _m_cc2 _sp_cc2 _tp_cc2 _pbo_cc2 _pmi_cc2 {

		merge 1:1 ${geo} using beta/beta_final/CZ/used_specs/cz_`outcome'`spec'.dta, nogen keepusing(Bj*)
		foreach ppp in 1 25 50 75 99  { 
		replace Bj_p`ppp'_cz`outcome'`spec'=. if pop2000<${cz_pop_cutoff}
		replace Bj_p`ppp'_cz`outcome'`spec'_se=. if pop2000<${cz_pop_cutoff}
		su Bj_p`ppp'_cz`outcome'`spec' [w=pop2000]
		replace Bj_p`ppp'_cz`outcome'`spec' = Bj_p`ppp'_cz`outcome'`spec' - r(mean)
		label var Bj_p`ppp'_cz`outcome'`spec' "Raw Causal Place Effect for child income rank at age 26 with parents at p`ppp'"
		label var Bj_p`ppp'_cz`outcome'`spec'_se "Raw Standard error for child income rank at age 26 with parents at p`ppp'"
		}
		}
		}
		
		foreach outcome in c1823 { 
		foreach spec in _cc2 _f_cc2 _m_cc2 _sp_cc2 _tp_cc2 {
		merge 1:1 ${geo} using beta/beta_final/CZ/used_specs/cz_`outcome'`spec'.dta, nogen keepusing(Bj*)
		foreach ppp in 1 25 50 75 99  { 
		replace Bj_p`ppp'_cz`outcome'`spec'=. if pop2000<${cz_pop_cutoff}
		replace Bj_p`ppp'_cz`outcome'`spec'_se=. if pop2000<${cz_pop_cutoff}
		su Bj_p`ppp'_cz`outcome'`spec' [w=pop2000]
		replace Bj_p`ppp'_cz`outcome'`spec' = Bj_p`ppp'_cz`outcome'`spec' - r(mean)
		label var Bj_p`ppp'_cz`outcome'`spec' "Raw Causal Place Effect for College Attendance at age 18-23 with parents at p`ppp'"
		label var Bj_p`ppp'_cz`outcome'`spec'_se "Raw Standard error for College Attendance at age 18-23 with parents at p`ppp'"
		}
		}
		}
		
		* 2.2 ) Other outcomes
		
		foreach outcome in kir26 kir26_f kir26_m kfi26 kfi26_m kfi26_f kii26 kii26_m kii26_f km26 kr26_sq kr26_coli tlpbo_16 { 
		foreach spec in _cc2{
		if "`outcome'" == "kr26_coli" {
			merge 1:1 ${geo} using beta/beta_final/CZ/used_specs/cz_`outcome'1996`spec'.dta, nogen keepusing(Bj*)
			rename *coli1996* *coli*
		}
		else{
		merge 1:1 ${geo} using beta/beta_final/CZ/used_specs/cz_`outcome'`spec'.dta, nogen keepusing(Bj*)
		}
		foreach ppp in 1 25 50 75 99  { 
		replace Bj_p`ppp'_cz`outcome'`spec'=. if pop2000<${cz_pop_cutoff}
		replace Bj_p`ppp'_cz`outcome'`spec'_se=. if pop2000<${cz_pop_cutoff}
		su Bj_p`ppp'_cz`outcome'`spec' [w=pop2000]
		replace Bj_p`ppp'_cz`outcome'`spec' = Bj_p`ppp'_cz`outcome'`spec' - r(mean)
		label var Bj_p`ppp'_cz`outcome'`spec' "Raw Causal Place Effect"
		label var Bj_p`ppp'_cz`outcome'`spec'_se "Raw Standard error"
		
		}
		}
		}
		
		*2.3) Split sample 
		
		foreach outcome in kr26 { 
		foreach spec in _cc2{
		foreach splitsample in _c0 _c1 _16_ss1 _16_ss2{
		merge 1:1 ${geo} using beta/beta_final/CZ/used_specs/cz_`outcome'`spec'`splitsample'.dta, nogen keepusing(Bj*`outcome'`spec'`splitsample' Bj*`outcome'`spec'`splitsample'_se)
		foreach ppp in 1 25 50 75 99  { 
		replace Bj_p`ppp'_cz`outcome'`spec'`splitsample'=. if pop2000<${cz_pop_cutoff}
		replace Bj_p`ppp'_cz`outcome'`spec'`splitsample'_se=. if pop2000<${cz_pop_cutoff}
		su Bj_p`ppp'_cz`outcome'`spec'`splitsample' [w=pop2000]
		replace Bj_p`ppp'_cz`outcome'`spec'`splitsample' = Bj_p`ppp'_cz`outcome'`spec'`splitsample' - r(mean)
		label var Bj_p`ppp'_cz`outcome'`spec'`splitsample' "Raw Causal Place Effect: Split Sample"
		label var Bj_p`ppp'_cz`outcome'`spec'`splitsample'_se "Raw Standard error: Split Sample"
		}
		}
		}
		}
		foreach outcome in tlpbo_16 { 
		foreach spec in _cc2{
		foreach splitsample in _ss1 _ss2{
		merge 1:1 ${geo} using beta/beta_final/CZ/used_specs/cz_`outcome'`spec'`splitsample'.dta, nogen keepusing(Bj*`outcome'`spec'`splitsample' Bj*`outcome'`spec'`splitsample'_se)
		foreach ppp in 1 25 50 75 99  { 
		replace Bj_p`ppp'_cz`outcome'`spec'`splitsample'=. if pop2000<${cz_pop_cutoff}
		replace Bj_p`ppp'_cz`outcome'`spec'`splitsample'_se=. if pop2000<${cz_pop_cutoff}
		su Bj_p`ppp'_cz`outcome'`spec'`splitsample' [w=pop2000]
		replace Bj_p`ppp'_cz`outcome'`spec'`splitsample' = Bj_p`ppp'_cz`outcome'`spec'`splitsample' - r(mean)
		label var Bj_p`ppp'_cz`outcome'`spec'`splitsample' "Raw Causal Place Effect: Split Sample"
		label var Bj_p`ppp'_cz`outcome'`spec'`splitsample'_se "Raw Standard error: Split Sample"
		}
		}
		}
		}
		
* 3) Bootstrapped standard errors 

		foreach outcome in kr26 c1823 kir26 { 
		foreach spec in _cc2 {
		preserve 
		use beta/beta_final/CZ_boot/used_specs/cz_`outcome'`spec', clear
		merge 1:1 ${geo} using "covariates/all_data/cz_pop.dta", nogen 
		cap drop *_se*
		foreach ppp of numlist 1 25 50 75 99 {

		forvalue i=1(1)100{
		replace Bj_p`ppp'_cz`outcome'`spec'_`i'=. if pop2000<${cz_pop_cutoff}
		qui su  Bj_p`ppp'_cz`outcome'`spec'_`i'  [w=pop2000]
		replace Bj_p`ppp'_cz`outcome'`spec'_`i'= Bj_p`ppp'_cz`outcome'`spec'_`i'-r(mean)
		label var Bj_p`ppp'_cz`outcome'`spec'_`i' "Raw Causal Place Effect"
		}
		egen count_bs_p`ppp'_cz`outcome'`spec' = rownonmiss(Bj_p`ppp'_cz`outcome'`spec'_*)
		egen Bj_p`ppp'_cz`outcome'`spec'_bs_se = rowsd(Bj_p`ppp'_cz`outcome'`spec'_*)
		label var Bj_p`ppp'_cz`outcome'`spec'_bs_se " Bootstrapped Standard error"
	
		su count*
		
		}
		
		tempfile boot 
		save `boot'
		restore 
		
		merge 1:1 ${geo} using `boot', nogen keepusing(Bj_*_bs*)
		}
		}
		
* 4) Merge with CZ Characteristics 

	* 4.1) Merge on cz name 
	merge 1:1 ${geo} using "crosswalks/cz_names.dta", nogen keepusing(czname)
	label var czname "CZ Name"

	* 4.2) Merge on state 
	merge 1:1 ${geo} using "covariates/all_data/old/analysis_revision_v1", nogen keepusing(stateabbrv state_id)
	label var stateabbrv "state Abbreviation"
	label var state_id "state Code"
	
	* 4.3) Merge on covariates
	merge 1:1 ${geo} using "covariates/all_data/${geo}_characteristics_v2", nogen keep(match)
	
	gen log_pop_density = log(pop_density)
	drop pop_density
	gen commute_time = 1-frac_traveltime_lt15
	label var intersects_msa "MSA Indicator"
	
	global varlist cs_race_bla poor_share cs_race_theil_2000 cs00_seg_inc cs00_seg_inc_pov25 cs00_seg_inc_aff75 frac_traveltime_lt15 ///
	hhinc00 gini inc_share_1perc gini99 frac_middleclass ///
	taxrate subcty_total_taxes_pc subcty_total_expenditure_pc eitc_exposure tax_st_diff_top20 ///
	ccd_exp_tot ccd_pup_tch_ratio score_r dropout_r ///
	num_inst_pc tuition gradrate_r ///
	cs_labforce cs_elf_ind_man d_tradeusch_pw_1990 frac_worked1416 ///
	mig_inflow mig_outflow cs_born_foreign ///
	scap_ski90pcm rel_tot crime_violent crime_total ///
	cs_fam_wkidsinglemom cs_divorced cs_married ///
	med_house_price_bm med_house_price_am med_rent_bm med_rent_am ///
	log_pop_density low_inc_ht median_inc_ht unemp_rate commute_time
	
	order cz czname pop2000 *state* *msa* Bj* ${varlist}
	
	* 4.4) Standardize covariates
	foreach var of varlist cs_race_bla - commute_time{
	label var `var' "Covariates"
	su `var' [w=pop2000], d
	gen `var'_st = (`var'-r(mean))/r(sd)
	label var `var'_st "standardized Covariates"
	}
	

* 5) Stayers predictions

	*5.1) Pooled across cohorts

	* Linear specs 
	foreach outcome in kr26 kr26_am kr26_bm kr26_f kr26_m kr26_sp kr26_tp ///
	c1823 c1823_f c1823_m c1823_sp c1823_tp ///
	kir26 kir26_f kir26_m ///
	kfi26 kfi26_m kfi26_f ///
	kii26 kii26_m kii26_f ///
	km26 kr26_sq kr26_coli1996 ///
	c19 c1820  ///
	dm2 dm2_f dm2_m ///
	kr30 kr30_f kr30_m kir30 kir30_f kir30_m kfi30 kfi30_m kfi30_f kii30 kii30_m kii30_f km30 km30_m km30_f {
	preserve 
	use irsdata/place_effect_final/pe_cz_`outcome'.dta, clear
	foreach p in 1 25 50 75 99 {
	if "`outcome'"=="kfi26" | "`outcome'"=="kfi26_m" | "`outcome'"=="kfi26_f" | "`outcome'"=="kii26" | "`outcome'"=="kii26_f" | "`outcome'"=="kii26_m" ///
	 | "`outcome'"=="kfi30" | "`outcome'"=="kfi30_m" | "`outcome'"=="kfi30_f" | "`outcome'"=="kii30" | "`outcome'"=="kii30_f" | "`outcome'"=="kii30_m" {
	gen e_rank_b_`outcome'_p`p' = (i_`outcome' +(`p'/100)*s_`outcome') if n_`outcome' > 250 
	label var e_rank_b_`outcome'_p`p' "Stayers E Rank"
	}
	else{
	gen e_rank_b_`outcome'_p`p' = 100*(i_`outcome' +(`p'/100)*s_`outcome') if n_`outcome' > 250 
	label var e_rank_b_`outcome'_p`p' "Stayers E Rank"
	}	
	}
	
	tempfile o`outcome'
	save `o`outcome''
	restore 
	merge 1:1 cz using `o`outcome'', nogen keepusing(e_rank_b*)
	}
	
	* Quadratic Specs
	foreach outcome in p90_24 p90_26 p90_30 kw24 kw26 kw30 {
	preserve 
	use irsdata/place_effect_final/pe_sq_cz_`outcome'.dta, clear
	foreach p in 1 25 50 75 99 {
	gen e_rank_b_`outcome'_p`p' = 100*(i_`outcome' +(`p'/100)*s_`outcome'+(`p'/100)^2*q_`outcome') if n_`outcome' > 250 	
	label var e_rank_b_`outcome'_p`p' "Stayers E Rank"
	}
	tempfile o`outcome'`cohort'
	save `o`outcome'`cohort''
	restore
	merge 1:1 cz using `o`outcome'`cohort'', nogen keepusing(e_rank_b*)
	
	}

	*5.2) By age 
	forvalues age = 20(1)32 {
	preserve 
	use irsdata/place_effect_final/pe_cz_kr`age'.dta, clear
	foreach p in 1 25 50 75 99{
	gen e_rank_b_kr`age'_p`p' = 100*(i_kr`age' +(`p'/100)*s_kr`age') if n_kr`age' > 250 
	label var e_rank_b_kr`age'_p`p' "Stayers E Rank"
	}
	tempfile o`age'
	save `o`age''
	restore 
	merge 1:1 cz using `o`age'', nogen keepusing(e_rank_b*)
	}
	
	*5.3) By cohort 
	foreach outcome in kr26 kr24 c1823 c19 {
	forvalues cohort = 1980(1)1988 {
	preserve
	use irsdata/place_effect_final/pe_czcohort_`outcome'.dta, clear
	keep if cohort == `cohort'
	foreach p in 1 25 50 75 99{
	gen e_rank_b_`outcome'_p`p'_`cohort' = 100*(i_`outcome' +(`p'/100)*s_`outcome') if n_`outcome' > 250 & cohort == `cohort' 
	label var e_rank_b_`outcome'_p`p'_`cohort' "Stayers E Rank"
	}
	tempfile o`outcome'`cohort'
	save `o`outcome'`cohort''
	restore
	merge 1:1 cz using `o`outcome'`cohort'', nogen keepusing(e_rank_b*)
	}
	}
	drop *e_rank_b_kr26_*1987 *e_rank_b_kr26_*1988 *e_rank_b_c1823_*1980 

	
	* collapse teen labor to 1980-83 cohorts
	preserve
	use irsdata/place_effect_final/pe_czcohort_tl16", clear
	g e_rank_b_tl16_p25_8386 = i_tl16 + 0.25*s_tl16
	g e_rank_b_tl16_p75_8386 = i_tl16 + 0.75*s_tl16

	collapse (rawsum) n_tl16 (mean) e_rank_b_tl16_p25_8386 e_rank_b_tl16_p75_8386 [w=n_tl16] ///
		if inrange(cohort,1983,1986), by(cz)

	replace e_rank_b_tl16_p25_8386 = . if n_tl16<250
	replace e_rank_b_tl16_p75_8386 = . if n_tl16<250
	tempfile tl8386
	save `tl8386'
	restore
	merge 1:1 cz using `tl8386', nogen keepusing(e_rank_b*)

* 6) Drop p1, p50 and p99 

drop *_p1* *_p50* *_p99*

* 7) merge on cz quintile transition matrix pooling 1980-86 cohorts
	
merge 1:1 cz using irsdata/place_effect_final/movers_v10_cz8086_qt_clps_mskd.dta, nogen keepusing(parq*)
	*mask if n_kr26 < 250
	merge 1:1 cz using irsdata/place_effect_final/pe_cz_kr26.dta, nogen keepusing(n_kr26)
	forval i = 1/5 {
		forval j = 1/5 {
			replace parq`i'_kidq`j' = .  if n_kr26 < 250
		}
	}
	drop n_kr26

* 8) Summarize all variables in the dataset to make sure they have relevant values

cap log close 
log using beta/beta_complete_final/final_cz_check.smcl, replace 
di in red " WITHOUT WEIGHTS"
fsum _all
di in red " WITH POP WEIGHTS"
fsum Bj*_cc2 *_st  [w=pop2000]
log close 

* 9) Save Dataset 
compress
save beta/beta_complete_final/final_cz_v5.dta, replace
