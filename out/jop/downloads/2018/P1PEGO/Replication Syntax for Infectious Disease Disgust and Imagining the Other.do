/*Kam, Cindy D. Infectious Disease, Disgust, and Imagining the Other.  Journal of Politics.  Replication Syntax. */

use "C:\Disease_Disgust_data.dta" , clear
set more off
svyset [pweight=weight]
gen fweight = round(weight*100)
drop if tookpost==0
drop if race>3

*****DEPENDENT VARIABLES**********************************
recode VAN201 (1=0 "more than enough")(2=.5)(3=1 "not enough")(else=.), gen(zika_US)
recode VAN202 (1=0 "more than enough")(2=.5)(3=1 "not enough")(else=.), gen(zika_LA)
recode VAN203 (1=1 "very concerned")(2=.67)(3=.33)(4=0)(else=.), gen(zika_concern)
recode VAN208 (1=1 "change")(2=.67)(3=.33)(4=0 "not change")(else=.), gen(zika_travel)

recode VAN701 (1=0 "more than enough")(2=.5)(3=1 "not enough")(else=.), gen(ebola_US)
recode VAN702 (1=0 "more than enough")(2=.5)(3=1 "not enough")(else=.), gen(ebola_AF)
recode VAN703 (1=1 "very concerned")(2=.67)(3=.33)(4=0)(else=.), gen(ebola_concern)
recode VAN708 (1=1 "change")(2=.67)(3=.33)(4=0 "not change")(else=.), gen(ebola_travel)

//TABLE 1
foreach v of varlist ebola_concern ebola_travel ebola_US ebola_AF zika_concern zika_travel zika_US zika_LA {
svy: tab `v'
}


*Comparison across Ebola and Zika
svy: mean ebola_concern zika_concern
test [ebola_concern]=[zika_concern]

svy: mean ebola_travel zika_travel
test [ebola_travel]=[zika_travel]

svy: mean zika_US ebola_US
test [zika_US]=[ebola_US]

svy: mean zika_LA ebola_AF
test [zika_LA]=[ebola_AF]

svy: mean zika_LA zika_US
test [zika_LA]=[zika_US]

svy: mean ebola_US ebola_AF
test [ebola_US]=[ebola_AF]


*****COVARIATES
//Disgust sensitivity
recode VAN411 VAN412 VAN414 (1=0)(2=.25)(3=.5)(4=.75)(5=1)(else=.), gen(toilet cook vomit)
recode VAN413 (1=1)(2=.75)(3=.5)(4=.25)(5=0)(else=.), gen(monkey)
recode VAN415 VAN416 VAN417 VAN418 (1=0)(2=.25)(3=.5)(4=.75)(5=1)(else=.), gen(soda choc maggot milk)
alpha toilet-milk
//alpha = 0.67
gen disgust = (toilet +cook +monkey +vomit +soda +choc +maggot +milk)/8
lab var disgust "Disgust Sensitivity"
svy: mean disgust
*Online appendix figure
histogram disgust [fw=fweight], percent name(disgust, replace) bin(25)
*per http://www.stata.com/statalist/archive/2007-10/msg00327.html

//FN9
gen disgust7 = (toilet +cook +vomit +soda +choc +maggot +milk)/7
lab var disgust7 "Disgust Sensitivity w/o Monkey item"


*****CONTROLS*****
recode gender (1=0)(2=1)(else=.), gen(female)
recode race (1 3=0)(2=1)(else=.), gen(black)
recode race (1 2=0)(3=1)(else=.), gen(hisp)
recode race (1=1)(2 3 =0), gen(white)
gen age = (2016-birthyr-18)/(94-18)
gen famincd = (faminc-1)/15
replace famincd = . if faminc==31
replace famincd = 0 if faminc==97
recode faminc (1/31=0)(97=1)(else=.), gen(refinc)
recode educ (1=0)(2=.2)(3=.4)(4=.6)(5=.8)(6=1)(else=.), gen(ed6cat)
recode CC16_340a (1=0 "Very Lib")(2=.17)(3=.33)(4 8=.5)(5=.67)(6=.83)(7=1 "Very Con")(else=.), gen(lc7catd)
recode pid7 (1=0 "Str Dem")(2=.17)(3=.33)(4 8=.5)(5=.67)(6=.83)(7=1 "Str GOP")(else=.), gen(pid7catd)

//TABLE 2
foreach v of varlist ebola_concern zika_concern ebola_travel  zika_travel ebola_US zika_US ebola_AF zika_LA {
svy: oprobit `v' disgust female black hisp age famincd refinc ed6cat lc7catd pid7catd 
est store `v'
}

est table ebola_concern zika_concern ebola_travel zika_travel ebola_US zika_US ebola_AF zika_LA , b(%9.2f) star(.1 .05 .01) stats(N) style(col) eq(1)
est table ebola_concern zika_concern ebola_travel zika_travel ebola_US zika_US ebola_AF zika_LA , b(%9.2f) se stats(N) style(col) eq(1)


//FIGURE 1
//predicted probabilities
svy: mean female black hisp age famincd refinc ed6cat lc7catd pid7catd 
preserve
collapse female black hisp age famincd refinc ed6cat lc7catd pid7catd 
replace female=1
replace black=0
replace hisp=0
replace refinc=0
replace famincd=.33333
replace lc7catd=.5
replace pid7catd = .5
expand 11
egen disgust =fill(0(.1)1)
lab var disgust "Disgust Sensitivity"
est restore ebola_concern 
predict p1 p2 p3 p4
gen concerned = (p3+p4)
table disgust, c(mean concerned)
twoway (connected concerned disgust, msymbol(i)), name(ebola_concern , replace) title("Concern: Ebola") ytitle("Pr(Very/Somewhat Concerned)") ylabel(0(.1).5)
drop p1 p2 p3 p4 concerned
est restore zika_concern 
predict p1 p2 p3 p4
gen concerned = (p3+p4)
table disgust, c(mean concerned)
twoway (connected concerned disgust, msymbol(i)), name(zika_concern , replace) title("Concern: Zika") ytitle("Pr(Very/Somewhat Concerned)") ylabel(0(.1).5)
drop p1 p2 p3 p4 concerned
est restore ebola_travel  
predict p1 p2 p3 p4
gen travel= (p3+p4)
table disgust, c(mean travel)
twoway (connected travel disgust, msymbol(i)), name(ebola_travel  , replace) title("Cancel Travel: Ebola") ytitle("Pr(Cancel Travel)") ylabel(0(.2)1)
drop p1 p2 p3 p4 travel
est restore zika_travel 
predict p1 p2 p3 p4
gen travel= (p3+p4)
table disgust, c(mean travel)
twoway (connected travel disgust, msymbol(i)), name(zika_travel , replace) title("Cancel Travel: Zika") ytitle("Pr(Cancel Travel)") ylabel(0(.2)1)
drop p1 p2 p3 p4 travel
est restore ebola_US 
predict p1 p2 p3
table disgust, c(mean p3)
twoway (connected p3 disgust, msymbol(i)), name(ebola_US , replace) title("Protect Americans: Ebola") ytitle("Pr(Not Doing Enough)") ylabel(0(.1).5)
drop p1 p2 p3
est restore zika_US 
predict p1 p2 p3
table disgust, c(mean p3)
twoway (connected p3 disgust, msymbol(i)), name(zika_US, replace) title("Protect Americans: Zika") ytitle("Pr(Not Doing Enough)") ylabel(0(.1).5)
drop p1 p2 p3
est restore ebola_AF 
predict p1 p2 p3
table disgust, c(mean p3)
twoway (connected p3 disgust, msymbol(i)), name(ebola_AF , replace) title("Fight Ebola Abroad") ytitle("Pr(Not Doing Enough)") ylabel(0(.1).5)
drop p1 p2 p3 
est restore zika_LA 
predict p1 p2 p3
table disgust, c(mean p3)
twoway (connected p3 disgust, msymbol(i)), name(zika_LA, replace) title("Fight Zika Abroad") ytitle("Pr(Not Doing Enough)") ylabel(0(.1).5)
restore
graph combine ebola_concern zika_concern ebola_travel zika_travel ebola_US zika_US ebola_AF zika_LA , col(2) xcommon ysize(12) xsize(6) altshrink name(basic, replace)
graph export Figure1.tif, name(basic) as(tif) replace


//comparing magnitude of effects across zika versus ebola
suest zika_concern ebola_concern, svy
test [zika_concern_zika_concern]disgust = [ebola_concern_ebola_concern]disgust

suest zika_travel ebola_travel, svy
test [zika_travel_zika_travel]disgust = [ebola_travel_ebola_travel]disgust

suest zika_US ebola_US, svy
test [zika_US_zika_US]disgust = [ebola_US_ebola_US]disgust

suest zika_LA ebola_AF, svy
test [zika_LA_zika_LA]disgust = [ebola_AF_ebola_AF]disgust


//Which Type of Disgust?
gen coredisgust = (monkey + vomit +milk +maggot)/4
gen contamdisgust = (toilet +cook +choc +soda)/4
svy: mean coredisgust contamdisgust
corr coredisgust contamdisgust [w=fweight]
alpha monkey vomit milk maggot
alpha toilet cook choc soda

lab var coredisgust "Core Disgust"
lab var contamdisgust "Contamination Disgust"
histogram coredisgust [fw=fweight], percent name(coredisgust, replace) bin(25)
histogram contamdisgust [fw=fweight], percent name(contamdisgust, replace) bin(25)
graph combine coredisgust contamdisgust

foreach v of varlist ebola_concern zika_concern ebola_travel  zika_travel ebola_US zika_US ebola_AF zika_LA {
quietly svy, subpop(white): oprobit `v' coredisgust contamdisgust  female black hisp age famincd refinc ed6cat lc7catd pid7catd 
est store `v'
}

est table ebola_concern zika_concern ebola_travel zika_travel ebola_US zika_US ebola_AF zika_LA , b(%9.2f) star(.1 .05 .01) stats(N) style(col) eq(1) keep(coredisgust contamdisgust)
est table ebola_concern zika_concern ebola_travel zika_travel ebola_US zika_US ebola_AF zika_LA , b(%9.2f) se stats(N) style(col) eq(1) keep(coredisgust contamdisgust)


//Disgust or Realistic Threat?
*****Localities for Ebola & Zika
recode inputstate (1 12 13 22 28 45 48=1)(else=0), gen(zikasites)
lab var zikasites "AL, FL, GA, LA, MS, SC, TX"

//Ebola cases:  TX, NY, GA, NE
recode inputstate (48 36 13 31=1)(else=0), gen(ebolasites)

foreach v of varlist ebola_US ebola_AF ebola_concern ebola_travel  {
quietly svy: oprobit `v' disgust ebolasites female black hisp age famincd refinc ed6cat lc7catd pid7catd 
est store `v'
}


foreach v of varlist zika_US zika_LA zika_concern zika_travel  {
quietly svy: oprobit `v' disgust zikasites female black hisp age famincd refinc ed6cat lc7catd pid7catd 
est store `v'
}


est table ebola_concern zika_concern ebola_travel zika_travel ebola_US zika_US ebola_AF zika_LA , b(%9.2f) star(.1 .05 .01) stats(N) style(col) eq(1)
est table ebola_concern zika_concern ebola_travel zika_travel ebola_US zika_US ebola_AF zika_LA , b(%9.2f) se stats(N) style(col) eq(1)

gen disgustebolasites = disgust*ebolasites
gen disgustzikasites = disgust*zikasites

foreach v of varlist ebola_US ebola_AF ebola_concern ebola_travel  {
quietly svy: oprobit `v' disgust disgustebolasites ebolasites female black hisp age famincd refinc ed6cat lc7catd pid7catd 
est store `v'
}

foreach v of varlist zika_US zika_LA zika_concern zika_travel  {
quietly svy: oprobit `v' disgust disgustzikasites zikasites female black hisp age famincd refinc ed6cat lc7catd pid7catd 
est store `v'
}
est table ebola_concern zika_concern ebola_travel zika_travel ebola_US zika_US ebola_AF zika_LA , b(%9.2f) star(.1 .05 .01) stats(N) style(col) eq(1)
est table ebola_concern zika_concern ebola_travel zika_travel ebola_US zika_US ebola_AF zika_LA , b(%9.2f) se stats(N) style(col) eq(1)


*****Women of CB age
//create childbearing age cohorts: 18-44; 45 and over
recode birthyr (1900/1971 =0 "Over 44")(1972/1999=1 "Age 18-44")(else=.), gen(CBage)
gen femCB = female*CBage

foreach v of varlist ebola_concern zika_concern ebola_travel  zika_travel ebola_US zika_US ebola_AF zika_LA {
quietly svy: oprobit `v' disgust female femCB CBage black hisp age famincd refinc ed6cat lc7catd pid7catd 
est store `v'
}


est table ebola_concern zika_concern ebola_travel zika_travel ebola_US zika_US ebola_AF zika_LA , b(%9.2f) star(.1 .05 .01) stats(N) style(col) eq(1)
est table ebola_concern zika_concern ebola_travel zika_travel ebola_US zika_US ebola_AF zika_LA , b(%9.2f) se stats(N) style(col) eq(1)


//among women of CB age versus not, effect of disgust sensitivity
gen CBdisgust = CBage*disgust
foreach v of varlist ebola_concern zika_concern ebola_travel  zika_travel ebola_US zika_US ebola_AF zika_LA {
quietly svy, subpop(female): oprobit `v' disgust CBdisgust CBage black hisp age famincd refinc ed6cat lc7catd pid7catd 
est store `v'
}


est table ebola_concern zika_concern ebola_travel zika_travel ebola_US zika_US ebola_AF zika_LA , b(%9.2f) star(.1 .05 .01) stats(N_sub) style(col) eq(1)
est table ebola_concern zika_concern ebola_travel zika_travel ebola_US zika_US ebola_AF zika_LA , b(%9.2f) se stats(N_sub) style(col) eq(1)

//Disgust Relative to Anxiety
*TIPI: Neuroticism
recode VAN763 (1=0)(2=.17)(3=.33)(4=.5)(5=.67)(6=.83)(7=1)(else=.), gen(neuro1)
recode VAN768 (1=1)(2=.83)(3=.67)(4=.5)(5=.33)(6=.17)(7=0)(else=.), gen(neuro2)
gen neurotic = (neuro1+neuro2)/2
corr_svy disgust neurotic  [pw=weight]

foreach v of varlist ebola_concern zika_concern ebola_travel  zika_travel ebola_US zika_US ebola_AF zika_LA {
quietly svy: oprobit `v' disgust neurotic female black hisp age famincd refinc ed6cat lc7catd pid7catd 
est store `v'
}

est table ebola_concern zika_concern ebola_travel zika_travel ebola_US zika_US ebola_AF zika_LA , b(%9.2f) star(.1 .05 .01) stats(N) style(col) eq(1)
est table ebola_concern zika_concern ebola_travel zika_travel ebola_US zika_US ebola_AF zika_LA , b(%9.2f) se stats(N) style(col) eq(1)



//Initial Test of Othering
*Basic results for whites
foreach v of varlist ebola_concern zika_concern ebola_travel  zika_travel ebola_US zika_US ebola_AF zika_LA {
quietly svy, subpop(white): oprobit `v' disgust female black hisp age famincd refinc ed6cat lc7catd pid7catd 
est store `v'
}

est table ebola_concern zika_concern ebola_travel zika_travel ebola_US zika_US ebola_AF zika_LA , b(%9.2f) star(.1 .05 .01) stats(N_sub) style(col) eq(1) keep(disgust)
est table ebola_concern zika_concern ebola_travel zika_travel ebola_US zika_US ebola_AF zika_LA , b(%9.2f) se stats(N_sub) style(col) eq(1) keep(disgust)

*Group attitudes
gen ftb = VAN105/100
gen fth = VAN108/100

foreach v of varlist ebola_US ebola_AF ebola_concern ebola_travel  {
quietly svy, subpop(white): oprobit `v' disgust ftb female black hisp age famincd refinc ed6cat lc7catd pid7catd 
est store `v'
}

foreach v of varlist zika_US zika_LA zika_concern zika_travel  {
quietly svy, subpop(white): oprobit `v' disgust fth female black hisp age famincd refinc ed6cat lc7catd pid7catd 
est store `v'
}

est table ebola_concern zika_concern ebola_travel zika_travel ebola_US zika_US ebola_AF zika_LA , b(%9.2f) star(.1 .05 .01) stats(N_sub) style(col) eq(1) keep(disgust ftb fth)
est table ebola_concern zika_concern ebola_travel zika_travel ebola_US zika_US ebola_AF zika_LA , b(%9.2f) se stats(N_sub) style(col) eq(1) keep(disgust ftb fth)

*Difference scores
gen ftw = VAN106/100
gen wftb = (ftw-ftb)
gen wfth = (ftw-fth)
foreach v of varlist ebola_US ebola_AF ebola_concern ebola_travel  {
quietly svy, subpop(white): oprobit `v' disgust wftb female black hisp age famincd refinc ed6cat lc7catd pid7catd 
est store `v'
}

foreach v of varlist zika_US zika_LA zika_concern zika_travel  {
quietly svy, subpop(white): oprobit `v' disgust wfth female black hisp age famincd refinc ed6cat lc7catd pid7catd 
est store `v'
}

est table ebola_concern zika_concern ebola_travel zika_travel ebola_US zika_US ebola_AF zika_LA , b(%9.2f) star(.1 .05 .01) stats(N_sub) style(col) eq(1) 
est table ebola_concern zika_concern ebola_travel zika_travel ebola_US zika_US ebola_AF zika_LA , b(%9.2f) se stats(N_sub) style(col) eq(1) 

*Disgust x Group Affect 
gen disgustftb = disgust*ftb
gen disgustfth = disgust*fth
foreach v of varlist ebola_US ebola_AF ebola_concern ebola_travel  {
quietly svy, subpop(white): oprobit `v' disgust disgustftb ftb female black hisp age famincd refinc ed6cat lc7catd pid7catd 
est store `v'
}

foreach v of varlist zika_US zika_LA zika_concern zika_travel  {
quietly svy, subpop(white): oprobit `v' disgust disgustfth fth female black hisp age famincd refinc ed6cat lc7catd pid7catd 
est store `v'
}

est table ebola_concern zika_concern ebola_travel zika_travel ebola_US zika_US ebola_AF zika_LA , b(%9.2f) star(.1 .05 .01) stats(N_sub) style(col) eq(1) 
est table ebola_concern zika_concern ebola_travel zika_travel ebola_US zika_US ebola_AF zika_LA , b(%9.2f) se stats(N_sub) style(col) eq(1) 


*Ethnocentrism (among whites only)
gen fta = VAN107/100
gen ftm = VAN109/100
gen eft = ftw-((ftb+fth+fta+ftm)/4) if race==1
//remove muslim respondents for eft
replace eft = . if religpew==6

gen wfta = (ftw-fta)
gen wftm = (ftw-ftm)
alpha wftb wfth wfta wftm if race==1 & religpew~=6
svy: mean eft
corr_svy disgust eft  [pw=weight]

foreach v of varlist ebola_concern zika_concern ebola_travel  zika_travel ebola_US zika_US ebola_AF zika_LA {
svy, subpop(white): oprobit `v' disgust eft female black hisp age famincd refinc ed6cat lc7catd pid7catd 
est store `v'
}

est table ebola_concern zika_concern ebola_travel zika_travel ebola_US zika_US ebola_AF zika_LA , b(%9.2f) star(.1 .05 .01) stats(N_sub) style(col) eq(1) keep(disgust eft)
est table ebola_concern zika_concern ebola_travel zika_travel ebola_US zika_US ebola_AF zika_LA , b(%9.2f) se stats(N_sub) style(col) eq(1) keep(disgust eft)

*Disgust x E
gen disgusteft = disgust*eft
foreach v of varlist ebola_concern zika_concern ebola_travel  zika_travel ebola_US zika_US ebola_AF zika_LA {
svy, subpop(white): oprobit `v' disgust disgusteft eft female black hisp age famincd refinc ed6cat lc7catd pid7catd 
est store `v'
}

est table ebola_concern zika_concern ebola_travel zika_travel ebola_US zika_US ebola_AF zika_LA , b(%9.2f) star(.1 .05 .01) stats(N_sub) style(col) eq(1) 
est table ebola_concern zika_concern ebola_travel zika_travel ebola_US zika_US ebola_AF zika_LA , b(%9.2f) se stats(N_sub) style(col) eq(1) 



*****SURVEY EXPERIMENT
recode VAN211 (1=1 "prevent")(2=.5)(3=0 "screen")(else=.), gen(zika_noentry)
recode VAN211_treat (1=0 "US")(2=1 "foreigners")(else=.), gen(zika_F_cond)
recode VAN711 (1=1 "prevent")(2=.5)(3=0 "screen")(else=.), gen(ebola_noentry)
recode VAN711_treat (1=0 "US")(2=1 "foreigners")(else=.), gen(ebola_F_cond)
recode ebola_F_cond (1=0)(0=1)(else=.), gen(ebola_US_cond)
recode zika_F_cond (1=0)(0=1)(else=.), gen(zika_US_cond)

//Table 4
svy: tab ebola_noentry ebola_F_cond
svy: tab zika_noentry zika_F_cond

*test of difference of means across samples
svy: reg ebola_noentry ebola_F_cond
svy: reg zika_noentry zika_F_cond

//Table 5
svy, subpop(ebola_US_cond): oprobit ebola_noentry disgust female black hisp age famincd refinc ed6cat lc7catd pid7catd 
est store ebola_noentry_US
svy, subpop(ebola_F_cond): oprobit ebola_noentry disgust female black hisp age famincd refinc ed6cat lc7catd pid7catd 
est store ebola_noentry_foreign
svy, subpop(zika_US_cond): oprobit zika_noentry disgust female black hisp age famincd refinc ed6cat lc7catd pid7catd
est store zika_noentry_US
svy, subpop(zika_F_cond): oprobit zika_noentry disgust female black hisp age famincd refinc ed6cat lc7catd pid7catd 
est store zika_noentry_foreign
est table ebola_noentry_US ebola_noentry_foreign zika_noentry_US zika_noentry_foreign , b(%9.2f) star(.1 .05 .01) stats(N_sub) eq(1)
est table ebola_noentry_US ebola_noentry_foreign zika_noentry_US zika_noentry_foreign , b(%9.2f) se stats(N_sub) eq(1) style(col)

preserve
collapse female black hisp age famincd refinc ed6cat lc7catd pid7catd 
replace female=1
replace black=0
replace hisp=0
replace refinc=0
replace famincd=.33
replace lc7catd=.5
replace pid7catd = .5
expand 11
egen disgust =fill(0(.1)1)
lab var disgust "Disgust Sensitivity"

foreach v in ebola_noentry_US ebola_noentry_foreign zika_noentry_US zika_noentry_foreign  {
est restore `v'
predict `v', outcome(#3)
}
table disgust, c(mean ebola_noentry_US mean ebola_noentry_foreign) f(%9.2f)
twoway (connected zika_noentry_US disgust, msymbol(i)) (connected zika_noentry_foreign disgust, msymbol(i)), name(zika_noentry, replace) title("Zika: Prevent Entry") legend(lab(1 "US") lab(2 "Foreign")) ytitle("Pr(Prevent Entry)")
twoway (connected ebola_noentry_US disgust, msymbol(i)) (connected ebola_noentry_foreign disgust, msymbol(i)), name(ebola_noentry, replace) title("Ebola: Prevent Entry") legend(lab(1 "US") lab(2 "Foreign")) ytitle("Pr(Prevent Entry)")
restore
graph combine ebola_noentry zika_noentry , col(2) ycommon xcommon altshrink name(Figure2, replace)
graph export Figure2.tif, name(Figure2) as(tif) replace


//FN 22
foreach v of varlist disgust female black hisp age famincd refinc ed6cat lc7catd pid7catd {
gen ebola_F_`v'=ebola_F_cond*`v'
}

svy: oprobit ebola_noentry ebola_F_* disgust female black hisp age famincd refinc ed6cat lc7catd pid7catd 

//Which type of disgust?
svy, subpop(ebola_US_cond): oprobit ebola_noentry coredisgust contamdisgust female black hisp age famincd refinc ed6cat lc7catd pid7catd 
est store ebola_noentry_US
svy, subpop(ebola_F_cond): oprobit ebola_noentry coredisgust contamdisgust female black hisp age famincd refinc ed6cat lc7catd pid7catd 
est store ebola_noentry_foreign
svy, subpop(zika_US_cond): oprobit zika_noentry coredisgust contamdisgust female black hisp age famincd refinc ed6cat lc7catd pid7catd
est store zika_noentry_US
svy, subpop(zika_F_cond): oprobit zika_noentry coredisgust contamdisgust female black hisp age famincd refinc ed6cat lc7catd pid7catd 
est store zika_noentry_foreign
est table ebola_noentry_US ebola_noentry_foreign zika_noentry_US zika_noentry_foreign , b(%9.2f) star(.1 .05 .01) stats(N_sub) eq(1)
est table ebola_noentry_US ebola_noentry_foreign zika_noentry_US zika_noentry_foreign , b(%9.2f) se stats(N_sub) eq(1) style(col)


//group attitudes
gen Wzika_US_cond= zika_US_cond if race==1
gen Wzika_F_cond= zika_F_cond if race==1
gen Webola_US_cond=ebola_US_cond if race==1
gen Webola_F_cond=ebola_F_cond if race==1

*Basic model
svy, subpop(Webola_US_cond): oprobit ebola_noentry disgust female black hisp age famincd refinc ed6cat lc7catd pid7catd 
est store ebola_noentry_US
svy, subpop(Webola_F_cond): oprobit ebola_noentry disgust female black hisp age famincd refinc ed6cat lc7catd pid7catd 
est store ebola_noentry_foreign
svy, subpop(Wzika_US_cond): oprobit zika_noentry disgust female black hisp age famincd refinc ed6cat lc7catd pid7catd
est store zika_noentry_US
svy, subpop(Wzika_F_cond): oprobit zika_noentry disgust female black hisp age famincd refinc ed6cat lc7catd pid7catd 
est store zika_noentry_foreign
est table ebola_noentry_US ebola_noentry_foreign zika_noentry_US zika_noentry_foreign , b(%9.2f) star(.1 .05 .01) stats(N_sub) eq(1)
est table ebola_noentry_US ebola_noentry_foreign zika_noentry_US zika_noentry_foreign , b(%9.2f) se stats(N_sub) eq(1) style(col)

*Group attitudes
svy, subpop(Webola_US_cond): oprobit ebola_noentry disgust ftb female black hisp age famincd refinc ed6cat lc7catd pid7catd 
est store ebola_noentry_US
svy, subpop(Webola_F_cond): oprobit ebola_noentry disgust ftb female black hisp age famincd refinc ed6cat lc7catd pid7catd 
est store ebola_noentry_foreign
svy, subpop(Wzika_US_cond): oprobit zika_noentry disgust fth female black hisp age famincd refinc ed6cat lc7catd pid7catd
est store zika_noentry_US
svy, subpop(Wzika_F_cond): oprobit zika_noentry disgust fth female black hisp age famincd refinc ed6cat lc7catd pid7catd 
est store zika_noentry_foreign
est table ebola_noentry_US ebola_noentry_foreign zika_noentry_US zika_noentry_foreign , b(%9.2f) star(.1 .05 .01) stats(N_sub) eq(1) keep(disgust ftb fth)
est table ebola_noentry_US ebola_noentry_foreign zika_noentry_US zika_noentry_foreign , b(%9.2f) se stats(N_sub) eq(1) style(col) keep(disgust ftb fth)

*Difference scores
svy, subpop(Webola_US_cond): oprobit ebola_noentry disgust wftb female black hisp age famincd refinc ed6cat lc7catd pid7catd 
est store ebola_noentry_US
svy, subpop(Webola_F_cond): oprobit ebola_noentry disgust wftb female black hisp age famincd refinc ed6cat lc7catd pid7catd 
est store ebola_noentry_foreign
svy, subpop(Wzika_US_cond): oprobit zika_noentry disgust wfth female black hisp age famincd refinc ed6cat lc7catd pid7catd
est store zika_noentry_US
svy, subpop(Wzika_F_cond): oprobit zika_noentry disgust wfth female black hisp age famincd refinc ed6cat lc7catd pid7catd 
est store zika_noentry_foreign
est table ebola_noentry_US ebola_noentry_foreign zika_noentry_US zika_noentry_foreign , b(%9.2f) star(.1 .05 .01) stats(N_sub) eq(1)
est table ebola_noentry_US ebola_noentry_foreign zika_noentry_US zika_noentry_foreign , b(%9.2f) se stats(N_sub) eq(1) style(col)

*Ethnocentrism
svy, subpop(Webola_US_cond): oprobit ebola_noentry disgust eft female black hisp age famincd refinc ed6cat lc7catd pid7catd 
est store ebola_noentry_US
svy, subpop(Webola_F_cond): oprobit ebola_noentry disgust eft female black hisp age famincd refinc ed6cat lc7catd pid7catd 
est store ebola_noentry_foreign
svy, subpop(Wzika_US_cond): oprobit zika_noentry disgust eft female black hisp age famincd refinc ed6cat lc7catd pid7catd
est store zika_noentry_US
svy, subpop(Wzika_F_cond): oprobit zika_noentry disgust eft female black hisp age famincd refinc ed6cat lc7catd pid7catd 
est store zika_noentry_foreign
est table ebola_noentry_US ebola_noentry_foreign zika_noentry_US zika_noentry_foreign , b(%9.2f) star(.1 .05 .01) stats(N) eq(1)
est table ebola_noentry_US ebola_noentry_foreign zika_noentry_US zika_noentry_foreign , b(%9.2f) se stats(N) eq(1) style(col)

*Disgust x group attitudes
svy, subpop(Webola_US_cond): oprobit ebola_noentry disgust disgustftb ftb female black hisp age famincd refinc ed6cat lc7catd pid7catd 
est store ebola_noentry_US
svy, subpop(Webola_F_cond): oprobit ebola_noentry disgust disgustftb ftb female black hisp age famincd refinc ed6cat lc7catd pid7catd 
est store ebola_noentry_foreign
svy, subpop(Wzika_US_cond): oprobit zika_noentry disgust disgustfth fth female black hisp age famincd refinc ed6cat lc7catd pid7catd
est store zika_noentry_US
svy, subpop(Wzika_F_cond): oprobit zika_noentry disgust disgustfth fth female black hisp age famincd refinc ed6cat lc7catd pid7catd 
est store zika_noentry_foreign
est table ebola_noentry_US ebola_noentry_foreign zika_noentry_US zika_noentry_foreign , b(%9.2f) star(.1 .05 .01) stats(N_sub) eq(1)
est table ebola_noentry_US ebola_noentry_foreign zika_noentry_US zika_noentry_foreign , b(%9.2f) se stats(N_sub) eq(1) style(col)

*Disgust x E
svy, subpop(Webola_US_cond): oprobit ebola_noentry disgust disgusteft eft female black hisp age famincd refinc ed6cat lc7catd pid7catd 
est store ebola_noentry_US
svy, subpop(Webola_F_cond): oprobit ebola_noentry disgust disgusteft eft female black hisp age famincd refinc ed6cat lc7catd pid7catd 
est store ebola_noentry_foreign
svy, subpop(Wzika_US_cond): oprobit zika_noentry disgust disgusteft eft female black hisp age famincd refinc ed6cat lc7catd pid7catd
est store zika_noentry_US
svy, subpop(Wzika_F_cond): oprobit zika_noentry disgust disgusteft eft female black hisp age famincd refinc ed6cat lc7catd pid7catd 
est store zika_noentry_foreign
est table ebola_noentry_US ebola_noentry_foreign zika_noentry_US zika_noentry_foreign , b(%9.2f) star(.1 .05 .01) stats(N_sub) eq(1)
est table ebola_noentry_US ebola_noentry_foreign zika_noentry_US zika_noentry_foreign , b(%9.2f) se stats(N_sub) eq(1) style(col)


//Removing monkey item and re-running main analyses
foreach v of varlist ebola_concern zika_concern ebola_travel  zika_travel ebola_US zika_US ebola_AF zika_LA {
svy: oprobit `v' disgust7 female black hisp age famincd refinc ed6cat lc7catd pid7catd 
est store `v'
}

est table ebola_concern zika_concern ebola_travel zika_travel ebola_US zika_US ebola_AF zika_LA , b(%9.2f) star(.1 .05 .01) stats(N) style(col) eq(1)
est table ebola_concern zika_concern ebola_travel zika_travel ebola_US zika_US ebola_AF zika_LA , b(%9.2f) se stats(N) style(col) eq(1)

svy, subpop(ebola_US_cond): oprobit ebola_noentry disgust7 female black hisp age famincd refinc ed6cat lc7catd pid7catd 
est store ebola_noentry_US
svy, subpop(ebola_F_cond): oprobit ebola_noentry disgust7 female black hisp age famincd refinc ed6cat lc7catd pid7catd 
est store ebola_noentry_foreign
svy, subpop(zika_US_cond): oprobit zika_noentry disgust7 female black hisp age famincd refinc ed6cat lc7catd pid7catd
est store zika_noentry_US
svy, subpop(zika_F_cond): oprobit zika_noentry disgust7 female black hisp age famincd refinc ed6cat lc7catd pid7catd 
est store zika_noentry_foreign
est table ebola_noentry_US ebola_noentry_foreign zika_noentry_US zika_noentry_foreign , b(%9.2f) star(.1 .05 .01) stats(N_sub) eq(1)
est table ebola_noentry_US ebola_noentry_foreign zika_noentry_US zika_noentry_foreign , b(%9.2f) se stats(N_sub) eq(1) style(col)
