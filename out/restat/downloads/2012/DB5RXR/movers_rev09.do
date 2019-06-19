version 10
clear
set memory 1400m
set matsize 7000
capture log close
log using ${pap4log}movers_rev09, text replace
set more off
capture program drop _all

***11.06.2009 ***RBal**********************************************
* Do movers earn more or less than non movers before mobility?
* 1. Compare movers from MNEs to nonMNEs with stayers in MNEs
* 2. Compare movers from MNEs to other MNEs to stayers in MNEs
* 3. Include 1 and 2 in same regression. 1 2 3 done in a program
* 4. Repeat program for 1-3, but redefine MNE the opposite way, so 
* 	this compares movers from nonMNEs to MNEs 
*	with stayers in nonMNEs.
*******************************************************************

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

* Define movers 2 y after move by direction of move
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
* Year and industry dummies
	quietly tab aar, gen(Y)
	*gen isic2=int(isic3/10)
	quietly tab isic3, gen (I)
	drop Y1 I1 isic3 
	bys bnr: egen mw=mean(wage)
	gen dw=wage-mw
	drop mw n N MNE
	bys bnr aar: egen mw=mean(wage)
	gen dwy=wage-mw
	drop mw
	compress
	tsset pid aar
	save temp1.dta, replace

****************
* Movers before move: Movers from MNEs versus stayers in MNEs
*****************
#delimit ;
global regvar "size size2 kint skillshare femshare sex eduy tenure t2 erf erf2 erf3 erf4 Y* I*
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

program define regs
qui reg wage $regvar $dummies1 if sel1==1, cluster(pid)
est store ols1
qui xtreg wage $regvar $dummies1 if sel1==1, cluster(pid) fe
est store indfe1
qui reg wage $regvar $dummies2 if sel2==1, cluster(pid)
est store ols2
qui xtreg wage $regvar $dummies2 if sel2==1, cluster(pid) fe
est store indfe2
	foreach t in $dummies2 {
		count if `t'==1 & e(sample)
	}
qui reg dw $regvar $dummies1 if sel1==1, cluster(pid)
est store ols_dw
qui reg dwy $regvar $dummies1 if sel1==1, cluster(pid)
est store ols_dwy

est table ols1 ols2 indfe1 indfe2 ols_dw ols_dwy, stats(N r2 r2_a) keep($dummies2) b(%9.3f) star(.1 .05 .01)
est drop _all

qui areg wage $regvar $dummies1 if sel1==1, absorb(bnr) cluster(pid)
est store plantfe1
qui areg dw $regvar $dummies1 if sel1==1, absorb(bnr) cluster(pid)
est store plantfe_dw1
qui areg wage $regvar $dummies2 if sel2==1, absorb(bnr) cluster(pid)
est store plantfe2
qui areg dwy $regvar $dummies1 if sel1==1, absorb(bnr) cluster(pid)
est store plantfe_dwy1
qui areg dw $regvar $dummies1 if sel2==1, absorb(bnr) cluster(pid)
est store plantfe_dw2

est table plantfe1 plantfe2 plantfe_dw1 plantfe_dw2 plantfe_dwy1, stats(N r2 r2_a) keep($dummies2) b(%9.3f) star(.1 .05 .01)
est drop _all
/*
qui tab bnr, gen(B)
qui reg wage $regvar $dummies1 B* if sel1==1, cluster(pid)
est store ols_pd1
qui reg dw $regvar $dummies1 B* if sel1==1, cluster(pid)
est store ols_pd1_dw
qui reg wage $regvar $dummies2 B* if sel2==1, cluster(pid)
est store ols_pd2
est table ols_pd1 ols_pd2 ols_pd1_dw, stats(N r2 r2_a) keep($dummies2) b(%9.3f) star(.1 .05 .01)
est drop _all
*/
end



	use temp1.dta, clear
	drop m_nm_1 m_nm_2 m_nn_1 m_nn_2 m_nm m_nn 
	drop m_nn1 m_nn2 m_nm1 m_nm2 m_mn1 m_mn2 m_mm1 m_mm2 
	drop stay5
	select 2
	keep if sel2==1
	compress
	regs

	use temp1.dta, clear
	drop m_nm_1 m_nm_2 m_nn_1 m_nn_2 m_nm m_nn
	drop m_nn1 m_nn2 m_nm1 m_nm2 m_mn1 m_mn2 m_mm1 m_mm2 
	drop stay
	rename stay5 stay
	select 2
	keep if sel2==1
	regs

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
* Movers to nonMNEs versus stayers in nonMNEs: after move
*******************
global dummies1 "m_nn1 m_nn2 m_mn1 m_mn2"  
global dummies2 "m_nn1 m_nn2 m_mn1 m_mn2 m_nn m_mn"
global dummies3 "m_mn m_nn"
	
	use temp1.dta, clear
	drop stay5 
	drop m_nm1 m_nm2 m_mm1 m_mm2 m_mm m_nm
	drop m*_1 m*_2
	select 1
	keep if sel2==1
	regs

	use temp1.dta, clear
	drop stay 
	drop m_nm1 m_nm2 m_mm1 m_mm2 m_mm m_nm
	drop m*_1 m*_2
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
