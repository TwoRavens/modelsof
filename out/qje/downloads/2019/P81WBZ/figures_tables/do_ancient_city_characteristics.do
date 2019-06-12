/* Match ancient locations to geographic fundamentals. Each case is explained below in details. */
clear
capture log close
/***************************************/
/* Import ancient data */
/***************************************/
cd ..
import delimited "estimate/results/ancient/v20170924/twostep/noc/qa01Dropma02Known/main/report_table_twostepse.csv", encoding(ISO-8859-1)
cd "figures_tables"

rename name anccity
/* Estimated coordinates (baseline) vs Barjamovic coordinates (robustness in Appendix table V) */
drop long_x lat_y         // Estimated coordinates for lost cities, known coordinates for others. To run the robustness for Barjamovic locations,
rename varphi_est long_x //  comment out these three lines, together with the related modifications in do_ancientTs.do, do_match_ancient.., and do_main.do
rename lambda_est lat_y // 

save temp_anccity.dta,replace

local radius = 20
/***************************************/
/* Add geographic characteristics */
/***************************************/
qui do "do_geodata.do"  // generates the geo data for elevation, minerals, rivers and minerals. 

/***************************************/
// Elevation
use temp_anccity,clear
cross using "temp_files/temp_elevation.dta"
*vincenty lat_y_elevation long_x_elevation  lat_y long_x, vin(dist_est) inkm 
gen dist_est = sqrt((cos(37.9/180*_pi)*(long_x_elevation-long_x))^2  + (lat_y_elevation-lat_y)^2)
replace dist_est = dist_est*10000/90

keep if dist_est < `radius' 
collapse (mean) elevation, by(anccity)
merge 1:1 anccity using temp_anccity
keep if _merge==3
drop _merge
 
save temp_anccity.dta,replace
/***************************************/
// Crop suitability
cross using "temp_files/temp_crops"
*vincenty lat_y_crop long_x_crop  lat_y long_x, vin(dist_est) inkm
gen dist_est = sqrt((cos(37.9/180*_pi)*(long_x_crop-long_x))^2  + (lat_y_crop-lat_y)^2)
replace dist_est = dist_est*10000/90

keep if dist_est < `radius' 
collapse (mean) cropsuit, by(anccity)
merge 1:1 anccity using temp_anccity
keep if _merge==3
drop _merge
 
save temp_anccity.dta,replace

/***************************************/
// Modern minerals
cross using "temp_files/temp_minerals_modern"
*vincenty lat_y_mineral long_x_mineral  lat_y long_x, vin(dist_est) inkm
gen dist_est = sqrt((cos(37.9/180*_pi)*(long_x_mineral-long_x))^2  + (lat_y_mineral-lat_y)^2)
replace dist_est = dist_est*10000/90
*keep if dist_est < `radius'  // there may not be a mineral deposit within the radius km!

collapse (min) dist_est, by(anccity commodity)
reshape wide dist_est,i(anccity) j(commodity) string

rename dist_estCopper mindistCopperModern
rename dist_estGold   mindistGoldModern
rename dist_estSilver mindistSilverModern

merge 1:1 anccity using temp_anccity
keep if _merge==3
drop _merge

save temp_anccity.dta,replace
/***************************************/
// Ancient minerals
cross using "temp_files/temp_minerals_ancient"
*vincenty lat_y_mineralancient long_x_mineralancient lat_y long_x, vin(dist_est) inkm
gen dist_est = sqrt((cos(37.9/180*_pi)*(long_x_mineralancient-long_x))^2  + (lat_y_mineralancient-lat_y)^2)
replace dist_est = dist_est*10000/90

keep if status=="preH" // Keep only prehistoric deposits

replace commodity = "Tin" if locality=="Kestel" // FLAG: Massa's table is missing tin in Kestel.

collapse (min) dist_est, by(anccity commodity)

reshape wide dist_est,i(anccity) j(commodity) string
rename dist_estCopper mindistCopperAncient
rename dist_estGold   mindistGoldAncient
rename dist_estTin   mindistTinAncient
rename dist_estSilver   mindistSilverAncient

merge 1:1 anccity using temp_anccity
keep if _merge==3
drop _merge

save temp_anccity.dta,replace
/***************************************/
// Rivers
cross using "temp_files/temp_rivers"
*vincenty lat_y_river long_x_river lat_y long_x, vin(dist_est) inkm
gen dist_est = sqrt((cos(37.9/180*_pi)*(long_x_river-long_x))^2  + (lat_y_river-lat_y)^2)
replace dist_est = dist_est*10000/90

collapse (min) dist_est, by(anccity)
rename dist_est mindistRiver

merge 1:1 anccity using temp_anccity
keep if _merge==3
drop _merge

save temp_anccity.dta,replace
/***************************************/
// River crossing points
cross using "temp_files/temp_rivercrossings"
*vincenty  lat_y_rivcrossing long_x_rivcrossing lat_y long_x, vin(dist_est) inkm
gen dist_est = sqrt((cos(37.9/180*_pi)*(long_x_rivcrossing-long_x))^2  + (lat_y_rivcrossing-lat_y)^2)
replace dist_est = dist_est*10000/90

collapse (min) dist_est, by(anccity)
rename dist_est mindistRcross

merge 1:1 anccity using temp_anccity
keep if _merge==3
drop _merge

save temp_anccity.dta,replace
/***************************************/
// Ruggedness
keep anccity lat_y long_x // Important to drop elevation here, we will bring it back by crossing again with the elevation data.
cross using "temp_files/temp_elevation"
*vincenty lat_y_elevation long_x_elevation lat_y long_x, vin(dist_est) inkm
gen dist_est = sqrt((cos(37.9/180*_pi)*(long_x_elevation -long_x))^2  + (lat_y_elevation -lat_y)^2)
replace dist_est = dist_est*10000/90

sort anccity dist_est

by anccity:gen rank=_n
keep if rank<10 // Terrain ruggedness index: closest grid point, and the 8 grid points in each direction of movement.
gen center_elev = .
replace center_elev = elevation if rank==1
replace center_elev = center_elev[_n-1] if center_elev==.

gen elev2 = (center_elev-elevation)^2
collapse (sum) elev2,by(anccity)
gen TRI = sqrt(elev2)  // Terrain ruggedness index of Riley, DeGloria, Elliot (1999)

merge 1:1 anccity using temp_anccity
drop _merge elev2

save temp_anccity.dta,replace
/***************************************/
// Night lights
keep anccity long_x lat_y
cross using "temp_files/temp_lights"
*vincenty lat_y_lights long_x_lights lat_y long_x, vin(dist_est) inkm
gen dist_est = sqrt((cos(37.9/180*_pi)*(long_x_lights-long_x))^2  + (lat_y_lights-lat_y)^2)
replace dist_est = dist_est*10000/90

keep if dist_est < `radius' 
collapse (sum) lightintensity, by(anccity)
merge 1:1 anccity using temp_anccity
keep if _merge==3
rename lightintensity lights
drop _merge
save temp_anccity.dta,replace

/***************************************/
// Road scores weighted by gravity
cross using "temp_files/temp_roadscores"

*vincenty lat_y_roadgrid long_x_roadgrid  lat_y long_x, vin(distroadgrid) inkm
gen distroadgrid = sqrt((cos(37.9/180*_pi)*(long_x_roadgrid-long_x))^2  + (lat_y_roadgrid-lat_y)^2)
replace distroadgrid = distroadgrid*10000/90

keep if distroadgrid <  `radius' 

gen wcrossings  = dist_gravity_0_400_deep_500

collapse (mean) wcrossings, by(anccity) // these are already point-wise weighted sum, so just find the average road score around the city (which is why < 20 km above)

merge 1:1 anccity using temp_anccity
drop _merge  
save temp_anccity.dta,replace

/***************************************/
// Roman road crossings (based on David French's maps)
cross using "GEOdata/DFrench_roadknots/DavidFrench_road_crossings.dta"
*vincenty  lat_y_dfcrossing long_x_dfcrossing lat_y long_x, vin(distdfcrossings) inkm
gen distdfcrossings = sqrt((cos(37.9/180*_pi)*(long_x_dfcrossing-long_x))^2  + (lat_y_dfcrossing-lat_y)^2)
replace distdfcrossings = distdfcrossings*10000/90

save temp.dta,replace

// first measure: number of crossings and distance to the closest crossing
sort anccity distdfcrossings
collapse (firstnm) numberofsc crossing distdfcrossings,by(anccity)

replace numberofsc = 2 if  distdfcrossings > `radius'  // if the closest crossing is more than 20 km away, assume that just a road passes through this city.
rename numberofsc DFcrossings1
keep anccity DFcrossings1

merge 1:1 anccity using temp_anccity
drop _merge  
save temp_anccity.dta,replace

// second measure: max of road crossings within 20 km
use temp,clear

keep if distdfcrossings < `radius' 
collapse (max) numberofsc, by(anccity)
rename numberofsc DFcrossings2
merge 1:1 anccity using temp_anccity
replace DFcrossings2 = 2 if _merge == 2 // A road goes through every city
drop _merge

save temp_anccity.dta,replace

/***************************************/
drop lat* long* 
erase temp.dta
erase temp_anccity.dta

capture erase "temp_files/temp_crops.dta"
capture erase "temp_files/temp_minerals_ancient.dta"
capture erase "temp_files/temp_minerals_modern.dta"
capture erase "temp_files/temp_rivers.dta"
capture erase "temp_files/temp_rivercrossings.dta"
capture erase "temp_files/temp_elevation.dta"
capture erase "temp_files/temp_lights.dta"
capture erase "temp_files/temp_roadscores.dta"
capture rmdir "temp_files"
