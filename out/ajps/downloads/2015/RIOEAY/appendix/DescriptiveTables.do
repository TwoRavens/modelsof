
* Appendix: Tables with descriptive information




set more off
set seed 63521



*  ======================================
*  =  Table S.2 Descriptive Statistics  =
*  ======================================

use "../Data.dta", clear
* rescale vars for display 
replace income_ppp2005 = income_ppp2005/10000
replace Rgdp = Rgdp/10000
replace incdist = incdist/10000
foreach v of varlist transue transnlf female victim lowsup smempl whcol blcol skillshg skillslg skillssp Rforeign {
    replace `v' = `v'*100
}


* Listwise column: continous vars followed by categ.
tabstat income_ppp2005 incdist age eduyrs hhmmb Rtech Rgdp Rgini Rforeign Ruerate if _mi_m==0, stat(mean sd) col(stats) format(%5.2f)
tabstat transue transnlf female victim lowsup smempl whcol blcol skillshg skillslg skillssp if _mi_m==0, stat(mean) col(stats) format(%5.1f)


* Imputed column
tabstat income_ppp2005 incdist age eduyrs hhmmb Rtech Rgdp Rgini Rforeign Ruerate if _mi_m!=0, stat(mean sd) col(stats) format(%5.2f)
tabstat transue transnlf female victim lowsup smempl whcol blcol skillshg skillslg skillssp if _mi_m!=0, stat(mean) col(stats) format(%5.1f)


* Missings count (divide by 96682)
nmissing income_ppp2005 eduyrs transue hhmmb victim






*  ======================================================
*  =  Table S.7 Individuals classified as poor / rich   =
*  ======================================================

use "../Data.dta", clear

* Poor, rich indicator vars
gen inc_lo = 0
replace inc_lo = 1 if incdist < -25000
gen inc_hi = 0
replace inc_hi = 1 if incdist > 30000

* Columns: "N"
qui levelsof cntry, local(countries)
foreach c of local countries {
    dis "`c'"
    count if inc_lo==1 & cntry=="`c'"
    count if inc_hi==1 & cntry=="`c'"
}


* Columns: "Percent"
qui levelsof cntry, local(countries)
replace inc_lo = inc_lo*100
replace inc_hi = inc_hi*100
foreach c of local countries {
    dis "`c'"
    mean inc_lo inc_hi if cntry=="`c'", cformat(%5.2f)
}

