* this do file generates the results in Table 5 from Siminski (2013) 'Employment Effects of Army Service and Veterans’ Compensation: Evidence from the Australian Vietnam-Era Conscription Lotteries' The Review of Economics and Statistics 95(1): 87–97

** get collapsed earnings (second stage) data for 1995-96 (from tax data)
use second_stage_tax_returns.dta, clear
tab cohort, gen(c)

*merge on the relevant predicted values from the relevant first stage
merge m:1 cohort ballot using predicted_1st_stage_w_migrants, keepusing(rhat96) keep(match)
rename rhat96 parm
drop _merge

* estimate the 2sls vietnam ERA army service effect (using all cohorts)

*********************************************** Column (1)
quietly reg earn96 parm c2-c16 [aw=wt96], robust
est store earn

*********************************************** Column (2)
quietly reg l_earn96 parm c2-c16 [aw=wt96], robust
est store l_earn

** get collapsed income (second stage) data for 2006 (Census)
use second_stage_inc06_census.dta, clear
tabulate cohort, gen(c)

*merge on the relevant predicted values from the relevant first stage
merge m:1 cohort ballot using predicted_1st_stage, keepusing(parm) keep(match)
drop _merge

* annualise income
replace y = 52*y

*********************************************** Column (3)
quietly reg y parm c2-c16 [aw=wt06], robust
est store y

*********************************************** Column (4)
quietly reg ly parm c2-c16 [aw=wt06pos], robust
est store ly

esttab * using Table5.rtf, b(%8.3f) se(%8.3f)  replace keep(parm)
*parentheses  scalar(N) mtitles compress
