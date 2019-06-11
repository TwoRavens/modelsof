/* This do-file generates the elasticity estimates (and bootstrapped confidence intervals)
from Section 6 of Costinot, Donaldson, Kyle and Williams (QJE, 2019)
*/

***Preamble***

set seed 857
capture log close

*Set log
log using "${log_dir}EpsBootstrap.log", replace

*Reset output variables
scalar drop _all

*Load Data
use "${finalsavedir}data_for_price_on_distance.dta", clear


*******************  OBTAIN POINT ESTIMATES (ELASTICITIES) REPORTED IN SECTION 6 ****************
preserve

*Drop Sales of countries to itself
drop if sales_ctry == dest_ctry



**** Estimate "alpha" (column 2 of Table 9)
reghdfe lnprice lndist, absorb(mol#corp#gbd) vce(cluster sales_country dest_country)
*Save variables as scalars
scalar alpha = _b[lndist]


**** Estimate "rho" (column 1 of Table 9)
restore
*Prepare data
use "${finalsavedir}main_final_dataset.dta"
preserve

*Reduce to square dataset
drop if square_dataset != 1

*Drop Sales of countries to itself
drop if sales_ctry == dest_ctry

reghdfe lnsales lndist, absorb(dest_country#gbd sales_country#gbd) vce(cluster sales_country dest_country)
*Save variables as scalars
scalar rho = _b[lndist]

**** Create epsilon_X estimate
scalar epsXVal = round((1- (scalar(rho)/scalar(alpha))), 0.001)
di (1- (scalar(rho)/scalar(alpha)))


**** Estimate (1-eps_X)/(1+eps_S) from column 3 of Table 10

reghdfe lnsales (lnsales_sales_gbd=lndaly_p_sales), absorb(dest_country#sales_country dest_country#gbd) vce(cluster sales_country dest_country) stages(first)
scalar IVVal = _b[lnsales_sales_gbd]


**** Create epsilon_S estimate
scalar epsSVal = round((1-scalar(epsXVal))/scalar(IVVal)-1, 0.001)


*Drop unnecessary scalars
scalar drop rho alpha IVVal

restore


*************  OBTAIN BOOTSTRAPPED CONFIDENCE INTERVALS ON EPS_X AND EPS_S AS REPORTED IN SECTION 6 ******


*Load Data
use "${finalsavedir}data_for_price_on_distance.dta"

*Create Variable columns
gen epsX = 9999
gen epsS = 9999

*Number of bootstraps
local bstraps = 200


forval i = 1/`bstraps' {
preserve
bsample 56, cluster(dest_country) idcluster(idnew)


***Prepare data***

*No country should sell to itself
assert sales_ctry != dest_ctry

***Regressions***

*Regression (1)
reghdfe lnprice lndist, absorb(mol#corp#gbd) vce(cluster sales_country idnew)
*Save variables as scalars, only number of observations as local
scalar alpha = _b[lndist]

*Regression (2)
tempfile temp1
save "`temp1'"
*Prepare data


collapse price, by(idnew dest_country dest_ctry sales_country sales_ctry gbd)
merge m:1 dest_ctry sales_ctry gbd using "${finalsavedir}main_final_dataset.dta"
*Check that all entries from bsample are found in the main dataset
assert _m != 1
*Drop unmatched entries from main dataset
drop if _m != 3

*Dataset should be from square
assert square_dataset == 1

*No country should sell to itself
assert sales_ctry != dest_ctry

reghdfe lnsales lndist, absorb(idnew#gbd sales_country#gbd) vce(cluster sales_country idnew)
*Save variables as scalars
scalar rho = _b[lndist]

*Create epsilon_X estimate
scalar epsXBootVal = 1- (scalar(rho)/scalar(alpha))


*Table 10 Regression (3); Used to get epsilon_S value
reghdfe lnsales (lnsales_sales_gbd=lndaly_p_sales), absorb(idnew#sales_country idnew#gbd gbd) vce(cluster sales_country idnew) stages(first)
scalar IVVal = _b[lnsales_sales_gbd]


*Create epsilon_S estimate
scalar epsSBootVal = ((1-scalar(epsXBootVal))/scalar(IVVal))-1

restore
replace epsX = scalar(epsXBootVal) if _n == `i'
replace epsS = scalar(epsSBootVal) if _n == `i'

*Drop unnecessary scalars
scalar drop rho alpha IVVal epsSBootVal epsXBootVal
}

drop if epsS == 9999
drop if epsX == 9999

*** get 95% confidence intervals (for 200 bootstrap case)


sort epsS
scalar epsSlower = round(epsS[5], 0.001)
scalar epsSupper = round(epsS[195], 0.001)

sort epsX
scalar epsXlower = round(epsX[5], 0.001)
scalar epsXupper = round(epsX[195], 0.001)



scalar list

log close

