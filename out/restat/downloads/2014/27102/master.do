cd H:\RESEARCH\PriceIsRight\Publication
cap log close

** This file generates all table and figure output for "The Price is Right: Updating of Inflation Expectations in a Randomized Price Information Experiment"
** Note, this file can be run in two versions by changing the local called "version," below
** Midpoint version: SPF perception gaps is coded as distance to median SPF forecast
** Interval version: SPF perception gaps is coded as minimum distance to 90% interval SPF forecast
** The former results are reported in the paper; interval version results are a robustness check (see footnote 15)

local version "midpoint"
*local version "interval"

*************************
** PART ONE: DATA PREP **
*************************

** Data prep for density forecasts
use densityforecasts, clear
reshape wide  mean median var p25 p75, i(id question) j(wave) string
rename id prim_key
save Output\densityforecasts_reshaped, replace

** Data prep for financial literacy questions
use finlit_raw, clear 
gen fin_q1 = 0 
replace fin_q1 = 1 if F1 == 2 
gen fin_q2 = 0 
replace fin_q2 = 1 if F2 == 2 
gen num_q1 = 0 
replace num_q1 = 1 if N2_100 == 10 
gen num_q2 = 0 
replace num_q2 = 1 if N2_1000 == 100 
gen num_q3 = 0 
replace num_q3 = 1 if N3 == 500 
gen num_q4 = 0 
replace num_q4 = 1 if N4_1year == 110 
gen num_q5 = 0 
replace num_q5 = 1 if N4_2years == 121 
gen highfinlit = 0 
replace highfinlit = 1 if fin_q1 + fin_q2 + num_q1 + num_q2 + num_q3 + num_q4 + num_q5 >= 7
keep prim_key highfinlit
save Output\finlit_scores, replace

***********************************
** PART TWO: MERGES AND CLEANING **
***********************************

** Merge density forecast and finlit data with point forecast raw data:
use pointforecast_raw, clear
set more off

** Note 10 respondents finished the survey but do not have density forecasts:
merge 1:1 prim_key using Output\densityforecasts_reshaped
drop _merge

** Some other respondents didn't finish the survey at all:
drop if tsend==""

** Merge in finlit data:
merge 1:1 prim_key using Output\finlit_scores
drop if _merge==2
drop _merge

** Flag the treatment groups:
gen all=1
gen treated = .
replace treated = 1 if randomscreen2!=4  & randomscreen2!=.
replace treated = 0 if randomscreen2==4  & randomscreen2!=.
gen control = !treated
gen treatment = ""
replace treatment = "food" if randomab==1
replace treatment = "spf" if randomab==2
gen food=.
replace food=0 if treatment!="food"
replace food=1 if treatment=="food"
gen spf=.
replace spf=0 if treatment!="spf"
replace spf=1 if treatment=="spf"
gen question_type = ""
replace question_type = "PP" if randomstage1==1
replace question_type = "RI" if randomstage1==2
tab question question_type, mi
drop question
rename question_type question
gen pp=.
replace pp=0 if question=="RI"
replace pp=1 if question=="PP"
gen ri=.
replace ri=0 if question=="PP"
replace ri=1 if question=="RI"
gen ppXfood = pp * food
gen riXfood = ri * food
gen ppXtreated = pp * treated
gen riXtreated = ri * treated
gen controlXfood = control * food
gen ppXfoodXtreated = pp * food * treated
gen riXfoodXtreated = ri * food * treated
gen treatment_string=""
replace treatment_string = "2 PP SPF Control" if randomscreen2==4 & question=="PP" & treatment=="spf"
replace treatment_string = "4 PP FoodBev Control" if randomscreen2==4 & question=="PP" & treatment=="food"
replace treatment_string = "1 RI SPF Control" if randomscreen2==4 & question=="RI" & treatment=="spf"
replace treatment_string = "3 RI FoodBev Control" if randomscreen2==4 & question=="RI" & treatment=="food"
replace treatment_string = "6 PP SPF Info Treatment" if randomscreen2!=4 & question=="PP" & treatment=="spf"
replace treatment_string = "8 PP FoodBev Info Treatment" if randomscreen2!=4 & question=="PP" & treatment=="food"
replace treatment_string = "5 RI SPF Info Treatment" if randomscreen2!=4 & question=="RI" & treatment=="spf"
replace treatment_string = "7 RI FoodBev Info Treatment" if randomscreen2!=4 & question=="RI" & treatment=="food"

** Recode education:
recode highesteducation (4=8) (6=10) (7=11) (8=11) (9=12) (10=13) (11=14) (12=14) (13=16) (14=18) (15=18) (16=20), generate(educ_years)
sum educ_years, d

** Find initial beliefs:
gen belief_food = .
replace belief_food = e1a_higher if e1a_lower==. | (e1a_lower==0 & e1a_higher!=.)
replace belief_food = -e1a_lower if e1a_higher==. | (e1a_higher==0 & e1a_lower!=.)
gen belief_spf = .
replace belief_spf = e1b_inflation if e1b_deflation==. | (e1b_deflation==0 & e1b_inflation!=.)
replace belief_spf = -e1b_deflation if e1b_inflation==. | (e1b_inflation==0 & e1b_deflation!=.)

** Calculate perception gaps:
** (Note randomscreen2==4 --> control group. No treatment respondent has a zero perception gap, so we can code control respondents as zero perception gaps w/o affecting the regressions below)
gen gap_food = 1.39 - belief_food if randomscreen2!=4
replace gap_food = 0 if randomscreen2==4 & food==1
gen gap_spf = 1.96 - belief_spf if randomscreen2!=4
replace gap_spf = 0 if randomscreen2==4 & food==0
gen gap = .
replace gap = gap_food if gap_food!=.
replace gap = gap_spf if gap_spf!=.
drop gap_spf gap_food
gen abs_gap = abs(gap)
gen log_info_belief = .
replace log_info_belief = ln(1.39/belief_food) if log_info_belief==.
replace log_info_belief = ln(1.96/belief_spf) if log_info_belief==.
gen recoded_neg_belief = .1 if belief_food<=0 | belief_spf<=0
replace log_info_belief = ln(1.39/recoded_neg_belief) if belief_food<=0
replace log_info_belief = ln(1.96/recoded_neg_belief) if belief_spf<=0
if "`version'"=="interval" {
	replace gap = 0 if spf & (belief_spf >= 1.19 & belief_spf<=3.03) & control==0
	replace gap = 3.03 - belief_spf if spf & belief_spf>3.03 & belief_spf!=. & control==0
	replace gap = 1.19 - belief_spf if spf & belief_spf<1.19 & control==0
	}
	
** Error xi term:
gen gapXpp = pp * gap
gen gapXri = ri * gap

** Demographics:
gen fem = .
replace fem = 0 if gender==1
replace fem = 1 if gender==2
gen incover75 = familyincome>=14 if familyincome!=.
gen college = highesteducation>=13 if highesteducation!=.
gen age55andup = rage>=55 if rage!=. 
gen male = fem==0 if fem!=.
gen incunder75=incover75==0 if incover75!=.
gen nocollege = college==0 if college!=.
gen lofinlit = highfinlit==0 if highfinlit!=.
gen ageunder55 = !age55andup

** SPF/FoodBev Affected:
gen spf_affected = e5b>=5 & e5b!=. if e5b!=.
gen food_affected = e5a>=5 & e5a!=. if e5a!=.
gen affected = . 
replace affected = food_affected if affected==.
replace affected = spf_affected if affected==.
replace affected = 0 if affected==.
drop spf_affected food_affected
gen noaffected = affected==0 if affected!=.

** Affected xi term:
gen affectedXpp = affected * pp
gen affectedXri = affected * ri
gen affectedXgapXpp = affected * gap * pp
gen affectedXgapXri = affected * gap * ri
gen affectedXtreated = affected * treated
gen noaffectedXpp = noaffected * pp
gen noaffectedXri = noaffected * ri
gen noaffectedXgapXpp = noaffected * gap * pp
gen noaffectedXgapXri = noaffected * gap * ri

** Baseline point forecasts:
gen base_pf_PP1 = .
replace base_pf_PP1 =  a1_12months_up if (a1_12months_down==. | a1_12months_down==0)
replace base_pf_PP1 = a1_12months_down if (a1_12months_up==. | a1_12months_up==0)
gen base_pf_RI1 = .
replace base_pf_RI1 =  a3_12months_inflation if (a3_12months_deflation==. | a3_12months_deflation==0)
replace base_pf_RI1 = a3_12months_deflation if (a3_12months_inflation==. | a3_12months_inflation==0)
gen base_pf_PP3 = .
replace base_pf_PP3 =  a1_3years_up if (a1_3years_down==. | a1_3years_down==0)
replace base_pf_PP3 = a1_3years_down if (a1_3years_up==. | a1_3years_up==0)
gen base_pf_RI3 = .
replace base_pf_RI3 =  a3_3years_inflation if (a3_3years_deflation==. | a3_3years_deflation==0)
replace base_pf_RI3 = a3_3years_deflation if (a3_3years_inflation==. | a3_3years_inflation==0)

** Recode a  probable typo:
replace base_pf_RI1 = 20 if base_pf_RI1==2020

** Revised point forecasts:
gen end_pf_PP1 = .
replace end_pf_PP1 =  e1_12months_up if (e1_12months_down==. | e1_12months_down==0)
replace end_pf_PP1 = e1_12months_down if (e1_12months_up==. | e1_12months_up==0)
gen end_pf_RI1 = .
replace end_pf_RI1 =  e3_12months_inflation if (e3_12months_deflation==. | e3_12months_deflation==0)
replace end_pf_RI1 = e3_12months_deflation if (e3_12months_inflation==. | e3_12months_inflation==0)
gen end_pf_PP3 = .
replace end_pf_PP3 =  e1_3years_up if (e1_3years_down==. | e1_3years_down==0)
replace end_pf_PP3 = e1_3years_down if (e1_3years_up==. | e1_3years_up==0)
gen end_pf_RI3 = .
replace end_pf_RI3 =  e3_3years_inflation if (e3_3years_deflation==. | e3_3years_deflation==0)
replace end_pf_RI3 = e3_3years_deflation if (e3_3years_inflation==. | e3_3years_inflation==0)

** Point forecast revisions:
gen pf_revision1 = end_pf_PP1 - base_pf_PP1
replace pf_revision1 = end_pf_RI1 - base_pf_RI1 if pf_revision1==.
gen pf_revision3 = end_pf_PP3 - base_pf_PP3
replace pf_revision3 = end_pf_RI3 - base_pf_RI3 if pf_revision3==.

** Density forecast revisions:
gen dens_revision = meanb - meana

** Absolute revision vars:
foreach rev in pf_revision1 pf_revision3 dens_revision {
	gen abs_`rev' = abs(`rev')
	}
	
** Demographic xi terms:
foreach var of varlist fem incover75 college highfinlit age55andup  {
	gen `var'Xtreated = `var' * treated
	gen `var'Xfood = `var' * food
	gen `var'XgapXpp = `var' * gap * pp
	gen `var'XgapXri = `var' * gap * ri
	gen `var'Xpp = `var' * pp
	gen `var'Xri = `var' * ri
	
	}
foreach var of varlist male incunder75 nocollege lofinlit ageunder55 {
	gen `var'XgapXpp = `var' * gap * pp
	gen `var'XgapXri = `var' * gap * ri
	}

** Drop anyone with missing PF revision or missing perception gap:
drop if pf_revision1==. | riXtreated==. | gapXri==.
drop if pf_revision1==. | ppXtreated==. | gapXpp==.	

** Drop outliers by initial point forecast:
foreach pf in PP1 RI1 PP3 RI3 {
	drop if abs(end_pf_`pf')>50 & end_pf_`pf'!=.
	drop if abs(base_pf_`pf')>50 & base_pf_`pf'!=.
	}

** Drop outliers by info beliefs:
keep if (abs(belief_spf)<=50 | abs(belief_food)<=50) 

** Drop PP respondents (see working paper for results with PP respondents):
keep if ri

** Unertainty xi terms:
sum vara, d
gen unc = vara>=r(p50) if vara!=.
gen uncXtreated = unc * treated
gen uncXgapXri = gapXri * unc
gen uncXgapXpp = gapXpp * unc
gen uncXfemXgapXri = unc * femXgapXri
gen uncXincover75XgapXri = unc * incover75XgapXri
gen uncXcollegeXgapXri = unc * collegeXgapXri
gen uncXhighfinlitXgapXri = unc * highfinlitXgapXri
gen uncXage55andupXgapXri = unc * age55andupXgapXri
gen uncXfem = unc * fem
gen uncXincover75 = unc * incover75
gen uncXcollege = unc * college
gen uncXhighfinlit = unc * highfinlit
gen uncXage55andup = unc * age55andup
gen uncXmaleXgapXri = unc * maleXgapXri
gen uncXincunder75XgapXri = unc * incunder75XgapXri
gen uncXnocollegeXgapXri = unc * nocollegeXgapXri
gen uncXlofinlitXgapXri = unc * lofinlitXgapXri
gen uncXageunder55XgapXri = unc * ageunder55XgapXri

**SAVE:
save Output\mastercleaned, replace


*********************************************************
** PART THREE: REGRESSION TABLES / SUMMARY STAT TABLES **
*********************************************************

	* * * * * *
	* Table 1 *
	* * * * * *

preserve

** Recode control-group perception gaps from zero to real values:
replace gap = 1.96 - belief_spf if randomscreen2==4 & spf==1
replace gap = 1.39 - belief_food if randomscreen2==4 & food==1

gen pf1_non_rev = pf_revision1==0 if pf_revision1!=.

if "`version'"=="interval" {
	replace gap = 0 if spf & (belief_spf >= 1.19 & belief_spf<=3.03) /* & control==0 */
	replace gap = 3.03 - belief_spf if spf & belief_spf>3.03 & belief_spf!=. /* & control==0 */
	replace gap = 1.19 - belief_spf if spf & belief_spf<1.19 /* & control==0 */
	}

table treatment_string, contents(mean base_pf_RI1 mean pf_revision1 mean abs_pf_revision1)
table treatment_string, contents(median base_pf_RI1 median pf_revision1 median abs_pf_revision1)
table treatment_string, contents(mean gap median gap)
table treatment_string, contents(mean pf1_non_rev)
table treatment_string if pf1_non_rev==0, contents(mean gap median gap)
table treatment_string if pf1_non_rev==1, contents(mean gap median gap)
table treatment_string, contents(n pf_revision1)

ttest base_pf_RI1 if treatment=="spf" & question=="RI", by(treated)
ttest base_pf_RI1 if treatment=="food" & question=="RI", by(treated)
median base_pf_RI1 if treatment=="spf" & question=="RI", by(treated)
median base_pf_RI1 if treatment=="food" & question=="RI", by(treated)

ttest pf_revision1 if treatment=="spf" & question=="RI", by(treated)
ttest pf_revision1 if treatment=="food" & question=="RI", by(treated)
median pf_revision1 if treatment=="spf" & question=="RI", by(treated)
median pf_revision1 if treatment=="food" & question=="RI", by(treated)

ttest abs_pf_revision1 if treatment=="spf" & question=="RI", by(treated)
ttest abs_pf_revision1 if treatment=="food" & question=="RI", by(treated)
median abs_pf_revision1 if treatment=="spf" & question=="RI", by(treated)
median abs_pf_revision1 if treatment=="food" & question=="RI", by(treated)

tab pf1_non_rev treated if treatment=="spf" & question=="RI", chi2
tab pf1_non_rev treated if treatment=="food" & question=="RI", chi2

ttest gap if treatment=="spf" & question=="RI", by(treated)
ttest gap if treatment=="food" & question=="RI", by(treated)
median gap if treatment=="spf" & question=="RI", by(treated)
median gap if treatment=="food" & question=="RI", by(treated)

ttest gap if treated==0 & treatment=="spf" & question=="RI", by(pf1_non_rev)
median gap if treated==0 & treatment=="spf" & question=="RI", by(pf1_non_rev)
ttest gap if treated==0 & treatment=="food" & question=="RI", by(pf1_non_rev)
median gap if treated==0 & treatment=="food" & question=="RI", by(pf1_non_rev)
ttest gap if treated==1 & treatment=="spf" & question=="RI", by(pf1_non_rev)
median gap if treated==1 & treatment=="spf" & question=="RI", by(pf1_non_rev)
ttest gap if treated==1 & treatment=="food" & question=="RI", by(pf1_non_rev)
median gap if treated==1 & treatment=="food" & question=="RI", by(pf1_non_rev)

restore

	* * * * * *
	* Table 2 *
	* * * * * *

eststo clear
foreach rev in pf_revision1 dens_revision pf_revision3 {
	eststo: reg `rev' riXtreated gapXri if ri==1 & treatment=="food", robust
	eststo: reg `rev' riXtreated gapXri if ri==1 & treatment=="spf", robust
	}
eststo: reg pf_revision1 riXtreated gapXri uncXgapXri unc uncXtreated if ri==1 & treatment=="food", robust
eststo: reg pf_revision1 riXtreated gapXri uncXgapXri unc uncXtreated if ri==1 & treatment=="spf", robust		
test gapXri = uncXgapXri
esttab using Output\Table2.csv, se replace star(* 0.10 ** 0.05 *** 0.01) r2
	
	* * * * * *
	* Table 3 *
	* * * * * *

** Note this table is limited to non-controls except in the "control" column

preserve

gen expec_in_tail = .
replace expec_in_tail = 0 if (base_pf_PP1>=0 & base_pf_PP1<5 & pp) | (base_pf_RI1>=0 & base_pf_RI1<5 & ri)
replace expec_in_tail = 1 if (base_pf_PP1>=5 & pp) | (base_pf_RI1>=5 & ri)

** Recode control-group perception gaps from zero to real values:
replace gap = 1.39 - belief_food if randomscreen2==4 & food==1
replace gap = 1.96 - belief_spf if randomscreen2==4 & spf==1

if "`version'"=="interval" {
	replace gap = 0 if spf & (belief_spf >= 1.19 & belief_spf<=3.03) /* & control==0 */
	replace gap = 3.03 - belief_spf if spf & belief_spf>3.03 & belief_spf!=. /* & control==0 */
	replace gap = 1.19 - belief_spf if spf & belief_spf<1.19 /* & control==0 */
	}

gen pf1_non_rev = pf_revision1==0 if pf_revision1!=.
rename pf1_non_rev nonrevise

table control if question=="RI", contents(n base_pf_RI1 mean base_pf_RI1 median base_pf_RI1)
table fem if question=="RI" & control==0, contents(n base_pf_RI1 mean base_pf_RI1 median base_pf_RI1)
table age55andup if question=="RI" & control==0, contents(n base_pf_RI1 mean base_pf_RI1 median base_pf_RI1)
table highfinlit if question=="RI" & control==0, contents(n base_pf_RI1 mean base_pf_RI1 median base_pf_RI1)
table college if question=="RI" & control==0, contents(n base_pf_RI1 mean base_pf_RI1 median base_pf_RI1)
table incover75 if question=="RI" & control==0, contents(n base_pf_RI1 mean base_pf_RI1 median base_pf_RI1)

table control if question=="RI", contents(mean expec_in_tail)
table fem if question=="RI" & control==0, contents(mean expec_in_tail)
table age55andup if question=="RI" & control==0, contents(mean expec_in_tail)
table highfinlit if question=="RI" & control==0, contents(mean expec_in_tail)
table college if question=="RI" & control==0, contents(mean expec_in_tail)
table incover75 if question=="RI" & control==0, contents(mean expec_in_tail)

table control if food==1 & question=="RI", contents(mean gap sd gap)
table fem if food==1 & question=="RI" & control==0, contents(mean gap sd gap)
table age55andup if food==1 & question=="RI" & control==0, contents(mean gap sd gap)
table highfinlit if food==1 & question=="RI" & control==0, contents(mean gap sd gap)
table college if food==1 & question=="RI" & control==0, contents(mean gap sd gap)
table incover75 if food==1 & question=="RI" & control==0, contents(mean gap sd gap)

table control if spf==1 & question=="RI", contents(mean gap sd gap)
table fem if spf==1 & question=="RI" & control==0, contents(mean gap sd gap)
table age55andup if spf==1 & question=="RI" & control==0, contents(mean gap sd gap)
table highfinlit if spf==1 & question=="RI" & control==0, contents(mean gap sd gap)
table college if spf==1 & question=="RI" & control==0, contents(mean gap sd gap)
table incover75 if spf==1 & question=="RI" & control==0, contents(mean gap sd gap)

table control if question=="RI", contents(mean vara sd vara)
table fem if question=="RI" & control==0, contents(mean vara sd vara)
table age55andup if question=="RI" & control==0, contents(mean vara sd vara)
table highfinlit if question=="RI" & control==0, contents(mean vara sd vara)
table college if question=="RI" & control==0, contents(mean vara sd vara)
table incover75 if question=="RI" & control==0, contents(mean vara sd vara)

table control if question=="RI", contents(mean pf_revision1 median pf_revision1 sd pf_revision1)
table fem if question=="RI" & control==0, contents(mean pf_revision1 median pf_revision1 sd pf_revision1)
table age55andup if question=="RI" & control==0, contents(mean pf_revision1 median pf_revision1 sd pf_revision1)
table highfinlit if question=="RI" & control==0, contents(mean pf_revision1 median pf_revision1 sd pf_revision1)
table college if question=="RI" & control==0, contents(mean pf_revision1 median pf_revision1 sd pf_revision1)
table incover75 if question=="RI" & control==0, contents(mean pf_revision1 median pf_revision1 sd pf_revision1)

table control if question=="RI", contents(mean end_pf_RI1 median end_pf_RI1)
table fem if question=="RI" & control==0, contents(mean end_pf_RI1 median end_pf_RI1)
table age55andup if question=="RI" & control==0, contents(mean end_pf_RI1 median end_pf_RI1)
table highfinlit if question=="RI" & control==0, contents(mean end_pf_RI1 median end_pf_RI1)
table college if question=="RI" & control==0, contents(mean end_pf_RI1 median end_pf_RI1)
table incover75 if question=="RI" & control==0, contents(mean end_pf_RI1 median end_pf_RI1)

table control if question=="RI", contents(mean nonrevise)
table fem if question=="RI" & control==0, contents(mean nonrevise)
table age55andup if question=="RI" & control==0, contents(mean nonrevise)
table highfinlit if question=="RI" & control==0, contents(mean nonrevise)
table college if question=="RI" & control==0, contents(mean nonrevise)
table incover75 if question=="RI" & control==0, contents(mean nonrevise)

table control if question=="RI", contents(sd base_pf_RI1 sd end_pf_RI1)
table fem if question=="RI" & control==0, contents(sd base_pf_RI1 sd end_pf_RI1)
table age55andup if question=="RI" & control==0, contents(sd base_pf_RI1 sd end_pf_RI1)
table highfinlit if question=="RI" & control==0, contents(sd base_pf_RI1 sd end_pf_RI1)
table college if question=="RI" & control==0, contents(sd base_pf_RI1 sd end_pf_RI1)
table incover75 if question=="RI" & control==0, contents(sd base_pf_RI1 sd end_pf_RI1)

ttest base_pf_RI1 if question=="RI" & control==0, by(fem)
ttest base_pf_RI1 if question=="RI" & control==0, by(age55andup)
ttest base_pf_RI1 if question=="RI" & control==0, by(highfinlit)
ttest base_pf_RI1 if question=="RI" & control==0, by(college)
ttest base_pf_RI1 if question=="RI" & control==0, by(incover75)

median base_pf_RI1 if question=="RI" & control==0, by(fem)
median base_pf_RI1 if question=="RI" & control==0, by(age55andup)
median base_pf_RI1 if question=="RI" & control==0, by(highfinlit)
median base_pf_RI1 if question=="RI" & control==0, by(college)
median base_pf_RI1 if question=="RI" & control==0, by(incover75)

tab expec_in_tail fem if question=="RI" & control==0, chi2
tab expec_in_tail age55andup if question=="RI" & control==0, chi2
tab expec_in_tail highfinlit if question=="RI" & control==0, chi2
tab expec_in_tail college if question=="RI" & control==0, chi2
tab expec_in_tail incover75 if question=="RI" & control==0, chi2

ttest gap if food==1 & question=="RI" & control==0, by(fem)
ttest gap if food==1 & question=="RI" & control==0, by(age55andup)
ttest gap if food==1 & question=="RI" & control==0, by(highfinlit)
ttest gap if food==1 & question=="RI" & control==0, by(college)
ttest gap if food==1 & question=="RI" & control==0, by(incover75)

ttest gap if spf==1 & question=="RI" & control==0, by(fem)
ttest gap if spf==1 & question=="RI" & control==0, by(age55andup)
ttest gap if spf==1 & question=="RI" & control==0, by(highfinlit)
ttest gap if spf==1 & question=="RI" & control==0, by(college)
ttest gap if spf==1 & question=="RI" & control==0, by(incover75)

ttest vara if question=="RI" & control==0, by(fem)
ttest vara if question=="RI" & control==0, by(age55andup)
ttest vara if question=="RI" & control==0, by(highfinlit)
ttest vara if question=="RI" & control==0, by(college)
ttest vara if question=="RI" & control==0, by(incover75)

ttest pf_revision1 if question=="RI" & control==0, by(fem)
ttest pf_revision1 if question=="RI" & control==0, by(age55andup)
ttest pf_revision1 if question=="RI" & control==0, by(highfinlit)
ttest pf_revision1 if question=="RI" & control==0, by(college)
ttest pf_revision1 if question=="RI" & control==0, by(incover75)

median pf_revision1 if question=="RI" & control==0, by(fem)
median pf_revision1 if question=="RI" & control==0, by(age55andup)
median pf_revision1 if question=="RI" & control==0, by(highfinlit)
median pf_revision1 if question=="RI" & control==0, by(college)
median pf_revision1 if question=="RI" & control==0, by(incover75)

ttest end_pf_RI1 if question=="RI" & control==0, by(fem)
ttest end_pf_RI1 if question=="RI" & control==0, by(age55andup)
ttest end_pf_RI1 if question=="RI" & control==0, by(highfinlit)
ttest end_pf_RI1 if question=="RI" & control==0, by(college)
ttest end_pf_RI1 if question=="RI" & control==0, by(incover75)

median end_pf_RI1 if question=="RI" & control==0, by(fem)
median end_pf_RI1 if question=="RI" & control==0, by(age55andup)
median end_pf_RI1 if question=="RI" & control==0, by(highfinlit)
median end_pf_RI1 if question=="RI" & control==0, by(college)
median end_pf_RI1 if question=="RI" & control==0, by(incover75)

tab nonrevise fem if question=="RI" & control==0, chi2
tab nonrevise age55andup if question=="RI" & control==0, chi2
tab nonrevise highfinlit if question=="RI" & control==0, chi2
tab nonrevise college if question=="RI" & control==0, chi2
tab nonrevise incover75 if question=="RI" & control==0, chi2

ksmirnov base_pf_RI1 if question=="RI" & control==0, by(fem) exact
ksmirnov base_pf_RI1 if question=="RI" & control==0, by(age55andup) exact
ksmirnov base_pf_RI1 if question=="RI" & control==0, by(highfinlit) exact
ksmirnov base_pf_RI1 if question=="RI" & control==0, by(college) exact
ksmirnov base_pf_RI1 if question=="RI" & control==0, by(incover75) exact

ksmirnov end_pf_RI1 if question=="RI" & control==0, by(fem) exact
ksmirnov end_pf_RI1 if question=="RI" & control==0, by(age55andup) exact
ksmirnov end_pf_RI1 if question=="RI" & control==0, by(highfinlit) exact
ksmirnov end_pf_RI1 if question=="RI" & control==0, by(college) exact
ksmirnov end_pf_RI1 if question=="RI" & control==0, by(incover75) exact

restore

preserve

rename base_pf_RI1 pf_RI1_init
rename end_pf_RI1 pf_RI1_end
keep prim_key question fem age55andup highfinlit college incover75 all pf_RI1_init pf_RI1_end control
reshape long pf_RI1, i(prim_key question fem age55andup highfinlit college incover75 all control) j(stage) string
gen init = stage=="_init"
ksmirnov pf_RI1 if question=="RI" & control==0, by(init) exact
ksmirnov pf_RI1 if question=="RI" & control==1, by(init) exact
ksmirnov pf_RI1 if question=="RI" & fem==0 & control==0, by(init) exact
ksmirnov pf_RI1 if question=="RI" & fem==1 & control==0, by(init) exact
ksmirnov pf_RI1 if question=="RI" & age55andup==0 & control==0, by(init) exact
ksmirnov pf_RI1 if question=="RI" & age55andup==1 & control==0, by(init) exact
ksmirnov pf_RI1 if question=="RI" & highfinlit==0 & control==0, by(init) exact
ksmirnov pf_RI1 if question=="RI" & highfinlit==1 & control==0, by(init) exact
ksmirnov pf_RI1 if question=="RI" & college==0 & control==0, by(init) exact
ksmirnov pf_RI1 if question=="RI" & college==1 & control==0, by(init) exact
ksmirnov pf_RI1 if question=="RI" & incover75==0 & control==0, by(init) exact
ksmirnov pf_RI1 if question=="RI" & incover75==1 & control==0, by(init) exact

restore

	* * * * * *
	* Table 4 *
	* * * * * *

eststo clear
	eststo: reg pf_revision1 riXtreated femXtreated femXri maleXgapXri femXgapXri if ri==1 & treatment=="food", robust
	test maleXgapXri = femXgapXri 
	eststo: reg pf_revision1 riXtreated femXtreated femXri maleXgapXri femXgapXri if ri==1 & treatment=="spf", robust
	test maleXgapXri = femXgapXri 
	eststo: reg pf_revision1 riXtreated incover75Xtreated incover75Xri incunder75XgapXri incover75XgapXri if ri==1 & treatment=="food", robust
	test incunder75XgapXri = incover75XgapXri 
	eststo: reg pf_revision1 riXtreated incover75Xtreated incover75Xri incunder75XgapXri incover75XgapXri if ri==1 & treatment=="spf", robust
	test incunder75XgapXri = incover75XgapXri 
	eststo: reg pf_revision1 riXtreated collegeXtreated collegeXri nocollegeXgapXri collegeXgapXri if ri==1 & treatment=="food", robust
	test nocollegeXgapXri = collegeXgapXri
	eststo: reg pf_revision1 riXtreated collegeXtreated collegeXri nocollegeXgapXri collegeXgapXri if ri==1 & treatment=="spf", robust
	test nocollegeXgapXri = collegeXgapXri
	eststo: reg pf_revision1 riXtreated highfinlitXtreated highfinlitXri lofinlitXgapXri highfinlitXgapXri if ri==1 & treatment=="food", robust
	test lofinlitXgapXri = highfinlitXgapXri
	eststo: reg pf_revision1 riXtreated highfinlitXtreated highfinlitXri lofinlitXgapXri highfinlitXgapXri if ri==1 & treatment=="spf", robust
	test lofinlitXgapXri = highfinlitXgapXri
	eststo: reg pf_revision1 riXtreated age55andupXtreated age55andupXri ageunder55XgapXri age55andupXgapXri if ri==1 & treatment=="food", robust
	test ageunder55XgapXri = age55andupXgapXri 
	eststo: reg pf_revision1 riXtreated age55andupXtreated age55andupXri ageunder55XgapXri age55andupXgapXri if ri==1 & treatment=="spf", robust
	test ageunder55XgapXri = age55andupXgapXri 
	eststo: reg pf_revision1 riXtreated affectedXtreated affectedXri noaffectedXgapXri affectedXgapXri if ri==1 & treatment=="food", robust
	test noaffectedXgapXri = affectedXgapXri 
	eststo: reg pf_revision1 riXtreated affectedXtreated affectedXri noaffectedXgapXri affectedXgapXri if ri==1 & treatment=="spf", robust
	test noaffectedXgapXri = affectedXgapXri 
esttab using Output\Table4.csv, se replace star(* 0.10 ** 0.05 *** 0.01) r2

	* * * * * *
	* Table 5 *
	* * * * * *

preserve

gen delta_var = varb - vara
egen med_delta_var = median(delta_var)
gen hi_delta_var = delta_var>med_delta_var if delta_var!=.
drop med_delta_var
rename dens_revision densmean_rev
gen densmedian_rev = medianb - mediana

eststo clear
eststo: reg pf_revision1 densmean_rev, robust
test densmean_rev==1
eststo: reg pf_revision1 densmean_rev delta_var, robust
test densmean_rev==1
test (densmean_rev==1) (delta_var==0)
eststo: reg pf_revision1 densmedian_rev, robust
test densmedian_rev==1
eststo: reg pf_revision1 densmedian_rev delta_var, robust
test densmedian_rev==1
test (densmedian_rev==1) (delta_var==0)
esttab using Output\Table5.csv, se replace star(* 0.10 ** 0.05 *** 0.01) r2

restore

	* * * * * * * * * * *
	* Appendix Table A1 *
	* * * * * * * * * * *

eststo clear
eststo: reg log_info_belief food fem femXfood if ri==1, robust
test fem femXfood
eststo: reg log_info_belief food age55andup age55andupXfood if ri==1, robust
test age55andup age55andupXfood
eststo: reg log_info_belief food highfinlit highfinlitXfood if ri==1, robust
test highfinlit highfinlitXfood
eststo: reg log_info_belief food college collegeXfood if ri==1, robust
test college collegeXfood
eststo: reg log_info_belief food incover75 incover75Xfood if ri==1, robust
test incover75 incover75Xfood
eststo: reg log_info_belief food fem femXfood age55andup age55andupXfood highfinlit highfinlitXfood college collegeXfood incover75 incover75Xfood if ri==1, robust
test fem femXfood age55andup age55andupXfood highfinlit highfinlitXfood college collegeXfood incover75 incover75Xfood 
esttab using Output\TableA1.csv, se replace star(* 0.10 ** 0.05 *** 0.01) r2

	* * * * * * * * * * *
	* Appendix Table A2 *
	* * * * * * * * * * *

eststo clear

eststo: reg pf_revision1 riXtreated unc uncXtreated femXri femXtreated uncXfem femXgapXri maleXgapXri uncXfemXgapXri uncXmaleXgapXri if ri==1 & treatment=="food", robust
eststo: reg pf_revision1 riXtreated unc uncXtreated femXri femXtreated uncXfem femXgapXri maleXgapXri uncXfemXgapXri uncXmaleXgapXri if ri==1 & treatment=="spf", robust
eststo: reg pf_revision1 riXtreated unc uncXtreated femXri femXtreated uncXfem uncXgapXri femXgapXri maleXgapXri uncXfemXgapXri if ri==1 & treatment=="food", robust
eststo: reg pf_revision1 riXtreated unc uncXtreated femXri femXtreated uncXfem uncXgapXri femXgapXri maleXgapXri uncXfemXgapXri if ri==1 & treatment=="spf", robust
eststo: reg pf_revision1 riXtreated unc uncXtreated femXri femXtreated femXgapXri maleXgapXri uncXfemXgapXri uncXmaleXgapXri if ri==1 & treatment=="food", robust
eststo: reg pf_revision1 riXtreated unc uncXtreated femXri femXtreated femXgapXri maleXgapXri uncXfemXgapXri uncXmaleXgapXri if ri==1 & treatment=="spf", robust
eststo: reg pf_revision1 riXtreated unc uncXtreated femXri femXtreated uncXgapXri femXgapXri maleXgapXri uncXfemXgapXri if ri==1 & treatment=="food", robust
eststo: reg pf_revision1 riXtreated unc uncXtreated femXri femXtreated uncXgapXri femXgapXri maleXgapXri uncXfemXgapXri if ri==1 & treatment=="spf", robust	
eststo: reg pf_revision1 riXtreated unc uncXtreated femXri femXtreated uncXfem uncXgapXri femXgapXri maleXgapXri if ri==1 & treatment=="food", robust
eststo: reg pf_revision1 riXtreated unc uncXtreated femXri femXtreated uncXfem uncXgapXri femXgapXri maleXgapXri if ri==1 & treatment=="spf", robust
eststo: reg pf_revision1 riXtreated unc uncXtreated femXri femXtreated uncXgapXri femXgapXri maleXgapXri if ri==1 & treatment=="food", robust
eststo: reg pf_revision1 riXtreated unc uncXtreated femXri femXtreated uncXgapXri femXgapXri maleXgapXri if ri==1 & treatment=="spf", robust	

esttab using Output\TableA2.csv, se replace star(* 0.10 ** 0.05 *** 0.01) r2
	
*****************************************************
** PART FOUR: RESULTS FOR PAPER TEXT AND FOOTNOTES **
*****************************************************

** Free-response answers:
outsheet e4_prices e4_inflation using Output\openanswertexts.csv, comma replace

** Perception gap distributions
preserve
replace gap = 1.39 - belief_food if randomscreen2==4 & food==1
replace gap = 1.96 - belief_spf if randomscreen2==4 & spf==1
if "`version'"=="interval" {
	replace gap = 0 if spf & (belief_spf >= 1.19 & belief_spf<=3.03)
	replace gap = 3.03 - belief_spf if spf & belief_spf>3.03 & belief_spf!=.
	replace gap = 1.19 - belief_spf if spf & belief_spf<1.19
	}
sum gap if ri==1 & spf==1 & control==0, d
sum gap if ri==1 & food==1 & control==0, d
sum gap if ri==1 & spf==1, d
sum gap if ri==1 & food==1, d
restore

** Distribution of expectations:
sum base_pf_PP1, d
sum base_pf_RI1, d

** Distribution of non-updaters in shaded and unshaded quadrants (Fig 2):
preserve
replace gap = 1.39 - belief_food if randomscreen2==4 & food==1
replace gap = 1.96 - belief_spf if randomscreen2==4 & spf==1
if "`version'"=="interval" {
	replace gap = 0 if spf & (belief_spf >= 1.19 & belief_spf<=3.03) /* & control==0 */
	replace gap = 3.03 - belief_spf if spf & belief_spf>3.03 & belief_spf!=. /* & control==0 */
	replace gap = 1.19 - belief_spf if spf & belief_spf<1.19 /* & control==0 */
	}
gen sensible = gap * pf_revision1 > 0 if pf_revision1!=0
bysort food control: sum sensible
restore

** Changes in individual uncertainty:
preserve
replace gap = 1.39 - belief_food if randomscreen2==4 & food==1
replace gap = 1.96 - belief_spf if randomscreen2==4 & spf==1
if "`version'"=="interval" {
	replace gap = 0 if spf & (belief_spf >= 1.19 & belief_spf<=3.03) /* & control==0 */
	replace gap = 3.03 - belief_spf if spf & belief_spf>3.03 & belief_spf!=. /* & control==0 */
	replace gap = 1.19 - belief_spf if spf & belief_spf<1.19 /* & control==0 */
	}
gen low_gap = abs(gap)<=2 if gap
table low_gap control, contents(mean vara mean varb)
restore

** Forecast accuracy:
preserve
local realized_spf = 2.93
gen base_accurate = abs(base_pf_PP1-`realized_spf')<1 if base_pf_PP1!=.
replace base_accurate = abs(base_pf_RI1-`realized_spf')<1 if base_pf_RI1!=.
gen end_accurate = abs(end_pf_PP1-`realized_spf')<1 if end_pf_PP1!=.
replace end_accurate = abs(end_pf_RI1-`realized_spf')<1 if end_pf_RI1!=.
gen acc_change = end_accurate - base_accurate
sum base_accurate if !control
sum end_accurate if !control
restore

** Gender differences in info sources and strength of priors:
egen source_weight = rowtotal(b4_a- b4_g)
gen shop_pref = b4_g / source_weight
gen tv_pref = b4_a / source_weight
gen paper_pref = b4_b / source_weight
gen famfriends = b4_f / source_weight
gen groceries=b3_l==7
foreach pref in shop_pref tv_pref paper_pref famfriends groceries {
	ttest `pref', by(fem)
	}
bysort question: ttest vara, by(fem)
bysort question: ttest varb, by(fem)

** Non-updater regression analysis:
preserve
gen non_revise = .
gen riXspf = ri * spf
	foreach x in 0 10 20 {
	replace non_revise = pf_revision1==0 if abs_gap>`x'/10 & !control
	reg non_revise riXfood fem age55andup incunder75 highfinlit college, robust
	foreach pref in shop_pref tv_pref paper_pref famfriends {
		ttest `pref', by(non_revise)
		}
	replace non_revise = .
	}	
replace non_revise = pf_revision1==0 if abs_gap>1 & !control
restore

** Correlations of Table 4 regressors
corr fem college incover75 highfinlit age55andup

** Gap between density and PF forecasts:
preserve
gen base_pf_dens_gap = base_pf_RI1 - meana
replace base_pf_dens_gap = base_pf_PP1 - meana if base_pf_dens_gap==.
count if meana==.
gen end_pf_dens_gap = end_pf_RI1 - meanb
replace  end_pf_dens_gap = end_pf_PP1 - meanb if end_pf_dens_gap==.
count if meanb==.
gen base_pf_dens_gap2 = base_pf_RI1 - mediana
replace base_pf_dens_gap2 = base_pf_PP1 - mediana if base_pf_dens_gap2==.
count if mediana==.
gen end_pf_dens_gap2 = end_pf_RI1 - medianb
replace end_pf_dens_gap2 = end_pf_PP1 - medianb if end_pf_dens_gap2==.
count if medianb==.
tab base_pf_dens_gap
tab end_pf_dens_gap
sum base_pf_dens_gap end_pf_dens_gap
tab base_pf_dens_gap2
tab end_pf_dens_gap2
sum base_pf_dens_gap2 end_pf_dens_gap2
gen base_gap_sign = base_pf_dens_gap / abs(base_pf_dens_gap)
gen end_gap_sign = end_pf_dens_gap / abs(end_pf_dens_gap)
gen base_gap_sign2 = base_pf_dens_gap2 / abs(base_pf_dens_gap2)
gen end_gap_sign2 = end_pf_dens_gap2 / abs(end_pf_dens_gap2)
replace base_gap_sign = 0 if abs(base_pf_dens_gap)<1
replace end_gap_sign = 0 if abs(end_pf_dens_gap)<1
replace base_gap_sign2 = 0 if abs(base_pf_dens_gap2)<1
replace end_gap_sign2 = 0 if abs(end_pf_dens_gap2)<1
tab base_gap_sign end_gap_sign
tab base_gap_sign end_gap_sign if meana!=meanb | base_pf_RI1!=end_pf_RI1
tab base_gap_sign2 end_gap_sign2
tab base_gap_sign2 end_gap_sign2 if mediana!=medianb | base_pf_RI1!=end_pf_RI1
restore

************************
** PART FIVE: FIGURES **
************************

	* * * * *
	* Fig 2 *
	* * * * *

use Output\mastercleaned, clear

** Create non-zero perception gaps for control group respondents
replace gap = 1.39 - belief_food if randomscreen2==4 & food==1
replace gap = 1.96 - belief_spf if randomscreen2==4 & food==0 

** Collapse by deciles
drop if abs(gap)>=20
forval p = 10(10)90 {
	egen p`p' = pctile(gap), p(`p') by(treatment question control)
	}
	
** Fit splines
locpoly pf_revision1 gap if /* gap+3.25>=p10 & gap-3.25<=p90 & */ ri & control & spf, gen(xfit_CRcont yfit_CRcont) width(3.25) nograph adoonly
locpoly pf_revision1 gap if /* gap+3.25>=p10 & gap-3.25<=p90 & */ ri & control & food, gen(xfit_FRcont yfit_FRcont) width(3.25) nograph adoonly
locpoly pf_revision1 gap if /* gap+3.25>=p10 & gap-3.25<=p90 & */ ri & !control & spf, gen(xfit_CRinfo yfit_CRinfo) width(3.25) nograph adoonly
locpoly pf_revision1 gap if /* gap+3.25>=p10 & gap-3.25<=p90 & */ ri & !control & food, gen(xfit_FRinfo yfit_FRinfo) width(3.25) nograph adoonly

** Save spline fits
preserve
keep *fit* treatment question control
gen id = _n
reshape long xfit yfit, i(id) j(tmt) string
replace control = .
replace control = strpos(tmt,"cont")>0
replace question = ""
replace question = "RI" if strpos(tmt,"CR")>0 | strpos(tmt,"FR")>0
* replace question = "PP" if strpos(tmt,"CP")>0 | strpos(tmt,"FP")>0
replace treatment = ""
replace treatment = "spf" if strpos(tmt,"CR")>0 /* | strpos(tmt,"CP")>0 */
replace treatment = "food" if strpos(tmt,"FR")>0 /* | strpos(tmt,"FP")>0 */
keep xfit yfit treatment question control
save Output\Fig2splines, replace
restore
drop *fit*

** Label deciles
gen err_decile = .
replace err_decile = 1 if gap < p10
replace err_decile = 2 if gap >= p10 & gap < p20
replace err_decile = 3 if gap >= p20 & gap < p30
replace err_decile = 4 if gap >= p30 & gap < p40
replace err_decile = 5 if gap >= p40 & gap < p50
replace err_decile = 6 if gap >= p50 & gap < p60
replace err_decile = 7 if gap >= p60 & gap < p70
replace err_decile = 8 if gap >= p70 & gap < p80
replace err_decile = 9 if gap >= p80 & gap < p90
replace err_decile = 10 if gap >= p90 & gap != .
keep gap pf_revision1 err_decile treatment question control
collapse gap pf_revision1, by(err_decile treatment question control)

** Create frequency weights for the scatterplots, for number of overlapping deciles
egen decile_group = group(treatment question control)
sort decile_group err_decile
gen count_duples = err_decile[_n]-err_decile[_n-1] if decile_group[_n]==decile_group[_n-1]
replace count_duples = err_decile[_n] if decile_group[_n]!=decile_group[_n-1]

** Create shading for quadrants 1 & 3, with different shading (i.e. different axes ranges) for each panel in the figure
** Note, the "expand 4" command doesn't change the appearance of the scatterplots, but is needed when we collapse by deciles
expand 4
sort treatment question
by treatment question: gen counter=sum(1)
gen y_shade = .
gen x_shade = .
egen y_shade_max = max(pf_revision1), by(treatment question)
egen y_shade_min = min(pf_revision1), by(treatment question)
egen x_shade_max = max(gap), by(treatment question)
egen x_shade_min = min(gap), by(treatment question)
replace y_shade = 5*floor(y_shade_min/5) if counter==1 | counter==2
replace y_shade = 5*ceil(y_shade_max/5) if counter==3 | counter==4
replace y_shade = 5 if y_shade < 5 & (counter==3 | counter==4)
replace x_shade = 5*floor(x_shade_min/5) if counter==1
replace x_shade = 0 if counter==2
replace x_shade = 0 if counter==3
replace x_shade = 5*ceil(x_shade_max/5) if counter==4
replace x_shade = 5 if x_shade < 5 & counter==4
append using Output\Fig2splines
egen xmax = max(x_shade), by(treatment question)
egen xmin = min(x_shade), by(treatment question)
egen ymax = max(y_shade), by(treatment question)
egen ymin = min(y_shade), by(treatment question)
replace y_shade = 6 if y_shade > 0 & (treatment!="spf" | question!="RI")
replace y_shade = -6 if y_shade < 0 & (treatment!="spf" | question!="RI")

** Make plots 
twoway area y_shade x_shade if treatment=="food" & question=="RI", color(gs14) || line yfit xfit if treatment=="food" & question=="RI" & control==0 & yfit>=ymin & yfit<=ymax & xfit>=xmin & xfit <=xmax || scatter pf_revision1 gap [fw=count_duples] if treatment=="food" & question=="RI" & control==0, msize(small) msymbol(circle_hollow) mcolor(gs2) ytitle("Revision") xtitle("Perception Gap") legend(off) yscale(range(-6(1)6)) ylabel(-5 0 5,angle(0))
graph save Output\agg_updating_visFR_nocon, replace
twoway area y_shade x_shade if treatment=="spf" & question=="RI", color(gs14) || line yfit xfit if treatment=="spf" & question=="RI" & control==0 & yfit>=ymin & yfit<=ymax & xfit>=xmin & xfit <=xmax  || scatter pf_revision1 gap [fw=count_duples] if treatment=="spf" & question=="RI" & control==0, msize(small) msymbol(circle_hollow) mcolor(gs2) ytitle("Revision") xtitle("Perception Gap") legend(off) ylabel(,angle(0)) /* yscale(range(-6(1)6)) ylabel(-5 0 5,angle(0)) */
graph save Output\agg_updating_visCR_nocon, replace
twoway area y_shade x_shade if treatment=="food" & question=="RI", color(gs14) || line yfit xfit if treatment=="food" & question=="RI" & control==1 & yfit>=ymin & yfit<=ymax & xfit>=xmin & xfit <=xmax  || scatter pf_revision1 gap [fw=count_duples] if treatment=="food" & question=="RI" & control==1, msize(small) msymbol(circle_hollow) mcolor(gs2) ytitle("Revision") xtitle("Perception Gap") legend(off) yscale(range(-6(1)6)) ylabel(-5 0 5,angle(0))
graph save Output\agg_updating_visFR_con, replace
twoway area y_shade x_shade if treatment=="spf" & question=="RI", color(gs14) || line yfit xfit if treatment=="spf" & question=="RI" & control==1 & yfit>=ymin & yfit<=ymax & xfit>=xmin & xfit <=xmax  || scatter pf_revision1 gap [fw=count_duples] if treatment=="spf" & question=="RI" & control==1, msize(small) msymbol(circle_hollow) mcolor(gs2) ytitle("Revision") xtitle("Perception Gap") legend(off) ylabel(,angle(0)) /* yscale(range(-6(1)6)) ylabel(-5 0 5,angle(0)) */
graph save Output\agg_updating_visCR_con, replace

graph combine Output\agg_updating_visCR_nocon.gph Output\agg_updating_visCR_con.gph, rows(1) title("       SPF", size(medium))
graph save Output\agg_updating_visCR_both, replace
graph export Output\agg_updating_visCR_both.emf, replace

graph combine Output\agg_updating_visFR_nocon.gph Output\agg_updating_visFR_con.gph, rows(1) title("       Food", size(medium))
graph save Output\agg_updating_visFR_both, replace
graph export Output\agg_updating_visFR_both.emf, replace

graph combine Output\agg_updating_visCR_both.gph Output\agg_updating_visFR_both.gph, title({bf:   Treatment Group                Control Group}, size(medium)) rows(2) ysize(20) xsize(15.5) imargin(0 0 0 0) t2title(" ", size(minuscule))
graph export Output\Fig2.emf, replace

use Output\mastercleaned, clear

	* * * * *
	* Fig 3 *
	* * * * *
	
preserve

gen base_pf_RI1_flag0_5 = 0
gen base_pf_RI1_flag5_10 = 0
gen base_pf_RI1_flag10_15 = 0
gen base_pf_RI1_flag15_50 = 0
egen ri_N = total(ri==1 & control==0)

replace base_pf_RI1_flag0_5 = 100/ri_N if base_pf_RI1>=0 & base_pf_RI1<5
replace base_pf_RI1_flag5_10 = 100/ri_N if base_pf_RI1>=5 & base_pf_RI1<10
replace base_pf_RI1_flag10_15 = 100/ri_N if base_pf_RI1>=10 & base_pf_RI1<15
replace base_pf_RI1_flag15_50 = 100/ri_N if base_pf_RI1>=15 & base_pf_RI1<.
gen end_pf_RI1_cat = .
replace end_pf_RI1_cat = 1 if end_pf_RI1>=0 & end_pf_RI1<5
replace end_pf_RI1_cat = 2 if end_pf_RI1>=5 & end_pf_RI1<10
replace end_pf_RI1_cat = 3 if end_pf_RI1>=10 & end_pf_RI1<15
replace end_pf_RI1_cat = 4 if end_pf_RI1>=15 & end_pf_RI1<.
label define pf_cats 1 "[0,5)" 2 "[5,10)" 3 "[10,15)" 4 "15+"
label values end_pf_RI1_cat pf_cats

graph bar (sum) base_pf_RI1_flag* if ri==1 & control==0, over(end_pf_RI1_cat, relabel(1 "[0,5)" 2 "[5,10)" 3 "[10,15)" 4 "15+") sort(end_pf_RI1)) legend(col(1) pos(3) subtitle("Baseline" "Expectations") order(4 3 2 1)) asyvars stack b1title("Final Expectations") l1title("Percent", angle(0)) bar(1, fcolor(gs14) lcolor(black) lwidth(vvthin) fintensity(90)) bar(2, fcolor(gs10) lcolor(black) lwidth(vvthin) fintensity(80)) bar(3, fcolor(gs7) lcolor(black) lwidth(vvthin) fintensity(80)) bar(4, fcolor(gs4) lcolor(black) lwidth(vvthin) fintensity(90)) lintensity(0)
graph export Output\updating_dist.emf, replace

*Who moves where?
tab end_pf_RI1_cat if base_pf_RI1_flag5_10 > 0
**How much updating is there within each of the bars?
gen non_rev = pf_revision1==0 if control==0 & pf_revision1!=.
*Stayed in bar 1:
tab non_rev if base_pf_RI1_flag0_5 > 0 & end_pf_RI1_cat == 1
*Stayed in bar 2:
tab non_rev if base_pf_RI1_flag5_10 > 0 & end_pf_RI1_cat == 2
*Stayed in bar 3:
tab non_rev if base_pf_RI1_flag10_15 > 0 & end_pf_RI1_cat == 3
*Stayed in bar 4:
tab non_rev if base_pf_RI1_flag15_50 > 0 & end_pf_RI1_cat == 4

restore

	* * * * *
	* Fig 4 *
	* * * * *

preserve

** Sample selection: treatment only, [-15,15] for perception gap, [-5,15] for baseline expectation
keep if control==0
keep if abs(gap) <=15
keep if base_pf_RI1<=15 & base_pf_RI1>=-5 

** "mywt" will become the density for the contour plots
gen mywt = 1
collapse (sum) mywt, by(gap base_pf_RI1 food spf)

** Create "dummy" observations with zero density that extend the support of the joint density to the four corners of the plot
count
local newobs = r(N)+8
set obs `newobs'
replace mywt = 0 if mywt==.
gen newobsindex = _n - (`newobs'-8) if mywt == 0 
replace food = 0 if newobsindex>=1 & newobsindex<=4
replace spf = 1 if newobsindex>=1 & newobsindex<=4
replace food = 1 if newobsindex>=5 & newobsindex<=8
replace spf = 0 if newobsindex>=5 & newobsindex<=8
replace gap = -15 if newobsindex==1 | newobsindex==2 | newobsindex==5 | newobsindex==6
replace gap = 15 if newobsindex==3 | newobsindex==4 | newobsindex==7 | newobsindex==8
replace base_pf_RI1 = -5 if newobsindex==1 | newobsindex==3 | newobsindex==5 | newobsindex==7
replace base_pf_RI1 = 15 if newobsindex==2 | newobsindex==4 | newobsindex==6 | newobsindex==8

** Normalize the density to integrate to 1 in each treatment:
egen wt_denom = total(mywt), by(spf)
replace mywt = mywt / wt_denom

** Put the dummy densities just slightly below zero to give them a different color in the plot
replace mywt = -.001 if mywt==-.1
drop newobsindex wt_denom
label variable mywt "Density"

** Finally, make the plots:
** There are occasional bugs with the Stata "contour" command so the following lines are commented out for stability:
*twoway contour mywt gap base_pf_RI1 if spf, minmax yscale(range(-15(5)15)) ylabel(-15(5)15) xtitle("Baseline Expectation") ytitle("Perception Gap") ccuts(.0 .01 .02 .03 .04 .05 .06 .07 .08 .09 .10 .11 .12) ccolors(gs16 gs15 gs14 gs12 gs11 gs10 gs9 gs8 gs7 gs6 gs5 gs4 gs2 gs0) title("SPF Treatment")
*graph save Output\contour_spf, replace
*graph export Output\contour_spf.emf, replace
*twoway contour mywt gap base_pf_RI1 if food, minmax yscale(range(-15(5)15)) ylabel(-15(5)15) xtitle("Baseline Expectation") ytitle("Perception Gap") ccuts(.0 .01 .02 .03 .04 .05 .06 .07 .08 .09 .10 .11 .12) ccolors(gs16 gs15 gs14 gs12 gs11 gs10 gs9 gs8 gs7 gs6 gs5 gs4 gs2 gs0) title("Food Treatment")
*graph save Output\contour_food, replace
*graph export Output\contour_food.emf, replace

restore

