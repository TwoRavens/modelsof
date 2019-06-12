
****************************************
****************************************

*In maximum likelihood framework, the unequal variance estimates won't matter for the robust final covariance matrix for the coefficients 
*So, can just treat like a regression

use DatHS1, clear

*Table 1

global i = 1

foreach demog in q3b q3a q2b q2a px05_ px05p_ px1_ px1p_ px2_ px2p_ {
*ttest `demog', by(highqx) unequal
	reg `demog' highqx
	estimates store M$i
	global i = $i + 1
	}
suest M1 M2 M3 M4 M5 M6 M7 M8 M9 M10, robust
test highqx
matrix F = (r(p), r(drop), r(df), r(chi2), 1)


***********************************

use DatHS2, clear

sum q3d
local twicesd=2*r(sd)

*Table 2

global i = 1

foreach obs in "" "if q3d>=-`twicesd' & q3d <=`twicesd'" {
	foreach regressors in "highqx" "highqx female r_agemiss r_age r_age2 human econ othersoc day*" {
		reg q3d `regressors' `obs'
		estimates store M$i
		global i = $i + 1
		}
	}
foreach regressors in "highqx" "highqx female r_agemiss r_age r_age2 human econ othersoc day*" {
	ologit q2sd `regressors'
	estimates store M$i
	global i = $i + 1
	}

suest M1 M2 M3 M4 M5 M6, robust
test highqx
matrix F = F \  (r(p), r(drop), r(df), r(chi2), 2)


*****************************************************

use DatHS3, clear

*Table 3

global i = 1

foreach cert in 0 1 {
	foreach regressors in "Qx px" "Qx px female r_agemiss r_age r_age2 human econ othersoc day*" {
		reg x `regressors' if certain==`cert' & px~=1, 
		estimates store M$i
		global i = $i + 1
		}
	}

suest M1 M2 M3 M4, cluster(id)
test Qx
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 3)

drop _all
svmat double F
save results/SuestHS, replace


