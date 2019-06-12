/*
Dealing with Tyranny: International Sanctions and the
Survival of Authoritarian Rulers

Abel Escribà-Folch
Joseph Wright

Original file date: November 10, 2008
Updated: October 26, 2009

*/
capture log close

log using SanctionsSurvival2.log, replace

use  SANCTIONSFINAL, clear

***Table 1 Baseline Models***
gen time2 = leader_time^2
gen time3 = leader_time^3
gen coldwar = year<=1990
gen lpop = log(population)
tsset country year
gen loilrsanct = lsanctionx*logoilr
gen rentsanct = lsanctionx*logoilgas
tab regimetype type, m
tab regimetype alltype
tab regimetype puretype, m

xi:logit  leader_exit  logoilr i.type lsanctionx demobefo lpop regreg newc reld coldwar forwar loggdppc growthl12 leader_time time2 time3, cluster(leader_code)
est store table11 
xi:logit  leader_exit  logoilr i.type*lsanctionx demobefo lpop regreg newc reld coldwar forwar loggdppc growthl12  leader_time time2 time3, cluster(leader_code)
est store table12 
xi:logit  leader_exit  logoilr loilrsanct i.type*lsanctionx demobefo lpop regreg newc reld coldwar forwar loggdppc growthl12  leader_time time2 time3, cluster(leader_code)
est store table13
xi:logit  leader_exit  logoilr i.type*lsanctionx demobefo lpop regreg newc reld coldwar forwar loggdppc i.type*growthl12  leader_time time2 time3, cluster(leader_code)
est store table14
xi:logit  leader_exit  logoilr loilrsanct i.type*lsanctionx demobefo lpop regreg newc reld coldwar forwar loggdppc i.type*growthl12  leader_time time2 time3, cluster(leader_code)
est store table15 
xi:logit  leader_exit  logoilr loilrsanct i.type*lsanctionx demobefo lpop regreg newc reld coldwar forwar loggdppc i.type*growthl12  leader_time time2 time3 if regimetype_code~=1, cluster(leader_code)
est store table16 
xi:logit  leader_exit  logoilr loilrsanct i.alltype*lsanctionx demobefo lpop regreg newc reld coldwar forwar loggdppc i.alltype*growthl12  leader_time time2 time3, cluster(leader_code)
est store table17
xi:logit  leader_exit  logoilr loilrsanct i.type*lsanctionx demobefo lpop regreg newc reld coldwar forwar loggdppc i.type*coldwar growthl12  leader_time time2 time3, cluster(leader_code)
est store table18


*Alternative measure of oil rents and sanctions (TIES)*
xi:logit  leader_exit   logoilgas rentsanct i.type*lsanctionx demobefo lpop regreg newc reld coldwar forwar loggdppc i.type*growthl12  leader_time time2 time3, cluster(leader_code)
est store tableA1

gen ltsanction=l.tsanction
gen loilrtsanct=ltsanction*logoilr
xi:logit  leader_exit  logoilr loilrtsanct i.type*ltsanction demobefo lpop regreg newc reld coldwar forwar loggdppc i.type*growthl12  leader_time time2 time3 if year>1970, cluster(leader_code)
est store tableA2



*Alternative measure of regional democracy presence*
xi:logit  leader_exit  logoilr loilrsanct i.type*lsanctionx demobefo lpop  neighbordemocracy newc reld coldwar forwar loggdppc growthl12 leader_time time2 time3, cluster(leader_code)
est store tableA3
*Baseline Model including Civil War dummy*
xi:logit  leader_exit  logoilr loilrsanct i.type*lsanctionx demobefo lpop regreg newc reld  coldwar forwar civwar loggdppc growthl12 leader_time time2 time3, cluster(leader_code)
est store tableA4
*Use splines, not polynomials*
xi:logit  leader_exit  logoilr loilrsanct i.type*lsanctionx demobefo lpop regreg newc reld  coldwar forwar loggdppc growthl12 spli*, cluster(leader_code)
est store tableA5


***Table 2 Clarify Simulations***

xi:logit  leader_exit  logoilr i.type*lsanctionx demobefo lpop regreg newc reld forwar  coldwar loggdppc growthl12 leader_time time2 time3, cluster(leader_code)
bysort type: sum logoilr leader_time growthl12 time2 time3 if e(sample)  
estsimp logit  leader_exit  logoilr   _Itype_2 _Itype_3   lsanctionx   _ItypXlsanc_2 _ItypXlsanc_3 demobefo lpop regreg newc reld  coldwar forwar   loggdppc growthl12 leader_time time2 time3, cluster(leader_code)
setx mean
setx  _Itype_2   0 _Itype_3 0 lsanctionx  0  _ItypXlsanc_2 0   _ItypXlsanc_3  0  logoilr 1.32 leader_time 13 time2  286 time3  8842
simqi 
setx  _Itype_2   0 _Itype_3 0 lsanctionx  1  _ItypXlsanc_2 0   _ItypXlsanc_3  0  logoilr 1.32 leader_time 13 time2  286 time3  8842
simqi
setx mean
setx  _Itype_2   1 _Itype_3 0 lsanctionx  0  _ItypXlsanc_2 0   _ItypXlsanc_3 0 logoilr .64 leader_time 11  time2  207 time3  4984
simqi 
setx  _Itype_2   1 _Itype_3 0 lsanctionx  1  _ItypXlsanc_2 1   _ItypXlsanc_3 0 logoilr .64 leader_time 11  time2  207 time3  4984
simqi
setx mean
setx  _Itype_2   0 _Itype_3 1 lsanctionx  0  _ItypXlsanc_2 0   _ItypXlsanc_3 0 logoilr .39  leader_time 5  time2  47 time3  652
simqi 
setx  _Itype_2   0 _Itype_3 1 lsanctionx  1  _ItypXlsanc_2 0   _ItypXlsanc_3 1 logoilr .39  leader_time 5  time2  47 time3  652
simqi


setx mean
setx  _Itype_2   0 _Itype_3 0 lsanctionx  0  _ItypXlsanc_2 0   _ItypXlsanc_3  0  logoilr 1.32 leader_time 13 time2  286 time3  8842
 simqi, fd(prval (1))  changex(lsanctionx 0 1) level(90)
setx mean
setx  _Itype_2   1 _Itype_3 0 lsanctionx  0  _ItypXlsanc_2 0   _ItypXlsanc_3 0 logoilr .64 leader_time 11  time2  207 time3  4984
 simqi, fd(prval (1))  changex(lsanctionx 0 1 _ItypXlsanc_2 0 1) level(90)
setx mean
setx  _Itype_2   0 _Itype_3 1 lsanctionx  0  _ItypXlsanc_2 0   _ItypXlsanc_3 0 logoilr .39   leader_time 5  time2  47 time3  652
 simqi, fd(prval (1)) changex(lsanctionx 0 1 _ItypXlsanc_3 0 1) level(90)
drop b*



xi:logit  leader_exit  logoilr loilrsanct i.type*lsanctionx demobefo lpop regreg newc reld forwar  coldwar loggdppc i.type*growthl12 leader_time time2 time3, cluster(leader_code)
bysort type: sum logoilr leader_time time2 time3 if e(sample)  
estsimp logit  leader_exit  logoilr  loilrsanct  _Itype_2 _Itype_3   lsanctionx   _ItypXlsanc_2 _ItypXlsanc_3 demobefo lpop regreg newc reld  coldwar forwar   loggdppc growthl12 _ItypXgrowt_2 _ItypXgrowt_3 leader_time time2 time3, cluster(leader_code)
setx mean
setx  _Itype_2   0 _Itype_3 0 lsanctionx  0  _ItypXlsanc_2 0   _ItypXlsanc_3  0 growthl12 0.0087 _ItypXgrowt_2 0 _ItypXgrowt_3 0 logoilr 1.32 loilrsanct 0 leader_time 13 time2  286 time3  8842
simqi 
setx  _Itype_2   0 _Itype_3 0 lsanctionx  1  _ItypXlsanc_2 0   _ItypXlsanc_3  0 growthl12 0.0087  _ItypXgrowt_2 0 _ItypXgrowt_3 0 logoilr 1.32 loilrsanct 1.32 leader_time 13 time2  286 time3  8842
simqi
setx mean
setx  _Itype_2   1 _Itype_3 0 lsanctionx  0  _ItypXlsanc_2 0   _ItypXlsanc_3 0 growthl12 0.017 _ItypXgrowt_2 0.017 _ItypXgrowt_3 0 logoilr .64 loilrsanct 0 leader_time 11  time2  207 time3  4984
simqi 
setx  _Itype_2   1 _Itype_3 0 lsanctionx  1  _ItypXlsanc_2 1   _ItypXlsanc_3 0 growthl12 0.017 _ItypXgrowt_2 0.017 _ItypXgrowt_3 0 logoilr .64 loilrsanct .64 leader_time 11  time2  207 time3  4984
simqi
setx mean
setx  _Itype_2   0 _Itype_3 1 lsanctionx  0  _ItypXlsanc_2 0   _ItypXlsanc_3 0 growthl12 0.018 _ItypXgrowt_2 0 _ItypXgrowt_3 0.018 logoilr .39 loilrsanct 0 leader_time 5  time2  47 time3  652
simqi 
setx  _Itype_2   0 _Itype_3 1 lsanctionx  1  _ItypXlsanc_2 0   _ItypXlsanc_3 1 growthl12 0.018 _ItypXgrowt_2 0 _ItypXgrowt_3 0.018 logoilr .39 loilrsanct .39 leader_time 5  time2  47 time3  652
simqi


setx mean
setx  _Itype_2   0 _Itype_3 0 lsanctionx  0  _ItypXlsanc_2 0   _ItypXlsanc_3  0  logoilr 1.32 leader_time 13 time2  286 time3  8842
 simqi, fd(prval (1))  changex(lsanctionx 0 1 loilrsanct 0 1.32) level(90)
setx mean
setx  _Itype_2   1 _Itype_3 0 lsanctionx  0  _ItypXlsanc_2 0   _ItypXlsanc_3 0 logoilr .64 leader_time 11  time2  207 time3  4984
 simqi, fd(prval (1))  changex(lsanctionx 0 1 _ItypXlsanc_2 0 1 loilrsanct 0 0.64) level(90)
setx mean
setx  _Itype_2   0 _Itype_3 1 lsanctionx  0  _ItypXlsanc_2 0   _ItypXlsanc_3 0 logoilr .39   leader_time 5  time2  47 time3  652
 simqi, fd(prval (1)) changex(lsanctionx 0 1 _ItypXlsanc_3 0 1 loilrsanct 0 .39) level(90)
drop b*
 

xi:logit  leader_exit  logoilr loilrsanct i.type*lsanctionx demobefo lpop regreg newc reld i.type*coldwar forwar   loggdppc growthl12 leader_time time2 time3, cluster(leader_code)
bysort type: sum logoilr leader_time time2 time3 if e(sample)  
estsimp logit  leader_exit  logoilr  loilrsanct   _Itype_2 _Itype_3   lsanctionx    _ItypXlsanc_2 _ItypXlsanc_3 demobefo lpop regreg newc reld   _ItypXcoldw_2 _ItypXcoldw_3 coldwar forwar   loggdppc growthl12 leader_time time2 time3, cluster(leader_code)
setx mean
setx  _Itype_2   0 _Itype_3 0 lsanctionx  0  _ItypXlsanc_2 0   _ItypXlsanc_3  0  _ItypXcoldw_2 0  _ItypXcoldw_3 0  logoilr 1.32 loilrsanct 0 leader_time 13 time2  286 time3  8842
simqi 
setx  _Itype_2   0 _Itype_3 0 lsanctionx  1  _ItypXlsanc_2 0   _ItypXlsanc_3  0  _ItypXcoldw_2 0  _ItypXcoldw_3 0  logoilr 1.32 loilrsanct 1.32 leader_time 13 time2  286 time3  8842
simqi
setx mean
setx  _Itype_2   1 _Itype_3 0 lsanctionx  0  _ItypXlsanc_2 0   _ItypXlsanc_3 0 _ItypXcoldw_3  0 logoilr .64 loilrsanct 0 leader_time 11  time2  207 time3  4984
simqi 
setx  _Itype_2   1 _Itype_3 0 lsanctionx  1  _ItypXlsanc_2 1   _ItypXlsanc_3 0 _ItypXcoldw_3  0 logoilr .64 loilrsanct .64 leader_time 11  time2  207 time3  4984
simqi
setx mean
setx  _Itype_2   0 _Itype_3 1 lsanctionx  0  _ItypXlsanc_2 0   _ItypXlsanc_3 0 _ItypXcoldw_2  0 logoilr .39 loilrsanct 0  leader_time 5  time2  47 time3  652
simqi 
setx  _Itype_2   0 _Itype_3 1 lsanctionx  1  _ItypXlsanc_2 0   _ItypXlsanc_3 1 _ItypXcoldw_2  0 logoilr .39  loilrsanct .39 leader_time 5  time2  47 time3  652
simqi
 

setx mean
setx  _Itype_2   0 _Itype_3 0 lsanctionx  0  _ItypXlsanc_2 0   _ItypXlsanc_3  0  _ItypXcoldw_2 0  _ItypXcoldw_3 0  logoilr 1.33 leader_time 13 time2  289 time3  8935
 simqi, fd(prval (1))  changex(lsanctionx 0 1 loilrsanct 0 1.32) level(90)
setx mean
setx  _Itype_2   1 _Itype_3 0 lsanctionx  0  _ItypXlsanc_2 0   _ItypXlsanc_3 0 _ItypXcoldw_3  0 logoilr .64 leader_time 11  time2  208 time3  5019
 simqi, fd(prval (1))  changex(lsanctionx 0 1 _ItypXlsanc_2 0 1 loilrsanct 0 .64) level(90)
setx mean
setx  _Itype_2   0 _Itype_3 1 lsanctionx  0  _ItypXlsanc_2 0   _ItypXlsanc_3 0 _ItypXcoldw_2  0 logoilr .38  leader_time 5  time2  48 time3  684
 simqi, fd(prval (1)) changex(lsanctionx 0 1 _ItypXlsanc_3 0 1 loilrsanct 0 .39) level(90)
drop b*



***Table 3 Cox Model and Fixed-effects and Aid & Trade controls ***

stset leader_time, failure(leader_exit)

xi: stcox logoilr  loilrsanct i.type*lsanctionx demobefo lpop regreg newc reld  coldwar forwar loggdppc i.type*growthl12 , nohr  cluster(leader_name)  sca(ssc*) sch(sc*)
estat phtest, detail log
drop sc* ssc*

gen logsqtime = log(sqrt(leader_time))
twoway scatter logsqtime leader_time
gen ltime_gdp = loggdppc *logsqtime
gen ltime_demobefo = demobefo *logsqtime
gen ltime_oil = logoilr *logsqtime
gen ltime_oilsanct = loilrsanct *logsqtime
gen ltime_reld = reld*logsqtime
gen ltime_for = for*logsqtime
gen ltime_milsanct=   _Itype_3*lsanctionx*logsqtime


xi: stcox logoilr loilrsanct i.type*lsanctionx demobefo lpop regreg newc reld coldwar forwar loggdppc i.type*growthl12  ltime_gdp ltime_demobefo ltime_oil ltime_oilsanct ltime_reld ltime_for ltime_mils,  nohr  cluster(leader_name)   
xi: stcox logoilr loilrsanct i.type*lsanctionx demobefo lpop regreg newc reld coldwar forwar loggdppc i.type*growthl12  ltime_gdp ltime_demobefo ltime_oil ltime_oilsanct ,  nohr  cluster(leader_name)   
est store table31

xi: stcox logoilr loilrsanct i.type*lsanctionx demobefo lpop regreg newc reld coldwar forwar loggdppc i.type*growthl12  ltime_gdp ltime_demobefo ltime_oil ltime_oilsanct ,  nohr  cluster(leader_name)   
stcurve,  hazard at1(lsanctionx=1,   _ItypXlsanc_2=0,   _ItypXlsanc_3=0,  _Itype_2=0,  _Itype_3=0, _ItypXgrowt_3=0, _ItypXgrowt_2=0) at2(lsanctionx=0,  _Itype_2=0,  _Itype_3=0,    _ItypXlsanc_2=0,   _ItypXlsanc_3=0, _ItypXgrowt_3=0, _ItypXgrowt_2=0,  loilrsanct=0) range(0 20) legend(label(1 "Sanction") lab(2 "No Sanction")) yscale(range(0 0.8))  title("Personalist") xtitle("Leader Duration (Years)") width(4)
graph export "C:\files\AID data\Sanctions Survival\CoxPer.ps", as(ps) replace 
graph export "C:\files\AID data\Sanctions Survival\CoxPer.eps", as(eps) replace 

stcurve,  hazard at1(lsanctionx=1,   _ItypXlsanc_2=1,   _ItypXlsanc_3=0,  _Itype_2=1,  _Itype_3=0, _ItypXgrowt_3=0, _ItypXgrowt_2=1) at2(lsanctionx=0,  _Itype_2=1,  _Itype_3=0,    _ItypXlsanc_2=1,   _ItypXlsanc_3=0,   _ItypXgrowt_3=0, _ItypXgrowt_2=1,  loilrsanct=0) range(0 20) legend(label(1 "Sanction") lab(2 "No Sanction")) yscale(range(0 0.8))  title("Party") xtitle("Leader Duration (Years)") width(4)
graph export "C:\files\AID data\Sanctions Survival\CoxSP.ps", as(ps) replace 
graph export "C:\files\AID data\Sanctions Survival\CoxSP.eps", as(eps) replace 

stcurve,  hazard at1(lsanctionx=1,   _ItypXlsanc_2=0,   _ItypXlsanc_3=1,  _Itype_2=0,  _Itype_3=1, _ItypXgrowt_3=1, _ItypXgrowt_2=0) at2(lsanctionx=0,  _Itype_2=0,  _Itype_3=1,    _ItypXlsanc_2=0,   _ItypXlsanc_3=0,   _ItypXgrowt_3=1, _ItypXgrowt_2=0,  loilrsanct=0) range(0 20) legend(label(1 "Sanction") lab(2 "No Sanction")) yscale(range(0 0.8))  title("Military") xtitle("Leader Duration (Years)") width(4)
graph export "C:\files\AID data\Sanctions Survival\CoxMil.ps", as(ps) replace 
graph export "C:\files\AID data\Sanctions Survival\CoxMil.eps", as(eps) replace 


tsset country year
xi:xtlogit  leader_exit  logoilr loilrsanct i.type*lsanctionx lpop regreg coldwar forwar loggdppc i.type*growthl12  leader_time time2 time3, re i(country) nolog
est store re
xi:xtlogit  leader_exit  logoilr loilrsanct i.type*lsanctionx lpop regreg coldwar forwar loggdppc i.type*growthl12  leader_time time2 time3, fe i(country) nolog
est store fe
hausman fe re, eq(1:1)
xi:xtlogit  leader_exit  logoilr loilrsanct i.alltype*lsanctionx lpop regreg coldwar forwar loggdppc growthl12  leader_time time2 time3, fe i(country)
est store tableA6


**Controlling for trade and aid, separately and together**
xi:logit  leader_exit  logoilr loilrsanct i.type*lsanctionx tradegdp demobefo lpop regreg newc reld coldwar forwar loggdppc i.type*growthl12  leader_time time2 time3, cluster(leader_code)
est store tableA7
xi:logit  leader_exit  logoilr loilrsanct i.type*lsanctionx aidpcl12 demobefo lpop regreg newc reld coldwar forwar loggdppc i.type*growthl12  leader_time time2 time3, cluster(leader_code)
est store tableA8
xi:logit  leader_exit  logoilr loilrsanct i.type*lsanctionx aidpcl12 tradegdp demobefo lpop regreg newc reld coldwar forwar loggdppc i.type*growthl12  leader_time time2 time3, cluster(leader_code)
est store table33

***Table 4 Selection corrected Models***

xi:probit lsanctionx logoilr forwar civwar odwp loggdppc i.type coldwar tradedem newc ssa nafr meast casia cacar easia samer ceeu
est store appendix1 
predict lp if e(sample), xb
generate lambda_sanct= -normalden(lp)/(normprob(lp)) 
generate lambda_nosanct= normalden(lp)/(1-normprob(lp)) 
drop  lp 

xi:logit  leader_exit lambda_sanct i.type logoilr lpop coldwar reld demobefo loggdppc i.type*growthl12 newc regreg forwar leader_time time2 time3 if lsanctionx==1, cluster(leader_code)
predict pr_sanct, p
xi:logit  leader_exit lambda_nosanct i.type logoilr lpop coldwar reld demobefo loggdppc i.type*growthl12 newc regreg forwar leader_time time2 time3 if lsanctionx==0, cluster(leader_code) 
predict pr_nosanct, p

sum pr_nosanct pr_sanct
sum pr_nosanct pr_sanct if type==1
sum pr_nosanct pr_sanct if type==2| type==3

ttest pr_nosanct=pr_sanct, unpaired unequal
ttest pr_nosanct=pr_sanct if type==1, unpaired unequal
ttest pr_nosanct=pr_sanct if type==2| type==3, unpaired unequal
ttest pr_nosanct=pr_sanct if type==2 , unpaired unequal
ttest pr_nosanct=pr_sanct if type==3 , unpaired unequal

drop lambda_*
drop pr_*

xi:probit lsanctionx lpop forwar civwar odwp loggdppc i.alltype coldwar newc ssa nafr meast casia cacar easia samer ceeu
est store appendix1 
predict lp if e(sample), xb
generate lambda_sanct= -normalden(lp)/(normprob(lp)) 
generate lambda_nosanct= normalden(lp)/(1-normprob(lp)) 
drop  lp 

xi:logit  leader_exit lambda_sanct i.alltype logoilr lpop coldwar reld demobefo loggdppc i.alltype*growthl12 newc regreg forwar leader_time time2 time3 if lsanctionx==1, cluster(leader_code)
predict pr_sanct, p
xi:logit  leader_exit lambda_nosanct i.alltype logoilr lpop coldwar reld demobefo loggdppc i.alltype*growthl12 newc regreg forwar leader_time time2 time3 if lsanctionx==0, cluster(leader_code) 
predict pr_nosanct, p

sum pr_nosanct pr_sanct
sum pr_nosanct pr_sanct if alltype==1
sum pr_nosanct pr_sanct if alltype==2| alltype==3

ttest pr_nosanct=pr_sanct, unpaired unequal
ttest pr_nosanct=pr_sanct if alltype==1, unpaired unequal
ttest pr_nosanct=pr_sanct if alltype==2| alltype==3, unpaired unequal
ttest pr_nosanct=pr_sanct if alltype==2 , unpaired unequal
ttest pr_nosanct=pr_sanct if alltype==3 , unpaired unequal

drop lambda_*
drop pr_*


***Table 5***

xi:mlogit leader_typeexit logoilr loilrsanct loggdppc i.type*growthl12 lpop reld newc demobefo regreg coldwar forwar i.type*lsanctionx leader_time time2 time3, cluster(leader_code)
est store  table51
xi:mlogit leader_typeexit logoilr loilrsanct loggdppc i.type*coldwar growthl12 lpop reld newc demobefo regreg coldwar forwar i.type*lsanctionx leader_time time2 time3, cluster(leader_code)
est store  table52
xi:mlogit leader_typeexit logoilr loilrsanct loggdppc i.type*coldwar i.type*growthl12 lpop reld newc demobefo regreg forwar i.type*lsanctionx leader_time time2 time3, cluster(leader_code)
est store typeexit1

***Table 6***

xi:mlogit  leader_typeexit  logoilr loilrsanct i.type*lsanctionx demobefo lpop regreg newc reld forwar coldwar loggdppc i.type*growthl12 leader_time time2 time3, cluster(leader_code)
bysort type: sum logoilr leader_time time2 time3 if e(sample)  
estsimp mlogit  leader_typeexit  logoilr  loilrsanct  _Itype_2 _Itype_3   lsanctionx   _ItypXlsanc_2 _ItypXlsanc_3 demobefo lpop regreg newc reld  coldwar forwar   loggdppc growthl12 _ItypXgrowt_2 _ItypXgrowt_3 leader_time time2 time3, cluster(leader_code)
setx mean
setx  _Itype_2   0 _Itype_3 0 lsanctionx  0  _ItypXlsanc_2 0   _ItypXlsanc_3  0 growthl12 0.0087 _ItypXgrowt_2 0 _ItypXgrowt_3 0 logoilr 1.32 loilrsanct 0 leader_time 13 time2  286 time3  8842
simqi 
setx  _Itype_2   0 _Itype_3 0 lsanctionx  1  _ItypXlsanc_2 0   _ItypXlsanc_3  0 growthl12 0.0087  _ItypXgrowt_2 0 _ItypXgrowt_3 0 logoilr 1.32 loilrsanct 1.32 leader_time 13 time2  286 time3  8842
simqi
setx mean
setx  _Itype_2   1 _Itype_3 0 lsanctionx  0  _ItypXlsanc_2 0   _ItypXlsanc_3 0 growthl12 0.017 _ItypXgrowt_2 0.017 _ItypXgrowt_3 0 logoilr .64 loilrsanct 0 leader_time 11  time2  207 time3  4984
simqi 
setx  _Itype_2   1 _Itype_3 0 lsanctionx  1  _ItypXlsanc_2 1   _ItypXlsanc_3 0 growthl12 0.017 _ItypXgrowt_2 0.017 _ItypXgrowt_3 0 logoilr .64 loilrsanct .64 leader_time 11  time2  207 time3  4984
simqi
setx mean
setx  _Itype_2   0 _Itype_3 1 lsanctionx  0  _ItypXlsanc_2 0   _ItypXlsanc_3 0 growthl12 0.018 _ItypXgrowt_2 0 _ItypXgrowt_3 0.018 logoilr .39 loilrsanct 0 leader_time 5  time2  47 time3  652
simqi 
setx  _Itype_2   0 _Itype_3 1 lsanctionx  1  _ItypXlsanc_2 0   _ItypXlsanc_3 1 growthl12 0.018 _ItypXgrowt_2 0 _ItypXgrowt_3 0.018 logoilr .39 loilrsanct .39 leader_time 5  time2  47 time3  652
simqi


*First differences*
setx mean
setx  _Itype_2 0 _Itype_3 0  lsanctionx 0 _ItypXlsanc_2 0  _ItypXlsanc_3 0 growthl12 0.0087 _ItypXgrowt_2 0 _ItypXgrowt_3 0  logoilr 1.32  loilrsanct 0 leader_time 13 time2 286 time3 8842
 simqi, fd(prval (1))  changex(lsanctionx 0 1 loilrsanct 0 1.32)
 simqi, fd(prval (2))  changex(lsanctionx 0 1 loilrsanct 0 1.32)

setx mean
setx  _Itype_2 1 _Itype_3 0  lsanctionx 0 _ItypXlsanc_2 0  _ItypXlsanc_3 0 growthl12 0.017 _ItypXgrowt_2 0.017 _ItypXgrowt_3 0  logoilr .64  loilrsanct 0  leader_time 11 time2 207 time3 4984
 simqi, fd(prval (1))  changex(lsanctionx 0 1 _ItypXlsanc_2 0 1 loilrsanct 0 .64)
 simqi, fd(prval (2))  changex(lsanctionx 0 1 _ItypXlsanc_2 0 1 loilrsanct 0 .64)

setx mean
setx  _Itype_2 0 _Itype_3 1 lsanctionx 0 _ItypXlsanc_2 0  _ItypXlsanc_3 0 growthl12 0.018 _ItypXgrowt_2 0 _ItypXgrowt_3 0.018  logoilr .39  loilrsanct 0   leader_time  5 time2 47 time3 652
 simqi, fd(prval (1))  changex(lsanctionx 0 1 _ItypXlsanc_3 0 1 loilrsanct 0 .39)
 simqi, fd(prval (2))  changex(lsanctionx 0 1 _ItypXlsanc_3 0 1 loilrsanct 0 .39)

drop b*


xi:mlogit leader_typeexit logoilr loilrsanct loggdppc growthl12 lpop reld newc demobefo regreg forwar i.type*lsanctionx i.type*coldwar leader_time time2 time3, cluster(leader_code)
bysort type: sum logoilr leader_time time2 time3 if e(sample)
estsimp mlogit  leader_typeexit  logoilr  loilrsanct  _Itype_2 _Itype_3   lsanctionx   _ItypXlsanc_2 _ItypXlsanc_3 demobefo lpop regreg newc reld  coldwar  _ItypXcoldw_2 _ItypXcoldw_3 forwar   loggdppc growthl12 leader_time time2 time3, cluster(leader_code)
setx mean
setx  _Itype_2 0 _Itype_3 0  lsanctionx 0 _ItypXlsanc_2 0  _ItypXlsanc_3 0 _ItypXcoldw_2 0 _ItypXcoldw_3 0 logoilr 1.32  loilrsanct 0 leader_time 13 time2 286 time3 8842
simqi
setx  _Itype_2 0 _Itype_3 0  lsanctionx 1 _ItypXlsanc_2 0  _ItypXlsanc_3 0 _ItypXcoldw_2 0 _ItypXcoldw_3 0 logoilr 1.32  loilrsanct 1.32  leader_time 13 time2 286 time3 8842
simqi

setx  _Itype_2 1 _Itype_3 0  lsanctionx 0 _ItypXlsanc_2 0  _ItypXlsanc_3 0 _ItypXcoldw_3 0 logoilr .64  loilrsanct 0   leader_time 11 time2 207 time3 4984
simqi
setx  _Itype_2 1 _Itype_3 0  lsanctionx 1 _ItypXlsanc_2 1  _ItypXlsanc_3 0 _ItypXcoldw_3 0 logoilr .64  loilrsanct 0.64   leader_time  11 time2 207 time3 4984
simqi

setx  _Itype_2 0 _Itype_3 1 lsanctionx 0 _ItypXlsanc_2 0  _ItypXlsanc_3  0 _ItypXcoldw_2 0 logoilr .39  loilrsanct 0   leader_time 5 time2 47 time3 652
simqi
setx  _Itype_2 0 _Itype_3 1  lsanctionx 1 _ItypXlsanc_2 0 _ItypXlsanc_3 1  _ItypXcoldw_2 0 logoilr .39  loilrsanct 0.39   leader_time 5  time2 47 time3 652
simqi


*First differences*
setx mean
setx  _Itype_2 0 _Itype_3 0  lsanctionx 0 _ItypXlsanc_2 0  _ItypXlsanc_3 0 _ItypXcoldw_2 0 _ItypXcoldw_3 0  logoilr 1.32  loilrsanct 0 leader_time 13 time2 286 time3 8842
 simqi, fd(prval (1))  changex(lsanctionx 0 1 loilrsanct 0 1.32)
 simqi, fd(prval (2))  changex(lsanctionx 0 1 loilrsanct 0 1.32)

setx mean
setx  _Itype_2 1 _Itype_3 0  lsanctionx 0 _ItypXlsanc_2 0  _ItypXlsanc_3 0  _ItypXcoldw_3 0  logoilr .64  loilrsanct 0  leader_time 11 time2 207 time3 4984
 simqi, fd(prval (1))  changex(lsanctionx 0 1 _ItypXlsanc_2 0 1 loilrsanct 0 .64)
 simqi, fd(prval (2))  changex(lsanctionx 0 1 _ItypXlsanc_2 0 1 loilrsanct 0 .64)

setx mean
setx  _Itype_2 0 _Itype_3 1 lsanctionx 0 _ItypXlsanc_2 0  _ItypXlsanc_3 0 _ItypXcoldw_2 0 logoilr .39  loilrsanct 0   leader_time  5 time2 47 time3 652
 simqi, fd(prval (1))  changex(lsanctionx 0 1 _ItypXlsanc_3 0 1 loilrsanct 0 .39)
 simqi, fd(prval (2))  changex(lsanctionx 0 1 _ItypXlsanc_3 0 1 loilrsanct 0 .39)

drop b*




**Output tables**
estout table1* using table1.tex, cells(b(star fmt(%9.3f)) se(par fmt(%9.2f))) stats(r2 ll N) style(tex)  starlevels(+ 0.10 * 0.05 ** 0.01)  replace
estout table3* using table3.tex, cells(b(star fmt(%9.3f)) se(par fmt(%9.2f))) stats(r2 ll N) style(tex)  starlevels(+ 0.10 * 0.05 ** 0.01)  replace
estout table5* using table5.tex, cells(b(star fmt(%9.3f)) se(par fmt(%9.2f))) stats(r2 ll N) style(tex)  starlevels(+ 0.10 * 0.05 ** 0.01)  replace
estout appendix* using appendix.tex, cells(b(star fmt(%9.3f)) se(par fmt(%9.2f))) stats(r2 ll N) style(tex)  starlevels(+ 0.10 * 0.05 ** 0.01)  replace
estout tableA* using tableA.tex, cells(b(star fmt(%9.3f)) se(par fmt(%9.2f))) stats(r2 ll N) style(tex)  starlevels(+ 0.10 * 0.05 ** 0.01)  replace
estout typeexit1 using typeexit1.tex, cells(b(star fmt(%9.3f)) se(par fmt(%9.2f))) stats(r2 ll N) style(tex)  starlevels(+ 0.10 * 0.05 ** 0.01)  replace





***Arms imports***
gen logarms_pop = log(1+  (armsimports/(population/1000000)))
tsset country year 
gen laglogarms_pop = l.logarms_pop
xi:logit  leader_exit  i.type*laglogarms logoilr  demobefo lpop regreg newc reld  coldwar forwar loggdppc i.type*growthl12 leader_time time2 time3, cluster(leader_code)
lincom  laglogarms_pop+ _ItypXlaglo_2
lincom  laglogarms_pop+ _ItypXlaglo_3
est store arms1

xi:logit  leader_exit  i.type*laglogarms i.type*lsanctionx loilrsanct logoilr lpop demobefo regreg newc reld i.type*coldwar forwar loggdppc growthl12 leader_time time2 time3, cluster(leader_code)
lincom  laglogarms_pop+ _ItypXlaglo_2
lincom  laglogarms_pop+ _ItypXlaglo_3
est store arms2

xi:logit  leader_exit  i.type*laglogarms logoilr demobefo lpop regreg newc reld  coldwar forwar loggdppc i.type*growthl12 leader_time time2 time3 if coldwar, cluster(leader_code)
lincom  laglogarms_pop+ _ItypXlaglo_2
lincom  laglogarms_pop+ _ItypXlaglo_3
est store arms3

xi:logit  leader_exit  i.type*laglogarms i.type*lsanctionx loilrsanct logoilr lpop demobefo regreg newc reld  coldwar forwar loggdppc growthl12 leader_time time2 time3 if coldwar, cluster(leader_code)
lincom  laglogarms_pop+ _ItypXlaglo_2
lincom  laglogarms_pop+ _ItypXlaglo_3
est store arms4

estout arms* using tablearms.tex, cells(b(star fmt(%9.3f)) se(par fmt(%9.2f))) stats(r2 ll N) style(tex)  starlevels(+ 0.10 * 0.05 ** 0.01)  replace




****************
**Figures Data**
****************
use figures.dta, clear
***Figure 1***
table sanction if type==1, c(mean  aid_gni mean  nontaxgdp mean  inttaxgdp)
table sanction if type==1, c(mean   inctaxgdp  mean   gstaxgdp mean   taxrev)
table sanction if type==2, c(mean  aid_gni mean  nontaxgdp mean  inttaxgdp)
table sanction if type==2, c(mean   inctaxgdp  mean   gstaxgdp mean   taxrev)
table sanction if type==3, c(mean  aid_gni mean  nontaxgdp mean  inttaxgdp)
table sanction if type==3, c(mean   inctaxgdp  mean   gstaxgdp mean   taxrev)

ttest  aid_gni if type==1, by(sanction) unequal
ttest  nontaxgdp if type==1, by(sanction) unequal
ttest  inttaxgdp if type==1, by(sanction) unequal
ttest  inctaxgdp if type==1, by(sanction) unequal
ttest  gstaxgdp if type==1, by(sanction) unequal
ttest  taxrev if type==1, by(sanction) unequal

ttest  aid_gni if type==2, by(sanction) unequal
ttest  nontaxgdp if type==2, by(sanction) unequal
ttest  inttaxgdp if type==2, by(sanction) unequal
ttest  inctaxgdp if type==2, by(sanction) unequal
ttest  gstaxgdp if type==2, by(sanction) unequal
ttest  taxrev if type==2, by(sanction) unequal

ttest  aid_gni if type==3, by(sanction) unequal
ttest  nontaxgdp if type==3, by(sanction) unequal
ttest  inttaxgdp if type==3, by(sanction) unequal
ttest  inctaxgdp if type==3, by(sanction) unequal
ttest  gstaxgdp if type==3, by(sanction) unequal
ttest  taxrev if type==3, by(sanction) unequal


***Figure 2***

graph bar (mean) gsexpgdp subsidiesgdp capitalexpgdp, over(sanction, relabel(1 "No sanction" 2 "Under")) over(type, relabel(1 "Personal/Monarch" 2 "Single-party" 3 "Military")) legend(label(1 "Goods and services") label(2 "Subsidies and transfers") label(3 "Capital expenditures")) bar(1, color(edkblue)) bar(2, color(red)) bar(3, color(sand)) ytitle("% of GDP")


***Figure 3***

graph bar (mean)  terrorscale, over(sanction, relabel(1 "No sanction" 2 "Under")) over(type, relabel(1 "Personal/Monarch" 2 "Single-party" 3 "Military")) ytitle("Political Terror Scale")



**Descriptive Statistics Used:**

bysort puretype: sum aidpc  
bysort type: sum aidpc  


bysort type: sum govcons
bysort puretype: sum govcons


**t-tests for repression**

ttest terrorscale if type==1, by(lagsanct) unequal
ttest terrorscale if type==2, by(lagsanct) unequal
ttest terrorscale if type==3, by(lagsanct) unequal


**t-tests for government spending**

ttest gsexpgdp if type==1, by(sanction) unequal
ttest gsexpgdp if type==2, by(sanction) unequal
ttest gsexpgdp if type==3, by(sanction) unequal

ttest subsidiesgdp if type==1, by(sanction) unequal
ttest subsidiesgdp if type==2, by(sanction) unequal
ttest subsidiesgdp if type==3, by(sanction) unequal

ttest capitalexpgdp if type==1, by(sanction) unequal
ttest capitalexpgdp if type==2, by(sanction) unequal
ttest capitalexpgdp if type==3, by(sanction) unequal

*footnote 14*
gen loggovcons = log(1+ govcons)
xi: reg loggovcons i.type lgdp_ rentsross

log close

**The End**