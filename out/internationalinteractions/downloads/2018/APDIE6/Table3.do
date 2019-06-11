* replication code for Table 3
* make sure the spreg package is installed. If not, run "net install st0292.pkg"


*net install st0292.pkg

* Use the file below in the directory
use "Table3.dta", clear 

gen lnarea= log(area_1998)
keep if lnarea!=. 


spmat idistance weights long_avg lat_avg, id(pointID) replace

* Table 3, Column 1
spreg gs2sls lnadminarea *avg_C *avg_D *avg_E *avg_F *avg_L *avg_V lnarea, id(pointID) dlmat(weights)

* Table 3, Column 2
spreg gs2sls  lnadminarea *avg_C lnarea, id(pointID) dlmat(weights)

* Table 3, Column 3
spreg gs2sls  lnadminarea *avg_D lnarea, id(pointID) dlmat(weights)

* Table 3, Column 4
spreg gs2sls  lnadminarea *avg_E lnarea, id(pointID) dlmat(weights)

* Table 3, Column 5
spreg gs2sls  lnadminarea *avg_F lnarea, id(pointID) dlmat(weights)

* Table 3, Column 6
spreg gs2sls  lnadminarea *avg_L lnarea, id(pointID) dlmat(weights)

* Table 3, Column 7
spreg gs2sls  lnadminarea *avg_V lnarea, id(pointID) dlmat(weights)



