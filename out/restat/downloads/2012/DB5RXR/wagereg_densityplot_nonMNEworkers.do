version 10
clear
set memory 400m
capture log close
capture program drop _all
set more off

***27.06.2009 *************
* Make one figure: for workers in nonMNEs: stayers
* versus those with MNEexp and those without. 
* workerfe_nonMNEs.eps 
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




exit
