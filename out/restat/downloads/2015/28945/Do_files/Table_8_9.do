*-----------------------------------------------------------------------------------------------------------------------------*
* This do-file generates Tables 8 and 9 of Berman and Couttenier (2014)	     												  *
* This version: january 29, 2014																							  *
*-----------------------------------------------------------------------------------------------------------------------------*
*
clear all
cd "$Results"
*
			*--------------------------------------------*
			*--------------------------------------------*
			*       TABLE 8 - MACRO RESULTS 		     *
			*--------------------------------------------*
			*--------------------------------------------*
*
*****************
* A: shock FAO  *
*****************
*
use "$Output_data\data_BC_Restat2014", clear
*
keep if lshock_fao_c != . 
*
collapse (mean) lshock_fao_c yeard*  (mean) prio onsetprioP civil_conflict (sum) nb_conflict_c3=nbconflict_c3, by(iso3 year)
*
rename civil_conflict conflict_civil
rename prio           conflict_prio
rename onsetprioP     onset_prio
*
g conflict_c3 		  = nb_conflict_c3>0
bys iso3: egen sum_c3 = sum(conflict_c3)
*
egen  country = group(iso3)
tsset country year
*
foreach conflict in c3 civil {
g         onset_`conflict' = (conflict_`conflict'==1 & l.conflict_`conflict'==0)
replace   onset_`conflict' = . if conflict_`conflict'== 1 & l.conflict_`conflict'==1
replace   onset_`conflict' = . if conflict_`conflict' ==.
label var onset_`conflict' "Onset, `conflict'"
}

foreach conflict in c3 civil prio{
g         ending_`conflict' = (conflict_`conflict'==0 & l.conflict_`conflict'==1)
replace   ending_`conflict' = . if conflict_`conflict'== 0 & l.conflict_`conflict'==0
replace   ending_`conflict' = . if conflict_`conflict' ==.
label var ending_`conflict' "Ending, `conflict'"
}
egen iso3_year=group(iso3 year)
*
* Incidence *
eststo: xtreg conflict_c3     	 lshock_fao_c yeard*, fe ro cluster(iso3_year) nonest 
eststo: xtreg conflict_prio   	 lshock_fao_c yeard*, fe ro cluster(iso3_year) nonest
* Onset *
eststo: xtreg onset_c3      	 lshock_fao_c yeard*, fe ro cluster(iso3_year) nonest
eststo: xtreg onset_prio    	 lshock_fao_c yeard*, fe ro cluster(iso3_year) nonest
* Ending *
eststo: xtreg ending_c3     	 lshock_fao_c yeard*, fe ro cluster(iso3_year) nonest
eststo: xtreg ending_prio       lshock_fao_c yeard*, fe ro cluster(iso3_year) nonest
* Intensity *
eststo:  xtreg nb_conflict_c3    lshock_fao_c yeard*, fe ro cluster(iso3_year) nonest
*
log using Table8.log, replace
set linesize 250
esttab, mtitles keep(lshock_fao_c) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(lshock_fao_c) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close
*
*************
* B: CRISES *
*************
*
use "$Output_data\data_BC_Restat2014", clear
*
keep if exposure_crisis_c != .
*
collapse (mean) exposure_crisis_c  yeard*  (mean) prio onsetprioP civil_conflict (sum) nb_conflict_c3=nbconflict_c3, by(iso3 year)
*
rename civil_conflict conflict_civil
rename prio           conflict_prio
rename onsetprioP     onset_prio
*
g conflict_c3 = nb_conflict_c3>0
*
bys iso3: egen sum_c3=sum(conflict_c3)
*
egen country = group(iso3)
tsset country year
*
foreach conflict in c3 civil {
g       onset_`conflict' = (conflict_`conflict'==1 & l.conflict_`conflict'==0)
replace onset_`conflict' = . if conflict_`conflict'== 1 & l.conflict_`conflict'==1
replace onset_`conflict' = . if conflict_`conflict' ==.
label var onset_`conflict' "Onset, `conflict'"
}

foreach conflict in c3 civil prio{
g       ending_`conflict' = (conflict_`conflict'==0 & l.conflict_`conflict'==1)
replace ending_`conflict' = . if conflict_`conflict'== 0 & l.conflict_`conflict'==0
replace ending_`conflict' = . if conflict_`conflict' ==.
label var ending_`conflict' "Ending, `conflict'"
}
egen iso3_year=group(iso3 year)
*
* Incidence *
eststo: xtreg conflict_c3     exposure_crisis_c yeard*  , fe ro cluster(iso3_year) nonest
eststo: xtreg conflict_prio   exposure_crisis_c yeard*  , fe ro cluster(iso3_year) nonest
* Onset *
eststo: xtreg onset_c3        exposure_crisis_c yeard*  , fe ro cluster(iso3_year) nonest
eststo: xtreg onset_prio      exposure_crisis_c yeard*  , fe ro cluster(iso3_year) nonest
* Ending *
eststo: xtreg ending_c3       exposure_crisis_c yeard*  , fe ro cluster(iso3_year) nonest
eststo: xtreg ending_prio     exposure_crisis_c yeard*  , fe ro cluster(iso3_year) nonest
* Intensity *
eststo: xtreg nb_conflict_c3  exposure_crisis_c yeard*  , fe ro cluster(iso3_year) nonest
*
log using Table8.log, append
set linesize 250
esttab, mtitles keep(exposure_crisis_c) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(exposure_crisis_c) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close
*
			*--------------------------------------------*
			*--------------------------------------------*
			*       TABLE 9 - LINK MICRO MACRO 	    	 *
			*--------------------------------------------*
			*--------------------------------------------*
*
use "$Output_data\data_BC_Restat2014", clear
tsset
sort group_gid year
keep if onsetprio == 1 
keep if lshock_fao !=. & exposure_crisis != .
*
eststo: xtreg conflict_c3   lshock_fao 						yeard*, fe ro cluster(fao_region)
eststo: xtreg conflict_c3   lshock_fao lshock_fao_dist  	yeard*, fe ro cluster(fao_region)
eststo: xtreg nbconflict_c3 lshock_fao 						yeard*, fe ro cluster(fao_region)
eststo: xtreg nbconflict_c3 lshock_fao lshock_fao_dist  	yeard*, fe ro cluster(fao_region)
*
eststo: xtreg conflict_c3   exposure_crisis 			 	yeard*, fe ro cluster(fao_region) 
eststo: xtreg conflict_c3   exposure_crisis crisis_ldist 	yeard*, fe ro cluster(fao_region)
eststo: xtreg nbconflict_c3 exposure_crisis 			 	yeard*, fe ro cluster(fao_region)
eststo: xtreg nbconflict_c3 exposure_crisis crisis_ldist 	yeard*, fe ro cluster(fao_region)
*
distinct iso3 if e(sample)
tab year if e(sample)
*
log using Table9.log, replace
set linesize 250
esttab, mtitles keep(lshock_fao lshock_fao_dist exposure_crisis crisis_ldist) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(lshock_fao lshock_fao_dist exposure_crisis crisis_ldist) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close



