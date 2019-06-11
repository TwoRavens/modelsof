
capture log close
log using "replication.log", replace 
use US_data.dta


/*TABULATE ALL VARIABLES*/
set more off 

***************** cleaning variables *********************

recode gender 1=0 2=1

*** education ***

gen edu_cat = .
replace edu_cat = 0 if edu <12
replace edu_cat = 1 if edu >12 
replace edu_cat = 2 if edu == 16
replace edu_cat = 3 if edu >16

gen democrat = .
replace democrat = 1 if vb11 == 1 
replace democrat = 0 if vb11 == 2

recode party3 2=0 1=2 3=1 4=1
recode party5 2=0 1=2 3=1 4=1

gen obama_therm = ft3a_1
gen romney_therm = ft3b_1
gen clinton_therm = ft3c_1
gen pelosi_therm = ft3d_1
gen rice_therm = ft3e_1
gen palin_therm = ft3f_1

gen terror_all = nr_intl_terror + rc_intl_terror + rp_intl_terror
sort treatments 

*** Figure 1 ***


ttest clinton_therm, by(control_vs_terror)
ttest clinton_therm, by(terror_vs_gt)

ttest pelosi_therm, by(control_vs_terror)
ttest pelosi_therm, by(terror_vs_gt)

ttest rice_therm, by(control_vs_terror)
ttest rice_therm, by(terror_vs_gt)

ttest palin_therm, by(control_vs_terror)
ttest palin_therm, by(terror_vs_gt)

ttest obama_therm, by(control_vs_terror)
ttest obama_therm, by(terror_vs_gt)

ttest romney_therm, by(control_vs_terror)
ttest romney_therm, by(terror_vs_gt)

*** Table 2 ***
sum clinton_therm
tab clinton_therm
by treatments: summarize (clinton_therm)
anova clinton_therm treatments
ttest clinton_therm, by(control_vs_terror)
ttest clinton_therm, by(control_vs_terror_nr)
ttest clinton_therm, by(control_vs_terror_rc)
ttest clinton_therm, by(control_vs_terror_rp)


sum pelosi_therm
tab pelosi_therm
by treatments: summarize (pelosi_therm)
anova pelosi_therm treatments
ttest pelosi_therm, by(control_vs_terror)
ttest pelosi_therm, by(control_vs_terror_nr)
ttest pelosi_therm, by(control_vs_terror_rc)
ttest pelosi_therm, by(control_vs_terror_rp)


sum obama_therm
tab obama_therm
by treatments: summarize (obama_therm)
anova obama_therm treatments
ttest obama_therm, by(control_vs_terror)
ttest obama_therm, by(control_vs_terror_nr)
ttest obama_therm, by(control_vs_terror_rc)
ttest obama_therm, by(control_vs_terror_rp)


**** Table 3 ****


sum rice_therm
tab rice_therm
by treatments: summarize (rice_therm)
anova rice_therm treatments
ttest rice_therm, by(control_vs_terror)
ttest rice_therm, by(control_vs_terror_nr)
ttest rice_therm, by(control_vs_terror_rc)
ttest rice_therm, by(control_vs_terror_rp)


sum palin_therm
tab palin_therm
by treatments: summarize (palin_therm)
anova palin_therm treatments
ttest palin_therm, by(control_vs_terror)
ttest palin_therm, by(control_vs_terror_nr)
ttest palin_therm, by(control_vs_terror_rc)
ttest palin_therm, by(control_vs_terror_rp)


sum romney_therm
tab romney_therm
by treatments: summarize (romney_therm)
anova romney_therm treatments
ttest romney_therm, by(control_vs_terror)
ttest romney_therm, by(control_vs_terror_nr)
ttest romney_therm, by(control_vs_terror_rc)
ttest romney_therm, by(control_vs_terror_rp)



**** appendix materials **** 

**** balancing and manipulation checks ****
*** manipulation checks ***

*** Table I **** 
gen white = 0
replace white = 1 if etid == 1
oneway white treatments, tab
oneway l1 treatments, tab


oneway gender treatments, tab
oneway age treatments, tab 
oneway edu treatments, tab


*** Table II **** 
eststo clear 
eststo: mlogit treatment age white gender l1 edu
esttab using "Table II.rtf", replace se(2) b(2) n star(+ .10 * .05 ** .01 *** .001)


*** Table III ***

sum emoa emob add_fear add_enthus add_anger
oneway add_fear treatments, tab
oneway add_enthus treatments, tab
oneway add_anger treatments, tab


ttest add_fear, by(control_vs_terror)
ttest add_fear, by(control_vs_terror_nr)
ttest add_fear, by(control_vs_terror_rc)
ttest add_fear, by(control_vs_terror_rp)
ttest add_fear, by(control_vs_gt)
ttest add_fear, by(terror_vs_gt)
ttest add_fear, by(terror_nr_vs_gt)
ttest add_fear, by(terror_rc_vs_gt)
ttest add_fear, by(terror_rp_vs_gt)



ttest add_anger, by(control_vs_terror)
ttest add_anger, by(control_vs_terror_nr)
ttest add_anger, by(control_vs_terror_rc)
ttest add_anger, by(control_vs_terror_rp)
ttest add_anger, by(control_vs_gt)
ttest add_anger, by(terror_vs_gt)
ttest add_anger, by(terror_nr_vs_gt)
ttest add_anger, by(terror_rc_vs_gt)
ttest add_anger, by(terror_rp_vs_gt)



ttest add_enthus, by(control_vs_terror)
ttest add_enthus, by(control_vs_terror_nr)
ttest add_enthus, by(control_vs_terror_rc)
ttest add_enthus, by(control_vs_terror_rp)
ttest add_enthus, by(control_vs_gt)
ttest add_enthus, by(terror_vs_gt)
ttest add_enthus, by(terror_nr_vs_gt)
ttest add_enthus, by(terror_rc_vs_gt)
ttest add_enthus, by(terror_rp_vs_gt)



*** Table VI *** 

sum clinton_therm
tab clinton_therm
by treatments: summarize (clinton_therm)
anova clinton_therm treatments
ttest clinton_therm, by(control_vs_terror)
ttest clinton_therm, by(control_vs_terror_nr)
ttest clinton_therm, by(control_vs_terror_rc)
ttest clinton_therm, by(control_vs_terror_rp)
ttest clinton_therm, by(control_vs_gt)
ttest clinton_therm, by(terror_vs_gt)
ttest clinton_therm, by(terror_nr_vs_gt)
ttest clinton_therm, by(terror_rc_vs_gt)
ttest clinton_therm, by(terror_rp_vs_gt)

sum pelosi_therm
tab pelosi_therm
by treatments: summarize (pelosi_therm)
anova pelosi_therm treatments
ttest pelosi_therm, by(control_vs_terror)
ttest pelosi_therm, by(control_vs_terror_nr)
ttest pelosi_therm, by(control_vs_terror_rc)
ttest pelosi_therm, by(control_vs_terror_rp)
ttest pelosi_therm, by(control_vs_gt)
ttest pelosi_therm, by(terror_vs_gt)
ttest pelosi_therm, by(terror_nr_vs_gt)
ttest pelosi_therm, by(terror_rc_vs_gt)
ttest pelosi_therm, by(terror_rp_vs_gt)

sum obama_therm
tab obama_therm
by treatments: summarize (obama_therm)
anova obama_therm treatments
ttest obama_therm, by(control_vs_terror)
ttest obama_therm, by(control_vs_terror_nr)
ttest obama_therm, by(control_vs_terror_rc)
ttest obama_therm, by(control_vs_terror_rp)
ttest obama_therm, by(control_vs_gt)
ttest obama_therm, by(terror_vs_gt)
ttest obama_therm, by(terror_nr_vs_gt)
ttest obama_therm, by(terror_rc_vs_gt)
ttest obama_therm, by(terror_rp_vs_gt)

*** Table VII ***

anova rice_therm treatments
ttest rice_therm, by(control_vs_terror)
ttest rice_therm, by(control_vs_terror_nr)
ttest rice_therm, by(control_vs_terror_rc)
ttest rice_therm, by(control_vs_terror_rp)
ttest rice_therm, by(control_vs_gt)
ttest rice_therm, by(terror_vs_gt)
ttest rice_therm, by(terror_nr_vs_gt)
ttest rice_therm, by(terror_rc_vs_gt)
ttest rice_therm, by(terror_rp_vs_gt)

anova palin_therm treatments
ttest palin_therm, by(control_vs_terror)
ttest palin_therm, by(control_vs_terror_nr)
ttest palin_therm, by(control_vs_terror_rc)
ttest palin_therm, by(control_vs_terror_rp)
ttest palin_therm, by(control_vs_gt)
ttest palin_therm, by(terror_vs_gt)
ttest palin_therm, by(terror_nr_vs_gt)
ttest palin_therm, by(terror_rc_vs_gt)
ttest palin_therm, by(terror_rp_vs_gt)

anova romney_therm treatments
ttest romney_therm, by(control_vs_terror)
ttest romney_therm, by(control_vs_terror_nr)
ttest romney_therm, by(control_vs_terror_rc)
ttest romney_therm, by(control_vs_terror_rp)
ttest romney_therm, by(control_vs_gt)
ttest romney_therm, by(terror_vs_gt)
ttest romney_therm, by(terror_nr_vs_gt)
ttest romney_therm, by(terror_rc_vs_gt)
ttest romney_therm, by(terror_rp_vs_gt)

*** Table VII ***

eststo clear
eststo clear  
eststo clinton_therm: reg clinton_therm terror_all if econ_threat==0 &  good_times  == 0
estimates store clinton, title(Clinton Therm)
eststo pelosi_therm: reg pelosi_therm terror_all if econ_threat==0 &  good_times  == 0
estimates store pelosi, title(Pelosi Therm)
eststo rice_therm: reg rice_therm terror_all if econ_threat==0 &  good_times  == 0
estimates store rice, title(Rice Therm)
eststo palin_therm: reg palin_therm terror_all if econ_threat==0 &  good_times  == 0
estimates store palin, title(Palin Therm)
eststo obama_therm: reg obama_therm terror_all if econ_threat==0 &  good_times  == 0
estimates store obama, title(Obama Therm)
eststo obama_therm: reg romney_therm terror_all if econ_threat==0 &  good_times  == 0
estimates store romney, title(Romney Therm)



**** Table VIII *** 

suest clinton pelosi, noomitted 
test [clinton_mean = pelosi_mean], cons
suest obama pelosi, noomitted
test [obama_mean = pelosi_mean], cons
suest obama clinton, noomitted
test [obama_mean = clinton_mean], cons


eststo clear
eststo: sureg (clinton_therm terror_all) (pelosi_therm terror_all ) (rice_therm terror_all) (palin_therm terror_all ) (obama_therm terror_all) (romney_therm terror_all ) if econ_threat == 0 & good_times == 0, corr
esttab using "Table VIII.rtf", replace se(2) b(2) n star(+ .15 * .10 ** .05 *** .05)


**** Table IIX *** 

/*gender and treatments */

gen good_times_gender = good_times*gender 
gen nr_gender = nr_intl_terror*gender
gen rc_gender = rc_intl_terror*gender
gen rp_gender = rp_intl_terror*gender
gen terror_gender = terror_all*gender 

eststo clear
eststo: reg clinton_therm terror_all gender terror_gender if econ_threat==0 & good_times == 0
mfx
eststo: reg pelosi_therm terror_all gender  terror_gender if econ_threat==0 & good_times == 0
mfx
eststo: reg rice_therm terror_all gender terror_gender if econ_threat==0 & good_times == 0
mfx
eststo: reg palin_therm  terror_all gender terror_gender if econ_threat==0 & good_times == 0
mfx
eststo: reg obama_therm terror_all gender terror_gender if econ_threat==0 & good_times == 0
mfx
eststo: reg romney_therm terror_all gender terror_gender if econ_threat==0 & good_times == 0
mfx
esttab using "Table IIX.rtf", replace se(2) b(2) n star(+ .10 * .05 ** .01 *** .001)

*** Table IX ****


eststo clear
eststo: reg clinton_therm terror_all gender terror_gender if econ_threat==0 & control == 0
mfx
eststo: reg pelosi_therm terror_all gender  terror_gender if econ_threat==0 & control == 0
mfx
eststo: reg rice_therm terror_all gender terror_gender if econ_threat==0 & control == 0
mfx
eststo: reg palin_therm  terror_all gender terror_gender if econ_threat==0 & control == 0
mfx
eststo: reg obama_therm terror_all gender terror_gender if econ_threat==0 & control == 0
mfx
eststo: reg romney_therm terror_all gender terror_gender if econ_threat==0 & control == 0
mfx
esttab using "Table IX.rtf", replace se(2) b(2) n star(+ .10 * .05 ** .01 *** .001)
eststo clear


** Table X **



gen good_times_pid = good_times*democrat 
gen nr_pid = nr_intl_terror*democrat
gen rc_pid = rc_intl_terror*democrat
gen rp_pid = rp_intl_terror*democrat
gen terror_pid = terror_all*democrat 

eststo clear
eststo: reg clinton_therm terror_all democrat terror_pid if econ_threat==0 & control  == 0
eststo: reg pelosi_therm terror_all democrat terror_pid if econ_threat==0 & control == 0
eststo: reg rice_therm terror_all democrat terror_pid if econ_threat==0 & control == 0
eststo: reg palin_therm terror_all democrat terror_pid if econ_threat==0 & control == 0
eststo: reg obama_therm terror_all democrat terror_pid if econ_threat==0 & control == 0
eststo: reg romney_therm terror_all democrat terror_pid if econ_threat==0 & control == 0
esttab using "Table X.rtf", replace se(2) b(2) n star(+ .10 * .05 ** .01 *** .001)


*** Table XI *** 

eststo clear
eststo: reg clinton_therm terror_all democrat terror_pid if econ_threat==0 & good_times == 0
eststo: reg pelosi_therm terror_all democrat terror_pid if econ_threat==0 & good_times == 0
eststo: reg rice_therm terror_all democrat terror_pid if econ_threat==0 & good_times == 0
eststo: reg palin_therm terror_all democrat terror_pid if econ_threat==0 & good_times == 0
eststo: reg obama_therm terror_all democrat terror_pid if econ_threat==0 & good_times == 0
eststo: reg romney_therm terror_all democrat terror_pid if econ_threat==0 & good_times == 0
esttab using "Table XI.rtf", replace se(2) b(2) n star(+ .10 * .05 ** .01 *** .001)
