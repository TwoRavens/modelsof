****
****
****	PSID Replication File, Part 1
****
****
****	Health and Voting in Young Adulthood	
****
****	Ojeda and Pacheco
****
****	BJPS 2017
****
****
****
****	Table of Contents
****
****	- Cleaning up variables
****
****	- Saving data
****
****	- Creating time-invariant variables 
****
****	- Data preparation for R
****
****	- Descriptives
****


cd "put pathname here"
use "PSID_data.dta", clear


****
**** Cleaning up variables
****

*vote
recode vote2005 5=0
recode vote2007 5=0
recode vote2009 0=. 5=0 9=.
recode vote2011 0=. 5=0
replace vote_last1972 = . if vote_last1972 == 9

*education
foreach var of varlist educ_years2005 educ_years2007 educ_years2009 educ_years2011{
replace `var' = . if `var' == 0 | `var' == 99 | `var' == 98
}
*

*gender
rename sex female
recode female 2=1 1=0

*race
foreach var of varlist race*{
replace `var' = . if `var' == 0 | `var' == 8 | `var' == 9
}
*

forvalues i = 2005(2)2011{
replace racea`i' = 1 if racea`i' == . & raceb`i' == 1
replace racea`i' = 2 if racea`i' == . & raceb`i' == 2
replace racea`i' = 3 if racea`i' == . & raceb`i' == 3
replace racea`i' = 4 if racea`i' == . & raceb`i' == 4
replace racea`i' = 5 if racea`i' == . & raceb`i' == 5
replace racea`i' = 7 if racea`i' == . & raceb`i' == 7
replace racea`i' = 1 if racea`i' == . & racec`i' == 1
replace racea`i' = 2 if racea`i' == . & racec`i' == 2
replace racea`i' = 3 if racea`i' == . & racec`i' == 3
replace racea`i' = 4 if racea`i' == . & racec`i' == 4
replace racea`i' = 5 if racea`i' == . & racec`i' == 5
replace racea`i' = 7 if racea`i' == . & racec`i' == 7
rename racea`i' race`i'
gen race_white`i' = 0
replace race_white`i' = 1 if race`i' == 1
replace race_white`i' = . if race`i' == .
gen race_black`i' = 0
replace race_black`i' = 1 if race`i' == 2
replace race_black`i' = . if race`i' == .
gen race_amerind`i' = 0
replace race_amerind`i' = 1 if race`i' == 3
replace race_amerind`i' = . if race`i' == .
gen race_asian`i' = 0
replace race_asian`i' = 1 if race`i' == 4
replace race_asian`i' = . if race`i' == .
gen race_pacific`i' = 0
replace race_pacific`i' = 1 if race`i' == 5
replace race_pacific`i' = . if race`i' == .
gen race_other`i' = 0
replace race_other`i' = 1 if race`i' == 7
replace race_other`i' = . if race`i' == .
drop raceb`i' racec`i'
}
*

*marital status
forvalues i=2005(2)2011{
gen married`i' = 0
replace married`i' = 1 if marital`i' == 1
replace married`i' = . if marital`i' == .
}
*

*family income
forvalues i=1968(1)1997{
gen pov_level`i' = inc_fam`i'/pov_needs`i'
gen inc10_`i' = inc_fam`i'/10000
}

forvalues i=1999(2)2011{
gen pov_level`i' = inc_fam`i'/pov_needs`i'
gen inc10_`i' = inc_fam`i'/10000
}
*

gen pov_level_log2005 = log(pov_level2005 + .001)
gen pov_level_log2007 = log(pov_level2007 + .001)
gen pov_level_log2009 = log(pov_level2009 + .001)
gen pov_level_log2011 = log(pov_level2011 + .001)
gen inc_log2005 = log(inc_fam2005 + .001)
gen inc_log2007 = log(inc_fam2007 + .001)
gen inc_log2009 = log(inc_fam2009 + .001)
gen inc_log20011 = log(inc_fam2011 + .001)

*parental education
foreach var of varlist educ_dad* educ_mom*{
replace `var' = . if `var' == 0 | `var' == 99 | `var' == 98 | `var' == 96 
}
*

forvalues i=2005(2)2011{
egen educ_par`i' = rowmean(educ_dad`i' educ_mom`i')
}
*

*parenthood
foreach var of varlist child_num*{
replace `var' = . if `var' == 99
}
*

forvalues i=2005(2)2011{
gen parenthood`i' = 0
replace parenthood`i' = 1 if child_num`i' > 1
replace parenthood`i' = . if child_num`i' == .
}
*

*mobility
foreach var of varlist mobility*{
replace `var' = . if `var' == 8
recode `var' 5=0
}
*

*age
foreach var of varlist age*{
replace `var' = . if `var' == 0
}
*

*depression
foreach var of varlist depress_*{
replace `var' = . if `var' == 9
recode `var' 5=0 4=1 3=2 2=3 1=4
}
*

forvalues i=2005(2)2011{
egen depression`i' = rowmean(depress_effort`i' depress_hopeless`i' depress_nervous`i' depress_restless`i' depress_sad`i' depress_worthless`i')
}
*

*self-rated healths status
foreach var of varlist health_self*{
replace `var' = . if `var' == 9
recode `var' 5=0 4=1 3=2 2=3 1=4
}
*

*chroninc conditions
sum chronic*limit*

forvalues i=2005(2)2011{
replace chronic_asthma_limit`i' = . if chronic_asthma_limit`i'  == 8 | chronic_asthma_limit`i'  == 9
replace chronic_blpress_limit`i' = . if chronic_blpress_limit`i'  == 8 | chronic_blpress_limit`i'  == 9
replace chronic_cancer_limit`i' = . if chronic_cancer_limit`i'  == 8 | chronic_cancer_limit`i'  == 9
replace chronic_diabetes_limit`i' = . if chronic_diabetes_limit`i'  == 8 | chronic_diabetes_limit`i'  == 9
replace chronic_other_limit`i' = . if chronic_other_limit`i'  == 8 | chronic_other_limit`i'  == 9
gen chronic_diagnosis`i' = 0
replace chronic_diagnosis`i' = 1 if chronic_asthma_limit`i' > 0 | chronic_blpress_limit`i' > 0 | ///
	chronic_cancer_limit`i' > 0 | chronic_diabetes_limit`i' > 0 | chronic_other_limit`i' > 0
replace chronic_diagnosis`i' = . if chronic_asthma_limit`i' == . | chronic_blpress_limit`i' == . | ///
	chronic_cancer_limit`i' == . | chronic_diabetes_limit`i' == . | chronic_other_limit`i' == .  
gen chronic_diagnosis_noa`i' = 0
replace chronic_diagnosis_noa`i' = 1 if chronic_blpress_limit`i' > 0 | ///
	chronic_cancer_limit`i' > 0 | chronic_diabetes_limit`i' > 0 | chronic_other_limit`i' > 0
replace chronic_diagnosis_noa`i' = . if chronic_blpress_limit`i' == . | ///
	chronic_cancer_limit`i' == . | chronic_diabetes_limit`i' == . | chronic_other_limit`i' == .  	
}
*

forvalues i=2005(2)2011{
gen chronic_asthma_new`i' = chronic_asthma_limit`i'
recode chronic_asthma_new`i' 7=0 5=1 3=2 1=3
gen chronic_blpress_new`i' = chronic_blpress_limit`i'
recode chronic_blpress_new`i' 7=0 5=1 3=2 1=3
gen chronic_cancer_new`i' = chronic_cancer_limit`i'
recode chronic_cancer_new`i' 7=0 5=1 3=2 1=3
gen chronic_diabetes_new`i' = chronic_diabetes_limit`i'
recode chronic_diabetes_new`i' 7=0 5=1 3=2 1=3
gen chronic_other_new`i' = chronic_other_limit`i'
recode chronic_other_new`i' 7=0 5=1 3=2 1=3
egen chronic_limit_count`i' = rowmean(chronic_asthma_new`i' chronic_blpress_new`i' chronic_cancer_new`i' chronic_diabetes_new`i' chronic_other_new`i')
}
*

alpha chronic_asthma_limit* chronic_blpress_limit* chronic_cancer_limit* chronic_diabetes_limit* chronic_other_limit*
forvalues i=2005(2)2011{
alpha chronic_asthma_limit`i' chronic_blpress_limit`i' chronic_cancer_limit`i' chronic_diabetes_limit`i' chronic_other_limit`i'
}
*


****
**** Saving data
****

keep vote* educ_years2005 educ_years2007 educ_years2009 educ_years2011 female ///
race* married* marital* pov_level2005 pov_level2007 pov_level2009 pov_level2011 ///
pov_level_log* educ_par* parent* mobility2005 ///
mobility2007 mobility2009 mobility2011 depression* health_self* chronic_diagnosis* chronic_diagnosis_noa* ///
chronic_limit_count* age2005 age2007 age2009 age2011 aid_fam aid_ind weight* depress* inc_fam* inc10* inc_log*

order *, alphabet
order aid_fam aid_ind, first

save "PSID2_health.dta", replace
saveold "PSID2_health_stata12.dta", version(12) replace


****
**** Creating time-invariant variables
****

use "PSID2_health_stata12.dta", clear

gen age05=age2005
gen chronic05=chronic_diagnosis2005
gen chronic_noa05=chronic_diagnosis_noa2005
gen limit05=chronic_limit_count2005
gen depress05=depression2005
gen educ_par05=educ_par2005
gen educ_year05=educ_years2005
gen srhs05=health_self2005
gen marital05=marital2005
gen mobility05=mobility2005
gen parent05=parenthood2005
gen pov05=pov_level2005
gen povlog05=pov_level_log2005
gen inc10_05=inc10_2005
gen inc_log05 = inc_log2005
gen race=race2005
gen asian=race_asian2005
gen black=race_black2005
gen other=race_other2005
gen other2=0
replace other2=1 if race>=3
gen voteparent=vote_last1972

keep age05 chronic05 chronic_noa05 other2 limit05 female depress05 educ_par05 ///
educ_year05 srhs05 marital05 mobility05 parent05 pov05 povlog05 race asian ///
black other voteparent aid_ind aid_fam inc10_05 inc_log05

gen aid_ind_st=string(aid_ind)
gen aid_fam_st=string(aid_fam)
egen id_st=concat(aid_fam_st aid_ind_st)
destring id_st, gen(id_n) force

drop if age05<18

sort id_n
save "PSID2_health_time_invariant.dta", replace



****
**** Data preparation for R
****

use "PSID2_health_stata12.dta", clear

gen aid_ind_st=string(aid_ind)
gen aid_fam_st=string(aid_fam)

egen id_st=concat(aid_fam_st aid_ind_st)

destring id_st, gen(id_n) force

drop if age2005<18

drop aid*

keep age* chronic* depression* female educ_par* educ_years* health* marital* married* mobility* parenthood* pov_level* pov_level_log* vote* weight* inc10* inc_fam* inc_log* id_n 

format educ_years* vote* %9.0g
label drop _all

reshape long age chronic_diagnosis chronic_diagnosis_noa chronic_limit_count depression depression_new educ_par educ_years health_self marital married mobility parenthood pov_level pov_level_log vote weight inc_fam inc_log inc10_, i(id_n) j(year)
drop vote_last*

sort id_n
merge id_n using "PSID2_health_time_invariant.dta"


recode health_self srhs05 (0=4) (1=3) (2=2) (3=1) (4=0)

gen midterm=0
replace midterm=1 if year==2007 | year==2011

gen ceduc_par=educ_par-12
gen cdepress=depression-.84
gen ceduc=educ_years-12
gen cdepressnew=depression_new-.683

gen ceduc_par05=educ_par05-12

drop if age05<18

gen cage=age-22
gen cpov_level=pov_level-3.81
gen cpov_level_log=pov_level_log-.855

gen cpov05=pov05-4.21
gen cpovlog05=povlog05-1.00

gen cinc10_05 = inc10_05 - 7.239289
rename inc10_ inc10
gen cinc10 = inc10 - 3.343229 

gen cdepress05=depress05-.89

gen cvoteparent=voteparent-1.81

gen election=.
replace election=0 if year==2005
replace election=1 if year==2007
replace election=2 if year==2009
replace election=3 if year==2011

corr ceduc_par cdepress depress05 ceduc cpov_level cpov_level_log cvoteparent

gen health_selfb=health_self
gen srhs05b=srhs05
recode health_selfb srhs05b (0=0) (1=0) (2=1) (3=2) (4=3)

gen health_selfc=health_self
gen srhs05c=srhs05
recode health_selfc srhs05c (0=0) (1=0) (2=1) (3=2) (4=2)

saveold "PSID2_health_for_r12.dta", version(12) replace



****
**** Descriptives
****

use "PSID2_health_for_r12.dta", clear



**
** VOTER TURNOUT GRAPH

clear
set obs 4
gen year = .
replace year = 2004 if _n == 1
replace year = 2006 if _n == 2
replace year = 2008 if _n == 3
replace year = 2010 if _n == 4

gen turnout = .
replace turnout = 46.518519 if _n == 1
replace turnout = 28.933721 if _n == 2
replace turnout = 65.74344 if _n == 3
replace turnout = 32.631579 if _n == 4

gen turnout_str = "."
replace turnout_str = "47%" if _n == 1
replace turnout_str = "29%" if _n == 2
replace turnout_str = "66%" if _n == 3
replace turnout_str = "33%" if _n == 4

forvalues i=1(1)4{
gen turnout`i' = .
replace turnout`i' = turnout if _n == `i'
}

gen n_var = .
replace n_var = 1 if _n == 1
replace n_var = 2.2 if _n == 2
replace n_var = 3.4 if _n == 3
replace n_var = 4.6 if _n == 4

twoway(bar turnout1 n_var, barwidth(0.75) lcolor(black) color(gs4)) ///
		(bar turnout2 n_var, barwidth(0.75) lcolor(black) color(gs4)) ///
		(bar turnout3 n_var, barwidth(0.75) lcolor(black) color(gs4)) ///
		(bar turnout4 n_var, barwidth(0.75) lcolor(black) color(gs4)) ///
		(scatter turnout n_var, msymbol(i) mlabel(turnout_str) mlabposition(12) mlabsize(3)), ///
		title("Figure B.1: Reported Turnout in Each Election, PSID") ///
		legend(off) ///
		yscale(off) ///
		ylabel(0 10 20 30 40 50 60 70 80, labsize(2.5) angle(horizontal) nogrid) ///
		xlabel(1 "2004" 2.2 "2006" 3.4 "2008" 4.6 "2010", notick angle(45) labgap(3)) ///
		xtitle("") ///
		scheme(s2mono) graphregion(fcolor(white))
