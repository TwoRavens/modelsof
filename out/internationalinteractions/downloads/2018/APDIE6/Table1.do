* replication code for Table 2
* make sure the spreg package is installed. If not, run "net install st0292.pkg"

net install st0292.pkg

* Use the file below in the directory
use "Table1.dta", clear 

spmat idistance weights long_avg lat_avg, id(pointID) replace

* Table 1, Column 1
spreg gs2sls  lnarea1998 *avg_C, id(pointID) dlmat(weights)

* Table 1, Column 2
spreg gs2sls  lnarea1998 *avg_D, id(pointID) dlmat(weights)

*Table 1, COlumn 3
spreg gs2sls  lnarea1998 *avg_E, id(pointID) dlmat(weights)

* Table 1, Column 4
spreg gs2sls  lnarea1998 *avg_F, id(pointID) dlmat(weights)

* Table 1, Column 5
spreg gs2sls  lnarea1998 *avg_L, id(pointID) dlmat(weights)

* Table 1, Column 6
spreg gs2sls  lnarea1998 *avg_V, id(pointID) dlmat(weights)

* Table 1, Column 7
spreg gs2sls  lnarea1998 *avg_C *avg_D *avg_E *avg_F *avg_L *avg_V, id(pointID) dlmat(weights)

