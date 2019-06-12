

use $dtadir/kpwz_analysis_bld5.dta, clear
set seed 123456
g u = runiform()

*KEEP LARGEST INCOME IN YEAR OF EVENT 
gsort appnum -rev100 u
by appnum: keep if _n==1
drop u 

sort unmasked_tin 
save $dtadir/kpwz_analysis_bld5_largest.dta, replace

