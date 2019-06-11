clear
set more off, perm
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
// Filename: DataConstructionGreenbook.do
//
// Description: This code takes the "Row Format" Greenbook dataset from the
//    Philadelphia Fed's website (in an Excel spreadsheet: GBweb_Row_Format.xls)
//    and merges them, along with a csv file that maps Greenbook dates to FOMC
//    meeting dates (GBFOMCmapping.csv). The latter file was generated from
//    pages on the Federal Reserve Board's historical website
//    (https://www.federalreserve.gov/monetarypolicy/fomc_historical.htm).
//    The output (GBmerged.dta) is used by GreenbookBlueChip.do. 
//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//

// Directories
local indir ../Data_Orig/
local outdir ../IntermediateFiles/
local dirInput "../IntermediateFiles/"

// Import mapping between FOMC meeting and Greenbook dates
import delim `indir'GBFOMCmapping.csv, varnames(1) case(preserve)

// Import and merge Greenbook data
//     gRGDP : real output growth (GNP/GDP)
//     gPGDP : inflation (GNP/GDP deflator)
//     UNEMP : unemployment rate
//     gPCI  : Q/Q PCE inflation annualized (CPI)
//     gPPCE : Q/Q PCE inflation annualized (PCE)

foreach vv in gRGDP gPGDP UNEMP gPCPI gPPCE {
    preserve
    tempfile tempGB
    import excel using "`indir'GBweb_Row_Format.xls", sheet("`vv'") firstrow clear
    save "`tempGB'"
    restore
    merge 1:1 GBdate using `tempGB', nogen keep(match master)
    tostring GBdate, replace
}
gen year = substr(GBdate, 1, 4)
gen month = substr(GBdate, 5, 2)
destring year month , replace


//----------------------------------------------------------------------------//
// Clean up the data 
//----------------------------------------------------------------------------//
// Drop meetings before the time when we only had 8 per year.
drop if FOMCdate < 19810000

// "gbdate" is the date the Greenbook was given to the Committee.
tostring GBdate, replace

// Drop FOMC meetings for which there is no GB forecast
// [occurs at beginning and end of sample].
drop if missing(DATE)

// "date" is the quarter of the forecast, in the format YYYY.Q. This will help
// us line up the forecasts.
ren DATE fdate_gb
egen end_gb_sample = max(year)

// Rename variables to be consistent with blue chip variable names
local gbNames "gRGDP gPGDP UNEMP gPCPI gPPCE"
local bcNames "RealGDP GDPPriceIndex CivilianUnemploymentRate CPI PCE"
local n : word count `gbNames'
forvalues i = 1/`n' {
  local gbn : word `i' of `gbNames'
  local bcn : word `i' of `bcNames'
  renpfix `gbn'B  gb`bcn'_L
  ren     `gbn'F0 gb`bcn'_0
  renpfix `gbn'F  gb`bcn'_F
}
rename *CivilianUnemploymentRate*  *Unemployment*
ds
local preBCvariables  = r(varlist)
//----------------------------------------------------------------------------//
// Merge BlueChip data, created in DataConstruction_BlueChip.do
//----------------------------------------------------------------------------//
merge 1:1 year month using "`dirInput'BlueChip_constructed.dta", ///
                     gen(_merge_GBshockBC)
gen fdate_bc = year + quarter(mdy(month,1,year))/10 // see fdate_gb above
rename *CivilianUnemploymentRate*  *Unemployment*

//----------------------------------------------------------------------------//
// Calculate the difference in the forecasts for each variable
//
// This takes the difference between the Blue Chip and Greenbook forecasts
// in each month. "Blue Chip in each month" literally means the Blue Chip
// forecast made in that month. "Greenbook in that month" means the Greenbook
// forecast made for the meeting in that month. 
//----------------------------------------------------------------------------//
local horizons "L1 0 F1 F2 F3 F4 F5 F6 F7 F8"
local n : word count `horizons'
local n = `n' - 1
sort year month
foreach var in RealGDP GDPPriceIndex Unemployment CPI PCE{
    forvalues i = 1/`n' {
        local t   : word `i' of `horizons'
        local ip1 = `i'+1
        local tp1 : word `ip1' of `horizons'
        gen dGBBC_`var'_`t' = gb`var'_`t' - `var'_`t'q
    }
}


// Save output
keep `preBCvariables' dGBBC* fdate_bc
save `outdir'Greenbook_reg.dta, replace
