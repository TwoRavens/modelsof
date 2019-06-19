* program CAREG1A to estimate basic regression 12/1/07, w/LYS stratification, edited OPN on 12/15/07
set more off


capture log close
log using c:\user\wei\ca\careg1a.log, replace
cd "c:\\user\wei\ca"
clear
use "CA_wERR.dta"
set more off

drop lys_er defacto_reinrog_er
merge cn year using EXRregimeIndex
drop _merge
sort cn year
merge cn year using real_eff_ifs

drop if current < -1
drop if lys_er == 1

sort country year
gen lagcurrent = current[_n-1] if year > 1970
gen lys = lys_er-2
gen open = opn/100


**** interaction terms

gen lagcurrentopen = lagcurrent*open
gen lagcurrentka = lagcurrent*kaopen


local filename WEI_strat.out
local switches se 3aster nolabel adjr2

**** full sample
 reg current lagcurrent if lys==0, robust
	outreg using "`filename'", replace `switches'
 reg current lagcurrent if lys==1, robust
	outreg using "`filename'", append `switches'
 reg current lagcurrent if lys==2, robust
	outreg using "`filename'", append `switches'
 reg current lagcurrent if lys==3, robust
	outreg using "`filename'", append `switches'


**** idc
 reg current lagcurrent if idc==1 & lys==0, robust
	outreg using "`filename'", append `switches'
 reg current lagcurrent if idc==1 & lys==1, robust
	outreg using "`filename'", append `switches'
 reg current lagcurrent if idc==1 & lys==2, robust
	outreg using "`filename'", append `switches'
 reg current lagcurrent if idc==1 & lys==3, robust
	outreg using "`filename'", append `switches'

**** non-idc
 reg current lagcurrent if idc!=1 & lys==0, robust
	outreg using "`filename'", append `switches'
 reg current lagcurrent if idc!=1 & lys==1, robust
	outreg using "`filename'", append `switches'
 reg current lagcurrent if idc!=1 & lys==2, robust
	outreg using "`filename'", append `switches'
 reg current lagcurrent if idc!=1 & lys==3, robust
	outreg using "`filename'", append `switches'


**** non-idc, non-oil
 reg current lagcurrent if idc!=1 & oil!=1 & lys==0, robust
	outreg using "`filename'", append `switches'
 reg current lagcurrent if idc!=1 & oil!=1 & lys==1, robust
	outreg using "`filename'", append `switches'
 reg current lagcurrent if idc!=1 & oil!=1 & lys==2, robust
	outreg using "`filename'", append `switches'
 reg current lagcurrent if idc!=1 & oil!=1 & lys==3, robust
	outreg using "`filename'", append `switches'


local filename WEI_strat_intr.out
local switches se 3aster nolabel adjr2

**** full sample
 reg current lagcurrent lagcurrentopen lagcurrentka open kaopen if lys==0, robust
	outreg using "`filename'", replace `switches'
 reg current lagcurrent lagcurrentopen lagcurrentka open kaopen if lys==1, robust
	outreg using "`filename'", append `switches'
 reg current lagcurrent lagcurrentopen lagcurrentka open kaopen if lys==2, robust
	outreg using "`filename'", append `switches'
 reg current lagcurrent lagcurrentopen lagcurrentka open kaopen if lys==3, robust
	outreg using "`filename'", append `switches'


**** idc
 reg current lagcurrent lagcurrentopen lagcurrentka open kaopen if idc==1 & lys==0, robust
	outreg using "`filename'", append `switches'
 reg current lagcurrent lagcurrentopen lagcurrentka open kaopen if idc==1 & lys==1, robust
	outreg using "`filename'", append `switches'
 reg current lagcurrent lagcurrentopen lagcurrentka open kaopen if idc==1 & lys==2, robust
	outreg using "`filename'", append `switches'
 reg current lagcurrent lagcurrentopen lagcurrentka open kaopen if idc==1 & lys==3, robust
	outreg using "`filename'", append `switches'

**** non-idc
 reg current lagcurrent lagcurrentopen lagcurrentka open kaopen if idc!=1 & lys==0, robust
	outreg using "`filename'", append `switches'
 reg current lagcurrent lagcurrentopen lagcurrentka open kaopen if idc!=1 & lys==1, robust
	outreg using "`filename'", append `switches'
 reg current lagcurrent lagcurrentopen lagcurrentka open kaopen if idc!=1 & lys==2, robust
	outreg using "`filename'", append `switches'
 reg current lagcurrent lagcurrentopen lagcurrentka open kaopen if idc!=1 & lys==3, robust
	outreg using "`filename'", append `switches'


**** non-idc, non-oil
 reg current lagcurrent lagcurrentopen lagcurrentka open kaopen if idc!=1 & oil!=1 & lys==0, robust
	outreg using "`filename'", append `switches'
 reg current lagcurrent lagcurrentopen lagcurrentka open kaopen if idc!=1 & oil!=1 & lys==1, robust
	outreg using "`filename'", append `switches'
 reg current lagcurrent lagcurrentopen lagcurrentka open kaopen if idc!=1 & oil!=1 & lys==2, robust
	outreg using "`filename'", append `switches'
 reg current lagcurrent lagcurrentopen lagcurrentka open kaopen if idc!=1 & oil!=1 & lys==3, robust
	outreg using "`filename'", append `switches'






log close



