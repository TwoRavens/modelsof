**************
// create within firm dataset
**************


use "eseecleaned.dta", clear

keep firmid year  crisis ind pcaext  adv inv_it rd inv_veh  inv_mach   inv_fur  ///
     	corpgrp  forplans forshares size prod shortfiratio

//create average investment & stocks for each category within firms
gen deprate_adv=0.6
gen deprate_inv_it=0.3
gen deprate_rd=0.2
gen deprate_inv_veh=0.16
gen deprate_inv_mach=0.12
gen deprate_inv_fur=0.1
foreach var in adv inv_it rd inv_veh inv_mach inv_fur {
cap drop avginv_`var'
bysort firmid  : egen avginv_`var'=mean(`var')
cap drop stock0_`var'
gen stock0_`var'=avginv_`var'/deprate_`var'
cap drop temp
bysort firmid : egen temp=min(year) if `var'!=.
cap drop firstyr_`var'
bysort firmid : egen firstyr_`var'=min(temp)
gen stockbop_`var'=stock0_`var' if year==firstyr_`var'
gen depr_`var'=stockbop_`var'*deprate_`var' if year==firstyr_`var'
xtset firm year
forvalues yr=1/8 {
replace stockbop_`var'=l.stockbop_`var'-l.depr_`var'+l.`var' if year==(firstyr_`var'+`yr') & l.`var'!=.
replace stockbop_`var'=l.stockbop_`var'-l.depr_`var'+l.avginv_`var' if year==(firstyr_`var'+`yr') & l.`var'==.
replace depr_`var'=stockbop_`var'*deprate_`var' if year==firstyr_`var'+`yr'
}
gen inv_stock_`var'=`var'/stockbop_`var'
replace inv_stock_`var'=0 if stockbop_`var'==0 & `var'==0
}
drop stockbop_* 
drop depr_*
drop stock0_*
drop avginv_*
drop firstyr_*
drop deprate*

merge n:1 firmid using "ipw.dta", keep(master match) keepus(ipw)
label var ipw "Inverse propensity weight"
drop _merge

cap drop temp
cap drop shortfi2007
gen temp=shortfiratio if year==2007
bysort firmid: egen shortfi2007=min(temp)
cap drop temp
label var shortfi2007 "Short term credit with fin inst/total credit in 2007"
sum shortfiratio if year==2007, detail
gen shortfi=1 if shortfi2007>`r(mean)' & shortfi2007!=.
replace shortfi=0 if shortfi2007<=`r(mean)'  & shortfi2007!=.
label var shortfi "1 more than avg short term debt in 2007"
drop shortfiratio

foreach var in  adv inv_it rd inv_veh  inv_mach   inv_fur  {
di "`var'"
sum `var'
sum `var' if `var'>0
replace `var'=1 if `var'==0
sum `var'
sum `var' if `var'>0
rename `var' val`var'
}


reshape long val inv_stock_, i(firmid  year  ) j(category) string
label var category "Investment category"
gen lnval=ln(val) if val!=1  //excludes zeros that were set to 1
label var lnval "ln(investment value)"
gen lnval2=ln(val) 
label var lnval2 "ln(investment value), incl 0s" //includes zeros that were set to 1
cap drop val
rename inv_stock_ inv_stock
label var inv_stock "investment/stock"

gen domfir=(pcaext<=50)
replace domfir=. if pcaext==.
cap drop pcaext
label var domfir "Dummy if foreign share <=50%"
label var crisis "Dummy if after crisis (year>=2008)"
egen firmyr=group(firmid year)
egen catd=group(category)
xtset firmyr catd
egen catyr=group(category year)
egen indyear=group(ind year)
compress

gen deprate=0.6 if category=="adv"
replace deprate=0.3 if category=="inv_it"
replace deprate=0.2 if category=="rd"
replace deprate=0.16 if category=="inv_veh"
replace deprate=0.12 if category=="inv_mach"
replace deprate=0.1 if category=="inv_fur"
label var deprate "Depreciation rate"
gen longinv8=1/deprate
label var longinv8 "Time-to-payoff measure"

gen longinv10=1 if category=="adv"
replace longinv10=2 if category=="inv_it"
replace longinv10=3 if category=="rd"
replace longinv10=4 if category=="inv_veh"
replace longinv10=5 if category=="inv_mach"
replace longinv10=6 if category=="inv_fur"
label var longinv10 "Time-to-payoff measure"

gen longinv11=1 if category=="adv"
replace longinv11=2 if category=="rd"
replace longinv11=2 if category=="inv_it"
replace longinv11=3 if category=="inv_veh"
replace longinv11=4 if category=="inv_mach"
replace longinv11=4 if category=="inv_fur"
label var longinv11 "Time-to-payoff measure"

gen longinv12=1 if category=="adv"
replace longinv12=2 if category=="inv_it"
replace longinv12=2 if category=="rd"
replace longinv12=3 if category=="inv_veh"
replace longinv12=3 if category=="inv_mach"
replace longinv12=3 if category=="inv_fur"
label var longinv12 "Time-to-payoff measure"

gen longinv13=1 if category=="adv"
replace longinv13=2 if category=="inv_it"
replace longinv13=2 if category=="rd"
replace longinv13=2 if category=="inv_veh"
replace longinv13=3 if category=="inv_mach"
replace longinv13=3 if category=="inv_fur"
label var longinv13 "Time-to-payoff measure"

gen crisisXlonginv=crisis*longinv8
label var crisisXlonginv "(1/depr rate)*after 2008 dummy"
label var crisis "After 2008 dummy"

foreach var in domfir  size prod shortfi shortfi2007 {
gen crisisXlonginvX`var'=crisis*longinv8*`var'
gen longinvX`var'=longinv8*`var'
}

label var longinvXdomfir "(Time-to-payoff measure)*(domestic firm dummy)"
label var crisisXlonginvXdomfir "(Time-to-payoff measure)*(after 2008 dummy)*(domestic firm dummy)"
label var longinvXsize "(Time-to-payoff measure)*ln(sales)"
label var crisisXlonginvXsize "(Time-to-payoff measure)*(after 2008 dummy)*ln(sales)"
label var longinvXprod "(Time-to-payoff measure)*ln(TFP)"
label var crisisXlonginvXprod "(Time-to-payoff measure)*(after 2008 dummy)*ln(TFP)"
label var longinvXshortfi "(Time-to-payoff measure)*(treatment)"
label var crisisXlonginvXshortfi "(Time-to-payoff measure)*(after 2008 dummy)*(treatment)"
label var longinvXshortfi2007 "(Time-to-payoff measure)*(treatment)"
label var crisisXlonginvXshortfi2007 "(Time-to-payoff measure)*(after 2008 dummy)*(treatment)"

keep  firmid  year crisis category catd indyear catyr firmyr  ///
	lnval lnval2 inv_stock  ///
	crisisXlonginv crisisXlonginvXdomfir crisisXlonginvXsize crisisXlonginvXprod crisisXlonginvXshortfi crisisXlonginvXshortfi2007 ///
	longinvXdomfir longinvXsize longinvXprod longinvXshortfi longinvXshortfi2007 ///
	longinv8 longinv10 longinv11 longinv12 longinv13 deprate domfir  ///
	corpgrp forplans forshares ipw

save "eseewithinfirm.dta", replace
