
capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust by(string) unequal]
	tempvar touse newcluster
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
	mata ResF = J($reps,4,.); ResB = J($reps,$k,.); ResSE = J($reps,$k,.)
	set seed 1
	forvalues i = 1/$reps {
		if (floor(`i'/50) == `i'/50) display "`i'", _continue
		preserve
			bsample if `touse', cluster($cluster) idcluster(`newcluster')
			if ("`by'" == "") {
				if ("`cluster'" ~= "") capture `anything', cluster(`newcluster') 
				if ("`cluster'" == "") capture `anything', 
				if (_rc == 0) {
					capture mata B = st_matrix("e(b)"); V = st_matrix("e(V)"); B = B[1,1..$k]; V = V[1..$k,1..$k]
					capture testparm `testvars'
					if (_rc == 0 & r(df) == $k) {
						mata t = (B-BB[1..$k,1]')*invsym(V)*(B'-BB[1..$k,1])
						if (e(df_r) == .) mata ResF[`i',1..3] = `r(p)', chi2tail($k,t[1,1]), $k - `r(df)'
						if (e(df_r) ~= .) mata ResF[`i',1...] = `r(p)', Ftail($k,`e(df_r)',t[1,1]/$k), $k - `r(df)', `e(df_r)'
						mata ResB[`i',1...] = B; ResSE[`i',1...] = sqrt(diagonal(V))'
						}
					}
				}
			if ("`by'" ~= "") {
				capture `cmd' `dep', by(`by') `unequal'
				if (_rc == 0) {
					mata B = (`r(mu_2)'-`r(mu_1)',`r(se)'); ResB[`i',1] = B[1,1]; ResSE[`i',1] = B[1,2]
					mata ResF[`i',1..4] = Ftail(1,`r(df_t)',(B[1,1]/B[1,2])^2), Ftail(1,`r(df_t)',((B[1,1]-BB[1,1])/B[1,2])^2), 0, `r(df_t)'
					}
				}
		restore
		}
	preserve
		quietly drop _all
		quietly set obs $reps
		quietly generate double ResF$i = .
		quietly generate double ResFF$i = .
		quietly generate double ResD$i = .
		quietly generate double ResDF$i = .
		global kk = $j + $k - 1
		forvalues i = $j/$kk {
			quietly generate double ResB`i' = .
			}
		forvalues i = $j/$kk {
			quietly generate double ResSE`i' = .
			}
		mata X = ResF, ResB, ResSE; st_store(.,.,X)
		quietly svmat double B
		quietly rename B2 SE$i
		capture rename B1 B$i
		save ip\BS$i, replace
		global i = $i + 1
		global j = $j + $k
	restore
end


*******************

global cluster = "id"

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




*****************************************




use ip\BS1, clear
forvalues i = 2/20 {
	merge using ip\BS`i'
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
save results\BootstrapHS, replace

