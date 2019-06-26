*do file for Supplemental Appendix for Philip Hultquist's Journal of Peace Research submission (ID: JPR-11-0192.R1)- Power Parity and Peace? The Role of Relative Pwer on Civil War Settlement.
*run "Hultquist_JPR_Main_text_tables_figure_2.5.13"


set more off
* A.1 reports model that dissagregates government victory from low activity. 1=settlement/ceasefire; 2=government military victory; 3=rebel victory; 4=termination by low activity
mlogit k1  rclag1 rc2lag1 battledeaths identity territory pg_troops pr_troops lngdpper polity2 polity_sq,  nolog cluster(dyadid)
outreg2 using parityappendix1.doc, nolabel replace

* A.2 reports model that uses current version of RCi (also dissagregates government victory from low activity. 1=settlement/ceasefire; 2=government military victory; 3=rebel victory; 4=termination by low activity)
mlogit k1  rc rc2 battledeaths identity territory pg_troops pr_troops lngdpper polity2 polity_sq ,  nolog cluster(dyadid)
outreg2 using parityappendix2.doc, nolabel replace


* A.3 reports model that clusters on conflict
mlogit k1  rclag1 rc2lag1 battledeaths identity territory pg_troops pr_troops lngdpper polity2 polity_sq ,  nolog cluster(conflictid)
outreg2 using parityappendix3.doc, nolabel replace


* A.4 reports model that includes loss of superpower support "sploss" (where Ò1Ó indicates that at least one party had superpower support in the form of troop presence the year before, but not in the current year and Ò0Ó indicates neither party had support or they still have it.)
mlogit k1  rclag1 rc2lag1 battledeaths identity territory sploss lngdpper polity2 polity_sq ,  nolog cluster(dyadid)
outreg2 using parityappendix4.doc, nolabel replace


*clarifying the role of identity and territory - Figure A.1 reports predicted proabilities for four types of conflict 
*make sure JPR1.2 has been run to establish psettle


*where (identity==0, territory=1)
*gen copies 
gen c1battledeaths = battledeaths
gen c1identity = identity
gen c1territory = territory
gen c1pg_troops = pg_troops
gen c1pr_troops =pr_troops
gen c1lngdpper = lngdpper
gen c1polity2 =polity2
gen c1polity_sq = polity_sq
gen c1age=age
gen c1age2=age2
gen c1age3=age3

quietly mlogit k rclag1 rc2lag1 c1battledeaths c1identity c1territory c1pg_troops c1pr_troops c1lngdpper c1polity2 c1polity_sq c1age c1age2 c1age3,  nolog cluster(dyadid)

quietly sum c1battledeaths, det
replace c1battledeaths = r(mean) 

quietly sum c1lngdpper, det
replace c1lngdpper = r(mean) 

quietly sum c1polity2, det
replace c1polity2 = r(mean) 

quietly sum c1polity_sq, det
replace c1polity_sq = r(mean) 

quietly sum c1age, det
replace c1age = r(mean) 

quietly sum c1age2, det
replace c1age2 = r(mean) 

quietly sum c1age3, det
replace c1age3 = r(mean) 

replace c1identity = 0
replace c1territory = 1 
replace c1pg_troops = 0
replace c1pr_troops = 0


/*generate predicted values*/
    sort rclag1
    predict pongoing1 psettle1 pgv1 prv1 if e(sample)


*where (identity==0, territory=0)
*gen copies 
gen c2battledeaths = battledeaths
gen c2identity = identity
gen c2territory = territory
gen c2pg_troops = pg_troops
gen c2pr_troops =pr_troops
gen c2lngdpper = lngdpper
gen c2polity2 =polity2
gen c2polity_sq = polity_sq
gen c2age=age
gen c2age2=age2
gen c2age3=age3


quietly mlogit k rclag1 rc2lag1 c2battledeaths c2identity c2territory c2pg_troops c2pr_troops c2lngdpper c2polity2 c2polity_sq c2age c2age2 c2age3,  nolog cluster(dyadid)

quietly sum c2battledeaths, det
replace c2battledeaths = r(mean) 

quietly sum c2lngdpper, det
replace c2lngdpper = r(mean)

quietly sum c2polity2, det
replace c2polity2 = r(mean) 

quietly sum c2polity_sq, det
replace c2polity_sq = r(mean) 

quietly sum c2age, det
replace c2age = r(mean) 

quietly sum c2age2, det
replace c2age2 = r(mean) 

quietly sum c2age3, det
replace c2age3 = r(mean) 

replace c2identity = 0
replace c2territory = 0 
replace c2pg_troops = 0
replace c2pr_troops = 0



/*generate predicted values*/
    sort rclag1
    predict pongoing2 psettle2 pgv2 prv2 if e(sample)


*where (identity==1, territory=0)
*gen copies 
gen c3battledeaths = battledeaths
gen c3identity = identity
gen c3territory = territory
gen c3pg_troops = pg_troops
gen c3pr_troops =pr_troops
gen c3lngdpper = lngdpper
gen c3polity2 =polity2
gen c3polity_sq = polity_sq
gen c3age=age
gen c3age2=age2
gen c3age3=age3


quietly mlogit k rclag1 rc2lag1 c3battledeaths c3identity c3territory c3pg_troops c3pr_troops c3lngdpper c3polity2 c3polity_sq c3age c3age2 c3age3,  nolog cluster(dyadid)

quietly sum c3battledeaths, det
replace c3battledeaths = r(mean) 

quietly sum c3lngdpper, det
replace c3lngdpper = r(mean) 

quietly sum c3polity2, det
replace c3polity2 = r(mean) 

quietly sum c3polity_sq, det
replace c3polity_sq = r(mean) 

quietly sum c3age, det
replace c3age = r(mean) 

quietly sum c3age2, det
replace c3age2 = r(mean) 

quietly sum c3age3, det
replace c3age3 = r(mean) 

replace c3identity = 1
replace c3territory = 0 
replace c3pg_troops = 0
replace c3pr_troops = 0


/*generate predicted values*/
    sort rclag1
    predict pongoing3 psettle3 pgv3 prv3 if e(sample)

*Table A.5
tab identity territory if e(sample), cell

*Figure with four plots, no cis
twoway (qfit psettle rclag1, clcolor(black) clpattern(solid)) (qfit psettle1 rclag1, clcolor(black)clpattern(dash)) (qfit psettle2 rclag1, clcolor(black) clpattern(longdash)) (qfit psettle3 rclag1,clcolor(black) clpattern(longdash_shortdash)), ytitle(Predicted Probabilities) xtitle(RCi (lagged 1 year)) title(Predicted Probablity of Settlement or Ceasefire) legend(on)



* A.6 drops 250 observations from the low end of RCi
drop if rc<.09
sum rclag1
mlogit k rclag1 rc2lag1 battledeaths identity territory pg_troops pr_troops lngdpper polity2 polity_sq  ,  nolog cluster(dyadid)
outreg2 using parityappendix6.doc, nolabel replace


use "/Users/p_hultquist/Dropbox/Documents/UNM/Parity JPR/Parity JPR Dataset submitted.dta", clear

* A.7 model without cases straddling the 1989 beginning point
drop if straddle==1
mlogit k rclag1 rc2lag1 battledeaths identity territory pg_troops pr_troops lngdpper polity2 polity_sq ,  nolog cluster(dyadid)
outreg2 using parityappendix7.doc, nolabel replace

use "/Users/p_hultquist/Dropbox/Documents/UNM/Parity JPR/Parity JPR Dataset submitted.dta", clear

*model A.8 that keeps all values of RCi
mlogit k rebtotlag1 rebtot2lag1 battledeaths identity territory pg_troops pr_troops lngdpper polity2 polity_sq ,  nolog cluster(dyadid)
outreg2 using parityappendix8.doc, nolabel replace


*model A.9 removes all dyads that do not end in the study period to demonstrate that including right censored dyads in the baseline is not affecting the results.
*remove dyads with that do not end during the time period
drop if censored_r==1
mlogit k rclag1 rc2lag1 battledeaths identity territory pg_troops pr_troops lngdpper polity2 polity_sq ,  nolog cluster(dyadid)
outreg2 using parityappendix9.doc, nolabel replace
