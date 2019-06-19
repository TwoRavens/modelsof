/*Modified to make the names of the relevant variables the same as in the main database*/
set mem 100m
fdause wstcredit

pause off
set more off

drop if compnumb==""
duplicates tag compnumb year, g(d)
drop if d>0

*Only manufactures

*keep if sic>=2000 & sic<3999

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

gen payturn2 =cgsold/payab
replace payturn2 = . if payturn2<0

gen stdbtpay = stdebt/payab
replace stdbtpay = . if stdbtpay<0

gen invpayturn1 = 1/payturn1

*Take typical values for firms and counting instances

collapse (p50) recturn1 payturn1 stdbtpay invpayturn1 (count) nrecturn1=recturn1 npayturn1=payturn1 nstdbtpay=stdbtpay ninvpayturn1=invpayturn1, by(wbcode compnumb sic3 sic)

*Maintain only those firms that have at least 5 observations to erase cyclical effects

replace recturn1         = . if nrecturn<5
replace payturn1        = . if npayturn<5
replace stdbtpay        = . if nstdbtpay<5
replace invpayturn1   = . if ninvpayturn1<5

preserve

collapse (p50) Rec = recturn1 Pay = payturn1 Std = stdbtpay InvPay = invpayturn1 (count) nrecturn1=recturn1 npayturn1=payturn1 nstdbtpay=stdbtpay ninvpay=invpayturn1, by(wbcode)

replace Pay = . if npay<10
replace InvPay = . if ninvpay<10
replace Rec = . if nrec<10
replace Std = . if nstd<10

rename InvPay InvPay_all
rename Std Std_all
rename  Pay Pay_all
rename Std Std_all


save Trade_credit_measures_medians_all, replace

