*do file - f:\TESS\do files\HRF_ISQ.do
log using f:\TESS\logs\HRF_ISQ.log, replace

/*THIS FILE CONTAINS ALL CODE NEEDED TO PRODUCE TABLES REPORTED IN*/
/*Timothy Hellwig, Eve Ringsmuth, and John Freeman, "The American Public and the Room to Maneuver," forthcoming, INTERNATIONAL STUDIES QUARTERLY*/
/*MARCH 4, 2008*/

set more off
use f:\tess\data\TESS102507.dta

gen nortm2wy = nortm
recode nortm2wy .=1
gen nortm3wy = nortm
recode nortm3wy 0=1 1=2 .=3

/*TABLE 1 IS SUMMARY OF EXPERIMENTAL DESIGN*/

/*TABLE 2*/
/*column 1 is from ANES 1998 as reported in Rudolph 2003b*/
/*Column 2*/
tab q1_11
/*Column 3*/
tab q1_12
/*Column 4*/
tab q1_21
/*Column 5*/
tab q1_22

/*TABLE 3*/
gen pidxdune = pid7pt*unemploy_change
mlogit q1_12_22 pid7pt age3wy edu3wy unemploy_change pidxdune, b(3) cluster( st_name)

/*TABLE 4*/
/*note: users will need to downloade CLARIFY package from http://gking.harvard.edu/clarify*/ 
estsimp mlogit q1_12_22 pid7pt age3wy edu3wy unemploy_change pidxdune, b(3) cluster( st_name)
/*PID7PT=7, "strong republican" and une at mean*/
setx pid7pt 7 age3wy 1 edu3wy 1 unemploy_change -.3661 pidxdune ((7*(-.3661)))
simqi
/*PID7PT=1, "strong democrat" and une at mean*/
setx pid7pt 1 age3wy 1 edu3wy 1 unemploy_change -.3661 pidxdune ((1*(-.3661)))
simqi
simqi, fd(pr) changex(pid7pt 7 1 pidxdune (7*(-.3661)) (1*(-.3661)))
/*age3wy=0*/
setx pid7pt 4 age3wy 0 edu3wy 1 unemploy_change -.3661 pidxdune ((4*(-.3661))) 
simqi
/*age3wy=2*/
setx pid7pt 4 age3wy 2 edu3wy 1 unemploy_change -.3661 pidxdune ((4*(-.3661))) 
simqi
simqi, fd(pr) changex(age3wy 0 2)
/*edu3wy=0*/
setx pid7pt 4 age3wy 1 edu3wy 0 unemploy_change -.3661 pidxdune ((4*(-.3661))) 
simqi
/*edu3wy=2*/
setx pid7pt 4 age3wy 1 edu3wy 2 unemploy_change -.3661 pidxdune ((4*(-.3661))) 
simqi
simqi, fd(pr) changex(edu3wy 0 2)

/*FIGURE 1A: note that figure reports expected probabilities for "president" only*/
/*strong democrats*/
setx pid7pt 1 age3wy 1 edu3wy 1 unemploy_change .13 pidxdune ((1*(.13)))
simqi, level(90)
setx pid7pt 1 age3wy 1 edu3wy 1 unemploy_change .04 pidxdune ((1*(.04)))
simqi, level(90)
setx pid7pt 1 age3wy 1 edu3wy 1 unemploy_change -.05 pidxdune ((1*(-.05)))
simqi, level(90)
setx pid7pt 1 age3wy 1 edu3wy 1 unemploy_change -.14 pidxdune ((1*(-.14)))
simqi, level(90)
setx pid7pt 1 age3wy 1 edu3wy 1 unemploy_change -.23 pidxdune ((1*(-.23)))
simqi, level(90)
setx pid7pt 1 age3wy 1 edu3wy 1 unemploy_change -.32 pidxdune ((1*(-.32)))
simqi, level(90)
setx pid7pt 1 age3wy 1 edu3wy 1 unemploy_change -.41 pidxdune ((1*(-.41)))
simqi, level(90)
setx pid7pt 1 age3wy 1 edu3wy 1 unemploy_change -.5 pidxdune ((1*(-.5)))
simqi, level(90)
setx pid7pt 1 age3wy 1 edu3wy 1 unemploy_change -.59 pidxdune ((1*(-.59)))
simqi, level(90)
setx pid7pt 1 age3wy 1 edu3wy 1 unemploy_change -.68 pidxdune ((1*(-.68)))
simqi, level(90)
setx pid7pt 1 age3wy 1 edu3wy 1 unemploy_change -.77 pidxdune ((1*(-.77)))
simqi, level(90)
setx pid7pt 1 age3wy 1 edu3wy 1 unemploy_change -.86 pidxdune ((1*(-.86)))
simqi, level(90)
/*strong republicans*/
setx pid7pt 7 age3wy 1 edu3wy 1 unemploy_change .13 pidxdune ((7*(.13)))
simqi, level(90)
setx pid7pt 7 age3wy 1 edu3wy 1 unemploy_change .04 pidxdune ((7*(.04)))
simqi, level(90)
setx pid7pt 7 age3wy 1 edu3wy 1 unemploy_change -.05 pidxdune ((7*(-.05)))
simqi, level(90)
setx pid7pt 7 age3wy 1 edu3wy 1 unemploy_change -.14 pidxdune ((7*(-.14)))
simqi, level(90)
setx pid7pt 7 age3wy 1 edu3wy 1 unemploy_change -.23 pidxdune ((7*(-.23)))
simqi, level(90)
setx pid7pt 7 age3wy 1 edu3wy 1 unemploy_change -.32 pidxdune ((7*(-.32)))
simqi, level(90)
setx pid7pt 7 age3wy 1 edu3wy 1 unemploy_change -.41 pidxdune ((7*(-.41)))
simqi, level(90)
setx pid7pt 7 age3wy 1 edu3wy 1 unemploy_change -.5 pidxdune ((7*(-.5)))
simqi, level(90)
setx pid7pt 7 age3wy 1 edu3wy 1 unemploy_change -.59 pidxdune ((7*(-.59)))
simqi, level(90)
setx pid7pt 7 age3wy 1 edu3wy 1 unemploy_change -.68 pidxdune ((7*(-.68)))
simqi, level(90)
setx pid7pt 7 age3wy 1 edu3wy 1 unemploy_change -.77 pidxdune ((7*(-.77)))
simqi, level(90)
setx pid7pt 7 age3wy 1 edu3wy 1 unemploy_change -.86 pidxdune ((7*(-.86)))
simqi, level(90)

/*FIGURE 1B*/
/*first differences for unemployment across range partisanship from 1 (strong dem) to 7 (strong rep)*/
setx pid7pt 1 age3wy 1 edu3wy 1 unemploy_change -.3661 pidxdune ((1*(-.3661)))
simqi, fd(pr) changex(unemploy_change (-.8569) (.124) pidxdune (1*(-.8569)) (1*(.124))) level(90)
setx pid7pt 2 age3wy 1 edu3wy 1 unemploy_change -.3661 pidxdune ((2*(-.3661)))
simqi, fd(pr) changex(unemploy_change (-.8569) (.124) pidxdune (2*(-.8569)) (2*(.124))) level(90)
setx pid7pt 3 age3wy 1 edu3wy 1 unemploy_change -.3661 pidxdune ((3*(-.3661)))
simqi, fd(pr) changex(unemploy_change (-.8569) (.124) pidxdune (3*(-.8569)) (3*(.124))) level(90)
setx pid7pt 4 age3wy 1 edu3wy 1 unemploy_change -.3661 pidxdune ((4*(-.3661)))
simqi, fd(pr) changex(unemploy_change (-.8569) (.124) pidxdune (4*(-.8569)) (4*(.124))) level(90)
setx pid7pt 5 age3wy 1 edu3wy 1 unemploy_change -.3661 pidxdune ((5*(-.3661)))
simqi, fd(pr) changex(unemploy_change (-.8569) (.124) pidxdune (5*(-.8569)) (5*(.124))) level(90)
setx pid7pt 6 age3wy 1 edu3wy 1 unemploy_change -.3661 pidxdune ((6*(-.3661)))
simqi, fd(pr) changex(unemploy_change (-.8569) (.124) pidxdune (6*(-.8569)) (6*(.124))) level(90)
setx pid7pt 7 age3wy 1 edu3wy 1 unemploy_change -.3661 pidxdune ((7*(-.3661)))
simqi, fd(pr) changex(unemploy_change (-.8569) (.124) pidxdune (7*(-.8569)) (7*(.124))) level(90)
drop b1-b24 

/*TABLE 5*/
/*column 1 is from BEPS 2001*/
/*column 2*/
tab q1_31
/*column 3*/
tab q1_32

/*TABLE 6*/
/*first bloc, "keep prices down"*/
/*column 1 - from BSS 1986*/
/*column 2*/
tab q1_4_11
/*column 3*/
tab q1_4_21
/*second bloc, "reduce unemployment"*/
/*column 1 - from BSS 1986*/
/*column 2*/
tab q1_4_12
/*column 3*/
tab q1_4_22
/*third bloc, "reduce unemployment"*/
/*column 1 - NA*/
/*column 2*/
tab q1_4_13
/*column 3*/
tab q1_4_23

/*TABLE 7 MODEL 1*/
probit nortm pid7pt age3wy edu3wy c3 c4 c8
/*TABLE 7 MODEL 2*/
gen pidage3 = pid7pt*age3wy
gen pidedu3 = pid7pt*edu3wy
probit nortm pid7pt age3wy edu3wy pidage3 pidedu3 c3 c4 c8

/*FIGURE 2*/
estsimp probit nortm pid7pt age3wy edu3wy pidage3 pidedu3 c3 c4 c8
/*4 scenarios - the first is for high sophisticates - moving from strong democrat to strong republican*/
setx pid7pt 1 age3wy 1 edu3wy 2 pidage3 1 pidedu3 2 c3 0 c4 0 c8 1
simqi, level(90) 
setx pid7pt 2 age3wy 1 edu3wy 2 pidage3 2 pidedu3 4 c3 0 c4 0 c8 1
simqi, level(90) 
setx pid7pt 3 age3wy 1 edu3wy 2 pidage3 3 pidedu3 6 c3 0 c4 0 c8 1
simqi, level(90) 
setx pid7pt 4 age3wy 1 edu3wy 2 pidage3 4 pidedu3 8 c3 0 c4 0 c8 1
simqi, level(90)  
setx pid7pt 5 age3wy 1 edu3wy 2 pidage3 5 pidedu3 10 c3 0 c4 0 c8 1
simqi, level(90) 
setx pid7pt 6 age3wy 1 edu3wy 2 pidage3 6 pidedu3 12 c3 0 c4 0 c8 1
simqi, level(90) 
setx pid7pt 7 age3wy 1 edu3wy 2 pidage3 7 pidedu3 14 c3 0 c4 0 c8 1
simqi, level(90)

/*next scenario is for low sophisticates - moving from strong democrat to strong republican*/
setx pid7pt 1 age3wy 1 edu3wy 0 pidage3 1 pidedu3 0 c3 0 c4 0 c8 1
simqi, level(90) 
setx pid7pt 2 age3wy 1 edu3wy 0 pidage3 2 pidedu3 0 c3 0 c4 0 c8 1
simqi, level(90) 
setx pid7pt 3 age3wy 1 edu3wy 0 pidage3 3 pidedu3 0 c3 0 c4 0 c8 1
simqi, level(90) 
setx pid7pt 4 age3wy 1 edu3wy 0 pidage3 4 pidedu3 0 c3 0 c4 0 c8 1
simqi, level(90) 
setx pid7pt 5 age3wy 1 edu3wy 0 pidage3 5 pidedu3 0 c3 0 c4 0 c8 1
simqi, level(90) 
setx pid7pt 6 age3wy 1 edu3wy 0 pidage3 6 pidedu3 0 c3 0 c4 0 c8 1
simqi, level(90) 
setx pid7pt 7 age3wy 1 edu3wy 0 pidage3 7 pidedu3 0 c3 0 c4 0 c8 1
simqi, level(90) 

/*next scenario is for oldest cohort (age 60+) - moving from strong democrat to strong republican*/
setx pid7pt 1 age3wy 2 edu3wy 1 pidage3 2 pidedu3 1 c3 0 c4 0 c8 1
simqi, level(90) 
setx pid7pt 2 age3wy 2 edu3wy 1 pidage3 4 pidedu3 2 c3 0 c4 0 c8 1
simqi, level(90) 
setx pid7pt 3 age3wy 2 edu3wy 1 pidage3 6 pidedu3 3 c3 0 c4 0 c8 1
simqi, level(90) 
setx pid7pt 4 age3wy 2 edu3wy 1 pidage3 8 pidedu3 4 c3 0 c4 0 c8 1
simqi, level(90) 
setx pid7pt 5 age3wy 2 edu3wy 1 pidage3 10 pidedu3 5 c3 0 c4 0 c8 1
simqi, level(90) 
setx pid7pt 6 age3wy 2 edu3wy 1 pidage3 12 pidedu3 6 c3 0 c4 0 c8 1
simqi, level(90) 
setx pid7pt 7 age3wy 2 edu3wy 1 pidage3 14 pidedu3 7 c3 0 c4 0 c8 1
simqi, level(90) 

/*final scenario is for youngest cohort (age 39 or younger) - moving from strong democrat to strong republican*/
setx pid7pt 1 age3wy 0 edu3wy 1 pidage3 0 pidedu3 1 c3 0 c4 0 c8 1
simqi, level(90) 
setx pid7pt 2 age3wy 0 edu3wy 1 pidage3 0 pidedu3 2 c3 0 c4 0 c8 1
simqi, level(90) 
setx pid7pt 3 age3wy 0 edu3wy 1 pidage3 0 pidedu3 3 c3 0 c4 0 c8 1
simqi, level(90) 
setx pid7pt 4 age3wy 0 edu3wy 1 pidage3 0 pidedu3 4 c3 0 c4 0 c8 1
simqi, level(90) 
setx pid7pt 5 age3wy 0 edu3wy 1 pidage3 0 pidedu3 5 c3 0 c4 0 c8 1
simqi, level(90) 
setx pid7pt 6 age3wy 0 edu3wy 1 pidage3 0 pidedu3 6 c3 0 c4 0 c8 1
simqi, level(90) 
setx pid7pt 7 age3wy 0 edu3wy 1 pidage3 0 pidedu3 7 c3 0 c4 0 c8 1
simqi, level(90) 

/*TABLE 8*/
/*doing the cells for the 2x2 tables*/
/*strong dem identifiers*/
setx pid7pt 1 age3wy 2 edu3wy 2 pidage3 2 pidedu3 2 c3 0 c4 0 c8 1
simqi, level(90) 
setx pid7pt 1 age3wy 2 edu3wy 0 pidage3 2 pidedu3 0 c3 0 c4 0 c8 1
simqi, level(90) 
setx pid7pt 1 age3wy 0 edu3wy 2 pidage3 0 pidedu3 2 c3 0 c4 0 c8 1
simqi, level(90) 
setx pid7pt 1 age3wy 0 edu3wy 0 pidage3 0 pidedu3 0 c3 0 c4 0 c8 1
simqi, level(90) 
/*strong rep identifiers*/
setx pid7pt 7 age3wy 2 edu3wy 2 pidage3 14 pidedu3 14 c3 0 c4 0 c8 1
simqi, level(90) 
setx pid7pt 7 age3wy 2 edu3wy 0 pidage3 14 pidedu3 0 c3 0 c4 0 c8 1
simqi, level(90) 
setx pid7pt 7 age3wy 0 edu3wy 2 pidage3 0 pidedu3 14 c3 0 c4 0 c8 1
simqi, level(90) 
setx pid7pt 7 age3wy 0 edu3wy 0 pidage3 0 pidedu3 0 c3 0 c4 0 c8 1
simqi, level(90) 
drop b1-b9


/*APPENDIX TABLE A2 - TABLE 3 W/O THE NIBCS OPTION*/
mlogit q1_11_21 pid7pt age3wy edu3wy unemploy_change pidxdune, b(3) cluster( st_name)

/*APPENDIX TABLE A3 - TABLE 4 W/O THE NIBCS OPTION*/
estsimp  mlogit q1_11_21 pid7pt age3wy edu3wy unemploy_change pidxdune, b(3) cluster( st_name)
/*PID7PT=7, "strong republican" and une at mean*/
setx pid7pt 7 age3wy 1 edu3wy 1 unemploy_change -.3661 pidxdune ((7*(-.3661)))
simqi
/*PID7PT=1, "strong democrat" and une at mean*/
setx pid7pt 1 age3wy 1 edu3wy 1 unemploy_change -.3661 pidxdune ((1*(-.3661)))
simqi
simqi, fd(pr) changex(pid7pt 7 1 pidxdune (7*(-.3661)) (1*(-.3661)))
/*age3wy=0*/
setx pid7pt 4 age3wy 0 edu3wy 1 unemploy_change -.3661 pidxdune ((4*(-.3661))) 
simqi
/*age3wy=2*/
setx pid7pt 4 age3wy 2 edu3wy 1 unemploy_change -.3661 pidxdune ((4*(-.3661))) 
simqi
simqi, fd(pr) changex(age3wy 0 2)
/*edu3wy=0*/
setx pid7pt 4 age3wy 1 edu3wy 0 unemploy_change -.3661 pidxdune ((4*(-.3661))) 
simqi
/*edu3wy=2*/
setx pid7pt 4 age3wy 1 edu3wy 2 unemploy_change -.3661 pidxdune ((4*(-.3661))) 
simqi
simqi, fd(pr) changex(edu3wy 0 2)

/*APPENDIX TABLE A4 - THIS IS TABLE 7 WITH ALTERNATIVE, LESS CONSERVATIVE, CLASSIFICATION OF NON-BELIEVERS*/
/*TABLE A4 MODEL 1*/
probit nortm2wy pid7pt age3wy edu3wy c3 c4 c8
/*TABLE A4 MODEL 2*/
probit nortm2wy pid7pt age3wy edu3wy pidage3 pidedu3 c3 c4 c8
/*now with trichotomous measure for table A4 models 3 and 4*/
/*TABLE A4 MODEL 3*/
mlogit nortm3wy pid7pt age3wy edu3wy c3 c4 c8, b(1)
/*TABLE A4 MODEL 4*/
mlogit nortm3wy pid7pt age3wy edu3wy pidage3 pidedu3 c3 c4 c8, b(1)






