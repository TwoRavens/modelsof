*-----------------------------------------------------------------------------------------------------------------------------*
* This do file constructs Table A26 and A27 of the web appendix of Berman and Couttenier (2014)								  *
* This version: january 29, 2014																							  *
*-----------------------------------------------------------------------------------------------------------------------------*
*
clear all
cd "$Results"
*
			*--------------------------------------------*
			*--------------------------------------------*
			*   	TABLE A26 / A27 - OUTLIERS			 *
			*--------------------------------------------*
			*--------------------------------------------*


				*** A26 - OUTLIERS / FAO ***
				****************************
				
cd "$Output_data"
clear all
use data_BC_Restat2014, clear
cd "$Results"
save tmp, replace

global export "Results_outliers.xls"
capture erase "Results_outliers.txt"
capture erase "$export"

	** drop 5 countries with highest number of conflict
	
use tmp, clear
gen location = group_gid
drop if conflict_c3 == .
bys iso3: egen sum_conflict2 = sum(conflict_c3)
gen t = 1
bys iso3  : egen nb_grid = sum(t)
gen share = sum_conflict2 /nb_grid
tab share
eststo: xtreg  conflict_c3  lshock_fao lshock_fao_dist yeard* if share<0.20 , fe ro cluster(fao_region)
	
use tmp, clear
gen location = group_gid
drop if conflict_c1 == .
bys iso3: egen sum_conflict2 = sum(conflict_c1)
gen t = 1
bys iso3  : egen nb_grid = sum(t)
gen share = sum_conflict2 /nb_grid
tab share
eststo: xtreg  conflict_c1  lshock_fao lshock_fao_dist yeard* if share<0.1 , fe ro cluster(fao_region)
	
use tmp, clear
gen location = group_gid
drop if conflict_c2 == .
bys iso3: egen sum_conflict2 = sum(conflict_c2)
gen t = 1
bys iso3  : egen nb_grid = sum(t)
gen share = sum_conflict2 /nb_grid
tab share
eststo: xtreg  conflict_c2  lshock_fao lshock_fao_dist yeard* if share<0.205, fe ro cluster(fao_region)

foreach x in c3 c1 c2{
use tmp, clear
gen location = group_gid
drop if conflict_`x' == .

bys iso3 year: egen sum_conflict = sum(conflict_`x')
bys iso3: egen sum_conflict2 = sum(conflict_`x')
gen t = 1
bys iso3 year : egen nb_grid = sum(t)
gen share = sum_conflict /nb_grid

	** < 20% obs iso/year sont en conflits
eststo: xtreg  conflict_`x'  lshock_fao lshock_fao_dist yeard* if share < 0.2 , fe ro cluster(fao_region)

	** > 0 obs by iso/year
eststo: xtreg  conflict_`x'  lshock_fao lshock_fao_dist yeard* if sum_conflict > 0 , fe ro cluster(fao_region)

	** nb_conflict<1
eststo: xtreg  conflict_`x'  lshock_fao lshock_fao_dist yeard* if nbconflict_`x'< 2 , fe ro cluster(fao_region)

}
*
log using Table_A26.log, replace
set linesize 250
esttab, mtitles keep(lshock_fao lshock_fao_dist) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(lshock_fao lshock_fao_dist) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close
erase tmp.dta
				** A27 - OUTLIERS / CRISIS **
				*****************************

cd "$Output_data"
clear all
use data_BC_Restat2014, clear
cd "$Results"
save tmp, replace

global export "Results_outliers_crisis.xls"
capture erase "Results_outliers_crisis.txt"
capture erase "$export"

	** drop 5 countries with highest number of conflict
	
use tmp, clear
gen location = group_gid
drop if conflict_c3 == .
bys iso3: egen sum_conflict2 = sum(conflict_c3)
gen t = 1
bys iso3  : egen nb_grid = sum(t)
gen share = sum_conflict2 /nb_grid
tab share
eststo: xtreg  conflict_c3  exposure_crisis crisis_ldist yeard* if share<0.20 , fe ro cluster(fao_region)
	
use tmp, clear
gen location = group_gid
drop if conflict_c1 == .
bys iso3: egen sum_conflict2 = sum(conflict_c1)
gen t = 1
bys iso3  : egen nb_grid = sum(t)
gen share = sum_conflict2 /nb_grid
tab share
eststo: xtreg  conflict_c1  exposure_crisis crisis_ldist yeard* if share<0.1 , fe ro cluster(fao_region)
	
use tmp, clear
gen location = group_gid
drop if conflict_c2 == .
bys iso3: egen sum_conflict2 = sum(conflict_c2)
gen t = 1
bys iso3  : egen nb_grid = sum(t)
gen share = sum_conflict2 /nb_grid
tab share
eststo: xtreg  conflict_c2  exposure_crisis crisis_ldist yeard* if share<0.205, fe ro cluster(fao_region)

foreach x in c3 c1 c2{
use tmp, clear
gen location = group_gid
drop if conflict_`x' == .

bys iso3 year: egen sum_conflict = sum(conflict_`x')
bys iso3: egen sum_conflict2 = sum(conflict_`x')
gen t = 1
bys iso3 year : egen nb_grid = sum(t)
gen share = sum_conflict /nb_grid

	** < 20% obs iso/year sont en conflits
eststo: xtreg  conflict_`x'  exposure_crisis crisis_ldist yeard* if share < 0.2 , fe ro cluster(fao_region)

	** > 0 obs by iso/year
eststo: xtreg  conflict_`x'  exposure_crisis crisis_ldist yeard* if sum_conflict > 0 , fe ro cluster(fao_region)

	** nb_conflict<1
eststo: xtreg  conflict_`x'  exposure_crisis crisis_ldist yeard* if nbconflict_`x'< 2 , fe ro cluster(fao_region)
}			
log using Table_A27.log, replace
set linesize 250
esttab, mtitles keep(exposure_crisis crisis_ldist) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(exposure_crisis crisis_ldist) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close
erase tmp.dta
