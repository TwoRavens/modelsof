*lukas jobb
clear
set memory 1400m
set matsize 6000
capture log close
log using ${pap4log}movers_rev09_table, text replace
set more off
capture program drop _all

***02.07.2009 ***RBal****************************
* Based on movers_rev09, select results to put in
* tables for the last section of the paper.
*************************************************

* 1.
* Prepare data for movers from and stayers in MNEs
	use ${pap4data}wagereg1temp.dta

*keep if pid<55000
* Tenure into years
	replace tenure=tenure/12
	replace t2=tenure^2
* MNE indicator: just MNE vs nonMNE
	gen MNE=1 if dommne==1 | formne==1
	replace MNE=0 if MNE==.
	replace eduy=9 if eduy==0 | eduy==.
	gen erf=max(0,age-eduy-7)
	replace erf=15 if erf>15
	sum erf
	gen erf2=(erf)^2
	gen erf3=(erf)^3
	gen erf4=(erf)^4
	gen size2=(size)^2
	gen Dsex=(sex==1)
	drop sex
	rename Dsex sex
* Drop low wages and very high wages
	drop if realwage<12000
	drop if realwage>200000
	rename wagedef wage
	#delimit ;
	keep aar pid bnr MNE wage isic3	
		size size2 kint skillshare femshare
		eduy tenure t2 sex erf erf2 erf3 erf4;
	#delimit cr
* Gender interaction variables
	foreach t in eduy tenure t2 erf erf2 erf3 erf4 {
		gen D`t'=sex*`t'
	}

* Drop individuals observed only once
	quietly bys pid: gen n=_n
	quietly bys pid: gen N=_N
	drop if N==1

* Define sample for wageregressions
	quietly reg wage  size kint skillshare femshare eduy tenure  sex erf erf2 , cluster(pid)
	keep if e(sample)

* Save data
	compress
	tempfile temp1
	save temp1.dta, replace
	*keep if pid<50000 


* Define stayers in always MNEs, always nonMNEs and other plants (acqplants)
	use temp1.dta, clear
	bys bnr: egen maxutl=max(MNE)
	bys bnr: egen minutl=min(MNE)
	bys pid: egen mbnr=mean(bnr)
	gen x=0 if mbnr==bnr
	replace x=1 if x==.
	bys pid: egen z=sum(x)
	tab z	
	gen stay=1 if z==0 & maxutl==0
	replace stay=2 if z==0 & minutl==1
	replace stay=3 if z==0 & stay==.
	label var stay "1:stay in nonMNE,2: stay in MNE, 3: stay in acqplant"
	gen stay5=stay if N>=5
	label var stay5 "=stay but for workers observed 5 y or more"
	replace stay=0 if stay==.
	replace stay5=0 if stay==0
	drop mbnr x z
	tab stay stay5


* Define movers and drop those with 3 or more moves
	sort pid aar
	gen move=1 if bnr!=bnr[_n-1] & pid==pid[_n-1]
	label var move "=1 if worker has changed plant since last year observed"
	replace move=0 if move==.
	bys pid: egen n_move=sum(move)
	tab n_move if n==N
	drop if n_move>=3
	assert n_move>0 if stay==0
	assert n_move==0 if stay>0

* Define movers by direction of move, the year after move
	*=moveyear
	tsset pid aar
	gen m_nn=1 if move==1 & MNE==0 & L.MNE==0
	gen m_nm=1 if move==1 & MNE==1 & L.MNE==0
	gen m_mn=1 if move==1 & MNE==0 & L.MNE==1
	gen m_mm=1 if move==1 & MNE==1 & L.MNE==1 

* Define movers the year before move, by dir of move
	gen m_nn_1=1 if F.m_nn==1 
	gen m_nm_1=1 if F.m_nm==1 
	gen m_mn_1=1 if F.m_mn==1 
	gen m_mm_1=1 if F.m_mm==1 

* Define movers 2years before move, by dir of move
	gen m_nn_2=1 if F.m_nn_1==1 & MNE==0 & bnr==F.bnr
	gen m_nm_2=1 if F.m_nm_1==1 & MNE==0 & bnr==F.bnr
	gen m_mn_2=1 if F.m_mn_1==1 & MNE==1 & bnr==F.bnr
	gen m_mm_2=1 if F.m_mm_1==1 & MNE==1 & bnr==F.bnr

* Define movers 1 y after move by direction of move
	gen m_nn1=1 if L.m_nn==1 & MNE==L.MNE & bnr==L.bnr
	gen m_nm1=1 if L.m_nm==1 & MNE==L.MNE & bnr==L.bnr
	gen m_mn1=1 if L.m_mn==1 & MNE==L.MNE & bnr==L.bnr
	gen m_mm1=1 if L.m_mm==1 & MNE==L.MNE & bnr==L.bnr

* Define movers 2 y after move by direction of move
	gen m_nn2=1 if L2.m_nn==1 & MNE==L.MNE & bnr==L.bnr
	gen m_nm2=1 if L2.m_nm==1 & MNE==L.MNE & bnr==L.bnr
	gen m_mn2=1 if L2.m_mn==1 & MNE==L.MNE & bnr==L.bnr
	gen m_mm2=1 if L2.m_mm==1 & MNE==L.MNE & bnr==L.bnr
	
	foreach t in m_nn m_nm m_mm m_mn {
		qui replace `t'=0 if `t'==.
		di "Number of `t'=1"
		count if `t'==1
		foreach x in _1 _2 1 2 {
			qui replace `t'`x'=0 if `t'`x'==.
			di "Number of `t'`x'=1"
			count if `t'`x'==1
		}
	}
	
  	compress
	bys stay: sum eduy erf tenure
	bys stay5: sum eduy erf tenure

	drop maxutl minutl n_move 
* Year and industry year interaction dummies
* sine est are by plant or individual fixed effect only on
* individuals in the same plant industry dummies are redundant
	quietly tab aar, gen(Y)
	gen isic2=int(isic3/10)
	egen x=group(isic2 aar)	
	qui tab x, gen(iy)
	compress
	tsset pid aar
	gen deltaw=D.wage
	save temp1.dta, replace

****************
* Movers before move: Movers from MNEs versus stayers in MNEs
*****************
#delimit ;
global regvar "size size2 kint skillshare femshare sex eduy tenure t2 erf erf2 erf3 erf4 Y*
	Deduy Dtenure Dt2 Derf Derf2 Derf3 Derf4";
#delimit cr
global dummies1 "m_mm_1 m_mm_2 m_mn_1 m_mn_2"  
global dummies2 "m_mm_1 m_mm_2 m_mn_1 m_mn_2 m_mm m_mn"
global dummies3 "m_mm m_mn"


program define select
	gen sel1=1 if stay==`1'
	foreach t in $dummies1 {
	replace sel1=1 if `t'==1
	}
	gen sel2=sel1
	foreach t in $dummies3 {
		replace sel2=1 if `t'==1
	}
end



	use temp1.dta, clear
	drop m_nm_1 m_nm_2 m_nn_1 m_nn_2 m_nm m_nn 
	drop m_nn1 m_nn2 m_nm1 m_nm2 m_mn1 m_mn2 m_mm1 m_mm2 
	drop stay5
	select 2
	keep if sel2==1
	compress
/*
qui reg deltaw $regvar $dummies2 if sel2==1, cluster(pid) 
est store ols1
qui xtreg deltaw $regvar $dummies2 if sel2==1, cluster(pid) fe
est store indfe1
qui xtreg wage $regvar $dummies2 if sel2==1, cluster(pid) fe
est store indfe2
*/
qui areg wage $regvar $dummies1 if sel1==1, absorb(bnr) cluster(pid)
est store plantfe1
	foreach t in $dummies1 {
		count if `t'==1 & e(sample)
	}

*est table ols1 indfe1 indfe2 plantfe1, stats(N r2 r2_a) keep($dummies2) b(%9.3f) star(.05 .01 .001)

	use temp1.dta, clear
	drop m_nm_1 m_nm_2 m_nn_1 m_nn_2 m_nm m_nn
	drop m_nn1 m_nn2 m_nm1 m_nm2 m_mn1 m_mn2 m_mm1 m_mm2 
	drop stay
	rename stay5 stay
	select 2
	keep if sel2==1
/*
qui reg deltaw $regvar $dummies2 if sel2==1, cluster(pid) 
est store ols15
qui xtreg deltaw $regvar $dummies2 if sel2==1, cluster(pid) fe
est store indfe15
qui xtreg wage $regvar $dummies2 if sel2==1, cluster(pid) fe
est store indfe25
*/
qui areg wage $regvar $dummies1 if sel1==1, absorb(bnr) cluster(pid)
est store plantfe15
*est table ols15 indfe15 indfe25 plantfe15, stats(N r2 r2_a) keep($dummies2) b(%9.3f) star(.05 .01 .001)

	estout plantfe1 plantfe15 using ${pap4tab}moversfromMNEs.tex, replace style(tex) ///
 	keep($dummies1) ///
	stats(N r2_a, fmt(%9.0g %4.2f) labels(N R$^2$)) /// 
	cells(b(fmt(%4.3f)) se(par star fmt(%4.3f))) ///
	starlevels ($^{\ast}$ .05 $^{\ast\ast}$ .01 $^{\ast\ast\ast}$ .001 ) /// 
 	mlabels( , none) label nolz collabels(, none) ///
 	varlabels(m_mm_1 "Movers from MNEs to MNEs, 1 y. bef. move" m_mm_2 "Movers from MNEs to MNEs, 2 y. bef. move" ///
	  m_mn_1 "Movers from MNEs to non-MNEs, 1 y. bef. move"  m_mn_2 "Movers from MNEs to non-MNEs, 2 y. bef. move" ) ///
	title("Movers versus stayers: wages before move") 

********************
* Movers to nonMNEs versus stayers in nonMNEs: after move
* Keep only the non-MNEs used in productivity regressions
*******************

* Indicator for productivity regression sample
	use ${pap4data}regpanel.dta, clear
	merge bnr aar using ${pap4data}new_workers.dta, keep(N N_exp*)
	keep if _merge==3
	foreach t in N_exp{
		quietly gen s`t'=`t'/N
		assert s`t'!=.
	}
	keep if maxutl==0
	quietly reg q k m h fp lms5 cr5 lpm lturb  
	gen s=1 if e(sample)
	keep if s==1
	drop s
	bys bnr: egen neverMNEexp=sum(N_exp)
	count if neverMNEexp==0
	gen MNEexpsample=1 if neverMNEexp!=0
	keep if MNEexpsample==1
	keep aar bnr
	sort bnr aar
	tempfile tempmerge
	save tempmerge.dta, replace





global dummies1 "m_nn1 m_nn2 m_mn1 m_mn2"  
global dummies2 "m_nn m_nn1 m_nn2 m_mn m_mn1 m_mn2"
global dummies3 "m_nn m_mn"

/*	
	use temp1.dta, clear
	*drop stay5 
	drop m_nm1 m_nm2 m_mm1 m_mm2 m_mm m_nm
	drop m*_1 m*_2


	select 1
	keep if sel2==1
qui reg deltaw $regvar $dummies2 if sel2==1, cluster(pid) 
est store ols1a
qui xtreg deltaw $regvar $dummies2 if sel2==1, cluster(pid) fe
est store indfe1a
qui xtreg wage $regvar $dummies2 if sel2==1, cluster(pid) fe
est store indfe2a
	foreach t in $dummies2 {
		count if `t'==1 & e(sample)
	}
qui areg wage $regvar $dummies2 if sel2==1, absorb(bnr) cluster(pid)
est store plantfe1a
est table ols1a indfe1a indfe2a plantfe1a, stats(N r2 r2_a) keep($dummies2) b(%9.3f) star(.05 .01 .001)

*/
	use temp1.dta, clear
	*drop stay5 
	drop m_nm1 m_nm2 m_mm1 m_mm2 m_mm m_nm
	drop m*_1 m*_2

*Define movers by tenure before move to nonMNE
	gen m_mnl=1 if move==1 & MNE==0 & L.MNE==1 & L.tenure<1
	gen m_mnm=1 if move==1 & MNE==0 & L.MNE==1 & L.tenure<3 & L.tenure>=1
	gen m_mnh=1 if move==1 & MNE==0 & L.MNE==1 & L.tenure>=3
	gen m_nnl=1 if move==1 & MNE==0 & L.MNE==0 & L.tenure<1
	gen m_nnm=1 if move==1 & MNE==0 & L.MNE==0 & L.tenure<3 & L.tenure>=1
	gen m_nnh=1 if move==1 & MNE==0 & L.MNE==0 & L.tenure>=3

* Define movers 1 y after move by direction of move and tenure before move
	gen m_nnl1=1 if L.m_nnl==1 & MNE==L.MNE & bnr==L.bnr
	gen m_nnm1=1 if L.m_nnm==1 & MNE==L.MNE & bnr==L.bnr
	gen m_nnh1=1 if L.m_nnh==1 & MNE==L.MNE & bnr==L.bnr
	gen m_mnl1=1 if L.m_mnl==1 & MNE==L.MNE & bnr==L.bnr
	gen m_mnm1=1 if L.m_mnm==1 & MNE==L.MNE & bnr==L.bnr
	gen m_mnh1=1 if L.m_mnh==1 & MNE==L.MNE & bnr==L.bnr

	
	foreach t in m_nnl m_nnm m_mnm m_mnl m_nnh m_mnh {
		qui replace `t'=0 if `t'==.
		di "Number of `t'=1"
		count if `t'==1
		foreach x in 1  {
			qui replace `t'`x'=0 if `t'`x'==.
			di "Number of `t'`x'=1"
			count if `t'`x'==1
		}
	}

global tenuredummies "m_mnl m_mnl1 m_mnm m_mnm1 m_mnh m_mnh1 m_nnl m_nnl1 m_nnm m_nnm1 m_nnh m_nnh1"

	gen sel1=1 if stay==1
	gen sel2=sel1
	foreach t in $tenuredummies {
		replace sel2=1 if `t'==1
	}
	sort bnr aar
	merge bnr aar using tempmerge
tab _merge

/*	
qui reg deltaw $regvar $tenuredummies if sel2==1, cluster(pid) 
est store ols1a
qui xtreg deltaw $regvar $tenuredummies if sel2==1, cluster(pid) fe
est store indfe1a
qui xtreg wage $regvar $tenuredummies if sel2==1, cluster(pid) fe
est store indfe2a
*/
qui areg wage $regvar $tenuredummies if sel2==1 & _merge==3, absorb(bnr) cluster(pid)
est store plantfe1a
	foreach t in $tenuredummies {
		count if `t'==1 & e(sample)
	}

*est table ols1a indfe1a indfe2a plantfe1a, stats(N r2 r2_a) keep($tenuredummies) b(%9.3f) star(.05 .01 .001)
drop sel2
	gen sel2=1 if stay5==1
	foreach t in $tenuredummies {
		replace sel2=1 if `t'==1
	}

qui areg wage $regvar $tenuredummies if sel2==1 & _merge==3, absorb(bnr) cluster(pid)
est store plantfe1a5
	foreach t in $tenuredummies {
		count if `t'==1 & e(sample)
	}


	estout plantfe1a plantfe1a5 using ${pap4tab}moversfromMNEsafter.tex, replace style(tex) ///
 	keep($tenuredummies) ///
	stats(N r2_a, fmt(%9.0g %4.2f) labels(N R$^2$)) /// 
	cells(b(fmt(%4.3f)) se(par star fmt(%4.3f))) ///
	starlevels ($^{\ast}$ .05 $^{\ast\ast}$ .01 $^{\ast\ast\ast}$ .001 ) /// 
 	mlabels( , none) label nolz collabels(, none) ///
 	title("Movers versus stayers: wages after move") 



global tenuredummies " m_mnl1 m_mnm1 m_mnh1 m_nnl1  m_nnm1  m_nnh1"
	drop sel2
	gen sel2=sel1
	foreach t in $tenuredummies {
		replace sel2=1 if `t'==1
	}
qui areg wage $regvar $tenuredummies if sel2==1 & _merge==3, absorb(bnr) cluster(pid)
est store plantfe1a
	foreach t in $tenuredummies {
		count if `t'==1 & e(sample)
	}

*est table ols1a indfe1a indfe2a plantfe1a, stats(N r2 r2_a) keep($tenuredummies) b(%9.3f) star(.05 .01 .001)
drop sel2
gen sel2=1 if stay5==1
	foreach t in $tenuredummies {
		replace sel2=1 if `t'==1
	}

qui areg wage $regvar $tenuredummies if sel2==1 & _merge==3, absorb(bnr) cluster(pid)
est store plantfe1a5
	foreach t in $tenuredummies {
		count if `t'==1 & e(sample)
	}


	estout plantfe1a plantfe1a5 using ${pap4tab}moversfromMNEsafter_1.tex, replace style(tex) ///
 	keep($tenuredummies) ///
	stats(N r2_a, fmt(%9.0g %4.2f) labels(N R$^2$)) /// 
	cells(b(fmt(%4.3f)) se(par star fmt(%4.3f))) ///
	starlevels ($^{\ast}$ .05 $^{\ast\ast}$ .01 $^{\ast\ast\ast}$ .001 ) /// 
 	mlabels( , none) label nolz collabels(, none) ///
 	title("Movers versus stayers: wages after move") 

* Repeat last table with movers to MNEs
	use temp1.dta, clear
	*drop stay5 
	drop m_nm1 m_nm2 m_mm1 m_mm2 m_mm m_nm
	drop m*_1 m*_2

*Define movers by tenure before move to MNE
	gen m_nml=1 if move==1 & MNE==1 & L.MNE==0 & L.tenure<1
	gen m_nmm=1 if move==1 & MNE==1 & L.MNE==0 & L.tenure<3 & L.tenure>=1
	gen m_nmh=1 if move==1 & MNE==1 & L.MNE==0 & L.tenure>=3
	gen m_mml=1 if move==1 & MNE==1 & L.MNE==1 & L.tenure<1
	gen m_mmm=1 if move==1 & MNE==1 & L.MNE==1 & L.tenure<3 & L.tenure>=1
	gen m_mmh=1 if move==1 & MNE==1 & L.MNE==1 & L.tenure>=3

* Define movers 1 y after move by direction of move and tenure before move
	gen m_mml1=1 if L.m_mml==1 & MNE==L.MNE & bnr==L.bnr
	gen m_mmm1=1 if L.m_mmm==1 & MNE==L.MNE & bnr==L.bnr
	gen m_mmh1=1 if L.m_mmh==1 & MNE==L.MNE & bnr==L.bnr
	gen m_nml1=1 if L.m_nml==1 & MNE==L.MNE & bnr==L.bnr
	gen m_nmm1=1 if L.m_nmm==1 & MNE==L.MNE & bnr==L.bnr
	gen m_nmh1=1 if L.m_nmh==1 & MNE==L.MNE & bnr==L.bnr

	
	foreach t in m_mml m_mmm m_nmm m_nml m_mmh m_nmh {
		qui replace `t'=0 if `t'==.
		di "Number of `t'=1"
		count if `t'==1
		foreach x in 1  {
			qui replace `t'`x'=0 if `t'`x'==.
			di "Number of `t'`x'=1"
			count if `t'`x'==1
		}
	}

global tenuredummies " m_nml1 m_nmm1 m_nmh1 m_mml1  m_mmm1  m_mmh1"
gen sel1=1 if stay==2
	foreach t in $tenuredummies {
		replace sel1=1 if `t'==1
	}
qui areg wage $regvar $tenuredummies if sel1==1, absorb(bnr) cluster(pid)
est store MNE1
	foreach t in $tenuredummies {
		count if `t'==1 & e(sample)
	}
drop sel1
gen sel1=1 if stay5==2
	foreach t in $tenuredummies {
		replace sel1=1 if `t'==1
	}
qui areg wage $regvar $tenuredummies if sel1==1, absorb(bnr) cluster(pid)
est store MNE2
	foreach t in $tenuredummies {
		count if `t'==1 & e(sample)
	}

	estout MNE1 MNE2 using ${pap4tab}moverstoMNEsafter_1.tex, replace style(tex) ///
 	keep($tenuredummies) ///
	stats(N r2_a, fmt(%9.0g %4.2f) labels(N R$^2$)) /// 
	cells(b(fmt(%4.3f)) se(par star fmt(%4.3f))) ///
	starlevels ($^{\ast}$ .05 $^{\ast\ast}$ .01 $^{\ast\ast\ast}$ .001 ) /// 
 	mlabels( , none) label nolz collabels(, none) ///
 	title("Movers versus stayers: wages in MNEs after move") 


erase temp1.dta
erase tempmerge.dta
log close
 exit

gen

********************
* Movers from nonMNEs versus stayers in nonMNEs: before move
*******************
global dummies1 "m_nm_1 m_nm_2 m_nn_1 m_nn_2"  
global dummies2 "m_nm_1 m_nm_2 m_nn_1 m_nn_2 m_nm m_nn"
global dummies3 "m_nm m_nn"
	
	use temp1.dta, clear
	drop m_mm_1 m_mm_2 m_mn_1 m_mn_2 m_mm m_mn
	drop m_nn1 m_nn2 m_nm1 m_nm2 m_mn1 m_mn2 m_mm1 m_mm2 
	drop stay5
	select 1
	keep if sel2==1
	regs

	use temp1.dta, clear
	drop stay 
	drop m_mm_1 m_mm_2 m_mn_1 m_mn_2 m_mm m_mn
	drop m_nn1 m_nn2 m_nm1 m_nm2 m_mn1 m_mn2 m_mm1 m_mm2 
	rename stay5 stay
	select 1
	keep if sel2==1
	regs

********************
* Movers to MNEs versus stayers in MNEs: after move
*******************
global dummies1 "m_nm1 m_nm2 m_mm1 m_mm2"  
global dummies2 "m_nm1 m_nm2 m_mm1 m_mm2 m_nm m_mm"
global dummies3 "m_mm m_nm"

	use temp1.dta, clear
	drop stay5 
	drop m_nn1 m_nn2 m_mn1 m_mn2 m_nn m_mn
	drop m*_1 m*_2
	select 2
	keep if sel2==1
	regs

	use temp1.dta, clear
	drop stay 
	drop m_nn1 m_nn2 m_mn1 m_mn2 m_nn m_mn
	drop m*_1 m*_2
	rename stay5 stay
	select 2
	keep if sel2==1
	regs

erase temp1.dta
log close 
exit
