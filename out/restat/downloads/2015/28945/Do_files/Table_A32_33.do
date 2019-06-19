*-----------------------------------------------------------------------------------------------------------------------------*
* This do file constructs Table A32 and A33 of the web appendix of Berman and Couttenier (2014)								  *
* This version: january 29, 2014																							  *
*-----------------------------------------------------------------------------------------------------------------------------*
*
cd "$Results"
*
/*append data for estimations with additional ACLED countries */
use "$Output_data\data_BC_Restat2014", clear
rename conflict_c2 		acled
rename onset_c2 		onset_acled
rename ending_c2 		ending_acled
append using "$Output_data\To_Append_No_Africa"
*
drop country_year fao_region yeard* group_gid 
*for clusters
egen country_year = group(iso3 year)
egen fao_region   = group(region iso3)
egen group_gid    = group(iso3 gid)
gen location      = group_gid
*
/* year dummies*/
tab year, gen(yeard)
*
tsset group_gid year
sort  group_gid year
*
					*--------------------------------------------*
					*--------------------------------------------*
					* TABLE A32 - SHOCK FAO, ALL COUNTRIES 	 *
					*--------------------------------------------*
					*--------------------------------------------*
*					
***********
* PANEL A *
***********
*
/* incidence */
eststo: clogit acled  lshock_fao yeard*, group(location) ro cluster(fao_region)
eststo: xtreg  acled  lshock_fao yeard* , fe ro cluster(fao_region)
*
/* onset */
eststo: clogit onset_acled  lshock_fao yeard*, group(location) ro cluster(fao_region)
eststo: xtreg  onset_acled  lshock_fao yeard* , fe ro cluster(fao_region)
*
/* ending */
eststo: clogit ending_acled  lshock_fao yeard*, group(location) ro cluster(fao_region)
eststo: xtreg  ending_acled  lshock_fao yeard* , fe ro cluster(fao_region)
*
log using Table_A32.log, replace
set linesize 250
esttab, mtitles keep(lshock_fao) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(lshock_fao) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close
*
***********
* PANEL B *
***********
*
/* incidence */
eststo: clogit acled  lshock_fao lshock_fao_dist  yeard* , group(location) cluster(fao_region)  ro
eststo: xtreg  acled  lshock_fao lshock_fao_dist  yeard* , fe ro cluster(fao_region)
*
/* onset */
eststo: clogit onset_acled  lshock_fao lshock_fao_dist   yeard*, group(location) cluster(fao_region)  ro
eststo: xtreg  onset_acled  lshock_fao lshock_fao_dist  yeard* , fe ro cluster(fao_region)
*
/* ending */
eststo: clogit ending_acled  lshock_fao lshock_fao_dist yeard*, group(location) cluster(fao_region)  ro
eststo: xtreg  ending_acled  lshock_fao lshock_fao_dist yeard* , fe ro cluster(fao_region)
*
log using Table_A32.log, append
set linesize 250
esttab, mtitles keep(lshock_fao lshock_fao_dist  ) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(lshock_fao lshock_fao_dist  ) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close
					*---------------------------------------------*
					*---------------------------------------------*
					* TABLE A.33 - SHOCK CRISIS: All countries    *      
					*---------------------------------------------*
					*---------------------------------------------*				
*									
***********
* PANEL A *
***********
*
/* incidence */
eststo: clogit acled  exposure_crisis yeard*, group(location) ro cluster(fao_region)
eststo: xtreg  acled  exposure_crisis yeard* , fe ro cluster(fao_region)
*
/* onset */
eststo: clogit onset_acled  exposure_crisis yeard*, group(location) ro cluster(fao_region)
eststo: xtreg  onset_acled  exposure_crisis yeard* , fe ro cluster(fao_region)
*
/* ending */
eststo: clogit ending_acled  exposure_crisis yeard*, group(location) ro cluster(fao_region)
eststo: xtreg  ending_acled  exposure_crisis yeard* , fe ro cluster(fao_region)
*
log using Table_A33.log, replace
set linesize 250
esttab, mtitles keep(exposure_crisis) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(exposure_crisis) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close
*
***********
* PANEL B *
***********
*
/* incidence */
eststo: clogit acled  exposure_crisis crisis_ldist yeard* , group(location) cluster(fao_region)  ro
eststo: xtreg  acled  exposure_crisis crisis_ldist yeard* , fe ro cluster(fao_region)
*
/* onset */
eststo: clogit onset_acled  exposure_crisis crisis_ldist yeard*, group(location) cluster(fao_region)  ro
eststo: xtreg  onset_acled  exposure_crisis crisis_ldist yeard* , fe ro cluster(fao_region)
*
/* ending */
eststo: clogit ending_acled  exposure_crisis crisis_ldist yeard*, group(location) cluster(fao_region)  ro
eststo: xtreg  ending_acled  exposure_crisis crisis_ldist yeard*, fe ro cluster(fao_region)
*
log using Table_A33.log, append
set linesize 250
esttab, mtitles keep(exposure_crisis crisis_ldist) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(exposure_crisis crisis_ldist) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close

		