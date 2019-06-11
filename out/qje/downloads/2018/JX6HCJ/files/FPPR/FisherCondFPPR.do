
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	`anything' `if' `in', cluster(`cluster')
	capture testparm `testvars'
	if (_rc == 0) {
		matrix F[$i,1] = r(p), r(drop), e(df_r), $k
		local i = 0
		foreach var in `testvars' {
			matrix B[$j+`i',1] = _b[`var'], _se[`var']
			local i = `i' + 1
			}
		}
global i = $i + 1
global j = $j + $k
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

matrix F = J(102,4,.)
matrix B = J(130,2,.)

global i = 1
global j = 1

*Table 1
foreach X in Business_Expenditures Inventory_Raw_Mat Equipment Other_Bus_Cost Non_Business_Exp Repairs_Repair_Only Utilities_Taxes_Rent Human_Capital Re_Lent Savings Food_And_Durable New_Business_Ap15 {
	mycmd (sec_treat) regress `X' sec_treat Match3rd_in3rd SD2-SD9 $controls, cluster(sec_group_name)
	mycmd (sec_treat) regress `X' sec_treat Match3rd_in3rd SD2-SD9 $controls1, cluster(sec_group_name)
	}

*Table 2
foreach X in Profit ln_Q50 Capital Profit_TopCode ln_Q50_TopCode Capital_TopCode Profit_TopCode_1P ln_Q50_1P Capital_TopCode_1P Profit_TopCode_5P ln_Q50_5P Capital_TopCode_5P {
	mycmd (sec_treat) regress `X' sec_treat SD2-SD9, cluster(sec_group_name)
	mycmd (sec_treat) regress `X' sec_treat SD2-SD9 SLO2-SLO5 $controls2, cluster(sec_group_name)
	}


*Table 3
foreach X in Late_Days_364 Late_Days_476 not_finished_aug19 Outstanding Fifty_Percent_Loan_Paid Made_First_11_Pay_On_Time Made_First_Pay {
	mycmd (sec_treat) regress `X' sec_treat SD2-SD9, cluster(sec_group_name)
	mycmd (sec_treat) regress `X' sec_treat SD2-SD9 SLO2-SLO5 Literate_C $controls1, cluster(sec_group_name)
	}

*Table 4
foreach X in atleastone_bizshutdown_alt Max_Min Q68 Q35_ Q37 Q11_Together_max {
	mycmd (sec_treat) regress `X' sec_treat SD2-SD9, cluster(sec_group_name)
	mycmd (sec_treat) regress `X' sec_treat SD2-SD9 SLO2-SLO5 Literate_C $controls1, cluster(sec_group_name)
	}

*Table 5 
foreach Y in Profit Profit_TopCode {
	foreach X in Risk_Loving Has_Savings_Acc_Apr24 Chronically_Ill Impatient No_Business_Broad Earns_Wage Heterogeneous {
		mycmd (sec_treat sec_treat_`X') regress `Y' sec_treat sec_treat_`X' `X' SD2-SD9, cluster(sec_group_name)
		if "`X'" ~= "No_Business_Broad" {
			mycmd (sec_treat sec_treat_`X') regress `Y' sec_treat sec_treat_`X' `X' SD2-SD9 SLO2-SLO5 $controls3, cluster(sec_group_name)
			}
		else {
			mycmd (sec_treat sec_treat_`X') regress `Y' sec_treat sec_treat_`X' `X' SD2-SD9 SLO2-SLO5 $controls4, cluster(sec_group_name)
			}
		}
	}


global i = 0

*Table 1
foreach X in Business_Expenditures Inventory_Raw_Mat Equipment Other_Bus_Cost Non_Business_Exp Repairs_Repair_Only Utilities_Taxes_Rent Human_Capital Re_Lent Savings Food_And_Durable New_Business_Ap15 {
	global i = $i + 1
	randcmdc ((sec_treat) regress `X' sec_treat Match3rd_in3rd SD2-SD9 $controls, cluster(sec_group_name)), treatvars(sec_treat) strata(Stratification_Dummies) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(sec_group_name) 
	global i = $i + 1
	randcmdc ((sec_treat) regress `X' sec_treat Match3rd_in3rd SD2-SD9 $controls1, cluster(sec_group_name)), treatvars(sec_treat) strata(Stratification_Dummies) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(sec_group_name) 
	}

*Table 2
foreach X in Profit ln_Q50 Capital Profit_TopCode ln_Q50_TopCode Capital_TopCode Profit_TopCode_1P ln_Q50_1P Capital_TopCode_1P Profit_TopCode_5P ln_Q50_5P Capital_TopCode_5P {
	global i = $i + 1
	randcmdc ((sec_treat) regress `X' sec_treat SD2-SD9, cluster(sec_group_name)), treatvars(sec_treat) strata(Stratification_Dummies) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(sec_group_name) 
	global i = $i + 1
	randcmdc ((sec_treat) regress `X' sec_treat SD2-SD9 SLO2-SLO5 $controls2, cluster(sec_group_name)), treatvars(sec_treat) strata(Stratification_Dummies) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(sec_group_name) 
	}

*Table 3
foreach X in Late_Days_364 Late_Days_476 not_finished_aug19 Outstanding Fifty_Percent_Loan_Paid Made_First_11_Pay_On_Time Made_First_Pay {
	global i = $i + 1
	randcmdc ((sec_treat) regress `X' sec_treat SD2-SD9, cluster(sec_group_name)), treatvars(sec_treat) strata(Stratification_Dummies) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(sec_group_name) 
	global i = $i + 1
	randcmdc ((sec_treat) regress `X' sec_treat SD2-SD9 SLO2-SLO5 Literate_C $controls1, cluster(sec_group_name)), treatvars(sec_treat) strata(Stratification_Dummies) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(sec_group_name) 
	}

*Table 4
foreach X in atleastone_bizshutdown_alt Max_Min Q68 Q35_ Q37 Q11_Together_max {
	global i = $i + 1
	randcmdc ((sec_treat) regress `X' sec_treat SD2-SD9, cluster(sec_group_name)), treatvars(sec_treat) strata(Stratification_Dummies) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(sec_group_name) 
	global i = $i + 1
	randcmdc ((sec_treat) regress `X' sec_treat SD2-SD9 SLO2-SLO5 Literate_C $controls1, cluster(sec_group_name)), treatvars(sec_treat) strata(Stratification_Dummies) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(sec_group_name) 
	}

*Table 5 
	forvalues j = 1/56 {
		global i = $i + 1
		preserve
			drop _all
			set obs $reps
			foreach var in ResB ResSE ResF {
				gen `var' = .
				}
			gen __0000001 = 0 if _n == 1
			gen __0000002 = 0 if _n == 1
			save ip\a$i, replace
		restore
		}


matrix T = J($i,2,.)
use ip\a1, clear
mkmat __* in 1/1, matrix(a)
drop __*
matrix T[1,1] = a
rename ResB ResB1
rename ResSE ResSE1
rename ResF ResF1
forvalues i = 2/$i {
	merge using ip\a`i'
	mkmat __* in 1/1, matrix(a)
	drop __* _m
	matrix T[`i',1] = a
	rename ResB ResB`i'
	rename ResSE ResSE`i'
	rename ResF ResF`i'
	}
svmat double F
svmat double B
svmat double T
gen N = _n
sort N
compress
aorder
save results\FisherCondFPPR, replace


