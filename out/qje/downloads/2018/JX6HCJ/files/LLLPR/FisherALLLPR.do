
*randomizing & clustering at treatment level



****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, absorb(string) cluster(string) ]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	`anything' `if' `in', absorb(`absorb') cluster(`cluster')
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
	syntax anything [if] [in] [, absorb(string) cluster(string) ]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	quietly `anything' `if' `in', absorb(`absorb') cluster(`cluster')
	capture testparm `testvars'
	if (_rc == 0) {
		matrix FF[$i,1] = r(p), r(drop), e(df_r)
		local i = 0
		foreach var in `testvars' {
			matrix BB[$j+`i',1] = _b[`var'], _se[`var']
			local i = `i' + 1
			}
		}
global i = $i + 1
global j = $j + $k
end

****************************************
****************************************

use DatLLLPR.dta, clear

egen cluster = group(month date id), label

matrix F = J(6,4,.)
matrix B = J(16,2,.)

global i = 1
global j = 1

*Table 3 
mycmd (small_gift large_gift) areg donation small_gift large_gift warm_list, absorb(id) cluster(cluster)
mycmd (small_gift large_gift warm_small warm_large) areg donation small_gift large_gift warm_small warm_large warm_list, absorb(id) cluster(cluster)
mycmd (small_gift large_gift) areg donation small_gift large_gift warm_pVCM warm_pLotto, absorb(id) cluster(cluster)
	
*Table 4 
mycmd (small_gift large_gift) areg give small_gift large_gift warm_list, absorb(id) cluster(cluster)
mycmd (small_gift large_gift warm_small warm_large) areg give small_gift large_gift warm_small warm_large warm_list, absorb(id) cluster(cluster)
mycmd (small_gift large_gift) areg give small_gift large_gift warm_pVCM warm_pLotto, absorb(id) cluster(cluster)
	
*treatments do not vary within clusters
bysort cluster: gen N = _n
sort N cluster
global N = 83
mata Y = st_data((1,$N),("large_gift","small_gift"))
generate Order = _n
generate double U = .

mata ResF = J($reps,6,.); ResD = J($reps,6,.); ResDF = J($reps,6,.); ResB = J($reps,16,.); ResSE = J($reps,16,.)
forvalues c = 1/$reps {
	matrix FF = J(6,3,.)
	matrix BB = J(16,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort U in 1/$N
	mata st_store((1,$N),("large_gift","small_gift"),Y)
	sort cluster N
	foreach i in large_gift small_gift {
		quietly replace `i' = `i'[_n-1] if cluster == cluster[_n-1] & N > 1
		}
	quietly replace warm_small = warm_list*small_gift
	quietly replace warm_large = warm_list*large_gift

global i = 1
global j = 1

*Table 3 
mycmd1 (small_gift large_gift) areg donation small_gift large_gift warm_list, absorb(id) cluster(cluster)
mycmd1 (small_gift large_gift warm_small warm_large) areg donation small_gift large_gift warm_small warm_large warm_list, absorb(id) cluster(cluster)
mycmd1 (small_gift large_gift) areg donation small_gift large_gift warm_pVCM warm_pLotto, absorb(id) cluster(cluster)
	
*Table 4 
mycmd1 (small_gift large_gift) areg give small_gift large_gift warm_list, absorb(id) cluster(cluster)
mycmd1 (small_gift large_gift warm_small warm_large) areg give small_gift large_gift warm_small warm_large warm_list, absorb(id) cluster(cluster)
mycmd1 (small_gift large_gift) areg give small_gift large_gift warm_pVCM warm_pLotto, absorb(id) cluster(cluster)

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..6] = FF[.,1]'; ResD[`c',1..6] = FF[.,2]'; ResDF[`c',1..6] = FF[.,3]'
mata ResB[`c',1..16] = BB[.,1]'; ResSE[`c',1..16] = BB[.,2]'

}


drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/6 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/16 {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save results\FisherALLLPR, replace





