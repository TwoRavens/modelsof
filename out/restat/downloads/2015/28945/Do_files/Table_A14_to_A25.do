*-----------------------------------------------------------------------------------------------------------------------------*
* This do file constructs Tables A14 to A25 of the web appendix of Berman and Couttenier (2014)								  *
* This version: january 29, 2014																							  *
*-----------------------------------------------------------------------------------------------------------------------------*
*
clear all
*
						*--------------------------------------------*
						*--------------------------------------------*
						*       TABLE A14 - SHOCK FAO: ONSET          *
						*--------------------------------------------*
						*--------------------------------------------*
cd "$Results"
*
***********************
* PANEL A: shock only *
***********************
*
foreach x in c3 c1 c2{
use "$Output_data\data_BC_Restat2014", clear
tsset
*
label var lshock_fao      "ln agr. shock"
label var lshock_fao_dist "ln agr. shock  $\times$ remoteness$^1$"
*
gen location = group_gid
drop if conflict_`x' == .
/* onset */
eststo: clogit onset_`x'  lshock_fao yeard*, group(location) ro cluster(fao_region)
eststo: xtreg  onset_`x'  lshock_fao yeard*, fe ro cluster(fao_region)
*
}
log using Table_A14.log, replace
set linesize 250
esttab, mtitles keep(lshock_fao) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(lshock_fao) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close
*
**************************************
* PANEL B: interaction with distance *
**************************************
*
foreach x in c3 c1 c2{
use "$Output_data\data_BC_Restat2014", clear
tsset
*
label var lshock_fao      "ln agr. shock"
label var lshock_fao_dist "ln agr. shock  $\times$ remoteness$^1$"
*
gen location = group_gid
drop if conflict_`x' == .
/* incidence */
eststo: clogit onset_`x'  lshock_fao lshock_fao_dist yeard* , group(location) cluster(fao_region)  ro
eststo: xtreg  onset_`x'  lshock_fao lshock_fao_dist yeard* , fe ro cluster(fao_region)
*
}
log using Table_A14.log, append
set linesize 250
esttab, mtitles keep(lshock_fao lshock_fao_dist) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(lshock_fao lshock_fao_dist) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close
*
				*--------------------------------------------*
				*--------------------------------------------*
				*      TABLE A15 - SHOCK FAO: ENDING         *
				*--------------------------------------------*
				*--------------------------------------------*

cd "$Results"
*
***********************
* PANEL A: shock only *
***********************
*
foreach x in c3 c1 c2{
use "$Output_data\data_BC_Restat2014", clear
tsset
*
label var lshock_fao      "ln agr. shock"
label var lshock_fao_dist "ln agr. shock  $\times$ remoteness$^1$"
*
gen location = group_gid
drop if conflict_`x' == .
/* onset */
eststo: clogit ending_`x'  lshock_fao yeard*, group(location) ro cluster(fao_region)
eststo: xtreg  ending_`x'  lshock_fao yeard*, fe ro cluster(fao_region)
*
}
log using Table_A15.log, replace
set linesize 250
esttab, mtitles keep(lshock_fao) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(lshock_fao) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close
*
**************************************
* PANEL B: interaction with distance *
**************************************
*
foreach x in c3 c1 c2{
use "$Output_data\data_BC_Restat2014", clear
tsset
*
label var lshock_fao      "ln agr. shock"
label var lshock_fao_dist "ln agr. shock  $\times$ remoteness$^1$"
*
gen location = group_gid
drop if conflict_`x' == .
/* incidence */
eststo: clogit ending_`x'  lshock_fao lshock_fao_dist yeard* , group(location) cluster(fao_region)  ro
eststo: xtreg  ending_`x'  lshock_fao lshock_fao_dist yeard* , fe ro cluster(fao_region)
*
}
log using Table_A15.log, append
set linesize 250
esttab, mtitles keep(lshock_fao lshock_fao_dist ) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(lshock_fao lshock_fao_dist ) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close
*
					*--------------------------------------------*
					*--------------------------------------------*
					*     TABLE A16 - SHOCK FAO: INTENS      	 *
					*--------------------------------------------*
					*--------------------------------------------*
				
cd "$Results"
*
***********************
* PANEL A: shock only *
***********************
*
foreach x in c3 c1 c2{
use "$Output_data\data_BC_Restat2014", clear
tsset
*
label var lshock_fao      "ln agr. shock"
label var lshock_fao_dist "ln agr. shock  $\times$ remoteness$^1$"
*
gen location = group_gid
drop if conflict_`x' == .
/* onset */
eststo: xtpqml nbconflict_`x'  lshock_fao yeard*, i(group_gid) cluster(gid) 
eststo: xtreg  nbconflict_`x'  lshock_fao yeard*, fe ro cluster(fao_region)
*
}
log using Table_A16.log, replace
set linesize 250
esttab, mtitles keep(lshock_fao) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(lshock_fao) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close
*
**************************************
* PANEL B: interaction with distance *
**************************************
*
foreach x in c3 c1 c2{
use "$Output_data\data_BC_Restat2014", clear
tsset
*
label var lshock_fao      "ln agr. shock"
label var lshock_fao_dist "ln agr. shock  $\times$ remoteness$^1$"
*
gen location = group_gid
drop if conflict_`x' == .
/* incidence */
eststo: xtpqml nbconflict_`x'  lshock_fao lshock_fao_dist yeard* , fe cluster(gid)
eststo: xtreg  nbconflict_`x'  lshock_fao lshock_fao_dist yeard* , fe ro cluster(fao_region)
*
}
log using Table_A16.log, append
set linesize 250
esttab, mtitles keep(lshock_fao lshock_fao_dist) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(lshock_fao lshock_fao_dist) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close

					*--------------------------------------------*
					*--------------------------------------------*
					*    TABLE A17 - SHOCK CRISIS: ONSET 	     *
					*--------------------------------------------*
					*--------------------------------------------*

cd "$Results"
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
/* incidence */
eststo: clogit onset_`x'  exposure_crisis yeard*, group(location) ro cluster(fao_region)
eststo: xtreg  onset_`x'  exposure_crisis yeard*, fe ro cluster(fao_region)
*
}
log using Table_A17.log, replace
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
/* incidence */
eststo: clogit onset_`x'  exposure_crisis crisis_ldist yeard*, group(location) cluster(fao_region)  ro
eststo: xtreg  onset_`x'  exposure_crisis crisis_ldist yeard*, fe ro cluster(fao_region)
}
log using Table_A17.log, append
set linesize 250
esttab, mtitles keep(exposure_crisis crisis_ldist) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(exposure_crisis crisis_ldist) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close
*

						*--------------------------------------------*
						*--------------------------------------------*
						*   TABLE A18 - SHOCK CRISIS: ENDING RESULTS *
						*--------------------------------------------*
						*--------------------------------------------*
cd "$Results"
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
/* incidence */
eststo: clogit ending_`x'  exposure_crisis yeard*, group(location) ro cluster(fao_region)
eststo: xtreg  ending_`x'  exposure_crisis yeard*, fe ro cluster(fao_region)
*
}
log using Table_A18.log, replace
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
/* incidence */
eststo: clogit ending_`x'  exposure_crisis crisis_ldist yeard*, group(location) cluster(fao_region)  ro
eststo: xtreg  ending_`x'  exposure_crisis crisis_ldist yeard*, fe ro cluster(fao_region)
}
log using Table_A18.log, append
set linesize 250
esttab, mtitles keep(exposure_crisis crisis_ldist) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(exposure_crisis crisis_ldist) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close
*
						*--------------------------------------------*
						*--------------------------------------------*
						* TABLE A19 - SHOCK CRISIS: INTENSITY 		 *     
						*--------------------------------------------*
						*--------------------------------------------*
cd "$Results"
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
/* incidence */
eststo: xtpqml nbconflict_`x'  exposure_crisis yeard*, fe cluster(group_gid)
eststo: xtreg  nbconflict_`x'  exposure_crisis yeard*, fe ro cluster(fao_region)
*
}
log using Table_A19.log, replace
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
/* incidence */
eststo: xtpqml nbconflict_`x'  exposure_crisis crisis_ldist yeard*, fe cluster(group_gid)
eststo: xtreg  nbconflict_`x'  exposure_crisis crisis_ldist yeard*, fe ro cluster(fao_region)
}
log using Table_A19.log, append
set linesize 250
esttab, mtitles keep(exposure_crisis crisis_ldist) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(exposure_crisis crisis_ldist) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close
*
						*--------------------------------------------*
						*--------------------------------------------*
						*       TABLE A20 - SHOCK CROP: ONSET        *
						*--------------------------------------------*
						*--------------------------------------------*
cd "$Results"
*
***********************
* PANEL A: shock only *
***********************
*
foreach x in c3 c1 c2{
use "$Output_data\data_BC_Restat2014", clear
tsset
*
label var lshock_crop      "ln agr. shock, M3-crop"
label var lshock_crop_dist "ln agr. shock  $\times$ remoteness$^1$"
*
gen location = group_gid
drop if conflict_`x' == .
/* onset */
eststo: clogit onset_`x'  lshock_crop yeard*, group(location) ro cluster(fao_region)
eststo: xtreg  onset_`x'  lshock_crop yeard*, fe ro cluster(fao_region)
*
}
log using Table_A20.log, replace
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
foreach x in c3 c1 c2{
use "$Output_data\data_BC_Restat2014", clear
tsset
*
label var lshock_crop      "ln agr. shock, M3-crop"
label var lshock_crop_dist "ln agr. shock  $\times$ remoteness$^1$"
*
gen location = group_gid
drop if conflict_`x' == .
/* incidence */
eststo: clogit onset_`x'  lshock_crop lshock_crop_dist yeard* , group(location) cluster(fao_region)  ro
eststo: xtreg  onset_`x'  lshock_crop lshock_crop_dist yeard* , fe ro cluster(fao_region)
*
}
log using Table_A20.log, append
set linesize 250
esttab, mtitles keep(lshock_crop lshock_crop_dist) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(lshock_crop lshock_crop_dist) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close
*
						*--------------------------------------------*
						*--------------------------------------------*
						*      TABLE A21 - SHOCK CROP: ENDING        *
						*--------------------------------------------*
						*--------------------------------------------*
cd "$Results"
*
***********************
* PANEL A: shock only *
***********************
*
foreach x in c3 c1 c2{
use "$Output_data\data_BC_Restat2014", clear
tsset
*
label var lshock_crop      "ln agr. shock, M3-crop"
label var lshock_crop_dist "ln agr. shock  $\times$ remoteness$^1$"
*
gen location = group_gid
drop if conflict_`x' == .
/* onset */
eststo: clogit ending_`x'  lshock_crop yeard*, group(location) ro cluster(fao_region)
eststo: xtreg  ending_`x'  lshock_crop yeard*, fe ro cluster(fao_region)
*
}
log using Table_A21.log, replace
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
foreach x in c3 c1 c2{
use "$Output_data\data_BC_Restat2014", clear
tsset
*
label var lshock_crop      "ln agr. shock, M3-crop"
label var lshock_crop_dist "ln agr. shock  $\times$ remoteness$^1$"
*
gen location = group_gid
drop if conflict_`x' == .
/* incidence */
eststo: clogit ending_`x'  lshock_crop lshock_crop_dist yeard* , group(location) cluster(fao_region)  ro
eststo: xtreg  ending_`x'  lshock_crop lshock_crop_dist yeard* , fe ro cluster(fao_region)
*
}
log using Table_A21.log, append
set linesize 250
esttab, mtitles keep(lshock_crop lshock_crop_dist) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(lshock_crop lshock_crop_dist) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close
*
						*--------------------------------------------*
						*--------------------------------------------*
						*     TABLE A22 - SHOCK CROP: INTENS         *
						*--------------------------------------------*
						*--------------------------------------------*

cd "$Results"
*
***********************
* PANEL A: shock only *
***********************
*
foreach x in c3 c1 c2{
use "$Output_data\data_BC_Restat2014", clear
tsset
*
label var lshock_crop      "ln agr. shock, M3-crop"
label var lshock_crop_dist "ln agr. shock  $\times$ remoteness$^1$"
*
gen location = group_gid
drop if conflict_`x' == .
/* onset */
eststo: xtpqml nbconflict_`x'  lshock_crop yeard*, i(group_gid) cluster(gid) 
eststo: xtreg  nbconflict_`x'  lshock_crop yeard*, fe ro cluster(fao_region)
*
}
log using Table_A22.log, replace
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
foreach x in c3 c1 c2{
use "$Output_data\data_BC_Restat2014", clear
tsset
*
label var lshock_crop      "ln agr. shock, M3-crop"
label var lshock_crop_dist "ln agr. shock  $\times$ remoteness$^1$"
*
gen location = group_gid
drop if conflict_`x' == .
/* incidence */
eststo: xtpqml nbconflict_`x'  lshock_crop lshock_crop_dist yeard* , fe cluster(gid)
eststo: xtreg  nbconflict_`x'  lshock_crop lshock_crop_dist yeard* , fe ro cluster(fao_region)
*
}
log using Table_A22.log, append
set linesize 250
esttab, mtitles keep(lshock_crop lshock_crop_dist) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(lshock_crop lshock_crop_dist) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close
						*--------------------------------------------*
						*--------------------------------------------*
						*       TABLE A23 - SHOCK GAEZ: ONSET        *
						*--------------------------------------------*
						*--------------------------------------------*

cd "$Results"
*
***********************
* PANEL A: shock only *
***********************
*
foreach x in c3 c1 c2{
use "$Output_data\data_BC_Restat2014", clear
tsset
*
label var lshock_gaez40      "ln agr. shock, GAEZ"
label var lshock_gaez40_dist "ln agr. shock  $\times$ remoteness$^1$"
*
gen location = group_gid
drop if conflict_`x' == .
/* onset */
eststo: clogit onset_`x'  lshock_gaez40 yeard*, group(location) ro cluster(fao_region)
eststo: xtreg  onset_`x'  lshock_gaez40 yeard*, fe ro cluster(fao_region)
*
}
log using Table_A23.log, replace
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
foreach x in c3 c1 c2{
use "$Output_data\data_BC_Restat2014", clear
tsset
*
label var lshock_gaez40      "ln agr. shock, GAEZ"
label var lshock_gaez40_dist "ln agr. shock  $\times$ remoteness$^1$"
*
gen location = group_gid
drop if conflict_`x' == .
/* incidence */
eststo: clogit onset_`x'  lshock_gaez40 lshock_gaez40_dist yeard* , group(location) cluster(fao_region)  ro
eststo: xtreg  onset_`x'  lshock_gaez40 lshock_gaez40_dist yeard* , fe ro cluster(fao_region)
*
}
log using Table_A23.log, append
set linesize 250
esttab, mtitles keep(lshock_gaez40 lshock_gaez40_dist) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(lshock_gaez40 lshock_gaez40_dist) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close
*
				*--------------------------------------------*
				*--------------------------------------------*
				*      TABLE A24 - SHOCK GAEZ: ENDING        *
				*--------------------------------------------*
				*--------------------------------------------*

cd "$Results"
*
***********************
* PANEL A: shock only *
***********************
*
foreach x in c3 c1 c2{
use "$Output_data\data_BC_Restat2014", clear
tsset
*
label var lshock_gaez40      "ln agr. shock, GAEZ"
label var lshock_gaez40_dist "ln agr. shock  $\times$ remoteness$^1$"
*
gen location = group_gid
drop if conflict_`x' == .
/* onset */
eststo: clogit ending_`x'  lshock_gaez40 yeard*, group(location) ro cluster(fao_region)
eststo: xtreg  ending_`x'  lshock_gaez40 yeard*, fe ro cluster(fao_region)
*
}
log using Table_A24.log, replace
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
foreach x in c3 c1 c2{
use "$Output_data\data_BC_Restat2014", clear
tsset
*
label var lshock_gaez40      "ln agr. shock, GAEZ"
label var lshock_gaez40_dist "ln agr. shock  $\times$ remoteness$^1$"
*
gen location = group_gid
drop if conflict_`x' == .
/* incidence */
eststo: clogit ending_`x'  lshock_gaez40 lshock_gaez40_dist yeard* , group(location) cluster(fao_region)  ro
eststo: xtreg  ending_`x'  lshock_gaez40 lshock_gaez40_dist yeard* , fe ro cluster(fao_region)
*
}
log using Table_A24.log, append
set linesize 250
esttab, mtitles keep(lshock_gaez40 lshock_gaez40_dist) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(lshock_gaez40 lshock_gaez40_dist) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close
*
				*--------------------------------------------*
				*--------------------------------------------*
				*     TABLE A25 - SHOCK GAEZ: INTENS      	 *
				*--------------------------------------------*
				*--------------------------------------------*

cd "$Results"
*
***********************
* PANEL A: shock only *
***********************
*
foreach x in c3 c1 c2{
use "$Output_data\data_BC_Restat2014", clear
tsset
*
label var lshock_gaez40      "ln agr. shock, GAEZ"
label var lshock_gaez40_dist "ln agr. shock  $\times$ remoteness$^1$"
*
gen location = group_gid
drop if conflict_`x' == .
/* onset */
eststo: xtpqml nbconflict_`x'  lshock_gaez40 yeard*, i(group_gid) cluster(gid) 
eststo: xtreg  nbconflict_`x'  lshock_gaez40 yeard*, fe ro cluster(fao_region)
*
}
log using Table_A25.log, replace
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
foreach x in c3 c1 c2{
use "$Output_data\data_BC_Restat2014", clear
tsset
*
label var lshock_gaez40      "ln agr. shock, GAEZ"
label var lshock_gaez40_dist "ln agr. shock  $\times$ remoteness$^1$"
*
gen location = group_gid
drop if conflict_`x' == .
/* incidence */
eststo: xtpqml nbconflict_`x'  lshock_gaez40 lshock_gaez40_dist yeard* , fe cluster(gid)
eststo: xtreg  nbconflict_`x'  lshock_gaez40 lshock_gaez40_dist yeard* , fe ro cluster(fao_region)
*
}
log using Table_A25.log, append
set linesize 250
esttab, mtitles keep(lshock_gaez40 lshock_gaez40_dist) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(lshock_gaez40 lshock_gaez40_dist) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close
