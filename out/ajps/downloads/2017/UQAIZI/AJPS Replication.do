***Replication Do File***********************************************************
***"How to Elect More Women: Gender and Candidate Success in a Field Experiment"*
***Christopher F. Karpowitz, J. Quin Monson, and Jessica R. Preece***************
*********************************************************************************

**All analyses were completed on Stata SE 14.1 for Mac
**Please install parmest and combomarginsplot commands

**Place datasets in a folder and change the directory to that folder

**Ex: cd "/Users/cfk/Dropbox/Caucus Project (2)/Data/Replication Data"

cd "Place path to data files here"

use "2014 Precinct Caucus Data Replication Working.dta", clear
set more off

**Variable creation and recoding

gen receiveletter_dum=.
replace receiveletter_dum=1 if receiveletter==1
replace receiveletter_dum=0 if receiveletter==2|receiveletter==3|receiveletter==4

gen content_para_dum=.
replace content_para_dum=1 if content_para==1
replace content_para_dum=0 if content_para==2|content_para==3|content_para==4

gen content_recruit_dum=.
replace content_recruit_dum=1 if content_recruit==1
replace content_recruit_dum=0 if content_recruit==2|content_recruit==3|content_recruit==4

tab condition content_para_dum if receiveletter_dum==1, row
tab condition content_recruit_dum if receiveletter_dum==1, row


**Generate compliance variables, conditional on receiving a letter and reading it before the caucus
gen recruit_dum=.
replace recruit_dum=0 if receiveletter_dum==1
replace recruit_dum=1 if (recruit_num==1|recruit_num==2|recruit_num==3) &receiveletter_dum==1

gen para_dum=.
replace para_dum=0 if receiveletter_dum==1
replace para_dum=1 if para_read==1 & receiveletter_dum==1

gen both_dum=.
replace both_dum=1 if para_dum==1&recruit_dum==1
replace both_dum=0 if recruit_dum==0|para_dum==0


**Generate compliance variables for all precinct chair survey participants
gen recruit_dum2=.
replace recruit_dum2=0 if chair_survey==1
replace recruit_dum2=1 if (recruit_num==1|recruit_num==2|recruit_num==3)

gen para_dum2=.
replace para_dum2=0 if chair_survey==1
replace para_dum2=1 if para_read==1

gen both_dum2=.
replace both_dum2=1 if para_dum2==1&recruit_dum2==1
replace both_dum2=0 if recruit_dum2==0|para_dum2==0

gen female=.
replace female=1 if gender==2
replace female=0 if gender==1

**Create alternate measures for factorial analysis
gen recruit=0
replace recruit=1 if condition==2|condition==4
replace recruit=. if condition==.

gen paragraph=0
replace paragraph=1 if condition==3|condition==4
replace paragraph=. if condition==.

prtest recruit_dum, by(recruit)


**Dummy variable for precincts electing 0 women
gen sd_nofem2014=0
replace sd_nofem2014=1 if prop_sd_fem2014==0
replace sd_nofem2014=. if prop_sd_fem2014==.


gen sd_nofem2012=0
replace sd_nofem2012=1 if prop_sd_fem2012==0
replace sd_nofem2012=. if prop_sd_fem2012==.

**Dummy variable for precincts electing at least 1 woman
gen sd_onefem2014=1-sd_nofem2014

gen sd_onefem2012=1-sd_nofem2012

**Create dummy variables for demographic characteristics of precinct chairs
gen mormon=.
replace mormon=0 if religion~=.
replace mormon=1 if religion==3

gen nonwhite=.
replace nonwhite=0 if race==4
replace nonwhite=1 if race~=4 & race~=.


**Tables used in body of the manuscript

**Table 1: Compliance Summary Statistics -- Survey of Precinct Chairs
**Generate compliance statistics, conditional on receiving a letter and reading it before the caucus
tabulate condition if receiveletter_dum==1, summarize(recruit_dum)
tabulate condition if receiveletter_dum==1, summarize(para_dum)
tabulate condition if receiveletter_dum==1, summarize(both_dum)

**Generate compliance statistics for all precinct chair survey participants
tabulate condition, summarize(recruit_dum2)
tabulate condition, summarize(para_dum2)
tabulate condition, summarize(both_dum2)

**Table 2: Intent-to-Treat Effects -- Precincts Electing At Least One Woman
**OLS
reg sd_onefem2014 i.condition, cluster(county)
reg sd_onefem2014 i.condition sd2014 age2014 attendees2014 prop_fem_attend2014 distance_100, cluster(county)

**Probit
probit sd_onefem2014 i.condition, cluster(county)
probit sd_onefem2014 i.condition sd2014 age2014 attendees2014 prop_fem_attend2014 distance_100, cluster(county)


**Table 3: Intent-to-Treat Effects -- Proportion of State Delegates Who Are Women
**DV is Proportion of Elected Delegates Who Are Women
**OLS
reg prop_sd_fem2014 i.condition, cluster(county)
reg prop_sd_fem2014 i.condition sd2014 age2014 attendees2014 prop_fem_attend2014 distance_100, cluster(county)

**Fractional Logit
glm prop_sd_fem2014 i.condition, family(binomial) link(logit) cluster(county)
glm prop_sd_fem2014 i.condition sd2014 age2014 attendees2014 prop_fem_attend2014 distance_100, family(binomial) link(logit) cluster(county)

margins condition, mcompare(bon) post coeflegend
test _b[1bn.condition]=_b[4.condition]
test _b[2bn.condition]=_b[4.condition]
test _b[3bn.condition]=_b[4.condition]

**Table 4: Intent-to-Treat Effects by Gender of Precinct Chair
**Male Chair
reg prop_sd_fem2014 i.condition if pcfemale_2014==0, cluster(county)
glm prop_sd_fem2014 i.condition if pcfemale_2014==0, family(binomial) link(logit) cluster(county)

**Female Chair
reg prop_sd_fem2014 i.condition if pcfemale_2014==1, cluster(county)
glm prop_sd_fem2014 i.condition if pcfemale_2014==1, family(binomial) link(logit) cluster(county)


**Figures used in body of the manuscript
**Figure 1: Proportion of Meeting Attenders vs. Proportion of Elected Delegates in Control Condition Only
graph twoway (kdensity prop_fem_attend2014 if condition==1, kernel(gaussian)) (kdensity prop_sd_fem2014 if condition==1, kernel(gaussian)) 


**Figure 2: Proportion of Precincts Electing At Least One Woman as State Delegate, by Experimental Condition
reg sd_onefem2014 i.condition
margins condition, level(83) saving("RawOneFemMarg_83", replace)
margins condition, level(95) saving("RawOneFemMarg_95", replace)
marginsplot, level(83) recast(scatter) saving("RawOneFemMarg_83", replace)
marginsplot, level(95) recast(scatter) recastci(rspike) saving("RawOneFemMarg_95", replace)
combomarginsplot "RawOneFemMarg_83" "RawOneFemMarg_95", file1opts(recast(scatter)) file2opts(recast(scatter)) fileci2opts(recast(rspike))

**Figure 3: Estimated Proportion of State Delegates Who Are Women, by Condition
glm prop_sd_fem2014 i.condition sd2014 age2014 attendees2014 prop_fem_attend2014 distance_100, family(binomial) link(logit) cluster(county)
margins condition, level(83) mcompare(bon) saving("Marg_83_bon", replace)
margins condition, level(95) mcompare(bon) saving("Marg_95_bon", replace)
combomarginsplot "Marg_83_bon" "Marg_95_bon", file1opts(recast(scatter)) file2opts(recast(scatter)) fileci2opts(recast(rspike))


**Replication of Tables and Figures in Supporting Information Appendix
**Table A1: Assignment to Conditions
tabulate condition
tabulate condition if letter==1

tabulate condition, summarize(letter)


**Table A2: Randomization Checks
**Four Tests
**Wilcoxon Mann-Whitney tests
for var prop_sd_fem2012 pcfemale_2014 sd2014 age2014 attendees2014 prop_fem_attend2014 distance_100: ranksum X if condition==1|condition==2, by(condition)
for var prop_sd_fem2012 pcfemale_2014 sd2014 age2014 attendees2014 prop_fem_attend2014 distance_100: ranksum X if condition==1|condition==3, by(condition)
for var prop_sd_fem2012 pcfemale_2014 sd2014 age2014 attendees2014 prop_fem_attend2014 distance_100: ranksum X if condition==1|condition==4, by(condition)
for var prop_sd_fem2012 pcfemale_2014 sd2014 age2014 attendees2014 prop_fem_attend2014 distance_100: ranksum X if condition==2|condition==3, by(condition)
for var prop_sd_fem2012 pcfemale_2014 sd2014 age2014 attendees2014 prop_fem_attend2014 distance_100: ranksum X if condition==2|condition==4, by(condition)
for var prop_sd_fem2012 pcfemale_2014 sd2014 age2014 attendees2014 prop_fem_attend2014 distance_100: ranksum X if condition==3|condition==4, by(condition)

**T-tests
for var prop_sd_fem2012 pcfemale_2014 sd2014 age2014 attendees2014 prop_fem_attend2014 distance_100: ttest X if condition==1|condition==2, by(condition)
for var prop_sd_fem2012 pcfemale_2014 sd2014 age2014 attendees2014 prop_fem_attend2014 distance_100: ttest X if condition==1|condition==3, by(condition)
for var prop_sd_fem2012 pcfemale_2014 sd2014 age2014 attendees2014 prop_fem_attend2014 distance_100: ttest X if condition==1|condition==4, by(condition)
for var prop_sd_fem2012 pcfemale_2014 sd2014 age2014 attendees2014 prop_fem_attend2014 distance_100: ttest X if condition==2|condition==3, by(condition)
for var prop_sd_fem2012 pcfemale_2014 sd2014 age2014 attendees2014 prop_fem_attend2014 distance_100: ttest X if condition==2|condition==4, by(condition)
for var prop_sd_fem2012 pcfemale_2014 sd2014 age2014 attendees2014 prop_fem_attend2014 distance_100: ttest X if condition==3|condition==4, by(condition)

**Kolmogorov-Smirnov tests
for var prop_sd_fem2012 pcfemale_2014 sd2014 age2014 attendees2014 prop_fem_attend2014 distance_100: ksmirnov X if condition==1|condition==2, by(condition)
for var prop_sd_fem2012 pcfemale_2014 sd2014 age2014 attendees2014 prop_fem_attend2014 distance_100: ksmirnov X if condition==1|condition==3, by(condition)
for var prop_sd_fem2012 pcfemale_2014 sd2014 age2014 attendees2014 prop_fem_attend2014 distance_100: ksmirnov X if condition==1|condition==4, by(condition)
for var prop_sd_fem2012 pcfemale_2014 sd2014 age2014 attendees2014 prop_fem_attend2014 distance_100: ksmirnov X if condition==2|condition==3, by(condition)
for var prop_sd_fem2012 pcfemale_2014 sd2014 age2014 attendees2014 prop_fem_attend2014 distance_100: ksmirnov X if condition==2|condition==4, by(condition)
for var prop_sd_fem2012 pcfemale_2014 sd2014 age2014 attendees2014 prop_fem_attend2014 distance_100: ksmirnov X if condition==3|condition==4, by(condition)

**Equality of Medians Test
for var prop_sd_fem2012 pcfemale_2014 sd2014 age2014 attendees2014 prop_fem_attend2014 distance_100: median X, by(condition) medianties(split)


**Table A3: Randomization Check -- Conditions and 2012 Results
**OLS
reg prop_sd_fem2012 i.condition, cluster(county)
reg prop_sd_fem2012 i.condition sd2012 age2012 attendees2012 prop_fem_attend2012 distance_100, cluster(county)

**Fractional Logit
glm prop_sd_fem2012 i.condition, family(binomial) link(logit) cluster(county)
glm prop_sd_fem2012 i.condition sd2012 age2012 attendees2012 prop_fem_attend2012 distance_100, family(binomial) link(logit) cluster(county)

**Tables A4-A6: Factorial Analysis
**Table A4: Main Effects of Treatments: Percent of Precincts Electing At Least One Woman
**Results in tables listed as percents, not proportions
probit sd_onefem2014 i.recruit##i.paragraph, cluster(county)
margins recruit paragraph
margins i.recruit##i.paragraph, pwcompare(effects)

**Computing n in each cell
tab recruit if sd_onefem2014~=.
tab paragraph if sd_onefem2014~=.


**Table A5: Main Effects of Treatments: Percent of Elected Delegates Who Are Women
glm prop_sd_fem2014 i.recruit##i.paragraph, family(binomial) link(logit) cluster(county)
margins recruit paragraph
margins i.recruit##i.paragraph, pwcompare(effects)

**Computing n in each cell
tab recruit if prop_sd_fem2014~=.
tab paragraph if prop_sd_fem2014~=.

**Table A6
reg sd_onefem2014 i.recruit##i.paragraph, cluster(county)
probit sd_onefem2014 i.recruit##i.paragraph, cluster(county)
reg prop_sd_fem2014 i.recruit##i.paragraph, cluster(county)
glm prop_sd_fem2014 i.recruit##i.paragraph, family(binomial) link(logit) cluster(county)

**Figure A1: Distribution of Gender Balance in Meeting Attendance, by Condition
graph twoway (kdensity prop_fem_attend2014 if condition==1, kernel(gaussian)) (kdensity prop_fem_attend2014 if condition==2, kernel(gaussian)) (kdensity prop_fem_attend2014 if condition==3, kernel(gaussian)) (kdensity prop_fem_attend2014 if condition==4, kernel(gaussian))

**Table A7: Intent-to-Treat Effects – Proportion of Precincts Electing At Least One Woman, with Controls for Proportion of Female State Delegates in 2012
reg sd_onefem2014 i.condition sd2014 age2014 attendees2014 prop_fem_attend2014 distance_100 prop_sd_fem2012, cluster(county)
probit sd_onefem2014 i.condition sd2014 age2014 attendees2014 prop_fem_attend2014 distance_100 prop_sd_fem2012, cluster(county)

**Table A8: Treatment Effects -- Precincts Electing At Least One Woman, Conditional on Being Sent a Letter
reg sd_onefem2014 i.condition if letter==1, cluster(county)
reg sd_onefem2014 i.condition sd2014 age2014 attendees2014 prop_fem_attend2014 distance_100 if letter==1, cluster(county)

probit sd_onefem2014 i.condition if letter==1, cluster(county)
probit sd_onefem2014 i.condition sd2014 age2014 attendees2014 prop_fem_attend2014 distance_100 if letter==1, cluster(county)

**Table A9: Intent-to-Treat Effects -- Proportion of Delegates Who Are Women, with Controls for Proportion of Female State Delegates in 2012
reg prop_sd_fem2014 i.condition sd2014 age2014 attendees2014 prop_fem_attend2014 distance_100 prop_sd_fem2012, cluster(county)
glm prop_sd_fem2014 i.condition sd2014 age2014 attendees2014 prop_fem_attend2014 distance_100 prop_sd_fem2012, family(binomial) link(logit) cluster(county)


**Table A10: Treatment Effects -- Proportion of Delegates Who Are Women, Conditional on Letter Sent
reg prop_sd_fem2014 i.condition if letter==1, cluster(county)
reg prop_sd_fem2014 i.condition sd2014 age2014 attendees2014 prop_fem_attend2014 distance_100 if letter==1, cluster(county)
glm prop_sd_fem2014 i.condition if letter==1, family(binomial) link(logit) cluster(county)
glm prop_sd_fem2014 i.condition sd2014 age2014 attendees2014 prop_fem_attend2014 distance_100 if letter==1, family(binomial) link(logit) cluster(county)

**Table A11: Intent-to-Treat Effects by Gender of Precinct Chair, with Controls
**Male Precinct Chair
reg prop_sd_fem2014 i.condition sd2014 age2014 attendees2014 prop_fem_attend2014 distance_100 if pcfemale_2014==0, cluster(county)
glm prop_sd_fem2014 i.condition sd2014 age2014 attendees2014 prop_fem_attend2014 distance_100 if pcfemale_2014==0, family(binomial) link(logit) cluster(county)

**Female Precinct Chair
reg prop_sd_fem2014 i.condition sd2014 age2014 attendees2014 prop_fem_attend2014 distance_100 if pcfemale_2014==1, cluster(county)
glm prop_sd_fem2014 i.condition sd2014 age2014 attendees2014 prop_fem_attend2014 distance_100 if pcfemale_2014==1, family(binomial) link(logit) cluster(county)

**Figure A2: Distribution of Proportion of Delegates Who Are Women, by Gender of Precinct Chair
graph twoway (kdensity prop_sd_fem2014 if condition==1 & pcfemale_2014==1, kernel(gaussian) ylabel(0(1)4)) (kdensity prop_sd_fem2014 if condition==2 & pcfemale_2014==1, kernel(gaussian)) (kdensity prop_sd_fem2014 if condition==3 & pcfemale_2014==1, kernel(gaussian)) (kdensity prop_sd_fem2014 if condition==4 & pcfemale_2014==1, kernel(gaussian))
graph twoway (kdensity prop_sd_fem2014 if condition==1 & pcfemale_2014==0, kernel(gaussian)) (kdensity prop_sd_fem2014 if condition==2 & pcfemale_2014==0, kernel(gaussian)) (kdensity prop_sd_fem2014 if condition==3 & pcfemale_2014==0, kernel(gaussian)) (kdensity prop_sd_fem2014 if condition==4 & pcfemale_2014==0, kernel(gaussian))

**Table A12: Precinct Chair Attitudes about Women by Experimental Condition
reg women_more i.condition, cluster(county)
reg women_more i.condition age income mormon nonwhite, cluster(county)
reg women_more i.condition age income mormon nonwhite if female==0, cluster(county)
reg women_more i.condition age income mormon nonwhite if female==1, cluster(county)

**Table A13: Number of Female Candidates by Experimental Condition
ren Total_Female_Running tot_fem_run

nbreg tot_fem_run i.condition
nbreg tot_fem_run i.condition attendees2014
nbreg tot_fem_run i.recruit
nbreg tot_fem_run i.recruit attendees2014 
nbreg tot_fem_run i.recruit attendees2014 if receiveletter_dum==1


**Appendix D: Replication of Results with Survey Respondents Only
**Chair Survey Only
**Create index of attitudes toward women
factor  women_more women_ideas women_menbetter women_toofar
alpha  women_more women_ideas women_menbetter women_toofar, i std gen(women_attitudes)
egen min_women_attitudes=min(women_attitudes)
egen max_women_attitudes=max(women_attitudes)
replace women_attitudes=(women_attitudes-min_women_attitudes)/(max_women_attitudes-min_women_attitudes)


reg prop_sd_fem2014 i.condition if chair_survey==1, cluster(county)
reg prop_sd_fem2014 i.condition sd2014 age2014 attendees2014 prop_fem_attend2014 distance_100 if chair_survey==1, cluster(county)
reg prop_sd_fem2014 i.condition sd2014 age2014 attendees2014 prop_fem_attend2014 distance_100 women_attitudes if chair_survey==1, cluster(county)
reg prop_sd_fem2014 i.condition sd2014 age2014 attendees2014 prop_fem_attend2014 distance_100 women_attitudes if pcfemale_2014==0 & chair_survey==1, cluster(county)
reg prop_sd_fem2014 i.condition sd2014 age2014 attendees2014 prop_fem_attend2014 distance_100 women_attitudes if pcfemale_2014==1 & chair_survey==1, cluster(county)

glm prop_sd_fem2014 i.condition if chair_survey==1, family(binomial) link(logit) cluster(county)
glm prop_sd_fem2014 i.condition sd2014 age2014 attendees2014 prop_fem_attend2014 distance_100 if chair_survey==1, family(binomial) link(logit) cluster(county)
glm prop_sd_fem2014 i.condition sd2014 age2014 attendees2014 prop_fem_attend2014 distance_100 women_attitudes if chair_survey==1, family(binomial) link(logit) cluster(county)
glm prop_sd_fem2014 i.condition sd2014 age2014 attendees2014 prop_fem_attend2014 distance_100 women_attitudes if pcfemale_2014==0 & chair_survey==1, family(binomial) link(logit) cluster(county)
glm prop_sd_fem2014 i.condition sd2014 age2014 attendees2014 prop_fem_attend2014 distance_100 women_attitudes if pcfemale_2014==1 & chair_survey==1, family(binomial) link(logit) cluster(county)




**Replication of YouGov Survey Data
use "YouGov Replication Working.dta", clear

gen women_treat=0
replace women_treat=1 if Q6_rand==1

gen cand5_treat=0
replace cand5_treat=1 if Q7_rand1==1


gen vote_woman=0
replace vote_woman=1 if Q7==1 & (Q7_name_01==4|Q7_name_01==5)
replace vote_woman=1 if Q7==2 & (Q7_name_02==4|Q7_name_02==5)
replace vote_woman=1 if Q7==3 & (Q7_name_03==4|Q7_name_03==5)
replace vote_woman=1 if Q7==4 & (Q7_name_04==4|Q7_name_04==5)
replace vote_woman=1 if Q7==5 & (Q7_name_05==4|Q7_name_05==5)

gen treatments=.
replace treatments=1 if women_treat==0&cand5_treat==0
replace treatments=2 if women_treat==1&cand5_treat==0
replace treatments=3 if women_treat==0&cand5_treat==1
replace treatments=4 if women_treat==1&cand5_treat==1

**Create Control Variables
gen female=0
replace female=1 if gender==2

gen age=2015-birthyr

gen partystrength=pid7-5

gen polint=(5-DEMO012)/4

replace ideo5=3 if ideo5==6


**Replication of Table A14
reg vote_woman i.treatments, cluster(inputstate)
reg vote_woman i.treatments female age educ partystrength polint ideo5, cluster(inputstate)

probit vote_woman i.treatments, cluster(inputstate)
probit vote_woman i.treatments female age educ partystrength polint ideo5, cluster(inputstate)


**Replication of Figure 5
reg vote_woman i.treatments, cluster(inputstate)
probit vote_woman i.treatments, cluster(inputstate)
margins treatments, post mcompare(bonf)
estimates store main_treat

parmest, norestore
gen estimate_2=estimate
replace estimate_2=estimate-.25 if parm=="1.treatments"|parm=="2.treatments"
replace estimate_2=estimate-.4 if parm=="3.treatments"|parm=="4.treatments"
gen xval=.
replace xval=1 if parm=="1.treatments"
replace xval=3 if parm=="2.treatments"
replace xval=2 if parm=="3.treatments"
replace xval=4 if parm=="4.treatments"

replace min95=min95-.25 if parm=="1.treatments"|parm=="2.treatments"
replace min95=min95-.4 if parm=="3.treatments"|parm=="4.treatments"
replace max95=max95-.4 if parm=="3.treatments"|parm=="4.treatments"
replace max95=max95-.25 if parm=="1.treatments"|parm=="2.treatments"

gen min83=estimate_2-(stderr*(invnormal(0.915)))
gen max83=estimate_2+(stderr*(invnormal(0.915)))


graph twoway (scatter estimate_2 xval) || (rspike max95 min95 xval) || (rcap max83 min83 xval)



