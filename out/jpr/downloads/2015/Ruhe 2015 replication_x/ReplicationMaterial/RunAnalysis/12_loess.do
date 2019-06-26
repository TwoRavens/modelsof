
use "$data", clear
*declare as panel data
xtset dyad_unique month
*create variables needed for analysis
quietly forvalues t=1/5 {
foreach var in lbest_est fatal lwma_distance_mean lwma_distance_mean2 lwma_distance_mean3 {
gen L`t'`var'=L`t'.`var'
}
}
saveold loess.dta, replace

local directory c(pwd)
display `directory'
local directory=subinstr(`directory', "\", "\\", .)
display "`directory'"

quietly: file open Rcode using  12b_call_R.R, write replace
quietly: file write Rcode ///
    `"setwd("`directory'")"' _newline ///
    `"source("12a_loess.R")"'
quietly: file close Rcode

shell "$R_dir" CMD BATCH 12b_call_R.R

