*Analysis conducted using Stata 13
*Users will need to change directory names below to run the analyses

clear
use "/Users/gwyneth/Dropbox/Pentecostal Messages Nairobi/Data and Analysis Code/replication files for Religion As Stimulant of Political Participation/religionasstimulant.dta"

*VARIABLE CODING FOR PARTICIPATION PAPER
gen rsi=0
replace rsi=1 if treatment==1
gen ssi=0
replace ssi=1 if treatment==2
gen rpm=0
replace rpm=1 if treatment==3
gen spm=0
replace spm=1 if treatment==4

gen religioustreatment=0
replace religioustreatment=1 if rsi==1 | rpm==1

gen prosperitytreatment=0
replace prosperitytreatment=1 if rpm==1|spm==1

gen age=2014-birthyear

gen christian=1
replace christian=0 if religion==5 | religion==6 | religion==8 | religion==7
sum christian

gen secondaryed=0
replace secondaryed=1 if education>10

recode ownscar (1=1) (2=0), gen(car)
recode ownstv (1=1) (2=0), gen(television)
recode ownsmotorcycle (1=1) (2=0), gen(motorcycle)

recode gender (2=1) (1=0), gen(female)

recode religion (2=1) (1 3 4 5 6 7 8 =0), gen(catholic)
recode religion (1=1) (2 3 4 5 6 7 8 = 0), gen(pentecostal)
recode religion (2 3 =1) (1 4 5 6 7 8 =0), gen(tradchristian)
**above includes mainline protestant and catholic
recode religion (1 4=1) (2 3 5 6 7 8 =0), gen(pentecostal2) 
** above includes pentecostal and the category "other" (likely charismatic or renewalist)

recode marital (2=1) (1 3=0), gen(married)
recode marital (2 3 =1) (1=0), gen(evermarried)

recode nativelanguage (12=1) (1 2 3 4 5 22 6 7 14 8=0), gen(kalenjin)
recode nativelanguage (3=1) (1 2 12 4 5 22 6 7 14 8=0), gen(luhya)
recode nativelanguage (5=1) (1 2 12 4 3 22 6 7 14 8=0), gen(kamba)
recode nativelanguage (4=1) (1 2 12 5 3 22 6 7 14 8=0), gen(kisii)
recode nativelanguage (1=1) (4 2 12 5 3 22 6 7 14 8=0), gen(kikuyu)
recode nativelanguage (2=1) (4 1 12 5 3 22 6 7 14 8=0), gen(luo)
recode nativelanguage (22 6 7 14 8=1) (1 2 3 4 5 12=0), gen(other)

replace beforeattend=. if beforeattend<0

gen joingroup=0
replace joingroup=1 if youthagendajoin==1 & communityforumjoin==1


drop if beforeattend>3

**Test for whether reporting at the end of the experiment that one is a christian is predicted by treatment assignment
logit christian i.treatment
estimates store unconstrained
logit christian if treatment!=.
lrtest unconstrained

**because cannot reject the null that reporting being a christian is not predicted by treatment assignment:
drop if christian==0

save "/Users/gwyneth/Dropbox/Pentecostal Messages Nairobi/Data and Analysis Code/religionasstimulant_withcodedvariables.dta", replace //saves data with newly coded variables for use to create Figures 1 and 4 at end of this file


*SUMMARY STATISTICS
**Reported in the appendix (Table A-4)
sum female education secondaryed age married children beforeattend television motorcycle car luhya kikuyu kisii kamba kalenjin luo
sum sentsms
**TREATMENT ASSIGNMENT AND RANDOMIZATION CHECK (reported in the appendix, p.2)
sum rsi rpm ssi spm
mlogit treatment education married children female age beforeattend kikuyu luhya dictatorkept
estimates store unconstrained
mlogit treatment if education!=. & married!=. & children!=. & female!=. & age!=. & beforeattend!=. & kikuyu!=. & luhya!=.& dictatorkept!=.
lrtest unconstrained

**REPORTED IN RESULTS SECTION OF BODY OF PAPER
ttest sentsms, by(prosperitytreatment) unequal
ttest sentsms if (rpm==1 | ssi==1), by(rpm) unequal
ttest sentsms if (rpm==1 | spm==1), by(rpm) unequal
	**Robustness (reported in Appendix, Table A-5):
	logit sentsms rpm dictatorkept female secondaryed age married beforeattend television 

**Next is the code to reproduce the results reported in the Results section text and in Figure 1
* N.B. Figure 1 in paper was created manually in Powerpoint using standard errors of the means in each comparison but at the end of this .do file there is code to recreate Figure 1 in STATA as well 
by prosperitytreatment, sort: ttest sentsms, by(religioustreatment) unequal

**Figure 2 (below is code for the calculations, but figure 2 was created in R; see separate rtf file in replication materials)
ttest sentsms, by(prosperitytreatment) unequal
ttest tookpamphlet, by(prosperitytreatment) unequal
ttest joingroup, by(prosperitytreatment) unequal
ttest sentsms, by(rpm) unequal
ttest tookpamphlet, by(rpm) unequal
ttest joingroup, by(rpm) unequal

**test for whether treatment assignments are jointly uncorrelated with reporting (at the end of the experiment) that one is specifically Pentecostal
logit pentecostal i.treatment
estimates store unconstrained
logit pentecostal if treatment!=.
lrtest unconstrained

**Figure 3 (below is code for the calculations, but figure 3a and 3b were created in R; see separate rtf files in replication materials)
**subgroups are divided into Pentecostals + Other and then Catholics + Mainline Protestants in order to generate decent-sized subgroups and because Other is likely charismatic or renewalist
ttest sentsms if pentecostal2==1 & (ssi==1 | rpm==1), by(rpm) unequal
ttest sentsms if pentecostal2==1 & (rsi==1 | rpm==1), by(rpm) unequal
ttest sentsms if pentecostal2==1 & (spm==1 | rpm==1), by(rpm) unequal
ttest tookpamphlet if pentecostal2==1 & (ssi==1 | rpm==1), by(rpm) unequal
ttest tookpamphlet if pentecostal2==1 & (rsi==1 | rpm==1), by(rpm) unequal
ttest tookpamphlet if pentecostal2==1 & (spm==1 | rpm==1), by(rpm) unequal
ttest joingroup if pentecostal2==1 & (ssi==1 | rpm==1), by(rpm) unequal
ttest joingroup if pentecostal2==1 & (rsi==1 | rpm==1), by(rpm) unequal
ttest joingroup if pentecostal2==1 & (spm==1 | rpm==1), by(rpm) unequal

ttest joingroup if tradchristian==1 & (ssi==1 | rpm==1), by(rpm) unequal
ttest joingroup if tradchristian==1 & (rsi==1 | rpm==1), by(rpm) unequal
ttest joingroup if tradchristian==1 & (spm==1 | rpm==1), by(rpm) unequal
ttest sentsms if tradchristian==1 & (ssi==1 | rpm==1), by(rpm) unequal
ttest sentsms if tradchristian==1 & (rsi==1 | rpm==1), by(rpm) unequal
ttest sentsms if tradchristian==1 & (spm==1 | rpm==1), by(rpm) unequal
ttest tookpamphlet if tradchristian==1 & (ssi==1 | rpm==1), by(rpm) unequal
ttest tookpamphlet if tradchristian==1 & (rsi==1 | rpm==1), by(rpm) unequal
ttest tookpamphlet if tradchristian==1 & (spm==1 | rpm==1), by(rpm) unequal

*test for differential attrition (discussed in Appendix, p.2)
gen missingsms=1 if sentsms==.
replace missingsms=0 if sentsms~=.
logit missingsms i.treatment
estimates store unconstrained
logit missingsms if treatment!=.
lrtest unconstrained

**TESTS BY RELIGIOUS PRACTICE
merge m:1 surveyid using "/Users/gwyneth/Dropbox/Pentecostal Messages Nairobi/Data and Analysis Code/Religiosity_Followup.dta"

drop if _merge==1
drop if _merge==2

logit answered i.treatment
estimates store unconstrained
logit answered if treatment!=.
lrtest unconstrained

*Busara Center enumerators coded 3 or more times as ``3," and 2 times as ``4," which we found counter-intuitive, so:
recode ChurchAttendance (3 = 4) (4 = 3)
recode PrayerFrequency (3 = 4) (4 = 3)
recode ScriptureReading (3 = 4) (4 = 3)

sum  ChurchAttendance PrayerFrequency ScriptureReading

gen neverattend=.
replace neverattend=1 if ChurchAttendance==1
replace neverattend=0 if ChurchAttendance==2 | ChurchAttendance==3 | ChurchAttendance==4

gen neverpray=.
replace neverpray=1 if PrayerFrequency==1
replace neverpray=0 if PrayerFrequency==2 | PrayerFrequency==3 | PrayerFrequency==4

gen neverscripture=.
replace neverscripture=1 if ScriptureReading==1
replace neverscripture=0 if ScriptureReading==2 | ScriptureReading==3 | ScriptureReading==4

sum neverattend neverpray neverscripture

**test for whether treatment assignment predicts religiosity (discussed in Heterogeneous Treatment Effects section of main paper)
logit neverattend i.treatment
estimates store unconstrained
logit neverattend if treatment!=.
lrtest unconstrained
*Can't reject null: Prob > chi2 =    0.2118

logit neverscripture i.treatment
estimates store unconstrained
logit neverscripture if treatment!=.
lrtest unconstrained
*Can't reject null: Prob > chi2 =    0.7939

**Figure 4 (below is the code to reproduce the results reported in the Results section text and in Figure 4)
** Figure 4 in the main paper was created manually in Powerpoint but at the end of this .do file there is STATA code to reproduce both parts of Figure 4
by neverattend, sort: ttest sentsms if neverattend~=., by(rpm) unequal 
by neverscripture, sort: ttest sentsms if neverscripture~=., by(rpm) unequal 

*Also, tests for interaction (Appendix, Table A-3), also discussed in Heterogeneous Treatment Effects section of main paper:
gen neverattendrpm=rpm*neverattend
reg sentsms rpm neverattend neverattendrpm
gen neverscripturerpm=rpm*neverscripture
reg sentsms rpm neverscripture neverscripturerpm
reg sentsms rpm neverscripture neverscripturerpm female secondaryed married television

*Below reported in Results section and Appendix (Table A-3) 
// can't distinguish treatment effects between those who attended church one or less and those who attended more frequently
gen attendonceorless=.
replace attendonceorless=1 if ChurchAttendance==1 | ChurchAttendance==2
replace attendonceorless=0 if ChurchAttendance==3 | ChurchAttendance==4
by attendonceorless, sort: ttest sentsms if attendonceorless~=., by(rpm) unequal 
gen attendoncerpm=rpm*attendonceorless
reg sentsms rpm attendonceorless attendoncerpm

****Recreating Figures 1 and 4 in STATA
clear 
use "/Users/gwyneth/Dropbox/Pentecostal Messages Nairobi/Data and Analysis Code/religionasstimulant_withcodedvariables.dta"
******STATA code to recreate Figure 1**********
gen notselfaffirming=.
replace notselfaffirming=1 if prosperitytreatment==0
replace notselfaffirming=0 if prosperitytreatment==1
label define selfaffirminglabel 0 "Self-Affirming" 1 "Not Self-Affirming"
label values notselfaffirming selfaffirminglabel

gen notreligious=.
replace notreligious=1 if religioustreatment==0
replace notreligious=0 if religioustreatment==1

gen ratesms=sentsms*100

collapse (mean) meansentsms=ratesms (semean) sesentsms=ratesms, by(notreligious notselfaffirming)
gen hisent=meansentsms+sesentsms
gen lowsent=meansentsms-sesentsms

twoway (bar meansentsms notreligious if notreligious==0, fcolor(gray) lcolor(black)) (bar meansentsms notreligious if notreligious==1, fcolor(white) lcolor(black))  (rcap hisent lowsent notreligious, lcolor(black)), xscale(off) xlabel(0   "Religious" 1   "Secular", labels) by(, legend(off)) by(, graphregion(fcolor(white)) plotregion(fcolor(white))) by(notselfaffirming, note("")) subtitle( , fcolor(white) lcolor(white))  ytitle("") ysc(r(0 50)) ytick(0 (5) 50, labels) xtitle("") saving(figure1)

******STATA code to recreate Figure 4**********
**first half
clear 
use "/Users/gwyneth/Dropbox/Pentecostal Messages Nairobi/Data and Analysis Code/religionasstimulant_withcodedvariables.dta"
merge m:1 surveyid using "/Users/gwyneth/Dropbox/Pentecostal Messages Nairobi/Data and Analysis Code/Religiosity_Followup.dta"
drop if _merge==1
drop if _merge==2
recode ChurchAttendance (3 = 4) (4 = 3)
recode PrayerFrequency (3 = 4) (4 = 3)
recode ScriptureReading (3 = 4) (4 = 3)
gen attendoncemore=.
replace attendoncemore=0 if ChurchAttendance==1
replace attendoncemore=1 if ChurchAttendance==2 | ChurchAttendance==3 | ChurchAttendance==4
label define attendoncemorelabel 0 "Did not attend church" 1 "Attended church once or more"
label values attendoncemore attendoncemorelabel
gen notprosperity=.
replace notprosperity=1 if rpm==0
replace notprosperity=0 if rpm==1
gen ratesms=sentsms*100
collapse (mean) meansentsms=ratesms (semean) sesentsms=ratesms, by(notprosperity attendoncemore)
gen hisent=meansentsms+sesentsms
gen lowsent=meansentsms-sesentsms
twoway (bar meansentsms notprosperity if notprosperity==0, fcolor(gray) lcolor(black)) (bar meansentsms notprosperity if notprosperity==1, fcolor(white) lcolor(black))  (rcap hisent lowsent notprosperity, lcolor(black)), xscale(off) xlabel(0   "Prosperity Gospel" 1   "Other Treatments", labels) by(, legend(off)) by(, graphregion(fcolor(white)) plotregion(fcolor(white))) by(attendoncemore, note("")) subtitle( , fcolor(white) lcolor(white))  ytitle("") ysc(r(0 90)) ytick(0 (10) 90, labels) xtitle("") saving(figure4a)

**second half
clear 
use "/Users/gwyneth/Dropbox/Pentecostal Messages Nairobi/Data and Analysis Code/religionasstimulant_withcodedvariables.dta"
merge m:1 surveyid using "/Users/gwyneth/Dropbox/Pentecostal Messages Nairobi/Data and Analysis Code/Religiosity_Followup.dta"
drop if _merge==1
drop if _merge==2
recode ChurchAttendance (3 = 4) (4 = 3)
recode PrayerFrequency (3 = 4) (4 = 3)
recode ScriptureReading (3 = 4) (4 = 3)
gen scriptureoncemore=.
replace scriptureoncemore=0 if ScriptureReading==1
replace scriptureoncemore=1 if ScriptureReading==2 | ScriptureReading==3 | ScriptureReading==4
label define scriptureoncemorelabel 0 "Did not read scripture" 1 "Read scripture once or more"
label values scriptureoncemore scriptureoncemorelabel
gen notprosperity=.
replace notprosperity=1 if rpm==0
replace notprosperity=0 if rpm==1
gen ratesms=sentsms*100
collapse (mean) meansentsms=ratesms (semean) sesentsms=ratesms, by(notprosperity scriptureoncemore)
gen hisent=meansentsms+sesentsms
gen lowsent=meansentsms-sesentsms
twoway (bar meansentsms notprosperity if notprosperity==0, fcolor(gray) lcolor(black)) (bar meansentsms notprosperity if notprosperity==1, fcolor(white) lcolor(black))  (rcap hisent lowsent notprosperity, lcolor(black)), xscale(off) xlabel(0   "Prosperity Gospel" 1   "Other Treatments", labels) by(, legend(off)) by(, graphregion(fcolor(white)) plotregion(fcolor(white))) by(scriptureoncemore, note("")) subtitle( , fcolor(white) lcolor(white))  ytitle("") ysc(r(0 90)) ytick(0 (10) 90, labels) xtitle("") saving(figure4b)

