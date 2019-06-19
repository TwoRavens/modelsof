* program CAREG1IV to estimate basic regression 1/1/08, w/LYS dummy variables, and Instrumental Variables,
* delete regional dummies 2/21/09
set more off


capture log close
log using c:\user\wei\ca\careg1iv.log, replace
cd "c:\\user\wei\ca"
clear
use "CA_wERR2-Feb2009.dta"
set more off

* drop lys_er defacto_reinrog_er
* merge cn year using EXRregimeIndex
* drop _merge
* sort cn year
* merge cn year using real_eff_ifs

drop _merge
sort ccode
merge ccode using excerpt

** screen outliers
drop if current < -1
drop if lys_er == 1

** generate initial reserves
sort cn year
gen resgdp = atregold/nyus if year > 1960

gen iniresgdpyr = 0
qui by cn: replace iniresgdpyr = 1 if resgdp != .
qui by cn: gen diffyr = iniresgdpyr[_n]-iniresgdpyr[_n-1]
gen iniresgdpyr2 = 0
qui by cn: replace iniresgdpyr2 = 1 if diffyr == 1 | (iniresgdpyr == 1 & _n == 1)
qui by cn: gen iniresgdpx = resgdp if iniresgdpyr2 == 1
sort cn year
egen iniresgdp = sum(iniresgdpx), by(cn)


*** generate variables

* gen lagcurrent = current[_n-1] if year > 1970
* gen lys = lys_er-2
* gen open = opn/100

gen larea = log(area)
gen lryppp = log(ryppp)



gen lys0 = 0 if lys!=.
gen lys1 = 0 if lys!=.
gen lys2 = 0 if lys!=.
gen lys3 = 0 if lys!=.
replace lys0 = 1 if lys==0
replace lys1 = 1 if lys==1
replace lys2 = 1 if lys==2
replace lys3 = 1 if lys==3

local filename WEI_dintr_iv1s.out
local switches se  nolabel 



**** IV regimes
probit lys0 island larea lryppp iniresgdp 
	outreg2 using "`filename'", replace `switches'
 predict lys0hat
 gen lys0h = 0 if lys0!=.
 replace lys0h = 1 if lys0hat > 0.5
 replace lys0h = . if lys0==.
probit lys1 island larea lryppp iniresgdp 
	outreg2 using "`filename'", append `switches'
 predict lys1hat
 gen lys1h = 0 if lys1!=.
 replace lys1h = 1 if lys1hat > 0.5
 replace lys1h = . if lys1==.

probit lys2 island larea lryppp iniresgdp 
	outreg2 using "`filename'", append `switches'
 predict lys2hat
 gen lys2h = 0 if lys2!=.
 replace lys2h = 1 if lys2hat > 0.5
 replace lys2h = . if lys2==.

probit lys3 island larea lryppp iniresgdp 
	outreg2 using "`filename'", append `switches'
 predict lys3hat
 gen lys3h = 0 if lys3!=.
 replace lys3h = 1 if lys3hat > 0.5
 replace lys3h = . if lys3==.



**** interaction terms

* gen lagcurrentopn = lagcurrent*opn
* gen lagcurrentka = lagcurrent*kaopen
gen lagcurrent0h = lagcurrent*lys0h
gen lagcurrent1h = lagcurrent*lys1h
gen lagcurrent2h = lagcurrent*lys2h
gen lagcurrent3h = lagcurrent*lys3h



local filename WEI_dintr_iv2s.out
local switches se  nolabel adjr2

**** full sample
 reg current lagcurrent lagcurrent1h lagcurrent2h lagcurrent3h lys1h lys2h lys3h, robust
	outreg2 using "`filename'", replace `switches'

**** idc
 reg current lagcurrent lagcurrent1h lagcurrent2h lagcurrent3h lys1h lys2h lys3h if idc==1, robust
	outreg2 using "`filename'", append `switches'

**** non-idc
 reg current lagcurrent lagcurrent1h lagcurrent2h lagcurrent3h lys1h lys2h lys3h if idc!=1, robust
	outreg2 using "`filename'", append `switches'
 
**** non-idc, non-oil
 reg current lagcurrent lagcurrent1h lagcurrent2h lagcurrent3h lys1h lys2h lys3h if idc!=1 & oil==0, robust
	outreg2 using "`filename'", append `switches'
 
**** full sample
 reg current lagcurrent lagcurrent1h lagcurrent2h lagcurrent3h lys1h lys2h lys3h lagcurrentopn lagcurrentka opn kaopen, robust
	outreg2 using "`filename'", append `switches'

**** idc
 reg current lagcurrent lagcurrent1h lagcurrent2h lagcurrent3h lys1h lys2h lys3h lagcurrentopn lagcurrentka opn kaopen if idc==1, robust
	outreg2 using "`filename'", append `switches'

**** non-idc
 reg current lagcurrent lagcurrent1h lagcurrent2h lagcurrent3h lys1h lys2h lys3h lagcurrentopn lagcurrentka opn kaopen if idc!=1, robust
	outreg2 using "`filename'", append `switches'

**** non-idc, non-oil
 reg current lagcurrent lagcurrent1h lagcurrent2h lagcurrent3h lys1h lys2h lys3h lagcurrentopn lagcurrentka opn kaopen if idc!=1 & oil==0, robust
	outreg2 using "`filename'", append `switches'

log close



