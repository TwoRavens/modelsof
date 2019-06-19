version 10
clear
set memory 500m
capture log close
capture program drop _all
log using ${pap4log}experience2, text replace


***19.05.2009******************************************
* Check mean differences in new workers to nonMNEs 
* with different types of experience
*******************************************************

	use ${pap4data}wagereg1temp.dta, clear
*drop if pid>50000
	quietly gen MNE=2 if dommne==1
	quietly replace MNE=1 if formne==1
	quietly replace MNE=0 if MNE==.
    	gen FD=(totutenl>0)
	replace eduy=9 if eduy==.
	replace eduy=9 if eduy==0
	gen erf=max(0,age-eduy-7)
	count if erf==.
	replace erf=15 if erf>15 & erf!=.
	rename erf erfaring
	*quietly replace education=1 if education==0 
	quietly replace education=3 if education==4
	*drop if realwage<12000 | realwage==.
	rename realwage wage
	*gen isic4=int(naering/10)
	gen isic2=int(naering/1000)
    keep aar pid bnr eduy MNE FD erfaring wage isic* education v13
    sort pid aar

* Define separations= all workers in year t and plant x
* that are not in plant x in year t+1
	gen sep=1 if pid==pid[_n+1] & bnr!=bnr[_n+1] 
	* last year in panel all workers are separated from plant x in t
	bys pid: gen N=_N
	bys pid: gen n=_n
	replace sep=1 if n==N & aar<2000 
	bys bnr aar: egen separation=sum(sep)
	drop n N
* Define plant turnoverrate=separations_t/employment_t
	bys bnr aar: gen N=_N
	bys bnr aar: gen empl=N
	drop N
	gen turnover=separation/empl
	drop separation empl sep
	sum turnover, det
	assert turnover==0 if aar==2000

* Count # of ind per plant and by educationtype
	bys bnr aar: gen n=_n
	bys bnr aar: gen N=_N

	sort pid aar

* Generate accumulated recent experience from allMNE, dom and for MNE
    gen erf=1 if MNE!=0
    gen erfdom=1 if MNE==2
    gen erffor=1 if MNE==1
	gen erfs=1 if v13>100
    sort pid aar 
    foreach z in erf erfdom erffor erfs {
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
	rename experfs expstor
    drop erf erfdom erffor erfs
	foreach t in exp expfor expdom expstor {
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
* For those with exp from large plants, count this only if they are new to the plant
* and without MNEexp
	replace expstor=0 if new==0 
	replace expstor=0 if exp==1

	sum exp*

	bys bnr: egen maxutl=max(MNE)
	keep if maxutl==0

	sum exp*

sum eduy if expnonMNE==1, det
sum erfaring if expnonMNE==1, det

sum eduy if exp==1, det
sum erfaring if exp==1, det

sum eduy if new==1, det
sum erfaring if new==1, det

sum eduy if expfor==1, det
sum erfaring if expfor==1, det

sum eduy if expdom==1, det
sum erfaring if expdom==1, det

sum eduy if new==0, det
sum erfaring if new==0, det

log close
exit