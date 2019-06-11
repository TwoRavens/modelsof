use allmodes, clear

* Trim the weighting for all surveys at 7
replace weight=7 if weight>7

* Generate variable for age
recode birthyr 9998=. 9999=.
gen age=2010-birthyr
replace age=85 if age>85 & age~=.

* Generate indicators for race
tab race, gen(race)
ren race1 white
ren race2 black
ren race3 hispanic

* Generate indicator for gender
gen female=1 if gender==2
replace female=0 if gender==1

* Generate indicator for home ownership
tab acsownrent, gen(own)
ren own1 own

* Generate indicator for marital status
tab marstat, gen(married)
ren married1 married

* Re-code education
recode educ 6=5

* Generate indicator for whether R voted
tab turnout08, gen(voted)
ren voted4 voted

* Generate indicators for time at address
gen tenure1yr=1 if address_length<4
replace tenure1yr=0 if address_length>3 & address_length~=.

gen tenure5yrs=1 if address_length>5 & address_length~=.
replace tenure5yrs=0 if address_length<6

* Recode income to match CPS categories
gen incless20k=1 if income>0 & income<4
gen inc20to50k=1 if income>3 & income<8
gen inc50to100k=1 if income>7 & income<12
gen incover100k=1 if income>11 & income<15
replace incless20k=0 if incless20k==. & income~=15
replace inc20to50k=0 if inc20to50k==. & income~=15
replace inc50to100k=0 if inc50to100k==. & income~=15
replace incover100k=0 if incover100k==. & income~=15
drop if income==15

* Generate indicator for R's mode of voting
gen vbm=1 if voted08==3 & voted==1
replace vbm=0 if voted==1 & vbm==.

gen earlyip=1 if voted08==2 & voted==1
replace earlyip=0 if voted==1 & earlyip==.

sort mode

* Append CPS dataset to mode study data
append using cpstoappend

* Recode so that all weight variables are under same variable name
replace weight=PWCMPWGT if weight==.
svyset [pw=weight]

* Estimates plotted in Figure 1a
svy: logit voted educ black age female own married inc20to50k inc50to100k incover100k tenure1yr tenure5yrs if mode==1 & votereg==1 
estimates store internet
parmest, saving(internet, replace)
svy: logit voted educ black age female own married inc20to50k inc50to100k incover100k tenure1yr tenure5yrs if mode==2 & votereg==1 
estimates store phone
parmest, saving(phone, replace)
svy: logit voted educ black age female own married inc20to50k inc50to100k incover100k tenure1yr tenure5yrs if mode==4 & votereg==1 
estimates store mail
parmest, saving(mail, replace)
svy: logit voted educ black age female own married inc20to50k inc50to100k incover100k tenure1yr tenure5yrs if notregistered~=1 & mode==. 
estimates store cps
parmest, saving(cps, replace)

* Estimates plotted in Figure 1b
svy: logit vbm educ black age female own married inc20to50k inc50to100k incover100k tenure1yr tenure5yrs if mode==1 & voted==1 
estimates store internet_vbm
parmest, saving(internet_vbm, replace)
svy: logit vbm educ black age female own married inc20to50k inc50to100k incover100k tenure1yr tenure5yrs if mode==2 & voted==1 
estimates store phone_vbm
parmest, saving(phone_vbm, replace)
svy: logit vbm educ black age female own married inc20to50k inc50to100k incover100k tenure1yr tenure5yrs if mode==4 & voted==1 
estimates store mail_vbm
parmest, saving(mail_vbm, replace)
svy: logit vbm educ black age female own married inc20to50k inc50to100k incover100k tenure1yr tenure5yrs if notregistered~=1 & mode==. 
estimates store cps_vbm
parmest, saving(cps_vbm, replace)

* Estimates plotted in Figure 1c
svy: logit earlyip educ black age female own married inc20to50k inc50to100k incover100k tenure1yr tenure5yrs if mode==1 & voted==1 
estimates store internet_earlyip
parmest, saving(internet_earlyip, replace)
svy: logit earlyip educ black age female own married inc20to50k inc50to100k incover100k tenure1yr tenure5yrs if mode==2 & voted==1 
estimates store phone_earlyip
parmest, saving(phone_earlyip, replace)
svy: logit earlyip educ black age female own married inc20to50k inc50to100k incover100k tenure1yr tenure5yrs if mode==4 & voted==1 
estimates store mail_earlyip
parmest, saving(mail_earlyip, replace)
svy: logit earlyip educ black age female own married inc20to50k inc50to100k incover100k tenure1yr tenure5yrs if notregistered~=1 & mode==. 
estimates store cps_earlyip
parmest, saving(cps_earlyip, replace)


* Create the tables that comprise the Appendix
log using cpstable_appendix.log, replace

est table cps internet phone mail, b(%9.2f) stats(N) se style(col) 
est table cps_vbm internet_vbm phone_vbm mail_vbm, b(%9.2f) stats(N) se style(col) 
est table cps_earlyip internet_earlyip phone_earlyip mail_earlyip, b(%9.2f) stats(N) se style(col) 

estimates clear

log close

