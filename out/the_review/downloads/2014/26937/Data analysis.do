* Author: Guy Grossman
* This version: 10/11/2013
* Analysis of data for "Administrative Unit Proliferation" APSR 108(1): 196-217


capture log close
clear all
version 12.1
set more off 

* set directory
cd "~/Dropbox/District.Formation/data/replication files/"

* bring in data
use "DistrictFormation.dta"

*****************************************************************************
* Descriptive Stats
*****************************************************************************
* define global
global polimarg "DEC_rep county_dec_share ethdiff"
global econmarg " nonpoor employee nag_pio literacy eduattain gov_primary_conc gov_sec_conc clinics_tot_conc SERVICES margA" 
su $polimarg $econmarg

* recode split category
recode split_cat(1=2)(2=1)
lab define split_cat 0 "No split" 1 "Mother" 2 "Splinter", modify
lab value split_cat split_cat
tab split_cat
		
***************************************************************************
* Table 2: Political and Ethnic Marginalization by Electoral Wave
***************************************************************************

	forvalues i=1/3{
	display "******************************************************
	display "******************************************************
	foreach var in $polimarg {
	display "******************************************************
	tabstat `var' if wave==`i', by(split_cat) stats(mean sd N) f(%8.2f) not
	}
	}

***************************************************************************
* Table 3: Level of Development by Electoral Wave
***************************************************************************

	forvalues i=1/3{
	display "******************************************************
	display "******************************************************
	foreach var in $econmarg {
	display "******************************************************
	tabstat `var' if wave==`i', by(split_cat) stats(mean sd N) f(%8.2f) not
	}
	}	
	
***************************************************************************
* Regressiob analysis
***************************************************************************

* set panel variables
tsset id prev_elections
xtsum splinter mother, i(id)

* define vars for analysis
global MARGS DEC_rep ethdiff margA 
global CONT ncounties break_lag 
global REGIONS region2 region3 region4
global WAVES period3 period4
global POLIT support_loser opposed mshare_lag mshare_lag2
global SOCIO logpop elf02

***************************************************************************
* table 4: Dependent Variable - Splinter category
***************************************************************************

* random intercept logit (identical to random effects)
	eststo clear
	eststo m1: xtlogit splinter $MARGS $CONT $REGIONS $WAVES if ncounties!=1, re
	estat ic

* random intercept logit: add political controls 	
	eststo m2: xtlogit splinter $MARGS $POLIT $CONT $REGIONS $WAVES  if ncounties!=1, re
	estat ic
	
* random intercept logit: add socio-demographic controls 	
	eststo m3: xtlogit splinter $MARGS $SOCIO $CONT $REGIONS $WAVES if ncounties!=1, re
	estat ic

* random intercept logit: all control 	
	eststo m4: xtlogit splinter $MARGS $POLIT $SOCIO $CONT $REGIONS $WAVES if ncounties!=1, re
	estat ic

* random intercept logit: all control 	
	eststo m5: xtlogit splinter $MARGS $POLIT $SOCIO bantushare banyanshare $CONT $REGIONS $WAVES if ncounties!=1, re
	estat ic
			
#delimit;
	esttab m1 m2 m3 m4 m5, 
	b(2) se(2) aic(2) bic(2) nogaps page label booktabs width(\hsize) varlabels(_cons Intercept) 
   	transform(ln*: exp(@) exp(@)) nodepvars nonumbers star(* 0.1 ** 0.05 *** 0.01) scalar("ll Log Likelihood") 
   	title ("District Splits" "and Local Politics");
#delimit cr
			
*********************************************** 
* Figure 2: predicted probabilities from M4
*********************************************** 

  estimate restore m4
  predict pslinter
  gen pslinter2 =invlogit(pslinter)
  
fracpoly reg pslinter2 DEC_rep
fracplot, msymbol(none) title("Pooled", size(3.5)) scheme(lean1) yscale(r(0 1)) ylab(0(0.25)1) ytitle("Predicted probabilities", size(3)) xtitle("Relative DEC share", size(3.5))  lineopts(lp(solid) lc(red)) name(FIG1)
fracplot, title("Pooled", size(3.5)) scheme(lean1) yscale(r(0 1)) ylab(0(0.25)1) ytitle("Predicted probabilities", size(3)) xtitle("Relative DEC share", size(3.5))  lineopts(lp(solid) lc(red)) name(FIG3)

fracpoly reg pslinter2 margA
fracplot, msymbol(none) title("Pooled", size(3.5)) scheme(lean1) yscale(r(0 1)) ylab(0(0.25)1) ytitle("Predicted probabilities", size(3)) xtitle("Development summary index", size(3.5))  lineopts(lp(solid) lc(red)) name(FIG2)
fracplot, title("Pooled", size(3.5)) scheme(lean1) yscale(r(0 1)) ylab(0(0.25)1) ytitle("Predicted probabilities", size(3)) xtitle("Development summary index", size(3.5))  lineopts(lp(solid) lc(red)) name(FIG4)

* Generate Figure 2
graph combine FIG3 FIG4, xsize(16) ysize(10) title("Marginalization and County Secession", size(3.5)) rows(1) col(2) scheme(lean1)


* Alternative graphs not reported in paper
 lab define wave 1 "1996-2000" 2 "2001-2005" 3 "2006-2010"
 lab value wave wave
 lab var pslinter2 "Pred. probabilities" 
  
 lowess pslinter2 DEC_rep if wave==1 & DEC_rep<5 , name(DEC1) title("1996-2000", size(3.5)) bw(.5) scheme(lean1) xscale(r(0 5)) xlab (0(1)5) yscale(r(0 0.75)) ylab(0(0.25)0.75) lineopts(lp(solid) lc(red) lw(thik)) ytitle("Pred. probabilities", size(3)) xtitle("Relative DEC share", size(3))
 lowess pslinter2 DEC_rep if wave==2 & DEC_rep<5 , name(DEC2) title("2001-2005", size(3.5)) bw(.5) scheme(lean1) xscale(r(0 5)) xlab (0(1)5) yscale(r(0 0.75)) ylab(0(0.25)0.75) lineopts(lp(solid) lc(red) lw(thik)) ytitle("") xtitle("Relative DEC share", size(3))
 lowess pslinter2 DEC_rep if wave==3 & DEC_rep<5 , name(DEC3) title("2006-2010", size(3.5)) bw(.5) scheme(lean1) xscale(r(0 5)) xlab (0(1)5) yscale(r(0 0.75)) ylab(0(0.25)0.75) lineopts(lp(solid) lc(red) lw(thik)) ytitle("") xtitle("Relative DEC share", size(3))
 lowess pslinter2 DEC_rep if  DEC_rep<5 , name(DEC4) title("Pooled", size(3.5)) bw(.5) scheme(lean1) xscale(r(0 5)) xlab (0(1)5) yscale(r(0 0.75)) ylab(0(0.25)0.75) lineopts(lp(solid) lc(red) lw(thik)) ytitle("") xtitle("Relative DEC share", size(3))
graph combine DEC1 DEC2 DEC3 DEC4, xsize(10) ysize(10) title("Political marginalization and district splits", size(4)) rows(2) col(2) scheme(lean1)
 
 lowess pslinter2 mshare_lag if wave==1, name(DEC5) title("1996-2000", size(3.5)) bw(.5) scheme(lean1) xscale(r(0 1)) xlab(0(0.25)1) yscale(r(0 0.75)) ylab(0(0.25)0.75) lineopts(lp(solid) lc(red) lw(thik)) ytitle("Pred. probabilities", size(3)) xtitle("Vote share in previous election", size(3))
 lowess pslinter2 mshare_lag if wave==2, name(DEC6) title("2001-2005", size(3.5)) bw(.5) scheme(lean1) xscale(r(0 1)) xlab(0(0.25)1) yscale(r(0 0.75)) ylab(0(0.25)0.75) lineopts(lp(solid) lc(red) lw(thik)) ytitle("") xtitle("Past vote share", size(3))
 lowess pslinter2 mshare_lag if wave==3, name(DEC7) title("2006-2010", size(3.5)) bw(.5) scheme(lean1) xscale(r(0 1)) xlab(0(0.25)1) yscale(r(0 0.75)) ylab(0(0.25)0.75) lineopts(lp(solid) lc(red) lw(thik)) ytitle("") xtitle("Past vote share", size(3))
 lowess pslinter2 mshare_lag, name(DEC8) title("Pooled", size(3.5)) bw(.5) scheme(lean1) xscale(r(0 1)) xlab(0(0.25)1) yscale(r(0 0.75)) ylab(0(0.25)0.75) lineopts(lp(solid) lc(red) lw(thik)) ytitle("", size(3)) xtitle("Past vote share", size(3))
graph combine DEC5 DEC6 DEC7 DEC8, xsize(10) ysize(10) title("Past Museveni vote and district splits", size(4)) rows(2) col(2) scheme(lean1)

 lowess pslinter2 margA if wave==1 , name(DEC9) title("1996-2000", size(3.5)) bw(.5) scheme(lean1) xscale(r(-1 3)) xlab(-1(1)3) yscale(r(0 0.75)) ylab(0(0.25)0.75) lineopts(lp(solid) lc(red) lw(thik)) ytitle("Pred. probabilities", size(3)) xtitle("Service provision", size(3))
 lowess pslinter2 margA if wave==2 , name(DEC10) title("2001-2005", size(3.5)) bw(.5) scheme(lean1) xscale(r(-1 3)) xlab(-1(1)3) yscale(r(0 0.75)) ylab(0(0.25)0.75) lineopts(lp(solid) lc(red) lw(thik)) ytitle("") xtitle("Development index", size(3))
 lowess pslinter2 margA if wave==3 , name(DEC11) title("2006-2010", size(3.5)) bw(.5) scheme(lean1) xscale(r(-1 3)) xlab(-1(1)3) yscale(r(0 0.75)) ylab(0(0.25)0.75) lineopts(lp(solid) lc(red) lw(thik)) ytitle("") xtitle("Development index", size(3))
 lowess pslinter2 margA, name(DEC12) title("Pooled", size(3.5)) bw(.5) scheme(lean1) xscale(r(-1 3)) xlab(-1(1)3) yscale(r(0 0.75)) ylab(0(0.25)0.75) lineopts(lp(solid) lc(red) lw(thik)) ytitle("", size(3)) xtitle("Development index", size(3))
graph combine DEC9 DEC10 DEC11 DEC12, xsize(10) ysize(10) title("Service provision and district splits", size(4)) rows(2) col(2) scheme(lean1)

graph combine DEC1 DEC2 DEC3 DEC4 DEC9 DEC10 DEC11 DEC12 DEC5 DEC6 DEC7 DEC8, xsize(10) ysize(10) title("Marginalization and district splits", size(3.5)) rows(3) col(4) scheme(lean1)

***************************************************************************
* Table 5: Robustness check I 
***************************************************************************

* Use alternative measure of economic marginalization
eststo m6: xtlogit splinter DEC_rep ethdiff SERVICES $POLIT $SOCIO $CONT $REGIONS $WAVES if ncounties!=1, re
estat ic

* Use alternative measure of economic marginalization
eststo m7: xtlogit splinter DEC_rep ethdiff ECON $POLIT $SOCIO $CONT $REGIONS $WAVES if ncounties!=1, re
estat ic

* Use alternative measure of DEC share
eststo m8: xtlogit splinter county_dec_share ethdiff margA $POLIT $SOCIO $CONT $REGIONS $WAVES if ncounties!=1, re
estat ic

***************************************************************************
* * Robustness check II: demeaned regresssion 
***************************************************************************

* create mean of time varying variables over-time
foreach var in county_dec_share DEC_rep support_loser opposed ethdiff mshare_lag mshare_lag2 ncounties break_lag nosplit splinter mother{
	bys id: egen m`var'=mean(`var') 
	gen dmean_`var'=`var'-m`var'
	}

lab var mDEC_rep "DEC share /population share (within)"
lab var dmean_DEC_rep "DEC share /population share (between)"

lab var msupport_loser "Support LC5 chair loser (within)"
lab var dmean_support_loser "Support LC5 chair loser (between)"

lab var mopposed "LC5 Elections opposed (within)"
lab var dmean_opposed "LC5 Elections opposed (between)"

lab var methdiff "Ethnic marginalization (within)"
lab var dmean_ethdiff "Ethnic marginalization (between)"

lab var mmshare_lag "Museveni vote share past election (within)"
lab var dmean_mshare_lag "Museveni vote share past election (between)"

lab var mmshare_lag2 "Museveni vote share past election $^2$ (within)" 
lab var dmean_mshare_lag2 "Museveni vote share past election $^2$ (between)" 

lab var mncounties "N. counties in district (within)"
lab var dmean_ncounties "N. counties in district (between)"

lab var mbreak_lag "Breakup lag (within)"
lab var dmean_break_lag "Breakup lag (between)"

global mvars mDEC_rep msupport_loser mopposed methdiff mmshare_lag mmshare_lag2 mncounties mbreak_lag
global dvars dmean_DEC_rep dmean_support_loser dmean_opposed dmean_ethdiff dmean_mshare_lag dmean_mshare_lag2 dmean_ncounties dmean_break_lag

* de-meaned RE and FE models as in Bell and Jones (2012)		
	eststo m9: xtlogit splinter $dvars $mvars margA $REGIONS $WAVES i.wave if ncounties!=1, re
	estat ic
	
	eststo m10: xtlogit splinter $dvars $mvars margA $SOCIO $REGIONS $WAVES i.wave if ncounties!=1, re
	estat ic

#delimit;
	esttab m6 m7 m8 m9 m10, 
	replace b(2) se(2) aic(2) bic(2) nogaps page label booktabs width(\hsize) varlabels(_cons Intercept) 
   	transform(ln*: exp(@) exp(@)) nodepvars nonumbers star(* 0.1 ** 0.05 *** 0.01) scalar("ll Log Likelihood") 
   	title ("District Splits" "Robustness check");
#delimit cr
  
***************************************************************************
* Table 7: separate regression for each wave
***************************************************************************
* Model A: without socio-demographic covariates
eststo clear
	forvalues i=1(1)3{
	eststo a`i': xtmelogit splinter $MARGS $POLIT $SOCIO $CONT $REGIONS if ncounties!=1 &wave==`i'|| dist:,
	estat ic
	}

#delimit;
	esttab a1 a2 a3, 
	replace b(2) se(2) aic(2) bic(2) nogaps page label booktabs width(\hsize) varlabels(_cons Intercept) 
   	transform(ln*: exp(@) exp(@)) nodepvars nonumbers star(* 0.1 ** 0.05 *** 0.01) scalar("ll Log Likelihood") 
   	title ("District Splits" "and Local Politics") 
   	nonumbers mtitles("1996-2000" "2001-2005" "2006-2010");  
#delimit cr

*****************************************************************************
* Table 8: Musevenie vote share in county i in election j (first elections after splits)
*****************************************************************************

* reset panel variables
tsset id wave

* Model 0: no control  
eststo clear
	eststo re1: xtreg mshare_county i.split_cat i.wave, re   
	est store re1
	eststo fe1: xtreg mshare_county i.split_cat i.wave, fe
	est store fe1 
	hausman . re1, force

* Model A: add lag of the in independent variable
* Hausman test strongly supports the use of FEs
	 eststo re2: xtreg mshare_county i.split_cat l.i.split_cat i.wave, re   
	 est store re2
	 eststo fe2: xtreg mshare_county i.split_cat l.i.split_cat i.wave, fe
	 est store fe2
	 hausman . re2

* Model B: add dominant ethnicity dummies to REs specification
	 eststo re3: xtreg mshare_county i.split_cat l.i.split_cat i.dom_ethnic02 i.wave, re
	 est store re3

* Model C: use de-meaned speicifcation
 	eststo re4: xtreg mshare_county msplinter dmean_splinter mmother dmean_mother $REGIONS i.wave, re
 	est store re4 

* Model D: add dominant ethnicity dummies to demeaned REs specification
 	eststo re5: xtreg mshare_county msplinter dmean_splinter mmother dmean_mother i.dom_ethnic02 $REGIONS i.wave, re
 	est store re5

* Model E: dynamic model (xtabond) 
 	eststo d1: xtdpd L(0/1).mshare_county L(0/1).(splinter mother) period2 period3, div(L(0/1).(splinter mother)  period2 period3) dgmmiv(mshare_county, lag(1 .)) hascons
estat sargan

#delimit;  
	esttab fe1 fe2 re4 re5 d1, 
	replace b(%9.3f) se(%9.3f) keep(i.split_cat)
	nogaps page label booktabs width(\hsize) varlabels(_cons Intercept) 
    transform(ln*: exp(@) exp(@)) nodepvars nonumbers star scalar("ll Log Likelihood") 
    title ("Museveni Vote Share" "and District Creation")  
    nonumbers mtitles("(A)" "(B)" "(C)" "(D)" "(E)");  
#delimit cr
