*This program computes the measures of trade credit utilization for the different countries
*Modified at the end so that the important final variables has the same name as in the final database
fdause WSTcredit.xpt

*First I just drop the conflictive cases. I prefer this to dealing with the reasons of repeated obs
preserve

drop if compnumb==""
duplicates tag compnumb year, g(d)
drop if d>0

egen id = group(compnumb)

tsset id year

gen recturn1 = (sales/(0.5*(receiv + l.receiv)))^-1

gen recturn2 = (sales/(0.5*(receiv + ltmrec + l.receiv + l.ltmrec)))^-1

gen recturn3 = (sales/receiv)^-1

gen payturn1 = (cgsold/(0.5*(payab + l.payab)))^-1

gen payturn2 = (cgsold/payab)^-1

gen stdbtpay = stdebt/payab


*Now I will collapse the values at the country level



collapse recturn1 recturn2 recturn3 payturn1 payturn2  stdbtpay (median) Recturn1=recturn1 Recturn2=recturn2 Recturn3=recturn3 ///
Payturn1=payturn1 Payturn2=payturn2 Stdbtpay=stdbtpay, by(wbcode country)

foreach v of varlist  recturn1 recturn2 recturn3 payturn1 payturn2  {
	rename `v' inv`v'
}

foreach v of varlist  Recturn1 Recturn2 Recturn3 Payturn1 Payturn2 {
	rename `v' Inv`v'
}

sort wbcode
label data "This one has the inverse ratios"

save Trade_credit_by_country_inv, replace
