

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust by(string) unequal]
	tempvar touse
	gettoken testvars anything: anything, match(match)
	if ("`by'" == "") {
		`anything' `if' `in', cluster(`cluster') `robust'
		testparm `testvars'
		global k = r(df)
		gen `touse' = e(sample)
		mata B = st_matrix("e(b)"); V = st_matrix("e(V)"); V = sqrt(diagonal(V)); BB = B[1,1..$k]',V[1..$k,1]; st_matrix("B",BB)
		}
	if ("`by'" ~= "") {
		gettoken cmd anything: anything
		gettoken dep anything: anything
		`cmd' `dep', by(`by') `unequal'
		mata BB = (`r(mu_2)'-`r(mu_1)',`r(se)'); st_matrix("B",BB)
		gen `touse' = (`dep' ~= .)
		global k = 1
		}
preserve
	keep if `touse'
	if ("$cluster" ~= "") egen M = group($cluster)
	if ("$cluster" == "") gen M = _n
	quietly sum M
	global N = r(max)
	mata ResB = J($N,$k,.); ResSE = J($N,$k,.); ResF = J($N,3,.)
	forvalues i = 1/$N {
		if (floor(`i'/50) == `i'/50) display "`i'", _continue
		if ("`by'" == "") {
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
		if ("`by'" ~= "") {
			quietly `cmd' `dep' if M ~= `i', by(`by') `unequal'
			mata BB = (`r(mu_2)'-`r(mu_1)',`r(se)'); ResB[`i',1] = BB[1,1]; ResSE[`i',1] = BB[1,2]
			mata ResF[`i',1..3] = Ftail(1,`r(df_t)',(BB[1,1]/BB[1,2])^2), 0, `r(df_t)'
			}
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

global cluster = "randset"

global i = 1
global j = 1

use DatHS1, clear

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


use ip\JK1, clear
forvalues i = 2/20 {
	merge using ip\JK`i'
	tab _m
	drop _m
	}
quietly sum B1
global k = r(N)
mkmat B1 SE1 in 1/$k, matrix(B)
forvalues i = 2/20 {
	quietly sum B`i'
	global k = r(N)
	mkmat B`i' SE`i' in 1/$k, matrix(BB)
	matrix B = B \ BB
	}
drop B* SE*
svmat double B
aorder
save results\JackKnifeAHS, replace


