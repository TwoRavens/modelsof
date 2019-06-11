
******************************

*First reproduce results, then modify code so as not to have to keep loading and reloading files

*Table 3 - All okay

global varbaseline "i.s_teneviv s_utilities s_durables s_infraest_hh s_age_sorteo s_age_sorteo2 s_years_back s_sexo i.s_estcivil s_single s_edadhead s_yrshead s_tpersona s_num18 i.s_estrato s_puntaje s_ingtotal i.grade suba s_over_age"
use Public_Data_AEJApp_2010-0132.dta, clear
drop if suba == 1 & grade < 9
keep if survey_selected
drop if grade == 11

xi: reg at_msamean T1_treat T2_treat if suba == 0, cluster(school_code)
xi: reg at_msamean T1_treat T2_treat $varbaseline if suba == 0, cluster(school_code)
xi: reg at_msamean T1_treat T2_treat $varbaseline i.school_code if suba == 0, cluster(school_code)
xi: reg at_msamean T3_treat if suba == 1 & grade > 8, cluster(school_code)
xi: reg at_msamean T3_treat $varbaseline if suba == 1 & grade > 8, cluster(school_code)
xi: reg at_msamean T3_treat $varbaseline i.school_code if suba == 1 & grade > 8, cluster(school_code)
xi: reg at_msamean T1_treat T2_treat T3_treat $varbaseline suba i.school_code if grade > 8, cluster(school_code)


*Table 4 - All okay

global varbaseline "i.s_teneviv s_utilities s_durables s_infraest_hh s_age_sorteo s_age_sorteo2 s_years_back s_sexo i.s_estcivil s_single s_edadhead s_yrshead s_tpersona s_num18 i.s_estrato s_puntaje s_ingtotal i.grade suba s_over_age"
use Public_Data_AEJApp_2010-0132.dta, clear
drop if suba == 1 & grade < 9
drop if grade == 11

xi: reg m_enrolled T1_treat T2_treat if suba == 0 & grade < 11, cluster(school_code)
xi: reg m_enrolled T1_treat T2_treat $varbaseline if suba == 0 & grade < 11, cluster(school_code)
xi: reg m_enrolled T1_treat T2_treat $varbaseline i.school_code if suba == 0 & grade < 11, cluster(school_code)
xi: reg m_enrolled T3_treat if suba == 1 & grade > 8 & grade < 11, cluster(school_code)
xi: reg m_enrolled T3_treat $varbaseline if suba == 1 & grade > 8 & grade < 11, cluster(school_code)
xi: reg m_enrolled T3_treat $varbaseline i.school_code if suba == 1 & grade > 8 & grade < 11, cluster(school_code)
xi: reg m_enrolled T1_treat T2_treat T3_treat $varbaseline suba i.school_code if grade > 8 & grade < 11, cluster(school_code)


*Table 5 - All okay

*Note that s_sexo is not in this set because girl is used as an interaction variable.  So, it is included seperately in each regression;
global varbaseline "i.s_teneviv s_utilities s_durables s_infraest_hh s_age_sorteo s_age_sorteo2 s_years_back i.s_estcivil s_single s_edadhead s_yrshead s_tpersona s_num18 i.s_estrato s_puntaje s_ingtotal i.grade suba s_over_age"
use Public_Data_AEJApp_2010-0132.dta, clear
drop if suba == 1 & grade < 9
drop if grade > 10
gen girl = s_sexo == 0
gen boy = girl == 0
gen inc_380 = s_ingtotal <= 380
gen T1_inc_380 = T1_treat * inc_380
gen T2_inc_380 = T2_treat * inc_380
gen pen = en_baseline
gen patt = at_baseline
foreach var in survey_selected girl pen patt {
   gen T1_treat_`var' = T1_treat * `var'
   gen T2_treat_`var' = T2_treat * `var'
   gen T3_treat_`var' = T3_treat * `var'
   }

xi: reg at_msamean T1_treat T2_treat T1_treat_girl T2_treat_girl girl $varbaseline i.school_code if suba == 0 & survey_selected == 1, cluster(school_code)
xi: reg m_enrolled T1_treat T2_treat T1_treat_girl T2_treat_girl girl $varbaseline i.school_code if suba == 0 & grade < 11, cluster(school_code)
xi: reg at_msamean T1_treat T2_treat T1_inc_380 T2_inc_380 inc_380 girl $varbaseline i.school_code if suba == 0 & survey_selected == 1, cluster(school_code)
xi: reg m_enrolled T1_treat T2_treat T1_inc_380 T2_inc_380 inc_380 girl $varbaseline i.school_code if suba == 0 & grade < 11, cluster(school_code)
xi: reg at_msamean T1_treat T2_treat T1_treat_patt T2_treat_patt girl $varbaseline i.school_code if suba == 0 & survey_selected == 1, cluster(school_code)
xi: reg m_enrolled T1_treat T2_treat T1_treat_pen T2_treat_pen girl $varbaseline i.school_code if suba == 0 & grade < 11, cluster(school_code)


*Table 6 - All okay

global varbaseline "i.s_teneviv s_utilities s_durables s_infraest_hh s_age_sorteo s_age_sorteo2 s_years_back s_sexo i.s_estcivil s_single s_edadhead s_yrshead s_tpersona s_num18 i.s_estrato s_puntaje s_ingtotal i.grade suba s_over_age"
use Public_Data_AEJApp_2010-0132.dta, clear
drop if suba == 1 & grade < 9
keep if fu_observed == 1
drop if grade == 11

xi: reg fu_self_attendance T1_treat T2_treat $varbaseline i.school_code if suba == 0, cluster(school_code)
xi: reg fu_self_attendance T3_treat $varbaseline i.school_code if suba == 1, cluster(school_code)
xi: reg fu_self_attendance T1_treat T2_treat T3_treat $varbaseline i.school_code if grade > 8, cluster(school_code)
xi: reg fu_currently_attending T1_treat T2_treat $varbaseline i.school_code if suba == 0, cluster(school_code)
xi: reg fu_currently_attending T3_treat $varbaseline i.school_code if suba == 1, cluster(school_code)
xi: reg fu_currently_attending T1_treat T2_treat T3_treat $varbaseline i.school_code if grade > 8, cluster(school_code)


*Table 7 - One s.e. rounding error

global varbaseline "i.s_teneviv s_utilities s_durables s_infraest_hh s_age_sorteo s_age_sorteo2 s_years_back s_sexo i.s_estcivil s_single s_edadhead s_yrshead s_tpersona s_num18 i.s_estrato s_puntaje s_ingtotal i.grade suba s_over_age"
use Public_Data_AEJApp_2010-0132.dta, clear
drop if suba == 1 & grade < 9
keep if fu_observed == 1

xi: reg graduated T1_treat T2_treat $varbaseline i.school_code if suba == 0 & grade == 11, cluster(school_code)
xi: reg graduated T3_treat $varbaseline i.school_code if suba == 1 & grade == 11, cluster(school_code)
xi: reg graduated T1_treat T2_treat T3_treat $varbaseline i.school_code if grade == 11, cluster(school_code)
xi: reg tertiary T1_treat T2_treat $varbaseline i.school_code if suba == 0 & grade == 11, cluster(school_code)
xi: reg tertiary T3_treat $varbaseline i.school_code if suba == 1 & grade == 11, cluster(school_code)
xi: reg tertiary T1_treat T2_treat T3_treat $varbaseline i.school_code if grade == 11, cluster(school_code)


*Table 8 - All okay

global labor_new "fu_primary_study fu_primary_work fu_primary_home fu_hrs_last_wwk fu_earn_last_wwk"
global varbaseline "i.s_teneviv s_utilities s_durables s_infraest_hh s_age_sorteo s_age_sorteo2 s_years_back s_sexo i.s_estcivil s_single s_edadhead s_yrshead s_tpersona s_num18 i.s_estrato s_puntaje s_ingtotal i.grade suba s_over_age"
use Public_Data_AEJApp_2010-0132.dta, clear
drop if suba == 1 & grade < 9
global condition "survey_selected & fu_observed & grade < 11"
foreach var in $labor_new {
   reg `var' if control & ~suba & $condition
   xi: reg `var' T1_treat T2_treat $varbaseline i.school_code if ~suba & $condition, cluster(school_code)
   reg `var' if control & suba & grade > 8 & $condition
   xi: reg `var' T3_treat $varbaseline i.school_code if suba & grade > 8 & $condition, cluster(school_code)
   }

global condition "survey_selected & fu_observed & grade == 11"
foreach var in $labor_new {
   reg `var' if control & ~suba & $condition
   xi: reg `var' T1_treat T2_treat $varbaseline i.school_code if ~suba & $condition, cluster(school_code)
   reg `var' if control & suba & grade > 8 & $condition
   xi: reg `var' T3_treat $varbaseline i.school_code if suba & grade > 8 & $condition, cluster(school_code)
   }


*Table 9 & 10 - All okay

global varbaseline "i.s_teneviv s_utilities s_durables s_infraest_hh s_age_sorteo s_age_sorteo2 s_years_back s_sexo i.s_estcivil s_single s_edadhead s_yrshead s_tpersona s_num18 i.s_estrato s_puntaje s_ingtotal i.grade suba s_over_age"
use Public_Data_AEJApp_2010-0132.dta, clear
keep if fu_observed == 1
drop if grade == 11
bysort fu_nim_hogar: gen num_rsib = _N
replace num_rsib = . if fu_nim_hogar == .
tab num_rsib
keep if num_rsib == 2
bysort fu_nim_hogar: gen tsib = treatment[2] if _n == 1
bysort fu_nim_hogar: replace tsib = treatment[1] if _n == 2
bysort fu_nim_hogar: egen num_tsib = sum(treatment)
drop if suba == 1 & grade < 9

xi: reg at_msamean tsib suba $varbaseline i.school_code if control == 1, cluster(school_code)
xi: reg m_enrolled tsib suba $varbaseline i.school_code if control == 1, cluster(school_code)
xi: reg at_msamean tsib suba $varbaseline i.school_code if control == 1 & s_sexo == 0, cluster(school_code)
xi: reg m_enrolled tsib suba $varbaseline i.school_code if control == 1 & s_sexo == 0, cluster(school_code)
xi: reg at_msamean tsib suba $varbaseline i.school_code if control == 1 & s_sexo == 1, cluster(school_code)
xi: reg m_enrolled tsib suba $varbaseline i.school_code if control == 1 & s_sexo == 1, cluster(school_code)
xi: reg at_msamean treatment suba $varbaseline i.school_code if num_tsib == 1, cluster(school_code)
xi: reg m_enrolled treatment suba $varbaseline i.school_code if num_tsib == 1, cluster(school_code)
xi: reg at_msamean tsib suba $varbaseline i.school_code if control == 0, cluster(school_code)
xi: reg m_enrolled tsib suba $varbaseline i.school_code if control == 0, cluster(school_code)


***********************************

*Now combine it all - will use areg  
*Will have to randomize including suba == 1 & grade < 9 (in separate strata), because these used in calculation of "tsib" further below
*So, even though all regressions refer to sample excluding these observations, these observations influence the treatment vector in tsib regressions in Tables 9 & 10. 

use Public_Data_AEJApp_2010-0132.dta, clear

*Prep for tables 9 & 10
generate S = 1 if grade ~= 11 & fu_observed == 1
bysort S fu_nim_hogar: gen num_rsib = _N 
replace num_rsib = . if (fu_nim_hogar == . | S ~= 1)
tab num_rsib
replace S = . if num_rsib ~= 2
bysort S fu_nim_hogar: gen tsib = treatment[2] if _n == 1
bysort S fu_nim_hogar: replace tsib = treatment[1] if _n == 2
bysort S fu_nim_hogar: egen num_tsib = sum(treatment)
replace tsib = . if S ~= 1
replace num_tsib = . if S ~= 1
replace num_rsib = . if S ~= 1

generate SS = 1 if suba == 1 & grade < 9

gen girl = s_sexo == 0
gen boy = girl == 0
gen inc_380 = s_ingtotal <= 380
gen T1_inc_380 = T1_treat * inc_380
gen T2_inc_380 = T2_treat * inc_380
gen pen = en_baseline
gen patt = at_baseline
foreach var in survey_selected girl pen patt {
   gen T1_treat_`var' = T1_treat * `var'
   gen T2_treat_`var' = T2_treat * `var'
   gen T3_treat_`var' = T3_treat * `var'
   }

tab s_teneviv, gen(S_TENEVIV)
tab s_estcivil, gen(S_ESTCIVIL)
tab s_estrato, gen(S_ESTRATO)
tab grade, gen(GRADE)

global varbaseline "i.s_teneviv s_utilities s_durables s_infraest_hh s_age_sorteo s_age_sorteo2 s_years_back s_sexo i.s_estcivil s_single s_edadhead s_yrshead s_tpersona s_num18 i.s_estrato s_puntaje s_ingtotal i.grade suba s_over_age"
*Note that s_sexo is not in this set because girl is used as an interaction variable.  So, it is included seperately in each regression;
global varbaseline1 "i.s_teneviv s_utilities s_durables s_infraest_hh s_age_sorteo s_age_sorteo2 s_years_back i.s_estcivil s_single s_edadhead s_yrshead s_tpersona s_num18 i.s_estrato s_puntaje s_ingtotal i.grade suba s_over_age"

global BASELINE1 "S_TENEVIV2-S_TENEVIV4 s_utilities s_durables s_infraest_hh s_age_sorteo s_age_sorteo2 s_years_back s_sexo S_ESTCIVIL2-S_ESTCIVIL5 s_single s_edadhead s_yrshead s_tpersona s_num18 S_ESTRATO2-S_ESTRATO3 s_puntaje s_ingtotal s_over_age"
*dropped grades & suba, as these vary by specification (will add in manually)

global BASELINE2 "S_TENEVIV2-S_TENEVIV4 s_utilities s_durables s_infraest_hh s_age_sorteo s_age_sorteo2 s_sexo S_ESTCIVIL2-S_ESTCIVIL5 s_single s_edadhead s_yrshead s_tpersona s_num18 S_ESTRATO2-S_ESTRATO3 s_puntaje s_ingtotal s_over_age"
*drop s_years_back - colinear in some regressions

global BASELINE3 "S_TENEVIV2-S_TENEVIV4 s_utilities s_durables s_infraest_hh s_age_sorteo s_age_sorteo2 s_years_back s_sexo S_ESTCIVIL4-S_ESTCIVIL5 s_single s_edadhead s_yrshead s_tpersona s_num18 S_ESTRATO2-S_ESTRATO3 s_puntaje s_ingtotal s_over_age"
*S_ESTCIVIL2 S_ESTCIVIL3 don't vary in some regressions

global BASELINE4 "S_TENEVIV2-S_TENEVIV4 s_utilities s_durables s_infraest_hh s_age_sorteo s_age_sorteo2 s_years_back s_sexo S_ESTCIVIL2 S_ESTCIVIL4 S_ESTCIVIL5 s_single s_edadhead s_yrshead s_tpersona s_num18 S_ESTRATO2-S_ESTRATO3 s_puntaje s_ingtotal s_over_age"
*S_ESTCIVIL3 doesn't vary in some regressions

global BASELINE5 "S_TENEVIV2-S_TENEVIV4 s_utilities s_durables s_infraest_hh s_age_sorteo2 s_years_back s_sexo S_ESTCIVIL2-S_ESTCIVIL5 s_single s_edadhead s_yrshead s_tpersona s_num18 S_ESTRATO2-S_ESTRATO3 s_puntaje s_ingtotal s_over_age"
*dropped s_age_sorteo - colinear in some regressions

global BASELINE6 "S_TENEVIV2-S_TENEVIV4 s_utilities s_durables s_infraest_hh s_age_sorteo2 s_years_back s_sexo S_ESTCIVIL5 s_single s_edadhead s_yrshead s_tpersona s_num18 S_ESTRATO2-S_ESTRATO3 s_puntaje s_ingtotal s_over_age"
*s_age_sorteo, S_ESTCIVIL2-SESTCIVIL4

global BASELINE7 "S_TENEVIV2-S_TENEVIV4 s_utilities s_durables s_infraest_hh s_age_sorteo s_age_sorteo2 s_sexo S_ESTCIVIL2-S_ESTCIVIL5 s_single s_edadhead s_yrshead s_tpersona s_num18 S_ESTRATO2-S_ESTRATO3 s_puntaje s_ingtotal s_over_age"
*s_years_back

global BASELINE8 "S_TENEVIV2-S_TENEVIV4 s_utilities s_durables s_infraest_hh s_age_sorteo s_age_sorteo2 s_years_back s_sexo s_single s_edadhead s_yrshead s_tpersona s_num18 S_ESTRATO2-S_ESTRATO3 s_puntaje s_ingtotal s_over_age"
*S_ESTCIVIL*

global BASELINE9 "S_TENEVIV2-S_TENEVIV4 s_utilities s_durables s_infraest_hh s_age_sorteo s_age_sorteo2 s_years_back s_single s_edadhead s_yrshead s_tpersona s_num18 S_ESTRATO2-S_ESTRATO3 s_puntaje s_ingtotal s_over_age"
*S_ESTCIVIL*, s_sexo

global BASELINE10 "S_TENEVIV2-S_TENEVIV4 s_utilities s_durables s_infraest_hh s_age_sorteo s_age_sorteo2 s_years_back S_ESTCIVIL2 S_ESTCIVIL4-S_ESTCIVIL5 s_single s_edadhead s_yrshead s_tpersona s_num18 S_ESTRATO2-S_ESTRATO3 s_puntaje s_ingtotal s_over_age"
*S_ESTCIVIL3, s_sexo

global BASELINES1 "S_TENEVIV2-S_TENEVIV4 s_utilities s_durables s_infraest_hh s_age_sorteo s_age_sorteo2 s_years_back S_ESTCIVIL2-S_ESTCIVIL5 s_single s_edadhead s_yrshead s_tpersona s_num18 S_ESTRATO2-S_ESTRATO3 s_puntaje s_ingtotal s_over_age"
*no s_sexo


*Table 3 - All okay

xi: reg at_msamean T1_treat T2_treat if SS ~= 1 & grade ~= 11 & suba == 0 & survey_selected == 1, cluster(school_code)
	reg at_msamean T1_treat T2_treat if SS ~= 1 & grade ~= 11 & suba == 0 & survey_selected == 1, cluster(school_code)

xi: reg at_msamean T1_treat T2_treat $varbaseline if SS ~= 1 & grade ~= 11 & suba == 0 & survey_selected == 1, cluster(school_code)
	reg at_msamean T1_treat T2_treat GRADE2-GRADE4 $BASELINE1 if SS ~= 1 & grade ~= 11 & suba == 0 & survey_selected == 1, cluster(school_code)

xi: reg at_msamean T1_treat T2_treat $varbaseline i.school_code if SS ~= 1 & grade ~= 11 & suba == 0 & survey_selected == 1, cluster(school_code)
	areg at_msamean T1_treat T2_treat GRADE2-GRADE4 $BASELINE1 if SS ~= 1 & grade ~= 11 & suba == 0 & survey_selected == 1, absorb(school_code) cluster(school_code)

xi: reg at_msamean T3_treat if SS ~= 1 & grade ~= 11 & suba == 1 & grade > 8 & survey_selected == 1, cluster(school_code)
	reg at_msamean T3_treat if SS ~= 1 & grade ~= 11 & suba == 1 & grade > 8 & survey_selected == 1, cluster(school_code)

xi: reg at_msamean T3_treat $varbaseline if SS ~= 1 & grade ~= 11 & suba == 1 & grade > 8 & survey_selected == 1, cluster(school_code)
	reg at_msamean T3_treat GRADE5 $BASELINE2 if SS ~= 1 & grade ~= 11 & suba == 1 & grade > 8 & survey_selected == 1, cluster(school_code)

*showing colinearity of s_years_back with other non-treatment variables in this specification
reg s_years_back GRADE5 S_TENEVIV2-S_TENEVIV4 s_utilities s_durables s_infraest_hh s_age_sorteo s_age_sorteo2 s_sexo S_ESTCIVIL2-S_ESTCIVIL5 s_single s_edadhead s_yrshead s_tpersona s_num18 S_ESTRATO2-S_ESTRATO3 s_puntaje s_ingtotal s_over_age if SS ~= 1 & grade ~= 11 & suba == 1 & grade > 8 & survey_selected == 1, cluster(school_code)

xi: reg at_msamean T3_treat $varbaseline i.school_code if SS ~= 1 & grade ~= 11 & suba == 1 & grade > 8 & survey_selected == 1, cluster(school_code)
	areg at_msamean T3_treat $BASELINE1 if SS ~= 1 & grade ~= 11 & suba == 1 & grade > 8 & survey_selected == 1, absorb(school_code) cluster(school_code)

xi: reg at_msamean T1_treat T2_treat T3_treat $varbaseline suba i.school_code if SS ~= 1 & grade ~= 11 & grade > 8 & survey_selected == 1, cluster(school_code)
	areg at_msamean T1_treat T2_treat T3_treat $BASELINE1 suba if SS ~= 1 & grade ~= 11 & grade > 8 & survey_selected == 1, absorb(school_code) cluster(school_code)




*Table 4 - All okay

xi: reg m_enrolled T1_treat T2_treat if SS ~= 1 & grade ~= 11 & suba == 0 & grade < 11, cluster(school_code)
	reg m_enrolled T1_treat T2_treat if SS ~= 1 & grade ~= 11 & suba == 0 & grade < 11, cluster(school_code)

xi: reg m_enrolled T1_treat T2_treat $varbaseline if SS ~= 1 & grade ~= 11 & suba == 0 & grade < 11, cluster(school_code)
	reg m_enrolled T1_treat T2_treat GRADE2-GRADE4 $BASELINE1 if SS ~= 1 & grade ~= 11 & suba == 0 & grade < 11, cluster(school_code)

xi: reg m_enrolled T1_treat T2_treat $varbaseline i.school_code if SS ~= 1 & grade ~= 11 & suba == 0 & grade < 11, cluster(school_code)
	areg m_enrolled T1_treat T2_treat GRADE2-GRADE4 $BASELINE1 if SS ~= 1 & grade ~= 11 & suba == 0 & grade < 11, absorb(school_code) cluster(school_code)

xi: reg m_enrolled T3_treat if SS ~= 1 & grade ~= 11 & suba == 1 & grade > 8 & grade < 11, cluster(school_code)
	reg m_enrolled T3_treat if SS ~= 1 & grade ~= 11 & suba == 1 & grade > 8 & grade < 11, cluster(school_code)

xi: reg m_enrolled T3_treat $varbaseline if SS ~= 1 & grade ~= 11 & suba == 1 & grade > 8 & grade < 11, cluster(school_code)
	reg m_enrolled T3_treat $BASELINE3 if SS ~= 1 & grade ~= 11 & suba == 1 & grade > 8 & grade < 11, cluster(school_code)

*These variables dropped because don't vary
sum S_ESTCIVIL2 S_ESTCIVIL3 if SS ~= 1 & grade ~= 11 & suba == 1 & grade > 8 & grade < 11 & m_enrolled ~= .

xi: reg m_enrolled T3_treat $varbaseline i.school_code if SS ~= 1 & grade ~= 11 & suba == 1 & grade > 8 & grade < 11, cluster(school_code)
	areg m_enrolled T3_treat $BASELINE3 if SS ~= 1 & grade ~= 11 & suba == 1 & grade > 8 & grade < 11, absorb(school_code) cluster(school_code)

xi: reg m_enrolled T1_treat T2_treat T3_treat $varbaseline suba i.school_code if SS ~= 1 & grade ~= 11 & grade > 8 & grade < 11, cluster(school_code)
	areg m_enrolled T1_treat T2_treat T3_treat $BASELINE4 suba if SS ~= 1 & grade ~= 11 & grade > 8 & grade < 11, absorb(school_code) cluster(school_code)

*Don't vary or are colinear with other non-treatment variables
sum S_ESTCIVIL2 S_ESTCIVIL3 GRADE* if SS ~= 1 & grade ~= 11 & grade > 8 & grade < 11 & m_enrolled ~= .
areg GRADE4 $BASELINE4 suba if SS ~= 1 & grade ~= 11 & grade > 8 & grade < 11, absorb(school_code) cluster(school_code)




*Table 5 - All okay

xi: reg at_msamean T1_treat T2_treat T1_treat_girl T2_treat_girl girl $varbaseline1 i.school_code if SS ~= 1 & grade ~= 11 & suba == 0 & survey_selected == 1, cluster(school_code)
	areg at_msamean T1_treat T2_treat T1_treat_girl T2_treat_girl girl GRADE2-GRADE4 $BASELINES1 if SS ~= 1 & grade ~= 11 & suba == 0 & survey_selected == 1, absorb(school_code) cluster(school_code)

xi: reg m_enrolled T1_treat T2_treat T1_treat_girl T2_treat_girl girl $varbaseline1 i.school_code if SS ~= 1 & grade ~= 11 & suba == 0 & grade < 11, cluster(school_code)
	areg m_enrolled T1_treat T2_treat T1_treat_girl T2_treat_girl girl GRADE2-GRADE4 $BASELINES1 if SS ~= 1 & grade ~= 11 & suba == 0 & grade < 11, absorb(school_code) cluster(school_code)

xi: reg at_msamean T1_treat T2_treat T1_inc_380 T2_inc_380 inc_380 girl $varbaseline1 i.school_code if SS ~= 1 & grade ~= 11 & suba == 0 & survey_selected == 1, cluster(school_code)
	areg at_msamean T1_treat T2_treat T1_inc_380 T2_inc_380 inc_380 girl GRADE2-GRADE4 $BASELINES1 if SS ~= 1 & grade ~= 11 & suba == 0 & survey_selected == 1, absorb(school_code) cluster(school_code)

xi: reg m_enrolled T1_treat T2_treat T1_inc_380 T2_inc_380 inc_380 girl $varbaseline1 i.school_code if SS ~= 1 & grade ~= 11 & suba == 0 & grade < 11, cluster(school_code)
	areg m_enrolled T1_treat T2_treat T1_inc_380 T2_inc_380 inc_380 girl GRADE2-GRADE4 $BASELINES1 if SS ~= 1 & grade ~= 11 & suba == 0 & grade < 11, absorb(school_code) cluster(school_code)

xi: reg at_msamean T1_treat T2_treat T1_treat_patt T2_treat_patt girl $varbaseline1 i.school_code if SS ~= 1 & grade ~= 11 & suba == 0 & survey_selected == 1, cluster(school_code)
	areg at_msamean T1_treat T2_treat T1_treat_patt T2_treat_patt girl GRADE2-GRADE4 $BASELINES1 if SS ~= 1 & grade ~= 11 & suba == 0 & survey_selected == 1, absorb(school_code) cluster(school_code)

xi: reg m_enrolled T1_treat T2_treat T1_treat_pen T2_treat_pen girl $varbaseline1 i.school_code if SS ~= 1 & grade ~= 11 & suba == 0 & grade < 11, cluster(school_code)
	areg m_enrolled T1_treat T2_treat T1_treat_pen T2_treat_pen girl GRADE2-GRADE4 $BASELINES1 if SS ~= 1 & grade ~= 11 & suba == 0 & grade < 11, absorb(school_code) cluster(school_code)



*Table 6 - All okay

xi: reg fu_self_attendance T1_treat T2_treat $varbaseline i.school_code if SS ~= 1 & grade ~= 11 & suba == 0 & fu_observed == 1, cluster(school_code)
	areg fu_self_attendance T1_treat T2_treat GRADE2-GRADE4 $BASELINE1 if SS ~= 1 & grade ~= 11 & suba == 0 & fu_observed == 1, absorb(school_code) cluster(school_code)

xi: reg fu_self_attendance T3_treat $varbaseline i.school_code if SS ~= 1 & grade ~= 11 & suba == 1 & fu_observed == 1, cluster(school_code)
	areg fu_self_attendance T3_treat GRADE4 $BASELINE2 if SS ~= 1 & grade ~= 11 & suba == 1 & fu_observed == 1, absorb(school_code) cluster(school_code)

*Showing colinearity
areg s_years_back GRADE4 $BASELINE2 if SS ~= 1 & grade ~= 11 & suba == 1 & fu_observed == 1 & fu_self_attendance ~= ., absorb(school_code) cluster(school_code)

xi: reg fu_self_attendance T1_treat T2_treat T3_treat $varbaseline i.school_code if SS ~= 1 & grade ~= 11 & grade > 8 & fu_observed == 1, cluster(school_code)
	areg fu_self_attendance T1_treat T2_treat T3_treat suba $BASELINE1 if SS ~= 1 & grade ~= 11 & grade > 8 & fu_observed == 1, absorb(school_code) cluster(school_code)

*Do not vary or collinear
sum GRADE* if SS ~= 1 & grade ~= 11 & fu_self_attendance ~= . & grade > 8 & fu_observed == 1
areg GRADE4 suba $BASELINE1 if SS ~= 1 & grade ~= 11 & fu_self_attendance ~= . & grade > 8 & fu_observed == 1, absorb(school_code)
areg GRADE5 suba $BASELINE1 if SS ~= 1 & grade ~= 11 & fu_self_attendance ~= . & grade > 8 & fu_observed == 1, absorb(school_code)

xi: reg fu_currently_attending T1_treat T2_treat $varbaseline i.school_code if SS ~= 1 & grade ~= 11 & suba == 0 & fu_observed == 1, cluster(school_code)
	areg fu_currently_attending T1_treat T2_treat GRADE2-GRADE4 $BASELINE1 if SS ~= 1 & grade ~= 11 & suba == 0 & fu_observed == 1, absorb(school_code) cluster(school_code)

xi: reg fu_currently_attending T3_treat $varbaseline i.school_code if SS ~= 1 & grade ~= 11 & suba == 1 & fu_observed == 1, cluster(school_code)
	areg fu_currently_attending T3_treat $BASELINE1 if SS ~= 1 & grade ~= 11 & suba == 1 & fu_observed == 1, absorb(school_code) cluster(school_code)

xi: reg fu_currently_attending T1_treat T2_treat T3_treat $varbaseline i.school_code if SS ~= 1 & grade ~= 11 & grade > 8 & fu_observed == 1, cluster(school_code)
	areg fu_currently_attending T1_treat T2_treat T3_treat suba $BASELINE1 if SS ~= 1 & grade ~= 11 & grade > 8 & fu_observed == 1, absorb(school_code) cluster(school_code)




*Table 7 - One s.e. rounding error

xi: reg graduated T1_treat T2_treat $varbaseline i.school_code if SS ~= 1 & suba == 0 & grade == 11 & fu_observed == 1, cluster(school_code)
	areg graduated T1_treat T2_treat $BASELINE5 if SS ~= 1 & suba == 0 & grade == 11 & fu_observed == 1, absorb(school_code) cluster(school_code)

*s_age_sorteo colinear
areg s_age_sorteo $BASELINE5 if SS ~= 1 & suba == 0 & grade == 11 & fu_observed == 1, absorb(school_code) cluster(school_code)

xi: reg graduated T3_treat $varbaseline i.school_code if SS ~= 1 & suba == 1 & grade == 11 & fu_observed == 1, cluster(school_code)
	areg graduated T3_treat $BASELINE6 if SS ~= 1 & suba == 1 & grade == 11 & fu_observed == 1, absorb(school_code) cluster(school_code)

*Do not vary or colinear
sum S_ESTCIVIL* if SS ~= 1 & suba == 1 & grade == 11 & fu_observed == 1
areg s_age_sorteo $BASELINE5 if SS ~= 1 & suba == 1 & grade == 11 & fu_observed == 1, absorb(school_code) cluster(school_code)

xi: reg graduated T1_treat T2_treat T3_treat $varbaseline i.school_code if SS ~= 1 & grade == 11 & fu_observed == 1, cluster(school_code)
	areg graduated T1_treat T2_treat T3_treat suba $BASELINE7 if SS ~= 1 & grade == 11 & fu_observed == 1, absorb(school_code) cluster(school_code)

*Colinearity
areg s_years_back suba $BASELINE6 if SS ~= 1 & grade == 11 & fu_observed == 1, absorb(school_code) cluster(school_code)

xi: reg tertiary T1_treat T2_treat $varbaseline i.school_code if SS ~= 1 & suba == 0 & grade == 11 & fu_observed == 1, cluster(school_code)
	areg tertiary T1_treat T2_treat $BASELINE7 if SS ~= 1 & suba == 0 & grade == 11 & fu_observed == 1, absorb(school_code) cluster(school_code)

xi: reg tertiary T3_treat $varbaseline i.school_code if SS ~= 1 & suba == 1 & grade == 11 & fu_observed == 1, cluster(school_code)
	areg tertiary T3_treat $BASELINE6 if SS ~= 1 & suba == 1 & grade == 11 & fu_observed == 1, absorb(school_code) cluster(school_code)

xi: reg tertiary T1_treat T2_treat T3_treat $varbaseline i.school_code if SS ~= 1 & grade == 11 & fu_observed == 1, cluster(school_code)
	areg tertiary T1_treat T2_treat T3_treat suba $BASELINE7 if SS ~= 1 & grade == 11 & fu_observed == 1, absorb(school_code) cluster(school_code)




*Table 8 - All okay

foreach var in fu_primary_study fu_primary_work fu_primary_home fu_hrs_last_wwk fu_earn_last_wwk {
   xi: reg `var' T1_treat T2_treat $varbaseline i.school_code if SS ~= 1 & survey_selected & fu_observed & grade < 11 & ~suba, cluster(school_code)
	areg `var' T1_treat T2_treat GRADE2-GRADE4 $BASELINE1 if SS ~= 1 & survey_selected & fu_observed & grade < 11 & ~suba, absorb(school_code) cluster(school_code)

   xi: reg `var' T3_treat $varbaseline i.school_code if SS ~= 1 & survey_selected & fu_observed & grade < 11 & suba & grade > 8, cluster(school_code)
	areg `var' T3_treat $BASELINE1 if SS ~= 1 & survey_selected & fu_observed & grade < 11 & suba & grade > 8, absorb(school_code) cluster(school_code)

   }

foreach var in fu_primary_study fu_primary_work fu_primary_home fu_hrs_last_wwk fu_earn_last_wwk {
   xi: reg `var' T1_treat T2_treat $varbaseline i.school_code if SS ~= 1 & survey_selected & fu_observed & grade == 11 & ~suba, cluster(school_code)
	areg `var' T1_treat T2_treat $BASELINE7 if SS ~= 1 & survey_selected & fu_observed & grade == 11 & ~suba, absorb(school_code) cluster(school_code)

   xi: reg `var' T3_treat $varbaseline i.school_code if SS ~= 1 & survey_selected & fu_observed & grade == 11 & suba & grade > 8, cluster(school_code)
	areg `var' T3_treat $BASELINE6 if SS ~= 1 & survey_selected & fu_observed & grade == 11 & suba & grade > 8, absorb(school_code) cluster(school_code)
   }


*Table 9 & 10 - All okay

xi: reg at_msamean tsib suba $varbaseline i.school_code if SS ~= 1 & control == 1 & S == 1, cluster(school_code)
	areg at_msamean tsib GRADE2-GRADE4 $BASELINE1 if SS ~= 1 & control == 1 & S == 1, absorb(school_code) cluster(school_code)

xi: reg m_enrolled tsib suba $varbaseline i.school_code if SS ~= 1 & control == 1 & S == 1, cluster(school_code)
	areg m_enrolled tsib GRADE2-GRADE4 $BASELINE8 if SS ~= 1 & control == 1 & S == 1, absorb(school_code) cluster(school_code)

*Don't vary
sum S_ESTCIVIL* if SS ~= 1 & control == 1 & S == 1 & m_enrolled ~= .

xi: reg at_msamean tsib suba $varbaseline i.school_code if SS ~= 1 & control == 1 & s_sexo == 0 & S == 1, cluster(school_code)
	areg at_msamean tsib GRADE2-GRADE4 $BASELINES1 if SS ~= 1 & control == 1 & s_sexo == 0 & S == 1, absorb(school_code) cluster(school_code)

xi: reg m_enrolled tsib suba $varbaseline i.school_code if SS ~= 1 & control == 1 & s_sexo == 0 & S == 1, cluster(school_code)
	areg m_enrolled tsib GRADE2-GRADE4 $BASELINE9 if SS ~= 1 & control == 1 & s_sexo == 0 & S == 1, absorb(school_code) cluster(school_code)

*Don't vary
sum S_ESTCIVIL* s_sexo if SS ~= 1 & control == 1 & s_sexo == 0 & S == 1 & m_enrolled ~= .

xi: reg at_msamean tsib suba $varbaseline i.school_code if SS ~= 1 & control == 1 & s_sexo == 1 & S == 1, cluster(school_code)
	areg at_msamean tsib GRADE2-GRADE4 $BASELINE10 if SS ~= 1 & control == 1 & s_sexo == 1 & S == 1, absorb(school_code) cluster(school_code)

*Don't vary
sum S_ESTCIVIL3 s_sexo if SS ~= 1 & control == 1 & s_sexo == 1 & S == 1 & at_msamean ~= .

xi: reg m_enrolled tsib suba $varbaseline i.school_code if SS ~= 1 & control == 1 & s_sexo == 1 & S == 1, cluster(school_code)
	areg m_enrolled tsib GRADE2-GRADE4 $BASELINE9 if SS ~= 1 & control == 1 & s_sexo == 1 & S == 1, absorb(school_code) cluster(school_code)

*Don't vary
sum S_ESTCIVIL* s_sexo if SS ~= 1 & control == 1 & s_sexo == 1 & S == 1 & m_enrolled ~= .

xi: reg at_msamean treatment suba $varbaseline i.school_code if SS ~= 1 & num_tsib == 1 & S == 1, cluster(school_code)
	areg at_msamean treatment suba GRADE2-GRADE4 $BASELINE4 if SS ~= 1 & num_tsib == 1 & S == 1, absorb(school_code) cluster(school_code)

*Doesn't vary
sum S_ESTCIVIL3 if SS ~= 1 & num_tsib == 1 & S == 1 & at_msamean ~= .

xi: reg m_enrolled treatment suba $varbaseline i.school_code if SS ~= 1 & num_tsib == 1 & S == 1, cluster(school_code)
	areg m_enrolled treatment suba GRADE2-GRADE4 $BASELINE8 if SS ~= 1 & num_tsib == 1 & S == 1, absorb(school_code) cluster(school_code)

*Don't vary
sum S_ESTCIVIL* if SS ~= 1 & num_tsib == 1 & S == 1 & m_enrolled ~= .

xi: reg at_msamean tsib suba $varbaseline i.school_code if SS ~= 1 & control == 0 & S == 1, cluster(school_code)
	areg at_msamean tsib suba GRADE2-GRADE4 $BASELINE1 if SS ~= 1 & control == 0 & S == 1, absorb(school_code) cluster(school_code)

xi: reg m_enrolled tsib suba $varbaseline i.school_code if SS ~= 1 & control == 0 & S == 1, cluster(school_code)
	areg m_enrolled tsib suba GRADE2-GRADE4 $BASELINE8 if SS ~= 1 & control == 0 & S == 1, absorb(school_code) cluster(school_code)

save DatBBLP, replace







