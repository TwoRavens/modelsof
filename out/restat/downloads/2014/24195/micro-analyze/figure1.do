/** figure1.do

***/

clear
set mem 800m
set more off

capture log close
log using figure1.log,replace text


capture program drop doall
program define doall 

clear
use ../censusmicro/census`1'.dta

keep if hoursamp==1

**** Add weights for 1980
if `1' == 80 {
   gen perwt = 1
}

** Calculate shares in each cell
egen totwt = sum(perwt)
sort lincwgb
gen pctile = sum(perwt/totwt)
gen cut = int(pctile*100)
sort pctile
replace cut = 100 if _n==_N

*** Determine median size by pctile
egen tcwt = sum(perwt), by(cut)
egen size`1' = sum(perwt*size_a/tcwt), by(cut)

gen change = (cut~=cut[_n-1])
keep if change==1

keep cut lincwgb size`1'

rename lincwgb lincwgb`1'
if `1' ~= 80 {
	sort cut
	merge cut using tempb.dta
	tab _merge
	drop _merge
}

sort cut
save tempb.dta, replace

end

doall 80
doall 90
doall 00
doall 07

**** Set 80 as the base year
gen x8090 = lincwgb90-lincwgb80
gen x9000 = lincwgb00-lincwgb90
gen x0007 = lincwgb07-lincwgb00

l cut x8090 x9000 x0007, separator(0)
l cut size80 size90 size00 size07, separator(0)

log close

erase tempb.dta

