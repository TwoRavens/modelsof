***** Analysis file
***** Conservative Larks, Liberal Owls: The Relationship between Chronotype and Political Ideology
***** Journal of Politics
***** Aleksander Ksiazkiewicz

***** Prepared for Dataverse 11/20/2018



*** Sample 1 analyses
clear 
use sample1

pwcorr beta*, star(.05)

regress beta_ideo beta_chrono
regress beta_ideo beta_chrono beta_age sex_female beta_income beta_education



*** Sample 2 analyses
clear 
use sample2

pwcorr beta*, star(.05)

regress beta_ideo beta_chrono
regress beta_ideo beta_chrono beta_age sex_female beta_income beta_education
regress beta_ideo beta_chrono beta_b5op beta_b5co
regress beta_ideo beta_chrono beta_age sex_female beta_income beta_education beta_b5op beta_b5co



*** Sample 3 analyses
clear
use sample3

pwcorr beta*, star(.05)

regress beta_ideo beta_chrono
regress beta_ideo beta_chrono beta_age sex_female beta_income beta_education
regress beta_ideo beta_age sex_female beta_income beta_education



*** Sample 4 analyses
clear
use sample4

pwcorr beta*, star(.05)

regress beta_ideo beta_chrono
regress beta_ideo beta_chrono beta_age sex_female beta_income beta_education
regress beta_ideo beta_chrono beta_b5op beta_b5co
regress beta_ideo beta_chrono beta_age sex_female beta_income beta_education beta_b5op beta_b5co

regress beta_ideo beta_meq
regress beta_ideo beta_meq beta_age sex_female beta_income beta_education
regress beta_ideo beta_meq beta_b5op beta_b5co
regress beta_ideo beta_meq beta_age sex_female beta_income beta_education beta_b5op beta_b5co



*** Sample 5 analyses
clear 
use sample5

pwcorr beta*, star(.05)

regress beta_ideo beta_chrono
regress beta_ideo beta_chrono beta_age sex_female beta_income beta_education
regress beta_ideo beta_chrono beta_b5op beta_b5co
regress beta_ideo beta_chrono beta_age sex_female beta_income beta_education beta_b5op beta_b5co



*** Sample 6 analyses
clear 
use sample6

pwcorr beta*, star(.05)

regress beta_ideo beta_chrono
regress beta_ideo beta_chrono beta_age sex_female beta_income beta_education



*** Sample 7 analyses
clear
use sample7

pwcorr beta*, star(.05)

regress beta_ideo beta_free_mid
regress beta_ideo beta_free_mid beta_age sex_female beta_income beta_education



*** Sample 8 analyses
** Note: this data is from Add Health Wave IV
** It is available through ICPSR (labeled as DS22 Wave IV: In-Home Questionnaire, Public Use Sample)

clear
use 21600-0022-Data

* Code wake time on free days
gen freewake_h=H4SP3H
recode freewake_h 96=. 98=. 99=.

gen freewake_m=H4SP3M
recode freewake_m 96=. 98=. 99=.

gen freewake_t=H4SP3T
recode freewake_t 6=. 8=.

gen freewake = freewake_h if freewake_t==1
recode freewake 12=0
replace freewake = freewake_h + 12 if freewake_t==2
recode freewake 24=12

replace freewake = freewake + freewake_m/60

* Code sleep time on free days
gen freesleep_h=H4SP4H
recode freesleep_h 96=. 98=. 99=.

gen freesleep_m=H4SP4M
recode freesleep_m 96=. 98=. 99=.

gen freesleep_t=H4SP4T
recode freesleep_t 6=. 8=.

gen freesleep = freesleep_h if freesleep_t==1
recode freesleep 12=0
replace freesleep = freesleep_h + 12 if freesleep_t==2
recode freesleep 24=12

replace freesleep = freesleep + freesleep_m/60

* Calculate sleep duration on free days
gen freesleepduration = freewake - freesleep if freewake>=freesleep
replace freesleepduration = (24-freesleep) + freewake if freesleepduration==.

* Calculate midpoint of freenight sleep
gen freemid = freewake - freesleepduration/2
replace freemid = freemid+24 if freemid<0
replace freemid = . if freesleepduration<4

replace freemid = . if freesleepduration>18

gen freemidcenter = freemid-19.5
replace freemidcenter = freemidcenter + 24 if freemidcenter<0

sum freemidcenter

sum freesleepduration if (freesleep<=6 | freesleep>=19) & (freewake<=15 & freewake>=4)
sum freemidcenter if (freesleep<=6 | freesleep>=19) & (freewake<=15 & freewake>=4)

keep if (freesleep<=6 | freesleep>=19) & (freewake<=15 & freewake>=4)
keep if freesleepduration>=2 & freesleepduration<=18

* Rename ideology variable
rename H4DA28 ideology
tab ideology
recode ideology 96=. 98=. 99=.

* Calculate personality measures

foreach var of varlist H4PE* {
	recode `var' 6=. 8=.
}

alpha H4PE5 H4PE13 H4PE21 H4PE29

gen b5op=(6-H4PE5)
replace b5op=b5op+H4PE13
replace b5op=b5op+H4PE21
replace b5op=b5op+H4PE29

alpha H4PE3 H4PE11 H4PE19 H4PE27

gen b5co=(6-H4PE3)
replace b5co=b5co+H4PE11
replace b5co=b5co+(6-H4PE19)
replace b5co=b5co+H4PE27

alpha H4PE1 H4PE9 H4PE17 H4PE25

gen b5ex=(6-H4PE1)
replace b5ex=b5ex+H4PE9
replace b5ex=b5ex+(6-H4PE17)
replace b5ex=b5ex+H4PE25

alpha H4PE2 H4PE10 H4PE18 H4PE26

gen b5ag=(6-H4PE2) if H4PE2<=5
replace b5ag=b5ag+H4PE10 if H4PE10<=5
replace b5ag=b5ag+(6-H4PE18) if H4PE18<=5
replace b5ag=b5ag+H4PE26 if H4PE26<=5

alpha H4PE4 H4PE6 H4PE8 H4PE12 H4PE14 H4PE16 H4PE20 H4PE22 H4PE24 H4PE28

gen b5ne=(6-H4PE4)
replace b5ne=b5ne+(6-H4PE6)
replace b5ne=b5ne+(6-H4PE8)
replace b5ne=b5ne+H4PE12
replace b5ne=b5ne+H4PE14
replace b5ne=b5ne+H4PE16
replace b5ne=b5ne+(6-H4PE20)
replace b5ne=b5ne+(6-H4PE22)
replace b5ne=b5ne+(6-H4PE24)
replace b5ne=b5ne+H4PE28

* Calculate age at time of interview
gen age = IYEAR4 - H4OD1Y

* Rename sex
gen sex = BIO_SEX4
recode sex 1=0 2=1

* Rename education
gen education = H4ED2
recode education 98=. 12=10 13=11 

* Rename income
tab H4EC1
gen income = H4EC1
recode income 96=. 98=.

* Rename all to standardized variable names and standardize
gen ideo = ideology
gen free_mid = freemidcenter
gen sex_female = sex
gen free_duration = freesleepduration

foreach var of varlist ideo free_mid free_duration age income education b5op b5co {
	gen beta_`var' = `var' if ideo!=. & free_mid!=. & age!=. & income!=. & education!=. & sex_female!=. & b5op!=. & b5co!=. &(freesleep<=6 | freesleep>=19) & (freewake<=15 & freewake>=4)
	qui sum beta_`var'
	local mean=r(mean)
	local sd=r(sd)
	replace beta_`var'=(beta_`var'-`mean')/`sd'
}

* Recode ideology so that higher is conservative
* Recode chrono so that higher is morning
replace beta_ideo = beta_ideo * -1
replace beta_free_mid = beta_free_mid * -1

* Save data
preserve
rename free_mid chrono
rename beta_free_mid beta_chrono

keep beta_* ideo chrono age income education sex_female b5op b5co freesleep freewake freemidcenter freesleepduration
save sample8, replace
restore

clear
use sample8

pwcorr beta*, star(.05)
regress beta_ideo beta_chrono
regress beta_ideo beta_chrono beta_age sex_female beta_income beta_education
regress beta_ideo beta_chrono beta_b5op beta_b5co
regress beta_ideo beta_chrono beta_age sex_female beta_income beta_education beta_b5op beta_b5co
