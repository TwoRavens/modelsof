*-----------------------------------------------------------------------------------------------------------------------------*
* This do-file generates Tables 3 and 4 of Berman and Couttenier (2014)														  *
* This version: january 29, 2014    																						  *
*-----------------------------------------------------------------------------------------------------------------------------*
*
clear all
cd "$Results"
*
						*--------------------------------------------*
						*--------------------------------------------*
						*    TABLE 3 - SHOCK FAO: BASELINE RESULTS   *    
						*--------------------------------------------*
						*--------------------------------------------*
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
eststo: clogit conflict_`x'  lshock_fao yeard*, group(location) ro cluster(fao_region)
distinct iso3 if e(sample)
tab year if e(sample)
eststo: xtreg  conflict_`x'  lshock_fao yeard*, fe ro cluster(fao_region)
distinct iso3 if e(sample)
tab year if e(sample)
*
}
log using Table3.log, replace
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
*
eststo: clogit conflict_`x'  lshock_fao lshock_fao_dist yeard* , group(location) cluster(fao_region)  ro
eststo: xtreg  conflict_`x'  lshock_fao lshock_fao_dist yeard* , fe ro cluster(fao_region)
*
}
log using Table3.log, append
set linesize 250
esttab, mtitles keep(lshock_fao lshock_fao_dist ) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(lshock_fao lshock_fao_dist ) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close
*
********************************************
* PANEL C: interaction with distance ratio *
********************************************
*
foreach x in c3 c1 c2{
use "$Output_data\data_BC_Restat2014", clear
tsset
*
label var lshock_fao        "ln agr. shock"
label var lshock_fao_dist_r "ln agr. shock  $\times$ remoteness$^2$"
*
gen location = group_gid
drop if conflict_`x' == .
*
eststo: clogit conflict_`x'  lshock_fao lshock_fao_dist_r yeard* , group(location) cluster(fao_region)  ro
eststo: xtreg  conflict_`x'  lshock_fao lshock_fao_dist_r yeard* , fe ro cluster(fao_region)
*
}
log using Table3.log, append
set linesize 250
esttab, mtitles keep(lshock_fao lshock_fao_dist_r) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(lshock_fao lshock_fao_dist_r) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close				
	
						*--------------------------------------------*
						*--------------------------------------------*
						* TABLE 4  - SHOCK FAO: ROBUSTNESS INTERACT. *    
						*--------------------------------------------*
						*--------------------------------------------*

foreach x in c3 c1 c2{
use "$Output_data\data_BC_Restat2014", clear
g temp0 = pop if year == 1990
bys gid : egen pop90 	= mean(pop)
g lshock_fao_gdp 		= log(ppp90)*lshock_fao
g lshock_fao_pop 		= log(pop90)*lshock_fao
drop pop90 temp0
*
tsset
*
label var lshock_fao      "ln agr. shock"
label var lshock_fao_dist "ln agr. shock  $\times$ remoteness$^1$"
label var lshock_fao_pop  "ln agr. shock  $\times$ ln pop. area"
label var lshock_fao_gdp  "ln agr. shock  $\times$ ln GDP area"
*
gen location = group_gid
drop if conflict_`x' == .
*
eststo: clogit conflict_`x'  lshock_fao lshock_fao_dist lshock_fao_dist_cap lshock_fao_dist_bord lshock_fao_dist_res lshock_fao_gdp lshock_fao_pop ldist_cap ldist_bord yeard*, group(location) ro cluster(fao_region)
distinct iso3 if e(sample)
tab year if e(sample)
eststo: xtreg  conflict_`x'  lshock_fao lshock_fao_dist lshock_fao_dist_cap lshock_fao_dist_bord lshock_fao_dist_res lshock_fao_gdp lshock_fao_pop ldist_cap ldist_bord yeard*, fe ro cluster(fao_region)
distinct iso3 if e(sample)
tab year if e(sample)
*
}
log using Table4.log, replace
set linesize 250
esttab, mtitles keep(lshock_fao lshock_fao_dist lshock_fao_dist_cap lshock_fao_dist_bord lshock_fao_dist_res lshock_fao_gdp lshock_fao_pop) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(lshock_fao lshock_fao_dist lshock_fao_dist_cap lshock_fao_dist_bord lshock_fao_dist_res lshock_fao_gdp lshock_fao_pop) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close
