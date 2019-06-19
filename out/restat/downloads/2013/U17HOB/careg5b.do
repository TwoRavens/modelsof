* program to estimate dummy variable based regressions LYS 12/2/07, SIZE issues
set more off


capture log close
log using c:\user\wei\ca\careg5b.log, replace
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
gen g7 = 0
replace g7=1 if cn==111 | cn==112 | cn==158 | cn==136 | cn==134 | cn==132 | cn==156

* gen lryus = log(ryus)
* gen lryppp = log(ryppp)



gen lys0 = 0 if lys!=.
gen lys1 = 0 if lys!=.
gen lys2 = 0 if lys!=.
gen lys3 = 0 if lys!=.
replace lys0 = 1 if lys==0
replace lys1 = 1 if lys==1
replace lys2 = 1 if lys==2
replace lys3 = 1 if lys==3

sort year
egen avggdpus = mean(ryus), by(year)
egen avggdpppp = mean(ryppp), by(year)


sort cn year


**** interaction terms

gen lagcurrentopen = lagcurrent*open
gen lagcurrentka = lagcurrent*kaopen
gen lagcurrent0 = lagcurrent*lys0
gen lagcurrent1 = lagcurrent*lys1
gen lagcurrent2 = lagcurrent*lys2
gen lagcurrent3 = lagcurrent*lys3


local filename WEI_size.out
local switches se 3aster nolabel adjr2

**** Large in log USD terms > avggdpus
reg current lagcurrent if ryus > avggdpus, robust
	outreg using "`filename'", replace `switches'

reg current lagcurrent lagcurrent1 lagcurrent2 lagcurrent3 lys1 lys2 lys3 if ryus > avggdpus, robust
	outreg using "`filename'", append `switches'
reg current lagcurrent lagcurrent1 lagcurrent2 lagcurrent3 lys1 lys2 lys3 lagcurrentopen open if ryus > avggdpus, robust
	outreg using "`filename'", append `switches'
reg current lagcurrent lagcurrent1 lagcurrent2 lagcurrent3 lys1 lys2 lys3 lagcurrentopen lagcurrentka open kaopen if ryus > avggdpus, robust
	outreg using "`filename'", append `switches'


**** Small in log USD terms < avggdpus
reg current lagcurrent if ryus < avggdpus, robust
	outreg using "`filename'", append `switches'

reg current lagcurrent lagcurrent1 lagcurrent2 lagcurrent3 lys1 lys2 lys3 if ryus < avggdpus, robust
	outreg using "`filename'", append `switches'
reg current lagcurrent lagcurrent1 lagcurrent2 lagcurrent3 lys1 lys2 lys3 lagcurrentopen open if ryus < avggdpus, robust
	outreg using "`filename'", append `switches'
reg current lagcurrent lagcurrent1 lagcurrent2 lagcurrent3 lys1 lys2 lys3 lagcurrentopen lagcurrentka open kaopen if ryus < avggdpus, robust
	outreg using "`filename'", append `switches'

**** Large in log PPP terms > avggdpppp
reg current lagcurrent if ryppp > avggdpppp, robust
	outreg using "`filename'", append `switches'

reg current lagcurrent lagcurrent1 lagcurrent2 lagcurrent3 lys1 lys2 lys3 if ryppp > avggdpppp, robust
	outreg using "`filename'", append `switches'
reg current lagcurrent lagcurrent1 lagcurrent2 lagcurrent3 lys1 lys2 lys3 lagcurrentopen open if ryppp > avggdpppp, robust
	outreg using "`filename'", append `switches'
reg current lagcurrent lagcurrent1 lagcurrent2 lagcurrent3 lys1 lys2 lys3 lagcurrentopen lagcurrentka open kaopen if ryppp > avggdpppp, robust
	outreg using "`filename'", append `switches'

**** Small in log PPP terms < avggdpppp
reg current lagcurrent if ryppp < avggdpppp, robust
	outreg using "`filename'", append `switches'

reg current lagcurrent lagcurrent1 lagcurrent2 lagcurrent3 lys1 lys2 lys3 if ryppp < avggdpppp, robust
	outreg using "`filename'", append `switches'
reg current lagcurrent lagcurrent1 lagcurrent2 lagcurrent3 lys1 lys2 lys3 lagcurrentopen open if ryppp < avggdpppp, robust
	outreg using "`filename'", append `switches'
reg current lagcurrent lagcurrent1 lagcurrent2 lagcurrent3 lys1 lys2 lys3 lagcurrentopen lagcurrentka open kaopen if ryppp < avggdpppp, robust
	outreg using "`filename'", append `switches'



local filename WEI_g7.out
local switches se 3aster nolabel adjr2


**** If G7
 reg current lagcurrent if g7==1, robust
	outreg using "`filename'", replace `switches'

reg current lagcurrent lagcurrent1 lagcurrent2 lagcurrent3 lys1 lys2 lys3 if g7==1, robust
	outreg using "`filename'", append `switches'
reg current lagcurrent lagcurrent1 lagcurrent2 lagcurrent3 lys1 lys2 lys3 lagcurrentopen open if g7==1, robust
	outreg using "`filename'", append `switches'
reg current lagcurrent lagcurrent1 lagcurrent2 lagcurrent3 lys1 lys2 lys3 lagcurrentopen lagcurrentka open kaopen if g7==1, robust
	outreg using "`filename'", append `switches'


**** If not g7
 reg current lagcurrent if g7!=1, robust
	outreg using "`filename'", append `switches'

reg current lagcurrent lagcurrent1 lagcurrent2 lagcurrent3 lys1 lys2 lys3 if g7!=1, robust
	outreg using "`filename'", append `switches'
reg current lagcurrent lagcurrent1 lagcurrent2 lagcurrent3 lys1 lys2 lys3 lagcurrentopen open if g7!=1, robust
	outreg using "`filename'", append `switches'
reg current lagcurrent lagcurrent1 lagcurrent2 lagcurrent3 lys1 lys2 lys3 lagcurrentopen lagcurrentka open kaopen if g7!=1, robust
	outreg using "`filename'", append `switches'


log close



