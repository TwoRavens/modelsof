*to install runmlwin

 ssc install runmlwin, replace
global MLwiN_path "C:\Program Files (x86)\MLwiN v2.27\i386\mlwin.exe"

*load the dataset

use Milner1, clear

*generate mean variables

egen gdppc_mean = mean(gdppc), by(ctylabel)
egen polity_mean = mean(polity), by(ctylabel)
egen lnpop_mean = mean(lnpop), by(ctylabel)

*remove missing values

drop if missing(tariff)
drop if missing(gdppc)
drop if missing(polity)
drop if missing(lnpop)

*generate within variables

egen date_mean_new = mean(date), by(ctylabel)
egen gdppc_mean_new = mean(gdppc), by(ctylabel)
egen polity_mean_new = mean(polity), by(ctylabel)
egen lnpop_mean_new = mean(lnpop), by(ctylabel)

gen datew = date - date_mean_new
gen gdppcw = gdppc - gdppc_mean_new
gen polityw = polity - polity_mean_new
gen lnpopw = lnpop - lnpop_mean_new

drop gdppc_mean_new
drop polity_mean_new
drop lnpop_mean_new

*center variables

sum gdppc, meanonly
gen cgdppc = gdppc - r(mean)
sum date, meanonly
gen cdate = date - r(mean)
sum lnpop, meanonly
gen clnpop = lnpop - r(mean)

sum gdppc_mean, meanonly
gen cgdppc_mean = gdppc_mean - r(mean)
sum lnpop_mean, meanonly
gen clnpop_mean = lnpop_mean - r(mean)

*generate cross-level interactions etc

generate politywxpolity_mean = polityw*polity_mean

generate SAsia = 0
replace SAsia = 1 if ctylabel == 68
replace SAsia = 1 if ctylabel == 61
replace SAsia = 1 if ctylabel == 76

generate bangla = 0
replace bangla = 1 if ctylabel == 61

generate BanglaXPolityw = bangla*polityw

*generate the matrix for the linear variance function at level 1

matrix A = (1,1,0)

*set the nature of the data (needed for xtreg)

tsset ctylabel date, yearly

*run the models

runmlwin tariff cons, level2(ctylabel: cons) ///
level1(date: cons) nopause rigls
estimates store REnull

xtreg tariff polity clnpop cgdppc cdate, fe
estimates store FE 

runmlwin tariff cons polity clnpop cgdppc cdate, ///
level2(ctylabel: cons) level1(date: cons) nopause rigls
estimates store RE

runmlwin tariff cons polityw lnpopw gdppcw datew polity_mean ///
clnpop_mean cgdppc_mean, level2(ctylabel: cons) ///
level1(date: cons) nopause rigls
estimates store REwb

runmlwin tariff cons polityw lnpopw gdppcw datew polity_mean ///
clnpop_mean cgdppc_mean SAsia, ///
level2(ctylabel: cons) level1(date: cons) ///
initsprevious nopause rigls
estimates store mod5

runmlwin tariff cons polityw lnpopw gdppcw datew polity_mean ///
clnpop_mean cgdppc_mean SAsia, ///
level2(ctylabel: cons polityw) level1(date: cons polityw, elements(A)) ///
initsprevious nopause rigls
estimates store mod6

runmlwin tariff cons polityw lnpopw gdppcw datew polity_mean ///
clnpop_mean cgdppc_mean SAsia BanglaXPolityw, ///
level2(ctylabel: cons polityw) level1(date: cons polityw, elements(A)) ///
initsprevious nopause rigls
estimates store mod7

runmlwin tariff cons polityw lnpopw gdppcw datew polity_mean ///
clnpop_mean cgdppc_mean SAsia BanglaXPolityw politywxpolity_mean, ///
level2(ctylabel: cons polityw) level1(date: cons polityw, elements(A)) ///
initsprevious nopause rigls
estimates store mod8

estimates table REnull FE RE REwb, se stats(deviance)

estimates table mod5 mod6 mod7 mod8, se stats(deviance)
