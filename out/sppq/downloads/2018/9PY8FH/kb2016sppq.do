version 12.1
set more off
  quietly log
  local logon = r(status)
  if "`logon'" == "on" { 
	log close 
	}
log using kb2016sppq.log, text replace


/* *************************************************************      */
/*  File Name:  kb2016sppq.do                                         */
/*  Authors:    Rebecca Kreitzer and Frederick J. Boehmke             */
/*  Date:       February 22, 2018                                     */
/*  Purpose:    Replication of Pooled Event History Analysis models   */
/*              for Kreitzer and Boehmke, SPPQ, 2016. This runs the   */
/*              anti-abortion examples for Table 1 and Figures 3 & 4. */
/*  Input:      kb2016sppq.dta                                        */
/*  Output:     kb2016sppq.log,                                       */
/*              kb2016sppq_mc01.dta,                                  */
/*              kb2016sppq-fig3.gph,                                  */
/*              kb2016sppq-fig4.gph                                   */
/*  Programs:   estout.ado                                            */	
/* *************************************************************      */


use kb2016sppq.dta, clear

	///////////////////////////
	* Run models for Table 1  *
	///////////////////////////

* M1: Logit

logit adopt_policy norrander_legality religadhrate initdif dem_gov uni_dem_leg ///
	fem_dem nbrspct rescaledmedincome rescaledpopsize time time2 webster, cluster(state)
 
		estat ic
		estimates store t1m1_log

* M2: FEs

logit adopt_policy norrander_legality religadhrate initdif dem_gov uni_dem_leg ///
	fem_dem nbrspct rescaledmedincome rescaledpopsize time time2 webster i.policy_num, cluster(state)

		estat ic
		estimates store t1m2_fes
		
* M3: Clustered

logit adopt_policy norrander_legality religadhrate initdif dem_gov uni_dem_leg ///
	fem_dem nbrspct rescaledmedincome rescaledpopsize time time2 webster, cluster(state_policy)

		estat ic
		estimates store t1m3_clu

* M4: MLM

melogit adopt_policy norrander_legality religadhrate initdif dem_gov uni_dem_leg ///
	fem_dem nbrspct rescaledmedincome rescaledpopsize time time2 webster || policy_num: 

		estat ic
		estimates store t1m4_mlm

* M5: MLM-RC

melogit adopt_policy norrander_legality religadhrate initdif dem_gov uni_dem_leg ///
	fem_dem nbrspct rescaledmedincome rescaledpopsize time time2 webster ||policy_num: nbrspct dem_gov 

		estat ic
		estimates store t1m5_mlm_rc	

* Make Table. Install estout.ado if needed (-net search estout- at the command prompt).

  estout t1m1_log t1m2_fes t1m3_clu t1m4_mlm t1m5_mlm_rc using kb2016sppq-fig1.txt, replace ///
	cells(b(star fmt(3)) se(par)) ///
	stats(N chi2 aic bic, fmt(0 2)) ///
	modelwidth(8) ///
	starlevels(* 0.1 ** 0.05 *** 0.01) legend ///
	label varwidth(30) ///
	drop(*policy*) ///
	mlabels(Logit FEs Clustered MLM MLM-RC) ///
	collabels(, none) 
		
	///////////////////////////
	* Open up MLMRC estimates.*
	///////////////////////////

*estimates replay t1m5_mlm_rc

*  estimates esample: adopt_policy norrander_legality initdif  ///
*	fem_dem rescaledmedincome rescaledpopsize nbrspct time time2 webster ///
*	dem_gov religadhrate uni_dem_leg if !missing(policy_num)
		
predict re1 re2 re0, remeans reses(re_se1 re_se2 re_se0)

  generate b0 = _b[_cons]
  generate b1 = _b[nbrspct]
  generate b2 = _b[dem_gov]

  generate se0 = _se[_cons]
  generate se1 = _se[nbrspct]
  generate se2 = _se[dem_gov]  
  
  collapse (mean) re_se1-se2 policy_num, by(policy_name)
	 
	///////////////////////////
	* Gen combined full SEs.  *
	* Assumes independence.   *
	///////////////////////////

 generate b0_re0 = b0 + re0
 generate b1_re1 = b1 + re1
 generate b2_re2 = b2 + re2

 generate b0_lo = b0 - 1.96*se0
 generate b1_lo = b1 - 1.96*se1
 generate b2_lo = b2 - 1.96*se2

 generate b0_hi = b0 + 1.96*se0
 generate b1_hi = b1 + 1.96*se1
 generate b2_hi = b2 + 1.96*se2

 generate b0_re0_lo = b0_re0 - 1.96*re_se0
 generate b1_re1_lo = b1_re1 - 1.96*re_se1
 generate b2_re2_lo = b2_re2 - 1.96*re_se2

 generate b0_re0_hi = b0_re0 + 1.96*re_se0
 generate b1_re1_hi = b1_re1 + 1.96*re_se1
 generate b2_re2_hi = b2_re2 + 1.96*re_se2

 generate b0_re0_full_lo = b0_re0 - 1.96*sqrt(re_se0^2 + se0^2)
 generate b1_re1_full_lo = b1_re1 - 1.96*sqrt(re_se1^2 + se1^2)
 generate b2_re2_full_lo = b2_re2 - 1.96*sqrt(re_se2^2 + se2^2)

 generate b0_re0_full_hi = b0_re0 + 1.96*sqrt(re_se0^2 + se0^2)
 generate b1_re1_full_hi = b1_re1 + 1.96*sqrt(re_se1^2 + se1^2)
 generate b2_re2_full_hi = b2_re2 + 1.96*sqrt(re_se2^2 + se2^2)

 generate b0_sig = 0
 replace b0_sig = 1 if abs(b0_re0/sqrt(re_se0^2 + se0^2)) > 1.65
 replace b0_sig = 2 if abs(b0_re0/sqrt(re_se0^2 + se0^2)) > 1.96

 generate b1_sig = 0
 replace b1_sig = 1 if abs(b1_re1/sqrt(re_se1^2 + se1^2)) > 1.65
 replace b1_sig = 2 if abs(b1_re1/sqrt(re_se1^2 + se1^2)) > 1.96

 generate b2_sig = 0
 replace b2_sig = 1 if abs(b2_re2/sqrt(re_se2^2 + se2^2)) > 1.65
 replace b2_sig = 2 if abs(b2_re2/sqrt(re_se2^2 + se2^2)) > 1.96

 generate zero = 0

 encode policy_name, generate(policy)
	 
	/////////////////
	* Figure 3      *
	/////////////////
	
* plot estimated random coefficients for neighboring adopters by policy
* Note that there are a couple small differences in Figure 3 relative to the 
* published figure. See README for details.

twoway rarea b1_lo b1_hi policy, horiz scheme(s1mono) /// 
	color(gs15) /// 
  ||	rarea b1 b1 policy, horiz /// 
	color(gs0) /// 
  ||	rarea zero zero policy, horiz /// 
	lcolor(red) lpattern(solid) /// 
  || 	rspike b1_re1_full_lo b1_re1_full_hi policy if b1_sig==0, horiz /// 
	lcolor(gs13) /// 
  ||	scatter policy b1_re1 if b1_sig==0,	 /// 
	msymbol(o) mcolor(gs13) msize(medsmall)	 /// 
  ||	rspike b1_re1_full_lo b1_re1_full_hi policy if b1_sig==1, horiz /// 
	lcolor(gs8) /// 
  ||	scatter policy b1_re1 if b1_sig==1,	 /// 
	msymbol(s) mcolor(gs8) msize(medium)	 /// 
  ||	rspike b1_re1_full_lo b1_re1_full_hi policy if b1_sig==2, horiz /// 
	lcolor(gs0) /// 
  ||	scatter policy b1_re1 if b1_sig==2,	 /// 
	msymbol(d) mcolor(gs0) msize(medsmall)	 /// 
	ylabel(#29, valuelabel angle(horizontal) labsize(vsmall))	/// 
	ytitle("") xtitle("")	///
	xsize(5) ysize(3) graphregion(margin(tiny))	///
	legend(off)	///
	saving(kb2016sppq-fig3, replace) 
		
	/////////////////
	* Figure 4      *
	/////////////////

* plot estimated random coefficients for democratic governor by policy

twoway rarea b2_lo b2_hi policy, horiz scheme(s1mono) /// 
	color(gs15) /// 
  ||	rarea b2 b2 policy, horiz /// 
	color(gs0) /// 
  ||	rarea zero zero policy, horiz /// 
	lcolor(red) lpattern(solid) /// 
  || 	rspike b2_re2_full_lo b2_re2_full_hi policy if b2_sig==0, horiz /// 
	lcolor(gs13) /// 
  ||	scatter policy b2_re2 if b2_sig==0,	 /// 
	msymbol(o) mcolor(gs13) msize(medsmall)	 /// 
  ||	rspike b2_re2_full_lo b2_re2_full_hi policy if b2_sig==1, horiz /// 
	lcolor(gs8) /// 
  ||	scatter policy b2_re2 if b2_sig==1,	 /// 
	msymbol(s) mcolor(gs8) msize(medium)	 /// 
  ||	rspike b2_re2_full_lo b2_re2_full_hi policy if b2_sig==2, horiz /// 
	lcolor(gs0) /// 
  ||	scatter policy b2_re2 if b2_sig==2,	 /// 
	msymbol(d) mcolor(gs0) msize(medsmall)	 /// 
	ylabel(#29, valuelabel angle(horizontal) labsize(vsmall))	///
	ytitle("") xtitle("")	///
	xsize(5) ysize(3) graphregion(margin(tiny))	///
	legend(off)	///
	saving(kb2016sppq-fig4, replace)
	
clear
log close
exit, STATA
