/*
**********************************************************************************************************************************
Previous Version: 12-28-2007
This Version: 10-17-2008. Modified to include material expense as a denominator to compute use of trade credit and ratio of material expense to cost of goods sold
Missing items: Long term receivables, short term debtm, labor cost
Missing items: short term debt, missing country Switzerland
Modified to make variable names the same as in the final database
**********************************************************************************************************************************
*/


clear
set mem 1000m
*fdause wstcredit
use amadeus_manuf_2007  /*10-17-2008*/

gen wbcode =""
replace wbcode="AUT"	if country=="AT"
replace wbcode="BEL"	if country=="BE"
replace wbcode="DNK"	if country=="DK"
replace wbcode="FIN"	if country=="FI"
replace wbcode="FRA"	if country=="FR"
replace wbcode="GRC"	if country=="GR"
replace wbcode="HUN"	if country=="HU"
replace wbcode="ITA"	if country=="IT"
replace wbcode="IRL"    if country=="IE"
replace wbcode="ISL"    if country=="IS"
replace wbcode="NLD"	if country=="NL"
replace wbcode="NOR"    if country=="NO"
replace wbcode="POL"	if country=="PL"
replace wbcode="PRT"	if country=="PT"
replace wbcode="ESP"	if country=="ES"
replace wbcode="SWE"	if country=="SE"
replace wbcode="CHE"	if country=="CH"
replace wbcode="GBR"	if country=="GB"

capture egen id_num = group(bvd_id_number)
*I'm going to simply drop the duplicates.
*If I ever need to understand in detail why there are duplicates I would have to go to amadeus

duplicates drop id_num year, force

isid id_num year

pause on
set more off

*Only manufactures

tsset id_num year

*rename turn sales
rename cost_goods_sold cgsold
rename creditors payab
rename debtors receiv
rename material_cost mater
*rename priussco sic3
*rename loan stdebt
rename employment_cost laborcomp

replace cgsold = . if cgsold==0
replace cgsold = mater + laborcomp if cgsold==. & mater~=. & laborcomp~=.

gen recturn1 = sales/(0.5*(receiv + l.receiv))
replace recturn1 = . if recturn1<0

*gen recturn2 = sales/(0.5*(receiv + ltmrec + l.receiv + l.ltmrec))
*replace recturn2 = . if recturn2<0

gen recturn3 = sales/receiv
replace recturn3 = . if recturn3<0

gen payturn1 = cgsold/(0.5*(payab + l.payab))
replace payturn1 = . if payturn1<0

gen payturnmat = mater/(0.5*(payab + l.payab))
replace payturnmat = . if payturnmat<0

gen mcost2cgs = mater/cgs
replace mcost2cgs = . if mcost2cgs<0

gen payturn2 =cgsold/payab
replace payturn2 = . if payturn2<0

*gen stdbtpay = stdebt/payab
*replace stdbtpay = . if stdbtpay<0

gen invpayturn1 = 1/payturn1
gen invpaymat   = 1/payturnmat

*Take typical values for firms and counting instances

collapse (p50) recturn1 payturn1 payturnmat  invpayturn1 invpaymat mcost2cgs (count) nrecturn1=recturn1 npayturn1=payturn1 npayturnmat = payturnmat  ninvpayturn1=invpayturn1 ninvpaymat=invpaymat nmcost2cgs = mcost2cgs, by(wbcode id sic3 )

pause
*Maintain only those firms that have at least 5 observations to erase cyclical effects

replace recturn1         = . if nrecturn<5
replace payturn1        = . if npayturn1<5
replace payturnmat    = . if npayturnmat<5
*replace stdbtpay      	= . if nstdbtpay<5
replace invpayturn     = . if ninvpayturn1<5
replace invpaymat     = . if ninvpaymat<5
replace mcost2cgs     = . if nmcost2cgs<5
preserve

collapse (p50) Rec = recturn1 Pay = payturn1 Paymat = payturnmat  InvPay = invpayturn1 InvPaymat = invpaymat Mcost2cgs = mcost2cgs (count) nrecturn1=recturn1 npayturn1=payturn1 npaymat = payturnmat  ninvpay=invpayturn1 ninvpaymat = invpaymat nmcost2cgs=mcost2cgs, by(wbcode)

replace Pay = . if npayturn1<10
replace Paymat = . if npaymat<10
replace InvPay = . if ninvpay<10
replace InvPaymat =. if ninvpaymat<10
replace Rec = . if nrec<10
*replace Std = . if nstd<10
replace Mcost2cgs = . if nmcost2cgs<10

foreach v of varlist  Rec Pay Paymat InvPay InvPaymat Mcost2cgs {
	rename `v' `v'_amadeus
}


save Trade_credit_measures_medians_amadeus_2007, replace


restore

