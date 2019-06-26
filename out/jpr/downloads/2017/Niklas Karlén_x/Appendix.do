
////////////////////////////////////////////////////////////////////////////////////////////////////////
// APPENDIX FOR THE LEGACY OF FOREIGN PATRONS: EXTERNAL STATE SUPPORT AND CONFLICT RECURRENCE //
////////////////////////////////////////////////////////////////////////////////////////////////////////

//This is the estimation procedures for the online appendix. 
//Do not run the entire file at once. Estimate one table at a time and then reload the dta-file as some operations change the structure of the dataset //

// SETUP DATA FOR SURVIVAL ANALYSIS //
sort dyadid year

stset time, id(dyadid) failure(recuryear==1) exit(time .) enter(time0)

// APPENDIX (robustness & extensions) //

// Table A1: Effect of external support on conflict recurrence with additional controls//

// Model 1 (dummies)

stcox reb_decay2 gov_decay2 ethnic pko2 territory intensity territorytvc3 ethnictvc3 lngdp fh_ipolity2 lnpop conep_dur victory peaceag lowactivity, efron cluster(dyadid)
est store a1

// Model 2 (number of supporters)

stcox reb_decay2c gov_decay2c ethnic pko2 territory intensity territorytvc3 ethnictvc3 lngdp fh_ipolity2 lnpop conep_dur victory peaceag lowactivity, efron cluster(dyadid)
est store a2

// Model 3 (proportion of years with support)

stcox reby_decay2c govy_decay2c ethnic pko2 territory intensity territorytvc3 ethnictvc3 lngdp fh_ipolity2 lnpop conep_dur victory peaceag lowactivity, efron cluster(dyadid)
est store a3

esttab a1 a2 a3, eform b(%9.2f) se(%9.2f) star(* 0.1 ** 0.05 *** 0.01) mtitle(m1) stats(N)

// Table A2: Effect of external support on conflict recurrence without decay functions //

// Model 1 (dummies)

stcox reb_support_dum gov_support_dum ethnic pko2 territory intensity territorytvc3 ethnictvc3 lngdp fh_ipolity2 lnpop conep_dur victory peaceag lowactivity, efron cluster(dyadid)
est store b1

// Model 2 (number of supporters)

stcox reb_supporters gov_supporters ethnic pko2 territory intensity territorytvc3 ethnictvc3 lngdp fh_ipolity2 lnpop conep_dur victory peaceag lowactivity, efron cluster(dyadid)
est store b2

// Model 3 (number of supporters)
stcox gov_suppyears_p reb_suppyears_p  ethnic pko2 territory intensity territorytvc3 ethnictvc3 lngdp fh_ipolity2 lnpop conep_dur victory peaceag lowactivity, efron cluster(dyadid)
est store b3

esttab b1 b2 b3, eform b(%9.2f) se(%9.2f) star(* 0.1 ** 0.05 *** 0.01) mtitle(m1) stats(N)

// Table A3: Effect of external support on conflict recurrence with different decay functions //

// Half-life=1
stcox reb_decay1 gov_decay1 ethnic pko2 territory territorytvc3 ethnictvc3 lngdp fh_ipolity2 lnpop intensity victory peaceag lowactivity conep_dur, efron cluster(dyadid)
est store h1
stcox reb_decay1c gov_decay1c ethnic pko2 territory territorytvc3 ethnictvc3 lngdp fh_ipolity2 lnpop intensity victory peaceag lowactivity conep_dur, efron cluster(dyadid)
est store h2
stcox reby_decay1c govy_decay1c ethnic pko2 territory territorytvc3 ethnictvc3 lngdp fh_ipolity2 lnpop intensity victory peaceag lowactivity conep_dur, efron cluster(dyadid)
est store h3
esttab h1 h2 h3, eform b(%9.2f) se(%9.2f) star(* 0.1 ** 0.05 *** 0.01) mtitle(m1) stats(N)

// Half-life=2
stcox reb_decay2 gov_decay2 ethnic pko2 territory territorytvc3 ethnictvc3 lngdp fh_ipolity2 lnpop intensity victory peaceag lowactivity conep_dur, efron cluster(dyadid)
est store h1b
stcox reb_decay2c gov_decay2c ethnic pko2 territory territorytvc3 ethnictvc3 lngdp fh_ipolity2 lnpop intensity victory peaceag lowactivity conep_dur, efron cluster(dyadid)
est store h2b
stcox reby_decay2c govy_decay2c ethnic pko2 territory territorytvc3 ethnictvc3 lngdp fh_ipolity2 lnpop intensity victory peaceag lowactivity conep_dur, efron cluster(dyadid)
est store h3b
esttab h1b h2b h3b, eform b(%9.2f) se(%9.2f) star(* 0.1 ** 0.05 *** 0.01) mtitle(m1) stats(N)

// Half-life=3
stcox reb_decay3 gov_decay3 ethnic pko2 territory territorytvc3 ethnictvc3 lngdp fh_ipolity2 lnpop intensity victory peaceag lowactivity conep_dur, efron cluster(dyadid)
est store h1c
stcox reb_decay3c gov_decay3c ethnic pko2 territory territorytvc3 ethnictvc3 lngdp fh_ipolity2 lnpop intensity victory peaceag lowactivity conep_dur, efron cluster(dyadid)
est store h2c
stcox reby_decay3c govy_decay3c ethnic pko2 territory territorytvc3 ethnictvc3 lngdp fh_ipolity2 lnpop intensity victory peaceag lowactivity conep_dur, efron cluster(dyadid)
est store h3c

esttab h1c h2c h3c, eform b(%9.2f) se(%9.2f) star(* 0.1 ** 0.05 *** 0.01) mtitle(m1) stats(N)

// Table A4: Assessment of PH assumption
// Model 1 (dummies)

stcox reb_decay2 gov_decay2 ethnic pko2 territory intensity territorytvc3 ethnictvc3 conep_dur victory peaceag lowactivity, efron cluster(dyadid)
estat phtest, detail

// Model 2 (number of supporters)

stcox reb_decay2c gov_decay2c ethnic pko2 territory intensity territorytvc3 ethnictvc3 conep_dur victory peaceag lowactivity, efron cluster(dyadid)
estat phtest, detail

// Model 3 (proportion of years with support)

stcox reby_decay2c govy_decay2c ethnic pko2 territory intensity territorytvc3 ethnictvc3 conep_dur victory peaceag lowactivity, efron cluster(dyadid)
estat phtest, detail


// TABLE A5: Effect of external support on conflict recurrence (discrete time robustness check, logit model)

logit recuryear time time2 time3 reb_decay2 gov_decay2 ethnic pko2 lngdp fh_ipolity2 lnpop territory intensity conep_dur lowactivity peaceag victory, cluster(dyadid)
est store dt1

logit recuryear time time2 time3 reb_decay2c gov_decay2c ethnic pko2 lngdp fh_ipolity2 lnpop territory intensity conep_dur lowactivity peaceag victory, cluster(dyadid)
est store dt2

logit recuryear time time2 time3 reby_decay2c govy_decay2c ethnic pko2 lngdp fh_ipolity2 lnpop territory intensity conep_dur lowactivity peaceag victory, cluster(dyadid)
est store dt3

esttab dt1 dt2 dt3, b(%9.2f) se(%9.2f) star(* 0.1 ** 0.05 *** 0.01) mtitle(m1) stats(N)


// Table A6: Effect of external support on conflict recurrence (parametric robustness check, weibull model)//

// Model 1 (dummies)
streg reb_decay2 gov_decay2 ethnic pko2 territory lngdp fh_ipolity2 lnpop intensity conep_dur victory peaceag lowactivity, distribution(weibull) cluster(dyadid)
est store w1

// Model 2 (number of supporters)
streg reb_decay2c gov_decay2c ethnic pko2 territory lngdp fh_ipolity2 lnpop intensity conep_dur victory peaceag lowactivity, distribution(weibull) cluster(dyadid)
est store w2

// Model 3 (proportion of years with support)
streg reby_decay2c govy_decay2c ethnic pko2 territory lngdp fh_ipolity2 lnpop intensity conep_dur victory peaceag lowactivity, distribution(weibull) cluster(dyadid)
est store w3

esttab w1 w2 w3, eform b(%9.2f) se(%9.2f) star(* 0.1 ** 0.05 *** 0.01) mtitle(m1) stats(N)


// TABLE A7: Alternative specification of recurrence (only after two years of peace)
// first commands drops all observations that recurred within this timeframe

drop if dyadep=="15_1"
drop if dyadep=="46_1"
drop if dyadep=="54_1"
drop if dyadep=="55_1"
drop if dyadep=="129_1"
drop if dyadep=="190_1"
drop if dyadep=="207_1"
drop if dyadep=="217_1"
drop if dyadep=="220_1"
drop if dyadep=="243_1"
drop if dyadep=="249_1"
drop if dyadep=="260_1"
drop if dyadep=="269_1"
drop if dyadep=="285_1"
drop if dyadep=="303_1"
drop if dyadep=="322_1"
drop if dyadep=="337_1"
drop if dyadep=="342_1"
drop if dyadep=="353_1"
drop if dyadep=="360_1"
drop if dyadep=="405_1"
drop if dyadep=="433_1"
drop if dyadep=="435_1"
drop if dyadep=="495_1"
drop if dyadep=="558_1"
drop if dyadep=="639_1"
drop if dyadep=="660_1"
drop if dyadep=="663_1"
drop if dyadep=="129_2"
drop if dyadep=="129_3"
drop if dyadep=="129_4"
drop if dyadep=="129_5"
drop if dyadep=="151_2"
drop if dyadep=="151_3"
drop if dyadep=="54_3"
drop if dyadep=="55_2"
drop if dyadep=="55_3"
drop if dyadep=="55_4"
drop if dyadep=="190_3"
drop if dyadep=="190_5"
drop if dyadep=="246_4"
drop if dyadep=="279_2"
drop if dyadep=="285_2"
drop if dyadep=="269_2"
drop if dyadep=="325_2"
drop if dyadep=="325_4"
drop if dyadep=="325_5"
drop if dyadep=="325_7"
drop if dyadep=="336_2"
drop if dyadep=="336_4"
drop if dyadep=="406_2"
drop if dyadep=="306_2"
drop if dyadep=="306_3"
drop if dyadep=="306_4"
drop if dyadep=="243_2"
drop if dyadep=="217_2"
drop if dyadep=="242_2"
drop if dyadep=="242_3"
drop if dyadep=="249_2"

stset time, id(dyadid) failure(recuryear==1) exit(time .) enter(time0)

// Model 1 (dummies)

stcox reb_decay2 gov_decay2 ethnic pko2 territory intensity territorytvc3 ethnictvc3 lngdp fh_ipolity2 lnpop conep_dur victory peaceag lowactivity, efron cluster(dyadid)
est store x1

// Model 2 (number of supporters)

stcox reb_decay2c gov_decay2c ethnic pko2 territory intensity territorytvc3 ethnictvc3 lngdp fh_ipolity2 lnpop conep_dur victory peaceag lowactivity, efron cluster(dyadid)
est store x2

// Model 3 (proportion of years with support)

stcox reby_decay2c govy_decay2c ethnic pko2 territory intensity territorytvc3 ethnictvc3 lngdp fh_ipolity2 lnpop conep_dur victory peaceag lowactivity, efron cluster(dyadid)
est store x3

esttab x1 x2 x3, eform b(%9.2f) se(%9.2f) star(* 0.1 ** 0.05 *** 0.01) mtitle(m1) stats(N)

// TABLE A8: Effect of external support on conflict recurrence (post-matching subsample)

set seed 97856421
gen u=uniform()
sort u

psmatch2 reb_support_dum rivalry reb_trans reb_mod gov_support_dum, outcome(recuryear) logit
pstest rivalry reb_trans reb_mod gov_support_dum, both

drop if _nn==0

sort dyadid year

stset time, id(dyadid) failure(recuryear==1) exit(time .) enter(time0)

// Model 1 (dummies)

stcox reb_decay2 gov_decay2 ethnic pko2 territory intensity territorytvc3 ethnictvc3 lngdp fh_ipolity2 lnpop conep_dur victory peaceag lowactivity, efron cluster(dyadid)
est store s1

// Model 2 (number of supporters)

stcox reb_decay2c gov_decay2c ethnic pko2 territory intensity territorytvc3 ethnictvc3 lngdp fh_ipolity2 lnpop conep_dur victory peaceag lowactivity, efron cluster(dyadid)
est store s2

// Model 3 (proportion of years with support)

stcox reby_decay2c govy_decay2c ethnic pko2 territory intensity territorytvc3 ethnictvc3 lngdp fh_ipolity2 lnpop conep_dur victory peaceag lowactivity, efron cluster(dyadid)
est store s3

esttab s1 s2 s3, eform b(%9.2f) se(%9.2f) star(* 0.1 ** 0.05 *** 0.01) mtitle(m1) stats(N)

// TABLE A9: Effect of external support on conflict recurrence (interaction terms)
gen interaction1=reb_decay2*rebvictory
gen interaction2=reb_decay2c*rebvictory
gen interaction3=reby_decay2c*rebvictory

// Model 1 (dummies)

stcox reb_decay2 rebvictory interaction1 govvictory gov_decay2 ethnic pko2 territory intensity territorytvc3 ethnictvc3 lngdp fh_ipolity2 lnpop conep_dur peaceag lowactivity, efron cluster(dyadid)
est store i1

// Model 2 (number of supporters)

stcox reb_decay2c rebvictory interaction2 govvictory gov_decay2c ethnic pko2 territory intensity territorytvc3 ethnictvc3 lngdp fh_ipolity2 lnpop conep_dur peaceag lowactivity, efron cluster(dyadid)
est store i2

// Model 3 (proportion of years with support)

stcox reby_decay2c rebvictory interaction3 govvictory govy_decay2c ethnic pko2 territory intensity territorytvc3 ethnictvc3 lngdp fh_ipolity2 lnpop conep_dur peaceag lowactivity, efron cluster(dyadid)
est store i3

esttab i1 i2 i3, eform b(%9.2f) se(%9.2f) star(* 0.1 ** 0.05 *** 0.01) mtitle(m1) stats(N)

///TABLE A10c: Cross-tabulation of conflict-dyad years.
tab recuryear any_support, cell

///TABLE A10b: Cross-tabulation of conflict-dyad episodes.
collapse (sum)any_support (sum)recuryear, by(episodeid)
replace any_support=1 if any_support>0 & any_support!=.
replace recuryear=1 if recuryear>0 & recuryear!=.
tab recuryear any_support, cell

///TABLE A10a: Cross-tabulation of conflicts.
collapse (sum)any_support (sum)recuryear, by(dyadid)
replace any_support=1 if any_support>0 & any_support!=.
replace recuryear=1 if recuryear>0 & recuryear!=.
tab recuryear any_support, cell
