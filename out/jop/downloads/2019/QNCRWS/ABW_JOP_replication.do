*********************** Replication file of the analyses conducted in the paper *******************************************
*********************** "Social Welfare Policy Outputs and Governing Parties' Left-Right Images: Do Voters Respond?" *******
*********************** Authors: James Adams, Luca Bernardi and Christopher Wlezien ****************************************
*********************** Publication: Journal of Politics (February 2019) ***************************************************


***** BEGIN DO FILE *****

clear
use "replace working directory here/ABW_JOP_replication.dta"

xtset code year


***** Analyses in the manuscript *****

* Table 1: Analyses of Governing PartiesÕ Perceived Left-Right Shifts
reg d_CSES cwed d_cwed if govt_full_term==1, cluster(party_n)
r2_a

reg d_CSES l_CSES cwed d_cwed if govt_full_term==1, cluster(party_n)
r2_a

reg d_CSES cwed d_cwed CMP d_CMP if govt_full_term==1, cluster(party_n)
r2_a

reg d_CSES l_CSES cwed d_cwed CMP d_CMP if govt_full_term==1, cluster(party_n)
r2_a


* Figure 1: Effects of the Current Level of Welfare Generosity Index on VotersÕ Perceptions of PartiesÕ Left-Right Shifts* Panel hypothetical left partyreg d_CSES l_CSES cwed d_cwed if govt_full_term==1, cluster(party_n)
margins, at(cwed=(20.9(1)46.6) l_CSES=3.07 (mean) d_cwed) level(90)
marginsplot, recast(line) recastci(rline) ciopts(lpattern(dash))

* Panel hypothetical center party
reg d_CSES l_CSES cwed d_cwed if govt_full_term==1, cluster(party_n)
margins, at(cwed=(20.9(1)46.6) l_CSES=5.57 (mean) d_cwed) level(90)
marginsplot, recast(line) recastci(rline) ciopts(lpattern(dash))

* Panel hypothetical right party
reg d_CSES l_CSES cwed d_cwed if govt_full_term==1, cluster(party_n)
margins, at(cwed=(20.9(1)46.6) l_CSES=8.07 (mean) d_cwed) level(90)
marginsplot, recast(line) recastci(rline) ciopts(lpattern(dash))

graph combine "left90ci_new.gph" "center90ci_new.gph" "right90ci_new.gph"



***** Analyses in the Online Appendix *****

* Table S2: Descriptive Statistics on PartiesÕ Left-Right Images and Welfare Generositysum d_CSES l_CSES cwed d_cwed if govt_full_term==1 & d_CSES!=.* Table S3: Analyses of PartiesÕ Perceived Left-Right Shifts, without Welfare Generosity Changereg d_CSES cwed if govt_full_term==1, cluster(party_n)
r2_a

reg d_CSES l_CSES cwed if govt_full_term==1, cluster(party_n)
r2_a


* Table S4: Analyses of PartiesÕ Perceived Left-Right Shifts, for Mainstream Parties

* Generate dummy for green party (CMP party family)
gen green = 0
replace green = 1 if party_n==63110 | party_n==42110 | party_n==62110 | party_n==14110 | party_n==31110 | party_n==41110 | party_n==53110 | party_n==22110 | party_n==64110 | party_n==11110

* Generate dummy for nationalist party (CMP party family)
gen nationalist = 0
replace nationalist = 1 if party_n==42710 | party_n==13720 | party_n==31720 | party_n==22720 | party_n==22722 | party_n==11710

* Generate dummy for agrarian party (CMP party family)
gen agrarian = 0
replace agrarian = 1 if party_n==63810 | party_n==14810 | party_n==12810 | party_n==11810

* Generate dummy for ethno-regionalistic party (CMP party family)
gen ethnic = 0
replace ethnic = 1 if party_n==62901 | party_n==14901 | party_n==53951 | party_n==22952 | party_n==64901 | party_n==12951 | party_n==33902 | party_n==33905 | party_n==33907 | party_n==33908 | party_n==51902
reg d_CSES cwed d_cwed if govt_full_term==1 & green!=1 & nationalist!=1 & agrarian!=1 & ethnic!=1, cluster(party_n)
r2_a

reg d_CSES l_CSES cwed d_cwed if govt_full_term==1 & green!=1 & nationalist!=1 & agrarian!=1 & ethnic!=1, cluster(party_n)
r2_a
* Table S5: Analyses of PartiesÕ Perceived Left-Right Shifts, for European Parties gen ches_corr8 = 0
replace ches_corr8 = 1 if cc==4 | cc==5 | cc==6 | cc==7 | cc==9 | cc==10 | cc==13 | cc==14 | cc==15 | cc==16

reg d_CSES cwed d_cwed if govt_full_term==1 & ches_corr8==1, cluster(party_n)
r2_a

reg d_CSES l_CSES cwed d_cwed if govt_full_term==1 & ches_corr8==1, cluster(party_n)
r2_a* Table S6: Analyses of PartiesÕ Perceived Left-Right Shifts, Estimates on ÒNewÓ versus ÒOldÓ Governing Parties * Generate dummy variable for governing parties that equals 1 when the party was already in government at the time of the previous election, and zero otherwise
gen govt_previous_election = 0 if govt[_n]==1 & govt[_n-1]!=1
replace govt_previous_election = 1 if govt[_n]==1 & govt[_n-1]==1
reg d_CSES c.cwed##i.govt_previous_election c.d_cwed##i.govt_previous_election if govt_full_term==1, cluster(party_n)
r2_a

reg d_CSES c.cwed##i.govt_previous_election c.d_cwed##i.govt_previous_election c.l_CSES##i.govt_previous_election if govt_full_term==1, cluster(party_n)
r2_a
* Table S7: Analyses of PartiesÕ Perceived Left-Right Shifts, Estimates on Prime Ministerial Parties versus Junior Coalition Partners * Generate junior coalition partner (1=junior coalition partner; 0=otherwise)
gen junior = 0
replace junior = 1 if govt==1 & pm!=1

reg d_CSES c.cwed##i.junior c.d_cwed##i.junior if govt_full_term==1, cluster(party_n)
r2_a

reg d_CSES c.cwed##i.junior c.d_cwed##i.junior c.l_CSES##i.junior if govt_full_term==1, cluster(party_n)
r2_a
* Table S8: Analyses of PartiesÕ Perceived Left-Right Shifts, All Currently Governing Parties reg d_CSES cwed d_cwed if govt==1, cluster(party_n)
r2_a

reg d_CSES l_CSES cwed d_cwed if govt==1, cluster(party_n)
r2_a
* Table S9: Analyses of PartiesÕ Perceived Left-Right Shifts, Cases Involving Non-Consecutive Election Years Omitted * Generate missing consecutive election dummy variablegen miss_elec = 0
replace miss_elec = 1 if (country=="Australia" & year==1996)
replace miss_elec = 1 if (country=="Australia" & year==2004)
replace miss_elec = 1 if (country=="Canada" & year==1997)
replace miss_elec = 1 if (country=="Canada" & year==2004)
replace miss_elec = 1 if (country=="Denmark" & year==2001)
replace miss_elec = 1 if (country=="Denmark" & year==2007)
replace miss_elec = 1 if (country=="Germany" & year==1976)
replace miss_elec = 1 if (country=="Germany" & year==1983)
replace miss_elec = 1 if (country=="Germany" & year==1990)
replace miss_elec = 1 if (country=="Germany" & year==1998)
replace miss_elec = 1 if (country=="Netherlands" & year==2002)
replace miss_elec = 1 if (country=="Netherlands" & year==2006)
replace miss_elec = 1 if (country=="New Zealand" & year==1996)
replace miss_elec = 1 if (country=="New Zealand" & year==2002)
replace miss_elec = 1 if (country=="New Zealand" & year==2008)

reg d_CSES cwed d_cwed if govt_full_term==1 & miss_elec==0, cluster(party_n)
r2_a

reg d_CSES l_CSES cwed d_cwed if govt_full_term==1 & miss_elec==0, cluster(party_n)
r2_a
* Table S10: Analyses of PartiesÕ Perceived Left-Right Shifts, Errors-In-Variables Regressions for CMP Basic Modeleivreg d_CSES cwed d_cwed CMP d_CMP if govt_full_term==1, r(CMP 0.9 d_CMP 0.9)
eivreg d_CSES cwed d_cwed CMP d_CMP if govt_full_term==1, r(CMP 0.8 d_CMP 0.8)
eivreg d_CSES cwed d_cwed CMP d_CMP if govt_full_term==1, r(CMP 0.7 d_CMP 0.7)
eivreg d_CSES cwed d_cwed CMP d_CMP if govt_full_term==1, r(CMP 0.6 d_CMP 0.6)
eivreg d_CSES cwed d_cwed CMP d_CMP if govt_full_term==1, r(CMP 0.5 d_CMP 0.5)
* Table S11: Analyses of PartiesÕ Perceived Left-Right Shifts: Errors-In-Variables Regressions for CMP Lagged Perceived Position Model
eivreg d_CSES l_CSES cwed d_cwed CMP d_CMP if govt_full_term==1, r(CMP 0.9 d_CMP 0.9)
eivreg d_CSES l_CSES cwed d_cwed CMP d_CMP if govt_full_term==1, r(CMP 0.8 d_CMP 0.8)
eivreg d_CSES l_CSES cwed d_cwed CMP d_CMP if govt_full_term==1, r(CMP 0.7 d_CMP 0.7)
* Table S12: Jackknife Analyses of the Welfare Generosity Index (t) Effect, Omitting One Country at a Timereg d_CSES cwed d_cwed if govt_full_term==1 & cc!=1, cluster(party_n)
reg d_CSES cwed d_cwed if govt_full_term==1 & cc!=3, cluster(party_n)
reg d_CSES cwed d_cwed if govt_full_term==1 & cc!=4, cluster(party_n)
reg d_CSES cwed d_cwed if govt_full_term==1 & cc!=5, cluster(party_n)
reg d_CSES cwed d_cwed if govt_full_term==1 & cc!=6, cluster(party_n)
reg d_CSES cwed d_cwed if govt_full_term==1 & cc!=7, cluster(party_n)
reg d_CSES cwed d_cwed if govt_full_term==1 & cc!=9, cluster(party_n)
reg d_CSES cwed d_cwed if govt_full_term==1 & cc!=10, cluster(party_n)
reg d_CSES cwed d_cwed if govt_full_term==1 & cc!=11, cluster(party_n)
reg d_CSES cwed d_cwed if govt_full_term==1 & cc!=12, cluster(party_n)
reg d_CSES cwed d_cwed if govt_full_term==1 & cc!=13, cluster(party_n)
reg d_CSES cwed d_cwed if govt_full_term==1 & cc!=14, cluster(party_n)
reg d_CSES cwed d_cwed if govt_full_term==1 & cc!=15, cluster(party_n)
reg d_CSES cwed d_cwed if govt_full_term==1 & cc!=16, cluster(party_n)
reg d_CSES cwed d_cwed if govt_full_term==1 & cc!=17, cluster(party_n)


* Table S13: Analyses of PartiesÕ Perceived Left-Right Shifts, Conflicting Signals between Welfare Generosity and Party Rhetoric * Generate dummy variable for conflicting signals between shifts in welfare generosity and shifts in the CMP gen cwed_CMP_shift = 0 if (d_cwed > 0 & d_CMP < 0) & d_CMP!=.
replace cwed_CMP_shift = 0 if (d_cwed < 0 & d_CMP > 0) & d_CMP!=.
replace cwed_CMP_shift = 1 if cwed_CMP_shift==. & d_CMP!=.
reg d_CSES cwed CMP c.d_cwed##i.cwed_CMP_shift c.d_CMP##i.cwed_CMP_shift if govt_full_term==1 , cluster(party_n)
r2_a

reg d_CSES l_CSES cwed CMP c.d_cwed##i.cwed_CMP_shift c.d_CMP##i.cwed_CMP_shift if govt_full_term==1 , cluster(party_n)
r2_a

* Postestimation test: confirms no significant difference in signals
lincom CMP + d_CMP

***** END DO FILE *****
