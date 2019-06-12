************************************************************************
* Replication Materials for JOP paper: Duration of War models          *
* "Spoilers, Terrorism, and the Resolution of Civil Wars"              *
* Date: 5/18/15														   *
* Authors: Michael G. Findley and Joseph K. Young                      * 
************************************************************************

clear
set more off

*Duration data
use duration_main.dta

*Set the data for survival analysis
stset warmonths, id(warnumber) f(warend)

*******************************
* Table 1: Models 1 and 2     *
*******************************
* Model 1
streg lagLogTotalWarRelated logpop elf  lngdp uppsalaMaxed logbattledeaths mountains guarantee, dist(lognormal) nolog

*Top half of Figure 3a
stcurve, hazard at1(lagLogTotalWarRelated=0.8247647 logpop=9.954131 elf=.5327649  lngdp=7.690343 uppsalaMaxed=3.065931  logbattledeaths=6.517842  mountains=30.1963  guarantee=.024463) at2(lagLogTotalWarRelated=1.9610567 logpop=9.954131 elf=.5327649  lngdp=7.690343 uppsalaMaxed=3.065931  logbattledeaths=6.517842  mountains=30.1963  guarantee=.024463) ytitle("Hazard Rate") xtitle("Analysis Time") legend(label(1 Mean Level of Terrorism) label(2 One SD Increase)) scheme(s2mono) 

* Model 2
streg smterrorwarrelated logpop elf  lngdp uppsalaMaxed logbattledeaths mountains guarantee, dist(lognormal) nolog 

*Bottom half of Figure 3a
stcurve, hazard at1(smterrorwarrelated=.8045763 logpop=9.952105 elf=.5329549  lngdp=7.682146 uppsalaMaxed=3.063651  logbattledeaths=6.513015  mountains=30.36538  guarantee=.0252284) at2(smterrorwarrelated=1.940918 logpop=9.952105 elf=.5329549  lngdp=7.682146 uppsalaMaxed=3.063651  logbattledeaths=6.513015  mountains=30.36538  guarantee=.0252284) ytitle("Hazard Rate") xtitle("Analysis Time") legend(label(1 Mean Level of Terrorism) label(2 One SD Increase))  scheme(s2mono)

save duration_main_est.dta, replace

