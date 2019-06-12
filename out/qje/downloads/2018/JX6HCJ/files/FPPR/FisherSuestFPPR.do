

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) ]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")

	if ($i == 0) {
		global M = ""
		global test = ""
		capture drop yyy* xxx* Ssample*
		estimates clear
		}
	global i = $i + 1

	gettoken cmd anything: anything
	gettoken dep anything: anything
	foreach var in `testvars' {
		local anything = subinstr("`anything'","`var'","",1)
		}
	quietly reg `dep' `testvars' `anything' `if' `in', 
	quietly generate Ssample$i = e(sample)
	quietly reg `dep' `anything' if Ssample$i, 
	quietly predict double yyy$i if Ssample$i, resid
	local newtestvars = ""
	foreach var in `testvars' {
		quietly reg `var' `anything' if Ssample$i, 
		quietly predict double xxx`var'$i if Ssample$i, resid
		local newtestvars = "`newtestvars'" + " " + "xxx`var'$i"
		}
	quietly reg yyy$i `newtestvars', noconstant
	estimates store M$i
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

*dropping colinear outcomes

*Table 1
global i = 0
*foreach X in Business_Expenditures Inventory_Raw_Mat Equipment Other_Bus_Cost Non_Business_Exp Repairs_Repair_Only Utilities_Taxes_Rent Human_Capital Re_Lent Savings Food_And_Durable New_Business_Ap15 {
foreach X in Business_Expenditures Inventory_Raw_Mat Equipment Non_Business_Exp Repairs_Repair_Only Utilities_Taxes_Rent Human_Capital Re_Lent Savings Food_And_Durable New_Business_Ap15 {
	mycmd (sec_treat) regress `X' sec_treat Match3rd_in3rd SD2-SD9 $controls, cluster(sec_group_name)
	mycmd (sec_treat) regress `X' sec_treat Match3rd_in3rd SD2-SD9 $controls1, cluster(sec_group_name)
	}

quietly suest $M, cluster(sec_group_name)
test $test
matrix F = (r(p), r(drop), r(df), r(chi2), 1)

*dropping colinear outcomes

*Table 2
global i = 0
*foreach X in Profit ln_Q50 Capital Profit_TopCode ln_Q50_TopCode Capital_TopCode Profit_TopCode_1P ln_Q50_1P Capital_TopCode_1P Profit_TopCode_5P ln_Q50_5P Capital_TopCode_5P {
foreach X in Profit ln_Q50 Capital Profit_TopCode ln_Q50_TopCode Capital_TopCode Profit_TopCode_1P ln_Q50_1P Capital_TopCode_1P Profit_TopCode_5P ln_Q50_5P {
	mycmd (sec_treat) regress `X' sec_treat SD2-SD9, cluster(sec_group_name)
	mycmd (sec_treat) regress `X' sec_treat SD2-SD9 SLO2-SLO5 $controls2, cluster(sec_group_name)
	}

quietly suest $M, cluster(sec_group_name)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 2)

*Table 3
global i = 0
foreach X in Late_Days_364 Late_Days_476 not_finished_aug19 Outstanding Fifty_Percent_Loan_Paid Made_First_11_Pay_On_Time Made_First_Pay {
	mycmd (sec_treat) regress `X' sec_treat SD2-SD9, cluster(sec_group_name)
	mycmd (sec_treat) regress `X' sec_treat SD2-SD9 SLO2-SLO5 Literate_C $controls1, cluster(sec_group_name)
	}

quietly suest $M, cluster(sec_group_name)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 3)

*Table 4
global i = 0
foreach X in atleastone_bizshutdown_alt Max_Min Q68 Q35_ Q37 Q11_Together_max {
	mycmd (sec_treat) regress `X' sec_treat SD2-SD9, cluster(sec_group_name)
	mycmd (sec_treat) regress `X' sec_treat SD2-SD9 SLO2-SLO5 Literate_C $controls1, cluster(sec_group_name)
	}

quietly suest $M, cluster(sec_group_name)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 4)

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

quietly suest $M, cluster(sec_group_name)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 5)

sort sec_group_name
by sec_group_name: gen N = _n
sort N Stratification_Dummies sec_group_name
global N = 169
generate Order = _n
generate double U = .
mata Y = st_data((1,$N),"sec_treat")

mata ResF = J($reps,25,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort N Stratification_Dummies U in 1/$N
	mata st_store((1,$N),"sec_treat",Y)
	sort sec_group_name N
	quietly replace sec_treat = sec_treat[_n-1] if N > 1 & sec_group_name == sec_group_name[_n-1]
	foreach X in Impatient Risk_Loving Earns_Wage Chronically_Ill No_Business_Broad Has_Savings_Acc_Apr24 Heterogeneous {
		quietly replace sc`X' = sec_treat*`X'
		}

*Table 1
global i = 0
foreach X in Business_Expenditures Inventory_Raw_Mat Equipment Non_Business_Exp Repairs_Repair_Only Utilities_Taxes_Rent Human_Capital Re_Lent Savings Food_And_Durable New_Business_Ap15 {
	mycmd (sec_treat) regress `X' sec_treat Match3rd_in3rd SD2-SD9 $controls, cluster(sec_group_name)
	mycmd (sec_treat) regress `X' sec_treat Match3rd_in3rd SD2-SD9 $controls1, cluster(sec_group_name)
	}

capture suest $M, cluster(sec_group_name)
if (_rc == 0) {
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 1)
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
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',6..10] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 2)
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
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',11..15] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 3)
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
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',16..20] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 4)
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
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',21..25] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 5)
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
sort N
save results\FisherSuestFPPR, replace




