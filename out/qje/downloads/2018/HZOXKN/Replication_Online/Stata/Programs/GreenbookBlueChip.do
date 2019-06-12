//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
// Filename: GreenbookBlueChip.do
//
// Description: This file merges the Greenbook (GB) forecasts, Blue Chip (BC)
//     forecasts, and the policy news shock. It then runs the regressions---in
//     Nakamura and Steinsson's "High Frequency Identification of Monetary
//     Non-Neutrality" (2016)---that studies the relationship between
//     forecast differences in the BC and GB and the policy news shock.
//     The output is stored as two xml files, which can be opened in Excel.
//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//

// Get Stata ready
set memory 2g
set more off, perm
clear all

// Set up directories
local dirInput "../IntermediateFiles/"
local outdir "../Output/"

//----------------------------------------------------------------------------//
// Import Greenbook forecasts (created by DataConstructionGreenbook.do)
//----------------------------------------------------------------------------//
use "`dirInput'Greenbook_reg.dta", clear


//----------------------------------------------------------------------------//
//  Merge shocks series, created in OLSBlueChip.do
//----------------------------------------------------------------------------//
merge 1:1 year month  using "`dirInput'MonthlyShock.dta", ///
                      gen(_merge_GBshock)



// Select sample (The Crisis observations are dropped from the shock series)
keep if year >= 1995 & year <=2009

//----------------------------------------------------------------------------//
// Regressions for difference in forecasts; that is, the first set of
// Greenbook regressions:
//
//           100*shock_t = a + b (GDP^GB_t - GDP^BC_t)
// 
//----------------------------------------------------------------------------//
local shock "con_mshock_path_intra_wide_m"
local x "RealGDP"

gen  `shock'100 =  `shock' * 100

local CWD `c(pwd)'
cd `outdir'

foreach t in 0 F1 F2 F3 F4 F5 F6 F7 {
    // What to do with the output file.
    if "`t'" == "0" {
        local replaceOrAppend "replace"
    }
    else {
        local replaceOrAppend "append"
    }

    // Effect of shock on difference: exclude months with shock of size 0
    //                                (i.e., months w/ no meeting)
    reg `shock'100 dGBBC_`x'_`t'  if `shock' != 0, r
    outreg2 using OLS_GBBC_`shock', excel `replaceOrAppend' ///
                                    stats(coef, se) dec(2) label noaster
}


//----------------------------------------------------------------------------//
// Calculate the change in the difference in forecasts for each variable
// This creates d_dGBBC_q, where q is relative to the quarter of the month
// (that is, if the observation month is 2, then q corresponds to Q1).
// We take the difference (across meetings) between the difference in GB and
// BC forecasts of quarter q. So, the first step is to drop non-meeting months
// so that we can easily make comparisons across FOMC meetings.
//----------------------------------------------------------------------------//
keep if !missing(FOMCdate)
// Take chagne in differences
local horizons "L1 0 F1 F2 F3 F4 F5 F6 F7"
local N : word count `horizons'
local Nm1 = `N' - 1
sort year month
foreach var in RealGDP GDPPriceIndex Unemployment CPI PCE{
    forvalues i = 1/`Nm1' {
        local t   : word `i' of `horizons'
        local ip1 = `i' + 1
        local tp1 : word `ip1' of `horizons'  
        gen d_dGBBC_`var'_`t'     = dGBBC_`var'_`t'[_n] - dGBBC_`var'_`t'[_n-1]
        replace d_dGBBC_`var'_`t' = dGBBC_`var'_`t'[_n] - dGBBC_`var'_`tp1'[_n-1] if fdate_bc[_n] > fdate_bc[_n-1]
    }
    local last   : word `N' of `horizons'
    gen d_dGBBC_`var'_`last'     = dGBBC_`var'_`last'[_n] - dGBBC_`var'_`last'[_n-1] if fdate_bc[_n] == fdate_bc[_n-1]
}

//----------------------------------------------------------------------------//
// Regressions for the change in foreast differences
// These are the the second set of Greenbook regressions:
//
// (GDP^GB_{t} - GDP^BC_{t}) - (GDP^GB_{t-1} - GDP^BC_{t-1}) = a + b shock_{t-1}
//
// Note that the timing is FORECAST SHOCK FORECAST, where the quarter of the
// forecast is aligned with the second forecast.
//----------------------------------------------------------------------------//
sort year month
//gen Fcon_mshock_path_intra_wide_m = con_mshock_path_intra_wide_m[_n+1]
gen L`shock' = `shock'[_n-1]

foreach t in L1 0 F1 F2 F3 F4 F5 F6 F7 {
    // What to do with the output file.
    if "`t'" == "L1" {
        local replaceOrAppend "replace"
    }
    else {
        local replaceOrAppend "append"
    }
    // change in (BC - GB)
    reg    d_dGBBC_`x'_`t' L`shock' if L`shock' != 0, r
    outreg2 using OLS_d_GBBC_`shock', excel `replaceOrAppend' ///
                                      stats(coef, se) dec(2) label noaster
}

cd "`CWD'"
