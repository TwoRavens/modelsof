/* Spatial data on locational fundamentals, to be linked to the coordinates of ancient cities.
 To access detailed information about data sources and related documentation/ReadMe files, 
 see the particular folders under /GEOdata/ from which each dataset is imported. */
clear
cd "/Users/ke.3747/Dropbox/Research/BCH_AssyrianTrade_local/BCCH_replication_package/figures_tables"
capture mkdir "temp_files"
/***************/
// Elevation data
/***************/
use "GEOdata/fao_gaez_elevation/elevation_coordinates.dta"
drop if _X < 29 | _X > 44 // Restrict to the relevant part of Turkey
drop if _Y < 35 | _Y > 42
duplicates drop _ID _X _Y,force 
gen numcorner=1
collapse (sum) numcorner,by(_ID)
drop if numcorner>5 // if a polygon is not a square, drop it. Important for how we calculate ruggedness below.
drop numcorner      // When inspected in GIS software, these several polyongs that are dropped correspond to lakes anyway.

merge 1:m _ID using "GEOdata/fao_gaez_elevation/elevation_coordinates.dta"
keep if _merge==3
drop _merge
duplicates drop _ID _X _Y,force 
drop if _X==.
sort _ID _X _Y

collapse (mean) _X _Y, by(_ID) // find the centroids of square polygons
merge 1:1 _ID using "GEOdata/fao_gaez_elevation/elevation_data"
keep if _merge==3
drop _merge _ID
rename _X   long_x_elevation
rename _Y   lat_y_elevation

save "temp_files/temp_elevation.dta",replace
clear
/***********************/
// Crop suitability data
/***********************/
/*
// The following command already generated centroids for the polygons:
**shp2dta using fao_gaez_cropsuit_lowinput_rainfed_cereals, database(fao_gaez_cropsuit_lowinput_rainfed_cereals) coordinates(fao_gaez_cropsuit_lowinput_rainfed_cereals_coord) genid(_ID) gencentroids(centroids)
use "data/GEOdata/fao_gaez_cropsuit_lowinput_rainfed_cereals/fao_gaez_cropsuit_lowinput_rainfed_cereals.dta", clear
// One can plot this in GIS software by importing the file below as delimited text layer (in QGIS)
export delimited using "/Users/ke.3747/Desktop/cropdata", replace
// The grid is pretty uneven, the polygons are not 10km x 10km squares as the elevation data. So using the centroids is not useful to 
// find crop suitability around cities. So, we use the orderly grid points from the elevation file, placed in the 
// crop polygons, which will make it possible to take average crop suitability within a 30 km radius of cities.
*/

use "temp_files/temp_elevation"
rename lat_y_elevation lat_y_crop
rename long_x_elevation long_x_crop

geoinpoly lat_y_crop long_x_crop  using "GEOdata/fao_gaez_cropsuit_lowinput_rainfed_cereals/fao_gaez_cropsuit_lowinput_rainfed_cereals_coord.dta" // grid points in crop polygons

drop if _ID==. // those that don't match are on the coastal edges and Cyprus.
drop elevation

merge m:1 _ID using "GEOdata/fao_gaez_cropsuit_lowinput_rainfed_cereals/fao_gaez_cropsuit_lowinput_rainfed_cereals.dta", keepusing(cropsuit)
keep if _merge==3
drop _merge _ID

drop if cropsuit==9
tab cropsuit
replace cropsuit = (100+85)/2  if cropsuit==1 // take mean of the range from the legend of cropsuit. 1 is the best, with >85, very high suitability
replace cropsuit = (70+85)/2 if cropsuit==2
replace cropsuit = (55+70)/2 if cropsuit==3
replace cropsuit = (40+55)/2 if cropsuit==4
replace cropsuit = (25+40)/2 if cropsuit==5
replace cropsuit = (10+25)/2 if cropsuit==6
replace cropsuit = (10)/2 if cropsuit==7
replace cropsuit = .    if cropsuit==8

save "temp_files/temp_crops.dta",replace
clear
/**********************/
// Modern minerals data
/**********************/
import delimited "GEOdata/minerals/ofr20051294/deposit.csv", encoding(ISO-8859-1) // all minerals
drop citation metallic model_name model_code type_detail state
save temp.dta,replace
clear
import delimited "GEOdata/minerals/ofr20051294/commodity.csv", encoding(ISO-8859-1)
rename value symbol
merge m:1 gid using temp
drop _merge gid dep_name // dep_name includes the city name, if one wants to check in the map, but since coordinates are provided, this is not needed
erase temp.dta

keep if country=="Turkey" | country=="Syria" | country=="Iraq"
keep if symbol=="Cu" | symbol=="Cr" | symbol=="Au" | symbol=="Ag" | symbol=="Zn" | symbol=="Al" | symbol=="Fe" | symbol=="sodium carbonate"
replace commodity = "Copper" if symbol=="Cu"
replace commodity = "Gold" if symbol=="Au"
replace commodity = "Silver" if symbol=="Ag"
replace commodity = "Chrome" if symbol=="Cr"
replace commodity = "Zinc" if symbol=="Zn"
replace commodity = "Iron" if symbol=="Fe"
replace commodity = "Aluminum" if symbol=="Al"
drop dep_type // perhaps some types are more likely to be known in the past priort to modern technology
save temp.dta

clear
import delimited "GEOdata/minerals/sir20105090z/pcu_deps_pros.csv", encoding(ISO-8859-1) // more detailed information about copper deposits
drop  objectid gmrap_id coded_id tract_name latitude // correct variable names, they shift while importing, inspect the file
rename longitude latitude
rename dep_type longitude
drop dev_status comm_major tonnage_mt dep_subtype age* includes name* sitestatus 
rename country sitestatus
rename state_prov country
rename comm_minor comm_major
rename comm_trace comm_minor
rename ref_list dev_status

keep if country=="Turkey" | country=="Syria" | country=="Iraq"
order sitestatus dev_status
keep sitestatus dev_status country latitude longitude comm_major

split comm_major, p(",")
drop comm_major

gen id=_n
reshape long comm_major, i(id) j(var1)
drop var1 id
rename comm_major symbol
drop if symbol=="" 
gen status=""
replace status="prospect" if dev_status=="Prospect" & sitestatus=="prospect"
replace status="prospect" if dev_status=="Unknown" & sitestatus=="prospect"
replace status="prospect" if dev_status=="Occurrence" & sitestatus=="prospect"
replace status="actual" if sitestatus=="deposit"
replace status="actual" if dev_status=="Past Producer" | dev_status=="Producer"
drop dev_status sitestatus
replace symbol=trim(symbol)
gen commodity=""
replace commodity="Copper" if symbol=="Cu"
replace commodity = "Gold" if symbol=="Au"
replace commodity = "Iron" if symbol=="Fe"
replace commodity = "Molybdenum" if symbol=="Mo"
replace commodity = "Antimony" if symbol=="Sb"
replace commodity = "Tungsten" if symbol=="W"

append using temp
format commodity %10s
format symbol %2s

replace status="actual" if status=="" // the first dataset above contains all existing copper deposits
erase temp.dta

keep if commodity == "Copper" | commodity == "Gold" | commodity == "Silver" 
drop symbol
drop country // Only minerals in Turkey remain so far
order longitude latitude commodity

rename longitude long_x_mineral
rename latitude lat_y_mineral

save "temp_files/temp_minerals_modern.dta",replace
clear
/**********************/
// Ancient minerals data
/**********************/
use "GEOdata/ancient_mineral_deposits/ancientminedata"
keep metal evidenceformining1 long_x lat_y locality

rename evidenceformining1 status
replace status = "Not preH" if status!="preH"

// In Massa's thesis, tin in Kestel is missing, insert that (
fillin metal locality
replace _fillin = 0 if locality=="Kestel" & metal == "Tin"
drop if _fillin == 1
drop _fillin
sort locality metal 
replace lat_y = lat_y[_n-1] if  lat_y==.  
replace long_x = long_x[_n-1] if long_x==.
replace status = status[_n-1] if status==""

rename long_x long_x_mineralancient
rename lat_y lat_y_mineralancient
rename metal commodity

save "temp_files/temp_minerals_ancient.dta",replace
clear
/***************/
// Rivers data
/***************/
use "GEOdata/rivers/ne_10m_rivers_europe_coord.dta"
drop if _X < 29 | _X > 44
drop if _Y < 35 | _Y > 42
merge m:1 _ID using "GEOdata/rivers/ne_10m_rivers_europe.dta", keepusing(name)
keep if _merge==3
drop _merge
rename name rivername
drop _ID
save temp.dta,replace

clear
use "GEOdata/rivers/ne_10m_rivers_lake_centerlines_coord.dta"
drop if _X < 29 | _X > 44  // Restrict to the relevant part of Turkey
drop if _Y < 35 | _Y > 42
merge m:1 _ID using "GEOdata/rivers/ne_10m_rivers_lake_centerlines.dta", keepusing(name)
keep if _merge==3
drop _merge
rename name rivername
drop _ID

append using temp
erase temp.dta

rename _X long_x_river
rename _Y lat_y_river 

save "temp_files/temp_rivers.dta",replace
clear
/******************/
// River crossings 
/******************/
import excel "GEOdata/data_for_roadknots/crossing_coord.xlsx", sheet("Sheet2") firstrow
rename crossing_X long_x_rivcrossing
rename crossing_Y lat_y_rivcrossing

save "temp_files/temp_rivercrossings.dta",replace
clear
/******************/
// Night lights
/******************/
use "GEOdata/nightlights/turkey_lights.dta"
drop if x < 29 | x > 44 // Restrict to the relevant part of Turkey
drop if y < 35 | y > 42

rename x long_x_lights
rename y lat_y_lights

save "temp_files/temp_lights.dta",replace
clear
/*************************************************************************/
// Natural road scores (simulated road scores, see folder 'roadknots' for details)
/*************************************************************************/
cd .. 
import delimited "roadknots/Output/roadknots.csv", encoding(ISO-8859-1)
rename elev elev_roadscore
rename lon long_x_roadgrid
rename lat lat_y_roadgrid
cd "figures_tables"

save "temp_files/temp_roadscores.dta",replace
clear
