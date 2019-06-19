* program NEWREG1A to estimate basic regression 10/16/09, w/LYS stratification, 
set more off


capture log close
log using c:\user\wei\ca\newreg1a.log, replace
cd "c:\\user\wei\ca"
clear
use "CA_wERR_HPFCA.dta"
set more off

drop lys_er defacto_reinrog_er
merge cn year using EXRregimeIndex
drop _merge
sort cn year
merge cn year using real_eff_ifs

drop if cn==537
drop if ca < -1
drop if lys_er == 1

sort country year
gen cadev = ca-hp_ca
gen lagcadev = cadev[_n-1] if year > 1970
gen lys = lys_er-2
gen open = opn/100


**** interaction terms

gen lagcadevopen = lagcadev*open
gen lagcadevka = lagcadev*kaopen


local filename WEI_strathp.out
local switches se  nolabel adjr2

**** full sample
 reg cadev lagcadev if lys==0, robust
	outreg2 using "`filename'", replace `switches'
 reg cadev lagcadev if lys==1, robust
	outreg2 using "`filename'", append `switches'
 reg cadev lagcadev if lys==2, robust
	outreg2 using "`filename'", append `switches'
 reg cadev lagcadev if lys==3, robust
	outreg2 using "`filename'", append `switches'


**** idc
 reg cadev lagcadev if idc==1 & lys==0, robust
	outreg2 using "`filename'", append `switches'
 reg cadev lagcadev if idc==1 & lys==1, robust
	outreg2 using "`filename'", append `switches'
 reg cadev lagcadev if idc==1 & lys==2, robust
	outreg2 using "`filename'", append `switches'
 reg cadev lagcadev if idc==1 & lys==3, robust
	outreg2 using "`filename'", append `switches'

**** non-idc
 reg cadev lagcadev if idc!=1 & lys==0, robust
	outreg2 using "`filename'", append `switches'
 reg cadev lagcadev if idc!=1 & lys==1, robust
	outreg2 using "`filename'", append `switches'
 reg cadev lagcadev if idc!=1 & lys==2, robust
	outreg2 using "`filename'", append `switches'
 reg cadev lagcadev if idc!=1 & lys==3, robust
	outreg2 using "`filename'", append `switches'


**** non-idc, non-oil
 reg cadev lagcadev if idc!=1 & oil!=1 & lys==0, robust
	outreg2 using "`filename'", append `switches'
 reg cadev lagcadev if idc!=1 & oil!=1 & lys==1, robust
	outreg2 using "`filename'", append `switches'
 reg cadev lagcadev if idc!=1 & oil!=1 & lys==2, robust
	outreg2 using "`filename'", append `switches'
 reg cadev lagcadev if idc!=1 & oil!=1 & lys==3, robust
	outreg2 using "`filename'", append `switches'


local filename WEI_strat_intrhp.out
local switches se  nolabel adjr2

**** full sample
 reg cadev lagcadev lagcadevopen lagcadevka open kaopen if lys==0, robust
	outreg2 using "`filename'", replace `switches'
 reg cadev lagcadev lagcadevopen lagcadevka open kaopen if lys==1, robust
	outreg2 using "`filename'", append `switches'
 reg cadev lagcadev lagcadevopen lagcadevka open kaopen if lys==2, robust
	outreg2 using "`filename'", append `switches'
 reg cadev lagcadev lagcadevopen lagcadevka open kaopen if lys==3, robust
	outreg2 using "`filename'", append `switches'


**** idc
 reg cadev lagcadev lagcadevopen lagcadevka open kaopen if idc==1 & lys==0, robust
	outreg2 using "`filename'", append `switches'
 reg cadev lagcadev lagcadevopen lagcadevka open kaopen if idc==1 & lys==1, robust
	outreg2 using "`filename'", append `switches'
 reg cadev lagcadev lagcadevopen lagcadevka open kaopen if idc==1 & lys==2, robust
	outreg2 using "`filename'", append `switches'
 reg cadev lagcadev lagcadevopen lagcadevka open kaopen if idc==1 & lys==3, robust
	outreg2 using "`filename'", append `switches'

**** non-idc
 reg cadev lagcadev lagcadevopen lagcadevka open kaopen if idc!=1 & lys==0, robust
	outreg2 using "`filename'", append `switches'
 reg cadev lagcadev lagcadevopen lagcadevka open kaopen if idc!=1 & lys==1, robust
	outreg2 using "`filename'", append `switches'
 reg cadev lagcadev lagcadevopen lagcadevka open kaopen if idc!=1 & lys==2, robust
	outreg2 using "`filename'", append `switches'
 reg cadev lagcadev lagcadevopen lagcadevka open kaopen if idc!=1 & lys==3, robust
	outreg2 using "`filename'", append `switches'


**** non-idc, non-oil
 reg cadev lagcadev lagcadevopen lagcadevka open kaopen if idc!=1 & oil!=1 & lys==0, robust
	outreg2 using "`filename'", append `switches'
 reg cadev lagcadev lagcadevopen lagcadevka open kaopen if idc!=1 & oil!=1 & lys==1, robust
	outreg2 using "`filename'", append `switches'
 reg cadev lagcadev lagcadevopen lagcadevka open kaopen if idc!=1 & oil!=1 & lys==2, robust
	outreg2 using "`filename'", append `switches'
 reg cadev lagcadev lagcadevopen lagcadevka open kaopen if idc!=1 & oil!=1 & lys==3, robust
	outreg2 using "`filename'", append `switches'






log close



