
****************************************
****************************************

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
	local i = 0
	foreach var in `newtestvars' {
		matrix B[$j+`i',1] = _b[`var'], _se[`var']
		local i = `i' + 1
		}

	global M = "$M" + " " + "M$i"
	global test = "$test" + " " + "`newtestvars'"

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

matrix B = J(130,2,.)

global j = 1

*Table 1
global i = 0
foreach X in Business_Expenditures Inventory_Raw_Mat Equipment Other_Bus_Cost Non_Business_Exp Repairs_Repair_Only Utilities_Taxes_Rent Human_Capital Re_Lent Savings Food_And_Durable New_Business_Ap15 {
	mycmd (sec_treat) regress `X' sec_treat Match3rd_in3rd SD2-SD9 $controls, cluster(sec_group_name)
	mycmd (sec_treat) regress `X' sec_treat Match3rd_in3rd SD2-SD9 $controls1, cluster(sec_group_name)
	}

quietly suest $M, cluster(sec_group_name)
test $test
matrix F = (r(p), r(drop), r(df), r(chi2), 1)

*Table 2
global i = 0
foreach X in Profit ln_Q50 Capital Profit_TopCode ln_Q50_TopCode Capital_TopCode Profit_TopCode_1P ln_Q50_1P Capital_TopCode_1P Profit_TopCode_5P ln_Q50_5P Capital_TopCode_5P {
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
 
drop _all
svmat double F
svmat double B
save results/SuestFPPR, replace






