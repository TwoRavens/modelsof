*-----------------------------------------------------------------------------------------------------------------------------*
* This do file constructs Table A28 of the web appendix of Berman and Couttenier (2014)										  *
* This version: january 29, 2014																							  *
*-----------------------------------------------------------------------------------------------------------------------------*
*
clear all
cd "$Results"
						*--------------------------------------------*
						*--------------------------------------------*
						*   TABLE A28 - COUNTRY SPECIFIC TRENDS      *
						*--------------------------------------------*
						*--------------------------------------------*
*
******************************************
* PANEL A: country trends, with distance *
******************************************
*			
use "$Output_data\data_BC_Restat2014", clear
*
/* country trends */
g trend=year-1980
forvalues x=1(1)53{
gen trend_iso3d`x'   = trend*iso3d`x'
label var trend_iso3d`x' "Trend specific to country `x'"
}
*
label var lshock_fao         "ln agr. shock"
label var lshock_crop        "ln agr. shock, M3-crop"
label var exposure_crisis    "Exposure to crises "
label var lshock_fao_dist    "ln agr. shock  $\times$ remoteness$^1$"
label var lshock_crop_dist   "ln agr. shock  $\times$ remoteness$^1$"
label var crisis_ldist       "Exp. to crises $\times$ remoteness$^1$"
label var lshock_fao_dist_r  "ln agr. shock  $\times$ remoteness$^2$"
label var lshock_crop_dist_r "ln agr. shock  $\times$ remoteness$^2$"
label var crisis_ldist_r     "Exp. to crises $\times$ remoteness$^2$"
*
gen location = group_gid
*
/* FAO */
eststo: xtreg  conflict_c3  lshock_fao  lshock_fao_dist  yeard* trend_iso3d*, fe ro cluster(fao_region)
eststo: xtreg  conflict_c1  lshock_fao  lshock_fao_dist  yeard* trend_iso3d*, fe ro cluster(fao_region)
eststo: xtreg  conflict_c2  lshock_fao  lshock_fao_dist  yeard* trend_iso3d*, fe ro cluster(fao_region)
/* Crises */
eststo: xtreg  conflict_c3  exposure_crisis crisis_ldist yeard* trend_iso3d*, fe ro cluster(fao_region)
eststo: xtreg  conflict_c1  exposure_crisis crisis_ldist yeard* trend_iso3d*, fe ro cluster(fao_region)
eststo: xtreg  conflict_c2  exposure_crisis crisis_ldist yeard* trend_iso3d*, fe ro cluster(fao_region)
*
log using Table_A28.log, replace
set linesize 250
esttab, mtitles b(%5.3f) keep(lshock_fao  lshock_fao_dist  exposure_crisis crisis_ldist) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles b(%5.3f) keep(lshock_fao  lshock_fao_dist  exposure_crisis crisis_ldist) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close	
*
************************************************
* PANEL B: country trends, with distance ratio *
************************************************
*			
use "$Output_data\data_BC_Restat2014", clear
*
/* country trends */
g trend=year-1980
forvalues x=1(1)53{
gen trend_iso3d`x'   = trend*iso3d`x'
label var trend_iso3d`x' "Trend specific to country `x'"
}
label var lshock_fao         "ln agr. shock"
label var lshock_crop        "ln agr. shock, M3-crop"
label var exposure_crisis    "Exposure to crises "
label var lshock_fao_dist    "ln agr. shock  $\times$ remoteness$^1$"
label var lshock_crop_dist   "ln agr. shock  $\times$ remoteness$^1$"
label var crisis_ldist       "Exp. to crises $\times$ remoteness$^1$"
label var lshock_fao_dist_r  "ln agr. shock  $\times$ remoteness$^2$"
label var lshock_crop_dist_r "ln agr. shock  $\times$ remoteness$^2$"
label var crisis_ldist_r     "Exp. to crises $\times$ remoteness$^2$"
*
gen location = group_gid
*
/* FAO */
eststo: xtreg  conflict_c1  lshock_fao  lshock_fao_dist_r  yeard* trend_iso3d*, fe ro cluster(fao_region)
eststo: xtreg  conflict_c2  lshock_fao  lshock_fao_dist_r  yeard* trend_iso3d*, fe ro cluster(fao_region)
eststo: xtreg  conflict_c3  lshock_fao  lshock_fao_dist_r  yeard* trend_iso3d*, fe ro cluster(fao_region)
/* Crises */
eststo: xtreg  conflict_c3  exposure_crisis crisis_ldist_r yeard* trend_iso3d*, fe ro cluster(fao_region)
eststo: xtreg  conflict_c1  exposure_crisis crisis_ldist_r yeard* trend_iso3d*, fe ro cluster(fao_region)
eststo: xtreg  conflict_c2  exposure_crisis crisis_ldist_r yeard* trend_iso3d*, fe ro cluster(fao_region)
*
log using Table_A28.log, append
set linesize 250
esttab, mtitles b(%5.3f) keep(lshock_fao  lshock_fao_dist_r exposure_crisis crisis_ldist_r) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles b(%5.3f) keep(lshock_fao  lshock_fao_dist_r exposure_crisis crisis_ldist_r) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close	
*
