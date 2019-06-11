
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	`anything' `if' `in', cluster(`cluster')
	capture testparm `testvars'
	if (_rc == 0) {
		matrix F[$i,1] = r(p), r(drop), e(df_r), $k
		local i = 0
		foreach var in `testvars' {
			matrix B[$j+`i',1] = _b[`var'], _se[`var']
			local i = `i' + 1
			}
		}
global i = $i + 1
global j = $j + $k
end

****************************************
****************************************

global demog "female age shia education logincome baseline_risk bornlocally reporting_important  policesolve courtsolve"
global newdemog "female shia age education logincome baseline_risk"

use DatCILS, clear

matrix F = J(32,4,.)
matrix B = J(60,2,.)

global i = 1
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

global i = 0

*Table 4
	global i = $i + 1
		randcmdc ((pf) intreg qlow qhigh pf PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)), treatvars(pf) strata(pc) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(M1)
	global i = $i + 1
		randcmdc ((pf) intreg qlow qhigh pf $demog PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)), treatvars(pf) strata(pc) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(M1)
	global i = $i + 1
		randcmdc ((pf) intreg qlow qhigh pf PROVINCE2-PROVINCE12 if insample >=2 & certainty==1, cluster(pc)), treatvars(pf) strata(pc) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(M1)
	global i = $i + 1
		randcmdc ((pf) intreg qlow qhigh pf $demog PROVINCE2-PROVINCE12 if insample >=2 & certainty==1, cluster(pc)), treatvars(pf) strata(pc) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(M1)
	global i = $i + 1
		randcmdc ((pf) intreg upremiumlow upremiumhigh pf PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)), treatvars(pf) strata(pc) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(M1)
	global i = $i + 1
		randcmdc ((pf) intreg upremiumlow upremiumhigh pf $demog PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)), treatvars(pf) strata(pc) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(M1)

	forvalues j = 1/12 {
		global i = $i + 1
		preserve
			drop _all
			set obs $reps
			foreach var in ResB ResSE ResF {
				gen `var' = .
				}
			gen __0000001 = 0 if _n == 1
			gen __0000002 = 0 if _n == 1
			save ip\a$i, replace
		restore
		}

*Table 5
	global i = $i + 1
		randcmdc ((pf) intreg qlow qhigh pf PC2-PC287 if insample >=2 & certainty==0), treatvars(pf) strata(pc) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(M1)
	global i = $i + 1
		randcmdc ((pf) intreg qlow qhigh pf $demog PC2-PC287 if insample >=2 & certainty==0), treatvars(pf) strata(pc) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(M1)
	global i = $i + 1
		randcmdc ((pf) intreg qlow qhigh pf PC2-PC287 if insample >=2 & certainty==1), treatvars(pf) strata(pc) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(M1)
	global i = $i + 1
		randcmdc ((pf) intreg qlow qhigh pf $demog PC2-PC287 if insample >=2 & certainty==1), treatvars(pf) strata(pc) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(M1)
	global i = $i + 1
		randcmdc ((pf) intreg upremiumlow upremiumhigh pf PC2-PC287 if insample >=2 & certainty==0), treatvars(pf) strata(pc) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(M1)
	global i = $i + 1
		randcmdc ((pf) intreg upremiumlow upremiumhigh pf $demog PC2-PC287 if insample >=2 & certainty==0), treatvars(pf) strata(pc) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(M1)

	forvalues j = 1/36 {
		global i = $i + 1
		preserve
			drop _all
			set obs $reps
			foreach var in ResB ResSE ResF {
				gen `var' = .
				}
			gen __0000001 = 0 if _n == 1
			gen __0000002 = 0 if _n == 1
			save ip\a$i, replace
		restore
		}


matrix T = J($i,2,.)
use ip\a1, clear
mkmat __* in 1/1, matrix(a)
drop __*
matrix T[1,1] = a
rename ResB ResB1
rename ResSE ResSE1
rename ResF ResF1
forvalues i = 2/$i {
	merge using ip\a`i'
	mkmat __* in 1/1, matrix(a)
	drop __* _m
	matrix T[`i',1] = a
	rename ResB ResB`i'
	rename ResSE ResSE`i'
	rename ResF ResF`i'
	}
svmat double F
svmat double B
svmat double T
gen N = _n
sort N
compress
aorder
save results\FisherCondCILS, replace




