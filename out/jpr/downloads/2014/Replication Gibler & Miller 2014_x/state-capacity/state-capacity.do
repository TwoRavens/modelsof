use Z:\home\steve\Dropbox\projects\state-capacity\analysis\state-capacity.dta

mi import flong, m(imp) id(year ccode) imp(udsmean-udsmean2)
mi xtset ccode year
sort ccode year
drop if ccode == 2

gen L1_exprgdpols = L1.exprgdpols
gen L1_logtpop = L1.logtpop
gen L1_udsmean = L1.udsmean
gen L1_udsmean2 = L1.udsmean2
gen L1_c_lninflationcpi = L1.c_lninflationcpi
gen L1_c_agropergdp = L1.c_agropergdp
gen L1_logeconaid = L1.logeconaid
gen L1_logmilitaid = L1.logmilitaid
gen L1_ucdpterrconf = L1.ucdpterrconf
gen L1_ucdpnonterrconf = L1.ucdpnonterrconf
gen L1_cowcw4ongoing = L1.cowcw4ongoing



mi estimate: regress logmilper L1.exprgdpols L1.logtpop oil ethnic religion nwstate newlmtnest L1.udsmean L1.udsmean2 udsinstab L1.c_lninflationcpi L1.c_agro L1.logeconaid L1.logmilitaid L1.cowcw4ongoing L1.ucdpnonterrconf L1.ucdpterrconf, cluster (ccode)
est sto m1
mi estimate: regress logkg L1.exprgdpols L1.logtpop oil ethnic religion nwstate newlmtnest L1.udsmean L1.udsmean2 udsinstab L1.c_lninflationcpi L1.c_agro L1.logeconaid L1.logmilitaid  L1.cowcw4ongoing L1.ucdpnonterrconf L1.ucdpterrconf if year >= 1950, cluster (ccode)
est sto m2

mibeta logmilper L1.exprgdpols L1.logtpop oil ethnic religion nwstate newlmtnest L1.udsmean L1.udsmean2 udsinstab L1.c_lninflationcpi L1.c_agro L1.logeconaid L1.logmilitaid L1.ucdpterrconf L1.ucdpnonterrconf L1.cowcw4ongoing, cluster (ccode)
mibeta logkg L1.exprgdpols L1.logtpop oil ethnic religion nwstate newlmtnest L1.udsmean L1.udsmean2 udsinstab L1.c_lninflationcpi L1.c_agro L1.logeconaid L1.logmilitaid L1.ucdpterrconf L1.ucdpnonterrconf L1.cowcw4ongoing if year >= 1950, cluster (ccode)


use Z:\home\steve\Dropbox\projects\state-capacity\analysis\outdata31.dta, clear

estsimp regress logmilper L1_exprgdpols L1_logtpop oil ethnic religion nwstate newlmtnest L1_udsmean L1_udsmean2 udsinstab L1_c_lninflationcpi L1_c_agro L1_logeconaid L1_logmilitaid L1_ucdpterrconf L1_ucdpnonterrconf L1_cowcw4ongoing, cluster(ccode) genname(elmil) mi(outdata3)

setx mean
setx L1_ucdpterrconf 0
simqi, listx level(95)
setx L1_ucdpterrconf 1
simqi, listx level(95)
simqi, fd(ev) changex(L1_ucdpterrconf 0 1) level(95)

estsimp regress logkg L1_exprgdpols L1_logtpop oil ethnic religion nwstate newlmtnest L1_udsmean L1_udsmean2 udsinstab L1_c_lninflationcpi L1_c_agro L1_logeconaid L1_logmilitaid L1_ucdpterrconf L1_ucdpnonterrconf L1_cowcw4ongoing if year >= 1950, cluster(ccode) genname(logkg) mi(outdata3)

setx mean
setx L1_ucdpterrconf 0
simqi, listx level(95)
setx L1_ucdpterrconf 1
simqi, listx level(95)
simqi, fd(ev) changex(L1_ucdpterrconf 0 1) level(95)


