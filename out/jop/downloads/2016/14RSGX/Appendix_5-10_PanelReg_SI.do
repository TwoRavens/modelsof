/*
Replication file for "The Policy Effects of the Partisan Composition of State Government"
Authors: Devin Caughey, Chris Warshaw, Yiqing Xu

Online Supporting Information

Sofeware: STATA 14
*/

 ssc install reghdfe // for estimating fixed effects models
 ssc install outreg2 // for exporting results
 ssc install xtabond2 // for GMM estimation

/*
1. Dynamic Effects
2. Testing Unit Roots and GMM Estimations
3. State-specific Trends
4. Choosing the Number of Lagged Terms
5. Asscess Model Fit: The Case of California
6. Disentangling Share and Control
*/

clear all
set more off

**Set the working directory in Stata to whatever directory you downloaded the replication materials from our paper.

**cd "~/Dropbox/Projects/PartyControl_StateLegislatures/Replication_Archive/"

********************
* A5: Dynamic Effects 
********************

use "party_control_data_161121_stata.dta", clear
g gov_dem = gov_party == 1
encode abb, gen(state)
drop if abb=="NE"

// generate interactions
foreach var in gov_dem hs_dem_control sen_dem_control {
   g `var'_leftout = 1 
   forvalues i=5(-1)1 {
      g `var'_pre_`i' = 0 
      bysort state (year): replace `var'_pre_`i'=1 if `var'==0 & `var'[_n+`i']==0 
      bysort state (year): replace `var'_leftout=0 if `var'==0 & `var'[_n+`i']==0 
      }
   forvalues i=1/5 {
      g `var'_pst_`i' = 0 
      bysort state (year): replace `var'_pst_`i'=1 if `var'==1 & `var'[_n-`i']==0 
      bysort state (year): replace `var'_leftout=0 if `var'==1 & `var'[_n-`i']==0 
      }
   
   }
drop gov_dem_pre_1 hs_dem_control_pre_1 sen_dem_control_pre_1

// estimation
mat AA = J(9,6,.)

reghdfe Policy Policy_L1 Policy_L2 gov_dem_* hs_dem_control sen_dem_control, a(state year) cl(state)
mat coef = e(b)
mat var = e(V)
forvalues i = 1/9 {
   mat AA[`i',1] = coef[1,`i'+3] // save coefficients
   mat AA[`i',4] = sqrt(var[`i'+3,`i'+3]) // save std.err.s
   }

reghdfe Policy Policy_L1 Policy_L2 gov_dem hs_dem_control_* sen_dem_control, a(state year) cl(state)
mat coef = e(b)
mat var = e(V)
forvalues i = 1/9 {
   mat AA[`i',2] = coef[1,`i'+4]
   mat AA[`i',5] = sqrt(var[`i'+4,`i'+4])
   }

reghdfe Policy Policy_L1 Policy_L2 gov_dem hs_dem_control sen_dem_control_* , a(state year) cl(state)
mat coef = e(b)
mat var = e(V)
forvalues i = 1/9 {
   mat AA[`i',3] = coef[1,`i'+5]
   mat AA[`i',6] = sqrt(var[`i'+5,`i'+5])
   }

mat list AA
svmat AA
keep AA*
keep if AA1~=.
ren AA1 coef_gov
ren AA2 coef_hs
ren AA3 coef_sen
ren AA4 se_gov
ren AA5 se_hs
ren AA6 se_sen
* rows: -4, -3, -2, -1, 1, 2, 3, 4, 5
saveold fg_dyn,  replace // drawing pictures in R

**********************************
* A6: Unit Roots and GMM Estimations
**********************************

cap erase PanelResults.txt
cap erase PanelResults.tex

use "party_control_data_161121_stata.dta", clear
g gov_dem = gov_party == 1
encode abb, gen(state)
xtset state year
qui tab year, g(yr)
bysort abb (year): g d_Policy = Policy - Policy[_n-1] // first differencing
global keyvar = "gov_dem hs_dem_control sen_dem_control"

qui reghdfe d_Policy $keyvar Policy_L1, a(state year) cl(state)
outreg2 using PanelResults, tex dec(3) keep($keyvar Policy_L1) nocons noas addstat(States, e(N_clust))

qui xtabond2 d_Policy $keyvar Policy_L1 yr1-yr77  i.state, ///
  gmm(Policy, lag(2 5) eq(both)) ///
  iv(gov_dem hs_dem_control sen_dem_control yr1-yr77 i.state, eq(both)) robust
outreg2 using PanelResults, tex dec(3) keep($keyvar Policy_L1) nocons noas addstat(States, e(N_g))

qui reghdfe d_Policy  $keyvar Policy_L1 Policy_L2, a(state year) cl(state)
outreg2 using PanelResults, tex dec(3) keep($keyvar Policy_L1 Policy_L2) nocons noas addstat(States, e(N_clust))


qui xtabond2 d_Policy Policy_L1 Policy_L2 $keyvar yr1-yr77  i.state, ///
  gmm(Policy, lag(3 6) eq(both)) ///
  iv(gov_dem hs_dem_control sen_dem_control yr1-yr77 i.state, eq(both)) robust
outreg2 using PanelResults, tex dec(3) keep($keyvar Policy_L1 Policy_L2) nocons noas addstat(States, e(N_g))


****************************
* A7: Visualizing the Policy Effects of Party Control of Government
****************************

**See R code: PanelReg_Plotting.R


****************************
* A8: Adding time trends 
****************************

use "party_control_data_161121_stata.dta", clear
g gov_dem = gov_party == 1
encode abb, gen(state)
replace year=year-1936
g year2 = year*year
g year3 = year*year*year
global keyvar = "gov_dem hs_dem_control sen_dem_control"


cap erase PanelResults.txt
cap erase PanelResults.tex

bootstrap _b, reps(50) cluster(state) seed(01239): reghdfe Policy $keyvar, a(state year) 
outreg2 using PanelResults, tex dec(3) nocons noas addstat(States, e(N_clust))

bootstrap _b, reps(50) cluster(state) seed(01239): reghdfe Policy $keyvar, a(state year c.year#i.state) 
outreg2 using PanelResults, tex dec(3) nocons noas addstat(States, e(N_clust))

bootstrap _b, reps(50) cluster(state) seed(01239): reghdfe Policy $keyvar, a(state year (c.year c.year2)##i.state) 
outreg2 using PanelResults, tex dec(3) nocons noas addstat(States, e(N_clust))

bootstrap _b, reps(50) cluster(state) seed(01239): reghdfe Policy $keyvar, a(state year (c.year c.year2 c.year3)##i.state) 
outreg2 using PanelResults, tex dec(3)  nocons noas addstat(States, e(N_clust))

*******************************
* A8: Model Fit: California
*******************************

use "party_control_data_161121_stata.dta", clear
encode abb, gen(state)
g gov_dem = gov_party == 1
replace year=year-1936
g year2 = year*year
g year3 = year*year*year
global keyvar = "gov_dem hs_dem_control sen_dem_control"
replace sen_dem_control=0 if abb=="CA" & sen_dem_control==.

* two-way
qui reghdfe Policy $keyvar, a(state year, save)
predict Policy_fe, xbd

* trends
qui reghdfe Policy $keyvar, a(state year c.year##i.state, save)
predict Policy_trd1, xbd

qui reghdfe Policy $keyvar, a(state year (c.year c.year2)##i.state, save) 
predict Policy_trd2, xbd

qui reghdfe Policy $keyvar, a(state year (c.year c.year2 c.year3)##i.state, save) 
predict Policy_trd3, xbd

* LDV + FEs
qui reghdfe Policy Policy_L1 $keyvar, a(state year, save)
predict Policy_lg1, xbd

qui reghdfe Policy Policy_L1 Policy_L2 $keyvar, a(state year, save) 
predict Policy_lg2, xbd

qui reghdfe Policy Policy_L1 Policy_L2 Policy_L3 $keyvar, a(state year, save)
predict Policy_lg3, xbd

keep abb year gov_dem hs_dem_control sen_dem_control Policy Policy_fe Policy_trd? Policy_lg?

// For plotting in R
saveold fg_modelfit, replace 


**************************
* A9: Number of Lagged Terms
**************************

use "party_control_data_161121_stata.dta", clear
encode abb, gen(state)
g gov_dem = gov_party == 1
global keyvar = "gov_dem hs_dem_control sen_dem_control"

cap erase PanelResults.txt
cap erase PanelResults.tex

bootstrap _b, reps(50) cluster(state) seed(01239): reghdfe Policy $keyvar, a(state year) 
outreg2 using PanelResults, tex dec(3) nocons noas addstat(States, e(N_clust))

bootstrap _b, reps(50) cluster(state) seed(01239): reghdfe Policy $keyvar Policy_L1, a(state year) 
outreg2 using PanelResults, tex dec(3) nocons noas addstat(States, e(N_clust))

bootstrap _b, reps(50) cluster(state) seed(01239): reghdfe Policy $keyvar Policy_L1 Policy_L2, a(state year) 
outreg2 using PanelResults, tex dec(3) nocons noas addstat(States, e(N_clust))

bootstrap _b, reps(50) cluster(state) seed(01239): reghdfe Policy $keyvar Policy_L1 Policy_L2 Policy_L3, a(state year) 
outreg2 using PanelResults, tex dec(3) nocons noas addstat(States, e(N_clust))

bootstrap _b, reps(50) cluster(state) seed(01239): reghdfe Policy $keyvar Policy_L1 Policy_L2 Policy_L3 Policy_L4, a(state year) 
outreg2 using PanelResults, tex dec(3) nocons noas addstat(States, e(N_clust))



***************************************
* A10: Share vs. Control
***************************************

use "party_control_data_161121_stata.dta", clear
encode abb, gen(state)
g gov_dem = gov_party == 1
g DemSeatShareHouse_X_Control = hs_dem_per_2pty * hs_dem_control
g DemSeatShareSenate_X_Control = sen_dem_per_2pty * sen_dem_control

cap erase PanelResults.txt
cap erase PanelResults.tex

bootstrap _b, reps(50) cluster(state) seed(01239): reghdfe Policy Policy_L1 Policy_L2 gov_dem hs_dem_control sen_dem_control DemSeatShareHouse, a(state year) 
outreg2 using PanelResults, tex dec(3)  nocons noas addstat(States, e(N_clust))

bootstrap _b, reps(50) cluster(state) seed(01239): reghdfe Policy Policy_L1 Policy_L2 gov_dem hs_dem_control sen_dem_control DemSeatShareSenate, a(state year) 
outreg2 using PanelResults, tex dec(3)  nocons noas addstat(States, e(N_clust))

bootstrap _b, reps(50) cluster(state) seed(01239): reghdfe Policy Policy_L1 Policy_L2 gov_dem hs_dem_control sen_dem_control hs_dem_per_2pty sen_dem_per_2pty, a(state year) 
outreg2 using PanelResults, tex dec(3)  nocons noas addstat(States, e(N_clust))

bootstrap _b, reps(50) cluster(state) seed(01239): reghdfe Policy Policy_L1 Policy_L2 gov_dem hs_dem_control sen_dem_control hs_dem_per_2pty DemSeatShareHouse_X_Control sen_dem_per_2pty DemSeatShareSenate_X_Control, a(state year) 
outreg2 using PanelResults, tex dec(3)  nocons noas addstat(States, e(N_clust))







