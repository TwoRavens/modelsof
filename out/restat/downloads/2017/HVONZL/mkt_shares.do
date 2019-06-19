//
// Two-sided Heterogeneity and Trade
// 

/* This file calculates market shares which are used in the main analysis. 
 Use IDSB database from UNIDO - total imports, exports and output at the 4-digit level of ISIC Rev 3. 127 manufacturing industries.
 Use bilateral trade data for Norway and Sweden from BACI, at ISIC Rev. 3 level. */


// Import absorption from UNIDO
// Data is in 1000s USD, current prices
import excel using IDSB_UNIDO.xlsx, clear first
destring CountryCode, gen(isonum)
destring Year, replace
destring ISIC, replace
drop ISICComb
destring Output, replace force
destring ImportsWorld, replace force
destring ExportsWorld, replace force
destring Apparent, replace force
ren Apparent abs
ren Year year
label var output "Output, manufacturing, USD, nominal values" 
label var abs "Absorption, manufacturing, USD, nominal values" 
save IDSB_UNIDO, replace

use IDSB_UNIDO, clear
replace isonum=842 if isonum==840 // USA
replace isonum=251 if isonum==250 // France
replace isonum=381 if isonum==380 // Italy
replace isonum=579 if isonum==578 // Norway
replace isonum=757 if isonum==756 // Switzerland
merge n:1 isonum using Comtrade/country_codes.dta, keep(match master)
replace iso2="TW" if isonum==158
drop if iso2==""
drop country* start* end* ctycomments _merge
drop CountryCode isonum
order iso2 year ISIC
ren ISIC isicr3
save absorption, replace

//
// Check total imports in UNIDO vs BACI
//
use ../baci/isicr3/baci_all, clear
drop if exp==""
drop if imp==""
collapse (sum) value, by(imp isicr3 year)
ren value totimp
save totimp, replace

use absorption, clear
ren iso2 imp
merge 1:1 imp isicr3 year using totimp, keep(match master)
sum totimp ImportsWorld
corr totimp ImportsWorld // good
gen ratio = totimp/ImportsWorld
sum ratio, det
gen lnratio = log(ratio)
hist lnratio

//
// Get bilateral trade data for NO and SE, in current 1000 USD
//
use ../baci/isicr3/baci_all, clear
keep if imp=="NO"
drop if exp==""
ren value imports_to_NO, replace
ren exp iso2
drop imp
save imports_to_NO, replace

use ../baci/isicr3/baci_all, clear
keep if exp=="NO"
drop if imp==""
ren value exports_from_NO, replace
ren imp iso2
drop exp
save exports_from_NO, replace

use ../baci/isicr3/baci_all, clear
keep if exp=="SE"
drop if imp==""
ren value exports_from_SE, replace
ren imp iso2
drop exp
save exports_from_SE, replace

use ../baci/isicr3/baci_all, clear
keep if exp=="SE" | exp=="FI" | exp=="DK" | exp=="IS"
drop if imp==""
collapse (sum) value, by(year isicr3 imp)
ren value exports_from_Nordic, replace
ren imp iso2
save exports_from_Nordic, replace

use ../baci/isicr3/baci_all, clear
drop if exp=="NO"
drop if exp==""
drop if imp==""
collapse (sum) value, by(year isicr3 imp)
ren value exports_from_All, replace
ren imp iso2
save exports_from_All, replace

use ../baci/isicr3/baci_all, clear
keep if imp=="SE"
drop if exp==""
ren value imports_to_SE, replace
ren exp iso2
drop imp
save imports_to_SE, replace



// Calculate (i) NO mkt share in country j, (ii) SE mkt share in country j 
// (iii) j mkt share in Norway, (iv) j mkt share in Sweden
// (v) import share of country j, except Norway.

use absorption, clear
merge 1:1 iso2 isicr3 year using imports_to_NO, keep(match master)
drop _merge
merge 1:1 iso2 isicr3 year using imports_to_SE, keep(match master)
drop _merge
merge 1:1 iso2 isicr3 year using exports_from_NO, keep(match master)
drop _merge
merge 1:1 iso2 isicr3 year using exports_from_SE, keep(match master)
drop _merge
merge 1:1 iso2 isicr3 year using exports_from_Nordic, keep(match master)
drop _merge
merge 1:1 iso2 isicr3 year using exports_from_All, keep(match master)
drop _merge

foreach i of varlist imports_* exports_* {
  replace `i' = 0 if `i'==.
}

gen tmp = abs if iso2=="NO"
egen absNO = max(tmp), by(isicr3 year)
capture drop tmp
gen tmp = abs if iso2=="SE"
egen absSE = max(tmp), by(isicr3 year)

gen shNOinj = exports_from_NO/abs
gen shSEinj = exports_from_SE/abs
gen shNordicinj = exports_from_Nordic/abs
gen shjinNO = imports_to_NO/absNO
gen shjinSE = imports_to_SE/absSE

save mkt_sh, replace
