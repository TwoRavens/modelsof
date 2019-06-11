/* Barjamovic-Chaney-Cosar-Hortacsu, June 2017
Construct gridded graph of elevations in Anatolia, middle east and wider geography around
in order to find least cost paths between random nodes and construct road crossing
scores for locations. We drop the desert with no population to avoid drawing nodes,
make lakes inpassable (unless sailing defined and allowed), make rivers inpassable
except for crossings, and may allow sailing across the coast (by dropping elevations < -100
to drop sailing across the sea. The output of this script is an input to the matlab code.
*/

clear

cd "/Users/ke.3747/Desktop/data_for_roadknots/"

// Grid points in polygons for the entire map
use "gridpointscoord.dta" // Constructed an even grid with 0.1 degree distances in the ETOPO1 extract ETOPO1-extract.png
rename _ID gridID

geoinpoly _Y _X using elevationpolycoord // elevation data from ETOPO comes as a raster which converted into a vector layer in QGIS with polygons. 
                                         // These polygons are unevenly shaped, though most of them squares. Find the polygongs in which 
										 // the grid points lie...

merge m:1 _ID using elevationpoly.dta  // ...and then get the elevation of these polygons (mean)
keep if _merge == 3
drop _merge _ID
sort gridID
count if elevation == .
summ elevation, det

save grid_with_elevation, replace

// Grid points in lakes
geoinpoly _Y _X using lakes_turkeycoord // grid points in major lakes in Turkey
merge m:1 _ID using lakes_turkey.dta, keepusing(name)
rename name lakename
tab lakename
replace elevation = 99999 if lakename!="" // we put a high friction to the lakes to make them inpassable
drop _merge _ID
sort gridID

save grid_with_elevation, replace

// Grid points in rivers 
/* Buffer polygons rivers_turkey_buffer.shp created from rivers_turkey.shp using 
buffer distance of 0.1 thick enough so as to prevent movement across rivers through 
diagonal points that are not within buffer zones. Inspect the grid vector file overlaid
with the buffer vector file along rivers to make sure that doesn't happen. Otherwise 
fast marching algorithm will cross through those routes but that will be totally due to computing error 
*/
geoinpoly _Y _X using rivers_buffer_1coord, unique inside  // two river line files ne_10m_rivers_europe.shp and ne_10m_rivers_lake_centerlines.shp 
                                                           // from http//www.naturalearthdata.com/download/10m; all major rivers and their tributaries.
														   // In QGIS, we keep Euphrates with Murat tributary, Sakarya with Porsuk tributary, 
														   // Seyhan, Kizilirmak, Yesilirmak with Kelkit tributary. Then create buffer polygons around the 
														   // river lines so that thick enough grid points are contained within these polygons 
														   // which then can be assigned a movement friction (high elevation) below except for crossings.
merge m:1 _ID using rivers_buffer_1.dta, keepusing(name)
rename name rivername1
drop if _merge==2
drop _merge _ID

geoinpoly _Y _X using rivers_buffer_2coord, unique inside 
merge m:1 _ID using rivers_buffer_2.dta, keepusing(name)
rename name rivername2
drop if _merge==2
drop _merge _ID

sort gridID

// Define crossings
// rename intersecting points where tributary Kelkit joins the main river Yesilirmak as Yesilirmak for matching with the crossing data.
gen rivername = ""
replace rivername = rivername1 if rivername1!="" & rivername2==""
replace rivername = rivername2 if rivername2!="" & rivername1==""
replace rivername = rivername1 if rivername1!="" & rivername2!="" & (rivername1==rivername2)
replace rivername = rivername1 if rivername1!="" & rivername2!="" & (rivername1!=rivername2)

replace rivername = "Yesilirmak" if rivername=="Kelkit"
replace rivername = "Firat" if rivername=="Murat"
replace rivername = "Sakarya" if rivername=="Porsuk"
replace rivername = "." if rivername==""
drop rivername1 rivername2
tab rivername
save temp, replace


// Merge with river crossing data
clear
import excel "/Users/ke.3747/Desktop/data_for_roadknots/crossing_coord.xlsx", sheet("Sheet2") firstrow	 // Coordinates of historical crossing points, data from Gojko Barjamovic 

replace rivername = "Yesilirmak" if rivername=="Kelkit"
replace rivername = "Firat" if rivername=="Murat"
replace rivername = "Sakarya" if rivername=="Porsuk"

set obs `=_N+1'
replace rivername = "." if crossing_X==.

// Join grid with crossings, pairwise for every river
joinby rivername using "temp" // Note: merge doesn't work here. we want all possible crossing-river points. If you merge, it randomly matches and 'tab crossing' below varies.
count
sort gridID
erase temp.dta

gen crossing = .
gen tolerance = 0.15 // how many degrees buffer we allow for crossings. has to be wide enough to make sure we get a passage
replace crossing = 1 if rivername!="" & abs(_X-crossing_X) <= tolerance & abs(_Y-crossing_Y) <= tolerance
replace crossing = 0 if rivername!="" & (abs(_X-crossing_X) > tolerance | abs(_Y-crossing_Y) > tolerance)
drop tolerance

*tab crossing // should get higher numbers for crossing = 1 as tolerance increases. Also joinby is important above!

// Define crossings in all upstream and downstream grid points after a certain location 
replace crossing = 1 if rivername=="Seyhan" & _Y < 36.98333333 // anywhere below Adana
replace crossing = 1 if rivername=="Firat" &  _Y > 39 // Clears both north of Firat above Keban and relevant part of upstream Murat;  past Malazgirt
replace crossing = 1 if rivername=="Yesilirmak" &  _X > 36.9 // valid for both Kelkit and main Yesilirmak
replace crossing = 1 if rivername=="Sakarya" &  _X < 30.53333333  & _Y < 39.9 // valid for the Porsuk tributary
replace crossing = 1 if rivername=="Sakarya" & _Y < 39.15 // anywhere above Eskisehir 

// Penalties for rivers 
replace elevation = 99999 if rivername!="." & crossing!=1 // Rivers present a high friction to mobility except for crossing points 

collapse (min) elevation (max) crossing, by(gridID _X _Y rivername lakename) // if a gridID (duplicated through joinby) was assigned a crossing above, 
                                                                   // then its elevation is preserved at its original lower than 99999 values, 
																   // so taking min is a way to collapse these to unique grid points. Those that 
															   // are not crossing points are all 99999 so their collapse min gets this value.


label variable elevation "meters,99999=lake/river"
label variable lakename ""
label variable rivername ""
drop crossing

replace rivername = "" if  rivername == "."
order gridID _X _Y elevation rivername lakename  

/* Figures for inspection */
* scatter _Y _X
/*
twoway (scatter _Y _X if rivername!="",msize(tiny) msymbol(Oh) mcolor(red)) ///
  (scatter _Y _X if rivername!="" & elevation<99999,msize(tiny) legend(off) mcolor(green)) ///
  (scatter _Y _X if lakename!="" & elevation==99999,msize(tiny) legend(off) mcolor(blue))
*/

save grid_with_elevation, replace
