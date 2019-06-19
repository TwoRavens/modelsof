
set more off
clear all
set mem 600m

log using "C:\output\logs\results_log", replace

clear all

local sims=100
insheet using "C:\output\results.csv"
gen agent_sim=userid
gen agent=floor(agent_sim/(`sims'+1))
gen sim=agent_sim-(agent*(`sims'+1))
drop userid	number_obs_total number_obs_removed cycles_remain_test number_r_total number_r_removed
sort agent
save "C:\output\logs\results.dta", replace

gen str15 actual_text=""
replace actual_text="Actual Subjects" if sim==0
replace actual_text="Simulations" if sim>0

gen monthly_budgets=total_budgets/24
summarize monthly_budgets total_budgets min_sum_weights if sim==0
summarize monthly_budgets total_budgets min_sum_weights if sim==1

* histogram afriat, by(actual_text, cols(1) note("")) fraction saving("C:\output\logs\aei1.gph", replace) xtitle("AEI") bin(40)
ksmirnov afriat, by(actual_text)

gen hme=min_sum_weights/total_budget
* histogram hme, by(actual_text, cols(1) note("")) fraction saving("C:\output\logs\hme1.gph", replace) xtitle("MCI") bin(40)
ksmirnov hme, by(actual_text)

gen perfect=0
replace perfect=1 if hme==0
summarize perfect if sim==0
summarize perfect if sim==1

keep if sim==0
gen hme_actual=hme
gen afriat_actual=afriat
sort agent
save "C:\output\logs\results_actual.dta", replace

clear all
use "C:\output\logs\results.dta"

gen hme=min_sum_weights/total_budget

gen perfect=0
replace perfect=1 if hme==0

drop if sim==0
sort agent
merge agent using "C:\output\logs\results_actual.dta"

gen hme_under=0
replace hme_under=1 if hme_actual<=hme

gen afriat_over=0
replace afriat_over=1 if afriat_actual>=afriat

collapse (mean) hme_sim=hme hme_under afriat_sim=afriat afriat_over (p5) hme_5th=hme (p95) afriat_95th=afriat, by(agent)
save  "C:\output\logs\results_sim.dta", replace

clear all
use "C:\output\logs\results_actual.dta"

sort agent
merge agent using "C:\output\logs\results_sim.dta"

gen hme_sb=hme-hme_sim
gen afriat_sb=afriat-afriat_sim

gen hme_under5=0 
replace hme_under5=1 if hme<=hme_5th

gen afriat_over95=0
replace afriat_over95=1 if afriat>=afriat_95th

drop _merge

sort agent
save "C:\output\logs\results_full.dta", replace

clear all
use c:/research/denver/temp/demographics_only.dta

* aggregate purchases to individual level
sort panid
egen agent=group(panid)

sort agent
merge agent using "C:\output\logs\results_full.dta"

save "C:\output\logs\final.dta", replace

outsheet using c:/output/results_merge.csv, comma replace

summarize perfect hme hme_sim hme_sb hme_under hme_under5 afriat afriat_sim afriat_sb afriat_over afriat_over95

table hhsize_code hhage_code
table income_code hhed_code

xi: regress hme i.hhage_code i.hhsize_code i.num_heads_max i.income_code i.hhed_code 
xi: regress hme_sb i.hhage_code i.hhsize_code i.num_heads_max i.income_code i.hhed_code 

xi: regress afriat i.hhage_code i.hhsize_code i.num_heads_max i.income_code i.hhed_code 
xi: regress afriat_sb i.hhage_code i.hhsize_code i.num_heads_max i.income_code i.hhed_code 

corr hme afriat
corr hme_sb afriat_sb

* graph twoway (scatter hme afriat)(lfit hme afriat), saving("C:\output\logs\scatter_measures_absolute", replace)
* graph twoway (scatter hme_sb afriat_sb)(lfit hme_sb afriat_sb), saving("C:\output\logs\scatter_measures_adjusted", replace)

log close

* clear all
* set more on
