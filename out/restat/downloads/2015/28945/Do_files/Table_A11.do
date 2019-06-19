*-----------------------------------------------------------------------------------------------------------------------------*
* This do file constructs Table A11 of the web appendix of Berman and Couttenier (2014)										  *
* This version: january 29, 2014																							  *
*-----------------------------------------------------------------------------------------------------------------------------*
*
clear all
cd "$Results"
						*--------------------------------------------*
						*--------------------------------------------*
						*    TABLE A.11 - PAST INSTABILITY   		 *    
						*--------------------------------------------*
						*--------------------------------------------*
*
***********************
* PANEL A: FAO Shock  *
***********************
*
foreach x in  c3 c1 c2{
use "$Output_data\data_BC_Restat2014", clear
tsset
*
label var lshock_fao      "ln agr. shock"
label var lshock_fao_dist "ln agr. shock  $\times$ remoteness$^1$"
*
bys gid: gen tmp  = sum(nbconflict_`x')
g past_inst       = tmp-conflict_`x'
g lshock_fao_past = lshock_fao*past_inst
drop tmp
*
gen location = group_gid
drop if conflict_`x' == .
/* incidence */
eststo: clogit conflict_`x'  lshock_fao lshock_fao_dist lshock_fao_past past_inst yeard* , group(location) cluster(fao_region)  ro
eststo: xtreg  conflict_`x'  lshock_fao lshock_fao_dist lshock_fao_past past_inst yeard* , fe ro cluster(fao_region)
*
}
log using Table_A11.log, replace 
set linesize 250
esttab, mtitles keep(lshock_fao lshock_fao_dist lshock_fao_past past_inst) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(lshock_fao lshock_fao_dist lshock_fao_past past_inst) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close
*
****************************
* PANEL C: exposure crises *
****************************
*
foreach x in  c3 c1 c2{
use "$Output_data\data_BC_Restat2014", clear
tsset
*
label var exposure_crisis "Exposure to crises "
label var crisis_ldist  "Exp. to crises  $\times$ remoteness$^1$"
*
bys gid: gen tmp  = sum(nbconflict_`x')
g past_inst       = tmp-conflict_`x'
g crisis_past     = exposure_crisis*past_inst
drop tmp
*
gen location = group_gid
drop if conflict_`x' == .
/* incidence */
eststo: clogit conflict_`x'  exposure_crisis crisis_ldist crisis_past past_inst yeard*, group(location) cluster(fao_region)  ro
eststo: xtreg  conflict_`x'  exposure_crisis crisis_ldist crisis_past past_inst yeard*, fe ro cluster(fao_region)
*
}
log using Table_A11.log, append 
set linesize 250
esttab, mtitles keep(exposure_crisis crisis_ldist crisis_past past_inst) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(exposure_crisis crisis_ldist crisis_past past_inst) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close

