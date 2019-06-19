*-----------------------------------------------------------------------------------------------------------------------------*
* This do file constructs the main dataset used in Berman and Couttenier (2014) 											  *
* This version: september 18, 2014																								  *
*-----------------------------------------------------------------------------------------------------------------------------*
*
clear all
cd "$Output_data"

			** DATA CREATION GID + YEAR **
			******************************

set obs 33
gen year = 1979 + _n
keep if year >1979
save "$Output_data\years", replace 

use "$Data\PRIO_continent\PRIOcont.dta", clear
keep if continent == "Africa"
cross using "$Output_data\years.dta"

erase "$Output_data\years.dta"
sort gid year
save "$Output_data\base_gid_year", replace


			** MERGE DATA PRIO GRID TIME VARIANT **
			***************************************
			
use "$Data\priodata\files_w_year\conflict_v1_01", clear
keep if year > 1979 
sort gid
merge gid using "$Data\PRIO_continent\PRIOcont.dta"
drop _merge
keep if continent == "Africa"
sort gid year
merge  gid year using  "$Output_data\base_gid_year"
drop _merge
compress
sort gid year
save "$Output_data\base_reg_afr", replace
*
use "$Data\priodata\files_w_year\distance_v1_01", clear
keep if year > 1979
sort gid
merge gid using "$Data\PRIO_continent\PRIOcont.dta"
drop _merge
keep if continent == "Africa"
sort gid year
merge  gid year using  "$Output_data\base_reg_afr"
drop _merge
compress
sort gid year
save "$Output_data\base_reg_afr", replace
*
use "$Data\priodata\files_w_year\physclimate_v1_01", clear
keep if year > 1979
sort gid
merge gid using "$Data\PRIO_continent\PRIOcont.dta"
drop _merge
keep if continent == "Africa"
sort gid year
merge  gid year using  "$Output_data\base_reg_afr"
drop _merge
compress
sort gid year
save "$Output_data\base_reg_afr", replace
*
use "$Data\priodata\files_w_year\socioeco_v1_01", clear
keep if year > 1979
sort gid
merge gid using "$Data\PRIO_continent\PRIOcont.dta"
drop _merge
keep if continent == "Africa"
sort gid year
merge  gid year using  "$Output_data\base_reg_afr"
drop _merge
compress
sort gid 
save "$Output_data\base_reg_afr", replace


			** MERGE DATA PRIO GRID TIME INVARIANT **
			*****************************************
			
use "$Data\priodata\globcover_v1", clear
reshape wide lclasspc, i(gid) j(lclass)
sort gid
merge gid using "$Data\PRIO_continent\PRIOcont.dta"
drop _merge
keep if continent == "Africa"
sort gid
merge  gid  using  "$Output_data\base_reg_afr"
drop _merge
sort gid 
save "$Output_data\base_reg_afr", replace
*
use "$Data\priodata\nordhaus_v1_01", clear
sort gid
merge gid using "$Data\PRIO_continent\PRIOcont.dta"
drop _merge
keep if continent == "Africa"
sort gid
merge  gid  using  "$Output_data\base_reg_afr"
keep if _merge == 3
drop _merge
sort gid year
save "$Output_data\base_reg_afr", replace


			** RESOURCES DATA **
			********************
			
clear
import excel "$Data\resources\PETRODATA\Petrodata_Onshore_V1.2.xlsx", sheet("Copy of Petrodata_Onshore_V1.2") firstrow
keep if CONTCODE == 4
rename FIPSCODE iso2
sort iso2
merge iso2 using "$Data\resources\country_codes", nokeep
tab _merge
drop _merge 
*
replace iso3 = "BWA" if iso2=="BC"
replace iso3 = "TCD" if iso2=="CD"
replace iso3 = "COG" if iso2=="CF"
replace iso3 = "COD" if iso2=="CG"
replace iso3 = "CMR" if iso2=="CM"
replace iso3 = "CAF" if iso2=="CT"
replace iso3 = "GAB" if iso2=="GB"
replace iso3 = "GIN" if iso2=="GV"
replace iso3 = "CIV" if iso2=="IV"
replace iso3 = "LBR" if iso2=="LI"
replace iso3 = "LSO" if iso2=="LT"
replace iso3 = "NGA" if iso2=="NI"
replace iso3 = "ZAF" if iso2=="SF"
replace iso3 = "BFA" if iso2=="UV"
replace iso3 = "NAM" if iso2=="WA"
replace iso3 = "SWZ" if iso2=="WZ"
replace iso3 = "ZMB" if iso2=="ZA"
replace iso3 = "ZWE" if iso2=="ZI"
*
rename LAT     latitude
rename LONG    longitude
rename RESINFO resource
keep latitude longitude iso3 resource
save "$Data\resources\oil_gas", replace
*
use "$Data\resources\diams_coord", clear			
g resource = "diamond"
sort iso2
merge iso2 using "$Data\resources\country_codes", nokeep
tab _merge
drop _merge 
*
replace iso3 = "BWA" if iso2=="BC"
replace iso3 = "TCD" if iso2=="CD"
replace iso3 = "COG" if iso2=="CF"
replace iso3 = "COD" if iso2=="CG"
replace iso3 = "CMR" if iso2=="CM"
replace iso3 = "CAF" if iso2=="CT"
replace iso3 = "GAB" if iso2=="GB"
replace iso3 = "GIN" if iso2=="GV"
replace iso3 = "CIV" if iso2=="IV"
replace iso3 = "LBR" if iso2=="LI"
replace iso3 = "LSO" if iso2=="LT"
replace iso3 = "NGA" if iso2=="NI"
replace iso3 = "ZAF" if iso2=="SF"
replace iso3 = "BFA" if iso2=="UV"
replace iso3 = "NAM" if iso2=="WA"
replace iso3 = "SWZ" if iso2=="WZ"
replace iso3 = "ZMB" if iso2=="ZA"
replace iso3 = "ZWE" if iso2=="ZI"
*
rename latitude  latitude
rename longitude longitude
keep latitude longitude iso3 resource
*
append using "$Data\resources\oil_gas"
*
rename latitude  latitude_res
rename longitude longitude_res
*
sort iso3 resource
save "$Data\resources\resources_all", replace



		** COORDINATES AND COUNTRY **
		*****************************
		
/* coordinates grids */
use "$Data/PRIO-GRID/priogrid_v1_01", clear 
collapse (max) xcoord ycoord, by(gid)
sort gid
rename xcoord longitude
rename ycoord latitude
save "$Output_data\priogrid_v1_01", replace
*
/* country id*/
use "$Data\gid_ethnic_wide", clear
keep gid iso_1
save "$Output_data\temp0", replace
*
use "$Output_data/base_reg_afr", clear
*
sort gid
merge gid using "$Output_data/temp0", nokeep
tab _merge
drop _merge
*
sort gid
merge gid using "$Output_data\priogrid_v1_01", nokeep
tab _merge
drop _merge
*
sort gid year
save "$Output_data\base_reg_afr", replace


			** MERGE ACLED DATA **
			**********************
			
use "$Data\acled_II\africapriot.dta", clear			
keep gid year event_ty 
gen tot = 1
cap drop id
egen id = group(event_ty)
keep if id == 1 | id == 2 | id == 3 | id == 4  | id == 5
collapse (sum) t, by(gid year id)
reshape wide tot, i(gid year) j(id)
sort gid year
merge gid year using "$Output_data\base_reg_afr"
drop _merge

egen nb_event = rsum(tot*)
forvalues t = 1/5{
rename tot`t' nb_event`t'
replace nb_event`t' = 0 if  nb_event`t' == . & year>1996
}
*
drop if year == .
drop if year >2010
save "$Output_data\base_reg_afr", replace
*
/* ACLED data*/
use "$Data\acled_II\africapriot", clear
cap drop id
egen id = group(event_ty)
keep if id == 1 | id == 2 | id == 3 | id == 4  | id == 5
tab event_ty
g nb_acled = 1
*
/* acled fatalities*/ 
egen dyad_c2 = group(actor1 actor2)
*
collapse (sum) fataliti dyad_c2, by(gid year)
save "$Output_data\temp1", replace
*
use "$Output_data/base_reg_afr", clear
*
sort gid year
merge gid year using "$Output_data/temp1", nokeep
tab _merge
tab _merge if year>=1997
distinct gid if _merge==3
distinct gid if _merge==1
drop _merge
*
g acled   = (nb_event>0)
*
sort gid year
save "$Output_data\base_reg_afr", replace


		** GET GRID VERSION OF ACLED 1980-2005 *
		****************************************
		
clear 
insheet using "$Data\acled_I\prio.txt"
g conflict = 1
collapse (mean) conflict , by(latitude longitude)
drop conflict
sort latitude longitude
save conflict_coords, replace
outsheet using "$Data\acled_I\conflict_coords.txt", comma replace
*
* Here arc gis merge step *
*
clear
insheet using "$Data\acled_I\shp\merge.csv", comma
keep gid latitude longitude 
sort latitude longitude
save acled_1980_2005_coord, replace
*
clear
insheet using "$Data\acled_I\prio.txt"
sort latitude longitude
merge latitude longitude using acled_1980_2005_coord, nokeep
tab _merge
drop _merge
*
g year =substr(eventdate,7,10)
destring year, replace
*
/* keep period 1980-2005 */
keep if year>=1980 & year<2006
g nbconflict = 1 
egen dyad_c1 = group(sidea sideb)
*
collapse (sum) nbconflict dyad_c1, by(gid year)
*
sort gid year
duplicates report gid year
*
rename nbconflict nbconflict_a1
g conflict_a1 = 1
*
sort gid year
save acled_1980_2005_grid, replace
*
use "$Output_data\base_reg_afr", clear
sort gid year
merge gid year using acled_1980_2005_grid, nokeep
tab _merge
drop _merge
*
bys gid: egen sum_acled = sum(nbconflict)
*
replace iso_1 = "COG" if iso_1=="GAB" & sum_acled>0
replace iso_1 = "UGA" if iso_1=="KEN" & sum_acled>0
replace iso_1 = "BDI" if iso_1=="TZA" & sum_acled>0
replace iso_1 = "COD" if iso_1=="ZMB" & sum_acled>0
*
drop sum_acled
sort gid year
save "$Output_data\base_reg_afr", replace



			** CONFLICTS FROM UCDP PRIO **
			******************************
clear
insheet using "$Data\ucdp_conflict\ucdp-ged-points-v-1-5-csv\ucdp-ged15.csv"
*
/* drop if geo-precision is country level or missing */
drop if where_prec > 5
*
rename priogrid_gid gid 
g nb_event_ucdp = 1
g fataliti_ucdp = best_est
*
gen dyad_c3 = dyad_id
*
collapse (sum) nb_event_ucdp fataliti_ucdp dyad_c3, by(gid year)
*
label var nb_event_ucdp "# events, UCDP dataset"
label var fataliti_ucdp "# deaths, UCDP dataset"
*
sort gid year
save temp0, replace
*
use "$Output_data\base_reg_afr", clear
sort gid year
merge gid year using temp0, nokeep
tab _merge
drop _merge
*
sort gid year
save "$Output_data\base_reg_afr", replace

				** LABELS *
				***********
				
use "$Output_data\base_reg_afr", clear
*		
forvalues x=1(1)5{
label var nb_event`x' "# Event of type `x', Acled 1997-2010"
}
/*
forvalues x=8(1)8{
label var nb_event`x' "# Event of type `x', Acled 1997-2010"
}
*/
label var year      	"year"
label var gid       	"Prio GID cell code"
label var gcppc90   	"GDP per capita 1990"
label var gcppc95   	"GDP per capita 1995"
label var gcppc00   	"GDP per capita 2000"
label var gcppc05   	"GDP per capita 2005"
label var ppp90     	"GDP PPP, 1990"
label var ppp95     	"GDP PPP, 1995"
label var ppp00     	"GDP PPP, 2000"
label var ppp05     	"GDP PPP, 2005"
label var continent 	"Continent" 
label var longitude 	"Longitude centroid"
label var latitude  	"Latitude centroid"
label var nb_event  	"# Events, ACLED 1997-2010"
label var fataliti  	"# fatalities, ACLED 1997-2010"
label var acled     	"Binary, 1 for event, ACLED 1997-2010"
label var nbconflict_a1 "# events, ACLED 1980-2005"
label var conflict_a1   "Binary, 1 for event, ACLED 1985-2010"
*
sort gid iso_1 year
duplicates drop gid iso_1 year, force
drop if latitude == . | longitude == .
egen group_gid=group(gid)
*
save "$Output_data\base_reg_afr", replace



			** DISTANCE TO MAJOR PORTS **
			******************************
/* Why a draft of 10 meters? */
/* This is generally the threshold for a port to be considered "deep water" */
/* Actually it's about accomodating Panamax-like ships, which means 12.5 meters */
/* See http://en.wikipedia.org/wiki/Panamax */
/* Should do a robustness with 12 meters */
/*
/*seaport data*/
use "$Data\ports\ports_correct.dta", clear
append using "$Data\ports\patch2013"
sort iso3
save "$Data\ports\port_2013", replace
*
*******************
* 10 METERS DRAFT *
*******************
*
use "$Data\ports\port_2013", clear
replace country="Democratic Republic of Congo" if country=="Zaire"
replace country="Sierra Leone" if country=="Sierra leone"
sort port
g test=1
rename latitude  latitude_p
rename longitude longitude_p
save temp1, replace
/*conflict data*/
use base_reg_afr, clear
collapse (mean) latitude longitude, by(group_gid)
sort group_gid
gen count=_n
egen max_count=max(count)
g test=1
save temp2, replace 
*
local i = 1
		while `i'<max_count+1{
			use temp2, clear
			keep if count ==`i'
			sort test
			save r`i', replace
			use temp1, clear
			sort test
			merge test using r`i', nokeep
			tab _merge
			keep if _merge == 3
			drop _merge 
			geodist latitude longitude latitude_p longitude_p, generate(distance)
			sort distance
			keep if _n==1
			save r`i', replace
			local i = `i'+1 
		}

		use r1, clear
local i = 2
		while `i'<max_count+1{
		append using r`i'
		erase r`i'.dta
		local i = `i'+1 
		}
		erase r1.dta

*
/* append all */
*
sort group_gid
keep iso3 group_gid latitude_p longitude_p distance port
*
sort group_gid
rename distance    distance_cp
rename latitude_p  latitude_cp
rename longitude_p longitude_cp
rename iso3        iso3_cp
rename port        cport_a
label var distance_cp  "distance to closest port , all countries"
label var latitude_cp  "Latitude closest port, all countries"
label var longitude_cp "Longitude closest port, all countries"
label var cport_a      "closest port, all countries"
sort group_gid
save closest_port_a, replace
*
erase temp1.dta
erase temp2.dta
*
*******************
* 12 METERS DRAFT *
*******************
*
use "$Data\ports\port_2013", clear
*
drop if maxdraft <12

replace country="Democratic Republic of Congo" if country=="Zaire"
replace country="Sierra Leone" if country=="Sierra leone"
sort port
g test=1
rename latitude  latitude_p
rename longitude longitude_p
save temp1, replace
/*conflict data*/
use base_reg_afr, clear
collapse (mean) latitude longitude, by(group_gid)
sort group_gid
gen count=_n
egen max_count=max(count)
g test=1
save temp2, replace 
*
local i = 1
		while `i'<max_count+1{
			use temp2, clear
			keep if count ==`i'
			sort test
			save r`i', replace
			use temp1, clear
			sort test
			merge test using r`i', nokeep
			tab _merge
			keep if _merge == 3
			drop _merge 
			geodist latitude longitude latitude_p longitude_p, generate(distance)
			sort distance
			keep if _n==1
			save r`i', replace
			local i = `i'+1 
		}

		use r1, clear
local i = 2
		while `i'<max_count+1{
		append using r`i'
		erase r`i'.dta
		local i = `i'+1 
		}
		erase r1.dta
*
/* append all */
*
sort group_gid
keep iso3 group_gid latitude_p longitude_p distance port
*
sort group_gid
rename distance    distance_cp12
rename latitude_p  latitude_cp12
rename longitude_p longitude_cp12
rename iso3        iso3_cp12
rename port        cport_a12
label var distance_cp  "distance to closest port, 12 meters draft"
label var latitude_cp  "Latitude closest port, 12 meters draft"
label var longitude_cp "Longitude closest port, 12 meters draft"
label var cport_a      "closest port, 12 meters draft"
sort group_gid
save closest_port_a12, replace
*
erase temp1.dta
erase temp2.dta
*/
*
use "$Output_data\base_reg_afr", clear
*
sort group_gid
merge group_gid using closest_port_a, nokeep
tab _merge
drop _merge
*
sort group_gid
merge group_gid using closest_port_a12, nokeep
tab _merge
drop _merge
*
sort gid year
*
drop lclasspc11- lclasspc230
*
save "$Output_data\base_reg_afr", replace



			** DISTANCE TO RESOURCES **
			****************************
/*
/*seaport data*/
use "$Data\resources\resources_all.dta", clear
g test=1
save temp1, replace
/*conflict data*/
use base_reg_afr, clear
collapse (mean) latitude longitude, by(group_gid)
sort group_gid
gen count=_n
egen max_count=max(count)
g test=1
save temp2, replace 
*
local i = 1
		while `i'<max_count+1{
			use temp2, clear
			keep if count ==`i'
			sort test
			save r`i', replace
			use temp1, clear
			sort test
			merge test using r`i', nokeep
			tab _merge
			keep if _merge == 3
			drop _merge 
			geodist latitude longitude latitude_res longitude_res, generate(distance)
			sort distance
			keep if _n==1
			save r`i', replace
			local i = `i'+1 
		}

		use r1, clear
local i = 2
		while `i'<max_count+1{
		append using r`i'
		erase r`i'.dta
		local i = `i'+1 
		}
		erase r1.dta

*
/* append all */
*
sort group_gid
keep iso3 group_gid latitude_res longitude_res distance
*
sort group_gid
rename distance  distance_res
rename iso3      iso3_res
label var distance_res "distance to nat. resources, all countries"
label var iso3_res     "country, closest nat. resources"
sort group_gid
sort group_gid
save distance_natres, replace
*
erase temp1.dta
erase temp2.dta
*
*/
use "$Output_data\base_reg_afr", clear
*
sort group_gid
merge group_gid using distance_natres, nokeep
tab _merge
drop _merge
*
sort gid year
*
save "$Output_data\base_reg_afr", replace


	    ** MERGE WITH ALL SHOCKS **
		***************************

use "$Output_data\base_reg_afr", replace

rename iso_1 iso3 

/* M3 crops */		
sort gid year
merge gid year using GAEZ_ALL_AFRICA, nokeep
tab  _merge if year>1988 & year<2008
drop _merge
/* GAEZ shock */		
sort gid year
merge gid year using CROPS_M3_ALL_AFRICA, nokeep
tab  _merge if year>1988 & year<2008
drop _merge
/* FAO region */
sort gid 
merge gid using GID_REGION_FAO, nokeep
tab _merge
drop _merge
/* FAO shock */
sort gid year
merge gid year using FAO_PRIO_GRID, nokeep
tab  _merge if year>1988 & year<2008
drop _merge
/* FAO country-year coverage */
sort iso3 year
merge iso3 year using fao_years, nokeep
tab  _merge 
drop _merge
/* FAO cell-year coverage*/
sort gid year 
merge gid year using FAO_missing, nokeep
tab  _merge 
drop _merge
replace missing = 1 if missing > 0 & missing !=.
/* FAO shock, exported products */
sort gid year
merge gid year using FAO_PRIO_GRID_X, nokeep
tab  _merge if year>1988 & year<2008
drop _merge
/* FAO shock, droppping large players */
sort gid year
merge gid year using FAO_PRIO_GRID_MP, nokeep
tab  _merge if year>1988 & year<2008
drop _merge
/* FAO shock, weights<1993 */
sort gid year
merge gid year using FAO_PRIO_GRID_w0, nokeep
tab  _merge if year>1988 & year<2008
drop _merge
/* FAO shock, binary weights */
sort gid year
merge gid year using FAO_PRIO_GRID_wbin, nokeep
tab  _merge if year>1988 & year<2008
drop _merge
/* Exposure to crises */
sort iso3 year
merge iso3 year using exposure_crisis_all, nokeep
tab  _merge
drop _merge
rename exposure_crisis exposure_crisis_c
label var exposure_crisis "Exposure to crisis, main country of cell"
/* Exposure to crises */
sort gid year
merge gid year using exposure_crisis_gid, nokeep
tab  _merge
drop _merge
/* AGOA */
sort iso3 
merge iso3  using share_agoa, nokeep
tab  _merge
drop _merge
*
sort gid year
save "$Output_data\base_reg_afr", replace
*

				** SIPRI AND IRAI DATASETS *
				****************************
				
foreach dataset in constant share{
*
import excel "$Data\SIPRI\sipri_`dataset'.xlsx", sheet("Sheet1") firstrow clear
compress
drop Notes
drop if Country==""
reshape long military_, i(Country) j(year)
rename military_ military
destring military, replace force
keep Country year military
rename Country country
compress
sort country year
merge country using "$Data\SIPRI\countries_names", nokeep
tab _merge
tab country if _merge == 1
drop if _merge == 1
drop _merge
sort iso3 year
save "$Data\SIPRI\sipri_`dataset'", replace
*
/* Merge with SIPRI */
use "$Output_data\base_reg_afr", clear
sort iso3 year
merge iso3 year using "$Data\SIPRI\sipri_`dataset'", nokeep
tab _merge
drop _merge
rename military military_`dataset'
label var military_`dataset' "Country's military spending, `dataset'" 
*
sort gid year
save "$Output_data\base_reg_afr", replace
}
/* Revenue mobilization (IRAI) */
use "$Output_data\base_reg_afr", clear
sort iso3 year
merge iso3 year using "$Data\State_capacity_macro\irai.dta", nokeep
tab _merge
drop _merge
sort gid year
tsset
save "$Output_data\base_reg_afr", replace

	    ** FINITION	 **
		***************

use "$Output_data\base_reg_afr", clear
*
replace fataliti      = 0 if nb_event == 0 & year > 1996 & year < 2011
replace conflict_a1   = 0 if conflict_a1 == . & year < 2006
replace nbconflict_a1 = 0 if nbconflict_a1 == . & year < 2006
replace nb_event_ucdp = 0 if nb_event_ucdp == . & year > 1988 & year < 2011
replace fataliti_ucdp = 0 if fataliti_ucdp == . & year > 1988 & year < 2011
g conflict_ucdp       = (nb_event_ucdp > 0 )
replace conflict_ucdp = . if year < 1988 | year > 2010
*
/* rename conflict data */
/* c1 = Acled 1980-2005 */
/* c2 = Acled 1997-2010 */
/* c3 = UCDP  1989-2010 */
/* 3 variables: conflict, onset and nb_conflict */
*
rename conflict_a1   conflict_c1
rename nbconflict_a1 nbconflict_c1
rename acled         conflict_c2
rename nb_event    	 nbconflict_c2
rename conflict_ucdp conflict_c3
rename nb_event_ucdp nbconflict_c3

foreach var in conflict_c1 conflict_c2 conflict_c3 nbconflict_c1 nbconflict_c2 nbconflict_c3{
bys iso3: egen sum_`var' = sum(`var')
replace `var' = . if sum_`var' == 0
drop sum_`var'
}
replace conflict_c1 = . if year>2005
replace conflict_c2 = . if year<1997 
replace conflict_c3 = . if year<1989

tsset 
sort group_gid year
foreach conflict in c1 c2 c3{
g       onset_`conflict' = (conflict_`conflict'==1 & l.conflict_`conflict'==0)
replace onset_`conflict' = . if conflict_`conflict'==1 & l.conflict_`conflict'==1
replace onset_`conflict' = . if conflict_`conflict' ==.
label var onset_`conflict' "Onset, `conflict'"
}

foreach conflict in c1 c2 c3{
g       ending_`conflict' = (conflict_`conflict'==0 & l.conflict_`conflict'==1)
replace ending_`conflict' = . if conflict_`conflict'==0 & l.conflict_`conflict'==0
replace ending_`conflict' = . if conflict_`conflict' ==.
label var ending_`conflict' "Ending, `conflict'"
}

*
/* distances */
g ldist12     = log(distance_cp12)
g ldist       = log(distance_cp)
g ldist_cap   = log(capdist)
g ldist_bord  = log(bdist1)
g ldist_res   = log(distance_res)
label var ldist      "log(distance to closest port)"
label var ldist12    "log(distance to closest port, 12 meters)"
label var ldist_cap  "log(distance to capital)"
label var ldist_bord "log(distance to border)"
label var ldist_res  "log(distance to closest nat. resources)"
*
/* shocks */
g lshock_crop    = log(shock_crop)
g lshock_fao     = log(shock_fao)
g lshock_fao_x   = log(shock_fao_x)
g lshock_fao_mp  = log(shock_fao_mp)
g lshock_fao_w0  = log(shock_fao_w0)
g lshock_fao_wbin = log(shock_fao_wbin)
label var lshock_fao  "ln agr. com. shock"
label var lshock_crop "ln crop shock"
*
/* interaction*/
g lshock_fao_dist           = ldist*lshock_fao
g lshock_fao_dist_cap       = ldist_cap*lshock_fao
g lshock_fao_dist_bord      = ldist_bord*lshock_fao
g lshock_fao_dist_res       = ldist_res*lshock_fao
g lshock_fao_x_dist         = ldist*lshock_fao_x
g lshock_fao_x_dist_cap     = ldist_cap*lshock_fao_x
g lshock_fao_x_dist_bord    = ldist_bord*lshock_fao_x
g lshock_fao_x_dist_res     = ldist_res*lshock_fao_x
g lshock_fao_mp_dist        = ldist*lshock_fao_mp
g lshock_fao_mp_dist_cap    = ldist_cap*lshock_fao_mp
g lshock_fao_mp_dist_bord   = ldist_bord*lshock_fao_mp
g lshock_fao_mp_dist_res    = ldist_res*lshock_fao_mp
g lshock_fao_wbin_dist      = ldist*lshock_fao_wbin
g lshock_fao_wbin_dist_cap  = ldist_cap*lshock_fao_wbin
g lshock_fao_wbin_dist_bord = ldist_bord*lshock_fao_wbin
g lshock_fao_wbin_dist_res  = ldist_res*lshock_fao_wbin
g lshock_fao_w0_dist        = ldist*lshock_fao_w0
g lshock_fao_w0_dist_cap    = ldist_cap*lshock_fao_w0
g lshock_fao_w0_dist_bord   = ldist_bord*lshock_fao_w0
g lshock_fao_w0_dist_res    = ldist_res*lshock_fao_w0
g lshock_crop_dist 	        = ldist*lshock_crop
g lshock_crop_dist_cap      = ldist_cap*lshock_crop
g lshock_crop_dist_bord     = ldist_bord*lshock_crop
g lshock_crop_dist_res      = ldist_res*lshock_crop
g crisis_ldist              = ldist*exposure_crisis 
g crisis_ldist_cap          = ldist_cap*exposure_crisis 
g crisis_ldist_bord         = ldist_bord*exposure_crisis 
g crisis_ldist_res          = ldist_res*exposure_crisis 
* 
*
g lshock_fao_dist12         = ldist12*lshock_fao
g lshock_crop_dist12        = ldist12*lshock_crop
g crisis_ldist12            = ldist12*exposure_crisis 
*
/*idem with ratios*/
foreach dist in distance_cp capdist bdist1 distance_res{
bys iso3: egen max_`dist' = max(`dist')
g `dist'_r = `dist'/max_`dist'
}
g lshock_fao_dist_r           = distance_cp_r*lshock_fao
g lshock_fao_dist_cap_r       = capdist_r*lshock_fao
g lshock_fao_dist_bord_r      = bdist1_r*lshock_fao
g lshock_fao_dist_res_r       = distance_res_r*lshock_fao
g lshock_fao_x_dist_r         = distance_cp_r*lshock_fao_x
g lshock_fao_x_dist_cap_r     = capdist_r*lshock_fao_x
g lshock_fao_x_dist_bord_r    = bdist1_r*lshock_fao_x
g lshock_fao_x_dist_res_r     = distance_res_r*lshock_fao_x
g lshock_fao_mp_dist_r        = distance_cp_r*lshock_fao_mp
g lshock_fao_mp_dist_cap_r    = capdist_r*lshock_fao_mp
g lshock_fao_mp_dist_bord_r   = bdist1_r*lshock_fao_mp
g lshock_fao_mp_dist_res_r    = distance_res_r*lshock_fao_mp
g lshock_fao_wbin_dist_r      = distance_cp_r*lshock_fao_wbin
g lshock_fao_wbin_dist_cap_r  = capdist_r*lshock_fao_wbin
g lshock_fao_wbin_dist_bord_r = bdist1_r*lshock_fao_wbin
g lshock_fao_wbin_dist_res_r  = distance_res_r*lshock_fao_wbin
g lshock_fao_w0_dist_r        = distance_cp_r*lshock_fao_w0
g lshock_fao_w0_dist_cap_r    = capdist_r*lshock_fao_w0
g lshock_fao_w0_dist_bord_r   = bdist1_r*lshock_fao_w0
g lshock_fao_w0_dist_res_r    = distance_res_r*lshock_fao_w0
g lshock_crop_dist_r 	      = distance_cp_r*lshock_crop
g lshock_crop_dist_cap_r      = capdist_r*lshock_crop
g lshock_crop_dist_bord_r     = bdist1_r*lshock_crop
g lshock_crop_dist_res_r      = distance_res_r*lshock_crop
g crisis_ldist_r              = distance_cp_r*exposure_crisis 
g crisis_ldist_cap_r          = capdist_r*exposure_crisis 
g crisis_ldist_bord_r         = bdist1_r*exposure_crisis 
g crisis_ldist_res_r          = distance_res_r*exposure_crisis 
*
rename fataliti 	fataliti_c2
rename fataliti_ucdp fataliti_c3
*
label var fataliti_c3				  "# fatalities, UCDP-GED" 
label var iso3 						  "ISO3 code country"
label var region_fao				  "Region FAO (SALB-ADM1)"
label var shock_fao     			  "Agr. commodity shock (FAO-Agromaps)"
label var shock_fao_x     			  "Agr. commodity shock (FAO-Agromaps, exported prod. only)"
label var shock_fao_mp     			  "Agr. commodity shock (FAO-Agromaps, dropping large players) "
label var shock_fao_w0     			  "Agr. commodity shock (FAO-Agromaps, weights before 1993)"
label var shock_fao_wbin   			  "Agr. commodity shock (FAO-Agromaps, binary weights)"
label var exposure_crisis			  "Exposure to crises"
label var share_agoa				  "Share of trade affected by AGOA"
label var year_agoa					  "Year AGOA granted"
label var crisis_ldist    	 	      "Exp. to crises  $\times$ ln dist. to closest port"
label var crisis_ldist12  	 	      "Exp. to crises  $\times$ ln dist. to closest port (12 meters)"
label var crisis_ldist_cap 	 	      "Exp. to crises  $\times$ ln dist. to capital"
label var crisis_ldist_bord 	      "Exp. to crises  $\times$ ln dist. to border"
label var crisis_ldist_res 	          "Exp. to crises  $\times$ ln dist. to nat. res."
label var crisis_ldist_r   	 	      "Exp. to crises  $\times$ rel. dist. to closest port"
label var crisis_ldist_cap_r 	 	  "Exp. to crises  $\times$ rel. dist. to capital"
label var crisis_ldist_bord_r 	      "Exp. to crises  $\times$ rel. dist. to border"
label var crisis_ldist_res_r 	      "Exp. to crises  $\times$ rel. dist. to nat. res."
label var lshock_fao_dist    	      "ln agr. shock $\times$ ln dist. to closest port"
label var lshock_fao_dist12  	      "ln agr. shock $\times$ ln dist. to closest port (12 meters)"
label var lshock_fao_dist_cap         "ln agr. shock $\times$ ln dist. to capital"
label var lshock_fao_dist_bord        "ln agr. shock $\times$ ln dist. to border"
label var lshock_fao_dist_res         "ln agr. shock $\times$ ln dist. to nat. res."
label var lshock_fao_dist_r    	      "ln agr. shock $\times$ rel. dist. to closest port"
label var lshock_fao_dist_cap_r       "ln agr. shock $\times$ rel. dist. to capital"
label var lshock_fao_dist_bord_r      "ln agr. shock $\times$ rel. dist. to border"
label var lshock_fao_dist_res_r       "ln agr. shock $\times$ rel. dist. to nat. res."
label var lshock_fao_x_dist    	      "ln agr. shock (X) $\times$ ln dist. to closest port"
label var lshock_fao_x_dist_cap       "ln agr. shock (X) $\times$ ln dist. to capital"
label var lshock_fao_x_dist_bord      "ln agr. shock (X) $\times$ ln dist. to border"
label var lshock_fao_x_dist_res       "ln agr. shock (X) $\times$ ln dist. to nat. res."
label var lshock_fao_x_dist_r    	  "ln agr. shock (X) $\times$ rel. dist. to closest port"
label var lshock_fao_x_dist_cap_r     "ln agr. shock (X) $\times$ rel. dist. to capital"
label var lshock_fao_x_dist_bord_r    "ln agr. shock (X) $\times$ rel. dist. to border"
label var lshock_fao_x_dist_res_r     "ln agr. shock (X) $\times$ rel. dist. to nat. res."
label var lshock_fao_mp_dist    	  "ln agr. shock (MP) $\times$ ln dist. to closest port"
label var lshock_fao_mp_dist_cap      "ln agr. shock (MP) $\times$ ln dist. to capital"
label var lshock_fao_mp_dist_bord     "ln agr. shock (MP) $\times$ ln dist. to border"
label var lshock_fao_mp_dist_res      "ln agr. shock (MP) $\times$ ln dist. to nat. res."
label var lshock_fao_mp_dist_r    	  "ln agr. shock (MP) $\times$ rel. dist. to closest port"
label var lshock_fao_mp_dist_cap_r    "ln agr. shock (MP) $\times$ rel. dist. to capital"
label var lshock_fao_mp_dist_bord_r   "ln agr. shock (MP) $\times$ rel. dist. to border"
label var lshock_fao_mp_dist_res_r    "ln agr. shock (MP) $\times$ rel. dist. to nat. res."
label var lshock_fao_wbin_dist    	  "ln agr. shock (wbin) $\times$ ln dist. to closest port"
label var lshock_fao_wbin_dist_cap    "ln agr. shock (wbin) $\times$ ln dist. to capital"
label var lshock_fao_wbin_dist_bord   "ln agr. shock (wbin) $\times$ ln dist. to border"
label var lshock_fao_wbin_dist_res    "ln agr. shock (wbin) $\times$ ln dist. to nat. res."
label var lshock_fao_wbin_dist_r      "ln agr. shock (wbin) $\times$ rel. dist. to closest port"
label var lshock_fao_wbin_dist_cap_r  "ln agr. shock (wbin) $\times$ rel. dist. to capital"
label var lshock_fao_wbin_dist_bord_r "ln agr. shock (wbin) $\times$ rel. dist. to border"
label var lshock_fao_wbin_dist_res_r  "ln agr. shock (wbin) $\times$ rel. dist. to nat. res."
label var lshock_fao_w0_dist    	  "ln agr. shock (w0) $\times$ ln dist. to closest port"
label var lshock_fao_w0_dist_cap      "ln agr. shock (w0) $\times$ ln dist. to capital"
label var lshock_fao_w0_dist_bord     "ln agr. shock (w0) $\times$ ln dist. to border"
label var lshock_fao_w0_dist_res      "ln agr. shock (w0) $\times$ ln dist. to nat. res."
label var lshock_fao_w0_dist_r        "ln agr. shock (w0) $\times$ rel. dist. to closest port"
label var lshock_fao_w0_dist_cap_r    "ln agr. shock (w0) $\times$ rel. dist. to capital"
label var lshock_fao_w0_dist_bord_r   "ln agr. shock (w0) $\times$ rel. dist. to border"
label var lshock_fao_w0_dist_res_r    "ln agr. shock (w0) $\times$ rel. dist. to nat. res."
label var lshock_crop_dist   	      "ln crop shock $\times$ ln dist. to closest port"
label var lshock_crop_dist12 	      "ln crop shock $\times$ ln dist. to closest port (12 meters)"
label var lshock_crop_dist_cap        "ln crop shock $\times$ ln dist. to capital"
label var lshock_crop_dist_bord       "ln crop shock $\times$ ln dist. to border"
label var lshock_crop_dist_res        "ln crop shock $\times$ ln dist. to nat. res."
label var lshock_crop_dist_r   	      "ln crop shock $\times$ rel. dist. to closest port"
label var lshock_crop_dist_cap_r      "ln crop shock $\times$ rel. dist. to capital"
label var lshock_crop_dist_bord_r     "ln crop shock $\times$ rel. dist. to border"
label var lshock_crop_dist_res_r      "ln crop shock $\times$ rel. dist. to nat. res."
*
/* shock GAEZ */
foreach var of varlist shock_gaez40 {
gen l`var'        = log(`var')
gen l`var'_dist   = l`var' * ldist
gen l`var'_dist_r = l`var' * distance_cp_r
label var l`var'        "log(`var')"
label var l`var'_dist   "log(`var') $\times$ ln dist. port"
label var l`var'_dist_r "log(`var') $\times$ rel. dist. port"
}
/* conflict macro */
sort iso3 year 
merge iso3 year using "$Data\conflict_iso3\conflict_all", nokeep
tab _merge
drop _merge
*
/* Distance to NYC */
g latitude_nyc  = 40.714623
g longitude_nyc = -74.006605 
geodist latitude_cp longitude_cp latitude_nyc longitude_nyc, generate(distance_to_nyc) 
*
bys iso3: egen tmp      = mean(distance_to_nyc)
replace distance_to_nyc = tmp if distance_to_nyc == .
g ldist_us              = log(distance_to_nyc)
drop tmp 
*
/* AGOA shocks */
g agoa                = (year >= year_agoa) 
egen ldist_us_m       = mean(ldist_us)
g agoa_ldist_us       = agoa*(ldist_us-ldist_us_m)
egen share_agoa_all_m = mean(share_agoa)
g agoa_share_all      = agoa*(share_agoa-share_agoa_all_m)
g agoa_ldist          = agoa*ldist
g agoa_ldist_r        = agoa*distance_cp_r
drop share_agoa_all_m ldist_us_m
*
label var agoa 				 "AGOA dummy"
label var agoa_share_all 	 "AGOA dummy $\times$ Exposure"
label var ldist_us 	 		 "ln distance to US"
label var agoa_ldist_us 	 "AGOA $\times$ ln distance to US"
label var agoa_ldist 		 "AGOA $\times$ ln distance to closest port"
label var latitude_nyc       "Latitude NYC"
label var longitude_nyc      "Longitude NYC"
label var distance_to_nyc    "Distance to NYC"
label var ldist_us           "ln distance to US"
*
/* FAO Country-level */
sort iso3 year 
merge iso3 year using "$Output_data\FAO_country", nokeep
drop _merge 
g lshock_fao_c = log(shock_fao_c)
label var lshock_fao_c "FAO agr. shock, country-level"
*
*for clusters
egen country_year = group(iso3 year)
egen temp0   = group(region iso3)
bys gid : egen fao_region = mean(temp0)
drop temp0
*
/* country names */
sort iso3
merge iso3 using "$Data\country_names", nokeep
tab _merge
drop _merge
save "$Output_data\base_reg_afr", replace
*
/* Fearon conflict types */
use "$Data\fearon2003\fearon2003", clear
sort ccode
drop country cname
merge ccode using "$Data\fearon2003\ccodes", nokeep
tab  _merge
drop _merge
rename statenme country_name
keep country_name year wars war aim ethwar
sort country_name year
save "$Output_data\temp0", replace
*
use "$Output_data\base_reg_afr", clear
sort  country_name year
merge country_name year using "$Output_data\temp0", nokeep
tab _merge if year < 2000
tab iso3 if _merge == 1 & year < 2000
drop _merge
sort gid year
save "$Output_data\base_reg_afr", replace
*
/* price series: sorghum, maize, coffee */
use "$Output_data\base_reg_afr", clear
sort gid year
merge gid year using "$Data\Price_commodities\all_price", nokeep
tab _merge
drop _merge
label var suitable40_maize 		"Suitable cell, maize"
label var suitable40_sorghum  	"Suitable cell, sorghum"
label var suitable40_coffee 	"Suitable cell, coffee"
label var price_sorghum 		"World price, sorghum"
label var price_coffee 			"World price, coffee"
label var price_maize			"World price, maize"
*
/* year dummies*/
tab year, gen(yeard)
tab iso3, gen(iso3d)
*
tsset
sort gid year
*
/* Missing labels */
label var quality 			"1 if high quality G-econ data"
label var iso3_cp 			"Iso code closest port"
label var latitude_res 		"Latitude closest resource field"
label var longitude_res 	"Longitude closest resource field"
label var region_fao 		"Code region FAO"
label var conflict_c3 		"Conflict incidence, UCDP-GED"
label var lshock_fao_x 		"ln agr. shock (exported prod. only)"
label var lshock_fao_mp 	"ln agr. shock (dropping large players)"
label var lshock_fao_w0 	"ln agr. shock (t0 weights)"
label var lshock_fao_wbin 	"ln agr. shock (binary weights)"
label var max_distance_cp 	"Maximum distance to closest port by country"
label var distance_cp_r 	"Distance to closest port (ratio)"
label var iso3_cp12 		"Country code closest port (deep water)"
label var max_capdist  		"Maximum distance to capital city by country"
label var capdist_r  		"Distance to capital city (ratio)"
label var max_bdist1  		"Maximum distance to border by country"
label var bdist1_r   		"Distance to international border (ratio)"
label var max_distance_res  "Maximum distance to nat. res. by country"
label var distance_res_r    "Distance to natural resource field (ratio)"
label var onsetprioP 		"Onset (country level, PRIO)"
label var agoa_ldist_r 		"AGOA $\times$ distance to closest port (ratio)"
label var fao_region 		"Main region FAO (for clustering)"
label var shock_fao_c   	"Agr. commodity shock (FAO-Agromaps, country level)"
label var country_name 		"Country name"
*
save "$Output_data\base_reg_afr", replace
*
drop objectid shape_leng shape_area xcoord ycoord cow onsetcow onsetcowP LFincidence LFonset LFonsetP ongoing onsetprio ///
prio_global intensity_prio nb_event1 nb_event2 nb_event3 nb_event4 nb_event5 conf civconf confold civcfold onset conflag1 conflag3 conflag5 cfoldlag1 cfoldlag3 cfoldlag5
*
order gid group_gid  longitude latitude  iso3 region_fao year conflict_c3 conflict_c1 conflict_c2 nbconflict_c3 nbconflict_c1 nbconflict_c2  		///
fataliti_c3 fataliti_c2 dyad_c3 dyad_c1 dyad_c2 onset_c3 onset_c1 onset_c2 ending_c3 ending_c1 ending_c2 iso3_cp cport_a latitude_cp longitude_cp  	///
distance_cp iso3_cp12 cport_a12 latitude_cp12 longitude_cp12 distance_cp12 latitude_res longitude_res iso3_res distance_res shock_fao shock_fao_x 	///
shock_fao_mp shock_fao_w0 shock_fao_wbin shock_fao_c shock_crop shock_gaez40 exposure_crisis_c exposure_crisis share_agoa year_agoa country_name	///
military_share irai_erm 
*
/* keep pre-crisis period */
drop if year>2006
/* keep Sub-Saharan Africa */
drop if iso3 == "MAR" | iso3 == "EGY" | iso3 =="DZA" | iso3 =="LBY" | iso3 =="TUN" | iso3 == ""
*
save "$Output_data\base_reg_afr", replace
save "$Output_data\data_BC_Restat2014", replace
*
/*other countries*/
use "$Output_data\Append_No_Africa", clear
keep iso3 year exposure_crisis gid region_fao shock_fao nb_event acled longitude latitude latitude_p longitude_p ///
latitude_cp longitude_cp distance_cp ldist lshock_fao lshock_fao_dist crisis_ldist trend*
*
label var year 			"Year"
label var region_fao 	"region_fao"
label var longitude  	"Longitude cell's centroid"
label var latitude   	"Longitude cell's centroid"
label var acled 		"Conflict Incidence, ACLED"
label var latitude_p 	"Latitude closest port"
label var longitude_p 	"Longitude closest port"
label var trend 		"Country specific trend"
sort gid year
*
save  "$Output_data\To_Append_No_Africa", replace


*--------------------------------------*
*--------------------------------------*

/* Clean folder */ 
erase temp0.dta
erase temp1.dta
erase acled_1980_2005_coord.dta
erase acled_1980_2005_grid.dta
erase base_gid_year.dta
erase conflict_coords.dta
erase priogrid_v1_01.dta
*erase closest_port_a.dta
*erase distance_natres.dta
