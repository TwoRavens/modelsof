*-----------------------------------------------------------------------------------------------------------------------------*
* This do file constructs Table A29 of the web appendix of Berman and Couttenier (2014)										  *
* This version: january 29, 2014																							  *
*-----------------------------------------------------------------------------------------------------------------------------*
*
clear all
cd "$Results"
*
					*--------------------------------------------*
					*--------------------------------------------*
					*   TABLE A29 - COUNTRY YEAR FIXED EFFECTS   *
					*--------------------------------------------*
					*--------------------------------------------*
*
*******************************************
* PANEL A: country-year FE, with distance *
*******************************************
*			
use "$Output_data\data_BC_Restat2014", clear
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
/* FAO */
eststo: reg2hdfe  conflict_c3  lshock_fao  lshock_fao_dist  , id1(gid) id2(country_year) cluster(fao_region)
eststo: reg2hdfe  conflict_c2  lshock_fao  lshock_fao_dist  , id1(gid) id2(country_year) cluster(fao_region)
eststo: reg2hdfe  conflict_c1  lshock_fao  lshock_fao_dist  , id1(gid) id2(country_year) cluster(fao_region)
/* crises */
eststo: reg2hdfe  conflict_c3  crisis_ldist                 , id1(gid) id2(country_year) cluster(fao_region)
eststo: reg2hdfe  conflict_c1  crisis_ldist					, id1(gid) id2(country_year) cluster(fao_region)
eststo: reg2hdfe  conflict_c2  crisis_ldist 				, id1(gid) id2(country_year) cluster(fao_region)
*
log using Table_A29.log, replace
set linesize 250
esttab, mtitles b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close
*
************************************************
* PANEL B: country-year FE, with distance ratio*
************************************************
*			
use "$Output_data\data_BC_Restat2014", clear
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
/* FAO */
eststo: reg2hdfe  conflict_c3  lshock_fao  lshock_fao_dist_r  , id1(gid) id2(country_year) cluster(fao_region)
eststo: reg2hdfe  conflict_c1  lshock_fao  lshock_fao_dist_r  , id1(gid) id2(country_year) cluster(fao_region)
eststo: reg2hdfe  conflict_c2  lshock_fao  lshock_fao_dist_r  , id1(gid) id2(country_year) cluster(fao_region)
/* Crises */
eststo: reg2hdfe  conflict_c3  crisis_ldist_r                 , id1(gid) id2(country_year) cluster(fao_region)
eststo: reg2hdfe  conflict_c1  crisis_ldist_r				  , id1(gid) id2(country_year) cluster(fao_region)
eststo: reg2hdfe  conflict_c2  crisis_ldist_r 				  , id1(gid) id2(country_year) cluster(fao_region)
*
log using Table_A29.log, append
set linesize 250
esttab, mtitles b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close
*
