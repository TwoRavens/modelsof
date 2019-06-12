
**  Analysis do file for Table 3 from Gartzke, Erik and Alex Weisiger 2014 “Under Construction:  Development, Democracy, and Difference as Determinants of Systemic Liberal Peace,” International Studies Quarterly 58(2):130-145.

log using gartzke_weisiger_ISQ_2014_table_3_data_012014.log, replace

set more off

use gartzke_weisiger_ISQ_2014_table_3_data_012014.dta, clear

** Replicating Table 3


relogit deadlyl polave demloi logdist cntgdumy allydumy capratio onemajor deadyrs deadyer*, cluster(dyadid)

relogit deadlyl polave pcenerg diff1 demloi engypop dydiff logdist cntgdumy allydumy capratio onemajor deadyrs deadyer*, cluster(dyadid)

relogit deadlyl propdem mwldrgdppc diff1 demloi mrgdp96pl dydiff logdist cntgdumy allydumy capratio onemajor deadyrs deadyer*, cluster(dyadid)



