version 10
clear
set memory 500m
set matsize 800
capture log close
*log using ${pap4log}regression_MNEexp_tables_rev09, text replace
capture program drop _all
set more off

***03.07.09****************************************
* Makes 3 tables for the plant level productivity 
* section of the paper

* This do file has been run 3 times (at least):
* a: regressions including: q k m h I* Y* iy* skillshare femshare lturnover lturm lpm cr5 lms5
* b: regressions including: q k m h I* Y* iy* 
* c: regressions including: q k m h Y* iy* 

* Results are more or less identical, also in terms of Rsq.
* Go for c.
********************************************************


* Generate more variables for regressions
	use ${pap4data}regpanel.dta, clear

* Merge the most basic variables for MNE experience onto regpanel
* Made in experience.do 15 may 2009 
* (this should replace most of the previous MNEexperience do-files)
	#delimit ;
	merge bnr aar using ${pap4data}new_workers.dta, 
		keep(N N_exp* N_new 
		tot_wage tot_erf tot_eduy tot_*_exp tot_*_expnonMNE turnover);
	#delimit cr
	keep if _merge==3
	drop _merge
	tsset bnr aar
	gen lturnover=L.turnover

* Use the tot number of new empl with MNE exp as 
* share of total # of emp. in the plant
	foreach t in N_exp N_expfor N_expdom N_expnonMNE N_expstor N_new N_exp4 N_exp4n N_exp3 N_exp_not3 {
		quietly gen s`t'=`t'/N
		assert s`t'!=.
	}
	
	gen isic3=int(isic5/100)
	quietly tab aar, gen(Y)
	*quietly tab isic3, gen(I)
	drop Y1
	gen isic2=int(isic3/10)
	egen x=group(isic3 aar)	
	qui tab x, gen(iy)
	drop iy1

	preserve
* Save panel of plants that are not always nonMNE for "placebo regresion": reverse spillovers
	keep if maxutl!=0
	sort bnr aar
	tempfile fortemp
	save fortemp.dta, replace

* Panel of plants that are always nonMNE
	restore
	tsset bnr aar
* Control variables for investment shocks
	gen dN=D.h
	gen invest=n_mask+n_bygg+n_transp
	gen linv=L.invest
	gen dms=D.lms5
	keep if maxutl==0

* Estimating sample
	quietly reg q k m h fp lms5 cr5 lpm lturb  
	gen s=1 if e(sample)
	keep if s==1
	drop s

* Keep only nonMNEs that at least once hire
* workers with MNEexp
	bys bnr: egen neverMNEexp=sum(N_exp)
	count if neverMNEexp==0
	gen MNEexpsample=1 if neverMNEexp!=0
	keep if MNEexpsample==1
	tempfile regtemp
	save regtemp.dta, replace

global basereg "q k m h Y* iy* "

qui  xtreg $basereg sN_exp sN_expnonMNE, fe cluster(bnr)
est store fe1
test sN_exp=sN_expnonMNE
nlcom delta:_b[sN_exp]/_b[h]
nlcom delta:_b[sN_expnonMNE]/_b[h]
nlcom delta:_b[sN_exp]/_b[h]-_b[sN_expnonMNE]/_b[h]


qui xtreg $basereg sN_expdom sN_expfor sN_expnonMNE, fe cluster(bnr)
est store fe2
nlcom delta:_b[sN_expdom]/_b[h]
nlcom delta:_b[sN_expfor]/_b[h]
test sN_expdom=sN_expfor 
* Footnote checks
qui xtreg $basereg sN_expfor sN_expnonMNE, fe cluster(bnr)
est store fn1
qui  xtreg $basereg sN_expdom sN_expnonMNE, fe cluster(bnr)
est store fn2
qui  xtreg $basereg sN_expnonMNE, fe cluster(bnr)
est store fn3
qui  xtreg $basereg sN_expstor, fe cluster(bnr)
est store fn4
qui xtreg $basereg sN_expfor , fe cluster(bnr)
est store fn5
qui  xtreg $basereg sN_expdom , fe cluster(bnr)
est store fn6
est table fn1 fn2 fn3 fn4 fn5 fn6, stats(N r2 r2_a) keep(sN_expnonMNE sN_expfor sN_expdom sN_expstor) b(%9.3f) star
estimates drop fn*


qui  xtreg $basereg sN_exp sN_expstor, fe cluster(bnr)
est store fe3
test sN_exp=sN_expstor
nlcom delta:_b[sN_exp]/_b[h]
nlcom delta:_b[sN_exp]/_b[h]-_b[sN_expstor]/_b[h]

* Endogeneity checks: control for employment and investment shocks, lagged values
* Footnote checks: employment or investment shocks
 * Lagged share of workers (more or less same results if lags are included separately or 
* together with contemporaneous shares)
	tsset bnr aar
	gen ls_exp=L.sN_exp
	gen ls_non=L.sN_expnonMNE 
qui xi: xtreg $basereg ls_exp ls_non , fe cluster(bnr)
est store fe_lag


qui  xtreg $basereg sN_exp sN_expnonMNE dN invest, fe cluster(bnr)
est store fe1c
qui  xtreg $basereg sN_exp sN_expnonMNE dN linv, fe cluster(bnr)
est store fe2c
qui  xtreg $basereg sN_exp sN_expnonMNE L.dN linv, fe cluster(bnr)
est store fe3c


* Placebo regression: experience from mne and nonMNEs in MNEs
	use fortemp.dta, clear
qui  xtreg $basereg sN_expnonMNE sN_exp, fe cluster(bnr)
est store for3
test sN_expnonMNE=sN_exp
nlcom delta:_b[sN_exp]/_b[h]



* Table results: first plant level productivity table
#delimit ;
est table fe1 fe2 fe3 fe_lag for3, stats(N r2 r2_a) 
	keep(sN_exp sN_expfor sN_expdom sN_expnonMNE sN_expstor ls_exp ls_non k m h) b(%9.3f) star;
#delimit cr
est table fe1c fe2c fe3c, stats(N r2 r2_a) keep(dN invest linv L.dN sN_expnonMNE sN_exp) b(%9.3f) star

	estout fe1 fe2 fe3 fe1c fe_lag for3 using ${pap4tab}spillovers_main_rev09_3.tex, replace style(tex) ///
 	keep(sN_exp sN_expfor sN_expdom sN_expnonMNE sN_expstor ls_exp ls_non k m h) ///
	stats(N r2_a, fmt(%9.0g %4.2f) labels(N R$^2$)) /// 
	cells(b(fmt(%4.3f)) se(par star fmt(%4.3f))) ///
	starlevels ($^{(\ast)}$ .1 $^{\ast}$ .05 $^{\ast\ast}$ .01 ) /// 
 	mlabels( , none) label nolz collabels(, none) ///
 	varlabels(sN_exp "MNEs" sN_expfor "Foreign MNEs" sN_expdom "Domestic MNEs" ///
	sN_expnonMNE "Non-MNEs" sN_expstor "Large non-MNEs" ls_exp "lagMNE" ls_non "lag non" ///
	k "Log(Capital)" m "Log(Materials)" h "Log(hours)") ///
	title("Share of workers with MNE-experience and plant level productivity") 

	estimates drop _all
**********
*Repeat, with plant level vars and industry concetration/competition variables
* Results are more or less the same (version _1 of all saved .tex tables)
**********


************
* Appendix table with different productivity measures
************
* Impose CRS when estimating the cobb douglas prodution function
	use regtemp.dta, clear
	gen q1=q-k
	gen m1=m-k
	gen h1=h-k
	global baseregcrs "q1 m1 h1 Y* iy* "
qui xtreg $baseregcrs sN_exp sN_expnonMNE if MNEexpsample==1, fe cluster(bnr)
est store fe_crs

* 3 digit input coefficients
drop if isic3==354 | isic3==361
#delimit ;
foreach t in  311 312 313 314 321 322 323 324 331 332 341 342 351 
	352 355 356 362 369 371 372 381 382 383 384 385 390 {; 
	quietly gen I`t'=1 if isic3==`t';
	quietly replace I`t'=0 if I`t'==.;
	foreach x in h k m {;
	quietly gen `x'i`t'=`x'*I`t';
	};
	drop I`t';
};

#delimit cr

global basereg6 "q ki* mi* hi* Y*  iy*  "
quietly xtreg $basereg6 sN_exp sN_expnonMNE if MNEexpsample==1, fe cluster(bnr)
est store fe_3digit 
#delimit ;
foreach t in  311 312 313 314 321 322 323 324 331 332 341 342 351 
	352 355 356 362 369 371 372 381 382 383 384 385 390 {; 
		display " ****SECTOR `t'**********";
	nlcom delta:_b[sN_exp]/_b[hi`t']-_b[sN_expnonMNE]/_b[hi`t']	;
};
#delimit cr

* Various types of TFP indexes: selected based on checks in _4.do
	use regtemp.dta, clear
	sort bnr aar
	* Merge in tfp measures made in productivitymeasures.do
	merge bnr aar using ${pap4data}productivity.dta, keep(qhati_1 lntfp lntfp1)
	tab _merge
	keep if _merge==3
	drop _merge
global tfpreg "Y* iy* "
	gen levpet=log(qhati_1)
foreach t in levpet lntfp LP {
qui xtreg `t' $tfpreg  sN_expnonMNE sN_exp, fe cluster(bnr)
est store tab`t'
test sN_expnonMNE=sN_exp
}
est table fe_crs fe_3digit tablevpet tablntfp tabLP, stats(N r2 r2_a) keep(sN_expnonMNE sN_exp) b(%9.3f) star

	estout fe_crs fe_3digit tablevpet tablntfp tabLP using ${pap4tab}spillovers_tfpalt_rev09.tex, replace style(tex) ///
 	keep(sN_exp sN_expnonMNE) ///
	stats(N r2_a, fmt(%9.0g %4.2f) labels(N R$^2$)) /// 
	cells(b(fmt(%4.3f)) se(par star fmt(%4.3f))) ///
	starlevels ($^{(\ast)}$ .1 $^{\ast}$ .05 $^{\ast\ast}$ .01 ) /// 
 	mlabels( , none) label nolz collabels(, none) ///
 	varlabels(sN_exp "MNEs" sN_expnonMNE "Non-MNEs") ///
	title("Results: Different productivity measures") 

est drop _all

* Footnote checks: 
* Each 2 digit sector separately
	foreach t in 31 32 33 34 35 36 37 38 39 {
	use regtemp.dta, clear
	keep if isic2==`t'
di "********Sector is now `t'**************"	
qui xi: xtreg $basereg sN_expnonMNE sN_exp, fe cluster(bnr)
est store fe1
nlcom delta:_b[sN_exp]/_b[h]
nlcom delta:_b[sN_expnonMNE]/_b[h]
nlcom delta:_b[sN_exp]/_b[h]-_b[sN_expnonMNE]/_b[h]

est table fe1, stats(N r2) keep(k m h sN_expnonMNE sN_exp) b(%9.2f) star(0.1 0.05 0.01)
}

* dropping 2 digit sectors 1 by one
	foreach t in 31 32 33 34 35 36 37 38 39 {
	use regtemp.dta, clear
	drop if isic2==`t'
di "********Sector dropped is  `t'**************"	
qui xi: xtreg $basereg sN_expnonMNE sN_exp, fe cluster(bnr)
est store fe1
nlcom delta:_b[sN_exp]/_b[h]
nlcom delta:_b[sN_expnonMNE]/_b[h]
nlcom delta:_b[sN_exp]/_b[h]-_b[sN_expnonMNE]/_b[h]
est table fe1, stats(N r2) keep(k m h sN_expnonMNE sN_exp) b(%9.2f) star(0.1 0.05 0.01)
}

****************************************
* Table with controls for human capital
***************************************

* Altenative control for human capital: generate shares of employment by education group
* Pick 2 groups, but 4 groups gives the same results.
	set more off
	use regtemp.dta, clear	
	sort bnr aar
	#delimit ;
	merge bnr aar using ${pap4data}new_workers.dta, 
		keep(N9 N10 N11 N12 N15 N16  N*_exp N*_expnonMNE);
	#delimit cr
	keep if _merge==3
	drop _merge
	gen Nlav=N9+N10+N11+N12
	gen Nh=N15+N16
	gen Nlav_exp=N9_exp+N10_exp+N11_exp+N12_exp
	gen Nh_exp=N15_exp+N16_exp
	gen Nlav_expnonMNE=N9_expnonMNE+N10_expnonMNE+N11_expnonMNE+N12_expnonMNE
	gen Nh_expnonMNE=N15_expnonMNE+N16_expnonMNE
	drop N1* N9 N9*
	foreach t in Nlav Nh {
		gen s`t'=`t'/N
		replace s`t'=0 if s`t'==.
		gen h`t'=h*s`t'
	}
	foreach t in Nlav Nh {
		foreach x in exp expnonMNE {
		gen s`t'_`x'=`t'_`x'/N
		replace s`t'_`x'=0 if s`t'_`x'==.
	}
	}

* Merge in info on mean individual fixed effects per plant 
* of new workers with/out MNEexp from data
* made in experience3.do
	sort bnr aar
	merge bnr aar using ${pap4data}new_workers_meanfe.dta, keep(mpers mnepers nonpers forpers dompers feutv1 feutv2) 
	tab _merge
	drop if _merge==2
	gen fesample=1 if _merge==3
	drop _merge
	sort bnr aar

*global edgroup4 "q k m hN0 hN1 hN2 hN3 Y* iy* skillshare femshare lturnover lms5 cr5  lpm lturb"
global edgrouphl "q k m hNlav hNh Y* iy* "


rename sNlav_exp MNE
rename sNlav_expnonMNE nonMNE 
qui xtreg $edgrouphl MNE sNh_exp sNh_expnonMNE nonMNE if MNEexpsample==1, fe cluster(bnr)
est store tab1


* Control for the average level of education of the two
* groups of new workers: ie multiply totalhours by average 
* education in the plant
	gen Hed=Li_h*ed
	gen s_ed_exp=(Li_h*(N_exp/N)*(tot_eduy_exp/N_exp))/Hed
	replace s_ed_exp=0 if s_ed_exp==.
	gen h_ed=log(Hed)
	gen s_ed_non=(Li_h*(N_expnonMNE/N)*(tot_eduy_expnonMNE/N_expnonMNE))/Hed
	replace s_ed_non=0 if s_ed_non==.

global edreg "q k m h_ed Y* iy* "
drop MNE nonMNE
rename s_ed_exp MNE
rename s_ed_non nonMNE

qui xtreg $edreg MNE nonMNE if MNEexpsample==1, fe cluster(bnr)
est store tab2
nlcom delta:_b[MNE]/_b[h_ed]
nlcom delta:_b[nonMNE]/_b[h_ed]
nlcom delta:_b[MNE]/_b[h_ed]-_b[nonMNE]/_b[h_ed]
 
* Adjust for experience in the two groups
	gen Herf=Li_h*er
	gen s_erf_exp=(Li_h*(N_exp/N)*(tot_erf_exp/N_exp))/Herf
	replace s_erf_exp=0 if s_erf_exp==.
	gen h_erf=log(Herf)
	gen s_erf_non=(Li_h*(N_expnonMNE/N)*(tot_erf_expnonMNE/N_expnonMNE))/Herf
	replace s_erf_non=0 if s_erf_non==.
global erfreg "q k m h_erf Y* iy* "
drop MNE nonMNE 
rename s_erf_exp MNE
rename s_erf_non nonMNE
qui xtreg $erfreg MNE nonMNE if MNEexpsample==1, fe cluster(bnr)
est store tab3
nlcom delta:_b[MNE]/_b[h_erf]
nlcom delta:_b[nonMNE]/_b[h_erf]
nlcom delta:_b[MNE]/_b[h_erf]-_b[nonMNE]/_b[h_erf]

 
* Adjusting for wages in the two groups: footnote comment
	gen Hw=Li_h*(tot_wage/N)
	gen s_w_exp=(Li_h*(N_exp/N)*(tot_wage_exp/N_exp))/Hw
	replace s_w_exp=0 if s_w_exp==.
	gen h_w=log(Hw)
	gen s_w_non=(Li_h*(N_expnonMNE/N)*(tot_wage_expnonMNE/N_expnonMNE))/Hw
	replace s_w_non=0 if s_w_non==.
	*gen s_w_for=(Li_h*(N_expfor/N)*(tot_wage_expfor/N_expfor))/Hw
	*replace s_w_for=0 if s_w_for==.
	*gen s_w_dom=(Li_h*(N_expdom/N)*(tot_wage_expdom/N_expdom))/Hw
	*replace s_w_dom=0 if s_w_dom==.

global wreg "q k m h_w Y* iy* "
drop MNE nonMNE 
rename s_w_exp MNE
rename s_w_non nonMNE
qui xtreg $wreg MNE nonMNE if MNEexpsample==1, fe cluster(bnr)
est store fe6
est table fe6, stats(N r2 r2_a) keep(k m h_w MNE nonMNE ) b(%9.3f) star

* Adjust for mean of unobserveables in total and in the two groups
* Keep only plants with a sufficient number of matches of persons where I have estimated
* individual fixed effects. (Should repeat the above on the same sample)
	foreach t in pers  {
	gen H`t'=Li_h*m`t'
	gen s_`t'_exp=(Li_h*(N_exp/N)*mne`t')/H`t'
	replace s_`t'_exp=0 if s_`t'_exp==.
	gen s_`t'_for=(Li_h*(N_expfor/N)*for`t')/H`t'
	replace s_`t'_for=0 if s_`t'_for==.
	gen s_`t'_dom=(Li_h*(N_expdom/N)*dom`t')/H`t'
	replace s_`t'_dom=0 if s_`t'_dom==.
	gen h_`t'=log(H`t')
	gen s_`t'_non=(Li_h*(N_expnonMNE/N)*non`t')/H`t'
	replace s_`t'_non=0 if s_`t'_non==.
	}
global persreg "q k m h_pers Y* iy* "

drop if N_exp>0 & s_pers_exp==0 & feutv1==1
drop MNE nonMNE 
rename s_pers_exp MNE
rename s_pers_non nonMNE
qui xtreg $persreg MNE nonMNE if feutv1==1 & MNEexpsample==1, fe cluster(bnr)
est store tab4
nlcom delta:_b[MNE]/_b[h_pers]
nlcom delta:_b[nonMNE]/_b[h_pers]
nlcom delta:_b[MNE]/_b[h_pers]-_b[nonMNE]/_b[h_pers]

est table tab1 tab2 tab3 tab4 , stats(N r2 r2_a) ///
	keep(MNE sNh_exp nonMNE sNh_expnonMNE h_ed h_erf h_pers hNlav hNh) b(%9.3f) star

	estout tab1 tab2 tab3 tab4 using ${pap4tab}spillovers_hc_control_3.tex, replace style(tex) ///
 	keep(MNE sNh_exp nonMNE sNh_expnonMNE) ///
	stats(N r2_a, fmt(%9.0g %4.2f) labels(N R$^2$)) /// 
	cells(b(fmt(%4.3f)) se(par star fmt(%4.3f))) ///
	starlevels ($^{\ast}$ .1 $^{\ast\ast}$ .05 $^{\ast\ast\ast}$ .01 ) /// 
 	mlabels( , none) label nolz collabels(, none) ///
 	title("Observed and unobserved human capital") 

estimates drop _all
***************
* 3.
**** Robustness check table based on col 1
* in table spillovers_main_rev09.tex: with MNEexpsample==1
********************

* Annual measures of MNEexperience, split by high and low tenure 
* - split at around median tenure for movers
* Footnote comment
	set more off
	use regtemp.dta, clear
	drop N_* tot_* sN*
	sort bnr aar
	merge bnr aar using ${pap4data}new_workers_annual.dta, keep(N_new*) 
	keep if _merge==3
	drop _merge
	foreach t in N_new_mnelow N_new_mnehigh N_new_nonlow N_new_nonhigh N_new_mne N_new_non {
		quietly gen s`t'=`t'/N
		assert s`t'!=.
	}
foreach t in mnelow mnehigh nonlow nonhigh {
rename sN_new_`t' `t'
}
qui  xtreg $basereg mnelow mnehigh nonlow nonhigh, fe cluster(bnr)
est store lowhigh
est table lowhigh, stats(N r2 r2_a) keep(mnelow mnehigh nonlow nonhigh) b(%9.3f) star

* footnote check: control for investment shocs with annual measures
tsset bnr aar
qui  xtreg $basereg sN_new_mne sN_new_non , fe cluster(bnr)
est store fn1
qui  xtreg $basereg L.sN_new_mne L.sN_new_non , fe cluster(bnr)
est store fn2
qui  xtreg $basereg sN_new_mne sN_new_non  invest dN, fe cluster(bnr)
est store fn3
qui  xtreg $basereg L.sN_new_mne L.sN_new_non linv L.dN, fe cluster(bnr)
est store fn4
est table fn1 fn2 fn3 fn4, stats(N r2 r2_a) keep(sN_new_mne sN_new_non invest dN L.sN_new_mne L.sN_new_non linv L.dN) b(%9.3f) star


* From same sector or not, 

use regtemp.dta, clear
sort bnr aar
merge bnr aar using ${pap4data}new_workers.dta, keep(N_exp4n N_exp3 N_exp_not3 N)
gen s_exp4=N_exp4n/N
gen s_i3=N_exp3/N
gen s_n3=N_exp_not3/N
foreach t in exp4 i3 n3 {
	replace s_`t'=0 if s_`t'==.
}
qui xtreg $basereg s_i3 s_n3 sN_expnonMNE, fe cluster(bnr)
est store same3d

* recent or not so recent MNEexp
keep if aar>1994
qui xtreg $basereg sN_exp s_exp4 sN_expnonMNE, fe cluster(bnr)
est store mneoldnew
est table lowhigh same3d mneoldnew, ///
	stats(N r2 r2_a) keep(sN_exp sN_expnonMNE mnelow mnehigh nonlow nonhigh s_i3 s_n3 s_exp4) ///
	 b(%9.3f) star

	estout lowhigh same3d  using ${pap4tab}spillovers_rob_3.tex, replace style(tex) ///
 	keep(sN_exp sN_expnonMNE ls_exp ls_non mnelow mnehigh nonlow nonhigh s_i3 s_n3) ///
	stats(N r2_a, fmt(%9.0g %4.2f) labels(N R$^2$)) /// 
	cells(b(fmt(%4.3f)) se(par star fmt(%4.3f))) ///
	starlevels ($^{\ast}$ .1 $^{\ast\ast}$ .05 $^{\ast\ast\ast}$ .01 ) /// 
 	mlabels( , none) label nolz collabels(, none) ///
	varlabels(sN_exp "MNEs" sN_expnonMNE "non-MNEs" ls_exp "MNEs lagged" ls_non "non-MNEs lagged"  /// 
	mnelow "MNEs short tenure" mnehigh "MNEs long tenure" ///
	nonlow "non-MNEs short tenure" nonhigh "non_MNEs long tenure" /// 
	s_i3 "MNEs same sect" s_n3 "MNEs diff sect" ) ///
 	title("Robustness: estimated coefficient on share of workers with MNE experience") 



erase regtemp.dta
erase fortemp.dta
log close
exit



