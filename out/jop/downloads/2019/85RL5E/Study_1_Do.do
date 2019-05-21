* Setting the working directory <to be changed in one's own WD> * 
cd "C:\Users\теош\Desktop"

* Loading the dataset *
use "Institutions_corruption_JOP_Study_1_Data.dta", replace

*************************
** Main text (Table 1) **
*************************

xtset city_id year

* Model 1 - barebones speficiation
xtreg mayor_vote allegations y2013 y2013_allegations if dismissal_city!=1, fe cluster (city_id)
outreg2 using Table_1.doc, replace se dec(3) alpha (.001, .01, .05, .1) ///
symbol (***, **, *, +) addstat(Adj. R-Squared, (e(r2_a))) ///
addtext(City Fixed-effects, "YES", Incumbent-level controls, "NO", City-level controls, "NO") ///
title ("Table 1. Estimating the effect of corruption-based dismissal on electoral sanctioning")

* Calculating the difference b/w low- and high-integrity cities in 2003 & 2008 vs. 2013
lincom allegations + y2013_allegations


* Model 2 - barebones speficiation - with a Low-intergrity X 2008 interaction term
xtreg mayor_vote allegations y2008 y2013 y2008_allegations y2013_allegations if dismissal_city!=1, fe cluster (city_id)
outreg2 using Table_1.doc, append se dec(3) alpha (.001, .01, .05, .1) ///
symbol (***, **, *, +) addstat(Adj. R-Squared, (e(r2_a))) ///
addtext(City Fixed-effects, "YES", Incumbent-level controls, "NO", City-level controls, "NO") 

* Calculating the significance of the diff. b/w the interactions in 2008 & 2013
test y2008_allegations= y2013_allegations

* Calculating the difference b/w low- and high-integrity cities in 2003 & 2008
lincom allegations + y2008_allegations

* Calculating the difference b/w low- and high-integrity cities in 2003 & 2013
lincom allegations + y2013_allegations

* Calculating the difference b/w low- and high-integrity cities in 2008 & 2013
lincom  y2013_allegations -  y2008_allegations


* Model 3 - adding time-variant incumbent-level & city-level controls
xtreg mayor_vote allegations y2013 y2013_allegations ///
mayor_age mayor_prior_reign non_elected_incumbent ///
log_pop avg_class_size avg_salary if dismissal_city!=1, fe cluster (city_id)
outreg2 using Table_1.doc, append se dec(3) alpha (.001, .01, .05, .1) ///
symbol (***, **, *, +) addstat(Adj. R-Squared, (e(r2_a))) ///
keep(allegations y2013 y2013_allegations) ///
addtext(City Fixed-effects, "YES", Incumbent-level controls, "YES", City-level controls, "YES") 

* Calculating the difference b/w low- and high-integrity cities in 2003 & 2008 vs. 2013
lincom allegations + y2013_allegations


* Model 4 - Model 3 + no of opponents & strong challenger
xtreg mayor_vote allegations y2013 y2013_allegations ///
mayor_age mayor_prior_reign non_elected_incumbent ///
log_pop avg_class_size avg_salary ln_opp opponent_ex_mayor if dismissal_city!=1, fe cluster (city_id)
outreg2 using Table_1.doc, append se dec(3) alpha (.001, .01, .05, .1) ///
symbol (***, **, *, +) addstat(Adj. R-Squared, (e(r2_a))) ///
keep(allegations y2013 y2013_allegations ln_opp opponent_ex_mayor) ///
addtext(City Fixed-effects, "YES", Incumbent-level controls, "YES", City-level controls, "YES") 

* Calculating the difference b/w low- and high-integrity cities in 2003 & 2008 vs. 2013
lincom allegations + y2013_allegations

* Additional model (not shown in Table  1) - interaction 2013 with all other variables
xtreg mayor_vote i.y2013##i.allegations i.y2013##c.mayor_age i.y2013##c.mayor_prior_reign ///
i.y2013##i.non_elected_incumbent i.y2013##c.log_pop i.y2013##c.avg_class_size ///
i.y2013##c.avg_salary i.y2013##c.ln_opp i.y2013##i.opponent_ex_mayor if dismissal_city!=1, fe cluster (city_id)
margins i.y2013##i.allegations


*********************
** Online Appendix **
*********************

***** Summary statistics - Table A1 *****

outreg2 using Summary_table.doc if dismissal_city!=1, replace sum(log) ///
keep (mayor_vote y2003 y2008 y2013 allegations mayor_age mayor_prior_reign ///
non_elected_incumbent population avg_class_size avg_salary ln_opp opponent_ex_mayor) ///
title (Table A1. Descriptive statistics)


*****************************
** Table A2 - full results **
*****************************
xtset city_id year

* Model 1 - barebones speficiation
xtreg mayor_vote allegations y2013 y2013_allegations if dismissal_city!=1, fe cluster (city_id)
outreg2 using Table_A2.doc, replace se dec(3) alpha (.001, .01, .05, .1) ///
symbol (***, **, *, +) addstat(Adj. R-Squared, (e(r2_a))) ///
addtext(City Fixed-effects, "YES") ///
title ("Table A2. Full results of Table 1 in the main text")

* Model 2 - barebones speficiation - with a Low-intergrity X 2008 interaction term
xtreg mayor_vote allegations y2008 y2013 y2008_allegations y2013_allegations if dismissal_city!=1, fe cluster (city_id)
outreg2 using Table_A2.doc, append se dec(3) alpha (.001, .01, .05, .1) ///
symbol (***, **, *, +) addstat(Adj. R-Squared, (e(r2_a))) ///
addtext(City Fixed-effects, "YES") 

* Model 3 - adding time-variant incumbent-level & city-level controls
xtreg mayor_vote allegations y2013 y2013_allegations ///
mayor_age mayor_prior_reign non_elected_incumbent ///
log_pop avg_class_size avg_salary if dismissal_city!=1, fe cluster (city_id)
outreg2 using Table_A2.doc, append se dec(3) alpha (.001, .01, .05, .1) ///
symbol (***, **, *, +) addstat(Adj. R-Squared, (e(r2_a))) ///
addtext(City Fixed-effects, "YES")

* Model 4 - Model 3 + no of opponents & strong challenger
xtreg mayor_vote allegations y2013 y2013_allegations ///
mayor_age mayor_prior_reign non_elected_incumbent ///
log_pop avg_class_size avg_salary ln_opp opponent_ex_mayor if dismissal_city!=1, fe cluster (city_id)
outreg2 using Table_A2.doc, append se dec(3) alpha (.001, .01, .05, .1) ///
symbol (***, **, *, +) addstat(Adj. R-Squared, (e(r2_a))) ///
addtext(City Fixed-effects, "YES")


******************************
** Table A3 - Actual voters **
******************************

xtset city_id year

* Model 1 - barebones speficiation
xtreg mayor_vote2 allegations y2013 y2013_allegations if dismissal_city!=1, fe cluster (city_id)
outreg2 using Table_A3.doc, replace se dec(3) alpha (.001, .01, .05, .1) ///
symbol (***, **, *, +) addstat(Adj. R-Squared, (e(r2_a))) ///
addtext(City Fixed-effects, "YES", Incumbent-level controls, "NO", City-level controls, "NO") ///
title ("Table A3. Robustness tests: The effect on actual voters")

* Calculating the difference b/w low- and high-integrity cities in 2003 & 2008 vs. 2013
lincom allegations + y2013_allegations

* Model 2 - barebones speficiation - with a Low-intergrity X 2008 interaction term
xtreg mayor_vote2 allegations y2008 y2013 y2008_allegations y2013_allegations if dismissal_city!=1, fe cluster (city_id)
outreg2 using Table_A3.doc, append se dec(3) alpha (.001, .01, .05, .1) ///
symbol (***, **, *, +) addstat(Adj. R-Squared, (e(r2_a))) ///
addtext(City Fixed-effects, "YES", Incumbent-level controls, "NO", City-level controls, "NO") 

* Calculating the difference b/w low- and high-integrity cities in 2003 & 2008
lincom allegations + y2008_allegations

* Calculating the difference b/w low- and high-integrity cities in 2003 & 2013
lincom allegations + y2013_allegations

* Calculating the difference b/w low- and high-integrity cities in 2008 & 2013
lincom  y2013_allegations -  y2008_allegations


* Model 3 - adding time-variant incumbent-level & city-level controls
xtreg mayor_vote2 allegations y2013 y2013_allegations ///
mayor_age mayor_prior_reign non_elected_incumbent ///
log_pop avg_class_size avg_salary if dismissal_city!=1, fe cluster (city_id)
outreg2 using Table_A3.doc, append se dec(3) alpha (.001, .01, .05, .1) ///
symbol (***, **, *, +) addstat(Adj. R-Squared, (e(r2_a))) ///
keep(allegations y2013 y2013_allegations) ///
addtext(City Fixed-effects, "YES", Incumbent-level controls, "YES", City-level controls, "YES") 

* Calculating the difference b/w low- and high-integrity cities in 2003 & 2008 vs. 2013
lincom allegations + y2013_allegations

* Model 4 - Model 3 + no of opponents & strong challenger
xtreg mayor_vote2 allegations y2013 y2013_allegations ///
mayor_age mayor_prior_reign non_elected_incumbent ///
log_pop avg_class_size avg_salary ln_opp opponent_ex_mayor if dismissal_city!=1, fe cluster (city_id)
outreg2 using Table_A3.doc, append se dec(3) alpha (.001, .01, .05, .1) ///
symbol (***, **, *, +) addstat(Adj. R-Squared, (e(r2_a))) ///
keep(allegations y2013 y2013_allegations ln_opp opponent_ex_mayor) ///
addtext(City Fixed-effects, "YES", Incumbent-level controls, "YES", City-level controls, "YES") 

* Calculating the difference b/w low- and high-integrity cities in 2003 & 2008 vs. 2013
lincom allegations + y2013_allegations



**************************
** Table A4 - Jackknife **
**************************
xtset city_id year

* Model 1 - barebones speficiation
jackknife: xtreg mayor_vote allegations y2013 y2013_allegations if dismissal_city!=1, fe cluster (city_id)
outreg2 using Table_A4.doc, replace se dec(3) alpha (.001, .01, .05, .1) ///
symbol (***, **, *, +) addstat(Adj. R-Squared, (e(r2_a))) ///
addtext(City Fixed-effects, "YES", Incumbent-level controls, "NO", City-level controls, "NO") ///
title ("Table A4. Robustness test: With Jackknife estimation")

* Calculating the difference b/w low- and high-integrity cities in 2003 & 2008 vs. 2013
lincom allegations + y2013_allegations

* Model 2 - barebones speficiation - with a Low-intergrity X 2008 interaction term
jackknife: xtreg mayor_vote allegations y2008 y2013 y2008_allegations y2013_allegations if dismissal_city!=1, fe cluster (city_id)
outreg2 using Table_A4.doc, append se dec(3) alpha (.001, .01, .05, .1) ///
symbol (***, **, *, +) addstat(Adj. R-Squared, (e(r2_a))) ///
addtext(City Fixed-effects, "YES", Incumbent-level controls, "NO", City-level controls, "NO") 


* Calculating the difference b/w low- and high-integrity cities in 2003 & 2008
lincom allegations + y2008_allegations

* Calculating the difference b/w low- and high-integrity cities in 2003 & 2013
lincom allegations + y2013_allegations

* Calculating the difference b/w low- and high-integrity cities in 2008 & 2013
lincom  y2013_allegations -  y2008_allegations

* Model 3 - adding time-variant incumbent-level & city-level controls
jackknife: xtreg mayor_vote allegations y2013 y2013_allegations ///
mayor_age mayor_prior_reign non_elected_incumbent ///
log_pop avg_class_size avg_salary if dismissal_city!=1, fe cluster (city_id)
outreg2 using Table_A4.doc, append se dec(3) alpha (.001, .01, .05, .1) ///
symbol (***, **, *, +) addstat(Adj. R-Squared, (e(r2_a))) ///
keep(allegations y2013 y2013_allegations) ///
addtext(City Fixed-effects, "YES", Incumbent-level controls, "YES", City-level controls, "YES") 

* Calculating the difference b/w low- and high-integrity cities in 2003 & 2008 vs. 2013
lincom allegations + y2013_allegations

* Model 4 - Model 3 + no of opponents & strong challenger
jackknife: xtreg mayor_vote allegations y2013 y2013_allegations ///
mayor_age mayor_prior_reign non_elected_incumbent ///
log_pop avg_class_size avg_salary ln_opp opponent_ex_mayor if dismissal_city!=1, fe cluster (city_id)
outreg2 using Table_A4.doc, append se dec(3) alpha (.001, .01, .05, .1) ///
symbol (***, **, *, +) addstat(Adj. R-Squared, (e(r2_a))) ///
keep(allegations y2013 y2013_allegations ln_opp opponent_ex_mayor) ///
addtext(City Fixed-effects, "YES", Incumbent-level controls, "YES", City-level controls, "YES") 

* Calculating the difference b/w low- and high-integrity cities in 2003 & 2008 vs. 2013
lincom allegations + y2013_allegations

**********************************************************************
** Table A5 - only with cities appearing three times in the dataset **
**********************************************************************
bysort city_id: egen city_count=count(city_id)

* Model 1 - barebones speficiation
xtreg mayor_vote allegations y2013 y2013_allegations if dismissal_city!=1 & city_count==3, fe cluster (city_id)
outreg2 using Table_A5.doc, replace se dec(3) alpha (.001, .01, .05, .1) ///
symbol (***, **, *, +) addstat(Adj. R-Squared, (e(r2_a))) ///
addtext(City Fixed-effects, "YES", Incumbent-level controls, "NO", City-level controls, "NO") 

* Calculating the difference b/w low- and high-integrity cities in 2003 & 2008 vs. 2013
lincom allegations + y2013_allegations

* Model 2 - barebones speficiation - with a Low-intergrity X 2008 interaction term
xtreg mayor_vote allegations y2008 y2013 y2008_allegations y2013_allegations if dismissal_city!=1 & city_count==3, fe cluster (city_id)
outreg2 using Table_A5.doc, append se dec(3) alpha (.001, .01, .05, .1) ///
symbol (***, **, *, +) addstat(Adj. R-Squared, (e(r2_a))) ///
addtext(City Fixed-effects, "YES", Incumbent-level controls, "NO", City-level controls, "NO") 

* Calculating the difference b/w low- and high-integrity cities in 2003 & 2008
lincom allegations + y2008_allegations
* Calculating the difference b/w low- and high-integrity cities in 2003 & 2013
lincom allegations + y2013_allegations
* Calculating the difference b/w low- and high-integrity cities in 2008 & 2013
lincom  y2013_allegations -  y2008_allegations


* Model 3 - adding time-variant incumbent-level & city-level controls
xtreg mayor_vote allegations y2013 y2013_allegations ///
mayor_age mayor_prior_reign non_elected_incumbent ///
log_pop avg_class_size avg_salary if dismissal_city!=1 & city_count==3, fe cluster (city_id)
outreg2 using Table_A5.doc, append se dec(3) alpha (.001, .01, .05, .1) ///
symbol (***, **, *, +) addstat(Adj. R-Squared, (e(r2_a))) ///
keep(allegations y2013 y2013_allegations) ///
addtext(City Fixed-effects, "YES", Incumbent-level controls, "YES", City-level controls, "YES") 

* Calculating the difference b/w low- and high-integrity cities in 2003 & 2008 vs. 2013
lincom allegations + y2013_allegations

* Model 4 - Model 3 + no of opponents & strong challenger
xtreg mayor_vote allegations y2013 y2013_allegations ///
mayor_age mayor_prior_reign non_elected_incumbent ///
log_pop avg_class_size avg_salary ln_opp opponent_ex_mayor if dismissal_city!=1 & city_count==3, fe cluster (city_id)
outreg2 using Table_A5.doc, append se dec(3) alpha (.001, .01, .05, .1) ///
symbol (***, **, *, +) addstat(Adj. R-Squared, (e(r2_a))) ///
keep(allegations y2013 y2013_allegations ln_opp opponent_ex_mayor) ///
addtext(City Fixed-effects, "YES", Incumbent-level controls, "YES", City-level controls, "YES") 

* Calculating the difference b/w low- and high-integrity cities in 2003 & 2008 vs. 2013
lincom allegations + y2013_allegations

drop city_count


***********************************
*** Additional robustness tests ***
***********************************

**  Analyses with dropping 1 of the 5 corruption cases of 2013 **
sort year allegations dismissal_city
gen id=_n

** Re-estimating Model 1 (in Table 1) five times (all p-values < .004)
xtset city_id year

xtreg mayor_vote allegations y2013 y2013_allegations if dismissal_city!=1 & id!=170, fe cluster (city_id)
xtreg mayor_vote allegations y2013 y2013_allegations if dismissal_city!=1 & id!=171, fe cluster (city_id)
xtreg mayor_vote allegations y2013 y2013_allegations if dismissal_city!=1 & id!=172, fe cluster (city_id)
xtreg mayor_vote allegations y2013 y2013_allegations if dismissal_city!=1 & id!=173, fe cluster (city_id)
xtreg mayor_vote allegations y2013 y2013_allegations if dismissal_city!=1 & id!=174, fe cluster (city_id)

** Re-estimating Model 2 (in Table 1) five times (all p-values b/w .006 & .065)
xtreg mayor_vote allegations y2008 y2013 y2008_allegations y2013_allegations if dismissal_city!=1 & id!=170, fe cluster (city_id)
xtreg mayor_vote allegations y2008 y2013 y2008_allegations y2013_allegations if dismissal_city!=1 & id!=171, fe cluster (city_id)
xtreg mayor_vote allegations y2008 y2013 y2008_allegations y2013_allegations if dismissal_city!=1 & id!=172, fe cluster (city_id)
xtreg mayor_vote allegations y2008 y2013 y2008_allegations y2013_allegations if dismissal_city!=1 & id!=173, fe cluster (city_id)
xtreg mayor_vote allegations y2008 y2013 y2008_allegations y2013_allegations if dismissal_city!=1 & id!=174, fe cluster (city_id)

** Re-estimating Model 3 (in Table 1) five times (all p-values < .001)
xtreg mayor_vote allegations y2013 y2013_allegations ///
mayor_age mayor_prior_reign non_elected_incumbent ///
log_pop avg_class_size avg_salary if dismissal_city!=1  & id!=170, fe cluster (city_id)
xtreg mayor_vote allegations y2013 y2013_allegations ///
mayor_age mayor_prior_reign non_elected_incumbent ///
log_pop avg_class_size avg_salary if dismissal_city!=1  & id!=171, fe cluster (city_id)
xtreg mayor_vote allegations y2013 y2013_allegations ///
mayor_age mayor_prior_reign non_elected_incumbent ///
log_pop avg_class_size avg_salary if dismissal_city!=1  & id!=172, fe cluster (city_id)
xtreg mayor_vote allegations y2013 y2013_allegations ///
mayor_age mayor_prior_reign non_elected_incumbent ///
log_pop avg_class_size avg_salary if dismissal_city!=1  & id!=173, fe cluster (city_id)
xtreg mayor_vote allegations y2013 y2013_allegations ///
mayor_age mayor_prior_reign non_elected_incumbent ///
log_pop avg_class_size avg_salary if dismissal_city!=1  & id!=174, fe cluster (city_id)

	
** Re-estimating Model 4 (in Table 1) five times (all p-values b/w .001 & .035)
xtreg mayor_vote allegations y2013 y2013_allegations ///
mayor_age mayor_prior_reign non_elected_incumbent ///
log_pop avg_class_size avg_salary ln_opp opponent_ex_mayor if dismissal_city!=1  & id!=170, fe cluster (city_id)
xtreg mayor_vote allegations y2013 y2013_allegations ///
mayor_age mayor_prior_reign non_elected_incumbent ///
log_pop avg_class_size avg_salary ln_opp opponent_ex_mayor if dismissal_city!=1  & id!=171, fe cluster (city_id)
xtreg mayor_vote allegations y2013 y2013_allegations ///
mayor_age mayor_prior_reign non_elected_incumbent ///
log_pop avg_class_size avg_salary ln_opp opponent_ex_mayor if dismissal_city!=1  & id!=172, fe cluster (city_id)
xtreg mayor_vote allegations y2013 y2013_allegations ///
mayor_age mayor_prior_reign non_elected_incumbent ///
log_pop avg_class_size avg_salary ln_opp opponent_ex_mayor if dismissal_city!=1  & id!=173, fe cluster (city_id)
xtreg mayor_vote allegations y2013 y2013_allegations ///
mayor_age mayor_prior_reign non_elected_incumbent ///
log_pop avg_class_size avg_salary ln_opp opponent_ex_mayor if dismissal_city!=1  & id!=174, fe cluster (city_id)

drop id

** Analyzing Re-election rates **
tab reel allegations if year!=2, chi col exact /* p = .314*/
tab reel allegations if year==0, chi col exact /* p = .314; Exact = .632*/
tab reel allegations if year==1, chi col exact /* p = .290; Exact = .309*/

tab reel allegations if year==2 & dis==0, chi col exact /* p = .025; Exact = .044*/


** Permutation tests **

drop if dismissal_city==1
save "C:\Users\теош\Desktop\rand_data.dta", replace

*** First re-randomization ***

* Creating a random subset of 5 "low-integrity" cities in 2013
sort year
set seed 11790
randomtag if year==2, count(5) generate(random_2013_cities)

gen alleg_rand=allegations if year!=2
replace alleg_rand=0 if year==2
replace alleg_rand=1 if random_2013_cities==1
gen alleg_rand_2013=alleg_rand*y2013

set more off
xtreg mayor_vote alleg_rand y2013 alleg_rand_2013 if dismissal_city!=1, fe cluster (city_id)
gen b_model_1= _b[alleg_rand_2013]
gen t_model_1= (_b[alleg_rand_2013]/_se[alleg_rand_2013])
xtreg mayor_vote alleg_rand y2013 alleg_rand_2013 i.alleg_rand##i.y2008 if dismissal_city!=1, fe cluster (city_id)
gen b_model_2= _b[alleg_rand_2013]
gen t_model_2= (_b[alleg_rand_2013]/_se[alleg_rand_2013])
xtreg mayor_vote alleg_rand y2013 alleg_rand_2013 mayor_age mayor_prior_reign non_elected_incumbent ///
log_pop avg_class_size avg_salary if dismissal_city!=1, fe cluster (city_id)
gen b_model_3= _b[alleg_rand_2013]
gen t_model_3= (_b[alleg_rand_2013]/_se[alleg_rand_2013])
xtreg mayor_vote alleg_rand y2013 alleg_rand_2013 mayor_age mayor_prior_reign non_elected_incumbent ///
log_pop avg_class_size avg_salary ln_opp opponent_ex_mayor if dismissal_city!=1, fe cluster (city_id)
gen b_model_4= _b[alleg_rand_2013]
gen t_model_4= (_b[alleg_rand_2013]/_se[alleg_rand_2013])
keep b_model_1 t_model_1 b_model_2 t_model_2 b_model_3 t_model_3 b_model_4 t_model_4
drop in 2/174
save "C:\Users\теош\Desktop\results_rand.dta", replace


*** The loop for the other 9999 re-randomizations ***

** PAY ATTENTION! THIS WILL TAKE ABOUT TWO HOURS & 15 MINUTES TO RUN...

forvalues i = 1(1)9999 {
use "C:\Users\теош\Desktop\rand_data.dta", replace
sort year 
*city

* Creating a random subset of 5 "low-integrity" cities in 2013
randomtag if year==2, count(5) generate(random_2013_cities)

gen alleg_rand=allegations if year!=2
replace alleg_rand=0 if year==2
replace alleg_rand=1 if random_2013_cities==1	
gen alleg_rand_2013=alleg_rand*y2013
set more off
xtreg mayor_vote alleg_rand y2013 alleg_rand_2013 if dismissal_city!=1, fe cluster (city_id)
gen b_model_1= _b[alleg_rand_2013]
gen t_model_1= (_b[alleg_rand_2013]/_se[alleg_rand_2013])
xtreg mayor_vote alleg_rand y2013 alleg_rand_2013 i.alleg_rand##i.y2008 if dismissal_city!=1, fe cluster (city_id)
gen b_model_2= _b[alleg_rand_2013]
gen t_model_2= (_b[alleg_rand_2013]/_se[alleg_rand_2013])
xtreg mayor_vote alleg_rand y2013 alleg_rand_2013 mayor_age mayor_prior_reign non_elected_incumbent ///
log_pop avg_class_size avg_salary if dismissal_city!=1, fe cluster (city_id)
gen b_model_3= _b[alleg_rand_2013]
gen t_model_3= (_b[alleg_rand_2013]/_se[alleg_rand_2013])
xtreg mayor_vote alleg_rand y2013 alleg_rand_2013 mayor_age mayor_prior_reign non_elected_incumbent ///
log_pop avg_class_size avg_salary ln_opp opponent_ex_mayor if dismissal_city!=1, fe cluster (city_id)
gen b_model_4= _b[alleg_rand_2013]
gen t_model_4= (_b[alleg_rand_2013]/_se[alleg_rand_2013])
keep b_model_1 t_model_1 b_model_2 t_model_2 b_model_3 t_model_3 b_model_4 t_model_4
drop in 2/174
save "C:\Users\теош\Desktop\results_rand_disposable.dta", replace
use "C:\Users\теош\Desktop\results_rand.dta", replace
append using "C:\Users\теош\Desktop\results_rand_disposable.dta"
save "C:\Users\теош\Desktop\results_rand.dta", replace
erase "C:\Users\теош\Desktop\results_rand_disposable.dta"

}



gen b_eorb_than_orig_1=1 if b_model_1<= -.1025973
recode b_eorb_than_orig_1 (.=0)
tab b_eorb_than_orig_1
gen t_eorb_than_orig_1=1 if t_model_1<= -3.4995839 
recode t_eorb_than_orig_1 (.=0)
tab t_eorb_than_orig_1

gen b_eorb_than_orig_2=1 if b_model_2<= -.0961273
recode b_eorb_than_orig_2 (.=0)
tab b_eorb_than_orig_2
gen t_eorb_than_orig_2=1 if t_model_2<= -2.2869919 
recode t_eorb_than_orig_2 (.=0)
tab t_eorb_than_orig_2

gen b_eorb_than_orig_3=1 if b_model_3<= -.1181174
recode b_eorb_than_orig_3 (.=0)
tab b_eorb_than_orig_3
gen t_eorb_than_orig_3=1 if t_model_3<= -4.9872866 
recode t_eorb_than_orig_3 (.=0)
tab t_eorb_than_orig_3

gen b_eorb_than_orig_4=1 if b_model_4<= -.0772283  
recode b_eorb_than_orig_4 (.=0)
tab b_eorb_than_orig_4
gen t_eorb_than_orig_4=1 if t_model_4<= -2.7977518
recode t_eorb_than_orig_4 (.=0)
tab t_eorb_than_orig_4


************
** Graphs **
************
* adding the original results
replace b_model_1 = -.1025973 in 10001 /*this is done manually...*/
replace t_model_1 = -3.4995839 in 10001
replace b_model_2 = -.0961273 in 10001
replace t_model_2 =  -2.2869919 in 10001
replace b_model_3 = -.1181174 in 10001
replace t_model_3 = -4.9872866 in 10001
replace b_model_4 = -.0772283 in 10001
replace t_model_4 = -2.7977518 in 10001

gen id=_n
gen random=1 if id>=1 & id<=10000
replace random=0 if id==10001



* FIGURE A1
scatter b_model_1 t_model_1 if random==1, jitter(2) msymbol(oh) mc(gray) msize(vsmall)  ///
 || scatter b_model_1 t_model_1 if random==0, ///
 mlabcolor (blue) msize(large) msymbol(X) mc(blue) xscale(range(-5(2)5)) ///
 ytitle("Point estimate", size(3.5)) ///
 xtitle("t-statistic", size(3.5)) ///
 legend(off) title(Model 1) graphregion(fcolor(white) lcolor(white)) 
/* yla(,nogrid) */
graph save "Figure A1.gph", replace

* FIGURE A2
scatter b_model_2 t_model_2 if random==1, jitter(2) msymbol(oh) mc(gray) msize(vsmall)  ///
 || scatter b_model_2 t_model_2 if random==0, ///
 mlabcolor (blue) msize(large) msymbol(X) mc(blue) xscale(range(-3(2)5)) ///
 ytitle("Point estimate", size(3.5)) ///
 xtitle("t-statistic", size(3.5)) ///
 legend(off) title(Model 2) graphregion(fcolor(white) lcolor(white)) 
graph save "Figure A2.gph", replace

* FIGURE A3
scatter b_model_3 t_model_3 if random==1, jitter(2) msymbol(oh) mc(gray) msize(vsmall)  ///
 || scatter b_model_3 t_model_3 if random==0, ///
 mlabcolor (blue) msize(large) msymbol(X) mc(blue) ///
 ytitle("Point estimate", size(3.5)) ///
 xtitle("t-statistic", size(3.5)) ///
 legend(off) title(Model 3) graphregion(fcolor(white) lcolor(white)) 
graph save "Figure A3.gph", replace

* FIGURE A4
scatter b_model_4 t_model_4 if random==1, jitter(2) msymbol(oh) mc(gray) msize(vsmall)  ///
 || scatter b_model_4 t_model_4 if random==0, ///
 mlabcolor (blue) msize(large) msymbol(X) mc(blue) xscale(range(-5(2)5)) ///
 ytitle("Point estimate", size(3.5)) ///
 xtitle("t-statistic", size(3.5)) ///
 legend(off) title(Model 4) graphregion(fcolor(white) lcolor(white)) 
graph save "Figure A4.gph", replace



erase "C:\Users\теош\Desktop\results_rand.dta"
erase "C:\Users\теош\Desktop\rand_data.dta"
