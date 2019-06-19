***********************************************************************************
*** ANALYSIS_GARSHEM.DO -- REGRESSIONS AT GARSHEM LEVEL.			***
***********************************************************************************

clear all
set mem 400m

capture log close
set more off
log using "analysis_garshem.$S_DATE.log", replace

use "s_rates_by_garshem_wo0geos_wo1.dta", clear

/// Obtain county(geo)-level pop shares by race and age (note these are really shares of pop aged 20 to 64)
drop if hispanic==1
collapse pop, by(geo race)
reshape wide pop, i(geo) j(race_3)
gen racshrot = pop2/(pop1+pop2+pop3)
gen racshrbl = pop3/(pop1+pop2+pop3)
keep geo racshrot racshrbl
sort geo
save raceshr, replace
use "s_rates_by_garshem_wo0geos_wo1.dta", clear
drop if hispanic==1
collapse pop, by(geo age)
reshape wide pop, i(geo) j(age)
gen ageshr20_34 = (pop4+pop5)/(pop4+pop5+pop6+pop7+pop8)
gen ageshr35_54 = (pop6+pop7)/(pop4+pop5+pop6+pop7+pop8)
gen ageshr55_ = (pop8)/(pop4+pop5+pop6+pop7+pop8)
keep geo ageshr*
sort geo
save ageshr, replace
use "s_rates_by_garshem_wo0geos_wo1.dta", clear
sort geo
merge geo using ageshr
drop _merge
sort geo
merge geo using raceshr
drop _merge

/// Generate Categorical Family Income Variables
gen fminc90 = .
replace fminc90 = 1 if meanfinc1 < 10000
replace fminc90 = 2 if inrange(meanfinc1,10000,19999)
replace fminc90 = 3 if inrange(meanfinc1,20000,39999)
replace fminc90 = 4 if inrange(meanfinc1,40000,60000)
replace fminc90 = 5 if meanfinc1 > 60000

/// Generate Shares for Omitted Categories
gen raceOM = 1 - _Irace_3_2 - _Irace_3_3
gen ageOM = 1 - _Iage_5 - _Iage_6 - _Iage_7 - _Iage_4
gen educOM = 1 - _Ieduc_1 - _Ieduc_3 - _Ieduc_4 - _Ieduc_5 - _Ieduc_6
gen marstOM = 1 - _Imarst_3 - _Imarst_5 - _Imarst_6

/// Table B2. Summary Statistics
sum s_rate sex female _I* raceOM ageOM educOM marstOM hispanic meanfinc1 meanfinc2 meanfinc3 meanfinc4 firearmsharesuicide unemp_ip home1 vietnamvet if hispanic~=1 [aw=nobs1], detail

/// Table 1. Suicide Rates by Category
bysort age: sum s_rate [aw=pop]
bysort race_3: sum s_rate [aw=pop]
bysort sex: sum s_rate [aw=pop]
bysort educ: sum s_rate [aw=pop]
bysort marst: sum s_rate [aw=pop]
bysort fminc90: sum s_rate [aw=pop]
pwcorr meanfinc1 meanfinc2 meanfinc3 meanfinc4, sig obs


/////////////////////// REGRESSIONS USING 1990 CROSS SECTION ///////////////////////////////////////////
char fminc90[omit] 5
xi i.race_3 i.age i.marst i.educ i.fminc90 i.statefip

/// Table 5, Column 1
blogit s_freq nobs1 female _Irace* _Iage* _Imarst* lmeanfinc1 _Ist* if hispanic==0, robust cluster(statefip)
*codebook geo if e(sample)

/// Table 5, Column 2
blogit s_freq nobs1 female _Irace* _Iage* _Imarst* _Ifminc90_* _Ist* if hispanic==0, robust cluster(statefip)

/// Table 5, Column 3
blogit s_freq nobs1 female _Irace* _Iage* _Imarst* _Ifminc90_* lmeanfinc2 _Ist* if hispanic==0, robust cluster(statefip)

/// Table 5, Column 4 AND Table 6, Column 1 AND Table 7, Column 1
blogit s_freq nobs1 female _Irace* _Iage* _Imarst* _Ifminc90_* lmeanfinc2 ageshr* racshr* _Ist* if hispanic==0, robust cluster(statefip)

/// Table 7, Column 2
blogit s_freq nobs1 female _Irace* _Iage* _Imarst* _Ifminc90_* lmeanfinc3 ageshr* racshr* _Ist* if hispanic==0, robust cluster(statefip)

/// Table 7, Column 3
blogit s_freq nobs1 female _Irace* _Iage* _Imarst* _Ifminc90_* lmeanfinc4 ageshr* racshr* _Ist* if hispanic==0, robust cluster(statefip)

/// Table 5, Column 5 (allowing coef on county income to differ by gender)
gen femaleXlmeanfinc2 = female*lmeanfinc2
gen maleXlmeanfinc2 = (1-female)*lmeanfinc2
blogit s_freq nobs1 female _Irace* _Iage* _Imarst* _Ifminc90_* maleXlmeanfinc2 femaleXlmeanfinc2 ageshr* racshr* _Ist* if hispanic==0, robust cluster(statefip)

/// Table 5, Column 6 (allowing coef on county income to differ by race)
xi i.race_3*lmeanfinc2 i.age i.marst i.educ i.fminc90 i.statefip
gen _IracXlmeanfinc2_1 = (1 - _Irace_3_2 - _Irace_3_3)*lmeanfinc2
blogit s_freq nobs1 female _Irac* _Iage* _Imarst* _Ifminc90_* ageshr* racshr* _Ist* if hispanic==0, robust cluster(statefip)

*collapse (mean) s_rate meanfinc2 [aw=pop], by(geo)
*corr s_rate meanfinc2



/////////////////////// REGRESSIONS USING 1990-2000 PANEL ///////////////////////////////////////////
use "1990_2000panel.dta", clear  /* date we use in column 3 and 4 of table 6 */
capture gen statefip = floor(stcou/1000)
gen fminc90 = .
replace fminc90 = 1 if meanfinc1 < 10000
replace fminc90 = 2 if inrange(meanfinc1,10000,19999)
replace fminc90 = 3 if inrange(meanfinc1,20000,39999)
replace fminc90 = 4 if inrange(meanfinc1,40000,60000)
replace fminc90 = 5 if meanfinc1 > 60000
char fminc90[omit] 5
char age[omit] 8
char educ[omit] 2
capture gen lmeanfinc1 = log(meanfinc1 + 1)
capture gen lmeanfinc2 = log(meanfinc2)
capture gen female = 0
capture replace female = 1 if sex==0
capture gen _Iyear_1990 = 0
capture replace _Iyear_1990 = 1 if year==1990

xi i.race_3 i.age i.marst i.educ i.fminc90 i.statefip i.stcou

/// Table 6. Column 3
blogit s_freq nobs1 female _Irace* _Iage* _Imarst* _Ifminc90_* lmeanfinc2 _Istcou* _Iyear* if hispanic==0, robust cluster(stcou)
*blogit s_freq nobs1 female _Irace* _Iage* _Imarst* _Ifminc90_* lmeanfinc2 _Istcou* _Iyear* if hispanic==0, robust

/// Table 6. Column 4
blogit s_freq nobs1 female _Irace* _Iage* _Imarst* lmeanfinc1 lmeanfinc2 _Istcou* _Iyear* if hispanic==0, robust cluster(stcou)


/// Figure 3
use s_rates_by_garshem_wo0geos_wo1, clear
sum meanfinc1 [fw=s_freq], detail
kdensity meanfinc1 [fw=s_freq], generate (x1 y1) n(400)
sum meanfinc1 [fw=nobs1], detail
kdensity meanfinc1 [fw=nobs1], generate (x2 y2) n(400)
drop if y1==.
outsheet y1 x1 y2 x2 using "hhincome_kdensity_reduced.csv", comma replace


log close
