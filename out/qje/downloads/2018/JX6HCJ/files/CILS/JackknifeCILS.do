

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust absorb(string)]
	gettoken testvars anything: anything, match(match)
	`anything' `if' `in', cluster(`cluster') `robust'
	testparm `testvars'
	global k = r(df)
	unab testvars: `testvars'
	mata B = st_matrix("e(b)"); V = st_matrix("e(V)"); V = sqrt(diagonal(V)); BB = B[1,1..$k]',V[1..$k,1]; st_matrix("B",BB)
preserve
	keep if e(sample)
	if ("$cluster" ~= "") egen M = group($cluster)
	if ("$cluster" == "") gen M = _n
	quietly sum M
	global N = r(max)
	mata ResB = J($N,$k,.); ResSE = J($N,$k,.); ResF = J($N,3,.)
	forvalues i = 1/$N {
		if (floor(`i'/50) == `i'/50) display "`i'", _continue
		quietly `anything' if M ~= `i', cluster(`cluster') `robust'
		matrix BB = J($k,2,.)
		local c = 1
		foreach var in `testvars' {
			capture matrix BB[`c',1] = _b[`var'], _se[`var']
			local c = `c' + 1
			}
		matrix F = J(1,3,.)
		capture testparm `testvars'
		if (_rc == 0) matrix F = r(p), r(drop), e(df_r)
		mata BB = st_matrix("BB"); F = st_matrix("F"); ResB[`i',1..$k] = BB[1..$k,1]'; ResSE[`i',1..$k] = BB[1..$k,2]'; ResF[`i',1..3] = F
		}
	quietly drop _all
	quietly set obs $N
	global kk = $j + $k - 1
	forvalues i = $j/$kk {
		quietly generate double ResB`i' = .
		}
	forvalues i = $j/$kk {
		quietly generate double ResSE`i' = .
		}
	quietly generate double ResF$i = .
	quietly generate double ResD$i = .
	quietly generate double ResDF$i = .
	mata X = ResB, ResSE, ResF; st_store(.,.,X)
	quietly svmat double B
	quietly rename B2 SE$i
	capture rename B1 B$i
	save ip\JK$i, replace
restore
	global i = $i + 1
	global j = $j + $k
end



*******************


global cluster = "pc"

use DatCILS, clear

global demog "female age shia education logincome baseline_risk bornlocally reporting_important  policesolve courtsolve"
global newdemog "female shia age education logincome baseline_risk"

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
mycmd (pf) intreg qlow qhigh pf PC* if insample >=2 & certainty==0
mycmd (pf) intreg qlow qhigh pf $demog PC* if insample >=2 & certainty==0
mycmd (pf) intreg qlow qhigh pf PC* if insample >=2 & certainty==1
mycmd (pf) intreg qlow qhigh pf $demog PC* if insample >=2 & certainty==1
mycmd (pf) intreg upremiumlow upremiumhigh pf PC* if insample >=2 & certainty==0
mycmd (pf) intreg upremiumlow upremiumhigh pf $demog PC* if insample >=2 & certainty==0
mycmd (pf pf_kineticdummy1k_one) intreg qlow qhigh pf pf_kineticdummy1k_one PC* if insample >=2 & certainty==0
mycmd (pf pf_kineticdummy1k_one) intreg qlow qhigh pf pf_kineticdummy1k_one $demog PC* if insample >=2 & certainty==0
mycmd (pf pf_kineticdummy1k_one) intreg qlow qhigh pf pf_kineticdummy1k_one PC* if insample >=2 & certainty==1
mycmd (pf pf_kineticdummy1k_one) intreg qlow qhigh pf pf_kineticdummy1k_one $demog PC* if insample >=2 & certainty==1
mycmd (pf pf_kineticdummy1k_one) intreg upremiumlow upremiumhigh pf pf_kineticdummy1k_one PC* if insample >=2 & certainty==0
mycmd (pf pf_kineticdummy1k_one) intreg upremiumlow upremiumhigh pf  pf_kineticdummy1k_one $demog PC* if insample >=2 & certainty==0

*Table 7 
mycmd (pf pf_kineticdummy1k_one pf_reporting_important) intreg upremiumlow upremiumhigh pf pf_kineticdummy1k_one pf_reporting_important kineticdummy1k_one reporting_important PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)
mycmd (pf pf_kineticdummy1k_one pf_reporting_important) intreg upremiumlow upremiumhigh pf pf_kineticdummy1k_one pf_reporting_important kineticdummy1k_one reporting_important $newdemog PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)
mycmd (pf pf_kineticdummy1k_one pf_policesolve) intreg upremiumlow upremiumhigh pf pf_kineticdummy1k_one pf_policesolve kineticdummy1k_one policesolve PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)
mycmd (pf pf_kineticdummy1k_one pf_policesolve) intreg upremiumlow upremiumhigh pf pf_kineticdummy1k_one pf_policesolve kineticdummy1k_one policesolve  $newdemog PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)
mycmd (pf pf_kineticdummy1k_one pf_courtsolve) intreg upremiumlow upremiumhigh pf pf_kineticdummy1k_one pf_courtsolve kineticdummy1k_one courtsolve PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)
mycmd (pf pf_kineticdummy1k_one pf_courtsolve) intreg upremiumlow upremiumhigh pf  pf_kineticdummy1k_one pf_courtsolve kineticdummy1k_one courtsolve $newdemog PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)
mycmd (pf pf_kineticdummy1k_one pf_bornlocally) intreg upremiumlow upremiumhigh pf pf_kineticdummy1k_one pf_bornlocally kineticdummy1k_one bornlocally  PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)
mycmd (pf pf_kineticdummy1k_one pf_bornlocally) intreg upremiumlow upremiumhigh pf pf_kineticdummy1k_one pf_bornlocally kineticdummy1k_one bornlocally $newdemog PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)


use ip\JK1, clear
forvalues i = 2/32 {
	merge using ip\JK`i'
	tab _m
	drop _m
	}
quietly sum B1
global k = r(N)
mkmat B1 SE1 in 1/$k, matrix(B)
forvalues i = 2/32 {
	quietly sum B`i'
	global k = r(N)
	mkmat B`i' SE`i' in 1/$k, matrix(BB)
	matrix B = B \ BB
	}
drop B* SE*
svmat double B
aorder
save results\JackKnifeCILS, replace


