*-----------------------------------------------------------------------------------------------------------------------------*
* This do-file constructs Table 12 of the appendix of Berman and Couttenier (2014)											  *
* This version: january 29, 2014																							  *
*-----------------------------------------------------------------------------------------------------------------------------*
*
clear all
cd "$Results"
*
						*--------------------------------------------*
						*--------------------------------------------*
						* TABLE 12 - SHOCK GAEZ: BASELINE RESULTS    *    
						*--------------------------------------------*
						*--------------------------------------------*
*
***********************
* PANEL A: shock only *
***********************
*
foreach x in  c3 c1 c2{
use "$Output_data\data_BC_Restat2014", clear
tsset
*
label var lshock_gaez40      "ln agr. shock, GAEZ"
label var lshock_gaez40_dist "ln agr. shock  $\times$ remoteness$^1$"
*
gen location = group_gid
drop if conflict_`x' == .
/* incidence */
eststo: clogit conflict_`x'  lshock_gaez40 yeard*, group(location) ro cluster(fao_region)
distinct iso3 if e(sample)
eststo: xtreg  conflict_`x'  lshock_gaez40 yeard*, fe ro cluster(fao_region)
distinct iso3 if e(sample)
*
}
log using Table12.log, replace
set linesize 250
esttab, mtitles keep(lshock_gaez40) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(lshock_gaez40) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close
*
**************************************
* PANEL B: interaction with distance *
**************************************
*
foreach x in  c3 c1 c2{
use "$Output_data\data_BC_Restat2014", clear
tsset
*
label var lshock_gaez40      "ln agr. shock, GAEZ"
label var lshock_gaez40_dist "ln agr. shock  $\times$ remoteness$^1$"
*
gen location = group_gid
drop if conflict_`x' == .
/* incidence */
eststo: clogit conflict_`x'  lshock_gaez40  lshock_gaez40_dist yeard* , group(location) cluster(fao_region)  ro
eststo: xtreg  conflict_`x'  lshock_gaez40  lshock_gaez40_dist yeard* , fe ro cluster(fao_region)
*
}
log using Table12.log, append
set linesize 250
esttab, mtitles keep(lshock_gaez40  lshock_gaez40_dist) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(lshock_gaez40  lshock_gaez40_dist) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close
*
********************************************
* PANEL C: interaction with distance ratio *
********************************************
*
foreach x in  c3 c1 c2{
use "$Output_data\data_BC_Restat2014", clear
tsset
*
label var lshock_gaez40        "ln agr. shock, GAEZ"
label var lshock_gaez40_dist_r "ln agr. shock  $\times$ remoteness$^2$"
*
gen location = group_gid
drop if conflict_`x' == .
/* incidence */
eststo: clogit conflict_`x'  lshock_gaez40  lshock_gaez40_dist_r yeard* , group(location) cluster(fao_region)  ro
eststo: xtreg  conflict_`x'  lshock_gaez40  lshock_gaez40_dist_r yeard* , fe ro cluster(fao_region)
*
}
log using Table12.log, append
set linesize 250
esttab, mtitles keep(lshock_gaez40  lshock_gaez40_dist_r) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(lshock_gaez40  lshock_gaez40_dist_r) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close
