** BETZ, TIMM AND AMY POND (2018). "THE ABSENCE OF CONSUMER INTERESTS IN TRADE POLICY." 
** JOURNAL OF POLITICS, FORTHCOMING.
** REPLICATION DATA 

clear all
use jop_data.dta


* Table 1
reg simpleaverage weight_mex if iso3n == 484 & year == 2010 , robust
estimates store e1
reg simpleaverage weight_mex lnimport if iso3n == 484 & year == 2010  , robust
estimates store e2
reg simpleaverage weight_mex lnimport if iso3n == 484 & year == 2010 & tcode != 2 & tcode != 27  , robust
estimates store e3
reg simpleaverage weight_mex lnimport iit if iso3n == 484 & year == 2010  , robust
estimates store e4
reg simpleaverage weight_mex lnimport lnelasticity if iso3n == 484 & year == 2010  , robust
estimates store e5
preserve
drop _all
use "mex_isic.dta"
reg simpleaverage weight_mex lnoutput lnimport if year == 2010, robust
estimates store e6
restore

estout e1 e2 e3 e4 e5 e6,  cells(b(star fmt(a2)) p(par fmt(%4.3f))) starlevels( * .1 ** .05 *** .01) stats(N , fmt(0) label("Number Obs.")) nolz style(tex) varlabels(weight "Consumption share" lnexport "Log exports" lnimport "Log imports" _cons "Constant" )


* Table 2
reg simpleaverage c.weight_mex##c.polity2 lnimport if  iso3n == 484, cluster(tcode)
estimates store t1
reg simpleaverage c.weight_mex##c.polity2 lnimport ye ye2 if  iso3n == 484, cluster(tcode)
estimates store t2
reg simpleaverage c.weight_mex##c.polity2 lnimport nafta if  iso3n == 484, cluster(tcode)
estimates store t3
reg simpleaverage c.weight_mex##c.polity2 lnimport us_share if  iso3n == 484, cluster(tcode)
estimates store t4
reg simpleaverage_mfn c.weight_mex##c.polity2 lnimport if iso3n == 484, cluster(tcode)
estimates store t5

estout t1 t2 t3 t4 t5,  cells(b(star fmt(a2)) p(par fmt(%4.3f))) starlevels( * .1 ** .05 *** .01) stats(N , fmt(0) label("Number Obs.")) nolz style(tex) varlabels(weight_mex "Consumption share" lnimport "Log imports" _cons "Constant" )


* Table 3
reg simpleaverage c.weight_eu lnimport lngdp gdp_capita lnpop lnxrate lnfdi sum_ptas if  lastyear == 1, cluster(iso3n) 
estimates store m1
reg simpleaverage c.weight_eu##c.polity2 lnimport lngdp gdp_capita lnpop lnxrate lnfdi sum_ptas , cluster(iso3n) absorb(iso3n)
estimates store m2
reg simpleaverage c.weight_wb lnimport lngdp gdp_capita lnpop lnxrate lnfdi sum_ptas if year == 2010  , robust cluster(iso3n) 
estimates store m3
reg simpleaverage c.weight_wb##c.polity2 lnimport lngdp gdp_capita lnpop lnxrate lnfdi sum_ptas if maxpolity > 6  , robust  cluster(iso3n) absorb(iso3n)
estimates store m4
reg simpleaverage c.weight_mex lnimport lngdp gdp_capita lnpop lnxrate lnfdi sum_ptas if year == 2010 & northcentral == 1 , cluster(iso3n)
estimates store m5
reg simpleaverage c.weight_mex##c.polity2 lnimport lngdp gdp_capita lnpop lnxrate lnfdi sum_ptas if northcentral == 1 , cluster(iso3n) absorb(iso3n)
estimates store m6
reg simpleaverage weight_oecd lnimport lngdp gdp_capita lnpop lnxrate lnfdi sum_ptas  , robust cluster(iso3n)
estimates store m7

estout m1 m2 m3 m4 m5 m6 m7, extracols (3 5 7) cells(b(star fmt(a2)) p(par fmt(%4.3f))) starlevels( * .1 ** .05 *** .01) stats(N , fmt(0) label("Number Obs.")) nolz style(tex) varlabels(weight "Consumption share" lnexport "Log exports" lnimport "Log imports" _cons "Constant" )







