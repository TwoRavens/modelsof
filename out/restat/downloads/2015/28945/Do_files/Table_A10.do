*-----------------------------------------------------------------------------------------------------------------------------*
* This do file constructs Table A.10 of the web appendix of Berman and Couttenier (2014)										  *
* This version: january 29, 2014																							  *
*-----------------------------------------------------------------------------------------------------------------------------*
*
clear all
cd "$Results"
						*--------------------------------------------------*
						*--------------------------------------------------*
						*    TABLE A10 - SHOCK FAO: CONFLICT PRONE CELLS   *    
						*--------------------------------------------------*
						*--------------------------------------------------*
*
***********************
* PANEL A: shock only *
***********************
*
foreach x in  c3 c1 c2{
use "$Output_data\data_BC_Restat2014", clear
tsset
*
label var lshock_fao      "ln agr. shock"
label var lshock_fao_dist "ln agr. shock  $\times$ remoteness$^1$"
*
gen location = group_gid
drop if conflict_`x' == .
/* incidence */
eststo: clogit conflict_`x'  lshock_fao yeard*, group(location) ro cluster(fao_region)
distinct iso3 if e(sample)
eststo: xtreg  conflict_`x'  lshock_fao yeard* if e(sample), fe ro cluster(fao_region)
distinct iso3 if e(sample)
*
}
log using Table_A10.log, replace
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
foreach x in  c3 c1 c2{
use "$Output_data\data_BC_Restat2014", clear
tsset
*
label var lshock_fao      "ln agr. shock"
label var lshock_fao_dist "ln agr. shock  $\times$ remoteness$^1$"
*
gen location = group_gid
drop if conflict_`x' == .
/* incidence */
eststo: clogit conflict_`x'  lshock_fao lshock_fao_dist yeard* , group(location) cluster(fao_region)  ro
eststo: xtreg  conflict_`x'  lshock_fao lshock_fao_dist yeard* if e(sample), fe ro cluster(fao_region)
*
}
log using Table_A10.log, append
set linesize 250
esttab, mtitles keep(lshock_fao lshock_fao_dist) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(lshock_fao lshock_fao_dist) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
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
label var lshock_fao        "ln agr. shock"
label var lshock_fao_dist_r "ln agr. shock  $\times$ remoteness$^2$"
*
gen location = group_gid
drop if conflict_`x' == .
/* incidence */
eststo: clogit conflict_`x'  lshock_fao lshock_fao_dist_r yeard* , group(location) cluster(fao_region)  ro
tab year if e(sample)
eststo: xtreg  conflict_`x'  lshock_fao lshock_fao_dist_r yeard* if e(sample), fe ro cluster(fao_region)
tab year if e(sample)
*
}
log using Table_A10.log, append
set linesize 250
esttab, mtitles keep(lshock_fao lshock_fao_dist_r) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(lshock_fao lshock_fao_dist_r) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close				
