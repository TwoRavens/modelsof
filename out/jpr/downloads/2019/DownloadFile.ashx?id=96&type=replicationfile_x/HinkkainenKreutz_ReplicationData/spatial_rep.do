*****

* Spatial replication file

*****

*************************
* SPMAT
*************************

* Spatial matrix

clear

clear mata

net install shp2dta.pkg 

shp2dta using priogrid_cell, database(grids) coordinates(gridsxy) genid(id) gencentroids(c)

use grids

sort gid

merge gid using gridfinal.dta

tab _merge

drop if _merge!=3

collapse (max) id x_c y_c xcoord ycoord col row confl_best, by (gid)

sort id

save grids, replace

net install spmap.pkg

spmap using gridsxy, id(id)

use grids, clear

spmat contiguity gridspatial using gridsxy, id(id) normalize(row) saving(gridspatial) 

spmat summarize gridspatial, links

* 127053 obs is the island and needs dropping
* Note the gid for this island is 132135

drop if id==127053
spmat contiguity gridspatialx using gridsxy, id(id) normalize(row) 

spmat summarize gridspatialx, links

save grids.dta, replace

****** Now convert this to spatwmat to do autocorrelation tests ******

* Remember to clear matrix and mata and set maxvar 

clear
clear matrix
clear mata
set max_memory .

use grids.dta

spmat contiguity gridspatialtest using "gridsxy.dta", id(id) replace 

spmat summarize gridspatialtest 

spmat export gridspatialtest using "gridspatialtest.txt", noid replace 

clear

clear mata
set maxvar 32767 

import delimited using "gridspatialtest.txt", delim(" ")

* Here delete the first row of the txt file 

drop in 1 

save "gridspatialtest.dta", replace 

set matsize 11000

spatwmat using "gridspatialtest.dta", name(Ws) standardize 

use gridfinal.dta

drop if gid==132135 

collapse (sum) cellarea best_est high_est low_est confl_best ///
confl_high confl_low govosv allevents  lootablecsv nonlootablecsv ///
country_best country_high country_low country_events ///
(max) mnt land_mask ucdpgedpoly ext_suppa ext_suppb cocabush opiumpoppy confid ///
onset term talks cm_med peace_ag multi_dyad d_id uid gridnum ///
petrodata_onshore_v12 petrodata_offshore_v12 cannabis ///
conf civconf confold civcfold ///
(mean) frst area dur1 dur2 conflag1 conflag3 ///
conflag5 cfoldlag1 cfoldlag3 cfoldlag5 bdist1 bdist2 ///
bdist3 capdist ttime pop imr irri prec temp ///
gcppc90 gcppc95 gcppc00 gcppc05 gcpqual ppp90 ppp95 ppp00 ppp05, by(gid)

egen natres = rowtotal(petrodata_onshore_v12 petrodata_offshore_v12 cannabis lootablecsv nonlootablecsv)

tabstat natres, stat(sum)
  
summ 

reg confl_best natres cellarea capdist country_best pop
* Had to take some variables out as they have missing obs

spatdiag, weights(Ws)
* Table 8
  
* Global autocorrelation
spatgsa confl_best natres cellarea capdist country_best pop, weights(Ws) moran
* Table 9

* Local autocorrelation
spatlsa confl_best, weights(Ws) moran id(gid) sort
