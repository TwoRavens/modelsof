tempfile germans1910

*-------------------------------------------------------------------------------
* Load 1910 ICPSR county-level data
* Create share of Germans at state level
*-------------------------------------------------------------------------------

gen totalgermans=nwfpgerm + pbwgerm
keep if level==2
gen bpl=fips/1000
gen germans1910=totalgermans/totpop
keep germans1910 bpl
save `germans1910'

********************************************************************************
* Compute FNI by state of birth for those born before 1914
tempfile prewarFNI
use FNIdataset if german==1, clear

keep if birthyear<1914
collapse FNI, by(statefip)
ren statefip bpl
ren FNI prewarFNI
save `prewarFNI'

********************************************************************************

use FNIdataset if german==1, clear

* Only keep states for which we have voting data
drop if bpl>56

* merge with FNI of Germans born before 1914 at the state of birth
merge m:1 bpl using `prewarFNI'
drop _merge

* merge with voting data
tempfile mainfile
save `mainfile'
collapse pernum, by(stateicp statefip)
drop pernum
merge 1:1 stateicp using wilson
drop _merge
ren statefip bpl
drop if bpl==.
merge 1:m bpl using `mainfile'
drop _merge

* merge with Germans in state in 1910
merge m:1 bpl using `germans1910'
keep if _merge==3
drop _merge


gen postwar=(birthyear>=1917) 
gen inter=postwar*wilson
tab bpl, gen(st_)
tab birthyear, gen(coh_)

* linear trend
sum birthyear
local minyear=r(min)
local maxyear=r(max)-r(min)
gen t=birthyear-`minyear'+1

* compute cohort-specific interactions of pre-war FNI among Germans and German share in state
forval x=1/51 {
	gen intergerman1910_`x'=germans1910*coh_`x'
	gen FNIcoh_`x'=prewarFNI*coh_`x'
}

* deviation of index from state-specific pre-war trend
reg FNI i.bpl#c.t if birthyear<1914
predict res, res

estimates clear
reg FNI i.birthyear wilson inter, cl(bpl)
eststo m1
reg FNI i.birthyear wilson intergerman1910_* inter, cl(bpl)
eststo m2
reg FNI i.birthyear i.bpl intergerman1910_* inter, cl(bpl)
eststo m3
reg FNI i.birthyear i.bpl FNIcoh_* intergerman1910_* inter, cl(bpl)
eststo m4
reg res i.birthyear i.bpl FNIcoh_* intergerman1910_* inter, cl(bpl)
eststo m5

esttab m* using "Table6PanelA.csv", star(* 0.1 ** 0.05 *** 0.01) replace cells(b(fmt(a3) star) se(par)) stats(N r2) keep(inter wilson) 
