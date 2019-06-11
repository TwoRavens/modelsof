
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust ]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	`anything' `if' `in', cluster(`cluster') `robust'
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

capture program drop mycmd1
program define mycmd1
	syntax anything [if] [in] [, cluster(string) robust ]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	capture `anything' `if' `in', cluster(`cluster') `robust'
	if (_rc == 0) {
		capture testparm `testvars'
		if (_rc == 0) {
			matrix FF[$i,1] = r(p), r(drop), e(df_r)
			matrix V = e(V)
			matrix b = e(b)
			matrix V = V[1..$k,1..$k]
			matrix b = b[1,1..$k]
			matrix f = (b-B[$j..$j+$k-1,1]')*invsym(V)*(b'-B[$j..$j+$k-1,1])
			if (e(df_r) ~= .) capture matrix FF[$i,4] = Ftail($k,e(df_r),f[1,1]/$k)
			if (e(df_r) == .) capture matrix FF[$i,4] = chi2tail($k,f[1,1])
			local i = 0
			foreach var in `testvars' {
				matrix BB[$j+`i',1] = _b[`var'], _se[`var']
				local i = `i' + 1
				}
			}
		}
global i = $i + 1
global j = $j + $k
end


****************************************
****************************************

global a = 32
global b = 60

use DatCILS, clear

global demog "female age shia education logincome baseline_risk bornlocally reporting_important  policesolve courtsolve"
global newdemog "female shia age education logincome baseline_risk"

matrix F = J($a,4,.)
matrix B = J($b,2,.)

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

gen Order = _n
sort pc Order
gen N = 1
gen Dif = (pc ~= pc[_n-1])
replace N = N[_n-1] + Dif if _n > 1
save aa, replace

drop if N == N[_n-1]
egen NN = max(N)
keep NN
generate obs = _n
save aaa, replace

mata ResFF = J($reps,$a,.); ResF = J($reps,$a,.); ResD = J($reps,$a,.); ResDF = J($reps,$a,.); ResB = J($reps,$b,.); ResSE = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix FF = J($a,4,.)
	matrix BB = J($b,2,.)
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using aa
	drop pc
	rename obs pc

drop PC*
quietly tab pc, gen(PC)
drop PC1

global i = 1
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

mata BB = st_matrix("BB"); FF = st_matrix("FF")
mata ResF[`c',1..$a] = FF[.,1]'; ResD[`c',1..$a] = FF[.,2]'; ResDF[`c',1..$a] = FF[.,3]'; ResFF[`c',1..$a] = FF[.,4]'
mata ResB[`c',1..$b] = BB[.,1]'; ResSE[`c',1..$b] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResFF ResF ResD ResDF {
	forvalues i = 1/$a {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/$b {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResFF, ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save results\OBootstrapCILS, replace

capture erase aa.dta
capture erase aaa.dta

