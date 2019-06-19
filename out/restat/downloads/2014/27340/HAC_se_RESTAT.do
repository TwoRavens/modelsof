// This do file computes HAC standard errors of growth rates
//  for RRI and BLS
// modified on 3/19/14 for one-sided t-test of an equal mean

clear
*set mem 64m
set matsize 1000
set more off
set type double

// -----------------------------
// This part prepares a data set of 11 MSAs
cd "C:\Users\juy18\Downloads\rent_index\rri2003sample"
use RRI_BLS_10MSA, clear

drop  Mean_2003 RRI_2003 Mean BLS_S2003 BLS_Adjusted BLS_S

reshape wide  RRI BLS_Actual, i(time) j(msa_name4) string


// add New_York actual BLS index
cd "C:\Users\juy18\Downloads\rent_index"
merge 1:1 time using bls_index_norm
keep time month New_York* BLS* RRI*

// add New_York RRI
cd "C:\Users\juy18\Downloads\rent_index\rri"
merge 1:1 time using New_York_rri

drop New_Yorkmean
drop New_Yorkrs 
rename New_Yorkrshet RRINew_York
drop New_Yorkrshet_l 
drop New_Yorkrshet_u
rename New_York_BLSA_r_n BLS_ActualNew_York
drop _merge

order month, after(time)
order BLS_ActualNew_York, last

foreach var of varlist RRI* {
	gen d_`var' = `var' - `var'[_n-1] if `var'[_n-1]<.
}

foreach var of varlist BLS* {
	gen ln_`var' = ln(`var'+1)
	gen d_`var' = ln_`var' - ln_`var'[_n-1] if ln_`var'[_n-1]<.
	drop ln_`var'
}


cd "C:\Users\juy18\Downloads\rent_index"
save 11MSA_RRI_BLS, replace


// -----------------------------
// This part computes univariate HAC se
use 11MSA_RRI_BLS, clear
// Annualize quarterly rates
foreach var of varlist d_* {
replace `var' = `var'*4
}

drop if time<2005.25 | time>2010


//HAC standard errors
gen d=dofm(month)
gen q=qofd(d)
drop d
tsset q

foreach var of varlist d_* {
newey `var', lag(1)
gen mean_`var' = _b[_cons]
gen se_`var' = _se[_cons]
}

foreach var of varlist RRI* {
newey `var', lag(1)
gen se_`var' = _se[_cons]
}
foreach var of varlist BLS* {
newey `var', lag(1)
gen se_`var' = _se[_cons]
}

drop RRI* BLS* d_* time month q
duplicates drop se_d_RRIAtlanta, force

gen id= _n
reshape long mean_d_RRI mean_d_BLS_Actual se_d_RRI se_d_BLS_Actual se_RRI se_BLS_Actual, i(id) j(msa_name4) string
drop id
export excel RRI_BLS_growth, replace firstrow(variables)



// -----------------------------
// This part runs panel regressions to test HAC se between indexes
use 11MSA_RRI_BLS, clear
// Annualize quarterly rates
foreach var of varlist d_* {
replace `var' = `var'*4
}

drop if time<2005.25 | time>2010

gen d=dofm(month)
gen q=qofd(d)
drop d
order q, after(month)

drop RRI* BLS*

stack d_RRIAtlanta d_RRIBoston d_RRIDallas d_RRIDetroit d_RRIHouston d_RRILos_Angeles d_RRIMiami d_RRINew_York d_RRISan_Francisco d_RRISeattle d_RRIWashington ///
d_BLS_ActualAtlanta d_BLS_ActualBoston d_BLS_ActualDallas d_BLS_ActualDetroit d_BLS_ActualHouston d_BLS_ActualLos_Angeles d_BLS_ActualMiami d_BLS_ActualNew_York d_BLS_ActualSan_Francisco d_BLS_ActualSeattle d_BLS_ActualWashington, ///
into(Atlanta Boston Dallas Detroit Houston Los_Angeles Miami New_York San_Francisco Seattle Washington) clear wide


gen index="RRI" if _stack==1
replace index ="BLS" if _stack==2
gen BLS = 0
replace BLS =1 if _stack==2
gen time=_n
tsset time

foreach m in  ///
"Atlanta" ///
"Boston" ///
"Dallas" ///
"Detroit" ///
"Houston" ///
"Los_Angeles" ///
"Miami" ///
"New_York" ///
"San_Francisco" ///
"Seattle" ///
"Washington" ///
{
newey `m' BLS, lag(1)
gen mean_d_RRI`m' = _b[_cons]
gen se_d_RRI`m' = _se[_cons]
noisily lincom BLS+_cons
gen mean_d_BLS`m' = r(estimate)
gen se_d_BLS`m' = r(se)
gen diff_mean`m'= _b[BLS]
gen Pr_eqmean`m' = ttail(38, _b[BLS]/_se[BLS])
}

drop _stack Atlanta Boston Dallas Detroit Houston Los_Angeles Miami New_York San_Francisco Seattle Washington d_RRIAtlanta d_RRIBoston d_RRIDallas d_RRIDetroit d_RRIHouston d_RRILos_Angeles d_RRIMiami d_RRINew_York d_RRISan_Francisco d_RRISeattle d_RRIWashington d_BLS_ActualAtlanta d_BLS_ActualBoston d_BLS_ActualDallas d_BLS_ActualDetroit d_BLS_ActualHouston d_BLS_ActualLos_Angeles d_BLS_ActualMiami d_BLS_ActualNew_York d_BLS_ActualSan_Francisco d_BLS_ActualSeattle d_BLS_ActualWashington index BLS time
duplicates drop  mean_d_RRIAtlanta, force

gen id= _n
reshape long mean_d_RRI mean_d_BLS se_d_RRI se_d_BLS diff_mean Pr_eqmean, i(id) j(msa_name4) string
drop id

label variable msa_name4 "MSA"
label variable mean_d_RRI "Mean log change in RRI"
label variable mean_d_BLS "Mean log change in BLS"
label variable se_d_RRI "s.e. of log change in RRI"
label variable se_d_BLS "s.e. of log change in RRI" 
label variable diff_mean "Mean difference"
label variable Pr_eqmean "p-value of equal mean (One-side)"

gen f =  se_d_RRI^2/ se_d_BLS^2
label variable f "Variance ratio V(RRI)/V(BLS)"
*gen Pr_F_l_f = F(19,19,f)
*label variable Pr_F_l_f "Ha: ratio<1, Pr(F<f)"
gen Pr_F_g_f = 1 - F(19,19,f)
label variable Pr_F_g_f "p-value of equal variance (One-side)"
*gen Pr_F_e_f = 2*Pr_F_g_f if f > 1
*label variable Pr_F_e_f "Ha: ratio!=1, Pr(F>f)"

*format mean* se* diff* Pr* f %6.0g

export excel RRI_BLS_growth_tests, replace firstrow(varlabels)
/* Noto to the table.
Note. This table compares the annualized value of mean quarterly log change in the RRI and the BLS index for 11 MSAs during a common time period between 2005 and 2010. The Newey-West heteroskedasticty and autocorrelation consistent (HAC) standard errors with one-quarter lags are also reported. The p-value of equal mean is based on the t-statistic of the difference in mean log change between RRI and BLS. The HAC variance ratio is used for the F-test for an equal variance of log changes between the RRI and the BLS index (the p-value is reported).
*/
