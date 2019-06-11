
**********************************************************

*Their Code Tables 3 and 5

use a, clear
drop if date<23
quietly tab name ,ge(named)
quietly tab group,ge(sited)
ge lbill=log(1+kdje)

*Table 3 - All okay

reg p treat top5 treattop5, cluster(billid) 
reg p treat top5 treattop5 totaldish lbill named* sited*, cluster(billid)
dprobit p treat top5 treattop5,cluster(billid)
dprobit p treat top5 treattop5 totaldish lbill named* sited* ,cluster(billid)

*Table 5 - Sign reversed on one coefficient

use a, clear
quietly tab name ,ge(named)
quietly tab group,ge(sited)
ge lbill=log(1+kdje)

reg p treat after top5 treatafter top5after treattop5 treattop5after,cluster(billid)
reg p treat after top5 treatafter top5after treattop5 treattop5after totaldish lbill named* sited*,cluster(billid)
dprobit p treat after top5 treatafter top5after treattop5 treattop5after,cluster(billid)
dprobit p treat after top5 treatafter top5after treattop5 treattop5after totaldish lbill named* sited*,cluster(billid)

*******************************************************************

*My code - Tables 3 & 5 - dropping variables that are automatically dropped, combining both tables so only have to randomize once

use a, clear
quietly tab name ,ge(named)
quietly tab group,ge(sited)
ge lbill=log(1+kdje)

reg p treat treattop5 top5 if date >= 23, cluster(billid) 
areg p treat treattop5 top5 totaldish lbill sited2-sited4 if date >= 23, absorb(name) cluster(billid)

*Colinear in both samples
areg sited5 sited2-sited4 if date >= 23, absorb(name) 
areg sited5 sited2-sited4, absorb(name) 	

dprobit p treat treattop5 top5 if date >= 23, cluster(billid)
probit p treat treattop5 top5 if date >= 23, cluster(billid)

dprobit p treat treattop5 top5 totaldish lbill named2-named235 sited2-sited4 if date >= 23, cluster(billid)
probit p treat treattop5 top5 totaldish lbill named2-named235 sited2-sited4 if date >= 23, cluster(billid)

reg p treat treattop5 treatafter treattop5after after top5 top5after, cluster(billid)
areg p treat treattop5 treatafter treattop5after after top5 top5after totaldish lbill sited2-sited4, absorb(name) cluster(billid)

dprobit p treat after top5 treatafter top5after treattop5 treattop5after, cluster(billid)
probit p treat treattop5 treatafter treattop5after after top5 top5after, cluster(billid)

dprobit p treat after top5 treatafter top5after treattop5 treattop5after totaldish lbill named2-named235 sited2-sited4, cluster(billid)
probit p treat treattop5 treatafter treattop5after after top5 top5after totaldish lbill named2-named235 sited2-sited4, cluster(billid)

save DatCCF1, replace

*Note: billid is actually not unique to a bill
*Proof (example)
egen t = sd(kdrq), by(billid)
sum t
sum t if t > 0

**************************************

*Their code - Tables 4 & 6

use b, clear
drop if date<23
quietly tab name ,ge(named)
quietly tab group,ge(sited)
ge lbill=log(1+kdje)

*Table 4 - this regression mistakenly only covers 2 restaurants, as for the other 2 treattop5 mistakenly set equal to .
*Also - rounding error

tab group
tab group treattop5
tab group treat
tab group top5
*Error - data is available for these restaurants.  Following usual procedure, replicate their errors

reg p treat top5 treattop5,cluster(billid)
reg p treat top5 treattop5 totaldish lbill named* sited* ,cluster(billid)
dprobit p treat top5 treattop5,cluster(billid)
dprobit p treat top5 treattop5 totaldish lbill named* sited* ,cluster(billid)

use b, clear
quietly tab name ,ge(named)
quietly tab group,ge(sited)
ge lbill=log(1+kdje)

*Table 6 - Rounding error, dropped two (= 1/2 of) experimental locations, as in Table 4 above
*Also reverses the sign on one coefficient

reg p treat after top5 treatafter top5after treattop5 treattop5after,cluster(billid)
reg p treat after top5 treatafter top5after treattop5 treattop5after totaldish lbill named* sited*,cluster(billid)
dprobit p treat after top5 treatafter top5after treattop5 treattop5after,cluster(billid)
dprobit p treat after top5 treatafter top5after treattop5 treattop5after totaldish lbill named* sited*,cluster(billid)


**********************************************

*My code - Tables 4 and 6 - Since never use groups 23 & 24 (mistakenly coded out), everything runs more quickly if simply drop those observations

use b, clear
*Allocation of treatment to tables is implicitly stratified by location, so can drop these locations as they never feature in any of the regresssions
drop if group == 23 | group == 24
quietly tab name ,ge(named)
quietly tab group,ge(sited)
quietly generate lbill=log(1+kdje)

reg p treat treattop5 top5 if date >= 23, cluster(billid)
areg p treat treattop5 top5 totaldish lbill sited2 if date >= 23, absorb(name) cluster(billid)

dprobit p treat top5 treattop5 if date >= 23, cluster(billid)
probit p treat treattop5 top5 if date >= 23, cluster(billid)

dprobit p treat top5 treattop5 totaldish lbill named2-named115 sited2 if date >= 23, cluster(billid)
probit p treat treattop5 top5 totaldish lbill named2-named115 sited2 if date >= 23, cluster(billid)

reg p treat treattop5 treatafter treattop5after after top5 top5after, cluster(billid)
areg p treat treattop5 treatafter treattop5after after top5 top5after totaldish lbill sited2, absorb(name) cluster(billid)

dprobit p treat after top5 treatafter top5after treattop5 treattop5after, cluster(billid)
probit p treat treattop5 treatafter treattop5after after top5 top5after, cluster(billid)

dprobit p treat after top5 treatafter top5after treattop5 treattop5after totaldish lbill named2-named115 sited2, cluster(billid)
probit p treat treattop5 treatafter treattop5after after top5 top5after totaldish lbill named2-named115 sited2, cluster(billid)
save DatCCF2, replace













