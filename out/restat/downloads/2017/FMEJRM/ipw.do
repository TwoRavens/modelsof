//propensity score reweighting
//generate propensity scores
use "eseecleaned.dta", clear
set more off
set scheme s2mono
local matchlist " lny2003 lny2004 lny2005 lny2006 lny2007  exp12003 exp12004 exp12005 exp12006 exp12007"
keep if year<2008  //before treatment
forvalues yr=2003/2007 {
foreach var in lny exp1 {
cap drop temp
gen temp=`var' if year==`yr'
bysort firmid: egen `var'`yr'=min(temp)
drop temp
}
}
forvalues yr=2004/2007 {
local a=`yr'-1
gen dlny`yr'=lny`yr'-lny`a'
}
gen dlny=d.lny
collapse (mean) pcaext `matchlist`nr'', by(firmid)
gen treat=(pcaext<=50)
replace treat=. if pcaext==.
probit treat `matchlist`nr'' 
predict psc
keep if psc!=.
gen ipw=psc/(1-psc) if treat==0
replace ipw=1 if treat==1
keep firmid ipw
save "ipw.dta", replace
