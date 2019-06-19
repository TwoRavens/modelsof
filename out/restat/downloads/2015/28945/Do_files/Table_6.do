*-----------------------------------------------------------------------------------------------------------------------------*
* This do file constructs Table 6 of Berman and Couttenier (2014)											  				  *
* This version: september 18, 2014																							  *
*-----------------------------------------------------------------------------------------------------------------------------*
*
clear all 
cd "$Results"
*
			*------------------------------------------------------------*
			*------------------------------------------------------------*
			*   	TABLE 6 - ONSET / INTENSITY / ENDING 	             *
			*------------------------------------------------------------*
			*------------------------------------------------------------*
*
**********************
* PANEL A: shock only *
**********************
*
foreach x in  c3 {
use "$Output_data\data_BC_Restat2014", clear
*
label var exposure_crisis 	"Exposure to crises "
label var crisis_ldist  	"Exp. to crises  $\times$ remoteness$^1$"
*
gen location = group_gid
drop if conflict_`x' == .
* onset * 
eststo: clogit onset_`x'     lshock_fao 		yeard*, group(location) ro cluster(fao_region)
eststo: xtreg  onset_`x'     lshock_fao      	yeard*, fe ro cluster(fao_region)
eststo: clogit onset_`x'     exposure_crisis  	yeard*, group(location) ro cluster(fao_region)
eststo: xtreg  onset_`x'     exposure_crisis 	yeard*, fe ro cluster(fao_region)
* ending *
eststo: clogit ending_`x'    lshock_fao 		yeard*, group(location) ro cluster(fao_region)
eststo: xtreg  ending_`x'    lshock_fao      	yeard*, fe ro cluster(fao_region)
eststo: clogit ending_`x'    exposure_crisis  	yeard*, group(location) ro cluster(fao_region)
eststo: xtreg  ending_`x'    exposure_crisis 	yeard*, fe ro cluster(fao_region)
*
}
log using Table6.log, replace
set linesize 250
esttab, mtitles keep(lshock_fao exposure_crisis) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(lshock_fao exposure_crisis) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close
*
**************************************
* PANEL B: interaction with distance *
**************************************
*			
foreach x in  c3 {
use "$Output_data\data_BC_Restat2014", clear
tsset
*
label var lshock_fao      "ln agr. shock"
label var lshock_fao_dist "ln agr. shock  $\times$ remoteness$^1$"
*
gen location = group_gid
drop if conflict_`x' == .
* onset * 
eststo: clogit onset_`x'     lshock_fao lshock_fao_dist 	yeard*, group(location) ro cluster(fao_region)
eststo: xtreg  onset_`x'     lshock_fao lshock_fao_dist 	yeard*, fe ro cluster(fao_region)
eststo: clogit onset_`x'     exposure_crisis crisis_ldist 	yeard*, group(location) ro cluster(fao_region)
eststo: xtreg  onset_`x'     exposure_crisis crisis_ldist 	yeard*, fe ro cluster(fao_region)
* ending *
eststo: clogit ending_`x'    lshock_fao lshock_fao_dist 	yeard*, group(location) ro cluster(fao_region)
eststo: xtreg  ending_`x'    lshock_fao lshock_fao_dist   	yeard*, fe ro cluster(fao_region)
eststo: clogit ending_`x'    exposure_crisis  crisis_ldist 	yeard*, group(location) ro cluster(fao_region)
eststo: xtreg  ending_`x'    exposure_crisis crisis_ldist   yeard*, fe ro cluster(fao_region)
*
}
log using Table6.log, append
set linesize 250
esttab, mtitles keep(lshock_fao exposure_crisis lshock_fao_dist crisis_ldist) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(lshock_fao exposure_crisis lshock_fao_dist crisis_ldist) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close
