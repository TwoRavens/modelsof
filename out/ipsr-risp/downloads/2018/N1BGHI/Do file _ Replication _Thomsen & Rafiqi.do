********************************************************************************
**************			REPLICATION FILE				************************
*  The Impact of Mass-Level Ideological Orientations on Immigration Policy Preferences over Time
********************************************************************************

use "Dataset_Replication_ Thomsen & Rafiqi.dta", clear

********************************************************************************
**************			DATA PREPARATION				************************
********************************************************************************


*excluding ethnic minority members  

drop if blgetmg == 1 

***Gender. 
recode gndr (1=0 "male") (2=1 "female" ) (9 =.), generate (gender)
label variable gender "Female"

***Age. 
recode agea (14 101 102 104 114 999=.), generate (age)

***education.
recode eduyrs (77 88 99 =.), generate (education) 

***Labour Market Status. 
recode mnactic (1 7 = 1 "working") (2 = 2 "educating") ///
(3 4 5 6 8 = 3 "whithout work")(9 66 77 88 99 =.), generate (labourstatus)

******Urbanity. 
recode domicil (7 8 9 =.)
codebook domicil 

***economic satisfaction. 
recode hincfel (7 8 9 =.)
recode hincfel   (1 2 = 1 "satisfied") (3 4 = 2 "not satisfied"), generate (eco_satisfied)
codebook eco_satisfied

generate eco_satisfiedinter = ((eco_satisfied-1)/(2-1))*(1-0)+0

****social trust. 
recode ppltrst pplfair pplhlp (77 88 99 =.)

factor ppltrst pplfair pplhlp
alpha ppltrst pplfair pplhlp 
 
alpha ppltrst pplfair pplhlp, generate (socialtrust) min(2)
generate social_trust =(( socialtrust -0)/(10-0))*(1-0)+0
summarize social_trust 

**prejudice
recode imdetmr imdetbs (77 88 99 =.), generate (nyimdetmr nyimdetbs )
alpha nyimdetmr nyimdetbs, generate (prej)
generate prejudice =(( prej-0)/(10-0))*(1-0)+0
sum prejudice 

****Contact with ethnic minority (Contact)
* 2002. 
recode imgfrnd  (1=3) (2=2 ) (3=1) (7 8 9 =.), generate (friends)

recode imgclg (3 4 =1)(2=2) (1=3) ( 7 8 9 .a .b .c =.), generate (workcontact)
recode acetalv (1=1)(2=2) (3=3)(7 8 9 .a .b .c =.), generate (neighbourcontact)

alpha workcontact neighbourcontact friends, generate (contactindex)
generate contact_index =((contactindex-1)/(3-1))*(1-0)+0
sum contact_index

* 2014. 
recode dfegcf (1=7 "several") (2=2 "few") (3=1 "none") (7 8 9 =.), generate (friends)
recode dfegcon (1=1 "never") (7=7 "every day") (77 88 99 =.), generate (contact) 

alpha contact friends, generate (kontakt)
generate contact_index = ((kontakt -1)/(7-1))*(1-0)+0
sum contact_index 


****exclusion index (Oppostion to Immigration). 
recode imdfetn  ( 7 8 9 =.), generate (imdfetn1)
recode impcntr  (7 8 9 =.), generate (impcntr1)

corr imdfetn1 impcntr1 

alpha imdfetn1 impcntr1, generate (eksklusion1) 
generate eksklusion_indeks11 =(( eksklusion1 -1)/(4-1))*(1-0)+0

*****left-right scale (Political Ideology). 
recode lrscale (77 88 99=.)
generate leftright = ((lrscale-0)/(10-0))*(1-0)+0
sum leftright 




********************************************************************************
**************			  FINAL MODELS  				************************
********************************************************************************


*********************************
*****Table 1. Descriptive statistics

egen nmiss=rowmiss(eksklusion_indeks11 contact_index Time leftright social_trust gender age education ///
labourstatus domicil eco_satisfied) 

by country_level Time, sort : summarize eksklusion_indeks11 leftright if nmiss==0 

by Time, sort : summarize eksklusion_indeks11 leftright if nmiss==0 

by country_level Time, sort: corr imdfetn1  impcntr1 if nmiss==0 

by Time, sort: corr imdfetn1 impcntr1 if nmiss==0


*****Table 2. The Impact of Political Ideology on Opposition to Immigration across time 

*Model 1
quietly xtset country_level
xtreg eksklusion_indeks11 contact_index ib0.Time leftright social_trust ib0.gender age education ///
ib3.labourstatus ib5.domicil ib2.eco_satisfied , fe

*Model 2
quietly xtset country_level
xtreg eksklusion_indeks11 contact_index ib0.Time C.leftright#ib0.Time leftright  social_trust ib0.gender age education ///
ib3.labourstatus ib5.domicil ib2.eco_satisfied , fe


****Figure 1. The Predicted Relationship Between Political Ideology and Opposition to Immigration in 2002 and 2014   
summarize Time if e(sample), detail 
margins, dydx(leftright) at(Time =(0 1)) 
 
summarize leftright if e(sample), detail 
margins, at(leftright =(0(0.2)1) Time =(0 1)) 
marginsplot, recast(line) recastci(rline) ciopts(lpattern(dash))ytitle(Opposition to Immigration ) /// 
xtitle( Politicial Ideology) title("") 
scheme(s1mono)


*******Notes and robustness checks 
*note 2
sum age if  nmiss==0

*note 3
summarize social_trust if nmiss==0 
alpha ppltrst pplfair pplhlp if nmiss==0 

*note 6
margins Time if leftright < 0.3 , pwcompare 
margins Time if leftright > 0.3 , pwcompare 
 
*note 7

***Excluding one country at a time 
*change the nummer of country from 1-19
quietly xtset country_level
xtreg eksklusion_indeks11 contact_index ib0.Time C.leftright#ib0.Time leftright social_trust ib0.gender age education ///
ib3.labourstatus ib5.domicil ib2.eco_satisfied if country_level !=1 , fe


***Percentile-based Analysis. 
xtile pct4= leftright, n(4)

quietly xtset country_level
xtreg eksklusion_indeks11 contact_index ib1.Time ib1.pct4 ib1.Time#ib1.pct4 social_trust ib0.gender age education ///
ib3.labourstatus ib5.domicil ib2.eco_satisfied , fe

*predicted relationship 
summarize pct4 if e(sample), detail 
margins, at(pct4 =(1 2 3 4 ) Time =(0 1)) 
marginsplot, recast(line) recastci(rline) ciopts(lpattern(dash))ytitle(Opposition to Immigration ) /// 
xtitle( Politicial Ideology) title("") 
scheme(s1mono)

***The analysis only among the four East European countries.  
recode country_level (4=1) (11=2) (16=3) (19=4) (1 2 3 5 6 7 8 9 10 12 13 14 15 17 18 =.), generate (east_EU)

quietly xtset east_EU
xtreg eksklusion_indeks11 contact_index ib0.Time C.leftright#ib0.Time leftright social_trust ib0.gender age education ///
ib3.labourstatus ib5.domicil ib2.eco_satisfied , fe

**The analyses with prejudice as additional control- 
quietly xtset country_level 
xtreg eksklusion_indeks11 prejudice contact_index ib0.Time leftright social_trust ib0.gender age education ///
ib3.labourstatus ib5.domicil ib2.eco_satisfied , fe

quietly xtset country_level 
xtreg eksklusion_indeks11 prejudice contact_index ib0.Time C.leftright#ib0.Time leftright  social_trust ib0.gender age education ///
ib3.labourstatus ib5.domicil ib2.eco_satisfied , fe
