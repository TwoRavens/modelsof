version 10
clear
set memory 500m
capture log close
capture program drop _all
log using ${pap4log}experience, text replace
set more off

***13.05.2009******************************************
* Count the number of
* matched workers per plant of various groups:
* by education, experience, MNE/nonMNEexperience, new
* Count the total years of education, experience and 
* wages of each of these groups. 
* These variables are saved in new_workers.dta.
* To be used to construct various plant level shares
* used in plant level productivity regressions.
*******************************************************

	use ${pap4data}wagereg1temp.dta, clear
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
	label var N " # of full time workers in the plant"
	foreach t in 0 1 2 3  {
		bys bnr aar: egen ed`t'=count(pid) if education==`t'
		bys bnr aar: egen N`t'=mean(ed`t')
		drop ed`t'
		label var N`t' "# of full time workers in the plant with education=`t'"
		replace N`t'=0 if N`t'==.
	}
	egen x=rsum(N0 N1 N2 N3)
	assert x==N
	drop x
* Count # of ind per plant by educationyears
	gen ed9=1 if eduy<=9
	gen ed10=1 if eduy==10
	gen ed11=1 if eduy==11
	gen ed12=1 if eduy==12
	gen ed15=1 if eduy==13 | eduy==14 | eduy==15
	gen ed16=1 if eduy>15

	foreach t in 9 10 11 12 15 16 {
		bys bnr aar: egen ted`t'=count(pid) if ed`t'==1
		bys bnr aar: egen N`t'=mean(ted`t')
		drop ted`t'
		label var N`t' "# of full time workers in the plant with years of educ=`t'"
		replace N`t'=0 if N`t'==.
	}
	egen x=rsum(N9 N10 N11 N12 N15 N16)
	assert x==N
	drop x

	sort pid aar
	tempfile worktemp
	save worktemp.dta, replace
	keep if n==1
	keep aar bnr turnover N N* 
	compress
	sort bnr aar
	save ${pap4data}new_workers.dta, replace

use worktemp.dta, clear
drop turnover N N*

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


* Number of new workers with experience from MNEs t-4-t-5
    gen erf=1 if MNE!=0
	drop e*1990
    foreach z in erf {
    forvalues t=1990/2000 {
        quietly bys pid: egen x`t'=sum(`z') if aar<=`t'-3 & aar>`t'-6
        quietly bys pid: egen `z'`t'=mean(x`t') 
        quietly drop x`t'
    }
    quietly gen exp`z'=`z'1990 if aar==1990
    forvalues t=1991/2000 {
        quietly replace exp`z'=`z'`t' if aar==`t'
        drop `z'`t'
    } 
    }
	rename experf  exp4
	replace exp4=1 if exp4>1 & exp4!=.
	replace exp4=0 if exp4==.
	replace exp4=0 if exp==1
	label var exp4 "=1 if MNE exp in t-4 and t-5 and not after"
	gen exp4n=exp4
	replace exp4n=0 if new==0
	label var exp4n "=1 if new and MNE exp in t-4 and t-5 and not after"


* Count number of new workers with each type of experience
	foreach t in exp expfor expdom expnonMNE expstor new exp4 exp4n {
	bys bnr aar: egen N_`t'=sum(`t')
	}
	label var N_new "# of new workers in plant" 
	foreach t in exp expfor expdom expnonMNE expstor {
	label var N_`t' "# of new workers in plant with recent exp from `t'" 
	}
	label var N_exp4 "# workers with MNEexp t-4 t-5 and not after"
	label var N_exp4n "# new workers with MNEexp t-4 t-5 and not after"

	egen x=rsum(N_exp N_expnonMNE)
	assert x==N_new
	egen y=rsum(N_exp N_expstor)
	assert y<=N_new
	drop x y
	
	save worktemp.dta, replace
	keep aar bnr pid expnonMNE exp exp4n
	sort pid aar
	save ${pap4data}workerexp.dta, replace


	use worktemp.dta, clear
	keep if n==1
	keep aar bnr N*
	sort bnr aar
	merge bnr aar using ${pap4data}new_workers.dta
	assert _merge==3
	drop _merge
	compress
	sort bnr aar
	save ${pap4data}new_workers.dta, replace
	
* Count number of new workers with each type of experience by education type/year
	use worktemp.dta, clear
	drop N*
	foreach t in  0 1 2 3  {
		foreach z in exp expnonMNE  {
		bys bnr aar: egen ed`t'`z'=count(pid) if education==`t' & `z'==1
		bys bnr aar: egen N`t'_`z'=mean(ed`t'`z')
		drop ed`t'`z'
		label var N`t'_`z' "# of new ftw in plant with educ=`t' & exp=`z'"
		replace N`t'_`z'=0 if N`t'_`z'==.
	}
	}

	foreach t in  9 10 11 12 15 16 {
		foreach z in exp expnonMNE {
		bys bnr aar: egen ed`t'`z'=count(pid) if ed`t'==1 & `z'==1
		bys bnr aar: egen N`t'_`z'=mean(ed`t'`z')
		drop ed`t'`z'
		label var N`t'_`z' "# of new ftw in plant with eduy=`t' & exp=`z'"
		replace N`t'_`z'=0 if N`t'_`z'==.
	}
	}

	keep if n==1
	keep aar bnr N*
	sort bnr aar
	merge bnr aar using ${pap4data}new_workers.dta
	assert _merge==3
	drop _merge
	compress
	sort bnr aar
	save ${pap4data}new_workers.dta, replace


* Count number of new workers with MNEexperience from the same 3 digit sector
* Do this by generating indicator for being new from the same 3 digit sector
	use worktemp.dta, clear
	drop N*
	tsset pid aar
	gen new3=1 if bnr!=bnr[_n-1] & bnr[_n-1]!=. & pid==pid[_n-1] & isic3==isic3[_n-1]
	replace new3=1 if bnr!=bnr[_n-2] & bnr[_n-2]!=. & pid==pid[_n-2] & isic3==isic3[_n-2]

	replace new3=1 if bnr!=bnr[_n-3] & bnr[_n-3]!=. & pid==pid[_n-3] & isic3==isic3[_n-3]

	replace new3=0 if new3==.
	tab new new3
	label var new3 "=1 if new ftw that comes from same 3ds"
* For those with MNEexp, count this only if they are new to the plant from same 3ds
	gen exp3=exp
	replace exp3=0 if new3==0
	label var exp3 "=1 if new ftw with MNE exp from same 3ds"
	bys bnr aar: egen N_exp3=sum(exp3)
	label var N_exp3 "# of new ftw with recent MNEexp from same 3ds" 
	gen exp_not3=exp
	replace exp_not3=0 if exp3==1
	bys bnr aar: egen N_exp_not3=sum(exp_not3)
	label var N_exp_not3 "# of new ftw with recent MNEexp outside same 3ds" 
	sum N*


	keep if n==1
	keep aar bnr N*
	sort bnr aar
	merge bnr aar using ${pap4data}new_workers.dta
	assert _merge==3
	drop _merge
	compress
	sort bnr aar
	save ${pap4data}new_workers.dta, replace


* Total experience, education and wages for all groups of workers defined above
	use worktemp.dta, clear
	drop N*
	drop erf
	rename erfaring erf
	foreach t in wage erf eduy {
		bys bnr aar: egen tot_`t'=sum(`t')
		label var tot_`t' "Total `t' in plant"
		foreach z in exp expnonMNE expfor expdom {
			bys bnr aar: egen `z'tot_`t'=sum(`t') if `z'==1
			bys bnr aar: egen tot_`t'_`z'=mean(`z'tot_`t') 
			drop `z'tot_`t'
			label var tot_`t'_`z' "Total `t' for new ftw with exp=`z'"
			replace tot_`t'_`z'=0 if tot_`t'_`z'==.
		}
	}


* Keep one observation per plant and year: 
	keep if n==1
	keep aar bnr tot*
	sort bnr aar
	merge bnr aar using ${pap4data}new_workers.dta
	assert _merge==3
	drop _merge
	compress
	sort bnr aar
	save ${pap4data}new_workers.dta, replace

*
* Count # of ind per plant by education/experience groups
	use worktemp.dta, clear
	drop ed9 ed1*
	gen ed10=1 if eduy<=10
	gen ed14=1 if eduy>10 & eduy<15
	gen ed15=1 if eduy>=15
	save worktemp.dta, replace
	foreach t in 10 14 15 {
		bys bnr aar: egen ted`t'=count(pid) if ed`t'==1 & erfaring<5
		bys bnr aar: egen N`t'_er5=mean(ted`t')
		drop ted`t'
		label var N`t'_er5 "# of ftw in plant with years of educ=`t' & erf<5"
		replace N`t'_er5=0 if N`t'_er5==.
		foreach z in exp expnonMNE {
		bys bnr aar: egen ed`t'`z'=count(pid) if ed`t'==1 & `z'==1 & erfaring<5
		bys bnr aar: egen N`t'_er5_`z'=mean(ed`t'`z')
		drop ed`t'`z'
		label var N`t'_er5_`z' "# of new ftw in plant with eduy=`t' & exp=`z' & erf<5"
		replace N`t'_er5_`z'=0 if N`t'_er5_`z'==.
	}
	}
* Keep one observation per plant and year: 
	keep if n==1
	keep aar bnr N*
	sort bnr aar
	merge bnr aar using ${pap4data}new_workers.dta
	assert _merge==3
	drop _merge
	compress
	sort bnr aar
	save ${pap4data}new_workers.dta, replace

	use worktemp.dta, clear

	foreach t in 10 14 15 {
		bys bnr aar: egen ted`t'=count(pid) if ed`t'==1 & erfaring>=5 & erfaring<10
		bys bnr aar: egen N`t'_er10=mean(ted`t')
		drop ted`t'
		label var N`t'_er10 "# of ftw in plant with years of educ=`t' & erf<10"
		replace N`t'_er10=0 if N`t'_er10==.
		foreach z in exp expnonMNE {
		bys bnr aar: egen ed`t'`z'=count(pid) if ed`t'==1 & `z'==1 & erfaring>=5 & erfaring<10
		bys bnr aar: egen N`t'_er10_`z'=mean(ed`t'`z')
		drop ed`t'`z'
		label var N`t'_er10_`z' "# of new ftw in plant with eduy=`t' & exp=`z' & erf<10"
		replace N`t'_er10_`z'=0 if N`t'_er10_`z'==.
	}
	}
* Keep one observation per plant and year: 
	keep if n==1
	keep aar bnr N*
	sort bnr aar
	merge bnr aar using ${pap4data}new_workers.dta
	assert _merge==3
	drop _merge
	compress
	sort bnr aar
	save ${pap4data}new_workers.dta, replace

	use worktemp.dta, clear

	foreach t in 10 14 15 {
		bys bnr aar: egen ted`t'=count(pid) if ed`t'==1 & erfaring>=10
		bys bnr aar: egen N`t'_er15=mean(ted`t')
		drop ted`t'
		label var N`t'_er15 "# of ftw in plant with years of educ=`t' & erf>=10"
		replace N`t'_er15=0 if N`t'_er15==.
		foreach z in exp expnonMNE {
		bys bnr aar: egen ed`t'`z'=count(pid) if ed`t'==1 & `z'==1 & erfaring>=10
		bys bnr aar: egen N`t'_er15_`z'=mean(ed`t'`z')
		drop ed`t'`z'
		label var N`t'_er15_`z' "# of new ftw in plant with eduy=`t' & exp=`z' & erf>=10"
		replace N`t'_er15_`z'=0 if N`t'_er15_`z'==.
	}
	}
	
	
* Keep one observation per plant and year: 
	keep if n==1
	keep aar bnr N*
	sort bnr aar
	merge bnr aar using ${pap4data}new_workers.dta
	assert _merge==3
	drop _merge
	compress
	sort bnr aar
	save ${pap4data}new_workers.dta, replace

erase worktemp.dta

	use ${pap4data}wagereg1temp.dta, clear
	keep aar bnr pid
	bys bnr aar: gen N=_N
	tempfile temp0
	sort pid aar
	save temp0.dta, replace

	use ${pap4data}twowayfixed.dta, clear
	keep aar bnr pid person*
	bys bnr aar: gen N2=_N
	bys bnr aar: egen pf1=mean(person1)
	bys bnr aar: egen pf2=mean(person3)
	bys bnr aar: egen pf3=mean(person3)
	sort pid aar
	merge pid aar using temp0.dta
	assert _merge!=1
	tab _merge
	tab aar _merge
	codebook bnr if _merge==3
	codebook bnr 
	codebook pid if _merge==3
	codebook pid
	bys pid: gen pidN=_N
	tab _merge pidN
	sum N N2
	count if N==N2
	count if N<N2

	bys bnr: egen mm=max(_merge)
	bys bnr: gen bnrN=_N
	bys bnr: gen n=_n
	tab mm if n==bnrN
	drop n
	bys aar bnr: gen n=_n
	keep if n==1
	keep aar bnr pf* mm
	label var mm "=2 if plant not used in 2wayfixed reg"
	label var pf1 "mean individual fixed effect in plant"

* Have to assume that the average individual fixed effect per plant based on the workers 
* used in the a2reg command is representative for the whole workforce of the plant.
	sort bnr aar
	merge bnr aar using ${pap4data}new_workers.dta
	assert _merge==3
	drop _merge

	sort bnr aar
	compress
	save ${pap4data}new_workers.dta, replace
	tab aar
	des
	sum

erase temp0.dta
log close
exit

