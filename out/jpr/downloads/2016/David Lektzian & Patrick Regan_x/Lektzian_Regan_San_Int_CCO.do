* Table 1: Single Equation Logit Models
	use "Lektzian_Regan_San_Int_CCO.dta", clear
	drop if CW~=1

* Model 1
	eststo clear
	xtlogit CWenyrmoD sanUniDty##CWInt1 sannotUniDty lnKSGcgdppc UDS CWMajD lnKSGpop c.CWCount##c.CWCount##c.CWCount, vce(cl ccode)
	
	* Calculating psuedo R2 for model 1
	qui xtlogit CWenyrmoD, vce(cl ccode)
	local ll0=e(ll)
	qui xtlogit CWenyrmoD sanUniDty##CWInt1 sannotUniDty lnKSGcgdppc UDS CWMajD lnKSGpop c.CWCount##c.CWCount##c.CWCount, vce(cl ccode)
	local ll=e(ll)
	display "pseudo R2=" (`ll0' - `ll')/`ll0'
		
* Model 2
	xtlogit CWenyrmoD SanInstyrDty##CWInt1 SanNotInstyrDty lnKSGcgdppc UDS CWMajD lnKSGpop c.CWCount##c.CWCount##c.CWCount, vce(cl ccode)
	
	* Calculating psuedo R2 for model 2
	qui xtlogit CWenyrmoD, vce(cl ccode)
	local ll0=e(ll)
	qui xtlogit CWenyrmoD SanInstyrDty##CWInt1 SanNotInstyrDty lnKSGcgdppc UDS CWMajD lnKSGpop c.CWCount##c.CWCount##c.CWCount, vce(cl ccode)
	local ll=e(ll)
	display "pseudo R2=" (`ll0' - `ll')/`ll0'
		
	* Reversing interaction for interpretations
	xtlogit CWenyrmoD SanInstyrDty##NotCWInt1 SanNotInstyrDty lnKSGcgdppc UDS CWMajD lnKSGpop c.CWCount##c.CWCount##c.CWCount, vce(cl ccode)
	xtlogit CWenyrmoD SanInstyrDtyNeg##CWInt1 SanNotInstyrDty lnKSGcgdppc UDS CWMajD lnKSGpop c.CWCount##c.CWCount##c.CWCount, vce(cl ccode)

	* Substantive interpretations
	xtlogit CWenyrmoD SanInstyrDty##CWInt1 SanNotInstyrDty lnKSGcgdppc UDS CWMajD lnKSGpop c.CWCount##c.CWCount##c.CWCount, vce(cl ccode)
	margins i.SanInstyrDty##i.CWInt1, predict(pu0)  at(CWMajD==0 ) atmeans

* Model 3	
	xtlogit CWenyrmoD sanUniDty##MPInt sannotUniDty NoMPInt lnKSGcgdppc UDS CWMajD lnKSGpop c.CWCount##c.CWCount##c.CWCount, vce(cl ccode)
	
	* Calculating psuedo R2 for model 3
	qui xtlogit CWenyrmoD, vce(cl ccode)
	local ll0=e(ll)
	qui xtlogit CWenyrmoD sanUniDty##MPInt sannotUniDty NoMPInt lnKSGcgdppc UDS CWMajD lnKSGpop c.CWCount##c.CWCount##c.CWCount, vce(cl ccode)
	local ll=e(ll)
	display "pseudo R2=" (`ll0' - `ll')/`ll0'
		
* Model 4
	xtlogit CWenyrmoD SanInstyrDty##MPInt SanNotInstyrDty NoMPInt lnKSGcgdppc UDS CWMajD lnKSGpop c.CWCount##c.CWCount##c.CWCount, vce(cl ccode)
	
	* Calculating psuedo R2 for model 4
	qui xtlogit CWenyrmoD, vce(cl ccode)
	local ll0=e(ll)
	qui xtlogit CWenyrmoD SanInstyrDty##MPInt SanNotInstyrDty NoMPInt lnKSGcgdppc UDS CWMajD lnKSGpop c.CWCount##c.CWCount##c.CWCount, vce(cl ccode)
	local ll=e(ll)
	display "pseudo R2=" (`ll0' - `ll')/`ll0'
	
	* Reversing for interpretations
	xtlogit CWenyrmoD SanInstyrDty##NotMPInt SanNotInstyrDty NoMPInt lnKSGcgdppc UDS CWMajD lnKSGpop c.CWCount##c.CWCount##c.CWCount, vce(cl ccode)
	xtlogit CWenyrmoD SanInstyrDtyNeg##MPInt SanNotInstyrDty NoMPInt lnKSGcgdppc UDS CWMajD lnKSGpop c.CWCount##c.CWCount##c.CWCount, vce(cl ccode)
	
	* Substantive interpretations
	xtlogit CWenyrmoD SanInstyrDty##MPInt SanNotInstyrDty NoMPInt lnKSGcgdppc UDS CWMajD lnKSGpop c.CWCount##c.CWCount##c.CWCount, vce(cl ccode)
	margins i.SanInstyrDty##i.MPInt, predict(pu0)  at(CWMajD==0) atmeans
	

* Table 2: Multinomial Models
* Model 1
	mlogit MultOut4 sanUniDty##CWInt1 sannotUniDty lnKSGcgdppc UDS CWMajD lnKSGpop c.CWCount##c.CWCount##c.CWCount, vce(cl ccode)
	margins sanUniDty#CWInt1, at(CWMajD=0) pr(outcome(0))
	margins sanUniDty#CWInt1, at(CWMajD=0) pr(outcome(1))
	margins sanUniDty#CWInt1, at(CWMajD=0)  pr(outcome(2))
	margins sanUniDty#CWInt1, at(CWMajD=0)  pr(outcome(3))

	* Calculating psuedo R2 for model 1
	qui mlogit MultOut4, vce(cl ccode)
	local ll0=e(ll)
	qui mlogit MultOut4 sanUniDty##CWInt1 sannotUniDty lnKSGcgdppc UDS CWMajD lnKSGpop c.CWCount##c.CWCount##c.CWCount, vce(cl ccode)
	local ll=e(ll)
	display "pseudo R2=" (`ll0' - `ll')/`ll0'
	
* Model 2
	mlogit MultOut4 SanInstyrDty##CWInt1 SanNotInstyrDty lnKSGcgdppc UDS CWMajD lnKSGpop c.CWCount##c.CWCount##c.CWCount, vce(cl ccode)
	margins SanInstyrDty#CWInt1, at(CWMajD=0 ) pr(outcome(0))
	margins SanInstyrDty#CWInt1, at(CWMajD=0 ) pr(outcome(1))
	margins SanInstyrDty#CWInt1, at(CWMajD=0 ) pr(outcome(2))
	margins SanInstyrDty#CWInt1, at(CWMajD=0 ) pr(outcome(3))

	* Calculating psuedo R2 for model 2
	qui mlogit MultOut4, vce(cl ccode)
	local ll0=e(ll)
	qui mlogit MultOut4 SanInstyrDty##CWInt1 SanNotInstyrDty lnKSGcgdppc UDS CWMajD lnKSGpop c.CWCount##c.CWCount##c.CWCount, vce(cl ccode)
	local ll=e(ll)
	display "pseudo R2=" (`ll0' - `ll')/`ll0'

*Model 3
	mlogit MultOut4 SanInstyrDty##MPInt SanNotInstyrDty NoMPInt lnKSGcgdppc UDS CWMajD lnKSGpop c.CWCount##c.CWCount##c.CWCount, vce(cl ccode)
	margins SanInstyrDty#MPInt, at(CWMajD=0 ) pr(outcome(0))
	margins SanInstyrDty#MPInt, at(CWMajD=0 ) pr(outcome(1))
	margins SanInstyrDty#MPInt, at(CWMajD=0 )  pr(outcome(2))
	margins SanInstyrDty#MPInt, at(CWMajD=0 )  pr(outcome(3))
	
	* Calculating psuedo R2 for model 3
	qui mlogit MultOut4, vce(cl ccode)
	local ll0=e(ll)
	qui mlogit MultOut4 SanInstyrDty##MPInt SanNotInstyrDty NoMPInt lnKSGcgdppc UDS CWMajD lnKSGpop c.CWCount##c.CWCount##c.CWCount, vce(cl ccode)
	local ll=e(ll)
	display "pseudo R2=" (`ll0' - `ll')/`ll0'

* Figure 1: Looking at timing with a Cox Model
	stset CWCount if CWCount<61, failure(CWenyrmoD) id(CWID) exit(CWCount=.)

	stcox SanInstyrDty##i.CWInt1 SanNotInstyrDty lnKSGcgdppc UDS CWMajD lnKSGpop 

	stcurve, surv at1(CWInt1=0 SanInstyrDty=0 CWMajD=0) ///
	at2(CWInt1=1 SanInstyrDty=0 CWMajD=0) ///
	at3(CWInt1=0 SanInstyrDty=1 CWMajD=0) ///
	at4(CWInt1=1 SanInstyrDty=1 CWMajD=0) ///
	xlabel(0(12)60) ///
	title(" ") ///
	xtitle("Months") ///
	legend(position (6) rows (4) order(1 "No institution sanctions & no intervention" 2 "No institution sanctions & intervention" ///
	3 "Institution sanctions & no intervention" 4 "Institution sanctions & intervention")) ///
	scheme(lean2)

	*Non-parametric means from footnote 8 (Cleves 117).
	stset CWCount , failure(CWenyrmoD) id(CWID) exit(CWCount=.)
	gen MPIntSanInstyrDty = MPInt*SanInstyrDty
	gen CWInt1SanInstyrDty = CWInt1*SanInstyrDty
	
	* These commands give average durations for groups but are not model based (Cleves 117).
	stci, by(CWInt1SanInstyrDty) rmean

* Supplemental Appendix
* Table S1a - Replicating Table 1 with Heckman Model
	use "Lektzian_Regan_San_Int_CCO.dta", clear
	xtset ccode yrmo
* model 1	
	heckprob CWenyrmoD sanUniDty##CWInt1 sannotUniDty lnKSGcgdppc UDS CWMajD lnKSGpop c.CWCount##c.CWCount##c.CWCount, cluster(ccode)    /// 
	select (CW = lnKSGcgdppc UDS lnKSGpop CWpeaceyr CWspline1 CWspline2 CWspline3)
	
* Model 2	
	heckprob CWenyrmoD SanInstyrDty##CWInt1 SanNotInstyrDty lnKSGcgdppc UDS CWMajD lnKSGpop c.CWCount##c.CWCount##c.CWCount, vce(cl ccode)   /// 
	select (CW = lnKSGcgdppc UDS lnKSGpop CWpeaceyr CWspline1 CWspline2 CWspline3)

* Model 3	
	heckprob CWenyrmoD sanUniDty##MPInt sannotUniDty NoMPInt lnKSGcgdppc UDS CWMajD lnKSGpop c.CWCount##c.CWCount##c.CWCount, cluster(ccode)    /// 
	select (CW = lnKSGcgdppc UDS lnKSGpop CWpeaceyr CWspline1 CWspline2 CWspline3)

* Model 4	
	heckprob CWenyrmoD SanInstyrDty##MPInt SanNotInstyrDty NoMPInt lnKSGcgdppc UDS CWMajD lnKSGpop c.CWCount##c.CWCount##c.CWCount, cluster(ccode)    /// 
	select (CW = lnKSGcgdppc UDS lnKSGpop CWpeaceyr CWspline1 CWspline2 CWspline3)
	
*Table S1b - Replicating Table 1 without interactions
	use "Lektzian_Regan_San_Int_CCO.dta", clear
	drop if CW~=1
	xtset ccode yrmo

* Model 1
	xtlogit CWenyrmoD sanUniDty CWInt1 sannotUniDty lnKSGcgdppc UDS CWMajD lnKSGpop c.CWCount##c.CWCount##c.CWCount, vce(cl ccode)
	
	* Calculating psuedo R2 for model 1
	qui xtlogit CWenyrmoD, vce(cl ccode)
	local ll0=e(ll)
	qui xtlogit CWenyrmoD sanUniDty CWInt1 sannotUniDty lnKSGcgdppc UDS CWMajD lnKSGpop c.CWCount##c.CWCount##c.CWCount, vce(cl ccode)
	local ll=e(ll)
	display "pseudo R2=" (`ll0' - `ll')/`ll0'
	
* Model 2
	xtlogit CWenyrmoD SanInstyrDty CWInt1 SanNotInstyrDty lnKSGcgdppc UDS CWMajD lnKSGpop c.CWCount##c.CWCount##c.CWCount, vce(cl ccode)

	* Calculating psuedo R2 for model 2
	qui xtlogit CWenyrmoD, vce(cl ccode)
	local ll0=e(ll)
	qui xtlogit CWenyrmoD SanInstyrDty CWInt1 SanNotInstyrDty lnKSGcgdppc UDS CWMajD lnKSGpop c.CWCount##c.CWCount##c.CWCount, vce(cl ccode)
	local ll=e(ll)
	display "pseudo R2=" (`ll0' - `ll')/`ll0'
	
* Model 3	
	xtlogit CWenyrmoD sanUniDty MPInt sannotUniDty NoMPInt lnKSGcgdppc UDS CWMajD lnKSGpop c.CWCount##c.CWCount##c.CWCount, vce(cl ccode)
	
	* Calculating psuedo R2 for model 2
	qui xtlogit CWenyrmoD, vce(cl ccode)
	local ll0=e(ll)
	qui xtlogit CWenyrmoD sanUniDty MPInt sannotUniDty NoMPInt lnKSGcgdppc UDS CWMajD lnKSGpop c.CWCount##c.CWCount##c.CWCount, vce(cl ccode)
	local ll=e(ll)
	display "pseudo R2=" (`ll0' - `ll')/`ll0'

* Model 4
	xtlogit CWenyrmoD SanInstyrDty MPInt SanNotInstyrDty NoMPInt lnKSGcgdppc UDS CWMajD lnKSGpop c.CWCount##c.CWCount##c.CWCount, vce(cl ccode)
	
	* Calculating psuedo R2 for model 4
	qui xtlogit CWenyrmoD, vce(cl ccode)
	local ll0=e(ll)
	qui xtlogit CWenyrmoD SanInstyrDty MPInt SanNotInstyrDty NoMPInt lnKSGcgdppc UDS CWMajD lnKSGpop c.CWCount##c.CWCount##c.CWCount, vce(cl ccode)
	local ll=e(ll)
	display "pseudo R2=" (`ll0' - `ll')/`ll0'
	
* Table S2 
	stset CWCount, failure(CWenyrmoD) id(CWID) exit(CWCount=.)
	stcox SanInstyrDty##i.CWInt1 SanNotInstyrDty lnKSGcgdppc UDS CWMajD lnKSGpop 

* Table S3
	use "Lektzian_Regan_San_Int_CCO.dta", clear
	drop if CW~=1
	codebook sanUniDty SanInstyrDty CWInt1 MPInt
	gen a1=1 if sanUniDty==1&CWInt1==1
	gen a2=1 if SanInstyrDty==1&CWInt1==1
	gen a3=1 if sanUniDty==1&MPInt==1
	gen a4=1 if SanInstyrDty==1&MPInt==1
	codebook a1 a2 a3 a4
