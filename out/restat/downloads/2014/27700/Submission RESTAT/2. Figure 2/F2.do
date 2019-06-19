clear all
cd "H:\Superstars\Submission RESTAT\"

use "2. Figure 2\input\rank_top5.dta", clear
xi: reg lnv i.year
predict lnv_r, residuals
twoway (scatter lnv_r lnrh if ind=="A", sort), by(country) title("Text. & Apparel - TOP5") ytitle("ln (value)") xtitle("ln (rank-1/2)")
graph save Graph "2. Figure 2\F2_Text.gph", replace
use "2. Figure 2\input\rank_top5.dta", clear
xi: reg lnv i.year
predict lnv_r, residuals
twoway (scatter lnv_r lnrh if ind=="B", sort), by(country) title("Mach. & Transp.- TOP5") ytitle("ln (value)") xtitle("ln (rank-1/2)")
graph save Graph "2. Figure 2\F2_Mach.gph", replace
use "2. Figure 2\input\rank_top5.dta", clear
xi: reg lnv i.year
predict lnv_r, residuals
twoway (scatter lnv_r lnrh if ind=="C", sort), by(country) title("Food- TOP5") ytitle("ln (value)") xtitle("ln (rank-1/2)")
graph save Graph "2. Figure 2\F2_Food.gph", replace
