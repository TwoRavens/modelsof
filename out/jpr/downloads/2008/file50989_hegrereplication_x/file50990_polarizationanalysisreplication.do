clear
capture log close
log using "PolarizationReplication.log", replace

use "HegreReplication.dta"

set more off

summ


/*{NB: NORMALIZE FOR MU=!)
{Set aff. to . if year > 1996 )*/


replace DyadsInMID = 0 if DyadsInMID == .
replace DyFat0 = 0 if DyFat0==.
replace DyFat1 = 0 if DyFat1==.
replace DyFat2 = 0 if DyFat2==.
replace DyFat3 = 0 if DyFat3==.
replace DyFat4 = 0 if DyFat4==.
replace DyFat5 = 0 if DyFat5==.
replace DyFat6 = 0 if DyFat6==.


capture drop midshare
gen midshare = DyadsInMID / Dyads
capture drop midcntshare
gen midcntshare = DyadsInMID / Countries
capture drop wgtmidcnt
gen wgtmidcnt = (1*DyFat0 + (2*DyFat1) + (3*DyFat2) + (4*DyFat3) + (5*DyFat4) + (6*DyFat5) + (7*DyFat6) ) / Countries

ren var16 CPOP_16
ren var22 APOP_16
ren var25 AGDP_16
ren var28 PopAff_16

corr Countries Dyads midshare midcntshare wgtmidcnt CPOP_0 CPOP_16

/* Creating N-Pol measure */
gen RegionMu = RegionRichMu * RegionRichPopShare + RegionPoorMu * RegionPoorPopShare



sort Region year

gen NPol_16 = CPOP_16 * Countries^1.6
gen NAffPol_16 = PopAff_16 * Countries^1.6

 

/* Creating EGR measure */
capture drop EGR_16_2

gen RegionBiGini = RegionRichPopShare * RegionPoorPopShare*(RegionRichMu - RegionPoorMu)
gen EGR_16_2 = CPOP_16 - 2*((CPOP_0/(2*RegionMu)) - RegionBiGini)






tab Region
gen numreg = .
replace numreg = 1 if Region == "World"
replace numreg = 2 if Region == "America"
replace numreg = 3 if Region == "SSAfrica"
replace numreg = 4 if Region == "Asia"
replace numreg = 5 if Region == "Europe"
replace numreg = 6 if Region == "Middle East"
replace numreg = 7 if Region == "Oceania"

/* Table 1 */

sort Region
by Region: summarize Countries CPOP_0 CPOP_16 NPol_16 EGR_16_2 wgtmidcnt NAffPol_16 if year >= 1950 & year <= 2000
by Region: summarize Countries CPOP_0 CPOP_16 NPol_16 EGR_16_2 wgtmidcnt NAffPol_16 if year >= 1900 & year <= 2000
summarize Countries CPOP_0 CPOP_16 NPol_16 EGR_16_2 wgtmidcnt NAffPol_16 if year >= 1919 & year <= 1939 & Region == "World"
summarize Countries CPOP_0 CPOP_16 NPol_16 EGR_16_2 wgtmidcnt NAffPol_16 if year >= 1960 & year <= 2000 & Region == "SSAfrica"

corr CPOP_0 CPOP_16 NPol_16 Countries if Region == "World"


sort Region year 

/* FIGURE 1 */
/* Conflict Measures vs. Number of Countries, Countries as aggregation units */
#delimit ;
twoway (line Countries year , yaxis(1))
	(line midcntshare year, yaxis(2) lpattern(dot)) 
	(line wgtmidcnt year, yaxis(2) lpattern(dash)) if Region == "World" & year >=1900 & year < 2001,
	ytitle( "No. of Countries", axis(1) )
	ytitle( "Dyads in MID/No. of Countries", axis(2) )
	legend(label(1 "Number of Countries") label(3 "Weighted MID dyads / countries") label(2 "Unweighted MID dyads / countries"));
graph export "CountriesVsConflict.tif", replace;

/* FIGURE 2 */
/* Income ER polarization vs. N Polarization vs. Number of Countries, Countries as aggregation units */
#delimit ;
twoway (line Countries year , yaxis(1))
	(line CPOP_16 year, yaxis(2) lpattern(dot)) 
	(line NPol_16 year, yaxis(1) lpattern(dash)) if Region == "World" & year >=1900 & year < 2001,
	ytitle( "No. of Countries/N-Polarization", axis(1) )
	ytitle( "Income Polarization, alfa=1.6", axis(2) )
	legend(label(1 "Number of Countries") label(3 "Income ER-Polarization") label(2 "Income N-Polarization"));
graph export "CountriesVsERPolVsNPol.tif", replace;


/* FIGURE 3 */

/* Conflict and Income polarization, Countries as aggregation units */
#delimit ;
twoway (line wgtmidcnt year , yaxis(1))
	(line NPol_16 year, yaxis(2) lpattern(dash)) if Region == "World" & year >=1900 & year < 2001,
	ytitle( "Weighted Conflict", axis(1) )
	ytitle( "Income N-Polarization, alfa=1.6", axis(2) )
	legend(label(1 "Weighted Conflict") label(2 "Income N-Polarization"));
graph export "World.tif", replace;

/* FIGURE 4 */
/* By region: Conflict and Income polarization, Countries as aggregation units */
#delimit ;
twoway (line wgtmidcnt year , by(Region) yaxis(1))
	(line NPol_16 year, yaxis(2) lpattern(dash)) if Region != "World" & year >=1900 & year < 2001,
	ytitle( "Weighted Conflict", axis(1) )
	ytitle( "Income N-Polarization, alfa=1.6", axis(2) )
	legend(label(1 "Weighted Conflict") label(2 "Income N-Polarization"));
graph export "RegionsNPol.tif", replace;

/* FIGURE 5 */
/* By region: Conflict and Income EGR polarization, Countries as aggregation units */
#delimit ;
twoway (line wgtmidcnt year , by(Region) yaxis(1))
	(line EGR_16_2 year, yaxis(2) lpattern(dash)) if Region != "World" & year >=1900 & year < 2001,
	ytitle( "Weighted Conflict", axis(1) )
	ytitle( "Income EGR Polarization, alfa=1.6", axis(2) )
	legend(label(1 "Weighted Conflict") label(2 "Income EGR Polarization"));
graph export "RegionsEGR.tif", replace;

#delimit cr

/* TIME-SERIES ANALYSIS */
tsset numreg year, yearly


capture drop Y19*
gen Y1901 = 0
replace Y1901 = 1 if year == 1901
gen Y1913 = 0
replace Y1913 = 1 if year == 1913
gen Y1929 = 0
replace Y1929 = 1 if year == 1929
gen Y1939 = 0
replace Y1939 = 1 if year == 1939
gen Y1947 = 0
replace Y1947 = 1 if year == 1947
gen Y1950 = 0
replace Y1950 = 1 if year == 1950



/* Testing for ARCh effects */
reg wgtmidcnt if Region == "World" & year > 1900 & year < 2001
estat archlm, lags(1)
*arch wgtmidcnt if Region == "World" & year > 1900 & year < 2001, arch(1) ar(1 2) ma(1 2) garch(1)
*arch wgtmidcnt if Region == "World" & year > 1900 & year < 2001, arch(1) ar(1 2) ma(1) garch(1)
*arch wgtmidcnt if Region == "World" & year > 1900 & year < 2001, arch(1) ar(1 2) ma(1)
*arch wgtmidcnt if Region == "World" & year > 1900 & year < 2001, arch(1) ar(1) ma(1)
*arch wgtmidcnt if Region == "World" & year > 1900 & year < 2001, arch(1) ar(1) 

/* TABLE 6 */
/* World */
tsset numreg year, yearly
arch wgtmidcnt NPol_16 if Region == "World" & year > 1900 & year < 2001, arch(1) ar(1 2) ma(1)  nolog

/* Regions */
/* America */
arch wgtmidcnt NPol_16 if Region == "America" & year > 1900 & year < 2001, arch(1) ar(1 2) ma(1) nolog
arch wgtmidcnt NPol_16 if Region == "America" & year > 1900 & year < 2001, arch(1) ar(1) ma(1) nolog
arch wgtmidcnt NPol_16 if Region == "America" & year > 1900 & year < 2001, arch(1) ar(1) nolog

/* Europe */
arch wgtmidcnt NPol_16 if Region == "Europe" & year > 1900 & year < 2001, arch(1) ar(1 2) ma(1) nolog
arch wgtmidcnt NPol_16 if Region == "Europe" & year > 1900 & year < 2001, arch(1) ar(1) ma(1) nolog


/*Asia */
arch wgtmidcnt NPol_16 if Region == "Asia" & year > 1900 & year < 2001, arch(1) ar(1 2) ma(1) nolog
arch wgtmidcnt NPol_16 if Region == "Asia" & year > 1900 & year < 2001, arch(1) ar(1) ma(1) nolog

/*
arch wgtmidcnt NPol_16 if Region == "SSAfrica" & year > 1960 & year < 2001, arch(1) ar(1) 
arch wgtmidcnt NPol_16 if Region == "Oceania" & year > 1950 & year < 2001, arch(1) ar(1) 
Africa didn't converge, Oceania has no conflicts */

/*Middle East */
arch wgtmidcnt NPol_16 if Region == "Middle East" & year > 1950 & year < 2001, arch(1) ar(1 2) ma(1) nolog
arch wgtmidcnt NPol_16 if Region == "Middle East" & year > 1950 & year < 2001, arch(1) ar(1) ma(1) nolog
arch wgtmidcnt NPol_16 if Region == "Middle East" & year > 1950 & year < 2001, arch(1) ar(1) nolog
