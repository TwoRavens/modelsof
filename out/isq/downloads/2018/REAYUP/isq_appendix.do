version 11.0
set more off
capture log close
log using "isq_appendix.txt", text replace





*******************************************************************************
***** Replication code for                                                *****
***** Johannes Kleibl. "Tertiarization, Infustrial Adjustment, and the    *****
***** Domestic Politics of Foreign Aid." International Studies Quarterly. *****
***** October 3, 2011                                                     *****
*******************************************************************************




// read in data 
use "isq_data.dta", clear 
sort cow_dyadid year
tsset cow_dyadid year




// generate year, donor and recipient dummy variables
foreach num of numlist 1979(1)2001 {
quietly gen year`num' = 0
quietly replace year`num' = 1 if year == `num'
quietly label var year`num' "Dummy for `num'"
}
quietly tab cow_donor, gen(dond)
quietly tab cow_recipient, gen(recd)





*******************************************************************************
***** Table A1: Descriptive statistics.                                   ***** 
*******************************************************************************

sum laid0 Lldpop Llrpop Lldrgdppc Llrrgdppc lkmdist colony usaisr Lrpolity Lrconflict ///
    Lltotexp0 Llimp0pprb Llimp0ltmtht Lcempserclabf cempindclabfchy3 ///
	Lunemclabf Lunemclabfchy3 Lgenerosity Lleftc Ltcdemc if year >= 1980 & year <= 2001




	
	
	


*******************************************************************************
***** Table B1: Controlling for unemployment.                             *****
*******************************************************************************




// save list of independent variables that are included in all models
local indepvars "Lldpop Llrpop Lldrgdppc Llrrgdppc lkmdist colony usaisr Lrpolity Lrconflict Lunemclabf Lunemclabfchy3 Lcempserclabf cempindclabfchy3 Lltotexp0 Llimp0pprb"

/// Model 1 (without any interactions)
quietly tobit laid0 `indepvars' Llimp0ltmtht year1980-year2001 dond2-dond21 recd2-recd124 if year >= 1979, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Llimp0ltmtht year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 2 (interaction between exports and services employment)
quietly tobit laid0 `indepvars' Lcempserclabf_Lltotexp0 year1980-year2001 dond2-dond21 recd2-recd124 if year >= 1979, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Lcempserclabf_Lltotexp0 year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 3 (interaction between imports and services employment)
quietly tobit laid0 `indepvars' Lcempserclabf_Llimp0pprb year1980-year2001 dond2-dond21 recd2-recd124 if year >= 1979, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Lcempserclabf_Llimp0pprb year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 4 (interaction between recipients' GDPPC and services employment)
quietly tobit laid0 `indepvars' Lcempserclabf_Llrrgdppc year1980-year2001 dond2-dond21 recd2-recd124 if year >= 1979, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Lcempserclabf_Llrrgdppc year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res  

/// Model 5 (interaction between exports and change in industrial employment)
quietly tobit laid0 `indepvars' cempindclabfchy3_Lltotexp0 year1980-year2001 dond2-dond21 recd2-recd124 if year >= 1979, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' cempindclabfchy3_Lltotexp0 year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 6 (interaction between imports and change in industrial employment)
quietly tobit laid0 `indepvars' cempindclabfchy3_Llimp0pprb year1980-year2001 dond2-dond21 recd2-recd124 if year >= 1979, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' cempindclabfchy3_Llimp0pprb year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 7 (interaction between recipients' GDPPC and change in industrial employment)
quietly tobit laid0 `indepvars' cempindclabfchy3_Llrrgdppc year1980-year2001 dond2-dond21 recd2-recd124 if year >= 1979, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' cempindclabfchy3_Llrrgdppc year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res  	
		










*******************************************************************************
***** Table B2: Controlling for welfare state generosity.                 *****
***** (Note: There is no generosity data for Portugal, Spain and Greece.) *****
*******************************************************************************




// save list of independent variables that are included in all models
local indepvars "Lldpop Llrpop Lldrgdppc Llrrgdppc lkmdist colony usaisr Lrpolity Lrconflict Lgenerosity Lcempserclabf cempindclabfchy3 Lltotexp0 Llimp0pprb"

/// Model 1 (without any interactions)
quietly tobit laid0 `indepvars' Llimp0ltmtht year1980-year2001 dond2-dond8 dond11-dond13 dond15-dond21 recd2-recd124 if year >= 1979, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Llimp0ltmtht year1981-year2001 dond2-dond8 dond11-dond13 dond15-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 2 (interaction between exports and services employment)
quietly tobit laid0 `indepvars' Lcempserclabf_Lltotexp0 year1980-year2001 dond2-dond8 dond11-dond13 dond15-dond21 recd2-recd124 if year >= 1979, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Lcempserclabf_Lltotexp0 year1981-year2001 dond2-dond8 dond11-dond13 dond15-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 3 (interaction between imports and services employment)
quietly tobit laid0 `indepvars' Lcempserclabf_Llimp0pprb year1980-year2001 dond2-dond8 dond11-dond13 dond15-dond21 recd2-recd124 if year >= 1979, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Lcempserclabf_Llimp0pprb year1981-year2001 dond2-dond8 dond11-dond13 dond15-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 4 (interaction between recipients' GDPPC and services employment)
quietly tobit laid0 `indepvars' Lcempserclabf_Llrrgdppc year1980-year2001 dond2-dond8 dond11-dond13 dond15-dond21 recd2-recd124 if year >= 1979, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Lcempserclabf_Llrrgdppc year1981-year2001 dond2-dond8 dond11-dond13 dond15-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res  

/// Model 5 (interaction between exports and change in industrial employment)
quietly tobit laid0 `indepvars' cempindclabfchy3_Lltotexp0 year1980-year2001 dond2-dond8 dond11-dond13 dond15-dond21 recd2-recd124 if year >= 1979, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' cempindclabfchy3_Lltotexp0 year1981-year2001 dond2-dond8 dond11-dond13 dond15-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 6 (interaction between imports and change in industrial employment)
quietly tobit laid0 `indepvars' cempindclabfchy3_Llimp0pprb year1980-year2001 dond2-dond8 dond11-dond13 dond15-dond21 recd2-recd124 if year >= 1979, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' cempindclabfchy3_Llimp0pprb year1981-year2001 dond2-dond8 dond11-dond13 dond15-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 7 (interaction between recipients' GDPPC and change in industrial employment)
quietly tobit laid0 `indepvars' cempindclabfchy3_Llrrgdppc year1980-year2001 dond2-dond8 dond11-dond13 dond15-dond21 recd2-recd124 if year >= 1979, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' cempindclabfchy3_Llrrgdppc year1981-year2001 dond2-dond8 dond11-dond13 dond15-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res  
	









*******************************************************************************
***** Table B3: Controlling for government partisanship.                  *****
*******************************************************************************




// save list of independent variables that are included in all models
local indepvars "Lldpop Llrpop Lldrgdppc Llrrgdppc lkmdist colony usaisr Lrpolity Lrconflict Lleftc Ltcdemc Lcempserclabf cempindclabfchy3 Lltotexp0 Llimp0pprb"

/// Model 1 (without any interactions)
quietly tobit laid0 `indepvars' Llimp0ltmtht year1980-year2001 dond2-dond21 recd2-recd124 if year >= 1979, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Llimp0ltmtht year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 2 (interaction between exports and services employment)
quietly tobit laid0 `indepvars' Lcempserclabf_Lltotexp0 year1980-year2001 dond2-dond21 recd2-recd124 if year >= 1979, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Lcempserclabf_Lltotexp0 year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 3 (interaction between imports and services employment)
quietly tobit laid0 `indepvars' Lcempserclabf_Llimp0pprb year1980-year2001 dond2-dond21 recd2-recd124 if year >= 1979, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Lcempserclabf_Llimp0pprb year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 4 (interaction between recipients' GDPPC and services employment)
quietly tobit laid0 `indepvars' Lcempserclabf_Llrrgdppc year1980-year2001 dond2-dond21 recd2-recd124 if year >= 1979, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Lcempserclabf_Llrrgdppc year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res  

/// Model 5 (interaction between exports and change in industrial employment)
quietly tobit laid0 `indepvars' cempindclabfchy3_Lltotexp0 year1980-year2001 dond2-dond21 recd2-recd124 if year >= 1979, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' cempindclabfchy3_Lltotexp0 year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 6 (interaction between imports and change in industrial employment)
quietly tobit laid0 `indepvars' cempindclabfchy3_Llimp0pprb year1980-year2001 dond2-dond21 recd2-recd124 if year >= 1979, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' cempindclabfchy3_Llimp0pprb year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 7 (interaction between recipients' GDPPC and change in industrial employment)
quietly tobit laid0 `indepvars' cempindclabfchy3_Llrrgdppc year1980-year2001 dond2-dond21 recd2-recd124 if year >= 1979, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' cempindclabfchy3_Llrrgdppc year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res  
	










*******************************************************************************
***** Table B4: Lagged dependent variable.                                *****
*******************************************************************************




// save list of independent variables that are included in all models
local indepvars "Lldpop Llrpop Lldrgdppc Llrrgdppc lkmdist colony usaisr Lrpolity Lrconflict Lcempserclabf cempindclabfchy3 Lltotexp0 Llimp0pprb"

// generate LDV
quietly gen Llaid0 = L1.laid0 
quietly label var Llaid0 "Lagged ln foreign aid provision"

/// Model 1 (without any interactions)
tobit laid0 Llaid0 `indepvars' Llimp0ltmtht year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)
    
/// Model 2 (interaction between exports and services employment)
tobit laid0 Llaid0 `indepvars' Lcempserclabf_Lltotexp0 year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)
    
/// Model 3 (interaction between imports and services employment)
tobit laid0 Llaid0 `indepvars' Lcempserclabf_Llimp0pprb year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)
    
/// Model 4 (interaction between recipients' GDPPC and services employment)
tobit laid0 Llaid0 `indepvars' Lcempserclabf_Llrrgdppc year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)
    
/// Model 5 (interaction between exports and change in industrial employment)
tobit laid0 Llaid0 `indepvars' cempindclabfchy3_Lltotexp0 year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)
    
/// Model 6 (interaction between imports and change in industrial employment)
tobit laid0 Llaid0 `indepvars' cempindclabfchy3_Llimp0pprb year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)
    
/// Model 7 (interaction between recipients' GDPPC and change in industrial employment)
tobit laid0 Llaid0 `indepvars' cempindclabfchy3_Llrrgdppc year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)
    
quietly drop Llaid0





 
 
 
 








*******************************************************************************
***** Table B5: Exclusion of very large aid flows (>$100,000,000).        *****                               *****
***** (Note: US-Israel dummy not included, since the dyad is not included *****
***** in the sample.)                                                     *****  
*******************************************************************************




// save list of independent variables that are included in all models
local indepvars "Lldpop Llrpop Lldrgdppc Llrrgdppc lkmdist colony Lrpolity Lrconflict Lcempserclabf cempindclabfchy3 Lltotexp0 Llimp0pprb"

/// Model 1 (without any interactions)
quietly tobit laid0 `indepvars' Llimp0ltmtht year1980-year2001 dond2-dond21 recd2-recd124 if year >= 1979 & aid0 < 100000, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Llimp0ltmtht year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980 & aid0 < 100000, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 2 (interaction between exports and services employment)
quietly tobit laid0 `indepvars' Lcempserclabf_Lltotexp0 year1980-year2001 dond2-dond21 recd2-recd124 if year >= 1979 & aid0 < 100000, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Lcempserclabf_Lltotexp0 year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980 & aid0 < 100000, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 3 (interaction between imports and services employment)
quietly tobit laid0 `indepvars' Lcempserclabf_Llimp0pprb year1980-year2001 dond2-dond21 recd2-recd124 if year >= 1979 & aid0 < 100000, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Lcempserclabf_Llimp0pprb year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980 & aid0 < 100000, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 4 (interaction between recipients' GDPPC and services employment)
quietly tobit laid0 `indepvars' Lcempserclabf_Llrrgdppc year1980-year2001 dond2-dond21 recd2-recd124 if year >= 1979 & aid0 < 100000, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Lcempserclabf_Llrrgdppc year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980 & aid0 < 100000, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res  

/// Model 5 (interaction between exports and change in industrial employment)
quietly tobit laid0 `indepvars' cempindclabfchy3_Lltotexp0 year1980-year2001 dond2-dond21 recd2-recd124 if year >= 1979 & aid0 < 100000, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' cempindclabfchy3_Lltotexp0 year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980 & aid0 < 100000, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 6 (interaction between imports and change in industrial employment)
quietly tobit laid0 `indepvars' cempindclabfchy3_Llimp0pprb year1980-year2001 dond2-dond21 recd2-recd124 if year >= 1979 & aid0 < 100000, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' cempindclabfchy3_Llimp0pprb year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980 & aid0 < 100000, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 7 (interaction between recipients' GDPPC and change in industrial employment)
quietly tobit laid0 `indepvars' cempindclabfchy3_Llrrgdppc year1980-year2001 dond2-dond21 recd2-recd124 if year >= 1979 & aid0 < 100000, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' cempindclabfchy3_Llrrgdppc year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980 & aid0 < 100000, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res  
	










	
	
*******************************************************************************
***** Table B6: Exclusion of wealthy recipients (with an average          *****
***** GDPPC > $10,000).                                                   *****
***** (Note: US-Israel dummy not included, since the dyad is not included *****
***** in the sample.)                                                     *****  
*******************************************************************************




// save list of independent variables that are included in all models
local indepvars "Lldpop Llrpop Lldrgdppc Llrrgdppc lkmdist colony Lrpolity Lrconflict Lcempserclabf cempindclabfchy3 Lltotexp0 Llimp0pprb"

/// Model 1 (without any interactions)
quietly tobit laid0 `indepvars' Llimp0ltmtht year1980-year2001 dond2-dond21 recd3-recd5 recd8-recd25 recd27 recd29-recd33 recd36-recd56 recd58-recd76 recd78-recd80 recd82-recd89 recd92 recd98-recd119 recd121-recd124 if year >= 1979 & rec10000 == 0, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Llimp0ltmtht year1981-year2001 dond2-dond21 recd3-recd5 recd8-recd25 recd27 recd29-recd33 recd36-recd56 recd58-recd76 recd78-recd80 recd82-recd89 recd92 recd98-recd119 recd121-recd124 if year >= 1980 & rec10000 == 0, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 2 (interaction between exports and services employment)
quietly tobit laid0 `indepvars' Lcempserclabf_Lltotexp0 year1980-year2001 dond2-dond21 recd3-recd5 recd8-recd25 recd27 recd29-recd33 recd36-recd56 recd58-recd76 recd78-recd80 recd82-recd89 recd92 recd98-recd119 recd121-recd124 if year >= 1979 & rec10000 == 0, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Lcempserclabf_Lltotexp0 year1981-year2001 dond2-dond21 recd3-recd5 recd8-recd25 recd27 recd29-recd33 recd36-recd56 recd58-recd76 recd78-recd80 recd82-recd89 recd92 recd98-recd119 recd121-recd124 if year >= 1980 & rec10000 == 0, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 3 (interaction between imports and services employment)
quietly tobit laid0 `indepvars' Lcempserclabf_Llimp0pprb year1980-year2001 dond2-dond21 recd3-recd5 recd8-recd25 recd27 recd29-recd33 recd36-recd56 recd58-recd76 recd78-recd80 recd82-recd89 recd92 recd98-recd119 recd121-recd124 if year >= 1979 & rec10000 == 0, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Lcempserclabf_Llimp0pprb year1981-year2001 dond2-dond21 recd3-recd5 recd8-recd25 recd27 recd29-recd33 recd36-recd56 recd58-recd76 recd78-recd80 recd82-recd89 recd92 recd98-recd119 recd121-recd124 if year >= 1980 & rec10000 == 0, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 4 (interaction between recipients' GDPPC and services employment)
quietly tobit laid0 `indepvars' Lcempserclabf_Llrrgdppc year1980-year2001 dond2-dond21 recd3-recd5 recd8-recd25 recd27 recd29-recd33 recd36-recd56 recd58-recd76 recd78-recd80 recd82-recd89 recd92 recd98-recd119 recd121-recd124 if year >= 1979 & rec10000 == 0, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Lcempserclabf_Llrrgdppc year1981-year2001 dond2-dond21 recd3-recd5 recd8-recd25 recd27 recd29-recd33 recd36-recd56 recd58-recd76 recd78-recd80 recd82-recd89 recd92 recd98-recd119 recd121-recd124 if year >= 1980 & rec10000 == 0, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res  

/// Model 5 (interaction between exports and change in industrial employment)
quietly tobit laid0 `indepvars' cempindclabfchy3_Lltotexp0 year1980-year2001 dond2-dond21 recd3-recd5 recd8-recd25 recd27 recd29-recd33 recd36-recd56 recd58-recd76 recd78-recd80 recd82-recd89 recd92 recd98-recd119 recd121-recd124 if year >= 1979 & rec10000 == 0, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' cempindclabfchy3_Lltotexp0 year1981-year2001 dond2-dond21 recd3-recd5 recd8-recd25 recd27 recd29-recd33 recd36-recd56 recd58-recd76 recd78-recd80 recd82-recd89 recd92 recd98-recd119 recd121-recd124 if year >= 1980 & rec10000 == 0, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 6 (interaction between imports and change in industrial employment)
quietly tobit laid0 `indepvars' cempindclabfchy3_Llimp0pprb year1980-year2001 dond2-dond21 recd3-recd5 recd8-recd25 recd27 recd29-recd33 recd36-recd56 recd58-recd76 recd78-recd80 recd82-recd89 recd92 recd98-recd119 recd121-recd124 if year >= 1979 & rec10000 == 0, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' cempindclabfchy3_Llimp0pprb year1981-year2001 dond2-dond21 recd3-recd5 recd8-recd25 recd27 recd29-recd33 recd36-recd56 recd58-recd76 recd78-recd80 recd82-recd89 recd92 recd98-recd119 recd121-recd124 if year >= 1980 & rec10000 == 0, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 7 (interaction between recipients' GDPPC and change in industrial employment)
quietly tobit laid0 `indepvars' cempindclabfchy3_Llrrgdppc year1980-year2001 dond2-dond21 recd3-recd5 recd8-recd25 recd27 recd29-recd33 recd36-recd56 recd58-recd76 recd78-recd80 recd82-recd89 recd92 recd98-recd119 recd121-recd124 if year >= 1979 & rec10000 == 0, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' cempindclabfchy3_Llrrgdppc year1981-year2001 dond2-dond21 recd3-recd5 recd8-recd25 recd27 recd29-recd33 recd36-recd56 recd58-recd76 recd78-recd80 recd82-recd89 recd92 recd98-recd119 recd121-recd124 if year >= 1980 & rec10000 == 0, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res  
	







*******************************************************************************
***** Table B7: Resctricting sample to the Cold War era (1980–1989).      *****
***** (Note: Dummy variables for a number of recipients (Yugoslavia,      *****
***** South Africa, Cambodia and former Soviet Bloc states) not included, *****
***** since these countries receive 0 aid in all dyad years. Dummy        *****
***** variables for Portugal, Spain and Greece not included, since these  *****
***** countries only became donors during the 1990s.)                     ***** 
*******************************************************************************




// save list of independent variables that are included in all models
local indepvars "Lldpop Llrpop Lldrgdppc Llrrgdppc lkmdist colony usaisr Lrpolity Lrconflict Lcempserclabf cempindclabfchy3 Lltotexp0 Llimp0pprb"

/// Model 1 (without any interactions)
quietly tobit laid0 `indepvars' Llimp0ltmtht dond2-dond8 dond11-dond13 dond15-dond21 recd2-recd29 recd35 recd40-recd74 recd76-recd91 recd93-recd97 recd104-recd115 recd117-recd124 year1980 - year1989 if year >= 1979 & year < 1990, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Llimp0ltmtht dond2-dond8 dond11-dond13 dond15-dond21 recd2-recd29 recd35 recd40-recd74 recd76-recd91 recd93-recd97 recd104-recd115 recd117-recd124 year1981 - year1989 if year >= 1980 & year < 1990, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 2 (interaction between exports and services employment)
quietly tobit laid0 `indepvars' Lcempserclabf_Lltotexp0 dond2-dond8 dond11-dond13 dond15-dond21 recd2-recd29 recd35 recd40-recd74 recd76-recd91 recd93-recd97 recd104-recd115 recd117-recd124 year1980 - year1989 if year >= 1979 & year < 1990, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Lcempserclabf_Lltotexp0 dond2-dond8 dond11-dond13 dond15-dond21 recd2-recd29 recd35 recd40-recd74 recd76-recd91 recd93-recd97 recd104-recd115 recd117-recd124 year1981 - year1989 if year >= 1980 & year < 1990, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 3 (interaction between imports and services employment)
quietly tobit laid0 `indepvars' Lcempserclabf_Llimp0pprb dond2-dond8 dond11-dond13 dond15-dond21 recd2-recd29 recd35 recd40-recd74 recd76-recd91 recd93-recd97 recd104-recd115 recd117-recd124 year1980 - year1989 if year >= 1979 & year < 1990, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Lcempserclabf_Llimp0pprb dond2-dond8 dond11-dond13 dond15-dond21 recd2-recd29 recd35 recd40-recd74 recd76-recd91 recd93-recd97 recd104-recd115 recd117-recd124 year1981 - year1989 if year >= 1980 & year < 1990, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 4 (interaction between recipients' GDPPC and services employment)
quietly tobit laid0 `indepvars' Lcempserclabf_Llrrgdppc dond2-dond8 dond11-dond13 dond15-dond21 recd2-recd29 recd35 recd40-recd74 recd76-recd91 recd93-recd97 recd104-recd115 recd117-recd124 year1980 - year1989 if year >= 1979 & year < 1990, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Lcempserclabf_Llrrgdppc dond2-dond8 dond11-dond13 dond15-dond21 recd2-recd29 recd35 recd40-recd74 recd76-recd91 recd93-recd97 recd104-recd115 recd117-recd124 year1981 - year1989 if year >= 1980 & year < 1990, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res  

/// Model 5 (interaction between exports and change in industrial employment)
quietly tobit laid0 `indepvars' cempindclabfchy3_Lltotexp0 dond2-dond8 dond11-dond13 dond15-dond21 recd2-recd29 recd35 recd40-recd74 recd76-recd91 recd93-recd97 recd104-recd115 recd117-recd124 year1980 - year1989 if year >= 1979 & year < 1990, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' cempindclabfchy3_Lltotexp0 dond2-dond8 dond11-dond13 dond15-dond21 recd2-recd29 recd35 recd40-recd74 recd76-recd91 recd93-recd97 recd104-recd115 recd117-recd124 year1981 - year1989 if year >= 1980 & year < 1990, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 6 (interaction between imports and change in industrial employment)
quietly tobit laid0 `indepvars' cempindclabfchy3_Llimp0pprb dond2-dond8 dond11-dond13 dond15-dond21 recd2-recd29 recd35 recd40-recd74 recd76-recd91 recd93-recd97 recd104-recd115 recd117-recd124 year1980 - year1989 if year >= 1979 & year < 1990, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' cempindclabfchy3_Llimp0pprb dond2-dond8 dond11-dond13 dond15-dond21 recd2-recd29 recd35 recd40-recd74 recd76-recd91 recd93-recd97 recd104-recd115 recd117-recd124 year1981 - year1989 if year >= 1980 & year < 1990, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 7 (interaction between recipients' GDPPC and change in industrial employment)
quietly tobit laid0 `indepvars' cempindclabfchy3_Llrrgdppc dond2-dond8 dond11-dond13 dond15-dond21 recd2-recd29 recd35 recd40-recd74 recd76-recd91 recd93-recd97 recd104-recd115 recd117-recd124 year1980 - year1989 if year >= 1979 & year < 1990, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' cempindclabfchy3_Llrrgdppc dond2-dond8 dond11-dond13 dond15-dond21 recd2-recd29 recd35 recd40-recd74 recd76-recd91 recd93-recd97 recd104-recd115 recd117-recd124 year1981 - year1989 if year >= 1980 & year < 1990, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res  
	

	
	
	

	
	
	
	
*******************************************************************************
***** Table B8: Resctricting sample to the Post Cold War era (1990–2001). *****
***** (Note: Dummy variable for Lebanon not included, since the country   *****
***** drops out due to missing values during all Post Cold War years.)    *****
*******************************************************************************	
	
	
	

// save list of independent variables that are included in all models
local indepvars "Lldpop Llrpop Lldrgdppc Llrrgdppc lkmdist colony usaisr Lrpolity Lrconflict Lcempserclabf cempindclabfchy3 Lltotexp0 Llimp0pprb"

/// Model 1 (without any interactions)
quietly tobit laid0 `indepvars' Llimp0ltmtht dond2-dond21 recd2-recd87 recd89-recd124 year1990 - year2001 if year > 1988, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Llimp0ltmtht dond2-dond21 recd2-recd87 recd89-recd124 year1991 - year2001 if year > 1989, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 2 (interaction between exports and services employment)
quietly tobit laid0 `indepvars' Lcempserclabf_Lltotexp0 dond2-dond21 recd2-recd87 recd89-recd124 year1990 - year2001 if year > 1988, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Lcempserclabf_Lltotexp0 dond2-dond21 recd2-recd87 recd89-recd124 year1991 - year2001 if year > 1989, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 3 (interaction between imports and services employment)
quietly tobit laid0 `indepvars' Lcempserclabf_Llimp0pprb dond2-dond21 recd2-recd87 recd89-recd124 year1990 - year2001 if year > 1988, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Lcempserclabf_Llimp0pprb dond2-dond21 recd2-recd87 recd89-recd124 year1991 - year2001 if year > 1989, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 4 (interaction between recipients' GDPPC and services employment)
quietly tobit laid0 `indepvars' Lcempserclabf_Llrrgdppc dond2-dond21 recd2-recd87 recd89-recd124 year1990 - year2001 if year > 1988, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Lcempserclabf_Llrrgdppc dond2-dond21 recd2-recd87 recd89-recd124 year1991 - year2001 if year > 1989, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res  

/// Model 5 (interaction between exports and change in industrial employment)
quietly tobit laid0 `indepvars' cempindclabfchy3_Lltotexp0 dond2-dond21 recd2-recd87 recd89-recd124 year1990 - year2001 if year > 1988, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' cempindclabfchy3_Lltotexp0 dond2-dond21 recd2-recd87 recd89-recd124 year1991 - year2001 if year > 1989, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 6 (interaction between imports and change in industrial employment)
quietly tobit laid0 `indepvars' cempindclabfchy3_Llimp0pprb dond2-dond21 recd2-recd87 recd89-recd124 year1990 - year2001 if year > 1988, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' cempindclabfchy3_Llimp0pprb dond2-dond21 recd2-recd87 recd89-recd124 year1991 - year2001 if year > 1989, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 7 (interaction between recipients' GDPPC and change in industrial employment)
quietly tobit laid0 `indepvars' cempindclabfchy3_Llrrgdppc dond2-dond21 recd2-recd87 recd89-recd124 year1990 - year2001 if year > 1988, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' cempindclabfchy3_Llrrgdppc dond2-dond21 recd2-recd87 recd89-recd124 year1991 - year2001 if year > 1989, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res  
   
   
   
   
   
   
   
   

   
   
   
   
*******************************************************************************
***** Regional Groupwise Jackknife: Excluding the eight different         ***** 
***** geographical regions of recipients (as defined by their COW codes)  *****
***** one after another from the sample (see Pluemper and Neumayer 2006). *****
*******************************************************************************	   
   



*******************************************************************************
***** Table B9: Exclusion of North and Middle America (COW codes 0–99).   ***** 
*******************************************************************************	 




// save list of independent variables that are included in all models
local indepvars "Lldpop Llrpop Lldrgdppc Llrrgdppc lkmdist colony usaisr Lrpolity Lrconflict Lcempserclabf cempindclabfchy3 Lltotexp0 Llimp0pprb"

/// Model 1 (without any interactions)
quietly tobit laid0 `indepvars' Llimp0ltmtht year1980-year2001 dond2-dond21 recd17-recd124 if year >= 1979 & cow_recipient >= 100, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Llimp0ltmtht year1981-year2001 dond2-dond21 recd17-recd124 if year >= 1980 & cow_recipient >= 100, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 2 (interaction between exports and services employment)
quietly tobit laid0 `indepvars' Lcempserclabf_Lltotexp0 year1980-year2001 dond2-dond21 recd17-recd124 if year >= 1979 & cow_recipient >= 100, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Lcempserclabf_Lltotexp0 year1981-year2001 dond2-dond21 recd17-recd124 if year >= 1980 & cow_recipient >= 100, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 3 (interaction between imports and services employment)
quietly tobit laid0 `indepvars' Lcempserclabf_Llimp0pprb year1980-year2001 dond2-dond21 recd17-recd124 if year >= 1979 & cow_recipient >= 100, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Lcempserclabf_Llimp0pprb year1981-year2001 dond2-dond21 recd17-recd124 if year >= 1980 & cow_recipient >= 100, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 4 (interaction between recipients' GDPPC and services employment)
quietly tobit laid0 `indepvars' Lcempserclabf_Llrrgdppc year1980-year2001 dond2-dond21 recd17-recd124 if year >= 1979 & cow_recipient >= 100, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Lcempserclabf_Llrrgdppc year1981-year2001 dond2-dond21 recd17-recd124 if year >= 1980 & cow_recipient >= 100, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res  
  
/// Model 5 (interaction between exports and change in industrial employment)
quietly tobit laid0 `indepvars' cempindclabfchy3_Lltotexp0 year1980-year2001 dond2-dond21 recd17-recd124 if year >= 1979 & cow_recipient >= 100, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' cempindclabfchy3_Lltotexp0 year1981-year2001 dond2-dond21 recd17-recd124 if year >= 1980 & cow_recipient >= 100, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 6 (interaction between imports and change in industrial employment)
quietly tobit laid0 `indepvars' cempindclabfchy3_Llimp0pprb year1980-year2001 dond2-dond21 recd17-recd124 if year >= 1979 & cow_recipient >= 100, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' cempindclabfchy3_Llimp0pprb year1981-year2001 dond2-dond21 recd17-recd124 if year >= 1980 & cow_recipient >= 100, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 7 (interaction between recipients' GDPPC and change in industrial employment)
quietly tobit laid0 `indepvars' cempindclabfchy3_Llrrgdppc year1980-year2001 dond2-dond21 recd17-recd124 if year >= 1979 & cow_recipient >= 100, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' cempindclabfchy3_Llrrgdppc year1981-year2001 dond2-dond21 recd17-recd124 if year >= 1980 & cow_recipient >= 100, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res  
  
    

	
	
	
	

	
	
	
*******************************************************************************
***** Table B10: Exclusion of South America (COW codes 100–199).          ***** 
*******************************************************************************	 




// save list of independent variables that are included in all models
local indepvars "Lldpop Llrpop Lldrgdppc Llrrgdppc lkmdist colony usaisr Lrpolity Lrconflict Lcempserclabf cempindclabfchy3 Lltotexp0 Llimp0pprb"

/// Model 1 (without any interactions)
quietly tobit laid0 `indepvars' Llimp0ltmtht year1980-year2001 dond2-dond21 recd2-recd15 recd28-recd124 if year >= 1979 & (cow_recipient <= 99 | cow_recipient >= 200), ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Llimp0ltmtht year1981-year2001 dond2-dond21 recd2-recd15 recd28-recd124 if year >= 1980 & (cow_recipient <= 99 | cow_recipient >= 200), ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 2 (interaction between exports and services employment)
quietly tobit laid0 `indepvars' Lcempserclabf_Lltotexp0 year1980-year2001 dond2-dond21 recd2-recd15 recd28-recd124 if year >= 1979 & (cow_recipient <= 99 | cow_recipient >= 200), ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Lcempserclabf_Lltotexp0 year1981-year2001 dond2-dond21 recd2-recd15 recd28-recd124 if year >= 1980 & (cow_recipient <= 99 | cow_recipient >= 200), ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 3 (interaction between imports and services employment)
quietly tobit laid0 `indepvars' Lcempserclabf_Llimp0pprb year1980-year2001 dond2-dond21 recd2-recd15 recd28-recd124 if year >= 1979 & (cow_recipient <= 99 | cow_recipient >= 200), ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Lcempserclabf_Llimp0pprb year1981-year2001 dond2-dond21 recd2-recd15 recd28-recd124 if year >= 1980 & (cow_recipient <= 99 | cow_recipient >= 200), ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 4 (interaction between recipients' GDPPC and services employment)
quietly tobit laid0 `indepvars' Lcempserclabf_Llrrgdppc year1980-year2001 dond2-dond21 recd2-recd15 recd28-recd124 if year >= 1979 & (cow_recipient <= 99 | cow_recipient >= 200), ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Lcempserclabf_Llrrgdppc year1981-year2001 dond2-dond21 recd2-recd15 recd28-recd124 if year >= 1980 & (cow_recipient <= 99 | cow_recipient >= 200), ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res  

/// Model 5 (interaction between exports and change in industrial employment)
quietly tobit laid0 `indepvars' cempindclabfchy3_Lltotexp0 year1980-year2001 dond2-dond21 recd2-recd15 recd28-recd124 if year >= 1979 & (cow_recipient <= 99 | cow_recipient >= 200), ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' cempindclabfchy3_Lltotexp0 year1981-year2001 dond2-dond21 recd2-recd15 recd28-recd124 if year >= 1980 & (cow_recipient <= 99 | cow_recipient >= 200), ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 6 (interaction between imports and change in industrial employment)
quietly tobit laid0 `indepvars' cempindclabfchy3_Llimp0pprb year1980-year2001 dond2-dond21 recd2-recd15 recd28-recd124 if year >= 1979 & (cow_recipient <= 99 | cow_recipient >= 200), ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' cempindclabfchy3_Llimp0pprb year1981-year2001 dond2-dond21 recd2-recd15 recd28-recd124 if year >= 1980 & (cow_recipient <= 99 | cow_recipient >= 200), ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 7 (interaction between recipients' GDPPC and change in industrial employment)
quietly tobit laid0 `indepvars' cempindclabfchy3_Llrrgdppc year1980-year2001 dond2-dond21 recd2-recd15 recd28-recd124 if year >= 1979 & (cow_recipient <= 99 | cow_recipient >= 200), ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' cempindclabfchy3_Llrrgdppc year1981-year2001 dond2-dond21 recd2-recd15 recd28-recd124 if year >= 1980 & (cow_recipient <= 99 | cow_recipient >= 200), ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res  

	

	
	
	
	
	
	
	
	
*******************************************************************************
***** Table B11: Exclusion of East and South East Europe                  *****
***** (COW codes 338–373).                                                ***** 
*******************************************************************************	 




// save list of independent variables that are included in all models
local indepvars "Lldpop Llrpop Lldrgdppc Llrrgdppc lkmdist colony usaisr Lrpolity Lrconflict Lcempserclabf cempindclabfchy3 Lltotexp0 Llimp0pprb"

/// Model 1 (without any interactions)
quietly tobit laid0 `indepvars' Llimp0ltmtht year1980-year2001 dond2-dond21 recd2-recd27 recd40-recd124 if year >= 1979 & (cow_recipient <= 325 | cow_recipient >= 374), ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Llimp0ltmtht year1981-year2001 dond2-dond21 recd2-recd27 recd40-recd124 if year >= 1980 & (cow_recipient <= 325 | cow_recipient >= 374), ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 2 (interaction between exports and services employment)
quietly tobit laid0 `indepvars' Lcempserclabf_Lltotexp0 year1980-year2001 dond2-dond21 recd2-recd27 recd40-recd124 if year >= 1979 & (cow_recipient <= 325 | cow_recipient >= 374), ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Lcempserclabf_Lltotexp0 year1981-year2001 dond2-dond21 recd2-recd27 recd40-recd124 if year >= 1980 & (cow_recipient <= 325 | cow_recipient >= 374), ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 3 (interaction between imports and services employment)
quietly tobit laid0 `indepvars' Lcempserclabf_Llimp0pprb year1980-year2001 dond2-dond21 recd2-recd27 recd40-recd124 if year >= 1979 & (cow_recipient <= 325 | cow_recipient >= 374), ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Lcempserclabf_Llimp0pprb year1981-year2001 dond2-dond21 recd2-recd27 recd40-recd124 if year >= 1980 & (cow_recipient <= 325 | cow_recipient >= 374), ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 4 (interaction between recipients' GDPPC and services employment)
quietly tobit laid0 `indepvars' Lcempserclabf_Llrrgdppc year1980-year2001 dond2-dond21 recd2-recd27 recd40-recd124 if year >= 1979 & (cow_recipient <= 325 | cow_recipient >= 374), ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Lcempserclabf_Llrrgdppc year1981-year2001 dond2-dond21 recd2-recd27 recd40-recd124 if year >= 1980 & (cow_recipient <= 325 | cow_recipient >= 374), ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res  

/// Model 5 (interaction between exports and change in industrial employment)
quietly tobit laid0 `indepvars' cempindclabfchy3_Lltotexp0 year1980-year2001 dond2-dond21 recd2-recd27 recd40-recd124 if year >= 1979 & (cow_recipient <= 325 | cow_recipient >= 374), ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' cempindclabfchy3_Lltotexp0 year1981-year2001 dond2-dond21 recd2-recd27 recd40-recd124 if year >= 1980 & (cow_recipient <= 325 | cow_recipient >= 374), ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 6 (interaction between imports and change in industrial employment)
quietly tobit laid0 `indepvars' cempindclabfchy3_Llimp0pprb year1980-year2001 dond2-dond21 recd2-recd27 recd40-recd124 if year >= 1979 & (cow_recipient <= 325 | cow_recipient >= 374), ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' cempindclabfchy3_Llimp0pprb year1981-year2001 dond2-dond21 recd2-recd27 recd40-recd124 if year >= 1980 & (cow_recipient <= 325 | cow_recipient >= 374), ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 7 (interaction between recipients' GDPPC and change in industrial employment)
quietly tobit laid0 `indepvars' cempindclabfchy3_Llrrgdppc year1980-year2001 dond2-dond21 recd2-recd27 recd40-recd124 if year >= 1979 & (cow_recipient <= 325 | cow_recipient >= 374), ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' cempindclabfchy3_Llrrgdppc year1981-year2001 dond2-dond21 recd2-recd27 recd40-recd124 if year >= 1980 & (cow_recipient <= 325 | cow_recipient >= 374), ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res  
	
  

  
  
  
  
  
  
  
  
	
*******************************************************************************
***** Table B12: Exclusion of Central Africa (COW codes 400–499).         *****
*******************************************************************************	 




// save list of independent variables that are included in all models  
local indepvars "Lldpop Llrpop Lldrgdppc Llrrgdppc lkmdist colony usaisr Lrpolity Lrconflict Lcempserclabf cempindclabfchy3 Lltotexp0 Llimp0pprb"

/// Model 1 (without any interactions)
quietly tobit laid0 `indepvars' Llimp0ltmtht year1980-year2001 dond2-dond21 recd2-recd39 recd62-recd124 if year >= 1979 & (cow_recipient <= 399 | cow_recipient >= 500), ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Llimp0ltmtht year1981-year2001 dond2-dond21 recd2-recd39 recd62-recd124 if year >= 1980 & (cow_recipient <= 399 | cow_recipient >= 500), ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 2 (interaction between exports and services employment)
quietly tobit laid0 `indepvars' Lcempserclabf_Lltotexp0 year1980-year2001 dond2-dond21 recd2-recd39 recd62-recd124 if year >= 1979 & (cow_recipient <= 399 | cow_recipient >= 500), ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Lcempserclabf_Lltotexp0 year1981-year2001 dond2-dond21 recd2-recd39 recd62-recd124 if year >= 1980 & (cow_recipient <= 399 | cow_recipient >= 500), ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 3 (interaction between imports and services employment)
quietly tobit laid0 `indepvars' Lcempserclabf_Llimp0pprb year1980-year2001 dond2-dond21 recd2-recd39 recd62-recd124 if year >= 1979 & (cow_recipient <= 399 | cow_recipient >= 500), ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Lcempserclabf_Llimp0pprb year1981-year2001 dond2-dond21 recd2-recd39 recd62-recd124 if year >= 1980 & (cow_recipient <= 399 | cow_recipient >= 500), ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 4 (interaction between recipients' GDPPC and services employment)
quietly tobit laid0 `indepvars' Lcempserclabf_Llrrgdppc year1980-year2001 dond2-dond21 recd2-recd39 recd62-recd124 if year >= 1979 & (cow_recipient <= 399 | cow_recipient >= 500), ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Lcempserclabf_Llrrgdppc year1981-year2001 dond2-dond21 recd2-recd39 recd62-recd124 if year >= 1980 & (cow_recipient <= 399 | cow_recipient >= 500), ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res  

/// Model 5 (interaction between exports and change in industrial employment)
quietly tobit laid0 `indepvars' cempindclabfchy3_Lltotexp0 year1980-year2001 dond2-dond21 recd2-recd39 recd62-recd124 if year >= 1979 & (cow_recipient <= 399 | cow_recipient >= 500), ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' cempindclabfchy3_Lltotexp0 year1981-year2001 dond2-dond21 recd2-recd39 recd62-recd124 if year >= 1980 & (cow_recipient <= 399 | cow_recipient >= 500), ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 6 (interaction between imports and change in industrial employment)
quietly tobit laid0 `indepvars' cempindclabfchy3_Llimp0pprb year1980-year2001 dond2-dond21 recd2-recd39 recd62-recd124 if year >= 1979 & (cow_recipient <= 399 | cow_recipient >= 500), ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' cempindclabfchy3_Llimp0pprb year1981-year2001 dond2-dond21 recd2-recd39 recd62-recd124 if year >= 1980 & (cow_recipient <= 399 | cow_recipient >= 500), ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 7 (interaction between recipients' GDPPC and change in industrial employment)
quietly tobit laid0 `indepvars' cempindclabfchy3_Llrrgdppc year1980-year2001 dond2-dond21 recd2-recd39 recd62-recd124 if year >= 1979 & (cow_recipient <= 399 | cow_recipient >= 500), ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' cempindclabfchy3_Llrrgdppc year1981-year2001 dond2-dond21 recd2-recd39 recd62-recd124 if year >= 1980 & (cow_recipient <= 399 | cow_recipient >= 500), ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res  
	
	

	
	
	
	
	
	
	
*******************************************************************************
***** Table B13: Exclusion of Southern Africa (COW codes 500–599).        *****
*******************************************************************************	 




// save list of independent variables that are included in all models  	
local indepvars "Lldpop Llrpop Lldrgdppc Llrrgdppc lkmdist colony usaisr Lrpolity Lrconflict Lcempserclabf cempindclabfchy3 Lltotexp0 Llimp0pprb"

/// Model 1 (without any interactions)
quietly tobit laid0 `indepvars' Llimp0ltmtht year1980-year2001 dond2-dond21 recd2-recd61 recd78-recd124 if year >= 1979 & (cow_recipient <= 499 | cow_recipient >= 600), ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Llimp0ltmtht year1981-year2001 dond2-dond21 recd2-recd61 recd78-recd124 if year >= 1980 & (cow_recipient <= 499 | cow_recipient >= 600), ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 2 (interaction between exports and services employment)
quietly tobit laid0 `indepvars' Lcempserclabf_Lltotexp0 year1980-year2001 dond2-dond21 recd2-recd61 recd78-recd124 if year >= 1979 & (cow_recipient <= 499 | cow_recipient >= 600), ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Lcempserclabf_Lltotexp0 year1981-year2001 dond2-dond21 recd2-recd61 recd78-recd124 if year >= 1980 & (cow_recipient <= 499 | cow_recipient >= 600), ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 3 (interaction between imports and services employment)
quietly tobit laid0 `indepvars' Lcempserclabf_Llimp0pprb year1980-year2001 dond2-dond21 recd2-recd61 recd78-recd124 if year >= 1979 & (cow_recipient <= 499 | cow_recipient >= 600), ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Lcempserclabf_Llimp0pprb year1981-year2001 dond2-dond21 recd2-recd61 recd78-recd124 if year >= 1980 & (cow_recipient <= 499 | cow_recipient >= 600), ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 4 (interaction between recipients' GDPPC and services employment)
quietly tobit laid0 `indepvars' Lcempserclabf_Llrrgdppc year1980-year2001 dond2-dond21 recd2-recd61 recd78-recd124 if year >= 1979 & (cow_recipient <= 499 | cow_recipient >= 600), ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Lcempserclabf_Llrrgdppc year1981-year2001 dond2-dond21 recd2-recd61 recd78-recd124 if year >= 1980 & (cow_recipient <= 499 | cow_recipient >= 600), ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res  

/// Model 5 (interaction between exports and change in industrial employment)
quietly tobit laid0 `indepvars' cempindclabfchy3_Lltotexp0 year1980-year2001 dond2-dond21 recd2-recd61 recd78-recd124 if year >= 1979 & (cow_recipient <= 499 | cow_recipient >= 600), ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' cempindclabfchy3_Lltotexp0 year1981-year2001 dond2-dond21 recd2-recd61 recd78-recd124 if year >= 1980 & (cow_recipient <= 499 | cow_recipient >= 600), ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 6 (interaction between imports and change in industrial employment)
quietly tobit laid0 `indepvars' cempindclabfchy3_Llimp0pprb year1980-year2001 dond2-dond21 recd2-recd61 recd78-recd124 if year >= 1979 & (cow_recipient <= 499 | cow_recipient >= 600), ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' cempindclabfchy3_Llimp0pprb year1981-year2001 dond2-dond21 recd2-recd61 recd78-recd124 if year >= 1980 & (cow_recipient <= 499 | cow_recipient >= 600), ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 7 (interaction between recipients' GDPPC and change in industrial employment)
quietly tobit laid0 `indepvars' cempindclabfchy3_Llrrgdppc year1980-year2001 dond2-dond21 recd2-recd61 recd78-recd124 if year >= 1979 & (cow_recipient <= 499 | cow_recipient >= 600), ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' cempindclabfchy3_Llrrgdppc year1981-year2001 dond2-dond21 recd2-recd61 recd78-recd124 if year >= 1980 & (cow_recipient <= 499 | cow_recipient >= 600), ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res  
	
  

  
  
  

  
  
  
*******************************************************************************
***** Table B14: Exclusion of Northern Africa and Middle East             *****
***** (COW codes 600–699).                                                *****
***** (Note: US-Israel dummy not included, since Israel is not part of    *****
***** the sample.)                                                        *****
*******************************************************************************	 




// save list of independent variables that are included in all models    
local indepvars "Lldpop Llrpop Lldrgdppc Llrrgdppc lkmdist colony Lrpolity Lrconflict Lcempserclabf cempindclabfchy3 Lltotexp0 Llimp0pprb"

/// Model 1 (without any interactions)
quietly tobit laid0 `indepvars' Llimp0ltmtht year1980-year2001 dond2-dond21 recd2-recd77 recd98-recd124 if year >= 1979 & (cow_recipient <= 599 | cow_recipient >= 700), ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Llimp0ltmtht year1981-year2001 dond2-dond21 recd2-recd77 recd98-recd124 if year >= 1980 & (cow_recipient <= 599 | cow_recipient >= 700), ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 2 (interaction between exports and services employment)
quietly tobit laid0 `indepvars' Lcempserclabf_Lltotexp0 year1980-year2001 dond2-dond21 recd2-recd77 recd98-recd124 if year >= 1979 & (cow_recipient <= 599 | cow_recipient >= 700), ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Lcempserclabf_Lltotexp0 year1981-year2001 dond2-dond21 recd2-recd77 recd98-recd124 if year >= 1980 & (cow_recipient <= 599 | cow_recipient >= 700), ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 3 (interaction between imports and services employment)
quietly tobit laid0 `indepvars' Lcempserclabf_Llimp0pprb year1980-year2001 dond2-dond21 recd2-recd77 recd98-recd124 if year >= 1979 & (cow_recipient <= 599 | cow_recipient >= 700), ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Lcempserclabf_Llimp0pprb year1981-year2001 dond2-dond21 recd2-recd77 recd98-recd124 if year >= 1980 & (cow_recipient <= 599 | cow_recipient >= 700), ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 4 (interaction between recipients' GDPPC and services employment)
quietly tobit laid0 `indepvars' Lcempserclabf_Llrrgdppc year1980-year2001 dond2-dond21 recd2-recd77 recd98-recd124 if year >= 1979 & (cow_recipient <= 599 | cow_recipient >= 700), ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Lcempserclabf_Llrrgdppc year1981-year2001 dond2-dond21 recd2-recd77 recd98-recd124 if year >= 1980 & (cow_recipient <= 599 | cow_recipient >= 700), ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res  

/// Model 5 (interaction between exports and change in industrial employment)
quietly tobit laid0 `indepvars' cempindclabfchy3_Lltotexp0 year1980-year2001 dond2-dond21 recd2-recd77 recd98-recd124 if year >= 1979 & (cow_recipient <= 599 | cow_recipient >= 700), ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' cempindclabfchy3_Lltotexp0 year1981-year2001 dond2-dond21 recd2-recd77 recd98-recd124 if year >= 1980 & (cow_recipient <= 599 | cow_recipient >= 700), ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 6 (interaction between imports and change in industrial employment)
quietly tobit laid0 `indepvars' cempindclabfchy3_Llimp0pprb year1980-year2001 dond2-dond21 recd2-recd77 recd98-recd124 if year >= 1979 & (cow_recipient <= 599 | cow_recipient >= 700), ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' cempindclabfchy3_Llimp0pprb year1981-year2001 dond2-dond21 recd2-recd77 recd98-recd124 if year >= 1980 & (cow_recipient <= 599 | cow_recipient >= 700), ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 7 (interaction between recipients' GDPPC and change in industrial employment)
quietly tobit laid0 `indepvars' cempindclabfchy3_Llrrgdppc year1980-year2001 dond2-dond21 recd2-recd77 recd98-recd124 if year >= 1979 & (cow_recipient <= 599 | cow_recipient >= 700), ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' cempindclabfchy3_Llrrgdppc year1981-year2001 dond2-dond21 recd2-recd77 recd98-recd124 if year >= 1980 & (cow_recipient <= 599 | cow_recipient >= 700), ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 
	


	
	
	
	
	

	
*******************************************************************************
***** Table B15: Exclusion of Central, South and East Asia                *****
***** (COW codes 700–799).                                                *****
*******************************************************************************	 




// save list of independent variables that are included in all models   	
local indepvars "Lldpop Llrpop Lldrgdppc Llrrgdppc lkmdist colony usaisr Lrpolity Lrconflict Lcempserclabf cempindclabfchy3 Lltotexp0 Llimp0pprb"

/// Model 1 (without any interactions)
quietly tobit laid0 `indepvars' Llimp0ltmtht year1980-year2001 dond2-dond21 recd2-recd97 recd115-recd124 if year >= 1979 & (cow_recipient <= 699 | cow_recipient >= 800), ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Llimp0ltmtht year1981-year2001 dond2-dond21 recd2-recd97 recd115-recd124 if year >= 1980 & (cow_recipient <= 699 | cow_recipient >= 800), ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 2 (interaction between exports and services employment)
quietly tobit laid0 `indepvars' Lcempserclabf_Lltotexp0 year1980-year2001 dond2-dond21 recd2-recd97 recd115-recd124 if year >= 1979 & (cow_recipient <= 699 | cow_recipient >= 800), ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Lcempserclabf_Lltotexp0 year1981-year2001 dond2-dond21 recd2-recd97 recd115-recd124 if year >= 1980 & (cow_recipient <= 699 | cow_recipient >= 800), ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 3 (interaction between imports and services employment)
quietly tobit laid0 `indepvars' Lcempserclabf_Llimp0pprb year1980-year2001 dond2-dond21 recd2-recd97 recd115-recd124 if year >= 1979 & (cow_recipient <= 699 | cow_recipient >= 800), ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Lcempserclabf_Llimp0pprb year1981-year2001 dond2-dond21 recd2-recd97 recd115-recd124 if year >= 1980 & (cow_recipient <= 699 | cow_recipient >= 800), ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 4 (interaction between recipients' GDPPC and services employment)
quietly tobit laid0 `indepvars' Lcempserclabf_Llrrgdppc year1980-year2001 dond2-dond21 recd2-recd97 recd115-recd124 if year >= 1979 & (cow_recipient <= 699 | cow_recipient >= 800), ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Lcempserclabf_Llrrgdppc year1981-year2001 dond2-dond21 recd2-recd97 recd115-recd124 if year >= 1980 & (cow_recipient <= 699 | cow_recipient >= 800), ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res  

/// Model 5 (interaction between exports and change in industrial employment)
quietly tobit laid0 `indepvars' cempindclabfchy3_Lltotexp0 year1980-year2001 dond2-dond21 recd2-recd97 recd115-recd124 if year >= 1979 & (cow_recipient <= 699 | cow_recipient >= 800), ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' cempindclabfchy3_Lltotexp0 year1981-year2001 dond2-dond21 recd2-recd97 recd115-recd124 if year >= 1980 & (cow_recipient <= 699 | cow_recipient >= 800), ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 6 (interaction between imports and change in industrial employment)
quietly tobit laid0 `indepvars' cempindclabfchy3_Llimp0pprb year1980-year2001 dond2-dond21 recd2-recd97 recd115-recd124 if year >= 1979 & (cow_recipient <= 699 | cow_recipient >= 800), ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' cempindclabfchy3_Llimp0pprb year1981-year2001 dond2-dond21 recd2-recd97 recd115-recd124 if year >= 1980 & (cow_recipient <= 699 | cow_recipient >= 800), ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 7 (interaction between recipients' GDPPC and change in industrial employment)
quietly tobit laid0 `indepvars' cempindclabfchy3_Llrrgdppc year1980-year2001 dond2-dond21 recd2-recd97 recd115-recd124 if year >= 1979 & (cow_recipient <= 699 | cow_recipient >= 800), ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' cempindclabfchy3_Llrrgdppc year1981-year2001 dond2-dond21 recd2-recd97 recd115-recd124 if year >= 1980 & (cow_recipient <= 699 | cow_recipient >= 800), ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res  

	

	
	
	
	
	
	
	
*******************************************************************************
***** Table B16: Exclusion of South East Asia and Oceania                 *****
***** (COW codes 800–950).                                                *****
*******************************************************************************	 




// save list of independent variables that are included in all models  	
local indepvars "Lldpop Llrpop Lldrgdppc Llrrgdppc lkmdist colony usaisr Lrpolity Lrconflict Lcempserclabf cempindclabfchy3 Lltotexp0 Llimp0pprb"

/// Model 1 (without any interactions)
quietly tobit laid0 `indepvars' Llimp0ltmtht year1980-year2001 dond2-dond21 recd2-recd114 if year >= 1979 & cow_recipient <= 799, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Llimp0ltmtht year1981-year2001 dond2-dond21 recd2-recd114 if year >= 1980 & cow_recipient <= 799, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 2 (interaction between exports and services employment)
quietly tobit laid0 `indepvars' Lcempserclabf_Lltotexp0 year1980-year2001 dond2-dond21 recd2-recd114 if year >= 1979 & cow_recipient <= 799, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Lcempserclabf_Lltotexp0 year1981-year2001 dond2-dond21 recd2-recd114 if year >= 1980 & cow_recipient <= 799, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 3 (interaction between imports and services employment)
quietly tobit laid0 `indepvars' Lcempserclabf_Llimp0pprb year1980-year2001 dond2-dond21 recd2-recd114 if year >= 1979 & cow_recipient <= 799, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Lcempserclabf_Llimp0pprb year1981-year2001 dond2-dond21 recd2-recd114 if year >= 1980 & cow_recipient <= 799, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 4 (interaction between recipients' GDPPC and services employment)
quietly tobit laid0 `indepvars' Lcempserclabf_Llrrgdppc year1980-year2001 dond2-dond21 recd2-recd114 if year >= 1979 & cow_recipient <= 799, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Lcempserclabf_Llrrgdppc year1981-year2001 dond2-dond21 recd2-recd114 if year >= 1980 & cow_recipient <= 799, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res  

/// Model 5 (interaction between exports and change in industrial employment)
quietly tobit laid0 `indepvars' cempindclabfchy3_Lltotexp0 year1980-year2001 dond2-dond21 recd2-recd114 if year >= 1979 & cow_recipient <= 799, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' cempindclabfchy3_Lltotexp0 year1981-year2001 dond2-dond21 recd2-recd114 if year >= 1980 & cow_recipient <= 799, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 6 (interaction between imports and change in industrial employment)
quietly tobit laid0 `indepvars' cempindclabfchy3_Llimp0pprb year1980-year2001 dond2-dond21 recd2-recd114 if year >= 1979 & cow_recipient <= 799, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' cempindclabfchy3_Llimp0pprb year1981-year2001 dond2-dond21 recd2-recd114 if year >= 1980 & cow_recipient <= 799, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

/// Model 7 (interaction between recipients' GDPPC and change in industrial employment)
quietly tobit laid0 `indepvars' cempindclabfchy3_Llrrgdppc year1980-year2001 dond2-dond21 recd2-recd114 if year >= 1979 & cow_recipient <= 799, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' cempindclabfchy3_Llrrgdppc year1981-year2001 dond2-dond21 recd2-recd114 if year >= 1980 & cow_recipient <= 799, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res  	

	
	
	
log close












*** 14 Bootstraps: 
* Aid variable, Model 1
* Aid variable, Model 2
* Aid variable, Model 3
* Aid variable, Model 4
* Aid variable, Model 5
* Aid variable, Model 4
* Aid variable, Model 7
* Trade variables, Model 1
* Trade variables, Model 2
* Trade variables, Model 3
* Trade variables, Model 4
* Trade variables, Model 5
* Trade variables, Model 6
* Trade variables, Model 7






*******************************************************************************
***** Table B17: Resampling of zero values on the foreign aid provision   *****
***** variable (based on Models 1 to 7 in Table 1).                       *****
*******************************************************************************	 





log using "isq_bootstrap_aid_model1.txt", text replace

*******************************************************************************
***** Table B17: Model 1.                                                 *****
***** Randomly replacing 20% of zero values on the foreign aid provision  *****
***** variable with missing values. Resampling is repeated 250 times.     ***** 
*******************************************************************************	 




// read in data 
use "isq_data.dta", clear 
sort cow_dyadid year
tsset cow_dyadid year

// generate year, donor and recipient dummy variables
foreach num of numlist 1979(1)2001 {
quietly gen year`num' = 0
quietly replace year`num' = 1 if year == `num'
quietly label var year`num' "Dummy for `num'"
}
quietly tab cow_donor, gen(dond)
quietly tab cow_recipient, gen(recd)

// save list of independent variables that are included in all models  	
local indepvars "Lldpop Llrpop Lldrgdppc Llrrgdppc lkmdist colony usaisr Lrpolity Lrconflict Lcempserclabf cempindclabfchy3 Lltotexp0 Llimp0pprb"

// run the models for the 250 samples and save the results
set more off
set seed 1010101 // set seed to allow for exact replication

gen aid_0_1 = 0 if year >= 1979
replace aid_0_1 = 1 if aid0 != 0 & year >= 1979
tab aid_0_1 if year >= 1979, miss // 18490 zeros (out of 50227 observations)

gen bootstrap_no  = _n
gen b_Llrrgdppc   = .
gen se_Llrrgdppc  = .
gen t_Llrrgdppc   = .
gen b_Lltotexp0   = .
gen se_Lltotexp0  = .
gen t_Lltotexp0   = .
gen b_Llimp0pprb  = .
gen se_Llimp0pprb = .
gen t_Llimp0pprb  = .
gen b_Llimp0ltmtht  = .
gen se_Llimp0ltmtht = .
gen t_Llimp0ltmtht  = .

foreach num of numlist 1/250 {

display "Start: Resampling No " `num'

gen laid0_m`num' = laid0 if year >= 1979
gen random_m`num' = uniform() if aid0 == 0 & year >= 1979
sort aid_0_1 random_m`num'
replace laid0_m`num' = . in 1/3698 // 3698 observations = 20% of the missing values

sort cow_dyadid year
tsset cow_dyadid year

quietly tobit laid0_m`num' `indepvars' Llimp0ltmtht year1980-year2001 dond2-dond21 recd2-recd124 if year >= 1979, ll(0) vce(cluster cow_dyadid)
    quietly quietly predict xb, xb
    quietly gen laid0_res = laid0_m`num' - xb 
    quietly quietly gen L1laid0_res = L1.laid0_res
tobit laid0_m`num' L1laid0_res `indepvars' Llimp0ltmtht year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)

replace b_Llrrgdppc  = _b[Llrrgdppc]  if bootstrap_no == `num'
replace se_Llrrgdppc = _se[Llrrgdppc] if bootstrap_no ==`num'
replace t_Llrrgdppc  = _b[Llrrgdppc] / _se[Llrrgdppc]  if bootstrap_no== `num'

replace b_Lltotexp0  = _b[Lltotexp0]  if bootstrap_no ==`num'
replace se_Lltotexp0 = _se[Lltotexp0] if bootstrap_no ==`num'
replace t_Lltotexp0  = _b[Lltotexp0] / _se[Lltotexp0]  if bootstrap_no ==`num'

replace b_Llimp0pprb  = _b[Llimp0pprb]  if bootstrap_no ==`num'
replace se_Llimp0pprb = _se[Llimp0pprb] if bootstrap_no ==`num'
replace t_Llimp0pprb  = _b[Llimp0pprb] / _se[Llimp0pprb]  if bootstrap_no ==`num'

replace b_Llimp0ltmtht  = _b[Llimp0ltmtht]  if bootstrap_no ==`num'
replace se_Llimp0ltmtht = _se[Llimp0ltmtht] if bootstrap_no ==`num'
replace t_Llimp0ltmtht  = _b[Llimp0ltmtht] / _se[Llimp0ltmtht]  if bootstrap_no ==`num'

    quietly quietly drop xb laid0_res L1laid0_res laid0_m`num' random_m`num'

save "bootstrap_data\bootstrap_aid_model1.dta", replace
log close
log using "isq_bootstrap_aid_model1.txt", text append
} 

    quietly drop cow_dyadid -  aid_0_1 

save "bootstrap_data\bootstrap_aid_model1.dta", replace

log close


// display summary statistics for the results for the 250 samples

log using "isq_bootstrap_aid_model1_sum.txt", text replace

use "bootstrap_data\bootstrap_aid_model1.dta", clear

sum b_Llrrgdppc  t_Llrrgdppc 
sum b_Lltotexp0  t_Lltotexp0  
sum b_Llimp0pprb t_Llimp0pprb  
sum b_Llimp0ltmtht t_Llimp0ltmtht

tab t_Llrrgdppc  if t_Llrrgdppc  > -1.96
tab t_Lltotexp0  if t_Lltotexp0  <  1.96
tab t_Llimp0pprb if t_Llimp0pprb <  1.96
tab t_Llimp0ltmtht if t_Llimp0ltmtht > 1.96
tab t_Llimp0ltmtht if t_Llimp0ltmtht < -1.96

log close














log using "isq_bootstrap_aid_model2.txt", text replace

*******************************************************************************
***** Table B17: Model 2.                                                 *****
***** Randomly replacing 20% of zero values on the foreign aid provision  *****
***** variable with missing values. Resampling is repeated 250 times.     ***** 
*******************************************************************************	 




// read in data 
use "isq_data.dta", clear 
sort cow_dyadid year
tsset cow_dyadid year

// generate year, donor and recipient dummy variables
foreach num of numlist 1979(1)2001 {
quietly gen year`num' = 0
quietly replace year`num' = 1 if year == `num'
quietly label var year`num' "Dummy for `num'"
}
quietly tab cow_donor, gen(dond)
quietly tab cow_recipient, gen(recd)

// save list of independent variables that are included in all models  	
local indepvars "Lldpop Llrpop Lldrgdppc Llrrgdppc lkmdist colony usaisr Lrpolity Lrconflict Lcempserclabf cempindclabfchy3 Lltotexp0 Llimp0pprb"

// run the models for the 250 samples and save the results
set more off
set seed 1010101 // set seed to allow for exact replication

gen aid_0_1 = 0 if year >= 1979
replace aid_0_1 = 1 if aid0 != 0 & year >= 1979
tab aid_0_1 if year >= 1979, miss // 18490 zeros (out of 50227 observations)

gen bootstrap_no  = _n
gen b_Llrrgdppc   = .
gen se_Llrrgdppc  = .
gen t_Llrrgdppc   = .
gen b_Lltotexp0   = .
gen se_Lltotexp0  = .
gen t_Lltotexp0   = .
gen b_Llimp0pprb  = .
gen se_Llimp0pprb = .
gen t_Llimp0pprb  = .
gen b_Lcempserclabf_Lltotexp0  = .
gen se_Lcempserclabf_Lltotexp0 = .
gen t_Lcempserclabf_Lltotexp0  = .

foreach num of numlist 1/250 {

display "Start: Resampling No " `num'

gen laid0_m`num' = laid0 if year >= 1979
gen random_m`num' = uniform() if aid0 == 0 & year >= 1979
sort aid_0_1 random_m`num'
replace laid0_m`num' = . in 1/3698 // 3698 observations = 20% of the missing values

sort cow_dyadid year
tsset cow_dyadid year

quietly tobit laid0_m`num' `indepvars' Lcempserclabf_Lltotexp0 year1980-year2001 dond2-dond21 recd2-recd124 if year >= 1979, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    gen laid0_res = laid0_m`num' - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0_m`num' L1laid0_res `indepvars' Lcempserclabf_Lltotexp0 year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)

replace b_Llrrgdppc  = _b[Llrrgdppc]  if bootstrap_no == `num'
replace se_Llrrgdppc = _se[Llrrgdppc] if bootstrap_no ==`num'
replace t_Llrrgdppc  = _b[Llrrgdppc] / _se[Llrrgdppc]  if bootstrap_no== `num'

replace b_Lltotexp0  = _b[Lltotexp0]  if bootstrap_no ==`num'
replace se_Lltotexp0 = _se[Lltotexp0] if bootstrap_no ==`num'
replace t_Lltotexp0  = _b[Lltotexp0] / _se[Lltotexp0]  if bootstrap_no ==`num'

replace b_Llimp0pprb  = _b[Llimp0pprb]  if bootstrap_no ==`num'
replace se_Llimp0pprb = _se[Llimp0pprb] if bootstrap_no ==`num'
replace t_Llimp0pprb  = _b[Llimp0pprb] / _se[Llimp0pprb]  if bootstrap_no ==`num'

replace b_Lcempserclabf_Lltotexp0  = _b[Lcempserclabf_Lltotexp0]  if bootstrap_no ==`num'
replace se_Lcempserclabf_Lltotexp0 = _se[Lcempserclabf_Lltotexp0] if bootstrap_no ==`num'
replace t_Lcempserclabf_Lltotexp0  = _b[Lcempserclabf_Lltotexp0] / _se[Lcempserclabf_Lltotexp0]  if bootstrap_no ==`num'

    quietly drop xb laid0_res L1laid0_res laid0_m`num' random_m`num'

save "bootstrap_data\bootstrap_aid_model2.dta", replace
log close
log using "isq_bootstrap_aid_model2.txt", text append
} 

    quietly drop cow_dyadid -  aid_0_1 

save "bootstrap_data\bootstrap_aid_model2.dta", replace

log close


// display summary statistics for the results for the 250 samples

log using "isq_bootstrap_aid_model2_sum.txt", text replace

use "bootstrap_data\bootstrap_aid_model2.dta", clear

sum b_Llrrgdppc  t_Llrrgdppc 
sum b_Lltotexp0  t_Lltotexp0  
sum b_Llimp0pprb t_Llimp0pprb  
sum b_Lcempserclabf_Lltotexp0 t_Lcempserclabf_Lltotexp0

tab t_Llrrgdppc  if t_Llrrgdppc  > -1.96
tab t_Lltotexp0  if t_Lltotexp0  <  1.96
tab t_Llimp0pprb if t_Llimp0pprb <  1.96
tab t_Lcempserclabf_Lltotexp0 if t_Lcempserclabf_Lltotexp0 > -1.96

log close













log using "isq_bootstrap_aid_model3.txt", text replace

*******************************************************************************
***** Table B17: Model 3.                                                 *****
***** Randomly replacing 20% of zero values on the foreign aid provision  *****
***** variable with missing values. Resampling is repeated 250 times.     ***** 
*******************************************************************************	 




// read in data 
use "isq_data.dta", clear 
sort cow_dyadid year
tsset cow_dyadid year

// generate year, donor and recipient dummy variables
foreach num of numlist 1979(1)2001 {
quietly gen year`num' = 0
quietly replace year`num' = 1 if year == `num'
quietly label var year`num' "Dummy for `num'"
}
quietly tab cow_donor, gen(dond)
quietly tab cow_recipient, gen(recd)

// save list of independent variables that are included in all models  	
local indepvars "Lldpop Llrpop Lldrgdppc Llrrgdppc lkmdist colony usaisr Lrpolity Lrconflict Lcempserclabf cempindclabfchy3 Lltotexp0 Llimp0pprb"

// run the models for the 250 samples and save the results
set more off
set seed 1010101 // set seed to allow for exact replication

gen aid_0_1 = 0 if year >= 1979
replace aid_0_1 = 1 if aid0 != 0 & year >= 1979
tab aid_0_1 if year >= 1979, miss // 18490 zeros (out of 50227 observations)

gen bootstrap_no  = _n
gen b_Llrrgdppc   = .
gen se_Llrrgdppc  = .
gen t_Llrrgdppc   = .
gen b_Lltotexp0   = .
gen se_Lltotexp0  = .
gen t_Lltotexp0   = .
gen b_Llimp0pprb  = .
gen se_Llimp0pprb = .
gen t_Llimp0pprb  = .
gen b_Lcempserclabf_Llimp0pprb  = .
gen se_Lcempserclabf_Llimp0pprb = .
gen t_Lcempserclabf_Llimp0pprb  = .

foreach num of numlist 1/250 {

display "Start: Resampling No " `num'

gen laid0_m`num' = laid0 if year >= 1979
gen random_m`num' = uniform() if aid0 == 0 & year >= 1979
sort aid_0_1 random_m`num'
replace laid0_m`num' = . in 1/3698 // 3698 observations = 20% of the missing values

sort cow_dyadid year
tsset cow_dyadid year

quietly tobit laid0_m`num' `indepvars' Lcempserclabf_Llimp0pprb year1980-year2001 dond2-dond21 recd2-recd124 if year >= 1979, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    gen laid0_res = laid0_m`num' - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0_m`num' L1laid0_res `indepvars' Lcempserclabf_Llimp0pprb year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)

replace b_Llrrgdppc  = _b[Llrrgdppc]  if bootstrap_no == `num'
replace se_Llrrgdppc = _se[Llrrgdppc] if bootstrap_no ==`num'
replace t_Llrrgdppc  = _b[Llrrgdppc] / _se[Llrrgdppc]  if bootstrap_no== `num'

replace b_Lltotexp0  = _b[Lltotexp0]  if bootstrap_no ==`num'
replace se_Lltotexp0 = _se[Lltotexp0] if bootstrap_no ==`num'
replace t_Lltotexp0  = _b[Lltotexp0] / _se[Lltotexp0]  if bootstrap_no ==`num'

replace b_Llimp0pprb  = _b[Llimp0pprb]  if bootstrap_no ==`num'
replace se_Llimp0pprb = _se[Llimp0pprb] if bootstrap_no ==`num'
replace t_Llimp0pprb  = _b[Llimp0pprb] / _se[Llimp0pprb]  if bootstrap_no ==`num'

replace b_Lcempserclabf_Llimp0pprb  = _b[Lcempserclabf_Llimp0pprb]  if bootstrap_no ==`num'
replace se_Lcempserclabf_Llimp0pprb = _se[Lcempserclabf_Llimp0pprb] if bootstrap_no ==`num'
replace t_Lcempserclabf_Llimp0pprb  = _b[Lcempserclabf_Llimp0pprb] / _se[Lcempserclabf_Llimp0pprb]  if bootstrap_no ==`num'

    quietly drop xb laid0_res L1laid0_res laid0_m`num' random_m`num'

save "bootstrap_data\bootstrap_aid_model3.dta", replace
log close
log using "isq_bootstrap_aid_model3.txt", text append
} 

    quietly drop cow_dyadid -  aid_0_1 

save "bootstrap_data\bootstrap_aid_model3.dta", replace

log close


// display summary statistics for the results for the 250 samples

log using "isq_bootstrap_aid_model3_sum.txt", text replace

use "bootstrap_data\bootstrap_aid_model3.dta", clear

sum b_Llrrgdppc  t_Llrrgdppc 
sum b_Lltotexp0  t_Lltotexp0  
sum b_Llimp0pprb t_Llimp0pprb  
sum b_Lcempserclabf_Llimp0pprb t_Lcempserclabf_Llimp0pprb

tab t_Llrrgdppc  if t_Llrrgdppc  > -1.96
tab t_Lltotexp0  if t_Lltotexp0  <  1.96
tab t_Llimp0pprb if t_Llimp0pprb <  1.96
tab t_Lcempserclabf_Llimp0pprb if t_Lcempserclabf_Llimp0pprb > -1.96

log close













log using "isq_bootstrap_aid_model4.txt", text replace

*******************************************************************************
***** Table B17: Model 4.                                                 *****
***** Randomly replacing 20% of zero values on the foreign aid provision  *****
***** variable with missing values. Resampling is repeated 250 times.     ***** 
*******************************************************************************	 




// read in data 
use "isq_data.dta", clear 
sort cow_dyadid year
tsset cow_dyadid year

// generate year, donor and recipient dummy variables
foreach num of numlist 1979(1)2001 {
quietly gen year`num' = 0
quietly replace year`num' = 1 if year == `num'
quietly label var year`num' "Dummy for `num'"
}
quietly tab cow_donor, gen(dond)
quietly tab cow_recipient, gen(recd)

// save list of independent variables that are included in all models  	
local indepvars "Lldpop Llrpop Lldrgdppc Llrrgdppc lkmdist colony usaisr Lrpolity Lrconflict Lcempserclabf cempindclabfchy3 Lltotexp0 Llimp0pprb"

// run the models for the 250 samples and save the results
set more off
set seed 1010101 // set seed to allow for exact replication

gen aid_0_1 = 0 if year >= 1979
replace aid_0_1 = 1 if aid0 != 0 & year >= 1979
tab aid_0_1 if year >= 1979, miss // 18490 zeros (out of 50227 observations)

gen bootstrap_no  = _n
gen b_Llrrgdppc   = .
gen se_Llrrgdppc  = .
gen t_Llrrgdppc   = .
gen b_Lltotexp0   = .
gen se_Lltotexp0  = .
gen t_Lltotexp0   = .
gen b_Llimp0pprb  = .
gen se_Llimp0pprb = .
gen t_Llimp0pprb  = .
gen b_Lcempserclabf_Llrrgdppc  = .
gen se_Lcempserclabf_Llrrgdppc = .
gen t_Lcempserclabf_Llrrgdppc  = .

foreach num of numlist 1/250 {

display "Start: Resampling No " `num'

gen laid0_m`num' = laid0 if year >= 1979
gen random_m`num' = uniform() if aid0 == 0 & year >= 1979
sort aid_0_1 random_m`num'
replace laid0_m`num' = . in 1/3698 // 3698 observations = 20% of the missing values

sort cow_dyadid year
tsset cow_dyadid year

quietly tobit laid0_m`num' `indepvars' Lcempserclabf_Llrrgdppc year1980-year2001 dond2-dond21 recd2-recd124 if year >= 1979, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    gen laid0_res = laid0_m`num' - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0_m`num' L1laid0_res `indepvars' Lcempserclabf_Llrrgdppc year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)

replace b_Llrrgdppc  = _b[Llrrgdppc]  if bootstrap_no == `num'
replace se_Llrrgdppc = _se[Llrrgdppc] if bootstrap_no ==`num'
replace t_Llrrgdppc  = _b[Llrrgdppc] / _se[Llrrgdppc]  if bootstrap_no== `num'

replace b_Lltotexp0  = _b[Lltotexp0]  if bootstrap_no ==`num'
replace se_Lltotexp0 = _se[Lltotexp0] if bootstrap_no ==`num'
replace t_Lltotexp0  = _b[Lltotexp0] / _se[Lltotexp0]  if bootstrap_no ==`num'

replace b_Llimp0pprb  = _b[Llimp0pprb]  if bootstrap_no ==`num'
replace se_Llimp0pprb = _se[Llimp0pprb] if bootstrap_no ==`num'
replace t_Llimp0pprb  = _b[Llimp0pprb] / _se[Llimp0pprb]  if bootstrap_no ==`num'

replace b_Lcempserclabf_Llrrgdppc  = _b[Lcempserclabf_Llrrgdppc]  if bootstrap_no ==`num'
replace se_Lcempserclabf_Llrrgdppc = _se[Lcempserclabf_Llrrgdppc] if bootstrap_no ==`num'
replace t_Lcempserclabf_Llrrgdppc  = _b[Lcempserclabf_Llrrgdppc] / _se[Lcempserclabf_Llrrgdppc]  if bootstrap_no ==`num'

    quietly drop xb laid0_res L1laid0_res laid0_m`num' random_m`num'

save "bootstrap_data\bootstrap_aid_model4.dta", replace
log close
log using "isq_bootstrap_aid_model4.txt", text append
} 

    quietly drop cow_dyadid -  aid_0_1 

save "bootstrap_data\bootstrap_aid_model4.dta", replace

log close


// display summary statistics for the results for the 250 samples

log using "isq_bootstrap_aid_model4_sum.txt", text replace

use "bootstrap_data\bootstrap_aid_model4.dta", clear

sum b_Llrrgdppc  t_Llrrgdppc 
sum b_Lltotexp0  t_Lltotexp0  
sum b_Llimp0pprb t_Llimp0pprb  
sum b_Lcempserclabf_Llrrgdppc t_Lcempserclabf_Llrrgdppc

tab t_Llrrgdppc  if t_Llrrgdppc  <  1.96
tab t_Lltotexp0  if t_Lltotexp0  <  1.96
tab t_Llimp0pprb if t_Llimp0pprb <  1.96
tab t_Lcempserclabf_Llrrgdppc if t_Lcempserclabf_Llrrgdppc > -1.96

log close














log using "isq_bootstrap_aid_model5.txt", text replace

*******************************************************************************
***** Table B17: Model 5.                                                 *****
***** Randomly replacing 20% of zero values on the foreign aid provision  *****
***** variable with missing values. Resampling is repeated 250 times.     ***** 
*******************************************************************************	 




// read in data 
use "isq_data.dta", clear 
sort cow_dyadid year
tsset cow_dyadid year

// generate year, donor and recipient dummy variables
foreach num of numlist 1979(1)2001 {
quietly gen year`num' = 0
quietly replace year`num' = 1 if year == `num'
quietly label var year`num' "Dummy for `num'"
}
quietly tab cow_donor, gen(dond)
quietly tab cow_recipient, gen(recd)

// save list of independent variables that are included in all models  	
local indepvars "Lldpop Llrpop Lldrgdppc Llrrgdppc lkmdist colony usaisr Lrpolity Lrconflict Lcempserclabf cempindclabfchy3 Lltotexp0 Llimp0pprb"

// run the models for the 250 samples and save the results
set more off
set seed 1010101 // set seed to allow for exact replication

gen aid_0_1 = 0 if year >= 1979
replace aid_0_1 = 1 if aid0 != 0 & year >= 1979
tab aid_0_1 if year >= 1979, miss // 18490 zeros (out of 50227 observations)

gen bootstrap_no  = _n
gen b_Llrrgdppc   = .
gen se_Llrrgdppc  = .
gen t_Llrrgdppc   = .
gen b_Lltotexp0   = .
gen se_Lltotexp0  = .
gen t_Lltotexp0   = .
gen b_Llimp0pprb  = .
gen se_Llimp0pprb = .
gen t_Llimp0pprb  = .
gen b_cempindclabfchy3_Lltotexp0  = .
gen se_cempindclabfchy3_Lltotexp0 = .
gen t_cempindclabfchy3_Lltotexp0  = .

foreach num of numlist 1/250 {

display "Start: Resampling No " `num'

gen laid0_m`num' = laid0 if year >= 1979
gen random_m`num' = uniform() if aid0 == 0 & year >= 1979
sort aid_0_1 random_m`num'
replace laid0_m`num' = . in 1/3698 // 3698 observations = 20% of the missing values

sort cow_dyadid year
tsset cow_dyadid year

quietly tobit laid0_m`num' `indepvars' cempindclabfchy3_Lltotexp0 year1980-year2001 dond2-dond21 recd2-recd124 if year >= 1979, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    gen laid0_res = laid0_m`num' - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0_m`num' L1laid0_res `indepvars' cempindclabfchy3_Lltotexp0 year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)

replace b_Llrrgdppc  = _b[Llrrgdppc]  if bootstrap_no == `num'
replace se_Llrrgdppc = _se[Llrrgdppc] if bootstrap_no ==`num'
replace t_Llrrgdppc  = _b[Llrrgdppc] / _se[Llrrgdppc]  if bootstrap_no== `num'

replace b_Lltotexp0  = _b[Lltotexp0]  if bootstrap_no ==`num'
replace se_Lltotexp0 = _se[Lltotexp0] if bootstrap_no ==`num'
replace t_Lltotexp0  = _b[Lltotexp0] / _se[Lltotexp0]  if bootstrap_no ==`num'

replace b_Llimp0pprb  = _b[Llimp0pprb]  if bootstrap_no ==`num'
replace se_Llimp0pprb = _se[Llimp0pprb] if bootstrap_no ==`num'
replace t_Llimp0pprb  = _b[Llimp0pprb] / _se[Llimp0pprb]  if bootstrap_no ==`num'

replace b_cempindclabfchy3_Lltotexp0  = _b[cempindclabfchy3_Lltotexp0]  if bootstrap_no ==`num'
replace se_cempindclabfchy3_Lltotexp0 = _se[cempindclabfchy3_Lltotexp0] if bootstrap_no ==`num'
replace t_cempindclabfchy3_Lltotexp0  = _b[cempindclabfchy3_Lltotexp0] / _se[cempindclabfchy3_Lltotexp0]  if bootstrap_no ==`num'

    quietly drop xb laid0_res L1laid0_res laid0_m`num' random_m`num'

save "bootstrap_data\bootstrap_aid_model5.dta", replace
log close
log using "isq_bootstrap_aid_model5.txt", text append
} 

    quietly drop cow_dyadid -  aid_0_1 

save "bootstrap_data\bootstrap_aid_model5.dta", replace

log close


// display summary statistics for the results for the 250 samples

log using "isq_bootstrap_aid_model5_sum.txt", text replace

use "bootstrap_data\bootstrap_aid_model5.dta", clear

sum b_Llrrgdppc  t_Llrrgdppc 
sum b_Lltotexp0  t_Lltotexp0  
sum b_Llimp0pprb t_Llimp0pprb  
sum b_cempindclabfchy3_Lltotexp0 t_cempindclabfchy3_Lltotexp0

tab t_Llrrgdppc  if t_Llrrgdppc  > -1.96
tab t_Lltotexp0  if t_Lltotexp0  <  1.96
tab t_Llimp0pprb if t_Llimp0pprb <  1.96
tab t_cempindclabfchy3_Lltotexp0 if t_cempindclabfchy3_Lltotexp0 > -1.96

log close















log using "isq_bootstrap_aid_model6.txt", text replace

*******************************************************************************
***** Table B17: Model 6.                                                 *****
***** Randomly replacing 20% of zero values on the foreign aid provision  *****
***** variable with missing values. Resampling is repeated 250 times.     ***** 
*******************************************************************************	 




// read in data 
use "isq_data.dta", clear 
sort cow_dyadid year
tsset cow_dyadid year

// generate year, donor and recipient dummy variables
foreach num of numlist 1979(1)2001 {
quietly gen year`num' = 0
quietly replace year`num' = 1 if year == `num'
quietly label var year`num' "Dummy for `num'"
}
quietly tab cow_donor, gen(dond)
quietly tab cow_recipient, gen(recd)

// save list of independent variables that are included in all models  	
local indepvars "Lldpop Llrpop Lldrgdppc Llrrgdppc lkmdist colony usaisr Lrpolity Lrconflict Lcempserclabf cempindclabfchy3 Lltotexp0 Llimp0pprb"

// run the models for the 250 samples and save the results
set more off
set seed 1010101 // set seed to allow for exact replication

gen aid_0_1 = 0 if year >= 1979
replace aid_0_1 = 1 if aid0 != 0 & year >= 1979
tab aid_0_1 if year >= 1979, miss // 18490 zeros (out of 50227 observations)

gen bootstrap_no  = _n
gen b_Llrrgdppc   = .
gen se_Llrrgdppc  = .
gen t_Llrrgdppc   = .
gen b_Lltotexp0   = .
gen se_Lltotexp0  = .
gen t_Lltotexp0   = .
gen b_Llimp0pprb  = .
gen se_Llimp0pprb = .
gen t_Llimp0pprb  = .
gen b_cempindclabfchy3_Llimp0pprb  = .
gen se_cempindclabfchy3_Llimp0ppr = .
gen t_cempindclabfchy3_Llimp0pprb  = .

foreach num of numlist 1/250 {

display "Start: Resampling No " `num'

gen laid0_m`num' = laid0 if year >= 1979
gen random_m`num' = uniform() if aid0 == 0 & year >= 1979
sort aid_0_1 random_m`num'
replace laid0_m`num' = . in 1/3698 // 3698 observations = 20% of the missing values

sort cow_dyadid year
tsset cow_dyadid year

quietly tobit laid0_m`num' `indepvars' cempindclabfchy3_Llimp0pprb year1980-year2001 dond2-dond21 recd2-recd124 if year >= 1979, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    gen laid0_res = laid0_m`num' - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0_m`num' L1laid0_res `indepvars' cempindclabfchy3_Llimp0pprb year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)

replace b_Llrrgdppc  = _b[Llrrgdppc]  if bootstrap_no == `num'
replace se_Llrrgdppc = _se[Llrrgdppc] if bootstrap_no ==`num'
replace t_Llrrgdppc  = _b[Llrrgdppc] / _se[Llrrgdppc]  if bootstrap_no== `num'

replace b_Lltotexp0  = _b[Lltotexp0]  if bootstrap_no ==`num'
replace se_Lltotexp0 = _se[Lltotexp0] if bootstrap_no ==`num'
replace t_Lltotexp0  = _b[Lltotexp0] / _se[Lltotexp0]  if bootstrap_no ==`num'

replace b_Llimp0pprb  = _b[Llimp0pprb]  if bootstrap_no ==`num'
replace se_Llimp0pprb = _se[Llimp0pprb] if bootstrap_no ==`num'
replace t_Llimp0pprb  = _b[Llimp0pprb] / _se[Llimp0pprb]  if bootstrap_no ==`num'

replace b_cempindclabfchy3_Llimp0pprb  = _b[cempindclabfchy3_Llimp0pprb]  if bootstrap_no ==`num'
replace se_cempindclabfchy3_Llimp0ppr = _se[cempindclabfchy3_Llimp0pprb] if bootstrap_no ==`num'
replace t_cempindclabfchy3_Llimp0pprb  = _b[cempindclabfchy3_Llimp0pprb] / _se[cempindclabfchy3_Llimp0pprb]  if bootstrap_no ==`num'

    quietly drop xb laid0_res L1laid0_res laid0_m`num' random_m`num'

save "bootstrap_data\bootstrap_aid_model6.dta", replace
log close
log using "isq_bootstrap_aid_model6.txt", text append
} 

    quietly drop cow_dyadid -  aid_0_1 

save "bootstrap_data\bootstrap_aid_model6.dta", replace

log close


// display summary statistics for the results for the 250 samples

log using "isq_bootstrap_aid_model6_sum.txt", text replace

use "bootstrap_data\bootstrap_aid_model6.dta", clear

sum b_Llrrgdppc  t_Llrrgdppc 
sum b_Lltotexp0  t_Lltotexp0  
sum b_Llimp0pprb t_Llimp0pprb  
sum b_cempindclabfchy3_Llimp0pprb t_cempindclabfchy3_Llimp0pprb

tab t_Llrrgdppc  if t_Llrrgdppc  > -1.96
tab t_Lltotexp0  if t_Lltotexp0  <  1.96
tab t_Llimp0pprb if t_Llimp0pprb <  1.96
tab t_cempindclabfchy3_Llimp0pprb if t_cempindclabfchy3_Llimp0pprb > -1.96

log close













log using "isq_bootstrap_aid_model7.txt", text replace

*******************************************************************************
***** Table B17: Model 7.                                                 *****
***** Randomly replacing 20% of zero values on the foreign aid provision  *****
***** variable with missing values. Resampling is repeated 250 times.     ***** 
*******************************************************************************	 




// read in data 
use "isq_data.dta", clear 
sort cow_dyadid year
tsset cow_dyadid year

// generate year, donor and recipient dummy variables
foreach num of numlist 1979(1)2001 {
quietly gen year`num' = 0
quietly replace year`num' = 1 if year == `num'
quietly label var year`num' "Dummy for `num'"
}
quietly tab cow_donor, gen(dond)
quietly tab cow_recipient, gen(recd)

// save list of independent variables that are included in all models  	
local indepvars "Lldpop Llrpop Lldrgdppc Llrrgdppc lkmdist colony usaisr Lrpolity Lrconflict Lcempserclabf cempindclabfchy3 Lltotexp0 Llimp0pprb"

// run the models for the 250 samples and save the results
set more off
set seed 1010101 // set seed to allow for exact replication

gen aid_0_1 = 0 if year >= 1979
replace aid_0_1 = 1 if aid0 != 0 & year >= 1979
tab aid_0_1 if year >= 1979, miss // 18490 zeros (out of 50227 observations)

gen bootstrap_no  = _n
gen b_Llrrgdppc   = .
gen se_Llrrgdppc  = .
gen t_Llrrgdppc   = .
gen b_Lltotexp0   = .
gen se_Lltotexp0  = .
gen t_Lltotexp0   = .
gen b_Llimp0pprb  = .
gen se_Llimp0pprb = .
gen t_Llimp0pprb  = .
gen b_cempindclabfchy3_Llrrgdppc  = .
gen se_cempindclabfchy3_Llrrgdppc = .
gen t_cempindclabfchy3_Llrrgdppc  = .

foreach num of numlist 1/250 {

display "Start: Resampling No " `num'

gen laid0_m`num' = laid0 if year >= 1979
gen random_m`num' = uniform() if aid0 == 0 & year >= 1979
sort aid_0_1 random_m`num'
replace laid0_m`num' = . in 1/3698 // 3698 observations = 20% of the missing values

sort cow_dyadid year
tsset cow_dyadid year

quietly tobit laid0_m`num' `indepvars' cempindclabfchy3_Llrrgdppc year1980-year2001 dond2-dond21 recd2-recd124 if year >= 1979, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    gen laid0_res = laid0_m`num' - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0_m`num' L1laid0_res `indepvars' cempindclabfchy3_Llrrgdppc year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)

replace b_Llrrgdppc  = _b[Llrrgdppc]  if bootstrap_no == `num'
replace se_Llrrgdppc = _se[Llrrgdppc] if bootstrap_no ==`num'
replace t_Llrrgdppc  = _b[Llrrgdppc] / _se[Llrrgdppc]  if bootstrap_no== `num'

replace b_Lltotexp0  = _b[Lltotexp0]  if bootstrap_no ==`num'
replace se_Lltotexp0 = _se[Lltotexp0] if bootstrap_no ==`num'
replace t_Lltotexp0  = _b[Lltotexp0] / _se[Lltotexp0]  if bootstrap_no ==`num'

replace b_Llimp0pprb  = _b[Llimp0pprb]  if bootstrap_no ==`num'
replace se_Llimp0pprb = _se[Llimp0pprb] if bootstrap_no ==`num'
replace t_Llimp0pprb  = _b[Llimp0pprb] / _se[Llimp0pprb]  if bootstrap_no ==`num'

replace b_cempindclabfchy3_Llrrgdppc  = _b[cempindclabfchy3_Llrrgdppc]  if bootstrap_no ==`num'
replace se_cempindclabfchy3_Llrrgdppc = _se[cempindclabfchy3_Llrrgdppc] if bootstrap_no ==`num'
replace t_cempindclabfchy3_Llrrgdppc  = _b[cempindclabfchy3_Llrrgdppc] / _se[cempindclabfchy3_Llrrgdppc]  if bootstrap_no ==`num'

    quietly drop xb laid0_res L1laid0_res laid0_m`num' random_m`num'

save "bootstrap_data\bootstrap_aid_model7.dta", replace
log close
log using "isq_bootstrap_aid_model7.txt", text append
} 

    quietly drop cow_dyadid -  aid_0_1 

save "bootstrap_data\bootstrap_aid_model7.dta", replace

log close


// display summary statistics for the results for the 250 samples

log using "isq_bootstrap_aid_model7_sum.txt", text replace

use "bootstrap_data\bootstrap_aid_model7.dta", clear

sum b_Llrrgdppc  t_Llrrgdppc 
sum b_Lltotexp0  t_Lltotexp0  
sum b_Llimp0pprb t_Llimp0pprb  
sum b_cempindclabfchy3_Llrrgdppc t_cempindclabfchy3_Llrrgdppc

tab t_Llrrgdppc  if t_Llrrgdppc  > -1.96
tab t_Lltotexp0  if t_Lltotexp0  <  1.96
tab t_Llimp0pprb if t_Llimp0pprb <  1.96
tab t_cempindclabfchy3_Llrrgdppc if t_cempindclabfchy3_Llrrgdppc > -1.96

log close





















*******************************************************************************
***** Table B18: Resampling of the zero values on each of the exports,    *****
***** raw material imports, and other imports variables (based on         ***** 
***** Models 1 to 7 in Table 1).                                          *****
*******************************************************************************	 





log using "isq_bootstrap_trade_model1.txt", text replace

*******************************************************************************
***** Table B18: Model 1.                                                 *****
***** Randomly replacing 10% of the zero values on each of the exports,   *****
***** raw material imports, and other imports variables with missing      *****
***** values. Resampling is repeated 250 times.                           ***** 
*******************************************************************************	 




// read in data 
use "isq_data.dta", clear 
sort cow_dyadid year
tsset cow_dyadid year

// generate year, donor and recipient dummy variables
foreach num of numlist 1979(1)2001 {
quietly gen year`num' = 0
quietly replace year`num' = 1 if year == `num'
quietly label var year`num' "Dummy for `num'"
}
quietly tab cow_donor, gen(dond)
quietly tab cow_recipient, gen(recd)

// save list of independent variables that are included in all models  	
local indepvars "Lldpop Llrpop Lldrgdppc Llrrgdppc lkmdist colony usaisr Lrpolity Lrconflict Lcempserclabf cempindclabfchy3"

// run the models for the 250 samples and save the results
set more off
set seed 1010101 // set seed to allow for exact replication

gen exp_0_1 = 0 if year >= 1979
gen imppprb_0_1 = 0 if year >= 1979
gen impother_0_1 = 0 if year >= 1979
replace exp_0_1 = 1 if Lltotexp0 != 0 & year >= 1979
replace imppprb_0_1 = 1 if Llimp0pprb != 0 & year >= 1979
replace impother_0_1 = 1 if Llimp0ltmtht != 0 & year >= 1979
tab exp_0_1 if year >= 1979, miss // 4404 zeros (out of 50227 observations)  
tab imppprb_0_1 if year >= 1979, miss // 10419 zeros (out of 50227 observations) 
tab impother_0_1 if year >= 1979, miss // 19195 zeros (out of 50227 observations) 

gen bootstrap_no  = _n
gen b_Llrrgdppc   = .
gen se_Llrrgdppc  = .
gen t_Llrrgdppc   = .
gen b_Lltotexp0   = .
gen se_Lltotexp0  = .
gen t_Lltotexp0   = .
gen b_Llimp0pprb  = .
gen se_Llimp0pprb = .
gen t_Llimp0pprb  = .
gen b_Llimp0ltmtht  = .
gen se_Llimp0ltmtht = .
gen t_Llimp0ltmtht  = .

foreach num of numlist 1/250 {

display "Start: Resampling No " `num'

gen Lltotexp0_m`num' = Lltotexp0 if year >= 1979
gen Llimp0pprb_m`num' = Llimp0pprb if year >= 1979
gen Llimp0ltmtht_m`num' = Llimp0ltmtht if year >= 1979

gen random_exp_m`num' = uniform() if Lltotexp0 == 0 & year >= 1979
sort exp_0_1 random_exp_m`num' 
replace Lltotexp0_m`num' = . in 1/440 // 440 observations = 10% of the missings on the exports variable

gen random_imppprb_m`num' = uniform() if Llimp0pprb == 0 & year >= 1979
sort imppprb_0_1 random_imppprb_m`num'
replace Llimp0pprb_m`num' = . in 1/1042 // 1042 observations = 10% of the missings on the raw material imports variable

gen random_impother_m`num' = uniform() if Llimp0ltmtht == 0 & year >= 1979
sort impother_0_1 random_impother_m`num'
replace Llimp0ltmtht_m`num' = . in 1/1920 // 1920 observations = 10% of the missings on the other imports variable

sort cow_dyadid year
tsset cow_dyadid year

quietly tobit laid0 `indepvars' Lltotexp0_m`num' Llimp0pprb_m`num' Llimp0ltmtht_m`num' year1980-year2001 dond2-dond21 recd2-recd124 if year >= 1979, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Lltotexp0_m`num' Llimp0pprb_m`num' Llimp0ltmtht_m`num' year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)

replace b_Llrrgdppc  = _b[Llrrgdppc]  if bootstrap_no == `num'
replace se_Llrrgdppc = _se[Llrrgdppc] if bootstrap_no ==`num'
replace t_Llrrgdppc  = _b[Llrrgdppc] / _se[Llrrgdppc]  if bootstrap_no== `num'

replace b_Lltotexp0  = _b[Lltotexp0_m`num']  if bootstrap_no ==`num'
replace se_Lltotexp0 = _se[Lltotexp0_m`num'] if bootstrap_no ==`num'
replace t_Lltotexp0  = _b[Lltotexp0_m`num'] / _se[Lltotexp0_m`num']  if bootstrap_no ==`num'

replace b_Llimp0pprb  = _b[Llimp0pprb_m`num']  if bootstrap_no ==`num'
replace se_Llimp0pprb = _se[Llimp0pprb_m`num'] if bootstrap_no ==`num'
replace t_Llimp0pprb  = _b[Llimp0pprb_m`num'] / _se[Llimp0pprb_m`num']  if bootstrap_no ==`num'

replace b_Llimp0ltmtht  = _b[Llimp0ltmtht_m`num']  if bootstrap_no ==`num'
replace se_Llimp0ltmtht = _se[Llimp0ltmtht_m`num'] if bootstrap_no ==`num'
replace t_Llimp0ltmtht  = _b[Llimp0ltmtht_m`num'] / _se[Llimp0ltmtht_m`num']  if bootstrap_no ==`num'

    quietly drop xb laid0_res L1laid0_res Lltotexp0_m`num' random_exp_m`num' Llimp0pprb_m`num' random_imppprb_m`num' Llimp0ltmtht_m`num' random_impother_m`num'

save "bootstrap_data\bootstrap_trade_model1.dta", replace
log close
log using "isq_bootstrap_trade_model1.txt", text append
} 

    quietly drop cow_dyadid - impother_0_1 

save "bootstrap_data\bootstrap_trade_model1.dta", replace

log close


// display summary statistics for the results for the 250 samples

log using "isq_bootstrap_trade_model1_sum.txt", text replace

use "bootstrap_data\bootstrap_trade_model1.dta", clear

sum b_Llrrgdppc  t_Llrrgdppc 
sum b_Lltotexp0  t_Lltotexp0  
sum b_Llimp0pprb t_Llimp0pprb
sum b_Llimp0ltmtht t_Llimp0ltmtht    

tab t_Llrrgdppc  if t_Llrrgdppc  > -1.96
tab t_Lltotexp0  if t_Lltotexp0  <  1.96
tab t_Llimp0pprb if t_Llimp0pprb <  1.96
tab t_Llimp0ltmtht if t_Llimp0ltmtht > 1.96
tab t_Llimp0ltmtht if t_Llimp0ltmtht < -1.96

log close













log using "isq_bootstrap_trade_model2.txt", text replace

*******************************************************************************
***** Table B18: Model 2.                                                 *****
***** Randomly replacing 10% of the zero values on each of the exports,   *****
***** raw material imports, and other imports variables with missing      *****
***** values. Resampling is repeated 250 times.                           ***** 
*******************************************************************************	 




// read in data 
use "isq_data.dta", clear 
sort cow_dyadid year
tsset cow_dyadid year

// generate year, donor and recipient dummy variables
foreach num of numlist 1979(1)2001 {
quietly gen year`num' = 0
quietly replace year`num' = 1 if year == `num'
quietly label var year`num' "Dummy for `num'"
}
quietly tab cow_donor, gen(dond)
quietly tab cow_recipient, gen(recd)

// save list of independent variables that are included in all models  	
local indepvars "Lldpop Llrpop Lldrgdppc Llrrgdppc lkmdist colony usaisr Lrpolity Lrconflict Lcempserclabf cempindclabfchy3"

// run the models for the 250 samples and save the results
set more off
set seed 1010101 // set seed to allow for exact replication

gen exp_0_1 = 0 if year >= 1979
gen imppprb_0_1 = 0 if year >= 1979
replace exp_0_1 = 1 if Lltotexp0 != 0 & year >= 1979
replace imppprb_0_1 = 1 if Llimp0pprb != 0 & year >= 1979
tab exp_0_1 if year >= 1979, miss // 4404 zeros (out of 50227 observations)  
tab imppprb_0_1 if year >= 1979, miss // 10419 zeros (out of 50227 observations) 

gen bootstrap_no  = _n
gen b_Llrrgdppc   = .
gen se_Llrrgdppc  = .
gen t_Llrrgdppc   = .
gen b_Lltotexp0   = .
gen se_Lltotexp0  = .
gen t_Lltotexp0   = .
gen b_Llimp0pprb  = .
gen se_Llimp0pprb = .
gen t_Llimp0pprb  = .
gen b_Lcempserclabf_Lltotexp0  = .
gen se_Lcempserclabf_Lltotexp0 = .
gen t_Lcempserclabf_Lltotexp0  = .

foreach num of numlist 1/250 {

display "Start: Resampling No " `num'

gen Lltotexp0_m`num' = Lltotexp0 if year >= 1979
gen Llimp0pprb_m`num' = Llimp0pprb if year >= 1979

gen random_exp_m`num' = uniform() if Lltotexp0 == 0 & year >= 1979
sort exp_0_1 random_exp_m`num' 
replace Lltotexp0_m`num' = . in 1/440 // 440 observations = 10% of the missings on the exports variable

gen random_imppprb_m`num' = uniform() if Llimp0pprb == 0 & year >= 1979
sort imppprb_0_1 random_imppprb_m`num'
replace Llimp0pprb_m`num' = . in 1/1042 // 1042 observations = 10% of the missings on the raw material imports variable

sort cow_dyadid year
tsset cow_dyadid year

quietly tobit laid0 `indepvars' Lltotexp0_m`num' Llimp0pprb_m`num' Lcempserclabf_Lltotexp0 year1980-year2001 dond2-dond21 recd2-recd124 if year >= 1979, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Lltotexp0_m`num' Llimp0pprb_m`num' Lcempserclabf_Lltotexp0 year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)

replace b_Llrrgdppc  = _b[Llrrgdppc]  if bootstrap_no == `num'
replace se_Llrrgdppc = _se[Llrrgdppc] if bootstrap_no ==`num'
replace t_Llrrgdppc  = _b[Llrrgdppc] / _se[Llrrgdppc]  if bootstrap_no== `num'

replace b_Lltotexp0  = _b[Lltotexp0_m`num']  if bootstrap_no ==`num'
replace se_Lltotexp0 = _se[Lltotexp0_m`num'] if bootstrap_no ==`num'
replace t_Lltotexp0  = _b[Lltotexp0_m`num'] / _se[Lltotexp0_m`num']  if bootstrap_no ==`num'

replace b_Llimp0pprb  = _b[Llimp0pprb_m`num']  if bootstrap_no ==`num'
replace se_Llimp0pprb = _se[Llimp0pprb_m`num'] if bootstrap_no ==`num'
replace t_Llimp0pprb  = _b[Llimp0pprb_m`num'] / _se[Llimp0pprb_m`num']  if bootstrap_no ==`num'

replace b_Lcempserclabf_Lltotexp0  = _b[Lcempserclabf_Lltotexp0]  if bootstrap_no ==`num'
replace se_Lcempserclabf_Lltotexp0 = _se[Lcempserclabf_Lltotexp0] if bootstrap_no ==`num'
replace t_Lcempserclabf_Lltotexp0  = _b[Lcempserclabf_Lltotexp0] / _se[Lcempserclabf_Lltotexp0]  if bootstrap_no ==`num'

    quietly drop xb laid0_res L1laid0_res Lltotexp0_m`num' random_exp_m`num' Llimp0pprb_m`num' random_imppprb_m`num'

save "bootstrap_data\bootstrap_trade_model2.dta", replace
log close
log using "isq_bootstrap_trade_model2.txt", text append
} 

    quietly drop cow_dyadid - imppprb_0_1 

save "bootstrap_data\bootstrap_trade_model2.dta", replace

log close


// display summary statistics for the results for the 250 samples

log using "isq_bootstrap_trade_model2_sum.txt", text replace

use "bootstrap_data\bootstrap_trade_model2.dta", clear

sum b_Llrrgdppc  t_Llrrgdppc 
sum b_Lltotexp0  t_Lltotexp0  
sum b_Llimp0pprb t_Llimp0pprb  
sum b_Lcempserclabf_Lltotexp0 t_Lcempserclabf_Lltotexp0

tab t_Llrrgdppc  if t_Llrrgdppc  > -1.96
tab t_Lltotexp0  if t_Lltotexp0  <  1.96
tab t_Llimp0pprb if t_Llimp0pprb <  1.96
tab t_Lcempserclabf_Lltotexp0 if t_Lcempserclabf_Lltotexp0 > -1.96

log close














log using "isq_bootstrap_trade_model3.txt", text replace

*******************************************************************************
***** Table B18: Model 3.                                                 *****
***** Randomly replacing 10% of the zero values on each of the exports,   *****
***** raw material imports, and other imports variables with missing      *****
***** values. Resampling is repeated 250 times.                           ***** 
*******************************************************************************	 




// read in data 
use "isq_data.dta", clear 
sort cow_dyadid year
tsset cow_dyadid year

// generate year, donor and recipient dummy variables
foreach num of numlist 1979(1)2001 {
quietly gen year`num' = 0
quietly replace year`num' = 1 if year == `num'
quietly label var year`num' "Dummy for `num'"
}
quietly tab cow_donor, gen(dond)
quietly tab cow_recipient, gen(recd)

// save list of independent variables that are included in all models  	
local indepvars "Lldpop Llrpop Lldrgdppc Llrrgdppc lkmdist colony usaisr Lrpolity Lrconflict Lcempserclabf cempindclabfchy3"

// run the models for the 250 samples and save the results
set more off
set seed 1010101 // set seed to allow for exact replication

gen exp_0_1 = 0 if year >= 1979
gen imppprb_0_1 = 0 if year >= 1979
replace exp_0_1 = 1 if Lltotexp0 != 0 & year >= 1979
replace imppprb_0_1 = 1 if Llimp0pprb != 0 & year >= 1979
tab exp_0_1 if year >= 1979, miss // 4404 zeros (out of 50227 observations)  
tab imppprb_0_1 if year >= 1979, miss // 10419 zeros (out of 50227 observations) 

gen bootstrap_no  = _n
gen b_Llrrgdppc   = .
gen se_Llrrgdppc  = .
gen t_Llrrgdppc   = .
gen b_Lltotexp0   = .
gen se_Lltotexp0  = .
gen t_Lltotexp0   = .
gen b_Llimp0pprb  = .
gen se_Llimp0pprb = .
gen t_Llimp0pprb  = .
gen b_Lcempserclabf_Llimp0pprb  = .
gen se_Lcempserclabf_Llimp0pprb = .
gen t_Lcempserclabf_Llimp0pprb  = .

foreach num of numlist 1/250 {

display "Start: Resampling No " `num'

gen Lltotexp0_m`num' = Lltotexp0 if year >= 1979
gen Llimp0pprb_m`num' = Llimp0pprb if year >= 1979

gen random_exp_m`num' = uniform() if Lltotexp0 == 0 & year >= 1979
sort exp_0_1 random_exp_m`num' 
replace Lltotexp0_m`num' = . in 1/440 // 440 observations = 10% of the missings on the exports variable

gen random_imppprb_m`num' = uniform() if Llimp0pprb == 0 & year >= 1979
sort imppprb_0_1 random_imppprb_m`num'
replace Llimp0pprb_m`num' = . in 1/1042 // 1042 observations = 10% of the missings on the raw material imports variable

sort cow_dyadid year
tsset cow_dyadid year

quietly tobit laid0 `indepvars' Lltotexp0_m`num' Llimp0pprb_m`num' Lcempserclabf_Llimp0pprb year1980-year2001 dond2-dond21 recd2-recd124 if year >= 1979, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Lltotexp0_m`num' Llimp0pprb_m`num' Lcempserclabf_Llimp0pprb year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)

replace b_Llrrgdppc  = _b[Llrrgdppc]  if bootstrap_no == `num'
replace se_Llrrgdppc = _se[Llrrgdppc] if bootstrap_no ==`num'
replace t_Llrrgdppc  = _b[Llrrgdppc] / _se[Llrrgdppc]  if bootstrap_no== `num'

replace b_Lltotexp0  = _b[Lltotexp0_m`num']  if bootstrap_no ==`num'
replace se_Lltotexp0 = _se[Lltotexp0_m`num'] if bootstrap_no ==`num'
replace t_Lltotexp0  = _b[Lltotexp0_m`num'] / _se[Lltotexp0_m`num']  if bootstrap_no ==`num'

replace b_Llimp0pprb  = _b[Llimp0pprb_m`num']  if bootstrap_no ==`num'
replace se_Llimp0pprb = _se[Llimp0pprb_m`num'] if bootstrap_no ==`num'
replace t_Llimp0pprb  = _b[Llimp0pprb_m`num'] / _se[Llimp0pprb_m`num']  if bootstrap_no ==`num'

replace b_Lcempserclabf_Llimp0pprb  = _b[Lcempserclabf_Llimp0pprb]  if bootstrap_no ==`num'
replace se_Lcempserclabf_Llimp0pprb = _se[Lcempserclabf_Llimp0pprb] if bootstrap_no ==`num'
replace t_Lcempserclabf_Llimp0pprb  = _b[Lcempserclabf_Llimp0pprb] / _se[Lcempserclabf_Llimp0pprb]  if bootstrap_no ==`num'

    quietly drop xb laid0_res L1laid0_res Lltotexp0_m`num' random_exp_m`num' Llimp0pprb_m`num' random_imppprb_m`num'

save "bootstrap_data\bootstrap_trade_model3.dta", replace
log close
log using "isq_bootstrap_trade_model3.txt", text append
} 

    quietly drop cow_dyadid - imppprb_0_1 

save "bootstrap_data\bootstrap_trade_model3.dta", replace

log close


// display summary statistics for the results for the 250 samples

log using "isq_bootstrap_trade_model3_sum.txt", text replace

use "bootstrap_data\bootstrap_trade_model3.dta", clear

sum b_Llrrgdppc  t_Llrrgdppc 
sum b_Lltotexp0  t_Lltotexp0  
sum b_Llimp0pprb t_Llimp0pprb  
sum b_Lcempserclabf_Llimp0pprb t_Lcempserclabf_Llimp0pprb

tab t_Llrrgdppc  if t_Llrrgdppc  > -1.96
tab t_Lltotexp0  if t_Lltotexp0  <  1.96
tab t_Llimp0pprb if t_Llimp0pprb <  1.96
tab t_Lcempserclabf_Llimp0pprb if t_Lcempserclabf_Llimp0pprb > -1.96

log close














log using "isq_bootstrap_trade_model4.txt", text replace

*******************************************************************************
***** Table B18: Model 4.                                                 *****
***** Randomly replacing 10% of the zero values on each of the exports,   *****
***** raw material imports, and other imports variables with missing      *****
***** values. Resampling is repeated 250 times.                           ***** 
*******************************************************************************	 




// read in data 
use "isq_data.dta", clear 
sort cow_dyadid year
tsset cow_dyadid year

// generate year, donor and recipient dummy variables
foreach num of numlist 1979(1)2001 {
quietly gen year`num' = 0
quietly replace year`num' = 1 if year == `num'
quietly label var year`num' "Dummy for `num'"
}
quietly tab cow_donor, gen(dond)
quietly tab cow_recipient, gen(recd)

// save list of independent variables that are included in all models  	
local indepvars "Lldpop Llrpop Lldrgdppc Llrrgdppc lkmdist colony usaisr Lrpolity Lrconflict Lcempserclabf cempindclabfchy3"

// run the models for the 250 samples and save the results
set more off
set seed 1010101 // set seed to allow for exact replication

gen exp_0_1 = 0 if year >= 1979
gen imppprb_0_1 = 0 if year >= 1979
replace exp_0_1 = 1 if Lltotexp0 != 0 & year >= 1979
replace imppprb_0_1 = 1 if Llimp0pprb != 0 & year >= 1979
tab exp_0_1 if year >= 1979, miss // 4404 zeros (out of 50227 observations)  
tab imppprb_0_1 if year >= 1979, miss // 10419 zeros (out of 50227 observations) 

gen bootstrap_no  = _n
gen b_Llrrgdppc   = .
gen se_Llrrgdppc  = .
gen t_Llrrgdppc   = .
gen b_Lltotexp0   = .
gen se_Lltotexp0  = .
gen t_Lltotexp0   = .
gen b_Llimp0pprb  = .
gen se_Llimp0pprb = .
gen t_Llimp0pprb  = .
gen b_Lcempserclabf_Llrrgdppc  = .
gen se_Lcempserclabf_Llrrgdppc = .
gen t_Lcempserclabf_Llrrgdppc  = .

foreach num of numlist 1/250 {

display "Start: Resampling No " `num'

gen Lltotexp0_m`num' = Lltotexp0 if year >= 1979
gen Llimp0pprb_m`num' = Llimp0pprb if year >= 1979

gen random_exp_m`num' = uniform() if Lltotexp0 == 0 & year >= 1979
sort exp_0_1 random_exp_m`num' 
replace Lltotexp0_m`num' = . in 1/440 // 440 observations = 10% of the missings on the exports variable

gen random_imppprb_m`num' = uniform() if Llimp0pprb == 0 & year >= 1979
sort imppprb_0_1 random_imppprb_m`num'
replace Llimp0pprb_m`num' = . in 1/1042 // 1042 observations = 10% of the missings on the raw material imports variable

sort cow_dyadid year
tsset cow_dyadid year

quietly tobit laid0 `indepvars' Lltotexp0_m`num' Llimp0pprb_m`num' Lcempserclabf_Llrrgdppc year1980-year2001 dond2-dond21 recd2-recd124 if year >= 1979, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Lltotexp0_m`num' Llimp0pprb_m`num' Lcempserclabf_Llrrgdppc year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)

replace b_Llrrgdppc  = _b[Llrrgdppc]  if bootstrap_no == `num'
replace se_Llrrgdppc = _se[Llrrgdppc] if bootstrap_no ==`num'
replace t_Llrrgdppc  = _b[Llrrgdppc] / _se[Llrrgdppc]  if bootstrap_no== `num'

replace b_Lltotexp0  = _b[Lltotexp0_m`num']  if bootstrap_no ==`num'
replace se_Lltotexp0 = _se[Lltotexp0_m`num'] if bootstrap_no ==`num'
replace t_Lltotexp0  = _b[Lltotexp0_m`num'] / _se[Lltotexp0_m`num']  if bootstrap_no ==`num'

replace b_Llimp0pprb  = _b[Llimp0pprb_m`num']  if bootstrap_no ==`num'
replace se_Llimp0pprb = _se[Llimp0pprb_m`num'] if bootstrap_no ==`num'
replace t_Llimp0pprb  = _b[Llimp0pprb_m`num'] / _se[Llimp0pprb_m`num']  if bootstrap_no ==`num'

replace b_Lcempserclabf_Llrrgdppc  = _b[Lcempserclabf_Llrrgdppc]  if bootstrap_no ==`num'
replace se_Lcempserclabf_Llrrgdppc = _se[Lcempserclabf_Llrrgdppc] if bootstrap_no ==`num'
replace t_Lcempserclabf_Llrrgdppc  = _b[Lcempserclabf_Llrrgdppc] / _se[Lcempserclabf_Llrrgdppc]  if bootstrap_no ==`num'

    quietly drop xb laid0_res L1laid0_res Lltotexp0_m`num' random_exp_m`num' Llimp0pprb_m`num' random_imppprb_m`num'

save "bootstrap_data\bootstrap_trade_model4.dta", replace
log close
log using "isq_bootstrap_trade_model4.txt", text append
} 

    quietly drop cow_dyadid - imppprb_0_1 

save "bootstrap_data\bootstrap_trade_model4.dta", replace

log close


// display summary statistics for the results for the 250 samples

log using "isq_bootstrap_trade_model4_sum.txt", text replace

use "bootstrap_data\bootstrap_trade_model4.dta", clear

sum b_Llrrgdppc  t_Llrrgdppc 
sum b_Lltotexp0  t_Lltotexp0  
sum b_Llimp0pprb t_Llimp0pprb  
sum b_Lcempserclabf_Llrrgdppc t_Lcempserclabf_Llrrgdppc

tab t_Llrrgdppc  if t_Llrrgdppc  <  1.96
tab t_Lltotexp0  if t_Lltotexp0  <  1.96
tab t_Llimp0pprb if t_Llimp0pprb <  1.96
tab t_Lcempserclabf_Llrrgdppc if t_Lcempserclabf_Llrrgdppc > -1.96

log close














log using "isq_bootstrap_trade_model5.txt", text replace

*******************************************************************************
***** Table B18: Model 5.                                                 *****
***** Randomly replacing 10% of the zero values on each of the exports,   *****
***** raw material imports, and other imports variables with missing      *****
***** values. Resampling is repeated 250 times.                           ***** 
*******************************************************************************	 




// read in data 
use "isq_data.dta", clear 
sort cow_dyadid year
tsset cow_dyadid year

// generate year, donor and recipient dummy variables
foreach num of numlist 1979(1)2001 {
quietly gen year`num' = 0
quietly replace year`num' = 1 if year == `num'
quietly label var year`num' "Dummy for `num'"
}
quietly tab cow_donor, gen(dond)
quietly tab cow_recipient, gen(recd)

// save list of independent variables that are included in all models  	
local indepvars "Lldpop Llrpop Lldrgdppc Llrrgdppc lkmdist colony usaisr Lrpolity Lrconflict Lcempserclabf cempindclabfchy3"

// run the models for the 250 samples and save the results
set more off
set seed 1010101 // set seed to allow for exact replication

gen exp_0_1 = 0 if year >= 1979
gen imppprb_0_1 = 0 if year >= 1979
replace exp_0_1 = 1 if Lltotexp0 != 0 & year >= 1979
replace imppprb_0_1 = 1 if Llimp0pprb != 0 & year >= 1979
tab exp_0_1 if year >= 1979, miss // 4404 zeros (out of 50227 observations)  
tab imppprb_0_1 if year >= 1979, miss // 10419 zeros (out of 50227 observations) 

gen bootstrap_no  = _n
gen b_Llrrgdppc   = .
gen se_Llrrgdppc  = .
gen t_Llrrgdppc   = .
gen b_Lltotexp0   = .
gen se_Lltotexp0  = .
gen t_Lltotexp0   = .
gen b_Llimp0pprb  = .
gen se_Llimp0pprb = .
gen t_Llimp0pprb  = .
gen b_cempindclabfchy3_Lltotexp0  = .
gen se_cempindclabfchy3_Lltotexp0 = .
gen t_cempindclabfchy3_Lltotexp0  = .

foreach num of numlist 1/250 {

display "Start: Resampling No " `num'

gen Lltotexp0_m`num' = Lltotexp0 if year >= 1979
gen Llimp0pprb_m`num' = Llimp0pprb if year >= 1979

gen random_exp_m`num' = uniform() if Lltotexp0 == 0 & year >= 1979
sort exp_0_1 random_exp_m`num' 
replace Lltotexp0_m`num' = . in 1/440 // 440 observations = 10% of the missings on the exports variable

gen random_imppprb_m`num' = uniform() if Llimp0pprb == 0 & year >= 1979
sort imppprb_0_1 random_imppprb_m`num'
replace Llimp0pprb_m`num' = . in 1/1042 // 1042 observations = 10% of the missings on the raw material imports variable

sort cow_dyadid year
tsset cow_dyadid year

quietly tobit laid0 `indepvars' Lltotexp0_m`num' Llimp0pprb_m`num' cempindclabfchy3_Lltotexp0 year1980-year2001 dond2-dond21 recd2-recd124 if year >= 1979, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Lltotexp0_m`num' Llimp0pprb_m`num' cempindclabfchy3_Lltotexp0 year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)

replace b_Llrrgdppc  = _b[Llrrgdppc]  if bootstrap_no == `num'
replace se_Llrrgdppc = _se[Llrrgdppc] if bootstrap_no ==`num'
replace t_Llrrgdppc  = _b[Llrrgdppc] / _se[Llrrgdppc]  if bootstrap_no== `num'

replace b_Lltotexp0  = _b[Lltotexp0_m`num']  if bootstrap_no ==`num'
replace se_Lltotexp0 = _se[Lltotexp0_m`num'] if bootstrap_no ==`num'
replace t_Lltotexp0  = _b[Lltotexp0_m`num'] / _se[Lltotexp0_m`num']  if bootstrap_no ==`num'

replace b_Llimp0pprb  = _b[Llimp0pprb_m`num']  if bootstrap_no ==`num'
replace se_Llimp0pprb = _se[Llimp0pprb_m`num'] if bootstrap_no ==`num'
replace t_Llimp0pprb  = _b[Llimp0pprb_m`num'] / _se[Llimp0pprb_m`num']  if bootstrap_no ==`num'

replace b_cempindclabfchy3_Lltotexp0  = _b[cempindclabfchy3_Lltotexp0]  if bootstrap_no ==`num'
replace se_cempindclabfchy3_Lltotexp0 = _se[cempindclabfchy3_Lltotexp0] if bootstrap_no ==`num'
replace t_cempindclabfchy3_Lltotexp0  = _b[cempindclabfchy3_Lltotexp0] / _se[cempindclabfchy3_Lltotexp0]  if bootstrap_no ==`num'

    quietly drop xb laid0_res L1laid0_res Lltotexp0_m`num' random_exp_m`num' Llimp0pprb_m`num' random_imppprb_m`num'

save "bootstrap_data\bootstrap_trade_model5.dta", replace
log close
log using "isq_bootstrap_trade_model5.txt", text append
} 

    quietly drop cow_dyadid - imppprb_0_1 

save "bootstrap_data\bootstrap_trade_model5.dta", replace

log close


// display summary statistics for the results for the 250 samples

log using "isq_bootstrap_trade_model5_sum.txt", text replace

use "bootstrap_data\bootstrap_trade_model5.dta", clear

sum b_Llrrgdppc  t_Llrrgdppc 
sum b_Lltotexp0  t_Lltotexp0  
sum b_Llimp0pprb t_Llimp0pprb  
sum b_cempindclabfchy3_Lltotexp0 t_cempindclabfchy3_Lltotexp0

tab t_Llrrgdppc  if t_Llrrgdppc  > -1.96
tab t_Lltotexp0  if t_Lltotexp0  <  1.96
tab t_Llimp0pprb if t_Llimp0pprb <  1.96
tab t_cempindclabfchy3_Lltotexp0 if t_cempindclabfchy3_Lltotexp0 > -1.96

log close















log using "isq_bootstrap_trade_model6.txt", text replace

*******************************************************************************
***** Table B18: Model 6.                                                 *****
***** Randomly replacing 10% of the zero values on each of the exports,   *****
***** raw material imports, and other imports variables with missing      *****
***** values. Resampling is repeated 250 times.                           ***** 
*******************************************************************************	 

// read in data 
use "isq_data.dta", clear 
sort cow_dyadid year
tsset cow_dyadid year

// generate year, donor and recipient dummy variables
foreach num of numlist 1979(1)2001 {
quietly gen year`num' = 0
quietly replace year`num' = 1 if year == `num'
quietly label var year`num' "Dummy for `num'"
}
quietly tab cow_donor, gen(dond)
quietly tab cow_recipient, gen(recd)

// save list of independent variables that are included in all models  	
local indepvars "Lldpop Llrpop Lldrgdppc Llrrgdppc lkmdist colony usaisr Lrpolity Lrconflict Lcempserclabf cempindclabfchy3"

// run the models for the 250 samples and save the results
set more off
set seed 1010101 // set seed to allow for exact replication

gen exp_0_1 = 0 if year >= 1979
gen imppprb_0_1 = 0 if year >= 1979
replace exp_0_1 = 1 if Lltotexp0 != 0 & year >= 1979
replace imppprb_0_1 = 1 if Llimp0pprb != 0 & year >= 1979
tab exp_0_1 if year >= 1979, miss // 4404 zeros (out of 50227 observations)  
tab imppprb_0_1 if year >= 1979, miss // 10419 zeros (out of 50227 observations) 

gen bootstrap_no  = _n
gen b_Llrrgdppc   = .
gen se_Llrrgdppc  = .
gen t_Llrrgdppc   = .
gen b_Lltotexp0   = .
gen se_Lltotexp0  = .
gen t_Lltotexp0   = .
gen b_Llimp0pprb  = .
gen se_Llimp0pprb = .
gen t_Llimp0pprb  = .
gen b_cempindclabfchy3_Llimp0pprb  = .
gen se_cempindclabfchy3_Llimp0ppr = .
gen t_cempindclabfchy3_Llimp0pprb  = .

foreach num of numlist 1/250 {

display "Start: Resampling No " `num'

gen Lltotexp0_m`num' = Lltotexp0 if year >= 1979
gen Llimp0pprb_m`num' = Llimp0pprb if year >= 1979

gen random_exp_m`num' = uniform() if Lltotexp0 == 0 & year >= 1979
sort exp_0_1 random_exp_m`num' 
replace Lltotexp0_m`num' = . in 1/440 // 440 observations = 10% of the missings on the exports variable

gen random_imppprb_m`num' = uniform() if Llimp0pprb == 0 & year >= 1979
sort imppprb_0_1 random_imppprb_m`num'
replace Llimp0pprb_m`num' = . in 1/1042 // 1042 observations = 10% of the missings on the raw material imports variable

sort cow_dyadid year
tsset cow_dyadid year

quietly tobit laid0 `indepvars' Lltotexp0_m`num' Llimp0pprb_m`num' cempindclabfchy3_Llimp0pprb year1980-year2001 dond2-dond21 recd2-recd124 if year >= 1979, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Lltotexp0_m`num' Llimp0pprb_m`num' cempindclabfchy3_Llimp0pprb year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)

replace b_Llrrgdppc  = _b[Llrrgdppc]  if bootstrap_no == `num'
replace se_Llrrgdppc = _se[Llrrgdppc] if bootstrap_no ==`num'
replace t_Llrrgdppc  = _b[Llrrgdppc] / _se[Llrrgdppc]  if bootstrap_no== `num'

replace b_Lltotexp0  = _b[Lltotexp0_m`num']  if bootstrap_no ==`num'
replace se_Lltotexp0 = _se[Lltotexp0_m`num'] if bootstrap_no ==`num'
replace t_Lltotexp0  = _b[Lltotexp0_m`num'] / _se[Lltotexp0_m`num']  if bootstrap_no ==`num'

replace b_Llimp0pprb  = _b[Llimp0pprb_m`num']  if bootstrap_no ==`num'
replace se_Llimp0pprb = _se[Llimp0pprb_m`num'] if bootstrap_no ==`num'
replace t_Llimp0pprb  = _b[Llimp0pprb_m`num'] / _se[Llimp0pprb_m`num']  if bootstrap_no ==`num'

replace b_cempindclabfchy3_Llimp0pprb  = _b[cempindclabfchy3_Llimp0pprb]  if bootstrap_no ==`num'
replace se_cempindclabfchy3_Llimp0ppr = _se[cempindclabfchy3_Llimp0pprb] if bootstrap_no ==`num'
replace t_cempindclabfchy3_Llimp0pprb  = _b[cempindclabfchy3_Llimp0pprb] / _se[cempindclabfchy3_Llimp0pprb]  if bootstrap_no ==`num'

    quietly drop xb laid0_res L1laid0_res Lltotexp0_m`num' random_exp_m`num' Llimp0pprb_m`num' random_imppprb_m`num'

save "bootstrap_data\bootstrap_trade_model6.dta", replace
log close
log using "isq_bootstrap_trade_model6.txt", text append
} 

    quietly drop cow_dyadid - imppprb_0_1 

save "bootstrap_data\bootstrap_trade_model6.dta", replace

log close


// display summary statistics for the results for the 250 samples

log using "isq_bootstrap_trade_model6_sum.txt", text replace

use "bootstrap_data\bootstrap_trade_model6.dta", clear

sum b_Llrrgdppc  t_Llrrgdppc 
sum b_Lltotexp0  t_Lltotexp0  
sum b_Llimp0pprb t_Llimp0pprb  
sum b_cempindclabfchy3_Llimp0pprb t_cempindclabfchy3_Llimp0pprb

tab t_Llrrgdppc  if t_Llrrgdppc  > -1.96
tab t_Lltotexp0  if t_Lltotexp0  <  1.96
tab t_Llimp0pprb if t_Llimp0pprb <  1.96
tab t_cempindclabfchy3_Llimp0pprb if t_cempindclabfchy3_Llimp0pprb > -1.96

log close















log using "isq_bootstrap_trade_model7.txt", text replace

*******************************************************************************
***** Table B18: Model 7.                                                 *****
***** Randomly replacing 10% of the zero values on each of the exports,   *****
***** raw material imports, and other imports variables with missing      *****
***** values. Resampling is repeated 250 times.                           ***** 
*******************************************************************************	 

// read in data 
use "isq_data.dta", clear 
sort cow_dyadid year
tsset cow_dyadid year

// generate year, donor and recipient dummy variables
foreach num of numlist 1979(1)2001 {
quietly gen year`num' = 0
quietly replace year`num' = 1 if year == `num'
quietly label var year`num' "Dummy for `num'"
}
quietly tab cow_donor, gen(dond)
quietly tab cow_recipient, gen(recd)

// save list of independent variables that are included in all models  	
local indepvars "Lldpop Llrpop Lldrgdppc Llrrgdppc lkmdist colony usaisr Lrpolity Lrconflict Lcempserclabf cempindclabfchy3"

// run the models for the 250 samples and save the results
set more off
set seed 1010101 // set seed to allow for exact replication

gen exp_0_1 = 0 if year >= 1979
gen imppprb_0_1 = 0 if year >= 1979
replace exp_0_1 = 1 if Lltotexp0 != 0 & year >= 1979
replace imppprb_0_1 = 1 if Llimp0pprb != 0 & year >= 1979
tab exp_0_1 if year >= 1979, miss // 4404 zeros (out of 50227 observations)  
tab imppprb_0_1 if year >= 1979, miss // 10419 zeros (out of 50227 observations) 

gen bootstrap_no  = _n
gen b_Llrrgdppc   = .
gen se_Llrrgdppc  = .
gen t_Llrrgdppc   = .
gen b_Lltotexp0   = .
gen se_Lltotexp0  = .
gen t_Lltotexp0   = .
gen b_Llimp0pprb  = .
gen se_Llimp0pprb = .
gen t_Llimp0pprb  = .
gen b_cempindclabfchy3_Llrrgdppc  = .
gen se_cempindclabfchy3_Llrrgdppc = .
gen t_cempindclabfchy3_Llrrgdppc  = .

foreach num of numlist 1/250 {

display "Start: Resampling No " `num'

gen Lltotexp0_m`num' = Lltotexp0 if year >= 1979
gen Llimp0pprb_m`num' = Llimp0pprb if year >= 1979

gen random_exp_m`num' = uniform() if Lltotexp0 == 0 & year >= 1979
sort exp_0_1 random_exp_m`num' 
replace Lltotexp0_m`num' = . in 1/440 // 440 observations = 10% of the missings on the exports variable

gen random_imppprb_m`num' = uniform() if Llimp0pprb == 0 & year >= 1979
sort imppprb_0_1 random_imppprb_m`num'
replace Llimp0pprb_m`num' = . in 1/1042 // 1042 observations = 10% of the missings on the raw material imports variable

sort cow_dyadid year
tsset cow_dyadid year

quietly tobit laid0 `indepvars' Lltotexp0_m`num' Llimp0pprb_m`num' cempindclabfchy3_Llrrgdppc year1980-year2001 dond2-dond21 recd2-recd124 if year >= 1979, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb 
    quietly gen L1laid0_res = L1.laid0_res
tobit laid0 L1laid0_res `indepvars' Lltotexp0_m`num' Llimp0pprb_m`num' cempindclabfchy3_Llrrgdppc year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)

replace b_Llrrgdppc  = _b[Llrrgdppc]  if bootstrap_no == `num'
replace se_Llrrgdppc = _se[Llrrgdppc] if bootstrap_no ==`num'
replace t_Llrrgdppc  = _b[Llrrgdppc] / _se[Llrrgdppc]  if bootstrap_no== `num'

replace b_Lltotexp0  = _b[Lltotexp0_m`num']  if bootstrap_no ==`num'
replace se_Lltotexp0 = _se[Lltotexp0_m`num'] if bootstrap_no ==`num'
replace t_Lltotexp0  = _b[Lltotexp0_m`num'] / _se[Lltotexp0_m`num']  if bootstrap_no ==`num'

replace b_Llimp0pprb  = _b[Llimp0pprb_m`num']  if bootstrap_no ==`num'
replace se_Llimp0pprb = _se[Llimp0pprb_m`num'] if bootstrap_no ==`num'
replace t_Llimp0pprb  = _b[Llimp0pprb_m`num'] / _se[Llimp0pprb_m`num']  if bootstrap_no ==`num'

replace b_cempindclabfchy3_Llrrgdppc  = _b[cempindclabfchy3_Llrrgdppc]  if bootstrap_no ==`num'
replace se_cempindclabfchy3_Llrrgdppc = _se[cempindclabfchy3_Llrrgdppc] if bootstrap_no ==`num'
replace t_cempindclabfchy3_Llrrgdppc  = _b[cempindclabfchy3_Llrrgdppc] / _se[cempindclabfchy3_Llrrgdppc]  if bootstrap_no ==`num'

    quietly drop xb laid0_res L1laid0_res Lltotexp0_m`num' random_exp_m`num' Llimp0pprb_m`num' random_imppprb_m`num'

save "bootstrap_data\bootstrap_trade_model7.dta", replace
log close
log using "isq_bootstrap_trade_model7.txt", text append
} 

    quietly drop cow_dyadid - imppprb_0_1 

save "bootstrap_data\bootstrap_trade_model7.dta", replace

log close


// display summary statistics for the results for the 250 samples

log using "isq_bootstrap_trade_model7_sum.txt", text replace

use "bootstrap_data\bootstrap_trade_model7.dta", clear

sum b_Llrrgdppc  t_Llrrgdppc 
sum b_Lltotexp0  t_Lltotexp0  
sum b_Llimp0pprb t_Llimp0pprb  
sum b_cempindclabfchy3_Llrrgdppc t_cempindclabfchy3_Llrrgdppc

tab t_Llrrgdppc  if t_Llrrgdppc  > -1.96
tab t_Lltotexp0  if t_Lltotexp0  <  1.96
tab t_Llimp0pprb if t_Llimp0pprb <  1.96
tab t_cempindclabfchy3_Llrrgdppc if t_cempindclabfchy3_Llrrgdppc > -1.96

log close






exit


