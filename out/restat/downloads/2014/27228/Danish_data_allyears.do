clear all
set mem 100m
set more off

global path "C:\Users\Felix Tintelnot\Dropbox\WindBorder\RestatCGTReplication\Data"

cd "$path\original_files"

insheet using "danish_data_cleaned.csv", comma

egen year_connected = ends(date_grid_connection), punct(/) last 

gen n = 1

drop if x_coordinate == . 
drop if manufacture == "Uoplyst"

/* Distance to border crossings */

gen border_lat1 = 54.80558257
gen border_lat2 = 54.83985
gen border_lat3 = 54.872063
gen border_lat4 = 54.906225
gen border_lat5 = 54.914909

gen border_lng1 = 9.328680038
gen border_lng2 = 9.404297
gen border_lng3 = 9.077797
gen border_lng4 = 8.911972
gen border_lng5 = 8.671646

geodist latitude longitude border_lat1 border_lng1, generate(distance_b1) sphere radius(6370.973279)
geodist latitude longitude border_lat2 border_lng2, generate(distance_b2) sphere radius(6370.973279)
geodist latitude longitude border_lat3 border_lng3, generate(distance_b3) sphere radius(6370.973279)
geodist latitude longitude border_lat4 border_lng4, generate(distance_b4) sphere radius(6370.973279)
geodist latitude longitude border_lat5 border_lng5, generate(distance_b5) sphere radius(6370.973279)

gen distance_border = min(distance_b1,distance_b2,distance_b3,distance_b4,distance_b5)
drop border_lat1 border_lat2 border_lat3 border_lat4 border_lat5 border_lng1 border_lng2 border_lng3 border_lng4 border_lng5 distance_b1 distance_b2 distance_b3 distance_b4 distance_b5

/*
/* Distance to producers */

gen Bonus_lat       = 55.9551
gen Bonus_lng       = 9.12447
gen Enercon_lat  	= 53.4692
gen Enercon_lng	    = 7.46116
gen Fuhrlaender_lat	= 50.704
gen Fuhrlaender_lng	= 8.0811
gen Windworld_lat	= 57.059
gen Windworld_lng	= 9.93439
gen Micon_lat	    = 56.4285
gen Micon_lng	    = 10.0394
gen Nordex_lat	    = 54.0738
gen Nordex_lng	    = 12.1313
gen Nordtank_lat	= 56.3203
gen Nordtank_lng	= 10.7913
gen Suedwind_lat	= 52.5027
gen Suedwind_lng	= 13.4017
gen Tacke_lat	    = 52.3319	
gen Tacke_lng	    = 7.42311
gen Vestas_lat	    = 56.0239
gen Vestas_lng      = 8.38205

																		

foreach name in "Bonus" "Nordtank" "Micon" "Windworld" "Vestas" "Nordex" "Enercon" "Fuhrlaender" "Suedwind" "Tacke"{ 
geodist latitude longitude `name'_lat `name'_lng, generate(distance_`name') sphere radius(6370.973279)
}

drop Bonus_lat	Bonus_lng	Enercon_lat	Enercon_lng	Fuhrlaender_lat	Fuhrlaender_lng	Windworld_lat	Windworld_lng	Micon_lat	Micon_lng	Nordex_lat	Nordex_lng	Nordtank_lat	Nordtank_lng	Suedwind_lat	Suedwind_lng	Tacke_lat	Tacke_lng	Vestas_lat	Vestas_lng

*/


replace hub = . if hub <=1
replace rotor = . if rotor <=1

/*
collapse (sum) n (mean) latitude longitude hub rotor distance_border distance_Bonus distance_Nordtank distance_Micon distance_Vestas distance_Windworld distance_Enercon distance_Tacke distance_Fuhrlaender distance_Nordex distance_Suedwind, by (local_authority year_connected manufacture capacity cadastral_district type)
*/

collapse (sum) n (mean) latitude longitude hub rotor distance_border, by (local_authority year_connected manufacture capacity cadastral_district type)


rename capacity kw
rename manufacture prod
rename year_connected year

gen germany = 0
gen denmark = 1
gen total_mw = kw * n /1000

gen prodc_denmark = 1
replace prodc_denmark = 0 if prod=="Nordex"

replace prod="NEG Micon" if prod=="Neg Micon"
/* drop if type == "HAV" */
destring year, replace

/*
keep if year == 1995 | year == 1996
replace prod = "Fringe" if (prod !="Bonus" & prod !="Nordex" & prod !="Enercon" & prod !="Vestas" & prod !="Wind World" & prod !="Micon"  & prod !="Nordtank" & prod !="Fuhrlaender" & prod !="Suedwind" & prod !="Tacke")

gen bonus = 1 if prod =="Bonus"
replace bonus = 0 if bonus == . 

gen vestas = 1 if prod =="Vestas"
replace vestas = 0 if vestas == . 

gen nordex = 1 if prod =="Nordex"
replace nordex = 0 if nordex == .

gen enercon = 1 if prod =="Enercon"
replace enercon = 0 if enercon == .

gen windworld = 1 if prod =="Wind World"
replace windworld = 0 if windworld == . 

gen micon = 1 if prod =="Micon"
replace micon = 0 if micon == .  

gen nordtank = 1 if prod =="Nordtank"
replace nordtank = 0 if nordtank == . 

gen fuhrlaender = 1 if prod =="Fuhrlaender"
replace fuhrlaender = 0 if fuhrlaender == .

gen suedwind = 1 if prod =="Suedwind"
replace suedwind = 0 if suedwind == .

gen tacke = 1 if prod =="Tacke"
replace tacke = 0 if tacke == .   

gen fringe = 1 if prod =="Fringe"
replace fringe = 0 if fringe == . 

*/


/* Bring in Road Distances

replace longitude = round(longitude,0.0001)
replace latitude  = round(latitude,0.0001)

merge 1:1  longitude latitude n using "$path\additional_files\danish_project_id"
sort longitude latitude n

replace project_id = project_id[_n+1] if missing(project_id) & missing(prod[_n+1])
replace project_id = project_id[_n-1] if missing(project_id) & missing(prod[_n-1])

drop if _merge==2
drop _merge

sort project_id

save "$path\temp_files\danish_data_olddistances", replace
clear all

insheet using "$path\additional_files\dnk_road_distance.csv", names

replace distance_bonus_road     = distance_bonus_road / 1000
replace distance_nordtank_road  = distance_nordtank_road / 1000
replace distance_micon_road     = distance_micon_road / 1000
replace distance_vestas_road    = distance_vestas_road / 1000
replace distance_windworld_road = distance_windworld_road / 1000
replace distance_nordex_road    = distance_nordex_road / 1000
replace distance_enercon_road   = distance_enercon_road / 1000
replace distance_fuhrlaender_road = distance_fuhrlaender_road / 1000
replace distance_suedwind_road  = distance_suedwind_road / 1000
replace distance_tacke_road     = distance_tacke_road / 1000

merge 1:1 project_id using "$path\temp_files\danish_data_olddistances.dta"
erase "$path\temp_files\danish_data_olddistances.dta"
drop _merge


order kw total_mw n fringe bonus nordtank micon vestas windworld nordex enercon fuhrlaender suedwind tacke distance_bonus_road distance_nordtank_road distance_micon_road distance_vestas_road distance_windworld_road distance_nordex_road distance_enercon_road distance_fuhrlaender_road distance_suedwind_road distance_tacke_road distance_border latitude longitude
outsheet kw total_mw n fringe bonus nordtank micon vestas windworld nordex enercon fuhrlaender suedwind tacke distance_bonus_road distance_nordtank_road distance_micon_road distance_vestas_road distance_windworld_road distance_nordex_road distance_enercon_road distance_fuhrlaender_road distance_suedwind_road distance_tacke_road distance_border latitude longitude using "$path\output_files\danish_data_for_matlab_new_road_only", comma replace


order kw total_mw n fringe bonus nordtank micon vestas windworld nordex enercon fuhrlaender suedwind tacke distance_bonus distance_nordtank distance_micon distance_vestas distance_windworld distance_nordex distance_enercon distance_fuhrlaender distance_suedwind distance_tacke distance_border latitude longitude
outsheet kw total_mw n fringe bonus nordtank micon vestas windworld nordex enercon fuhrlaender suedwind tacke distance_bonus distance_nordtank distance_micon distance_vestas distance_windworld distance_nordex distance_enercon distance_fuhrlaender distance_suedwind distance_tacke distance_border latitude longitude using "$path\output_files\danish_data_for_matlab_new", comma replace

*/

drop if type == "HAV" 
drop if year >2005

saveold "$path\output_files\danish_data_allyears", replace





