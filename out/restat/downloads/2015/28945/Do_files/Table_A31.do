*-----------------------------------------------------------------------------------------------------------------------------*
* This do file constructs Table A31 of the web appendix of Berman and Couttenier (2014)										  *
* This version: january 29, 2014																							  *
*-----------------------------------------------------------------------------------------------------------------------------*
*
clear all
cd "$Results"
						*--------------------------------------------*
						*--------------------------------------------*
						*    		TABLE A31 - AGOA SHOCK           *    
						*--------------------------------------------*
						*--------------------------------------------*
*
***********************
* PANEL A: AGOA SHARE *
***********************
*
foreach x in  c3 c1 c2{
use "$Output_data\data_BC_Restat2014", clear
tsset
*
label var agoa       "AGOA"
label var agoa_share "Share products AGOA"
*
gen location = group_gid
drop if conflict_`x' == .
/* incidence */
eststo: clogit conflict_`x'  agoa agoa_share yeard*, group(location) ro cluster(fao_region)
distinct iso3 if e(sample)
eststo: xtreg  conflict_`x'  agoa agoa_share yeard*, fe ro cluster(fao_region)
distinct iso3 if e(sample)
*
}
log using Table_A31.log, replace
set linesize 250
esttab, mtitles keep(agoa agoa_share_all) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(agoa agoa_share_all) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close
*
***************************
* PANEL B: AGOA + dist US *
***************************
*
foreach x in  c3 c1 c2{
use "$Output_data\data_BC_Restat2014", clear
tsset
*
label var agoa          "AGOA"
label var agoa_ldist_us "AGOA  $\times$ ln dist. US"
*
gen location = group_gid
drop if conflict_`x' == .
/* incidence */
eststo: clogit conflict_`x'  agoa agoa_ldist_us yeard*, group(location) ro cluster(fao_region)
eststo: xtreg  conflict_`x'  agoa agoa_ldist_us yeard*, fe ro cluster(fao_region)
*
}
log using Table_A31.log, append
set linesize 250
esttab, mtitles keep(agoa agoa_ldist_us) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(agoa agoa_ldist_us) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close
*
**************************************
* PANEL C: interaction with distance *
**************************************
*
foreach x in  c3 c1 c2{
use "$Output_data\data_BC_Restat2014", clear
tsset
*
label var agoa          "AGOA"
label var agoa_ldist    "AGOA  $\times$ remoteness$^1$"
*
gen location = group_gid
drop if conflict_`x' == .
/* incidence */
eststo: clogit conflict_`x'  agoa agoa_ldist yeard* , group(location) cluster(fao_region)  ro
eststo: xtreg  conflict_`x'  agoa agoa_ldist yeard* , fe ro cluster(fao_region)
*
}
*
log using Table_A31.log, append
set linesize 250
esttab, mtitles keep(agoa agoa_ldist) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(agoa agoa_ldist) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close
*
********************************************
* PANEL D: interaction with distance ratio *
********************************************
*
foreach x in  c3 c1 c2{
use "$Output_data\data_BC_Restat2014", clear
tsset
*
label var agoa            "AGOA"
label var agoa_ldist_r    "AGOA  $\times$ remoteness$^2$"
*
gen location = group_gid
drop if conflict_`x' == .
/* incidence */
eststo: clogit conflict_`x'  agoa agoa_ldist_r yeard* , group(location) cluster(fao_region)  ro
eststo: xtreg  conflict_`x'  agoa agoa_ldist_r yeard* , fe ro cluster(fao_region)
*
}
*
log using Table_A31.log, append
set linesize 250
esttab, mtitles keep(agoa agoa_ldist_r) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(agoa agoa_ldist_r) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close
