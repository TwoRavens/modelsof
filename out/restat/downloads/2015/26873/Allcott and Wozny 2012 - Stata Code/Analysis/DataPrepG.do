/* DataPrepG.do */
/* Add a series of gas cost and the gas cost instrument variables onto AutoPQX.  Note this was
   originally part of DataPrep.do, but was separated for convenience. */
capture log close
log using DataPrepG.log, replace

clear all
set mem 4000m
set more off

* Initialize AutoPQXG.dta
use AutoPQX.dta, clear
saveold AutoPQXG.dta,replace

*********
local PrimarySpec="1000000006025024100110"
local Bootstrap = 0

foreach params in ///
"1000000006025024100110"   ///
"1000000006025024100100" "1000000006025024100000" "1000000006025024100200" "1000000006025024100300" ///
"1000000006025024100111" "1000000006025024100112" "1000000006025024100113" "1000000006025024100114" ///
"1000000006025024100115" "1000000006025024100116" "1000000006025024100117" "1000000006025024100118" ///
"100000000602502410011A" "100000000602502410011B" "100000000602502410011C" "100000000602502410011D" ///
"1000000006025024112110" ///
"1000000003025024100110" "1000000010025024100110" "1000000011025024100110" "1000000012025024100110" "1000000014025024100110" "1000000015025024100110"  ///
"1000000013025024100110" "1000000017025024100110" "1000000000025024100110" "1000000093025024100110" "1000000094025024100110" "1000000095025024100110" ///
"1000000003025024100000" "1000000010025024100000" "1000000011025024100000" "1000000012025024100000" "1000000014025024100000" "1000000015025024100000"  ///
"1000000013025024100000" "1000000017025024100000" "1000000000025024100000" "1000000024025024100000" "1000000025025024100000" "1000000026025024100000" ///
"1000000006025005100110" "1000000006025003100110" ///
"1000110006025024100000" "1000120006025024100000" "1000150006025024100000" ///
"1001000006025024100110" "1002000006025024100110" "1003000006025024100110" "1004000006025024100110" "1005000006025024100110" "1006000006025024100110" "1100000006025024100110" ///
"1001000006025024100000" "1002000006025024100000" "1003000006025024100000" "1004000006025024100000" "1006000006025024100000" ///
"1000200006025024100110" "1000300006025024100110" "1000400006025024100110" "1000400006025024100000" ///
{

/* Description of above G's:
base (r=6%)
no pred futures, martingale, martingale with unadjusted gas prices, martingale with MSC data
intensive margin adjustments: 1, 2, 3, 4
intensive margin adjustments: 5, 6, 7, 8
intensive margin adjustments: A, B, C, D
fix VMT
disc rate: 3, 10, 11, 12, 14, 15
disc rate: 13, 17, 0, 93, 94, 95
disc rate: 3, 10, 11, 12, 14, 15 (martingale)
disc rate: 13, 17, 0, 24, 25, 26 (martingale)
time horizon: 5, 3
mean reversion: .1, .20, .50
lag gas price: 1, 2, 3, 4, 6; GPME 
martingale lag gas price: 1, 2, 3, 4, 6 mo
exclude C* from VMT regression, firm-specific age trends in survival probabilities, NHTS survival probabilities, NHTS survival probabilities (martingale) */


    * First is measurement error simulation. 1 is no measurement error. 2 and higher add additional forms of measurement error.
    * Second is an indicator for using GPME (pre-2008) instead of GPMA
    			* Second used to be an indicator for using the mean GPM for model j of age a, not ja from the specific model year.
    * 3-4 are gas price lag in months. This can't be larger than 12 for the code in GetGI.do
    * The hundreds of quadrillions (5) equals 1 if we want to assume a mean reversion parameter, 2 if we want to exclude the C* from the VMT regression, 3 to control for firm-specific age trends in survival probability
    * The tens of quadrillions and quadrillions (6-7) define the mean reversion parameter
    * Trillions and tens of trillions (9-10) is discount rate r
    * Billions and tens of billions (12-13) is lifetime in years
    * Millions and tens of millions (15-16) is time horizon in years. Note that time horizon can't be longer than 24 because only have survival probabilities to 24+1 years.
    * 100,000 (17) place is `usesurv'
    * 10,000 and 1000s (18-19) place define the m, in 1,000s of miles.
    * 100s (20) place = 1 to use futures data, 0 to assume martingale, 2 for martingale with unadjusted gas prices
    * 10s (21) place = 1 to use predicted futures
    * 1s (22) is intensive margin adjustment parameter

		local usegpme = real(substr("`params'",2,1))
		local gaspricelag = real(substr("`params'",3,2))
		local testmeanreversionconstant = real(substr("`params'",5,1))
		local meanreversionconstant = (-1) *real(substr("`params'",6,2))/100 /* meanreversionconstant is between 0 and-1*/
		local r = real(substr("`params'",9,2)) / 100 /* r is defined to be between 0 and 1 */
	  local lifetime = real(substr("`params'",12,2))
	  local timehorizon = real(substr("`params'",15,2))
	  local usesurv = real(substr("`params'",17,1))
	  local m = real(substr("`params'",18,2)) * 1000
	  local usefutures = real(substr("`params'",20,1))
	  local usepredictedfutures = real(substr("`params'",21,1))
	  local adjustintensive = substr("`params'",22,1)

		local primary = cond("`params'" == "`PrimarySpec'" ,1,0) /*Indicator for primary specification */
	
		
		*local params = real("`params'")
		
		display "`params'"
		display `usegpme'
		display `gaspricelag'
		display `testmeanreversionconstant'
		display `meanreversionconstant'
	  display `r'
	  display `lifetime'
	  display `timehorizon'
	  display `usesurv'
	  display `m'
	  display `usefutures'
	  display `usepredictedfutures'
	  display "`adjustintensive'"
		display `primary'
	
	  include Data/GetGI.do
	
	  if "`params'"=="`PrimarySpec'" {
	      compress
	      saveold AutoPQXG_Small, replace
	  }
	  
	  
	  
	/* Bootstrap replications */
	if "`params'"=="`PrimarySpec'" {
		** First get the normal primary spec
		include Data/GetGI.do
		
		** Then get the bootstrapped primary specs
		local Bootstrap = 1
		set seed 0 
		forvalues br = 1/50 {
			include Data/GetGI.do
		}
		local Bootstrap = 0
	}
	  
	  
}

/* Generate additional instruments for G for measurement error tests */
** Using primary specification only
* First the lags of G:
sort CarID Year Month
foreach l in 1 4 12 {
	gen lag`l'G`PrimarySpec' = cond(CarID == CarID[_n-`l'],G`PrimarySpec'[_n-`l'],.)
}

* Now the Average of G for vehicles in the class x modelyear x time group
bysort VClass ModelYear Month Year: egen av1G`PrimarySpec' = mean(G`PrimarySpec')
* Average of G for all in the class at the particular time.
bysort VClass Month Year: egen av2G`PrimarySpec' = mean(G`PrimarySpec')

saveold AutoPQXG, replace

/* Create new vehicle instruments 

do NewInst

use AutoPQXG, replace
sort CarID ModelYear Age
merge CarID ModelYear Age using NewInst, uniqusing nokeep keep(BLP_InFirm BLP_InCont BLP_OutCont)
drop _merge
replace BLP_InFirm = 0 if Age>0
replace BLP_InCont = 0 if Age>0
replace BLP_OutCont = 0 if Age>0
tab ModelYear if BLP_InFirm==. | BLP_OutCont==.
tab Make if BLP_InFirm==. | BLP_OutCont==.

saveold AutoPQXG, replace
*/

log close
