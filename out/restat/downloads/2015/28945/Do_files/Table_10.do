*-----------------------------------------------------------------------------------------------------------------------------*
* This do-file constructs Table 10 of the appendix of Berman and Couttenier (2014)											  *
* This version: january 29, 2014																							  *
*-----------------------------------------------------------------------------------------------------------------------------*
*
clear all
cd "$Results"
*
						*--------------------------------------------*
						*--------------------------------------------*
						*   TABLE 10 - SHOCK FAO: OTHER ROBUSTNESS  *    
						*--------------------------------------------*
						*--------------------------------------------*

use "$Output_data\data_BC_Restat2014", clear
cor lshock_fao lshock_fao lshock_fao_x lshock_fao_mp lshock_fao_w0 lshock_fao_wbin
*
log using Table10.log, replace
log close
*
/*PANELS A, C, D*/
foreach lshock_fao in lshock_fao_wbin lshock_fao_mp lshock_fao_x {
	use "$Output_data\data_BC_Restat2014", clear
	*
	label var `lshock_fao'      "ln agr. shock"
	label var `lshock_fao'_dist "ln agr. shock  $\times$ remoteness$^1$"
	*
	gen location = group_gid
	/* incidence */
	eststo: clogit conflict_c3  `lshock_fao' `lshock_fao'_dist yeard* , group(location) cluster(fao_region)  ro
	eststo: xtreg  conflict_c3  `lshock_fao' `lshock_fao'_dist yeard* , fe ro cluster(fao_region)
	eststo: clogit conflict_c1  `lshock_fao' `lshock_fao'_dist yeard* , group(location) cluster(fao_region)  ro
	eststo: xtreg  conflict_c1  `lshock_fao' `lshock_fao'_dist yeard* , fe ro cluster(fao_region)
	eststo: clogit conflict_c2  `lshock_fao' `lshock_fao'_dist yeard* , group(location) cluster(fao_region)  ro
	eststo: xtreg  conflict_c2  `lshock_fao' `lshock_fao'_dist yeard* , fe ro cluster(fao_region)
	*
*
log using Table10.log, append
set linesize 250
esttab, mtitles keep(`lshock_fao' `lshock_fao'_dist) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(`lshock_fao' `lshock_fao'_dist) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close
*
}
/*PANEL B */
foreach lshock_fao in lshock_fao_w0{
	use "$Output_data\data_BC_Restat2014", clear
	*
	label var `lshock_fao'      "ln agr. shock"
	label var `lshock_fao'_dist "ln agr. shock  $\times$ remoteness$^1$"
	*
	gen location = group_gid
	/* incidence */
	eststo: clogit conflict_c3  `lshock_fao' `lshock_fao'_dist yeard* if year>1993, group(location) cluster(fao_region)  ro
	eststo: xtreg  conflict_c3  `lshock_fao' `lshock_fao'_dist yeard* if year>1993, fe ro cluster(fao_region)
	eststo: clogit conflict_c1  `lshock_fao' `lshock_fao'_dist yeard* if year>1993, group(location) cluster(fao_region)  ro
	eststo: xtreg  conflict_c1  `lshock_fao' `lshock_fao'_dist yeard* if year>1993, fe ro cluster(fao_region)
	eststo: clogit conflict_c2  `lshock_fao' `lshock_fao'_dist yeard* if year>1993, group(location) cluster(fao_region)  ro
	eststo: xtreg  conflict_c2  `lshock_fao' `lshock_fao'_dist yeard* if year>1993, fe ro cluster(fao_region)
	*
*
log using Table10.log, append
set linesize 250
esttab, mtitles keep(`lshock_fao' `lshock_fao'_dist) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(`lshock_fao' `lshock_fao'_dist) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close
*
}
		