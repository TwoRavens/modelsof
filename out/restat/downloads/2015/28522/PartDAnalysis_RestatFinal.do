clear all   
cap log close
set more off
set matsize 11000

* Set date (here this is used to direct to the output file)
global date 122014
* Set location of input file
global inputs mergefiles/finaldata
* note that a DUA with CMS through NBER is need to access the input file.
* The full directory location is "/disk/agedisk5/medicare.work/afinkels-DUA22559/kluender/RestatSubmission". 
* Set location for output files
global outputs Documentation
* Set log file
log using Logs/PartDAnalysis_${date}.log, text replace

* Figure 2 plots P(claim in first 3 months) and Average End-of-year Price by Enrollment Month
scalar figure2 = 1
* Appendix Table A5 provides Part D summary statistics
* Appendix Table A6 provides a cross-tabulation of birth month and enrollment month
* Appendix Table A7 provides a cross-tabulation of enrollment month and end-of-year plan phase
* Appendix Table A8 provides enrollment month and end-of-year price regressions
scalar AppendixTables = 1

if figure2 == 1 {

* Call the analysis dataset
use ${inputs}/bene070809_65sample, clear

* Generate our initial utilization measure (any claims in first 30 days)
gen any_initial_claims = days_to_firstclaim<92 & days_to_firstclaim!=. & days_to_firstclaim>=0

* Analyzing future price by join month 
matrix define ded_fp = J(9, 4, .)
matrix define noded_fp = J(9, 4, .)

matrix colnames ded_fp = "FP" "Sim FP" "BM Sim FP" "Any Claim"
matrix colnames noded_fp = "FP" "Sim FP" "BM Sim FP" "Any Claim"

local rownames = ""
local row = 0
forv x = 2/10 {
	local rownames "`rownames' `x'"
	local row = `row' + 1
	
	sum future_price if partd_joinmonth==`x' & plan_group=="ded"
	local d = round(r(mean), 0.001)

	sum future_price if partd_joinmonth==`x' & plan_group=="noded"
	local nd = round(r(mean), 0.001)

	matrix ded_fp[`row', 1]=`d'
	matrix noded_fp[`row', 1]=`nd'
	
	sum sim_fp if partd_joinmonth==`x' & plan_group=="ded"
	local d = round(r(mean), 0.001)

	sum sim_fp if partd_joinmonth==`x' & plan_group=="noded"
	local nd = round(r(mean), 0.001)

	matrix ded_fp[`row', 2]=`d'
	matrix noded_fp[`row', 2]=`nd'
	
	sum sim_fp_bm if partd_joinmonth==`x' & plan_group=="ded"
	local d = round(r(mean), 0.001)

	sum sim_fp_bm if partd_joinmonth==`x' & plan_group=="noded"
	local nd = round(r(mean), 0.001)

	matrix ded_fp[`row', 3]=`d'
	matrix noded_fp[`row', 3]=`nd'

	sum any_initial_claims if partd_joinmonth==`x' & plan_group=="ded"
	local d = round(r(mean), 0.001)

	sum any_initial_claims if partd_joinmonth==`x' & plan_group=="noded"
	local nd = round(r(mean), 0.001)

	matrix ded_fp[`row', 4]=`d'
	matrix noded_fp[`row', 4]=`nd'	

} // end forv x = 2/10
matrix rownames ded_fp = `rownames'
matrix rownames noded_fp = `rownames'
matrix list ded_fp
matrix list noded_fp

* Note: Figure 2 is produced in Excel using the tables above
* The first column is the future price, the fourth column is initial utilization
* The two middle columns are instruments for the future price regressions (sim_fp_bm is used)
* The first table provides the values for deductible plans, the second for no deductible plans

} // end figure2

if AppendixTables == 1 {

* Pull in 65 year old analysis dataset
use ${inputs}/bene070809_65sample, clear

* Generate count variable for collapse
gen freq = 1

drop plan_group
gen plan_group=""
replace plan_group = "ded" if ded_amt>0 & ded_amt!=.
replace plan_group = "noded" if ded_amt==0

* Generate plan detail variables
gen somegapcov = 1-nogapcov
gen gap_coin_nogapcov = plan_coin_gap if nogapcov
gen gap_coin_somegapcov = plan_coin_gap if nogapcov==0

collapse (sum) freq (mean) age ded_amt plan_coin_ded icl_amt plan_coin_preicl somegapcov gap_coin_nogapcov gap_coin_somegapcov, by(plan_group)

* Note: This outsheets Table A5's summary statistics
* The table in the paper is a transposed and formatted version of the table outputted
outsheet plan_group freq age ded_amt plan_coin_ded icl_amt plan_coin_preicl somegapcov gap_coin_nogapcov gap_coin_somegapcov using ${outputs}/output_${date}/TableA5_65SamplePlanStats.csv, replace c

* Pull in 65 year old analysis dataset
use ${inputs}/bene070809_65sample, clear

* Table A6
tab birthmonth partd_joinmonth, row nofreq
tab birthmonth partd_joinmonth
* NOTE: Need to clean this table in Excel

*Table A7
bysort plan_group: tab partd_joinmonth finphas_clean, row
* NOTE: Need to clean this table in Excel

* REGRESSION PREP
xtset plan_year_id
local cluster plan_year_id
bysort plan_year_id: gen size_of_plan = _N
drop if size_of_plan==1
gen any_initial_claims = days_to_firstclaim<92 & days_to_firstclaim!=. & days_to_firstclaim>=0

*Table A8
* JOIN MONTH REGRESSIONS
areg any_initial_claims partd_joinmonth if plan_group=="ded", vce(cluster `cluster') absorb(plan_year)
estimates store D_AnyClm
areg any_initial_claims partd_joinmonth if plan_group=="noded", vce(cluster `cluster') absorb(plan_year)
estimates store ND_AnyClm
areg any_initial_claims ded_x_jm i.partd_joinmonth, vce(cluster `cluster') absorb(plan_year)
estimates store OLS_AnyClm
xtivreg2 any_initial_claims (ded_x_jm jm* = ded_x_bm bm*), cluster(plan_year_id) fe first
estimates store IV_AnyClm

* FUTURE PRICE REGRESSIONS
areg any_initial_claims future_price i.partd_joinmonth, vce(cluster `cluster') absorb(plan_year)
estimates store OLS_AnyClm_FP
xtivreg2 any_initial_claims (jm* future_price = sim_fp_bm bm*), cluster(plan_year_id) fe first
estimates store IV_BM_AnyClm_FP

* Note: This produces the Table A8 of the paper
estout D_AnyClm ND_AnyClm OLS_AnyClm IV_AnyClm OLS_AnyClm_FP IV_BM_AnyClm_FP, keep(partd_joinmonth ded_x_jm future_price) cells(b(fmt(3) star) se(fmt(3) par)) stats(N, fmt(0))

} // end AppendixTables

log close

