*********************************************************************
*******************KAM, CINDY D. AND BETH A. ESTES*******************
***************DISGUST AND PUBLIC DEMAND FOR PROTECTION**************
*************************JOURNAL OF POLITICS*************************
************************DATA PREP AND ANALYSIS***********************
*********************************************************************

*****Dataset contains variables from Vanderbilt CCES 2012 Module*****
*****use "C:\Magic Briefcase\CCES12_VAN_OUTPUT_20130311.DTA", clear
*****keep V102 VAN341_mid VAN342_mid VAN343_mid VAN344_mid VAN345_mid VAN346_mid VAN347_mid VAN348_mid VAN341_last VAN342_last VAN343_last VAN344_last VAN345_last VAN346_last VAN347_last VAN348_last gender educ race religpew pew_bornagain birthyr CC334A pid7 faminc VAN350 CC324 VAN352 CC326 VAN353 VAN385 VAN386 CC327 VAN371 VAN373 VAN372 VAN374 VAN360 VAN362 VAN363 VAN364 VAN366 VAN361 VAN365 VAN367 VAN368 VAN369 VAN391 VAN392 VAN393 VAN394 VAN381 VAN384 VAN382 VAN383 CC302 CC304 CC302a CC328 CC325 versionVAN461AB VAN465 VAN462 VAN463 VAN464 
*****save "C:\Magic Briefcase\KAM ESTES JOP DATA.DTA"

********************DATA PREPARATION***************
set more off
use "C:\Magic Briefcase\KAM ESTES JOP DATA.DTA", clear
svyset [pweight=V102]
gen fweight = round(V102*100)

//recoding all vars 0-1
***Disgust Scale for Mid Placement
recode VAN341_mid (1=0)(2=.25)(3=.5)(4=.75)(5=1)(else=.), gen(toilet1)
recode VAN342_mid (1=0)(2=.25)(3=.5)(4=.75)(5=1)(else=.), gen(cook1)
recode VAN343_mid (1=1)(2=.75)(3=.5)(4=.25)(5=0)(else=.), gen(monkey1)
recode VAN344_mid (1=0)(2=.25)(3=.5)(4=.75)(5=1)(else=.), gen(vomit1)
recode VAN345_mid (1=0)(2=.25)(3=.5)(4=.75)(5=1)(else=.), gen(soda1)
recode VAN346_mid (1=0)(2=.25)(3=.5)(4=.75)(5=1)(else=.), gen(choc1)
recode VAN347_mid (1=0)(2=.25)(3=.5)(4=.75)(5=1)(else=.), gen(maggot1)
recode VAN348_mid (1=0)(2=.25)(3=.5)(4=.75)(5=1)(else=.), gen(milk1)

***Disgust Scale for Last Placement
recode VAN341_last (1=0)(2=.25)(3=.5)(4=.75)(5=1)(else=.), gen(toilet2)
recode VAN342_last (1=0)(2=.25)(3=.5)(4=.75)(5=1)(else=.), gen(cook2)
recode VAN343_last (1=1)(2=.75)(3=.5)(4=.25)(5=0)(else=.), gen(monkey2)
recode VAN344_last (1=0)(2=.25)(3=.5)(4=.75)(5=1)(else=.), gen(vomit2)
recode VAN345_last (1=0)(2=.25)(3=.5)(4=.75)(5=1)(else=.), gen(soda2)
recode VAN346_last (1=0)(2=.25)(3=.5)(4=.75)(5=1)(else=.), gen(choc2)
recode VAN347_last (1=0)(2=.25)(3=.5)(4=.75)(5=1)(else=.), gen(maggot2)
recode VAN348_last (1=0)(2=.25)(3=.5)(4=.75)(5=1)(else=.), gen(milk2)

**Combining items
foreach v in toilet cook monkey vomit soda choc maggot milk {
gen `v' = `v'1 if `v'1<1.1
replace `v' = `v'2 if `v'2<1.1
}


*Reliability
alpha toilet1 cook1 monkey1 vomit1 soda1 choc1 maggot1 milk1  
alpha toilet2 cook2 monkey2 vomit2 soda2 choc2 maggot2 milk2 
alpha toilet cook monkey vomit soda choc maggot milk

**Generate Disgust Scale for Last Placement
**Generate Disgust Scale 
gen dsr1=(toilet1+cook1+monkey1+vomit1+soda1+choc1+maggot1+milk1)/8
gen dsr2=(toilet2+cook2+monkey2+vomit2+soda2+choc2+maggot2+milk2)/8
gen dsr = (toilet+cook+monkey+vomit+soda+choc+maggot+milk)/8
lab var dsr "DSR-8 scale"

*****APPENDIX TABLE 1
svy: mean monkey vomit toilet cook milk maggot choc soda 


*****SCALE DESCRIPTIVES (IN TEXT)
svy: mean dsr

//Response rate
egen dsrmis = rowmiss (monkey vomit milk maggot toilet cook choc soda)
svy: tab dsrmis

**********FIGURE 1**********
histogram dsr [fw=fweight], percent name(disgust, replace) bin(25)
*per http://www.stata.com/statalist/archive/2007-10/msg00327.html

//DSR placement is immaterial
recode dsr1 (0/1=1)(else=.), gen(midplacement)
replace midplacement = 0 if dsr2>=0 & dsr2<=1
svy: reg dsr midplacement

//Conceptually distinct, but empirically not that distinct  
gen coredisgust = (monkey + vomit +milk +maggot)/4
gen contamdisgust = (toilet +cook +choc +soda)/4
corr coredisgust contamdisgust [w=fweight]
*http://www.stata.com/support/faqs/statistics/estimate-correlations-with-survey-data/


//saving data for CFA analysis, which uses AMOS
preserve
keep toilet - milk V102
saveold "C:/MAGIC BRIEFCASE/CFA DSR8.dta", replace
*then stat/transfer to spss format
*then run various .amw files for CFA
restore 


*****DEMOGRAPHICS*****
recode gender (1=0)(2=1)(else=.), gen(female)
recode educ (1=0)(2=.2)(3=.4)(4=.6)(5=.8)(6=1)(else=.), gen(ed6cat)
recode race (1 3=0)(2=1)(else=.), gen(black)
recode race (1 2=0)(3=1)(else=.), gen(hisp)
recode race (1=1)(else=0), gen(white)
recode religpew (1=1)(2/12=0)(else=.), gen(protestant)
recode religpew (1=0)(2=1)(3/12 = 0)(else=.), gen(cath)
recode religpew (3 4 6 7 8=1)(1 2 5 9/12=0)(else=.), gen(othrel)
recode religpew (1/4=0)(5=1)(6/12=0)(else=.), gen(jewish)
recode religpew (1 /8 =0)(9 10 11 =1)(12 = 0)(else=.), gen(ath_agn_norel)
gen bornagain = protestant
replace bornagain = 0 if pew_bornagain==2
replace bornagain = 1 if pew_bornagain==1 & protestant==1

gen age = (2012-birthyr-18)/(94-18)
//create age cohorts: 18-29, 30-45, 46-64, 65+
recode birthyr (1900/1947=1)(1948/1995=0)(else=.), gen(age65pl)
recode birthyr (1900/1947=0)(1948/1966=1)(1967/1995=0)(else=.), gen(age4664)
recode birthyr (1900/1947 1948/1966=0)(1967/1982=1)(1983/1995=0)(else=.), gen(age3045)
recode birthyr (1900/1947 1948/1966 1967/1982 =0)(1983/1995=1)(else=.), gen(age1829)

recode CC334A (1=0 "Very Lib")(2=.17)(3=.33)(4 8=.5)(5=.67)(6=.83)(7=1 "Very Con")(else=.), gen(lc7catd)
recode pid7 (1=0 "Str Dem")(2=.17)(3=.33)(4 8=.5)(5=.67)(6=.83)(7=1 "Str GOP")(else=.), gen(pid7catd)

//use famincd with refinc
gen famincd = (faminc-1)/15
replace famincd = . if faminc==32
replace famincd = 0 if faminc==97
recode faminc (1/32=0)(97=1)(else=.), gen(refinc)

*****DEMOGRAPHIC CORRELATES OF OUR SCALE
svy: mean dsr, over(female)
lincom [dsr]1 - [dsr]0

preserve
drop if race>2
svy: mean dsr, over(black)
lincom [dsr]1 - [dsr]0
restore

*Ideology
corr dsr lc7catd [w=fweight]

*Partisanship
corr dsr pid7catd [w=fweight]



********************TABLE 1********************
svy: reg dsr female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel 
est store dsr
est table dsr, b(%9.2f) star(.1 .05 .01) 
est table dsr, b(%9.2f) se stats(r2 N) style(col)




*****PUBLIC OPINION DVS*****
recode VAN350 (1=1 "Vote for")(2=.67)(3=.33)(4=0 "Vote against")(else=.), gen(safety)
recode CC324 (1=1 "never")(2=.67)(3=.33)(4=0 "always")(else=.), gen(abortion)
recode VAN352 (1=1 "Favor detainment")(2=.67)(3=.33)(4=0 "Oppose detainment")(else=.), gen(detain)
recode CC326 (1=0 "favor")(2=1 "oppose")(else=.), gen(gaymar)
recode VAN353 (1=0 "Favor job disc laws")(2=.33)(3=.67)(4=1 "Oppose job disc laws")(else=.), gen(gayjob)
recode VAN385 (1=0 "BW dating OK")(2=.25)(3=.5)(4=.75)(5=1 "BW dating not ok")(else=.), gen(BWdating)
recode VAN386 (1=1 "oppose intermarriage")(2=.75)(3=.5)(4=.25)(5=0 "favor intermarriage")(else=.), gen(intermarriage)
recode CC327 (1=0 "str support")(2=.33)(3=.67)(4=1 "str oppose")(else=.), gen(affaxn)

svy: mean safety abortion detain gayjob gaymar 
svy: mean affaxn BWdating intermarriage if white==1


********************TABLE 2********************
foreach v of varlist safety detain abortion gayjob gaymar {
svy: oprobit `v' dsr female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  
est store `v'
}

foreach v of varlist affaxn BWdating intermarriage {
svy: oprobit `v' dsr female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  if white==1
est store `v'
}

est table safety abortion detain gaymar gayjob BWdating intermarriage affaxn , b(%9.2f) star(.1 .05 .01) stats(N) style(col) eq(1)
est table safety abortion detain gaymar gayjob BWdating intermarriage affaxn , b(%9.2f) se stats(N) style(col) eq(1)

graph drop _all



//predicted probabilities
svy: mean female black hisp age famincd refinc ed6cat lc7catd pid7catd  bornagain cath jewish othrel ath_agn_norel  
svy: mean famincd if refinc==0

preserve
collapse female black hisp age famincd refinc ed6cat lc7catd pid7catd  bornagain cath jewish othrel ath_agn_norel  
expand 11
egen dsr = fill(0(.1)1)
replace female =1
replace black = 0
replace hisp = 0 
replace age =.4
replace famincd=0.3
replace refinc=0
replace ed6cat=0.4
replace lc7catd=0.5
replace pid7catd=0.5
replace bornagain=0
replace cath =0
replace jewish=0
replace othrel=0
replace ath_agn_norel=0
est restore safety
predict p_1 p_2 p_3 p_4 
gen p_dsr = (p_3+p_4)
table dsr, c(mean p_dsr)
quietly twoway (connect p_dsr dsr, msymbol(i)), ylabel(0(.2)1) title("Food Safety Law") ytitle("Pr(Vote)") xtitle("DSR-8 scale") scheme(s1mono) name(safety, replace)

est restore abortion
drop p_*
predict p_1 p_2 p_3 p_4 
gen p_dsr = (p_3+p_4)
table dsr, c(mean p_dsr)
quietly twoway (connect p_dsr dsr, msymbol(i)), ylabel(0(.2)1) title("Abortion") ytitle("Pr(Oppose)") xtitle("DSR-8 scale") scheme(s1mono) name(abortion, replace)

est restore detain
drop p_*
predict p_1 p_2 p_3 p_4 
gen p_dsr = (p_3+p_4)
table dsr, c(mean p_dsr)
quietly twoway (connect p_dsr dsr, msymbol(i)), ylabel(0(.2)1) title("Detain Immigrant") ytitle("Pr(Support)") xtitle("DSR-8 scale") scheme(s1mono) name(detain, replace)

est restore gaymar
drop p_*
predict p_1 p_2 
gen p_dsr = (p_2)
table dsr, c(mean p_dsr)
quietly twoway (connect p_dsr dsr, msymbol(i)), ylabel(0(.2)1) title("Gay Marriage") ytitle("Pr(Oppose)") xtitle("DSR-8 scale") scheme(s1mono) name(gaymar, replace)

est restore gayjob
drop p_*
predict p_1 p_2 p_3 p_4 
gen p_dsr = (p_3+p_4)
table dsr, c(mean p_dsr)
quietly twoway (connect p_dsr dsr, msymbol(i)), ylabel(0(.2)1) title("Job Protections for Homosexuals") ytitle("Pr(Oppose)") xtitle("DSR-8 scale") scheme(s1mono) name(gayjob, replace)

est restore BWdating
drop p_*
predict p_1 p_2 p_3 p_4 p_5
gen p_dsr = (p_4+p_5)
table dsr, c(mean p_dsr)
quietly twoway (connect p_dsr dsr, msymbol(i)), ylabel(0(.2)1) title("Interracial Dating") ytitle("Pr(Oppose)") xtitle("DSR-8 scale") scheme(s1mono) name(BWdating, replace) 

est restore intermarriage
drop p_*
predict p_1 p_2 p_3 p_4 p_5
gen p_dsr = (p_4+p_5)
table dsr, c(mean p_dsr)
quietly twoway (connect p_dsr dsr, msymbol(i)), ylabel(0(.2)1) title("Interracial Marriage") ytitle("Pr(Oppose)") xtitle("DSR-8 scale") scheme(s1mono) name(intermarriage, replace)

est restore affaxn
drop p_*
predict p_1 p_2 p_3 p_4 
gen p_dsr = (p_3+p_4)
table dsr, c(mean p_dsr)
quietly twoway (connect p_dsr dsr, msymbol(i)), ylabel(0(.2)1) title("Affirmative Action") ytitle("Pr(Oppose)") xtitle("DSR-8 scale") scheme(s1mono) name(affaxn, replace)
restore

********************FIGURE 2********************
graph combine safety abortion detain gaymar gayjob BWdating intermarriage affaxn , ycommon xcommon scheme(s1mono) row(3) holes(6) ysize(10) xsize(9) iscale(.4)
graph drop _all


*****FN 11: RACE
//pooled coefficient
foreach v of varlist  BWdating intermarriage affaxn{
svy: oprobit `v' dsr female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel 
est store `v'B
}

est table BWdating intermarriage affaxn BWdatingB intermarriageB affaxnB , b(%9.2f) star(.1 .05 .01) stats(N) style(col) eq(1)
est table BWdating intermarriage affaxn BWdatingB intermarriageB affaxnB , b(%9.2f) se stats(N) style(col) eq(1)

//only minority respondents
foreach v of varlist BWdating intermarriage affaxn {
svy: oprobit `v' dsr female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel if black==1
est store `v'B
}

est table BWdating intermarriage affaxn BWdatingB intermarriageB affaxnB , b(%9.2f) star(.1 .05 .01) stats(N) style(col) eq(1)
est table BWdating intermarriage affaxn BWdatingB intermarriageB affaxnB , b(%9.2f) se stats(N) style(col) eq(1)

foreach v of varlist  BWdating intermarriage affaxn{
svy: oprobit `v' dsr female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel if hisp==1
est store `v'H
}

est table BWdating intermarriage affaxn BWdatingH intermarriageH affaxnH, b(%9.2f) star(.1 .05 .01) stats(N) style(col) eq(1)
est table BWdating intermarriage affaxn BWdatingH intermarriageH affaxnH , b(%9.2f) se stats(N) style(col) eq(1)


//ROBUSTNESS CHECKS
*****MORAL TRADITIONALISM 
recode VAN371 VAN373 (1=0)(2=.25)(3=.5)(4=.75)(5=1)(else=.), gen(moral1 moral3)
recode VAN372 VAN374 (1=1)(2=.75)(3=.5)(4=.25)(5=0)(else=.), gen(moral2 moral4)
gen moral = (moral1+moral2+moral3+moral4)/4
alpha moral1-moral4 
svy: mean moral
corr dsr moral [w=fweight]
svy: reg dsr moral 
svy: reg moral dsr 

foreach v of varlist safety detain abortion gayjob gaymar {
svy: oprobit `v' dsr moral female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  
est store `v'
}

foreach v of varlist affaxn BWdating intermarriage {
svy: oprobit `v' dsr moral female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  if white==1
est store `v'
}

est table safety abortion detain gaymar gayjob BWdating intermarriage affaxn , b(%9.2f) star(.1 .05 .01) stats(N) style(col) eq(1)
est table safety abortion detain gaymar gayjob BWdating intermarriage affaxn , b(%9.2f) se stats(N) style(col) eq(1)


*****TIPI: Openness, Conscientiousness, Extraversion, Agreeableness, Neuroticism
recode VAN360 VAN362 VAN363 VAN364 VAN366(1=0)(2=.17)(3=.33)(4=.5)(5=.67)(6=.83)(7=1)(else=.), gen(extra1 consc1 neuro1 open1 agree2)
recode VAN361 VAN365 VAN367 VAN368 VAN369 (1=1)(2=.83)(3=.67)(4=.5)(5=.33)(6=.17)(7=0)(else=.), gen(agree1 extra2 consc2 neuro2 open2)
gen extraversion = (extra1+extra2)/2
gen openness = (open1+open2)/2
gen conscientiousness = (consc1+consc2)/2
gen agreeableness = (agree1+agree2)/2
gen neuroticism = (neuro1+neuro2)/2

corr dsr openness conscientiousness extraversion agreeableness neuroticism [w=fweight]
svy: reg dsr openness 
svy: reg openness dsr 
svy: reg dsr conscientiousness 
svy: reg conscientiousness dsr 
svy: reg dsr extraversion 
svy: reg extraversion dsr 
svy: reg dsr agreeableness 
svy: reg agreeableness dsr 
svy: reg dsr neuroticism 
svy: reg neuroticism dsr 


foreach v of varlist safety detain abortion gayjob gaymar {
svy: oprobit `v' dsr openness conscientiousness extraversion agreeableness neuroticism  female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  
est store `v'
}

foreach v of varlist affaxn BWdating intermarriage {
svy: oprobit `v' dsr openness conscientiousness extraversion agreeableness neuroticism  female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  if white==1
est store `v'
}

est table safety abortion detain gaymar gayjob BWdating intermarriage affaxn , b(%9.2f) star(.1 .05 .01) stats(N) style(col) eq(1)
est table safety abortion detain gaymar gayjob BWdating intermarriage affaxn , b(%9.2f) se stats(N) style(col) eq(1)


*****Authoritarianism
recode VAN391 (1=0)(2=1)(else=.), gen(auth1)
recode VAN392 (1=1)(2=0)(else=.), gen(auth2)
recode VAN393 (1=0)(2=1)(else=.), gen(auth3)
recode VAN394 (1=0)(2=1)(else=.), gen(auth4)
alpha auth1-auth4
gen authsc = (auth1+auth2+auth3+auth4)/4
svy: mean authsc
corr dsr authsc [w=fweight]
svy: reg dsr authsc

foreach v of varlist safety detain abortion gayjob gaymar {
svy: oprobit `v' dsr authsc female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  
est store `v'
}

foreach v of varlist affaxn BWdating intermarriage {
svy: oprobit `v' dsr authsc female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  if white==1
est store `v'
}

est table safety abortion detain gaymar gayjob BWdating intermarriage affaxn , b(%9.2f) star(.1 .05 .01) stats(N) style(col) eq(1)
est table safety abortion detain gaymar gayjob BWdating intermarriage affaxn , b(%9.2f) se stats(N) style(col) eq(1)


*****Racial resentment
recode VAN381 VAN384 (1=1)(2=.75)(3=.5)(4=.25)(5=0)(else=.), gen(resent1 resent4)
recode VAN382 VAN383 (1=0)(2=.25)(3=.5)(4=.75)(5=1)(else=.), gen(resent2 resent3)
alpha resent1 resent2 resent3 resent4
gen resent = (resent1+resent2+resent3+resent4)/4
svy: mean resent
corr dsr resent [w=fweight]
svy: reg dsr resent

foreach v of varlist safety detain abortion gayjob gaymar {
svy: oprobit `v' dsr resent female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  
est store `v'
}

foreach v of varlist affaxn BWdating intermarriage {
svy: oprobit `v' dsr resent female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  if white==1
est store `v'
}

est table safety abortion detain gaymar gayjob BWdating intermarriage affaxn , b(%9.2f) star(.1 .05 .01) stats(N) style(col) eq(1)
est table safety abortion detain gaymar gayjob BWdating intermarriage affaxn , b(%9.2f) se stats(N) style(col) eq(1)



*****SUBGROUP ANALYSES
//For whom does disgust work?
//LIBERALS
preserve
keep if lc7catd<.5
svy: oprobit safety dsr  female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  
est store safety
svy: oprobit detain dsr  female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  
est store detain 
svy: oprobit gayjob dsr  female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  
est store gayjob
svy: oprobit gaymar dsr  female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  
est store gaymar
svy: oprobit affaxn dsr  female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel   if white==1
est store affaxn 
svy: oprobit BWdating dsr  female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel   if white==1
est store BWdating
svy: oprobit intermarriage dsr  female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel   if white==1
est store intermarriage
svy: oprobit abortion dsr  female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  
est store abortion
est table safety abortion detain gaymar gayjob BWdating intermarriage affaxn abortion, b(%9.2f) star(.1 .05 .01) stats(N) eq(1)
est table safety abortion detain gaymar gayjob BWdating intermarriage affaxn abortion, b(%9.2f) se stats(N) eq(1) style(col)
restore

//CONSERVATIVES
preserve
keep if lc7catd>.5
svy: oprobit safety dsr  female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  
est store safety
svy: oprobit detain dsr  female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  
est store detain 
svy: oprobit gayjob dsr  female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  
est store gayjob
svy: oprobit gaymar dsr  female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  
est store gaymar
svy: oprobit affaxn dsr  female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel   if white==1
est store affaxn 
svy: oprobit BWdating dsr  female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel   if white==1
est store BWdating
svy: oprobit intermarriage dsr  female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel    if white==1
est store intermarriage
svy: oprobit abortion dsr  female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  
est store abortion
est table safety abortion detain gaymar gayjob BWdating intermarriage affaxn abortion, b(%9.2f) star(.1 .05 .01) stats(N) eq(1)
est table safety abortion detain gaymar gayjob BWdating intermarriage affaxn abortion, b(%9.2f) se stats(N) eq(1) style(col)
restore

//DEMOCRATS
preserve
keep if pid7catd<.5
svy: oprobit safety dsr  female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  
est store safety
svy: oprobit detain dsr  female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  
est store detain 
svy: oprobit gayjob dsr  female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  
est store gayjob
svy: oprobit gaymar dsr  female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  
est store gaymar
svy: oprobit affaxn dsr  female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel   if white==1
est store affaxn 
svy: oprobit BWdating dsr  female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel   if white==1
est store BWdating
svy: oprobit intermarriage dsr  female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel    if white==1
est store intermarriage
svy: oprobit abortion dsr  female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  
est store abortion
est table safety abortion detain gaymar gayjob BWdating intermarriage affaxn abortion, b(%9.2f) star(.1 .05 .01) stats(N) eq(1)
est table safety abortion detain gaymar gayjob BWdating intermarriage affaxn abortion, b(%9.2f) se stats(N) eq(1) style(col)
restore 

//REPUBLICANS
preserve
keep if pid7catd>.5
svy: oprobit safety dsr  female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  
est store safety
svy: oprobit detain dsr  female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  
est store detain 
svy: oprobit gayjob dsr  female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  
est store gayjob
svy: oprobit gaymar dsr  female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  
est store gaymar
svy: oprobit affaxn dsr  female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel   if white==1
est store affaxn 
svy: oprobit BWdating dsr  female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel   if white==1
est store BWdating
svy: oprobit intermarriage dsr  female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel   if white==1
est store intermarriage
svy: oprobit abortion dsr  female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  
est store abortion
est table safety abortion detain gaymar gayjob BWdating intermarriage affaxn abortion, b(%9.2f) star(.1 .05 .01) stats(N) eq(1)
est table safety abortion detain gaymar gayjob BWdating intermarriage affaxn abortion, b(%9.2f) se stats(N) eq(1) style(col)
restore

//MALES
preserve
keep if female==0
svy: oprobit safety dsr  female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  
est store safety
svy: oprobit detain dsr  female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  
est store detain 
svy: oprobit gayjob dsr  female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  
est store gayjob
svy: oprobit gaymar dsr  female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  
est store gaymar
svy: oprobit affaxn dsr  female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel   if white==1
est store affaxn 
svy: oprobit BWdating dsr  female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel   if white==1
est store BWdating
svy: oprobit intermarriage dsr  female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel   if white==1
est store intermarriage
svy: oprobit abortion dsr  female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  
est store abortion
est table safety abortion detain gaymar gayjob BWdating intermarriage affaxn , b(%9.2f) star(.1 .05 .01) stats(N) eq(1)
est table safety abortion detain gaymar gayjob BWdating intermarriage affaxn abortion, b(%9.2f) se stats(N) eq(1) style(col)

//FEMALES
restore
preserve
keep if female==1
svy: oprobit safety dsr  female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  
est store safety
svy: oprobit detain dsr  female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  
est store detain 
svy: oprobit gayjob dsr  female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  
est store gayjob
svy: oprobit gaymar dsr  female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  
est store gaymar
svy: oprobit affaxn dsr  female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel   if white==1
est store affaxn 
svy: oprobit BWdating dsr  female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel   if white==1
est store BWdating
svy: oprobit intermarriage dsr  female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel   if white==1
est store intermarriage
svy: oprobit abortion dsr  female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  
est store abortion
est table safety abortion detain gaymar gayjob BWdating intermarriage affaxn abortion, b(%9.2f) star(.1 .05 .01) stats(N) eq(1)
est table safety abortion detain gaymar gayjob BWdating intermarriage affaxn abortion, b(%9.2f) se stats(N) eq(1) style(col)
restore


*****//DISCRIMINANT VALIDITY
*economic evaluations: retro-national, retro-personal; future-national (CC302a); 
recode CC302 (1=1 "Much better")(2=.75)(3 6=.5)(4=.25)(5=0 "Much worse")(else=.), gen(econretro)
recode CC304 (1=1 "Much better")(2=.75)(3 6=.5)(4=.25)(5=0 "Much worse")(else=.), gen(pockretro)
recode CC302a (1=1 "Much better")(2=.75)(3 6=.5)(4=.25)(5=0 "Much worse")(else=.), gen(econfut)

svy: oprobit econretro dsr female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  
svy: oprobit pockretro dsr female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  
svy: oprobit econfut dsr female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  

*Balanced budget
svy: mlogit CC328 dsr female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  

*Jobs/environment
recode CC325 (1=1 "Env")(2=.75)(3=.5)(4=.25)(5=0 "Jobs")(else=.), gen(jobenv)
svy: oprobit jobenv dsr female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  



********************************************************************************************
***********************************FOOD SAFETY EXPERIMENT***********************************
recode versionVAN461AB (1=0)(2=1)(else=.), gen(foodexp_treat)

*Generate DVs
recode VAN465 (1=1)(2=.75)(3=.5)(4=.25)(5=0)(else=.), gen(fdaspending)
svy: tab fdaspending
svy: mean fdaspending
svy: mean fdaspending, over(foodexp_treat)
svy: reg fdaspending foodexp_treat

*FN 18: Check for balance
svy: probit foodexp_treat female black hisp age famincd refinc ed6cat lc7catd pid7catd  bornagain cath jewish othrel ath_agn_norel  //balanced
*Generate emotion variables
recode VAN462 VAN463 VAN464 (1=0)(2=.25)(3=.5)(4=.75)(5=1)(else=.), gen(disgusted angry afraid)

*Test emotional reactions to treatments - STATE VS. TRAIT DISGUST
svy: mean disgusted, over(foodexp_treat)
lincom [disgusted]1 - [disgusted]0

svy: mean angry, over(foodexp_treat)
lincom [angry]1 - [angry]0

svy: mean afraid, over(foodexp_treat)
lincom [afraid]1 - [afraid]0

corr_svy disgusted angry afraid dsr

*************************TABLE 4*************************
svy: oprobit fdaspending dsr female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel if foodexp_treat==0
est store mild
svy: oprobit fdaspending dsr female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel if foodexp_treat==1
est store strong
est table mild strong, b(%9.2f) star(.1 .05 .01) stats(N) 
est table mild strong, b(%9.2f) se stats(N) 


//predicted probabilities
preserve
collapse foodexp_treat female black hisp age famincd refinc ed6cat lc7catd pid7catd  bornagain cath jewish othrel ath_agn_norel  
expand 11
egen dsr = fill(0(.1)1)
replace female =1
replace black = 0
replace hisp = 0 
replace age =.4
replace famincd=0.3
replace refinc=0
replace ed6cat=0.4
replace lc7catd=0.5
replace pid7catd=0.5
replace bornagain=0
replace cath=0
replace jewish=0
replace othrel=0
replace ath_agn_norel=0
est restore strong
predict p_1 p_2 p_3 p_4 p_5
gen p_disguststrong = (p_4+p_5)
table dsr, c(mean p_disguststrong)
restore


*****FN19
*fully interactive model
preserve
program foodexp
foreach v of varlist dsr female black hisp age famincd refinc ed6cat lc7catd pid7catd  bornagain cath jewish othrel ath_agn_norel  {
gen foodexp`v' = foodexp_treat*`v'
}
end
foodexp
svy: oprobit fdaspending foodexp* dsr female black hisp age famincd refinc ed6cat lc7catd pid7catd  bornagain cath jewish othrel ath_agn_norel  
restore

*****FN 20
corr lc7catd pid7catd [w=fweight]
alpha lc7catd pid7catd 
gen lc7pid7 = (lc7catd+pid7catd)/2

program drop foodexp
preserve
program foodexp
foreach v of varlist dsr female black hisp age famincd refinc ed6cat lc7pid7 bornagain cath jewish othrel ath_agn_norel  {
gen foodexp`v' = foodexp_treat*`v'
}
end
foodexp
svy: oprobit fdaspending foodexp* dsr female black hisp age famincd refinc ed6cat lc7pid7 bornagain cath jewish othrel ath_agn_norel  
restore




*****FN21
svy: oprobit fdaspending dsr neuroticism female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel if foodexp_treat==0
svy: oprobit fdaspending dsr neuroticism female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel if foodexp_treat==1






*****ONLINE APPENDIX E. OLS RESULTS*****
*TABLE 2 WITH OLS
foreach v of varlist safety detain abortion gaymar gayjob {
svy: reg `v' dsr female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  
est store `v'
}

foreach v of varlist BWdating intermarriage affaxn {
svy: reg `v' dsr female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  if white==1
est store `v'
}

est table safety abortion detain gaymar gayjob BWdating intermarriage affaxn , b(%9.2f) star(.1 .05 .01) stats(N) style(col) eq(1)
est table safety abortion detain gaymar gayjob BWdating intermarriage affaxn , b(%9.2f) se stats(N) style(col) eq(1)

*TABLE 3 WITH OLS
*Moral traditionalism
foreach v of varlist safety detain abortion gaymar gayjob {
svy: reg `v' dsr moral female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  
est store `v'
}

foreach v of varlist BWdating intermarriage affaxn {
svy: reg `v' dsr moral female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  if white==1
est store `v'
}

est table safety abortion detain gaymar gayjob BWdating intermarriage affaxn , b(%9.2f) star(.1 .05 .01) stats(N) style(col) eq(1)
est table safety abortion detain gaymar gayjob BWdating intermarriage affaxn , b(%9.2f) se stats(N) style(col) eq(1)

*TIPI
foreach v of varlist safety detain abortion gaymar gayjob {
svy: reg `v' dsr openness conscientiousness extraversion agreeableness neuroticism  female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  
est store `v'
}

foreach v of varlist BWdating intermarriage affaxn {
svy: reg `v' dsr openness conscientiousness extraversion agreeableness neuroticism  female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  if white==1
est store `v'
}

est table safety abortion detain gaymar gayjob BWdating intermarriage affaxn , b(%9.2f) star(.1 .05 .01) stats(N) style(col) eq(1)
est table safety abortion detain gaymar gayjob BWdating intermarriage affaxn , b(%9.2f) se stats(N) style(col) eq(1)

*Authoritarianism
foreach v of varlist safety detain abortion gaymar gayjob {
svy: reg `v' dsr authsc female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  
est store `v'
}

foreach v of varlist BWdating intermarriage affaxn {
svy: reg `v' dsr authsc female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  if white==1
est store `v'
}

est table safety abortion detain gaymar gayjob BWdating intermarriage affaxn , b(%9.2f) star(.1 .05 .01) stats(N) style(col) eq(1)
est table safety abortion detain gaymar gayjob BWdating intermarriage affaxn , b(%9.2f) se stats(N) style(col) eq(1)


*Racial resentment
foreach v of varlist safety detain abortion gaymar gayjob {
svy: reg `v' dsr resent female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  
est store `v'
}

foreach v of varlist BWdating intermarriage affaxn {
svy: reg `v' dsr resent female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel  if white==1
est store `v'
}

est table safety abortion detain gaymar gayjob BWdating intermarriage affaxn , b(%9.2f) star(.1 .05 .01) stats(N) style(col) eq(1)
est table safety abortion detain gaymar gayjob BWdating intermarriage affaxn , b(%9.2f) se stats(N) style(col) eq(1)


*TABLE 4 WITH OLS
svy: reg fdaspending dsr female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel if foodexp_treat==0
est store mild
svy: reg fdaspending dsr female black hisp age famincd refinc ed6cat lc7catd pid7catd bornagain cath jewish othrel ath_agn_norel if foodexp_treat==1
est store strong
est table mild strong , b(%9.2f) star(.1 .05 .01) stats(N) style(col)
est table mild strong , b(%9.2f) se stats(N) style(col)

*****END OF CODE AT LINE 746.  LAST EDITED BY CDK 10-13-15*****
