* do file for regression estimation for REStat Article in Vol 95(1).

* Mario Jametti, August 2013

clear
capture program drop estimation_1001
program define estimation_1001
* version 9.0
version 10.0

* "\\lhs3\paws\MarioJametti\linked"

set more off
set mem 200m
set logtype text

* Estimation at the plan level

log using "results\estimation_plan_1001_nc.log", replace

use "final\db_plan.dta", replace

*adjust dataset to sample size

drop if m_share_equity==.
drop if jurisdict==70

* generate and rescale variables

* generat safe vs. risky assets

gen m_tot_safe = m_tot_bd + m_tot_secure + m_tot_short + m_poolmony
gen m_tot_risk = m_tot_asset_alt - m_tot_safe
gen m_share_safe = m_tot_safe / m_tot_asset_alt 
gen m_share_risk = 1 - m_share_safe

gen age = (year - effect_date)/100
gen age_sq = age^2
gen share_retired = retired / (employed + retired)
replace contrib= contrib - 1
replace m_tot_asset_alt = m_tot_asset_alt / 1000000
gen asset_memb = m_tot_asset_alt / memb_tot
replace r_wage = r_wage / 1000
gen quebec=0
replace quebec=1 if jurisdict==24
gen east=0 if jurisdict~=35
replace east=1 if jurisdict<35
gen west=0 if jurisdict~=35
replace west=1 if jurisdict>35

* generate logs, squares, cubes and interactions of continuous variables for balancing test

gen l_tot_asset = ln(m_tot_asset_alt)
gen l_memb = ln(memb_tot)
gen l_asset_memb = ln(asset_memb)

gen tot_asset_sq = m_tot_asset_alt^2
gen memb_sq = memb_tot^2
gen l_tot_asset_sq = l_tot_asset^2
gen l_memb_sq = l_memb^2

gen tot_asset_cub = m_tot_asset_alt^3
gen memb_cub = memb_tot^3
gen l_tot_asset_cub = l_tot_asset^3
gen l_memb_cub = l_memb^3

gen assetXmemb = m_tot_asset_alt*memb_tot
gen assetXsh_ret = m_tot_asset_alt*share_retired
gen membXsh_ret = memb_tot*share_retired
gen l_assetXl_memb = l_tot_asset*l_memb
gen l_assetXsh_ret = l_tot_asset*share_retired
gen l_membXsh_ret = l_memb*share_retired

display "summary statistics Table 1"
display ""

sum m_share_equity m_share_bd ins m_tot_asset_alt memb_tot share_retired master_alt /*
*/ growth inflation emp_rate if memb_tot>0

sum m_share_equity m_share_bd ins m_tot_asset_alt memb_tot share_retired master_alt /*
*/ growth inflation emp_rate if ins==0 & memb_tot>0

sum m_share_equity m_share_bd ins m_tot_asset_alt memb_tot share_retired master_alt /*
*/ growth inflation emp_rate if ins==1 & memb_tot>0

display "Raw differences"
display ""

bys ins: sum m_share_equity m_share_bd
bys quebec: sum m_share_equity m_share_bd

display "base specification on controls"
display ""

xi: reg m_share_equity ins l_tot_asset l_tot_asset_sq l_tot_asset_cub l_memb l_memb_sq l_memb_cub l_assetXl_memb share_retired l_assetXsh_ret /*
*/ master_alt i.year if ins==0, cluster(jurisdict)
estimates store spec_equity_1
ovtest

xi: reg m_share_bd ins l_tot_asset l_tot_asset_sq l_tot_asset_cub l_memb l_memb_sq l_memb_cub l_assetXl_memb share_retired l_assetXsh_ret /*
*/ master_alt i.year if ins==0, cluster(jurisdict)
estimates store spec_bd_1
ovtest

display "base regressions - clustered"
display ""

xi: reg m_share_equity ins l_tot_asset l_tot_asset_sq l_tot_asset_cub l_memb l_memb_sq l_memb_cub l_assetXl_memb share_retired l_assetXsh_ret /*
*/ master_alt i.year, cluster(jurisdict)
estimates store base_equity_1
ovtest

xi: reg m_share_equity ins l_tot_asset l_tot_asset_sq l_tot_asset_cub l_memb l_memb_sq l_memb_cub l_assetXl_memb share_retired l_assetXsh_ret /*
*/ master_alt growth inflation emp_rate i.year, cluster(jurisdict)
estimates store base_equity_2

xi: reg m_share_bd ins l_tot_asset l_tot_asset_sq l_tot_asset_cub l_memb l_memb_sq l_memb_cub l_assetXl_memb share_retired l_assetXsh_ret /*
*/ master_alt i.year, cluster(jurisdict)
estimates store base_bd_1
ovtest

xi: reg m_share_bd ins l_tot_asset l_tot_asset_sq l_tot_asset_cub l_memb l_memb_sq l_memb_cub l_assetXl_memb share_retired l_assetXsh_ret /*
*/ master_alt growth inflation emp_rate i.year, cluster(jurisdict)
estimates store base_bd_2

display "tobit regressions"
display ""

xi: tobit m_share_equity ins l_tot_asset l_tot_asset_sq l_tot_asset_cub l_memb l_memb_sq l_memb_cub l_assetXl_memb share_retired l_assetXsh_ret /*
*/ master_alt i.year, ll vce(cluster jurisdict)
estimates store tobit_equity_1

xi: tobit m_share_equity ins l_tot_asset l_tot_asset_sq l_tot_asset_cub l_memb l_memb_sq l_memb_cub l_assetXl_memb share_retired l_assetXsh_ret /*
*/ master_alt growth inflation emp_rate i.year, ll vce(cluster jurisdict)
estimates store tobit_equity_2

xi: tobit m_share_bd ins l_tot_asset l_tot_asset_sq l_tot_asset_cub l_memb l_memb_sq l_memb_cub l_assetXl_memb share_retired l_assetXsh_ret /*
*/ master_alt i.year, ll vce(cluster jurisdict)
estimates store tobit_bd_1

xi: tobit m_share_bd ins l_tot_asset l_tot_asset_sq l_tot_asset_cub l_memb l_memb_sq l_memb_cub l_assetXl_memb share_retired l_assetXsh_ret /*
*/ master_alt growth inflation emp_rate i.year, ll vce(cluster jurisdict)
estimates store tobit_bd_2

display "drop Quebec - clustered"
display ""

xi: reg m_share_equity ins l_tot_asset l_tot_asset_sq l_tot_asset_cub l_memb l_memb_sq l_memb_cub l_assetXl_memb share_retired l_assetXsh_ret /*
*/ master_alt i.year if quebec==0, cluster(jurisdict)
estimates store base_equity_1que
ovtest

xi: reg m_share_equity ins l_tot_asset l_tot_asset_sq l_tot_asset_cub l_memb l_memb_sq l_memb_cub l_assetXl_memb share_retired l_assetXsh_ret /*
*/ master_alt growth inflation emp_rate i.year if quebec==0, cluster(jurisdict)
estimates store base_equity_2que

xi: reg m_share_bd ins l_tot_asset l_tot_asset_sq l_tot_asset_cub l_memb l_memb_sq l_memb_cub l_assetXl_memb share_retired l_assetXsh_ret /*
*/ master_alt i.year if quebec==0, cluster(jurisdict)
estimates store base_bd_1que
ovtest

xi: reg m_share_bd ins l_tot_asset l_tot_asset_sq l_tot_asset_cub l_memb l_memb_sq l_memb_cub l_assetXl_memb share_retired l_assetXsh_ret /*
*/ master_alt growth inflation emp_rate i.year if quebec==0, cluster(jurisdict)
estimates store base_bd_2que

* step two: propensity score

display "Propensity score - balancing tests"
display ""

capture drop pscore*

xi: pscore ins l_tot_asset l_tot_asset_sq l_tot_asset_cub l_memb l_memb_sq l_memb_cub l_assetXl_memb share_retired l_assetXsh_ret /*
*/ master_alt i.year, pscore(pscore_ind) comsup level(0.0006)

* step three: matching

display "Matching"
display ""

xi: psmatch2 ins l_tot_asset l_tot_asset_sq l_tot_asset_cub l_memb l_memb_sq l_memb_cub l_assetXl_memb share_retired l_assetXsh_ret /*
*/ master_alt i.year, kernel outcome(m_share_equity) common

xi: psmatch2 ins l_tot_asset l_tot_asset_sq l_tot_asset_cub l_memb l_memb_sq l_memb_cub l_assetXl_memb share_retired l_assetXsh_ret /*
*/ master_alt growth inflation emp_rate i.year, kernel outcome(m_share_equity) common

xi: psmatch2 ins l_tot_asset l_tot_asset_sq l_tot_asset_cub l_memb l_memb_sq l_memb_cub l_assetXl_memb share_retired l_assetXsh_ret /*
*/ master_alt i.year, kernel outcome(m_share_bd) common

xi: psmatch2 ins l_tot_asset l_tot_asset_sq l_tot_asset_cub l_memb l_memb_sq l_memb_cub l_assetXl_memb share_retired l_assetXsh_ret /*
*/ master_alt growth inflation emp_rate i.year, kernel outcome(m_share_bd) common

estout * using results\Plan_table_1001_nc.xls, stats(r2 r2_a r2_p F chi2 ll N) /*
*/ cells(b(star fmt(%14.5f)) se(fmt(%14.5f))) margin legend starlevels(* 0.1 ** 0.05 *** 0.01) /*
*/ replace 

log close
estimates clear

clear

end

estimation_1001
