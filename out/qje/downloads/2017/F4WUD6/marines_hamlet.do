args bw

*********************************
****Hamlet level treatment data
*********************************

*inshet data on distance to boundary
insheet using dist_by_seg.csv, comma clear
foreach N of num 1/3 {
	recode dis_seg`N' (-1=.)
}

*calculate which boundary segment is closest
egen dbnd=rowmin(dis_seg1 dis_seg2 dis_seg3)
drop if dbnd==.

*create boundary segment FE
g seg2=0
replace seg2=1 if (dbnd==dis_seg2 | dbnd==dis_seg3)
keep id dbnd seg2 lat lon
tempfile data
save `data', replace

*merge with usids
use coords, clear
keep id usid
merge 1:1 id using `data'
drop if _merge==1 /*not near boundary*/
drop _merge

*create treatment indicator
tostring usid, g(temp)
g treat=substr(temp, 1, 1)
destring treat, replace
recode treat (2=0)
drop temp

*distance from boundary variable
replace dbnd=dbnd/1000
replace dbnd=-dbnd if treat==0 

*higher order RD polynomials 
g dbnd2=dbnd^2
rename latwgs lat
rename lonwgs lon
g lat2=lat^2
g lon2=lon^2

*interact 1d RD polynomial with treatment
g treat_dbnd=treat*dbnd
g treat2_dbnd=treat*dbnd2

*create a village id
tostring usid, g(temp)
g villageid=substr(temp, 1, 7)
destring villageid, replace
drop temp

save marines_data, replace

*****************************
**Geographic characteristics - hamlet level
*****************************

***elevation
insheet using marines_elev.csv, comma clear
keep id raster
recode raster (-9999=.)
rename raster elev
tempfile data
save `data', replace

*merge with usids
use coords, clear
keep id usid
merge 1:1 id using `data'
drop if _merge==1
drop _merge id
merge 1:1 usid using marines_data
drop if _merge==1
drop _merge

save marines_data, replace

***slope
insheet using marines_slope.csv, comma clear
keep id raster
recode raster (-9999=.)
rename raster slope
tempfile data
save `data', replace

*merge with usids
use coords, clear
keep id usid
merge 1:1 id using `data'
drop if _merge==1
drop _merge id
merge 1:1 usid using marines_data
drop if _merge==1
drop _merge

keep if abs(dbnd)<`bw'

save marines_data, replace

*****************************
**LCA
*****************************
use lca_marines_all6971, clear

tostring usid, g(temp)
g villageid=substr(temp, 1, 7)
destring villageid, replace
merge 1:1 usid villageid using marines_data	
keep if _merge==3 /*_merge=1s are not near the boundary; _merge==2s not in the data this period; a hamlet reorg before the sample period means a lot don't exist*/
drop _merge
save marines_data, replace

*****************************
**SITRA
*****************************

use sitra_all2k, clear

*merge with rest of data
merge 1:1 usid villageid using marines_data
drop if _merge==1
drop _merge

save marines_data, replace

*****************************
**French maps - points 
*****************************
***Factories
insheet using fr_factory_dist.csv, comma clear
tempfile data
save `data', replace

*merge with usids
use coords, clear
keep id usid
merge 1:1 id using `data'
drop if _merge==1
drop _merge id
merge 1:1 usid using marines_data
drop if _merge==1 /*never in HES*/
recode factory (.=0)
drop _merge
save marines_data, replace

***Markets
insheet using fr_market_dist.csv, comma clear
tempfile data
save `data', replace

*merge with usids
use coords, clear
keep id usid
merge 1:1 id using `data'
drop if _merge==1
drop _merge id
merge 1:1 usid using marines_data
drop if _merge==1 /*never in HES*/
recode market (.=0)
drop _merge
save marines_data, replace

***Military posts
insheet using fr_milpost_dist.csv, comma clear
tempfile data
save `data', replace

*merge with usids
use coords, clear
keep id usid
merge 1:1 id using `data'
drop if _merge==1
drop _merge id
merge 1:1 usid using marines_data
drop if _merge==1 /*never in HES*/
recode milpost (.=0)
drop _merge
save marines_data, replace

**telgraphs
insheet using fr_telegraph_dist.csv, comma clear
tempfile data
save `data', replace

*merge with usids
use coords, clear
keep id usid
merge 1:1 id using `data'
drop if _merge==1
drop _merge id
merge 1:1 usid using marines_data
drop if _merge==1 /*never in HES*/
recode telegraph (.=0)
drop _merge
save marines_data, replace

***Trains/trams
insheet using fr_traintram_dist.csv, comma clear
tempfile data
save `data', replace

*merge with usids
use coords, clear
keep id usid
merge 1:1 id using `data'
drop if _merge==1
drop _merge id
merge 1:1 usid using marines_data
drop if _merge==1 /*never in HES*/
recode traintram (.=0)
drop _merge
save marines_data, replace


*****************************
**French maps - lines
*****************************
***all roads
insheet using fr_road_inter2k.csv, comma clear
tempfile data
save `data', replace

*merge with usids
use coords, clear
keep id usid
merge 1:1 id using `data'
drop if _merge==1
drop _merge id
merge 1:1 usid using marines_data
drop if _merge==1 /*never in HES*/
recode all_roads (.=0)
drop _merge
save marines_data, replace

***colonial roads
insheet using fr_colroad_inter2k.csv, comma clear
tempfile data
save `data', replace

*merge with usids
use coords, clear
keep id usid
merge 1:1 id using `data'
drop if _merge==1
drop _merge id
merge 1:1 usid using marines_data
drop if _merge==1 /*never in HES*/
recode colonial_roads (.=0)
drop _merge

keep if abs(dbnd)<`bw'
save marines_data, replace

*****************************
***outcome data from HES
*****************************
use hes_ham_vilg69_71, clear

*merge with rd data
merge 1:1 usid villageid using marines_data	
keep if _merge==3 /*merge=2s, missing urbanization*/
drop _merge

g latlon=lat*lon

drop if (elev==.) /*one hamlet that is missing coordinates, drop for consistent sample*/

gen oweight=.
gen MaxDist=`bw'
replace oweight=(1-(abs(dbnd)/MaxDist)) /*weights for local regression */
replace oweight=0 if oweight<0
drop MaxDist

label var treat "Marines"
save marines_hamlet, replace



