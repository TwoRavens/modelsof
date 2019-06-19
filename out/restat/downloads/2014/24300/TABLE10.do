clear
set more off
set mem 500000

cd ""

cap log close
log using TABLE10.log, text replace

use "RESTAT_REFORMS.dta", clear
**Table 10: Growth regressions, Emerging and developing economies (without Somalia)***
preserve
keep if DEV_EMERGING==1
drop if ifs==726
sort ifs year
tsset ifs year

xi: reg GDP_Gr lGDP1 TR1 i.ifs i.year, vce(cl ifs)
outreg2 TR1 lGDP1 using TABLE10, bdec(3) nocon word title(Table 10. Reforms and Growth, Emerging and Developing Economies) replace


foreach X in CUR100 AG NW DF BK SM CAP100 CAPRES CAPNONRES  {
xi: reg GDP_Gr lGDP1 `X'1 i.ifs i.year, vce(cl ifs)
outreg2 `X'1 lGDP1 using TABLE10, bdec(3) nocon word title(Table 10. Reforms and Growth, Emerging and Developing Economies)
}
 
restore
log close
