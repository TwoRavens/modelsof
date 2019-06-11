
capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust]
	if ($i == 0) {
		global M = ""
		global test = ""
		estimates clear
		capture drop xxx*
		matrix B = J(1,100,.)
		global j = 0
		}
	global i = $i + 1

	gettoken testvars anything: anything, match(match)
	gettoken cmd anything: anything
	gettoken dep anything: anything
	foreach var in `testvars' {
		local anything = subinstr("`anything'","`var'","",1)
		}
	local newtestvars = ""
	foreach var in `testvars' {
		quietly gen xxx`var'$i = `var'
		local newtestvars = "`newtestvars'" + " " + "xxx`var'$i"
		}
	capture `cmd' `dep' `newtestvars' `anything' [`weight' `exp'] `if' `in'
	if (_rc == 0) {
		estimates store M$i
		foreach var in `newtestvars' {
			global j = $j + 1
			matrix B[1,$j] = _b[`var']
			}
		}
	global M = "$M" + " " + "M$i"
	global test = "$test" + " " + "`newtestvars'"

end

****************************************
****************************************

use DatFPPR, clear

global controls "sec_loanamount1 sec_loanamount2 sec_loanamount3 sec_loanamount4 sec_loanamount5 sec_loanamount6"
*All changes to controls to 0 have no effect (so drop that part of code - all miss_ are also identically zero)
global controls1 Age_C Married_C Muslim_C HH_Size_C Years_Education_C shock_any_C Has_Business_C Financial_Control_C homeowner_C sec_loanamount1 sec_loanamount2 sec_loanamount3 sec_loanamount5 sec_loanamount6 sec_loanamount7 No_Drain_C miss_Age_C miss_Married_C miss_Years_Education_C miss_shock_any_C miss_Financial_Control_C miss_homeowner_C miss_No_Drain_C
global controls2 Age_C Married_C Muslim_C HH_Size_C Years_Education_C shock_any_C Has_Business_C Financial_Control_C homeowner_C sec_loanamount1 sec_loanamount2 sec_loanamount3 sec_loanamount5 sec_loanamount6 sec_loanamount7 No_Drain_C miss_Age_C miss_Years_Education_C miss_shock_any_C miss_Financial_Control_C miss_homeowner_C miss_No_Drain_C
*Another specification where they drop the dummies by loan amount and substitute the loan amount
global controls3 Age_C Married_C Muslim_C HH_Size_C Years_Education_C shock_any_C Has_Business_C Financial_Control_C homeowner_C sec_loanamount No_Drain_C miss_Age_C miss_Years_Education_C miss_shock_any_C miss_Financial_Control_C miss_homeowner_C miss_No_Drain_C
*Specification where they drop Has_Business_C
global controls4 Age_C Married_C Muslim_C HH_Size_C Years_Education_C shock_any_C Financial_Control_C homeowner_C sec_loanamount No_Drain_C miss_Age_C miss_Years_Education_C miss_shock_any_C miss_Financial_Control_C miss_homeowner_C miss_No_Drain_C

*Dropping colinear outcomes

*Table 1
global i = 0
foreach X in Business_Expenditures Inventory_Raw_Mat Equipment Non_Business_Exp Repairs_Repair_Only Utilities_Taxes_Rent Human_Capital Re_Lent Savings Food_And_Durable New_Business_Ap15 {
	mycmd (sec_treat) regress `X' sec_treat Match3rd_in3rd SD2-SD9 $controls, cluster(sec_group_name)
	mycmd (sec_treat) regress `X' sec_treat Match3rd_in3rd SD2-SD9 $controls1, cluster(sec_group_name)
	}

suest $M, cluster(sec_group_name)
test $test
matrix F = r(p), r(drop), r(df), r(chi2), 1
matrix B1 = B[1,1..$j]

*Dropping colinear outcomes

*Table 2
global i = 0
foreach X in Profit ln_Q50 Capital Profit_TopCode ln_Q50_TopCode Capital_TopCode Profit_TopCode_1P ln_Q50_1P Capital_TopCode_1P Profit_TopCode_5P ln_Q50_5P {
	mycmd (sec_treat) regress `X' sec_treat SD2-SD9, cluster(sec_group_name)
	mycmd (sec_treat) regress `X' sec_treat SD2-SD9 SLO2-SLO5 $controls2, cluster(sec_group_name)
	}

suest $M, cluster(sec_group_name)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 2)
matrix B2 = B[1,1..$j]

*Table 3
global i = 0
foreach X in Late_Days_364 Late_Days_476 not_finished_aug19 Outstanding Fifty_Percent_Loan_Paid Made_First_11_Pay_On_Time Made_First_Pay {
	mycmd (sec_treat) regress `X' sec_treat SD2-SD9, cluster(sec_group_name)
	mycmd (sec_treat) regress `X' sec_treat SD2-SD9 SLO2-SLO5 Literate_C $controls1, cluster(sec_group_name)
	}

suest $M, cluster(sec_group_name)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 3)
matrix B3 = B[1,1..$j]

*Table 4
global i = 0
foreach X in atleastone_bizshutdown_alt Max_Min Q68 Q35_ Q37 Q11_Together_max {
	mycmd (sec_treat) regress `X' sec_treat SD2-SD9, cluster(sec_group_name)
	mycmd (sec_treat) regress `X' sec_treat SD2-SD9 SLO2-SLO5 Literate_C $controls1, cluster(sec_group_name)
	}

suest $M, cluster(sec_group_name)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 4)
matrix B4 = B[1,1..$j]

*Table 5 
foreach var in Risk_Loving Has_Savings_Acc_Apr24 Chronically_Ill Impatient No_Business_Broad Earns_Wage Heterogeneous {
	rename sec_treat_`var' sc`var'
	}

global i = 0
foreach Y in Profit Profit_TopCode {
	foreach X in Risk_Loving Has_Savings_Acc_Apr24 Chronically_Ill Impatient No_Business_Broad Earns_Wage Heterogeneous {
		mycmd (sec_treat sc`X') regress `Y' sec_treat sc`X' `X' SD2-SD9, cluster(sec_group_name)
		if "`X'" ~= "No_Business_Broad" {
			mycmd (sec_treat sc`X') regress `Y' sec_treat sc`X' `X' SD2-SD9 SLO2-SLO5 $controls3, cluster(sec_group_name)
			}
		else {
			mycmd (sec_treat sc`X') regress `Y' sec_treat sc`X' `X' SD2-SD9 SLO2-SLO5 $controls4, cluster(sec_group_name)
			}
		}
	}

suest $M, cluster(sec_group_name)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 5)
matrix B5 = B[1,1..$j]

generate Order = _n
sort sec_group_name Order
gen N = 1
gen Dif = (sec_group_name ~= sec_group_name[_n-1])
replace N = N[_n-1] + Dif if _n > 1
save aa, replace

drop if N == N[_n-1]
egen NN = max(N)
keep NN
generate obs = _n
save aaa, replace

mata ResF = J($reps,25,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using aa
	drop sec_group_name
	rename obs sec_group_name


*Table 1
global i = 0
foreach X in Business_Expenditures Inventory_Raw_Mat Equipment Non_Business_Exp Repairs_Repair_Only Utilities_Taxes_Rent Human_Capital Re_Lent Savings Food_And_Durable New_Business_Ap15 {
	mycmd (sec_treat) regress `X' sec_treat Match3rd_in3rd SD2-SD9 $controls, cluster(sec_group_name)
	mycmd (sec_treat) regress `X' sec_treat Match3rd_in3rd SD2-SD9 $controls1, cluster(sec_group_name)
	}

capture suest $M, cluster(sec_group_name)
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B1)*invsym(V)*(B[1,1..$j]-B1)'
		mata test = st_matrix("test"); ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', test[1,1], 1)
		}
	}

*Table 2
global i = 0
foreach X in Profit ln_Q50 Capital Profit_TopCode ln_Q50_TopCode Capital_TopCode Profit_TopCode_1P ln_Q50_1P Capital_TopCode_1P Profit_TopCode_5P ln_Q50_5P {
	mycmd (sec_treat) regress `X' sec_treat SD2-SD9, cluster(sec_group_name)
	mycmd (sec_treat) regress `X' sec_treat SD2-SD9 SLO2-SLO5 $controls2, cluster(sec_group_name)
	}

capture suest $M, cluster(sec_group_name)
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B2)*invsym(V)*(B[1,1..$j]-B2)'
		mata test = st_matrix("test"); ResF[`c',6..10] = (`r(p)', `r(drop)', `r(df)', test[1,1], 2)
		}
	}

*Table 3
global i = 0
foreach X in Late_Days_364 Late_Days_476 not_finished_aug19 Outstanding Fifty_Percent_Loan_Paid Made_First_11_Pay_On_Time Made_First_Pay {
	mycmd (sec_treat) regress `X' sec_treat SD2-SD9, cluster(sec_group_name)
	mycmd (sec_treat) regress `X' sec_treat SD2-SD9 SLO2-SLO5 Literate_C $controls1, cluster(sec_group_name)
	}

capture suest $M, cluster(sec_group_name)
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B3)*invsym(V)*(B[1,1..$j]-B3)'
		mata test = st_matrix("test"); ResF[`c',11..15] = (`r(p)', `r(drop)', `r(df)', test[1,1], 3)
		}
	}

*Table 4
global i = 0
foreach X in atleastone_bizshutdown_alt Max_Min Q68 Q35_ Q37 Q11_Together_max {
	mycmd (sec_treat) regress `X' sec_treat SD2-SD9, cluster(sec_group_name)
	mycmd (sec_treat) regress `X' sec_treat SD2-SD9 SLO2-SLO5 Literate_C $controls1, cluster(sec_group_name)
	}

capture suest $M, cluster(sec_group_name)
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B4)*invsym(V)*(B[1,1..$j]-B4)'
		mata test = st_matrix("test"); ResF[`c',16..20] = (`r(p)', `r(drop)', `r(df)', test[1,1], 4)
		}
	}

*Table 5 
global i = 0
foreach Y in Profit Profit_TopCode {
	foreach X in Risk_Loving Has_Savings_Acc_Apr24 Chronically_Ill Impatient No_Business_Broad Earns_Wage Heterogeneous {
		mycmd (sec_treat sc`X') regress `Y' sec_treat sc`X' `X' SD2-SD9, cluster(sec_group_name)
		if "`X'" ~= "No_Business_Broad" {
			mycmd (sec_treat sc`X') regress `Y' sec_treat sc`X' `X' SD2-SD9 SLO2-SLO5 $controls3, cluster(sec_group_name)
			}
		else {
			mycmd (sec_treat sc`X') regress `Y' sec_treat sc`X' `X' SD2-SD9 SLO2-SLO5 $controls4, cluster(sec_group_name)
			}
		}
	}

capture suest $M, cluster(sec_group_name)
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B5)*invsym(V)*(B[1,1..$j]-B5)'
		mata test = st_matrix("test"); ResF[`c',21..25] = (`r(p)', `r(drop)', `r(df)', test[1,1], 5)
		}
	}
}

drop _all
set obs $reps
forvalues i = 1/25 {
	quietly generate double ResF`i' = . 
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
save results\OBootstrapSuestFPPR, replace

erase aa.dta
erase aaa.dta

