*-----------------------------------------------------------------------------------------------------------------------------*
* This do-file generates Table 7 of Berman and Couttenier (2014)															  *
* This version: january 29, 2014 																							  *
*-----------------------------------------------------------------------------------------------------------------------------*
*
clear all
cd "$Results"
*
			*--------------------------------------------*
			*--------------------------------------------*
			*    TABLE 7 - CHANNELS OF TRANSMISSION 	 *     
			*--------------------------------------------*
			*--------------------------------------------*
*
*********************************
* A: Shocks and GDP per capita  *
*********************************
*
use "$Output_data\data_BC_Restat2014", clear
*
g lgdpc = .	
replace lgdpc = log(gcppc90) if year==1990
replace lgdpc = log(gcppc95) if year==1995
replace lgdpc = log(gcppc00) if year==2000
replace lgdpc = log(gcppc05) if year==2005
keep if lgdpc != .
/* include all interactions */
eststo: xtreg lgdpc  lshock_fao      lshock_fao_dist  lshock_fao_dist_cap  lshock_fao_dist_bord  lshock_fao_dist_res  ldist_bord ldist_cap yeard* if quality == 1, fe cluster(gid)  ro
eststo: xtreg lgdpc  exposure_crisis crisis_ldist     crisis_ldist_cap     crisis_ldist_bord     crisis_ldist_res     ldist_bord ldist_cap yeard* if quality == 1, fe cluster(gid)  ro
*
************************************
* B: Shocks and military spending  *
************************************
*
use "$Output_data\data_BC_Restat2014", clear
*
label var lshock_fao      "ln agr. shock"
label var lshock_fao_dist "ln agr. shock  $\times$ remoteness$^1$"
*
gen location = group_gid
*
collapse (mean) military_constant military_share exposure_crisis shock_fao_c country_year, by(iso3 year)
*
g lmilitary_constant   = log(military_constant)
g lmilitary_share      = log(military_share)
g lshock_fao  	       = log(shock_fao)
*
egen country=group(iso3)
tsset country year
tab year, gen(yeard)
*
eststo: xtreg lmilitary_constant  lshock_fao yeard*     , fe ro cluster(country_year) nonest
eststo: xtreg lmilitary_constant  exposure_crisis yeard*, fe ro cluster(country_year) nonest
eststo: xtreg lmilitary_share     lshock_fao yeard*     , fe ro cluster(country_year) nonest
eststo: xtreg lmilitary_share     exposure_crisis yeard*, fe ro cluster(country_year) nonest
*
******************************************
* C: EFFICIENCY OF REVENUE MOBILIZATION  *
******************************************
*
use "$Output_data\data_BC_Restat2014", clear
*
bys iso3: egen mean_irai_erm = mean(irai_erm)
g lshock_fao_irai            = mean_irai_erm*lshock_fao
g exposure_crisis_irai       = mean_irai_erm*exposure_crisis
*
gen location = group_gid
*
eststo: xtreg  conflict_c3  lshock_fao 	    lshock_fao_irai   					  yeard* , fe ro cluster(fao_region)
eststo: xtreg  conflict_c3  lshock_fao	    lshock_fao_irai      lshock_fao_dist  yeard* , fe ro cluster(fao_region)
eststo: xtreg  conflict_c3  exposure_crisis exposure_crisis_irai  			   	  yeard* , fe ro cluster(fao_region)
eststo: xtreg  conflict_c3  exposure_crisis exposure_crisis_irai crisis_ldist     yeard* , fe ro cluster(fao_region)
*
label var lshock_fao       		"Shock"
label var exposure_crisis  		"Shock"
label var lshock_fao_dist  		"Shock $\times$ remoteness$^1$"
label var crisis_ldist     		"Shock $\times$ remoteness$^1$"
label var lshock_fao_irai  	    "Shock $\times$ Rev. mobilization"
label var exposure_crisis_irai  "Shock $\times$ Rev. mobilization"
*
log using "$Results\Table7.log", replace
set linesize 250
esttab, mtitles keep(lshock_fao lshock_fao_dist exposure_crisis crisis_ldist lshock_fao_irai exposure_crisis_irai) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(lshock_fao lshock_fao_dist exposure_crisis crisis_ldist lshock_fao_irai exposure_crisis_irai) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close
*
