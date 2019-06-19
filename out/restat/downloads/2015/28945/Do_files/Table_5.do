*-----------------------------------------------------------------------------------------------------------------------------*
* This do-file generates Table 5 of Berman and Couttenier (2014)															  *
* This version: january 29, 2014																							  *
*-----------------------------------------------------------------------------------------------------------------------------*
*
clear all
cd "$Results"
*
			*--------------------------------------------*
			*--------------------------------------------*
			*  TABLE 5 - SHOCK CRISIS: BASELINE RESULTS  *     
			*--------------------------------------------*
			*--------------------------------------------*
*
***********************
* PANEL A: shock only *
**********************
*
foreach x in c3 c1 c2{
use "$Output_data\data_BC_Restat2014", clear
*
label var exposure_crisis "Exposure to crises "
label var crisis_ldist    "Exp. to crises  $\times$ remoteness$^1$"
*
gen location = group_gid
drop if conflict_`x' == .
*
eststo: clogit conflict_`x'  exposure_crisis yeard*, group(location) ro cluster(fao_region)
distinct iso3 if e(sample)
tab year if e(sample)
eststo: xtreg  conflict_`x'  exposure_crisis yeard*, fe ro cluster(fao_region)
distinct iso3 if e(sample)
tab year if e(sample)
*
}
log using Table5.log, replace
set linesize 250
esttab, mtitles keep(exposure_crisis) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(exposure_crisis) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close
*
**************************************
* PANEL B: interaction with distance *
**************************************
*
foreach x in c3 c1 c2{
use "$Output_data\data_BC_Restat2014", clear
*
label var exposure_crisis "Exposure to crises "
label var crisis_ldist    "Exp. to crises  $\times$ remoteness$^1$"
*
gen location = group_gid
drop if conflict_`x' == .
*
eststo: clogit conflict_`x'  exposure_crisis crisis_ldist yeard*, group(location) cluster(fao_region)  ro
eststo: xtreg  conflict_`x'  exposure_crisis crisis_ldist yeard*, fe ro cluster(fao_region)
}
log using Table5.log, append
set linesize 250
esttab, mtitles keep(exposure_crisis crisis_ldist) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(exposure_crisis crisis_ldist) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close
*
********************************************
* PANEL C: interaction with distance ratio *
********************************************
*
foreach x in c3 c1 c2{
use "$Output_data\data_BC_Restat2014", clear
*
label var exposure_crisis "Exposure to crises "
label var crisis_ldist_r  "Exp. to crises  $\times$ remoteness$^2$"
*
gen location = group_gid
drop if conflict_`x' == .
*
eststo: clogit conflict_`x'  exposure_crisis crisis_ldist_r yeard*, group(location) cluster(fao_region)  ro
eststo: xtreg  conflict_`x'  exposure_crisis crisis_ldist_r yeard*, fe ro cluster(fao_region)
}
log using Table5.log, append
set linesize 250
esttab, mtitles keep(exposure_crisis crisis_ldist_r ) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(exposure_crisis crisis_ldist_r ) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close
