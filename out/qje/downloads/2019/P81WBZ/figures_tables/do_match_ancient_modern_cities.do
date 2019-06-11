/* Match ancient locations, estimated or known, to modern day provinces/town using four methods:
province center town(s) near the ancient city, three methods for that also referred to in the do_main.do
  1) closest town
  2) population sum of all towns within the radius specified below
  3) town with the largest population within the radius specified below
*/

clear
capture log close
capture erase temp_match.dta
/*******************************/
/* Import ancient data */
cd ..
import delimited "estimate/results/ancient/v20170924/twostep/noc/qa01Dropma02Known/main/report_table_twostepse.csv", encoding(ISO-8859-1)
cd "figures_tables"

local radius = 20

rename name anccity

save temp.dta,replace
/*******************/
/* Estimated coordinates (baseline) vs Barjamovic coordinates (robustness in Appendix table V) */
// Estimates (baseline) 
drop long_x lat_y // for unknown cities (validity=0), values in here are Barjamovic conjectures.
rename varphi_est long_x_ancient // estimated coordinates: long_x_ancient, lat_y_ancient
rename lambda_est lat_y_ancient
// Barjamovic (appendix table V, panel A)
*drop varphi_est lambda_est
*rename long_x  long_x_ancient
*rename lat_y lat_y_ancient
/*******************/
order anccity
save temp.dta,replace
/*********************/
// Matching procedures
/*********************/

/* Modern Turkish provinces and provincial centers */
clear
use  "GEOdata/Turkey_district_populations/Turkey_2012_district_populations_coordinates"
rename long_x   long_x_modern
rename lat_y  lat_y_modern
cross using temp

*vincenty lat_y_modern long_x_modern lat_y_ancient long_x_ancient , h(dist) inkm
// if vincenty package not installed, use the latitude corrected Euclidean formula:
gen dist = sqrt((cos(37.9/180*_pi)*(long_x_ancient-long_x_modern))^2  + (lat_y_ancient-lat_y_modern)^2)
replace dist = dist*10000/90
sort anccity dist

save temp.dta,replace

// Method 1
sort anccity dist
collapse (min) dist (firstnm) urbanpop2012 province district,by(anccity)
rename urbanpop2012 modernpop1 // method 1: urban population of closest district town
label variable modernpop1 "Pop of closest town"
rename province province1 
label variable province1 "Province of closest town"
rename district district1
label variable district1 "Closest town"
save temp_method1,replace

// Method 2
use temp,clear
gen nummoderndist=1
keep if dist < `radius'
collapse (sum) urbanpop2012 nummoderndist,by(anccity)
rename urbanpop2012 modernpop2 // method 2: sum of urban populations of all towns within 30 kms
label variable modernpop2 "Pop sum of towns within the set radius"
label variable nummoderndist "# towns within the set radius "
save temp_method2,replace

// Method 3
use temp,clear
keep if dist < `radius'
gsort anccity -urbanpop2012 // since the firstnm command below keeps the first string, this has to be sorted
collapse (max) urbanpop2012 (firstnm) province district,by(anccity)
rename urbanpop2012 modernpop3 // method 3: largest urban populations of all towns within 20 kms
label variable modernpop3 "Pop of largest town within the set radius"
rename province province3
label variable province3 "Province of largest town within the set radius"
rename district district3
label variable district3 "Largest town within the set radius"

merge 1:1 anccity  using temp_method2
drop _merge
merge 1:1 anccity  using temp_method1
drop _merge

order anccity modernpop*

/******************/
capture erase temp.dta
capture erase temp_method1.dta
capture erase temp_method2.dta
