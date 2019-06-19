clear
set more off
set mem 500000

cd ""

cap log close
log using TABLE11.log, text replace

use "RESTAT_REFORMS.dta", clear
**TABLE 11: Growth regressions, 3 year interval data**

preserve
keep if (year==1973 | year==1976 | year==1979 | year==1982 | year==1985 | year==1988 | year==1991 | year==1994 | year==1997 | year==2000 | year==2003 | year==2006)
sort ifs year
**gen log GDP**
gen lGDP3=ln(rgdpch)
**gen lag log GDP***
by ifs: gen lGDP3_1=lGDP3[_n-1]
**gen growth rate**
gen GDP_Gr3=lGDP3-lGDP3_1

foreach X in TR CUR100 AG NW DF BK SM CAP100 CAPRES CAPNONRES  {
by ifs: gen `X'3=`X'[_n-1]
}

tsset ifs year
xi: reg GDP_Gr3 lGDP3_1 TR3 i.ifs i.year, vce(cl ifs)
outreg2 TR3 lGDP3_1 using TABLE11, bdec(3) nocon word title(Table 11. Reforms and Growth, Three-year interval) replace

foreach X in CUR100 AG NW DF BK SM CAP100 CAPRES CAPNONRES  {
xi: reg GDP_Gr3 lGDP3_1 `X'3 i.ifs i.year, vce(cl ifs)
outreg2 `X'3 lGDP3_1 using TABLE11, bdec(3) nocon word title(Table 11. Reforms and Growth, Three-year interval) 
}

restore
log close
