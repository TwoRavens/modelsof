
*Summary:

*Table 1 doesn't include loan officer fixed fixed effects (although says does), includes unmentioned variable Match3rd_in3rd in all specifications
*Remaining tables do include loan officer fixed effects (with expanded controls), but never have Match3rd_in3rd
*Tables 3 and 4 add Literate_C as an additional control (not used in other tables, doesn't appear in Appendix 1 panel A - paper explains these appendix variables are in the specification)
*Table 5 drops dummies by loan amount and simply uses loan amount (dummies by loan amount are the variables in Appendix 1 panel A which are supposed to be used in all specifications)
*Table 5 drops Has_Business_C for No_Business_Broad regression (understandable)

*************************************

*Their code (shortened somewhat) 

*Table 1 - All okay, except that table says include loan officer fixed effects in regressions with additional controls and, in fact, do not.
*Also, includes unmentioned variable Match3rd_in3rd

use "Grace Period Data.dta", clear
tab sec_loanamount, gen(sec_loanamount)
forvalues i=1/7 {
	gen miss_sec_loanamount`i' = 0
	replace miss_sec_loanamount`i' = 1 if sec_loanamount == .
	}
local controls sec_loanamount1 sec_loanamount2 sec_loanamount3 sec_loanamount4 sec_loanamount5 sec_loanamount6 
local miss_controls
	foreach var of varlist `controls' {
		local miss_controls `miss_controls' miss_`var'
	}
local controls_and_miss `controls' `miss_controls'

foreach X in Business_Expenditures  Inventory_Raw_Mat Equipment  Other_Bus_Cost Non_Business_Exp  Repairs_Repair_Only Utilities_Taxes_Rent Human_Capital Re_Lent Savings Food_And_Durable New_Business_Ap15 {
	xi: regress `X' sec_treat Match3rd_in3rd i.Stratification_Dummies `controls_and_miss', cluster(sec_group_name)
	}

local controls Age_C Married_C  Muslim_C HH_Size_C Years_Education_C shock_any_C  Has_Business_C Financial_Control_C homeowner_C  sec_loanamount1 sec_loanamount2 sec_loanamount3  sec_loanamount5 sec_loanamount6 sec_loanamount7 No_Drain_C
foreach var in `controls' {
	replace `var' = 0 if miss_`var' == 1
	}
local controls Age_C Married_C  Muslim_C HH_Size_C Years_Education_C shock_any_C  Has_Business_C Financial_Control_C homeowner_C  sec_loanamount1 sec_loanamount2 sec_loanamount3  sec_loanamount5 sec_loanamount6 sec_loanamount7 No_Drain_C
local miss_controls
foreach var of varlist `controls' {
	local miss_controls `miss_controls' miss_`var'
}
local controls_and_miss `controls' `miss_controls'

foreach X in Business_Expenditures  Inventory_Raw_Mat Equipment  Other_Bus_Cost Non_Business_Exp  Repairs_Repair_Only Utilities_Taxes_Rent Human_Capital Re_Lent Savings Food_And_Durable New_Business_Ap15 {	
	xi: regress `X' sec_treat Match3rd_in3rd i.Stratification_Dummies `controls_and_miss', cluster(sec_group_name)
	}


*******************************

*Table 2 - All okay - This regression adds loan officer fixed effects (stated for Table 1, but actually entered in Table 2)
*They now drop the variables Match3rd used earlier in Table 1 (don't use further below either)

use "Grace Period Data.dta", clear

*Panel A

tab sec_loanamount, gen(sec_loanamount)
forvalues i=1/7{
	gen miss_sec_loanamount`i' = 0
	replace miss_sec_loanamount`i' = 1 if sec_loanamount == .
	}
duplicates drop slid, force
* Make sure missings are 0 not averages (missing controls coded as "." only in Table 1)
local controls Age_C Married_C  Muslim_C HH_Size_C Years_Education_C shock_any_C  Has_Business_C Financial_Control_C homeowner_C  sec_loanamount1 sec_loanamount2 sec_loanamount3  sec_loanamount5 sec_loanamount6 sec_loanamount7 No_Drain_C
foreach var in `controls' {
	replace `var' = 0 if miss_`var' == 1
	}
local controls Age_C Married_C  Muslim_C HH_Size_C Years_Education_C shock_any_C  Has_Business_C Financial_Control_C homeowner_C  sec_loanamount1 sec_loanamount2 sec_loanamount3  sec_loanamount5 sec_loanamount6 sec_loanamount7 No_Drain_C
local miss_controls
foreach var of varlist `controls' {
	local miss_controls `miss_controls' miss_`var'
	}
local controls_and_miss `controls' `miss_controls'

foreach X in Profit ln_Q50 Capital {
	foreach specification in "sec_treat i.Stratification_Dummies" "sec_treat i.Stratification_Dummies i.sec_loan_officer `controls_and_miss'" {
		xi: regress `X' `specification', cluster(sec_group_name)
	}
}

*Panel B

local controls Age_C Married_C  Muslim_C HH_Size_C Years_Education_C shock_any_C  Has_Business_C Financial_Control_C homeowner_C  sec_loanamount1 sec_loanamount2 sec_loanamount3  sec_loanamount5 sec_loanamount6 sec_loanamount7 No_Drain_C
foreach var in `controls' {
	replace `var' = 0 if miss_`var' == 1
	}
local controls Age_C Married_C  Muslim_C HH_Size_C Years_Education_C shock_any_C  Has_Business_C Financial_Control_C homeowner_C  sec_loanamount1 sec_loanamount2 sec_loanamount3  sec_loanamount5 sec_loanamount6 sec_loanamount7 No_Drain_C
local miss_controls
foreach var of varlist `controls' {
	local miss_controls `miss_controls' miss_`var'
	}
local controls_and_miss `controls' `miss_controls'

foreach X in  Profit_TopCode ln_Q50_TopCode Capital_TopCode {
	foreach specification in "sec_treat i.Stratification_Dummies" "sec_treat i.Stratification_Dummies i.sec_loan_officer `controls_and_miss'" {
		xi: regress `X' `specification', cluster(sec_group_name)
		}
	}

*Panel C

local controls Age_C Married_C  Muslim_C HH_Size_C Years_Education_C shock_any_C  Has_Business_C Financial_Control_C homeowner_C  sec_loanamount1 sec_loanamount2 sec_loanamount3  sec_loanamount5 sec_loanamount6 sec_loanamount7 No_Drain_C
local miss_controls
	foreach var of varlist `controls' {
	local miss_controls `miss_controls' miss_`var'
	}
local controls_and_miss `controls' `miss_controls'

foreach X in Profit_TopCode_1P ln_Q50_1P Capital_TopCode_1P {
	foreach specification in "sec_treat i.Stratification_Dummies" "sec_treat i.Stratification_Dummies i.sec_loan_officer `controls_and_miss'" {
		xi: regress `X' `specification', cluster(sec_group_name)
		}
	}

*Panel D

local controls Age_C Married_C  Muslim_C HH_Size_C Years_Education_C shock_any_C  Has_Business_C Financial_Control_C homeowner_C  sec_loanamount1 sec_loanamount2 sec_loanamount3  sec_loanamount5 sec_loanamount6 sec_loanamount7 No_Drain_C
local miss_controls
foreach var of varlist `controls' {
	local miss_controls `miss_controls' miss_`var'
	}
local controls_and_miss `controls' `miss_controls'

foreach X in Profit_TopCode_5P  ln_Q50_5P Capital_TopCode_5P {
	foreach specification in "sec_treat i.Stratification_Dummies" "sec_treat i.Stratification_Dummies i.sec_loan_officer `controls_and_miss'" {
		xi: regress `X' `specification', cluster(sec_group_name)
		}
	}

**********************************

*Table 3 - All okay - This table adds an additional control (Literate_C miss_Literate_C) not used in the previous tables, and not mentioned in pub.

use "Grace Period Data.dta", clear

local defaultvars  Late_Days_364  Late_Days_476 not_finished_aug19 Outstanding Fifty_Percent_Loan_Paid  Made_First_11_Pay_On_Time Made_First_Pay
local specifications  "sec_treat i.Stratification"

foreach X in Late_Days_364  Late_Days_476 not_finished_aug19 Outstanding Fifty_Percent_Loan_Paid  Made_First_11_Pay_On_Time Made_First_Pay {
		 xi: regress `X' sec_treat i.Stratification, cluster(sec_group_name)
	}


tab sec_loanamount, gen(sec_loanamount)
forvalues i=1/7 {
	gen miss_sec_loanamount`i' = 0
	replace miss_sec_loanamount`i' = 1 if sec_loanamount == .
	}
duplicates drop slid, force

* Make sure missings are 0 not averages (missing controls coded as "." only in Table 1)
local risk Age_C Married_C Literate_C Muslim_C HH_Size_C Years_Education_C shock_any_C  Has_Business_C Financial_Control_C homeowner_C  sec_loanamount1 sec_loanamount2 sec_loanamount3  sec_loanamount5 sec_loanamount6 sec_loanamount7 No_Drain_C
foreach var in `risk' {
replace `var' = 0 if miss_`var' == 1
}
local controls Age_C Married_C Literate_C Muslim_C HH_Size_C Years_Education_C shock_any_C  Has_Business_C Financial_Control_C homeowner_C  sec_loanamount1 sec_loanamount2 sec_loanamount3  sec_loanamount5 sec_loanamount6 sec_loanamount7 No_Drain_C
local miss_controls
foreach var of varlist `controls' {
local miss_controls `miss_controls' miss_`var'
}
local controls_and_miss `controls' `miss_controls'
local miss_controls
foreach var of varlist `controls' {
	local miss_controls `miss_controls' miss_`var'
}
local controls_and_miss `controls' `miss_controls'

*BASE SPECIFICATION

local specifications  "sec_treat i.Stratification i.sec_loan_officer `controls_and_miss'"
foreach X in Late_Days_364  Late_Days_476 not_finished_aug19 Outstanding Fifty_Percent_Loan_Paid  Made_First_11_Pay_On_Time Made_First_Pay {
		 xi: regress `X' `specifications' , cluster(sec_group_name)
	}

*****************************************

*Table 4 - All okay - This table continues to use Literate_C as a control (not used earlier in Tables 1 or 2)

use "Grace Period Data.dta", clear

foreach X in atleastone_bizshutdown_alt Max_Min Q68 Q35_ Q37  Q11_Together_max {
		 xi: regress `X' sec_treat i.Stratification_Dummies, cluster(sec_group_name)
	}


tab sec_loanamount, gen(sec_loanamount)
forvalues i=1/7{
gen miss_sec_loanamount`i' = 0
replace miss_sec_loanamount`i' = 1 if sec_loanamount == .
}
duplicates drop slid, force
* Make sure missings are 0 not averages (missing controls coded as "." only in Table 1)
local controls Age_C Married_C Literate_C Muslim_C HH_Size_C Years_Education_C shock_any_C  Has_Business_C Financial_Control_C homeowner_C  sec_loanamount1 sec_loanamount2 sec_loanamount3  sec_loanamount5 sec_loanamount6 sec_loanamount7 No_Drain_C
foreach var in `controls' {
replace `var' = 0 if miss_`var' == 1
}
local controls Age_C Married_C Literate_C Muslim_C HH_Size_C Years_Education_C shock_any_C  Has_Business_C Financial_Control_C homeowner_C  sec_loanamount1 sec_loanamount2 sec_loanamount3  sec_loanamount5 sec_loanamount6 sec_loanamount7 No_Drain_C
local miss_controls
foreach var of varlist `controls' {
local miss_controls `miss_controls' miss_`var'
}
local controls_and_miss `controls' `miss_controls'


foreach X in atleastone_bizshutdown_alt Max_Min Q68 Q35_ Q37 Q11_Together_max {
	xi: regress `X' sec_treat i.Stratification_Dummies i.sec_loan_officer `controls_and_miss', cluster(sec_group_name)
	}

*********************************************

*Table 5 - All okay (long redundant code, shortened here, shortened more further below)
*But, in this table drop dummies by loan amount and substitutes loan amount itself 
*In Business_Broad regression drops Has_Business_C

use "Grace Period Data.dta", clear
local variables2 Impatient Risk_Loving  Earns_Wage Chronically_Ill No_Business_Broad Has_Savings_Acc_Apr24
forvalues i=1/6 {
local var2: word `i' of `variables2'
	gen sec_treat_`var2'=sec_treat*`var2'
}
egen Heterogeneous=rowtotal(No_Business_Broad Impatient  Earns_Wage    Risk_Loving  Has_Savings_Acc_Apr24),m  

*IMPATIENT

* Make sure missings are 0 not averages (missing controls coded as "." only in Table 1)
local risk  Age_C Married_C  Muslim_C Years_Education_C  HH_Size_C shock_any_C Has_Business_C homeowner_C  Financial_Control_C  sec_loanamount   No_Drain
foreach var of local risk {
	replace `var' = 0 if miss_`var' == 1
	}
local controls  Age_C Married_C  Muslim_C Years_Education_C  HH_Size_C shock_any_C Has_Business_C homeowner_C  Financial_Control_C  sec_loanamount   No_Drain
local controls  Age_C Married_C  Muslim_C Years_Education_C  HH_Size_C shock_any_C  Has_Business_C homeowner_C   Financial_Control_C  sec_loanamount   No_Drain
local miss_controls
foreach var of varlist `controls' {
local miss_controls `miss_controls' miss_`var'
}
local controls_and_miss `controls' `miss_controls'

local interaction Impatient
local specifications  " sec_treat sec_treat_`interaction' `interaction'  i.Stratification_Dummies "
local specifications ""`specifications'" " sec_treat sec_treat_Impatient Impatient i.Stratification_Dummies i.sec_loan_officer `controls_and_miss'""


	foreach specification in `specifications' {
		 xi: regress  Profit `specification' , cluster(sec_group_name)
	
}

*SAVINGS ACCOUNT

* Make sure missings are 0 not averages (missing controls coded as "." only in Table 1)
local risk  Age_C Married_C  Muslim_C Years_Education_C  HH_Size_C shock_any_C Has_Business_C homeowner_C  Financial_Control_C  sec_loanamount   No_Drain
foreach var of local risk {
	replace `var' = 0 if miss_`var' == 1
	}
local controls  Age_C Married_C  Muslim_C Years_Education_C  HH_Size_C shock_any_C Has_Business_C homeowner_C  Financial_Control_C  sec_loanamount   No_Drain
local controls  Age_C Married_C  Muslim_C Years_Education_C  HH_Size_C shock_any_C  Has_Business_C homeowner_C   Financial_Control_C  sec_loanamount   No_Drain
local miss_controls
foreach var of varlist `controls' {
local miss_controls `miss_controls' miss_`var'
}
local controls_and_miss `controls' `miss_controls'

local interaction Has_Savings_Acc_Apr24
local specifications  " sec_treat sec_treat_`interaction' `interaction'  i.Stratification_Dummies "
local specifications ""`specifications'" " sec_treat sec_treat_`interaction' `interaction' i.Stratification_Dummies i.sec_loan_officer `controls_and_miss'""

	foreach specification in `specifications' {
		 xi: regress  Profit `specification' , cluster(sec_group_name)
	
}

*RISK LOVING

* Make sure missings are 0 not averages (missing controls coded as "." only in Table 1)
local risk  Age_C Married_C  Muslim_C Years_Education_C  HH_Size_C shock_any_C Has_Business_C homeowner_C  Financial_Control_C  sec_loanamount   No_Drain
foreach var of local risk {
	replace `var' = 0 if miss_`var' == 1
	}
local controls  Age_C Married_C  Muslim_C Years_Education_C  HH_Size_C shock_any_C Has_Business_C homeowner_C  Financial_Control_C  sec_loanamount   No_Drain
local controls  Age_C Married_C  Muslim_C Years_Education_C  HH_Size_C shock_any_C  Has_Business_C homeowner_C   Financial_Control_C  sec_loanamount   No_Drain
local miss_controls
foreach var of varlist `controls' {
local miss_controls `miss_controls' miss_`var'
}
local controls_and_miss `controls' `miss_controls'

local interaction Risk_Loving
local specifications  " sec_treat sec_treat_`interaction' `interaction'  i.Stratification_Dummies "
local specifications ""`specifications'" " sec_treat sec_treat_`interaction' `interaction' i.Stratification_Dummies i.sec_loan_officer `controls_and_miss'""

foreach specification in `specifications' {
		 xi: regress  Profit `specification' , cluster(sec_group_name)
	
}


*AT LEAST ONE HH MEMBER OF SPOUSE AND WIFE EARNS A WAGE

* Make sure missings are 0 not averages (missing controls coded as "." only in Table 1)
local risk  Age_C Married_C  Muslim_C Years_Education_C  HH_Size_C shock_any_C Has_Business_C homeowner_C  Financial_Control_C  sec_loanamount   No_Drain
foreach var of local risk {
	replace `var' = 0 if miss_`var' == 1
	}
local controls  Age_C Married_C  Muslim_C Years_Education_C  HH_Size_C shock_any_C Has_Business_C homeowner_C  Financial_Control_C  sec_loanamount   No_Drain
local controls  Age_C Married_C  Muslim_C Years_Education_C  HH_Size_C shock_any_C  Has_Business_C homeowner_C   Financial_Control_C  sec_loanamount   No_Drain
local miss_controls
foreach var of varlist `controls' {
local miss_controls `miss_controls' miss_`var'
}
local controls_and_miss `controls' `miss_controls'


local interaction Earns_Wage
local specifications  " sec_treat sec_treat_`interaction' `interaction'  i.Stratification_Dummies "
local specifications ""`specifications'" " sec_treat sec_treat_`interaction' `interaction' i.Stratification_Dummies i.sec_loan_officer `controls_and_miss'""

foreach specification in `specifications' {
		 xi: regress  Profit `specification' , cluster(sec_group_name)
	
}

*NU CHRONIC ILL*


* Make sure missings are 0 not averages (missing controls coded as "." only in Table 1)
local risk  Age_C Married_C  Muslim_C Years_Education_C  HH_Size_C shock_any_C Has_Business_C homeowner_C  Financial_Control_C  sec_loanamount   No_Drain
foreach var of local risk {
	replace `var' = 0 if miss_`var' == 1
	}
local controls  Age_C Married_C  Muslim_C Years_Education_C  HH_Size_C shock_any_C Has_Business_C homeowner_C  Financial_Control_C  sec_loanamount   No_Drain
local miss_controls
foreach var of varlist `controls' {
local miss_controls `miss_controls' miss_`var'
}
local controls_and_miss `controls' `miss_controls'

local interaction Chronically_Ill
local specifications  " sec_treat sec_treat_`interaction' `interaction'  i.Stratification_Dummies "
local specifications ""`specifications'" " sec_treat sec_treat_`interaction' `interaction' i.Stratification_Dummies i.sec_loan_officer `controls_and_miss'""

foreach specification in `specifications' {
		 xi: regress  Profit `specification' , cluster(sec_group_name)
	
}


*NO BUSINESS*

* Make sure missings are 0 not averages (missing controls coded as "." only in Table 1)
local risk  Age_C Married_C  Muslim_C Years_Education_C  HH_Size_C shock_any_C Has_Business_C homeowner_C  Financial_Control_C  sec_loanamount   No_Drain
foreach var of local risk {
	replace `var' = 0 if miss_`var' == 1
	}
local controls  Age_C Married_C  Muslim_C Years_Education_C  HH_Size_C shock_any_C  homeowner_C  Financial_Control_C  sec_loanamount   No_Drain
local miss_controls
foreach var of varlist `controls' {
local miss_controls `miss_controls' miss_`var'
}
local controls_and_miss `controls' `miss_controls'

local interaction No_Business_Broad
local specifications  " sec_treat sec_treat_`interaction' `interaction'  i.Stratification_Dummies "
local specifications ""`specifications'" " sec_treat sec_treat_`interaction' `interaction' i.Stratification_Dummies i.sec_loan_officer `controls_and_miss'""

foreach specification in `specifications' {
		 xi: regress  Profit `specification' , cluster(sec_group_name)
	
}


*HETEROGENEOUS RISK INDEX*

gen sec_treat_Heterogeneous=sec_treat*Heterogeneous
* Make sure missings are 0 not averages (missing controls coded as "." only in Table 1)
local risk  Age_C Married_C  Muslim_C Years_Education_C  HH_Size_C shock_any_C Has_Business_C homeowner_C  Financial_Control_C  sec_loanamount   No_Drain
foreach var of local risk {
	replace `var' = 0 if miss_`var' == 1
	}
local controls  Age_C Married_C  Muslim_C Years_Education_C  HH_Size_C shock_any_C Has_Business_C homeowner_C  Financial_Control_C  sec_loanamount   No_Drain
local miss_controls
foreach var of varlist `controls' {
local miss_controls `miss_controls' miss_`var'
}
local controls_and_miss `controls' `miss_controls'

local interaction Heterogeneous
local specifications  " sec_treat sec_treat_`interaction' `interaction'  i.Stratification_Dummies "
local specifications ""`specifications'" " sec_treat sec_treat_`interaction' `interaction' i.Stratification_Dummies i.sec_loan_officer `controls_and_miss'""

foreach specification in `specifications' {
		 xi: regress  Profit `specification' , cluster(sec_group_name)
	
}



*IMPATIENT

* Make sure missings are 0 not averages (missing controls coded as "." only in Table 1)
local risk  Age_C Married_C  Muslim_C Years_Education_C  HH_Size_C shock_any_C Has_Business_C homeowner_C  Financial_Control_C  sec_loanamount   No_Drain
foreach var of local risk {
	replace `var' = 0 if miss_`var' == 1
	}
local controls  Age_C Married_C  Muslim_C Years_Education_C  HH_Size_C shock_any_C Has_Business_C homeowner_C  Financial_Control_C  sec_loanamount   No_Drain
local miss_controls
foreach var of varlist `controls' {
local miss_controls `miss_controls' miss_`var'
}
local controls_and_miss `controls' `miss_controls'

local interaction Impatient
local specifications  " sec_treat sec_treat_`interaction' `interaction'  i.Stratification_Dummies "
local specifications ""`specifications'" " sec_treat sec_treat_Impatient Impatient i.Stratification_Dummies i.sec_loan_officer `controls_and_miss'""

foreach specification in `specifications' {
		 xi: regress  Profit_TopCode `specification' , cluster(sec_group_name)
	
}

*SAVINGS ACCOUNT


* Make sure missings are 0 not averages (missing controls coded as "." only in Table 1)
local risk  Age_C Married_C  Muslim_C Years_Education_C  HH_Size_C shock_any_C Has_Business_C homeowner_C  Financial_Control_C  sec_loanamount   No_Drain
foreach var of local risk {
	replace `var' = 0 if miss_`var' == 1
	}
local controls  Age_C Married_C  Muslim_C Years_Education_C  HH_Size_C shock_any_C Has_Business_C homeowner_C  Financial_Control_C  sec_loanamount   No_Drain
local miss_controls
foreach var of varlist `controls' {
local miss_controls `miss_controls' miss_`var'
}
local controls_and_miss `controls' `miss_controls'

local interaction Has_Savings_Acc_Apr24
local specifications  " sec_treat sec_treat_`interaction' `interaction'  i.Stratification_Dummies "
local specifications ""`specifications'" " sec_treat sec_treat_`interaction' `interaction' i.Stratification_Dummies i.sec_loan_officer `controls_and_miss'""

foreach specification in `specifications' {
		 xi: regress  Profit_TopCode `specification' , cluster(sec_group_name)
	
}

*RISK LOVING

* Make sure missings are 0 not averages (missing controls coded as "." only in Table 1)
local risk  Age_C Married_C  Muslim_C Years_Education_C  HH_Size_C shock_any_C Has_Business_C homeowner_C  Financial_Control_C  sec_loanamount   No_Drain
foreach var of local risk {
	replace `var' = 0 if miss_`var' == 1
	}
local controls  Age_C Married_C  Muslim_C Years_Education_C  HH_Size_C shock_any_C Has_Business_C homeowner_C  Financial_Control_C  sec_loanamount   No_Drain
local miss_controls
foreach var of varlist `controls' {
local miss_controls `miss_controls' miss_`var'
}
local controls_and_miss `controls' `miss_controls'

local interaction Risk_Loving
local specifications  " sec_treat sec_treat_`interaction' `interaction'  i.Stratification_Dummies "
local specifications ""`specifications'" " sec_treat sec_treat_`interaction' `interaction' i.Stratification_Dummies i.sec_loan_officer `controls_and_miss'""

foreach specification in `specifications' {
		 xi: regress  Profit_TopCode `specification' , cluster(sec_group_name)
	
}


*AT LEAST ONE HH MEMBER OF SPOUSE AND WIFE EARNS A WAGE

* Make sure missings are 0 not averages (missing controls coded as "." only in Table 1)
local risk  Age_C Married_C  Muslim_C Years_Education_C  HH_Size_C shock_any_C Has_Business_C homeowner_C  Financial_Control_C  sec_loanamount   No_Drain
foreach var of local risk {
	replace `var' = 0 if miss_`var' == 1
	}
local controls  Age_C Married_C  Muslim_C Years_Education_C  HH_Size_C shock_any_C Has_Business_C homeowner_C  Financial_Control_C  sec_loanamount   No_Drain
local miss_controls
foreach var of varlist `controls' {
local miss_controls `miss_controls' miss_`var'
}
local controls_and_miss `controls' `miss_controls'

local interaction Earns_Wage
local specifications  " sec_treat sec_treat_`interaction' `interaction'  i.Stratification_Dummies "
local specifications ""`specifications'" " sec_treat sec_treat_`interaction' `interaction' i.Stratification_Dummies i.sec_loan_officer `controls_and_miss'""

foreach specification in `specifications' {
		 xi: regress  Profit_TopCode `specification' , cluster(sec_group_name)
	
}



*NU CHRONIC ILL
* Make sure missings are 0 not averages (missing controls coded as "." only in Table 1)
local risk  Age_C Married_C  Muslim_C Years_Education_C  HH_Size_C shock_any_C Has_Business_C homeowner_C  Financial_Control_C  sec_loanamount   No_Drain
foreach var of local risk {
	replace `var' = 0 if miss_`var' == 1
	}
local controls  Age_C Married_C  Muslim_C Years_Education_C  HH_Size_C shock_any_C Has_Business_C homeowner_C  Financial_Control_C  sec_loanamount   No_Drain
local miss_controls
foreach var of varlist `controls' {
local miss_controls `miss_controls' miss_`var'
}
local controls_and_miss `controls' `miss_controls'

local interaction Chronically_Ill
local specifications  " sec_treat sec_treat_`interaction' `interaction'  i.Stratification_Dummies "
local specifications ""`specifications'" " sec_treat sec_treat_`interaction' `interaction' i.Stratification_Dummies i.sec_loan_officer `controls_and_miss'""

foreach specification in `specifications' {
		 xi: regress  Profit_TopCode `specification' , cluster(sec_group_name)
	
}

*NO BUSINESS
* Make sure missings are 0 not averages (missing controls coded as "." only in Table 1)
local risk  Age_C Married_C  Muslim_C Years_Education_C  HH_Size_C shock_any_C Has_Business_C homeowner_C  Financial_Control_C  sec_loanamount   No_Drain
foreach var of local risk {
	replace `var' = 0 if miss_`var' == 1
	}
local controls  Age_C Married_C  Muslim_C Years_Education_C  HH_Size_C shock_any_C  homeowner_C  Financial_Control_C  sec_loanamount   No_Drain
local miss_controls
foreach var of varlist `controls' {
local miss_controls `miss_controls' miss_`var'
}
local controls_and_miss `controls' `miss_controls'

local interaction No_Business_Broad
local specifications  " sec_treat sec_treat_`interaction' `interaction'  i.Stratification_Dummies "
local specifications ""`specifications'" " sec_treat sec_treat_`interaction' `interaction' i.Stratification_Dummies i.sec_loan_officer `controls_and_miss'""

foreach specification in `specifications' {
		 xi: regress  Profit_TopCode `specification' , cluster(sec_group_name)
	
}

*HETEROGENEOUS RISK INDEX

* Make sure missings are 0 not averages (missing controls coded as "." only in Table 1)
local risk  Age_C Married_C  Muslim_C Years_Education_C  HH_Size_C shock_any_C Has_Business_C homeowner_C  Financial_Control_C  sec_loanamount   No_Drain
foreach var of local risk {
	replace `var' = 0 if miss_`var' == 1
	}
local controls  Age_C Married_C  Muslim_C Years_Education_C  HH_Size_C shock_any_C Has_Business_C homeowner_C  Financial_Control_C  sec_loanamount   No_Drain
local miss_controls
foreach var of varlist `controls' {
local miss_controls `miss_controls' miss_`var'
}
local controls_and_miss `controls' `miss_controls'

local interaction Heterogeneous
local specifications  " sec_treat sec_treat_`interaction' `interaction'  i.Stratification_Dummies "
local specifications ""`specifications'" " sec_treat sec_treat_`interaction' `interaction' i.Stratification_Dummies i.sec_loan_officer `controls_and_miss'""

foreach specification in `specifications' {
		 xi: regress  Profit_TopCode `specification' , cluster(sec_group_name)
	
}

*************************************************
*************************************************
************************************************


*Now, combine everything in shorter code

use "Grace Period Data.dta", clear
tab sec_loanamount, gen(sec_loanamount)
*All miss_sec_* variables used in their regressions are all identically equal to 0, so drop that element of code
tab Stratification_Dummies, gen(SD)
tab sec_loan_officer, gen(SLO)
egen Heterogeneous = rowtotal(No_Business_Broad Impatient Earns_Wage Risk_Loving Has_Savings_Acc_Apr24)
foreach X in Impatient Risk_Loving Earns_Wage Chronically_Ill No_Business_Broad Has_Savings_Acc_Apr24 Heterogeneous {
	generate sec_treat_`X'=sec_treat*`X'
	}

global controls "sec_loanamount1 sec_loanamount2 sec_loanamount3 sec_loanamount4 sec_loanamount5 sec_loanamount6"
*All changes to controls to 0 have no effect (so drop that part of code - all miss_ are also identically zero)
global controls1 Age_C Married_C Muslim_C HH_Size_C Years_Education_C shock_any_C Has_Business_C Financial_Control_C homeowner_C sec_loanamount1 sec_loanamount2 sec_loanamount3 sec_loanamount5 sec_loanamount6 sec_loanamount7 No_Drain_C miss_Age_C miss_Married_C miss_Years_Education_C miss_shock_any_C miss_Financial_Control_C miss_homeowner_C miss_No_Drain_C
global controls2 Age_C Married_C Muslim_C HH_Size_C Years_Education_C shock_any_C Has_Business_C Financial_Control_C homeowner_C sec_loanamount1 sec_loanamount2 sec_loanamount3 sec_loanamount5 sec_loanamount6 sec_loanamount7 No_Drain_C miss_Age_C miss_Years_Education_C miss_shock_any_C miss_Financial_Control_C miss_homeowner_C miss_No_Drain_C
*Another specification where they drop the dummies by loan amount and substitute the loan amount
global controls3 Age_C Married_C Muslim_C HH_Size_C Years_Education_C shock_any_C Has_Business_C Financial_Control_C homeowner_C sec_loanamount No_Drain_C miss_Age_C miss_Years_Education_C miss_shock_any_C miss_Financial_Control_C miss_homeowner_C miss_No_Drain_C
*Specification where they drop Has_Business_C
global controls4 Age_C Married_C Muslim_C HH_Size_C Years_Education_C shock_any_C Financial_Control_C homeowner_C sec_loanamount No_Drain_C miss_Age_C miss_Years_Education_C miss_shock_any_C miss_Financial_Control_C miss_homeowner_C miss_No_Drain_C

*Completely redundant, so removed
tab miss_Has_Business_C miss_Married_C
tab miss_HH_Size_C miss_Age_C
tab miss_Muslim_C miss_Age_C
tab miss_Literate_C miss_Years_Education_C
*Redundant in some specifications
tab miss_Married_C miss_Age_C if Capital ~= .

*Table 1
foreach X in Business_Expenditures Inventory_Raw_Mat Equipment Other_Bus_Cost Non_Business_Exp Repairs_Repair_Only Utilities_Taxes_Rent Human_Capital Re_Lent Savings Food_And_Durable New_Business_Ap15 {
	regress `X' sec_treat Match3rd_in3rd SD2-SD9 $controls, cluster(sec_group_name)
	regress `X' sec_treat Match3rd_in3rd SD2-SD9 $controls1, cluster(sec_group_name)
	}

*Table 2

foreach X in Profit ln_Q50 Capital Profit_TopCode ln_Q50_TopCode Capital_TopCode Profit_TopCode_1P ln_Q50_1P Capital_TopCode_1P Profit_TopCode_5P ln_Q50_5P Capital_TopCode_5P {
	regress `X' sec_treat SD2-SD9, cluster(sec_group_name)
	regress `X' sec_treat SD2-SD9 SLO2-SLO5 $controls2, cluster(sec_group_name)
	}


*Table 3
*Drop miss_Literate_C because identical to miss_Years_Education_C

foreach X in Late_Days_364 Late_Days_476 not_finished_aug19 Outstanding Fifty_Percent_Loan_Paid Made_First_11_Pay_On_Time Made_First_Pay {
	regress `X' sec_treat SD2-SD9, cluster(sec_group_name)
	regress `X' sec_treat SD2-SD9 SLO2-SLO5 Literate_C $controls1, cluster(sec_group_name)
	}

*Table 4

foreach X in atleastone_bizshutdown_alt Max_Min Q68 Q35_ Q37 Q11_Together_max {
	regress `X' sec_treat SD2-SD9, cluster(sec_group_name)
	regress `X' sec_treat SD2-SD9 SLO2-SLO5 Literate_C $controls1, cluster(sec_group_name)
	}

*Table 5 - Reorder as in table

foreach Y in Profit Profit_TopCode {
	foreach X in Risk_Loving Has_Savings_Acc_Apr24 Chronically_Ill Impatient No_Business_Broad Earns_Wage Heterogeneous {
		regress `Y' sec_treat sec_treat_`X' `X' SD2-SD9, cluster(sec_group_name)

		if "`X'" ~= "No_Business_Broad" {
			regress `Y' sec_treat sec_treat_`X' `X' SD2-SD9 SLO2-SLO5 $controls3, cluster(sec_group_name)
			}
		else {
			regress `Y' sec_treat sec_treat_`X' `X' SD2-SD9 SLO2-SLO5 $controls4, cluster(sec_group_name)
			}
		}
	}

save DatFPPR, replace



