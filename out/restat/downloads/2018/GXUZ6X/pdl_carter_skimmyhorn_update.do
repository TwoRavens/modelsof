clear all
set more off
set mem 1g
set maxvar 3000
set matsize 3000
capture log close
set logtype text
set debug off


log using $logdir/final_`dat'.txt, replace 

********
* Do File Directions:
* local id_strategy_1_and_3_young is for the Young Soldier Sample Cross Section and DD Results
* local id_strategy_1_xs_full is for the All Soldier Random Sample Cross Sectional Results
* local id_strategy_3_dd_full is for the All Soldier Random Sample DD Results
* local id_strategy_2_within_term is for the 2nd identification strategy
* local cz_replication is for Appendix Table 9 Panel B
*********


local id_strategy_1_and_3_young = 1
local id_strategy_1_xs_full = 0
local id_strategy_3_dd_full = 0
local id_strategy_2_within_term = 0
local cz_replication = 0
local appendix = 0


if `id_strategy_1_and_3_young' {
****** This is for the Young Soldier Sample
use $datadir/final_full_sample, replace

local wild_bootstrap = 1
local years year_06 year_07 year_09 year_10

gen cross = treatment*pre

local demo_controls female nonwhite nrdep ged hsg asc_smc college_pl afqsc married divorced age age_sq ue hp DM_* 

local financial_controls baspay hfpdur

**** F-Tests and Partial R2 for Table 1 *****
**** Appendix Table 3 "Young Soldier Sample" *****
foreach outcome in treatment {
	xi: qui areg `outcome'   hfpdur baspay `demo_controls' `financial_controls' i.pmos i.grade, absorb(year)
	bys treatment pre: tab state if e(sample) == 1
	xi: qui areg `outcome'   hfpdur baspay `demo_controls' `financial_controls' i.pmos i.grade if pre == 1, absorb(year)
	bys treatment pre:  summ afqsc female white black nonwhite nrdep ged hsd hsg asc_smc college_pl married divorced baspay hfpdur reup_n sep_inv age
	tab state if e(sample) == 1
	eststo `outcome'_yxjobxgr: xi: qui areg `outcome'  i.pmos i.grade if pre == 1 & e(sample) == 1, absorb(exper_mos_year_fe) `cluster' robust
	eststo `outcome'_demo: xi: qui areg `outcome'   hfpdur baspay `demo_controls' `financial_controls' if pre == 1 ,  absorb(exper_mos_year_fe) `cluster' robust
	test afqsc female nonwhite ged hsg asc_smc college_pl married divorced nrdep baspay hfpdur age age_sq
	summ `outcome' if e(sample) == 1
	xi: qui areg `outcome'   hfpdur baspay `demo_controls' `financial_controls' if pre == 0,  absorb(exper_mos_year_fe) `cluster' robust
	tab state if e(sample) == 1
	eststo `outcome'_1_po: xi: qui areg `outcome'   i.year if pre == 0 & e(sample) == 1,  absorb(exper_mos_year_fe) `cluster' robust
	summ `outcome' if e(sample) == 1
	eststo `outcome'_2_po: xi: qui areg `outcome'   hfpdur baspay `demo_controls' `financial_controls' if pre == 0,  absorb(exper_mos_year_fe) `cluster' robust
	test afqsc female nonwhite ged hsg asc_smc college_pl married divorced nrdep baspay hfpdur age age_sq
	summ `outcome' if e(sample) == 1
	xi: qui areg `outcome'   hfpdur baspay `demo_controls' `financial_controls',  absorb(exper_mos_year_fe) `cluster' robust
	eststo `outcome'_all: xi: qui areg `outcome'   i.year if e(sample) == 1,  absorb(exper_mos_year_fe) `cluster' robust
	summ `outcome' if e(sample) == 1
	eststo `outcome'_all2: xi: qui areg `outcome'   hfpdur baspay `demo_controls' `financial_controls',  absorb(exper_mos_year_fe) `cluster' robust
	test afqsc female nonwhite ged hsg asc_smc college_pl married divorced nrdep baspay hfpdur age age_sq
	summ `outcome' if e(sample) == 1
	eststo `outcome'_cross11: xi: qui areg cross treatment pre `years'   i.year if e(sample) == 1,  absorb(exper_mos_fe) `cluster' robust
	summ `outcome' if e(sample) == 1
	eststo `outcome'_cross12: xi: qui areg cross treatment pre `years'  hfpdur baspay `demo_controls' `financial_controls',  absorb(exper_mos_fe) `cluster' robust
	test afqsc female nonwhite ged hsg asc_smc college_pl married divorced nrdep baspay hfpdur age age_sq
	summ `outcome' if e(sample) == 1
	eststo `outcome'_cross21: xi: qui areg cross `years' if e(sample) == 1,  absorb(exper_mos_fe) `cluster' robust
	summ `outcome' if e(sample) == 1
	eststo `outcome'_cross22: xi: qui areg cross `years'  hfpdur baspay `demo_controls' `financial_controls',  absorb(exper_mos_fe) `cluster' robust
	test afqsc female nonwhite ged hsg asc_smc college_pl  married divorced nrdep baspay hfpdur age age_sq
	summ `outcome' if e(sample) == 1
	esttab using $outsheet/full_exogeneity.csv, se(3) b(a2) r2(4) ar2(4) star(* 0.1 ** 0.05 *** 0.01) mtitles replace
	esttab, ci(3) b(a2) ar2(4) star(* 0.1 ** 0.05 *** 0.01) mtitles
	eststo clear
	}
	

eststo clear


gen male = female == 0
summ afqsc, d
gen AFQT_q1 = (afqsc < r(p25))
gen AFQT_q2 = (afqsc >= r(p25) & afqsc < r(p50))
gen AFQT_q3 = (afqsc >= r(p50) & afqsc < r(p75))
gen AFQT_q4 = (afqsc >= r(p75))
gen not_married = married == 0
gen lesshsg = (hsd == 1 | ged == 1)
gen greathsg = (cived_cat == "College_Pl" | cived_cat == "ASC_SMC")
gen nodep = nrdep == 0
gen dep1 = nrdep == 1
gen dep2 = nrdep > 1
gen sing_div_dep = (single == 1 & nrdep > 0) | (divorced == 1 & nrdep > 0)
gen sing_afqtq12 = (single == 1) & (AFQT_q1 == 1 | AFQT_q2 == 1)
gen marr_afqtq12 = (married == 1) & (AFQT_q1 == 1 | AFQT_q2 == 1)


foreach outcome in mis_cm econ reup_n sep_inv drug revoked {
	xi: qui areg `outcome' i.treat*i.pre  hfpdur baspay `demo_controls' `financial_controls' `years',  absorb(exper_mos_fe) `cluster' robust
	xi: qui areg `outcome' i.treat*i.pre  if e(sample) == 1, absorb(exper_mos_fe) `cluster' robust
	xi: qui areg `outcome' i.treat*i.pre  hfpdur baspay `demo_controls' `financial_controls' `years',  absorb(exper_mos_fe) `cluster' robust
	global ddmainbeta`outcome' = _b[_ItreXpre_1_1]
	global ddmaint`outcome' = _b[_ItreXpre_1_1] / _se[_ItreXpre_1_1]
	xi: qui areg `outcome' i.treat i.pre hfpdur baspay `demo_controls' `financial_controls' `years',  absorb(exper_mos_fe) `cluster' robust
	predict ddepshat`outcome', resid
	predict ddyhat`outcome', xb
	}

 
xi: qui areg `outcome' i.treat*i.pre  hfpdur baspay `demo_controls' `financial_controls' `years',  absorb(exper_mos_fe) `cluster' robust
bys year: tab stanam
eststo clear

**********************************************************************
****** DD Results Table 3 Panel C and Appendix Table 7 Panel C *******
**********************************************************************

foreach outcome in mis_cm econ article15 reup_n sep_inv drug revoked {
	xi: qui areg `outcome' i.treat*i.pre  hfpdur baspay `demo_controls' `financial_controls' `years',  absorb(exper_mos_fe) `cluster' robust
	eststo `outcome'_1_pre: xi: qui areg `outcome' i.treat*i.pre `years' if e(sample) == 1, absorb(exper_mos_fe) `cluster' robust
	estadd ysumm
	eststo sum_`outcome'_`group': estpost tabstat `outcome' `years' if e(sample) == 1, listwise statistics(mean sd)
	eststo `outcome'_2_pre: xi: qui areg `outcome' i.treat*i.pre  hfpdur baspay `demo_controls' `financial_controls' `years',  absorb(exper_mos_fe) `cluster' robust
	estadd ysumm
	summ `outcome' if treat == 0 & e(sample) == 1
	}
esttab using $outsheet/full_dd.csv, se(3) b(a2) ar2(4) star(* 0.1 ** 0.05 *** 0.01) stats(N r2 ymean ysd) mtitles replace
esttab, ci(3) b(a2) ar2(4) star(* 0.1 ** 0.05 *** 0.01) mtitles

****************************
**** Below are regressions when including the average unemployment rate
****************************
eststo clear
foreach outcome in mis_cm econ article15 reup_n sep_inv drug revoked {
	xi: qui areg `outcome' i.treat*i.pre  hfpdur baspay `demo_controls' `financial_controls' `years' hp ue,  absorb(exper_mos_fe) `cluster' robust
	eststo `outcome'_1_pre: xi: qui areg `outcome' i.treat*i.pre `years' hp ue if e(sample) == 1 , absorb(exper_mos_fe) `cluster' robust
	eststo `outcome'_2_pre: xi: qui areg `outcome' i.treat*i.pre  hfpdur baspay `demo_controls' `financial_controls' `years' hp ue,  absorb(exper_mos_fe) `cluster' robust
	eststo `outcome'_1_on: xi: qui areg `outcome' i.treat*i.pre `years' hp ue if  e(sample) == 1 & onpost_single == 1, absorb(exper_mos_fe) `cluster' robust
	eststo `outcome'_2_on: xi: qui areg `outcome' i.treat*i.pre  hfpdur baspay `demo_controls' `financial_controls' `years' hp ue if onpost_single == 1,  absorb(exper_mos_fe) `cluster' robust
	}
esttab using $outsheet/full_dd_unempl.csv, se(3) b(a2) ar2(4) star(* 0.1 ** 0.05 *** 0.01) mtitles replace
esttab using $outsheet/full_dd_p_unempl.csv, p(3) b(a2) ar2(4) star(* 0.1 ** 0.05 *** 0.01) mtitles replace
 eststo clear


eststo clear

**********************************************************************
****** Summary Statistics for Table 1 "Young Soldier Sample" *********
****** XS Results Table 3 Panel A and Appendix Table 7 Panel A *******
**********************************************************************
foreach outcome in drug revoked mis_cm econ sep_inv  {
	xi: qui areg `outcome' treatment  hfpdur baspay `demo_controls' `financial_controls' if pre == 1,  absorb(exper_mos_year_fe) `cluster' robust
	eststo `outcome'_pre1: xi: qui areg `outcome' treatment  if e(sample)==1,  absorb(exper_mos_year_fe) `cluster' robust
	eststo `outcome'_pre: xi: qui areg `outcome' treatment  hfpdur baspay `demo_controls' `financial_controls' if e(sample)==1,  absorb(exper_mos_year_fe) `cluster' robust
	estadd ysumm 
	summ `outcome' if e(sample) == 1 & treatment == 0

	xi: qui areg `outcome' treatment  hfpdur baspay `demo_controls' `financial_controls' ,  absorb(exper_mos_year_fe) `cluster' robust
	/*new summ stats */
	dis "new summ stats `outcome'"
	bys treatment pre:  summ afqsc female white black nonwhite nrdep ged hsd hsg asc_smc college_pl married divorced baspay hfpdur sep_inv age if e(sample) == 1
	bys treatment pre: summ revoked if e(sample) == 1
	bys treatment pre: tab state if e(sample) == 1
}

esttab using $outsheet/full_cs.csv, se(3) b(a2) r2(4) ar2(4) star(* 0.1 ** 0.05 *** 0.01) stats(N r2 ymean ysd) mtitles replace
esttab using $outsheet/full_cs_ci.csv, ci(3) b(a2) r2(4) ar2(4) star(* 0.1 ** 0.05 *** 0.01) mtitles replace

eststo clear


*****************************************************************************
****** XS Results for Subsamples - Appendix Table 4 Young Soldier Sample ****
*****************************************************************************
foreach group in female male AFQT_q1 AFQT_q2 AFQT_q3 AFQT_q4 lesshsg hsg greathsg nodep dep1 dep2  {
	foreach outcome in drug revoked mis_cm econ sep_inv  {
		xi: qui areg `outcome' treatment  hfpdur baspay `demo_controls' `financial_controls' if pre == 1 & `group' == 1,  absorb(exper_mos_year_fe) `cluster' robust
		eststo `group'_`outcome'_pre1: xi: qui areg `outcome' treatment  if e(sample)==1,  absorb(exper_mos_year_fe) `cluster' robust
		eststo `group'_`outcome'_pre: xi: qui areg `outcome' treatment  hfpdur baspay `demo_controls' `financial_controls' if pre == 1 & `group' == 1,  absorb(exper_mos_year_fe) `cluster' robust
		dis "`outcome' `group'"
		summ `outcome' if `group' == 1 & treatment == 0
		global maint`group'`outcome' = _b[treatment] / _se[treatment]
		eststo sum_`outcome'_`group': estpost tabstat `outcome' if e(sample) == 1, listwise statistics(mean sd)
		xi: qui areg `outcome'  hfpdur baspay `demo_controls' `financial_controls' if  pre == 1 & `group' == 1,  absorb(exper_mos_year_fe) `cluster' robust
		predict epshat`group'`outcome', resid
		predict yhat`group'`outcome', xb
		* eststo `outcome'_po_`group': xi: qui areg `outcome' treatment  hfpdur baspay `demo_controls' `financial_controls' if pre == 0 & `group' == 1,  absorb(exper_m os_year_fe) `cluster' robust
		dis "`group'"
		}
	}
esttab female* male* AFQT_q1* AFQT_q2* AFQT_q3* AFQT_q4* lesshsg* hsg* greathsg* nodep* dep1* dep2* using $outsheet/full_cs_groups1.csv, se(3) b(a2) r2(4) ar2(4) star(* 0.1 ** 0.05 *** 0.01) mtitles replace
eststo clear

foreach group in married single divorced sing_div_dep sing_afqtq12  white black not_deployed  offpost onpost_single {
	foreach outcome in drug revoked mis_cm econ sep_inv  {
		xi:  qui areg `outcome' treatment  hfpdur baspay `demo_controls' `financial_controls' if pre == 1 & `group' == 1,  absorb(exper_mos_year_fe) `cluster' robust
		eststo `group'_`outcome'_p1: xi:  areg `outcome' treatment if e(sample) == 1,  absorb(exper_mos_year_fe) `cluster' robust
		eststo `group'_`outcome'_pre: xi:  areg `outcome' treatment  hfpdur baspay `demo_controls' `financial_controls' if pre == 1 & `group' == 1,  absorb(exper_mos_year_fe) `cluster' robust
		global maint`group'`outcome' = _b[treatment] / _se[treatment]
		summ `outcome' if e(sample) == 1 & treatment == 0
		eststo sum_`outcome'_`group': estpost tabstat `outcome' if e(sample) == 1, listwise statistics(mean sd)
		xi: qui areg `outcome'  hfpdur baspay `demo_controls' `financial_controls' if  pre == 1 & `group' == 1,  absorb(exper_mos_year_fe) `cluster' robust
		predict epshat`group'`outcome', resid
		predict yhat`group'`outcome', xb
		eststo `outcome'_po_`group': xi: qui areg `outcome' treatment  hfpdur baspay `demo_controls' `financial_controls' if pre == 0 & `group' == 1,  absorb(exper_mos_year_fe) `cluster' robust
		dis "`group'"
		}
	}
 
esttab married* single* divorced* sing_div_dep* sing_afqtq12*  white* black* not_deployed*  past_aer* asvabcl_high* asvabcl_low* offpost* onpost_single* using $outsheet/full_cs_groups2.csv, se(3) b(a2) r2(4) ar2(4) star(* 0.1 ** 0.05 *** 0.01) mtitles replace
eststo clear

*****************************************************************************
****** DD Results for Subsamples - Appendix Table 6 Young Soldier Sample ****
*****************************************************************************
foreach group in female male AFQT_q1 AFQT_q2 AFQT_q3 AFQT_q4 lesshsg hsg greathsg nodep dep1 dep2 {
	foreach outcome in drug revoked mis_cm econ sep_inv  {
		xi: qui areg `outcome' i.treat*i.pre  hfpdur baspay `demo_controls' `financial_controls' i.year i.grade,  absorb(exper_mos_fe) `cluster' robust
		eststo `group'_`outcome'_1: xi: qui areg `outcome' i.treat*i.pre `years' if e(sample) == 1 & `group' == 1 , absorb(exper_mos_fe) `cluster' robust
		estadd ysumm
		eststo sum_`outcome'_`group': estpost tabstat `outcome' `years' if e(sample) == 1, listwise statistics(mean sd)
		eststo `group'_`outcome'_2: xi: qui areg `outcome' i.treat*i.pre  hfpdur baspay `demo_controls' `financial_controls' `years' if `group' == 1,  absorb(exper_mos_fe) `cluster' robust
		estadd ysumm
		dis "control mean: `group' `outcome'"
		summ `outcome' if e(sample) == 1 & treatment == 0
		}
	}
esttab female* male* AFQT_q1* AFQT_q2* AFQT_q3* AFQT_q4* lesshsg* hsg* greathsg* nodep* dep1* dep2* using $outsheet/full_dd_groups.csv, se(3) b(a2) r2(4) ar2(4) star(* 0.1 ** 0.05 *** 0.01) mtitles replace
eststo clear

foreach group in married single divorced sing_div_dep sing_afqtq12  white black not_deployed  past_aer offpost onpost_single {
	foreach outcome in drug revoked mis_cm econ sep_inv  {
		xi: qui areg `outcome' i.treat*i.pre  hfpdur baspay `demo_controls' `financial_controls' i.year i.grade,  absorb(exper_mos_fe) `cluster' robust
		eststo `group'_`outcome'_1: xi: qui areg `outcome' i.treat*i.pre `years' if e(sample) == 1 & `group' == 1 , absorb(exper_mos_fe) `cluster' robust
		estadd ysumm
		eststo sum_`outcome'_`group': estpost tabstat `outcome' `years' if e(sample) == 1, listwise statistics(mean sd)
		eststo `group'_`outcome'_2: xi: qui areg `outcome' i.treat*i.pre  hfpdur baspay `demo_controls' `financial_controls' `years' if `group' == 1,  absorb(exper_mos_fe) `cluster' robust
		estadd ysumm
		dis "control mean: `group' `outcome'"
		summ `outcome' if e(sample) == 1 & treatment == 0
		}
	}
esttab married* single* divorced* sing_div_dep* sing_afqtq12* white* black* not_deployed*  past_aer* asvabcl_high* asvabcl_low* offpost* onpost_single*  using $outsheet/full_dd_groups2.csv, se(3) b(a2) r2(4) ar2(4) star(* 0.1 ** 0.05 *** 0.01) mtitles replace
eststo clear


*********************************************************************************************
****** Wild Bootstrapping for Appendix Table 1 Panel A and Panel C Young Soldier Samples ****
*********************************************************************************************

if `wild_bootstrap' {
set seed 365476247 
global bootreps = 1000
bys state: gen num_state = _n
count if num_state == 1
global numstates = r(N)

postfile bskeep_full t_wildsep_inv ddt_wildsep_inv t_wildrevoked ddt_wildrevoked using $datadir/bs_results_full, replace

gen treat_pre = treatment*pre
forvalues b=1/$bootreps {
dis "iteration `b'"
sort state
qui by state: gen temp = uniform()
qui by state: gen pos = (temp[1] < .5)

foreach var in sep_inv revoked {
gen wildresid`var' = epshat`var' * (2*pos - 1)
gen wild`var' = yhat`var' + wildresid`var'
dis "`var' `b'"
xi: qui areg wild`var' treatment  hfpdur baspay `demo_controls' `financial_controls'  if pre == 1,  absorb(exper_mos_year_fe) `cluster' robust
local bst_wild_`var' = _b[treatment] / _se[treatment]
drop wildresid`var' wild`var' 


gen wildresid`var' = ddepshat`var' * (2*pos - 1)
gen wild`var' = ddyhat`var' + wildresid`var'
dis "`var' `b'_dd"
xi: qui areg wild`var' treatment pre treat_pre  hfpdur baspay `demo_controls' `financial_controls',  absorb(exper_mos_year_fe) `cluster' robust
local bst_wild_`var'_dd = _b[treat_pre] / _se[treat_pre]
drop wildresid`var' wild`var'

}
post bskeep_full (`bst_wild_sep_inv') (`bst_wild_sep_inv_dd') (`bst_wild_revoked') (`bst_wild_revoked')
drop temp pos
}

postclose bskeep_full

use $datadir/bs_results_full, clear
foreach var in sep_inv revoked {
	gen positive_`var'= ${maint`var'}>0
	gen pos_`var' = t_wild`var' > ${maint`var'}
	gen neg_`var' = t_wild`var' < ${maint`var'}
	gen reject_`var' = positive_`var' * pos_`var' + (1-positive_`var')*neg_`var'
	summ reject_`var'
	local sumreject_`var' = r(sum)
	local p_value_wild`var'=2*`sumreject_`var''/$bootreps
	local p_value_main`var' = 2*(ttail(($numstates-1),abs(${maint`var'})))
	dis "Number BS reps `var' = $bootreps"
	dis "P-value from clustered standard errors, `var' = `p_value_main`var''"
	dis "P-value from wild bootstrap, `var' = `p_value_wild`var''"

	drop positive_`var' pos_`var' neg_`var' reject_`var'

	gen positive_`var'= ${ddmaint`var'}>0
	gen pos_`var' = ddt_wild`var' > ${ddmaint`var'}
	gen neg_`var' = ddt_wild`var' < ${ddmaint`var'}
	gen reject_`var' = positive_`var' * pos_`var' + (1-positive_`var')*neg_`var'
	summ reject_`var'
	local sumreject_`var' = r(sum)
	local p_value_wild`var'=2*`sumreject_`var''/$bootreps
	local p_value_main`var' = 2*(ttail(($numstates-1),abs(${ddmaint`var'})))
	dis "Number BS reps `var' = $bootreps"
	dis "P-value from clustered standard errors for dd, `var' = `p_value_main`var''"
	dis "P-value from wild bootstrap for dd, `var' = `p_value_wild`var''"
	}

}

}



if `id_strategy_1_xs_full' {

use $datadir/final_id_strategy_1_xs_full 
local wild_bootstrap = 1
local cross_section = 1
local years year_*
local cluster cluster(state)
local outsheet2 xs_1

** normal credit group
local credit_out econ sep_inv mis_cm drug
local credit1 econ
local credit2 sep_inv
local credit3 mis_cm
local credit4 drug
local credit_out_prev ahd30_ abk16_ ahi83_ score_
local credit1_p ahd30_
local credit2_p abk16_
local credit3_p ahi83_
local credit4_p score_

if `appendix' {
local credit_out bankr econ derog drug
local credit1 bankr
local credit2 econ
local credit3 derog
local credit4 drug
local credit_out_prev bankr abk16_ derog score_
local credit1_p bankr
local credit2_p abk16_
local credit3_p derog
local credit4_p score_
}

**********************************************************************
**** Table 1 Panel B & Appendix Table 4 and 6 "All Soldier Sample" ****
**********************************************************************
local demos hfpdur_ baspay_ female nonwhite numdep_ ged hsg smc_asc collegepl afqsc_ married divorced age age_sq ue hp ahd30_prev bankrprev derogprev score_prev
local demosexog hfpdur_ baspay_ female nonwhite numdep_ ged hsg smc_asc collegepl afqsc_ married divorced age age_sq ahd30_prev bankrprev derogprev score_prev
	qui areg pdl_access2  `demosexog' if pre == 1 & score_~= ., absorb(exper_mos_year_fe) `cluster' robust
	eststo exog1_pr: xi: qui areg pdl_access2 if e(sample) == 1, absorb(exper_mos_year_fe) `cluster' robust 
	eststo exog2_pr: xi: qui areg pdl_access2  `demosexog' if e(sample) == 1, absorb(exper_mos_year_fe) `cluster' robust
	test afqsc_ female nonwhite numdep_ ged smc_asc collegepl hsg married divorced hfpdur_ baspay_ age age_sq ahd30_prev bankrprev derogprev score_prev
	qui areg pdl_access2   `demosexog' if pre == 0 & score_~= ., absorb(exper_mos_year_fe) `cluster' robust
	eststo exog1_po: xi:  qui areg pdl_access2 if e(sample) == 1, absorb(exper_mos_year_fe) `cluster' robust
	eststo exog2_po: xi:  qui areg pdl_access2   `demosexog' if e(sample) == 1, absorb(exper_mos_year_fe) `cluster' robust
	test afqsc_ female nonwhite numdep_ ged smc_asc collegepl hsg married divorced hfpdur_ baspay_ age age_sq ahd30_prev bankrprev derogprev score_prev 
	qui areg pdl_access2   `demosexog' if score_~= ., absorb(exper_mos_year_fe) `cluster' robust
	eststo exog1_all: xi:  qui areg pdl_access2 if e(sample) == 1, absorb(exper_mos_year_fe) `cluster' robust
	eststo exog2_all: xi:  qui areg pdl_access2   `demosexog' if e(sample) == 1, absorb(exper_mos_year_fe) `cluster' robust
	test afqsc_ female nonwhite numdep_ ged smc_asc collegepl hsg married divorced hfpdur_ baspay_ age age_sq ahd30_prev bankrprev derogprev score_prev 
	qui areg cross pre pdl_access2  `years' `demosexog' if score_~= ., absorb(exper_mos_fe) `cluster' robust
	eststo exog1_cross1: xi:  qui areg cross pre pdl_access2 `years' if e(sample) == 1, absorb(exper_mos_fe) `cluster' robust
	eststo exog2_cross1: xi:  qui areg cross pre pdl_access2  `years' `demosexog' if e(sample) == 1, absorb(exper_mos_fe) `cluster' robust
	test afqsc_ female nonwhite numdep_ ged smc_asc collegepl hsg married divorced hfpdur_ baspay_ age age_sq ahd30_prev bankrprev derogprev score_prev
	qui areg cross `demosexog' if score_~= ., absorb(exper_mos_year_fe) `cluster' robust
	eststo exog1_cross2: xi:  qui areg cross if e(sample) == 1, absorb(exper_mos_year_fe) `cluster' robust
	eststo exog2_cross2: xi:  qui areg cross `demosexog' if e(sample) == 1, absorb(exper_mos_year_fe) `cluster' robust
	test afqsc_ female nonwhite numdep_ ged smc_asc collegepl hsg married divorced hfpdur_ baspay_ age age_sq ahd30_prev bankrprev derogprev score_prev 
	esttab using $outsheet\t_`outsheet2'_exogeneity.csv, se(3) b(a2) r2(4) star(* 0.1 ** 0.05 *** 0.01) mtitles replace
	eststo clear

gen startdate = date(basdt_s, "MDY")
gen startdate2 = date(bpedt_s, "MDY")


dis "Credit Outcomes"

eststo clear
foreach outcome in  `credit_out'  {
	eststo `outcome'_1_pre: xi: qui areg `outcome' pdl_access2  if pre == 1, absorb(exper_mos_year_fe) `cluster' robust
	eststo sum_`outcome': estpost tabstat `outcome' if e(sample) == 1 & pdl_access == 0, listwise statistics(mean sd)
	eststo `outcome'_2_pre: xi: qui areg `outcome' pdl_access2  hfpdur_ baspay_ `independent'  if pre == 1,  absorb(exper_mos_year_fe) `cluster' robust
	estadd ysumm
	predict resid`outcome', resid
	global maint`outcome' = _b[pdl_access2] / _se[pdl_access2]

	histogram resid`outcome', normal title(`outcome')
	graph export $figdir/resid`outcome'.ps, replace

	xi: qui areg `outcome'  hfpdur_ baspay_ `independent',  absorb(exper_mos_year_fe) `cluster' robust
	dis "new summ stats `outcome'"
*************************************************
*** Table 1 Summary Statistics ******************
*************************************************
	bys pdl_access2 pre: summ afqsc_ female white nonwhite numdep_ ged hsd hsg smc_asc collegepl married divorced age baspay_ hfpdur_ aal06_  aal07_ aal26_ aau01_ `credit_out' aln08_ ahd30_ ahi83_ ahd11_ score_ sep_inv sep_vol if e(sample) == 1
	bys pdl_access2 pre: tab state if e(sample) == 1
	}
*****************************************************************
**** Table 3 Panel A ***********************
*****************************************************************
	esttab `credit1'*  `credit2'* `credit3'* `credit4'*   using $outsheet\t_`outsheet2'_pre.csv, se(3) b(a2) r2(4) star(* 0.1 ** 0.05 *** 0.01) stats(N r2 ymean ysd) mtitles replace
	esttab `credit1'*  `credit2'* `credit3'* `credit4'*   using $outsheet\t_`outsheet2'_pre_ci.csv, ci(3) b(a2) r2(4) star(* 0.1 ** 0.05 *** 0.01) mtitles replace

	eststo clear

*** For Wild Bootstrapping ***
foreach outcome in sep_inv mis_cm {
	xi: qui areg `outcome'  hfpdur_ baspay_ `independent'  if pre == 1,  absorb(exper_mos_year_fe) `cluster' robust
	predict epshat`outcome', resid
	predict yhat`outcome', xb
	}
foreach outcome in ahd30_ score_ {
	xi: qui areg `outcome'  hfpdur_ baspay_ `independent' `outcome'prev if pre == 1,  absorb(exper_mos_year_fe) `cluster' robust
	predict epshat`outcome', resid
	predict yhat`outcome', xb
	}

*****************************************************************
**** Table 3 Panel A with lags for the credit outcomes **********
*****************************************************************
foreach outcome in  `credit_out_prev'  {
	xi: qui areg `outcome' pdl_access2  `outcome'prev hfpdur_ baspay_ `independent'  if pre == 1,  absorb(exper_mos_year_fe) `cluster' robust
	eststo `outcome'_1_pre: xi: qui areg `outcome' pdl_access2  if e(sample) == 1, absorb(exper_mos_year_fe) `cluster' robust
	eststo sum_`outcome': estpost tabstat `outcome' `outcome'prev if e(sample) == 1 & pdl_access == 0, listwise statistics(mean sd)
	eststo `outcome'_2_pre: xi: qui areg `outcome' pdl_access2  `outcome'prev hfpdur_ baspay_ `independent'  if pre == 1,  absorb(exper_mos_year_fe) `cluster' robust
	estadd ysumm
	}
	esttab `credit1_p'*  `credit2_p'* `credit3_p'* `credit4_p'*   using $outsheet\t_`outsheet2'_pre_prev.csv, se(3) b(a2) r2(4) star(* 0.1 ** 0.05 *** 0.01) stats(N r2 ymean ysd) mtitles replace
	esttab `credit1_p'*  `credit2_p'* `credit3_p'* `credit4_p'*   using $outsheet\t_`outsheet2'_pre_ci_prev.csv, ci(3) b(a2) r2(4) star(* 0.1 ** 0.05 *** 0.01) mtitles replace


summ afqsc, d
gen AFQT_q1 = (afqsc < r(p25))
gen AFQT_q2 = (afqsc >= r(p25) & afqsc < r(p50))
gen AFQT_q3 = (afqsc >= r(p50) & afqsc < r(p75))
gen AFQT_q4 = (afqsc >= r(p75))
gen not_married = married == 0
gen greathsg = (civedcatg_ == "ASC" | civedcatg_ == "CLG" | civedcatg_ == "GRD" | civedcatg_ == "SMC")
gen nodep = numdep_ == 0
gen dep1 = numdep_ == 1
gen dep2 = numdep_ > 1
gen lesshsg = ged == 1 | hsd == 1
gen notmar_dep = married == 0 & numdep_ > 0

*****************************************************************
**** Appendix Table 4 with lags for the credit outcomes *********
*****************************************************************
eststo clear
foreach outcome in `credit_out'   {
	foreach group in female male AFQT_q1 AFQT_q2 AFQT_q3 AFQT_q4 lesshsg hsg greathsg nodep dep1 dep2 not_married married single divorced notmar_dep white black not_deployed q1_q2_score auto_50pay auto_cc_50pay cc_2month  {
		eststo `group'_`outcome'_1_pre: xi: qui areg `outcome' pdl_access2  if pre == 1 & `group' == 1, absorb(exper_mos_year_fe) `cluster' robust
		dis "`outcome' `group'"
		summ `outcome' if `group' == 1 & pdl_access2 == 0
		eststo sum_`outcome'_`group': estpost tabstat `outcome' if e(sample) == 1, listwise statistics(mean sd)
		eststo `group'_`outcome'_2_pre: xi: qui areg `outcome' pdl_access2  hfpdur_ baspay_ `independent'  if pre == 1 & `group' == 1,  absorb(exper_mos_year_fe) `cluster' robust
		global maint`group'`outcome' = _b[pdl_access2] / _se[pdl_access2]
		xi: qui areg `outcome' hfpdur_ baspay_ `independent'  if pre == 1 & `group' == 1,  absorb(exper_mos_year_fe) `cluster' robust
		predict epshat`group'`outcome', resid
		predict yhat`group'`outcome', xb

		}
	}
esttab female* male* AFQT_q1* AFQT_q2* AFQT_q3* AFQT_q4* lesshsg* hsg* greathsg* nodep* dep1* dep2* not_married* married* single* divorced* notmar_dep* white* black* not_deployed* q1_q2_score* auto_50pay* auto_cc_50pay* cc_2month* using $outsheet\t_`outsheet2'_pre_groups.csv, se(3) b(a2) r2(4) star(* 0.1 ** 0.05 *** 0.01) mtitles replace

eststo clear
foreach outcome in `credit_out_prev'   {
	foreach group in female male AFQT_q1 AFQT_q2 AFQT_q3 AFQT_q4 lesshsg hsg greathsg nodep dep1 dep2 not_married married single divorced notmar_dep white black not_deployed q1_q2_score auto_50pay auto_cc_50pay cc_2month  {
		xi: qui areg `outcome' pdl_access2 `outcome'prev hfpdur_ baspay_ `independent'  if pre == 1 & `group' == 1, absorb(exper_mos_year_fe) `cluster' robust
		eststo `group'_`outcome'_1_pre: xi: qui areg `outcome' pdl_access2  if e(sample)==1, absorb(exper_mos_year_fe) `cluster' robust
		eststo `group'_`outcome'_2_pre: xi: qui areg `outcome' pdl_access2 `outcome'prev hfpdur_ baspay_ `independent'  if e(sample)==1,  absorb(exper_mos_year_fe) `cluster' robust
		}
	}
	esttab female* male* AFQT_q1* AFQT_q2* AFQT_q3* AFQT_q4* lesshsg* hsg* greathsg* nodep* dep1* dep2* not_married* married* single* divorced* notmar_dep* white* black* not_deployed* q1_q2_score* auto_50pay* auto_cc_50pay* cc_2month* using $outsheet\t_`outsheet2'_pre_groups_prev.csv, se(3) b(a2) r2(4) star(* 0.1 ** 0.05 *** 0.01) mtitles replace
	eststo clear


foreach outcome in `credit_out'  {
	foreach group in offpost q1_q2_score2 single_onpost {
		eststo `group'_`outcome'_1_pre: xi: qui areg `outcome' pdl_access2  if pre == 1 & `group' == 1, absorb(exper_mos_year_fe) `cluster' robust
		eststo sum_`outcome'_`group': estpost tabstat `outcome' if e(sample) == 1, listwise statistics(mean sd)
		eststo `group'_`outcome'_2_pre: xi: qui areg `outcome' pdl_access2  hfpdur_ baspay_ `independent'  if pre == 1 & `group' == 1,  absorb(exper_mos_year_fe) `cluster' robust
		global maint`group'`outcome' = _b[pdl_access2] / _se[pdl_access2]
		xi: qui areg `outcome'  hfpdur_ baspay_ `independent'  if pre == 1 & `group' == 1,  absorb(exper_mos_year_fe) `cluster' robust
		predict epshat`group'`outcome', resid
		predict yhat`group'`outcome', xb

		}
	}
esttab offpost* q1_q2_score2* single_onpost* using $outsheet\t_`outsheet2'_pre_groups2.csv, se(3) b(a2) r2(4) star(* 0.1 ** 0.05 *** 0.01) mtitles replace
eststo clear

foreach outcome in `credit_out_prev'  {
	foreach group in offpost q1_q2_score2 single_onpost {
		xi: qui areg `outcome' pdl_access2 `outcome'prev hfpdur_ baspay_ `independent'  if pre == 1 & `group' == 1,  absorb(exper_mos_year_fe) `cluster' robust
		eststo `group'_`outcome'_1_pre: xi: qui areg `outcome' pdl_access2  if e(sample)==1, absorb(exper_mos_year_fe) `cluster' robust
		eststo `group'_`outcome'_2_pre: xi: qui areg `outcome' pdl_access2  hfpdur_ baspay_ `independent'  if e(sample)==1,  absorb(exper_mos_year_fe) `cluster' robust
		}
		}
		esttab offpost* q1_q2_score2* single_onpost* using $outsheet\t_`outsheet2'_pre_groups2_prev.csv, se(3) b(a2) r2(4) star(* 0.1 ** 0.05 *** 0.01) mtitles replace
		eststo clear
		

*********************************************
** Wild Bootstrapping for Appendix Table 1 **
*********************************************

if `wild_bootstrap' {
	set seed 365476247 
	global bootreps = 1000
	bys state: gen num_state = _n
	count if num_state == 1
	global numstates = r(N)


postfile bskeep t_wildsep_inv t_wildmis_cm t_wildahd30_ t_wildscore_ using $datadir/bs_results, replace

forvalues b=1/$bootreps {
	sort state
	qui by state: gen temp = uniform()
	qui by state: gen pos = (temp[1] < .5)


	foreach var in sep_inv mis_cm  {
	gen wildresid`var' = epshat`var' * (2*pos - 1)
	gen wild`var' = yhat`var' + wildresid`var'

		if `cross_section' {
		xi: qui areg wild`var' pdl_access2  hfpdur_ baspay_ `independent'  if pre == 1,  absorb(exper_mos_year_fe) `cluster' robust
		local bst_wild_`var' = _b[pdl_access2] / _se[pdl_access2]
		drop wildresid`var' wild`var' 
		}
}

foreach var in ahd30_ score_  {
	gen wildresid`var' = epshat`var' * (2*pos - 1)
	gen wild`var' = yhat`var' + wildresid`var'

	if `cross_section' {
	xi: qui areg wild`var' pdl_access2  hfpdur_ baspay_ `independent' `var'prev if pre == 1,  absorb(exper_mos_year_fe) `cluster' robust
	local bst_wild_`var' = _b[pdl_access2] / _se[pdl_access2]
	drop wildresid`var' wild`var' 
	}

}

	post bskeep (`bst_wild_sep_inv') (`bst_wild_mis_cm') (`bst_wild_ahd30_') (`bst_wild_score_')
	drop temp pos
	}

	postclose bskeep


use $datadir/bs_results
foreach var in sep_inv mis_cm ahd30_ score_ {
	gen positive_`var'= ${maint`var'}>0
	gen pos_`var' = t_wild`var' > ${maint`var'}
	gen neg_`var' = t_wild`var' < ${maint`var'}
	gen reject_`var' = positive_`var' * pos_`var' + (1-positive_`var')*neg_`var'
	summ reject_`var'
	local sumreject_`var' = r(sum)
	local p_value_wild`var'=2*`sumreject_`var''/$bootreps
	local p_value_main`var' = 2*(ttail(($numstates-1),abs(${maint`var'})))
	dis "Number BS reps `var' = $bootreps"
	dis "P-value from clustered standard errors, `var' = `p_value_main`var''"
	dis "P-value from wild bootstrap, `var' = `p_value_wild`var''"
	}


}
}





if `id_strategy_3_dd_full' {
use $datadir/final_id_strategy_3_dd_full
local wild_bootstrap = 1

	local outsheet2 dd_1
	** normal credit group
	local credit_out econ sep_inv mis_cm drug
	local credit1 econ
	local credit2 sep_inv
	local credit3 mis_cm
	local credit4 drug
	local credit_out_prev ahd30_ abk16_ ahi83_ score_
	local credit1_p ahd30_
	local credit2_p abk16_
	local credit3_p ahi83_
	local credit4_p score_

	if `appendix' {
		local credit_out bankr econ derog drug
		local credit1 bankr
		local credit2 econ
		local credit3 derog
		local credit4 drug
		local credit_out_prev bankr abk16_ derog score_
		local credit1_p bankr
		local credit2_p abk16_
		local credit3_p derog
		local credit4_p score_
		}


foreach var in `credit_out'  {
	xi: eststo `var'_1: qui areg `var'  pre treatment treat_pre `years', absorb(exper_mos_fe) `cluster' robust
	xi: eststo `var'_2: areg `var'  pre treatment treat_pre `demo_controls' `financial_controls' `years', absorb(exper_mos_fe) `cluster' robust
	estadd ysumm
	predict resid`var', resid
	global maint`var' = _b[treat_pre] / _se[treat_pre]
	summ `var' if e(sample) == 1 & treatment == 0
	xi: qui areg `var'  pre treatment `demo_controls' `financial_controls' `years', absorb(exper_mos_fe) `cluster' robust
	predict epshat`var', resid
	predict yhat`var', xb
	}
dis "Table, All"
*******************************************
** Table 3 Panel C for All Soldier Sample**
*******************************************
esttab using $outsheet\t_`outsheet2'_dd.csv , se(3) b(a2) r2(4) star(* 0.1 ** 0.05 *** 0.01) stats(N r2 ymean ysd) mtitles replace
esttab using $outsheet\t_`outsheet2'_dd_ci.csv , ci(3) b(a2) r2(4) star(* 0.1 ** 0.05 *** 0.01) mtitles replace
esttab using $outsheet\t_`outsheet2'_dd_p.csv , p(2) b(a2) r2(4) star(* 0.1 ** 0.05 *** 0.01) mtitles replace

eststo clear
foreach var in `credit_out_prev'  {
	xi: qui areg `var'  pre treatment treat_pre `var'prev `demo_controls' `financial_controls' `years', absorb(exper_mos_fe) `cluster' robust
	xi: eststo `var'_1: qui areg `var'  pre treatment treat_pre `years' if e(sample) == 1, absorb(exper_mos_fe) `cluster' robust
	estadd ysumm
	predict resid`var', resid
	global maint`var' = _b[treat_pre] / _se[treat_pre]
	summ `var' if e(sample) == 1 & treatment == 0
	dis "looking at reg, outcome = `var'"
	xi: eststo `var'_2: areg `var'  pre treatment treat_pre `var'prev `demo_controls' `financial_controls' `years', absorb(exper_mos_fe) `cluster' robust
	xi: qui areg `var'  pre treatment `demo_controls' `financial_controls' `years', absorb(exper_mos_fe) `cluster' robust
	predict epshat`var', resid
	predict yhat`var', xb
	}
dis "Table, All"
**************************************************************************
** Table 3 Panel C for All Soldier Sample with lags for credit outcomes **
**************************************************************************
esttab using $outsheet\t_`outsheet2'_dd_prev.csv , se(3) b(a2) r2(4) star(* 0.1 ** 0.05 *** 0.01) stats(N r2 ymean ysd)mtitles replace
esttab using $outsheet\t_`outsheet2'_dd_ci_prev.csv , ci(3) b(a2) r2(4) star(* 0.1 ** 0.05 *** 0.01) mtitles replace
esttab using $outsheet\t_`outsheet2'_dd_p_prev.csv , p(2) b(a2) r2(4) star(* 0.1 ** 0.05 *** 0.01) mtitles replace


tab _merge
foreach var in `credit_out'  {
	xi: eststo `var'_1: qui areg `var'  pre treatment treat_pre  `years' , absorb(exper_mos_fe) `cluster' robust
	xi: eststo `var'_2: qui areg `var'  pre treatment treat_pre `demo_controls' `financial_controls' `years' , absorb(exper_mos_fe) `cluster' robust

	xi: eststo `var'_1_on: qui areg `var'  pre treatment treat_pre  `years'  if single_onpost == 1, absorb(exper_mos_fe) `cluster' robust
	xi: eststo `var'_2_on: qui areg `var'  pre treatment treat_pre `demo_controls' `financial_controls' `years'  if single_onpost == 1, absorb(exper_mos_fe) `cluster' robust

	}
dis "Table, All"
esttab using $outsheet\t_`outsheet2'_dd_unempl.csv , se(3) b(a2) r2(4) star(* 0.1 ** 0.05 *** 0.01) mtitles replace
esttab using $outsheet\t_`outsheet2'_dd_unempl_ci.csv , ci(3) b(a2) r2(4) star(* 0.1 ** 0.05 *** 0.01) mtitles replace
esttab using $outsheet\t_`outsheet2'_dd_unempl_p.csv , p(2) b(a2) r2(4) star(* 0.1 ** 0.05 *** 0.01) mtitles replace


eststo clear
preserve
**************************************************************************
** Results when do not include Ft. Benning *******************************
**************************************************************************
drop if (stanam == "FT BENNING")
foreach var in `credit_out' {
	xi: eststo `var'_1: qui areg `var'  pre treatment treat_pre `years', absorb(exper_mos_fe) `cluster' robust
	xi: eststo `var'_2: qui areg `var'  pre treatment treat_pre `demo_controls' `financial_controls' `years', absorb(exper_mos_fe) `cluster' robust
	summ `var' if e(sample) == 1 & treatment == 0
	}
dis "Table, All"
esttab using $outsheet\t_`outsheet2'_dd_nofb.csv , se(3) b(a2) r2(4) star(* 0.1 ** 0.05 *** 0.01) mtitles replace
esttab using $outsheet\t_`outsheet2'_dd_nofb_ci.csv , ci(3) b(a2) r2(4) star(* 0.1 ** 0.05 *** 0.01) mtitles replace
esttab using $outsheet\t_`outsheet2'_dd_nofb_p.csv , p(2) b(a2) r2(4) star(* 0.1 ** 0.05 *** 0.01) mtitles replace

restore

eststo clear

foreach var in `credit_out'  {
	xi: eststo `var'_1: qui areg `var'  pre treatment treat_pre `years' if year == 2005 | year == 2006 | year == 2009 | year == 2010, absorb(exper_mos_fe) `cluster' robust
	xi: eststo `var'_2: qui areg `var'  pre treatment treat_pre `demo_controls' `financial_controls' `years' if year == 2005 | year == 2006 | year == 2009 | year == 2010, absorb(exper_mos_fe) `cluster' robust
	summ `var' if e(sample) == 1
	}
dis "Table, All"
**************************************************************************
** Results when do not 2008 *******************************
**************************************************************************
esttab using $outsheet\t_`outsheet2'_dd_05_06_09_10.csv , se(3) b(a2) r2(4) star(* 0.1 ** 0.05 *** 0.01) mtitles replace
esttab using $outsheet\t_`outsheet2'_dd_ci_05_06_09_10_ci.csv , ci(3) b(a2) r2(4) star(* 0.1 ** 0.05 *** 0.01) mtitles replace
esttab using $outsheet\t_`outsheet2'_dd_p_05_06_09_10_p.csv , p(2) b(a2) r2(4) star(* 0.1 ** 0.05 *** 0.01) mtitles replace



summ afqsc, d
gen AFQT_q1 = (afqsc < r(p25))
gen AFQT_q2 = (afqsc >= r(p25) & afqsc < r(p50))
gen AFQT_q3 = (afqsc >= r(p50) & afqsc < r(p75))
gen AFQT_q4 = (afqsc >= r(p75))
gen not_married = married == 0
gen greathsg = (civedcatg_ == "ASC" | civedcatg_ == "CLG" | civedcatg_ == "GRD" | civedcatg_ == "SMC")
gen nodep = numdep_ == 0
gen dep1 = numdep_ == 1
gen dep2 = numdep_ > 1
gen notmar_dep = married == 0 & numdep_ > 0

eststo clear

**************************************************************************
***** Appendix Table 6 All Soldier Sample  *******************************
**************************************************************************
foreach group in  male AFQT_q1 AFQT_q2 AFQT_q3 AFQT_q4 lesshsg hsg greathsg nodep dep1 dep2 not_married married single divorced notmar_dep white black not_deployed q1_q2_score auto_50pay auto_cc_50pay cc_2month offpost q1_q2_score2 single_onpost {
	foreach var in `credit_out' {
		xi: eststo `var'_`group'_1: qui areg `var'  pre treatment treat_pre `years' if `group' == 1, absorb(exper_mos_fe) `cluster' robust
		xi: eststo `var'_`group'_2: qui areg `var'  pre treatment treat_pre `years' `demo_controls' `financial_controls' if `group' == 1, absorb(exper_mos_fe) `cluster' robust
		dis "`var' `group'"
		summ `var' if e(sample) == 1 & treatment == 0
		}
	}
esttab using $outsheet\t_`outsheet2'_dd_groups.csv, se(3) b(a2) r2(4) star(* 0.1 ** 0.05 *** 0.01) mtitles replace
eststo clear

foreach group in  male AFQT_q1 AFQT_q2 AFQT_q3 AFQT_q4 lesshsg hsg greathsg nodep dep1 dep2 not_married married single divorced notmar_dep white black not_deployed q1_q2_score auto_50pay auto_cc_50pay cc_2month offpost q1_q2_score2 single_onpost {
	foreach var in `credit_out_prev' {
		qui areg `var'  pre treatment treat_pre `var'prev `years' `demo_controls' `financial_controls' if `group' == 1, absorb(exper_mos_fe) `cluster' robust
		xi: eststo `var'_`group'_1: qui areg `var'  pre treatment treat_pre `years' if e(sample) == 1, absorb(exper_mos_fe) `cluster' robust
		xi: eststo `var'_`group'_2: qui areg `var'  pre treatment treat_pre `var'prev `years' `demo_controls' `financial_controls' if e(sample) == 1, absorb(exper_mos_fe) `cluster' robust
		}
	}
esttab using $outsheet\t_`outsheet2'_dd_groups_prev.csv, se(3) b(a2) r2(4) star(* 0.1 ** 0.05 *** 0.01) mtitles replace
eststo clear

foreach group in single_onpost {
	foreach var in `credit_out'  {
		xi: eststo `var'_`group'_1: qui areg `var'  pre treatment treat_pre `years' if `group' == 1, absorb(exper_mos_fe) `cluster' robust
		dis "p"
		xi: eststo `var'_`group'_2: qui areg `var'  pre treatment treat_pre `years' `demo_controls' `financial_controls' if `group' == 1, absorb(exper_mos_fe) `cluster' robust
		dis "`var' `group'"
		summ `var' if e(sample) == 1 & treatment == 0
		}
	}
esttab using $outsheet\t_`outsheet2'_dd_single_onpost.csv, se(3) b(a2) r2(4) star(* 0.1 ** 0.05 *** 0.01) mtitles replace
esttab using $outsheet\t_`outsheet2'_dd_single_onpost_ci.csv, ci(3) b(a2) r2(4) star(* 0.1 ** 0.05 *** 0.01) mtitles replace
eststo clear


foreach group in single_onpost {
	foreach var in `credit_out_prev'  {
		qui areg `var'  pre treatment treat_pre `var'prev `years' `demo_controls' `financial_controls' if `group' == 1, absorb(exper_mos_fe) `cluster' robust
		xi: eststo `var'_`group'_1: qui areg `var'  pre treatment treat_pre `years' if e(sample) == 1, absorb(exper_mos_fe) `cluster' robust
		xi: eststo `var'_`group'_2: qui areg `var'  pre treatment treat_pre `var'prev `years' `demo_controls' `financial_controls' if e(sample) == 1, absorb(exper_mos_fe) `cluster' robust
		}
	}
esttab using $outsheet\t_`outsheet2'_dd_single_onpost_prev.csv, se(3) b(a2) r2(4) star(* 0.1 ** 0.05 *** 0.01) mtitles replace
eststo clear

**************************************************************************
***** Wild Bootrstrapping for Appendix Table 1  **************************
**************************************************************************
if `wild_bootstrap' {
set seed 365476247 
global bootreps = 1000
bys state: gen num_state = _n
count if num_state == 1
global numstates = r(N)


postfile bskeep t_wildsep_inv t_wildmis_cm t_wildahd30_ t_wildscore_ using $datadir/bs_results, replace

forvalues b=1/$bootreps {
sort state
qui by state: gen temp = uniform()
qui by state: gen pos = (temp[1] < .5)


foreach var in sep_inv mis_cm  {
gen wildresid`var' = epshat`var' * (2*pos - 1)
gen wild`var' = yhat`var' + wildresid`var'


xi: eststo `var'_2: qui areg wild`var'  pre treatment treat_pre `demo_controls' `financial_controls' `years', absorb(exper_mos_fe) `cluster' robust
local bst_wild_`var' = _b[treat_pre] / _se[treat_pre]
drop wildresid`var' wild`var' 

}

foreach var in ahd30_ score_  {
gen wildresid`var' = epshat`var' * (2*pos - 1)
gen wild`var' = yhat`var' + wildresid`var'


xi: eststo `var'_2: qui areg wild`var'  pre treatment treat_pre `var'prev `demo_controls' `financial_controls' `years', absorb(exper_mos_fe) `cluster' robust
local bst_wild_`var' = _b[treat_pre] / _se[treat_pre]
drop wildresid`var' wild`var' 


}
post bskeep (`bst_wild_sep_inv') (`bst_wild_mis_cm') (`bst_wild_ahd30_') (`bst_wild_score_')
drop temp pos
}
postclose bskeep

clear

use $datadir/bs_results
foreach var in sep_inv mis_cm ahd30_ score_ {
gen positive_`var'= ${maint`var'}>0
gen pos_`var' = t_wild`var' > ${maint`var'}
gen neg_`var' = t_wild`var' < ${maint`var'}
gen reject_`var' = positive_`var' * pos_`var' + (1-positive_`var')*neg_`var'
summ reject_`var'
local sumreject_`var' = r(sum)
local p_value_wild`var'=2*`sumreject_`var''/$bootreps
local p_value_main`var' = 2*(ttail(($numstates-1),abs(${maint`var'})))
dis "Number BS reps `var' = $bootreps"
dis "P-value from clustered standard errors, `var' = `p_value_main`var''"
dis "P-value from wild bootstrap, `var' = `p_value_wild`var''"
}
}

}


if `id_strategy_2_within_term' {
/* do file originally used: fraction_rr2.do */
use $datadir/final_second_strategy

**************************************
*** Randomization Tables (TABLE 2)
**************************************
	xi: qui areg  frac_pdl `demo_controls' fr_* if time_in > 180 & everabroad == 0, absorb(exper_mos_year_fe)
	eststo frac_180_1_fr: xi: areg  frac_pdl fr_* if e(sample) == 1, robust absorb(exper_mos_year_fe)
	eststo frac_180_2_fr: xi: areg  frac_pdl fr_* `demo_controls' if e(sample) == 1, robust absorb(exper_mos_year_fe)
	test afqsc female nonwhite nrdep ged hsg asc_smc college_pl married divorced age age_sq
	estadd ysumm
	xi: qui areg  frac_pdl `demo_controls' if time_in > 180 & everabroad == 0, absorb(exper_mos_year_fe)
	tab state if e(sample) ==1
	eststo frac_180_base_na: xi: areg  frac_pdl if e(sample) == 1, robust absorb(exper_mos_year_fe)
	eststo frac_180_demos_na: xi: areg  frac_pdl `demo_controls' if e(sample) == 1, robust absorb(exper_mos_year_fe)
	test afqsc female nonwhite nrdep ged hsg asc_smc college_pl married divorced age age_sq 
	foreach var in `demo_controls' {
	eststo frac_180_`var': xi: areg frac_pdl `var' fr_* if e(sample) == 1, robust absorb(exper_mos_year_fe)
	}
	estadd ysumm 

	xi: qui areg  frac_pdl `demo_controls' if time_in > 365 & everabroad == 0, absorb(exper_mos_year_fe)
	eststo frac_365_base_na: xi: areg  frac_pdl if e(sample) == 1, robust absorb(exper_mos_year_fe)
	eststo frac_365_demos_na: xi: areg  frac_pdl `demo_controls' if e(sample) == 1, robust absorb(exper_mos_year_fe)
	test afqsc female nonwhite nrdep ged hsg asc_smc college_pl married divorced age age_sq 
	foreach var in `demo_controls' {
	eststo frac_365_`var': xi: areg frac_pdl `var' fr_* if e(sample) == 1, robust absorb(exper_mos_year_fe)
	}
	estadd ysumm 
	xi: qui areg  frac_pdl `demo_controls' fr_* if time_in > 365 & everabroad == 0, absorb(exper_mos_year_fe)
	eststo frac_365_1_fr: xi: areg  frac_pdl fr_* if e(sample) == 1, robust absorb(exper_mos_year_fe)
	eststo frac_365_2_fr: xi: areg  frac_pdl fr_* `demo_controls' if e(sample) == 1, robust absorb(exper_mos_year_fe)
	test afqsc female nonwhite nrdep ged hsg asc_smc college_pl married divorced age age_sq
	estadd ysumm 
	esttab using $outsheet/randomization.csv, se(3) b(a2) r2(4) ar2(4) star(* 0.1 ** 0.05 *** 0.01) stats(N r2 ymean ysd) mtitles replace
******************

	ren clearance sec
	replace sec = 1 if psitype == "H" | psitype == "J"
	replace sec = . if psitype == ""

	gen drug = spdgrp == "X6" | spd == "JKK" if spd ~= ""
	replace drug = . if sep_inv2 == .

	gen dr_on = spd == "JKK" | spd == "JPC" if spd ~= ""
	replace dr_on = . if sep_inv2 == .

	gen econ = spd == "JBM" | spd == "LBM" if spd ~= ""
	replace econ = . if sep_inv2 == .

	gen mis_cm = spdgrp == "KA" | spdgrp == "JC" | spdgrp == "FS"
	replace mis_cm = . if spd == "" | sep_inv2 == .

	local cluster state_combo

*********************************************************************
***** Table 3 Panel B & Appendix TABLE 7 Panel B Regressions ********
**********************************************************************
	foreach var in sep_inv2 revoked dr_on drug mis_cm econ {

	xi: qui areg `var' frac_pdl `demo_controls' fr_* if time_in > 180 & everabroad == 0 , absorb(exper_mos_year_fe) cluster(`cluster')
	eststo `var'_180_1_fr: xi:  areg `var' frac_pdl  if e(sample) == 1, robust absorb(exper_mos_year_fe) cluster(`cluster')
	eststo `var'_180_2_fr: xi:  areg `var' frac_pdl fr_*  if e(sample) == 1, robust absorb(exper_mos_year_fe) cluster(`cluster')
	eststo `var'_180_3_fr: xi:  areg `var' frac_pdl  fr_*  `demo_controls'  if e(sample) == 1, robust absorb(exper_mos_year_fe) cluster(`cluster')
	estadd ysumm


	xi: qui areg `var' frac_pdl `demo_controls' fr_*  if time_in > 365 & everabroad == 0 , absorb(exper_mos_year_fe) cluster(`cluster')
	eststo `var'_365_1_fr: xi:  areg `var' frac_pdl  if e(sample) == 1, robust absorb(exper_mos_year_fe) cluster(`cluster')
	eststo `var'_365_2_fr: xi:  areg `var' frac_pdl fr_*  if e(sample) == 1, robust absorb(exper_mos_year_fe) cluster(`cluster')
	eststo `var'_365_3_fr: xi:  areg `var' frac_pdl `demo_controls' fr_*   if e(sample) == 1, robust absorb(exper_mos_year_fe) cluster(`cluster')
	estadd ysumm 

	esttab using $outsheet/`var'.csv, se(3) b(a2) r2(4) ar2(4) star(* 0.1 ** 0.05 *** 0.01) stats(N r2 ymean ysd) mtitles replace keep(frac_pdl)
	eststo clear
	}

	foreach var in  revoked  {

	xi: qui areg `var' frac_pdl `demo_controls' fr_* if time_in > 180 & everabroad == 0 & year(trandt_s) < 2001, absorb(exper_mos_year_fe) cluster(`cluster')
	eststo `var'_180_1_fr: xi:  areg `var' frac_pdl  if e(sample) == 1, robust absorb(exper_mos_year_fe) cluster(`cluster')
	eststo `var'_180_2_fr: xi:  areg `var' frac_pdl fr_*  if e(sample) == 1, robust absorb(exper_mos_year_fe) cluster(`cluster')
	eststo `var'_180_3_fr: xi:  areg `var' frac_pdl  fr_*  `demo_controls'  if e(sample) == 1, robust absorb(exper_mos_year_fe) cluster(`cluster')
	estadd ysumm


	xi: qui areg `var' frac_pdl `demo_controls' fr_*  if time_in > 365 & everabroad == 0 & year(trandt_s) < 2001, absorb(exper_mos_year_fe) cluster(`cluster')
	eststo `var'_365_1_fr: xi:  areg `var' frac_pdl  if e(sample) == 1, robust absorb(exper_mos_year_fe) cluster(`cluster')
	eststo `var'_365_2_fr: xi:  areg `var' frac_pdl fr_*  if e(sample) == 1, robust absorb(exper_mos_year_fe) cluster(`cluster')
	eststo `var'_365_3_fr: xi:  areg `var' frac_pdl `demo_controls' fr_*   if e(sample) == 1, robust absorb(exper_mos_year_fe) cluster(`cluster')
	estadd ysumm 

	esttab using $outsheet/`var'.csv, se(3) b(a2) r2(4) ar2(4) star(* 0.1 ** 0.05 *** 0.01) stats(N r2 ymean ysd) mtitles replace keep(frac_pdl)
	eststo clear
	}


**************************************
*** APPENDIX TABLE 9 PANEL A
**************************************
	bys paygr pmos year stanam: egen cell = mean(sep_inv2) if sep_inv2 ~= .

	bys pmos minyear: gen exper_mos_year_flag2=1 if _n==1
	replace exper_mos_year_flag2=0 if exper_mos_year_flag2==.
	gen exper_mos_year_fe2=sum(exper_mos_year_flag2)
	drop exper_mos_year_flag2

	gen temp_etsdt_s = dofc(etsdt_s)
	drop etsdt_s
	ren temp_etsdt_s etsdt_s
	format etsdt_s %td

	gen lastyr = (abs(etsdt_s - trandt_s) <= 365)


	gen fileyr = minyear
	sort fileyr pmos
	merge m:1 fileyr pmos using /cifs/research_projects/pay_day_loan/branch-by-year-technical.dta, gen(merge_tech)

/* CZ replication exercise */
	xi: qui areg sep_inv2 frac_pdl `demo_controls' fr_*  if time_in > 365 & everabroad == 0 , absorb(exper_mos_year_fe) cluster(`cluster')
	dis "total moves"
	tab totmove if e(sample) == 1
	eststo `var'_365_1_fr: xi:  areg sep_inv2 frac_pdl `demo_controls' fr_*  if e(sample) == 1, robust absorb(exper_mos_year_fe) cluster(`cluster')
	xi: qui areg sep_inv2 frac_pdl `demo_controls' fr_*  if time_in > 365 & everabroad == 0 , absorb(exper_mos_year_fe) cluster(`cluster')
	eststo `var'_365_1_un: xi:  areg sep_inv2 frac_pdl `demo_controls' fr_* avg_unemp if e(sample) == 1, robust absorb(exper_mos_year_fe) cluster(`cluster')
	xi: qui areg sep_inv2 frac_pdl `demo_controls' fr_*  if time_in > 365 & everabroad == 0 , absorb(exper_mos_year_fe) cluster(`cluster')
	eststo `var'_365_1_yr01: xi:  areg sep_inv2 frac_pdl `demo_controls' fr_*   if e(sample) == 1 & year(trandt_s) <= 2001, robust absorb(exper_mos_year_fe2) cluster(`cluster')
	xi: qui areg sep_inv2 frac_pdl `demo_controls' fr_*  if time_in > 365 & everabroad == 0 , absorb(exper_mos_year_fe) cluster(`cluster')
	eststo `var'_365_1_states: xi:  areg sep_inv2 frac_pdl `demo_controls' fr_*   if e(sample) == 1 & cz_states_always == 1, robust absorb(exper_mos_year_fe2) cluster(`cluster')
	xi: qui areg sep_inv2 frac_pdl `demo_controls' fr_*  if time_in > 365 & everabroad == 0 , absorb(exper_mos_year_fe) cluster(`cluster')
	eststo `var'_365_1_lastyr: xi:  areg sep_inv2 frac_pdl `demo_controls' fr_*   if e(sample) == 1 & lastyr == 1, robust absorb(exper_mos_year_fe2) cluster(`cluster')
	xi: qui areg sep_inv2 frac_pdl `demo_controls' fr_*  if time_in > 365 & everabroad == 0 , absorb(exper_mos_year_fe) cluster(`cluster')
	eststo `var'_365_1_jy: xi:  areg sep_inv2 frac_pdl `demo_controls' fr_*  if e(sample) == 1, robust absorb(exper_mos_year_fe2) cluster(`cluster')
	xi: qui areg sep_inv2 frac_pdl `demo_controls' fr_*  if time_in > 365 & everabroad == 0 , absorb(exper_mos_year_fe) cluster(`cluster')
	eststo `var'_365_1_tech: xi:  areg sep_inv2 frac_pdl `demo_controls' fr_*  if e(sample) == 1 & tech == 1, robust absorb(exper_mos_year_fe) cluster(`cluster')
	xi: qui areg sep_inv2 frac_pdl `demo_controls' fr_*  if time_in > 365 & everabroad == 0 , absorb(exper_mos_year_fe) cluster(`cluster')
	eststo `var'_365_1_cell: xi:  areg cell frac_pdl `demo_controls' fr_*  if e(sample) == 1, robust absorb(exper_mos_year_fe) cluster(`cluster')
	xi: qui areg sep_inv2 frac_pdl `demo_controls' fr_*  if time_in > 365 & everabroad == 0 , absorb(exper_mos_year_fe) cluster(`cluster')
	eststo `var'_365_1_all: xi:  areg cell frac_pdl `demo_controls' fr_* avg_unemp  if e(sample) == 1 & lastyr == 1 & cz_states == 1 & year(trandt_s) <= 2001 & tech == 1, robust absorb(exper_mos_year_fe2) cluster(`cluster')

	esttab using $outsheet/frac_cz_rep.csv, se(3) b(a2) r2(4) ar2(4) star(* 0.1 ** 0.05 *** 0.01) stats(N r2 ymean ysd) mtitles replace keep(frac_pdl)
	eststo clear

*** IV Tables (footnoted)
	local base i.exper_mos_year_fe
	local demo_controls female nonwhite nrdep ged hsg asc_smc college_pl afqsc married divorced age age_sq 

	foreach var in sep_inv2 {
	eststo: xi: ivregress 2sls `var' `demo_controls' i.exper_mos_year_fe (mi_si = pi_ci), robust first cluster(state_combo)
	}

	foreach var in sep_inv2 {
	eststo: xi: ivregress 2sls `var' `demo_controls' i.exper_mos_year_fe (mi_si = pi2_ci2), robust first cluster(state_combo)
	}
	esttab using $outsheet/iv.csv, se(3) b(a2) r2(4) ar2(4) star(* 0.1 ** 0.05 *** 0.01) stats(N r2 ymean ysd) mtitles replace


	eststo clear
	
*** CHECK: using the expected months as the denominator (footnoted)
	foreach var in sep_inv2 revoked {
	xi: qui areg `var' frac_expected `demo_controls' fr_*  if time_in > 365 & everabroad == 0 , absorb(exper_mos_year_fe) cluster(`cluster')
	eststo `var'_365_2_fr: xi:  areg `var' frac_expected fr_*  if e(sample) == 1, robust absorb(exper_mos_year_fe) cluster(`cluster')
	eststo `var'_365_3_fr: xi:  areg `var' frac_expected `demo_controls' fr_*   if e(sample) == 1, robust absorb(exper_mos_year_fe) cluster(`cluster')
	estadd ysumm 
	}
	esttab using $outsheet/frac_expected.csv, se(3) b(a2) r2(4) ar2(4) star(* 0.1 ** 0.05 *** 0.01) stats(N r2 ymean ysd) mtitles replace keep(frac_expected)

*** CHECK: clustering at the state level with the most observations (footnoted)
	eststo clear
	foreach var in sep_inv2 revoked {
	xi: qui areg `var' frac_pdl `demo_controls' fr_*  if time_in > 365 & everabroad == 0 , absorb(exper_mos_year_fe) cluster(statemax)
	eststo `var'_365_2_fr: xi:  areg `var' frac_pdl fr_*  if e(sample) == 1, robust absorb(exper_mos_year_fe) cluster(statemax)
	eststo `var'_365_3_fr: xi:  areg `var' frac_pdl `demo_controls' fr_*   if e(sample) == 1, robust absorb(exper_mos_year_fe) cluster(statemax)
	estadd ysumm 
	}
	esttab using $outsheet/cluster_state_max.csv, se(3) b(a2) r2(4) ar2(4) star(* 0.1 ** 0.05 *** 0.01) stats(N r2 ymean ysd) mtitles replace keep(frac_pdl)
	eststo clear

	histogram frac_pdl
	graph export $outsheet/frac_pdl.ps, replace

	gen male = female == 0
	summ afqsc, d
	gen single = marst == "S"
	gen AFQT_q1 = (afqsc < r(p25))
	gen AFQT_q2 = (afqsc >= r(p25) & afqsc < r(p50))
	gen AFQT_q3 = (afqsc >= r(p50) & afqsc < r(p75))
	gen AFQT_q4 = (afqsc >= r(p75))
	gen not_married = married == 0
	gen lesshsg = (hsd == 1 | ged == 1)
	gen greathsg = (cived_cat == "College_Pl" | cived_cat == "ASC_SMC")
	gen nodep = nrdep == 0
	gen dep1 = nrdep == 1
	gen dep2 = nrdep > 1
	gen nm_dp = (single == 1 & nrdep > 0) | (divorced == 1 & nrdep > 0)
	gen s_aq12 = (single == 1) & (AFQT_q1 == 1 | AFQT_q2 == 1)
	gen marr_aq12 = (married == 1) & (AFQT_q1 == 1 | AFQT_q2 == 1)
	*gen not_deployed = hfpdur == 0
	gen smc = cived_cat == "ASC_SMC" if cived_cat ~= ""
	gen collegepl = cived_cat == "College_Pl" if cived_cat ~= ""
	gen onpost_single = junior == 1 & single == 1
*************************
****** Table 2 *******
*************************
	dis "Summary Statistics"
	xi: qui areg sep_inv2 frac_pdl `demo_controls' `base' if time_in > 180 & everabroad == 0, absorb(exper_mos_year_fe)
	summ sep_inv2 frac_pdl female afqsc nonwhite nrdep ged hsd hsg smc collegepl married divorced age if e(sample) == 1 
	summ revoked sec if e(sample) == 1
	histogram frac_pdl if e(sample) == 1, frac xtitle("Fraction of Time in Payday Loan State") title("More than 180 Days in Army")
	graph export $figdir/frac_pdl_180.ps, replace
	xi: qui areg sep_inv2 frac_pdl `demo_controls' `base' if time_in > 365 & everabroad == 0, absorb(exper_mos_year_fe)
	summ sep_inv2 frac_pdl female afqsc nonwhite nrdep ged hsd hsg smc collegepl married divorced age if e(sample) == 1 
	summ revoked sec if e(sample) == 1 
	histogram frac_pdl if e(sample) == 1, frac xtitle("Fraction of Time in Payday Loan State") title("More than 365 Days in Army")
	graph export $figdir/frac_pdl_365.ps, replace

*****************************************************
******SubSample Analysis for APPENDIX TABLE 5 *******
*****************************************************

	foreach var in  sep_inv2 revoked sec drug mis_cm   {
	foreach group in married single divorced nm_dp s_aq12  white black female male AFQT_q1 AFQT_q2 AFQT_q3 AFQT_q4 lesshsg greathsg op_single hsg {
	xi: qui areg `var' frac_pdl `demo_controls'  if time_in > 90 & `group' == 1, absorb(exper_mos_year_fe) cluster(`cluster')
	eststo `var'_90_1_`group': xi: areg `var' frac_pdl  if e(sample) == 1, robust absorb(exper_mos_year_fe) cluster(`cluster')
	eststo `var'_90_2_`group': xi: areg `var' frac_pdl `demo_controls'  if e(sample) == 1, robust absorb(exper_mos_year_fe) cluster(`cluster')
	estadd ysumm 

	xi: qui areg `var' frac_pdl `demo_controls'  if time_in > 180 & `group' == 1, absorb(exper_mos_year_fe) cluster(`cluster')
	eststo `var'_180_1_`group': xi: areg `var' frac_pdl  if e(sample) == 1, robust absorb(exper_mos_year_fe) cluster(`cluster')
	eststo `var'_180_2_`group': xi: areg `var' frac_pdl `demo_controls'  if e(sample) == 1, robust absorb(exper_mos_year_fe) cluster(`cluster')
	estadd ysumm 

	xi: qui areg `var' frac_pdl `demo_controls'  if time_in > 365 & `group' == 1, absorb(exper_mos_year_fe) cluster(`cluster')
	eststo `var'_365_1_`group': xi: areg `var' frac_pdl  if e(sample) == 1, robust absorb(exper_mos_year_fe) cluster(`cluster')
	eststo `var'_365_2_`group': xi: areg `var' frac_pdl `demo_controls'  if e(sample) == 1, robust absorb(exper_mos_year_fe) cluster(`cluster')
	estadd ysumm 

	xi: qui areg `var' frac_pdl `demo_controls'  if time_in > 547 & `group' == 1, absorb(exper_mos_year_fe) cluster(`cluster')
	eststo `var'_547_1_`group': xi: areg `var' frac_pdl  if e(sample) == 1, robust absorb(exper_mos_year_fe) cluster(`cluster')
	eststo `var'_547_2_`group': xi: areg `var' frac_pdl `demo_controls'  if e(sample) == 1, robust absorb(exper_mos_year_fe) cluster(`cluster')
	estadd ysumm 

	xi: qui areg `var' frac_pdl `demo_controls' fr_* if time_in > 90 & everabroad == 0 & `group' == 1, absorb(exper_mos_year_fe) cluster(`cluster')
	eststo `var'_90_1_na_`group': xi: areg `var' frac_pdl fr_* if e(sample) == 1, robust absorb(exper_mos_year_fe) cluster(`cluster')
	eststo `var'_90_2_na_`group': xi: areg `var' frac_pdl `demo_controls' fr_* if e(sample) == 1, robust absorb(exper_mos_year_fe) cluster(`cluster')
	estadd ysumm 

	xi: qui areg `var' frac_pdl `demo_controls' fr_* if time_in > 180 & everabroad == 0 & `group' == 1, absorb(exper_mos_year_fe) cluster(`cluster')
	eststo `var'_180_1_na_`group': xi: areg `var' frac_pdl fr_* if e(sample) == 1, robust absorb(exper_mos_year_fe) cluster(`cluster')
	eststo `var'_180_2_na_`group': xi: areg `var' frac_pdl `demo_controls' fr_* if e(sample) == 1, robust absorb(exper_mos_year_fe) cluster(`cluster')
	estadd ysumm 

	xi: qui areg `var' frac_pdl `demo_controls' fr_* if time_in > 365 & everabroad == 0 & `group' == 1, absorb(exper_mos_year_fe) cluster(`cluster')
	eststo `var'_365_1_na_`group': xi: areg `var' frac_pdl fr_* if e(sample) == 1, robust absorb(exper_mos_year_fe) cluster(`cluster')
	eststo `var'_365_2_na_`group': xi: areg `var' frac_pdl `demo_controls' fr_* if e(sample) == 1, robust absorb(exper_mos_year_fe) cluster(`cluster')
	estadd ysumm 

	xi: qui areg `var' frac_pdl `demo_controls' fr_* if time_in > 547 & everabroad == 0 & `group' == 1, absorb(exper_mos_year_fe) cluster(`cluster')
	eststo `var'_547_1_na_`group': xi: areg `var' frac_pdl fr_* if e(sample) == 1, robust absorb(exper_mos_year_fe) cluster(`cluster')
	eststo `var'_547_2_na_`group': xi: areg `var' frac_pdl `demo_controls' fr_* if e(sample) == 1, robust absorb(exper_mos_year_fe) cluster(`cluster')
	estadd ysumm 


	esttab using $outsheet/`var'_`group'.csv, se(3) b(a2) r2(4) ar2(4) star(* 0.1 ** 0.05 *** 0.01) stats(N r2 ymean ysd) mtitles replace
	eststo clear
	}
	}

}
	

if `cz_replication' {
***** CREATING THE CZ REPLICATION EXERCISE *********
** This dta file includes an observation for everyone in January for the years 1996 to 2005.  It also includes information on the reason why someone eventually left, as well as ineligiblity information.  

use $datadir/cz_replication_exercise

*** Who is in last year of contract:
	gen lastyear = etsdt_s - filedt_s <= 365 & etsdt_s - filedt_s > 0

*** Creating age and base pay variables
	gen age = (filedt_s - dob_s)/365
	gen age_sq = age^2

	gen tempx = baspay/1000
	replace baspay = tempx
	drop tempx

*** Counting someone as in their first term if their last assignment was before their startdate 
	gen enlistmentdate = datla_s
	gen first_term = abs(enlistmentdate - startdate) < 30  

*** Dropping anyone with certain SPD codes (ex: death)
	drop if spd == "938" | spd == "941" | spd == "942" | spd == "943" | spd == "944" | spd == "945" | spd == "946" | spd == "947" | spd == "948" ///
	| spd == "949" | spd == "950"

	drop if (spd_old == "938" | spd_old== "941" | spd_old== "942" | spd_old == "943" | spd_old == "944" |spd_old == "945" | spd_old == "946" | spd_old == "947" | spd_old == "948" ///
	| spd_old == "949" | spd_old == "950") & merge_gle == 2	
	
/** Creating SPD Groupings -- Reasons why people left **/
	/*
	XX = Not Categorized (Else Condition)
	BM = Insufficient Retainability (Economic Reasons) 
	CC = Reduction in Force 
	CR = Weight Control Failure 
	CQ = Surviving Family Member 
	DB = Hardship 
	DF = Pregnancy or Childbirth   
	FF = Secretarial Authority 
	FX = Personality Disorder 
	GA = Entry Level Performance and Conduct 
	HC = Immediate Reenlistment 
	HJ = Unsatisfactory Performance 
	BD = Retirement (BC,BD,BE) 
	BK = Completed AFS (BK,GF) 
	CA = Early Release (CA,CB) 
	DG = Parenthood (DG,DH) 
	KA = Misconduct (KA,KB,KC,KD,KF,KK,KM,KN,KQ) 
	GH = Non-Retention or Non-Selection for Promotion (GH,GB,GC) 
	RA = Homosexual(RA,RB,RC)
	X7 = Disability (FJ,FK,FL,FM,FN,FP,FQ,FR) 
	FV = Physical Condition (FT,FV,FW)
	X1 = Holiday Early Release or To Attend School (DM,CF)
	X2 = Death (44,45,46)
	X3 = DFR (41,42,50,85)
	X4 = Defective Enlistment (47,79,74,DA,DS,FC)
	X5 = Commission or Interdepartment Transfer (48,GL,GM,GN,GQ,GX)
	X6 = Drug or Alcohol (PC,PD)
	JC = Court Martial (JC,JD)
	FS = In Leiu of Court Martial or Lack of Jurisdiction (DN,FS)
	X8 = Other (CM,ND)
	*/
	
	gen spdgrp="XX"
	replace spdgrp=substr(spd,2,2) if substr(spd,2,2)=="BM" | substr(spd,2,2)=="CR" | substr(spd,2,2)=="CC" | substr(spd,2,2)=="CR" | substr(spd,2,2)=="CQ" | substr(spd,2,2)=="DB" | substr(spd,2,2)=="DF" | substr(spd,2,2)=="FF" | substr(spd,2,2)=="FX" | substr(spd,2,2)=="GA" | substr(spd,2,2)=="HC" | substr(spd,2,2)=="HJ"
	/* Retirement */
	replace spdgrp="BD" if substr(spd,2,2)=="BC" | substr(spd,2,2)=="BD" | substr(spd,2,2)=="BE"
	/* Completed AFS */
	replace spdgrp="BK" if substr(spd,2,2)=="BK" | substr(spd,2,2)=="GF"
	/* Early Release */
	replace spdgrp="CA" if substr(spd,2,2)=="CA" | substr(spd,2,2)=="CB"
	/* Parenthood */
	replace spdgrp="DG" if substr(spd,2,2)=="DG" | substr(spd,2,2)=="DH"
	/* Misconduct */
	replace spdgrp="KA" if substr(spd,2,2)=="KA" | substr(spd,2,2)=="KB" | substr(spd,2,2)=="KC" | substr(spd,2,2)=="KD" | substr(spd,2,2)=="KF" | substr(spd,2,2)=="KK" | substr(spd,2,2)=="KM" | substr(spd,2,2)=="KN" | substr(spd,2,2)=="KQ"
	/* Non-Retention or Non-Selection for Promotion */ replace spdgrp="GH" if substr(spd,2,2)=="GH" | substr(spd,2,2)=="GB"  | substr(spd,2,2)=="GC"
	/* Homosexual */
	replace spdgrp="RA" if substr(spd,2,2)=="RA" | substr(spd,2,2)=="RB" | substr(spd,2,2)=="RC"
	/* Disability */
	replace spdgrp="X7" if substr(spd,2,2)=="FJ" | substr(spd,2,2)=="FK" | substr(spd,2,2)=="FL" | substr(spd,2,2)=="FM" | substr(spd,2,2)=="FN" | substr(spd,2,2)=="FP" | substr(spd,2,2)=="FQ" | substr(spd,2,2)=="FR"
	/* Physical Condition */
	replace spdgrp="FV" if substr(spd,2,2)=="FT" | substr(spd,2,2)=="FV" | substr(spd,2,2)=="FW"
	/* Holiday Early Release or To Attend School */ replace spdgrp="X1" if substr(spd,2,2)=="DM" | substr(spd,2,2)=="CF"
	/* Death */
	replace spdgrp="X2" if substr(spd,2,2)=="44" | substr(spd,2,2)=="45" | substr(spd,2,2)=="46"
	/* DFR */
	replace spdgrp="X3" if substr(spd,2,2)=="41" | substr(spd,2,2)=="42" | substr(spd,2,2)=="50" | substr(spd,2,2)=="85"
	/* Defective Enlistment */
	replace spdgrp="X4" if substr(spd,2,2)=="47" | substr(spd,2,2)=="79" | substr(spd,2,2)=="74" | substr(spd,2,2)=="DA" | substr(spd,2,2)=="DS" | substr(spd,2,2)=="FC"
	/* Commission or Interdepartment Transfer */ replace spdgrp="X5" if substr(spd,2,2)=="48" | substr(spd,2,2)=="GL" | substr(spd,2,2)=="GM" | substr(spd,2,2)=="GN"| substr(spd,2,2)=="GQ" | substr(spd,2,2)=="GX"
	/* Drug / Alcohol */
	replace spdgrp="X6" if substr(spd,2,2)=="PC" | substr(spd,2,2)=="PD"
	/* Court Martial */
	replace spdgrp="JC" if substr(spd,2,2)=="JC" | substr(spd,2,2)=="JD"
	/* In Leiu of Court Martial or Lack of Jurisdiction */ replace spdgrp="FS" if substr(spd,2,2)=="DN" | substr(spd,2,2)=="FS"
	/* Other */
	replace spdgrp="X8" if substr(spd,2,2)=="CM" | substr(spd,2,2)=="ND" 
	replace spdgrp="" if trandt_s==.
	tab spdgrp

	
*** Creating a Separte Involuntary Group if in first term (for last observation in first term)
	bys id first_term: egen maxfile_first = max(filedt_s)
	replace maxfile_first = . if first_term ~= 1
	gen first_sep_inv =(spdgrp == "BM" | spdgrp == "X4" | spdgrp == "X6" | spdgrp == "JC" | spdgrp == "FS" | spdgrp == "X3" | spdgrp =="CR" | spdgrp =="GA" | spdgrp =="HJ" | spdgrp == "KA" | spdgrp == "GH" | spdgrp == "FV" |spd == "JBK" | spd == "LBK") 
	replace first_sep_inv = . if filedt_s ~= maxfile_first
	replace first_sep_inv = . if (year(etsdt_s) > 2001 | (year(etsdt_s) == 2001 & month(etsdt_s) > 9))
	
*** Merging in state information
	sort arloc
	merge arloc using $arlocdir/arloc
	tab _merge

	tab state

*** Ft. Benning is on the Border to Alabama, so we count it has having access to payday loans.
	replace state = "AL" if state == "GA" & (stanam == "FT BENNING")	
	
*** Carroll and Zinman: If allowed payday loans for more than 1/2 of the fiscal year, then count as having pdl access.
	gen treatment = 1 if state == "TX" & filedt_s >= td(01oct2000) /*filedt_s >= td(16jun2000*/
	replace treatment = 0 if state == "TX" & filedt_s < td(01oct2000) /* filedt_s < td(16jun2000)*/
	replace treatment = 1 if state == "KS"
	replace treatment = 0 if state == "GA"
	replace treatment = 0 if state == "AL" & filedt_s < td(01oct1998) /*filedt_s < td(01feb1999)*/ /*td(9oct1998)*/
	replace treatment = 1 if state == "AL" & filedt_s >= td(01oct1998) /*filedt_s >= td(01feb1999)*/ /*td(9oct1998)*/
	replace treatment = 0 if state == "NC" & filedt_s < td(1oct1997)
	replace treatment = 1 if state == "NC" & filedt_s >= td(1oct1997) & filedt_s < td(01oct2001) /*td(31aug2001)*/
	replace treatment = 0 if state == "NC" & filedt_s >= td(01oct2001) /*td(31aug2001) */
	replace treatment = 1 if state == "WA"
	replace treatment = 1 if state == "CO"
	replace treatment = 0 if state == "AK" & filedt_s < td(01oct2004) /*td(29jun2004)*/
	replace treatment = 1 if state == "AK" & filedt_s >= td(01oct2004)
	replace treatment = 0 if state == "HI" & filedt_s < td(1oct999)
	replace treatment = 1 if state == "HI" & filedt_s >= td(1oct999) /* td(1jul1999)*/
	replace treatment = 1 if state == "LA"
	replace treatment = 0 if state == "AR" & filedt_s < td(01oct1999) /*td(7apr1999) */
	replace treatment = 1 if state == "AR" & filedt_s >= td(01oct1999) & filedt_s <= td(01oct2000) /*td(22mar2001)*/
	replace treatment = 0 if state == "AR" & filedt_s > td(01oct2000) /* td(22mar2001) */
	replace treatment = 0 if state == "AZ" & filedt_s < td(1oct2000) /*td(1sep2000)*/
	replace treatment = 1 if state == "AZ" & filedt_s >= td(1oct2000) /*td(1sep2000)*/
	replace treatment = 0 if state == "CA" & filedt_s < td(1oct1996)  /*td(1jan1997)*/
	replace treatment = 1 if state == "CA" & filedt_s >= td(1oct1996)  /*td(1jan1997)*/
	replace treatment = 0 if state == "DC" & filedt_s < td(1oct1998) /*td(12may1998) */
	replace treatment = 1 if state == "DC" & filedt_s >= td(1oct1998) /*td(12may1998) */
	replace treatment = 1 if state == "DE"
	replace treatment = 1 if state == "FL"
	replace treatment = 1 if state == "ID"
	replace treatment = 1 if state == "IL"
	replace treatment = 0 if state == "MA"
	replace treatment = 0 if state == "MD"
	replace treatment = 1 if state == "MO"
	replace treatment = 0 if state == "MS" & filedt_s < td(1oct1998) /*td(1jul1998)*/
	replace treatment = 1 if state == "MS" & filedt_s >= td(1oct1998) /*td(1jul1998) */
	replace treatment = 1 if state == "MT"
	replace treatment = 1 if state == "ND" & filedt_s < td(1oct1997) /*filedt_s < td(27mar1997) */
	replace treatment = 0 if state == "ND" & filedt_s >= td(1oct1997) & filedt_s < td(1oct2001) /*td(19apr2001)*/
	replace treatment = 1 if state == "ND" & filedt_s >= td(1oct2001)
	replace treatment = 1 if state == "NE"
	replace treatment = 0 if state == "NJ"
	replace treatment = 1 if state == "NM"
	replace treatment = 1 if state == "NV"
	replace treatment = 1 if state == "OH"
	replace treatment = 1 if state == "OK" & filedt_s < td(01oct1997) /*td(1jul1997)*/
	replace treatment = 0 if state == "OK" & filedt_s >= td(01oct1997) & filedt_s < td(1oct2003) /*td(1sep2003)*/
	replace treatment = 1 if state == "OK" & filedt_s >= td(1oct2003) /* td(1sep2003) */
	replace treatment = 0 if state == "SC" & filedt_s < td(1oct1998) /*td(11jun1998)*/
	replace treatment = 1 if state == "SC" & filedt_s >= td(1oct1998) /*td(11jun1998) */
	replace treatment = 1 if state == "SD"
	replace treatment = 1 if state == "UT"
	replace treatment = 0 if state == "VA" & filedt_s < td(1oct2002) /*td(1jul2002) */
	replace treatment = 1 if state == "VA" & filedt_s >= td(1oct2002) /*td(1jul2002) */
	replace treatment = 0 if state == "WY" & filedt_s < td(1oct1996) /*td(1jul1996) */
	replace treatment = 1 if state == "WY" & filedt_s >= td(1oct1996) /*td(1jul1996) */
	replace treatment = 0 if state == "NY"
	replace treatment = 1 if state == "KY"

*** Creating Ineligible for Re-enlistment Variable
	gen ineligible = .
	replace ineligible = 0 if ereupp == "10"
	replace ineligible = 1 if ereupp == "11"
	replace ineligible = 0 if ereupp == "1A"
	replace ineligible = 0 if ereupp == "1B"
	replace ineligible = 0 if ereupp == "1C"
	replace ineligible = 0 if ereupp == "20"
	replace ineligible = 0 if ereupp == "2A"
	replace ineligible = 0 if ereupp == "2B"
	replace ineligible = 0 if ereupp == "2C"
	replace ineligible = 0 if ereupp == "30" /* need a waiver */
	replace ineligible = 0 if ereupp == "3A" /* need a waiver */
	replace ineligible = 0 if ereupp == "3B" /* need a waiver */
	replace ineligible = 0 if ereupp == "3C" /* need a waiver */
	replace ineligible = 0 if ereupp == "3S" /* need a waiver */
	replace ineligible = 0 if ereupp == "3V" /* need a waiver */
	replace ineligible = 1 if ereupp == "40"
	replace ineligible = 1 if ereupp == "4A"
	replace ineligible = 0 if ereupp == "4R" /*retirement */
	replace ineligible = 1 if ereupp == "9A"
	replace ineligible = 1 if ereupp == "9C"
	replace ineligible = 1 if ereupp == "9D"
	replace ineligible = 1 if ereupp == "9E"
	replace ineligible = 1 if ereupp == "9F"
	replace ineligible = 1 if ereupp == "9G"
	replace ineligible = 1 if ereupp == "9H"
	replace ineligible = 1 if ereupp == "9I"
	replace ineligible = 1 if ereupp == "9J"
	replace ineligible = 1 if ereupp == "9K"
	replace ineligible = 1 if ereupp == "9L"
	replace ineligible = 0 if ereupp == "9M" /* retirement */
	replace ineligible = 1 if ereupp == "9N"
	replace ineligible = 0 if ereupp == "9O" /* age */
	replace ineligible = 1 if ereupp == "9P"
	replace ineligible = 1 if ereupp == "9Q"
	replace ineligible = 1 if ereupp == "9R"
	replace ineligible = 1 if ereupp == "9S"
	replace ineligible = 1 if ereupp == "9T"
	replace ineligible = 0 if ereupp == "9U" /* retirement */
	replace ineligible = 1 if ereupp == "9V"
	replace ineligible = 1 if ereupp == "9W"
	replace ineligible = 1 if ereupp == "9X"
	replace ineligible = 0 if ereupp == "9Y" /* retirement */
	replace ineligible = 1 if ereupp == "9Z"

*** Creating a variable for being ineligible for re-enlistment in first term
	bys id first_term: egen maxdate_first = max(filedt_s)
	gen inel_first_temp = ineligible if filedt_s == maxdate_first & first_term == 1 & trandt_s <= td(30sep2001)
	*replace inel_first_temp = 1 if filedt_s == maxdate_first & first_term == 1 & first_sep_inv == 1 & trandt_s <= td(31dec2001)
	gen inel_first = inel_first_temp
	replace inel_first = . if first_term ~= 1
	replace inel_first = . if (year(etsdt_s) > 2001 | (year(etsdt_s) == 2001 & month(etsdt_s) > 9))

	drop inel_first_temp maxdate_first
	
	ren paygr grade
	gen grade_group = "Junior" if grade <= 4
	replace grade_group = "NCO" if grade == 5 | grade == 6
	replace grade_group = "Senior" if grade > 6

	gen junior = grade_group == "Junior"
	gen NCO = grade_group == "NCO"

	gen female = sex == "F" if sex != ""
	gen white = race == "W" if race ~= ""
	gen black = race == "B" if race ~= ""
	gen nonwhite = race ~= "W" if race ~= ""

	gen married = marst == "M" if !missing(marst)
	gen divorced = marst == "D" if !missing(marst)
	gen hsd = civedcatg == "HSD" if !missing(civedcatg)
	gen hsg = civedcatg == "HSG" if !missing(civedcatg)
	gen ged = civedcatg == "GED" if !missing(civedcatg)
	gen asc_smc =  civedcatg == "ASC" | civedcatg == "SMC" if !missing(civedcatg)
	gen college_pl = civedcatg == "CLG" | civedcatg == "GRD" if !missing(civedcatg)

	gen cived_cat = "HSD" if civedcatg == "HSD"
	replace cived_cat = "GED" if civedcatg == "GED"
	replace cived_cat = "HSG" if civedcatg == "HSG"
	replace cived_cat = "ASC_SMC" if civedcatg == "ASC" | civedcatg == "SMC"
	replace cived_cat = "College_Pl" if civedcatg == "CLG" | civedcatg == "GRD"
	
	replace stanam = "FT BENNING" if stanam == "FT BENNIN"
	replace stanam =  "FT RICHARDSON" if stanam == "FT RICHAR"
	replace stanam =  "FT STEWART" if stanam == "FT STEWAR"
	replace stanam =  "FT WAINWRIGHT" if stanam == "FT WAINWR"
	replace stanam =  "HUNTER AAF" if stanam == "HUNTER AA"
	replace stanam =  "SCHOFIELD BRKS" if stanam == "SCHOFIELD"
	replace stanam =  "WHEELER AAF" if stanam == "WHEELER AA"
	replace stanam =  "WHEELER AAF" if stanam == "WHEELER A"
	replace stanam =  "FT MCPHERSON" if stanam == "FT MCPHER"

*** Correcting some of the station names
	sort stanam
	drop _merge
	merge m:1 stanam using $datadir/stanam
	replace stanam = newstanam if newstanam ~= ""
	drop newstanam
	drop _merge

*** Keeping only people in the U.S. 
	keep if conus == 1 | state == "HI" | state == "AK"

*** Merging in Housing Pay and unemployment info
	gen calendaryear = year(filedt_s)
	sort stanam calendaryear
	merge stanam calendaryear using $datadir/final_hp-ue_all.dta
	drop hp
	ren _merge merge_ue
	gen oldue = ue
	
	sort stanam year
	merge stanam year using $datadir/final_hp_all.dta
	drop ue
	ren oldue ue
	tab _merge
	ren _merge merge_hp

	drop if merge_hp == 2
	
*** Following CZ, just looking at observations between 1996 and 2001
	drop if year < 1996 | year > 2001

*** Keeping only locations that had at least 50 observations
	bys stanam: gen nbr_stanam = _N
	keep if nbr_stanam > 50
	
*** Creating job x rank x year fixed effects
	bys grade pmos year: gen exper_mos_year_flag=1 if _n==1
	replace exper_mos_year_flag=0 if exper_mos_year_flag==.
	gen exper_mos_year_fe=sum(exper_mos_year_flag)
	drop exper_mos_year_flag

*** Creating job x term x year fixed effects
	gen yos = (filedt_s - startdate)/365
	gen term = "less_4" if yos >0 & yos <= 4
	replace term = "y_4_10" if yos > 4 & yos <= 10
	replace term = "y_10_plus" if yos >10 & yos ~= .
	bys term pmos year: gen exper_mos_year_flag2=1 if _n==1
	replace exper_mos_year_flag2=0 if exper_mos_year_flag2==.
	gen exper_mos_year_fe2=sum(exper_mos_year_flag2)
	drop exper_mos_year_flag2

*** Locals for regression analysis
	local demo_controls female nonwhite nrdep ged hsg asc_smc college_pl afqsc married divorced age age_sq 
	local financial_controls baspay hfpdur


*** Running Regressions
	eststo clear
	
**********************************
***** Appendix Table 9 Panel B ***
**********************************

	foreach var in first_sep_inv inel_first  {
	*** Regression with jobxrankxyear fixed effects, clustering at state level, including only the last year of contract
		eststo `var'_lastyr_jry: xi: qui areg  `var' treatment  hfpdur baspay `demo_controls' `financial_controls' ue hp i.stanam if lastyear == 1, absorb(exper_mos_year_fe) cluster(state) robust
		estadd ysumm
	*** Regression with jobxtermxyear fixed effects, clustering at state level, including only the last year of contract
		eststo `var'_lastyr_jty: xi: qui areg  `var' treatment  hfpdur baspay `demo_controls' `financial_controls' ue hp i.stanam if lastyear == 1, absorb(exper_mos_year_fe2) cluster(state) robust
		estadd ysumm
	*** Regression with jobxrankxyear fixed effects, clustering at state level, including all last observations in first-term
		eststo `var'_jry: xi: qui areg  `var' treatment  hfpdur baspay `demo_controls' `financial_controls' ue hp i.stanam, absorb(exper_mos_year_fe) cluster(state) robust
		estadd ysumm
	*** Regression with jobxtermxyear fixed effects, clustering at state level, including all last observations in first-term
		eststo `var'_jty: xi: qui areg  `var' treatment  hfpdur baspay `demo_controls' `financial_controls' ue hp i.stanam, absorb(exper_mos_year_fe2) cluster(state) robust
		estadd ysumm
		}
	esttab using $outsheet/cz_replication_exercise.csv, se(3) b(a2) r2(4)  stats(N r2 ymean ysd) star(* 0.1 ** 0.05 *** 0.01) mtitles replace


}
