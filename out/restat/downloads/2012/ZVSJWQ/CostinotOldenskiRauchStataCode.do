*Stata code used in Costinot, Oldenski and Rauch, "Adaptation and the Boundary 0f Multinational Firms"


****Sign tests****

cd "C:\"

log using CostinotOldenskiRauch_SignTests.log, replace 

use CostinotOldenskiRauch_SigntestData.dta, replace
signtest mshare_b = mshare_a if prbslv_b >= prbslv_a
bysort naics_b: signtest mshare_b = mshare_a if prbslv_b >= prbslv_a
bysort naics_a: signtest mshare_b = mshare_a if prbslv_b >= prbslv_a
bysort country: signtest mshare_b = mshare_a if prbslv_b >= prbslv_a

log close



****Regressions****

log using CostinotOldenskiRauch.log, replace 
use CostinotOldenskiRauchData.dta, clear


***Non standardized (non Beta) coefficients

*Table 7: Baseline Regressions

quietly xi: reg mshare rtne i.ctryyr, cluster(naics)
modl a  rtne 
quietly xi: reg mshare rtne ln_KL ln_SL ln_rd i.ctryyr, cluster(naics)
modl b  rtne  ln_KL ln_SL  ln_rd 
quietly xi: reg mshare rtne ln_KL ln_SL ln_rd zi_rs1 i.ctryyr, cluster(naics)
modl c  rtne  ln_KL ln_SL ln_rd zi_rs1 
quietly xi: reg mshare rtne ln_KL ln_SL ln_rd zi_rs1 intrmd i.ctryyr, cluster(naics)
modl d rtne  ln_KL ln_SL ln_rd zi_rs1 intrmd 
quietly xi: reg mshare rtne ln_KL ln_SL ln_rd zi_rs1 intrmd cv i.ctryyr, cluster(naics)
modl e rtne  ln_KL ln_SL ln_rd zi_rs1 intrmd cv 

modltbl ts a b c d e, Table 7: non-standardized coefficients for 4-digit naics, 2000-2006, SE's 
clustered by industry, ctry-year FE
macro drop _all


*Table 8: Regressions for High Income OECD Countries

quietly xi: reg mshare rtne i.ctryyr if wbinc==1, cluster(naics)
modl a  rtne 
quietly xi: reg mshare rtne ln_KL ln_SL ln_rd i.ctryyr if wbinc==1, cluster(naics)
modl b  rtne  ln_KL ln_SL  ln_rd 
quietly xi: reg mshare rtne ln_KL ln_SL ln_rd zi_rs1 i.ctryyr if wbinc==1, cluster(naics)
modl c  rtne  ln_KL ln_SL ln_rd zi_rs1 
quietly xi: reg mshare rtne ln_KL ln_SL ln_rd zi_rs1 intrmd i.ctryyr if wbinc==1, cluster(naics)
modl d rtne  ln_KL ln_SL ln_rd zi_rs1 intrmd 
quietly xi: reg mshare rtne ln_KL ln_SL ln_rd zi_rs1 intrmd cv i.ctryyr if wbinc==1, cluster(naics)
modl e rtne  ln_KL ln_SL ln_rd zi_rs1 intrmd cv 

modltbl ts a b c d e, Table 8: non-standardized coefficients for High Income OECD Countries, 4-digit 
naics, 2000-2006, SE's clustered by industry, ctry-year FE
macro drop _all


*Table 9: Regressions for All Other Countries

quietly xi: reg mshare rtne i.ctryyr if wbinc==0, cluster(naics)
modl j  rtne 
quietly xi: reg mshare rtne ln_KL ln_SL ln_rd i.ctryyr if wbinc==0, cluster(naics)
modl k  rtne  ln_KL ln_SL  ln_rd 
quietly xi: reg mshare rtne ln_KL ln_SL ln_rd zi_rs1 i.ctryyr if wbinc==0, cluster(naics)
modl l  rtne  ln_KL ln_SL ln_rd zi_rs1 
quietly xi: reg mshare rtne ln_KL ln_SL ln_rd zi_rs1 intrmd i.ctryyr if wbinc==0, cluster(naics)
modl m rtne  ln_KL ln_SL ln_rd zi_rs1 intrmd 
quietly xi: reg mshare rtne ln_KL ln_SL ln_rd zi_rs1 intrmd cv i.ctryyr if wbinc==0, cluster(naics)
modl n rtne  ln_KL ln_SL ln_rd zi_rs1 intrmd cv 

modltbl ts j k l m n, Table 9: non-standardized coefficients for All Other Countries, 4-digit naics, 
2000-2006, SE's clustered by industry, ctry-year FE
macro drop _all


*Table 10: Regressions for Restricted Set of Countries

quietly xi: reg mshare rtne i.ctryyr if rstrct==1, cluster(naics)
modl a  rtne 
quietly xi: reg mshare rtne ln_KL ln_SL ln_rd i.ctryyr if rstrct==1, cluster(naics)
modl b  rtne  ln_KL ln_SL  ln_rd 
quietly xi: reg mshare rtne ln_KL ln_SL ln_rd zi_rs1 i.ctryyr if rstrct==1, cluster(naics)
modl c  rtne  ln_KL ln_SL ln_rd zi_rs1 
quietly xi: reg mshare rtne ln_KL ln_SL ln_rd zi_rs1 intrmd i.ctryyr if rstrct==1, cluster(naics)
modl d rtne  ln_KL ln_SL ln_rd zi_rs1 intrmd 
quietly xi: reg mshare rtne ln_KL ln_SL ln_rd zi_rs1 intrmd cv i.ctryyr if rstrct==1, cluster(naics)
modl e rtne  ln_KL ln_SL ln_rd zi_rs1 intrmd cv 

modltbl ts a b c d e, Table 10: Restricted country sample, 4-digit naics, 2000-2006, SE's clustered by 
industry, ctry-year FE
macro drop _all


*Table 11: Regressions Only Including Nonzero Intrafirm Import Shares

quietly xi: reg mshare rtne i.ctryyr if mshare~=0, cluster(naics)
modl a  rtne 
quietly xi: reg mshare rtne ln_KL ln_SL ln_rd i.ctryyr if mshare~=0, cluster(naics)
modl b  rtne  ln_KL ln_SL  ln_rd 
quietly xi: reg mshare rtne ln_KL ln_SL ln_rd zi_rs1 i.ctryyr if mshare~=0, cluster(naics)
modl c  rtne  ln_KL ln_SL ln_rd zi_rs1 
quietly xi: reg mshare rtne ln_KL ln_SL ln_rd zi_rs1 intrmd i.ctryyr if mshare~=0, cluster(naics)
modl d rtne  ln_KL ln_SL ln_rd zi_rs1 intrmd 
quietly xi: reg mshare rtne ln_KL ln_SL ln_rd zi_rs1 intrmd cv i.ctryyr if mshare~=0, cluster(naics)
modl e rtne  ln_KL ln_SL ln_rd zi_rs1 intrmd cv 

modltbl ts a b c d e, Table 11: non-standardized coefficients usin Non-zero import shares only, 4-
digit naics, 2000-2006, SE's clustered by industry, ctry-year FE
macro drop _all


log close




*****Standardized Beta Coefficients*****


log using CostinotOldenskiRauch_Betas.log, replace 
use CostinotOldenskiRauchData.dta, clear


*Table 7: Baseline Regressions

xi: reg mshare rtne i.ctryyr, beta
xi: reg mshare rtne ln_KL ln_SL ln_rd i.ctryyr, beta
xi: reg mshare rtne ln_KL ln_SL ln_rd zi_rs1 i.ctryyr, beta
xi: reg mshare rtne ln_KL ln_SL ln_rd zi_rs1 intrmd i.ctryyr, beta
xi: reg mshare rtne ln_KL ln_SL ln_rd zi_rs1 intrmd cv i.ctryyr, beta


*Table 8: Regressions for High Income OECD Countries

xi: reg mshare rtne i.ctryyr if wbinc==1, beta
xi: reg mshare rtne ln_KL ln_SL ln_rd i.ctryyr if wbinc==1, beta
xi: reg mshare rtne ln_KL ln_SL ln_rd zi_rs1 i.ctryyr if wbinc==1, beta
xi: reg mshare rtne ln_KL ln_SL ln_rd zi_rs1 intrmd i.ctryyr if wbinc==1, beta
xi: reg mshare rtne ln_KL ln_SL ln_rd zi_rs1 intrmd cv i.ctryyr if wbinc==1, beta


*Table 9: Regressions for All Other Countries

xi: reg mshare rtne i.ctryyr if wbinc==0, beta
xi: reg mshare rtne ln_KL ln_SL ln_rd i.ctryyr if wbinc==0, beta
xi: reg mshare rtne ln_KL ln_SL ln_rd zi_rs1 i.ctryyr if wbinc==0, beta
xi: reg mshare rtne ln_KL ln_SL ln_rd zi_rs1 intrmd i.ctryyr if wbinc==0, beta
xi: reg mshare rtne ln_KL ln_SL ln_rd zi_rs1 intrmd cv i.ctryyr if wbinc==0, beta


*Table 10: Regressions for Restricted Set of Countries

xi: reg mshare rtne i.ctryyr if rstrct==1, beta
xi: reg mshare rtne ln_KL ln_SL ln_rd i.ctryyr if rstrct==1, beta
xi: reg mshare rtne ln_KL ln_SL ln_rd zi_rs1 i.ctryyr if rstrct==1, beta
xi: reg mshare rtne ln_KL ln_SL ln_rd zi_rs1 intrmd i.ctryyr if rstrct==1, beta
xi: reg mshare rtne ln_KL ln_SL ln_rd zi_rs1 intrmd cv i.ctryyr if rstrct==1, beta


*Table 11: Regressions Only Including Nonzero Intrafirm Import Shares

xi: reg mshare rtne i.ctryyr if mshare~=0, beta
xi: reg mshare rtne ln_KL ln_SL ln_rd i.ctryyr if mshare~=0, beta
xi: reg mshare rtne ln_KL ln_SL ln_rd zi_rs1 i.ctryyr if mshare~=0, beta
xi: reg mshare rtne ln_KL ln_SL ln_rd zi_rs1 intrmd i.ctryyr if mshare~=0, beta
xi: reg mshare rtne ln_KL ln_SL ln_rd zi_rs1 intrmd cv i.ctryyr if mshare~=0, beta


log close
