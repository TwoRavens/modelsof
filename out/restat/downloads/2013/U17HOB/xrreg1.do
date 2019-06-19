* program to estimate exchange rate regression 10/13/07, w/LYS dummy interactions, drop if lrer < 10
set more off


capture log close
log using c:\user\wei\ca\xrreg1.log, replace
cd "c:\\user\wei\ca"
clear
use "CA_wERR.dta"
set more off

drop lys_er defacto_reinrog_er
merge cn year using EXRregimeIndex
drop _merge
sort cn year
merge cn year using real_eff_ifs

gen lrer = log(real_eff_ifs)
drop if current < -1
drop if lrer > 10
drop if lys_er == 1

sort country year
gen lagcurrent = current[_n-1] if year > 1970
gen laglrer = lrer[_n-1] if year > 1970
gen lys = lys_er-2

drop if lrer >10
gen open=opn/100
gen lys0 = 0 if lys!=.
gen lys1 = 0 if lys!=.
gen lys2 = 0 if lys!=.
gen lys3 = 0 if lys!=.
replace lys0 = 1 if lys==0
replace lys1 = 1 if lys==1
replace lys2 = 1 if lys==2
replace lys3 = 1 if lys==3





**** interaction terms

gen laglreropen = laglrer*open
gen laglrerka = laglrer*kaopen
gen laglrer0 = laglrer*lys0
gen laglrer1 = laglrer*lys1
gen laglrer2 = laglrer*lys2
gen laglrer3 = laglrer*lys3



iis(cn)

local filename WEI_results_xr1.out
local switches se 3aster nolabel r2


**** full sample
xtreg lrer laglrer, fe robust cluster(cn)
	outreg using "`filename'", replace `switches'
xtreg lrer laglrer laglrer1 laglrer2 laglrer3 lys1 lys2 lys3, fe robust cluster(cn)
	outreg using "`filename'", append `switches'
xtreg lrer laglrer laglrer1 laglrer2 laglrer3 lys1 lys2 lys3 laglreropen laglrerka open kaopen, fe robust cluster(cn)
	outreg using "`filename'", append `switches'


**** idc
xtreg lrer laglrer if idc==1, fe robust cluster(cn)
	outreg using "`filename'", append `switches'

xtreg lrer laglrer laglrer1 laglrer2 laglrer3 lys1 lys2 lys3 if idc==1, fe robust cluster(cn)
	outreg using "`filename'", append `switches'
xtreg lrer laglrer laglrer1 laglrer2 laglrer3 lys1 lys2 lys3 laglreropen laglrerka open kaopen if idc==1, fe robust cluster(cn)
	outreg using "`filename'", append `switches'

**** non-idc
xtreg lrer laglrer if idc!=1, fe robust cluster(cn)
	outreg using "`filename'", append `switches'

xtreg lrer laglrer laglrer1 laglrer2 laglrer3 lys1 lys2 lys3 if idc!=1, fe robust cluster(cn)
	outreg using "`filename'", append `switches'
xtreg lrer laglrer laglrer1 laglrer2 laglrer3 lys1 lys2 lys3 laglreropen laglrerka open kaopen if idc!=1, fe robust cluster(cn)
	outreg using "`filename'", append `switches'

**** non-idc, non-oil
xtreg lrer laglrer if idc!=1 & oil!=1, fe robust cluster(cn)
	outreg using "`filename'", append `switches'

xtreg lrer laglrer laglrer1 laglrer2 laglrer3 lys1 lys2 lys3 if idc!=1 & oil!=1, fe robust cluster(cn)
	outreg using "`filename'", append `switches'
xtreg lrer laglrer laglrer1 laglrer2 laglrer3 lys1 lys2 lys3 laglreropen laglrerka open kaopen if idc!=1 & oil!=1, fe robust cluster(cn)
	outreg using "`filename'", append `switches'



log close



