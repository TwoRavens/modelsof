********** RATIONALIST EXPERIMENTS ON WAR (REPLICATION) **********

***** STATISTICAL SOFTWARE: STATA VERSION 10 (MAC VERSION)

***** NOTES: (1) Stata Version 10 running on Mac OS X; (2) Player ID ("player") coded based on session*1000+subject; (3) Risk preference ("risk") measured on a summed score based on the decisions made in the risk-aversion game at the end of the experiment: the higher the score, the greater the individual willingness to take risk. Risk game described in Appendix.

***** SETUP

cd "/Users/Sky/Desktop/"

use REW_data.dta

set more off
set scheme sj

capture log close
log using "REW_Replicate.txt", text replace

** Treatment groups (Round1-Round10)

gen treat = 0
replace treat = 1 if (info==0 & enforce==0)
replace treat = 2 if (info==0 & enforce==1)
replace treat = 3 if (info==1 & enforce==0)
replace treat = 4 if (info==1 & enforce==1)

gen playtreat = player + treat*10000
gen sesstreat = session*100 + treat

** Renege variable

gen renege = .
replace renege = 1 if offer1 > offer2
replace renege = 0 if offer1 == offer2

preserve

***** ANALYSIS

*** (Table: Incidence of War Across Conditions)

* Note: "info=1/0" = public/private information conditions; "enforce=1/0" = with/without enforcement

tabstat war if (state==2 & period<11), by(treat) stat(mean) col(stat) long

*** (Table: Average Number of Wars Per Player)

keep if (period < 11)

* drop players with any missing value
drop if (player==3019 | player==3020 | player==3021)

egen player_war = sum(war), by(playtreat)

keep if (period==1 | period==10)

* Note: The 4 treatment groups ("treat") are defined above.

tabstat player_war, by(treat) stat(mean) col(stat) long
tabstat player_war if (session==1), by(treat) stat(mean) col(stat) long
tabstat player_war if (session==2), by(treat) stat(mean) col(stat) long
tabstat player_war if (session==3), by(treat) stat(mean) col(stat) long

*** Result 1a: No-enforcement causes a large increase in wars

restore
preserve
keep if (period < 11)

prtest(war) if (state == 2), by(enforce)
prtest(war) if (info==1 & state == 2), by(enforce)
prtest(war) if (info==0 & state == 2), by(enforce)

*** RESULT 1b: Crossover tests

restore
preserve

* Don't need to drop player 3020 (unaffected before period7)
drop if (player==3019 | player==3021)
keep if (period == 5 | period == 6)

gen catchenforce = .
replace catchenforce = 1 if (enforce==1 & period==5)
replace catchenforce = 0 if (enforce==0 & period==5)
egen maxenforce = max(catchenforce), by(player)

prtest(war) if (maxenforce==0 & state==2), by(period)
prtest(war) if (maxenforce==1 & state==2), by(period)

prtest(war) if (info==1 & maxenforce==0 & state==2), by(period)
prtest(war) if (info==1 & maxenforce==1 & state==2), by(period)
prtest(war) if (info==0 & maxenforce==0 & state==2), by(period)
prtest(war) if (info==0 & maxenforce==1 & state==2), by(period)

* paired ttest

restore
preserve

drop if (player==3019 | player==3021)
keep if (period == 5 | period == 6)

gen bwar_enf0 = war if (enforce==0)
gen bwar_enf1 = war if (enforce==1)

egen war_enf0 = max(bwar_enf0), by(player)
egen war_enf1 = max(bwar_enf1), by(player)

keep if period == 5

ttest war_enf0 = war_enf1 if info == 1
ttest war_enf0 = war_enf1 if info == 0

*** RESULT 2: Renege

restore
preserve
keep if (period < 11)

keep if enforce==0
keep if war == 1
keep if state == 1

* (Figure 4: Wars in stage 1)

tabstat war1, stat(mean) by(period)

restore
preserve
keep if (period < 11)

keep if enforce==0
keep if war1 == 0
keep if state == 1

* (Figure 3: Reneged offers)

tabstat renege, stat(mean) by(period)

keep if offer2 > 1
tabstat peace, stat(mean) by(period)

*** RESULT 3: Info has no effect

restore
preserve
keep if (period < 11)

prtest(war) if state==2, by(info)
prtest(war) if (enforce==1 & state==2), by(info)
prtest(war) if (enforce==0 & state==2), by(info)

* Player averages

drop if (player==3019 | player==3020 | player==3021)
egen player_war = sum(war), by(playtreat)
keep if (period==1 | period==10)

ttest(player_war) if enforce==1, by(info)
ttest(player_war) if enforce==0, by(info)

*** (Figure 2: War in Rounds 1-10)

restore
preserve
keep if (period < 11)

tabstat war if (state==2 & period < 11 & enforce==1), stat(mean) by(period)
tabstat war if (state==2 & period < 11 & enforce==0), stat(mean) by(period)

tabstat war if (state==2 & period < 11 & info==1 & enforce==1), stat(mean) by(period)
tabstat war if (state==2 & period < 11 & info==0 & enforce==1), stat(mean) by(period)
tabstat war if (state==2 & period < 11 & info==1 & enforce==0), stat(mean) by(period)
tabstat war if (state==2 & period < 11 & info==0 & enforce==0), stat(mean) by(period)

*** RESULT 4: Commitment Problem, Rounds 11-15

restore
preserve
keep if (period > 10 & period < 16)

sum war if (state==2 & enforce11==0)
sum war if (state==2 & enforce11==1)

* (Table 4)

tabstat war if (state==2 & enforce11==0), stat(mean, n) by(session)
tabstat war if (state==2 & enforce11==1), stat(mean, n) by(session)

tabstat war if (state==2), by(enforce11) stat(mean) col(stat) long
tabstat war if (state==2 & session==1), by(enforce11) stat(mean) col(stat) long
tabstat war if (state==2 & session==2), by(enforce11) stat(mean) col(stat) long
tabstat war if (state==2 & session==3), by(enforce11) stat(mean) col(stat) long

* (Figure 6)

tabstat war if (state==2 & enforce11==0), stat(mean, n) by(period)
tabstat war if (state==2 & enforce11==1), stat(mean, n) by(period)

* Diff in average incidence of war across players
egen player_mean = mean(war), by(player)
keep if (period==11)
ttest(player_mean), by(enforce11)

* Based on only rounds 11-13
keep if (period > 10 & period < 14)
drop player_mean
egen player_mean = mean(war), by(player)
keep if (period==11)
ttest(player_mean), by(enforce11)

*** APPENDIX (Finding 4): Timer treatments (Round 16)

restore
preserve
keep if period == 16

ranksum war if state==2, by(timer16)
prtest war if state==2, by(timer16)

restore
preserve
drop if (session == 1 & period == 16)
replace period = 16 if (session == 1 & period == 20)
keep if period == 16

ranksum war if state==2, by(timer16)
prtest war if state==2, by(timer16)

restore
preserve
drop if (session == 1 & period == 16)
replace period = 16 if (session == 1 & period == 21)
keep if period == 16

ranksum war if state==2, by(timer16)
prtest war if state==2, by(timer16)

*** <<< REGRESSIONS 1: Periods 1-10 >>>
*** (Table 3: Logit)

restore
preserve

keep if (period < 11)
keep if (state == 2)
gen info_enforce = info*enforce
replace offer1 = . if (offer1 == -1)
sum war enforce info offer1 risk info_enforce

xi: logit war enforce info i.period i.session, cluster(player)
xi: logit war enforce info info_enforce i.period i.session, cluster(player)
xi: logit war enforce info offer1 risk i.period i.session, cluster(player)
xi: logit war enforce info info_enforce offer1 risk i.period i.session, cluster(player)

*** <<< REGRESSIONS 2: Periods 11-15 >>>
*** (Appendix Table A1: Logit)

restore
preserve

keep if (period > 10 & period < 16)
keep if (state == 2)
replace offer1 = . if (offer1 == -1)
sum war offer1 enforce11 risk

logit war enforce11, cluster(player)
logit war enforce11 offer1, cluster(player)
logit war enforce11 offer1 risk, cluster(player)
xi: logit war enforce11 i.period i.session, cluster(player)
xi: logit war enforce11 offer1 i.period i.session, cluster(player)
xi: logit war enforce11 offer1 risk i.period i.session, cluster(player)

log close 