clear
set more off

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
g seg3=0

replace seg2=1 if dbnd==dis_seg2
replace seg3=1 if dbnd==dis_seg3
keep id dbnd seg2 seg3 lat lon
tempfile data
save `data', replace

*merge with usids
use coords, clear
keep id usid
merge 1:1 id using `data'
drop if _merge==1
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

save marines_data, replace


*****************************
**PAAS
*****************************
use paas, clear

*merge with rest of data
merge 1:1 usid using marines_data
keep if _merge==3
drop _merge
label var treat "Marines"

replace seg2=1 if seg3==1
drop seg3

save marines_paas, replace


