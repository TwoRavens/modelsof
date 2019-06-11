**********************************************************************************
* Analyzes the results that Souphala sent on Feb 12, 2015
**********************************************************************************

set more off
clear all
set maxvar 11000
set matsize 11000

*************************
* Where data lies
*************************

cap cd ""

***************************************
***************************************
* TABLE 1 
***************************************
***************************************

use "Data`c(dirsep)'RD_Estimates_CL_Loop.dta", clear

rename b_cl_cv* b_cv_cl*

rename *_mean *
keep avg1* b_cv* freq1 fico_coarse_2 

ds *
foreach var of varlist `r(varlist)' {
 cap gen sd_`var' = `var'
}

************************
* Stuff weighted by freq	
************************

tempfile temp1
tempfile temp2
tempfile temp3
tempfile temp4

save `temp1'

collapse (mean) avg1* b_cv* (sd) sd_avg1* sd_b_cv*, by(fico_coarse_2)
rename *totpurvol* *totpv*
reshape long avg1_ b_cv_ sd_avg1_ sd_b_cv_, i(fico_coarse_2) j(var) string
save `temp2'

use `temp1', clear
collapse (mean) avg1* b_cv* (sd) sd_avg1* sd_b_cv*
rename *totpurvol* *totpv*
gen fico_coarse_2 = 0
reshape long avg1_ b_cv_ sd_avg1_ sd_b_cv_, i(fico_coarse_2) j(var) string
save `temp3'

append using `temp2'

drop if strpos(var,"_f") != 0 & var != "_freq_"
drop if strpos(var,"_p") != 0
drop if strpos(var,"_censoring") != 0
drop if strpos(var,"behav") != 0
drop if strpos(var,"income") != 0
drop if strpos(var,"rate_c") != 0

replace var = "z_freq" if var  == "_freq_"
sort var fico_coarse_2 

order fico_coarse_2 var avg1_ sd_avg1_ b_cv_ sd_b_cv_
br


***************************************
***************************************
* TABLE 2
***************************************
***************************************

use "Data`c(dirsep)'RD_Estimates_CL_Loop.dta", clear

cap rename *total* *tot*

cap drop fico_coarse_2
gen      fico_coarse_2 = .
replace  fico_coarse_2 = 1 if fico1 <= 660
replace  fico_coarse_2 = 2 if fico1 >  660 & fico1 <= 700
replace  fico_coarse_2 = 3 if fico1 >  700 & fico1 < 740
replace  fico_coarse_2 = 4 if fico1 >= 740 


gen new = avg1_intbrdt_f48_mean + avg1_float_f48_mean
gen delta = abs(new - avg1_avgdailybal_f48_mean)/avg1_avgdailybal_f48_mean

keep *avg1* freq1 fico_coarse_2

forval i = 12(12)60 {
	replace avg1_intbrdt_f`i'_mean = . if avg1_avgdailybal_f`i'_mean	== .
	replace avg1_float_f`i'_mean   = . if avg1_avgdailybal_f`i'_mean	== .
}
	
ds fico_coarse_2, not

collapse (mean) `r(varlist)', by(fico_coarse_2)

reshape long avg1_ , i(fico_coarse_2) j(varname) string

gen     ordervar = .
replace ordervar = 1 if varname == "currcredlimit_f1_mean"
replace ordervar = 2 if varname == "currcredlimit_f12_mean"
replace ordervar = 3 if varname == "currcredlimit_f24_mean"
replace ordervar = 4 if varname == "currcredlimit_f36_mean"
replace ordervar = 5 if varname == "currcredlimit_f48_mean"
replace ordervar = 6 if varname == "currcredlimit_f60_mean"
replace ordervar = 7 if varname == "bccl_f1_mean"
replace ordervar = 8 if varname == "bccl_f4_mean"
replace ordervar = 9 if varname == "bccl_f8_mean"
replace ordervar = 10 if varname == "bccl_f12_mean"
replace ordervar = 11 if varname == "bccl_f16_mean"
replace ordervar = 12 if varname == "bccl_f20_mean"
replace ordervar = 13 if varname == "avgdailybal_f12_mean"
replace ordervar = 14 if varname == "avgdailybal_f24_mean"
replace ordervar = 15 if varname == "avgdailybal_f36_mean"
replace ordervar = 16 if varname == "avgdailybal_f48_mean"
replace ordervar = 17 if varname == "avgdailybal_f60_mean"
replace ordervar = 18 if varname == "bcbal_f4_mean"
replace ordervar = 19 if varname == "bcbal_f8_mean"
replace ordervar = 20 if varname == "bcbal_f12_mean"
replace ordervar = 21 if varname == "bcbal_f16_mean"
replace ordervar = 22 if varname == "bcbal_f20_mean"
replace ordervar = 23 if varname == "totpurvol_po12_mean"
replace ordervar = 24 if varname == "totpurvol_po24_mean"
replace ordervar = 25 if varname == "totpurvol_po36_mean"
replace ordervar = 26 if varname == "totpurvol_po48_mean"
replace ordervar = 27 if varname == "totpurvol_po60_mean"
replace ordervar = 28 if varname == "evdpd60p_po12_mean"
replace ordervar = 29 if varname == "evdpd60p_po24_mean"
replace ordervar = 30 if varname == "evdpd60p_po36_mean"
replace ordervar = 31 if varname == "evdpd60p_po48_mean"
replace ordervar = 32 if varname == "evdpd60p_po60_mean"
replace ordervar = 33 if varname == "totchgoffamt_po12_mean"
replace ordervar = 34 if varname == "totchgoffamt_po24_mean"
replace ordervar = 35 if varname == "totchgoffamt_po36_mean"
replace ordervar = 36 if varname == "totchgoffamt_po48_mean"
replace ordervar = 37 if varname == "totchgoffamt_po60_mean"
replace ordervar = 38 if varname == "cost_po12"
replace ordervar = 39 if varname == "cost_po24"
replace ordervar = 40 if varname == "cost_po36"
replace ordervar = 41 if varname == "cost_po48"
replace ordervar = 42 if varname == "cost_po60"
replace ordervar = 43 if varname == "totfees_po12_mean"
replace ordervar = 44 if varname == "totfees_po24_mean"
replace ordervar = 45 if varname == "totfees_po36_mean"
replace ordervar = 46 if varname == "totfees_po48_mean"
replace ordervar = 47 if varname == "totfees_po72_mean"
replace ordervar = 48 if varname == "totfinchg_po12_mean"
replace ordervar = 49 if varname == "totfinchg_po24_mean"
replace ordervar = 50 if varname == "totfinchg_po36_mean"
replace ordervar = 51 if varname == "totfinchg_po48_mean"
replace ordervar = 52 if varname == "totfinchg_po60_mean"
replace ordervar = 53 if varname == "income_po12"
replace ordervar = 54 if varname == "income_po24"
replace ordervar = 55 if varname == "income_po36"
replace ordervar = 56 if varname == "income_po48"
replace ordervar = 57 if varname == "income_po60"
replace ordervar = 58 if varname == "netincome_po12"
replace ordervar = 59 if varname == "netincome_po24"
replace ordervar = 60 if varname == "netincome_po36"
replace ordervar = 61 if varname == "netincome_po48"
replace ordervar = 62 if varname == "netincome_po60"
replace ordervar = 63 if varname == "totcof_po12_mean"
replace ordervar = 64 if varname == "totcof_po24_mean"
replace ordervar = 65 if varname == "totcof_po36_mean"
replace ordervar = 66 if varname == "totcof_po48_mean"
replace ordervar = 67 if varname == "totcof_po60_mean"
replace ordervar = 68 if varname == "evdpd90p_po12_mean"
replace ordervar = 69 if varname == "evdpd90p_po24_mean"
replace ordervar = 70 if varname == "evdpd90p_po36_mean"
replace ordervar = 71 if varname == "evdpd90p_po48_mean"
replace ordervar = 72 if varname == "evdpd90p_po60_mean"
replace ordervar = 73 if varname == "doesborrow_12mo_mean"
replace ordervar = 74 if varname == "doesborrow_24mo_mean"
replace ordervar = 75 if varname == "doesborrow_36mo_mean"
replace ordervar = 76 if varname == "doesborrow_48mo_mean"
replace ordervar = 76 if varname == "doesborrow_60mo_mean"
replace ordervar = 77 if varname == "intbrdt_f12_mean"
replace ordervar = 78 if varname == "intbrdt_f24_mean"
replace ordervar = 79 if varname == "intbrdt_f36_mean"
replace ordervar = 80 if varname == "intbrdt_f48_mean"
replace ordervar = 81 if varname == "intbrdt_f60_mean"
replace ordervar = 82 if varname == "float_f12_mean"
replace ordervar = 83 if varname == "float_f24_mean"
replace ordervar = 84 if varname == "float_f36_mean"
replace ordervar = 85 if varname == "float_f48_mean"
replace ordervar = 86 if varname == "float_f60_mean"

drop if ordervar == .
drop freq1

reshape wide avg1_, i(varname) j(fico_coarse_2) 

sort ordervar
br
