************************************************************************
* Replication Materials for JOP paper: Recurrence of War models        *
* "Spoilers, Terrorism, and the Resolution of Civil Wars"              *
* Date: 5/18/15														   *
* Authors: Michael G. Findley and Joseph K. Young                      * 
************************************************************************

clear
set more off

*Recurrence data
use recurrence_main.dta, clear

*Set the data for survival analysis
stset pdur, id(warnumb) f(pcens)

*******************************
* Table 1: Models 3 and 4     *
*******************************
*Model 3
streg lagLogTotalWarRelated lpopns ethfrac ln_gdpen inst2 regd4 absent, dist(lognormal) nolog

*Top half of Figure 3b
stcurve, hazard at1(lagLogTotalWarRelated=1.239982 lpopns=16.85648 ethfrac=0.4977412 ln_gdpen=0.3480922 inst2=0.2079208 regd4=-2.15429 absent=0.330033) at2(lagLogTotalWarRelated=2.823558 lpopns=16.85648 ethfrac=0.4977412 ln_gdpen=0.3480922 inst2=0.2079208 regd4=-2.15429 absent=0.330033) ytitle("Hazard Rate") xtitle("Analysis Time") legend(label(1 Mean Level of Terrorism) label(2 One SD Increase)) scheme(s2mono) 

*Model 4
streg smterrorWarRelated lpopns ethfrac ln_gdpen inst2 regd4 absent, dist(lognormal) nolog 

*Bottom half of Figure 3b
stcurve, hazard at1(smterrorWarRelated=1.201693 lpopns=16.85782 ethfrac=0.4973729 ln_gdpen=0.3424065 inst2=0.2045455 regd4=-2.19237 absent=0.3262987) at2(smterrorWarRelated=2.706251 lpopns=16.85782 ethfrac=0.4973729 ln_gdpen=0.3424065 inst2=0.2045455 regd4=-2.19237 absent=0.3262987) ytitle("Hazard Rate") xtitle("Analysis Time") legend(label(1 Mean Level of Terrorism) label(2 One SD Increase)) scheme(s2mono) 

save recurrence_main_est.dta, replace
