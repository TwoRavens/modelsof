version 10
clear
set memory 500m
capture log close
capture program drop _all
log using ${pap4log}experience_annual, text replace
set more off

***23.06.2009******************************************
* Here count the number of new workers with MNEexp 
* and non-MNEexp each year. 
* And count the number of new workers with MNE and non MNEexp
* each year by tenure in last job.
* These variables are saved in
* new_workers_annual.dta 
* To be used to construct various plant level shares
* used in plant level productivity regressions.
*******************************************************

	use ${pap4data}wagereg1temp.dta, clear
	quietly gen MNE=2 if dommne==1
	quietly replace MNE=1 if formne==1
	quietly replace MNE=0 if MNE==.
	rename realwage wage
	replace eduy=9 if eduy==0 | eduy==.
	gen erf=max(0,age-eduy-7)
	replace erf=15 if erf>15

    keep aar pid bnr MNE tenure eduy erf wage
    sort pid aar
	bys bnr: egen maxutl=max(MNE)

	sort pid aar
	tempfile worktemp
	save worktemp.dta, replace

use worktemp.dta, clear


* New: Indicator for being a new worker in the plant, new defined as
* being new in t,  split by being in an MNE or nonMNE last year
	tsset pid aar
	gen new_mne=1 if bnr!=bnr[_n-1] & bnr[_n-1]!=. & pid==pid[_n-1] & MNE[_n-1]!=0
	replace new_mne=0 if new_mne==.
	tab new_mne
	label var new_mne "=1 if worker is new to plant and was in MNE last y"
	gen new_non=1 if bnr!=bnr[_n-1] & bnr[_n-1]!=. & pid==pid[_n-1] & MNE[_n-1]==0
	replace new_non=0 if new_non==.
	tab new_non
	label var new_non "=1 if worker is new to plant and was in nonMNE last y"

	gen new_dom=1 if bnr!=bnr[_n-1] & bnr[_n-1]!=. & pid==pid[_n-1] & MNE[_n-1]==2
	replace new_dom=0 if new_dom==.
	label var new_dom "=1 if worker is new to plant and was in domMNE last y"
	
	gen new_for=1 if bnr!=bnr[_n-1] & bnr[_n-1]!=. & pid==pid[_n-1] & MNE[_n-1]==1
	replace new_for=0 if new_for==.
	label var new_for "=1 if worker is new to plant and was in forMNE last y"

gen lten=L.tenure
sum lten if new_mne==1 & maxutl==0, det
sum lten if new_non==1 & maxutl==0, det


* Repeat above, by tenure classes in last job
	gen new_mnelow=1 if bnr!=bnr[_n-1] & bnr[_n-1]!=. & pid==pid[_n-1] & MNE[_n-1]!=0 & tenure[_n-1]<=25
	replace new_mnelow=0 if new_mnelow==.
	gen new_mnehigh=1 if bnr!=bnr[_n-1] & bnr[_n-1]!=. & pid==pid[_n-1] & MNE[_n-1]!=0 & tenure[_n-1]>25
	replace new_mnehigh=0 if new_mnehigh==.
	label var new_mnelow "=1 if new and was in MNE last y with tenure <25 months"
	label var new_mnehigh "=1 if new and was in MNE last y with tenure >25 months"
	assert new_mne==1 if new_mnelow==1 | new_mnehigh==1


	gen new_nonlow=1 if bnr!=bnr[_n-1] & bnr[_n-1]!=. & pid==pid[_n-1] & MNE[_n-1]==0 & tenure[_n-1]<=25
	replace new_nonlow=0 if new_nonlow==.
	gen new_nonhigh=1 if bnr!=bnr[_n-1] & bnr[_n-1]!=. & pid==pid[_n-1] & MNE[_n-1]==0 & tenure[_n-1]>25
	replace new_nonhigh=0 if new_nonhigh==.
	label var new_nonlow "=1 if new and was in nonMNE last y with tenure <25 months"
	label var new_nonhigh "=1 if new and was in nonMNE last y with tenure >25 months"
	assert new_non==1 if new_nonlow==1 | new_nonhigh==1

	foreach t in new_mne new_mnelow new_mnehigh new_non new_nonlow new_nonhigh new_for new_dom {
	bys bnr aar: egen N_`t'=sum(`t')
	label var N_`t' " # of new workers of type `t' in year t"
	}


* Count years of education/exp/wage by group
	foreach t in for dom non mne {
		bys bnr aar: egen x`t'=sum(eduy) if new_`t'==1
		bys bnr aar: egen tot_ed_`t'_a=min(x`t')
		drop x`t'
	}
	foreach t in for dom non mne {
		bys bnr aar: egen x`t'=sum(erf) if new_`t'==1
		bys bnr aar: egen tot_erf_`t'_a=min(x`t')
		drop x`t'
	}
	foreach t in for dom non mne {
		bys bnr aar: egen x`t'=sum(wage) if new_`t'==1
		bys bnr aar: egen tot_w_`t'_a=min(x`t')
		drop x`t'
	}

	bys bnr aar: gen n=_n
	keep if n==1
	keep aar bnr N* tot*
	assert N_new_mne==N_new_mnelow+N_new_mnehigh
	assert N_new_non==N_new_nonlow+N_new_nonhigh
	tsset bnr aar
	#delimit ;
	foreach t in N_new_mne N_new_non N_new_mnelow N_new_mnehigh N_new_nonlow N_new_nonhigh {;
		gen `t'2=`t'+L.`t';
	};
	#delimit cr

	sort bnr aar
	compress
	save ${pap4data}new_workers_annual.dta, replace

erase worktemp.dta
log close
exit

