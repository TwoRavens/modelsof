* * * TOP INCOME SHARES IN SWITZERLAND * * * 
 
 * Isabel Martinez, University of St. Gallen, 2012
 // this version: July 2016
 
/***
 NOTES:
 * closing the gap caused by the missing years 1995-2002 using
 1) synthetic control method
 2) OLS estimation and linear prediction
 3) simple imputation method exploiting variance from missing series
 4) add synthetic control estimates back in and replace the missing years with these estimates, as this turns out to be the preferred method
 5) store the data set 4a_TopIncomeShares_CH_1981-2010.dta
 6) produce "Table 2: Growth in income shares of top groups, 1981–2010 (in percent)"
 7) add data from Dell, Piketty, Saez (2007) covering the years 1933-1995
 8) some final editing of the data such as calculating average incomes, real incomes etc.
 9) store the data set 4b_TopIncomeShares_CH_1933-2010.dta
***/
 *_____________________________________________________________________________________
 
version 14.0 

clear all
set more off
cap log close
cap graph drop _all
cap clear matrix 

* PREAPARE A DATASET FOR THE SYNTHETIC CONTROL

use "$thepath/2a_TopIncomeShares_CH_withgap.dta", clear

keep cant year P90d P95d P99d P995d P999d P9999d ///
 ts90 inc_avg90 ts95 inc_avg95 ts99 inc_avg99 ts995 inc_avg995 ///
 ts999 inc_avg999 ts9999 inc_avg9999 b90 b95 b99 b995 b999 b9999
keep if cant==0
 
xtset cant year
tsfill, full
 
// add the annual population totals
preserve
	import excel "$thepath/Population.xlsx", sheet("popstat_annual") cellrange(L1:P31) clear firstrow
	gen total_taxunits = total_taxunits_annual
	gen total_adults = total_adults_annual 
	gen cant=0
	drop total_adults_annual total_taxunits_annual total_adults_biennial total_taxunits_biennial
	tempfile popstat_1
	save "`popstat_1'"
restore

merge 1:1 cant year using "`popstat_1'"
drop _merge

// add Swiss GDP
preserve
	import excel "$thepath/Data.xlsx", sheet("gdp_ch") cellrange(A1:C29) clear firstrow
	tempfile gdp_ch
	save "`gdp_ch'"
restore

merge 1:1 cant year using "`gdp_ch'"
drop _merge


// add the cantonal top shares, gdp and unemployment rate data
drop if year>2008 //since cantonal data only goes up to 2008
append using "$thepath/2b_SyntheticControl_cantonal_data.dta"

replace gdp_cant = gdp_ch if cant==0

// add unemployment rate (Switzerland and all cantons)
preserve
	import excel "$thepath/Data.xlsx", sheet("ul_rate") cellrange(B1:D757) clear firstrow
	tempfile ulrate
	save "`ulrate'"
restore
merge 1:1 cant year using "`ulrate'"
drop _merge


cd "$thepath/results/synthetic_control"

* create linearlly interpolated series, as synth does not work with missings
foreach n in 90 95 99 995 999 9999 {
bysort cant: ipolate  P`n'd year, generate(P`n'_ipol)
replace P`n'd=P`n'_ipol if P`n'd==.
drop P`n'_ipol
}



*GDP per capita
gen gdp_pc=gdp_cant*1000000/total_adults
	label var gdp_pc "GDP per adult"

*GDP grwoth
bysort cant: gen gdp_growth=(gdp_cant[_n]-gdp_cant[_n-1]) / gdp_cant[_n-1] if _n>1
replace gdp_growth=. if gdp_growth==-1
replace gdp_growth=gdp_growth*100
	label var gdp_growth "Annual GDP growth rate"

*Population growth
bysort cant: gen pop_growth=(total_adults[_n]-total_adults[_n-1]) / total_adults[_n-1] if _n>1
replace pop_growth=pop_growth*100
	label var pop_growth "Annual population growth rate"



* Synthetic control *
// How to install synth package:
/*
  net from "http://www.mit.edu/~jhainm/Synth"
  net describe synth
  net install synth, all replace force
*/
 
log using synth_estimates, replace
 
*Top 10%  (all predictors)
synth P90d ///
P90d P95d P99d P995d P999d P9999d  ///
inc_avg90 inc_avg95  inc_avg99  inc_avg995 inc_avg999 inc_avg9999 ts90 ts95 ts99 ts995 ts999 ts9999   ///
gdp_pc gdp_growth pop_growth ul_rate, ///
trunit(0) trperiod(1995) counit(1(1)26)) /*figure*/ keep(synth_top10_share.dta, replace)
     * graph export "top10.pdf", as(pdf) replace
// predictor balance matrix
matrix B10=e(X_balance)
matrix colnames B10 = "Switzerland" "Top 10%"
matrix rownames B10 =  "Top 10%"  "Top 5%"  "Top 1%"  "Top 0.5%"  "Top 0.1%"  "Top 0.01%"  "Top 10%"  "Top 5%"  "Top 1%"  "Top 0.5%"  "Top 0.1%"  "Top 0.01%"  "Top 10%"  "Top 5%"  "Top 1%"  "Top 0.5%"  "Top 0.1%"  "Top 0.01%"  "GDP growth"  "Population growth"  "GDP p.c. Unemployment rate"
putexcel A4=matrix(B10, names)	using "predictors.xlsx",  replace
// weighting matrix
matrix W10=e(W_weights)
matrix W10=W10[1...,2]
matrix colnames W10 =  "Top 10%"
matrix rownames W10 = "ZH"  "BE"  "LU"  "UR"  "SZ"  "OW"  "NW"  "GL"  "ZG"  "FR"  "SO"  "BS"  "BL"  "SH"  "AR"  "AI"  "SG"  "GR"  "AG"  "TG"  "TI"  "VD"  "VS"  "NE"  "GE"  "JU"
putexcel B4=matrix(W10, names) using "weights.xlsx",  replace



*Top 5%  (all predictors)
synth P95d ///
P90d P95d P99d P995d P999d P9999d  ///
inc_avg90 inc_avg95  inc_avg99  inc_avg995 inc_avg999 inc_avg9999 ts90 ts95 ts99 ts995 ts999 ts9999   ///
gdp_pc gdp_growth pop_growth ul_rate, ///
trunit(0) trperiod(1995) counit(1(1)26)) /*figure*/ keep(synth_top5_share.dta, replace)
     * graph export "top5.pdf", as(pdf) replace
// predictor balance matrix
matrix B5=e(X_balance)
matrix B5=B5[1...,2]
matrix colnames B5 = "Top 5%"
putexcel D4=matrix(B5, colnames) using "predictors.xlsx",  sheet("Sheet1") modify
// weighting matrix
matrix W5=e(W_weights)
matrix W5=W5[1...,2]
matrix colnames W5 =  "Top 5%"
putexcel D4=matrix(W5, colnames) using "weights.xlsx", sheet("Sheet1")  modify


*Top 1%  (all predictors)
synth P99d ///
P90d P95d P99d P995d P999d P9999d  ///
inc_avg90 inc_avg95  inc_avg99  inc_avg995 inc_avg999 inc_avg9999 ts90 ts95 ts99 ts995 ts999 ts9999   ///
gdp_pc gdp_growth pop_growth ul_rate, ///
trunit(0) trperiod(1995) counit(1(1)26)) /*figure*/ keep(synth_top1_share.dta, replace)
     * graph export "top1.pdf", as(pdf) replace
// predictor balance matrix
matrix B1=e(X_balance)
matrix B1=B1[1...,2]
matrix colnames B1 = "Top 1%"
putexcel E4=matrix(B1, colnames) using "predictors.xlsx",  sheet("Sheet1") modify
// weighting matrix
matrix W1=e(W_weights)
matrix W1=W1[1...,2]
matrix colnames W1 =  "Top 1%"
putexcel E4=matrix(W1, colnames) using "weights.xlsx", sheet("Sheet1")  modify


*Top 0.5%  (all predictors)
synth P995d ///
P90d P95d P99d P995d P999d P9999d  ///
inc_avg90 inc_avg95  inc_avg99  inc_avg995 inc_avg999 inc_avg9999 ts90 ts95 ts99 ts995 ts999 ts9999   ///
gdp_pc gdp_growth pop_growth ul_rate, ///
trunit(0) trperiod(1995) counit(1(1)26)) /*figure*/ keep(synth_top05_share.dta, replace)
     * graph export "top05.pdf", as(pdf) replace
// predictor balance matrix
matrix B05=e(X_balance)
matrix B05=B05[1...,2]
matrix colnames B05 = "Top 0.5%"
putexcel F4=matrix(B05, colnames) using "predictors.xlsx",  sheet("Sheet1") modify
// weighting matrix
matrix W05=e(W_weights)
matrix W05=W05[1...,2]
matrix colnames W05 =  "Top 0.5%"
putexcel F4=matrix(W05, colnames) using "weights.xlsx", sheet("Sheet1")  modify


*Top 0.1%  (all predictors)
synth P999d ///
P90d P95d P99d P995d P999d P9999d  ///
inc_avg90 inc_avg95  inc_avg99  inc_avg995 inc_avg999 inc_avg9999 ts90 ts95 ts99 ts995 ts999 ts9999   ///
gdp_pc gdp_growth pop_growth ul_rate, ///
trunit(0) trperiod(1995) counit(1(1)26)) /*figure*/ keep(synth_top01_share.dta, replace)
     * graph export "top01.pdf", as(pdf) replace
// predictor balance matrix
matrix B01=e(X_balance)
matrix B01=B01[1...,2]
matrix colnames B01 = "Top 0.1%"
putexcel G4=matrix(B01, colnames) using "predictors.xlsx",  sheet("Sheet1") modify
// weighting matrix
matrix W01=e(W_weights)
matrix W01=W01[1...,2]
matrix colnames W01 =  "Top 0.1%"
putexcel G4=matrix(W01, colnames) using "weights.xlsx", sheet("Sheet1")  modify


*Top 0.01%  
//note: this doesn't go through because GL and AR couldn't be Pareto interpolated... (therefore in 81&82 the top 0.01% are missing here)
// therefore: inter- & extrapolation of top shares of GL & AR where they are mising
foreach n in 9999 {
bysort cant: ipolate  P`n'd year if cant==8 | cant== 15, generate(P`n'_ipol) epolate
replace P`n'd=P`n'_ipol if P`n'd==.
drop P`n'_ipol
}

synth P9999d ///
P90d P95d P99d P995d P999d P9999d  ///
inc_avg90 inc_avg95  inc_avg99  inc_avg995 inc_avg999 inc_avg9999 ts90 ts95 ts99 ts995 ts999 ts9999   ///
gdp_pc gdp_growth pop_growth ul_rate, ///
trunit(0) trperiod(1995) counit(1(1)26)) /*figure*/ keep(synth_top001_share.dta, replace)
     * graph export "top001.pdf", as(pdf) replace
// predictor balance matrix
matrix B001=e(X_balance)
matrix B001=B001[1...,2]
matrix colnames B001 = "Top 0.01%"
putexcel H4=matrix(B001, colnames) using "predictors.xlsx",  sheet("Sheet1") modify
// weighting matrix
matrix W001=e(W_weights)
matrix W001=W001[1...,2]
matrix colnames W001 =  "Top 0.01%"
putexcel H4=matrix(W001, colnames) using "weights.xlsx", sheet("Sheet1")  modify

log close




* ESTIMATE THE BETA COEFFICIENTS USING SYNTHETIC CONTROL METHOD
log using synth_beta_estimates, replace

* Interpolation *
foreach n in 90 95 99 995 999 9999 {
bysort cant: ipolate  b`n' year, generate(b`n'_ipol)
replace b`n'=b`n'_ipol if b`n'==.
drop b`n'_ipol
}

 
*Top 10%  (all predictors)
synth b90 ///
b90 b95 b99 b995 b999 b9999  ///
inc_avg90 inc_avg95  inc_avg99  inc_avg995 inc_avg999 inc_avg9999 ts90 ts95 ts99 ts995 ts999 ts9999   ///
gdp_pc gdp_growth pop_growth ul_rate, ///
trunit(0) trperiod(1995) counit(1(1)26)) /*figure*/ keep(synth_top10_beta.dta, replace)
     * graph export "top10_beta.pdf", as(pdf) replace
// predictor balance matrix
matrix B10=e(X_balance)
matrix colnames B10 = "Switzerland" "\beta top 10%"
matrix rownames B10 =  "\beta top 10%"  "\beta top 5%"  "\beta top 1%"  "\beta top 0.5%"  "\beta top 0.1%"  "\beta top 0.01%"  "\beta top 10%"  "\beta top 5%"  "\beta top 1%"  "\beta top 0.5%"  "\beta top 0.1%"  "\beta top 0.01%"  "\beta top 10%"  "\beta top 5%"  "\beta top 1%"  "\beta top 0.5%"  "\beta top 0.1%"  "\beta top 0.01%"  "GDP growth"  "Population growth"  "GDP p.c. Unemployment rate"
putexcel A4=matrix(B10, names)	using "predictors_beta.xlsx",  replace
// weighting matrix
matrix W10=e(W_weights)
matrix W10=W10[1...,2]
matrix colnames W10 =  "\beta top 10%"
matrix rownames W10 = "ZH"  "BE"  "LU"  "UR"  "SZ"  "OW"  "NW"  "GL"  "ZG"  "FR"  "SO"  "BS"  "BL"  "SH"  "AR"  "AI"  "SG"  "GR"  "AG"  "TG"  "TI"  "VD"  "VS"  "NE"  "GE"  "JU"
putexcel B4=matrix(W10, names) using "weights_beta.xlsx",  replace



*Top 5%  (all predictors)
synth b95 ///
b90 b95 b99 b995 b999 b9999  ///
inc_avg90 inc_avg95  inc_avg99  inc_avg995 inc_avg999 inc_avg9999 ts90 ts95 ts99 ts995 ts999 ts9999   ///
gdp_pc gdp_growth pop_growth ul_rate, ///
trunit(0) trperiod(1995) counit(1(1)26)) /*figure*/ keep(synth_top5_beta.dta, replace)
     * graph export "top5_beta.pdf", as(pdf) replace
// predictor balance matrix
matrix B5=e(X_balance)
matrix B5=B5[1...,2]
matrix colnames B5 = "\beta top 5%"
putexcel D4=matrix(B5, colnames) using "predictors_beta.xlsx",  sheet("Sheet1") modify
// weighting matrix
matrix W5=e(W_weights)
matrix W5=W5[1...,2]
matrix colnames W5 =  "\beta top 5%"
putexcel D4=matrix(W5, colnames) using "weights_beta.xlsx", sheet("Sheet1")  modify



*Top 1%  (all predictors)
synth b99 ///
b90 b95 b99 b995 b999 b9999  ///
inc_avg90 inc_avg95  inc_avg99  inc_avg995 inc_avg999 inc_avg9999 ts90 ts95 ts99 ts995 ts999 ts9999   ///
gdp_pc gdp_growth pop_growth ul_rate, ///
trunit(0) trperiod(1995) counit(1(1)26)) /*figure*/ keep(synth_top1_beta.dta, replace)
     * graph export "top1_beta.pdf", as(pdf) replace
// predictor balance matrix
matrix B1=e(X_balance)
matrix B1=B1[1...,2]
matrix colnames B1 = "\beta top 1%"
putexcel E4=matrix(B1, colnames) using "predictors_beta.xlsx",  sheet("Sheet1") modify
// weighting matrix
matrix W1=e(W_weights)
matrix W1=W1[1...,2]
matrix colnames W1 =  "\beta top 1%"
putexcel E4=matrix(W1, colnames) using "weights_beta.xlsx", sheet("Sheet1")  modify



*Top 0.5%  (all predictors)
synth b995 ///
b90 b95 b99 b995 b999 b9999  ///
inc_avg90 inc_avg95  inc_avg99  inc_avg995 inc_avg999 inc_avg9999 ts90 ts95 ts99 ts995 ts999 ts9999   ///
gdp_pc gdp_growth pop_growth ul_rate, ///
trunit(0) trperiod(1995) counit(1(1)26)) /*figure*/ keep(synth_top05_beta.dta, replace)
     * graph export "top05_beta.pdf", as(pdf) replace
// predictor balance matrix
matrix B05=e(X_balance)
matrix B05=B05[1...,2]
matrix colnames B05 = "\beta top 0.5%"
putexcel F4=matrix(B05, colnames) using "predictors_beta.xlsx",  sheet("Sheet1") modify
// weighting matrix
matrix W05=e(W_weights)
matrix W05=W05[1...,2]
matrix colnames W05 =  "\beta top 0.5%"
putexcel F4=matrix(W05, colnames) using "weights_beta.xlsx", sheet("Sheet1")  modify



*Top 0.1%  (all predictors)
synth b999 ///
b90 b95 b99 b995 b999 b9999  ///
inc_avg90 inc_avg95  inc_avg99  inc_avg995 inc_avg999 inc_avg9999 ts90 ts95 ts99 ts995 ts999 ts9999   ///
gdp_pc gdp_growth pop_growth ul_rate, ///
trunit(0) trperiod(1995) counit(1(1)26)) /*figure*/ keep(synth_top01_beta.dta, replace)
     * graph export "top01_beta.pdf", as(pdf) replace
// predictor balance matrix
matrix B01=e(X_balance)
matrix B01=B01[1...,2]
matrix colnames B01 = "\beta top 0.1%"
putexcel G4=matrix(B01, colnames) using "predictors_beta.xlsx",  sheet("Sheet1") modify
// weighting matrix
matrix W01=e(W_weights)
matrix W01=W01[1...,2]
matrix colnames W01 =  "\beta top 0.1%"
putexcel G4=matrix(W01, colnames) using "weights_beta.xlsx", sheet("Sheet1")  modify



*Top 0.01%  
//note: this doesn't go through because GL and AR couldn't be Pareto interpolated... (therefore in 81&82 the top 0.01% are missing here)
// therefore: inter- & extrapolation of top shares of GL & AR where they are mising
foreach n in 9999 {
bysort cant: ipolate  b`n' year if cant==8 | cant== 15, generate(b`n'_ipol) epolate
replace b`n'=b`n'_ipol if b`n'==.
drop b`n'_ipol
}

synth b9999 ///
b90 b95 b99 b995 b999 b9999  ///
inc_avg90 inc_avg95  inc_avg99  inc_avg995 inc_avg999 inc_avg9999 ts90 ts95 ts99 ts995 ts999 ts9999   ///
gdp_pc gdp_growth pop_growth ul_rate, ///
trunit(0) trperiod(1995) counit(1(1)26)) /*figure*/ keep(synth_top001_beta.dta, replace)
     * graph export "top001_beta.pdf", as(pdf) replace
// predictor balance matrix
matrix B001=e(X_balance)
matrix B001=B001[1...,2]
matrix colnames B001 = "\beta top 0.01%"
putexcel H4=matrix(B001, colnames) using "predictors_beta.xlsx",  sheet("Sheet1") modify
// weighting matrix
matrix W001=e(W_weights)
matrix W001=W001[1...,2]
matrix colnames W001 =  "\beta top 0.01%"
putexcel H4=matrix(W001, colnames) using "weights_beta.xlsx", sheet("Sheet1")  modify


log close


***  * *  ***  * *  ***  * *  ***  * *  ***  * *  ***  * *  ***  * *  ***  * *  *** 
* REARRANGE RESULTS DATA SETS FOR LATER USE * 



* 1) Top Shares

use "$thepath/results/synthetic_control/synth_top10_share.dta", clear
rename _time year
rename _Y_synthetic synth_P90d
drop _Co_Number _W_Weight _Y_treated
tempfile P90_synth
gen cant=0
save "`P90_synth'"

use "$thepath/results/synthetic_control/synth_top5_share.dta", clear
rename _time year
rename _Y_synthetic synth_P95d
drop _Co_Number _W_Weight _Y_treated
tempfile P95_synth
gen cant=0
save "`P95_synth'"

use "$thepath/results/synthetic_control/synth_top1_share.dta", clear
rename _time year
rename _Y_synthetic synth_P99d
drop _Co_Number _W_Weight _Y_treated
tempfile P99_synth
gen cant=0
save "`P99_synth'"

use "$thepath/results/synthetic_control/synth_top05_share.dta", clear
rename _time year
rename _Y_synthetic synth_P995d
drop _Co_Number _W_Weight _Y_treated
tempfile P995_synth
gen cant=0
save "`P995_synth'"

use "$thepath/results/synthetic_control/synth_top01_share.dta", clear
rename _time year
rename _Y_synthetic synth_P999d
drop _Co_Number _W_Weight _Y_treated
tempfile P999_synth
gen cant=0
save "`P999_synth'"

use "$thepath/results/synthetic_control/synth_top001_share.dta", clear
rename _time year
rename _Y_synthetic synth_P9999d
drop _Co_Number _W_Weight _Y_treated
tempfile P9999_synth
gen cant=0
save "`P9999_synth'"


// merge everything together
use "`P90_synth'", clear
merge 1:1 year cant using "`P95_synth'", nogen
merge 1:1 year cant using "`P99_synth'", nogen
merge 1:1 year cant using "`P995_synth'", nogen
merge 1:1 year cant using "`P999_synth'", nogen
merge 1:1 year cant using "`P9999_synth'", nogen

save "$thepath/results/synthetic_control/synthetic_top_shares.dta", replace

// remove the intemediary files
rm "$thepath/results/synthetic_control/synth_top10_share.dta"
rm "$thepath/results/synthetic_control/synth_top5_share.dta"
rm "$thepath/results/synthetic_control/synth_top1_share.dta"
rm "$thepath/results/synthetic_control/synth_top05_share.dta"
rm "$thepath/results/synthetic_control/synth_top01_share.dta"
rm "$thepath/results/synthetic_control/synth_top001_share.dta"




* 2) BETAS

use "$thepath/results/synthetic_control/synth_top10_beta.dta", clear
rename _time year
rename _Y_synthetic beta_P90_synth
drop _Co_Number _W_Weight _Y_treated
tempfile P90_synth
gen cant=0
save "`P90_synth'"

use "$thepath/results/synthetic_control/synth_top5_beta.dta", clear
rename _time year
rename _Y_synthetic beta_P95_synth
drop _Co_Number _W_Weight _Y_treated
tempfile P95_synth
gen cant=0
save "`P95_synth'"

use "$thepath/results/synthetic_control/synth_top1_beta.dta", clear
rename _time year
rename _Y_synthetic beta_P99_synth
drop _Co_Number _W_Weight _Y_treated
tempfile P99_synth
gen cant=0
save "`P99_synth'"

use "$thepath/results/synthetic_control/synth_top05_beta.dta", clear
rename _time year
rename _Y_synthetic beta_P995_synth
drop _Co_Number _W_Weight _Y_treated
tempfile P995_synth
gen cant=0
save "`P995_synth'"

use "$thepath/results/synthetic_control/synth_top01_beta.dta", clear
rename _time year
rename _Y_synthetic beta_P999_synth
drop _Co_Number _W_Weight _Y_treated
tempfile P999_synth
gen cant=0
save "`P999_synth'"

use "$thepath/results/synthetic_control/synth_top001_beta.dta", clear
rename _time year
rename _Y_synthetic beta_P9999_synth
drop _Co_Number _W_Weight _Y_treated
tempfile P9999_synth
gen cant=0
save "`P9999_synth'"


// merge everything together
use "`P90_synth'", clear
merge 1:1 year cant using "`P95_synth'", nogen
merge 1:1 year cant using "`P99_synth'", nogen
merge 1:1 year cant using "`P995_synth'", nogen
merge 1:1 year cant using "`P999_synth'", nogen
merge 1:1 year cant using "`P9999_synth'", nogen

save "$thepath/results/synthetic_control/synthetic_betas.dta", replace

// remove the intemediary files
rm "$thepath/results/synthetic_control/synth_top10_beta.dta"
rm "$thepath/results/synthetic_control/synth_top5_beta.dta"
rm "$thepath/results/synthetic_control/synth_top1_beta.dta"
rm "$thepath/results/synthetic_control/synth_top05_beta.dta"
rm "$thepath/results/synthetic_control/synth_top01_beta.dta"
rm "$thepath/results/synthetic_control/synth_top001_beta.dta"





*** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** 
 * O L S   E S T I M A T I O N   O F   T O P   S H A R E S *
 
 
use "$thepath/2a_TopIncomeShares_CH_withgap.dta", clear
drop P90 P95 P99 P995 P999 P9999 P10_5 P5_1 P10_1 // don't need these series anymore, where denominator has not been corrected for non-filers
tsfill


* Generate the "99th" canton to run regressions with on a later stage
set obs 622
replace cant=99 in 595/622
label define cant 99 "Switzerland, OLS", modify
replace year=_n+1386 in 595/622
drop if cant==.

// replace all the other variables for the new Switzerland by their value for Switzerland
foreach var in total_taxunits total_adults tu_total inc_total alpha beta ///
P90d P95d P99d P995d P999d P9999d P10_5d P5_1d P10_1d ///
top10_within_top1 top1_within_top1 top10_within_top10 period income_denominator ///
b_60 k_60 b_70 k_70 b_80 k_80 b_90 k_90 b_100 k_100 b_120 k_120 b_150 k_150 ///
 b_200 k_200 b_300 k_300 b_400 k_400 b_500 k_500 b_1000 k_1000 b_2000 k_2000 ///
 ts90 inc_avg90 inc_abv90 b90 ts95 inc_avg95 inc_abv95 b95 ts99 inc_avg99 inc_abv99 b99 ///
 ts995 inc_avg995 inc_abv995 b995 ts999 inc_avg999 inc_abv999 b999 ts9999 inc_avg9999 inc_abv9999 b9999 {
bysort year (cant) : replace `var' = `var'[1] if cant==99 & `var'==.
}

* Generate variables containing the Swiss and cantonal Top Shares for each year
foreach n in 90 95 99 995 999 9999 {
quietly gen OLS_P`n'd=P`n'd if cant==0
bysort year (OLS_P`n'd): replace OLS_P`n'd=OLS_P`n'd[1]
label var OLS_P`n'd "P`n''s income share, Switzerland (1995-2002 (incl.) replaced by OLS estimates)"
* Generate variables containing the Basel Stadt Top Shares
quietly gen BS_P`n'd=P`n'd if cant==12
bysort year (BS_P`n'd): replace BS_P`n'd=BS_P`n'd[1]
label var BS_P`n'd "P`n''s income share, Basel City"
* Generate variables containing the ZH,TG Top Shares
quietly gen ZHTG_P`n'd=P`n'd if cant==92
bysort year (ZHTG_P`n'd): replace ZHTG_P`n'd=ZHTG_P`n'd[1]
label var ZHTG_P`n'd "P`n''s income share, ZH and TG"
* Generate variables containing the VD, VS, TI Top Shares
quietly gen VVT_P`n'd=P`n'd if cant==91
bysort year (VVT_P`n'd): replace VVT_P`n'd=VVT_P`n'd[1]
label var VVT_P`n'd "P`n''s income share, VD, VS and TI"
* Generate variables containing the 20 Cantons Top Shares
quietly gen twenty_P`n'd=P`n'd if cant==93
bysort year (twenty_P`n'd): replace twenty_P`n'd=twenty_P`n'd[1]
label var twenty_P`n'd "P`n''s income share, 20 Cantons"
}


sort cant year
order cant year P90d P95d P99d P995d P999d P9999d ///
OLS_P90d OLS_P95d OLS_P99d OLS_P995d OLS_P999d OLS_P9999d ///
BS_P90d BS_P95d BS_P99d BS_P995d BS_P999d BS_P9999d ///
ZHTG_P90d ZHTG_P95d ZHTG_P99d ZHTG_P995d ZHTG_P999d ZHTG_P9999d ///
VVT_P90d VVT_P95d VVT_P99d VVT_P995d VVT_P999d VVT_P9999d ///
twenty_P90d twenty_P95d twenty_P99d twenty_P995d twenty_P999d twenty_P9999d ///
 total_taxunits total_adults tu_total inc_total alpha beta


****** R E G R E S S I O N   M O D E L S   I, II, III ****** 
cd "$thepath/results/OLS"
//Also make a log file and create regression tables for the paper*
// to install the estout package type: ssc install estout 

log using regression_models, replace 

foreach n in 90 95 99 995 999 9999 {
* model I
eststo I_`n': xtreg OLS_P`n'd BS_P`n'd if cant==99, fe
predict OLS_P`n'_I
label var OLS_P`n'_I "OLS prediction based on Model I: BS"
}
foreach n in 90 95 99 995 999 9999 {
* model II
eststo II_`n': xtreg OLS_P`n'd BS_P`n'd  ZHTG_P`n'd if cant==99, fe
predict OLS_P`n'_II
label var OLS_P`n'_II "OLS prediction based on Model II: BS, ZH&TG"
}
foreach n in 90 95 99 995 999 9999 {
* model III
eststo III_`n': xtreg OLS_P`n'd BS_P`n'd  ZHTG_P`n'd  twenty_P`n'd if cant==99, fe
predict OLS_P`n'_III
label var OLS_P`n'_III "OLS prediction based on Model III: BS, ZH&TG, 20 cantons"
}

log close

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *  
* *  Produce estimation tables (for the Appendix) * * 
// set nicer labels
foreach n in 90 95 99 995 999 9999 {
label var BS_P`n'd "Basel City (BS)"
label var ZHTG_P`n'd "Zurich and Thurgau (ZH TG)"
label var twenty_P`n'd "Twenty Cantons"
}

// produce the tables (for Word: .rtf, for LaTeX: .tex)
foreach n in 90 95 99 995 999 9999 {
esttab I_`n' II_`n' III_`n' using table_C1-`n'.csv, ///
se r2 label noobs ///
title(Top `n' shares) ///
replace
}

esttab I_90 II_90 III_90 using table_C1-90.csv, ///
se r2 label ///
title("Top 10% Shares") ///
nonumber mtitles("Model I" "Model II" "Model III") ///
replace 

esttab I_95 II_95 III_95 using table_C1-95.csv, ///
se r2 label ///
title("Top 5% Shares") ///
nonumber mtitles("Model I" "Model II" "Model III") ///
replace 

esttab I_99 II_99 III_99 using table_C1-99.csv, ///
se r2 label ///
title("Top 1% Shares") ///
nonumber mtitles("Model I" "Model II" "Model III") ///
replace 

esttab I_995 II_995 III_995 using table_C1-995.csv, ///
se r2 label ///
title("Top 0.5% Shares") ///
nonumber mtitles("Model I" "Model II" "Model III") ///
replace 

esttab I_999 II_999 III_999 using table_C1-999.csv, ///
se r2 label ///
title("Top 0.1% Shares") ///
nonumber mtitles("Model I" "Model II" "Model III") ///
replace 

esttab I_9999 II_9999 III_9999 using table_C1-9999.csv, ///
se r2 label  ///
title("Top 0.01% Shares") ///
nonumber mtitles("Model I" "Model II" "Model III") ///
replace 

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 

drop  _est_I*
* replace missing years with predicted values
sort cant year
foreach n in 90 95 99 995 999 9999 {
quiet replace OLS_P`n'd=OLS_P`n'_III if OLS_P`n'd==. & cant==99 & (year==1995 | year==2001 | year==2002)
quiet replace OLS_P`n'd=OLS_P`n'_II if OLS_P`n'd==. & cant==99 & (year==1999 | year==2000)
quiet replace OLS_P`n'd=OLS_P`n'_I if OLS_P`n'd==. & cant==99 & (year==1996 | year==1997 | year==1998)
}



*** *** *** *** *** *** *** *** *** *** *** *** *** *** *** 
 * B E T A   C O E F F I C I E N T S *
 
* Generate variables containing the Swiss and cantonal beta coefficients
foreach n in 90 95 99 995 999 9999 {
quietly gen OLS_b`n'=b`n' if cant==0
bysort year (OLS_b`n'): replace OLS_b`n'=OLS_b`n'[1]
label var OLS_b`n' "P`n''s beta, Switzerland (1995-2002 (incl.) replaced by OLS estimates)"
* Generate variables containing the Basel Stadt beta coefficients
quietly gen BS_b`n'=b`n' if cant==12
bysort year (BS_b`n'): replace BS_b`n'=BS_b`n'[1]
label var BS_b`n' "P`n''s beta, Basel City"
* Generate variables containing the ZH,TG beta coefficients
quietly gen ZHTG_b`n'=b`n' if cant==92
bysort year (ZHTG_b`n'): replace ZHTG_b`n'=ZHTG_b`n'[1]
label var ZHTG_b`n' "P`n''s beta, ZH and TG"
* Generate variables containing the VD, VS, TI beta coefficients
quietly gen VVT_b`n'=b`n' if cant==91
bysort year (VVT_b`n'): replace VVT_b`n'=VVT_b`n'[1]
label var VVT_b`n' "P`n''s beta, VD, VS and TI"
* Generate variables containing the 20 Cantons beta coefficients
quietly gen twenty_b`n'=b`n' if cant==93
bysort year (twenty_b`n'): replace twenty_b`n'=twenty_b`n'[1]
label var twenty_b`n' "P`n''s beta, 20 Cantons"
}


sort cant year

* regression models and prediction of the beta coefficients
foreach n in 90 95 99 995 999 9999 {
* model I
quiet xtreg OLS_b`n' BS_b`n' if cant==99, fe
quiet predict OLS_b`n'_I
label var OLS_b`n'_I "OLS prediction based on Model I: BS"
* model II
quiet xtreg OLS_b`n' BS_b`n'  ZHTG_b`n' if cant==99, fe
quiet predict OLS_b`n'_II
label var OLS_b`n'_II "OLS prediction based on Model II: BS, ZH&TG"
* model III
quiet xtreg OLS_b`n' BS_b`n'  ZHTG_b`n'  twenty_b`n' if cant==99, fe
quiet predict OLS_b`n'_III
label var OLS_b`n'_III "OLS prediction based on Model III: BS, ZH&TG, 20 cantons"
}

sort cant year

* replace predicted values of the beta coefficients
foreach n in 90 95 99 995 999 9999 {
quiet replace OLS_b`n'=OLS_b`n'_III if OLS_b`n'==. & cant==99 & (year==1995 | year==2001 | year==2002)
quiet replace OLS_b`n'=OLS_b`n'_II if OLS_b`n'==. & cant==99 & (year==1999 | year==2000)
quiet replace OLS_b`n'=OLS_b`n'_I if OLS_b`n'==. & cant==99 & (year==1996 | year==1997 | year==1998)
}


foreach n in 90 95 99 995 999 9999 {
replace P`n'd = OLS_P`n'd if P`n'd==. & cant==99
}

* drop the top income share series of the grouped cantons
drop BS_P90d BS_P95d BS_P99d BS_P995d BS_P999d BS_P9999d ZHTG_P90d ZHTG_P95d ZHTG_P99d ZHTG_P995d ZHTG_P999d ZHTG_P9999d VVT_P90d VVT_P95d VVT_P99d VVT_P995d VVT_P999d VVT_P9999d twenty_P90d twenty_P95d twenty_P99d twenty_P995d twenty_P999d twenty_P9999d OLS_b90 OLS_b95 OLS_b99 OLS_b995 OLS_b999 OLS_b9999 BS_b90 BS_b95 BS_b99 BS_b995 BS_b999 BS_b9999 ZHTG_b90 ZHTG_b95 ZHTG_b99 ZHTG_b995 ZHTG_b999 ZHTG_b9999 VVT_b90 VVT_b95 VVT_b99 VVT_b995 VVT_b999 VVT_b9999 twenty_b90 twenty_b95 twenty_b99 twenty_b995 twenty_b999 twenty_b9999



*** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** 
*** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** 

****** I M P U T A T I O N    U S I N G    C A N T O N    V A R I A N C E ******

* Generate the "98th" canton to run regressions with on a later stage
set obs 622
replace cant=98 in 595/622
label define cant 98 "Switzerland, imputation using cantonal variance", modify
replace year=_n+1386 in 595/622
drop if cant==.

// replace all the other variables for the new Switzerland by their value for Switzerland
foreach var in  total_taxunits total_adults tu_total inc_total alpha beta ///
P90d P95d P99d P995d P999d P9999d P10_5d P5_1d P10_1d ///
top10_within_top1 top1_within_top1 top10_within_top10 period income_denominator ///
b_60 k_60 b_70 k_70 b_80 k_80 b_90 k_90 b_100 k_100 b_120 k_120 b_150 k_150 ///
 b_200 k_200 b_300 k_300 b_400 k_400 b_500 k_500 b_1000 k_1000 b_2000 k_2000 ///
 ts90 inc_avg90 inc_abv90 b90 ts95 inc_avg95 inc_abv95 b95 ts99 inc_avg99 inc_abv99 b99 ///
 ts995 inc_avg995 inc_abv995 b995 ts999 inc_avg999 inc_abv999 b999 ts9999 inc_avg9999 inc_abv9999 b9999 {
bysort year (cant) : replace `var' = `var'[1] if cant==98 & `var'==.
}

* Generate variables containing the Swiss and cantonal Top Shares for each year
foreach n in 90 95 99 995 999 9999 {
quietly gen imp_P`n'd=P`n'd if cant==0
bysort year (imp_P`n'd): replace imp_P`n'd=imp_P`n'd[1]
label var imp_P`n'd "P`n''s income share, Switzerland (1995-2002 (incl.) replaced by imputed estimates)"

* Generate variables containing the BS,ZH,TG Top Shares
quietly gen BSZHTG_P`n'd=P`n'd if cant==105
bysort year (BSZHTG_P`n'd): replace BSZHTG_P`n'd=BSZHTG_P`n'd[1]
label var BSZHTG_P`n'd "P`n''s income share, BS, ZH and TG"
* Generate variables EXCLUDING the BS,ZH,TG Top Shares
quietly gen bszhtg_P`n'd=P`n'd if cant==104
bysort year (bszhtg_P`n'd): replace bszhtg_P`n'd=bszhtg_P`n'd[1]
label var bszhtg_P`n'd "P`n''s income share, whole CH excluding BS, ZH and TG"
* Generate variables EXCLUDING the VD,VS,TI Top Shares
quietly gen vvt_P`n'd=P`n'd if cant==102
bysort year (vvt_P`n'd): replace vvt_P`n'd=vvt_P`n'd[1]
label var vvt_P`n'd "P`n''s income share, whole CH excluding VD, VS and TI"
}

sort cant year
order cant year P90d P95d P99d P995d P999d P9999d ///
imp_P90d imp_P95d imp_P99d imp_P995d imp_P999d imp_P9999d ///
vvt_P90d vvt_P95d vvt_P99d vvt_P995d vvt_P999d vvt_P9999d ///
bszhtg_P90d bszhtg_P95d bszhtg_P99d bszhtg_P995d bszhtg_P999d bszhtg_P9999d ///
BSZHTG_P90d BSZHTG_P95d BSZHTG_P99d BSZHTG_P995d BSZHTG_P999d BSZHTG_P9999d ///
 total_taxunits total_adults tu_total inc_total alpha beta


****** I M P U T A T I O N   ******

foreach n in 90 95 99 995 999 9999 {
* 1)  Replace years 1995/96 & years 1997/98
replace imp_P`n'd = imp_P`n'd[_n-2]*bszhtg_P`n'd/bszhtg_P`n'd[_n-2] if year == 1995 & cant==98
replace imp_P`n'd = imp_P`n'd[_n-2]*bszhtg_P`n'd/bszhtg_P`n'd[_n-2] if year == 1997 & cant==98

* 2)  Replace years 1999,2000,2001,2002
replace imp_P`n'd = imp_P`n'd[_n+1]*vvt_P`n'd/vvt_P`n'd[_n+1] if year == 2002 & cant==98
replace imp_P`n'd = imp_P`n'd[_n+1]*vvt_P`n'd/vvt_P`n'd[_n+1] if year == 2001 & cant==98

replace imp_P`n'd = imp_P`n'd[_n+1]*BSZHTG_P`n'd/BSZHTG_P`n'd[_n+1] if year == 2000 & cant==98
replace imp_P`n'd = imp_P`n'd[_n+1]*BSZHTG_P`n'd/BSZHTG_P`n'd[_n+1] if year == 1999 & cant==98
}

foreach n in 90 95 99 995 999 9999 {
replace P`n'd = imp_P`n'd if P`n'd==. & cant==98
}

* drop the top income share series of the grouped cantons
drop BSZHTG_P9999d bszhtg_P995d vvt_P90d vvt_P95d vvt_P99d vvt_P995d vvt_P999d vvt_P9999d bszhtg_P90d bszhtg_P95d bszhtg_P99d bszhtg_P995d bszhtg_P999d bszhtg_P9999d BSZHTG_P90d BSZHTG_P95d BSZHTG_P99d BSZHTG_P995d BSZHTG_P999d BSZHTG_P9999d

*** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** 

* A D D   S Y N T H E T I C   C O N T R O L   E S T I M A T E S *

merge 1:m year cant using "$thepath/results/synthetic_control/synthetic_top_shares.dta"
drop _merge
sort cant year

merge 1:m year cant using "$thepath/results/synthetic_control/synthetic_betas.dta"
drop _merge
sort cant year


* replace the missing years with the synthetic control estimates
foreach n in 90 95 99 995 999 9999 {
replace P`n'd = synth_P`n'd if cant ==0 & P`n'd==. & year>=1995 & year<=2002
}

* replace intermediate shares 
replace P10_5d = P90d-P95d 
replace P5_1d = P95d-P99d 
replace P10_1d = P90d-P99d 

* replace shares within shares
replace top10_within_top1 = P999d/P99d 
replace top1_within_top1 = P9999d/P99d 
replace top10_within_top10 = P99d/P90d 


* FINISHING TOUCH: CALCULATION OF AVERAGE INCOMES, REAL VALUES ETC. 
* Calclulate "income denominator" and interpolate tu_total and inc_total for the missing years
// linearly interpolate total net income reported in tax statistics and total number of tax returnsv(tax units) reported in tax statistics
foreach var in tu_total inc_total {
bysort cant: ipolate `var' year, generate(`var'_ipol)
replace `var' = `var'_ipol if `var'==. & year>=1995 & year<=2002
}

// read-in total adult population and married adults
preserve
	import excel "$thepath/Population.xlsx", sheet("popstat_annual") cellrange(L1:P31) clear firstrow
	gen total_taxunits = total_taxunits_annual if year >=1995
	replace total_taxunits = total_taxunits_biennial if year <1995
	gen total_adults = total_adults_annual if year >=1995
	replace total_adults = total_adults_biennial if year <1995
	gen cant=0
	tempfile popstat1
	save "`popstat1'"
restore
merge 1:m year cant using  "`popstat1'", update nogen

// replace income denominator
replace income_denominator=inc_total *[1+ 0.2*((total_taxunits)/tu_total - 1)] if income_denominator==. & year>=1995 & year<=2002

* Generate again the total income of the top P`n' population
foreach n in 90 95 99 995 999 9999 {
quietly gen inc_abv`n'_2 = P`n'd*income_denominator
}

* Generate again the average income of the top P`n' population
quietly gen inc_avg90_2 = inc_abv90_2/(0.1*total_taxunits)
quietly gen inc_avg95_2 = inc_abv95_2/(0.05*total_taxunits)
quietly gen inc_avg99_2 = inc_abv99_2/(0.01*total_taxunits)
quietly gen inc_avg995_2 = inc_abv995_2/(0.005*total_taxunits)
quietly gen inc_avg999_2 = inc_abv999_2/(0.001*total_taxunits)
quietly gen inc_avg9999_2 = inc_abv9999_2/(0.0001*total_taxunits)

* Replace the average and total incomes where they were missing, drop the auxiliary variables
foreach n in 90 95 99 995 999 9999 {
format inc_abv`n' inc_avg`n' %15.0g
quietly replace inc_avg`n'=inc_avg`n'_2 if inc_avg`n'==.
quietly replace inc_abv`n'=inc_abv`n'_2 if inc_abv`n'==.
drop inc_avg`n'_2 inc_abv`n'_2
}

* Find again the thresholds to belong to the top P`n' income earners
foreach n in 90 95 99 995 999 9999{
replace b`n' = beta_P`n'_synth if b`n'==. & year>=1995 & year<=2002
quietly gen si_`n'=inc_avg`n'/b`n'
quietly label var si_`n' "Threshold to belong to the top P`n' income earners"
quietly replace ts`n'=si_`n' if ts`n'==.
quietly drop si_`n'
quietly drop beta_P`n'_synth
}

* Re-calculate the alpha and beta coefficients where they are missing
replace alpha=1/(1-log(P99d/P999d)/log(10)) if alpha==.
replace beta=alpha/(alpha-1) if beta==.


* Average income per adult and per tax unit
gen avg_inc_adult = income_denominator/total_adults
label var avg_inc_adult "Average nominal income per adult"
gen avg_inc_taxunit = income_denominator/total_taxunits
label var avg_inc_taxunit "Average nominal income per tax unit"


* Generate real values
// add cpi
preserve
	import excel "$thepath/Data.xlsx", sheet("CPI_1981-2010_stata") cellrange(A1:C31) clear firstrow
	gen CPI_00=.
	replace CPI_00=CPI_biennial if year<1995
	replace CPI_00=CPI_annual if year>=1995
	label var CPI_00 "CPI (base 2000), biennial before 1995, annual afterwards"
	gen cant=0
	tempfile myCPI
	save "`myCPI'"
restore

merge 1:m year cant using "`myCPI'", nogen

// gen real values
foreach var in ts90 ts95 ts99 ts995 ts999 ts9999 ///
inc_avg90 inc_avg95 inc_avg99 inc_avg995 inc_avg999 inc_avg9999 avg_inc_adult {
quietly gen `var'_real=`var'/CPI_00*100
local u : variable label `var'
display "`u'"
local l= "`u' (real)" 
label var `var'_real "`l'"
}

* Express some monetary variables in millions of CHF
foreach n in 90 95 99 995 999 9999 {
replace inc_abv`n'=inc_abv`n'/1000000
}
replace income_denominator = income_denominator/1000000

sort cant year
*** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** 
saveold "$thepath/4a_TopIncomeShares_CH_1981-2010.dta", version(12) replace
*** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** 

* GENERATE OUTPUT FOR TABLE 2: Growth in income shares of top gorups, 1981-2010

clear
cap clear matrix
cap log close
cap graph drop _all
version 14.1

use cant year P90d P99d P10_1d P995d P999d P9999d using "$thepath/4a_TopIncomeShares_CH_1981-2010.dta"
keep if cant==0
drop if P90d==.

sort year
foreach var in P90d P99d P10_1d P995d P999d P9999d {
gen `var'_gr  = (`var'/`var'[1]-1)*100
// max growth:
	egen `var'_gr_max = max(`var'_gr)
	gen `var'_maxgryear= year if `var'_gr_max==`var'_gr
	replace `var'_maxgryear= `var'_maxgryear[_n-1] if `var'_maxgryear==.
// avg. growth:
sort year
	gen `var'_avg_gr=`var'_gr[_N]/30
// variance:
sort cant year
	gen `var'_gr_annual = ((`var'-`var'[_n-1])/`var'[_n-1])*100
	egen `var'_gr_sd = sd(`var'_gr_annual)
	gen `var'_gr_variance = `var'_gr_sd^(2)
}

keep if year==2010
keep  *_gr *_avg_gr *_gr_variance  *_gr_max  *_maxgryear
order 	P90d_gr  P90d_gr_variance P90d_avg_gr  P90d_gr_max  P90d_maxgryear ///
		P10_1d_gr  P10_1d_gr_variance P10_1d_avg_gr  P10_1d_gr_max  P10_1d_maxgryear ///
		P99d_gr  P99d_gr_variance P99d_avg_gr  P99d_gr_max  P99d_maxgryear ///
		P995d_gr  P995d_gr_variance P995d_avg_gr  P995d_gr_max  P995d_maxgryear ///
		P999d_gr  P999d_gr_variance P999d_avg_gr  P999d_gr_max  P999d_maxgryear ///
		P9999d_gr  P9999d_gr_variance P9999d_avg_gr  P9999d_gr_max  P9999d_maxgryear
		

foreach var in P90d P99d P10_1d P995d P999d P9999d {
label var `var'_gr "Growth in income share since 1981, measured in 2010"
label var `var'_gr_variance "Variance in year-to-year (i.e., taxperiod-to-taxperiod) growth rates"
label var `var'_avg_gr "Growth p.a. over the 30 years 1981 to 2010 (=`var'_gr/30)"
label var `var'_gr_max "Maximum reached growth since 1981"
label var `var'_maxgryear "Year in which growth was maximal relative to income share in 1981"
}


// reshape to make an Excel-table
foreach var in P90d P99d P10_1d P995d P999d P9999d {
rename `var'_gr `var'_1
rename `var'_gr_variance `var'_2
rename `var'_avg_gr `var'_3
rename `var'_gr_max `var'_4
rename `var'_maxgryear `var'_5
}
gen cant=0
reshape long P90d_ P10_1d_ P99d_ P995d_ P999d_ P9999d_, i(cant) j(row)
drop cant

label var P90d_ 	"Top 10%"
label var P10_1d_ 	"Top 10-1%"
label var P99d_ 	"Top 1%"
label var P995d_ 	"Top 0.5%"
label var P999d_ 	"Top 0.1%"
label var P9999d_ 	"Top 0.01%"

gen rowname = 		"Growth" if row==1
replace rowname =	"Variance" if row==2
replace rowname =	"Growth p.a." if row==3
replace rowname =	"Max growth" if row==4
replace rowname =	"in year" if row==5
label var rowname "Top group:"
drop row
order rowname

// export to excel
export excel using "$thepath/results/table2.xlsx", firstrow(varlabels) cell(A1) sheetmodify

*** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** 




* GENERATE A DATASET INCLUDING THE EARLIER DATA FROM DELL ET AL. 2007 STARTING IN 1933

clear
cap clear matrix
cap log close
cap graph drop _all
version 14.0

* 0 some general data to merge later
//cpi biennial		
import excel "$thepath/Data.xlsx", sheet("CPI_1981-2010_stata") cellrange(A1:C31) clear firstrow
gen CPI_00=.
replace CPI_00=CPI_biennial if year<1995
replace CPI_00=CPI_annual if year>=1995
label var CPI_00 "CPI (base 2000), biennial before 1995, annual afterwards"
tempfile myCPI
save "`myCPI'"


//total tax units, adults, denominator, total income
// read-in total adult population and married adults
import excel "$thepath/Population.xlsx", sheet("popstat_annual") cellrange(L1:P31) clear firstrow
gen total_taxunits = total_taxunits_annual if year >=1995
replace total_taxunits = total_taxunits_biennial if year <1995
gen total_adults = total_adults_annual if year >=1995
replace total_adults = total_adults_biennial if year <1995

tempfile popstat
save "`popstat'"


* 1 Original data series for CH 1981-2008 
use "$thepath/4a_TopIncomeShares_CH_1981-2010.dta", clear
keep if cant==0
xtset cant year

keep cant year P90d P95d P99d P995d P999d P9999d total_taxunits total_adults tu_total inc_total ///
		inc_avg90 inc_avg95 inc_avg99 inc_avg995 inc_avg999 inc_avg9999  ///
		inc_abv90 inc_abv95 inc_abv99 inc_abv995 inc_abv999 inc_abv9999 ///
		ts90 ts95 ts99 ts995 ts999 ts9999 b90 b95 b99 b995 b999 b9999 alpha beta period ///
		P10_5d P5_1d P10_1d top10_within_top1 top1_within_top1 top10_within_top10 ///
		synth_P90d synth_P90d synth_P95d synth_P99d synth_P995d synth_P999d synth_P9999d 
		
merge 1:1 year using "`myCPI'", nogen
merge 1:1 year using  "`popstat'", update nogen

// claculate total income denominator, taking non-filers into account and assigning them 20% of average income
gen income_denominator=inc_total *[1+ 0.2*((total_taxunits)/tu_total - 1)]
format %15.0g income_denominator

order cant year P90d P95d P99d P995d P999d P9999d ///
		P10_5d P5_1d P10_1d top10_within_top1 top1_within_top1 top10_within_top10 ///
		ts90 ts95 ts99 ts995 ts999 ts9999  ///
		inc_avg90 inc_avg95 inc_avg99 inc_avg995 inc_avg999 inc_avg9999  ///
		inc_abv90 inc_abv95 inc_abv99 inc_abv995 inc_abv999 inc_abv9999 ///
		alpha beta  total_taxunits total_adults tu_total inc_total income_denominator CPI_00 ///
		synth_P90d synth_P90d synth_P95d synth_P99d synth_P995d synth_P999d synth_P9999d 



* ADD DATA FROM DELL ET AL. 2007 FOR THE YEARS 1933-1993drop if year < 1995
drop if year<1994
append using "$thepath/2c_TopShares_Dell_etal_1933-1993.dta"
foreach var in P90d P95d P99d P995d P999d P9999d {
replace `var' = `var'/100 if year< 1994
}

* FINISHING TOUCH: CALCULATION OF AVERAGE INCOMES, REAL VALUES ETC. 

* replace intermediate shares where missing
replace P10_5d = P90d-P95d if P10_5d==.
replace P5_1d = P95d-P99d if P5_1d==.
replace P10_1d = P90d-P99d if P10_1d==.

* replace shares within shares
replace top10_within_top1 = P999d/P99d if top10_within_top1==.
replace top1_within_top1 = P9999d/P99d if top1_within_top1==.
replace top10_within_top10 = P99d/P90d if top10_within_top10==.

* Generate again the total income of the top P`n' population
foreach n in 90 95 99 995 999 9999 {
quietly gen inc_abv`n'_2 = P`n'd*income_denominator
}

* Generate again the average income of the top P`n' population
quietly gen inc_avg90_2 = inc_abv90_2/(0.1*total_taxunits)
quietly gen inc_avg95_2 = inc_abv95_2/(0.05*total_taxunits)
quietly gen inc_avg99_2 = inc_abv99_2/(0.01*total_taxunits)
quietly gen inc_avg995_2 = inc_abv995_2/(0.005*total_taxunits)
quietly gen inc_avg999_2 = inc_abv999_2/(0.001*total_taxunits)
quietly gen inc_avg9999_2 = inc_abv9999_2/(0.0001*total_taxunits)

* Replace the average and total incomes where they were missing, drop the auxiliary variables
foreach n in 90 95 99 995 999 9999 {
format inc_abv`n' inc_avg`n' %15.0g
quietly replace inc_avg`n'=inc_avg`n'_2 if inc_avg`n'==.
quietly replace inc_abv`n'=inc_abv`n'_2 if inc_abv`n'==.
drop inc_avg`n'_2 inc_abv`n'_2
}

* Re-calculate the alpha and beta coefficients where they are missing
replace alpha=1/(1-log(P99d/P999d)/log(10)) if alpha==.
replace beta=alpha/(alpha-1) if beta==.


sort year
drop cant
*** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** 
note: Data before 1995 from Dell, Piketty, Saez (2007), from 1995 onwards: own calculations Foellmi Martinez (2016)
saveold "$thepath/4b_TopIncomeShares_CH_1933-2010.dta",version(12) replace
*** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** 

