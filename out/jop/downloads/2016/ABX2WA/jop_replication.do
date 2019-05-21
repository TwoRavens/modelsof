************************************************************************************************************************
*** TITLE:   Trading Interests: Domestic Institutions, International Negotiations, and the Politics of Trade
*** AUTHOR:  Timm Betz; timm.betz@tamu.edu
*** JOURNAL: The Journal of Politics
************************************************************************************************************************

use "jop_replication.dta", replace

*** TABLE 1
xtgls f.sd_tariff housesys , corr(ar1) force p(h)
estimates store m1
xtgls f.sd_tariff housesys lngdp gdp_capita , corr(ar1) force p(h)
estimates store m2
xtgls f.sd_tariff_i_net housesys lngdp gdp_capita , corr(ar1) force p(h)
estimates store m3
xtdpdsys fsd_tariff housesys lngdp gdp_capita , vce(robust)  pre(housesys) twostep
estimates store m4
xtreg f.sd_tariff housesys lngdp gdp_capita  , cluster(iso3n) re
estimates store m5
xtreg f.sd_tariff housesys lngdp gdp_capita  , cluster(iso3n) fe
estimates store m6

estout m1 m2 m3 m4 m5 m6,  starlevels(* .1 ** .05 *** .01) varlabels(_cons \textsc{constant} lngdp \textsc{GDP} gdp_capita "\textsc{GDP per capita}" housesys "\textsc{plurality rule}" L.fsd_tariff "\textsc{Lag sd tariff}") cells(b(star fmt(%9.3g)) se(par fmt(%9.3g))) stats(N N_g, label("Obs." "Countries") fmt(%4.0f)) style(tex) 


*** TABLE 2
xtgls f.sd_tariff mean_tariff housesys lngdp gdp_capita , corr(ar1) force p(h)
estimates store m1
xtgls f.sd_tariff tariff_cut housesys lngdp gdp_capita , corr(ar1) force p(h)
estimates store m2
qreg2 fsd_tariff housesys lngdp gdp_capita, cluster(iso3n) q(.5)
estimates store m3
xtset iso3n year
xtgls f.sd_tariff sd_trade housesys lngdp gdp_capita , corr(ar1) force p(h)
estimates store m6

preserve
use "jop_elasticity.dta", replace
xtgls f.sd_mixed c.housesys##c.dummy_elasticity lngdp gdp_capita , corr(ar1) force p(h)
estimates store m4
restore
preserve
use "jop_intermediates.dta", replace
xtgls f.sd_mixed c.housesys##c.intermediates lngdp gdp_capita , corr(ar1) force p(h)
estimates store m5
restore
preserve
use "jop_sector.dta", replace
set matsize 2000
xtgls f.sd_tariff_2d housesys lngdp gdp_capita lnimport_s lnexport_s , force p(h) corr(ar1)
estimates store m7
xtgls f.sd_tariff_2d housesys sd_trade_s lngdp gdp_capita , force p(h) corr(ar1)
estimates store m8
restore

estout m1 m2 m3 m4 m5 m6 m7 m8,  starlevels(* .1 ** .05 *** .01) varlabels(mean_tariff "\textsc{Avg tariff}" tariff_cut "\textsc{Tariff cut}" sd_trade "\textsc{Sd trade}" sd_trade_s "\textsc{Sd sector trade}" lnexport_s "\textsc{Sector exports}" lnimport_s "\textsc{Sector imports}" hs2_elasticity "\textsc{Elasticity}" _cons \textsc{constant} nonintermediate "\textsc{Non-intermediate}" lngdp "\textsc{GDP}" gdp_capita "\textsc{GDP per capita}" housesys "\textsc{plurality rule}" GDP \textsc{GDP} L.fsd_tariff "\textsc{Lag sd tariff}") cells(b(star fmt(%9.3g)) se(par fmt(%9.3g))) stats(N N_g, label("Obs." "Countries") fmt(%4.0f)) style(tex) 
