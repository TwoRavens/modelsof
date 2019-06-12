
global cluster = "id"

use DatHS1, clear

global i = 1
global j = 1

*Table 1
foreach demog in q3b q3a q2b q2a px05_ px05p_ px1_ px1p_ px2_ px2p_ {
	mycmd (highqx) ttest `demog', by(highqx) unequal
	}

***********************************

use DatHS2, clear

sum q3d
local twicesd=2*r(sd)

*Table 2
foreach obs in "" "if q3d>=-`twicesd' & q3d <=`twicesd'" {
	foreach regressors in "highqx" "highqx female r_agemiss r_age r_age2 human econ othersoc day*" {
		mycmd (highqx) reg q3d `regressors' `obs'
		}
	}
foreach regressors in "highqx" "highqx female r_agemiss r_age r_age2 human econ othersoc day*" {
	mycmd (highqx) ologit q2sd `regressors'
	}


*****************************************************

use DatHS3, clear

*Table 3
foreach cert in 0 1 {
	foreach regressors in "Qx px" "Qx px female r_agemiss r_age r_age2 human econ othersoc day*" {
		mycmd (Qx) reg x `regressors' if certain==`cert' & px~=1, cluster(id)
		}
	}

