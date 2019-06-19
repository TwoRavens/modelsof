*-----------------------------------------------------------------------------------------------------------------------------*
* This do file constructs Table A13 of the web appendix of Berman and Couttenier (2014)										  *
* This version: january 29, 2014																							  *
*-----------------------------------------------------------------------------------------------------------------------------*
*
clear all
cd "$Results"
*
						*--------------------------------------------*
						*--------------------------------------------*
						* 		TABLE A13 - CRISIS ROBUSTNESS    	 *
						*--------------------------------------------*
						*--------------------------------------------*
*
***************************
* PANEL A: distance level *
***************************
*
foreach x in c3 c1 c2{
use "$Output_data\data_BC_Restat2014", clear
g temp0 = pop if year == 1990
bys gid : egen pop90 = mean(pop)
g crisis_gdp = log(ppp90)*exposure_crisis
g crisis_pop = log(pop90)*exposure_crisis
drop pop90 temp0
*
label var exposure_crisis "Exposure to crises "
label var crisis_ldist  "Exp. to crises  $\times$ remoteness$^1$"
*
gen location = group_gid
drop if conflict_`x' == .
/* incidence */
eststo: clogit conflict_`x'  exposure_crisis crisis_ldist crisis_ldist_cap crisis_ldist_bord crisis_ldist_res crisis_gdp crisis_pop ldist_cap ldist_bord yeard*, group(location) ro cluster(fao_region)
distinct iso3 if e(sample)
eststo: xtreg  conflict_`x'  exposure_crisis crisis_ldist crisis_ldist_cap crisis_ldist_bord crisis_ldist_res crisis_gdp crisis_pop ldist_cap ldist_bord yeard*, fe ro cluster(fao_region)
distinct iso3 if e(sample)
*
}
log using Table_A13.log, replace
set linesize 250
esttab, mtitles keep(exposure_crisis crisis_ldist crisis_ldist_cap crisis_ldist_bord crisis_ldist_res crisis_gdp crisis_pop ) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(exposure_crisis crisis_ldist crisis_ldist_cap crisis_ldist_bord crisis_ldist_res crisis_gdp crisis_pop ) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close
*
***************************
* PANEL B: distance ratio *
***************************
*
foreach x in c3 c1 c2{
use "$Output_data\data_BC_Restat2014", clear
g temp0 = pop if year == 1990
bys gid : egen pop90 = mean(pop)
g crisis_gdp = log(ppp90)*exposure_crisis
g crisis_pop = log(pop90)*exposure_crisis
drop pop90 temp0
*
label var exposure_crisis "Exposure to crises "
label var crisis_ldist  "Exp. to crises  $\times$ remoteness$^1$"
*
gen location = group_gid
drop if conflict_`x' == .
/* incidence */
eststo: clogit conflict_`x'  exposure_crisis crisis_ldist_r crisis_ldist_cap_r crisis_ldist_bord_r crisis_ldist_res_r crisis_gdp crisis_pop ldist_cap ldist_bord yeard*, group(location) ro cluster(fao_region)
eststo: xtreg  conflict_`x'  exposure_crisis crisis_ldist_r crisis_ldist_cap_r crisis_ldist_bord_r crisis_ldist_res_r crisis_gdp crisis_pop ldist_cap ldist_bord yeard*, fe ro cluster(fao_region)
}
log using Table_A13.log, append
set linesize 250
esttab, mtitles keep(exposure_crisis crisis_ldist_r crisis_ldist_cap_r crisis_ldist_bord_r crisis_ldist_res_r crisis_gdp crisis_pop ) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(exposure_crisis crisis_ldist_r crisis_ldist_cap_r crisis_ldist_bord_r crisis_ldist_res_r crisis_gdp crisis_pop ) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close

			