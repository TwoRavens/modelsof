// Replication of Regression Analyses from DeScioli and Kimbrough, "Alliance formation in a side-taking Experiment," Journal of Experimental Political Science

clear all

log using "~/Dropbox (Personal)/Alliances/Experimental Paper/JEPS Final/Replication_Regressions_JEPS.log", replace

use "~/Dropbox (Personal)/Alliances/Experimental Paper/JEPS Final/Individual_Data_JEPS.dta"

gen invpd = 1/period
label variable invpd "1/Period"

xtset id period

gen fullchat = full*chat
gen fullpd = full*invpd
gen chatpd = chat*invpd
gen fullchatpd = full*chat*invpd


//compute Fisher's z-transform of the alliance and egalitarian/bandwagon strategies

gen z_alliance = 0.5*ln((1+alliance)/(1-alliance))
gen z_egal_band = 0.5*ln((1+egalitarian_bandwagon)/(1-egalitarian_bandwagon))

// Reproduce estimates from Table 1

xtreg z_alliance full chat fullchat ,re vce(cluster session)
eststo

xtreg z_alliance full chat invpd fullchat fullpd chatpd fullchatpd, re vce(cluster session)
eststo

xtreg z_egal_band full chat fullchat ,re vce(cluster session)
eststo

xtreg z_egal_band full chat invpd fullchat fullpd chatpd fullchatpd, re vce(cluster session)
eststo

esttab , cells(b(star fmt(3)) se(par fmt(3))) star( * 0.05 ** 0.01 *** 0.001) scalars("N Obs." "chi2  Wald Chi-Sq.") label replace notes 


// Reproduce estimates from Table A1
//type1 = alliance, type2 = bandwagon, type3 = egalitarian, type4 = none

est clear
drop if period==1
mlogit type full chat fullchat, cluster(session) base(4)
eststo
mlogit type full chat fullchat invpd fullpd chatpd fullchatpd, cluster(session) base(4)
eststo

esttab , cells(b(star fmt(3)) se(par fmt(3))) star( * 0.05 ** 0.01 *** 0.001) scalars("N Obs." "chi2  Wald Chi-Sq.") label replace notes 


log close

