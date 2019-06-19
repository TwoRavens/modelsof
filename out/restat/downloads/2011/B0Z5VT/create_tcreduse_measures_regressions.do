/*
**********************************************************************************************************************************
Previous Version: 12-28-2007
This Version: 10-17-2008. Modified to include material expense as a denominator to compute use of trade credit and ratio of material expense to cost of goods sold
**********************************************************************************************************************************
*/

set mem 300m
*fdause wstcredit
use WSTcredit  /*10-17-2008*/

pause on
set more off

drop if compnumb==""
duplicates tag compnumb year, g(d)
drop if d>0

*Only manufactures

keep if sic>=2000 & sic<3999

egen id = group(compnumb)

tsset id year

gen recturn1 = sales/(0.5*(receiv + l.receiv))
replace recturn1 = . if recturn1<0

gen recturn2 = sales/(0.5*(receiv + ltmrec + l.receiv + l.ltmrec))
replace recturn2 = . if recturn2<0

gen recturn3 = sales/receiv
replace recturn3 = . if recturn3<0

gen payturn1 = cgsold/(0.5*(payab + l.payab))
replace payturn1 = . if payturn1<0


gen netpayturn = cgsold/(0.5*(payab - receiv + l.payab - l.receiv))


gen payturnmat = mater/(0.5*(payab + l.payab))
replace payturnmat = . if payturnmat<0

gen mcost2cgs = mater/cgs
replace mcost2cgs = . if mcost2cgs<0

gen payturn2 =cgsold/payab
replace payturn2 = . if payturn2<0

gen stdbtpay = stdebt/payab
replace stdbtpay = . if stdbtpay<0

gen invpayturn1 = 1/payturn1
gen invpaymat   = 1/payturnmat

*Take typical values for firms and counting instances

collapse (p50) recturn1 payturn1 payturnmat stdbtpay invpayturn1 netpayturn invpaymat mcost2cgs (count) nrecturn1=recturn1 npayturn1=payturn1 npayturnmat = payturnmat nstdbtpay=stdbtpay ninvpayturn1=invpayturn1 ninvpaymat=invpaymat nmcost2cgs = mcost2cgs nnetpayturn=netpayturn, by(wbcode compnumb sic3 sic)
pause
*Maintain only those firms that have at least 5 observations to erase cyclical effects

replace recturn1         = . if nrecturn<5
replace payturn1        = . if npayturn1<5
replace payturnmat    = . if npayturnmat<5
replace stdbtpay      	= . if nstdbtpay<5
replace invpayturn     = . if ninvpayturn1<5
replace invpaymat     = . if ninvpaymat<5
replace mcost2cgs     = . if nmcost2cgs<5
replace netpayturn    = . if nnetpayturn<5


preserve

collapse (p50) Rec = recturn1 Pay = payturn1 Paymat = payturnmat NetPay = netpayturn Std = stdbtpay InvPay = invpayturn1 InvPaymat = invpaymat Mcost2cgs = mcost2cgs (count) nrecturn1=recturn1 npayturn1=payturn1 npaymat = payturnmat nstdbtpay=stdbtpay ninvpay=invpayturn1 ninvpaymat = invpaymat nmcost2cgs=mcost2cgs nnetpayturn= netpayturn, by(wbcode)

replace Pay = . if npayturn1<10
replace Paymat = . if npaymat<10
replace InvPay = . if ninvpay<10
replace InvPaymat =. if ninvpaymat<10
replace Rec = . if nrec<10
replace Std = . if nstd<10
replace Mcost2cgs = . if nmcost2cgs<10
replace NetPay = . if nnetpayturn<10


save Trade_credit_measures_medians_102008, replace

*exit

restore

*Take typical values for industries within countries

collapse (p50) recturn1 payturn1 invpayturn stdbtpay (count) nrecturn1=recturn1 npayturn1=payturn1 nstdbtpay=stdbtpay ninvpayturn=invpayturn, by(wbcode sic3)

di in ye  "HERE"
*pause

egen npay = sum(npayt), by(wbcode)
egen nrec = sum(nrect), by(wbcode)
egen nstd = sum(nstdb), by(wbcode)
egen ninv = sum(ninvp), by(wbcode)

*pause

replace pay = . if npay<10
replace rec = . if nrec<10
replace std = . if nstd<10
replace invpay = . if ninv<10

*pause

qui replace rec = . if rec>1000
qui replace std = . if std>1000
qui replace pay = . if pay>1000
qui replace invpay = . if invpay>1

*pause

egen nsicconrec = count(rec), by(wbcode)
egen nsicconpay = count(pay), by(wbcode)
egen nsicconstd = count(std), by(wbcode)
egen nsicconinv = count(inv), by(wbcode)

*pause

replace rec = . if nsicconrec<3
replace pay = . if nsicconpay<3
replace std = . if nsicconstd<3
replace inv = . if nsicconinv<3

egen nrecind = count(rec), by(sic3)
egen npayind = count(pay), by(sic3)
egen nstdind = count(std), by(sic3)
egen ninvind = count(inv), by(sic3)

di in ye "HERE AGAIN"

pause

*Computing the values

*First defining the dummies appropiately
egen cty = group(wbcode) if nsicconpay >=3
egen ind = group(sic3) if npayind>=10

qui tab ind if npayind>=10, g(SIC_)
qui tab cty if nsicconpay >=3, g(CON_)

reg payturn CON_* SIC_*

pause
qui sum cty
local ncon = r(max)
qui sum ind
local nind = r(max)

local totalind = 0
gen PAY = .

forvalues i=1/`nind' {
capture local totalind = `totalind' + _b[SIC_`i']
}
local totalind = `totalind'/`nind'

forvalues i=1/`ncon' {
capture replace PAY = _b[_cons] + _b[CON_`i'] + `totalind' if cty==`i'
}

*Receivables
drop cty ind SIC_* CON_*

egen cty = group(wbcode) if nsicconrec >=3
egen ind = group(sic3) if nrecind>=10

qui tab ind if nrecind>=10, g(SIC_)
qui tab cty if nsicconrec >=3, g(CON_)

reg recturn CON_* SIC_*

pause
qui sum cty
local ncon = r(max)
qui sum ind
local nind = r(max)

local totalind = 0
gen REC = .

forvalues i=1/`nind' {
capture local totalind = `totalind' + _b[SIC_`i']
}
local totalind = `totalind'/`nind'

forvalues i=1/`ncon' {
capture replace REC = _b[_cons] + _b[CON_`i'] + `totalind' if cty==`i'
}

*Short term debt

drop cty ind SIC_* CON_*

egen cty = group(wbcode) if nsicconstd >=3
egen ind = group(sic3) if nstdind>=10

qui tab ind if nstdind>=10, g(SIC_)
qui tab cty if nsicconstd >=3, g(CON_)

reg stdbtpay CON_* SIC_*

pause
qui sum cty
local ncon = r(max)
qui sum ind
local nind = r(max)

local totalind = 0
gen STD = .

forvalues i=1/`nind' {
capture local totalind = `totalind' + _b[SIC_`i']
}
local totalind = `totalind'/`nind'

forvalues i=1/`ncon' {
capture replace STD = _b[_cons] + _b[CON_`i'] + `totalind' if cty==`i'
}

*Inverse turnover
drop cty ind SIC_* CON_*

egen cty = group(wbcode) if nsicconrec >=3
egen ind = group(sic3) if nrecind>=10

qui tab ind if nrecind>=10, g(SIC_)
qui tab cty if nsicconrec >=3, g(CON_)

reg invpay CON_* SIC_*

pause
qui sum cty
local ncon = r(max)
qui sum ind
local nind = r(max)

local totalind = 0
gen INVPAY = .

forvalues i=1/`nind' {
capture local totalind = `totalind' + _b[SIC_`i']
}
local totalind = `totalind'/`nind'

forvalues i=1/`ncon' {
capture replace INVPAY = _b[_cons] + _b[CON_`i'] + `totalind' if cty==`i'
}

drop cty ind SIC_* CON_*

collapse PAY INVPAY REC STD, by(wbcode)

save Trade_credit_measures_regressions_inv, replace
