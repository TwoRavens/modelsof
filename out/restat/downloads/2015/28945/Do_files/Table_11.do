*-----------------------------------------------------------------------------------------------------------------------------*
* This do-file constructs Table 11 of the appendix of Berman and Couttenier (2014)											  *
* This version: january 29, 2014																							  *
*-----------------------------------------------------------------------------------------------------------------------------*
*
clear all
cd "$Results"
*						*--------------------------------------------*
						*--------------------------------------------*
						* TABLE 11 - SHOCK CROP: BASELINE RESULTS    *    
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
label var lshock_crop      "ln agr. shock, M3-crop"
label var lshock_crop_dist "ln agr. shock  $\times$ remoteness$^1$"
*
gen location = group_gid
drop if conflict_`x' == .
*
eststo: clogit conflict_`x'  lshock_crop yeard*, group(location) ro cluster(fao_region)
distinct iso3 if e(sample)
eststo: xtreg  conflict_`x'  lshock_crop yeard*, fe ro cluster(fao_region)
distinct iso3 if e(sample)
*
}
log using Table11.log, replace
set linesize 250
esttab, mtitles keep(lshock_crop) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(lshock_crop) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
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
label var lshock_crop      "ln agr. shock, M3-crop"
label var lshock_crop_dist "ln agr. shock  $\times$ remoteness$^1$"
*
gen location = group_gid
drop if conflict_`x' == .
*
eststo: clogit conflict_`x'  lshock_crop lshock_crop_dist yeard* , group(location) cluster(fao_region)  ro
eststo: xtreg  conflict_`x'  lshock_crop lshock_crop_dist yeard* , fe ro cluster(fao_region)
*
}
log using Table11.log, append
set linesize 250
esttab, mtitles keep(lshock_crop lshock_crop_dist) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(lshock_crop lshock_crop_dist) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
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
label var lshock_crop        "ln agr. shock, M3-crop"
label var lshock_crop_dist_r "ln agr. shock  $\times$ remoteness$^2$"
*
gen location = group_gid
drop if conflict_`x' == .
*
eststo: clogit conflict_`x'  lshock_crop lshock_crop_dist_r yeard* , group(location) cluster(fao_region)  ro
eststo: xtreg  conflict_`x'  lshock_crop lshock_crop_dist_r yeard* , fe ro cluster(fao_region)
*
}
log using Table11.log, append
set linesize 250
esttab, mtitles keep(lshock_crop lshock_crop_dist_r) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(lshock_crop lshock_crop_dist_r) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close

