
clear
set memory 200M

insheet using bankscope.asc, comma clear
save Databestand_Banks.dta, replace

clear
set memory 200m
use Databestand_Banks.dta, clear
drop if totalassets>=.

 
********************************************************************************************
*** This code:
*	1. Checks the data
*	2. Creates new variables, codes the data, makes dummies, renames variables
*	3. Creates a new workfile: "Databestand_Banks2.dta" : Attention: variables with TA=n.a. are removed.
********************************************************************************************

********************************************************************************************
*** Rename certain variables
********************************************************************************************

drop v1
rename v2 temp
*bankname only contains numbers
ren bankname banknr
ren specialisationgeneral specialism
ren equitytotalassets Equity_TA
label variable Equity_TA "Equity_TA (%)"
ren returnonaverageassetsroaa ROA
label variable ROA "Return on Assets (%)"
ren fixedassets FA
label variable FA "Fixed Assets"
ren totalassets TA
label variable TA "Total Assets"
ren offbalancesheetitems OBSitems
label variable OBSitems "Off balance sheet items"
*the variable below used to be called: Customer&short term funding
ren depositsshorttermfunding CSTF
label variable CSTF "Deposits & short term funding"
ren interestincome II
label variable II "Interest Income"
ren interestexpense IE
label variable IE "Interest Expense"
ren personnelexpenses PE
label variable PE "Personnel Expenses"
ren otheradminexpenses OAE
label variable OAE "other administrative expenses"
ren otheroperatingexpenses OOE
label variable OOE "other operating expenses"
ren cashandduefrombanks CDFB
label variable CDFB "Cash and due from banks"
ren othernonearningassets ONEA
label variable ONEA "Other non-earning assets"
ren banksdeposits DepositsBanks
ren customerdeposits Depositscustomers





********************************************************************************************
*** Create new variables
********************************************************************************************

* Creates other non-interestes expense (ONIE) (e.g. depreciation, energy costs, software/hardware costs)=other adm expenses+other operating expenses
* OAE+OOE will not be performed if one of them is missing. In this case we see missing as zero, so that they are added anyhow.
* This is solved via the following code (>=. means: is missing)

generate ONIE=OAE+OOE
replace ONIE=OOE if OAE>=.
replace ONIE=OAE if OOE>=.
label variable ONIE "Other non-interest expenses"

*aanmaken total_funding=customer&short term funding + other funding (deposit & Short term funding)
generate total_funding=CSTF+otherfunding
replace total_funding=CSTF if otherfunding>=.
replace total_funding=otherfunding if CSTF>=.

*Creates Total Non-interest Expenses=Personnel expenses+other non-interest expenses
gen TNIE=PE+ONIE
replace TNIE=PE if ONIE>=.
replace TNIE=ONIE if PE>=.

*Create other income=total revenue -/- interest income
gen OI=totalrevenue-II


* Create period
destring temp, generate(period) ignore(", Values in USD (mil)")
drop temp

*Create time
gen time=period-1999

* create identificatienumber 
generate IDNR=_n
label variable IDNR "Identification number"

********************************************************************************************
*** Create dummies*********************************************
********************************************************************************************
gen dum_commercial=0
label variable dum_commercial "Dummy Commercial Bank"
replace dum_commercial=1 if specialism=="Commercial Bank"

gen dum_cooperative=0
label variable dum_cooperative "Dummy Cooperative Bank"
replace dum_cooperative=1 if specialism=="Cooperative Bank"

gen dum_investment=0
label variable dum_investment "Dummy Investment Bank"
replace dum_investment=1 if specialism=="Investment Bank/Securities House"

gen dum_MLTCredit=0
label variable dum_MLTCredit "Dummy MLTCredit Bank"
replace dum_MLTCredit=1 if specialism=="Medium & Long Term Credit Bank"

gen dum_RealEstate=0
label variable dum_RealEstate "Dummy Real Estate Bank"
replace dum_RealEstate=1 if specialism=="Real Estate / Mortgage Bank"

gen dum_savings=0
label variable dum_savings "Dummy Savings Bank"
replace dum_savings=1 if specialism=="Savings Bank"

gen dum_SpecGovCredit=0
label variable dum_SpecGovCredit "Dummy SpecGovCredit Bank"
replace dum_SpecGovCredit=1 if specialism=="Specialised Governmental Credit Inst."

*****************yeardummies**************************

gen dum_1994=0
gen dum_1995=0
gen dum_1996=0
gen dum_1997=0
gen dum_1998=0
gen dum_1999=0
gen dum_2000=0
gen dum_2001=0
gen dum_2002=0
gen dum_2003=0
gen dum_2004=0
replace dum_1994=1 if period==1994
replace dum_1995=1 if period==1995
replace dum_1996=1 if period==1996
replace dum_1997=1 if period==1997
replace dum_1998=1 if period==1998
replace dum_1999=1 if period==1999
replace dum_2000=1 if period==2000
replace dum_2001=1 if period==2001
replace dum_2002=1 if period==2002
replace dum_2003=1 if period==2003
replace dum_2004=1 if period==2004

*********************************************************************************
*** Series for Panzar Rosse analysis
*********************************************************************************


gen II_TA=ln(II/TA)
gen IE_FUN=ln(IE/total_funding)
gen PE_TA=ln(PE/TA)
gen ONIE_FA=ln(ONIE/FA)
gen loans_TA=ln(loans/TA)
gen lnEquity_TA=ln(Equity_TA)
gen OI_II=ln(OI/II)
gen lnDepositscustomers=ln(Depositscustomers)
gen ONEA_TA = ln(ONEA/TA)
gen lnII=ln(II)
gen lnTI=ln(totalrevenue)

gen time2=time^2
gen time3=time^3

gen lnFA=ln(FA)
gen lnloans=ln(loans)
gen lnloans2=(ln(loans))^2
gen lnTA=ln(TA)
gen lnTA2=(lnTA)^2
gen lnloanslnTA=ln(loans)*ln(TA)


*** CORRECTION OF FA
reg lnFA lnloans lnTA lnloans2 lnTA2 lnloanslnTA
predict model
** Get residuals
gen FAcorr=exp(model)
gen ONIE_FAcorr=ln(ONIE/FAcorr)



************************************************************************************
*** Clarification for certain variables
************************************************************************************
*Equity_TA, ROA en ROE are all expressed as percentage!

save Databestand_Banks2.dta, replace





