*Use Trimmed ANES Cumulative File data set included with replication materials

*"acts2" is additive 0-5 index and drops any respondent that lacks a response for any of the 5 items
*acts2=influence+meeting+campaign+button+donate

*TABLE 1
nbreg acts2 md unionmem ps educ income age age2 female black hispanic other acts2_nonteachers statedum* yeardum* if teacher==1, cluster(stateyear)
nbreg acts2 md unionmem ps educ income age age2 female black hispanic other acts2_nonteachers statedum* yeardum* if teacher==0, cluster(stateyear)

*TABLE 2
estsimp nbreg acts2 md unionmem ps educ income age age2 female black hispanic other acts2_nonteachers statedum2-statedum51 yeardum3-yeardum24 if teacher==1, cluster(stateyear)
setx mean
simqi, fd(ev) changex(md 0 1)
setx mean
simqi, fd(ev) changex(unionmem 0 1)
setx mean
simqi, fd(ev) changex(ps 1 3)
setx mean
simqi, fd(ev) changex(educ 5 7)
setx mean
simqi, fd(ev) changex(income 1 5)

*TABLE 3
nbreg acts2 md1 unionmem ps educ income age age2 female black hispanic other acts2_nonteachers statedum* yeardum* if teacher==1, cluster(stateyear)
nbreg acts2 md2 unionmem ps educ income age age2 female black hispanic other acts2_nonteachers statedum* yeardum* if teacher==1, cluster(stateyear)

*TABLE 4
probit cdp md unionmem ps educ income age age2 female black hispanic other cdp_non statedum* yeardum* if teacher==1, cluster(stateyear)
probit crp md unionmem ps educ income age age2 female black hispanic other cr_non statedum* yeardum* if teacher==1, cluster(stateyear)
probit co md unionmem ps educ income age age2 female black hispanic other co_non statedum* yeardum* if teacher==1, cluster(stateyear)
probit co md unionmem ps educ income age age2 female black hispanic other co_non statedum* yeardum* if teacher==0, cluster(stateyear)
oprobit interest_elections md unionmem ps educ income age age2 female black hispanic other ie_non statedum* yeardum* if teacher==1, cluster(stateyear)
oprobit interest_politics md unionmem ps educ income age age2 female black hispanic other ip_non statedum* yeardum* if teacher==1, cluster(stateyear)


*Merging in presidential competitiveness measure (Margin between Dem and Rep divided by total votes for Dem and Rep) using outcome from 2 years ago for midterm years
gen state_year=stateyear
sort state_year
merge state_year using "Presidential_vote_share_by_state_1952-2012_formatted.dta"
drop _merge
sort state_year
merge state_year using "Midterm_vote_share_by_state_1958-2006_formatted.dta"
drop _merge
replace pres=midterm if pres==.

*Merging in rolling 4 year average of Holbrook and Van Dunk and Ranney state electoral competitiveness
sort state_year
merge state_year using "Ranney_HVD_From_Klarner_2013_04_08_ready_to_merge.dta"
drop _merge

*Merging in state-year union density for 1964-2004 (from unionstats.com)
sort stateyear
merge stateyear using "State_Union_Membership_1964-2004_long.dta"
tab _merge
drop _merge


*TABLES FOR SUPPORTING INFORMATION SECTION

*TABLE SI-1: Using % acts engaged in instead of count
reg pctacts md unionmem ps educ income age age2 female black hispanic other pctacts_nonteachers statedum* yeardum* if teacher==1, cluster(stateyear)

*TABLE SI-2: Female x CB interaction term
nbreg acts2 femaleXcb md unionmem ps educ income age age2 female black hispanic other acts2_nonteachers statedum* yeardum* if teacher==1, cluster(stateyear)

*TABLE SI-3: Only non-union member taachers
nbreg acts2 md ps educ income age age2 female black hispanic other acts2_nonteachers statedum* yeardum* if teacher==1 & unionmem==0, cluster(stateyear)

*TABLE SI-4: Teacher x CB interaction term on full ANES sample
nbreg acts2 teacherXcb teacher md unionmem ps educ income age age2 female black hispanic other acts2_nonteachers statedum* yeardum*, cluster(stateyear)

*TABLE SI-6: Adding in state-year union density for 1964-2004
nbreg acts2 md union_density unionmem ps educ income age age2 female black hispanic other acts2_nonteachers statedum* yeardum* if teacher==1, cluster(stateyear)

*TABLE SI-7: Adding in 3 measures of political competition included
nbreg acts2 md pres hvd_4yr folded_ranney_4yrs unionmem ps educ income age age2 female black hispanic other acts2_nonteachers union_density statedum* yeardum* if teacher==1, cluster(stateyear)
