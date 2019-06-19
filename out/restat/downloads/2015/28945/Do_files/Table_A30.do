*-----------------------------------------------------------------------------------------------------------------------------*
* This do file constructs Table A30 of the web appendix of Berman and Couttenier (2014)										  *
* This version: january 29, 2014																							  *
*-----------------------------------------------------------------------------------------------------------------------------*
*
clear all
cd "$Results"
*
					*--------------------------------------------*
					*--------------------------------------------*
					*     TABLE A30 - DEEP WATER SEAPORTS        *
					*--------------------------------------------*
					*--------------------------------------------*
*
**********************
* PANEL A: SHOCK FAO *
**********************
*			
use "$Output_data\data_BC_Restat2014", clear
*
label var lshock_fao           "ln agr. shock"
label var lshock_crop          "ln agr. shock, M3-crop"
label var exposure_crisis      "Exposure to crises "
label var lshock_fao_dist12    "ln agr. shock  $\times$ remoteness$^1$"
label var lshock_crop_dist12   "ln agr. shock  $\times$ remoteness$^1$"
label var crisis_ldist12       "Exp. to crises $\times$ remoteness$^1$"
*
gen location = group_gid
*
/* LPM */
eststo: clogit conflict_c3  lshock_fao  lshock_fao_dist12  yeard*, group(group_gid) ro cluster(fao_region)
eststo: xtreg  conflict_c3  lshock_fao  lshock_fao_dist12  yeard*, fe ro cluster(fao_region)
*
eststo: clogit conflict_c1  lshock_fao  lshock_fao_dist12  yeard*, group(group_gid) ro cluster(fao_region)
eststo: xtreg  conflict_c1  lshock_fao  lshock_fao_dist12  yeard*, fe ro cluster(fao_region)

eststo: xtreg  conflict_c2  lshock_fao  lshock_fao_dist12  yeard*, fe ro cluster(fao_region)
eststo: clogit conflict_c2  lshock_fao  lshock_fao_dist12  yeard*, group(group_gid) ro cluster(fao_region)
*
log using Table_A30.log, replace
set linesize 250
esttab, mtitles drop(yeard*  _cons) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles drop(yeard*  _cons) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title()  
eststo clear
log close
*
*******************
* PANEL B: CRISES *
*******************
*			
eststo: clogit conflict_c3  exposure_crisis crisis_ldist12 yeard*, group(group_gid) ro cluster(fao_region)
eststo: xtreg  conflict_c3  exposure_crisis crisis_ldist12 yeard*, fe ro cluster(fao_region)
*
eststo: xtreg  conflict_c1  exposure_crisis crisis_ldist12 yeard*, fe ro cluster(fao_region)
eststo: xtreg  conflict_c2  exposure_crisis crisis_ldist12 yeard*, fe ro cluster(fao_region)
*
eststo: clogit conflict_c1  exposure_crisis crisis_ldist12 yeard*, group(group_gid) ro cluster(fao_region)
eststo: clogit conflict_c2  exposure_crisis crisis_ldist12 yeard*, group(group_gid) ro cluster(fao_region)
*
log using Table_A30.log, append
set linesize 250
esttab, mtitles drop(yeard*) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles drop(yeard*) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close
*			
