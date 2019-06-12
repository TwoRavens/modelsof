set more off
clear

use "$path/touse_main_pooled_wide.dta"
cd "$path"

*****
* Figure 1: Strategy types by country
*****
histogram strategy_t5, fcolor(white) discrete percent ylabel(#5,grid) xtitle("") xlabel(1(1)5, labsize(small) angle(forty_five) valuelabel) by(country)
graph save Figure1.gph, replace
graph export Figure1.pdf, replace

*****
* Figure 2: Distribution of Own Contributions
*****
histogram recip_own_contrib,  fcolor(white) discrete percent ylabel(#5,grid) xlabel(#10, labsize(small)) 
graph save Figure2.gph, replace
graph export Figure2.pdf, replace

*****
* Figure 3: Correlates of Cooperative Behavior in France, Germany, the United Kingdom, and the United States (pooled data).
*****
* Estimates used for plotting:
xi: regress recip_own_contrib female agegr30_49 agegr50_69 agegr70_o incgr_middle incgr_high educ_high i.country [pweight=weight], robust
parmest, saving("$path/res_contrib_socdem", replace)

xi: regress recip_own_contrib recip_expect_med recip_expect_high female agegr30_49 agegr50_69 agegr70_o incgr_middle incgr_high educ_high i.country [pweight=weight], robust
parmest, saving("$path/res_contrib_norms", replace)


* Prepare estimates for figures
foreach set in res_contrib_socdem res_contrib_norms  {
clear
use "$path/`set'"
*rename parm name
*rename estimate b
*rename stderr se
* Drop constant and country estimates
drop if parm=="_cons"
drop if parm=="_Icountry_2"
drop if parm=="_Icountry_3"
drop if parm=="_Icountry_4"
drop if parm=="_cons"
keep parm estimate stderr
*encode name, gen(var)
*drop name
*order var b se
save "$path/`set'", replace

*outfile using `set'.csv, replace
*mkmat var b se, matrix(mat_`set')
*mat2txt, matrix(mat_`set') saving(`set'.txt) replace
}


* Add two missing observations to estimates reporting socio-demographics only
* To make number of observations equal (for plotting) 
clear
use "$path/res_contrib_socdem" 

* Drop country estimates
gen order=_n
d
local new_obs=`r(N)'+3
set obs `new_obs'
replace order=order+3
replace order=1 if estimate==.
sort order
drop order
saveold "$path/res_contrib_socdem", replace 
clear

* Means add one obs to social norms results (for reference category)

clear
use "$path/res_contrib_norms"

* Drop country estimates
gen order=_n
d
local new_obs=`r(N)'+1
set obs `new_obs'
replace order=order+1
replace order=1 if estimate==.
sort order
drop order
saveold "$path/res_contrib_norms", replace 

clear

* Plot produced using R: See folder "4 Figure 3"



*****
* Figure 4: The Socio-demographics of Strategy Types in France, Germany, the United Kingdom, and the United States (pooled data)
*****
use "$path/touse_main_pooled_wide.dta"
cd "$path/"
xi: estsimp mlogit strategy_t5 female agegr30_49 agegr50_69 agegr70_o incgr_middle incgr_high educ_high i.country, baseoutcome(1) robust

* Gender contrast: male to female, else mean
setx mean
simqi, fd(prval(1 2 3 4 5)) changex(female 0 1) fd(genpr(fd_female_1 fd_female_2 fd_female_3 fd_female_4 fd_female_5)) listx
*simqi, fd(prval(1 2 3 4 5)) changex(female 0 1) genpr(fd_female_1 fd_female_2 fd_female_3 fd_female_4 fd_female_5) listx

* Age contrast: agegr30_49 from 0 to 1
* set age group to age < 29
setx (agegr30_49 agegr50_69 agegr70_o) 0
simqi, fd(prval(1 2 3 4 5)) changex(agegr30_49 0 1) fd(genpr(fd_agegr30_49_1 fd_agegr30_49_2 fd_agegr30_49_3 fd_agegr30_49_4 fd_agegr30_49_5)) listx

* Age contrast: agegr50_69 from 0 to 1
* set age group to age < 29
setx (agegr30_49 agegr50_69 agegr70_o) 0
simqi, fd(prval(1 2 3 4 5)) changex(agegr50_69 0 1) fd(genpr(fd_agegr50_69_1 fd_agegr50_69_2 fd_agegr50_69_3 fd_agegr50_69_4 fd_agegr50_69_5)) listx

* Age contrast: agegr70_o from 0 to 1
* set age group to age < 29
setx (agegr30_49 agegr50_69 agegr70_o) 0
simqi, fd(prval(1 2 3 4 5)) changex(agegr70_o 0 1) fd(genpr(fd_agegr70_o_1 fd_agegr70_o_2 fd_agegr70_o_3 fd_agegr70_o_4 fd_agegr70_o_5)) listx

* Income contrast: incgr_middle from 0 to 1
* set income group to low
setx (incgr_middle incgr_high) 0
simqi, fd(prval(1 2 3 4 5)) changex(incgr_middle 0 1) fd(genpr(fd_incgr_middle_1 fd_incgr_middle_2 fd_incgr_middle_3 fd_incgr_middle_4 fd_incgr_middle_5)) listx

* Income contrast: incgr_high from 0 to 1
* set income group to low
setx (incgr_middle incgr_high) 0
simqi, fd(prval(1 2 3 4 5)) changex(incgr_high 0 1) fd(genpr(fd_incgr_high_1 fd_incgr_high_2 fd_incgr_high_3 fd_incgr_high_4 fd_incgr_high_5)) listx

* Education contrast: educ_high from 0 to 1
* set all mean
setx mean
simqi, fd(prval(1 2 3 4 5)) changex(educ_high 0 1) fd(genpr(fd_educ_high_1 fd_educ_high_2 fd_educ_high_3 fd_educ_high_4 fd_educ_high_5)) listx
save res_socdem_strategy_pool_PrY_forfig.dta, replace

* A. Prepare data and variable names
use res_socdem_strategy_pool_PrY_forfig.dta
keep fd_female_1-fd_educ_high_5

* Prepare frame for extracting quantities of interest
gen type=1 in 1/7
replace type=2 in 8/14
replace type=3 in 15/21
replace type=4 in 22/28
replace type=5 in 29/35

label var type "Strategy Type"
label define typelab 1 "FR" 2 "PN" 3 "PR" ///
4 "IU" 5 "O"
label values type typelab

* Prepare variable names
gen varname=.
forvalues k=1(1)7 {
	forvalues i=`k'(7)35 {
	replace varname=`k' in `i' 
	}
}

label var varname "Socio-Demographics"
label define varlab 1 "Female" 2 "Age: 30-49" 3 "Age: 50-69" ///
4 "Age: 70+" 5 "Income: Middle" 6 "Income: High" 7 "Education: High"
label values varname varlab

gen varstring="."
replace varstring="female" if varname==1
replace varstring="agegr30_49" if varname==2
replace varstring="agegr50_69" if varname==3
replace varstring="agegr70_o" if varname==4
replace varstring="incgr_middle" if varname==5
replace varstring="incgr_high" if varname==6
replace varstring="educ_high" if varname==7

* Quantity of Interest: Change in Pr(Y=c)
gen estimate=.
gen min95=.
gen max95=.

* Populate cells
* Female (varname==1)
foreach var in female agegr30_49 agegr50_69 agegr70_o incgr_middle incgr_high educ_high {
	forvalues i=1(1)5 {
	su fd_`var'_`i'
	replace estimate=r(mean) if varstring=="`var'" & type==`i'
	*sumqi fd_`var'_`i', level(99)
	sumqi fd_`var'_`i', level(95)
	replace min95=r(r1) if varstring=="`var'" & type==`i'
	replace max95=r(r2) if varstring=="`var'" & type==`i'
	}
}

label variable estimate "Change in Pr(Y=j)"
drop if estimate==.
drop fd_female_1-fd_educ_high_5

* Plot
twoway (rspike min95 max95 type, ///
  xlabel(,valuelabel angle(90) labsize(small))) ///
(scatter estimate type, ytitle("Change in Pr(Type)") xtitle("") yline(0, ///
lwidth(thin) lpattern(dash) lcolor(black)) ///
ylabel(-0.3(0.1)0.2, labsize(small)) ///
ymtick(##3, nolabels) ///
mcolor(black) msize(vsmall) msymbol(circle)), ///
by(, legend(at(8))) ///
legend(order(3 "FR=Freerider" 4 "PN=Positive Nonconditional" ///
5 "PR=Positive Reciprocity" 6 "IU=Inverse U-shaped Reciprocity" 7 "O=Other") ///
rows(5) size(small)) ///
by(varname, imargin(zero)) ///
subtitle(, size(small))

graph save Figure4.gph, replace
graph export Figure4.pdf, replace
clear

*****
* Table 1: The Causal Effect of Cooperative Environment on Own Contributions.
*****
use "$path/touse_main_pooled_wide.dta"
xi: regress recip_own_contrib , robust
outreg2 using Table1.xls, ctitle() excel bdec(2) stats(coef se) replace

xi: regress recip_own_contrib example_other_306090 [pweight=weight], robust
outreg2 using Table1.xls, ctitle("Binary Treatment (High vs Low)") excel bdec(2) stats(coef se) append
 
xi: regress recip_own_contrib example_other_306090 female agegr30_49 agegr50_69 agegr70_o incgr_middle incgr_high educ_high i.own_ex_cont i.country [pweight=weight], robust
outreg2 using Table1.xls, ctitle("Binary Treatment with Controls") excel bdec(2) stats(coef se) append

xi: regress recip_expect_contrib example_other_306090 [pweight=weight], robust
outreg2 using Table1.xls, ctitle("DV: Expectations - First Stage IV") excel bdec(2) stats(coef se) append

xi: regress recip_expect_contrib example_other_306090 female agegr30_49 agegr50_69 agegr70_o incgr_middle incgr_high educ_high i.own_ex_cont i.country [pweight=weight], robust
outreg2 using Table1.xls, ctitle("DV: Expectations - First Stage IV") excel bdec(2) stats(coef se) append

xi: ivreg2 recip_own_contrib (recip_expect_contrib=example_other_306090)  [pweight=weight], robust first
outreg2 using Table1.xls, ctitle("IV Estimates, Binary Treatment") excel bdec(2) stats(coef se) append

xi: ivreg2 recip_own_contrib female agegr30_49 agegr50_69 agegr70_o incgr_middle incgr_high educ_high i.own_ex_cont i.country (recip_expect_contrib=example_other_306090) [pweight=weight], robust first
outreg2 using Table1.xls, ctitle("IV Estimates, Binary Treatment with Controls") excel bdec(2) stats(coef se) append

*****
* Table 2: The Socio-demographic Correlates of Contribution Elasticity
*****
* by sociodemographic subgroups
xi: regress elasticity female agegr30_49 agegr50_69 agegr70_o incgr_middle incgr_high educ_high i.country [pweight=weight], robust
outreg2 using Table2.xls, ctitle("Basic") excel bdec(2) stats(coef se) replace

xi: regress elasticity female agegr30_49 agegr50_69 agegr70_o incgr_middle incgr_high educ_high altru_high married separated divorced widowed dompart emplgr_unemp ideology i.country [pweight=weight], robust
outreg2 using Table2.xls, ctitle("Extended") excel bdec(2) stats(coef se) append

xi: tobit elasticity female agegr30_49 agegr50_69 agegr70_o incgr_middle incgr_high educ_high emplgr_unemp ideology altru_high married separated divorced widowed dompart i.country  [pweight=weight], ll(0) robust
outreg2 using Table2.xls, ctitle("Tobit") excel bdec(2) stats(coef se) append


*****
* Table 3: The Causal Effects of Cooperative Environment on Own Contributions by Strategy Type (Instrumental Variables Estimates).
*****
xi: ivreg2 recip_own_contrib female agegr30_49 agegr50_69 agegr70_o incgr_middle incgr_high educ_high i.own_ex_cont i.country (recip_expect_contrib=example_other_306090) [pweight=weight] if strategy_t5==1, robust first
outreg2 using Table3.xls, ctitle("IV Estimates: Freerider t5") excel bdec(2) stats(coef se) replace

xi: ivreg2 recip_own_contrib female agegr30_49 agegr50_69 agegr70_o incgr_middle incgr_high educ_high i.own_ex_cont i.country (recip_expect_contrib=example_other_306090) [pweight=weight] if strategy_t5==2, robust first
outreg2 using Table3.xls, ctitle("Exp: IV Estimates: Positive Noncond t5 (at least 5)") excel bdec(2) stats(coef se) append

xi: ivreg2 recip_own_contrib female agegr30_49 agegr50_69 agegr70_o incgr_middle incgr_high educ_high i.own_ex_cont i.country (recip_expect_contrib=example_other_306090) [pweight=weight] if strategy_t5==3, robust first
outreg2 using Table3.xls, ctitle("Exp: IV Estimates: Positive Reciproc: at least 5 units increase") excel bdec(2) stats(coef se) append

xi: ivreg2 recip_own_contrib female agegr30_49 agegr50_69 agegr70_o incgr_middle incgr_high educ_high i.own_ex_cont i.country (recip_expect_contrib=example_other_306090) [pweight=weight] if strategy_t5==4, robust first
outreg2 using Table3.xls, ctitle("Exp: IV Estimates: Inverse U-shaped (at least5)") excel bdec(2) stats(coef se) append

xi: ivreg2 recip_own_contrib female agegr30_49 agegr50_69 agegr70_o incgr_middle incgr_high educ_high i.own_ex_cont i.country (recip_expect_contrib=example_other_306090) [pweight=weight] if strategy_t5==5, robust first
outreg2 using Table3.xls, ctitle("Exp: IV Estimates: Other t5") excel bdec(2) stats(coef se) append

*****
* Table A-1: Distribution of Sociodemgraphics
* Population demographics sources: see note for Table S1
*****
* Distribution of sociodemgraphics
* a. France
svyset [pweight=weight]

* Age
tab  agegrd_fr
svy: tab agegrd_fr

* Gender
tab female if country==1
svy: tab female if country==1

* Education
tab educgrd_fr
svy: tab educgrd_fr

* b. Germany
* Age
tab agegrd_ge
svy: tab agegrd_ge

* Gender
tab female if country==2
svy: tab female if country==2

* Education
tab educgr_ge
svy: tab educgr_ge

* c. United Kingdom
* Age
tab agegrd_uk
svy: tab agegrd_uk
* Gender
tab female if country==3
svy: tab female if country==3

* Education
svyset [pweight=weight]
tab educgrd_uk 
svy: tab educgrd_uk 

* c. United States
* Age
tab agegrd_us 
svy: tab agegrd_us

* Gender
tab female if country==4
svy: tab female if country==4

* Education
tab educgrd_us 
svy: tab educgrd_us 


*****
* Table A-2: The Socio-demographic Correlates of Contributions
*****
xi: regress recip_own_contrib [pweight=weight], robust
outreg2 using TableA2.xls, ctitle() excel bdec(2) stats(coef se) replace
xi: regress recip_own_contrib female agegr30_49 agegr50_69 agegr70_o incgr_middle incgr_high educ_high altru_high married separated divorced widowed dompart emplgr_unemp ideology i.country [pweight=weight], robust
outreg2 using TableA2.xls, ctitle(Contributions: All) excel bdec(2) stats(coef se) append
xi: regress recip_own_contrib recip_expect_med recip_expect_high female agegr30_49 agegr50_69 agegr70_o incgr_middle incgr_high educ_high altru_high married separated divorced widowed dompart emplgr_unemp ideology i.country [pweight=weight], robust
outreg2 using TableA2.xls, ctitle(Contributions: All) excel bdec(2) stats(coef se) append
xi: regress recip_own_contrib recip_expect_med recip_expect_high female agegr30_49 agegr50_69 agegr70_o incgr_middle incgr_high educ_high i.country [pweight=weight] if expectationsother_asked_first==0, robust
outreg2 using TableA2.xls, ctitle("Own contribution first") excel bdec(2) stats(coef se) append
xi: regress recip_own_contrib recip_expect_med recip_expect_high female agegr30_49 agegr50_69 agegr70_o incgr_middle incgr_high educ_high i.country [pweight=weight] if expectationsother_asked_first==1, robust
outreg2 using TableA2.xls, ctitle("Expectation other first") excel bdec(2) stats(coef se) append
xi: regress recip_own_contrib recip_expect_med recip_expect_high female agegr30_49 agegr50_69 agegr70_o incgr_middle incgr_high educ_high expectationsother_asked_first i.country [pweight=weight], robust
outreg2 using TableA2.xls, ctitle("Expectation other first variable") excel bdec(2) stats(coef se) append
xi: tobit recip_own_contrib recip_expect_med recip_expect_high female agegr30_49 agegr50_69 agegr70_o incgr_middle incgr_high educ_high i.country [pweight=weight], ll(0) ul(100) vce(r)
outreg2 using TableA2.xls, ctitle(SocialNorms_SI_tobit_cat_altru) excel bdec(2) stats(coef se) append

*****
* Table A-3: The Correlates of Contributions by Strategy Type
*****
xi: regress recip_own_contrib [pweight=weight], robust
outreg2 using TableA3.xls, ctitle() excel bdec(2) stats(coef se) replace
xi: regress recip_own_contrib recip_expect_med recip_expect_high female agegr30_49 agegr50_69 agegr70_o incgr_middle incgr_high educ_high i.country if strategy_t5==1 [pweight=weight], robust
outreg2 using TableA3.xls, ctitle("Freerider") excel bdec(2) stats(coef se) append
xi: regress recip_own_contrib recip_expect_med recip_expect_high female agegr30_49 agegr50_69 agegr70_o incgr_middle incgr_high educ_high i.country if strategy_t5==2 [pweight=weight], robust
outreg2 using TableA3.xls, ctitle("Positive Nonconditional") excel bdec(2) stats(coef se) append
xi: regress recip_own_contrib recip_expect_med recip_expect_high female agegr30_49 agegr50_69 agegr70_o incgr_middle incgr_high educ_high i.country if strategy_t5==3 [pweight=weight], robust
outreg2 using TableA3.xls, ctitle("Positive Reciprocity") excel bdec(2) stats(coef se) append
xi: regress recip_own_contrib recip_expect_med recip_expect_high female agegr30_49 agegr50_69 agegr70_o incgr_middle incgr_high educ_high i.country if strategy_t5==4 [pweight=weight], robust
outreg2 using TableA3.xls, ctitle("Inverse U-shaped Reciprocity") excel bdec(2) stats(coef se) append
xi: regress recip_own_contrib recip_expect_med recip_expect_high female agegr30_49 agegr50_69 agegr70_o incgr_middle incgr_high educ_high i.country if strategy_t5==5 [pweight=weight], robust
outreg2 using TableA3.xls, ctitle("Other") excel bdec(2) stats(coef se) append

*****
* Table A-4: The Causal Effects of Cooperative Environments on Own Contributions by Strategy Type - All Treatment Indicators
*****

**********************************
* 0. Own contribution experiment: Additional Treatment indicators for appendix 
**********************************

gen exp_other_10=0
replace exp_other_10=1 if other_ex_cont==10
label var exp_other_10 "Other Contribution Treatment: 10"

gen exp_other_30=0
replace exp_other_30=1 if other_ex_cont==30
label var exp_other_30 "Other Contribution Treatment: 30"

gen exp_other_60=0
replace exp_other_60 =1 if other_ex_cont==60
label var exp_other_60 "Other Contribution Treatment: 60"

gen exp_other_90=0
replace exp_other_90=1 if other_ex_cont==90
label var exp_other_90 "Other Contribution Treatment: 90"

* Three treatment groups
gen exp_other_low=0
replace exp_other_low=1 if exp_other_10==1 | exp_other_30==1 
label var exp_other_low "Other Contribution Treatment Low: 10 or 30"

gen exp_other_medium=0
replace exp_other_medium=1 if exp_other_60==1 
label var exp_other_medium "Other Contribution Treatment Medium: 60"

gen exp_other_high=0
replace exp_other_high=1 if exp_other_90==1 
label var exp_other_high "Other Contribution Treatment High: 90"


xi: regress recip_own_contrib [pweight=weight], robust
outreg2 using TableA4.xls, ctitle("") excel bdec(2) stats(coef se) replace
xi: regress recip_own_contrib exp_other_30 exp_other_60 exp_other_90 female agegr30_49 agegr50_69 agegr70_o incgr_middle incgr_high educ_high i.own_ex_cont i.country [pweight=weight], robust
outreg2 using TableA4.xls, ctitle("All") excel bdec(2) stats(coef se) append
xi: regress recip_own_contrib exp_other_30 exp_other_60 exp_other_90 female agegr30_49 agegr50_69 agegr70_o incgr_middle incgr_high educ_high i.own_ex_cont i.country [pweight=weight] if strategy_t5==1, robust
outreg2 using TableA4.xls, ctitle("Freerider") excel bdec(2) stats(coef se) append
xi: regress recip_own_contrib exp_other_30 exp_other_60 exp_other_90 female agegr30_49 agegr50_69 agegr70_o incgr_middle incgr_high educ_high i.own_ex_cont i.country [pweight=weight] if strategy_t5==2, robust
outreg2 using TableA4.xls, ctitle("Positive Nonconditional") excel bdec(2) stats(coef se) append
xi: regress recip_own_contrib exp_other_30 exp_other_60 exp_other_90 female agegr30_49 agegr50_69 agegr70_o incgr_middle incgr_high educ_high i.own_ex_cont i.country [pweight=weight] if strategy_t5==3, robust
outreg2 using TableA4.xls, ctitle("Positive Reciprocitiy") excel bdec(2) stats(coef se) append
xi: regress recip_own_contrib exp_other_30 exp_other_60 exp_other_90 female agegr30_49 agegr50_69 agegr70_o incgr_middle incgr_high educ_high i.own_ex_cont i.country [pweight=weight] if strategy_t5==4, robust
outreg2 using TableA4.xls, ctitle("Positive Inverse U-shaped") excel bdec(2) stats(coef se) append
xi: regress recip_own_contrib exp_other_30 exp_other_60 exp_other_90 female agegr30_49 agegr50_69 agegr70_o incgr_middle incgr_high educ_high i.own_ex_cont i.country [pweight=weight] if strategy_t5==5, robust
outreg2 using TableA4.xls, ctitle("Other") excel bdec(2) stats(coef se) append

*****
* Table A-5: The Causal Effects of Expected Contribution on Own Contribution.
*****
xi: regress recip_own_contrib, robust
outreg2 using TableA5.xls, ctitle() excel bdec(2) stats(coef se) replace
xi: regress recip_own_contrib exp_other_30 exp_other_60 exp_other_90 [pweight=weight], robust
outreg2 using TableA5.xls, ctitle("All Treatments") excel bdec(2) stats(coef se) append
xi: regress recip_own_contrib exp_other_30 exp_other_60 exp_other_90 female agegr30_49 agegr50_69 agegr70_o incgr_middle incgr_high educ_high i.own_ex_cont i.country [pweight=weight], robust
outreg2 using TableA5.xls, ctitle("All Treatments with Controls") excel bdec(2) stats(coef se) append

*****
* Table A-6: The Socio-demographic Correlates of Observed and Predicted Contributions.
*****
gen d_obs_pred=pred_contrib_ct-recip_own_contrib
label var d_obs_pred "Difference between Predicted and Observed Own Contribution"
label var pred_contrib_ct "Predicted (Strategy Method)"

xi: regress recip_own_contrib [pweight=weight], robust
outreg2 using TableA6.xls, ctitle() excel bdec(2) stats(coef se) replace

xi: regress recip_own_contrib recip_expect_med recip_expect_high female agegr30_49 agegr50_69 agegr70_o incgr_middle incgr_high educ_high altru_high married separated divorced widowed dompart emplgr_unemp ideology i.country [pweight=weight], robust
outreg2 using TableA6.xls, ctitle(Own Contribution) excel bdec(2) stats(coef se) append

xi: regress pred_contrib_ct recip_expect_med recip_expect_high female agegr30_49 agegr50_69 agegr70_o incgr_middle incgr_high educ_high altru_high married separated divorced widowed dompart emplgr_unemp ideology i.country [pweight=weight], robust
outreg2 using TableA6.xls, ctitle(Predicted Contribution (Strategy Method and Belief)) excel bdec(2) stats(coef se) append

xi: regress d_obs_pred recip_expect_med recip_expect_high female agegr30_49 agegr50_69 agegr70_o incgr_middle incgr_high educ_high altru_high married separated divorced widowed dompart emplgr_unemp ideology i.country [pweight=weight], robust
outreg2 using TableA6.xls, ctitle(DV: Difference in predicted and observed) excel bdec(2) stats(coef se) append

*****
* Table A-7: The Socio-demographic Correlates of Strategy Choice
*****
xi: mlogit strategy_t5 female agegr30_49 agegr50_69 agegr70_o incgr_middle incgr_high educ_high i.country [pweight=weight], baseoutcome(1) robust
outreg2 using TableA7.xls, ctitle("Strategy: Socio-Demo") excel bdec(2) stats(coef se) replace

*****
* Figure A-1: Distribution of Conditional Contribution Schedules
*****
* USE LONG FORMAT DATA TO PLOT STRATEGIES
clear

use "$path/touse_main_pooled_long.dta"
twoway (line contrib_own contrib_other, lcolor(gs8) lpattern(solid) lwidth(vvthin) cmissing(n) connect(direct) cmissing(n))
graph save FigureA1.gph, replace
clear
exit

