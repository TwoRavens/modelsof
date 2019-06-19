*-----------------------------------------------------------------------------------------------------------------------------*
* This do-file compute the statistics contained in Tables A.3 to A.6 of the web appendix of Berman and Couttenier (2014)		  *
* This version: january 29, 2014																							  *
*-----------------------------------------------------------------------------------------------------------------------------*
*
clear all
cd "$Results"
*
log using Table_A3_to_A6.log, replace
*
						*-----------------------------------------------*
						*-----------------------------------------------*
						* TABLES A.3 to A.6 conflicts descriptive stats *    
						*-----------------------------------------------*
						*-----------------------------------------------*
*
/* ALL YEARS */
use "$Output_data\data_BC_Restat2014", clear
cor nbconflict_c*
*
foreach c in c3 c1 c2{
use "$Output_data\data_BC_Restat2014", clear
keep if conflict_`c' != .
collapse (max) conflict_`c' (sum) nb_event = nbconflict_`c' (max) max_nbevent= nbconflict_`c', by(gid iso3 country_name)
g nbcell   = 1
g nbcell_c = nbcell if conflict_`c' == 1
collapse (sum) nbcell* nb_event (max) max_nbevent , by(iso3 country_name)
g share = nbcell_c / nbcell
compress
keep country_name share nb_event max_nbevent
save "$Results\share_conflict_`c'", replace
}
*
/* Only overlapping years */
use "$Output_data\data_BC_Restat2014", clear
cor nbconflict_c*
*
foreach c in c3 c1 c2{
use "$Output_data\data_BC_Restat2014", clear
keep if conflict_`c' != .
keep if year > 1996 & year < 2006
keep if iso3=="AGO" | iso3  =="CIV" | iso3=="BDI" | iso3=="COG"  | iso3=="CAF" | iso3=="COD" | iso3=="LBR" | iso3=="GIN" | iso3=="SLE" | iso3=="SDN" | iso3=="UGA" | iso3=="RWA"
collapse (max) conflict_`c' (sum) nb_event = nbconflict_`c' (max) max_nbevent= nbconflict_`c', by(gid iso3 country_name)
g nbcell   = 1
g nbcell_c = nbcell if conflict_`c' == 1
collapse (sum) nbcell* nb_event (max) max_nbevent , by(iso3 country_name)
g share = nbcell_c / nbcell
compress
keep country_name share nb_event max_nbevent
save "$Results\share_conflict_`c'_overlap", replace
}
*
use   "$Results\share_conflict_c3", replace
save  "$Results\Table_A3", replace
*
use   "$Results\share_conflict_c1", replace
save  "$Results\Table_A4", replace
*
use   "$Results\share_conflict_c2", replace
save  "$Results\Table_A5", replace
*
use   "$Results\share_conflict_c3_overlap", replace
save  "$Results\Table_A6a", replace
*
use   "$Results\share_conflict_c1_overlap", replace
save  "$Results\Table_A6b", replace
*
use   "$Results\share_conflict_c2_overlap", replace
save  "$Results\Table_A6c", replace
*
erase "$Results\share_conflict_c3.dta"
erase "$Results\share_conflict_c1.dta"
erase "$Results\share_conflict_c2.dta"
erase "$Results\share_conflict_c3_overlap.dta"
erase "$Results\share_conflict_c1_overlap.dta"
erase "$Results\share_conflict_c2_overlap.dta"
*
log close




