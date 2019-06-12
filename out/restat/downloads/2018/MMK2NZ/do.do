**"A TIE THAT BINDS: REVISITING THE TRILEMMA IN EMERGING MARKET ECONOMIES"
** BY: Maurice Obstfeld, Jonathan D. Ostry, Mahvash S. Qureshi
**This file provides the code for regression results reported in Tables 1-8 in the paper.

clear
set more off

use "\\data4\users2\mqureshi\My Documents\mqureshi\GFC_ERR\Submissions\RESTAT\FINAL\data.dta", clear
cd "\\data4\users2\mqureshi\My Documents\mqureshi\GFC_ERR\Submissions\RESTAT\FINAL\


foreach var of varlist df_agg_new1 df_agg_new2{
gen `var'_rtbill3m=`var'*rtbill3m
gen `var'_lnvxo=`var'*lnvxo
}

gen crisis=bnkcr
replace crisis=1 if curcr==1 & bnkcr==0

local df_agg_new df_agg_new1 df_agg_new2
local df_agg_new_lnvxo df_agg_new1_lnvxo df_agg_new2_lnvxo
local df_agg_new_rtbill3m df_agg_new1_rtbill3m df_agg_new2_rtbill3m

gen sample=1 if cap100>37.5 & cap100!=. & crisis!=1
label var sample "Sample includes partially open economies & non-crisis observations**

**=====*
**NOTES: 
**=====*

*Quarterly real GDP growth (rgdpgq), real house price growth (rhpgq), real stock price growth (rstockprgq), and institutional quality index (icrg) are not included in the data file because these are proprietary series** 
*Sample size varies across estimations based on data availability for both the public and proprietary data series

*Sample on which real domestic private sector growth (rpscgq) regressions are estimated is sample_rpscgq==1

*Sample on which real house price growth (rhpgq) regressions are estimated is sample_rhpgq==1

*Sample on which real stock price growth (rstockprgq) regressions are estimated is sample_rstockprgq==1

*Sample on which change in LTD ratio (ltdchq) regressions are estimated is sample_ltdchq==1


*============================================*
*TABLE 1: REAL DOMESTIC CREDIT GROWTH IN EMEs*
*============================================*

areg rpscgq `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l2.pscy lnvxo trend gfc3 l1.cap100 if sample==1 & sample_rpscgq==1, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l2.pscy lnvxo trend gfc3 l1.cap100 using Tab1.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust)) replace

areg rpscgq `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l2.pscy l1.cap100 date1-date135 if sample==1 & sample_rpscgq==1, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l2.pscy l1.cap100 using Tab1.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust)) 

areg rpscgq `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l2.pscy `df_agg_new_rtbill3m' date1-date135 l1.cap100 if sample==1 & sample_rpscgq==1, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l2.pscy `df_agg_new_rtbill3m' l1.cap100 using Tab1.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust)) 

areg rpscgq `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l2.pscy l1.rpscgq date1-date135 l1.cap100 if sample==1 & sample_rpscgq==1, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l2.pscy l1.rpscgq l1.cap100 using Tab1.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust)) 

areg rpscgq `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l2.pscy l1.fkfoiliaby l1.cbrttr date1-date135 l1.cap100 if sample==1 & sample_rpscgq==1, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l2.pscy l1.fkfoiliaby l1.cbrttr l1.cap100 using Tab1.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust)) 

areg rpscgq `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l2.pscy date1-date135 l1.cap100 if sample==1 & sample_rpscgq==1 & year>=2000, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l2.pscy l1.cap100 using Tab1.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust)) 


*========================================*
*TABLE 2: REAL HOUSE PRICE GROWTH IN EMEs*
*========================================*
areg rhpgq `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.rpscgq lnvxo trend gfc3 l1.cap100 if sample==1 & sample_rhpgq==1, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.rpscgq lnvxo trend gfc3 l1.cap100 using Tab2.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust)) replace

areg rpscgq `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.rpscgq l1.cap100 date1-date135 if sample==1 & sample_rhpgq==1, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.rpscgq l1.cap100 using Tab2.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust)) 

areg rpscgq `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.rpscgq `df_agg_new_rtbill3m' date1-date135 l1.cap100 if sample==1 & sample_rhpgq==1, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.rpscgq `df_agg_new_rtbill3m' l1.cap100 using Tab2.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust)) 

areg rpscgq `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.rpscgq l1.rhpgq date1-date135 l1.cap100 if sample==1 & sample_rhpgq==1, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l2.pscy l1.rpscgq l1.cap100 using Tab2.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust)) 

areg rpscgq `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.rpscgq l1.fkfoiliaby l1.cbrttr date1-date135 l1.cap100 if sample==1 & sample_rhpgq==1, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l2.pscy l1.fkfoiliaby l1.cbrttr l1.cap100 using Tab2.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust)) 

areg rpscgq `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.rpscgq date1-date135 l1.cap100 if sample==1 & sample_rhpgq==1 & year>=2000, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l2.pscy l1.cap100 using Tab2.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust)) 


*========================================*
*TABLE 3: REAL STOCK PRICE GROWTH IN EMEs*
*========================================*
areg rstockprgq `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.rpscgq lnvxo trend gfc3 l1.cap100 if sample==1 & sample_rstockprgq==1, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.rpscgq lnvxo trend gfc3 l1.cap100 using Tab3.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust)) replace

areg rstockprgq `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.rpscgq l1.cap100 date1-date135 if sample==1 & sample_rstockprgq==1, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.rpscgq l1.cap100 using Tab3.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust)) 

areg rstockprgq `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.rpscgq `df_agg_new_rtbill3m' date1-date135 l1.cap100 if sample==1 & sample_rstockprgq==1, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.rpscgq `df_agg_new_rtbill3m' l1.cap100 using Tab3.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust)) 

areg rstockprgq `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.rpscgq l1.rhpgq date1-date135 l1.cap100 if sample==1 & sample_rstockprgq==1, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l2.pscy l1.rpscgq l1.cap100 using Tab3.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust)) 

areg rstockprgq `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.rpscgq l1.pfly l1.cbrttr date1-date135 l1.cap100 if sample==1 & sample_rstockprgq==1, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l2.pscy l1.fkfoiliaby l1.cbrttr l1.cap100 using Tab3.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust)) 

areg rstockprgq `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.rpscgq date1-date135 l1.cap100 if sample==1 & sample_rstockprgq==1 & year>=2000, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l2.pscy l1.cap100 using Tab3.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust)) 

*======================================*
*TABLE 4: CHANGE IN LTD RATIO IN EMEs  *
*======================================*

areg ltdchq `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l2.ltd  lnvxo trend gfc3 l1.cap100 if sample==1 & sample_ltdchq==1, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l2.ltd  lnvxo trend gfc3 l1.cap100 using Tab4.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust)) replace

areg ltdchq `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l2.ltd  date1-date135 l1.cap100 if sample==1 & sample_ltdchq==1, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l2.ltd l1.cap100 using Tab4.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust))

areg ltdchq `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l2.ltd `df_agg_new_rtbill3m' date1-date135 l1.cap100 if sample==1 & sample_ltdchq==1, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l2.ltd  `df_agg_new_rtbill3m' l1.cap100 using Tab4.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust))

areg ltdchq `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l2.ltd l1.ltdchq date1-date135 l1.cap100 if sample==1 & sample_ltdchq==1, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l2.ltd  l2.ltdchq l1.cap100 using Tab4.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust))

areg ltdchq `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l2.ltd l1.fkfoiliaby l1.cbrttr date1-date135 l1.cap100 if sample==1 & sample_ltdchq==1, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l2.ltd  l1.fkfoiliaby l1.cbrttr l1.cap100 using Tab4.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust))

areg ltdchq `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l2.ltd l1.cap100 date1-date135 if sample==1 & sample_ltdchq==1 & year>=2000, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l2.ltd l1.cap100 using Tab4.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust)) ctitle(>=2000)

*====================================*
* TABLE 5: NET CAPITAL FLOWS IN EMEs *
*====================================*

areg fkfoiliaby `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.icrg l1.pscy lnvxo trend gfc3 l1.cap100 if sample==1 & sample_fkfoiliaby==1, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.icrg l1.pscy lnvxo trend gfc3 l1.cap100 using Tab5.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust)) replace

areg fkfoiliaby `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.icrg l1.pscy l1.cap100  date1-date135  if sample==1 & sample_fkfoiliaby==1, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.icrg l1.pscy l1.cap100 using Tab5.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust))

areg fkfoiliaby `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.icrg l1.pscy `df_agg_new_rtbill3m' l1.cap100  date1-date135  if sample==1 & sample_fkfoiliaby==1, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.icrg l1.pscy l1.cap100 `df_agg_new_rtbill3m' l1.cap100 using Tab5.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust))

areg fkfoiliaby `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.icrg l1.pscy date1-date135 l1.fkfoiliaby l1.cap100 if sample==1 & sample_fkfoiliaby==1, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.icrg l1.pscy l1.fkfoiliaby l1.cap100 using Tab5.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust))

areg fkfoiliaby `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.icrg l1.pscy date1-date135 l1.cap100 if sample==1 & sample_fkfoiliaby==1 & year>=2000, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.icrg l1.pscy l1.cap100 using Tab5.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust)) ctitle(>=2000)

*========================================*
* TABLE 6: LIABILITY/ASSET FLOWS IN EMEs *
*========================================*

areg liab21y `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.icrg l1.pscy lnvxo trend gfc3 l1.cap100 if sample==1 & sample_fkfoiliaby==1, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.icrg l1.pscy lnvxo trend gfc3 l1.cap100 using Tab6.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust)) replace

areg liab21y `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.icrg l1.pscy l1.cap100  date1-date135  if sample==1 & sample_fkfoiliaby==1, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.icrg l1.pscy l1.cap100 using Tab6.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust))

areg liab21y `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.icrg l1.pscy `df_agg_new_rtbill3m' l1.cap100  date1-date135  if sample==1 & sample_fkfoiliaby==1, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.icrg l1.pscy l1.cap100 `df_agg_new_rtbill3m' l1.cap100 using Tab6.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust))

areg liab21y `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.icrg l1.pscy date1-date135 l1.liab21y l1.cap100 if sample==1 & sample_fkfoiliaby==1, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.icrg l1.pscy l1.liab21y l1.cap100 using Tab6.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust))

areg liab21y `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.icrg l1.pscy date1-date135 l1.cap100 if sample==1 & sample_fkfoiliaby==1 & year>=2000, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.icrg l1.pscy l1.cap100 using Tab6.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust)) ctitle(>=2000)

areg assety `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.icrg l1.pscy lnvxo trend gfc3 l1.cap100 if sample==1 & sample_fkfoiliaby==1, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.icrg l1.pscy lnvxo trend gfc3 l1.cap100 using Tab6.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust)) 

areg assety `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.icrg l1.pscy l1.cap100  date1-date135  if sample==1 & sample_fkfoiliaby==1, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.icrg l1.pscy l1.cap100 using Tab6.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust))

areg assety `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.icrg l1.pscy `df_agg_new_rtbill3m' l1.cap100  date1-date135  if sample==1 & sample_fkfoiliaby==1, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.icrg l1.pscy l1.cap100 `df_agg_new_rtbill3m' l1.cap100 using Tab6.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust))

areg assety `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.icrg l1.pscy date1-date135 l1.assety l1.cap100 if sample==1 & sample_fkfoiliaby==1, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.icrg l1.pscy l1.assety l1.cap100 using Tab6.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust))

areg assety `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.icrg l1.pscy date1-date135 l1.cap100 if sample==1 & sample_fkfoiliaby==1 & year>=2000, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.icrg l1.pscy l1.cap100 using Tab6.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust)) ctitle(>=2000)

*=================================*
* TABLE 7: TYPES OF FLOWS IN EMEs *
*=================================*

areg fdily `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.icrg l1.pscy lnvxo trend gfc3 l1.cap100 if sample==1 & sample_fkfoiliaby==1, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.icrg l1.pscy lnvxo trend gfc3 l1.cap100 using Tab7.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust)) replace

areg fdily `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.icrg l1.pscy l1.cap100  date1-date135  if sample==1 & sample_fkfoiliaby==1, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.icrg l1.pscy l1.cap100 using Tab7.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust))

areg fdily `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.icrg l1.pscy `df_agg_new_rtbill3m' l1.cap100  date1-date135  if sample==1 & sample_fkfoiliaby==1, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.icrg l1.pscy l1.cap100 `df_agg_new_rtbill3m' l1.cap100 using Tab7.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust))

areg fdily `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.icrg l1.pscy date1-date135 l1.fdily l1.cap100 if sample==1 & sample_fkfoiliaby==1, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.icrg l1.pscy l1.fdily l1.cap100 using Tab7.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust))

areg pfly `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.icrg l1.pscy lnvxo trend gfc3 l1.cap100 if sample==1 & sample_fkfoiliaby==1, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.icrg l1.pscy lnvxo trend gfc3 l1.cap100 using Tab7.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust)) 

areg pfly `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.icrg l1.pscy l1.cap100  date1-date135  if sample==1 & sample_fkfoiliaby==1, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.icrg l1.pscy l1.cap100 using Tab7.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust))

areg pfly `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.icrg l1.pscy `df_agg_new_rtbill3m' l1.cap100  date1-date135  if sample==1 & sample_fkfoiliaby==1, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.icrg l1.pscy l1.cap100 `df_agg_new_rtbill3m' l1.cap100 using Tab7.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust))

areg pfly `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.icrg l1.pscy date1-date135 l1.pfly l1.cap100 if sample==1 & sample_fkfoiliaby==1, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.icrg l1.pscy l1.pfly l1.cap100 using Tab7.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust))

areg oiliab21y `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.icrg l1.pscy lnvxo trend gfc3 l1.cap100 if sample==1 & sample_fkfoiliaby==1, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.icrg l1.pscy lnvxo trend gfc3 l1.cap100 using Tab7.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust)) replace

areg oiliab21y `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.icrg l1.pscy l1.cap100  date1-date135  if sample==1 & sample_fkfoiliaby==1, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.icrg l1.pscy l1.cap100 using Tab7.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust))

areg oiliab21y `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.icrg l1.pscy `df_agg_new_rtbill3m' l1.cap100  date1-date135  if sample==1 & sample_fkfoiliaby==1, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.icrg l1.pscy l1.cap100 `df_agg_new_rtbill3m' l1.cap100 using Tab7.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust))

areg oiliab21y `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.icrg l1.pscy date1-date135 l1.oiliab21y l1.cap100 if sample==1 & sample_fkfoiliaby==1, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.rgdpgq l1.icrg l1.pscy l1.oiliab21y l1.cap100 using Tab7.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust))

*==================================*
* TABLE 8: REAL GDP GROWTH IN EMEs *
*==================================*

areg rgdpgq `df_agg_new' `df_agg_new_lnvxo' l1.icrg l1.pscy l1.lnrgdpdpc lnvxo trend gfc3 l1.cap100 if sample==1 & sample_rgdpgq==1, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.icrg l1.pscy l1.lnrgdpdpc lnvxo trend gfc3 l1.cap100 using Tab8.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust)) replace

areg rgdpgq `df_agg_new' `df_agg_new_lnvxo' l1.icrg l1.pscy l1.lnrgdpdpc l1.cap100 date1-date135 if sample==1 & sample_rgdpgq==1, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.icrg l1.pscy l1.lnrgdpdpc l1.cap100 using Tab8.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust))

areg rgdpgq `df_agg_new' `df_agg_new_lnvxo' l1.icrg l1.pscy l1.lnrgdpdpc `df_agg_new_rtbill3m' date1-date135 l1.cap100 if cap100>37.5 & cap100!=. & year<2014 & crisis!=1 & nonsample==., absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.icrg l1.pscy l1.lnrgdpdpc `df_agg_new_rtbill3m' l1.cap100 using Tab8.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust))

areg rgdpgq `df_agg_new' `df_agg_new_lnvxo' l1.icrg l1.pscy l1.lnrgdpdpc date1-date135 l1.cap100 if sample==1 & sample_rgdpgq==1, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.icrg l1.pscy l1.lnrgdpdpc l1.cap100 using Tab8.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust)) ctitle(wcrisis)

areg rgdpgq `df_agg_new' `df_agg_new_lnvxo' l1.icrg l1.pscy l1.lnrgdpdpc l1.rgdpgq date1-date135 l1.cap100 if cap100>37.5 & cap100!=. & year<2014 & crisis!=1 & nonsample==., absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.icrg l1.pscy l1.lnrgdpdpc l1.rgdpgq l1.cap100 using Tab8.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust))

areg rgdpgq `df_agg_new' `df_agg_new_lnvxo' l1.icrg l1.pscy l1.lnrgdpdpc  date1-date135 l1.cap100 if sample==1 & sample_rgdpgq==1 & year>=2000, absorb(ifscode) cluster(ifscode)
outreg2 `df_agg_new' `df_agg_new_lnvxo' l1.icrg l1.pscy l1.lnrgdpdpc l1.cap100 using Tab8.xls, dec(3) addstat("Adjusted R2", e(r2_a), "No. of countries", e(N_clust)) ctitle(>=2000)

*clear








