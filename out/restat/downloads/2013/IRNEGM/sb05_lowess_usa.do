set more off 
********
********10% bins! Don't forget to change bsize in sb05_lowess_inline_10pct.do
********

*********************
*Set Paths/Directories
*********************

***
local root_dir "F:\NETSData2007\Generated_files\SB05"
***
local log_dir "F:\NETSData2007\Generated_files\SB05\Logs"
local result_dir "F:\NETSData2007\Generated_files\SB05\FinalResults"

*********************
*Set Input/Output Filenames
*********************

***
local iteration "112608_10pct"
***
local bsize "10"

local log_file "`log_dir'\lowess_`iteration'.log"

***
* baseline graph: Figure 1
***


use "`root_dir'\Results4a\firmnonpardata.dta", clear
rename avgfirmemp avgemp
do "`root_dir'\sb05_lowess_inline_`bsize'pct.do"
save "`result_dir'\1nonpar\firm_nonpar_4a_`bsize'pct.dta", replace


foreach x in 4a {
use "`result_dir'\1nonpar\firm_nonpar_`x'_`bsize'pct.dta", clear
sort avgemp
keep avgemp y_hat
rename y_hat y_hat_`x'
sort avgemp
save "`result_dir'\1nonpar\firm_nonpar_`x'_`bsize'pct.dta", replace
}


*b/w
*all emp
*twoway (line y_hat_4a avgemp, lpattern(solid)) if avgemp<200000 & avgemp>=5, ytitle(Smoothed net employment growth rate (%)) xtitle(Firm size)
*graph save "`result_dir'\figure1a_`bsize'"
* 5-5000 emp
twoway (line y_hat_4a avgemp, lpattern(solid)) if avgemp<50000 & avgemp>=5, ytitle(Smoothed net employment growth rate (%)) xtitle(Firm size)
graph save "`result_dir'\figure1b_`bsize'"

***
* combined graph - scope of observations: Figure 2
***


use "`root_dir'\Results4a\nonpardata.dta", clear
do "`root_dir'\sb05_lowess_inline_`bsize'pct.do"
save "`result_dir'\1nonpar\nonpar_4a_`bsize'pct.dta", replace
use "`root_dir'\Results4b\nonpardata.dta", clear
do "`root_dir'\sb05_lowess_inline_`bsize'pct.do"
save "`result_dir'\1nonpar\nonpar_4b_`bsize'pct.dta", replace
use "`root_dir'\Results4c\nonpardata.dta", clear
do "`root_dir'\sb05_lowess_inline_`bsize'pct.do"
save "`result_dir'\1nonpar\nonpar_4c_`bsize'pct.dta", replace


foreach x in 4a 4b 4c {
use "`result_dir'\1nonpar\nonpar_`x'_`bsize'pct.dta", clear
sort avgemp
keep avgemp y_hat
rename y_hat y_hat_`x'
save "`result_dir'\1nonpar\nonpar_`x'_`bsize'pct.dta", replace
}

use "`result_dir'\1nonpar\nonpar_4a_`bsize'pct.dta", clear
foreach x in 4b 4c {
merge avgemp using "`result_dir'\1nonpar\nonpar_`x'_`bsize'pct.dta"
drop _merge
sort avgemp
}

*b/w
*all emp
*twoway (line y_hat_4a avgemp, lpattern(solid)) (line y_hat_4b avgemp, lpattern(dash)) (line y_hat_4c avgemp, lpattern(shortdash)) if avgemp<10000, ytitle(Smoothed net employment growth rate (%)) xtitle(Establishment size) legend(order(1 "All Industries" 2 "Manufacturing" 3 "Services"))
*graph save "`result_dir'\figure2a_`bsize'"
* 5-2000 emp
twoway (line y_hat_4a avgemp, lpattern(solid)) (line y_hat_4b avgemp, lpattern(dash)) (line y_hat_4c avgemp, lpattern(shortdash)) if avgemp<5000 & avgemp>=5, ytitle(Smoothed net employment growth rate (%)) xtitle(Establishment size) legend(order(1 "All Industries" 2 "Manufacturing" 3 "Services"))
graph save "`result_dir'\figure2_`bsize'"


