* Nick Petrovsky
* nicolai.petrovsky@uky.edu

* This do-file generates the tables and analyses reported in 
* James/Petrovsky/Moseley/Boyne (2016, BJPS): 
* "The Politics of Agency Death: Ministers and the Survival 
*  of Government Agencies in a Parliamentary System"
* Do-file by Alice Moseley, Nick Petrovsky, and Oliver James

* Stata version 14.1
* last modified September 27, 2016

* Stata version 13.1
* code last modified August 25, 2014, with the exception of changing 
*  exported graphs from .wmf to .png, to allow do-file to run on MacOS
* page and footnote numbers in the annotations updated on October 17, 2016

* Data set required:
* JamesPetrovskyMoseleyBoyneBJPS.dta

* Please copy this do-file and the data set into a
* directory on your hard drive.
* Then, please use Stata's command
* cd
* to change to that directory.
* Now you can run this do-file.


clear
clear matrix
version 13.1
set more off
set scheme s1mono

* Open data
use JamesPetrovskyMoseleyBoyneBJPS
save workfile, replace

* Open a log and allow for replacement
log using JamesPetrovskyMoseleyBoyneBJPS, replace


* Verify agency age
bysort agencyID: gen t = _n
lab var t "Agency age"
assert t == agency_age
sort agencyID financialyear
save, replace


* Generate a non-parametric baseline (one dummy for each 
* possible agency age)
tabulate agency_age, ge(basedummy)
ds basedummy*


* Generate a variable indicating agencies that will get 
* merged; this variable is called "willgetmerged" and it 
* takes on the following values: 
* 0 if agency will not get merged
* X if agency will get merged into agencyID X
* This variable has 18 unique values.  
gen willgetmerged = 0
replace willgetmerged = 43 if agencyID == 23 | agencyID == 49 | agencyID == 52
replace willgetmerged = 105 if agencyID == 26 | agencyID == 104
replace willgetmerged = 36 if agencyID == 128 | agencyID == 163
replace willgetmerged = 44 if agencyID == 98 | agencyID == 113
replace willgetmerged = 140 if agencyID == 17 | agencyID == 204
replace willgetmerged = 97 if agencyID == 68 | agencyID == 192
replace willgetmerged = 48 if agencyID == 47 | agencyID == 54
replace willgetmerged = 109 if agencyID == 107 | agencyID == 110
replace willgetmerged = 211 if agencyID == 69 | agencyID == 228
replace willgetmerged = 61 if agencyID == 63 | agencyID == 64
replace willgetmerged = 188 if agencyID == 4 | agencyID == 198
replace willgetmerged = 57 if agencyID == 5 | agencyID == 36
replace willgetmerged = 100 if agencyID == 167 | agencyID == 216 | agencyID == 101 | agencyID == 145
replace willgetmerged = 149 if agencyID == 195 | agencyID == 205
replace willgetmerged = 75 if agencyID == 19 | agencyID == 82
replace willgetmerged = 242 if agencyID == 3 | agencyID == 21
replace willgetmerged = 243 if agencyID == 211 | agencyID == 240


* Generate media stories within-agency standard 
* deviation indicator: 
sort agencyID
by agencyID: egen mean_media = mean(mediastories)
by agencyID: egen SD_media = sd(mediastories)
gen media_Z_score = (mediastories - mean_media)/SD_media
sort agencyID financialyear


* Generate two new ministerial change variables: 

* firstminchange
gen firstminchange = newminister
gen l1minid = L1.MinID
replace firstminchange = 0 if newminister == 1 & (l1minid ~= creatingminister)

* subseqminchange
gen subseqminchange = newminister
replace subseqminchange = 0 if newminister == 1 & (l1minid == creatingminister)


sort agencyID financialyear
save, replace


* Define vectors of right-hand side variables

local thecorevariables1 "L.(c.media_Z_score ib0.newparty2 ib0.congruence ib0.newPM ib0.PM_cong c.t#1.newminister c.media_Z_score#c.t#1.newminister ib0.min_cong ib0.newceo) ib0.formerlyfree ib0.func_external ib0.func_regulatory ib0.func_research l.staff_short l.centralspend L.(ib0.trading_fund) ib0.basedummy3 ib0.basedummy4 ib0.basedummy5 ib0.basedummy6 ib0.basedummy7 ib0.basedummy8 ib0.basedummy9 ib0.basedummy10 ib0.basedummy11 ib0.basedummy12 ib0.basedummy13 ib0.basedummy14 ib0.basedummy15 ib0.basedummy16 ib0.basedummy17 ib0.basedummy20 ib0.basedummy21 ib0.basedummy22"

local thecorevariables2 "L.(c.media_Z_score ib0.newparty2 ib0.congruence ib0.newPM ib0.PM_cong ib0.firstminchange ib0.subseqminchange c.media_Z_score#1.firstminchange c.media_Z_score#1.subseqminchange ib0.min_cong ib0.newceo) ib0.formerlyfree ib0.func_external ib0.func_regulatory ib0.func_research l.staff_short l.centralspend L.(ib0.trading_fund) ib0.basedummy3 ib0.basedummy4 ib0.basedummy5 ib0.basedummy6 ib0.basedummy7 ib0.basedummy8 ib0.basedummy9 ib0.basedummy10 ib0.basedummy11 ib0.basedummy12 ib0.basedummy13 ib0.basedummy14 ib0.basedummy15 ib0.basedummy16 ib0.basedummy17 ib0.basedummy20 ib0.basedummy21 ib0.basedummy22"


* Obtain tables of results: 

* Table 2, first column
sort agencyID financialyear
logit anytermination L.(c.targsmilespct_met c.targsmilespct_met#c.media_Z_score) `thecorevariables1' if country == 1, nocons vce(cluster willgetmerged) or
outreg2 using Table2_1, eform tstat bdec(3) tdec(3) nor2 e(ll) /*
*/ title(Table 2_1) /*
*/ word replace

* Count the number of agencies in the estimation sample
codebook agencyID if e(sample)

* Obtain examples of agencies for the text
list agencyID financialyear agencyname end_date agency_termination /*
*/ Minister L2.targsmilespct_met /*
*/ if e(sample) & anytermination == 1 & L2.targsmilespct_met > 80 & /*
*/ L2.targsmilespct_met ~= . & L1.newminister == 1

* Table 2, second column
sort agencyID financialyear
logit anytermination L.(c.targsmilespct_met c.targsmilespct_met#c.media_Z_score) `thecorevariables2' if country == 1, nocons vce(cluster willgetmerged) or
outreg2 using Table2_2, eform tstat bdec(3) tdec(3) nor2 e(ll) /*
*/ title(Table 2_2) /*
*/ word replace

* Obtain substantive interpretations for ministerial
* congruence and trading fund status

* --> rerun the logit model with a constant and one less base 
* dummy, as required by the margins command; see: 
* http://www.stata.com/statalist/archive/2011-06/msg00411.html 
quietly logit anytermination L.(c.targsmilespct_met c.targsmilespct_met#c.media_Z_score) `thecorevariables2' if country == 1, vce(cluster willgetmerged) or
margins L.i.min_cong L.i.trading_fund, grand

* distribution of first ministerial change and agency death by agency age
gen LAGfirstminchange = L.firstminchange
gen LAGsubseqminchange = L.subseqminchange
tab firstminchange
tab LAGfirstminchange if e(sample)
tab firstminchange if agency_age <= 3
tab LAGfirstminchange if agency_age <= 4 & e(sample)
tab subseqminchange
tab LAGsubseqminchange if e(sample)
tab subseqminchange if agency_age <= 3
tab LAGsubseqminchange if agency_age <= 4 & e(sample)
sort agency_age
tab anytermination if e(sample)
by agency_age: tab anytermination if e(sample)
sort agencyID financialyear

* changes in the predicted probability of termination associated with the first ministerial change, at different agency ages
sum agency_age, d
sum agency_age if e(sample)
margins L.firstminchange if agency_age < 5
margins L.firstminchange if agency_age >= 5 & agency_age < 10
margins L.firstminchange if agency_age >= 10

* example of a combination of RHS variables generating a predicted probability of termination > .5
estat classification
predict predprobdeath if e(sample), pr
sum predprobdeath if predprobdeath >= .5 & predprobdeath ~= .
list anytermination agencyID financialyear agencyname if predprobdeath >= .5 & predprobdeath ~= .

* Table 3, first column
sort agencyID financialyear
logit anytermination L.(ib0.high_tarmil_FY ib0.low_tarmil_FY 1.high_tarmil_FY#c.media_Z_score 1.low_tarmil_FY#c.media_Z_score) `thecorevariables1' if country == 1, nocons vce(cluster willgetmerged) or
outreg2 using Table3_1, eform tstat bdec(3) tdec(3) nor2 e(ll) /*
*/ title(Table 3_1) /*
*/ word replace

* Table 3, second column
sort agencyID financialyear
logit anytermination L.(ib0.high_tarmil_FY ib0.low_tarmil_FY 1.high_tarmil_FY#c.media_Z_score 1.low_tarmil_FY#c.media_Z_score) `thecorevariables2' if country == 1, nocons vce(cluster willgetmerged) or
outreg2 using Table3_2, eform tstat bdec(3) tdec(3) nor2 e(ll) /*
*/ title(Table 3_2) /*
*/ word replace

* Figure 2: Predicted probability of agency termination according to the 
* presence or absence of ministerial change at different levels of media 
* stories (with 95 percent confidence intervals)
gen L_subseqminchange = L.subseqminchange
gen L_media_Z_score = L.media_Z_score
gen termination = anytermination
lab var L_media_Z_score "Media stories z-score"
lab var L_subseqminchange "Subsequent ministerial change"
lab def L_subseqminchange 0 "No ministerial change" 1 "Ministerial change"
lab val L_subseqminchange L_subseqminchange
compress
save, replace
quietly logit termination L.(ib0.high_tarmil_FY ib0.low_tarmil_FY) L.1.high_tarmil_FY#c.L_media_Z_score L.1.low_tarmil_FY#c.L_media_Z_score L_media_Z_score L.(ib0.newparty2 ib0.congruence ib0.newPM ib0.PM_cong ib0.firstminchange) i.L_subseqminchange c.L_media_Z_score#L.1.firstminchange i.L_subseqminchange#c.L_media_Z_score L.(ib0.min_cong ib0.newceo) ib0.formerlyfree ib0.func_external ib0.func_regulatory ib0.func_research l.staff_short l.centralspend L.(ib0.trading_fund) ib0.basedummy3 ib0.basedummy4 ib0.basedummy5 ib0.basedummy6 ib0.basedummy7 ib0.basedummy8 ib0.basedummy9 ib0.basedummy10 ib0.basedummy11 ib0.basedummy12 ib0.basedummy13 ib0.basedummy14 ib0.basedummy15 ib0.basedummy16 ib0.basedummy17 ib0.basedummy20 ib0.basedummy21 ib0.basedummy22 if country == 1, vce(cluster willgetmerged) or
margins L_subseqminchange, grand
sum L_media_Z_score if e(sample), d
quietly margins i.L_subseqminchange, at(L_media_Z_score = (-1(1)2))
marginsplot, title("")
graph export Figure2.png, replace


* Table 1 (summary statistics)
quietly logit anytermination L.(c.targsmilespct_met c.targsmilespct_met#c.media_Z_score) `thecorevariables1' if country == 1, nocons vce(cluster willgetmerged) or
sort agencyID financialyear
recode agency_termination (0=0) (1=1) (2=1) (3=1) (4=2) (5=2) (6=2), gen (surviveorendorreorg)
tab agency_termination surviveorendorreorg
gen ongoing = .
replace ongoing = 1 if surviveorendorreorg == 0
replace ongoing = 0 if surviveorendorreorg == 1 | surviveorendorreorg == 2
sum ongoing anytermination L.(targsmilespct_met high_tarmil_FY low_tarmil_FY) `thecorevariables1' L.newminister if e(sample)
* Count number of agencies in estimation sample: 
codebook agencyID if e(sample)
* Provide some information on survival: 
* shortest life span, mean life span, median life span, longest life span
sum agency_age if e(sample), d
sum agency_age if e(sample) & anytermination == 1


* Figure 1: Number of agencies created, ongoing, and 
* terminated in each financial year

* Within each FY, there are three types of agency: 
* a) created this year
* b) created before this year and not terminated this year
* c) created before this year and terminated this year

* Generate the status indicator - a), b), or c) as in the list above: 
* Values of variable agencystatus: 
* 1  continued from previous year with no change
* 2  new this year
* 3  name changed this year
* 5  terminated this year
gen int created = .
replace created = 1 if agencystatus == 2
replace created = 0 if agencystatus ~= 2 & agencystatus ~= .
gen int going = .
replace going = 1 if agencystatus == 1 | agencystatus == 3
replace going = 0 if agencystatus ~= 1 & agencystatus ~= 3 & agencystatus ~= .
gen int terminated = .
replace terminated = 1 if agencystatus == 5
replace terminated = 0 if agencystatus ~= 5 & agencystatus ~= .
tab created if country == 1
tab going if country == 1
tab terminated if country == 1

graph bar (sum) created going terminated if country == 1, /*
*/ over(financialyear, label(alternate)) stack legend(rows(1) /*
*/ label(1 "created") label(2 "ongoing") label(3 "terminated")) /*
*/ bar(1, color(gs16) lcolor(gs0)) bar(2, color(gs12) lcolor(gs0)) /*
*/ bar(3, color(gs0) lcolor(gs16))
graph export Figure1.png, replace


* Footnote 58: Testing for possible endogeneity of the "formerly free" agencies 
* by re-running the models without these agencies

* Table 2, first column
sort agencyID financialyear
logit anytermination L.(c.targsmilespct_met c.targsmilespct_met#c.media_Z_score) `thecorevariables1' if country == 1 & formerlyfree == 0, nocons vce(cluster willgetmerged) or
outreg2 using no_formerly_free_Table2_1, eform tstat bdec(3) tdec(3) nor2 e(ll) /*
*/ title(Table 2_1) /*
*/ word replace

* Table 2, second column
sort agencyID financialyear
logit anytermination L.(c.targsmilespct_met c.targsmilespct_met#c.media_Z_score) `thecorevariables2' if country == 1 & formerlyfree == 0, nocons vce(cluster willgetmerged) or
outreg2 using no_formerly_free_Table2_2, eform tstat bdec(3) tdec(3) nor2 e(ll) /*
*/ title(Table 2_2) /*
*/ word replace

* Table 3, first column
sort agencyID financialyear
logit anytermination L.(ib0.high_tarmil_FY ib0.low_tarmil_FY 1.high_tarmil_FY#c.media_Z_score 1.low_tarmil_FY#c.media_Z_score) `thecorevariables1' if country == 1 & formerlyfree == 0, nocons vce(cluster willgetmerged) or
outreg2 using no_formerly_free_Table3_1, eform tstat bdec(3) tdec(3) nor2 e(ll) /*
*/ title(Table 3_1) /*
*/ word replace

* Table 3, second column
sort agencyID financialyear
logit anytermination L.(ib0.high_tarmil_FY ib0.low_tarmil_FY 1.high_tarmil_FY#c.media_Z_score 1.low_tarmil_FY#c.media_Z_score) `thecorevariables2' if country == 1 & formerlyfree == 0, nocons vce(cluster willgetmerged) or
outreg2 using no_formerly_free_Table3_2, eform tstat bdec(3) tdec(3) nor2 e(ll) /*
*/ title(Table 3_2) /*
*/ word replace


* Page 781: Does reorganization (termination of type 4, 5, or 6) predict 
* a difference in the target achievement rate of the new agencies
* relative to their predecessors?  

* 1) Rectangularize the data to make the following commands work
fillin agencyID financialyear
save, replace

* 2) Obtain over-time target achievement percentage and 
* death year for all agencies
sort agencyID
by agencyID: egen meanTAPCT = mean(targsmilespct_met)
sort agencyID financialyear
forval i = 1(1)246 {
egen Xdeathyear`i' = mean(financialyear) if agency_termination ~= 0 & agency_termination ~= . & agencyID == `i'
}
sort agencyID
forval i = 1(1)246 {
egen deathyear`i' = min(Xdeathyear`i')
drop Xdeathyear`i'
}
sort agencyID financialyear

* 3) Obtain the difference in TAPCT between an agency and 
* its successor

* Relevant agencies with agency_termination == 4 or 
* agency_termination == 5

egen postTAPCT23 = mean(targsmilespct_met) if agencyID == 43 /*
*/ & financialyear > deathyear23 & targsmilespct_met ~= .
egen succTAPCT23 = min(postTAPCT23)
gen succminuspred = succTAPCT23 - meanTAPCT if /*
*/ agencyID == 23 & financialyear == deathyear23

egen postTAPCT49 = mean(targsmilespct_met) if /*
*/ agencyID == 43 & financialyear > deathyear49 /*
*/ & targsmilespct_met ~= .
egen succTAPCT49 = min(postTAPCT49)
replace succminuspred = succTAPCT49 - meanTAPCT if /*
*/ agencyID == 49 & financialyear == deathyear49

egen postTAPCT52 = mean(targsmilespct_met) if /*
*/ agencyID == 43 & financialyear > deathyear52 /*
*/ & targsmilespct_met ~= .
egen succTAPCT52 = min(postTAPCT52)
replace succminuspred = succTAPCT52 - meanTAPCT if /*
*/ agencyID == 52 & financialyear == deathyear52

egen postTAPCT26 = mean(targsmilespct_met) if /*
*/ agencyID == 105 & financialyear > deathyear26 /*
*/ & targsmilespct_met ~= .
egen succTAPCT26 = min(postTAPCT26)
replace succminuspred = succTAPCT26 - meanTAPCT if /*
*/ agencyID == 26 & financialyear == deathyear26

egen postTAPCT104 = mean(targsmilespct_met) if /*
*/ agencyID == 105 & financialyear > deathyear104 /*
*/ & targsmilespct_met ~= .
egen succTAPCT104 = min(postTAPCT104)
replace succminuspred = succTAPCT104 - meanTAPCT if /*
*/ agencyID == 104 & financialyear == deathyear104

egen postTAPCT128 = mean(targsmilespct_met) if /*
*/ agencyID == 36 & financialyear > deathyear128 /*
*/ & targsmilespct_met ~= .
egen succTAPCT128 = min(postTAPCT128)
replace succminuspred = succTAPCT128 - meanTAPCT if /*
*/ agencyID == 128 & financialyear == deathyear128

egen postTAPCT163 = mean(targsmilespct_met) if /*
*/ agencyID == 36 & financialyear > deathyear163 /*
*/ & targsmilespct_met ~= .
egen succTAPCT163 = min(postTAPCT163)
replace succminuspred = succTAPCT163 - meanTAPCT if /*
*/ agencyID == 163 & financialyear == deathyear163

egen postTAPCT98 = mean(targsmilespct_met) if /*
*/ agencyID == 44 & financialyear > deathyear98 /*
*/ & targsmilespct_met ~= .
egen succTAPCT98 = min(postTAPCT98)
replace succminuspred = succTAPCT98 - meanTAPCT if /*
*/ agencyID == 98 & financialyear == deathyear98

egen postTAPCT113 = mean(targsmilespct_met) if /*
*/ agencyID == 44 & financialyear > deathyear113 /*
*/ & targsmilespct_met ~= .
egen succTAPCT113 = min(postTAPCT113)
replace succminuspred = succTAPCT113 - meanTAPCT if /*
*/ agencyID == 113 & financialyear == deathyear113

egen postTAPCT17 = mean(targsmilespct_met) if /*
*/ agencyID == 140 & financialyear > deathyear17 /*
*/ & targsmilespct_met ~= .
egen succTAPCT17 = min(postTAPCT17)
replace succminuspred = succTAPCT17 - meanTAPCT if /*
*/ agencyID == 17 & financialyear == deathyear17

egen postTAPCT204 = mean(targsmilespct_met) if /*
*/ agencyID == 140 & financialyear > deathyear204 /*
*/ & targsmilespct_met ~= .
egen succTAPCT204 = min(postTAPCT204)
replace succminuspred = succTAPCT204 - meanTAPCT if /*
*/ agencyID == 204 & financialyear == deathyear204

egen postTAPCT68 = mean(targsmilespct_met) if /*
*/ agencyID == 97 & financialyear > deathyear68 /*
*/ & targsmilespct_met ~= .
egen succTAPCT68 = min(postTAPCT68)
replace succminuspred = succTAPCT68 - meanTAPCT if /*
*/ agencyID == 68 & financialyear == deathyear68

egen postTAPCT192 = mean(targsmilespct_met) if /*
*/ agencyID == 97 & financialyear > deathyear192 /*
*/ & targsmilespct_met ~= .
egen succTAPCT192 = min(postTAPCT192)
replace succminuspred = succTAPCT192 - meanTAPCT if /*
*/ agencyID == 192 & financialyear == deathyear192

egen postTAPCT47 = mean(targsmilespct_met) if /*
*/ agencyID == 48 & financialyear > deathyear47 /*
*/ & targsmilespct_met ~= .
egen succTAPCT47 = min(postTAPCT47)
replace succminuspred = succTAPCT47 - meanTAPCT if /*
*/ agencyID == 47 & financialyear == deathyear47

egen postTAPCT54 = mean(targsmilespct_met) if /*
*/ agencyID == 48 & financialyear > deathyear54 /*
*/ & targsmilespct_met ~= .
egen succTAPCT54 = min(postTAPCT54)
replace succminuspred = succTAPCT54 - meanTAPCT if /*
*/ agencyID == 54 & financialyear == deathyear54

egen postTAPCT107 = mean(targsmilespct_met) if /*
*/ agencyID == 109 & financialyear > deathyear107 /*
*/ & targsmilespct_met ~= .
egen succTAPCT107 = min(postTAPCT107)
replace succminuspred = succTAPCT107 - meanTAPCT if /*
*/ agencyID == 107 & financialyear == deathyear107

egen postTAPCT110 = mean(targsmilespct_met) if /*
*/ agencyID == 109 & financialyear > deathyear110 /*
*/ & targsmilespct_met ~= .
egen succTAPCT110 = min(postTAPCT110)
replace succminuspred = succTAPCT110 - meanTAPCT if /*
*/ agencyID == 110 & financialyear == deathyear110

egen postTAPCT69 = mean(targsmilespct_met) if /*
*/ agencyID == 211 & financialyear > deathyear69 /*
*/ & targsmilespct_met ~= .
egen succTAPCT69 = min(postTAPCT69)
replace succminuspred = succTAPCT69 - meanTAPCT if /*
*/ agencyID == 69 & financialyear == deathyear69

egen postTAPCT228 = mean(targsmilespct_met) if /*
*/ agencyID == 211 & financialyear > deathyear228 /*
*/ & targsmilespct_met ~= .
egen succTAPCT228 = min(postTAPCT228)
replace succminuspred = succTAPCT228 - meanTAPCT if /*
*/ agencyID == 228 & financialyear == deathyear228

egen postTAPCT63 = mean(targsmilespct_met) if /*
*/ agencyID == 61 & financialyear > deathyear63 /*
*/ & targsmilespct_met ~= .
egen succTAPCT63 = min(postTAPCT63)
replace succminuspred = succTAPCT63 - meanTAPCT if /*
*/ agencyID == 63 & financialyear == deathyear63

egen postTAPCT64 = mean(targsmilespct_met) if /*
*/ agencyID == 61 & financialyear > deathyear64 /*
*/ & targsmilespct_met ~= .
egen succTAPCT64 = min(postTAPCT64)
replace succminuspred = succTAPCT64 - meanTAPCT if /*
*/ agencyID == 64 & financialyear == deathyear64

egen postTAPCT4 = mean(targsmilespct_met) if /*
*/ agencyID == 188 & financialyear > deathyear4 /*
*/ & targsmilespct_met ~= .
egen succTAPCT4 = min(postTAPCT4)
replace succminuspred = succTAPCT4 - meanTAPCT if /*
*/ agencyID == 4 & financialyear == deathyear4

egen postTAPCT198 = mean(targsmilespct_met) if /*
*/ agencyID == 188 & financialyear > deathyear198 /*
*/ & targsmilespct_met ~= .
egen succTAPCT198 = min(postTAPCT198)
replace succminuspred = succTAPCT198 - meanTAPCT if /*
*/ agencyID == 198 & financialyear == deathyear198

egen postTAPCT5 = mean(targsmilespct_met) if /*
*/ agencyID == 57 & financialyear > deathyear5 /*
*/ & targsmilespct_met ~= .
egen succTAPCT5 = min(postTAPCT5)
replace succminuspred = succTAPCT5 - meanTAPCT if /*
*/ agencyID == 5 & financialyear == deathyear5

egen postTAPCT36 = mean(targsmilespct_met) if /*
*/ agencyID == 57 & financialyear > deathyear36 /*
*/ & targsmilespct_met ~= .
egen succTAPCT36 = min(postTAPCT36)
replace succminuspred = succTAPCT36 - meanTAPCT if /*
*/ agencyID == 36 & financialyear == deathyear36

egen postTAPCT167 = mean(targsmilespct_met) if /*
*/ agencyID == 100 & financialyear > deathyear167 /*
*/ & targsmilespct_met ~= .
egen succTAPCT167 = min(postTAPCT167)
replace succminuspred = succTAPCT167 - meanTAPCT if /*
*/ agencyID == 167 & financialyear == deathyear167

egen postTAPCT216 = mean(targsmilespct_met) if /*
*/ agencyID == 100 & financialyear > deathyear216 /*
*/ & targsmilespct_met ~= .
egen succTAPCT216 = min(postTAPCT216)
replace succminuspred = succTAPCT216 - meanTAPCT if /*
*/ agencyID == 216 & financialyear == deathyear216

egen postTAPCT101 = mean(targsmilespct_met) if /*
*/ agencyID == 100 & financialyear > deathyear101 /*
*/ & targsmilespct_met ~= .
egen succTAPCT101 = min(postTAPCT101)
replace succminuspred = succTAPCT101 - meanTAPCT if /*
*/ agencyID == 101 & financialyear == deathyear101

egen postTAPCT145 = mean(targsmilespct_met) if /*
*/ agencyID == 100 & financialyear > deathyear145 /*
*/ & targsmilespct_met ~= .
egen succTAPCT145 = min(postTAPCT145)
replace succminuspred = succTAPCT145 - meanTAPCT if /*
*/ agencyID == 145 & financialyear == deathyear145

egen postTAPCT195 = mean(targsmilespct_met) if /*
*/ agencyID == 149 & financialyear > deathyear195 /*
*/ & targsmilespct_met ~= .
egen succTAPCT195 = min(postTAPCT195)
replace succminuspred = succTAPCT195 - meanTAPCT if /*
*/ agencyID == 195 & financialyear == deathyear195

egen postTAPCT205 = mean(targsmilespct_met) if /*
*/ agencyID == 149 & financialyear > deathyear205 /*
*/ & targsmilespct_met ~= .
egen succTAPCT205 = min(postTAPCT205)
replace succminuspred = succTAPCT205 - meanTAPCT if /*
*/ agencyID == 205 & financialyear == deathyear205

egen postTAPCT19 = mean(targsmilespct_met) if /*
*/ agencyID == 75 & financialyear > deathyear19 /*
*/ & targsmilespct_met ~= .
egen succTAPCT19 = min(postTAPCT19)
replace succminuspred = succTAPCT19 - meanTAPCT if /*
*/ agencyID == 19 & financialyear == deathyear19

egen postTAPCT82 = mean(targsmilespct_met) if /*
*/ agencyID == 75 & financialyear > deathyear82 /*
*/ & targsmilespct_met ~= .
egen succTAPCT82 = min(postTAPCT82)
replace succminuspred = succTAPCT82 - meanTAPCT if /*
*/ agencyID == 82 & financialyear == deathyear82

egen postTAPCT3 = mean(targsmilespct_met) if /*
*/ agencyID == 242 & financialyear > deathyear3 /*
*/ & targsmilespct_met ~= .
egen succTAPCT3 = min(postTAPCT3)
replace succminuspred = succTAPCT3 - meanTAPCT if /*
*/ agencyID == 3 & financialyear == deathyear3

egen postTAPCT21 = mean(targsmilespct_met) if /*
*/ agencyID == 242 & financialyear > deathyear21 /*
*/ & targsmilespct_met ~= .
egen succTAPCT21 = min(postTAPCT21)
replace succminuspred = succTAPCT21 - meanTAPCT if /*
*/ agencyID == 21 & financialyear == deathyear21

egen postTAPCT211 = mean(targsmilespct_met) if /*
*/ agencyID == 243 & financialyear > deathyear211 /*
*/ & targsmilespct_met ~= .
egen succTAPCT211 = min(postTAPCT211)
replace succminuspred = succTAPCT211 - meanTAPCT if /*
*/ agencyID == 211 & financialyear == deathyear211

egen postTAPCT240 = mean(targsmilespct_met) if /*
*/ agencyID == 243 & financialyear > deathyear240 /*
*/ & targsmilespct_met ~= .
egen succTAPCT240 = min(postTAPCT240)
replace succminuspred = succTAPCT240 - meanTAPCT if /*
*/ agencyID == 240 & financialyear == deathyear240

egen postTAPCT20 = mean(targsmilespct_met) if /*
*/ agencyID == 125 & financialyear > deathyear20 /*
*/ & targsmilespct_met ~= .
egen succTAPCT20 = min(postTAPCT20)
replace succminuspred = succTAPCT20 - meanTAPCT if /*
*/ agencyID == 20 & financialyear == deathyear20

egen postTAPCT88 = mean(targsmilespct_met) if /*
*/ agencyID == 244 & financialyear > deathyear88 /*
*/ & targsmilespct_met ~= .
egen succTAPCT88 = min(postTAPCT88)
replace succminuspred = succTAPCT88 - meanTAPCT if /*
*/ agencyID == 88 & financialyear == deathyear88

egen postTAPCT90 = mean(targsmilespct_met) if /*
*/ agencyID == 121 & financialyear > deathyear90 /*
*/ & targsmilespct_met ~= .
egen succTAPCT90 = min(postTAPCT90)
replace succminuspred = succTAPCT90 - meanTAPCT if /*
*/ agencyID == 90 & financialyear == deathyear90

egen postTAPCT96 = mean(targsmilespct_met) if /*
*/ agencyID == 175 & financialyear > deathyear96 /*
*/ & targsmilespct_met ~= .
egen succTAPCT96 = min(postTAPCT96)
replace succminuspred = succTAPCT96 - meanTAPCT if /*
*/ agencyID == 96 & financialyear == deathyear96

egen postTAPCT156 = mean(targsmilespct_met) if /*
*/ agencyID == 116 & financialyear > deathyear156 /*
*/ & targsmilespct_met ~= .
egen succTAPCT156 = min(postTAPCT156)
replace succminuspred = succTAPCT156 - meanTAPCT if /*
*/ agencyID == 156 & financialyear == deathyear156

egen postTAPCT201 = mean(targsmilespct_met) if /*
*/ agencyID == 3 & financialyear > deathyear201 /*
*/ & targsmilespct_met ~= .
egen succTAPCT201 = min(postTAPCT201)
replace succminuspred = succTAPCT201 - meanTAPCT if /*
*/ agencyID == 201 & financialyear == deathyear201

egen postTAPCT214 = mean(targsmilespct_met) if /*
*/ agencyID == 93 & financialyear > deathyear214 /*
*/ & targsmilespct_met ~= .
egen succTAPCT214 = min(postTAPCT214)
replace succminuspred = succTAPCT214 - meanTAPCT if /*
*/ agencyID == 214 & financialyear == deathyear214

egen postTAPCT220 = mean(targsmilespct_met) if /*
*/ agencyID == 218 & financialyear > deathyear220 /*
*/ & targsmilespct_met ~= .
egen succTAPCT220 = min(postTAPCT220)
replace succminuspred = succTAPCT220 - meanTAPCT if /*
*/ agencyID == 220 & financialyear == deathyear220

egen postTAPCT30 = mean(targsmilespct_met) if /*
*/ agencyID == 240 & financialyear > deathyear30 /*
*/ & targsmilespct_met ~= .
egen succTAPCT30 = min(postTAPCT30)
replace succminuspred = succTAPCT30 - meanTAPCT if /*
*/ agencyID == 30 & financialyear == deathyear30

egen postTAPCT114 = mean(targsmilespct_met) if /*
*/ agencyID == 115 & financialyear > deathyear114 /*
*/ & targsmilespct_met ~= .
egen succTAPCT114 = min(postTAPCT114)
replace succminuspred = succTAPCT114 - meanTAPCT if /*
*/ agencyID == 114 & financialyear == deathyear114

egen postTAPCT147 = mean(targsmilespct_met) if /*
*/ agencyID == 150 & financialyear > deathyear147 /*
*/ & targsmilespct_met ~= .
egen succTAPCT147 = min(postTAPCT147)
replace succminuspred = succTAPCT147 - meanTAPCT if /*
*/ agencyID == 147 & financialyear == deathyear147

egen postTAPCT18 = mean(targsmilespct_met) if /*
*/ agencyID == 140 & financialyear > deathyear18 /*
*/ & targsmilespct_met ~= .
egen succTAPCT18 = min(postTAPCT18)
replace succminuspred = succTAPCT18 - meanTAPCT if /*
*/ agencyID == 18 & financialyear == deathyear18

egen postTAPCT35 = mean(targsmilespct_met) if /*
*/ agencyID == 7 & financialyear > deathyear35 /*
*/ & targsmilespct_met ~= .
egen succTAPCT35 = min(postTAPCT35)
replace succminuspred = succTAPCT35 - meanTAPCT if /*
*/ agencyID == 35 & financialyear == deathyear35

egen postTAPCT45 = mean(targsmilespct_met) if /*
*/ agencyID == 42 & financialyear > deathyear45 /*
*/ & targsmilespct_met ~= .
egen succTAPCT45 = min(postTAPCT45)
replace succminuspred = succTAPCT45 - meanTAPCT if /*
*/ agencyID == 45 & financialyear == deathyear45

egen postTAPCT134 = mean(targsmilespct_met) if /*
*/ agencyID == 140 & financialyear > deathyear134 /*
*/ & targsmilespct_met ~= .
egen succTAPCT134 = min(postTAPCT134)
replace succminuspred = succTAPCT134 - meanTAPCT if /*
*/ agencyID == 134 & financialyear == deathyear134

egen postTAPCT165 = mean(targsmilespct_met) if /*
*/ agencyID == 40 & financialyear > deathyear165 /*
*/ & targsmilespct_met ~= .
egen succTAPCT165 = min(postTAPCT165)
replace succminuspred = succTAPCT165 - meanTAPCT if /*
*/ agencyID == 165 & financialyear == deathyear165

egen postTAPCT206 = mean(targsmilespct_met) if /*
*/ agencyID == 217 & financialyear > deathyear206 /*
*/ & targsmilespct_met ~= .
egen succTAPCT206 = min(postTAPCT206)
replace succminuspred = succTAPCT206 - meanTAPCT if /*
*/ agencyID == 206 & financialyear == deathyear206

* This agency that was replaced by two newly created 
* agencies in our data set: agencyID == 6, replaced by 
* agencyID == 55 and agencyID == 129. 
* It is not included in this check.  

* Six agencies have agency_termination == 6, i.e. they were 
* replaced by another executive agency.  

egen postTAPCT27 = mean(targsmilespct_met) if /*
*/ agencyID == 180 & financialyear > deathyear27 /*
*/ & targsmilespct_met ~= .
egen succTAPCT27 = min(postTAPCT27)
replace succminuspred = succTAPCT27 - meanTAPCT if /*
*/ agencyID == 27 & financialyear == deathyear27

egen postTAPCT59 = mean(targsmilespct_met) if /*
*/ agencyID == 37 & financialyear > deathyear59 /*
*/ & targsmilespct_met ~= .
egen succTAPCT59 = min(postTAPCT59)
replace succminuspred = succTAPCT59 - meanTAPCT if /*
*/ agencyID == 59 & financialyear == deathyear59

egen postTAPCT70 = mean(targsmilespct_met) if /*
*/ agencyID == 136 & financialyear > deathyear70 /*
*/ & targsmilespct_met ~= .
egen succTAPCT70 = min(postTAPCT70)
replace succminuspred = succTAPCT70 - meanTAPCT if /*
*/ agencyID == 70 & financialyear == deathyear70

egen postTAPCT158 = mean(targsmilespct_met) if /*
*/ agencyID == 155 & financialyear > deathyear158 /*
*/ & targsmilespct_met ~= .
egen succTAPCT158 = min(postTAPCT158)
replace succminuspred = succTAPCT158 - meanTAPCT if /*
*/ agencyID == 158 & financialyear == deathyear158

egen postTAPCT155 = mean(targsmilespct_met) if /*
*/ agencyID == 142 & financialyear > deathyear155 /*
*/ & targsmilespct_met ~= .
egen succTAPCT155 = min(postTAPCT155)
replace succminuspred = succTAPCT155 - meanTAPCT if /*
*/ agencyID == 155 & financialyear == deathyear155

egen postTAPCT200 = mean(targsmilespct_met) if /*
*/ agencyID == 51 & financialyear > deathyear200 /*
*/ & targsmilespct_met ~= .
egen succTAPCT200 = min(postTAPCT200)
replace succminuspred = succTAPCT200 - meanTAPCT if /*
*/ agencyID == 200 & financialyear == deathyear200

* Save a new workfile in order to generate the figure
save, replace
save workfile2, replace

* Keep the relevant agencies
keep if succminuspred ~= .
save, replace

* Collapse the relevant variables into a cross-section
collapse succminuspred, by(agencyID)
save workfile2, replace

* Summarize the distribution of succminuspred
sum succminuspred, d

* Conduct Wilcoxon signed-rank test
signrank succminuspred = 0


* Footnote 61: 
* Does the number of performance targets an agency operates under 
* during its last two years prior to termination differ from 
* the over-time average number of performance targets it operated 
* under during all prior years of its existence?  

use workfile, replace
erase workfile2.dta

* Obtain the average number of targets during an agency's 
* last two years before the termination year
sort agencyID financialyear
save, replace
gen n_targets_end = /*
*/ (L.targsmiles_set + L2.targsmiles_set)/2 if death == 1

* Obtain the average number of targets during an agency's 
* prior years of existence (three and more years 
* before the termination year)
gen n_targets_before = L3.targsmiles_set /*
*/ if death == 1 & agency_age == 4
replace n_targets_before = /*
*/ (L3.targsmiles_set + L4.targsmiles_set)/2 /*
*/ if death == 1 & agency_age == 5
replace n_targets_before = /*
*/ (L3.targsmiles_set + L4.targsmiles_set /*
*/ + L5.targsmiles_set)/3 /*
*/ if death == 1 & agency_age == 6
replace n_targets_before = /*
*/ (L3.targsmiles_set + L4.targsmiles_set /*
*/ + L5.targsmiles_set + L6.targsmiles_set)/4 /*
*/ if death == 1 & agency_age == 7
replace n_targets_before = /*
*/ (L3.targsmiles_set + L4.targsmiles_set /*
*/ + L5.targsmiles_set + L6.targsmiles_set /*
*/ + L7.targsmiles_set)/5 /*
*/ if death == 1 & agency_age == 8
replace n_targets_before = /*
*/ (L3.targsmiles_set + L4.targsmiles_set /*
*/ + L5.targsmiles_set + L6.targsmiles_set /*
*/ + L7.targsmiles_set + L8.targsmiles_set)/6 /*
*/ if death == 1 & agency_age == 9
replace n_targets_before = /*
*/ (L3.targsmiles_set + L4.targsmiles_set /*
*/ + L5.targsmiles_set + L6.targsmiles_set /*
*/ + L7.targsmiles_set + L8.targsmiles_set /*
*/ + L9.targsmiles_set)/7 /*
*/ if death == 1 & agency_age == 10
replace n_targets_before = /*
*/ (L3.targsmiles_set + L4.targsmiles_set /*
*/ + L5.targsmiles_set + L6.targsmiles_set /*
*/ + L7.targsmiles_set + L8.targsmiles_set /*
*/ + L9.targsmiles_set + L10.targsmiles_set)/8 /*
*/ if death == 1 & agency_age == 11
replace n_targets_before = /*
*/ (L3.targsmiles_set + L4.targsmiles_set /*
*/ + L5.targsmiles_set + L6.targsmiles_set /*
*/ + L7.targsmiles_set + L8.targsmiles_set /*
*/ + L9.targsmiles_set + L10.targsmiles_set /*
*/ + L11.targsmiles_set)/9 /*
*/ if death == 1 & agency_age == 12
replace n_targets_before = /*
*/ (L3.targsmiles_set + L4.targsmiles_set /*
*/ + L5.targsmiles_set + L6.targsmiles_set /*
*/ + L7.targsmiles_set + L8.targsmiles_set /*
*/ + L9.targsmiles_set + L10.targsmiles_set /*
*/ + L11.targsmiles_set + L12.targsmiles_set)/10 /*
*/ if death == 1 & agency_age == 13
replace n_targets_before = /*
*/ (L3.targsmiles_set + L4.targsmiles_set /*
*/ + L5.targsmiles_set + L6.targsmiles_set /*
*/ + L7.targsmiles_set + L8.targsmiles_set /*
*/ + L9.targsmiles_set + L10.targsmiles_set /*
*/ + L11.targsmiles_set + L12.targsmiles_set /*
*/ + L13.targsmiles_set)/11 /*
*/ if death == 1 & agency_age == 14
replace n_targets_before = /*
*/ (L3.targsmiles_set + L4.targsmiles_set /*
*/ + L5.targsmiles_set + L6.targsmiles_set /*
*/ + L7.targsmiles_set + L8.targsmiles_set /*
*/ + L9.targsmiles_set + L10.targsmiles_set /*
*/ + L11.targsmiles_set + L12.targsmiles_set /*
*/ + L13.targsmiles_set + L14.targsmiles_set)/12 /*
*/ if death == 1 & agency_age == 15
replace n_targets_before = /*
*/ (L3.targsmiles_set + L4.targsmiles_set /*
*/ + L5.targsmiles_set + L6.targsmiles_set /*
*/ + L7.targsmiles_set + L8.targsmiles_set /*
*/ + L9.targsmiles_set + L10.targsmiles_set /*
*/ + L11.targsmiles_set + L12.targsmiles_set /*
*/ + L13.targsmiles_set + L14.targsmiles_set /*
*/ + L15.targsmiles_set)/13 /*
*/ if death == 1 & agency_age == 16
replace n_targets_before = /*
*/ (L3.targsmiles_set + L4.targsmiles_set /*
*/ + L5.targsmiles_set + L6.targsmiles_set /*
*/ + L7.targsmiles_set + L8.targsmiles_set /*
*/ + L9.targsmiles_set + L10.targsmiles_set /*
*/ + L11.targsmiles_set + L12.targsmiles_set /*
*/ + L13.targsmiles_set + L14.targsmiles_set /*
*/ + L15.targsmiles_set + L16.targsmiles_set)/14 /*
*/ if death == 1 & agency_age == 17
replace n_targets_before = /*
*/ (L3.targsmiles_set + L4.targsmiles_set /*
*/ + L5.targsmiles_set + L6.targsmiles_set /*
*/ + L7.targsmiles_set + L8.targsmiles_set /*
*/ + L9.targsmiles_set + L10.targsmiles_set /*
*/ + L11.targsmiles_set + L12.targsmiles_set /*
*/ + L13.targsmiles_set + L14.targsmiles_set /*
*/ + L15.targsmiles_set + L16.targsmiles_set /*
*/ + L17.targsmiles_set)/15 /*
*/ if death == 1 & agency_age == 18
replace n_targets_before = /*
*/ (L3.targsmiles_set + L4.targsmiles_set /*
*/ + L5.targsmiles_set + L6.targsmiles_set /*
*/ + L7.targsmiles_set + L8.targsmiles_set /*
*/ + L9.targsmiles_set + L10.targsmiles_set /*
*/ + L11.targsmiles_set + L12.targsmiles_set /*
*/ + L13.targsmiles_set + L14.targsmiles_set /*
*/ + L15.targsmiles_set + L16.targsmiles_set /*
*/ + L17.targsmiles_set + L18.targsmiles_set)/16 /*
*/ if death == 1 & agency_age == 19
replace n_targets_before = /*
*/ (L3.targsmiles_set + L4.targsmiles_set /*
*/ + L5.targsmiles_set + L6.targsmiles_set /*
*/ + L7.targsmiles_set + L8.targsmiles_set /*
*/ + L9.targsmiles_set + L10.targsmiles_set /*
*/ + L11.targsmiles_set + L12.targsmiles_set /*
*/ + L13.targsmiles_set + L14.targsmiles_set /*
*/ + L15.targsmiles_set + L16.targsmiles_set /*
*/ + L17.targsmiles_set + L18.targsmiles_set /*
*/ + L19.targsmiles_set)/17 /*
*/ if death == 1 & agency_age == 20
replace n_targets_before = /*
*/ (L3.targsmiles_set + L4.targsmiles_set /*
*/ + L5.targsmiles_set + L6.targsmiles_set /*
*/ + L7.targsmiles_set + L8.targsmiles_set /*
*/ + L9.targsmiles_set + L10.targsmiles_set /*
*/ + L11.targsmiles_set + L12.targsmiles_set /*
*/ + L13.targsmiles_set + L14.targsmiles_set /*
*/ + L15.targsmiles_set + L16.targsmiles_set /*
*/ + L17.targsmiles_set + L18.targsmiles_set /*
*/ + L19.targsmiles_set + L20.targsmiles_set)/18 /*
*/ if death == 1 & agency_age == 21
replace n_targets_before = /*
*/ (L3.targsmiles_set + L4.targsmiles_set /*
*/ + L5.targsmiles_set + L6.targsmiles_set /*
*/ + L7.targsmiles_set + L8.targsmiles_set /*
*/ + L9.targsmiles_set + L10.targsmiles_set /*
*/ + L11.targsmiles_set + L12.targsmiles_set /*
*/ + L13.targsmiles_set + L14.targsmiles_set /*
*/ + L15.targsmiles_set + L16.targsmiles_set /*
*/ + L17.targsmiles_set + L18.targsmiles_set /*
*/ + L19.targsmiles_set + L20.targsmiles_set /*
*/ + L21.targsmiles_set)/19 /*
*/ if death == 1 & agency_age == 22

* Collapse the relevant variables into a cross-section
collapse n_targets_end n_targets_before, by(agencyID)
save workfile3, replace

* Summarize the distribution
sum n_targets_before, d
sum n_targets_end, d

gen upondeathminusbefore = n_targets_end - n_targets_before
sum upondeathminusbefore if upondeathminusbefore > 0
sum upondeathminusbefore if upondeathminusbefore == 0
sum upondeathminusbefore if upondeathminusbefore < 0
sum upondeathminusbefore, d

* Conduct Wilcoxon signed-rank test
signrank upondeathminusbefore = 0

use workfile, replace
erase workfile3.dta

clear
erase workfile.dta
log close
exit
