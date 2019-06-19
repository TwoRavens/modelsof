*Notes: excludes establishments that were never located in California.
*Notes: uses NETS 05 data from Ingrid's directory.
*uses NAICS codes. also is better equiped to handle firm growth, imputation and rounding than sb05_old

*********************
*Set Paths/Directories
*********************

foreach runtype in 1a 1b 1c 1d 2d 4b 4c 5c {

***
local root_dir "F:\NETSData2007\Generated_files\SB05\Results`runtype'"
***
local log_dir "F:\NETSData2007\Generated_files\SB05\Logs"
local result_dir "F:\NETSData2007\Generated_files\SB05\FinalResults"
local temp_dir "F:\NETSData2007\Generated_files\SB05\Temp"

*********************
*Set Input/Output Filenames
*********************

***
local iteration "usa_`runtype'"
***

local log_file "`log_dir'\\reformat_`iteration'.log"

clear
set mem 100m
set more off
capture log close
log using "`log_file'", replace

*********************
*aggregate results into one file for each type of calculation
*********************

mkdir `result_dir'\\`iteration'

foreach type in firmcurr firmbase base curr {

*gen share for gc and gd
use `root_dir'\\`type'_gcreation.dta, clear
forvalues x=1994/2005 {
quietly: sum _`x'
replace _`x'=_`x'/`r(sum)'
}
save "`root_dir'\\`type'_gcreation_share.dta", replace

use `root_dir'\\`type'_gdestruct.dta, clear
forvalues x=1994/2005 {
quietly: sum _`x'
replace _`x'=_`x'/`r(sum)'
}
save  `root_dir'\\`type'_gdestruct_share.dta, replace

clear
set obs 1
gen rowname = "gross creation rate"
append using `root_dir'\\`type'_gc_rate.dta

count
local newobs = `r(N)' + 2
set obs `newobs'
replace rowname = "gross destruction rate" in `newobs'
append using `root_dir'\\`type'_gd_rate.dta

count
local newobs = `r(N)' + 2
set obs `newobs'
replace rowname = "net creation rate" in `newobs'
append using `root_dir'\\`type'_nc_rate.dta

count
local newobs = `r(N)' + 2
set obs `newobs'
replace rowname = "employment share" in `newobs'
append using `root_dir'\\`type'_empshare.dta

count
local newobs = `r(N)' + 2
set obs `newobs'
replace rowname = "creation" in `newobs'
append using `root_dir'\\`type'_gcreation.dta

count
local newobs = `r(N)' + 2
set obs `newobs'
replace rowname = "creation share" in `newobs'
append using `root_dir'\\`type'_gcreation_share.dta

count
local newobs = `r(N)' + 2
set obs `newobs'
replace rowname = "destruction" in `newobs'
append using `root_dir'\\`type'_gdestruct.dta

count
local newobs = `r(N)' + 2
set obs `newobs'
replace rowname = "destruction share" in `newobs'
append using `root_dir'\\`type'_gdestruct_share.dta

count
local newobs = `r(N)' + 2
set obs `newobs'
replace rowname = "total employment" in `newobs'
append using `root_dir'\\`type'emp.dta


/*generate year-on-year averages (based on 1994-2004 range, 11 years)
gen avg = _1994 + _1995 + _1996 + _1997 + _1998 + _1999 + _2000 + _2001 + _2002 + _2003 + _2004
replace avg = avg/11
*/

*generate year-on-year averages (based on 1994-2005 range, 12 years)
gen avg = _1994 + _1995 + _1996 + _1997 + _1998 + _1999 + _2000 + _2001 + _2002 + _2003 + _2004 + _2005
replace avg = avg/12
*

save `result_dir'\\`iteration'\\1_`type'_total_output.dta, replace

foreach file in `type'_gcreation `type'_gdestruct `type'emp `type'_netchange `type'_gc_rate `type'_gd_rate `type'_nc_rate `type'_empshare `type'_gcreation_share `type'_gdestruct_share {
copy `root_dir'\\`file'.dta `result_dir'\\`iteration'\\`file'.dta
erase `root_dir'\\`file'.dta
}


}

}

log close

