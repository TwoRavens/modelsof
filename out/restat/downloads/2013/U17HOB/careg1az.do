* program CAREG1AZ to estimate basic regression 12/1/07, w/LYS stratification, edited OPN on 12/15/07 rev to nonlin 2/12/09
* add test to compare against earlier data set 2/20/09

set more off


capture log close
log using c:\user\wei\ca\careg1az.log, replace
cd "c:\\user\wei\ca"
clear
use "CA_wERR2-Feb2009.dta"
set more off

* drop lys_er defacto_reinrog_er
* merge cn year using EXRregimeIndex
* drop _merge
* sort cn year
* merge cn year using real_eff_ifs

* drop if current < -1
* drop if lys_er == 1

sort country year
* gen lagcurrent = current[_n-1] if year > 1970
* gen lys = lys_er-2
gen open = opn/100
gen pos = 0
replace pos = 1 if lagcurrent > 0



**** interaction terms
gen lagcurrentabs = lagcurrent*((lagcurrent^2)^.5)
gen lagcurrentpos = lagcurrent*pos
gen lagcurrentabspos = lagcurrentabs*pos
gen lagcurrentopen = lagcurrent*open
* gen lagcurrentka = lagcurrent*kaopen
* gen lagcurrentlys = lagcurrent*lys

local filename WEI_strat_test.out
local switches se nolabel adjr2

**** full sample
 reg current lagcurrent if lys==0, robust
	outreg2 using "`filename'", replace `switches'
 reg current lagcurrent if lys==1, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent if lys==2, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent if lys==3, robust
	outreg2 using "`filename'", append `switches'


**** idc
 reg current lagcurrent if idc==1 & lys==0, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent if idc==1 & lys==1, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent if idc==1 & lys==2, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent if idc==1 & lys==3, robust
	outreg2 using "`filename'", append `switches'

**** non-idc
 reg current lagcurrent if idc!=1 & lys==0, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent if idc!=1 & lys==1, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent if idc!=1 & lys==2, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent if idc!=1 & lys==3, robust
	outreg2 using "`filename'", append `switches'


**** non-idc, non-oil
 reg current lagcurrent if idc!=1 & oil!=1 & lys==0, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent if idc!=1 & oil!=1 & lys==1, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent if idc!=1 & oil!=1 & lys==2, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent if idc!=1 & oil!=1 & lys==3, robust
	outreg2 using "`filename'", append `switches'






local filename WEI_stratz.out
local switches se nolabel adjr2

**** full sample
 reg current lagcurrent lagcurrentabs if lys==0, robust
	outreg2 using "`filename'", replace `switches'
 reg current lagcurrent lagcurrentabs if lys==1, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent lagcurrentabs if lys==2, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent lagcurrentabs if lys==3, robust
	outreg2 using "`filename'", append `switches'


**** idc
 reg current lagcurrent lagcurrentabs if idc==1 & lys==0, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent lagcurrentabs if idc==1 & lys==1, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent lagcurrentabs if idc==1 & lys==2, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent lagcurrentabs if idc==1 & lys==3, robust
	outreg2 using "`filename'", append `switches'

**** non-idc
 reg current lagcurrent lagcurrentabs if idc!=1 & lys==0, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent lagcurrentabs if idc!=1 & lys==1, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent lagcurrentabs if idc!=1 & lys==2, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent lagcurrentabs if idc!=1 & lys==3, robust
	outreg2 using "`filename'", append `switches'


**** non-idc, non-oil
 reg current lagcurrent lagcurrentabs if idc!=1 & oil!=1 & lys==0, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent lagcurrentabs if idc!=1 & oil!=1 & lys==1, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent lagcurrentabs if idc!=1 & oil!=1 & lys==2, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent lagcurrentabs if idc!=1 & oil!=1 & lys==3, robust
	outreg2 using "`filename'", append `switches'


local filename WEI_strat_intrz.out
local switches se nolabel adjr2

**** full sample
 reg current lagcurrent lagcurrentabs lagcurrentopen lagcurrentka open kaopen if lys==0, robust
	outreg2 using "`filename'", replace `switches'
 reg current lagcurrent lagcurrentabs lagcurrentopen lagcurrentka open kaopen if lys==1, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent lagcurrentabs lagcurrentopen lagcurrentka open kaopen if lys==2, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent lagcurrentabs lagcurrentopen lagcurrentka open kaopen if lys==3, robust
	outreg2 using "`filename'", append `switches'


**** idc
 reg current lagcurrent lagcurrentabs lagcurrentopen lagcurrentka open kaopen if idc==1 & lys==0, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent lagcurrentabs lagcurrentopen lagcurrentka open kaopen if idc==1 & lys==1, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent lagcurrentabs lagcurrentopen lagcurrentka open kaopen if idc==1 & lys==2, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent lagcurrentabs lagcurrentopen lagcurrentka open kaopen if idc==1 & lys==3, robust
	outreg2 using "`filename'", append `switches'

**** non-idc
 reg current lagcurrent lagcurrentabs lagcurrentopen lagcurrentka open kaopen if idc!=1 & lys==0, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent lagcurrentabs lagcurrentopen lagcurrentka open kaopen if idc!=1 & lys==1, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent lagcurrentabs lagcurrentopen lagcurrentka open kaopen if idc!=1 & lys==2, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent lagcurrentabs lagcurrentopen lagcurrentka open kaopen if idc!=1 & lys==3, robust
	outreg2 using "`filename'", append `switches'


**** non-idc, non-oil
 reg current lagcurrent lagcurrentabs lagcurrentopen lagcurrentka open kaopen if idc!=1 & oil!=1 & lys==0, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent lagcurrentabs lagcurrentopen lagcurrentka open kaopen if idc!=1 & oil!=1 & lys==1, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent lagcurrentabs lagcurrentopen lagcurrentka open kaopen if idc!=1 & oil!=1 & lys==2, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent lagcurrentabs lagcurrentopen lagcurrentka open kaopen if idc!=1 & oil!=1 & lys==3, robust
	outreg2 using "`filename'", append `switches'


local filename WEI_strat_posz.out
local switches se nolabel adjr2

**** full sample
 reg current lagcurrent lagcurrentpos lagcurrentopen lagcurrentka open kaopen if lys==0, robust
	outreg2 using "`filename'", replace `switches'
 reg current lagcurrent lagcurrentpos lagcurrentopen lagcurrentka open kaopen if lys==1, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent lagcurrentpos lagcurrentopen lagcurrentka open kaopen if lys==2, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent lagcurrentpos lagcurrentopen lagcurrentka open kaopen if lys==3, robust
	outreg2 using "`filename'", append `switches'


**** idc
 reg current lagcurrent lagcurrentpos lagcurrentopen lagcurrentka open kaopen if idc==1 & lys==0, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent lagcurrentpos lagcurrentopen lagcurrentka open kaopen if idc==1 & lys==1, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent lagcurrentpos lagcurrentopen lagcurrentka open kaopen if idc==1 & lys==2, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent lagcurrentpos lagcurrentopen lagcurrentka open kaopen if idc==1 & lys==3, robust
	outreg2 using "`filename'", append `switches'

**** non-idc
 reg current lagcurrent lagcurrentpos lagcurrentopen lagcurrentka open kaopen if idc!=1 & lys==0, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent lagcurrentpos lagcurrentopen lagcurrentka open kaopen if idc!=1 & lys==1, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent lagcurrentpos lagcurrentopen lagcurrentka open kaopen if idc!=1 & lys==2, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent lagcurrentpos lagcurrentopen lagcurrentka open kaopen if idc!=1 & lys==3, robust
	outreg2 using "`filename'", append `switches'


**** non-idc, non-oil
 reg current lagcurrent lagcurrentpos lagcurrentopen lagcurrentka open kaopen if idc!=1 & oil!=1 & lys==0, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent lagcurrentpos lagcurrentopen lagcurrentka open kaopen if idc!=1 & oil!=1 & lys==1, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent lagcurrentpos lagcurrentopen lagcurrentka open kaopen if idc!=1 & oil!=1 & lys==2, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent lagcurrentpos lagcurrentopen lagcurrentka open kaopen if idc!=1 & oil!=1 & lys==3, robust
	outreg2 using "`filename'", append `switches'


local filename WEI_strat_intrposz.out
local switches se nolabel adjr2

**** full sample
 reg current lagcurrent lagcurrentabs lagcurrentabspos lagcurrentopn lagcurrentka opn kaopen if lys==0, robust
	outreg2 using "`filename'", replace `switches'
 reg current lagcurrent lagcurrentabs lagcurrentabspos lagcurrentopn lagcurrentka opn kaopen if lys==1, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent lagcurrentabs lagcurrentabspos lagcurrentopn lagcurrentka opn kaopen if lys==2, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent lagcurrentabs lagcurrentabspos lagcurrentopn lagcurrentka opn kaopen if lys==3, robust
	outreg2 using "`filename'", append `switches'


**** idc
 reg current lagcurrent lagcurrentabs lagcurrentabspos lagcurrentopn lagcurrentka opn kaopen if idc==1 & lys==0, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent lagcurrentabs lagcurrentabspos lagcurrentopn lagcurrentka opn kaopen if idc==1 & lys==1, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent lagcurrentabs lagcurrentabspos lagcurrentopn lagcurrentka opn kaopen if idc==1 & lys==2, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent lagcurrentabs lagcurrentabspos lagcurrentopn lagcurrentka opn kaopen if idc==1 & lys==3, robust
	outreg2 using "`filename'", append `switches'

**** non-idc
 reg current lagcurrent lagcurrentabs lagcurrentabspos lagcurrentopn lagcurrentka opn kaopen if idc!=1 & lys==0, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent lagcurrentabs lagcurrentabspos lagcurrentopn lagcurrentka opn kaopen if idc!=1 & lys==1, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent lagcurrentabs lagcurrentabspos lagcurrentopn lagcurrentka opn kaopen if idc!=1 & lys==2, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent lagcurrentabs lagcurrentabspos lagcurrentopn lagcurrentka opn kaopen if idc!=1 & lys==3, robust
	outreg2 using "`filename'", append `switches'


**** non-idc, non-oil
 reg current lagcurrent lagcurrentabs lagcurrentabspos lagcurrentopn lagcurrentka opn kaopen if idc!=1 & oil!=1 & lys==0, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent lagcurrentabs lagcurrentabspos lagcurrentopn lagcurrentka opn kaopen if idc!=1 & oil!=1 & lys==1, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent lagcurrentabs lagcurrentabspos lagcurrentopn lagcurrentka opn kaopen if idc!=1 & oil!=1 & lys==2, robust
	outreg2 using "`filename'", append `switches'
 reg current lagcurrent lagcurrentabs lagcurrentabspos lagcurrentopn lagcurrentka opn kaopen if idc!=1 & oil!=1 & lys==3, robust
	outreg2 using "`filename'", append `switches'






log close



