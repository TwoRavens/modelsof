clear
set more off
set mem 500000

cd ""

cap log close
log using TABLE5.log, text replace

use "RESTAT_REFORMS.dta", clear
******************************************************
*TABLE 5: GMM, Arellano Bond                         *
******************************************************

sort ifs year
xtset ifs year

xtabond2 lGDP l.lGDP TR1 yeardum*, gmm(l.lGDP) iv(TR1 yeardum*) noleveleq robust
outreg2 TR1 L1.lGDP using TABLE5, bdec(3) nocon word title(Table 5. Reforms and Growth: Arellano-Bond GMM) replace



foreach X in CUR100 AG NW DF BK SM CAP100 CAPRES CAPNONRES  {
xtabond2 lGDP l.lGDP `X'1 yeardum*, gmm(l.lGDP) iv(`X'1 yeardum*) noleveleq robust
outreg2 `X'1 L1.lGDP using TABLE5, bdec(3) nocon word title(Table 5. Reforms and Growth: Arellano-Bond GMM) 
}


log close

