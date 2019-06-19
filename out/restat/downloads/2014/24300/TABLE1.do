clear
set more off
set mem 500000

cd ""

cap log close
log using TABLE1.log, text replace

use "RESTAT_REFORMS.dta", clear

**TABLE 1: ** BASELINE OLS GROWTH REGRESSIONS **

sort ifs year
tsset ifs year

xi: reg GDP_Gr lGDP1 TR1 i.ifs i.year, vce(cl ifs)
outreg2 TR1 lGDP1 using TABLE1, bdec(3) nocon word title(Table 1. Baseline Growth Regressions) replace


foreach X in CUR100 AG NW DF BK SM CAP100 CAPRES CAPNONRES  {
xi: reg GDP_Gr lGDP1 `X'1 i.ifs i.year, vce(cl ifs)
outreg2 `X'1 lGDP1 using TABLE1, bdec(3) nocon word title(Table 1. Baseline Growth Regressions)
}

log close
