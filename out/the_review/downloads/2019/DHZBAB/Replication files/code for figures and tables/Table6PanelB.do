* collapse anti-German incidents by state
use hatecrimes, clear
collapse (count) id, by(statefip)
ren id hatecrimes
ren statefip bpl
tempfile hatecrimes
save `hatecrimes'


*-------------------------------------------------------------------------------
* Load 1910 ICSPR county-level census data
* Create share of Germans at state level
*-------------------------------------------------------------------------------

tempfile germans1910
gen totalgermans=pbwgerm + nwfpgerm
keep if level==2
gen bpl=fips/1000
gen germans1910=totalgermans/totpop   
keep bpl germans1910
save `germans1910', replace

*-------------------------------------------------------------------------------
* Load 1920 ICSPR county-level census data
* Get state-level population (to normalize incidents)
*-------------------------------------------------------------------------------

tempfile totpop1920
keep if level==2
gen bpl=fips/1000
keep totpop bpl
rename totpop totpop1920
save `totpop1920'

********************************************************************************
* FNI by state of birth for those born before 1914
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

// merge with anti-German harassment incidents on the state of birth
merge m:1 bpl using `hatecrimes'
replace hatecrimes=0 if _merge==1
drop _merge

// merge with German share on the state of birth
merge m:1 bpl using `germans1910', nogen

// merge with pre-war FNI of Germans and total population in 1920
merge m:1 bpl using `prewarFNI', nogen

merge m:1 bpl using `totpop1920', nogen

// Incidents per capita
gen hatepcpop=(hatecrimes/totpop1920)*1000


gen postwar=(birthyear>=1917)
gen inter=postwar*hatepcpop
tab bpl, gen(st_)
tab birthyear, gen(coh_)

* compute cohort-specific interactions of pre-war FNI among Germans and German share in state
forval x=1/51 {
	gen FNIst_`x'=prewarFNI*coh_`x'
	gen intercontrol_`x'=germans1910*coh_`x'
}

* deviation of index from state-specific pre-war trend
reg FNI i.bpl#c.t if birthyear<1914
predict res, res

estimates clear
reg FNI i.birthyear hatepcpop  inter, cl(bpl)
eststo m1
reg FNI i.birthyear hatepcpop intercontrol_*  inter, cl(bpl)
eststo m2
reg FNI i.birthyear i.bpl intercontrol_*  inter, cl(bpl)
eststo m3
reg FNI i.birthyear i.bpl FNIst_* intercontrol_*  inter, cl(bpl)
eststo m4
reg res i.birthyear i.bpl FNIst_* intercontrol_*  inter, cl(bpl)
eststo m5
esttab m* using "Table6PanelB.csv", star(* 0.1 ** 0.05 *** 0.01) replace cells(b(fmt(a3) star) se(par)) stats(N r2) keep(inter hatepcpop) 
