* Replication 'do' file for Conrad & Souva 'Regime Similarity and Rivalry'
* International Interactions

set more off


* Cross-tabs for Table 1

tab dem_mpsoc kgdonset if kgdongoing !=1 & year >= 1946, col chi
tab mil_mpsoc kgdonset if kgdongoing !=1 & year >= 1946, col chi
tab sing_mpsoc kgdonset if kgdongoing !=1 & year >= 1946, col chi
tab soc_mpsoc kgdonset if kgdongoing !=1 & year >= 1946, col chi
tab pers_mpsoc kgdonset if kgdongoing !=1 & year >= 1946, col chi
tab mon_mpsoc kgdonset if kgdongoing !=1 & year >= 1946, col chi

tab dem_mpsoc thomonset if thomongoing !=1 & year >= 1946, col chi
tab mil_mpsoc thomonset if thomongoing !=1 & year >= 1946, col chi
tab sing_mpsoc thomonset if thomongoing !=1 & year >= 1946, col chi
tab soc_mpsoc thomonset if thomongoing !=1 & year >= 1946, col chi
tab pers_mpsoc thomonset if thomongoing !=1 & year >= 1946, col chi
tab mon_mpsoc thomonset if thomongoing !=1 & year >= 1946, col chi

tab dem_mpsoc icbrivonset if icbrivongoing !=1 & year >= 1946, col chi
tab mil_mpsoc icbrivonset if icbrivongoing !=1 & year >= 1946, col chi
tab sing_mpsoc icbrivonset if icbrivongoing !=1 & year >= 1946, col chi
tab soc_mpsoc icbrivonset if icbrivongoing !=1 & year >= 1946, col chi
tab pers_mpsoc icbrivonset if icbrivongoing !=1 & year >= 1946, col chi
tab mon_mpsoc icbrivonset if icbrivongoing !=1 & year >= 1946, col chi


* List of Regime Similarity Rivals for Table 2


list statea stateb year if dem_mpsoc == 1 & kgdonset == 1 & year >= 1946 
list statea stateb year if dem_mpsoc == 1 & thomonset == 1 & year >= 1946 
list statea stateb year if dem_mpsoc == 1 & icbrivonset == 1 & year >= 1946 

list statea stateb year if sing_mpsoc == 1 & kgdonset == 1 & year >= 1946 
list statea stateb year if sing_mpsoc == 1 & thomonset == 1 & year >= 1946 
list statea stateb year if sing_mpsoc == 1 & icbrivonset == 1 & year >= 1946 

list statea stateb year if soc_mpsoc == 1 & kgdonset == 1 & year >= 1946 
list statea stateb year if soc_mpsoc == 1 & thomonset == 1 & year >= 1946 
list statea stateb year if soc_mpsoc == 1 & icbrivonset == 1 & year >= 1946 

list statea stateb year if mil_mpsoc == 1 & kgdonset == 1 & year >= 1946 
list statea stateb year if mil_mpsoc == 1 & thomonset == 1 & year >= 1946 
list statea stateb year if mil_mpsoc == 1 & icbrivonset == 1 & year >= 1946 

list statea stateb year if mon_mpsoc == 1 & kgdonset == 1 & year >= 1946 
list statea stateb year if mon_mpsoc == 1 & thomonset == 1 & year >= 1946 
list statea stateb year if mon_mpsoc == 1 & icbrivonset == 1 & year >= 1946 

list statea stateb year if pers_mpsoc == 1 & kgdonset == 1 & year >= 1946 
list statea stateb year if pers_mpsoc == 1 & thomonset == 1 & year >= 1946 
list statea stateb year if pers_mpsoc == 1 & icbrivonset == 1 & year >= 1946 


* Table 3

* KGD Rivals

* Model 1

* What is the influence of joint democracy on rivalry onset going back to 1816? 
logit kgdonset jntd5 dp  onemajor twomajor contig150 lndistance powerrat gdpeaceyears gdspline1 gdspline2 gdspline3 if kgdongoing !=1, cluster(dyadid) nolog 

* Model 2: Regime similarity: military trumps single, Polity trumps Geddes coding
logit kgdonset mil_mp sing_mp pers_mp mon_mp dem_mp dp  onemajor twomajor contig150 lndistance powerrat gdpeaceyears gdspline1 gdspline2 gdspline3 if year >= 1946 & kgdongoing !=1, cluster(dyadid) nolog 

* Model 3: Weeks coding
logit kgdonset pers_w mil_w sing_w dynmon_w nondynmon_w interreg_w newdem_w mixednondem dem_w dp  onemajor twomajor contig150 lndistance powerrat gdpeaceyears gdspline1 gdspline2 gdspline3 if year >= 1946 & kgdongoing !=1, cluster(dyadid) nolog 

* Model 4: Is it joint democracy or joint institutional coherence (Bennett's argument)? 
logit kgdonset polity21 polity22 jpolity jpolitysq dp  onemajor twomajor contig150 lndistance powerrat gdpeaceyears gdspline1 gdspline2 gdspline3 if year >= 1946 & kgdongoing !=1, cluster(dyadid) nolog 

* Two democracies
lincom polity21*10 + polity22*10 + jpolity*100 + jpolitysq*(100*100)
* Two non-democracies
lincom polity21*-10 + polity22*-10 + jpolity*100 + jpolitysq*(100*100)
* Democracy and non-democracy
lincom polity21*10 + polity22*-10 + jpolity*-100 + jpolitysq*(-100*-100)

* Model 5:  Polity trumps Geddes coding with Socialist
logit kgdonset mil_mpsoc sing_mpsoc soc_mpsoc pers_mpsoc mon_mpsoc dem_mpsoc dp  onemajor twomajor contig150 lndistance powerrat gdpeaceyears gdspline1 gdspline2 gdspline3 if year >= 1946 & kgdongoing !=1, cluster(dyadid) nolog 


* Table 4: Thompson rivalries


* Model 6: What is the influence of joint democracy on rivalry onset going back to 1816? 
logit thomonset jntd5 dp  onemajor twomajor contig150 lndistance powerrat  tpeaceyears tspline1 tspline2 tspline3 if thomongoing !=1, cluster(dyadid) nolog

* Model 7: Regime similarity: Polity trumps Geddes coding
logit thomonset mil_mp sing_mp pers_mp mon_mp dem_mp dp  onemajor twomajor contig150 lndistance powerrat  tpeaceyears tspline1 tspline2 tspline3 if year >= 1946 & thomongoing !=1, cluster(dyadid) nolog

* Model 8: Weeks measure
logit thomonset pers_w sing_w dynmon_w interreg_w nondynmon_w mixednondem mil_w newdem_w dem_w dp  onemajor twomajor contig150 lndistance powerrat  tpeaceyears tspline1 tspline2 tspline3 if year >= 1946 & thomongoing !=1 & mixednondem !=1 & nondynmon_w != 1 & mil_w != 1 & newdem_w != 1 & dem_w !=1, cluster(dyadid) nolog

/* Some regime similarity dyads have no Thompson rivalries. 
Check to see if each regime similarity measure is associated with fewer
rivalry onsets in a cross-tabulation partitioned by contiguity. */ 

sort contig150
by contig150: tab nondynmon_w thomonset if year >= 1946 & thomongoing !=1 & pers_w !=1 & mil_w !=1 & sing_w !=1 & dynmon_w !=1 & interreg_w !=1 & newdem_w !=1 & mixednondem !=1 & dem_w !=1, exp chi
by contig150: tab mixednondem thomonset if year >= 1946 & thomongoing !=1 & pers_w !=1 & mil_w !=1 & sing_w !=1 & dynmon_w !=1 & interreg_w !=1 & newdem_w !=1 & nondynmon_w !=1 & dem_w !=1, exp chi
by contig150: tab mil_w thomonset if year >= 1946 & thomongoing !=1 & pers_w !=1 & mixednondem !=1 & sing_w !=1 & dynmon_w !=1 & interreg_w !=1 & newdem_w !=1 & nondynmon_w !=1 & dem_w !=1, exp chi
by contig150: tab sing_w thomonset if year >= 1946 & thomongoing !=1 & pers_w !=1 & mixednondem !=1 & mil_w !=1 & dynmon_w !=1 & interreg_w !=1 & newdem_w !=1 & nondynmon_w !=1 & dem_w !=1, exp chi
by contig150: tab dem_w thomonset if year >= 1946 & thomongoing !=1 & pers_w !=1 & mixednondem !=1 & sing_w !=1 & dynmon_w !=1 & interreg_w !=1 & newdem_w !=1 & nondynmon_w !=1 & mil_w !=1, exp chi

* Model 9: Institutional Coherence
logit thomonset polity21 polity22 jpolity jpolitysq dp  onemajor twomajor contig150 lndistance powerrat  tpeaceyears tspline1 tspline2 tspline3 if year >= 1946 & thomongoing !=1, cluster(dyadid) nolog

* Two democracies
lincom polity21*10 + polity22*10 + jpolity*100 + jpolitysq*(100*100)
* Two non-democracies
lincom polity21*-10 + polity22*-10 + jpolity*100 + jpolitysq*(100*100)
* Democracy and non-democracy
lincom polity21*10 + polity22*-10 + jpolity*-100 + jpolitysq*(-100*-100)

* Model 10: Polity trumps Geddes coding with Socialist
logit thomonset mil_mpsoc sing_mpsoc soc_mpsoc pers_mpsoc mon_mpsoc dem_mpsoc  dp  onemajor twomajor contig150 lndistance powerrat  tpeaceyears tspline1 tspline2 tspline3 if year >= 1946 & thomongoing !=1, cluster(dyadid) nolog


* Table 5: ICB, Proto and Enduring conflicts


* Model 11: What is the influence of joint democracy on rivalry onset going back to 1918? 
logit icbrivonset jntd5 dp  onemajor twomajor contig150 lndistance powerrat icbpyears icbspline1 icbspline2 icbspline3 if icbrivongoing !=1 & year >= 1918, cluster(dyadid) nolog 

* Model 12: Regime similarity: Polity trumps Geddes coding
logit icbrivonset mil_mp sing_mp pers_mp mon_mp dem_mp dp  onemajor twomajor contig150 lndistance powerrat icbpyears icbspline1 icbspline2 icbspline3 if year >= 1946 & icbrivongoing !=1, cluster(dyadid) nolog 

sort contig150
by contig150: tab mil_mp icbrivonset if year >= 1946 & icbrivongoing !=1 & pers_mp !=1 & sing_mp !=1 & mon_mp !=1 & dem_mp !=1, exp chi
by contig150: tab sing_mp icbrivonset if year >= 1946 & icbrivongoing !=1 & pers_mp !=1 & mil_mp !=1 & mon_mp !=1 & dem_mp !=1, exp chi
by contig150: tab pers_mp icbrivonset if year >= 1946 & icbrivongoing !=1 & mil_mp !=1 & sing_mp !=1 & mon_mp !=1 & dem_mp !=1, exp chi
by contig150: tab mon_mp icbrivonset if year >= 1946 & icbrivongoing !=1 & pers_mp !=1 & sing_mp !=1 & mil_mp !=1 & dem_mp !=1, exp chi
by contig150: tab dem_mp icbrivonset if year >= 1946 & icbrivongoing !=1 & pers_mp !=1 & sing_mp !=1 & mon_mp !=1 & mil_mp !=1, exp chi

tab mil_mp icbrivonset if year >= 1946 & icbrivongoing !=1 & pers_mp !=1 & sing_mp !=1 & mon_mp !=1 & dem_mp !=1, exp chi
tab sing_mp icbrivonset if year >= 1946 & icbrivongoing !=1 & pers_mp !=1 & mil_mp !=1 & mon_mp !=1 & dem_mp !=1, exp chi
tab pers_mp icbrivonset if year >= 1946 & icbrivongoing !=1 & mil_mp !=1 & sing_mp !=1 & mon_mp !=1 & dem_mp !=1, exp chi
tab mon_mp icbrivonset if year >= 1946 & icbrivongoing !=1 & pers_mp !=1 & sing_mp !=1 & mil_mp !=1 & dem_mp !=1, exp chi
tab dem_mp icbrivonset if year >= 1946 & icbrivongoing !=1 & pers_mp !=1 & sing_mp !=1 & mon_mp !=1 & mil_mp !=1, exp chi

* Model 13: Weeks coding
logit icbrivonset pers_w mil_w sing_w dynmon_w nondynmon_w interreg_w newdem_w mixednondem dem_w dp  onemajor twomajor contig150 lndistance powerrat icbpyears icbspline1 icbspline2 icbspline3 if year >= 1946 & icbrivongoing !=1, cluster(dyadid) nolog 

sort contig150
by contig150: tab nondynmon_w icbrivonset if year >= 1946 & icbrivongoing !=1 & pers_w !=1 & mil_w !=1 & sing_w !=1 & dynmon_w !=1 & interreg_w !=1 & newdem_w !=1 & mixednondem !=1 & dem_w !=1, exp chi
by contig150: tab mixednondem icbrivonset if year >= 1946 & icbrivongoing !=1 & pers_w !=1 & mil_w !=1 & sing_w !=1 & dynmon_w !=1 & interreg_w !=1 & newdem_w !=1 & nondynmon_w !=1 & dem_w !=1, exp chi
by contig150: tab mil_w icbrivonset if year >= 1946 & icbrivongoing !=1 & pers_w !=1 & mixednondem !=1 & sing_w !=1 & dynmon_w !=1 & interreg_w !=1 & newdem_w !=1 & nondynmon_w !=1 & dem_w !=1, exp chi
by contig150: tab sing_w icbrivonset if year >= 1946 & icbrivongoing !=1 & pers_w !=1 & mixednondem !=1 & mil_w !=1 & dynmon_w !=1 & interreg_w !=1 & newdem_w !=1 & nondynmon_w !=1 & dem_w !=1, exp chi
by contig150: tab dem_w icbrivonset if year >= 1946 & icbrivongoing !=1 & pers_w !=1 & mixednondem !=1 & sing_w !=1 & dynmon_w !=1 & interreg_w !=1 & newdem_w !=1 & nondynmon_w !=1 & mil_w !=1, exp chi

* Model 14: Is it joint democracy or joint institutional coherence (Bennett's argument)? 
logit icbrivonset polity21 polity22 jpolity jpolitysq dp  onemajor twomajor contig150 lndistance powerrat icbpyears icbspline1 icbspline2 icbspline3 if year >= 1946 & icbrivongoing !=1, cluster(dyadid) nolog 

* Two democracies
lincom polity21*10 + polity22*10 + jpolity*100 + jpolitysq*(100*100)
* Two non-democracies
lincom polity21*-10 + polity22*-10 + jpolity*100 + jpolitysq*(100*100)
* Democracy and non-democracy
lincom polity21*10 + polity22*-10 + jpolity*-100 + jpolitysq*(-100*-100)

* Model 15: Polity trumps Geddes coding with Socialist
logit icbrivonset mil_mpsoc sing_mpsoc soc_mpsoc pers_mpsoc mon_mpsoc dem_mpsoc dp  onemajor twomajor contig150 lndistance powerrat icbpyears icbspline1 icbspline2 icbspline3 if year >= 1946 & icbrivongoing !=1, cluster(dyadid) nolog 

tab mil_mpsoc icbrivonset if year >= 1946 & icbrivongoing !=1 & soc_mpsoc !=1 & pers_mpsoc !=1 & sing_mpsoc !=1 & mon_mpsoc !=1 & dem_mpsoc !=1, exp chi
tab sing_mpsoc icbrivonset if year >= 1946 & icbrivongoing !=1 & soc_mpsoc !=1 & pers_mpsoc !=1 & mil_mpsoc !=1 & mon_mpsoc !=1 & dem_mpsoc !=1, exp chi
tab soc_mpsoc icbrivonset if year >= 1946 & icbrivongoing !=1 & mil_mpsoc !=1 & pers_mpsoc !=1 & sing_mpsoc !=1 & mon_mpsoc !=1 & dem_mpsoc !=1, exp chi
tab pers_mpsoc icbrivonset if year >= 1946 & icbrivongoing !=1 & soc_mpsoc !=1 & mil_mpsoc !=1 & sing_mpsoc !=1 & mon_mpsoc !=1 & dem_mpsoc !=1, exp chi
tab mon_mpsoc icbrivonset if year >= 1946 & icbrivongoing !=1 & soc_mpsoc !=1 & pers_mpsoc !=1 & sing_mpsoc !=1 & mil_mpsoc !=1 & dem_mpsoc !=1, exp chi
tab dem_mpsoc icbrivonset if year >= 1946 & icbrivongoing !=1 & soc_mpsoc !=1 & pers_mpsoc !=1 & sing_mpsoc !=1 & mon_mpsoc !=1 & mil_mpsoc !=1, exp chi



* KGD Rivalries: Sensitivity Analyses


* CG trumps Geddes coding
logit kgdonset mil_mcg sing_mcg pers_mcg mon_mcg dem_mcg dp  onemajor twomajor contig150 lndistance powerrat gdpeaceyears gdspline1 gdspline2 gdspline3 if year >= 1946 & kgdongoing !=1, cluster(dyadid) nolog 

* Geddes trumps Polity coding
logit kgdonset mil_mg sing_mg pers_mg mon_mg dem_mg dp  onemajor twomajor contig150 lndistance powerrat gdpeaceyears gdspline1 gdspline2 gdspline3 if year >= 1946 & kgdongoing !=1, cluster(dyadid) nolog 

* Thompson rivalries

* CG trumps Geddes coding
logit thomonset mil_mcg sing_mcg pers_mcg mon_mcg dem_mcg dp  onemajor twomajor contig150 lndistance powerrat  tpeaceyears tspline1 tspline2 tspline3 if year >= 1946 & thomongoing !=1, cluster(dyadid) nolog

* Geddes trumps Polity coding
logit thomonset mil_mg sing_mg pers_mg mon_mg dem_mg dp  onemajor twomajor contig150 lndistance powerrat  tpeaceyears tspline1 tspline2 tspline3 if year >= 1946 & thomongoing !=1, cluster(dyadid) nolog

* ICB rivalries

logit icbrivonset mil_mcg sing_mcg pers_mcg mon_mcg dem_mcg dp  onemajor twomajor contig150 lndistance powerrat icbpyears icbspline1 icbspline2 icbspline3 if year >= 1918 & icbrivongoing !=1, cluster(dyadid) nolog 

logit icbrivonset mil_mg sing_mg pers_mg mon_mg dem_mg dp  onemajor twomajor contig150 lndistance powerrat icbpyears icbspline1 icbspline2 icbspline3 if year >= 1918 & icbrivongoing !=1, cluster(dyadid) nolog 


* Footnote 24: Alternative operationalization for institutional coherence argument: dummy variable version 

logit kgdonset jntd5 jnta5 onedemxoneaut oneautxoneanoc onedemxoneanoc jntanoc dp  onemajor twomajor contig150 lndistance powerrat gdpeaceyears gdspline1 gdspline2 gdspline3 if year >= 1946 & kgdongoing !=1, cluster(dyadid) nolog
logit thomonset jntd5 jnta5 onedemxoneaut oneautxoneanoc onedemxoneanoc jntanoc dp  onemajor twomajor contig150 lndistance powerrat tpeaceyears tspline1 tspline2 tspline3 if year >= 1946 & thomongoing !=1, cluster(dyadid) nolog
logit icbrivonset jntd5 jnta5 onedemxoneaut oneautxoneanoc onedemxoneanoc jntanoc dp  onemajor twomajor contig150 lndistance powerrat icbpyears icbspline1 icbspline2 icbspline3 if year >= 1946 & icbrivongoing !=1, cluster(dyadid) nolog


*****************
* Predicted 	*
* Probabilities *
* KGD Data		*
*****************


* Change in predicted probability for each joint regime variable - KGD DATA


estsimp logit kgdonset mil_mpsoc sing_mpsoc soc_mpsoc pers_mpsoc mon_mpsoc dem_mpsoc dp  onemajor twomajor contig150 lndistance powerrat gdpeaceyears gdspline1 gdspline2 gdspline3 if year >= 1946 & kgdongoing !=1, cluster(dyadid) nolog 

* Baseling probability is for mixed dyads, i.e. all joint regime dyads equal 0

setx mil_mpsoc 0 sing_mpsoc 0 soc_mpsoc 0 pers_mpsoc 0 mon_mpsoc 0 dem_mpsoc 0 twomajor 0 onemajor 1 (dp contig150) median  (lndistance powerrat gdpeaceyears gdspline1 gdspline2 gdspline3) mean

simqi
simqi, genpr(baseprobx)

gen baseprob = 1 - baseprobx 


* Scenario 1: change mil_mg from 0 to 1

setx mil_mpsoc 1 sing_mpsoc 0 soc_mpsoc 0 pers_mpsoc 0 mon_mpsoc 0 dem_mpsoc 0  twomajor 0 onemajor 1 (dp contig150) median  (lndistance powerrat gdpeaceyears gdspline1 gdspline2 gdspline3) mean

simqi
simqi, genpr(scenario1)

gen scenario11 = 1 - scenario1

gen percent_change = ((scenario11 - baseprob)*100)/baseprob

sum percent_change

drop percent_change scenario1 scenario11


* Scenario 2: change sing_mg from 0 to 1

setx mil_mpsoc 0 sing_mpsoc 1 soc_mpsoc 0 pers_mpsoc 0 mon_mpsoc 0 dem_mpsoc 0 twomajor 0 onemajor 1 (dp contig150) median (lndistance powerrat gdpeaceyears gdspline1 gdspline2 gdspline3) mean

simqi
simqi, genpr(scenario2)

gen scenario22 = 1 - scenario2

gen percent_change = ((scenario22 - baseprob)*100)/baseprob

sum percent_change

drop percent_change scenario2 scenario22


* Scenario 3: change pers_mg from 0 to 1

setx mil_mpsoc 0 sing_mpsoc 0 soc_mpsoc 0 pers_mpsoc 1 mon_mpsoc 0 dem_mpsoc 0 twomajor 0 onemajor 1 (dp contig150) median  (lndistance powerrat gdpeaceyears gdspline1 gdspline2 gdspline3) mean

simqi
simqi, genpr(scenario3)

gen scenario33 = 1 - scenario3

gen percent_change = ((scenario33 - baseprob)*100)/baseprob

sum percent_change

drop percent_change scenario3 scenario33


* Scenario 4: change mon_mg from 0 to 1

setx mil_mpsoc 0 sing_mpsoc 0 soc_mpsoc 0 pers_mpsoc 0 mon_mpsoc 1 dem_mpsoc 0 twomajor 0 onemajor 1 (dp contig150) median  (lndistance powerrat gdpeaceyears gdspline1 gdspline2 gdspline3) mean

simqi
simqi, genpr(scenario4)

gen scenario44 = 1 - scenario4

gen percent_change = ((scenario44 - baseprob)*100)/baseprob

sum percent_change

drop percent_change scenario4 scenario44


* Scenario 5: change dem_mg from 0 to 1

setx mil_mpsoc 0 sing_mpsoc 0 soc_mpsoc 0 pers_mpsoc 0 mon_mpsoc 0 dem_mpsoc 1 twomajor 0 onemajor 1 (dp contig150) median  (lndistance powerrat gdpeaceyears gdspline1 gdspline2 gdspline3) mean

simqi
simqi, genpr(scenario5)

gen scenario55 = 1 - scenario5

gen percent_change = ((scenario55 - baseprob)*100)/baseprob

sum percent_change

drop percent_change scenario5 scenario55


* Scenario 6: change soc_mg from 0 to 1

setx mil_mpsoc 0 sing_mpsoc 0 soc_mpsoc 1 pers_mpsoc 0 mon_mpsoc 0 dem_mpsoc 0 twomajor 0 onemajor 1 (dp contig150) median  (lndistance powerrat gdpeaceyears gdspline1 gdspline2 gdspline3) mean

simqi
simqi, genpr(scenario6)

gen scenario666 = 1 - scenario6

gen percent_change = ((scenario666 - baseprob)*100)/baseprob

sum percent_change

drop percent_change scenario6 scenario666


* Scenario: change contiguity from 0 to 1 

setx mil_mpsoc 0 sing_mpsoc 0 soc_mpsoc 0 pers_mpsoc 0 mon_mpsoc 0 dem_mpsoc 0 twomajor 0 onemajor 1 dp median contig150 1  (lndistance powerrat gdpeaceyears gdspline1 gdspline2 gdspline3) mean

simqi
simqi, genpr(contprob)

gen cont11 = 1 - contprob

gen percent_change = ((cont11 - baseprob)*100)/baseprob

sum percent_change

drop contprob cont11 percent_change


* Scenario: change onemajor to 0 and twomajor to 1

setx mil_mpsoc 0 sing_mpsoc 0 soc_mpsoc 0 pers_mpsoc 0 mon_mpsoc 0 dem_mpsoc 0 twomajor 1 onemajor 0 dp median contig150 median  (lndistance powerrat gdpeaceyears gdspline1 gdspline2 gdspline3) mean

simqi
simqi, genpr(twomajprob)

gen twomaj11 = 1 - twomajprob

gen percent_change = ((twomaj11 - baseprob)*100)/baseprob

sum percent_change

drop twomajprob twomaj11 percent_change


drop b*



*****************
* Predicted 	*
* Probabilities *
* Thompson Data	*
*****************


* Model 7 change in predicted probability for each joint regime variable - THOMPSON DATA


estsimp logit thomonset mil_mpsoc sing_mpsoc soc_mpsoc pers_mpsoc mon_mpsoc dem_mpsoc  dp  onemajor twomajor contig150 lndistance powerrat  tpeaceyears tspline1 tspline2 tspline3 if year >= 1946 & thomongoing !=1, cluster(dyadid) nolog

* Baseling probability is for mixed dyads, i.e. all joint regime dyads equal 0

setx mil_mpsoc 0 sing_mpsoc 0 soc_mpsoc 0 pers_mpsoc 0 mon_mpsoc 0 dem_mpsoc 0 twomajor 0 onemajor 1 (dp contig150) median  (lndistance powerrat tpeaceyears tspline1 tspline2 tspline3) mean

simqi
simqi, genpr(baseprobx)

gen baseprob = 1 - baseprobx 


* Scenario 1: change mil_mg from 0 to 1

setx mil_mpsoc 1 sing_mpsoc 0 soc_mpsoc 0 pers_mpsoc 0 mon_mpsoc 0 dem_mpsoc 0 twomajor 0 onemajor 1 (dp contig150) median  (lndistance powerrat tpeaceyears tspline1 tspline2 tspline3) mean

simqi
simqi, genpr(scenario1)

gen scenario11 = 1 - scenario1

gen percent_change = ((scenario11 - baseprob)*100)/baseprob

sum percent_change

drop percent_change scenario1 scenario11


* Scenario 2: change sing_mg from 0 to 1

setx mil_mpsoc 0 sing_mpsoc 1 soc_mpsoc 0 pers_mpsoc 0 mon_mpsoc 0 dem_mpsoc 0 twomajor 0 onemajor 1 (dp contig150) median  (lndistance powerrat tpeaceyears tspline1 tspline2 tspline3) mean

simqi
simqi, genpr(scenario2)

gen scenario22 = 1 - scenario2

gen percent_change = ((scenario22 - baseprob)*100)/baseprob

sum percent_change

drop percent_change scenario2 scenario22


* Scenario 3: change pers_mg from 0 to 1

setx mil_mpsoc 0 sing_mpsoc 0 soc_mpsoc 0 pers_mpsoc 1 mon_mpsoc 0 dem_mpsoc 0 twomajor 0 onemajor 1 (dp contig150) median  (lndistance powerrat tpeaceyears tspline1 tspline2 tspline3) mean

simqi
simqi, genpr(scenario3)

gen scenario33 = 1 - scenario3

gen percent_change = ((scenario33 - baseprob)*100)/baseprob

sum percent_change

drop percent_change scenario3 scenario33


* Scenario 4: change mon_mg from 0 to 1

setx mil_mpsoc 0 sing_mpsoc 0 soc_mpsoc 0 pers_mpsoc 0 mon_mpsoc 1 dem_mpsoc 0 twomajor 0 onemajor 1 (dp contig150) median  (lndistance powerrat tpeaceyears tspline1 tspline2 tspline3) mean

simqi
simqi, genpr(scenario4)

gen scenario44 = 1 - scenario4

gen percent_change = ((scenario44 - baseprob)*100)/baseprob

sum percent_change

drop percent_change scenario4 scenario44


* Scenario 5: change dem_mg from 0 to 1

setx mil_mpsoc 0 sing_mpsoc 0 soc_mpsoc 0 pers_mpsoc 0 mon_mpsoc 0 dem_mpsoc 1 twomajor 0 onemajor 1 (dp contig150) median  (lndistance powerrat tpeaceyears tspline1 tspline2 tspline3) mean

simqi
simqi, genpr(scenario5)

gen scenario55 = 1 - scenario5

gen percent_change = ((scenario55 - baseprob)*100)/baseprob

sum percent_change

drop percent_change scenario5 scenario55


* Scenario 6: change soc_mg from 0 to 1

setx mil_mpsoc 0 sing_mpsoc 0 soc_mpsoc 1 pers_mpsoc 0 mon_mpsoc 0 dem_mpsoc 0 twomajor 0 onemajor 1 (dp contig150) median  (lndistance powerrat tpeaceyears tspline1 tspline2 tspline3) mean

simqi
simqi, genpr(scenario6)

gen scenario666 = 1 - scenario6

gen percent_change = ((scenario666 - baseprob)*100)/baseprob

sum percent_change

drop percent_change scenario6 scenario666

* Scenario: change contiguity from 0 to 1

setx mil_mpsoc 0 sing_mpsoc 0 soc_mpsoc 0 pers_mpsoc 0 mon_mpsoc 0 dem_mpsoc 0 twomajor 0 onemajor 1 dp median contig150 1  (lndistance powerrat tpeaceyears tspline1 tspline2 tspline3) mean
simqi
simqi, genpr(contprob)

gen cont11 = 1 - contprob

gen percent_change = ((cont11 - baseprob)*100)/baseprob

sum percent_change

drop contprob cont11 percent_change

* Scenario: change one major to 0 and two major to 1

setx mil_mpsoc 0 sing_mpsoc 0 soc_mpsoc 0 pers_mpsoc 0 mon_mpsoc 0 dem_mpsoc 0 twomajor 1 onemajor 0 dp median contig150 median  (lndistance powerrat tpeaceyears tspline1 tspline2 tspline3) mean

simqi
simqi, genpr(twomajprob)

gen twomaj11 = 1 - twomajprob

gen percent_change = ((twomaj11 - baseprob)*100)/baseprob

sum percent_change

drop twomajprob twomaj11 percent_change


drop b*


*****************
* Predicted 	*
* Probabilities *
* ICB Data		*
*****************


* Model 12 change in predicted probability for each joint regime variable - ICB DATA


* Note, the abbreviated model is because the other regime variables do not vary. 

estsimp logit icbrivonset soc_mpsoc dem_mpsoc dp  onemajor twomajor contig150 lndistance powerrat icbpyears icbspline1 icbspline2 icbspline3 if year >= 1946 & icbrivongoing !=1, cluster(dyadid) nolog 

* Baseling probability is for mixed dyads, i.e. all joint regime dyads equal 0

setx soc_mpsoc 0 dem_mpsoc 0 twomajor 0 onemajor 1 (dp contig150) median  (lndistance powerrat icbpyears icbspline1 icbspline2 icbspline3) mean

simqi
simqi, genpr(baseprobx)

gen baseprob = 1 - baseprobx 


* Scenario 1: change dem_mg from 0 to 1

setx soc_mpsoc 0 dem_mpsoc 1 twomajor 0 onemajor 1 (dp contig150) median  (lndistance powerrat icbpyears icbspline1 icbspline2 icbspline3) mean

simqi
simqi, genpr(scenario5)

gen scenario55 = 1 - scenario5

gen percent_change = ((scenario55 - baseprob)*100)/baseprob

sum percent_change

drop percent_change scenario5 scenario55


* Scenario 6: change soc_mg from 0 to 1

setx soc_mpsoc 1 dem_mpsoc 0  twomajor 0 onemajor 1 (dp contig150) median  (lndistance powerrat icbpyears icbspline1 icbspline2 icbspline3) mean

simqi
simqi, genpr(scenario6)

gen scenario666 = 1 - scenario6

gen percent_change = ((scenario666 - baseprob)*100)/baseprob

sum percent_change

drop percent_change scenario6 scenario666

* Scenario: change contiguity from 0 to 1

setx soc_mpsoc 0 dem_mpsoc 0 twomajor 0 onemajor 1 dp median contig150 1  (lndistance powerrat icbpyears icbspline1 icbspline2 icbspline3) mean
simqi
simqi, genpr(contprob)

gen cont11 = 1 - contprob

gen percent_change = ((cont11 - baseprob)*100)/baseprob

sum percent_change

drop contprob cont11 percent_change

* Scenario: change one major to 0 and two major to 1

setx soc_mpsoc 0 dem_mpsoc 0 twomajor 1 onemajor 0 dp median contig150 median  (lndistance powerrat icbpyears icbspline1 icbspline2 icbspline3) mean

simqi
simqi, genpr(twomajprob)

gen twomaj11 = 1 - twomajprob

gen percent_change = ((twomaj11 - baseprob)*100)/baseprob

sum percent_change

drop twomajprob twomaj11 percent_change


******************************************************************************
* Exploring differences in the control variables across the rivalry datasets *
* Table 8                                                                    * 
******************************************************************************


tab contig150 kgdonset if kgdongoing !=1 & year >= 1946, col chi
tab contig150 thomonset if thomongoing !=1 & year >= 1946, col chi
tab contig150  icbrivonset if  icbrivongoing !=1 & year >= 1946, col chi

tab onemajor kgdonset if kgdongoing !=1 & year >= 1946, col chi
tab onemajor thomonset if thomongoing !=1 & year >= 1946, col chi
tab onemajor  icbrivonset if  icbrivongoing !=1 & year >= 1946, col chi

tab mzmid kgdrival if year >= 1946, row chi
tab mzmid thomrival if year >= 1946, row chi
tab mzmid icbrival if year >= 1946, row chi

tab war kgdrival if year >= 1946, row chi
tab war thomrival if year >= 1946, row chi
tab war icbrival if year >= 1946, row chi

* Region 1 = Europe
* Region 2 = Middle East and North Africa
* Region 3 = Africa
* Region 4 = Asia
* Region 5 = Americas

tab sameregion kgdonset if kgdongoing !=1 & year >= 1946, col chi
tab sameregion thomonset if thomongoing !=1 & year >= 1946, col chi
tab sameregion icbrivonset if icbrivongoing !=1 & year >= 1946, col chi
