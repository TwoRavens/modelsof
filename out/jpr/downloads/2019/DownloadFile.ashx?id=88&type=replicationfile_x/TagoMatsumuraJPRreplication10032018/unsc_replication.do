*** DO-FILE TO REPLICATE RESULTS FROM JPR ARTICLE "Negative Surprise in the UN Security Council Authorization"

* Set command directory to where replication files locate

***** DATA CLEANING: WAVE 1 EXPERIMENT 

set more off 
use "UNSC_Survey_2014Sept4-10.dta", replace

drop q04_* q07_*

recode q01 (1=4)(2=3)(3=2)(4=1)   /* Recode Q1 and Q3 to 1 = Do not support, 2 = Do not really support, 3 = Somehow support, 4 = Support */ 
recode q03 (1=4)(2=3)(3=2)(4=1)
label var q01 "DV (US use of force): do not suport (1) ~ suport (4)" 
label var q03 "DV2 (JSDF Deployment) : do not suport (1) ~ suport (4)" 

label var q02_1 "mechanim of support: Illegality "
label var q02_2 "mechanim of support: Cost"
label var q02_3 "mechanim of support: Contribution to Public Goods"
label var q02_4 "mechanim of support: Duration"
label var q02_5 "mechanim of support: Casualty"
label var q02_6 "mechanim of support: Low-Legitimacy"
label var q02_7 "mechanim of support: Contribution to US Interest"
label var q02_8 "mechanim of support: Diplimatic Solution"
label var q02_9 "mechanim of support: Possibility of Failure"

label var q05 "interest in IR" 
label var q06 "use of force preference" 
gen uof_categ  = q06
label var uof_categ "1: favor, 2: somewhat favor, 3: somewhat unfavor, 4: unfavor"
gen uof_categ2=1 if q06==1 | q06==2 
replace uof_categ2=2 if q06==3 | q06==4
replace uof_categ2=3 if q06==.
label var uof_categ2 "1: favor, 2: unfavor, 3: unknown"
tab uof_categ2 uof_categ

label var q08 "birth year" 
label var q09 "gender" 
recode q09(2=0)
gen age = 2014-q08
label var q10 "education"
label var q11 "income"

gen support_dum=1 if q01==3 |q01==4
replace support_dum=0 if q01==1 |q01==2
label var support_dum "q01's dummy"
tab support_dum q01

gen support_dum2=1 if q03==3 |q03==4
replace support_dum2=0 if q03==1 |q03==2
label var support_dum2 "q03's dummy"
tab support_dum2 q03

label var pat "treatment groups"
gen tmt_s = 1 if pat==1
recode tmt_s(.=0) 
gen tmt_rv = 1 if pat==2
recode tmt_rv(.=0)
gen tmt_cv = 1 if pat==3
recode tmt_cv(.=0)
gen tmt_fv = 1 if pat==4
recode tmt_fv(.=0)
gen tmt_ukv = 1 if pat==5
recode tmt_ukv(.=0)
gen tmt_usw = 1 if pat==6
recode tmt_usw(.=0)
sum tmt_*

save "UNSC_Wave1.dta", replace



***** DATA CLEANING: WAVE 2 EXPERIMENT 

set more off 
use "UNSC_Survey_2018Jan10-11.dta", clear 
drop responseid responseset name externaldatareference emailaddress ipaddress status ethics
drop var*  q05full1 q05ps1 q05fv1 q05usw1 q06ps1 q06fv1  open
drop if finished==.   /* Drop unfinished respondents (155 obs) */
drop if finished==0 & check==.
 
gen double start = clock(startdate, "YMDhm")
format %tc start
gen double end = clock(enddate, "YMDhm")
format %tc end

gen time = end-start
format %tC time 
gen minute = mm(time)
sum minute

codebook q05* q07*  /* Fix errors */ 
recode q05usw (4=2)(5=3)(6=4)(7=5)(8=6)
recode q07full (3=2)(4=3)(5=4)(6=5)(7=6)
recode q07ps (3=2)(4=3)(5=4)(6=5)(7=6)
recode check (7=3)(3=4)(4=5)(5=6) 

gen q05= .   /* Recode Q5 and Q7(JSDF) to 1 = Do not support, 2 = Do not really support, 3 = Somehow support, 4 = Support */ 
replace q05=q05full if q05==.
replace q05=q05ps if q05==.
replace q05=q05fv if q05==.
replace q05=q05usw if q05==.
gen q07= .
replace q07= q07full if q07==.
replace q07= q07ps if q07==.
replace q07= q07fv if q07==.
replace q07= q07usw if q07==.

recode q05 (1=4)(2=3)(3=2)(4=1) (5=.) (6=.)
recode q07 (1=4)(2=3)(3=2)(4=1) (5=.) (6=.)
label var q05 "DV (US use of force): do not suport (1) ~ suport (4)" 
label var q07 "DV2 (JSDF Deployment) : do not suport (1) ~ suport (4)" 

label var q01_j "trust in Japanese Gov."
label var q01_us "trust in US Gov." 
label var q01_uk "trust in UK Gov."
label var q01_fr "trust in French Gov."
label var q01_ru "trust in Russian Gov."
label var q01_cn "trust in Chinese Gov."
label var q01_un "trust in UN."
recode q01_*(1=4)(2=3)(3=2)(4=1)(5=.)(6=.)

label var q02 "interest in IR"
recode q02(1=4)(2=3)(3=2)(4=1)(5=.)(6=.)

label var q03 "use of force preference" 
recode q03 (5=.)(6=.)
gen uof_categ  = q03
label var uof_categ "1: favor, 2: somewhat favor, 3: somewhat unfavor, 4: unfavor"
gen uof_categ2=1 if q03==1 | q03==2 
replace uof_categ2=2 if q03==3 | q03==4
replace uof_categ2=3 if q03==.
label var uof_categ2 "1: favor, 2: unfavor, 3: unknown"
tab uof_categ2 uof_categ

generate age = .
replace age = 75-byear
replace gender =0 if gender==2
replace gender =. if gender==5

gen support_dum=1 if q05==3 |q05==4
replace support_dum=0 if q05==1 |q05==2
label var support_dum "q05's dummy"
tab support_dum q05

gen support_dum2=1 if q07==3 |q07==4
replace support_dum2=0 if q07==1 |q07==2
label var support_dum2 "q07's dummy"
tab support_dum2 q07

gen pat=. 
replace pat=1 if q05full~=.
replace pat=2 if q05ps~=.
replace pat=3 if q05fv~=.
replace pat=4 if q05usw~=.
label var pat "treatment groups"

gen tmt_full = 1 if pat==1
recode tmt_full(.=0) 
gen tmt_ps = 1 if pat==2
recode tmt_ps(.=0)
gen tmt_fv = 1 if pat==3
recode tmt_fv(.=0)
gen tmt_usw = 1 if pat==4
recode tmt_usw(.=0)
sum tmt_*

gen reason1 = .
replace reason1 = q06full01 if q06full01~=.
replace reason1 = q06ps01 if q06ps01~=.
replace reason1 = q06fv01 if q06fv01~=.
replace reason1 = q06usw01 if q06usw01~=.
gen reason2 = .
replace reason2 = q06full02 if q06full02~=.
replace reason2 = q06ps02 if q06ps02~=.
replace reason2 = q06fv02 if q06fv02~=.
replace reason2 = q06usw02 if q06usw02~=.
gen reason3 = .
replace reason3 = q06full03 if q06full03~=.
replace reason3 = q06ps03 if q06ps03~=.
replace reason3 = q06fv03 if q06fv03~=.
replace reason3 = q06usw03 if q06usw03~=.
gen reason4 = .
replace reason4 = q06full04 if q06full04~=.
replace reason4 = q06ps04 if q06ps04~=.
replace reason4 = q06fv04 if q06fv04~=.
replace reason4 = q06usw04 if q06usw04~=.
gen reason5 = .
replace reason5 = q06full05 if q06full05~=.
replace reason5 = q06ps05 if q06ps05~=.
replace reason5 = q06fv05 if q06fv05~=.
replace reason5 = q06usw05 if q06usw05~=.
gen reason6 = .
replace reason6 = q06full06 if q06full06~=.
replace reason6 = q06ps06 if q06ps06~=.
replace reason6 = q06fv06 if q06fv06~=.
replace reason6 = q06usw06 if q06usw06~=.
gen reason7 = .
replace reason7 = q06full07 if q06full07~=.
replace reason7 = q06ps07 if q06ps07~=.
replace reason7 = q06fv07 if q06fv07~=.
replace reason7 = q06usw07 if q06usw07~=.
gen reason8 = .
replace reason8 = q06full08 if q06full08~=.
replace reason8 = q06ps08 if q06ps08~=.
replace reason8 = q06fv08 if q06fv08~=.
replace reason8 = q06usw08 if q06usw08~=.
gen reason9 = .
replace reason9 = q06full09 if q06full09~=.
replace reason9 = q06ps09 if q06ps09~=.
replace reason9 = q06fv09 if q06fv09~=.
replace reason9 = q06usw09 if q06usw09~=.
label var reason1 "mechanim of support: Illegality "
label var reason2 "mechanim of support: Cost"
label var reason3 "mechanim of support: Contribution to Public Goods"
label var reason4 "mechanim of support: Duration"
label var reason5 "mechanim of support: Casualty"
label var reason6 "mechanim of support: Low-Legitimacy"
label var reason7 "mechanim of support: Contribution to US Interest"
label var reason8 "mechanim of support: Diplimatic Solution"
label var reason9 "mechanim of support: Possibility of Failure"

save "UNSC_Wave2.dta", replace


***** ANALSYS 

* TABLE IIa: Sample Size and Mean Value of Key Variables (Wave 1) 
use "UNSC_Wave1.dta", clear
tab pat
sort pat 
by pat: sum q05 q06 age q09 q10 q11

drop if duration_q01exp<25  /* drop respondents by the below 25 seconds answer time for the first page */
tab pat

* TABLE IIb: Sample Size and Mean Value of Key Variables (Wave 2) 
use "UNSC_Wave2.dta", clear
tab pat
sort pat
by pat: sum q02 q03 age gender education income

drop if minute <2  /* drop respondents who completed the survey in less than 1 minute */
tab pat



* FIGURE I: Wave 1: September 2014 
use "UNSC_Wave1.dta", clear
drop if duration_q01exp<25

* Support Rate for US Use of Force
gen mean1 =.
gen std =.
gen n =.
	
forvalues i=1(1)6 {
	sum support_dum if pat==`i'  
	replace mean1 = r(mean) if pat==`i' 
    replace std = r(sd) if pat==`i' 
    replace n = r(N) if pat==`i' 
	}
gen upper=mean1+1.96*std/sqrt(n)
gen lower=mean1-1.96*std/sqrt(n)
replace mean1=round(mean1, .01)

twoway (rcap lower upper pat) (scatter mean1 pat, mc(gs2) ms(0) mlabel(mean1)), xlab(1 "S" 2 "RV" 3 "CV" 4 "FV" 5 "UKV" 6 "USW") ///
b1title("") xtitle("") title("Support rate for US use of force")  legend(off) note("Note: Bars indicate 95% confidence intervals.") ///
ylab(0.1 (0.1) 0.8) xscale(range(0.8 6.2)) ytitle("%") graphregion(color(white))   scheme(sj)
graph save F1L.gph, replace 
graph export F1L.tif, replace

* Support Rate for SDF Deployment
gen mean2 =.
gen std2 =.
gen n2 =.
	
forvalues i=1(1)6 {
	sum support_dum2 if pat==`i'  
	replace mean2 = r(mean) if pat==`i' 
    replace std2 = r(sd) if pat==`i' 
    replace n2 = r(N) if pat==`i' 
	}
gen upper2=mean2+1.96*std2/sqrt(n2)
gen lower2=mean2-1.96*std2/sqrt(n2)
replace mean2=round(mean2, .01)

twoway (rcap lower2 upper2 pat) (scatter mean2 pat,mc(gs2) ms(0)  mlabel(mean2)), xlab(1 "S" 2 "RV" 3 "CV" 4 "FV" 5 "UKV" 6 "USW") ///
b1title("") xtitle("") title("Support rate for SDF deployment") legend(off) note("Note: Bars indicate 95% confidence intervals.") ///
ylab(0.1 (0.1) 0.8) xscale(range(0.8 6.2)) ytitle("%") graphregion(color(white)) scheme(sj)
graph save F1R, replace 
graph export F1R.tif, replace

graph combine F1L.gph F1R.gph, graphregion(color(white))
graph export F1.tif, replace 




* FIGURE II: Wave 2: January 2018 
use "UNSC_Wave2.dta", clear
drop if minute <2

* Support Rate for US Use of Force
gen mean1 =.
gen std =.
gen n =.
	
forvalues i=1(1)4 {
	sum support_dum if pat==`i'  
	replace mean1 = r(mean) if pat==`i' 
    replace std = r(sd) if pat==`i' 
    replace n = r(N) if pat==`i' 
	}
gen upper=mean1+1.96*std/sqrt(n)
gen lower=mean1-1.96*std/sqrt(n)
replace mean1=round(mean1, .01)

twoway (rcap lower upper pat) (scatter mean1 pat, mc(gs2) ms(0) mlabel(mean1)), xlab(1 "S" 2 "SP" 3 "FV" 4 "USW" ) ///
title("Support rate for US use of force") xtitle("") legend(off) note("Note: Bars indicate 95% confidence intervals.") ///
ylab(0.1 (0.1) 0.8) xscale(range(0.8 4.2)) ytitle("%") graphregion(color(white)) scheme(sj)
graph save F2L, replace 
graph export F2L.tif, replace 


* Support Rate for SDF Deployment
gen mean2 =.
gen std2 =.
gen n2 =.
	
forvalues i=1(1)4 {
	sum support_dum2 if pat==`i'  
	replace mean2 = r(mean) if pat==`i' 
    replace std2 = r(sd) if pat==`i' 
    replace n2 = r(N) if pat==`i' 
	}
gen upper2=mean2+1.96*std2/sqrt(n2)
gen lower2=mean2-1.96*std2/sqrt(n2)
replace mean2=round(mean2, .01)

twoway (rcap lower2 upper2 pat) (scatter mean2 pat, mc(gs2) ms(0) mlabel(mean2)), xlab(1 "S" 2 "SP" 3 "FV" 4 "USW" ) ///
title("Support rate for SDF deployment") xtitle("") legend(off) note("Note: Bars indicate 95% confidence intervals.") ///
ylab(0.1 (0.1) 0.8) xscale(range(0.8 4.2)) ytitle("%") graphregion(color(white)) scheme(sj)
graph save F2R.gph, replace 
graph export F2R.tif, replace  

graph combine F2L.gph F2R.gph, graphregion(color(white))
graph export F2.png, replace 
 
 
* Figure III: By Preference Group, Wave 2: January 2018
use "UNSC_Wave2.dta", clear
drop if minute <2
 
* Support Rate for US Use of Force among Hawks (UoF-Favors)  
gen mean_f =.
gen std_f =.
gen n_f =.
	
forvalues i=1(1)4 {
	sum support_dum if pat==`i' & uof_categ2==1
	replace mean_f = r(mean) if pat==`i' & uof_categ2==1
    replace std_f = r(sd) if pat==`i' & uof_categ2==1
    replace n_f = r(N) if pat==`i' & uof_categ2==1
	}
gen upper_f=mean_f+1.96*std_f/sqrt(n_f)
gen lower_f=mean_f-1.96*std_f/sqrt(n_f)
replace mean_f=round(mean_f, .01)

* Support Rate for US Use of Force among (UoF-Unfavors) 
gen mean_unf =.
gen std_unf =.
gen n_unf =.
	
forvalues i=1(1)4 {
	sum support_dum if pat==`i' & uof_categ2==2
	replace mean_unf = r(mean) if pat==`i' & uof_categ2==2
    replace std_unf = r(sd) if pat==`i' & uof_categ2==2
    replace n_unf = r(N) if pat==`i' & uof_categ2==2
	}
gen upper_unf=mean_unf+1.96*std_unf/sqrt(n_unf)
gen lower_unf=mean_unf-1.96*std_unf/sqrt(n_unf)
replace mean_unf=round(mean_unf, .01)

gen pata = pat+0.1  /* Overlay for Manuscript */
gen patb = pat-0.1
gen patall = pat+0.2

twoway (rcap lower_f upper_f patb) (scatter mean_f patb,msymbol(o) mc(gs2) mlabel(mean_f))  ///
(rcap lower_unf upper_unf pata , lw(medthick) lc(gs7)) (scatter mean_unf pata ,msymbol(t) mc(gs2) mlabel(mean_unf)), ///
xlab(1 "S" 2 "SP" 3 "FV" 4 "USW" ) xscale(range(0.8 4.2)) ///
title("Support rate for US use of force" , tstyle(size(medsmall))) ytitle("%") ylab(0 (0.1) 1) ///
legend(label(1 "Hawks") label(2 " ") label(3 "Doves") label(4 " ")  rows(1) ) note("Note: Bars indicate 95% confidence intervals.") graphregion(color(white))  scheme(s2mono) xsize(3)
graph save F3L.gph, replace
graph export F3L.tif, replace 

* Support Rate for SDF Deployment among Hawks (UoF-Favors) 
use "UNSC_Wave2.dta", clear
drop if minute <2
 
gen mean_f =.
gen std_f =.
gen n_f =.
	
forvalues i=1(1)4 {
	sum support_dum2 if pat==`i' & uof_categ2==1
	replace mean_f = r(mean) if pat==`i' & uof_categ2==1
    replace std_f = r(sd) if pat==`i' & uof_categ2==1
    replace n_f = r(N) if pat==`i' & uof_categ2==1
	}
gen upper_f=mean_f+1.96*std_f/sqrt(n_f)
gen lower_f=mean_f-1.96*std_f/sqrt(n_f)
replace mean_f=round(mean_f, .01)

* Support Rate for SDF Deployment among Doves (UoF-Unfavors)  
gen mean_unf =.
gen std_unf =.
gen n_unf =.
	
forvalues i=1(1)4 {
	sum support_dum2 if pat==`i' & uof_categ2==2
	replace mean_unf = r(mean) if pat==`i' & uof_categ2==2
    replace std_unf = r(sd) if pat==`i' & uof_categ2==2
    replace n_unf = r(N) if pat==`i' & uof_categ2==2
	}
gen upper_unf=mean_unf+1.96*std_unf/sqrt(n_unf)
gen lower_unf=mean_unf-1.96*std_unf/sqrt(n_unf)
replace mean_unf=round(mean_unf, .01)

gen pata = pat+0.1  /* Overlay for Manuscript */
gen patb = pat-0.1
gen patall = pat+0.2

twoway (rcap lower_f upper_f patb) (scatter mean_f patb,msymbol(o) mc(gs2) mlabel(mean_f))  ///
(rcap lower_unf upper_unf pata , lw(medthick) lc(gs7)) (scatter mean_unf pata ,msymbol(t) mc(gs2) mlabel(mean_unf)), ///
xlab(1 "S" 2 "SP" 3 "FV" 4 "USW" ) xscale(range(0.8 4.2)) ///
title("Support rate for SDF deployment" , tstyle(size(medsmall))) ytitle("%") ylab(0 (0.1) 1) ///
legend(label(1 "Hawks") label(2 " ") label(3 "Doves") label(4 " ")  rows(1) ) note("Note: Bars indicate 95% confidence intervals.") graphregion(color(white))  scheme(s2mono) xsize(3)

graph save F3R.gph , replace 
graph export F3R.tif, replace 

graph combine F3L.gph F3R.gph, graphregion(color(white))  scheme(sj) xsize(5)
graph export F3.tif, replace 


* FIGURE IV: Motivations, Wave 2: January 2018
use "UNSC_Wave2.dta", clear
drop if minute <2

* All Sample (N=1,251) 
preserve 
set more off 
forvalues i=1(1)9 {
	
oneway reason`i' pat, tabulate
pwmean reason`i', over(pat) mcompare(tukey) effects
return list

matrix b = r(table_vs)
matrix list b
matrix c = b'
svmat double c, name(vector)

gen pair=7-_n  in 1/6
rename vector1 meandiff 
rename vector5 lowci
rename vector6 highci

twoway (scatter pair meandiff ,msize(medium)) (rcap lowci highci pair, lw(medthick) horizontal), legend(off) scheme(s2mono)  ///
xline(0) ylab(6 "Pos.surprise - Full support" 5 "Neg.surprise - Full support" 4  "USW - Full support" 3 "Neg.surprise - Pos.surprise" 2 "USW - Pos.surprise" 1 "USW - Neg.surprise", angle(0) labsize(medsmall)) ///
ytitle(" ") title("Q6_`i'", size(medsmall))   ///
graphregion(color(white))
graph save Q6_`i', replace 
drop vec* meandiff lowci highci  pair
}

restore  

graph combine Q6_1.gph Q6_2.gph Q6_3.gph Q6_4.gph Q6_5.gph Q6_6.gph Q6_7.gph Q6_8.gph Q6_9.gph, iscale(*.8) xcommon  colfirst scheme(sj) graphregion(color(white)) title("All Sample (N=1,251)", tstyle(size(medsmall))) ///
note("Q6_1. 'Perception on illegality'    Q6_4. 'Perception on duration'        Q6_7. 'Perception on contribution to US interest'" /// 
"Q6_2. 'Perception on cost'         Q6_5. 'Perception on casualty'        Q6_8. 'Perception on diplomatic solution'" ///
"Q6_3. 'Perception on contribution to public goods'  Q6_6. 'Perception on low-legitimacy'   Q6_9. 'Perception on possibility of failure'", tstyle(size(vsmall)) ) 
graph export F4.tif, replace 


* Hawk only 
use "UNSC_Wave2.dta", clear
drop if minute <2
 
preserve 
keep if uof_categ2==1

set more off 
forvalues i=1(1)9 {
	
oneway reason`i' pat, tabulate
pwmean reason`i', over(pat) mcompare(tukey) effects
return list

matrix b = r(table_vs)
matrix list b
matrix c = b'
svmat double c, name(vector)

gen pair=7-_n  in 1/6
rename vector1 meandiff 
rename vector5 lowci
rename vector6 highci

twoway (scatter pair meandiff ,msize(medium)) (rcap lowci highci pair, lw(medthick) horizontal), legend(off) scheme(s2mono)  ///
xline(0) ylab(6 "Pos.surprise - Full support" 5 "Neg.surprise - Full support" 4  "USW - Full support" 3 "Neg.surprise - Pos.surprise" 2 "USW - Pos.surprise" 1 "USW - Neg.surprise", angle(0) labsize(medsmall)) ///
ytitle(" ") title("Q6_`i'", size(medsmall))   ///
graphregion(color(white))
graph save Q6_`i', replace 
drop vec* meandiff lowci highci  pair
}

restore  

graph combine Q6_1.gph Q6_2.gph Q6_3.gph Q6_4.gph Q6_5.gph Q6_6.gph Q6_7.gph Q6_8.gph Q6_9.gph, iscale(*.8) xcommon  colfirst scheme(sj)  graphregion(color(white)) title("Hawks (N=488)", tstyle(size(medsmall)))  ///
note("Q6_1. 'Perception on illegality'    Q6_4. 'Perception on duration'        Q6_7. 'Perception on contribution to US interest'" /// 
"Q6_2. 'Perception on cost'         Q6_5. 'Perception on casualty'        Q6_8. 'Perception on diplomatic solution'" ///
"Q6_3. 'Perception on contribution to public goods'  Q6_6. 'Perception on low-legitimacy'         Q6_9. 'Perception on possibility of failure'", tstyle(size(vsmall)) ) 
graph export F4hawk.tif, replace 

* Doves only 
use "UNSC_Wave2.dta", clear
drop if minute <2
 
preserve 
keep if uof_categ2==2

set more off 
forvalues i=1(1)9 {
	
oneway reason`i' pat, tabulate
pwmean reason`i', over(pat) mcompare(tukey) effects
return list

matrix b = r(table_vs)
matrix list b
matrix c = b'
svmat double c, name(vector)

gen pair=7-_n  in 1/6
rename vector1 meandiff 
rename vector5 lowci
rename vector6 highci

twoway (scatter pair meandiff ,msize(medium)) (rcap lowci highci pair, lw(medthick) horizontal), legend(off) scheme(s2mono)  ///
xline(0) ylab(6 "Pos.durprise - Full support" 5 "Neg.surprise - Full support" 4  "USW - Full support" 3 "Neg.surprise - Pos.surprise" 2 "USW - Pos.surprise" 1 "USW - Neg.surprise", angle(0) labsize(medsmall)) ///
ytitle(" ") title("Q6_`i'", size(medsmall))   ///
graphregion(color(white))
graph save Q6_`i', replace 
drop vec* meandiff lowci highci  pair
}

restore  

graph combine Q6_1.gph Q6_2.gph Q6_3.gph Q6_4.gph Q6_5.gph Q6_6.gph Q6_7.gph Q6_8.gph Q6_9.gph, iscale(*.8) xcommon  colfirst scheme(sj)  graphregion(color(white)) title("Doves (N=677)" , tstyle(size(medsmall))) ///
note("Q6_1. 'Perception on illegality'    Q6_4. 'Perception on duration'        Q6_7. 'Perception on contribution to US interest'" /// 
"Q6_2. 'Perception on cost'         Q6_5. 'Perception on casualty'        Q6_8. 'Perception on diplomatic solution'" ///
"Q6_3. 'Perception on contribution to public goods'  Q6_6. 'Perception on low-legitimacy'         Q6_9. 'Perception on possibility of failure'", tstyle(size(vsmall)) ) 
graph export F4dove.tif, replace 



***** ONLINE APPENDIX: Tables and Figures

* TABLE A0: Support Rate for American use of force and SDF Deployment: Wave 1
* Support Rate for American use of force
use "UNSC_Wave1.dta", clear
drop if duration_q01exp<25

bysort pat: su support_dum  
reg support_dum tmt_rv tmt_cv tmt_fv tmt_ukv tmt_usw  /* Coef. shows a difference from a baseline and _cons shows a rate for the baseline (Full Support or tmt_s) */

* Support Rate for SDF Deployment
reg support_dum2 tmt_rv tmt_cv tmt_fv tmt_ukv tmt_usw
bysort pat: su support_dum2 
reg support_dum2 tmt_rv tmt_cv tmt_fv tmt_ukv tmt_usw  /* Coef. shows a difference from a baseline and _cons shows a rate for the baseline (Full Support or tmt_s) */



* TABLE A1: Mean score for Q2-1 and Q2-9 : Wave 1
use "UNSC_Wave1.dta", clear
drop if duration_q01exp<25
sort pat
by pat: sum q02_*



* TABLE A2: Support Rate for American use of force by Respondent Use-of-Force Preference: Wave 1
use "UNSC_Wave1.dta", clear
drop if duration_q01exp<25

* Hawkish (Pro-) Use of Force Respondents
reg support_dum tmt_rv tmt_cv tmt_fv tmt_ukv tmt_usw  if uof_categ2==1
bysort pat: su support_dum  if uof_categ2==1 
tab pat if uof_categ2==1 

* Dovish (Anti-) Use of Force Respondents
reg support_dum tmt_rv tmt_cv tmt_fv tmt_ukv tmt_usw  if uof_categ2==2
bysort pat: su support_dum  if uof_categ2==2 
tab pat if uof_categ2==2 



* TABLE A3: Support Rate for SDF Deployment by Respondent Use-of-Force Preference: Wave 1
use "UNSC_Wave1.dta", clear
drop if duration_q01exp<25

* Hawkish (Pro-) Use of Force Respondents
reg support_dum2 tmt_rv tmt_cv tmt_fv tmt_ukv tmt_usw  if uof_categ2==1
bysort pat: su support_dum2  if uof_categ2==1 
tab pat if uof_categ2==1 

* Dovish (Anti-) Use of Force Respondents
reg support_dum2 tmt_rv tmt_cv tmt_fv tmt_ukv tmt_usw  if uof_categ2==2
bysort pat: su support_dum2  if uof_categ2==2 
tab pat if uof_categ2==2 


* FIGURE A1: 
use "UNSC_Wave1.dta", clear
drop if duration_q01exp<25

* Hawkish (Pro-) Use of Force Respondents: Wave 1 (N=587)
preserve 
keep if uof_categ2==1

set more off 
forvalues i=1(1)9 {
	
oneway q02_`i' pat, tabulate
pwmean q02_`i', over(pat) mcompare(tukey) effects
return list

matrix b = r(table_vs)
matrix list b
matrix c = b'
svmat double c, name(vector)
*list vector1  vector2 vector3 in 1/15

gen pair=16-_n  in 1/15
rename vector1 meandiff 
rename vector5 lowci
rename vector6 highci

twoway (scatter pair meandiff ,msize(medium)) (rcap lowci highci pair, horizontal), legend(off) ///
xline(0) ylab(15 "RV/S" 14 "CV/S" 13 "FV/S" 12 "UKV/S" 11 "USW/S" 10 "CV/RV" 9 "FV/RV" 8 "UKV/RV" 7 "USW/RV" 6 "FV/CV" 5 "UKV/CV" 4 "USW/CV" 3 "UKV/FV" 2 "USW/FV" 1 "USW/UKV", angle(0) labsize(small)) ///
ytitle(" ") title("Q2_`i'", size(small))   ///
graphregion(color(white))
graph save Q2_`i', replace 
drop vec* meandiff lowci highci  pair
}

restore  

graph combine Q2_1.gph Q2_2.gph Q2_3.gph Q2_4.gph Q2_5.gph Q2_6.gph Q2_7.gph Q2_8.gph Q2_9.gph, iscale(*.8) xcommon  colfirst  cols(2)  ysize(9) xsize(6) graphregion(color(white)) 

* Dovish (Anti-) Use of Force Respondents: Wave 1 (N1,183)
preserve 
keep if uof_categ2==2

set more off 
forvalues i=1(1)9 {
	
oneway q02_`i' pat, tabulate
pwmean q02_`i', over(pat) mcompare(tukey) effects
return list

matrix b = r(table_vs)
matrix list b
matrix c = b'
svmat double c, name(vector)
*list vector1  vector2 vector3 in 1/15

gen pair=16-_n  in 1/15
rename vector1 meandiff 
rename vector5 lowci
rename vector6 highci

twoway (scatter pair meandiff ,msize(medium)) (rcap lowci highci pair, horizontal), legend(off) ///
xline(0) ylab(15 "RV/S" 14 "CV/S" 13 "FV/S" 12 "UKV/S" 11 "USW/S" 10 "CV/RV" 9 "FV/RV" 8 "UKV/RV" 7 "USW/RV" 6 "FV/CV" 5 "UKV/CV" 4 "USW/CV" 3 "UKV/FV" 2 "USW/FV" 1 "USW/UKV", angle(0) labsize(small)) ///
ytitle(" ") title("Q2_`i'", size(small))   ///
graphregion(color(white))
graph save Q2_`i', replace 
drop vec* meandiff lowci highci  pair
}

restore  

graph combine Q2_1.gph Q2_2.gph Q2_3.gph Q2_4.gph Q2_5.gph Q2_6.gph Q2_7.gph Q2_8.gph Q2_9.gph, iscale(*.8) xcommon  colfirst  cols(2)  ysize(9) xsize(6) graphregion(color(white)) 

* Add titles by hand 
*Q2_1. Perception on Illegality
*Q2_2. Perception on Cost
*Q2_3. Perception on Contribution to Public Goods
*Q2_4. Perception on Duration
*Q2_5. Perception on Casualty
*Q2_6. Perception on Low-Legitimacy
*Q2_7. Perception on Contribution to US Interest
*Q2_8. Perception on Diplimatic Solution
*Q2_9. Percetion on Possibility of Failure



* TABLE A4: Manipulation Check for Wave 2
use "UNSC_Wave2.dta", clear
drop if minute <2

gen correct=.
replace correct=1 if pat==1 & check ==1
replace correct=1 if pat==2 & check ==1
replace correct=1 if pat==3 & check ==4
replace correct=1 if pat==4 & check ==6
recode correct(.=0)
tab correct 

bysort pat: tab correct
bysort pat: tab correct check, row



* FIGURE A2: Robustness Check for Wave 1: No Sample Reduction for Figure I
use "UNSC_Wave1.dta", clear
*drop if duration_q01exp<25

* Support Rate for US Use of Force
gen mean1 =.
gen std =.
gen n =.
	
forvalues i=1(1)6 {
	sum support_dum if pat==`i'  
	replace mean1 = r(mean) if pat==`i' 
    replace std = r(sd) if pat==`i' 
    replace n = r(N) if pat==`i' 
	}
gen upper=mean1+1.96*std/sqrt(n)
gen lower=mean1-1.96*std/sqrt(n)
replace mean1=round(mean1, .01)

twoway (rcap lower upper pat) (scatter mean1 pat, mlabel(mean1)), xlab(1 "S" 2 "RV" 3 "CV" 4 "FV" 5 "UKV" 6 "USW") ///
b1title("") xtitle("") title("Support rate for US use of force")  legend(off) note("Note: Bars indicate 95% confidence intervals.") ///
ylab(0.1 (0.1) 0.8) ytitle("%") graphregion(color(white)) 

* Support Rate for SDF Deployment
gen mean2 =.
gen std2 =.
gen n2 =.
	
forvalues i=1(1)6 {
	sum support_dum2 if pat==`i'  
	replace mean2 = r(mean) if pat==`i' 
    replace std2 = r(sd) if pat==`i' 
    replace n2 = r(N) if pat==`i' 
	}
gen upper2=mean2+1.96*std2/sqrt(n2)
gen lower2=mean2-1.96*std2/sqrt(n2)
replace mean2=round(mean2, .01)

twoway (rcap lower2 upper2 pat) (scatter mean2 pat, mlabel(mean2)), xlab(1 "S" 2 "RV" 3 "CV" 4 "FV" 5 "UKV" 6 "USW") ///
b1title("") xtitle("") title("Support rate for JSDF deployment") legend(off) note("Note: Bars indicate 95% confidence intervals.") ///
ylab(0.1 (0.1) 0.8) ytitle("%") graphregion(color(white)) 



* FIGURE A3: Robustness Check for Wave 2: No Sample Reduction for Figure II
use "UNSC_Wave2.dta", clear
*drop if minute <2

* Support Rate for US Use of Force
gen mean1 =.
gen std =.
gen n =.
	
forvalues i=1(1)4 {
	sum support_dum if pat==`i'  
	replace mean1 = r(mean) if pat==`i' 
    replace std = r(sd) if pat==`i' 
    replace n = r(N) if pat==`i' 
	}
gen upper=mean1+1.96*std/sqrt(n)
gen lower=mean1-1.96*std/sqrt(n)
replace mean1=round(mean1, .01)

twoway (rcap lower upper pat) (scatter mean1 pat, mlabel(mean1)), xlab(1 "S" 2 "SP" 3 "FV" 4 "USW" 4.2 " ") ///
title("Support rate for US use of force") xtitle("") legend(off) note("Note: Bars indicate 95% confidence intervals.") ///
ylab(0.1 (0.1) 0.8) ytitle("%") graphregion(color(white)) 

* Support Rate for SDF Deployment
gen mean2 =.
gen std2 =.
gen n2 =.
	
forvalues i=1(1)4 {
	sum support_dum2 if pat==`i'  
	replace mean2 = r(mean) if pat==`i' 
    replace std2 = r(sd) if pat==`i' 
    replace n2 = r(N) if pat==`i' 
	}
gen upper2=mean2+1.96*std2/sqrt(n2)
gen lower2=mean2-1.96*std2/sqrt(n2)
replace mean2=round(mean2, .01)

twoway (rcap lower2 upper2 pat) (scatter mean2 pat, mlabel(mean2)), xlab(1 "S" 2 "SP" 3 "FV" 4 "USW" 4.2 " ") ///
title("Support rate for JSDF deployment") xtitle("") legend(off) note("Note: Bars indicate 95% confidence intervals.") ///
ylab(0.1 (0.1) 0.8) ytitle("%") graphregion(color(white)) 



* FIGURE A4: Robustness Check for Wave 2: No Sample Reduction for Figure III
use "UNSC_Wave2.dta", clear
*drop if minute <2
 
* Support Rate for US Use of Force among Hawks 
gen mean_f =.
gen std_f =.
gen n_f =.
	
forvalues i=1(1)4 {
	sum support_dum if pat==`i' & uof_categ2==1
	replace mean_f = r(mean) if pat==`i' & uof_categ2==1
    replace std_f = r(sd) if pat==`i' & uof_categ2==1
    replace n_f = r(N) if pat==`i' & uof_categ2==1
	}
gen upper_f=mean_f+1.96*std_f/sqrt(n_f)
gen lower_f=mean_f-1.96*std_f/sqrt(n_f)
replace mean_f=round(mean_f, .01)

* Support Rate for US Use of Force among Doves 
gen mean_unf =.
gen std_unf =.
gen n_unf =.
	
forvalues i=1(1)4 {
	sum support_dum if pat==`i' & uof_categ2==2
	replace mean_unf = r(mean) if pat==`i' & uof_categ2==2
    replace std_unf = r(sd) if pat==`i' & uof_categ2==2
    replace n_unf = r(N) if pat==`i' & uof_categ2==2
	}
gen upper_unf=mean_unf+1.96*std_unf/sqrt(n_unf)
gen lower_unf=mean_unf-1.96*std_unf/sqrt(n_unf)
replace mean_unf=round(mean_unf, .01)

gen pata = pat+0.1   /* Overlay for Manuscript */
gen patb = pat-0.1
gen patall = pat+0.2

twoway (rcap lower_f upper_f patb) (scatter mean_f patb,msymbol(o) mlabel(mean_f))  ///
(rcap lower_unf upper_unf pata) (scatter mean_unf pata ,msymbol(t) mlabel(mean_unf)), ///
xlab(1 "S" 2 "SP" 3 "FV" 4 "USW" 4.2 " ") title("Support rate for US use of force") ytitle("% ") ylab(0 (0.1) 1) ///
legend(label(1 "Hawks") label(2 " ") label(3 "Doves") label(4 " ")  rows(1) ) note("Note: Bars indicate 95% confidence intervals.") graphregion(color(white))


use "UNSC_Wave2.dta", clear
*drop if minute <2

* Support Rate for SDF Deployment among Hawks  
gen mean_f =.
gen std_f =.
gen n_f =.
	
forvalues i=1(1)4 {
	sum support_dum2 if pat==`i' & uof_categ2==1
	replace mean_f = r(mean) if pat==`i' & uof_categ2==1
    replace std_f = r(sd) if pat==`i' & uof_categ2==1
    replace n_f = r(N) if pat==`i' & uof_categ2==1
	}
gen upper_f=mean_f+1.96*std_f/sqrt(n_f)
gen lower_f=mean_f-1.96*std_f/sqrt(n_f)
replace mean_f=round(mean_f, .01)

* Support Rate for SDF Deployment among Doves 
gen mean_unf =.
gen std_unf =.
gen n_unf =.
	
forvalues i=1(1)4 {
	sum support_dum2 if pat==`i' & uof_categ2==2
	replace mean_unf = r(mean) if pat==`i' & uof_categ2==2
    replace std_unf = r(sd) if pat==`i' & uof_categ2==2
    replace n_unf = r(N) if pat==`i' & uof_categ2==2
	}
gen upper_unf=mean_unf+1.96*std_unf/sqrt(n_unf)
gen lower_unf=mean_unf-1.96*std_unf/sqrt(n_unf)
replace mean_unf=round(mean_unf, .01)

gen pata = pat+0.1 /* Overlay for Manuscript */
gen patb = pat-0.1
gen patall = pat+0.2

twoway (rcap lower_f upper_f patb) (scatter mean_f patb,msymbol(o) mlabel(mean_f))  ///
(rcap lower_unf upper_unf pata) (scatter mean_unf pata ,msymbol(t) mlabel(mean_unf)), ///
xlab(1 "S" 2 "SP" 3 "FV" 4 "USW" 4.2 " ") title("Support rate for JSDF deployment") ytitle("% ") ylab(0 (0.1) 1) ///
legend(label(1 "Hawks") label(2 " ") label(3 "Doves") label(4 " ")  rows(1) ) note("Note: Bars indicate 95% confidence intervals.") graphregion(color(white))



* FIGURE A5: Robustness Check for Wave 2: No Sample Reduction for Figure IV
use "UNSC_Wave2.dta", clear
*drop if minute <2

* All Sample  
preserve 
set more off 
forvalues i=1(1)9 {
	
oneway reason`i' pat, tabulate
pwmean reason`i', over(pat) mcompare(tukey) effects
return list

matrix b = r(table_vs)
matrix list b
matrix c = b'
svmat double c, name(vector)

gen pair=7-_n  in 1/6
rename vector1 meandiff 
rename vector5 lowci
rename vector6 highci

twoway (scatter pair meandiff ,msize(medium)) (rcap lowci highci pair, horizontal), legend(off) ///
xline(0) ylab(6 "Pos.surprise - Full support" 5 "Neg.surprise - Full support" 4  "USW - Full support" 3 "Neg.surprise - Pos.surprise" 2 "USW - Pos.surprise" 1 "USW - Neg.surprise", angle(0) labsize(small)) ///
ytitle(" ") title("Q6_`i'", size(small))   ///
graphregion(color(white))
graph save Q6_`i', replace 
drop vec* meandiff lowci highci  pair
}

restore  

graph combine Q6_1.gph Q6_2.gph Q6_3.gph Q6_4.gph Q6_5.gph Q6_6.gph Q6_7.gph Q6_8.gph Q6_9.gph, iscale(*.8) xcommon  colfirst  graphregion(color(white)) title("Wave2: All Sample (N=1,257)") ///
note("Q6_1. 'Perception on illegality'    Q6_4. 'Perception on duration'        Q6_7. 'Perception on contribution to US interest'" /// 
"Q6_2. 'Perception on cost'         Q6_5. 'Perception on casualty'        Q6_8. 'Perception on diplomatic solution'" ///
"Q6_3. 'Perception on contribution to public goods'  Q6_6. 'Perception on low-legitimacy'         Q6_9. 'Perception on possibility of failure'", tstyle(size(vsmall)) ) 

* Hawk only 
preserve 
keep if uof_categ2==1

set more off 
forvalues i=1(1)9 {
	
oneway reason`i' pat, tabulate
pwmean reason`i', over(pat) mcompare(tukey) effects
return list

matrix b = r(table_vs)
matrix list b
matrix c = b'
svmat double c, name(vector)

gen pair=7-_n  in 1/6
rename vector1 meandiff 
rename vector5 lowci
rename vector6 highci

twoway (scatter pair meandiff ,msize(medium)) (rcap lowci highci pair, horizontal), legend(off) ///
xline(0) ylab(6 "Pos.surprise - Full support" 5 "Neg.surprise - Full support" 4  "USW - Full support" 3 "Neg.surprise - Pos.surprise" 2 "USW - Pos.surprise" 1 "USW - Neg.surprise", angle(0) labsize(small)) ///
ytitle(" ") title("Q6_`i'", size(small))   ///
graphregion(color(white))
graph save Q6_`i', replace 
drop vec* meandiff lowci highci  pair
}

restore  

graph combine Q6_1.gph Q6_2.gph Q6_3.gph Q6_4.gph Q6_5.gph Q6_6.gph Q6_7.gph Q6_8.gph Q6_9.gph, iscale(*.8) xcommon  colfirst  graphregion(color(white)) title("Wave 2: Hawks (N=492)")  ///
note("Q6_1. 'Perception on illegality'    Q6_4. 'Perception on duration'        Q6_7. 'Perception on contribution to US interest'" /// 
"Q6_2. 'Perception on cost'         Q6_5. 'Perception on casualty'        Q6_8. 'Perception on diplomatic solution'" ///
"Q6_3. 'Perception on contribution to public goods'  Q6_6. 'Perception on low-legitimacy'         Q6_9. 'Perception on possibility of failure'", tstyle(size(vsmall)) ) 

* Doves only 
preserve 
keep if uof_categ2==2

set more off 
forvalues i=1(1)9 {
	
oneway reason`i' pat, tabulate
pwmean reason`i', over(pat) mcompare(tukey) effects
return list

matrix b = r(table_vs)
matrix list b
matrix c = b'
svmat double c, name(vector)

gen pair=7-_n  in 1/6
rename vector1 meandiff 
rename vector5 lowci
rename vector6 highci

twoway (scatter pair meandiff ,msize(medium)) (rcap lowci highci pair, horizontal), legend(off) ///
xline(0) ylab(6 "Pos.surprise - Full support" 5 "Neg.surprise - Full support" 4  "USW - Full support" 3 "Neg.surprise - Pos.surprise" 2 "USW - Pos.surprise" 1 "USW - Neg.Surprise", angle(0) labsize(small)) ///
ytitle(" ") title("Q6_`i'", size(small))   ///
graphregion(color(white))
graph save Q6_`i', replace 
drop vec* meandiff lowci highci  pair
}

restore  

graph combine Q6_1.gph Q6_2.gph Q6_3.gph Q6_4.gph Q6_5.gph Q6_6.gph Q6_7.gph Q6_8.gph Q6_9.gph, iscale(*.8) xcommon  colfirst  graphregion(color(white)) title("Wave 2: Doves (N=679)") ///
note("Q6_1. 'Perception on illegality'    Q6_4. 'Perception on duration'        Q6_7. 'Perception on contribution to US interest'" /// 
"Q6_2. 'Perception on cost'         Q6_5. 'Perception on casualty'        Q6_8. 'Perception on diplomatic solution'" ///
"Q6_3. 'Perception on contribution to public goods'  Q6_6. 'Perception on low-legitimacy'         Q6_9. 'Perception on possibility of failure'", tstyle(size(vsmall)) ) 

erase Q2_1.gph
erase Q2_2.gph
erase Q2_3.gph
erase Q2_4.gph
erase Q2_5.gph
erase Q2_6.gph
erase Q2_7.gph
erase Q2_8.gph
erase Q2_9.gph
erase Q6_1.gph
erase Q6_2.gph
erase Q6_3.gph
erase Q6_4.gph
erase Q6_5.gph
erase Q6_6.gph
erase Q6_7.gph
erase Q6_8.gph
erase Q6_9.gph
