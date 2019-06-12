version 11.0
set more off
capture log close
log using "isq_table.txt", text replace




*******************************************************************************
***** Replication code for                                                *****
***** Johannes Kleibl. "Tertiarization, Infustrial Adjustment, and the    *****
***** Domestic Politics of Foreign Aid." International Studies Quarterly. *****
***** October 3, 2011                                                     *****
*******************************************************************************




*******************************************************************************
***** Replication of results in Table 1.                                  ***** 
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




// Model 1 (without any interactions)
quietly tobit laid0 `indepvars' Llimp0ltmtht year1980-year2001 dond2-dond21 recd2-recd124 if year >= 1979, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb
    quietly gen L1laid0_res = L1.laid0_res 
tobit laid0 L1laid0_res `indepvars' Llimp0ltmtht year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

	
	
	
// Model 2 (interaction between exports and services employment)
quietly tobit laid0 `indepvars' Lcempserclabf_Lltotexp0 year1980-year2001 dond2-dond21 recd2-recd124 if year >= 1979, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb
    quietly gen L1laid0_res = L1.laid0_res 
tobit laid0 L1laid0_res `indepvars' Lcempserclabf_Lltotexp0 year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

// calculate % change in aid provision if volume of exports doubles for ...
quietly sum Lcempserclabf if e(sample), d
// ... services employment at 10th percentile
disp ((2^(_b[Lltotexp0] + _b[Lcempserclabf_Lltotexp0] * r(p10))) - 1) * 100
// ... services employment at 90th percentile
disp ((2^(_b[Lltotexp0] + _b[Lcempserclabf_Lltotexp0] * r(p90))) - 1) * 100




// Model 3 (interaction between imports and services employment)
quietly tobit laid0 `indepvars' Lcempserclabf_Llimp0pprb year1980-year2001 dond2-dond21 recd2-recd124 if year >= 1979, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb
    quietly gen L1laid0_res = L1.laid0_res 
tobit laid0 L1laid0_res `indepvars' Lcempserclabf_Llimp0pprb year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

// calculate % change in aid provision if volume of imports doubles for ...
quietly sum Lcempserclabf if e(sample), d
// ... services employment at 10th percentile
disp ((2^(_b[Llimp0pprb] + _b[Lcempserclabf_Llimp0pprb] * r(p10))) - 1) * 100
// ... services employment at 90th percentile
disp ((2^(_b[Llimp0pprb] + _b[Lcempserclabf_Llimp0pprb] * r(p90))) - 1) * 100




// Model 4 (interaction between recipients' GDPPC and services employment)
quietly tobit laid0 `indepvars' Lcempserclabf_Llrrgdppc year1980-year2001 dond2-dond21 recd2-recd124 if year >= 1979, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb
    quietly gen L1laid0_res = L1.laid0_res 
tobit laid0 L1laid0_res `indepvars' Lcempserclabf_Llrrgdppc year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res  

// calculate % change in aid provision if recipients' GDPPC doubles for ...
quietly sum Lcempserclabf if e(sample), d
// ... services employment at 10th percentile
disp ((2^(_b[Llrrgdppc] + _b[Lcempserclabf_Llrrgdppc] * r(p10))) - 1) * 100
// ... services employment at 90th percentile
disp ((2^(_b[Llrrgdppc] + _b[Lcempserclabf_Llrrgdppc] * r(p90))) - 1) * 100




// Model 5 (interaction between exports and change in industrial employment)
quietly tobit laid0 `indepvars' cempindclabfchy3_Lltotexp0 year1980-year2001 dond2-dond21 recd2-recd124 if year >= 1979, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb
    quietly gen L1laid0_res = L1.laid0_res 
tobit laid0 L1laid0_res `indepvars' cempindclabfchy3_Lltotexp0 year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

// calculate % change in aid provision if volume of exports doubles for ...
quietly sum cempindclabfchy3 if e(sample), d
// ... change in industrial employment at 10th percentile	
disp ((2^(_b[Lltotexp0] + _b[cempindclabfchy3_Lltotexp0] * r(p10))) - 1) * 100
// ... change in industrial employment at 90th percentile
disp ((2^(_b[Lltotexp0] + _b[cempindclabfchy3_Lltotexp0] * r(p90))) - 1) * 100




// Model 6 (interaction between imports and change in industrial employment)
quietly tobit laid0 `indepvars' cempindclabfchy3_Llimp0pprb year1980-year2001 dond2-dond21 recd2-recd124 if year >= 1979, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb
    quietly gen L1laid0_res = L1.laid0_res 
tobit laid0 L1laid0_res `indepvars' cempindclabfchy3_Llimp0pprb year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res 

// calculate % change in aid provision if volume of imports doubles for ...
quietly sum cempindclabfchy3 if e(sample), d
// ... change in industrial employment at 10th percentile	
disp ((2^(_b[Llimp0pprb] + _b[cempindclabfchy3_Llimp0pprb] * r(p10))) - 1) * 100
// ... change in industrial employment at 90th percentile
disp ((2^(_b[Llimp0pprb] + _b[cempindclabfchy3_Llimp0pprb] * r(p90))) - 1) * 100




// Model 7 (interaction between recipients' GDPPC and change in industrial employment)
quietly tobit laid0 `indepvars' cempindclabfchy3_Llrrgdppc year1980-year2001 dond2-dond21 recd2-recd124 if year >= 1979, ll(0) vce(cluster cow_dyadid)
    quietly predict xb, xb
    quietly gen laid0_res = laid0 - xb
    quietly gen L1laid0_res = L1.laid0_res 
tobit laid0 L1laid0_res `indepvars' cempindclabfchy3_Llrrgdppc year1981-year2001 dond2-dond21 recd2-recd124 if year >= 1980, ll(0) vce(cluster cow_dyadid)
    quietly drop xb laid0_res L1laid0_res  

// calculate % change in aid provision if volume of imports doubles for ...
quietly sum cempindclabfchy3 if e(sample), d
// ... change in industrial employment at 10th percentile
disp ((2^(_b[Llrrgdppc] + _b[cempindclabfchy3_Llrrgdppc] * r(p10))) - 1) * 100
// ... change in industrial employment at 90th percentile
disp ((2^(_b[Llrrgdppc] + _b[cempindclabfchy3_Llrrgdppc] * r(p90))) - 1) * 100



 
log close
  

