version 10
clear
capture program drop _all
set memory 350m
capture log close
set more off
log using ${pap4log}productivitymeasures, text replace

***07.06.2009**RBal***********************************
* Generate productivity measures, as in
* Arnold and Javorcik : both at 2 and 3 digit level
* Merge in levpet resuduals from lemons and cherries
* paper as well.

* Use the panel from the lemons and cherries
* paper. This is the plant panel used in the 
* plant level regressions of mobilitypaper as well 
* (merged in in regression_prepare_rev09.do)
******************************************************

	use ${industri}empdecomppanel1_update.dta, clear
	drop if aar<1990
	drop if aar>2000
	quietly gen isic2=int(naering/1000)

	keep aar bnr isic2 isic3 k1 k2 k3 wagecost rentcost Qidef Midef Li_e Li_h
	gen Lidef=wagecost+rentcost
* Information on the 3 different capital measures
	des k1 k2 k3
	pwcorr k1 k2 k3, star(1)
	* Mean of different cap measures by year
	table aar, c(m k1 m k2 m k3)
	* Median of different cap measures by year
	table aar, c(med k1 med k2 med k3)
	* # of obs of different cap measures by year
	table aar, c(n k1 n k2 n k3)

	sort bnr aar
	merge bnr aar using ${pap4data}new_workers.dta, keep(N N0 N1 N2 N3)
	keep if _merge==3
	drop _merge
* Generate factor elasticities=average cost shares per plant/year obs
	foreach t in Lidef Midef k1 k2 k3 {
		quietly gen s`t'=`t'/Qidef
	}
* Cost share if labour is split by education
	foreach t in 0 1 2 3 {
		gen s`t'=(N`t'/N)*(Lidef/Qidef)
		replace s`t'=0 if s`t'==.
	}
	tempfile temp0
	save temp0.dta, replace

program define productivity	
* Average cost shares per sector/year
	foreach t in Lidef Midef k1 k2 k3 {
	bys aar isic3: egen x`t'=mean(s`t') if s`t'>0.01 & s`t'<0.95
	bys aar isic3: egen ms`t'=mean(x`t')
	drop x`t'
	}
	foreach t in 0 1 2 3 {
	bys aar isic3: egen ms`t'=mean(s`t')
	}

* Mean output and input use per sector/year, in logs
	foreach t in Li_h Li_e Midef Qidef k1 k2 k3 {
		* plant log
		gen log`t'=log(`t')
		* mean sector log
		bys aar isic3: egen m`t'=mean(log`t')	
	}
	foreach t in 0 1 2 3 {
		*plant log share for education group
		gen log`t'=logLi_h*s`t'
		bys aar isic3: egen m`t'=mean(log`t') 
	}

	sort isic3 aar
	tempfile temp1
	save temp1.dta, replace

* Collpase to generate 3 digit sector variables for TFP calculation
	keep aar isic3 ms* mL* mM* mQ* mk* m0 m1 m2 m3
	collapse msLidef msMidef msk1 msk2 msk3 ms0 ms1 ms2 ms3 mLi_h mLi_e mMidef mQidef mk1 mk2 mk3 m0 m1 m2 m3, by(aar isic3)
	sort isic3 aar
	tsset isic3 aar
	foreach t in mLi_h mLi_e mMidef mQidef mk1 mk2 mk3 m0 m1 m2 m3 {
		gen D`t'=D.`t'
	}
	foreach t in msLidef msMidef msk1 msk2 msk3 ms0 ms1 ms2 ms3 {
		gen S`t'=(`t'+L.`t')/2
	}
	gen ledd4_Lh=SmsLidef*DmLi_h
	gen ledd4_Le=SmsLidef*DmLi_e
	gen ledd4_M=SmsMidef*DmMidef
	gen ledd4_k1=Smsk1*Dmk1
	gen ledd4_k2=Smsk2*Dmk2
	gen ledd4_k3=Smsk3*Dmk3
	foreach t in 0 1 2 3 {
		gen ledd4_`t'=Sms`t'*Dm`t'
	}
	assert ledd4_k1==. if aar==1990
	tsset isic3 aar

	foreach t in Lh Le M k1 k2 k3 0 1 2 3 {
		bys isic3: gen x4_`t'=sum(ledd4_`t')
	}
		bys isic3: gen x2_q=sum(DmQidef)

	keep x2_q x4_* mQidef mk1 mk2 mk3 mMidef mLi_h mLi_e  m0 m1 m2 m3 ms* aar isic3
	sort isic3 aar
	tempfile temp2
	save temp2.dta, replace

	use temp1.dta, clear
	merge isic3 aar using temp2.dta
	assert _merge==3
	drop _merge

* Generate TFP measure from Javorcik and Arnold
* It has 4 parts, called here x1-x4, with appropriate subscripts
* depending on the input used

	* Output (log) and input at plant level
	gen q=log(Qidef)
	gen m=log(Midef)
	gen h=log(Li_h)
	gen e=log(Li_e)
	gen k_1=log(k1)
	gen k_2=log(k2)
	gen k_3=log(k3)



* Part 1: plant level output and deviation from sector mean, year t
	gen x1_q=q-mQidef
* Part 2: made above: x2_q
* Part 3: average of plant and industry costshare multiplied by
* deviation from average industry input use
		gen x3_h=((sLidef+msLidef)/2)*(h-mLi_h)
		gen x3_e=((sLidef+msLidef)/2)*(e-mLi_e)
		gen x3_m=((sMidef+msMidef)/2)*(m-mMidef)
		gen x3_k1=((sk1+msk1)/2)*(k_1-mk1)
		gen x3_k2=((sk2+msk2)/2)*(k_2-mk2)
		gen x3_k3=((sk3+msk3)/2)*(k_3-mk3)
* Part 3 if labour is to be split by education
	foreach t in 0 1 2 3 {
		gen x3_h`t'=((sLidef+msLidef)/2)*(log`t'-m`t')
	}
		
* Part 4 made above
* Since all parts of the measures above that are sectoral averages are calculated at the 3 digit level
* do not need to use a loop where I keep each 3d sector separately.

* Productivity measures
gen lntfp=x1_q+ x2_q -x3_h- x4_Lh- x3_m-x4_M - x3_k1- x4_k1
gen lntfp1=x1_q+ x2_q -x3_e- x4_Le- x3_m-x4_M - x3_k1- x4_k1
gen lntfp2=x1_q+ x2_q -x3_h- x4_Lh- x3_m-x4_M - x3_k2- x4_k2
gen lntfp3=x1_q+ x2_q -x3_h- x4_Lh- x3_m-x4_M - x3_k3- x4_k3

* Productivity based on hours if labour is split by education, 
gen lntfp_ed1=x1_q+ x2_q -x3_h0- x4_0 -x3_h1- x4_1 -x3_h2- x4_2 -x3_h3- x4_3 - x3_m-x4_M - x3_k1- x4_k1
gen lntfp_ed3=x1_q+ x2_q -x3_h0- x4_0 -x3_h1- x4_1 -x3_h2- x4_2 -x3_h3- x4_3 - x3_m-x4_M - x3_k3- x4_k3


keep aar bnr lntf*
end

productivity 

sort bnr aar
merge bnr aar using ${industri}tfp_lp_i2_empdecomp_update.dta
tab _merge
keep if _merge==3
drop _merge
sort bnr aar
save ${pap4data}productivity.dta, replace


* Make productivity measures for each 2 digit sector
use temp0.dta, clear
drop isic3 
rename isic2 isic3
productivity
foreach t in lntfp lntfp1 lntfp2 lntfp3 lntfp_ed1 lntfp_ed3 {
	rename `t' `t'_i2
}
sort bnr aar
merge bnr aar using ${pap4data}productivity.dta
tab _merge
keep if _merge==3
drop _merge
sort bnr aar
save ${pap4data}productivity.dta, replace


erase temp0.dta
erase temp1.dta
erase temp2.dta

capture log close
exit
