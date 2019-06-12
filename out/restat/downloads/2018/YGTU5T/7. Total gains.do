********************************************************************************
*                                                                              *
*                         COUNTERFACTUAL ANALYSIS                              *
*                                                                              *
********************************************************************************

* Set different effects
global cpi2007 =  2432.4
global cpi2004 = 2326.9
local psi = 1
local r = 0.025
local totalinv = 1000000000

cd U:\  // open directory
use "NVM_20002014.dta", clear

global baseline = 0      // Estimate the baseline specifications
global adjustment = 1    // Allow for estimation of adjustment effect

local S = 3818799
local Sall = 6755864
local V = 151234
local Vall = 416572

set matsize 1000

local okw = .03340792
local okw_y1 = .0251331  
local okw_y2 = .0380518
local okw_y3 = .0405871
local rkw = .1031759
local rkw_y1 = .0926614
local rkw_y2 = .0696695
local rkw_y3 = .1323742

* Calculate counterfactual
use "NVM_20002014_full.dta", clear
g price = exp(logpricesqm)*exp(logsize)
g salestime = exp(logdaysonmarket)/365.25
g count = 1
keep price salestime year pc4 inkw
merge m:1 year using "cpi.dta", keep(3) nogenerate keepusing(cpi_index)
replace price = price*($cpi2007 / cpi_index)

collapse (mean) price salestime inkw , by(pc4)
keep if inkw == 1 
	
merge 1:1 pc4 using "pc4_housingunits_cbs.dta", nogenerate keep(1 3)
merge 1:1 pc4 using "pc4_woz.dta", nogenerate keep(1 3) keepusing(WOZ_imp)
rename WOZ_imp woz
replace woz = woz*($cpi2007 / $cpi2004) * 1000
*merge 1:1 pc4 using "Current projects\Probleemwijken\Data\pc4_hhtype.dta", nogenerate keep(1 3)
g ownerocc_rentalhousing = ownerocc+rentalhousing

g own_st = `okw'*price
g own_lt = `okw_y3'*price
g priv1_st = `okw'*woz
g priv1_lt = `okw_y3'*woz
g priv2_st = `rkw'*woz
g priv2_lt = `rkw_y3'*woz
g publ_st = `rkw'*woz
g publ_lt = `rkw_y3'*woz

// 1) • Effect on owner-occupied housing
//    • No effect on private rental and public housing
g est1_1 = own_st
g est1_2 = own_lt
g est1_3 = own_st*ownerocc
g est1_4 = own_lt*ownerocc

// 2) • Effect on owner-occupied housing
//    • Effect private rental equal to effect on owner-occupied housing
//    • No effect on public housing
g est2_1 = (own_st*ownerocc+priv1_st*rentalhousing)/(ownerocc+rentalhousing)
g est2_2 = (own_lt*ownerocc+priv1_lt*rentalhousing)/(ownerocc+rentalhousing)
g est2_3 = own_st*ownerocc+priv1_st*rentalhousing
g est2_4 = own_lt*ownerocc+priv1_lt*rentalhousing

// 3) • Effect on owner-occupied housing
//    • Effect on private rental housing
//    • No effect on public housing
g est3_1 = (own_st*ownerocc+priv2_st*rentalhousing)/(ownerocc+rentalhousing)
g est3_2 = (own_lt*ownerocc+priv2_lt*rentalhousing)/(ownerocc+rentalhousing)
g est3_3 = own_st*ownerocc+priv2_st*rentalhousing
g est3_4 = own_lt*ownerocc+priv2_lt*rentalhousing

// 4) • Effect on owner-occupied housing
//    • Effect on private rental housing
//    • Effect on public housing equal to effect on private rental housing
g est4_1 = (own_st*ownerocc+priv2_st*(rentalhousing+publhousing))/(ownerocc+rentalhousing+publhousing)
g est4_2 = (own_lt*ownerocc+priv2_lt*(rentalhousing+publhousing))/(ownerocc+rentalhousing+publhousing)
g est4_3 = own_st*ownerocc+priv2_st*(rentalhousing+publhousing)
g est4_4 = own_lt*ownerocc+priv2_lt*(rentalhousing+publhousing)

// Export results
g column1 = ""
replace column1 = "Estimate (1)" in 1
replace column1 = "Estimate (2)" in 2
replace column1 = "Estimate (3)" in 3
replace column1 = "Estimate (4)" in 4

g column2 = ""
replace column2 = "Effect on owner-occupied housing; No effect on private rental and public housing" in 1
replace column2 = "Effect on owner-occupied housing; Effect private rental equal to effect on owner-occupied housing; No effect on public housing" in 2
replace column2 = "Effect on owner-occupied housing; Effect on private rental housing; No effect on public housing" in 3
replace column2 = "Effect on owner-occupied housing; Effect on private rental housing; Effect on public housing equal to effect on private rental housing" in 4

g column3 = .
summ est1_1 [weight=ownerocc]
replace column3 =  r(mean) in 1
summ est2_1 [weight=ownerocc_rentalhousing]
replace column3 =  r(mean) in 2
summ est3_1 [weight=ownerocc_rentalhousing]
replace column3 =  r(mean) in 3
summ est4_1 [weight=totalunits]
replace column3 =  r(mean) in 4

g column4 = .
summ est1_2 [weight=ownerocc]
replace column4 =  r(mean) in 1
summ est2_2 [weight=ownerocc_rentalhousing]
replace column4 =  r(mean) in 2
summ est3_2 [weight=ownerocc_rentalhousing]
replace column4 =  r(mean) in 3
summ est4_2 [weight=totalunits]
replace column4 =  r(mean) in 4


g column5 = ""

g column6 = .
summ est1_3
replace column6 =  r(mean)*r(N)/1000000000 in 1
summ est2_3
replace column6 =  r(mean)*r(N)/1000000000 in 2
summ est3_3
replace column6 =  r(mean)*r(N)/1000000000 in 3
summ est4_3 
replace column6 =  r(mean)*r(N)/1000000000 in 4

g column7 = .
summ est1_4
replace column7 =  r(mean)*r(N)/1000000000 in 1
summ est2_4
replace column7 =  r(mean)*r(N)/1000000000 in 2
summ est3_4
replace column7 =  r(mean)*r(N)/1000000000 in 3
summ est4_4 
replace column7 =  r(mean)*r(N)/1000000000 in 4

keep column*
keep if _n<=4

export excel using "Results\Tables.xlsx", sheet("Table 5") sheetmodify cell(A1) firstrow(variables)
