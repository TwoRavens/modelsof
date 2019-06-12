
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust ]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	capture `anything' `if' `in', 
	if (_rc == 0) {
		local i = 0
		foreach var in `testvars' {
			matrix B[$j+`i',1] = _b[`var']
			local i = `i' + 1
			}
		}
global j = $j + $k
end

****************************************
****************************************

capture program drop mycmd1
program define mycmd1
	syntax anything [if] [in] [, cluster(string) robust ]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	capture `anything' `if' `in', 
	if (_rc == 0) {
		local i = 0
		foreach var in `testvars' {
			matrix BB[$j+`i',1] = _b[`var']
			local i = `i' + 1
			}
		}
global j = $j + $k
end


****************************************
****************************************

global b = 60

use DatCILS, clear

global demog "female age shia education logincome baseline_risk bornlocally reporting_important  policesolve courtsolve"
global newdemog "female shia age education logincome baseline_risk"

matrix B = J($b,1,.)

global j = 1

*Table 4
mycmd (pf) intreg qlow qhigh pf PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)
mycmd (pf) intreg qlow qhigh pf $demog PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)
mycmd (pf) intreg qlow qhigh pf PROVINCE2-PROVINCE12 if insample >=2 & certainty==1, cluster(pc)
mycmd (pf) intreg qlow qhigh pf $demog PROVINCE2-PROVINCE12 if insample >=2 & certainty==1, cluster(pc)
mycmd (pf) intreg upremiumlow upremiumhigh pf PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)
mycmd (pf) intreg upremiumlow upremiumhigh pf $demog PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)
mycmd (pf pf_kineticdummy1k_one) intreg qlow qhigh pf pf_kineticdummy1k_one kineticdummy1k_one PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)
mycmd (pf pf_kineticdummy1k_one) intreg qlow qhigh pf pf_kineticdummy1k_one kineticdummy1k_one $demog PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)
mycmd (pf pf_kineticdummy1k_one) intreg qlow qhigh pf pf_kineticdummy1k_one kineticdummy1k_one PROVINCE2-PROVINCE12 if insample >=2 & certainty==1, cluster(pc)
mycmd (pf pf_kineticdummy1k_one) intreg qlow qhigh pf pf_kineticdummy1k_one kineticdummy1k_one $demog PROVINCE2-PROVINCE12 if insample >=2 & certainty==1, cluster(pc)
mycmd (pf pf_kineticdummy1k_one) intreg upremiumlow upremiumhigh pf pf_kineticdummy1k_one kineticdummy1k_one PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)
mycmd (pf pf_kineticdummy1k_one) intreg upremiumlow upremiumhigh pf pf_kineticdummy1k_one kineticdummy1k_one $demog PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)

*Table 5
mycmd (pf) intreg qlow qhigh pf PC2-PC287 if insample >=2 & certainty==0
mycmd (pf) intreg qlow qhigh pf $demog PC2-PC287 if insample >=2 & certainty==0
mycmd (pf) intreg qlow qhigh pf PC2-PC287 if insample >=2 & certainty==1
mycmd (pf) intreg qlow qhigh pf $demog PC2-PC287 if insample >=2 & certainty==1
mycmd (pf) intreg upremiumlow upremiumhigh pf PC2-PC287 if insample >=2 & certainty==0
mycmd (pf) intreg upremiumlow upremiumhigh pf $demog PC2-PC287 if insample >=2 & certainty==0
mycmd (pf pf_kineticdummy1k_one) intreg qlow qhigh pf pf_kineticdummy1k_one PC2-PC287 if insample >=2 & certainty==0
mycmd (pf pf_kineticdummy1k_one) intreg qlow qhigh pf pf_kineticdummy1k_one $demog PC2-PC287 if insample >=2 & certainty==0
mycmd (pf pf_kineticdummy1k_one) intreg qlow qhigh pf pf_kineticdummy1k_one PC2-PC287 if insample >=2 & certainty==1
mycmd (pf pf_kineticdummy1k_one) intreg qlow qhigh pf pf_kineticdummy1k_one $demog PC2-PC287 if insample >=2 & certainty==1
mycmd (pf pf_kineticdummy1k_one) intreg upremiumlow upremiumhigh pf pf_kineticdummy1k_one PC2-PC287 if insample >=2 & certainty==0
mycmd (pf pf_kineticdummy1k_one) intreg upremiumlow upremiumhigh pf  pf_kineticdummy1k_one $demog PC2-PC287 if insample >=2 & certainty==0

*Table 7 
mycmd (pf pf_kineticdummy1k_one pf_reporting_important) intreg upremiumlow upremiumhigh pf pf_kineticdummy1k_one pf_reporting_important kineticdummy1k_one reporting_important PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)
mycmd (pf pf_kineticdummy1k_one pf_reporting_important) intreg upremiumlow upremiumhigh pf pf_kineticdummy1k_one pf_reporting_important kineticdummy1k_one reporting_important $newdemog PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)
mycmd (pf pf_kineticdummy1k_one pf_policesolve) intreg upremiumlow upremiumhigh pf pf_kineticdummy1k_one pf_policesolve kineticdummy1k_one policesolve PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)
mycmd (pf pf_kineticdummy1k_one pf_policesolve) intreg upremiumlow upremiumhigh pf pf_kineticdummy1k_one pf_policesolve kineticdummy1k_one policesolve  $newdemog PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)
mycmd (pf pf_kineticdummy1k_one pf_courtsolve) intreg upremiumlow upremiumhigh pf pf_kineticdummy1k_one pf_courtsolve kineticdummy1k_one courtsolve PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)
mycmd (pf pf_kineticdummy1k_one pf_courtsolve) intreg upremiumlow upremiumhigh pf  pf_kineticdummy1k_one pf_courtsolve kineticdummy1k_one courtsolve $newdemog PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)
mycmd (pf pf_kineticdummy1k_one pf_bornlocally) intreg upremiumlow upremiumhigh pf pf_kineticdummy1k_one pf_bornlocally kineticdummy1k_one bornlocally  PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)
mycmd (pf pf_kineticdummy1k_one pf_bornlocally) intreg upremiumlow upremiumhigh pf pf_kineticdummy1k_one pf_bornlocally kineticdummy1k_one bornlocally $newdemog PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)

egen M = group(pc)
sum M
global reps = r(max)

mata ResB = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"

preserve

drop if M == `c'

global j = 1

*Table 4
mycmd1 (pf) intreg qlow qhigh pf PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)
mycmd1 (pf) intreg qlow qhigh pf $demog PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)
mycmd1 (pf) intreg qlow qhigh pf PROVINCE2-PROVINCE12 if insample >=2 & certainty==1, cluster(pc)
mycmd1 (pf) intreg qlow qhigh pf $demog PROVINCE2-PROVINCE12 if insample >=2 & certainty==1, cluster(pc)
mycmd1 (pf) intreg upremiumlow upremiumhigh pf PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)
mycmd1 (pf) intreg upremiumlow upremiumhigh pf $demog PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)
mycmd1 (pf pf_kineticdummy1k_one) intreg qlow qhigh pf pf_kineticdummy1k_one kineticdummy1k_one PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)
mycmd1 (pf pf_kineticdummy1k_one) intreg qlow qhigh pf pf_kineticdummy1k_one kineticdummy1k_one $demog PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)
mycmd1 (pf pf_kineticdummy1k_one) intreg qlow qhigh pf pf_kineticdummy1k_one kineticdummy1k_one PROVINCE2-PROVINCE12 if insample >=2 & certainty==1, cluster(pc)
mycmd1 (pf pf_kineticdummy1k_one) intreg qlow qhigh pf pf_kineticdummy1k_one kineticdummy1k_one $demog PROVINCE2-PROVINCE12 if insample >=2 & certainty==1, cluster(pc)
mycmd1 (pf pf_kineticdummy1k_one) intreg upremiumlow upremiumhigh pf pf_kineticdummy1k_one kineticdummy1k_one PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)
mycmd1 (pf pf_kineticdummy1k_one) intreg upremiumlow upremiumhigh pf pf_kineticdummy1k_one kineticdummy1k_one $demog PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)

*Table 5
mycmd1 (pf) intreg qlow qhigh pf PC* if insample >=2 & certainty==0
mycmd1 (pf) intreg qlow qhigh pf $demog PC* if insample >=2 & certainty==0
mycmd1 (pf) intreg qlow qhigh pf PC* if insample >=2 & certainty==1
mycmd1 (pf) intreg qlow qhigh pf $demog PC* if insample >=2 & certainty==1
mycmd1 (pf) intreg upremiumlow upremiumhigh pf PC* if insample >=2 & certainty==0
mycmd1 (pf) intreg upremiumlow upremiumhigh pf $demog PC* if insample >=2 & certainty==0
mycmd1 (pf pf_kineticdummy1k_one) intreg qlow qhigh pf pf_kineticdummy1k_one PC* if insample >=2 & certainty==0
mycmd1 (pf pf_kineticdummy1k_one) intreg qlow qhigh pf pf_kineticdummy1k_one $demog PC* if insample >=2 & certainty==0
mycmd1 (pf pf_kineticdummy1k_one) intreg qlow qhigh pf pf_kineticdummy1k_one PC* if insample >=2 & certainty==1
mycmd1 (pf pf_kineticdummy1k_one) intreg qlow qhigh pf pf_kineticdummy1k_one $demog PC* if insample >=2 & certainty==1
mycmd1 (pf pf_kineticdummy1k_one) intreg upremiumlow upremiumhigh pf pf_kineticdummy1k_one PC* if insample >=2 & certainty==0
mycmd1 (pf pf_kineticdummy1k_one) intreg upremiumlow upremiumhigh pf  pf_kineticdummy1k_one $demog PC* if insample >=2 & certainty==0

*Table 7 
mycmd1 (pf pf_kineticdummy1k_one pf_reporting_important) intreg upremiumlow upremiumhigh pf pf_kineticdummy1k_one pf_reporting_important kineticdummy1k_one reporting_important PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)
mycmd1 (pf pf_kineticdummy1k_one pf_reporting_important) intreg upremiumlow upremiumhigh pf pf_kineticdummy1k_one pf_reporting_important kineticdummy1k_one reporting_important $newdemog PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)
mycmd1 (pf pf_kineticdummy1k_one pf_policesolve) intreg upremiumlow upremiumhigh pf pf_kineticdummy1k_one pf_policesolve kineticdummy1k_one policesolve PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)
mycmd1 (pf pf_kineticdummy1k_one pf_policesolve) intreg upremiumlow upremiumhigh pf pf_kineticdummy1k_one pf_policesolve kineticdummy1k_one policesolve  $newdemog PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)
mycmd1 (pf pf_kineticdummy1k_one pf_courtsolve) intreg upremiumlow upremiumhigh pf pf_kineticdummy1k_one pf_courtsolve kineticdummy1k_one courtsolve PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)
mycmd1 (pf pf_kineticdummy1k_one pf_courtsolve) intreg upremiumlow upremiumhigh pf  pf_kineticdummy1k_one pf_courtsolve kineticdummy1k_one courtsolve $newdemog PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)
mycmd1 (pf pf_kineticdummy1k_one pf_bornlocally) intreg upremiumlow upremiumhigh pf pf_kineticdummy1k_one pf_bornlocally kineticdummy1k_one bornlocally  PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)
mycmd1 (pf pf_kineticdummy1k_one pf_bornlocally) intreg upremiumlow upremiumhigh pf pf_kineticdummy1k_one pf_bornlocally kineticdummy1k_one bornlocally $newdemog PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)

mata BB = st_matrix("BB"); ResB[`c',1..$b] = BB[.,1]'

restore

}

drop _all
set obs $reps
forvalues i = 1/$b {
	quietly generate double ResB`i' = .
	}
mata st_store(.,.,ResB)
svmat double B
gen N = _n
save results\OJackknifeCILS, replace


