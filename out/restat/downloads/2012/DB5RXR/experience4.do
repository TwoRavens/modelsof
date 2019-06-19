version 10
clear
set memory 500m
capture log close
capture program drop _all
log using ${pap4log}experience4, text replace

***03.06.2009/ rev 26.06***************************************
* Simialr to experiecne3.do. Generate plant level measures 
* of the average individual fixed effect of new workers with
* and without MNEexp with data made in wagereg_felsdvreg.do
* use fixed effects: indfe_FD from xtreg and 
* pers from felsdvreg
* Must run after experience3.do
*******************************************************

	use ${pap4data}wagereg1temp.dta, clear

	quietly gen MNE=2 if dommne==1
	quietly replace MNE=1 if formne==1
	quietly replace MNE=0 if MNE==.
    keep aar pid bnr MNE 
    sort pid aar


* Generate accumulated recent experience from allMNE, 
    gen erf=1 if MNE!=0
    gen erfdom=1 if MNE==2
    gen erffor=1 if MNE==1
    sort pid aar 
	foreach z in erf erfdom erffor {
    		forvalues t=1990/2000 {
       		 quietly bys pid: egen x`t'=sum(`z') if aar<=`t' & aar>`t'-4
       		 quietly bys pid: egen `z'`t'=mean(x`t') 
        		quietly drop x`t'
    		}
   		 quietly gen exp`z'=`z'1990 if aar==1990
    		forvalues t=1991/2000 {
        		quietly replace exp`z'=`z'`t' if aar==`t'
       		 drop `z'`t'
   		} 
    }

	rename experf exp
    rename experfdom expdom
    rename experffor expfor
    drop erf erfdom erffor 
	foreach t in exp expfor expdom {
		replace `t'=1 if `t'>0
		assert `t'!=.
		label var `t' "=1 if new ftw with exp=`t'"
	}


* New: Indicator for being a new worker in the plant, new defined as
* being new in t, t-1 or t-2, (those with MNE exp from t-1,2,3) are by def
* new in non-MNEs either in t, t-1 or t-2
	tsset pid aar
	gen new=1 if bnr!=bnr[_n-1] & bnr[_n-1]!=. & pid==pid[_n-1]
	replace new=1 if bnr!=bnr[_n-2] & bnr[_n-2]!=. & pid==pid[_n-2]
	replace new=1 if bnr!=bnr[_n-3] & bnr[_n-3]!=. & pid==pid[_n-3]
	replace new=0 if new==.
	tab new
	label var new "=1 if worker is new to plant in t, t-1 or t-2"
* If new and no MNE experience, generate indicator for nonMNEexp
	gen expnonMNE=1 if new==1 & exp==0
	replace expnonMNE=0 if expnonMNE==.
	label var expnonMNE "=1 if new ftw with exp from nonMNE"

* For those with MNEexp, count this only if they are new to the plant
	foreach t in exp expfor expdom {
		replace `t'=0 if new==0
	}
	sum exp*

	gen old=1 if exp!=1 & expnonMNE!=1

	bys bnr aar: gen n=_n
	bys bnr aar: gen N=_N
	bys bnr aar: egen Nexp=sum(exp)
	bys bnr aar: egen Nnon=sum(expnonMNE)
	bys bnr aar: egen Nold=sum(old)
	egen x=rsum(Nexp Nnon Nold)
	assert x==N
	bys bnr aar: egen Nfor=sum(expfor)
	bys bnr aar: egen Ndom=sum(expdom)

	drop x

* Find mean individual fixed effect for individuals that are new
* to the plant (with and without MNEexp) from the felsdvreg-command
	sort pid aar
	merge pid aar using ${pap4data}wagereg_felsdvreg.dta, keep( group pers indfe_FD)
	tab _merge
	rename indfe_FD indfe
	keep if group==1
	drop group _merge
	sum indfe pers
	replace indfe=indfe+1
	tempfile temp1
	save temp1.dta, replace

* Find average of individual fixed effects pr plant/year
* before cleaning out on the share of individuals with fixed effects
* compared to those without
	use temp1.dta, clear
	foreach t in pers indfe {
		bys bnr aar: egen x`t'=mean(`t') if old==1	
		bys bnr aar: egen y`t'=mean(`t') if exp==1	
		bys bnr aar: egen z`t'=mean(`t') if expnonMNE==1
		bys bnr aar: egen w`t'=mean(`t') if expfor==1
		bys bnr aar: egen q`t'=mean(`t') if expdom==1
		bys bnr aar: egen old`t'=min(x`t') 
		bys bnr aar: egen mne`t'=min(y`t') 	
		bys bnr aar: egen non`t'=min(z`t') 
		bys bnr aar: egen for`t'=min(w`t') 
		bys bnr aar: egen dom`t'=min(q`t') 
		drop x`t' y`t' z`t' w`t' q`t'
	}
	bys bnr aar: egen mpers=mean(pers)
	bys bnr aar: egen mindfe=mean(indfe)
	gen feutv1=1
	assert pers!=.
	assert indfe!=.

* Number of matched workers with fixed effect per plant
	bys bnr aar: gen feN=_N
	assert feN<=N
	count if feN<0.7*N
	count if feN<0.8*N
	count if feN<0.6*N
	count if feN<0.5*N
	count if feN<0.9*N
	sort pid aar
	save temp1.dta, replace

* Drop plant/year obs if no fixed effects for new workers
	bys bnr aar: egen feNexp=sum(exp)
	bys bnr aar: egen feNnon=sum(expnonMNE)
	bys bnr aar: egen feNold=sum(old)
	count if feNexp==0 & Nexp>0
	drop if feNexp==0 & Nexp>0
	count if feNnon==0 & Nnon>0
	drop if feNnon==0 & Nnon>0
	count if feNold==0 & Nold>0
	drop if feNold==0 & Nold>0
	count if feN<0.7*N
	count if feN<0.8*N
	count if feN<0.6*N
	count if feN<0.5*N
	count if feN<0.9*N

* Keep only plants where the number of individulas with
* an estimated fixed effect is more than x% of matched individuals
* ie feN>x%*N, and then assume that average fixed effect
* for the plant, for each of the group of new workers with/out MNEexp
* is representative for these groups in the plant.
	drop if feN<0.8*N
	drop  erf1990 new
	foreach t in pers indfe{
		bys bnr aar: egen x`t'=mean(`t') if old==1	
		bys bnr aar: egen y`t'=mean(`t') if exp==1	
		bys bnr aar: egen z`t'=mean(`t') if expnonMNE==1
		bys bnr aar: egen w`t'=mean(`t') if expfor==1
		bys bnr aar: egen q`t'=mean(`t') if expdom==1
		bys bnr aar: egen cold`t'=min(x`t') 
		bys bnr aar: egen cmne`t'=min(y`t') 	
		bys bnr aar: egen cnon`t'=min(z`t') 
		bys bnr aar: egen cfor`t'=min(w`t') 
		bys bnr aar: egen cdom`t'=min(q`t') 
		drop x`t' y`t' z`t' w`t' q`t'
	}
	sort pid aar 
	bys bnr aar: egen mcpers=mean(pers)
	bys bnr aar: egen mcindfe=mean(indfe)
	keep pid aar cold* cmne* cnon* mc* cfor* cdom*
	gen feutv2=1
	sort pid aar
	merge pid aar using temp1.dta

* Keep one observation per plant
	keep if n==1
	sort bnr aar
	sum
	foreach t in oldpers oldindfe mnepers mneindfe forpers forindfe dompers domindfe nonpers nonindfe mpers mindfe mcpers mcindfe {
		replace `t'=0 if `t'==.
	}
	foreach t in coldpers coldindfe cmnepers cmneindfe cforpers cforindfe cdompers cdomindfe cnonpers cnonindfe {
		replace `t'=0 if `t'==.
	}

	keep aar bnr old* non* mne* for* dom* *old* *mne* *for* *dom* *non* *pers *indfe mc* feutv*
	drop  indfe pers Nold Nnon old expnonMNE


	compress
	sort bnr aar
	save ${pap4data}new_workers_meanfe.dta, replace
	erase temp1.dta
log close
exit
