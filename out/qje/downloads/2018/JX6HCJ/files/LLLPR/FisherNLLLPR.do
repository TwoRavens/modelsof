
*randomizing at their assumed clustering level


****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, absorb(string) ]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	`anything' `if' `in', absorb(`absorb')
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
	syntax anything [if] [in] [, absorb(string) ]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	quietly `anything' `if' `in', absorb(`absorb')
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

*Treatment administered in blocks by solicitors, but authors don't cluster so as alternative randomize at obs level

use DatLLLPR.dta, clear

matrix F = J(6,4,.)
matrix B = J(16,2,.)

global i = 1
global j = 1

*Table 3 
mycmd (small_gift large_gift) areg donation small_gift large_gift warm_list, absorb(id)
mycmd (small_gift large_gift warm_small warm_large) areg donation small_gift large_gift warm_small warm_large warm_list, absorb(id)
mycmd (small_gift large_gift) areg donation small_gift large_gift warm_pVCM warm_pLotto, absorb(id)
	
*Table 4 
mycmd (small_gift large_gift) areg give small_gift large_gift warm_list, absorb(id)
mycmd (small_gift large_gift warm_small warm_large) areg give small_gift large_gift warm_small warm_large warm_list, absorb(id)
mycmd (small_gift large_gift) areg give small_gift large_gift warm_pVCM warm_pLotto, absorb(id)
	
gen Order = _n
mata Y = st_data(.,("large_gift","small_gift"))
generate double U = .

mata ResF = J($reps,6,.); ResD = J($reps,6,.); ResDF = J($reps,6,.); ResB = J($reps,16,.); ResSE = J($reps,16,.)
forvalues c = 1/$reps {
	matrix FF = J(6,3,.)
	matrix BB = J(16,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() 
	sort U 
	mata st_store(.,("large_gift","small_gift"),Y)
	quietly replace warm_small = warm_list*small_gift
	quietly replace warm_large = warm_list*large_gift

global i = 1
global j = 1

*Table 3 
mycmd1 (small_gift large_gift) areg donation small_gift large_gift warm_list, absorb(id)
mycmd1 (small_gift large_gift warm_small warm_large) areg donation small_gift large_gift warm_small warm_large warm_list, absorb(id)
mycmd1 (small_gift large_gift) areg donation small_gift large_gift warm_pVCM warm_pLotto, absorb(id)
	
*Table 4 
mycmd1 (small_gift large_gift) areg give small_gift large_gift warm_list, absorb(id)
mycmd1 (small_gift large_gift warm_small warm_large) areg give small_gift large_gift warm_small warm_large warm_list, absorb(id)
mycmd1 (small_gift large_gift) areg give small_gift large_gift warm_pVCM warm_pLotto, absorb(id)

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
save results\FisherLLLPR, replace





