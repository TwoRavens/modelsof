*-----------------------------------------------------------------------------------------------------------------------------*
* This do file constructs the trade datasets needed to compute the agricultural shocks used in Berman and Couttenier (2014)   *
* This version: dec. 2, 2013
*-----------------------------------------------------------------------------------------------------------------------------*
*
/* append all years */

cd "$trade"
forvalue x=1989(1)2007{
use comtrade\hs6_ISIC3_`x', clear
rename i exp
rename j imp
rename t year
rename v trade
rename q qty
keep exp imp year trade hs6 qty
collapse (sum) trade qty, by(exp imp hs6 year)
save  comtrade\baci`x', replace
}

************************
* A - WORLD DEMAND HS4 *
************************
*
cd "$trade"
forvalues x=1989(1)2007{
use comtrade\baci`x', clear
drop if year==.
g hs4=substr(hs6,1,4)
collapse (sum) trade, by(hs4 year)
save comtrade\temp`x', replace
}
use comtrade\temp1989, clear
forvalues x=1990(1)2007{
append using comtrade\temp`x'
sort hs4 year
}
destring hs4, replace force
*
forvalues x=1989(1)2007{
erase comtrade\temp`x'.dta
}
sort hs4 year
save comtrade_hs4_world, replace
*
********************
* B - UNIT VALUES  *
********************
*
cd "$trade"
forvalues x=1989(1)2007{
use comtrade\baci`x', clear
drop if year==.
g hs4=substr(hs6,1,4)
collapse (sum) trade qty, by(hs4 year)
save comtrade\temp`x', replace
}
use comtrade\temp1989, clear
forvalues x=1990(1)2007{
append using comtrade\temp`x'
sort hs4 year
}
destring hs4, replace force
*
forvalues x=1989(1)2007{
erase comtrade\temp`x'.dta
}
*
g uv = trade/qty
collapse (mean) uv, by(hs4)
rename hs4 hs
sort hs
save unit_values, replace
*
************************************
* C * COUNTRY-SPECIFIC IMPORTS HS4 *
************************************
*
cd "$trade"
*
forvalues x=1989(1)2007{
use comtrade\baci`x', clear
drop if year==.
g hs4=substr(hs6,1,4)
destring imp, replace force
rename imp code
sort code
merge code using comtrade\country_codes_iso, nokeep
tab _merge
keep if _merge == 3
collapse (sum) trade, by(hs4 iso3 year)
save comtrade\temp`x', replace
}
use comtrade\temp1989, clear
forvalues x=1990(1)2007{
append using comtrade\temp`x'
}
sort hs4 year
forvalues x=1989(1)2007{
erase comtrade\temp`x'.dta
}
destring hs4, replace force
sort iso3 hs4 year
*
rename trade import_ikt
*
save comtrade_hs4_all_m, replace
*
************************************
* D * COUNTRY-SPECIFIC EXPORTS HS4 *
************************************
*
cd "$trade"
*
forvalues x=1989(1)2007{
use comtrade\baci`x', clear
drop if year==.
g hs4=substr(hs6,1,4)
destring exp, replace force
rename exp code
sort code
merge code using comtrade\country_codes_iso, nokeep
tab _merge
tab iso3 if _merge == 2
collapse (sum) trade, by(hs4 iso3 year)
save comtrade\temp`x', replace
}
use comtrade\temp1989, clear
forvalues x=1990(1)2007{
append using comtrade\temp`x'
}
sort hs4 year
forvalues x=1989(1)2007{
erase comtrade\temp`x'.dta
}
destring hs4, replace force
sort iso3 hs4 year
*
rename trade export_ikt
save comtrade_hs4_all, replace
*
