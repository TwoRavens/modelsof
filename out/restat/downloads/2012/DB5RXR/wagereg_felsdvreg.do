version 10
clear
set memory 1000m
capture log close
capture program drop _all
set more off
set matsize 800
log using ${pap4log}wagereg_felsdvreg, text replace

********************
* Individual level wage regressions
* with 2wayfixed effects and all results
* used based on these wage regressions
*************************************

* 1.
******************
* Prepare same panel as in wagereg_ind_rev09
****************
	use ${pap4data}wagereg1temp.dta, clear
	replace eduy=9 if eduy==0 | eduy==.
	gen erf=max(0,age-eduy-7)
	replace erf=15 if erf>15
	sum erf
	gen erf2=(erf)^2
	gen erf3=(erf)^3
	gen erf4=(erf)^4
	gen size2=(size)^2
	gen MNE=1 if dommne==1 | formne==1
	replace MNE=0 if MNE==.
	sum realwage, det
	gen FD=(totutenl>0)
	gen Dsex=(sex==1)
	drop sex
	rename Dsex sex
* Drop low wages and very high wages
	drop if realwage<12000
	drop if realwage>200000
	rename wagedef wage
	#delimit ;
	keep aar pid bnr FD MNE dommne formne wage naering isic3	
		size size2 kint skillshare femshare lp age
		eduy education tenure t2 sex erf erf2 erf3 erf4;
	#delimit cr
* Tenure into years
	replace tenure=tenure/12
	drop t2 
	gen t2=tenure*tenure
* Year and industry dummies
	quietly tab aar, gen(Y)
	*gen isic2=int(isic3/10)
	*quietly tab isic2, gen (I)
	drop Y1 
	*drop I1

* Define sample for wageregressions
	quietly reg wage FD size size2 kint skillshare femshare lp eduy tenure t2 sex erf erf2 erf3 erf4 , cluster(pid)
	gen s=1 if e(sample)
	keep if s==1
	drop s

* Gender interaction variables
	foreach t in eduy tenure t2 erf erf2 erf3 erf4 {
		gen D`t'=sex*`t'
	}
	drop education naering isic3 lp age sex
	compress
	save ${pap4data}wagetemp.dta, replace


* 2wayfixedeffect regression variables
#delimit ;
global regvar "size size2 kint skillshare femshare eduy tenure t2 erf erf2 erf3 erf4 Y*
	Deduy Dtenure Dt2 Derf Derf2 Derf3 Derf4";


* 2.;
* 2wayfixedeffect regression without MNE/FD dummy;

felsdvreg wage $regvar, i(pid) j(bnr) p(pers) f(firm) m(mover) 
		g(group) xb(xb) r(res) mnum(mnum) pobs(pobs) noisily;
#delimit cr

keep aar pid bnr group mover mnum pobs firm pers xb res FD MNE dommne formne
sort pid aar
save ${pap4data}wagereg_felsdvreg.dta, replace


* 3.
* 2wayfixedeffect regression with MNE dummy

use ${pap4data}wagetemp.dta, clear

#delimit ;
felsdvreg wage MNE $regvar, i(pid) j(bnr) p(pers) f(firm) m(mover) 
		g(group) xb(xb) r(res) mnum(mnum) pobs(pobs) noisily ;
#delimit cr
	keep aar pid bnr group mover mnum pobs firm pers xb res 
	foreach t in group mover mnum pobs firm pers xb res {
		rename `t' `t'_MNE
	}
	sort pid aar
	merge pid aar using ${pap4data}wagereg_felsdvreg.dta
	assert _merge==3
	drop _merge
	foreach t in group mover mnum pobs {
		assert `t'_MNE==`t'
		drop `t'_MNE
	}
	sort pid aar
	save ${pap4data}wagereg_felsdvreg.dta, replace



* 6. 
* Only individual fixed effects, 
use ${pap4data}wagetemp.dta, clear
xtreg wage FD $regvar, fe cluster(pid)
predict indfe_FD, u
keep pid aar indfe_FD
sort pid aar
	merge pid aar using ${pap4data}wagereg_felsdvreg.dta
	assert _merge==3
	drop _merge
	sort pid aar
	compress
	save ${pap4data}wagereg_felsdvreg.dta, replace


erase ${pap4data}wagetemp.dta



********** 3 june 2009 /rev 26 june*********************
* Use data on plant and individual fixed effects 
* and run regressions to see if plant/individual 
* fixed effect is higher in MNEs than in non-MNEs
* Make a table for use in the paper:unobs_tab.tex
* 
********************************************

* 1.
************************
* Plant level fixed effects
*************************

use ${pap4data}wagereg_felsdvreg.dta, replace
	keep aar bnr group firm firm_MNE MNE FD
	bys bnr aar: gen n=_n
	keep if n==1
	sort bnr aar
	keep if group==1
	sort bnr aar
	tempfile regtemp
	save regtemp.dta, replace

	use ${pap4data}wagereg1temp.dta, clear
	keep aar bnr naering dommne formne
	bys bnr aar: gen n=_n
	keep if n==1
	sort bnr aar
	merge bnr aar using regtemp.dta
	assert _merge!=2
	tab _merge
	keep if _merge==3
	erase regtemp.dta
	qui tab naering, gen(I)
	drop I1 n


*Drop plants only observed twice or less
	sort bnr aar
	bys bnr: gen n=_n
	bys bnr: gen N=_N
	tab N if n==N
	drop if N<=2

***************
* HOW to DEFINE MNEstatus???
**************
* Plant fixed effect er fixed pr plant, så
* trenger bare 1 obs pr plant; problemet er knytta til
* hvilke bnr som skal få MNE eller FD dummy like 1

* Alt 1: hvis minst 1 obs av MNE, FD=1: dvs mne=0/1 eller for=0/1
bys bnr: egen for=max(FD)
bys bnr: egen mne=max(MNE)

* Alt 2: alle obs enten FD=1 eller 0; dvs sumFD==N & FD==1 vs sumFD==0
* og tilsvarende for sumMNE
bys bnr: egen sumFD=sum(FD)
bys bnr: egen sumMNE=sum(MNE)
bys bnr: egen sumfor=sum(formne)
bys bnr: egen sumdom=sum(dommne)
bys bnr: egen maxmne=max(MNE)
bys bnr: egen maxfd=max(FD)
bys bnr: egen maxdom=max(dommne)
bys bnr: egen maxfor=max(formne)

tab MNE
tab FD
* Behold 1 obs pr bedrift
keep if n==1
tab for
tab mne
tab sumFD
tab sumMNE
tab maxfor maxdom

*************
* Regressions for plant fixed effects
************
* Alt 1: hvis minst 1 obs av MNE, FD=1: dvs bruk dummyer: mne, for, eller dmne fmne begge
gen FOR=maxfor
gen DOM=maxdom
replace FOR=0 if DOM==1
qui reg firm FOR DOM , r
est store p1
qui reg firm FOR DOM I*, r
est store tabp2
di "With 5d industry dummies"
est table p1 tabp2, keep(FOR DOM) stats(N r2) star
tab FOR DOM if e(sample)
gen
rename FOR for
rename DOM dom
gen
program define plantreg1
qui reg `1' mne, r
est store p1
qui reg `1' for, r
est store p2
est table p1 p2, keep(mne for ) stats(N r2) star
qui reg `1' mne I*, r
est store p1
qui reg `1' for I*, r
est store p2
di "With 3d industry dummies"
est table p1 p2, keep(mne for ) stats(N r2) star
end
*********

plantreg1 firm

plantreg1 firm_MNE

******
* Alt 2: alle obs av samme type: sumFD=N, sumMNE, sumdmne sumfmne
* Alt 2: alle obs enten FD=1 eller 0; dvs sumFD==N vs sumFD==0
gen aM=1 if sumMNE==N
replace aM=0 if sumMNE==0
gen aF=1 if sumFD==N
replace aF=0 if sumFD==0
drop mne for
rename aM mne
rename aF for
gen mnes=1 if mne==1 | maxmne==0
gen fds=1 if for==1 | maxfd==0

gen DOM=1 if sumdom==N
replace DOM=0 if sumdom==0
gen FOR=1 if sumfor==N
replace FOR=0 if sumfor==0
gen doms=1 if DOM==1 | maxdom==0 | maxfor==0 | FOR==1


qui reg firm DOM FOR I* if doms==1, r
est store tab_plant
est table tab_plant, keep(DOM FOR) stats(N r2) star

program define plantreg2
qui reg `1' mne if mnes==1, r
est store p12
qui reg `1' for if fds==1, r
est store p22
est table p12 p22, keep(mne for) stats(N r2) star
qui reg `1' mne I* if mnes==1, r
est store p12
qui reg `1' for I* if fds==1, r
est store p22
di "With 3d industry dummies"
est table p12 p22 , keep(mne for) stats(N r2) star
end
********

plantreg2 firm

plantreg2 firm_MNE

* 2.
*********************************
* Individual level fixed effects: 
*********************************

use ${pap4data}wagereg_felsdvreg.dta, replace
	keep aar pid bnr group pers pers_MNE MNE FD indfe_FD
	sort pid aar
	merge pid aar using ${pap4data}wagereg1temp.dta, keep(naering dommne formne)
	keep if group==1
	bys pid: gen N=_N
	drop if N<=2
	qui tab naering, gen(I)
	drop I1 


***************
* HOW to DEFINE MNEstatus???
**************
* Alt 1: hvis minst 1 obs av MNE, FD=1: dvs mne=0/1 eller for=0/1
bys pid: egen for=max(FD)
bys pid: egen mne=max(MNE)

* Alt 2: alle obs enten FD=1 eller 0; dvs sumFD==N & FD==1 vs sumFD==0
* og tilsvarende for sumMNE
bys pid: egen sumFD=sum(FD)
bys pid: egen sumMNE=sum(MNE)


tab MNE
tab FD


bys pid: egen sumfor=sum(formne)
bys pid: egen sumdom=sum(dommne)
bys pid: egen maxmne=max(MNE)
bys pid: egen maxfd=max(FD)
bys pid: egen maxdom=max(dommne)
bys pid: egen maxfor=max(formne)

* Behold 1 obs pr person
bys pid: gen n=_n
keep if n==1
tab for
tab mne
tab sumFD
tab sumMNE


****************
* Regressions : individual fixed effects
*****************


* ALT 1
plantreg1 pers
plantreg1 pers_MNE
plantreg1 indfe_FD

rename maxfor FOR
rename maxdom DOM
qui reg pers DOM FOR I*, r
est store tabind2
tab DOM FOR if e(sample)
est table tabind2, keep(DOM FOR) stats(N r2) star

******
* Alt 2: alle obs av samme type: sumFD=N, sumMNE, sumdmne sumfmne
* Alt 2: alle obs enten FD=1 eller 0; dvs sumFD==N vs sumFD==0
gen aM=1 if sumMNE==N
replace aM=0 if sumMNE==0
gen aF=1 if sumFD==N
replace aF=0 if sumFD==0
drop mne for
rename aM mne
rename aF for

gen mnes=1 if mne==1 | maxmne==0
gen fds=1 if for==1 | maxfd==0

plantreg2 pers
plantreg2 pers_MNE
plantreg2 indfe_FD


rename DOM maxdom
rename FOR maxfor
gen DOM=1 if sumdom==N
replace DOM=0 if sumdom==0
gen FOR=1 if sumfor==N
replace FOR=0 if sumfor==0
gen doms=1 if DOM==1 | maxdom==0 | maxfor==0 | FOR==1


qui reg pers DOM FOR if doms==1, r
est store p1
qui reg pers DOM FOR I* if doms==1, r
est store tab_ind
est table p1 tab_ind, keep(DOM FOR) stats(N r2) star


	estout tabp2 tab_plant tabind2 tab_ind using ${pap4tab}unobs_tab.tex, keep(DOM FOR) replace style(tex) notype /// 
	stats(N r2, fmt(%9.0g %4.2f) labels(N R$^2$)) /// 
 	cells(b(fmt(%4.3f)) se(par star fmt(%4.3f))) ///
	starlevels ($^{(\ast)}$ .01 $^{\ast\ast}$ .001) /// 	
	mlabels( , none) label nolz collabels(, none) ///
 	varlabels(DOM "Domestic MNEs" FOR "Foreign MNEs") ///
 	title("Unobserved plant and worker fixed effects") 




****************
* Make 2 figures with kernel density plots for paper
* 1 figure: for workers in nonMNEs: stayers
* versus those with MNEexp and those without. 
* workerfe_nonMNEs.eps 
* 1.Figure with worker and plant fixed effects for
* MNEs versus nonMNEs.
****************************


****************
* Density plots: individual fixed effects
* in nonMNEs, by type of experience
*****************

use ${pap4data}wagereg_felsdvreg.dta, replace
	keep aar bnr pid group firm firm_MNE MNE  pers 
* Merge in individual info of recent workexperience
	sort pid aar
	merge pid aar using ${pap4data}workerexp.dta
	tab _merge
	drop if _merge==2

*Drop workers only observed twice or less: 
* uncertain estimate of ind fixed effect
	bys pid: gen N=_N
	bys pid: gen n=_n
	drop if N<=2
	keep if group==1
* Keep only non-MNEs
	bys bnr: egen nonMNE=max(MNE)
	keep if nonMNE==0
* Keep only plants that at some time hire MNEexp workers
	bys bnr: egen nonexpw=sum(exp)
	drop if nonexpw==0
	drop nonMNE

	bys pid: egen neverMNE=sum(exp) 
	bys pid: egen nonMNEmover=sum(expnonMNE) 
	bys pid: egen mbnr=mean(bnr)
	gen x=0 if mbnr==bnr
	replace x=1 if x==.
	bys pid: egen z=sum(x)
	tab z	
	gen stay=1 if z==0 
	gen mneexp=1 if neverMNE>0
	gen rest=1 if stay!=1 & mneexp!=1
	replace stay=. if mneexp==1

keep if n==1
count if stay==1
count if mneexp==1
count if rest==1
count

* Drop the very long tail
drop if pers >10.3

* Figure
# delimit ;
kdensity pers if stay==1, lp(solid) lc(black) addplot(kdensity pers if rest==1, lp(dash) lc(black) ) 
legend( col(1) lab(1 "Stayers") lab(2 "Movers without MNE-experience")) 
title(" ") note(" ") xlabel(8.5(0.5)10)
 xtitle(" ") ytitle(" ") graphregion(fcolor(gs16)) saving(figx, replace)  ;

kdensity pers if stay==1, lp(solid) lc(black) addplot(kdensity pers if mneexp==1, lp(dash) lc(black) ) 
legend( col(1) lab(1 "Stayers") lab(2 "Movers with MNE-experience")) 
title(" ") note(" ") xlabel(8.5(0.5)10)
 xtitle(" ") ytitle(" ") graphregion(fcolor(gs16)) saving(figy, replace)  ;
# delimit cr

# delimit ;
graph combine figx.gph figy.gph , col(2) xsize(8) ysize(3) 
t1title(" ") 
graphregion(fcolor(gs16)) note(" ")
imargin(zero) iscale(1);
# delimit cr
graph export ${pap4fig}workerfe_nonMNEs.eps, replace



* 2.
*Figure for MNEs versus nonMNEs
*************************************************
* Plant fixed effects from the felsdvreg command
************************************************
****************************
* Plant level fixed effects: use only 1 obs per plant
* Define plant as MNE /nonMNE possible in many ways:
	* a) once obs as MNE=MNE, other plants are nonMNEs
	* b) always obs as MNE=MNE, never MNE=nonMNE
	* c) 50% of time obs as MNE=MNE, never MNE=nonMNE
* Another alternative is to use the full panel of plants, 
* and plot the figure for each year for MNE=0 vs MNE!=0
* Whatever I do, the results look more or less the same.
* Prefer the last option.
*****************************

use ${pap4data}wagereg_felsdvreg.dta, replace
	keep aar bnr group firm firm_MNE MNE 
	keep if group==1
	bys bnr aar: gen n=_n
	keep if n==1
	sort bnr aar

*Drop plants only observed twice or less: uncertain estimate of plant fixed effect
	bys bnr: gen N=_N
	drop if N<=2

* Drop long tails
drop if firm<-1
* 1997 
# delimit ;
kdensity firm if MNE!=0 & aar==1997, lp(solid) lc(black) 
addplot(kdensity firm if MNE==0 & aar==1997, lp(dash) lc(black) ) 
legend( col(1) lab(1 "MNEs") lab(2 "Non-MNEs")) note(" ")
 xtitle(" ") ytitle(" ") graphregion(fcolor(gs16)) title("Plant fixed effects")
saving(plant1997, replace)  ;
#delimit cr


* 3.
****************
* Density plots: individual fixed effects
*****************

use ${pap4data}wagereg_felsdvreg.dta, replace
	keep aar bnr pid group firm firm_MNE MNE  pers

*Drop workers only observed twice or less: 
* uncertain estimate of ind fixed effect
	bys pid: gen N=_N
	drop if N<=2
	keep if group==1

drop if pers>10.5
* 1997 figures for the paper?
# delimit ;
kdensity pers if MNE==1 & aar==1997, lp(solid) lc(black) 
addplot(kdensity pers if MNE==0 & aar==1997, lp(dash) lc(black) ) 
legend( col(1) lab(1 "Workers in MNEs") lab(2 "Workers in non-MNEs")) 
title("Worker fixed effects") note(" ") xlabel(8.5(0.5)10.5)
 xtitle(" ") ytitle(" ") graphregion(fcolor(gs16)) saving(worker1997, replace) nodraw ;
#delimit cr


#delimit ;
graph combine plant1997.gph worker1997.gph, col(2) graphregion(fcolor(gs16)) 
	xsize(8) ysize(3) note(" ")
	imargin(zero) iscale(1);
#delimit cr
graph export ${pap4fig}plant_worker_fe.eps, replace


log close
exit

